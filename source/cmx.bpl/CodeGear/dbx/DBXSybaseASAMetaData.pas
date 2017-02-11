unit DBXSybaseASAMetaData;

interface

uses
  DBXMetaDataWriterFactory,
  DBXSybaseASAMetaDataWriter
  ;


implementation
initialization
  TDBXMetaDataWriterFactory.RegisterWriter('Adaptive Server Anywhere', TDBXSybaseASAMetaDataWriter); {Do not localize}
end.
