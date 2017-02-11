unit BisLotoDataTiragesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DB,
  BisDataGridFm, BisFieldNames;

type
  TBisLotoDataTiragesForm = class(TBisDataGridForm)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisLotoDataTiragesFormIface=class(TBisDataGridFormIface)
  private
    function GetPreparationFlag(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisLotoDataTiragesForm: TBisLotoDataTiragesForm;

implementation

{$R *.dfm}

uses BisUtils, BisLotoDataTirageEditFm, BisConsts, BisFilterGroups;

{ TBisLotoDataTiragesFormIface }

constructor TBisLotoDataTiragesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisLotoDataTiragesForm;
  FilterClass:=TBisLotoDataTirageFilterFormIface;
  InsertClass:=TBisLotoDataTirageInsertFormIface;
  UpdateClass:=TBisLotoDataTirageUpdateFormIface;
  DeleteClass:=TBisLotoDataTirageDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_TIRAGES';
  with FieldNames do begin
    AddKey('TIRAGE_ID');
    AddInvisible('JACKPOT_PERCENT');
    AddInvisible('PRIZE_PERCENT');
    AddInvisible('PREPARATION_DATE');
    AddInvisible('FIRST_ROUND_PERCENT');
    AddInvisible('THIRD_ROUND_SUM');
    AddInvisible('FOURTH_ROUND_SUM');
    Add('NUM','Номер',40);
    Add('EXECUTION_DATE','Дата',120);
    Add('EXECUTION_PLACE','Место проведения',190);
    Add('TICKET_COST','Стоимость билета',60).DisplayFormat:='#0.00';
    AddCalculate('PREPARATION_FLAG','Подготовлен',GetPreparationFlag,ftInteger,0,40).VisualType:=vtCheckBox;
  end;
  Orders.Add('NUM');
end;

function TBisLotoDataTiragesFormIface.GetPreparationFlag(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  FieldDate: TField;
begin
  Result:=Null;
  if DataSet.Active then begin
    FieldDate:=DataSet.FieldByName('PREPARATION_DATE');
    Result:=iff(VarIsNull(FieldDate.Value),0,1);
  end;
end;

{ TBisLotoDataTiragesForm }

constructor TBisLotoDataTiragesForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
