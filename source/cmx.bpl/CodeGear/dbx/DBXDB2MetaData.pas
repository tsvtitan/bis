unit DBXDb2MetaData;

interface

uses
  DBXMetaDataWriterFactory,
  DBXDb2MetaDataWriter
  ;


implementation
initialization
  TDBXMetaDataWriterFactory.RegisterWriter('Db2', TDBXDb2MetaDataWriter);
end.
