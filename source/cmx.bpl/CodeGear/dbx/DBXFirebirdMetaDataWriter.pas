{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXFirebirdMetaDataWriter;
interface
uses
  DBXMetaDataReader,
  DBXMetaDataWriter,
  DBXPlatform,
  DBXPlatformUtil,
  DBXTableStorage;
type
  TDBXFirebirdCustomMetaDataWriter = class(TDBXBaseMetaDataWriter)
  protected
    procedure MakeSqlDataType(Buffer: TDBXWideStringBuffer; DataType: TDBXDataTypeDescription; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s); override;
  private
    procedure FormatStringType(Buffer: TDBXWideStringBuffer; DataType: TDBXDataTypeDescription; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s);
    procedure FormatBlobType(Buffer: TDBXWideStringBuffer; DataType: TDBXDataTypeDescription; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s);
    function UnicodeSpecificationRequired(ColumnRow: TDBXRowStorage): Boolean;
  end;

  TDBXFirebirdMetaDataWriter = class(TDBXFirebirdCustomMetaDataWriter)
  public
    constructor Create;
    procedure Open; override;
  protected
    function IsIndexNamesGlobal: Boolean; override;
    function IsSerializedIsolationSupported: Boolean; override;
    function IsMixed_DDL_DML_Supported: Boolean; override;
    function GetAlterTableSupport: Integer; override;
    function GetSqlKeyGeneratedIndexName: WideString; override;
    function IsSchemasSupported: Boolean; override;
  end;

implementation
uses
  DBXCommon,
  DBXFirebirdMetaDataReader,
  DBXMetaDataNames,
  SysUtils;

procedure TDBXFirebirdCustomMetaDataWriter.MakeSqlDataType(Buffer: TDBXWideStringBuffer; DataType: TDBXDataTypeDescription; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s);
begin
  case DataType.DbxDataType of
    TDBXDataTypes.AnsiStringType:
      FormatStringType(Buffer, DataType, ColumnRow, Overrides);
    TDBXDataTypes.BlobType:
      FormatBlobType(Buffer, DataType, ColumnRow, Overrides);
    else
      inherited MakeSqlDataType(Buffer, DataType, ColumnRow, Overrides);
  end;
end;

procedure TDBXFirebirdCustomMetaDataWriter.FormatStringType(Buffer: TDBXWideStringBuffer; DataType: TDBXDataTypeDescription; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s);
var
  Precision: Integer;
begin
  Precision := Overrides[0];
  if Precision < 0 then
    Precision := ColumnRow.GetInt32(TDBXColumnsIndex.Precision, -1);
  if ColumnRow.GetBoolean(TDBXColumnsIndex.IsFixedLength, False) then
    Buffer.Append('CHAR')
  else 
    Buffer.Append('VARCHAR');
  if Precision > 0 then
  begin
    Buffer.Append('(');
    Buffer.Append(IntToStr(Precision));
    Buffer.Append(')');
  end;
  if UnicodeSpecificationRequired(ColumnRow) then
    Buffer.Append(' CHARACTER SET UNICODE_FSS');
end;

procedure TDBXFirebirdCustomMetaDataWriter.FormatBlobType(Buffer: TDBXWideStringBuffer; DataType: TDBXDataTypeDescription; ColumnRow: TDBXRowStorage; const Overrides: TDBXInt32s);
var
  Subtype: WideString;
  UnicodeSpecRequired: Boolean;
begin
  Subtype := '0';
  UnicodeSpecRequired := False;
  case ColumnRow.GetInt32(TDBXColumnsIndex.DbxDataType, TDBXDataTypes.BlobType) of
    TDBXDataTypes.AnsiStringType:
      begin
        UnicodeSpecRequired := UnicodeSpecificationRequired(ColumnRow);
        Subtype := '1';
      end;
    TDBXDataTypes.WideStringType:
      begin
        UnicodeSpecRequired := UnicodeSpecificationRequired(ColumnRow);
        Subtype := 'TEXT';
      end;
  end;
  Buffer.Append('BLOB SUB_TYPE ');
  Buffer.Append(Subtype);
  if UnicodeSpecRequired then
    Buffer.Append(' CHARACTER SET UNICODE_FSS');
end;

function TDBXFirebirdCustomMetaDataWriter.UnicodeSpecificationRequired(ColumnRow: TDBXRowStorage): Boolean;
begin
  Result := ColumnRow.GetBoolean(TDBXColumnsIndex.IsUnicode);
end;

constructor TDBXFirebirdMetaDataWriter.Create;
begin
  inherited Create;
  Open;
end;

procedure TDBXFirebirdMetaDataWriter.Open;
begin
  if FReader = nil then
    FReader := TDBXFirebirdMetaDataReader.Create;
end;

function TDBXFirebirdMetaDataWriter.IsIndexNamesGlobal: Boolean;
begin
  Result := True;
end;

function TDBXFirebirdMetaDataWriter.IsSerializedIsolationSupported: Boolean;
begin
  Result := False;
end;

function TDBXFirebirdMetaDataWriter.IsMixed_DDL_DML_Supported: Boolean;
begin
  Result := False;
end;

function TDBXFirebirdMetaDataWriter.GetAlterTableSupport: Integer;
begin
  Result := TDBXAlterTableOperation.DropColumn or TDBXAlterTableOperation.AddColumn or TDBXAlterTableOperation.ChangeColumnType or TDBXAlterTableOperation.ChangeColumnPosition or TDBXAlterTableOperation.RenameColumn;
end;

function TDBXFirebirdMetaDataWriter.GetSqlKeyGeneratedIndexName: WideString;
begin
  Result := '';
end;

function TDBXFirebirdMetaDataWriter.IsSchemasSupported: Boolean;
begin
  Result := False;
end;

end.
