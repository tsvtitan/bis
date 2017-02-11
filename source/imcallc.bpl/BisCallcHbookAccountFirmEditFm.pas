unit BisCallcHbookAccountFirmEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcHbookAccountFirmEditForm = class(TBisDataEditForm)
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelFirm: TLabel;
    EditFirm: TEdit;
    ButtonFirm: TButton;
  private
    { Private declarations }
  public
  end;

  TBisCallcHbookAccountFirmEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookAccountFirmInsertFormIface=class(TBisCallcHbookAccountFirmEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookAccountFirmUpdateFormIface=class(TBisCallcHbookAccountFirmEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookAccountFirmDeleteFormIface=class(TBisCallcHbookAccountFirmEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookAccountFirmEditForm: TBisCallcHbookAccountFirmEditForm;

implementation

uses BisCallcConsts, BisCore;

{$R *.dfm}

{ TBisCallcHbookAccountFirmEditFormIface }

constructor TBisCallcHbookAccountFirmEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookAccountFirmEditForm;
  with Params do begin
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassHbookAccountsFormIface,'USER_NAME',true,true).Older('OLD_ACCOUNT_ID');
    AddEditDataSelect('FIRM_ID','EditFirm','LabelFirm','ButtonFirm',
                      SIfaceClassHbookFirmsFormIface,'FIRM_SMALL_NAME',true,true,'','SMALL_NAME').Older('OLD_FIRM_ID');
  end;
end;

{ TBisCallcHbookAccountFirmInsertFormIface }

constructor TBisCallcHbookAccountFirmInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACCOUNT_FIRM';
end;

{ TBisCallcHbookAccountFirmUpdateFormIface }

constructor TBisCallcHbookAccountFirmUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACCOUNT_FIRM';
end;

{ TBisCallcHbookAccountFirmDeleteFormIface }

constructor TBisCallcHbookAccountFirmDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACCOUNT_FIRM';
end;


end.
