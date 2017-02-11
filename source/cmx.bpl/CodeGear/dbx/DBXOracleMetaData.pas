unit DBXOracleMetaData;

interface

uses
  DBXMetaDataWriterFactory,
  DBXOracleMetaDataWriter
  ;


implementation
initialization
  TDBXMetaDataWriterFactory.RegisterWriter('Oracle', TDBXOracleMetaDataWriter); {Do not localize}
end.
