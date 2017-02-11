unit DataViewStorage;

interface
uses
  DBXTableStorage,
  AbstractTableStorage,
  DataTableStorage,
  DataRowStorage,
  System.Data;

type
  TDataViewStorage = class(TAbstractTableStorage)
  public
    constructor Create(Table: TDataTableStorage; View: DataView);
    procedure BeforeFirst; override;
    function Next: Boolean; override;
    procedure Close; override;
    function GetInt16(Ordinal: Integer): SmallInt; overload; override;
    function GetInt32(Ordinal: Integer): Integer; overload; override;
    function GetInt64(Ordinal: Integer): Int64; overload; override;
    function GetBoolean(Ordinal: Integer): Boolean; overload; override;
    function GetString(Ordinal: Integer): WideString; overload; override;
    function GetObject(Ordinal: Integer): TObject; overload; override;
    function IsNull(Ordinal: Integer): Boolean; override;
  protected
    function GetMetaDataCollectionName: WideString; override;
    function GetColumns: TDBXColumnDescriptorArray; override;
    function GetOriginalRow: TDBXRowStorage; override;
    function GetStorage: TObject; override;
  private
    FTable: TDataTableStorage;
    FView: DataView;
    FRow: DataRowView;
    FRowIndex: Integer;
    FOriginal: TDataRowStorage;
  end;

implementation

constructor TDataViewStorage.Create(Table: TDataTableStorage; View: DataView);
begin
  Inherited Create;
  FTable := Table;
  FView := View;
  FRowIndex := -1;
end;

function TDataViewStorage.GetMetaDataCollectionName: WideString;
begin
  Result := FTable.MetaDataCollectionName;
end;

function TDataViewStorage.GetColumns: TDBXColumnDescriptorArray;
begin
  Result := FTable.Columns;
end;

function TDataViewStorage.GetOriginalRow: TDBXRowStorage;
begin
  if FOriginal = nil then
    FOriginal := TDataRowStorage.Create;
  if (FRow = nil) or (Integer(FRow.Row.RowState and DataRowState.Added) <> 0) then
    Result := nil
  else
  begin
    FOriginal.Row := FRow.Row;
    if FRow.Row.HasVersion(DataRowVersion.Original) then
      FOriginal.Version := DataRowVersion.Original
    else
      FOriginal.Version := DataRowVersion.Current;
    Result := FOriginal;
  end;
end;

procedure TDataViewStorage.BeforeFirst;
begin
  FRowIndex := -1;
  FRow := nil;
end;

function TDataViewStorage.Next: Boolean;
begin
  Inc(FRowIndex);
  Result := (FRowIndex < FView.Count);
  if (Result) then
    FRow := FView[FRowIndex]
  else
  begin
    Dec(FRowIndex);
    FRow := nil;
  end;
end;

procedure TDataViewStorage.Close;
begin
  FRow := nil;
  FView := nil;
  FTable := nil;
end;

function TDataViewStorage.GetStorage: TObject;
begin
  Result := FView;
end;

function TDataViewStorage.GetInt16(Ordinal: Integer): SmallInt;
begin
  Result := SmallInt(FRow[Ordinal]);
end;

function TDataViewStorage.GetInt32(Ordinal: Integer): Integer;
begin
  Result := Integer(FRow[Ordinal]);
end;

function TDataViewStorage.GetInt64(Ordinal: Integer): Int64;
begin
  Result := Int64(FRow[Ordinal]);
end;

function TDataViewStorage.GetBoolean(Ordinal: Integer): Boolean;
begin
  Result := Boolean(FRow[Ordinal]);
end;

function TDataViewStorage.GetString(Ordinal: Integer): WideString;
begin
  Result := WideString(FRow[Ordinal]);
end;

function TDataViewStorage.GetObject(Ordinal: Integer): TObject;
begin
  Result := FRow[Ordinal];
end;

function TDataViewStorage.IsNull(Ordinal: Integer): Boolean;
var
  Value: TObject;
begin
  Value := FRow[Ordinal];
  Result := (Value = nil) or (Value = DBNull.Value);
end;

end.
