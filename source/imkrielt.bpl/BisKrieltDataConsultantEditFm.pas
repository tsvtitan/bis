unit BisKrieltDataConsultantEditFm;

interface                                                                                           

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst, ComCtrls, Menus, ActnPopup, ExtDlgs, ImgList,
  BisDataEditFm, BisParam, BisControls;

type
  TBisKrieltDataConsultantEditForm = class(TBisDataEditForm)
    LabelUserName: TLabel;
    EditUserName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPassword: TLabel;
    EditPassword: TEdit;
    CheckBoxLocked: TCheckBox;
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
    LabelFirm: TLabel;
    EditFirm: TEdit;
    ButtonFirm: TButton;
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
    LabelJobTitle: TLabel;
    EditJobTitle: TEdit;
    procedure ButtonPhotoClick(Sender: TObject);
    procedure PopupActionBarPhotoPopup(Sender: TObject);
    procedure MenuItemLoadPhotoClick(Sender: TObject);
    procedure MenuItemSavePhotoClick(Sender: TObject);
    procedure MenuItemClearPhotoClick(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
    function ChangesExists: Boolean; override;
    procedure Execute; override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisKrieltDataConsultantEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataConsultantInsertFormIface=class(TBisKrieltDataConsultantEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataConsultantUpdateFormIface=class(TBisKrieltDataConsultantEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataConsultantDeleteFormIface=class(TBisKrieltDataConsultantEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataConsultantEditForm: TBisKrieltDataConsultantEditForm;

implementation

uses DateUtils, DB,
     BisFilterGroups, BisProvider, BisUtils, BisCore,
     BisKrieltConsts;

{$R *.dfm}

{ TBisKrieltDataConsultantEditFormIface }

constructor TBisKrieltDataConsultantEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataConsultantEditForm;
  with Params do begin
    with AddKey('CONSULTANT_ID') do begin
      Older('OLD_CONSULTANT_ID');
    end;
    AddEdit('USER_NAME','EditUserName','LabelUserName',true);
    AddEdit('PASSWORD','EditPassword','LabelPassword');
    AddCheckBox('LOCKED','CheckBoxLocked').ExcludeModes([emFilter]);
    AddEdit('SURNAME','EditSurname','LabelSurname',true);
    AddEdit('NAME','EditName','LabelName',true);
    AddEdit('PATRONYMIC','EditPatronymic','LabelPatronymic',true);
    AddImage('PHOTO','ImagePhoto').ExcludeModes([emDelete,emFilter]);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEdit('PHONE','EditPhone','LabelPhone');
    AddEdit('EMAIL','EditEmail','LabelEmail',true);
    AddEditDataSelect('FIRM_ID','EditFirm','LabelFirm','ButtonFirm',
                      SIfaceClassDataFirmsFormIface,'FIRM_SMALL_NAME',false,false,'','SMALL_NAME');
    AddEdit('JOB_TITLE','EditJobTitle','LabelJobTitle');
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes([emFilter,emUpdate]);
  end;
end;

{ TBisKrieltDataConsultantInsertFormIface }

constructor TBisKrieltDataConsultantInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CONSULTANT';
  Caption:='������� ������������';
end;

{ TBisKrieltDataConsultantUpdateFormIface }

constructor TBisKrieltDataConsultantUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CONSULTANT';
  Caption:='�������� ������������';
end;

{ TBisKrieltDataConsultantDeleteFormIface }

constructor TBisKrieltDataConsultantDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CONSULTANT';
  Caption:='������� ������������';
end;

{ TBisKrieltDataConsultantEditForm }

constructor TBisKrieltDataConsultantEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Provider.WithWaitCursor:=true;
  EditPassword.Password:=true;
  ImagePhoto.ControlStyle:=ImagePhoto.ControlStyle+[csReflector];
end;

procedure TBisKrieltDataConsultantEditForm.BeforeShow;
begin
  inherited BeforeShow;
  ButtonPhoto.Enabled:=Mode in [emInsert,emUpdate,emDuplicate];
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      Find('DATE_CREATE').SetNewValue(Core.ServerDate);
    end;
  end;
  ButtonPhoto.Enabled:=Mode in [emInsert,emDuplicate,emUpdate];
  UpdateButtonState;
end;

procedure TBisKrieltDataConsultantEditForm.ButtonPhotoClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=PanelPhoto.ClientToScreen(Point(ButtonPhoto.Left,ButtonPhoto.Top+ButtonPhoto.Height));
  PopupActionBarPhoto.Popup(Pt.X,Pt.Y);
end;

procedure TBisKrieltDataConsultantEditForm.ChangeParam(Param: TBisParam);
var
  P: TBisProvider;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'CONSULTANT_ID') and not Param.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_CONSULTANTS';
      P.FieldNames.AddInvisible('PHOTO');
      P.FilterGroups.Add.Filters.Add('CONSULTANT_ID',fcEqual,Param.Value);
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

end;

function TBisKrieltDataConsultantEditForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists;
end;

procedure TBisKrieltDataConsultantEditForm.MenuItemClearPhotoClick(
  Sender: TObject);
begin
  Provider.Params.ParamByName('PHOTO').Clear;
end;

procedure TBisKrieltDataConsultantEditForm.MenuItemLoadPhotoClick(
  Sender: TObject);
begin
  if OpenPictureDialog.Execute then
    Provider.Params.ParamByName('PHOTO').LoadFromFile(OpenPictureDialog.FileName);
end;

procedure TBisKrieltDataConsultantEditForm.MenuItemSavePhotoClick(
  Sender: TObject);
begin
  if SavePictureDialog.Execute then
    Provider.Params.ParamByName('PHOTO').SaveToFile(SavePictureDialog.FileName);
end;

procedure TBisKrieltDataConsultantEditForm.PopupActionBarPhotoPopup(
  Sender: TObject);
var
  Param: TBisParam;
begin
  Param:=Provider.Params.ParamByName('PHOTO');
  MenuItemSavePhoto.Enabled:=not Param.Empty;
  MenuItemClearPhoto.Enabled:=MenuItemSavePhoto.Enabled;
end;

procedure TBisKrieltDataConsultantEditForm.Execute;
begin
  inherited Execute;
end;


end.
