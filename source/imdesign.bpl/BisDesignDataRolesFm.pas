unit BisDesignDataRolesFm;

interface

uses                                                                                                
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisDesignDataRolesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataRolesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataRolesForm: TBisDesignDataRolesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDesignDataRoleEditFm;

{ TBisDesignDataRolesFormIface }

constructor TBisDesignDataRolesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataRolesForm;
  FilterClass:=TBisDesignDataRoleEditFormIface;
  InsertClass:=TBisDesignDataRoleInsertFormIface;
  UpdateClass:=TBisDesignDataRoleUpdateFormIface;
  DeleteClass:=TBisDesignDataRoleDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_ACCOUNTS';
  with FieldNames do begin
    AddKey('ACCOUNT_ID');
    AddInvisible('IS_ROLE');
    AddInvisible('AUTO_CREATED');
    AddInvisible('LOCKED');
    AddInvisible('DATE_CREATE');
    Add('USER_NAME','������������',150);
    Add('DESCRIPTION','��������',200);
  end;
  FilterGroups.Add.Filters.Add('IS_ROLE',fcEqual,1);
  Orders.Add('USER_NAME');
end;

{ TBisDesignDataRolesForm }

constructor TBisDesignDataRolesForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.