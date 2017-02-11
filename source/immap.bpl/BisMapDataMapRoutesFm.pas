unit BisMapDataMapRoutesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm, BisDataFrm;
                                                                                                          
type
  TBisMapDataMapRoutesForm = class(TBisDataGridForm)
  end;

  TBisMapDataMapRoutesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMapDataMapRoutesForm: TBisMapDataMapRoutesForm;

implementation

{$R *.dfm}

uses BisUtils, BisConsts,
     BisMapDataMapRouteEditFm;

{ TBisMapDataMapRoutesFormIface }

constructor TBisMapDataMapRoutesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMapDataMapRoutesForm;
  FilterClass:=TBisMapDataMapRouteFilterFormIface;
  InsertClass:=TBisMapDataMapRouteInsertFormIface;
  UpdateClass:=TBisMapDataMapRouteUpdateFormIface;
  DeleteClass:=TBisMapDataMapRouteDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_MAP_ROUTES';
  with FieldNames do begin
    AddInvisible('FROM_STREET_ID').IsKey:=true;
    AddInvisible('FROM_STREET_PREFIX');
    AddInvisible('FROM_LOCALITY_PREFIX');
    AddInvisible('TO_STREET_ID').IsKey:=true;
    AddInvisible('TO_STREET_PREFIX');
    AddInvisible('TO_LOCALITY_PREFIX');
    AddInvisible('DATE_CREATE');

    Add('FROM_STREET_NAME','����� ��',120);
    Add('FROM_HOUSE','��� ��',50).IsKey:=true;
    Add('FROM_LOCALITY_NAME','���������� ����� ��',95);

    Add('TO_STREET_NAME','����� �',120);
    Add('TO_HOUSE','��� �',50).IsKey:=true;
    Add('TO_LOCALITY_NAME','���������� ����� �',95);

    Add('DISTANCE','���������� (�)',80);
    Add('DURATION','����� (���)',50);
  end;
  with Orders do begin
    Add('FROM_LOCALITY_NAME');
    Add('FROM_STREET_NAME');
    Add('FROM_HOUSE');
  end;
  FilterOnShow:=true;
end;

end.
