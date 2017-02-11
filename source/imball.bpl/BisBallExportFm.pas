unit BisBallExportFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB,
  BisFm, BisSizeGrip, BisDialogFm;

type
  TBisBallExportForm = class(TBisForm)
    GroupBoxChoice: TGroupBox;
    RadioButtonLottery: TRadioButton;
    RadioButtonTicketsOn: TRadioButton;
    RadioButtonTicketsOff: TRadioButton;
    LabelTirage: TLabel;
    EditTirage: TEdit;
    ButtonTirage: TButton;
    LabelCounter: TLabel;
    ProgressBar: TProgressBar;
    ButtonExport: TButton;
    LabelFile: TLabel;
    EditFile: TEdit;
    ButtonFile: TButton;
    SaveDialog: TSaveDialog;
    procedure ButtonTirageClick(Sender: TObject);
    procedure ButtonFileClick(Sender: TObject);
    procedure ButtonExportClick(Sender: TObject);
  private
    FTirageId: Variant;
    FTirageNum: String;
    FTicketCount: Integer;
    FUsedCount: Integer;
    FNotUsedCount: Integer;
    FPrizeSum: Extended;
    FJackpotSum: Extended;
    FSecond1Sum: Extended;
    FSecond2Sum: Extended;
    FSecond3Sum: Extended;
    FSecond4Sum: Extended;
    FExecutionDate: String;
    FSizeGrip: TBisSizeGrip;
    function CheckFields: Boolean;
    procedure Export;
    procedure SetStatistics;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

  TBisBallExportFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisBallExportForm: TBisBallExportForm;

implementation

uses Math,
     ALXmlDoc,
     BisUtils, BisProvider, BisFilterGroups, BisDialogs, BisLogger,
     BisBallDataTiragesFm;

{$R *.dfm}

{ TBisBallExportFormIface }

constructor TBisBallExportFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisBallExportForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
  ShowType:=stMdiChild;
end;

{ TBisBallExportForm }

constructor TBisBallExportForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;

  FSizeGrip:=TBisSizeGrip.Create(nil);
  FSizeGrip.Parent:=Self;

  FTirageId:=Null;
end;

destructor TBisBallExportForm.Destroy;
begin
  FSizeGrip.Free;
  inherited Destroy;
end;

procedure TBisBallExportForm.ButtonFileClick(Sender: TObject);
begin
  if SaveDialog.Execute then begin
    EditFile.Text:=SaveDialog.FileName;
  end;
end;

procedure TBisBallExportForm.ButtonTirageClick(Sender: TObject);
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
        FExecutionDate:=P.FieldByName('EXECUTION_DATE').AsString;
        EditTirage.Text:=FormatEx('%s �� %s',
                                  [FTirageNum,
                                   FExecutionDate]);
        SetStatistics;                                   
      end;
    end;
  finally
    P.Free;
    Iface.Free;
  end;
end;

procedure TBisBallExportForm.ButtonExportClick(Sender: TObject);
begin
  Export;
end;

function TBisBallExportForm.CheckFields: Boolean;
begin
  Result:=false;

  if (Trim(EditTirage.Text)='') or VarIsNull(FTirageId) then begin
    ShowError('�������� �����.');
    EditTirage.SetFocus;
    exit;
  end;

  if Trim(EditFile.Text)='' then begin
    ShowError('�������� ����.');
    EditFile.SetFocus;
    exit;
  end;

  Result:=true;
end;

procedure TBisBallExportForm.Export;
var
  AllCount: Integer;
  
  procedure ExportLottery(FileName: String);
  var
    PLottery: TBisProvider;
    PProtocol: TBisProvider;

    procedure GetLottery(RoundNum: Integer; LotteryNode: TALXMLNode);
    var
      BarrelNode: TALXMLNode;
      S: String;
    begin
      if PLottery.Active then begin
        PLottery.Filtered:=false;
        PLottery.Filter:='ROUND_NUM='+IntToStr(RoundNum);
        PLottery.Filtered:=true;
        PLottery.First;
        while not PLottery.Eof do begin
          BarrelNode:=LotteryNode.AddChild('barrel');
          S:=PLottery.FieldByName('SUBROUND_NAME').AsString;
          if Trim(S)<>'' then
            BarrelNode.Attributes['subround']:=S;
          BarrelNode.Attributes['num']:=PLottery.FieldByName('BARREL_NUM').AsString;
          PLottery.Next;
        end;
      end;
    end;

    procedure GetWinnings(RoundNum: Integer; WinningsNode: TALXMLNode);
    var
      TicketNode: TALXMLNode;
      S: String;
    begin
      if PProtocol.Active then begin
        PProtocol.Filtered:=false;
        PProtocol.Filter:='ROUND_NUM='+IntToStr(RoundNum);
        PProtocol.Filtered:=true;
        PProtocol.First;
        while not PProtocol.Eof do begin
          TicketNode:=WinningsNode.AddChild('ticket');
          S:=PProtocol.FieldByName('SUBROUND_NAME').AsString;
          if Trim(S)<>'' then
            TicketNode.Attributes['subround']:=S;
          TicketNode.Attributes['num']:=PProtocol.FieldByName('NUM').AsString;
          TicketNode.Attributes['series']:=PProtocol.FieldByName('SERIES').AsString;
          TicketNode.Attributes['prize']:=PProtocol.FieldByName('PRIZE_NAME').AsString;
          TicketNode.Attributes['sum']:=FormatFloat('0.00',PProtocol.FieldByName('PRIZE_COST').AsFloat);
          PProtocol.Next;
        end;
      end;
    end;

  var
    i: Integer;
    S: String;
    Xml: TALXMLDocument;
    TirageNode: TALXMLNode;
    RoundNode: TALXMLNode;
    LotteryNode: TALXMLNode;
    WinningsNode: TALXMLNode;
    PrizeSum: Extended;
  begin
    PLottery:=TBisProvider.Create(nil);
    PProtocol:=TBisProvider.Create(nil);
    Xml:=TALXMLDocument.Create(nil);
    try
      Xml.Options:=Xml.Options+[doNodeAutoIndent];
      Xml.Active:=true;
      Xml.Version:='1.0';
      Xml.Encoding:='windows-1251';
      Xml.StandAlone:='yes';

      TirageNode:=Xml.AddChild('tirage');
      TirageNode.Attributes['num']:=FTirageNum;
      TirageNode.Attributes['date']:=FExecutionDate;
      TirageNode.Attributes['all_count']:=FTicketCount;
      TirageNode.Attributes['used_count']:=FUsedCount;
      TirageNode.Attributes['prize_sum']:=FormatFloat('0.00',FPrizeSum);
      TirageNode.Attributes['jackpot_sum']:=FormatFloat('0.00',FJackpotSum);

      PLottery.WithWaitCursor:=false;
      PLottery.ProviderName:='S_LOTTERY';
      with PLottery.FieldNames do begin
        Add('ROUND_NUM');
        Add('SUBROUND_NAME');
        Add('BARREL_NUM');
      end;
      PLottery.FilterGroups.Add.Filters.Add('TIRAGE_ID',fcEqual,FTirageId).CheckCase:=true;
      with PLottery.Orders do begin
        Add('ROUND_NUM');
        Add('SUBROUND_PRIORITY');
        Add('PRIORITY');
      end;
      PLottery.Open;

      PProtocol.WithWaitCursor:=false;
      PProtocol.ProviderName:='GET_PROTOCOL';
      with PProtocol.FieldNames do begin
        Add('ROUND_NUM');
        Add('SUBROUND_NAME');
        Add('NUM');
        Add('SERIES');
        Add('PRIZE_NAME');
        Add('PRIZE_COST');
      end;
      PProtocol.Params.AddInvisible('TIRAGE_ID').Value:=FTirageId;
      PProtocol.OpenWithExecute;

      ProgressBar.Max:=4;
      if PLottery.Active and PProtocol.Active then begin
        for i:=1 to 4 do begin
          S:='none';
          PrizeSum:=0.0;
          case i of
            1: begin
              S:='first';
              PrizeSum:=FSecond1Sum;
            end;
            2: begin
              S:='second';
              PrizeSum:=FSecond2Sum;
            end;
            3: begin
              S:='third';
              PrizeSum:=FSecond3Sum;
            end;
            4: begin
              S:='fourth';
              PrizeSum:=FSecond4Sum;
            end;
          end;
          RoundNode:=TirageNode.AddChild(S);
          RoundNode.Attributes['prize_sum']:=FormatFloat('0.00',PrizeSum);

          LotteryNode:=RoundNode.AddChild('lottery');
          GetLottery(i,LotteryNode);
          WinningsNode:=RoundNode.AddChild('winnings');
          GetWinnings(i,WinningsNode);

          Inc(AllCount);
          LabelCounter.Caption:=Format('�������������� %d �� %d �������',[AllCount,ProgressBar.Max]);
          LabelCounter.Update;
          ProgressBar.Position:=AllCount;
          ProgressBar.Update;
          Sleep(1);
          Application.ProcessMessages;

        end;
      end;

      Xml.SaveToFile(FileName);
    finally
      Xml.Free;
      PProtocol.Free;
      PLottery.Free;
    end;
  end;


  procedure ExportTickets(FileName: String; Used: Boolean);
  var
    P: TBisProvider;
    Xml: TALXMLDocument;
    TirageNode: TALXMLNode;
    TicketNode: TALXMLNode;
  begin
    P:=TBisProvider.Create(nil);
    Xml:=TALXMLDocument.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='S_TICKETS';
      with P.FieldNames do begin
        Add('NUM');
        Add('SERIES');
        Add('USED')
      end;
      with P.FilterGroups.Add do begin
        Filters.Add('TIRAGE_ID',fcEqual,FTirageId).CheckCase:=true;
        Filters.Add('USED',fcEqual,Integer(Used));
      end;
      P.Open;
      if P.Active then begin
        Xml.Options:=Xml.Options+[doNodeAutoIndent];
        Xml.Active:=true;
        Xml.Version:='1.0';
        Xml.Encoding:='windows-1251';
        Xml.StandAlone:='yes';

        TirageNode:=Xml.AddChild('tirage');
        TirageNode.Attributes['num']:=FTirageNum;
        TirageNode.Attributes['date']:=FExecutionDate;
        TirageNode.Attributes['count']:=P.RecordCount;

        ProgressBar.Max:=P.RecordCount;
        P.First;
        while not P.Eof do begin
          TicketNode:=TirageNode.AddChild('ticket');
          TicketNode.Attributes['num']:=P.FieldByName('NUM').AsString;
          TicketNode.Attributes['series']:=P.FieldByName('SERIES').AsString;
          TicketNode.Attributes['used']:=P.FieldByName('USED').AsString;
          Inc(AllCount);
          LabelCounter.Caption:=Format('�������������� %d �� %d �������',[AllCount,ProgressBar.Max]);
          LabelCounter.Update;
          ProgressBar.Position:=AllCount;
          ProgressBar.Update;
          Sleep(1);
          Application.ProcessMessages;
          P.Next;
        end;
        Xml.SaveToFile(FileName);
      end;
    finally
      Xml.Free;
      P.Free;
    end;
  end;

var
  S: String;
  OldCursor: TCursor;
begin
  if CheckFields then begin
    try
      EnableControls(false);
      OldCursor:=Screen.Cursor;
      ProgressBar.Position:=0;
      try
        Screen.Cursor:=crHourGlass;
        AllCount:=0;
        Update;
        
        S:=Trim(EditFile.Text);

        if RadioButtonLottery.Checked then
          ExportLottery(S);

        if RadioButtonTicketsOn.Checked then
          ExportTickets(S,true);

        if RadioButtonTicketsOff.Checked then
          ExportTickets(S,false);
        
      finally
        ProgressBar.Position:=0;
        Screen.Cursor:=OldCursor;
        EnableControls(true);
      end;

      if not  RadioButtonLottery.Checked then
        ShowInfo(FormatEx('�������������� %d �������.',[AllCount]));
    except
      On E: Exception do begin
        LoggerWrite(E.Message,ltError);
        ShowError(E.Message);
      end;
    end;
  end;
end;

procedure TBisBallExportForm.SetStatistics;
var
  P: TBisProvider;
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
        FTicketCount:=P.Params.ParamByName('ALL_COUNT').AsInteger;
        FUsedCount:=P.Params.ParamByName('USED_COUNT').AsInteger;
        FNotUsedCount:=P.Params.ParamByName('NOT_USED_COUNT').AsInteger;
        FPrizeSum:=P.Params.ParamByName('PRIZE_SUM').AsExtended;
        FJackpotSum:=P.Params.ParamByName('JACKPOT_SUM').AsExtended;
        FSecond1Sum:=P.Params.ParamByName('SECOND_1_ROUND_SUM').AsExtended;
        FSecond2Sum:=P.Params.ParamByName('SECOND_2_ROUND_SUM').AsExtended;
        FSecond3Sum:=P.Params.ParamByName('SECOND_3_ROUND_SUM').AsExtended;
        FSecond4Sum:=P.Params.ParamByName('SECOND_4_ROUND_SUM').AsExtended;
      end;
    finally
      P.Free;
    end;
  end else begin
    FTicketCount:=0;
    FUsedCount:=0;
    FNotUsedCount:=0;
  end;
end;

end.
