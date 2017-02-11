{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXMetaDataWriter;
interface
uses
  DBXMetaDataReader,
  DBXPlatform,
  DBXPlatformUtil,
  DBXTableStorage,
  SysUtils;
type
  TDBXAlterTableOperation = class
  public
    const NoSupport = 0;
    const RenameTable = 1;
    const RenameTableTo = 2;
    const DropColumn = 4;
    const AddColumn = 8;
    const AddColumnWithPosition = 16;
    const ChangeDefaultValue = 32;
    const DropDefaultValue = 64;
    const SetNullable = 128;
    const DropNullable = 256;
    const ChangeColumnType = 512;
    const AddAutoincrement = 1024;
    const DropAutoincrement = 2048;
    const ChangeColumnPosition = 4096;
    const RenameColumn = 8192;
    const FullAlterSupport = 16383;
  end;

  TDBXMetaDataWriter = class abstract
  public
    procedure Open; virtual; abstract;
    procedure MakeSqlCreate(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage; Parts: TDBXTableStorage); virtual; abstract;
    procedure MakeSqlAlter(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage; Parts: TDBXTableStorage); virtual; abstract;
    procedure MakeSqlDrop(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage); virtual; abstract;
    procedure MakeSqlIdentifier(Buffer: TDBXWideStringBuffer; Identifier: WideString); virtual; abstract;
    function CheckColumnSupported(Column: TDBXRowStorage): Boolean; virtual; abstract;
    function GetSqlQuotedIdentifier(UnquotedIdentifier: WideString): WideString; virtual; abstract;
    function GetSqlUnQuotedIdentifier(QuotedIdentifier: WideString): WideString; virtual; abstract;
  protected
    procedure SetContext(Context: TDBXProviderContext); virtual; abstract;
    function GetContext: TDBXProviderContext; virtual; abstract;
    function GetMetaDataReader: TDBXMetaDataReader; virtual; abstract;
    function GetSqlRenameTable: WideString; virtual; abstract;
    function GetSqlAutoIncrementInserts: WideString; virtual; abstract;
    function GetSqlAutoIncrementKeyword: WideString; virtual; abstract;
    function GetSqlKeyGeneratedIndexName: WideString; virtual; abstract;
    function GetAlterTableSupport: Integer; virtual; abstract;
    function IsCatalogsSupported: Boolean; virtual; abstract;
    function IsSchemasSupported: Boolean; virtual; abstract;
    function IsMultipleStatementsSupported: Boolean; virtual; abstract;
    function IsIndexNamesGlobal: Boolean; virtual; abstract;
    function IsDescendingIndexConstraintsSupported: Boolean; virtual; abstract;
    function IsSerializedIsolationSupported: Boolean; virtual; abstract;
    function IsDDLTransactionsSupported: Boolean; virtual; abstract;
    function IsMixed_DDL_DML_Supported: Boolean; virtual; abstract;
  public
    property Context: TDBXProviderContext read GetContext write SetContext;
    property MetaDataReader: TDBXMetaDataReader read GetMetaDataReader;
    property SqlRenameTable: WideString read GetSqlRenameTable;
    property SqlAutoIncrementInserts: WideString read GetSqlAutoIncrementInserts;
    property SqlAutoIncrementKeyword: WideString read GetSqlAutoIncrementKeyword;
    property SqlKeyGeneratedIndexName: WideString read GetSqlKeyGeneratedIndexName;
    property AlterTableSupport: Integer read GetAlterTableSupport;
    property CatalogsSupported: Boolean read IsCatalogsSupported;
    property SchemasSupported: Boolean read IsSchemasSupported;
    property MultipleStatementsSupported: Boolean read IsMultipleStatementsSupported;
    property IndexNamesGlobal: Boolean read IsIndexNamesGlobal;
    property DescendingIndexConstraintsSupported: Boolean read IsDescendingIndexConstraintsSupported;
    property SerializedIsolationSupported: Boolean read IsSerializedIsolationSupported;
    property DDLTransactionsSupported: Boolean read IsDDLTransactionsSupported;
    property Mixed_DDL_DML_Supported: Boolean read IsMixed_DDL_DML_Supported;
  end;

  TDBXBaseMetaDataWriter = class(TDBXMetaDataWriter)
  public
    procedure Open; override;
    destructor Destroy; override;
    procedure MakeSqlCreate(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage; Parts: TDBXTableStorage); override;
    procedure MakeSqlAlter(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage; Parts: TDBXTableStorage); override;
    procedure MakeSqlDrop(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage); override;
    function CheckColumnSupported(Column: TDBXRowStorage): Boolean; override;
    function GetSqlQuotedIdentifier(UnquotedIdentifier: WideString): WideString; override;
    function GetSqlUnQuotedIdentifier(QuotedIdentifier: WideString): WideString; override;
    procedure MakeSqlIdentifier(Buffer: TDBXWideStringBuffer; Identifier: WideString); override;
  protected
    procedure SetContext(Context: TDBXProviderContext); override;
    function GetContext: TDBXProviderContext; override;
    function GetMetaDataReader: TDBXMetaDataReader; override;
    function IsCatalogsSupported: Boolean; override;
    function IsSchemasSupported: Boolean; override;
    function IsMultipleStatementsSupported: Boolean; override;
    function IsIndexNamesGlobal: Boolean; override;
    function IsDescendingIndexConstraintsSupported: Boolean; override;
    function IsSerializedIsolationSupported: Boolean; override;
    function IsDDLTransactionsSupported: Boolean; override;
    function IsMixed_DDL_DML_Supported: Boolean; override;
    function GetAlterTableSupport: Integer; override;
    function GetSqlAutoIncrementKeyword: WideString; override;
    function GetSqlKeyGeneratedIndexName: WideString; override;
    function GetSqlAutoIncrementInserts: WideString; override;
    function GetSqlRenameTable: WideString; override;
    procedure MakeSqlObjectName(Buffer: TDBXWideStringBuffer; CatalogName: WideString; SchemaName: WideString; ObjectName: WideString); virtual;
    procedure MakeSqlNullable(Buffer: TDBXWideStringBuffer; Column: TDBXRowStorage); virtual;
    procedure MakeSqlDataType(Buffer: TDBXWideStringBuffer; TypeName: WideString; ColumnRow: TDBXRowStorage); overload; virtual;
    procedure MakeSqlDataType(Buffer: TDBXWideStringBuffer; DataType: TDBXDataTypeDescription; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s); overload; virtual;
    function FindDataType(TypeName: WideString; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s): TDBXDataTypeDescription; virtual;
    function FindTypeName(ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s; FailIfNotFound: Boolean): WideString; virtual;
    function FindSimpleColumnTypeMatch(ColumnRow: TDBXRowStorage; FailIfNotFound: Boolean): WideString; virtual;
    function FindBooleanTypeName(ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s; FailIfNotFound: Boolean): WideString; virtual;
    function FindStringOrBinaryTypeName(ColumnRow: TDBXRowStorage; FailIfNotFound: Boolean): WideString; virtual;
    function FindIntegerTypeName(ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s; FailIfNotFound: Boolean): WideString; virtual;
    function FindDecimalTypeName(ColumnRow: TDBXRowStorage; FailIfNotFound: Boolean): WideString; virtual;
    function FindFloatTypeName(ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s; FailIfNotFound: Boolean): WideString; virtual;
    function FindDateTimeTypeName(ColumnRow: TDBXRowStorage; FailIfNotFound: Boolean): WideString; virtual;
    procedure MakeSqlColumnTypeCast(Buffer: TDBXWideStringBuffer; Column: TDBXRowStorage); virtual;
    function CanCreateIndexAsKey(Index: TDBXRowStorage; IndexColumns: TDBXTableStorage): Boolean; virtual;
    procedure MakeSqlCreateIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage; IndexColumns: TDBXTableStorage); virtual;
    procedure MakeSqlDropIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage); virtual;
    procedure MakeSqlCreateKey(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage; IndexColumns: TDBXTableStorage); virtual;
    procedure MakeSqlConstraintName(Buffer: TDBXWideStringBuffer; Constraint: TDBXRowStorage);
    procedure MakeSqlAlterTablePrefix(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage); virtual;
    procedure MakeSqlCreateIndexColumnList(Buffer: TDBXWideStringBuffer; IndexColumns: TDBXTableStorage); virtual;
    procedure MakeSqlDropSecondaryIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage); virtual;
    procedure MakeSqlForeignKeySyntax(Buffer: TDBXWideStringBuffer; ForeignKey: TDBXRowStorage; ForeignKeyColumns: TDBXTableStorage);
    procedure MakeSqlCreateForeignKey(Buffer: TDBXWideStringBuffer; ForeignKey: TDBXRowStorage; ForeignKeyColumns: TDBXTableStorage); virtual;
    procedure MakeSqlDropForeignKey(Buffer: TDBXWideStringBuffer; ForeignKey: TDBXRowStorage); virtual;
  private
    procedure MakeSqlCreateTable(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Columns: TDBXTableStorage);
    procedure MakeSqlAlterTable(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Columns: TDBXTableStorage);
    function SupportedTableAlteration(Operation: Integer): Boolean;
    function MakeSqlFullAlterTable(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Columns: TDBXTableStorage): Boolean;
    function MakeSqlTableRename(Buffer: TDBXWideStringBuffer; CatalogName: WideString; SchemaName: WideString; TableName: WideString; OldCatalogName: WideString; OldSchemaName: WideString; OldTableName: WideString): Boolean; overload;
    function MakeSqlColumnRename(Buffer: TDBXWideStringBuffer; ColumnName: WideString; CatalogName: WideString; SchemaName: WideString; TableName: WideString; OldColumnName: WideString): Boolean;
    procedure MakeSqlColumnDefinition(Buffer: TDBXWideStringBuffer; Column: TDBXRowStorage);
    procedure MakeSqlDefaultValue(Buffer: TDBXWideStringBuffer; DefaultValue: WideString; TypeName: WideString);
    function RemoveMarkersForNullValues(Format: WideString; Values: TDBXWideStringArray): WideString;
    function ErrorTypeNameNotFound(ColumnRow: TDBXRowStorage): Exception;
    function CalcPrecisionColumnType(ColumnType: Integer; UnsignedOption: Boolean): Integer;
    function CalcDecimalPrecision(ColumnType: Integer): Integer;
    function CalcBinaryPrecision(ColumnType: Integer): Integer;
    function IsSignedInteger(ColumnType: Integer): Boolean;
    function GetDefaultFloatPrecision(ColumnType: Integer): Integer;
    function AddToExternalStatements(ExternalStatements: TDBXWideStringBuffer; Buffer: TDBXWideStringBuffer; StartPosition: Integer): TDBXWideStringBuffer;
    function IsValidSqlIdentifier(Identifier: WideString): Boolean;
    function IsReservedWord(Identifier: WideString): Boolean;
    function IsLetter(Ch: WideChar; UpperOK: Boolean; LowerOK: Boolean): Boolean;
    function IsDigit(Ch: WideChar): Boolean;
    procedure MakeSqlTableReplacement(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Columns: TDBXTableStorage);
    function CopyColumns(ColumnTable: TDBXTableStorage): TDBXTableStorage;
    function CopyTableRow(Table: TDBXRowStorage; TempTableName: WideString): TDBXRowStorage;
    function ComputeColumnMap(Columns: TDBXTableStorage): TDBXStringStore;
    function GetDefaults(CatalogName: WideString; SchemaName: WideString; TableName: WideString): TDBXTableStorage;
    function GetIndexes(CatalogName: WideString; SchemaName: WideString; TableName: WideString): TDBXTableStorage;
    function GetIndexColumns(CatalogName: WideString; SchemaName: WideString; TableName: WideString): TDBXTableStorage;
    function GetForeignKeyColumns(CatalogName: WideString; SchemaName: WideString; TableName: WideString): TDBXTableStorage;
    procedure RemoveForeignKeyGeneratedIndexes(Table: TDBXRowStorage; Indexes: TDBXTableStorage; IndexColumns: TDBXTableStorage; ForeignKeyColumns: TDBXTableStorage);
    procedure DropAllConstraints(Buffer: TDBXWideStringBuffer; Defaults: TDBXTableStorage; Indexes: TDBXTableStorage; ForeignKeys: TDBXTableStorage);
    procedure CreateTempOutputTable(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Columns: TDBXTableStorage; TempTableName: WideString);
    procedure SetIdentityInsert(Buffer: TDBXWideStringBuffer; CatalogName: WideString; SchemaName: WideString; TableName: WideString; &On: Boolean);
    function CheckForAutoIncrement(Columns: TDBXTableStorage): Boolean;
    procedure InsertValuesFromOldTable(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Columns: TDBXTableStorage; TempTableName: WideString);
    procedure MakeSqlDropTable(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage);
    procedure ReplaceParameter(Buffer: TDBXWideStringBuffer; Start: Integer; Parameter: WideString; Replacement: WideString);
    procedure MakeSqlTableRename(Buffer: TDBXWideStringBuffer; CatalogName: WideString; SchemaName: WideString; TableName: WideString; NewTableName: WideString); overload;
    procedure CopyRow(Source: TDBXRowStorage; Target: TDBXTableStorage; Columns: Integer);
    function Compare(Table: TDBXTableStorage; Start: Integer; Row: TDBXRowStorage; RowStart: Integer; Columns: Integer): Boolean;
    function SameConstraint(Table: TDBXTableStorage; Row: TDBXRowStorage; Columns: Integer): Boolean;
    procedure MapTable(Item: TDBXTableStorage; Table: TDBXRowStorage);
    function MapColumn(Parts: TDBXTableStorage; Table: TDBXRowStorage; ColumnMap: TDBXStringStore; ColIndex: Integer; IdColumns: Integer; DroppedColumn: WideString): WideString;
    procedure CreateConstraints(Buffer: TDBXWideStringBuffer; Columns: TDBXColumnDescriptorArray; Constraints: TDBXTableStorage; ConstraintColumns: TDBXTableStorage; CollectionIndex: Integer; CollectionName: WideString; IdColumns: Integer; ItemColumns: Integer; PartColumns: Integer; Table: TDBXRowStorage; ColumnMap: TDBXStringStore; ColIndex1: Integer; ColIndex2: Integer);
    procedure CreateIndices(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Indexes: TDBXTableStorage; IndexColumns: TDBXTableStorage; ColumnMap: TDBXStringStore);
    procedure CreateForeignKeys(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; ForeignKeyColumns: TDBXTableStorage; ColumnMap: TDBXStringStore);
    procedure MakeSqlCreateSecondaryIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage; IndexColumns: TDBXTableStorage);
    procedure MakeSqlCreateConstraint(Buffer: TDBXWideStringBuffer; Constraint: TDBXRowStorage);
    procedure MakeSqlDropConstraint(Buffer: TDBXWideStringBuffer; Constraint: TDBXRowStorage);
    procedure MakeSqlCreateView(Buffer: TDBXWideStringBuffer; View: TDBXRowStorage; Columns: TDBXTableStorage);
    procedure MakeSqlAlterView(Buffer: TDBXWideStringBuffer; View: TDBXRowStorage; Columns: TDBXTableStorage);
    procedure MakeSqlDropView(Buffer: TDBXWideStringBuffer; View: TDBXRowStorage);
    procedure MakeSqlCreateSynonym(Buffer: TDBXWideStringBuffer; Synonym: TDBXRowStorage; Columns: TDBXTableStorage);
    procedure MakeSqlAlterSynonym(Buffer: TDBXWideStringBuffer; Synonym: TDBXRowStorage; Columns: TDBXTableStorage);
    procedure MakeSqlDropSynonym(Buffer: TDBXWideStringBuffer; Synonym: TDBXRowStorage);
  protected
    FContext: TDBXProviderContext;
    FReader: TDBXBaseMetaDataReader;
    FReservedWords: TDBXTableStorage;
  private
    const Requirement = 1000;
    const Desireable = 100;
    const TieBreaker1 = 1;
    const TieBreaker2 = 2;
    const TieBreaker3 = 4;
    const TieBreaker4 = 8;
    const TieBreaker5 = 16;
    const TieBreaker6 = 32;
  end;

  TDBXSQL = class
  public
    const Add = 'ADD';
    const Alter = 'ALTER';
    const &As = 'AS';
    const Binary = 'BINARY';
    const Cast = 'CAST';
    const Char = 'CHAR';
    const CloseBrace = '}';
    const CloseParen = ')';
    const Colon = ':';
    const Column = 'COLUMN';
    const Comma = ',';
    const Constraint = 'CONSTRAINT';
    const Convert = 'CONVERT';
    const &Create = 'CREATE';
    const CurrentTimestamp = 'CURRENT_TIMESTAMP';
    const Date = 'DATE';
    const Datetime = 'DATETIME';
    const Decimal = 'DECIMAL';
    const Default = 'DEFAULT';
    const Descending = 'DESC';
    const Dot = '.';
    const DoubleQuote = '"';
    const Drop = 'DROP';
    const Empty = '';
    const &For = 'FOR';
    const Foreign = 'FOREIGN';
    const From = 'FROM';
    const &Function = 'FUNCTION';
    const Index = 'INDEX';
    const Insert = 'INSERT';
    const Into = 'INTO';
    const Key = 'KEY';
    const LineComment = '//';
    const Makedate = 'MAKEDATE';
    const Nl = #$a;
    const &Not = 'NOT';
    const Nullable = 'NULL';
    const Off = 'OFF';
    const &On = 'ON';
    const OpenBrace = '{';
    const OpenParen = '(';
    const Position = 'POSITION';
    const Primary = 'PRIMARY';
    const &Procedure = 'PROCEDURE';
    const Quote = '''';
    const References = 'REFERENCES';
    const Rename = 'RENAME';
    const Result = 'RESULT';
    const Returns = 'RETURNS';
    const Select = 'SELECT';
    const Semicolon = ';';
    const &Set = 'SET';
    const Signed = 'SIGNED';
    const Space = ' ';
    const Spacing = '  ';
    const Synonym = 'SYNONYM';
    const Table = 'TABLE';
    const Temp = 'TEMP_';
    const Time = 'TIME';
    const &To = 'TO';
    const &Type = 'TYPE';
    const FYear = 'year';
    const Unique = 'UNIQUE';
    const View = 'VIEW';
  end;

resourcestring
  SCannotBeUsedForAutoIncrement = 'The best type match in %s for the column: %s is %s. But is cannot be used for an auto increment column.';
  SUnknownColumnName = 'The Data type: %s requires a column: %s, which does not exist on the Column collection.';
  SCannotHoldUnicodeChars = 'The best type match in %s for the column: %s is %s. But it cannot hold unicode characters.';
  SCannotHoldWantedPrecision = 'The best type match in %s for the column: %s is %s. But the max precision is: %s which is less than the specified: %s.';
  SCannotRecreateConstraint = 'The constraint: %s could not be recreated, because the column: %s was dropped.';
  SNoSignedTypeFound = 'The best type match in %s for the column: %s is %s. But it is unsigned.';
  STypeNotFound = 'No %2:s type found for the column: %1:s in %0:s.';
  SNoBlobTypeFound = 'No long %2:s type found for the column: %1:s in %0:s.';
  SWrongViewDefinition = 'A view definition must start with the CREATE keyword.';
  SNoTypeWithEnoughPrecision = 'The best type match in %s for the column: %s is %s. But it is does not have sufficient precision.';
  SCannotHoldWantedScale = 'The best type match in %s for the column: %s is %s. But the max scale is: %s which is less than the specified: %s.';
  STypeNameNotFound = 'Data type: %s is not recognized for SQL dialect.';

implementation
uses
  DBXCommon,
  DBXMetaDataError,
  DBXMetaDataNames,
  DBXMetaDataUtil,
  StrUtils;

procedure TDBXBaseMetaDataWriter.Open;
begin
end;

destructor TDBXBaseMetaDataWriter.Destroy;
begin
  FreeAndNil(FReservedWords);
  FreeAndNil(FReader);
  inherited Destroy;
end;

procedure TDBXBaseMetaDataWriter.SetContext(Context: TDBXProviderContext);
begin
  self.FContext := Context;
  if FReader <> nil then
    FReader.Context := Context;
end;

function TDBXBaseMetaDataWriter.GetContext: TDBXProviderContext;
begin
  Result := FContext;
end;

function TDBXBaseMetaDataWriter.GetMetaDataReader: TDBXMetaDataReader;
begin
  Result := FReader;
end;

procedure TDBXBaseMetaDataWriter.MakeSqlCreate(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage; Parts: TDBXTableStorage);
var
  CollectionName: WideString;
begin
  CollectionName := Item.MetaDataCollectionName;
  if (CollectionName = TDBXMetaDataCollectionName.Tables) then
    MakeSqlCreateTable(Buffer, Item, Parts)
  else if (CollectionName = TDBXMetaDataCollectionName.Views) then
    MakeSqlCreateView(Buffer, Item, Parts)
  else if (CollectionName = TDBXMetaDataCollectionName.Synonyms) then
    MakeSqlCreateSynonym(Buffer, Item, Parts)
  else if (CollectionName = TDBXMetaDataCollectionName.Indexes) then
    MakeSqlCreateIndex(Buffer, Item, Parts)
  else if (CollectionName = TDBXMetaDataCollectionName.ForeignKeys) then
    MakeSqlCreateForeignKey(Buffer, Item, Parts)
  else 
    raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlAlter(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage; Parts: TDBXTableStorage);
var
  CollectionName: WideString;
begin
  CollectionName := Item.MetaDataCollectionName;
  if (CollectionName = TDBXMetaDataCollectionName.Tables) then
    MakeSqlAlterTable(Buffer, Item, Parts)
  else if (CollectionName = TDBXMetaDataCollectionName.Views) then
    MakeSqlAlterView(Buffer, Item, Parts)
  else if (CollectionName = TDBXMetaDataCollectionName.Synonyms) then
    MakeSqlAlterSynonym(Buffer, Item, Parts)
  else if (CollectionName = TDBXMetaDataCollectionName.Indexes) then
  begin
    MakeSqlDropIndex(Buffer, Item.OriginalRow);
    MakeSqlCreateIndex(Buffer, Item, Parts);
  end
  else if (CollectionName = TDBXMetaDataCollectionName.ForeignKeys) then
  begin
    MakeSqlDropForeignKey(Buffer, Item.OriginalRow);
    MakeSqlCreateForeignKey(Buffer, Item, Parts);
  end
  else 
    raise Exception.Create(SUnsupportedOperation);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlDrop(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage);
var
  CollectionName: WideString;
begin
  CollectionName := Item.MetaDataCollectionName;
  if (CollectionName = TDBXMetaDataCollectionName.Tables) then
    MakeSqlDropTable(Buffer, Item)
  else if (CollectionName = TDBXMetaDataCollectionName.Views) then
    MakeSqlDropView(Buffer, Item)
  else if (CollectionName = TDBXMetaDataCollectionName.Synonyms) then
    MakeSqlDropSynonym(Buffer, Item)
  else if (CollectionName = TDBXMetaDataCollectionName.Indexes) then
    MakeSqlDropIndex(Buffer, Item)
  else if (CollectionName = TDBXMetaDataCollectionName.ForeignKeys) then
    MakeSqlDropForeignKey(Buffer, Item)
  else 
    raise Exception.Create(SUnsupportedOperation);
end;

function TDBXBaseMetaDataWriter.CheckColumnSupported(Column: TDBXRowStorage): Boolean;
begin
  Result := (not StringIsNil(FindTypeName(Column, nil, False)));
end;

function TDBXBaseMetaDataWriter.IsCatalogsSupported: Boolean;
begin
  Result := False;
end;

function TDBXBaseMetaDataWriter.IsSchemasSupported: Boolean;
begin
  Result := True;
end;

function TDBXBaseMetaDataWriter.IsMultipleStatementsSupported: Boolean;
begin
  Result := False;
end;

function TDBXBaseMetaDataWriter.IsIndexNamesGlobal: Boolean;
begin
  Result := False;
end;

function TDBXBaseMetaDataWriter.IsDescendingIndexConstraintsSupported: Boolean;
begin
  Result := True;
end;

function TDBXBaseMetaDataWriter.IsSerializedIsolationSupported: Boolean;
begin
  Result := True;
end;

function TDBXBaseMetaDataWriter.IsDDLTransactionsSupported: Boolean;
begin
  Result := True;
end;

function TDBXBaseMetaDataWriter.IsMixed_DDL_DML_Supported: Boolean;
begin
  Result := True;
end;

function TDBXBaseMetaDataWriter.GetAlterTableSupport: Integer;
begin
  Result := TDBXAlterTableOperation.NoSupport;
end;

function TDBXBaseMetaDataWriter.GetSqlAutoIncrementKeyword: WideString;
begin
  Result := NullString;
end;

function TDBXBaseMetaDataWriter.GetSqlKeyGeneratedIndexName: WideString;
begin
  Result := NullString;
end;

function TDBXBaseMetaDataWriter.GetSqlQuotedIdentifier(UnquotedIdentifier: WideString): WideString;
begin
  Result := TDBXMetaDataUtil.QuoteIdentifier(UnquotedIdentifier, FReader.SqlIdentifierQuoteChar, FReader.SqlIdentifierQuotePrefix, FReader.SqlIdentifierQuoteSuffix);
end;

function TDBXBaseMetaDataWriter.GetSqlUnQuotedIdentifier(QuotedIdentifier: WideString): WideString;
begin
  Result := TDBXMetaDataUtil.UnquotedIdentifier(QuotedIdentifier, FReader.SqlIdentifierQuoteChar, FReader.SqlIdentifierQuotePrefix, FReader.SqlIdentifierQuoteSuffix);
end;

function TDBXBaseMetaDataWriter.GetSqlAutoIncrementInserts: WideString;
begin
  Result := NullString;
end;

function TDBXBaseMetaDataWriter.GetSqlRenameTable: WideString;
begin
  Result := NullString;
end;

procedure TDBXBaseMetaDataWriter.MakeSqlCreateTable(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Columns: TDBXTableStorage);
var
  Separator: WideString;
  SecondSeparator: WideString;
  CurrentColumns: TDBXTableStorage;
begin
  Buffer.Append(TDBXSQL.&Create);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Table);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlObjectName(Buffer, Table.GetString(TDBXTablesIndex.CatalogName, NullString), Table.GetString(TDBXTablesIndex.SchemaName, NullString), Table.GetString(TDBXTablesIndex.TableName, NullString));
  Buffer.Append(TDBXSQL.OpenParen);
  Separator := TDBXSQL.Nl + TDBXSQL.Spacing;
  SecondSeparator := TDBXSQL.Comma + TDBXSQL.Nl + TDBXSQL.Spacing;
  CurrentColumns := Columns.GetCurrentRows(TDBXColumnsColumns.Ordinal);
  CurrentColumns.BeforeFirst;
  while CurrentColumns.Next do
  begin
    Buffer.Append(Separator);
    MakeSqlColumnDefinition(Buffer, CurrentColumns);
    Separator := SecondSeparator;
  end;
  FreeAndNil(CurrentColumns);
  Buffer.Append(TDBXSQL.CloseParen);
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlAlterTable(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Columns: TDBXTableStorage);
var
  Original: TDBXRowStorage;
  CatalogName: WideString;
  SchemaName: WideString;
  TableName: WideString;
  ColumnMap: TDBXStringStore;
  Defaults: TDBXTableStorage;
  ForeignKeyColumns: TDBXTableStorage;
  Indexes: TDBXTableStorage;
  IndexColumns: TDBXTableStorage;
  UseTransaction: Boolean;
  FullAlterTable: Boolean;
  Marker: Integer;
begin
  Original := Table.OriginalRow;
  CatalogName := Original.GetString(TDBXTablesIndex.CatalogName, NullString);
  SchemaName := Original.GetString(TDBXTablesIndex.SchemaName, NullString);
  TableName := Original.GetString(TDBXTablesIndex.TableName, NullString);
  ColumnMap := ComputeColumnMap(Columns);
  Defaults := GetDefaults(CatalogName, SchemaName, TableName);
  ForeignKeyColumns := GetForeignKeyColumns(CatalogName, SchemaName, TableName);
  UseTransaction := SerializedIsolationSupported;
  if UseTransaction then
    FContext.StartSerializedTransaction;
  try
    Indexes := GetIndexes(CatalogName, SchemaName, TableName);
    IndexColumns := GetIndexColumns(CatalogName, SchemaName, TableName);
    if UseTransaction then
      FContext.Commit;
    UseTransaction := False;
  finally
    if UseTransaction then
      FContext.Rollback;
  end;
  RemoveForeignKeyGeneratedIndexes(Table, Indexes, IndexColumns, ForeignKeyColumns);
  DropAllConstraints(Buffer, Defaults, Indexes, ForeignKeyColumns);
  Buffer.Append(TDBXSQL.Nl);
  FullAlterTable := (AlterTableSupport <> TDBXAlterTableOperation.NoSupport);
  if FullAlterTable then
  begin
    Marker := Buffer.Length;
    FullAlterTable := MakeSqlFullAlterTable(Buffer, Table, Columns);
    if not FullAlterTable then
      Buffer.Length := Marker;
  end;
  if not FullAlterTable then
    MakeSqlTableReplacement(Buffer, Table, Columns);
  Buffer.Append(TDBXSQL.Nl);
  CreateIndices(Buffer, Table, Indexes, IndexColumns, ColumnMap);
  CreateForeignKeys(Buffer, Table, ForeignKeyColumns, ColumnMap);
  FreeAndNil(Indexes);
  FreeAndNil(IndexColumns);
  FreeAndNil(Defaults);
  FreeAndNil(ForeignKeyColumns);
  FreeAndNil(ColumnMap);
end;

function TDBXBaseMetaDataWriter.SupportedTableAlteration(Operation: Integer): Boolean;
var
  Support: Integer;
begin
  Support := AlterTableSupport;
  Result := ((Support and Operation) = Operation);
end;

function TDBXBaseMetaDataWriter.MakeSqlFullAlterTable(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Columns: TDBXTableStorage): Boolean;
var
  MarkerA: Integer;
  MarkerB: Integer;
  &Inline: Boolean;
  OriginalTable: TDBXRowStorage;
  ExternalStatements: TDBXWideStringBuffer;
  MarkerAlterTableStart: Integer;
  MarkerAlterTableFirst: Integer;
  Separator: WideString;
  SecondSeparator: WideString;
  Deleted: TDBXTableStorage;
  Inserted: TDBXTableStorage;
  Modified: TDBXTableStorage;
  MarkerChangeColumnStart: Integer;
  Original: TDBXRowStorage;
  MarkerChangeColumnFirstChange: Integer;
  DefaultValue: WideString;
  AutoIncrementWord: WideString;
begin
  OriginalTable := Table.OriginalRow;
  ExternalStatements := nil;
  MarkerAlterTableStart := Buffer.Length;
  MakeSqlAlterTablePrefix(Buffer, OriginalTable);
  MarkerAlterTableFirst := Buffer.Length;
  Separator := TDBXSQL.Nl + TDBXSQL.Spacing;
  SecondSeparator := TDBXSQL.Comma + TDBXSQL.Nl + TDBXSQL.Spacing;
  Deleted := Columns.DeletedRows;
  Deleted.BeforeFirst;
  while Deleted.Next do
  begin
    if not SupportedTableAlteration(TDBXAlterTableOperation.DropColumn) then
    begin
      Result := False;
      exit;
    end;
    Buffer.Append(Separator);
    Buffer.Append(TDBXSQL.Drop);
//      buffer.append(SQL.SPACE);    Not supported by Interbase
//      buffer.append(SQL.COLUMN);
    Buffer.Append(TDBXSQL.Space);
    MakeSqlIdentifier(Buffer, Deleted.GetString(TDBXColumnsIndex.ColumnName, NullString));
    Separator := SecondSeparator;
  end;
  Deleted.Close;
  Inserted := Columns.InsertedRows;
  Inserted.BeforeFirst;
  while Inserted.Next do
  begin
    if not SupportedTableAlteration(TDBXAlterTableOperation.AddColumn) then
    begin
      Result := False;
      exit;
    end;
    Buffer.Append(Separator);
    Buffer.Append(TDBXSQL.Add);
//      buffer.append(SQL.SPACE);   Not supported by Interbase
//      buffer.append(SQL.COLUMN);
    Buffer.Append(TDBXSQL.Space);
    MakeSqlColumnDefinition(Buffer, Inserted);
    if not Inserted.IsNull(TDBXColumnsIndex.Ordinal) then
    begin
      if not SupportedTableAlteration(TDBXAlterTableOperation.AddColumnWithPosition) then
      begin
        Result := False;
        exit;
      end;
      Buffer.Append(TDBXSQL.Space);
      Buffer.Append(TDBXSQL.Position);
      Buffer.Append(TDBXSQL.Space);
      Buffer.Append(Inserted.GetInt32(TDBXColumnsIndex.Ordinal));
    end;
    Separator := SecondSeparator;
  end;
  Inserted.Close;
  Modified := Columns.ModifiedRows;
  Modified.BeforeFirst;
  while Modified.Next do
  begin
    MarkerChangeColumnStart := Buffer.Length;
    Buffer.Append(Separator);
    Buffer.Append(TDBXSQL.Alter);
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(TDBXSQL.Column);
    Buffer.Append(TDBXSQL.Space);
    Original := Modified.OriginalRow;
    MakeSqlIdentifier(Buffer, Original.GetString(TDBXColumnsIndex.ColumnName));
    MarkerChangeColumnFirstChange := Buffer.Length;
    if not (Modified.EqualTo(TDBXColumnsIndex.TypeName, Original, TDBXColumnsIndex.TypeName) and Modified.EqualTo(TDBXColumnsIndex.Precision, Original, TDBXColumnsIndex.Precision) and Modified.EqualTo(TDBXColumnsIndex.Scale, Original, TDBXColumnsIndex.Scale)) then
    begin
      if not SupportedTableAlteration(TDBXAlterTableOperation.ChangeColumnType) then
      begin
        Result := False;
        exit;
      end;
      Buffer.Append(TDBXSQL.Space);
      Buffer.Append(TDBXSQL.&Type);
      Buffer.Append(TDBXSQL.Space);
      MakeSqlDataType(Buffer, Modified.GetString(TDBXColumnsIndex.TypeName), Modified);
    end;
    if not Modified.EqualTo(TDBXColumnsIndex.DefaultValue, Original, TDBXColumnsIndex.DefaultValue) then
    begin
      DefaultValue := Modified.GetString(TDBXColumnsIndex.DefaultValue, NullString);
      if (StringIsNil(DefaultValue)) or (Length(DefaultValue) = 0) then
      begin
        if not SupportedTableAlteration(TDBXAlterTableOperation.DropDefaultValue) then
        begin
          Result := False;
          exit;
        end;
        Buffer.Append(TDBXSQL.Space);
        Buffer.Append(TDBXSQL.Drop);
        Buffer.Append(TDBXSQL.Space);
        Buffer.Append(TDBXSQL.Default);
      end
      else 
      begin
        if not SupportedTableAlteration(TDBXAlterTableOperation.ChangeDefaultValue) then
        begin
          Result := False;
          exit;
        end;
        Buffer.Append(TDBXSQL.Space);
        Buffer.Append(TDBXSQL.&Set);
        Buffer.Append(TDBXSQL.Space);
        MakeSqlDefaultValue(Buffer, DefaultValue, Modified.GetString(TDBXColumnsIndex.TypeName, NullString));
      end;
    end;
    if not Modified.EqualTo(TDBXColumnsIndex.IsNullable, Original, TDBXColumnsIndex.IsNullable) then
    begin
      if not Modified.GetBoolean(TDBXColumnsIndex.IsNullable, True) then
      begin
        if not SupportedTableAlteration(TDBXAlterTableOperation.DropNullable) then
        begin
          Result := False;
          exit;
        end;
        Buffer.Append(TDBXSQL.Space);
        Buffer.Append(TDBXSQL.&Not);
        Buffer.Append(TDBXSQL.Space);
        Buffer.Append(TDBXSQL.Nullable);
      end
      else 
      begin
        if not SupportedTableAlteration(TDBXAlterTableOperation.SetNullable) then
        begin
          Result := False;
          exit;
        end;
        Buffer.Append(TDBXSQL.Space);
        Buffer.Append(TDBXSQL.Nullable);
      end;
    end;
    if not Modified.EqualTo(TDBXColumnsIndex.IsAutoIncrement, Original, TDBXColumnsIndex.IsAutoIncrement) then
    begin
      AutoIncrementWord := SqlAutoIncrementKeyword;
      if (not StringIsNil(AutoIncrementWord)) and (Length(AutoIncrementWord) > 0) then
      begin
        if Modified.GetBoolean(TDBXColumnsIndex.IsAutoIncrement, False) then
        begin
          if not SupportedTableAlteration(TDBXAlterTableOperation.AddAutoincrement) then
          begin
            Result := False;
            exit;
          end;
          Buffer.Append(TDBXSQL.Space);
          Buffer.Append(AutoIncrementWord);
        end
        else 
        begin
          if not SupportedTableAlteration(TDBXAlterTableOperation.DropAutoincrement) then
          begin
            Result := False;
            exit;
          end;
          Buffer.Append(TDBXSQL.Space);
          Buffer.Append(TDBXSQL.Drop);
          Buffer.Append(TDBXSQL.Space);
          Buffer.Append(AutoIncrementWord);
        end;
      end;
    end;
    if not Modified.EqualTo(TDBXColumnsIndex.Ordinal, Original, TDBXColumnsIndex.Ordinal) then
    begin
      if not SupportedTableAlteration(TDBXAlterTableOperation.ChangeColumnPosition) then
      begin
        Result := False;
        exit;
      end;
      Buffer.Append(TDBXSQL.Space);
      Buffer.Append(TDBXSQL.Position);
      Buffer.Append(TDBXSQL.Space);
      Buffer.Append(Modified.GetInt32(TDBXColumnsIndex.Ordinal));
    end;
    if not Modified.EqualTo(TDBXColumnsIndex.ColumnName, Original, TDBXColumnsIndex.ColumnName) then
    begin
      if not SupportedTableAlteration(TDBXAlterTableOperation.RenameColumn) then
      begin
        Result := False;
        exit;
      end;
      MarkerA := Buffer.Length;
      Buffer.Append(TDBXSQL.Space);
      MarkerB := Buffer.Length;
      &Inline := MakeSqlColumnRename(Buffer, Modified.GetString(TDBXColumnsIndex.ColumnName, NullString), OriginalTable.GetString(TDBXTablesIndex.CatalogName, NullString), OriginalTable.GetString(TDBXTablesIndex.SchemaName, NullString), OriginalTable.GetString(TDBXTablesIndex.TableName, NullString), Original.GetString(TDBXColumnsIndex.ColumnName, NullString));
      if not &Inline then
      begin
        ExternalStatements := AddToExternalStatements(ExternalStatements, Buffer, MarkerB);
        Buffer.Length := MarkerA;
      end;
    end;
    if MarkerChangeColumnFirstChange = Buffer.Length then
      Buffer.Length := MarkerChangeColumnStart
    else 
      Separator := SecondSeparator;
  end;
  Modified.Close;
  if not (Table.EqualTo(TDBXTablesIndex.CatalogName, OriginalTable, TDBXTablesIndex.CatalogName) and Table.EqualTo(TDBXTablesIndex.SchemaName, OriginalTable, TDBXTablesIndex.SchemaName) and Table.EqualTo(TDBXTablesIndex.TableName, OriginalTable, TDBXTablesIndex.TableName)) then
  begin
    if not SupportedTableAlteration(TDBXAlterTableOperation.RenameTable) and not SupportedTableAlteration(TDBXAlterTableOperation.RenameTableTo) then
    begin
      Result := False;
      exit;
    end;
    MarkerA := Buffer.Length;
    Buffer.Append(Separator);
    MarkerB := Buffer.Length;
    &Inline := MakeSqlTableRename(Buffer, Table.GetString(TDBXTablesIndex.CatalogName, NullString), Table.GetString(TDBXTablesIndex.SchemaName, NullString), Table.GetString(TDBXTablesIndex.TableName, NullString), OriginalTable.GetString(TDBXTablesIndex.CatalogName, NullString), OriginalTable.GetString(TDBXTablesIndex.SchemaName, NullString), OriginalTable.GetString(TDBXTablesIndex.TableName, NullString));
    if &Inline then
      Separator := SecondSeparator
    else 
    begin
      ExternalStatements := AddToExternalStatements(ExternalStatements, Buffer, MarkerB);
      Buffer.Length := MarkerA;
    end;
  end;
  if MarkerAlterTableFirst = Buffer.Length then
    Buffer.Length := MarkerAlterTableStart;
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
  if ExternalStatements <> nil then
    Buffer.Append(ExternalStatements);
  Result := True;
end;

function TDBXBaseMetaDataWriter.MakeSqlTableRename(Buffer: TDBXWideStringBuffer; CatalogName: WideString; SchemaName: WideString; TableName: WideString; OldCatalogName: WideString; OldSchemaName: WideString; OldTableName: WideString): Boolean;
begin
  Buffer.Append(TDBXSQL.Rename);
  if SupportedTableAlteration(TDBXAlterTableOperation.RenameTableTo) then
  begin
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(TDBXSQL.&To);
  end;
  Buffer.Append(TDBXSQL.Space);
  MakeSqlObjectName(Buffer, CatalogName, SchemaName, TableName);
  Result := True;
end;

function TDBXBaseMetaDataWriter.MakeSqlColumnRename(Buffer: TDBXWideStringBuffer; ColumnName: WideString; CatalogName: WideString; SchemaName: WideString; TableName: WideString; OldColumnName: WideString): Boolean;
begin
  Buffer.Append(TDBXSQL.&To);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlIdentifier(Buffer, ColumnName);
  Result := True;
end;

procedure TDBXBaseMetaDataWriter.MakeSqlObjectName(Buffer: TDBXWideStringBuffer; CatalogName: WideString; SchemaName: WideString; ObjectName: WideString);
var
  Dot: WideString;
begin
  Dot := TDBXSQL.Empty;
  if (not StringIsNil(CatalogName)) and CatalogsSupported then
  begin
    MakeSqlIdentifier(Buffer, CatalogName);
    Dot := TDBXSQL.Dot;
  end;
  if (not StringIsNil(SchemaName)) and SchemasSupported then
  begin
    Buffer.Append(Dot);
    MakeSqlIdentifier(Buffer, SchemaName);
    Dot := TDBXSQL.Dot;
  end;
  Buffer.Append(Dot);
  MakeSqlIdentifier(Buffer, ObjectName);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlIdentifier(Buffer: TDBXWideStringBuffer; Identifier: WideString);
begin
  if FReader.QuotedIdentifiersSupported then
  begin
    if not IsValidSqlIdentifier(Identifier) or IsReservedWord(Identifier) then
      Identifier := GetSqlQuotedIdentifier(Identifier);
  end;
  Buffer.Append(Identifier);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlColumnDefinition(Buffer: TDBXWideStringBuffer; Column: TDBXRowStorage);
var
  AutoIncrementWord: WideString;
begin
  MakeSqlIdentifier(Buffer, Column.GetString(TDBXColumnsIndex.ColumnName, NullString));
  Buffer.Append(TDBXSQL.Space);
  MakeSqlDataType(Buffer, Column.GetString(TDBXColumnsIndex.TypeName, NullString), Column);
  MakeSqlDefaultValue(Buffer, Column.GetString(TDBXColumnsIndex.DefaultValue, NullString), Column.GetString(TDBXColumnsIndex.TypeName, NullString));
  if Column.GetBoolean(TDBXColumnsIndex.IsAutoIncrement, False) then
  begin
    AutoIncrementWord := SqlAutoIncrementKeyword;
    if (not StringIsNil(AutoIncrementWord)) and (Length(AutoIncrementWord) > 0) then
    begin
      Buffer.Append(TDBXSQL.Space);
      Buffer.Append(AutoIncrementWord);
    end;
  end;
  MakeSqlNullable(Buffer, Column);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlNullable(Buffer: TDBXWideStringBuffer; Column: TDBXRowStorage);
begin
  if not Column.GetBoolean(TDBXColumnsIndex.IsNullable, True) then
  begin
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(TDBXSQL.&Not);
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(TDBXSQL.Nullable);
  end;
end;

procedure TDBXBaseMetaDataWriter.MakeSqlDefaultValue(Buffer: TDBXWideStringBuffer; DefaultValue: WideString; TypeName: WideString);
begin
  if (not StringIsNil(DefaultValue)) and (Length(DefaultValue) > 0) then
  begin
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(TDBXSQL.Default);
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(DefaultValue);
  end;
end;

function TDBXBaseMetaDataWriter.RemoveMarkersForNullValues(Format: WideString; Values: TDBXWideStringArray): WideString;
var
  Found: Integer;
  SearchFor: WideString;
  Index: Integer;
begin
  SearchFor := NullString;
  for index := Length(Values) - 1 downto 1 do
  begin
    if StringIsNil(Values[Index]) then
    begin
      SearchFor := TDBXSQL.Comma + TDBXSQL.OpenBrace + IntToStr(Index) + TDBXSQL.CloseBrace;
      Found := StringIndexOf(Format,SearchFor);
      if Found > 0 then
        Format := Copy(Format,0+1,Found-(0)) + Copy(Format,Found + Length(SearchFor)+1,Length(Format)-(Found + Length(SearchFor)));
    end;
    break;
  end;
  if StringIsNil(Values[0]) then
  begin
    SearchFor := TDBXSQL.OpenParen + TDBXSQL.OpenBrace + IntToStr(0) + TDBXSQL.CloseBrace + TDBXSQL.CloseParen;
    Found := StringIndexOf(Format,SearchFor);
    if Found > 0 then
      Format := Copy(Format,0+1,Found-(0)) + Copy(Format,Found + Length(SearchFor)+1,Length(Format)-(Found + Length(SearchFor)));
  end;
  Result := Format;
end;

procedure TDBXBaseMetaDataWriter.MakeSqlDataType(Buffer: TDBXWideStringBuffer; TypeName: WideString; ColumnRow: TDBXRowStorage);
var
  Overrides: TDBXInt32s;
  DataType: TDBXDataTypeDescription;
begin
  SetLength(Overrides,2);
  Overrides[0] := -1;
  Overrides[1] := -1;
  DataType := FindDataType(TypeName, ColumnRow, Overrides);
  MakeSqlDataType(Buffer, DataType, ColumnRow, Overrides);
  Overrides := nil;
end;

procedure TDBXBaseMetaDataWriter.MakeSqlDataType(Buffer: TDBXWideStringBuffer; DataType: TDBXDataTypeDescription; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s);
var
  FormattedType: WideString;
  Params: WideString;
  FormatString: WideString;
  ParameterCount: Integer;
  Tokenizer: TDBXTokenizer;
  Values: TDBXWideStringArray;
  ParameterIndex: Integer;
  ColumnName: WideString;
  Index: Integer;
  Override: Integer;
begin
  FormattedType := NullString;
  Params := DataType.CreateParameters;
  FormatString := DataType.CreateFormat;
  if (StringIsNil(Params)) or (Length(Params) = 0) then
    FormattedType := FormatString
  else 
  begin
    ParameterCount := 0;
    Tokenizer := TDBXTokenizer.Create(Params, TDBXSQL.Comma + TDBXSQL.Space);
    while Tokenizer.HasMoreTokens do
    begin
      Tokenizer.NextToken;
      ParameterCount := ParameterCount + 1;
    end;
    SetLength(Values,ParameterCount);
    Tokenizer.Free;
    Tokenizer := TDBXTokenizer.Create(Params, TDBXSQL.Comma + TDBXSQL.Space);
    ParameterIndex := 0;
    while Tokenizer.HasMoreTokens do
    begin
      ColumnName := Tokenizer.NextToken;
      Index := ColumnRow.FindOrdinal(ColumnName);
      if Index < 0 then
        raise TDBXMetaDataError.Create(Format(SUnknownColumnName, [DataType.TypeName,ColumnName]));
      Override := -1;
      case Index of
        TDBXColumnsIndex.Precision:
          Override := Overrides[0];
        TDBXColumnsIndex.Scale:
          Override := Overrides[1];
      end;
      if Override < 0 then
        Values[ParameterIndex] := ColumnRow.GetAsString(Index)
      else 
        Values[ParameterIndex] := IntToStr(Override);
      ParameterIndex := ParameterIndex + 1;
    end;
    Tokenizer.Free;
    FormatString := RemoveMarkersForNullValues(FormatString, Values);
    FormattedType := FormatMessage(FormatString,Values);
  end;
  Buffer.Append(FormattedType);
end;

function TDBXBaseMetaDataWriter.ErrorTypeNameNotFound(ColumnRow: TDBXRowStorage): Exception;
var
  Product: WideString;
  ColumnName: WideString;
  ColumnType: Integer;
  IsUnsigned: Boolean;
begin
  Product := FReader.ProductName;
  ColumnName := ColumnRow.GetString(TDBXColumnsIndex.ColumnName, '');
  ColumnType := ColumnRow.GetInt32(TDBXColumnsIndex.DbxDataType);
  IsUnsigned := ColumnRow.GetBoolean(TDBXColumnsIndex.IsUnsigned);
  Result := TDBXMetaDataError.Create(Format(STypeNotFound, [Product,ColumnName,FContext.GetPlatformTypeName(ColumnType, IsUnsigned)]));
end;

function TDBXBaseMetaDataWriter.FindDataType(TypeName: WideString; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s): TDBXDataTypeDescription;
var
  DataTypes: TDBXObjectStore;
  DataType: TDBXDataTypeDescription;
begin
  if StringIsNil(TypeName) then
    TypeName := FindTypeName(ColumnRow, Overrides, True);
  if StringIsNil(TypeName) then
    raise ErrorTypeNameNotFound(ColumnRow);
  DataTypes := FReader.DataTypeHash;
  DataType := TDBXDataTypeDescription(DataTypes[TypeName]);
  if DataType = nil then
    raise TDBXMetaDataError.Create(Format(STypeNameNotFound, [TypeName]));
  Result := DataType;
end;

function TDBXBaseMetaDataWriter.FindTypeName(ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s; FailIfNotFound: Boolean): WideString;
var
  ColumnType: Integer;
begin
  ColumnType := ColumnRow.GetInt32(TDBXColumnsIndex.DbxDataType);
  case ColumnType of
    TDBXDataTypes.AnsiStringType,
    TDBXDataTypes.WideStringType:
      Result := FindStringOrBinaryTypeName(ColumnRow, FailIfNotFound);
    TDBXDataTypesEx.Int8Type,
    TDBXDataTypes.Int16Type,
    TDBXDataTypes.Int32Type,
    TDBXDataTypes.Int64Type,
    TDBXDataTypesEx.UInt8Type,
    TDBXDataTypes.UInt16Type,
    TDBXDataTypes.UInt32Type,
    TDBXDataTypes.UInt64Type:
      Result := FindIntegerTypeName(ColumnRow, Overrides, FailIfNotFound);
    TDBXDataTypes.BcdType:
      Result := FindDecimalTypeName(ColumnRow, FailIfNotFound);
    TDBXDataTypesEx.SingleType,
    TDBXDataTypes.DoubleType:
      Result := FindFloatTypeName(ColumnRow, Overrides, FailIfNotFound);
    TDBXDataTypes.DateType,
    TDBXDataTypes.TimeType,
    TDBXDataTypes.TimestampType:
      Result := FindDateTimeTypeName(ColumnRow, FailIfNotFound);
    TDBXDataTypes.BlobType,
    TDBXDataTypes.BytesType,
    TDBXDataTypes.VarbytesType:
      Result := FindStringOrBinaryTypeName(ColumnRow, FailIfNotFound);
    TDBXDataTypes.BooleanType:
      Result := FindBooleanTypeName(ColumnRow, Overrides, FailIfNotFound);
    TDBXDataTypesEx.ObjectType:
      Result := FindSimpleColumnTypeMatch(ColumnRow, FailIfNotFound);
    else
      Result := NullString;
  end;
end;

function TDBXBaseMetaDataWriter.FindSimpleColumnTypeMatch(ColumnRow: TDBXRowStorage; FailIfNotFound: Boolean): WideString;
var
  WantedColumnType: Integer;
  BestScore: Integer;
  BestTypeName: WideString;
  DataTypes: TDBXArrayList;
  Index: Integer;
  DataType: TDBXDataTypeDescription;
  Score: Integer;
  Product: WideString;
  ColumnName: WideString;
begin
  WantedColumnType := ColumnRow.GetInt32(TDBXColumnsIndex.DbxDataType);
  BestScore := -1;
  BestTypeName := NullString;
  DataTypes := FReader.DataTypes;
  for index := 0 to DataTypes.Count - 1 do
  begin
    DataType := TDBXDataTypeDescription(DataTypes[Index]);
    Score := 0;
    if DataType.DbxDataType = WantedColumnType then
    begin
      Score := Score + Requirement;
      if DataType.BestMatch then
        Score := Score + TieBreaker1;
      if Score > BestScore then
      begin
        BestScore := Score;
        BestTypeName := DataType.TypeName;
      end;
    end;
  end;
  if BestScore >= Requirement then
  begin
    Result := BestTypeName;
    exit;
  end
  else if not FailIfNotFound then
  begin
    Result := NullString;
    exit;
  end;
  Product := FReader.ProductName;
  ColumnName := ColumnRow.GetString(TDBXColumnsIndex.ColumnName, '');
  raise TDBXMetaDataError.Create(Format(STypeNotFound, [Product,ColumnName,FContext.GetPlatformTypeName(WantedColumnType, False)]));
end;

function TDBXBaseMetaDataWriter.FindBooleanTypeName(ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s; FailIfNotFound: Boolean): WideString;
var
  BestScore: Integer;
  BestTypeName: WideString;
  DataTypes: TDBXArrayList;
  Index: Integer;
  DataType: TDBXDataTypeDescription;
  ActualColumnType: Integer;
  Score: Integer;
  Product: WideString;
  ColumnName: WideString;
begin
  BestScore := -1;
  BestTypeName := NullString;
  DataTypes := FReader.DataTypes;
  for index := 0 to DataTypes.Count - 1 do
  begin
    DataType := TDBXDataTypeDescription(DataTypes[Index]);
    ActualColumnType := DataType.DbxDataType;
    Score := -1;
    case ActualColumnType of
      TDBXDataTypes.BooleanType:
        begin
          Result := DataType.TypeName;
          exit;
        end;
      TDBXDataTypes.AnsiStringType:
        Score := 2 * Desireable;
      TDBXDataTypes.WideStringType:
        Score := Desireable;
    end;
    if (Score > 0) and ColumnRow.GetBoolean(TDBXColumnsIndex.IsFixedLength) then
      Score := Score + TieBreaker1;
    if Score > BestScore then
    begin
      BestScore := Score;
      BestTypeName := DataType.TypeName;
    end;
  end;
  if BestScore > 0 then
  begin
    Overrides[0] := 1;
    begin
      Result := BestTypeName;
      exit;
    end;
  end
  else if not FailIfNotFound then
  begin
    Result := NullString;
    exit;
  end;
  Product := FReader.ProductName;
  ColumnName := ColumnRow.GetString(TDBXColumnsIndex.ColumnName, '');
  raise TDBXMetaDataError.Create(Format(STypeNotFound, [Product,ColumnName,FContext.GetPlatformTypeName(TDBXDataTypes.BooleanType, False)]));
end;

function TDBXBaseMetaDataWriter.FindStringOrBinaryTypeName(ColumnRow: TDBXRowStorage; FailIfNotFound: Boolean): WideString;
var
  WantedColumnType: Integer;
  WantedStringType: Boolean;
  UnicodeRequired: Boolean;
  UnicodeNotDesired: Boolean;
  BlobRequired: Boolean;
  BlobForbidden: Boolean;
  FixedLengthDesired: Boolean;
  VariableLengthDesired: Boolean;
  PrecisionRequired: Integer;
  BestScore: Integer;
  BestTypeName: WideString;
  BestColumnSize: Int64;
  BestIsUnicode: Boolean;
  DataTypes: TDBXArrayList;
  Index: Integer;
  DataType: TDBXDataTypeDescription;
  ActualColumnType: Integer;
  ActualStringType: Boolean;
  Score: Integer;
  Product: WideString;
  ColumnName: WideString;
begin
  WantedColumnType := ColumnRow.GetInt32(TDBXColumnsIndex.DbxDataType);
  WantedStringType := ((WantedColumnType = TDBXDataTypes.AnsiStringType) or (WantedColumnType = TDBXDataTypes.WideStringType));
  UnicodeRequired := ColumnRow.GetBoolean(TDBXColumnsIndex.IsUnicode, False);
  UnicodeNotDesired := not ColumnRow.GetBoolean(TDBXColumnsIndex.IsUnicode, True);
  BlobRequired := ColumnRow.GetBoolean(TDBXColumnsIndex.IsLong, False);
  BlobForbidden := not ColumnRow.GetBoolean(TDBXColumnsIndex.IsLong, True);
  FixedLengthDesired := ColumnRow.GetBoolean(TDBXColumnsIndex.IsFixedLength, False);
  VariableLengthDesired := not ColumnRow.GetBoolean(TDBXColumnsIndex.IsFixedLength, True);
  PrecisionRequired := ColumnRow.GetInt32(TDBXColumnsIndex.Precision, -1);
  if not WantedStringType then
  begin
    UnicodeRequired := False;
    UnicodeNotDesired := False;
  end;
  BestScore := -1;
  BestTypeName := NullString;
  BestColumnSize := -1;
  BestIsUnicode := False;
  DataTypes := FReader.DataTypes;
  for index := 0 to DataTypes.Count - 1 do
  begin
    DataType := TDBXDataTypeDescription(DataTypes[Index]);
    ActualColumnType := DataType.DbxDataType;
    ActualStringType := ((ActualColumnType = TDBXDataTypes.AnsiStringType) or (ActualColumnType = TDBXDataTypes.WideStringType));
    case ActualColumnType of
      TDBXDataTypes.BlobType,
      TDBXDataTypes.BytesType,
      TDBXDataTypes.VarbytesType,
      TDBXDataTypes.AnsiStringType,
      TDBXDataTypes.WideStringType:
        if (WantedStringType = ActualStringType) or (WantedStringType and DataType.StringOptionSupported) then
        begin
          Score := 0;
          if DataType.ColumnSize >= PrecisionRequired then
            Score := Score + Requirement;
          if DataType.Unicode or DataType.UnicodeOptionSupported or not UnicodeRequired then
            Score := Score + Requirement;
          if DataType.Long or DataType.LongOptionSupported or not BlobRequired then
            Score := Score + Requirement;
          if not DataType.Long or not BlobForbidden then
            Score := Score + Requirement;
          if DataType.FixedLength and FixedLengthDesired then
            Score := Score + Desireable;
          if not DataType.Unicode or not UnicodeNotDesired then
            Score := Score + Desireable;
          if not DataType.FixedLength and VariableLengthDesired then
            Score := Score + Desireable;
          if not DataType.Long then
            Score := Score + TieBreaker5;
          if DataType.Unicode then
            Score := Score + TieBreaker4;
          if not DataType.FixedLength then
            Score := Score + TieBreaker3;
          if DataType.BestMatch then
            Score := Score + TieBreaker2;
          if DataType.ColumnSize < BestColumnSize then
            Score := Score + TieBreaker1;
          if Score > BestScore then
          begin
            BestScore := Score;
            BestTypeName := DataType.TypeName;
            BestColumnSize := DataType.ColumnSize;
            BestIsUnicode := DataType.Unicode;
          end;
        end;
    end;
  end;
  if BestScore >= 4 * Requirement then
  begin
    Result := BestTypeName;
    exit;
  end
  else if not FailIfNotFound then
  begin
    Result := NullString;
    exit;
  end;
  Product := FReader.ProductName;
  ColumnName := ColumnRow.GetString(TDBXColumnsIndex.ColumnName, '');
  if BestScore < 0 then
    raise TDBXMetaDataError.Create(Format(STypeNotFound, [Product,ColumnName,FContext.GetPlatformTypeName(WantedColumnType, False)]));
  if BestColumnSize < PrecisionRequired then
    raise TDBXMetaDataError.Create(Format(SCannotHoldWantedPrecision, [Product,ColumnName,BestTypeName,IntToStr(BestColumnSize),IntToStr(PrecisionRequired)]));
  if not BestIsUnicode and UnicodeRequired then
    raise TDBXMetaDataError.Create(Format(SCannotHoldUnicodeChars, [Product,ColumnName,BestTypeName]));
  if BlobRequired then
    raise TDBXMetaDataError.Create(Format(SNoBlobTypeFound, [Product,ColumnName,FContext.GetPlatformTypeName(WantedColumnType, False)]))
  else 
    raise TDBXMetaDataError.Create(Format(STypeNotFound, [Product,ColumnName,FContext.GetPlatformTypeName(WantedColumnType, False)]));
end;

function TDBXBaseMetaDataWriter.CalcPrecisionColumnType(ColumnType: Integer; UnsignedOption: Boolean): Integer;
begin
  if not UnsignedOption then
  begin
    Result := ColumnType;
    exit;
  end;
  case ColumnType of
    TDBXDataTypesEx.Int8Type:
      Result := TDBXDataTypesEx.UInt8Type;
    TDBXDataTypes.Int16Type:
      Result := TDBXDataTypes.UInt16Type;
    TDBXDataTypes.Int32Type:
      Result := TDBXDataTypes.UInt32Type;
    TDBXDataTypes.Int64Type:
      Result := TDBXDataTypes.UInt64Type;
    else
      Result := ColumnType;
  end;
end;

function TDBXBaseMetaDataWriter.CalcDecimalPrecision(ColumnType: Integer): Integer;
begin
  case ColumnType of
    TDBXDataTypesEx.Int8Type,
    TDBXDataTypesEx.UInt8Type:
      Result := 3;
    TDBXDataTypes.Int16Type,
    TDBXDataTypes.UInt16Type:
      Result := 5;
    TDBXDataTypes.Int32Type,
    TDBXDataTypes.UInt32Type:
      Result := 10;
    TDBXDataTypes.Int64Type:
      Result := 19;
    TDBXDataTypes.UInt64Type:
      Result := 20;
    else
      Result := 0;
  end;
end;

function TDBXBaseMetaDataWriter.CalcBinaryPrecision(ColumnType: Integer): Integer;
begin
  case ColumnType of
    TDBXDataTypesEx.Int8Type:
      Result := 7;
    TDBXDataTypesEx.UInt8Type:
      Result := 8;
    TDBXDataTypes.Int16Type:
      Result := 15;
    TDBXDataTypes.UInt16Type:
      Result := 16;
    TDBXDataTypes.Int32Type:
      Result := 31;
    TDBXDataTypes.UInt32Type:
      Result := 32;
    TDBXDataTypes.Int64Type:
      Result := 63;
    TDBXDataTypes.UInt64Type:
      Result := 64;
    else
      Result := 0;
  end;
end;

function TDBXBaseMetaDataWriter.IsSignedInteger(ColumnType: Integer): Boolean;
begin
  case ColumnType of
    TDBXDataTypesEx.Int8Type,
    TDBXDataTypes.Int16Type,
    TDBXDataTypes.Int32Type,
    TDBXDataTypes.Int64Type:
      Result := True;
    else
      Result := False;
  end;
end;

function TDBXBaseMetaDataWriter.FindIntegerTypeName(ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s; FailIfNotFound: Boolean): WideString;
var
  ColumnType: Integer;
  RequiredBinaryPrecision: Integer;
  RequiredDecimalPrecision: Integer;
  SignedRequired: Boolean;
  AutoIncrementRequired: Boolean;
  BestScore: Integer;
  BestType: Integer;
  BestTypeName: WideString;
  BestIsAutoIncrementable: Boolean;
  BestIsSigned: Boolean;
  DataTypes: TDBXArrayList;
  Score: Integer;
  ActualColumnType: Integer;
  ActualBinaryPrecision: Integer;
  ActualDecimalPrecision: Integer;
  Index: Integer;
  DataType: TDBXDataTypeDescription;
  PrecisionColumnType: Integer;
  Product: WideString;
  ColumnName: WideString;
begin
  ColumnType := ColumnRow.GetInt32(TDBXColumnsIndex.DbxDataType);
  RequiredBinaryPrecision := CalcBinaryPrecision(ColumnType);
  RequiredDecimalPrecision := CalcDecimalPrecision(ColumnType);
  SignedRequired := IsSignedInteger(ColumnType);
  AutoIncrementRequired := ColumnRow.GetBoolean(TDBXColumnsIndex.IsAutoIncrement, False);
  BestScore := -1;
  BestType := TDBXDataTypes.UnknownType;
  BestTypeName := NullString;
  BestIsAutoIncrementable := False;
  BestIsSigned := False;
  DataTypes := FReader.DataTypes;
  for index := 0 to DataTypes.Count - 1 do
  begin
    DataType := TDBXDataTypeDescription(DataTypes[Index]);
    ActualColumnType := DataType.DbxDataType;
    case ActualColumnType of
      TDBXDataTypesEx.Int8Type,
      TDBXDataTypesEx.UInt8Type,
      TDBXDataTypes.Int16Type,
      TDBXDataTypes.UInt16Type,
      TDBXDataTypes.Int32Type,
      TDBXDataTypes.UInt32Type,
      TDBXDataTypes.Int64Type,
      TDBXDataTypes.UInt64Type,
      TDBXDataTypes.BcdType:
        begin
          Score := 0;
          if ActualColumnType = TDBXDataTypes.BcdType then
          begin
            ActualBinaryPrecision := 128;
            ActualDecimalPrecision := Integer(DataType.ColumnSize);
          end
          else 
          begin
            PrecisionColumnType := CalcPrecisionColumnType(ActualColumnType, DataType.UnsignedOptionSupported);
            ActualBinaryPrecision := CalcBinaryPrecision(PrecisionColumnType);
            ActualDecimalPrecision := CalcDecimalPrecision(PrecisionColumnType);
          end;
          if ActualBinaryPrecision >= RequiredBinaryPrecision then
            Score := Score + Requirement + 128 - (ActualBinaryPrecision - RequiredBinaryPrecision);
          if ActualDecimalPrecision >= RequiredDecimalPrecision then
            Score := Score + Requirement;
          if DataType.AutoIncrementable or not AutoIncrementRequired then
            Score := Score + Requirement;
          if not DataType.Unsigned or not SignedRequired then
            Score := Score + Requirement;
          if DataType.BestMatch then
            Score := Score + Desireable;
          if Score > BestScore then
          begin
            BestScore := Score;
            BestType := ActualColumnType;
            BestTypeName := DataType.TypeName;
            BestIsAutoIncrementable := DataType.AutoIncrementable;
            BestIsSigned := not DataType.Unsigned;
          end;
        end;
    end;
  end;
  if BestScore >= 4 * Requirement then
  begin
    if (BestType = TDBXDataTypes.BcdType) and (Overrides <> nil) then
    begin
      Overrides[0] := RequiredDecimalPrecision;
      Overrides[1] := 0;
    end;
    begin
      Result := BestTypeName;
      exit;
    end;
  end
  else if not FailIfNotFound then
  begin
    Result := NullString;
    exit;
  end;
  Product := FReader.ProductName;
  ColumnName := ColumnRow.GetString(TDBXColumnsIndex.ColumnName, '');
  if BestScore < 0 then
    raise ErrorTypeNameNotFound(ColumnRow);
  if not BestIsAutoIncrementable and AutoIncrementRequired then
    raise TDBXMetaDataError.Create(Format(SCannotBeUsedForAutoIncrement, [Product,ColumnName,BestTypeName]));
  if not BestIsSigned and SignedRequired then
    raise TDBXMetaDataError.Create(Format(SNoSignedTypeFound, [Product,ColumnName,BestTypeName]))
  else 
    raise TDBXMetaDataError.Create(Format(SNoTypeWithEnoughPrecision, [Product,ColumnName,BestTypeName]));
end;

function TDBXBaseMetaDataWriter.FindDecimalTypeName(ColumnRow: TDBXRowStorage; FailIfNotFound: Boolean): WideString;
var
  PrecisionRequired: Integer;
  ScaleRequired: Integer;
  AutoIncrementRequired: Boolean;
  BestScore: Integer;
  BestTypeName: WideString;
  BestColumnSize: Int64;
  BestMaxScale: Integer;
  DataTypes: TDBXArrayList;
  Index: Integer;
  DataType: TDBXDataTypeDescription;
  Score: Integer;
  ColumnName: WideString;
begin
  PrecisionRequired := ColumnRow.GetInt32(TDBXColumnsIndex.Precision, -1);
  ScaleRequired := ColumnRow.GetInt32(TDBXColumnsIndex.Scale, -1);
  AutoIncrementRequired := ColumnRow.GetBoolean(TDBXColumnsIndex.IsAutoIncrement, False);
  BestScore := -1;
  BestTypeName := NullString;
  BestColumnSize := -1;
  BestMaxScale := -1;
  DataTypes := FReader.DataTypes;
  for index := 0 to DataTypes.Count - 1 do
  begin
    DataType := TDBXDataTypeDescription(DataTypes[Index]);
    if DataType.DbxDataType = TDBXDataTypes.BcdType then
    begin
      Score := 0;
      if DataType.ColumnSize >= PrecisionRequired then
        Score := Score + Requirement + TieBreaker3;
      if DataType.MaximumScale >= ScaleRequired then
        Score := Score + Requirement + TieBreaker2;
      if DataType.AutoIncrementable or not AutoIncrementRequired then
        Score := Score + Requirement;
      if DataType.BestMatch then
        Score := Score + TieBreaker1;
      if Score > BestScore then
      begin
        BestScore := Score;
        BestTypeName := DataType.TypeName;
        BestColumnSize := DataType.ColumnSize;
        BestMaxScale := DataType.MaximumScale;
      end;
    end;
  end;
  if BestScore >= 3 * Requirement then
  begin
    Result := BestTypeName;
    exit;
  end
  else if not FailIfNotFound then
  begin
    Result := NullString;
    exit;
  end;
  ColumnName := ColumnRow.GetString(TDBXColumnsIndex.ColumnName, '');
  if BestScore < 0 then
    raise ErrorTypeNameNotFound(ColumnRow);
  if BestColumnSize < PrecisionRequired then
    raise TDBXMetaDataError.Create(Format(SCannotHoldWantedPrecision, [ColumnName,BestTypeName,IntToStr(BestColumnSize),IntToStr(PrecisionRequired)]));
  if BestMaxScale < ScaleRequired then
    raise TDBXMetaDataError.Create(Format(SCannotHoldWantedScale, [ColumnName,BestTypeName,IntToStr(BestMaxScale),IntToStr(ScaleRequired)]))
  else 
    raise TDBXMetaDataError.Create(Format(SCannotBeUsedForAutoIncrement, [BestTypeName,ColumnName]));
end;

function TDBXBaseMetaDataWriter.GetDefaultFloatPrecision(ColumnType: Integer): Integer;
begin
  case ColumnType of
    TDBXDataTypesEx.SingleType:
      Result := 24;
    TDBXDataTypes.DoubleType:
      Result := 53;
    else
      Result := 0;
  end;
end;

function TDBXBaseMetaDataWriter.FindFloatTypeName(ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s; FailIfNotFound: Boolean): WideString;
var
  WantedColumnType: Integer;
  PrecisionRequired: Integer;
  BestScore: Integer;
  BestTypeName: WideString;
  BestColumnSize: Int64;
  BestPrecisionNeeded: Boolean;
  DataTypes: TDBXArrayList;
  Index: Integer;
  DataType: TDBXDataTypeDescription;
  ActualColumnType: Integer;
  Score: Integer;
  PrecisionNeeded: Boolean;
  ColumnName: WideString;
  Product: WideString;
begin
  WantedColumnType := ColumnRow.GetInt32(TDBXColumnsIndex.DbxDataType);
  PrecisionRequired := GetDefaultFloatPrecision(WantedColumnType);
  BestScore := -1;
  BestTypeName := NullString;
  BestColumnSize := -1;
  BestPrecisionNeeded := False;
  DataTypes := FReader.DataTypes;
  for index := 0 to DataTypes.Count - 1 do
  begin
    DataType := TDBXDataTypeDescription(DataTypes[Index]);
    ActualColumnType := DataType.DbxDataType;
    case ActualColumnType of
      TDBXDataTypesEx.SingleType,
      TDBXDataTypes.DoubleType:
        begin
          Score := 0;
          PrecisionNeeded := (Length(DataType.CreateParameters) > 0);
          if PrecisionNeeded then
          begin
            if DataType.ColumnSize >= PrecisionRequired then
              Score := Score + Requirement;
          end
          else 
          begin
            if ActualColumnType = WantedColumnType then
              Score := Score + Requirement + TieBreaker2;
          end;
          if DataType.BestMatch then
            Score := Score + TieBreaker1;
          if Score > BestScore then
          begin
            BestScore := Score;
            BestTypeName := DataType.TypeName;
            BestColumnSize := DataType.ColumnSize;
            BestPrecisionNeeded := PrecisionNeeded;
          end;
        end;
    end;
  end;
  if BestScore >= Requirement then
  begin
    if BestPrecisionNeeded then
    begin
      if ColumnRow.IsNull(TDBXColumnsIndex.Precision) or (ColumnRow.GetInt32(TDBXColumnsIndex.Precision) < PrecisionRequired) then
      begin
        if Overrides <> nil then
          Overrides[0] := PrecisionRequired;
      end;
    end;
    begin
      Result := BestTypeName;
      exit;
    end;
  end
  else if not FailIfNotFound then
  begin
    Result := NullString;
    exit;
  end;
  ColumnName := ColumnRow.GetString(TDBXColumnsIndex.ColumnName, '');
  Product := FReader.ProductName;
  if BestScore < 0 then
    raise ErrorTypeNameNotFound(ColumnRow)
  else 
    raise TDBXMetaDataError.Create(Format(SCannotHoldWantedPrecision, [Product,ColumnName,BestTypeName,IntToStr(BestColumnSize),IntToStr(PrecisionRequired)]));
end;

function TDBXBaseMetaDataWriter.FindDateTimeTypeName(ColumnRow: TDBXRowStorage; FailIfNotFound: Boolean): WideString;
var
  WantedColumnType: Integer;
  BestScore: Integer;
  BestTypeName: WideString;
  DataTypes: TDBXArrayList;
  Index: Integer;
  DataType: TDBXDataTypeDescription;
  ColumnType: Integer;
  Score: Integer;
begin
  WantedColumnType := ColumnRow.GetInt32(TDBXColumnsIndex.DbxDataType);
  BestScore := -1;
  BestTypeName := NullString;
  DataTypes := FReader.DataTypes;
  for index := 0 to DataTypes.Count - 1 do
  begin
    DataType := TDBXDataTypeDescription(DataTypes[Index]);
    ColumnType := DataType.DbxDataType;
    case ColumnType of
      TDBXDataTypes.DateType,
      TDBXDataTypes.TimeType,
      TDBXDataTypes.TimestampType:
        begin
          Score := 0;
          if WantedColumnType = ColumnType then
            Score := Requirement + Desireable
          else if ColumnType = TDBXDataTypes.TimestampType then
            Score := Requirement;
          if DataType.BestMatch then
            Score := Score + TieBreaker1;
          if Score > BestScore then
          begin
            BestScore := Score;
            BestTypeName := DataType.TypeName;
          end;
        end;
    end;
  end;
  if BestScore >= Requirement then
  begin
    Result := BestTypeName;
    exit;
  end
  else if not FailIfNotFound then
  begin
    Result := NullString;
    exit;
  end;
  raise ErrorTypeNameNotFound(ColumnRow);
end;

function TDBXBaseMetaDataWriter.AddToExternalStatements(ExternalStatements: TDBXWideStringBuffer; Buffer: TDBXWideStringBuffer; StartPosition: Integer): TDBXWideStringBuffer;
begin
  if ExternalStatements = nil then
    ExternalStatements := TDBXWideStringBuffer.Create;
  ExternalStatements.Append(SubString(Buffer,StartPosition));
  Result := ExternalStatements;
end;

function TDBXBaseMetaDataWriter.IsValidSqlIdentifier(Identifier: WideString): Boolean;
var
  UpperOK: Boolean;
  LowerOK: Boolean;
  Index: Integer;
  Ch: WideChar;
begin
  UpperOK := FReader.UpperCaseIdentifiersSupported;
  LowerOK := FReader.LowerCaseIdentifiersSupported;
  if (Length(Identifier) = 0) or not IsLetter(Identifier[1+0], UpperOK, LowerOK) then
  begin
    Result := False;
    exit;
  end;
  for index := 1 to Length(Identifier) - 1 do
  begin
    Ch := Identifier[1+Index];
    if not IsLetter(Ch, UpperOK, LowerOK) and not IsDigit(Ch) and (Ch <> '_') then
    begin
      Result := False;
      exit;
    end;
  end;
  Result := True;
end;

function TDBXBaseMetaDataWriter.IsReservedWord(Identifier: WideString): Boolean;
begin
  if FReservedWords = nil then
    FReservedWords := FReader.MakeStorage(FReader.FetchReservedWords);
  Result := FReservedWords.FindStringKey(TDBXReservedWordsIndex.ReservedWord, Identifier);
end;

function TDBXBaseMetaDataWriter.IsLetter(Ch: WideChar; UpperOK: Boolean; LowerOK: Boolean): Boolean;
begin
  if (Ch >= 'A') and (Ch <= 'Z') then
  begin
    Result := UpperOK;
    exit;
  end;
  if (Ch >= 'a') and (Ch <= 'z') then
  begin
    Result := LowerOK;
    exit;
  end;
  Result := False;
end;

function TDBXBaseMetaDataWriter.IsDigit(Ch: WideChar): Boolean;
begin
  Result := ((Ch >= '0') and (Ch <= '9'));
end;

procedure TDBXBaseMetaDataWriter.MakeSqlTableReplacement(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Columns: TDBXTableStorage);
var
  OriginalTable: TDBXRowStorage;
  TableRename: Boolean;
  NewCatalogName: WideString;
  NewSchemaName: WideString;
  NewTableName: WideString;
  TempTableName: WideString;
  NewTable: TDBXRowStorage;
  NewColumns: TDBXTableStorage;
begin
  OriginalTable := Table.OriginalRow;
  TableRename := not (Table.EqualTo(TDBXTablesIndex.CatalogName, OriginalTable, TDBXTablesIndex.CatalogName) and Table.EqualTo(TDBXTablesIndex.SchemaName, OriginalTable, TDBXTablesIndex.SchemaName) and Table.EqualTo(TDBXTablesIndex.TableName, OriginalTable, TDBXTablesIndex.TableName));
  NewCatalogName := Table.GetString(TDBXTablesIndex.CatalogName, NullString);
  NewSchemaName := Table.GetString(TDBXTablesIndex.SchemaName, NullString);
  NewTableName := Table.GetString(TDBXTablesIndex.TableName, NullString);
  TempTableName := C_Conditional(TableRename, NewTableName, TDBXSQL.Temp + NewTableName);
  Buffer.Append(TDBXSQL.Nl);
  CreateTempOutputTable(Buffer, Table, Columns, TempTableName);
  Buffer.Append(TDBXSQL.Nl);
  InsertValuesFromOldTable(Buffer, Table, Columns, TempTableName);
  Buffer.Append(TDBXSQL.Nl);
  MakeSqlDropTable(Buffer, OriginalTable);
  if not TableRename then
  begin
    if not StringIsNil(SqlRenameTable) then
      MakeSqlTableRename(Buffer, NewCatalogName, NewSchemaName, TempTableName, NewTableName)
    else 
    begin
      NewTable := CopyTableRow(Table, TempTableName);
      NewColumns := CopyColumns(Columns);
      Buffer.Append(TDBXSQL.Nl);
      CreateTempOutputTable(Buffer, NewTable, NewColumns, NewTableName);
      Buffer.Append(TDBXSQL.Nl);
      InsertValuesFromOldTable(Buffer, NewTable, NewColumns, NewTableName);
      Buffer.Append(TDBXSQL.Nl);
      MakeSqlDropTable(Buffer, NewTable.OriginalRow);
    end;
  end;
end;

function TDBXBaseMetaDataWriter.CopyColumns(ColumnTable: TDBXTableStorage): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
  TableCopy: TDBXTableStorage;
  Cursor: TDBXTableStorage;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateColumnsColumns;
  TableCopy := FContext.CreateTableStorage(TDBXMetaDataCollectionIndex.Columns, TDBXMetaDataCollectionName.Columns, Columns);
  Cursor := ColumnTable.GetCurrentRows(TDBXColumnsColumns.Ordinal);
  TableCopy.CopyFrom(Cursor);
  TableCopy.AcceptChanges;
  FreeAndNil(Cursor);
  Result := TableCopy;
end;

function TDBXBaseMetaDataWriter.CopyTableRow(Table: TDBXRowStorage; TempTableName: WideString): TDBXRowStorage;
var
  Columns: TDBXColumnDescriptorArray;
  TableCopy: TDBXTableStorage;
  NewTableName: WideString;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateTablesColumns;
  TableCopy := FContext.CreateTableStorage(TDBXMetaDataCollectionIndex.Tables, TDBXMetaDataCollectionName.Tables, Columns);
  TableCopy.NewRow;
  CopyRow(Table, TableCopy, Length(Columns));
  NewTableName := TableCopy.GetString(TDBXTablesIndex.TableName, NullString);
  TableCopy.SetString(TDBXTablesIndex.TableName, TempTableName);
  TableCopy.InsertRow;
  TableCopy.AcceptChanges;
  TableCopy.SetString(TDBXTablesIndex.TableName, NewTableName);
  Result := TableCopy;
end;

function TDBXBaseMetaDataWriter.ComputeColumnMap(Columns: TDBXTableStorage): TDBXStringStore;
var
  Map: TDBXStringStore;
  Current: TDBXTableStorage;
  Original: TDBXRowStorage;
begin
  Map := TDBXStringStore.Create;
  Current := Columns.GetCurrentRows(NullString);
  Current.BeforeFirst;
  while Current.Next do
  begin
    Original := Current.OriginalRow;
    if Original <> nil then
      Map[Original.GetString(TDBXColumnsIndex.ColumnName)] := Current.GetString(TDBXColumnsIndex.ColumnName);
  end;
  FreeAndNil(Current);
  Result := Map;
end;

function TDBXBaseMetaDataWriter.GetDefaults(CatalogName: WideString; SchemaName: WideString; TableName: WideString): TDBXTableStorage;
begin
  Result := FReader.MakeStorage(FReader.FetchColumnConstraints(CatalogName, SchemaName, TableName));
end;

function TDBXBaseMetaDataWriter.GetIndexes(CatalogName: WideString; SchemaName: WideString; TableName: WideString): TDBXTableStorage;
begin
  Result := FReader.MakeStorage(FReader.FetchIndexes(CatalogName, SchemaName, TableName));
end;

function TDBXBaseMetaDataWriter.GetIndexColumns(CatalogName: WideString; SchemaName: WideString; TableName: WideString): TDBXTableStorage;
begin
  Result := FReader.MakeStorage(FReader.FetchIndexColumns(CatalogName, SchemaName, TableName, NullString));
end;

function TDBXBaseMetaDataWriter.GetForeignKeyColumns(CatalogName: WideString; SchemaName: WideString; TableName: WideString): TDBXTableStorage;
var
  ForeignKeyColumns: TDBXTableStorage;
  ImportedKeyColumns: TDBXTableStorage;
begin
  ForeignKeyColumns := FReader.MakeStorage(FReader.FetchForeignKeyColumns(CatalogName, SchemaName, TableName, NullString, NullString, NullString, NullString, NullString));
  ImportedKeyColumns := FReader.FetchForeignKeyColumns(NullString, NullString, NullString, NullString, CatalogName, SchemaName, TableName, NullString);
  ForeignKeyColumns.CopyFrom(ImportedKeyColumns);
  ImportedKeyColumns.Close;
  ImportedKeyColumns.Free;
  ForeignKeyColumns.AcceptChanges;
  Result := ForeignKeyColumns;
end;

procedure TDBXBaseMetaDataWriter.RemoveForeignKeyGeneratedIndexes(Table: TDBXRowStorage; Indexes: TDBXTableStorage; IndexColumns: TDBXTableStorage; ForeignKeyColumns: TDBXTableStorage);
var
  GeneratedIndexName: WideString;
  Name: WideString;
  Original: TDBXRowStorage;
  ConstraintNames: TDBXStringList;
  IndexNames: TDBXStringList;
begin
  GeneratedIndexName := SqlKeyGeneratedIndexName;
  if not StringIsNil(GeneratedIndexName) then
  begin
    Original := Table.OriginalRow;
    ConstraintNames := TDBXStringList.Create;
    IndexNames := TDBXStringList.Create;
    ForeignKeyColumns.BeforeFirst;
    while ForeignKeyColumns.Next do
    begin
      if Compare(ForeignKeyColumns, TDBXForeignKeyColumnsIndex.CatalogName, Original, TDBXTablesIndex.CatalogName, (TDBXTablesIndex.TableName - TDBXTablesIndex.CatalogName) + 1) and (ForeignKeyColumns.GetAsInt32(TDBXForeignKeyColumnsIndex.Ordinal) = 1) then
        ConstraintNames.Add(ForeignKeyColumns.GetString(TDBXForeignKeyColumnsIndex.ForeignKeyName, TDBXSQL.Empty) + GeneratedIndexName);
    end;
    Indexes.BeforeFirst;
    while Indexes.Next do
    begin
      Name := Indexes.GetString(TDBXIndexesIndex.ConstraintName, NullString);
      if StringIsNil(Name) then
        Name := Indexes.GetString(TDBXIndexesIndex.IndexName, NullString);
      if StringEndsWith(Name,GeneratedIndexName) and (ConstraintNames.IndexOf(Name) >= 0) then
      begin
        IndexNames.Add(Indexes.GetString(TDBXIndexesIndex.IndexName, TDBXSQL.Empty));
        Indexes.DeleteRow;
      end;
    end;
    Indexes.AcceptChanges;
    IndexColumns.BeforeFirst;
    while IndexColumns.Next do
    begin
      Name := IndexColumns.GetString(TDBXIndexColumnsIndex.IndexName, TDBXSQL.Empty);
      if StringEndsWith(Name,GeneratedIndexName) and (IndexNames.IndexOf(Name) >= 0) then
        IndexColumns.DeleteRow;
    end;
    IndexColumns.AcceptChanges;
  end;
end;

procedure TDBXBaseMetaDataWriter.DropAllConstraints(Buffer: TDBXWideStringBuffer; Defaults: TDBXTableStorage; Indexes: TDBXTableStorage; ForeignKeys: TDBXTableStorage);
begin
  if Defaults <> nil then
  begin
    Defaults.BeforeFirst;
    while Defaults.Next do
      MakeSqlDropConstraint(Buffer, Defaults);
  end;
  ForeignKeys.BeforeFirst;
  while ForeignKeys.Next do
  begin
    if ForeignKeys.GetInt32(TDBXForeignKeyColumnsIndex.Ordinal, 0) = 1 then
      MakeSqlDropForeignKey(Buffer, ForeignKeys);
  end;
  Indexes.BeforeFirst;
  while Indexes.Next do
    MakeSqlDropIndex(Buffer, Indexes);
end;

procedure TDBXBaseMetaDataWriter.CreateTempOutputTable(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Columns: TDBXTableStorage; TempTableName: WideString);
var
  TempStorage: TDBXTableStorage;
begin
  TempStorage := FContext.CreateTableStorage(TDBXMetaDataCollectionIndex.Tables, TDBXMetaDataCollectionName.Tables, TDBXMetaDataCollectionColumns.CreateTablesColumns);
  TempStorage.BeforeFirst;
  TempStorage.NewRow;
  Table.CopyTo(TDBXTablesIndex.CatalogName, TempStorage, TDBXTablesIndex.CatalogName);
  Table.CopyTo(TDBXTablesIndex.SchemaName, TempStorage, TDBXTablesIndex.SchemaName);
  TempStorage.SetString(TDBXTablesIndex.TableName, TempTableName);
  TempStorage.InsertRow;
  MakeSqlCreate(Buffer, TempStorage, Columns);
  FreeAndNil(TempStorage);
end;

procedure TDBXBaseMetaDataWriter.SetIdentityInsert(Buffer: TDBXWideStringBuffer; CatalogName: WideString; SchemaName: WideString; TableName: WideString; &On: Boolean);
var
  AutoIncrementInserts: WideString;
begin
  AutoIncrementInserts := SqlAutoIncrementInserts;
  if not StringIsNil(AutoIncrementInserts) then
  begin
    Buffer.Append(TDBXSQL.&Set);
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(AutoIncrementInserts);
    Buffer.Append(TDBXSQL.Space);
    MakeSqlObjectName(Buffer, CatalogName, SchemaName, TableName);
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(C_Conditional(&On, TDBXSQL.&On, TDBXSQL.Off));
    Buffer.Append(TDBXSQL.Semicolon);
    Buffer.Append(TDBXSQL.Nl);
  end;
end;

function TDBXBaseMetaDataWriter.CheckForAutoIncrement(Columns: TDBXTableStorage): Boolean;
begin
  Columns.BeforeFirst;
  while Columns.Next do
  begin
    if Columns.GetBoolean(TDBXColumnsIndex.IsAutoIncrement, False) then
    begin
      Result := True;
      exit;
    end;
  end;
  Result := False;
end;

procedure TDBXBaseMetaDataWriter.InsertValuesFromOldTable(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Columns: TDBXTableStorage; TempTableName: WideString);
var
  CurrentColumns: TDBXTableStorage;
  OriginalTable: TDBXRowStorage;
  OldCatalogName: WideString;
  OldSchemaName: WideString;
  OldTableName: WideString;
  NewCatalogName: WideString;
  NewSchemaName: WideString;
  HasAutoIncrementColumn: Boolean;
  Original: TDBXRowStorage;
  Comma: WideString;
begin
  CurrentColumns := Columns.GetCurrentRows(TDBXColumnsColumns.Ordinal);
  OriginalTable := Table.OriginalRow;
  OldCatalogName := OriginalTable.GetString(TDBXTablesIndex.CatalogName, NullString);
  OldSchemaName := OriginalTable.GetString(TDBXTablesIndex.SchemaName, NullString);
  OldTableName := OriginalTable.GetString(TDBXTablesIndex.TableName, NullString);
  NewCatalogName := Table.GetString(TDBXTablesIndex.CatalogName, NullString);
  NewSchemaName := Table.GetString(TDBXTablesIndex.SchemaName, NullString);
  HasAutoIncrementColumn := CheckForAutoIncrement(CurrentColumns);
  if HasAutoIncrementColumn then
    SetIdentityInsert(Buffer, NewCatalogName, NewSchemaName, TempTableName, True);
  Buffer.Append(TDBXSQL.Insert);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Into);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlObjectName(Buffer, NewCatalogName, NewSchemaName, TempTableName);
  Buffer.Append(TDBXSQL.OpenParen);
  CurrentColumns.BeforeFirst;
  Comma := TDBXSQL.Empty;
  while CurrentColumns.Next do
  begin
    Original := CurrentColumns.OriginalRow;
    if Original <> nil then
    begin
      Buffer.Append(Comma);
      Comma := TDBXSQL.Comma;
      MakeSqlIdentifier(Buffer, CurrentColumns.GetString(TDBXColumnsIndex.ColumnName, NullString));
    end;
  end;
  Buffer.Append(TDBXSQL.CloseParen);
  Buffer.Append(TDBXSQL.Nl);
  Buffer.Append(TDBXSQL.Spacing);
  Buffer.Append(TDBXSQL.Select);
  Buffer.Append(TDBXSQL.Space);
  CurrentColumns.BeforeFirst;
  Comma := TDBXSQL.Empty;
  while CurrentColumns.Next do
  begin
    Original := CurrentColumns.OriginalRow;
    if Original <> nil then
    begin
      Buffer.Append(Comma);
      Comma := TDBXSQL.Comma;
      if CurrentColumns.EqualTo(TDBXColumnsIndex.TypeName, Original, TDBXColumnsIndex.TypeName) and CurrentColumns.EqualTo(TDBXColumnsIndex.Precision, Original, TDBXColumnsIndex.Precision) and CurrentColumns.EqualTo(TDBXColumnsIndex.Scale, Original, TDBXColumnsIndex.Scale) then
        MakeSqlIdentifier(Buffer, Original.GetString(TDBXColumnsIndex.ColumnName, NullString))
      else 
        MakeSqlColumnTypeCast(Buffer, CurrentColumns);
    end;
  end;
  FreeAndNil(CurrentColumns);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.From);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlObjectName(Buffer, OldCatalogName, OldSchemaName, OldTableName);
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
  if HasAutoIncrementColumn then
    SetIdentityInsert(Buffer, NewCatalogName, NewSchemaName, TempTableName, False);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlColumnTypeCast(Buffer: TDBXWideStringBuffer; Column: TDBXRowStorage);
var
  Original: TDBXRowStorage;
begin
  Original := Column.OriginalRow;
  Buffer.Append(TDBXSQL.Cast);
  Buffer.Append(TDBXSQL.OpenParen);
  MakeSqlIdentifier(Buffer, Original.GetString(TDBXColumnsIndex.ColumnName, NullString));
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.&As);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlDataType(Buffer, Column.GetString(TDBXColumnsIndex.TypeName), Column);
  Buffer.Append(TDBXSQL.CloseParen);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlDropTable(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage);
begin
  Buffer.Append(TDBXSQL.Drop);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Table);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlObjectName(Buffer, Table.GetString(TDBXTablesIndex.CatalogName, NullString), Table.GetString(TDBXTablesIndex.SchemaName, NullString), Table.GetString(TDBXTablesIndex.TableName, NullString));
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

procedure TDBXBaseMetaDataWriter.ReplaceParameter(Buffer: TDBXWideStringBuffer; Start: Integer; Parameter: WideString; Replacement: WideString);
var
  Marker: WideString;
begin
  Marker := FReader.SqlDefaultParameterMarker;
  Parameter := Marker + Parameter;
  if (StringIsNil(Replacement)) or (Length(Replacement) = 0) then
    Parameter := Parameter + TDBXSQL.Dot;
  Buffer.Replace(Parameter,Replacement,Start,Buffer.Length-(Start));
end;

procedure TDBXBaseMetaDataWriter.MakeSqlTableRename(Buffer: TDBXWideStringBuffer; CatalogName: WideString; SchemaName: WideString; TableName: WideString; NewTableName: WideString);
var
  Start: Integer;
begin
  Start := Buffer.Length;
  Buffer.Append(SqlRenameTable);
  ReplaceParameter(Buffer, Start, TDBXParameterName.CatalogName, CatalogName);
  ReplaceParameter(Buffer, Start, TDBXParameterName.SchemaName, SchemaName);
  ReplaceParameter(Buffer, Start, TDBXParameterName.TableName, TableName);
  ReplaceParameter(Buffer, Start, TDBXParameterName.NewSchemaName, SchemaName);
  ReplaceParameter(Buffer, Start, TDBXParameterName.NewTableName, NewTableName);
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

procedure TDBXBaseMetaDataWriter.CopyRow(Source: TDBXRowStorage; Target: TDBXTableStorage; Columns: Integer);
var
  Ordinal: Integer;
begin
  for ordinal := 0 to Columns - 1 do
    Source.CopyTo(Ordinal, Target, Ordinal);
end;

function TDBXBaseMetaDataWriter.Compare(Table: TDBXTableStorage; Start: Integer; Row: TDBXRowStorage; RowStart: Integer; Columns: Integer): Boolean;
var
  Index: Integer;
begin
  for index := 0 to Columns - 1 do
  begin
    if not Row.IsNull(RowStart) and not Table.EqualTo(Start, Row, RowStart) then
    begin
      Result := False;
      exit;
    end;
    IncrAfter(Start);
    IncrAfter(RowStart);
  end;
  Result := True;
end;

function TDBXBaseMetaDataWriter.SameConstraint(Table: TDBXTableStorage; Row: TDBXRowStorage; Columns: Integer): Boolean;
var
  Ordinal: Integer;
begin
  for ordinal := 0 to Columns - 1 do
  begin
    if not Table.EqualTo(Ordinal, Row, Ordinal) then
    begin
      Result := False;
      exit;
    end;
  end;
  Result := True;
end;

procedure TDBXBaseMetaDataWriter.MapTable(Item: TDBXTableStorage; Table: TDBXRowStorage);
var
  Original: TDBXRowStorage;
begin
  Original := Table.OriginalRow;
  if Compare(Item, TDBXIndexesIndex.CatalogName, Original, TDBXTablesIndex.CatalogName, TDBXTablesIndex.TableName - TDBXTablesIndex.CatalogName + 1) then
  begin
    Table.CopyTo(TDBXTablesIndex.CatalogName, Item, TDBXIndexesIndex.CatalogName);
    Table.CopyTo(TDBXTablesIndex.SchemaName, Item, TDBXIndexesIndex.SchemaName);
    Table.CopyTo(TDBXTablesIndex.TableName, Item, TDBXIndexesIndex.TableName);
  end;
end;

function TDBXBaseMetaDataWriter.MapColumn(Parts: TDBXTableStorage; Table: TDBXRowStorage; ColumnMap: TDBXStringStore; ColIndex: Integer; IdColumns: Integer; DroppedColumn: WideString): WideString;
var
  Original: TDBXRowStorage;
  ColumnName: WideString;
  MappedName: WideString;
begin
  if (StringIsNil(DroppedColumn)) and (ColIndex >= 0) then
  begin
    Original := Table.OriginalRow;
    if Compare(Parts, ColIndex - IdColumns, Original, TDBXTablesIndex.CatalogName, TDBXTablesIndex.TableName - TDBXTablesIndex.CatalogName + 1) then
    begin
      ColumnName := Parts.GetString(ColIndex);
      MappedName := ColumnMap[ColumnName];
      if StringIsNil(MappedName) then
      begin
        Result := ColumnName;
        exit;
      end;
      Parts.SetString(ColIndex, MappedName);
      Table.CopyTo(TDBXTablesIndex.CatalogName, Parts, ColIndex - IdColumns + TDBXTablesIndex.CatalogName);
      Table.CopyTo(TDBXTablesIndex.SchemaName, Parts, ColIndex - IdColumns + TDBXTablesIndex.SchemaName);
      Table.CopyTo(TDBXTablesIndex.TableName, Parts, ColIndex - IdColumns + TDBXTablesIndex.TableName);
    end;
  end;
  Result := DroppedColumn;
end;

procedure TDBXBaseMetaDataWriter.CreateConstraints(Buffer: TDBXWideStringBuffer; Columns: TDBXColumnDescriptorArray; Constraints: TDBXTableStorage; ConstraintColumns: TDBXTableStorage; CollectionIndex: Integer; CollectionName: WideString; IdColumns: Integer; ItemColumns: Integer; PartColumns: Integer; Table: TDBXRowStorage; ColumnMap: TDBXStringStore; ColIndex1: Integer; ColIndex2: Integer);
var
  Item: TDBXTableStorage;
  Parts: TDBXTableStorage;
  DroppedColumn: WideString;
  MoreItems: Boolean;
  ItemSource: TDBXTableStorage;
  MoreColumns: Boolean;
begin
  Item := FContext.CreateTableStorage(CollectionIndex, CollectionName, Columns);
  Parts := FContext.CreateTableStorage(ConstraintColumns.MetaDataCollectionIndex, ConstraintColumns.MetaDataCollectionName, ConstraintColumns.CopyColumns);
  DroppedColumn := NullString;
  Item.BeforeFirst;
  Item.NewRow;
  Item.InsertRow;
  MoreItems := True;
  ItemSource := ConstraintColumns;
  if Constraints <> nil then
  begin
    ItemSource := Constraints;
    Constraints.BeforeFirst;
    MoreItems := Constraints.Next;
  end;
  ConstraintColumns.BeforeFirst;
  MoreColumns := ConstraintColumns.Next;
  while MoreColumns and MoreItems do
  begin
    CopyRow(ItemSource, Item, ItemColumns);
    Parts.Clear;
    while MoreColumns and SameConstraint(ConstraintColumns, Item, IdColumns) do
    begin
      Parts.BeforeFirst;
      Parts.NewRow;
      CopyRow(ConstraintColumns, Parts, PartColumns);
      DroppedColumn := MapColumn(Parts, Table, ColumnMap, ColIndex1, IdColumns, DroppedColumn);
      DroppedColumn := MapColumn(Parts, Table, ColumnMap, ColIndex2, IdColumns, DroppedColumn);
      Parts.InsertRow;
      MoreColumns := ConstraintColumns.Next;
    end;
    if Constraints <> nil then
      MoreItems := Constraints.Next;
    if StringIsNil(DroppedColumn) then
    begin
      MapTable(Item, Table);
      MakeSqlCreate(Buffer, Item, Parts);
    end
    else 
    begin
      Buffer.Append(TDBXSQL.LineComment);
      Buffer.Append(TDBXSQL.Space);
      Buffer.Append(Format(SCannotRecreateConstraint, [Item.GetString(IdColumns - 1),DroppedColumn]));
      Buffer.Append(TDBXSQL.Nl);
      DroppedColumn := NullString;
    end;
  end;
  FreeAndNil(Item);
  FreeAndNil(Parts);
end;

procedure TDBXBaseMetaDataWriter.CreateIndices(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; Indexes: TDBXTableStorage; IndexColumns: TDBXTableStorage; ColumnMap: TDBXStringStore);
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateIndexesColumns;
  CreateConstraints(Buffer, Columns, Indexes, IndexColumns, TDBXMetaDataCollectionIndex.Indexes, TDBXMetaDataCollectionName.Indexes, TDBXIndexesIndex.IndexName + 1, TDBXIndexesIndex.IsUnique + 1, TDBXIndexColumnsIndex.IsAscending + 1, Table, ColumnMap, TDBXIndexColumnsIndex.ColumnName, -1);
end;

procedure TDBXBaseMetaDataWriter.CreateForeignKeys(Buffer: TDBXWideStringBuffer; Table: TDBXRowStorage; ForeignKeyColumns: TDBXTableStorage; ColumnMap: TDBXStringStore);
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateForeignKeysColumns;
  CreateConstraints(Buffer, Columns, nil, ForeignKeyColumns, TDBXMetaDataCollectionIndex.ForeignKeys, TDBXMetaDataCollectionName.ForeignKeys, TDBXForeignKeysIndex.ForeignKeyName + 1, TDBXForeignKeysIndex.ForeignKeyName + 1, TDBXForeignKeyColumnsIndex.Ordinal + 1, Table, ColumnMap, TDBXForeignKeyColumnsIndex.ColumnName, TDBXForeignKeyColumnsIndex.PrimaryColumnName);
end;

function TDBXBaseMetaDataWriter.CanCreateIndexAsKey(Index: TDBXRowStorage; IndexColumns: TDBXTableStorage): Boolean;
begin
  if not DescendingIndexConstraintsSupported and (IndexColumns <> nil) then
  begin
    IndexColumns.BeforeFirst;
    while IndexColumns.Next do
    begin
      if not IndexColumns.GetBoolean(TDBXIndexColumnsIndex.IsAscending, True) then
      begin
        Result := False;
        exit;
      end;
    end;
  end;
  if not Index.GetBoolean(TDBXIndexesIndex.IsPrimary, False) and not Index.GetBoolean(TDBXIndexesIndex.IsUnique, False) then
  begin
    Result := False;
    exit;
  end;
  Result := True;
end;

procedure TDBXBaseMetaDataWriter.MakeSqlCreateIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage; IndexColumns: TDBXTableStorage);
begin
  if CanCreateIndexAsKey(Index, IndexColumns) then
    MakeSqlCreateKey(Buffer, Index, IndexColumns)
  else 
    MakeSqlCreateSecondaryIndex(Buffer, Index, IndexColumns);
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlDropIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage);
begin
  if not Index.IsNull(TDBXIndexesIndex.ConstraintName) then
    MakeSqlDropConstraint(Buffer, Index)
  else 
    MakeSqlDropSecondaryIndex(Buffer, Index);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlCreateKey(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage; IndexColumns: TDBXTableStorage);
begin
  MakeSqlCreateConstraint(Buffer, Index);
  if Index.GetBoolean(TDBXIndexesIndex.IsPrimary, False) then
  begin
    Buffer.Append(TDBXSQL.Primary);
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(TDBXSQL.Key);
  end
  else 
    Buffer.Append(TDBXSQL.Unique);
  MakeSqlCreateIndexColumnList(Buffer, IndexColumns);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlCreateSecondaryIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage; IndexColumns: TDBXTableStorage);
begin
  Buffer.Append(TDBXSQL.&Create);
  Buffer.Append(TDBXSQL.Space);
  if Index.GetBoolean(TDBXIndexesIndex.IsUnique, False) or Index.GetBoolean(TDBXIndexesIndex.IsPrimary, False) then
  begin
    Buffer.Append(TDBXSQL.Unique);
    Buffer.Append(TDBXSQL.Space);
  end;
  if FReader.DescendingIndexSupported and not Index.GetBoolean(TDBXIndexesIndex.IsAscending, True) then
  begin
    Buffer.Append(TDBXSQL.Descending);
    Buffer.Append(TDBXSQL.Space);
  end;
  Buffer.Append(TDBXSQL.Index);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlIdentifier(Buffer, Index.GetString(TDBXIndexesIndex.IndexName, NullString));
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.&On);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlObjectName(Buffer, Index.GetString(TDBXIndexesIndex.CatalogName, NullString), Index.GetString(TDBXIndexesIndex.SchemaName, NullString), Index.GetString(TDBXIndexesIndex.TableName, NullString));
  MakeSqlCreateIndexColumnList(Buffer, IndexColumns);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlCreateConstraint(Buffer: TDBXWideStringBuffer; Constraint: TDBXRowStorage);
begin
  MakeSqlAlterTablePrefix(Buffer, Constraint);
  Buffer.Append(TDBXSQL.Add);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlConstraintName(Buffer, Constraint);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlConstraintName(Buffer: TDBXWideStringBuffer; Constraint: TDBXRowStorage);
var
  ConstraintName: WideString;
begin
  ConstraintName := NullString;
  if (Constraint.MetaDataCollectionName = TDBXMetaDataCollectionName.Indexes) then
    ConstraintName := Constraint.GetString(TDBXIndexesIndex.ConstraintName, NullString);
  if StringIsNil(ConstraintName) then
    ConstraintName := Constraint.GetString(TDBXForeignKeysIndex.ForeignKeyName);
  if (not StringIsNil(ConstraintName)) and (Length(ConstraintName) > 0) then
  begin
    Buffer.Append(TDBXSQL.Constraint);
    Buffer.Append(TDBXSQL.Space);
    MakeSqlIdentifier(Buffer, ConstraintName);
    Buffer.Append(TDBXSQL.Space);
  end;
end;

procedure TDBXBaseMetaDataWriter.MakeSqlAlterTablePrefix(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage);
begin
  Buffer.Append(TDBXSQL.Alter);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Table);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlObjectName(Buffer, Item.GetString(TDBXForeignKeysIndex.CatalogName, NullString), Item.GetString(TDBXForeignKeysIndex.SchemaName, NullString), Item.GetString(TDBXForeignKeysIndex.TableName, NullString));
  Buffer.Append(TDBXSQL.Space);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlDropConstraint(Buffer: TDBXWideStringBuffer; Constraint: TDBXRowStorage);
var
  ConstraintName: WideString;
begin
  MakeSqlAlterTablePrefix(Buffer, Constraint);
  ConstraintName := NullString;
  if (Constraint.MetaDataCollectionName = TDBXMetaDataCollectionName.Indexes) then
    ConstraintName := Constraint.GetString(TDBXIndexesIndex.ConstraintName, NullString);
  if StringIsNil(ConstraintName) then
    ConstraintName := Constraint.GetString(TDBXForeignKeysIndex.ForeignKeyName);
  Buffer.Append(TDBXSQL.Drop);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Constraint);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlIdentifier(Buffer, ConstraintName);
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlCreateIndexColumnList(Buffer: TDBXWideStringBuffer; IndexColumns: TDBXTableStorage);
var
  Columns: TDBXTableStorage;
  Comma: WideString;
begin
  Buffer.Append(TDBXSQL.Nl);
  Buffer.Append(TDBXSQL.Spacing);
  Buffer.Append(TDBXSQL.OpenParen);
  Columns := IndexColumns.GetCurrentRows(TDBXIndexColumnsColumns.Ordinal);
  Columns.BeforeFirst;
  Comma := TDBXSQL.Empty;
  while Columns.Next do
  begin
    Buffer.Append(Comma);
    Comma := TDBXSQL.Comma + TDBXSQL.Space;
    MakeSqlIdentifier(Buffer, Columns.GetString(TDBXIndexColumnsIndex.ColumnName, NullString));
    if FReader.DescendingIndexColumnsSupported and not Columns.GetBoolean(TDBXIndexColumnsIndex.IsAscending, True) then
    begin
      Buffer.Append(TDBXSQL.Space);
      Buffer.Append(TDBXSQL.Descending);
    end;
  end;
  FreeAndNil(Columns);
  Buffer.Append(TDBXSQL.CloseParen);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlDropSecondaryIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage);
begin
  Buffer.Append(TDBXSQL.Drop);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Index);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlIdentifier(Buffer, Index.GetString(TDBXIndexesIndex.IndexName, NullString));
  if not IndexNamesGlobal then
  begin
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(TDBXSQL.&On);
    Buffer.Append(TDBXSQL.Space);
    MakeSqlObjectName(Buffer, Index.GetString(TDBXIndexesIndex.CatalogName, NullString), Index.GetString(TDBXIndexesIndex.SchemaName, NullString), Index.GetString(TDBXIndexesIndex.TableName, NullString));
  end;
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlForeignKeySyntax(Buffer: TDBXWideStringBuffer; ForeignKey: TDBXRowStorage; ForeignKeyColumns: TDBXTableStorage);
var
  Columns: TDBXTableStorage;
  Comma: WideString;
begin
  Buffer.Append(TDBXSQL.Foreign);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Key);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.OpenParen);
  Columns := ForeignKeyColumns.GetCurrentRows(TDBXForeignKeyColumnsColumns.Ordinal);
  Columns.BeforeFirst;
  Comma := TDBXSQL.Empty;
  while Columns.Next do
  begin
    Buffer.Append(Comma);
    Comma := TDBXSQL.Comma + TDBXSQL.Space;
    MakeSqlIdentifier(Buffer, Columns.GetString(TDBXForeignKeyColumnsIndex.ColumnName, NullString));
  end;
  Buffer.Append(TDBXSQL.CloseParen);
  Columns.BeforeFirst;
  Columns.Next;
  Buffer.Append(TDBXSQL.Nl);
  Buffer.Append(TDBXSQL.Spacing);
  Buffer.Append(TDBXSQL.References);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlObjectName(Buffer, Columns.GetString(TDBXForeignKeyColumnsIndex.PrimaryCatalogName, NullString), Columns.GetString(TDBXForeignKeyColumnsIndex.PrimarySchemaName, NullString), Columns.GetString(TDBXForeignKeyColumnsIndex.PrimaryTableName, NullString));
  Buffer.Append(TDBXSQL.OpenParen);
  Columns.BeforeFirst;
  Comma := TDBXSQL.Empty;
  while Columns.Next do
  begin
    Buffer.Append(Comma);
    Comma := TDBXSQL.Comma + TDBXSQL.Space;
    MakeSqlIdentifier(Buffer, Columns.GetString(TDBXForeignKeyColumnsIndex.PrimaryColumnName, NullString));
  end;
  Buffer.Append(TDBXSQL.CloseParen);
  FreeAndNil(Columns);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlCreateForeignKey(Buffer: TDBXWideStringBuffer; ForeignKey: TDBXRowStorage; ForeignKeyColumns: TDBXTableStorage);
begin
  MakeSqlCreateConstraint(Buffer, ForeignKey);
  MakeSqlForeignKeySyntax(Buffer, ForeignKey, ForeignKeyColumns);
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlDropForeignKey(Buffer: TDBXWideStringBuffer; ForeignKey: TDBXRowStorage);
begin
  MakeSqlDropConstraint(Buffer, ForeignKey);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlCreateView(Buffer: TDBXWideStringBuffer; View: TDBXRowStorage; Columns: TDBXTableStorage);
begin
  Buffer.Append(View.GetString(TDBXViewsIndex.Definition, NullString));
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlAlterView(Buffer: TDBXWideStringBuffer; View: TDBXRowStorage; Columns: TDBXTableStorage);
var
  Definition: WideString;
begin
  Definition := View.GetString(TDBXViewsIndex.Definition, NullString);
  Definition := Trim(Definition);
  if (Length(Definition) < Length(TDBXSQL.&Create)) or not (WideUpperCase(Copy(Definition,0+1,Length(TDBXSQL.&Create)-(0))) = TDBXSQL.&Create) then
    raise TDBXMetaDataError.Create(SWrongViewDefinition);
  Buffer.Append(TDBXSQL.Alter);
  Buffer.Append(Copy(Definition,Length(TDBXSQL.&Create)+1,Length(Definition)-(Length(TDBXSQL.&Create))));
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlDropView(Buffer: TDBXWideStringBuffer; View: TDBXRowStorage);
begin
  Buffer.Append(TDBXSQL.Drop);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.View);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlObjectName(Buffer, View.GetString(TDBXViewsIndex.CatalogName), View.GetString(TDBXViewsIndex.SchemaName), View.GetString(TDBXViewsIndex.ViewName));
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlCreateSynonym(Buffer: TDBXWideStringBuffer; Synonym: TDBXRowStorage; Columns: TDBXTableStorage);
begin
  Buffer.Append(TDBXSQL.&Create);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Synonym);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlObjectName(Buffer, Synonym.GetString(TDBXSynonymsIndex.CatalogName, NullString), Synonym.GetString(TDBXSynonymsIndex.SchemaName, NullString), Synonym.GetString(TDBXSynonymsIndex.SynonymName, NullString));
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.&For);
  MakeSqlObjectName(Buffer, Synonym.GetString(TDBXSynonymsIndex.TableCatalogName, NullString), Synonym.GetString(TDBXSynonymsIndex.TableSchemaName, NullString), Synonym.GetString(TDBXSynonymsIndex.TableName, NullString));
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlAlterSynonym(Buffer: TDBXWideStringBuffer; Synonym: TDBXRowStorage; Columns: TDBXTableStorage);
begin
  MakeSqlDropSynonym(Buffer, Synonym);
  MakeSqlCreateSynonym(Buffer, Synonym, Columns);
end;

procedure TDBXBaseMetaDataWriter.MakeSqlDropSynonym(Buffer: TDBXWideStringBuffer; Synonym: TDBXRowStorage);
begin
  Buffer.Append(TDBXSQL.Drop);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Synonym);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlObjectName(Buffer, Synonym.GetString(TDBXSynonymsIndex.CatalogName, NullString), Synonym.GetString(TDBXSynonymsIndex.SchemaName, NullString), Synonym.GetString(TDBXSynonymsIndex.SynonymName, NullString));
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

end.
