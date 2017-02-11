unit DBXMetaDataCommand;
interface

uses
  DBXCommon,
  DBXTableStorage,
  DBXMetaDataReader,
  DBXSqlScanner;

type
  TDBXMetaDataCommand = class(TDBXCommand)
  public
    constructor Create(DBXContext: TDBXContext; MorphicCommand: TDBXCommand; Provider: TDBXMetaDataReader);
    destructor Destroy; override;
  protected
    procedure SetRowSetSize(const RowSetSize: Int64); override;
    procedure SetMaxBlobSize(const MaxBlobSize: Int64); override;
    function  GetRowsAffected: Int64; override;

    function  DerivedGetNextReader: TDBXReader; override;
    procedure DerivedOpen; override;
    procedure DerivedClose; override;
    procedure DerivedPrepare; override;
    function  DerivedExecuteQuery: TDBXReader; override;
    procedure DerivedExecuteUpdate; override;
  private
    function  FetchDatabaseColumns: TDBXTableStorage;
  private
    FQueryCommand: TDBXCommand;
    FReader: TDBXMetaDataReader;
  end;

implementation
uses
  DBXPlatform,
  DBXPlatformUtil,
  DBXMetaDataNames,
  SysUtils;

resourcestring
  SBeforeRow = 'Invoke Next before getting data from a reader.';
  SAfterRow = 'No more data in reader.';

const
  ParameterQuote = '"';
  DatabaseCollectionName = 'Database';
  DatabaseCollectionIndex = 0;

  QuoteCharOrdinal = 0;
  ProcedureQuoteCharOrdinal = 1;
  MaxCommandsOrdinal = 2;
  SupportsTransactionsOrdinal = 3;
  SupportsNestedTransactionsOrdinal = 4;
  SupportsRowSetSizeOrdinal = 5;
  ProductVersionOrdinal = 6;
  ProductNameOrdinal = 7;
  QuotePrefixOrdinal = 8;
  QuoteSuffixOrdinal = 9;
  SupportsLowerCaseIdentifiersOrdinal = 10;
  SupportsUpperCaseIdentifiersOrdinal = 11;
  DatabaseColumnCount = 12;

//  QuotePrefixOrdinal = 7;
//  QuoteSuffixOrdinal = 8;
//  SupportsLowerCaseIdentifiersOrdinal = 9;
//  SupportsUpperCaseIdentifiersOrdinal = 10;
//  DatabaseColumnCount = 11;

type
  TDBXMetaDataDbxReader = class;
  TDatabaseCursor = class;
  TDBXMetaDataRow = class;

  TDBXMetaDataDbxReader = class(TDBXReader)
  public
    constructor Create(DBXContext: TDBXContext; Row: TDBXMetaDataRow; Cursor: TDBXTableStorage);
    destructor Destroy; override;
  protected
    function  DerivedNext: Boolean; override;
    procedure DerivedClose; override;
    function  GetByteReader: TDBXByteReader; override;
  private
    FByteReader:  TDBXReaderByteReader;
    function MapToDBXType(ColumnType: Integer): Integer;
  private
    FCursor: TDBXTableStorage;
  end;

  TDatabaseCursor = class(TDBXBaseMetaDataReader.TDBXSanitizedTableCursor)
  public
    constructor Create(Columns: TDBXColumnDescriptorArray; Provider: TDBXMetaDataReader; TypeNames: TDBXPlatformTypeNames);
    function  Next: Boolean; override;
    procedure Close; override;
    procedure CheckColumn(const Ordinal: Integer; const ColumnType: Integer); override;
    function  IsNull(Ordinal: Integer): Boolean; override;
    function  GetString(Ordinal: Integer): WideString; override;
    function  GetInt32(Ordinal: Integer): Integer; override;
    function  GetBoolean(Ordinal: Integer): Boolean; override;
  private
    FReader: TDBXMetaDataReader;
    FRow: Integer;
  end;

  TDBXMetaDataRow = class(TDBXRowEx)
  protected
    constructor Create(DBXContext: TDBXContext; Row: TDBXRowStorage);

  protected
    procedure GetWideString(DbxValue: TDBXWideStringValue; var WideStringBuilder: TDBXWideStringBuilder; var IsNull: LongBool); override;
    procedure GetBoolean(DbxValue: TDBXBooleanValue; var Value: LongBool; var IsNull: LongBool); override;
    procedure GetInt16(DbxValue: TDBXInt16Value; var Value: SmallInt; var IsNull: LongBool); override;
    procedure GetInt32(DbxValue: TDBXInt32Value; var Value: TInt32; var IsNull: LongBool); override;
    procedure GetInt64(DbxValue: TDBXInt64Value; var Value: Int64; var IsNull: LongBool); override;
  private
    FRow: TDBXRowStorage;
  public
    destructor Destroy; override;
  end;


constructor TDBXMetaDataCommand.Create(DBXContext: TDBXContext; MorphicCommand: TDBXCommand; Provider: TDBXMetaDataReader);
begin
  Inherited Create(DBXContext);
  FReader := Provider;
end;

destructor TDBXMetaDataCommand.Destroy;
begin
  FreeAndNil(FQueryCommand);
  inherited Destroy;
end;

procedure TDBXMetaDataCommand.SetRowSetSize(const RowSetSize: Int64);
begin
// todo: delegate
end;

procedure TDBXMetaDataCommand.SetMaxBlobSize(const MaxBlobSize: Int64);
begin
// todo: delegate
end;

function  TDBXMetaDataCommand.GetRowsAffected: Int64;
begin
// todo: delegate
  Result := 0;
end;

function TDBXMetaDataCommand.DerivedGetNextReader: TDBXReader;
begin
  Result := nil;
end;

procedure TDBXMetaDataCommand.DerivedOpen;
begin

end;

procedure TDBXMetaDataCommand.DerivedClose;
begin

end;

procedure TDBXMetaDataCommand.DerivedPrepare;
begin

end;

function TDBXMetaDataCommand.DerivedExecuteQuery: TDBXReader;
var
  Table: TDBXTableStorage;
  Row: TDBXMetaDataRow;
begin
  Table := FReader.FetchCollection(Text);
  if Table = nil then
    Table := FetchDatabaseColumns
  else
    FQueryCommand := TDBXCommand(Table.Command);
  Row := TDBXMetaDataRow.Create(FDBXContext,Table);
  Result := TDBXMetaDataDbxReader.Create(FDBXContext,Row,Table);
end;

procedure TDBXMetaDataCommand.DerivedExecuteUpdate;
begin

end;

function TDBXMetaDataCommand.FetchDatabaseColumns: TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns, DatabaseColumnCount);
  Columns[QuoteCharOrdinal]                    := TDBXColumnDescriptor.Create(TDBXMetaDatabaseColumnNames.QuoteChar,                    TDBXDataTypes.WideStringType, 2);
  Columns[ProcedureQuoteCharOrdinal]           := TDBXColumnDescriptor.Create(TDBXMetaDatabaseColumnNames.ProcedureQuoteChar,           TDBXDataTypes.WideStringType, 2);
  Columns[SupportsTransactionsOrdinal]         := TDBXColumnDescriptor.Create(TDBXMetaDatabaseColumnNames.SupportsTransactions,         TDBXDataTypes.BooleanType, 1);
  Columns[SupportsNestedTransactionsOrdinal]   := TDBXColumnDescriptor.Create(TDBXMetaDatabaseColumnNames.SupportsNestedTransactions,   TDBXDataTypes.BooleanType, 1);
  Columns[MaxCommandsOrdinal]                  := TDBXColumnDescriptor.Create(TDBXMetaDatabaseColumnNames.MaxCommands,                  TDBXDataTypes.Int32Type,     4);
  Columns[SupportsRowSetSizeOrdinal]           := TDBXColumnDescriptor.Create(TDBXMetaDatabaseColumnNames.SupportsRowSetSize,           TDBXDataTypes.BooleanType, 1);
  Columns[ProductVersionOrdinal]               := TDBXColumnDescriptor.Create(TDBXMetaDatabaseColumnNames.ProductVersion,               TDBXDataTypes.WideStringType, 20);
  Columns[ProductNameOrdinal]                  := TDBXColumnDescriptor.Create(TDBXMetaDatabaseColumnNames.ProductName,                  TDBXDataTypes.WideStringType, 20);
  Columns[QuotePrefixOrdinal]                  := TDBXColumnDescriptor.Create(TDBXMetaDatabaseColumnNames.QuotePrefix,                  TDBXDataTypes.WideStringType, 2);
  Columns[QuoteSuffixOrdinal]                  := TDBXColumnDescriptor.Create(TDBXMetaDatabaseColumnNames.QuoteSuffix,                  TDBXDataTypes.WideStringType, 2);
  Columns[SupportsLowerCaseIdentifiersOrdinal] := TDBXColumnDescriptor.Create(TDBXMetaDatabaseColumnNames.SupportsLowerCaseIdentifiers, TDBXDataTypes.BooleanType, 1);
  Columns[SupportsUpperCaseIdentifiersOrdinal] := TDBXColumnDescriptor.Create(TDBXMetaDatabaseColumnNames.SupportsUpperCaseIdentifiers, TDBXDataTypes.BooleanType, 1);
  Result := TDatabaseCursor.Create(Columns,FReader,FReader.Context);
end;

{ TDatabaseCursor }

constructor TDatabaseCursor.Create(Columns: TDBXColumnDescriptorArray; Provider: TDBXMetaDataReader; TypeNames: TDBXPlatformTypeNames);
begin
  inherited Create(TypeNames, DatabaseCollectionIndex, DatabaseCollectionName, Columns, nil);
  FReader := Provider;
end;

function TDatabaseCursor.Next: Boolean;
begin
  if FRow < 2 then
    Inc(FRow);
  Result := (FRow = 1);
end;

procedure TDatabaseCursor.Close;
begin
end;

procedure TDatabaseCursor.CheckColumn(const Ordinal: Integer; const ColumnType: Integer);
begin
  case FRow of
    0: raise Exception.Create(SBeforeRow);
    1: ;
    else raise Exception.Create(SAfterRow);
  end;
  inherited CheckColumn(Ordinal, ColumnType);
end;

function TDatabaseCursor.IsNull(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.UnknownType);
  Result := False;
end;

function TDatabaseCursor.GetString(Ordinal: Integer): WideString;
begin
  CheckColumn(Ordinal, TDBXDataTypes.WideStringType);
  case Ordinal of
    QuoteCharOrdinal:
      Result := FReader.SqlIdentifierQuoteChar;
    ProcedureQuoteCharOrdinal:
      Result := FReader.SqlProcedureQuoteChar;
    ProductVersionOrdinal:
      Result := FReader.Version;
    ProductNameOrdinal:
      Result := FReader.ProductName;
    QuotePrefixOrdinal:
      Result := FReader.SqlIdentifierQuotePrefix;
    QuoteSuffixOrdinal:
      Result := FReader.SqlIdentifierQuoteSuffix;
  else
    Result := '';
  end;
end;

function TDatabaseCursor.GetBoolean(Ordinal: Integer): Boolean;
begin
  Result := True;
  CheckColumn(Ordinal, TDBXDataTypes.BooleanType);
  case Ordinal of
    SupportsTransactionsOrdinal:
      Result := FReader.TransactionsSupported;
    SupportsNestedTransactionsOrdinal:
      Result := FReader.NestedTransactionsSupported;
    SupportsRowSetSizeOrdinal:
      Result := FReader.SetRowSizeSupported;
    SupportsLowerCaseIdentifiersOrdinal:
      Result := FReader.LowerCaseIdentifiersSupported;
    SupportsUpperCaseIdentifiersOrdinal:
      Result := FReader.UpperCaseIdentifiersSupported;
  end;
end;

function TDatabaseCursor.GetInt32(Ordinal: Integer): Integer;
begin
  Result := 0;
  CheckColumn(Ordinal, TDBXDataTypes.Int32Type);
  case Ordinal of
    MaxCommandsOrdinal:
      if not FReader.MultipleCommandsSupported then
        Result := 1;  // MySQL supports only 1 command per connection.
  end;
end;

{ TDBXMetaDataDbxReader }

constructor TDBXMetaDataDbxReader.Create(DBXContext: TDBXContext; Row: TDBXMetaDataRow; Cursor: TDBXTableStorage);
var
  Ordinal: Integer;
  Column: TDBXColumnDescriptor;
  ValueType: TDBXValueType;
  Values: TDBXValueArray;
begin
  Inherited Create(DBXContext, Row, nil);
  FCursor := Cursor;
  SetLength(Values, Length(Cursor.Columns));
  for Ordinal := Low(Values) to High(Values) do
  begin
    Column                   := Cursor.Columns[Ordinal];
    ValueType                := TDBXDriverHelpEx.CreateTDBXValueType(DBXContext,Row);
    ValueType.DataType       := MapToDBXType(Column.ColumnType);
    ValueType.SubType        := TDBXDataTypes.UnknownType;
    ValueType.Ordinal        := Ordinal;
    ValueType.Scale          := 0;
    ValueType.Size           := Column.DataSize;
    ValueType.Name           := Column.ColumnName;
    if (ValueType.DataType = TDBXDataTypes.WideStringType) then
    begin
      if ValueType.Size = 0 then
        ValueType.Size        := 256;
      if ValueType.Precision = 0 then
        ValueType.Precision   := ValueType.Size;
      ValueType.Size := ValueType.Size + 2; // Allow space for the zero terminator.
    end;
    ValueType.ValueTypeFlags := TDBXValueTypeFlags.Nullable or TDBXValueTypeFlags.ReadOnly;
    Values[Ordinal] := TDBXValue.CreateValue(FDBXContext, ValueType, FDbxRow, true);
  end;
  SetValues(Values);
end;

destructor TDBXMetaDataDbxReader.Destroy;
begin
  FreeAndNil(FByteReader);
  inherited Destroy;
end;

function TDBXMetaDataDbxReader.MapToDBXType(ColumnType: Integer): Integer;
begin
  Result := ColumnType;
end;

function  TDBXMetaDataDbxReader.DerivedNext: Boolean;
begin
  if FCursor = nil then
    Result := False
  else
  begin
    Result := FCursor.Next;
    if not Result then
    begin
      FCursor.Close;
      FreeAndNil(FCursor);
    end;
  end;
end;

function TDBXMetaDataDbxReader.GetByteReader: TDBXByteReader;
begin
  if FByteReader = nil then
    FByteReader := TDBXReaderByteReader.Create(FDbxContext, Self);
  Result := FByteReader;
end;

procedure TDBXMetaDataDbxReader.DerivedClose;
begin
  if FCursor <> nil then
  begin
    FCursor.Close;
    FreeAndNil(FCursor);
  end;
end;


{ TDBXMetaDataRow }

constructor TDBXMetaDataRow.Create(DBXContext: TDBXContext; Row: TDBXRowStorage);
begin
  Inherited Create(DBXContext);
  FRow := Row;
end;

destructor TDBXMetaDataRow.Destroy;
begin
{  if Assigned(FRow) then
    FreeAndNil(FRow);}
  inherited  Destroy;
end;

procedure TDBXMetaDataRow.GetWideString(DbxValue: TDBXWideStringValue; var WideStringBuilder: TDBXWideStringBuilder; var IsNull: LongBool);
var
  Ordinal: Integer;
begin
  Ordinal := DbxValue.ValueType.Ordinal;
  IsNull := FRow.IsNull(Ordinal);
  if not IsNull then
    TDBXPlatform.CopyWideStringToBuilder(FRow.GetString(Ordinal), WideStringBuilder);
end;

procedure TDBXMetaDataRow.GetBoolean(DbxValue: TDBXBooleanValue; var Value: LongBool; var IsNull: LongBool);
var
  Ordinal: Integer;
begin
  Ordinal := DbxValue.ValueType.Ordinal;
  IsNull := FRow.IsNull(Ordinal);
  if not IsNull then
    Value := FRow.GetBoolean(Ordinal)
  else
    Value := False;
end;

procedure TDBXMetaDataRow.GetInt16(DbxValue: TDBXInt16Value; var Value: SmallInt; var IsNull: LongBool);
var
  Ordinal: Integer;
begin
  Ordinal := DbxValue.ValueType.Ordinal;
  IsNull := FRow.IsNull(Ordinal);
  if not IsNull then
    Value := FRow.GetInt16(Ordinal)
  else
    Value := 0;
end;

procedure TDBXMetaDataRow.GetInt32(DbxValue: TDBXInt32Value; var Value: TInt32; var IsNull: LongBool);
var
  Ordinal: Integer;
begin
  Ordinal := DbxValue.ValueType.Ordinal;
  IsNull := FRow.IsNull(Ordinal);
  if not IsNull then
    Value := FRow.GetInt32(Ordinal)
  else
    Value := 0;
end;

procedure TDBXMetaDataRow.GetInt64(DbxValue: TDBXInt64Value; var Value: Int64; var IsNull: LongBool);
var
  Ordinal: Integer;
begin
  Ordinal := DbxValue.ValueType.Ordinal;
  IsNull := FRow.IsNull(Ordinal);
  if not IsNull then
    Value := FRow.GetInt64(Ordinal)
  else
    Value := 0;
end;

end.
