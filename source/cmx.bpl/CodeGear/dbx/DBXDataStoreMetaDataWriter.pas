{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXDataStoreMetaDataWriter;
interface
uses
  DBXMetaDataReader,
  DBXMetaDataWriter,
  DBXPlatform,
  DBXPlatformUtil,
  DBXTableStorage;
type
  TDBXDataStoreCustomMetaDataWriter = class(TDBXBaseMetaDataWriter)
  protected
    procedure MakeSqlDataType(Buffer: TDBXWideStringBuffer; DataType: TDBXDataTypeDescription; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s); override;
  end;

  TDBXDataStoreMetaDataWriter = class(TDBXDataStoreCustomMetaDataWriter)
  public
    constructor Create;
    procedure Open; override;
  protected
    function IsCatalogsSupported: Boolean; override;
    function IsSchemasSupported: Boolean; override;
    function IsMultipleStatementsSupported: Boolean; override;
    function GetAlterTableSupport: Integer; override;
    function GetSqlAutoIncrementKeyword: WideString; override;
    function GetSqlKeyGeneratedIndexName: WideString; override;
  end;

implementation
uses
  DBXCommon,
  DBXDataStoreMetaDataReader,
  DBXMetaDataNames;

procedure TDBXDataStoreCustomMetaDataWriter.MakeSqlDataType(Buffer: TDBXWideStringBuffer; DataType: TDBXDataTypeDescription; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s);
begin
  if ((DataType.DbxDataType = TDBXDataTypes.WideStringType) or (DataType.DbxDataType = TDBXDataTypes.BlobType)) and ColumnRow.GetBoolean(TDBXColumnsIndex.IsLong, False) then
    Buffer.Append(DataType.TypeName)
  else 
    inherited MakeSqlDataType(Buffer, DataType, ColumnRow, Overrides);
end;

constructor TDBXDataStoreMetaDataWriter.Create;
begin
  inherited Create;
  Open;
end;

procedure TDBXDataStoreMetaDataWriter.Open;
begin
  if FReader = nil then
    FReader := TDBXDataStoreMetaDataReader.Create;
end;

function TDBXDataStoreMetaDataWriter.IsCatalogsSupported: Boolean;
begin
  Result := False;
end;

function TDBXDataStoreMetaDataWriter.IsSchemasSupported: Boolean;
begin
  Result := True;
end;

function TDBXDataStoreMetaDataWriter.IsMultipleStatementsSupported: Boolean;
begin
  Result := False;
end;

function TDBXDataStoreMetaDataWriter.GetAlterTableSupport: Integer;
begin
  Result := TDBXAlterTableOperation.FullAlterSupport;
end;

function TDBXDataStoreMetaDataWriter.GetSqlAutoIncrementKeyword: WideString;
begin
  Result := 'AUTOINCREMENT';
end;

function TDBXDataStoreMetaDataWriter.GetSqlKeyGeneratedIndexName: WideString;
begin
  Result := '_IDX';
end;

end.
