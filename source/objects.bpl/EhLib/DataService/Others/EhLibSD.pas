{*******************************************************}
{                                                       }
{                        EhLib                          }
{    Copyright (c) 2002 - 2004 by Dmitry V. Bolshakov   }
{                                                       }
{  Register object that sort and filtering data in      }
{         TSDQuery, TSDMacroQuery from SQLDirect        }
{   Copyright (c) 2003-2004 by Andrew Holubovski        }
{    Copyright (c) 2004 by by Stalker SoftWare          }
{                                                       }
{*******************************************************}

{*******************************************************}
{ Add this unit to 'uses' clause of any unit of your    }
{ project to allow TDBGridEh to sort data in            }
{ TSDQuery automatically after sorting markers          }
{ will be changed.                                      }
{ TSQLDatasetFeaturesEh will try to find line in        }
{ TSDQuery.SQL string that begin from 'ORDER BY' phrase }
{ and replace line by 'ORDER BY FieldNo1 [DESC],....'   }
{ using SortMarkedColumns.                              }
{ Used SQLDirect 4.1.2 or Above                         }
{*******************************************************}

unit EhLibSD;

{$I EhLib.Inc}

interface

uses
  DbUtilsEh, DBGridEh, SDEngine, Db, SysUtils;

type
  TSDSQLDatasetFeaturesEh = class(TSQLDatasetFeaturesEh)
  public
    procedure ApplySorting(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
    procedure ApplyFilter(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
    constructor Create; override;
  end;

implementation

uses
  TypInfo;

function SDDataSetDriverName(DataSet: TSDDataSet): String;
begin
 Result := GetEnumName(TypeInfo(TSDServerType), Ord(DataSet.Database.ServerType));
 Result := Copy(Result, 3, Length(Result)-2)
end; { SDDataSetDriverName }

function DateValueToSDSQLStringProc(DataSet: TDataSet; Value: Variant): String;
begin
 Result := DateValueToDataBaseSQLString(SDDataSetDriverName(TSDDataSet(DataSet)), Value)
end; { DateValueToSDSQLStringProc }

procedure SortDataInSDDataSet(Grid: TCustomDBGridEh; DataSet: TSDDataSet);
var
  cFields  :String;
  cOrders  :String;
  cCases   :String;
  nCou     :Integer;

begin

 cFields := '';
 cOrders := '';
 cCases  := '';

 for nCou := 0 to Grid.SortMarkedColumns.Count-1 do begin

   cFields := cFields + Grid.SortMarkedColumns[nCou].FieldName+';';

   if Grid.SortMarkedColumns[nCou].Title.SortMarker = smUpEh then
     cOrders := cOrders + 'Desc;'
   else
     cOrders := cOrders + 'Asc;';

   cCases := cCases+'True; ';

 end; { for }

 Delete(cFields, Length(cFields), 1);
 Delete(cOrders, Length(cOrders), 1);
 Delete(cCases, Length(cCases), 1);

 DataSet.SortRecords(cFields, cOrders, cCases);

end; { SortDataInSDDataSet }

{ TSDSQLDatasetFeaturesEh }

constructor TSDSQLDatasetFeaturesEh.Create;
begin
 inherited Create;
 DateValueToSQLString := DateValueToSDSQLStringProc;
end; { Create }

procedure TSDSQLDatasetFeaturesEh.ApplyFilter(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean);
begin

 if Sender is TDBGridEh then begin

   if not DataSet.Active then Exit;

   if TDBGridEh(Sender).STFilter.Local then begin
     DataSet.Filter :=
       GetExpressionAsFilterString(TDBGridEh(Sender), GetOneExpressionAsLocalFilterString, nil);
     DataSet.Filtered := (Trim(DataSet.Filter) <> '');
   end else
     ApplyFilterSQLBasedDataSet(TDBGridEh(Sender), DateValueToSDSQLStringProc, IsReopen, 'SQL');

  end; { if }

end; { ApplyFilter }

procedure TSDSQLDatasetFeaturesEh.ApplySorting(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean);
begin

 if Sender is TCustomDBGridEh then begin

   if not DataSet.Active then Exit;

   if TCustomDBGridEh(Sender).SortLocal then
     SortDataInSDDataSet(TCustomDBGridEh(Sender), TSDDataSet(DataSet))
   else
     inherited ApplySorting(Sender, DataSet, IsReopen);
 end; { if }    

end; { ApplySorting }

initialization
  RegisterDatasetFeaturesEh(TSDSQLDatasetFeaturesEh, TSDQuery);
  RegisterDatasetFeaturesEh(TSDSQLDatasetFeaturesEh, TSDMacroQuery);

end.
