unit BisDesignDataDocumentEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Contnrs, ActiveX, OleCtnrs,                                               
  BisFm, BisDataEditFm, BisParam, BisControls, ImgList;

type
  TBisDesignDataDocumentEditForm = class(TBisDataEditForm)
    LabelDocument: TLabel;
    EditDocument: TEdit;
    LabelPlace: TLabel;
    ComboBoxPlace: TComboBox;
    OpenDialog: TOpenDialog;
    ButtonLoad: TButton;
    ButtonSave: TButton;
    ButtonClear: TButton;
    SaveDialog: TSaveDialog;
    LabelOleClass: TLabel;
    EditOleClass: TEdit;
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    CheckBoxRefresh: TCheckBox;
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure EditDocumentChange(Sender: TObject);
  private
    function GetOleClass(FileName: String): String;
    procedure ChangeInterfaceId(Param: TBisParam);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
    function CheckParam(Param: TBisParam): Boolean; override;
    procedure Execute; override;
  end;

  TBisDesignDataDocumentEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataDocumentInsertFormIface=class(TBisDesignDataDocumentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataDocumentUpdateFormIface=class(TBisDesignDataDocumentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataDocumentDeleteFormIface=class(TBisDesignDataDocumentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataDocumentEditForm: TBisDesignDataDocumentEditForm;

implementation

uses ComObj,
     BisDesignDataInterfacesFm, BisFilterGroups, BisInterfaces, BisUtils, BisProvider,
     BisConsts, BisDialogs, BisCore;

{$R *.dfm}

{ TBisDesignDataDocumentEditFormIface }

constructor TBisDesignDataDocumentEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataDocumentEditForm;
  with Params do begin
    AddKey('INTERFACE_ID').Older('OLD_INTERFACE_ID');
    AddInvisible('DOCUMENT_ID').Older('OLD_DOCUMENT_ID');
    AddInvisible('INTERFACE_TYPE').Value:=Integer(itDocument);
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddComboBox('PLACE','ComboBoxPlace','LabelPlace',true).ExcludeModes([emDuplicate,emUpdate]);
    AddEdit('OLE_CLASS','EditOleClass','LabelOleClass',true);
    AddInvisible('DOCUMENT').Required:=true;
  end;
end;

{ TBisDesignDataDocumentInsertFormIface }

constructor TBisDesignDataDocumentInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_DOCUMENT';
  Caption:='Создать документ';
end;

{ TBisDesignDataDocumentUpdateFormIface }

constructor TBisDesignDataDocumentUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_DOCUMENT';
  Caption:='Изменить документ';
end;

{ TBisDesignDataDocumentDeleteFormIface }

constructor TBisDesignDataDocumentDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_DOCUMENT';
  Caption:='Удалить документ';
end;

{ TBisDesignDataDocumentEditForm }

constructor TBisDesignDataDocumentEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBisDesignDataDocumentEditForm.Destroy;
begin
  inherited Destroy;
end;

procedure TBisDesignDataDocumentEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode=emInsert then
    Provider.Params.ParamByName('DOCUMENT_ID').SetNewValue(Provider.Params.ParamByName('INTERFACE_ID').Value);
  ButtonSave.Enabled:=not Provider.Params.ParamByName('PLACE').Empty and
                      (Mode in [emInsert,emDuplicate,emUpdate]);
  ButtonClear.Enabled:=ButtonSave.Enabled;
  LabelDocument.Enabled:=ButtonSave.Enabled;
  EditDocument.Enabled:=ButtonSave.Enabled;
end;

procedure TBisDesignDataDocumentEditForm.EditDocumentChange(Sender: TObject);
begin
  if not EditDocument.ReadOnly then begin
    EditDocument.OnChange:=nil;
    try
      Provider.Params.ParamByName('DOCUMENT').Value:=EditDocument.Text; 
    finally
      EditDocument.OnChange:=EditDocumentChange;
    end;
  end;
end;

procedure TBisDesignDataDocumentEditForm.ChangeInterfaceId(Param: TBisParam);
var
  AProvider: TBisProvider;
  DocumentParam: TBisParam;
  EngineParam: TBisParam;
  PlaceParam: TBisParam;
begin
  if Mode in [emDuplicate,emUpdate] then begin
    DocumentParam:=Param.Find('DOCUMENT');
    EngineParam:=Param.Find('OLE_CLASS');
    PlaceParam:=Param.Find('PLACE');
    if Assigned(DocumentParam) then begin
      AProvider:=TBisProvider.Create(nil);
      try
        AProvider.ProviderName:='S_DOCUMENTS';
        with AProvider.FieldNames do begin
          if Mode<>emDelete then
            AddInvisible('DOCUMENT');
          AddInvisible('OLE_CLASS');
          AddInvisible('PLACE');
        end;
        AProvider.FilterGroups.Add.Filters.Add('DOCUMENT_ID',fcEqual,Param.Value);
        AProvider.Open;
        if AProvider.Active and not AProvider.IsEmpty then begin
          if Mode<>emDelete then
            DocumentParam.SetNewValue(AProvider.FieldByName('DOCUMENT').Value);
          EngineParam.SetNewValue(AProvider.FieldByName('OLE_CLASS').Value);
          PlaceParam.SetNewValue(AProvider.FieldByName('PLACE').Value);
        end;
      finally
        AProvider.Free;
      end;
    end;
  end;
end;

procedure TBisDesignDataDocumentEditForm.ChangeParam(Param: TBisParam);
var
  AEmpty: Boolean;
begin
  inherited ChangeParam(Param);

  if AnsiSameText(Param.ParamName,'INTERFACE_ID') then begin
    Provider.Params.ParamByName('DOCUMENT_ID').SetNewValue(Param.Value);
    ChangeInterfaceId(Param);
  end;

  if AnsiSameText(Param.ParamName,'PLACE') then begin
    EditDocument.ReadOnly:=not Boolean(VarToIntDef(Param.Value,0));
    EditDocument.Color:=iff(EditDocument.ReadOnly,ColorControlReadOnly,clWindow);
    LabelDocument.Enabled:=not Param.Empty and
                          (Mode in [emInsert,emDuplicate,emUpdate]);
    EditDocument.Enabled:=LabelDocument.Enabled;
    ButtonLoad.Caption:=iff(EditDocument.ReadOnly,'Загрузить','Выбрать');
    ChangeParam(Provider.Params.ParamByName('DOCUMENT'));
  end;
  
  if AnsiSameText(Param.ParamName,'DOCUMENT') then begin
    AEmpty:=Param.Empty;
    if EditDocument.ReadOnly then
      EditDocument.Text:=iff(AEmpty,'Не загружен','Загружен')
    else EditDocument.Text:=VarToStrDef(Param.Value,'');
    ButtonLoad.Enabled:=(Mode in [emInsert,emDuplicate,emUpdate]);
    ButtonSave.Enabled:=not AEmpty and (Mode in [emInsert,emDuplicate,emUpdate]);
    ButtonClear.Enabled:=ButtonSave.Enabled;
  end;
  
end;

function TBisDesignDataDocumentEditForm.GetOleClass(FileName: String): String;
var
{  clsid: TCLSID;
  S: WideString;}
  Ole: TOleContainer;
begin
{  S:=FileName;
  OleCheck(GetClassFile(PWideChar(S),clsid));
  Result:=ClassIDToProgID(clsid);}
  Ole:=TOleContainer.Create(nil);
  try
    Ole.Visible:=false;
    Ole.Parent:=Self;
    Ole.CreateObjectFromFile(FileName,false);
    Result:=Ole.OleClassName;
  finally
    Ole.Free;
  end;      
end;

procedure TBisDesignDataDocumentEditForm.ButtonLoadClick(Sender: TObject);
var
  Param, Param2, Param3: TBisParam;
begin
  Param:=Provider.Params.Find('DOCUMENT');
  if OpenDialog.Execute then begin
    if EditDocument.ReadOnly then
      Param.LoadFromFile(OpenDialog.FileName)
    else Param.Value:=OpenDialog.FileName;

    Param2:=Provider.Params.ParamByName('OLE_CLASS');
    if Param2.Empty then
      Param2.Value:=GetOleClass(OpenDialog.FileName);

    Param3:=Provider.ParamByName('NAME');
    if Param3.Empty then
      Param3.Value:=ExtractFileName(OpenDialog.FileName);
      
  end;
end;

procedure TBisDesignDataDocumentEditForm.ButtonSaveClick(Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('DOCUMENT');
  SaveDialog.FileName:=EditName.Text;
  if SaveDialog.Execute then begin
    if EditDocument.ReadOnly then
      Param.SaveToFile(SaveDialog.FileName)
    else CopyFile(PChar(VarToStrDef(Param.Value,'')),PChar(SaveDialog.FileName),false);
  end;
end;

procedure TBisDesignDataDocumentEditForm.ButtonClearClick(Sender: TObject);
begin
  Provider.Params.Find('DOCUMENT').Clear;
end;

function TBisDesignDataDocumentEditForm.CheckParam(Param: TBisParam): Boolean;
begin
  if AnsiSameText(Param.ParamName,'DOCUMENT') then begin
    if Param.Empty then begin
      ShowError(Format(SNeedControlValue,[LabelDocument.Caption]));
      EditDocument.SetFocus;
      Result:=false;
    end else
      Result:=true;
  end else
    Result:=inherited CheckParam(Param);
end;

procedure TBisDesignDataDocumentEditForm.Execute;
begin
  inherited Execute;
  if CheckBoxRefresh.Checked then begin
    Core.RefreshPermissions;
    Core.ReloadInterfaces;
  end;
end;

end.
