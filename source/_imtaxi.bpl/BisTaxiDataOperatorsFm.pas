unit BisTaxiDataOperatorsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisTaxiDataOperatorsForm = class(TBisDataGridForm)
  end;

  TBisTaxiDataOperatorsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataOperatorsForm: TBisTaxiDataOperatorsForm;

implementation

{$R *.dfm}

uses BisUtils, BisConsts,
     BisTaxiDataOperatorEditFm;

{ TBisTaxiDataOperatorsFormIface }

constructor TBisTaxiDataOperatorsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataOperatorsForm;
  FilterClass:=TBisTaxiDataOperatorFilterFormIface;
  InsertClass:=TBisTaxiDataOperatorInsertFormIface;
  UpdateClass:=TBisTaxiDataOperatorUpdateFormIface;
  DeleteClass:=TBisTaxiDataOperatorDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_OPERATORS';
  with FieldNames do begin
    AddKey('OPERATOR_ID');
    AddInvisible('RANGES');
    AddInvisible('ENABLED');
    AddInvisible('PRIORITY');
    AddInvisible('CONVERSIONS');
    Add('NAME','������������',100);
    Add('DESCRIPTION','��������',250);
  end;
  Orders.Add('PRIORITY');
end;

end.
