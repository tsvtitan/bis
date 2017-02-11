unit DBXDataStoreMetaData;

interface

uses
  DBXMetaDataWriterFactory,
  DBXDataStoreMetaDataWriter
  ;


implementation
initialization
  TDBXMetaDataWriterFactory.RegisterWriter('BlackfishSQL', TDBXDataStoreMetaDataWriter);
end.
