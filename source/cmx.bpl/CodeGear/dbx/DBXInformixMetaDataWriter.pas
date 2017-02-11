{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXInformixMetaDataWriter;
interface
uses
  DBXMetaDataWriter,
  DBXPlatformUtil,
  DBXTableStorage;
type
  TDBXInformixCustomMetaDataWriter = class(TDBXBaseMetaDataWriter)
  protected
    procedure MakeSqlCreateKey(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage; IndexColumns: TDBXTableStorage); override;
    procedure MakeSqlCreateForeignKey(Buffer: TDBXWideStringBuffer; ForeignKey: TDBXRowStorage; ForeignKeyColumns: TDBXTableStorage); override;
    procedure MakeSqlDropSecondaryIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage); override;
  end;

  TDBXInformixMetaDataWriter = class(TDBXInformixCustomMetaDataWriter)
  public
    constructor Create;
    procedure Open; override;
  protected
    function GetSqlAutoIncrementKeyword: WideString; override;
    function GetSqlRenameTable: WideString; override;
    function IsSchemasSupported: Boolean; override;
    function IsMultipleStatementsSupported: Boolean; override;
    function IsDescendingIndexConstraintsSupported: Boolean; override;
  end;

implementation
uses
  DBXInformixMetaDataReader,
  DBXMetaDataNames;

procedure TDBXInformixCustomMetaDataWriter.MakeSqlCreateKey(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage; IndexColumns: TDBXTableStorage);
begin
  MakeSqlAlterTablePrefix(Buffer, Index);
  Buffer.Append(TDBXSQL.Add);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Constraint);
  Buffer.Append(TDBXSQL.Space);
  if Index.GetBoolean(TDBXIndexesIndex.IsPrimary, False) then
  begin
    Buffer.Append(TDBXSQL.Primary);
    Buffer.Append(TDBXSQL.Space);
    Buffer.Append(TDBXSQL.Key);
  end
  else 
    Buffer.Append(TDBXSQL.Unique);
  MakeSqlCreateIndexColumnList(Buffer, IndexColumns);
  MakeSqlConstraintName(Buffer, Index);
end;

procedure TDBXInformixCustomMetaDataWriter.MakeSqlCreateForeignKey(Buffer: TDBXWideStringBuffer; ForeignKey: TDBXRowStorage; ForeignKeyColumns: TDBXTableStorage);
begin
  MakeSqlAlterTablePrefix(Buffer, ForeignKey);
  Buffer.Append(TDBXSQL.Add);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Constraint);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlForeignKeySyntax(Buffer, ForeignKey, ForeignKeyColumns);
  MakeSqlConstraintName(Buffer, ForeignKey);
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

procedure TDBXInformixCustomMetaDataWriter.MakeSqlDropSecondaryIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage);
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
  MakeSqlIdentifier(Buffer, Original.GetString(TDBXIndexesIndex.IndexName, NullString));
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

constructor TDBXInformixMetaDataWriter.Create;
begin
  inherited Create;
  Open;
end;

procedure TDBXInformixMetaDataWriter.Open;
begin
  if FReader = nil then
    FReader := TDBXInformixMetaDataReader.Create;
end;

function TDBXInformixMetaDataWriter.GetSqlAutoIncrementKeyword: WideString;
begin
  Result := 'IDENTITY';
end;

function TDBXInformixMetaDataWriter.GetSqlRenameTable: WideString;
begin
  Result := 'RENAME TABLE :SCHEMA_NAME.:TABLE_NAME TO :NEW_SCHEMA_NAME:NEW_TABLE_NAME';
end;

function TDBXInformixMetaDataWriter.IsSchemasSupported: Boolean;
begin
  Result := True;
end;

function TDBXInformixMetaDataWriter.IsMultipleStatementsSupported: Boolean;
begin
  Result := False;
end;

function TDBXInformixMetaDataWriter.IsDescendingIndexConstraintsSupported: Boolean;
begin
  Result := False;
end;

end.
