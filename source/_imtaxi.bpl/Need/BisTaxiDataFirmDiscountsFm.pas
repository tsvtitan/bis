unit BisTaxiDataFirmDiscountsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisTaxiDataFirmDiscountsForm = class(TBisDataGridForm)
  end;

  TBisTaxiDataFirmDiscountsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataFirmDiscountsForm: TBisTaxiDataFirmDiscountsForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataFirmDiscountEditFm, BisConsts, BisOrders;

{ TBisTaxiDataFirmDiscountsFormIface }

constructor TBisTaxiDataFirmDiscountsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataFirmDiscountsForm;
  FilterClass:=TBisTaxiDataFirmDiscountFilterFormIface;
  InsertClass:=TBisTaxiDataFirmDiscountInsertFormIface;
  UpdateClass:=TBisTaxiDataFirmDiscountUpdateFormIface;
  DeleteClass:=TBisTaxiDataFirmDiscountDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_FIRM_DISCOUNTS';
  with FieldNames do begin
    AddKey('FIRM_ID');
    AddKey('DISCOUNT_ID');
    AddInvisible('PRIORITY');
    AddInvisible('TYPE_DISCOUNT');
    AddInvisible('PROC_NAME');
    AddInvisible('PERCENT');
    AddInvisible('DISCOUNT_SUM');
    Add('FIRM_SMALL_NAME','������',250);
    Add('DISCOUNT_NAME','������',150);
  end;
  Orders.Add('FIRM_SMALL_NAME');
  Orders.Add('PRIORITY');
end;

end.