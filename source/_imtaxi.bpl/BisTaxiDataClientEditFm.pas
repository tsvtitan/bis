unit BisTaxiDataClientEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList, Buttons, Menus, ActnPopup,
  BisDataEditFm, BisDataFrm, BisParam,
  BisTaxiDataClientPhonesFm,
  BisTaxiDataReceiptsFrm, BisTaxiDataChargesFrm, BisTaxiDataDiscountsFm,
  BisTaxiDataInMessagesFm, BisTaxiDataOutMessagesFrm,
  BisTaxiDataCallEditFm, BisTaxiDataCallsFrm,
  BisTaxiDataOrdersFrm, BisTaxiDataClientChildsFrm, 
  BisControls;

type
  TBisTaxiDataClientEditForm = class(TBisDataEditForm)
    PageControl: TPageControl;
    TabSheetMain: TTabSheet;
    TabSheetAccount: TTabSheet;
    TabSheetMessages: TTabSheet;
    TabSheetOrders: TTabSheet;
    TabSheetExtra: TTabSheet;
    LabelSurname: TLabel;
    EditSurname: TEdit;
    LabelName: TLabel;
    EditName: TEdit;
    LabelPatronymic: TLabel;
    EditPatronymic: TEdit;
    LabelPhone: TLabel;
    EditPhone: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPassport: TLabel;
    MemoPassport: TMemo;
    LabelDateBirth: TLabel;
    DateTimePickerBirth: TDateTimePicker;
    LabelPlaceBirth: TLabel;
    EditPlaceBirth: TEdit;
    LabelFirm: TLabel;
    EditFirm: TEdit;
    ButtonFirm: TButton;
    LabelMethod: TLabel;
    ComboBoxMethod: TComboBox;
    LabelUserName: TLabel;
    EditUserName: TEdit;
    CheckBoxLocked: TCheckBox;
    LabelJobTitle: TLabel;
    EditJobTitle: TEdit;
    BitBtnPhone: TBitBtn;
    PopupPhone: TPopupActionBar;
    PanelReceiptCharges: TPanel;
    LabelCalc: TLabel;
    ComboBoxCalc: TComboBox;
    LabelMinBalance: TLabel;
    EditMinBalance: TEdit;
    LabelActualBalance: TLabel;
    EditActualBalance: TEdit;
    PageControlAccount: TPageControl;
    TabSheetAccountReceipts: TTabSheet;
    TabSheetAccountCharges: TTabSheet;
    PhoneMenuItemMessage: TMenuItem;
    PhoneMenuItemCall: TMenuItem;
    PageControlMessages: TPageControl;
    TabSheetInMessages: TTabSheet;
    TabSheetOutMessages: TTabSheet;
    TabSheetDiscounts: TTabSheet;
    GroupBoxAddress: TGroupBox;
    LabelStreet: TLabel;
    LabelIndex: TLabel;
    LabelHouse: TLabel;
    LabelFlat: TLabel;
    EditStreet: TEdit;
    ButtonStreet: TButton;
    EditIndex: TEdit;
    EditHouse: TEdit;
    EditFlat: TEdit;
    LabelPassword: TLabel;
    EditPassword: TEdit;
    LabelGroup: TLabel;
    EditGroup: TEdit;
    ButtonGroup: TButton;
    LabelSource: TLabel;
    ComboBoxSource: TComboBox;
    LabelSex: TLabel;
    ComboBoxSex: TComboBox;
    LabelAddressDesc: TLabel;
    EditAddressDesc: TEdit;
    LabelPorch: TLabel;
    EditPorch: TEdit;
    ButtonUserName: TBitBtn;
    TabSheetPhones: TTabSheet;
    TabSheetChilds: TTabSheet;
    TabSheetCalls: TTabSheet;
    PageControlCalls: TPageControl;
    TabSheetInCalls: TTabSheet;
    TabSheetOutCalls: TTabSheet;
    procedure PageControlChange(Sender: TObject);
    procedure BitBtnPhoneClick(Sender: TObject);
    procedure PopupPhonePopup(Sender: TObject);
    procedure PhoneMenuItemMessageClick(Sender: TObject);
    procedure PageControlAccountChange(Sender: TObject);
    procedure PageControlMessagesChange(Sender: TObject);
    procedure ButtonUserNameClick(Sender: TObject);
    procedure PhoneMenuItemCallClick(Sender: TObject);
    procedure PageControlCallsChange(Sender: TObject);
  private
    FPhonesFrame: TBisTaxiDataClientPhonesFrame;
    FReceiptsFrame: TBisTaxiDataReceiptsFrame;
    FChargesFrame: TBisTaxiDataChargesFrame;
    FDiscountsFrame: TBisTaxiDataDiscountsFrame;
    FInMessagesFrame: TBisTaxiDataInMessagesFrame;
    FOutMessagesFrame: TBisTaxiDataOutMessagesFrame;
    FInCallsFrame: TBisTaxiDataCallsFrame;
    FOutCallsFrame: TBisTaxiDataCallsFrame;
    FOrdersFrame: TBisTaxiDataOrdersFrame;
    FChildsFrame: TBisTaxiDataClientChildsFrame;

    procedure SetActualBalance;
    function CanMessage: Boolean;
    procedure Message;
    function CanCall: Boolean;
    procedure Call;
    function FrameCan(Sender: TBisDataFrame): Boolean;
    procedure FrameCalcBalance(Sender: TBisDataFrame);
    function GetClientUserName(VisibleCursor: Boolean): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ChangeParam(Param: TBisParam); override;
    procedure BeforeShow; override;
    procedure ShowParam(Param: TBisParam); override;

  end;

  TBisTaxiDataClientEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientViewFormIface=class(TBisTaxiDataClientEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientFilterFormIface=class(TBisTaxiDataClientEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientInsertFormIface=class(TBisTaxiDataClientEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientUpdateFormIface=class(TBisTaxiDataClientEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientDeleteFormIface=class(TBisTaxiDataClientEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataClientEditForm: TBisTaxiDataClientEditForm;

implementation

uses
     BisUtils, BisTaxiConsts, BisIfaces, BisCore, BisLogger, BisFm, BisDataFm,
     BisParamEditDataSelect, BisValues, BisProvider, BisFilterGroups, BisOrders,
     BisTaxiDataCalcsFm, BisTaxiDataMethodsFm, BisTaxiDataClientGroupsFm, BisTaxiDataSourcesFm,
     BisTaxiDataOutMessageEditFm, BisTaxiPhoneFm, BisTaxiPhoneFrm;

{$R *.dfm}

{ TBisTaxiDataClientEditFormIface }

constructor TBisTaxiDataClientEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataClientEditForm;
  with Params do begin
    AddKey('CLIENT_ID').Older('OLD_CLIENT_ID');
    AddInvisible('LOCALITY_ID');
    AddInvisible('LOCALITY_PREFIX');
    AddInvisible('LOCALITY_NAME');
    AddInvisible('STREET_PREFIX');
    AddInvisible('STREET_NAME');
    AddEdit('SURNAME','EditSurName','LabelSurName',false);
    AddEdit('NAME','EditName','LabelName',false);
    AddEdit('PATRONYMIC','EditPatronymic','LabelPatronymic');
    AddEditDataSelect('FIRM_ID','EditFirm','LabelFirm','ButtonFirm',
                      SClassDataFirmsFormIface,'FIRM_SMALL_NAME',false,false,'','SMALL_NAME');
    AddEdit('JOB_TITLE','EditJobTitle','LabelJobTitle');
    AddEdit('PHONE','EditPhone','LabelPhone',false);
    AddComboBoxDataSelect('METHOD_ID','ComboBoxMethod','LabelMethod','',
                          TBisTaxiDataMethodsFormIface,'METHOD_NAME',false,false,'','NAME');
    with AddEditDataSelect('STREET_ID','EditStreet','LabelStreet','ButtonStreet',
                            SClassDataStreetsFormIface,'STREET_PREFIX;STREET_NAME;LOCALITY_PREFIX;LOCALITY_NAME;LOCALITY_ID',
                            false,false,'STREET_ID','PREFIX;NAME;LOCALITY_PREFIX;LOCALITY_NAME;LOCALITY_ID') do begin
      DataAliasFormat:='%s%s %s%s';
      ExcludeModes([emFilter]);
    end;
    AddEdit('HOUSE','EditHouse','LabelHouse');
    AddEdit('FLAT','EditFlat','LabelFlat');
    AddEdit('PORCH','EditPorch','LabelPorch');
    AddEdit('INDEX','EditIndex','LabelIndex');
    AddEdit('ADDRESS_DESC','EditAddressDesc','LabelAddressDesc');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEdit('USER_NAME','EditUserName','LabelUserName',true);
    AddEdit('PASSWORD','EditPassword','LabelPassword');
    AddCheckBox('LOCKED','CheckBoxLocked');

    AddEditDataSelect('CLIENT_GROUP_ID','EditGroup','LabelGroup','ButtonGroup',
                      TBisTaxiDataClientGroupsFormIface,'CLIENT_GROUP_NAME',false,false,'','NAME');
    AddComboBoxDataSelect('SOURCE_ID','ComboBoxSource','LabelSource','',
                          TBisTaxiDataSourcesFormIface,'SOURCE_NAME',false,false,'','NAME');
    AddEditDate('DATE_BIRTH','DateTimePickerBirth','LabelDateBirth');
    AddEdit('PLACE_BIRTH','EditPlaceBirth','LabelPlaceBirth');
    AddMemo('PASSPORT','MemoPassport','LabelPassport');
    AddComboBoxIndex('SEX','ComboBoxSex','LabelSex');

    AddComboBoxDataSelect('CALC_ID','ComboBoxCalc','LabelCalc','',
                          TBisTaxiDataCalcsFormIface,'CALC_NAME',false,false,'','NAME');
    AddEditFloat('MIN_BALANCE','EditMinBalance','LabelMinBalance');
    AddEditFloat('ACTUAL_BALANCE','EditActualBalance','LabelActualBalance').ExcludeModes(AllParamEditModes);
  end;
end;

{ TBisTaxiDataClientViewFormIface }

constructor TBisTaxiDataClientViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='�������� �������';
end;

{ TBisTaxiDataClientFilterFormIface }

constructor TBisTaxiDataClientFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ��������';
end;

{ TBisTaxiDataClientInsertFormIface }

constructor TBisTaxiDataClientInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Permissions.Enabled:=true;
  ProviderName:='I_CLIENT';
  ParentProviderName:='S_CLIENTS';
  Caption:='������� �������';
  SMessageSuccess:='������ %USER_NAME ������� ������.';
end;

{ TBisTaxiDataClientUpdateFormIface }

constructor TBisTaxiDataClientUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CLIENT';
  Caption:='�������� �������';
end;

{ TBisTaxiDataClientDeleteFormIface }

constructor TBisTaxiDataClientDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CLIENT';
  Caption:='������� �������';
end;

{ TBisTaxiDataClientEditForm }

constructor TBisTaxiDataClientEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPhonesFrame:=TBisTaxiDataClientPhonesFrame.Create(nil);
  with FPhonesFrame do begin
    Parent:=TabSheetPhones;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    Provider.FieldNames.FieldByName('USER_NAME').Visible:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FReceiptsFrame:=TBisTaxiDataReceiptsFrame.Create(nil);
  with FReceiptsFrame do begin
    Parent:=TabSheetAccountReceipts;
    Align:=alClient;
    AsModal:=true;
    ShowAnotherFirms:=true;
    LabelCounter.Visible:=true;
    Provider.FieldNames.FieldByName('NEW_USER_NAME').Visible:=false;
    FilterMenuItemToday.Visible:=false;
    FilterMenuItemToday.Checked:=false;
    FilterMenuItemArchive.Visible:=false;
    FilterMenuItemArchive.Checked:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
    OnAfterInsertRecord:=FrameCalcBalance;
    OnAfterUpdateRecord:=FrameCalcBalance;
    OnAfterDeleteRecord:=FrameCalcBalance;
  end;

  FChargesFrame:=TBisTaxiDataChargesFrame.Create(nil);
  with FChargesFrame do begin
    Parent:=TabSheetAccountCharges;
    Align:=alClient;
    AsModal:=true;
    ShowAnotherFirms:=true;
    LabelCounter.Visible:=true;
    Provider.FieldNames.FieldByName('NEW_USER_NAME').Visible:=false;
    FilterMenuItemToday.Visible:=false;
    FilterMenuItemToday.Checked:=false;
    FilterMenuItemArchive.Visible:=false;
    FilterMenuItemArchive.Checked:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
    OnAfterInsertRecord:=FrameCalcBalance;
    OnAfterUpdateRecord:=FrameCalcBalance;
    OnAfterDeleteRecord:=FrameCalcBalance;
  end;

  FDiscountsFrame:=TBisTaxiDataDiscountsFrame.Create(nil);
  with FDiscountsFrame do begin
    Parent:=TabSheetDiscounts;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    Provider.FieldNames.FieldByName('USER_NAME').Visible:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FInMessagesFrame:=TBisTaxiDataInMessagesFrame.Create(nil);
  with FInMessagesFrame do begin
    Parent:=TabSheetInMessages;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('NEW_SENDER_NAME').Visible:=false;
    end;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Checked:=true;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FOutMessagesFrame:=TBisTaxiDataOutMessagesFrame.Create(nil);
  with FOutMessagesFrame do begin
    InsertClasses.Remove(InsertClasses.Items[InsertClasses.Count-1]);
    Parent:=TabSheetOutMessages;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('NEW_RECIPIENT_NAME').Visible:=false;
    end;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Checked:=true;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FInCallsFrame:=TBisTaxiDataCallsFrame.Create(nil);
  with FInCallsFrame do begin
    Parent:=TabSheetInCalls;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('NEW_CALLER_NAME').Visible:=false;
    end;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Checked:=true;
    ViewMode:=vmIncoming;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FOutCallsFrame:=TBisTaxiDataCallsFrame.Create(nil);
  with FOutCallsFrame do begin
    Parent:=TabSheetOutCalls;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('NEW_ACCEPTOR_NAME').Visible:=false;
    end;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Checked:=true;
    ViewMode:=vmOutgoing;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;
  
  FOrdersFrame:=TBisTaxiDataOrdersFrame.Create(nil);
  with FOrdersFrame do begin
    Parent:=TabSheetOrders;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    Provider.FieldNames.FieldByName('CLIENT_USER_NAME').Visible:=false;
    FilterMenuItemToday.Visible:=false;
    FilterMenuItemToday.Checked:=false;
    FilterMenuItemArchive.Visible:=false;
    FilterMenuItemArchive.Checked:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FChildsFrame:=TBisTaxiDataClientChildsFrame.Create(nil);
  with FChildsFrame do begin
    Parent:=TabSheetChilds;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;
end;

destructor TBisTaxiDataClientEditForm.Destroy;
begin
  FChildsFrame.Free;
  FOrdersFrame.Free;
  FOutCallsFrame.Free;
  FInCallsFrame.Free;
  FOutMessagesFrame.Free;
  FInMessagesFrame.Free;
  FDiscountsFrame.Free;
  FChargesFrame.Free;
  FReceiptsFrame.Free;
  FPhonesFrame.Free;
  inherited Destroy;
end;

procedure TBisTaxiDataClientEditForm.FrameCalcBalance(Sender: TBisDataFrame);
begin
  if (Mode in [emUpdate,emDelete,emView]) then
    SetActualBalance;
end;

function TBisTaxiDataClientEditForm.FrameCan(Sender: TBisDataFrame): Boolean;
begin
  Result:=Mode in [emUpdate];
end;

procedure TBisTaxiDataClientEditForm.Init;
begin
  inherited Init;
  FPhonesFrame.Init;
  FReceiptsFrame.Init;
  FChargesFrame.Init;
  FDiscountsFrame.Init;
  FInMessagesFrame.Init;
  FOutMessagesFrame.Init;
  FInCallsFrame.Init;
  FOutCallsFrame.Init;
  FOrdersFrame.Init;
  FChildsFrame.Init;
end;

procedure TBisTaxiDataClientEditForm.BeforeShow;
var
  Exists: Boolean;
  UserName: String;
begin
  inherited BeforeShow;

  PageControl.TabIndex:=0;
  PageControlAccount.TabIndex:=0;
  PageControlMessages.TabIndex:=0;

  Exists:=Mode in [emUpdate,emDelete,emView];
  PageControlAccount.Visible:=Exists;
  TabSheetPhones.TabVisible:=Exists;
  TabSheetMessages.TabVisible:=Exists;
  TabSheetOrders.TabVisible:=Exists;
  TabSheetDiscounts.TabVisible:=Exists;
  TabSheetChilds.TabVisible:=Exists;

  if Mode in [emInsert,emDuplicate] then begin
    UserName:=GetClientUserName(false);
    with Provider.Params do begin
      Find('USER_NAME').SetNewValue(UserName);
    end;
  end;

  if Mode in [emDelete] then begin
    EnableControl(TabSheetMain,false);
    EnableControl(PanelReceiptCharges,false);
    EnableControl(TabSheetPhones,false);
    EnableControl(TabSheetAccountReceipts,false);
    EnableControl(TabSheetAccountCharges,false);
    EnableControl(TabSheetInMessages,false);
    EnableControl(TabSheetOutMessages,false);
    EnableControl(TabSheetInCalls,false);
    EnableControl(TabSheetOutCalls,false);
    EnableControl(TabSheetOrders,false);
    EnableControl(TabSheetDiscounts,false);
    EnableControl(TabSheetChilds,false);
  end else begin
    FPhonesFrame.ShowType:=ShowType;
    FReceiptsFrame.ShowType:=ShowType;
    FChargesFrame.ShowType:=ShowType;
    FDiscountsFrame.ShowType:=ShowType;
    FInMessagesFrame.ShowType:=ShowType;
    FOutMessagesFrame.ShowType:=ShowType;
    FInCallsFrame.ShowType:=ShowType;
    FOutCallsFrame.ShowType:=ShowType;
    FOrdersFrame.ShowType:=ShowType;
    FChildsFrame.ShowType:=ShowType;
  end;

  UpdateButtonState;
end;

procedure TBisTaxiDataClientEditForm.SetActualBalance;
var
  ParamBalance: TBisParam;
  ParamClientId: TBisParam;
  P: TBisProvider;
begin
  ParamBalance:=Provider.Params.ParamByName('ACTUAL_BALANCE');
  ParamClientId:=Provider.Params.ParamByName('CLIENT_ID');
  if not ParamClientId.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.StopException:=true;
      P.ProviderName:='GET_ACCOUNT_BALANCE';
      P.Params.AddInvisible('ACCOUNT_ID').Value:=ParamClientId.Value;
      P.Params.AddInvisible('BALANCE',ptOutput);
      P.Execute;
      if P.Success then
        ParamBalance.SetNewValue(P.Params.ParamByName('BALANCE').Value)
      else
        ParamBalance.SetNewValue(Null);
    finally
      P.Free;
    end;
  end;
end;

procedure TBisTaxiDataClientEditForm.ShowParam(Param: TBisParam);
begin
  if AnsiSameText(Param.ParamName,'CLIENT_GROUP_ID') or
     AnsiSameText(Param.ParamName,'CLIENT_GROUP_NAME') or
     AnsiSameText(Param.ParamName,'SOURCE_ID') or
     AnsiSameText(Param.ParamName,'SOURCE_NAME') or
     AnsiSameText(Param.ParamName,'DATE_BIRTH') or
     AnsiSameText(Param.ParamName,'PLACE_BIRTH') or
     AnsiSameText(Param.ParamName,'PASSPORT') or
     AnsiSameText(Param.ParamName,'SEX') then begin
    PageControl.ActivePageIndex:=1;
  end else
  if AnsiSameText(Param.ParamName,'CALC_ID') or
     AnsiSameText(Param.ParamName,'CALC_NAME') or
     AnsiSameText(Param.ParamName,'MIN_BALANCE') or
     AnsiSameText(Param.ParamName,'ACTUAL_BALANCE') then begin
    PageControl.ActivePageIndex:=2;
  end else
    PageControl.ActivePageIndex:=0;

  inherited ShowParam(Param);
end;

procedure TBisTaxiDataClientEditForm.BitBtnPhoneClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=TabSheetMain.ClientToScreen(Point(BitBtnPhone.Left,BitBtnPhone.Top+BitBtnPhone.Height));
  PopupPhone.Popup(Pt.X,Pt.Y);
end;

procedure TBisTaxiDataClientEditForm.ChangeParam(Param: TBisParam);
begin
  inherited ChangeParam(Param);
end;

procedure TBisTaxiDataClientEditForm.PhoneMenuItemCallClick(Sender: TObject);
begin
  Call;
end;

procedure TBisTaxiDataClientEditForm.PhoneMenuItemMessageClick(Sender: TObject);
begin
  Message;
end;

function TBisTaxiDataClientEditForm.CanCall: Boolean;
var
  AIface: TBisTaxiPhoneFormIface;
begin
  Result:=Trim(EditPhone.Text)<>'';
  if Result then begin
    AIface:=TBisTaxiPhoneFormIface.Create(nil);
    try
      AIface.Init;
      Result:=AIface.CanShow;
    finally
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataClientEditForm.Call;
var
  AIface: TBisTaxiPhoneFormIface;
begin
  if CanCall then begin
    AIface:=TBisTaxiPhoneFormIface(Core.FindIface(TBisTaxiPhoneFormIface));
    if Assigned(AIface) then begin
      with Provider do begin
        AIface.Dial(EditPhone.Text,Null);
      end;
    end;
  end;
end;

function TBisTaxiDataClientEditForm.CanMessage: Boolean;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataEditFormIface;
begin
  Result:=Trim(EditPhone.Text)<>'';
  if Result then begin
    AClass:=TBisTaxiDataOutMessageInsertFormIface;
    Result:=Assigned(AClass) and IsClassParent(AClass,TBisDataEditFormIface);
    if Result then begin
      AIface:=TBisDataEditFormIfaceClass(AClass).Create(nil);
      try
        AIface.Init;
        Result:=AIface.CanShow;
      finally
        AIface.Free;
      end;
    end;
  end;
end;

procedure TBisTaxiDataClientEditForm.Message;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataEditFormIface;
  P1: TBisParam;
begin
  if CanMessage then begin
    AClass:=TBisTaxiDataOutMessageInsertFormIface;
    AIface:=TBisDataEditFormIfaceClass(AClass).Create(nil);
    try
      AIface.Init;
      with AIface.Params do begin
        if Mode in [emUpdate,emView] then begin
          ParamByName('RECIPIENT_ID').Value:=Provider.Params.ParamByName('CLIENT_ID').Value;
          ParamByName('RECIPIENT_USER_NAME').Value:=Provider.Params.ParamByName('USER_NAME').Value;
          ParamByName('RECIPIENT_SURNAME').Value:=Provider.Params.ParamByName('SURNAME').Value;
          ParamByName('RECIPIENT_NAME').Value:=Provider.Params.ParamByName('NAME').Value;
          ParamByName('RECIPIENT_PATRONYMIC').Value:=Provider.Params.ParamByName('PATRONYMIC').Value;
          P1:=ParamByName('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
          P1.Value:=AIface.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
        end;
        ParamByName('CONTACT').Value:=Provider.Params.ParamByName('PHONE').Value;
      end;
      AIface.ShowType:=ShowType;
      AIface.ShowModal;
    finally
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataClientEditForm.PopupPhonePopup(Sender: TObject);
begin
  PhoneMenuItemMessage.Enabled:=CanMessage;
  PhoneMenuItemCall.Enabled:=CanCall;
end;

procedure TBisTaxiDataClientEditForm.PageControlAccountChange(Sender: TObject);
var
  Param: TBisParam;
begin

  if PageControlAccount.ActivePage=TabSheetAccountReceipts then begin
    Param:=Provider.Params.ParamByName('CLIENT_ID');
    if not Param.Empty then begin
      with FReceiptsFrame do begin
        ResizeToolbars;
        AccountId:=Param.Value;
        UserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        Surname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        Name:=Self.Provider.Params.ParamByName('NAME').Value;
        Patronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('ACCOUNT_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControlAccount.ActivePage=TabSheetAccountCharges then begin
    Param:=Provider.Params.ParamByName('CLIENT_ID');
    if not Param.Empty then begin
      with FChargesFrame do begin
        ResizeToolbars;
        AccountId:=Param.Value;
        UserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        Surname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        Name:=Self.Provider.Params.ParamByName('NAME').Value;
        Patronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('ACCOUNT_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

end;

procedure TBisTaxiDataClientEditForm.PageControlMessagesChange(Sender: TObject);
var
  Param: TBisParam;
begin

  if PageControlMessages.ActivePage=TabSheetInMessages then begin
    Param:=Provider.Params.ParamByName('CLIENT_ID');
    if not Param.Empty then begin
      with FInMessagesFrame do begin
        ResizeToolbars;
        SenderId:=Param.Value;
        SenderUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        SenderSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        SenderName:=Self.Provider.Params.ParamByName('NAME').Value;
        SenderPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        Contact:=Self.Provider.Params.ParamByName('PHONE').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('SENDER_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControlMessages.ActivePage=TabSheetOutMessages then begin
    Param:=Provider.Params.ParamByName('CLIENT_ID');
    if not Param.Empty then begin
      with FOutMessagesFrame do begin
        ResizeToolbars;
        RecipientId:=Param.Value;
        RecipientUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        RecipientSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        RecipientName:=Self.Provider.Params.ParamByName('NAME').Value;
        RecipientPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        Contact:=Self.Provider.Params.ParamByName('PHONE').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('RECIPIENT_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

end;

procedure TBisTaxiDataClientEditForm.PageControlCallsChange(Sender: TObject);
var
  Param: TBisParam;
begin

  if PageControlCalls.ActivePage=TabSheetInCalls then begin
    Param:=Provider.Params.ParamByName('CLIENT_ID');
    if not Param.Empty then begin
      with FInCallsFrame do begin
        ResizeToolbars;
        CallerId:=Param.Value;
        CallerUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        CallerSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        CallerName:=Self.Provider.Params.ParamByName('NAME').Value;
        CallerPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        CallerPhone:=Self.Provider.Params.ParamByName('PHONE').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('CALLER_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControlCalls.ActivePage=TabSheetOutCalls then begin
    Param:=Provider.Params.ParamByName('CLIENT_ID');
    if not Param.Empty then begin
      with FOutCallsFrame do begin
        ResizeToolbars;
        AcceptorId:=Param.Value;
        AcceptorUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        AcceptorSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        AcceptorName:=Self.Provider.Params.ParamByName('NAME').Value;
        AcceptorPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        AcceptorPhone:=Self.Provider.Params.ParamByName('PHONE').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('ACCEPTOR_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

end;

procedure TBisTaxiDataClientEditForm.PageControlChange(Sender: TObject);
var
  Param: TBisParam;
begin

  if PageControl.ActivePage=TabSheetPhones then begin
    Param:=Provider.Params.ParamByName('CLIENT_ID');
    if not Param.Empty then begin
      with FPhonesFrame do begin
        ResizeToolbars;
        ClientId:=Param.Value;
        UserName:=Self.Provider.Params.ParamByName('USER_NAME').AsString;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('CLIENT_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControl.ActivePage=TabSheetAccount then begin
    if (Mode in [emUpdate,emDelete,emView]) then
      SetActualBalance;
    PageControlAccountChange(nil);
  end;

  if PageControl.ActivePage=TabSheetDiscounts then begin
    Param:=Provider.Params.ParamByName('CLIENT_ID');
    if not Param.Empty then begin
      with FDiscountsFrame do begin
        ResizeToolbars;
        ClientId:=Param.Value;
        UserName:=Self.Provider.Params.ParamByName('USER_NAME').AsString;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('CLIENT_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControl.ActivePage=TabSheetMessages then begin
    PageControlMessagesChange(nil);
  end;

  if PageControl.ActivePage=TabSheetCalls then begin
    PageControlCallsChange(nil);
  end;

  if PageControl.ActivePage=TabSheetOrders then begin
    Param:=Provider.Params.ParamByName('CLIENT_ID');
    if not Param.Empty then begin
      with FOrdersFrame do begin
        ResizeToolbars;
        with Provider do begin
          FilterGroups.Clear;
          with FilterGroups.Add do begin
         {   Filters.Add('PARENT_ID',fcIsNull,Null);
            Filters.Add('DATE_HISTORY',fcIsNull,Null); }
            Filters.Add('WHO_HISTORY_ID',fcIsNull,Null);
            Filters.Add('CLIENT_ID',fcEqual,Param.Value).CheckCase:=true;
          end;
        end;
        OpenRecords;
      end;
    end;
  end;

  if PageControl.ActivePage=TabSheetChilds then begin
    Param:=Provider.Params.ParamByName('CLIENT_ID');
    if not Param.Empty then begin
      with FChildsFrame do begin
        ResizeToolbars;
        ClientId:=Param.Value;
        UserName:=Self.Provider.Params.ParamByName('USER_NAME').AsString;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('CLIENT_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

end;

function TBisTaxiDataClientEditForm.GetClientUserName(VisibleCursor: Boolean): String;
var
  P: TBisProvider;
begin
  Result:='';
  P:=TBisProvider.Create(nil);
  try
    P.WithWaitCursor:=VisibleCursor;
    P.StopException:=false;
    P.ProviderName:='GET_CLIENT_USER_NAME';
    P.Params.AddInvisible('USER_NAME',ptInputOutput);
    try
      P.Execute;
      if P.Success then
        Result:=P.Params.Find('USER_NAME').AsString;
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  finally
    P.Free;
  end;
end;

procedure TBisTaxiDataClientEditForm.ButtonUserNameClick(Sender: TObject);
begin
  Provider.Params.ParamByName('USER_NAME').Value:=GetClientUserName(true);
end;


end.
