unit BisMessDataRolesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisMessDataRolesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataRolesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessDataRolesForm: TBisMessDataRolesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisMessDataRoleEditFm;

{ TBisMessDataRolesFormIface }

constructor TBisMessDataRolesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataRolesForm;
  FilterClass:=TBisMessDataRoleEditFormIface;
  InsertClass:=TBisMessDataRoleInsertFormIface;
  UpdateClass:=TBisMessDataRoleUpdateFormIface;
  DeleteClass:=TBisMessDataRoleDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_ACCOUNTS';
  with FieldNames do begin
    AddKey('ACCOUNT_ID');
    AddInvisible('IS_ROLE');
    AddInvisible('AUTO_CREATED');
    AddInvisible('LOCKED');
    AddInvisible('DATE_CREATE');
    Add('USER_NAME','Наименование',150);
    Add('DESCRIPTION','Описание',200);
  end;
  FilterGroups.Add.Filters.Add('IS_ROLE',fcEqual,1);
  Orders.Add('USER_NAME');
end;

{ TBisMessDataRolesForm }

constructor TBisMessDataRolesForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
