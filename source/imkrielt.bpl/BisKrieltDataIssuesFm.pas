unit BisKrieltDataIssuesFm;
                                                                                                         
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, DB, BisFm, ActnList,
  BisFieldNames;

type
  TBisKrieltDataIssuesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataIssuesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataIssuesForm: TBisKrieltDataIssuesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataIssueEditFm, BisOrders;

{ TBisKrieltDataIssuesFormIface }

constructor TBisKrieltDataIssuesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataIssuesForm;
  FilterClass:=TBisKrieltDataIssueFilterFormIface;
  InsertClass:=TBisKrieltDataIssueInsertFormIface;
  UpdateClass:=TBisKrieltDataIssueUpdateFormIface;
  DeleteClass:=TBisKrieltDataIssueDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_ISSUES';
  with FieldNames do begin
    AddKey('ISSUE_ID');
    AddInvisible('PUBLISHING_ID');
    AddInvisible('DESCRIPTION');
    Add('PUBLISHING_NAME','�������',150);
    Add('NUM','�����',100);
    Add('DATE_BEGIN','���� ������',100);
    Add('DATE_END','���� ���������',100);
  end;
  Orders.Add('DATE_BEGIN',otDesc);
end;


end.
