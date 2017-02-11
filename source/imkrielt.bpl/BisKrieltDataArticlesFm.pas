unit BisKrieltDataArticlesFm;
                                                                                                                
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB, DBCtrls,
  BisFm, BisDataFrm, BisFieldNames,
  BisDataGridFm, BisKrieltDataArticlesFrm;

type
  TBisKrieltDataArticlesForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoExcerpt: TDBMemo;
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataArticlesFormIface=class(TBisDataGridFormIface)
  private
    function GetSectionName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataInputTypesForm: TBisKrieltDataArticlesForm;

implementation

{$R *.dfm}

uses
    BisFilterGroups, BisOrders,
    BisKrieltDataArticleEditFm;

{ TBisKrieltDataArticlesFormIface }

constructor TBisKrieltDataArticlesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataArticlesForm;
  FilterClass:=TBisKrieltDataArticleFilterFormIface;
  InsertClass:=TBisKrieltDataArticleInsertFormIface;
  UpdateClass:=TBisKrieltDataArticleUpdateFormIface;
  DeleteClass:=TBisKrieltDataArticleDeleteFormIface; 
  Permissions.Enabled:=true;
  ProviderName:='S_ARTICLES';
  with FieldNames do begin
    AddKey('ARTICLE_ID');
    AddInvisible('SUBJECT_ID');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('USER_NAME');
    AddInvisible('DATE_CREATE');
    AddInvisible('SECTION');
    AddInvisible('EXCERPT');
    AddInvisible('ARTICLE_TEXT');
    AddInvisible('LINK');
    AddInvisible('TAGS');
    AddInvisible('SUBJECT_NAME');
    Add('DATE_ARTICLE','���� ������',120);
    AddCalculate('SECTION_NAME','������',GetSectionName,ftString,50,60);
    Add('TITLE','���������',400);
    Add('VIEWS_COUNTER','����������',40);
  end;
  Orders.Add('DATE_ARTICLE',otDesc);
end;

function TBisKrieltDataArticlesFormIface.GetSectionName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
begin
  Result:=Null;
  if DataSet.Active then begin
    Result:=GetSectionNameByIndex(DataSet.FieldByName('SECTION').AsInteger);
  end;
end;

{ TBisKrieltDataArticlesForm }

constructor TBisKrieltDataArticlesForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    DBMemoExcerpt.DataSource:=DataFrame.DataSource;
  end;
end;

class function TBisKrieltDataArticlesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltDataArticlesFrame;
end;

end.
