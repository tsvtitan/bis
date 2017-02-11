unit BisCallcHbookTaskEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcHbookTaskEditForm = class(TBisDataEditForm)
    LabelResult: TLabel;
    ComboBoxResult: TComboBox;
    ButtonResult: TButton;
    LabelDeal: TLabel;
    EditDeal: TEdit;
    ButtonDeal: TButton;
    LabelAction: TLabel;
    EditAction: TEdit;
    ButtonAction: TButton;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    DateTimePickerTimeCreate: TDateTimePicker;
    DateTimePickerTimeBegin: TDateTimePicker;
    DateTimePickerTimeEnd: TDateTimePicker;
    LabelPerformer: TLabel;
    EditPerformer: TEdit;
    ButtonPerformer: TButton;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
  end;

  TBisCallcHbookTaskEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookTaskInsertFormIface=class(TBisCallcHbookTaskEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookTaskUpdateFormIface=class(TBisCallcHbookTaskEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookTaskDeleteFormIface=class(TBisCallcHbookTaskEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookTaskEditForm: TBisCallcHbookTaskEditForm;

implementation

uses DateUtils,
     BisCallcHbookDealsFm, BisCallcHbookActionsFm, BisCallcConsts, BisCallcHbookResultsFm,
     BisConsts, BisParam;

{$R *.dfm}

{ TBisCallcHbookTaskEditFormIface }

constructor TBisCallcHbookTaskEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookTaskEditForm;
  with Params do begin
    AddKey('TASK_ID').Older('OLD_TASK_ID');
    AddEditDataSelect('DEAL_ID','EditDeal','LabelDeal','ButtonDeal',
                      TBisCallcHbookDealsFormIface,'DEAL_NUM',true);
    AddEditDataSelect('ACTION_ID','EditAction','LabelAction','ButtonAction',
                      TBisCallcHbookActionsFormIface,'ACTION_NAME',true,false,'','NAME');
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerTimeCreate','LabelDateCreate',true);
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerTimeBegin','LabelDateBegin');
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassHbookAccountsFormIface,'USER_NAME');
    AddEditDataSelect('PERFORMER_ID','EditPerformer','LabelPerformer','ButtonPerformer',
                      SIfaceClassHbookAccountsFormIface,'PERFORMER_USER_NAME',false,false,'ACCOUNT_ID','USER_NAME');
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerTimeEnd','LabelDateEnd');
    AddComboBoxDataSelect('RESULT_ID','ComboBoxResult','LabelResult','ButtonResult',
                          TBisCallcHbookResultsFormIface,'RESULT_NAME',false,false,'','NAME');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
  end;
end;

{ TBisCallcHbookTaskInsertFormIface }

constructor TBisCallcHbookTaskInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_TASK';
end;

{ TBisCallcHbookTaskUpdateFormIface }

constructor TBisCallcHbookTaskUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_TASK';
end;

{ TBisCallcHbookTaskDeleteFormIface }

constructor TBisCallcHbookTaskDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_TASK';
end;

{ TBisCallcHbookTaskEditForm }

constructor TBisCallcHbookTaskEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisCallcHbookTaskEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      ParamByName('DATE_CREATE').SetNewValue(Now);
      ParamByName('DATE_BEGIN').SetNewValue(Null);
      ParamByName('DATE_END').SetNewValue(Null);
    end;
  end;
  if Mode in [emFilter] then begin
    EditDeal.ReadOnly:=false;
    EditDeal.Color:=clWindow;
    EditAction.ReadOnly:=false;
    EditAction.Color:=clWindow;
  end;
end;


end.
