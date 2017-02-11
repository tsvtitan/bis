{*******************************************************}
{                                                       }
{                     EhLib vX.X                        }
{          Registers object that sort data in           }
{                  TCustomMemTableEh                    }
{                                                       }
{    Copyright (c) 2003, 04 by Dmitry V. Bolshakov      }
{                                                       }
{*******************************************************}

{*******************************************************}
{ Add this unit to 'uses' clause of any unit of your    }
{ project to allow TDBGridEh to sort data in            }
{ TMemTableEh automatically after sorting markers       }
{ will be changed.                                      }
{ TMTEDatasetFeaturesEh determine if                    }
{ TDBGridEh.SortLocal = True then it will sort data     }
{ in memory using procedure SortByFields                }
{ else if SortLocal = False and MemTable connected to   }
{ other  DataSet via ProviderDataSet, it will try to    }
{ sord data in this DataSet using                       }
{ GetDatasetFeaturesForDataSet function                 }
{*******************************************************}

unit EhLibMTE;

{$I EhLib.Inc}

interface

uses
{$IFDEF EH_LIB_6} Variants, {$ENDIF}
  DbUtilsEh, DBGridEh, Db, MemTableEh, DataDriverEh, SysUtils;

type

  TMTEDatasetFeaturesEh = class(TSQLDatasetFeaturesEh)
  public
    constructor Create; override;
    procedure ApplyFilter(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
    procedure ApplySorting(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
  end;

var
  SortInView: Boolean;

implementation

uses Classes;

type
  TCustomDBGridEhCrack = class(TCustomDBGridEh) end;
  TDataDriverEhCrack = class(TDataDriverEh) end;

procedure ApplySortingForSQLDataDriver(Grid: TCustomDBGridEh; SQLDriver: TSQLDataDriverEh;
   UseFieldName: Boolean);

  function DeleteStr(str: String; sunstr: String): String;
  var
    i: Integer;
  begin
    i := Pos(sunstr, str);
    if i <> 0 then
      Delete(str, i, Length(sunstr));
    Result := str;
  end;

var
  i, OrderLine: Integer;
  s: String;
  SQL: TStrings;
begin

  SQL := TStringList.Create;
  try
    SQL.Text := SQLDriver.SelectSQL.Text;

    s := '';
    for i := 0 to Grid.SortMarkedColumns.Count - 1 do
    begin
      if UseFieldName
        then s := s + Grid.SortMarkedColumns[i].FieldName
        else s := s + IntToStr(Grid.SortMarkedColumns[i].Field.FieldNo);
      if Grid.SortMarkedColumns[i].Title.SortMarker = smUpEh
        then s := s + ' DESC, '
        else s := s + ', ';
    end;

    if s <> '' then
      s := 'ORDER BY ' + Copy(s, 1, Length(s) - 2);

    OrderLine := -1;
    for i := 0 to SQL.Count - 1 do
      if UpperCase(Copy(SQL[i], 1, Length('ORDER BY'))) = 'ORDER BY' then
      begin
        OrderLine := i;
        Break;
      end;
    if OrderLine = -1 then
    begin
      SQL.Add('');
      OrderLine := SQL.Count-1;
    end;

    SQL.Strings[OrderLine] := s;

    SQLDriver.SelectSQL := SQL;

  finally
    SQL.Free;
  end;
end;

procedure ApplyFilterForSQLDataDriver(Grid: TCustomDBGridEh; SQLDriver: TSQLDataDriverEh;
  DateValueToSQLString: TDateValueToSQLStringProcEh);
var
  i, OrderLine: Integer;
  s: String;
  SQL: TStrings;
begin

  SQL := TStringList.Create;
  try
    SQL.Text := SQLDriver.SelectSQL.Text;

    OrderLine := -1;
    for i := 0 to SQL.Count - 1 do
      if UpperCase(Copy(SQL[i], 1, Length(SQLFilterMarker))) = UpperCase(SQLFilterMarker) then
      begin
        OrderLine := i;
        Break;
      end;
    s := GetExpressionAsFilterString(Grid, GetOneExpressionAsSQLWhereString, DateValueToSQLString, True);
    if s = '' then
      s := '1=1';
    if OrderLine = -1 then
      Exit;

    SQL.Strings[OrderLine] := SQLFilterMarker + ' (' + s + ')';
    SQLDriver.SelectSQL := SQL;

  finally
    SQL.Free;
  end;
end;

{ TMTEDatasetFeaturesEh }

procedure TMTEDatasetFeaturesEh.ApplyFilter(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean);
var
  DataDriver: TDataDriverEh;
  DS: TDataSet;
  DatasetFeatures: TDatasetFeaturesEh;
begin
  if TDBGridEh(Sender).STFilter.Local then
  begin
    inherited ApplyFilter(Sender, DataSet, IsReopen)
  end else if (DataSet is TCustomMemTableEh) then
  begin
    if not (DataSet is TCustomMemTableEh) then Exit;
    DataDriver := TCustomMemTableEh(DataSet).DataDriver;
    DS := TDataDriverEhCrack(DataDriver).ProviderDataSet;
    if DS <> nil then
    begin
      DatasetFeatures := GetDatasetFeaturesForDataSet(DS);
      if DatasetFeatures <> nil then
        DatasetFeatures.ApplyFilter(Sender, DS, False);
      DataSet.Close;
      DataSet.Open;
    end else if (DataDriver is TSQLDataDriverEh) then
    begin
      ApplyFilterForSQLDataDriver(TCustomDBGridEh(Sender),
        TSQLDataDriverEh(DataDriver), DateValueToSQLString);
    end;
  end;
end;

procedure TMTEDatasetFeaturesEh.ApplySorting(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean);
var
  DS: TDataSet;
  MTE: TCustomMemTableEh;
  DatasetFeatures: TDatasetFeaturesEh;
  i: Integer;
  OrderByStr: String;
  DataDriver: TDataDriverEh;
begin
  if Sender is TCustomDBGridEh then
    if TCustomDBGridEh(Sender).SortLocal then
      with TCustomDBGridEh(Sender) do
        begin
          OrderByStr := '';
          for i := 0 to SortMarkedColumns.Count - 1 do
          begin
            OrderByStr := OrderByStr + SortMarkedColumns[i].FieldName + ' ';
            if SortMarkedColumns[i].Title.SortMarker = smUpEh then
              OrderByStr := OrderByStr + ' DESC';
            OrderByStr := OrderByStr + ',';
          end;
          Delete(OrderByStr, Length(OrderByStr), 1);
          if (DataSet is TCustomMemTableEh) then
          begin
            MTE := TCustomMemTableEh(DataSet);
            if SortInView
              then MTE.SortOrder := OrderByStr
              else MTE.SortByFields(OrderByStr);
          end;
        end
    else
    begin
      if not (DataSet is TCustomMemTableEh) then Exit;
      DataDriver := TCustomMemTableEh(DataSet).DataDriver;
      DS := TDataDriverEhCrack(DataDriver).ProviderDataSet;
      if DS <> nil then
      begin
        DatasetFeatures := GetDatasetFeaturesForDataSet(DS);
        if DatasetFeatures <> nil then
          DatasetFeatures.ApplySorting(Sender, DS, False);
        DataSet.Close;
        DataSet.Open;
      end else if (DataDriver is TSQLDataDriverEh) then
      begin
        ApplySortingForSQLDataDriver(TCustomDBGridEh(Sender),
          TSQLDataDriverEh(DataDriver), SortUsingFieldName);
      end;
    end;
end;

constructor TMTEDatasetFeaturesEh.Create;
begin
  inherited Create;
  SupportsLocalLike := True;
end;


initialization
  RegisterDatasetFeaturesEh(TMTEDatasetFeaturesEh, TCustomMemTableEh);
end.
