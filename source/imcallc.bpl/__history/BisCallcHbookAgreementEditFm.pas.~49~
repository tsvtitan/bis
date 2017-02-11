unit BisCallcHbookAgreementEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisFm, BisControls;

type
  TBisCallcHbookAgreementEditForm = class(TBisDataEditForm)
    LabelNum: TLabel;
    LabelFirm: TLabel;
    EditNum: TEdit;
    EditFirm: TEdit;
    ButtonFirm: TButton;
    LabelParent: TLabel;
    EditParent: TEdit;
    ButtonParent: TButton;
    LabelVariant: TLabel;
    EditVariant: TEdit;
    ButtonVariant: TButton;
    DateTimePickerBegin: TDateTimePicker;
    LabelDateBegin: TLabel;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookAgreementEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookAgreementInsertFormIface=class(TBisCallcHbookAgreementEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookAgreementInsertChildFormIface=class(TBisCallcHbookAgreementEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;
  
  TBisCallcHbookAgreementUpdateFormIface=class(TBisCallcHbookAgreementEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookAgreementDeleteFormIface=class(TBisCallcHbookAgreementEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookAgreementEditForm: TBisCallcHbookAgreementEditForm;

implementation

uses BisCallcConsts,
     BisCallcHbookAgreementsFm, BisCallcHbookVariantsFm;

{$R *.dfm}

{ TBisCallcHbookAgreementEditFormIface }

constructor TBisCallcHbookAgreementEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookAgreementEditForm;
  with Params do begin
    AddKey('AGREEMENT_ID').Older('OLD_AGREEMENT_ID');
    AddEditDataSelect('PARENT_ID','EditParent','LabelParent','ButtonParent',
                      TBisCallcHbookAgreementsFormIface,'PARENT_NUM',false,false,'AGREEMENT_ID','NUM');
    AddEdit('NUM','EditNum','LabelNum',true);
    AddEditDataSelect('FIRM_ID','EditFirm','LabelFirm','ButtonFirm',
                      SIfaceClassHbookFirmsFormIface,'FIRM_SMALL_NAME',true,false,'','SMALL_NAME');
    AddEditDataSelect('VARIANT_ID','EditVariant','LabelVariant','ButtonVariant',
                      TBisCallcHbookVariantsFormIface,'VARIANT_NAME',true,false,'','NAME');
    AddEditDate('DATE_BEGIN','DateTimePickerBegin','LabelDateBegin',true);
    AddEditDate('DATE_END','DateTimePickerEnd','LabelDateEnd');
  end;
end;

{ TBisCallcHbookAgreementInsertFormIface }

constructor TBisCallcHbookAgreementInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_AGREEMENT';
end;

function TBisCallcHbookAgreementInsertFormIface.CreateForm: TBisForm; 
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentProvider) and ParentProvider.Active and not ParentProvider.IsEmpty then begin
      with LastForm.Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentProvider.FieldByName('PARENT_ID').Value);
        Params.ParamByName('PARENT_NUM').SetNewValue(ParentProvider.FieldByName('PARENT_NUM').Value);
      end;
    end;
  end;
end;

{ TBisCallcHbookAgreementInsertChildFormIface }

constructor TBisCallcHbookAgreementInsertChildFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_AGREEMENT';
  Caption:='Создать дочерний договор';
end;

function TBisCallcHbookAgreementInsertChildFormIface.CreateForm: TBisForm; 
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentProvider) and ParentProvider.Active and not ParentProvider.IsEmpty then begin
      with LastForm.Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentProvider.FieldByName('AGREEMENT_ID').Value);
        Params.ParamByName('PARENT_NUM').SetNewValue(ParentProvider.FieldByName('NUM').Value);
      end;
    end;
  end;
end;

{ TBisCallcHbookAgreementUpdateFormIface }

constructor TBisCallcHbookAgreementUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_AGREEMENT';
end;

{ TBisCallcHbookAgreementDeleteFormIface }

constructor TBisCallcHbookAgreementDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_AGREEMENT';
end;

{ TBisCallcHbookAgreementEditForm }

constructor TBisCallcHbookAgreementEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DateTimePickerBegin.Date:=Date;
end;

end.
