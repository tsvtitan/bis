unit BisCallcHbookDealEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcHbookDealEditForm = class(TBisDataEditForm)
    LabelDealNum: TLabel;
    EditDealNum: TEdit;
    LabelDebtor: TLabel;
    EditDebtor: TEdit;
    ButtonDebtor: TButton;
    LabelDateIssue: TLabel;
    DateTimePickerIssue: TDateTimePicker;
    LabelAccountNum: TLabel;
    EditAccountNum: TEdit;
    LabelArrearPeriod: TLabel;
    EditArrearPeriod: TEdit;
    LabelInitialDebt: TLabel;
    EditInitialDebt: TEdit;
    LabelDateClose: TLabel;
    DateTimePickerClose: TDateTimePicker;
    LabelAgreement: TLabel;
    EditAgreement: TEdit;
    ButtonAgreement: TButton;
    LabelPlan: TLabel;
    EditPlan: TEdit;
    ButtonPlan: TButton;
    LabelGroup: TLabel;
    EditGroup: TEdit;
    ButtonGroup: TButton;
    LabelDebtInformation: TLabel;
    MemoDebtInformation: TMemo;
    LabelGuarantors: TLabel;
    MemoGuarantors: TMemo;
    LabelDebtorNum: TLabel;
    EditDebtorNum: TEdit;
    LabelDebtorDate: TLabel;
    DateTimePickerDebtorDate: TDateTimePicker;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
  end;

  TBisCallcHbookDealEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookDealInsertFormIface=class(TBisCallcHbookDealEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookDealUpdateFormIface=class(TBisCallcHbookDealEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookDealDeleteFormIface=class(TBisCallcHbookDealEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookDealEditForm: TBisCallcHbookDealEditForm;

implementation

uses BisCallcHbookGroupsFm, BisCallcHbookPlansFm, BisCallcHbookAgreementsFm,
     BisCallcHbookDebtorsFm, BisParam;

{$R *.dfm}

{ TBisCallcHbookDealEditFormIface }

constructor TBisCallcHbookDealEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookDealEditForm;
  with Params do begin
    AddKey('DEAL_ID').Older('OLD_DEAL_ID');
    AddEdit('DEAL_NUM','EditDealNum','LabelDealNum',true);
    AddEditDataSelect('AGREEMENT_ID','EditAgreement','LabelAgreement','ButtonAgreement',
                      TBisCallcHbookAgreementsFormIface,'AGREEMENT_NUM',true,false,'','NUM');
    AddEditDate('DATE_ISSUE','DateTimePickerIssue','LabelDateIssue',true);
    AddEditDataSelect('DEBTOR_ID','EditDebtor','LabelDebtor','ButtonDebtor',
                      TBisCallcHbookDebtorsFormIface,'DEBTOR_NAME',true,false,'','SURNAME;NAME;PATRONYMIC;DATE_BIRTH');
    AddEditDataSelect('GROUP_ID','EditGroup','LabelGroup','ButtonGroup',
                      TBisCallcHbookGroupsFormIface,'GROUP_NAME',true,false,'','NAME');
    AddEdit('DEBTOR_NUM','EditDebtorNum','LabelDebtorNum',true);
    AddEditDate('DEBTOR_DATE','DateTimePickerDebtorDate','LabelDebtorDate',true);
    AddEditDataSelect('PLAN_ID','EditPlan','LabelPlan','ButtonPlan',
                      TBisCallcHbookPlansFormIface,'PLAN_NAME',false,false,'','NAME');
    AddEdit('ACCOUNT_NUM','EditAccountNum','LabelAccountNum',true);
    AddEditInteger('ARREAR_PERIOD','EditArrearPeriod','LabelArrearPeriod',true);
    AddEditFloat('INITIAL_DEBT','EditInitialDebt','LabelInitialDebt',true);
    AddMemo('DEBT_INFORMATION','MemoDebtInformation','LabelDebtInformation',true);
    AddMemo('GUARANTORS','MemoGuarantors','LabelGuarantors');
    AddEditDate('DATE_CLOSE','DateTimePickerClose','LabelDateClose');
  end;
end;

{ TBisCallcHbookDealInsertFormIface }

constructor TBisCallcHbookDealInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_DEAL';
end;

{ TBisCallcHbookDealUpdateFormIface }

constructor TBisCallcHbookDealUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_DEAL';
end;

{ TBisCallcHbookDealDeleteFormIface }

constructor TBisCallcHbookDealDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_DEAL';
end;

{ TBisCallcHbookDealEditForm }

constructor TBisCallcHbookDealEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DateTimePickerIssue.Date:=Date;
end;

procedure TBisCallcHbookDealEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode=emFilter then begin
    EditDebtor.ReadOnly:=false;
    EditDebtor.Color:=clWindow;
  end;
end;


end.
