unit DBXMsSqlMetaData;

interface

uses
  DBXMetaDataWriterFactory,
  DBXMsSQlMetaDataWriter
  ;


implementation
initialization
  TDBXMetaDataWriterFactory.RegisterWriter('Microsoft SQL Server', TDBXMsSqlMetaDataWriter);
end.
