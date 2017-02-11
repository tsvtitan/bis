unit DbxDefaultDrivers;

interface

{$HPPEMIT ''}
{$HPPEMIT '/* Link in the following obj files for C++ */'}
{$HPPEMIT '#pragma link "DbxTrace.obj"'}
{$HPPEMIT '#pragma link "DBXPool.obj"'}
{$HPPEMIT '#pragma link "DbxClient.obj"'}
{$HPPEMIT '#pragma link "DbxDynalink.obj"'}
{$HPPEMIT '#pragma link "DbxInformixReadOnlyMetaData.obj"'}
{$HPPEMIT '#pragma link "DbxInterbaseReadOnlyMetaData.obj"'}
//{$HPPEMIT '#pragma link "DbxFirebirdReadOnlyMetaData.obj"'}
{$HPPEMIT '#pragma link "DbxDb2ReadOnlyMetaData.obj"'}
{$HPPEMIT '#pragma link "DbxMsSqlReadOnlyMetaData.obj"'}
{$HPPEMIT '#pragma link "DbxMySqlReadOnlyMetaData.obj"'}
{$HPPEMIT '#pragma link "DbxOracleReadOnlyMetaData.obj"'}
{$HPPEMIT '#pragma link "DbxSybaseASAReadOnlyMetaData.obj"'}
{$HPPEMIT '#pragma link "DbxSybaseASEReadOnlyMetaData.obj"'}
{$HPPEMIT ''}


implementation

// Temporary until connection editor can add these directly into
// a form or datamodule.
//
uses
  DbxCommon,
  DbxTrace,
  DBXPool,
{$IFNDEF CLR}
  DbxClient,
{$ENDIF}
  DbxDynalink,
  DbxInformixReadOnlyMetaData,
  DbxInterbaseReadOnlyMetaData,
  //DbxFirebirdReadOnlyMetaData,
  DbxDb2ReadOnlyMetaData,
  DbxMsSqlReadOnlyMetaData,
  DbxMySqlReadOnlyMetaData,
  DbxOracleReadOnlyMetaData,
  DbxSybaseASAReadOnlyMetaData,
  DbxSybaseASEReadOnlyMetaData;

end.

