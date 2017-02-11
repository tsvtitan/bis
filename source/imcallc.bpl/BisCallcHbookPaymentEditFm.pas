unit BisCallcHbookPaymentEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB,
  BisDataEditFm, BisParam, BisParamEditFloat, BisControls;

type
  TBisCallcHbookPaymentEditForm = class(TBisDataEditForm)
    LabelDatePayment: TLabel;
    DateTimePickerPayment: TDateTimePicker;
    LabelAmount: TLabel;
    EditAmount: TEdit;
    LabelDeal: TLabel;
    EditDeal: TEdit;
    ButtonDeal: TButton;
    LabelState: TLabel;
    ComboBoxState: TComboBox;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelCurrentDebt: TLabel;
    LabelInitialDebt: TLabel;
  private
    FInitialDebt: Extended;
    FCurrentDebt: Extended;
    FOldAmountPayment: Extended;
    FOldLabelCurrentDebtcaption: String;
    FOldLabelInitialDebtCaption: String;
    FChangeDealId: Boolean;
    procedure GetDealInfo(DealId: Variant; var InitialDebt, AmountPayment, CurrentDebt: Variant);
    procedure UpdateLabelCurrentDebt(AmountPayment: Extended);
    procedure UpdateLabelInitialDebt;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisCallcHbookPaymentEditFormIface=class(TBisDataEditFormIface)
  private
    procedure AccountIdChange(Param: TBisParam);
    function GetLastForm: TBisCallcHbookPaymentEditForm;
  public
    constructor Create(AOwner: TComponent); override;

    property LastForm: TBisCallcHbookPaymentEditForm read GetLastForm;
  end;

  TBisCallcHbookPaymentInsertFormIface=class(TBisCallcHbookPaymentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookPaymentUpdateFormIface=class(TBisCallcHbookPaymentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookPaymentDeleteFormIface=class(TBisCallcHbookPaymentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookPaymentEditForm: TBisCallcHbookPaymentEditForm;

function GetStateByIndex(Index: Integer): String;

implementation

uses BisCallcHbookDealsFm, BisCallcConsts, BisCore, BisProvider,
     BisFilterGroups, BisUtils;

{$R *.dfm}

function GetStateByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='�� ��������';
    1: Result:='��������';
  end;
end;

{ TBisCallcHbookPaymentEditFormIface }

constructor TBisCallcHbookPaymentEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookPaymentEditForm;
  with Params do begin
    AddKey('PAYMENT_ID').Older('OLD_PAYMENT_ID');
    AddInvisible('PERIOD').Value:=1;
    AddEditDataSelect('DEAL_ID','EditDeal','LabelDeal','ButtonDeal',
                      TBisCallcHbookDealsFormIface,'DEAL_NUM',true);
    AddEditDate('DATE_PAYMENT','DateTimePickerPayment','LabelDatePayment',true);
    AddEditFloat('AMOUNT','EditAmount','LabelAmount',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddComboBox('STATE','ComboBoxState','LabelState',true);
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassHbookAccountsFormIface,'USER_NAME',true).OnChange:=AccountIdChange;
  end;
end;

function TBisCallcHbookPaymentEditFormIface.GetLastForm: TBisCallcHbookPaymentEditForm;
begin
  Result:=TBisCallcHbookPaymentEditForm(inherited LastForm);
end;

procedure TBisCallcHbookPaymentEditFormIface.AccountIdChange(Param: TBisParam);
begin

end;


{ TBisCallcHbookPaymentInsertFormIface }

constructor TBisCallcHbookPaymentInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PAYMENT';
end;

{ TBisCallcHbookPaymentUpdateFormIface }

constructor TBisCallcHbookPaymentUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PAYMENT';
end;

{ TBisCallcHbookPaymentDeleteFormIface }

constructor TBisCallcHbookPaymentDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PAYMENT';
end;

{ TBisCallcHbookPaymentEditForm }

constructor TBisCallcHbookPaymentEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ComboBoxState.Clear;
  ComboBoxState.Items.Add(GetStateByIndex(0));
  ComboBoxState.Items.Add(GetStateByIndex(1));
  ComboBoxState.ItemIndex:=0;

  FCurrentDebt:=0.0;
  FOldAmountPayment:=0.0;
  FChangeDealId:=False;

  FOldLabelCurrentDebtcaption:=LabelCurrentDebt.Caption;
  FOldLabelInitialDebtCaption:=LabelInitialDebt.Caption;
end;

procedure TBisCallcHbookPaymentEditForm.GetDealInfo(DealId: Variant;
  var InitialDebt, AmountPayment, CurrentDebt: Variant);
var
  P: TBisProvider;
begin
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='GET_DEAL_INFO';
    with P.Params do begin
      AddInvisible('DEAL_ID').Value:=DealId;
      AddInvisible('INITIAL_DEBT',ptOutput);
      AddInvisible('AMOUNT_PAYMENT',ptOutput);
      AddInvisible('CURRENT_DEBT',ptOutput);
    end;
    P.Execute;
    if P.Success then begin
      InitialDebt:=P.Params.ParamByName('INITIAL_DEBT').Value;
      AmountPayment:=P.Params.ParamByName('AMOUNT_PAYMENT').Value;
      CurrentDebt:=P.Params.ParamByName('CURRENT_DEBT').Value;
    end;
  finally
    P.Free;
  end;
end;

procedure TBisCallcHbookPaymentEditForm.UpdateLabelCurrentDebt(AmountPayment: Extended);
var
  Debt: Extended;
begin
  Debt:=FCurrentDebt-AmountPayment+FOldAmountPayment;
  LabelCurrentDebt.Caption:=Format('%s %s',[FOldLabelCurrentDebtcaption,FormatFloat(SDisplayFormatFloat,Debt)]);
end;

procedure TBisCallcHbookPaymentEditForm.UpdateLabelInitialDebt;
begin
  LabelInitialDebt.Caption:=Format('%s %s',[FOldLabelInitialDebtcaption,FormatFloat(SDisplayFormatFloat,FInitialDebt)]);
end;

procedure TBisCallcHbookPaymentEditForm.ChangeParam(Param: TBisParam);
var
  InitialDebt, AmountPayment, CurrentDebt: Variant;
  AmountParam: TBisParam;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'DEAL_ID') and not Param.Empty then begin
    FChangeDealId:=true;
    GetDealInfo(Param.Value,InitialDebt,AmountPayment,CurrentDebt);
    FCurrentDebt:=VarToExtendedDef(CurrentDebt,0.0);
    FInitialDebt:=VarToExtendedDef(InitialDebt,0.0);
    AmountParam:=Param.Find('AMOUNT');
    if Assigned(AmountParam) then begin
      UpdateLabelCurrentDebt(VarToExtendedDef(AmountParam.Value,0.0));
      UpdateLabelInitialDebt;
    end;
  end;
  if AnsiSameText(Param.ParamName,'AMOUNT') then begin
    if Mode=emUpdate then
      FOldAmountPayment:=VarToExtendedDef(Param.Value,0.0);

    UpdateLabelCurrentDebt(VarToExtendedDef(Param.Value,0.0));
    UpdateLabelInitialDebt;
  end;
end;

procedure TBisCallcHbookPaymentEditForm.BeforeShow;
begin
  with Provider.Params do begin
    ParamByName('DATE_PAYMENT').SetNewValue(Date);
    ParamByName('ACCOUNT_ID').SetNewValue(Core.AccountId);
    ParamByName('USER_NAME').SetNewValue(Core.AccountUserName);
    if not FChangeDealId then
      ParamByName('DEAL_ID').SetNewValue(ParamByName('DEAL_ID').Value);
  end;
  inherited BeforeShow;
end;

end.
