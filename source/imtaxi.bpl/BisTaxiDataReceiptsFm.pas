unit BisTaxiDataReceiptsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataFrm, BisDataGridFm, BisDataGridFrm, BisDataEditFm,
  BisTaxiDataReceiptsFrm;
                                                                                                   
type
  TBisTaxiDataReceiptsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataReceiptsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataReceiptsForm: TBisTaxiDataReceiptsForm;

implementation

{$R *.dfm}

{ TBisTaxiDataReceiptsFormIface }

constructor TBisTaxiDataReceiptsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataReceiptsForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisTaxiDataReceiptsForm }

class function TBisTaxiDataReceiptsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataReceiptsFrame;
end;

end.
