unit DBXInterbaseMetaData;

interface

uses
  DBXMetaDataWriterFactory,
  DBXInterbaseMetaDataWriter
  ;


implementation
initialization
  TDBXMetaDataWriterFactory.RegisterWriter('Interbase', TDBXInterbaseMetaDataWriter);
end.
