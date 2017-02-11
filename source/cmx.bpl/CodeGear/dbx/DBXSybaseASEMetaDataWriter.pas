{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXSybaseASEMetaDataWriter;
interface
uses
  DBXMetaDataWriter,
  DBXPlatformUtil,
  DBXTableStorage;
type
  TDBXSybaseASECustomMetaDataWriter = class(TDBXBaseMetaDataWriter)
  public
    procedure MakeSqlCreate(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage; Parts: TDBXTableStorage); override;
    procedure MakeSqlAlter(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage; Parts: TDBXTableStorage); override;
    procedure MakeSqlDrop(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage); override;
  protected
    procedure MakeSqlColumnTypeCast(Buffer: TDBXWideStringBuffer; Column: TDBXRowStorage); override;
    procedure MakeSqlDropSecondaryIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage); override;
  private
    const SetQuotedIdentifiersOn = 'SET QUOTED_IDENTIFIER ON;'#$a;
  end;

  TDBXSybaseASEMetaDataWriter = class(TDBXSybaseASECustomMetaDataWriter)
  public
    constructor Create;
    procedure Open; override;
  protected
    function GetSqlAutoIncrementKeyword: WideString; override;
    function GetSqlAutoIncrementInserts: WideString; override;
    function IsCatalogsSupported: Boolean; override;
    function IsSchemasSupported: Boolean; override;
    function IsSerializedIsolationSupported: Boolean; override;
    function IsMultipleStatementsSupported: Boolean; override;
    function IsDDLTransactionsSupported: Boolean; override;
    function GetSqlRenameTable: WideString; override;
  end;

implementation
uses
  DBXMetaDataNames,
  DBXSybaseASEMetaDataReader;

procedure TDBXSybaseASECustomMetaDataWriter.MakeSqlCreate(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage; Parts: TDBXTableStorage);
begin
  Buffer.Append(SetQuotedIdentifiersOn);
  inherited MakeSqlCreate(Buffer, Item, Parts);
end;

procedure TDBXSybaseASECustomMetaDataWriter.MakeSqlAlter(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage; Parts: TDBXTableStorage);
begin
  Buffer.Append(SetQuotedIdentifiersOn);
  inherited MakeSqlAlter(Buffer, Item, Parts);
end;

procedure TDBXSybaseASECustomMetaDataWriter.MakeSqlDrop(Buffer: TDBXWideStringBuffer; Item: TDBXRowStorage);
begin
  Buffer.Append(SetQuotedIdentifiersOn);
  inherited MakeSqlDrop(Buffer, Item);
end;

procedure TDBXSybaseASECustomMetaDataWriter.MakeSqlColumnTypeCast(Buffer: TDBXWideStringBuffer; Column: TDBXRowStorage);
var
  Original: TDBXRowStorage;
begin
  Original := Column.OriginalRow;
  Buffer.Append(TDBXSQL.Convert);
  Buffer.Append(TDBXSQL.OpenParen);
  MakeSqlDataType(Buffer, Column.GetString(TDBXColumnsIndex.TypeName), Column);
  Buffer.Append(TDBXSQL.Comma);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlIdentifier(Buffer, Original.GetString(TDBXColumnsIndex.ColumnName, NullString));
  Buffer.Append(TDBXSQL.CloseParen);
end;

procedure TDBXSybaseASECustomMetaDataWriter.MakeSqlDropSecondaryIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage);
var
  Original: TDBXRowStorage;
begin
  Original := Index.OriginalRow;
  Buffer.Append(TDBXSQL.Drop);
  Buffer.Append(TDBXSQL.Space);
  Buffer.Append(TDBXSQL.Index);
  Buffer.Append(TDBXSQL.Space);
  MakeSqlIdentifier(Buffer, Original.GetString(TDBXIndexesIndex.TableName, NullString));
  Buffer.Append(TDBXSQL.Dot);
  MakeSqlIdentifier(Buffer, Original.GetString(TDBXIndexesIndex.IndexName, NullString));
  Buffer.Append(TDBXSQL.Semicolon);
  Buffer.Append(TDBXSQL.Nl);
end;

constructor TDBXSybaseASEMetaDataWriter.Create;
begin
  inherited Create;
  Open;
end;

procedure TDBXSybaseASEMetaDataWriter.Open;
begin
  if FReader = nil then
    FReader := TDBXSybaseASEMetaDataReader.Create;
end;

function TDBXSybaseASEMetaDataWriter.GetSqlAutoIncrementKeyword: WideString;
begin
  Result := 'IDENTITY';
end;

function TDBXSybaseASEMetaDataWriter.GetSqlAutoIncrementInserts: WideString;
begin
  Result := 'IDENTITY_INSERT';
end;

function TDBXSybaseASEMetaDataWriter.IsCatalogsSupported: Boolean;
begin
  Result := False;
end;

function TDBXSybaseASEMetaDataWriter.IsSchemasSupported: Boolean;
begin
  Result := True;
end;

function TDBXSybaseASEMetaDataWriter.IsSerializedIsolationSupported: Boolean;
begin
  Result := False;
end;

function TDBXSybaseASEMetaDataWriter.IsMultipleStatementsSupported: Boolean;
begin
  Result := False;
end;

function TDBXSybaseASEMetaDataWriter.IsDDLTransactionsSupported: Boolean;
begin
  Result := False;
end;

function TDBXSybaseASEMetaDataWriter.GetSqlRenameTable: WideString;
begin
  Result := 'EXEC sp_rename '':SCHEMA_NAME.:TABLE_NAME'', '':NEW_TABLE_NAME'', ''OBJECT''';
end;

end.
