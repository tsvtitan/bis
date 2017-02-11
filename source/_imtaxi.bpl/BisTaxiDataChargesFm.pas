unit BisTaxiDataChargesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataFrm, BisDataGridFm, BisTaxiDataChargesFrm;

type
  TBisTaxiDataChargesForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataChargesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataChargesForm: TBisTaxiDataChargesForm;

implementation

{$R *.dfm}

{ TBisTaxiDataChargesFormIface }

constructor TBisTaxiDataChargesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataChargesForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisTaxiDataChargesForm }

class function TBisTaxiDataChargesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataChargesFrame;
end;

end.
