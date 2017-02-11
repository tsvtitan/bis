unit BisDesignDataScriptEditFm;

interface
                                                                                               
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Contnrs,
  BisFm, BisDataEditFm, BisParam, BisControls, BisScriptIface, ImgList;

type
  TBisDesignDataScriptEditForm = class(TBisDataEditForm)
    LabelScript: TLabel;
    EditScript: TEdit;
    LabelEngine: TLabel;
    ComboBoxEngine: TComboBox;
    LabelPlace: TLabel;
    ComboBoxPlace: TComboBox;
    OpenDialog: TOpenDialog;
    ButtonLoad: TButton;
    ButtonSave: TButton;
    ButtonClear: TButton;
    SaveDialog: TSaveDialog;
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    CheckBoxRefresh: TCheckBox;
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure EditScriptChange(Sender: TObject);
  private
    procedure ChangeInterfaceId(Param: TBisParam);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
    function CheckParam(Param: TBisParam): Boolean; override;
    procedure Execute; override;
  end;

  TBisDesignDataScriptEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataScriptInsertFormIface=class(TBisDesignDataScriptEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataScriptUpdateFormIface=class(TBisDesignDataScriptEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataScriptDeleteFormIface=class(TBisDesignDataScriptEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataScriptEditForm: TBisDesignDataScriptEditForm;

implementation

uses
     BisDesignDataInterfacesFm, BisFilterGroups, BisInterfaces, BisUtils, BisProvider,
     BisConsts, BisDialogs, BisCore, BisScriptModules;

{$R *.dfm}

{ TBisDesignDataScriptEditFormIface }

constructor TBisDesignDataScriptEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataScriptEditForm;
  with Params do begin
    AddKey('INTERFACE_ID').Older('OLD_INTERFACE_ID');
    AddInvisible('SCRIPT_ID').Older('OLD_SCRIPT_ID');
    AddInvisible('INTERFACE_TYPE').Value:=Integer(itScript);
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddComboBoxTextIndex('ENGINE','ComboBoxEngine','LabelEngine',true).ExcludeModes([emDuplicate,emUpdate]);
    AddComboBox('PLACE','ComboBoxPlace','LabelPlace',true).ExcludeModes([emDuplicate,emUpdate]);
    AddInvisible('SCRIPT').Required:=true;
  end;
end;

{ TBisDesignDataScriptInsertFormIface }

constructor TBisDesignDataScriptInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_SCRIPT';
  Caption:='������� ������';
end;

{ TBisDesignDataScriptUpdateFormIface }

constructor TBisDesignDataScriptUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_SCRIPT';
  Caption:='�������� ������';
end;

{ TBisDesignDataScriptDeleteFormIface }

constructor TBisDesignDataScriptDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_SCRIPT';
  Caption:='������� ������';
end;

{ TBisDesignDataScriptEditForm }

constructor TBisDesignDataScriptEditForm.Create(AOwner: TComponent);
var
  Module: TBisScriptModule;
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxEngine.Clear;
  for i:=0 to Core.ScriptModules.Count-1 do begin
    Module:=Core.ScriptModules.Items[i];
    if Module.Enabled and Assigned(Module.ScriptClass) then
      ComboBoxEngine.Items.AddObject(Module.ObjectName,Module);
  end;

  EditScript.Color:=ColorControlReadOnly;
end;

destructor TBisDesignDataScriptEditForm.Destroy;
begin
  inherited Destroy;
end;

procedure TBisDesignDataScriptEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode=emInsert then
    Provider.Params.ParamByName('SCRIPT_ID').SetNewValue(Provider.Params.ParamByName('INTERFACE_ID').Value);
  ButtonLoad.Enabled:=not Provider.Params.ParamByName('PLACE').Empty and
                      (Mode in [emInsert,emDuplicate,emUpdate]);
  ButtonClear.Enabled:=ButtonLoad.Enabled;
  LabelScript.Enabled:=not Provider.Params.ParamByName('ENGINE').Empty and
                      (Mode in [emInsert,emDuplicate,emUpdate]);
  EditScript.Enabled:=LabelScript.Enabled;
end;

procedure TBisDesignDataScriptEditForm.EditScriptChange(Sender: TObject);
begin
  if not EditScript.ReadOnly then begin
    EditScript.OnChange:=nil;
    try
      Provider.Params.ParamByName('SCRIPT').Value:=EditScript.Text; 
    finally
      EditScript.OnChange:=EditScriptChange;
    end;
  end;
end;

procedure TBisDesignDataScriptEditForm.ChangeInterfaceId(Param: TBisParam);
var
  AProvider: TBisProvider;
  ScriptParam: TBisParam;
  EngineParam: TBisParam;
  PlaceParam: TBisParam;
begin
  if Mode in [emDuplicate,emUpdate] then begin
    ScriptParam:=Param.Find('SCRIPT');
    EngineParam:=Param.Find('ENGINE');
    PlaceParam:=Param.Find('PLACE');
    if Assigned(ScriptParam) then begin
      AProvider:=TBisProvider.Create(nil);
      try
        AProvider.ProviderName:='S_SCRIPTS';
        with AProvider.FieldNames do begin
          if Mode<>emDelete then
            AddInvisible('SCRIPT');
          AddInvisible('ENGINE');
          AddInvisible('PLACE');
        end;
        AProvider.FilterGroups.Add.Filters.Add('SCRIPT_ID',fcEqual,Param.Value);
        AProvider.Open;
        if AProvider.Active and not AProvider.IsEmpty then begin
          if Mode<>emDelete then
            ScriptParam.SetNewValue(AProvider.FieldByName('SCRIPT').Value);
          EngineParam.SetNewValue(AProvider.FieldByName('ENGINE').Value);
          PlaceParam.SetNewValue(AProvider.FieldByName('PLACE').Value);
        end;
      finally
        AProvider.Free;
      end;
    end;
  end;
end;

procedure TBisDesignDataScriptEditForm.ChangeParam(Param: TBisParam);
var
  AEmpty: Boolean;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'INTERFACE_ID') then begin
    Provider.Params.ParamByName('SCRIPT_ID').SetNewValue(Param.Value);
    ChangeInterfaceId(Param);
  end;
  if AnsiSameText(Param.ParamName,'PLACE') then begin
    EditScript.ReadOnly:=not Boolean(VarToIntDef(Param.Value,0));
    EditScript.Color:=iff(EditScript.ReadOnly,ColorControlReadOnly,clWindow);
    ButtonLoad.Caption:=iff(EditScript.ReadOnly,'���������','�������');
    ChangeParam(Provider.Params.ParamByName('SCRIPT'));
  end;
  if AnsiSameText(Param.ParamName,'SCRIPT') then begin
    AEmpty:=Param.Empty;
    if EditScript.ReadOnly then
      EditScript.Text:=iff(AEmpty,'�� ��������','��������')
    else EditScript.Text:=VarToStrDef(Param.Value,'');
    ButtonLoad.Enabled:=(Mode in [emInsert,emDuplicate,emUpdate]);
    ButtonSave.Enabled:=not AEmpty and (Mode in [emInsert,emDuplicate,emUpdate]);
    ButtonClear.Enabled:=ButtonSave.Enabled;
  end;
end;

procedure TBisDesignDataScriptEditForm.ButtonLoadClick(Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('SCRIPT');
  if Assigned(Param) then begin
    if OpenDialog.Execute then begin
      if EditScript.ReadOnly then
        Param.LoadFromFile(OpenDialog.FileName)
      else Param.Value:=OpenDialog.FileName;
      UpdateButtonState;
    end;
  end;
end;

procedure TBisDesignDataScriptEditForm.ButtonSaveClick(Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('SCRIPT');
  if Assigned(Param) then begin
    SaveDialog.FileName:=EditName.Text;
    if SaveDialog.Execute then begin
      if EditScript.ReadOnly then
        Param.SaveToFile(SaveDialog.FileName)
      else CopyFile(PChar(VarToStrDef(Param.Value,'')),PChar(SaveDialog.FileName),false);  
    end;
  end;
end;

procedure TBisDesignDataScriptEditForm.ButtonClearClick(Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('SCRIPT');
  if Assigned(Param) then begin
    Param.Clear;
    UpdateButtonState;
  end;
end;

function TBisDesignDataScriptEditForm.CheckParam(Param: TBisParam): Boolean;
begin
  if AnsiSameText(Param.ParamName,'SCRIPT') then begin
    if Param.Empty then begin
      ShowError(Format(SNeedControlValue,[LabelScript.Caption]));
      EditScript.SetFocus;
      Result:=false;
    end else
      Result:=true;
  end else
    Result:=inherited CheckParam(Param);
end;

procedure TBisDesignDataScriptEditForm.Execute;
begin
  inherited Execute;
  if CheckBoxRefresh.Checked then begin
    Core.RefreshPermissions;
    Core.ReloadInterfaces;
  end;
end;


end.