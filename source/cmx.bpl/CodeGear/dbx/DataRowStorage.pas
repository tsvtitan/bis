unit DataRowStorage;
interface
uses
  DBXTableStorage,
  System.Data;

type
  TDataRowStorage = class(TDBXDefaultRowStorage)
  public
    constructor Create(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString); overload;
    constructor Create(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; Row: DataRow); overload;
    function GetInt16(Ordinal: Integer): SmallInt; overload; override;
    function GetInt32(Ordinal: Integer): Integer; overload; override;
    function GetInt64(Ordinal: Integer): Int64; overload; override;
    function GetBoolean(Ordinal: Integer): Boolean; overload; override;
    function GetString(Ordinal: Integer): WideString; overload; override;
    function GetObject(Ordinal: Integer): TObject; overload; override;
    function IsNull(Ordinal: Integer): Boolean; override;
  protected
    function GetMetaDataCollectionName: WideString; override;
    function GetMetaDataCollectionIndex: Integer; override;
    function GetOriginalRow: TDBXRowStorage; override;
  private
    procedure SetRow(Row: DataRow);
    procedure SetVersion(Wanted: DataRowVersion);
    procedure AdjustVersion;
    function IsValidVersion(Version: DataRowVersion): Boolean;
  public
    property Row: DataRow write SetRow;
    property Version: DataRowVersion write SetVersion;
  private
    FMetaDataCollectionIndex: Integer;
    FMetaDataCollectionName: WideString;
    FRow: DataRow;
    FWanted: DataRowVersion;
    FVersion: DataRowVersion;
    FOriginal: TDataRowStorage;
  end;

implementation

const
  RowType = 'Row';

constructor TDataRowStorage.Create(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString);
begin
  Inherited Create;
  FMetaDataCollectionIndex := MetaDataCollectionIndex;
  FMetaDataCollectionName := MetaDataCollectionName;
end;

constructor TDataRowStorage.Create(MetaDataCollectionIndex: Integer; const MetaDataCollectionName: WideString; Row: DataRow);
begin
  Inherited Create;
  FMetaDataCollectionIndex := MetaDataCollectionIndex;
  FMetaDataCollectionName := MetaDataCollectionName;
  FRow := Row;
  FVersion := DataRowVersion.Current;
end;

function TDataRowStorage.GetMetaDataCollectionName: WideString;
begin
  Result := FMetaDataCollectionName;
end;

function TDataRowStorage.GetMetaDataCollectionIndex: Integer;
begin
  Result := FMetaDataCollectionIndex;
end;

procedure TDataRowStorage.SetRow(Row: DataRow);
begin
  FRow := Row;
  AdjustVersion;
end;

procedure TDataRowStorage.SetVersion(Wanted: DataRowVersion);
begin
  FWanted := Wanted;
  AdjustVersion;
end;

procedure TDataRowStorage.AdjustVersion;
begin
  if (FRow <> nil) and IsValidVersion(FWanted) and FRow.HasVersion(FWanted) then
    FVersion := FWanted
  else
    FVersion := DataRowVersion.Current;
end;

function TDataRowStorage.IsValidVersion(Version: DataRowVersion): Boolean;
begin
  case Version of
    DataRowVersion.Current,
    DataRowVersion.Original,
    DataRowVersion.Proposed:
      Result := True;
    else
      Result := False;
  end;
end;

function TDataRowStorage.GetOriginalRow: TDBXRowStorage;
begin
  if FOriginal = nil then
    FOriginal := TDataRowStorage.Create;
  FOriginal.Row := FRow;
  Result := FOriginal;
  if Integer(FRow.RowState and DataRowState.Added) <> 0 then
    Result := nil
  else if FRow.HasVersion(DataRowVersion.Original) then
    FOriginal.Version := DataRowVersion.Original
  else
    FOriginal.Version := DataRowVersion.Current;
end;

function TDataRowStorage.GetInt16(Ordinal: Integer): SmallInt;
begin
  Result := SmallInt(FRow[Ordinal,FVersion]);
end;

function TDataRowStorage.GetInt32(Ordinal: Integer): Integer;
begin
  Result := Integer(FRow[Ordinal,FVersion]);
end;

function TDataRowStorage.GetInt64(Ordinal: Integer): Int64;
begin
  Result := Int64(FRow[Ordinal,FVersion]);
end;

function TDataRowStorage.GetBoolean(Ordinal: Integer): Boolean;
begin
  Result := Boolean(FRow[Ordinal,FVersion]);
end;

function TDataRowStorage.GetString(Ordinal: Integer): WideString;
begin
  Result := WideString(FRow[Ordinal,FVersion]);
end;

function TDataRowStorage.GetObject(Ordinal: Integer): TObject;
begin
  Result := FRow[Ordinal,FVersion];
end;

function TDataRowStorage.IsNull(Ordinal: Integer): Boolean;
var
  Value: TObject;
begin
  Value := FRow[Ordinal,FVersion];
  Result := (Value = nil) or (Value = DBNull.Value);
end;

end.