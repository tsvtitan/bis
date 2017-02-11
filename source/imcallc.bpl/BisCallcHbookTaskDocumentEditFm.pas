unit BisCallcHbookTaskDocumentEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisParam, BisControls;

type
  TBisCallcHbookTaskDocumentType=(dtUnknown,dtDocument,dtAudio,dtVideo,dtImage);

  TBisCallcHbookTaskDocumentEditForm = class(TBisDataEditForm)
    LabelTask: TLabel;
    EditTask: TEdit;
    ButtonTask: TButton;
    LabelDateDocument: TLabel;
    DateTimePickerDocument: TDateTimePicker;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    DateTimePickerTimeDocument: TDateTimePicker;
    LabelName: TLabel;
    EditName: TEdit;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelDocument: TLabel;
    EditDocument: TEdit;
    ButtonLoad: TButton;
    ButtonSave: TButton;
    ButtonClear: TButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    LabelExtension: TLabel;
    EditExtension: TEdit;
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure ChangeParam(Param: TBisParam); override;
    function CheckParam(Param: TBisParam): Boolean; override;
    procedure BeforeShow; override;
  end;

  TBisCallcHbookTaskDocumentEditFormIface=class(TBisDataEditFormIface)
  private
    procedure DocumentIdChange(Param: TBisParam);
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookTaskDocumentInsertFormIface=class(TBisCallcHbookTaskDocumentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookTaskDocumentUpdateFormIface=class(TBisCallcHbookTaskDocumentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookTaskDocumentDeleteFormIface=class(TBisCallcHbookTaskDocumentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookTaskDocumentEditForm: TBisCallcHbookTaskDocumentEditForm;

function GetDocumentTypeByIndex(Index: Integer): String;

implementation

uses DateUtils, TypInfo,
     BisCallcHbookTasksFm, BisUtils, 
     BisConsts, BisProvider, BisFilterGroups, BisDialogs;

{$R *.dfm}

function GetDocumentTypeByIndex(Index: Integer): String;
begin
  Result:='';
  case TBisCallcHbookTaskDocumentType(Index) of
    dtUnknown: Result:='����������';
    dtDocument: Result:='��������';
    dtAudio: Result:='�����';
    dtVideo: Result:='�����';
    dtImage: Result:='�����������';
  end;
end;

{ TBisCallcHbookTaskDocumentEditFormIface }

constructor TBisCallcHbookTaskDocumentEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookTaskDocumentEditForm;
  with Params do begin
    with AddKey('TASK_DOCUMENT_ID') do begin
      Older('OLD_TASK_DOCUMENT_ID');
      OnChange:=DocumentIdChange;
    end;
    AddEditDataSelect('TASK_ID','EditTask','LabelTask','ButtonTask',
                      TBisCallcHbookTasksFormIface,'TASK_NAME',true,false,'','DEAL_NUM;ACTION_NAME;DATE_CREATE');
    AddComboBox('DOCUMENT_TYPE','ComboBoxType','LabelType',true);
    AddInvisible('DOCUMENT').Required:=true;
    AddEdit('NAME','EditName','LabelName',true);
    AddEdit('EXTENSION','EditExtension','LabelExtension',true);
    AddEditDateTime('DATE_DOCUMENT','DateTimePickerDocument','DateTimePickerTimeDocument','LabelDateDocument',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
  end;
end;

procedure TBisCallcHbookTaskDocumentEditFormIface.DocumentIdChange(Param: TBisParam);
var
  AProvider: TBisProvider;
  ParamDocument: TBisParam;
begin
  if Self.ClassType<>TBisCallcHbookTaskDocumentDeleteFormIface then begin
    ParamDocument:=Param.Find('DOCUMENT');
    if Assigned(ParamDocument) then begin
      AProvider:=TBisProvider.Create(Self);
      try
        AProvider.ProviderName:='S_TASK_DOCUMENTS';
        AProvider.FieldNames.AddInvisible('DOCUMENT');
        AProvider.FilterGroups.Add.Filters.Add('TASK_DOCUMENT_ID',fcEqual,Param.Value);
        AProvider.Open;
        if AProvider.Active and not AProvider.IsEmpty then begin
          ParamDocument.SetNewValue(AProvider.FieldByName('DOCUMENT').AsString);
        end;
      finally
        AProvider.Free;
      end;
    end;
  end;
end;

{ TBisCallcHbookTaskDocumentInsertFormIface }

constructor TBisCallcHbookTaskDocumentInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_TASK_DOCUMENT';
end;

{ TBisCallcHbookTaskDocumentUpdateFormIface }

constructor TBisCallcHbookTaskDocumentUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_TASK_DOCUMENT';
end;

{ TBisCallcHbookTaskDocumentDeleteFormIface }

constructor TBisCallcHbookTaskDocumentDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_TASK_DOCUMENT';
end;

{ TBisCallcHbookTaskDocumentEditForm }

constructor TBisCallcHbookTaskDocumentEditForm.Create(AOwner: TComponent);
var
  i: Integer;
  PInfo: PTypeInfo;
  PData: PTypeData;
begin
  inherited Create(AOwner);

  EditDocument.Color:=ColorControlReadOnly;
  ComboBoxType.Clear;
  PData:=nil;
  PInfo:=TypeInfo(TBisCallcHbookTaskDocumentType);
  if Assigned(PInfo) then
    PData:=GetTypeData(PInfo);
  if Assigned(PData) then
    for i:=PData.MinValue to PData.MaxValue do begin
      ComboBoxType.Items.Add(GetDocumentTypeByIndex(i));
    end;
end;

procedure TBisCallcHbookTaskDocumentEditForm.BeforeShow;
begin
  Provider.Params.ParamByName('DATE_DOCUMENT').SetNewValue(Now);
  inherited BeforeShow;
end;

procedure TBisCallcHbookTaskDocumentEditForm.ChangeParam(Param: TBisParam);
var
  AEmpty: Boolean;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'DOCUMENT') then begin
    AEmpty:=Param.Empty;
    EditDocument.Text:=iff(AEmpty,'�� ��������','��������');
    ButtonLoad.Enabled:=AEmpty;
    ButtonSave.Enabled:=not AEmpty;
    ButtonClear.Enabled:=ButtonSave.Enabled;
  end;
end;

procedure TBisCallcHbookTaskDocumentEditForm.ButtonLoadClick(Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('DOCUMENT');
  if Assigned(Param) then begin
    OpenDialog.FilterIndex:=ComboBoxType.ItemIndex+1;
    if OpenDialog.Execute then begin
      Param.LoadFromFile(OpenDialog.FileName);
      EditName.Text:=ChangeFileExt(ExtractFileName(OpenDialog.FileName),'');
      EditExtension.Text:=ExtractFileExt(OpenDialog.FileName);
      UpdateButtonState;
    end;
  end;
end;

procedure TBisCallcHbookTaskDocumentEditForm.ButtonSaveClick(Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('DOCUMENT');
  if Assigned(Param) then begin
    SaveDialog.FilterIndex:=ComboBoxType.ItemIndex+1;
    SaveDialog.FileName:=EditName.Text+EditExtension.Text;
    if SaveDialog.Execute then
      Param.SaveToFile(SaveDialog.FileName);
  end;
end;

procedure TBisCallcHbookTaskDocumentEditForm.ButtonClearClick(Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('DOCUMENT');
  if Assigned(Param) then begin
    Param.Clear;
    UpdateButtonState;
  end;
end;

function TBisCallcHbookTaskDocumentEditForm.CheckParam(Param: TBisParam): Boolean;
begin
  if AnsiSameText(Param.ParamName,'DOCUMENT') then begin
    ShowError(Format(SNeedControlValue,[LabelDocument.Caption]));
    EditDocument.SetFocus;
    Result:=false;
  end else
    Result:=inherited CheckParam(Param);
end;

end.
