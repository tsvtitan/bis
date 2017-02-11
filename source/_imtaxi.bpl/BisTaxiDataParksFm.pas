unit BisTaxiDataParksFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm, BisTaxiDataParksFrm, BisDataFrm;

type
  TBisTaxiDataParksForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataParksFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataParksForm: TBisTaxiDataParksForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataParkEditFm, BisConsts;

{ TBisTaxiDataParksFormIface }

constructor TBisTaxiDataParksFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataParksForm;
  FilterClass:=TBisTaxiDataParkFilterFormIface;
  InsertClass:=TBisTaxiDataParkInsertFormIface;
  UpdateClass:=TBisTaxiDataParkUpdateFormIface;
  DeleteClass:=TBisTaxiDataParkDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_PARKS';
  with FieldNames do begin
    AddKey('PARK_ID');
    AddInvisible('STREET_ID');
    AddInvisible('HOUSE');
    AddInvisible('STREET_NAME');
    AddInvisible('STREET_PREFIX');
    AddInvisible('LOCALITY_NAME');
    AddInvisible('LOCALITY_PREFIX');
    AddInvisible('MAX_COUNT');
    AddInvisible('PRIORITY');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',250);
  end;
  Orders.Add('PRIORITY');
end;

{ TBisTaxiDataParksForm }

class function TBisTaxiDataParksForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataParksFrame;
end;

end.
