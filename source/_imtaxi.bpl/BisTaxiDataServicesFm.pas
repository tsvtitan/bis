unit BisTaxiDataServicesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisTaxiDataServicesForm = class(TBisDataGridForm)
  end;

  TBisTaxiDataServicesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataServicesForm: TBisTaxiDataServicesForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataServiceEditFm, BisConsts;

{ TBisTaxiDataServicesFormIface }

constructor TBisTaxiDataServicesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataServicesForm;
  FilterClass:=TBisTaxiDataServiceFilterFormIface;
  InsertClass:=TBisTaxiDataServiceInsertFormIface;
  UpdateClass:=TBisTaxiDataServiceUpdateFormIface;
  DeleteClass:=TBisTaxiDataServiceDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_SERVICES';
  with FieldNames do begin
    AddKey('SERVICE_ID');
    AddInvisible('PRIORITY');
    AddInvisible('DESCRIPTION');
    Add('NAME','Наименование',250);
    Add('COST','Стоимость',100).DisplayFormat:='#0.00';
  end;
  Orders.Add('PRIORITY');
end;

end.
