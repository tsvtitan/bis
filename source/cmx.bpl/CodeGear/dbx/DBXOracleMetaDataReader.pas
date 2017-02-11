{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXOracleMetaDataReader;
interface
uses
  DBXMetaDataNames,
  DBXMetaDataReader,
  DBXPlatformUtil,
  DBXTableStorage;
type
  
  /// <summary>  OracleCustomMetaDataProvider contains custom code for Orcale.
  /// </summary>
  /// <remarks>  This class handles default values.
  /// </remarks>
  TDBXOracleCustomMetaDataReader = class(TDBXBaseMetaDataReader)
  public
    type

      /// <summary>  OracleColumnsCursor is a filter for a cursor providing table columns.
      /// </summary>
      /// <remarks>  In Oracle the default value is kept in a LONG data type. Oracle does not allow SQL
      ///   operations like TRIM() on LONG values.
      ///   This filter will trim the default values.
      /// </remarks>
            
      /// <summary>  OracleColumnsCursor is a filter for a cursor providing table columns.
      /// </summary>
      /// <remarks>  In Oracle the default value is kept in a LONG data type. Oracle does not allow SQL
      ///   operations like TRIM() on LONG values.
      ///   This filter will trim the default values.
      /// </remarks>
      TDBXOracleColumnsCursor = class(TDBXBaseMetaDataReader.TDBXSanitizedTableCursor)
      public
        function GetString(Ordinal: Integer): WideString; override;
      protected
        constructor Create(const Provider: TDBXOracleCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Cursor: TDBXTableStorage);
      end;


      /// <summary>  OracleIndexColumnsCursor is a filter for a cursor providing index columns.
      /// </summary>
      /// <remarks>  In Oracle indexes can be created from expressions, therefore there are no column
      ///   names specified for each index.
      ///   This filter tries to extract the column name from an index expression.
      /// </remarks>
            
      /// <summary>  OracleIndexColumnsCursor is a filter for a cursor providing index columns.
      /// </summary>
      /// <remarks>  In Oracle indexes can be created from expressions, therefore there are no column
      ///   names specified for each index.
      ///   This filter tries to extract the column name from an index expression.
      /// </remarks>
      TDBXOracleIndexColumnsCursor = class(TDBXBaseMetaDataReader.TDBXSanitizedTableCursor)
      public
        function GetString(Ordinal: Integer): WideString; override;
      protected
        constructor Create(Provider: TDBXOracleCustomMetaDataReader; Columns: TDBXColumnDescriptorArray; Cursor: TDBXTableStorage);
      private
        function ComputeColumnName: WideString;
      private
        const ColumnExpressionOrdinal = TDBXIndexColumnsIndex.Last + 1;
        const ColumnExpressionNullOrdinal = TDBXIndexColumnsIndex.Last + 2;
      end;

  public
    
    /// <summary>  Overrides the implementation in BaseMetaDataProvider.
    /// </summary>
    /// <remarks>  A custom filter is added to trim the default values.
    /// </remarks>
    /// <seealso cref="OracleColumnsCursor."/>
    function FetchColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage; override;
    
    /// <summary>  Overrides the implementation in BaseMetaDataProvider.
    /// </summary>
    /// <remarks>  A custom filter is added to retrieve the column names.
    /// </remarks>
    /// <seealso cref="OracleColumnsCursor."/>
    function FetchIndexColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const Index: WideString): TDBXTableStorage; override;
  protected
    procedure PopulateDataTypes(Hash: TDBXObjectStore; Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray); override;
  end;

  TDBXOracleMetaDataReader = class(TDBXOracleCustomMetaDataReader)
  public
    function FetchCatalogs: TDBXTableStorage; override;
    function FetchColumnConstraints(const CatalogName: WideString; const SchemaName: WideString; const TableName: WideString): TDBXTableStorage; override;
  protected
    function GetProductName: WideString; override;
    function IsNestedTransactionsSupported: Boolean; override;
    function IsSetRowSizeSupported: Boolean; override;
    function GetSqlForSchemas: WideString; override;
    function GetSqlForTables: WideString; override;
    function GetSqlForViews: WideString; override;
    function GetSqlForColumns: WideString; override;
    function GetSqlForIndexes: WideString; override;
    function GetSqlForIndexColumns: WideString; override;
    function GetSqlForForeignKeys: WideString; override;
    function GetSqlForForeignKeyColumns: WideString; override;
    function GetSqlForSynonyms: WideString; override;
    function GetSqlForProcedures: WideString; override;
    function GetSqlForProcedureSources: WideString; override;
    function GetSqlForProcedureParameters: WideString; override;
    function GetSqlForPackages: WideString; override;
    function GetSqlForPackageSources: WideString; override;
    function GetSqlForPackageProcedures: WideString; override;
    function GetSqlForPackageProcedureParameters: WideString; override;
    function GetSqlForUsers: WideString; override;
    function GetSqlForRoles: WideString; override;
    function GetDataTypeDescriptions: TDBXDataTypeDescriptionArray; override;
    function GetReservedWords: TDBXWideStringArray; override;
  end;

implementation
uses
  DBXCommon,
  SysUtils;

procedure TDBXOracleCustomMetaDataReader.PopulateDataTypes(Hash: TDBXObjectStore; Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray);
var
  Def: TDBXDataTypeDescription;
begin
  inherited PopulateDataTypes(Hash, Types, Descr);
  Def := TDBXDataTypeDescription.Create('REF CURSOR', TDBXDataTypes.CursorType, 0, NullString, NullString, 0, 0, NullString, NullString, NullString, NullString, 0);
  Hash[Def.TypeName] := Def;
  Def := TDBXDataTypeDescription.Create('PL/SQL BOOLEAN', TDBXDataTypes.BooleanType, 0, NullString, NullString, 0, 0, NullString, NullString, NullString, NullString, 0);
  Hash[Def.TypeName] := Def;
  Def := TDBXDataTypeDescription.Create('BINARY_INTEGER', TDBXDataTypes.Int32Type, 0, NullString, NullString, 0, 0, NullString, NullString, NullString, NullString, 0);
  Hash[Def.TypeName] := Def;
end;

function TDBXOracleCustomMetaDataReader.FetchColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(ParameterNames,3);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.TableName;
  SetLength(ParameterValues,3);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Table;
  Cursor := FContext.ExecuteQuery(SqlForColumns, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateColumnsColumns;
  Result := TDBXBaseMetaDataReader.TDBXColumnsTableCursor.Create(self, False, TDBXOracleCustomMetaDataReader.TDBXOracleColumnsCursor.Create(self, Columns, Cursor));
end;

function TDBXOracleCustomMetaDataReader.FetchIndexColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const Index: WideString): TDBXTableStorage;
var
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Cursor: TDBXTableStorage;
  Columns: TDBXColumnDescriptorArray;
begin
  SetLength(ParameterNames,4);
  ParameterNames[0] := TDBXParameterName.CatalogName;
  ParameterNames[1] := TDBXParameterName.SchemaName;
  ParameterNames[2] := TDBXParameterName.TableName;
  ParameterNames[3] := TDBXParameterName.IndexName;
  SetLength(ParameterValues,4);
  ParameterValues[0] := Catalog;
  ParameterValues[1] := Schema;
  ParameterValues[2] := Table;
  ParameterValues[3] := Index;
  Cursor := FContext.ExecuteQuery(SqlForIndexColumns, ParameterNames, ParameterValues);
  Columns := TDBXMetaDataCollectionColumns.CreateIndexColumnsColumns;
  Result := TDBXOracleCustomMetaDataReader.TDBXOracleIndexColumnsCursor.Create(self, Columns, Cursor);
end;

constructor TDBXOracleCustomMetaDataReader.TDBXOracleColumnsCursor.Create(const Provider: TDBXOracleCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Cursor: TDBXTableStorage);
begin
  inherited Create(Provider.FContext, TDBXMetaDataCollectionIndex.Columns, TDBXMetaDataCollectionName.Columns, Columns, Cursor);
end;

function TDBXOracleCustomMetaDataReader.TDBXOracleColumnsCursor.GetString(Ordinal: Integer): WideString;
begin
  case Ordinal of
    TDBXColumnsIndex.DefaultValue:
      Result := Trim(inherited GetString(Ordinal));
    else
      Result := inherited GetString(Ordinal);
  end;
end;

constructor TDBXOracleCustomMetaDataReader.TDBXOracleIndexColumnsCursor.Create(Provider: TDBXOracleCustomMetaDataReader; Columns: TDBXColumnDescriptorArray; Cursor: TDBXTableStorage);
begin
  inherited Create(Provider.FContext, TDBXMetaDataCollectionIndex.IndexColumns, TDBXMetaDataCollectionName.IndexColumns, Columns, Cursor);
end;

function TDBXOracleCustomMetaDataReader.TDBXOracleIndexColumnsCursor.GetString(Ordinal: Integer): WideString;
begin
  if Ordinal = TDBXIndexColumnsIndex.ColumnName then
    Result := ComputeColumnName
  else 
    Result := inherited GetString(Ordinal);
end;

function TDBXOracleCustomMetaDataReader.TDBXOracleIndexColumnsCursor.ComputeColumnName: WideString;
var
  Expression: WideString;
begin
  Expression := NullString;
  if FCursor.GetAsInt32(ColumnExpressionNullOrdinal) <> 0 then
  begin
    Result := inherited GetString(TDBXIndexColumnsIndex.ColumnName);
    exit;
  end
  else 
  begin
    Expression := FCursor.GetString(ColumnExpressionOrdinal);
    if (not StringIsNil(Expression)) and (Length(Expression) > 0) then
    begin
      if (Length(Expression) > 2) and (Expression[1+0] = '"') and (Expression[1+Length(Expression) - 1] = '"') and (StringIndexOf(Expression,' ') < 0) then
        Expression := Copy(Expression,1+1,Length(Expression) - 1-(1));
    end;
  end;
  Result := Expression;
end;

function TDBXOracleMetaDataReader.GetProductName: WideString;
begin
  Result := 'Oracle';
end;

function TDBXOracleMetaDataReader.IsNestedTransactionsSupported: Boolean;
begin
  Result := True;
end;

function TDBXOracleMetaDataReader.IsSetRowSizeSupported: Boolean;
begin
  Result := True;
end;

function TDBXOracleMetaDataReader.FetchCatalogs: TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateCatalogsColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Catalogs, TDBXMetaDataCollectionName.Catalogs, Columns);
end;

function TDBXOracleMetaDataReader.GetSqlForSchemas: WideString;
begin
  Result := 'SELECT DISTINCT NULL, OWNER ' +
            'FROM ALL_OBJECTS ' +
            'WHERE (1<2 OR (:CATALOG_NAME IS NULL)) ' +
            'ORDER BY 1';
end;

function TDBXOracleMetaDataReader.GetSqlForTables: WideString;
begin
  Result := 'SELECT NULL, OWNER, OBJECT_NAME, CASE WHEN OWNER IN (''SYS'',''SYSTEM'',''CTXSYS'',''DMSYS'',''EXFSYS'',''OLAPSYS'',''ORDSYS'',''MDSYS'',''WKSYS'',''WK_TEST'',''WMSYS'',''XDB'') THEN ''SYSTEM '' ELSE '''' END || OBJECT_TYPE ' +
            'FROM ALL_OBJECTS ' +
            'WHERE OBJECT_TYPE IN (''VIEW'',''TABLE'',''SYNONYM'') ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (OBJECT_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            ' AND ((CASE WHEN OWNER IN (''SYS'',''SYSTEM'',''CTXSYS'',''DMSYS'',''EXFSYS'',''OLAPSYS'',''ORDSYS'',''MDSYS'',''WKSYS'',''WK_TEST'',''WMSYS'',''XDB'') THEN ''SYSTEM '' ELSE '''' END) || OBJECT_TYPE IN (:TABLES,:VIEWS,:SYSTEM_TABLES,:SYSTEM_VIEWS,:SYNONYMS)) ' +
            'ORDER BY 2, 3';
end;

function TDBXOracleMetaDataReader.GetSqlForViews: WideString;
begin
  Result := 'SELECT NULL, OWNER, VIEW_NAME, TEXT ' +
            'FROM SYS.ALL_VIEWS ' +
            'WHERE (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (VIEW_NAME = :VIEW_NAME OR (:VIEW_NAME IS NULL)) ' +
            'ORDER BY 2, 3';
end;

function TDBXOracleMetaDataReader.GetSqlForColumns: WideString;
begin
  Result := 'SELECT NULL, OWNER, TABLE_NAME, COLUMN_NAME, DATA_TYPE, COALESCE(DATA_PRECISION,CHAR_COL_DECL_LENGTH,DATA_LENGTH), DATA_SCALE, COLUMN_ID, DATA_DEFAULT, DECODE(NULLABLE,''Y'',1,''YES'',1,0), 0, NULL ' +
            'FROM SYS.ALL_TAB_COLUMNS ' +
            'WHERE (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 2, 3, COLUMN_ID';
end;

function TDBXOracleMetaDataReader.FetchColumnConstraints(const CatalogName: WideString; const SchemaName: WideString; const TableName: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateColumnConstraintsColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.ColumnConstraints, TDBXMetaDataCollectionName.ColumnConstraints, Columns);
end;

function TDBXOracleMetaDataReader.GetSqlForIndexes: WideString;
begin
  Result := 'SELECT NULL, I.TABLE_OWNER, I.TABLE_NAME, I.INDEX_NAME, C.CONSTRAINT_NAME, CASE WHEN C.CONSTRAINT_TYPE = ''P'' THEN 1 ELSE 0 END, CASE WHEN I.UNIQUENESS = ''UNIQUE'' THEN 1 ELSE 0 END, 1 ' +
            'FROM SYS.ALL_INDEXES I, SYS.ALL_CONSTRAINTS C ' +
            'WHERE I.TABLE_OWNER=C.OWNER(+) AND I.INDEX_NAME=C.INDEX_NAME(+) AND I.TABLE_NAME=C.TABLE_NAME(+) ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(I.TABLE_OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (I.TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 2, 3, 4';
end;

function TDBXOracleMetaDataReader.GetSqlForIndexColumns: WideString;
begin
  Result := 'SELECT NULL, C.TABLE_OWNER, C.TABLE_NAME, C.INDEX_NAME, C.COLUMN_NAME, C.COLUMN_POSITION, CASE WHEN C.DESCEND = ''DESC'' THEN 0 ELSE 1 END, E.COLUMN_EXPRESSION, CASE WHEN E.COLUMN_EXPRESSION IS NULL THEN 1 ELSE 0 END ' +
            'FROM ALL_IND_COLUMNS C, ALL_IND_EXPRESSIONS E ' +
            'WHERE C.INDEX_OWNER=E.INDEX_OWNER(+) AND C.INDEX_NAME=E.INDEX_NAME(+) AND C.COLUMN_POSITION=E.COLUMN_POSITION(+) ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(C.TABLE_OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (C.TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (C.INDEX_NAME = :INDEX_NAME OR (:INDEX_NAME IS NULL)) ' +
            'ORDER BY 2, 3, 4, 6';
end;

function TDBXOracleMetaDataReader.GetSqlForForeignKeys: WideString;
begin
  Result := 'SELECT NULL, OWNER, TABLE_NAME, CONSTRAINT_NAME ' +
            'FROM ALL_CONSTRAINTS ' +
            'WHERE CONSTRAINT_TYPE = ''R'' ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
            'ORDER BY 2, 3, 4';
end;

function TDBXOracleMetaDataReader.GetSqlForForeignKeyColumns: WideString;
begin
  Result := 'SELECT NULL, FC.OWNER, FC.TABLE_NAME, FC.CONSTRAINT_NAME, FC.COLUMN_NAME, NULL, PC.OWNER, PC.TABLE_NAME, PC.CONSTRAINT_NAME, PC.COLUMN_NAME, FC.POSITION ' +
            'FROM ALL_CONS_COLUMNS FC, ALL_CONSTRAINTS F, ALL_CONSTRAINTS P, ALL_CONS_COLUMNS PC ' +
            'WHERE F.CONSTRAINT_TYPE = ''R'' ' +
            ' AND F.OWNER=FC.OWNER AND F.TABLE_NAME=FC.TABLE_NAME AND F.CONSTRAINT_NAME=FC.CONSTRAINT_NAME ' +
            ' AND F.R_OWNER=P.OWNER AND F.R_CONSTRAINT_NAME=P.CONSTRAINT_NAME ' +
            ' AND P.OWNER=PC.OWNER AND P.TABLE_NAME=PC.TABLE_NAME AND P.CONSTRAINT_NAME=PC.CONSTRAINT_NAME ' +
            ' AND FC.POSITION=PC.POSITION ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(FC.OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (FC.TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (FC.CONSTRAINT_NAME = :FOREIGN_KEY_NAME OR (:FOREIGN_KEY_NAME IS NULL)) ' +
            ' AND (1<2 OR (:PRIMARY_CATALOG_NAME IS NULL)) AND (LOWER(PC.OWNER) = LOWER(:PRIMARY_SCHEMA_NAME) OR (:PRIMARY_SCHEMA_NAME IS NULL)) AND (PC.TABLE_NAME = :PRIMARY_TABLE_NAME OR (:PRIMARY_TABLE_NAME IS NULL)) AND (PC.CONSTRAINT_NAME = :PRIMARY_KEY_NAME OR (' + ':PRIMARY_KEY_NAME IS NULL)) ' +
            'ORDER BY 2, 3, 4, FC.POSITION';
end;

function TDBXOracleMetaDataReader.GetSqlForSynonyms: WideString;
begin
  Result := 'SELECT NULL, OWNER, SYNONYM_NAME, NULL, TABLE_OWNER, TABLE_NAME ' +
            'FROM ALL_SYNONYMS ' +
            'WHERE (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (SYNONYM_NAME = :SYNONYM_NAME OR (:SYNONYM_NAME IS NULL)) ' +
            'ORDER BY 2,3';
end;

function TDBXOracleMetaDataReader.GetSqlForProcedures: WideString;
begin
  Result := 'SELECT NULL, OWNER, OBJECT_NAME, OBJECT_TYPE ' +
            'FROM ALL_OBJECTS ' +
            'WHERE OBJECT_TYPE IN (''FUNCTION'',''PROCEDURE'') ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (OBJECT_NAME = :PROCEDURE_NAME OR (:PROCEDURE_NAME IS NULL)) AND (OBJECT_TYPE = :PROCEDURE_TYPE OR (:PROCEDURE_TYPE IS NULL)) ' +
            'ORDER BY 2,3';
end;

function TDBXOracleMetaDataReader.GetSqlForProcedureSources: WideString;
begin
  Result := 'SELECT NULL, OWNER, NAME, TYPE, TEXT, NULL, LINE AS SOURCE_LINE_NUMBER ' +
            'FROM ALL_SOURCE S ' +
            'WHERE TYPE IN (''FUNCTION'',''PROCEDURE'') ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (NAME = :PROCEDURE_NAME OR (:PROCEDURE_NAME IS NULL)) ' +
            'ORDER BY OWNER,NAME,LINE';
end;

function TDBXOracleMetaDataReader.GetSqlForProcedureParameters: WideString;
begin
{  Result := 'SELECT NULL, OWNER, OBJECT_NAME, ARGUMENT_NAME, CASE WHEN POSITION=0 THEN ''RESULT'' WHEN IN_OUT=''IN/OUT'' THEN ''INOUT'' ELSE IN_OUT END, DATA_TYPE, NULL, NULL, POSITION, 1 ' +
            'FROM ALL_ARGUMENTS ' +
            'WHERE PACKAGE_NAME IS NULL AND DATA_LEVEL=0 AND DATA_TYPE IS NOT NULL ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (OBJECT_NAME = :PROCEDURE_NAME OR (:PROCEDURE_NAME IS NULL)) AND (ARGUMENT_NAME = :PARAMETER_NAME OR (:PARAMETER_NAME IS NULL)) ' +
            'ORDER BY OWNER,OBJECT_NAME,POSITION';}
  // by TSV            
  Result := 'SELECT NULL, OWNER, OBJECT_NAME, ARGUMENT_NAME, CASE WHEN POSITION=0 THEN ''RESULT'' WHEN IN_OUT=''IN/OUT'' THEN ''INOUT'' ELSE IN_OUT END, PLS_TYPE, NULL, NULL, POSITION, 1 ' +
            'FROM ALL_ARGUMENTS ' +
            'WHERE PACKAGE_NAME IS NULL AND DATA_LEVEL=0 AND PLS_TYPE IS NOT NULL ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (OBJECT_NAME = :PROCEDURE_NAME OR (:PROCEDURE_NAME IS NULL)) AND (ARGUMENT_NAME = :PARAMETER_NAME OR (:PARAMETER_NAME IS NULL)) ' +
            'ORDER BY OWNER,OBJECT_NAME,POSITION';
end;

function TDBXOracleMetaDataReader.GetSqlForPackages: WideString;
begin
  Result := 'SELECT NULL, OWNER, OBJECT_NAME ' +
            'FROM ALL_OBJECTS ' +
            'WHERE OBJECT_TYPE IN (''PACKAGE'') ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (OBJECT_NAME = :PACKAGE_NAME OR (:PACKAGE_NAME IS NULL)) ' +
            'ORDER BY 2,3';
end;

function TDBXOracleMetaDataReader.GetSqlForPackageSources: WideString;
begin
  Result := 'SELECT NULL, OWNER, NAME, TEXT, LINE AS SOURCE_LINE_NUMBER ' +
            'FROM ALL_SOURCE S ' +
            'WHERE TYPE IN (''PACKAGE'') ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (NAME = :PACKAGE_NAME OR (:PACKAGE_NAME IS NULL)) ' +
            'ORDER BY OWNER,NAME,LINE';
end;

function TDBXOracleMetaDataReader.GetSqlForPackageProcedures: WideString;
begin
  Result := 'SELECT NULL, OWNER, PACKAGE_NAME, OBJECT_NAME, CASE WHEN MIN(POSITION)=0 THEN ''FUNCTION'' ELSE ''PROCEDURE'' END ' +
            'FROM ALL_ARGUMENTS ' +
            'WHERE PACKAGE_NAME IS NOT NULL ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (PACKAGE_NAME = :PACKAGE_NAME OR (:PACKAGE_NAME IS NULL)) AND (OBJECT_NAME = :PROCEDURE_NAME OR (:PROCEDURE_NAME IS NULL)) ' +
            'GROUP BY OWNER, PACKAGE_NAME, OBJECT_NAME ' +
            'HAVING (CASE WHEN MIN(POSITION)=0 THEN ''FUNCTION'' ELSE ''PROCEDURE'' END = :PROCEDURE_TYPE OR (:PROCEDURE_TYPE IS NULL))';
end;

function TDBXOracleMetaDataReader.GetSqlForPackageProcedureParameters: WideString;
begin
  Result := 'SELECT NULL, OWNER, PACKAGE_NAME, OBJECT_NAME, ARGUMENT_NAME, CASE WHEN POSITION=0 THEN ''RESULT'' WHEN IN_OUT=''IN/OUT'' THEN ''INOUT'' ELSE IN_OUT END, DATA_TYPE, NULL, NULL, POSITION, 1 ' +
            'FROM ALL_ARGUMENTS ' +
            'WHERE PACKAGE_NAME IS NOT NULL AND DATA_LEVEL=0 AND DATA_TYPE IS NOT NULL ' +
            ' AND (1<2 OR (:CATALOG_NAME IS NULL)) AND (LOWER(OWNER) = LOWER(:SCHEMA_NAME) OR (:SCHEMA_NAME IS NULL)) AND (PACKAGE_NAME = :PACKAGE_NAME OR (:PACKAGE_NAME IS NULL)) AND (OBJECT_NAME = :PROCEDURE_NAME OR (:PROCEDURE_NAME IS NULL)) AND (ARGUMENT_NAME = :P' + 'ARAMETER_NAME OR (:PARAMETER_NAME IS NULL)) ' +
            'ORDER BY OWNER,PACKAGE_NAME,OBJECT_NAME,POSITION';
end;

function TDBXOracleMetaDataReader.GetSqlForUsers: WideString;
begin
  Result := 'SELECT USERNAME FROM ALL_USERS ORDER BY 1';
end;

function TDBXOracleMetaDataReader.GetSqlForRoles: WideString;
begin
  Result := 'SELECT ROLE FROM SESSION_ROLES ORDER BY 1';
end;

function TDBXOracleMetaDataReader.GetDataTypeDescriptions: TDBXDataTypeDescriptionArray;
var
  Types: TDBXDataTypeDescriptionArray;
begin
//  SetLength(Types,22);
  // by TSV
  SetLength(Types,23);
  Types[0] := TDBXDataTypeDescription.Create('BFILE', TDBXDataTypes.BlobType, 4294967296, 'BFILE', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[1] := TDBXDataTypeDescription.Create('BLOB', TDBXDataTypes.BlobType, 4294967296, 'BLOB', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[2] := TDBXDataTypeDescription.Create('CHAR', TDBXDataTypes.AnsiStringType, 2000, 'CHAR({0})', 'Precision', -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.LiteralSupported);
  Types[3] := TDBXDataTypeDescription.Create('CLOB', TDBXDataTypes.AnsiStringType, 4294967296, 'CLOB', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[4] := TDBXDataTypeDescription.Create('DATE', TDBXDataTypes.TimestampType, 19, 'DATE', NullString, -1, -1, 'TO_DATE(''', ''',''YYYY-MM-DD HH24:MI:SS'')', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[5] := TDBXDataTypeDescription.Create('FLOAT', TDBXDataTypes.BcdType, 126, 'FLOAT({0})', 'Precision', -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[6] := TDBXDataTypeDescription.Create('BINARY_FLOAT', TDBXDataTypesEx.SingleType, 7, 'BINARY_FLOAT', NullString, -1, -1, '', '', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[7] := TDBXDataTypeDescription.Create('BINARY_DOUBLE', TDBXDataTypes.DoubleType, 53, 'BINARY_DOUBLE', NullString, -1, -1, '', '', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[8] := TDBXDataTypeDescription.Create('INTERVAL DAY TO SECOND', TDBXDataTypesEx.IntervalType, 0, 'INTERVAL DAY({0}) TO SECOND({1})', 'Precision,Scale', -1, -1, 'TO_DSINTERVAL(''', ''')', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[9] := TDBXDataTypeDescription.Create('INTERVAL YEAR TO MONTH', TDBXDataTypesEx.IntervalType, 0, 'INTERVAL YEAR({0}) TO MONTH', 'Precision', -1, -1, 'TO_YMINTERVAL(''', ''')', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[10] := TDBXDataTypeDescription.Create('LONG', TDBXDataTypes.AnsiStringType, 2147483647, 'LONG', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Long);
  Types[11] := TDBXDataTypeDescription.Create('LONG RAW', TDBXDataTypes.BytesType, 2147483647, 'LONG RAW', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[12] := TDBXDataTypeDescription.Create('NCHAR', TDBXDataTypes.WideStringType, 2000, 'NCHAR({0})', 'Precision', -1, -1, 'N''', '''', NullString, NullString, TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.LiteralSupported or TDBXTypeFlag.Unicode);
  Types[13] := TDBXDataTypeDescription.Create('NCLOB', TDBXDataTypes.WideStringType, 4294967296, 'NCLOB', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.Unicode);
  Types[14] := TDBXDataTypeDescription.Create('NUMBER', TDBXDataTypes.BcdType, 38, 'NUMBER({0},{1})', 'Precision,Scale', 127, -84, '', '', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[15] := TDBXDataTypeDescription.Create('NVARCHAR2', TDBXDataTypes.WideStringType, 4000, 'NVARCHAR2({0})', 'Precision', -1, -1, 'N''', '''', NullString, NullString, TDBXTypeFlag.CaseSensitive or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported or TDBXTypeFlag.Unicode);
  Types[16] := TDBXDataTypeDescription.Create('RAW', TDBXDataTypes.BytesType, 2000, 'RAW({0})', 'Precision', -1, -1, 'HEXTORAW(''', ''')', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[17] := TDBXDataTypeDescription.Create('TIMESTAMP', TDBXDataTypes.TimestampType, 27, 'TIMESTAMP({0})', 'Precision', -1, -1, 'TO_TIMESTAMP(''', ''',''YYYY-MM-DD HH24:MI:SS.FF'')', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[18] := TDBXDataTypeDescription.Create('TIMESTAMP WITH LOCAL TIME ZONE', TDBXDataTypes.TimestampType, 27, 'TIMESTAMP({0} WITH LOCAL TIME ZONE)', 'Precision', -1, -1, 'TO_TIMESTAMP_TZ(''', ''',''YYYY-MM-DD HH24:MI:SS.FF'')', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[19] := TDBXDataTypeDescription.Create('TIMESTAMP WITH TIME ZONE', TDBXDataTypes.TimestampType, 34, 'TIMESTAMP({0} WITH TIME ZONE)', 'Precision', -1, -1, 'TO_TIMESTAMP_TZ(''', ''',''YYYY-MM-DD HH24:MI:SS.FF TZH:TZM'')', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.LiteralSupported);
  Types[20] := TDBXDataTypeDescription.Create('VARCHAR2', TDBXDataTypes.AnsiStringType, 4000, 'VARCHAR2({0})', 'Precision', -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike or TDBXTypeFlag.LiteralSupported);
  Types[21] := TDBXDataTypeDescription.Create('XMLTYPE', TDBXDataTypes.AnsiStringType, 4000, 'XMLTYPE({0})', 'Precision', -1, -1, 'XMLType(''', ''')', NullString, NullString, TDBXTypeFlag.LiteralSupported);
  // by TSV
  Types[22] := TDBXDataTypeDescription.Create('INTEGER', TDBXDataTypes.Int32Type, 10, 'INTEGER', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Result := Types;
end;

function TDBXOracleMetaDataReader.GetReservedWords: TDBXWideStringArray;
var
  Words: TDBXWideStringArray;
begin
  SetLength(Words,80);
  Words[0] := 'ALL';
  Words[1] := 'ALTER';
  Words[2] := 'AND';
  Words[3] := 'ANY';
  Words[4] := 'AS';
  Words[5] := 'ASC';
  Words[6] := 'BETWEEN';
  Words[7] := 'BY';
  Words[8] := 'CHAR';
  Words[9] := 'CHECK';
  Words[10] := 'CLUSTER';
  Words[11] := 'COMPRESS';
  Words[12] := 'CONNECT';
  Words[13] := 'CREATE';
  Words[14] := 'DATE';
  Words[15] := 'DECIMAL';
  Words[16] := 'DEFAULT';
  Words[17] := 'DELETE';
  Words[18] := 'DESC';
  Words[19] := 'DISTINCT';
  Words[20] := 'DROP';
  Words[21] := 'ELSE';
  Words[22] := 'EXCLUSIVE';
  Words[23] := 'EXISTS';
  Words[24] := 'FLOAT';
  Words[25] := 'FOR';
  Words[26] := 'FROM';
  Words[27] := 'GRANT';
  Words[28] := 'GROUP';
  Words[29] := 'HAVING';
  Words[30] := 'IDENTIFIED';
  Words[31] := 'IN';
  Words[32] := 'INDEX';
  Words[33] := 'INSERT';
  Words[34] := 'INTEGER';
  Words[35] := 'INTERSECT';
  Words[36] := 'INTO';
  Words[37] := 'IS';
  Words[38] := 'LIKE';
  Words[39] := 'LOCK';
  Words[40] := 'LONG';
  Words[41] := 'MINUS';
  Words[42] := 'MODE';
  Words[43] := 'NOCOMPRESS';
  Words[44] := 'NOT';
  Words[45] := 'NOWAIT';
  Words[46] := 'NULL';
  Words[47] := 'NUMBER';
  Words[48] := 'OF';
  Words[49] := 'ON';
  Words[50] := 'OPTION';
  Words[51] := 'OR';
  Words[52] := 'ORDER';
  Words[53] := 'PCTFREE';
  Words[54] := 'PRIOR';
  Words[55] := 'PUBLIC';
  Words[56] := 'RAW';
  Words[57] := 'RENAME';
  Words[58] := 'RESOURCE';
  Words[59] := 'REVOKE';
  Words[60] := 'SELECT';
  Words[61] := 'SET';
  Words[62] := 'SHARE';
  Words[63] := 'SIZE';
  Words[64] := 'SMALLINT';
  Words[65] := 'START';
  Words[66] := 'SYNONYM';
  Words[67] := 'TABLE';
  Words[68] := 'THEN';
  Words[69] := 'TO';
  Words[70] := 'TRIGGER';
  Words[71] := 'UNION';
  Words[72] := 'UNIQUE';
  Words[73] := 'UPDATE';
  Words[74] := 'VALUES';
  Words[75] := 'VARCHAR';
  Words[76] := 'VARCHAR2';
  Words[77] := 'VIEW';
  Words[78] := 'WHERE';
  Words[79] := 'WITH';
  Result := Words;
end;

end.
