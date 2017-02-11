unit BisBallManageTicketFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, DB, Mask,
  XComDrv,
  BisFm, BisSizeGrip, BisProvider, BisControls;

type

  TBisCustomComm=class(TCustomComm)
  end;

  TBisBallManageTicketForm = class(TBisForm)
    PanelControls: TPanel;
    GroupBoxSearch: TGroupBox;
    LabelSearchNum: TLabel;
    EditSearchNum: TMaskEdit;
    ButtonSearch: TButton;
    GroupBoxTicket: TGroupBox;
    LabelTirage: TLabel;
    EditTirage: TEdit;
    ButtonTirage: TButton;
    GroupBoxAction: TGroupBox;
    CheckBoxScanner: TCheckBox;
    PanelTicket: TPanel;
    PageControlTicket: TPageControl;
    TabSheetNone: TTabSheet;
    TabSheetTicket: TTabSheet;
    LabelSeries: TLabel;
    EditSeries: TEdit;
    LabelTicketNone: TLabel;
    GroupBoxStatistics: TGroupBox;
    LabelTicketCount: TLabel;
    LabelTicketManageCount: TLabel;
    LabelTicketUsedCount: TLabel;
    LabelTicketNotUsedCount: TLabel;
    CheckBoxAction: TCheckBox;
    PanelAction: TPanel;
    RadioButtonAutoExclude: TRadioButton;
    RadioButtonAutoInclude: TRadioButton;
    CheckBoxInLottery: TCheckBox;
    LabelSurname: TLabel;
    EditSurname: TEdit;
    LabelName: TLabel;
    EditName: TEdit;
    LabelPatronymic: TLabel;
    EditPatronymic: TEdit;
    LabelAddress: TLabel;
    EditAddress: TEdit;
    LabelPhone: TLabel;
    EditPhone: TEdit;
    EditNum: TEdit;
    LabelNum: TLabel;
    LabelOwner: TLabel;
    BevelOwner: TBevel;
    ButtonChange: TButton;
    LabelTicketCounter: TLabel;
    LabelTicketManageCounter: TLabel;
    LabelTicketNotUsedCounter: TLabel;
    LabelTicketUsedCounter: TLabel;
    LabelFirst: TLabel;
    BevelFirst: TBevel;
    BevelSecond: TBevel;
    LabelSecond: TLabel;
    ShapeFirst: TShape;
    ShapeSecond: TShape;
    LabelDealer: TLabel;
    EditDealer: TEdit;
    LabelFirstPrize1: TLabel;
    EditFirstPrize1: TEdit;
    LabelFirstMoney1: TLabel;
    EditFirstMoney1: TEdit;
    LabelFirstCode: TLabel;
    EditFirstCode: TEdit;
    ShapeSecond1: TShape;
    EditSecond11: TEdit;
    EditSecond12: TEdit;
    EditSecond13: TEdit;
    EditSecond14: TEdit;
    EditSecond15: TEdit;
    ShapeSecond2: TShape;
    EditSecond21: TEdit;
    EditSecond22: TEdit;
    EditSecond23: TEdit;
    EditSecond24: TEdit;
    EditSecond25: TEdit;
    ShapeSecond3: TShape;
    EditSecond31: TEdit;
    EditSecond32: TEdit;
    EditSecond33: TEdit;
    EditSecond34: TEdit;
    EditSecond35: TEdit;
    ShapeSecond4: TShape;
    EditSecond41: TEdit;
    EditSecond42: TEdit;
    EditSecond43: TEdit;
    EditSecond44: TEdit;
    EditSecond45: TEdit;
    ShapeSecond5: TShape;
    EditSecond51: TEdit;
    EditSecond52: TEdit;
    EditSecond53: TEdit;
    EditSecond54: TEdit;
    EditSecond55: TEdit;
    ShapeSecond6: TShape;
    EditSecond61: TEdit;
    EditSecond62: TEdit;
    EditSecond63: TEdit;
    EditSecond64: TEdit;
    EditSecond65: TEdit;
    LabelFirstPrize2: TLabel;
    EditFirstPrize2: TEdit;
    LabelFirstMoney2: TLabel;
    EditFirstMoney2: TEdit;
    PanelSecondWinning: TPanel;
    PanelFirstWinning: TPanel;
    EditSecondPrizeCost: TEdit;
    EditSecondPrizeName: TEdit;
    procedure CheckBoxScannerClick(Sender: TObject);
    procedure CheckBoxActionClick(Sender: TObject);
    procedure ButtonSearchClick(Sender: TObject);
    procedure ButtonTirageClick(Sender: TObject);
    procedure CheckBoxInLotteryClick(Sender: TObject);
    procedure ButtonChangeClick(Sender: TObject);
  private
    FSizeGrip: TBisSizeGrip;
    FProcessCounter: Integer;
    FScanner: TBisCustomComm;
    FTirageId: Variant;
    FTirageNum: Variant;
    FTicketId: Variant;
    FPreparationFlag: Boolean;
    procedure SetStatistics;
    procedure SetTirageParams(P: TBisProvider);
    procedure SetTicketParams(P: TBisProvider);
    procedure ScannerData(Sender: TObject; const Received: DWORD);
    procedure ScannerCommEvent(Sender: TObject; const Events: TDeviceEvents);
    function SetTirage(TirageNum: String): Boolean;
    procedure SetTicketStatus(Used: Boolean);
    procedure Search;
    procedure SetWinnings(WithCheck: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;

  end;

  TBisBallManageTicketFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisBallManageTicketForm: TBisBallManageTicketForm;

implementation

uses BisLogger, BisDialogs, BisUtils, BisFilterGroups, BisConsts,
     BisBallDataTiragesFm;

{$R *.dfm}

{ TBisBallManageTicketFormIface }

constructor TBisBallManageTicketFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisBallManageTicketForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
  ShowType:=stMdiChild;
end;

{ TBisBallManageTicketForm }

constructor TBisBallManageTicketForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  SizesStored:=true;

  EditTirage.Color:=ColorControlReadOnly;
  EditNum.Color:=ColorControlReadOnly;
  EditSeries.Color:=ColorControlReadOnly;
  EditDealer.Color:=ColorControlReadOnly;

  EditFirstPrize1.Alignment:=taCenter;
  EditFirstPrize2.Alignment:=taCenter;
  EditFirstMoney1.Alignment:=taCenter;
  EditFirstMoney2.Alignment:=taCenter;
  EditFirstCode.Alignment:=taCenter;

  EditSecond11.Alignment:=taCenter;
  EditSecond12.Alignment:=taCenter;
  EditSecond13.Alignment:=taCenter;
  EditSecond14.Alignment:=taCenter;
  EditSecond15.Alignment:=taCenter;

  EditSecond21.Alignment:=taCenter;
  EditSecond22.Alignment:=taCenter;
  EditSecond23.Alignment:=taCenter;
  EditSecond24.Alignment:=taCenter;
  EditSecond25.Alignment:=taCenter;

  EditSecond31.Alignment:=taCenter;
  EditSecond32.Alignment:=taCenter;
  EditSecond33.Alignment:=taCenter;
  EditSecond34.Alignment:=taCenter;
  EditSecond35.Alignment:=taCenter;

  EditSecond41.Alignment:=taCenter;
  EditSecond42.Alignment:=taCenter;
  EditSecond43.Alignment:=taCenter;
  EditSecond44.Alignment:=taCenter;
  EditSecond45.Alignment:=taCenter;

  EditSecond51.Alignment:=taCenter;
  EditSecond52.Alignment:=taCenter;
  EditSecond53.Alignment:=taCenter;
  EditSecond54.Alignment:=taCenter;
  EditSecond55.Alignment:=taCenter;

  EditSecond61.Alignment:=taCenter;
  EditSecond62.Alignment:=taCenter;
  EditSecond63.Alignment:=taCenter;
  EditSecond64.Alignment:=taCenter;
  EditSecond65.Alignment:=taCenter;

  FProcessCounter:=0;
  FTirageId:=Null;
  FTirageNum:=Null;

  FSizeGrip:=TBisSizeGrip.Create(nil);
  FSizeGrip.Parent:=PanelControls;

  FScanner:=TBisCustomComm.Create(Self);
  FScanner.DTRSettings:= [];
  FScanner.XOnXOffSettings:=[fsInX];
  FScanner.MonitorEvents:= [deChar, deFlag, deOutEmpty, deCTS, deDSR, deRLSD,
                            deBreak, deError, deRing, dePrintError, deIn80Full, deProv1, deProv2];
  FScanner.FlowControl:= fcNone;
  FScanner.Options:= [coDiscardNull];
  FScanner.Synchronize:= true;
  FScanner.OnData:=ScannerData;
  FScanner.OnCommEvent:=ScannerCommEvent;

  FScanner.DeviceName:=ConfigRead('Port',FScanner.DeviceName);
  FScanner.BaudRate:=ConfigRead('BaudRate',br9600);
  FScanner.DataControl.DataBits:=ConfigRead('DataBits',db8);
  FScanner.DataControl.Parity:=ConfigRead('Parity',paNone);
  FScanner.DataControl.StopBits:=ConfigRead('StopBits',sb1);

  CheckBoxActionClick(nil);
  TabSheetNone.Visible:=true;
  TabSheetTicket.Visible:=false;

end;

destructor TBisBallManageTicketForm.Destroy;
begin
  FScanner.Free;
  FSizeGrip.Free;
  inherited Destroy;
end;

procedure TBisBallManageTicketForm.ScannerCommEvent(Sender: TObject;  const Events: TDeviceEvents);
begin
  //
end;

procedure TBisBallManageTicketForm.ButtonSearchClick(Sender: TObject);
begin
  Search;
end;

procedure TBisBallManageTicketForm.SetTirageParams(P: TBisProvider);
begin
  if Assigned(P) and P.Active and not P.Empty then begin
    FTirageId:=P.FieldByName('TIRAGE_ID').Value;
    FTirageNum:=P.FieldByName('NUM').Value;
    FPreparationFlag:=not VarIsNull(P.FieldByName('PREPARATION_DATE').Value);
    EditTirage.Text:=FormatEx('%s �� %s',
                              [VarToStrDef(FTirageNum,''),
                               P.FieldByName('EXECUTION_DATE').AsString]);
  end else begin
    FTirageId:=Null;
    FTirageNum:=Null;
    FPreparationFlag:=false;
    EditTirage.Text:='';
  end;
  if FPreparationFlag then begin
    CheckBoxAction.Checked:=false;
    CheckBoxAction.Enabled:=false;
  end else begin
    CheckBoxAction.Enabled:=true;
  end;
  CheckBoxInLottery.Enabled:=not FPreparationFlag and not CheckBoxAction.Checked;
end;

procedure TBisBallManageTicketForm.ButtonTirageClick(Sender: TObject);
var
  Iface: TBisBallDataTiragesFormIface;
  P: TBisProvider;
begin
  Iface:=TBisBallDataTiragesFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    Iface.Init;
    Iface.LocateFields:='TIRAGE_ID';
    Iface.LocateValues:=FTirageId;
    if Iface.SelectInto(P) then begin
      SetTirageParams(P);
      FProcessCounter:=0;
      SetStatistics;
    end;
  finally
    P.Free;
    Iface.Free;
  end;
end;

procedure TBisBallManageTicketForm.CheckBoxActionClick(Sender: TObject);
begin
  EnableControl(PanelAction,CheckBoxAction.Checked);
  CheckBoxInLottery.Enabled:=not FPreparationFlag and not CheckBoxAction.Checked;
end;

procedure TBisBallManageTicketForm.CheckBoxScannerClick(Sender: TObject);
var
  Error: String;
begin
  try
    CheckBoxScanner.OnClick:=nil;
    try
      if CheckBoxScanner.Checked then begin
        if FScanner.Opened then
          FScanner.CloseDevice;
        FScanner.OpenDevice;
      end else begin
        if FScanner.Opened then
          FScanner.CloseDevice;
      end;
    finally
      CheckBoxScanner.OnClick:=CheckBoxScannerClick;
    end;
  except
    On E: Exception do begin
      LoggerWrite(E.Message,ltError);
      if CheckBoxScanner.Checked then
        Error:='���������� ���������� ������.'
      else Error:='���������� ��������� ������.';
      ShowError(Error);
      CheckBoxScanner.Checked:=false;
    end;
  end;
end;

function TBisBallManageTicketForm.SetTirage(TirageNum: String): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  if not Result then begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='S_TIRAGES';
      with P.FieldNames do begin
        AddInvisible('TIRAGE_ID');
        AddInvisible('NUM');
        AddInvisible('PREPARATION_DATE');
        AddInvisible('EXECUTION_DATE');
      end;
       P.FilterGroups.Add.Filters.Add('NUM',fcEqual,TirageNum).CheckCase:=true;
       P.Open;
       SetTirageParams(P);
       Result:=P.Active and not P.Empty;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisBallManageTicketForm.ScannerData(Sender: TObject; const Received: DWORD);

  function CheckScanNumm(var TirageNum,TicketNum: String): Boolean;
  var
    S: String;
  begin
    Result:=false;
    FScanner.WaitForString([#13#10],1000,S);
    if Length(S)>=16 then begin
      TirageNum:=Copy(S,2,3);
      TirageNum:=Trim(TirageNum);
      TicketNum:=Copy(S,5,8);
      TicketNum:=Trim(TicketNum);
      Result:=(Length(TirageNum)=3) and (Length(TicketNum)=8);
    end;
  end;

var
  TirageNum: String;
  TicketNum: String;
begin
  FScanner.OnData:=nil;
  try
    SetTirageParams(nil);
    EditSearchNum.Text:='';
    SetWinnings(false);
    SetTicketParams(nil);
    if CheckScanNumm(TirageNum,TicketNum) then begin
      if SetTirage(TirageNum) then begin
        EditSearchNum.Text:=TicketNum;
        EditSearchNum.SelStart:=Length(TicketNum);
        SetStatistics;
        Search;
      end else
        ShowWarning('�� ������ �����.');
    end else
      ShowWarning('�� ������ �����-���.');
  finally
    FScanner.OnData:=ScannerData;
  end;
end;

procedure TBisBallManageTicketForm.SetTicketStatus(Used: Boolean);
var
  P: TBisProvider;
begin
  if not VarIsNull(FTicketId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=true;
      P.ProviderName:='SET_TICKET_STATUS';
      with P.Params do begin
        AddInvisible('TICKET_ID').Value:=FTicketId;
        AddInvisible('USED').Value:=Integer(Used);
      end;
      P.Execute;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisBallManageTicketForm.CheckBoxInLotteryClick(Sender: TObject);
begin
  SetTicketStatus(CheckBoxInLottery.Checked);
  SetStatistics;
end;

procedure TBisBallManageTicketForm.ButtonChangeClick(Sender: TObject);
var
  P: TBisProvider;
begin
  if not VarIsNull(FTicketId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=true;
      P.ProviderName:='CHANGE_TICKET_OWNER';
      P.StopException:=true;
      with P.Params do begin
        AddInvisible('TICKET_ID').Value:=FTicketId;
        AddInvisible('SURNAME').Value:=Iff(Trim(EditSurname.Text)<>'',Trim(EditSurname.Text),Null);
        AddInvisible('NAME').Value:=Iff(Trim(EditName.Text)<>'',Trim(EditName.Text),Null);
        AddInvisible('PATRONYMIC').Value:=Iff(Trim(EditPatronymic.Text)<>'',Trim(EditPatronymic.Text),Null);
        AddInvisible('ADDRESS').Value:=Iff(Trim(EditAddress.Text)<>'',Trim(EditAddress.Text),Null);
        AddInvisible('PHONE').Value:=Iff(Trim(EditPhone.Text)<>'',Trim(EditPhone.Text),Null);
      end;
      P.Execute;
      if P.Success then
        ShowInfo('������ ��������� ������� ��������.');
    finally
      P.Free;
    end;
  end;
end;

procedure TBisBallManageTicketForm.SetStatistics;
var
  P: TBisProvider;
  AllCount: Integer;
  UsedCount: Integer;
  NotUsedCount: Integer;
begin
  if not VarIsNull(FTirageId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='GET_TIRAGE_STATISTICS';
      with P.Params do begin
        AddInvisible('TIRAGE_ID').Value:=FTirageId;
        AddInvisible('ALL_COUNT',ptOutput);
        AddInvisible('USED_COUNT',ptOutput);
        AddInvisible('NOT_USED_COUNT',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        AllCount:=P.Params.ParamByName('ALL_COUNT').AsInteger;
        UsedCount:=P.Params.ParamByName('USED_COUNT').AsInteger;
        NotUsedCount:=P.Params.ParamByName('NOT_USED_COUNT').AsInteger;

        LabelTicketCounter.Caption:=IntToStr(AllCount);
        LabelTicketManageCounter.Caption:=IntToStr(FProcessCounter);
        LabelTicketUsedCounter.Caption:=IntToStr(UsedCount);
        LabelTicketNotUsedCounter.Caption:=IntToStr(NotUsedCount);
      end;
    finally
      P.Free;
    end;
  end else begin
    LabelTicketCounter.Caption:=IntToStr(0);
    LabelTicketUsedCounter.Caption:=IntToStr(0);
    LabelTicketNotUsedCounter.Caption:=IntToStr(0);
  end;
end;

procedure TBisBallManageTicketForm.SetTicketParams(P: TBisProvider);

  procedure SetEditValue(Edit: TEdit; Value: String);
  begin
    Edit.Text:=Trim(Value);
    if Edit.Text<>'' then begin
      Edit.Color:=clWindow;
      Edit.Enabled:=true;
      Edit.ReadOnly:=true;
      Edit.Font.Style:=[fsBold];
    end else begin
      Edit.Color:=ColorControlReadOnly;
      Edit.Enabled:=false;
      Edit.ReadOnly:=true;
      Edit.Font.Style:=[];
    end;
  end;

  procedure EmptyEdits;
  var
    i: Integer;
    Control: TControl;
    AName: String;
    S: String;
  begin
    for i:=0 to TabSheetTicket.ControlCount-1 do begin
      Control:=TabSheetTicket.Controls[i];
      if Control is TEdit then begin
        AName:=TEdit(Control).Name;
        S:=Copy(AName,1,10);
        if AnsiSameText(S,'EditSecond') then
          SetEditValue(TEdit(Control),'');
      end;
    end;
  end;

  procedure SetEdits(P: TBisProvider);
  var
    i: Integer;
    Control: TControl;
    AName: String;
    S: String;
    Field: TField;
  begin
    if P.Active then
      for i:=0 to TabSheetTicket.ControlCount-1 do begin
        Control:=TabSheetTicket.Controls[i];
        if Control is TEdit then begin
          AName:=TEdit(Control).Name;
          S:=Copy(AName,1,10);
          if AnsiSameText(S,'EditSecond') then begin
            S:='G2_'+Copy(AName,11,2);
            Field:=P.FindField(S);
            if Assigned(Field) then begin
              S:=Field.AsString;
              SetEditValue(TEdit(Control),S);
            end;
          end;
        end;
      end;
  end;

begin
  if Assigned(P) and P.Active and not P.Empty then begin
    FTicketId:=P.FieldByName('TICKET_ID').Value;
    EditNum.Text:=P.FieldByName('NUM').AsString;
    EditSeries.Text:=P.FieldByName('SERIES').AsString;
    EditDealer.Text:=P.FieldByName('DEALER_NAME').AsString;
    CheckBoxInLottery.Checked:=Boolean(P.FieldByName('USED').AsInteger);
    CheckBoxInLottery.Enabled:=not FPreparationFlag and not CheckBoxAction.Checked;
    SetEditValue(EditFirstPrize1,P.FieldByName('G1_PRIZE_1').AsString);
    SetEditValue(EditFirstPrize2,P.FieldByName('G1_PRIZE_2').AsString);
    SetEditValue(EditFirstMoney1,P.FieldByName('G1_MONEY_1').AsString);
    SetEditValue(EditFirstMoney2,P.FieldByName('G1_MONEY_2').AsString);
    SetEditValue(EditFirstCode,P.FieldByName('G1_CODE').AsString);
    SetEdits(P);
    EditSurname.Text:=P.FieldByName('SURNAME').AsString;
    EditName.Text:=P.FieldByName('NAME').AsString;
    EditPatronymic.Text:=P.FieldByName('PATRONYMIC').AsString;
    EditAddress.Text:=P.FieldByName('ADDRESS').AsString;
    EditPhone.Text:=P.FieldByName('PHONE').AsString;
    TabSheetNone.Visible:=false;
    TabSheetTicket.Visible:=true;
    ButtonChange.Enabled:=true;
  end else begin
    FTicketId:=Null;
    EditNum.Text:='';
    EditSeries.Text:='';
    EditDealer.Text:='';
    CheckBoxInLottery.Checked:=false;
    SetEditValue(EditFirstPrize1,'');
    SetEditValue(EditFirstPrize2,'');
    SetEditValue(EditFirstMoney1,'');
    SetEditValue(EditFirstMoney2,'');
    SetEditValue(EditFirstCode,'');
    EmptyEdits;
    EditSurname.Text:='';
    EditName.Text:='';
    EditPatronymic.Text:='';
    EditAddress.Text:='';
    EditPhone.Text:='';
    TabSheetNone.Visible:=true;
    TabSheetTicket.Visible:=false;
    ButtonChange.Enabled:=false;
  end;
end;

procedure TBisBallManageTicketForm.Search;
var
  TicketNum: String;

  function CheckFields: Boolean;
  begin
    Result:=false;

    if (Trim(EditTirage.Text)='') or VarIsNull(FTirageId) then begin
      ShowError('�������� �����.');
      EditTirage.SetFocus;
      exit;
    end;

    if TicketNum='' then begin
      ShowError('������� ����� ������.');
      EditSearchNum.SetFocus;
      exit;
    end;

    if Length(TicketNum)<8 then begin
      ShowError('������� ���������� ����� ������.');
      EditSearchNum.SetFocus;
      exit;
    end;
    
    Result:=true;
  end;

  function SetTicket: Boolean;
  var
    P: TBisProvider;
  begin
    Result:=false;
    if not Result then begin
      P:=TBisProvider.Create(nil);
      try
        P.WithWaitCursor:=true;
        P.ProviderName:='S_TICKETS';
        with P.FilterGroups.Add do begin
          Filters.Add('TIRAGE_ID',fcEqual,FTirageId).CheckCase:=true;
          Filters.Add('NUM',fcEqual,TicketNum).CheckCase:=true;
        end;
        P.Open;
        SetTicketParams(P);
        Result:=not VarIsNull(FTicketId);
      finally
        P.Free;
      end;
    end;
  end;

  procedure ProcessAction;
  begin
    if CheckBoxAction.Checked then begin
      SetTicketStatus(RadioButtonAutoInclude.Checked);
      CheckBoxInLottery.Checked:=not RadioButtonAutoExclude.Checked;
      Inc(FProcessCounter);
    end;
  end;

begin
  TicketNum:=Trim(EditSearchNum.Text);
  if CheckFields then begin
    CheckBoxInLottery.OnClick:=nil;
    try
      SetWinnings(false);
      SetTicketParams(nil);
      if SetTicket then begin
        Update;
        ProcessAction;
        SetWinnings(not CheckBoxAction.Enabled);
        SetStatistics;
      end else begin
        ShowWarning('����� � ����� ������� �� ������.');
        EditSearchNum.SetFocus;
      end;
    finally
      CheckBoxInLottery.OnClick:=CheckBoxInLotteryClick;
    end;
  end;
end;

procedure TBisBallManageTicketForm.SetWinnings(WithCheck: Boolean);

  procedure UpdatePannel(Panel: TPanel; Ready, Winning: Boolean);
  begin
    if Ready then begin
      Panel.Caption:=iff(Winning,'�������','��������');
      Panel.Color:=iff(Winning,clRed,clBtnFace);
      Panel.Font.Color:=iff(Winning,clYellow,clWindowText);
      if Winning then
        Panel.Font.Style:=[fsBold]
      else Panel.Font.Style:=[];
    end else begin
      Panel.Caption:='�� �����';
      Panel.Color:=clBtnFace;
      Panel.Font.Color:=clWindowText;
      Panel.Font.Style:=[];
    end;
  end;

  function GetFirstWinning: Boolean;
  begin
    Result:=false;
    if (EditFirstPrize1.Text<>'������') and (EditFirstPrize2.Text<>'��� ���!') then begin
      Result:=true;
    end else if (EditFirstMoney1.Text=EditFirstMoney2.Text) then
      Result:=true;
  end;

  function GetSecondWinning(var PrizeName: String; var PrizeCost: Extended): Boolean;
  var
    P: TBisProvider;
  begin
    Result:=false;
    if not VarIsNull(FTirageId) and not VarIsNull(FTicketId) then begin
      P:=TBisProvider.Create(nil);
      try
        P.WithWaitCursor:=false;
        P.ProviderName:='GET_PROTOCOL';
        with P.FieldNames do begin
          AddInvisible('PRIZE_NAME');
          AddInvisible('PRIZE_COST');
        end;
        with P.Params do begin
          AddInvisible('TIRAGE_ID').Value:=FTirageId;
          AddInvisible('TICKET_ID',ptOutput);
        end;
        P.FilterGroups.Add.Filters.Add('TICKET_ID',fcEqual,FTicketId).CheckCase:=true;
        P.OpenWithExecute;
        if P.Active then begin
          if not P.Empty then begin
            PrizeName:=P.FieldByName('PRIZE_NAME').AsString;
            PrizeCost:=P.FieldByName('PRIZE_COST').AsFloat;
            Result:=true;
          end;
        end;
      finally
        P.Free;
      end;
    end;
  end;

var
  PrizeName: String;
  PrizeCost: Extended;
  SecondFlag: Boolean;
  FS: TFormatSettings;
begin
  if WithCheck then begin
    UpdatePannel(PanelFirstWinning,true,GetFirstWinning);

    SecondFlag:=GetSecondWinning(PrizeName,PrizeCost);
    UpdatePannel(PanelSecondWinning,true,SecondFlag);

    if SecondFlag then begin
      FS.ThousandSeparator:=' ';
      FS.DecimalSeparator:=DecimalSeparator;
      FS.CurrencyFormat:=CurrencyFormat;
      FS.CurrencyDecimals:=CurrencyDecimals;
      FS.CurrencyString:=CurrencyString;

      EditSecondPrizeName.Text:=PrizeName;
      EditSecondPrizeName.Enabled:=true;
      EditSecondPrizeName.Font.Color:=clRed;
      EditSecondPrizeCost.Text:=FloatToStrF(PrizeCost,ffCurrency,15,2,FS);
      EditSecondPrizeCost.Enabled:=true;
      EditSecondPrizeCost.Font.Color:=clRed;
    end else begin
      EditSecondPrizeName.Text:='';
      EditSecondPrizeName.Enabled:=true;
      EditSecondPrizeName.Font.Color:=clWindowText;
      EditSecondPrizeCost.Text:='';
      EditSecondPrizeCost.Enabled:=true;
      EditSecondPrizeCost.Font.Color:=clWindowText;
    end;
  end else begin
    UpdatePannel(PanelFirstWinning,false,false);
    UpdatePannel(PanelSecondWinning,false,false);
    EditSecondPrizeName.Text:='';
    EditSecondPrizeName.Enabled:=false;
    EditSecondPrizeName.Font.Color:=clWindowText;
    EditSecondPrizeCost.Text:='';
    EditSecondPrizeCost.Enabled:=false;
    EditSecondPrizeName.Font.Color:=clWindowText;
  end;
end;

procedure TBisBallManageTicketForm.BeforeShow;
begin
  inherited BeforeShow;
end;


end.
