{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2006 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit AdoMetaDataProvider;

interface
uses
  DBXMetaDataReader,
  DBXMetaDataWriter,
  ADOProviderContext,
  DBXPlatformUtil,
  System.Collections,
  System.Configuration,
  System.Data,
  System.Data.Common,
  System.Text,
  System.Text.RegularExpressions,
  DBXMetaDataProvider,
  DBXMetaDataWriterFactory,
  System.Threading;

type
  TAdoMetaDataProvider = class(TDBXMetaDataProvider)
  private
    FConnection: DbConnection;
    FDatabaseProductName: WideString;
    FDatabaseVersion: WideString;
    class var FDialects: TDBXStringStore;
  public
    class procedure RegisterConfiguration(Config: Configuration); static;
    constructor Create(); overload;
    constructor Create(DatabaseProductName: WideString; DatabaseVersion: WideString; ParameterMarker: WideString; MarkerIncludedInParameterName: Boolean; Connection: IDbConnection); overload;
    constructor Create(Connection: DbConnection); overload;
  public
    procedure Open();
    property Connection: DbConnection read FConnection write FConnection;

  private
    procedure InitLoader(DatabaseProductName: WideString; DatabaseVersion: WideString; ParameterMarker: WideString; MarkerIncludedInParameterName: Boolean; Connection: IDbConnection);
    class function GetProductName(Connection: DbConnection; out Version: WideString; out ParameterMarkerPattern: WideString; out ParameterNamePattern: WideString): WideString;
    procedure FindParameterMarker(ParameterMarkerPattern: WideString; ParameterNamePattern: WideString; out ParameterMarker: WideString; out MarkerIncludedInParameterName: Boolean);
    function GetConnectionType(Connection: IDbConnection): WideString;
    function IsFullMatch(Validator: Regex; Value: WideString): Boolean;
  end;

implementation
uses
  DBXTableStorage,
  DataRowStorage,
  DataTableStorage,
  DialectConfigurationSection,
  SysUtils;

resourcestring
  SNoProductNameFound = 'No Product name found for Data Provider. No metadata can be provided.';
  SNoDialectForProduct = 'No metadata could be loaded for: %s.';
  SDialectTypeNotFound = 'Could not locate the type: %s.';

const
  QuestionParameterMarker = '?';
  AtSignParameterMarker = '@';
  ColonParameterMarker = ':';
  ParameterNameSample = 'TABLE_NAME';
  InterbaseProduct = 'InterBase';                { Do not localize }
  FirebirdProduct = 'Firebird';                { Do not localize }
  OracleProduct    = 'Oracle';                   { Do not localize }
  SybaseASEProduct = 'Sybase SQL Server';        { Do not localize }
  SybaseASAProduct = 'Adaptive Server Anywhere'; { Do not localize }
  Db2Product       = 'Db2';                      { Do not localize }
  InformixProduct  = 'Informix Dynamic Server';  { Do not localize }

class procedure TAdoMetaDataProvider.RegisterConfiguration(Config: Configuration);
var
  Section: TDialectConfigurationSection;
  Dialects: TMetaDataDialectCollection;
  Dialect: TMetaDataDialectElement;
  Index: Integer;
  Key: WideString;
begin
  Monitor.Enter(typeof(TAdoMetaDataProvider));
  try
    if FDialects = nil then
      FDialects := TDBXStringStore.Create;
    Section := Config.GetSection(TDialectConfigurationSection.SectionName) as TDialectConfigurationSection;
    if Section <> nil then
    begin
      Dialects := Section.MetaDataDialects;
      for Index := 0 to Dialects.Count - 1 do
      begin
        Dialect := Dialects[Index];
        Key := TMetaDataDialectCollection.ProduceKey(Dialect.ProductName, Dialect.ConnectionType);
        FDialects[Key] := Dialect.DialectType;
      end;
    end;
  finally
    Monitor.Exit(typeof(TAdoMetaDataProvider));
  end;
end;

constructor TAdoMetaDataProvider.Create(DatabaseProductName: WideString; DatabaseVersion: WideString; ParameterMarker: WideString; MarkerIncludedInParameterName: Boolean; Connection: IDBConnection);
begin
  Inherited Create;
  InitLoader(DatabaseProductName, DatabaseVersion, ParameterMarker, MarkerIncludedInParameterName, Connection);
end;

constructor TAdoMetaDataProvider.Create(Connection: DbConnection);
var
  Version, ParameterMarkerPattern, ParameterNamePattern, ProductName, ParameterMarker: WideString;
  MarkerIncludedInParameterName: Boolean;
begin
  Inherited Create;
  ProductName := GetProductName(Connection, Version, ParameterMarkerPattern, ParameterNamePattern);
  FindParameterMarker(ParameterMarkerPattern, ParameterNamePattern, ParameterMarker, MarkerIncludedInParameterName);
  InitLoader(ProductName, Version, ParameterMarker, MarkerIncludedInParameterName, Connection);
end;


procedure TAdoMetaDataProvider.Open;
var
  ParameterMarkerPattern: WideString;
  ParameterNamePattern:   WideString;
  ParameterMarker:        WideString;
  ConnectionType:         WideString;
  DialectTypename:        WideString;
  MarkerIncludedInParameterName: Boolean;
  NewWriter: TDBXMetaDataWriter;
  Context: TADOProviderContext;
  Reader: TDBXMetaDataReader;
begin
//  ProductName := GetProductName(Connection, Version, ParameterMarkerPattern, ParameterNamePattern);
//  FindParameterMarker(ParameterMarkerPattern, ParameterNamePattern, ParameterMarker, MarkerIncludedInParameterName);
//  InitLoader(ProductName, Version, ParameterMarker, MarkerIncludedInParameterName, Connection);
  if FDatabaseProductName = nil then
    FDatabaseProductName := GetProductName(FConnection, FDatabaseVersion, ParameterMarkerPattern, ParameterMarkerPattern);
  if (FDatabaseProductName = nil) or (Length(FDatabaseProductName) = 0) then
    raise Exception.Create(SNoProductNameFound);
  FindParameterMarker(ParameterMarkerPattern, ParameterNamePattern, ParameterMarker, MarkerIncludedInParameterName);

  ConnectionType := GetConnectionType(FConnection);
  DialectTypeName := nil;
  NewWriter := TDBXMetaDataWriterFactory.CreateWriter(FDatabaseProductName);

  Context := TADOProviderContext.Create;
  Context.Connection := FConnection;
  Context.SqlParameterMarker := ParameterMarker;
  Context.IsMarkerIncludedInParameterName := MarkerIncludedInParameterName;
  Context.UseAnsiStrings := (FDatabaseProductName = InterbaseProduct) or (FDatabaseProductName = FirebirdProduct) or (FDatabaseProductName = OracleProduct) or
                            (FDatabaseProductName = SybaseASAProduct) or (FDatabaseProductName = SybaseASEProduct) or (FDatabaseProductName = Db2Product) or (FDatabaseProductName = InformixProduct);

  NewWriter.Context := Context;
  Reader := NewWriter.MetaDataReader;
  Reader.Context := Context;
  Reader.Version := FDatabaseVersion;
  Writer := NewWriter;
end;

procedure TAdoMetaDataProvider.InitLoader(DatabaseProductName: WideString; DatabaseVersion: WideString; ParameterMarker: WideString; MarkerIncludedInParameterName: Boolean; Connection: IDbConnection);
var
  ConnectionType: WideString;
  DialectTypename: WideString;
  DialectType: System.Type;
  Key1, Key2: WideString;
  Reader: TDBXMetaDataReader;
  Context: TADOProviderContext;
begin
  if (DatabaseProductName = nil) or (DatabaseProductName.Length = 0) then
    raise Exception.Create(SNoProductNameFound);
  ConnectionType := GetConnectionType(Connection);
  DialectTypeName := nil;
  Key1 := TMetaDataDialectCollection.ProduceKey(DatabaseProductName, ConnectionType);
  Key2 := TMetaDataDialectCollection.ProduceKey(DatabaseProductName, nil);
  if FDialects.Contains(Key1) then
    DialectTypeName := FDialects[Key1]
  else if FDialects.Contains(Key2) then
    DialectTypeName := FDialects[Key2];
  if DialectTypeName = nil then
    raise Exception.Create(Format(SNoDialectForProduct, [databaseProductName]));
  DialectType := System.Type.GetType(DialectTypeName);
  if DialectType = nil then
    raise Exception.Create(Format(SDialectTypeNotFound, [DialectTypeName]));
  Context := TADOProviderContext.Create;
  Context.Connection := Connection;
  Context.SqlParameterMarker := ParameterMarker;
  Context.IsMarkerIncludedInParameterName := MarkerIncludedInParameterName;
  Writer := TDBXMetaDataWriter(Activator.CreateInstance(DialectType));
  Writer.Context := Context;
  Reader := Writer.MetaDataReader;
  Reader.Context := Context;
  Reader.Version := DatabaseVersion;
end;

class function TAdoMetaDataProvider.GetProductName(Connection: DbConnection; out Version: WideString; out ParameterMarkerPattern: WideString; out ParameterNamePattern: WideString): WideString;
var
  ProductName: WideString;
  Inner: Exception;
  Schema: DataTable;
  MarkerPattern, NamePattern: TObject;
begin
  ProductName := nil;
  Inner := nil;
  Version := nil;
  ParameterMarkerPattern := nil;
  ParameterNamePattern := nil;
  try
    Schema := Connection.GetSchema(DbMetaDataCollectionNames.DataSourceInformation);
    if (schema <> nil) and (schema.Rows.Count > 0) then
    begin
      ProductName := Schema.Rows[0][DbMetaDataColumnNames.DataSourceProductName] as WideString;
      version := Schema.Rows[0][DbMetaDataColumnNames.DataSourceProductVersionNormalized] as WideString;
      MarkerPattern := Schema.Rows[0][DbMetaDataColumnNames.ParameterMarkerPattern];
      NamePattern := Schema.Rows[0][DbMetaDataColumnNames.ParameterNamePattern];
      if MarkerPattern <> DBNull.Value then
        ParameterMarkerPattern := MarkerPattern as WideString;
      if NamePattern <> DBNull.Value then
        ParameterNamePattern := NamePattern as WideString;
    end;
    Schema.Clear();
  except
    on Ex: Exception do
    begin
      ProductName := nil;
      Inner := Ex;
    end;
  end;
  if (ProductName = nil) or (ProductName.Length = 0) then
    raise Exception.Create(SNoProductNameFound, Inner);
  Result := ProductName;
end;

constructor TAdoMetaDataProvider.Create;
begin
  inherited;
end;

procedure TAdoMetaDataProvider.FindParameterMarker(ParameterMarkerPattern: WideString; ParameterNamePattern: WideString; out ParameterMarker: WideString; out MarkerIncludedInParameterName: Boolean);
var
  Validator: Regex;
begin
  ParameterMarker := nil;
  MarkerIncludedInParameterName := False;
  if (ParameterMarkerPattern <> nil) and not (ParameterMarkerPattern = QuestionParameterMarker) then
  begin
    Validator := Regex.Create(ParameterMarkerPattern);
    if IsFullMatch(Validator, AtSignParameterMarker + ParameterNameSample) then
      ParameterMarker := AtSignParameterMarker
    else if IsFullMatch(Validator, ColonParameterMarker + ParameterNameSample) then
      ParameterMarker := ColonParameterMarker
    else if IsFullMatch(Validator, QuestionParameterMarker + ParameterNameSample) then
      ParameterMarker := ColonParameterMarker;
    if (ParameterMarker <> nil) and (parameterNamePattern <> nil) then
    begin
      Validator := Regex.Create(ParameterNamePattern);
      if IsFullMatch(Validator, ParameterMarker + ParameterNameSample) then
        MarkerIncludedInParameterName := True;
    end;
  end;
end;

function TAdoMetaDataProvider.GetConnectionType(Connection: IDbConnection): WideString;
var
  ConnectionType: System.Type;
begin
  ConnectionType := TObject(Connection).GetType();
  Result := ConnectionType.AssemblyQualifiedName;
end;

function TAdoMetaDataProvider.IsFullMatch(Validator: Regex; Value: WideString): Boolean;
var
  MatchResult: Match;
begin
  MatchResult := validator.Match(value);
  Result := MatchResult.Success and (MatchResult.Length = Value.Length);
end;

end.

