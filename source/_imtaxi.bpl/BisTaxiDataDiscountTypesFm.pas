unit BisTaxiDataDiscountTypesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisTaxiDataDiscountTypesForm = class(TBisDataGridForm)
  end;

  TBisTaxiDataDiscountTypesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDiscountTypesForm: TBisTaxiDataDiscountTypesForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataDiscountTypeEditFm, BisConsts;

{ TBisTaxiDataDiscountTypesFormIface }

constructor TBisTaxiDataDiscountTypesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDiscountTypesForm;
  FilterClass:=TBisTaxiDataDiscountTypeFilterFormIface;
  InsertClass:=TBisTaxiDataDiscountTypeInsertFormIface;
  UpdateClass:=TBisTaxiDataDiscountTypeUpdateFormIface;
  DeleteClass:=TBisTaxiDataDiscountTypeDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_DISCOUNT_TYPES';
  with FieldNames do begin
    AddKey('DISCOUNT_TYPE_ID');
    AddInvisible('PRIORITY');
    AddInvisible('TYPE_CALC');
    AddInvisible('PERCENT');
    AddInvisible('DISCOUNT_SUM');
    AddInvisible('PROC_NAME');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',250);
  end;
  Orders.Add('PRIORITY');
end;

end.