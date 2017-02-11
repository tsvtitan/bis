unit DBXMetaDataWriterFactory;

interface

uses
  DBXCommon,
  SysUtils,
  DBXMetaDataProvider,
  ClassRegistry,
{$IFNDEF CLR}
  WideStrings,
{$ENDIF}
  DbxMetaDataWriter,
  DBXDataStoreMetaDataWriter,
  DBXDb2MetaDataWriter,
  DBXInformixMetaDataWriter,
  DBXInterbaseMetaDataWriter,
  DBXFirebirdMetaDataWriter,
  DBXMsSqlMetaDataWriter,
  DBXMySqlMetaDataWriter,
  DBXOracleMetaDataWriter,
  DBXSybaseASAMetaDataWriter,
  DBXSybaseASEMetaDataWriter;

const
  SWriterPrefix = 'Borland.MetaDataWriter.';

resourcestring
  SNoMetadataProvider = 'Cannot load metadata for %s.';

type
  TDBXMetaDataWriterFactory = class
  private
    class var FProviderRegistry: TWideStringList;
  public
    class procedure RegisterWriter(DialectName: String; WriterClass: TClass);
    class procedure FreeWriterRegistry;
    class function CreateWriter(DialectName: String): TDBXMetaDataWriter;

  end;

implementation

type
  TWriterItem = class
    private
      FClass: TClass;
      constructor Create(WriterClass: TClass);
  end;


{ TDBXMetaDataWriterFactory }

class function TDBXMetaDataWriterFactory.CreateWriter(
  DialectName: String): TDBXMetaDataWriter;
var
  WriterItem: TWriterItem;
  Index: Integer;
begin
  Index := FProviderRegistry.IndexOf(DialectName);
  if Index < 0 then
  begin
    raise TDBXError.Create(TDBXErrorCodes.DriverInitFailed, Wideformat(SNoMetadataProvider, [DialectName]));
  end;
  WriterItem := FProviderRegistry.Objects[Index] as TWriterItem;;
  Result := TClassRegistry.GetClassRegistry
{$IFDEF CLR}
            .CreateInstance('Borland.Data.'+WriterItem.FClass.ClassName)  { Do not resource }
{$ELSE}
            .CreateInstance(WriterItem.FClass.ClassName)
{$ENDIF}
             as TDBXMetaDataWriter;
  Result.Open;
end;

class procedure TDBXMetaDataWriterFactory.FreeWriterRegistry;
  var
    Index: Integer;
  begin
    for Index := 0 to FProviderRegistry.Count - 1 do
      FProviderRegistry.Objects[Index].Free;
    FProviderRegistry.Free;
    FProviderRegistry := nil;
  end;

class procedure TDBXMetaDataWriterFactory.RegisterWriter(
  DialectName: String;
  WriterClass: TClass);
var
  ClassRegistry: TClassRegistry;
begin
  FProviderRegistry.AddObject(DialectName, TWriterItem.Create(WriterClass));
  ClassRegistry := TClassRegistry.GetClassRegistry;
{$IFDEF CLR}
  ClassRegistry.RegisterClass('Borland.Data.'+WriterClass.ClassName, WriterClass); { Do not resource }
{$ELSE}
  ClassRegistry.RegisterClass(WriterClass.ClassName, WriterClass);
{$ENDIF}
end;

{ TWriterItem }

constructor TWriterItem.Create(WriterClass: TClass);
begin
  FClass := WriterClass;
  inherited Create;
end;

initialization
  TDBXMetaDataWriterFactory.FProviderRegistry := TWideStringList.Create;
finalization
  TDBXMetaDataWriterFactory.FreeWriterRegistry;

end.
