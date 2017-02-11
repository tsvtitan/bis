unit DBXMetaDataCommandFactory;
interface
uses
  ClassRegistry,
  DBXCommon,
  DBXPlatformUtil,
  DBXSqlScanner,
  DBXTableStorage,
  DBXMetaDataReader;

type
  TDBXMetaDataCommandFactory = class(TDBXCommandFactory)
  public
    class procedure RegisterMetaDataCommandFactory(const ObjectClass: TClass); static;
    function CreateCommand(DbxContext: TDBXContext; Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand; override;
    function CreateMetaDataReader: TDBXMetaDataReader; virtual; abstract;
  end;

  TDBXDataExpressProviderContext = class(TDBXProviderContext)
  protected
    FConnection: TDBXConnection;
    FScanner: TDBXSqlScanner;
    FParameterMarker: WideString;
    FMarkerIncludedInParameterName: Boolean;
    FUseAnsiStrings: Boolean;
    FRemoveIsNull: Boolean;
  private
//  procedure BindParametersByName(Command: TDBXCommand; ParameterNames: TDBXWideStringArray; ParameterValues: TDBXWideStringArray);
    procedure BindParametersByOrdinal(Command: TDBXCommand; ParameterNames: TDBXWideStringArray; ParameterValues: TDBXWideStringArray);
    function FindParameterByName(const ParameterName: WideString; ParameterNames: TDBXWideStringArray): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function GetPlatformTypeName(const DataType: Integer; const IsUnsigned: Boolean): WideString; override;
    function ExecuteQuery(const Sql: WideString; const ParameterNames: TDBXWideStringArray; const ParameterValues: TDBXWideStringArray): TDBXTableStorage; override;
    function CreateTableStorage(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray): TDBXTableStorage; override;
    function CreateRowStorage(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray): TDBXRowStorage; override;
    procedure StartTransaction; override;
    procedure StartSerializedTransaction; override;
    procedure Commit; override;
    procedure Rollback; override;
    function GetVendorProperty(const name: WideString): WideString; override;
  protected
    function GetSqlParameterMarker: WideString;
    function GetMarkerIncludedInParameterName: Boolean;
  public
    property SqlParameterMarker: WideString read FParameterMarker;
    property IsMarkerIncludedInParameterName: Boolean read FMarkerIncludedInParameterName;
    property Connection: TDBXConnection write FConnection;
    property UseAnsiStrings: Boolean read FUseAnsiStrings write FUseAnsiStrings;
    property RemoveIsNull: Boolean read FRemoveIsNull write FRemoveIsNull;
  end;

implementation
uses
  SysUtils,
  DBXReaderTableStorage,
  DBXMetaDataCommand;

const
  BlackfishSQLProduct = 'BlackfishSQL';          { Do not localize }
  InterbaseProduct = 'InterBase';                { Do not localize }
  FirebirdProduct = 'Firebird';                { Do not localize }
  OracleProduct    = 'Oracle';                   { Do not localize }
  SybaseASEProduct = 'Sybase SQL Server';        { Do not localize }
  SybaseASAProduct = 'Adaptive Server Anywhere'; { Do not localize }
  Db2Product       = 'Db2';                      { Do not localize }
  InformixProduct  = 'Informix Dynamic Server';  { Do not localize }

resourcestring
  SUnknownDataType = 'Unknown Data Type';


class procedure TDBXMetaDataCommandFactory.RegisterMetaDataCommandFactory(const ObjectClass: TClass);
var
  ClassRegistry: TClassRegistry;
  ClassName: String;
begin
{$IFDEF CLR}
  ClassName := 'Borland.Data.' + ObjectClass.ClassName;  { Do not resource }
{$ELSE}
  ClassName := ObjectClass.ClassName;
{$ENDIF}
  ClassRegistry := TClassRegistry.GetClassRegistry;
  ClassRegistry.RegisterClass(ClassName, ObjectClass);
end;

function TDBXMetaDataCommandFactory.CreateCommand(DbxContext: TDBXContext;
  Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand;
var
  Reader: TDBXMetaDataReader;
  ProviderContext: TDBXDataExpressProviderContext;
  ConnectionEx: TDBXConnectionEx;
begin
  ConnectionEx := TDBXConnectionEx(Connection);
  Reader := TDBXMetaDataReader(ConnectionEx.MetaDataReader);
  if Reader = nil then
  begin
    Reader := CreateMetaDataReader;
    ProviderContext := TDBXDataExpressProviderContext.Create;
    ProviderContext.Connection := Connection;
    ProviderContext.UseAnsiStrings := (Reader.ProductName <> BlackfishSQLProduct); // (Reader.ProductName = InterbaseProduct) or (Reader.ProductName = OracleProduct) or (Reader.ProductName = SybaseASAProduct) or (Reader.ProductName = SybaseASEProduct) or (Reader.ProductName = Db2Product) or (Reader.ProductName = InformixProduct);
    if Reader.ProductName <> BlackfishSQLProduct then
      ProviderContext.RemoveIsNull := True; // (Reader.ProductName = InterbaseProduct) or (Reader.ProductName = SybaseASEProduct);
    Reader.Context := ProviderContext;
    Reader.Version := TDBXConnectionEx(Connection).ProductVersion;
    ConnectionEx.MetaDataReader := Reader;
  end;
  Result := TDBXMetaDataCommand.Create(DBXContext, MorphicCommand, Reader);
end;

constructor TDBXDataExpressProviderContext.Create;
begin
  inherited Create;
end;

destructor TDBXDataExpressProviderContext.Destroy;
begin
  FreeAndNil(FScanner);
  inherited Destroy;
end;

function TDBXDataExpressProviderContext.GetPlatformTypeName(const DataType: Integer; const IsUnsigned: Boolean): WideString;
begin
  case DataType of
    TDBXDataTypesEx.Uint8Type,
    TDBXDataTypesEx.Int8Type:
      Result := 'Byte';
    TDBXDataTypes.UInt16Type,
    TDBXDataTypes.Int16Type:
      Result := 'SmallInt';
    TDBXDataTypes.UInt32Type,
    TDBXDataTypes.Int32Type:
      Result := 'TInt32';
    TDBXDataTypes.UInt64Type,
    TDBXDataTypes.Int64Type:
      Result := 'Int64';
    TDBXDataTypes.BooleanType:
      Result := 'Boolean';
    TDBXDataTypes.DateType:
      Result := 'TDBXDate';
    TDBXDataTypes.TimeType:
      Result := 'TDBXTime';
    TDBXDataTypes.TimeStampType:
      Result := 'TSQLTimeStamp';
    TDBXDataTypesEx.IntervalType:
      Result := 'TSQLTimeStamp';
    TDBXDataTypes.WideStringType:
      Result := 'WideString';
    TDBXDataTypes.AnsiStringType:
      Result := 'AnsiString';
    TDBXDataTypes.BcdType:
      Result := 'TBcd';
    TDBXDataTypesEx.SingleType:
      Result := 'Single';
    TDBXDataTypes.DoubleType:
      Result := 'Double';
    TDBXDataTypes.BytesType,
    TDBXDataTypes.VarBytesType:
      Result := 'TBytes';
    TDBXDataTypesEx.ObjectType:
      Result := 'TObject';
    else
      raise Exception.Create(SUnknownDataType);
  end;
end;

function TDBXDataExpressProviderContext.GetSqlParameterMarker: WideString;
begin
  Result := FParameterMarker;
end;

function TDBXDataExpressProviderContext.GetMarkerIncludedInParameterName: Boolean;
begin
  Result := FMarkerIncludedInParameterName;
end;

function TDBXDataExpressProviderContext.ExecuteQuery(const Sql: WideString; const ParameterNames: TDBXWideStringArray; const ParameterValues: TDBXWideStringArray): TDBXTableStorage;
var
  Reader: TDBXReader;
  Command: TDBXCommand;
begin
  Command := FConnection.CreateCommand;
  Command.Text := Sql;
  try
    if ParameterValues <> nil then
    begin
      BindParametersByOrdinal(Command, ParameterNames, ParameterValues);
    end;
    Reader := Command.ExecuteQuery;
    Result := TDBXReaderTableStorage.Create(Command,Reader);
    Command := nil;
  finally
    FreeAndNil(Command);
  end;
end;

function TDBXDataExpressProviderContext.CreateTableStorage(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray): TDBXTableStorage;
begin
  Result := nil;
end;

function TDBXDataExpressProviderContext.CreateRowStorage(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray): TDBXRowStorage;
begin
  Result := nil;
end;

procedure TDBXDataExpressProviderContext.StartTransaction;
begin
end;

procedure TDBXDataExpressProviderContext.StartSerializedTransaction;
begin
end;

procedure TDBXDataExpressProviderContext.Commit;
begin
end;

procedure TDBXDataExpressProviderContext.Rollback;
begin
end;

function TDBXDataExpressProviderContext.GetVendorProperty(const name: WideString): WideString;
var
  ConnectionEx: TDBXConnectionEx;
begin
  Result := 'false';
  ConnectionEx := nil;
  if FConnection is TDBXConnectionEx then
    ConnectionEx := TDBXConnectionEx(FConnection);
  if ConnectionEx <> nil then
    Result := ConnectionEx.GetVendorProperty(name);
end;

{
procedure TDBXDataExpressProviderContext.BindParametersByName(Command: TDBXCommand; ParameterNames: TDBXWideStringArray; ParameterValues: TDBXWideStringArray);
var
  Parameters: TDBXParameterList;
  Parameter: TDBXParameter;
  Index: Integer;
begin
  Parameters := Command.Parameters;
  for Index := Low(ParameterValues) to High(ParameterValues) do
  begin
    Parameter := Command.CreateParameter;
    Parameter.DataType := TDBXDataTypes.WideStringType;
    Parameter.Name := ParameterNames[Index];
    if ParameterValues[Index] = NullString then
      Parameter.Value.SetNull
    else
      Parameter.Value.SetWideString(ParameterValues[Index]);
    Parameters.AddParameter(Parameter);
  end;
end;
}

procedure TDBXDataExpressProviderContext.BindParametersByOrdinal(Command: TDBXCommand; ParameterNames: TDBXWideStringArray; ParameterValues: TDBXWideStringArray);
const
  KeywordIS = 'IS';      { Do not localize }
  KeywordNULL = 'NULL';  { Do not localize }
  SqlTrueValue = '1=1';  { Do not localize }
  SqlFalseValue = '1=2'; { Do not localize }
  DummyValue = 'A';      { Do not localize }
  TokenIS = 1;
  TokenNULL = 2;
var
  Token: Integer;
  StartPos: Integer;
  EndPos: Integer;
  ParameterIndex: Integer;
  Parameters: TDBXParameterList;
  Parameter: TDBXParameter;
  Buffer: TDBXWideStringBuffer;
  Params: array of Integer;
  Count: Integer;
  Index: Integer;
  NullWasRemoved: Boolean;
begin
  Count := 0;
  StartPos := 1;
  Buffer := nil;
  if FScanner = nil then
  begin
    FScanner := TDBXSqlScanner.Create('','','');
    FScanner.RegisterId(KeywordIS, TokenIS);
    FScanner.RegisterId(KeywordNULL, TokenNULL);
  end;
  FScanner.Init(Command.Text);
  Token := FScanner.NextToken;
  while Token <> TDBXSqlScanner.TokenEos do
  begin
    if (Token <> TDBXSqlScanner.TokenSymbol) or (FScanner.Symbol <> ':') then
      Token := FScanner.NextToken
    else
    begin
      EndPos := FScanner.NextIndex;
      Token := FScanner.NextToken;
      if Token = TDBXSqlScanner.TokenId then
      begin
        if Buffer = nil then
        begin
          Buffer := TDBXWideStringBuffer.Create(Length(Command.Text));
          SetLength(Params,Length(ParameterNames)*3);
        end;
        Buffer.Append(Copy(Command.Text,StartPos,EndPos-StartPos));
        StartPos := FScanner.NextIndex+1;
        ParameterIndex := FindParameterByName(FScanner.Id, ParameterNames);

        NullWasRemoved := false;
        if RemoveIsNull then
        begin
          if (FScanner.LookAtNextToken = TokenIS) then
          begin
            FScanner.NextToken;
            if FScanner.LookAtNextToken = TokenNull then
            begin
              FScanner.NextToken;
              StartPos := FScanner.NextIndex+1;
              NullWasRemoved := true;
              if ParameterValues[ParameterIndex] = NullString then
                Buffer.Append(SqlTrueValue)
              else
                Buffer.Append(SqlFalseValue)
            end;
          end;
        end;

        if not NullWasRemoved then
        begin
          Buffer.Append('?');

          if Length(Params) <= Count then
            SetLength(Params, Count+2);
          Params[Count] := ParameterIndex;
          Inc(Count);
        end;
      end;
    end;
  end;
  if Buffer <> nil then
  begin
    Buffer.Append(Copy(Command.Text,StartPos,Length(Command.Text)-StartPos+1));
    Command.Text := Buffer.ToString;
    Parameters := Command.Parameters;
    Parameters.ClearParameters;
    for Index := 0 to Count - 1 do
    begin
      ParameterIndex := Params[Index];
      Parameter := Command.CreateParameter;

      if UseAnsiStrings then
        Parameter.DataType := TDBXDataTypes.AnsiStringType
      else
        Parameter.DataType := TDBXDataTypes.WideStringType;

      if RemoveIsNull and (ParameterValues[ParameterIndex] = NullString) then
        ParameterValues[ParameterIndex] := DummyValue;
      if (ParameterValues[ParameterIndex] = NullString) then
        Parameter.Value.SetNull
      else if UseAnsiStrings then
        Parameter.Value.SetAnsiString(ParameterValues[ParameterIndex])
      else
        Parameter.Value.SetWideString(ParameterValues[ParameterIndex]);

      Parameters.AddParameter(Parameter);
    end;
    FreeAndNil(Buffer);
    Params := nil;
  end;
end;

function TDBXDataExpressProviderContext.FindParameterByName(const ParameterName: WideString; ParameterNames: TDBXWideStringArray): Integer;
var
  Index: Integer;
  Found: Boolean;
begin
  Index := High(ParameterNames);
  Found := False;
  while not Found and (Index >= Low(ParameterNames)) do
  begin
    if ParameterNames[Index] = ParameterName then
      Found := True
    else
      Dec(Index);
  end;
  if not Found then
    raise Exception.Create('ParameterName not found: '+ParameterName);
  Result := Index;
end;

end.

