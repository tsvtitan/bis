{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Client                                                       }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

/// <summary> DBX Client </summary>

unit DBXClient;

{$WARNINGS OFF}

{$Z+}


interface

uses
  DBXCommon,
  DBXDelegate,
  DBXChannel,
  // Temporary, once we have the metadata on the server, this
  // can be removed.
  //
  DBXDataStoreReadOnlyMetaData,
  DBXRowBuffer,
  DbxJSonStreamWriter,
  DbxErrorHandler,
  DbxTraceHandler,
  DbxJSonStreamReader,
  DbxTokens,
  DbxStringCodes,
{$IF DEFINED(CLR)}
  DBXSocketChannelManaged,
{$ELSE}
//  DBXIndyChannel,
  DBXSocketChannelNative,
{$IFEND}
  DBXPlatform, DBPlatform,
  Classes, SysUtils,
  DBCommonTypes, FMTBcd, SqlTimSt, ClassRegistry, Contnrs
{$IF DEFINED(CLR)}
{$ELSE}
  , WideStrings
{$IFEND}
;

type
  TDBXClientDriverLoaderClass = class of TObject;
  TDBXClientConnection = class;
  TDBXClientCommand = class;
  TDBXClientRow = class;
  TDBXClientReader = class;
  TDBXClientDriverLoader = class(TDBXDriverLoader)
    public
      constructor Create; override;
      function Load(DriverDef: TDBXDriverDef): TDBXDriver; override;
  end;

  TDBXClientDriver = class(TDBXDriverEx)
    private
      function  CreateClientCommand(DbxContext: TDBXContext; Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand;

    strict protected

//      procedure CheckResult(DBXResult: TDBXErrorCode);
    protected
      procedure Close; override;
      function  CreateConnection(ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection; override;
    public
      constructor Create;
      destructor Destroy; override;
      function GetDriverVersion: WideString; override;

  end;
  TDBXClientTransaction = class(TDBXTransaction)
    private
      FTransactionHandle: Integer;
      constructor Create(Connection: TDBXClientConnection; IsolationLevel: TDBXIsolation; TransactionHandle: Integer);
  end;

  TDBXClientConnection = class(TDBXConnectionEx)
    strict private
      FChannel:           TDBXChannel;
      FErrorHandler:      TDbxErrorHandler;
      FTraceHandler:      TDbxTraceHandler;

    private
      FDbxReader:         TDbxJSonStreamReader;
      FDbxWriter:         TDbxJSonStreamWriter;
      FConnectionHandle:  Integer;
      FProductName:       WideString;
      FProtocolVersion:   Integer;
      FCommandList:       TDBXClientCommand;
      FVendorProps:       TWideStringList;

      procedure updateIsolationLevel(IsolationLevel: TDBXIsolation);
      procedure RemoveCommand(RemoveCommand: TDBXClientCommand);

    protected

//      procedure CheckResult(DBXResult: TDBXErrorCode);
      function  CreateAndBeginTransaction(Isolation: TDBXIsolation): TDBXTransaction; override;
      procedure Commit(InTransaction: TDBXTransaction); override;
      procedure Rollback(InTransaction: TDBXTransaction); override;
      procedure Close; override;
      procedure SetTraceInfoEvent(TraceInfoEvent: TDBXTraceEvent); override;
      function  DerivedCreateCommand: TDBXCommand; overload; override;
      procedure DerivedOpen(); override;
      procedure DerivedGetCommandTypes(List: TWideStrings); override;
      procedure DerivedGetCommands(CommandType: WideString; List: TWideStrings); override;
      function  GetProductName: WideString; override;


    public
      constructor Create(ConnectionBuilder: TDBXConnectionBuilder);
      destructor Destroy; override;
      function  GetVendorProperty(const Name: WideString): WideString; override;

  end;

  TDBXClientExtendedStream = class(TStream)
{$IF DEFINED(CLR)}
      function ReadBytes(const Buffer: TBytes; Offset, Count: Longint): Longint; virtual; abstract;
{$ELSE}
    function Seek(Offset: Longint; Origin: Word): Longint; overload; override;
{$IFEND}
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
  end;

  TDBXClientBlobStream = class(TDBXClientExtendedStream)
    private
      FBuffer:            TBytes;
      FOffset:            Integer;
      FReader:            TDBXStreamReader;

    protected
      function GetSize: Int64; override;
{$IF DEFINED(CLR)}
      procedure SetSize(NewSize: Int64); overload; override;
    public
      function Read(var Buffer: array of Byte; Offset, Count: Longint): Longint; overload; override;
      function ReadBytes(const Buffer: TBytes; Offset, Count: Longint): Longint; override;
      function Write(const Buffer: array of Byte; Offset, Count: Longint): Longint; overload; override;
      function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
{$ELSE}
    public
      function Read(var Buffer; Count: Longint): Longint; override;
      function Write(const Buffer; Count: Longint): Longint; override;
{$IFEND}
      destructor Destroy; override;
  end;


  TDBXClientBytesStream = class(TDBXClientExtendedStream)
    private
      FBuffer:            TBytes;
      FOffset:            Integer;
      FSize:              Integer;
    protected
      function GetSize: Int64; override;
{$IF DEFINED(CLR)}
      procedure SetSize(NewSize: Int64); overload; override;
    public
      function Read(var Buffer: array of Byte; Offset, Count: Longint): Longint; overload; override;
      function ReadBytes(const Buffer: TBytes; Offset, Count: Longint): Longint; override;
      function Write(const Buffer: array of Byte; Offset, Count: Longint): Longint; overload; override;
      function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
{$ELSE}
    public
      function Read(var Buffer; Count: Longint): Longint; override;
      function Write(const Buffer; Count: Longint): Longint; override;
{$IFEND}
  end;

  TDBXClientCommand = class(TDBXCommandEx)
    strict private
      FDbxReader:           TDbxJSonStreamReader;
      FDbxWriter:           TDbxJSonStreamWriter;
      FConnectionHandle:    Integer;
      FCommandHandle:       Integer;
      FRowsAffected:        Int64;
      FUpdateable:          Boolean;
      FConnection:          TDBXClientConnection;
      FDbxReaderBuffer:     TDBXRowBuffer;

      function Execute: TDBXReader;
      procedure HandleParameterMoreBlobRequest;
      function ReadTable: TDBXClientReader;

    private
        FDbxParameterBuffer:  TDBXRowBuffer;
        FParameterTypeChange: Boolean;
        FNext:                TDBXClientCommand;

      constructor Create( DBXContext: TDBXContext;
                          Connection: TDBXClientConnection;
                          ConnectionHandle: Integer;
                          DbxReader: TDbxJSonStreamReader;
                          DbxWriter: TDbxJSonStreamWriter
                          );
      procedure NilReaderAndWriter();
//      procedure ReadMoreBlob(Stream: TDBXClientBlobStream);
//      property BlobId: Integer read FBlobId write FBlobId;

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
      function DerivedGetNextReader: TDBXReader; override;
      procedure SetText(const Value: WideString); override;
  public
      destructor Destroy(); override;

  end;


  TDBXClientByteReader = class(TDBXReaderByteReader)
    private
      constructor Create( DBXContext: TDBXContext; ReaderHandle: Integer;
                          ClientReader: TDBXClientReader;
                          DbxReader: TDbxJSonStreamReader; DbxWriter: TDbxJSonStreamWriter;
                          DbxRowBuffer: TDBXRowBuffer);
    private
      FReaderHandle:      Integer;
      FDbxStreamReader:   TDbxJSonStreamReader;
      FDbxStreamWriter:   TDbxJSonStreamWriter;
      FDbxRowBuffer:      TDBXRowBuffer;
      FDbxClientReader:   TDBXClientReader;
    public
      procedure GetAnsiString(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetWideString(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
//      procedure GetBoolean(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetInt16(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetInt32(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetInt64(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetDouble(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;


  end;

  TDBXClientReader = class(TDBXReader)
    strict private
      FReadLastBuffer:    Boolean;
    private
      FByteReader:  TDBXReaderByteReader;
      FPosition:          Int64;
      constructor Create( DBXContext: TDBXContext;
                          ReaderHandle: Integer;
                          DbxRow: TDBXRow;
                          DbxReader: TDbxJSonStreamReader; DbxWriter: TDbxJSonStreamWriter;
                          DbxRowBuffer: TDBXRowBuffer);
      function ReadData: Boolean;
    protected
      FReaderHandle:      Integer;
      FDbxReader:         TDbxJSonStreamReader;
      FDbxWriter:         TDbxJSonStreamWriter;
      FDbxRowBuffer:      TDBXRowBuffer;
      function  GetByteReader: TDBXByteReader; override;
      procedure DerivedClose; override;
      function DerivedNext: Boolean; override;
    public
      destructor Destroy; override;

  end;

  TDBXClientRow = class(TDBXRowEx)
    private
      FReaderHandle:          Integer;
      FDbxStreamReader:       TDbxJSonStreamReader;
      FDbxStreamWriter:       TDbxJSonStreamWriter;
      FDbxRowBuffer:          TDBXRowBuffer;
      FDbxClientCommand:      TDBXClientCommand;
      FDbxClientReader:       TDBXClientReader;
      FDBXLookAheadStreamReader:   TDBXLookAheadStreamReader;
      FTZInfo:                TTimeZone;
      FTZInfoInitialized:     Boolean;
      FLastParameterOrdinal:  Integer;

      procedure InitTZInfo;
//      procedure CreateBlobStream(Ordinal: Integer; var Stream: TStream);
      procedure ProcessStringOverFlow(DbxValue: TDBXWideStringValue);
      procedure CheckParameter(DbxValue: TDBXValue);
    protected
      constructor Create(DBXContext: TDBXContext; ReaderHandle: Integer;
                          DbxClientCommand: TDBXClientCommand;
                          DbxStreamReader: TDbxJSonStreamReader; DbxStreamWriter: TDbxJSonStreamWriter;
                          DbxRowBuffer: TDBXRowBuffer);

      function  UseExtendedTypes: Boolean; override;
      procedure GetAnsiString(DbxValue: TDBXAnsiStringValue; var AnsiStringVar: TDBXAnsiStringBuilder; var IsNull: LongBool); override;
      procedure GetWideChars(DbxValue: TDBXWideStringValue; var WideChars: TDBXWideChars; var Count: Integer; var IsNull: LongBool); override;
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
      procedure GetStream(DbxValue: TDBXStreamValue; var Stream: TStream; var IsNull: LongBool); overload; override;
      procedure GetStream(DbxValue: TDBXWideStringValue; var Stream: TStream; var IsNull: LongBool); overload; override;
      procedure GetStreamBytes(DbxValue: TDBXStreamValue; const Buffer: TBytes; BufferOffset, Length, ReturnLength: Int64; var IsNull: LongBool); override;
      procedure GetStreamLength(DbxValue: TDBXStreamValue; StreamLength: Int64; var IsNull: LongBool); override;

      procedure SetNull(DbxValue: TDBXValue); override;
      procedure SetString(DbxValue: TDBXAnsiStringValue; const Value: String); override;
      procedure SetWideChars(DbxValue: TDBXWideStringValue; const Value: WideString); override;
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
      procedure SetStream(DbxValue:     TDBXStreamValue;
                          StreamReader: TDBXStreamReader); overload; override;
      function  CreateCustomValue(ValueType: TDBXValueType): TDBXValue; override;
    public
      destructor Destroy; override;
  end;

  TDBXClientParameterRow = class(TDBXClientRow)
    private
      function UseRowValue(DbxValue: TDBXWritableValue): Boolean; inline;
    protected
      constructor Create(DBXContext: TDBXContext; ReaderHandle: Integer;
                          DbxClientCommand: TDBXClientCommand;
                          DbxStreamReader: TDbxJSonStreamReader; DbxStreamWriter: TDbxJSonStreamWriter;
                          DbxRowBuffer: TDBXRowBuffer);
      procedure GetAnsiString(DbxValue: TDBXAnsiStringValue; var AnsiStringVar: TDBXAnsiStringBuilder; var IsNull: LongBool); override;
      procedure GetWideChars(DbxValue: TDBXWideStringValue; var WideChars: TDBXWideChars; var Count: Integer; var IsNull: LongBool); override;
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
      procedure GetStream(DbxValue: TDBXStreamValue; var Stream: TStream; var IsNull: LongBool); overload; override;
      procedure GetStream(DbxValue: TDBXWideStringValue; var Stream: TStream; var IsNull: LongBool); overload; override;
      procedure GetStreamBytes(DbxValue: TDBXStreamValue; const Buffer: TBytes; BufferOffset, Length, ReturnLength: Int64; var IsNull: LongBool); override;
      procedure GetStreamLength(DbxValue: TDBXStreamValue; StreamLength: Int64; var IsNull: LongBool); override;
  end;

  TDBXClientWideCharsValue = class(TDBXWideCharsValueEx)
    private
      FDbxByteStreamReader: TDBXByteStreamReader;
      procedure SetByteStreamReader(const Bytes: TBytes);
    public
      constructor Create(ValueType: TDBXValueType);
      destructor Destroy; override;
      function GetValueSize: Int64; override;
      function GetBytes(Offset: Int64; const Value: TBytes; BufferOffset, Length: Int64): Int64; overload; override;
      function GetAnsiString: String; override;
      procedure SetAnsiString(const Value: String); override;

  end;

  const

{$IF DEFINED(CLR)}
  SCLIENT_LOADER_NAME = 'Borland.Data.'+'TDBXClientDriverLoader'; { Do not resource }
{$ELSE}
  SCLIENT_LOADER_NAME      =        'TDBXClientDriverLoader'; { Do not resource }
{$IFEND}
resourcestring
  ParameterNotSet     = 'Parameter not set for column number %d';

implementation
const
  // This may be potentially added to TDBXDataTypes as type 27 in the future.
  // Adding a new data type would be too disruptive at this point in time.
  // So Singles will be surfaced as Doubles with casts when reading and writing.
  //
  SingleType = 27;
type

ClientErrorHandler = class(TDbxErrorHandler)
  FDbxContext:  TDBXContext;
  private
    constructor Create(DbxContext: TDBXContext);
  public
    procedure HandleError(ErrorCode: Integer; ErrorMessage: WideString; Ex: Exception); override;

end;

ClientTraceHandler = class(TDbxTraceHandler)
  FDbxContext:  TDBXContext;
  private
    constructor Create(DbxContext: TDBXContext);
  public
    procedure Trace(Message: WideString); override;
  protected
    function IsTracing: Boolean; override;

end;

var
  DBXClientDriverLoaderClass: TDBXClientDriverLoaderClass;

  { TDBXClientDriver }

procedure TDBXClientDriver.Close;
begin
  inherited;

end;

constructor TDBXClientDriver.Create;
begin
  inherited;
  // '' makes this the default command factory.
  //
  AddCommandFactory('', CreateClientCommand);

end;

function TDBXClientDriver.CreateClientCommand(DbxContext: TDBXContext;
  Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand;
var
  ClientConnection: TDBXClientConnection;
begin
  ClientConnection := TDBXClientConnection(Connection);
  Result := TDBXClientCommand.Create(DbxContext, ClientConnection,
                                     ClientConnection.FConnectionHandle,
                                     ClientConnection.FDbxReader,
                                     ClientConnection.FDbxWriter);
end;

function TDBXClientDriver.CreateConnection(
  ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection;
begin
  Result := TDBXClientConnection.Create(ConnectionBuilder);
end;

destructor TDBXClientDriver.Destroy;
begin

  inherited;
end;

function TDBXClientDriver.GetDriverVersion: WideString;
begin
  Result := DBXVersion40;
end;

{ TDBXClientDriverLoader }

constructor TDBXClientDriverLoader.Create;
begin
  inherited Create;
end;

function TDBXClientDriverLoader.Load(DriverDef: TDBXDriverDef): TDBXDriver;
begin
  if DriverDef.FDriverProperties[TDBXPropertyNames.DriverUnit] = 'DBXClient' then
    Result := TDBXClientDriver.Create
  else
    Result := nil;
end;

{ TDBXClientConnection }

procedure TDBXClientConnection.Close;
var
  Command: TDBXClientCommand;
begin
  if FConnectionHandle > 0 then
  begin
    FDbxWriter.WriteDisconnectObject(FConnectionHandle);
    // Keep ASP.NET app from complaining about unhandled exception.
    // Write failes when server closes socket.
    //
    try
      FDbxWriter.Flush;
    except

    end;
  end;

  FConnectionHandle := 0;
  Command := FCommandList;
  while (Command <> nil) do
  begin
    Command.NilReaderAndWriter;
    Command := Command.FNext;
  end;
  FCommandList := nil;

  FreeAndNil(FDbxReader);
  FreeAndNil(FDbxWriter);
  FreeAndNil(FTraceHandler);
  FreeAndNil(FErrorHandler);
  FreeAndNil(FChannel);

  inherited Close;
end;

procedure TDBXClientConnection.Commit(InTransaction: TDBXTransaction);
var
  txId: Integer;
begin
  txId := TDBXClientTransaction(InTransaction).FTransactionHandle;
  if txId = 1 then
  begin
    FDbxWriter.WriteTxEnd(true, txId);
    FDbxReader.NextResultObjectStart;
    FDbxReader.SkipToEndOfObject;
  end;
end;

constructor TDBXClientConnection.Create(
  ConnectionBuilder: TDBXConnectionBuilder);
begin
  inherited Create(ConnectionBuilder);
  FVendorProps := TWideStringList.Create;

end;


function TDBXClientConnection.CreateAndBeginTransaction(
  Isolation: TDBXIsolation): TDBXTransaction;
var
  TransactionHandle: Integer;
begin
  FDbxWriter.WriteTxBegin(Isolation);
  TransactionHandle := FDbxReader.ReadIntResultObject;
  Result := TDBXClientTransaction.Create(Self, Isolation, TransactionHandle);
end;

function TDBXClientConnection.DerivedCreateCommand: TDBXCommand;
begin
  Result := TDBXMorphicCommand.Create(FDBXContext, Self);
//  Result := TDBXClientCommand.Create(FDBXContext, Self, FConnectionHandle, FDbxReader, FDbxWriter);
end;

procedure TDBXClientConnection.DerivedGetCommands(CommandType: WideString;
  List: TWideStrings);
begin
  inherited;

end;

function TDBXClientConnection.GetProductName: WideString;
begin
  Result := FProductName;
end;

function TDBXClientConnection.GetVendorProperty(
  const Name: WideString): WideString;
var
  Index: Integer;
begin
  if FProtocolVersion >= TDbxJSonStreamWriter.ProtocolVersion2 then
  begin
    Index := FVendorProps.IndexOfName(Name);
    if Index > -1 then
    begin
      Result := FVendorProps.ValueFromIndex[Index];
    end else
    begin
      FDbxWriter.WriteVendorProperty(Name);

      FDbxReader.NextResultObjectStart;
      FDBXReader.Next(TDBXTokens.ArrayStartToken);
      Result := FDBXReader.ReadString;
      FDbxReader.SkipToEndOfObject;
      FVendorProps.Add(Name+'='+Result);
    end;
  end else
    inherited GetVendorProperty(Name);
end;

procedure TDBXClientConnection.DerivedGetCommandTypes(List: TWideStrings);
begin
  inherited;

end;

procedure TDBXClientConnection.DerivedOpen;
var
  Complete: Boolean;
  Index: Integer;
  Count:          TInt32;
  Names:          TWideStringArray;
  Values:         TWideStringArray;
  Token: Integer;
begin
  Complete := false;
  try
//    FChannel := TDBXIndyTcpChannel.Create;
    FChannel := TDBXSocketChannel.Create;
    FChannel.DbxProperties := FConnectionProperties;
    FChannel.Open;

    FTraceHandler := ClientTraceHandler.Create(FDBXContext);
    FErrorHandler := ClientErrorHandler.Create(FDBXContext);

    FDbxReader := TDbxJSonStreamReader.Create;
    FDbxReader.DbxChannel := FChannel;
    FDbxReader.TheErrorHandler := FErrorHandler;
    FdbxReader.TheTraceHandler := FTraceHandler;
    FDbxReader.Open;

    FDbxWriter := TDbxJSonStreamWriter.Create;
    FDbxWriter.DbxChannel := FChannel;
    FDbxWriter.TheErrorHandler := FErrorHandler;
    FdbxWriter.TheTraceHandler := FTraceHandler;
    FDbxWriter.Open;

    FDbxWriter.WriteConnectObjectStart;
    FDbxWriter.WriteParamsStart;
    Count := FConnectionProperties.Properties.Count;
    FConnectionProperties.GetLists(Names, Values);
    Index := 0;
    FDbxWriter.WriteObjectStart;
    while Index < Count do
    begin
      FDbxWriter.WriteNamedString(Names[Index], Values[Index]);
      inc(Index);
      if Index < Count then
        FDBXWriter.WriteValueSeparator;
    end;
    FDbxWriter.WriteObjectEnd;
    FDbxWriter.WriteArrayEnd;
    FDbxWriter.WriteObjectEnd;
    FDbxWriter.Flush;
    FDbxReader.NextResultObjectStart;
    FDBXReader.Next(TDBXTokens.ArrayStartToken);
    FConnectionHandle := FDBXReader.ReadInt;
    FDbxReader.Next(TDBXTokens.ValueSeparatorToken);
    FProductName := FDbxReader.ReadString;
    Token := FDbxReader.Next;
    if Token = TDBXTokens.ValueSeparatorToken then
      FProtocolVersion := FDBXReader.ReadInt;

    FDbxReader.SkipToEndOfObject;

    Complete := true;
  finally
    if not Complete then
      Close;
  end;
end;


destructor TDBXClientConnection.Destroy;
begin
  FreeAndNil(FVendorProps);
  inherited;
end;

procedure TDBXClientConnection.Rollback(InTransaction: TDBXTransaction);
var
  txId: Integer;
begin
  txId :=TDBXClientTransaction(inTransaction).FTransactionHandle;
  FDbxWriter.WriteTxEnd(false, txId);
  FDbxReader.NextResultObjectStart;
  FDbxReader.SkipToEndOfObject;
end;

procedure TDBXClientConnection.SetTraceInfoEvent(
  TraceInfoEvent: TDBXTraceEvent);
begin
  inherited;

end;

procedure TDBXClientConnection.RemoveCommand(RemoveCommand: TDBXClientCommand);
var
  Prior:    TDBXClientCommand;
  Command:  TDBXClientCommand;
begin
  Prior := nil;
  Command := FCommandList;
  while Command <> nil do
  begin
    if Command = RemoveCommand then
    begin
      if Prior = nil then
        FCommandList := FCommandList.FNext
      else
        FCommandList := Prior.FNext.FNext;
      exit;
    end;
    Prior := Command;
    Command := Command.FNext;
  end;
end;

procedure TDBXClientConnection.updateIsolationLevel(IsolationLevel: TDBXIsolation);
begin
  FIsolationLevel := IsolationLevel;
end;

{ TDBXClientCommand }

constructor TDBXClientCommand.Create(DBXContext: TDBXContext;
  Connection: TDBXClientConnection;
  ConnectionHandle: Integer; DbxReader: TDbxJSonStreamReader;
  DbxWriter: TDbxJSonStreamWriter);
begin
  inherited Create(DBXContext);
  FConnectionHandle := ConnectionHandle;
  FDbxReader := DbxReader;
  FDbxWriter := DbxWriter;
  FConnection := Connection;
  FNext := FConnection.FCommandList;
  FConnection.FCommandList := Self;
end;

function TDBXClientCommand.CreateParameterRow: TDBXRow;
begin
  if FDbxParameterBuffer = nil then
  begin
    FDbxParameterBuffer := TDBXRowBuffer.Create;
    FDbxParameterBuffer.Client := true;
    FDbxParameterBuffer.DbxStreamReader := FDbxReader;
    FDbxParameterBuffer.DbxStreamWriter := FDbxWriter;
    FDbxParameterBuffer.MinBufferSize := 1 * 1024;
    FDbxParameterBuffer.ParameterBuffer := true;
  end;
  FDbxParameterBuffer.Handle := FCommandHandle;

  Result := TDBXClientParameterRow.Create(FDBXContext, FCommandHandle, Self, FDbxReader, FDbxWriter, FDbxParameterBuffer);
end;

procedure TDBXClientCommand.NilReaderAndWriter();
begin
  FdbxReader      := nil;
  FDbxWriter      := nil;
  FCommandHandle  := -1;
end;
procedure TDBXClientCommand.DerivedClose;
begin
  if (FDbxWriter <> nil) and (FCommandHandle >= 0) then
  begin
    FDbxWriter.WriteCommandCloseObject(FCommandHandle);
  end;

end;

function TDBXClientCommand.DerivedExecuteQuery: TDBXReader;
begin
  Result := Execute;
end;

procedure TDBXClientCommand.DerivedExecuteUpdate;
begin
  Execute;
end;

function TDBXClientCommand.DerivedGetNextReader: TDBXReader;
var
  HasMore:      Boolean;
  ResultHandle: Integer;
  ClientReader: TDBXClientReader;

begin
  FDbxWriter.WriteNextResultObject(FCommandHandle);
  FDbxWriter.Flush;
  FDbxReader.NextResultObjectStart;
  FDbxReader.Next(TDbxTokens.ArrayStartToken);
  HasMore := FDbxReader.ReadBoolean;
  FDbxReader.NextValueSeparator;
  FRowsAffected := FDbxReader.ReadLong;
  FDbxReader.NextValueSeparator;
  FUpdateable := FDbxReader.ReadBoolean;
  FDbxReader.NextValueSeparator;
  ResultHandle := FDbxReader.ReadInt;
  FDbxReader.SkipToEndOfObject;
  if HasMore and (ResultHandle > -1) then
  begin
    FDbxReader.Next(TDbxTokens.ObjectStartToken);
    FDbxReader.Next(TDbxTokens.StringStartToken);
    FDbxReader.ReadStringCode;
    ClientReader := ReadTable;
    ClientReader.ReadData;
    Result := ClientReader;
  end
  else
    Result := nil;
end;

procedure TDBXClientCommand.DerivedOpen;
begin
//  FDbxWriter.WriteCreateCommandObject(FConnectionHandle);
//  FCommandHandle := FDbxReader.ReadIntResultObject;
  FCommandHandle := -1; // Initialized on execute and/or prepare.
end;

procedure TDBXClientCommand.DerivedPrepare;
var
  ParameterCount: Integer;
  Ordinal: Integer;
  Parameter: TDBXParameter;
  ExistingParameterCount: Integer;
begin

  FDbxWriter.WritePrepareObject(FCommandHandle, false, CommandType, Text);
  FDbxWriter.Flush;
  FDbxReader.NextResultObjectStart;
  FDbxReader.Next(TDbxTokens.ArrayStartToken);
  repeat
  begin
    FDbxReader.Next(TDbxTokens.ObjectStartToken);
    FDbxReader.Next(TDbxTokens.StringStartToken);
    begin
      case FDbxReader.ReadStringCode of
        TDbxStringCodes.Fields:
        begin
          FDbxReader.Next(TDbxTokens.NameSeparatorToken);
          FDbxReader.Next(TDbxTokens.ArrayStartToken);
          FDbxReader.ReadInt;  // ParameterKind.
          FDbxReader.NextValueSeparator;
          FDbxReader.ReadBoolean; // updateable.
        end;
        TDbxStringCodes.Handle:
        begin
          FDbxReader.Next(TDbxTokens.NameSeparatorToken);
          FDbxReader.Next(TDbxTokens.ArrayStartToken);
          FCommandHandle := FDbxReader.ReadInt;
        end;
        TDbxStringCodes.Parameters:
        begin
          FDbxReader.Next(TDbxTokens.NameSeparatorToken);
          FDbxReader.Next(TDbxTokens.ArrayStartToken);
          ParameterCount := FDbxReader.ReadInt;
          if ParameterCount > 0 then
          begin
            ExistingParameterCount := Parameters.Count;
            if ExistingParameterCount = 0 then
              Parameters.SetCount(ParameterCount);
            for Ordinal := 0 to ParameterCount - 1 do
            begin
              FDbxReader.NextValueSeparator;
              FDbxReader.Next(TDBXTokens.ArrayStartToken);
              Parameter := CreateParameter;
              Parameter.DataType := FDbxReader.ReadInt;
              FDbxReader.NextValueSeparator;
              Parameter.SubType := FDbxReader.ReadInt;
              FDbxReader.NextValueSeparator;
              Parameter.ParameterDirection := FdbxReader.ReadInt;
              FDbxReader.NextValueSeparator;
              Parameter.Precision := FdbxReader.ReadLong;
              FDbxReader.NextValueSeparator;
              Parameter.Scale := FdbxReader.ReadInt;
              FDbxReader.NextValueSeparator;
              Parameter.Name := FDbxReader.ReadString;
              FDbxReader.NextValueSeparator;
              Parameter.ChildPosition  := FDbxReader.ReadInt;
              FDbxReader.NextValueSeparator;
              Parameter.Size           := FDbxReader.ReadInt;
              FDbxReader.SkipToEndOfArray;

              Parameter.ValueTypeFlags := Parameter.ValueTypeFlags or TDBXValueTypeFlagsEx.ExtendedType;

              if ExistingParameterCount = 0 then
              begin
                Parameters.SetParameter(Ordinal, Parameter);
                TDBXDriverHelpEx.UpdateParameterType(Parameter);

              end
              else
                Parameter.Free;
            end;
            if ExistingParameterCount = 0 then
              FParameterTypeChange := false;
          end;
        end;
      end;
      FDbxReader.SkipToEndOfObject;
    end;
  end until FDbxReader.Next <> TDbxTokens.ValueSeparatorToken;

  FDbxReader.SkipToEndOfObject;

end;

destructor TDBXClientCommand.Destroy;
begin
  if FDbxReader <> nil then
    FConnection.RemoveCommand(Self);
  FreeAndNil(FDbxReaderBuffer);
  FreeAndNil(FDbxParameterBuffer);
  inherited Destroy;
end;

function TDBXClientCommand.ReadTable: TDBXClientReader;
var
  ClientReader: TDBXClientReader;
  Row: TDBXClientRow;
  ReaderHandle: Integer;
  ByteReader: TDBXClientByteReader;
begin
  ClientReader := nil;
  ReaderHandle := -1;
  FDbxReader.Next(TDbxTokens.NameSeparatorToken);
  FDbxReader.Next(TDbxTokens.ArrayStartToken);
  repeat
    case FDbxReader.ReadStringCode of
      TDbxStringCodes.Fields:
      begin
        FDbxReader.Next(TDbxTokens.NameSeparatorToken);
        FDbxReader.Next(TDbxTokens.ArrayStartToken);
        ReaderHandle := FDbxReader.ReadInt;
        FDbxReader.Next(TDbxTokens.ValueSeparatorToken);
        FUpdateable   := FDbxReader.ReadBoolean;
        FDBXReader.SkipToEndOfObject;
      end;
      TDbxStringCodes.Columns:
      begin
        FDbxReader.Next(TDbxTokens.NameSeparatorToken);
        FDbxReader.Next(TDbxTokens.ArrayStartToken);
        Row         := nil;
        ByteReader  := nil;
        try
          if FDbxReaderBuffer = nil then
          begin
            FDbxReaderBuffer := TDBXRowBuffer.Create;
            FDbxReaderBuffer.Handle := ReaderHandle;
            FDbxReaderBuffer.Client := true;
            FDbxReaderBuffer.DbxStreamReader := FDbxReader;
            FDbxReaderBuffer.DbxStreamWriter := FDbxWriter;
            FDbxReaderBuffer.PreventDecoderGrowth := true;
            FDbxReaderBuffer.MinBufferSize := 8*1024;
          end;
          Row         := TDBXClientRow.Create(FDBXContext, ReaderHandle, Self, FDbxReader, FDbxWriter, FDbxReaderBuffer);
          ClientReader := TDBXClientReader
          .Create(FDBXContext, ReaderHandle, Row, FDbxReader, FDbxWriter, FDbxReaderBuffer);
          Row.FDbxClientReader := ClientReader;
          FDbxReaderBuffer.ColumnCount := ClientReader.ColumnCount;
          Result := ClientReader;
          LastReader := Result;
          Row         := nil;
          ByteReader  := nil;
        finally
          Row.Free;
          ByteReader.Free;
        end;
        FDBXReader.SkipToEndOfObject;
      end;
      else
        FDBXReader.SkipToEndOfObject;
  end until FDbxReader.Next <> TDbxTokens.ValueSeparatorToken;
  FDBXReader.SkipToEndOfObject;
  Result := ClientReader;
end;

function TDBXClientCommand.Execute: TDBXReader;
var
  ClientReader: TDBXClientReader;
  Index: Integer;
  Parameter: TDBXParameter;
begin
  FRowsAffected := -1;
  FDbxWriter.WriteExecuteStart;
  if IsPrepared then
  begin
    FDbxWriter.WriteHandleObject(FCommandHandle);
    if (FParameters <> nil) and (FParameters.Count > 0) then
    begin
      if FParameterTypeChange then
      begin
        FDbxWriter.WriteValueSeparator;
        FDbxWriter.WriteParametersObjectStart(FParameters.Count);
        for Index := 0 to FParameters.Count - 1 do
        begin
          Parameter := FParameters[Index];
          FDbxWriter.WriteParameter(Parameter.DataType,
                                    Parameter.SubType,
                                    Parameter.ParameterDirection,
                                    Parameter.Precision,
                                    Parameter.Scale,
                                    Parameter.Name,
                                    Parameter.ChildPosition,
                                    Parameter.Size
                                    );

        end;
        FDbxWriter.WriteArrayEnd;
        FDbxWriter.WriteObjectEnd;
      end;

      if (FDbxParameterBuffer.offset > 0) then
      begin
        try
          FDbxWriter.WriteValueSeparator;
          FDbxWriter.WriteDataObject(FDbxParameterBuffer.Buffer, FDbxParameterBuffer.BufferOffset);
        finally
          FDbxParameterBuffer.Post;
        end;
      end;
    end;
  end
  else
    FDbxWriter.WriteExecuteFieldsObject(FCommandHandle, false, CommandType, Text);


  FDbxWriter.WriteArrayEnd;
  FDbxWriter.WriteObjectEnd;
  FDbxWriter.Flush;

  repeat
  begin
    FDbxReader.Next(TDbxTokens.ObjectStartToken);
    FDbxReader.Next(TDbxTokens.StringStartToken);
    begin
      case FDbxReader.ReadStringCode of
        TDbxStringCodes.MoreBlob:
          HandleParameterMoreBlobRequest;
        TDbxStringCodes.Result:
          ;
        TDbxStringCodes.Error:
          FdbxReader.ReadErrorBody;
      end;
    end;
  end until FDbxReader.StringCode = TDbxStringCodes.Result;

  FDbxReader.Next(TDbxTokens.NameSeparatorToken);
  FDbxReader.Next(TDbxTokens.ArrayStartToken);
  ClientReader := nil;
  Result := nil;
  repeat
  begin
    FDbxReader.Next(TDbxTokens.ObjectStartToken);
    FDbxReader.Next(TDbxTokens.StringStartToken);
    begin
      case FDbxReader.ReadStringCode of
        TDbxStringCodes.MoreBlob:
          HandleParameterMoreBlobRequest;
        TDbxStringCodes.Handle:
        begin
          FDbxReader.Next(TDbxTokens.NameSeparatorToken);
          FDbxReader.Next(TDbxTokens.ArrayStartToken);
          FCommandHandle := FDbxReader.ReadInt;
          FDbxReader.SkipToEndOfObject;
        end;
        TDbxStringCodes.Session:
        begin
        FDbxReader.Next(TDbxTokens.NameSeparatorToken);
        FDbxReader.Next(TDbxTokens.ArrayStartToken);
        FDbxReader.ReadBoolean;  // Autocommit.
        FDbxReader.Next(TDbxTokens.ValueSeparatorToken);
        FConnection.updateIsolationLevel(FDbxReader.ReadInt); // Isolation level.
        FDbxReader.Next(TDbxTokens.ValueSeparatorToken);
        FDbxReader.ReadString; // RoleName.
        FDbxReader.SkipToEndOfObject;
        end;
        TDbxStringCodes.Table:
          ClientReader := ReadTable;
        TDbxStringCodes.Rows:
        begin
          FDbxReader.Next(TDbxTokens.NameSeparatorToken);
          FDbxReader.Next(TDbxTokens.ArrayStartToken);
          FRowsAffected := FDbxReader.ReadLong;
          FDbxReader.SkipToEndOfObject;
        end;
        TDbxStringCodes.Data:
        begin
          FDbxReader.Next(TDbxTokens.NameSeparatorToken);
          FDbxReader.Next(TDbxTokens.ArrayStartToken);
          FDbxParameterBuffer.ReadDataBytes;
          FDbxReader.SkipToEndOfObject;
        end;
        else
          FDbxReader.SkipToEndOfObject;
      end;
    end;
  end until FDbxReader.Next <> TDbxTokens.ValueSeparatorToken;
  FDbxReader.SkipToEndOfObject;
  if ClientReader <> nil then
  begin
    ClientReader.ReadData;
    Result := ClientReader;
  end;
  FParameterTypeChange := false;
end;

function TDBXClientCommand.GetRowsAffected: Int64;
begin
  Result := FRowsAffected;
end;

procedure TDBXClientCommand.HandleParameterMoreBlobRequest;
var
//  Handle:   Integer;
//  Id:       Integer;
//  Row:      Int64;
  Ordinal:  Integer;
  Value:    TDBXValue;
begin
  FDbxReader.Next(TDbxTokens.NameSeparatorToken);
  FDbxReader.Next(TDbxTokens.ArrayStartToken);
  //  Handle :=
  FDbxReader.ReadInt;
  FDbxReader.NextValueSeparator;
  //Id :=
  FDbxReader.ReadInt;
  FDbxReader.NextValueSeparator;
  //Row :=
  FDbxReader.ReadLong;
  FDbxReader.NextValueSeparator;
  Ordinal :=  FDbxReader.ReadInt;
  FDbxReader.SkipToEndOfObject;

  Value := Parameters[Ordinal].Value;
  if Value is TDBXStreamValue then
    FDbxWriter.WriteDataObject(
      TDBXDriverHelpEx.GetStreamReader(TDBXStreamValue(Parameters[Ordinal].Value)))
  else
    FDbxWriter.WriteDataObject(
      TDBXClientWideCharsValue(Value).FDbxByteStreamReader);



end;

//procedure TDBXClientCommand.ReadMoreBlob(Stream: TDBXClientBlobStream);
//var
//  Size: Integer;
//begin
//  FDbxWriter.WriteMoreBlobObject(FCommandHandle, Stream.FId, Stream.FRow, Stream.FOrdinal);
//  FDbxReader.NextResultObjectStart;
//  FDbxReader.Next(TDbxTokens.ArrayStartToken);
//  FDbxReader.Next(TDbxTokens.ObjectStartToken);
//  FDbxReader.Next(TDbxTokens.StringStartToken);
//  FDbxReader.ReadStringCode;
//  FDbxReader.Next(TDBXTokens.NameSeparatorToken);
//  FDbxReader.Next(TDbxTokens.ArrayStartToken);
//  Size := FDbxReader.ReadInt;
//  if Size <= 0 then
//  begin
//    Stream.FEOS := true;
//    Size := -Size;
//  end;
//  FDbxReader.NextValueSeparator;
//  if Length(Stream.FBuffer) < Size then
//    SetLength(Stream.FBuffer, Size);
//  FDbxReader.ReadDataBytes(stream.FBuffer, 0, Size);
//  Stream.FOffset := 0;
//  Stream.FBytesRead := Size;
//  FDbxReader.SkipToEndOfObject;
//  FDbxReader.SkipToEndOfObject;
//end;

procedure TDBXClientCommand.SetMaxBlobSize(const MaxBlobSize: Int64);
begin
  Assert(false, 'Not Implemented yet');
end;

procedure TDBXClientCommand.SetRowSetSize(const RowSetSize: Int64);
begin
  Assert(false, 'Not Implemented yet');
end;

procedure TDBXClientCommand.SetText(const Value: WideString);
var
  Temp: WideString;
  Count: Integer;
begin
  // VCL code can some times terminate string with
  // an null.  Ok for c drivers, but not those that
  // are Delphi.
  //
  Count := Pos(#0, Value);
  if Count > 0 then
  begin
    Temp := Value;
    SetLength(Temp, Count-1);
    inherited SetText(Temp);
  end else
    inherited SetText(Value);
end;

{ TDBXDynalinkReader }


constructor TDBXClientReader.Create(DBXContext: TDBXContext;
  ReaderHandle: Integer;
  DbxRow: TDBXRow;
  DbxReader: TDbxJSonStreamReader; DbxWriter: TDbxJSonStreamWriter;
  DbxRowBuffer: TDBXRowBuffer);
var
  Ordinal:            TInt32;
//  Length:             TInt32;
//  ColumnType:         TInt32;
//  ColumnSubType:      TInt32;
//  Precision:          TInt32;
//  Scale:              TInt32;
  Flags:              TInt32;
  DbxFlags:           TInt32;
  Column:             TDBXValueType;
  ColumnCount:        TInt32;
  Values:             TDBXValueArray;
  DataType:           Integer;
  SubType:            Integer;
//  Name:               WideString;

begin
  inherited Create(DBXContext, DbxRow, nil);
  FReaderHandle :=  ReaderHandle;
  FDbxReader    :=  DbxReader;
  FDbxWriter    :=  DbxWriter;
  FDbxRowBuffer :=  DbxRowBuffer;
  FPosition     :=  -1;

  ColumnCount := DbxReader.readInt;
  SetLength(Values, ColumnCount);


    for Ordinal := 0 to High(Values) do
    begin
      DbxReader.Next(TDbxTokens.ValueSeparatorToken);
      DbxReader.Next(TDbxTokens.ArrayStartToken);
      Column                := TDBXDriverHelp.CreateTDBXValueType(DBXContext);
      Column.Ordinal        := Ordinal;
      Column.Name           := DbxReader.ReadString;
      DbxReader.Next(TDbxTokens.ValueSeparatorToken);
      DataType              := DbxReader.ReadInt;
      Column.DataType := DataType;
      DbxReader.Next(TDbxTokens.ValueSeparatorToken);
      SubType        := DbxReader.ReadInt;
      Column.SubType := SubType;
      DbxReader.Next(TDbxTokens.ValueSeparatorToken);
      Column.Precision      := DbxReader.ReadInt;
      DbxReader.Next(TDbxTokens.ValueSeparatorToken);
      Column.Scale          := DbxReader.ReadInt;
      DbxReader.Next(TDbxTokens.ValueSeparatorToken);
      Column.Size           := DbxReader.ReadInt;
      DbxReader.Next(TDbxTokens.ValueSeparatorToken);
      Flags                 := DbxReader.ReadInt;
      DbxFlags              := TDBXValueTypeFlagsEx.ExtendedType;
      if (Flags and 1) <> 0 then
        DbxFlags := DbxFlags or TDBXValueTypeFlags.ReadOnly;
      if (Flags and 2) <> 0 then
        DbxFlags := DbxFlags or TDBXValueTypeFlags.Searchable;
      if (Flags and 8) <> 0 then
        DbxFlags := DbxFlags or TDBXValueTypeFlags.Nullable;
      if (Flags and $40) <> 0 then
        DbxFlags := DbxFlags or TDBXValueTypeFlags.AutoIncrement;
      Column.ValueTypeFlags := DbxFlags;

//      Column.Size           := DbxReader.ReadInt;

//      if DataType = TDBXDataTypes. then
      
      Values[Ordinal] := TDBXValue.CreateValue(FDBXContext, Column, FDbxRow, true);
      DbxReader.SkipToEndOfArray();
    end;

  SetValues(Values);

end;

procedure TDBXClientReader.DerivedClose;
begin
  if (FDbxWriter <> nil) and (FReaderHandle >= 0) then
  begin
    FDbxWriter.WriteReaderCloseObject(FReaderHandle);
  end;
  FreeAndNil(FByteReader);
  inherited;
end;

function TDBXClientReader.DerivedNext: Boolean;
begin
  if FPosition < 0 then
  begin

    FPosition := 0;
    Result := (FDbxRowBuffer.ReadSize > 0);

  end
  else if FDbxRowBuffer.NextRow then
  begin
    inc(FPosition);
    Result := true;
  end
  else
  begin
    if FReadLastBuffer then
      Result := false
    else
    begin
      FDbxWriter.WriteNextObject(FReaderHandle, FPosition);
      FDbxWriter.Flush;
      ReadData;
      Result := FDbxRowBuffer.NextRow;
      if Result then
        inc(FPosition);
    end;
  end;
end;

destructor TDBXClientReader.Destroy;
begin
  inherited;
end;

function TDBXClientReader.GetByteReader: TDBXByteReader;
begin
  if FByteReader = nil then
    FByteReader  := TDBXClientByteReader
                  .Create(FDBXContext, FReaderHandle, Self, FDbxReader, FDbxWriter, FDbxRowBuffer);
  Result := FByteReader;
end;

function TDBXClientReader.ReadData: Boolean;
var
  DataSize: Integer;
  ResultCode: Integer;
begin

  FDbxReader.Next(TDBXTokens.ObjectStartToken);
  FDbxReader.Next(TDBXTokens.StringStartToken);
  ResultCode := FDbxReader.ReadStringCode;
  if ResultCode = TDBXStringCodes.Data then
  begin
    FDbxReader.Next(TDBXTokens.NameSeparatorToken);
    FDbxReader.Next(TDBXTokens.ArrayStartToken);
    DataSize := FDbxReader.ReadInt;
    if DataSize > 0 then
      FReadLastBuffer := false
    else
    begin
      FReadLastBuffer := true;
      DataSize := -DataSize;
    end;
    if DataSize <> 0 then
    begin
      FDBXReader.Next(TDBXTokens.ValueSeparatorToken);
      FDBXReader.ReadDataBytes(FDbxRowBuffer.Buffer, 0, DataSize);
      Result := true;
    end
    else
    begin
      Result := false;
    end;
    FDBXRowBuffer.ReadSize := DataSize;
  end else if ResultCode = TDBXStringCodes.Error then
  begin
    FdbxReader.ReadErrorBody;
  end else
    Result := false;

    Result := false;
  FDbxReader.SkipToEndOfObject;

end;

{ TDBXDynalinkRow }

procedure TDBXClientRow.CheckParameter(DbxValue: TDBXValue);
var
  Ordinal:    Integer;
  Index:      Integer;
  Direction:  Integer;
begin
  Ordinal := DbxValue.ValueType.Ordinal;

  if Ordinal = 0 then
  begin
    FLastParameterOrdinal := 0;
    // Could have out or return values in the buffer, so set the off to 0.
    //
    FDbxClientCommand.FDbxParameterBuffer.Cancel;
  end
  else if Ordinal <> FLastParameterOrdinal then
  begin
    for Index := 0 to Ordinal-1 do
    begin
      Direction := FDbxClientCommand.Parameters[Index].ParameterDirection;
      if      (Direction <> TDBXParameterDirections.OutParameter)
          and (Direction <> TDBXParameterDirections.ReturnParameter) then
      begin
        break;
      end;
      SetNull(FDbxClientCommand.Parameters[Index].Value);
    end;
    // Try again.
    //
    if Ordinal <> FLastParameterOrdinal then
      raise TDBXError.Create(TDBXErrorCodes.ParameterNotSet, WideFormat(ParameterNotSet, [FLastParameterOrdinal]));
  end;

  inc(FLastParameterOrdinal);
end;

constructor TDBXClientRow.Create(DBXContext: TDBXContext;
  ReaderHandle: Integer;
  DbxClientCommand: TDBXClientCommand;
  DbxStreamReader: TDbxJSonStreamReader; DbxStreamWriter: TDbxJSonStreamWriter;
  DbxRowBuffer: TDBXRowBuffer);

begin
  inherited Create(DBXContext);
  FReaderHandle := ReaderHandle;
  FDbxClientCommand   := DbxClientCommand;
  FDbxStreamReader    := DbxStreamReader;
  FDbxStreamWriter    := DbxStreamWriter;
  FDbxRowBuffer := DbxRowBuffer;
end;



procedure TDBXClientRow.GetAnsiString(DbxValue: TDBXAnsiStringValue;
  var AnsiStringVar: TDBXAnsiStringBuilder; var IsNull: LongBool);
begin
  inherited;

end;

procedure TDBXClientRow.GetBcd(DbxValue: TDBXBcdValue; var Value: TBcd;
  var IsNull: LongBool);
var
  Value64: Int64;
  SignSpecialPlaces: Byte;

begin
  FDbxRowBuffer.GoToField(DbxValue.ValueType.Ordinal);
  if FDbxRowBuffer.Null then
  begin
    isNull := true;
  end else
  begin
    isNull := false;
    FDbxRowBuffer.ReadBigDecimalBuffer;
    if FDbxRowBuffer.BigDecimalFitsInInt64 then
    begin
      Value64 := FDbxRowBuffer.BigDecimalBufferAsInt64;
      Value   := StrToBcd(IntToStr(Value64));
      if FDbxRowBuffer.BigDecimalSignum < 0 then
        SignSpecialPlaces := $80
      else
        SignSpecialPlaces := $0;
      SignSpecialPlaces := SignSpecialPlaces + FDbxRowBuffer.BigDecimalScale;
      Value.SignSpecialPlaces := SignSpecialPlaces;
    end else // Temp, need big int div and mod.
      raise TDBXError.Create(TDBXErrorCodes.InvalidLength, 'BCD to big');
  end;
end;

procedure TDBXClientRow.GetBoolean(DbxValue: TDBXBooleanValue; var Value,
  IsNull: LongBool);
begin
  FDbxRowBuffer.GoToField(DbxValue.ValueType.Ordinal);
  if FDbxRowBuffer.Null then
  begin
    isNull := true;
  end else
  begin
    isNull := false;
    Value := FDbxRowBuffer.ReadBoolean;
  end;
end;

procedure TDBXClientRow.GetByteLength(DbxValue: TDBXByteArrayValue;
  var ByteLength: Int64; var IsNull: LongBool);
var
  ReaderValue:  Boolean;
begin
  ReaderValue := TDBXDriverHelpEx.IsReadOnlyValueType(DbxValue.ValueType);
  if ReaderValue then
  begin
    IsNull := FDbxRowBuffer.Null;
    if not IsNull then
    begin
      FDbxRowBuffer.GoToField(DbxValue.ValueType.Ordinal);
      ByteLength := FDbxRowBuffer.ReadReaderBlobSize;
    end;
  end;
end;

procedure TDBXClientRow.GetBytes(DbxValue: TDBXByteArrayValue; Offset: Int64;
  const Buffer: TBytes; BufferOffset, Length: Int64; var ReturnLength: Int64;
  var IsNull: LongBool);
var
  Stream: TStream;
begin
  GetStream(TDBXStreamValue(DbxValue), Stream, IsNull);
  if IsNull then
    ReturnLength := 0
  else
  begin
    try
{$IF DEFINED(CLR)}
      ReturnLength := TDBXClientExtendedStream(Stream).ReadBytes(Buffer, BufferOffset, Length)
{$ELSE}
      ReturnLength := Stream.Read(Buffer[0], Length)
{$IFEND}
    finally
      FreeAndNil(Stream);
    end;
  end;
end;

procedure TDBXClientRow.GetDate(DbxValue: TDBXDateValue; var Value: TDBXDate;
  var IsNull: LongBool);
var
  Int64Value: Int64;
  DateTime: TDateTime;
begin
  FDbxRowBuffer.GoToField(DbxValue.ValueType.Ordinal);
  if FDbxRowBuffer.Null then
  begin
    isNull := true;
  end else
  begin
    isNull := false;
    Int64Value := FDbxRowBuffer.ReadInt64;
    DateTime := EncodeDate(Int64Value shr 9, (Int64Value shr 5) and $f, Int64Value and $1F);
    Value := DateTimeToTimeStamp(DateTime).Date;
  end;
end;

procedure TDBXClientRow.GetDouble(DbxValue: TDBXDoubleValue;
  var Value: Double; var IsNull: LongBool);
begin
  FDbxRowBuffer.GoToField(DbxValue.ValueType.Ordinal);
  if FDbxRowBuffer.Null then
  begin
    isNull := true;
  end else
  begin
    isNull := false;
    if DbxValue.ValueType.SubType = SingleType then
      Value := FDbxRowBuffer.ReadSingle
    else
      Value := FDbxRowBuffer.ReadDouble;
  end;
end;

procedure TDBXClientRow.GetInt16(DbxValue: TDBXInt16Value;
  var Value: SmallInt; var IsNull: LongBool);
begin
  FDbxRowBuffer.GoToField(DbxValue.ValueType.Ordinal);
  if FDbxRowBuffer.Null then
  begin
    isNull := true;
  end else
  begin
    isNull := false;
    Value := FDbxRowBuffer.ReadInt16;
  end;
end;

procedure TDBXClientRow.GetInt32(DbxValue: TDBXInt32Value; var Value: TInt32;
  var IsNull: LongBool);
begin
  FDbxRowBuffer.GoToField(DbxValue.ValueType.Ordinal);
  if FDbxRowBuffer.Null then
  begin
    isNull := true;
  end else
  begin
    isNull := false;
    Value := FDbxRowBuffer.ReadInt32;
  end;
end;

procedure TDBXClientRow.GetInt64(DbxValue: TDBXInt64Value; var Value: Int64;
  var IsNull: LongBool);
begin
  FDbxRowBuffer.GoToField(DbxValue.ValueType.Ordinal);
  if FDbxRowBuffer.Null then
  begin
    isNull := true;
  end else
  begin
    isNull := false;
    Value := FDbxRowBuffer.ReadInt64;
  end;
end;

function TDBXClientRow.GetObjectTypeName(Ordinal: TInt32): WideString;
begin

end;

procedure TDBXClientRow.GetStream(DbxValue: TDBXStreamValue;
  var Stream: TStream; var IsNull: LongBool);
var
  ReaderValue:  Boolean;
  BytesStream:  TDBXClientBytesStream;
  BlobStream:   TDBXClientBlobStream;
begin
  ReaderValue := TDBXDriverHelpEx.IsReadOnlyValueType(DbxValue.ValueType);
  if ReaderValue then
  begin
    FDbxRowBuffer.GoToField(DbxValue.ValueType.Ordinal);
    if FDbxRowBuffer.BlobHeader then
    begin
      Assert(FDbxRowBuffer.BlobHeader);
      BlobStream := TDBXClientBlobStream.Create;
      BlobStream.FReader := FDbxRowBuffer.ReadBlobStreamReader;
      SetLength(BlobStream.FBuffer, FDbxStreamReader.ReadBufferSize);
      Stream := BlobStream;
    end else
    begin
      BytesStream := TDBXClientBytesStream.Create;
      BytesStream.FSize := FDbxRowBuffer.ReadReaderBlobSize;
      SetLength(BytesStream.FBuffer, BytesStream.FSize);
      FDbxRowBuffer.ReadBytes(BytesStream.FBuffer, 0, BytesStream.FSize);
      Stream := BytesStream;
    end;
  end;
end;

procedure TDBXClientRow.GetStream(DbxValue: TDBXWideStringValue;
  var Stream: TStream; var IsNull: LongBool);
var
  ReaderValue: Boolean;
  BytesStream: TDBXClientBytesStream;
begin
  ReaderValue := TDBXDriverHelpEx.IsReadOnlyValueType(DbxValue.ValueType);
  if ReaderValue then
  begin
    BytesStream := TDBXClientBytesStream.Create;
    BytesStream.FBuffer := FDbxRowBuffer.ReadStringBytes;
    BytesStream.FSize := FDbxRowBuffer.StringBytesLength;
    Stream := BytesStream;
//    if FDbxRowBuffer.BlobHeader then
//    begin
//      if FDBXLookAheadStreamReader = nil then
//        FDBXLookAheadStreamReader := TDBXLookAheadStreamReader.Create;
//      CreateBlobStream(DbxValue.ValueType.Ordinal, BlobStream);
//      try
//        FDBXLookAheadStreamReader.SetStream(Stream);
//        BytesStream.FBuffer := FDbxRowBuffer.ReadStringBytes(FDBXLookAheadStreamReader);
//        BytesStream.FSize := FDbxRowBuffer.StringBytesLength;
//      finally
//        BlobStream.Free;
//      end;
//    end else
//    begin
//      BytesStream := TDBXClientBytesStream.Create;
//      BytesStream.FBuffer := FDbxRowBuffer.ReadStringBytes;
//      BytesStream.FSize := FDbxRowBuffer.StringBytesLength;
//      Stream := BytesStream;
//    end;
  end;
end;

function TDBXClientRow.CreateCustomValue(ValueType: TDBXValueType): TDBXValue;
begin
  Result := nil;
  case ValueType.DataType of
    TDBXDataTypes.WideStringType,
    TDBXDataTypes.AnsiStringType:
      Result := TDBXClientWideCharsValue.Create(ValueType);
    TDBXDataTypes.BlobType:
      case ValueType.SubType of
        TDBXDataTypes.MemoSubType,
        TDBXDataTypes.WideMemoSubType:
          Result := TDBXClientWideCharsValue.Create(ValueType);
      end;
  end;
end;

destructor TDBXClientRow.Destroy;
begin
  FreeAndNil(FDBXLookAheadStreamReader);
  inherited;
end;

procedure TDBXClientRow.GetStreamBytes(DbxValue: TDBXStreamValue;
  const Buffer: TBytes; BufferOffset, Length, ReturnLength: Int64;
  var IsNull: LongBool);
begin
  inherited;
end;


procedure TDBXClientRow.GetStreamLength(DbxValue: TDBXStreamValue;
  StreamLength: Int64; var IsNull: LongBool);
begin
  inherited;

end;

procedure TDBXClientRow.GetTime(DbxValue: TDBXTimeValue; var Value: TDBXTime;
  var IsNull: LongBool);
var
  Int64Value: Int64;
  DateTime: TDateTime;
  Hours: Word;
  Minutes: Word;
  Seconds: Word;
  Milliseconds: Word;
begin
  FDbxRowBuffer.GoToField(DbxValue.ValueType.Ordinal);
  if FDbxRowBuffer.Null then
  begin
    isNull := true;
  end else
  begin
    isNull := false;
    Int64Value := FDbxRowBuffer.ReadInt64;
    //  FDbxRowBuffer.WriteInt64((Year shl 9) or (Month shl 5) or Day);
    Milliseconds  := Int64Value mod 1000;
    Int64Value    := Int64Value div 1000;
    Seconds       := Int64Value mod 60;
    Int64Value    := Int64Value div 60;
    Minutes       := Int64Value mod 60;
    Hours         := Int64Value div 60;
    DateTime := EncodeTime(Hours, Minutes, Seconds, Milliseconds);
    Value := DateTimeToTimeStamp(DateTime).Time;
  end;
end;

procedure TDBXClientRow.GetTimeStamp(DbxValue: TDBXTimeStampValue;
  var Value: TSQLTimeStamp; var IsNull: LongBool);
var
  Int64Value: Int64;
  TimeInt64: Int64;
  DateTime: TDateTime;
begin
  FDbxRowBuffer.GoToField(DbxValue.ValueType.Ordinal);
  if FDbxRowBuffer.Null then
  begin
    isNull := true;
  end else
  begin
    isNull := false;
    Int64Value := FDbxRowBuffer.ReadTimestamp;
    Int64Value      := (Int64Value + (Int64(UnixDateDelta) * MSecsPerDay));
    DateTime        := Int64Value div MSecsPerDay;
    Value           := DateTimeToSQLTimeStamp(DateTime);
    TimeInt64       := Int64Value mod MSecsPerDay;
//    Value.Fractions := TimeInt64 mod 1000;
    Value.Fractions    := FDbxRowBuffer.ReadTimestampNanos div (1000*1000);
    TimeInt64       := TimeInt64 div 1000;
    Value.Second    := TimeInt64 mod 60;
    TimeInt64       := TimeInt64 div 60;
    Value.Minute    := TimeInt64 mod 60;
    Value.Hour      := TimeInt64 div 60;
    InitTZInfo;
    Value := UTCToLocal(FTzInfo, Value);
  end;
end;

procedure TDBXClientRow.GetWideChars(DbxValue: TDBXWideStringValue;
  var WideChars: TDBXWideChars; var Count: Integer;  var IsNull: LongBool);
var
  MaxStringSize: Integer;
  StringLength: Integer;
begin
    FDbxRowBuffer.GoToField(DbxValue.ValueType.Ordinal);
  if FDbxRowBuffer.Null then
  begin
    isNull := true;
  end else
  begin
    isNull := false;
    StringLength := FDbxRowBuffer.EncodedStringLength;
    if DbxValue.ValueType.Size < 1 then
    begin
      MaxStringSize := StringLength + 1;
      if Length(WideChars) < MaxStringSize then
      begin
        SetLength(WideChars, MaxStringSize);
      end;
    end;
    Count := FDbxRowBuffer.ReadChars(WideChars, StringLength);
    if Count > StringLength then
    begin
      WideChars := FDbxRowBuffer.Decoder.DecodeBuf;
    end;

  end;

end;

procedure TDBXClientRow.InitTZInfo;
begin
  if not FTZInfoInitialized then
  begin
    FTZInfo := TTimeZone.GetTimeZone;
    FTZInfoInitialized := true;
  end;
end;

procedure TDBXClientRow.ProcessStringOverFlow(DbxValue: TDBXWideStringValue);
begin
  TDBXClientWideCharsValue(DbxValue).SetByteStreamReader(FDbxRowBuffer.OverflowStringBytes);
end;

procedure TDBXClientRow.SetBCD(DbxValue: TDBXBcdValue; var Value: TBcd);
begin
  CheckParameter(DbxValue);
  FDbxRowBuffer.WriteString(BcdToStr(Value));
end;

procedure TDBXClientRow.SetBoolean(DbxValue: TDBXBooleanValue;
  Value: Boolean);
begin
  CheckParameter(DbxValue);
  FDbxRowBuffer.WriteBoolean(Value);
end;

procedure TDBXClientRow.SetDate(DbxValue: TDBXDateValue; Value: TDBXDate);
var
  TimeStamp: TTimeStamp;
  DateTime: TDateTime;
  Month: Word;
  Day: Word;
  Year: Word;
begin
  CheckParameter(DbxValue);
  TimeStamp.Time := 0;
  TimeStamp.Date := Value;
  DateTime := TimeStampToDateTime(TimeStamp);
  DecodeDate(DateTime, Year, Month, Day);
  FDbxRowBuffer.WriteInt64((Year shl 9) or (Month shl 5) or Day);
end;

procedure TDBXClientRow.SetDouble(DbxValue: TDBXDoubleValue; Value: Double);
begin
  CheckParameter(DbxValue);
  if DbxValue.ValueType.SubType = SingleType then
    FDbxRowBuffer.WriteSingle(Value)
  else
    FDbxRowBuffer.WriteDouble(Value);
end;

procedure TDBXClientRow.SetDynamicBytes(DbxValue: TDBXValue; Offset: Int64;
  const Buffer: TBytes; BufferOffset, Count: Int64);
begin
  CheckParameter(DbxValue);
  inherited;

end;

procedure TDBXClientRow.SetInt16(DbxValue: TDBXInt16Value; Value: SmallInt);
begin
  CheckParameter(DbxValue);
  if DbxValue.ValueType.ParameterDirection = TDBXParameterDirections.OutParameter then
    FDbxRowBuffer.WriteNull
  else
    FDbxRowBuffer.WriteInt32(Value);
end;

procedure TDBXClientRow.SetInt32(DbxValue: TDBXInt32Value; Value: TInt32);
begin
  CheckParameter(DbxValue);
  FDbxRowBuffer.WriteInt32(Value);
end;

procedure TDBXClientRow.SetInt64(DbxValue: TDBXInt64Value; Value: Int64);
begin
  CheckParameter(DbxValue);
  FDbxRowBuffer.WriteInt64(Value);
end;

procedure TDBXClientRow.SetNull(DbxValue: TDBXValue);
begin
  CheckParameter(DbxValue);
  FDbxRowBuffer.WriteNull;
end;

procedure TDBXClientRow.SetStream(DbxValue: TDBXStreamValue; StreamReader: TDBXStreamReader);
begin
  CheckParameter(DbxValue);
  FDbxRowBuffer.WriteBytes(StreamReader);
end;


procedure TDBXClientRow.SetString(DbxValue: TDBXAnsiStringValue;
  const Value: String);
begin
  CheckParameter(DbxValue);
  inherited;

end;

procedure TDBXClientRow.SetTime(DbxValue: TDBXTimeValue; Value: TDBXTime);
var
  TimeStamp: TTimeStamp;
  DateTime: TDateTime;
  Hour: Word;
  Minutes: Word;
  Seconds: Word;
  Milliseconds: Word;
begin
  CheckParameter(DbxValue);
  TimeStamp.Time := Value;
  TimeStamp.Date := DateDelta;
  DateTime := TimeStampToDateTime(TimeStamp);
  DecodeTime(DateTime, Hour, Minutes, Seconds, Milliseconds);
  FDbxRowBuffer.WriteInt64(     (Hour * (60*60*1000))
                            +  (Minutes * (60*1000))
                            +  (Seconds * 1000)
                            +  (Milliseconds)
                          );
end;

procedure TDBXClientRow.SetTimestamp(DbxValue: TDBXTimeStampValue;
  var Value: TSQLTimeStamp);
var
  Int64Value: Int64;
  DateTime: TDateTime;
  Days: Integer;
begin
  CheckParameter(DbxValue);
  InitTZInfo;
  Value := LocalToUTC(FTzInfo, Value);
  DateTime := SQLTimeStampToDateTime(Value);
  Days := Trunc(DateTime);
  Dec(Days, UnixDateDelta);
  Int64Value := Int64(Days) * MSecsPerDay;
  Inc(Int64Value, Value.Hour * 60 * 60 * 1000);
  Inc(Int64Value, Value.Minute * 60 * 1000);
  Inc(Int64Value, Value.Second * 1000);
//  Inc(Int64Value, Value.Fractions);
  FDbxRowBuffer.WriteTimestamp(Int64Value, Value.Fractions*1000*1000);
end;

procedure TDBXClientRow.SetValueType(ValueType: TDBXValueType);
begin
  FDbxClientCommand.FParameterTypeChange := true;
end;

procedure TDBXClientRow.SetWideChars(DbxValue: TDBXWideStringValue;
  const Value: WideString);
begin
  CheckParameter(DbxValue);
  if not FDbxRowBuffer.WriteString(Value) then
  begin
    ProcessStringOverflow(DbxValue);
  end;
end;


function TDBXClientRow.UseExtendedTypes: Boolean;
begin
  Result := true;
end;

constructor TDBXClientByteReader.Create(DBXContext: TDBXContext;
  ReaderHandle: Integer;
  ClientReader: TDBXClientReader;
  DbxReader: TDbxJSonStreamReader;
  DbxWriter: TDbxJSonStreamWriter;
  DbxRowBuffer: TDBXRowBuffer);
begin
  inherited Create(DBXContext, ClientReader);
  FReaderHandle     := ReaderHandle;
  FDbxStreamReader  := DbxReader;
  FDbxStreamWriter  := DbxWriter;
  FDbxRowBuffer     := DbxRowBuffer;
  FDbxClientReader  := ClientReader;

end;

procedure TDBXClientByteReader.GetAnsiString(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
begin
  inherited;

end;

{
procedure TDBXClientByteReader.GetBoolean(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
begin
  FDbxRowBuffer.GoToField(Ordinal);
  if FDbxRowBuffer.Null then
    IsNull := true
  else
  begin
    IsNull := false;
    if FDbxRowBuffer.ReadBoolean then
    begin
      value[Offset]   := $FF;
      value[Offset+1] := $FF;
    end else
    begin
      value[Offset]   := 0;
      value[Offset+1] := 0;
    end;
  end;
end;
}


procedure TDBXClientByteReader.GetDouble(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
begin
  if FDbxClientReader[Ordinal].ValueType.SubType = SingleType then
    inherited
  else
  begin
    FDbxRowBuffer.GoToField(Ordinal);
    if FDbxRowBuffer.Null then
      IsNull := true
    else
    begin
      IsNull := false;
      TDBXPlatform.CopyInt64(FDbxRowBuffer.ReadDoubleAsInt64, Value, 0);
    end;
  end;
end;

procedure TDBXClientByteReader.GetInt16(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
var
  ValueObject: TDBXValue;
begin
  FDbxRowBuffer.GoToField(Ordinal);
  if FDbxRowBuffer.Null then
    IsNull := true
  else
  begin
    IsNull := false;
    ValueObject := FDbxClientReader[Ordinal];
    if ValueObject.ValueType.DataType = TDBXDataTypes.BooleanType then
    begin
      if FDbxRowBuffer.ReadBoolean then
      begin
        value[Offset]   := $FF;
        value[Offset+1] := $FF;
      end else
      begin
        value[Offset]   := 0;
        value[Offset+1] := 0;
      end;
    end else
    begin
      TDBXPlatform.CopyInt16(FDbxRowBuffer.ReadInt16, Value, 0);
    end;
  end;
end;

procedure TDBXClientByteReader.GetInt32(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
begin
  FDbxRowBuffer.GoToField(Ordinal);
  if FDbxRowBuffer.Null then
    IsNull := true
  else
  begin
    IsNull := false;
    TDBXPlatform.CopyInt32(FDbxRowBuffer.ReadInt32, Value, 0);
  end;
end;

procedure TDBXClientByteReader.GetInt64(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
begin
  FDbxRowBuffer.GoToField(Ordinal);
  if FDbxRowBuffer.Null then
    IsNull := true
  else
  begin
    IsNull := false;
    TDBXPlatform.CopyInt64(FDbxRowBuffer.ReadInt64, Value, 0);
  end;
end;

procedure TDBXClientByteReader.GetWideString(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
begin
  FDbxRowBuffer.GoToField(Ordinal);
  if FDbxRowBuffer.Null then
    IsNull := true
  else
  begin
    IsNull := false;
    FDbxRowBuffer.ReadStringBytes(Value, Offset);
  end;
end;

{ ClientTraceHandler }

constructor ClientTraceHandler.Create(DbxContext: TDBXContext);
begin
  inherited Create;
  FDbxContext := DbxContext;
end;

function ClientTraceHandler.IsTracing: Boolean;
begin
  Result := FDbxContext.IsTracing(TDBXTraceFlags.Vendor);
end;

procedure ClientTraceHandler.Trace(Message: WideString);
begin
  FDbxContext.Trace(TDBXTraceFlags.Vendor, Message);
end;

{ ClientErrorHandler }

constructor ClientErrorHandler.Create(DbxContext: TDBXContext);
begin
  inherited Create;
  FDbxContext := DbxContext;
end;

procedure ClientErrorHandler.HandleError(ErrorCode: Integer;
  ErrorMessage: WideString; Ex: Exception);
begin
  FDBXContext.Error(TDBXErrorCodes.InvalidOperation, ErrorMessage);
end;


{ TDBXClientTransaction }

constructor TDBXClientTransaction.Create(Connection: TDBXClientConnection;
  IsolationLevel: TDBXIsolation; TransactionHandle: Integer);
begin
  inherited Create(Connection);
  FTransactionHandle := TransactionHandle;
  FIsolationLevel := IsolationLevel;
end;

{ TDBXClientBlobStream }

{$IF DEFINED(CLR)}
procedure TDBXClientBlobStream.SetSize(NewSize: Int64);
begin
end;
function TDBXClientBlobStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  Result := 0;
end;
{$IFEND}
function TDBXClientBlobStream.GetSize: Int64;
begin
  Result := FReader.Size;
end;

{$IF DEFINED(CLR)}
function TDBXClientBlobStream.ReadBytes(const Buffer: TBytes; Offset, Count: Longint): Longint;
var
  TransferBytes: Integer;
  DestIndex: Integer;
  Available: Integer;
begin
  Result := 0;
  DestIndex := 0;
  while (Result < Count) and (not FReader.Eos) do
  begin
    Available := Length(FBuffer);
    if Count < Available then
      Available := Count;
    TransferBytes := FReader.Read(FBuffer, 0, Available);
    Assert(Length(FBuffer) >= (TransferBytes+FOffset));
    TDBXPlatform.CopyByteArray(FBuffer, FOffset, Buffer, DestIndex, TransferBytes);
    Inc(DestIndex, TransferBytes);
    Result := Result + TransferBytes;
  end;
end;

function TDBXClientBlobStream.Read(var Buffer: array of Byte; Offset, Count: Longint): Longint;
begin
  Result := readBytes(Buffer, Offset, Count);
end;

{$ELSE}
function TDBXClientBlobStream.Read(var Buffer; Count: Integer): Longint;
var
  TransferBytes: Integer;
  DestPointer: PByte;
  Available: Integer;
  Remaining: Integer;

begin
  Result := 0;
  DestPointer := Addr(Buffer);
  Remaining := Count;
  while (Result < Count) and (not FReader.Eos) do
  begin
    Available := Length(FBuffer);
    if Remaining < Available then
      Available := Remaining;
    TransferBytes := FReader.Read(FBuffer, 0, Available);
    dec(Remaining, TransferBytes);
    Assert(Length(FBuffer) >= (TransferBytes+FOffset));
    Move(FBuffer[FOffset], DestPointer^, TransferBytes);
    Inc(DestPointer, TransferBytes);
    Result := Result + TransferBytes;
  end;
end;
{$IFEND}

{$IF DEFINED(CLR)}
function TDBXClientBlobStream.Write(const Buffer: array of Byte; Offset, Count: Longint): Longint;
{$ELSE}
function TDBXClientBlobStream.Write(const Buffer; Count: Integer): Longint;
{$IFEND}
begin
  Result := 0;
end;

destructor TDBXClientBlobStream.Destroy;
begin
  FreeAndNil(FReader);
end;

{ TDBXClientBytesStream }

{$IF DEFINED(CLR)}
procedure TDBXClientBytesStream.SetSize(NewSize: Int64);
begin
end;
function TDBXClientBytesStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  Result := 0;
end;
{$IFEND}

function TDBXClientBytesStream.GetSize: Int64;
begin
  Result := FSize;
end;

{$IF DEFINED(CLR)}
function TDBXClientBytesStream.ReadBytes(const Buffer: TBytes; Offset, Count: Longint): Longint;
var
  TransferBytes: Integer;
begin
  TransferBytes := FSize - FOffset;
  if TransferBytes > Count then
    TransferBytes := Count;
  TDBXPlatform.CopyByteArray(FBuffer, FOffset, Buffer, 0, TransferBytes);
  inc(FOffset, TransferBytes);
  Result := TransferBytes;
end;

function TDBXClientBytesStream.Read(var Buffer: array of Byte; Offset, Count: Longint): Longint;
begin
  Result := ReadBytes(Buffer, Offset, Count);
end;

{$ELSE}
function TDBXClientBytesStream.Read(var Buffer; Count: Integer): Longint;
var
  TransferBytes: Integer;
begin
  TransferBytes := FSize - FOffset;
  if TransferBytes > Count then
    TransferBytes := Count;
  Move(FBuffer[FOffset], Buffer, TransferBytes);
  inc(FOffset, TransferBytes);
  Result := TransferBytes;
end;
{$IFEND}

{$IF DEFINED(CLR)}
function TDBXClientBytesStream.Write(const Buffer: array of Byte; Offset, Count: Longint): Longint;
{$ELSE}
function TDBXClientBytesStream.Write(const Buffer; Count: Integer): Longint;
{$IFEND}
begin
  Result := 0;
end;

{ TDBXClientParameterRow }

constructor TDBXClientParameterRow.Create(DBXContext: TDBXContext;
  ReaderHandle: Integer; DbxClientCommand: TDBXClientCommand;
  DbxStreamReader: TDbxJSonStreamReader; DbxStreamWriter: TDbxJSonStreamWriter;
  DbxRowBuffer: TDBXRowBuffer);
begin
  inherited;
end;

procedure TDBXClientParameterRow.GetAnsiString(DbxValue: TDBXAnsiStringValue;
  var AnsiStringVar: TDBXAnsiStringBuilder; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;

end;

procedure TDBXClientParameterRow.GetBcd(DbxValue: TDBXBcdValue; var Value: TBcd;
  var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetBoolean(DbxValue: TDBXBooleanValue;
  var Value, IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetByteLength(DbxValue: TDBXByteArrayValue;
  var ByteLength: Int64; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetBytes(DbxValue: TDBXByteArrayValue;
  Offset: Int64; const Buffer: TBytes; BufferOffset, Length: Int64;
  var ReturnLength: Int64; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetDate(DbxValue: TDBXDateValue;
  var Value: TDBXDate; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetDouble(DbxValue: TDBXDoubleValue;
  var Value: Double; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetInt16(DbxValue: TDBXInt16Value;
  var Value: SmallInt; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetInt32(DbxValue: TDBXInt32Value;
  var Value: TInt32; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetInt64(DbxValue: TDBXInt64Value;
  var Value: Int64; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetStream(DbxValue: TDBXStreamValue;
  var Stream: TStream; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetStream(DbxValue: TDBXWideStringValue;
  var Stream: TStream; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetStreamBytes(DbxValue: TDBXStreamValue;
  const Buffer: TBytes; BufferOffset, Length, ReturnLength: Int64;
  var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetStreamLength(DbxValue: TDBXStreamValue;
  StreamLength: Int64; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetTime(DbxValue: TDBXTimeValue;
  var Value: TDBXTime; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetTimeStamp(DbxValue: TDBXTimeStampValue;
  var Value: TSQLTimeStamp; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

procedure TDBXClientParameterRow.GetWideChars(DbxValue: TDBXWideStringValue;
  var WideChars: TDBXWideChars; var Count: Integer; var IsNull: LongBool);
begin
  if UseRowValue(DbxValue) then
    inherited;
end;

function TDBXClientParameterRow.UseRowValue(
  DbxValue: TDBXWritableValue): Boolean;
begin
  Result := False;
  if DbxValue.ValueType.ParameterDirection = TDBXParameterDirections.InParameter then
    Result := False
  else if DbxValue.ValueType.ParameterDirection = TDBXParameterDirections.OutParameter then
  begin
    Result := True;
  end else if DbxValue.ValueType.ParameterDirection = TDBXParameterDirections.InOutParameter then
  begin
    Result := True;
  end else if DbxValue.ValueType.ParameterDirection = TDBXParameterDirections.ReturnParameter then
  begin
    Result := True;
  end;
end;

{ TDBXClientWideCharsValue }

constructor TDBXClientWideCharsValue.Create(ValueType: TDBXValueType);
begin
  inherited
end;

destructor TDBXClientWideCharsValue.Destroy;
begin
  FreeAndNil(FDbxByteStreamReader);
  inherited;
end;
function TDBXClientWideCharsValue.GetAnsiString: String;
begin
  Result := GetWideString;
end;

function TDBXClientWideCharsValue.GetBytes(Offset: Int64; const Value: TBytes;
  BufferOffset, Length: Int64): Int64;
var
  Chars: TDBXWideChars;
  Count:  Integer;
  Index:  Integer;
  Ch:     WideChar;
begin
    Chars := WideChars;
    Count := WideCharsCount;
    Index := Offset;
    while Count > 0 do
    begin
      Ch := Chars[(Index div 2)];
      Value[Index] := Byte(Ch);
      inc(Index);
      Value[Index] := Byte(Integer(Ch) shr 8);
      inc(Index);
      dec(Count);
    end;
end;

function TDBXClientWideCharsValue.GetValueSize: Int64;
begin
  if IsNull then
    Result := -1
  else
    Result := (WideCharsCount)*2;
end;

procedure TDBXClientWideCharsValue.SetAnsiString(const Value: String);
begin
  SetWideString(Value);
end;

procedure TDBXClientWideCharsValue.SetByteStreamReader(const Bytes: TBytes);
begin
  FreeAndNil(FDbxByteStreamReader);
  FDbxByteStreamReader := TDBXByteStreamReader.Create(Bytes, 0, Length(Bytes));
end;


{ TDBXClientExtendedStream }

{$IF DEFINED(CLR)}
{$ELSE}
function TDBXClientExtendedStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  if (Offset <> 0) and (Origin <> soFromBeginning) then
    inherited Seek(Offset, Origin);
end;
{$IFEND}

function TDBXClientExtendedStream.Seek(const Offset: Int64;
  Origin: TSeekOrigin): Int64;
begin
  if (Offset <> 0) and (Origin <> soBeginning) then
    raise TDBXError.Create(TDBXErrorCodes.NotSupported, '');
end;

initialization
  DBXClientDriverLoaderClass := TDBXClientDriverLoader;
  TClassRegistry.GetClassRegistry
  .RegisterClass(SCLIENT_LOADER_NAME, DBXClientDriverLoaderClass);
finalization
  if DBXClientDriverLoaderClass <> nil then
    TClassRegistry.GetClassRegistry
    .UnregisterClass(SCLIENT_LOADER_NAME);

end.

