{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

{$HINTS OFF}

unit DBXMetaDataReader;
interface
uses
  DBXPlatformUtil,
  DBXSqlScanner,
  DBXTableStorage;
type
  TDBXDataTypeDescription = class;
  TDBXPlatformTypeNames = class;
  TDBXProviderContext = class;
  TDBXDataTypeDescriptionArray = array of TDBXDataTypeDescription;

  TDBXDataTypeDescription = class
  public
    constructor Create(const TypeName: WideString; const DataType: Integer; const ColumnSize: Int64; const CreateFormat: WideString; const CreateParams: WideString; const MaxScale: Integer; const MinScale: Integer; const LiteralPrefix: WideString; const LiteralSuffix: WideString; const MaxVersion: WideString; const MinVersion: WideString; const Flags: Integer); overload;
    constructor Create(Original: TDBXDataTypeDescription); overload;
    function GetDataType(const TypeNames: TDBXPlatformTypeNames): WideString;
  protected
    function IsAutoIncrementable: Boolean;
    function IsBestMatch: Boolean;
    function IsCaseSensitive: Boolean;
    function IsFixedLength: Boolean;
    function IsFixedPrecisionScale: Boolean;
    function IsLong: Boolean;
    function IsNullable: Boolean;
    function IsSearchable: Boolean;
    function IsSearchableWithLike: Boolean;
    function IsUnsigned: Boolean;
    function IsUnicode: Boolean;
    function IsUnicodeOptionSupported: Boolean;
    procedure SetUnicodeOptionSupported(Supported: Boolean);
    function IsUnsignedOptionSupported: Boolean;
    function IsStringOptionSupported: Boolean;
    function IsLongOptionSupported: Boolean;
    function GetMaximumScale: SmallInt;
    function GetMinimumScale: SmallInt;
    function IsConcurrencyType: Boolean;
    function IsLiteralSupported: Boolean;
  private
    function IsFlagSet(Flag: Integer): Boolean;
    procedure SetFlag(&On: Boolean; Flag: Integer);
  private
    FTypeName: WideString;
    FDataType: Integer;
    FColumnSize: Int64;
    FFlags: Integer;
    FMaxVersion: WideString;
    FMinVersion: WideString;
    FCreateFormat: WideString;
    FCreateParams: WideString;
    FLiteralPrefix: WideString;
    FLiteralSuffix: WideString;
    FMaxScale: Integer;
    FMinScale: Integer;
  public
    property TypeName: WideString read FTypeName;
    property DbxDataType: Integer read FDataType;
    property ColumnSize: Int64 read FColumnSize;
    property CreateFormat: WideString read FCreateFormat;
    property CreateParameters: WideString read FCreateParams;
    property AutoIncrementable: Boolean read IsAutoIncrementable;
    property BestMatch: Boolean read IsBestMatch;
    property CaseSensitive: Boolean read IsCaseSensitive;
    property FixedLength: Boolean read IsFixedLength;
    property FixedPrecisionScale: Boolean read IsFixedPrecisionScale;
    property Long: Boolean read IsLong;
    property Nullable: Boolean read IsNullable;
    property Searchable: Boolean read IsSearchable;
    property SearchableWithLike: Boolean read IsSearchableWithLike;
    property Unsigned: Boolean read IsUnsigned;
    property Unicode: Boolean read IsUnicode;
    property UnicodeOptionSupported: Boolean read IsUnicodeOptionSupported write SetUnicodeOptionSupported;
    property UnsignedOptionSupported: Boolean read IsUnsignedOptionSupported;
    property StringOptionSupported: Boolean read IsStringOptionSupported;
    property LongOptionSupported: Boolean read IsLongOptionSupported;
    property MaximumScale: SmallInt read GetMaximumScale;
    property MinimumScale: SmallInt read GetMinimumScale;
    property ConcurrencyType: Boolean read IsConcurrencyType;
    property MaximumVersion: WideString read FMaxVersion;
    property MinimumVersion: WideString read FMinVersion;
    property LiteralSupported: Boolean read IsLiteralSupported;
    property LiteralPrefix: WideString read FLiteralPrefix;
    property LiteralSuffix: WideString read FLiteralSuffix;
  end;

  TDBXFilterProps = class(TDBXStringStore)
  end;

  TDBXMetaDataCollectionColumns = class
  public
    class function CreateDataTypesColumns: TDBXColumnDescriptorArray; static;
    class function CreateCatalogsColumns: TDBXColumnDescriptorArray; static;
    class function CreateSchemasColumns: TDBXColumnDescriptorArray; static;
    class function CreateTablesColumns: TDBXColumnDescriptorArray; static;
    class function CreateViewsColumns: TDBXColumnDescriptorArray; static;
    class function CreateSynonymsColumns: TDBXColumnDescriptorArray; static;
    class function CreateColumnsColumns: TDBXColumnDescriptorArray; static;
    class function CreateColumnConstraintsColumns: TDBXColumnDescriptorArray; static;
    class function CreateIndexesColumns: TDBXColumnDescriptorArray; static;
    class function CreateIndexColumnsColumns: TDBXColumnDescriptorArray; static;
    class function CreateForeignKeysColumns: TDBXColumnDescriptorArray; static;
    class function CreateForeignKeyColumnsColumns: TDBXColumnDescriptorArray; static;
    class function CreateProceduresColumns: TDBXColumnDescriptorArray; static;
    class function CreateProcedureSourcesColumns: TDBXColumnDescriptorArray; static;
    class function CreateProcedureParametersColumns: TDBXColumnDescriptorArray; static;
    class function CreatePackagesColumns: TDBXColumnDescriptorArray; static;
    class function CreatePackageProceduresColumns: TDBXColumnDescriptorArray; static;
    class function CreatePackageProcedureParametersColumns: TDBXColumnDescriptorArray; static;
    class function CreatePackageSourcesColumns: TDBXColumnDescriptorArray; static;
    class function CreateUsersColumns: TDBXColumnDescriptorArray; static;
    class function CreateRolesColumns: TDBXColumnDescriptorArray; static;
    class function CreateReservedWordsColumns: TDBXColumnDescriptorArray; static;
  end;

  TDBXMetaDataCommandParseResult = class
  public
    constructor Create(CommandToken: Integer; const Parameters: TDBXWideStringArray);
  protected
    function GetCommandToken: Integer; virtual;
    function GetParameters: TDBXWideStringArray; virtual;
  private
    FCommandToken: Integer;
    FParameters: TDBXWideStringArray;
  public
    property CommandToken: Integer read GetCommandToken;
    property Parameters: TDBXWideStringArray read GetParameters;
  end;

  TDBXMetaDataReader = class abstract
  public
    function FetchCollection(const MetaDataCommand: WideString): TDBXTableStorage; virtual; abstract;
    function FetchCollectionWithStorage(const MetaDataCommand: WideString): TDBXTableStorage; virtual; abstract;
  protected
    procedure SetContext(const Context: TDBXProviderContext); virtual; abstract;
    function GetContext: TDBXProviderContext; virtual; abstract;
    function GetProductName: WideString; virtual; abstract;
    function GetVersion: WideString; virtual; abstract;
    procedure SetVersion(const Version: WideString); virtual; abstract;
    function GetSqlIdentifierQuotePrefix: WideString; virtual; abstract;
    function GetSqlIdentifierQuoteSuffix: WideString; virtual; abstract;
    function IsLowerCaseIdentifiersSupported: Boolean; virtual; abstract;
    function IsUpperCaseIdentifiersSupported: Boolean; virtual; abstract;
    function IsQuotedIdentifiersSupported: Boolean; virtual; abstract;
    function IsDescendingIndexSupported: Boolean; virtual; abstract;
    function IsDescendingIndexColumnsSupported: Boolean; virtual; abstract;
    function GetSqlIdentifierQuoteChar: WideString; virtual; abstract;
    function GetSqlProcedureQuoteChar: WideString; virtual; abstract;
    function IsMultipleCommandsSupported: Boolean; virtual; abstract;
    function IsTransactionsSupported: Boolean; virtual; abstract;
    function IsNestedTransactionsSupported: Boolean; virtual; abstract;
    function IsSetRowSizeSupported: Boolean; virtual; abstract;
  public
    property Context: TDBXProviderContext read GetContext write SetContext;
    property ProductName: WideString read GetProductName;
    property Version: WideString read GetVersion write SetVersion;
    property SqlIdentifierQuotePrefix: WideString read GetSqlIdentifierQuotePrefix;
    property SqlIdentifierQuoteSuffix: WideString read GetSqlIdentifierQuoteSuffix;
    property LowerCaseIdentifiersSupported: Boolean read IsLowerCaseIdentifiersSupported;
    property UpperCaseIdentifiersSupported: Boolean read IsUpperCaseIdentifiersSupported;
    property QuotedIdentifiersSupported: Boolean read IsQuotedIdentifiersSupported;
    property DescendingIndexSupported: Boolean read IsDescendingIndexSupported;
    property DescendingIndexColumnsSupported: Boolean read IsDescendingIndexColumnsSupported;
    property SqlIdentifierQuoteChar: WideString read GetSqlIdentifierQuoteChar;
    property SqlProcedureQuoteChar: WideString read GetSqlProcedureQuoteChar;
    property MultipleCommandsSupported: Boolean read IsMultipleCommandsSupported;
    property TransactionsSupported: Boolean read IsTransactionsSupported;
    property NestedTransactionsSupported: Boolean read IsNestedTransactionsSupported;
    property SetRowSizeSupported: Boolean read IsSetRowSizeSupported;
  end;

  TDBXBaseMetaDataReader = class(TDBXMetaDataReader)
  public
    type
      TDBXEmptyTableCursor = class(TDBXDefaultTableStorage)
      public
        constructor Create(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray);
        destructor Destroy; override;
        function Next: Boolean; override;
        procedure Close; override;
      protected
        function GetMetaDataCollectionIndex: Integer; override;
        function GetMetaDataCollectionName: WideString; override;
        function GetColumns: TDBXColumnDescriptorArray; override;
      private
        FMetaDataCollectionIndex: Integer;
        FMetaDataCollectionName: WideString;
        FColumns: TDBXColumnDescriptorArray;
      end;

      TDBXSanitizedTableCursor = class(TDBXDefaultTableStorage)
      public
        constructor Create(const TypeNames: TDBXPlatformTypeNames; MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray; const Cursor: TDBXTableStorage);
        destructor Destroy; override;
        function Next: Boolean; override;
        procedure Close; override;
        function IsNull(Ordinal: Integer): Boolean; override;
        function GetInt16(Ordinal: Integer): SmallInt; override;
        function GetInt32(Ordinal: Integer): Integer; override;
        function GetInt64(Ordinal: Integer): Int64; override;
        function GetBoolean(Ordinal: Integer): Boolean; override;
        function GetString(Ordinal: Integer): WideString; override;
      protected
        function GetCommand: TObject; override;
        function FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer; virtual;
        function GetMetaDataCollectionIndex: Integer; override;
        function GetMetaDataCollectionName: WideString; override;
        function GetColumns: TDBXColumnDescriptorArray; override;
        procedure CheckColumn(const Ordinal: Integer; const ColumnType: Integer); virtual;
      private
        procedure AdjustColumnSize;
      protected
        FTypeNames: TDBXPlatformTypeNames;
        FMetaDataCollectionIndex: Integer;
        FMetaDataCollectionName: WideString;
        FCursor: TDBXTableStorage;
        FColumns: TDBXColumnDescriptorArray;
      private
        FColumnsSizeAdjusted: Boolean;
      end;

      TDBXColumnsTableCursor = class(TDBXDelegateTableStorage)
      public
        constructor Create(Reader: TDBXBaseMetaDataReader; CheckBase: Boolean; const Cursor: TDBXTableStorage);
        function Next: Boolean; override;
        function IsNull(Ordinal: Integer): Boolean; override;
        function GetInt32(Ordinal: Integer): Integer; override;
        function GetAsInt32(Ordinal: Integer): Integer; override;
        function GetBoolean(Ordinal: Integer): Boolean; override;
        function GetAsBoolean(Ordinal: Integer): Boolean; override;
      protected
        procedure CheckColumn(const Ordinal: Integer; const ColumnType: Integer); virtual;
      private
        procedure LookupDataType;
      protected
        FOrdinalOffset: Integer;
        FOrdinalTypeName: Integer;
        FReader: TDBXBaseMetaDataReader;
        FDataTypeHash: TDBXObjectStore;
        FDataType: TDBXDataTypeDescription;
        FCheckBase: Boolean;
      end;

      TDBXSourceTableCursor = class(TDBXBaseMetaDataReader.TDBXSanitizedTableCursor)
      public
        constructor Create(const Context: TDBXProviderContext; MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray; const Cursor: TDBXTableStorage; const OrdinalDefinition: Integer; const OrdinalLineNumber: Integer);
        destructor Destroy; override;
        function Next: Boolean; override;
        function IsNull(Ordinal: Integer): Boolean; override;
        function GetInt16(Ordinal: Integer): SmallInt; override;
        function GetInt32(Ordinal: Integer): Integer; override;
        function GetInt64(Ordinal: Integer): Int64; override;
        function GetBoolean(Ordinal: Integer): Boolean; override;
        function GetString(Ordinal: Integer): WideString; override;
      private
        FRowStorage: TDBXRowStorage;
        FBuffer: TDBXWideStringBuffer;
        FOrdinalLineNumber: Integer;
        FOrdinalDefinition: Integer;
        FBeforeEnd: Boolean;
        FBeforeFirst: Boolean;
      end;

      TDBXDataTypeCursor = class(TDBXDefaultTableStorage)
      public
        constructor Create(const Reader: TDBXBaseMetaDataReader; const Columns: TDBXColumnDescriptorArray; Types: TDBXArrayList);
        destructor Destroy; override;
        procedure Close; override;
        procedure BeforeFirst; override;
        function Next: Boolean; override;
        function IsNull(Ordinal: Integer): Boolean; override;
        function GetInt16(Ordinal: Integer): SmallInt; override;
        function GetInt32(Ordinal: Integer): Integer; override;
        function GetInt64(Ordinal: Integer): Int64; override;
        function GetBoolean(Ordinal: Integer): Boolean; override;
        function GetString(Ordinal: Integer): WideString; override;
      protected
        function GetMetaDataCollectionIndex: Integer; override;
        function GetMetaDataCollectionName: WideString; override;
        function GetColumns: TDBXColumnDescriptorArray; override;
      private
        procedure CheckColumn(const Ordinal: Integer; const ColumnType: Integer);
      protected
        FReader: TDBXBaseMetaDataReader;
        FTypes: TDBXArrayList;
        FColumns: TDBXColumnDescriptorArray;
        FCurrent: TDBXDataTypeDescription;
        FRowIndex: Integer;
      end;

      TDBXReservedWordsCursor = class(TDBXDefaultTableStorage)
      public
        constructor Create(const TypeNames: TDBXPlatformTypeNames; const Columns: TDBXColumnDescriptorArray; const Keywords: TDBXWideStringArray);
        destructor Destroy; override;
        procedure BeforeFirst; override;
        function Next: Boolean; override;
        procedure Close; override;
        function IsNull(Ordinal: Integer): Boolean; override;
        function GetString(Ordinal: Integer): WideString; override;
      protected
        function GetMetaDataCollectionIndex: Integer; override;
        function GetMetaDataCollectionName: WideString; override;
        function GetColumns: TDBXColumnDescriptorArray; override;
      private
        procedure CheckColumn(const Ordinal: Integer; const ColumnType: Integer);
      protected
        FTypeNames: TDBXPlatformTypeNames;
        FKeywords: TDBXWideStringArray;
        FColumns: TDBXColumnDescriptorArray;
        FRowIndex: Integer;
      end;

  public
    destructor Destroy; override;
    function CompareVersion(const OtherVersion: WideString): Integer; virtual;
    function FetchCollection(const MetaDataCommand: WideString): TDBXTableStorage; override;
    function MakeStorage(Cursor: TDBXTableStorage): TDBXTableStorage; virtual;
    function FetchCollectionWithStorage(const MetaDataCommand: WideString): TDBXTableStorage; override;
    function FetchDataTypes: TDBXTableStorage; virtual;
    function FetchCatalogs: TDBXTableStorage; virtual;
    function FetchSchemas(const Catalog: WideString): TDBXTableStorage; virtual;
    function FetchTables(const Catalog: WideString; const Schema: WideString; const TableName: WideString; const TableType: WideString): TDBXTableStorage; virtual;
    function FetchViews(const Catalog: WideString; const Schema: WideString; const View: WideString): TDBXTableStorage; virtual;
    function FetchColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage; virtual;
    function FetchColumnConstraints(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage; virtual;
    function FetchIndexes(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage; virtual;
    function FetchIndexColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const Index: WideString): TDBXTableStorage; virtual;
    function FetchForeignKeys(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage; virtual;
    function FetchForeignKeyColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const ForeignKeyName: WideString; const PrimaryCatalog: WideString; const PrimarySchema: WideString; const PrimaryTable: WideString; const PrimaryKeyName: WideString): TDBXTableStorage; virtual;
    function FetchSynonyms(const Catalog: WideString; const Schema: WideString; const Synonym: WideString): TDBXTableStorage; virtual;
    function FetchProcedures(const Catalog: WideString; const Schema: WideString; const ProcedureName: WideString; const ProcedureType: WideString): TDBXTableStorage; virtual;
    function FetchProcedureSources(const Catalog: WideString; const Schema: WideString; const &Procedure: WideString): TDBXTableStorage; virtual;
    function FetchProcedureParameters(const Catalog: WideString; const Schema: WideString; const &Procedure: WideString; const Parameter: WideString): TDBXTableStorage; virtual;
    function FetchPackages(const Catalog: WideString; const Schema: WideString; const PackageName: WideString): TDBXTableStorage; virtual;
    function FetchPackageProcedures(const Catalog: WideString; const Schema: WideString; const PackageName: WideString; const ProcedureName: WideString; const ProcedureType: WideString): TDBXTableStorage; virtual;
    function FetchPackageProcedureParameters(const Catalog: WideString; const Schema: WideString; const PackageName: WideString; const ProcedureName: WideString; const ParameterName: WideString): TDBXTableStorage; virtual;
    function FetchPackageSources(const Catalog: WideString; const Schema: WideString; const PackageName: WideString): TDBXTableStorage; virtual;
    function FetchUsers: TDBXTableStorage; virtual;
    function FetchRoles: TDBXTableStorage; virtual;
    function FetchReservedWords: TDBXTableStorage; virtual;
  protected
    procedure SetContext(const Context: TDBXProviderContext); override;
    function GetContext: TDBXProviderContext; override;
    function GetProductName: WideString; override;
    function GetVersion: WideString; override;
    procedure SetVersion(const Version: WideString); override;
    function GetSqlDefaultParameterMarker: WideString; virtual;
    function GetSqlIdentifierQuotePrefix: WideString; override;
    function GetSqlIdentifierQuoteSuffix: WideString; override;
    function IsQuotedIdentifiersSupported: Boolean; override;
    function IsLowerCaseIdentifiersSupported: Boolean; override;
    function IsUpperCaseIdentifiersSupported: Boolean; override;
    function IsDescendingIndexSupported: Boolean; override;
    function IsDescendingIndexColumnsSupported: Boolean; override;
    function GetSqlIdentifierQuoteChar: WideString; override;
    function GetSqlProcedureQuoteChar: WideString; override;
    function IsMultipleCommandsSupported: Boolean; override;
    function IsTransactionsSupported: Boolean; override;
    function IsNestedTransactionsSupported: Boolean; override;
    function IsSetRowSizeSupported: Boolean; override;
    function GetTableType: WideString; virtual;
    function GetViewType: WideString; virtual;
    function GetSystemTableType: WideString; virtual;
    function GetSystemViewType: WideString; virtual;
    function GetSynonymType: WideString; virtual;
    function MakeTableTypeString(TableTypeCode: Integer; Flags: Integer): WideString;
    function GetDataTypeHash: TDBXObjectStore; virtual;
    function GetDataTypes: TDBXArrayList; virtual;
    procedure PopulateDataTypes(Hash: TDBXObjectStore; Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray); virtual;
    function GetDataTypeDescriptions: TDBXDataTypeDescriptionArray; virtual;
    function GetReservedWords: TDBXWideStringArray; virtual;
    function GetSqlForDataTypes: WideString; virtual;
    function GetSqlForCatalogs: WideString; virtual;
    function GetSqlForSchemas: WideString; virtual;
    function GetSqlForTables: WideString; virtual;
    function GetSqlForViews: WideString; virtual;
    function GetSqlForColumns: WideString; virtual;
    function GetSqlForColumnConstraints: WideString; virtual;
    function GetSqlForIndexes: WideString; virtual;
    function GetSqlForIndexColumns: WideString; virtual;
    function GetSqlForForeignKeys: WideString; virtual;
    function GetSqlForForeignKeyColumns: WideString; virtual;
    function GetSqlForSynonyms: WideString; virtual;
    function GetSqlForProcedures: WideString; virtual;
    function GetSqlForProcedureSources: WideString; virtual;
    function GetSqlForProcedureParameters: WideString; virtual;
    function GetSqlForPackages: WideString; virtual;
    function GetSqlForPackageProcedures: WideString; virtual;
    function GetSqlForPackageProcedureParameters: WideString; virtual;
    function GetSqlForPackageSources: WideString; virtual;
    function GetSqlForUsers: WideString; virtual;
    function GetSqlForRoles: WideString; virtual;
    function GetSqlForReservedWords: WideString; virtual;
  private
    function CountDigits(const Version: WideString; FromIndex: Integer): Integer;
    procedure AppendVersionSection(const Buffer: TDBXWideStringBuffer; const Version: WideString; Start: Integer; EndIndex: Integer; ExpectedLength: Integer; AddDot: Boolean);
    function MakeStandardVersionFormat(const Version: WideString): WideString;
    function FindSourceLineColumn(Cursor: TDBXTableStorage; ExpectedColumns: Integer): Integer;
    procedure InitScanner;
    function ParseMetaDataCommand(const MetaDataCommand: WideString): TDBXMetaDataCommandParseResult;
    function ParseId: WideString;
    procedure ParseSqlObjectName(const Parameters: TDBXWideStringArray; MaxIds: Integer);
    function ParseParameter(CommandToken: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
    function ParseGetObjectName(CommandToken: Integer; MaxIds: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
    function ParseGetTables(CommandToken: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
    function ParseForeignKeyColumns(CommandToken: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
    function ParseIndexColumns(CommandToken: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
    function ParseProcedures(CommandToken: Integer; MaxIds: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
    function ParseProcedureParameters(CommandToken: Integer; MaxIds: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
    function ParseDone(CommandToken: Integer; const Command: WideString; const Parameters: TDBXWideStringArray): TDBXMetaDataCommandParseResult;
  protected
    FContext: TDBXProviderContext;
    FDataTypeHash: TDBXObjectStore;
  private
    FScanner: TDBXSqlScanner;
    FVersion: WideString;
    FTypes: TDBXArrayList;
  public
    property SqlDefaultParameterMarker: WideString read GetSqlDefaultParameterMarker;
    property TableType: WideString read GetTableType;
    property ViewType: WideString read GetViewType;
    property SystemTableType: WideString read GetSystemTableType;
    property SystemViewType: WideString read GetSystemViewType;
    property SynonymType: WideString read GetSynonymType;
    property DataTypeHash: TDBXObjectStore read GetDataTypeHash;
    property DataTypes: TDBXArrayList read GetDataTypes;
  protected
    property DataTypeDescriptions: TDBXDataTypeDescriptionArray read GetDataTypeDescriptions;
    property ReservedWords: TDBXWideStringArray read GetReservedWords;
    property SqlForDataTypes: WideString read GetSqlForDataTypes;
    property SqlForCatalogs: WideString read GetSqlForCatalogs;
    property SqlForSchemas: WideString read GetSqlForSchemas;
    property SqlForTables: WideString read GetSqlForTables;
    property SqlForViews: WideString read GetSqlForViews;
    property SqlForColumns: WideString read GetSqlForColumns;
    property SqlForColumnConstraints: WideString read GetSqlForColumnConstraints;
    property SqlForIndexes: WideString read GetSqlForIndexes;
    property SqlForIndexColumns: WideString read GetSqlForIndexColumns;
    property SqlForForeignKeys: WideString read GetSqlForForeignKeys;
    property SqlForForeignKeyColumns: WideString read GetSqlForForeignKeyColumns;
    property SqlForSynonyms: WideString read GetSqlForSynonyms;
    property SqlForProcedures: WideString read GetSqlForProcedures;
    property SqlForProcedureSources: WideString read GetSqlForProcedureSources;
    property SqlForProcedureParameters: WideString read GetSqlForProcedureParameters;
    property SqlForPackages: WideString read GetSqlForPackages;
    property SqlForPackageProcedures: WideString read GetSqlForPackageProcedures;
    property SqlForPackageProcedureParameters: WideString read GetSqlForPackageProcedureParameters;
    property SqlForPackageSources: WideString read GetSqlForPackageSources;
    property SqlForUsers: WideString read GetSqlForUsers;
    property SqlForRoles: WideString read GetSqlForRoles;
    property SqlForReservedWords: WideString read GetSqlForReservedWords;
  private
    const SourceLineNumber = 'SOURCE_LINE_NUMBER';
    const Colon = ':';
    const Dot = '.';
    const DoubleQuote = '"';
    const TokenDatabase = 500;
    const TokenTable = 501;
    const TokenView = 502;
    const TokenSystemTable = 503;
    const TokenSystemView = 504;
    const TokenSynonym = 505;
    const TokenProcedureType = 506;
    const TokenFunctionType = 507;
    const TokenPrimaryKey = 508;
    const TokenForeignKey = 509;
  end;

  TDBXParameterName = class
  public
    const DefaultMarker = ':';
    const CatalogName = 'CATALOG_NAME';
    const SchemaName = 'SCHEMA_NAME';
    const TableName = 'TABLE_NAME';
    const NewSchemaName = 'NEW_SCHEMA_NAME';
    const NewTableName = 'NEW_TABLE_NAME';
    const Tables = 'TABLES';
    const Views = 'VIEWS';
    const SystemTables = 'SYSTEM_TABLES';
    const SystemViews = 'SYSTEM_VIEWS';
    const Synonyms = 'SYNONYMS';
    const ViewName = 'VIEW_NAME';
    const IndexName = 'INDEX_NAME';
    const ForeignKeyName = 'FOREIGN_KEY_NAME';
    const PrimaryCatalogName = 'PRIMARY_CATALOG_NAME';
    const PrimarySchemaName = 'PRIMARY_SCHEMA_NAME';
    const PrimaryTableName = 'PRIMARY_TABLE_NAME';
    const PrimaryKeyName = 'PRIMARY_KEY_NAME';
    const SynonymName = 'SYNONYM_NAME';
    const ProcedureType = 'PROCEDURE_TYPE';
    const ProcedureName = 'PROCEDURE_NAME';
    const PackageName = 'PACKAGE_NAME';
    const ParameterName = 'PARAMETER_NAME';
  end;

  TDBXPlatformTypeNames = class abstract
  public
    function GetPlatformTypeName(const DataType: Integer; const IsUnsigned: Boolean): WideString; virtual; abstract;
  end;

  TDBXProcedureType = class
  public
    const ProcedureType = 'PROCEDURE';
    const FunctionType = 'FUNCTION';
  end;

  TDBXProviderContext = class abstract(TDBXPlatformTypeNames)
  public
    function ExecuteQuery(const Sql: WideString; const ParameterNames: TDBXWideStringArray; const ParameterValues: TDBXWideStringArray): TDBXTableStorage; virtual; abstract;
    function CreateTableStorage(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray): TDBXTableStorage; virtual; abstract;
    function CreateRowStorage(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray): TDBXRowStorage; virtual; abstract;
    procedure StartSerializedTransaction; virtual; abstract;
    procedure StartTransaction; virtual; abstract;
    procedure Commit; virtual; abstract;
    procedure Rollback; virtual; abstract;
    function GetVendorProperty(const Name: WideString): WideString; virtual; abstract;
  end;

  TDBXTableType = class
  public
    const Table = 'TABLE';
    const View = 'VIEW';
    const Synonym = 'SYNONYM';
    const SystemTable = 'SYSTEM TABLE';
    const SystemView = 'SYSTEM VIEW';
  end;

  TDBXTableTypeFlag = class
  public
    const Table = 1;
    const View = 2;
    const SystemTable = 4;
    const SystemView = 8;
    const Synonym = 16;
    const All = 31;
  end;

  TDBXTableTypeParser = class
  public
    class function ParseTableTypes(const TableTypes: WideString): Integer; static;
  end;

  TDBXTypeFlag = class
  public
    const AutoIncrementable = 1;
    const BestMatch = 2;
    const FixedLength = 4;
    const CaseSensitive = 8;
    const FixedPrecisionScale = 16;
    const Long = 32;
    const Nullable = 64;
    const Searchable = 128;
    const SearchableWithLike = 256;
    const Unsigned = 512;
    const ConcurrencyType = 1024;
    const LiteralSupported = 2048;
    const Unicode = 4096;
    const UnicodeOption = 8192;
    const UnsignedOption = 16384;
    const StringOption = 32768;
    const LongOption = 65536;
  end;

  TDBXVersion = class
  public
    const FMySQL4_1 = '04.01.0000';
    const FMySQL5 = '05.00.0000';
    const FMySQL5_0_6 = '05.00.0006';
    const FVersion10 = '10.00.0000';
  end;

resourcestring
  SIndexName = 'Index Name';
  SDataType = 'Platform Type Name';
  STableName = 'Table Name';
  SPackageName = 'Package Name';
  SUnknownSchemaName = 'Unknown schema name specified: %s';
  SIsSearchableWithLike = 'Searchable With Like';
  SPrimaryCatalogName = 'Primary Catalog Name';
  SIsPrimary = 'Primary';
  SSchemaName = 'Schema Name';
  SProviderDbType = 'Provider Type';
  SSynonymName = 'Synonym Name';
  SProcedureType = 'Procedure Type';
  SParameterMode = 'Parameter Mode';
  SMetaDataCommandExpected = 'A MetaData command was expected here e.g. GetTables.';
  SMissingImplementation = 'This method must be implemented in a derived class.';
  SIsFixedLength = 'Fixed Length';
  SIsFixedPrecisionScale = 'Fixed Precision';
  SUserName = 'User Name';
  SCatalogName = 'Catalog Name';
  SIsBestMatch = 'Best Match';
  SNoSchemaNameSpecified = 'No schema name specified.';
  SMaximumScale = 'Maximum Scale';
  SOrdinal = 'Ordinal';
  SMaximumVersion = 'Maximum Version';
  SDefaultValue = 'Default Value';
  SPrimaryTableName = 'Primary Table Name';
  SMinimumVersion = 'Minimum Version';
  SDefinition = 'Definition';
  SColumnName = 'Column Name';
  SCreateParameters = 'Create Parameters';
  SIsConcurrencyType = 'Concurrency';
  SDbxDataType = 'DbxType';
  STableType = 'Table Type';
  SMaxInline = 'Max Inline';
  SUnclosedQuotes = 'Unclosed quotes were found in the metadata query: %s.';
  SIsLiteralSupported = 'Literal Supported';
  SIsAscending = 'Ascending';
  SIsUnicode = 'Unicode';
  SPrecision = 'Precision';
  SConstraintName = 'Constraint Name';
  SMustCallNextFirst = 'Cursor is positioned before the first row, move to the next row before getting data';
  SScale = 'Scale';
  SIsNullable = 'Nullable';
  SWrongAccessorForType = 'Wrong accessor method used for the datatype: %s.';
  SExternalDefinition = 'External Definition';
  SForeignKeyName = 'Foreign Key Name';
  SIsSearchable = 'Searchable';
  SPrimarySchemaName = 'Primary Schema Name';
  SIsCaseSensitive = 'Case Sensitive';
  SParameterName = 'Parameter Name';
  SIsUnsigned = 'Unsigned';
  SIsAutoIncrement = 'Auto Increment';
  SRoleName = 'Role Name';
  SOrdinalOutOfRange = 'Ordinal is outside the bounds of this cursor.';
  SIsUnique = 'Unique';
  SCreateFormat = 'Create Format';
  SPrimaryKeyName = 'Primary Key Name';
  SUnknownTableType = 'Unknown table type specified:';
  SColumnSize = 'Column Size';
  SPrimaryColumnName = 'Primary Column Name';
  SIsAutoIncrementable = 'AutoIncrementable';
  SProcedureName = 'Procedure Name';
  STableCatalogName = 'Table Catalog Name';
  SReservedWord = 'Reserved Word';
  STableSchemaName = 'Table Schema Name';
  STypeName = 'Type Name';
  SViewName = 'View Name';
  SIsLong = 'Long';
  SPastEndOfCursor = 'No more data.';
  SUnexpectedSymbol = 'Could not parse the %1:s metadata command. Problem found near: %0:s. Original query: %2:s.';
  SLiteralPrefix = 'Literal Prefix';
  SMinimumScale = 'Minimum Scale';
  SLiteralSuffix = 'Literal Suffix';

implementation
uses
  DBXCommon,
  DBXMetaDataError,
  DBXMetaDataNames,
  Math,
  StrUtils,
  SysUtils;

constructor TDBXDataTypeDescription.Create(const TypeName: WideString; const DataType: Integer; const ColumnSize: Int64; const CreateFormat: WideString; const CreateParams: WideString; const MaxScale: Integer; const MinScale: Integer; const LiteralPrefix: WideString; const LiteralSuffix: WideString; const MaxVersion: WideString; const MinVersion: WideString; const Flags: Integer);
begin
  inherited Create;
  self.FTypeName := TypeName;
  self.FDataType := DataType;
  self.FColumnSize := ColumnSize;
  self.FMaxVersion := MaxVersion;
  self.FMinVersion := MinVersion;
  self.FFlags := Flags;
  self.FCreateFormat := CreateFormat;
  self.FCreateParams := CreateParams;
  self.FLiteralPrefix := LiteralPrefix;
  self.FLiteralSuffix := LiteralSuffix;
  self.FMaxScale := MaxScale;
  self.FMinScale := MinScale;
end;

constructor TDBXDataTypeDescription.Create(Original: TDBXDataTypeDescription);
begin
  inherited Create;
  self.FTypeName := Original.FTypeName;
  self.FDataType := Original.FDataType;
  self.FColumnSize := Original.FColumnSize;
  self.FMaxVersion := Original.FMaxVersion;
  self.FMinVersion := Original.FMinVersion;
  self.FFlags := Original.FFlags;
  self.FCreateFormat := Original.FCreateFormat;
  self.FCreateParams := Original.FCreateParams;
  self.FLiteralPrefix := Original.FLiteralPrefix;
  self.FLiteralSuffix := Original.FLiteralSuffix;
  self.FMaxScale := Original.FMaxScale;
  self.FMinScale := Original.FMinScale;
end;

function TDBXDataTypeDescription.GetDataType(const TypeNames: TDBXPlatformTypeNames): WideString;
begin
  Result := TypeNames.GetPlatformTypeName(FDataType, Unsigned);
end;

function TDBXDataTypeDescription.IsFlagSet(Flag: Integer): Boolean;
begin
  Result := (FFlags and Flag) = Flag;
end;

procedure TDBXDataTypeDescription.SetFlag(&On: Boolean; Flag: Integer);
begin
  if &On then
    FFlags := FFlags or Flag
  else 
    FFlags := FFlags and not Flag;
end;

function TDBXDataTypeDescription.IsAutoIncrementable: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.AutoIncrementable);
end;

function TDBXDataTypeDescription.IsBestMatch: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.BestMatch);
end;

function TDBXDataTypeDescription.IsCaseSensitive: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.CaseSensitive);
end;

function TDBXDataTypeDescription.IsFixedLength: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.FixedLength);
end;

function TDBXDataTypeDescription.IsFixedPrecisionScale: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.FixedPrecisionScale);
end;

function TDBXDataTypeDescription.IsLong: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.Long);
end;

function TDBXDataTypeDescription.IsNullable: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.Nullable);
end;

function TDBXDataTypeDescription.IsSearchable: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.Searchable);
end;

function TDBXDataTypeDescription.IsSearchableWithLike: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.SearchableWithLike);
end;

function TDBXDataTypeDescription.IsUnsigned: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.Unsigned);
end;

function TDBXDataTypeDescription.IsUnicode: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.Unicode);
end;

function TDBXDataTypeDescription.IsUnicodeOptionSupported: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.UnicodeOption);
end;

procedure TDBXDataTypeDescription.SetUnicodeOptionSupported(Supported: Boolean);
begin
  SetFlag(Supported, TDBXTypeFlag.UnicodeOption);
end;

function TDBXDataTypeDescription.IsUnsignedOptionSupported: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.UnsignedOption);
end;

function TDBXDataTypeDescription.IsStringOptionSupported: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.StringOption);
end;

function TDBXDataTypeDescription.IsLongOptionSupported: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.LongOption);
end;

function TDBXDataTypeDescription.GetMaximumScale: SmallInt;
begin
  Result := SmallInt(FMaxScale);
end;

function TDBXDataTypeDescription.GetMinimumScale: SmallInt;
begin
  Result := SmallInt(FMinScale);
end;

function TDBXDataTypeDescription.IsConcurrencyType: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.ConcurrencyType);
end;

function TDBXDataTypeDescription.IsLiteralSupported: Boolean;
begin
  Result := IsFlagSet(TDBXTypeFlag.LiteralSupported);
end;

class function TDBXMetaDataCollectionColumns.CreateDataTypesColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,26);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.TypeName, STypeName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.DbxDataType, SDbxDataType, TDBXDataTypes.Int32Type);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.ColumnSize, SColumnSize, TDBXDataTypes.Int64Type);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.CreateFormat, SCreateFormat, TDBXDataTypes.WideStringType);
  Columns[4] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.CreateParameters, SCreateParameters, TDBXDataTypes.WideStringType);
  Columns[5] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.DataType, SDataType, TDBXDataTypes.WideStringType);
  Columns[6] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.IsAutoIncrementable, SIsAutoIncrementable, TDBXDataTypes.BooleanType);
  Columns[7] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.IsBestMatch, SIsBestMatch, TDBXDataTypes.BooleanType);
  Columns[8] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.IsCaseSensitive, SIsCaseSensitive, TDBXDataTypes.BooleanType);
  Columns[9] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.IsFixedLength, SIsFixedLength, TDBXDataTypes.BooleanType);
  Columns[10] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.IsFixedPrecisionScale, SIsFixedPrecisionScale, TDBXDataTypes.BooleanType);
  Columns[11] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.IsLong, SIsLong, TDBXDataTypes.BooleanType);
  Columns[12] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.IsNullable, SIsNullable, TDBXDataTypes.BooleanType);
  Columns[13] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.IsSearchable, SIsSearchable, TDBXDataTypes.BooleanType);
  Columns[14] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.IsSearchableWithLike, SIsSearchableWithLike, TDBXDataTypes.BooleanType);
  Columns[15] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.IsUnsigned, SIsUnsigned, TDBXDataTypes.BooleanType);
  Columns[16] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.MaximumScale, SMaximumScale, TDBXDataTypes.Int16Type);
  Columns[17] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.MinimumScale, SMinimumScale, TDBXDataTypes.Int16Type);
  Columns[18] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.IsConcurrencyType, SIsConcurrencyType, TDBXDataTypes.BooleanType);
  Columns[19] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.MaximumVersion, SMaximumVersion, TDBXDataTypes.WideStringType);
  Columns[20] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.MinimumVersion, SMinimumVersion, TDBXDataTypes.WideStringType);
  Columns[21] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.IsLiteralSupported, SIsLiteralSupported, TDBXDataTypes.BooleanType);
  Columns[22] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.LiteralPrefix, SLiteralPrefix, TDBXDataTypes.WideStringType);
  Columns[23] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.LiteralSuffix, SLiteralSuffix, TDBXDataTypes.WideStringType);
  Columns[24] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.IsUnicode, SIsUnicode, TDBXDataTypes.BooleanType);
  Columns[25] := TDBXColumnDescriptor.Create(TDBXDataTypesColumns.ProviderDbType, SProviderDbType, TDBXDataTypes.Int32Type, True);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateCatalogsColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,1);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXCatalogsColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateSchemasColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,2);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXSchemasColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXSchemasColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateTablesColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,4);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXTablesColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXTablesColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXTablesColumns.TableName, STableName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXTablesColumns.TableType, STableType, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateViewsColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,4);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXViewsColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXViewsColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXViewsColumns.ViewName, SViewName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXViewsColumns.Definition, SDefinition, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateSynonymsColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,6);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXSynonymsColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXSynonymsColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXSynonymsColumns.SynonymName, SSynonymName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXSynonymsColumns.TableCatalogName, STableCatalogName, TDBXDataTypes.WideStringType);
  Columns[4] := TDBXColumnDescriptor.Create(TDBXSynonymsColumns.TableSchemaName, STableSchemaName, TDBXDataTypes.WideStringType);
  Columns[5] := TDBXColumnDescriptor.Create(TDBXSynonymsColumns.TableName, STableName, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateColumnsColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,17);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.TableName, STableName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.ColumnName, SColumnName, TDBXDataTypes.WideStringType);
  Columns[4] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.TypeName, STypeName, TDBXDataTypes.WideStringType);
  Columns[5] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.Precision, SPrecision, TDBXDataTypes.Int32Type);
  Columns[6] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.Scale, SScale, TDBXDataTypes.Int32Type);
  Columns[7] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.Ordinal, SOrdinal, TDBXDataTypes.Int32Type);
  Columns[8] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.DefaultValue, SDefaultValue, TDBXDataTypes.WideStringType);
  Columns[9] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.IsNullable, SIsNullable, TDBXDataTypes.BooleanType);
  Columns[10] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.IsAutoIncrement, SIsAutoIncrement, TDBXDataTypes.BooleanType);
  Columns[11] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.MaxInline, SMaxInline, TDBXDataTypes.Int32Type, True);
  Columns[12] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.DbxDataType, SDbxDataType, TDBXDataTypes.Int32Type, True);
  Columns[13] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.IsFixedLength, SIsFixedLength, TDBXDataTypes.BooleanType, True);
  Columns[14] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.IsUnicode, SIsUnicode, TDBXDataTypes.BooleanType, True);
  Columns[15] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.IsLong, SIsLong, TDBXDataTypes.BooleanType, True);
  Columns[16] := TDBXColumnDescriptor.Create(TDBXColumnsColumns.IsUnsigned, SIsUnsigned, TDBXDataTypes.BooleanType, True);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateColumnConstraintsColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,5);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXColumnConstraintsColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXColumnConstraintsColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXColumnConstraintsColumns.TableName, STableName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXColumnConstraintsColumns.ConstraintName, SConstraintName, TDBXDataTypes.WideStringType);
  Columns[4] := TDBXColumnDescriptor.Create(TDBXColumnConstraintsColumns.ColumnName, SColumnName, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateIndexesColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,8);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXIndexesColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXIndexesColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXIndexesColumns.TableName, STableName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXIndexesColumns.IndexName, SIndexName, TDBXDataTypes.WideStringType);
  Columns[4] := TDBXColumnDescriptor.Create(TDBXIndexesColumns.ConstraintName, SConstraintName, TDBXDataTypes.WideStringType, True);
  Columns[5] := TDBXColumnDescriptor.Create(TDBXIndexesColumns.IsPrimary, SIsPrimary, TDBXDataTypes.BooleanType);
  Columns[6] := TDBXColumnDescriptor.Create(TDBXIndexesColumns.IsUnique, SIsUnique, TDBXDataTypes.BooleanType);
  Columns[7] := TDBXColumnDescriptor.Create(TDBXIndexesColumns.IsAscending, SIsAscending, TDBXDataTypes.BooleanType, True);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateIndexColumnsColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,7);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXIndexColumnsColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXIndexColumnsColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXIndexColumnsColumns.TableName, STableName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXIndexColumnsColumns.IndexName, SIndexName, TDBXDataTypes.WideStringType);
  Columns[4] := TDBXColumnDescriptor.Create(TDBXIndexColumnsColumns.ColumnName, SColumnName, TDBXDataTypes.WideStringType);
  Columns[5] := TDBXColumnDescriptor.Create(TDBXIndexColumnsColumns.Ordinal, SOrdinal, TDBXDataTypes.Int32Type);
  Columns[6] := TDBXColumnDescriptor.Create(TDBXIndexColumnsColumns.IsAscending, SIsAscending, TDBXDataTypes.BooleanType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateForeignKeysColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,4);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXForeignKeysColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXForeignKeysColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXForeignKeysColumns.TableName, STableName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXForeignKeysColumns.ForeignKeyName, SForeignKeyName, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateForeignKeyColumnsColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,11);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXForeignKeyColumnsColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXForeignKeyColumnsColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXForeignKeyColumnsColumns.TableName, STableName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXForeignKeyColumnsColumns.ForeignKeyName, SForeignKeyName, TDBXDataTypes.WideStringType);
  Columns[4] := TDBXColumnDescriptor.Create(TDBXForeignKeyColumnsColumns.ColumnName, SColumnName, TDBXDataTypes.WideStringType);
  Columns[5] := TDBXColumnDescriptor.Create(TDBXForeignKeyColumnsColumns.PrimaryCatalogName, SPrimaryCatalogName, TDBXDataTypes.WideStringType);
  Columns[6] := TDBXColumnDescriptor.Create(TDBXForeignKeyColumnsColumns.PrimarySchemaName, SPrimarySchemaName, TDBXDataTypes.WideStringType);
  Columns[7] := TDBXColumnDescriptor.Create(TDBXForeignKeyColumnsColumns.PrimaryTableName, SPrimaryTableName, TDBXDataTypes.WideStringType);
  Columns[8] := TDBXColumnDescriptor.Create(TDBXForeignKeyColumnsColumns.PrimaryKeyName, SPrimaryKeyName, TDBXDataTypes.WideStringType);
  Columns[9] := TDBXColumnDescriptor.Create(TDBXForeignKeyColumnsColumns.PrimaryColumnName, SPrimaryColumnName, TDBXDataTypes.WideStringType);
  Columns[10] := TDBXColumnDescriptor.Create(TDBXForeignKeyColumnsColumns.Ordinal, SOrdinal, TDBXDataTypes.Int32Type);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateProceduresColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,4);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXProceduresColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXProceduresColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXProceduresColumns.ProcedureName, SProcedureName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXProceduresColumns.ProcedureType, SProcedureType, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateProcedureSourcesColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,6);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXProcedureSourcesColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXProcedureSourcesColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXProcedureSourcesColumns.ProcedureName, SProcedureName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXProcedureSourcesColumns.ProcedureType, SProcedureType, TDBXDataTypes.WideStringType);
  Columns[4] := TDBXColumnDescriptor.Create(TDBXProcedureSourcesColumns.Definition, SDefinition, TDBXDataTypes.WideStringType);
  Columns[5] := TDBXColumnDescriptor.Create(TDBXProcedureSourcesColumns.ExternalDefinition, SExternalDefinition, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateProcedureParametersColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,15);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.ProcedureName, SProcedureName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.ParameterName, SParameterName, TDBXDataTypes.WideStringType);
  Columns[4] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.ParameterMode, SParameterMode, TDBXDataTypes.WideStringType);
  Columns[5] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.TypeName, STypeName, TDBXDataTypes.WideStringType);
  Columns[6] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.Precision, SPrecision, TDBXDataTypes.Int32Type);
  Columns[7] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.Scale, SScale, TDBXDataTypes.Int32Type);
  Columns[8] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.Ordinal, SOrdinal, TDBXDataTypes.Int32Type);
  Columns[9] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.IsNullable, SIsNullable, TDBXDataTypes.BooleanType);
  Columns[10] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.DbxDataType, SDbxDataType, TDBXDataTypes.Int32Type, True);
  Columns[11] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.IsFixedLength, SIsFixedLength, TDBXDataTypes.BooleanType, True);
  Columns[12] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.IsUnicode, SIsUnicode, TDBXDataTypes.BooleanType, True);
  Columns[13] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.IsLong, SIsLong, TDBXDataTypes.BooleanType, True);
  Columns[14] := TDBXColumnDescriptor.Create(TDBXProcedureParametersColumns.IsUnsigned, SIsUnsigned, TDBXDataTypes.BooleanType, True);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreatePackagesColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,3);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXPackagesColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXPackagesColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXPackagesColumns.PackageName, SPackageName, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreatePackageProceduresColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,5);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXPackageProceduresColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXPackageProceduresColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXPackageProceduresColumns.PackageName, SPackageName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXPackageProceduresColumns.ProcedureName, SProcedureName, TDBXDataTypes.WideStringType);
  Columns[4] := TDBXColumnDescriptor.Create(TDBXPackageProceduresColumns.ProcedureType, SProcedureType, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreatePackageProcedureParametersColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,16);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.PackageName, SPackageName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.ProcedureName, SProcedureName, TDBXDataTypes.WideStringType);
  Columns[4] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.ParameterName, SParameterName, TDBXDataTypes.WideStringType);
  Columns[5] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.ParameterMode, SParameterMode, TDBXDataTypes.WideStringType);
  Columns[6] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.TypeName, STypeName, TDBXDataTypes.WideStringType);
  Columns[7] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.Precision, SPrecision, TDBXDataTypes.Int32Type);
  Columns[8] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.Scale, SScale, TDBXDataTypes.Int32Type);
  Columns[9] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.Ordinal, SOrdinal, TDBXDataTypes.Int32Type);
  Columns[10] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.IsNullable, SIsNullable, TDBXDataTypes.BooleanType);
  Columns[11] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.DbxDataType, SDbxDataType, TDBXDataTypes.Int32Type, True);
  Columns[12] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.IsFixedLength, SIsFixedLength, TDBXDataTypes.BooleanType, True);
  Columns[13] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.IsUnicode, SIsUnicode, TDBXDataTypes.BooleanType, True);
  Columns[14] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.IsLong, SIsLong, TDBXDataTypes.BooleanType, True);
  Columns[15] := TDBXColumnDescriptor.Create(TDBXPackageProcedureParametersColumns.IsUnsigned, SIsUnsigned, TDBXDataTypes.BooleanType, True);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreatePackageSourcesColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,4);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXPackageSourcesColumns.CatalogName, SCatalogName, TDBXDataTypes.WideStringType);
  Columns[1] := TDBXColumnDescriptor.Create(TDBXPackageSourcesColumns.SchemaName, SSchemaName, TDBXDataTypes.WideStringType);
  Columns[2] := TDBXColumnDescriptor.Create(TDBXPackageSourcesColumns.PackageName, SPackageName, TDBXDataTypes.WideStringType);
  Columns[3] := TDBXColumnDescriptor.Create(TDBXPackageSourcesColumns.Definition, SDefinition, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateUsersColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,1);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXUsersColumns.UserName, SUserName, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateRolesColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,1);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXRolesColumns.RoleName, SRoleName, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

class function TDBXMetaDataCollectionColumns.CreateReservedWordsColumns: TDBXColumnDescriptorArray;
var
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(Columns,1);
  Columns[0] := TDBXColumnDescriptor.Create(TDBXReservedWordsColumns.ReservedWord, SReservedWord, TDBXDataTypes.WideStringType);
  Result := Columns;
end;

constructor TDBXMetaDataCommandParseResult.Create(CommandToken: Integer; const Parameters: TDBXWideStringArray);
begin
  inherited Create;
  self.FCommandToken := CommandToken;
  self.FParameters := Parameters;
end;

function TDBXMetaDataCommandParseResult.GetCommandToken: Integer;
begin
  Result := FCommandToken;
end;

function TDBXMetaDataCommandParseResult.GetParameters: TDBXWideStringArray;
begin
  Result := FParameters;
end;

destructor TDBXBaseMetaDataReader.Destroy;
begin
  FreeAndNil(FContext);
  FreeAndNil(FScanner);
  FreeAndNil(FDataTypeHash);
  FreeAndNil(FTypes);
  inherited Destroy;
end;

procedure TDBXBaseMetaDataReader.SetContext(const Context: TDBXProviderContext);
begin
  self.FContext := Context;
end;

function TDBXBaseMetaDataReader.GetContext: TDBXProviderContext;
begin
  Result := FContext;
end;

function TDBXBaseMetaDataReader.GetProductName: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetVersion: WideString;
begin
  Result := self.FVersion;
end;

procedure TDBXBaseMetaDataReader.SetVersion(const Version: WideString);
begin
  self.FVersion := MakeStandardVersionFormat(Version);
end;

function TDBXBaseMetaDataReader.CountDigits(const Version: WideString; FromIndex: Integer): Integer;
var
  Index: Integer;
  IsDigit: Boolean;
  Ch: WideChar;
begin
  Index := FromIndex;
  IsDigit := True;
  while IsDigit and (Index < Length(Version)) do
  begin
    Ch := Version[1+Index];
    IsDigit := ((Ch >= '0') and (Ch <= '9'));
    IncrAfter(Index);
  end;
  if not IsDigit then
    DecrAfter(Index);
  Result := Index - FromIndex;
end;

procedure TDBXBaseMetaDataReader.AppendVersionSection(const Buffer: TDBXWideStringBuffer; const Version: WideString; Start: Integer; EndIndex: Integer; ExpectedLength: Integer; AddDot: Boolean);
var
  Index: Integer;
  MaxLength: Integer;
begin
  MaxLength := Min(Length(Version),EndIndex);
  while (Start < MaxLength) and (Version[1+Start] = '0') do
    IncrAfter(Start);
  if EndIndex - Start > ExpectedLength then
    for index := 0 to ExpectedLength - 1 do
      Buffer.Append('9')
  else 
  begin
    for index := EndIndex - Start to ExpectedLength - 1 do
      Buffer.Append('0');
    for index := Start to EndIndex - 1 do
      Buffer.Append(Version[1+Index]);
  end;
  if AddDot then
    Buffer.Append(Dot);
end;

function TDBXBaseMetaDataReader.MakeStandardVersionFormat(const Version: WideString): WideString;
var
  I1: Integer;
  I2: Integer;
  I3: Integer;
  Buffer: TDBXWideStringBuffer;
  Index: Integer;
  Standard: WideString;
begin
  I1 := StringIndexOf(Version,Dot);
  I2 := StringIndexOf(Version,Dot,I1 + 1);
  I3 := I2 + 1 + CountDigits(Version, I2 + 1);
  if (I1 > 0) and (I2 > I1) and (I3 > I2) and ((I1 <> 2) or (I2 - I1 <> 3) or (I3 - I2 <> 4)) then
  begin
    Buffer := TDBXWideStringBuffer.Create;
    AppendVersionSection(Buffer, Version, 0, I1, 2, True);
    AppendVersionSection(Buffer, Version, I1 + 1, I2, 2, True);
    AppendVersionSection(Buffer, Version, I2 + 1, I3, 4, False);
    for index := I3 to Length(Version) - 1 do
      Buffer.Append(Version[1+Index]);
    Standard := Buffer.ToString;
    FreeAndNil(Buffer);
    Result := Standard;
  end
  else 
    Result := Version;
end;

function TDBXBaseMetaDataReader.GetSqlDefaultParameterMarker: WideString;
begin
  Result := Colon;
end;

function TDBXBaseMetaDataReader.CompareVersion(const OtherVersion: WideString): Integer;
begin
  if (not StringIsNil(FVersion)) and (not StringIsNil(OtherVersion)) then
    Result := WideCompareStr(FVersion,OtherVersion)
  else 
    Result := 0;
end;

function TDBXBaseMetaDataReader.GetSqlIdentifierQuotePrefix: WideString;
begin
  Result := DoubleQuote;
end;

function TDBXBaseMetaDataReader.GetSqlIdentifierQuoteSuffix: WideString;
begin
  Result := DoubleQuote;
end;

function TDBXBaseMetaDataReader.IsQuotedIdentifiersSupported: Boolean;
begin
  Result := (Length(SqlIdentifierQuoteChar) > 0) or ((Length(SqlIdentifierQuotePrefix) > 0) and (Length(SqlIdentifierQuoteSuffix) > 0));
end;

function TDBXBaseMetaDataReader.IsLowerCaseIdentifiersSupported: Boolean;
begin
  Result := False;
end;

function TDBXBaseMetaDataReader.IsUpperCaseIdentifiersSupported: Boolean;
begin
  Result := True;
end;

function TDBXBaseMetaDataReader.IsDescendingIndexSupported: Boolean;
begin
  Result := False;
end;

function TDBXBaseMetaDataReader.IsDescendingIndexColumnsSupported: Boolean;
begin
  Result := True;
end;

function TDBXBaseMetaDataReader.GetSqlIdentifierQuoteChar: WideString;
begin
  Result := DoubleQuote;
end;

function TDBXBaseMetaDataReader.GetSqlProcedureQuoteChar: WideString;
begin
  Result := SqlIdentifierQuoteChar;
end;

function TDBXBaseMetaDataReader.IsMultipleCommandsSupported: Boolean;
begin
  Result := True;
end;

function TDBXBaseMetaDataReader.IsTransactionsSupported: Boolean;
begin
  Result := True;
end;

function TDBXBaseMetaDataReader.IsNestedTransactionsSupported: Boolean;
begin
  Result := False;
end;

function TDBXBaseMetaDataReader.IsSetRowSizeSupported: Boolean;
begin
  Result := False;
end;

function TDBXBaseMetaDataReader.GetTableType: WideString;
begin
  Result := TDBXTableType.Table;
end;

function TDBXBaseMetaDataReader.GetViewType: WideString;
begin
  Result := TDBXTableType.View;
end;

function TDBXBaseMetaDataReader.GetSystemTableType: WideString;
begin
  Result := TDBXTableType.SystemTable;
end;

function TDBXBaseMetaDataReader.GetSystemViewType: WideString;
begin
  Result := TDBXTableType.SystemView;
end;

function TDBXBaseMetaDataReader.GetSynonymType: WideString;
begin
  Result := TDBXTableType.Synonym;
end;

function TDBXBaseMetaDataReader.MakeTableTypeString(TableTypeCode: Integer; Flags: Integer): WideString;
begin
  if ((TableTypeCode and Flags) = 0) and (Flags <> 0) then
    TableTypeCode := 0;
  case TableTypeCode of
    TDBXTableTypeFlag.Table:
      Result := TableType;
    TDBXTableTypeFlag.View:
      Result := ViewType;
    TDBXTableTypeFlag.SystemTable:
      Result := SystemTableType;
    TDBXTableTypeFlag.SystemView:
      Result := SystemViewType;
    TDBXTableTypeFlag.Synonym:
      Result := SynonymType;
    else
      Result := '0';
  end;
end;

function TDBXBaseMetaDataReader.FindSourceLineColumn(Cursor: TDBXTableStorage; ExpectedColumns: Integer): Integer;
var
  Columns: TDBXColumnDescriptorArray;
  Ordinal: Integer;
begin
  Columns := Cursor.Columns;
  for ordinal := ExpectedColumns to Length(Columns) - 1 do
  begin
    if (WideUpperCase(Columns[Ordinal].ColumnName) = SourceLineNumber) then
    begin
      Result := Ordinal;
      exit;
    end;
  end;
  Result := -1;
end;

procedure TDBXBaseMetaDataReader.InitScanner;
var
  QuoteChar: WideString;
  QuotePrefix: WideString;
  QuoteSuffix: WideString;
  Scan: TDBXSqlScanner;
begin
  if FScanner = nil then
  begin
    QuoteChar := SqlIdentifierQuoteChar;
    QuotePrefix := SqlIdentifierQuotePrefix;
    QuoteSuffix := SqlIdentifierQuoteSuffix;
    if (QuoteChar = '') then
      QuoteChar := DoubleQuote;
    if (QuotePrefix = '') then
      QuotePrefix := DoubleQuote;
    if (QuoteSuffix = '') then
      QuoteSuffix := DoubleQuote;
    Scan := TDBXSqlScanner.Create(QuoteChar, QuotePrefix, QuoteSuffix);
    Scan.RegisterId(TDBXMetaDataCommands.GetDatabase, TokenDatabase);
    Scan.RegisterId(TDBXMetaDataCommands.GetDatatypes, TDBXMetaDataCollectionIndex.DataTypes);
    Scan.RegisterId(TDBXMetaDataCommandsEx.GetCatalogs, TDBXMetaDataCollectionIndex.Catalogs);
    Scan.RegisterId(TDBXMetaDataCommandsEx.GetSchemas, TDBXMetaDataCollectionIndex.Schemas);
    Scan.RegisterId(TDBXMetaDataCommands.GetTables, TDBXMetaDataCollectionIndex.Tables);
    Scan.RegisterId(TDBXMetaDataCommandsEx.GetViews, TDBXMetaDataCollectionIndex.Views);
    Scan.RegisterId(TDBXMetaDataCommandsEx.GetSynonyms, TDBXMetaDataCollectionIndex.Synonyms);
    Scan.RegisterId(TDBXMetaDataCommands.GetColumns, TDBXMetaDataCollectionIndex.Columns);
    Scan.RegisterId(TDBXMetaDataCommands.GetIndexes, TDBXMetaDataCollectionIndex.Indexes);
    Scan.RegisterId(TDBXMetaDataCommands.GetIndexColumns, TDBXMetaDataCollectionIndex.IndexColumns);
    Scan.RegisterId(TDBXMetaDataCommands.GetForeignKeys, TDBXMetaDataCollectionIndex.ForeignKeys);
    Scan.RegisterId(TDBXMetaDataCommands.GetForeignKeyColumns, TDBXMetaDataCollectionIndex.ForeignKeyColumns);
    Scan.RegisterId(TDBXMetaDataCommands.GetProcedures, TDBXMetaDataCollectionIndex.Procedures);
    Scan.RegisterId(TDBXMetaDataCommandsEx.GetProcedureSources, TDBXMetaDataCollectionIndex.ProcedureSources);
    Scan.RegisterId(TDBXMetaDataCommands.GetProcedureParameters, TDBXMetaDataCollectionIndex.ProcedureParameters);
    Scan.RegisterId(TDBXMetaDataCommands.GetPackages, TDBXMetaDataCollectionIndex.Packages);
    Scan.RegisterId(TDBXMetaDataCommandsEx.GetPackageProcedures, TDBXMetaDataCollectionIndex.PackageProcedures);
    Scan.RegisterId(TDBXMetaDataCommandsEx.GetPackageProcedureParameters, TDBXMetaDataCollectionIndex.PackageProcedureParameters);
    Scan.RegisterId(TDBXMetaDataCommandsEx.GetPackageSources, TDBXMetaDataCollectionIndex.PackageSources);
    Scan.RegisterId(TDBXMetaDataCommands.GetUsers, TDBXMetaDataCollectionIndex.Users);
    Scan.RegisterId(TDBXMetaDataCommandsEx.GetRoles, TDBXMetaDataCollectionIndex.Roles);
    Scan.RegisterId(TDBXMetaDataCommandsEx.GetReservedWords, TDBXMetaDataCollectionIndex.ReservedWords);
    Scan.RegisterId(TDBXMetaDataTableTypes.Table, TokenTable);
    Scan.RegisterId(TDBXMetaDataTableTypes.View, TokenView);
    Scan.RegisterId(TDBXMetaDataTableTypes.SystemTable, TokenSystemTable);
    Scan.RegisterId(TDBXMetaDataTableTypesEx.SystemView, TokenSystemView);
    Scan.RegisterId(TDBXMetaDataTableTypes.Synonym, TokenSynonym);
    Scan.RegisterId(TDBXProcedureType.ProcedureType, TokenProcedureType);
    Scan.RegisterId(TDBXProcedureType.FunctionType, TokenFunctionType);
    Scan.RegisterId(TDBXMetaDataKeyword.PrimaryKey, TokenPrimaryKey);
    Scan.RegisterId(TDBXMetaDataKeyword.ForeignKey, TokenForeignKey);
    FScanner := Scan;
  end;
end;

function TDBXBaseMetaDataReader.GetDataTypeHash: TDBXObjectStore;
var
  Hash: TDBXObjectStore;
  Descr: TDBXDataTypeDescriptionArray;
  AddedTypes: TDBXArrayList;
begin
  if FDataTypeHash = nil then
  begin
    Hash := TDBXObjectStore.Create;
    Descr := DataTypeDescriptions;
    AddedTypes := TDBXArrayList.Create;
    PopulateDataTypes(Hash, AddedTypes, Descr);
    FreeObjectArray(TDBXFreeArray(Descr));
    FDataTypeHash := Hash;
    FTypes := AddedTypes;
  end;
  Result := FDataTypeHash;
end;

function TDBXBaseMetaDataReader.GetDataTypes: TDBXArrayList;
begin
  DataTypeHash;
  Result := FTypes;
end;

procedure TDBXBaseMetaDataReader.PopulateDataTypes(Hash: TDBXObjectStore; Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray);
var
  Index: Integer;
  DataType: TDBXDataTypeDescription;
  TypeName: WideString;
  MinimumVersion: WideString;
  MaximumVersion: WideString;
begin
  for index := 0 to Length(Descr) - 1 do
  begin
    DataType := Descr[Index];
    if DataType <> nil then
    begin
      TypeName := DataType.TypeName;
      MinimumVersion := DataType.MinimumVersion;
      MaximumVersion := DataType.MaximumVersion;
      if (not Hash.ContainsKey(TypeName) and ((StringIsNil(MinimumVersion)) or (CompareVersion(MinimumVersion) >= 0)) and ((StringIsNil(MaximumVersion)) or (CompareVersion(MaximumVersion) <= 0))) then
      begin
        Hash[TypeName] := DataType;
        Types.Add(DataType);
        Descr[Index] := nil;
      end;
    end;
  end;
end;

function TDBXBaseMetaDataReader.ParseMetaDataCommand(const MetaDataCommand: WideString): TDBXMetaDataCommandParseResult;
var
  Token: Integer;
begin
  InitScanner;
  FScanner.Init(MetaDataCommand);
  Token := FScanner.NextToken;
  case Token of
    TokenDatabase:
      Result := ParseDone(Token, TDBXMetaDataCommands.GetDatabase, nil);
    TDBXMetaDataCollectionIndex.DataTypes:
      Result := ParseDone(Token, TDBXMetaDataCommands.GetDatatypes, nil);
    TDBXMetaDataCollectionIndex.Catalogs:
      Result := ParseDone(Token, TDBXMetaDataCommandsEx.GetCatalogs, nil);
    TDBXMetaDataCollectionIndex.Schemas:
      Result := ParseParameter(Token, TDBXMetaDataCommandsEx.GetSchemas);
    TDBXMetaDataCollectionIndex.Tables:
      Result := ParseGetTables(Token, TDBXMetaDataCommands.GetTables);
    TDBXMetaDataCollectionIndex.Views:
      Result := ParseGetObjectName(Token, 3, TDBXMetaDataCommandsEx.GetViews);
    TDBXMetaDataCollectionIndex.Synonyms:
      Result := ParseGetObjectName(Token, 3, TDBXMetaDataCommandsEx.GetSynonyms);
    TDBXMetaDataCollectionIndex.Columns:
      Result := ParseGetObjectName(Token, 3, TDBXMetaDataCommands.GetColumns);
    TDBXMetaDataCollectionIndex.Indexes:
      Result := ParseGetObjectName(Token, 3, TDBXMetaDataCommands.GetIndexes);
    TDBXMetaDataCollectionIndex.IndexColumns:
      Result := ParseIndexColumns(Token, TDBXMetaDataCommands.GetIndexColumns);
    TDBXMetaDataCollectionIndex.ForeignKeys:
      Result := ParseGetObjectName(Token, 3, TDBXMetaDataCommands.GetForeignKeys);
    TDBXMetaDataCollectionIndex.ForeignKeyColumns:
      Result := ParseForeignKeyColumns(Token, TDBXMetaDataCommands.GetForeignKeyColumns);
    TDBXMetaDataCollectionIndex.Procedures:
      Result := ParseProcedures(Token, 3, TDBXMetaDataCommands.GetProcedures);
    TDBXMetaDataCollectionIndex.ProcedureSources:
      Result := ParseGetObjectName(Token, 3, TDBXMetaDataCommandsEx.GetProcedureSources);
    TDBXMetaDataCollectionIndex.ProcedureParameters:
      Result := ParseProcedureParameters(Token, 3, TDBXMetaDataCommands.GetProcedureParameters);
    TDBXMetaDataCollectionIndex.Packages:
      Result := ParseGetObjectName(Token, 3, TDBXMetaDataCommands.GetPackages);
    TDBXMetaDataCollectionIndex.PackageProcedures:
      Result := ParseProcedures(Token, 4, TDBXMetaDataCommandsEx.GetPackageProcedures);
    TDBXMetaDataCollectionIndex.PackageProcedureParameters:
      Result := ParseProcedureParameters(Token, 4, TDBXMetaDataCommandsEx.GetPackageProcedureParameters);
    TDBXMetaDataCollectionIndex.PackageSources:
      Result := ParseGetObjectName(Token, 3, TDBXMetaDataCommandsEx.GetPackageSources);
    TDBXMetaDataCollectionIndex.Users:
      Result := ParseDone(Token, TDBXMetaDataCommands.GetUsers, nil);
    TDBXMetaDataCollectionIndex.Roles:
      Result := ParseDone(Token, TDBXMetaDataCommandsEx.GetRoles, nil);
    TDBXMetaDataCollectionIndex.ReservedWords:
      Result := ParseDone(Token, TDBXMetaDataCommandsEx.GetReservedWords, nil);
    else
      raise TDBXMetaDataError.Create(SMetaDataCommandExpected);
  end;
end;

function TDBXBaseMetaDataReader.ParseId: WideString;
var
  Token: Integer;
begin
  Token := FScanner.LookAtNextToken;
  case Token of
    TDBXSqlScanner.TokenId:
      begin
        FScanner.NextToken;
        begin
          Result := FScanner.Id;
          exit;
        end;
      end;
    TDBXSqlScanner.TokenSymbol:
      if FScanner.Symbol = '%' then
        FScanner.NextToken;
    else
      if Token > TDBXSqlScanner.TokenEos then
      begin
        FScanner.NextToken;
        begin
          Result := FScanner.Id;
          exit;
        end;
      end;
  end;
  Result := NullString;
end;

procedure TDBXBaseMetaDataReader.ParseSqlObjectName(const Parameters: TDBXWideStringArray; MaxIds: Integer);
var
  Parameter: Integer;
  Token: Integer;
  Index: Integer;
begin
  Parameters[MaxIds - 1] := ParseId;
  Parameter := 1;
  Token := FScanner.LookAtNextToken;
  while (Parameter < MaxIds) and (Token = TDBXSqlScanner.TokenPeriod) do
  begin
    FScanner.NextToken;
    for index := 0 to Parameter - 1 do
      Parameters[MaxIds - Parameter + Index - 1] := Parameters[MaxIds - Parameter + Index];
    Parameters[MaxIds - 1] := ParseId;
    IncrAfter(Parameter);
    Token := FScanner.LookAtNextToken;
  end;
end;

function TDBXBaseMetaDataReader.ParseParameter(CommandToken: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
var
  Parameters: TDBXWideStringArray;
begin
  SetLength(Parameters,1);
  Parameters[0] := ParseId;
  Result := ParseDone(CommandToken, Command, Parameters);
end;

function TDBXBaseMetaDataReader.ParseGetObjectName(CommandToken: Integer; MaxIds: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
var
  Parameters: TDBXWideStringArray;
begin
  SetLength(Parameters,MaxIds);
  ParseSqlObjectName(Parameters, MaxIds);
  Result := ParseDone(CommandToken, Command, Parameters);
end;

function TDBXBaseMetaDataReader.ParseGetTables(CommandToken: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
var
  Parameters: TDBXWideStringArray;
  Types: TDBXWideStringBuffer;
  TableType: WideString;
  Token: Integer;
begin
  SetLength(Parameters,4);
  ParseSqlObjectName(Parameters, 3);
  Types := nil;
  TableType := TDBXTableType.Table;
  while not StringIsNil(TableType) do
  begin
    Token := FScanner.LookAtNextToken;
    case Token of
      TokenTable:
        TableType := TDBXTableType.Table;
      TokenView:
        TableType := TDBXTableType.View;
      TokenSystemTable:
        TableType := TDBXTableType.SystemTable;
      TokenSystemView:
        TableType := TDBXTableType.SystemView;
      TokenSynonym:
        TableType := TDBXTableType.Synonym;
      else
        TableType := NullString;
    end;
    if not StringIsNil(TableType) then
    begin
      FScanner.NextToken;
      if Types = nil then
        Types := TDBXWideStringBuffer.Create
      else 
        Types.Append(',');
      Types.Append(TableType);
      Token := FScanner.LookAtNextToken;
      if (Token = TDBXSqlScanner.TokenSemicolon) or (Token = TDBXSqlScanner.TokenComma) then
        FScanner.NextToken;
    end;
  end;
  if Types <> nil then
    Parameters[3] := Types.ToString;
  FreeAndNil(Types);
  Result := ParseDone(CommandToken, Command, Parameters);
end;

function TDBXBaseMetaDataReader.ParseForeignKeyColumns(CommandToken: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
var
  Parameters: TDBXWideStringArray;
  KeySpecificationFound: Boolean;
  UsePrimaryKey: Boolean;
  KeynameFound: Boolean;
  Token: Integer;
  Index: Integer;
begin
  SetLength(Parameters,8);
  ParseSqlObjectName(Parameters, 3);
  KeySpecificationFound := True;
  UsePrimaryKey := False;
  KeynameFound := False;
  Token := FScanner.LookAtNextToken;
  if (Token <> TokenPrimaryKey) and (Token <> TokenForeignKey) then
  begin
    if Token = TDBXSqlScanner.TokenPeriod then
      FScanner.NextToken;
    Parameters[3] := ParseId;
    Token := FScanner.LookAtNextToken;
  end;
  case Token of
    TokenPrimaryKey:
      UsePrimaryKey := True;
    TokenForeignKey:
      UsePrimaryKey := False;
    else
      KeySpecificationFound := False;
  end;                                                                 
  if KeySpecificationFound then
    FScanner.NextToken;
  if UsePrimaryKey then
    for index := 0 to 3 do
    begin
      Parameters[Index + 4] := Parameters[4];
      Parameters[Index] := NullString;
    end;
  Result := ParseDone(CommandToken, Command, Parameters);
end;

function TDBXBaseMetaDataReader.ParseIndexColumns(CommandToken: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
var
  Parameters: TDBXWideStringArray;
  Token: Integer;
begin
  SetLength(Parameters,4);
  ParseSqlObjectName(Parameters, 3);
  Token := FScanner.LookAtNextToken;
  if Token = TDBXSqlScanner.TokenPeriod then
    FScanner.NextToken;
  Parameters[3] := ParseId;
  Result := ParseDone(CommandToken, Command, Parameters);
end;

function TDBXBaseMetaDataReader.ParseProcedures(CommandToken: Integer; MaxIds: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
var
  Parameters: TDBXWideStringArray;
  ProcType: WideString;
  Token: Integer;
begin
  SetLength(Parameters,MaxIds + 1);
  ParseSqlObjectName(Parameters, MaxIds);
  ProcType := NullString;
  Token := FScanner.LookAtNextToken;
  case Token of
    TokenProcedureType:
      ProcType := TDBXProcedureType.ProcedureType;
    TokenFunctionType:
      ProcType := TDBXProcedureType.FunctionType;
  end;
  if not StringIsNil(ProcType) then
  begin
    FScanner.NextToken;
    Parameters[MaxIds] := ProcType;
  end;
  Result := ParseDone(CommandToken, Command, Parameters);
end;

function TDBXBaseMetaDataReader.ParseProcedureParameters(CommandToken: Integer; MaxIds: Integer; const Command: WideString): TDBXMetaDataCommandParseResult;
var
  Parameters: TDBXWideStringArray;
  Token: Integer;
begin
  SetLength(Parameters,MaxIds + 1);
  ParseSqlObjectName(Parameters, MaxIds);
  Token := FScanner.LookAtNextToken;
  if Token = TDBXSqlScanner.TokenPeriod then
  begin
    FScanner.NextToken;
    Parameters[MaxIds] := ParseId;
  end;
  Result := ParseDone(CommandToken, Command, Parameters);
end;

function TDBXBaseMetaDataReader.ParseDone(CommandToken: Integer; const Command: WideString; const Parameters: TDBXWideStringArray): TDBXMetaDataCommandParseResult;
var
  Token: Integer;
  Culprint: WideString;
begin
  Token := FScanner.NextToken;
  while Token = TDBXSqlScanner.TokenSemicolon do
    Token := FScanner.NextToken;
  if Token <> TDBXSqlScanner.TokenEos then
  begin
    if Token = TDBXSqlScanner.TokenError then
      raise TDBXMetaDataError.Create(Format(SUnclosedQuotes, [FScanner.SqlQuery]));
    Culprint := NullString;
    if (Token < TDBXSqlScanner.TokenEos) and (Token <> TDBXSqlScanner.TokenId) and (Token <> TDBXSqlScanner.TokenNumber) then
      Culprint := FScanner.Symbol
    else 
      Culprint := FScanner.Id;
    raise TDBXMetaDataError.Create(Format(SUnexpectedSymbol, [Culprint,Command,FScanner.SqlQuery]));
  end;
  Result := TDBXMetaDataCommandParseResult.Create(CommandToken, Parameters);
end;

function TDBXBaseMetaDataReader.FetchCollection(const MetaDataCommand: WideString): TDBXTableStorage;
var
  Command: TDBXMetaDataCommandParseResult;
  CommandToken: Integer;
  Parameters: TDBXWideStringArray;
begin
  Command := ParseMetaDataCommand(MetaDataCommand);
  CommandToken := Command.CommandToken;
  Parameters := Command.Parameters;
  FreeAndNil(Command);
  case CommandToken of
    TokenDatabase:
      Result := nil;
    TDBXMetaDataCollectionIndex.DataTypes:
      Result := FetchDataTypes;
    TDBXMetaDataCollectionIndex.Catalogs:
      Result := FetchCatalogs;
    TDBXMetaDataCollectionIndex.Schemas:
      Result := FetchSchemas(Parameters[0]);
    TDBXMetaDataCollectionIndex.Tables:
      Result := FetchTables(Parameters[0], Parameters[1], Parameters[2], Parameters[3]);
    TDBXMetaDataCollectionIndex.Views:
      Result := FetchViews(Parameters[0], Parameters[1], Parameters[2]);
    TDBXMetaDataCollectionIndex.Synonyms:
      Result := FetchSynonyms(Parameters[0], Parameters[1], Parameters[2]);
    TDBXMetaDataCollectionIndex.Columns:
      Result := FetchColumns(Parameters[0], Parameters[1], Parameters[2]);
    TDBXMetaDataCollectionIndex.Indexes:
      Result := FetchIndexes(Parameters[0], Parameters[1], Parameters[2]);
    TDBXMetaDataCollectionIndex.IndexColumns:
      Result := FetchIndexColumns(Parameters[0], Parameters[1], Parameters[2], Parameters[3]);
    TDBXMetaDataCollectionIndex.ForeignKeys:
      Result := FetchForeignKeys(Parameters[0], Parameters[1], Parameters[2]);
    TDBXMetaDataCollectionIndex.ForeignKeyColumns:
      Result := FetchForeignKeyColumns(Parameters[0], Parameters[1], Parameters[2], Parameters[3], Parameters[4], Parameters[5], Parameters[6], Parameters[7]);
    TDBXMetaDataCollectionIndex.Procedures:
      Result := FetchProcedures(Parameters[0], Parameters[1], Parameters[2], Parameters[3]);
    TDBXMetaDataCollectionIndex.ProcedureSources:
      Result := FetchProcedureSources(Parameters[0], Parameters[1], Parameters[2]);
    TDBXMetaDataCollectionIndex.ProcedureParameters:
      Result := FetchProcedureParameters(Parameters[0], Parameters[1], Parameters[2], Parameters[3]);
    TDBXMetaDataCollectionIndex.Packages:
      Result := FetchPackages(Parameters[0], Parameters[1], Parameters[2]);
    TDBXMetaDataCollectionIndex.PackageProcedures:
      Result := FetchPackageProcedures(Parameters[0], Parameters[1], Parameters[2], Parameters[3], Parameters[4]);
    TDBXMetaDataCollectionIndex.PackageProcedureParameters:
      Result := FetchPackageProcedureParameters(Parameters[0], Parameters[1], Parameters[2], Parameters[3], Parameters[4]);
    TDBXMetaDataCollectionIndex.PackageSources:
      Result := FetchPackageSources(Parameters[0], Parameters[1], Parameters[2]);
    TDBXMetaDataCollectionIndex.Users:
      Result := FetchUsers;
    TDBXMetaDataCollectionIndex.Roles:
      Result := FetchRoles;
    TDBXMetaDataCollectionIndex.ReservedWords:
      Result := FetchReservedWords;
    else
      Result := nil;
  end;
end;

function TDBXBaseMetaDataReader.MakeStorage(Cursor: TDBXTableStorage): TDBXTableStorage;
var
  Storage: TDBXTableStorage;
begin
  Storage := FContext.CreateTableStorage(Cursor.MetaDataCollectionIndex, Cursor.MetaDataCollectionName, Cursor.CopyColumns);
  Storage.CopyFrom(Cursor);
  Cursor.Close;
  FreeAndNil(Cursor);
  Storage.AcceptChanges;
  Result := Storage;
end;

function TDBXBaseMetaDataReader.FetchCollectionWithStorage(const MetaDataCommand: WideString): TDBXTableStorage;
begin
  Result := MakeStorage(FetchCollection(MetaDataCommand));
end;

function TDBXBaseMetaDataReader.FetchDataTypes: TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateDataTypesColumns;
  Result := TDBXBaseMetaDataReader.TDBXDataTypeCursor.Create(self, Columns, DataTypes);
end;

function TDBXBaseMetaDataReader.FetchCatalogs: TDBXTableStorage;
var
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  Cursor := FContext.ExecuteQuery(SqlForCatalogs, nil, nil);
  Columns := TDBXMetaDataCollectionColumns.CreateCatalogsColumns;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.Catalogs, TDBXMetaDataCollectionName.Catalogs, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchSchemas(const Catalog: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(ParameterNames,1);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  SetLength(ParameterValues,1);
  ParameterValues[0] := Catalog;
  Cursor := FContext.ExecuteQuery(SqlForSchemas, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateSchemasColumns;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.Schemas, TDBXMetaDataCollectionName.Schemas, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchTables(const Catalog: WideString; const Schema: WideString; const TableName: WideString; const TableType: WideString): TDBXTableStorage;
var
  TypeMask: Integer;
  Tables: WideString;
  Views: WideString;
  SystemTables: WideString;
  SystemViews: WideString;
  Synonyms: WideString;
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  TypeMask := TDBXTableTypeParser.ParseTableTypes(TableType);
  Tables := MakeTableTypeString(TDBXTableTypeFlag.Table, TypeMask);
  Views := MakeTableTypeString(TDBXTableTypeFlag.View, TypeMask);
  SystemTables := MakeTableTypeString(TDBXTableTypeFlag.SystemTable, TypeMask);
  SystemViews := MakeTableTypeString(TDBXTableTypeFlag.SystemView, TypeMask);
  Synonyms := MakeTableTypeString(TDBXTableTypeFlag.Synonym, TypeMask);
  SetLength(ParameterNames,8);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.TableName;
  ParameterNames[3] := TDBXParameterName.Tables;
  ParameterNames[4] := TDBXParameterName.Views;
  ParameterNames[5] := TDBXParameterName.SystemTables;
  ParameterNames[6] := TDBXParameterName.SystemViews;
  ParameterNames[7] := TDBXParameterName.Synonyms;
  SetLength(ParameterValues,8);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := TableName;
  ParameterValues[3] := Tables;
  ParameterValues[4] := Views;
  ParameterValues[5] := SystemTables;
  ParameterValues[6] := SystemViews;
  ParameterValues[7] := Synonyms;
  Cursor := FContext.ExecuteQuery(SqlForTables, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateTablesColumns;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.Tables, TDBXMetaDataCollectionName.Tables, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchViews(const Catalog: WideString; const Schema: WideString; const View: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
  OrdinalLineNumber: Integer;
begin
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.ViewName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := View;
  Cursor := FContext.ExecuteQuery(SqlForViews, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateViewsColumns;
  OrdinalLineNumber := FindSourceLineColumn(Cursor, Length(Columns));
  if OrdinalLineNumber > 0 then
    Result := TDBXBaseMetaDataReader.TDBXSourceTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.Views, TDBXMetaDataCollectionName.Views, Columns, Cursor, TDBXViewsIndex.Definition, OrdinalLineNumber)
  else 
    Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.Views, TDBXMetaDataCollectionName.Views, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  DataTypeHash;
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.TableName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Table;
  Cursor := FContext.ExecuteQuery(SqlForColumns, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateColumnsColumns;
  Cursor := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.Columns, TDBXMetaDataCollectionName.Columns, Columns, Cursor);
  Result := TDBXBaseMetaDataReader.TDBXColumnsTableCursor.Create(self, False, Cursor);
end;

function TDBXBaseMetaDataReader.FetchColumnConstraints(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.TableName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Table;
  Cursor := FContext.ExecuteQuery(SqlForColumnConstraints, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateColumnConstraintsColumns;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.ColumnConstraints, TDBXMetaDataCollectionName.ColumnConstraints, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchIndexes(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.TableName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Table;
  Cursor := FContext.ExecuteQuery(SqlForIndexes, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateIndexesColumns;
  Columns[TDBXIndexesIndex.IsAscending].Hidden := DescendingIndexSupported;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.Indexes, TDBXMetaDataCollectionName.Indexes, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchIndexColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const Index: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(ParameterNames,4);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.TableName;
  ParameterNames[3] := TDBXParameterName.IndexName;
  SetLength(ParameterValues,4);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Table;
  ParameterValues[3] := Index;
  Cursor := FContext.ExecuteQuery(SqlForIndexColumns, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateIndexColumnsColumns;
  Columns[TDBXIndexColumnsIndex.IsAscending].Hidden := DescendingIndexColumnsSupported;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.IndexColumns, TDBXMetaDataCollectionName.IndexColumns, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchForeignKeys(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.TableName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Table;
  Cursor := FContext.ExecuteQuery(SqlForForeignKeys, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateForeignKeysColumns;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.ForeignKeys, TDBXMetaDataCollectionName.ForeignKeys, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchForeignKeyColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const ForeignKeyName: WideString; const PrimaryCatalog: WideString; const PrimarySchema: WideString; const PrimaryTable: WideString; const PrimaryKeyName: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(ParameterNames,8);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.TableName;
  ParameterNames[3] := TDBXParameterName.ForeignKeyName;
  ParameterNames[4] := TDBXParameterName.PrimaryCatalogName;
  ParameterNames[5] := TDBXParameterName.PrimarySchemaName;
  ParameterNames[6] := TDBXParameterName.PrimaryTableName;
  ParameterNames[7] := TDBXParameterName.PrimaryKeyName;
  SetLength(ParameterValues,8);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Table;
  ParameterValues[3] := ForeignKeyName;
  ParameterValues[4] := PrimaryCatalog;
  ParameterValues[5] := PrimarySchema;
  ParameterValues[6] := PrimaryTable;
  ParameterValues[7] := PrimaryKeyName;
  Cursor := FContext.ExecuteQuery(SqlForForeignKeyColumns, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateForeignKeyColumnsColumns;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.ForeignKeyColumns, TDBXMetaDataCollectionName.ForeignKeyColumns, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchSynonyms(const Catalog: WideString; const Schema: WideString; const Synonym: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.SynonymName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Synonym;
  Cursor := FContext.ExecuteQuery(SqlForSynonyms, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateSynonymsColumns;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.Synonyms, TDBXMetaDataCollectionName.Synonyms, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchProcedures(const Catalog: WideString; const Schema: WideString; const ProcedureName: WideString; const ProcedureType: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(ParameterNames,4);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.ProcedureName;
  ParameterNames[3] := TDBXParameterName.ProcedureType;
  SetLength(ParameterValues,4);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := ProcedureName;
  ParameterValues[3] := ProcedureType;
  Cursor := FContext.ExecuteQuery(SqlForProcedures, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateProceduresColumns;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.Procedures, TDBXMetaDataCollectionName.Procedures, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchProcedureSources(const Catalog: WideString; const Schema: WideString; const &Procedure: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
  OrdinalLineNumber: Integer;
begin
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.ProcedureName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := &Procedure;
  Cursor := FContext.ExecuteQuery(SqlForProcedureSources, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateProcedureSourcesColumns;
  OrdinalLineNumber := FindSourceLineColumn(Cursor, Length(Columns));
  if OrdinalLineNumber > 0 then
    Result := TDBXBaseMetaDataReader.TDBXSourceTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.ProcedureSources, TDBXMetaDataCollectionName.ProcedureSources, Columns, Cursor, TDBXProcedureSourcesIndex.Definition, OrdinalLineNumber)
  else 
    Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.ProcedureSources, TDBXMetaDataCollectionName.ProcedureSources, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchProcedureParameters(const Catalog: WideString; const Schema: WideString; const &Procedure: WideString; const Parameter: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  DataTypeHash;
  SetLength(ParameterNames,4);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.ProcedureName;
  ParameterNames[3] := TDBXParameterName.ParameterName;
  SetLength(ParameterValues,4);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := &Procedure;
  ParameterValues[3] := Parameter;
  Cursor := FContext.ExecuteQuery(SqlForProcedureParameters, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateProcedureParametersColumns;
  Cursor := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.ProcedureParameters, TDBXMetaDataCollectionName.ProcedureParameters, Columns, Cursor);
  Result := TDBXBaseMetaDataReader.TDBXColumnsTableCursor.Create(self, False, Cursor);
end;

function TDBXBaseMetaDataReader.FetchPackages(const Catalog: WideString; const Schema: WideString; const PackageName: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.PackageName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := PackageName;
  Cursor := FContext.ExecuteQuery(SqlForPackages, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreatePackagesColumns;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.Packages, TDBXMetaDataCollectionName.Packages, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchPackageProcedures(const Catalog: WideString; const Schema: WideString; const PackageName: WideString; const ProcedureName: WideString; const ProcedureType: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(ParameterNames,5);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.PackageName;
  ParameterNames[3] := TDBXParameterName.ProcedureName;
  ParameterNames[4] := TDBXParameterName.ProcedureType;
  SetLength(ParameterValues,5);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := PackageName;
  ParameterValues[3] := ProcedureName;
  ParameterValues[4] := ProcedureType;
  Cursor := FContext.ExecuteQuery(SqlForPackageProcedures, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreatePackageProceduresColumns;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.PackageProcedures, TDBXMetaDataCollectionName.PackageProcedures, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchPackageProcedureParameters(const Catalog: WideString; const Schema: WideString; const PackageName: WideString; const ProcedureName: WideString; const ParameterName: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  DataTypeHash;
  SetLength(ParameterNames,5);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.PackageName;
  ParameterNames[3] := TDBXParameterName.ProcedureName;
  ParameterNames[4] := TDBXParameterName.ParameterName;
  SetLength(ParameterValues,5);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := PackageName;
  ParameterValues[3] := ProcedureName;
  ParameterValues[4] := ParameterName;
  Cursor := FContext.ExecuteQuery(SqlForPackageProcedureParameters, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreatePackageProcedureParametersColumns;
  Cursor := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.PackageProcedureParameters, TDBXMetaDataCollectionName.PackageProcedureParameters, Columns, Cursor);
  Result := TDBXBaseMetaDataReader.TDBXColumnsTableCursor.Create(self, False, Cursor);
end;

function TDBXBaseMetaDataReader.FetchPackageSources(const Catalog: WideString; const Schema: WideString; const PackageName: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.PackageName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := PackageName;
  Cursor := FContext.ExecuteQuery(SqlForPackageSources, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreatePackageSourcesColumns;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.PackageSources, TDBXMetaDataCollectionName.PackageSources, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchUsers: TDBXTableStorage;
var
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  Cursor := FContext.ExecuteQuery(SqlForUsers, nil, nil);
  Columns := TDBXMetaDataCollectionColumns.CreateUsersColumns;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.Users, TDBXMetaDataCollectionName.Users, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchRoles: TDBXTableStorage;
var
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  Cursor := FContext.ExecuteQuery(SqlForRoles, nil, nil);
  Columns := TDBXMetaDataCollectionColumns.CreateRolesColumns;
  Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.Roles, TDBXMetaDataCollectionName.Roles, Columns, Cursor);
end;

function TDBXBaseMetaDataReader.FetchReservedWords: TDBXTableStorage;
var
  ReservedSqlWords: TDBXWideStringArray;
  Columns: TDBXColumnDescriptorArray;
  Cursor: TDBXTableStorage;
begin
  ReservedSqlWords := ReservedWords;
  Columns := TDBXMetaDataCollectionColumns.CreateReservedWordsColumns;
  if ReservedSqlWords = nil then
  begin
    Cursor := FContext.ExecuteQuery(SqlForReservedWords, nil, nil);
    Result := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.ReservedWords, TDBXMetaDataCollectionName.ReservedWords, Columns, Cursor);
  end
  else 
    Result := TDBXBaseMetaDataReader.TDBXReservedWordsCursor.Create(FContext, Columns, ReservedSqlWords);
end;

function TDBXBaseMetaDataReader.GetDataTypeDescriptions: TDBXDataTypeDescriptionArray;
begin
  Result := nil;
end;

function TDBXBaseMetaDataReader.GetReservedWords: TDBXWideStringArray;
begin
  Result := nil;
end;

function TDBXBaseMetaDataReader.GetSqlForDataTypes: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForCatalogs: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForSchemas: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForTables: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForViews: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForColumns: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForColumnConstraints: WideString;
begin
  Result := NullString;
end;

function TDBXBaseMetaDataReader.GetSqlForIndexes: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForIndexColumns: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForForeignKeys: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForForeignKeyColumns: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForSynonyms: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForProcedures: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForProcedureSources: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForProcedureParameters: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForPackages: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForPackageProcedures: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForPackageProcedureParameters: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForPackageSources: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForUsers: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForRoles: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

function TDBXBaseMetaDataReader.GetSqlForReservedWords: WideString;
begin
  raise TDBXMetaDataError.Create(SMissingImplementation);
end;

constructor TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray);
begin
  inherited Create;
  self.FColumns := Columns;
  self.FMetaDataCollectionName := MetaDataCollectionName;
  self.FMetaDataCollectionIndex := MetaDataCollectionIndex;
end;

destructor TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Destroy;
begin
  FreeObjectArray(TDBXFreeArray(FColumns));
  inherited Destroy;
end;

function TDBXBaseMetaDataReader.TDBXEmptyTableCursor.GetMetaDataCollectionIndex: Integer;
begin
  Result := FMetaDataCollectionIndex;
end;

function TDBXBaseMetaDataReader.TDBXEmptyTableCursor.GetMetaDataCollectionName: WideString;
begin
  Result := FMetaDataCollectionName;
end;

function TDBXBaseMetaDataReader.TDBXEmptyTableCursor.GetColumns: TDBXColumnDescriptorArray;
begin
  Result := FColumns;
end;

function TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Next: Boolean;
begin
  Result := False;
end;

procedure TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Close;
begin
end;

constructor TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(const TypeNames: TDBXPlatformTypeNames; MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray; const Cursor: TDBXTableStorage);
begin
  inherited Create;
  self.FTypeNames := TypeNames;
  self.FMetaDataCollectionIndex := MetaDataCollectionIndex;
  self.FMetaDataCollectionName := MetaDataCollectionName;
  self.FCursor := Cursor;
  self.FColumns := Columns;
end;

destructor TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Destroy;
begin
  FreeAndNil(FCursor);
  FreeObjectArray(TDBXFreeArray(FColumns));
  inherited Destroy;
end;

function TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.GetCommand: TObject;
begin
  if FCursor = nil then
    Result := nil
  else 
    Result := FCursor.Command;
end;

function TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer;
var
  Column: TDBXColumnDescriptor;
begin
  Column := SourceColumns[Ordinal];
  case Column.ColumnType of
    TDBXDataTypes.WideStringType:
      Result := Column.DataSize;
    TDBXDataTypes.AnsiStringType:
      Result := 2 * Column.DataSize;
    TDBXDataTypes.Int16Type:
      Result := 6;
    TDBXDataTypes.Int32Type:
      Result := 11;
    TDBXDataTypes.Int64Type:
      Result := 20;
    TDBXDataTypes.BooleanType:
      Result := 5;
    else
      Result := 0;
  end;
end;

procedure TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.AdjustColumnSize;
var
  SourceColumns: TDBXColumnDescriptorArray;
  Ordinal: Integer;
begin
  if FCursor <> nil then
  begin
    SourceColumns := FCursor.Columns;
    for ordinal := 0 to Length(FColumns) - 1 do
      case FColumns[Ordinal].ColumnType of
        TDBXDataTypes.WideStringType:
          FColumns[Ordinal].DataSize := FindStringSize(Ordinal, SourceColumns);
        TDBXDataTypes.Int16Type:
          FColumns[Ordinal].DataSize := 2;
        TDBXDataTypes.Int32Type:
          FColumns[Ordinal].DataSize := 4;
        TDBXDataTypes.Int64Type:
          FColumns[Ordinal].DataSize := 8;
        TDBXDataTypes.BooleanType:
          FColumns[Ordinal].DataSize := 2;
      end;
  end;
end;

function TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.GetMetaDataCollectionIndex: Integer;
begin
  Result := FMetaDataCollectionIndex;
end;

function TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.GetMetaDataCollectionName: WideString;
begin
  Result := FMetaDataCollectionName;
end;

function TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Next: Boolean;
begin
  Result := FCursor.Next;
end;

procedure TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Close;
begin
  FCursor.Close;
end;

function TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.GetColumns: TDBXColumnDescriptorArray;
begin
  if not FColumnsSizeAdjusted then
  begin
    AdjustColumnSize;
    FColumnsSizeAdjusted := True;
  end;
  Result := FColumns;
end;

procedure TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.CheckColumn(const Ordinal: Integer; const ColumnType: Integer);
begin
  if (Ordinal < 0) or (Ordinal > Length(FColumns)) then
    raise TDBXMetaDataError.Create(SOrdinalOutOfRange);
  if (ColumnType <> TDBXDataTypes.UnknownType) and (ColumnType <> FColumns[Ordinal].ColumnType) then
    raise TDBXMetaDataError.Create(Format(SWrongAccessorForType, [FTypeNames.GetPlatformTypeName(FColumns[Ordinal].ColumnType, False)]));
end;

function TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.IsNull(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.UnknownType);
  Result := FCursor.IsNull(Ordinal);
end;

function TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.GetInt16(Ordinal: Integer): SmallInt;
begin
  CheckColumn(Ordinal, TDBXDataTypes.Int16Type);
  Result := FCursor.GetAsInt16(Ordinal);
end;

function TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.GetInt32(Ordinal: Integer): Integer;
begin
  CheckColumn(Ordinal, TDBXDataTypes.Int32Type);
  if (FMetaDataCollectionIndex = TDBXMetaDataCollectionIndex.Columns) and (Ordinal = TDBXColumnsIndex.Precision) then
    try
      begin
        Result := FCursor.GetAsInt32(Ordinal);
        exit;
      end;
    except
      on Ex: Exception do
      begin
        Result := High(Integer);
        exit;
      end;
    end;
  Result := FCursor.GetAsInt32(Ordinal);
end;

function TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.GetInt64(Ordinal: Integer): Int64;
begin
  CheckColumn(Ordinal, TDBXDataTypes.Int64Type);
  Result := FCursor.GetAsInt64(Ordinal);
end;

function TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.GetBoolean(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.BooleanType);
  Result := FCursor.GetAsBoolean(Ordinal);
end;

function TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.GetString(Ordinal: Integer): WideString;
begin
  CheckColumn(Ordinal, TDBXDataTypes.WideStringType);
  Result := FCursor.GetAsString(Ordinal);
end;

constructor TDBXBaseMetaDataReader.TDBXColumnsTableCursor.Create(Reader: TDBXBaseMetaDataReader; CheckBase: Boolean; const Cursor: TDBXTableStorage);
begin
  inherited Create(Cursor);
  self.FDataTypeHash := Reader.DataTypeHash;
  self.FReader := Reader;
  self.FCheckBase := CheckBase;
  FOrdinalOffset := 0;
  FOrdinalTypeName := TDBXColumnsIndex.TypeName;
  case MetaDataCollectionIndex of
    TDBXMetaDataCollectionIndex.ProcedureParameters:
      begin
        FOrdinalOffset := TDBXColumnsIndex.DbxDataType - TDBXProcedureParametersIndex.DbxDataType;
        FOrdinalTypeName := TDBXProcedureParametersIndex.TypeName;
      end;
    TDBXMetaDataCollectionIndex.PackageProcedureParameters:
      begin
        FOrdinalOffset := TDBXColumnsIndex.DbxDataType - TDBXPackageProcedureParametersIndex.DbxDataType;
        FOrdinalTypeName := TDBXPackageProcedureParametersIndex.TypeName;
      end;
  end;
end;

procedure TDBXBaseMetaDataReader.TDBXColumnsTableCursor.CheckColumn(const Ordinal: Integer; const ColumnType: Integer);
var
  TableColumns: TDBXColumnDescriptorArray;
begin
  TableColumns := Columns;
  if (Ordinal < 0) or (Ordinal > Length(TableColumns)) then
    raise TDBXMetaDataError.Create(SOrdinalOutOfRange);
  if (ColumnType <> TDBXDataTypes.UnknownType) and (ColumnType <> TableColumns[Ordinal].ColumnType) then
    raise TDBXMetaDataError.Create(Format(SWrongAccessorForType, [FReader.FContext.GetPlatformTypeName(TableColumns[Ordinal].ColumnType, False)]));
end;

function TDBXBaseMetaDataReader.TDBXColumnsTableCursor.Next: Boolean;
begin
  FDataType := nil;
  Result := inherited Next;
end;

procedure TDBXBaseMetaDataReader.TDBXColumnsTableCursor.LookupDataType;
begin
  if FDataType = nil then
    FDataType := TDBXDataTypeDescription(FDataTypeHash[inherited GetString(FOrdinalTypeName)]);
end;

function TDBXBaseMetaDataReader.TDBXColumnsTableCursor.IsNull(Ordinal: Integer): Boolean;
begin
  if Ordinal + FOrdinalOffset >= TDBXColumnsIndex.DbxDataType then
    Result := False
  else 
    Result := inherited IsNull(Ordinal);
end;

function TDBXBaseMetaDataReader.TDBXColumnsTableCursor.GetInt32(Ordinal: Integer): Integer;
begin
  if Ordinal + FOrdinalOffset < TDBXColumnsIndex.DbxDataType then
    Result := inherited GetInt32(Ordinal)
  else 
  begin
    CheckColumn(Ordinal, TDBXDataTypes.Int32Type);
    LookupDataType;
    if FDataType = nil then
    begin
      Result := TDBXDataTypes.UnknownType;
      exit;
    end;
    Result := FDataType.DbxDataType;
  end;
end;

function TDBXBaseMetaDataReader.TDBXColumnsTableCursor.GetAsInt32(Ordinal: Integer): Integer;
begin
  Result := GetInt32(Ordinal);
end;

function TDBXBaseMetaDataReader.TDBXColumnsTableCursor.GetBoolean(Ordinal: Integer): Boolean;
begin
  if Ordinal + FOrdinalOffset < TDBXColumnsIndex.DbxDataType then
    Result := inherited GetBoolean(Ordinal)
  else 
  begin
    if FCheckBase and not inherited IsNull(Ordinal) then
    begin
      Result := inherited GetBoolean(Ordinal);
      exit;
    end;
    CheckColumn(Ordinal, TDBXDataTypes.BooleanType);
    LookupDataType;
    if FDataType = nil then
    begin
      Result := False;
      exit;
    end;
    case Ordinal + FOrdinalOffset of
      TDBXColumnsIndex.IsFixedLength:
        Result := FDataType.FixedLength;
      TDBXColumnsIndex.IsUnicode:
        Result := FDataType.Unicode;
      TDBXColumnsIndex.IsLong:
        Result := FDataType.Long;
      TDBXColumnsIndex.IsUnsigned:
        Result := FDataType.Unsigned;
      else
        Result := False;
    end;
  end;
end;

function TDBXBaseMetaDataReader.TDBXColumnsTableCursor.GetAsBoolean(Ordinal: Integer): Boolean;
begin
  Result := GetBoolean(Ordinal);
end;

constructor TDBXBaseMetaDataReader.TDBXSourceTableCursor.Create(const Context: TDBXProviderContext; MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray; const Cursor: TDBXTableStorage; const OrdinalDefinition: Integer; const OrdinalLineNumber: Integer);
begin
  inherited Create(Context, MetaDataCollectionIndex, MetaDataCollectionName, Columns, Cursor);
  self.FOrdinalLineNumber := OrdinalLineNumber;
  self.FOrdinalDefinition := OrdinalDefinition;
  self.FRowStorage := Context.CreateRowStorage(MetaDataCollectionIndex, MetaDataCollectionName, self.CopyColumns);
  self.FBuffer := TDBXWideStringBuffer.Create;
  self.FBeforeFirst := True;
end;

destructor TDBXBaseMetaDataReader.TDBXSourceTableCursor.Destroy;
begin
  FreeAndNil(FRowStorage);
  FreeAndNil(FBuffer);
  inherited Destroy;
end;

function TDBXBaseMetaDataReader.TDBXSourceTableCursor.Next: Boolean;
var
  LineNumber: Integer;
  PrevLineNumber: Integer;
  Ordinal: Integer;
begin
  if FBeforeFirst then
  begin
    FBeforeEnd := FCursor.Next;
    FBeforeFirst := False;
  end;
  if not FBeforeEnd then
  begin
    Result := False;
    exit;
  end;
  LineNumber := FCursor.GetAsInt32(FOrdinalLineNumber);
  PrevLineNumber := LineNumber - 1;
  for ordinal := 0 to Length(FColumns) - 1 do
    FCursor.CopyTo(Ordinal, FRowStorage, Ordinal);
  FBuffer.Length := 0;
  while FBeforeEnd and (LineNumber > PrevLineNumber) do
  begin
    FBuffer.Append(FCursor.GetAsString(FOrdinalDefinition));
    FBeforeEnd := FCursor.Next;
    if FBeforeEnd then
    begin
      PrevLineNumber := LineNumber;
      LineNumber := FCursor.GetAsInt32(FOrdinalLineNumber);
    end;
  end;
  FRowStorage.SetString(FOrdinalDefinition, FBuffer.ToString);
  Result := True;
end;

function TDBXBaseMetaDataReader.TDBXSourceTableCursor.IsNull(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.UnknownType);
  Result := FRowStorage.IsNull(Ordinal);
end;

function TDBXBaseMetaDataReader.TDBXSourceTableCursor.GetInt16(Ordinal: Integer): SmallInt;
begin
  CheckColumn(Ordinal, TDBXDataTypes.Int16Type);
  Result := FRowStorage.GetInt16(Ordinal);
end;

function TDBXBaseMetaDataReader.TDBXSourceTableCursor.GetInt32(Ordinal: Integer): Integer;
begin
  CheckColumn(Ordinal, TDBXDataTypes.Int32Type);
  Result := FRowStorage.GetInt32(Ordinal);
end;

function TDBXBaseMetaDataReader.TDBXSourceTableCursor.GetInt64(Ordinal: Integer): Int64;
begin
  CheckColumn(Ordinal, TDBXDataTypes.Int64Type);
  Result := FRowStorage.GetInt64(Ordinal);
end;

function TDBXBaseMetaDataReader.TDBXSourceTableCursor.GetBoolean(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.BooleanType);
  Result := FRowStorage.GetBoolean(Ordinal);
end;

function TDBXBaseMetaDataReader.TDBXSourceTableCursor.GetString(Ordinal: Integer): WideString;
begin
  CheckColumn(Ordinal, TDBXDataTypes.WideStringType);
  Result := FRowStorage.GetString(Ordinal);
end;

constructor TDBXBaseMetaDataReader.TDBXDataTypeCursor.Create(const Reader: TDBXBaseMetaDataReader; const Columns: TDBXColumnDescriptorArray; Types: TDBXArrayList);
begin
  inherited Create;
  self.FReader := Reader;
  self.FTypes := Types;
  self.FColumns := Columns;
  self.FRowIndex := -1;
end;

destructor TDBXBaseMetaDataReader.TDBXDataTypeCursor.Destroy;
begin
  FreeObjectArray(TDBXFreeArray(FColumns));
  inherited Destroy;
end;

function TDBXBaseMetaDataReader.TDBXDataTypeCursor.GetMetaDataCollectionIndex: Integer;
begin
  Result := TDBXMetaDataCollectionIndex.DataTypes;
end;

function TDBXBaseMetaDataReader.TDBXDataTypeCursor.GetMetaDataCollectionName: WideString;
begin
  Result := TDBXMetaDataCollectionName.DataTypes;
end;

function TDBXBaseMetaDataReader.TDBXDataTypeCursor.GetColumns: TDBXColumnDescriptorArray;
begin
  Result := FColumns;
end;

procedure TDBXBaseMetaDataReader.TDBXDataTypeCursor.Close;
begin
end;

procedure TDBXBaseMetaDataReader.TDBXDataTypeCursor.CheckColumn(const Ordinal: Integer; const ColumnType: Integer);
begin
  if FRowIndex < 0 then
    raise TDBXMetaDataError.Create(SMustCallNextFirst);
  if FRowIndex >= FTypes.Count then
    raise TDBXMetaDataError.Create(SPastEndOfCursor);
  if (Ordinal < 0) or (Ordinal > Length(FColumns)) then
    raise TDBXMetaDataError.Create(SOrdinalOutOfRange);
  if (ColumnType <> TDBXDataTypes.UnknownType) and (ColumnType <> FColumns[Ordinal].ColumnType) then
    raise TDBXMetaDataError.Create(Format(SWrongAccessorForType, [FReader.FContext.GetPlatformTypeName(FColumns[Ordinal].ColumnType, False)]));
end;

procedure TDBXBaseMetaDataReader.TDBXDataTypeCursor.BeforeFirst;
begin
  FRowIndex := -1;
end;

function TDBXBaseMetaDataReader.TDBXDataTypeCursor.Next: Boolean;
begin
  IncrAfter(FRowIndex);
  if FRowIndex >= FTypes.Count then
  begin
    Result := False;
    exit;
  end;
  FCurrent := TDBXDataTypeDescription(FTypes[FRowIndex]);
  Result := True;
end;

function TDBXBaseMetaDataReader.TDBXDataTypeCursor.IsNull(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.UnknownType);
  case Ordinal of
    TDBXDataTypesIndex.TypeName,
    TDBXDataTypesIndex.CreateFormat,
    TDBXDataTypesIndex.CreateParameters,
    TDBXDataTypesIndex.DataType,
    TDBXDataTypesIndex.MaximumVersion,
    TDBXDataTypesIndex.MinimumVersion,
    TDBXDataTypesIndex.LiteralPrefix,
    TDBXDataTypesIndex.LiteralSuffix:
      Result := (StringIsNil(GetString(Ordinal)));
    else
      Result := False;
  end;
end;

function TDBXBaseMetaDataReader.TDBXDataTypeCursor.GetInt16(Ordinal: Integer): SmallInt;
begin
  CheckColumn(Ordinal, TDBXDataTypes.Int16Type);
  case Ordinal of
    TDBXDataTypesIndex.MaximumScale:
      Result := FCurrent.MaximumScale;
    TDBXDataTypesIndex.MinimumScale:
      Result := FCurrent.MinimumScale;
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

function TDBXBaseMetaDataReader.TDBXDataTypeCursor.GetInt32(Ordinal: Integer): Integer;
begin
  CheckColumn(Ordinal, TDBXDataTypes.Int32Type);
  case Ordinal of
    TDBXDataTypesIndex.DbxDataType,
    TDBXDataTypesIndex.ProviderDbType:
      Result := FCurrent.DbxDataType;
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

function TDBXBaseMetaDataReader.TDBXDataTypeCursor.GetInt64(Ordinal: Integer): Int64;
begin
  CheckColumn(Ordinal, TDBXDataTypes.Int64Type);
  case Ordinal of
    TDBXDataTypesIndex.ColumnSize:
      Result := FCurrent.ColumnSize;
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

function TDBXBaseMetaDataReader.TDBXDataTypeCursor.GetBoolean(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.BooleanType);
  case Ordinal of
    TDBXDataTypesIndex.IsAutoIncrementable:
      Result := FCurrent.AutoIncrementable;
    TDBXDataTypesIndex.IsBestMatch:
      Result := FCurrent.BestMatch;
    TDBXDataTypesIndex.IsCaseSensitive:
      Result := FCurrent.CaseSensitive;
    TDBXDataTypesIndex.IsFixedLength:
      Result := FCurrent.FixedLength;
    TDBXDataTypesIndex.IsFixedPrecisionScale:
      Result := FCurrent.FixedPrecisionScale;
    TDBXDataTypesIndex.IsLong:
      Result := FCurrent.Long;
    TDBXDataTypesIndex.IsNullable:
      Result := FCurrent.Nullable;
    TDBXDataTypesIndex.IsSearchable:
      Result := FCurrent.Searchable;
    TDBXDataTypesIndex.IsSearchableWithLike:
      Result := FCurrent.SearchableWithLike;
    TDBXDataTypesIndex.IsUnsigned:
      Result := FCurrent.Unsigned;
    TDBXDataTypesIndex.IsConcurrencyType:
      Result := FCurrent.ConcurrencyType;
    TDBXDataTypesIndex.IsLiteralSupported:
      Result := FCurrent.LiteralSupported;
    TDBXDataTypesIndex.IsUnicode:
      Result := FCurrent.Unicode;
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

function TDBXBaseMetaDataReader.TDBXDataTypeCursor.GetString(Ordinal: Integer): WideString;
begin
  CheckColumn(Ordinal, TDBXDataTypes.WideStringType);
  case Ordinal of
    TDBXDataTypesIndex.TypeName:
      Result := FCurrent.TypeName;
    TDBXDataTypesIndex.CreateFormat:
      Result := FCurrent.CreateFormat;
    TDBXDataTypesIndex.CreateParameters:
      Result := FCurrent.CreateParameters;
    TDBXDataTypesIndex.DataType:
      Result := FCurrent.GetDataType(FReader.FContext);
    TDBXDataTypesIndex.MaximumVersion:
      Result := FCurrent.MaximumVersion;
    TDBXDataTypesIndex.MinimumVersion:
      Result := FCurrent.MinimumVersion;
    TDBXDataTypesIndex.LiteralPrefix:
      Result := FCurrent.LiteralPrefix;
    TDBXDataTypesIndex.LiteralSuffix:
      Result := FCurrent.LiteralSuffix;
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

constructor TDBXBaseMetaDataReader.TDBXReservedWordsCursor.Create(const TypeNames: TDBXPlatformTypeNames; const Columns: TDBXColumnDescriptorArray; const Keywords: TDBXWideStringArray);
begin
  inherited Create;
  self.FTypeNames := TypeNames;
  self.FKeywords := Keywords;
  self.FColumns := Columns;
  self.FRowIndex := -1;
end;

destructor TDBXBaseMetaDataReader.TDBXReservedWordsCursor.Destroy;
begin
  FreeObjectArray(TDBXFreeArray(FColumns));
  FKeywords := nil;
  inherited Destroy;
end;

function TDBXBaseMetaDataReader.TDBXReservedWordsCursor.GetMetaDataCollectionIndex: Integer;
begin
  Result := TDBXMetaDataCollectionIndex.ReservedWords;
end;

function TDBXBaseMetaDataReader.TDBXReservedWordsCursor.GetMetaDataCollectionName: WideString;
begin
  Result := TDBXMetaDataCollectionName.ReservedWords;
end;

function TDBXBaseMetaDataReader.TDBXReservedWordsCursor.GetColumns: TDBXColumnDescriptorArray;
begin
  Result := FColumns;
end;

procedure TDBXBaseMetaDataReader.TDBXReservedWordsCursor.CheckColumn(const Ordinal: Integer; const ColumnType: Integer);
begin
  if FRowIndex < 0 then
    raise TDBXMetaDataError.Create(SMustCallNextFirst);
  if FRowIndex >= Length(FKeywords) then
    raise TDBXMetaDataError.Create(SPastEndOfCursor);
  if (Ordinal < 0) or (Ordinal > Length(FColumns)) then
    raise TDBXMetaDataError.Create(SOrdinalOutOfRange);
  if (ColumnType <> TDBXDataTypes.UnknownType) and (ColumnType <> FColumns[Ordinal].ColumnType) then
    raise TDBXMetaDataError.Create(Format(SWrongAccessorForType, [FTypeNames.GetPlatformTypeName(FColumns[Ordinal].ColumnType, False)]));
end;

procedure TDBXBaseMetaDataReader.TDBXReservedWordsCursor.BeforeFirst;
begin
  FRowIndex := -1;
end;

function TDBXBaseMetaDataReader.TDBXReservedWordsCursor.Next: Boolean;
begin
  IncrAfter(FRowIndex);
  Result := (FRowIndex < Length(FKeywords));
end;

procedure TDBXBaseMetaDataReader.TDBXReservedWordsCursor.Close;
begin
end;

function TDBXBaseMetaDataReader.TDBXReservedWordsCursor.IsNull(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.UnknownType);
  Result := (StringIsNil(GetString(Ordinal)));
end;

function TDBXBaseMetaDataReader.TDBXReservedWordsCursor.GetString(Ordinal: Integer): WideString;
begin
  CheckColumn(Ordinal, TDBXDataTypes.WideStringType);
  case Ordinal of
    TDBXReservedWordsIndex.ReservedWord:
      Result := FKeywords[FRowIndex];
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

class function TDBXTableTypeParser.ParseTableTypes(const TableTypes: WideString): Integer;
var
  Flags: Integer;
  Tokenizer: TDBXTokenizer;
  TableType: WideString;
begin
  Flags := 0;
  if not StringIsNil(TableTypes) then
  begin
    Tokenizer := TDBXTokenizer.Create(TableTypes, ',');
    while Tokenizer.HasMoreTokens do
    begin
      TableType := Trim(Tokenizer.NextToken);
      if (TableType = TDBXTableType.Table) then
        Flags := Flags or TDBXTableTypeFlag.Table
      else if (TableType = TDBXTableType.SystemTable) then
        Flags := Flags or TDBXTableTypeFlag.SystemTable
      else if (TableType = TDBXTableType.View) then
        Flags := Flags or TDBXTableTypeFlag.View
      else if (TableType = TDBXTableType.Synonym) then
        Flags := Flags or TDBXTableTypeFlag.Synonym
      else if Length(TableType) > 0 then
        raise TDBXMetaDataError.Create(SUnknownTableType + TableType);
    end;
    FreeAndNil(Tokenizer);
  end;
  if Flags = 0 then
    Flags := TDBXTableTypeFlag.All;
  Result := Flags;
end;

end.
