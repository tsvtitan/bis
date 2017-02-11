{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2006 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXTrace;
//interface
//implementation
//{$IF not DEFINED(ENABLEDBXTRACE)}

interface
uses  DBXCommon,
      DBXDelegate,
      DBXPlatform,
      Windows,
      FMTBcd,
      SqlTimSt,
      DBCommonTypes,
      Classes,
      SyncObjs,
      ClassRegistry
{$IF DEFINED(CLR)}
{$ELSE}
      , WideStrings
{$IFEND}
      , SysUtils;

const
{$IF DEFINED(CLR)}
  STRACE_DRIVER_LOADER_NAME = 'Borland.Data.'+'TDBXTraceDriverLoader'; // Do not localize
{$ELSE}
  STRACE_DRIVER_LOADER_NAME = 'TDBXTraceDriverLoader'; // Do not localize
{$IFEND}

resourcestring
  SINVALID_TRACE_FLAG       =
    '%s is an invalid setting for the %s property.'#13#10
    +'Use ''%s'' or a semicolon separated list of one or more of the following:'#13#10
    +'%s %s %s %s %s %s %s %s %s %s %s %s';


type
{$IF DEFINED(CLR)}
  TWideStringList = TStringList;
{$IFEND}

  TDBXTraceDriverLoaderClass = class of TDBXTraceDriverLoader;

TDBXTracePropertyNames = class
  const
      /// <remarks>Semicolon separate list of TDBXTraceFlagNames</remarks>
      TraceFlags = 'TraceFlags'; { do not localize }
      /// <remarks>Name of file for trace output, or 'con' for console output</remarks>
      TraceOut   = 'TraceOut';   { do not localize }
      /// <remarks>Set to true to activate framework level tracing </remarks>
      TraceFrameWork = 'TraceFramework'; { do not localize }
      /// <remarks>Set to true to activate driver level tracing </remarks>
      TraceDriver = 'TraceDriver'; { do not localize }
      /// <remarks>Set to a file to send trace ouptput to. </remarks>
      TraceFile = 'TraceFile'; { do not localize }

end;


TDBXTraceFlagNames = class
  const
      NONE        = 'NONE';         { do not localize }
      PREPARE     = 'PREPARE';      { do not localize }
      EXECUTE     = 'EXECUTE';      { do not localize }
      ERROR       = 'ERROR';        { do not localize }
      COMMAND     = 'COMMAND';      { do not localize }
      CONNECT     = 'CONNECT';      { do not localize }
      TRANSACT    = 'TRANSACT';     { do not localize }
      BLOB        = 'BLOB';         { do not localize }
      MISC        = 'MISC';         { do not localize }
      VENDOR      = 'VENDOR';       { do not localize }
      PARAMETER   = 'PARAMETER';    { do not localize }
      READER      = 'READER';       { do not localize }
      DRIVER_LOAD = 'DRIVER_LOAD';  { do not localize }
      METADATA    = 'METADATA';     { do not localize }
      DRIVER      = 'DRIVER';     { do not localize }

end;


TDBXTraceWriter = class
  private
    function    IsSingleton: Boolean; virtual; abstract;
    function    WriteTrace(TraceInfo: TDBXTraceInfo): CBRType; virtual; abstract;
end;


TDBXConsoleTraceWriter = class(TDBXTraceWriter)
  function    IsSingleton: Boolean; override;
  function    WriteTrace(TraceInfo: TDBXTraceInfo): CBRType; override;
end;

TDBXTraceFormatter = class
  private
    FCommentStart:  String;
    FCommentEnd:    String;
    FMaxLineWidth:  Integer;

    constructor Create(CommentStart, CommentEnd: String; MaxLineWidth: Integer);

    function Comment(CommentText: String): String; virtual; abstract;
    function CommentValue(ResultName: String; Value: String): String; virtual; abstract;
    function OpenComment(CommentText: String): String; virtual; abstract;
    function CloseComment: String; virtual; abstract;

    function GetProperty(ResultName, InstanceName, PropertyName: String): String; virtual; abstract;
    function SetProperty(InstanceName, PropertyName: String; Value: WideString): String; virtual; abstract;
    function CallProcedure(InstanceName, MethodName: String): String; virtual; abstract;
    function CallFunction(ResultName, InstanceName, MethodName: String): String; virtual; abstract;

    function CallOpenProcedure(InstanceName, MethodName: String): String; virtual; abstract;
    function CallOpenFunction(ResultName, InstanceName, MethodName: String): String; virtual; abstract;

    function ArrayProperty(InstanceName: String; Ordinal: Integer): String; virtual; abstract;
    function ParamString(Param: String; Separator: String): String; virtual; abstract;
    function ParamWideString(Param: WideString; Separator: String): String; virtual; abstract;
    function ParamBoolean(Param: Boolean; Separator: String): String; virtual; abstract;
    function ParamInt16(Param: SmallInt; Separator: String): String; virtual; abstract;
    function ParamInt32(Param: TInt32; Separator: String): String; virtual; abstract;
    function ParamInt64(Param: Int64; Separator: String): String; virtual; abstract;
    function ParamDouble(Param: Double; Separator: String): String; virtual; abstract;
    function ParamBcd(Param: TBcd; Separator: String): String; virtual; abstract;
    function ParamDate(Param: TDBXDate; Separator: String): String; virtual; abstract;
    function ParamTime(Param: TDBXTime; Separator: String): String; virtual; abstract;
    function ParamTimeStamp(Param: TSqlTimeStamp; Separator: String): String; virtual; abstract;
    function ParamBytes(Param: array of Byte; Offset: Int64; RequestedCount, Count: Int64; Separator: String): String; virtual; abstract;

    function ColumnTypeToStr(ColumnType:  TDBXType): String; virtual;
//    function ColumnSubTypeToStr(ColumnType:  TDBXType): String; virtual;
//    function ParameterDirectionToStr(Direction:  TDBXParameterDirection): String; virtual;

    function CloseProcedure(): String; virtual; abstract;
    function CloseFunction(): String; virtual; abstract;
    function QuoteString(Value: String): String; virtual; abstract;
end;

TDBXTracePascalFormatter = class(TDBXTraceFormatter)

  private
    function Comment(CommentText: String): String; override;
    function CommentValue(ResultName: String; Value: String): String; override;
    function OpenComment(CommentText: String): String; override;
    function CloseComment: String; override;

    function GetProperty(ResultName, InstanceName, PropertyName: String): String; override;
    function SetProperty(InstanceName, PropertyName: String; Value: WideString): String; override;
    function CallProcedure(InstanceName, MethodName: String): String; override;
    function CallFunction(ResultName, InstanceName, MethodName: String): String; override;

    function CallOpenProcedure(InstanceName, MethodName: String): String; override;
    function CallOpenFunction(ResultName, InstanceName, MethodName: String): String; override;

    function ArrayProperty(InstanceName: String; Ordinal: Integer): String; override;
    function ParamString(Param: String; Separator: String): String; override;
    function ParamWideString(Param: WideString; Separator: String): String; override;
    function ParamBoolean(Param: Boolean; Separator: String): String; override;
    function ParamInt16(Param: SmallInt; Separator: String): String; override;
    function ParamInt32(Param: TInt32; Separator: String): String; override;
    function ParamInt64(Param: Int64; Separator: String): String; override;
    function ParamDouble(Param: Double; Separator: String): String; override;
    function ParamBcd(Param: TBcd; Separator: String): String; override;
    function ParamDate(Param: TDBXDate; Separator: String): String; override;
    function ParamTime(Param: TDBXTime; Separator: String): String; override;
    function ParamTimeStamp(Param: TSqlTimeStamp; Separator: String): String; override;
    function ParamBytes(Param: array of Byte; Offset: Int64; RequestedCount, Count: Int64; Separator: String): String; override;

    function CloseProcedure(): String; override;
    function CloseFunction(): String; override;
    function QuoteString(Value: String): String; override;

end;

TDBXTraceDriverLoader = class(TDBXDriverLoader)
  public
    constructor Create; override;
    function Load(DriverDef: TDBXDriverDef): TDBXDriver; override;
end;

TDBXTraceOutput = class
  private
    FName:                WideString;
    FReferenceCount:      TInt32;
    FCriticalSection:     TCriticalSection;
    FFormatter:         TDBXTraceFormatter;
    procedure     Open; virtual; abstract;
    procedure     WriteTraceln(Line: WideString); virtual; abstract;
    function      LogTrace(TraceInfo: TDBXTraceInfo): CBRType;
    function      LogDriverTrace(TraceInfo: TDBXTraceInfo): CBRType;
    function      TraceFlagToString(TraceFlag: TDBXTraceFlag): String;
    procedure     AddReference;
    function      RemoveReference: TInt32;
    property      Name: WideString read FName write FName;
    property      Formatter: TDBXTraceFormatter read FFormatter write FFormatter;
  public
    constructor   Create;
    destructor Destroy; override;
end;

TDBXConsoleTraceOutput = class(TDBXTraceOutput)
  private
    procedure Open; override;
    procedure WriteTraceln(Line: WideString); override;
  public
    destructor Destroy; override;
end;

TDBXFileTraceOutput = class(TDBXTraceOutput)
  private
    FTraceFile:           TextFile;
    procedure Open; override;
    procedure WriteTraceln(Line: WideString); override;
  public
    destructor Destroy; override;
end;

TDBXTraceDriver = class(TDBXDriver)
    private
      FConnectionCount:   Int64;
      FTraceOutputList:   TWideStrings;
      function  GetTraceOutput(Name: WideString): TDBXTraceOutput;
      procedure AddTraceOutput(TraceOutput: TDBXTraceOutput);
      procedure ReleaseTraceOutput(TraceOutput: TDBXTraceOutput);
    protected
      procedure Close; override;

    public
      destructor Destroy; override;
      constructor Create;
      function CreateConnection(ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection; override;
      function GetDriverVersion: WideString; override;
end;

TDBXTraceConnection = class(TDBXDelegateConnection)
  private
    FFormatter:             TDBXTraceFormatter;
    FConnectionId:          Int64;
    FConnectionName:        String;
    FCommandCount:          Int64;
    FOriginalLogError:      TDBXErrorEvent;
    FTraceDriver:           TDBXTraceDriver;
    FTraceOutput:           TDBXTraceOutput;
    procedure Trace(TraceFlags: TDBXTraceFlag; Message: WideString);


  protected

    function  GetConnectionProperties: TDBXProperties; override;
    procedure SetConnectionProperties(const Value: TDBXProperties); override;
    function  GetTraceInfoEvent: TDBXTraceEvent; override;
    procedure SetTraceInfoEvent(TraceInfoEvent: TDBXTraceEvent); override;
    procedure LogError(DBXError: TDBXError);

    function  GetName: String;

  public
    constructor Create( ConnectionBuilder: TDBXConnectionBuilder;
                        TraceOutput: TDBXTraceOutput;
                        Driver: TDBXTraceDriver;
                        Connection: TDBXConnection;
                        ConnectionId: Int64);
    destructor Destroy; override;
    procedure Open(); override;

    function CreateCommand: TDBXCommand; override;
end;


//TDBXTraceParameterRow = class;

TDBXTraceCommand = class(TDBXDelegateCommand)
  private
    FFormatter:         TDBXTraceFormatter;
    FReaderCount:       Int64;
    FConnectionId:      Int64;
    FCommandId:         Int64;
    FCommandName:       String;
    FParametersName:    String;
    procedure Trace(TraceFlags: TDBXTraceFlag; Message: WideString);

  protected
    function  GetRowsAffected: Int64; override;
    function  GetText: WideString; override;
    procedure SetMaxBlobSize(const MaxBlobSize: Int64); override;
    procedure SetRowSetSize(const Value: Int64); override;
    procedure SetCommandType(const Value: WideString); override;
    procedure SetText(const Value: WideString); override;

    function  GetName: String;

  public

    constructor Create(Command: TDBXCommand; DBXContext: TDBXContext; Formatter: TDBXTraceFormatter; ConnectionId: Int64; CommandId: Int64);
    destructor  Destroy; override;

    function  CreateParameter: TDBXParameter; override;
    function  GetParameters: TDBXParameterList; override;
    procedure Prepare; override;
    function  ExecuteQuery: TDBXReader; override;
    procedure ExecuteUpdate; override;
    function  GetNextReader: TDBXReader; override;

  end;

  TDBXTraceParameterList = class(TDBXDelegateParameterList)
    strict protected
      FFormatter:         TDBXTraceFormatter;
      FParametersName:    String;
      FConnectionId:      Int64;
      FCommandId:         Int64;

      function GetName: String;

    public
      constructor Create( Command: TDBXCommand; Parameters: TDBXParameterList;
                          DBXContext: TDBXContext;
                          Formatter: TDBXTraceFormatter;  ParametersName: String; ConnectionId: Int64; CommandId: Int64);
      destructor  Destroy; override;
      procedure   AddParameter(Parameter: TDBXParameter); override;
      procedure   SetParameter(Ordinal: Integer; Parameter: TDBXParameter); override;
      procedure   InsertParameter(Ordinal: Integer; Parameter: TDBXParameter); override;
  end;


TDBXTraceWritableValue = class(TDBXDelegateWritableValue)
    private
      FFormatter:         TDBXTraceFormatter;
      FValueName:         WideString;
      FValueDisplayName:  WideString;
      FLastOrdinal:       TInt32;

      function GetValueDisplayName: WideString;

    private

    protected
//      constructor Create(DBXContext: TDBXContext; ValueType: TDBXValueType; Value: TDBXValue; Formatter: TDBXTraceFormatter; ValueName: WideString); overload;
      constructor Create(DBXContext: TDBXContext; ValueType: TDBXValueType; Value: TDBXWritableValue; Formatter: TDBXTraceFormatter; ValueName: WideString); overload;
    public

      function IsNull: Boolean; override;

      function GetValueSize: Int64; override;
      function GetAnsiString: String; override;
      function GetDate: TDBXDate; override;
      function GetBoolean: Boolean; override;
      function GetTime: TDBXTime; override;
      function GetWideString: WideString; override;
      function GetInt16: SmallInt; override;
      function GetInt32: TInt32; override;
      function GetInt64: Int64; override;
      function GetDouble: Double; override;
      function GetBytes(Offset: Int64; const Buffer: TBytes; BufferOffset, Length: Int64): Int64; override;
      function GetTimeStamp: TSQLTimeStamp; override;
      function GetBcd: TBcd; override;

      procedure SetNull; override;
      procedure SetTimeStamp(const Value: TSQLTimeStamp); override;
      procedure SetBcd(const Value: TBcd); override;
      procedure SetAnsiString(const Value: String); override;
      procedure SetBoolean(Value: Boolean); override;
      procedure SetDate(Value: TDBXDate); override;
      procedure SetTime(Value: TDBXTime); override;
      procedure SetWideString(const Value: WideString); override;
      procedure SetInt16(Value: SmallInt); override;
      procedure SetInt32(Value: TInt32); override;
      procedure SetInt64(Value: Int64); override;
      procedure SetDouble(Value: Double); override;
      procedure SetStaticBytes( Offset:       Int64;
                          const Buffer:   array of Byte;
                          BufferOffset: Int64;
                          Length:       Int64); override;
      procedure SetDynamicBytes( Offset:       Int64;
                          const Buffer:   TBytes;
                          BufferOffset: Int64;
                          Length:       Int64); override;

      destructor Destroy(); override;
end;

  TDBXTraceParameter = class(TDBXDelegateParameter)
    FTraceValue:    TDBXTraceWritableValue;
    FFormatter:     TDBXTraceFormatter;
    FParameterName: WideString;
    protected
      function  GetValue: TDBXWritableValue; override;

    public
      constructor Create(DbxContext: TDBXContext; Parameter: TDBXParameter; Formatter: TDBXTraceFormatter; ValueName: WideString);
      destructor Destroy(); override;
      function Clone: TObject; override;

  end;

TDBXTraceReader = class(TDBXDelegateReader)
  private
    FFormatter:         TDBXTraceFormatter;
    FNextCount:         Int64;
    FConnectionId:      Int64;
    FCommandId:         Int64;
    FReaderId:          Int64;
    FReaderName:        String;
    FClosed:            Boolean;

    procedure PrintColumns;

  public

      constructor Create( DBXContext: TDBXContext; Reader: TDBXReader;
                          Formatter: TDBXTraceFormatter;
                          ConnectionId: Int64;
                          CommandId: Int64;
                          ReaderId:  Int64);
      destructor Destroy; override;
      function Next: Boolean; override;
end;

implementation

var
  DBXTraceDriverLoaderClass: TDBXTraceDriverLoaderClass;

type

  TDBXAccessorCommand = class(TDBXCommand)


end;



{ TDBXTraceConnection }

constructor TDBXTraceConnection.Create(
  ConnectionBuilder: TDBXConnectionBuilder;
  TraceOutput: TDBXTraceOutput;
  Driver: TDBXTraceDriver;
  Connection: TDBXConnection;
  ConnectionId: Int64);
begin
  inherited Create(ConnectionBuilder, ConnectionBuilder.CreateDelegateeConnection);
  if ConnectionBuilder.ConnectionProperties.GetBoolean(TDBXTracePropertyNames.TraceDriver) then
    FConnection.OnTrace := TraceOutput.LogDriverTrace;
  FTraceDriver      := Driver;
  FTraceOutput      := TraceOutput;
  FFormatter        := TraceOutput.Formatter;
  FConnectionId     := ConnectionId;
  FConnectionName   := 'ConnectionC'+IntToStr(ConnectionId);
  FOriginalLogError := FConnection.OnErrorEvent;
  SetErrorEvent(LogError);
//  FConnection.OnErrorEvent := LogError;
//  FDBXContext  :=  ConnectionBuilder.ExtractDbxContext;
end;


function TDBXTraceConnection.CreateCommand: TDBXCommand;
var
  Command: TDBXTraceCommand;
begin
  inc(FCommandCount);
  Command := TDBXTraceCommand.Create(inherited CreateCommand, FDBXContext, FFormatter, FConnectionId, FCommandCount);
  if FDBXContext.IsTracing(TDBXTraceFlags.Command) then
    Trace(TDBXTraceFlags.Command,
          FFormatter.CallFunction(Command.GetName, GetName, 'CreateCommand'));
  Result := Command;
end;

destructor TDBXTraceConnection.Destroy;
begin
  if Assigned(FDBXContext) and (FDBXContext.IsTracing(TDBXTraceFlags.Connect)) then
    Trace(TDBXTraceFlags.Connect, FFormatter.CallOpenProcedure('', 'FreeAndNil')
          + GetName + FFormatter.CloseProcedure);
  if (FTraceDriver <> nil) then
    FTraceDriver.ReleaseTraceOutput(FTraceOutput);
  inherited;
end;



procedure TDBXTraceConnection.Open;
begin
  inherited;
  if FDBXContext.IsTracing(TDBXTraceFlags.Connect) then
    Trace(TDBXTraceFlags.Connect, FFormatter.CallProcedure(GetName, 'Open'));
end;


function TDBXTraceConnection.GetName: String;
begin
  Result := FConnectionName;
end;

function TDBXTraceConnection.GetConnectionProperties: TDBXProperties;
begin
  Result := inherited GetConnectionProperties;
  if FDBXContext.IsTracing(TDBXTraceFlags.Connect) then
    Trace(TDBXTraceFlags.Connect, FFormatter.CallProcedure(GetName, 'GetConnectionProperties'));
end;

procedure TDBXTraceConnection.SetConnectionProperties(
  const Value: TDBXProperties);
begin
  inherited;
  if FDBXContext.IsTracing(TDBXTraceFlags.Connect) then
    Trace(TDBXTraceFlags.Connect, FFormatter.CallProcedure(GetName, 'SetConnectionProperties'));
end;

function TDBXTraceConnection.GetTraceInfoEvent: TDBXTraceEvent;
begin
  Result := inherited GetTraceInfoEvent;
end;

procedure TDBXTraceConnection.LogError(DBXError: TDBXError);
var
  ErrorMessage: WideString;
begin
  if FDBXContext.IsTracing(TDBXTraceFlags.Error) then
  begin
    ErrorMessage := FFormatter.Comment( TDBXError.ErrorCodeToString(DBXError.ErrorCode)
                       + ' ' + DBXError.Message);
    FDBXContext.Trace(TDBXTraceFlags.Error, ErrorMessage);
    if Assigned(FOriginalLogError) then
      FOriginalLogError(DBXError);
  end;
end;

procedure TDBXTraceConnection.SetTraceInfoEvent(
  TraceInfoEvent: TDBXTraceEvent);
begin
  inherited;
  if Assigned(FDBXContext) then
    FDBXContext.OnTrace := TraceInfoEvent;
end;

procedure TDBXTraceConnection.Trace(TraceFlags: TDBXTraceFlag;
  Message: WideString);
begin
  FDBXContext.Trace(TraceFlags, Message);
end;


{ TDBXTraceCommand }

constructor TDBXTraceCommand.Create(Command: TDBXCommand; DBXContext: TDBXContext; Formatter: TDBXTraceFormatter; ConnectionId: Int64; CommandId: Int64);
begin
  inherited Create(DBXContext, Command);
  FFormatter      := Formatter;
  FConnectionId   := ConnectionId;
  FCommandId      := CommandId;
  FCommandName    := 'CommandC'+IntToStr(ConnectionId)+'_'+IntToStr(CommandId);
  FParametersName := FCommandName+'.Parameters';
end;



function TDBXTraceCommand.CreateParameter: TDBXParameter;
begin
  Result := TDBXTraceParameter.Create(FDBXContext, FCommand.CreateParameter, FFormatter, FParametersName);
end;

destructor TDBXTraceCommand.Destroy;
begin
  if FDBXContext.IsTracing(TDBXTraceFlags.Command) then
    Trace(TDBXTraceFlags.Command, FFormatter.CallOpenProcedure('', 'FreeAndNil')
          + GetName + FFormatter.CloseProcedure);
  inherited;
end;

function TDBXTraceCommand.ExecuteQuery: TDBXReader;
var
  ReaderName: String;
begin
  inc(FReaderCount);
  if FDBXContext.IsTracing(TDBXTraceFlags.Execute) then
  begin
    ReaderName := 'ReaderC'+IntToStr(FConnectionId)+'_'+IntToStr(FCommandId)+'_'+IntToStr(FReaderCount);
    Trace(TDBXTraceFlags.Command,
          FFormatter.CallFunction(ReaderName, GetName, 'ExecuteQuery'));
  end;
  Result := inherited ExecuteQuery;
  if (Result <> nil) and FDBXContext.IsTracing(TDBXTraceFlags.Reader) then
  begin
    Result := TDBXTraceReader.Create(FDBXContext, Result, FFormatter, FConnectionId, FCommandId, FreaderCount);
  end;
end;

procedure TDBXTraceCommand.ExecuteUpdate;
//var
//  ResultName: String;
begin
  if FDBXContext.IsTracing(TDBXTraceFlags.Execute) then
  begin
//    ResultName := 'RowsAffected'+IntToStr(FConnectionId)+'_'+IntToStr(FCommandId);
//    Trace(TDBXTraceFlags.EXECUTE, FFormatter.CallFunction(ResultName, GetName, 'ExecuteUpdate'));
    Trace(TDBXTraceFlags.Execute, FFormatter.CallProcedure(GetName, 'ExecuteUpdate'));
  end;
  inherited ExecuteUpdate;
//  if FDBXContext.IsTracing(TDBXTraceFlags.EXECUTE) then
//  begin
//    Trace(TDBXTraceFlags.EXECUTE, FFormatter.Comment(ResultName+' = '+IntToStr(Result)));
//  end;
end;


function TDBXTraceCommand.GetRowsAffected: Int64;
var
  ResultName: String;
begin
  if FDBXContext.IsTracing(TDBXTraceFlags.Execute) then
  begin
    ResultName := 'RowsAffectedC'+IntToStr(FConnectionId)+'_'+IntToStr(FCommandId);
    Trace(TDBXTraceFlags.Execute, FFormatter.GetProperty(ResultName, GetName, 'RowsAffected'));
  end;
  Result := inherited GetRowsAffected;
  if FDBXContext.IsTracing(TDBXTraceFlags.Execute) then
  begin
    Trace(TDBXTraceFlags.Execute, FFormatter.Comment(ResultName+' = '+IntToStr(Result)));
  end;
end;

function TDBXTraceCommand.GetText: WideString;
begin
  Result := inherited GetText;
end;

function TDBXTraceCommand.GetName: String;
begin
  Result := FCommandName;
end;

function TDBXTraceCommand.GetNextReader: TDBXReader;
begin
  Result := inherited GetNextReader;
end;

function TDBXTraceCommand.GetParameters: TDBXParameterList;
begin
  if FParameters = nil then
    FParameters := TDBXTraceParameterList.Create(Self, FCommand.Parameters, FDBXContext, FFormatter, FCommandName, FConnectionId, FCommandId);
  Result := FParameters;
end;

procedure TDBXTraceCommand.Prepare;
begin
  if FDBXContext.IsTracing(TDBXTraceFlags.Prepare) then
    Trace(TDBXTraceFlags.Prepare, FFormatter.CallProcedure(GetName, 'Prepare'));
  inherited;
end;


procedure TDBXTraceCommand.SetMaxBlobSize(const MaxBlobSize: Int64);
begin
  if FDBXContext.IsTracing(TDBXTraceFlags.Command) then
    Trace(TDBXTraceFlags.Command,
      FFormatter.SetProperty(GetName, 'MaxBlobsize', FFormatter.ParamInt64(MaxBlobSize, '')));
  inherited;
end;

procedure TDBXTraceCommand.SetRowSetSize(const Value: Int64);
begin
  if FDBXContext.IsTracing(TDBXTraceFlags.Command) then
    Trace(TDBXTraceFlags.Command,
      FFormatter.SetProperty(GetName, 'RowSetSize', FFormatter.ParamInt64(Value, '')));
  inherited;
end;

procedure TDBXTraceCommand.SetCommandType(const Value: WideString);
begin
  if FDBXContext.IsTracing(TDBXTraceFlags.Command) then
    Trace(TDBXTraceFlags.Command,
      FFormatter.SetProperty(GetName, 'CommandType', FFormatter.QuoteString(Value)));
  inherited;
end;

procedure TDBXTraceCommand.SetText(const Value: WideString);
begin
  if FDBXContext.IsTracing(TDBXTraceFlags.Command) then
    Trace(TDBXTraceFlags.Command,
          FFormatter.SetProperty(GetName, 'Text', FFormatter.QuoteString(Value)));
  inherited;
end;

procedure TDBXTraceCommand.Trace(TraceFlags: TDBXTraceFlag;
  Message: WideString);
begin
  FDBXContext.Trace(TraceFlags, Message);
end;

{ TDBXTraceDriverLoader }

constructor TDBXTraceDriverLoader.Create;
begin
  inherited;
end;

function TDBXTraceDriverLoader.Load(DriverDef: TDBXDriverDef): TDBXDriver;
begin
  Result := nil;
  if DriverDef.FDriverProperties[TDBXPropertyNames.DriverName] = 'DBXTrace' then
  begin
    Result := TDBXTraceDriver.Create;
  end;
end;

{ TDBXTraceDriver }

procedure TDBXTraceDriver.AddTraceOutput(TraceOutput: TDBXTraceOutput);
begin
  FTraceOutputList.AddObject(TraceOutput.Name, TraceOutput);
end;

procedure TDBXTraceDriver.Close;
begin
  inherited;

end;

constructor TDBXTraceDriver.Create;
begin
  inherited Create;
  FTraceOutputList := TWideStringList.Create;
end;

function TDBXTraceDriver.CreateConnection(ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection;
var
  Connection:         TDBXTraceConnection;
  DBXContext:         TDBXContext;
  Properties:         TDBXProperties;
  TraceFlagList:      TStringList;
  TraceFlagsProperty: String;
  TraceFlagsString:   String;
  Index:              Integer;
  TraceFlags:         TDBXTraceFlag;
  TraceFileName:      WideString;
  NeedsOnTraceEvent:  Boolean;
  TraceOutput:        TDBXTraceOutput;
  Complete:           Boolean;
  ConsoleFileName:    WideString;
begin
  DBXContext          := ConnectionBuilder.DBXContext;
  Properties          := ConnectionBuilder.ConnectionProperties;
  TraceFlagsProperty  := Properties.GetRequiredValue(TDBXTracePropertyNames.TraceFlags);
  TraceFlags := 0;
  if TraceFlagsProperty <> TDBXTraceFlagNames.NONE then
  begin
    TraceFlagList := TStringList.Create;
      try
      TraceFlagList.Delimiter := ';';
      TraceFlagList.DelimitedText := TraceFlagsProperty;
      for Index := 0 to TraceFlagList.Count - 1 do
      begin
        TraceFlagsString := TraceFlagList[Index];
        if TraceFlagsString = TDBXTraceFlagNames.PREPARE then
            TraceFlags := TraceFlags or TDBXTraceFlags.Prepare
        else if TraceFlagsString = TDBXTraceFlagNames.EXECUTE then
            TraceFlags := TraceFlags or TDBXTraceFlags.Execute
        else if TraceFlagsString = TDBXTraceFlagNames.ERROR then
            TraceFlags := TraceFlags or TDBXTraceFlags.Error
        else if TraceFlagsString = TDBXTraceFlagNames.COMMAND then
            TraceFlags := TraceFlags or TDBXTraceFlags.Command
        else if TraceFlagsString = TDBXTraceFlagNames.CONNECT then
            TraceFlags := TraceFlags or TDBXTraceFlags.Connect
        else if TraceFlagsString = TDBXTraceFlagNames.TRANSACT then
            TraceFlags := TraceFlags or TDBXTraceFlags.Transact
        else if TraceFlagsString = TDBXTraceFlagNames.BLOB then
            TraceFlags := TraceFlags or TDBXTraceFlags.Blob
        else if TraceFlagsString = TDBXTraceFlagNames.MISC then
            TraceFlags := TraceFlags or TDBXTraceFlags.Misc
        else if TraceFlagsString = TDBXTraceFlagNames.VENDOR then
            TraceFlags := TraceFlags or TDBXTraceFlags.Vendor
        else if TraceFlagsString = TDBXTraceFlagNames.PARAMETER then
            TraceFlags := TraceFlags or TDBXTraceFlags.Parameter
        else if TraceFlagsString = TDBXTraceFlagNames.READER then
            TraceFlags := TraceFlags or TDBXTraceFlags.Reader
        else if TraceFlagsString = TDBXTraceFlagNames.DRIVER_LOAD then
            TraceFlags := TraceFlags or TDBXTraceFlags.DriverLoad
        else if TraceFlagsString = TDBXTraceFlagNames.METADATA then
            TraceFlags := TraceFlags or TDBXTraceFlags.MetaData
        else
          DBXContext.Error(TDBXErrorCodes.InvalidParameter,
          WideFormat(SINVALID_TRACE_FLAG,
          [ TraceFlagsString, TDBXTracePropertyNames.TraceFlags,
            TDBXTraceFlagNames.NONE,
            TDBXTraceFlagNames.PARAMETER,
            TDBXTraceFlagNames.EXECUTE,
            TDBXTraceFlagNames.ERROR,
            TDBXTraceFlagNames.COMMAND,
            TDBXTraceFlagNames.CONNECT,
            TDBXTraceFlagNames.TRANSACT,
            TDBXTraceFlagNames.BLOB,
            TDBXTraceFlagNames.MISC,
            TDBXTraceFlagNames.VENDOR,
            TDBXTraceFlagNames.READER,
            TDBXTraceFlagNames.DRIVER_LOAD,
            TDBXTraceFlagNames.METADATA
            ]));
      end;
    finally
      FreeAndNil(TraceFlagList);
    end;
  end;



  ConsoleFileName := ':con'; // Invalid file name.
  TraceFileName := Properties[TDBXTracePropertyNames.TraceFile];
  if TraceFileName = '' then
    TraceFileName := ConsoleFileName;
  TraceOutput := GetTraceOutput(TraceFileName);
  if TraceOutput = nil then
  begin
    if TraceFileName = ConsoleFileName then
      TraceOutput := TDBXConsoleTraceOutput.Create
    else
      TraceOutput := TDBXFileTraceOutput.Create;
    Complete := false;
    try
      TraceOutput.Name := TraceFileName;
      TraceOutput.Open;
      TraceOutput.AddReference;
      Complete := true;
    finally
      if not Complete then
        FreeAndNil(TraceOutput);
    end;
    AddTraceOutput(TraceOutput);
  end
  else
    TraceOutput.AddReference;


  DBXContext.TraceFlags := DBXContext.TraceFlags or TraceFlags;
  if Assigned(DBXContext.OnTrace) then
    NeedsOnTraceEvent := false
  else
  begin
    DBXContext.OnTrace := TraceOutput.LogTrace;
    NeedsOnTraceEvent := true;
  end;
  Complete := false;
  try
    inc(FConnectionCount);
    Connection := TDBXTraceConnection.Create(ConnectionBuilder, TraceOutput, Self, nil, FConnectionCount);
    Result := Connection;
    Complete := true;
  finally
    if not Complete then
      ReleaseTraceOutput(TraceOutput);
    if NeedsOnTraceEvent then
      DBXContext.OnTrace := nil;
  end;
end;

//function TDBXTraceDriver.CreateValue(DBXContext: TDBXContext;
//  Column: TDBXValueType): TDBXValue;
//begin
//  Assert(false, 'Should not get here');
//  Result := nil;
//end;

destructor TDBXTraceDriver.Destroy;
var
  Index: Integer;
begin
  for Index := 0 to FTraceOutputList.Count - 1 do
    FTraceOutputList.Objects[Index].Free;
  FreeAndNil(FTraceOutputList);
  inherited;
end;

function TDBXTraceDriver.GetDriverVersion: WideString;
begin
  Result := 'DBXTraceDriver 1.0'; {Do not localize}
end;


function TDBXTraceDriver.GetTraceOutput(Name: WideString): TDBXTraceOutput;
var
  Index: Integer;
begin
  Index := FTraceOutputList.IndexOf(Name);
  if Index < 0 then
    Result := nil
  else  
    Result := TDBXTraceOutput(FTraceOutputList.Objects[Index]);
end;

//procedure TDBXTraceDriver.LogError(DBXError: TDBXError);
//var
//  TraceInfo: TDBXTraceInfo;
//begin
//  TraceInfo.WriteNewLine := False;
//  TraceInfo.TraceFlag := TDBXTraceFlags.Error;
//  TraceInfo.Message := FFormatter.Comment( TDBXError.ErrorCodeToString(DBXError.ErrorCode)
//                       + ' ' + DBXError.Message);
//  LogTrace(TraceInfo);
//end;


procedure TDBXTraceDriver.ReleaseTraceOutput(TraceOutput: TDBXTraceOutput);
begin
  if TraceOutput = GetTraceOutput(TraceOutput.Name) then
  begin
    if TraceOutput.RemoveReference < 1 then
    begin
      FTraceOutputList.Delete(FTraceOutputList.IndexOf(TraceOutput.Name));
      TraceOutput.Free;
    end;
  end;
end;

{ TDBXTraceFormatter }
{
function TDBXTraceFormatter.ColumnSubTypeToStr(ColumnType: TDBXType): String;
begin
  with TDBXDataTypes do
    case ColumnType of
      MoneySubType         : Result := 'TDBXTypes.SUB_TYPE_MONEY';
      MemoSubType          : Result := 'TDBXTypes.SUB_TYPE_MEMO';
      BinarySubType        : Result := 'TDBXTypes.SUB_TYPE_BINARY';
//      SUB_TYPE_FMTMEMO       : Result := 'TDBXTypes.SUB_TYPE_FMTMEMO';
//      SUB_TYPE_OLEOBJ        : Result := 'TDBXTypes.SUB_TYPE_OLEOBJ';
//      SUB_TYPE_GRAPHIC       : Result := 'TDBXTypes.SUB_TYPE_GRAPHIC';
//      SUB_TYPE_DBSOLEOBJ     : Result := 'TDBXTypes.SUB_TYPE_DBSOLEOBJ';
//      SUB_TYPE_TYPEDBINARY   : Result := 'TDBXTypes.SUB_TYPE_TYPEDBINARY';
//      SUB_TYPE_ACCOLEOBJ     : Result := 'TDBXTypes.SUB_TYPE_ACCOLEOBJ';
      WideMemoSubType      : Result := 'TDBXTypes.SUB_TYPE_WIDEMEMO';
      HMemoSubType         : Result := 'TDBXTypes.SUB_TYPE_HMEMO';
      HBinarySubType       : Result := 'TDBXTypes.SUB_TYPE_HBINARY';
      BFileSubType         : Result := 'TDBXTypes.SUB_TYPE_BFILE';
//      SUB_TYPE_PASSWORD      : Result := 'TDBXTypes.SUB_TYPE_PASSWORD';
      FixedSubType         : Result := 'TDBXTypes.SUB_TYPE_FIXED';
      AutoIncSubType       : Result := 'TDBXTypes.SUB_TYPE_AUTOINC';
      AdtNestedTableSubType: Result := 'TDBXTypes.SUB_TYPE_ADTNestedTable';
      AdtDateSubType       : Result := 'TDBXTypes.SUB_TYPE_ADTDATE';
      OracleTimeStampSubType  : Result := 'TDBXTypes.SUB_TYPE_ORATIMESTAMP';
      OracleIntervalSubType   : Result := 'TDBXTypes.SUB_TYPE_ORAINTERVAL';
      else
        Result := 'UNKNOWN('+IntToStr(Columntype)+')';
    end;

end;
}
function TDBXTraceFormatter.ColumnTypeToStr(ColumnType: TDBXType): String;
begin
  Result := TDBXValueTypeEx.DataTypeName(ColumnType);
end;

constructor TDBXTraceFormatter.Create(CommentStart, CommentEnd: String;
  MaxLineWidth: Integer);
begin
  inherited Create;
  FCommentStart := CommentStart;
  FCommentEnd   := CommentEnd;
  FMaxLineWidth := MaxLineWidth;
end;


//function TDBXTraceFormatter.ParameterDirectionToStr(
//  Direction: TDBXParameterDirection): String;
//begin
//  with TDBXDataTypes do
//    case Direction of
//      TDBXParameterDirections.Unknown:   Result := '{TDBXParameterDirections.}UNKNOWN';
//      TDBXParameterDirections.InParameter:   Result := '{TDBXParameterDirections.}IN_ONLY';
//      TDBXParameterDirections.OutParameter:  Result := '{TDBXParameterDirections.}OUT_ONLY';
//      TDBXParameterDirections.InOutParameter:    Result := '{TDBXParameterDirections.}IN_OUT';
//      TDBXParameterDirections.ReturnParameter:    Result := '{TDBXParameterDirections.}RETURN';
//    else
//      Result := 'UNKNOWN Parameter Direction('+IntToStr(Integer(Direction))+')';
//    end;
//end;

{ TDBXTracePascalFormatter }

function TDBXTracePascalFormatter.ArrayProperty(InstanceName: String;
  Ordinal: Integer): String;
begin
  Result := InstanceName + '[' + IntToStr(Ordinal) + ']';
end;

function TDBXTracePascalFormatter.CallFunction(ResultName, InstanceName,
  MethodName: String): String;
begin
  if InstanceName = '' then
    Result := ResultName + ' := ' + MethodName + ';'
  else
    Result := ResultName + ' := ' + InstanceName + '.' + MethodName + ';';
end;

function TDBXTracePascalFormatter.CallOpenFunction(ResultName, InstanceName,
  MethodName: String): String;
begin
  if InstanceName = '' then
    Result := ResultName + ' := ' + MethodName + '('
  else
    Result := ResultName + ' := ' + InstanceName + '.' + MethodName + '(';
end;

function TDBXTracePascalFormatter.CallOpenProcedure(InstanceName,
  MethodName: String): String;
begin
  if InstanceName = '' then
    Result := MethodName + '('
  else
    Result := InstanceName + '.' + MethodName + '(';
end;

function TDBXTracePascalFormatter.CallProcedure(InstanceName,
  MethodName: String): String;
begin
  if InstanceName = '' then
    Result := MethodName + ';'
  else
    Result := InstanceName + '.' + MethodName + ';';
end;

function TDBXTracePascalFormatter.CloseComment: String;
begin
  Result := FCommentEnd;
end;

function TDBXTracePascalFormatter.CloseFunction: String;
begin
  Result := ');';
end;

function TDBXTracePascalFormatter.CloseProcedure: String;
begin
  Result := ');';
end;

function TDBXTracePascalFormatter.Comment(CommentText: String): String;
begin
  Result := FCommentStart + CommentText + FCommentEnd;
end;

function TDBXTracePascalFormatter.CommentValue(ResultName,
  Value: String): String;
begin
  Result := FCommentStart + ResultName + ' = ' + Value + FCommentEnd;
end;

function TDBXTracePascalFormatter.GetProperty(ResultName, InstanceName,
  PropertyName: String): String;
begin
  Result := ResultName + ' := ' + InstanceName + '.' + PropertyName;
end;

function TDBXTracePascalFormatter.OpenComment(CommentText: String): String;
begin
  Result := FCommentEnd;
end;


function TDBXTracePascalFormatter.ParamBcd(Param: TBcd;
  Separator: String): String;
begin
  // When setting output params, a nil'd out value is sent
  // that cannot be converted to a string.
  //
  if Param.Precision = 0 then
    Result := 'StrToBcd('''+'0'+''')' + Separator
  else
    Result := 'StrToBcd('''+BcdToStr(Param)+''')' + Separator;
end;

function TDBXTracePascalFormatter.ParamBoolean(Param: Boolean;
  Separator: String): String;
begin
  Result := BoolToStr(Param, true) + Separator;
end;
const
  Hex = '0123456789ABCDEF';
function TDBXTracePascalFormatter.ParamBytes(Param: array of Byte; Offset,
  RequestedCount, Count: Int64; Separator: String): String;
var
  Buffer: array of char;
  Index: Integer;
  BufIndex: Integer;
  Ch: Byte;
  HexIndex: Integer;
begin
  if Count < 1 then  
    SetLength(Buffer, 4+2)
  else
    SetLength(Buffer, Count*4+2);
  Buffer[1] := '[';
  BufIndex := 2;
  for Index := Offset to High(Param) do
  begin
    Ch := Param[Index];
    Buffer[BufIndex] := '$';
    inc(BufIndex);
    HexIndex := Ch shr 4;
    if HexIndex = 0 then
      Buffer[BufIndex] := Hex[(Ch shr 4)+1];
    Buffer[BufIndex] := Hex[(Ch shr 4)+1];
    inc(BufIndex);
    Buffer[BufIndex] := Hex[(Ch and $F)+1];
    inc(BufIndex);
    Buffer[BufIndex] := ',';
    inc(BufIndex);
  end;
  Buffer[BufIndex-1] := ']';

  Result := String(Buffer) + Separator;
end;
{function TDBXTracePascalFormatter.ParamBytes(Param: array of Byte; Offset,
  RequestedCount, Count: Int64; Separator: String): String;
var
  Buffer: String;
  Index: Integer;
  BufIndex: Integer;
  Ch: Byte;
begin
  SetLength(Buffer, Count*4+1);
  Buffer[1] := '[';
  BufIndex := 2;
  for Index := Offset to High(Param) do
  begin
    Ch := Param[Index];
    Buffer[BufIndex] := '$';
    inc(BufIndex);
    Buffer[BufIndex] := Hex[(Ch shr 4)];
    inc(BufIndex);
    Buffer[BufIndex] := Hex[(Ch and $F)];
    inc(BufIndex);
    Buffer[BufIndex] := ',';
    inc(BufIndex);
  end;
  Buffer[BufIndex-1] := ']';

  Result := String(Buffer) + Separator;
end;
}
function TDBXTracePascalFormatter.ParamDate(Param: TDBXDate;
  Separator: String): String;
var
  TimeStamp: TTimeStamp;
begin
  TimeStamp.Date := Param;
  TimeStamp.Time := 0;
  Result := IntToStr(Param) + FCommentStart+DateToStr(TimeStampToDateTime(TimeStamp))+FCommentEnd + Separator;
end;

function TDBXTracePascalFormatter.ParamDouble(Param: Double;
  Separator: String): String;
begin
  Result := FloatToStr(Param) + Separator;
end;

function TDBXTracePascalFormatter.ParamInt16(Param: SmallInt;
  Separator: String): String;
begin
  Result := IntToStr(Param) + Separator;
end;

function TDBXTracePascalFormatter.ParamInt32(Param: TInt32;
  Separator: String): String;
begin
  Result := IntToStr(Param) + Separator;
end;

function TDBXTracePascalFormatter.ParamInt64(Param: Int64;
  Separator: String): String;
begin
  Result := IntToStr(Param) + Separator;
end;

function TDBXTracePascalFormatter.ParamString(Param, Separator: String): String;
begin
  Result := QuoteString(Param) + Separator;
end;
function TDBXTracePascalFormatter.ParamTime(Param: TDBXTime;
  Separator: String): String;
var
  TimeStamp: TTimeStamp;
begin
  TimeStamp.Date := DateDelta;
  TimeStamp.Time := Param;
  Result := IntToStr(Param) + FCommentStart+TimeToStr(TimeStampToDateTime(TimeStamp))+FCommentEnd + Separator;
end;

function TDBXTracePascalFormatter.ParamTimeStamp(Param: TSqlTimeStamp;
  Separator: String): String;
begin
  Result := 'StrToSQLTimeSTamp(' + QuoteString(SQLTimeStampToStr('', Param)) + ')' + Separator;
end;

function TDBXTracePascalFormatter.ParamWideString(Param: WideString;
  Separator: String): String;
begin
  Result := QuoteString(Param) + Separator;
end;

function TDBXTracePascalFormatter.QuoteString(Value: String): String;
var
  StringList: TStringList;
  Index: Integer;
  StartIndex: Integer;
  Ch: Char;
  StringEnd : Integer;
begin
  StringList := TStringList.Create;
  try
    StringList.LineBreak := '';
    StartIndex := 1;
    StringList.Add('''');
    StringEnd := Length(Value);
    Index := 1;
    while Index <= StringEnd do
    begin
      Ch := Value[Index];
      if Ch < ' ' then
      begin
        StringList.Add(Copy(Value, StartIndex, Index-StartIndex));
        StartIndex := Index + 1;
        StringList.Add('''#'+IntToStr(Integer(Ch))+'''');
      end;
      if Ch = #10 then
      begin
        if (Index+1) < StringEnd then
          StringList.Add(''''#13#10'+''');
      end;
      if (Index-StartIndex) > 100 then
      begin
        StringList.Add(Copy(Value, StartIndex, Index-StartIndex));
        StringList.Add('''+''');
        StartIndex := Index;
      end;
      inc(Index);
    end;
    StringList.Add(Copy(Value, StartIndex, Index-StartIndex));
    StringList.Add('''');
    Result := StringList.Text;
  finally
    FreeAndNil(StringList);
  end;
end;

function TDBXTracePascalFormatter.SetProperty(InstanceName,
  PropertyName: String; Value: WideString): String;
begin
  Result := InstanceName + '.' + PropertyName + ' := ' + Value + ';';
end;

{ TDBXTraceParameters }

//function TDBXTraceParameters.CreateAndAddParameter: TDBXParameter;
//begin
//  if FDBXContext.IsTracing(TDBXTraceFlags.Parameter) then
//    Trace(TDBXTraceFlags.Parameter,
//          FFormatter.CallProcedure(GetName, 'AddParameter'));
//  Result := inherited CreateAndAddParameter;
//end;

//procedure TDBXTraceParameterList.SetCapacity(Count: TInt32);
//begin
//  if FDBXContext.IsTracing(TDBXTraceFlags.Parameter) then
//    Trace(TDBXTraceFlags.Parameter,
//          FFormatter.CallOpenProcedure(GetName, 'AddParameters')
//          + FFormatter.ParamInt32(Count, '')
//          + FFormatter.CloseProcedure);
//  inherited;
//
//end;

procedure TDBXTraceParameterList.AddParameter(Parameter: TDBXParameter);
begin
  inherited AddParameter(Parameter);

end;

constructor TDBXTraceParameterList.Create(
  Command: TDBXCommand; Parameters: TDBXParameterList;
  DBXContext: TDBXContext; Formatter: TDBXTraceFormatter;
  ParametersName: String; ConnectionId, CommandId: Int64);
begin
  inherited Create(DBXContext, Command, Parameters);
  FFormatter := Formatter;
  FConnectionId := ConnectionId;
  FCommandId := CommandId;
  FParametersName := ParametersName;

end;

destructor TDBXTraceParameterList.Destroy;
begin
  inherited;
end;

function TDBXTraceParameterList.GetName: String;
begin
  REsult := FParametersName;
end;


procedure TDBXTraceParameterList.InsertParameter(Ordinal: Integer;
  Parameter: TDBXParameter);
begin
  inherited InsertParameter(Ordinal, Parameter);

end;

procedure TDBXTraceParameterList.SetParameter(Ordinal: Integer;
  Parameter: TDBXParameter);
begin
  inherited SetParameter(Ordinal, Parameter);

end;



{ TDBXConsoleTraceWriter }

function TDBXConsoleTraceWriter.IsSingleton: Boolean;
begin
  Result := true;
end;

function TDBXConsoleTraceWriter.WriteTrace(TraceInfo: TDBXTraceInfo): CBRType;
begin
  Writeln(TraceInfo.Message);
  Result := cbrUSEDEF;
end;

//{ TDBXTraceRegistry }
//
//procedure TDBXTraceRegistry.AddTraceWriter(Name: WideString;
//  ObjectClass: TObjectClass);
//begin
//  FTraceRegistry.RegisterClass(Name, ObjectClass);
//end;
//
//constructor TDBXTraceRegistry.Create;
//begin
//  inherited Create;
//  FTraceRegistry := TClassRegistry.Create;
//  FSingletons    := TWideStringList.Create;
//end;
//
//destructor TDBXTraceRegistry.Destroy;
//begin
//  FreeAndNil(FTraceRegistry);
//  FreeAndNil(FSingletons);
//  inherited;
//end;
//
//function TDBXTraceRegistry.GetInstance(Name: WideString;
//  Properties: TDBXProperties): TDBXTraceRegistry;
//begin
//  Result := nil;
//end;
//
//procedure TDBXTraceRegistry.ReleaseInstance(TraceWriter: TDBXTraceWriter);
//begin
//
//end;


{ TDBXTraceWritableValue }

constructor TDBXTraceWritableValue.Create(DBXContext: TDBXContext; ValueType: TDBXValueType; Value: TDBXWritableValue;  Formatter: TDBXTraceFormatter;ValueName: WideString);
begin
  inherited Create(ValueType, Value);
  FFormatter      := Formatter;
  FValueName      := ValueName;
  FLastOrdinal    := -1;
end;

//constructor TDBXTraceWritableValue.Create(DBXContext: TDBXContext; ValueType: TDBXValueType; Value: TDBXValue;  Formatter: TDBXTraceFormatter; ValueName: WideString);
//begin
//  inherited Create(ValueType, Value);
//  FFormatter      := Formatter;
//  FValueName      := ValueName;
//  FLastOrdinal    := -1;
//end;

destructor TDBXTraceWritableValue.Destroy;
begin

  inherited;
end;

function TDBXTraceWritableValue.GetBcd: TBcd;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty('ResultBcd',
                                  GetValueDisplayName,
                                  'GetBcd'));
  Result := inherited GetBCD;
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultBcd', FFormatter.ParamBcd(Result, '')));

end;

function TDBXTraceWritableValue.GetBoolean: Boolean;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty('ResultBoolean',
                                  GetValueDisplayName,
                                  'GetBoolean'));
  Result := inherited GetBoolean;
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultBoolean', FFormatter.ParamBoolean(Result, '')));

end;

function TDBXTraceWritableValue.GetBytes(Offset: Int64;
  const Buffer: TBytes; BufferOffset, Length: Int64): Int64;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty('ResultBytes',
                                  GetValueDisplayName,
                                  'GetBytes'));
  Result := inherited GetBytes(Offset, Buffer, BufferOffset, Length);
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultBytes',
          FFormatter.ParamBytes(Buffer, BufferOffset, Length, Result, '')));

end;

function TDBXTraceWritableValue.GetDate: TDBXDate;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty('ResultDate',
                                  GetValueDisplayName,
                                  'GetGetDate'));
  Result := inherited GetDate;
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultDate', FFormatter.ParamDate(Result, '')));

end;

function TDBXTraceWritableValue.GetDouble: Double;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty('ResultDouble',
                                  GetValueDisplayName,
                                  'GetDouble'));
  Result := inherited GetDouble;
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultDouble', FFormatter.ParamDouble(Result, '')));

end;

function TDBXTraceWritableValue.GetInt16: SmallInt;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty('ResultInt16',
                                  GetValueDisplayName,
                                  'GetInt16'));
  Result := inherited GetInt16;
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultInt16', FFormatter.ParamInt16(Result, '')));

end;

function TDBXTraceWritableValue.GetInt32: TInt32;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty('ResultInt32',
                                  GetValueDisplayName,
                                  'GetInt32'));
  Result := inherited GetInt32;
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultInt32', FFormatter.ParamInt32(Result, '')));

end;

function TDBXTraceWritableValue.GetInt64: Int64;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty('ResultInt64',
                                  GetValueDisplayName,
                                  'GetInt64'));
  Result := inherited GetInt64;
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultInt64', FFormatter.ParamInt64(Result, '')));

end;

function TDBXTraceWritableValue.GetAnsiString: String;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty('ResultString',
                                  GetValueDisplayName,
                                  'GetAnsiString'));
  Result := inherited GetAnsiString;
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultString', FFormatter.ParamString(Result, '')));

end;

function TDBXTraceWritableValue.GetTime: TDBXTime;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty('ResultTime',
                                  GetValueDisplayName,
                                  'GetTime'));
  Result := inherited GetTime;
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultTime', FFormatter.ParamTime(Result, '')));

end;

function TDBXTraceWritableValue.GetTimeStamp: TSQLTimeStamp;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty('ResultTimeStamp',
                                  GetValueDisplayName,
                                  'GetTimeStamp'));
  Result := inherited GetTimeStamp;
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultTimeStamp', FFormatter.ParamTimeStamp(Result, '')));

end;

function TDBXTraceWritableValue.GetValueDisplayName: WideString;
begin
  if FLastOrdinal <> ValueType.Ordinal then
  begin
    FValueDisplayName := FValueName + '[' + IntToStr(ValueType.Ordinal) + '].Value';
    FLastOrdinal := ValueType.Ordinal;
  end;
  Result := FValueDisplayName;
end;

function TDBXTraceWritableValue.GetValueSize: Int64;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DbxContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty('ResultGetValueSize',
                                  GetValueDisplayName,
                                  'GetValueSize'));
  Result := inherited GetValueSize;
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DbxContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultGetBlobLength', FFormatter.ParamInt64(Result, '')));

end;

function TDBXTraceWritableValue.GetWideString: WideString;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty('ResultWideString',
                                  GetValueDisplayName,
                                  'GetWideString'));
  Result := inherited GetWideString;
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultWideString', FFormatter.ParamWideString(Result, '')));

end;

function TDBXTraceWritableValue.IsNull: Boolean;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.GetProperty(GetValueDisplayName+' ResultIsNull',
                                  GetValueDisplayName,
                                  'IsNull'));
  Result := inherited IsNull;
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CommentValue(GetValueDisplayName+' ResultIsNull', FFormatter.ParamBoolean(Result, '')));

end;

procedure TDBXTraceWritableValue.SetBcd(const Value: TBcd);
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallOpenProcedure(GetValueDisplayName,
          'SetBcd')
          + FFormatter.ParamBcd(Value, '')
          + FFormatter.CloseProcedure);
  inherited;
end;

procedure TDBXTraceWritableValue.SetBoolean(Value: Boolean);
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallOpenProcedure(GetValueDisplayName,
          'SetBoolean')
          + FFormatter.ParamBoolean(Value, '')
          + FFormatter.CloseProcedure);
  inherited;
end;

procedure TDBXTraceWritableValue.SetDate(Value: TDBXDate);
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallOpenProcedure(GetValueDisplayName,
          'SetDate')
          + FFormatter.ParamDate(Value, '')
          + FFormatter.CloseProcedure);
  inherited;
end;

procedure TDBXTraceWritableValue.SetDouble(Value: Double);
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallOpenProcedure(GetValueDisplayName,
          'SetDouble')
          + FFormatter.ParamDouble(Value, '')
          + FFormatter.CloseProcedure);
  inherited;
end;

procedure TDBXTraceWritableValue.SetDynamicBytes(Offset: Int64;
  const Buffer: TBytes; BufferOffset, Length: Int64);
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallOpenProcedure(GetValueDisplayName,
          'SetDynamicBytes')
          + FFormatter.ParamInt64(Offset, ',')
          + FFormatter.ParamBytes(Buffer, BufferOffset, Length, Length, ',')
          + FFormatter.ParamInt64(BufferOffset, ',')
          + FFormatter.ParamInt64(Length, '')
          + FFormatter.CloseProcedure);
  inherited;
end;

procedure TDBXTraceWritableValue.SetInt16(Value: SmallInt);
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallOpenProcedure(GetValueDisplayName,
          'SetInt16')
          + FFormatter.ParamInt16(Value, '')
          + FFormatter.CloseProcedure);
  inherited;
end;

procedure TDBXTraceWritableValue.SetInt32(Value: TInt32);
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallOpenProcedure(GetValueDisplayName,
          'SetInt32')
          + FFormatter.ParamInt32(Value, '')
          + FFormatter.CloseProcedure);
  inherited;
end;

procedure TDBXTraceWritableValue.SetInt64(Value: Int64);
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallOpenProcedure(GetValueDisplayName,
          'SetInt64')
          + FFormatter.ParamInt64(Value, '')
          + FFormatter.CloseProcedure);
  inherited;
end;

procedure TDBXTraceWritableValue.SetNull;
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallProcedure(GetValueDisplayName,
          'SetNull'));
  inherited;
end;

procedure TDBXTraceWritableValue.SetStaticBytes(Offset: Int64;
  const Buffer: array of Byte; BufferOffset, Length: Int64);
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallOpenProcedure(GetValueDisplayName,
          'SetStaticBytes')
          + FFormatter.ParamInt64(Offset, ',')
          + FFormatter.ParamBytes(Buffer, BufferOffset, Length, Length, ',')
          + FFormatter.ParamInt64(BufferOffset, ',')
          + FFormatter.ParamInt64(Length, '')
          + FFormatter.CloseProcedure);
  inherited;
end;

procedure TDBXTraceWritableValue.SetAnsiString(const Value: String);
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallOpenProcedure(GetValueDisplayName,
          'SetAnsiString')
          + FFormatter.ParamString(Value, '')
          + FFormatter.CloseProcedure);
  inherited;
end;

procedure TDBXTraceWritableValue.SetTime(Value: TDBXTime);
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallOpenProcedure(GetValueDisplayName,
          'SetTime')
          + FFormatter.ParamTime(Value, '')
          + FFormatter.CloseProcedure);
  inherited;
end;

procedure TDBXTraceWritableValue.SetTimeStamp(const Value: TSQLTimeStamp);
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallOpenProcedure(GetValueDisplayName,
          'SetTimeStamp')
          + FFormatter.ParamTimeStamp(Value, '')
          + FFormatter.CloseProcedure);
  inherited;

end;

procedure TDBXTraceWritableValue.SetWideString(const Value: WideString);
begin
  if DBXContext.IsTracing(TDBXTraceFlags.Parameter) then
    DBXContext.Trace(TDBXTraceFlags.Parameter,
          FFormatter.CallOpenProcedure(GetValueDisplayName,
          'SetWideString')
          + FFormatter.ParamWideString(Value, '')
          + FFormatter.CloseProcedure);
  inherited;
end;

{ TDBXTraceParameter }

function TDBXTraceParameter.Clone: TObject;
var
  Parameter: TDBXParameterEx;
begin
  if Assigned(FParameter) then
    Parameter := TDBXParameterEx(TDBXParameterEx(FParameter).Clone)
  else
    Parameter := nil;
  Result := TDBXTraceParameter.Create(FDBXContext, Parameter, FFormatter, FParameterName+'_Clone'); { Do not resource }
end;

constructor TDBXTraceParameter.Create(DbxContext: TDBXContext; Parameter: TDBXParameter;
Formatter: TDBXTraceFormatter; ValueName: WideString);
begin
  inherited Create(DbxContext, Parameter);
//  if (DataType <> TDBXTypes.UnknownType) then
//    FTraceValue := TDBXTraceWritableValue.Create(DbxContext, Parameter.Value, Formatter, ValueName)
  FFormatter  := Formatter;
  FParameterName := ValueName;
end;

destructor TDBXTraceParameter.Destroy;
begin
  inherited;
  FreeAndNil(FTraceValue);
end;

function TDBXTraceParameter.GetValue: TDBXWritableValue;
begin
  if FTraceValue = nil then
  begin
    if FParameter.Value <> nil then
    begin
      FTraceValue := TDBXTraceWritableValue.Create(FDbxContext, Self, FParameter.Value, FFormatter, FParameterName);
    end;
  end;
  // Subtle.  Causes type changes to be updated if needed.
  //
  inherited GetValue;
  Result := FTraceValue;

end;


{ TDBXTraceOutput }

procedure TDBXTraceOutput.AddReference;
begin
  inc(FReferenceCount);
end;

constructor TDBXTraceOutput.Create;
begin
  inherited;
  FFormatter := TDBXTracePascalFormatter.Create('{', '}', 200);
  FCriticalSection := TCriticalSection.Create;
end;

destructor TDBXTraceOutput.Destroy;
begin
  FreeAndNil(FFormatter);
  FreeAndNil(FCriticalSection);
  inherited;
end;

function TDBXTraceOutput.LogDriverTrace(TraceInfo: TDBXTraceInfo): CBRType;
var
  DriverTraceInfo: TDBXTraceInfo;
begin
  DriverTraceInfo.TraceFlag := TraceInfo.TraceFlag or TDBXTraceFlags.Driver;
  DriverTraceInfo.Message   := FFormatter.Comment(TraceInfo.Message);
  Result := LogTrace(DriverTraceInfo);
end;

function TDBXTraceOutput.LogTrace(TraceInfo: TDBXTraceInfo): CBRType;
var
  TraceName: String;
  OriginalLength: Integer;
  Index: Integer;
  Line: WideString;
begin
  TraceName := TraceFlagToString(TraceInfo.TraceFlag);
  OriginalLength := Length(TraceName);
  SetLength(TraceName, 15);
  for Index := OriginalLength+1 to 15 do
    TraceName[Index] := ' ';
  Line := FFormatter.Comment(TraceName)+' '+TraceInfo.Message;
  FCriticalSection.Acquire;
  try
    WriteTraceln(Line);
  finally
    FCriticalSection.Release;
  end;
  Result := cbrUSEDEF;
end;

function TDBXTraceOutput.RemoveReference: TInt32;
begin
  dec(FReferenceCount);
  Result := FReferenceCount;
end;


function TDBXTraceOutput.TraceFlagToString(TraceFlag: TDBXTraceFlag): String;
begin
  if TraceFlag and TDBXTraceFlags.Driver <> 0 then
  begin
    Result := TDBXTraceFlagNames.DRIVER + ' ' + TraceFlagToString(TraceFlag - TDBXTraceFlags.Driver);
  end else
    case TraceFlag of
        TDBXTraceFlags.Prepare:     Result := TDBXTraceFlagNames.PREPARE;
        TDBXTraceFlags.Execute:     Result := TDBXTraceFlagNames.EXECUTE;
        TDBXTraceFlags.Error:       Result := TDBXTraceFlagNames.ERROR;
        TDBXTraceFlags.Command:     Result := TDBXTraceFlagNames.COMMAND;
        TDBXTraceFlags.Connect:     Result := TDBXTraceFlagNames.CONNECT;
        TDBXTraceFlags.Transact:    Result := TDBXTraceFlagNames.TRANSACT;
        TDBXTraceFlags.Blob:        Result := TDBXTraceFlagNames.BLOB;
        TDBXTraceFlags.Misc:        Result := TDBXTraceFlagNames.MISC;
        TDBXTraceFlags.Vendor:      Result := TDBXTraceFlagNames.VENDOR;
        TDBXTraceFlags.Parameter:   Result := TDBXTraceFlagNames.PARAMETER;
        TDBXTraceFlags.Reader:      Result := TDBXTraceFlagNames.READER;
        TDBXTraceFlags.DriverLoad: Result := TDBXTraceFlagNames.DRIVER_LOAD;
        TDBXTraceFlags.MetaData:    Result := TDBXTraceFlagNames.METADATA;
      else
        Result := 'UNKNOWN' +'('+IntToStr(TraceFlag)+')';
    end;
end;

{ TDBXFileTraceOutput }

destructor TDBXFileTraceOutput.Destroy;
begin
  CloseFile(FTraceFile);
  inherited;
end;

procedure TDBXFileTraceOutput.Open;
begin
    AssignFile(FTraceFile, Name);
    if FileExists(Name) then
      Append(FTraceFile)
    else
      Rewrite(FTraceFile);
    WriteTraceln('Log Opened ==========================================');
end;

procedure TDBXFileTraceOutput.WriteTraceln(Line: WideString);
begin
    Writeln(FTraceFile, Line);
end;

{ TDBXConsoleTraceOutput }

destructor TDBXConsoleTraceOutput.Destroy;
begin

  inherited;
end;

procedure TDBXConsoleTraceOutput.Open;
begin

end;

procedure TDBXConsoleTraceOutput.WriteTraceln(Line: WideString);
begin
    Writeln(Line);
end;

{ TDBXTraceReader }

constructor TDBXTraceReader.Create(DBXContext: TDBXContext; Reader: TDBXReader;
  Formatter: TDBXTraceFormatter; ConnectionId, CommandId, ReaderId: Int64);
begin
  inherited Create(DBXContext, Reader);
  FFormatter      := Formatter;
  FConnectionId   := ConnectionId;
  FCommandId      := CommandId;
  FReaderId       := ReaderId;
  FReaderName     := 'ReaderC'+IntToStr(ConnectionId)+'_'+IntToStr(CommandId)+'_'+IntToStr(ReaderId);
  if FDBXContext.IsTracing(TDBXTraceFlags.Reader) then
    PrintColumns;

end;


destructor TDBXTraceReader.Destroy;
begin
  if FDBXContext.IsTracing(TDBXTraceFlags.Reader) then
  begin
    if not FClosed then
      FDbxContext.Trace(  TDBXTraceFlags.Reader,
                          ' { ' + FReaderName + ' closed.  '
                          + IntToStr(FNextCount) + ' row(s) read }');

    FDbxContext.Trace(  TDBXTraceFlags.Reader,
                        FFormatter.CallOpenProcedure('', 'FreeAndNil')
                        + FReaderName + FFormatter.CloseProcedure);
//                        + ' { ' + IntToStr(FNextCount) + ' row(s) read }');
  end;
  inherited;
end;

function TDBXTraceReader.Next: Boolean;
begin
  Result := inherited Next;
  if Result then
    inc(FNextCount)
  else if not FClosed then
  begin
    if FDBXContext.IsTracing(TDBXTraceFlags.Reader) then
    begin
      FDbxContext.Trace(  TDBXTraceFlags.Reader,
                          ' { ' + FReaderName + ' closed.  '
                          + IntToStr(FNextCount) + ' row(s) read }');
    end;
    FClosed := true;
  end;
end;

procedure TDBXTraceReader.PrintColumns;
var
  Ordinal: Integer;
  LastOrdinal: Integer;
  LocalValueType: TDBXValueType;
begin
    LastOrdinal := GetColumnCount - 1;
    for Ordinal := 0 to LastOrdinal do
    begin
      LocalValueType := ValueType[Ordinal];
      FDBXContext.Trace(TDBXTraceFlags.Reader,
                          ' {' + LocalValueType.Name
                        + '  ' + FFormatter.ColumnTypeToStr(LocalValueType.DataType)
                        + ' }');
    end;
end;

initialization
  DBXTraceDriverLoaderClass := TDBXTraceDriverLoader;
  TClassRegistry.GetClassRegistry
  .RegisterClass(STRACE_DRIVER_LOADER_NAME, DBXTraceDriverLoaderClass);
finalization
  if DBXTraceDriverLoaderClass <> nil then
    TClassRegistry.GetClassRegistry
    .UnregisterClass(STRACE_DRIVER_LOADER_NAME);
//{$IFEND}
end.

