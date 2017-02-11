unit BisCallcHbookVariantEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcHbookVariantEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelCurrency: TLabel;
    EditCurrency: TEdit;
    ButtonCurrency: TButton;
    LabelProc: TLabel;
    EditProc: TEdit;
  private
    { Private declarations }
  public
  end;

  TBisCallcHbookVariantEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookVariantInsertFormIface=class(TBisCallcHbookVariantEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookVariantUpdateFormIface=class(TBisCallcHbookVariantEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookVariantDeleteFormIface=class(TBisCallcHbookVariantEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookVariantEditForm: TBisCallcHbookVariantEditForm;

implementation

uses BisCallcHbookCurrencyFm;

{$R *.dfm}

{ TBisCallcHbookVariantEditFormIface }

constructor TBisCallcHbookVariantEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookVariantEditForm;
  with Params do begin
    AddKey('VARIANT_ID').Older('OLD_VARIANT_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddEditDataSelect('CURRENCY_ID','EditCurrency','LabelCurrency','ButtonCurrency',
                      TBisCallcHbookCurrencyFormIface,'CURRENCY_NAME',true,false,'','NAME');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEdit('PROC_NAME','EditProc','LabelProc',true);
  end;
end;

{ TBisCallcHbookVariantInsertFormIface }

constructor TBisCallcHbookVariantInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_VARIANT';
end;

{ TBisCallcHbookVariantUpdateFormIface }

constructor TBisCallcHbookVariantUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_VARIANT';
end;

{ TBisCallcHbookVariantDeleteFormIface }

constructor TBisCallcHbookVariantDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_VARIANT';
end;

end.
