{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXMsSqlMetaDataWriter;
interface
uses
  DBXMetaDataWriter,
  DBXPlatformUtil,
  DBXTableStorage;
type
  TDBXMsSqlCustomMetaDataWriter = class(TDBXBaseMetaDataWriter)
  protected
    procedure MakeSqlDropSecondaryIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage); override;
  end;

  TDBXMsSqlMetaDataWriter = class(TDBXMsSqlCustomMetaDataWriter)
  public
    constructor Create;
    procedure Open; override;
  protected
    function GetSqlAutoIncrementKeyword: WideString; override;
    function GetSqlAutoIncrementInserts: WideString; override;
    function GetSqlRenameTable: WideString; override;
    function IsCatalogsSupported: Boolean; override;
    function IsSchemasSupported: Boolean; override;
    function IsMultipleStatementsSupported: Boolean; override;
  end;

implementation
uses
  DBXMetaDataNames,
  DBXMsSqlMetaDataReader;

procedure TDBXMsSqlCustomMetaDataWriter.MakeSqlDropSecondaryIndex(Buffer: TDBXWideStringBuffer; Index: TDBXRowStorage);
var
  Version: WideString;
  Original: TDBXRowStorage;
begin
  Version := FReader.Version;
  if Version >= '09.00.0000' then
    inherited MakeSqlDropSecondaryIndex(Buffer, Index)
  else 
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
end;

constructor TDBXMsSqlMetaDataWriter.Create;
begin
  inherited Create;
  Open;
end;

procedure TDBXMsSqlMetaDataWriter.Open;
begin
  if FReader = nil then
    FReader := TDBXMsSqlMetaDataReader.Create;
end;

function TDBXMsSqlMetaDataWriter.GetSqlAutoIncrementKeyword: WideString;
begin
  Result := 'IDENTITY';
end;

function TDBXMsSqlMetaDataWriter.GetSqlAutoIncrementInserts: WideString;
begin
  Result := 'IDENTITY_INSERT';
end;

function TDBXMsSqlMetaDataWriter.GetSqlRenameTable: WideString;
begin
  Result := 'EXEC sp_rename '':SCHEMA_NAME.:TABLE_NAME'', '':NEW_TABLE_NAME'', ''OBJECT''';
end;

function TDBXMsSqlMetaDataWriter.IsCatalogsSupported: Boolean;
begin
  Result := True;
end;

function TDBXMsSqlMetaDataWriter.IsSchemasSupported: Boolean;
begin
  Result := True;
end;

function TDBXMsSqlMetaDataWriter.IsMultipleStatementsSupported: Boolean;
begin
  Result := True;
end;

end.
