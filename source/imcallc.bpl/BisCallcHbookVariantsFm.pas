unit BisCallcHbookVariantsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DBCtrls;

type
  TBiCallcHbookVariantsForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoDescription: TDBMemo;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookVariantsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookVariantsForm: TBiCallcHbookVariantsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisCallcHbookVariantEditFm;

{ TBisCallcHbookVariantsFormIface }

constructor TBisCallcHbookVariantsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBiCallcHbookVariantsForm;
  InsertClass:=TBisCallcHbookVariantInsertFormIface;
  UpdateClass:=TBisCallcHbookVariantUpdateFormIface;
  DeleteClass:=TBisCallcHbookVariantDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_VARIANTS';
  with FieldNames do begin
    AddKey('VARIANT_ID');
    AddInvisible('CURRENCY_ID');
    AddInvisible('DESCRIPTION');
    Add('NAME','������������',200);
    Add('CURRENCY_NAME','������',50);
    Add('PROC_NAME','��������� �������',150);
  end;
  Orders.Add('CURRENCY_NAME');
  Orders.Add('NAME');
end;

{ TBiCallcHbookVariantsForm }

constructor TBiCallcHbookVariantsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    DBMemoDescription.DataSource:=DataFrame.DataSource;
  end;
end;

end.