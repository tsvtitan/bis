{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXMySqlMetaDataWriter;
interface
uses
  DBXMetaDataReader,
  DBXMetaDataWriter,
  DBXPlatform,
  DBXPlatformUtil,
  DBXTableStorage;
type
  TDBXMySqlCustomMetaDataWriter = class(TDBXBaseMetaDataWriter)
  protected
    procedure MakeSqlDataType(Buffer: TDBXWideStringBuffer; DataType: TDBXDataTypeDescription; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s); override;
    function CanCreateIndexAsKey(Index: TDBXRowStorage; IndexColumns: TDBXTableStorage): Boolean; override;
    procedure MakeSqlCreateIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage; IndexColumns: TDBXTableStorage); override;
    procedure MakeSqlDropIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage); override;
    procedure MakeSqlDropForeignKey(Buffer: TDBXWideStringBuffer; ForeignKey: TDBXRowStorage); override;
    procedure MakeSqlColumnTypeCast(Buffer: TDBXWideStringBuffer; Column: TDBXRowStorage); override;
  private
    function UnicodeSpecificationRequired(ColumnRow: TDBXRowStorage): Boolean;
    function HasAutoIncrementColumn(Index: TDBXRowStorage): Boolean;
    function FindCastType(Column: TDBXRowStorage): WideString;
  end;

  TDBXMySqlMetaDataWriter = class(TDBXMySqlCustomMetaDataWriter)
  public
    constructor Create;
    procedure Open; override;
  protected
    function GetSqlAutoIncrementKeyword: WideString; override;
    function IsCatalogsSupported: Boolean; override;
    function IsSchemasSupported: Boolean; override;
    function GetAlterTableSupport: Integer; override;
    function GetSqlRenameTable: WideString; override;
  end;

implementation
uses
  DBXCommon,
  DBXMetaDataNames,
  DBXMySqlMetaDataReader,
  SysUtils;

procedure TDBXMySqlCustomMetaDataWriter.MakeSqlDataType(Buffer: TDBXWideStringBuffer; DataType: TDBXDataTypeDescription; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s);
begin
  inherited MakeSqlDataType(Buffer, DataType, ColumnRow, Overrides);
  case DataType.DbxDataType of
    TDBXDataTypes.AnsiStringType:
      if UnicodeSpecificationRequired(ColumnRow) then
        Buffer.Append(' CHARACTER SET utf8');
    TDBXDataTypesEx.Int8Type,
    TDBXDataTypes.Int16Type,
    TDBXDataTypes.Int32Type,
    TDBXDataTypes.Int64Type,
    TDBXDataTypesEx.UInt8Type,
    TDBXDataTypes.UInt16Type,
    TDBXDataTypes.UInt32Type,
    TDBXDataTypes.UInt64Type:
      if ColumnRow.GetBoolean(TDBXColumnsIndex.IsUnsigned, False) then
        Buffer.Append(' unsigned');
  end;
end;

function TDBXMySqlCustomMetaDataWriter.UnicodeSpecificationRequired(ColumnRow: TDBXRowStorage): Boolean;
var
  CustomReader: TDBXMySqlCustomMetaDataReader;
  DefaultIsUnicode: Boolean;
  UnicodeRequested: Boolean;
begin
  CustomReader := TDBXMySqlCustomMetaDataReader(FReader);
  DefaultIsUnicode := CustomReader.DefaultCharSetUnicode;
  UnicodeRequested := ColumnRow.GetBoolean(TDBXColumnsIndex.IsUnicode, DefaultIsUnicode);
  Result := UnicodeRequested and not DefaultIsUnicode;
end;

function TDBXMySqlCustomMetaDataWriter.CanCreateIndexAsKey(Index: TDBXRowStorage; IndexColumns: TDBXTableStorage): Boolean;
begin
  Result := False;
end;

procedure TDBXMySqlCustomMetaDataWriter.MakeSqlCreateIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage; IndexColumns: TDBXTableStorage);
begin
  if not Index.GetBoolean(TDBXIndexesIndex.IsPrimary, False) then
    inherited MakeSqlCreateIndex(Buffer, Index, IndexColumns)
  else 
  begin
    MakeSqlAlterTablePrefix(Buffer, Index);
    Buffer.Append(TDBXSQL.Add);
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(TDBXSQL.Primary);
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(TDBXSQL.Key);
    Buffer.Append(TDBXSQL.Space);
    MakeSqlCreateIndexColumnList(Buffer, IndexColumns);
    Buffer.Append(TDBXSQL.Semicolon);
    Buffer.Append(TDBXSQL.Nl);
  end;
end;

function TDBXMySqlCustomMetaDataWriter.HasAutoIncrementColumn(Index: TDBXRowStorage): Boolean;
var
  CatalogName: WideString;
  SchemaName: WideString;
  TableName: WideString;
  ColumnsTable: TDBXTableStorage;
  HasAutoIncrement: Boolean;
begin
  CatalogName := Index.GetString(TDBXIndexesIndex.CatalogName, NullString);
  SchemaName := Index.GetString(TDBXIndexesIndex.SchemaName, NullString);
  TableName := Index.GetString(TDBXIndexesIndex.TableName, NullString);
  ColumnsTable := FReader.FetchColumns(CatalogName, SchemaName, TableName);
  HasAutoIncrement := False;
  while ColumnsTable.Next do
  begin
    if ColumnsTable.GetAsBoolean(TDBXColumnsIndex.IsAutoIncrement) then
    begin
      HasAutoIncrement := True;
      break;
    end;
  end;
  ColumnsTable.Close;
  ColumnsTable.Free;
  Result := HasAutoIncrement;
end;

procedure TDBXMySqlCustomMetaDataWriter.MakeSqlDropIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage);
begin
  if Index.GetBoolean(TDBXIndexesIndex.IsPrimary) then
  begin
    if HasAutoIncrementColumn(Index) then
    begin
      
      exit;
    end;
  end;
  MakeSqlAlterTablePrefix(Buffer, Index);
  Buffer.Append(TDBXSQL.Drop);
  Buffer.Append(TDBXSQL.Space);
  if Index.GetBoolean(TDBXIndexesIndex.IsPrimary) then
  begin
    Buffer.Append(TDBXSQL.Primary);
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(TDBXSQL.Key);
  end
  else 
  begin
    Buffer.Append(TDBXSQL.Index);
    Buffer.Append(TDBXSQL.Space);
    MakeSqlIdentifier(Buffer, Index.GetString(TDBXIndexesIndex.IndexName));
  end;
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

procedure TDBXMySqlCustomMetaDataWriter.MakeSqlDropForeignKey(Buffer: TDBXWideStringBuffer; ForeignKey: TDBXRowStorage);
begin
  MakeSqlAlterTablePrefix(Buffer, ForeignKey);
  Buffer.Append(TDBXSQL.Drop);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Foreign);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Key);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlIdentifier(Buffer, ForeignKey.GetString(TDBXForeignKeysIndex.ForeignKeyName));
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

function TDBXMySqlCustomMetaDataWriter.FindCastType(Column: TDBXRowStorage): WideString;
var
  TypeName: WideString;
  DataType: TDBXDataTypeDescription;
  DbType: Integer;
begin
  TypeName := Column.GetString(TDBXColumnsIndex.TypeName);
  DataType := FindDataType(TypeName, Column, nil);
  DbType := DataType.DbxDataType;
  case DbType of
    TDBXDataTypes.AnsiStringType,
    TDBXDataTypes.WideStringType:
      Result := TDBXSQL.Char + TDBXSQL.OpenParen + IntToStr(Column.GetAsInt32(TDBXColumnsIndex.Precision)) + TDBXSQL.CloseParen;
    TDBXDataTypesEx.SingleType,
    TDBXDataTypes.DoubleType,
    TDBXDataTypes.BcdType:
      Result := TDBXSQL.Decimal;
    TDBXDataTypes.TimestampType:
      Result := TDBXSQL.Datetime;
    TDBXDataTypes.TimeType:
      Result := TDBXSQL.Time;
    TDBXDataTypes.DateType:
      Result := TDBXSQL.Date;
    TDBXDataTypes.BooleanType,
    TDBXDataTypesEx.Int8Type,
    TDBXDataTypes.Int16Type,
    TDBXDataTypes.Int32Type,
    TDBXDataTypes.Int64Type:
      Result := TDBXSQL.Signed;
    TDBXDataTypes.BytesType,
    TDBXDataTypes.VarbytesType:
      Result := TDBXSQL.Binary + TDBXSQL.OpenParen + IntToStr(Column.GetAsInt32(TDBXColumnsIndex.Precision)) + TDBXSQL.CloseParen;
    else
      Result := NullString;
  end;
end;

procedure TDBXMySqlCustomMetaDataWriter.MakeSqlColumnTypeCast(Buffer: TDBXWideStringBuffer; Column: TDBXRowStorage);
var
  Original: TDBXRowStorage;
  OldType: WideString;
  NewType: WideString;
  TypeName: WideString;
begin
  Original := Column.OriginalRow;
  OldType := FindCastType(Original);
  NewType := FindCastType(Column);
  if (StringIsNil(NewType)) or (NewType = OldType) then
    MakeSqlIdentifier(Buffer, Original.GetString(TDBXColumnsIndex.ColumnName, NullString))
  else 
  begin
    TypeName := Column.GetString(TDBXColumnsIndex.TypeName);
    if (TypeName = TDBXSQL.FYear) then
    begin
      Buffer.Append(TDBXSQL.FYear);
      Buffer.Append(TDBXSQL.OpenParen);
      Buffer.Append(TDBXSQL.Makedate);
      Buffer.Append(TDBXSQL.OpenParen);
    end;
    Buffer.Append(TDBXSQL.Cast);
    Buffer.Append(TDBXSQL.OpenParen);
    MakeSqlIdentifier(Buffer, Original.GetString(TDBXColumnsIndex.ColumnName, NullString));
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(TDBXSQL.&As);
    Buffer.Append(TDBXSQL.Space);
    MakeSqlDataType(Buffer, Column.GetString(TDBXColumnsIndex.TypeName), Column);
    Buffer.Append(TDBXSQL.CloseParen);
    if (TypeName = TDBXSQL.FYear) then
    begin
      Buffer.Append(TDBXSQL.Comma);
      Buffer.Append(1);
      Buffer.Append(TDBXSQL.CloseParen);
      Buffer.Append(TDBXSQL.CloseParen);
    end;
  end;
end;

constructor TDBXMySqlMetaDataWriter.Create;
begin
  inherited Create;
  Open;
end;

procedure TDBXMySqlMetaDataWriter.Open;
begin
  if FReader = nil then
    FReader := TDBXMySqlMetaDataReader.Create;
end;

function TDBXMySqlMetaDataWriter.GetSqlAutoIncrementKeyword: WideString;
begin
  Result := 'auto_increment primary key';
end;

function TDBXMySqlMetaDataWriter.IsCatalogsSupported: Boolean;
begin
  Result := True;
end;

function TDBXMySqlMetaDataWriter.IsSchemasSupported: Boolean;
begin
  Result := False;
end;

function TDBXMySqlMetaDataWriter.GetAlterTableSupport: Integer;
begin
  Result := TDBXAlterTableOperation.DropColumn or TDBXAlterTableOperation.AddColumn or TDBXAlterTableOperation.DropDefaultValue or TDBXAlterTableOperation.ChangeDefaultValue or TDBXAlterTableOperation.RenameTable;
end;

function TDBXMySqlMetaDataWriter.GetSqlRenameTable: WideString;
begin
  Result := 'RENAME TABLE :SCHEMA_NAME.:TABLE_NAME TO :NEW_SCHEMA_NAME.:NEW_TABLE_NAME';
end;

end.
