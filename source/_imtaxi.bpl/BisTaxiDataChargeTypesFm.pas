unit BisTaxiDataChargeTypesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisTaxiDataChargeTypesForm = class(TBisDataGridForm)
  end;

  TBisTaxiDataChargeTypesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataChargeTypesForm: TBisTaxiDataChargeTypesForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataChargeTypeEditFm, BisConsts;

{ TBisTaxiDataChargeTypesFormIface }

constructor TBisTaxiDataChargeTypesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataChargeTypesForm;
  FilterClass:=TBisTaxiDataChargeTypeFilterFormIface;
  InsertClass:=TBisTaxiDataChargeTypeInsertFormIface;
  UpdateClass:=TBisTaxiDataChargeTypeUpdateFormIface;
  DeleteClass:=TBisTaxiDataChargeTypeDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_CHARGE_TYPES';
  with FieldNames do begin
    AddKey('CHARGE_TYPE_ID');
    AddInvisible('DESCRIPTION');
    Add('NAME','������������',280);
    Add('SUM_CHARGE','�����',70).DisplayFormat:='#0.00';
  end;
  Orders.Add('NAME');
end;

end.
