unit BisLotoTicketManageFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, DB,
  XComDrv,
  BisFm, BisSizeGrip, BisProvider, BisControls;

type

  TBisCustomComm=class(TCustomComm)
  end;

  TBisLotoTicketManageForm = class(TBisForm)
    PanelControls: TPanel;
    GroupBoxSearch: TGroupBox;
    LabelSearchNum: TLabel;
    EditSearchNum: TEdit;
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
    LabelString1: TLabel;
    EditF1_01: TEdit;
    EditF1_02: TEdit;
    EditF1_03: TEdit;
    EditF1_04: TEdit;
    EditF1_05: TEdit;
    EditF1_06: TEdit;
    EditF1_07: TEdit;
    EditF1_08: TEdit;
    EditF1_09: TEdit;
    LabelString2: TLabel;
    EditF2_01: TEdit;
    EditF2_02: TEdit;
    EditF2_03: TEdit;
    EditF2_04: TEdit;
    EditF2_05: TEdit;
    EditF2_06: TEdit;
    EditF2_07: TEdit;
    EditF2_08: TEdit;
    EditF2_09: TEdit;
    LabelString3: TLabel;
    EditF3_01: TEdit;
    EditF3_02: TEdit;
    EditF3_03: TEdit;
    EditF3_04: TEdit;
    EditF3_05: TEdit;
    EditF3_06: TEdit;
    EditF3_07: TEdit;
    EditF3_08: TEdit;
    EditF3_09: TEdit;
    LabelString4: TLabel;
    EditF4_01: TEdit;
    EditF4_02: TEdit;
    EditF4_03: TEdit;
    EditF4_04: TEdit;
    EditF4_05: TEdit;
    EditF4_06: TEdit;
    EditF4_07: TEdit;
    EditF4_08: TEdit;
    EditF4_09: TEdit;
    ShapeString3: TShape;
    ShapeString2: TShape;
    ShapeString4: TShape;
    ShapeString1: TShape;
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
    ButtonPrizes: TButton;
    ButtonChange: TButton;
    LabelTicketCounter: TLabel;
    LabelTicketManageCounter: TLabel;
    LabelTicketNotUsedCounter: TLabel;
    LabelTicketUsedCounter: TLabel;
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
    procedure SetTicketStatus(NotUsed: Boolean);
    procedure Search;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;

  end;

  TBisLotoTicketManageFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisLotoTicketManageForm: TBisLotoTicketManageForm;

implementation

uses BisLogger, BisDialogs, BisUtils, BisFilterGroups, BisConsts,
     BisLotoDataTiragesFm;

{$R *.dfm}

{ TBisLotoTicketManageFormIface }

constructor TBisLotoTicketManageFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisLotoTicketManageForm;
  Available:=true;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
end;

{ TBisLotoTicketManageForm }

constructor TBisLotoTicketManageForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  SizesStored:=true;

  EditTirage.Color:=ColorControlReadOnly;
  EditNum.Color:=ColorControlReadOnly;
  EditSeries.Color:=ColorControlReadOnly;

  with LabelString1.FocusControls do begin
    Add(EditF1_01);
    Add(EditF1_02);
    Add(EditF1_03);
    Add(EditF1_04);
    Add(EditF1_05);
    Add(EditF1_06);
    Add(EditF1_07);
    Add(EditF1_08);
    Add(EditF1_09);
  end;

  with LabelString2.FocusControls do begin
    Add(EditF2_01);
    Add(EditF2_02);
    Add(EditF2_03);
    Add(EditF2_04);
    Add(EditF2_05);
    Add(EditF2_06);
    Add(EditF2_07);
    Add(EditF2_08);
    Add(EditF2_09);
  end;

  with LabelString3.FocusControls do begin
    Add(EditF3_01);
    Add(EditF3_02);
    Add(EditF3_03);
    Add(EditF3_04);
    Add(EditF3_05);
    Add(EditF3_06);
    Add(EditF3_07);
    Add(EditF3_08);
    Add(EditF3_09);
  end;

  with LabelString4.FocusControls do begin
    Add(EditF4_01);
    Add(EditF4_02);
    Add(EditF4_03);
    Add(EditF4_04);
    Add(EditF4_05);
    Add(EditF4_06);
    Add(EditF4_07);
    Add(EditF4_08);
    Add(EditF4_09);
  end;

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

destructor TBisLotoTicketManageForm.Destroy;
begin
  FScanner.Free;
  FSizeGrip.Free;
  inherited Destroy;
end;

procedure TBisLotoTicketManageForm.ScannerCommEvent(Sender: TObject;  const Events: TDeviceEvents);
begin
  //
end;

procedure TBisLotoTicketManageForm.ButtonSearchClick(Sender: TObject);
begin
  Search;
end;

procedure TBisLotoTicketManageForm.SetTirageParams(P: TBisProvider);
begin
  if Assigned(P) and P.Active and not P.Empty then begin
    FTirageId:=P.FieldByName('TIRAGE_ID').Value;
    FTirageNum:=P.FieldByName('NUM').Value;
    FPreparationFlag:=not VarIsNull(P.FieldByName('PREPARATION_DATE').Value);
    EditTirage.Text:=FormatEx('%s от %s',
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
  ButtonPrizes.Enabled:=FPreparationFlag;
end;

procedure TBisLotoTicketManageForm.ButtonTirageClick(Sender: TObject);
var
  Iface: TBisLotoDataTiragesFormIface;
  P: TBisProvider;
begin
  Iface:=TBisLotoDataTiragesFormIface.Create(nil);
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

procedure TBisLotoTicketManageForm.CheckBoxActionClick(Sender: TObject);
begin
  EnableControl(PanelAction,CheckBoxAction.Checked);
  CheckBoxInLottery.Enabled:=not FPreparationFlag and not CheckBoxAction.Checked;
end;

procedure TBisLotoTicketManageForm.CheckBoxScannerClick(Sender: TObject);
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
        Error:='Невозможно подключить сканер.'
      else Error:='Невозможно отключить сканер.';
      ShowError(Error);
      CheckBoxScanner.Checked:=false;
    end;
  end;
end;

function TBisLotoTicketManageForm.SetTirage(TirageNum: String): Boolean;
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

procedure TBisLotoTicketManageForm.ScannerData(Sender: TObject; const Received: DWORD);

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
    SetTicketParams(nil);
    if CheckScanNumm(TirageNum,TicketNum) then begin
      if SetTirage(TirageNum) then begin
        EditSearchNum.Text:=TicketNum;
        EditSearchNum.SelStart:=Length(TicketNum);
        SetStatistics;
        Search;
      end else
        ShowWarning('Не верный тираж.');
    end else
      ShowWarning('Не верный штрих-код.');
  finally
    FScanner.OnData:=ScannerData;
  end;
end;

procedure TBisLotoTicketManageForm.SetTicketStatus(NotUsed: Boolean);
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
        AddInvisible('NOT_USED').Value:=Integer(NotUsed);
      end;
      P.Execute;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisLotoTicketManageForm.CheckBoxInLotteryClick(Sender: TObject);
begin
  SetTicketStatus(not CheckBoxInLottery.Checked);
  SetStatistics;
end;

procedure TBisLotoTicketManageForm.ButtonChangeClick(Sender: TObject);
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
        ShowInfo('Данные владельца успешно изменены.');
    finally
      P.Free;
    end;
  end;
end;

procedure TBisLotoTicketManageForm.SetStatistics;
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
      P.ProviderName:='GET_LOTTERY_STATISTICS';
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

procedure TBisLotoTicketManageForm.SetTicketParams(P: TBisProvider);

  procedure EmptyF;
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
        S:=Copy(AName,1,5);
        if AnsiSameText(S,'EditF') then begin
          TEdit(Control).Color:=ColorControlReadOnly;
          TEdit(Control).Enabled:=false;
          TEdit(Control).ReadOnly:=true;
          TEdit(Control).Font.Style:=[];
          TEdit(Control).Text:='';
        end;
      end;
    end;
  end;

  procedure SetF(P: TBisProvider);
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
          S:=Copy(AName,1,5);
          if AnsiSameText(S,'EditF') then begin
            S:=Copy(AName,5,5);
            Field:=P.FindField(S);
            if Assigned(Field) then begin
              S:=Field.AsString;
              if Trim(S)<>'' then begin
                TEdit(Control).Color:=clWindow;
                TEdit(Control).Enabled:=true;
                TEdit(Control).ReadOnly:=true;
                TEdit(Control).Font.Style:=[fsBold];
              end;
              TEdit(Control).Text:=S;
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
    CheckBoxInLottery.Checked:=not Boolean(P.FieldByName('NOT_USED').AsInteger);
    CheckBoxInLottery.Enabled:=not FPreparationFlag and not CheckBoxAction.Checked;
    SetF(P);
    EditSurname.Text:=P.FieldByName('SURNAME').AsString;
    EditName.Text:=P.FieldByName('NAME').AsString;
    EditPatronymic.Text:=P.FieldByName('PATRONYMIC').AsString;
    EditAddress.Text:=P.FieldByName('ADDRESS').AsString;
    EditPhone.Text:=P.FieldByName('PHONE').AsString;
    TabSheetNone.Visible:=false;
    TabSheetTicket.Visible:=true;
    ButtonPrizes.Enabled:=FPreparationFlag;
    ButtonChange.Enabled:=true;
  end else begin
    FTicketId:=Null;
    EditNum.Text:='';
    EditSeries.Text:='';
    CheckBoxInLottery.Checked:=false;
    EmptyF;
    EditSurname.Text:='';
    EditName.Text:='';
    EditPatronymic.Text:='';
    EditAddress.Text:='';
    EditPhone.Text:='';
    TabSheetNone.Visible:=true;
    TabSheetTicket.Visible:=false;
    ButtonPrizes.Enabled:=false;
    ButtonChange.Enabled:=false;
  end;
end;

procedure TBisLotoTicketManageForm.Search;
var
  TicketNum: String;

  function CheckFields: Boolean;
  begin
    Result:=false;

    if (Trim(EditTirage.Text)='') or VarIsNull(FTirageId) then begin
      ShowError('Выберите тираж.');
      EditTirage.SetFocus;
      exit;
    end;

    if TicketNum='' then begin
      ShowError('Введите номер билета.');
      EditSearchNum.SetFocus;
      exit;
    end;

    if Length(TicketNum)<8 then begin
      ShowError('Введите правильный номер билета.');
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
      SetTicketStatus(RadioButtonAutoExclude.Checked);
      CheckBoxInLottery.Checked:=not RadioButtonAutoExclude.Checked;
      Inc(FProcessCounter);
    end;
  end;

  procedure SetPrizes;
  begin
  end;

begin
  TicketNum:=Trim(EditSearchNum.Text);
  if CheckFields then begin
    CheckBoxInLottery.OnClick:=nil;
    try
      SetTicketParams(nil);
      if SetTicket then begin
        Update;
        ProcessAction;
        SetPrizes;
        SetStatistics;
      end else begin
        ShowWarning('Билет с таким номером не найден.');
        EditSearchNum.SetFocus;
      end;
    finally
      CheckBoxInLottery.OnClick:=CheckBoxInLotteryClick;
    end;
  end;
end;

procedure TBisLotoTicketManageForm.BeforeShow;
begin
  inherited BeforeShow;
//  LabelString1.
end;


end.
