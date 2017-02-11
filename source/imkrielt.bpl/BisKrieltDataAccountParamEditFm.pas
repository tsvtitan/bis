unit BisKrieltDataAccountParamEditFm;
                                                                     
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisKrieltDataAccountParamEditForm = class(TBisDataEditForm)
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelParam: TLabel;
    EditParam: TEdit;
    ButtonParam: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
  end;

  TBisKrieltDataAccountParamEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAccountParamFilterFormIface=class(TBisKrieltDataAccountParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAccountParamInsertFormIface=class(TBisKrieltDataAccountParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAccountParamUpdateFormIface=class(TBisKrieltDataAccountParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAccountParamDeleteFormIface=class(TBisKrieltDataAccountParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataAccountParamEditForm: TBisKrieltDataAccountParamEditForm;

implementation

uses BisKrieltDataParamsFm, BisKrieltConsts;

{$R *.dfm}

{ TBisKrieltDataAccountParamEditFormIface }

constructor TBisKrieltDataAccountParamEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataAccountParamEditForm;
  with Params do begin
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassDataRolesAndAccountsFormIface,'USER_NAME',true,true).Older('OLD_ACCOUNT_ID');
    AddEditDataSelect('PARAM_ID','EditParam','LabelParam','ButtonParam',
                      TBisKrieltDataParamsFormIface,'PARAM_NAME',true,true,'','NAME').Older('OLD_PARAM_ID');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisKrieltDataAccountParamFilterFormIface }

constructor TBisKrieltDataAccountParamFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataAccountParamInsertFormIface }

constructor TBisKrieltDataAccountParamInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACCOUNT_PARAM';
end;

{ TBisKrieltDataAccountParamUpdateFormIface }

constructor TBisKrieltDataAccountParamUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACCOUNT_PARAM';
end;

{ TBisKrieltDataAccountParamDeleteFormIface }

constructor TBisKrieltDataAccountParamDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACCOUNT_PARAM';
end;


end.