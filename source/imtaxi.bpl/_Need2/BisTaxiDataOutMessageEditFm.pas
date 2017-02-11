unit BisTaxiDataOutMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList, Menus, ActnPopup,
  BisFm, BisDataFm, BisDataEditFm, BisParam, BisControls;                                               

type
  TBisTaxiDataOutMessageEditForm = class(TBisDataEditForm)
    LabelRecipient: TLabel;
    EditRecipient: TEdit;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    ButtonRecipient: TButton;
    LabelDateOut: TLabel;
    DateTimePickerOut: TDateTimePicker;
    DateTimePickerOutTime: TDateTimePicker;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelContact: TLabel;
    EditContact: TEdit;
    LabelCreator: TLabel;
    EditCreator: TEdit;
    LabelPriority: TLabel;
    ComboBoxPriority: TComboBox;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    MemoText: TMemo;
    ButtonPattern: TButton;
    LabelCounter: TLabel;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    DateTimePickerBeginTime: TDateTimePicker;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
    DateTimePickerEndTime: TDateTimePicker;
    PopupAccount: TPopupActionBar;
    MenuItemAccounts: TMenuItem;
    MenuItemDrivers: TMenuItem;
    MenuItemClients: TMenuItem;
    CheckBoxDelivery: TCheckBox;
    CheckBoxFlash: TCheckBox;
    LabelFirm: TLabel;
    ComboBoxFirm: TComboBox;
    procedure MemoTextChange(Sender: TObject);
    procedure ButtonPatternClick(Sender: TObject);
    procedure ButtonRecipientClick(Sender: TObject);
    procedure PopupAccountPopup(Sender: TObject);
    procedure MenuItemAccountsClick(Sender: TObject);
    procedure MenuItemDriversClick(Sender: TObject);
    procedure MenuItemClientsClick(Sender: TObject);
  private
    FSHigh: String;
    FSNormal: String;
    FSLow: String;
    function CanSelectAccount: Boolean;
    procedure SelectAccount;
    function CanSelectDriver: Boolean;
    procedure SelectDriver;
    function CanSelectClient: Boolean;
    procedure SelectClient;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
  published
    property SHigh: String read FSHigh write FSHigh;
    property SNormal: String read FSNormal write FSNormal;
    property SLow: String read FSLow write FSLow;
  end;

  TBisTaxiDataOutMessageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOutMessageViewFormIface=class(TBisTaxiDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOutMessageInsertFormIface=class(TBisTaxiDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOutMessageUpdateFormIface=class(TBisTaxiDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOutMessageDeleteFormIface=class(TBisTaxiDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataOutMessageEditForm: TBisTaxiDataOutMessageEditForm;

function GetTypeMessageByIndex(Index: Integer): String;

implementation

uses BisUtils, BisCore, BisFilterGroups, BisTaxiConsts, BisParamEditDataSelect,
     BisProvider, BisIfaces, BisDataSet,
     BisDesignDataAccountsFm, BisMessDataPatternMessagesFm,
     BisTaxiDataReceiptTypesFm, BisTaxiDataDriversFm, BisTaxiDataClientsFm;

{$R *.dfm}

function GetTypeMessageByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='сообщение';
    1: Result:='запрос';
    2: Result:='вызов';
  end;
end;

{ TBisTaxiDataOutMessageEditFormIface }

constructor TBisTaxiDataOutMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataOutMessageEditForm;
  with Params do begin
    AddKey('OUT_MESSAGE_ID').Older('OLD_OUT_MESSAGE_ID');
    AddInvisible('LOCKED');
    AddInvisible('ORDER_ID');
    AddInvisible('CHANNEL');
    AddInvisible('DATE_DELIVERY');
    AddInvisible('DEST_PORT');
    AddInvisible('RECIPIENT_USER_NAME');
    AddInvisible('RECIPIENT_SURNAME');
    AddInvisible('RECIPIENT_NAME');
    AddInvisible('RECIPIENT_PATRONYMIC');
    AddInvisible('OPERATOR_ID');
    AddInvisible('OPERATOR_NAME');
    AddComboBoxIndex('TYPE_MESSAGE','ComboBoxType','LabelType',true);
    AddCheckBox('DELIVERY','CheckBoxDelivery');
    AddCheckBox('FLASH','CheckBoxFlash');
    AddComboBoxIndex('PRIORITY','ComboBoxPriority','LabelPriority',true);
    with AddEditDataSelect('RECIPIENT_ID','EditRecipient','LabelRecipient','ButtonRecipient',
                           TBisDesignDataAccountsFormIface,'RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC',
                           false,false,'ACCOUNT_ID','USER_NAME;SURNAME;NAME;PATRONYMIC') do begin
      DataAliasFormat:='%s - %s %s %s';
    end;
    AddEdit('CONTACT','EditContact','LabelContact',true);
    AddMemo('TEXT_OUT','MemoText','LabelCounter');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin',true);
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd');
    AddEditDateTime('DATE_OUT','DateTimePickerOut','DateTimePickerOutTime','LabelDateOut');
    AddEditDataSelect('CREATOR_ID','EditCreator','LabelCreator','',
                       TBisDesignDataAccountsFormIface,'CREATOR_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
    AddComboBoxDataSelect('FIRM_ID','ComboBoxFirm','LabelFirm',
                          'S_OFFICES','FIRM_SMALL_NAME',false,false,'','SMALL_NAME');
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes(AllParamEditModes);
  end;
end;

{ TBisTaxiDataOutMessageViewFormIface }

constructor TBisTaxiDataOutMessageViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Просмотр исходящего сообщения';
end;

{ TBisTaxiDataOutMessageInsertFormIface }

constructor TBisTaxiDataOutMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Permissions.Enabled:=true;
  ProviderName:='I_OUT_MESSAGE';
  ParentProviderName:='S_OUT_MESSAGES';
  Caption:='Создать исходящее сообщение';
  SMessageSuccess:='Сообщение успешно создано.';
  with Params do begin
    Find('TYPE_MESSAGE').Value:=0;
  end;
end;

{ TBisTaxiDataOutMessageUpdateFormIface }

constructor TBisTaxiDataOutMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_OUT_MESSAGE';
  Caption:='Изменить исходящее сообщение';
end;

{ TBisTaxiDataOutMessageDeleteFormIface }

constructor TBisTaxiDataOutMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_OUT_MESSAGE';
  Caption:='Удалить исходящее сообщение';
end;

{ TBisTaxiDataOutMessageEditForm }

constructor TBisTaxiDataOutMessageEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxType.Clear;
  for i:=0 to 2 do
    ComboBoxType.Items.Add(GetTypeMessageByIndex(i));

  FSHigh:='высокий';
  FSNormal:='нормальный';
  FSLow:='низкий';

end;

procedure TBisTaxiDataOutMessageEditForm.Init;
var
  OldIndex: Integer;
begin
  inherited Init;
  OldIndex:=ComboBoxPriority.ItemIndex;
  try
    ComboBoxPriority.Items.Strings[0]:=FSHigh;
    ComboBoxPriority.Items.Strings[1]:=FSNormal;
    ComboBoxPriority.Items.Strings[2]:=FSLow;
  finally
    ComboBoxPriority.ItemIndex:=OldIndex;
  end;
end;

procedure TBisTaxiDataOutMessageEditForm.MemoTextChange(Sender: TObject);
begin
  LabelCounter.Caption:=IntToStr(Length(MemoText.Lines.Text));
end;

procedure TBisTaxiDataOutMessageEditForm.BeforeShow;
var
  D: TDateTime;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    D:=Core.ServerDate;
    ActiveControl:=EditContact;
    with Provider.Params do begin
      Find('TYPE_MESSAGE').SetNewValue(0);
      Find('PRIORITY').SetNewValue(2);
      Find('DATE_BEGIN').SetNewValue(D);
      Find('CREATOR_ID').SetNewValue(Core.AccountId);
      Find('CREATOR_NAME').SetNewValue(Core.AccountUserName);
      Find('DATE_CREATE').SetNewValue(D);
      Find('FIRM_ID').SetNewValue(Core.FirmId);
      Find('FIRM_SMALL_NAME').SetNewValue(Core.FirmSmallName);
    end;
  end;

  if not VarIsNull(Core.FirmId) and (Mode<>emFilter) then
    Provider.ParamByName('FIRM_ID').Enabled:=false;

  LabelCounter.Enabled:=not (Mode in [emDelete]);
  ButtonPattern.Enabled:=LabelCounter.Enabled;
  UpdateButtonState;
  MemoTextChange(nil);
end;

procedure TBisTaxiDataOutMessageEditForm.ButtonPatternClick(Sender: TObject);
var
  AIface: TBisMessDataPatternMessagesFormIface;
  P: TBisProvider;
begin
  AIface:=TBisMessDataPatternMessagesFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.Init;
    if AIface.SelectInto(P) then begin
      if P.Active and not P.Empty then begin
        Provider.Params.ParamByName('TEXT_OUT').Value:=P.FieldByName('TEXT_PATTERN').Value;
        MemoTextChange(nil);
      end;
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisTaxiDataOutMessageEditForm.ButtonRecipientClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=PanelControls.ClientToScreen(Point(ButtonRecipient.Left,ButtonRecipient.Top+ButtonRecipient.Height));
  PopupAccount.Popup(Pt.X,Pt.Y);
end;

procedure TBisTaxiDataOutMessageEditForm.ChangeParam(Param: TBisParam);
begin
  inherited ChangeParam(Param);
end;

function TBisTaxiDataOutMessageEditForm.CanSelectAccount: Boolean;
var
  AIface: TBisDesignDataAccountsFormIface;
begin
  AIface:=TBisDesignDataAccountsFormIface.Create(nil);
  try
    AIface.Init;
    Result:=AIface.CanShow;
  finally
    AIface.Free;
  end;
end;

function TBisTaxiDataOutMessageEditForm.CanSelectDriver: Boolean;
var
  AIface: TBisTaxiDataDriversFormIface;
begin
  AIface:=TBisTaxiDataDriversFormIface.Create(nil);
  try
    AIface.Init;
    Result:=AIface.CanShow;
  finally
    AIface.Free;
  end;
end;

function TBisTaxiDataOutMessageEditForm.CanSelectClient: Boolean;
var
  AIface: TBisTaxiDataClientsFormIface;
begin
  AIface:=TBisTaxiDataClientsFormIface.Create(nil);
  try
    AIface.Init;
    Result:=AIface.CanShow;
  finally
    AIface.Free;
  end;
end;

procedure TBisTaxiDataOutMessageEditForm.SelectAccount;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisDesignDataAccountsFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectAccount then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('RECIPIENT_ID'));
    AIface:=TBisDesignDataAccountsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ACCOUNT_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('ACCOUNT_ID').Value;
        Provider.Params.ParamByName('RECIPIENT_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName('RECIPIENT_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('RECIPIENT_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('RECIPIENT_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        Provider.Params.ParamByName('CONTACT').Value:=DS.FieldByName('PHONE').Value;
        P1:=Provider.Params.ParamByName('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataOutMessageEditForm.SelectDriver;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataDriversFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectDriver then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('RECIPIENT_ID'));
    AIface:=TBisTaxiDataDriversFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='DRIVER_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('DRIVER_ID').Value;
        Provider.Params.ParamByName('RECIPIENT_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName('RECIPIENT_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('RECIPIENT_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('RECIPIENT_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        Provider.Params.ParamByName('CONTACT').Value:=DS.FieldByName('PHONE').Value;
        P1:=Provider.Params.ParamByName('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataOutMessageEditForm.SelectClient;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataClientsFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectClient then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('RECIPIENT_ID'));
    AIface:=TBisTaxiDataClientsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('ID').Value;
        Provider.Params.ParamByName('RECIPIENT_USER_NAME').Value:=DS.FieldByName('NEW_NAME').Value;
        Provider.Params.ParamByName('RECIPIENT_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('RECIPIENT_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('RECIPIENT_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        Provider.Params.ParamByName('CONTACT').Value:=DS.FieldByName('PHONE').Value;
        P1:=Provider.Params.ParamByName('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataOutMessageEditForm.PopupAccountPopup(Sender: TObject);
begin
  MenuItemAccounts.Enabled:=CanSelectAccount;
  MenuItemDrivers.Enabled:=CanSelectDriver;
  MenuItemClients.Enabled:=CanSelectClient;
end;

procedure TBisTaxiDataOutMessageEditForm.MenuItemAccountsClick(Sender: TObject);
begin
  SelectAccount;
end;

procedure TBisTaxiDataOutMessageEditForm.MenuItemClientsClick(Sender: TObject);
begin
  SelectClient;
end;

procedure TBisTaxiDataOutMessageEditForm.MenuItemDriversClick(Sender: TObject);
begin
  SelectDriver;
end;

end.
