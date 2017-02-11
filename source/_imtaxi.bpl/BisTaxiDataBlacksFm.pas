unit BisTaxiDataBlacksFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DB,
  BisDataGridFm, BisFieldNames, DBCtrls;

type
  TBisTaxiDataBlacksForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoDescription: TDBMemo;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataBlacksFormIface=class(TBisDataGridFormIface)
  private
    function GetAddress(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataBlacksForm: TBisTaxiDataBlacksForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataBlackEditFm, BisConsts, BisVariants;

{ TBisTaxiDataBlacksFormIface }

constructor TBisTaxiDataBlacksFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataBlacksForm;
  FilterClass:=TBisTaxiDataBlackFilterFormIface;
  InsertClass:=TBisTaxiDataBlackInsertFormIface;
  UpdateClass:=TBisTaxiDataBlackUpdateFormIface;
  DeleteClass:=TBisTaxiDataBlackDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_BLACKS';
  with FieldNames do begin
    AddKey('BLACK_ID');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('USER_NAME');
    AddInvisible('DATE_CREATE');
    AddInvisible('LOCALITY_ID');
    AddInvisible('STREET_ID');
    AddInvisible('HOUSE');
    AddInvisible('FLAT');
    AddInvisible('STREET_NAME');
    AddInvisible('STREET_PREFIX');
    AddInvisible('LOCALITY_NAME');
    AddInvisible('LOCALITY_PREFIX');
    AddInvisible('DESCRIPTION');
    Add('PHONE','�������',150);
    AddCalculate('ADDRESS','�����',GetAddress,ftString,1000,300);
  end;
  Orders.Add('PHONE');
end;

function TBisTaxiDataBlacksFormIface.GetAddress(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  Args: TBisVariants;
begin
  Result:=Null;
  if DataSet.Active and not DataSet.isEmpty  then begin
    Args:=TBisVariants.Create;
    try
      Args.Add(DataSet.FieldByName('LOCALITY_PREFIX').Value);
      Args.Add(DataSet.FieldByName('LOCALITY_NAME').Value);
      Args.Add(DataSet.FieldByName('STREET_PREFIX').Value);
      Args.Add(DataSet.FieldByName('STREET_NAME').Value);
      Args.Add(DataSet.FieldByName('HOUSE').Value);
      Args.Add(DataSet.FieldByName('FLAT').Value);
      Result:=FormatEx('%s%s %s%s %s %s',Args);
    finally
      Args.Free;
    end;
  end;
end;

{ TBisTaxiDataBlacksForm }

constructor TBisTaxiDataBlacksForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    DBMemoDescription.DataSource:=DataFrame.DataSource;
  end;
end;

end.
