unit BisCallcHbookCurrencyFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBiCallcHbookCurrencyForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookCurrencyFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookCurrencyForm: TBiCallcHbookCurrencyForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisCallcHbookCurrencyEditFm;

{ TBisCallcHbookCurrencyFormIface }

constructor TBisCallcHbookCurrencyFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBiCallcHbookCurrencyForm;
  InsertClass:=TBisCallcHbookCurrencyInsertFormIface;
  UpdateClass:=TBisCallcHbookCurrencyUpdateFormIface;
  DeleteClass:=TBisCallcHbookCurrencyDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_CURRENCY';
  with FieldNames do begin
    AddKey('CURRENCY_ID');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',150);
    AddInvisible('PRIORITY');
  end;
  Orders.Add('PRIORITY');
end;

end.
