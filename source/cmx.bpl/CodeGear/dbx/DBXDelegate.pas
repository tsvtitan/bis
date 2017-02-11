{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2006 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }
unit DBXDelegate;

interface
uses  DBXCommon,
      DBXPlatform,
      Windows,
      Classes,
      FMTBcd,
      SqlTimSt,
      DBCommonTypes,
      SysUtils
{$IF DEFINED(CLR)}
{$ELSE}
  , WideStrings
{$IFEND}
;

type
{$IF DEFINED(CLR)}
  TWideStrings = TStrings;
{$IFEND}


TDBXDelegateConnection = class(TDBXConnectionEx)
  strict protected
    FConnection:    TDBXConnection;

  protected
    function  GetDatabaseMetaData: TDBXDatabaseMetaData; override;
    function  GetConnectionProperties: TDBXProperties; override;
    procedure SetConnectionProperties(const Value: TDBXProperties); override;
    function  GetTraceInfoEvent: TDBXTraceEvent; override;
    procedure SetTraceInfoEvent(TraceInfoEvent: TDBXTraceEvent); override;
    function  GetErrorEvent: TDBXErrorEvent; override;
    procedure SetErrorEvent(ErrorEvent: TDBXErrorEvent); override;

    function  CreateAndBeginTransaction(Isolation: TDBXIsolation): TDBXTransaction; overload; override;
    procedure Commit(Transaction: TDBXTransaction); override;
    procedure Rollback(Transaction: TDBXTransaction); override;
    function  DerivedCreateCommand: TDBXCommand; overload; override;
    procedure DerivedOpen(); override;
    procedure DerivedGetCommandTypes(List: TWideStrings); override;
    procedure DerivedGetCommands(CommandType: WideString; List: TWideStrings); override;
    function  GetIsOpen: Boolean; override;
    function CreateMorphCommand(MorphicCommand: TDBXCommand): TDBXCommand; override;
    function GetProductVersion: WideString; override;
    function GetProductName: WideString; override;
    procedure Open(); override;

  public
    constructor Create(ConnectionBuilder: TDBXConnectionBuilder; Connection: TDBXConnection);
    destructor Destroy; override;

    function GetVendorProperty(const Name: WideString): WideString; override;
    function CreateCommand: TDBXCommand; override;
end;


TDBXDelegateCommand = class(TDBXCommandEx)
  strict protected
    FCommand: TDBXCommand;

  protected
    function  GetRowsAffected: Int64; override;
    function  GetText: WideString; override;
    procedure SetCommandType(const Value: WideString); override;
    procedure SetText(const Value: WideString); override;
    function  CreateParameterRow(): TDBXRow; override;
    function  GetParameters: TDBXParameterList; override;
    procedure CreateParameters(Command: TDBXCommand); override;

    procedure SetMaxBlobSize(const MaxBlobSize: Int64); override;
    procedure SetRowSetSize(const Value: Int64); override;
    procedure DerivedOpen; override;
    procedure DerivedClose; override;

    function  DerivedGetNextReader: TDBXReader; override;
    function  DerivedExecuteQuery: TDBXReader; override;
    procedure DerivedExecuteUpdate; override;
    procedure DerivedPrepare; override;

  public

    constructor Create(DBXContext: TDBXContext; Command: TDBXCommand);
    destructor Destroy; override;

    procedure Prepare; override;
    function  ExecuteQuery: TDBXReader; override;
    procedure ExecuteUpdate; override;
    function  GetNextReader: TDBXReader; override;

  end;

TDBXMorphicCommand = class(TDBXCommand)
  strict protected
    FConnection:      TDBXConnection;
    FCommand:         TDBXCommand;
    FRowSetSize:      Int64;
    FMaxBlobSize:     Int64;

    procedure CopyProperties(Command: TDBXCommand);

  protected
    function  GetRowsAffected: Int64; override;
    procedure SetCommandType(const Value: WideString); override;
    procedure SetText(const Value: WideString); override;
    function  CreateParameterRow(): TDBXRow; override;
    function  GetParameters: TDBXParameterList; override;
    procedure CreateParameters(Command: TDBXCommand); override;

    procedure SetMaxBlobSize(const MaxBlobSize: Int64); override;
    procedure SetRowSetSize(const Value: Int64); override;
    procedure DerivedOpen; override;
    procedure DerivedClose; override;

    function  DerivedGetNextReader: TDBXReader; override;
    function  DerivedExecuteQuery: TDBXReader; override;
    procedure DerivedExecuteUpdate; override;
    procedure DerivedPrepare; override;


  public

    constructor Create(DBXContext: TDBXContext; Connection: TDBXConnection);
    destructor Destroy; override;

    procedure Prepare; override;
    function  ExecuteQuery: TDBXReader; override;
    procedure ExecuteUpdate; override;
    function  GetNextReader: TDBXReader; override;

  end;


  TDBXDelegateParameterList = class(TDBXParameterList)
    strict protected
      FParameterList:        TDBXParameterList;


    protected
      function GetParameterByOrdinal(const Ordinal: TInt32): TDBXParameter; override;
      function GetCount: TInt32; override;

      constructor Create(DBXContext: TDBXContext; Command: TDBXCommand; Parameters: TDBXParameterList);


    public
      destructor  Destroy; override;
      procedure   SetCount(Count: TInt32); override;
      procedure   AddParameter(Parameter: TDBXParameter); override;
      procedure   SetParameter(Ordinal: Integer; Parameter: TDBXParameter); override;
      procedure   InsertParameter(Ordinal: Integer; Parameter: TDBXParameter); override;
      procedure   RemoveParameter(Ordinal: Integer); overload; override;
      procedure   RemoveParameter(Parameter: TDBXParameter); overload; override;
      procedure   ClearParameters; overload; override;
      function    GetOrdinal(const Name: WideString): Integer; override;
  end;

TDBXDelegateParameter = class(TDBXParameterEx)
    strict protected
      FParameter:   TDBXParameter;
    protected
      function  GetValue: TDBXWritableValue; override;

      procedure SetParameter; override;
      procedure SetDbxRow(DbxRow: TDBXRow); override;

      procedure SetParameterDirection(ParameterDirection: TDBXParameterDirection); override;
      procedure SetName(const Name: WideString); override;
      procedure SetOrdinal(Ordinal: TInt32); override;
      procedure SetDataType(DataType: TDBXType); override;
      procedure SetSubType(SubType: TDBXType); override;
      procedure SetPrecision(Precision: Int64); override;
      procedure SetScale(Scale: TInt32); override;
      procedure SetChildPosition(ChildPosition: TInt32); override;
      procedure SetFlags(Flags: TInt32); override;
      procedure SetNullable(NullableValue: Boolean); override;
      procedure SetSize(Size: Int64); override;

      function  GetParameterDirection: TDBXParameterDirection; override;
      function  GetName: WideString; override;
      function  GetOrdinal: TInt32 ; override;
      function  GetDataType: TDBXType; override;
      function  GetSubType: TDBXType; override;
      function  GetPrecision: Int64; override;
      function  GetScale: TInt32; override;
      function  GetChildPosition: TInt32; override;
      function  GetFlags: TInt32; override;
      function  GetSize: Int64; override;

    public
      constructor Create(DbxContext: TDBXContext; Parameter: TDBXParameter);
      destructor  Destroy; override;


end;

TDBXDelegateWritableValue = class(TDBXWritableValue)
    strict protected
      FValue:         TDBXValue;
      FWritableValue: TDBXWritableValue;

    protected
//      constructor Create(ValueType: TDBXValueType; Value: TDBXValue); overload;
      constructor Create(ValueType: TDBXValueType; Value: TDBXWritableValue); overload;
      procedure SetPendingValue; override;

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
//      procedure SetBytes( const Buffer: TBytes;
//                          BufferOffset: Int64;
//                          Length:       Int64); override;
//      procedure SetStream(const Stream: TStream); override;

      destructor Destroy(); override;
end;


  TDBXDelegateReader = class(TDBXReader)
    private
      FReader:  TDBXReader;

    protected
      function  DerivedNext: Boolean; override;
      procedure DerivedClose; override;

      function GetValue(const Ordinal: TInt32): TDBXValue; override;
      function GetValueByName(const Name: WideString): TDBXValue; override;
      function GetValueType(const Ordinal: TInt32): TDBXValueType; override;
      function GetByteReader: TDBXByteReader; override;

      function GetColumnCount: TInt32; override;

  public

      constructor Create(DBXContext: TDBXContext; Reader: TDBXReader);
      destructor Destroy; override;
      function Next: Boolean; override;
      function GetObjectTypeName(Ordinal: TInt32): WideString; override;
      function GetOrdinal(const Name: WideString): TInt32; override;

  end;


{
  TDBXDelegateByteReader = class
    private
      FByteReader:  TDBXByteReader;
      FReader:        TDBXReader;

    public
      procedure GetString(Ordinal: TInt32; Value: TPointer; var IsNull: LongBool); override;
      procedure GetWideString(Ordinal: TInt32; Value: TPointer; var IsNull: LongBool); override;
      procedure GetInt16(Ordinal: TInt32; Value: TPointer; var IsNull: LongBool); override;
      procedure GetInt32(Ordinal: TInt32; Value: TPointer; var IsNull: LongBool); override;
      procedure GetInt64(Ordinal: TInt32; Value: TPointer; var IsNull: LongBool); override;
      procedure GetDouble(Ordinal: TInt32; Value: TPointer; var IsNull: LongBool); override;
      procedure GetBcd(Ordinal: TInt32; Value: TPointer; var IsNull: LongBool); override;
      procedure GetTimeStamp(Ordinal: TInt32; Value: TPointer; var IsNull: LongBool); override;
      procedure GetTime(Ordinal: TInt32; Value: TPointer; var IsNull: LongBool); override;
      procedure GetDate(Ordinal: TInt32; Value: TPointer; var IsNull: LongBool); override;
      procedure GetBytes(Ordinal: TInt32; Value: TBytes; var IsNull: LongBool); override;
      procedure GetBlobLength(Ordinal: TInt32; var Length: Int64; var IsNull: LongBool); override;
      procedure GetBlob(Ordinal: TInt32; Offset: Int64; Value: TBytes;
                                 ValueOffset, Length: Int64; var IsNull: LongBool); override;
  end;
}
implementation

type

  TDBXAccessorConnection = class(TDBXConnection)
  end;

  TDBXAccessorConnectionEx = class(TDBXConnectionEx)
  end;

  TDBXAccessorCommand = class(TDBXCommand)
  end;

  TDBXAccessorParameterList = class(TDBXParameterList)
  end;

  TDBXAccessorMetaData = class(TDBXDatabaseMetaData)
  end;

  TDBXAccessorParameter = class(TDBXParameter)
  end;

  TDBXAccessorWritableValue = class(TDBXWritableValue)
  end;

  TDBXAccessorReader = class(TDBXReader)
  end;

{ TDBXDelegateConnection }

procedure TDBXDelegateConnection.Commit(Transaction: TDBXTransaction);
begin
  TDBXAccessorConnection(FConnection).Commit(Transaction);
end;

constructor TDBXDelegateConnection.Create(ConnectionBuilder: TDBXConnectionBuilder; Connection: TDBXConnection);
begin
  inherited Create(ConnectionBuilder);
  FConnection := Connection;
end;



function TDBXDelegateConnection.CreateAndBeginTransaction(
  Isolation: TDBXIsolation): TDBXTransaction;
begin
  Result := TDBXAccessorConnection(FConnection).CreateAndBeginTransaction(Isolation);
end;

function TDBXDelegateConnection.CreateMorphCommand(
  MorphicCommand: TDBXCommand): TDBXCommand;
var
  Temp: TDBXConnectionEx;
begin
  Result := inherited CreateMorphCommand(MorphicCommand);
  if Result = nil then
  begin
    if FConnection is TDBXConnectionEx then
    begin
        Temp := TDBXConnectionEx(FConnection);
        Result := TDBXAccessorConnectionEx(Temp).CreateMorphCommand(MorphicCommand);
    end;
  end
end;

function TDBXDelegateConnection.CreateCommand: TDBXCommand;
begin
  Result := FConnection.CreateCommand;
end;


destructor TDBXDelegateConnection.Destroy;
begin
  FreeAndNil(FConnection);
  inherited;
  Assert(FDBXContext = nil);
end;



procedure TDBXDelegateConnection.Open;
begin
  if not FConnection.IsOpen then
  begin
    TDBXAccessorConnection(FConnection).Open;
  end;
end;

procedure TDBXDelegateConnection.Rollback(Transaction: TDBXTransaction);
begin
  TDBXAccessorConnection(FConnection).Rollback(Transaction);
end;

function TDBXDelegateConnection.GetDatabaseMetaData: TDBXDatabaseMetaData;
begin
  Result := FConnection.DatabaseMetaData;
end;

function TDBXDelegateConnection.GetConnectionProperties: TDBXProperties;
begin
  Result := FConnection.ConnectionProperties;
end;

function TDBXDelegateConnection.GetErrorEvent: TDBXErrorEvent;
begin
  Result := inherited GetErrorEvent;
end;

function TDBXDelegateConnection.GetIsOpen: Boolean;
begin
  Result := FConnection.IsOpen;
end;

function TDBXDelegateConnection.GetProductName: WideString;
begin
  Result := TDBXConnectionEx(FConnection).ProductName;
end;

function TDBXDelegateConnection.GetProductVersion: WideString;
begin
  Result := TDBXConnectionEx(FConnection).ProductVersion;
end;

procedure TDBXDelegateConnection.SetConnectionProperties(
  const Value: TDBXProperties);
begin
  FConnection.ConnectionProperties := Value;
end;

procedure TDBXDelegateConnection.SetErrorEvent(ErrorEvent: TDBXErrorEvent);
begin
  TDBXAccessorConnection(FConnection).SetErrorEvent(ErrorEvent);
  inherited SetErrorevent(ErrorEvent);

end;

function TDBXDelegateConnection.GetTraceInfoEvent: TDBXTraceEvent;
begin
  Result := FConnection.OnTrace;
end;

function TDBXDelegateConnection.GetVendorProperty(const Name: WideString): WideString;
begin
  Result := TDBXConnectionEx(FConnection).GetVendorProperty(Name);
end;

function TDBXDelegateConnection.DerivedCreateCommand: TDBXCommand;
begin
  Result := TDBXAccessorConnection(FConnection).DerivedCreateCommand;
end;

procedure TDBXDelegateConnection.DerivedGetCommands(CommandType: WideString;
  List: TWideStrings);
begin
  TDBXAccessorConnection(FConnection).DerivedGetCommands(CommandType, List);
end;

procedure TDBXDelegateConnection.DerivedGetCommandTypes(List: TWideStrings);
begin
  TDBXAccessorConnection(FConnection).DerivedGetCommandTypes(List);
end;

procedure TDBXDelegateConnection.DerivedOpen;
begin
  TDBXAccessorConnection(FConnection).DerivedOpen;
end;

procedure TDBXDelegateConnection.SetTraceInfoEvent(
  TraceInfoEvent: TDBXTraceEvent);
begin
  if Assigned(TraceInfoEvent) then
    FConnection.OnTrace := TraceInfoEvent;
end;

{ TDBXDelegateCommand }


procedure TDBXDelegateCommand.DerivedOpen;
begin
  TDBXAccessorCommand(FCommand).DerivedOpen;
end;

procedure TDBXDelegateCommand.DerivedClose;
begin
  TDBXAccessorCommand(FCommand).DerivedClose;
end;

constructor TDBXDelegateCommand.Create(DBXContext: TDBXContext; Command: TDBXCommand);
begin
  inherited Create(DBXContext);
  FCommand := Command;
end;


procedure TDBXDelegateCommand.CreateParameters(Command: TDBXCommand);
begin
  TDBXAccessorCommand(FCommand).CreateParameters(Command);
end;


destructor TDBXDelegateCommand.Destroy;
begin
  FreeAndNil(FCommand);
  inherited;
end;

function TDBXDelegateCommand.ExecuteQuery: TDBXReader;
begin
  Result := FCommand.ExecuteQuery;
end;

procedure TDBXDelegateCommand.ExecuteUpdate;
begin
  FCommand.ExecuteUpdate;
end;

function TDBXDelegateCommand.GetParameters: TDBXParameterList;
begin
  Result := TDBXAccessorCommand(FCommand).GetParameters;
end;

function TDBXDelegateCommand.CreateParameterRow: TDBXRow;
begin
  Result := TDBXAccessorCommand(FCommand).CreateParameterRow;
end;

function TDBXDelegateCommand.GetRowsAffected: Int64;
begin
  Result := FCommand.RowsAffected;
end;

function TDBXDelegateCommand.GetText: WideString;
begin
  Result := FCommand.Text;
end;

function TDBXDelegateCommand.GetNextReader: TDBXReader;
begin
  Result := FCommand.GetNextReader;
end;

procedure TDBXDelegateCommand.Prepare;
begin
  FCommand.Prepare;
end;


function TDBXDelegateCommand.DerivedExecuteQuery: TDBXReader;
begin
  Result := TDBXAccessorCommand(FCommand).DerivedExecuteQuery;
end;

procedure TDBXDelegateCommand.DerivedExecuteUpdate;
begin
  TDBXAccessorCommand(FCommand).DerivedExecuteUpdate;
end;

function TDBXDelegateCommand.DerivedGetNextReader: TDBXReader;
begin
  Result := TDBXAccessorCommand(FCommand).DerivedGetNextReader;
end;

procedure TDBXDelegateCommand.DerivedPrepare;
begin
  TDBXAccessorCommand(FCommand).DerivedPrepare;
end;

procedure TDBXDelegateCommand.SetMaxBlobSize(const MaxBlobSize: Int64);
begin
  FCommand.MaxBlobSize  := MaxBlobSize;
end;

procedure TDBXDelegateCommand.SetRowSetSize(const Value: Int64);
begin
  FCommand.RowSetSize := Value;
end;

procedure TDBXDelegateCommand.SetCommandType(const Value: WideString);
begin
  Close;
  FCommand.CommandType := Value;
end;

procedure TDBXDelegateCommand.SetText(const Value: WideString);
begin
  Close;
  FCommand.Text := Value;
end;


{ TDBXDelegateParameters }


procedure TDBXDelegateParameterList.SetCount(Count: TInt32);
begin
  FParameterList.SetCount(Count);
end;

procedure TDBXDelegateParameterList.AddParameter(Parameter: TDBXParameter);
begin
  FParameterList.AddParameter(Parameter);

end;

procedure TDBXDelegateParameterList.ClearParameters;
begin
  FParameterList.ClearParameters;

end;

procedure TDBXDelegateParameterList.SetParameter(Ordinal: Integer;
  Parameter: TDBXParameter);
begin
  FParameterList.SetParameter(Ordinal, Parameter);

end;

constructor TDBXDelegateParameterList.Create(DBXContext: TDBXContext;
  Command: TDBXCommand; Parameters: TDBXParameterList);
begin
  inherited Create(DBXContext, Command);
  FParameterList := Parameters;
end;

destructor TDBXDelegateParameterList.Destroy;
begin
  inherited;
end;

function TDBXDelegateParameterList.GetCount: TInt32;
begin
  Result := TDBXAccessorParameterList(FParameterList).GetCount;
end;

function TDBXDelegateParameterList.GetOrdinal(const Name: WideString): Integer;
begin
  Result := FParameterList.GetOrdinal(Name);
end;

function TDBXDelegateParameterList.GetParameterByOrdinal(
  const Ordinal: TInt32): TDBXParameter;
begin
  Result := TDBXAccessorParameterList(FParameterList).GetParameterByOrdinal(Ordinal);
end;

procedure TDBXDelegateParameterList.InsertParameter(Ordinal: Integer;
  Parameter: TDBXParameter);
begin
  FParameterList.InsertParameter(Ordinal, Parameter);

end;

procedure TDBXDelegateParameterList.RemoveParameter(Parameter: TDBXParameter);
begin
  FParameterList.RemoveParameter(Parameter);

end;

procedure TDBXDelegateParameterList.RemoveParameter(Ordinal: Integer);
begin
  FParameterList.RemoveParameter(Ordinal);

end;

{ TDBXDelegateReader }

constructor TDBXDelegateReader.Create(DBXContext: TDBXContext;
  Reader: TDBXReader);
begin
  inherited Create(DBXContext, nil, nil);
  FReader := Reader;
end;

procedure TDBXDelegateReader.DerivedClose;
begin
  TDBXAccessorReader(FReader).DerivedClose;
end;

function TDBXDelegateReader.DerivedNext: Boolean;
begin
  Result := Freader.Next;

end;

destructor TDBXDelegateReader.Destroy;
begin
  FreeAndNil(FReader);
  inherited;
end;


function TDBXDelegateReader.GetByteReader: TDBXByteReader;
begin
  Result := TDBXAccessorReader(FReader).GetByteReader;
end;

function TDBXDelegateReader.GetColumnCount: TInt32;
begin
  Result := TDBXAccessorReader(FReader).GetColumnCount;
end;

function TDBXDelegateReader.GetObjectTypeName(Ordinal: TInt32): WideString;
begin
  Result := FReader.GetObjectTypeName(Ordinal);
end;

function TDBXDelegateReader.GetOrdinal(const Name: WideString): TInt32;
begin
  Result := TDBXAccessorReader(FReader).GetOrdinal(Name);
end;

function TDBXDelegateReader.GetValue(const Ordinal: TInt32): TDBXValue;
begin
  Result := TDBXAccessorReader(FReader).GetValue(Ordinal);
end;

function TDBXDelegateReader.GetValueByName(const Name: WideString): TDBXValue;
begin
  Result := TDBXAccessorReader(FReader).GetValueByName(Name);
end;

function TDBXDelegateReader.GetValueType(const Ordinal: TInt32): TDBXValueType;
begin
  Result := TDBXAccessorReader(FReader).GetValueType(Ordinal);
end;

function TDBXDelegateReader.Next: Boolean;
begin
  Result := FReader.Next;
end;


{ TDBXDelegateWritableValue }

constructor TDBXDelegateWritableValue.Create(ValueType: TDBXValueType; Value: TDBXWritableValue);
begin
  inherited Create(ValueType);
  FValue := Value;
  FWritableValue := Value;
end;

destructor TDBXDelegateWritableValue.Destroy;
begin
  // These are not owned by this object, so don't free them.
  //
  FValue := nil;
  FWritableValue := nil;
  inherited;
end;

function TDBXDelegateWritableValue.GetBcd: TBcd;
begin
  Result := FValue.GetBcd;
end;

function TDBXDelegateWritableValue.GetBoolean: Boolean;
begin
  Result := FValue.GetBoolean;
end;

function TDBXDelegateWritableValue.GetBytes(Offset: Int64;
  const Buffer: TBytes; BufferOffset, Length: Int64): Int64;
begin
  Result := FValue.GetBytes(Offset, Buffer, BufferOffset, Length);
end;

function TDBXDelegateWritableValue.GetDate: TDBXDate;
begin
  Result := FValue.GetDate;
end;

function TDBXDelegateWritableValue.GetDouble: Double;
begin
  Result := FValue.GetDouble;
end;

function TDBXDelegateWritableValue.GetInt16: SmallInt;
begin
  Result := FValue.GetInt16;
end;

function TDBXDelegateWritableValue.GetInt32: TInt32;
begin
  Result := FValue.GetInt32;
end;

function TDBXDelegateWritableValue.GetInt64: Int64;
begin
  Result := FValue.GetInt64;
end;

function TDBXDelegateWritableValue.GetAnsiString: String;
begin
  Result := FValue.GetAnsiString;
end;

function TDBXDelegateWritableValue.GetTime: TDBXTime;
begin
  Result := FValue.GetTime;
end;

function TDBXDelegateWritableValue.GetTimeStamp: TSQLTimeStamp;
begin
  Result := FValue.GetTimeStamp;
end;

function TDBXDelegateWritableValue.GetValueSize: Int64;
begin
  Result := FValue.GetValueSize;
end;

function TDBXDelegateWritableValue.GetWideString: WideString;
begin
  Result := FValue.GetWideString;
end;

function TDBXDelegateWritableValue.IsNull: Boolean;
begin
  Result := FValue.IsNull;
end;

procedure TDBXDelegateWritableValue.SetBcd(const Value: TBcd);
begin
  FWritableValue.SetBcd(Value);
end;

procedure TDBXDelegateWritableValue.SetBoolean(Value: Boolean);
begin
  FWritableValue.SetBoolean(Value);
end;

//procedure TDBXDelegateWritableValue.SetBytes(const Buffer: TBytes; BufferOffset,
//  Length: Int64);
//begin
//  FWritableValue.SetBytes(Buffer, BufferOffset, Length);
//
//end;

procedure TDBXDelegateWritableValue.SetDate(Value: TDBXDate);
begin
  FWritableValue.SetDate(Value);

end;

procedure TDBXDelegateWritableValue.SetDouble(Value: Double);
begin
  FWritableValue.SetDouble(Value);

end;

procedure TDBXDelegateWritableValue.SetDynamicBytes(Offset: Int64;
  const Buffer: TBytes; BufferOffset, Length: Int64);
begin
  FWritableValue.SetDynamicBytes(Offset, Buffer, BufferOffset, Length);

end;

procedure TDBXDelegateWritableValue.SetInt16(Value: SmallInt);
begin
  FWritableValue.SetInt16(Value);

end;

procedure TDBXDelegateWritableValue.SetInt32(Value: TInt32);
begin
  FWritableValue.SetInt32(Value);

end;

procedure TDBXDelegateWritableValue.SetInt64(Value: Int64);
begin
  FWritableValue.SetInt64(Value);

end;

procedure TDBXDelegateWritableValue.SetNull;
begin
  FWritableValue.SetNull;

end;

procedure TDBXDelegateWritableValue.SetPendingValue;
begin
  TDBXAccessorWritableValue(FWritableValue).SetPendingValue;
end;

procedure TDBXDelegateWritableValue.SetStaticBytes(Offset: Int64;
  const Buffer: array of Byte; BufferOffset, Length: Int64);
begin
  FWritableValue.SetStaticBytes(Offset, Buffer, BufferOffset, Length);

end;

//procedure TDBXDelegateWritableValue.SetStream(const Stream: TStream);
//begin
//  FWritableValue.SetStream(Stream);
//end;

procedure TDBXDelegateWritableValue.SetAnsiString(const Value: String);
begin
  FWritableValue.SetAnsiString(Value);

end;

procedure TDBXDelegateWritableValue.SetTime(Value: TDBXTime);
begin
  FWritableValue.SetTime(Value);

end;

procedure TDBXDelegateWritableValue.SetTimeStamp(const Value: TSQLTimeStamp);
begin
  FWritableValue.SetTimeStamp(Value);

end;

procedure TDBXDelegateWritableValue.SetWideString(const Value: WideString);
begin
  FWritableValue.SetWideString(Value);

end;


constructor TDBXDelegateParameter.Create(DbxContext: TDBXContext; Parameter: TDBXParameter);
begin
  FParameter := Parameter;
  inherited Create(DbxContext);
  // TODO:  Change TDBXParameter.Name property to read from virtual TDBXParameter.GetName
  // method so we don't need to copy this.  Can't break the unit interface in
  // this release.
  //
  Name := Parameter.Name;
end;

destructor TDBXDelegateParameter.Destroy;
begin
  FreeAndNil(FParameter);
  inherited;
end;


function TDBXDelegateParameter.GetChildPosition: TInt32;
begin
  Result := TDBXAccessorParameter(FParameter).GetChildPosition;
end;

function TDBXDelegateParameter.GetDataType: TDBXType;
begin
  Result := TDBXAccessorParameter(FParameter).GetDataType;
end;

function TDBXDelegateParameter.GetFlags: TInt32;
begin
  Result := TDBXAccessorParameter(FParameter).GetFlags;
end;

function TDBXDelegateParameter.GetName: WideString;
begin
  Result := TDBXAccessorParameter(FParameter).GetName;
end;

function TDBXDelegateParameter.GetOrdinal: TInt32;
begin
  Result := TDBXAccessorParameter(FParameter).GetOrdinal;
end;

function TDBXDelegateParameter.GetParameterDirection: TDBXParameterDirection;
begin
  Result := TDBXAccessorParameter(FParameter).GetParameterDirection;
end;

function TDBXDelegateParameter.GetPrecision: Int64;
begin
  Result := TDBXAccessorParameter(FParameter).GetPrecision;
end;

function TDBXDelegateParameter.GetScale: TInt32;
begin
  Result := TDBXAccessorParameter(FParameter).GetScale;
end;

function TDBXDelegateParameter.GetSize: Int64;
begin
  Result := TDBXAccessorParameter(FParameter).GetSize;
end;

function TDBXDelegateParameter.GetSubType: TDBXType;
begin
  Result := TDBXAccessorParameter(FParameter).GetSubType;
end;

function TDBXDelegateParameter.GetValue: TDBXWritableValue;
begin
  Result := FParameter.Value;
end;

procedure TDBXDelegateParameter.SetChildPosition(ChildPosition: TInt32);
begin
  TDBXAccessorParameter(FParameter).SetChildPosition(ChildPosition);
end;

procedure TDBXDelegateParameter.SetDataType(DataType: TDBXType);
begin
  TDBXAccessorParameter(FParameter).SetDataType(DataType);
end;


procedure TDBXDelegateParameter.SetDbxRow(DbxRow: TDBXRow);
begin
  TDBXAccessorParameter(FParameter).SetDbxRow(DbxRow);
end;

procedure TDBXDelegateParameter.SetFlags(Flags: TInt32);
begin
  TDBXAccessorParameter(FParameter).SetFlags(Flags);
end;

procedure TDBXDelegateParameter.SetName(const Name: WideString);
begin
  inherited SetName(Name);
  TDBXAccessorParameter(FParameter).SetName(Name);
end;

procedure TDBXDelegateParameter.SetNullable(NullableValue: Boolean);
begin
  TDBXAccessorParameter(FParameter).SetNullable(NullableValue);
end;

procedure TDBXDelegateParameter.SetOrdinal(Ordinal: TInt32);
begin
  TDBXAccessorParameter(FParameter).SetOrdinal(Ordinal);
end;

procedure TDBXDelegateParameter.SetParameter;
begin
    TDBXAccessorParameter(FParameter).SetParameter;
end;

procedure TDBXDelegateParameter.SetParameterDirection(
  ParameterDirection: TDBXParameterDirection);
begin
  TDBXAccessorParameter(FParameter).SetParameterDirection(ParameterDirection);
end;

procedure TDBXDelegateParameter.SetPrecision(Precision: Int64);
begin
  TDBXAccessorParameter(FParameter).SetPrecision(Precision);
end;

procedure TDBXDelegateParameter.SetScale(Scale: TInt32);
begin
  TDBXAccessorParameter(FParameter).SetScale(Scale);
end;

procedure TDBXDelegateParameter.SetSize(Size: Int64);
begin
  TDBXAccessorParameter(FParameter).SetSize(Size);
end;

procedure TDBXDelegateParameter.SetSubType(SubType: TDBXType);
begin
  TDBXAccessorParameter(FParameter).SetSubType(SubType);
end;


{ TDBXMorphicCommand }

constructor TDBXMorphicCommand.Create(DBXContext: TDBXContext; Connection: TDBXConnection);
begin
  inherited Create(DBXContext);
  FConnection  := Connection;
  FRowSetSize  := DBXDefaultRowSetSize;
  FMaxBlobSize := -1;
end;

procedure TDBXMorphicCommand.CreateParameters(Command: TDBXCommand);
begin
  TDBXAccessorCommand(FCommand).CreateParameters(Command);
end;


destructor TDBXMorphicCommand.Destroy;
begin
  FreeAndNil(FCommand);
  inherited;
end;


function TDBXMorphicCommand.ExecuteQuery: TDBXReader;
begin
  Open;
  Result := FCommand.ExecuteQuery;
end;

procedure TDBXMorphicCommand.ExecuteUpdate;
begin
  Open;
  FCommand.ExecuteUpdate;
end;

function TDBXMorphicCommand.GetParameters: TDBXParameterList;
begin
  Open;
  Result := TDBXAccessorCommand(FCommand).GetParameters;
end;

function TDBXMorphicCommand.CreateParameterRow: TDBXRow;
begin
  Result := TDBXAccessorCommand(FCommand).CreateParameterRow;
end;

function TDBXMorphicCommand.GetRowsAffected: Int64;
begin
  Result := FCommand.RowsAffected;
end;

procedure TDBXMorphicCommand.Prepare;
begin
  Open;
  FCommand.Prepare;
end;

function TDBXMorphicCommand.GetNextReader: TDBXReader;
begin
  Result := FCommand.GetNextReader;
end;


procedure TDBXMorphicCommand.DerivedClose;
begin
  if FCommand <> nil then
    TDBXAccessorCommand(FCommand).DerivedClose;
  FCommand := nil;
end;

function TDBXMorphicCommand.DerivedExecuteQuery: TDBXReader;
begin
  Result := TDBXAccessorCommand(FCommand).DerivedExecuteQuery;
end;

procedure TDBXMorphicCommand.DerivedExecuteUpdate;
begin
  TDBXAccessorCommand(FCommand).DerivedExecuteUpdate;
end;

function TDBXMorphicCommand.DerivedGetNextReader: TDBXReader;
begin
  Result := TDBXAccessorCommand(FCommand).DerivedGetNextReader;
end;

procedure TDBXMorphicCommand.DerivedOpen;
var
  Temp: TDBXConnectionEx;
begin
  if (FCommand = nil) and (FConnection is TDBXConnectionEx) then
  begin
    Temp := TDBXConnectionEx(FConnection);
    FCommand := TDBXAccessorConnectionEx(Temp).CreateMorphCommand(Self);
    CopyProperties(FCommand);
  end else
    TDBXAccessorCommand(FCommand).DerivedOpen;
end;

procedure TDBXMorphicCommand.DerivedPrepare;
begin
  TDBXAccessorCommand(FCommand).DerivedPrepare;
end;

procedure TDBXMorphicCommand.SetMaxBlobSize(const MaxBlobSize: Int64);
begin
  FMaxBlobSize := MaxBlobSize;
  if FCommand <> nil then
    FCommand.MaxBlobSize  := MaxBlobSize;
end;

procedure TDBXMorphicCommand.SetRowSetSize(const Value: Int64);
begin
  FRowSetSize := Value;
  if FCommand <> nil then  
    FCommand.RowSetSize := Value;
end;

procedure TDBXMorphicCommand.SetCommandType(const Value: WideString);
begin
  if Value <> GetCommandType then
  begin
    FreeAndNil(FCommand);
    inherited SetCommandType(Value);
  end;
end;

procedure TDBXMorphicCommand.SetText(const Value: WideString);
begin
  inherited SetText(Value);
  if FCommand <> nil then
    FCommand.Text := Value;
end;

procedure TDBXMorphicCommand.CopyProperties(Command: TDBXCommand);
begin
  Command.Text := Text;
  Command.CommandType := CommandType;
  if FMaxBlobSize > -1 then
    Command.MaxBlobSize := FMaxBlobSize;
  if FRowSetSize <> DBXDefaultRowSetSize then
    Command.RowSetSize := FRowSetSize;
  TDBXAccessorCommand(FCommand).Open;
end;

end.
