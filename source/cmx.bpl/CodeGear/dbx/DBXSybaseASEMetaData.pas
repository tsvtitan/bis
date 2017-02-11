unit DBXSybaseASEMetaData;

interface

uses
  DBXMetaDataWriterFactory,
  DBXSybaseASEMetaDataWriter
  ;


implementation
initialization
  TDBXMetaDataWriterFactory.RegisterWriter('Sybase SQL Server', TDBXSybaseASEMetaDataWriter); {Do not localize}
end.
