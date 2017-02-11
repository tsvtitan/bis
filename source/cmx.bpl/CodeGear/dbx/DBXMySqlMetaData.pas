unit DBXMySqlMetaData;

interface

uses
  DBXMetaDataWriterFactory,
  DBXMySqlMetaDataWriter
  ;


implementation
initialization
  TDBXMetaDataWriterFactory.RegisterWriter('MySQL', TDBXMySqlMetaDataWriter);
end.
