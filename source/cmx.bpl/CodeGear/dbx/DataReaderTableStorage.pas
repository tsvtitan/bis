unit DataReaderTableStorage;
interface
uses
  DBXTableStorage,
  DBXPlatformUtil,
  AbstractTableStorage,
  System.Data;
type
  TDataReaderTableStorage = class(TAbstractTableStorage)
  public
    constructor Create(Command: IDbCommand; Reader: IDataReader);
    procedure BeforeFirst; override;
    function Next: Boolean; override;
    procedure Close; override;
    function GetUnsignedByte(Ordinal: Integer): SmallInt; override;
    function GetInt16(Ordinal: Integer): SmallInt; override;
    function GetInt32(Ordinal: Integer): Integer; override;
    function GetInt64(Ordinal: Integer): Int64; override;
    function GetBoolean(Ordinal: Integer): Boolean; override;
    function GetString(Ordinal: Integer): WideString; override;
    function GetDecimal(Ordinal: Integer): TObject; override;
    function GetObject(Ordinal: Integer): TObject; override;
    function IsNull(Ordinal: Integer): Boolean; override;
  protected
    function GetColumns: TDBXColumnDescriptorArray; override;
    function GetStorage: TObject; override;
  private
    procedure ComputeCharTypes;
  private
    FCommand: IDbCommand;
    FReader: IDataReader;
    FColumns: TDBXColumnDescriptorArray;
    FCharType: TDBXDynamicBooleanArray;
    FNextCalled: Boolean;
  end;

implementation
uses
  SysUtils;

  const CharType = 'CHAR';

constructor TDataReaderTableStorage.Create(Command: IDbCommand; Reader: IDataReader);
begin
  Inherited Create;
  FCommand := Command;
  FReader := Reader;
end;

procedure TDataReaderTableStorage.BeforeFirst;
begin
  if FNextCalled then
    raise Exception.Create(SUnsupportedOperation);
end;

function TDataReaderTableStorage.Next: Boolean;
begin
  FNextCalled := True;
  Result := FReader.Read;
end;

procedure TDataReaderTableStorage.Close;
begin
  if FReader <> nil then
    FReader.Close;
  FReader := nil;
  FreeAndNil(FCommand);
end;

function TDataReaderTableStorage.GetColumns: TDBXColumnDescriptorArray;
var
  Ordinal: Integer;
begin
  if FColumns = nil then
  begin
    SetLength(FColumns, FReader.FieldCount);
    for Ordinal := Low(FColumns) to High(FColumns) do
      FColumns[Ordinal] := TDBXColumnDescriptor.Create(FReader.GetName(Ordinal), nil, ToColumnType(FReader.GetFieldType(Ordinal)));
  end;
  Result := FColumns;
end;

function TDataReaderTableStorage.GetStorage: TObject;
begin
  Result := FReader;
end;

function TDataReaderTableStorage.GetUnsignedByte(Ordinal: Integer): SmallInt;
begin
  Result := FReader.GetByte(Ordinal);
end;

function TDataReaderTableStorage.GetInt16(Ordinal: Integer): SmallInt;
begin
  Result := FReader.GetInt16(Ordinal);
end;

function TDataReaderTableStorage.GetInt32(Ordinal: Integer): Integer;
begin
  Result := FReader.GetInt32(Ordinal);
end;

function TDataReaderTableStorage.GetInt64(Ordinal: Integer): Int64;
begin
  Result := FReader.GetInt64(Ordinal);
end;

function TDataReaderTableStorage.GetBoolean(Ordinal: Integer): Boolean;
begin
  Result := FReader.GetBoolean(Ordinal);
end;

function TDataReaderTableStorage.GetString(Ordinal: Integer): WideString;
begin
  Result := FReader.GetString(Ordinal);
  if FCharType = nil then
    ComputeCharTypes;
  if FCharType[Ordinal] then
    Result := TrimRight(Result);
end;

function TDataReaderTableStorage.GetDecimal(Ordinal: Integer): TObject;
begin
  Result := TObject(FReader.GetDecimal(Ordinal));
end;

function TDataReaderTableStorage.GetObject(Ordinal: Integer): TObject;
begin
  Result := FReader.GetValue(Ordinal);
end;

function TDataReaderTableStorage.IsNull(Ordinal: Integer): Boolean;
begin
  Result := FReader.IsDBNull(Ordinal);
end;

procedure TDataReaderTableStorage.ComputeCharTypes;
var
  Ordinal: Integer;
begin
  SetLength(FCharType, FReader.FieldCount);
  for Ordinal := Low(FCharType) to High(FCharType) do
    FCharType[Ordinal] := (CharType = FReader.GetDataTypeName(Ordinal));
end;

end.

