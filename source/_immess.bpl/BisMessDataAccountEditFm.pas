unit BisMessDataAccountEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst, ComCtrls, Menus, ActnPopup, ExtDlgs,
  ImgList,
  BisDataEditFm, BisParam, BisControls;

type
  TBisMessDataAccountEditForm = class(TBisDataEditForm)
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelSurname: TLabel;
    EditSurname: TEdit;
    LabelName: TLabel;
    EditName: TEdit;
    LabelPatronymic: TLabel;
    EditPatronymic: TEdit;
    LabelPhone: TLabel;
    EditPhone: TEdit;
    LabelEmail: TLabel;
    EditEmail: TEdit;
    GroupBoxRoles: TGroupBox;
    CheckListBoxRoles: TCheckListBox;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    PanelPhoto: TPanel;
    PopupActionBarPhoto: TPopupActionBar;
    MenuItemLoadPhoto: TMenuItem;
    MenuItemSavePhoto: TMenuItem;
    MenuItemClearPhoto: TMenuItem;
    ShapePhoto: TShape;
    ImagePhoto: TImage;
    ButtonPhoto: TButton;
    OpenPictureDialog: TOpenPictureDialog;
    SavePictureDialog: TSavePictureDialog;
    procedure CheckListBoxRolesClickCheck(Sender: TObject);
    procedure ButtonPhotoClick(Sender: TObject);
    procedure PopupActionBarPhotoPopup(Sender: TObject);
    procedure MenuItemLoadPhotoClick(Sender: TObject);
    procedure MenuItemSavePhotoClick(Sender: TObject);
    procedure MenuItemClearPhotoClick(Sender: TObject);
  private
    FChangeRoles: Boolean;
    procedure RefreshRoles;
    procedure RefreshAccountRoles;
    procedure DeleteAccountRoles;
    procedure InsertAccountRoles;
  public
    constructor Create(AOwner: TComponent); override;
    function ChangesExists: Boolean; override;
    procedure Execute; override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisMessDataAccountEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataAccountInsertFormIface=class(TBisMessDataAccountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataAccountUpdateFormIface=class(TBisMessDataAccountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataAccountDeleteFormIface=class(TBisMessDataAccountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessDataAccountEditForm: TBisMessDataAccountEditForm;

implementation

uses DateUtils, DB,
     {BisMessDataFirmsFm, }BisFilterGroups, BisProvider, BisUtils, BisCore;

{$R *.dfm}

type

  TBisRoleInfo=class(TObject)
  private
    var RoleId: Variant;
  end;

{ TBisMessDataAccountEditFormIface }

constructor TBisMessDataAccountEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataAccountEditForm;
  with Params do begin
    with AddKey('ACCOUNT_ID') do begin
      Older('OLD_ACCOUNT_ID');
    end;
    AddInvisible('IS_ROLE').Value:=0;
    AddInvisible('AUTO_CREATED').Value:=0;
    AddInvisible('USER_NAME');
    AddInvisible('PASSWORD');
    AddInvisible('LOCKED').Value:=1;
    AddInvisible('DB_USER_NAME');
    AddInvisible('DB_PASSWORD');
    AddImage('PHOTO','ImagePhoto');
    AddEdit('SURNAME','EditSurname','LabelSurname',true);
    AddEdit('NAME','EditName','LabelName');
    AddEdit('PATRONYMIC','EditPatronymic','LabelPatronymic');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEdit('PHONE','EditPhone','LabelPhone');
    AddEdit('EMAIL','EditEmail','LabelEmail');
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes([emFilter,emUpdate]);
  end;
end;

{ TBisMessDataAccountInsertFormIface }

constructor TBisMessDataAccountInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACCOUNT';
end;

{ TBisMessDataAccountUpdateFormIface }

constructor TBisMessDataAccountUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACCOUNT';
end;

{ TBisMessDataAccountDeleteFormIface }

constructor TBisMessDataAccountDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACCOUNT';
end;

{ TBisMessDataAccountEditForm }

constructor TBisMessDataAccountEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FChangeRoles:=false;
  Provider.WithWaitCursor:=false;
  ImagePhoto.ControlStyle:=ImagePhoto.ControlStyle+[csReflector];
  RefreshRoles;
end;

procedure TBisMessDataAccountEditForm.BeforeShow;
begin
  inherited BeforeShow;
  GroupBoxRoles.Enabled:=Mode in [emInsert,emUpdate,emDuplicate];
  CheckListBoxRoles.Color:=iff(GroupBoxRoles.Enabled,clWindow,clBtnFace);
  PanelPhoto.Color:=CheckListBoxRoles.Color;
  ButtonPhoto.Enabled:=GroupBoxRoles.Enabled;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      Find('DATE_CREATE').SetNewValue(Core.ServerDate);
    end;
  end;
  UpdateButtonState;
  RefreshAccountRoles;
end;

procedure TBisMessDataAccountEditForm.ButtonPhotoClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=PanelPhoto.ClientToScreen(Point(ButtonPhoto.Left,ButtonPhoto.Top+ButtonPhoto.Height));
  PopupActionBarPhoto.Popup(Pt.X,Pt.Y);
end;

procedure TBisMessDataAccountEditForm.ChangeParam(Param: TBisParam);
var
  P1, P2, P3, P4: TBisParam;
  P: TBisProvider;
  S: String;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'ACCOUNT_ID') and not Param.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_ACCOUNTS';
      P.FieldNames.AddInvisible('PHOTO');
      P.FilterGroups.Add.Filters.Add('ACCOUNT_ID',fcEqual,Param.Value);
      P.Open;
      if P.Active and not P.IsEmpty then begin
        with Provider.Params.ParamByName('PHOTO') do begin
          SetNewValue(P.FieldByName('PHOTO').AsString);
        end;
      end;
    finally
      P.Free;
    end;
  end;

  if (AnsiSameText(Param.ParamName,'SURNAME') or
      AnsiSameText(Param.ParamName,'NAME') or
      AnsiSameText(Param.ParamName,'PATRONYMIC')) and (Mode in [emInsert,emDuplicate]) then begin

    P1:=Param.Find('SURNAME');
    P2:=Param.Find('NAME');
    P3:=Param.Find('PATRONYMIC');
    P4:=Param.Find('USER_NAME');
    if Assigned(P1) and Assigned(P2) and Assigned(P3) then begin
      S:='';
      if not P1.Empty then
        S:=VarToStrDef(P1.Value,'');
      if not P2.Empty then
        S:=S+' '+Copy(VarToStrDef(P2.Value,''),1,1)+'.';
      if not P3.Empty then
        S:=S+Copy(VarToStrDef(P3.Value,''),1,1)+'.';
      P4.SetNewValue(S);
      UpdateButtonState;
    end;
  end;

end;

function TBisMessDataAccountEditForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists or FChangeRoles;
end;

procedure TBisMessDataAccountEditForm.CheckListBoxRolesClickCheck(
  Sender: TObject);
begin
  FChangeRoles:=true;
  UpdateButtonState;
end;

procedure TBisMessDataAccountEditForm.DeleteAccountRoles;
var
  P: TBisProvider;
  Obj: TBisRoleInfo;
  Param: TBisParam;
  i: Integer;
begin
  Param:=Provider.Params.Find('ACCOUNT_ID');
  if Assigned(Param) and not Param.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='D_ACCOUNT_ROLE';
      P.WithWaitCursor:=false;
      with P.Params do begin
        AddInvisible('ROLE_ID').Older('OLD_ROLE_ID');
        with AddInvisible('ACCOUNT_ID') do begin
          Older('OLD_ACCOUNT_ID');
          SetNewValue(Param.Value);
        end;
      end;
      for i:=0 to CheckListBoxRoles.Items.Count-1 do begin
        Obj:=TBisRoleInfo(CheckListBoxRoles.Items.Objects[i]);
        P.Params.ParamByName('ROLE_ID').SetNewValue(Obj.RoleId);
        P.Execute;
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisMessDataAccountEditForm.InsertAccountRoles;
var
  P: TBisProvider;
  Obj: TBisRoleInfo;
  Param: TBisParam;
  i: Integer;
begin
  Param:=Provider.Params.Find('ACCOUNT_ID');
  if Assigned(Param) and not Param.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='I_ACCOUNT_ROLE';
      P.WithWaitCursor:=false;
      with P.Params do begin
        AddInvisible('ROLE_ID');
        AddInvisible('ACCOUNT_ID').SetNewValue(Param.Value);
      end;
      for i:=0 to CheckListBoxRoles.Items.Count-1 do begin
        if CheckListBoxRoles.Checked[i] then begin
          Obj:=TBisRoleInfo(CheckListBoxRoles.Items.Objects[i]);
          P.Params.ParamByName('ROLE_ID').SetNewValue(Obj.RoleId);
          P.Execute;
        end;
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisMessDataAccountEditForm.RefreshAccountRoles;
var
  P: TBisProvider;
  Param: TBisParam;
  RoleId: Variant;
  i: Integer;
  Obj: TBisRoleInfo;
begin
  Param:=Provider.Params.Find('ACCOUNT_ID');
  if Assigned(Param) and not Param.Empty then begin
    CheckListBoxRoles.Items.BeginUpdate;
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_ACCOUNT_ROLES';
      P.FieldNames.AddInvisible('ROLE_ID');
      P.FilterGroups.Add.Filters.Add('ACCOUNT_ID',fcEqual,Param.Value);
      P.Open;
      if P.Active then begin
        P.First;
        while not P.Eof do begin
          RoleId:=P.FieldByName('ROLE_ID').Value;
          for i:=0 to CheckListBoxRoles.Items.Count-1 do begin
            Obj:=TBisRoleInfo(CheckListBoxRoles.Items.Objects[i]);
            if VarSameValue(RoleId,Obj.RoleId) then begin
              CheckListBoxRoles.Checked[i]:=true;
            end;
          end;
          P.Next;
        end;
      end;
    finally
      P.Free;
      CheckListBoxRoles.Items.EndUpdate;
    end;
  end;
end;

procedure TBisMessDataAccountEditForm.RefreshRoles;
var
  P: TBisProvider;
  Obj: TBisRoleInfo;
begin
  ClearStrings(CheckListBoxRoles.Items);
  CheckListBoxRoles.Items.BeginUpdate;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_ACCOUNTS';
    with P.FieldNames do begin
      AddInvisible('ACCOUNT_ID');
      AddInvisible('USER_NAME');
    end;
    P.FilterGroups.Add.Filters.Add('IS_ROLE',fcEqual,1);
    P.Orders.Add('USER_NAME');
    P.Open;
    if P.Active then begin
      P.First;
      while not P.Eof do begin
        Obj:=TBisRoleInfo.Create;
        Obj.RoleId:=P.FieldByName('ACCOUNT_ID').Value;
        CheckListBoxRoles.Items.AddObject(P.FieldByName('USER_NAME').AsString,Obj);
        P.Next;
      end;
    end;
  finally
    P.Free;
    CheckListBoxRoles.Items.EndUpdate;
  end;
end;

procedure TBisMessDataAccountEditForm.MenuItemClearPhotoClick(
  Sender: TObject);
begin
  Provider.Params.ParamByName('PHOTO').Clear;
end;

procedure TBisMessDataAccountEditForm.MenuItemLoadPhotoClick(
  Sender: TObject);
begin
  if OpenPictureDialog.Execute then
    Provider.Params.ParamByName('PHOTO').LoadFromFile(OpenPictureDialog.FileName);
end;

procedure TBisMessDataAccountEditForm.MenuItemSavePhotoClick(
  Sender: TObject);
begin
  if SavePictureDialog.Execute then
    Provider.Params.ParamByName('PHOTO').SaveToFile(SavePictureDialog.FileName);
end;

procedure TBisMessDataAccountEditForm.PopupActionBarPhotoPopup(
  Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.ParamByName('PHOTO');
  MenuItemSavePhoto.Enabled:=not Param.Empty;
  MenuItemClearPhoto.Enabled:=MenuItemSavePhoto.Enabled;
end;

procedure TBisMessDataAccountEditForm.Execute;
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    if Mode in [emDelete] then
      DeleteAccountRoles;
    inherited Execute;
    if Mode in [emUpdate] then
      DeleteAccountRoles;
    if Mode in [emInsert,emUpdate,emDuplicate] then
    InsertAccountRoles;
  finally
    Screen.Cursor:=OldCursor;
  end;
end;


end.
