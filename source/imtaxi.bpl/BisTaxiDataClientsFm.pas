unit BisTaxiDataClientsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  BisDataFrm, BisDataTreeFm, BisDataGridFm,
  BisTaxiDataClientsFrm;

type
  TBisTaxiDataClientsForm = class(TBisDataTreeForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;                                                                                                  

  TBisTaxiDataClientsFormIface=class(TBisDataTreeFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataClientsForm: TBisTaxiDataClientsForm;

implementation

{$R *.dfm}

{ TBisTaxiDataClientsFormIface }

constructor TBisTaxiDataClientsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataClientsForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisTaxiDataClientsForm }

class function TBisTaxiDataClientsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataClientsFrame;
end;

end.
