unit DBXInformixMetaData;

interface

uses
  DBXMetaDataWriterFactory,
  DBXInformixMetaDataWriter
  ;


implementation
initialization
  TDBXMetaDataWriterFactory.RegisterWriter('Informix Dynamic Server', TDBXInformixMetaDataWriter);
end.
