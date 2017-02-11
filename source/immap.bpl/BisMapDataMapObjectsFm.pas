unit BisMapDataMapObjectsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm, BisDataFrm;
                                                                                                          
type
  TBisMapDataMapObjectsForm = class(TBisDataGridForm)
  end;

  TBisMapDataMapObjectsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMapDataMapObjectsForm: TBisMapDataMapObjectsForm;

implementation

{$R *.dfm}

uses BisUtils, BisConsts,
     BisMapDataMapObjectEditFm;

{ TBisMapDataMapObjectsFormIface }

constructor TBisMapDataMapObjectsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMapDataMapObjectsForm;
  FilterClass:=TBisMapDataMapObjectFilterFormIface;
  InsertClass:=TBisMapDataMapObjectInsertFormIface;
  UpdateClass:=TBisMapDataMapObjectUpdateFormIface;
  DeleteClass:=TBisMapDataMapObjectDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_MAP_OBJECTS';
  with FieldNames do begin
    AddInvisible('STREET_ID').IsKey:=true;
    AddInvisible('STREET_PREFIX');
    AddInvisible('LOCALITY_PREFIX');
    AddInvisible('DATE_CREATE');
    Add('STREET_NAME','�����',140);
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
