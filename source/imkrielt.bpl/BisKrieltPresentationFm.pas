unit BisKrieltPresentationFm;

interface                                                                                        

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB, DBCtrls,
  BisFm, BisDataGridFm, BisFieldNames, BisDataFrm,
  BisKrieltPresentationFrm;

type
  TBisKrieltPresentationForm = class(TBisDataGridForm)
  private
    function GetDataFrame: TBisKrieltPresentationFrame;
    { Private declarations }
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    property DataFrame: TBisKrieltPresentationFrame read GetDataFrame;
  end;

  TBisKrieltPresentationFormIface=class(TBisDataGridFormIface)
  private
    FPresentationName: String;
    FTableName: String;
    FPresentationId: Variant;
    FPresentationPath: String;
    FPublishingId: Variant;
    FOperationId: Variant;
    FTypeId: Variant;
    FViewId: Variant;
    FUserName: String;
    function GetLastForm: TBisKrieltPresentationForm;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure RefreshByPresentationId;

    property PresentationName: String read FPresentationName write FPresentationName;
    property TableName: String read FTableName write FTableName;
    property PresentationId: Variant read FPresentationId write FPresentationId;
    property PresentationPath: String read FPresentationPath write FPresentationPath;
    property PublishingId: Variant read FPublishingId write FPublishingId;
    property ViewId: Variant read FViewId write FViewId;
    property TypeId: Variant read FTypeId write FTypeId;
    property OperationId: Variant read FOperationId write FOperationId;
    property UserName: String read FUserName write FUserName;

    property LastForm: TBisKrieltPresentationForm read GetLastForm;
  end;

var
  BisKrieltPresentationForm: TBisKrieltPresentationForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisProvider, BisUtils, BisKrieltPresentationEditFm;

{ TBisKrieltPresentationFormIface }

constructor TBisKrieltPresentationFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltPresentationForm;
  FilterClass:=TBisKrieltPresentationFilterFormIface;
  ViewClass:=TBisKrieltPresentationViewingFormIface;
  FilterOnShow:=true;
end;

function TBisKrieltPresentationFormIface.GetLastForm: TBisKrieltPresentationForm;
begin
  Result:=TBisKrieltPresentationForm(inherited LastForm);
end;

function TBisKrieltPresentationFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(LastForm) then begin
    with LastForm do begin
      DataFrame.PresentationId:=FPresentationId;
      DataFrame.PresentationName:=FPresentationName;
      DataFrame.TableName:=FTableName;
    end;
  end;
end;

procedure TBisKrieltPresentationFormIface.RefreshByPresentationId;
var
  P: TBisProvider;
  S: String;
  i: Integer;
  Field: TField;
  ACaption: String;
  AFieldName: String;
  Flag: Boolean;
  UserText: String;
begin
  if (Trim(FPresentationId)<>'') and (Trim(FTableName)<>'') then begin
    UserText:='';
    if Trim(FUserName)<>'' then
      UserText:=FormatEx(' для %s',[FUserName]);

    if Trim(FPresentationPath)<>'' then begin
      Caption:=FormatEx('Представление%s: %s => %s',[UserText,FPresentationName,FPresentationPath]);
    end else begin
      Caption:=FormatEx('Представление%s: %s',[UserText,FPresentationName]);
    end;

    ProviderName:=FTableName;
    FieldNames.Clear;
    FilterGroups.Clear;
    with FilterGroups.Add.Filters do begin
      if not VarIsNull(FPublishingId) then
        Add('PUBLISHING_ID',fcEqual,FPublishingId);
      if not VarIsNull(FViewId) then
        Add('VIEW_ID',fcEqual,FViewId);
      if not VarIsNull(FTypeId) then
        Add('TYPE_ID',fcEqual,FTypeId);
      if not VarIsNull(FOperationId) then
        Add('OPERATION_ID',fcEqual,FOperationId);
    end;

    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:=FTableName;
      P.FetchCount:=0;
      P.Open;
      if P.Active then begin
        for i:=0 to P.FieldCount-1 do begin
          Field:=P.Fields[i];
          AFieldName:=Field.FieldName;
          if AnsiSameText(AFieldName,'OBJECT_ID') then FieldNames.AddKey(AFieldName);
          if AnsiSameText(AFieldName,'PUBLISHING_ID') then FieldNames.AddKey(AFieldName);
          S:=Copy(AFieldName,Length(AFieldName)-2,3);
          if S<>'_ID' then begin
            ACaption:=AFieldName;
            Flag:=true;
            if AnsiSameText(AFieldName,'PUBLISHING_NAME') then begin
              ACaption:='Издание';
              Flag:=VarIsNull(FPublishingId);
            end;
            if AnsiSameText(AFieldName,'VIEW_NAME') then begin
              ACaption:='Вид';
              Flag:=VarIsNull(FViewId);
            end;
            if AnsiSameText(AFieldName,'TYPE_NAME') then begin
              ACaption:='Тип';
              Flag:=VarIsNull(FTypeId);
            end;
            if AnsiSameText(AFieldName,'OPERATION_NAME') then begin
              ACaption:='Операция';
              Flag:=VarIsNull(FOperationId);
            end;
            if AnsiSameText(AFieldName,'DATE_BEGIN') then begin
              ACaption:='Дата начала';
            end;
            if AnsiSameText(AFieldName,'USER_NAME') then begin
              ACaption:='Учетная запись';
            end;
            if AnsiSameText(AFieldName,'PHONE') then begin
              ACaption:='Телефон';
            end;
            if AnsiSameText(AFieldName,'STATUS') then begin
              Flag:=false;
            end;
            if Flag then
              FieldNames.Add(AFieldName,ACaption)
            else FieldNames.AddInvisible(AFieldName);
          end;
        end;
      end;
    finally
      P.Free;
    end;
  end;
end;

{ TBisKrieltPresentationForm }

function TBisKrieltPresentationForm.GetDataFrame: TBisKrieltPresentationFrame;
begin
  Result:=TBisKrieltPresentationFrame(inherited DataFrame);
end;

class function TBisKrieltPresentationForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltPresentationFrame;
end;

end.
