unit DBXInterbaseReadOnlyMetaData;
interface
uses
  DBXMetaDataReader,
  DBXMetaDataCommandFactory;
type
  TDBXInterbaseMetaDataCommandFactory = class(TDBXMetaDataCommandFactory)
  public
    function CreateMetaDataReader: TDBXMetaDataReader; override;
  end;

implementation
uses
  DBXInterbaseMetaDataReader;

function TDBXInterbaseMetaDataCommandFactory.CreateMetaDataReader: TDBXMetaDataReader;
begin
  Result := TDBXInterbaseMetaDataReader.Create;
end;

initialization
  TDBXMetaDataCommandFactory.RegisterMetaDataCommandFactory(TDBXInterbaseMetaDataCommandFactory);
end.
