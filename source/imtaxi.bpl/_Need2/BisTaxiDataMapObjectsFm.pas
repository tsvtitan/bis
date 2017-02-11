unit BisTaxiDataMapObjectsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm, BisDataFrm;
                                                                                                          
type
  TBisTaxiDataMapObjectsForm = class(TBisDataGridForm)
  end;

  TBisTaxiDataMapObjectsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataMapObjectsForm: TBisTaxiDataMapObjectsForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataMapObjectEditFm, BisConsts;

{ TBisTaxiDataMapObjectsFormIface }

constructor TBisTaxiDataMapObjectsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataMapObjectsForm;
  FilterClass:=TBisTaxiDataMapObjectFilterFormIface;
  InsertClass:=TBisTaxiDataMapObjectInsertFormIface;
  UpdateClass:=TBisTaxiDataMapObjectUpdateFormIface;
  DeleteClass:=TBisTaxiDataMapObjectDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_MAP_OBJECTS';
  with FieldNames do begin
    AddInvisible('STREET_ID').IsKey:=true;
    AddInvisible('STREET_PREFIX');
    AddInvisible('LOCALITY_PREFIX');
    Add('STREET_NAME','�����',145);
    Add('HOUSE','���',50).IsKey:=true;
    Add('LOCALITY_NAME','���������� �����',95);
    Add('LAT','������',105).DisplayFormat:='#0.000000000';
    Add('LON','�������',105).DisplayFormat:='#0.000000000';
  end;
  with Orders do begin
    Add('LOCALITY_NAME');
    Add('STREET_NAME');
    Add('HOUSE');
  end;
  FilterOnShow:=true;
end;

end.
