unit BisTaxiDataReceiptEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList, Menus, ActnPopup,
  BisFm, BisDataFm, BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataReceiptEditForm = class(TBisDataEditForm)                                                  
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelSum: TLabel;
    EditSum: TEdit;
    LabelAccount: TLabel;
    LabelDateReceipt: TLabel;
    DateTimePickerReceipt: TDateTimePicker;
    DateTimePickerReceiptTime: TDateTimePicker;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelWho: TLabel;
    EditWho: TEdit;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    ButtonWho: TButton;
    PopupAccount: TPopupActionBar;
    MenuItemAccounts: TMenuItem;
    MenuItemDrivers: TMenuItem;
    MenuItemClients: TMenuItem;
    LabelFirm: TLabel;
    ComboBoxFirm: TComboBox;
    procedure ButtonAccountClick(Sender: TObject);
    procedure PopupAccountPopup(Sender: TObject);
    procedure MenuItemAccountsClick(Sender: TObject);
    procedure MenuItemDriversClick(Sender: TObject);
    procedure MenuItemClientsClick(Sender: TObject);
  private
    FShowAnotherFirms: Boolean;
    function CanSelectAccount: Boolean;
    procedure SelectAccount;
    function CanSelectDriver: Boolean;
    procedure SelectDriver;
    function CanSelectClient: Boolean;
    procedure SelectClient;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
  end;

  TBisTaxiDataReceiptEditFormIface=class(TBisDataEditFormIface)
  private
    FShowAnotherFirms: Boolean;
  protected
    function CreateForm: TBisForm; override;  
  public
    constructor Create(AOwner: TComponent); override;

    property ShowAnotherFirms: Boolean read FShowAnotherFirms write FShowAnotherFirms; 
  end;

  TBisTaxiDataReceiptViewFormIface=class(TBisTaxiDataReceiptEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataReceiptInsertFormIface=class(TBisTaxiDataReceiptEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataReceiptUpdateFormIface=class(TBisTaxiDataReceiptEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataReceiptDeleteFormIface=class(TBisTaxiDataReceiptEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataReceiptEditForm: TBisTaxiDataReceiptEditForm;

implementation

uses BisUtils, BisTaxiConsts, BisCore,
     BisParamEditDataSelect, BisIfaces, BisDataSet, BisFilterGroups,
     BisDesignDataAccountsFm,
     BisTaxiDataReceiptTypesFm, BisTaxiDataDriversFm, BisTaxiDataClientsFm;

{$R *.dfm}

{ TBisTaxiDataReceiptEditFormIface }

constructor TBisTaxiDataReceiptEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataReceiptEditForm;
  with Params do begin
    AddKey('RECEIPT_ID').Older('OLD_RECEIPT_ID');
    AddInvisible('USER_NAME');
    AddInvisible('SURNAME');
    AddInvisible('NAME');
    AddInvisible('PATRONYMIC');
    AddInvisible('ORDER_ID');
    with AddComboBoxDataSelect('RECEIPT_TYPE_ID','ComboBoxType','LabelType','',
                               TBisTaxiDataReceiptTypesFormIface,'RECEIPT_TYPE_NAME',true,false,'','NAME') do begin
      FilterGroups.Add.Filters.Add('VISIBLE',fcEqual,1);
    end;
    with AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                           TBisDesignDataAccountsFormIface,'USER_NAME;SURNAME;NAME;PATRONYMIC',true,false) do begin
      DataAliasFormat:='%s - %s %s %s';
    end;
    AddComboBoxDataSelect('FIRM_ID','ComboBoxFirm','LabelFirm',
                          'S_OFFICES','FIRM_SMALL_NAME',false,false,'','SMALL_NAME');
    AddEditFloat('SUM_RECEIPT','EditSum','LabelSum',true);
    AddEditDateTime('DATE_RECEIPT','DateTimePickerReceipt','DateTimePickerReceiptTime','LabelDateReceipt',true).ExcludeModes([emFilter]);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditDataSelect('WHO_CREATE_ID','EditWho','LabelWho','ButtonWho',
                       TBisDesignDataAccountsFormIface,'WHO_USER_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes(AllParamEditModes);
  end;
end;

function TBisTaxiDataReceiptEditFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if FShowAnotherFirms then begin
      if TBisTaxiDataReceiptEditForm(Result).Mode=emFilter then
        TBisTaxiDataReceiptEditForm(Result).FShowAnotherFirms:=FShowAnotherFirms;
    end;
  end;
end;

{ TBisTaxiDataReceiptViewFormIface }

constructor TBisTaxiDataReceiptViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='�������� �����������';
end;

{ TBisTaxiDataReceiptInsertFormIface }

constructor TBisTaxiDataReceiptInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Permissions.Enabled:=true;
  ProviderName:='I_RECEIPT';
  ParentProviderName:='S_RECEIPTS';
  Caption:='�������� �����������';
  SMessageSuccess:='����������� ������� ���������.';
end;

{ TBisTaxiDataReceiptUpdateFormIface }

constructor TBisTaxiDataReceiptUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_RECEIPT';
  Caption:='�������� �����������';
end;

{ TBisTaxiDataReceiptDeleteFormIface }

constructor TBisTaxiDataReceiptDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_RECEIPT';
  Caption:='������� �����������';
end;

{ TBisTaxiDataReceiptEditForm }

constructor TBisTaxiDataReceiptEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowAnotherFirms:=VarIsNull(Core.FirmId);
end;

procedure TBisTaxiDataReceiptEditForm.BeforeShow;
var
  D: TDateTime;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      D:=Core.ServerDate;
      Find('DATE_RECEIPT').SetNewValue(D);
      Find('WHO_CREATE_ID').SetNewValue(Core.AccountId);
      Find('WHO_USER_NAME').SetNewValue(Core.AccountUserName);
      Find('DATE_CREATE').SetNewValue(D);
      Find('FIRM_ID').SetNewValue(Core.FirmId);
      Find('FIRM_SMALL_NAME').SetNewValue(Core.FirmSmallName);
    end;
  end;

  Provider.ParamByName('FIRM_ID').Enabled:=FShowAnotherFirms and not (Mode=emDelete);

  UpdateButtonState;
end;

procedure TBisTaxiDataReceiptEditForm.ButtonAccountClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=PanelControls.ClientToScreen(Point(ButtonAccount.Left,ButtonAccount.Top+ButtonAccount.Height));
  PopupAccount.Popup(Pt.X,Pt.Y);
end;

function TBisTaxiDataReceiptEditForm.CanSelectAccount: Boolean;
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

function TBisTaxiDataReceiptEditForm.CanSelectDriver: Boolean;
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

function TBisTaxiDataReceiptEditForm.CanSelectClient: Boolean;
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

procedure TBisTaxiDataReceiptEditForm.SelectAccount;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisDesignDataAccountsFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectAccount then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('ACCOUNT_ID'));
    AIface:=TBisDesignDataAccountsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ACCOUNT_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('ACCOUNT_ID').Value;
        Provider.Params.ParamByName('USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName('SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        P1:=Provider.Params.ParamByName('USER_NAME;SURNAME;NAME;PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataReceiptEditForm.SelectDriver;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataDriversFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectDriver then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('ACCOUNT_ID'));
    AIface:=TBisTaxiDataDriversFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='DRIVER_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('DRIVER_ID').Value;
        Provider.Params.ParamByName('USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName('SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        P1:=Provider.Params.ParamByName('USER_NAME;SURNAME;NAME;PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataReceiptEditForm.SelectClient;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataClientsFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectClient then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('ACCOUNT_ID'));
    AIface:=TBisTaxiDataClientsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('ID').Value;
        Provider.Params.ParamByName('USER_NAME').Value:=DS.FieldByName('NEW_NAME').Value;
        Provider.Params.ParamByName('SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        P1:=Provider.Params.ParamByName('USER_NAME;SURNAME;NAME;PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataReceiptEditForm.PopupAccountPopup(Sender: TObject);
begin
  MenuItemAccounts.Enabled:=CanSelectAccount;
  MenuItemDrivers.Enabled:=CanSelectDriver;
  MenuItemClients.Enabled:=CanSelectClient;
end;

procedure TBisTaxiDataReceiptEditForm.MenuItemAccountsClick(Sender: TObject);
begin
  SelectAccount;
end;

procedure TBisTaxiDataReceiptEditForm.MenuItemClientsClick(Sender: TObject);
begin
  SelectClient;
end;

procedure TBisTaxiDataReceiptEditForm.MenuItemDriversClick(Sender: TObject);
begin
  SelectDriver;
end;

end.
