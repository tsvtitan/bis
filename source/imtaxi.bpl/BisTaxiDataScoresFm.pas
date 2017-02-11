unit BisTaxiDataScoresFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DB,
  BisDataFrm, BisDataGridFrm, BisDataGridFm, 
  BisTaxiDataScoresFrm;

type
  TBisTaxiDataScoresForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataScoresFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataScoresForm: TBisTaxiDataScoresForm;

implementation

{$R *.dfm}

{ TBisTaxiDataScoresFormIface }

constructor TBisTaxiDataScoresFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataScoresForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisTaxiDataScoresForm }

class function TBisTaxiDataScoresForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataScoresFrame;
end;

end.
