unit BisTaxiDataCostEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisParam, BisControls, ImgList;

type
  TBisTaxiDataCostEditForm = class(TBisDataEditForm)
    LabelZoneTo: TLabel;
    EditZoneTo: TEdit;                                                                          
    LabelPeriod: TLabel;
    EditPeriod: TEdit;
    LabelDistance: TLabel;
    EditDistance: TEdit;
    LabelCost: TLabel;
    EditCost: TEdit;
    LabelZoneFrom: TLabel;
    EditZoneFrom: TEdit;
  private
  end;

  TBisTaxiDataCostEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCostUpdateFormIface=class(TBisTaxiDataCostEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCostDeleteFormIface=class(TBisTaxiDataCostEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCostEditForm: TBisTaxiDataCostEditForm;

implementation

uses DB, BisUtils;

{$R *.dfm}

{ TBisTaxiDataCostEditFormIface }

constructor TBisTaxiDataCostEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCostEditForm;
  with Params do begin
    AddKey('ZONE_TO_ID').Older('OLD_ZONE_TO_ID');
    AddKey('ZONE_FROM_ID').Older('OLD_ZONE_FROM_ID');
    AddEdit('ZONE_TO_NAME','EditZoneTo','LabelZoneTo').ExcludeModes(AllParamEditModes);
    AddEdit('ZONE_FROM_NAME','EditZoneFrom','LabelZoneFrom').ExcludeModes(AllParamEditModes);
    AddEditInteger('DISTANCE','EditDistance','LabelDistance');
    AddEditInteger('PERIOD','EditPeriod','LabelPeriod');
    AddEditFloat('COST','EditCost','LabelCost');
  end;
end;

{ TBisTaxiDataCostUpdateFormIface }

constructor TBisTaxiDataCostUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_COST';
  Caption:='Изменить стоимость поездки';
end;

{ TBisTaxiDataCostDeleteFormIface }

constructor TBisTaxiDataCostDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_COST';
  Caption:='Удалить стоимость поездки';
end;

end.
