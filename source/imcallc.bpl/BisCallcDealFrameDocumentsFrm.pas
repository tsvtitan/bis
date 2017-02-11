unit BisCallcDealFrameDocumentsFrm;

interface

uses Classes, DB, Variants,
     BisDataGridFrm, BisDataEditFm, BisFieldNames, BisParam,
     BisCallcHbookTaskDocumentEditFm;

type
  TBisCallcDealFrameDocumentEditFormIface=class(TBisCallcHbookTaskDocumentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcDealFrameDocumentInsertFormIface=class(TBisCallcDealFrameDocumentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcDealFrameDocumentUpdateFormIface=class(TBisCallcDealFrameDocumentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcDealFrameDocumentDeleteFormIface=class(TBisCallcDealFrameDocumentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcDealFrameDocumentViewingFormIface=class(TBisCallcDealFrameDocumentEditFormIface)
  private
    FPath: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Execute; override;

    property Path: String read FPath write FPath;
  end;

  TBisCallcDealFrameDocumentsFrame=class(TBisDataGridFrame)
  private
    FPath: String;
    FTaskId: Variant;
    FTaskName: String;
    function GetDocumentTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  protected
    function CreateIface(AClass: TBisDataEditFormIfaceClass): TBisDataEditFormIface; override;
  public
    constructor Create(AOwner: TComponent); override;

    property Path: String read FPath write FPath;
    property TaskId: Variant read FTaskId write FTaskId;
    property TaskName: String read FTaskName write FTaskName;
  end;


implementation

uses Windows, SysUtils, Forms, ShellApi,
     BisProvider, BisFilterGroups, BisOrders, BisUtils;

{ TBisCallcDealFrameDocumentsFrame }

constructor TBisCallcDealFrameDocumentsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InsertClass:=TBisCallcDealFrameDocumentInsertFormIface;
  UpdateClass:=TBisCallcDealFrameDocumentUpdateFormIface;
  DeleteClass:=TBisCallcDealFrameDocumentDeleteFormIface;
  ViewingClass:=TBisCallcDealFrameDocumentViewingFormIface;
  Grid.NumberVisible:=true;
  Grid.AutoResizeableColumns:=true;
  ActionFilter.Visible:=false;
  LabelCounter.Visible:=true;
  with Provider do begin
    ProviderName:='S_TASK_DOCUMENTS';
    with FieldNames do begin
      AddKey('TASK_DOCUMENT_ID');
      AddInvisible('TASK_ID');
      AddInvisible('TASK_NAME');
      AddInvisible('DOCUMENT_TYPE');
      AddInvisible('EXTENSION');
      AddCalculate('DOCUMENT_TYPE_NAME','Тип документа',GetDocumentTypeName,ftString,100,100);
      Add('DATE_DOCUMENT','Дата документа',110);
      Add('NAME','Наименование',150);
      Add('DESCRIPTION','Описание',245);
    end;
    Orders.Add('DATE_DOCUMENT',otDesc);
  end;
  AsModal:=true;
end;

function TBisCallcDealFrameDocumentsFrame.GetDocumentTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetDocumentTypeByIndex(DataSet.FieldByName('DOCUMENT_TYPE').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;

function TBisCallcDealFrameDocumentsFrame.CreateIface(AClass: TBisDataEditFormIfaceClass): TBisDataEditFormIface;
begin
  Result:=inherited CreateIface(AClass);
  if Assigned(Result) then begin
    with TBisCallcDealFrameDocumentEditFormIface(Result) do begin
      Params.ParamByName('TASK_ID').SetNewValue(FTaskId);
      Params.ParamByName('TASK_NAME').SetNewValue(FTaskName);
    end;

    if Result is TBisCallcDealFrameDocumentViewingFormIface then begin
      TBisCallcDealFrameDocumentViewingFormIface(Result).Path:=FPath;
      TBisCallcDealFrameDocumentViewingFormIface(Result).Params.ParamByName('TASK_DOCUMENT_ID').SetNewValue(Provider.FieldByName('TASK_DOCUMENT_ID').Value);
    end;
  end;
end;


{ TBisCallcDealFrameDocumentEditFormIface }

constructor TBisCallcDealFrameDocumentEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Params.ParamByName('TASK_ID').ExcludeModes(AllParamEditModes);
end;

{ TBisCallcDealFrameDocumentInsertFormIface }

constructor TBisCallcDealFrameDocumentInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Создать документ';
  ProviderName:='I_TASK_DOCUMENT';
end;

{ TBisCallcDealFrameDocumentUpdateFormIface }

constructor TBisCallcDealFrameDocumentUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Изменить документ';
  ProviderName:='U_TASK_DOCUMENT';
end;

{ TBisCallcDealFrameDocumentDeleteFormIface }

constructor TBisCallcDealFrameDocumentDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Удалить документ';
  ProviderName:='D_TASK_DOCUMENT';
end;

{ TBisCallcDealFrameDocumentViewingFormIface }

constructor TBisCallcDealFrameDocumentViewingFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Просмотр документа';
end;


procedure TBisCallcDealFrameDocumentViewingFormIface.Execute;
var
  P: TBisProvider;
  DocumentId: Variant;
  S: String;
begin
  DocumentId:=Params.ParamByName('TASK_DOCUMENT_ID').Value;
  if not VarIsNull(DocumentId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_TASK_DOCUMENTS';
      with P.FieldNames do begin
        AddInvisible('DOCUMENT');
        AddInvisible('EXTENSION');
      end;
      P.FilterGroups.Add.Filters.Add('TASK_DOCUMENT_ID',fcEqual,DocumentId);
      P.Open;
      if P.Active and not P.IsEmpty then begin
        if DirectoryExists(FPath) then
          S:=FPath+VarToStrDef(DocumentId,'')+P.FieldByName('EXTENSION').AsString
        else
          S:=ExtractFilePath(Application.ExeName)+VarToStrDef(DocumentId,'')+P.FieldByName('EXTENSION').AsString;
        TBlobField(P.FieldByName('DOCUMENT')).SaveToFile(S);
        if FileExists(S) then begin
          ShellExecute(0,nil,PChar(S),nil,nil,SW_SHOW);
        end;
      end;
    finally
      P.Free;
    end;
  end;
end;

end.
