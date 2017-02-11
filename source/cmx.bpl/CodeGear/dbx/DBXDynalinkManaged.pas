unit DBXDynalinkManaged;

interface

uses DBXCommon, DBXDynalink,
     Borland.Vcl.DBCommonTypes,
     DBXPlatform,
     Windows,System.Runtime.InteropServices, System.Text, FMTBcd,
     ClassRegistry,
     SqlTimSt, SysUtils;


type

TManagedMethodTable = class(TDBXMethodTable)
  strict private
    FLibraryHandle:    HModule;
  public
    constructor Create(LibraryHandle: HModule);
    destructor Destroy; override;
    function LoadMethod(MethodName: WideString): IntPtr; override;
    procedure LoadMethods; override;

end;

  TDBXDynalinkDriverLoader = class(TDBXDynalinkDriverCommonLoader)
    strict protected
//      procedure LoadDriverLibrary(DriverProperties: TDBXProperties; DBXContext: TDBXContext); override;
      function  CreateMethodTable(): TDBXMethodTable; override;
      function  CreateDynalinkDriver: TDBXDynalinkDriver; override;
  public
    constructor Create;
  end;



  TDBXDynalinkDriverManaged = class(TDBXDynalinkDriver)
    public
      constructor Create(DriverClone: TDBXDriver; DriverHandle: TDBXDriverHandle; MethodTable: TDBXMethodTable);
      function CreateConnection(ConnectionBuilder:  TDBXConnectionBuilder): TDBXConnection; override;
  end;

implementation

var
  DriverLoader: TDBXDynalinkDriverLoader;

[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXLoader_GetDriver)]
function DBXLoader_GetDriver([in]Count: TInt32; [in]Names, [in]Values: TWideStringArray; [out]ErrorMessage: StringBuilder; out [out]DriverHandle: TDBXDriverHandle): TDBXErrorCode; external;

// DBXBase.

[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXBase_GetErrorMessageLength)]
function DBXBase_GetErrorMessageLength([in]DBX_Handle: TDBXCommonHandle; [in]LastErrorCode: TDBXErrorCode; out [out]ErrorLen: TInt32): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXBase_GetErrorMessage)]
function DBXBase_GetErrorMessage([in]DBX_Handle: TDBXCommonHandle; [in]LastErrorCode: TDBXErrorCode; [out]ErrorMessage: TDBXWideStringVar): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXBase_Close)]
function DBXBase_Close([in]Handle: TDBXCommonHandle): TDBXErrorCode; external;

// DBXRow.

[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Ansi, EntryPoint = SDBXRow_GetString)]
function DBXRow_GetString([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; [out]Value: TDBXAnsiStringVar; out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetWideString)]
function DBXRow_GetWideString([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; [out]Value: TDBXWideStringVar; out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetBoolean)]
function DBXRow_GetBoolean([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; out [out]Value: LongBool; out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetInt16)]
function DBXRow_GetInt16([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; out [out]Value: SmallInt; out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetInt32)]
function DBXRow_GetInt32([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; out [out]Value: LongInt; out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetInt64)]
function DBXRow_GetInt64([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; out [out]Value: Int64; out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetDouble)]
function DBXRow_GetDouble([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; out [out]Value: double; out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetBcd)]
function DBXRow_GetBcd([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; out [out]Value: TBcd; out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetTimeStamp)]
function DBXRow_GetTimeStamp([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; out [out]Value: TSQLTimeStamp; out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetTime)]
function DBXRow_GetTime([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; out [out]Value: TDBXTime; out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetDate)]
function DBXRow_GetDate([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; out [out]Value: TDBXDate; out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetByteLength)]
function DBXRow_GetByteLength([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; out [out]Length: Int64; out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetFixedBytes)]
function DBXRow_GetFixedBytes([in]Handle: TDBXRowHandle;
                        [in]Ordinal: TInt32;
                        [out]Value: TBytes; const [in]LastIndex: TInt32;{dummy to simulate native "open array"}
                        [in]ValueOffset: TInt32;
                        out [out]IsNull: LongBool): TDBXErrorCode; external;
//[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetBinary)]
//function DBXRow_GetBinary([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; [out]Value: TPointer;
//                                        out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetBytes)]
function DBXRow_GetBytes([in]Handle: TDBXRowHandle;
                        [in]Ordinal: TInt32;
                        [in]Offset: Int64;
                        [out]Value: TBytes; const [in]LastIndex: TInt32;{dummy to simulate native "open array"}
                        [in]ValueOffset,
                        Length: Int64;
                        out [out]ReturnLength: Int64;
                        out [out]IsNull: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXRow_GetObjectTypeName)]
function DBXRow_GetObjectTypeName([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32; [out]Value: TDBXWideStringVar; [in]MaxLength: TInt32): TDBXErrorCode; external;

// DBXWritableRow.

[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Ansi, EntryPoint = SDBXWritableRow_SetNull)]
function DBXWritableRow_SetNull([in]Handle: TDBXWritableRowHandle; [in]Ordinal: TInt32): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Ansi, EntryPoint = SDBXWritableRow_SetString)]
function DBXWritableRow_SetString([in]Handle: TDBXWritableRowHandle; [in]Ordinal: TInt32; [in]const Value: TDBXAnsiString; [in]Length: Int64): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXWritableRow_SetWideString)]
function DBXWritableRow_SetWideString([in]Handle: TDBXWritableRowHandle; [in]Ordinal: TInt32; [in]const Value: TDBXWideString; [in]Length: Int64): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXWritableRow_SetBoolean)]
function DBXWritableRow_SetBoolean([in]Handle: TDBXWritableRowHandle; [in]Ordinal: TInt32; [in]Value: LongBool): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXWritableRow_SetInt16)]
function DBXWritableRow_SetInt16([in]Handle: TDBXWritableRowHandle; [in]Ordinal: TInt32; [in]Value: SmallInt): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXWritableRow_SetInt32)]
function DBXWritableRow_SetInt32([in]Handle: TDBXWritableRowHandle; [in]Ordinal: TInt32; [in]Value: LongInt): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXWritableRow_SetInt64)]
function DBXWritableRow_SetInt64([in]Handle: TDBXWritableRowHandle; [in]Ordinal: TInt32; [in]Value: Int64): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXWritableRow_SetDouble)]
function DBXWritableRow_SetDouble([in]Handle: TDBXWritableRowHandle; [in]Ordinal: TInt32; [in]Value: double): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXWritableRow_SetBcd)]
function DBXWritableRow_SetBcd([in]Handle: TDBXWritableRowHandle; [in]Ordinal: TInt32; [in]Value: TBcd): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXWritableRow_SetTimeStamp)]
function DBXWritableRow_SetTimeStamp([in]Handle: TDBXWritableRowHandle; [in]Ordinal: TInt32; var [in]Value: TSQLTimeStamp): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXWritableRow_SetTime)]
function DBXWritableRow_SetTime([in]Handle: TDBXWritableRowHandle; [in]Ordinal: TInt32; [in]Value: TDBXTime): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXWritableRow_SetDate)]
function DBXWritableRow_SetDate([in]Handle: TDBXWritableRowHandle; [in]Ordinal: TInt32; [in]Value: TDBXDate): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXWritableRow_SetBinary)]
function DBXWritableRow_SetBinary([in]Handle: TDBXWritableRowHandle; [in]Ordinal: TInt32; [in]Value: TPointer;
                                        [in]Length: Int64): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXWritableRow_SetBytes)]
function DBXWritableRow_SetBytes( [in]Handle: TDBXWritableRowHandle;
                                  [in]Ordinal: TInt32;
                                  [in]BlobOffset: Int64;
                                  [in]Value: TBytes; LastIndex: TInt32;{dummy to simulate native "open array"}
                                  [in]ValueOffset: Int64;
                                  [in]Length: Int64): TDBXErrorCode; external;


[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXDriver_CreateConnection)]
function DBXDriver_CreateConnection([in]Handle: TDBXDriverHandle; out [out]pConn: TDBXConnectionHandle): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXDriver_GetVersion)]
function DBXDriver_GetVersion([in]Handle: TDBXDriverHandle; [out]Version: TDBXWideStringVar; [in]MaxLength: TInt32): TDBXErrorCode; external;

// DBXConnection.

[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXConnection_Connect)]
function DBXConnection_Connect([in]Handle: TDBXConnectionHandle;  [in]Count: TInt32; [in]Names, [in]Values: TWideStringArray): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXConnection_Disconnect)]
function DBXConnection_Disconnect([in]Handle: TDBXConnectionHandle): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXConnection_SetCallbackEvent)]
function DBXConnection_SetCallbackEvent([in]Handle: TDBXConnectionHandle; [in]CallbackHandle: DBXCallbackHandle; [in]CallbackEvent: DBXTraceCallback): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXConnection_CreateCommand)]
function DBXConnection_CreateCommand([in]Handle: TDBXConnectionHandle; [in] const CommandType: TDBXWideString; out [out]pCommand: TDBXCommandHandle): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXConnection_BeginTransaction)]
function DBXConnection_BeginTransaction([in]Handle: TDBXConnectionHandle; out [out]TransactionHandle: TDBXTransactionHandle; [in]IsolationLevel: TInt32): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXConnection_Commit)]
function DBXConnection_Commit([in]Handle: TDBXConnectionHandle; [in]TransactionHandle: TDBXTransactionHandle): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXConnection_Rollback)]
function DBXConnection_Rollback([in]Handle: TDBXConnectionHandle; [in]TransactionHandle: TDBXTransactionHandle): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXConnection_GetIsolation)]
function DBXConnection_GetIsolation([in]Handle: TDBXConnectionHandle; out [out]IsolationLevel: TInt32): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXConnection_GetVendorProperty)]
function DBXConnection_GetVendorProperty([in]Handle: TDBXConnectionHandle; [in]Name: String; [out]Value: TDBXWideStringVar; [in]MaxLength: TInt32): TDBXErrorCode; external;
//[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXConnection_SetProperty)]
//function DBXConnection_SetProperty([in]Handle: TDBXConnectionHandle; [in]Name: String; [in]Value: String): TDBXErrorCode; external;

// DBXCommand.


[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXCommand_CreateParameterRow)]
function DBXCommand_CreateParameterRow([in]Handle: TDBXCommandHandle; out [out]parametersHandle: TDBXRowHandle): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXCommand_Prepare)]
function DBXCommand_Prepare([in]Handle: TDBXCommandHandle; [in] const SQL: TDBXWideString; [in]Count: TInt32): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXCommand_Execute)]
function DBXCommand_Execute([in]Handle: TDBXCommandHandle; out [out]Reader: TDBXReaderHandle): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXCommand_ExecuteImmediate)]
function DBXCommand_ExecuteImmediate([in]Handle: TDBXCommandHandle; [in] const SQL: TDBXWideString; out [out]Reader: TDBXReaderHandle): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXCommand_GetNextReader)]
function DBXCommand_GetNextReader([in]Handle: TDBXCommandHandle; out [out]Reader: TDBXReaderHandle): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXCommand_GetRowsAffected)]
function DBXCommand_GetRowsAffected([in]Handle: TDBXCommandHandle; out [out]Rows: Int64): TDBXErrorCode; external;

[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXCommand_SetMaxBlobSize)]
function DBXCommand_SetMaxBlobSize([in]Handle: TDBXCommandHandle; [in]MaxBlobSize: Int64): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXCommand_SetRowSetSize)]
function DBXCommand_SetRowSetSize([in]Handle: TDBXCommandHandle; [in]RowSetSize: Int64): TDBXErrorCode; external;

// DBXParameterRow.

[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXParameterRow_SetParameterType)]
function DBXParameterRow_SetParameterType([in]Handle: TDBXRowHandle; [in]Ordinal: TInt32;
                                        [in]const Name: TDBXWideString; [in]ChildPosition: TInt32; [in]eParamType: TDBXParameterDirection;
                                        [in]DBXType: TDBXType; [in]DBXSubType: TDBXType;
                                        [in]Size: Int64; [in]Precision: Int64; [in]Scale: TInt32): TDBXErrorCode; external;


// DBXReader.


[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXReader_GetColumnCount)]
function DBXReader_GetColumnCount([in]Handle: TDBXReaderHandle; out [out]ColumnCount: TInt32): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXReader_GetColumnMetadata)]
function DBXReader_GetColumnMetadata([in]Handle: TDBXReaderHandle; [in]Ordinal: TInt32; [out]ColumnName: TDBXWideStringVar; out [out]ColumnType: TInt32; out [out]ColumnSubType: TInt32; out [out]Length: TInt32; out [out]precision: TInt32; out [out]scale: TInt32; out [out]flags: TInt32): TDBXErrorCode; external;
[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXReader_Next)]
function DBXReader_Next([in]Handle: TDBXReaderHandle): TDBXErrorCode; external;


{ TDBXDynalinkDriverManaged }


constructor TDBXDynalinkDriverManaged.Create(DriverClone: TDBXDriver; DriverHandle: TDBXDriverHandle; MethodTable: TDBXMethodTable);
begin
  inherited Create(DriverClone, DriverHandle, MethodTable);
end;

function TDBXDynalinkDriverManaged.CreateConnection(ConnectionBuilder:  TDBXConnectionBuilder): TDBXConnection;
var
  ConnectionHandle: TDBXConnectionHandle;
  DBXResult:      TDBXErrorCode;
begin
  DBXResult := FMethodTable.FDBXDriver_CreateConnection(FDriverHandle, ConnectionHandle);
  CheckResult(DbxResult);
  Result := TDBXDynalinkConnection.Create(ConnectionBuilder, ConnectionHandle, FMethodTable);
end;



{ TManagedMethodTable }

constructor TManagedMethodTable.Create(LibraryHandle: HModule);
begin
  FLibraryHandle := LibraryHandle;
  inherited Create;
end;

destructor TManagedMethodTable.Destroy;
begin

  inherited;
end;

procedure TManagedMethodTable.LoadMethods;
begin
  inherited;
//  FDBXLoader_GetDriver :=             DBXLoader_GetDriver;
  FDBXLoader_GetDriver :=             TDBXLoader_GetDriver(Marshal.GetDelegateForFunctionPointer(LoadMethod(SDBXLoader_GetDriver), Typeof(TDBXLoader_GetDriver)));
//  FDBXLoader_GetDriver :=             TDBXLoader_GetDriver(Marshal.GetDelegateForFunctionPointer(LoadMethod(SDBXLoader_GetDriver), TDBXLoader_GetDriver);

  FDBXBase_GetErrorMessageLength :=   DBXBase_GetErrorMessageLength;
  FDBXBase_GetErrorMessage :=         DBXBase_GetErrorMessage;
  FDBXBase_Close :=                   DBXBase_Close;

  FDBXRow_GetString :=                DBXRow_GetString;
  FDBXRow_GetWideString :=            DBXRow_GetWideString;
  FDBXRow_GetBoolean :=               DBXRow_GetBoolean;
  FDBXRow_GetInt16 :=                 DBXRow_GetInt16;
  FDBXRow_GetInt32 :=                 DBXRow_GetInt32;
  FDBXRow_GetInt64 :=                 DBXRow_GetInt64;
  FDBXRow_GetDouble :=                DBXRow_GetDouble;
  FDBXRow_GetBcd :=                   DBXRow_GetBcd;
  FDBXRow_GetTimeStamp :=             DBXRow_GetTimeStamp;
  FDBXRow_GetTime :=                  DBXRow_GetTime;
  FDBXRow_GetDate :=                  DBXRow_GetDate;
  FDBXRow_GetFixedBytes :=            DBXRow_GetFixedBytes;
  FDBXRow_GetByteLength :=            DBXRow_GetByteLength;
//  FDBXRow_GetBinary :=                DBXRow_GetBinary;
  FDBXRow_GetBytes :=                 DBXRow_GetBytes;
  FDBXRow_GetObjectTypeName :=        DBXRow_GetObjectTypeName;

  FDBXWritableRow_SetNull :=          DBXWritableRow_SetNull;
  FDBXWritableRow_SetString :=        DBXWritableRow_SetString;
  FDBXWritableRow_SetWideString :=    DBXWritableRow_SetWideString;
  FDBXWritableRow_SetBoolean :=       DBXWritableRow_SetBoolean;
  FDBXWritableRow_SetInt16 :=         DBXWritableRow_SetInt16;
  FDBXWritableRow_SetInt32 :=         DBXWritableRow_SetInt32;
  FDBXWritableRow_SetInt64 :=         DBXWritableRow_SetInt64;
  FDBXWritableRow_SetDouble :=        DBXWritableRow_SetDouble;
  FDBXWritableRow_SetBcd :=           DBXWritableRow_SetBcd;
  FDBXWritableRow_SetTimeStamp :=     DBXWritableRow_SetTimeStamp;
  FDBXWritableRow_SetTime :=          DBXWritableRow_SetTime;
  FDBXWritableRow_SetDate :=          DBXWritableRow_SetDate;
//  FDBXWritableRow_SetBinary :=        DBXWritableRow_SetBinary;
  FDBXWritableRow_SetBytes :=         DBXWritableRow_SetBytes;

  FDBXDriver_CreateConnection :=      DBXDriver_CreateConnection;
//  FDBXDriver_GetVersion :=            DBXDriver_GetVersion;
  FDBXDriver_GetVersion :=            TDBXDriver_GetVersion(Marshal.GetDelegateForFunctionPointer(LoadMethod(SDBXDriver_GetVersion), Typeof(TDBXDriver_GetVersion)));

  FDBXConnection_Connect :=           DBXConnection_Connect;
  FDBXConnection_Disconnect :=        DBXConnection_Disconnect;
  FDBXConnection_SetCallbackEvent :=  DBXConnection_SetCallbackEvent;
  FDBXConnection_CreateCommand :=     DBXConnection_CreateCommand;
  FDBXConnection_BeginTransaction :=  DBXConnection_BeginTransaction;
  FDBXConnection_Commit :=            DBXConnection_Commit;
  FDBXConnection_Rollback :=          DBXConnection_Rollback;
  FDBXConnection_GetIsolation :=      DBXConnection_GetIsolation;
  FDBXConnection_GetVendorProperty := DBXConnection_GetVendorProperty;
//  FDBXConnection_SetProperty  :=      DBXConnection_SetProperty;

  FDBXCommand_CreateParameterRow :=   DBXCommand_CreateParameterRow;
  FDBXCommand_Prepare :=              DBXCommand_Prepare;
  FDBXCommand_Execute :=              DBXCommand_Execute;
  FDBXCommand_ExecuteImmediate :=     DBXCommand_ExecuteImmediate;
  FDBXCommand_GetNextReader :=        DBXCommand_GetNextReader;
  FDBXCommand_GetRowsAffected :=      DBXCommand_GetRowsAffected;
  FDBXCommand_SetMaxBlobSize :=       DBXCommand_SetMaxBlobSize;
  FDBXCommand_SetRowSetSize :=        DBXCommand_SetRowSetSize;

  FDBXParameterRow_SetParameterType :=  DBXParameterRow_SetParameterType;

  FDBXReader_GetColumnCount :=        DBXReader_GetColumnCount;
  FDBXReader_GetColumnMetadata :=     DBXReader_GetColumnMetadata;
  FDBXReader_Next :=                  DBXReader_Next;

end;

function TManagedMethodTable.LoadMethod(MethodName: String): IntPtr;
var
  ProcAddress: Intptr;
begin
  ProcAddress := GetProcAddress(FLibraryHandle, MethodName);
  if not Assigned(ProcAddress) then
  begin
    raise TDBXError.Create(TDBXErrorCodes.DriverInitFailed, WideFormat(SDllProcLoadError, [MethodName]));
  end;
  Result := ProcAddress;
end;

{ TDBXDynalinkDriverLoaderManaged }


function TDBXDynalinkDriverLoader.CreateDynalinkDriver: TDBXDynalinkDriver;
begin
  Result := TDBXDynalinkDriverManaged.Create(TDBXDriver(nil), FDriverHandle, FMethodTable);

end;

function TDBXDynalinkDriverLoader.CreateMethodTable: TDBXMethodTable;
begin
  Result := TManagedMethodTable.Create(FLibraryHandle);
end;


{procedure TDBXDynalinkDriverLoader.LoadDriverLibrary(DriverProperties: TDBXProperties; DBXContext: TDBXContext);
begin
  // Currently staticlly loaded dbxadapter.dll, so nothing
  // to do here.
end;
}

constructor TDBXDynalinkDriverLoader.Create;
begin
  inherited
end;

end.
