unit MetaDataLoader;

interface
uses
  DBXMetaDataReader,
  DBXMetaDataWriter,
  ADOProviderContext,
  DBXPlatformUtil,
  System.Collections,
  System.Configuration,
  System.Data,
  System.Data.Common,
  System.Text,
  System.Text.RegularExpressions,
  System.Threading;

type
  TMetaDataLoader = class
  private
    FWriter: TDBXMetaDataWriter;
    class var FDialects: TDBXStringStore;
  public
    class procedure RegisterConfiguration(Config: Configuration); static;
    constructor Create(DatabaseProductName: WideString; DatabaseVersion: WideString; ParameterMarker: WideString; MarkerIncludedInParameterName: Boolean; Connection: IDbConnection); overload;
    constructor Create(Connection: DbConnection); overload;
    function GetSchema(Filters: TDBXFilterProps): DataTable;
    procedure MakeSqlCreate(Builder: StringBuilder; Item: DataRow; Parts: DataTable);
    procedure MakeSqlAlter(Builder: StringBuilder; Item: DataRow; Parts: DataTable);
    procedure MakeSqlDrop(Builder: StringBuilder; Item: DataRow);
    procedure QuoteIfNeccessary(Builder: StringBuilder; Identifier: WideString);
  private
    function GetDatabaseProduct: WideString;
    function GetDatabaseVersion: WideString;
    function GetIdentifierQuotePrefix: WideString;
    function GetIdentifierQuoteSuffix: WideString;
    function GetIsCatalogsSupported: Boolean;
    function GetIsSchemasSupported: Boolean;
    function GetIsMultipleStatementsSupported: Boolean;
    function GetIsDescendingIndexSupported: Boolean;
    function GetIsDescendingIndexColumnsSupported: Boolean;
    function GetIsMixed_DDL_DML_Supported: Boolean;
    function GetIsDDLTransactionsSupported: Boolean;
  public
    property DatabaseProduct: WideString read GetDatabaseProduct;
    property DatabaseVersion: WideString read GetDatabaseVersion;
    property IdentifierQuotePrefix: WideString read GetIdentifierQuotePrefix;
    property IdentifierQuoteSuffix: WideString read GetIdentifierQuoteSuffix;
    property IsCatalogsSupported: Boolean read GetIsCatalogsSupported;
    property IsSchemasSupported: Boolean read GetIsSchemasSupported;
    property IsMultipleStatementsSupported: Boolean read GetIsMultipleStatementsSupported;
    property IsDescendingIndexSupported: Boolean read GetIsDescendingIndexSupported;
    property IsDescendingIndexColumnsSupported: Boolean read GetIsDescendingIndexColumnsSupported;
    property IsMixed_DDL_DML_Supported: Boolean read GetIsMixed_DDL_DML_Supported;
    property IsDDLTransactionsSupported: Boolean read GetIsDDLTransactionsSupported;

  private
    procedure InitLoader(DatabaseProductName: WideString; DatabaseVersion: WideString; ParameterMarker: WideString; MarkerIncludedInParameterName: Boolean; Connection: IDbConnection);
    class function GetProductName(Connection: DbConnection; out Version: WideString; out ParameterMarkerPattern: WideString; out ParameterNamePattern: WideString): WideString;
    procedure FindParameterMarker(ParameterMarkerPattern: WideString; ParameterNamePattern: WideString; out ParameterMarker: WideString; out MarkerIncludedInParameterName: Boolean);
    function GetConnectionType(Connection: IDbConnection): WideString;
    function IsFullMatch(Validator: Regex; Value: WideString): Boolean;
  end;

  TDBXFilterPropName = class
  public
    const MetaData = 'MetaData';
    const IndexName = 'IndexName';
    const PrimarySchemaName = 'PrimarySchemaName';
    const CatalogName = 'CatalogName';
    const SchemaName = 'SchemaName';
    const PackageName = 'PackageName';
    const ProcedureType = 'ProcedureType';
    const PrimaryCatalogName = 'PrimaryCatalogName';
    const SynonymName = 'SynonymName';
    const ViewName = 'ViewName';
    const PrimaryKeyName = 'PrimaryKeyName';
    const TableType = 'TableType';
    const PrimaryTableName = 'PrimaryTableName';
    const ForeignKeyName = 'ForeignKeyName';
    const ProcedureName = 'ProcedureName';
    const TableName = 'TableName';
    const ParameterName = 'ParameterName';
  end;

implementation
uses
  DBXTableStorage,
  DBXMetaDataNames,
  ADOTypedTableStorage,
  DataRowStorage,
  DataTableStorage,
  DialectConfigurationSection,
  SysUtils;

resourcestring
  SNoProductNameFound = 'No Product name found for Data Provider. No metadata can be provided.';
  SNoDialectForProduct = 'No metadata could be loaded for: %s.';
  SDialectTypeNotFound = 'Could not locate the type: %s.';

const
  QuestionParameterMarker = '?';
  AtSignParameterMarker = '@';
  ColonParameterMarker = ':';
  ParameterNameSample = 'TABLE_NAME';
  RowType = 'Row';

class procedure TMetaDataLoader.RegisterConfiguration(Config: Configuration);
var
  Section: TDialectConfigurationSection;
  Dialects: TMetaDataDialectCollection;
  Dialect: TMetaDataDialectElement;
  Index: Integer;
  Key: WideString;
begin
  Monitor.Enter(typeof(TMetaDataLoader));
  try
    if FDialects = nil then
      FDialects := TDBXStringStore.Create;
    Section := Config.GetSection(TDialectConfigurationSection.SectionName) as TDialectConfigurationSection;
    if Section <> nil then
    begin
      Dialects := Section.MetaDataDialects;
      for Index := 0 to Dialects.Count - 1 do
      begin
        Dialect := Dialects[Index];
        Key := TMetaDataDialectCollection.ProduceKey(Dialect.ProductName, Dialect.ConnectionType);
        FDialects[Key] := Dialect.DialectType;
      end;
    end;
  finally
    Monitor.Exit(typeof(TMetaDataLoader));
  end;
end;

constructor TMetaDataLoader.Create(DatabaseProductName: WideString; DatabaseVersion: WideString; ParameterMarker: WideString; MarkerIncludedInParameterName: Boolean; Connection: IDBConnection);
begin
  Inherited Create;
  InitLoader(DatabaseProductName, DatabaseVersion, ParameterMarker, MarkerIncludedInParameterName, Connection);
end;

constructor TMetaDataLoader.Create(Connection: DbConnection);
var
  Version, ParameterMarkerPattern, ParameterNamePattern, ProductName, ParameterMarker: WideString;
  MarkerIncludedInParameterName: Boolean;
begin
  Inherited Create;
  ProductName := GetProductName(Connection, Version, ParameterMarkerPattern, ParameterNamePattern);
  FindParameterMarker(ParameterMarkerPattern, ParameterNamePattern, ParameterMarker, MarkerIncludedInParameterName);
  InitLoader(ProductName, Version, ParameterMarker, MarkerIncludedInParameterName, Connection);
end;

function ToStorage(Table: DataTable; Collection: TDBXTableStorage): TDBXTableStorage;
begin
  Result := TDataTableStorage.Create(Collection.MetaDataCollectionIndex,Collection.MetaDataCollectionName,Table);
  Result.CopyFrom(Collection);
  Result.AcceptChanges;
  Collection.Close;
end;

function FetchCollection(Reader: TDBXBaseMetaDataReader; Filters: TDBXFilterProps): TDBXTableStorage;
var
  Table: WideString;
begin
  Table := Filters[TDBXFilterPropName.MetaData];
  if Table = TDBXMetaDataCollectionName.DataTypes then
    Result := ToStorage(TDataTypesTable.Create, Reader.FetchDataTypes)
  else if Table = TDBXMetaDataCollectionName.Catalogs then
    Result := ToStorage(TCatalogsTable.Create, Reader.FetchCatalogs)
  else if Table = TDBXMetaDataCollectionName.Schemas then
    Result := ToStorage(TSchemasTable.Create, Reader.FetchSchemas(Filters[TDBXFilterPropName.CatalogName]))
  else if Table = TDBXMetaDataCollectionName.Tables then
    Result := ToStorage(TTablesTable.Create, Reader.FetchTables(Filters[TDBXFilterPropName.CatalogName],Filters[TDBXFilterPropName.SchemaName],Filters[TDBXFilterPropName.TableName],Filters[TDBXFilterPropName.TableType]))
  else if Table = TDBXMetaDataCollectionName.Views then
    Result := ToStorage(TViewsTable.Create, Reader.FetchViews(Filters[TDBXFilterPropName.CatalogName],Filters[TDBXFilterPropName.SchemaName],Filters[TDBXFilterPropName.ViewName]))
  else if Table = TDBXMetaDataCollectionName.Synonyms then
    Result := ToStorage(TSynonymsTable.Create, Reader.FetchSynonyms(Filters[TDBXFilterPropName.CatalogName],Filters[TDBXFilterPropName.SchemaName],Filters[TDBXFilterPropName.SynonymName]))
  else if Table = TDBXMetaDataCollectionName.Columns then
    Result := ToStorage(TColumnsTable.Create, Reader.FetchColumns(Filters[TDBXFilterPropName.CatalogName],Filters[TDBXFilterPropName.SchemaName],Filters[TDBXFilterPropName.TableName]))
  else if Table = TDBXMetaDataCollectionName.Indexes then
    Result := ToStorage(TIndexesTable.Create, Reader.FetchIndexes(Filters[TDBXFilterPropName.CatalogName],Filters[TDBXFilterPropName.SchemaName],Filters[TDBXFilterPropName.TableName]))
  else if Table = TDBXMetaDataCollectionName.IndexColumns then
    Result := ToStorage(TIndexColumnsTable.Create, Reader.FetchIndexColumns(Filters[TDBXFilterPropName.CatalogName],Filters[TDBXFilterPropName.SchemaName],Filters[TDBXFilterPropName.TableName],Filters[TDBXFilterPropName.IndexName]))
  else if Table = TDBXMetaDataCollectionName.ForeignKeys then
    Result := ToStorage(TForeignKeysTable.Create, Reader.FetchForeignKeys(Filters[TDBXFilterPropName.CatalogName],Filters[TDBXFilterPropName.SchemaName],Filters[TDBXFilterPropName.TableName]))
  else if Table = TDBXMetaDataCollectionName.ForeignKeyColumns then
    Result := ToStorage(TForeignKeyColumnsTable.Create, Reader.FetchForeignKeyColumns(Filters[TDBXFilterPropName.CatalogName],Filters[TDBXFilterPropName.SchemaName],Filters[TDBXFilterPropName.TableName],Filters[TDBXFilterPropName.ForeignKeyName],Filters[TDBXFilterPropName.PrimaryCatalogName],Filters[TDBXFilterPropName.PrimarySchemaName],Filters[TDBXFilterPropName.PrimaryTableName],Filters[TDBXFilterPropName.PrimaryKeyName]))
  else if Table = TDBXMetaDataCollectionName.Procedures then
    Result := ToStorage(TProceduresTable.Create, Reader.FetchProcedures(Filters[TDBXFilterPropName.CatalogName],Filters[TDBXFilterPropName.SchemaName],Filters[TDBXFilterPropName.ProcedureName],Filters[TDBXFilterPropName.ProcedureType]))
  else if Table = TDBXMetaDataCollectionName.ProcedureSources then
    Result := ToStorage(TProcedureSourcesTable.Create, Reader.FetchProcedureSources(Filters[TDBXFilterPropName.CatalogName],Filters[TDBXFilterPropName.SchemaName],Filters[TDBXFilterPropName.ProcedureName]))
  else if Table = TDBXMetaDataCollectionName.ProcedureParameters then
    Result := ToStorage(TProcedureParametersTable.Create, Reader.FetchProcedureParameters(Filters[TDBXFilterPropName.CatalogName],Filters[TDBXFilterPropName.SchemaName],Filters[TDBXFilterPropName.ProcedureName],Filters[TDBXFilterPropName.ParameterName]))
  else if Table = TDBXMetaDataCollectionName.Packages then
    Result := ToStorage(TPackagesTable.Create, Reader.FetchPackages(Filters[TDBXFilterPropName.CatalogName],Filters[TDBXFilterPropName.SchemaName],Filters[TDBXFilterPropName.PackageName]))
  else if Table = TDBXMetaDataCollectionName.PackageSources then
    Result := ToStorage(TPackageSourcesTable.Create, Reader.FetchPackageSources(Filters[TDBXFilterPropName.CatalogName],Filters[TDBXFilterPropName.SchemaName],Filters[TDBXFilterPropName.PackageName]))
  else if Table = TDBXMetaDataCollectionName.Users then
    Result := ToStorage(TUsersTable.Create, Reader.FetchUsers)
  else if Table = TDBXMetaDataCollectionName.Roles then
    Result := ToStorage(TRolesTable.Create, Reader.FetchRoles)
  else if Table = TDBXMetaDataCollectionName.ReservedWords then
    Result := ToStorage(TReservedWordsTable.Create, Reader.FetchReservedWords)
  else
    Result := nil;
end;

function ToCollectionIndex(const CollectionName: WideString): Integer;
begin
  if CollectionName = TDBXMetaDataCollectionName.DataTypes then
    Result := TDBXMetaDataCollectionIndex.DataTypes
  else if CollectionName = TDBXMetaDataCollectionName.Catalogs then
    Result := TDBXMetaDataCollectionIndex.Catalogs
  else if CollectionName = TDBXMetaDataCollectionName.Schemas then
    Result := TDBXMetaDataCollectionIndex.Schemas
  else if CollectionName = TDBXMetaDataCollectionName.Tables then
    Result := TDBXMetaDataCollectionIndex.Tables
  else if CollectionName = TDBXMetaDataCollectionName.Views then
    Result := TDBXMetaDataCollectionIndex.Views
  else if CollectionName = TDBXMetaDataCollectionName.Synonyms then
    Result := TDBXMetaDataCollectionIndex.Synonyms
  else if CollectionName = TDBXMetaDataCollectionName.Columns then
    Result := TDBXMetaDataCollectionIndex.Columns
  else if CollectionName = TDBXMetaDataCollectionName.Indexes then
    Result := TDBXMetaDataCollectionIndex.Indexes
  else if CollectionName = TDBXMetaDataCollectionName.IndexColumns then
    Result := TDBXMetaDataCollectionIndex.IndexColumns
  else if CollectionName = TDBXMetaDataCollectionName.ForeignKeys then
    Result := TDBXMetaDataCollectionIndex.ForeignKeys
  else if CollectionName = TDBXMetaDataCollectionName.ForeignKeyColumns then
    Result := TDBXMetaDataCollectionIndex.ForeignKeyColumns
  else if CollectionName = TDBXMetaDataCollectionName.Procedures then
    Result := TDBXMetaDataCollectionIndex.Procedures
  else if CollectionName = TDBXMetaDataCollectionName.ProcedureSources then
    Result := TDBXMetaDataCollectionIndex.ProcedureSources
  else if CollectionName = TDBXMetaDataCollectionName.ProcedureParameters then
    Result := TDBXMetaDataCollectionIndex.ProcedureParameters
  else if CollectionName = TDBXMetaDataCollectionName.Packages then
    Result := TDBXMetaDataCollectionIndex.Packages
  else if CollectionName = TDBXMetaDataCollectionName.PackageSources then
    Result := TDBXMetaDataCollectionIndex.PackageSources
  else if CollectionName = TDBXMetaDataCollectionName.Users then
    Result := TDBXMetaDataCollectionIndex.Users
  else if CollectionName = TDBXMetaDataCollectionName.Roles then
    Result := TDBXMetaDataCollectionIndex.Roles
  else if CollectionName = TDBXMetaDataCollectionName.ReservedWords then
    Result := TDBXMetaDataCollectionIndex.ReservedWords
  else
    Result := 0;
end;

function MakeRowStorage(Item: DataRow): TDBXRowStorage;
var
  CollectionName: WideString;
  CollectionIndex: Integer;
  TypeName: WideString;
begin
  if (Item <> nil) and (Item.Table <> nil) then
    CollectionName := Item.Table.TableName
  else
    CollectionName := nil;
  if (CollectionName = nil) then
  begin
    TypeName := Item.GetType().Name;
    if (TypeName.EndsWith(RowType)) then
      CollectionName := TypeName.Substring(0, TypeName.Length - RowType.Length);
  end;
  CollectionIndex := ToCollectionIndex(CollectionName);
  Result := TDataRowStorage.Create(CollectionIndex, CollectionName, Item);
end;

function MakeTableStorage(Table: DataTable): TDBXTableStorage;
var
  CollectionName: WideString;
  CollectionIndex: Integer;
begin
  CollectionName := Table.TableName;
  CollectionIndex := ToCollectionIndex(CollectionName);
  Result := TDataTableStorage.Create(CollectionIndex, CollectionName, Table);
end;

function TMetaDataLoader.GetSchema(Filters: TDBXFilterProps): DataTable;
var
  Table: TDBXTableStorage;
  Data: DataTable;
begin
  Table := FetchCollection(TDBXBaseMetaDataReader(FWriter.MetaDataReader), Filters);
  Data := DataTable(Table.Storage);
  Data.AcceptChanges();
  Result := Data;
end;

procedure TMetaDataLoader.MakeSqlCreate(Builder: StringBuilder; Item: DataRow; Parts: DataTable);
begin
  FWriter.MakeSqlCreate(Builder, MakeRowStorage(Item), MakeTableStorage(Parts));
end;

procedure TMetaDataLoader.MakeSqlAlter(Builder: StringBuilder; Item: DataRow; Parts: DataTable);
begin
  FWriter.MakeSqlAlter(Builder, MakeRowStorage(Item), MakeTableStorage(Parts));
end;

procedure TMetaDataLoader.MakeSqlDrop(Builder: StringBuilder; Item: DataRow);
begin
  FWriter.MakeSqlDrop(Builder, MakeRowStorage(Item));
end;

procedure TMetaDataLoader.QuoteIfNeccessary(Builder: StringBuilder; Identifier: WideString);
begin
  FWriter.MakeSqlIdentifier(Builder, Identifier);
end;

function TMetaDataLoader.GetDatabaseProduct: WideString;
begin
  Result := FWriter.MetaDataReader.ProductName;
end;

function TMetaDataLoader.GetDatabaseVersion: WideString;
begin
  Result := FWriter.MetaDataReader.Version;
end;

function TMetaDataLoader.GetIdentifierQuotePrefix: WideString;
begin
  Result := FWriter.MetaDataReader.SqlIdentifierQuotePrefix;
end;

function TMetaDataLoader.GetIdentifierQuoteSuffix: WideString;
begin
  Result := FWriter.MetaDataReader.SqlIdentifierQuoteSuffix;
end;

function TMetaDataLoader.GetIsCatalogsSupported: Boolean;
begin
  Result := FWriter.CatalogsSupported;
end;

function TMetaDataLoader.GetIsSchemasSupported: Boolean;
begin
  Result := FWriter.SchemasSupported;
end;

function TMetaDataLoader.GetIsMultipleStatementsSupported: Boolean;
begin
  Result := FWriter.MultipleStatementsSupported;
end;

function TMetaDataLoader.GetIsDescendingIndexSupported: Boolean;
begin
  Result := FWriter.MetaDataReader.DescendingIndexSupported;
end;

function TMetaDataLoader.GetIsDescendingIndexColumnsSupported: Boolean;
begin
  Result := FWriter.MetaDataReader.DescendingIndexColumnsSupported;
end;

function TMetaDataLoader.GetIsMixed_DDL_DML_Supported: Boolean;
begin
  Result := FWriter.Mixed_DDL_DML_Supported;
end;

function TMetaDataLoader.GetIsDDLTransactionsSupported: Boolean;
begin
  Result := FWriter.DDLTransactionsSupported;
end;

procedure TMetaDataLoader.InitLoader(DatabaseProductName: WideString; DatabaseVersion: WideString; ParameterMarker: WideString; MarkerIncludedInParameterName: Boolean; Connection: IDbConnection);
const
  InterbaseProduct = 'InterBase';                { Do not localize }
  FirebirdProduct = 'Firebird';                { Do not localize }
  OracleProduct    = 'Oracle';                   { Do not localize }
  SybaseASEProduct = 'Sybase SQL Server';        { Do not localize }
  SybaseASAProduct = 'Adaptive Server Anywhere'; { Do not localize }
  Db2Product       = 'Db2';                      { Do not localize }
  InformixProduct  = 'Informix Dynamic Server';  { Do not localize }
var
  ConnectionType: WideString;
  DialectTypename: WideString;
  DialectType: System.Type;
  Key1, Key2: WideString;
  Reader: TDBXMetaDataReader;
  Context: TADOProviderContext;
begin
  if (DatabaseProductName = nil) or (DatabaseProductName.Length = 0) then
    raise Exception.Create(SNoProductNameFound);
  ConnectionType := GetConnectionType(Connection);
  DialectTypeName := nil;
  Key1 := TMetaDataDialectCollection.ProduceKey(DatabaseProductName, ConnectionType);
  Key2 := TMetaDataDialectCollection.ProduceKey(DatabaseProductName, nil);
  if FDialects.Contains(Key1) then
    DialectTypeName := FDialects[Key1]
  else if FDialects.Contains(Key2) then
    DialectTypeName := FDialects[Key2];
  if DialectTypeName = nil then
    raise Exception.Create(Format(SNoDialectForProduct, [databaseProductName]));
  DialectType := System.Type.GetType(DialectTypeName);
  if DialectType = nil then
    raise Exception.Create(Format(SDialectTypeNotFound, [DialectTypeName]));
  Context := TADOProviderContext.Create;
  Context.Connection := Connection;
  Context.SqlParameterMarker := ParameterMarker;
  Context.IsMarkerIncludedInParameterName := MarkerIncludedInParameterName;
  FWriter := TDBXMetaDataWriter(Activator.CreateInstance(DialectType));
  FWriter.Context := Context;
  Reader := FWriter.MetaDataReader;
  Reader.Context := Context;
  Reader.Version := DatabaseVersion;
  Context.UseAnsiStrings := (Reader.ProductName = InterbaseProduct) or (Reader.ProductName = FirebirdProduct) or (Reader.ProductName = OracleProduct) or
                            (Reader.ProductName = SybaseASAProduct) or (Reader.ProductName = SybaseASEProduct) or (Reader.ProductName = Db2Product) or (Reader.ProductName = InformixProduct);
end;

class function TMetaDataLoader.GetProductName(Connection: DbConnection; out Version: WideString; out ParameterMarkerPattern: WideString; out ParameterNamePattern: WideString): WideString;
var
  ProductName: WideString;
  Inner: Exception;
  Schema: DataTable;
  MarkerPattern, NamePattern: TObject;
begin
  ProductName := nil;
  Inner := nil;
  Version := nil;
  ParameterMarkerPattern := nil;
  ParameterNamePattern := nil;
  try
    Schema := Connection.GetSchema(DbMetaDataCollectionNames.DataSourceInformation);
    if (schema <> nil) and (schema.Rows.Count > 0) then
    begin
      ProductName := Schema.Rows[0][DbMetaDataColumnNames.DataSourceProductName] as WideString;
      version := Schema.Rows[0][DbMetaDataColumnNames.DataSourceProductVersionNormalized] as WideString;
      MarkerPattern := Schema.Rows[0][DbMetaDataColumnNames.ParameterMarkerPattern];
      NamePattern := Schema.Rows[0][DbMetaDataColumnNames.ParameterNamePattern];
      if MarkerPattern <> DBNull.Value then
        ParameterMarkerPattern := MarkerPattern as WideString;
      if NamePattern <> DBNull.Value then
        ParameterNamePattern := NamePattern as WideString;
    end;
    Schema.Clear();
  except
    on Ex: Exception do
    begin
      ProductName := nil;
      Inner := Ex;
    end;
  end;
  if (ProductName = nil) or (ProductName.Length = 0) then
    raise Exception.Create(SNoProductNameFound, Inner);
  Result := ProductName;
end;

procedure TMetaDataLoader.FindParameterMarker(ParameterMarkerPattern: WideString; ParameterNamePattern: WideString; out ParameterMarker: WideString; out MarkerIncludedInParameterName: Boolean);
var
  Validator: Regex;
begin
  ParameterMarker := nil;
  MarkerIncludedInParameterName := False;
  if (ParameterMarkerPattern <> nil) and not (ParameterMarkerPattern = QuestionParameterMarker) then
  begin
    Validator := Regex.Create(ParameterMarkerPattern);
    if IsFullMatch(Validator, AtSignParameterMarker + ParameterNameSample) then
      ParameterMarker := AtSignParameterMarker
    else if IsFullMatch(Validator, ColonParameterMarker + ParameterNameSample) then
      ParameterMarker := ColonParameterMarker
    else if IsFullMatch(Validator, QuestionParameterMarker + ParameterNameSample) then
      ParameterMarker := ColonParameterMarker;
    if (ParameterMarker <> nil) and (parameterNamePattern <> nil) then
    begin
      Validator := Regex.Create(ParameterNamePattern);
      if IsFullMatch(Validator, ParameterMarker + ParameterNameSample) then
        MarkerIncludedInParameterName := True;
    end;
  end;
end;

function TMetaDataLoader.GetConnectionType(Connection: IDbConnection): WideString;
var
  ConnectionType: System.Type;
begin
  ConnectionType := TObject(Connection).GetType();
  Result := ConnectionType.AssemblyQualifiedName;
end;

function TMetaDataLoader.IsFullMatch(Validator: Regex; Value: WideString): Boolean;
var
  MatchResult: Match;
begin
  MatchResult := validator.Match(value);
  Result := MatchResult.Success and (MatchResult.Length = Value.Length);
end;

end.

