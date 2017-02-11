unit ADOPlatformTypeNames;

interface
uses
  DBXMetaDataReader;

type
  TADOPlatformTypeNames = class(TDBXPlatformTypeNames)
  public
    function GetPlatformTypeName(const DataType: Integer; const IsUnsigned: Boolean): WideString; override;
  end;

implementation
uses
  DBXCommon,
  DBXTableStorage,
  DBXPlatformUtil;

resourcestring
  UnknownDataType = 'Unknown Data Type';

function TADOPlatformTypeNames.GetPlatformTypeName(const DataType: Integer; const IsUnsigned: Boolean): WideString;
begin
  case DataType of
    TDBXDataTypesEx.Uint8Type:
      Result := 'System.Byte';
    TDBXDataTypesEx.Int8Type:
      Result := 'System.SByte';
    TDBXDataTypes.Int16Type:
      Result := 'System.Int16';
    TDBXDataTypes.Int32Type:
      Result := 'System.Int32';
    TDBXDataTypes.Int64Type:
      Result := 'System.Int64';
    TDBXDataTypes.BooleanType:
      Result := 'System.Boolean';
    TDBXDataTypes.DateType,
    TDBXDataTypes.TimeType,
    TDBXDataTypes.TimeStampType:
      Result := 'System.DateTime';
    TDBXDataTypesEx.IntervalType:
      Result := 'System.TimeSpan';
    TDBXDataTypes.AnsiStringType,
    TDBXDataTypes.WideStringType:
      Result := 'System.String';
    TDBXDataTypes.BcdType:
      Result := 'System.Decimal';
    TDBXDataTypesEx.SingleType:
      Result := 'System.Single';
    TDBXDataTypes.DoubleType:
      Result := 'System.Double';
    TDBXDataTypes.VarBytesType,
    TDBXDataTypes.BytesType,
    TDBXDataTypes.BlobType:
      Result := 'System.Byte[]';
    TDBXDataTypesEx.ObjectType:
      Result := 'System.Object';
    else
      raise Exception.Create(UnknownDataType);
  end;
end;

end.
