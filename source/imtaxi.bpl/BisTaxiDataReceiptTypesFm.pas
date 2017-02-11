unit BisTaxiDataReceiptTypesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;
                                                                                                         
type
  TBisTaxiDataReceiptTypesForm = class(TBisDataGridForm)
  end;

  TBisTaxiDataReceiptTypesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataReceiptTypesForm: TBisTaxiDataReceiptTypesForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataReceiptTypeEditFm, BisConsts;

{ TBisTaxiDataReceiptTypesFormIface }

constructor TBisTaxiDataReceiptTypesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataReceiptTypesForm;
  FilterClass:=TBisTaxiDataReceiptTypeFilterFormIface;
  InsertClass:=TBisTaxiDataReceiptTypeInsertFormIface;
  UpdateClass:=TBisTaxiDataReceiptTypeUpdateFormIface;
  DeleteClass:=TBisTaxiDataReceiptTypeDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_RECEIPT_TYPES';
  with FieldNames do begin
    AddKey('RECEIPT_TYPE_ID');
    AddInvisible('DESCRIPTION');
    AddInvisible('VIRTUAL');
    Add('NAME','Наименование',250);
    Add('SUM_RECEIPT','Сумма',70).DisplayFormat:='#0.00';
    AddCheckBox('VISIBLE','Видимость',30);
  end;
//  Orders.Add('NAME');
end;

end.
