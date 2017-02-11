unit BisKrieltDataBannerPageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type
  TBisKrieltDataPlacementEditForm = class(TBisDataEditForm)
    LabelPage: TLabel;
    EditPage: TEdit;
    ButtonPage: TButton;
    LabelBanner: TLabel;
    EditBanner: TEdit;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelPlace: TLabel;
    ComboBoxPlace: TComboBox;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
    LabelWhoplaced: TLabel;
    EditWhoplaced: TEdit;
    ButtonWhoplaced: TButton;
    LabelDatePlaced: TLabel;
    DateTimePickerDatePlacedDate: TDateTimePicker;
    DateTimePickerDatePlacedTime: TDateTimePicker;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelCounter: TLabel;
    EditCounter: TEdit;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
  end;

  TBisKrieltDataBannerPageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataBannerPageFilterFormIface=class(TBisKrieltDataBannerPageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataBannerPageInsertFormIface=class(TBisKrieltDataBannerPageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataBannerPageUpdateFormIface=class(TBisKrieltDataBannerPageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataBannerPageDeleteFormIface=class(TBisKrieltDataBannerPageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataPlacementEditForm: TBisKrieltDataPlacementEditForm;

implementation

uses Dateutils,
     BisKrieltDataBannersFm, BisKrieltDataPagesFm,
     BisCore, BisFilterGroups, BisKrieltConsts;

{$R *.dfm}

{ TBisKrieltDataBannerPageEditFormIface }

constructor TBisKrieltDataBannerPageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataBannerPageEditForm;
  with Params do begin
    AddEditDataSelect('Banner_ID','EditBanner','LabelBanner','ButtonBanner',
                      TBisKrieltDataBannersFormIface,'Banner_NAME',true,true,'','NAME').Older('OLD_Banner_ID');
    AddEditDataSelect('PAGE_ID','EditPage','LabelPage','ButtonPage',
                      TBisKrieltDataPagesFormIface,'PAGE_NAME',true,true,'','NAME').Older('OLD_PAGE_ID');
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassDataRolesAndAccountsFormIface,'USER_NAME',true,true).Older('OLD_ACCOUNT_ID');
    AddInvisible('PLACE').Value:=0;                      
    AddComboBoxTextIndex('PLACE2','ComboBoxPlace','LabelPlace',true);
    AddEditDate('DATE_BEGIN','DateTimePickerBegin','LabelDateBegin',true).FilterCondition:=fcEqualGreater;
    AddEditDate('DATE_END','DateTimePickerEnd','LabelDateEnd').FilterCondition:=fcEqualLess;
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
    AddEditInteger('COUNTER','EditCounter','LabelCounter');
    AddEditDataSelect('WHO_PLACED','EditWhoplaced','LabelWhoplaced','ButtonWhoplaced',
                      SIfaceClassDataAccountsFormIface,'WHO_PLACED_NAME',true,false,'ACCOUNT_ID','USER_NAME');
    AddEditDateTime('DATE_PLACED','DateTimePickerDatePlacedDate','DateTimePickerDatePlacedTime','LabelDatePlaced',true).ExcludeModes([emFilter]);
  end;
end;

{ TBisKrieltDataBannerPageFilterFormIface }

constructor TBisKrieltDataBannerPageFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataBannerPageInsertFormIface }

constructor TBisKrieltDataBannerPageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_Banner_PAGE';
end;

{ TBisKrieltDataBannerPageUpdateFormIface }

constructor TBisKrieltDataBannerPageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_Banner_PAGE';
end;

{ TBisKrieltDataBannerPageDeleteFormIface }

constructor TBisKrieltDataBannerPageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_Banner_PAGE';
end;


{ TBisKrieltDataBannerPageEditForm }

constructor TBisKrieltDataPlacementEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisKrieltDataPlacementEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      Find('DATE_BEGIN').SetNewValue(DateOf(Date));
      Find('WHO_PLACED').SetNewValue(Core.AccountId);
      Find('WHO_PLACED_NAME').SetNewValue(Core.AccountUserName);
      Find('DATE_PLACED').SetNewValue(Now);
    end;
  end;
  UpdateButtonState;
end;


end.
