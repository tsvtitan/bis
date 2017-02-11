unit BisTaxiDataZoneParkEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisParam, BisControls, ImgList;
                                                                                                          
type
  TBisTaxiDataZoneParkEditForm = class(TBisDataEditForm)
    LabelZone: TLabel;
    EditZone: TEdit;
    LabelPeriod: TLabel;
    EditPeriod: TEdit;
    LabelDistance: TLabel;
    EditDistance: TEdit;
    LabelCost: TLabel;
    EditCost: TEdit;
    LabelPark: TLabel;
    EditPark: TEdit;
  private
  end;

  TBisTaxiDataZoneParkEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataZoneParkUpdateFormIface=class(TBisTaxiDataZoneParkEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataZoneParkDeleteFormIface=class(TBisTaxiDataZoneParkEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataZoneParkEditForm: TBisTaxiDataZoneParkEditForm;

implementation

uses DB, BisUtils;

{$R *.dfm}

{ TBisTaxiDataZoneParkEditFormIface }

constructor TBisTaxiDataZoneParkEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataZoneParkEditForm;
  with Params do begin
    AddKey('ZONE_ID').Older('OLD_ZONE_ID');
    AddKey('PARK_ID').Older('OLD_PARK_ID');
    AddInvisible('PARK_NAME');
    AddInvisible('PARK_DESCRIPTION');
    AddEdit('ZONE_NAME','EditZone','LabelZone').ExcludeModes(AllParamEditModes);
    AddEdit('NEW_PARK_NAME','EditPark','LabelPark').ExcludeModes(AllParamEditModes);
    AddEditInteger('DISTANCE','EditDistance','LabelDistance');
    AddEditInteger('PERIOD','EditPeriod','LabelPeriod');
    AddEditFloat('COST','EditCost','LabelCost');
  end;
end;

{ TBisTaxiDataZoneParkUpdateFormIface }

constructor TBisTaxiDataZoneParkUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ZONE_PARK';
  Caption:='Изменить стоимость подачи';
end;

{ TBisTaxiDataZoneParkDeleteFormIface }

constructor TBisTaxiDataZoneParkDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ZONE_PARK';
  Caption:='Удалить стоимость подачи';
end;

end.
