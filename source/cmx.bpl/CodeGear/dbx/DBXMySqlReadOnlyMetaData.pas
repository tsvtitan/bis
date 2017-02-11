unit DBXMySqlReadOnlyMetaData;
interface
uses
  DBXMetaDataReader,
  DBXMetaDataCommandFactory;
type
  TDBXMySqlMetaDataCommandFactory = class(TDBXMetaDataCommandFactory)
  public
    function CreateMetaDataReader: TDBXMetaDataReader; override;
  end;

implementation
uses
  DBXMySqlMetaDataReader;

function TDBXMySqlMetaDataCommandFactory.CreateMetaDataReader: TDBXMetaDataReader;
begin
  Result := TDBXMySqlMetaDataReader.Create;
end;

initialization
  TDBXMetaDataCommandFactory.RegisterMetaDataCommandFactory(TDBXMySqlMetaDataCommandFactory);
end.
