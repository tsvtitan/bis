unit BisTaxiDataDriverTypesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisTaxiDataDriverTypesForm = class(TBisDataGridForm)
  end;                                                                                          

  TBisTaxiDataDriverTypesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDriverTypesForm: TBisTaxiDataDriverTypesForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataDriverTypeEditFm, BisConsts;

{ TBisTaxiDataDriverTypesFormIface }

constructor TBisTaxiDataDriverTypesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDriverTypesForm;
  FilterClass:=TBisTaxiDataDriverTypeFilterFormIface;
  InsertClass:=TBisTaxiDataDriverTypeInsertFormIface;
  UpdateClass:=TBisTaxiDataDriverTypeUpdateFormIface;
  DeleteClass:=TBisTaxiDataDriverTypeDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_DRIVER_TYPES';
  with FieldNames do begin
    AddKey('DRIVER_TYPE_ID');
    AddInvisible('PRIORITY');
    AddInvisible('VISIBLE');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',250);
  end;
end;

end.
