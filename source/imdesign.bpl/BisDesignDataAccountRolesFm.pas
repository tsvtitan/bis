unit BisDesignDataAccountRolesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,                                          
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisDesignDataAccountRolesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataAccountRolesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiDesignDataAccountRolesForm: TBisDesignDataAccountRolesForm;

implementation

{$R *.dfm}

uses BisDesignDataAccountRoleEditFm;

{ TBisDesignDataAccountRolesFormIface }

constructor TBisDesignDataAccountRolesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataAccountRolesForm;
  FilterClass:=TBisDesignDataAccountRoleEditFormIface;
  InsertClass:=TBisDesignDataAccountRoleInsertFormIface;
  UpdateClass:=TBisDesignDataAccountRoleUpdateFormIface;
  DeleteClass:=TBisDesignDataAccountRoleDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_ACCOUNT_ROLES';
  with FieldNames do begin
    AddKey('ROLE_ID');
    AddKey('ACCOUNT_ID');
    Add('ROLE_NAME','����',150);
    Add('USER_NAME','�����',150);
  end;
  Orders.Add('ROLE_NAME');
  Orders.Add('USER_NAME');
end;

end.
