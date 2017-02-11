unit BisKrieltDataAccountPresentationEditFm;

interface

uses                                                                                                        
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisKrieltDataAccountPresentationEditForm = class(TBisDataEditForm)
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelView: TLabel;
    EditView: TEdit;
    ButtonView: TButton;
    LabelType: TLabel;
    EditType: TEdit;
    ButtonType: TButton;
    LabelOperation: TLabel;
    EditOperation: TEdit;
    ButtonOperation: TButton;
    LabelPresentation: TLabel;
    EditPresentation: TEdit;
    ButtonPresentation: TButton;
    CheckBoxRefresh: TCheckBox;
    LabelPublishing: TLabel;
    EditPublishing: TEdit;
    ButtonPublishing: TButton;
    ComboBoxWeekday: TComboBox;
    LabelWeekday: TLabel;
  private
    { Private declarations }
  public
    procedure Execute; override;
  end;

  TBisKrieltDataAccountPresentationEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAccountPresentationFilterFormIface=class(TBisKrieltDataAccountPresentationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAccountPresentationInsertFormIface=class(TBisKrieltDataAccountPresentationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAccountPresentationUpdateFormIface=class(TBisKrieltDataAccountPresentationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAccountPresentationDeleteFormIface=class(TBisKrieltDataAccountPresentationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataAccountPresentationEditForm: TBisKrieltDataAccountPresentationEditForm;

implementation

uses BisKrieltConsts, BisKrieltDataPresentationsFm, BisKrieltDataViewsFm,
     BisKrieltDataTypesFm, BisKrieltDataOperationsFm, BisKrieltDataPublishingFm,
     BisCore, BisFilterGroups;

{$R *.dfm}

{ TBisKrieltDataAccountPresentationEditFormIface }

constructor TBisKrieltDataAccountPresentationEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataAccountPresentationEditForm;
  with Params do begin
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassDataRolesAndAccountsFormIface,'USER_NAME',true,true).Older('OLD_ACCOUNT_ID');
    AddEditDataSelect('PUBLISHING_ID','EditPublishing','LabelPublishing','ButtonPublishing',
                      TBisKrieltDataPublishingFormIface,'PUBLISHING_NAME',true,true,'','NAME').Older('OLD_PUBLISHING_ID');
    AddEditDataSelect('VIEW_ID','EditView','LabelView','ButtonView',
                      TBisKrieltDataViewsFormIface,'VIEW_NAME',true,true,'','NAME').Older('OLD_VIEW_ID');
    AddEditDataSelect('TYPE_ID','EditType','LabelType','ButtonType',
                      TBisKrieltDataTypesFormIface,'TYPE_NAME',true,true,'','NAME').Older('OLD_TYPE_ID');
    AddEditDataSelect('OPERATION_ID','EditOperation','LabelOperation','ButtonOperation',
                      TBisKrieltDataOperationsFormIface,'OPERATION_NAME',true,true,'','NAME').Older('OLD_OPERATION_ID');
    with AddEditDataSelect('PRESENTATION_ID','EditPresentation','LabelPresentation','ButtonPresentation',
                           TBisKrieltDataPresentationsFormIface,'PRESENTATION_NAME',true,false,'','NAME') do
      FilterGroups.Add.Filters.Add('PRESENTATION_TYPE',fcEqual,0);

    AddComboBoxIndex('WEEKDAY','ComboBoxWeekday','LabelWeekday',true);
    AddEdit('CONDITIONS','EditConditions','LabelConditions');
  end;
end;

{ TBisKrieltDataAccountPresentationFilterFormIface }

constructor TBisKrieltDataAccountPresentationFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataAccountPresentationInsertFormIface }

constructor TBisKrieltDataAccountPresentationInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACCOUNT_PRESENTATION';
end;

{ TBisKrieltDataAccountPresentationUpdateFormIface }

constructor TBisKrieltDataAccountPresentationUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACCOUNT_PRESENTATION';
end;

{ TBisKrieltDataAccountPresentationDeleteFormIface }

constructor TBisKrieltDataAccountPresentationDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACCOUNT_PRESENTATION';
end;


{ TBisKrieltDataAccountPresentationEditForm }

procedure TBisKrieltDataAccountPresentationEditForm.Execute;
begin
  inherited Execute;
  if CheckBoxRefresh.Checked then
    Core.RefreshContents;
end;

end.