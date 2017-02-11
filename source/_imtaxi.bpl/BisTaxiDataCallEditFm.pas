unit BisTaxiDataCallEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList, Menus, ActnPopup, Buttons,
  BisFm, BisDataFm, BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataCallViewMode=(vmFull,vmIncoming,vmOutgoing);

  TBisTaxiDataCallEditForm = class(TBisDataEditForm)
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    LabelDirection: TLabel;
    ComboBoxDirection: TComboBox;
    LabelCreator: TLabel;
    EditCreator: TEdit;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    DateTimePickerBeginTime: TDateTimePicker;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
    DateTimePickerEndTime: TDateTimePicker;
    LabelFirm: TLabel;
    ComboBoxFirm: TComboBox;
    LabelCallResult: TLabel;
    ComboBoxCallResult: TComboBox;
    LabelTypeEnd: TLabel;
    ComboBoxTypeEnd: TComboBox;
    GroupBoxCaller: TGroupBox;
    LabelCaller: TLabel;
    EditCaller: TEdit;
    ButtonCaller: TButton;
    LabelCallerPhone: TLabel;
    EditCallerPhone: TEdit;
    BitBtnCallerLoad: TBitBtn;
    BitBtnCallerSave: TBitBtn;
    BitBtnCallerClear: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    LabelCallerAudioData: TLabel;
    GroupBoxAcceptor: TGroupBox;
    LabelAcceptor: TLabel;
    LabelAcceptorPhone: TLabel;
    LabelAcceptorAudoData: TLabel;
    EditAcceptor: TEdit;
    ButtonAcceptor: TButton;
    EditAcceptorPhone: TEdit;
    BitBtnAcceptorLoad: TBitBtn;
    BitBtnAcceptorSave: TBitBtn;
    BitBtnAcceptorClear: TBitBtn;
    PopupAccount: TPopupActionBar;
    MenuItemAccounts: TMenuItem;
    MenuItemDrivers: TMenuItem;
    MenuItemClients: TMenuItem;
    MenuItemDispatchers: TMenuItem;
    LabelDateFound: TLabel;
    DateTimePickerFound: TDateTimePicker;
    DateTimePickerFoundTime: TDateTimePicker;
    procedure BitBtnCallerClearClick(Sender: TObject);
    procedure BitBtnCallerLoadClick(Sender: TObject);
    procedure BitBtnCallerSaveClick(Sender: TObject);
    procedure BitBtnAcceptorLoadClick(Sender: TObject);
    procedure BitBtnAcceptorSaveClick(Sender: TObject);
    procedure BitBtnAcceptorClearClick(Sender: TObject);
    procedure ButtonCallerClick(Sender: TObject);
    procedure PopupAccountPopup(Sender: TObject);
    procedure MenuItemAccountsClick(Sender: TObject);
    procedure ButtonAcceptorClick(Sender: TObject);
    procedure MenuItemDriversClick(Sender: TObject);
    procedure MenuItemClientsClick(Sender: TObject);
    procedure MenuItemDispatchersClick(Sender: TObject);
  private
    FLastButton: TButton;
    procedure UpdateButtons;
    function CanSelectAccount: Boolean;
    procedure SelectAccount(Alias: String);
    function CanSelectDriver: Boolean;
    procedure SelectDriver(Alias: String);
    function CanSelectClient: Boolean;
    procedure SelectClient(Alias: String);
    function CanSelectDispatcher: Boolean;
    procedure SelectDispatcher(Alias: String);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisTaxiDataCallEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCallViewFormIface=class(TBisTaxiDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCallInsertFormIface=class(TBisTaxiDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCallUpdateFormIface=class(TBisTaxiDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCallDeleteFormIface=class(TBisTaxiDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCallEditForm: TBisTaxiDataCallEditForm;

function GetDirectionByIndex(Index: Integer): String;
function GetTypeEndByIndex(Index: Integer): String;

implementation

uses BisUtils, BisCore, BisFilterGroups, BisParamEditDataSelect,
     BisProvider, BisIfaces, BisDataSet,
     BisTaxiConsts, BisTaxiDataCallResultsFm, BisTaxiDataDriversFm,
     BisTaxiDataDispatchersFm, BisTaxiDataClientsFm;

{$R *.dfm}

function GetDirectionByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='входящий';
    1: Result:='исходящий';
  end;
end;

function GetTypeEndByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='завершено сервером';
    1: Result:='завершено вызывающим';
    2: Result:='завершено принимающим';
    3: Result:='отменено сервером';
    4: Result:='отменено вызывающим';
    5: Result:='отменено принимающим';
    6: Result:='время истекло';
  end;
end;

{ TBisTaxiDataCallEditFormIface }

constructor TBisTaxiDataCallEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCallEditForm;
  with Params do begin
    AddKey('CALL_ID').Older('OLD_CALL_ID');
    AddInvisible('LINE_ID');
    AddInvisible('OPERATOR_ID');
    AddInvisible('OPERATOR_NAME');
    AddInvisible('ORDER_ID');
    AddInvisible('CALLER_AUDIO');
    AddInvisible('CALLER_USER_NAME');
    AddInvisible('CALLER_SURNAME');
    AddInvisible('CALLER_NAME');
    AddInvisible('CALLER_PATRONYMIC');
    AddInvisible('ACCEPTOR_USER_NAME');
    AddInvisible('ACCEPTOR_SURNAME');
    AddInvisible('ACCEPTOR_NAME');
    AddInvisible('ACCEPTOR_PATRONYMIC');
    AddInvisible('ACCEPTOR_AUDIO');

    AddComboBoxIndex('DIRECTION','ComboBoxDirection','LabelDirection',true);
    with AddEditDataSelect('CALLER_ID','EditCaller','LabelCaller','ButtonCaller',
                           SClassDataAccountsFormIface,'CALLER_USER_NAME;CALLER_SURNAME;CALLER_NAME;CALLER_PATRONYMIC',
                           false,false,'ACCOUNT_ID','USER_NAME;SURNAME;NAME;PATRONYMIC') do begin
      DataAliasFormat:='%s - %s %s %s';
    end;

    AddEdit('CALLER_PHONE','EditCallerPhone','LabelCallerPhone');
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes(AllParamEditModes);
    AddEditDataSelect('CREATOR_ID','EditCreator','LabelCreator','',
                       SClassDataAccountsFormIface,'CREATOR_USER_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
    AddComboBoxDataSelect('FIRM_ID','ComboBoxFirm','LabelFirm',
                          'S_OFFICES','FIRM_SMALL_NAME',false,false,'','SMALL_NAME');
    AddComboBoxDataSelect('CALL_RESULT_ID','ComboBoxCallResult','LabelCallResult','',
                          TBisTaxiDataCallResultsFormIface,'CALL_RESULT_NAME',false,false,'','NAME');

    with AddEditDataSelect('ACCEPTOR_ID','EditAcceptor','LabelAcceptor','ButtonAcceptor',
                           SClassDataAccountsFormIface,'ACCEPTOR_USER_NAME;ACCEPTOR_SURNAME;ACCEPTOR_NAME;ACCEPTOR_PATRONYMIC',
                           false,false,'ACCOUNT_ID','USER_NAME;SURNAME;NAME;PATRONYMIC') do begin
      DataAliasFormat:='%s - %s %s %s';
    end;
    AddEdit('ACCEPTOR_PHONE','EditAcceptorPhone','LabelAcceptorPhone');
    AddEditDateTime('DATE_FOUND','DateTimePickerFound','DateTimePickerFoundTime','LabelDateFound');
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin');
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd');
    AddComboBoxIndex('TYPE_END','ComboBoxTypeEnd','LabelTypeEnd');
  end;
end;

{ TBisTaxiDataCallViewFormIface }

constructor TBisTaxiDataCallViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Просмотр вызова';
end;

{ TBisTaxiDataCallInsertFormIface }

constructor TBisTaxiDataCallInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CALL';
  Caption:='Создать вызов';
end;

{ TBisTaxiDataCallUpdateFormIface }

constructor TBisTaxiDataCallUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CALL';
  Caption:='Изменить вызов';
end;

{ TBisTaxiDataCallDeleteFormIface }

constructor TBisTaxiDataCallDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CALL';
  Caption:='Удалить вызов';
end;

{ TBisTaxiDataCallEditForm }

constructor TBisTaxiDataCallEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxDirection.Clear;
  for i:=0 to 1 do
    ComboBoxDirection.Items.Add(GetDirectionByIndex(i));

  ComboBoxTypeEnd.Clear;
  for i:=0 to 6 do
    ComboBoxTypeEnd.Items.Add(GetTypeEndByIndex(i));

end;

procedure TBisTaxiDataCallEditForm.Init;
begin
  inherited Init;
end;

procedure TBisTaxiDataCallEditForm.MenuItemAccountsClick(Sender: TObject);
begin
  SelectAccount(iff(FLastButton=ButtonCaller,'CALLER','ACCEPTOR'));
end;

procedure TBisTaxiDataCallEditForm.MenuItemClientsClick(Sender: TObject);
begin
  SelectClient(iff(FLastButton=ButtonCaller,'CALLER','ACCEPTOR'));
end;

procedure TBisTaxiDataCallEditForm.MenuItemDispatchersClick(Sender: TObject);
begin
  SelectDispatcher(iff(FLastButton=ButtonCaller,'CALLER','ACCEPTOR'));
end;

procedure TBisTaxiDataCallEditForm.MenuItemDriversClick(Sender: TObject);
begin
  SelectDriver(iff(FLastButton=ButtonCaller,'CALLER','ACCEPTOR'));
end;

procedure TBisTaxiDataCallEditForm.UpdateButtons;
begin
  if Mode<>emDelete then begin
    LabelCallerAudioData.Enabled:=Mode<>emFilter;
    BitBtnCallerLoad.Enabled:=Mode<>emFilter;
    BitBtnCallerSave.Enabled:=(Mode<>emFilter) and not Provider.ParamByName('CALLER_AUDIO').Empty;
    BitBtnCallerClear.Enabled:=BitBtnCallerSave.Enabled;

    LabelAcceptorAudoData.Enabled:=Mode<>emFilter;
    BitBtnAcceptorLoad.Enabled:=Mode<>emFilter;
    BitBtnAcceptorSave.Enabled:=(Mode<>emFilter) and not Provider.ParamByName('ACCEPTOR_AUDIO').Empty;
    BitBtnAcceptorClear.Enabled:=BitBtnAcceptorSave.Enabled;
  end else begin
    LabelCallerAudioData.Enabled:=false;
    BitBtnCallerLoad.Enabled:=false;
    BitBtnCallerSave.Enabled:=false;
    BitBtnCallerClear.Enabled:=false;

    LabelAcceptorAudoData.Enabled:=false;
    BitBtnAcceptorLoad.Enabled:=false;
    BitBtnAcceptorSave.Enabled:=false;
    BitBtnAcceptorClear.Enabled:=false;
  end;
end;

procedure TBisTaxiDataCallEditForm.BeforeShow;
var
  D: TDateTime;
begin
  inherited BeforeShow;

  if Mode in [emInsert,emDuplicate] then begin
    D:=Core.ServerDate;
    with Provider.Params do begin
      Find('LINE_ID').SetNewValue(GetUniqueID);
      Find('CREATOR_ID').SetNewValue(Core.AccountId);
      Find('CREATOR_USER_NAME').SetNewValue(Core.AccountUserName);
      Find('DATE_CREATE').SetNewValue(D);
      Find('FIRM_ID').SetNewValue(Core.FirmId);
      Find('FIRM_SMALL_NAME').SetNewValue(Core.FirmSmallName);
    end;
  end;

  if not VarIsNull(Core.FirmId) and (Mode<>emFilter) then
    Provider.ParamByName('FIRM_ID').Enabled:=false;

  UpdateButtons;
  UpdateButtonState;
end;

procedure TBisTaxiDataCallEditForm.BitBtnAcceptorClearClick(Sender: TObject);
begin
  Provider.ParamByName('ACCEPTOR_AUDIO').Clear;
  UpdateButtons;
end;

procedure TBisTaxiDataCallEditForm.BitBtnAcceptorLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    Provider.ParamByName('ACCEPTOR_AUDIO').LoadFromFile(OpenDialog.FileName);
    UpdateButtons;
  end;
end;

procedure TBisTaxiDataCallEditForm.BitBtnAcceptorSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then begin
    Provider.ParamByName('ACCEPTOR_AUDIO').SaveToFile(SaveDialog.FileName);
    UpdateButtons;
  end;
end;

procedure TBisTaxiDataCallEditForm.BitBtnCallerClearClick(Sender: TObject);
begin
  Provider.ParamByName('CALLER_AUDIO').Clear;
  UpdateButtons;
end;

procedure TBisTaxiDataCallEditForm.BitBtnCallerLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    Provider.ParamByName('CALLER_AUDIO').LoadFromFile(OpenDialog.FileName);
    UpdateButtons;
  end;
end;

procedure TBisTaxiDataCallEditForm.BitBtnCallerSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then begin
    Provider.ParamByName('CALLER_AUDIO').SaveToFile(SaveDialog.FileName);
    UpdateButtons;
  end;
end;

procedure TBisTaxiDataCallEditForm.ChangeParam(Param: TBisParam);
var
  P: TBisProvider;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'CALL_ID') and not Param.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_CALLS';
      with P.FieldNames do begin
        AddInvisible('CALLER_AUDIO');
        AddInvisible('ACCEPTOR_AUDIO');
      end;
      P.FilterGroups.Add.Filters.Add('CALL_ID',fcEqual,Param.Value).CheckCase:=true;
      P.Open;
      if P.Active and not P.IsEmpty then begin
        with Provider.Params do begin
          ParamByName('CALLER_AUDIO').SetNewValue(P.FieldByName('CALLER_AUDIO').Value);
          ParamByName('ACCEPTOR_AUDIO').SetNewValue(P.FieldByName('ACCEPTOR_AUDIO').Value);
        end;
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisTaxiDataCallEditForm.ButtonAcceptorClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=GroupBoxAcceptor.ClientToScreen(Point(ButtonAcceptor.Left,ButtonAcceptor.Top+ButtonAcceptor.Height));
  PopupAccount.Popup(Pt.X,Pt.Y);
  FLastButton:=ButtonAcceptor;
end;

procedure TBisTaxiDataCallEditForm.ButtonCallerClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=GroupBoxCaller.ClientToScreen(Point(ButtonCaller.Left,ButtonCaller.Top+ButtonCaller.Height));
  PopupAccount.Popup(Pt.X,Pt.Y);
  FLastButton:=ButtonCaller;
end;

procedure TBisTaxiDataCallEditForm.PopupAccountPopup(Sender: TObject);
begin
  MenuItemAccounts.Enabled:=CanSelectAccount;
//  MenuItemDispatchers.Enabled:=CanSelectDispatcher;
  MenuItemDrivers.Enabled:=CanSelectDriver;
  MenuItemClients.Enabled:=CanSelectClient;
end;

function TBisTaxiDataCallEditForm.CanSelectAccount: Boolean;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataFormIface;
begin
  AClass:=Core.FindIfaceClass(SClassDataAccountsFormIface);
  Result:=Assigned(AClass) and IsClassParent(AClass,TBisDataFormIface);
  if Result then begin
    AIface:=TBisDataFormIfaceClass(AClass).Create(nil);
    try
      AIface.Init;
      Result:=AIface.CanShow;
    finally
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataCallEditForm.SelectAccount(Alias: String);
var
  Param: TBisParamEditDataSelect;
  AClass: TBisIfaceClass;
  AIface: TBisDataFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectAccount then begin
    AClass:=Core.FindIfaceClass(SClassDataAccountsFormIface);
    if Assigned(AClass) and IsClassParent(AClass,TBisDataFormIface) then begin
      Param:=TBisParamEditDataSelect(Provider.Params.ParamByName(Alias+'_ID'));
      AIface:=TBisDataFormIfaceClass(AClass).Create(nil);
      DS:=TBisDataSet.Create(nil);
      try
        AIface.LocateFields:='ACCOUNT_ID';
        AIface.LocateValues:=Param.Value;
        if AIface.SelectInto(DS) then begin
          Param.Value:=DS.FieldByName('ACCOUNT_ID').Value;
          Provider.Params.ParamByName(Alias+'_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
          Provider.Params.ParamByName(Alias+'_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
          Provider.Params.ParamByName(Alias+'_NAME').Value:=DS.FieldByName('NAME').Value;
          Provider.Params.ParamByName(Alias+'_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
          if Mode<>emFilter then
            Provider.Params.ParamByName(Alias+'_PHONE').Value:=DS.FieldByName('PHONE').AsString;
          P1:=Provider.Params.ParamByName(Alias+'_USER_NAME;'+Alias+'_SURNAME;'+Alias+'_NAME;'+Alias+'_PATRONYMIC');
          P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
        end;
      finally
        DS.Free;
        AIface.Free;
      end;
    end;
  end;
end;

function TBisTaxiDataCallEditForm.CanSelectDriver: Boolean;
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

procedure TBisTaxiDataCallEditForm.SelectDriver(Alias: String);
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataDriversFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectDriver then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName(Alias+'_ID'));
    AIface:=TBisTaxiDataDriversFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='DRIVER_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('DRIVER_ID').Value;
        Provider.Params.ParamByName(Alias+'_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName(Alias+'_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName(Alias+'_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName(Alias+'_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        if Mode<>emFilter then
          Provider.Params.ParamByName(Alias+'_PHONE').Value:=DS.FieldByName('PHONE').AsString;
        P1:=Provider.Params.ParamByName(Alias+'_USER_NAME;'+Alias+'_SURNAME;'+Alias+'_NAME;'+Alias+'_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

function TBisTaxiDataCallEditForm.CanSelectClient: Boolean;
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

procedure TBisTaxiDataCallEditForm.SelectClient(Alias: String);
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataClientsFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectClient then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName(Alias+'_ID'));
    AIface:=TBisTaxiDataClientsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('ID').Value;
        Provider.Params.ParamByName(Alias+'_NAME').Value:=DS.FieldByName('USER_NAME').AsString;
        Provider.Params.ParamByName(Alias+'_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName(Alias+'_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName(Alias+'_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName(Alias+'_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        if Mode<>emFilter then
          Provider.Params.ParamByName(Alias+'_PHONE').Value:=DS.FieldByName('PHONE').AsString;
        P1:=Provider.Params.ParamByName(Alias+'_USER_NAME;'+Alias+'_SURNAME;'+Alias+'_NAME;'+Alias+'_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

function TBisTaxiDataCallEditForm.CanSelectDispatcher: Boolean;
var
  AIface: TBisTaxiDataDispatchersFormIface;
begin
  AIface:=TBisTaxiDataDispatchersFormIface.Create(nil);
  try
    AIface.Init;
    Result:=AIface.CanShow;
  finally
    AIface.Free;
  end;
end;

procedure TBisTaxiDataCallEditForm.SelectDispatcher(Alias: String);
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataDispatchersFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectDispatcher then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName(Alias+'_ID'));
    AIface:=TBisTaxiDataDispatchersFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='DISPATCHER_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('DISPATCHER_ID').Value;
        Provider.Params.ParamByName(Alias+'_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName(Alias+'_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName(Alias+'_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName(Alias+'_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
//        if Mode<>emFilter then
//          Provider.Params.ParamByName(Alias+'_PHONE').Value:=DS.FieldByName('PHONE').AsString; need internal number
        P1:=Provider.Params.ParamByName(Alias+'_USER_NAME;'+Alias+'_SURNAME;'+Alias+'_NAME;'+Alias+'_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;


end.
