unit BisCallcHbookTaskDocumentsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DBCtrls, Dialogs, DB,
  BisDataGridFm, BisFieldNames;

type
  TBiCallcHbookTaskDocumentsForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoDescription: TDBMemo;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookTaskDocumentsFormIface=class(TBisDataGridFormIface)
  private
    function GetDocumentTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookTaskDocumentsForm: TBiCallcHbookTaskDocumentsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisCallcHbookTaskDocumentEditFm;

{ TBisCallcHbookTaskDocumentsFormIface }

constructor TBisCallcHbookTaskDocumentsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBiCallcHbookTaskDocumentsForm;
  InsertClass:=TBisCallcHbookTaskDocumentInsertFormIface;
  UpdateClass:=TBisCallcHbookTaskDocumentUpdateFormIface;
  DeleteClass:=TBisCallcHbookTaskDocumentDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_TASK_DOCUMENTS';
  with FieldNames do begin
    AddKey('TASK_DOCUMENT_ID');
    AddInvisible('TASK_ID');
    AddInvisible('DESCRIPTION');
    AddInvisible('DOCUMENT_TYPE');
    AddInvisible('EXTENSION');
    Add('TASK_NAME','�������',180);
    Add('NAME','������������',200);
    Add('DATE_DOCUMENT','���� ���������',70);
    AddCalculate('DOCUMENT_TYPE_NAME','��� ���������',GetDocumentTypeName,ftString,100,100);
  end;
  Orders.Add('NAME');
  Orders.Add('DATE_DOCUMENT');
end;

function TBisCallcHbookTaskDocumentsFormIface.GetDocumentTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetDocumentTypeByIndex(DataSet.FieldByName('DOCUMENT_TYPE').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;

{ TBiCallcHbookDocumentsForm }

constructor TBiCallcHbookTaskDocumentsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    DBMemoDescription.DataSource:=DataFrame.DataSource;
  end;
end;

end.