unit BisTaxiDataDriversFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataFrm, BisDataGridFm, BisTaxiDataDriversFrm;

type
  TBisTaxiDataDriversForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataDriversFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDriversForm: TBisTaxiDataDriversForm;

implementation

{$R *.dfm}

{ TBisTaxiDataDriversFormIface }

constructor TBisTaxiDataDriversFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDriversForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisTaxiDataDriversForm }

class function TBisTaxiDataDriversForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataDriversFrame;
end;

end.
