unit BisKrieltDataAccountSubscriptionEditFm;

interface
                                                                                                         
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisControls, BisParam, ImgList;

type
  TBisKrieltDataAccountSubscriptionEditForm = class(TBisDataEditForm)
    LabelSubscription: TLabel;
    EditSubscription: TEdit;
    ButtonSubscription: TButton;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelAccessType: TLabel;
    ComboBoxAccessType: TComboBox;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
  end;

  TBisKrieltDataAccountSubscriptionEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAccountSubscriptionFilterFormIface=class(TBisKrieltDataAccountSubscriptionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAccountSubscriptionInsertFormIface=class(TBisKrieltDataAccountSubscriptionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAccountSubscriptionUpdateFormIface=class(TBisKrieltDataAccountSubscriptionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAccountSubscriptionDeleteFormIface=class(TBisKrieltDataAccountSubscriptionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataAccountSubscriptionEditForm: TBisKrieltDataAccountSubscriptionEditForm;

function GetAccessTypeByIndex(Index: Integer): String;
  
implementation

uses Dateutils,
     BisKrieltDataSubscriptionsFm,
     BisCore, BisFilterGroups, BisKrieltConsts;

{$R *.dfm}

function GetAccessTypeByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='на сайте';
    1: Result:='на сайте + уведомление';
    2: Result:='на сайте + архив почтой';
  end;
end;


{ TBisKrieltDataAccountSubscriptionEditFormIface }

constructor TBisKrieltDataAccountSubscriptionEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataAccountSubscriptionEditForm;
  with Params do begin
    AddEditDataSelect('SUBSCRIPTION_ID','EditSubscription','LabelSubscription','ButtonSubscription',
                      TBisKrieltDataSubscriptionsFormIface,'SUBSCRIPTION_NAME',true,true,'','NAME').Older('OLD_SUBSCRIPTION_ID');
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassDataRolesAndAccountsFormIface,'USER_NAME',true,true).Older('OLD_ACCOUNT_ID');
    AddComboBox('ACCESS_TYPE','ComboBoxAccessType','LabelAccessType',true);
    AddEditDate('DATE_BEGIN','DateTimePickerBegin','LabelDateBegin',true).FilterCondition:=fcEqualGreater;
    AddEditDate('DATE_END','DateTimePickerEnd','LabelDateEnd').FilterCondition:=fcEqualLess;
  end;
end;

{ TBisKrieltDataAccountSubscriptionFilterFormIface }

constructor TBisKrieltDataAccountSubscriptionFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataAccountSubscriptionInsertFormIface }

constructor TBisKrieltDataAccountSubscriptionInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACCOUNT_SUBSCRIPTION';
end;

{ TBisKrieltDataAccountSubscriptionUpdateFormIface }

constructor TBisKrieltDataAccountSubscriptionUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACCOUNT_SUBSCRIPTION';
end;

{ TBisKrieltDataAccountSubscriptionDeleteFormIface }

constructor TBisKrieltDataAccountSubscriptionDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACCOUNT_SUBSCRIPTION';
end;


{ TBisKrieltDataAccountSubscriptionEditForm }

constructor TBisKrieltDataAccountSubscriptionEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);
  ComboBoxAccessType.Clear;
  for i:=0 to 2 do begin
    ComboBoxAccessType.Items.Add(GetAccessTypeByIndex(i));
  end;
end;

procedure TBisKrieltDataAccountSubscriptionEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      Find('DATE_BEGIN').SetNewValue(DateOf(Date));
    end;
  end;
  UpdateButtonState;
end;


end.
