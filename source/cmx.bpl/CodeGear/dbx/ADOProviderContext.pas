unit ADOProviderContext;
interface
uses
  System.Data,
  System.Reflection,
  DBXTableStorage,
  DBXMetaDataReader,
  DBXPlatformUtil,
  ADOPlatformTypeNames;

type
  TADOProviderContext = class(TDBXProviderContext)
  private
    FUseAnsiStrings: Boolean;
    FConnection: IDbConnection;
    FParameterMarker: WideString;
    FMarkerIncludedInParameterName: Boolean;
    FTypeNames: TADOPlatformTypeNames;
    FTransaction: IDbTransaction;
  protected
    function CurrentTransAction: IDbTransaction; virtual;
  public
    constructor Create;
    function GetPlatformTypeName(const DataType: Integer; const IsUnsigned: Boolean): WideString; override;
    function ExecuteQuery(const Sql: WideString; const ParameterNames: TDBXWideStringArray; const ParameterValues: TDBXWideStringArray): TDBXTableStorage; override;
    function CreateTableStorage(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray): TDBXTableStorage; override;
    function CreateRowStorage(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray): TDBXRowStorage; override;
    procedure StartTransaction; override;
    procedure StartSerializedTransaction; override;
    procedure Commit; override;
    procedure Rollback; override;
    function GetVendorProperty(const Name: WideString): WideString; override;
  private
    function ExecuteQueryWithoutNamedParameters(Sql: WideString; ParameterNames: TDBXWideStringArray; ParameterValues: TDBXWideStringArray): TDBXTableStorage;
    function ExecuteQueryWithNamedParameters(Sql: WideString; ParameterNames: TDBXWideStringArray; ParameterValues: TDBXWideStringArray): TDBXTableStorage;
    function RemoveExtraParameterMarkers(Sql: WideString; ParameterNames: TDBXWideStringArray; ParameterValues: TDBXWideStringArray): WideString;
    function RemoveNamedParameters(var Sql: WideString; ParameterNames: TDBXWideStringArray; ParameterValues: TDBXWideStringArray): TDBXWideStringArray;
    function FindMatchingStartParen(const Sql: WideString; const IndexEndParen: Integer): Integer;
    function GetParameterName(Sql: WideString; Index: Integer): WideString;
  public
    property SqlParameterMarker: WideString read FParameterMarker write FParameterMarker;
    property IsMarkerIncludedInParameterName: Boolean read FMarkerIncludedInParameterName write FMarkerIncludedInParameterName;
    property Connection: IDbConnection write FConnection;
    property UseAnsiStrings: Boolean read FUseAnsiStrings write FUseAnsiStrings;
  end;

implementation
uses
  DataTableStorage,
  DataReaderTableStorage,
  System.Collections,
  System.Text,
  SysUtils;

const
  EqualsAndSpace = '= ';
  OrSection = ' OR (';
  IsNull = ' IS NULL)';
  TrueValue = '1<2';
  FalseValue = '1>2';
  DefaultMarker = ':';
  DefaultParameterName = 'Arg';
  QuestionMark = '?';
  Call = 'CALL ';
  DummyValue = '#$%X@Z';

constructor TADOProviderContext.Create;
begin
  inherited Create;
  FTypeNames := TADOPlatformTypeNames.Create;
end;

function TADOProviderContext.GetPlatformTypeName(const DataType: Integer; const IsUnsigned: Boolean): WideString;
begin
  Result := FTypeNames.GetPlatformTypeName(DataType, IsUnsigned);
end;

function TADOProviderContext.ExecuteQuery(const Sql: WideString; const ParameterNames: TDBXWideStringArray; const ParameterValues: TDBXWideStringArray): TDBXTableStorage;
begin
  if (FParameterMarker = nil) or (FParameterMarker.Length = 0) then
    Result := ExecuteQueryWithoutNamedParameters(Sql, ParameterNames, ParameterValues)
  else
    Result := ExecuteQueryWithNamedParameters(Sql, ParameterNames, ParameterValues);
end;

function TADOProviderContext.CreateTableStorage(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray): TDBXTableStorage;
var
  Table: DataTable;
  Storage: TDBXTableStorage;
begin
  Table := DataTable.Create;
  Table.TableName := MetaDataCollectionName;
  Storage := TDataTableStorage.Create(MetaDataCollectionIndex, MetaDataCollectionName, Table);
  Storage.Columns := Columns;
  Result := Storage;
end;

function TADOProviderContext.CreateRowStorage(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; const Columns: TDBXColumnDescriptorArray): TDBXRowStorage;
var
  Storage: TDBXTableStorage;
begin
  Storage := CreateTableStorage(MetaDataCollectionIndex, MetaDataCollectionName, Columns);
  Storage.NewRow;
  Storage.InsertRow;
  Result := Storage;
end;

function TADOProviderContext.CurrentTransaction: IDbTransaction;
begin
  Result := FTransaction;
end;

procedure TADOProviderContext.StartTransaction;
begin
  try
    FTransaction := FConnection.BeginTransaction;
  except
  end;
end;

procedure TADOProviderContext.StartSerializedTransaction;
begin
  try
    FTransaction := FConnection.BeginTransaction(IsolationLevel.Serializable);
  except
  end;
end;

procedure TADOProviderContext.Commit;
begin
  if FTransaction <> nil then
  begin
    FTransaction.Commit;
    FTransaction := nil;
  end;
end;

procedure TADOProviderContext.Rollback;
begin
  if FTransaction <> nil then
  begin
    FTransaction.Rollback;
    FTransaction := nil;
  end;
end;

function TADOProviderContext.GetVendorProperty(const Name: WideString): WideString;
var
  Con: TObject;
  Ext: TObject;
  Res: TObject;
begin
  Result := '';
  if FConnection <> nil then
  begin
    try
      Con := TObject(FConnection);
      Ext := Con.GetType.InvokeMember('Dbx', BindingFlags.Default or BindingFlags.GetProperty, nil, Con, nil);
      if Ext <> nil then
      begin
        Res := Ext.GetType.InvokeMember('GetVendorProperty', BindingFlags.InvokeMethod, nil, Ext, [Name]);
        if Res <> nil then
          Result :=  String(Res);
      end;
    except
    end;
  end;
end;

function TADOProviderContext.ExecuteQueryWithoutNamedParameters(Sql: WideString; ParameterNames: TDBXWideStringArray; ParameterValues: TDBXWideStringArray): TDBXTableStorage;
var
  Command: IDbCommand;
  ParameterCollection: IDataParameterCollection;
  Parameter: IDataParameter;
  Reader: IDataReader;
  Index: Integer;
begin
  if ParameterNames <> nil then
    ParameterValues := RemoveNamedParameters(Sql,ParameterNames,ParameterValues);
  Command := FConnection.CreateCommand;
  try
    Command.Transaction := CurrentTransaction;
    Command.CommandText := Sql;
    if ParameterValues <> nil then
    begin
      ParameterCollection := Command.Parameters;
      for Index := Low(ParameterValues) to High(ParameterValues) do
      begin
        Parameter := Command.CreateParameter;
        Parameter.ParameterName := DefaultParameterName + Convert.ToString(Index+1);
        if FUseAnsiStrings then
          Parameter.DbType := DbType.AnsiStringFixedLength
        else
          Parameter.DbType := DbType.StringFixedLength;
        if ParameterValues[Index] = nil then
          Parameter.Value := DBNull.Value
        else
          Parameter.Value := TObject(ParameterValues[Index]);
        ParameterCollection.Add(Parameter);
      end;
    end;
    Reader := Command.ExecuteReader;
    Result := TDataReaderTableStorage.Create(Command,Reader);
    Command := nil;
  finally
    FreeAndNil(Command);
  end;
end;

function TADOProviderContext.ExecuteQueryWithNamedParameters(Sql: WideString; ParameterNames: TDBXWideStringArray; ParameterValues: TDBXWideStringArray): TDBXTableStorage;
var
  Command: IDbCommand;
  ParameterCollection: IDataParameterCollection;
  Parameter: IDataParameter;
  Reader: IDataReader;
  Index: Integer;
begin
  Command := FConnection.CreateCommand;
  try
    Command.Transaction := CurrentTransaction;
    Command.CommandText := RemoveExtraParameterMarkers(Sql, ParameterNames, ParameterValues);
    if ParameterValues <> nil then
    begin
      ParameterCollection := Command.Parameters;
      for Index := Low(ParameterValues) to High(ParameterValues) do
      begin
        Parameter := Command.CreateParameter;
        if FUseAnsiStrings then
          Parameter.DbType := DbType.AnsiString
        else
          Parameter.DbType := DbType.String;
        if IsMarkerIncludedInParameterName then
          Parameter.ParameterName := SqlParameterMarker + ParameterNames[Index]
        else
          Parameter.ParameterName := ParameterNames[Index];
        if ParameterValues[Index] = nil then
          Parameter.Value := DBNull.Value
        else
          Parameter.Value := TObject(ParameterValues[Index]);
        ParameterCollection.Add(Parameter);
      end;
    end;
    Reader := Command.ExecuteReader();
    Result := TDataReaderTableStorage.Create(Command,Reader);
    Command := nil;
  finally
    FreeAndNil(Command);
  end;
end;

function TADOProviderContext.RemoveExtraParameterMarkers(Sql: WideString; ParameterNames: TDBXWideStringArray; ParameterValues: TDBXWideStringArray): WideString;
var
  ParameterIndex: Integer;
  Index: Integer;
  Start: Integer;
  Marker: WideString;
begin
  if ParameterNames <> nil then
  begin
    for ParameterIndex := Low(ParameterNames) to High(ParameterNames) do
    begin
      Marker := DefaultMarker + ParameterNames[ParameterIndex];
      Index := Sql.IndexOf(EqualsAndSpace + Marker + OrSection + Marker + IsNull);
      if Index >= 0 then
      begin
        if ParameterValues[ParameterIndex] = nil then
        begin
          Start := FindMatchingStartParen(Sql, Index);
          Sql := Sql.Remove(Start + 1, Index - Start - 1 + EqualsAndSpace.Length + Marker.Length + OrSection.Length - 1);
        end
        else
        begin
          Sql := Sql.Remove(Index + EqualsAndSpace.Length + Marker.Length, OrSection.Length + Marker.Length + IsNull.Length);
        end;
      end;
    end;
    if not SqlParameterMarker.Equals(DefaultMarker) then
      Sql := Sql.Replace(DefaultMarker, SqlParameterMarker);
  end;
  Result := Sql;
end;

function TADOProviderContext.RemoveNamedParameters(var Sql: WideString; ParameterNames: TDBXWideStringArray; ParameterValues: TDBXWideStringArray): TDBXWideStringArray;
var
  Marker: WideString;
  Names: ArrayList;
  Values: ArrayList;
  Builder: StringBuilder;
  Index: Integer;
  ParameterIndex: Integer;
  ParameterName: WideString;
  Replacement: WideString;
  UseDummyValue: Boolean;
begin
  UseDummyValue := not Sql.StartsWith(Call);
  Marker := DefaultMarker;
  Values := ArrayList.Create;
  Names := ArrayList.Create(ParameterNames);
  Builder := StringBuilder.Create(Sql);
  Index := Sql.LastIndexOf(Marker);
  while Index >= 0 do
  begin
    ParameterName := GetParameterName(Sql, Index + Marker.Length);
    ParameterIndex := Names.IndexOf(ParameterName);
    if (Sql[Index] = '(') and (Sql.IndexOf(IsNull, Index + Marker.Length + ParameterName.Length, IsNull.Length) > 0) then
    begin
      if ParameterValues[ParameterIndex] = nil then
        Replacement := TrueValue
      else
        Replacement := FalseValue;
      Builder.Remove(Index, Marker.Length + ParameterName.Length + IsNull.Length - 1);
      Builder.Insert(Index, Replacement);
    end
    else
    begin
      if ParameterValues[ParameterIndex] <> nil then
        Values.Add(ParameterValues[ParameterIndex])
      else if UseDummyValue then
        Values.Add(DummyValue)
      else
        Values.Add(nil);
      Builder.Replace(ParameterName, '', Index + Marker.Length, ParameterName.Length);
      Builder.Replace(Marker, QuestionMark, Index, Marker.Length);
    end;
    Index := Sql.LastIndexOf(Marker,Index-1);
  end;
  Sql := Builder.ToString;
  SetLength(Result, Values.Count);
  for Index := Low(Result) to High(Result) do
    Result[Index] := WideString(Values[Length(Result) - Index - 1]);
end;

function TADOProviderContext.FindMatchingStartParen(const Sql: WideString; const IndexEndParen: Integer): Integer;
var
  Pos: Integer;
  ParenNesting: Integer;
  Ch: Char;
begin
  Pos := IndexEndParen+1;
  ParenNesting := 1;
  Result := 0;
  while Pos > 1 do
  begin
    Dec(Pos);
    Ch := Sql[Pos];
    if Ch = ')' then
      Inc(parenNesting)
    else if (Ch = '(') then
    begin
      Dec(ParenNesting);
      if ParenNesting = 0 then
      begin
        Result := Pos-1;
        Exit;
      end;
    end;
  end;
end;

function TADOProviderContext.GetParameterName(Sql: WideString; Index: Integer): WideString;
var
  Start: Integer;
  Pos: Integer;
  Ch: Char;
begin
  Pos := Index + 1;
  Start := Index;
  if Pos <= Sql.Length then
    Ch := Sql[Pos]
  else
    Ch := '@';
  while ((Ch >= 'A') and (Ch <= 'Z')) or (Ch = '_') do
  begin
    Inc(Pos);
    if Pos <= Sql.Length then
      Ch := Sql[Pos]
    else
      Ch := '@';
  end;
  Result := Sql.Substring(Start, Pos - 1 - Start);
end;

end.


