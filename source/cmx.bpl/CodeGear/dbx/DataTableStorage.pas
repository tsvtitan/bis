{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DataTableStorage;
interface
uses
  DBXTableStorage,
  AbstractTableStorage,
  DataRowStorage,
  System.Data;
type
  TDataTableStorage = class(TAbstractTableStorage)
  public
    constructor Create(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString); overload;
    constructor Create(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; Table: DataTable); overload;
    procedure BeforeFirst; override;
    function Next: Boolean; override;
    procedure NewRow; override;
    procedure InsertRow; override;
    procedure DeleteRow; override;
    procedure Close; override;
    function GetUnsignedByte(Ordinal: Integer): SmallInt; overload; override;
    procedure SetUnsignedByte(Ordinal: Integer; Value: SmallInt); override;
    function GetInt16(Ordinal: Integer): SmallInt; overload; override;
    procedure SetInt16(Ordinal: Integer; Value: SmallInt); override;
    function GetInt32(Ordinal: Integer): Integer; overload; override;
    procedure SetInt32(Ordinal: Integer; Value: Integer); override;
    function GetInt64(Ordinal: Integer): Int64; overload; override;
    procedure SetInt64(Ordinal: Integer; Value: Int64); override;
    function GetBoolean(Ordinal: Integer): Boolean; overload; override;
    procedure SetBoolean(Ordinal: Integer; Value: Boolean); override;
    function GetString(Ordinal: Integer): WideString; overload; override;
    procedure SetString(Ordinal: Integer; const Value: WideString); override;
    function GetObject(Ordinal: Integer): TObject; overload; override;
    procedure SetObject(Ordinal: Integer; Value: TObject); override;
    function IsNull(Ordinal: Integer): Boolean; override;
    procedure SetNull(Ordinal: Integer); override;

    procedure AcceptChanges; override;
    procedure Clear; override;
    function GetCurrentRows(const OrderByColumnName: WideString): TDBXTableStorage; override;
    function FindStringKey(const Ordinal: Integer; const Value: WideString): Boolean; override;
  protected
    function GetMetaDataCollectionName: WideString; override;
    function GetMetaDataCollectionIndex: Integer; override;
    function GetColumns: TDBXColumnDescriptorArray; override;
    procedure SetColumns(const Columns: TDBXColumnDescriptorArray); override;
    procedure SetHiddenColumn(const ColumnName: WideString); override;
    function GetDeletedRows: TDBXTableStorage; override;
    function GetInsertedRows: TDBXTableStorage; override;
    function GetModifiedRows: TDBXTableStorage; override;
    function GetOriginalRow: TDBXRowStorage; override;
    function GetStorage: TObject; override;
  private
    procedure FailIfRowIsNew;
    function CreateDataColumn(Descriptor: TDBXColumnDescriptor): DataColumn;
  private
    FMetaDataCollectionIndex: Integer;
    FMetaDataCollectionName: WideString;
    FTable: DataTable;
    FRow: DataRow;
    FRowIsNew: Boolean;
    FColumns: TDBXColumnDescriptorArray;
    FRowIndex: Integer;
    FOriginal: TDataRowStorage;
  end;

implementation
uses
  DBXCommon,
  DataViewStorage;

resourcestring
  SNewRowNotCalled = 'Must call NewRow before InsertRow.';
  SInsertRowNotCalled = 'Must call InsertRow before moving away from a new row.';
  SUnexpectedMetaDataType = 'Unexpected metadata type';
  SMustKeepOriginalColumnOrder = 'Additional columns must be added after the prescribed columns.';

constructor TDataTableStorage.Create(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString);
begin
  Inherited Create;
  FTable := DataTable.Create;
  FMetaDataCollectionIndex := MetaDataCollectionIndex;
  FMetaDataCollectionName := MetaDataCollectionName;
end;

constructor TDataTableStorage.Create(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; Table: DataTable);
begin
  Inherited Create;
  FTable := Table;
  FMetaDataCollectionIndex := MetaDataCollectionIndex;
  FMetaDataCollectionName := MetaDataCollectionName;
end;

procedure TDataTableStorage.BeforeFirst;
begin
  FailIfRowIsNew();
  FRowIndex := -1;
  FRow := nil;
end;

function TDataTableStorage.Next: Boolean;
begin
  FailIfRowIsNew();
  Inc(FRowIndex);
  Result := (FRowIndex < FTable.Rows.Count);
  if (Result) then
    FRow := FTable.Rows[FRowIndex]
  else
  begin
    Dec(FRowIndex);
    FRow := nil;
  end;
end;

procedure TDataTableStorage.NewRow;
begin
  FailIfRowIsNew();
  FRow := FTable.NewRow();
  FRowIsNew := True;
end;

procedure TDataTableStorage.InsertRow;
begin
  if not FRowIsNew then
    raise Exception.Create(SNewRowNotCalled);
  FTable.Rows.Add(FRow);
  FRowIsNew := False;
end;

procedure TDataTableStorage.DeleteRow;
begin
  FTable.Rows[FRowIndex].Delete();
end;

procedure TDataTableStorage.Close;
begin
  FRow := nil;
  FTable := nil;
  FRowIsNew := False;
end;

function TDataTableStorage.GetUnsignedByte(Ordinal: Integer): SmallInt;
begin
  Result := SmallInt(FRow[Ordinal]);
end;

procedure TDataTableStorage.SetUnsignedByte(Ordinal: Integer; Value: SmallInt);
begin
  FRow[Ordinal] := TObject(Byte(Value));
end;

function TDataTableStorage.GetInt16(Ordinal: Integer): SmallInt;
begin
  Result := SmallInt(FRow[Ordinal]);
end;

procedure TDataTableStorage.SetInt16(Ordinal: Integer; Value: SmallInt);
begin
  FRow[Ordinal] := TObject(Value);
end;

function TDataTableStorage.GetInt32(Ordinal: Integer): Integer;
begin
  Result := Integer(FRow[Ordinal]);
end;

procedure TDataTableStorage.SetInt32(Ordinal: Integer; Value: Integer);
begin
  FRow[Ordinal] := TObject(Value);
end;

function TDataTableStorage.GetInt64(Ordinal: Integer): Int64;
begin
  Result := Int64(FRow[Ordinal]);
end;

procedure TDataTableStorage.SetInt64(Ordinal: Integer; Value: Int64);
begin
  FRow[Ordinal] := TObject(Value);
end;

function TDataTableStorage.GetBoolean(Ordinal: Integer): Boolean;
begin
  Result := Boolean(FRow[Ordinal]);
end;

procedure TDataTableStorage.SetBoolean(Ordinal: Integer; Value: Boolean);
begin
  FRow[Ordinal] := TObject(Value);
end;

function TDataTableStorage.GetString(Ordinal: Integer): WideString;
begin
  Result := WideString(FRow[Ordinal]);
end;

procedure TDataTableStorage.SetString(Ordinal: Integer; const Value: WideString);
begin
  FRow[Ordinal] := Value;
end;

function TDataTableStorage.GetObject(Ordinal: Integer): TObject;
begin
  Result := FRow[Ordinal];
end;

procedure TDataTableStorage.SetObject(Ordinal: Integer; Value: TObject);
begin
  FRow[Ordinal] := Value;
end;

function TDataTableStorage.IsNull(Ordinal: Integer): Boolean;
begin
  Result := FRow.IsNull(Ordinal) or (FRow[Ordinal] = nil);
end;

procedure TDataTableStorage.SetNull(Ordinal: Integer);
begin
  FRow[Ordinal] := DBNull.Value;
end;

procedure TDataTableStorage.AcceptChanges;
begin
  FTable.AcceptChanges();
end;

procedure TDataTableStorage.Clear;
begin
  FTable.Clear();
end;

function TDataTableStorage.GetCurrentRows(const OrderByColumnName: WideString): TDBXTableStorage;
var
  View: DataView;
begin
  View := DataView.Create(FTable, nil, OrderByColumnName, DataViewRowState.CurrentRows);
  Result := TDataViewStorage.Create(Self, View);
end;

function TDataTableStorage.FindStringKey(const Ordinal: Integer; const Value: WideString): Boolean;
var
  Key: array of DataColumn;
  FoundRow: DataRow;
begin
  Key := FTable.PrimaryKey;
  if (Key = nil) or (Length(Key) <> 1) or (FTable.Columns[Ordinal] <> Key[0]) then
  begin
    SetLength(Key,1);
    Key[0] := FTable.Columns[Ordinal];
    FTable.PrimaryKey := Key;
  end;
  FoundRow := FTable.Rows.Find(Value);
  if FoundRow = nil then
    Result := False
  else
  begin
    FRow := FoundRow;
    Result := True;
  end;
end;

function TDataTableStorage.GetMetaDataCollectionName: WideString;
begin
  Result := FMetaDataCollectionName;
end;

function TDataTableStorage.GetMetaDataCollectionIndex: Integer;
begin
  Result := FMetaDataCollectionIndex;
end;

function TDataTableStorage.GetColumns: TDBXColumnDescriptorArray;
var
  Ordinal: Integer;
  Column: DataColumn;
begin
  if FColumns = nil then
  begin
    SetLength(FColumns, FTable.Columns.Count);
    for Ordinal := Low(FColumns) to High(FColumns) do
    begin
      Column := FTable.Columns[Ordinal];
      FColumns[Ordinal] := TDBXColumnDescriptor.Create(Column.ColumnName, Column.Caption, ToColumnType(Column.DataType));
    end;
  end;
  Result := FColumns;
end;

procedure TDataTableStorage.SetColumns(const Columns: TDBXColumnDescriptorArray);
var
  Ordinal: Integer;
begin
  FTable.BeginInit();
  for Ordinal := Low(Columns) to High(Columns) do
  begin
    if Ordinal >= FTable.Columns.Count then
      FTable.Columns.Add(CreateDataColumn(Columns[Ordinal]))
    else if not FTable.Columns[Ordinal].ColumnName.Equals(Columns[Ordinal].ColumnName) then
      raise Exception.Create(SMustKeepOriginalColumnOrder);
  end;
  FTable.EndInit();
end;

procedure TDataTableStorage.SetHiddenColumn(const ColumnName: WideString);
var
  Column: DataColumn;
begin
  Column := FTable.Columns[ColumnName];
  if Column <> nil then
    Column.ColumnMapping := MappingType.Hidden;
end;

function TDataTableStorage.GetDeletedRows: TDBXTableStorage;
var
  View: DataView;
begin
  View := DataView.Create(FTable, nil, nil, DataViewRowState.Deleted);
  Result := TDataViewStorage.Create(Self, View);
end;

function TDataTableStorage.GetInsertedRows: TDBXTableStorage;
var
  View: DataView;
begin
  View := DataView.Create(FTable, nil, nil, DataViewRowState.Added);
  Result := TDataViewStorage.Create(Self, View);
end;

function TDataTableStorage.GetModifiedRows: TDBXTableStorage;
var
  View: DataView;
begin
  View := DataView.Create(FTable, nil, nil, DataViewRowState.ModifiedCurrent);
  Result := TDataViewStorage.Create(Self, View);
end;

function TDataTableStorage.GetOriginalRow: TDBXRowStorage;
begin
  if FOriginal = nil then
    FOriginal := TDataRowStorage.Create(MetaDataCollectionIndex, MetaDataCollectionName);
  FOriginal.Row := FRow;
  if Integer(FRow.RowState and DataRowState.Added) <> 0 then
    Result := nil
  else if FRow.HasVersion(DataRowVersion.Original) then
    FOriginal.Version := DataRowVersion.Original
  else
    FOriginal.Version := DataRowVersion.Current;
  Result := FOriginal
end;

function TDataTableStorage.GetStorage: TObject;
begin
  Result := FTable;
end;

procedure TDataTableStorage.FailIfRowIsNew;
begin
  if FRowIsNew then
    raise Exception.Create(SInsertRowNotCalled);
end;

function TDataTableStorage.CreateDataColumn(Descriptor: TDBXColumnDescriptor): DataColumn;
var
  DataType: System.Type;
  Column: DataColumn;
begin
  DataType := nil;
  case Descriptor.ColumnType of
    TDBXDataTypes.BooleanType:
      DataType := typeof(Boolean);
    TDBXDataTypes.Int16Type:
      DataType := typeof(SmallInt);
    TDBXDataTypes.Int32Type:
      DataType := typeof(Integer);
    TDBXDataTypes.Int64Type:
      DataType := typeof(Int64);
    TDBXDataTypes.WideStringType:
      DataType := typeof(WideString);
    else
      raise Exception.Create(SUnexpectedMetaDataType);
  end;
  Column := DataColumn.Create(Descriptor.ColumnName, DataType);
  Column.Caption := Descriptor.ColumnCaption;
  Result := Column;
end;

end.