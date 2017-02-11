unit BisTaxiDataInMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList, Menus, ActnPopup,
  BisDataFm, BisDataEditFm, BisParam,
  BisMessDataInMessageEditFm, 
  BisControls;
                                                                                                            
type
  TBisTaxiDataInMessageEditForm = class(TBisMessDataInMessageEditForm)
    PopupAccount: TPopupActionBar;
    MenuItemAccounts: TMenuItem;
    MenuItemDrivers: TMenuItem;
    MenuItemClients: TMenuItem;
    procedure ButtonSenderClick(Sender: TObject);
    procedure PopupAccountPopup(Sender: TObject);
    procedure MenuItemAccountsClick(Sender: TObject);
    procedure MenuItemDriversClick(Sender: TObject);
    procedure MenuItemClientsClick(Sender: TObject);
  private
    function CanSelectAccount: Boolean;
    procedure SelectAccount;
    function CanSelectDriver: Boolean;
    procedure SelectDriver;
    function CanSelectClient: Boolean;
    procedure SelectClient;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataInMessageEditFormIface=class(TBisMessDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataInMessageViewFormIface=class(TBisTaxiDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataInMessageInsertFormIface=class(TBisTaxiDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataInMessageUpdateFormIface=class(TBisTaxiDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataInMessageDeleteFormIface=class(TBisTaxiDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataInMessageEditForm: TBisTaxiDataInMessageEditForm;

implementation

uses BisUtils, BisCore, BisFilterGroups, BisTaxiConsts,
     BisParamEditDataSelect, BisIfaces, BisDataSet,
     BisDesignDataAccountsFm,
     BisTaxiDataDriversFm, BisTaxiDataClientsFm;

{$R *.dfm}

{ TBisTaxiDataInMessageEditFormIface }

constructor TBisTaxiDataInMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataInMessageEditForm;
  Params.AddInvisible('ORDER_ID');
end;

{ TBisTaxiDataInMessageViewFormIface }

constructor TBisTaxiDataInMessageViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisMessDataInMessageViewFormIface.CreateInited(nil) do begin
    try
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataInMessageInsertFormIface }

constructor TBisTaxiDataInMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisMessDataInMessageInsertFormIface.CreateInited(nil) do begin
    try
      Self.ProviderName:=ProviderName;
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataInMessageUpdateFormIface }

constructor TBisTaxiDataInMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisMessDataInMessageUpdateFormIface.CreateInited(nil) do begin
    try
      Self.ProviderName:=ProviderName;
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataInMessageDeleteFormIface }

constructor TBisTaxiDataInMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisMessDataInMessageDeleteFormIface.CreateInited(nil) do begin
    try
      Self.ProviderName:=ProviderName;
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataInMessageEditForm }

constructor TBisTaxiDataInMessageEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisTaxiDataInMessageEditForm.ButtonSenderClick(Sender: TObject);
var
  Pt: TPoint;
begin                                
  Pt:=PanelControls.ClientToScreen(Point(ButtonSender.Left,ButtonSender.Top+ButtonSender.Height));
  PopupAccount.Popup(Pt.X,Pt.Y);
end;

function TBisTaxiDataInMessageEditForm.CanSelectAccount: Boolean;
begin
  with TBisDesignDataAccountsFormIface.CreateInited(nil) do begin
    try
      Result:=CanShow;
    finally
      Free;
    end;
  end;
end;

function TBisTaxiDataInMessageEditForm.CanSelectDriver: Boolean;
begin
  with TBisTaxiDataDriversFormIface.CreateInited(nil) do begin
    try
      Result:=CanShow;
    finally
      Free;
    end;
  end;
end;

function TBisTaxiDataInMessageEditForm.CanSelectClient: Boolean;
begin
  with TBisTaxiDataClientsFormIface.CreateInited(nil) do begin
    try
      Result:=CanShow;
    finally
      Free;
    end;
  end;
end;

procedure TBisTaxiDataInMessageEditForm.SelectAccount;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisDesignDataAccountsFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectAccount then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('SENDER_ID'));
    AIface:=TBisDesignDataAccountsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ACCOUNT_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('ACCOUNT_ID').Value;
        Provider.Params.ParamByName('SENDER_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName('SENDER_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('SENDER_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('SENDER_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        Provider.Params.ParamByName('CONTACT').Value:=DS.FieldByName('PHONE').AsString;
        P1:=Provider.Params.ParamByName('SENDER_USER_NAME;SENDER_SURNAME;SENDER_NAME;SENDER_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataInMessageEditForm.SelectDriver;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataDriversFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectDriver then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('SENDER_ID'));
    AIface:=TBisTaxiDataDriversFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='DRIVER_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('DRIVER_ID').Value;
        Provider.Params.ParamByName('SENDER_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName('SENDER_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('SENDER_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('SENDER_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        Provider.Params.ParamByName('CONTACT').Value:=DS.FieldByName('PHONE').AsString;
        P1:=Provider.Params.ParamByName('SENDER_USER_NAME;SENDER_SURNAME;SENDER_NAME;SENDER_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataInMessageEditForm.SelectClient;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataClientsFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectClient then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('SENDER_ID'));
    AIface:=TBisTaxiDataClientsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('ID').Value;
        Provider.Params.ParamByName('SENDER_NAME').Value:=DS.FieldByName('NEW_NAME').AsString;
        Provider.Params.ParamByName('SENDER_USER_NAME').Value:=DS.FieldByName('NEW_NAME').Value;
        Provider.Params.ParamByName('SENDER_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('SENDER_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('SENDER_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        Provider.Params.ParamByName('CONTACT').Value:=DS.FieldByName('PHONE').AsString;
        P1:=Provider.Params.ParamByName('SENDER_USER_NAME;SENDER_SURNAME;SENDER_NAME;SENDER_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataInMessageEditForm.PopupAccountPopup(Sender: TObject);
begin
  MenuItemAccounts.Enabled:=CanSelectAccount;
  MenuItemDrivers.Enabled:=CanSelectDriver;
  MenuItemClients.Enabled:=CanSelectClient;
end;

procedure TBisTaxiDataInMessageEditForm.MenuItemAccountsClick(Sender: TObject);
begin
  SelectAccount;
end;

procedure TBisTaxiDataInMessageEditForm.MenuItemClientsClick(Sender: TObject);
begin
  SelectClient;
end;

procedure TBisTaxiDataInMessageEditForm.MenuItemDriversClick(Sender: TObject);
begin
  SelectDriver;
end;

end.
