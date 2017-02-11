unit BisKrieltDataCreditProgramEditFm;
                                                                                                     
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, BisParam, ImgList;

type
  TBisKrieltDataCreditProgramEditForm = class(TBisDataEditForm)
    LabelFirm: TLabel;
    EditFirm: TEdit;
    ButtonFirm: TButton;
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelPeriodMin: TLabel;
    EditPeriodMin: TEdit;
    LabelPeriodMax: TLabel;
    EditPeriodMax: TEdit;
    LabelRateFrom: TLabel;
    EditRateFrom: TEdit;
    LabelRateBefore: TLabel;
    EditRateBefore: TEdit;
    LabelAmountMin: TLabel;
    EditAmountMin: TEdit;
    LabelAmountMax: TLabel;
    EditAmountMax: TEdit;
    LabelAgeFrom: TLabel;
    EditAgeFrom: TEdit;
    LabelAgeBefore: TLabel;
    EditAgeBefore: TEdit;
    LabelCurrency: TLabel;
    ComboBoxCurrency: TComboBox;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataCreditProgramEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataCreditProgramFilterFormIface=class(TBisKrieltDataCreditProgramEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataCreditProgramInsertFormIface=class(TBisKrieltDataCreditProgramEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataCreditProgramUpdateFormIface=class(TBisKrieltDataCreditProgramEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataCreditProgramDeleteFormIface=class(TBisKrieltDataCreditProgramEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataCreditProgramEditForm: TBisKrieltDataCreditProgramEditForm;

function GetProgramTypeByIndex(Index: Integer): String;

implementation

{$R *.dfm}

uses BisProvider, BisCore, BisInterfaces, BisIfaces, BisKrieltConsts;

function GetProgramTypeByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='ипотека';
  end;
end;
     

{ TBisKrieltDataCreditProgramEditFormIface }

constructor TBisKrieltDataCreditProgramEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataCreditProgramEditForm;
  with Params do begin
    AddKey('CREDIT_PROGRAM_ID').Older('OLD_CREDIT_PROGRAM_ID');
    AddEditDataSelect('FIRM_ID','EditFirm','LabelFirm','ButtonFirm',
                      SIfaceClassDataFirmsFormIface,'FIRM_SMALL_NAME',true,false,'','SMALL_NAME');
    AddEdit('NAME','EditName','LabelName',true);
    AddComboBox('PROGRAM_TYPE','ComboBoxType','LabelType',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEditInteger('PERIOD_MIN','EditPeriodMin','LabelPeriodMin');
    AddEditInteger('PERIOD_MAX','EditPeriodMax','LabelPeriodMax');
    AddEditFloat('RATE_FROM','EditRateFrom','LabelRateFrom');
    AddEditFloat('RATE_BEFORE','EditRateBefore','LabelRateBefore');
    AddEditFloat('AMOUNT_MIN','EditAmountMin','LabelAmountMin');
    AddEditFloat('AMOUNT_MAX','EditAmountMax','LabelAmountMax');
    AddEditInteger('AGE_FROM','EditAgeFrom','LabelAgeFrom');
    AddEditInteger('AGE_BEFORE','EditAgeBefore','LabelAgeBefore');
    AddComboBox('CURRENCY','ComboBoxCurrency','LabelCurrency',true);
  end;
end;

{ TBisKrieltDataCreditProgramFilterFormIface }

constructor TBisKrieltDataCreditProgramFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataCreditProgramInsertFormIface }

constructor TBisKrieltDataCreditProgramInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CREDIT_PROGRAM';
end;

{ TBisKrieltDataCreditProgramUpdateFormIface }

constructor TBisKrieltDataCreditProgramUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CREDIT_PROGRAM';
end;

{ TBisKrieltDataCreditProgramDeleteFormIface }

constructor TBisKrieltDataCreditProgramDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CREDIT_PROGRAM';
end;


{ TBisKrieltDataCreditProgramEditForm }

constructor TBisKrieltDataCreditProgramEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);
  ComboBoxType.Clear;
  for i:=0 to 0 do begin
    ComboBoxType.Items.Add(GetProgramTypeByIndex(i));
  end;
end;

end.
