unit BisBallDataTiragesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DB,
  BisDataGridFm, BisFieldNames;

type
  TBisBallDataTiragesForm = class(TBisDataGridForm)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisBallDataTiragesFormIface=class(TBisDataGridFormIface)
  private
    function GetPreparationFlag(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisBallDataTiragesForm: TBisBallDataTiragesForm;

implementation

{$R *.dfm}

uses BisUtils, BisBallDataTirageEditFm, BisConsts, BisFilterGroups;

{ TBisBallDataTiragesFormIface }

constructor TBisBallDataTiragesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisBallDataTiragesForm;
  FilterClass:=TBisBallDataTirageFilterFormIface;
  InsertClass:=TBisBallDataTirageInsertFormIface;
  UpdateClass:=TBisBallDataTirageUpdateFormIface;
  DeleteClass:=TBisBallDataTirageDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_TIRAGES';
  with FieldNames do begin
    AddKey('TIRAGE_ID');
    AddInvisible('PRIZE_PERCENT');
    AddInvisible('JACKPOT_PERCENT');
    AddInvisible('PREPARATION_DATE');
    AddInvisible('FIRST_PERCENT');
    AddInvisible('SECOND_1_ROUND_PERCENT');
    AddInvisible('SECOND_2_ROUND_PERCENT');
    AddInvisible('SECOND_3_ROUND_PERCENT');
    AddInvisible('SECOND_4_ROUND_PERCENT');
    Add('NUM','Номер',40);
    Add('EXECUTION_DATE','Дата',120);
    Add('EXECUTION_PLACE','Место проведения',190);
    Add('TICKET_COST','Стоимость билета',60).DisplayFormat:='#0.00';
    AddCalculate('PREPARATION_FLAG','Подготовлен',GetPreparationFlag,ftInteger,0,40).VisualType:=vtCheckBox;
  end;
  Orders.Add('NUM');
end;

function TBisBallDataTiragesFormIface.GetPreparationFlag(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  FieldDate: TField;
begin
  Result:=Null;
  if DataSet.Active then begin
    FieldDate:=DataSet.FieldByName('PREPARATION_DATE');
    Result:=iff(VarIsNull(FieldDate.Value),0,1);
  end;
end;

{ TBisBallDataTiragesForm }

constructor TBisBallDataTiragesForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
