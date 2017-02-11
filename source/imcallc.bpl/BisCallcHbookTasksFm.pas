unit BisCallcHbookTasksFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DBCtrls, Dialogs,
  BisDataGridFm;

type
  TBiCallcHbookTasksForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoDescription: TDBMemo;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookTasksFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookTasksForm: TBiCallcHbookTasksForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisCallcHbookTaskEditFm;

{ TBisCallcHbookTasksFormIface }

constructor TBisCallcHbookTasksFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBiCallcHbookTasksForm;
  InsertClass:=TBisCallcHbookTaskInsertFormIface;
  UpdateClass:=TBisCallcHbookTaskUpdateFormIface;
  DeleteClass:=TBisCallcHbookTaskDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  FilterOnShow:=true;
  ProviderName:='S_TASKS';
  with FieldNames do begin
    AddKey('TASK_ID');
    AddInvisible('DEAL_ID');
    AddInvisible('ACTION_ID');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('PERFORMER_ID');
    AddInvisible('RESULT_ID');
    AddInvisible('DESCRIPTION');
    AddInvisible('USER_NAME');
    AddInvisible('PERFORMER_USER_NAME');
    Add('DEAL_NUM','����� ����',100);
    Add('ACTION_NAME','��������',100);
    Add('DATE_CREATE','���� ��������',70);
    Add('DATE_BEGIN','���� ������',70);
    Add('DATE_END','���� ���������',70);
    Add('RESULT_NAME','���������',140);
  end;
  Orders.Add('DEAL_NUM');
  Orders.Add('DATE_CREATE');
  Orders.Add('DATE_BEGIN');
  Orders.Add('DATE_END');
end;

{ TBiCallcHbookTasksForm }

constructor TBiCallcHbookTasksForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    DBMemoDescription.DataSource:=DataFrame.DataSource;
  end;
end;

end.