unit DBXReaderTableStorage;
interface
uses
  DBXCommon,
  DBXTableStorage,
  DBXPlatformUtil,
  FmtBcd;

type
  TDBXReaderTableStorage = class(TDBXDefaultTableStorage)
  public
    constructor Create(Command: TDBXCommand; Reader: TDBXReader);
    destructor Destroy; override;
    procedure BeforeFirst; override;
    function Next: Boolean; override;
    procedure Close; override;
    function GetInt16(Ordinal: Integer): SmallInt; override;
    function GetInt32(Ordinal: Integer): Integer; override;
    function GetInt64(Ordinal: Integer): Int64; override;
    function GetBoolean(Ordinal: Integer): Boolean; override;
    function GetString(Ordinal: Integer): WideString; override;
    function GetDecimal(Ordinal: Integer): TObject; override;
    function GetAsInt16(Ordinal: Integer): SmallInt; override;
    function GetAsInt32(Ordinal: Integer): Integer; override;
    function GetAsInt64(Ordinal: Integer): Int64; override;
    function GetAsBoolean(Ordinal: Integer): Boolean; override;
    function GetAsString(Ordinal: Integer): WideString; override;
    function IsNull(Ordinal: Integer): Boolean; override;
  protected
    function GetColumns: TDBXColumnDescriptorArray; override;
    function GetStorage: TObject; override;
    function GetCommand: TObject; override;
//  private
//    function ToColumnType(DataType: Integer): Integer;
  private
    FCommand: TDBXCommand;
    FReader: TDBXReader;
    FColumns: TDBXColumnDescriptorArray;
    FNextCalled: Boolean;
  end;

  TBcdObject = class
  public
    constructor Create(Bcd: TBcd);
  private
    FBcd: TBcd;
  public
    property BcdValue: TBcd read FBcd;
  end;

implementation
uses
  SysUtils;

constructor TDBXReaderTableStorage.Create(Command: TDBXCommand; Reader: TDBXReader);
begin
  Inherited Create;
  FCommand := Command;
  FReader := Reader;
end;

destructor TDBXReaderTableStorage.Destroy;
begin
  FreeAndNil(FCommand);
  FreeAndNil(FReader);
  FreeObjectArray(TDBXFreeArray(FColumns));
  inherited Destroy;
end;

function TDBXReaderTableStorage.GetCommand: TObject;
begin
  Result := FCommand;
  FCommand := nil;
end;

procedure TDBXReaderTableStorage.BeforeFirst;
begin
  if FNextCalled then
    raise Exception.Create(SUnsupportedOperation);
end;

function TDBXReaderTableStorage.Next: Boolean;
begin
  FNextCalled := True;
  Result := FReader.Next;
end;

procedure TDBXReaderTableStorage.Close;
begin
  FreeAndNil(FReader);
end;

function TDBXReaderTableStorage.GetColumns: TDBXColumnDescriptorArray;
var
  Ordinal: Integer;
  ValueType: TDBXValueType;
begin
  if FColumns = nil then
  begin
    SetLength(FColumns, FReader.ColumnCount);
    for Ordinal := Low(FColumns) to High(FColumns) do
    begin
      ValueType := FReader.ValueType[Ordinal];
      FColumns[Ordinal] := TDBXColumnDescriptor.Create(ValueType.Name, ValueType.DataType, ValueType.Precision);
    end;
  end;
  Result := FColumns;
end;

//function TDBXReaderTableStorage.ToColumnType(DataType: Integer): Integer;
//begin
//  case DataType of
//    TDBXDataTypes.AnsiStringType,
//    TDBXDataTypes.WideStringType:
//      Result := TDBXColumnType.Varchar;
//    TDBXDataTypes.BooleanType:
//      Result := TDBXColumnType.Boolean;
//    TDBXDataTypes.Int16Type:
//      Result := TDBXColumnType.Short;
//    TDBXDataTypes.Int32Type:
//      Result := TDBXColumnType.Int;
//    TDBXDataTypes.Int64Type:
//      Result := TDBXColumnType.Long;
//    TDBXDataTypes.BcdType:
//      Result := TDBXColumnType.Decimal;
//    else
//      Result := TDBXColumnType.Notype;
//  end;
//end;

function TDBXReaderTableStorage.GetStorage: TObject;
begin
  Result := FReader;
end;

function TDBXReaderTableStorage.GetInt16(Ordinal: Integer): SmallInt;
begin
  Result := FReader.Value[Ordinal].GetInt16;
end;

function TDBXReaderTableStorage.GetInt32(Ordinal: Integer): Integer;
begin
  Result := FReader.Value[Ordinal].GetInt32;
end;

function TDBXReaderTableStorage.GetInt64(Ordinal: Integer): Int64;
begin
  Result := FReader.Value[Ordinal].GetInt64;
end;

function TDBXReaderTableStorage.GetBoolean(Ordinal: Integer): Boolean;
begin
  Result := FReader.Value[Ordinal].GetBoolean;
end;

function TDBXReaderTableStorage.GetString(Ordinal: Integer): WideString;
var
  Value: TDBXValue;
begin
  // TODO:  Switch to AsWideString once DbxCommon supports it.
  //
  Value := FReader.Value[Ordinal];
  if Value is TDBXWideStringValue then
    Result := Value.GetWideString
  else
    Result := Value.GetAnsiString;
end;

function TDBXReaderTableStorage.GetDecimal(Ordinal: Integer): TObject;
begin
  Result := TBcdObject.Create(FReader.Value[Ordinal].GetBcd);
end;

function TDBXReaderTableStorage.GetAsInt16(Ordinal: Integer): SmallInt;
begin
  case FReader.ValueType[Ordinal].DataType of
    TDBXDataTypes.Int16Type:
      Result := FReader.Value[Ordinal].GetInt16;
    TDBXDataTypes.Int32Type:
      Result := SmallInt(FReader.Value[Ordinal].GetInt32);
    TDBXDataTypes.Int64Type:
      Result := SmallInt(FReader.Value[Ordinal].GetInt64);
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

function TDBXReaderTableStorage.GetAsInt32(Ordinal: Integer): Integer;
begin
  case FReader.ValueType[Ordinal].DataType of
    TDBXDataTypes.Int16Type:
      Result := Integer(FReader.Value[Ordinal].GetInt16);
    TDBXDataTypes.Int32Type:
      Result := FReader.Value[Ordinal].GetInt32;
    TDBXDataTypes.Int64Type:
      Result := Integer(FReader.Value[Ordinal].GetInt64);
    TDBXDataTypes.BcdType:
      Result := BcdToInteger(FReader.Value[Ordinal].GetBcd);
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

function TDBXReaderTableStorage.GetAsInt64(Ordinal: Integer): Int64;
begin
  case FReader.ValueType[Ordinal].DataType of
    TDBXDataTypes.Int16Type:
      Result := Int64(FReader.Value[Ordinal].GetInt16);
    TDBXDataTypes.Int32Type:
      Result := Int64(FReader.Value[Ordinal].GetInt32);
    TDBXDataTypes.Int64Type:
      Result := FReader.Value[Ordinal].GetInt64;
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

function TDBXReaderTableStorage.GetAsBoolean(Ordinal: Integer): Boolean;
begin
  case FReader.ValueType[Ordinal].DataType of
    TDBXDataTypes.BooleanType:
      Result := FReader.Value[Ordinal].GetBoolean;
    TDBXDataTypes.Int16Type:
      Result := (FReader.Value[Ordinal].GetInt16 <> 0);
    TDBXDataTypes.Int32Type:
      Result := (FReader.Value[Ordinal].GetInt32 <> 0);
    TDBXDataTypes.Int64Type:
      Result := (FReader.Value[Ordinal].GetInt64 <> 0);
    TDBXDataTypes.BcdType:
      Result := (BcdToStr(FReader.Value[Ordinal].GetBcd) <> '0');
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

function TDBXReaderTableStorage.GetAsString(Ordinal: Integer): WideString;
begin
  case FReader.ValueType[Ordinal].DataType of
    TDBXDataTypes.AnsiStringType:
      Result := FReader.Value[Ordinal].GetAnsiString;
    TDBXDataTypes.WideStringType:
      Result := FReader.Value[Ordinal].GetWideString;
    TDBXDataTypes.BlobType:
      if FReader.ValueType[Ordinal].SubType = TDBXDataTypes.MemoSubType then
        Result := FReader.Value[Ordinal].GetAnsiString
      else if FReader.ValueType[Ordinal].SubType = TDBXDataTypes.WideMemoSubType then
        Result := FReader.Value[Ordinal].GetWideString
      else
        raise Exception.Create(SUnsupportedOperation);
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
  if FReader.ValueType[Ordinal].SubType = TDBXDataTypes.FixedSubType then
    Result := TrimRight(Result);
end;

function TDBXReaderTableStorage.IsNull(Ordinal: Integer): Boolean;
begin
  Result := FReader.Value[Ordinal].IsNull;
end;

constructor TBcdObject.Create(Bcd: TBcd);
begin
  inherited Create;
  FBcd := Bcd;
end;


end.

