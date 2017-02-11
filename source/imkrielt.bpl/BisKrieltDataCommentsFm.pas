unit BisKrieltDataCommentsFm;
                                                                                                      
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DBCtrls,
  BisFm, BisDataGridFm, BisDataTreeFm, BisDataFrm, BisDataTreeFrm, BisDataEditFm;

type
  TBisKrieltDataCommentsFrame=class(TBisDataTreeFrame)
  private
    FArticleId: Variant;
    FArticleTitle: String;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  end;

  TBisKrieltDataCommentsForm = class(TBisDataTreeForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoText: TDBMemo;
  private
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataCommentsFormIface=class(TBisDataTreeFormIface)
  private
    FArticleId: Variant;
    FArticleTitle: String;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property ArticleId: Variant read FArticleId write FArticleId;
    property ArticleTitle: String read FArticleTitle write FArticleTitle;
  end;

var
  BisKrieltDataCommentsForm: TBisKrieltDataCommentsForm;

implementation

uses
     BisParam, BisFieldNames, BisOrders, BisParamEditDataSelect,
     BisKrieltDataCommentEditFm;

{$R *.dfm}


{ TBisKrieltDataCommentsFrame }

procedure TBisKrieltDataCommentsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  ParamId: TBisParamEditDataSelect;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    ParamId:=TBisParamEditDataSelect(AIface.Params.Find('ARTICLE_ID'));
    if Assigned(ParamId) and not VarIsNull(FArticleId) then begin
      ParamId.Value:=FArticleId;
      with AIface do begin
        Params.ParamByName('ARTICLE_TITLE').Value:=FArticleTitle;
      end;
      ParamId.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

{ TBisKrieltDataCommentsFormIface }

constructor TBisKrieltDataCommentsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataCommentsForm;
  FilterClass:=TBisKrieltDataCommentEditFormIface;
  InsertClasses.Add(TBisKrieltDataCommentInsertFormIface);
  InsertClasses.Add(TBisKrieltDataCommentInsertChildFormIface);
  UpdateClass:=TBisKrieltDataCommentUpdateFormIface;
  DeleteClass:=TBisKrieltDataCommentDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_COMMENTS';
  with FieldNames do begin
    AddKey('COMMENT_ID');
    AddParentKey('PARENT_ID');
    AddInvisible('PARENT_TITLE');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('ARTICLE_ID');
    AddInvisible('ARTICLE_TITLE');
    AddInvisible('COMMENT_TEXT');
    Add('USER_NAME','������� ������',150);
    Add('DATE_COMMENT','���� �����������',120);
    Add('TITLE','���������',250);
    AddCheckBox('VISIBLE','�������',35);
  end;
  Orders.Add('LEVEL');
  Orders.Add('DATE_COMMENT',otDesc);

  FArticleId:=Null;
  FArticleTitle:='';
end;

function TBisKrieltDataCommentsFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisKrieltDataCommentsForm(Result) do begin
      TBisKrieltDataCommentsFrame(DataFrame).FArticleId:=FArticleId;
      TBisKrieltDataCommentsFrame(DataFrame).FArticleTitle:=FArticleTitle;
    end;
  end;
end;

{ TBisKrieltDataCommentsForm }

constructor TBisKrieltDataCommentsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    DBMemoText.DataSource:=DataFrame.DataSource;
  end;
end;

class function TBisKrieltDataCommentsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltDataCommentsFrame;
end;

end.