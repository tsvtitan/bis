{ *************************************************************************** }
{                                                                             }
{ Kylix and Delphi Cross-Platform Visual Component Library                    }
{                                                                             }
{ Copyright (c) 1999, 2005 Borland Software Corporation                       }
{                                                                             }
{ *************************************************************************** }


unit SqlExpr;

{$R-,T-,H+,X+}

interface

uses Windows, SysUtils, Variants, Classes, DB,  DBCommon, DBCommonTypes, DBByteBuffer,
  DBXCommon, DbxDefaultDrivers, SqlTimSt, DBPlatform, Contnrs
{$IF DEFINED(CLR)}
{$ELSE}
  , WideStrings
{$IFEND}
  ;
{$IFDEF LINUX}
uses Libc, SysUtils, Variants, Classes, DB, DBCommon, Borland.Data.TDBX, SqlTimSt;
{$ENDIF}

const
// eSQLTableType
    eSQLTable       = $0001;
    eSQLView        = $0002;
    eSQLSystemTable = $0004;
    eSQLSynonym     = $0008;
    eSQLTempTable   = $0010;
    eSQLLocal       = $0020;

// eSQLProcType
    eSQLProcedure   = $0001;
    eSQLFunction    = $0002;
    eSQLPackage     = $0004;
    eSQLSysProcedure = $0008;

// eSQLColType
    eSQLRowId       = $0001;
    eSQLRowVersion  = $0002;
    eSQLAutoIncr    = $0004;
    eSQLDefault     = $0008;

// eSQLIndexType
    eSQLNonUnique   = $0001;
    eSQLUnique      = $0002;
    eSQLPrimaryKey  = $0004;

  SSelect         =   'select';               { Do not localize }
  SSelectStar     =   ' select * ';           { Do not localize }
  SSelectStarFrom =   ' select * from ';      { Do not localize }
  SSelectSpaces   =   ' select ';             { Do not localize }
  SWhere          =   ' where ';              { Do not localize }
  SAnd            =   ' and ';                { Do not localize }
  SOrderBy        =   ' order by ';           { Do not localize }
  SParam          =   '?';                    { Do not localize }
  DefaultCursor   =   0;
  HourGlassCursor =   -11;

{ Default Max BlobSize }

  DefaultMaxBlobSize = -1;   // values are in K; -1 means retrieve actual size

{ Default RowsetSize }

  DefaultRowsetSize = DBXDefaultRowSetSize;

  TErrorMessageSize = 2048;

{ FieldType Mappings }

  FldTypeMap: TFieldMap = (
    TDBXDataTypes.UnknownType, TDBXDataTypes.AnsiStringType, TDBXDataTypes.Int16Type, TDBXDataTypes.Int32Type, TDBXDataTypes.UInt16Type, TDBXDataTypes.BooleanType, // 0..5
    TDBXDataTypes.DoubleType, TDBXDataTypes.DoubleType, TDBXDataTypes.BcdType, TDBXDataTypes.DateType, TDBXDataTypes.TimeType, 0{TDBXTypes.TIMESTAMP}, TDBXDataTypes.BytesType, // 6..12
    TDBXDataTypes.VarBytesType, TDBXDataTypes.Int32Type, TDBXDataTypes.BlobType, TDBXDataTypes.BlobType, TDBXDataTypes.BlobType, TDBXDataTypes.BlobType, TDBXDataTypes.BlobType, // 13..19
          TDBXDataTypes.BlobType, TDBXDataTypes.BlobType, TDBXDataTypes.CursorType, TDBXDataTypes.AnsiStringType, TDBXDataTypes.WideStringType, TDBXDataTypes.Int64Type, TDBXDataTypes.AdtType, // 20..26
    TDBXDataTypes.ArrayType, TDBXDataTypes.RefType, TDBXDataTypes.TableType, TDBXDataTypes.BlobType, TDBXDataTypes.BlobType, TDBXDataTypes.UnknownType, TDBXDataTypes.UnknownType, // 27..33
    TDBXDataTypes.UnknownType, TDBXDataTypes.AnsiStringType, TDBXDataTypes.TimeStampType, TDBXDataTypes.BcdType, // 33..37
    TDBXDataTypes.WideStringType, TDBXDataTypes.BlobType, TDBXDataTypes.TimeStampType, TDBXDataTypes.AnsiStringType); // 38..41

  FldSubTypeMap: array[TFieldType] of Word = (
    0, 0, 0, 0, 0, 0, 0, TDBXDataTypes.MoneySubType, 0, 0, 0, 0, 0, 0, TDBXDataTypes.AutoIncSubType, // 0..14
//    TDBXTypes.SUB_TYPE_BINARY, TDBXTypes.SUB_TYPE_MEMO, TDBXTypes.SUB_TYPE_GRAPHIC, TDBXTypes.SUB_TYPE_FMTMEMO, TDBXTypes.SUB_TYPE_OLEOBJ, // 15..19
    TDBXDataTypes.BinarySubType, TDBXDataTypes.MemoSubType, 0, 0, 0, // 15..19
//    TDBXTypes.SUB_TYPE_DBSOLEOBJ, TDBXTypes.SUB_TYPE_TYPEDBINARY, 0, TDBXTypes.SUB_TYPE_FIXED, 0, // 20..24
    0, 0, 0, TDBXDataTypes.FixedSubType, 0, // 20..24
    0, 0, 0, 0, 0, TDBXDataTypes.HBinarySubType, TDBXDataTypes.HMemoSubType, 0, 0, 0, 0, 0, 0, // 24..37
    TDBXDataTypes.FixedSubType, TDBXDataTypes.WideMemoSubType, TDBXDataTypes.OracleTimeStampSubType, TDBXDataTypes.OracleIntervalSubType); // 38 ..41
  DataTypeMap: array[0..TDBXDataTypes.MaxBaseTypes - 1] of TFieldType = (
    ftUnknown, ftString, ftDate, ftBlob, ftBoolean, ftSmallint,
    ftInteger, ftFloat, ftFMTBCD, ftBytes, ftTime, ftDateTime,
    ftWord, ftInteger, ftUnknown, ftVarBytes, ftUnknown, ftCursor,
    ftLargeInt, ftLargeInt, ftADT, ftArray, ftReference, ftDataSet,
    ftTimeStamp, ftFMTBCD, ftWideString);

const
  SUB_TYPE_MEMO = TDBXDataTypes.MemoSubType;

  BlobTypeMap: array[SUB_TYPE_MEMO..TDBXDataTypes.BFileSubType] of TFieldType = (
    ftMemo, ftBlob, ftFmtMemo, ftParadoxOle, ftGraphic, ftDBaseOle,
    ftTypedBinary, ftBlob, ftBlob, ftBlob, ftWideMemo, ftOraClob, ftOraBlob,
    ftBlob, ftBlob);

type

{$IF DEFINED(CLR)}
TWideDataSet  = TDataSet;
TFieldList    = TObjectList;
TLocale       = IntPtr;
{$ELSE}
TFieldList    = TList;
TLocale = Pointer;
{$IFEND}

  // Deprecated, use TDBXErrorCode;
  SQLResult      = TDBXErrorCode;

{ Forward declarations }

  TSQLConnection = class;
  TCustomSQLDataSet = class;
  TSQLDataSet = class;
  TSQLQuery = class;
  TSQLStoredProc = class;
  TSQLTable = class;

  TLocaleCode = Integer;

  TSQLExceptionType = (exceptConnection, exceptCommand, exceptCursor, exceptMetaData, exceptUseLast);


 TTransIsolationLevel = (xilREADCOMMITTED, xilREPEATABLEREAD, xilDIRTYREAD, xilCUSTOM);

  TTransactionDesc = packed record
    TransactionID    : LongWord;             { Transaction id }
    GlobalID         : LongWord;             { Global transaction id }
    IsolationLevel   : TTransIsolationLevel; {Transaction Isolation level}
    CustomIsolation  : LongWord;             { DB specific custom isolation }
  end;


  SPParamDesc = class                   { Stored Proc Descriptor }
    iParamNum       : Word;             { Field number (1..n) }
    szName          : WideString;       { Field name }
    iArgType        : TParamType;       { Field type }
    iDataType       : TFieldType;       { Field type }
    iUnits1         : SmallInt;         { Number of Chars, digits etc }
    iUnits2         : SmallInt;         { Decimal places etc. }
    iLen            : LongWord;         { Length in bytes  }
  end;

{ TSQLBlobStream }

  TSQLBlobStream = class(TMemoryStream)
  private
    FDataSet: TCustomSQLDataSet;
    FField: TBlobField;
    FFieldNo: Integer;
  public
    constructor Create(Field: TBlobField; Mode: TBlobStreamMode = bmRead);
    destructor Destroy; override;
    procedure ReadBlobData;
  end;

  TConnectionUserType = (eUserMonitor, eUserDataSet);


{ TSQLMonitor }


  TTraceEvent = procedure(Sender: TObject; TraceInfo: TDBXTraceInfo; var LogTrace: Boolean) of object;
  TTraceLogEvent = procedure(Sender: TObject; TraceInfo: TDBXTraceInfo) of object;

  TSQLMonitor = class(TComponent)
  private
    FActive: Boolean;
    FAutoSave: Boolean;
    FFileName: string;
    FKeepConnection: Boolean;
    FMaxTraceCount: Integer;
    FOnTrace: TTraceEvent;
    FOnLogTrace: TTraceLogEvent;
    FSQLConnection: TSQLConnection;
    FStreamedActive: Boolean;
    FTraceFlags: TDBXTraceFlag;
    FTraceList: TWideStrings;
    procedure CheckInactive;
    function GetTraceCount: Integer;
  protected
    function InvokeCallBack(TraceInfo: TDBXTraceInfo): CBRType;
    procedure SetActive(Value: Boolean);
    procedure SetSQLConnection(Value: TSQLConnection);
    procedure SetStreamedActive;
    procedure SetTraceList(Value: TWideStrings);
    procedure SetFileName(const Value: String);
    procedure SwitchConnection(const Value: TSQLConnection);
    procedure Trace(TraceInfo: TDBXTraceInfo; LogTrace: Boolean); virtual;
    procedure UpdateTraceCallBack;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFromFile(AFileName: string);
    procedure SaveToFile(AFileName: string);
    property MaxTraceCount: Integer read FMaxTraceCount write FMaxTraceCount;
    property TraceCount: Integer read GetTraceCount;
  published
    property Active: Boolean read FActive write SetActive default False;
    property AutoSave: Boolean read FAutoSave write FAutoSave default False;
    property FileName: string read FFileName write SetFileName;
    property OnLogTrace: TTraceLogEvent read FOnLogTrace write FOnLogTrace;
    property OnTrace: TTraceEvent read FOnTrace write FOnTrace;
{   property TraceFlags not supported in DBExpress 1.0 }
    property TraceList: TWideStrings read FTraceList write SetTraceList stored False;
    property SQLConnection: TSQLConnection read FSQLConnection write SetSQLConnection;
  end;

//  TConnectionFactory = class(TComponent)
//    strict protected
//      function GetConnectionFactory: TDBXConnectionFactory; virtual; abstract;
//    public
//      property ConnectionFactory: TDBXConnectionFactory read GetConnectionFactory;
//  end;

//  TIniFileConnectionFactory = class(TConnectionFactory)
//    strict private
//      FDBXConnectionFactory:  TDBXIniFileConnectionFactory;
//      FOpen:                  Boolean;
//    strict protected
//      function  GetDriversFile: WideString;
//      procedure SetDriversFile(DriversFile: WideString);
//      function  GetConnectionsFile: WideString;
//      procedure SetConnectionsFile(ConnectionsFile: WideString);
//    public
//      constructor Create(AOwner: TComponent); override;
//      destructor  Destroy; override;
//      function    GetConnectionFactory: TDBXConnectionFactory; override;
//    published
//      property DriversFile: WideString read GetDriversFile write SetDriversFile;
//      property ConnectionsFile: WideString read GetConnectionsFile write SetConnectionsFile;
//  end;

{ TSQLConnection }


  EConnectFlag = (eConnect, eReconnect, eDisconnect);

  TSchemaType = (stNoSchema, stTables, stSysTables, stProcedures, stColumns,
    stProcedureParams, stIndexes, stPackages, stUserNames);

  TConnectionState = (csStateClosed, csStateOpen, csStateConnecting,
    csStateExecuting, csStateFetching, csStateDisconnecting);

  TTableScope = (tsSynonym, tsSysTable, tsTable, tsView);

  TTableScopes = set of TTableScope;

  TSQLConnectionLoginEvent = procedure(Database: TSQLConnection;
    LoginParams: TWideStrings) of object;

  TTransactionItem = class
    FTransaction:      TDBXTransaction;
    FTransactionDesc:  TTransactionDesc;
    FNext:             TTransactionItem;
  end deprecated;

  TSQLConnection = class(TCustomConnection)
  strict private
    function BeginTransaction(TransDesc: TTransactionDesc; Isolation: TDBXIsolation): TDBXTransaction; overload;

  private
    FSelectStatements: LongWord;
//    FPrevSelectStatements: LongWord;
    FActiveStatements: LongWord;
    FAutoClone: Boolean;
    FCloneParent: TSQLConnection;
    FConnectionState: TConnectionState;
    FConnectionName: string;
    FConnectionRegistryFile: string;
    FDriverName: string;
    FDriverRegistryFile: string;
    FGetDriverFunc: string;
    FTransactionCount: Integer;
    FIsCloned: Boolean;
    FDBXConnection: TDBXConnection;
    FKeepConnection: Boolean;
    //TODO: remove on next version change.
    FLastError: TDBXError;
    FLibraryName: string;
    FLoadParamsOnConnect: Boolean;
    FMonitorUsers: TList;
    FOnLogin: TSQLConnectionLoginEvent;
    FParams: TWideStrings;
    FParamsLoaded: Boolean;
    FMaxStmtsPerConn: LongWord;
    FQuoteChar: WideString;
    FProcedureQuoteChar: WideString;
    FDefaultSchemaName: WideString;
    FRefCount: Integer;
    FSQLDllHandle: THandle;
    FSQLDriver: TDBXDriver;
    FSQLHourGlass: Boolean;
    FMetaData: TDBXDatabaseMetaData;
    FSupportsNestedTrans: LongBool;
    FTableScope: TTableScopes;
    FTraceCallbackEvent: TDBXTraceEvent;
    FTransactionsSupported: LongBool;
    FVendorLib: string;
    FTransIsoLevel: TDBXIsolations;
    FLoginUsername: WideString;
//    FConnectionFactory: TConnectionFactory;
    FTransactionStack: TTransactionItem;
    FDefaultSchema: WideString;
    procedure CheckActive;
    procedure CheckInactive;
    procedure CheckLoginParams;
    procedure ClearConnectionUsers;
    procedure ClearMonitors;
    procedure FreeSchemaTable(DataSet: TCustomSQLDataSet);
    function GetConnectionForStatement: TSQLConnection;
    function GetConnectionName: string;
    function GetFDriverRegistryFile: string;
    function GetLocaleCode: TLocaleCode;
    function GetInTransaction: Boolean;
    function GetLibraryName: string;
    procedure GetLoginParams(LoginParams: TWideStrings);
    function GetQuoteChar: WideString;
    function GetVendorLib: string;
    procedure Login(ConnectionProps: TWideStrings);
    function OpenSchemaTable(eKind: TSchemaType; SInfo: WideString; SQualifier: WideString = ''; SPackage: WideString = ''): TCustomSQLDataSet;overload;
    function OpenSchemaTable(eKind: TSchemaType; SInfo: WideString; SQualifier: WideString = ''; SPackage: WideString = ''; SSchemaName: WideString = ''): TCustomSQLDataSet;overload;
    procedure RegisterTraceMonitor(Client: TObject);
    procedure RegisterTraceCallback(Value: Boolean);
    procedure SetConnectionName(Value: string);
    procedure SetDriverName(Value: string);
    procedure SetKeepConnection(Value: Boolean);
    procedure SetParams(Value: TWideStrings);
    procedure SetCursor(CursorType: Integer);
    procedure SetLocaleCode(Value: TLocaleCode);
//    function SQLTraceCallback(TraceInfo: Pointer): CBRType;
    procedure UnregisterTraceMonitor(Client: TObject);
    procedure EndFreeAndNilTransaction(var Transaction: TDBXTransaction; Commit: Boolean); overload;
    procedure EndAndFreeTransaction(Commit: Boolean); overload;
    procedure EndAndFreeTransaction(TransDesc: TTransactionDesc; Commit: Boolean); overload;
    property DefaultSchema: WideString read FDefaultSchema;
  protected
    procedure CheckConnection(eFlag: eConnectFlag);
    procedure CheckDisconnect; virtual;
    procedure ConnectionOptions; virtual;
    procedure DoConnect; override;
    procedure DoDisconnect; override;
    function GetConnected: Boolean; override;
    function GetDataSet(Index: Integer): TCustomSQLDataSet; reintroduce;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure OpenSchema(eKind: TSchemaType; sInfo: Widestring; List: TWideStrings); overload;
    procedure OpenSchema(eKind: TSchemaType; sInfo, SSchemaName: WideString; List: TWideStrings); overload;
    procedure RegisterClient(Client: TObject; Event: TConnectChangeEvent = nil); override;
    procedure SQLError(Error: TDBXError);
    procedure UnRegisterClient(Client: TObject); override;
    property ConnectionRegistryFile: string read FConnectionRegistryFile;
    property DriverRegistryFile: string read GetFDriverRegistryFile;
    //TODO: remove on next version change.
    property LastError: TDBXError read FLastError write FLastError;
    property QuoteChar: WideString read FQuoteChar;
    property SQLDllHandle: THandle read FSQLDllHandle write FSQlDllHandle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CloneConnection: TSQLConnection;
    procedure CloseDataSets;
    procedure Commit( TransDesc: TTransactionDesc); deprecated;
    procedure CommitFreeAndNil(var Transaction: TDBXTransaction);
    function Execute(const SQL: WideString; Params: TParams;
      ResultSet: TPSResult = nil): Integer;
    function ExecuteDirect(const SQL: WideString): Integer;
{$IF NOT DEFINED(CLR)}
    procedure GetFieldNames(const TableName: string; List: TStrings); overload; deprecated;
    procedure GetFieldNames(const TableName: string; SchemaName: string; List: TStrings); overload; deprecated;
{$IFEND}
    procedure GetFieldNames(const TableName: WideString; SchemaName: WideString; List: TWideStrings); overload;
    procedure GetFieldNames(const TableName: WideString; List: TWideStrings); overload;
{$IF NOT DEFINED(CLR)}
    procedure GetIndexNames(const TableName: string; List: TStrings); overload; deprecated;
    procedure GetIndexNames(const TableName, SchemaName: string; List: TStrings); overload; deprecated;
{$IFEND}
    procedure GetIndexNames(const TableName: WideString; List: TWideStrings); overload;
    procedure GetIndexNames(const TableName, SchemaName: WideString; List: TWideStrings); overload;
{$IF NOT DEFINED(CLR)}
    procedure GetProcedureNames(List: TStrings); overload; deprecated;
    procedure GetProcedureNames(const PackageName: string; List: TStrings); overload; deprecated;
    procedure GetProcedureNames(const PackageName, SchemaName: string; List: TStrings); overload; deprecated;
{$IFEND}
    procedure GetProcedureNames(List: TWideStrings); overload;
    procedure GetProcedureNames(const PackageName: Widestring; List: TWideStrings); overload;
    procedure GetProcedureNames(const PackageName, SchemaName: WideString; List: TWideStrings); overload;
{$IF NOT DEFINED(CLR)}
    procedure GetPackageNames(List: TStrings); overload; deprecated;
    procedure GetSchemaNames(List: TStrings); overload;
{$IFEND}
    procedure GetCommandTypes(List: TWideStrings);
    procedure GetPackageNames(List: TWideStrings); overload;
    procedure GetSchemaNames(List: TWideStrings); overload;
    function GetDefaultSchemaName: WideString;
    procedure GetProcedureParams(ProcedureName : WideString; List: TList); overload;
    procedure GetProcedureParams(ProcedureName, PackageName: WideString; List: TList); overload;
    procedure GetProcedureParams(ProcedureName, PackageName, SchemaName: Widestring; List: TList); overload;
{$IF NOT DEFINED(CLR)}
    procedure GetTableNames(List: TStrings; SystemTables: Boolean = False); overload;
    procedure GetTableNames(List: TStrings; SchemaName: WideString; SystemTables: Boolean = False); overload;
{$IFEND}
    procedure GetTableNames(List: TWideStrings; SchemaName: WideString; SystemTables: Boolean = False); overload;
    procedure GetTableNames(List: TWideStrings; SystemTables: Boolean = False); overload;
    procedure LoadParamsFromIniFile( FFileName: WideString = '');
    procedure Rollback( TransDesc: TTransactionDesc); deprecated;
    procedure RollbackFreeAndNil(var Transaction: TDBXTransaction);
    procedure RollbackIncompleteFreeAndNil(var Transaction: TDBXTransaction);
    function  HasTransaction(Transaction:  TDBXTransaction): Boolean;
    procedure SetTraceEvent(Event: TDBXTraceEvent);
    function  BeginTransaction: TDBXTransaction; overload;
    function  BeginTransaction(Isolation: TDBXIsolation): TDBXTransaction; overload;
    procedure StartTransaction( TransDesc: TTransactionDesc); deprecated;
    function GetLoginUsername: WideString;
    property ActiveStatements: LongWord read FActiveStatements;
    property AutoClone: Boolean read FAutoClone write FAutoClone default True;
    property ConnectionState: TConnectionState read FConnectionState write FConnectionState;
    property DataSets[Index: Integer]: TCustomSQLDataSet read GetDataSet;
    property InTransaction: Boolean read GetInTransaction;
    property LocaleCode: TLocaleCode read GetLocaleCode write SetLocaleCode default TLocaleCode(0);
    property MaxStmtsPerConn: LongWord read FMaxStmtsPerConn;
    property MetaData: TDBXDatabaseMetaData read FMetaData;
    property MultipleTransactionsSupported: LongBool read FSupportsNestedTrans;
    property ParamsLoaded: Boolean read FParamsLoaded write FParamsLoaded;
    property DBXConnection: TDBXConnection read FDBXConnection write FDBXConnection;
    property SQLHourGlass: Boolean read FSQLHourGlass write FSQLHourGlass default True;
    property TraceCallbackEvent: TDBXTraceEvent read FTraceCallbackEvent;
    property TransactionsSupported: LongBool read FTransactionsSupported;
//    property Locale: TLocale read FLocale;
  published
    property ConnectionName: string read GetConnectionName write SetConnectionName;
    property DriverName: string read FDriverName write SetDriverName;
    property GetDriverFunc: string read FGetDriverFunc write FGetDriverFunc;
    property KeepConnection: Boolean read FKeepConnection write SetKeepConnection default True;
    property LibraryName: string read GetLibraryName write FLibraryName;
    property LoadParamsOnConnect: Boolean read FLoadParamsOnConnect write FLoadParamsOnConnect default False;
    property LoginPrompt default True;
    property Params: TWideStrings read FParams write SetParams;
    property TableScope: TTableScopes read FTableScope write FTableScope default [tsTable, tsView];
    property VendorLib: string read GetVendorLib write FVendorLib;
    property AfterConnect;
    property AfterDisconnect;
    property BeforeConnect;
    property BeforeDisconnect;
    property OnLogin: TSQLConnectionLoginEvent read FOnLogin write FOnLogin;
    property Connected;
//    property ConnectionFactory: TConnectionFactory read FConnectionFactory write FConnectionFactory;
  end;

{ TSQLDataLink }

  TSQLDataLink = class(TDetailDataLink)
  private
    FSQLDataSet: TCustomSQLDataSet;
  protected
    procedure ActiveChanged; override;
    procedure CheckBrowseMode; override;
    function GetDetailDataSet: TDataSet; override;
    procedure RecordChanged(Field: TField); override;
  public
    constructor Create(ADataSet: TCustomSQLDataSet);
  end;

{ FLDDesc wrapper }

  TFLDDesc = class
    FFldNum:          Word;             { Field number (1..n) }
    FName:            WideString;       { Field name }
    FFldType:         Word;             { Field type }
    FSubType:         Word;             { Field subtype (if applicable) }
    FUnits1:          SmallInt;         { Number of Chars, digits etc }
    FUnits2:          SmallInt;         { Decimal places etc. }
    FOffset:          Word;             { Offset in the record (computed) }
    FLen:             LongWord;         { Length in bytes (computed) }
    FNullOffset:      Word;             { For Null bits (computed) }
    FFLDVchk:         FLDVchk;          { Field Has vcheck (computed) }
    FFLDRights:       FLDRights;        { Field Rights (computed) }
    FCalcField:       WordBool;         { Is Calculated field (computed) }
  public
    property iFldNum: Word read FFldNum write FFldNum;
    property szName: WideString read FName write FName;
    property iFldType: Word read FFldType write FFldType;
    property iSubType: Word read FSubType write FSubType;
    property iUnits1: SmallInt read FUnits1 write FUnits1;
    property iUnits2: SmallInt read FUnits2 write FUnits2;
    property iOffset: Word read FOffset write FOffset;
    property iLen: LongWord read FLen write FLen;
    property iNullOffset: Word read FNullOffset write FNullOffset;
    property efldvVchk: FLDVchk read FFLDVchk write FFLDVchk;
    property efldrRights: FLDRights read FFLDRights write FFLDRights;
    property bCalcField: WordBool read FCalcField write FCalcField;
  end;

{ TCustomSQLDataSet }

  TSQLSchemaInfo = record
    FType: TSchemaType;
    ObjectName: WideString;
    Pattern: WideString;
    PackageName : WideString;
  end;

  TFieldDescList = array of TFLDDesc;

  TParseSqlEvent = procedure(var FieldNames: TWideStrings; SQL: WideString;
      var TableName: WideString) of object;
  TParseInsertSqlEvent = procedure(var FieldNames: TWideStrings; SQL: WideString;
      var BindAllFields: Boolean; var TableName: WideString) of object;

  TCustomSQLDataSet = class(TWideDataSet)
  strict private
    FFieldBuffer:  TBytes;
  private
    FBlobBuffer: TBlobByteData;
    FCalcFieldsBuffer: TBytes;
    FCheckRowsAffected: Boolean;
    FClonedConnection: TSqlConnection;
    FCommandText: WideString;
    FCommandType: TSQLCommandType;
    FDbxCommandType: WideString;
    FCurrentBlobSize: Int64;
    FDataLink: TDataLink;
    FDesignerData: string;
    FGetNextRecordSet: Boolean;
    FIndexDefs: TIndexDefs;
    FIndexDefsLoaded: Boolean;
    //TODO: remove on next version change.
    FLastError: TDBXError;
    FMaxBlobSize: Integer;
    FMaxColSize: LongWord;
    FNativeCommand: WideString;
    FGetMetadata: Boolean;
    FNumericMapping: Boolean;
    FParamCheck: Boolean;
    FParamCount: Integer;
    FParams: TParams;
    FPrepared: Boolean;
    FProcParams: TList;
    FRecords: Integer;
    FRowsAffected: Integer;
    FSchemaInfo: TSQLSchemaInfo;
    FParseSelectSql: TParseSqlEvent;
    FParseUpdateSql: TParseSqlEvent;
    FParseDeleteSql: TParseSqlEvent;
    FParseInsertSql: TParseInsertSqlEvent;
    FSortFieldNames: WideString;

    FDBXCommand: TDBXCommand;
    FSQLConnection: TSQLConnection;
    FDBXReader: TDBXReader;

    FStatementOpen: Boolean;
    FTransactionLevel: SmallInt deprecated;
    FSchemaName: string;
    function CheckFieldNames(const FieldNames: WideString): Boolean;
    procedure CheckConnection(eFlag: eConnectFlag);
    function CheckDetail(const SQL: WideString): WideString;
    procedure CheckStatement(ForSchema: Boolean = False);
    function GetCalculatedField(Field: TField; var Buffer: TValueBuffer): Boolean;
    function GetDataSetFromSQL(TableName: WideString): TCustomSQLDataSet;
    function GetProcParams: TList;
    function GetInternalConnection: TSQLConnection;
    function GetObjectProcParamCount: Integer; virtual;
    function GetParamCount: Integer; virtual;
    function GetQueryFromType: WideString; virtual;
    function GetRowsAffected: Integer;
    function AddMetadataQuotes(Identifier: WideString; StoredProc: Boolean): WideString;
    function QuoteIdentifier(Identifier: WideString; StoredProc: Boolean): WideString;
    procedure InitBuffers;
    procedure LoadFieldDef(FieldID: Word; var FldDesc: TFLDDesc); overload;
    procedure ReadDesignerData(Reader: TReader);
    procedure RefreshParams;
    procedure SetConnection(const Value: TSQLConnection); virtual;
    procedure SetCurrentBlobSize(Value: Int64);
    procedure SetDataSource(Value: TDataSource);
    procedure SetParameters(const Value: TParams);
    procedure SetParamsFromProcedure;
    procedure SetParamsFromSQL(DataSet: TDataSet; bFromFields: Boolean);
    procedure SetPrepared(Value: Boolean);
    procedure SetCommandType(const Value: TSQLCommandType); virtual;
    procedure SetDbxCommandType(const Value: WideString); virtual;
    procedure WriteDesignerData(Writer: TWriter);
    procedure SetSchemaName(const Value: string);
    procedure SetSchemaOption(var ACatalogName, ASchemaName: WideString);
    procedure ParseIdentifier(Identifier: WideString; var Catalog, Schema, Name: WideString);
  protected
    { IProviderSupport2 }
    procedure PSEndTransaction(Commit: Boolean); override;
    procedure PSExecute; override;
{$IF DEFINED(CLR)}
    function PSExecuteStatement(const ASQL: string; AParams: TParams;
      var ResultSet: TObject): Integer; override;
{$ELSE}
    function PSExecuteStatement(const ASQL: WideString; AParams: TParams;
      ResultSet: TPSResult = nil): Integer; override;
{$IFEND}
    procedure PSGetAttributes(List: TList); override;
    function PSGetDefaultOrder: TIndexDef; override;
{$IF DEFINED(CLR)}
    function PSGetKeyFields: WideString; override;
    function PSGetQuoteChar: WideString; override;
    function PSGetTableName: WideString; override;
{$ELSE}
    function PSGetKeyFieldsW: WideString; override;
    function PSGetQuoteCharW: WideString; override;
    function PSGetTableNameW: WideString; override;
{$IFEND}
    function PSGetIndexDefs(IndexTypes: TIndexOptions): TIndexDefs; override;
    function PSGetParams: TParams; override;
    function PSGetUpdateException(E: Exception; Prev: EUpdateError): EUpdateError; override;
    function PSInTransaction: Boolean; override;
    function PSIsSQLBased: Boolean; override;
    function PSIsSQLSupported: Boolean; override;
    procedure PSReset; override;
    procedure PSSetCommandText(const ACommandText: WideString); override;
    procedure PSSetParams(AParams: TParams); override;
    procedure PSStartTransaction; override;
    function PSUpdateRecord(UpdateKind: TUpdateKind; Delta: TDataSet): Boolean; override;
    function PSGetCommandText: string; override;
    function PSGetCommandType: TPSCommandType; override;
  protected
    { implementation of abstract TDataSet methods }
    procedure InternalClose; override;
    procedure InternalHandleException; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalOpen; override;
    function IsCursorOpen: Boolean; override;
  protected
    procedure AddFieldDesc(FieldDescs: TFieldDescList; DescNo: Integer;
        var FieldID: Integer; RequiredFields: TBits; FieldDefs: TFieldDefs);
    procedure AddIndexDefs(SourceDS: TCustomSQLDataSet; IndexName: string = '') ;
    procedure CheckPrepareError;
    procedure ClearIndexDefs;
    procedure CloseCursor; override;
    procedure CloseStatement;
    procedure DefineProperties(Filer: TFiler); override;
    function ExecSQL(ExecDirect: Boolean = False): Integer; virtual;
    procedure ExecuteStatement;
    procedure FreeReader;
    procedure FreeBuffers;
    procedure FreeCommand;
    function GetCanModify: Boolean; override;
    function GetDataSource: TDataSource; override;
    procedure GetObjectTypeNames(Fields: TFields);
    procedure GetOutputParams(AProcParams: TList = nil);
    function GetRecord(Buffer: TRecordBuffer; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
    function GetSortFieldNames: WideString;
    procedure InitRecord(Buffer: TRecordBuffer); override;
    procedure InternalRefresh; override;
    procedure Loaded; override;
    function LocateRecord(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions; SyncCursor: Boolean): Boolean;
    procedure OpenCursor(InfoQuery: Boolean); override;
    procedure OpenSchema; virtual;
    procedure PropertyChanged;
    procedure SetBufListSize(Value: Integer); override;
    procedure SetCommandText(const Value: WideString); virtual;

{$IF DEFINED(CLR)}
    procedure SetFieldData(Field: TField; Buffer: TValueBuffer); override;
{$ELSE}
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
{$IFEND}
    procedure SetParamsFromCursor;
    procedure SetSortFieldNames(Value: WideString);
    procedure UpdateIndexDefs; override;
    { protected properties }
    property BlobBuffer: TBlobByteData read FBlobBuffer write FBlobBuffer;
    property CurrentBlobSize: Int64 read FCurrentBlobSize write SetCurrentBlobSize;
    property DataLink: TDataLink read FDataLink;
    property InternalConnection: TSqlConnection read GetInternalConnection;
    //TODO: remove on next version change.
    property LastError: TDBXError read FLastError write FLastError;
    property NativeCommand: WideString read FNativeCommand write FNativeCommand;
    property ProcParams: TList read GetProcParams write FProcParams;
    property RowsAffected: Integer read GetRowsAffected;
    procedure SetMaxBlobSize(MaxSize: Integer);
    procedure SetFCommandText(const Value: string);
    property ParamCount: Integer read GetParamCount;
    property SchemaInfo: TSQLSchemaInfo read FSchemaInfo write FSchemaInfo;
  protected  { publish in TSQLDataSet }
    property CommandType: TSQLCommandType read FCommandType write SetCommandType default ctQuery;
    property DbxCommandType: WideString read FDbxCommandType write SetDbxCommandType;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property MaxBlobSize: Integer read FMaxBlobSize write SetMaxBlobSize default 0;
    function GetRecordCount: Integer; override;
    property Params: TParams read FParams write SetParameters;
    property ParamCheck: Boolean read FParamCheck write FParamCheck default True;
    property SortFieldNames: WideString read GetSortFieldNames write SetSortFieldNames;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CommandText: WideString read FCommandText write SetCommandText;
    function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override;
    function GetBlobFieldData(FieldNo: Integer; var Buffer: TBlobByteData): Integer; override;
    procedure GetCommandNames(List: TWideStrings);
{$IF DEFINED(CLR)}
    procedure GetDetailLinkFields(MasterFields, DetailFields: TObjectList); override;
    function GetFieldData(FieldNo: Integer; Buffer: TValueBuffer): Boolean; overload; override;
    function GetFieldData(Field: TField; Buffer: TValueBuffer): Boolean; overload; override;
{$ELSE}
    procedure GetDetailLinkFields(MasterFields, DetailFields: TList); override;
    function GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean; overload; override;
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; overload; override;
{$IFEND}
{$IF NOT DEFINED(CLR)}
    function GetKeyFieldNames(List: TStrings): Integer; overload;
{$IFEND}
    function GetKeyFieldNames(List: TWideStrings): Integer; overload;
    function GetQuoteChar: WideString; virtual;
    function ParamByName(const Value: string): TParam;
    procedure PrepareStatement; virtual;
    property IndexDefs: TIndexDefs read FIndexDefs write FIndexDefs;
    function IsSequenced: Boolean; override;
    function Locate(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean; override;
    function Lookup(const KeyFields: string; const KeyValues: Variant;
      const ResultFields: string): Variant; override;
    procedure SetSchemaInfo(SchemaType: TSchemaType; SchemaObjectName, SchemaPattern: WideString; PackageName: WideString = '' );
    property Prepared: Boolean read FPrepared write SetPrepared default False;
    property DesignerData: string read FDesignerData write FDesignerData;
    property RecordCount: Integer read GetRecordCount;
    property SQLConnection: TSQLConnection read FSQLConnection write SetConnection;
    property TransactionLevel: SmallInt read FTransactionLevel write FTransactionLevel default 0;
  published
    property ParseSelectSql: TParseSqlEvent read FParseSelectSql write FParseSelectSql;
    property ParseDeleteSql: TParseSqlEvent read FParseDeleteSql write FParseDeleteSql;
    property ParseUpdateSql: TParseSqlEvent read FParseUpdateSql write FParseUpdateSql;
    property ParseInsertSql: TParseInsertSqlEvent read FParseInsertSql write FParseInsertSql;
    property SchemaName: string read FSchemaName write SetSchemaName;
    property GetMetadata: Boolean read FGetMetadata write FGetMetadata default True;
    property NumericMapping: Boolean read FNumericMapping write FNumericMapping default False;
    property ObjectView default False;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property Active default False;
  end;

{ TSQLDataSet }

  TSQLDataSet = class(TCustomSQLDataSet)
  public
    constructor Create(AOwner: TComponent); override;
    function ExecSQL(ExecDirect: Boolean = False): Integer; override;
  published
    property CommandText;
    property CommandType;
    property DbxCommandType;
    property DataSource;
    property MaxBlobSize;
    property ParamCheck;
    property Params;
    property SortFieldNames;
    property SQLConnection;
  end;

{ TSQLQuery }

  TSQLQuery = class(TCustomSQLDataSet)
  private
    FSQL: TWideStrings;
    FText: string;
    procedure QueryChanged(Sender: TObject);
    procedure SetSQL(Value: TWideStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecSQL(ExecDirect: Boolean = False): Integer; override;
    procedure PrepareStatement; override;
    property RowsAffected;
    property Text: string read FText;
  published
    property DataSource;
    property GetMetadata default False;
    property MaxBlobSize;
    property ParamCheck;
    property Params;
    property SQL: TWideStrings read FSQL write SetSQL;
    property SQLConnection;
  end;

{ TSQLStoredProc }

  TSQLStoredProc = class(TCustomSQLDataSet)
  private
    FStoredProcName: WideString;
    FPackageName: WideString;
    procedure SetStoredProcName(Value: WideString);
    procedure SetPackageName(Value: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    function ExecProc: Integer; virtual;
    function NextRecordSet: TCustomSQLDataSet;
    procedure PrepareStatement; override;
  published
    property MaxBlobSize;
    property ParamCheck;
    property Params;
    { SetPackageName set StoredProcName to empty string
      Need to set PackageName 1st, and StoredProcName 2nd.
      Don't change following 2 items order }
    property PackageName: WideString read FPackageName write SetPackageName;
    property SQLConnection;
    property StoredProcName: WideString read FStoredProcName write SetStoredProcName;
  end;

{ TSQLTable }

  TSQLTable = class(TCustomSQLDataSet)
  private
    FIsDetail: Boolean;
    FIndexFields: TList;
    FIndexFieldNames: WideString;
    FIndexName: WideString;
    FMasterLink: TMasterDataLink;
    FTableName: WideString;
    FIndexFieldCount: Integer;
    procedure AddParamsToQuery;
    function GetMasterFields: WideString;
    function GetIndexField(Index: Integer): TField;
    function GetIndexFieldCount: Integer;
    function RefreshIndexFields: Integer;
    procedure SetIndexFieldNames(Value: WideString);
    procedure SetIndexName(Value: WideString);
    procedure SetMasterFields(Value: WideString);
    procedure SetTableName(Value: WideString);
    function GetQueryFromType: WideString; override;
    procedure SetDataSource(Value: TDataSource);
  protected
    procedure OpenCursor(InfoQuery: Boolean); override;
    procedure SetIndexField(Index: Integer; Value: TField);
    property MasterLink: TMasterDataLink read FMasterLink;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DeleteRecords;
    procedure GetIndexNames(List: TWideStrings);
    procedure PrepareStatement; override;
    property IndexFields[Index: Integer]: TField read GetIndexField write SetIndexField;
    property IndexFieldCount: Integer read GetIndexFieldCount;
  published
    property Active default False;
    property IndexFieldNames: WideString read FIndexFieldNames write SetIndexFieldNames;
    property IndexName: WideString read FIndexName write SetIndexName;
    property MasterFields: WideString read GetMasterFields write SetMasterFields;
    property MasterSource: TDataSource read GetDataSource write SetDataSource;
    property MaxBlobSize;
    property SQLConnection;
    property TableName: WideString read FTableName write SetTableName;
  end;

{ Utility Routines }

  procedure LoadParamListItems(Params: TParams; ProcParams: TList);
  procedure FreeProcParams(var ProcParams: TList);
  procedure GetConnectionNames(List: TStrings; Driver: string = ''; DesignMode: Boolean = True);
  procedure GetDriverNames(List: TStrings; DesignMode: Boolean = True);
  function GetDriverRegistryFile(DesignMode: Boolean = False): string;
  function GetConnectionRegistryFile(DesignMode: Boolean = False): string;

type
  TGetDriverFunc = function(SVendorLib, SResourceFile: PChar; out Obj): TDBXErrorCode; stdcall;
//var
//{$IFDEF MSWINDOWS}
//  DllGetClassObject: function(const CLSID, IID: TGUID; var Obj): HResult; stdcall;
//  procedure RegisterDbXpressLib(GetClassProc: Pointer);
//{$ENDIF}
//
//threadvar
//  GetDriver: TGetDriverFunc;
//  DllHandle: THandle;

implementation

{$IF DEFINED(LINUX)}
uses SqlConst, DBConsts, IniFiles, Math, DBConnAdmin, FMTBcd, DBXMetaDataNames;
{$IFEND}
{$IF DEFINED(CLR)}
//uses Registry, SqlConst, DBConsts, IniFiles, DBConnAdmin, Math, FMTBcd, StrUtils
uses Registry, SqlConst, DBConsts, FMTBcd, IniFiles, Math, DBConnAdmin, StrUtils,
  System.Text, System.IO;

{$ELSE}
uses Registry, SqlConst, DBConsts, FMTBcd, IniFiles, DBConnAdmin, Math, WideStrUtils;
{$IFEND}
type
  // deprecated.  Will be replaced by newer DBX4 metadata in the next
  // release.
  //
  TDBXIndexType = class
    const
      NonUnique                = $0001;
      Unique                   = $0002;
      PrimaryKey               = $0004;
  end;

  TDBXIndexColumn = class
    FIndexName:   WideString;
    FColumnName:  WideString;
    FOrdinal:     Integer;
    FAscending:   Boolean;
  end;

  TDBXIndexColumns = class
    private
      FGetIndexesText:  WideString;
      FSqlConnection:   TSQLConnection;
      FColumns:         TObjectList;
      procedure Open;
      function HasAllFieldNames( IndexName: WideString;
                              DataSet: TCustomSQLDataSet;
                              var FieldNames: String;
                              var FirstColumnAscending: Boolean): Boolean;
      function GetFieldNames(IndexName: WideString): String;
  public
    constructor Create;
    destructor Destroy; override;
  end;


{ Utility routines }

//procedure CheckObject(const Value: IInterface; const eType: TSQLExceptionType);
//var
//  Message: string;
//begin
//  if not Assigned(Value) then
//  begin
//    case eType of
//      exceptConnection: Message := SDBXNOCONNECTION;
//      exceptCommand: Message := SDBXNOCOMMAND;
//      exceptCursor: Message := SDBXNOCURSOR;
//      exceptMetadata: Message := SDBXNOMETAOBJECT;
//    end;
//    DatabaseError(Message);
//  end;
//end;

{
function GetTableScope(Scope: TTableScopes): WideString;
begin
  Result := '';
  if tsTable in Scope then
    Result := Result + TDBXMetaDataTableTypes.Table;
  if tsView in Scope then
  begin
    if Result <> '' then
      Result := Result + ';';
    Result := Result + TDBXMetaDataTableTypes.View;
  end;
  if tsSysTable in Scope then
  begin
    if Result <> '' then
      Result := Result + ';';
    Result := Result + TDBXMetaDataTableTypes.SystemTable;
  end;
  if tsSynonym in Scope then
  begin
    if Result <> '' then
      Result := Result + ';';
    Result := Result + TDBXMetaDataTableTypes.Synonym;
  end;

end;
}

function GetTableScope(Scope: TTableScopes): WideString;
begin
  Result := '';
  if tsTable in Scope then
    Result := Result + TDBXMetaDataTableTypes.Table + ';';
  if tsView in Scope then
    Result := Result + TDBXMetaDataTableTypes.View + ';';
  if tsSysTable in Scope then
    Result := Result + TDBXMetaDataTableTypes.SystemTable + ';';
  if tsSynonym in Scope then
    Result := Result + TDBXMetaDataTableTypes.Synonym + ';';
end;

{$IFDEF LINUX}
function CopyConfFile(Source, Target: string): Boolean;
var
  List: TStrings;
  IniIn, IniOut: TMemIniFile;
begin
  List := TStringList.Create;
  try
    IniIn := TMemIniFile.Create(Source);
    try
      IniOut := TMemIniFile.Create(Target);
      try
        IniIn.GetStrings(List);
        IniOut.SetStrings(List);
        IniOut.UpdateFile;
        Result := True;
      finally
        IniOut.Free;
      end;
    finally
      IniIn.Free;
    end;
  finally
    List.Free;
  end;
end;
{$ENDIF}

function GetRegistryFile(Setting, Default: string; DesignMode: Boolean): string;
{$IF LINUX}
var
  GlobalFile: string;
begin
  Result := getenv('HOME') + SDBEXPRESSREG_USERPATH + Default;    { do not localize }
  if not FileExists(Result) then
  begin
    GlobalFile := SDBEXPRESSREG_GLOBALPATH + Default + SConfExtension;
    if FileExists(GlobalFile) then
    begin
      if DesignMode then
      begin
        if not CopyConfFile(GlobalFile, Result) then
          DatabaseErrorFmt(SConfFileMoveError, [GlobalFile, Result])
      end else
        Result := GlobalFile;
    end else
      DatabaseErrorFmt(SMissingConfFile, [GlobalFile]);
  end;
{$ELSE}
var
  Reg: TRegistry;
begin
  Result := '';
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly(TDBXRegistryKey) then
      Result := Reg.ReadString(Setting);
  finally
    Reg.Free;
  end;
  if Result = '' then
    Result := ExtractFileDir(ParamStr(0)) + '\' + Default;
{$IFEND}
end;

function GetDriverRegistryFile(DesignMode: Boolean = False): string;
begin
  Result := GetRegistryFile(TDBXRegistryDriverValue, TDBXDriverFile, DesignMode);
end;

function GetConnectionRegistryFile(DesignMode: Boolean = False): string;
begin
  Result := GetRegistryFile(TDBXRegistryConnectionValue, TDBXConnectionFile, DesignMode);
end;

function GetBlobLength(DataSet: TCustomSQLDataSet; FieldNo: Integer): Int64;
var
  IsNull: LongBool;
begin
  Result := 0;
  if not DataSet.EOF then
  begin
    if DataSet.MaxBlobSize = 0 then
      exit;
    DataSet.FDBXReader.ByteReader.GetByteLength(FieldNo-1, Result, isNull);
    if isNull then
      Result := 0;
  end;
  DataSet.CurrentBlobSize := Result;
end;

function NextPiece(Start: WideString; InLiteral: Boolean; QuoteChar: WideChar; EndParam: Boolean = False): Integer;
var
  P, Len: Integer;
  C: WideChar;
  SearchChars: TSysCharSet;
begin
  SearchChars := [' ', ')', ',', '=', ':', '>', '<', #13, #10];
  P := 2;
  Len := Length(Start);
  Result := 0;
  while (Result = 0) and (P <= Len) and (Start[P] <> #0) do
  begin
    C := Start[P];
    if (C = '''') or (C = QuoteChar) then
      InLiteral := not InLiteral
    else if not InLiteral and (C in SearchChars) then
    begin
      if EndParam then
      begin
        if not (C in ['=', ':', '<', '>']) then
          Result := P;
      end else
      begin
        if (C = ':') then
        begin
          if (Start[P-1] in [' ', ')', ',', '=', '(']) then
            Result := P - 1;
        end else if (P < Len) and (Start[P + 1] = ':') then
          Result := P;
      end;
    end;
    Inc(P);
  end;
end;

// SqlObjects does not support named params: convert to ?
// if not yet converted
function FixParams(SQL: WideString; Count: Integer; QuoteChar: WideString): string;
var
  Param, Start: string;
  Pos, EndPos: Integer;
  InLiteral: Boolean;
  Q: WideChar;
begin
  Q := #0;
  if Length(QuoteChar) > 0 then
    Q := QuoteChar[1];
  if (Q in [#0, ' ']) then Q := '''';
  InLiteral := False;
  Start := SQL;
  Pos := NextPiece(Start, InLiteral, Q);
  while Pos > 0 do
  begin
    Start := copy(Start, Pos + 1, Length(Start) - Pos);
    EndPos := NextPiece(Start, InLiteral, Q, True);
    if EndPos = 0 then
      Param := copy(Start, 1, Length(Start))
    else
      Param := copy(Start, 1, EndPos-1);
    SQL := StringReplace(SQL, Param, ' ? ', []);
    Pos := NextPiece(Start, InLiteral, Q);
  end;
  Result := SQL;
end;
{
function NextPiece(Start: WideString; InLiteral: Boolean; QuoteChar: WideChar; EndParam: Boolean = False): Integer;
var
  P: PWideChar;
  Ctr: Integer;
  SearchChars: set of char;
begin
  SearchChars := [' ', ')', ',', '=', ':', '>', '<', #13, #10];
  P := (PWideChar(Start))+1;
  Ctr := 1;
  Result := 0;
  while (Result = 0) and (P^ <> #0) do
  begin
    if (P^ = '''') or (P^ = QuoteChar) then
      InLiteral := not InLiteral
    else
    if not InLiteral and inOpSet(P^, SearchChars) then
    begin
      if EndParam then
      begin
        if not inOpSet(P^, ['=', ':', '<', '>']) then
        begin
          Result := Ctr;
          Inc(Result);
        end
      end else
      begin
        if (P^ = ':') then
        begin
          if inOpSet(P[-1], [' ', ')', ',', '=', '(']) then
            Result := Ctr;
        end
        else if (P[1] = ':') then
        begin
          Result := Ctr;
          Inc(Result);
        end;
      end;
    end;
    Inc(P);
    Inc(Ctr);
  end;
end;

// SqlObjects does not support named params: convert to ?
// if not yet converted
function FixParams(SQL: WideString; Count: Integer; QuoteChar: WideString): Widestring;
var
  Param, Start: Widestring;
  Pos, EndPos: Integer;
  InLiteral: Boolean;
  Q: WideChar;
begin
  Q := PWideChar(QuoteChar)[0];
  if inOpSet(Q, [#0, ' ']) then Q := '''';
  InLiteral := False;
  Start := SQL;
  Pos := NextPiece(Start, InLiteral, Q);
  while Pos > 0 do
  begin
    Start := copy(Start, Pos + 1, Length(Start) - Pos);
    EndPos := NextPiece(Start, InLiteral, Q, True);
    if EndPos = 0 then
      Param := copy(Start, 1, Length(Start))
    else
      Param := copy(Start, 1, EndPos-1);
    SQL := WideStringReplace(SQL, Param, ' ? ', []);
    Pos := NextPiece(Start, InLiteral, Q);
  end;
  Result := SQL;
end;
}
function GetProfileString(Section, Setting, IniFileName: string): string;
var
  IniFile: TMemIniFile;
  List: TStrings;
begin
  List := TStringList.Create;
  try
    IniFile := TMemIniFile.Create(IniFileName);
    IniFile.ReadSectionValues(Section, List);
    try
      Result := List.Values[ Setting ];
    finally
      IniFile.Free;
    end;
  finally
    List.Free;
  end;
end;

procedure GetDriverNames(List: TStrings; DesignMode: Boolean = True);
var
  ConnectionAdmin: IConnectionAdmin;
begin
  ConnectionAdmin := GetConnectionAdmin;
  ConnectionAdmin.GetDriverNames(List);
end;

procedure GetConnectionNames(List: TStrings; Driver: string = ''; DesignMode: Boolean = True);
var
  I: Integer;
  ConnectionAdmin: IConnectionAdmin;
begin
  ConnectionAdmin := GetConnectionAdmin;
  ConnectionAdmin.GetConnectionNames(List, '');
  if Driver <> '' then
  begin
    List.BeginUpdate;
    try
      I := List.Count - 1;
      while I >= 0 do
      begin
        if AnsiCompareText(GetProfileString(List[I], DRIVERNAME_KEY,
              GetConnectionRegistryFile(DesignMode)), Driver) <> 0 then
           List.Delete(I);
        Dec(I);
      end;
    finally
      List.EndUpdate;
    end;
  end;
end;

//procedure GetParamData(Param: TParam; Buffer: Pointer; const DrvLocale: TLocale);
procedure GetParamData(Param: TParam; Buffer: TRecordBuffer; const DrvLocale: TLocale);
begin
  if Buffer <> nil then
  begin
    with Param do
      if DataType in [ftString, ftFixedChar, ftMemo]  then
      begin
        NativeStr := VarToStr(Value); { TODO -oTArisawa -cWide : Check NativeStr. }
        GetData(Buffer);
      end else if DataType = ftBcd then
        TPlatformRecordBuffer.setFMTBcd(Buffer, AsFmtBcd)
      else
        GetData(Buffer);
  end;
end;

procedure CalcUnits( const Params: TParams; const ProcParams: TList;
          const Index: Integer; var pArgDesc: SPParamDesc; var ChildPos: array of Word );
var
  I:        Integer;
  ArgDesc:  SPParamDesc;
begin
  I := Index + 1;
  pArgDesc.iUnits1 := 0;
  pArgDesc.iUnits2 := 0;
  if ProcParams = nil then
    ArgDesc := SPParamDesc.Create
  else
    ArgDesc := nil;
  try
    while (I < Params.Count) do
    begin
      if ProcParams <> nil then
        ArgDesc := (SPParamDesc(ProcParams.Items[I]))
      else
        begin
          with ArgDesc, Params[i] do
            begin
              iParamNum := ID + 1;
              szName := Name;
              iArgType := ParamType;
              iDataType := DataType;
              iUnits1 := Precision;
              iUnits2 := NumericScale;
              iLen := GetDataSize;
            end;
        end;
      if ArgDesc.iParamNum <> pArgDesc.iParamNum then
        break;
      Inc(pArgDesc.iUnits1);
      Inc(pArgDesc.iUnits2);
      ChildPos[I] := I - Index;
      if ArgDesc.iDataType = ftADT then
      begin
        CalcUnits(Params, ProcParams, I, ArgDesc, ChildPos);
        Inc(pArgDesc.iUnits2, ArgDesc.iUnits2);
        Inc(I, ArgDesc.iUnits2);
      end else
        Inc(I);
    end;
  finally
    if ProcParams = nil then
      ArgDesc.Free;
  end;
end;

//var bugcount: Integer;
{$IF NOT DEFINED(CLR)}
procedure CopyParamBytesToByteBuffer(const Param: TParam; const Buffer: TDBByteBuffer);
var
  Value: Variant;
  P: Pointer;
begin
  Value := Param.Value;
  if VarIsArray(Value) then
  begin
    P := VarArrayLock(Value);
    try
      Buffer.Append(PChar(P), VarArrayHighBound(Value, 1) + 1);
    finally
      VarArrayUnlock(Value);
    end;
  end;
end;
{$IFEND}

procedure SetQueryProcParams(const Sender: TSQLConnection;
  const Command: TDBXCommand; const Params: TParams; ProcParams: TList = nil);
var
  I, IInd, DataLen: Integer;
  DBXIndex: Integer;
//  DBXParameter: TDBXParameter;
  iFldNum: LongWord;
  iFldType, iSubType: Word;
  DrvLocale: TLocale;
  Status: TDBXErrorCode;
  ArgDesc: SPParamDesc;
  ChildPosArray: array of Word;
  SBcd: string;
  Param: TParam;
  Buffer: TDBByteBuffer;
  ExtractedBytes: TBytes;
  DbxParameter: TDBXParameter;
begin
//inc(bugcount);
//if bugcount > 29 then
//  writeln('bugcount:  ' + IntToStr(bugcount));
  DrvLocale := nil;
  Buffer := nil;
  SetLength(ChildPosArray, Params.Count);
  ArgDesc := SPParamDesc.Create;
  try
    for I := 0 to Params.Count - 1 do
      begin
        Param := Params[I];
        try
          if Param.ParamType = ptUnknown then  // Midas assumes its Input
            Param.ParamType := ptInput;
          iFldNum := i + 1;
          iFldType := FldTypeMap[Param.DataType];
          iSubType := 0;
          if iFldType in [TDBXDataTypes.BlobType, TDBXDataTypes.AnsiStringType] then
            iSubType := Word(FldSubTypeMap[Param.DataType])
          else if iFldType = TDBXDataTypes.UnknownType then
            DatabaseErrorFmt(SNoParameterValue, [Param.Name]);
          if ProcParams <> nil then
            with (SPParamDesc(ProcParams.Items[I])) do
              begin
                // This method will modify ArgDesc.iLen, so make a copy.
                //
                ArgDesc.iParamNum := iParamNum;
                ArgDesc.szName := szName;
                ArgDesc.iArgType := iArgType;
                ArgDesc.iDataType := iDataType;
                ArgDesc.iUnits1 := iUnits1;
                ArgDesc.iUnits2 := iUnits2;
                ArgDesc.iLen := iLen;
              end
          else
            with ArgDesc, Param do
              begin
                iParamNum := iFldNum;
                szName := Name;
                iArgType := ParamType;
                iDataType := DataType;
                iUnits1 := Precision;
                iUnits2 := NumericScale;
                iLen := GetDataSize;
              end;
          iFldType := FldTypeMap[ArgDesc.iDataType];
          if Param.ParamType <> ptOutput then
            DataLen := Param.GetDataSize
          else
            DataLen := ArgDesc.iLen;
          {Check if the IN param is NULL and set the NULL indicator}
          if ((Param.ParamType in [ptInput, ptInputOutput]) and Param.IsNull) then
            iInd := 1
          else
          if (DataLen > 0) then
          begin
            iInd := 0;
            if Param.ParamType = ptInput then
              Param.Size := 0;
            if (Param.ParamType = ptOutput) and not(iFldType in [TDBXDataTypes.DoubleType]) then
            begin
              if iFldType in [TDBXDataTypes.BcdType{, TDBXTypes.FMTBCD}] then
                Param.Size := ArgDesc.iUnits1
              else
                ArgDesc.iLen := 0;
            end else
              case iFldType of
                TDBXDataTypes.BlobType:
                  begin
                    ArgDesc.iLen := DataLen;
                    ArgDesc.iUnits2 := 0;
                    Param.Size := DataLen;
                  end;
                TDBXDataTypes.AnsiStringType, TDBXDataTypes.BytesType, TDBXDataTypes.VarBytesType:
                  begin
                    ArgDesc.iLen := DataLen;
                    ArgDesc.iUnits2 := 0;
                    if Param.ParamType = ptInput then
                    begin
                      if (iFldType <> TDBXDataTypes.AnsiStringType) or (DataLen > 0) then
                        Param.Size := DataLen;
                    end else if (Param.ParamType = ptInputOutput) and (DataLen > Param.Size) then
                    begin
                      Param.Size := DataLen;
                    end;
                  end;
                TDBXDataTypes.DoubleType:
                  begin
                    if Param.Precision = 4 then
                      ArgDesc.iLen := 4
                    else
                      ArgDesc.iLen := Sizeof(Double);
                  end;
                {TDBXTypes.FMTBCD,} TDBXDataTypes.BcdType:
                  begin
                    iFldType := TDBXDataTypes.BcdType;
                    if Param.Size <> 0 then
                    begin
                      ArgDesc.iUnits2 := Param.NumericScale;
                    end;
                  end;
                TDBXDataTypes.AdtType, TDBXDataTypes.ArrayType:
                  begin
                    CalcUnits(Params, ProcParams, I, ArgDesc, ChildPosArray);
                    ArgDesc.iLen := DataLen;
                  end;
              end;
          end else
          begin
            if iFldType in [TDBXDataTypes.AdtType, TDBXDataTypes.ArrayType] then
              DatabaseError(SObjectTypenameRequired);
            iInd := 1;
          end;
          DBXIndex := iFldNum - 1 - ChildPosArray[I];

          DbxParameter := Command.Parameters[DbxIndex];
          if DbxParameter = nil then
          begin
            DbxParameter := Command.CreateParameter;
            Command.Parameters.SetParameter(DbxIndex, DbxParameter);
          end;

          with DbxParameter do
          begin
            ChildPosition      := ChildPosArray[I];
            ParameterDirection := TDBXParameterDirection(ArgDesc.iArgType);
            DataType           := iFldType;
            SubType            := iSubType;
            Size               := ArgDesc.iLen;
            Precision          := Param.Size;
            Scale              := Integer(ArgDesc.iUnits2);
            if    (ParameterDirection = TDBXParameterDirections.InParameter)
              or  (ParameterDirection = TDBXParameterDirections.InOutParameter) then
            begin
              if iInd <> 0 then
                Value.SetNull
              else //if Param.ParamType <> ptOutput then
              // Should not be the Param type.  It must be the type from
              // ProcParams since this is the actual type.  Param has
              // the Variant type which may not be the same.
              //
                case ArgDesc.iDataType of
                  ftString, ftFixedChar, ftMemo, ftAdt:
                    Value.SetAnsiString(Param.AsString);
                  ftWideString, ftWideMemo:
    {$IF DEFINED(CLR)}
                    Value.SetWideString(Param.AsString);
    {$ELSE}
                    Value.SetWideString(Param.AsWideString);
    {$IFEND}
                  ftSmallint, ftWord:
                    Value.SetInt16(Param.AsInteger);
                  ftAutoInc, ftInteger:
                    Value.SetInt32(Param.AsInteger);
                  ftTime:
                    Value.SetTime(DateTimeToTimeStamp(Param.AsDateTime).Time);
                  ftDate:
                    Value.SetDate(DateTimeToTimeStamp(Param.AsDateTime).Date);
                  ftBCD, ftFMTBCD:
                    Value.SetBCD(Param.AsFMTBcd);
                  ftCurrency, ftFloat:
                    Value.SetDouble(Param.AsFloat);
                  ftTimeStamp:
                    Value.SetTimestamp(Param.AsSQLTimeStamp);
                  ftBoolean:
                    Value.SetBoolean(Param.AsBoolean);
{$IF DEFINED(CLR)}
                  ftBytes, ftVarBytes,
                  ftBlob, ftGraphic..ftTypedBinary,ftOraBlob,ftOraClob:
                  begin
                    Buffer := TDBByteBuffer.Create(Param.GetDataSize);
                    Param.GetData(Buffer);
                    ExtractedBytes := Buffer.GetBytes;
                    Value.SetDynamicBytes(0, ExtractedBytes, 0, Length(ExtractedBytes));
                  end;
{$ELSE}
// Needed for Spacely to preserve older interface.
// CLR section above will work for both native and managed in Highlander.
//
                  ftBytes, ftVarBytes:
                  begin
                    Buffer := TDBByteBuffer.Create(Param.GetDataSize);
                    CopyParamBytesToByteBuffer(Param, Buffer);
                    ExtractedBytes := Buffer.GetBytes;
                    Value.SetDynamicBytes(0, ExtractedBytes, 0, Length(ExtractedBytes));
                  end;
                  ftBlob, ftGraphic..ftTypedBinary,ftOraBlob,ftOraClob:
                  begin
                     Buffer := TDBByteBuffer.Create(Param.GetDataSize);
                     Buffer.Append(Param.AsString);
                     ExtractedBytes := Buffer.GetBytes;
                     Value.SetDynamicBytes(0, ExtractedBytes, 0, Length(ExtractedBytes));
                  end;
{$IFEND}
                  ftArray, ftDataSet,
                  ftReference, ftCursor: {Nothing};
                  else
                    DatabaseError(Wideformat(SUnknownDataType, [TDBXValueTypeEx.DataTypeName(DataType), ArgDesc.szName]));
              end;
            end;
          end;
        finally
          if Buffer <> nil then
            FreeAndNil(Buffer);
        end;
      end;
  finally
    ArgDesc.Free;
  end;
end;

procedure FreeProcParams(var ProcParams: TList);
var
  ArgParam: SPParamDesc;
  I: Integer;
begin
  if not Assigned(ProcParams) then Exit;
  for I := 0 to ProcParams.Count -1 do
  begin
    ArgParam := SPParamDesc(ProcParams[I]);
    ArgParam.Free;
  end;
  FreeAndNil(ProcParams);
end;

procedure LoadParamListItems(Params: TParams; ProcParams: TList);
var
  I: Integer;
  ArgParam: SPParamDesc;
begin
  for I := 0 to ProcParams.Count -1 do
  begin
    ArgParam := SPParamDesc(ProcParams.Items[I]);
    with TParam(Params.Add) do
    begin
      Name := ArgParam.szName;
      ParamType := ArgParam.iArgType;
      DataType := ArgParam.iDataType;
      NumericScale := ArgParam.iUnits2;
      Precision := ArgParam.iUnits1;
      if ParamType <> ptInput then
        Size := ArgParam.iLen;
    end;
  end;
end;

{ TSQLBlobStream }

constructor TSQLBlobStream.Create(Field: TBlobField; Mode: TBlobStreamMode = bmRead);
begin
  inherited Create;
  if not Field.DataSet.Active then
    DataBaseError(SDatasetClosed);
  FField := Field;
  FDataSet := FField.DataSet as TCustomSQLDataSet;
  FFieldNo := FField.FieldNo;
  ReadBlobData;
end;

destructor TSQLBlobStream.Destroy;
begin
  inherited Destroy;
end;

procedure TSQLBlobStream.ReadBlobData;
var
  BlobLength: Int64;
  Buffer: TValueBuffer;
begin
  Clear;
  BlobLength := GetBlobLength(FDataSet, FFieldNo);
  SetSize(BlobLength);
  if BlobLength = 0 then Exit;
{$IF DEFINED(CLR)}
  Buffer := TPlatformRecordBuffer.CreateRecordBuffer(BlobLength);
  try
    if FDataSet.GetFieldData(FField, Buffer, True) then
    begin
      TPlatformRecordBuffer.Copy(Buffer, FDataSet.FBlobBuffer, 0, FDataSet.FCurrentBlobSize);
      Write(FDataSet.FBlobBuffer, FDataSet.FCurrentBlobSize);
    end;
    Position := 0;
  finally
    TPlatformRecordBuffer.Free(Buffer);
  end;
{$ELSE}
  Buffer := TValueBuffer(FDataSet.FBlobBuffer);
  if FDataSet.GetFieldData(FField, Buffer, True) then
    Write(Buffer^, FDataSet.FCurrentBlobSize);
{$IFEND}

  Position := 0;
end;



type

{ TSQLParams }

  TSQLParams = class(TParams)
  private
    FFieldName: TWideStrings;
    FBindAllFields: Boolean;
    FIdOption: IDENTIFIEROption;
    function ParseSelect(SQL: WideString; bDeleteQuery: Boolean): WideString;
    function ParseUpdate(SQL: WideString): WideString;
    function ParseInsert(SQL: WideString): WideString;
  public
    constructor Create(Owner: TPersistent; IdOption: IDENTIFIEROption);
    Destructor Destroy; override;
    function GetFieldName(index: Integer): WideString;
    function Parse(Var SQL: WideString; DoCreate: Boolean): WideString;
    property BindAllFields: Boolean read FBindAllFields;
  end;

constructor TSQLParams.Create(Owner: TPersistent; IdOption: IDENTIFIEROption);
begin
  inherited Create;
  FBindAllFields := False;
  FFieldName := TWideStringList.Create;
  FIdOption := IdOption;
end;

destructor TSQLParams.Destroy;
begin
  inherited;
  FreeAndNil(FFieldName);
end;

function TSQLParams.GetFieldName(index: Integer): WideString;
begin
   Result := FFieldName[ index ];
end;

function TSQLParams.Parse(var SQL: WideString; DoCreate: Boolean): WideString;
const
  SDelete = 'delete';      { Do not localize }
  SUpdate = 'update';      { Do not localize }
  SInsert = 'insert';      { Do not localize }
var
  Start: string;
begin
  SQL := ParseSQL(SQL, DoCreate);
  Start := WideLowerCase(copy(SQL, 1, 6));
{ attempt to determine fields and fieldtypes associated with params }
  if Start = SSelect then
    Result := ParseSelect(SQL, False)
  else if Start = SDelete then
    Result := ParseSelect(SQL, True)
  else if Start = SInsert then
    Result := ParseInsert(SQL)
  else if Start = SUpdate then
    Result := ParseUpdate(SQL)
  else
    Result := '';
end;

// When DBCommon is single sourced this can be replaced.
//
{$IF DEFINED(CLR)}
function Platform_NextSQLToken(  const SQL:  WideString;
                        var p:      Integer;
                        out Token:  WideString;
                        CurSection: TSQLToken;
                        IdOption: IDENTIFIEROption): TSQLToken;
begin
  Result := NextSQLTokenEx(SQL, p, Token, CurSection, IdOption);
end;
{$ELSE}
function Platform_NextSQLToken(  const SQL:  WideString;
                        var p:      Integer;
                        out Token:  WideString;
                        CurSection: TSQLToken;
                        IdOption: IDENTIFIEROption): TSQLToken;
var
  pSQL:       PWideChar;
  pSQLStart:  PWideChar;
  tempToken:  WideString;
begin
  pSQLStart := PWideChar(SQL);
  pSQL      := pSQLStart + p - 1;
  Result    := NextSQLTokenEx(pSQL, Token, CurSection, IdOption);
  p         := pSQL - pSQLStart + 1;
end;
{$IFEND}

// Remove when System unit is single sourced.
{$IF NOT DEFINED(CLR)}
function PosEx(const substr, str: WideString; Offset: Integer): Integer;
begin
  Result := Pos(substr, WideString(PWideChar(str)+(Offset-1)));
end;
{$IFEND}

// Temporary:
// Move this into ConnectionOptions in the next version.
function GetIdOption(Connection: TSQLConnection): IDENTIFIEROption;
var
  MetaDataEx: TDBXDatabaseMetaDataEx;
begin
  Result := idMixCase;
  if (Assigned(Connection) and (Connection.MetaData is TDBXDatabaseMetaDataEx)) then
  begin
    MetaDataEx := TDBXDatabaseMetaDataEx(Connection.MetaData);
    if MetaDataEx.MetaDataVersion = DBXVersion40 then
    begin
      if not MetaDataEx.SupportsLowerCaseIdentifiers then
        Result := idMakeUpperCase
      else if not MetaDataEx.SupportsUpperCaseIdentifiers then
        Result := idMakeLowerCase;
    end;
  end;
end;

{ no attempt to match fields clause with values clause :
    types only added if all values are inserted }
function TSQLParams.ParseInsert(SQL: WideString): WideString;
var
  Start: Integer;
  Value: WideString;
  CurSection: TSQLToken;
begin
  Result := '';
  if ((Owner <> nil) and (Owner is TCustomSqlDataSet) and Assigned(TCustomSqlDataSet(Owner).ParseInsertSql)) then
    TCustomSqlDataSet(Owner).ParseInsertSql(FFieldName, SQL, FBindAllFields, Result)
  else
  begin
    if Pos(SSelectSpaces, LowerCase(SQL)) > 1 then Exit;  // can't parse sub queries
    Start := 1;
    CurSection := stUnknown;
    { move past 'insert ' }
    Platform_NextSQLToken(SQL, Start, Value, CurSection, FIdOption);
    { move past 'into ' }
    Platform_NextSQLToken(SQL, Start, Value, CurSection, FIdOption);
    { move past <TableName> }
    Platform_NextSQLToken(SQL, Start, Value, CurSection, FIdOption);

    { Check for owner qualified table name }
    if (Start <= Length(SQL)) and (SQL[Start] = '.') then
      Platform_NextSQLToken(SQL, Start, Value, CurSection, FIdOption);
    Result := Value;

    { move past 'set' }
    Platform_NextSQLToken(SQL, Start, Value, CurSection, FIdOption);
    if (LowerCase(Value) = 'values') then
      FBindAllFields := True;
  end;
end;

function TSQLParams.ParseSelect(SQL: WideString; bDeleteQuery: Boolean): WideString;
var
  FWhereFound: Boolean;
  bParsed: Boolean;
  Start: Integer;
  FName, Value: WideString;
  SQLToken, CurSection, LastToken: TSQLToken;
  Params: Integer;
begin
  Result := '';
  bParsed := False;
  if ((Owner <> nil) and (Owner is TCustomSqlDataSet)) then
  begin
    if (not bDeleteQuery) and Assigned(TCustomSqlDataSet(Owner).ParseSelectSql) then
    begin
      TCustomSqlDataSet(Owner).ParseSelectSql(FFieldName, SQL, Result);
      bParsed := True;
    end else if bDeleteQuery and Assigned(TCustomSqlDataSet(Owner).ParseDeleteSql) then
    begin
      TCustomSqlDataSet(Owner).ParseDeleteSql(FFieldName, SQL, Result);
      bParsed := True;
    end;
  end;
  if not bParsed then
  begin
    if bDeleteQuery = False then
    begin
      if PosEx(SSelectSpaces, WideLowerCase(SQL), 9) > 1 then Exit;  // can't parse sub queries
    end else
    begin
      if Pos(SSelectSpaces, WideLowerCase(SQL)) > 1 then Exit;  // can't parse sub queries
      SQL := SSelectStar + Copy(SQL, 8, Length(SQL) -7);
    end;
    Start := 1;
    CurSection := stUnknown;
    LastToken := stUnknown;
    FWhereFound := False;
    Params := 0;
    repeat
      repeat
        SQLToken := Platform_NextSQLToken(SQL, Start, FName, CurSection, FIdOption);
        if SQLToken = stWhere then
        begin
          FWhereFound := True;
          LastToken := stWhere;
        end else if SQLToken = stTableName then
        begin
          { Check for owner qualified table name }
          if (Start <= Length(SQL)) and (SQL[Start] = '.') then
            Platform_NextSQLToken(SQL, Start, FName, CurSection, FIdOption);
          Result := FName;
        end else if (SQLToken = stValue) and (LastToken = stWhere) then
          SQLToken := stFieldName;
        if SQLToken in SQLSections then
          CurSection := SQLToken;
      until SQLToken in [stFieldName, stEnd];
      if FWhereFound and (SQLToken = stFieldName) then
        repeat
          SQLToken := Platform_NextSQLToken(SQL, Start, Value, CurSection, FIdOption);
          if SQLToken in SQLSections then
            CurSection := SQLToken;
        until SQLToken in [stEnd,stValue,stIsNull,stIsNotNull,stFieldName];
      if Value='?' then
      begin
        FFieldName.Add(FName);
        Inc(Params);
      end;
    until (Params = Count) or (SQLToken = stEnd);
    if Result = '' then Result := GetTableNameFromSQLEx(SQL,FIdOption);
  end;
end;

function TSQLParams.ParseUpdate(SQL: WideString): WideString;
var
  Start: Integer;
  FName, Value: WideString;
  SQLToken, CurSection: TSQLToken;
  Params: Integer;
begin
  Result := '';
  if ((Owner <> nil) and (Owner is TCustomSqlDataSet) and Assigned(TCustomSqlDataSet(Owner).ParseUpdateSql)) then
    TCustomSqlDataSet(Owner).ParseUpdateSql(FFieldName, SQL, Result)
  else
  begin
    if Pos(SSelectSpaces, LowerCase(SQL)) > 1 then Exit;  // can't parse sub queries
    Start := 1;
    CurSection := stUnknown;
    { move past 'update ' }
    Platform_NextSQLToken(SQL, Start, FName, CurSection, FIdOption);
    { move past <TableName> }
    Platform_NextSQLToken(SQL, Start, FName, CurSection, FIdOption);

    { Check for owner qualified table name }
    if (Start <= Length(SQL)) and (SQL[Start] = '.') then
      Platform_NextSQLToken(SQL, Start, FName, CurSection, FIdOption);

    Result := FName;
    { move past 'set ' }
    Platform_NextSQLToken(SQL, Start, FName, CurSection, FIdOption);
    Params := 0;
    CurSection := stSelect;
    repeat
      repeat
        SQLToken := Platform_NextSQLToken(SQL, Start, FName, CurSection, FIdOption);
        if SQLToken in SQLSections then CurSection := SQLToken;
      until SQLToken in [stFieldName, stEnd];
      if Pos(LowerCase(FName), 'values(') > 0 then continue;   { do not localize }
      if Pos(LowerCase(FName), 'values (') > 0 then continue;  { do not localize }
      if SQLToken = stFieldName then
        repeat
          SQLToken := Platform_NextSQLToken(SQL, Start, Value, CurSection, FIdOption);
            if SQLToken in SQLSections then CurSection := SQLToken;
        until SQLToken in [stEnd,stValue,stIsNull,stIsNotNull,stFieldName];
      if Value='?' then
      begin
        FFieldName.Add(FName);
        Inc(Params);
      end;
    until (Params = Count) or (SQLToken = stEnd);
  end;
end;

{ TSQLMonitor }

constructor TSQLMonitor.Create(AOwner: TComponent);
begin
  FTraceList := TWideStringList.Create;
  FMaxTraceCount := -1;
  inherited;
end;

destructor TSQLMonitor.Destroy;
begin
  if Active then SetActive(False);
  SetSQLConnection(nil);
  inherited;
  FreeAndNil(FTraceList);
end;

procedure TSQLMonitor.SetFileName(const Value: String);
begin
  FFileName := Value;
end;

procedure TSQLMonitor.CheckInactive;
begin
  if FActive then
  begin
    if (csDesigning in ComponentState) or (csLoading in ComponentState) then
      SetActive(False)
    else
      DatabaseError(SMonitorActive, Self);
  end;
end;

procedure TSQLMonitor.SetSQLConnection(Value: TSQLConnection);
var
  IsActive: Boolean;
begin
  if Value <> FSQLConnection then
  begin
    IsActive := Active;
    CheckInactive;
    if Assigned(FSQLConnection) and not FKeepConnection then
      SQLConnection.UnregisterTraceMonitor(Self);
    FSQLConnection := Value;
    if Assigned(FSQLConnection) then
    begin
      FSQLConnection.RegisterTraceMonitor(Self);
      Active := IsActive;
    end;
  end;
end;

procedure TSQLMonitor.SwitchConnection(const Value: TSQLConnection);
var
  MonitorActive: Boolean;
begin
  FKeepConnection := True;
  MonitorActive := Active;
  if MonitorActive then
    SetActive(False);
  SQLConnection := Value;
  if MonitorActive and Assigned(Value) then
    SetActive(True);
  FKeepConnection := False;
end;

procedure TSQLMonitor.Trace(TraceInfo: TDBXTraceInfo; LogTrace: Boolean);
begin
  if Assigned(FOnTrace) then
    FOnTrace(Self, TraceInfo, LogTrace);
end;

function TSQLMonitor.InvokeCallBack(TraceInfo: TDBXTraceInfo): CBRType;
var
  LogTrace: Boolean;
  Msg: WideString;
begin
  Result := cbrUSEDEF;
  if csDestroying in ComponentState then exit;
  LogTrace := (TraceInfo.TraceFlag and FTraceFlags) = 0;
  Trace(TraceInfo, LogTrace);
  if LogTrace then
  begin
    Msg := TraceInfo.Message;
    if (FMaxTraceCount = -1) or (TraceCount < FMaxTraceCount) then
      FTraceList.Add(Msg);
    if Assigned(FOnLogTrace) then
      FOnLogTrace(Self, TraceInfo);
    if FAutoSave and (FFileName <> '') then
      SaveToFile('');
  end;
end;


procedure TSQLMonitor.UpdateTraceCallBack;
begin
  if Assigned(FSQLConnection) then
  begin
    if Assigned(FSQLConnection.DBXConnection) then
    begin
      FSQLConnection.SetTraceEvent(InvokeCallback);
    end
    else
      FSQLConnection.SetTraceEvent(nil);
  end;
end;

procedure TSQLMonitor.SetActive(Value: Boolean);
var
{$IF DEFINED(CLR)}
  FileHandle: TOpenedFile;
{$ELSE}
  FileHandle: Integer;
{$IFEND}
begin
  if FActive <> Value then
  begin
    if (csReading in ComponentState) then
      FStreamedActive := Value
    else begin
      if not (csDestroying in ComponentState) and not Assigned(FSQLConnection) then
        DatabaseError(SConnectionNameMissing)
      else
      begin
        if Value and (FileName <> '') then
        begin
          if not FileExists(FileName) then
          begin
            FileHandle := FileCreate(FileName);
{$IF DEFINED(CLR)}
            if FileHandle = nil then
{$ELSE}
            if FileHandle = -1 then
{$IFEND}
              DatabaseErrorFmt(SCannotCreateFile, [FileName])
            else
              FileClose(FileHandle);
          end;
        end;
        if Assigned(FSQLConnection) then
        begin
          if Value then
            UpdateTraceCallBack
          else
            FSQLConnection.SetTraceEvent(nil);
        end;
        FActive := Value;
      end;
    end;
  end;
end;

procedure TSQLMonitor.SetStreamedActive;
begin
  if FStreamedActive then
    SetActive(True);
end;

function TSQLMonitor.GetTraceCount: Integer;
begin
  Result := FTraceList.Count;
end;

procedure TSQLMonitor.LoadFromFile(AFileName: string);
begin
  if AFileName <> '' then
    FTraceList.LoadFromFile(AFileName)
  else if FFileName <> '' then
    FTraceList.LoadFromFile(string(FFileName))
  else
    DatabaseError(SFileNameBlank);
end;

procedure TSQLMonitor.SaveToFile(AFileName: string);
begin
  if AFileName <> '' then
    FTraceList.SaveToFile(AFileName)
  else if FFileName <> '' then
    FTraceList.SaveToFile(FFileName)
  else
    DatabaseError(SFileNameBlank);
end;

procedure TSQLMonitor.SetTraceList(Value: TWideStrings);
begin
  if FTraceList <> Value then
  begin
    FTraceList.BeginUpdate;
    try
      FTraceList.Assign(Value);
    finally
      FTraceList.EndUpdate;
    end;
  end;
end;


{ TSQLConnection }

constructor TSQLConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParams := TWideStringList.Create;
  FAutoClone := True;
  try
    FConnectionRegistryFile := GetConnectionRegistryFile(csDesigning in ComponentState);
  except
    FConnectionRegistryFile := '';
  end;
  FKeepConnection := True;
  FMonitorUsers := TList.Create;
  FSQLHourGlass := True;
  FQuoteChar := '';
  FProcedureQuoteChar := '';
  FTableScope := [tsTable, tsView];
  LoginPrompt := True;
  FLoginUserName := '';
  FDBXConnection := Nil; { TODO -oTArisawa : Is it need? }
end;

destructor TSQLConnection.Destroy;
begin
//  FreeAndNil(FLastError);
  Destroying;
  ClearConnectionUsers;
  Close;
  ClearMonitors;
  FreeAndNil(FMonitorUsers);
  if Assigned(FDBXConnection) then
    FreeAndNil(FDBXConnection);
  inherited Destroy;
  FreeAndNil(FParams);
end;

{ user registration }

procedure TSQLConnection.ClearConnectionUsers;
begin
  while DataSetCount > 0 do
  begin
    if TCustomSQLDataSet(DataSets[0]).Active then
      TCustomSQLDataSet(DataSets[0]).Close;
    TCustomSQLDataSet(DataSets[0]).FreeCommand;
    TCustomSQLDataSet(DataSets[0]).SetConnection(nil);
  end;
end;

procedure TSQLConnection.ClearMonitors;
var
  I: Integer;
begin
  for I := 0 to FMonitorUsers.Count -1 do
  begin
    if Self.FIsCloned then
      TSQLMonitor(FMonitorUsers[I]).SwitchConnection(Self.FCloneParent)
    else
    begin
      TSQLMonitor(FMonitorUsers[I]).SetActive(False);
      TSQLMonitor(FMonitorUsers[I]).FSQLConnection := nil;
    end;
  end;
end;

procedure TSQLConnection.RegisterTraceMonitor(Client: TObject);
begin
  FMonitorUsers.Add(Client);
end;

procedure TSQLConnection.UnRegisterClient(Client: TObject);
begin
  inherited;

end;

procedure TSQLConnection.UnregisterTraceMonitor(Client: TObject);
begin
  FMonitorUsers.Remove(Client);
end;

{ Driver Exception handling routine }
const
  DbxError : array[0..28] of String = (SqlConst.SNOERROR, SqlConst.SWARNING,
      SqlConst.SNOMEMORY, SqlConst.SINVALIDFLDTYPE, SqlConst.SINVALIDHNDL,
      SqlConst.SNOTSUPPORTED, SqlConst.SINVALIDTIME, SqlConst.SINVALIDXLATION,
      SqlConst.SOUTOFRANGE, SqlConst.SINVALIDPARAM, SqlConst.SEOF,
      SqlConst.SSQLPARAMNOTSET, SqlConst.SINVALIDUSRPASS, SqlConst.SINVALIDPRECISION,
      SqlConst.SINVALIDLEN, SqlConst.SINVALIDXISOLEVEL, SqlConst.SINVALIDTXNID,
      SqlConst.SDUPLICATETXNID, SqlConst.SDRIVERRESTRICTED, SqlConst.SLOCALTRANSACTIVE,
      SqlConst.SMULTIPLETRANSNOTENABLED, SqlConst.SCONNECTIONFAILED,
      SqlConst.SDRIVERINITFAILED, SqlConst.SOPTLOCKFAILED, SqlConst.SINVALIDREF,
      SqlConst.SNOTABLE, SqlConst.SMISSINGPARAMINSQL, SqlConst.SNOTIMPLEMENTED,
      SqlConst.SDRIVERINCOMPATIBLE);


procedure TSQLConnection.SQLError(Error: TDBXError);
var
  dbxErrorMsg, ServerErrorMsg, ExceptionMessage: string;
  ServerMessage: WideString;
  Status: TDBXErrorCode;
  ErrorStatus: TDBXErrorCode;
begin
  dbxErrorMsg := '';
  ServerErrorMsg := '';
  ExceptionMessage := '';
  Status := TDBXErrorCodes.NoData;
  ErrorStatus := Error.ErrorCode;
  if (ErrorStatus > TDBXErrorCodes.None) and (ErrorStatus <=  TDBXErrorCodes.MaxCommonErrors) then
  begin
    if ErrorStatus = TDBXErrorCodes.NoData then dbxErrorMsg := Format(SDBXError, [SqlConst.SNODATA])
    else if ErrorStatus = TDBXErrorCodes.VendorError then dbxErrorMsg := Format(SDBXError, [SqlConst.SSQLERROR])
    else dbxErrorMsg := Format(SDBXError, [DbxError[Integer(ErrorStatus)]]);
  end;

  ServerMessage := Error.Message;

  if Length(ServerMessage) > 0 then
    ServerErrorMsg := WideFormat(SSQLServerError, [ServerMessage]);

  if Length(dbxErrorMsg) > 0 then
    ExceptionMessage := dbxErrorMsg;
  if Length(ServerErrorMsg) > 0 then
  begin
    if Length(ExceptionMessage) > 0 then
      ExceptionMessage := ExceptionMessage + #13 + #10;
    ExceptionMessage := ExceptionMessage + ServerErrorMsg;
  end;
//  if (Length(ExceptionMessage) = 0) and (LastError <> nil) then
//    ExceptionMessage := LastError.Message;
  if Length(ExceptionMessage) = 0 then
    ExceptionMessage :=  Format(SDBXUNKNOWNERROR, [intToStr(Integer(ErrorStatus))]);
//  if FLastError <> Error then
//  begin
//    FreeAndNil(FLastError);
//    FLastError := Error;
//  end;
  FreeAndNil(Error);
  DatabaseError(ExceptionMessage);
end;


procedure TSQLConnection.CheckConnection(eFlag: eConnectFlag);
begin
  if (eFlag in [eDisconnect, eReconnect]) then
    Close;
  if (eFlag in [eConnect, eReconnect]) then
    Open
end;

procedure TSQLConnection.Login(ConnectionProps: TWideStrings);
var
  UserName, Password: string;

  function Login: Boolean;
  begin
    Result := Assigned(FOnLogin);
    if Result then FOnLogin(Self, ConnectionProps);
  end;

begin
  if not Login then
  begin
    UserName := ConnectionProps.Values[TDBXPropertyNames.UserName];
    if Assigned(LoginDialogExProc) then
    begin
      SetCursor(DefaultCursor);
      if not LoginDialogExProc(ConnectionName, UserName, Password, False) then
        DatabaseErrorFmt(SLoginError, [ConnectionName]);
      SetCursor(HourGlassCursor);
      ConnectionProps.Values[TDBXPropertyNames.UserName] := UserName;
      ConnectionProps.Values[szPASSWORD] := Password;
    end;
  end;
end;

procedure TSQLConnection.CheckLoginParams;
var
  I: Integer;
begin
  if FLoadParamsOnConnect then
  begin
    LoadParamsFromIniFile;
    FDriverName := GetProfileString(FConnectionName, DRIVERNAME_KEY, ConnectionRegistryFile);
  end;
  if FDriverName = '' then DataBaseError(SMissingDriverName);
  if LoadParamsOnConnect then
    FLibraryName := Trim(GetProfileString(FDriverName, DLLLIB_KEY, GetDriverRegistryFile(csDesigning in ComponentState)));
//  if FLibraryName = '' then DataBaseError(SMissingDLLName, Self);
  if LoadParamsOnConnect then
    FVendorLib := Trim(GetProfileString(FDriverName, VENDORLIB_KEY, GetDriverRegistryFile));
//  if FVendorLib = '' then DataBaseError(SMissingDLLName, Self);
  if LoadParamsOnConnect then
    FGetDriverFunc := Trim(GetProfileString(FDriverName, GETDRIVERFUNC_KEY, GetDriverRegistryFile));
  if Params.Values[DATABASENAME_KEY] = '' then
  begin
    if FConnectionName = '' then DataBaseError(SConnectionNameMissing)
    else DataBaseError(SMissingDatabaseName);
  end;
  for I := 0 to FMonitorUsers.Count -1 do
    TSQLMonitor(FMonitorUsers[i]).SetStreamedActive;
end;

function TSQLConnection.GetQuoteChar: WideString;
begin
  Result := FMetaData.QuoteChar;
  FQuoteChar := Result;
end;

procedure TSQLConnection.SetCursor(CursorType: Integer);
begin
  if SQLHourGlass or (CursorType = DefaultCursor) then
    if Assigned(ScreenCursorProc) then
      ScreenCursorProc(CursorType);
end;

procedure TSQLConnection.ConnectionOptions;
begin
  FQuoteChar              := GetQuoteChar;
  FProcedureQuoteChar     := FMetaData.ProcedureQuoteChar;
  FTransactionsSupported  := FMetaData.SupportsTransactions;
  FSupportsNestedTrans    := FMetaData.SupportsNestedTransactions;
  FMaxStmtsPerConn        := FMetaData.MaxCommands;
end;

const
  ProductVersionStr = '3.0';

procedure TSQLConnection.DoConnect;
var
  Status: TDBXErrorCode;
  ConnectionProps: TDBXProperties;
  PropSize: SmallInt;
  TrimmedUserName: WideString;
  DrvVersionStr: string;
  str: WideString;
  ind: integer;
  ConnectionStr: WideString;
  ConnectionFactory: TDBXConnectionFactory;
  IniFileConnectionFactory: TDBXIniFileConnectionFactory;
  STransIsolationKey: WideString;
  LoginParams: TWideStrings;
  SchemaOverride: WideString;
  SchemaOverRideList: TWideStringList;
  Password: WideString;
  MemoryConnectionFactory: TDBXMemoryConnectionFactory;
begin
  ConnectionProps   := nil;
  ConnectionFactory := nil;
  LoginParams := TWideStringList.Create;
  MemoryConnectionFactory := nil;
  try
//    if FConnectionFactory = nil then
//    begin
      if LoadParamsOnConnect then
      begin
        ConnectionFactory := TDBXConnectionFactory.GetConnectionFactory;
        ConnectionProps   := ConnectionFactory.GetConnectionProperties(ConnectionName);
        ConnectionProps   := ConnectionProps.Clone;
      end else
      begin
        ConnectionProps   := TDBXProperties.Create;
        try
          ConnectionFactory := TDBXConnectionFactory.GetConnectionFactory;
        except
          MemoryConnectionFactory := TDBXMemoryConnectionFactory.Create;
          ConnectionFactory := MemoryConnectionFactory;
          ConnectionFactory.Open;
        end;
        ConnectionProps.AddProperties(FParams);
        ConnectionProps.Add(TDBXPropertyNames.VendorLib, VendorLib);
        ConnectionProps.Add(TDBXPropertyNames.LibraryName, LibraryName);
        ConnectionProps.Add(TDBXPropertyNames.GetDriverFunc, GetDriverFunc);
      end;
      CheckLoginParams;
    ConnectionState := csStateConnecting;

    GetLoginParams(LoginParams);
    if LoginParams.Values[TDBXPropertyNames.Database] <> ConnectionProps[TDBXPropertyNames.Database] then
    begin
      ConnectionProps[TDBXPropertyNames.Database] := LoginParams.Values[TDBXPropertyNames.Database];
    end;

    SetCursor(HourGlassCursor);

{$IF DEFINED(CLR)}
    ConnectionProps.Add('UNLICENSED_DRIVERS', IntToStr(0)); // Do not translate.
{$ELSE}
    ConnectionProps.Add('UNLICENSED_DRIVERS', IntToStr(GDAL)); // Do not translate.
{$IFEND}

    FLoginUsername := LoginParams.Values[TDBXPropertyNames.UserName];
    if FLoginUserName <> '' then
      ConnectionProps[TDBXPropertyNames.UserName] := FLoginUsername;
    Password := LoginParams.Values[TDBXPropertyNames.Password];
    if Password <> '' then
      ConnectionProps[TDBXPropertyNames.Password] := Password;

    FDBXConnection := ConnectionFactory.GetConnection(ConnectionProps);
//    FDBXConnection.OnErrorEvent := SQLError;

    for ind := 0 to FMonitorUsers.Count -1 do
      TSQLMonitor(FMonitorUsers[ind]).UpdateTraceCallBack;

    SetCursor(HourGlassCursor);

    RegisterTraceCallback(True);

    FMetaData := FDBXConnection.DatabaseMetaData;

    FDefaultSchema := '';

    if (FDBXConnection is TDBXConnectionEx)
        and (TDBXConnectionEx(FDBXConnection).ProductName = 'BlackfishSQL') then {Do not localize}
    begin
      FDefaultSchema := 'DEFAULT_SCHEMA'; { Do not localize }
    end;

    SchemaOverride := ConnectionProps[TDBXPropertyNames.SchemaOverride];

    if (SchemaOverride = '') and LoadParamsOnConnect then
    begin
      SchemaOverride := ConnectionFactory.GetDriverProperties(ConnectionProps[TDBXPropertyNames.DriverName])
                        [TDBXPropertyNames.SchemaOverride];
    end;


    if SchemaOverride <> '' then
    begin
      SchemaOverRideList := TWideStringList.Create;
      try
        SchemaOverRideList.Delimiter := '.';
        SchemaOverRideList.DelimitedText := SchemaOverride;
        if SchemaOverRideList.Count = 2 then
        begin
          if (SchemaOverrideList[0] = '%') or (SchemaOverrideList[0] = FLoginUsername) then
            FDefaultSchema := SchemaOverrideList[1];
        end;
      finally
        SchemaOverRideList.Free;
      end;
    end;


    ConnectionOptions;

    ConnectionState := csStateOpen;
  finally
    FreeAndNil(MemoryConnectionFactory); // If allocated, free it.
    SetCursor(DefaultCursor);
    LoginParams.Free;
    ConnectionProps.Free;
    if ConnectionState = csStateConnecting then // an exception occurred
    begin
//      if FConnectionFactory = nil then
//        ConnectionFactory.Free;
      ConnectionState := csStateClosed;
      if Assigned(FDBXConnection) then
        FreeAndNil(FDBXConnection)
    end;
  end;
end;

function TSQLConnection.GetLoginUsername : WideString;
begin
  Result := FLoginUserName;
end;

procedure TSQLConnection.GetLoginParams(LoginParams: TWideStrings);
var
  I: Integer;
  PName: string;
begin
  LoginParams.BeginUpdate;
  try
    LoginParams.Clear;
    for I := 0 to FParams.Count - 1 do
      begin
        if LoginParams.IndexOf(FParams[I]) < 0 then
        begin
          PNAME := FParams.Names[I];
          if CompareText(PName, TDBXPropertyNames.Password) = 0 then
             LoginParams.Add(Wideformat('%s=%s',[TDBXPropertyNames.Password, FParams.Values[TDBXPropertyNames.Password] ]))
          else if CompareText(PName, TDBXPropertyNames.UserName) = 0 then
             LoginParams.Add(Wideformat('%s=%s',[TDBXPropertyNames.UserName, FParams.Values[TDBXPropertyNames.UserName]]))
          else if CompareText(PName, TDBXPropertyNames.Database) = 0 then
            LoginParams.Add(Wideformat('%s=%s',[TDBXPropertyNames.Database, trim(FParams.Values[TDBXPropertyNames.Database])]));
        end;
      end;
  finally
    LoginParams.EndUpdate;
  end;
  if LoginPrompt then
     Login(LoginParams);
end;



procedure TSQLConnection.GetCommandTypes(List: TWideStrings);
begin
  FDBXConnection.GetCommandTypes(List);
end;

function TSQLConnection.GetConnected: Boolean;
begin
  Result := Assigned(FDBXConnection) and (not
      (ConnectionState in [csStateClosed, csStateConnecting,
      csStateDisconnecting]));
end;

procedure TSQLConnection.DoDisconnect;
begin
  if FDBXConnection <> nil then
  begin
    ConnectionState := csStateDisconnecting;
    CloseDataSets;
    RegisterTraceCallback(False);
    if (FDBXConnection <> nil) then
    begin
      FTransactionCount := 0;
      FreeAndNil(FDBXConnection)
    end;
    SQLDllHandle := THandle(0);
    ConnectionState := csStateClosed;
    FSelectStatements := 0;
//    FPrevSelectStatements := 0;
  end;
  FParamsLoaded := False;
end;

procedure TSQLConnection.CloseDataSets;
var
  I: Integer;
begin
  for I := 0 to DataSetCount -1 do
  begin
    if TCustomSQLDataSet(DataSets[i]).Active then
      TCustomSQLDataSet(DataSets[i]).Close;
    TCustomSQLDataSet(DataSets[i]).FreeCommand;
  end;
  for I := 0 to FMonitorUsers.Count -1 do
  begin
    if Self.FIsCloned then
      TSQLMonitor(FMonitorUsers[I]).SwitchConnection( Self.FCloneParent );
  end;
end;

procedure TSQLConnection.CheckDisconnect;
var
  I: Integer;
begin
  if Connected and not (KeepConnection or InTransaction or (csLoading in ComponentState)) then
  begin
    for I := 0 to DataSetCount - 1 do
      if (DataSets[I].State <> dsInActive) then Exit;
    Close;
  end;
end;

procedure TSQLConnection.CheckInactive;
begin
  if FDBXConnection <> nil then
    if csDesigning in ComponentState then
      Close
    else
      DatabaseError(SdatabaseOpen, Self);
end;



procedure TSQLConnection.CheckActive;
begin
  if FDBXConnection = nil then DatabaseError(SDatabaseClosed, Self);
end;

{ Query execution }

function TSQLConnection.GetConnectionForStatement: TSQLConnection;
begin
  if (FMaxStmtsPerConn > 0) and (FSelectStatements >= FMaxStmtsPerConn)
       {and (FSelectStatements > FPrevSelectStatements)} and (FSelectStatements > 0)
       and not (FTransactionCount > 0) and AutoClone then
    Result := CloneConnection
  else
    Result := Self;
//    FPrevSelectStatements := FSelectStatements;
end;

function TSQLConnection.ExecuteDirect(const SQL: WideString): Integer;
var
  Command: TDBXCommand;
  Reader: TDBXReader;
  Status: TDBXErrorCode;
  Connection: TSQLConnection;
  RowsetSize: Integer;
  CurSection : TSqlToken;
  Value: WideString;
  Start: Integer;
begin
  CheckConnection(eConnect);
  Reader := nil;
  Result := 0;
  RowsetSize := defaultRowsetSize;
  CurSection := stUnknown;
  Start := 1;
  CurSection := Platform_NextSQLToken(SQL, Start, Value, CurSection, GetIdOption(Self));
  if CurSection = stSelect then
    Inc(FSelectStatements);
  Connection := GetConnectionForStatement;
  Command := Connection.FDBXConnection.CreateCommand;
  Reader := nil;
  try

    if Params.Values[ROWSETSIZE_KEY] <> '' then
    try
      RowsetSize := StrToInt(trim(Params.Values[ROWSETSIZE_KEY]));
    except
      RowsetSize := defaultRowsetSize;
    end;
    if FMetaData.SupportsRowSetSize then
      Command.RowSetSize := RowsetSize;

    Command.Text := SQL;
    Command.Prepare;
    Reader       := Command.ExecuteQuery;
    Result := Integer(Command.RowsAffected);

  finally
    Reader.Free;
    Command.Free;
  end;
end;

function TSQLConnection.Execute(const SQL: WideString; Params: TParams;
  ResultSet: TPSResult = nil): Integer;
var
  Status: TDBXErrorCode;
  SQLText: WideString;
  RowsAffected: LongWord;
  DS: TCustomSQLDataSet;
  I, ParamCount: Integer;
begin
  Result := 0;
  DS := TCustomSQLDataSet.Create(nil);
  try
    CheckConnection(eConnect);
    SetCursor(HourGlassCursor);
    DS.SQLConnection := Self;
    ConnectionState := csStateExecuting;
    if (Params <> nil) and (Params.Count > 0) then
    begin
      SQLText := FixParams(SQL, Params.Count, Self.GetQuoteChar);
      ParamCount := Params.Count;
    end else
    begin
      SQLText := Copy(SQL, 1, Length(SQL));
      ParamCount := 0;
    end;
    DS.FCommandText := SQLText;
    if ResultSet = nil then
    begin
      DS.CheckStatement;
      with DS.FDBXCommand do
      begin
        Text := SQLText;
        if Params <> nil then
          Parameters.SetCount(Params.Count);
        Prepare;
        if ParamCount > 0 then
          SetQueryProcParams(Self, DS.FDBXCommand, Params);
        DS.FDBXReader :=  ExecuteQuery;
        Result := RowsAffected;
      end;
    end else
    begin
      if ParamCount > 0 then
      begin
        for I := 0 to ParamCount -1 do
        begin
          DS.Params.CreateParam(Params.Items[I].DataType, format('P%d',[I+1]), ptInput);
          DS.Params[I].Value := Params[I].Value;
        end;
      end;
      DS.MaxBlobSize := DefaultMaxBlobSize;
      DS.Active := True;
    end;
  finally
    SetCursor(DefaultCursor);
    if ResultSet = nil then
      DS.Free
    else
      TPlatformPSResult.SetPSResult(ResultSet, DS);
    ConnectionState := csStateOpen;
  end;
end;

{ Metadata retrieval }

function TSQLConnection.CloneConnection: TSQLConnection;
var
  SelfParent: TSQLConnection;
  I: Integer;
  Status: TDBXErrorCode;
  buf : WideString;
  Len : smallint;
begin      // do not allow nested clones
  if Self.FIsCloned then
    SelfParent := Self.FCloneParent
  else
    SelfParent := Self;
  Result := TSQLConnection.Create(nil);
  Result.FIsCloned := True;
  Result.FLoadParamsOnConnect := FLoadParamsOnConnect;
  Result.LoginPrompt := False;
  Result.FDriverName := SelfParent.FDriverName;
  Result.FConnectionName := SelfParent.FConnectionName;
  Result.Name := SelfParent.Name + 'Clone1';
  Result.FParams.AddStrings(SelfParent.FParams);
  Result.FGetDriverFunc := SelfParent.FGetDriverFunc;
  Result.FLibraryName := SelfParent.FLibraryName;
  Result.FVendorLib := SelfParent.VendorLib;

  // This getter is not implemented in any of our dbx drivers.
//  Len := 0;
//  Status := FDBXConnection.getOption(eConnConnectionString, nil, 0, Len); // Len is number of byte.
//  if (Status <> 0) or (Len <= 0) then
//    Len := 1024;
//  SetLength(buf, Len div sizeof(WideChar));
//  FillChar(buf[1], Len div sizeof(WideChar), #0);
//  Status := FDBXConnection.getStringOption(eConnConnectionString, buf);
//  if Status = 0 then
//    Result.Params.Values[CONNECTION_STRING] := PWideChar(buf);

//  Result.FConnectionFactory := SelfParent.FConnectionFactory;
  Result.FTableScope := SelfParent.TableScope;
  for I := 0 to FMonitorUsers.Count -1 do
    TSQLMonitor(FMonitorUsers[I]).SwitchConnection( Result );
  Result.Connected := Self.Connected;
  Result.FCloneParent := SelfParent;
end;

function TSQLConnection.OpenSchemaTable(eKind: TSchemaType; SInfo: WideString; SQualifier: WideString = ''; SPackage: WideString = ''): TCustomSQLDataSet;
begin
  Result := OpenSchemaTable(eKind, SInfo, SQualifier, SPackage , '');
end;

function TSQLConnection.OpenSchemaTable(eKind: TSchemaType; SInfo: WideString; SQualifier: WideString = ''; SPackage: WideString = ''; SSchemaName: WideString = ''): TCustomSQLDataSet;
var
  DataSet: TCustomSQLDataSet;
begin
  CheckConnection(eConnect);
  DataSet := TCustomSQLDataSet.Create(nil);
  Result := nil;
  try
    Inc(FSelectStatements);
    DataSet.SetConnection(Self);
    DataSet.SetSchemaInfo(eKind, SInfo, SQualifier, SPackage);
    DataSet.SchemaName := SSchemaName;
    DataSet.Active := True;
    Result := DataSet;
  finally
    if Result = nil then
      FreeSchemaTable(DataSet);
  end;
end;

procedure TSQLConnection.FreeSchemaTable(DataSet: TCustomSQLDataSet);
var
  SaveKeepConnection: Boolean;
begin
//  if Assigned(Dataset) then
//    FreeAndNil(DataSet.FClonedConnection);
  Dec(FSelectStatements);
  SaveKeepConnection := FKeepConnection;
  FKeepConnection := True;
  if Assigned(Dataset) then
    DataSet.Free;
  FKeepConnection := SaveKeepConnection;
end;

procedure TSQLConnection.OpenSchema(eKind: TSchemaType; sInfo: WideString; List: TWideStrings);
begin
  OpenSchema(eKind, sInfo, '', List);
end;

//const
//  TBL_NAME_FIELD = 'TABLE_NAME';           { Do not localize }
//  PROC_NAME_FIELD = 'PROC_NAME';           { Do not localize }
//  COL_NAME_FIELD = 'COLUMN_NAME';          { Do not localize }
//  IDX_NAME_FIELD = 'INDEX_NAME';           { Do not localize }
//  OBJECT_NAME_FIELD = 'OBJECT_NAME';      { Do not localize }

function GetTableFieldName(SqlConnection: TSQLConnection): String;
var
  MetaData: TDBXDatabaseMetaData;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Result := 'TableName'
  else
    Result := 'TABLE_NAME';
end;
function GetProcedureFieldName(SqlConnection: TSQLConnection): String;
var
  MetaData: TDBXDatabaseMetaData;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Result := 'ProcedureName'
  else
    Result := 'PROC_NAME';
end;
function GetColumnFieldName(SqlConnection: TSQLConnection): String;
var
  MetaData: TDBXDatabaseMetaData;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Result := 'ColumnName'
  else
    Result := 'COLUMN_NAME';
end;
function GetIndexFieldName(SqlConnection: TSQLConnection): String;
var
  MetaData: TDBXDatabaseMetaData;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Result := 'IndexName'
  else
    Result := 'INDEX_NAME';
end;
function GetSchemaFieldName(SqlConnection: TSQLConnection): String;
var
  MetaData: TDBXDatabaseMetaData;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Result := 'SchemaName'
  else
    Result := 'OBJECT_NAME';
end;
function GetPackageFieldName(SqlConnection: TSQLConnection): String;
var
  MetaData: TDBXDatabaseMetaData;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Result := 'PackageName'
  else
    Result := 'OBJECT_NAME';
end;
function IsResultSetParameterType(SqlConnection: TSQLConnection; DataSet: TCustomSQLDataSet): Boolean;
var
  MetaData: TDBXDatabaseMetaData;
  Mode: WideString;
begin
  Result := False;
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
  begin
    Mode := TPlatformField.AsWideString(DataSet.FieldByName('ParameterMode'));
    Result := (Mode = 'RESULT');
  end;
end;
function GetParameterType(SqlConnection: TSQLConnection; DataSet: TCustomSQLDataSet; V:Variant): TParamType;
var
  MetaData: TDBXDatabaseMetaData;
  Mode: WideString;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
  begin
    Mode := TPlatformField.AsWideString(DataSet.FieldByName('ParameterMode'));
    if Mode = 'IN' then
      Result := ptInput
    else if Mode = 'OUT' then
      Result := ptOutput
    else if Mode = 'INOUT' then
      Result := ptInputOutput
    else if Mode = 'RETURN' then
      Result := ptResult
    else
      Result := ptUnknown;
  end
  else
  begin
    V := DataSet.FieldByName('PARAM_TYPE').Value;
    if VarIsNull(V) then
      Result := ptUnknown
    else
      Result := TParamType(Integer(V));
  end;
end;
function GetParameterDataTypeFieldName(SqlConnection: TSQLConnection): String;
var
  MetaData: TDBXDatabaseMetaData;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Result := 'DbxDataType'         { do not localize }
  else
    Result := 'PARAM_DATATYPE';     { do not localize }
end;
function IsParameterFixedStringType(SqlConnection: TSQLConnection; DataSet: TCustomSQLDataSet; V:Variant): Boolean;
var
  MetaData: TDBXDatabaseMetaData;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
  begin
    V := DataSet.FieldByName('IsFixedLength').Value;
    if VarIsNull(V) then
      Result := False
    else
      Result := Boolean(V);
  end
  else
  begin
    V := DataSet.FieldByName('PARAM_SUBTYPE').Value;
    if VarIsNull(V) then
      Result := False
    else
      Result := (V = TDBXDataTypes.FixedSubType);
  end;
end;
function GetParameterPositionFieldName(SqlConnection: TSQLConnection): String;
var
  MetaData: TDBXDatabaseMetaData;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Result := 'Ordinal'                  { do not localize }
  else
    Result := 'PARAM_POSITION';          { do not localize }
end;
function GetParameterPrecisionFieldName(SqlConnection: TSQLConnection): String;
var
  MetaData: TDBXDatabaseMetaData;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Result := 'Precision'          { do not localize }
  else
    Result := 'PARAM_PRECISION';   { do not localize }
end;
function GetParameterScaleFieldName(SqlConnection: TSQLConnection): String;
var
  MetaData: TDBXDatabaseMetaData;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Result := 'Scale'                  { do not localize }
  else
    Result := 'PARAM_SCALE';           { do not localize }
end;
function GetParameterLengthFieldName(SqlConnection: TSQLConnection): String;
var
  MetaData: TDBXDatabaseMetaData;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Result := 'Precision'             { do not localize }
  else
    Result := 'PARAM_LENGTH';         { do not localize }
end;
function GetParameterNameFieldName(SqlConnection: TSQLConnection): String;
var
  MetaData: TDBXDatabaseMetaData;
begin
  MetaData := SqlConnection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Result := 'ParameterName'      { do not localize }
  else
    Result := 'PARAM_NAME';        { do not localize }
end;
//  SubTypeFieldName = 'PARAM_SUBTYPE';       { do not localize }

procedure TSQLConnection.OpenSchema(eKind: TSchemaType; sInfo, SSchemaName: WideString; List: TWideStrings);
var
  DataSet: TCustomSQLDataSet;
  NameField: TField;
  PackageName : WideString;
  ISList: TWideStringList;

begin
  CheckConnection(eConnect);
  if FDBXConnection = nil then
    DatabaseError(sConnectionNameMissing);
  DataSet := nil;
  NameField := nil;
  if eKind = stProcedures then
    PackageName := sInfo;
  CheckActive;
  SetCursor(HourGlassCursor);
  try
    DataSet := OpenSchemaTable(eKind, sInfo, '', PackageName, SSchemaName);
    if Assigned(DataSet) then
    begin
      case eKind of
        stColumns:
          NameField := DataSet.FieldByName(GetColumnFieldName(Self));
        stProcedures:
          begin
            if not Assigned(DataSet) then DatabaseErrorFmt(SStoredProcsNotSupported, [FDriverName]);
            NameField := DataSet.FieldByName(GetProcedureFieldName(Self));
          end;
        stPackages:
          begin
            if not Assigned(DataSet) then DatabaseErrorFmt(SPackagesNotSupported, [FDriverName]);
            NameField := DataSet.FieldByName(GetPackageFieldName(Self));
          end;
        stIndexes:
          NameField := DataSet.FieldByName(GetIndexFieldName(Self));
        stTables, stSysTables:
          NameField := DataSet.FieldByName(GetTableFieldName(Self));
        stUserNames:
          NameField := DataSet.FieldByName(GetSchemaFieldName(Self));
      end;
      if (not DataSet.Eof) then
      begin
        ISList:= TWideStringList.Create;
        try
          try
            ISList.BeginUpdate;
            ISList.Duplicates := dupIgnore;
            ISList.CaseSensitive := False;
            while not DataSet.Eof do
            begin
              ISList.Add(TPlatformField.AsWideString(NameField));
              DataSet.Next;
            end;
            ISList.Sorted := True;
          finally
            ISList.EndUpdate;
          end;
          try
            List.BeginUpdate;
            List.Clear;
            List.AddStrings(ISList);
          finally
            List.EndUpdate;
          end;
        finally
          ISList.Free;
        end;
      end;
    end;
  finally
    SetCursor(DefaultCursor);
    if Assigned(DataSet) then FreeSchemaTable(DataSet);
  end;
end;

{$IF NOT DEFINED(CLR)}
procedure TSQLConnection.GetFieldNames(const TableName: String; List: TStrings);
var
  wList: TWideStringList;
begin
  wList := TWideStringList.Create;
  try
    OpenSchema(stColumns, TableName, wList);
    List.Assign(wList);
  finally
    wList.Free;
  end;
end;

procedure TSQLConnection.GetFieldNames(const TableName: string; SchemaName: String; List: TStrings);
var
  wList: TWideStringList;
begin
  wList := TWideStringList.Create;
  try
    OpenSchema(stColumns, TableName, SchemaName, wList);
    List.Assign(wList);
  finally
    wList.Free;
  end;
end;
{$IFEND}

procedure TSQLConnection.GetFieldNames(const TableName: WideString; List: TWideStrings);
begin
  OpenSchema(stColumns, TableName, List);
end;

procedure TSQLConnection.GetFieldNames(const TableName: Widestring; SchemaName: WideString; List: TWideStrings);
begin
  OpenSchema(stColumns, TableName, SchemaName, List);
end;

{$IF NOT DEFINED(CLR)}
procedure TSQLConnection.GetProcedureNames(List: TStrings);
var
  wList: TWideStringList;
begin
  wList := TWideStringList.Create;
  try
    OpenSchema(stProcedures, '', wList);
    List.Assign(wList);
  finally
    wList.Free;
  end;
end;

procedure TSQLConnection.GetProcedureNames(const PackageName : string; List: TStrings);
var
  wList: TWideStringList;
begin
  wList := TWideStringList.Create;
  try
    OpenSchema(stProcedures, PackageName, '',  wList);
    List.Assign(wList);
  finally
    wList.Free;
  end;
end;

procedure TSQLConnection.GetProcedureNames(const PackageName, SchemaName : string; List: TStrings);
var
  wList: TWideStringList;
begin
  wList := TWideStringList.Create;
  try
    OpenSchema(stProcedures, PackageName, SchemaName, wList);
    List.Assign(wList);
  finally
    wList.Free;
  end;
end;
{$IFEND}

procedure TSQLConnection.GetProcedureNames(List: TWideStrings);
begin
  OpenSchema(stProcedures, '', List);
end;

procedure TSQLConnection.GetProcedureNames(const PackageName : WideString; List: TWideStrings);
begin
  OpenSchema(stProcedures, PackageName, '',  List);
end;

procedure TSQLConnection.GetProcedureNames(const PackageName, SchemaName : WideString; List: TWideStrings);
begin
  OpenSchema(stProcedures, PackageName, SchemaName, List);
end;

{$IF NOT DEFINED(CLR)}
procedure TSQLConnection.GetPackageNames(List: TStrings);
var
  wList: TWideStringList;
begin
  wList := TWideStringList.Create;
  try
    OpenSchema(stPackages, '', wList);
    List.Assign(wList);
  finally
    wList.Free;
  end;
end;

procedure TSQLConnection.GetSchemaNames(List: TStrings);
var
  S : TWideStrings;
begin
  S := TWideStringList.Create;
  try
    OpenSchema(stUserNames, '', S);
    List.Assign(S);
  finally
    S.Free;
  end;
end;
{$IFEND}

procedure TSQLConnection.GetPackageNames(List: TWideStrings);

begin
  OpenSchema(stPackages, '', List);
end;

{$IF NOT DEFINED(CLR)}
procedure TSQLConnection.GetTableNames(List: TStrings; SystemTables: Boolean = False);
var
  wList: TWideStringList;
begin
  wList := TWideStringList.Create;
  try
    GetTableNames( wList, '', SystemTables );
    List.Assign(wList);
  finally
    wList.Free;
  end;
end;

procedure TSQLConnection.GetTableNames(List: TStrings; SchemaName: WideString; SystemTables: Boolean = False);
var
  wList: TWideStringList;
begin
  wList := TWideStringList.Create;
  try
    GetTableNames(wList, SchemaName, SystemTables);
    List.Assign(wList);
  finally
    wList.Free;
  end;
end;
{$IFEND}

procedure TSQLConnection.GetTableNames(List: TWideStrings; SystemTables: Boolean = False);
begin
  GetTableNames( List, '', SystemTables );
end;

procedure TSQLConnection.GetTableNames(List: TWideStrings; SchemaName: WideString; SystemTables: Boolean = False);
var
  eType: TSchemaType;
begin
  if SystemTables then
    eType := stSysTables
  else
    eType := stTables;
  OpenSchema(eType, '', SchemaName, List);
end;

{$IF NOT DEFINED(CLR)}
procedure TSQLConnection.GetIndexNames(const TableName: string; List: TStrings);
var
  wList: TWideStrings;
begin
  wList := TWideStringList.Create;
  try
    OpenSchema(stIndexes, TableName, '', wList);
    List.Assign(wList);
  finally
    wList.Free;
  end;
end;

procedure TSQLConnection.GetIndexNames(const TableName, SchemaName: string; List: TStrings);
var
  wList: TWideStrings;
begin
  wList := TWideStringList.Create;
  try
    OpenSchema(stIndexes, TableName, SchemaName, wList);
    List.Assign(wList);
  finally
    wList.Free;
  end;
end;
{$IFEND}

procedure TSQLConnection.GetIndexNames(const TableName: WideString; List: TWideStrings);
begin
  OpenSchema(stIndexes, TableName, '', List);
end;

procedure TSQLConnection.GetIndexNames(const TableName, SchemaName: WideString; List: TWideStrings);
begin
  OpenSchema(stIndexes, TableName, SchemaName, List);
end;

// Jens Ole:
// Some databases (i.e. Oracle) does not specify data length and precision
// Set some reasonable values here for the buffer sizes....
// We should probably inspect the input value !!
procedure AdjustProcedureDataLength(ArgDesc: SPParamDesc);
begin
  if ArgDesc.iLen = 0 then
  begin
    case ArgDesc.iDataType of
      ftUnknown:     ArgDesc.iLen := 40;  //probably never used
      ftFixedChar,
      ftFixedWideChar,
      ftWideString,
      ftString:      ArgDesc.iLen := 2000;
      ftSmallint:    ArgDesc.iLen := sizeof(SmallInt);
      ftLargeint:    ArgDesc.iLen := sizeof(LongWord);
      ftInteger:     ArgDesc.iLen := sizeof(Integer);
      ftWord:        ArgDesc.iLen := sizeof(Word);
      ftBoolean:     ArgDesc.iLen := sizeof(Integer);
      ftAutoInc,
      ftCurrency,
      ftFMTBcd,
      ftBCD:         ArgDesc.iLen := FmtBcd.SizeOfTBCD;
      ftFloat,
      ftDate,
      ftTime,
      ftTimeStamp,
      ftDateTime:    ArgDesc.iLen := sizeof(Double);
      ftOraTimeStamp,
      ftOraInterval: ArgDesc.iLen := 16;
    else
      ArgDesc.iLen := 8000;
    end;
    if ArgDesc.iUnits1 = 0 then
      ArgDesc.iUnits1 := ArgDesc.iLen;
  end;
end;

procedure TSQLConnection.GetProcedureParams(ProcedureName: WideString; List: TList);
begin
  GetProcedureParams(ProcedureName, '', List);
end;

procedure TSQLConnection.GetProcedureParams(ProcedureName, PackageName: WideString; List: TList);
begin
  GetProcedureParams(ProcedureName, PackageName, '',  List);
end;

procedure TSQLConnection.GetProcedureParams(ProcedureName, PackageName, SchemaName: WideString; List: TList);
const
  ResultParam = 'Result';                   { Do not localize }
var
  DataSet: TCustomSQLDataSet;
  ArgDesc: SPParamDesc;
  V: Variant;
begin
  DataSet := nil;
 // LeakStartCounter;
  try
    DataSet := OpenSchemaTable(stProcedureParams, ProcedureName,'', PackageName, SchemaName);
    while not DataSet.EOF do
    begin
      if not IsResultSetParameterType(self,DataSet) then
      begin
        ArgDesc := SPParamDesc.Create;
        ArgDesc.iParamNum := DataSet.FieldByName(GetParameterPositionFieldName(self)).Value;
        ArgDesc.iArgType := GetParameterType(self,DataSet,V);

        V := DataSet.FieldByName(GetParameterDataTypeFieldName(self)).Value;
        if VarIsNull(V) then
          ArgDesc.iDataType := ftUnknown
        else if V < TDBXDataTypes.MaxBaseTypes then
          ArgDesc.iDataType := DataTypeMap[Integer(V)]
        else if V = TDBXDataTypesEx.SingleType then
          ArgDesc.iDataType := ftFloat
        else
          ArgDesc.iDataType := ftUnknown;
        if IsParameterFixedStringType(self,DataSet,V) then
        begin
  //      ftFixedWideChar is not accepted for Informix...
          if (ArgDesc.iDataType = ftString) or (ArgDesc.iDataType = ftWideString) then
            ArgDesc.iDataType := ftFixedChar;
        end;
        V := DataSet.FieldByName(GetParameterPrecisionFieldName(self)).Value;
        if VarIsNull(V) then
          ArgDesc.iUnits1 := 0
        else
          ArgDesc.iUnits1 := V;
        V := DataSet.FieldByName(GetParameterScaleFieldName(self)).Value;
        if VarIsNull(V) then
          ArgDesc.iUnits2 := 0
        else
          ArgDesc.iUnits2 := V;
        if ArgDesc.iDataType = ftBCD then
        begin
          // dbExpress only supports ftFMTBcd
          ArgDesc.iDataType := ftFMTBcd
        end;
        V := DataSet.FieldByName(GetParameterLengthFieldName(self)).Value;
        if VarIsNull(V) or (V < 0) then
          ArgDesc.iLen := 0
        else
          ArgDesc.iLen := V;
        AdjustProcedureDataLength(ArgDesc);
        V := DataSet.FieldByName(GetParameterNameFieldName(self)).Value;
        if VarIsNull(V) then
          ArgDesc.szName := ResultParam
        else
          ArgDesc.szName := V;
        List.Add(ArgDesc);
      end;
      DataSet.next;
    end;
  finally
    FreeSchemaTable(DataSet);
//    LeakStopCounter;
  end;
end;

{ trace }

procedure TSQLConnection.SetTraceEvent(Event: TDBXTraceEvent);
begin
  FTraceCallbackEvent := Event;
  if Connected and not (csLoading in ComponentState) then
  begin
    RegisterTraceCallBack(Assigned(Event));
  end;
end;


procedure TSQLConnection.RegisterClient(Client: TObject;
  Event: TConnectChangeEvent);
begin
  inherited;

end;

procedure TSQLConnection.RegisterTraceCallback(Value: Boolean);
begin
  if (Value) then
  begin
    if Assigned(FTraceCallbackEvent) then
      FDBXConnection.OnTrace := FTraceCallbackEvent;
  end else
  begin
    if Assigned(FDBXConnection) then
      FDBXConnection.OnTrace := FTraceCallbackEvent;
  end;
end;

{ transaction support }

function TSQLConnection.GetInTransaction: Boolean;
begin
  Result := FTransactionCount > 0;
end;


function TSQLConnection.BeginTransaction: TDBXTransaction;
begin
  Result := BeginTransaction(TDBXIsolations.ReadCommitted);
end;

procedure TSQLConnection.StartTransaction( TransDesc: TTransactionDesc);
var
  Isolation: TDBXIsolation;
begin
  case TransDesc.IsolationLevel of
    xilREADCOMMITTED:
      Isolation := TDBXIsolations.ReadCommitted;
    xilREPEATABLEREAD:
      Isolation := TDBXIsolations.RepeatableRead;
    xilDIRTYREAD:
      Isolation := TDBXIsolations.DirtyRead;
    xilCUSTOM:
      Isolation := TDBXIsolations.ReadCommitted;
  end;
  BeginTransaction(TransDesc, Isolation);
end;

function TSQLConnection.BeginTransaction(TransDesc: TTransactionDesc;
  Isolation: TDBXIsolation): TDBXTransaction;
var
  Item: TTransactionItem;
begin
  CheckConnection(eConnect);
  if Connected then
  begin
    if FTransactionsSupported then
    begin
      CheckActive;
      if (not InTransaction) or FSupportsNestedTrans then
      begin
        Item := TTransactionItem.Create;
        Item.FTransactionDesc := TransDesc;
        try
          Item.FTransaction := FDBXConnection.BeginTransaction(Isolation);
          Item.FNext := FTransactionStack;
          FTransactionStack := Item;
        finally
          if Item.FTransaction = nil then
            Item.Free;
        end;
        Inc(FTransactionCount);
      end else
        DatabaseError(sActiveTrans, self)
    end;
  end else
    DatabaseError(SDatabaseClosed, Self);
end;

function TSQLConnection.BeginTransaction(
  Isolation: TDBXIsolation): TDBXTransaction;
var
  TransactionDesc: TTransactionDesc;
begin
  TransactionDesc.TransactionID := FTransactionCount + 1;
  if FTransactionsSupported then
  begin
    BeginTransaction(TransactionDesc, Isolation);
    Result := FTransactionStack.FTransaction
  end else
    Result := nil;
end;

function TSQLConnection.HasTransaction(Transaction: TDBXTransaction): Boolean;
var
  Item: TTransactionItem;
  TargetItem: TTransactionItem;
begin
  Item := FTransactionStack;
  while Item <> nil do
  begin
    if Item.FTransaction = Transaction then
    begin
      Result := true;
      exit;
    end;
    Item := FTransactionStack.FNext
  end;

  Result := false;
end;

procedure TSQLConnection.EndFreeAndNilTransaction(var Transaction: TDBXTransaction; Commit: Boolean);
var
  TransactionDesc:  TTransactionDesc;
  Item: TTransactionItem;
  TargetItem: TTransactionItem;
begin
  Item := FTransactionStack;
  TargetItem := Item;
  while Item <> nil do
  begin
    TargetItem := Item;
    if Item.FTransaction = Transaction then
      break;
    Item := FTransactionStack.FNext
  end;
  if TargetItem <> nil then
  begin
    EndAndFreeTransaction(TargetItem.FTransactionDesc, Commit);
    Transaction := nil;
  end else
  begin
    DatabaseError(sInvalidTransaction);
  end;
end;

procedure TSQLConnection.EndAndFreeTransaction(Commit: Boolean);
var
  Temp: TDBXTransaction;
begin
  if FTransactionsSupported then
  begin
    // Must put in temp since EndFreeAndNilTransaction will set
    // out (internal FTransctionStack element) reference to nil.
    //
    Temp := FTransactionStack.FTransaction;
    EndFreeAndNilTransaction(Temp, Commit);
  end;
end;

procedure TSQLConnection.EndAndFreeTransaction(TransDesc: TTransactionDesc; Commit: Boolean);
var
  Status: TDBXErrorCode;
  TargetTransaction:  TDBXTransaction;
  Item: TTransactionItem;
begin
  if FTransactionsSupported then
  begin
    if InTransaction then
    begin
      if Assigned(FDBXConnection) then
      begin
        Item := FTransactionStack;
        TargetTransaction := nil;
        while Item <> nil do
        begin
          FTransactionStack := Item.FNext;
          TargetTransaction := Item.FTransaction;
          if Item.FTransactionDesc.TransactionID = TransDesc.TransactionID then
          begin
            Item.Free;
            Item := Nil;
          end else
          begin
            Item.Free;
            Item := FTransactionStack;
          end;
        end;
        if TargetTransaction <> nil then
        begin
          if Commit then
            FDBXConnection.CommitFreeAndNil(TargetTransaction)
          else
            FDBXConnection.RollbackFreeAndNil(TargetTransaction);
        end;
        Dec(FTransactionCount);
      end
      else
        DatabaseError(SDatabaseClosed, Self);
    end
    else
      DatabaseError(sNoActiveTrans, self);
    CheckDisconnect;
  end;
end;


procedure TSQLConnection.CommitFreeAndNil(var Transaction: TDBXTransaction);
begin
  EndFreeAndNilTransaction(Transaction, true);
end;

procedure TSQLConnection.RollbackFreeAndNil(var Transaction: TDBXTransaction);
begin
  EndFreeAndNilTransaction(Transaction, false);
end;

procedure TSQLConnection.RollbackIncompleteFreeAndNil(
  var Transaction: TDBXTransaction);
begin
  if HasTransaction(Transaction) then
    RollbackFreeAndNil(Transaction);
  Transaction := nil;
end;

procedure TSQLConnection.Commit(TransDesc: TTransactionDesc);
begin
  EndAndFreeTransaction(TransDesc, True);
end;

procedure TSQLConnection.Rollback( TransDesc: TTransactionDesc);
begin
  EndAndFreeTransaction(TransDesc, false);
end;

function TSQLConnection.GetDataSet(Index: Integer): TCustomSQLDataSet;
begin
  Result := TCustomSQLDataSet(inherited GetDataSet(Index));
end;

{ misc. property set/get }

procedure TSQLConnection.SetDriverName(Value: string);

  procedure LoadDriverParams;
  var
    Index: Integer;
  begin
    FConnectionName := DriverName;
    LoadParamsFromIniFile(DriverRegistryFile);
    FConnectionName := '';
    Index := Params.IndexOfName(VENDORLIB_KEY);
    if Index <> -1 then
      Params.Delete(Index);
    Index := Params.IndexOfName(DLLLIB_KEY);
    if Index <> -1 then
      Params.Delete(Index);
    Index := Params.IndexOfName(GETDRIVERFUNC_KEY);
    if Index <> -1 then
      Params.Delete(Index);
  end;

begin
  if FDriverName <> Value then
  begin
    CheckInactive;
    if FConnectionName = '' then
    begin
      FVendorLib := '';
      FLibraryName := '';
      FGetDriverFunc := '';
      FParams.Clear;
    end;
    FDriverName := Value;
    if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
    begin
      FParams.Clear;
      FParamsLoaded := False;
      if FDriverName <> '' then
      begin
        try
          FVendorLib := Trim(GetProfileString(FDriverName, VENDORLIB_KEY, DriverRegistryFile));
          FLibraryName := Trim(GetProfileString(FDriverName, DLLLIB_KEY, DriverRegistryFile));
          FGetDriverFunc := Trim(GetProfileString(FDriverName, GETDRIVERFUNC_KEY, DriverRegistryFile));
          if FConnectionName = '' then
            LoadDriverParams;
        except
          DatabaseErrorFmt(SDriverNotInConfigFile, [Value, DriverRegistryFile]);
        end;
      end;
    end;
  end;
end;

function TSQLConnection.GetFDriverRegistryFile: string;
begin
  if FDriverRegistryFile = '' then
    FDriverRegistryFile := GetDriverRegistryFile(csDesigning in ComponentState);
  Result := FDriverRegistryFile;
end;

function TSQLConnection.GetConnectionName: string;
begin
  Result := FConnectionName;
end;

procedure TSQLConnection.SetConnectionName(Value: string);
var
  NewDriver: string;
begin
  if FConnectionName <> Value then
  begin
//    FreeAndNil(FLastError);
    if not (csLoading in ComponentState) then
      if Connected then Connected := False;
    if (FDriverName = '') and (Value = '') then
    begin
      FVendorLib := '';
      FLibraryName := '';
      FParams.Clear;
    end;
    FParamsLoaded := False;
    FConnectionName := Value;
    if not (csLoading in ComponentState) then
      CloseDataSets;
    if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
    begin
      if (Value = '') and (LoadParamsOnConnect) then
        FParams.Clear;
      if Value <> '' then
      begin
        NewDriver := GetProfileString(FConnectionName, DRIVERNAME_KEY, ConnectionRegistryFile);
        if NewDriver <> DriverName then
          DriverName := NewDriver;
        LoadParamsFromIniFile;
      end;
    end;
  end;
end;

function TSQLConnection.GetVendorLib: string;
begin
  Result := FVendorLib;
  if (Result = '') and (FLoadParamsOnConnect or (csLoading in ComponentState)) then
    Result := Trim(GetProfileString(FDriverName, VENDORLIB_KEY, DriverRegistryFile));
end;


function TSQLConnection.GetLibraryName: string;
begin
  Result := FLibraryName;
  if (Result = '') and (FLoadParamsOnConnect or (csLoading in ComponentState)) then
    Result := Trim(GetProfileString(FDriverName, DLLLIB_KEY, DriverRegistryFile));
end;


procedure TSQLConnection.LoadParamsFromIniFile(FFileName: WideString = '');
var
  IniFile: TMemIniFile;
  List: TStrings;
  FIniFileName: string;
begin
  if not FParamsLoaded then
  begin
    if FConnectionName = '' then
      DatabaseError(SConnectionNameMissing);
    List := TStringList.Create;
    try
      if FFileName = '' then
        FIniFileName := ConnectionRegistryFile
      else
        FIniFileName := FFileName;
      IniFile := TMemIniFile.Create(FIniFileName);
      try
        if FileExists(FIniFileName) then
        begin
          IniFile.ReadSectionValues(FConnectionName, List);
          Params.BeginUpdate;
          try
            Params.Clear;
            Params.AddStrings(List);
          finally
            Params.EndUpdate;
          end;
        end else
          DatabaseErrorFmt(sMissingDriverRegFile, [FIniFileName]);
      finally
        IniFile.Free;
      end;
    finally
      List.Free;
    end;
    FParamsLoaded := True;
  end;
end;

procedure TSQLConnection.SetLocaleCode(Value: TLocaleCode);
begin
  FParams.Values[SQLLOCALE_CODE_KEY] := IntToHex(Value, 4);
end;

function TSQLConnection.GetLocaleCode: TLocaleCode;
begin
  if FParams.Values[SQLLOCALE_CODE_KEY] <> '' then
    Result := StrToInt(HexDisplayPrefix + FParams.Values[SQLLOCALE_CODE_KEY])
  else
    Result := 0;
end;

procedure TSQLConnection.SetKeepConnection(Value: Boolean);
begin
  if FKeepConnection <> Value then
  begin
    FKeepConnection := Value;
    if not Value and (FRefCount = 0) then Close;
  end;
end;

procedure TSQLConnection.SetParams(Value: TWideStrings);
begin
  CheckInactive;
  FParams.Assign(Value);
end;


procedure TSQLConnection.Loaded;
begin
  inherited Loaded;
end;

procedure TSQLConnection.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;


procedure TSQLConnection.GetSchemaNames(List: TWideStrings);
begin
  OpenSchema(stUserNames, '', List);
end;

function TSQLConnection.GetDefaultSchemaName: WideString;
begin
  CheckConnection(eConnect);
  Result := FDefaultSchemaName;
end;

{ TSQLDataLink }

constructor TSQLDataLink.Create(ADataSet: TCustomSQLDataSet);
begin
  inherited Create;
  FSQLDataSet := ADataSet;
end;

procedure TSQLDataLink.ActiveChanged;
begin
  if FSQLDataSet.Active then FSQLDataSet.RefreshParams;
end;

function TSQLDataLink.GetDetailDataSet: TDataSet;
begin
  Result := FSQLDataSet;
end;

procedure TSQLDataLink.RecordChanged(Field: TField);
begin
  if (Field = nil) and FSQLDataSet.Active then FSQLDataSet.RefreshParams;
end;

procedure TSQLDataLink.CheckBrowseMode;
begin
  if FSQLDataSet.Active then FSQLDataSet.CheckBrowseMode;
end;

{ TCustomSQLDataSet }

constructor TCustomSQLDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParams := TParams.Create(Self);
  FDataLink := TSQLDataLink.Create(Self);
  FIndexDefs := TIndexDefs.Create(Self);
  FCommandType := ctQuery;
  FDbxCommandType := TDBXCommandTypes.DbxSQL;
  FCommandText := '';
  FParamCheck := True;
  FRecords := -1;
  FParamCount := -1;
  FSchemaInfo.FType := stNoSchema;
  SetUniDirectional(True);
  ObjectView := False;
end;

destructor TCustomSQLDataSet.Destroy;
begin
  Close;
//  FreeAndNil(FLastError);
  if Assigned(FDBXReader) then FreeReader;
  if Assigned(FDBXCommand) then FreeCommand;
  FreeAndNil(FParams);
  FreeAndNil(FIndexDefs);
  SetConnection(nil);
  FreeProcParams(FProcParams);
  inherited Destroy;
  FDataLink.Free;
  FreeBuffers;
end;

{ connection management }

procedure TCustomSQLDataSet.CheckConnection(eFlag: eConnectFlag);
begin
  if (FSQLConnection <> nil) then
    FSQLConnection.CheckConnection(eFlag)
  else if (eFlag in [eConnect, eReconnect ]) then
    DatabaseError(SMissingSQLConnection);
end;

procedure TCustomSQLDataSet.SetConnection(const Value: TSQLConnection);
begin
  CheckInactive;
  if Assigned(FSQLConnection) then
    FSQLConnection.UnRegisterClient(Self);
  FSQLConnection := Value;
  if (not (csLoading in ComponentState)) and (FSQLConnection <> Value) then
    SchemaName := '';
  if Assigned(FSQLConnection) then
  begin
    FSQLConnection.RegisterClient(Self,nil);
    if FMaxBlobSize = 0 then   // means it hasn't been changed
    begin
      if FSQLConnection.Params.Values[MAXBLOBSIZE_KEY] <> '' then
      try
        FMaxBlobSize := StrToInt(trim(FSQLConnection.Params.Values[MAXBLOBSIZE_KEY]));
      except
        FMaxBlobSize := DefaultMaxBlobSize;
      end else
        FMaxBlobSize := DefaultMaxBlobSize;
    end;
  end;
end;

function TCustomSQLDataSet.GetInternalConnection: TSQLConnection;
begin
  if Assigned(FClonedConnection) then
    Result := FClonedConnection
  else
    Result := FSQLConnection;
end;


{ open/close Cursors and Statements }

procedure TCustomSQLDataSet.GetObjectTypeNames(Fields: TFields);
var
  I: Integer;
  ObjectField: TObjectField;
begin
  for I := 0 to Fields.Count - 1 do
  begin
    if Fields[I] is TObjectField then
    begin
      ObjectField := TObjectField(Fields[I]);
      ObjectField.ObjectType := FDBXReader.GetObjectTypeName(ObjectField.FieldNo-1);
      with ObjectField do
        if DataType in [ftADT, ftArray] then
        begin
          if (DataType = ftArray) and SparseArrays and
             (Fields[0].DataType = ftADT) then
            GetObjectTypeNames(TObjectField(Fields[0]).Fields) else
            GetObjectTypeNames(Fields);
        end;
    end;
  end;
end;

procedure TCustomSQLDataSet.InternalOpen;
begin
  ExecuteStatement;
  if not Assigned(FDBXReader) then
  begin
    FreeCommand;
    if not FGetNextRecordSet then
      DataBaseError(SNoCursor,Self)
    else
      Exit;
  end;
  FieldDefs.Update;
  if DefaultFields then CreateFields;
  BindFields(True);
  if ObjectView then GetObjectTypeNames(Fields);
  InitBuffers;
end;

function TCustomSQLDataSet.IsCursorOpen: Boolean;
begin
  Result := (FDBXReader <> nil);
end;

procedure TCustomSQLDataSet.OpenCursor(InfoQuery: Boolean);
begin
  if (SchemaInfo.FType = stNoSchema) and (FCommandText = '') then
    DatabaseError(SNoSQLStatement);
  CheckConnection(eConnect);
  SetPrepared(True);
  CheckPrepareError;
  if FDataLink.DataSource <> nil then
     SetParamsFromCursor;
  if (SchemaInfo.FType = stNoSchema) then
    Inc(FSqlConnection.FActiveStatements);
  inherited OpenCursor;
end;

procedure TCustomSQLDataSet.CloseCursor;
begin
  inherited CloseCursor;
  if (SchemaInfo.FType = stNoSchema) and (FSqlConnection <> nil) then
    Dec(FSqlConnection.FActiveStatements);
end;

procedure TCustomSQLDataSet.FreeReader;
begin
  if Assigned(FDBXReader) then
  begin
    FreeAndNil(FDBXReader);
    FStatementOpen := False;   // Releasing Reader closes associated statement
  end;
end;

procedure TCustomSQLDataSet.FreeCommand;
begin
  if Assigned(FDBXCommand) then
  begin
    FreeReader;
    CloseStatement;
    if Assigned(FSQLConnection) then
      if Assigned(FClonedConnection) then
        FreeAndNil(FClonedConnection)
      else
       if FSQLConnection.FSelectStatements > 0 then
         Dec(FSQLConnection.FSelectStatements);
  end;
// Metadata requests now init FDBXCommand which is tested above.
//  else
//  if (FSchemaInfo.FType <> stNoSchema) then
//    if Assigned(FClonedConnection) then
//      FreeAndNil(FClonedConnection)
//    else
//      if Assigned(FSQLConnection) and (FSQLConnection.FSelectStatements > 0) then
//        Dec(FSQLConnection.FSelectStatements);

  if Assigned(FieldDefs) then
    FieldDefs.Updated := False;
  ClearIndexDefs;
end;

procedure TCustomSQLDataSet.CloseStatement;
begin
  FPrepared := False;
  FParamCount := -1;
  FStatementOpen := False;
  if Assigned(FDBXCommand) then
    FreeAndNil(FDBXCommand);
end;

procedure TCustomSQLDataSet.InternalClose;
var
  DetailList: TObjectList;
  I: Integer;
begin
  BindFields(False);
  if DefaultFields then DestroyFields;
  FreeBuffers;
  DetailList := TObjectList.Create(false);
  try
    GetDetailDataSets(DetailList);
    for I := 0 to DetailList.Count -1 do
    if TDataSet(DetailList[I]) is TCustomSQLDataSet then
    begin
      TCustomSQLDataSet(TDataSet(DetailList[I])).Close;
      TCustomSQLDataSet(TDataSet(DetailList[I])).SetPrepared(False);
    end;
  finally
    DetailList.Free;
  end;
  if Assigned(FSQLConnection) and ((FSQLConnection.KeepConnection) or
     (FSQLConnection.DataSetCount > 1)) then
    FreeReader
  else
    SetPrepared(False);
end;

procedure TCustomSQLDataSet.Loaded;
begin
  inherited Loaded;
end;

procedure TCustomSQLDataSet.InternalRefresh;
begin
  SetState(dsInactive);
  CloseCursor;
  OpenCursor(False);
  SetState(dsBrowse);
end;

procedure TCustomSQLDataSet.InitBuffers;
begin
  if (MaxBlobSize > 0) then
    SetLength(FBlobBuffer, MaxBlobSize * 1024);
  if (CalcFieldsSize > 0) then
    SetLength(FCalcFieldsBuffer, CalcFieldsSize);
end;

procedure TCustomSQLDataSet.ClearIndexDefs;
begin
  FIndexDefs.Clear;
  FIndexDefsLoaded := False;
end;

procedure TCustomSQLDataSet.FreeBuffers;
begin
  if FBlobBuffer <> nil then
    SetLength(FBlobBuffer, 0);
  FBlobBuffer := nil;
  if FFieldBuffer <> nil then
    SetLength(FFieldBuffer, 0);
  FFieldBuffer := nil;
  FCurrentBlobSize := 0;
  if FCalcFieldsBuffer <> nil then
  begin
    SetLength(FCalcFieldsBuffer, 0);
    FCalcFieldsBuffer := nil;
  end;
end;

procedure TCustomSQLDataSet.InitRecord(Buffer: TRecordBuffer);
begin
  { NOP }
end;

procedure TCustomSQLDataSet.SetBufListSize(Value: Integer);
begin
end;

{ Reader Level Metadata }

procedure TCustomSQLDataSet.AddFieldDesc(FieldDescs: TFieldDescList; DescNo: Integer;
  var FieldID: Integer; RequiredFields: TBits; FieldDefs: TFieldDefs);
const
  ArrayIndex = '[0]';
var
  FType: TFieldType;
  FSize: LongWord;
  FRequired: Boolean;
  FPrecision, I: Integer;
  FieldName, FName: WideString;
  FieldDesc: TFLDDesc;
  FldDef: TFieldDef;
begin
  FieldDesc := FieldDescs[DescNo];
  with FieldDesc do
  begin
    FieldName := szName; { TODO -oTArisawa : Can remove FieldName? }
    FName := FieldName;
    I := 0;
    while FieldDefs.IndexOf(FName) >= 0 do
    begin
      Inc(I);
      FName := Format('%s_%d', [FieldName, I]);
    end;
    if iFldType < TDBXDataTypes.MaxBaseTypes then
      FType := DataTypeMap[iFldType]
    else if iFldType = TDBXDataTypesEx.SingleType then
      FType := ftFloat
    else
      FType := ftUnknown;
    if iFldType in [{TDBXTypes.FMTBCD,} TDBXDataTypes.BcdType] then
    begin
      iUnits2 := Abs(iUnits2);
      if iUnits1 < iUnits2 then   // iUnits1 indicates Oracle 'usable decimals'
        iUnits1 := iUnits2;
      // ftBCD supports only up to 18-4.  If Prec > 14 or Scale > 4, make FMTBcd
      if (iUnits1 > (MaxBcdPrecision-4)) or (iUnits2 > MaxBcdScale) or FNumericMapping then
      begin
        FType := ftFMTBcd;
        iFldType := TDBXDataTypes.BcdType;
        if (iUnits1 = 38) and (iUnits2 in [0,38]) then
        begin
          iUnits1 := 32;
          iUnits2 := 8;
        end;
        if iUnits1 > MaxFMTBcdDigits then
          iUnits1 := MaxFMTBcdDigits;
      end;
    end;
    FSize := 0;
    FPrecision := 0;
    if RequiredFields.Size > FieldID then
      FRequired := RequiredFields[FieldID] else
      FRequired := False;
    case iFldType of
      TDBXDataTypes.AnsiStringType:
        begin
          if iUnits1 = 0 then { Ignore MLSLABEL field type on Oracle }
            FType := ftUnknown else
            FSize := iUnits1;
        end;
      TDBXDataTypes.WideStringType:
        begin
          if iUnits1 = 0 then { Ignore MLSLABEL field type on Oracle }
            FType := ftUnknown else
            FSize := iUnits1;
        end;

      TDBXDataTypes.BytesType, TDBXDataTypes.VarBytesType, TDBXDataTypes.RefType:
        begin
          if iUnits1 = 0 then { Ignore MLSLABEL field type on Oracle }
            FType := ftUnknown else
            FSize := iUnits1;
        end;
      TDBXDataTypes.Int16Type, TDBXDataTypes.UInt16Type:
        if iLen <> 2 then FType := ftUnknown;
      TDBXDataTypes.Int32Type:
        if iSubType = TDBXDataTypes.AutoIncSubType then
        begin
          FType := ftAutoInc;
          FRequired := False;
        end;
      TDBXDataTypes.DoubleType:
        if iSubType = TDBXDataTypes.MoneySubType then FType := ftCurrency;
      {TDBXTypes.FMTBCD,} TDBXDataTypes.BcdType:
        begin
          FSize := Abs(iUnits2);
          FPrecision := iUnits1;
        end;
      TDBXDataTypes.AdtType, TDBXDataTypes.ArrayType:
        begin
          FSize := iUnits2;
          FPrecision := iUnits1;
        end;
      TDBXDataTypes.BlobType:
        begin
          FSize := iUnits1;
          if (iSubType >= TDBXDataTypes.MemoSubType) and (iSubType <= TDBXDataTypes.BFileSubType) then
            FType := BlobTypeMap[iSubType];
        end;
    end;
    FldDef := FieldDefs.AddFieldDef;
    with FldDef do
    begin
      FieldNo := FieldID;
      Inc(FieldID);
      Name := FName;
      DataType := FType;
      Size := FSize;
      Precision := FPrecision;
      if FRequired then
        Attributes := [faRequired];
      if efldrRights = fldrREADONLY then
        Attributes := Attributes + [faReadonly];
      if iSubType = TDBXDataTypes.FixedSubType then
        Attributes := Attributes + [faFixed];
      InternalCalcField := bCalcField;
      case FType of
        ftADT:
          begin
            if iSubType = TDBXDataTypes.AdtNestedTableSubType then
              Attributes := Attributes + [faUnNamed];
            for I := 1 to iUnits1 do
            begin
              LoadFieldDef(Word(FieldNo + I), FieldDescs[1]);
              AddFieldDesc(FieldDescs, 1, FieldID, RequiredFields, ChildDefs);
            end;
          end;
        ftArray:
          begin
            for I := 1 to iUnits1 do
            begin
              LoadFieldDef(Word(FieldNo + I), FieldDescs[1]);
              FieldDescs[1].szName := FieldDesc.szName + ArrayIndex;
              AddFieldDesc(FieldDescs, 1, FieldID, RequiredFields, ChildDefs);
            end;
          end;
      end;
    end;
  end;
end;

procedure TCustomSQLDataSet.LoadFieldDef(FieldID: Word; var FldDesc: TFLDDesc);
var
  ValueType: TDBXValueType;
begin
  FldDesc.iFldNum   := FieldID;
  ValueType         := FDBXReader.ValueType[FieldID-1];
  FldDesc.szName    := ValueType.Name;
  FldDesc.iFldType  := ValueType.DataType;
  FldDesc.iSubtype  := ValueType.SubType;
  FldDesc.iLen      := ValueType.Size;
  FldDesc.iUnits1   := ValueType.Precision;
  FldDesc.iUnits2   := ValueType.Scale;
  if ValueType.ReadOnly then
    FldDesc.efldrRights := fldrREADONLY;
end;

procedure TCustomSQLDataSet.InternalInitFieldDefs;
var
  FID: Integer;
  FieldDescs: TFieldDescList;
  RequiredFields: TBits;
  Nullable: LongBool;
  FldDescCount: Word;
begin
  if (FDBXReader <> nil) then
  begin
    RequiredFields := TBits.Create;
    try
      FldDescCount := FDBXReader.ColumnCount;
      SetLength(FieldDescs, FldDescCount);
      for FID := 1 to FldDescCount do
        FieldDescs[FID-1] := TFldDesc.Create;
      try
        RequiredFields.Size := FldDescCount + 1;
        FieldDefs.Clear;
        FID := 1;
        FMaxColSize := FldDescCount;
        while FID <= FldDescCount do
        begin
          RequiredFields[FID] := FDBXReader.ValueType[FID-1].Nullable = False;
          LoadFieldDef(Word(FID), FieldDescs[0]);
          if (FieldDescs[0].iLen > FMaxColSize) and
             (FieldDescs[0].iFldType <> TDBXDataTypes.BlobType) then
            FMaxColSize := (FMaxColSize + FieldDescs[0].iLen);
          AddFieldDesc(FieldDescs, Integer(0), FID, RequiredFields, FieldDefs);
        end;
      finally
        for FID := 1 to FldDescCount do
          FreeAndNil(FieldDescs[FID-1]);
        FieldDescs := nil;
      end;
    finally
      RequiredFields.Free;
    end;
  end
  else
     DatabaseError(SDataSetClosed, self);
end;

{ Field and Record Access }

//{
procedure NormalizeBcdData(FieldBuffer: TBytes; BcdData: TValueBuffer; Precision, Scale: Word);
var
  InBcd: TBcd;
  LBcd: TBcd;
  Index: Integer;
begin
  if Assigned(BcdData) then
  begin
    if Precision > MaxFMTBcdDigits then Precision := MaxFMTBcdDigits;
    InBcd := BcdFromBytes(FieldBuffer);
    if (LBcd.SignSpecialPlaces = 38) and ((Scale and 63)in [38,0]) then
    begin
      if (Scale and (1 shl 7)) <> 0 then
        NormalizeBcd(InBcd, LBcd, MaxFMTBcdDigits, Word((DefaultFMTBcdScale and 63) or (1 shl 7)))
      else
        NormalizeBcd(InBcd, LBcd, MaxFMTBcdDigits, DefaultFMTBcdScale);
    end else
      NormalizeBcd(InBcd, LBcd, Precision, Scale);
    TPlatformValueBuffer.Copy(BcdToBytes(LBcd), 0, BcdData, SizeOfTBcd);
  end;
end;
//}
{
procedure NormalizeBcdData(BcdData: PBcd; Precision, Scale: Word);
var
  ABcd: TBcd;
  Success: Boolean;
begin
  if Assigned(BcdData) then
  begin
    if Precision > MaxFMTBcdDigits then Precision := MaxFMTBcdDigits;
    if (BcdData.SignSpecialPlaces = 38) and ((Scale and 63)in [38,0]) then
    begin
      if (Scale and (1 shl 7)) <> 0 then
        Success := NormalizeBcd( BcdData^, ABcd, MaxFMTBcdDigits, Word((DefaultFMTBcdScale and 63) or (1 shl 7)))
      else
        Success := NormalizeBcd( BcdData^, ABcd, MaxFMTBcdDigits, DefaultFMTBcdScale);
    end else
      Success := NormalizeBcd( BcdData^, ABcd, Precision, Scale);
    if Success then
      BcdData^ := ABcd
    else
      DatabaseError(SBcdOverflow);
 end;
end;
}
{$IF DEFINED(CLR)}
function TCustomSQLDataSet.GetFieldData(FieldNo: Integer; Buffer: TValueBuffer): Boolean;
{$ELSE}
function TCustomSQLDataSet.GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean;
{$IFEND}
var
  FldType: Word;
  FBlank: LongBool;
  Field: TField;
  Precision, Scale: Word;
  ByteReader: TDBXByteReader;
  Ordinal:  Integer;
  ByteBuffer: TBytes;
  DataLength: Integer;
  BytesRead:  Int64;
  ValueType: TDBXValueType;
begin
  if (FDBXReader = nil) then
    DatabaseError(SDataSetClosed, self);

  // When EOF is True or we are dealing with a calculated field (FieldNo < 1)
  // we should not be calling into the driver to get Data
  //
  if (FieldNo < 1) then
  begin
    Result := False;
    Exit;
  end;
  if EOF and (not BOF) then
  begin
    Result := False;
    Exit;
  end;
  if (EOF and BOF and FDBXReader.Closed) then
  begin
    Result := False;
    Exit;
  end;

  FBlank := True;
  Ordinal := FieldNo - 1;
  ValueType := FDBXReader.ValueType[Ordinal];
  DataLength := ValueType.Size;
  FldType := ValueType.DataType;
  if (Length(FFieldBuffer) < DataLength) and (FldType <> TDBXDataTypes.BlobType) then
    SetLength(FFieldBuffer, DataLength);
  ByteReader := FDBXReader.ByteReader;
  begin
    case FldType of
      TDBXDataTypes.AnsiStringType:
        begin
          ByteReader.GetAnsiString(Ordinal, FFieldBuffer, 0, FBlank);
          if not FBlank then
            TPlatformValueBuffer.Copy(FFieldBuffer, 0, Buffer, DataLength);
        end;
      TDBXDataTypes.WideStringType:
        begin
          if Length(FFieldBuffer) < (DataLength*2) then
            SetLength(FFieldBuffer, DataLength*2);
          ByteReader.GetWideString(Ordinal, FFieldBuffer, 0, FBlank);
          if not FBlank then
            TPlatformValueBuffer.Copy(FFieldBuffer, 0, Buffer, DataLength*2);
        end;
      TDBXDataTypes.Int16Type, TDBXDataTypes.UInt16Type:
        begin
          ByteReader.GetInt16(Ordinal, FFieldBuffer, 0, FBlank);
          if not FBlank then
            TPlatformValueBuffer.Copy(FFieldBuffer, 0, Buffer, DataLength);
        end;
      TDBXDataTypes.Int32Type, TDBXDataTypes.Uint32Type:
        begin
          ByteReader.GetInt32(Ordinal, FFieldBuffer, 0, FBlank);
          if not FBlank then
            TPlatformValueBuffer.Copy(FFieldBuffer, 0, Buffer, DataLength);
        end;
      TDBXDataTypes.Int64Type:
        begin
          ByteReader.GetInt64(Ordinal, FFieldBuffer, 0, FBlank);
          if not FBlank then
            TPlatformValueBuffer.Copy(FFieldBuffer, 0, Buffer, DataLength);
        end;
      TDBXDataTypes.DoubleType:
        begin
          ByteReader.GetDouble(Ordinal, FFieldBuffer, 0, FBlank);
          if not FBlank then
            TPlatformValueBuffer.Copy(FFieldBuffer, 0, Buffer, DataLength);
        end;
      {TDBXTypes.FMTBCD,} TDBXDataTypes.BcdType:
        begin
          ByteReader.GetBcd(Ordinal, FFieldBuffer, 0, FBlank);
          Field := FieldByNumber(FieldNo);
          if (not FBlank) and (Field <> nil) then
          begin
            if Field.DataType = ftBcd then
            begin
              Precision := TBcdField(Field).Precision;
              Scale := TBcdField(Field).Size;
            end else
            begin
              Precision := TFMTBcdField(Field).Precision;
              Scale := TFMTBcdField(Field).Size;
            end;
            NormalizeBcdData(FFieldBuffer, Buffer, Precision, Scale);
          end;
        end;
      TDBXDataTypes.DateType:
        begin
          ByteReader.GetDate(Ordinal, FFieldBuffer, 0, FBlank);
          if not FBlank then
            TPlatformValueBuffer.Copy(FFieldBuffer, 0, Buffer, DataLength);
        end;
      TDBXDataTypes.TimeType:
        begin
          ByteReader.GetTime(Ordinal, FFieldBuffer, 0, FBlank);
          if not FBlank then
            TPlatformValueBuffer.Copy(FFieldBuffer, 0, Buffer, DataLength);
        end;
      TDBXDataTypes.TimeStampType:
        begin
          ByteReader.GetTimeStamp(Ordinal, FFieldBuffer, 0, FBlank);
          if not FBlank then
            TPlatformValueBuffer.Copy(FFieldBuffer, 0, Buffer, DataLength);
        end;
      TDBXDataTypes.BooleanType:
        begin
          ByteReader.GetInt16(Ordinal, FFieldBuffer, 0, FBlank);
          if not FBlank then
            // DbxClient returns DataSize of 1, but we are reading 2 bytes.
            TPlatformValueBuffer.Copy(FFieldBuffer, 0, Buffer, 2);//DataLength);
        end;
      TDBXDataTypes.VarBytesType:
        begin
          DataLength := FDBXReader.ValueType[Ordinal].Size;
          SetLength(ByteBuffer, DataLength+2);
          BytesRead := ByteReader.GetBytes(Ordinal, 0, ByteBuffer, 2, DataLength, FBlank);
          ByteBuffer[0] := BytesRead;
          ByteBuffer[1] := BytesRead shr 8;
          if not FBlank then
            TPlatformValueBuffer.Copy(ByteBuffer, 0, Buffer, DataLength+2);
        end;
      TDBXDataTypes.BytesType:
        begin
          DataLength := FDBXReader.ValueType[Ordinal].Size;
          SetLength(ByteBuffer, DataLength);
          ByteReader.GetBytes(Ordinal, 0, ByteBuffer, 0, DataLength, FBlank);
          if not FBlank then
            TPlatformValueBuffer.Copy(ByteBuffer, 0, Buffer, DataLength);
        end;
      TDBXDataTypes.BlobType:
        begin
//          DataLength := GetBlobLength(Self, FieldNo);
          if CurrentBlobSize = 0 then
            FBlank := True
          else
            begin
{$IF NOT DEFINED(CLR)}
// Temporary for bug 249185.  Needs to be fixed properly for both managed
// and native in a better way than this.  This change will keep things
// working the same way they did in bds2006.
// Need to modify all drivers to return 0 bytes read if they cannot read
// a blob twice.  The temporary change below is also an optimization for
// blobs since it avoids a copy of the blob.  This is not the right way
// to fix this.  Solution should solve the problem for both native and
// managed. One option is to duplicate blob read code from the TSQLBlobStream
// class.  Virtually all apps will go through a blob stream to access blob
// data.  However there is a path to this method though TField.GetData.
// Sure would be nice if TDataSet could manage record buffers as TBytes.
// sshaughnessy 2007.04.19.
//
              if Buffer = FBlobBuffer then
              begin
                ByteBuffer := TBytes(Buffer);
                ByteReader.GetBytes(Ordinal, 0, ByteBuffer, 0, CurrentBlobSize, FBlank);
              end else
{$IFEND}
              begin
                SetLength(ByteBuffer, CurrentBlobSize);
                ByteReader.GetBytes(Ordinal, 0, ByteBuffer, 0, CurrentBlobSize, FBlank);
                if not FBlank then
                  TPlatformValueBuffer.Copy(ByteBuffer, 0, Buffer, CurrentBlobSize);
              end;
            end;
        end;
    end;
  end;
//    SetLength(FFieldBuffer, 1);
  Result := not FBlank;
end;

{$IF DEFINED(CLR)}
function TCustomSQLDataSet.GetFieldData(Field: TField; Buffer: TValueBuffer): Boolean;
{$ELSE}
function TCustomSQLDataSet.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
{$IFEND}
var
   FieldNo: Word;
   TempBuffer: TValueBuffer;
   ThisBuffer: TValueBuffer;
   BlobSize: Int64;
   BlobNull: LongBool;
begin
  if not Self.Active then
    DataBaseError(SDatasetClosed);
  FieldNo := Field.FieldNo;
  if not Assigned(Buffer) then
  begin
    if Field.IsBlob then
    begin
      if EOF then
        BlobNull := True
      else
        FDBXReader.ByteReader.GetByteLength(Word(FieldNo)-1, BlobSize, BlobNull);
      Result := not Boolean(BlobNull);
      Exit;
    end
    else if Field.Size > Field.DataSize then
      TempBuffer := TPlatformValueBuffer.CreateValueBuffer(Field.Size)
    else
      TempBuffer := TPlatformValueBuffer.CreateValueBuffer(Field.DataSize);
    ThisBuffer := TempBuffer;
  end else
  begin
    ThisBuffer := Buffer;
    TempBuffer := nil;
  end;
  try
    if Field.FieldNo < 1 then
      Result := GetCalculatedField(Field, ThisBuffer)
    else
      Result := GetFieldData(FieldNo, ThisBuffer);
  finally
    if Assigned(TempBuffer) then
      TPlatformValueBuffer.Free(TempBuffer);
  end;
end;

procedure TCustomSQLDataSet.SetCurrentBlobSize(Value: Int64);
begin
  if Value > FCurrentBlobSize then
    SetLength(FBlobBuffer, Value);
  FCurrentBlobSize := Value;
end;

function TCustomSQLDataSet.GetBlobFieldData(FieldNo: Integer; var Buffer: TBlobByteData): Integer;
var
  IsNull: LongBool;
  FldType: Word;
  Ordinal: Integer;
begin
  Result := 0;
  Ordinal := FieldNo - 1;
  GetBlobLength(Self, FieldNo);
  if (FDBXReader = nil) then
    DatabaseError(SDataSetClosed, self);
  if FCurrentBlobSize > 0 then
  begin
    fldType := FDBXReader.ValueType[Ordinal].DataType;
    if LongWord(Length(Buffer)) < CurrentBlobSize then
      SetLength(Buffer, CurrentBlobSize);
    if FCurrentBlobSize = 0 then
      Result := 0
    else
    begin
      FDBXReader.ByteReader.GetBytes(Ordinal, 0, TBytes(Buffer), 0, FCurrentBlobSize, IsNull);
      if not IsNull then
        Result := CurrentBlobSize;
    end;
  end;
end;

function TCustomSQLDataSet.CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream;
begin
  Result := TSQLBlobStream.Create(Field as TBlobField, Mode);
end;

{$IF DEFINED(CLR)}
procedure TCustomSQLDataSet.SetFieldData(Field: TField; Buffer: TValueBuffer);
{$ELSE}
procedure TCustomSQLDataSet.SetFieldData(Field: TField; Buffer: Pointer);
{$IFEND}
var
  RecBuf: TBytes;
begin
  RecBuf := FCalcFieldsBuffer;
  with Field do
  begin
    if FieldNo < 1 then   //{fkCalculated}
    begin
      if Assigned(Buffer) then
        begin
          RecBuf[Offset] := 1;
          TPlatformValueBuffer.Copy(Buffer, RecBuf, Offset+1, DataSize);
        end
      else
          RecBuf[Offset] := 0;
    end;
  end;
end;

function TCustomSQLDataSet.GetCalculatedField(Field: TField; var Buffer: TValueBuffer): Boolean;
var
  RecBuf: TBytes;
begin
  Result := False;
  RecBuf := FCalcFieldsBuffer;
  with Field do
  begin
    if FieldNo < 1 then   //{fkCalculated}
    begin
      if Boolean(RecBuf[Offset]) then
      begin
        TPlatformValueBuffer.Copy(RecBuf, Offset+1, Buffer, DataSize);
        Result := True;
      end;
    end;
  end;
end;

function TCustomSQLDataSet.GetCanModify: Boolean;
begin
  Result := False;
end;

procedure TCustomSQLDataSet.GetCommandNames(List: TWideStrings);
begin
  FSQLConnection.FDBXConnection.GetCommands(FDbxCommandType, List);
end;

function TCustomSQLDataSet.GetRecord(Buffer: TRecordBuffer; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
begin
  if FDBXReader.Next then
  begin
    GetCalcFields(Buffer);
    if Buffer <> nil then
      TPlatformRecordBuffer.Copy(Buffer, FCalcFieldsBuffer, 0, Length(FCalcFieldsBuffer));
    Result := grOK
  end
  else
    Result := grEOF;
end;

{ CommandText Management }

procedure TCustomSQLDataSet.SetFCommandText(const Value: string);
begin
  CheckInactive;
  FCommandText := Value;
  FNativeCommand := '';
end;

procedure TCustomSQLDataSet.SetCommandText(const Value: WideString);
var
  HasDataLink: Boolean;
  DataSet: TDataSet;
begin
  if FCommandText <> Value then
  begin
    CheckInactive;
    PropertyChanged;
    FCommandText := Trim(Value);
    if (SQLConnection <> nil) and (Value <> '') then
    begin
      if FParamCheck and (FCommandType <> ctTable) then
      begin
        HasDataLink := (FDataLink.DataSource <> nil) and (FDataLink.DataSource.DataSet is TCustomSQLDataSet);
        if HasDataLink then
          DataSet := FDataLink.DataSource.DataSet
        else
          DataSet := nil;
        SetParamsFromSQL(DataSet, not HasDataLink);
      end;
    end;
{$IF DEFINED(CLR)}
    DataEvent(dePropertyChange, nil);
{$ELSE}
    DataEvent(dePropertyChange, 0);
{$IFEND}
  end;
end;

function TCustomSQLDataSet.GetDataSetFromSQL(TableName: WideString): TCustomSQLDataSet;
var
  Q: WideString;
begin
  if TableName = '' then
    TableName := GetTableNameFromSQLEx(SSelectStarFrom +
              Copy(CommandText, 8, Length(CommandText) - 7), GetIdOption(FSQLConnection));
  if TableName = '' then
    Result := nil
  else
  begin
    Result := TCustomSQLDataSet.Create(nil);
    try
      Result.SetConnection(Self.SQLConnection);
      Q := Self.FSqlConnection.GetQuoteChar;
      Result.CommandText := SSelectStarFrom +
                  Q + TableName + Q +
                  SWhere + ' 0 = 1';    // only metadata is needed
      Result.Active := True;
    except
      FreeAndNil(Result);
    end;
  end;
end;

{ Parameters }

function TCustomSQLDataSet.GetProcParams: TList;
begin
  if (Self.FSQLConnection.Connected) and not Assigned(FProcParams) then
  begin
    FProcParams := TList.Create;
    FSQLConnection.GetProcedureParams(CommandText, FSchemaInfo.PackageName, FSchemaName, FProcParams);
  end;
  Result := FProcParams;
end;

procedure TCustomSQLDataSet.SetParamsFromProcedure;
var
  List: TParams;
begin
  List := TParams.Create;
  try
    try
      { Preserve existing values }
      List.AssignValues(Params);
      if Assigned(FProcParams) then
        FreeProcParams(FProcParams);
      ProcParams := TList.Create;
      FSQLConnection.GetProcedureParams(CommandText, FSchemaInfo.PackageName, FSchemaName, ProcParams);
      LoadParamListItems(List, FProcParams);
    except
        FreeProcParams(FProcParams);
    end;
    if List.Count > 0 then
      Params.Assign(List)
  finally
    List.Free;
  end;
end;

procedure TCustomSQLDataSet.SetParamsFromSQL(DataSet: TDataSet; bFromFields: Boolean);
var
  Field: TField;
  I: Integer;
  List: TSQLParams;
  WasDatasetActive: Boolean;
  FTblName: WideString;
  DSCreated: Boolean;
begin
  DSCreated := False;
  FNativeCommand := Copy(CommandText, 1, Length(CommandText));
  if (CommandType = ctStoredProc) then
  begin
    SetParamsFromProcedure;
    Exit;
  end;
  List := TSQLParams.Create(Self, GetIdOption(SQLConnection));
  try                                              // DBExpress only supports '?', so
    FTblName := List.Parse(FNativeCommand, True);  // save query to avoid
    { Preserve existing values }                   // parsing again with prepare
    List.AssignValues(Params);
    if (Assigned(SQLConnection)) and (List.Count > 0) then
      begin
        WasDataSetActive := True;
        if DataSet = nil then
        begin
          if FTblName <> '' then
          begin
            if csDesigning in ComponentState then
            begin
              DataSet := GetDataSetFromSQL(FTblName);
              if Assigned(DataSet) then
                DSCreated := True;
            end;
          end;
        end else begin
          WasDataSetActive := DataSet.Active;
          if not DataSet.Active then DataSet.Active := True;
        end;
        for I := 0 to List.Count - 1 do
          List[I].ParamType := ptInput;
        if (DataSet <> nil) and
              ((not List.BindAllFields) or
              (List.Count = DataSet.FieldCount)) then
          try
            for I := 0 to List.Count - 1 do
            begin
              if List.BindAllFields then
                Field := DataSet.Fields[I]
              else if List.FFieldName.Count > I then
              begin
                if (bFromFields) then
                  Field := DataSet.FieldByName(List.GetFieldName(I))
                else
                  Field := DataSet.FieldByName(List[I].Name);
              end else
                 Field := nil;
              if Assigned(Field) then
              begin
                if Field.DataType <> ftString then
                  List[I].DataType := Field.DataType
                else if TStringField(Field).FixedChar then
                  List[I].DataType := ftFixedChar
                else
                  List[I].DataType := ftString;
              end;
            end;
          except
            // ignore exception: Column type won't be provided
          end;
        if List.Count > 0 then
          Params.Assign(List);
        if Assigned(DataSet) and (not WasDataSetActive) then DataSet.Active := False;
      end
    else
      Params.clear;
  finally
    List.Free;
    if DSCreated then DataSet.Free;
  end;
end;

procedure TCustomSQLDataSet.RefreshParams;
var
  DataSet: TDataSet;
begin
  DisableControls;
  try
    if FDataLink.DataSource <> nil then
    begin
      DataSet := FDataLink.DataSource.DataSet;
      if DataSet <> nil then
        if DataSet.Active and (DataSet.State <> dsSetKey) then
        begin
          Close;
          Open;
        end;
    end;
  finally
    EnableControls;
  end;
end;

procedure TCustomSQLDataSet.SetParamsFromCursor;
var
  I: Integer;
  DataSet: TDataSet;
begin
  if (FDataLink.DataSource <> nil) and (FParams.Count > 0) then
  begin
    DataSet := FDataLink.DataSource.DataSet;
    if (DataSet <> nil) then
    begin
      for I := 0 to FParams.Count - 1 do
        with FParams[I] do
          if not Bound then
          begin
            if not DataSet.eof then
              AssignField(DataSet.FieldByName(Name))
            else
              FParams[I].Value := Null;
            Bound := False;
          end;
    end;
  end;
end;

function TCustomSQLDataSet.ParamByName(const Value: string): TParam;
begin
  Result := FParams.ParamByName(Value);
end;


procedure TCustomSQLDataSet.GetOutputParams(AProcParams: TList);
var
  I: Integer;
  ArgDesc: SPParamDesc;
  Param: TParam;
  TimeStamp: TTimeStamp;
  CurrencyValue: Currency;
  Bytes: TBytes;
  BytesLength: Int64;
begin
  if AProcParams = nil then
    ArgDesc := SPParamDesc.Create
  else
    ArgDesc := nil;
  try
    for I := 0 to Params.Count - 1 do
    begin
      if AProcParams <> nil then
        ArgDesc := (SPParamDesc(AProcParams.Items[I]))
      else
        with ArgDesc, Params[i] do
          begin
            iParamNum := i + 1;
            szName := Name;
            iArgType := ParamType;
            iDataType := DataType;
            iUnits1 := Precision;
            iUnits2 := NumericScale;
            iLen := GetDataSize;
          end;
      if (Params[I].ParamType in [ptOutput, ptResult, ptInputOutput]) and
         (ArgDesc.iDataType <> ftCursor) then
      begin
        Param := Params[I];
        with FDBXCommand.Parameters[i] do
        begin
          ParameterDirection := TDBXParameterDirection(Param.ParamType);
          DataType         := FldTypeMap[Param.DataType];
          Precision          := Param.Size;

          case Param.DataType of
              ftBlob, ftGraphic..ftTypedBinary,ftOraBlob,ftOraClob:
              begin
                Size := Params[I].Size;
                SetLength(Bytes, Size);
                Value.GetBytes(0, Bytes, 0, Size);
                if Value.IsNull then
                  Param.Value := Null
                else
                  Param.SetBlobData(Bytes, Size);
              end
              else
              begin
                Size               := ArgDesc.iLen;
                if Value.IsNull then
                  Param.Value := Null
                else
                case Param.DataType of
                    ftString, ftFixedChar:
                      begin
                        Param.AsString :=  Value.GetAnsiString;
                      end;
                    ftWord:
                      Param.AsWord := Value.GetInt16;
                    ftSmallInt:
                      Param.AsSmallInt := Value.GetInt16;
                    ftAutoInc, ftInteger:
                      Param.Value := Value.GetInt32;
                    ftTime:
                      begin
                        TimeStamp.Time := Value.GetTime;
                        TimeStamp.Date := DateDelta;
                        Param.AsTime := TimeStampToDateTime(TimeStamp);
                      end;
                    ftDate:
                      begin
                        TimeStamp.Time := 0;
                        TimeStamp.Date := Value.GetDate;
                        Param.AsDate := TimeStampToDateTime(TimeStamp);
                      end;
                    ftTimeStamp:
                      Param.AsSQLTimeStamp := Value.GetTimeStamp;
                    ftBCD:
                      if BCDToCurr(Value.GetBcd, CurrencyValue) then
                        Param.AsBCD := CurrencyValue
                      else
                        Param.AsBCD := 0;
                    ftFMTBCD:
                      Param.AsFMTBCD := Value.GetBcd;
                    ftCurrency:
                      Param.AsCurrency := Value.GetDouble;
                    ftFloat:
                      Param.AsFloat := Value.GetDouble;
                    ftBoolean:
                      Param.AsBoolean := Value.GetBoolean;
                    ftMemo:
                      Param.AsMemo := Value.GetAnsiString;
                    ftWideString, ftWideMemo:
                    begin
      //{$IF DEFINED(CLR)}
      //                Param.Value := Value.GetAnsiString;
      //{$ELSE}
                      Param.Value := Value.GetWideString;
      //{$IFEND}
                    end;
                else
                  DatabaseErrorFmt(SBadFieldType, [Name], Self);
                end;
              end;
            end;
          end;
        end;
      end;
  finally
    if AProcParams = nil then
      ArgDesc.Free;
  end;
end;

procedure TCustomSQLDataSet.SetParameters(const Value: TParams);
begin
  FParams.AssignValues(Value);
end;

{ Query Management }

procedure TCustomSQLDataSet.SetPrepared(Value: Boolean);
var
  Complete: Boolean;
begin
  if Value then CheckConnection(eConnect);
  if FGetNextRecordSet then
    FPrepared := Value
  else
    FreeReader;
  if SchemaInfo.FType <> stNoSchema then
  begin
    if Value then
      CheckStatement(True)
    else
      FreeCommand;
  end
  else
  if Value <> Prepared then
  begin
//    try
//      if Value then
//        begin
//          if FDBXCommand <> nil then DatabaseError(SSQLDataSetOpen, Self);
//          FRowsAffected := -1;
//          FCheckRowsAffected := True;
//          PrepareStatement;
//        end
//      else
//        begin
//          if FCheckRowsAffected then
//            FRowsAffected := RowsAffected;
//          FreeCommand;
//          if Assigned(FSQLConnection) then
//            FSQLConnection.CheckDisconnect;
//        end;
//      FPrepared := Value;
//    except
//      if Assigned(FDBXCommand) then
//        FreeCommand;
//      FPrepared := False;
//    end;

    Complete := false;
    if Value then
      try
        if FDBXCommand <> nil then DatabaseError(SSQLDataSetOpen, Self);
        FRowsAffected := -1;
        FCheckRowsAffected := True;
        PrepareStatement;
        Complete := true;
      finally
        if not Complete then
        begin
          if Assigned(FDBXCommand) then
            FreeCommand;
          FPrepared := False;
        end
      end
    else
      try
        if FCheckRowsAffected then
          FRowsAffected := RowsAffected;
        FreeCommand;
        if Assigned(FSQLConnection) then
          FSQLConnection.CheckDisconnect;
      except
        if Assigned(FDBXCommand) then
          FreeCommand;
        FPrepared := False;
      end;

    FPrepared := Value;
  end;
end;

procedure TCustomSQLDataSet.CheckStatement(ForSchema: Boolean = False);
var
  Connection: TSqlConnection;
  RowsetSize: Integer;
begin
//  FreeAndNil(FLastError);
  RowsetSize := defaultRowsetSize;
  if not Assigned(FSQLConnection) then
    DatabaseError(SMissingSQLConnection);
  Connection := FSQLConnection.GetConnectionForStatement;
  if Connection.FIsCloned then
    FClonedConnection := Connection;
  if Connection.LoadParamsOnConnect then
    Connection.LoadParamsFromIniFile;
  if Assigned(FDBXCommand) then
    FreeCommand;
  if not Assigned(Connection.DBXConnection) then
    DatabaseError(SdatabaseOpen, Self);
  if not ForSchema then
  begin
    if Length(FCommandText) = 0 then
      DatabaseError(SEmptySQLStatement, Self);
    FDBXCommand := Connection.DBXConnection.CreateCommand;
    FDBXCommand.CommandType := FDbxCommandType;

    if FSQLConnection.Params.Values[ROWSETSIZE_KEY] <> '' then
    try
      RowsetSize := StrToInt(trim(FSQLConnection.Params.Values[ROWSETSIZE_KEY]));
    except
      RowsetSize := defaultRowsetSize;
    end;

    if Connection.FMetaData.SupportsRowSetSize then
      FDBXCommand.RowSetSize := RowsetSize;

    FStatementOpen := True;
//    if FTransactionLevel > 0 then
//      FDBXCommand.SetOption(eCommTransactionID, Integer(FTransactionLevel));
    if FNativeCommand = '' then
    begin
      if FParams.Count > 0 then
        FNativeCommand := FixParams(CommandText, FParams.Count, Connection.GetQuoteChar)
      else
        FNativeCommand := CommandText;
    end;
  end;
end;

function TCustomSQLDataSet.GetQueryFromType: WideString;
var
  STableName : String;
begin
  case CommandType of
     ctTable:
       begin
         if Self.FSchemaName <> '' then
           STableName := QuoteIdentifier(FSchemaName + '.' + FCommandText, false)
         else
           STableName := QuoteIdentifier(FCommandText, false);
         if FSortFieldNames > '' then
           Result := SSelectStarFrom + STableName + SOrderBy + FSortFieldNames
         else
           if FNativeCommand = '' then
             Result := SSelectStarFrom + STableName
           else
           begin
             if Trim(FSchemaName) <> '' then
               STableName := QuoteIdentifier(FSchemaName + '.' + FNativeCommand, false)
             else
              STableName := QuoteIdentifier(FNativeCommand, false);
             Result := SSelectStarFrom + STableName;
           end;
       end;
     ctStoredProc:
       begin
         if FSchemaName <> '' then
           Result := QuoteIdentifier(FSchemaName + '.' + FCommandText, true)
         else
           Result := QuoteIdentifier(FCommandText, true)
       end;
     else
       if (FSortFieldNames > '') and (Pos(SOrderBy,
          WideLowerCase(FCommandText)) = 0) then
         Result := FNativeCommand + SOrderBy + FSortFieldNames
       else
         Result := FNativeCommand;
  end;
end;

function TCustomSQLDataSet.CheckDetail(const SQL: WideString): WideString;
begin
  Result := SQL;
  if pos(SParam, SQL) = 0 then
    if pos(SSelect, WideLowerCase(SQL)) > 0 then // Select Query with no ?, but Parameters are set
      Result := AddParamSQLForDetail(Params, SQL, True);
end;

procedure TCustomSQLDataSet.PrepareStatement;
var
  SQLText, Value: WideString;
  CurSection : TSqlToken;
  Start: Integer;
  IdOption: IDENTIFIEROption;
begin
  if Length(CommandText) = 0 then
    DatabaseError(SEmptySQLStatement, Self);
  IdOption := GetIdOption(FSQLConnection);
  if CommandType <> ctStoredProc then
  begin
    CurSection := stUnknown;
    Start := 1;
    CurSection := Platform_NextSQLToken(CommandText, Start, Value, CurSection, IdOption);
    if (CurSection = stSelect) or (CommandType = ctTable) then
      Inc(FSQLConnection.FSelectStatements);
    if CommandType = ctTable then
      FCommandText := Value;
  end;
  CheckStatement;
  SQLText := GetQueryFromType;
  if CommandType <> ctStoredProc then
  begin
    Start := 1;
    CurSection := Platform_NextSQLToken(SQLText, Start, Value, CurSection, IdOption);
    if (CurSection = stSelect) or (CommandType = ctTable) then
      Inc(FSQLConnection.FSelectStatements);
    if Params.Count > 0 then
      SQLText := CheckDetail(SQLText);
    FDBXCommand.CommandType := FDbxCommandType;
  end
  else
    FDBXCommand.CommandType := FDbxCommandType;
  FDBXCommand.Text := SQLText;
  if Params.Count > 0 then
    FDBXCommand.Parameters.SetCount(Params.Count);
  FDBXCommand.Prepare;
end;

procedure TCustomSQLDataSet.CheckPrepareError;
begin
  if (FDBXCommand = nil) and (SchemaInfo.FType = stNoSchema) then
  begin     // prepare has failed
//    if FLastError <> nil then
//      FSQLConnection.SQLError(FLastError)
//    else
    if (CommandType = ctQuery) or (SortFieldNames <> '') then
      DatabaseError(sPrepareError)
    else
      DatabaseError(sObjectNameError);
  end;
end;

function TCustomSQLDataSet.ExecSQL(ExecDirect: Boolean = False): Integer;
begin
  CheckInActive;
  CheckConnection(eConnect);
  try
    FRowsAffected := 0;
    if not ExecDirect then
    begin
      SetPrepared(True);
      CheckPrepareError;
      ExecuteStatement;
    end else
    begin
      CheckStatement;
      FDBXCommand.CommandType := FDbxCommandType;
      FDBXCommand.Text := CommandText;
      FDBXCommand.Prepare;
      FDBXReader := FDBXCommand.ExecuteQuery;
    end;
    if FDBXReader <> nil then
       SetParamsFromCursor;
    Result := RowsAffected;
  finally
    if Assigned(FDBXReader) then
    begin
      FreeReader;
      FreeCommand;
    end else if ExecDirect then
      FreeCommand
    else
      CloseStatement;
  end;
end;

procedure TCustomSQLDataSet.ExecuteStatement;

 function UseParams(): Boolean;
  const
    SDelete = 'delete';      { Do not localize }
    SUpdate = 'update';      { Do not localize }
    SInsert = 'insert';      { Do not localize }
  var
    SQL: WideString;
  begin
    Result := (FParams.Count <> 0);
    if Result and (FCommandType = ctTable) then
    begin
       if FNativeCommand <> ''  then
         SQL := FNativeCommand
       else
         SQL := FCommandText;
       Result := SqlRequiresParams(SQL);
    end;
  end;


var
  Status: TDBXErrorCode;
begin
  if SchemaInfo.FType = stNoSchema then
    begin
      if Assigned(FParams) and not FGetNextRecordSet then
      begin
        if CommandType = ctStoredProc then
          SetQueryProcParams(Self.FSQLConnection, FDBXCommand, Params, ProcParams)
        else
        if UseParams() then
          SetQueryProcParams(Self.FSQLConnection, FDBXCommand, Params);
      end;
      if FGetNextRecordSet then
      begin
        FreeAndNil(FDBXReader);
        FDBXReader := FDBXCommand.GetNextReader;
        if FDBXReader <> nil then
        begin
          if Active then
            Active := False
          else  // Active might be false when calling getNextCursor.
            CloseCursor;
        end else
          begin
            if CommandType = ctStoredProc then
              begin
                if Params.Count > 0 then
                  GetOutputParams(FProcParams);
              end
            else
              begin
                if Params.Count > 0 then
                  GetOutputParams;
              end;
          end;
      end
      else
      begin
        FDBXReader := FDBXCommand.executeQuery;
        if CommandType = ctStoredProc then
          begin
            if Params.Count > 0 then
              GetOutputParams(FProcParams);
          end
        else
          begin
            if Params.Count > 0 then
              GetOutputParams;
          end;
      end;
    end
  else begin
  //  LeakStartCounter;
    try
      OpenSchema;
    finally
   //   LeakStopCounter;
    end;
  end;
  FStatementOpen := True;
  FRecords := -1;
end;

function TCustomSQLDataSet.GetObjectProcParamCount: Integer;
var
  I, LastParamNum: Integer;
  ArgDesc: SPParamDesc;
begin
  GetProcParams;    // make sure FProcParams is loaded.
  Result := 0;
  LastParamNum := 0;
  for I := 0 to Params.Count -1 do
  begin
    ArgDesc := (SPParamDesc(ProcParams.Items[I]));
    if ArgDesc.iParamNum <> LastParamNum then Inc(Result);
    LastParamNum := ArgDesc.iParamNum;
  end;
end;

function TCustomSQLDataSet.GetParamCount: Integer;
var
  I : Integer;
begin
  Result := FParamCount;
  if Result = -1 then
  begin
    Result := 0;
    if Assigned(FParams) then
    begin
      if FCommandType = ctStoredProc then
      begin
        for I := 0 to Params.Count -1 do
        begin
          if Params.Items[I].DataType in [ftADT, ftARRAY] then
          begin
            Result := GetObjectProcParamCount;
            break;
          end;
        end;
      end;
      if Result = 0 then Result := FParams.Count
    end;
  end;
end;

function GetRows(Query: string; Connection: TSQLConnection): Integer;
var
  DS: TSQLDataSet;
begin
  Result := -1;
  DS := TSQLDataSet.Create(nil);
  try
    DS.SQLConnection := Connection;
    DS.CommandText := Query;
    DS.Active := True;
    if not DS.EOF then
      Result := DS.Fields[0].AsInteger;
  finally
    DS.Free;
    if Result = -1 then
      DatabaseError(SNotSupported);
  end;
end;

function TCustomSQLDataSet.GetRecordCount: Integer;
const
  SDistinct = ' distinct ';                 { do not localize }
  SSelectCount = 'select count(*) from ';   { do not localize }
var
  TableName, Query: string;
  HoldPos: Integer;
  Status : TDBXErrorCode;
  str : WideString;
begin
  if FRecords <> -1 then
    Result := FRecords
  else
  begin
    CheckConnection(eConnect);
    if Self.CommandText = '' then
      DatabaseError(SNoSQLStatement);
    case CommandType of
      ctStoredProc:
        DatabaseError(SNotSupported);
      ctTable:
        begin
          with GetInternalConnection.FDBXConnection do
          begin
            //Query := 'select count(*) from ' + GetQuoteChar + FCommandText + GetQuoteChar;
            Query := 'select count(*) from ' + QuoteIdentifier(CommandText, false);
          end;
        end;
      ctQuery:
        begin
          TableName := GetTableNameFromSQLEx(FCommandText, GetIdOption(FSQLConnection));
          if (TableName = '') or (Params.Count > 0) then
            DatabaseError(SNotSupported);
          if Pos(SDistinct, WideLowerCase(FCommandText)) = 0 then
            Query := SSelectCount
          else
            DatabaseError(SNotSupported);
          HoldPos := Pos(SWhere, WideLowerCase(FCommandText));
          if HoldPos = 0 then
            Query := Query + GetQuoteChar + TableName + GetQuoteChar
          else begin
            Query := Query + GetQuoteChar + TableName + GetQuoteChar + copy(FCommandText, HoldPos, Length(FCommandText) - (HoldPos-1));
            HoldPos := Pos(sOrderBy, WideLowerCase(Query));
            if HoldPos > 0 then
              Query := copy(Query, 1, HoldPos - 1);
          end;
        end;
    end;
    FRecords := GetRows(Query, FSQLConnection);
    Result := FRecords;
  end;
end;

function TCustomSQLDataSet.GetRowsAffected: Integer;
var
  UpdateCount: LongWord;
begin
  if FRowsAffected > 0 then
    Result := Integer(FRowsAffected)
  else
    begin
      if FDBXCommand <> nil then
        UpdateCount := FDBXCommand.RowsAffected
      else
        UpdateCount := 0;
      FRowsAffected := Integer(UpdateCount);
      Result := Integer(UpdateCount);
    end;
end;

{ Misc. Set/Get Property }

procedure TCustomSQLDataSet.SetDataSource(Value: TDataSource);
begin
  if IsLinkedTo(Value) then DatabaseError(SCircularDataLink, Self);
  if FDataLink.DataSource <> Value then
    FDataLink.DataSource := Value;
end;

procedure TCustomSQLDataSet.SetDbxCommandType(const Value: WideString);
begin
  if Value = TDBXCommandTypes.DbxStoredProcedure then
    FCommandType := ctStoredProc
  else if Value = TDBXCommandTypes.DbxTable then
    FCommandType := ctTable
  else
    FCommandType := ctQuery;

  FDbxCommandType := Value;

end;

function TCustomSQLDataSet.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

{$IF DEFINED(CLR)}
procedure TCustomSQLDataSet.GetDetailLinkFields(MasterFields, DetailFields: TObjectList);
{$ELSE}
procedure TCustomSQLDataSet.GetDetailLinkFields(MasterFields, DetailFields: TList);
{$IFEND}

  function AddFieldToList(const FieldName: string; DataSet: TDataSet;
    List: TList): Boolean;
  var
    Field: TField;
  begin
    Field := DataSet.FindField(FieldName);
    if Field <> nil then
      List.Add(Field);
    Result := Field <> nil;
  end;

var
  I: Integer;
begin
  MasterFields.Clear;
  DetailFields.Clear;
  if (DataSource <> nil) and (DataSource.DataSet <> nil) then
    for I := 0 to Params.Count - 1 do
      if AddFieldToList(Params[I].Name, DataSource.DataSet, MasterFields) then
        AddFieldToList(Params[I].Name, Self, DetailFields);
end;

function TCustomSQLDataSet.GetSortFieldNames: WideString;
begin
  Result := FSortFieldNames;
end;

procedure TCustomSQLDataSet.SetSortFieldNames(Value: WideString);
begin
  FSortFieldNames := Value;
end;

procedure TCustomSQLDataSet.SetMaxBlobSize(MaxSize: Integer);
begin
  FMaxBlobSize := MaxSize;
  if (FDBXCommand <> nil) then
    FDBXCommand.MaxBlobSize := MaxSize;
end;

procedure TCustomSQLDataSet.SetCommandType(const Value: TSQLCommandType);
begin
  if FCommandType <> Value then
  begin
    CheckInactive;
    FCommandType := Value;
    case Value of
      ctQuery:      FDbxCommandType := TDBXCommandTypes.DbxSQL;
      ctTable:      FDbxCommandType := TDBXCommandTypes.DbxTable;
      ctStoredProc: FDbxCommandType := TDBXCommandTypes.DbxStoredProcedure;
    end;
    PropertyChanged;
{$IF DEFINED(CLR)}
    DataEvent(dePropertyChange, nil);
{$ELSE}
    DataEvent(dePropertyChange, 0);
{$IFEND}
  end;
end;

procedure TCustomSQLDataSet.PropertyChanged;
begin
  if not (csLoading in ComponentState) then
  begin
    SetPrepared(False);
    FNativeCommand := '';
    FRecords := -1;
    FreeCommand;
    if SortFieldNames <> '' then
      FSortFieldNames := '';
    if FCommandText <> '' then
      FCommandText := '';
    FParams.Clear;
  end;
end;

{ Miscellaneous }

function TCustomSQLDataSet.IsSequenced: Boolean;
begin
  Result := False;
end;

procedure TCustomSQLDataSet.DefineProperties(Filer: TFiler);

  function DesignerDataStored: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := TCustomSQLDataSet(Filer.Ancestor).DesignerData <> DesignerData else
      Result := DesignerData <> '';
  end;

begin
  inherited;
  Filer.DefineProperty('DesignerData', ReadDesignerData, WriteDesignerData,
    DesignerDataStored);
end;

procedure TCustomSQLDataSet.ReadDesignerData(Reader: TReader);
begin
  FDesignerData := Reader.ReadString;
end;

procedure TCustomSQLDataSet.WriteDesignerData(Writer: TWriter);
begin
  Writer.WriteString(FDesignerData);
end;


procedure TCustomSQLDataSet.InternalHandleException;
begin
end;

{ Index Support }

procedure TCustomSQLDataSet.UpdateIndexDefs;
begin
  AddIndexDefs(Self);
end;

function TCustomSQLDataSet.CheckFieldNames(const FieldNames: WideString): Boolean;
var
  S: WideString;
  Pos: Integer;
begin
  Result := True;
  S := FieldNames;
  Pos := 1;
  while Result and (Pos <= Length(S)) do
    Result := FindField(ExtractFieldName(S, Pos)) <> nil;
end;

const
  IDX_TYPE_FIELD = 'INDEX_TYPE';           { Do not localize }
  IDX_SORT_FIELD = 'SORT_ORDER';           { Do not localize }
  DescendingOrder = 'D';                   { Do not localize }

procedure TCustomSQLDataSet.AddIndexDefs(SourceDS: TCustomSQLDataSet; IndexName: string = '');

  function DontUseIndex: Boolean;
  begin
    Result := CommandType in [ctQuery, ctStoredProc];
    if Result and (CommandType = ctQuery) then
      Result := IsMultiTableQuery(CommandText);
    if Result then FIndexDefsLoaded := True;
  end;

var
  DataSet: TCustomSQLDataSet;
  TableName, IdxName, SortOrder, FieldNames: string;
  IdxType: Integer;
  Options: TIndexOptions;
  IdxDef: TIndexDef;
  MetaData: TDBXDatabaseMetaData;
  Dbx4Metadata: Boolean;
  IndexColumns: TDBXIndexColumns;
  Index: Integer;
  FirstColumnAscending: Boolean;
begin
  if not FGetMetadata then FIndexDefsLoaded := True;
  if FIndexDefsLoaded then Exit;
  if SchemaInfo.FType <> stNoSchema then Exit;
  if DontUseIndex then Exit;
  if FCommandType = ctTable then
    TableName := FCommandText
  else
    TableName := GetTableNameFromSQLEx(CommandText, GetIdOption(FSQLConnection));
  DataSet := FSQLConnection.OpenSchemaTable(stIndexes, TableName, '', '', '');
  MetaData := FSQLConnection.FDBXConnection.DatabaseMetaData;
  IndexColumns := nil;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Dbx4Metadata := true
  else
    Dbx4Metadata := false;
  try
    FIndexDefs.Clear;
    IndexDefs.Clear;
    if Dbx4Metadata then
    begin
      while not DataSet.EOF do
      begin
        begin
          Options := [];
          IdxName := DataSet.FieldByName(GetIndexFieldName(FSQLConnection)).Value;
          if (IndexName = '') or (IdxName = IndexName) then
          begin

            try
              if IndexColumns = nil then
              begin
                IndexColumns := TDBXIndexColumns.Create;
                IndexColumns.FGetIndexesText := DataSet.FDBXCommand.Text;
                IndexColumns.FSqlConnection := DataSet.FSQLConnection;
                IndexColumns.Open;
              end;
              if IndexColumns.HasAllFieldNames(IdxName, SourceDS, FieldNames, FirstColumnAscending) then
              begin
                if DataSet.FieldByName('IsPrimary').Value then
                  Options := Options + [ixPrimary];
                if DataSet.FieldByName('IsUnique').Value then
                  Options := Options + [ixUnique];
                // vcl assumes all index columns are all asc or all desc, so
                // just look at the first.
                //
                if not FirstColumnAscending then
                  Options := Options + [ixDescending];
                FIndexDefs.Add(IdxName, FieldNames, Options);
              end;
            finally
              FreeAndNil(IndexColumns);
            end;
          end;
        end;
        DataSet.Next;
      end;
    end else
    begin
      while not DataSet.EOF do
      begin
        begin
          Options := [];
          IdxName := DataSet.FieldByName(GetIndexFieldName(FSQLConnection)).Value;
          if (IndexName = '') or (IdxName = IndexName) then
          begin
            if IndexDefs.IndexOf(IdxName) = -1 then
            begin
              FieldNames := DataSet.FieldByName(GetColumnFieldName(FSQLConnection)).Value;
              // don't add indexes on fields not in result set
              if SourceDS.CheckFieldNames(FieldNames) then
              begin
                IdxType := DataSet.FieldByName(IDX_TYPE_FIELD).Value;
                if (IdxType and eSQLPrimaryKey) = eSQLPrimaryKey then
                  Options := Options + [ixPrimary];
                if (IdxType and eSQLUnique) = eSQLUnique then
                  Options := Options + [ixUnique];
                SortOrder := DataSet.FieldByName(IDX_SORT_FIELD).Value;
                if SortOrder = DescendingOrder then
                  Options := Options + [ixDescending];
                FIndexDefs.Add(IdxName, FieldNames, Options);
              end;
            end else
            begin
              IdxDef := IndexDefs.Find(IdxName);
              IdxDef.Fields := IdxDef.Fields + ';' + DataSet.FieldByName(GetColumnFieldName(SQLConnection)).Value;
            end;
          end;
        end;
        DataSet.Next;
      end;
    end;
  finally
    FreeAndNil(IndexColumns);
    FSQLConnection.FreeSchemaTable(DataSet);
  end;
  FIndexDefsLoaded := True;
end;


function TCustomSQLDataSet.AddMetadataQuotes(Identifier: WideString; StoredProc: Boolean): WideString;
var
  QuoteChar:  WideString;
begin
//  if StoredProc then
//    QuoteChar := FSQLConnection.FQuoteChar
//  else
    QuoteChar := FSQLConnection.FQuoteChar;
  // We have to have a quote charachter for metadata even if the driver
  // indicates that it does not have one.  Informix driver currently
  // reports that it does not have a quote character, but allows spaces
  // in its identifiers.
  //
  if QuoteChar = '' then
    QuoteChar := '"';
  if Identifier <> '' then
    Result := QuoteChar + StringReplace(Identifier, QuoteChar, QuoteChar + QuoteChar, [rfReplaceAll]) + QuoteChar
  else
    Result := Identifier;
end;

{$IF NOT DEFINED(CLR)}
function TCustomSQLDataSet.GetKeyFieldNames(List: TStrings): Integer;
var
  wList: TWideStrings;
begin
  wList := TWideStringList.Create;
  try
    Result := GetKeyFieldNames(wList);
    List.Assign(wList);
  finally
    wList.Free
  end;
end;
{$IFEND}

function TCustomSQLDataSet.GetKeyFieldNames(List: TWideStrings): Integer;
var
  I: Integer;
begin
  if not FIndexDefsLoaded then
    AddIndexDefs(Self);
  Result := IndexDefs.Count;
  List.BeginUpdate;
  try
    List.Clear;
    for I := 0 to Result - 1 do
      List.Add(IndexDefs[I].Fields);
  finally
    List.EndUpdate;
  end;
end;

{ Schema Tables }

procedure TCustomSQLDataSet.SetSchemaInfo(SchemaType: TSchemaType; SchemaObjectName, SchemaPattern: WideString; PackageName: WideString = '' );
begin
  FreeCommand;
  FSchemaInfo.FType := SchemaType;
  FSchemaInfo.ObjectName := SchemaObjectName;
  FSchemaInfo.Pattern := SchemaPattern;
  FSchemaInfo.PackageName := PackageName;
end;

procedure TCustomSQLDataSet.OpenSchema;


  function ExtractObjectName(Value: WideString): WideString;
  var
    NamePos: Integer;
    Q: WideString;
  begin
    Result := Value;
    Q := GetQuoteChar;
    if (Q = '') or (Q = ' ') then exit;
    NamePos := Pos('.' + Q, Value);
    if NamePos = 0 then
      NamePos := Pos(Q + '.', Value);
    if NamePos = 0 then exit;
    Result := Copy(Value, NamePos + 2, Length(Value) - NamePos);
    if Pos(Q, Result) > 0 then
      Result := Copy(Result, 1, Length(Result) -1);
  end;


  function MakeDbxMetadataCommand(CommandName: WideString; Args: array of WideString): WideString;
  var
    I: Integer;
  begin
    Result := CommandName;
    for I := Low(Args) to High(Args) do
      Result := Result + ' ' + Args[I];
  end;

  procedure AppendToIdentifier(var Identifier: WideString; NewElement: WideString);
  begin
    if NewElement = '' then
    begin
      if Identifier <> '' then
        Identifier := Identifier + '.%';
    end else
    begin
      if Identifier = '' then
        Identifier := NewElement
      else
        Identifier := Identifier + '.' + NewElement;
    end;
  end;

var
  TableType:        WideString;
  Parameter:        TDBXParameter;
  Pattern:          WideString;
  ACatalogName:     WideString;
  ASchemaName:      WideString;
  Identifier:       WideString;
  DbxMetadataCommand:      WideString;
  Connection:       TSQLConnection;
  Dbx4Metadata:     Boolean;
var
  MetaData: TDBXDatabaseMetaData;
begin
  if FSQLConnection = nil then
    DatabaseError(sConnectionNameMissing);
  Pattern := FSchemaInfo.Pattern;
  Assert(FDBXReader = nil);
  Assert(FDBXCommand = nil);
  Connection := GetInternalConnection;
  MetaData := Connection.FDBXConnection.DatabaseMetaData;
  if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
    Dbx4Metadata := true
  else
    Dbx4Metadata := false;

  try

    FDBXCommand := Connection.DBXConnection.CreateCommand;
    FDBXCommand.CommandType := TDBXCommandTypes.DbxMetaData;

    Identifier := '';
    DbxMetadataCommand := '';

    case FSchemaInfo.FType of
      stTables:
        begin
          SetSchemaOption(ACatalogName, ASchemaName);

          AppendToIdentifier(Identifier, AddMetadataQuotes(ACatalogName, false));
          AppendToIdentifier(Identifier, AddMetadataQuotes(ASchemaName, false));
          AppendToIdentifier(Identifier, AddMetadataQuotes(Pattern, false));
          TableType           := GetTableScope(GetInternalConnection.FTableScope);
          DbxMetadataCommand         := MakeDbxMetadataCommand( TDBXMetaDataCommands.GetTables,
                                                  [Identifier,
                                                  TableType]);
        end;
      stSysTables:
        begin
          SetSchemaOption(ACatalogName, ASchemaName);
          AppendToIdentifier(Identifier, AddMetadataQuotes(ACatalogName, false));
          AppendToIdentifier(Identifier, AddMetadataQuotes(ASchemaName, false));
          AppendToIdentifier(Identifier, AddMetadataQuotes(Pattern, false));
          DbxMetadataCommand         := MakeDbxMetadataCommand( TDBXMetaDataCommands.GetTables,
                                                  [Identifier,
                                                  TDBXMetadataTableTypes.SystemTable]);
        end;
      stColumns:
        begin
          SetSchemaOption(ACatalogName, ASchemaName);
          AppendToIdentifier(Identifier, AddMetadataQuotes(ACatalogName, false));
          AppendToIdentifier(Identifier, AddMetadataQuotes(ASchemaName, false));
          AppendToIdentifier(Identifier, AddMetadataQuotes(FSchemaInfo.ObjectName, false));
          if not Dbx4Metadata then
            AppendToIdentifier(Identifier, AddMetadataQuotes(Pattern, false));
          DbxMetadataCommand         := MakeDbxMetadataCommand( TDBXMetaDataCommands.GetColumns,
                                                  [Identifier
                                                  ]);
        end;
      stProcedures:
        begin
          SetSchemaOption(ACatalogName, ASchemaName);
          AppendToIdentifier(Identifier, AddMetadataQuotes(ACatalogName, false));
          AppendToIdentifier(Identifier, AddMetadataQuotes(ASchemaName, false));
          if Dbx4Metadata and (FSchemaInfo.PackageName <> '') then
            AppendToIdentifier(Identifier, AddMetadataQuotes(FSchemaInfo.PackageName, false));
          AppendToIdentifier(Identifier, AddMetadataQuotes(Pattern, true));
          if Dbx4Metadata and (FSchemaInfo.PackageName <> '') then
            DbxMetadataCommand       := MakeDbxMetadataCommand( TDBXMetaDataCommandsEx.GetPackageProcedures,
                                                  [Identifier])
          else
          begin
            DbxMetadataCommand       := MakeDbxMetadataCommand( TDBXMetaDataCommands.GetProcedures,
                                                  [Identifier,
                                                  FSchemaInfo.PackageName]);
          end
        end;
      stPackages:
        begin
          DbxMetadataCommand         := MakeDbxMetadataCommand(TDBXMetaDataCommands.GetPackages, []);
        end;

      stUserNames:
        begin
          if Dbx4Metadata then
            DbxMetadataCommand       := MakeDbxMetadataCommand(TDBXMetaDataCommandsEx.GetSchemas, ['%'])
          else
            DbxMetadataCommand       := MakeDbxMetadataCommand(TDBXMetaDataCommands.GetUsers, []);
        end;

      stProcedureParams:
        begin
          SetSchemaOption(ACatalogName, ASchemaName);
          AppendToIdentifier(Identifier, AddMetadataQuotes(ACatalogName, false));
          AppendToIdentifier(Identifier, AddMetadataQuotes(ASchemaName, false));
          if Dbx4Metadata and (FSchemaInfo.PackageName <> '') then
            AppendToIdentifier(Identifier, AddMetadataQuotes(FSchemaInfo.PackageName, false));
          AppendToIdentifier(Identifier, AddMetadataQuotes(FSchemaInfo.ObjectName, true));
          if Dbx4Metadata and (FSchemaInfo.PackageName <> '') then
            DbxMetadataCommand := MakeDbxMetadataCommand( TDBXMetaDataCommandsEx.GetPackageProcedureParameters,
                                                  [Identifier])
          else
          begin
            AppendToIdentifier(Identifier, AddMetadataQuotes(Pattern, false));
            DbxMetadataCommand := MakeDbxMetadataCommand( TDBXMetaDataCommands.GetProcedureParameters,
                                                  [Identifier,
                                                   FSchemaInfo.PackageName
                                                  ]);
          end
        end;
      stIndexes:
        begin
          SetSchemaOption(ACatalogName, ASchemaName);
          AppendToIdentifier(Identifier, AddMetadataQuotes(ACatalogName, false));
          AppendToIdentifier(Identifier, AddMetadataQuotes(ASchemaName, false));
          AppendToIdentifier(Identifier, AddMetadataQuotes(FSchemaInfo.ObjectName, false));
//          if Dbx4Metadata then
//            AppendToIdentifier(Identifier, '%');

          DbxMetadataCommand         := MakeDbxMetadataCommand( TDBXMetaDataCommands.GetIndexes,
                                                  [Identifier,
                                                   FSchemaInfo.PackageName
                                                  ]);
        end;
    end;
    FDBXCommand.Text  := DbxMetadataCommand;
   // LeakStartCounter;
    try
      FDBXReader    := FDBXCommand.ExecuteQuery;
    finally
   //   LeakStopCounter();
    end;
  finally

  end;
end;

{ ProviderSupport }

procedure TCustomSQLDataSet.PSEndTransaction(Commit: Boolean);
var TransDesc: TTransactionDesc;
begin
   FSQLConnection.EndAndFreeTransaction(Commit);
end;

procedure TCustomSQLDataSet.PSExecute;
begin
   ExecSQL;
end;

{$IF DEFINED(CLR)}
function TCustomSQLDataSet.PSExecuteStatement(const ASQL: string; AParams: TParams;
  var ResultSet: TObject): Integer;
{$ELSE}
function TCustomSQLDataSet.PSExecuteStatement(const ASQL: WideString; AParams: TParams;
  ResultSet: TPSResult): Integer;
{$IFEND}
begin
  if Assigned(ResultSet) then
    Result := FSQLConnection.execute(ASQL, AParams, ResultSet)
  else
    Result := FSQLConnection.execute(ASQL, AParams);
end;


{$IF DEFINED(CLR)}
procedure TCustomSQLDataSet.PSGetAttributes(List: TList);
var
  Attr: TPacketAttribute;
begin
  inherited PSGetAttributes(List);
  Attr.Name := SLocaleCode;
  Attr.Value := Integer(FSQLConnection.LocaleCode);
  Attr.IncludeInDelta := False;
  List.Add(TObject(Attr));
end;
{$ELSE}
procedure TCustomSQLDataSet.PSGetAttributes(List: TList);
var
  Attr: PPacketAttribute;
begin
  inherited PSGetAttributes(List);
  New(Attr);
  List.Add(Attr);
  with Attr^ do
  begin
    Name := SLocaleCode;
    Value := Integer(FSQLConnection.LocaleCode);
    IncludeInDelta := False;
  end;
end;
{$IFEND}

function TCustomSQLDataSet.PSGetIndexDefs(IndexTypes: TIndexOptions): TIndexDefs;
begin
  if (not FIndexDefsLoaded) and (CommandType <> ctStoredProc)
     and (SchemaInfo.FType = stNoSchema) then
    AddIndexDefs(Self);
  Result := GetIndexDefs(IndexDefs, IndexTypes);
end;

function TCustomSQLDataSet.PSGetDefaultOrder: TIndexDef;

  function FieldsInQuery(IdxFields: string): Boolean;
  var
    I:  Integer;
    IdxFlds, Flds: TWideStrings;
    FldNames: string;
  begin
    Result := True;
    IdxFlds := TWideStringList.Create;
    try
      IdxFlds.CommaText := IdxFields;
      Flds := TWideStringList.Create;
      try
        Fields.GetFieldNames(Flds);
        FldNames := Flds.CommaText;
        for I := 0 to IdxFlds.Count -1 do
        begin
          if pos(IdxFlds[I], FldNames) = 0 then
          begin
            Result := False;
            exit;
          end;
        end;
      finally
        Flds.Free;
      end;
    finally
      IdxFlds.Free;
    end;
  end;

var
  I: Integer;
begin
  Result := inherited PSGetDefaultOrder;
  if not Assigned(Result) then
    Result := GetIndexForOrderBy(GetQueryFromType, Self);
  if (not Assigned(Result)) and
     (CommandType <> ctStoredProc) and (SchemaInfo.FType = stNoSchema) then
  begin
    if not FIndexDefsLoaded then
      AddIndexDefs(Self);
    for I := 0 to IndexDefs.Count - 1 do
    begin
      if (ixPrimary in TIndexDef(IndexDefs[I]).Options) and
         FieldsInQuery(TIndexDef(IndexDefs[I]).Fields) then
      begin
        Result := TIndexDef.Create(nil);
        Result.Assign(IndexDefs[I]);
        Break;
      end;
    end;
  end;
end;


{$IF DEFINED(CLR)}
function TCustomSQLDataSet.PSGetKeyFields: string;
var
  HoldPos, I: Integer;
  IndexFound:Boolean;
begin
  if (CommandType = ctStoredProc) or (SchemaInfo.FType <> stNoSchema) then exit;
  Result := inherited PSGetKeyFields;
  IndexFound := False;
  if (Result = '') and (SchemaInfo.FType = stNoSchema) then
  begin
    if not FIndexDefsLoaded then
      AddIndexDefs(Self);
    for I := 0 to IndexDefs.Count - 1 do
      if (ixUnique in IndexDefs[I].Options) or
         (ixPrimary in IndexDefs[I].Options) then
      begin
        Result := IndexDefs[I].Fields;
        IndexFound := (FieldCount = 0);
        if not IndexFound then
        begin
          HoldPos := 1;
          while HoldPos <= Length(Result) do
          begin
            IndexFound := FindField(ExtractFieldName(Result, HoldPos)) <> nil;
            if not IndexFound then Break;
          end;
        end;
        if IndexFound then Break;
      end;
    if not IndexFound then
      Result := '';
  end;
end;
{$ELSE}
function TCustomSQLDataSet.PSGetKeyFieldsW: WideString;
var
  HoldPos, I: Integer;
  IndexFound:Boolean;
begin
  if (CommandType = ctStoredProc) or (SchemaInfo.FType <> stNoSchema) then exit;
  Result := inherited PSGetKeyFieldsW;
  IndexFound := False;
  if (Result = '') and (SchemaInfo.FType = stNoSchema) then
  begin
    if not FIndexDefsLoaded then
      AddIndexDefs(Self);
    for I := 0 to IndexDefs.Count - 1 do
      if (ixUnique in IndexDefs[I].Options) or
         (ixPrimary in IndexDefs[I].Options) then
      begin
        Result := IndexDefs[I].Fields;
        IndexFound := (FieldCount = 0);
        if not IndexFound then
        begin
          HoldPos := 1;
          while HoldPos <= Length(Result) do
          begin
            IndexFound := FindField(ExtractFieldName(Result, HoldPos)) <> nil;
            if not IndexFound then Break;
          end;
        end;
        if IndexFound then Break;
      end;
    if not IndexFound then
      Result := '';
  end;
end;
{$IFEND}

function TCustomSQLDataSet.PSGetParams: TParams;
begin
  Result := Params;
end;

function TCustomSQLDataSet.GetQuoteChar: WideString;
begin
{$IF DEFINED(CLR)}
  Result := PSGetQuoteChar;
{$ELSE}
  Result := PSGetQuoteCharW;
{$IFEND}
end;

{$IF DEFINED(CLR)}
function TCustomSQLDataSet.PSGetQuoteChar: string;
begin
  Result := '';
  if (Assigned(FSqlConnection) and (FSQLConnection.QuoteChar <> '')) then
    Result := FSQLConnection.QuoteChar;
end;
{$ELSE}
function TCustomSQLDataSet.PSGetQuoteCharW: WideString;
begin
  Result := '';
  if (Assigned(FSqlConnection) and (FSQLConnection.QuoteChar <> '')) then
    Result := FSQLConnection.QuoteChar;
end;
{$IFEND}

procedure TCustomSQLDataSet.PSReset;
begin
  inherited PSReset;
  if Active and (not BOF) then
    First;
end;

{$IF DEFINED(CLR)}
function TCustomSQLDataSet.PSGetTableName: string;
begin
   if CommandType = ctTable then
     Result := CommandText
   else
     Result := GetTableNameFromSQLEx(CommandText, GetIdOption(FSQLConnection));
end;
{$ELSE}
function TCustomSQLDataSet.PSGetTableNameW: WideString;
begin
   if CommandType = ctTable then
     Result := CommandText
   else
     Result := GetTableNameFromSQLEx(CommandText, GetIdOption(FSQLConnection));
end;
{$IFEND}

function TCustomSQLDataSet.PSGetUpdateException(E: Exception; Prev: EUpdateError): EUpdateError;
begin
  if not Assigned(E) then
    E := EDatabaseError.Create(SErrorMappingError);
  Result := inherited PSGetUpdateException(E, Prev);
end;

function TCustomSQLDataSet.PSInTransaction: Boolean;
begin
  Result := (FSQLConnection <> nil) and (FSQLConnection.InTransaction);
end;

function TCustomSQLDataSet.PSIsSQLBased: Boolean;
var
  IsSQLBased: String;
begin
  Result := true;
  if Assigned(FSQLConnection) and (FSQLConnection.FDBXConnection is TDBXConnectionEx) then
  begin
    IsSQLBased := TDBXConnectionEx(FSQLConnection.FDBXConnection).GetVendorProperty('IsSQLBased'); { Do not localize. }
    if (IsSqlBased <> '') and (CompareText(IsSQLBased, 'false') = 0) then
      Result := false;
  end;
end;

function TCustomSQLDataSet.PSIsSQLSupported: Boolean;
begin
  Result := True;
end;

procedure TCustomSQLDataSet.PSSetParams(AParams: TParams);
begin
  if (AParams.Count <> 0) and (AParams <> Params) then
  begin
    Params.Assign(AParams);
    if Prepared and (pos(SParam, FNativeCommand) = 0) then
      SetPrepared(False);
  end;
  Close;
end;

procedure TCustomSQLDataSet.PSSetCommandText(const ACommandText: WideString);
begin
  if ACommandText <> '' then
    CommandText := ACommandText;
end;

procedure TCustomSQLDataSet.PSStartTransaction;
begin
  FSQLConnection.BeginTransaction;
end;

function TCustomSQLDataSet.PSUpdateRecord(UpdateKind: TUpdateKind; Delta: TDataSet): Boolean;
begin
  { OnUpdateRecord is not supported }
  Result := False;
end;

function TCustomSQLDataSet.QuoteIdentifier(Identifier: WideString;
  StoredProc: Boolean): WideString;
var
  QuoteChar:  WideString;
  Catalog:    WideString;
  Schema:     WideString;
  Name:       WideString;
begin
  if StoredProc then
    QuoteChar := FSQLConnection.FQuoteChar
  else
    QuoteChar := FSQLConnection.FQuoteChar;
  if Length(QuoteChar) = 0 then
    Result := Identifier
  else begin
    ParseIdentifier(Identifier, Catalog, Schema, Name);
    if Length(Catalog) > 0 then
    begin
      Result :=     QuoteChar + Catalog   + QuoteChar + '.'
                  + QuoteChar + Schema    + QuoteChar + '.'
                  + QuoteChar + Name      + QuoteChar;
    end else if Length(Schema) > 0 then
    begin
      Result :=     QuoteChar + Schema    + QuoteChar + '.'
                  + QuoteChar + Name      + QuoteChar;

    end else
    begin
      Result :=     QuoteChar + Name      + QuoteChar;
    end;
  end;
end;

function TCustomSQLDataSet.PSGetCommandText: string;
begin
  Result := CommandText;
end;

function TCustomSQLDataSet.PSGetCommandType: TPSCommandType;
begin
  Result := CommandType;
end;

function TCustomSQLDataSet.LocateRecord(const KeyFields: string; const KeyValues: Variant;
  Options: TLocateOptions; SyncCursor: Boolean): Boolean;

  function SameValue(V1, V2: Variant; IsString, CaseInsensitive,
           PartialLength: Boolean): Boolean;
  var
    V: Variant;
  begin
    if not IsString then
      Result := VarCompareValue(V1, V2) = vrEqual
    else
    begin
      if PartialLength then
        V := Copy(V1, 1, Length(V2)) { TODO -oTArisawa -cWide : Ansi ? Wide? }
      else
        V := V1;
      if CaseInsensitive then
        Result := WideLowerCase(V) = WideLowerCase(V2)
      else
        Result := V = V2;
    end;
  end;

  function CheckValues(AFields: TStrings; Values: Variant;
           CaseInsensitive, PartialLength: Boolean): Boolean;
  var
    J: Integer;
    Field: TField;
  begin
    Result := True;
    for J := 0 to AFields.Count -1 do
    begin
      Field := FieldByName(AFields[J]);
      if not SameValue(Field.Value, Values[J],
        Field.DataType in [ftString, ftFixedChar], CaseInsensitive, PartialLength) then
      begin
        Result := False;
        break;
      end;
    end;
  end;

var
  I: Integer;
  SaveFields, AFields: TStrings;
  PartialLength, CaseInsensitive: Boolean;
  Values, StartValues: Variant;
  bFound: Boolean;

begin
  CheckBrowseMode;
  CursorPosChanged;
  AFields := TStringList.Create;
  SaveFields := TStringList.Create;
  try
    AFields.CommaText := StringReplace(KeyFields, ';', ',', [rfReplaceAll]);
    PartialLength := loPartialKey in Options;
    CaseInsensitive := loCaseInsensitive in Options;
    if VarIsArray(KeyValues) then
      Values := KeyValues
    else
      Values := VarArrayOf([KeyValues]);
    { save current record in case we cannot locate KeyValues }
    StartValues := VarArrayCreate([0, FieldCount], varVariant);
    for I := 0 to FieldCount -1 do
    begin
      StartValues[I] := Fields[I].Value;
      SaveFields.Add(Fields[I].FieldName);
    end;
    First;
    while not EOF do
    begin
      if CheckValues(AFields, Values, CaseInsensitive, PartialLength) then
        break;
      Next;
    end;
    { if not found, reset cursor to starting position }
    bFound := not EOF;
    if not bFound then
    begin
      First;
      while not EOF do
      begin
        if CheckValues(SaveFields, StartValues, False, False) then
          break;
        Next;
      end;
    end;
    Result := bFound;
  finally
    AFields.Free;
    SaveFields.Free;
  end;
end;

function TCustomSQLDataSet.Locate(const KeyFields: string; const KeyValues: Variant;
  Options: TLocateOptions): Boolean;
begin
  DoBeforeScroll;
  Result := LocateRecord(KeyFields, KeyValues, Options, True);
  if Result then
  begin
    Resync([rmExact, rmCenter]);
    DoAfterScroll;
  end;
end;

function TCustomSQLDataSet.Lookup(const KeyFields: string; const KeyValues: Variant;
  const ResultFields: string): Variant;
begin
  Result := Null;
  if LocateRecord(KeyFields, KeyValues, [], False) then
  begin
    SetTempState(dsCalcFields);
    try
      CalculateFields(Nil);
      Result := FieldValues[ResultFields];
    finally
      RestoreState(dsBrowse);
    end;
  end;
end;

procedure TCustomSQLDataSet.SetSchemaName(const Value: string);
begin
  if FSchemaName <> Value then
  begin
    PropertyChanged;
    FSchemaName := Value;
  end;
end;

procedure TCustomSQLDataSet.ParseIdentifier(Identifier: WideString; var Catalog, Schema,
  Name: WideString);
var
  Start: Integer;
  IdOption: IDENTIFIEROption;
begin
  Catalog := '';
  Schema := '';
  Start := 1;
  IdOption := idMixCase;  // This is used for TSQLStoredProc and TSQLTable
  Platform_NextSQLToken(Identifier, Start, Name, stTableName, IdOption);
  if (Start < Length(Identifier)) and (Identifier[Start] = '.') then
  begin
    Schema := Name;
    Platform_NextSQLToken(Identifier, Start, Name, stTableName, IdOption);
  end;
  if (Start < Length(Identifier)) and (Identifier[Start] = '.') then
  begin
    Catalog := Schema;
    Schema := Name;
    Platform_NextSQLToken(Identifier, Start, Name, stTableName, IdOption);
  end;
end;

procedure TCustomSQLDataSet.SetSchemaOption(var ACatalogName, ASchemaName: WideString);
var
  ObjectName: WideString;
  Connection: TDBXConnection;
  Elements: TWideStringArray;
  Parameter: TDBXParameter;
begin
  ACatalogName  := '';
  ASchemaName   := '';
  ObjectName := FSchemaInfo.ObjectName;
  if ObjectName <> '' then
  begin
    Connection := GetInternalConnection.FDBXConnection;
    ParseIdentifier(ObjectName, ACatalogName, ASchemaName, FSchemaInfo.ObjectName);
  end;

  if Length(ACatalogName) = 0 then
    ACatalogName := GetInternalConnection.FParams.Values[DATABASENAME_KEY];
  (* by default, ASchemaName has been retrieved from getOption(eMetaSchemaName).
     if this is NOT set, then try TCustomDataSet.SchemaName;
     if this is NOT set, then try DefaultSchemaName;
     if this is NOT set, then try the UserName used to login;
     only if this is NOT set, get UserName from Parameter StringList *)
  if Length(ASchemaName) = 0 then
    ASchemaName := SchemaName;
  if Length(ASchemaName) = 0 then
  begin
    ASchemaName := GetInternalConnection.DefaultSchema;
    if (Length(ASchemaName) <= 0) then
    begin
      // This is mostly for Interbase's benefit.
      //
      ASchemaName := GetInternalConnection.GetLoginUsername;
      if (Length(ASchemaName) <= 0) then
        ASchemaName := GetInternalConnection.FParams.Values[TDBXPropertyNames.UserName];
    end;
  end;
end;
{ TSQLDataSet }

constructor TSQLDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCommandType := ctQuery;
  FGetMetadata := True;
end;

function TSQLDataSet.ExecSQL(ExecDirect: Boolean = False): Integer;
begin
  Result := inherited ExecSQL(ExecDirect);
end;

{ TSQLQuery }

constructor TSQLQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCommandType := ctQuery;
  FSQL := TWideStringList.Create;
  FGetMetaData := False;
  TWideStringList(SQL).OnChange := QueryChanged;
end;

destructor TSQLQuery.Destroy;
begin
  FSQL.Free;
  inherited Destroy;
end;

function TSQLQuery.ExecSQL(ExecDirect: Boolean = False): Integer;
begin
  Result := inherited ExecSQL(ExecDirect);
end;

procedure TSQLQuery.PrepareStatement;
var
  Start: Integer;
  SQLText: Widestring;
  CurSection: TSqlToken;
  Value: WideString;
begin
  if FCommandText = '' then
    SetSQL(SQL);
  if Length(CommandText) = 0 then
    DatabaseError(SEmptySQLStatement, Self);
  CurSection := stUnknown;
  Start := 1;
  CurSection := Platform_NextSQLToken(CommandText, Start, Value, CurSection, GetIdOption(FSQLConnection));
  if CurSection = stSelect then
    Inc(FSQLConnection.FSelectStatements);
  CheckStatement;
  SQLText := FNativeCommand;
  FDBXCommand.CommandType := FDbxCommandType;
  FDBXCommand.Text := SQLText;
  FDBXCommand.Parameters.SetCount(Params.Count);
  FDBXCommand.Prepare;
end;

procedure TSQLQuery.QueryChanged(Sender: TObject);
begin
  if not (csReading in ComponentState) then
  begin
    Close;
    SetPrepared(False);
    if ParamCheck or (csDesigning in ComponentState) then
    begin
      FCommandText := SQL.Text;
      FText := FCommandText;
      SetParamsFromSQL(nil, False);
    end
    else
      FText := SQL.Text;
{$IF DEFINED(CLR)}
    DataEvent(dePropertyChange, nil);
{$ELSE}
    DataEvent(dePropertyChange, 0);
{$IFEND}
  end
  else
    FText := FParams.ParseSQL(SQL.Text, False);
  SetFCommandText(FText);
end;

procedure TSQLQuery.SetSQL(Value: TWideStrings);
begin
  if SQL.Text <> Value.Text then
  begin
    Close;
    SQL.BeginUpdate;
    try
      SQL.Assign(Value);
    finally
      SQL.EndUpdate;
    end;
  end;
end;

{ TSQLStoredProc }

constructor TSQLStoredProc.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCommandType := ctStoredProc;
  FGetMetadata := True;
end;

function TSQLStoredProc.ExecProc: Integer;
begin
  Result := ExecSQL;
end;

procedure TSQLStoredProc.PrepareStatement;
var
  SQLText: Widestring;
begin
  if FCommandText = '' then
    SetStoredProcName(FStoredProcName);
  if Length(CommandText) = 0 then
    DatabaseError(SEmptySQLStatement, Self);
  CheckStatement;
  FDBXCommand.CommandType := TDBXCommandTypes.DbxStoredProcedure;
  if FSchemaName <> '' then
    SQLText := QuoteIdentifier(FSchemaName + '.' + FNativeCommand, true)
  else
    SQLText := QuoteIdentifier(FNativeCommand, true);
  if FPackageName <> '' then
    SQLText := QuoteIdentifier(FPackageName + '.' + FNativeCommand, true);
  FDBXCommand.Text := SQLText;
  FDBXCommand.Parameters.SetCount(Params.Count);
  FDBXCommand.Prepare;
end;

procedure TSQLStoredProc.SetStoredProcName(Value: WideString);
begin
  //if FStoredProcName <> Value then
  //begin
    FStoredProcName := Value;
    SetCommandText(Value);
    if Assigned(FProcParams) then  // free output params if any
      FreeProcParams(FProcParams);
  //end;
end;

procedure TSQLStoredProc.SetPackageName(Value: WideString);
begin
  if FPackageName <> Value then
  begin
    FPackageName := Value;
    FSchemaInfo.PackageName := Value;
    if Assigned(FProcParams) then
      FreeProcParams(FProcParams);
    FStoredProcName := '';
    SetCommandText('');
  end;
end;

function TSQLStoredProc.NextRecordSet: TCustomSQLDataSet;
begin
  FGetNextRecordSet := True;
  SetState(dsInactive);
  CloseCursor;
  if Assigned(FieldDefs) then
    FieldDefs.Updated := False;
  try
    Active := True;
  finally
    FGetNextRecordSet := False;
  end;
  if Assigned(FDBXReader) then
    Result := TCustomSQLDataSet(Self)
  else
    Result := Nil;
end;

{ TSQLTable }

constructor TSQLTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCommandType := ctTable;
  FGetMetadata := True;
  FIndexFieldCount := -1;
  FMasterLink := TMasterDataLink.Create(Self);
  FIndexFields := TList.Create;
end;

destructor TSQLTable.Destroy;
begin
  FreeAndNil(FMasterLink);
  FreeAndNil(FIndexFields);
  inherited Destroy;
end;

procedure TSQLTable.DeleteRecords;
begin
  SQLConnection.ExecuteDirect('delete from ' + TableName);   { do not localize }
end;

function TSQLTable.GetIndexField(Index: Integer): TField;
begin
  if IndexName = '' then Result := nil
  else
  begin
    if FIndexFieldCount = -1 then
      RefreshIndexFields;
    Result := TField(FIndexFields[Index]);
  end;
end;

function TSQLTable.GetIndexFieldCount: Integer;
begin
  if IndexName = '' then Result := 0
  else if FIndexFieldCount >= 0 then Result := FIndexFieldCount
  else Result := RefreshIndexFields;
end;

procedure TSQLTable.GetIndexNames(List: TWideStrings);
begin
  FSQLConnection.GetIndexNames(FTableName,List);
end;

procedure TSQLTable.OpenCursor(InfoQuery: Boolean);
begin
  inherited OpenCursor(InfoQuery);
  if not FIsDetail and not FIndexDefsLoaded then
    AddIndexDefs(Self);
end;

procedure TSQLTable.AddParamsToQuery;
var
  I: Integer;
  Value: string;
begin
  if Pos('?', NativeCommand) = 0 then
  begin
    for I := 0 to Params.Count -1 do
    begin
      if Params[I].IsNull then
        Value := 'is NULL'
      else
        Value := '= ?';
      if I = 0 then
        NativeCommand := format('%s%s(%s %s)', [NativeCommand, SWhere, Params[I].Name, Value])
      else
        NativeCommand := format('%s%s(%s %s)', [NativeCommand, SAnd, Params[I].Name, Value]);
    end;
  end;
end;

procedure TSQLTable.SetDataSource(Value: TDataSource);
begin
  inherited SetDataSource(Value);
end;

function TSQLTable.GetQueryFromType: WideString;
begin
  if FNativeCommand <> '' then
    Result := FNativeCommand
  else
    Result := inherited GetQueryFromType;
end;

procedure TSQLTable.PrepareStatement;

  function GetFieldsForIndexName(IndexName: WideString): WideString;
  var
    DataSet:      TCustomSQLDataSet;
    IdxName:      WideString;
    Dbx4Metadata: Boolean;
    IndexColumns: TDBXIndexColumns;
    MetaData:     TDBXDatabaseMetaData;
  begin
    DataSet := FSQLConnection.OpenSchemaTable(stIndexes, TableName,'','','');
    try
      MetaData := FSQLConnection.FDBXConnection.DatabaseMetaData;
      if (MetaData is TDBXDatabaseMetaDataEx) and (TDBXDatabaseMetaDataEx(MetaData).MetaDataVersion = DBXVersion40) then
      begin
        while not DataSet.EOF do
        begin
          IdxName := DataSet.FieldByName(GetIndexFieldName(FSQLConnection)).Value;
          if IdxName = IndexName then
          begin
            IndexColumns := TDBXIndexColumns.Create;
            try
              IndexColumns.FGetIndexesText := DataSet.FDBXCommand.Text;
              IndexColumns.FSqlConnection := DataSet.FSQLConnection;
              IndexColumns.Open;
              Result := IndexColumns.GetFieldNames(IdxName);
              exit;
            finally
              IndexColumns.Free;
            end;
          end;
          DataSet.Next;
        end;
      end else
      begin
        while not DataSet.EOF do
        begin
          IdxName := DataSet.FieldByName(GetIndexFieldName(FSQLConnection)).Value;
          if IdxName = IndexName then
          begin
            if Result = '' then
              Result := DataSet.FieldByName(GetColumnFieldName(FSQLConnection)).Value
            else
              Result := Result + ';' + DataSet.FieldByName(GetColumnFieldName(FSQLConnection)).Value;
          end;
          DataSet.Next;
        end;
      end;
    finally
      FSQLConnection.FreeSchemaTable(DataSet);
    end;
  end;

  function GetIndexFieldNames(FieldNames, IndexName: WideString): WideString;
  begin
    if (FieldNames = '') and (IndexName = '') then
      Result := ''
    else if FieldNames <> '' then
      Result := FieldNames
    else
      Result := GetFieldsForIndexName(IndexName);
  end;

var
  FDetailWhere, SQLText, IdxFieldNames: Widestring;
  FIndex, Pos1, Pos2: Integer;
  FName1, FName2, TempString1, TempString2: WideString;
  STableName : WideString;
begin  // first, convert TableName into valid Query.
  if Length(FTableName) = 0 then
    DatabaseError(SEmptySQLStatement, Self);
  if FNativeCommand = '' then  // otherwise, already prepared
  begin
    if (FDataLink.DataSource <> nil) and (MasterFields <> '') then
    begin
      FIsDetail := True;
      Pos1 := 1;
      Pos2 := 1;
      FIndex := 1;
      TempString1 := MasterFields;
      TempString2 := IndexFieldNames;
      while Pos1 <= Length(TempString1) do
        begin
          FName1 := ExtractFieldName(TempString1, Pos1);
          FName2 := ExtractFieldName(TempString2, Pos2);
          if FName1 = '' then Break;
          if FIndex = 1 then
            FDetailWhere := SWhere
          else
            FDetailWhere := FDetailWhere + SAnd;
          if FName2 = '' then
            FDetailWhere := FDetailWhere + FName1 + ' = :' + FName1
          else
            FDetailWhere := FDetailWhere + FName2 + ' = :' + FName1;
          Inc(FIndex);
        end;
      FCommandType := ctQuery;
      SetCommandText(SSelectStarFrom + QuoteIdentifier(FTableName, false)
                      + FDetailWhere);
    end else
    begin
      FIsDetail := False;
      IdxFieldNames := GetIndexFieldNames(IndexFieldNames, IndexName);
      if Self.FSchemaName <> '' then
        STableName := QuoteIdentifier(FSchemaName + '.' + FTableName, false)
      else
        STableName := QuoteIdentifier(FTableName, false);
      if IdxFieldNames = '' then
        FCommandText := SSelectStarFrom + STableName
      else
        FCommandText := SSelectStarFrom + STableName
                     + SOrderBy + StringReplace(IdxFieldNames, ';', ',', [rfReplaceAll]);
    end;
  end else if Params.Count > 0 then
    AddParamsToQuery;

  Inc(FSQLConnection.FSelectStatements);
  CheckStatement;
  SQLText := FNativeCommand;
  FDBXCommand.CommandType := FDbxCommandType;
  FDBXCommand.Text := SQLText;
  FDBXCommand.Parameters.SetCount(Params.Count);
  FDBXCommand.Prepare;
  FCommandType := ctTable;
  FCommandText := FTableName;
end;

function TSQLTable.RefreshIndexFields: Integer;
var
  I, Pos: Integer;
  Temp: WideString;
  FField: TField;
begin
  Result := 0;
  if not FIndexDefsLoaded then
    AddIndexDefs(Self);
  FIndexFields.Clear;
  for I := 0 to IndexDefs.Count - 1 do
  begin
    if WideCompareText(IndexDefs[I].Name, IndexName) = 0 then
    begin
      Temp := IndexDefs[I].Fields;
      Pos := 1;
      while Pos <= Length(Temp) do
      begin
        FField := FindField(ExtractFieldName(Temp, Pos));
        if FField = nil then
          Break
        else
          FIndexFields.Add(FField);
        Inc(Result);
      end;
      Break;
    end;
  end;
end;

function TSQLTable.GetMasterFields: WideString;
begin
  Result := FMasterLink.FieldNames;
end;

procedure TSQLTable.SetMasterFields(Value: WideString);
begin
  FMasterLink.FieldNames := Value;
  if not (csLoading in ComponentState) then
  begin
    Close;
    FreeCommand;
    FNativeCommand := '';
    FParams.clear;
  end;
end;

procedure TSQLTable.SetTableName(Value: WideString);
begin
  if FTableName <> Value then
  begin
    FNativeCommand := '';
    FTableName := Value;
    SetCommandText(Value);
  end;
end;

procedure TSQLTable.SetIndexFieldNames(Value: WideString);
begin
  if FIndexFieldNames <> Value then
  begin
    if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
      if (TableName = '') and (Value <> '') then DatabaseError(SNoTableName,Self);
    FIndexFieldNames := Value;
    if FIndexFieldNames <> '' then
      SetIndexName('');
    FNativeCommand := '';
    SetPrepared(False);
  end;
end;

procedure TSQLTable.SetIndexField(Index: Integer; Value: TField);
begin
  GetIndexField(Index).Assign(Value);
end;

procedure TSQLTable.SetIndexName(Value: WideString);
begin
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
    if (TableName = '') and (Value <> '') then DatabaseError(SNoTableName,Self);
  if FIndexName <> Value then
  begin
    FIndexName := Value;
    FNativeCommand := '';
    if Assigned(FSQLConnection) and (Value <> '') then
    begin
      SetIndexFieldNames('');  // clear out IndexFieldNames
      if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
        AddIndexDefs(Self, Value);
    end;
    SetPrepared(False);
  end;
  FIndexFieldCount := -1;
end;

//{$IFDEF MSWINDOWS}
//procedure RegisterDbXpressLib(GetClassProc: Pointer);
//begin
//  GetDriver := GetClassProc;
//  DllHandle := THandle(1);
//end;
//{$ENDIF}

{ TIniFileConnectionFactory }

//constructor TIniFileConnectionFactory.Create(AOwner: TComponent);
//begin
//  inherited Create(AOwner);
//  FDBXConnectionFactory := TDBXIniFileConnectionFactory.Create;
//end;
//
//destructor TIniFileConnectionFactory.Destroy;
//begin
//  FreeAndNil(FDBXConnectionFactory);
//end;
//
//function TIniFileConnectionFactory.GetConnectionFactory: TDBXConnectionFactory;
//begin
//  if not FOpen then
//    FDBXConnectionFactory.Open;
//  Result := FDBXConnectionFactory;
//end;
//
//function TIniFileConnectionFactory.GetConnectionsFile: WideString;
//begin
//  Result := FDBXConnectionFactory.ConnectionsFile;
//end;
//
//function TIniFileConnectionFactory.GetDriversFile: WideString;
//begin
//  Result := FDBXConnectionFactory.DriversFile;
//end;
//
//procedure TIniFileConnectionFactory.SetConnectionsFile(
//  ConnectionsFile: WideString);
//begin
//  FDBXConnectionFactory.ConnectionsFile := ConnectionsFile;
//end;
//
//procedure TIniFileConnectionFactory.SetDriversFile(
//  DriversFile: WideString);
//begin
//  FDBXConnectionFactory.DriversFile := DriversFile;
//end;
//
{ TDBXIndexColumns }

constructor TDBXIndexColumns.Create;
begin
  inherited Create;
  FColumns := TObjectList.Create;
  FColumns.OwnsObjects := true;
end;

destructor TDBXIndexColumns.Destroy;
var
  Index: Integer;
begin
  FreeAndNil(FColumns);
end;


function TDBXIndexColumns.GetFieldNames(IndexName: WideString): String;
var
  IndexColumn:  TDBXIndexColumn;
  Index:        Integer;
begin
  Result := '';
  for Index := 0 to FColumns.Count - 1 do
  begin
    IndexColumn := TDBXIndexColumn(FColumns[Index]);
    if IndexColumn.FIndexName = IndexName then
    begin
      if Result = '' then
        Result := IndexColumn.FColumnName
      else
        Result := Result + ';' + IndexColumn.FColumnName;
    end;
  end;
end;

function TDBXIndexColumns.HasAllFieldNames(IndexName: WideString;
  DataSet: TCustomSQLDataSet; var FieldNames: String;
  var FirstColumnAscending: Boolean): Boolean;
var
  IndexColumn:  TDBXIndexColumn;
  MissingField: Boolean;
  StartIndex:   Integer;
  LastIndex:    Integer;
  Index:        Integer;
begin
  StartIndex    := -1;
  MissingField  := False;
  for Index := 0 to FColumns.Count - 1 do
  begin
    IndexColumn := TDBXIndexColumn(FColumns[Index]);
    if IndexColumn.FIndexName = IndexName then
    begin
      if DataSet.FindField(IndexColumn.FColumnName) = nil then
      begin
        Result := false;
        exit;
      end;
      if StartIndex = -1 then
        StartIndex := Index;
      LastIndex := Index;
    end;
  end;
  FieldNames := '';
  FirstColumnAscending := true;

  if StartIndex < 0 then
    Result := false
  else
  begin
    for Index := StartIndex to LastIndex do
    begin
      IndexColumn := TDBXIndexColumn(FColumns[Index]);
      if Index = StartIndex then
      begin
        FirstColumnAscending := IndexColumn.FAscending;
        FieldNames := IndexColumn.FColumnName;
      end else
        FieldNames := FieldNames + ';' + IndexColumn.FColumnName;
    end;
    Result := True;
  end;
end;

procedure TDBXIndexColumns.Open;
var
  Reader:     TDBXReader;
  Column:     TDBXIndexColumn;
  StartIndex: Integer;
  Count:      Integer;
  Command:    TDBXCommand;
  Connection: TSQLConnection;
begin
  Command   := nil;
  Reader    := nil;
  Connection := FSqlConnection.GetConnectionForStatement;
  Command := Connection.FDBXConnection.CreateCommand;
  try
    StartIndex  := Length(TDBXMetaDataCommands.GetIndexes);
    Count       := Length(FGetIndexesText) - StartIndex;
    Command.Text := TDBXMetaDataCommands.GetIndexColumns
                        + Copy(FGetIndexesText, StartIndex+1, Count);
    Command.CommandType := TDBXCommandTypes.DbxMetaData;
    Reader := Command.ExecuteQuery;
    while Reader.Next do
    begin
      Column := TDBXIndexColumn.Create;
      Column.FIndexName   := Reader.Value['IndexName'].GetWideString; {Do not Localize}
      Column.FColumnName  := Reader.Value['ColumnName'].GetWideString; {Do not Localize}
      Column.FOrdinal     := Reader.Value['Ordinal'].GetInt32; {Do not Localize}
      Column.FAscending   := Reader.Value['IsAscending'].GetBoolean; {Do not Localize}
      FColumns.Add(Column);
    end;
  finally
    if (Connection <> nil) and Connection.FIsCloned then
      Connection.Free;
    FreeAndNil(Command);
    FreeAndNil(Reader);
  end;
end;

end.
