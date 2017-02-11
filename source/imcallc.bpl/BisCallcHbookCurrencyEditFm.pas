unit BisCallcHbookCurrencyEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcHbookCurrencyEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookCurrencyEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookCurrencyInsertFormIface=class(TBisCallcHbookCurrencyEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookCurrencyUpdateFormIface=class(TBisCallcHbookCurrencyEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookCurrencyDeleteFormIface=class(TBisCallcHbookCurrencyEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookCurrencyEditForm: TBisCallcHbookCurrencyEditForm;

implementation

{$R *.dfm}

{ TBisCallcHbookCurrencyEditFormIface }

constructor TBisCallcHbookCurrencyEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookCurrencyEditForm;
  with Params do begin
    AddKey('CURRENCY_ID').Older('OLD_CURRENCY_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisCallcHbookCurrencyInsertFormIface }

constructor TBisCallcHbookCurrencyInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CURRENCY';
end;

{ TBisCallcHbookCurrencyUpdateFormIface }

constructor TBisCallcHbookCurrencyUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CURRENCY';
end;

{ TBisCallcHbookCurrencyDeleteFormIface }

constructor TBisCallcHbookCurrencyDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CURRENCY';
end;

end.
