unit BisDocproHbookDocsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DBCtrls;

type
  TBisDocproHbookDocsForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoDescription: TDBMemo;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookDocsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproHbookDocsForm: TBisDocproHbookDocsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDocproHbookDocEditFm;

{ TBisDocproHbookDocsFormIface }

constructor TBisDocproHbookDocsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproHbookDocsForm;
  InsertClass:=TBisDocproHbookDocInsertFormIface;
  UpdateClass:=TBisDocproHbookDocUpdateFormIface;
  DeleteClass:=TBisDocproHbookDocDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_DOCS';
  with FieldNames do begin
    AddKey('DOC_ID');
    AddInvisible('VIEW_ID');
    AddInvisible('DESCRIPTION');
    Add('NUM','�����',60);
    Add('DATE_DOC','���� ���������',75);
    Add('NAME','������������',200);
    Add('VIEW_NAME','��� ���������',150);
  end;
  Orders.Add('DATE_DOC');
  Orders.Add('NUM');
end;

{ TBiDocproHbookDocsForm }

constructor TBisDocproHbookDocsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    DBMemoDescription.DataSource:=DataFrame.DataSource;
  end;
end;

end.
