 { *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2006 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXDynalink;

interface

uses  DBXCommon,
      DBXPlatform,
      DBXDelegate,
      Windows,
      FMTBcd,
      SqlTimSt,
//      DBXMsSqlMetaDataProviderFactory,
      DBCommonTypes,
      ClassRegistry,
      Classes,
      SysUtils
{$IF DEFINED(CLR)}
  , System.Runtime.InteropServices
  , System.Text
{$ELSE}
  , WideStrings
{$IFEND}
;
const

  MAX_VERSION_STRING_LENGTH = 128;


type

{$IF DEFINED(WIN32)}
  TDBXHandle               = Pointer;
  TPointer                 = Pointer;
{$ELSE IF DEFINED(CLR)}
  TDBXHandle               = IntPtr;
  TPointer                 = IntPtr;
{$IFEND}
{$IF DEFINED(CLR)}
  TWideStrings = TStrings;
{$IFEND}

  // Use empty classes to enforce the implicit inheritance
  // of dbx drivers called through the flat api.
  //
//  TDBXHandle                  = class end;
//  TDBXCommonHandle              = class(TDBXHandle) end;
//  TDBXTransactionHandle       = class(TDBXHandle) end;
//  TDBXDriverHandle            = class(TDBXCommonHandle) end;
//  TDBXConnectionHandle        = class(TDBXCommonHandle) end;
//  TDBXCommandHandle           = class(TDBXCommonHandle) end;
//  TDBXMetaDataHandle          = class(TDBXCommonHandle) end;
//  TDBXRowHandle               = class(TDBXCommonHandle) end;
//  TDBXReaderHandle            = class(TDBXRowHandle) end;
//  TDBXWritableRowHandle      = class(TDBXRowHandle) end;
//  TDBXParameterRowHandle        = class(TDBXWritableRowHandle) end;

  TDBXCommonHandle            = TDBXHandle;
  TDBXTransactionHandle       = TDBXHandle;
  TDBXDriverHandle            = TDBXHandle;
  TDBXConnectionHandle        = TDBXHandle;
  TDBXCommandHandle           = TDBXHandle;
  TDBXMetaDataHandle          = TDBXHandle;
  TDBXRowHandle               = TDBXHandle;
  TDBXReaderHandle            = TDBXHandle;
  TDBXWritableRowHandle       = TDBXHandle;

  DBXCallbackHandle          = TDBXHandle;

  const

{$IF DEFINED(CLR)}
  SDYNALINK_LOADER_NAME = 'Borland.Data.'+'TDBXDynalinkDriverLoader'; { Do not resource }
{$ELSE}
  SDYNALINK_LOADER_NAME      =        'TDBXDynalinkDriverLoader'; { Do not resource }
{$IFEND}
  SDBX_ADAPTER_NAME =                 'dbxadapter30.dll';

  SDBXLoader_GetDriver =              'DBXLoader_GetDriver';

  SDBXBase_GetErrorMessageLength =    'DBXBase_GetErrorMessageLength';
  SDBXBase_GetErrorMessage =          'DBXBase_GetErrorMessage';
  SDBXBase_Close =                    'DBXBase_Close';

  SDBXRow_GetString =                 'DBXRow_GetString';
  SDBXRow_GetWideString =             'DBXRow_GetWideString';
  SDBXRow_GetInt16 =                  'DBXRow_GetInt16';
  SDBXRow_GetBoolean =                'DBXRow_GetBoolean';
  SDBXRow_GetInt32 =                  'DBXRow_GetInt32';
  SDBXRow_GetInt64 =                  'DBXRow_GetInt64';
  SDBXRow_GetDouble =                 'DBXRow_GetDouble';
  SDBXRow_GetBcd =                    'DBXRow_GetBcd';
  SDBXRow_GetTimeStamp =              'DBXRow_GetTimeStamp';
  SDBXRow_GetTime =                   'DBXRow_GetTime';
  SDBXRow_GetDate =                   'DBXRow_GetDate';
  SDBXRow_GetFixedBytes =             'DBXRow_GetFixedBytes';
  SDBXRow_GetBytes =                  'DBXRow_GetBytes';
  SDBXRow_GetByteLength =             'DBXRow_GetByteLength';
  SDBXRow_GetObjectTypeName =         'DBXRow_GetObjectTypeName';

  SDBXWritableRow_SetNull =          'DBXWritableRow_SetNull';
  SDBXWritableRow_SetString =        'DBXWritableRow_SetString';
  SDBXWritableRow_SetWideString =    'DBXWritableRow_SetWideString';
  SDBXWritableRow_SetBoolean =       'DBXWritableRow_SetBoolean';
  SDBXWritableRow_SetInt16 =         'DBXWritableRow_SetInt16';
  SDBXWritableRow_SetInt32 =         'DBXWritableRow_SetInt32';
  SDBXWritableRow_SetInt64 =         'DBXWritableRow_SetInt64';
  SDBXWritableRow_SetDouble =        'DBXWritableRow_SetDouble';
  SDBXWritableRow_SetBcd =           'DBXWritableRow_SetBcd';
  SDBXWritableRow_SetTimeStamp =     'DBXWritableRow_SetTimeStamp';
  SDBXWritableRow_SetTime =          'DBXWritableRow_SetTime';
  SDBXWritableRow_SetDate =          'DBXWritableRow_SetDate';
  SDBXWritableRow_SetBytes =         'DBXWritableRow_SetBytes';
  SDBXWritableRow_SetBinary =        'DBXWritableRow_SetBinary';

  SDBXDriver_CreateConnection =       'DBXDriver_CreateConnection';
  SDBXDriver_GetVersion =             'DBXDriver_GetVersion';

  SDBXConnection_Connect =            'DBXConnection_Connect';
  SDBXConnection_Disconnect =         'DBXConnection_Disconnect';
  SDBXConnection_SetCallbackEvent =   'DBXConnection_SetCallbackEvent';
  SDBXConnection_CreateCommand =      'DBXConnection_CreateCommand';
  SDBXConnection_GetMetaData =        'DBXConnection_GetMetaData';
  SDBXConnection_BeginTransaction =   'DBXConnection_BeginTransaction';
  SDBXConnection_Commit =             'DBXConnection_Commit';
  SDBXConnection_Rollback =           'DBXConnection_Rollback';
  SDBXConnection_GetIsolation =       'DBXConnection_GetIsolation';
  SDBXConnection_GetVendorProperty =  'DBXConnection_GetVendorProperty';
//  SDBXConnection_SetProperty =        'DBXConnection_SetProperty';

  SDBXCommand_CreateParameterRow =    'DBXCommand_CreateParameterRow';
  SDBXCommand_Prepare =               'DBXCommand_Prepare';
  SDBXCommand_Execute =               'DBXCommand_Execute';
  SDBXCommand_ExecuteImmediate =      'DBXCommand_ExecuteImmediate';
  SDBXCommand_GetNextReader =         'DBXCommand_GetNextReader';
  SDBXCommand_GetRowsAffected =       'DBXCommand_GetRowsAffected';
  SDBXCommand_SetMaxBlobSize =        'DBXCommand_SetMaxBlobSize';
  SDBXCommand_SetRowSetSize =         'DBXCommand_SetRowSetSize';

  SDBXParameterRow_SetParameterType = 'DBXParameterRow_SetParameterType';

  SDBXReader_GetColumnCount =         'DBXReader_GetColumnCount';
  SDBXReader_GetColumnMetaData =      'DBXReader_GetColumnMetadata';
  SDBXReader_Next =                   'DBXReader_Next';

  SDBXMetaData_GetMetaData =          'DBXMetaData_GetMetaData';

type

  TDBXDynalinkDriverLoaderClass = class of TClassRegistryObject; //class of TObject;

  TInt32 = Integer;

  DBXTraceCallback                          = function(Handle: DBXCallbackHandle; TraceCategory: TInt32;
{$IF DEFINED(CLR)}
[MarshalAs(UnmanagedType.LPWStr)]
{$IFEND}
  TraceMessage: TDBXWideString): CBRType; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}

  TDBXCommon_GetErrorMessageLength        = function(Handle: TDBXCommonHandle; LastErrorCode: TDBXErrorCode; out ErrorLen: TInt32): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXCommon_GetErrorMessage              = function(Handle: TDBXCommonHandle; LastErrorCode: TDBXErrorCode; ErrorMessage: TDBXWideStringBuilder): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXCommon_Close                        = function(Handle: TDBXCommonHandle): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}

  TDBXRow_GetString                       = function(Handle: TDBXRowHandle; Ordinal: TInt32; Value: TDBXAnsiStringBuilder; out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXRow_GetWideString                   = function(Handle: TDBXRowHandle; Ordinal: TInt32; Value: TDBXWideStringBuilder; out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXRow_GetBoolean                      = function(Handle: TDBXRowHandle; Ordinal: TInt32; out Value: LongBool; out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXRow_GetInt16                        = function(Handle: TDBXRowHandle; Ordinal: TInt32; out Value: SmallInt; out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXRow_GetInt32                        = function(Handle: TDBXRowHandle; Ordinal: TInt32; out Value: LongInt; out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXRow_GetInt64                        = function(Handle: TDBXRowHandle; Ordinal: TInt32; out Value: Int64; out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXRow_GetDouble                       = function(Handle: TDBXRowHandle; Ordinal: TInt32; out Value: double; out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXRow_GetBcd                          = function(Handle: TDBXRowHandle; Ordinal: TInt32; out Value: TBcd; out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXRow_GetTimeStamp                    = function(Handle: TDBXRowHandle; Ordinal: TInt32; out Value: TSQLTimeStamp; out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXRow_GetTime                         = function(Handle: TDBXRowHandle; Ordinal: TInt32; out Value: TDBXTime; out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXRow_GetDate                         = function(Handle: TDBXRowHandle; Ordinal: TInt32; out Value: TDBXDate; out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
{$IF DEFINED(CLR)}
  TDBXRow_GetBytes                         = function(Handle: TDBXRowHandle;
                                                      Ordinal: TInt32;
                                                      Offset: Int64;
                                                      Value: TBytes; const LastIndex: TInt32;{dummy to simulate native "open array"}
                                                      ValueOffset,
                                                      Length: Int64;
                                                      out ReturnLength: Int64;
                                                      out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXRow_GetFixedBytes                    = function(Handle: TDBXRowHandle;
                                                      Ordinal: TInt32;
                                                      Value: TBytes; const LastIndex: TInt32;{dummy to simulate native "open array"}
                                                      ValueOffset: TInt32;
                                                      out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
{$ELSE}
  TDBXRow_GetBytes                         = function(Handle: TDBXRowHandle; Ordinal: TInt32; Offset: Int64; Value: array of byte;
                                            ValueOffset, Length: Int64; out ReturnLength: Int64; out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXRow_GetFixedBytes                    = function(Handle: TDBXRowHandle;
                                                      Ordinal: TInt32;
                                                      const Value: array of byte;
                                                      ValueOffset: TInt32;
                                                      out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
{$IFEND}
  TDBXRow_GetByteLength                   = function(Handle: TDBXRowHandle; Ordinal: TInt32; out Length: Int64; out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
//  TDBXRow_GetBinary                       = function(Handle: TDBXRowHandle; Ordinal: TInt32; Value: TPointer;
//                                            out IsNull: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXRow_GetObjectTypeName              = function(Handle: TDBXRowHandle; Ordinal: TInt32; Value: TDBXWideStringBuilder; MaxLength: Integer): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}

  TDBXWritableRow_SetNull                = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXWritableRow_SetString              = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32; const Value: TDBXAnsiString; Length: Int64): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXWritableRow_SetWideString          = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32; const Value: TDBXWideString; Length: Int64): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXWritableRow_SetBoolean             = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32; Value: LongBool): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXWritableRow_SetInt16               = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32; Value: SmallInt): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXWritableRow_SetInt32               = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32; Value: LongInt): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXWritableRow_SetInt64               = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32; Value: Int64): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXWritableRow_SetDouble              = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32; Value: double): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXWritableRow_SetBcd                 = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32; Value: TBcd): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXWritableRow_SetTimeStamp           = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32; var Value: TSQLTimeStamp): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXWritableRow_SetTime                = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32; Value: TDBXTime): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXWritableRow_SetDate                = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32; Value: TDBXDate): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
//  TDBXWritableRow_SetBinary              = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32; Value: TPointer;
//                                            Length: Int64): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
{$IF DEFINED(CLR)}
  TDBXWritableRow_SetBytes               = function(Handle: TDBXWritableRowHandle;
                                                    Ordinal: TInt32;
                                                    BlobOffset: Int64;
                                                    Value: TBytes; LastIndex: TInt32;{dummy to simulate native "open array"}
                                                    ValueOffset: Int64;
                                                    Length: Int64): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
{$ELSE}
//  TDBXWritableRow_SetBytes               = function(Handle: TDBXWritableRowHandle; Ordinal: TInt32; BlobOffset: Int64; Value: array of byte;
//                                            ValueOffset: Int64; Length: Int64): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXWritableRow_SetBytes               = function(Handle: TDBXWritableRowHandle;
                                                    Ordinal: TInt32;
                                                    BlobOffset: Int64;
                                                    Value: TBytes; LastIndex: TInt32;{dummy to simulate native "open array"}
                                                    ValueOffset: Int64;
                                                    Length: Int64): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
{$IFEND}

//[DllImport(SDBX_ADAPTER_NAME, CharSet = CharSet.Unicode, EntryPoint = SDBXLoader_GetDriver)]
//function DBXLoader_GetDriver([in]Count: TInt32; [in]Names, [in]Values: TWideStringArray; [out]ErrorMessage: StringBuilder; out [out]DriverHandle: TDBXDriverHandle): TDBXErrorCode; external;
{$IF DEFINED(CLR)}

{$IFEND}
  TDBXLoader_GetDriver                = function(
                                                {$IF DEFINED(CLR)} [in]  {$IFEND}
                                                Count: TInt32;
                                                {$IF DEFINED(CLR)} [in] [MarshalAs(UnmanagedType.LPArray, ArraySubType=UnmanagedType.LPWStr)] {$IFEND}
                                                Names: TWideStringArray;
                                                {$IF DEFINED(CLR)} [in] [MarshalAs(UnmanagedType.LPArray, ArraySubType=UnmanagedType.LPWStr)] {$IFEND}
                                                Values: TWideStringArray;
                                                {$IF DEFINED(CLR)} [out] [MarshalAs(UnmanagedType.LPWStr)] {$IFEND}
                                                ErrorMessage: TDBXWideStringBuilder;
                                                out pDriver: TDBXDriverHandle): TDBXErrorCode {$IF DEFINED(CLR)} of Object; {$ELSE} ; stdcall; {$IFEND}
//  TDBXLoader_GetDriver                = function( Count: TInt32; Names, Values: TWideStringArray;
//                                                ErrorMessage: TDBXWideStringBuilder; out pDriver: TDBXDriverHandle): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}

  TDBXDriver_CreateConnection         = function(Handle: TDBXDriverHandle; out pConn: TDBXConnectionHandle): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
//  TDBXDriver_GetVersion               = function(Handle: TDBXDriverHandle; Version: TDBXWideStringBuilder; MaxLength: TInt32): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXDriver_GetVersion                = function(
                                                {$IF DEFINED(CLR)} [in]  {$IFEND}
                                                Handle: TDBXDriverHandle;
                                                {$IF DEFINED(CLR)} [out] [MarshalAs(UnmanagedType.LPWStr)] {$IFEND}
                                                Version: TDBXWideStringBuilder;
                                                {$IF DEFINED(CLR)} [in]  {$IFEND}
                                                MaxLength: TInt32): TDBXErrorCode {$IF DEFINED(CLR)} of Object; {$ELSE} ; stdcall; {$IFEND}

  TDBXConnection_Connect              = function(Handle: TDBXConnectionHandle; Count: TInt32; Names, Values: TWideStringArray): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXConnection_Disconnect           = function(Handle: TDBXConnectionHandle): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXConnection_SetCallbackEvent     = function(Handle: TDBXConnectionHandle; CallbackHandle: DBXCallbackHandle; CallbackEvent: DBXTraceCallback): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXConnection_CreateCommand        = function(Handle: TDBXConnectionHandle; const CommandType: TDBXWideString; out pCommand: TDBXCommandHandle): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXConnection_GetMetaData          = function(Handle: TDBXConnectionHandle; out pMetaData: TDBXMetaDataHandle): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXConnection_BeginTransaction     = function(Handle: TDBXConnectionHandle; out TransactionHandle: TDBXTransactionHandle; IsolationLevel: TInt32): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXConnection_Commit               = function(Handle: TDBXConnectionHandle; TransactionHandle: TDBXTransactionHandle): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXConnection_Rollback             = function(Handle: TDBXConnectionHandle; TransactionHandle: TDBXTransactionHandle): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXConnection_GetIsolation         = function(Handle: TDBXConnectionHandle; out IsolationLevel: TInt32): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXConnection_GetVendorProperty          = function(
                                                {$IF DEFINED(CLR)} [in]  {$IFEND}
                                                Handle: TDBXConnectionHandle;
                                                {$IF DEFINED(CLR)} [in] [MarshalAs(UnmanagedType.LPWStr)] {$IFEND}
                                                Name: TDBXWideString;
                                                {$IF DEFINED(CLR)} [out] [MarshalAs(UnmanagedType.LPWStr)] {$IFEND}
                                                Value: TDBXWideStringBuilder;
                                                {$IF DEFINED(CLR)} [in]  {$IFEND}
                                                MaxLength: TInt32): TDBXErrorCode {$IF DEFINED(CLR)} of Object; {$ELSE} ; stdcall; {$IFEND}
//  TDBXConnection_SetProperty          = function(
//                                                {$IF DEFINED(CLR)} [in]  {$IFEND}
//                                                Handle: TDBXConnectionHandle;
//                                                {$IF DEFINED(CLR)} [in] [MarshalAs(UnmanagedType.LPWStr)] {$IFEND}
//                                                Name: TDBXWideString;
//                                                {$IF DEFINED(CLR)} [in] [MarshalAs(UnmanagedType.LPWStr)] {$IFEND}
//                                                Value: TDBXWideString
//                                                ): TDBXErrorCode {$IF DEFINED(CLR)} of Object; {$ELSE} ; stdcall; {$IFEND}

  TDBXCommand_CreateParameterRow      = function(Handle: TDBXCommandHandle; out Parameters: TDBXRowHandle): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXCommand_Prepare                 = function(Handle: TDBXCommandHandle; const SQL: TDBXWideString; Count: TInt32): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXCommand_Execute                 = function(Handle: TDBXCommandHandle; out Reader: TDBXReaderHandle): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXCommand_ExecuteImmediate        = function(Handle: TDBXCommandHandle; const SQL: TDBXWideString; out Reader: TDBXReaderHandle): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXCommand_GetNextReader           = function(Handle: TDBXCommandHandle; out Reader: TDBXReaderHandle): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXCommand_GetRowsAffected         = function(Handle: TDBXCommandHandle; out Rows: Int64): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXCommand_SetMaxBlobSize          = function(Handle: TDBXCommandHandle; MaxBlobSize: Int64): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXCommand_SetRowSetSize           = function(Handle: TDBXCommandHandle; RowSetSize: Int64): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}

  TDBXParameterRow_SetParameterType     = function(Handle: TDBXRowHandle;Ordinal: TInt32;
                                        const Name: TDBXWideString;
                                        ChildPosition: TInt32; ParamDirection: TDBXParameterDirection;
                                        DBXType: TInt32; DBXSubType: TInt32;
                                        Size: Int64; Precision: Int64; Scale: TInt32): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}

  TDBXReader_GetColumnCount           = function(Handle: TDBXReaderHandle; out ColumnCount: TInt32): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXReader_GetColumnMetadata        = function(Handle: TDBXReaderHandle; Ordinal: TInt32; Name: TDBXWideStringBuilder; out ColumnType: TInt32; out ColumnSubType: TInt32; out Length: TInt32; out precision: TInt32; out scale: TInt32; out flags: TInt32): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
  TDBXReader_Next                     = function(Handle: TDBXReaderHandle): TDBXErrorCode; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}




  TDBXMethodTable = class
    private
    procedure RaiseError( DBXContext:        TDBXContext;
                          DBXResult:         TDBXErrorCode;
                          DBXHandle:         TDBXCommonHandle;
                          AdditionalInfo:    WideString
                        ); overload;
    procedure RaiseError( DBXContext:        TDBXContext;
                          DBXResult:         TDBXErrorCode;
                          DBXHandle:         TDBXCommonHandle
                        ); overload;
    public
      FDBXLoader_GetDriver:             TDBXLoader_GetDriver;

      FDBXBase_GetErrorMessageLength:   TDBXCommon_GetErrorMessageLength;
      FDBXBase_GetErrorMessage:         TDBXCommon_GetErrorMessage;
      FDBXBase_Close:                   TDBXCommon_Close;

      FDBXRow_GetString:                TDBXRow_GetString;
      FDBXRow_GetWideString:            TDBXRow_GetWideString;
      FDBXRow_GetBoolean:               TDBXRow_GetBoolean;
      FDBXRow_GetInt16:                 TDBXRow_GetInt16;
      FDBXRow_GetInt32:                 TDBXRow_GetInt32;
      FDBXRow_GetInt64:                 TDBXRow_GetInt64;
      FDBXRow_GetDouble:                TDBXRow_GetDouble;
      FDBXRow_GetBcd:                   TDBXRow_GetBcd;
      FDBXRow_GetTimeStamp:             TDBXRow_GetTimeStamp;
      FDBXRow_GetTime:                  TDBXRow_GetTime;
      FDBXRow_GetDate:                  TDBXRow_GetDate;
      FDBXRow_GetFixedBytes:            TDBXRow_GetFixedBytes;
      FDBXRow_GetByteLength:            TDBXRow_GetByteLength;
      FDBXRow_GetBytes:                 TDBXRow_GetBytes;
//      FDBXRow_GetBinary:                TDBXRow_GetBinary;
      FDBXRow_GetObjectTypeName:       TDBXRow_GetObjectTypeName;

      FDBXWritableRow_SetNull:         TDBXWritableRow_SetNull;
      FDBXWritableRow_SetString:       TDBXWritableRow_SetString;
      FDBXWritableRow_SetWideString:   TDBXWritableRow_SetWideString;
      FDBXWritableRow_SetBoolean:      TDBXWritableRow_SetBoolean;
      FDBXWritableRow_SetInt16:        TDBXWritableRow_SetInt16;
      FDBXWritableRow_SetInt32:        TDBXWritableRow_SetInt32;
      FDBXWritableRow_SetInt64:        TDBXWritableRow_SetInt64;
      FDBXWritableRow_SetDouble:       TDBXWritableRow_SetDouble;
      FDBXWritableRow_SetBcd:          TDBXWritableRow_SetBcd;
      FDBXWritableRow_SetTimeStamp:    TDBXWritableRow_SetTimeStamp;
      FDBXWritableRow_SetTime:         TDBXWritableRow_SetTime;
      FDBXWritableRow_SetDate:         TDBXWritableRow_SetDate;
      FDBXWritableRow_SetBytes:        TDBXWritableRow_SetBytes;
//      FDBXWritableRow_SetBinary:       TDBXWritableRow_SetBinary;

      FDBXDriver_CreateConnection:      TDBXDriver_CreateConnection;
      FDBXDriver_GetVersion:            TDBXDriver_GetVersion;

      FDBXConnection_Connect:           TDBXConnection_Connect;
      FDBXConnection_Disconnect:        TDBXConnection_Disconnect;
      FDBXConnection_SetCallbackEvent:  TDBXConnection_SetCallbackEvent;
      FDBXConnection_CreateCommand:     TDBXConnection_CreateCommand;
      FDBXConnection_GetMetaData:       TDBXConnection_GetMetaData;
      FDBXConnection_BeginTransaction:  TDBXConnection_BeginTransaction;
      FDBXConnection_Commit:            TDBXConnection_Commit;
      FDBXConnection_Rollback:          TDBXConnection_Rollback;
      FDBXConnection_GetIsolation:      TDBXConnection_GetIsolation;
      FDBXConnection_GetVendorProperty:       TDBXConnection_GetVendorProperty;
//      FDBXConnection_SetProperty:       TDBXConnection_SetProperty;

      FDBXCommand_CreateParameterRow:   TDBXCommand_CreateParameterRow;
      FDBXCommand_Prepare:              TDBXCommand_Prepare;
      FDBXCommand_Execute:              TDBXCommand_Execute;
      FDBXCommand_ExecuteImmediate:     TDBXCommand_ExecuteImmediate;
      FDBXCommand_GetNextReader:        TDBXCommand_GetNextReader;
      FDBXCommand_GetRowsAffected:      TDBXCommand_GetRowsAffected;
      FDBXCommand_SetMaxBlobSize:       TDBXCommand_SetMaxBlobSize;
      FDBXCommand_SetRowSetSize:        TDBXCommand_SetRowSetSize;

      FDBXParameterRow_SetParameterType:  TDBXParameterRow_SetParameterType;

      FDBXReader_GetColumnCount:        TDBXReader_GetColumnCount;
      FDBXReader_GetColumnMetadata:     TDBXReader_GetColumnMetaData;
      FDBXReader_Next:                  TDBXReader_Next;

      constructor Create;

      function LoadMethod(MethodName: String): TPointer; virtual; abstract;

      procedure LoadMethods; virtual; abstract;


  end;




  TDBXDynalinkReader = class(TDBXReader)
    private
      procedure CheckResult(DBXResult: TDBXErrorCode);
      constructor Create(DBXContext: TDBXContext; ReaderHandle: TDBXReaderHandle; MethodTable: TDBXMethodTable; ByteReader: TDBXByteReader);
    protected
      FReaderHandle:      TDBXReaderHandle;
      FMethodTable:       TDBXMethodTable;
      procedure DerivedClose; override;
      function DerivedNext: Boolean; override;

  end;

  TDBXDynalinkRow = class(TDBXRowEx)
    private
      FRowHandle:           TDBXRowHandle;
      FMethodTable:         TDBXMethodTable;
      procedure CheckResult(DBXResult: TDBXErrorCode);
      procedure CheckParameterResult(DBXResult: TDBXErrorCode; DbxValue: TDbxValue);
      procedure ParameterError(DBXResult: TDBXErrorCode; DbxValue: TDbxValue);

    protected
      constructor Create(DBXContext: TDBXContext; MethodTable: TDBXMethodTable; RowHandle: TDBXRowHandle);

      procedure GetAnsiString(DbxValue: TDBXAnsiStringValue; var AnsiStringVar: TDBXAnsiStringBuilder; var IsNull: LongBool); override;
      procedure GetWideString(DbxValue: TDBXWideStringValue; var WideStringBuilder: TDBXWideStringBuilder; var IsNull: LongBool); override;
      procedure GetBoolean(DbxValue: TDBXBooleanValue; var Value: LongBool; var IsNull: LongBool); override;
      procedure GetInt16(DbxValue: TDBXInt16Value; var Value: SmallInt; var IsNull: LongBool); override;
      procedure GetInt32(DbxValue: TDBXInt32Value; var Value: TInt32; var IsNull: LongBool); override;
      procedure GetInt64(DbxValue: TDBXInt64Value; var Value: Int64; var IsNull: LongBool); override;
      procedure GetDouble(DbxValue: TDBXDoubleValue; var Value: Double; var IsNull: LongBool); override;
      procedure GetBcd(DbxValue: TDBXBcdValue; var Value: TBcd; var IsNull: LongBool); override;
      procedure GetDate(DbxValue: TDBXDateValue; var Value: TDBXDate; var IsNull: LongBool); override;
      procedure GetTime(DbxValue: TDBXTimeValue; var Value: TDBXTime; var IsNull: LongBool); override;
      procedure GetTimeStamp(DbxValue: TDBXTimeStampValue; var Value: TSQLTimeStamp; var IsNull: LongBool); override;
      procedure GetBytes(DbxValue: TDBXByteArrayValue; Offset: Int64; const Buffer: TBytes; BufferOffset, Length: Int64; var ReturnLength: Int64; var IsNull: LongBool); override;
      procedure GetByteLength(DbxValue: TDBXByteArrayValue; var ByteLength: Int64; var IsNull: LongBool); override;

      procedure SetNull(DbxValue: TDBXValue); override;
      procedure SetString(DbxValue: TDBXAnsiStringValue; const Value: String); override;
      procedure SetWideString(DbxValue: TDBXWideStringValue; const Value: WideString); override;
      procedure SetBoolean(DbxValue: TDBXBooleanValue; Value: Boolean); override;
      procedure SetInt16(DbxValue: TDBXInt16Value; Value: SmallInt); override;
      procedure SetInt32(DbxValue: TDBXInt32Value; Value: TInt32); override;
      procedure SetInt64(DbxValue: TDBXInt64Value; Value: Int64); override;
      procedure SetDouble(DbxValue: TDBXDoubleValue; Value: Double); override;

      procedure SetBCD(DbxValue: TDBXBcdValue; var Value: TBcd); override;

      procedure SetDate(DbxValue: TDBXDateValue; Value: TDBXDate); override;
      procedure SetTime(DbxValue: TDBXTimeValue; Value: TDBXTime); override;

      procedure SetTimestamp(DbxValue: TDBXTimeStampValue; var Value: TSQLTimeStamp); override;

      procedure SetDynamicBytes( DbxValue:     TDBXValue;
                          Offset:       Int64;
                          const Buffer: TBytes;
                          BufferOffset: Int64;
                          Count:       Int64); override;


      function  GetObjectTypeName(Ordinal: TInt32): WideString; override;

      procedure SetValueType( ValueType: TDBXValueType); override;
      procedure GetLength(DbxValue: TDBXValue; var ByteLength: Int64; var IsNull: LongBool); override;

  end;

  // by TSV
  TDBXDynalinkRowEx=class(TDBXDynalinkRow)
    public
      constructor Create(DBXContext: TDBXContext; MethodTable: TDBXMethodTable; RowHandle: TDBXRowHandle);
      destructor Destroy; override;
      procedure BeforeDestruction; override;
  end;

  TDBXDynalinkCommand = class(TDBXCommand)
    private
      FConnectionHandle:  TDBXConnectionHandle;
      FCommandHandle:     TDBXCommandHandle;
      FMethodTable:       TDBXMethodTable;

      procedure CheckResult(DBXResult: TDBXErrorCode);
      constructor Create(DBXContext: TDBXContext; ConnectionHandle: TDBXConnectionHandle; MethodTable: TDBXMethodTable);

    protected
      procedure SetRowSetSize(const RowSetSize: Int64); override;
      procedure SetMaxBlobSize(const MaxBlobSize: Int64); override;
      function GetRowsAffected: Int64; override;
      function CreateParameterRow(): TDBXRow; override;

      function DerivedExecuteQuery: TDBXReader; override;
      procedure DerivedExecuteUpdate; override;
      procedure DerivedPrepare; override;
      procedure DerivedOpen; override;
      procedure DerivedClose; override;
  public
      destructor Destroy(); override;
      function DerivedGetNextReader: TDBXReader; override;
  end;

  TDBXDynalinkByteReader = class(TDBXByteReader)
    private
      FReaderHandle:      TDBXReaderHandle;
      FMethodTable:       TDBXMethodTable;
      constructor Create(DBXContext: TDBXContext; ReaderHandle: TDBXReaderHandle; MethodTable: TDBXMethodTable);
      procedure CheckResult(DBXResult: TDBXErrorCode);
    public
      procedure GetAnsiString(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetWideString(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetInt16(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetInt32(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetInt64(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetDouble(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetBcd(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetTimeStamp(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetTime(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetDate(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;

      procedure GetByteLength(Ordinal: TInt32; var Length: Int64; var IsNull: LongBool); override;
      function  GetBytes(Ordinal: TInt32; Offset: Int64; const Value: TBytes;
                                 ValueOffset, Length: Int64; var IsNull: LongBool): Int64; override;

  end;


  TDBXDynalinkConnection = class;

  TDBXDynalinkTransaction = class(TDBXTransaction)
    private
      FTransactionHandle: TDBXTransactionHandle;
      constructor Create(Connection: TDBXDynalinkConnection; IsolationLevel: TDBXIsolation; TransactionHandle: TDBXTransactionHandle);
  end;


  TDBXDynalinkConnection = class(TDBXConnectionEx)
    private
//      FTransactionId:     TDBXTransactionHandle;
      FTraceCallback:  DBXTraceCallback;

    protected
      FConnectionHandle:  TDBXConnectionHandle;
      FMethodTable:       TDBXMethodTable;

      procedure CheckResult(DBXResult: TDBXErrorCode);
//      function  CreateAndBeginTransaction(): TDBXTransaction; override;
      function  CreateAndBeginTransaction(Isolation: TDBXIsolation): TDBXTransaction; override;
      procedure Commit(InTransaction: TDBXTransaction); override;
      procedure Rollback(InTransaction: TDBXTransaction); override;
      function  DBXCallback(Handle: DBXCallbackHandle;
                            TraceFlag: TDBXTraceFlag;
{$IF DEFINED(CLR)}
[MarshalAs(UnmanagedType.LPWStr)]
{$IFEND}
                            TraceMessage: TDBXWideString): CBRType; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
      procedure Close; override;
      procedure SetTraceInfoEvent(TraceInfoEvent: TDBXTraceEvent); override;
      function    DerivedCreateCommand: TDBXCommand; overload; override;
      procedure   DerivedOpen(); override;
      procedure DerivedGetCommandTypes(List: TWideStrings); override;
      procedure DerivedGetCommands(CommandType: WideString; List: TWideStrings); override;


    public
      function GetVendorProperty(const Name: WideString): WideString; override;
      constructor Create(ConnectionBuilder: TDBXConnectionBuilder; ConnectionHandle: TDBXConnectionHandle; MethodTable: TDBXMethodTable);

  end;

  TDBXDynalinkDriver = class(TDBXDriverEx)
    private
      FStringVersion:   WideString;
      function  CreateDynalinkCommand(DbxContext: TDBXContext; Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand;

    strict protected
      FDriverHandle: TDBXDriverHandle;
      FMethodTable:  TDBXMethodTable;

      constructor Create(Driver: TDBXDriver; DriverHandle: TDBXDriverHandle; MethodTable: TDBXMethodTable);
      procedure CheckResult(DBXResult: TDBXErrorCode);
    protected
      procedure Close; override;
    public
      destructor Destroy; override;
      function GetDriverVersion: WideString; override;


  end;

  TDBXDynalinkDriverCommonLoader = class(TDBXDriverLoader)
    strict protected
      FLibraryHandle:   HModule;
      FOldLibraryHandle:   HModule;
      FMethodTable:     TDBXMethodTable;
      FDriverHandle:    TDBXDriverHandle;

      procedure LoadDriverLibrary(DriverProperties: TDBXProperties; DBXContext: TDBXContext); virtual;
      function  CreateMethodTable: TDBXMethodTable; virtual; abstract;
      function  CreateDynalinkDriver: TDBXDynalinkDriver; virtual; abstract;

    public
      constructor Create; override;
      function Load(DriverDef: TDBXDriverDef): TDBXDriver; override;

  end;

resourcestring
  SAdditionalInfo = '%s.  Vendor error message:  %s.';
  SInvalidDataType = 'dbExpress driver does not support the %s data type';
implementation

uses
{$IF DEFINED(WIN32)}
DBXDynalinkNative;
{$ELSE IF DEFINED(CLR)}
DBXDynalinkManaged;
{$IFEND}

var
  DBXDynalinkDriverLoaderClass: TDBXDynalinkDriverLoaderClass;

{ TDBXDynalinkDriver }

procedure TDBXDynalinkDriver.CheckResult(DBXResult: TDBXErrorCode);
begin
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDBXContext, DBXResult, FDriverHandle, '');
end;

procedure TDBXDynalinkDriver.Close;
begin
  inherited;

end;

constructor TDBXDynalinkDriver.Create(Driver: TDBXDriver; DriverHandle: TDBXDriverHandle; MethodTable: TDBXMethodTable);
begin
  inherited Create;
  FMethodTable := MethodTable;
  FDriverHandle := DriverHandle;
  // '' makes this the default command factory.
  //
  AddCommandFactory('', CreateDynalinkCommand);
end;



function TDBXDynalinkDriver.CreateDynalinkCommand(DbxContext: TDBXContext;
  Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand;
begin
  Result := TDBXDynalinkCommand.Create(DbxContext, (TDBXDynalinkConnection(Connection).FConnectionHandle), FMethodTable);
end;

destructor TDBXDynalinkDriver.Destroy;
begin
  FMethodTable.FDBXBase_Close(FDriverHandle);
  FDriverHandle := nil;
  FreeAndNil(FMethodTable);
  inherited Destroy;
end;

function TDBXDynalinkDriver.GetDriverVersion: WideString;
var
  ErrorResult: TDBXErrorCode;
  StringVersionBuilder: TDBXWideStringBuilder;
begin

    StringVersionBuilder := TDBXPlatform.CreateWideStringBuilder(2*MAX_VERSION_STRING_LENGTH+1);
    try
      ErrorResult := FMethodTable.FDBXDriver_GetVersion(FDriverHandle, TDBXWideStringBuilder(StringVersionBuilder), MAX_VERSION_STRING_LENGTH);
      CheckResult(ErrorResult);
      FStringVersion := TDBXPlatform.ToWideString(StringVersionBuilder);
    finally
      TDBXPlatform.FreeAndNilWideStringBuilder(StringVersionBuilder);
    end;
  Result := FStringVersion;

end;


{ TDBXMethodTable }


constructor TDBXMethodTable.Create;
begin
  inherited Create;
end;

procedure TDBXMethodTable.RaiseError(DBXContext: TDBXContext;
DBXResult: TDBXErrorCode; DBXHandle: TDBXCommonHandle);
begin
  RaiseError(DBXContext, DBXResult, DBXHandle, '');
end;

procedure TDBXMethodTable.RaiseError(DBXContext: TDBXContext;
DBXResult: TDBXErrorCode; DBXHandle: TDBXCommonHandle;
AdditionalInfo: WideString);
var
  ErrorMessageBuilder: TDBXWideStringBuilder;
  ErrorMessage: WideString;
  Status: TDBXErrorCode;
  MessageLength: TInt32;
begin
  ErrorMessage := '';
  Status := FDBXBase_GetErrorMessageLength(DBXHandle, DBXResult, MessageLength);
  if(Status = TDBXErrorCodes.None) and(MessageLength > 0) then
  begin
    ErrorMessageBuilder := TDBXPlatform.CreateWideStringBuilder(MessageLength+1);
    try
      Status := FDBXBase_GetErrorMessage(DBXHandle, DBXResult, TDBXWideStringBuilder(ErrorMessageBuilder));
      if(Status = TDBXErrorCodes.None) then
      begin
        ErrorMessage := TDBXPlatform.ToWideString(ErrorMessageBuilder);
      end;
    finally
      TDBXPlatform.FreeAndNilWideStringBuilder(ErrorMessageBuilder);
    end;
  end;
  if AdditionalInfo <> '' then
  begin
    DBXContext.Error(DBXResult, WideFormat(SAdditionalInfo, [AdditionalInfo, ErrorMessage]));
  end else
  begin
    DBXContext.Error(DBXResult, ErrorMessage);
  end;

end;

{ TDBXDynalinkDriverLoader }

constructor TDBXDynalinkDriverCommonLoader.Create;
begin
  inherited;
  FLibraryHandle := HModule(0);
  FMethodTable   := nil;
  FDriverHandle  := nil;
  FLoaderName    := SDYNALINK_LOADER_NAME;
end;


function TDBXDynalinkDriverCommonLoader.Load(DriverDef: TDBXDriverDef): TDBXDriver;
var
  ErrorResult:          TDBXErrorCode;
  ErrorMessageBuilder:  TDBXWideStringBuilder;
  Count:                TInt32;
  Names:                TWideStringArray;
  Values:               TWideStringArray;
  ErrorMessage:         WideString;

begin
  Result := nil;
  if DriverDef.FDriverProperties[TDBXPropertyNames.LibraryName] <> '' then
  begin
    try
      LoadDriverLibrary(DriverDef.FDriverProperties, DriverDef.FDBXContext);
      FMethodTable   := CreateMethodTable;
      try
        FMethodTable.LoadMethods;
      except
        on EDBXError: TDBXError do
          begin
            DriverDef.FDBXContext.OnError(EDBXError);
            raise;
          end;
      end;
      Count := DriverDef.FDriverProperties.Properties.Count;
      DriverDef.FDriverProperties.GetLists(Names, Values);


      ErrorMessageBuilder := TDBXPlatform.CreateWideStringBuilder(256);
      try
        ErrorResult := FMethodTable.FDBXLoader_GetDriver(Count, Names, Values,
                                                         TDBXWideStringBuilder(ErrorMessageBuilder),
                                                         FDriverHandle);

        if ErrorResult <> TDBXErrorCodes.None then
        begin
          TDBXPlatform.CopyWideStringBuilder(ErrorMessageBuilder, ErrorMessage);

          DriverDef.FDBXContext.Error(ErrorResult, ErrorMessage);
        end;
      finally
         TDBXPlatform.FreeAndNilWideStringBuilder(ErrorMessageBuilder);
      end;


      Result  := CreateDynalinkDriver;
      FMethodTable := nil;

    finally
      FreeAndNil(FMethodTable); // NO-OP if success because it is set to nil.
    end;
  end;
end;

procedure TDBXDynalinkDriverCommonLoader.LoadDriverLibrary(
  DriverProperties: TDBXProperties; DBXContext: TDBXContext);
var
  GetNewDriver:       THandle;
  LastError:          Integer;
  LibraryName:        WideString;
begin

  LibraryName       := DriverProperties[TDBXPropertyNames.LibraryName];

  FLibraryHandle := HModule(LoadLibrary(TDBXAnsiString(String(LibraryName))));
  if FLibraryHandle = HModule(0) then
  begin
    LastError := GetLastError;
    DBXContext.Error(TDBXErrorCodes.DriverInitFailed, WideFormat(sDLLLoadError, [LibraryName, LastError]));
  end;

  GetNewDriver := THandle(GetProcAddress(FLibraryHandle, TDBXAnsiString(SDBXLoader_GetDriver)));
  if GetNewDriver = THandle(0) then
  begin
    FOldLibraryHandle := FLibraryHandle;
    FLibraryHandle := THandle(LoadLibrary(SDBX_ADAPTER_NAME));
//    FreeLibrary(OldLibraryHandle);
    if FLibraryHandle = THandle(0) then
      DBXContext.Error(TDBXErrorCodes.DriverInitFailed, WideFormat(sDLLLoadError, [SDBX_ADAPTER_NAME, GetLastError]));

    GetNewDriver := THandle(GetProcAddress(FLibraryHandle, TDBXAnsiString(SDBXLoader_GetDriver)));
    if GetNewDriver = THandle(0) then
    begin
      FreeLibrary(FLibraryHandle);
      DBXContext.Error(TDBXErrorCodes.DriverInitFailed, WideFormat(SDllProcLoadError, [SDBXLoader_GetDriver]));
    end;
  end;

end;

{ TDBXDynalinkConnection }

function TDBXDynalinkConnection.CreateAndBeginTransaction(
  Isolation: TDBXIsolation): TDBXTransaction;
var
  TransactionHandle: TDBXTransactionHandle;
begin
  CheckResult(FMethodTable.FDBXConnection_BeginTransaction(FConnectionHandle, TransactionHandle, Integer(Isolation)));
  Result := TDBXDynalinkTransaction.Create(Self, Isolation, TransactionHandle);
end;

function TDBXDynalinkConnection.DerivedCreateCommand: TDBXCommand;
begin
  Result := TDBXMorphicCommand.Create(FDBXContext, Self);
//  Result := TDBXDynalinkCommand.Create(FDBXContext, FConnectionHandle, FMethodTable);
end;

//function TDBXDynalinkConnection.CreateAndBeginTransaction: TDBXTransaction;
//var
//  TransactionHandle: TDBXTransactionHandle;
//begin
//  CheckResult(FMethodTable.FDBXConnection_BeginTransaction(FConnectionHandle, TransactionHandle, Integer(FIsolationLevel)));
//  Result := TDBXDynalinkTransaction.Create(Self, FIsolationLevel, TransactionHandle);
//end;

procedure TDBXDynalinkConnection.CheckResult(DBXResult: TDBXErrorCode);
begin
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDBXContext, DBXResult, FConnectionHandle, '');
end;

procedure TDBXDynalinkConnection.Close;
begin
  inherited Close;
  CheckResult(FMethodTable.FDBXBase_Close(FConnectionHandle));
  FConnectionHandle := nil;
end;

procedure TDBXDynalinkConnection.Commit(InTransaction: TDBXTransaction);
var
  Transaction: TDBXDynalinkTransaction;
begin
  Transaction := TDBXDynalinkTransaction(InTransaction);
  CheckResult(FMethodTable.FDBXConnection_Commit(FConnectionHandle, Transaction.FTransactionHandle));
end;

procedure TDBXDynalinkConnection.Rollback(InTransaction: TDBXTransaction);
var
  Transaction: TDBXDynalinkTransaction;
begin
  Transaction := TDBXDynalinkTransaction(InTransaction);
  CheckResult(FMethodTable.FDBXConnection_Rollback(FConnectionHandle, Transaction.FTransactionHandle));
end;

{$IF NOT DEFINED(CLR)}
function NativeDBXCallback(Handle: DBXCallbackHandle;
 TraceCategory: TInt32; TraceMessage: TDBXWideString): CBRType; stdcall;
begin
  Result := TDBXDynalinkConnection(Handle).DBXCallback(nil, TraceCategory, TraceMessage);
end;
{$IFEND}

procedure TDBXDynalinkConnection.SetTraceInfoEvent(
  TraceInfoEvent: TDBXTraceEvent);
var
  CallbackHandle:   DBXCallbackHandle;
begin
  inherited;
  if not Assigned(TraceInfoEvent) then
    CheckResult(FMethodTable.FDBXConnection_SetCallbackEvent(FConnectionHandle, nil, nil))
  else
  begin
{$IF DEFINED(CLR)}
    FTraceCallback   := DBXCallback;
    CallbackHandle   := nil;
{$ELSE}
    FTraceCallback   := NativeDBXCallback;
    CallbackHandle   := Self;
{$IFEND}
    CheckResult(FMethodTable.FDBXConnection_SetCallbackEvent(FConnectionHandle, CallbackHandle, FTraceCallback));
  end;
end;

function TDBXDynalinkConnection.DBXCallback(Handle: DBXCallbackHandle;
TraceFlag: TDBXTraceFlag;
{$IF DEFINED(CLR)}
[MarshalAs(UnmanagedType.LPWStr)]
{$IFEND}
TraceMessage: TDBXWideString): CBRType; {$IF NOT DEFINED(CLR)} stdcall; {$IFEND}
begin
  Result := FDBXContext.Trace(TraceFlag, TraceMessage);
end;

constructor TDBXDynalinkConnection.Create(
  ConnectionBuilder:        TDBXConnectionBuilder;
  ConnectionHandle:     TDBXConnectionHandle;
  MethodTable:          TDBXMethodTable);
begin
  inherited Create(ConnectionBuilder);
  FConnectionHandle := ConnectionHandle;
  FMethodTable      := MethodTAble;
end;

procedure TDBXDynalinkConnection.DerivedGetCommands(CommandType: WideString;
  List: TWideStrings);
begin
end;

procedure TDBXDynalinkConnection.DerivedGetCommandTypes(List: TWideStrings);
begin
end;

procedure TDBXDynalinkConnection.DerivedOpen;
var
  Count:          TInt32;
  Names:          TWideStringArray;
  Values:         TWideStringArray;
  IsolationLevel: Integer;
  DBXError:       TDBXErrorCode;
begin
  Count := FConnectionProperties.Properties.Count;
  FConnectionProperties.GetLists(Names, Values);

  CheckResult(FMethodTable.FDBXConnection_Connect(FConnectionHandle, Count, Names, Values));
  DBXError := FMethodTable.FDBXConnection_GetIsolation(FConnectionHandle, IsolationLevel);
  // Some drivers like mysql do not support isoalation level.
  //
  if DBXError = TDBXErrorCodes.NotSupported then
    IsolationLevel := TInt32(TDBXIsolations.DirtyRead)
  else
    CheckResult(DBXError);

  FIsolationLevel := TDBXIsolation(IsolationLevel);

end;


function TDBXDynalinkConnection.GetVendorProperty(const Name: WideString): WideString;
var
  ErrorResult: TDBXErrorCode;
  StringVersionBuilder: TDBXWideStringBuilder;
begin
  if Assigned(FMethodTable.FDBXConnection_GetVendorProperty) then
  begin
    StringVersionBuilder := TDBXPlatform.CreateWideStringBuilder(MAX_VERSION_STRING_LENGTH+1);
    try
      ErrorResult := FMethodTable.FDBXConnection_GetVendorProperty(FConnectionHandle, TDBXWideString(Name), (StringVersionBuilder), MAX_VERSION_STRING_LENGTH);
      if ErrorResult = TDBXErrorCodes.None then
        Result := TDBXPlatform.ToWideString(StringVersionBuilder)
      else
        Result := '';
    except
      Result := '';
    end;
    TDBXPlatform.FreeAndNilWideStringBuilder(StringVersionBuilder);
  end else
    Result := '';
end;

{ TDBXDynalinkCommand }

function TDBXDynalinkCommand.CreateParameterRow: TDBXRow;
var
  ParameterRowHandle: TDBXRowHandle;
begin
  if FCommandHandle = nil then
    Open;
  CheckResult(FMethodTable.FDBXCommand_CreateParameterRow(FCommandHandle, ParameterRowHandle));
//  Result := TDBXDynalinkRow.Create(FDBXContext, FMethodTable, ParameterRowHandle);
  // by TSV
  Result := TDBXDynalinkRowEx.Create(FDBXContext, FMethodTable, ParameterRowHandle);
end;

procedure TDBXDynalinkCommand.CheckResult(DBXResult: TDBXErrorCode);
begin
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDBXContext, DBXResult, FCommandHandle, '');
end;

destructor TDBXDynalinkCommand.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TDBXDynalinkCommand.DerivedClose;
begin
  if FCommandHandle <> nil then
  begin
    CheckResult(FMethodTable.FDBXBase_Close(FCommandHandle));
    FCommandHandle := nil;
  end;
end;

constructor TDBXDynalinkCommand.Create(DBXContext: TDBXContext;
  ConnectionHandle: TDBXConnectionHandle;
  MethodTable: TDBXMethodTable);
begin
  inherited Create(DBXContext);
  FConnectionHandle  := ConnectionHandle;
  FMethodTable    := MethodTable;
end;


function TDBXDynalinkCommand.DerivedExecuteQuery: TDBXReader;
var
  ReaderHandle: TDBXReaderHandle;
  ByteReader: TDBXDynalinkByteReader;
begin
  ReaderHandle := nil;

  if FCommandHandle = nil then
    Open;

  // Cheaper than using the property access which will cause a parameter row
  // to be allocated.  Also allows delegate driver to delegate the ParameterRow.
  //
  if ((FParameters = nil) or (FParameters.Count = 0)) and (not isPrepared) then
    CheckResult(FMethodTable.FDBXCommand_ExecuteImmediate(FCommandHandle, TDBXWideString(GetText), ReaderHandle))
  else
    CheckResult(FMethodTable.FDBXCommand_Execute(FCommandHandle, ReaderHandle));
  if ReaderHandle = nil then
  begin
    Result := nil;
  end else begin
    ByteReader := TDBXDynalinkByteReader.Create(FDBXContext, ReaderHandle, FMethodTable);
    Result := TDBXDynalinkReader.Create(FDBXContext, ReaderHandle, FMethodTable, ByteReader);
  end;
end;

procedure TDBXDynalinkCommand.DerivedExecuteUpdate;
var
  ReaderHandle: TDBXReaderHandle;
begin
  // Cheaper than using the property access which will cause a parameter row
  // to be allocated.  Also allows delegate driver to delegate the ParameterRow.
  //
  if ((FParameters = nil) or (FParameters.Count = 0)) and (not isPrepared) then
    CheckResult(FMethodTable.FDBXCommand_ExecuteImmediate(FCommandHandle, TDBXWideString(GetText), ReaderHandle))
  else
    CheckResult(FMethodTable.FDBXCommand_Execute(FCommandHandle, ReaderHandle));
end;


function TDBXDynalinkCommand.DerivedGetNextReader: TDBXReader;
var
  ReaderHandle: TDBXReaderHandle;
  ByteReader: TDBXDynalinkByteReader;
  DBXResult: TDBXErrorCode;
begin
  Result := nil;
  DBXResult := FMethodTable.FDBXCommand_GetNextReader(FCommandHandle, ReaderHandle);
  if    (DBXResult <> TDBXErrorCodes.EOF)
    and (DBXResult <> TDBXErrorCodes.NotSupported)
    and (DBXResult <> TDBXErrorCodes.NoData) then
  begin
    CheckResult(DBXResult);
    ByteReader := TDBXDynalinkByteReader.Create(FDBXContext, ReaderHandle, FMethodTable);
    Result := TDBXDynalinkReader.Create(FDBXContext, ReaderHandle, FMethodTable, ByteReader);
  end;
end;

function TDBXDynalinkCommand.GetRowsAffected: Int64;
begin
  CheckResult(FMethodTable.FDBXCommand_GetRowsAffected(FCommandHandle, Result));
end;

procedure TDBXDynalinkCommand.DerivedOpen;
var
  DBXResult: TDBXErrorCode;
begin
  DBXResult := FMethodTable.FDBXConnection_CreateCommand(FConnectionHandle, TDBXWideString(CommandType), FCommandHandle);
  // Must use the FConnectionHandle, because the FCommandHandle
  // could not be created.
  //
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDBXContext, DBXResult, FConnectionHandle, '');
end;

procedure TDBXDynalinkCommand.DerivedPrepare;
begin
  CheckResult(FMethodTable.FDBXCommand_Prepare(FCommandHandle, TDBXWideString(GetText), Parameters.Count));
end;

procedure TDBXDynalinkCommand.SetMaxBlobSize(const MaxBlobSize: Int64);
begin
  Open;
  CheckResult(FMethodTable.FDBXCommand_SetMaxBlobSize(FCommandHandle, MaxBlobSize));
end;

procedure TDBXDynalinkCommand.SetRowSetSize(const RowSetSize: Int64);
begin
  Open;
  CheckResult(FMethodTable.FDBXCommand_SetRowSetSize(FCommandHandle, RowSetSize));
end;


{ TDBXDynalinkReader }

procedure TDBXDynalinkReader.CheckResult(DBXResult: TDBXErrorCode);
begin
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDBXContext, DBXResult, FReaderHandle, '');
end;

procedure TDBXDynalinkReader.DerivedClose;
begin
  if FReaderHandle <> nil then
  begin
    CheckResult(FMethodTable.FDBXBase_Close(FReaderHandle));
    FReaderHandle := nil;
  end;
end;

constructor TDBXDynalinkReader.Create(DBXContext: TDBXContext;
  ReaderHandle: TDBXReaderHandle; MethodTable: TDBXMethodTable; ByteReader: TDBXByteReader);
var
  Ordinal:            TInt32;
  Length:             TInt32;
  ColumnType:         TInt32;
  ColumnSubType:      TInt32;
  Precision:          TInt32;
  Scale:              TInt32;
  Flags:              TInt32;
  Column:             TDBXValueType;
  ColumnCount:        TInt32;
  Values:             TDBXValueArray;
  NameStringBuilder:  TDBXWideStringBuilder;
  MaxIdentifier:      TInt32;
  Name:               WideString;
begin
  inherited Create(DBXContext, TDBXDynalinkRow.Create(DBXContext, MethodTable, ReaderHandle), ByteReader);
  FReaderHandle := ReaderHandle;
  FMethodTable  := MethodTable;
  CheckResult(FMethodTable.FDBXReader_GetColumnCount(ReaderHandle, ColumnCount));
  SetLength(Values, ColumnCount);

  MaxIdentifier := 255;
  NameStringBuilder := TDBXPlatform.CreateWideStringBuilder(MaxIdentifier+1);
  try

    for Ordinal := 0 to High(Values) do
    begin

      CheckResult(FMethodTable.FDBXReader_GetColumnMetadata(
          ReaderHandle, Ordinal, TDBXWideStringBuilder(NameStringBuilder), ColumnType,
          ColumnSubType, Length, Precision, Scale, Flags));

      Column                := TDBXDriverHelp.CreateTDBXValueType(DBXContext);
      Column.DataType       := ColumnType;
      Column.SubType        := ColumnSubType;
      Column.Ordinal        := Ordinal;
      Column.Precision      := Precision;
      Column.Scale          := Scale;
      Column.Size           := Length;
      TDBXPlatform.CopyWideStringBuilder(NameStringBuilder, Name);
      Column.Name           := Name;
      Column.ValueTypeFlags := Flags;

      Values[Ordinal] := TDBXValue.CreateValue(FDBXContext, Column, FDbxRow, true);

    end;

  finally
    TDBXPlatform.FreeAndNilWideStringBuilder(NameStringBuilder);
  end;

  SetValues(Values);

  end;

function TDBXDynalinkReader.DerivedNext: Boolean;
var
  DBXResult: TDBXErrorCode;
begin
  if FReaderHandle = nil then
    DBXResult := TDBXErrorCodes.NoData
  else
    DBXResult := FMethodTable.FDBXReader_Next(FReaderHandle);

  if DBXResult = TDBXErrorCodes.None then
  begin
    Result := true;
  end else if (DBXResult = TDBXErrorCodes.NoData) or (DBXResult = TDBXErrorCodes.EOF) then
  begin
    Result := false;
  end else
  begin
    Result := false;
    CheckResult(DBXResult);
  end;
end;


{ TDBXDynalinkTransaction }


constructor TDBXDynalinkTransaction.Create(Connection: TDBXDynalinkConnection; IsolationLevel: TDBXIsolation; TransactionHandle: TDBXTransactionHandle);
begin
  inherited Create(Connection);
  FIsolationLevel     := IsolationLevel;
  FTransactionHandle  := TransactionHandle;
end;





{ TDBXDynalinkByteReader }

procedure TDBXDynalinkByteReader.CheckResult(DBXResult: TDBXErrorCode);
begin
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDBXContext, DBXResult, FReaderHandle, '');
end;



constructor TDBXDynalinkByteReader.Create(DBXContext: TDBXContext;
  ReaderHandle: TDBXReaderHandle; MethodTable: TDBXMethodTable);
begin
  inherited Create(DBXContext);
  FReaderHandle := ReaderHandle;
  FMethodTable  := MethodTable;
end;


procedure TDBXDynalinkByteReader.GetBcd(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  CheckResult(FMethodTable.FDBXRow_GetFixedBytes(FReaderHandle, Ordinal,
{$IF DEFINED(CLR)}
                                            Value, Borland.Delphi.System.Length(Value),
{$ELSE}
                                            Value,
{$IFEND}
                                            Offset, IsNull));
end;


function TDBXDynalinkByteReader.GetBytes(Ordinal: TInt32; Offset: Int64;
  const Value: TBytes; ValueOffset, Length: Int64; var IsNull: LongBool): Int64;
begin
{$IF DEFINED(CLR)}
  CheckResult(FMethodTable.FDBXRow_GetBytes(FReaderHandle,
                                            Ordinal,
                                            Offset,
                                            Value, Borland.Delphi.System.Length(Value),
                                            ValueOffset,
                                            Length,
                                            Result,
                                            IsNull));
{$ELSE}
  CheckResult(FMethodTable.FDBXRow_GetBytes(FReaderHandle,
                                            Ordinal,
                                            Offset,
                                            Value,
                                            ValueOffset,
                                            Length,
                                            Result,
                                            IsNull));
{$IFEND}
end;

procedure TDBXDynalinkByteReader.GetAnsiString(Ordinal: TInt32;
  const Value: TBytes; Offset: Integer; var IsNull: LongBool);
begin
  CheckResult(FMethodTable.FDBXRow_GetFixedBytes(FReaderHandle, Ordinal,
{$IF DEFINED(CLR)}
                                            Value, Borland.Delphi.System.Length(Value),
{$ELSE}
                                            Value,
{$IFEND}
                                            Offset, IsNull));
end;

procedure TDBXDynalinkByteReader.GetDate(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  CheckResult(FMethodTable.FDBXRow_GetFixedBytes(FReaderHandle, Ordinal,
{$IF DEFINED(CLR)}
                                            Value, Borland.Delphi.System.Length(Value),
{$ELSE}
                                            Value,
{$IFEND}
                                            Offset, IsNull));
end;

procedure TDBXDynalinkByteReader.GetDouble(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  CheckResult(FMethodTable.FDBXRow_GetFixedBytes(FReaderHandle, Ordinal,
{$IF DEFINED(CLR)}
                                            Value, Borland.Delphi.System.Length(Value),
{$ELSE}
                                            Value,
{$IFEND}
                                            Offset, IsNull));
end;

procedure TDBXDynalinkByteReader.GetInt16(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  CheckResult(FMethodTable.FDBXRow_GetFixedBytes(FReaderHandle, Ordinal,
{$IF DEFINED(CLR)}
                                            Value, Borland.Delphi.System.Length(Value),
{$ELSE}
                                            Value,
{$IFEND}
                                            Offset, IsNull));
end;

procedure TDBXDynalinkByteReader.GetInt32(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  CheckResult(FMethodTable.FDBXRow_GetFixedBytes(FReaderHandle, Ordinal,
{$IF DEFINED(CLR)}
                                            Value, Borland.Delphi.System.Length(Value),
{$ELSE}
                                            Value,
{$IFEND}
                                            Offset, IsNull));
end;

procedure TDBXDynalinkByteReader.GetInt64(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  CheckResult(FMethodTable.FDBXRow_GetFixedBytes(FReaderHandle, Ordinal,
{$IF DEFINED(CLR)}
                                            Value, Borland.Delphi.System.Length(Value),
{$ELSE}
                                            Value,
{$IFEND}
                                            Offset, IsNull));
end;

procedure TDBXDynalinkByteReader.GetByteLength(Ordinal: TInt32; var Length: Int64;
  var IsNull: LongBool);
begin
  CheckResult(FMethodTable.FDBXRow_GetByteLength(FReaderHandle, Ordinal, Length, IsNull));
end;


procedure TDBXDynalinkByteReader.GetTime(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  CheckResult(FMethodTable.FDBXRow_GetFixedBytes(FReaderHandle, Ordinal,
{$IF DEFINED(CLR)}
                                            Value, Borland.Delphi.System.Length(Value),
{$ELSE}
                                            Value,
{$IFEND}
                                            Offset, IsNull));
end;

procedure TDBXDynalinkByteReader.GetTimeStamp(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  CheckResult(FMethodTable.FDBXRow_GetFixedBytes(FReaderHandle, Ordinal,
{$IF DEFINED(CLR)}
                                            Value, Borland.Delphi.System.Length(Value),
{$ELSE}
                                            Value,
{$IFEND}
                                            Offset, IsNull));
end;

procedure TDBXDynalinkByteReader.GetWideString(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  CheckResult(FMethodTable.FDBXRow_GetFixedBytes(FReaderHandle, Ordinal,
{$IF DEFINED(CLR)}
                                            Value, Borland.Delphi.System.Length(Value),
{$ELSE}
                                            Value,
{$IFEND}
                                            Offset, IsNull));
end;


{ TDBXDynalinkRow }

procedure TDBXDynalinkRow.CheckResult(DBXResult: TDBXErrorCode);
begin
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDBXContext, DBXResult, FRowHandle, '');
end;

procedure TDBXDynalinkRow.ParameterError(DBXResult: TDBXErrorCode; DbxValue: TDbxValue);
begin
  if DBXResult = TDBXErrorCodes.UnsupportedFieldType then
  begin
    FMethodTable.RaiseError(FDBXContext, DBXResult, FRowHandle,
    WideFormat(SInvalidDataType, [TDBXValueTypeEx.DataTypeName(DbxValue.ValueType.DataType)]));
  end else
    FMethodTable.RaiseError(FDBXContext, DBXResult, FRowHandle, '');

end;

procedure TDBXDynalinkRow.CheckParameterResult(DBXResult: TDBXErrorCode; DbxValue: TDbxValue);
begin
  if DBXResult <> TDBXErrorCodes.None then
    ParameterError(DBXResult, DbxValue);
end;

constructor TDBXDynalinkRow.Create(DBXContext: TDBXContext; MethodTable: TDBXMethodTable; RowHandle: TDBXRowHandle);
begin
  inherited Create(DBXContext);
  FRowHandle := RowHandle;
  FMethodTable        := MethodTable;
end;

procedure TDBXDynalinkRow.GetBcd(DbxValue: TDBXBcdValue; var Value: TBcd;
  var IsNull: LongBool);
var
  DBXResult: TDBXErrorCode;
begin
  DBXResult := FMethodTable.FDBXRow_GetBcd(FRowHandle, DbxValue.ValueType.Ordinal, Value, IsNull);
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FdbxContext, DBXResult, FRowHandle);
end;

procedure TDBXDynalinkRow.GetByteLength(DbxValue: TDBXByteArrayValue; var ByteLength: Int64; var IsNull: LongBool);
var
  DBXResult: TDBXErrorCode;
begin
  DBXResult := FMethodTable.FDBXRow_GetByteLength(FRowHandle, DbxValue.ValueType.Ordinal, ByteLength, IsNull);
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDbxContext, DBXResult, FRowHandle);
end;

procedure TDBXDynalinkRow.GetLength(DbxValue: TDBXValue;
  var ByteLength: Int64; var IsNull: LongBool);
var
  DBXResult: TDBXErrorCode;
begin
  DBXResult := FMethodTable.FDBXRow_GetByteLength(FRowHandle, DbxValue.ValueType.Ordinal, ByteLength, IsNull);
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDbxContext, DBXResult, FRowHandle);
end;

procedure TDBXDynalinkRow.GetBytes(DbxValue: TDBXByteArrayValue;
  Offset: Int64; const Buffer: TBytes; BufferOffset, Length: Int64;
  var ReturnLength: Int64; var IsNull: LongBool);
begin
{$IF DEFINED(CLR)}
  CheckResult(FMethodTable.FDBXRow_GetBytes(FRowHandle, DbxValue.ValueType.Ordinal, Offset, Buffer, Borland.Delphi.System.Length(Buffer), BufferOffset, Length, ReturnLength, IsNull));
{$ELSE}
  CheckResult(FMethodTable.FDBXRow_GetBytes(FRowHandle, DbxValue.ValueType.Ordinal, Offset, Buffer, BufferOffset, Length, ReturnLength, IsNull));
{$IFEND}
end;

procedure TDBXDynalinkRow.GetBoolean(DbxValue: TDBXBooleanValue;
  var Value: LongBool; var IsNull: LongBool);
var
  DBXResult: TDBXErrorCode;
begin
  DBXResult := FMethodTable.FDBXRow_GetBoolean(FRowHandle, DbxValue.ValueType.Ordinal, Value, IsNull);
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDbxContext, DBXResult, FRowHandle);
end;


procedure TDBXDynalinkRow.GetDate(DbxValue: TDBXDateValue; var Value: TDBXDate; var IsNull: LongBool);
var
  DBXResult: TDBXErrorCode;
begin
  DBXResult := FMethodTable.FDBXRow_GetDate(FRowHandle, DbxValue.ValueType.Ordinal, Value, IsNull);
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDBXContext, DBXResult, FRowHandle);
end;



procedure TDBXDynalinkRow.GetDouble(DbxValue: TDBXDoubleValue;
  var Value: Double; var IsNull: LongBool);
var
  DBXResult: TDBXErrorCode;
begin
  DBXResult := FMethodTable.FDBXRow_GetDouble(FRowHandle, DbxValue.ValueType.Ordinal, Value, IsNull);
  if DBXResult <> TDBXErrorCodes.None then
      FMethodTable.RaiseError(FDbxContext, DBXResult, FRowHandle);
end;

procedure TDBXDynalinkRow.GetInt16(DbxValue: TDBXInt16Value;
  var Value: SmallInt; var IsNull: LongBool);
var
  DBXResult: TDBXErrorCode;
begin
  DBXResult := FMethodTable.FDBXRow_GetInt16(FRowHandle, DbxValue.ValueType.Ordinal, Value, IsNull);
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDbxContext, DBXResult, FRowHandle);
end;

procedure TDBXDynalinkRow.GetInt32(DbxValue: TDBXInt32Value;
  var Value: TInt32; var IsNull: LongBool);

var
  DBXResult: TDBXErrorCode;
begin
  DBXResult := FMethodTable.FDBXRow_GetInt32(FRowHandle, DbxValue.ValueType.Ordinal, Value, IsNull);
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDbxContext, DBXResult, FRowHandle);
end;

procedure TDBXDynalinkRow.GetInt64(DbxValue: TDBXInt64Value;
  var Value: Int64; var IsNull: LongBool);

var
  DBXResult: TDBXErrorCode;
begin
  DBXResult := FMethodTable.FDBXRow_GetInt64(FRowHandle, DbxValue.ValueType.Ordinal, Value, IsNull);
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDbxContext, DBXResult, FRowHandle);
end;


function TDBXDynalinkRow.GetObjectTypeName(Ordinal: TInt32): WideString;
var
  WideStringBuilder: TDBXWideStringBuilder;
  DBXResult: TDBXErrorCode;
  MaxLength: Integer;
begin
  MaxLength := 128;
  WideStringBuilder := TDBXPlatform.CreateWideStringBuilder(MaxLength);
  try
    DBXResult := FMethodTable.FDBXRow_GetObjectTypeName(FRowHandle, Ordinal, WideStringBuilder, MaxLength);
    if DBXResult <> TDBXErrorCodes.None then
      FMethodTable.RaiseError(FDBXContext, DBXResult, FRowHandle);
    Result := TDBXPlatform.ToWideString(WideStringBuilder);
  finally
      TDBXPlatform.FreeAndNilWideStringBuilder(WideStringBuilder);
  end;
end;


procedure TDBXDynalinkRow.GetAnsiString(DbxValue: TDBXAnsiStringValue; var AnsiStringVar: TDBXAnsiStringBuilder; var IsNull: LongBool);
var
  DBXResult: TDBXErrorCode;
begin
    DBXResult := FMethodTable.FDBXRow_GetString(FRowHandle, DbxValue.ValueType.Ordinal, AnsiStringVar, IsNull);
    if DBXResult <> TDBXErrorCodes.None then
      FMethodTable.RaiseError(FDBXContext, DBXResult, FRowHandle);
end;

procedure TDBXDynalinkRow.GetTime(DbxValue: TDBXTimeValue;
  var Value: TDBXTime; var IsNull: LongBool);
var
  DBXResult: TDBXErrorCode;
begin
  DBXResult := FMethodTable.FDBXRow_GetTime(FRowHandle, DbxValue.ValueType.Ordinal, Value, IsNull);
    if DBXResult <> TDBXErrorCodes.None then
      FMethodTable.RaiseError(FDbxContext, DBXResult, FRowHandle);
end;

procedure TDBXDynalinkRow.GetTimeStamp(DbxValue: TDBXTimeStampValue;
  var Value: TSQLTimeStamp; var IsNull: LongBool);
var
  DBXResult: TDBXErrorCode;
begin
  DBXResult := FMethodTable.FDBXRow_GetTimeStamp(FRowHandle, DbxValue.ValueType.Ordinal, Value, IsNull);
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDbxContext, DBXResult, FRowHandle);
end;


procedure TDBXDynalinkRow.GetWideString(DbxValue: TDBXWideStringValue; var WideStringBuilder: TDBXWideStringBuilder; var IsNull: LongBool);
var
  DBXResult: TDBXErrorCode;
begin
//  DBXResult := FMethodTable.FDBXRow_GetWideString(FRowHandle, DbxValue.ValueType.Ordinal, TDBXWideStringVar(WideStringBuilder), IsNull);
  DBXResult := FMethodTable.FDBXRow_GetWideString(FRowHandle, DbxValue.ValueType.Ordinal, WideStringBuilder, IsNull);
  if DBXResult <> TDBXErrorCodes.None then
    FMethodTable.RaiseError(FDBXContext, DBXResult, FRowHandle);
end;


procedure TDBXDynalinkRow.SetBCD(DbxValue: TDBXBcdValue; var Value: TBcd);
begin
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetBCD(FRowHandle, DbxValue.ValueType.Ordinal, Value), DbxValue);
end;

procedure TDBXDynalinkRow.SetBoolean(DbxValue: TDBXBooleanValue; Value: Boolean);
begin
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetBoolean(FRowHandle, DbxValue.ValueType.Ordinal, Value), DbxValue);
end;


procedure TDBXDynalinkRow.SetDynamicBytes(DbxValue: TDBXValue; Offset: Int64;
  const Buffer: TBytes; BufferOffset, Count: Int64);
begin
{$IF DEFINED(CLR)}
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetBytes(FRowHandle, DbxValue.ValueType.Ordinal, Offset, Buffer, Length(Buffer), {dummy to simulate native "open array"}
   BufferOffset, Count), DbxValue);
{$ELSE}
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetBytes(FRowHandle, DbxValue.ValueType.Ordinal, Offset, Buffer, Length(Buffer), {dummy to simulate native "open array"}
   BufferOffset, Count), DbxValue);
//  CheckResult(FMethodTable.FDBXWritableRow_SetBytes(FRowHandle, DbxValue.ValueType.Ordinal, Offset, Buffer, BufferOffset, Count));
{$IFEND}
end;

procedure TDBXDynalinkRow.SetDate(DbxValue: TDBXDateValue; Value: TDBXDate);
begin
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetDate(FRowHandle, DbxValue.ValueType.Ordinal, Value), DbxValue);
end;

procedure TDBXDynalinkRow.SetDouble(DbxValue: TDBXDoubleValue; Value: Double);
begin
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetDouble(FRowHandle, DbxValue.ValueType.Ordinal, Value), DbxValue);
end;

procedure TDBXDynalinkRow.SetInt16(DbxValue: TDBXInt16Value; Value: SmallInt);
begin
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetInt16(FRowHandle, DbxValue.ValueType.Ordinal, Value), DbxValue);
end;

procedure TDBXDynalinkRow.SetInt32(DbxValue: TDBXInt32Value; Value: TInt32);
begin
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetInt32(FRowHandle, DbxValue.ValueType.Ordinal, Value), DBXValue);
end;

procedure TDBXDynalinkRow.SetInt64(DbxValue: TDBXInt64Value; Value: Int64);
begin
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetInt64(FRowHandle, DbxValue.ValueType.Ordinal, Value), DbxValue);
end;

procedure TDBXDynalinkRow.SetNull(DbxValue: TDBXValue);
begin
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetNull(FRowHandle, DbxValue.ValueType.Ordinal), DBXValue);
end;

procedure TDBXDynalinkRow.SetValueType(ValueType: TDBXValueType);
begin
  CheckResult(FMethodTable.FDBXParameterRow_SetParameterType(FRowHandle,
    ValueType.Ordinal, TDBXWideString(ValueType.Name),
    ValueType.ChildPosition, ValueType.ParameterDirection, ValueType.DataType,
    ValueType.SubType, ValueType.Size, ValueType.Precision, ValueType.Scale));
end;

procedure TDBXDynalinkRow.SetString(DbxValue: TDBXAnsiStringValue; const Value: String);
begin
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetString(FRowHandle, DbxValue.ValueType.Ordinal, TDBXAnsiString(Value), Length(Value)), DBXValue);
end;

procedure TDBXDynalinkRow.SetTime(DbxValue: TDBXTimeValue; Value: TDBXTime);
begin
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetTime(FRowHandle, DbxValue.ValueType.Ordinal, Value), DbxValue);
end;

procedure TDBXDynalinkRow.SetTimestamp(DbxValue: TDBXTimeStampValue; var Value: TSQLTimeStamp);
begin
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetTimeStamp(FRowHandle, DbxValue.ValueType.Ordinal, Value), DbxValue);
end;

procedure TDBXDynalinkRow.SetWideString(DbxValue: TDBXWideStringValue; const Value: WideString);
begin
  CheckParameterResult(FMethodTable.FDBXWritableRow_SetWideString(FRowHandle, DbxValue.ValueType.Ordinal, TDBXWideString(Value), Length(Value)), DbxValue);
end;

{ TDBXDynalinkRowEx }

// by TSV
procedure TDBXDynalinkRowEx.BeforeDestruction;
begin
  inherited BeforeDestruction;
 // CheckResult(FMethodTable.FDBXBase_Close(FRowHandle));
end;

// by TSV
constructor TDBXDynalinkRowEx.Create(DBXContext: TDBXContext; MethodTable: TDBXMethodTable; RowHandle: TDBXRowHandle);
begin
  inherited Create(DBXContext,MethodTable,RowHandle);
end;

// by TSV
destructor TDBXDynalinkRowEx.Destroy;
begin
  inherited Destroy;
end;

initialization
  DBXDynalinkDriverLoaderClass := TDBXDynalinkDriverLoader;
  TClassRegistry.GetClassRegistry
  .RegisterRegistryClass(SDYNALINK_LOADER_NAME, DBXDynalinkDriverLoaderClass);
finalization
  if DBXDynalinkDriverLoaderClass <> nil then
    TClassRegistry.GetClassRegistry
    .UnregisterClass(SDYNALINK_LOADER_NAME);
end.

