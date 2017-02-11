unit DBXFirebirdReadOnlyMetaData;
interface
uses
  DBXMetaDataReader,
  DBXMetaDataCommandFactory;
type
  TDBXFirebirdMetaDataCommandFactory = class(TDBXMetaDataCommandFactory)
  public
    function CreateMetaDataReader: TDBXMetaDataReader; override;
  end;

implementation
uses
  DBXFirebirdMetaDataReader;

function TDBXFirebirdMetaDataCommandFactory.CreateMetaDataReader: TDBXMetaDataReader;
begin
  Result := TDBXFirebirdMetaDataReader.Create;
end;

initialization
  TDBXMetaDataCommandFactory.RegisterMetaDataCommandFactory(TDBXFirebirdMetaDataCommandFactory);
end.
