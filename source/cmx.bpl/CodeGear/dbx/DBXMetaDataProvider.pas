{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXMetaDataProvider;
interface
uses
  DBXMetaDataReader,
  DBXMetaDataWriter,
  DBXPlatformUtil,
  DBXTableStorage,
  DBXTypedTableStorage;
type
  TDBXMetaDataColumn = class;
  TDBXMetaDataTable = class;
  TDBXSqlExecution = class;
  TDBXMetaDataColumnArray = array of TDBXMetaDataColumn;

  TDBXMetaDataColumn = class
  public
    constructor Create; overload;
    constructor Create(Column: TDBXMetaDataColumn); overload;
    procedure CopyColumnToTableStorage(Columns: TDBXColumnsTableStorage); virtual;
  protected
    function IsAutoIncrement: Boolean; virtual;
    procedure SetAutoIncrement(AutoIncrement: Boolean); virtual;
    function GetColumnName: WideString; virtual;
    procedure SetColumnName(const ColumnName: WideString); virtual;
    function GetDefaultValue: WideString; virtual;
    procedure SetDefaultValue(const DefaultValue: WideString); virtual;
    function IsFixedLength: Boolean; virtual;
    procedure SetFixedLength(FixedLength: Boolean); virtual;
    function GetMaxInline: Integer; virtual;
    procedure SetMaxInline(MaxInline: Integer); virtual;
    function IsNullable: Boolean; virtual;
    procedure SetNullable(Nullable: Boolean); virtual;
    function IsLong: Boolean; virtual;
    procedure SetLong(Blob: Boolean); virtual;
    function GetPrecision: Integer; virtual;
    procedure SetPrecision(Precision: Integer); virtual;
    function GetScale: Integer; virtual;
    procedure SetScale(Scale: Integer); virtual;
    function GetDataType: Integer; virtual;
    procedure SetMetaDataColumnType(MetaDataType: Integer); virtual;
    function IsUnicodeString: Boolean; virtual;
    procedure SetUnicodeChar(UnicodeString: Boolean); virtual;
    function IsUnsigned: Boolean; virtual;
    procedure SetUnsigned(Unsigned: Boolean); virtual;
  private
    FColumnName: WideString;
    FDefaultValue: WideString;
    FMetaDataType: Integer;
    FPrecision: Integer;
    FScale: Integer;
    FMaxInline: Integer;
    FUnsigned: Boolean;
    FAutoIncrement: Boolean;
    FNullable: Boolean;
    FFixedLength: Boolean;
    FUnicodeString: Boolean;
    FBlob: Boolean;
  public
    property AutoIncrement: Boolean read IsAutoIncrement write SetAutoIncrement;
    property ColumnName: WideString read GetColumnName write SetColumnName;
    property DefaultValue: WideString read GetDefaultValue write SetDefaultValue;
    property FixedLength: Boolean read IsFixedLength write SetFixedLength;
    property MaxInline: Integer read GetMaxInline write SetMaxInline;
    property Nullable: Boolean read IsNullable write SetNullable;
    property Long: Boolean read IsLong write SetLong;
    property Precision: Integer read GetPrecision write SetPrecision;
    property Scale: Integer read GetScale write SetScale;
    property DataType: Integer read GetDataType;
    property MetaDataColumnType: Integer write SetMetaDataColumnType;
    property UnicodeString: Boolean read IsUnicodeString;
    property UnicodeChar: Boolean write SetUnicodeChar;
    property Unsigned: Boolean read IsUnsigned write SetUnsigned;
  end;

  TDBXInt8Column = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXInt64Column = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXInt32Column = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXInt16Column = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXDoubleColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXDecimalColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString; InPrecision: Integer; InScale: Integer);
  end;

  TDBXDateColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXBooleanColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXBinaryLongColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(Name: WideString);
  end;

  TDBXBinaryColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString; InPrecision: Integer);
  end;

  TDBXAnsiVarCharColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(Name: WideString; InPrecision: Integer);
  end;

  TDBXAnsiLongColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(Name: WideString);
  end;

  TDBXAnsiCharColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(Name: WideString; InPrecision: Integer);
  end;

  TDBXMetaDataForeignKey = class
  public
    constructor Create; overload;
    destructor Destroy; override;
    constructor Create(const InForeignTableName: WideString; const InPrimaryTableName: WideString; const InForeignKeyName: WideString; References: array of WideString); overload;
    procedure AddReference(const ColumnName: WideString; const ColumnNameInPrimaryTable: WideString);
  protected
    function GetForeignKeyColumnsStorage: TDBXForeignKeyColumnsTableStorage;
    function GetCatalogName: WideString;
    procedure SetCatalogName(const CatalogName: WideString);
    function GetSchemaName: WideString;
    procedure SetSchemaName(const SchemaName: WideString);
    function GetTableName: WideString;
    procedure SetTableName(const TableName: WideString);
    function GetForeignKeyName: WideString;
    procedure SetForeignKeyName(const ForeignKeyName: WideString);
  private
    FForeignkey: TDBXForeignKeysTableStorage;
    FColumns: TDBXForeignKeyColumnsTableStorage;
    FPrimaryCatalogName: WideString;
    FPrimarySchemaName: WideString;
    FPrimaryTableName: WideString;
    FColumnCount: Integer;
  public
    property ForeignKeysStorage: TDBXForeignKeysTableStorage read FForeignkey;
    property ForeignKeyColumnsStorage: TDBXForeignKeyColumnsTableStorage read GetForeignKeyColumnsStorage;
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property TableName: WideString read GetTableName write SetTableName;
    property ForeignKeyName: WideString read GetForeignKeyName write SetForeignKeyName;
    property PrimaryCatalogName: WideString read FPrimaryCatalogName write FPrimaryCatalogName;
    property PrimarySchemaName: WideString read FPrimarySchemaName write FPrimarySchemaName;
    property PrimaryTableName: WideString read FPrimaryTableName write FPrimaryTableName;
  end;

  TDBXMetaDataIndex = class
  public
    constructor Create; overload;
    destructor Destroy; override;
    constructor Create(const InTableName: WideString; const InIndexName: WideString; Columns: array of WideString); overload;
    procedure AddColumn(const ColumnName: WideString); overload;
    procedure AddColumn(const ColumnName: WideString; Ascending: Boolean); overload;
  protected
    function GetCatalogName: WideString;
    procedure SetCatalogName(const CatalogName: WideString);
    function GetSchemaName: WideString;
    procedure SetSchemaName(const SchemaName: WideString);
    function GetTableName: WideString;
    procedure SetTableName(const TableName: WideString);
    function GetIndexName: WideString;
    procedure SetIndexName(const IndexName: WideString);
    function IsUnique: Boolean;
    procedure SetUnique(const Unique: Boolean);
  private
    FIndexes: TDBXIndexesTableStorage;
    FColumns: TDBXIndexColumnsTableStorage;
    FColumnCount: Integer;
  public
    property IndexesStorage: TDBXIndexesTableStorage read FIndexes;
    property IndexColumnsStorage: TDBXIndexColumnsTableStorage read FColumns;
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property TableName: WideString read GetTableName write SetTableName;
    property IndexName: WideString read GetIndexName write SetIndexName;
    property Unique: Boolean read IsUnique write SetUnique;
  end;

  TDBXMetaDataProvider = class
  public
    destructor Destroy; override;
    function CheckColumnSupported(Column: TDBXMetaDataColumn): Boolean; virtual;
    procedure Execute(const Sql: WideString); virtual;
    procedure CreateTable(Table: TDBXMetaDataTable); virtual;
    function DropTable(const SchemaName: WideString; const TableName: WideString): Boolean; overload; virtual;
    function DropTable(const TableName: WideString): Boolean; overload; virtual;
    procedure CreatePrimaryKey(Index: TDBXMetaDataIndex); virtual;
    procedure CreateUniqueIndex(Index: TDBXMetaDataIndex); virtual;
    procedure CreateIndex(Index: TDBXMetaDataIndex); virtual;
    function DropIndex(const TableName: WideString; const IndexName: WideString): Boolean; overload; virtual;
    function DropIndex(const SchemaName: WideString; const TableName: WideString; const IndexName: WideString): Boolean; overload; virtual;
    procedure CreateForeignKey(Foreignkey: TDBXMetaDataForeignKey); virtual;
    function DropForeignKey(const TableName: WideString; const ForeignKey: WideString): Boolean; overload; virtual;
    function DropForeignKey(const SchemaName: WideString; const TableName: WideString; const ForeignKey: WideString): Boolean; overload; virtual;
    function QuoteIdentifierIfNeeded(const Identifier: WideString): WideString; virtual;
    function GetCollection(MetaDataCommand: WideString): TDBXTableStorage; virtual;
    procedure ToMemoryStorage(Table: TDBXDelegateTableStorage); virtual;
    function MakeCreateTableSql(Table: TDBXTablesTableStorage; Columns: TDBXColumnsTableStorage): WideString; virtual;
    function MakeAlterTableSql(Table: TDBXTablesTableStorage; Columns: TDBXColumnsTableStorage): WideString; overload; virtual;
    function MakeDropTableSql(Table: TDBXTablesTableStorage): WideString; virtual;
    function MakeCreateIndexSql(Indexes: TDBXIndexesTableStorage; Columns: TDBXIndexColumnsTableStorage): WideString; virtual;
    function MakeDropIndexSql(Indexes: TDBXIndexesTableStorage): WideString; virtual;
    function MakeCreateForeignKeySql(ForeignKeys: TDBXForeignKeysTableStorage; Columns: TDBXForeignKeyColumnsTableStorage): WideString; virtual;
    function MakeDropForeignKeySql(ForeignKey: TDBXForeignKeysTableStorage): WideString; virtual;
    function MakeAlterTableSql(Indexes: TDBXIndexesTableStorage; Columns: TDBXIndexColumnsTableStorage): WideString; overload; virtual;
    function IsCatalogsSupported: Boolean; virtual;
    function IsSchemasSupported: Boolean; virtual;
    function IsMultipleStatementsSupported: Boolean; virtual;
    function IsDescendingIndexSupported: Boolean; virtual;
    function IsDescendingIndexColumnsSupported: Boolean; virtual;
    function IsMixedDDLAndDMLSupported: Boolean; virtual;
    function IsDDLTransactionsSupported: Boolean; virtual;
  protected
    procedure SetWriter(Writer: TDBXMetaDataWriter); virtual;
    function GetWriter: TDBXMetaDataWriter; virtual;
    function GetVendor: WideString; virtual;
    function GetDatabaseProduct: WideString; virtual;
    function GetDatabaseVersion: WideString; virtual;
    function GetIdentifierQuotePrefix: WideString; virtual;
    function GetIdentifierQuoteSuffix: WideString; virtual;
  private
    FWriter: TDBXMetaDataWriter;
    FExecuter: TDBXSqlExecution;
  public
    property Vendor: WideString read GetVendor;
    property DatabaseProduct: WideString read GetDatabaseProduct;
    property DatabaseVersion: WideString read GetDatabaseVersion;
    property IdentifierQuotePrefix: WideString read GetIdentifierQuotePrefix;
    property IdentifierQuoteSuffix: WideString read GetIdentifierQuoteSuffix;
  protected
    property Writer: TDBXMetaDataWriter read GetWriter write SetWriter;
  end;

  TDBXMetaDataTable = class
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddColumn(Column: TDBXMetaDataColumn); virtual;
    function GetColumn(Ordinal: Integer): TDBXMetaDataColumn; virtual;
  protected
    function GetCatalogName: WideString;
    procedure SetCatalogName(const CatalogName: WideString);
    function GetSchemaName: WideString;
    procedure SetSchemaName(const SchemaName: WideString);
    function GetTableName: WideString;
    procedure SetTableName(const TableName: WideString);
  private
    FTable: TDBXTablesTableStorage;
    FColumns: TDBXColumnsTableStorage;
    FColumnCount: Integer;
    FMetaDataColumns: TDBXMetaDataColumnArray;
  public
    property TableStorage: TDBXTablesTableStorage read FTable;
    property ColumnsStorage: TDBXColumnsTableStorage read FColumns;
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property TableName: WideString read GetTableName write SetTableName;
  end;

  TDBXObjectColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXSingleColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXSqlExecution = class
  public
    constructor Create(Writer: TDBXMetaDataWriter);
    procedure Execute(const Sql: WideString); virtual;
  private
    FContext: TDBXProviderContext;
  end;

  TDBXTimeColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXTimestampColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXUInt16Column = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXUInt32Column = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXUInt64Column = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXUInt8Column = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString);
  end;

  TDBXUnicodeCharColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(Name: WideString; InPrecision: Integer);
  end;

  TDBXUnicodeLongColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(Name: WideString);
  end;

  TDBXUnicodeVarCharColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString; InPrecision: Integer);
  end;

  TDBXVarBinaryColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(InName: WideString; InPrecision: Integer);
  end;

  TDBXWideVarCharColumn = class(TDBXMetaDataColumn)
  public
    constructor Create(Name: WideString; InPrecision: Integer);
  end;

implementation
uses
  DBXCommon,
  DBXMetaDataNames,
  DBXTableStoragePlatform,
  SysUtils;

constructor TDBXMetaDataColumn.Create;
begin
  inherited Create;
  FNullable := True;
end;

constructor TDBXMetaDataColumn.Create(Column: TDBXMetaDataColumn);
begin
  inherited Create;
  self.FColumnName := Column.FColumnName;
  self.FDefaultValue := Column.FDefaultValue;
  self.FMetaDataType := Column.FMetaDataType;
  self.FPrecision := Column.FPrecision;
  self.FScale := Column.FScale;
  self.FMaxInline := Column.FMaxInline;
  self.FUnsigned := Column.FUnsigned;
  self.FAutoIncrement := Column.FAutoIncrement;
  self.FNullable := Column.FNullable;
  self.FFixedLength := Column.FFixedLength;
  self.FUnicodeString := Column.FUnicodeString;
  self.FBlob := Column.FBlob;
end;

procedure TDBXMetaDataColumn.CopyColumnToTableStorage(Columns: TDBXColumnsTableStorage);
begin
  Columns.ColumnName := FColumnName;
  Columns.Precision := FPrecision;
  Columns.Scale := FScale;
  Columns.DefaultValue := FDefaultValue;
  Columns.Long := FBlob;
  Columns.Nullable := FNullable;
  Columns.AutoIncrement := FAutoIncrement;
  Columns.MaxInline := FMaxInline;
  Columns.DbxDataType := FMetaDataType;
  Columns.FixedLength := FFixedLength;
  Columns.Unicode := FUnicodeString;
  Columns.Unsigned := FUnsigned;
end;

function TDBXMetaDataColumn.IsAutoIncrement: Boolean;
begin
  Result := FAutoIncrement;
end;

procedure TDBXMetaDataColumn.SetAutoIncrement(AutoIncrement: Boolean);
begin
  self.FAutoIncrement := AutoIncrement;
end;

function TDBXMetaDataColumn.GetColumnName: WideString;
begin
  Result := FColumnName;
end;

procedure TDBXMetaDataColumn.SetColumnName(const ColumnName: WideString);
begin
  self.FColumnName := ColumnName;
end;

function TDBXMetaDataColumn.GetDefaultValue: WideString;
begin
  Result := FDefaultValue;
end;

procedure TDBXMetaDataColumn.SetDefaultValue(const DefaultValue: WideString);
begin
  self.FDefaultValue := DefaultValue;
end;

function TDBXMetaDataColumn.IsFixedLength: Boolean;
begin
  Result := FFixedLength;
end;

procedure TDBXMetaDataColumn.SetFixedLength(FixedLength: Boolean);
begin
  self.FFixedLength := FixedLength;
end;

function TDBXMetaDataColumn.GetMaxInline: Integer;
begin
  Result := FMaxInline;
end;

procedure TDBXMetaDataColumn.SetMaxInline(MaxInline: Integer);
begin
  self.FMaxInline := MaxInline;
end;

function TDBXMetaDataColumn.IsNullable: Boolean;
begin
  Result := FNullable;
end;

procedure TDBXMetaDataColumn.SetNullable(Nullable: Boolean);
begin
  self.FNullable := Nullable;
end;

function TDBXMetaDataColumn.IsLong: Boolean;
begin
  Result := FBlob;
end;

procedure TDBXMetaDataColumn.SetLong(Blob: Boolean);
begin
  self.FBlob := Blob;
end;

function TDBXMetaDataColumn.GetPrecision: Integer;
begin
  Result := FPrecision;
end;

procedure TDBXMetaDataColumn.SetPrecision(Precision: Integer);
begin
  self.FPrecision := Precision;
end;

function TDBXMetaDataColumn.GetScale: Integer;
begin
  Result := FScale;
end;

procedure TDBXMetaDataColumn.SetScale(Scale: Integer);
begin
  self.FScale := Scale;
end;

function TDBXMetaDataColumn.GetDataType: Integer;
begin
  Result := FMetaDataType;
end;

procedure TDBXMetaDataColumn.SetMetaDataColumnType(MetaDataType: Integer);
begin
  self.FMetaDataType := MetaDataType;
end;

function TDBXMetaDataColumn.IsUnicodeString: Boolean;
begin
  Result := FUnicodeString;
end;

procedure TDBXMetaDataColumn.SetUnicodeChar(UnicodeString: Boolean);
begin
  self.FUnicodeString := UnicodeString;
end;

function TDBXMetaDataColumn.IsUnsigned: Boolean;
begin
  Result := FUnsigned;
end;

procedure TDBXMetaDataColumn.SetUnsigned(Unsigned: Boolean);
begin
  self.FUnsigned := Unsigned;
end;

constructor TDBXInt8Column.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypesEx.Int8Type;
  ColumnName := InName;
end;

constructor TDBXInt64Column.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.Int64Type;
  ColumnName := InName;
end;

constructor TDBXInt32Column.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.Int32Type;
  ColumnName := InName;
end;

constructor TDBXInt16Column.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.Int16Type;
  ColumnName := InName;
end;

constructor TDBXDoubleColumn.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.DoubleType;
  ColumnName := InName;
end;

constructor TDBXDecimalColumn.Create(InName: WideString; InPrecision: Integer; InScale: Integer);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.BcdType;
  ColumnName := InName;
  Precision := InPrecision;
  Scale := InScale;
end;

constructor TDBXDateColumn.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.DateType;
  ColumnName := InName;
end;

constructor TDBXBooleanColumn.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.BooleanType;
  ColumnName := InName;
end;

constructor TDBXBinaryLongColumn.Create(Name: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.BlobType;
  Long := True;
  ColumnName := Name;
  Precision := 80000;
end;

constructor TDBXBinaryColumn.Create(InName: WideString; InPrecision: Integer);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.BytesType;
  FixedLength := True;
  ColumnName := InName;
  Precision := InPrecision;
  FixedLength := True;
end;

constructor TDBXAnsiVarCharColumn.Create(Name: WideString; InPrecision: Integer);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.AnsiStringType;
  Long := False;
  FixedLength := False;
  ColumnName := Name;
  Precision := InPrecision;
end;

constructor TDBXAnsiLongColumn.Create(Name: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.AnsiStringType;
  Long := True;
  ColumnName := Name;
  Precision := 80000;
end;

constructor TDBXAnsiCharColumn.Create(Name: WideString; InPrecision: Integer);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.AnsiStringType;
  Long := False;
  FixedLength := True;
  ColumnName := Name;
  Precision := InPrecision;
end;

constructor TDBXMetaDataForeignKey.Create;
begin
  inherited Create;
  FForeignkey := TDBXForeignKeysTableStorage.Create;
  FColumns := TDBXForeignKeyColumnsTableStorage.Create;
  FForeignkey.NewRow;
  FForeignkey.InsertRow;
end;

destructor TDBXMetaDataForeignKey.Destroy;
begin
  FreeAndNil(FForeignkey);
  FreeAndNil(FColumns);
  inherited Destroy;
end;

constructor TDBXMetaDataForeignKey.Create(const InForeignTableName: WideString; const InPrimaryTableName: WideString; const InForeignKeyName: WideString; References: array of WideString);
var
  Index: Integer;
begin
  Create;
  TableName := InForeignTableName;
  PrimaryTableName := InPrimaryTableName;
  ForeignKeyName := InForeignKeyName;
  Index := 0;
  while Index < Length(References) do
  begin
    AddReference(References[Index], References[Index + 1]);
    Index := Index + 2;
  end;
end;

function TDBXMetaDataForeignKey.GetForeignKeyColumnsStorage: TDBXForeignKeyColumnsTableStorage;
begin
  FColumns.BeforeFirst;
  while FColumns.Next do
  begin
    FColumns.PrimaryCatalogName := FPrimaryCatalogName;
    FColumns.PrimarySchemaName := FPrimarySchemaName;
    FColumns.PrimaryTableName := FPrimaryTableName;
  end;
  Result := FColumns;
end;

function TDBXMetaDataForeignKey.GetCatalogName: WideString;
begin
  Result := FForeignkey.CatalogName;
end;

procedure TDBXMetaDataForeignKey.SetCatalogName(const CatalogName: WideString);
begin
  FForeignkey.CatalogName := CatalogName;
end;

function TDBXMetaDataForeignKey.GetSchemaName: WideString;
begin
  Result := FForeignkey.SchemaName;
end;

procedure TDBXMetaDataForeignKey.SetSchemaName(const SchemaName: WideString);
begin
  FForeignkey.SchemaName := SchemaName;
end;

function TDBXMetaDataForeignKey.GetTableName: WideString;
begin
  Result := FForeignkey.TableName;
end;

procedure TDBXMetaDataForeignKey.SetTableName(const TableName: WideString);
begin
  FForeignkey.TableName := TableName;
end;

function TDBXMetaDataForeignKey.GetForeignKeyName: WideString;
begin
  Result := FForeignkey.ForeignKeyName;
end;

procedure TDBXMetaDataForeignKey.SetForeignKeyName(const ForeignKeyName: WideString);
begin
  FForeignkey.ForeignKeyName := ForeignKeyName;
end;

procedure TDBXMetaDataForeignKey.AddReference(const ColumnName: WideString; const ColumnNameInPrimaryTable: WideString);
begin
  IncrAfter(FColumnCount);
  FColumns.NewRow;
  FColumns.Ordinal := FColumnCount;
  FColumns.ColumnName := ColumnName;
  FColumns.PrimaryColumnName := ColumnNameInPrimaryTable;
  FColumns.InsertRow;
end;

constructor TDBXMetaDataIndex.Create;
begin
  inherited Create;
  FIndexes := TDBXIndexesTableStorage.Create;
  FColumns := TDBXIndexColumnsTableStorage.Create;
  FIndexes.NewRow;
  FIndexes.InsertRow;
end;

destructor TDBXMetaDataIndex.Destroy;
begin
  FreeAndNil(FIndexes);
  FreeAndNil(FColumns);
  inherited Destroy;
end;

constructor TDBXMetaDataIndex.Create(const InTableName: WideString; const InIndexName: WideString; Columns: array of WideString);
var
  Index: Integer;
begin
  Create;
  TableName := InTableName;
  IndexName := InIndexName;
  for index := 0 to Length(Columns) - 1 do
    AddColumn(Columns[Index]);
end;

function TDBXMetaDataIndex.GetCatalogName: WideString;
begin
  Result := FIndexes.CatalogName;
end;

procedure TDBXMetaDataIndex.SetCatalogName(const CatalogName: WideString);
begin
  FIndexes.CatalogName := CatalogName;
end;

function TDBXMetaDataIndex.GetSchemaName: WideString;
begin
  Result := FIndexes.SchemaName;
end;

procedure TDBXMetaDataIndex.SetSchemaName(const SchemaName: WideString);
begin
  FIndexes.SchemaName := SchemaName;
end;

function TDBXMetaDataIndex.GetTableName: WideString;
begin
  Result := FIndexes.TableName;
end;

procedure TDBXMetaDataIndex.SetTableName(const TableName: WideString);
begin
  FIndexes.TableName := TableName;
end;

function TDBXMetaDataIndex.GetIndexName: WideString;
begin
  Result := FIndexes.IndexName;
end;

procedure TDBXMetaDataIndex.SetIndexName(const IndexName: WideString);
begin
  FIndexes.IndexName := IndexName;
end;

function TDBXMetaDataIndex.IsUnique: Boolean;
begin
  Result := FIndexes.Unique;
end;

procedure TDBXMetaDataIndex.SetUnique(const Unique: Boolean);
begin
  FIndexes.Unique := Unique;
end;

procedure TDBXMetaDataIndex.AddColumn(const ColumnName: WideString);
begin
  AddColumn(ColumnName, True);
end;

procedure TDBXMetaDataIndex.AddColumn(const ColumnName: WideString; Ascending: Boolean);
begin
  IncrAfter(FColumnCount);
  FColumns.NewRow;
  FColumns.Ordinal := FColumnCount;
  FColumns.ColumnName := ColumnName;
  FColumns.Ascending := Ascending;
  FColumns.InsertRow;
end;

destructor TDBXMetaDataProvider.Destroy;
begin
  FreeAndNil(FExecuter);
  FreeAndNil(FWriter);
  inherited Destroy;
end;

procedure TDBXMetaDataProvider.SetWriter(Writer: TDBXMetaDataWriter);
begin
  self.FWriter := Writer;
  self.FExecuter := TDBXSqlExecution.Create(Writer);
end;

function TDBXMetaDataProvider.GetWriter: TDBXMetaDataWriter;
begin
  Result := self.FWriter;
end;

function TDBXMetaDataProvider.GetVendor: WideString;
begin
  Result := FWriter.MetaDataReader.ProductName;
end;

function TDBXMetaDataProvider.CheckColumnSupported(Column: TDBXMetaDataColumn): Boolean;
var
  Storage: TDBXColumnsTableStorage;
  Supported: Boolean;
begin
  Storage := TDBXColumnsTableStorage.Create;
  Storage.NewRow;
  Column.CopyColumnToTableStorage(Storage);
  Storage.InsertRow;
  Supported := FWriter.CheckColumnSupported(Storage);
  FreeAndNil(Storage);
  Result := Supported;
end;

procedure TDBXMetaDataProvider.Execute(const Sql: WideString);
begin
  FExecuter.Execute(Sql);
end;

procedure TDBXMetaDataProvider.CreateTable(Table: TDBXMetaDataTable);
var
  Sql: WideString;
begin
  Sql := MakeCreateTableSql(Table.TableStorage, Table.ColumnsStorage);
  FExecuter.Execute(Sql);
end;

function TDBXMetaDataProvider.DropTable(const SchemaName: WideString; const TableName: WideString): Boolean;
var
  Storage: TDBXTableStorage;
  Builder: TDBXWideStringBuffer;
  Success: Boolean;
  Tables: TDBXTablesTableStorage;
  Sql: WideString;
begin
  Storage := nil;
  Builder := TDBXWideStringBuffer.Create;
  Success := False;
  try
    Builder.Append('GetTables ');
    if not StringIsNil(SchemaName) then
    begin
      FWriter.MakeSqlIdentifier(Builder, SchemaName);
      Builder.Append('.');
    end;
    FWriter.MakeSqlIdentifier(Builder, TableName);
    Storage := GetCollection(Builder.ToString);
    Tables := TDBXTablesTableStorage(Storage);
    ToMemoryStorage(Tables);
    Tables.BeforeFirst;
    if Tables.Next and not Tables.Next then
    begin
      Tables.BeforeFirst;
      if Tables.Next then
      begin
        Sql := MakeDropTableSql(Tables);
        Execute(Sql);
        Success := True;
      end;
    end;
    Result := Success;
  finally
    Storage.Free;
    Builder.Free;
  end;
end;

function TDBXMetaDataProvider.DropTable(const TableName: WideString): Boolean;
begin
  Result := DropTable(NullString, TableName);
end;

procedure TDBXMetaDataProvider.CreatePrimaryKey(Index: TDBXMetaDataIndex);
var
  Indexes: TDBXIndexesTableStorage;
begin
  Index.Unique := True;
  Indexes := Index.IndexesStorage;
  Indexes.Primary := True;
  CreateIndex(Index);
end;

procedure TDBXMetaDataProvider.CreateUniqueIndex(Index: TDBXMetaDataIndex);
begin
  Index.Unique := True;
  CreateIndex(Index);
end;

procedure TDBXMetaDataProvider.CreateIndex(Index: TDBXMetaDataIndex);
var
  Sql: WideString;
begin
  Sql := MakeCreateIndexSql(Index.IndexesStorage, Index.IndexColumnsStorage);
  FExecuter.Execute(Sql);
end;

function TDBXMetaDataProvider.DropIndex(const TableName: WideString; const IndexName: WideString): Boolean;
begin
  Result := DropIndex(NullString, TableName, IndexName);
end;

function TDBXMetaDataProvider.DropIndex(const SchemaName: WideString; const TableName: WideString; const IndexName: WideString): Boolean;
var
  Storage: TDBXTableStorage;
  Builder: TDBXWideStringBuffer;
  Success: Boolean;
  Indexes: TDBXIndexesTableStorage;
  Sql: WideString;
begin
  Storage := nil;
  Builder := TDBXWideStringBuffer.Create;
  Success := False;
  try
    Builder.Append('GetIndexes ');
    if not StringIsNil(SchemaName) then
    begin
      FWriter.MakeSqlIdentifier(Builder, SchemaName);
      Builder.Append('.');
    end;
    FWriter.MakeSqlIdentifier(Builder, TableName);
    Storage := GetCollection(Builder.ToString);
    Indexes := TDBXIndexesTableStorage(Storage);
    ToMemoryStorage(Indexes);
    Indexes.BeforeFirst;
    while Indexes.Next do
    begin
      if (not StringIsNil(IndexName)) and (IndexName = Indexes.IndexName) then
      begin
        Sql := MakeDropIndexSql(Indexes);
        Execute(Sql);
        Success := True;
      end;
    end;
    Result := Success;
  finally
    Storage.Free;
    Builder.Free;
  end;
end;

procedure TDBXMetaDataProvider.CreateForeignKey(Foreignkey: TDBXMetaDataForeignKey);
var
  Sql: WideString;
begin
  Sql := MakeCreateForeignKeySql(Foreignkey.ForeignKeysStorage, Foreignkey.ForeignKeyColumnsStorage);
  FExecuter.Execute(Sql);
end;

function TDBXMetaDataProvider.DropForeignKey(const TableName: WideString; const ForeignKey: WideString): Boolean;
begin
  Result := DropForeignKey(NullString, TableName, ForeignKey);
end;

function TDBXMetaDataProvider.DropForeignKey(const SchemaName: WideString; const TableName: WideString; const ForeignKey: WideString): Boolean;
var
  Storage: TDBXTableStorage;
  Builder: TDBXWideStringBuffer;
  Success: Boolean;
  ForeignKeys: TDBXForeignKeysTableStorage;
  Sql: WideString;
begin
  Storage := nil;
  Builder := TDBXWideStringBuffer.Create;
  Success := False;
  try
    Builder.Append('GetForeignKeys ');
    if not StringIsNil(SchemaName) then
    begin
      FWriter.MakeSqlIdentifier(Builder, SchemaName);
      Builder.Append('.');
    end;
    FWriter.MakeSqlIdentifier(Builder, TableName);
    Storage := GetCollection(Builder.ToString);
    ForeignKeys := TDBXForeignKeysTableStorage(Storage);
    ToMemoryStorage(ForeignKeys);
    ForeignKeys.BeforeFirst;
    if (not StringIsNil(ForeignKey)) or (ForeignKeys.Next and not ForeignKeys.Next) then
    begin
      ForeignKeys.BeforeFirst;
      while ForeignKeys.Next do
      begin
        if (StringIsNil(ForeignKey)) or (ForeignKey = ForeignKeys.ForeignKeyName) then
        begin
          Sql := MakeDropForeignKeySql(ForeignKeys);
          Execute(Sql);
          Success := True;
        end;
      end;
    end;
    Result := Success;
  finally
    Storage.Free;
    Builder.Free;
  end;
end;

function TDBXMetaDataProvider.QuoteIdentifierIfNeeded(const Identifier: WideString): WideString;
var
  Builder: TDBXWideStringBuffer;
  Id: WideString;
begin
  Builder := TDBXWideStringBuffer.Create;
  FWriter.MakeSqlIdentifier(Builder, Identifier);
  Id := Builder.ToString;
  FreeAndNil(Builder);
  Result := Id;
end;

function TDBXMetaDataProvider.GetCollection(MetaDataCommand: WideString): TDBXTableStorage;
var
  Table: TDBXTableStorage;
begin
  Table := FWriter.MetaDataReader.FetchCollection(MetaDataCommand);
  if Table = nil then
  begin
    Result := nil;
    exit;
  end;
  case Table.MetaDataCollectionIndex of
    TDBXMetaDataCollectionIndex.DataTypes:
      Result := TDBXDataTypesTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.Catalogs:
      Result := TDBXCatalogsTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.Schemas:
      Result := TDBXSchemasTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.Tables:
      Result := TDBXTablesTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.Views:
      Result := TDBXViewsTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.Synonyms:
      Result := TDBXSynonymsTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.Columns:
      Result := TDBXColumnsTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.Indexes:
      Result := TDBXIndexesTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.IndexColumns:
      Result := TDBXIndexColumnsTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.ForeignKeys:
      Result := TDBXForeignKeysTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.ForeignKeyColumns:
      Result := TDBXForeignKeyColumnsTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.Procedures:
      Result := TDBXProceduresTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.ProcedureSources:
      Result := TDBXProcedureSourcesTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.ProcedureParameters:
      Result := TDBXProcedureParametersTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.Packages:
      Result := TDBXPackagesTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.PackageSources:
      Result := TDBXPackageSourcesTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.Users:
      Result := TDBXUsersTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.Roles:
      Result := TDBXRolesTableStorage.Create(Table);
    TDBXMetaDataCollectionIndex.ReservedWords:
      Result := TDBXReservedWordsTableStorage.Create(Table);
    else
      Result := nil;
  end;
end;

procedure TDBXMetaDataProvider.ToMemoryStorage(Table: TDBXDelegateTableStorage);
var
  Storage: TDBXTableStorage;
begin
  if Table.Storage = nil then
  begin
    Storage := TDBXTableStoragePlatform.Create(Table.MetaDataCollectionIndex, Table.MetaDataCollectionName);
    Storage.Columns := Table.CopyColumns;
    Storage.CopyFrom(Table);
    Storage.AcceptChanges;
    Storage := Table.ReplaceStorage(Storage);
    Storage.Close;
    FreeAndNil(Storage);
  end;
end;

function TDBXMetaDataProvider.MakeCreateTableSql(Table: TDBXTablesTableStorage; Columns: TDBXColumnsTableStorage): WideString;
var
  Builder: TDBXWideStringBuffer;
  Sql: WideString;
begin
  Builder := TDBXWideStringBuffer.Create;
  FWriter.MakeSqlCreate(Builder, Table, Columns);
  Sql := Builder.ToString;
  FreeAndNil(Builder);
  Result := Sql;
end;

function TDBXMetaDataProvider.MakeAlterTableSql(Table: TDBXTablesTableStorage; Columns: TDBXColumnsTableStorage): WideString;
var
  Builder: TDBXWideStringBuffer;
  Sql: WideString;
begin
  Builder := TDBXWideStringBuffer.Create;
  FWriter.MakeSqlAlter(Builder, Table, Columns);
  Sql := Builder.ToString;
  FreeAndNil(Builder);
  Result := Sql;
end;

function TDBXMetaDataProvider.MakeDropTableSql(Table: TDBXTablesTableStorage): WideString;
var
  Builder: TDBXWideStringBuffer;
  Sql: WideString;
begin
  Builder := TDBXWideStringBuffer.Create;
  FWriter.MakeSqlDrop(Builder, Table);
  Sql := Builder.ToString;
  FreeAndNil(Builder);
  Result := Sql;
end;

function TDBXMetaDataProvider.MakeCreateIndexSql(Indexes: TDBXIndexesTableStorage; Columns: TDBXIndexColumnsTableStorage): WideString;
var
  Builder: TDBXWideStringBuffer;
  Sql: WideString;
begin
  Builder := TDBXWideStringBuffer.Create;
  FWriter.MakeSqlCreate(Builder, Indexes, Columns);
  Sql := Builder.ToString;
  FreeAndNil(Builder);
  Result := Sql;
end;

function TDBXMetaDataProvider.MakeDropIndexSql(Indexes: TDBXIndexesTableStorage): WideString;
var
  Builder: TDBXWideStringBuffer;
  Sql: WideString;
begin
  Builder := TDBXWideStringBuffer.Create;
  FWriter.MakeSqlDrop(Builder, Indexes);
  Sql := Builder.ToString;
  FreeAndNil(Builder);
  Result := Sql;
end;

function TDBXMetaDataProvider.MakeCreateForeignKeySql(ForeignKeys: TDBXForeignKeysTableStorage; Columns: TDBXForeignKeyColumnsTableStorage): WideString;
var
  Builder: TDBXWideStringBuffer;
  Sql: WideString;
begin
  Builder := TDBXWideStringBuffer.Create;
  FWriter.MakeSqlCreate(Builder, ForeignKeys, Columns);
  Sql := Builder.ToString;
  FreeAndNil(Builder);
  Result := Sql;
end;

function TDBXMetaDataProvider.MakeDropForeignKeySql(ForeignKey: TDBXForeignKeysTableStorage): WideString;
var
  Builder: TDBXWideStringBuffer;
  Sql: WideString;
begin
  Builder := TDBXWideStringBuffer.Create;
  FWriter.MakeSqlDrop(Builder, ForeignKey);
  Sql := Builder.ToString;
  FreeAndNil(Builder);
  Result := Sql;
end;

function TDBXMetaDataProvider.MakeAlterTableSql(Indexes: TDBXIndexesTableStorage; Columns: TDBXIndexColumnsTableStorage): WideString;
var
  Builder: TDBXWideStringBuffer;
  Sql: WideString;
begin
  Builder := TDBXWideStringBuffer.Create;
  FWriter.MakeSqlAlter(Builder, Indexes, Columns);
  Sql := Builder.ToString;
  FreeAndNil(Builder);
  Result := Sql;
end;

function TDBXMetaDataProvider.GetDatabaseProduct: WideString;
begin
  Result := FWriter.MetaDataReader.ProductName;
end;

function TDBXMetaDataProvider.GetDatabaseVersion: WideString;
begin
  Result := FWriter.MetaDataReader.Version;
end;

function TDBXMetaDataProvider.GetIdentifierQuotePrefix: WideString;
begin
  Result := FWriter.MetaDataReader.SqlIdentifierQuotePrefix;
end;

function TDBXMetaDataProvider.GetIdentifierQuoteSuffix: WideString;
begin
  Result := FWriter.MetaDataReader.SqlIdentifierQuoteSuffix;
end;

function TDBXMetaDataProvider.IsCatalogsSupported: Boolean;
begin
  Result := FWriter.CatalogsSupported;
end;

function TDBXMetaDataProvider.IsSchemasSupported: Boolean;
begin
  Result := FWriter.SchemasSupported;
end;

function TDBXMetaDataProvider.IsMultipleStatementsSupported: Boolean;
begin
  Result := FWriter.MultipleStatementsSupported;
end;

function TDBXMetaDataProvider.IsDescendingIndexSupported: Boolean;
begin
  Result := FWriter.MetaDataReader.DescendingIndexSupported;
end;

function TDBXMetaDataProvider.IsDescendingIndexColumnsSupported: Boolean;
begin
  Result := FWriter.MetaDataReader.DescendingIndexColumnsSupported;
end;

function TDBXMetaDataProvider.IsMixedDDLAndDMLSupported: Boolean;
begin
  Result := FWriter.Mixed_DDL_DML_Supported;
end;

function TDBXMetaDataProvider.IsDDLTransactionsSupported: Boolean;
begin
  Result := FWriter.DDLTransactionsSupported;
end;

constructor TDBXMetaDataTable.Create;
begin
  inherited Create;
  FTable := TDBXTablesTableStorage.Create;
  FColumns := TDBXColumnsTableStorage.Create;
  FTable.NewRow;
  FTable.InsertRow;
end;

destructor TDBXMetaDataTable.Destroy;
var
  Index: Integer;
begin
  if FMetaDataColumns <> nil then
    for index := 0 to Length(FMetaDataColumns) - 1 do
      FreeAndNil(FMetaDataColumns[Index]);
  FMetaDataColumns := nil;
  FreeAndNil(FTable);
  FreeAndNil(FColumns);
  inherited Destroy;
end;

function TDBXMetaDataTable.GetCatalogName: WideString;
begin
  Result := FTable.CatalogName;
end;

procedure TDBXMetaDataTable.SetCatalogName(const CatalogName: WideString);
begin
  FTable.CatalogName := CatalogName;
end;

function TDBXMetaDataTable.GetSchemaName: WideString;
begin
  Result := FTable.SchemaName;
end;

procedure TDBXMetaDataTable.SetSchemaName(const SchemaName: WideString);
begin
  FTable.SchemaName := SchemaName;
end;

function TDBXMetaDataTable.GetTableName: WideString;
begin
  Result := FTable.TableName;
end;

procedure TDBXMetaDataTable.SetTableName(const TableName: WideString);
begin
  FTable.TableName := TableName;
end;

procedure TDBXMetaDataTable.AddColumn(Column: TDBXMetaDataColumn);
var
  Temp: TDBXMetaDataColumnArray;
  Index: Integer;
begin
  FColumns.NewRow;
  FColumns.Ordinal := Incr(FColumnCount);
  Column.CopyColumnToTableStorage(FColumns);
  FColumns.InsertRow;
  if FColumns = nil then
    SetLength(FMetaDataColumns,1)
  else 
  begin
    SetLength(Temp,Length(FMetaDataColumns) + 1);
    for index := 0 to Length(FMetaDataColumns) - 1 do
      Temp[Index] := FMetaDataColumns[Index];
    FMetaDataColumns := Temp;
  end;
  FMetaDataColumns[Length(FMetaDataColumns) - 1] := Column;
end;

function TDBXMetaDataTable.GetColumn(Ordinal: Integer): TDBXMetaDataColumn;
begin
  if FMetaDataColumns = nil then
  begin
    Result := nil;
    exit;
  end;
  Result := FMetaDataColumns[Ordinal];
end;

constructor TDBXObjectColumn.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypesEx.ObjectType;
  ColumnName := InName;
end;

constructor TDBXSingleColumn.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypesEx.SingleType;
  ColumnName := InName;
end;

constructor TDBXSqlExecution.Create(Writer: TDBXMetaDataWriter);
begin
  inherited Create;
  self.FContext := Writer.Context;
end;

procedure TDBXSqlExecution.Execute(const Sql: WideString);
var
  Statement: WideString;
  Start: Integer;
  Index: Integer;
  Storage: TDBXTableStorage;
begin
  Statement := NullString;
  Start := 0;
  Index := StringIndexOf(Sql,';');
  while Index >= 0 do
  begin
    Statement := Copy(Sql,Start+1,Index-(Start));
    Statement := Trim(Statement);
    if Length(Statement) > 0 then
    begin
      Storage := FContext.ExecuteQuery(Statement, nil, nil);
      FreeAndNil(Storage);
    end;
    Start := Index + 1;
    Index := StringIndexOf(Sql,';',Start);
  end;
  Statement := Copy(Sql,Start+1,Length(Sql)-(Start));
  Statement := Trim(Statement);
  if Length(Statement) > 0 then
    FContext.ExecuteQuery(Statement, nil, nil);
end;

constructor TDBXTimeColumn.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.TimeType;
  ColumnName := InName;
end;

constructor TDBXTimestampColumn.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.TimestampType;
  ColumnName := InName;
end;

constructor TDBXUInt16Column.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.UInt16Type;
  ColumnName := InName;
  Unsigned := True;
end;

constructor TDBXUInt32Column.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.UInt32Type;
  ColumnName := InName;
  Unsigned := True;
end;

constructor TDBXUInt64Column.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.UInt64Type;
  ColumnName := InName;
  Unsigned := True;
end;

constructor TDBXUInt8Column.Create(InName: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypesEx.UInt8Type;
  ColumnName := InName;
  Unsigned := True;
end;

constructor TDBXUnicodeCharColumn.Create(Name: WideString; InPrecision: Integer);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.WideStringType;
  Long := False;
  FixedLength := True;
  ColumnName := Name;
  UnicodeChar := True;
  Precision := InPrecision;
end;

constructor TDBXUnicodeLongColumn.Create(Name: WideString);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.WideStringType;
  Long := True;
  UnicodeChar := True;
  ColumnName := Name;
  Precision := 80000;
end;

constructor TDBXUnicodeVarCharColumn.Create(InName: WideString; InPrecision: Integer);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.WideStringType;
  Long := False;
  FixedLength := False;
  ColumnName := InName;
  UnicodeChar := True;
  Precision := InPrecision;
end;

constructor TDBXVarBinaryColumn.Create(InName: WideString; InPrecision: Integer);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.VarbytesType;
  ColumnName := InName;
  Precision := InPrecision;
end;

constructor TDBXWideVarCharColumn.Create(Name: WideString; InPrecision: Integer);
begin
  inherited Create;
  MetaDataColumnType := TDBXDataTypes.WideStringType;
  Long := False;
  FixedLength := False;
  ColumnName := Name;
  Precision := InPrecision;
end;

end.
