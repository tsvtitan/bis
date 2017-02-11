{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXSybaseASAMetaDataWriter;
interface
uses
  DBXMetaDataWriter,
  DBXPlatformUtil,
  DBXTableStorage;
type
  TDBXSybaseASACustomMetaDataWriter = class(TDBXBaseMetaDataWriter)
  protected
    procedure MakeSqlNullable(Buffer: TDBXWideStringBuffer; Column: TDBXRowStorage); override;
    procedure MakeSqlDropSecondaryIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage); override;
  end;

  TDBXSybaseASAMetaDataWriter = class(TDBXSybaseASACustomMetaDataWriter)
  public
    constructor Create;
    procedure Open; override;
  protected
    function IsCatalogsSupported: Boolean; override;
    function IsSchemasSupported: Boolean; override;
    function IsSerializedIsolationSupported: Boolean; override;
    function IsMultipleStatementsSupported: Boolean; override;
    function IsDDLTransactionsSupported: Boolean; override;
    function IsDescendingIndexConstraintsSupported: Boolean; override;
    function GetSqlAutoIncrementKeyword: WideString; override;
    function GetSqlRenameTable: WideString; override;
  end;

implementation
uses
  DBXMetaDataNames,
  DBXSybaseASAMetaDataReader;

procedure TDBXSybaseASACustomMetaDataWriter.MakeSqlNullable(Buffer: TDBXWideStringBuffer; Column: TDBXRowStorage);
begin
  if not Column.GetBoolean(TDBXColumnsIndex.IsNullable, True) then
  begin
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(TDBXSQL.&Not);
  end;
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Nullable);
end;

procedure TDBXSybaseASACustomMetaDataWriter.MakeSqlDropSecondaryIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage);
var
  Original: TDBXRowStorage;
begin
  Original := Index.OriginalRow;
  Buffer.Append(TDBXSQL.Drop);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Index);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlIdentifier(Buffer, Original.GetString(TDBXIndexesIndex.SchemaName, NullString));
  Buffer.Append(TDBXSQL.Dot);
  MakeSqlIdentifier(Buffer, Original.GetString(TDBXIndexesIndex.TableName, NullString));
  Buffer.Append(TDBXSQL.Dot);
  MakeSqlIdentifier(Buffer, Original.GetString(TDBXIndexesIndex.IndexName, NullString));
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

constructor TDBXSybaseASAMetaDataWriter.Create;
begin
  inherited Create;
  Open;
end;

procedure TDBXSybaseASAMetaDataWriter.Open;
begin
  if FReader = nil then
    FReader := TDBXSybaseASAMetaDataReader.Create;
end;

function TDBXSybaseASAMetaDataWriter.IsCatalogsSupported: Boolean;
begin
  Result := False;
end;

function TDBXSybaseASAMetaDataWriter.IsSchemasSupported: Boolean;
begin
  Result := True;
end;

function TDBXSybaseASAMetaDataWriter.IsSerializedIsolationSupported: Boolean;
begin
  Result := False;
end;

function TDBXSybaseASAMetaDataWriter.IsMultipleStatementsSupported: Boolean;
begin
  Result := False;
end;

function TDBXSybaseASAMetaDataWriter.IsDDLTransactionsSupported: Boolean;
begin
  Result := False;
end;

function TDBXSybaseASAMetaDataWriter.IsDescendingIndexConstraintsSupported: Boolean;
begin
  Result := False;
end;

function TDBXSybaseASAMetaDataWriter.GetSqlAutoIncrementKeyword: WideString;
begin
  Result := 'DEFAULT AUTOINCREMENT';
end;

function TDBXSybaseASAMetaDataWriter.GetSqlRenameTable: WideString;
begin
  Result := 'ALTER TABLE :SCHEMA_NAME.:TABLE_NAME RENAME :NEW_TABLE_NAME';
end;

end.
