unit BisLotoLotteryFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Grids, DB,
  BisFm, BisSizeGrip, BisLotoBarrelFrm, 
  BisLotoRound1Frm, BisLotoRound2Frm, BisLotoRound3Frm, BisLotoRound4Frm,
  BisControls;

type
  TBisLotoLotteryForm = class(TBisForm)
    PanelControls: TPanel;
    GroupBoxOutput: TGroupBox;
    CheckBoxOutput: TCheckBox;
    PanelOutput: TPanel;
    LabelDir: TLabel;
    EditDir: TEdit;
    ButtonDir: TButton;
    GroupBoxGeneral: TGroupBox;
    LabelUsedCount: TLabel;
    EditUsedCount: TEdit;
    LabelTirage: TLabel;
    EditTirage: TEdit;
    ButtonTirage: TButton;
    LabelPrizeSum: TLabel;
    LabelJackpotSum: TLabel;
    EditPrizeSum: TEdit;
    EditJackpotSum: TEdit;
    GroupBoxRounds: TGroupBox;
    PanelRounds: TPanel;
    PageControl: TPageControl;
    TabSheetRound1: TTabSheet;
    TabSheetRound2: TTabSheet;
    TabSheetRound3: TTabSheet;
    TabSheetRound4: TTabSheet;
    ButtonOutputRefresh: TButton;
    procedure ButtonDirClick(Sender: TObject);
    procedure CheckBoxOutputClick(Sender: TObject);
    procedure ButtonTirageClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure ButtonOutputRefreshClick(Sender: TObject);
  private
    FSizeGrip: TBisSizeGrip;
    FTirageId: Variant;
    FTirageNum: String;
    FTirageDate: String;
    FFirstRoundSum: Extended;
    FSecondRoundSum: Extended;
    FThirdRoundSum: Extended;
    FFourthRoundSum: Extended;
    FRound1Frame: TBisLotoRound1Frame;
    FRound2Frame: TBisLotoRound2Frame;
    FRound3Frame: TBisLotoRound3Frame;
    FRound4Frame: TBisLotoRound4Frame;
    FTicketCountSuffix: String;
    FPrizeSumSuffix: String;
    FJackpotSumSuffix: String;
    function GetFrame: TBisLotoBarrelFrame;
    procedure SetStatistics;
    procedure RefreshFrame;
    procedure Output(WithStat: Boolean);
    procedure RoundFrameAction(Sender: TBisLotoBarrelFrame; WithStat: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

  TBisLotoLotteryFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisLotoLotteryForm: TBisLotoLotteryForm;

implementation

uses FileCtrl, DateUtils,
     BisUtils, BisProvider, BisFilterGroups, BisConsts, BisLogger, BisDialogs,
     BisLotoDataTiragesFm, BisLotoConsts;

{$R *.dfm}

{ TBisLotoLotteryFormIface }

constructor TBisLotoLotteryFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisLotoLotteryForm;
  Available:=true;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
end;

{ TBisLotoLotteryForm }

constructor TBisLotoLotteryForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  SizesStored:=true;

  EditTirage.Color:=ColorControlReadOnly;
  EditJackpotSum.Color:=ColorControlReadOnly;
  EditUsedCount.Color:=ColorControlReadOnly;
  EditPrizeSum.Color:=ColorControlReadOnly;

  EditUsedCount.Alignment:=taRightJustify;
  EditPrizeSum.Alignment:=taRightJustify;
  EditJackpotSum.Alignment:=taRightJustify;

  FSizeGrip:=TBisSizeGrip.Create(nil);
  FSizeGrip.Parent:=PanelControls;

  FRound1Frame:=TBisLotoRound1Frame.Create(nil);
  FRound1Frame.Parent:=TabSheetRound1;
  FRound1Frame.Align:=alClient;
  FRound1Frame.OnAction:=RoundFrameAction;

  FRound2Frame:=TBisLotoRound2Frame.Create(nil);
  FRound2Frame.Parent:=TabSheetRound2;
  FRound2Frame.Align:=alClient;
  FRound2Frame.OnAction:=RoundFrameAction;

  FRound3Frame:=TBisLotoRound3Frame.Create(nil);
  FRound3Frame.Parent:=TabSheetRound3;
  FRound3Frame.Align:=alClient;
  FRound3Frame.OnAction:=RoundFrameAction;

  FRound4Frame:=TBisLotoRound4Frame.Create(nil);
  FRound4Frame.Parent:=TabSheetRound4;
  FRound4Frame.Align:=alClient;
  FRound4Frame.OnAction:=RoundFrameAction;

  FTirageId:=Null;

  PageControl.Visible:=false;

  FTicketCountSuffix:=ConfigRead('TicketCountSuffix',FTicketCountSuffix);
  FPrizeSumSuffix:=ConfigRead('PrizeSumSuffix',FPrizeSumSuffix);
  FJackpotSumSuffix:=ConfigRead('JackpotSumSuffix',FJackpotSumSuffix);

  CheckBoxOutput.OnClick:=nil;
  CheckBoxOutput.Checked:=ProfileRead(CheckBoxOutput.Name,CheckBoxOutput.Checked);
  CheckBoxOutput.OnClick:=CheckBoxOutputClick;
  EditDir.Text:=ProfileRead(EditDir.Name,EditDir.Text);

  CheckBoxOutputClick(nil);
end;

destructor TBisLotoLotteryForm.Destroy;
begin
  ProfileWrite(CheckBoxOutput.Name,CheckBoxOutput.Checked);
  ProfileWrite(EditDir.Name,EditDir.Text);
  FRound4Frame.Free;
  FRound3Frame.Free;
  FRound2Frame.Free;
  FRound1Frame.Free;
  FSizeGrip.Free;
  inherited Destroy;
end;

function TBisLotoLotteryForm.GetFrame: TBisLotoBarrelFrame;
begin
  Result:=nil;
  case PageControl.TabIndex of
    0: Result:=FRound1Frame;
    1: Result:=FRound2Frame;
    2: Result:=FRound3Frame;
    3: Result:=FRound4Frame;
  end;
end;

procedure TBisLotoLotteryForm.RoundFrameAction(Sender: TBisLotoBarrelFrame; WithStat: Boolean);
begin
  Output(WithStat);
end;

procedure TBisLotoLotteryForm.SetStatistics;
var
  P: TBisProvider;
  UsedCount: Integer;
  GeneralSum: Extended;
  JackpotSum: Extended;
  FS: TFormatSettings;
begin
  if not VarIsNull(FTirageId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=true;
      P.ProviderName:='GET_LOTTERY_STATISTICS';
      with P.Params do begin
        AddInvisible('TIRAGE_ID').Value:=FTirageId;
        AddInvisible('USED_COUNT',ptOutput);
        AddInvisible('PRIZE_SUM',ptOutput);
        AddInvisible('JACKPOT_SUM',ptOutput);

        AddInvisible('FIRST_ROUND_SUM',ptOutput);
        AddInvisible('SECOND_ROUND_SUM',ptOutput);
        AddInvisible('THIRD_ROUND_SUM',ptOutput);
        AddInvisible('FOURTH_ROUND_SUM',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        UsedCount:=P.Params.ParamByName('USED_COUNT').AsInteger;
        GeneralSum:=P.Params.ParamByName('PRIZE_SUM').AsExtended;
        JackpotSum:=P.Params.ParamByName('JACKPOT_SUM').AsExtended;

{        EditUsedCount.Text:=IntToStr(UsedCount);
        EditPrizeSum.Text:=FormatFloat('#0',GeneralSum);
        EditJackpotSum.Text:=FormatFloat('#0',JackpotSum);}
        FS.ThousandSeparator:=' '; 
        EditUsedCount.Text:=FloatToStrF(UsedCount,ffNumber,15,0,FS);
        EditPrizeSum.Text:=FloatToStrF(GeneralSum,ffNumber,15,0,FS);
        EditJackpotSum.Text:=FloatToStrF(JackpotSum,ffNumber,15,0,FS);

        FFirstRoundSum:=P.Params.ParamByName('FIRST_ROUND_SUM').AsExtended;
        FSecondRoundSum:=P.Params.ParamByName('SECOND_ROUND_SUM').AsExtended;
        FThirdRoundSum:=P.Params.ParamByName('THIRD_ROUND_SUM').AsExtended;
        FFourthRoundSum:=P.Params.ParamByName('FOURTH_ROUND_SUM').AsExtended;
      end;
    finally
      P.Free;
    end;
  end else begin
    EditUsedCount.Text:='';
    EditPrizeSum.Text:='';
    EditJackpotSum.Text:='';

    FFirstRoundSum:=0.0;
    FSecondRoundSum:=0.0;
    FThirdRoundSum:=0.0;
    FFourthRoundSum:=0.0;
  end;
end;

procedure TBisLotoLotteryForm.ButtonDirClick(Sender: TObject);
var
  S: String;
begin
  S:=Trim(EditDir.Text);
  if SelectDirectory('Выберите директорию для вывода','',S,
                     [sdNewFolder,sdShowEdit,sdShowShares,sdNewUI,sdValidateDir],Self) then begin
    EditDir.Text:=Trim(S);
  end;
end;

procedure TBisLotoLotteryForm.RefreshFrame;
var
  Frame: TBisLotoBarrelFrame;
begin
  Frame:=GetFrame;
  if Assigned(Frame) then begin
    Frame.TirageId:=FTirageId;
    case Frame.RoundNum of
      1: Frame.RoundSum:=FFirstRoundSum;
      2: Frame.RoundSum:=FSecondRoundSum;
      3: Frame.RoundSum:=FThirdRoundSum;
      4: Frame.RoundSum:=FFourthRoundSum;
    end;
    Frame.Refresh;
  end;
end;

procedure TBisLotoLotteryForm.ButtonOutputRefreshClick(Sender: TObject);
begin
  Output(true);
end;

procedure TBisLotoLotteryForm.ButtonTirageClick(Sender: TObject);
var
  Iface: TBisLotoDataTiragesFormIface;
  P: TBisProvider;
begin
  Iface:=TBisLotoDataTiragesFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    Iface.Init;
    with Iface.FilterGroups.Add do begin
      Filters.Add('PREPARATION_DATE',fcIsNotNull,Null);
    end;
    Iface.LocateFields:='TIRAGE_ID';
    Iface.LocateValues:=FTirageId;
    if Iface.SelectInto(P) then begin
      if P.Active then begin
        FTirageId:=P.FieldByName('TIRAGE_ID').Value;
        FTirageNum:=P.FieldByName('NUM').AsString;
        FTirageDate:=DateToStr(DateOf(P.FieldByName('EXECUTION_DATE').AsDateTime));

        EditTirage.Text:=FormatEx('%s от %s',
                                  [FTirageNum,
                                   P.FieldByName('EXECUTION_DATE').AsString]);

        SetStatistics;
        Update;
        RefreshFrame;
        PageControl.Visible:=true;
        PageControl.Width:=PageControl.Width+1;
        PageControl.Height:=PageControl.Height+1;
        TabSheetRound4.TabVisible:=FFourthRoundSum<>0.0;
        Output(true);
      end;
    end;
  finally
    P.Free;
    Iface.Free;
  end;
end;

procedure TBisLotoLotteryForm.CheckBoxOutputClick(Sender: TObject);
begin
  EnableControl(PanelOutput,CheckBoxOutput.Checked);
end;

procedure TBisLotoLotteryForm.PageControlChange(Sender: TObject);
begin
  Update;
  RefreshFrame;
  Output(true);
end;

procedure TBisLotoLotteryForm.Output(WithStat: Boolean);
var
  Dir: String;

  procedure LocalOutput;
  var
    Frame: TBisLotoBarrelFrame;
    Str: TStringList;
    FileStream: TFileStream;
    FileName: String;
  begin
    Frame:=GetFrame;
    if Assigned(Frame) then begin
      Str:=TStringList.Create;
      try
        Str.Add(FTirageNum);
        Str.Add('');
        Str.Add(EditUsedCount.Text+iff(Trim(FTicketCountSuffix)<>'',' '+FTicketCountSuffix,''));
        Str.Add('');
        Str.Add(EditPrizeSum.Text+iff(Trim(FPrizeSumSuffix)<>'',' '+FPrizeSumSuffix,''));
        Str.Add('');
        Str.Add(EditJackpotSum.Text+iff(Trim(FJackpotSumSuffix)<>'',' '+FJackpotSumSuffix,''));
        Str.Add('');
        Str.Add(IntToStr(Frame.RoundNum));
        Str.Add('');
        if WithStat then
          Str.Add(Frame.PrizeSumString)
        else
          Str.Add(SUnknownValue);
        Str.Add('');
        if WithStat then
          Str.Add(Frame.TicketCountString)
        else
          Str.Add(SUnknownValue);
        Str.Add('');
        if WithStat then
          Str.Add(Frame.TicketSumString)
        else
          Str.Add(SUnknownValue);
        Str.Add('');
        Str.Add(Frame.LastBarrelNum);
        Str.Add('');
        Str.Add(Frame.BarrelNums);
        Str.Add('');
        Str.Add(Frame.PrizeName);

        FileName:=IncludeTrailingPathDelimiter(Dir)+'general.txt';

        FileStream:=TFileStream.Create(FileName,fmCreate);
        FileStream.Free;

        FileStream:=nil;
        try
          FileStream:=TFileStream.Create(FileName,fmOpenWrite or fmShareDenyNone);
          FileStream.Position:=0;

          StringsSpecialSaveToStream(Str,FileStream);

        finally
          if Assigned(FileStream) then
            FileStream.Free;
        end;

      finally
        Str.Free;
      end;
    end;
  end;

begin
  if not VarIsNull(FTirageId) and CheckBoxOutput.Checked then begin
    Dir:=Trim(EditDir.Text);
    if DirectoryExists(Dir) then begin
      try
        LocalOutput;
      except
        On E: Exception do begin
          LoggerWrite(E.Message,ltError);
          ShowError(E.Message);
        end;
      end;
    end;
  end;
end;

end.
