unit AbstractTableStorage;
interface
uses
  DBXTableStorage,
  System.Collections;

type
  TAbstractTableStorage = class(TDBXDefaultTableStorage)
  public
    function FindOrdinal(const ColumnName: WideString): Integer; override;
    function GetAsBoolean(Ordinal: Integer): Boolean; override;
    function GetAsInt16(Ordinal: Integer): SmallInt; override;
    function GetAsInt32(Ordinal: Integer): Integer; override;
    function GetAsInt64(Ordinal: Integer): Int64; override;
    function GetAsString(Ordinal: Integer): WideString; override;
    function ToColumnType(const DataType: System.Type): Integer;
  private
    procedure InitTypeMap;
    class var FTypeMap: Hashtable;
  end;

implementation
uses
  DBXCommon,
  DBXPlatformUtil,
  System.Threading;

function TAbstractTableStorage.FindOrdinal(const ColumnName: WideString): Integer;
var
  Ordinal: Integer;
  MyColumns: TDBXColumnDescriptorArray;
begin
  MyColumns := Columns;
  Result := -1;
  for Ordinal := 0 to Length(MyColumns) - 1 do
  begin
    if MyColumns[Ordinal].ColumnName = ColumnName then
    begin
      Result := Ordinal;
      Exit;
    end;
  end;
end;

function IsTrueStringValue(const Value: WideString): Boolean;
var
  Ch: Char;
begin
  Result := False;
  if Length(Value) > 0 then
  begin
    Ch := Value[1];
    case Ch of
      'Y','y','T','t':
        Result := True;
    end;
  end;
end;

function TAbstractTableStorage.GetAsBoolean(Ordinal: Integer): Boolean;
begin
  case Columns[Ordinal].ColumnType of
    TDBXDataTypes.BooleanType:
      Result := GetBoolean(Ordinal);
    TDBXDataTypesEx.Uint8Type:
      Result := (GetUnsignedByte(Ordinal) <> 0);
    TDBXDataTypes.Int16Type:
      Result := (GetInt16(Ordinal) <> 0);
    TDBXDataTypes.Int32Type:
      Result := (GetInt32(Ordinal) <> 0);
    TDBXDataTypes.Int64Type:
      Result := (GetInt64(Ordinal) <> 0);
    TDBXDataTypes.BcdType:
      Result := (Decimal(GetDecimal(Ordinal)) <> Decimal.Zero);
    TDBXDataTypes.AnsiStringType,
    TDBXDataTypes.WideStringType:
      Result := IsTrueStringValue(GetString(Ordinal));
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

function TAbstractTableStorage.GetAsInt16(Ordinal: Integer): SmallInt;
begin
  case Columns[Ordinal].ColumnType of
    TDBXDataTypesEx.Uint8Type:
      Result := GetUnsignedByte(Ordinal);
    TDBXDataTypes.Int16Type:
      Result := GetInt16(Ordinal);
    TDBXDataTypes.Int32Type:
      Result := Convert.ToInt16(GetInt32(Ordinal));
    TDBXDataTypes.Int64Type:
      Result := Convert.ToInt16(GetInt64(Ordinal));
    TDBXDataTypes.BcdType:
      Result := Convert.ToInt16(GetDecimal(Ordinal));
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

function TAbstractTableStorage.GetAsInt32(Ordinal: Integer): Integer;
begin
  case Columns[Ordinal].ColumnType of
    TDBXDataTypesEx.Uint8Type:
      Result := Convert.ToInt32(GetUnsignedByte(Ordinal));
    TDBXDataTypes.Int16Type:
      Result := Convert.ToInt32(GetInt16(Ordinal));
    TDBXDataTypes.Int32Type:
      Result := GetInt32(Ordinal);
    TDBXDataTypes.Int64Type:
      Result := Convert.ToInt32(GetInt64(Ordinal));
    TDBXDataTypes.BcdType:
      Result := Convert.ToInt32(GetDecimal(Ordinal));
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

function TAbstractTableStorage.GetAsInt64(Ordinal: Integer): Int64;
begin
  case Columns[Ordinal].ColumnType of
    TDBXDataTypesEx.Uint8Type:
      Result := Convert.ToInt64(GetUnsignedByte(Ordinal));
    TDBXDataTypes.Int16Type:
      Result := Convert.ToInt64(GetInt16(Ordinal));
    TDBXDataTypes.Int32Type:
      Result := Convert.ToInt64(GetInt32(Ordinal));
    TDBXDataTypes.Int64Type:
      Result := GetInt64(Ordinal);
    TDBXDataTypes.BcdType:
      Result := Convert.ToInt64(GetDecimal(Ordinal));
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

function TAbstractTableStorage.GetAsString(Ordinal: Integer): WideString;
begin
  case Columns[Ordinal].ColumnType of
    TDBXDataTypes.AnsiStringType,
    TDBXDataTypes.WideStringType:
      Result := GetString(Ordinal).TrimEnd(nil);
    TDBXDataTypes.Int32Type:
      Result := Convert.ToString(GetInt32(Ordinal));
    TDBXDataTypesEx.CharArrayType:
      Result := System.String.Create(TDBXDynamicCharArray(GetObject(Ordinal)));
    else
      raise Exception.Create(SUnsupportedOperation);
  end;
end;

function TAbstractTableStorage.ToColumnType(const DataType: System.Type): Integer;
begin
  InitTypeMap;
  Result := Integer(FTypeMap[DataType]);
end;

procedure TAbstractTableStorage.InitTypeMap;
begin
  Monitor.Enter(typeof(TAbstractTableStorage));
  try
    if (FTypeMap = nil) then
    begin
      FTypeMap := Hashtable.Create();
      FTypeMap.Add(typeof(Byte),                 TObject(Integer(TDBXDataTypesEx.Uint8Type)));
      FTypeMap.Add(typeof(SmallInt),             TObject(Integer(TDBXDataTypes.Int16Type)));
      FTypeMap.Add(typeof(Integer),              TObject(Integer(TDBXDataTypes.Int32Type)));
      FTypeMap.Add(typeof(Int64),                TObject(Integer(TDBXDataTypes.Int64Type)));
      FTypeMap.Add(typeof(WideString),           TObject(Integer(TDBXDataTypes.WideStringType)));
      FTypeMap.Add(typeof(TDBXDynamicCharArray), TObject(Integer(TDBXDataTypesEx.CharArrayType)));
      FTypeMap.Add(typeof(Boolean),              TObject(Integer(TDBXDataTypes.BooleanType)));
      FTypeMap.Add(typeof(Decimal),              TObject(Integer(TDBXDataTypes.BcdType)));
      FTypeMap.Add(typeof(TBytes),               TObject(Integer(TDBXDataTypes.BytesType)));
    end;
  finally
    Monitor.Exit(typeof(TAbstractTableStorage));
  end;
end;

end.