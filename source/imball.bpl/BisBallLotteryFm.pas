unit BisBallLotteryFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Grids, DB,
  BisFm, BisSizeGrip, BisBallBarrelFrm,
  BisBallFirstRoundFrm, BisBallSecondRoundFrm, BisBallThirdRoundFrm, BisBallFourthRoundFrm,
  BisControls;

type
  TBisBallLotteryForm = class(TBisForm)
    PanelControls: TPanel;
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
    TabSheetFirstRound: TTabSheet;
    TabSheetSecondRound: TTabSheet;
    TabSheetThirdRound: TTabSheet;
    TabSheetFourthRound: TTabSheet;
    CheckBoxAutoCalc: TCheckBox;
    ButtonCalc: TButton;
    CheckBoxAutoMove: TCheckBox;
    TimerNext: TTimer;
    procedure ButtonTirageClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure CheckBoxAutoCalcClick(Sender: TObject);
    procedure ButtonCalcClick(Sender: TObject);
    procedure CheckBoxAutoMoveClick(Sender: TObject);
    procedure TimerNextTimer(Sender: TObject);
  private
    FSizeGrip: TBisSizeGrip;
    FTirageId: Variant;
    FTirageNum: String;
    FTirageDate: String;
    FFirstRoundFrame: TBisBallFirstRoundFrame;
    FSecondRoundFrame: TBisBallSecondRoundFrame;
    FThirdRoundFrame: TBisBallThirdRoundFrame;
    FFourthRoundFrame: TBisBallFourthRoundFrame;
    function GetFrame: TBisBallBarrelFrame;
    procedure SetDataBaseStatistics;
    procedure SetStatistics;
    procedure RefreshFrame;
    procedure FrameAction(Sender: TBisBallBarrelFrame; WithStat: Boolean);
    procedure FrameNext(Sender: TBisBallBarrelFrame);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

  TBisBallLotteryFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisBallLotteryForm: TBisBallLotteryForm;

implementation

uses FileCtrl, DateUtils,
     BisUtils, BisProvider, BisFilterGroups, BisConsts, BisLogger, BisDialogs,
     BisBallDataTiragesFm, BisBallConsts;

{$R *.dfm}

{ TBisBallLotteryFormIface }

constructor TBisBallLotteryFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisBallLotteryForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
  ShowType:=stMdiChild;
end;

{ TBisBallLotteryForm }

constructor TBisBallLotteryForm.Create(AOwner: TComponent);
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

  FFirstRoundFrame:=TBisBallFirstRoundFrame.Create(nil);
  FFirstRoundFrame.Parent:=TabSheetFirstRound;
  FFirstRoundFrame.Align:=alClient;
  FFirstRoundFrame.OnAction:=FrameAction;
  FFirstRoundFrame.OnNext:=FrameNext;

  FSecondRoundFrame:=TBisBallSecondRoundFrame.Create(nil);
  FSecondRoundFrame.Parent:=TabSheetSecondRound;
  FSecondRoundFrame.Align:=alClient;
  FSecondRoundFrame.OnAction:=FrameAction;
  FSecondRoundFrame.OnNext:=FrameNext;

  FThirdRoundFrame:=TBisBallThirdRoundFrame.Create(nil);
  FThirdRoundFrame.Parent:=TabSheetThirdRound;
  FThirdRoundFrame.Align:=alClient;
  FThirdRoundFrame.OnAction:=FrameAction;
  FThirdRoundFrame.OnNext:=FrameNext;

  FFourthRoundFrame:=TBisBallFourthRoundFrame.Create(nil);
  FFourthRoundFrame.Parent:=TabSheetFourthRound;
  FFourthRoundFrame.Align:=alClient;
  FFourthRoundFrame.OnAction:=FrameAction;
  FFourthRoundFrame.OnNext:=FrameNext;

  CheckBoxAutoCalc.Checked:=true;
  CheckBoxAutoCalcClick(nil);

  FTirageId:=Null;

  PageControl.TabIndex:=0;
  PageControl.Visible:=false;
end;

destructor TBisBallLotteryForm.Destroy;
begin
  FFourthRoundFrame.Free;
  FThirdRoundFrame.Free;  
  FSecondRoundFrame.Free;
  FFirstRoundFrame.Free;
  FSizeGrip.Free;
  inherited Destroy;
end;

function TBisBallLotteryForm.GetFrame: TBisBallBarrelFrame;
begin
  Result:=nil;
  case PageControl.TabIndex of
    0: Result:=FFirstRoundFrame;
    1: Result:=FSecondRoundFrame;
    2: Result:=FThirdRoundFrame;
    3: Result:=FFourthRoundFrame;
  end;
end;

procedure TBisBallLotteryForm.FrameAction(Sender: TBisBallBarrelFrame; WithStat: Boolean);
begin
end;

procedure TBisBallLotteryForm.TimerNextTimer(Sender: TObject);
var
  TabSheet: TTabSheet;
  Frame: TBisBallBarrelFrame; 
begin
  TimerNext.Enabled:=false;

  TabSheet:=nil;
  Frame:=GetFrame;
  if Frame=FFirstRoundFrame then
    TabSheet:=TabSheetSecondRound
  else if Frame=FSecondRoundFrame then
    TabSheet:=TabSheetThirdRound
  else if Frame=FThirdRoundFrame then
    TabSheet:=TabSheetFourthRound;

  if Assigned(TabSheet) then begin
    PageControl.OnChange:=nil;
    try
      PageControl.ActivePage:=TabSheet;
      PageControlChange(nil);
    finally
      PageControl.OnChange:=PageControlChange;
    end;
  end;

end;

procedure TBisBallLotteryForm.FrameNext(Sender: TBisBallBarrelFrame);
begin
  TimerNext.Enabled:=Assigned(Sender);
end;

procedure TBisBallLotteryForm.SetDataBaseStatistics;
var
  P: TBisProvider;
begin
  P:=TBisProvider.Create(nil);
  try
    P.WithWaitCursor:=true;
    P.ProviderName:='SET_STATISTICS';
    P.Execute;
  finally
    P.Free;
  end;
end;

procedure TBisBallLotteryForm.SetStatistics;
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
        AddInvisible('ALL_COUNT',ptOutput);
        AddInvisible('USED_COUNT',ptOutput);
        AddInvisible('NOT_USED_COUNT',ptOutput);
        AddInvisible('PRIZE_SUM',ptOutput);
        AddInvisible('JACKPOT_SUM',ptOutput);
        AddInvisible('SECOND_1_ROUND_SUM',ptOutput);
        AddInvisible('SECOND_2_ROUND_SUM',ptOutput);
        AddInvisible('SECOND_3_ROUND_SUM',ptOutput);
        AddInvisible('SECOND_4_ROUND_SUM',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        UsedCount:=P.Params.ParamByName('USED_COUNT').AsInteger;
        GeneralSum:=P.Params.ParamByName('PRIZE_SUM').AsExtended;
        JackpotSum:=P.Params.ParamByName('JACKPOT_SUM').AsExtended;

        FS.ThousandSeparator:=' ';
        FS.DecimalSeparator:=DecimalSeparator;
        FS.CurrencyFormat:=CurrencyFormat;
        FS.CurrencyDecimals:=CurrencyDecimals;
        FS.CurrencyString:=CurrencyString;

        EditUsedCount.Text:=FloatToStrF(UsedCount,ffNumber,15,0,FS);
        EditPrizeSum.Text:=FloatToStrF(GeneralSum,ffCurrency,15,2,FS);
        EditJackpotSum.Text:=FloatToStrF(JackpotSum,ffCurrency,15,2,FS);


        FFirstRoundFrame.RoundSum:=P.Params.ParamByName('SECOND_1_ROUND_SUM').AsExtended;
        FSecondRoundFrame.RoundSum:=P.Params.ParamByName('SECOND_2_ROUND_SUM').AsExtended;
        FThirdRoundFrame.RoundSum:=P.Params.ParamByName('SECOND_3_ROUND_SUM').AsExtended;
        FFourthRoundFrame.RoundSum:=P.Params.ParamByName('SECOND_4_ROUND_SUM').AsExtended;
      end;
    finally
      P.Free;
    end;
  end else begin
    EditUsedCount.Text:='';
    EditPrizeSum.Text:='';
    EditJackpotSum.Text:='';

    FFirstRoundFrame.RoundSum:=0.0;
    FSecondRoundFrame.RoundSum:=0.0;
    FThirdRoundFrame.RoundSum:=0.0;
    FFourthRoundFrame.RoundSum:=0.0;
  end;
end;

procedure TBisBallLotteryForm.RefreshFrame;
var
  Frame: TBisBallBarrelFrame;
begin
  Frame:=GetFrame;
  if Assigned(Frame) then begin
    Frame.TirageId:=FTirageId;
    Frame.Refresh;
  end;
end;

procedure TBisBallLotteryForm.ButtonCalcClick(Sender: TObject);
var
  Frame: TBisBallBarrelFrame;
begin
  Frame:=GetFrame;
  if Assigned(Frame) then
    Frame.SetStatistics(true);
end;

procedure TBisBallLotteryForm.ButtonTirageClick(Sender: TObject);
var
  Iface: TBisBallDataTiragesFormIface;
  P: TBisProvider;
begin
  Iface:=TBisBallDataTiragesFormIface.Create(nil);
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

        EditTirage.Text:=FormatEx('%s �� %s',
                                  [FTirageNum,
                                   P.FieldByName('EXECUTION_DATE').AsString]);

        SetDataBaseStatistics;
        SetStatistics;
        Update;
        RefreshFrame;
        PageControl.Visible:=true;
        PageControl.Width:=PageControl.Width+1;
        PageControl.Height:=PageControl.Height+1;
      end;
    end;
  finally
    P.Free;
    Iface.Free;
  end;
end;

procedure TBisBallLotteryForm.PageControlChange(Sender: TObject);
var
  Frame: TBisBallBarrelFrame;
begin
  Frame:=GetFrame;
  if Assigned(Frame) then begin
    PageControl.OnChange:=nil;
    Frame.AutoMove:=false;
    Frame.AutoCalc:=false;
    try
      Update;
      RefreshFrame;
    finally
      Frame.AutoCalc:=CheckBoxAutoCalc.Checked;
      Frame.AutoMove:=CheckBoxAutoMove.Checked;
      PageControl.OnChange:=PageControlChange;
    end;
  end;
end;

procedure TBisBallLotteryForm.CheckBoxAutoCalcClick(Sender: TObject);
begin
  FFirstRoundFrame.AutoCalc:=CheckBoxAutoCalc.Checked;
  FSecondRoundFrame.AutoCalc:=CheckBoxAutoCalc.Checked;
  FThirdRoundFrame.AutoCalc:=CheckBoxAutoCalc.Checked;
  FFourthRoundFrame.AutoCalc:=CheckBoxAutoCalc.Checked;
  ButtonCalc.Enabled:=not CheckBoxAutoCalc.Checked;
end;

procedure TBisBallLotteryForm.CheckBoxAutoMoveClick(Sender: TObject);
begin
  FFirstRoundFrame.AutoMove:=CheckBoxAutoMove.Checked;
  FSecondRoundFrame.AutoMove:=CheckBoxAutoMove.Checked;
  FThirdRoundFrame.AutoMove:=CheckBoxAutoMove.Checked;
  FFourthRoundFrame.AutoMove:=CheckBoxAutoMove.Checked;
end;

end.
