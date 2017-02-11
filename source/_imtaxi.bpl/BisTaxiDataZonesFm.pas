unit BisTaxiDataZonesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataFrm, BisDataGridFm;

type
  TBisTaxiDataZonesForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataZonesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataZonesForm: TBisTaxiDataZonesForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataZoneEditFm, BisConsts, BisTaxiDataZonesFrm;

{ TBisTaxiDataZonesFormIface }

constructor TBisTaxiDataZonesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataZonesForm;
  FilterClass:=TBisTaxiDataZoneFilterFormIface;
  InsertClass:=TBisTaxiDataZoneInsertFormIface;
  UpdateClass:=TBisTaxiDataZoneUpdateFormIface;
  DeleteClass:=TBisTaxiDataZoneDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_ZONES';
  with FieldNames do begin
    AddKey('ZONE_ID');
    AddInvisible('PRIORITY');
    AddInvisible('COST_IN');
    AddInvisible('COST_OUT');
    AddInvisible('PRIORITY');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',250);
  end;
  Orders.Add('PRIORITY');
end;

{ TBisTaxiDataZonesForm }

class function TBisTaxiDataZonesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataZonesFrame;
end;

end.
