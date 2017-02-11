unit BisDesignDataMenuEditFm;

interface

uses                                                                                                        
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ExtDlgs,
  BisFm, BisDataEditFm, BisParam, BisControls, CheckLst, ImgList;

type
  TBisDesignDataMenuEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    LabelInterface: TLabel;
    EditName: TEdit;
    EditInterface: TEdit;
    ButtonInterface: TButton;
    LabelParent: TLabel;
    EditParent: TEdit;
    ButtonParent: TButton;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelShortcut: TLabel;
    HotKeyShortCut: THotKey;
    ImagePicture: TImage;
    ButtonLoad: TButton;
    ButtonSave: TButton;
    ButtonClear: TButton;
    OpenPictureDialog: TOpenPictureDialog;
    SavePictureDialog: TSavePictureDialog;
    GroupBoxApplications: TGroupBox;
    CheckBoxRefresh: TCheckBox;
    CheckListBoxApplications: TCheckListBox;
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure CheckListBoxApplicationsClickCheck(Sender: TObject);
  private
    FChangeApplications: Boolean;
    procedure RefreshApplications;
    procedure RefreshApplicationMenus;
    procedure DeleteApplicationMenus;
    procedure InsertApplicationMenus;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ChangeParam(Param: TBisParam); override;
    procedure Execute; override;
    function ChangesExists: Boolean; override;
    procedure BeforeShow; override;
  end;

  TBisDesignDataMenuEditFormIface=class(TBisDataEditFormIface)
  private
    procedure PictureIdChange(Param: TBisParam);
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataMenuInsertFormIface=class(TBisDesignDataMenuEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataMenuInsertChildFormIface=class(TBisDesignDataMenuEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataMenuUpdateFormIface=class(TBisDesignDataMenuEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataMenuDeleteFormIface=class(TBisDesignDataMenuEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataMenuEditForm: TBisDesignDataMenuEditForm;

implementation

uses BisDesignDataInterfacesFm, BisDesignDataMenusFm, BisPicture, BisProvider,
     BisFilterGroups, BisUtils, BisCore;

{$R *.dfm}

type

  TBisApplicationInfo=class(TObject)
  private
    var ApplicationId: Variant;
  end;

{ TBisDesignDataMenuEditFormIface }

constructor TBisDesignDataMenuEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataMenuEditForm;
  with Params do begin
    with AddKey('MENU_ID') do begin
      Older('OLD_MENU_ID');
      OnChange:=PictureIdChange;
    end;
    AddEditDataSelect('PARENT_ID','EditParent','LabelParent','ButtonParent',
                      TBisDesignDataMenusFormIface,'PARENT_NAME',false,false,'MENU_ID','NAME');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddHotKey('SHORTCUT','HotKeyShortCut','LabelShortcut');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
    AddEditDataSelect('INTERFACE_ID','EditInterface','LabelInterface','ButtonInterface',
                      TBisDesignDataInterfacesFormIface,'INTERFACE_NAME',false,false,'','NAME');
    AddInvisible('PICTURE');
  end;
end;

procedure TBisDesignDataMenuEditFormIface.PictureIdChange(Param: TBisParam);
var
  AProvider: TBisProvider;
  ParamPicture: TBisParam;
begin
  ParamPicture:=Param.Find('PICTURE');
  if Assigned(ParamPicture) then begin
    AProvider:=TBisProvider.Create(Self);
    try
      AProvider.ProviderName:='S_MENUS';
      AProvider.FieldNames.AddInvisible('PICTURE');
      AProvider.FilterGroups.Add.Filters.Add('MENU_ID',fcEqual,Param.Value);
      AProvider.Open;
      if AProvider.Active and not AProvider.IsEmpty then begin
        ParamPicture.SetNewValue(AProvider.FieldByName('PICTURE').AsString);
      end;
    finally
      AProvider.Free;
    end;
  end;
end;

{ TBisDesignDataMenuInsertFormIface }

constructor TBisDesignDataMenuInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_MENU';
end;

function TBisDesignDataMenuInsertFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
      with LastForm.Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentDataSet.FieldByName('PARENT_ID').Value);
        Params.ParamByName('PARENT_NAME').SetNewValue(ParentDataSet.FieldByName('PARENT_NAME').Value);
      end;
    end;
  end;
end;

{ TBisDesignDataMenuInsertChildFormIface }

constructor TBisDesignDataMenuInsertChildFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_MENU';
  Caption:='������� �������� ����';
end;


function TBisDesignDataMenuInsertChildFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
      with LastForm.Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentDataSet.FieldByName('MENU_ID').Value);
        Params.ParamByName('PARENT_NAME').SetNewValue(ParentDataSet.FieldByName('NAME').Value);
      end;
    end;
  end;
end;

{ TBisDesignDataMenuUpdateFormIface }

constructor TBisDesignDataMenuUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_MENU';
end;

{ TBisDesignDataMenuDeleteFormIface }

constructor TBisDesignDataMenuDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_MENU';
end;

{ TBisDesignDataMenuEditForm }

constructor TBisDesignDataMenuEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FChangeApplications:=false;
  Provider.UseWaitCursor:=false;
  RefreshApplications;
end;

procedure TBisDesignDataMenuEditForm.ChangeParam(Param: TBisParam);
var
  AEmpty: Boolean;
  Stream: TMemoryStream;
  AParam: TBisParam;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'PICTURE') then begin
    AEmpty:=Param.Empty;
    if AEmpty then
      ImagePicture.Picture.Assign(nil)
    else begin
      Stream:=TMemoryStream.Create;
      try
        Param.SaveToStream(Stream);
        Stream.Position:=0;
        TBisPicture(ImagePicture.Picture).LoadFromStream(Stream);
      finally
        Stream.Free;
      end;
    end;
    ButtonLoad.Enabled:=AEmpty;
    ButtonSave.Enabled:=not AEmpty;
    ButtonClear.Enabled:=ButtonSave.Enabled;
  end;
  if AnsiSameText(Param.ParamName,'INTERFACE_NAME') then begin
    AParam:=Provider.Params.ParamByName('NAME');
    if AParam.Empty and not Param.Empty then
       AParam.Value:=Param.Value;
  end;
end;

function TBisDesignDataMenuEditForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists or FChangeApplications;
end;

procedure TBisDesignDataMenuEditForm.CheckListBoxApplicationsClickCheck(
  Sender: TObject);
begin
  FChangeApplications:=true;
  UpdateButtonState;
end;

procedure TBisDesignDataMenuEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emDelete,emFilter] then begin
    ButtonLoad.Enabled:=false;
    GroupBoxApplications.Enabled:=false;
  end;

  RefreshApplicationMenus;
end;

procedure TBisDesignDataMenuEditForm.ButtonClearClick(Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('PICTURE');
  if Assigned(Param) then begin
    Param.Clear;
    UpdateButtonState;
  end;
end;

procedure TBisDesignDataMenuEditForm.ButtonLoadClick(Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('PICTURE');
  if Assigned(Param) then begin
    if OpenPictureDialog.Execute then begin
      Param.LoadFromFile(OpenPictureDialog.FileName);
      UpdateButtonState;
    end;
  end;
end;


procedure TBisDesignDataMenuEditForm.ButtonSaveClick(Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('PICTURE');
  if Assigned(Param) then begin
    SavePictureDialog.FileName:=EditName.Text;
    if SavePictureDialog.Execute then
      Param.SaveToFile(SavePictureDialog.FileName);
  end;
end;

procedure TBisDesignDataMenuEditForm.RefreshApplications;
var
  P: TBisProvider;
  Obj: TBisApplicationInfo;
begin
  ClearStrings(CheckListBoxApplications.Items);
  CheckListBoxApplications.Items.BeginUpdate;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_APPLICATIONS';
    with P.FieldNames do begin
      AddInvisible('APPLICATION_ID');
      AddInvisible('NAME');
    end;
    P.Open;
    if P.Active then begin
      P.First;
      while not P.Eof do begin
        Obj:=TBisApplicationInfo.Create;
        Obj.ApplicationId:=P.FieldByName('APPLICATION_ID').Value;
        CheckListBoxApplications.Items.AddObject(P.FieldByName('NAME').AsString,Obj);
        P.Next;
      end;
    end;
  finally
    P.Free;
    CheckListBoxApplications.Items.EndUpdate;
  end;
end;

procedure TBisDesignDataMenuEditForm.RefreshApplicationMenus;
var
  P: TBisProvider;
  Param: TBisParam;
  ApplicationId: Variant;
  i: Integer;
  Obj: TBisApplicationInfo;
begin
  Param:=Provider.Params.Find('MENU_ID');
  if Assigned(Param) and not Param.Empty then begin
    CheckListBoxApplications.Items.BeginUpdate;
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_APPLICATION_MENUS';
      P.FieldNames.AddInvisible('APPLICATION_ID');
      P.FilterGroups.Add.Filters.Add('MENU_ID',fcEqual,Param.Value);
      P.Open;
      if P.Active then begin
        P.First;
        while not P.Eof do begin
          ApplicationId:=P.FieldByName('APPLICATION_ID').Value;
          for i:=0 to CheckListBoxApplications.Items.Count-1 do begin
            Obj:=TBisApplicationInfo(CheckListBoxApplications.Items.Objects[i]);
            if VarSameValue(ApplicationId,Obj.ApplicationId) then begin
              CheckListBoxApplications.Checked[i]:=true;
            end;
          end;
          P.Next;
        end;
      end;
    finally
      P.Free;
      CheckListBoxApplications.Items.EndUpdate;
    end;
  end;
end;

procedure TBisDesignDataMenuEditForm.DeleteApplicationMenus;
var
  P: TBisProvider;
  Obj: TBisApplicationInfo;
  Param: TBisParam;
  i: Integer;
begin
  Param:=Provider.Params.Find('MENU_ID');
  if Assigned(Param) and not Param.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='D_APPLICATION_MENU';
      P.UseWaitCursor:=false;
      with P.Params do begin
        AddInvisible('APPLICATION_ID').Older('OLD_APPLICATION_ID');
        with AddInvisible('MENU_ID') do begin
          Older('OLD_MENU_ID');
          SetNewValue(Param.Value);
        end;
      end;
      for i:=0 to CheckListBoxApplications.Items.Count-1 do begin
        Obj:=TBisApplicationInfo(CheckListBoxApplications.Items.Objects[i]);
        P.Params.ParamByName('APPLICATION_ID').SetNewValue(Obj.ApplicationId);
        P.Execute;
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisDesignDataMenuEditForm.InsertApplicationMenus;
var
  P: TBisProvider;
  Obj: TBisApplicationInfo;
  Param: TBisParam;
  i: Integer;
begin
  Param:=Provider.Params.Find('MENU_ID');
  if Assigned(Param) and not Param.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='I_APPLICATION_MENU';
      P.UseWaitCursor:=false;
      with P.Params do begin
        AddInvisible('APPLICATION_ID');
        AddInvisible('MENU_ID').SetNewValue(Param.Value);
      end;
      for i:=0 to CheckListBoxApplications.Items.Count-1 do begin
        if CheckListBoxApplications.Checked[i] then begin
          Obj:=TBisApplicationInfo(CheckListBoxApplications.Items.Objects[i]);
          P.Params.ParamByName('APPLICATION_ID').SetNewValue(Obj.ApplicationId);
          P.Execute;
        end;
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisDesignDataMenuEditForm.Execute;
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    inherited Execute;
    if Mode in [emUpdate] then
      DeleteApplicationMenus;
    if Mode in [emInsert,emUpdate,emDuplicate] then
    InsertApplicationMenus;
    if CheckBoxRefresh.Checked then
      Core.RefreshContents;
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

end.
