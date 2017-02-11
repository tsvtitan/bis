unit BisTaxiDataCalcsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisTaxiDataCalcsForm = class(TBisDataGridForm)
  end;

  TBisTaxiDataCalcsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCalcsForm: TBisTaxiDataCalcsForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataCalcEditFm, BisConsts;

{ TBisTaxiDataCalcsFormIface }

constructor TBisTaxiDataCalcsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCalcsForm;
  FilterClass:=TBisTaxiDataCalcFilterFormIface;
  InsertClass:=TBisTaxiDataCalcInsertFormIface;
  UpdateClass:=TBisTaxiDataCalcUpdateFormIface;
  DeleteClass:=TBisTaxiDataCalcDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_CALCS';
  with FieldNames do begin
    AddKey('CALC_ID');
    AddInvisible('PRIORITY');
    AddInvisible('TYPE_CALC');
    AddInvisible('PERCENT');
    AddInvisible('CALC_SUM');
    AddInvisible('PROC_NAME');
    Add('NAME','Наименование',100);
    Add('DESCRIPTION','Описание',250);
  end;
  Orders.Add('PRIORITY');
end;

end.
