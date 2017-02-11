unit BisMessDataAccountsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisDataGridFm, BisFm, BisControls;

type
  TBisMessDataAccountsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisMessDataAccountsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiMessDataAccountsForm: TBisMessDataAccountsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisMessDataAccountEditFm;

{ TBisMessDataAccountsFormIface }

constructor TBisMessDataAccountsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataAccountsForm;
  FilterClass:=TBisMessDataAccountEditFormIface;
  InsertClass:=TBisMessDataAccountInsertFormIface;
  UpdateClass:=TBisMessDataAccountUpdateFormIface;
  DeleteClass:=TBisMessDataAccountDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_ACCOUNTS';
  with FieldNames do begin
    AddKey('ACCOUNT_ID');
    AddInvisible('FIRM_ID');
    AddInvisible('FIRM_SMALL_NAME');
    AddInvisible('DATE_CREATE');
    AddInvisible('PASSWORD');
    AddInvisible('DESCRIPTION');
    AddInvisible('DB_USER_NAME');
    AddInvisible('DB_PASSWORD');
    AddInvisible('IS_ROLE');
    AddInvisible('LOCKED');
    AddInvisible('AUTO_CREATED');
    AddInvisible('USER_NAME');
    Add('SURNAME','�������',120);
    Add('NAME','���',100);
    Add('PATRONYMIC','��������',120);
    Add('PHONE','�������',80);
    Add('EMAIL','����������� �����',100);
  end;
  FilterGroups.Add.Filters.Add('IS_ROLE',fcEqual,0);
  Orders.Add('SURNAME');
end;

end.
