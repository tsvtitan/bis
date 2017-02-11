{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2006 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }
unit DBXPool;

interface

uses DBXCommon, DBXPlatform, ClassRegistry, Classes, DbxDelegate, SysUtils, SyncObjs
{$IF DEFINED(CLR)}
{$ELSE}
  , WideStrings
{$IFEND}
;

const
{$IF DEFINED(CLR)}
  SCONNECTION_POOL_DRIVER_LOADER_NAME = 'Borland.Data.'+'TDBXPoolDriverLoader'; // Do not localize
{$ELSE}
  SCONNECTION_POOL_DRIVER_LOADER_NAME = 'TDBXPoolDriverLoader'; // Do not localize
{$IFEND}

resourcestring
  SConnectTimeout = 'Connect request timed out after %s milliseconds';
  SInvalidCommand = 'Unrecognized command:  %s';

type

///<summary>the DBXPool delegate driver specific connection properties</summary>
TDBXPoolPropertyNames = class
  const
      /// <remarks>Maximum number of connections allocated in a connection pool.</remarks>
      MaxConnections    = 'MaxConnections'; { do not localize }
      /// <remarks>Minimum number of connections allocated in a connection pool.</remarks>
      MinConnections    = 'MinConnections';   { do not localize }
      /// <remarks>Number of wait time seconds to wait for a connection.</remarks>
      ConnectTimeout    = 'ConnectTimeout'; { do not localize }

end;

///<summary>
///  DBXCommand instances that are created with the TDBXCommandType.DBXConnectionPool
///  command type can have their TDBXCommand.Text property set to one of the commands
///  below.
///</summary>
TDBXPoolCommands = class
    const
      ///<summary>Returns a TDBXReader instance with the TDBXPoolsTable columns.</summary>
      GetPools = 'GetPools';      {Do not localize}
end;
///<summary>Columns returned by executing the TDBXPoolCommands.GetPools command</summary>
TDBXPoolsTable = class
  const
      ///<summary>Name of connection if any.</summary>
      ConnectionName          = 'ConnectionName';      {Do not localize}
      ///<summary>Name of driver for this connection.</summary>
      DriverName              =  'DriverName';         {Do not localize}
      ///<summary>Name of database for this connection.</summary>
      DatabaseName            = 'DatabaseName';        {Do not localize}
      ///<summary>Name of user for this connection.</summary>
      UserName                = 'UserName';            {Do not localize}
      ///<summary>Unique path of all delegate drivers used for this connection.</summary>
      DelegateSignature       = 'DelegateSignature';   {Do not localize}
      ///<summary>Integer time out in milliseconds for this connection.</summary>
      ConnectTimeout          = 'ConnectTimeout';      {Do not localize}
      ///<summary>Integer count open connections in the pool available for use.</summary>
      AvailableConnections    = 'AvailableConnections';{Do not localize}
      ///<summary>Integer count of the total connections in the pool.</summary>
      TotalConnections        = 'TotalConnections';    {Do not localize}
      ///<summary>Integer count of the maximum connections in the pool.</summary>
      MaxConnections          = 'MaxConnections';      {Do not localize}

end;

TDBXPoolDriverLoader = class(TDBXDriverLoader)
  public
    constructor Create; override;
    function Load(DriverDef: TDBXDriverDef): TDBXDriver; override;
end;

TDBXPool = class;
TDBXPoolDriver = class;

TDBXPoolConnection = class(TDBXDelegateConnection)
  private
    FPoolDriver:  TDBXPoolDriver;
    FPool:        TDBXPool;
  protected
    procedure DerivedGetCommandTypes(List: TWideStrings); override;
    procedure DerivedGetCommands(CommandType: WideString; List: TWideStrings); override;

  public
    constructor Create(Pool: TDBXPool; ConnectionBuilder: TDBXConnectionBuilder; PoolDriver: TDBXPoolDriver; Connection: TDBXConnection);
    destructor Destroy; override;
    function CreateCommand: TDBXCommand; overload; override;
end;

TDBXPoolCommand = class(TDBXCommand)
  private
    FPool:    TDBXPool;
    function ExecuteGetPools: TDBXReader;
  protected
    procedure SetMaxBlobSize(const MaxBlobSize: Int64); override;
    procedure SetRowSetSize(const Value: Int64); override;
    procedure DerivedOpen; override;
    procedure DerivedClose; override;

    function  DerivedGetNextReader: TDBXReader; override;
    function  DerivedExecuteQuery: TDBXReader; override;
    procedure DerivedExecuteUpdate; override;
    procedure DerivedPrepare; override;
    function  GetRowsAffected: Int64; override;
    constructor Create(DBXContext: TDBXContext; Pool: TDBXPool);

  public

    destructor Destroy; override;
end;

TDBXPoolReader = class(TDBXReader)
    private
      FByteReader:  TDBXReaderByteReader;
    protected
      function  DerivedNext: Boolean; override;
      procedure DerivedClose; override;
      function  GetByteReader: TDBXByteReader; override;

    public
      constructor Create(DBXContext: TDBXContext; DbxRow: TDBXRow; ByteReader: TDBXByteReader);
      destructor Destroy; override;
end;

TDBXPoolRow = class(TDBXRow)
  private
    FPoolList:    TList;
    FRow:         Integer;
    function  Next: Boolean;
  protected
      procedure GetWideString(DbxValue: TDBXWideStringValue; var WideStringBuilder: TDBXWideStringBuilder; var IsNull: LongBool); override;
      procedure GetInt32(DbxValue: TDBXInt32Value; var Value: TInt32; var IsNull: LongBool); override;

  public
    constructor Create(PoolList: TList; DBXContext: TDBXContext);
end;

TDBXPool = class
  private
    FSemaphore:                 TDBXSemaphore;
    FCriticalSection:           TCriticalSection;

    FConnectionBuilder:         TDBXConnectionBuilder;
    FAllConnectionArray:        array of TDBXConnection;
    FAvailableConnectionArray:  array of TDBXConnection;


    FPoolDriver:            TDBXPoolDriver;
    FConnectionName:        WideString;
    FDriverName:            WideString;
    FDatabaseName:          WideString;
    FUserName:              WideString;
    FDelegateSignature:     WideString;
    FConnectTimeout:        Integer;
    FTotalConnections:      Integer;
    FAvailableConnections:  Integer;
    FMaxConnections:        Integer;

    constructor Create(Driver: TDBXPoolDriver; ConnectionBuilder: TDBXConnectionBuilder);
    function Equals(ConnectionBuilder: TDBXConnectionBuilder;
                    const ConnectionName:     WideString;
                    const DelegateSignature:  WideString;
                    const DriverName:         WideString;
                    const DatabaseName:       WideString;
                    const UserName:           WideString): Boolean;

    function GetConnection(ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection;
    procedure ReleaseConnection(Connection: TDBXConnection);
    procedure ClearPool;
  public
    destructor Destroy; override;
end;

TDBXPoolDriver = class(TDBXDriverEx)
    private
      FPoolList:        TList;

      function  FindPool(ConnectionBuilder: TDBXConnectionBuilder): TDBXPool;
      procedure ClearPools;
      function  CreatePoolCommand(DbxContext: TDBXContext; Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand;
    protected
      procedure Close; override;


    public
      destructor Destroy; override;
      constructor Create;
      function CreateConnection(ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection; override;
      function GetDriverVersion: WideString; override;
end;

implementation

type

  TDBXColumnDef = record
    Name:           WideString;
    DataType:       TDBXType;
    SubType:        TDBXType;
    Precision:      TInt32;
    Scale:          TInt32;
    Size:           TInt32;
    ValueTypeFlags: TInt32;
  end;

  TDBXPoolDriverLoaderClass = class of TDBXPoolDriverLoader;
var
  DBXPoolDriverLoaderClass: TDBXPoolDriverLoaderClass;

const
  WideStringPrecision = 96;
  PoolValueTypeFlags  =     TDBXValueTypeFlags.Nullable
                        or  TDBXValueTypeFlags.ReadOnly
                        or  TDBXValueTypeFlags.Searchable;
  PoolColumnDefs: array[0..8] of TDBXColumnDef =
    (
      (Name: TDBXPoolsTable.ConnectionName; DataType: TDBXDataTypes.WideStringType; SubType: TDBXDataTypes.UnknownType; Precision: WideStringPrecision; Scale: -1; Size: WideStringPrecision; ValueTypeFlags: PoolValueTypeFlags),
      (Name: TDBXPoolsTable.DriverName;           DataType: TDBXDataTypes.WideStringType; SubType: TDBXDataTypes.UnknownType; Precision: WideStringPrecision; Scale: -1; Size: WideStringPrecision; ValueTypeFlags: PoolValueTypeFlags),
      (Name: TDBXPoolsTable.DatabaseName;         DataType: TDBXDataTypes.WideStringType; SubType: TDBXDataTypes.UnknownType; Precision: WideStringPrecision; Scale: -1; Size: WideStringPrecision; ValueTypeFlags: PoolValueTypeFlags),
      (Name: TDBXPoolsTable.UserName;             DataType: TDBXDataTypes.WideStringType; SubType: TDBXDataTypes.UnknownType; Precision: WideStringPrecision; Scale: -1; Size: WideStringPrecision; ValueTypeFlags: PoolValueTypeFlags),
      (Name: TDBXPoolsTable.DelegateSignature;    DataType: TDBXDataTypes.WideStringType; SubType: TDBXDataTypes.UnknownType; Precision: WideStringPrecision; Scale: -1; Size: WideStringPrecision; ValueTypeFlags: PoolValueTypeFlags),
      (Name: TDBXPoolsTable.ConnectTimeout;       DataType: TDBXDataTypes.Int32Type;      SubType: TDBXDataTypes.UnknownType; Precision: WideStringPrecision; Scale: -1; Size: WideStringPrecision; ValueTypeFlags: PoolValueTypeFlags),
      (Name: TDBXPoolsTable.AvailableConnections; DataType: TDBXDataTypes.Int32Type;      SubType: TDBXDataTypes.UnknownType; Precision: WideStringPrecision; Scale: -1; Size: WideStringPrecision; ValueTypeFlags: PoolValueTypeFlags),
      (Name: TDBXPoolsTable.TotalConnections;     DataType: TDBXDataTypes.Int32Type;      SubType: TDBXDataTypes.UnknownType; Precision: WideStringPrecision; Scale: -1; Size: WideStringPrecision; ValueTypeFlags: PoolValueTypeFlags),
      (Name: TDBXPoolsTable.MaxConnections;       DataType: TDBXDataTypes.Int32Type;      SubType: TDBXDataTypes.UnknownType; Precision: WideStringPrecision; Scale: -1; Size: WideStringPrecision; ValueTypeFlags: PoolValueTypeFlags)
    );

{ TDBXPoolDriverLoader }

constructor TDBXPoolDriverLoader.Create;
begin
  inherited;
end;

function TDBXPoolDriverLoader.Load(
  DriverDef: TDBXDriverDef): TDBXDriver;
begin
  Result := nil;
  if DriverDef.FDriverProperties[TDBXPropertyNames.DriverName] = 'DBXPool' then
  begin
    Result := TDBXPoolDriver.Create;
  end;
end;

{ TDBXPoolDriver }


constructor TDBXPoolDriver.Create;
begin
  inherited Create;
  FPoolList :=  TList.Create;
  CacheUntilFinalization;
  AddCommandFactory(TDBXCommandTypes.DbxPool, CreatePoolCommand);

end;

function TDBXPoolDriver.CreateConnection(
  ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection;
var
  Pool:           TDBXPool;
begin
  Pool := FindPool(ConnectionBuilder);
  if Pool = nil then
  begin
    Pool := TDBXPool.Create(Self, ConnectionBuilder);
    FPoolList.Add(Pool);
  end;
  Result := Pool.GetConnection(ConnectionBuilder);
end;

function TDBXPoolDriver.CreatePoolCommand(DbxContext: TDBXContext;
  Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand;
begin
    Result := TDBXPoolCommand.Create(DBXContext, TDBXPoolConnection(Connection).FPool);
end;

destructor TDBXPoolDriver.Destroy;
var
  Pool: TDBXPool;
  Index: Integer;
begin
  for Index := 0 to FPoolList.Count - 1 do
  begin
    Pool := TDBXPool(FPoolList[Index]);
    Pool.Destroy;
  end;
  FreeAndNil(FPoolList);
  inherited;
end;

function TDBXPoolDriver.FindPool(
  ConnectionBuilder: TDBXConnectionBuilder): TDBXPool;
var
  Index:              Integer;
  Pool:               TDBXPool;
  DriverName:         WideString;
  DatabaseName:       WideString;
  DelegateSignature:  WideString;
begin
  DelegateSignature := ConnectionBuilder.DelegationSignature;
  DriverName        := ConnectionBuilder.InputConnectionProperties[TDBXPropertyNames.DriverName];
  DatabaseName      := ConnectionBuilder.InputConnectionProperties[TDBXPropertyNames.Database];
  for Index := 0 to FPoolList.Count - 1 do
  begin
    Pool := TDBXPool(FPoolList[Index]);
    if Pool.Equals( ConnectionBuilder,
                    ConnectionBuilder.InputConnectionName,
                    DelegateSignature,
                    DriverName,
                    DatabaseName,
                    ConnectionBuilder.InputUserName) then
    begin
      Result := Pool;
      exit;
    end;
  end;
  Result := nil;
end;

function TDBXPoolDriver.GetDriverVersion: WideString;
begin
  Result := 'DBXPoolDriver 1.0'; {Do not localize}
end;

{ TDBXPool }

constructor TDBXPool.Create(Driver: TDBXPoolDriver; ConnectionBuilder: TDBXConnectionBuilder);
var
  Properties: TDBXProperties;
begin
  inherited Create;
  FPoolDriver         := Driver;
  FConnectionName     := ConnectionBuilder.InputConnectionName;
  FConnectionBuilder  := TDBXDriverHelp.CreateConnectionBuilder(ConnectionBuilder);
  FDelegateSignature  := FConnectionBuilder.DelegationSignature;
  FDriverName         := FConnectionBuilder.InputConnectionProperties[TDBXPropertyNames.DriverName];
  FDatabaseName       := FConnectionBuilder.InputConnectionProperties[TDBXPropertyNames.Database];
  FUserName           := FConnectionBuilder.InputUserName;
  Properties          := FConnectionBuilder.ConnectionProperties;
  FTotalConnections   := Properties.GetInteger(TDBXPoolPropertyNames.MinConnections);


  if FTotalConnections < 0 then
    FTotalConnections := 0;
  FMaxConnections := Properties.GetInteger(TDBXPoolPropertyNames.MaxConnections);
  if FMaxConnections < 1 then
    FMaxConnections := 16;
  FConnectTimeout     := Properties.GetInteger(TDBXPoolPropertyNames.ConnectTimeout);
  if FConnectTimeout < 0 then
    FConnectTimeout := 0;

  FSemaphore          := TDBXSemaphore.Create(FMaxConnections);
  FCriticalSection    := TCriticalSection.Create;

  SetLength(FAllConnectionArray, FTotalConnections);
  SetLength(FAvailableConnectionArray, FTotalConnections);
end;

procedure TDBXPoolDriver.ClearPools;
var
  Pool: TDBXPool;
  Index: Integer;
begin
  for Index := 0 to FPoolList.Count - 1 do
  begin
    Pool := TDBXPool(FPoolList[Index]);
    Pool.ClearPool;
  end;
  inherited;
end;

procedure TDBXPoolDriver.Close;
begin
  ClearPools;
end;

procedure TDBXPool.ClearPool;
var
  Index: Integer;
begin
  for Index := 0 to FTotalConnections-1 do
      FAllConnectionArray[Index].Free;
  FTotalConnections       := 0;
  FAvailableConnections   := 0;
end;

destructor TDBXPool.Destroy;
begin
  ClearPool;
  SetLength(FAllConnectionArray, 0);
  SetLength(FAvailableConnectionArray, 0);
  FreeandNil(FCriticalSection);
  FreeAndNil(FSemaphore);
  FreeAndNil(FConnectionBuilder);
  inherited;
end;

function TDBXPool.Equals(
  ConnectionBuilder:  TDBXConnectionBuilder;
  const ConnectionName:     WideString;
  const DelegateSignature:  WideString;
  const DriverName:         WideString;
  const DatabaseName:       WideString;
  const UserName:           WideString): Boolean;

begin
  if (FConnectionName = ConnectionName) and (ConnectionName <> '') then
  begin
    if FUserName = UserName then
      Result := true
    else
      Result := false;
  end else
  begin
    if FDatabaseName <> DatabaseName then
      Result := false
    else if FUserName <> UserName then
      Result := false
    else if FDriverName <> DriverName then
      Result := false
    else if FDelegateSignature <> DelegateSignature then
      Result := false
    else
      Result := true;
  end;
end;

function TDBXPool.GetConnection(
  ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection;
begin

  Result := nil;
  if not FSemaphore.Acquire(FConnectTimeout) then
    ConnectionBuilder.DBXContext
    .Error(TDBXErrorCodes.ConnectionFailed,
             WideFormat(SConnectTimeout, [IntToStr(FConnectTimeout)]));
  try
    FCriticalSection.Acquire;
    try
      if FAvailableConnections < 1 then
      begin
        SetLength(FAllConnectionArray, FTotalConnections+1);
        SetLength(FAvailableConnectionArray, FTotalConnections+1);
        FAllConnectionArray[FTotalConnections] := ConnectionBuilder.CreateDelegateeConnection;
        FAvailableConnectionArray[0]   := FAllConnectionArray[FTotalConnections];
        inc(FTotalConnections);
        inc(FAvailableConnections);
      end;
      Result := TDBXPoolConnection.Create(Self, ConnectionBuilder, FPoolDriver, FAvailableConnectionArray[FAvailableConnections-1]);
      dec(FAvailableConnections);
    finally
      FCriticalSection.Release;
    end;
  finally
    // Something went wrong, let go of the semaphore.
    //
    if Result = nil then
      FSemaphore.Release;
  end;
end;

procedure TDBXPool.ReleaseConnection(Connection: TDBXConnection);
begin
  FCriticalSection.Acquire;
  try
    FAvailableConnectionArray[FAvailableConnections] := Connection;
    inc(FAvailableConnections);
  finally
    FCriticalSection.Release;
  end;
  FSemaphore.Release;
end;

{ TDBXPoolConnection }

constructor TDBXPoolConnection.Create(Pool: TDBXPool; ConnectionBuilder: TDBXConnectionBuilder;
  PoolDriver: TDBXPoolDriver; Connection: TDBXConnection);
begin
  inherited Create(ConnectionBuilder, Connection);
  FPoolDriver := PoolDriver;
  FPool := Pool;
end;

function TDBXPoolConnection.CreateCommand: TDBXCommand;
begin
  Result := TDBXMorphicCommand.Create(FDBXContext, Self);
end;


procedure TDBXPoolConnection.DerivedGetCommands(CommandType: WideString;
  List: TWideStrings);
begin
  if CommandType = TDBXCommandTypes.DbxPool then
    List.Add(TDBXPoolCommands.GetPools);
  inherited;
end;

procedure TDBXPoolConnection.DerivedGetCommandTypes(List: TWideStrings);
begin
  if List.IndexOf(TDBXCommandTypes.DbxPool) < 0 then
    List.Add(TDBXCommandTypes.DbxPool);
  inherited;
end;

destructor TDBXPoolConnection.Destroy;
begin
  FPool.ReleaseConnection(FConnection);
  FConnection := nil; // Prevent if from being freed.
  inherited;
end;


{ TDBXPoolCommand }


constructor TDBXPoolCommand.Create(DBXContext: TDBXContext; Pool: TDBXPool);
begin
  inherited Create(DBXContext);
  FPool       := Pool;
end;


destructor TDBXPoolCommand.Destroy;
begin
  inherited;
end;

function TDBXPoolCommand.ExecuteGetPools: TDBXReader;
var
  Column:               TDBXValueType;
  ColumnDef:            TDBXColumnDef;
  Values:               TDBXValueArray;
  ColumnCount:          Integer;
  Ordinal:              Integer;
  DbxPoolReader:        TDBXPoolReader;
  DbxPoolRow:           TDBXPoolRow;
begin
    DbxPoolRow          := TDBXPoolRow.Create(FPool.FPoolDriver.FPoolList, FDBXContext);
    DbxPoolReader       := TDBXPoolReader.Create(FDBXContext, DbxPoolRow, nil);
    try
      ColumnCount         := Length(PoolColumnDefs);
      SetLength(Values, ColumnCount);
      for Ordinal := 0 to ColumnCount-1 do
      begin
        Column                := TDBXDriverHelp.CreateTDBXValueType(FDBXContext);
        ColumnDef             := PoolColumnDefs[Ordinal];
        Column.DataType       := ColumnDef.DataType;
        Column.SubType        := ColumnDef.SubType;
        Column.Ordinal        := Ordinal;
        Column.Precision      := ColumnDef.Precision;
        Column.Scale          := ColumnDef.Scale;
        Column.Size           := ColumnDef.Size;
        Column.ValueTypeFlags := ColumnDef.ValueTypeFlags;
        Column.Name           := ColumnDef.Name;

        Values[Ordinal] := TDBXValue.CreateValue(FDBXContext, Column, DbxPoolRow, true);

      end;

      DbxPoolReader.SetValues(Values);

      Result := DbxPoolReader;

      DbxPoolReader := nil;
    finally
      DbxPoolReader.Free;
    end;
end;


function TDBXPoolCommand.GetRowsAffected: Int64;
begin
  Result := -1;
end;

procedure TDBXPoolCommand.DerivedClose;
begin
end;

procedure TDBXPoolCommand.SetMaxBlobSize(const MaxBlobSize: Int64);
begin
  NotImplemented;
end;

procedure TDBXPoolCommand.SetRowSetSize(const Value: Int64);
begin
  NotImplemented;
end;

function TDBXPoolCommand.DerivedExecuteQuery: TDBXReader;
begin
    if (Text = TDBXPoolCommands.GetPools) then
    begin
      Result := ExecuteGetPools;
    end
    else
    begin
      FDBXContext.Error(TDBXErrorCodes.NotImplemented,
                   WideFormat(SInvalidCommand, [Text]));
      Result := nil;
    end;
end;


procedure TDBXPoolCommand.DerivedExecuteUpdate;
begin
  NotImplemented;
end;

function TDBXPoolCommand.DerivedGetNextReader: TDBXReader;
begin
  Result := nil;
end;

procedure TDBXPoolCommand.DerivedOpen;
begin
end;

procedure TDBXPoolCommand.DerivedPrepare;
begin
end;

{ TDBXPoolReader }

constructor TDBXPoolReader.Create(DBXContext: TDBXContext; DbxRow: TDBXRow;
  ByteReader: TDBXByteReader);
begin
  inherited Create(DBXContext, DbxRow, ByteReader);

end;

destructor TDBXPoolReader.Destroy;
begin

  inherited;
end;

function TDBXPoolReader.GetByteReader: TDBXByteReader;
begin
  if FByteReader = nil then
    FByteReader := TDBXReaderByteReader.Create(FDbxContext, Self);
  Result := FByteReader;
end;

procedure TDBXPoolReader.DerivedClose;
begin
  FreeAndNil(FDbxRow);
  FreeAndNil(FByteReader);
end;

function TDBXPoolReader.DerivedNext: Boolean;
begin
  if FDbxRow = nil then
    Result := False
  else
    Result := TDBXPoolRow(FDbxRow).Next;
end;

{ TDBXPoolRow }

constructor TDBXPoolRow.Create(PoolList: TList; DBXContext: TDBXContext);
begin
  inherited Create(DBXContext);
  FRow := -1;
  FPoolList := PoolList;
end;

procedure TDBXPoolRow.GetInt32(DbxValue: TDBXInt32Value; var Value: TInt32;
  var IsNull: LongBool);
var
  Pool: TDBXPool;
begin
  IsNull := false;
  Pool := TDBXPool(FPoolList[FRow]);
  case DbxValue.ValueType.Ordinal of
    5: Value := Pool.FConnectTimeout;
    6: Value := Pool.FAvailableConnections;
    7: Value := Pool.FTotalConnections;
    8: Value := Pool.FMaxConnections;
    else
      Assert(false);
  end;
end;

procedure TDBXPoolRow.GetWideString(DbxValue: TDBXWideStringValue;
  var WideStringBuilder: TDBXWideStringBuilder; var IsNull: LongBool);
var
  Pool: TDBXPool;
  Value: WideString;
begin
  IsNull := false;
  Pool := TDBXPool(FPoolList[FRow]);
  case DbxValue.ValueType.Ordinal of
    0: Value := Pool.FConnectionName;
    1: Value := Pool.FDriverName;
    2: Value := Pool.FDatabaseName;
    3: Value := Pool.FUserName;
    4: Value := Pool.FDelegateSignature;
    else
      Assert(false);
  end;
  TDBXPlatform.CopyWideStringToBuilder(Value, WideStringBuilder);
end;

function TDBXPoolRow.Next: Boolean;
begin
  if (FRow+1) >= FPoolList.Count then
    Result := False
  else
  begin
    inc(FRow);
    inc(FGeneration);
    Result := True;
  end;

end;


initialization
  DBXPoolDriverLoaderClass := TDBXPoolDriverLoader;
  TClassRegistry.GetClassRegistry
  .RegisterClass(SCONNECTION_POOL_DRIVER_LOADER_NAME, DBXPoolDriverLoaderClass);
finalization
  if DBXPoolDriverLoaderClass <> nil then
    TClassRegistry.GetClassRegistry
    .UnregisterClass(SCONNECTION_POOL_DRIVER_LOADER_NAME);
//{$IFEND}
end.

