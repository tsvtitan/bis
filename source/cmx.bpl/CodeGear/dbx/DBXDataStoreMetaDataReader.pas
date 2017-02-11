{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXDataStoreMetaDataReader;
interface
uses
  DBXMetaDataReader,
  DBXPlatformUtil,
  DBXTableStorage;
type
  TDBXDataStoreCustomMetaDataReader = class(TDBXBaseMetaDataReader)
  public
    function FetchCollection(const MetaDataCommand: WideString): TDBXTableStorage; override;
    function FetchDataTypes: TDBXTableStorage; override;
    function FetchSchemas(const Catalog: WideString): TDBXTableStorage; override;
    function FetchTables(const Catalog: WideString; const Schema: WideString; const TableName: WideString; const TableType: WideString): TDBXTableStorage; override;
    function FetchViews(const Catalog: WideString; const Schema: WideString; const View: WideString): TDBXTableStorage; override;
    function FetchColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage; override;
    function FetchIndexes(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage; override;
    function FetchIndexColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const Index: WideString): TDBXTableStorage; override;
    function FetchForeignKeys(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage; override;
    function FetchForeignKeyColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const ForeignKeyName: WideString; const PrimaryCatalog: WideString; const PrimarySchema: WideString; const PrimaryTable: WideString; const PrimaryKeyName: WideString): TDBXTableStorage; override;
    function FetchProcedures(const Catalog: WideString; const Schema: WideString; const ProcedureName: WideString; const ProcedureType: WideString): TDBXTableStorage; override;
    function FetchProcedureSources(const Catalog: WideString; const Schema: WideString; const &Procedure: WideString): TDBXTableStorage; override;
    function FetchProcedureParameters(const Catalog: WideString; const Schema: WideString; const &Procedure: WideString; const Parameter: WideString): TDBXTableStorage; override;
    function FetchUsers: TDBXTableStorage; override;
    function FetchRoles: TDBXTableStorage; override;
    function FetchReservedWords: TDBXTableStorage; override;
  protected
    procedure PopulateDataTypes(Hash: TDBXObjectStore; Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray); override;
    function IsVersion7: Boolean;
  private
    function MapDataStoreType(DatastoreType: Integer): Integer;
    procedure FailIfVersion7;
  private
    FVersion7: Integer;
  private
    property Version7: Boolean read IsVersion7;
  public
    const ByteType = 2;
    const ShortType = 3;
    const IntType = 4;
    const LongType = 5;
    const FloatType = 6;
    const DoubleType = 7;
    const BigdecimalType = 10;
    const BooleanType = 11;
    const BinaryStreamType = 12;
    const DateType = 13;
    const TimeType = 14;
    const TimestampType = 15;
    const StringType = 16;
    const ObjectType = 17;
    const ByteArrayType = 18;
  end;

  TDBXDataStoreMetaDataReader = class(TDBXDataStoreCustomMetaDataReader)
  public
    function FetchCatalogs: TDBXTableStorage; override;
    function FetchSynonyms(const CatalogName: WideString; const SchemaName: WideString; const SynonymName: WideString): TDBXTableStorage; override;
    function FetchColumnConstraints(const CatalogName: WideString; const SchemaName: WideString; const TableName: WideString): TDBXTableStorage; override;
    function FetchPackages(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString): TDBXTableStorage; override;
    function FetchPackageProcedures(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString; const ProcedureName: WideString; const ProcedureType: WideString): TDBXTableStorage; override;
    function FetchPackageProcedureParameters(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString; const ProcedureName: WideString; const ParameterName: WideString): TDBXTableStorage; override;
    function FetchPackageSources(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString): TDBXTableStorage; override;
  protected
    function GetProductName: WideString; override;
    function GetSqlForSchemas: WideString; override;
    function GetSqlForTables: WideString; override;
    function GetSqlForViews: WideString; override;
    function GetSqlForColumns: WideString; override;
    function GetSqlForIndexes: WideString; override;
    function GetSqlForIndexColumns: WideString; override;
    function GetSqlForForeignKeys: WideString; override;
    function GetSqlForForeignKeyColumns: WideString; override;
    function GetSqlForProcedures: WideString; override;
    function GetSqlForProcedureSources: WideString; override;
    function GetSqlForProcedureParameters: WideString; override;
    function GetSqlForUsers: WideString; override;
    function GetSqlForRoles: WideString; override;
    function GetSqlForDataTypes: WideString; override;
    function GetSqlForReservedWords: WideString; override;
  end;

resourcestring
  SCannotLoadMetaDataForJds7 = 'MetaData cannot be provided from a BlackfishSQL server older than version 8.0';

implementation
uses
  DBXCommon,
  DBXMetaDataError,
  DBXMetaDataNames,
  SysUtils;

function TDBXDataStoreCustomMetaDataReader.MapDataStoreType(DatastoreType: Integer): Integer;
begin
  case DatastoreType of
    ByteType:
      Result := TDBXDataTypesEx.Int8Type;
    ShortType:
      Result := TDBXDataTypes.Int16Type;
    IntType:
      Result := TDBXDataTypes.Int32Type;
    LongType:
      Result := TDBXDataTypes.Int64Type;
    FloatType:
      Result := TDBXDataTypesEx.SingleType;
    DoubleType:
      Result := TDBXDataTypes.DoubleType;
    BigdecimalType:
      Result := TDBXDataTypes.BcdType;
    BooleanType:
      Result := TDBXDataTypes.BooleanType;
    BinaryStreamType:
      Result := TDBXDataTypes.BlobType;
    DateType:
      Result := TDBXDataTypes.DateType;
    TimeType:
      Result := TDBXDataTypes.TimeType;
    TimestampType:
      Result := TDBXDataTypes.TimestampType;
    StringType:
      Result := TDBXDataTypes.WideStringType;
    ObjectType:
      Result := TDBXDataTypesEx.ObjectType;
    ByteArrayType:
      Result := TDBXDataTypes.BlobType;
    else
      Result := TDBXDataTypes.BlobType;
  end;
end;

procedure TDBXDataStoreCustomMetaDataReader.PopulateDataTypes(Hash: TDBXObjectStore; Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray);
var
  Cursor: TDBXTableStorage;
  TypeName: WideString;
  MinimumVersion: WideString;
  MaximumVersion: WideString;
  DataType: Integer;
  ColumnSize: Int64;
  CreateFormat: WideString;
  CreateParams: WideString;
  MaxScale: Integer;
  MinScale: Integer;
  Prefix: WideString;
  Suffix: WideString;
  Flags: Integer;
  TypeDescription: TDBXDataTypeDescription;
begin
  Cursor := FContext.ExecuteQuery(SqlForDataTypes, nil, nil);
  while Cursor.Next do
  begin
    TypeName := Cursor.GetString(TDBXDataTypesIndex.TypeName);
    MinimumVersion := Cursor.GetString(TDBXDataTypesIndex.MinimumVersion);
    MaximumVersion := Cursor.GetString(TDBXDataTypesIndex.MaximumVersion);
    if (not Hash.ContainsKey(TypeName) and ((StringIsNil(MinimumVersion)) or (Length(MinimumVersion) = 0) or (CompareVersion(MinimumVersion) >= 0)) and ((StringIsNil(MaximumVersion)) or (Length(MaximumVersion) = 0) or (CompareVersion(MaximumVersion) <= 0))) then
    begin
      DataType := MapDataStoreType(Cursor.GetInt32(TDBXDataTypesIndex.DbxDataType, TDBXDataTypes.UnknownType));
      ColumnSize := Cursor.GetInt64(TDBXDataTypesIndex.ColumnSize, -1);
      CreateFormat := Cursor.GetString(TDBXDataTypesIndex.CreateFormat, NullString);
      CreateParams := Cursor.GetString(TDBXDataTypesIndex.CreateParameters, NullString);
      MaxScale := Cursor.GetInt16(TDBXDataTypesIndex.MaximumScale);
      MinScale := Cursor.GetInt16(TDBXDataTypesIndex.MinimumScale);
      Prefix := Cursor.GetString(TDBXDataTypesIndex.LiteralPrefix, NullString);
      Suffix := Cursor.GetString(TDBXDataTypesIndex.LiteralSuffix, NullString);
      Flags := 0;
      if Cursor.GetBoolean(TDBXDataTypesIndex.IsAutoIncrementable, False) then
        Flags := Flags or TDBXTypeFlag.AutoIncrementable;
      if Cursor.GetBoolean(TDBXDataTypesIndex.IsBestMatch, False) then
        Flags := Flags or TDBXTypeFlag.BestMatch;
      if Cursor.GetBoolean(TDBXDataTypesIndex.IsCaseSensitive, False) then
        Flags := Flags or TDBXTypeFlag.CaseSensitive;
      if Cursor.GetBoolean(TDBXDataTypesIndex.IsFixedLength, False) then
        Flags := Flags or TDBXTypeFlag.FixedLength;
      if Cursor.GetBoolean(TDBXDataTypesIndex.IsFixedPrecisionScale, False) then
        Flags := Flags or TDBXTypeFlag.FixedPrecisionScale;
      if Cursor.GetBoolean(TDBXDataTypesIndex.IsLong, False) then
        Flags := Flags or TDBXTypeFlag.Long;
      if Cursor.GetBoolean(TDBXDataTypesIndex.IsNullable, False) then
        Flags := Flags or TDBXTypeFlag.Nullable;
      if Cursor.GetBoolean(TDBXDataTypesIndex.IsSearchable, False) then
        Flags := Flags or TDBXTypeFlag.Searchable;
      if Cursor.GetBoolean(TDBXDataTypesIndex.IsSearchableWithLike, False) then
        Flags := Flags or TDBXTypeFlag.SearchableWithLike;
      if Cursor.GetBoolean(TDBXDataTypesIndex.IsUnsigned, False) then
        Flags := Flags or TDBXTypeFlag.Unsigned;
      if Cursor.GetBoolean(TDBXDataTypesIndex.IsConcurrencyType, False) then
        Flags := Flags or TDBXTypeFlag.ConcurrencyType;
      if Cursor.GetBoolean(TDBXDataTypesIndex.IsLiteralSupported, False) then
        Flags := Flags or TDBXTypeFlag.LiteralSupported;
      if Cursor.GetBoolean(TDBXDataTypesIndex.IsUnicode, False) then
        Flags := Flags or TDBXTypeFlag.Unicode;
      if (DataType = TDBXDataTypes.WideStringType) or (DataType = TDBXDataTypes.BlobType) then
        Flags := Flags or TDBXTypeFlag.LongOption;
      TypeDescription := TDBXDataTypeDescription.Create(TypeName, DataType, ColumnSize, CreateFormat, CreateParams, MaxScale, MinScale, Prefix, Suffix, MaximumVersion, MinimumVersion, Flags);
      Hash[TypeName] := TypeDescription;
      Types.Add(TypeDescription);
    end;
  end;
  Cursor.Close;
  FreeAndNil(Cursor);
end;

function TDBXDataStoreCustomMetaDataReader.IsVersion7: Boolean;
begin
  if FVersion7 = 0 then
    FVersion7 := WideCompareStr(Version,'08');
  Result := (FVersion7 < 0);
end;

procedure TDBXDataStoreCustomMetaDataReader.FailIfVersion7;
begin
  if Version7 then
    raise TDBXMetaDataError.Create(SCannotLoadMetaDataForJds7);
end;

function TDBXDataStoreCustomMetaDataReader.FetchCollection(const MetaDataCommand: WideString): TDBXTableStorage;
begin
  if (not StringIsNil(MetaDataCommand)) and not (MetaDataCommand = TDBXMetaDataCommands.GetDatabase) then
    FailIfVersion7;
  Result := inherited FetchCollection(MetaDataCommand);
end;

// ---------------------------------------------------------------------------
// This section can be eliminated when MetaDataLoader.pas is no longer used !
//
// DataExplorer and ASP.NET for Delphi are using MetaDataLoader.pas now (oct 2007)
function TDBXDataStoreCustomMetaDataReader.FetchDataTypes: TDBXTableStorage;
begin
  FailIfVersion7;
  Result := inherited FetchDataTypes;
end;

function TDBXDataStoreCustomMetaDataReader.FetchSchemas(const Catalog: WideString): TDBXTableStorage;
begin
  FailIfVersion7;
  Result := inherited FetchSchemas(Catalog);
end;

function TDBXDataStoreCustomMetaDataReader.FetchTables(const Catalog: WideString; const Schema: WideString; const TableName: WideString; const TableType: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  if Version7 then
  begin
    Columns := TDBXMetaDataCollectionColumns.CreateTablesColumns;
    Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Tables, TDBXMetaDataCollectionName.Tables, Columns);
  end
  else 
    Result := inherited FetchTables(Catalog, Schema, TableName, TableType);
end;

function TDBXDataStoreCustomMetaDataReader.FetchViews(const Catalog: WideString; const Schema: WideString; const View: WideString): TDBXTableStorage;
begin
  FailIfVersion7;
  Result := inherited FetchViews(Catalog, Schema, View);
end;

function TDBXDataStoreCustomMetaDataReader.FetchColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  if Version7 then
  begin
    Columns := TDBXMetaDataCollectionColumns.CreateColumnsColumns;
    Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Columns, TDBXMetaDataCollectionName.Columns, Columns);
  end
  else 
    Result := inherited FetchColumns(Catalog, Schema, Table);
end;

function TDBXDataStoreCustomMetaDataReader.FetchIndexes(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage;
begin
  FailIfVersion7;
  Result := inherited FetchIndexes(Catalog, Schema, Table);
end;

function TDBXDataStoreCustomMetaDataReader.FetchIndexColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const Index: WideString): TDBXTableStorage;
begin
  FailIfVersion7;
  Result := inherited FetchIndexColumns(Catalog, Schema, Table, Index);
end;

function TDBXDataStoreCustomMetaDataReader.FetchForeignKeys(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage;
begin
  FailIfVersion7;
  Result := inherited FetchForeignKeys(Catalog, Schema, Table);
end;

function TDBXDataStoreCustomMetaDataReader.FetchForeignKeyColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const ForeignKeyName: WideString; const PrimaryCatalog: WideString; const PrimarySchema: WideString; const PrimaryTable: WideString; const PrimaryKeyName: WideString): TDBXTableStorage;
begin
  FailIfVersion7;
  Result := inherited FetchForeignKeyColumns(Catalog, Schema, Table, ForeignKeyName, PrimaryCatalog, PrimarySchema, PrimaryTable, PrimaryKeyName);
end;

function TDBXDataStoreCustomMetaDataReader.FetchProcedures(const Catalog: WideString; const Schema: WideString; const ProcedureName: WideString; const ProcedureType: WideString): TDBXTableStorage;
begin
  FailIfVersion7;
  Result := inherited FetchProcedures(Catalog, Schema, ProcedureName, ProcedureType);
end;

function TDBXDataStoreCustomMetaDataReader.FetchProcedureSources(const Catalog: WideString; const Schema: WideString; const &Procedure: WideString): TDBXTableStorage;
begin
  FailIfVersion7;
  Result := inherited FetchProcedureSources(Catalog, Schema, &Procedure);
end;

function TDBXDataStoreCustomMetaDataReader.FetchProcedureParameters(const Catalog: WideString; const Schema: WideString; const &Procedure: WideString; const Parameter: WideString): TDBXTableStorage;
begin
  FailIfVersion7;
  Result := inherited FetchProcedureParameters(Catalog, Schema, &Procedure, Parameter);
end;

function TDBXDataStoreCustomMetaDataReader.FetchUsers: TDBXTableStorage;
begin
  FailIfVersion7;
  Result := inherited FetchUsers;
end;

function TDBXDataStoreCustomMetaDataReader.FetchRoles: TDBXTableStorage;
begin
  FailIfVersion7;
  Result := inherited FetchRoles;
end;

function TDBXDataStoreCustomMetaDataReader.FetchReservedWords: TDBXTableStorage;
begin
  FailIfVersion7;
  Result := inherited FetchReservedWords;
end;
// ---------------------------------------------------------------------------

function TDBXDataStoreMetaDataReader.GetProductName: WideString;
begin
  Result := 'BlackfishSQL';
end;

function TDBXDataStoreMetaDataReader.FetchCatalogs: TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateCatalogsColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Catalogs, TDBXMetaDataCollectionName.Catalogs, Columns);
end;

function TDBXDataStoreMetaDataReader.GetSqlForSchemas: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_SCHEMAS(:CATALOG_NAME)';
end;

function TDBXDataStoreMetaDataReader.GetSqlForTables: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_TABLES_EXT(:CATALOG_NAME,:SCHEMA_NAME,:TABLE_NAME,:TABLES,:VIEWS,:SYSTEM_TABLES,:SYSTEM_VIEWS,:SYNONYMS)';
end;

function TDBXDataStoreMetaDataReader.GetSqlForViews: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_VIEWS(:CATALOG_NAME,:SCHEMA_NAME,:VIEW_NAME)';
end;

function TDBXDataStoreMetaDataReader.GetSqlForColumns: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_COLUMNS(:CATALOG_NAME,:SCHEMA_NAME,:TABLE_NAME,NULL)';
end;

function TDBXDataStoreMetaDataReader.GetSqlForIndexes: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_INDEXES(:CATALOG_NAME,:SCHEMA_NAME,:TABLE_NAME)';
end;

function TDBXDataStoreMetaDataReader.GetSqlForIndexColumns: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_INDEX_COLUMNS(:CATALOG_NAME,:SCHEMA_NAME,:TABLE_NAME,:INDEX_NAME)';
end;

function TDBXDataStoreMetaDataReader.GetSqlForForeignKeys: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_FOREIGN_KEYS(:CATALOG_NAME,:SCHEMA_NAME,:TABLE_NAME)';
end;

function TDBXDataStoreMetaDataReader.GetSqlForForeignKeyColumns: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_FOREIGN_KEY_COLUMNS(:CATALOG_NAME,:SCHEMA_NAME,:TABLE_NAME,:FOREIGN_KEY_NAME,:PRIMARY_CATALOG_NAME,:PRIMARY_SCHEMA_NAME,:PRIMARY_TABLE_NAME,:PRIMARY_KEY_NAME)';
end;

function TDBXDataStoreMetaDataReader.FetchSynonyms(const CatalogName: WideString; const SchemaName: WideString; const SynonymName: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateSynonymsColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Synonyms, TDBXMetaDataCollectionName.Synonyms, Columns);
end;

function TDBXDataStoreMetaDataReader.GetSqlForProcedures: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_PROCEDURES(:CATALOG_NAME,:SCHEMA_NAME,:PROCEDURE_NAME,:PROCEDURE_TYPE)';
end;

function TDBXDataStoreMetaDataReader.GetSqlForProcedureSources: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_PROCEDURES(:CATALOG_NAME,:SCHEMA_NAME,:PROCEDURE_NAME,NULL)';
end;

function TDBXDataStoreMetaDataReader.GetSqlForProcedureParameters: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_PROCEDURE_COLUMNS(:CATALOG_NAME,:SCHEMA_NAME,:PROCEDURE_NAME,:PARAMETER_NAME)';
end;

function TDBXDataStoreMetaDataReader.FetchColumnConstraints(const CatalogName: WideString; const SchemaName: WideString; const TableName: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateColumnConstraintsColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.ColumnConstraints, TDBXMetaDataCollectionName.ColumnConstraints, Columns);
end;

function TDBXDataStoreMetaDataReader.FetchPackages(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreatePackagesColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Packages, TDBXMetaDataCollectionName.Packages, Columns);
end;

function TDBXDataStoreMetaDataReader.FetchPackageProcedures(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString; const ProcedureName: WideString; const ProcedureType: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreatePackageProceduresColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.PackageProcedures, TDBXMetaDataCollectionName.PackageProcedures, Columns);
end;

function TDBXDataStoreMetaDataReader.FetchPackageProcedureParameters(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString; const ProcedureName: WideString; const ParameterName: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreatePackageProcedureParametersColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.PackageProcedureParameters, TDBXMetaDataCollectionName.PackageProcedureParameters, Columns);
end;

function TDBXDataStoreMetaDataReader.FetchPackageSources(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreatePackageSourcesColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.PackageSources, TDBXMetaDataCollectionName.PackageSources, Columns);
end;

function TDBXDataStoreMetaDataReader.GetSqlForUsers: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_USERS()';
end;

function TDBXDataStoreMetaDataReader.GetSqlForRoles: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_ROLES()';
end;

function TDBXDataStoreMetaDataReader.GetSqlForDataTypes: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_DATATYPES()';
end;

function TDBXDataStoreMetaDataReader.GetSqlForReservedWords: WideString;
begin
  Result := 'CALL DB_ADMIN.GET_KEYWORDS()';
end;

end.
