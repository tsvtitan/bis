unit DBXDb2ReadOnlyMetaData;
interface
uses
  DBXMetaDataReader,
  DBXMetaDataCommandFactory;
type
  TDBXDb2MetaDataCommandFactory = class(TDBXMetaDataCommandFactory)
  public
    function CreateMetaDataReader: TDBXMetaDataReader; override;
  end;

implementation
uses
  DBXDb2MetaDataReader;

function TDBXDb2MetaDataCommandFactory.CreateMetaDataReader: TDBXMetaDataReader;
begin
  Result := TDBXDb2MetaDataReader.Create;
end;

initialization
  TDBXMetaDataCommandFactory.RegisterMetaDataCommandFactory(TDBXDb2MetaDataCommandFactory);
end.
