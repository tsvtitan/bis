{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXTypedTableStorage;
interface
uses
  DBXTableStorage;
type
  TDBXCatalogsTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
  end;

  TDBXColumnConstraintsTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetTableName: WideString; virtual;
    procedure SetTableName(Value: WideString); virtual;
    function GetConstraintName: WideString; virtual;
    procedure SetConstraintName(Value: WideString); virtual;
    function GetColumnName: WideString; virtual;
    procedure SetColumnName(Value: WideString); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property TableName: WideString read GetTableName write SetTableName;
    property ConstraintName: WideString read GetConstraintName write SetConstraintName;
    property ColumnName: WideString read GetColumnName write SetColumnName;
  end;

  TDBXColumnsTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetTableName: WideString; virtual;
    procedure SetTableName(Value: WideString); virtual;
    function GetColumnName: WideString; virtual;
    procedure SetColumnName(Value: WideString); virtual;
    function GetTypeName: WideString; virtual;
    procedure SetTypeName(Value: WideString); virtual;
    function GetPrecision: Integer; virtual;
    procedure SetPrecision(Value: Integer); virtual;
    function GetScale: Integer; virtual;
    procedure SetScale(Value: Integer); virtual;
    function GetOrdinal: Integer; virtual;
    procedure SetOrdinal(Value: Integer); virtual;
    function GetDefaultValue: WideString; virtual;
    procedure SetDefaultValue(Value: WideString); virtual;
    function IsNullable: Boolean; virtual;
    procedure SetNullable(Value: Boolean); virtual;
    function IsAutoIncrement: Boolean; virtual;
    procedure SetAutoIncrement(Value: Boolean); virtual;
    function GetMaxInline: Integer; virtual;
    procedure SetMaxInline(Value: Integer); virtual;
    function GetDbxDataType: Integer; virtual;
    procedure SetDbxDataType(Value: Integer); virtual;
    function IsFixedLength: Boolean; virtual;
    procedure SetFixedLength(Value: Boolean); virtual;
    function IsUnicode: Boolean; virtual;
    procedure SetUnicode(Value: Boolean); virtual;
    function IsLong: Boolean; virtual;
    procedure SetLong(Value: Boolean); virtual;
    function IsUnsigned: Boolean; virtual;
    procedure SetUnsigned(Value: Boolean); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property TableName: WideString read GetTableName write SetTableName;
    property ColumnName: WideString read GetColumnName write SetColumnName;
    property TypeName: WideString read GetTypeName write SetTypeName;
    property Precision: Integer read GetPrecision write SetPrecision;
    property Scale: Integer read GetScale write SetScale;
    property Ordinal: Integer read GetOrdinal write SetOrdinal;
    property DefaultValue: WideString read GetDefaultValue write SetDefaultValue;
    property Nullable: Boolean read IsNullable write SetNullable;
    property AutoIncrement: Boolean read IsAutoIncrement write SetAutoIncrement;
    property MaxInline: Integer read GetMaxInline write SetMaxInline;
    property DbxDataType: Integer read GetDbxDataType write SetDbxDataType;
    property FixedLength: Boolean read IsFixedLength write SetFixedLength;
    property Unicode: Boolean read IsUnicode write SetUnicode;
    property Long: Boolean read IsLong write SetLong;
    property Unsigned: Boolean read IsUnsigned write SetUnsigned;
  end;

  TDBXDataTypesTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetTypeName: WideString; virtual;
    procedure SetTypeName(Value: WideString); virtual;
    function GetDbxDataType: Integer; virtual;
    procedure SetDbxDataType(Value: Integer); virtual;
    function GetColumnSize: Int64; virtual;
    procedure SetColumnSize(Value: Int64); virtual;
    function GetCreateFormat: WideString; virtual;
    procedure SetCreateFormat(Value: WideString); virtual;
    function GetCreateParameters: WideString; virtual;
    procedure SetCreateParameters(Value: WideString); virtual;
    function GetDataType: WideString; virtual;
    procedure SetDataType(Value: WideString); virtual;
    function IsAutoIncrementable: Boolean; virtual;
    procedure SetAutoIncrementable(Value: Boolean); virtual;
    function IsBestMatch: Boolean; virtual;
    procedure SetBestMatch(Value: Boolean); virtual;
    function IsCaseSensitive: Boolean; virtual;
    procedure SetCaseSensitive(Value: Boolean); virtual;
    function IsFixedLength: Boolean; virtual;
    procedure SetFixedLength(Value: Boolean); virtual;
    function IsFixedPrecisionScale: Boolean; virtual;
    procedure SetFixedPrecisionScale(Value: Boolean); virtual;
    function IsLong: Boolean; virtual;
    procedure SetLong(Value: Boolean); virtual;
    function IsNullable: Boolean; virtual;
    procedure SetNullable(Value: Boolean); virtual;
    function IsSearchable: Boolean; virtual;
    procedure SetSearchable(Value: Boolean); virtual;
    function IsSearchableWithLike: Boolean; virtual;
    procedure SetSearchableWithLike(Value: Boolean); virtual;
    function IsUnsigned: Boolean; virtual;
    procedure SetUnsigned(Value: Boolean); virtual;
    function GetMaximumScale: SmallInt; virtual;
    procedure SetMaximumScale(Value: SmallInt); virtual;
    function GetMinimumScale: SmallInt; virtual;
    procedure SetMinimumScale(Value: SmallInt); virtual;
    function IsConcurrencyType: Boolean; virtual;
    procedure SetConcurrencyType(Value: Boolean); virtual;
    function GetMaximumVersion: WideString; virtual;
    procedure SetMaximumVersion(Value: WideString); virtual;
    function GetMinimumVersion: WideString; virtual;
    procedure SetMinimumVersion(Value: WideString); virtual;
    function IsLiteralSupported: Boolean; virtual;
    procedure SetLiteralSupported(Value: Boolean); virtual;
    function GetLiteralPrefix: WideString; virtual;
    procedure SetLiteralPrefix(Value: WideString); virtual;
    function GetLiteralSuffix: WideString; virtual;
    procedure SetLiteralSuffix(Value: WideString); virtual;
    function IsUnicode: Boolean; virtual;
    procedure SetUnicode(Value: Boolean); virtual;
    function GetProviderDbType: Integer; virtual;
    procedure SetProviderDbType(Value: Integer); virtual;
  public
    property TypeName: WideString read GetTypeName write SetTypeName;
    property DbxDataType: Integer read GetDbxDataType write SetDbxDataType;
    property ColumnSize: Int64 read GetColumnSize write SetColumnSize;
    property CreateFormat: WideString read GetCreateFormat write SetCreateFormat;
    property CreateParameters: WideString read GetCreateParameters write SetCreateParameters;
    property DataType: WideString read GetDataType write SetDataType;
    property AutoIncrementable: Boolean read IsAutoIncrementable write SetAutoIncrementable;
    property BestMatch: Boolean read IsBestMatch write SetBestMatch;
    property CaseSensitive: Boolean read IsCaseSensitive write SetCaseSensitive;
    property FixedLength: Boolean read IsFixedLength write SetFixedLength;
    property FixedPrecisionScale: Boolean read IsFixedPrecisionScale write SetFixedPrecisionScale;
    property Long: Boolean read IsLong write SetLong;
    property Nullable: Boolean read IsNullable write SetNullable;
    property Searchable: Boolean read IsSearchable write SetSearchable;
    property SearchableWithLike: Boolean read IsSearchableWithLike write SetSearchableWithLike;
    property Unsigned: Boolean read IsUnsigned write SetUnsigned;
    property MaximumScale: SmallInt read GetMaximumScale write SetMaximumScale;
    property MinimumScale: SmallInt read GetMinimumScale write SetMinimumScale;
    property ConcurrencyType: Boolean read IsConcurrencyType write SetConcurrencyType;
    property MaximumVersion: WideString read GetMaximumVersion write SetMaximumVersion;
    property MinimumVersion: WideString read GetMinimumVersion write SetMinimumVersion;
    property LiteralSupported: Boolean read IsLiteralSupported write SetLiteralSupported;
    property LiteralPrefix: WideString read GetLiteralPrefix write SetLiteralPrefix;
    property LiteralSuffix: WideString read GetLiteralSuffix write SetLiteralSuffix;
    property Unicode: Boolean read IsUnicode write SetUnicode;
    property ProviderDbType: Integer read GetProviderDbType write SetProviderDbType;
  end;

  TDBXForeignKeyColumnsTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetTableName: WideString; virtual;
    procedure SetTableName(Value: WideString); virtual;
    function GetForeignKeyName: WideString; virtual;
    procedure SetForeignKeyName(Value: WideString); virtual;
    function GetColumnName: WideString; virtual;
    procedure SetColumnName(Value: WideString); virtual;
    function GetPrimaryCatalogName: WideString; virtual;
    procedure SetPrimaryCatalogName(Value: WideString); virtual;
    function GetPrimarySchemaName: WideString; virtual;
    procedure SetPrimarySchemaName(Value: WideString); virtual;
    function GetPrimaryTableName: WideString; virtual;
    procedure SetPrimaryTableName(Value: WideString); virtual;
    function GetPrimaryKeyName: WideString; virtual;
    procedure SetPrimaryKeyName(Value: WideString); virtual;
    function GetPrimaryColumnName: WideString; virtual;
    procedure SetPrimaryColumnName(Value: WideString); virtual;
    function GetOrdinal: Integer; virtual;
    procedure SetOrdinal(Value: Integer); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property TableName: WideString read GetTableName write SetTableName;
    property ForeignKeyName: WideString read GetForeignKeyName write SetForeignKeyName;
    property ColumnName: WideString read GetColumnName write SetColumnName;
    property PrimaryCatalogName: WideString read GetPrimaryCatalogName write SetPrimaryCatalogName;
    property PrimarySchemaName: WideString read GetPrimarySchemaName write SetPrimarySchemaName;
    property PrimaryTableName: WideString read GetPrimaryTableName write SetPrimaryTableName;
    property PrimaryKeyName: WideString read GetPrimaryKeyName write SetPrimaryKeyName;
    property PrimaryColumnName: WideString read GetPrimaryColumnName write SetPrimaryColumnName;
    property Ordinal: Integer read GetOrdinal write SetOrdinal;
  end;

  TDBXForeignKeysTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetTableName: WideString; virtual;
    procedure SetTableName(Value: WideString); virtual;
    function GetForeignKeyName: WideString; virtual;
    procedure SetForeignKeyName(Value: WideString); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property TableName: WideString read GetTableName write SetTableName;
    property ForeignKeyName: WideString read GetForeignKeyName write SetForeignKeyName;
  end;

  TDBXIndexColumnsTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetTableName: WideString; virtual;
    procedure SetTableName(Value: WideString); virtual;
    function GetIndexName: WideString; virtual;
    procedure SetIndexName(Value: WideString); virtual;
    function GetColumnName: WideString; virtual;
    procedure SetColumnName(Value: WideString); virtual;
    function GetOrdinal: Integer; virtual;
    procedure SetOrdinal(Value: Integer); virtual;
    function IsAscending: Boolean; virtual;
    procedure SetAscending(Value: Boolean); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property TableName: WideString read GetTableName write SetTableName;
    property IndexName: WideString read GetIndexName write SetIndexName;
    property ColumnName: WideString read GetColumnName write SetColumnName;
    property Ordinal: Integer read GetOrdinal write SetOrdinal;
    property Ascending: Boolean read IsAscending write SetAscending;
  end;

  TDBXIndexesTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetTableName: WideString; virtual;
    procedure SetTableName(Value: WideString); virtual;
    function GetIndexName: WideString; virtual;
    procedure SetIndexName(Value: WideString); virtual;
    function GetConstraintName: WideString; virtual;
    procedure SetConstraintName(Value: WideString); virtual;
    function IsPrimary: Boolean; virtual;
    procedure SetPrimary(Value: Boolean); virtual;
    function IsUnique: Boolean; virtual;
    procedure SetUnique(Value: Boolean); virtual;
    function IsAscending: Boolean; virtual;
    procedure SetAscending(Value: Boolean); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property TableName: WideString read GetTableName write SetTableName;
    property IndexName: WideString read GetIndexName write SetIndexName;
    property ConstraintName: WideString read GetConstraintName write SetConstraintName;
    property Primary: Boolean read IsPrimary write SetPrimary;
    property Unique: Boolean read IsUnique write SetUnique;
    property Ascending: Boolean read IsAscending write SetAscending;
  end;

  TDBXPackageProcedureParametersTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetPackageName: WideString; virtual;
    procedure SetPackageName(Value: WideString); virtual;
    function GetProcedureName: WideString; virtual;
    procedure SetProcedureName(Value: WideString); virtual;
    function GetParameterName: WideString; virtual;
    procedure SetParameterName(Value: WideString); virtual;
    function GetParameterMode: WideString; virtual;
    procedure SetParameterMode(Value: WideString); virtual;
    function GetTypeName: WideString; virtual;
    procedure SetTypeName(Value: WideString); virtual;
    function GetPrecision: Integer; virtual;
    procedure SetPrecision(Value: Integer); virtual;
    function GetScale: Integer; virtual;
    procedure SetScale(Value: Integer); virtual;
    function GetOrdinal: Integer; virtual;
    procedure SetOrdinal(Value: Integer); virtual;
    function IsNullable: Boolean; virtual;
    procedure SetNullable(Value: Boolean); virtual;
    function GetDbxDataType: Integer; virtual;
    procedure SetDbxDataType(Value: Integer); virtual;
    function IsFixedLength: Boolean; virtual;
    procedure SetFixedLength(Value: Boolean); virtual;
    function IsUnicode: Boolean; virtual;
    procedure SetUnicode(Value: Boolean); virtual;
    function IsLong: Boolean; virtual;
    procedure SetLong(Value: Boolean); virtual;
    function IsUnsigned: Boolean; virtual;
    procedure SetUnsigned(Value: Boolean); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property PackageName: WideString read GetPackageName write SetPackageName;
    property ProcedureName: WideString read GetProcedureName write SetProcedureName;
    property ParameterName: WideString read GetParameterName write SetParameterName;
    property ParameterMode: WideString read GetParameterMode write SetParameterMode;
    property TypeName: WideString read GetTypeName write SetTypeName;
    property Precision: Integer read GetPrecision write SetPrecision;
    property Scale: Integer read GetScale write SetScale;
    property Ordinal: Integer read GetOrdinal write SetOrdinal;
    property Nullable: Boolean read IsNullable write SetNullable;
    property DbxDataType: Integer read GetDbxDataType write SetDbxDataType;
    property FixedLength: Boolean read IsFixedLength write SetFixedLength;
    property Unicode: Boolean read IsUnicode write SetUnicode;
    property Long: Boolean read IsLong write SetLong;
    property Unsigned: Boolean read IsUnsigned write SetUnsigned;
  end;

  TDBXPackageProceduresTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetPackageName: WideString; virtual;
    procedure SetPackageName(Value: WideString); virtual;
    function GetProcedureName: WideString; virtual;
    procedure SetProcedureName(Value: WideString); virtual;
    function GetProcedureType: WideString; virtual;
    procedure SetProcedureType(Value: WideString); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property PackageName: WideString read GetPackageName write SetPackageName;
    property ProcedureName: WideString read GetProcedureName write SetProcedureName;
    property ProcedureType: WideString read GetProcedureType write SetProcedureType;
  end;

  TDBXPackageSourcesTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetPackageName: WideString; virtual;
    procedure SetPackageName(Value: WideString); virtual;
    function GetDefinition: WideString; virtual;
    procedure SetDefinition(Value: WideString); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property PackageName: WideString read GetPackageName write SetPackageName;
    property Definition: WideString read GetDefinition write SetDefinition;
  end;

  TDBXPackagesTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetPackageName: WideString; virtual;
    procedure SetPackageName(Value: WideString); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property PackageName: WideString read GetPackageName write SetPackageName;
  end;

  TDBXProcedureParametersTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetProcedureName: WideString; virtual;
    procedure SetProcedureName(Value: WideString); virtual;
    function GetParameterName: WideString; virtual;
    procedure SetParameterName(Value: WideString); virtual;
    function GetParameterMode: WideString; virtual;
    procedure SetParameterMode(Value: WideString); virtual;
    function GetTypeName: WideString; virtual;
    procedure SetTypeName(Value: WideString); virtual;
    function GetPrecision: Integer; virtual;
    procedure SetPrecision(Value: Integer); virtual;
    function GetScale: Integer; virtual;
    procedure SetScale(Value: Integer); virtual;
    function GetOrdinal: Integer; virtual;
    procedure SetOrdinal(Value: Integer); virtual;
    function IsNullable: Boolean; virtual;
    procedure SetNullable(Value: Boolean); virtual;
    function GetDbxDataType: Integer; virtual;
    procedure SetDbxDataType(Value: Integer); virtual;
    function IsFixedLength: Boolean; virtual;
    procedure SetFixedLength(Value: Boolean); virtual;
    function IsUnicode: Boolean; virtual;
    procedure SetUnicode(Value: Boolean); virtual;
    function IsLong: Boolean; virtual;
    procedure SetLong(Value: Boolean); virtual;
    function IsUnsigned: Boolean; virtual;
    procedure SetUnsigned(Value: Boolean); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property ProcedureName: WideString read GetProcedureName write SetProcedureName;
    property ParameterName: WideString read GetParameterName write SetParameterName;
    property ParameterMode: WideString read GetParameterMode write SetParameterMode;
    property TypeName: WideString read GetTypeName write SetTypeName;
    property Precision: Integer read GetPrecision write SetPrecision;
    property Scale: Integer read GetScale write SetScale;
    property Ordinal: Integer read GetOrdinal write SetOrdinal;
    property Nullable: Boolean read IsNullable write SetNullable;
    property DbxDataType: Integer read GetDbxDataType write SetDbxDataType;
    property FixedLength: Boolean read IsFixedLength write SetFixedLength;
    property Unicode: Boolean read IsUnicode write SetUnicode;
    property Long: Boolean read IsLong write SetLong;
    property Unsigned: Boolean read IsUnsigned write SetUnsigned;
  end;

  TDBXProcedureSourcesTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetProcedureName: WideString; virtual;
    procedure SetProcedureName(Value: WideString); virtual;
    function GetProcedureType: WideString; virtual;
    procedure SetProcedureType(Value: WideString); virtual;
    function GetDefinition: WideString; virtual;
    procedure SetDefinition(Value: WideString); virtual;
    function GetExternalDefinition: WideString; virtual;
    procedure SetExternalDefinition(Value: WideString); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property ProcedureName: WideString read GetProcedureName write SetProcedureName;
    property ProcedureType: WideString read GetProcedureType write SetProcedureType;
    property Definition: WideString read GetDefinition write SetDefinition;
    property ExternalDefinition: WideString read GetExternalDefinition write SetExternalDefinition;
  end;

  TDBXProceduresTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetProcedureName: WideString; virtual;
    procedure SetProcedureName(Value: WideString); virtual;
    function GetProcedureType: WideString; virtual;
    procedure SetProcedureType(Value: WideString); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property ProcedureName: WideString read GetProcedureName write SetProcedureName;
    property ProcedureType: WideString read GetProcedureType write SetProcedureType;
  end;

  TDBXReservedWordsTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetReservedWord: WideString; virtual;
    procedure SetReservedWord(Value: WideString); virtual;
  public
    property ReservedWord: WideString read GetReservedWord write SetReservedWord;
  end;

  TDBXRolesTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetRoleName: WideString; virtual;
    procedure SetRoleName(Value: WideString); virtual;
  public
    property RoleName: WideString read GetRoleName write SetRoleName;
  end;

  TDBXSchemasTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
  end;

  TDBXSynonymsTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetSynonymName: WideString; virtual;
    procedure SetSynonymName(Value: WideString); virtual;
    function GetTableCatalogName: WideString; virtual;
    procedure SetTableCatalogName(Value: WideString); virtual;
    function GetTableSchemaName: WideString; virtual;
    procedure SetTableSchemaName(Value: WideString); virtual;
    function GetTableName: WideString; virtual;
    procedure SetTableName(Value: WideString); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property SynonymName: WideString read GetSynonymName write SetSynonymName;
    property TableCatalogName: WideString read GetTableCatalogName write SetTableCatalogName;
    property TableSchemaName: WideString read GetTableSchemaName write SetTableSchemaName;
    property TableName: WideString read GetTableName write SetTableName;
  end;

  TDBXTablesTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetTableName: WideString; virtual;
    procedure SetTableName(Value: WideString); virtual;
    function GetTableType: WideString; virtual;
    procedure SetTableType(Value: WideString); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property TableName: WideString read GetTableName write SetTableName;
    property TableType: WideString read GetTableType write SetTableType;
  end;

  TDBXUsersTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetUserName: WideString; virtual;
    procedure SetUserName(Value: WideString); virtual;
  public
    property UserName: WideString read GetUserName write SetUserName;
  end;

  TDBXViewsTableStorage = class(TDBXDelegateTableStorage)
  public
    constructor Create; overload;
    constructor Create(Table: TDBXTableStorage); overload;
  protected
    function GetCatalogName: WideString; virtual;
    procedure SetCatalogName(Value: WideString); virtual;
    function GetSchemaName: WideString; virtual;
    procedure SetSchemaName(Value: WideString); virtual;
    function GetViewName: WideString; virtual;
    procedure SetViewName(Value: WideString); virtual;
    function GetDefinition: WideString; virtual;
    procedure SetDefinition(Value: WideString); virtual;
  public
    property CatalogName: WideString read GetCatalogName write SetCatalogName;
    property SchemaName: WideString read GetSchemaName write SetSchemaName;
    property ViewName: WideString read GetViewName write SetViewName;
    property Definition: WideString read GetDefinition write SetDefinition;
  end;

implementation
uses
  DBXMetaDataNames,
  DBXMetaDataReader,
  DBXTableStoragePlatform;

constructor TDBXCatalogsTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.Catalogs, TDBXMetaDataCollectionName.Catalogs));
  Columns := TDBXMetaDataCollectionColumns.CreateCatalogsColumns;
end;

constructor TDBXCatalogsTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXCatalogsTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXCatalogsIndex.CatalogName);
end;

procedure TDBXCatalogsTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXCatalogsIndex.CatalogName, Value);
end;

constructor TDBXColumnConstraintsTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.ColumnConstraints, TDBXMetaDataCollectionName.ColumnConstraints));
  Columns := TDBXMetaDataCollectionColumns.CreateColumnConstraintsColumns;
end;

constructor TDBXColumnConstraintsTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXColumnConstraintsTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXColumnConstraintsIndex.CatalogName);
end;

procedure TDBXColumnConstraintsTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXColumnConstraintsIndex.CatalogName, Value);
end;

function TDBXColumnConstraintsTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXColumnConstraintsIndex.SchemaName);
end;

procedure TDBXColumnConstraintsTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXColumnConstraintsIndex.SchemaName, Value);
end;

function TDBXColumnConstraintsTableStorage.GetTableName: WideString;
begin
  Result := GetString(TDBXColumnConstraintsIndex.TableName);
end;

procedure TDBXColumnConstraintsTableStorage.SetTableName(Value: WideString);
begin
  SetString(TDBXColumnConstraintsIndex.TableName, Value);
end;

function TDBXColumnConstraintsTableStorage.GetConstraintName: WideString;
begin
  Result := GetString(TDBXColumnConstraintsIndex.ConstraintName);
end;

procedure TDBXColumnConstraintsTableStorage.SetConstraintName(Value: WideString);
begin
  SetString(TDBXColumnConstraintsIndex.ConstraintName, Value);
end;

function TDBXColumnConstraintsTableStorage.GetColumnName: WideString;
begin
  Result := GetString(TDBXColumnConstraintsIndex.ColumnName);
end;

procedure TDBXColumnConstraintsTableStorage.SetColumnName(Value: WideString);
begin
  SetString(TDBXColumnConstraintsIndex.ColumnName, Value);
end;

constructor TDBXColumnsTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.Columns, TDBXMetaDataCollectionName.Columns));
  Columns := TDBXMetaDataCollectionColumns.CreateColumnsColumns;
end;

constructor TDBXColumnsTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXColumnsTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXColumnsIndex.CatalogName);
end;

procedure TDBXColumnsTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXColumnsIndex.CatalogName, Value);
end;

function TDBXColumnsTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXColumnsIndex.SchemaName);
end;

procedure TDBXColumnsTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXColumnsIndex.SchemaName, Value);
end;

function TDBXColumnsTableStorage.GetTableName: WideString;
begin
  Result := GetString(TDBXColumnsIndex.TableName);
end;

procedure TDBXColumnsTableStorage.SetTableName(Value: WideString);
begin
  SetString(TDBXColumnsIndex.TableName, Value);
end;

function TDBXColumnsTableStorage.GetColumnName: WideString;
begin
  Result := GetString(TDBXColumnsIndex.ColumnName);
end;

procedure TDBXColumnsTableStorage.SetColumnName(Value: WideString);
begin
  SetString(TDBXColumnsIndex.ColumnName, Value);
end;

function TDBXColumnsTableStorage.GetTypeName: WideString;
begin
  Result := GetString(TDBXColumnsIndex.TypeName);
end;

procedure TDBXColumnsTableStorage.SetTypeName(Value: WideString);
begin
  SetString(TDBXColumnsIndex.TypeName, Value);
end;

function TDBXColumnsTableStorage.GetPrecision: Integer;
begin
  Result := GetInt32(TDBXColumnsIndex.Precision);
end;

procedure TDBXColumnsTableStorage.SetPrecision(Value: Integer);
begin
  SetInt32(TDBXColumnsIndex.Precision, Value);
end;

function TDBXColumnsTableStorage.GetScale: Integer;
begin
  Result := GetInt32(TDBXColumnsIndex.Scale);
end;

procedure TDBXColumnsTableStorage.SetScale(Value: Integer);
begin
  SetInt32(TDBXColumnsIndex.Scale, Value);
end;

function TDBXColumnsTableStorage.GetOrdinal: Integer;
begin
  Result := GetInt32(TDBXColumnsIndex.Ordinal);
end;

procedure TDBXColumnsTableStorage.SetOrdinal(Value: Integer);
begin
  SetInt32(TDBXColumnsIndex.Ordinal, Value);
end;

function TDBXColumnsTableStorage.GetDefaultValue: WideString;
begin
  Result := GetString(TDBXColumnsIndex.DefaultValue);
end;

procedure TDBXColumnsTableStorage.SetDefaultValue(Value: WideString);
begin
  SetString(TDBXColumnsIndex.DefaultValue, Value);
end;

function TDBXColumnsTableStorage.IsNullable: Boolean;
begin
  Result := GetBoolean(TDBXColumnsIndex.IsNullable);
end;

procedure TDBXColumnsTableStorage.SetNullable(Value: Boolean);
begin
  SetBoolean(TDBXColumnsIndex.IsNullable, Value);
end;

function TDBXColumnsTableStorage.IsAutoIncrement: Boolean;
begin
  Result := GetBoolean(TDBXColumnsIndex.IsAutoIncrement);
end;

procedure TDBXColumnsTableStorage.SetAutoIncrement(Value: Boolean);
begin
  SetBoolean(TDBXColumnsIndex.IsAutoIncrement, Value);
end;

function TDBXColumnsTableStorage.GetMaxInline: Integer;
begin
  Result := GetInt32(TDBXColumnsIndex.MaxInline);
end;

procedure TDBXColumnsTableStorage.SetMaxInline(Value: Integer);
begin
  SetInt32(TDBXColumnsIndex.MaxInline, Value);
end;

function TDBXColumnsTableStorage.GetDbxDataType: Integer;
begin
  Result := GetInt32(TDBXColumnsIndex.DbxDataType);
end;

procedure TDBXColumnsTableStorage.SetDbxDataType(Value: Integer);
begin
  SetInt32(TDBXColumnsIndex.DbxDataType, Value);
end;

function TDBXColumnsTableStorage.IsFixedLength: Boolean;
begin
  Result := GetBoolean(TDBXColumnsIndex.IsFixedLength);
end;

procedure TDBXColumnsTableStorage.SetFixedLength(Value: Boolean);
begin
  SetBoolean(TDBXColumnsIndex.IsFixedLength, Value);
end;

function TDBXColumnsTableStorage.IsUnicode: Boolean;
begin
  Result := GetBoolean(TDBXColumnsIndex.IsUnicode);
end;

procedure TDBXColumnsTableStorage.SetUnicode(Value: Boolean);
begin
  SetBoolean(TDBXColumnsIndex.IsUnicode, Value);
end;

function TDBXColumnsTableStorage.IsLong: Boolean;
begin
  Result := GetBoolean(TDBXColumnsIndex.IsLong);
end;

procedure TDBXColumnsTableStorage.SetLong(Value: Boolean);
begin
  SetBoolean(TDBXColumnsIndex.IsLong, Value);
end;

function TDBXColumnsTableStorage.IsUnsigned: Boolean;
begin
  Result := GetBoolean(TDBXColumnsIndex.IsUnsigned);
end;

procedure TDBXColumnsTableStorage.SetUnsigned(Value: Boolean);
begin
  SetBoolean(TDBXColumnsIndex.IsUnsigned, Value);
end;

constructor TDBXDataTypesTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.DataTypes, TDBXMetaDataCollectionName.DataTypes));
  Columns := TDBXMetaDataCollectionColumns.CreateDataTypesColumns;
end;

constructor TDBXDataTypesTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXDataTypesTableStorage.GetTypeName: WideString;
begin
  Result := GetString(TDBXDataTypesIndex.TypeName);
end;

procedure TDBXDataTypesTableStorage.SetTypeName(Value: WideString);
begin
  SetString(TDBXDataTypesIndex.TypeName, Value);
end;

function TDBXDataTypesTableStorage.GetDbxDataType: Integer;
begin
  Result := GetInt32(TDBXDataTypesIndex.DbxDataType);
end;

procedure TDBXDataTypesTableStorage.SetDbxDataType(Value: Integer);
begin
  SetInt32(TDBXDataTypesIndex.DbxDataType, Value);
end;

function TDBXDataTypesTableStorage.GetColumnSize: Int64;
begin
  Result := GetInt64(TDBXDataTypesIndex.ColumnSize);
end;

procedure TDBXDataTypesTableStorage.SetColumnSize(Value: Int64);
begin
  SetInt64(TDBXDataTypesIndex.ColumnSize, Value);
end;

function TDBXDataTypesTableStorage.GetCreateFormat: WideString;
begin
  Result := GetString(TDBXDataTypesIndex.CreateFormat);
end;

procedure TDBXDataTypesTableStorage.SetCreateFormat(Value: WideString);
begin
  SetString(TDBXDataTypesIndex.CreateFormat, Value);
end;

function TDBXDataTypesTableStorage.GetCreateParameters: WideString;
begin
  Result := GetString(TDBXDataTypesIndex.CreateParameters);
end;

procedure TDBXDataTypesTableStorage.SetCreateParameters(Value: WideString);
begin
  SetString(TDBXDataTypesIndex.CreateParameters, Value);
end;

function TDBXDataTypesTableStorage.GetDataType: WideString;
begin
  Result := GetString(TDBXDataTypesIndex.DataType);
end;

procedure TDBXDataTypesTableStorage.SetDataType(Value: WideString);
begin
  SetString(TDBXDataTypesIndex.DataType, Value);
end;

function TDBXDataTypesTableStorage.IsAutoIncrementable: Boolean;
begin
  Result := GetBoolean(TDBXDataTypesIndex.IsAutoIncrementable);
end;

procedure TDBXDataTypesTableStorage.SetAutoIncrementable(Value: Boolean);
begin
  SetBoolean(TDBXDataTypesIndex.IsAutoIncrementable, Value);
end;

function TDBXDataTypesTableStorage.IsBestMatch: Boolean;
begin
  Result := GetBoolean(TDBXDataTypesIndex.IsBestMatch);
end;

procedure TDBXDataTypesTableStorage.SetBestMatch(Value: Boolean);
begin
  SetBoolean(TDBXDataTypesIndex.IsBestMatch, Value);
end;

function TDBXDataTypesTableStorage.IsCaseSensitive: Boolean;
begin
  Result := GetBoolean(TDBXDataTypesIndex.IsCaseSensitive);
end;

procedure TDBXDataTypesTableStorage.SetCaseSensitive(Value: Boolean);
begin
  SetBoolean(TDBXDataTypesIndex.IsCaseSensitive, Value);
end;

function TDBXDataTypesTableStorage.IsFixedLength: Boolean;
begin
  Result := GetBoolean(TDBXDataTypesIndex.IsFixedLength);
end;

procedure TDBXDataTypesTableStorage.SetFixedLength(Value: Boolean);
begin
  SetBoolean(TDBXDataTypesIndex.IsFixedLength, Value);
end;

function TDBXDataTypesTableStorage.IsFixedPrecisionScale: Boolean;
begin
  Result := GetBoolean(TDBXDataTypesIndex.IsFixedPrecisionScale);
end;

procedure TDBXDataTypesTableStorage.SetFixedPrecisionScale(Value: Boolean);
begin
  SetBoolean(TDBXDataTypesIndex.IsFixedPrecisionScale, Value);
end;

function TDBXDataTypesTableStorage.IsLong: Boolean;
begin
  Result := GetBoolean(TDBXDataTypesIndex.IsLong);
end;

procedure TDBXDataTypesTableStorage.SetLong(Value: Boolean);
begin
  SetBoolean(TDBXDataTypesIndex.IsLong, Value);
end;

function TDBXDataTypesTableStorage.IsNullable: Boolean;
begin
  Result := GetBoolean(TDBXDataTypesIndex.IsNullable);
end;

procedure TDBXDataTypesTableStorage.SetNullable(Value: Boolean);
begin
  SetBoolean(TDBXDataTypesIndex.IsNullable, Value);
end;

function TDBXDataTypesTableStorage.IsSearchable: Boolean;
begin
  Result := GetBoolean(TDBXDataTypesIndex.IsSearchable);
end;

procedure TDBXDataTypesTableStorage.SetSearchable(Value: Boolean);
begin
  SetBoolean(TDBXDataTypesIndex.IsSearchable, Value);
end;

function TDBXDataTypesTableStorage.IsSearchableWithLike: Boolean;
begin
  Result := GetBoolean(TDBXDataTypesIndex.IsSearchableWithLike);
end;

procedure TDBXDataTypesTableStorage.SetSearchableWithLike(Value: Boolean);
begin
  SetBoolean(TDBXDataTypesIndex.IsSearchableWithLike, Value);
end;

function TDBXDataTypesTableStorage.IsUnsigned: Boolean;
begin
  Result := GetBoolean(TDBXDataTypesIndex.IsUnsigned);
end;

procedure TDBXDataTypesTableStorage.SetUnsigned(Value: Boolean);
begin
  SetBoolean(TDBXDataTypesIndex.IsUnsigned, Value);
end;

function TDBXDataTypesTableStorage.GetMaximumScale: SmallInt;
begin
  Result := GetInt16(TDBXDataTypesIndex.MaximumScale);
end;

procedure TDBXDataTypesTableStorage.SetMaximumScale(Value: SmallInt);
begin
  SetInt16(TDBXDataTypesIndex.MaximumScale, Value);
end;

function TDBXDataTypesTableStorage.GetMinimumScale: SmallInt;
begin
  Result := GetInt16(TDBXDataTypesIndex.MinimumScale);
end;

procedure TDBXDataTypesTableStorage.SetMinimumScale(Value: SmallInt);
begin
  SetInt16(TDBXDataTypesIndex.MinimumScale, Value);
end;

function TDBXDataTypesTableStorage.IsConcurrencyType: Boolean;
begin
  Result := GetBoolean(TDBXDataTypesIndex.IsConcurrencyType);
end;

procedure TDBXDataTypesTableStorage.SetConcurrencyType(Value: Boolean);
begin
  SetBoolean(TDBXDataTypesIndex.IsConcurrencyType, Value);
end;

function TDBXDataTypesTableStorage.GetMaximumVersion: WideString;
begin
  Result := GetString(TDBXDataTypesIndex.MaximumVersion);
end;

procedure TDBXDataTypesTableStorage.SetMaximumVersion(Value: WideString);
begin
  SetString(TDBXDataTypesIndex.MaximumVersion, Value);
end;

function TDBXDataTypesTableStorage.GetMinimumVersion: WideString;
begin
  Result := GetString(TDBXDataTypesIndex.MinimumVersion);
end;

procedure TDBXDataTypesTableStorage.SetMinimumVersion(Value: WideString);
begin
  SetString(TDBXDataTypesIndex.MinimumVersion, Value);
end;

function TDBXDataTypesTableStorage.IsLiteralSupported: Boolean;
begin
  Result := GetBoolean(TDBXDataTypesIndex.IsLiteralSupported);
end;

procedure TDBXDataTypesTableStorage.SetLiteralSupported(Value: Boolean);
begin
  SetBoolean(TDBXDataTypesIndex.IsLiteralSupported, Value);
end;

function TDBXDataTypesTableStorage.GetLiteralPrefix: WideString;
begin
  Result := GetString(TDBXDataTypesIndex.LiteralPrefix);
end;

procedure TDBXDataTypesTableStorage.SetLiteralPrefix(Value: WideString);
begin
  SetString(TDBXDataTypesIndex.LiteralPrefix, Value);
end;

function TDBXDataTypesTableStorage.GetLiteralSuffix: WideString;
begin
  Result := GetString(TDBXDataTypesIndex.LiteralSuffix);
end;

procedure TDBXDataTypesTableStorage.SetLiteralSuffix(Value: WideString);
begin
  SetString(TDBXDataTypesIndex.LiteralSuffix, Value);
end;

function TDBXDataTypesTableStorage.IsUnicode: Boolean;
begin
  Result := GetBoolean(TDBXDataTypesIndex.IsUnicode);
end;

procedure TDBXDataTypesTableStorage.SetUnicode(Value: Boolean);
begin
  SetBoolean(TDBXDataTypesIndex.IsUnicode, Value);
end;

function TDBXDataTypesTableStorage.GetProviderDbType: Integer;
begin
  Result := GetInt32(TDBXDataTypesIndex.ProviderDbType);
end;

procedure TDBXDataTypesTableStorage.SetProviderDbType(Value: Integer);
begin
  SetInt32(TDBXDataTypesIndex.ProviderDbType, Value);
end;

constructor TDBXForeignKeyColumnsTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.ForeignKeyColumns, TDBXMetaDataCollectionName.ForeignKeyColumns));
  Columns := TDBXMetaDataCollectionColumns.CreateForeignKeyColumnsColumns;
end;

constructor TDBXForeignKeyColumnsTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXForeignKeyColumnsTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXForeignKeyColumnsIndex.CatalogName);
end;

procedure TDBXForeignKeyColumnsTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXForeignKeyColumnsIndex.CatalogName, Value);
end;

function TDBXForeignKeyColumnsTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXForeignKeyColumnsIndex.SchemaName);
end;

procedure TDBXForeignKeyColumnsTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXForeignKeyColumnsIndex.SchemaName, Value);
end;

function TDBXForeignKeyColumnsTableStorage.GetTableName: WideString;
begin
  Result := GetString(TDBXForeignKeyColumnsIndex.TableName);
end;

procedure TDBXForeignKeyColumnsTableStorage.SetTableName(Value: WideString);
begin
  SetString(TDBXForeignKeyColumnsIndex.TableName, Value);
end;

function TDBXForeignKeyColumnsTableStorage.GetForeignKeyName: WideString;
begin
  Result := GetString(TDBXForeignKeyColumnsIndex.ForeignKeyName);
end;

procedure TDBXForeignKeyColumnsTableStorage.SetForeignKeyName(Value: WideString);
begin
  SetString(TDBXForeignKeyColumnsIndex.ForeignKeyName, Value);
end;

function TDBXForeignKeyColumnsTableStorage.GetColumnName: WideString;
begin
  Result := GetString(TDBXForeignKeyColumnsIndex.ColumnName);
end;

procedure TDBXForeignKeyColumnsTableStorage.SetColumnName(Value: WideString);
begin
  SetString(TDBXForeignKeyColumnsIndex.ColumnName, Value);
end;

function TDBXForeignKeyColumnsTableStorage.GetPrimaryCatalogName: WideString;
begin
  Result := GetString(TDBXForeignKeyColumnsIndex.PrimaryCatalogName);
end;

procedure TDBXForeignKeyColumnsTableStorage.SetPrimaryCatalogName(Value: WideString);
begin
  SetString(TDBXForeignKeyColumnsIndex.PrimaryCatalogName, Value);
end;

function TDBXForeignKeyColumnsTableStorage.GetPrimarySchemaName: WideString;
begin
  Result := GetString(TDBXForeignKeyColumnsIndex.PrimarySchemaName);
end;

procedure TDBXForeignKeyColumnsTableStorage.SetPrimarySchemaName(Value: WideString);
begin
  SetString(TDBXForeignKeyColumnsIndex.PrimarySchemaName, Value);
end;

function TDBXForeignKeyColumnsTableStorage.GetPrimaryTableName: WideString;
begin
  Result := GetString(TDBXForeignKeyColumnsIndex.PrimaryTableName);
end;

procedure TDBXForeignKeyColumnsTableStorage.SetPrimaryTableName(Value: WideString);
begin
  SetString(TDBXForeignKeyColumnsIndex.PrimaryTableName, Value);
end;

function TDBXForeignKeyColumnsTableStorage.GetPrimaryKeyName: WideString;
begin
  Result := GetString(TDBXForeignKeyColumnsIndex.PrimaryKeyName);
end;

procedure TDBXForeignKeyColumnsTableStorage.SetPrimaryKeyName(Value: WideString);
begin
  SetString(TDBXForeignKeyColumnsIndex.PrimaryKeyName, Value);
end;

function TDBXForeignKeyColumnsTableStorage.GetPrimaryColumnName: WideString;
begin
  Result := GetString(TDBXForeignKeyColumnsIndex.PrimaryColumnName);
end;

procedure TDBXForeignKeyColumnsTableStorage.SetPrimaryColumnName(Value: WideString);
begin
  SetString(TDBXForeignKeyColumnsIndex.PrimaryColumnName, Value);
end;

function TDBXForeignKeyColumnsTableStorage.GetOrdinal: Integer;
begin
  Result := GetInt32(TDBXForeignKeyColumnsIndex.Ordinal);
end;

procedure TDBXForeignKeyColumnsTableStorage.SetOrdinal(Value: Integer);
begin
  SetInt32(TDBXForeignKeyColumnsIndex.Ordinal, Value);
end;

constructor TDBXForeignKeysTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.ForeignKeys, TDBXMetaDataCollectionName.ForeignKeys));
  Columns := TDBXMetaDataCollectionColumns.CreateForeignKeysColumns;
end;

constructor TDBXForeignKeysTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXForeignKeysTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXForeignKeysIndex.CatalogName);
end;

procedure TDBXForeignKeysTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXForeignKeysIndex.CatalogName, Value);
end;

function TDBXForeignKeysTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXForeignKeysIndex.SchemaName);
end;

procedure TDBXForeignKeysTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXForeignKeysIndex.SchemaName, Value);
end;

function TDBXForeignKeysTableStorage.GetTableName: WideString;
begin
  Result := GetString(TDBXForeignKeysIndex.TableName);
end;

procedure TDBXForeignKeysTableStorage.SetTableName(Value: WideString);
begin
  SetString(TDBXForeignKeysIndex.TableName, Value);
end;

function TDBXForeignKeysTableStorage.GetForeignKeyName: WideString;
begin
  Result := GetString(TDBXForeignKeysIndex.ForeignKeyName);
end;

procedure TDBXForeignKeysTableStorage.SetForeignKeyName(Value: WideString);
begin
  SetString(TDBXForeignKeysIndex.ForeignKeyName, Value);
end;

constructor TDBXIndexColumnsTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.IndexColumns, TDBXMetaDataCollectionName.IndexColumns));
  Columns := TDBXMetaDataCollectionColumns.CreateIndexColumnsColumns;
end;

constructor TDBXIndexColumnsTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXIndexColumnsTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXIndexColumnsIndex.CatalogName);
end;

procedure TDBXIndexColumnsTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXIndexColumnsIndex.CatalogName, Value);
end;

function TDBXIndexColumnsTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXIndexColumnsIndex.SchemaName);
end;

procedure TDBXIndexColumnsTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXIndexColumnsIndex.SchemaName, Value);
end;

function TDBXIndexColumnsTableStorage.GetTableName: WideString;
begin
  Result := GetString(TDBXIndexColumnsIndex.TableName);
end;

procedure TDBXIndexColumnsTableStorage.SetTableName(Value: WideString);
begin
  SetString(TDBXIndexColumnsIndex.TableName, Value);
end;

function TDBXIndexColumnsTableStorage.GetIndexName: WideString;
begin
  Result := GetString(TDBXIndexColumnsIndex.IndexName);
end;

procedure TDBXIndexColumnsTableStorage.SetIndexName(Value: WideString);
begin
  SetString(TDBXIndexColumnsIndex.IndexName, Value);
end;

function TDBXIndexColumnsTableStorage.GetColumnName: WideString;
begin
  Result := GetString(TDBXIndexColumnsIndex.ColumnName);
end;

procedure TDBXIndexColumnsTableStorage.SetColumnName(Value: WideString);
begin
  SetString(TDBXIndexColumnsIndex.ColumnName, Value);
end;

function TDBXIndexColumnsTableStorage.GetOrdinal: Integer;
begin
  Result := GetInt32(TDBXIndexColumnsIndex.Ordinal);
end;

procedure TDBXIndexColumnsTableStorage.SetOrdinal(Value: Integer);
begin
  SetInt32(TDBXIndexColumnsIndex.Ordinal, Value);
end;

function TDBXIndexColumnsTableStorage.IsAscending: Boolean;
begin
  Result := GetBoolean(TDBXIndexColumnsIndex.IsAscending);
end;

procedure TDBXIndexColumnsTableStorage.SetAscending(Value: Boolean);
begin
  SetBoolean(TDBXIndexColumnsIndex.IsAscending, Value);
end;

constructor TDBXIndexesTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.Indexes, TDBXMetaDataCollectionName.Indexes));
  Columns := TDBXMetaDataCollectionColumns.CreateIndexesColumns;
end;

constructor TDBXIndexesTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXIndexesTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXIndexesIndex.CatalogName);
end;

procedure TDBXIndexesTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXIndexesIndex.CatalogName, Value);
end;

function TDBXIndexesTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXIndexesIndex.SchemaName);
end;

procedure TDBXIndexesTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXIndexesIndex.SchemaName, Value);
end;

function TDBXIndexesTableStorage.GetTableName: WideString;
begin
  Result := GetString(TDBXIndexesIndex.TableName);
end;

procedure TDBXIndexesTableStorage.SetTableName(Value: WideString);
begin
  SetString(TDBXIndexesIndex.TableName, Value);
end;

function TDBXIndexesTableStorage.GetIndexName: WideString;
begin
  Result := GetString(TDBXIndexesIndex.IndexName);
end;

procedure TDBXIndexesTableStorage.SetIndexName(Value: WideString);
begin
  SetString(TDBXIndexesIndex.IndexName, Value);
end;

function TDBXIndexesTableStorage.GetConstraintName: WideString;
begin
  Result := GetString(TDBXIndexesIndex.ConstraintName);
end;

procedure TDBXIndexesTableStorage.SetConstraintName(Value: WideString);
begin
  SetString(TDBXIndexesIndex.ConstraintName, Value);
end;

function TDBXIndexesTableStorage.IsPrimary: Boolean;
begin
  Result := GetBoolean(TDBXIndexesIndex.IsPrimary);
end;

procedure TDBXIndexesTableStorage.SetPrimary(Value: Boolean);
begin
  SetBoolean(TDBXIndexesIndex.IsPrimary, Value);
end;

function TDBXIndexesTableStorage.IsUnique: Boolean;
begin
  Result := GetBoolean(TDBXIndexesIndex.IsUnique);
end;

procedure TDBXIndexesTableStorage.SetUnique(Value: Boolean);
begin
  SetBoolean(TDBXIndexesIndex.IsUnique, Value);
end;

function TDBXIndexesTableStorage.IsAscending: Boolean;
begin
  Result := GetBoolean(TDBXIndexesIndex.IsAscending);
end;

procedure TDBXIndexesTableStorage.SetAscending(Value: Boolean);
begin
  SetBoolean(TDBXIndexesIndex.IsAscending, Value);
end;

constructor TDBXPackageProcedureParametersTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.PackageProcedureParameters, TDBXMetaDataCollectionName.PackageProcedureParameters));
  Columns := TDBXMetaDataCollectionColumns.CreatePackageProcedureParametersColumns;
end;

constructor TDBXPackageProcedureParametersTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXPackageProcedureParametersTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXPackageProcedureParametersIndex.CatalogName);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXPackageProcedureParametersIndex.CatalogName, Value);
end;

function TDBXPackageProcedureParametersTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXPackageProcedureParametersIndex.SchemaName);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXPackageProcedureParametersIndex.SchemaName, Value);
end;

function TDBXPackageProcedureParametersTableStorage.GetPackageName: WideString;
begin
  Result := GetString(TDBXPackageProcedureParametersIndex.PackageName);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetPackageName(Value: WideString);
begin
  SetString(TDBXPackageProcedureParametersIndex.PackageName, Value);
end;

function TDBXPackageProcedureParametersTableStorage.GetProcedureName: WideString;
begin
  Result := GetString(TDBXPackageProcedureParametersIndex.ProcedureName);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetProcedureName(Value: WideString);
begin
  SetString(TDBXPackageProcedureParametersIndex.ProcedureName, Value);
end;

function TDBXPackageProcedureParametersTableStorage.GetParameterName: WideString;
begin
  Result := GetString(TDBXPackageProcedureParametersIndex.ParameterName);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetParameterName(Value: WideString);
begin
  SetString(TDBXPackageProcedureParametersIndex.ParameterName, Value);
end;

function TDBXPackageProcedureParametersTableStorage.GetParameterMode: WideString;
begin
  Result := GetString(TDBXPackageProcedureParametersIndex.ParameterMode);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetParameterMode(Value: WideString);
begin
  SetString(TDBXPackageProcedureParametersIndex.ParameterMode, Value);
end;

function TDBXPackageProcedureParametersTableStorage.GetTypeName: WideString;
begin
  Result := GetString(TDBXPackageProcedureParametersIndex.TypeName);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetTypeName(Value: WideString);
begin
  SetString(TDBXPackageProcedureParametersIndex.TypeName, Value);
end;

function TDBXPackageProcedureParametersTableStorage.GetPrecision: Integer;
begin
  Result := GetInt32(TDBXPackageProcedureParametersIndex.Precision);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetPrecision(Value: Integer);
begin
  SetInt32(TDBXPackageProcedureParametersIndex.Precision, Value);
end;

function TDBXPackageProcedureParametersTableStorage.GetScale: Integer;
begin
  Result := GetInt32(TDBXPackageProcedureParametersIndex.Scale);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetScale(Value: Integer);
begin
  SetInt32(TDBXPackageProcedureParametersIndex.Scale, Value);
end;

function TDBXPackageProcedureParametersTableStorage.GetOrdinal: Integer;
begin
  Result := GetInt32(TDBXPackageProcedureParametersIndex.Ordinal);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetOrdinal(Value: Integer);
begin
  SetInt32(TDBXPackageProcedureParametersIndex.Ordinal, Value);
end;

function TDBXPackageProcedureParametersTableStorage.IsNullable: Boolean;
begin
  Result := GetBoolean(TDBXPackageProcedureParametersIndex.IsNullable);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetNullable(Value: Boolean);
begin
  SetBoolean(TDBXPackageProcedureParametersIndex.IsNullable, Value);
end;

function TDBXPackageProcedureParametersTableStorage.GetDbxDataType: Integer;
begin
  Result := GetInt32(TDBXPackageProcedureParametersIndex.DbxDataType);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetDbxDataType(Value: Integer);
begin
  SetInt32(TDBXPackageProcedureParametersIndex.DbxDataType, Value);
end;

function TDBXPackageProcedureParametersTableStorage.IsFixedLength: Boolean;
begin
  Result := GetBoolean(TDBXPackageProcedureParametersIndex.IsFixedLength);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetFixedLength(Value: Boolean);
begin
  SetBoolean(TDBXPackageProcedureParametersIndex.IsFixedLength, Value);
end;

function TDBXPackageProcedureParametersTableStorage.IsUnicode: Boolean;
begin
  Result := GetBoolean(TDBXPackageProcedureParametersIndex.IsUnicode);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetUnicode(Value: Boolean);
begin
  SetBoolean(TDBXPackageProcedureParametersIndex.IsUnicode, Value);
end;

function TDBXPackageProcedureParametersTableStorage.IsLong: Boolean;
begin
  Result := GetBoolean(TDBXPackageProcedureParametersIndex.IsLong);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetLong(Value: Boolean);
begin
  SetBoolean(TDBXPackageProcedureParametersIndex.IsLong, Value);
end;

function TDBXPackageProcedureParametersTableStorage.IsUnsigned: Boolean;
begin
  Result := GetBoolean(TDBXPackageProcedureParametersIndex.IsUnsigned);
end;

procedure TDBXPackageProcedureParametersTableStorage.SetUnsigned(Value: Boolean);
begin
  SetBoolean(TDBXPackageProcedureParametersIndex.IsUnsigned, Value);
end;

constructor TDBXPackageProceduresTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.PackageProcedures, TDBXMetaDataCollectionName.PackageProcedures));
  Columns := TDBXMetaDataCollectionColumns.CreatePackageProceduresColumns;
end;

constructor TDBXPackageProceduresTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXPackageProceduresTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXPackageProceduresIndex.CatalogName);
end;

procedure TDBXPackageProceduresTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXPackageProceduresIndex.CatalogName, Value);
end;

function TDBXPackageProceduresTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXPackageProceduresIndex.SchemaName);
end;

procedure TDBXPackageProceduresTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXPackageProceduresIndex.SchemaName, Value);
end;

function TDBXPackageProceduresTableStorage.GetPackageName: WideString;
begin
  Result := GetString(TDBXPackageProceduresIndex.PackageName);
end;

procedure TDBXPackageProceduresTableStorage.SetPackageName(Value: WideString);
begin
  SetString(TDBXPackageProceduresIndex.PackageName, Value);
end;

function TDBXPackageProceduresTableStorage.GetProcedureName: WideString;
begin
  Result := GetString(TDBXPackageProceduresIndex.ProcedureName);
end;

procedure TDBXPackageProceduresTableStorage.SetProcedureName(Value: WideString);
begin
  SetString(TDBXPackageProceduresIndex.ProcedureName, Value);
end;

function TDBXPackageProceduresTableStorage.GetProcedureType: WideString;
begin
  Result := GetString(TDBXPackageProceduresIndex.ProcedureType);
end;

procedure TDBXPackageProceduresTableStorage.SetProcedureType(Value: WideString);
begin
  SetString(TDBXPackageProceduresIndex.ProcedureType, Value);
end;

constructor TDBXPackageSourcesTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.PackageSources, TDBXMetaDataCollectionName.PackageSources));
  Columns := TDBXMetaDataCollectionColumns.CreatePackageSourcesColumns;
end;

constructor TDBXPackageSourcesTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXPackageSourcesTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXPackageSourcesIndex.CatalogName);
end;

procedure TDBXPackageSourcesTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXPackageSourcesIndex.CatalogName, Value);
end;

function TDBXPackageSourcesTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXPackageSourcesIndex.SchemaName);
end;

procedure TDBXPackageSourcesTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXPackageSourcesIndex.SchemaName, Value);
end;

function TDBXPackageSourcesTableStorage.GetPackageName: WideString;
begin
  Result := GetString(TDBXPackageSourcesIndex.PackageName);
end;

procedure TDBXPackageSourcesTableStorage.SetPackageName(Value: WideString);
begin
  SetString(TDBXPackageSourcesIndex.PackageName, Value);
end;

function TDBXPackageSourcesTableStorage.GetDefinition: WideString;
begin
  Result := GetString(TDBXPackageSourcesIndex.Definition);
end;

procedure TDBXPackageSourcesTableStorage.SetDefinition(Value: WideString);
begin
  SetString(TDBXPackageSourcesIndex.Definition, Value);
end;

constructor TDBXPackagesTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.Packages, TDBXMetaDataCollectionName.Packages));
  Columns := TDBXMetaDataCollectionColumns.CreatePackagesColumns;
end;

constructor TDBXPackagesTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXPackagesTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXPackagesIndex.CatalogName);
end;

procedure TDBXPackagesTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXPackagesIndex.CatalogName, Value);
end;

function TDBXPackagesTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXPackagesIndex.SchemaName);
end;

procedure TDBXPackagesTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXPackagesIndex.SchemaName, Value);
end;

function TDBXPackagesTableStorage.GetPackageName: WideString;
begin
  Result := GetString(TDBXPackagesIndex.PackageName);
end;

procedure TDBXPackagesTableStorage.SetPackageName(Value: WideString);
begin
  SetString(TDBXPackagesIndex.PackageName, Value);
end;

constructor TDBXProcedureParametersTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.ProcedureParameters, TDBXMetaDataCollectionName.ProcedureParameters));
  Columns := TDBXMetaDataCollectionColumns.CreateProcedureParametersColumns;
end;

constructor TDBXProcedureParametersTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXProcedureParametersTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXProcedureParametersIndex.CatalogName);
end;

procedure TDBXProcedureParametersTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXProcedureParametersIndex.CatalogName, Value);
end;

function TDBXProcedureParametersTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXProcedureParametersIndex.SchemaName);
end;

procedure TDBXProcedureParametersTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXProcedureParametersIndex.SchemaName, Value);
end;

function TDBXProcedureParametersTableStorage.GetProcedureName: WideString;
begin
  Result := GetString(TDBXProcedureParametersIndex.ProcedureName);
end;

procedure TDBXProcedureParametersTableStorage.SetProcedureName(Value: WideString);
begin
  SetString(TDBXProcedureParametersIndex.ProcedureName, Value);
end;

function TDBXProcedureParametersTableStorage.GetParameterName: WideString;
begin
  Result := GetString(TDBXProcedureParametersIndex.ParameterName);
end;

procedure TDBXProcedureParametersTableStorage.SetParameterName(Value: WideString);
begin
  SetString(TDBXProcedureParametersIndex.ParameterName, Value);
end;

function TDBXProcedureParametersTableStorage.GetParameterMode: WideString;
begin
  Result := GetString(TDBXProcedureParametersIndex.ParameterMode);
end;

procedure TDBXProcedureParametersTableStorage.SetParameterMode(Value: WideString);
begin
  SetString(TDBXProcedureParametersIndex.ParameterMode, Value);
end;

function TDBXProcedureParametersTableStorage.GetTypeName: WideString;
begin
  Result := GetString(TDBXProcedureParametersIndex.TypeName);
end;

procedure TDBXProcedureParametersTableStorage.SetTypeName(Value: WideString);
begin
  SetString(TDBXProcedureParametersIndex.TypeName, Value);
end;

function TDBXProcedureParametersTableStorage.GetPrecision: Integer;
begin
  Result := GetInt32(TDBXProcedureParametersIndex.Precision);
end;

procedure TDBXProcedureParametersTableStorage.SetPrecision(Value: Integer);
begin
  SetInt32(TDBXProcedureParametersIndex.Precision, Value);
end;

function TDBXProcedureParametersTableStorage.GetScale: Integer;
begin
  Result := GetInt32(TDBXProcedureParametersIndex.Scale);
end;

procedure TDBXProcedureParametersTableStorage.SetScale(Value: Integer);
begin
  SetInt32(TDBXProcedureParametersIndex.Scale, Value);
end;

function TDBXProcedureParametersTableStorage.GetOrdinal: Integer;
begin
  Result := GetInt32(TDBXProcedureParametersIndex.Ordinal);
end;

procedure TDBXProcedureParametersTableStorage.SetOrdinal(Value: Integer);
begin
  SetInt32(TDBXProcedureParametersIndex.Ordinal, Value);
end;

function TDBXProcedureParametersTableStorage.IsNullable: Boolean;
begin
  Result := GetBoolean(TDBXProcedureParametersIndex.IsNullable);
end;

procedure TDBXProcedureParametersTableStorage.SetNullable(Value: Boolean);
begin
  SetBoolean(TDBXProcedureParametersIndex.IsNullable, Value);
end;

function TDBXProcedureParametersTableStorage.GetDbxDataType: Integer;
begin
  Result := GetInt32(TDBXProcedureParametersIndex.DbxDataType);
end;

procedure TDBXProcedureParametersTableStorage.SetDbxDataType(Value: Integer);
begin
  SetInt32(TDBXProcedureParametersIndex.DbxDataType, Value);
end;

function TDBXProcedureParametersTableStorage.IsFixedLength: Boolean;
begin
  Result := GetBoolean(TDBXProcedureParametersIndex.IsFixedLength);
end;

procedure TDBXProcedureParametersTableStorage.SetFixedLength(Value: Boolean);
begin
  SetBoolean(TDBXProcedureParametersIndex.IsFixedLength, Value);
end;

function TDBXProcedureParametersTableStorage.IsUnicode: Boolean;
begin
  Result := GetBoolean(TDBXProcedureParametersIndex.IsUnicode);
end;

procedure TDBXProcedureParametersTableStorage.SetUnicode(Value: Boolean);
begin
  SetBoolean(TDBXProcedureParametersIndex.IsUnicode, Value);
end;

function TDBXProcedureParametersTableStorage.IsLong: Boolean;
begin
  Result := GetBoolean(TDBXProcedureParametersIndex.IsLong);
end;

procedure TDBXProcedureParametersTableStorage.SetLong(Value: Boolean);
begin
  SetBoolean(TDBXProcedureParametersIndex.IsLong, Value);
end;

function TDBXProcedureParametersTableStorage.IsUnsigned: Boolean;
begin
  Result := GetBoolean(TDBXProcedureParametersIndex.IsUnsigned);
end;

procedure TDBXProcedureParametersTableStorage.SetUnsigned(Value: Boolean);
begin
  SetBoolean(TDBXProcedureParametersIndex.IsUnsigned, Value);
end;

constructor TDBXProcedureSourcesTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.ProcedureSources, TDBXMetaDataCollectionName.ProcedureSources));
  Columns := TDBXMetaDataCollectionColumns.CreateProcedureSourcesColumns;
end;

constructor TDBXProcedureSourcesTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXProcedureSourcesTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXProcedureSourcesIndex.CatalogName);
end;

procedure TDBXProcedureSourcesTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXProcedureSourcesIndex.CatalogName, Value);
end;

function TDBXProcedureSourcesTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXProcedureSourcesIndex.SchemaName);
end;

procedure TDBXProcedureSourcesTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXProcedureSourcesIndex.SchemaName, Value);
end;

function TDBXProcedureSourcesTableStorage.GetProcedureName: WideString;
begin
  Result := GetString(TDBXProcedureSourcesIndex.ProcedureName);
end;

procedure TDBXProcedureSourcesTableStorage.SetProcedureName(Value: WideString);
begin
  SetString(TDBXProcedureSourcesIndex.ProcedureName, Value);
end;

function TDBXProcedureSourcesTableStorage.GetProcedureType: WideString;
begin
  Result := GetString(TDBXProcedureSourcesIndex.ProcedureType);
end;

procedure TDBXProcedureSourcesTableStorage.SetProcedureType(Value: WideString);
begin
  SetString(TDBXProcedureSourcesIndex.ProcedureType, Value);
end;

function TDBXProcedureSourcesTableStorage.GetDefinition: WideString;
begin
  Result := GetString(TDBXProcedureSourcesIndex.Definition);
end;

procedure TDBXProcedureSourcesTableStorage.SetDefinition(Value: WideString);
begin
  SetString(TDBXProcedureSourcesIndex.Definition, Value);
end;

function TDBXProcedureSourcesTableStorage.GetExternalDefinition: WideString;
begin
  Result := GetString(TDBXProcedureSourcesIndex.ExternalDefinition);
end;

procedure TDBXProcedureSourcesTableStorage.SetExternalDefinition(Value: WideString);
begin
  SetString(TDBXProcedureSourcesIndex.ExternalDefinition, Value);
end;

constructor TDBXProceduresTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.Procedures, TDBXMetaDataCollectionName.Procedures));
  Columns := TDBXMetaDataCollectionColumns.CreateProceduresColumns;
end;

constructor TDBXProceduresTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXProceduresTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXProceduresIndex.CatalogName);
end;

procedure TDBXProceduresTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXProceduresIndex.CatalogName, Value);
end;

function TDBXProceduresTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXProceduresIndex.SchemaName);
end;

procedure TDBXProceduresTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXProceduresIndex.SchemaName, Value);
end;

function TDBXProceduresTableStorage.GetProcedureName: WideString;
begin
  Result := GetString(TDBXProceduresIndex.ProcedureName);
end;

procedure TDBXProceduresTableStorage.SetProcedureName(Value: WideString);
begin
  SetString(TDBXProceduresIndex.ProcedureName, Value);
end;

function TDBXProceduresTableStorage.GetProcedureType: WideString;
begin
  Result := GetString(TDBXProceduresIndex.ProcedureType);
end;

procedure TDBXProceduresTableStorage.SetProcedureType(Value: WideString);
begin
  SetString(TDBXProceduresIndex.ProcedureType, Value);
end;

constructor TDBXReservedWordsTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.ReservedWords, TDBXMetaDataCollectionName.ReservedWords));
  Columns := TDBXMetaDataCollectionColumns.CreateReservedWordsColumns;
end;

constructor TDBXReservedWordsTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXReservedWordsTableStorage.GetReservedWord: WideString;
begin
  Result := GetString(TDBXReservedWordsIndex.ReservedWord);
end;

procedure TDBXReservedWordsTableStorage.SetReservedWord(Value: WideString);
begin
  SetString(TDBXReservedWordsIndex.ReservedWord, Value);
end;

constructor TDBXRolesTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.Roles, TDBXMetaDataCollectionName.Roles));
  Columns := TDBXMetaDataCollectionColumns.CreateRolesColumns;
end;

constructor TDBXRolesTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXRolesTableStorage.GetRoleName: WideString;
begin
  Result := GetString(TDBXRolesIndex.RoleName);
end;

procedure TDBXRolesTableStorage.SetRoleName(Value: WideString);
begin
  SetString(TDBXRolesIndex.RoleName, Value);
end;

constructor TDBXSchemasTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.Schemas, TDBXMetaDataCollectionName.Schemas));
  Columns := TDBXMetaDataCollectionColumns.CreateSchemasColumns;
end;

constructor TDBXSchemasTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXSchemasTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXSchemasIndex.CatalogName);
end;

procedure TDBXSchemasTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXSchemasIndex.CatalogName, Value);
end;

function TDBXSchemasTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXSchemasIndex.SchemaName);
end;

procedure TDBXSchemasTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXSchemasIndex.SchemaName, Value);
end;

constructor TDBXSynonymsTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.Synonyms, TDBXMetaDataCollectionName.Synonyms));
  Columns := TDBXMetaDataCollectionColumns.CreateSynonymsColumns;
end;

constructor TDBXSynonymsTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXSynonymsTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXSynonymsIndex.CatalogName);
end;

procedure TDBXSynonymsTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXSynonymsIndex.CatalogName, Value);
end;

function TDBXSynonymsTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXSynonymsIndex.SchemaName);
end;

procedure TDBXSynonymsTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXSynonymsIndex.SchemaName, Value);
end;

function TDBXSynonymsTableStorage.GetSynonymName: WideString;
begin
  Result := GetString(TDBXSynonymsIndex.SynonymName);
end;

procedure TDBXSynonymsTableStorage.SetSynonymName(Value: WideString);
begin
  SetString(TDBXSynonymsIndex.SynonymName, Value);
end;

function TDBXSynonymsTableStorage.GetTableCatalogName: WideString;
begin
  Result := GetString(TDBXSynonymsIndex.TableCatalogName);
end;

procedure TDBXSynonymsTableStorage.SetTableCatalogName(Value: WideString);
begin
  SetString(TDBXSynonymsIndex.TableCatalogName, Value);
end;

function TDBXSynonymsTableStorage.GetTableSchemaName: WideString;
begin
  Result := GetString(TDBXSynonymsIndex.TableSchemaName);
end;

procedure TDBXSynonymsTableStorage.SetTableSchemaName(Value: WideString);
begin
  SetString(TDBXSynonymsIndex.TableSchemaName, Value);
end;

function TDBXSynonymsTableStorage.GetTableName: WideString;
begin
  Result := GetString(TDBXSynonymsIndex.TableName);
end;

procedure TDBXSynonymsTableStorage.SetTableName(Value: WideString);
begin
  SetString(TDBXSynonymsIndex.TableName, Value);
end;

constructor TDBXTablesTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.Tables, TDBXMetaDataCollectionName.Tables));
  Columns := TDBXMetaDataCollectionColumns.CreateTablesColumns;
end;

constructor TDBXTablesTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXTablesTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXTablesIndex.CatalogName);
end;

procedure TDBXTablesTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXTablesIndex.CatalogName, Value);
end;

function TDBXTablesTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXTablesIndex.SchemaName);
end;

procedure TDBXTablesTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXTablesIndex.SchemaName, Value);
end;

function TDBXTablesTableStorage.GetTableName: WideString;
begin
  Result := GetString(TDBXTablesIndex.TableName);
end;

procedure TDBXTablesTableStorage.SetTableName(Value: WideString);
begin
  SetString(TDBXTablesIndex.TableName, Value);
end;

function TDBXTablesTableStorage.GetTableType: WideString;
begin
  Result := GetString(TDBXTablesIndex.TableType);
end;

procedure TDBXTablesTableStorage.SetTableType(Value: WideString);
begin
  SetString(TDBXTablesIndex.TableType, Value);
end;

constructor TDBXUsersTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.Users, TDBXMetaDataCollectionName.Users));
  Columns := TDBXMetaDataCollectionColumns.CreateUsersColumns;
end;

constructor TDBXUsersTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXUsersTableStorage.GetUserName: WideString;
begin
  Result := GetString(TDBXUsersIndex.UserName);
end;

procedure TDBXUsersTableStorage.SetUserName(Value: WideString);
begin
  SetString(TDBXUsersIndex.UserName, Value);
end;

constructor TDBXViewsTableStorage.Create;
begin
  inherited Create(TDBXTableStoragePlatform.Create(TDBXMetaDataCollectionIndex.Views, TDBXMetaDataCollectionName.Views));
  Columns := TDBXMetaDataCollectionColumns.CreateViewsColumns;
end;

constructor TDBXViewsTableStorage.Create(Table: TDBXTableStorage);
begin
  inherited Create(Table);
end;

function TDBXViewsTableStorage.GetCatalogName: WideString;
begin
  Result := GetString(TDBXViewsIndex.CatalogName);
end;

procedure TDBXViewsTableStorage.SetCatalogName(Value: WideString);
begin
  SetString(TDBXViewsIndex.CatalogName, Value);
end;

function TDBXViewsTableStorage.GetSchemaName: WideString;
begin
  Result := GetString(TDBXViewsIndex.SchemaName);
end;

procedure TDBXViewsTableStorage.SetSchemaName(Value: WideString);
begin
  SetString(TDBXViewsIndex.SchemaName, Value);
end;

function TDBXViewsTableStorage.GetViewName: WideString;
begin
  Result := GetString(TDBXViewsIndex.ViewName);
end;

procedure TDBXViewsTableStorage.SetViewName(Value: WideString);
begin
  SetString(TDBXViewsIndex.ViewName, Value);
end;

function TDBXViewsTableStorage.GetDefinition: WideString;
begin
  Result := GetString(TDBXViewsIndex.Definition);
end;

procedure TDBXViewsTableStorage.SetDefinition(Value: WideString);
begin
  SetString(TDBXViewsIndex.Definition, Value);
end;

end.
