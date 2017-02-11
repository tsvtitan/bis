unit DBXMsSqlReadOnlyMetaData;
interface
uses
  DBXMetaDataReader,
  DBXMetaDataCommandFactory;
type
  TDBXMsSqlMetaDataCommandFactory = class(TDBXMetaDataCommandFactory)
  public
    function CreateMetaDataReader: TDBXMetaDataReader; override;
  end;

implementation
uses
  DBXMsSqlMetaDataReader;

function TDBXMsSqlMetaDataCommandFactory.CreateMetaDataReader: TDBXMetaDataReader;
begin
  Result := TDBXMsSqlMetaDataReader.Create;
end;

initialization
  TDBXMetaDataCommandFactory.RegisterMetaDataCommandFactory(TDBXMsSqlMetaDataCommandFactory);
end.
