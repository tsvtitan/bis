unit DBXFirebirdMetaData;

interface

uses
  DBXMetaDataWriterFactory,
  DBXFirebirdMetaDataWriter
  ;


implementation
initialization
  TDBXMetaDataWriterFactory.RegisterWriter('Firebird', TDBXFirebirdMetaDataWriter);
end.
