unit BisDesignDataAccountRoleEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,                                           
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisDesignDataAccountRoleEditForm = class(TBisDataEditForm)
    LabelRole: TLabel;
    EditRole: TEdit;
    ButtonRole: TButton;
    LabelLogin: TLabel;
    EditLogin: TEdit;
    ButtonLogin: TButton;
    CheckBoxRefresh: TCheckBox;
  private
    { Private declarations }
  public
    procedure Execute; override;
  end;

  TBisDesignDataAccountRoleEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataAccountRoleInsertFormIface=class(TBisDesignDataAccountRoleEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataAccountRoleUpdateFormIface=class(TBisDesignDataAccountRoleEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataAccountRoleDeleteFormIface=class(TBisDesignDataAccountRoleEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataAccountRoleEditForm: TBisDesignDataAccountRoleEditForm;

implementation

uses BisDesignDataAccountsFm, BisDesignDataRolesFm, BisCore;

{$R *.dfm}

{ TBisDesignDataAccountRoleEditFormIface }

constructor TBisDesignDataAccountRoleEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataAccountRoleEditForm;
  with Params do begin
    AddEditDataSelect('ROLE_ID','EditRole','LabelRole','ButtonRole',
                      TBisDesignDataRolesFormIface,'ROLE_NAME',true,true,'ACCOUNT_ID','USER_NAME').Older('OLD_ROLE_ID');
    AddEditDataSelect('ACCOUNT_ID','EditLogin','LabelLogin','ButtonLogin',
                      TBisDesignDataAccountsFormIface,'USER_NAME',true,true).Older('OLD_ACCOUNT_ID');
  end;
end;

{ TBisDesignDataAccountRoleInsertFormIface }

constructor TBisDesignDataAccountRoleInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACCOUNT_ROLE';
end;

{ TBisDesignDataAccountRoleUpdateFormIface }

constructor TBisDesignDataAccountRoleUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACCOUNT_ROLE';
end;

{ TBisDesignDataAccountRoleDeleteFormIface }

constructor TBisDesignDataAccountRoleDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACCOUNT_ROLE';
end;

{ TBisDesignDataAccountRoleEditForm }

procedure TBisDesignDataAccountRoleEditForm.Execute;
begin
  inherited Execute;
  if CheckBoxRefresh.Checked then begin
    Core.RefreshPermissions;
    Core.ReloadInterfaces;
  end;
end;

end.
