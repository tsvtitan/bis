unit BisCallcHbookAccountGroupsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisCallcHbookAccountGroupsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookAccountGroupsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookAccountGroupsForm: TBisCallcHbookAccountGroupsForm;

implementation

{$R *.dfm}

uses BisCallcHbookAccountGroupEditFm;

{ TBisCallcHbookAccountGroupsFormIface }

constructor TBisCallcHbookAccountGroupsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookAccountGroupsForm;
  InsertClass:=TBisCallcHbookAccountGroupInsertFormIface;
  UpdateClass:=TBisCallcHbookAccountGroupUpdateFormIface;
  DeleteClass:=TBisCallcHbookAccountGroupDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_ACCOUNT_GROUPS';
  with FieldNames do begin
    AddKey('ACCOUNT_ID');
    AddKey('GROUP_ID');
    Add('USER_NAME','������� ������',150);
    Add('GROUP_NAME','�����������',150);
    Add('PRIORITY','�������',50);
  end;
  Orders.Add('USER_NAME');
  Orders.Add('PRIORITY');
  Orders.Add('GROUP_NAME');
end;

end.