{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2006 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

/// <summary> AdoDbxClient Ado.net 2.0 provider for dbExpress drivers </summary>
/// <remarks>
/// <para>
/// The AdoDBXClient provides an ado.net 2.0 provider for all dbExpress
/// version 4 drivers that impelement the newer extended metadata added
/// to dbExpress 4.  All dbExpress drivers shipped with Delphi implement
/// the newer extended metadata.
/// <para>
/// Making a Connection using dbxconnections.ini file.
/// <para>
/// The ConnectionName property
/// below is the name of a connection in the dbxconnections.ini file.
/// <para>
/// <c>
/// var
///   Factory: System.Data.Common.DbProviderFactory;
///   Connection: System.Data.Common.DbConnection;
/// begin
///    Factory := System.Data.Common.DbProviderFactories.GetFactory('Borland.Data.AdoDbxClient');
///    Connection := Factory.CreateConnection();
///    Connection.ConnectionString := 'ConnectionName=IBConnection';
///    Connection.Open;
/// end
/// </c>
/// <para>
/// Making a Connection using a System.Configuration file.
/// <para>
/// For this to work the
/// property settings in dbxconnections.ini and dbxdriver.ini for the database
/// you are connecting to must be migrated to a System.Configuration config file.
/// var
///   Factory: System.Data.Common.DbProviderFactory;
///   Connection: System.Data.Common.DbConnection;
///   Config: System.Configuration;
///   ConnectSection: System.ConnectionStringsSection;
///   CurrentSettings: System.ConnectionStringSettings;
///
/// begin
///    Factory := System.Data.Common.DbProviderFactories.GetFactory('Borland.Data.AdoDbxClient');
///    Connection := Factory.CreateConnection();
///    Config := ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
///    ConnectSection := config.ConnectionStrings;
///    Settings := ConnectSection.ConnectionStrings['IBConnection'];
///    Connection.ConnectionString := CurrentSettings.ConnectionString;
///    Connection.Open;
/// end
///
///  <para>
///  Deploying an application.
///  <para>
///  Updating Machine.config
///  <para>
///  The microsoft .net machine.config file must have an entry added for the
///  provider.  Locate machine.config below your Windows\Microsoft.net directory
///  tree and add the following entry in the "<DbProviderFactories>" section:
///  <para>
///  <c>
///  <add name="AdoDbx Data Provider" invariant="Borland.Data.AdoDbxClient" description=".Net Framework Data Provider for dbExpress Drivers" type="Borland.Data.TAdoDbxProviderFactory, Borland.Data.AdoDbxClient, Version=11.0.5000.0,Culture=neutral,PublicKeyToken=91d62ebb5b0d1b1b"/>
///  </c>
///  Deploying without updating machine.config
///  <para>
///  An application can also deploy without updating the machine config by directly
///  using the TAdoDbxProviderFactory class in the Borland.Data.AdoDbxClientProvider
///  unit.  Although this makes deployment easier, the TAdoDbxProviderFactory
///  can only create ado.net 2.0 objects for the AdoDbxClient provider.
///  <para>
///  If your application links with assemblies, the Borland.Data.AdoDbxClient.dll,
///  and Borland.Data.DbxCommonDriver.dll assembly must be either copied to the
///  same directory as your executable or registered in the gac.
///  <para>
///  If dbxconnections.ini and dbxdrivers.ini are used, they will have to also
///  be deployed as well.  If native dynalink drivers are being used, those
///  drivers and their corresponding client libraries will need to be deployed.
/// </remarks>

unit Borland.Data.AdoDbxClientProvider;

interface

uses

  DBXCommon,
  DBXMetaDataNames,
  Classes,
  SysUtils,
  FMTBcd, SqlTimSt,
  System.Data,
  System.ComponentModel,
  System.Collections,
  System.Data.Common,
  System.Web.UI.WebControls,
  System.Web.UI,
  System.Drawing;

{$R Borland.Data.TAdoDbxDataAdapter.bmp}
{$R Borland.Data.TAdoDbxCommand.bmp}
{$R Borland.Data.TAdoDbxCommandBuilder.bmp}
{$R Borland.Data.TAdoDbxConnection.bmp}
{$R Borland.Data.DbxDataSource.ico}

type

  TAdoDbxExtension = class;
  TAdoDbxConnection = class;
  TAdoDbxParameter = class;
  TAdoDbxCommand = class;
  TAdoDbxCommandBuilder = class;
  TAdoDbxDataAdapter = class;
  ///<summary>
  ///  These are columns returned from the GetSchema request for
  /// restrictions (<c>DbMetaDataCollectionNames.Restrictions</c>.
  ///</summary>
  TAdoDbxMetaDataColumnNames = class
  const
    ///<summary>Name of the restriction.</summary>
    RestrictionName = 'RestrictionName';  {Do not localize}
    ///<summary>Order in which the restriction should be specified in the restrictions array.</summary>
    RestrictionNumber = 'RestrictionNumber';  {Do not localize}
    ///<summary>Default value if nil is specified for the restriction.</summary>
    RestrictionDefault = 'RestrictionDefault';  {Do not localize}

  end;
  /// <summary>
  /// Additional columns that provide dbExpress specific data and sub type information.
  ///  </summary>
  TAdoDbxSchemaTableColumnNames = class
  const
    ///<summary>TDBXDataTypes data type</summary>
    DbxDataType = 'DbxDataType';
    ///<summary>TDBXDataTypes sub type</summary>
    DbxSubType = 'DbxSubType';
    ///<summary>TDBXDataTypes sub type</summary>
    DbxPrecision = 'DbxPrecision';
  end;
  TDBXValueTypes = array of TDBXValueType;
  TAdoDbxProviderFactory = class(DbProviderFactory)
    strict private
      class constructor Create;
      constructor Create(DbxContext: TDBXContext);
    private
      class var
        FValueTypesCache:    HashTable;
      FDBXContext:        TDBXContext;
      class procedure Unsupported(DbxContext: TDBXContext);
      class procedure  SystemToDbxType(Connection: TAdoDbxConnection; SystemType: System.Type; var DbxDataType: TDBXType; var DbxSubtype: TDBXType);
      class function  DbxToSystemType(DbxType, DbxSubtype: TDBXType): System.Type;
      class procedure  AdoToDbxType(Connection: TAdoDbxConnection; AdoType: DbType; var DbxDataType: Integer; var DbxSubType: Integer);
      class function  DbxToAdoParameterDirection(DbxParameterDirection: TDBXParameterDirection): ParameterDirection;
      class function  AdoToDbxParameterDirection(AdoParameterDirection: ParameterDirection): TDBXParameterDirection;
      class function  GetRowValue(DbxRow: TDBXValue): TObject;
      class function  GetRowBytesOrStringValue(Value: TDBXValue): TObject;

      class function  DateToDateTime(Date: TDBXDate): DateTime;
      class function  TimeToDateTime(Time: TDBXTime): DateTime;

      class procedure AddValueTypes(sql: String; ValueTypes: TDBXValueTypes); static;
      class function GetValueTypes(sql: String): TDBXValueTypes; static;

//      class function  DateTimeToDate(DateTimeValue: TDBXTime): TDBXDate;
//      class function  DateTimeToTime(DateTimeValue: TDBXTime): TDBXTime;
//      class function  DateTimeToTSQLTimeStamp(DateTimeValue: DateTime): TSQLTimeStamp;

    public
      class var
         Instance: TAdoDbxProviderFactory;
      var
      destructor Destroy; override;

      class function  DbxToAdoType(DbxType: TDBXType): DbType; static;

      function CreateConnection: DbConnection; override;
      function CreateCommand: DbCommand; override;
      function CreateParameter: DbParameter; override;
      function CreateDataAdapter: DbDataAdapter; override;
      function CreateDataSourceEnumerator: DbDataSourceEnumerator; override;
      function CreateCommandBuilder: DbCommandBuilder; override;
      function CreateConnectionStringBuilder: DbConnectionStringBuilder; override;
//      function CreatePermission(State: System.Security.Permissions.PermissionState): System.Security.CodeAccessPermission; override;
      function ReadCanCreateDataSourceEnumerator: Boolean;
      property CanCreateDataSourceEnumerator: Boolean read ReadCanCreateDataSourceEnumerator;

      procedure AdoDbxException(DBXError: TDBXError);

  end;

  [Serializable]
  TAdoDbxException = class(DbException)
    protected
      constructor Create(DBXError: TDBXError); overload;
      constructor Create(Message: String); overload;
  end;

    ///<summary>
    ///Represents a connection to a database.
    ///</summary>
    ///<remarks>
    ///TAdoDbxConnection represents a connection to a database. Upon creation of the object instance, all properties are set to their initial values. You must explicitly close any open connection using the Close method. There is no notion of an implicit disconnection in the .NET environment.
    ///
    ///TAdoDbxConnection is an implementation of the ADO.NET DbConnection class.
    ///
    ///To establish a database connection, you must create a new TAdoDbxConnection object and you must set its ConnectionString property. The ConnectionString is a name-value pair of all the parameters needed to connect to a particular database.
    ///
    ///TAdoDbxConnection has Open and Close methods to connect and disconnect from a database. The Open method used the connection parameters specified in the ConnectionString property to establish a connection to a database. For every Open method, you should include a corresponding Close method. Otherwise, the connection might not be closed properly and a subsequent connection attempt will fail with an exception.
    ///
    ///A valid connection must be opened before you can use the TAdoDbxConnection to create a new TAdoDbxCommand or call BeginTransaction to create a new TAdoDbxTransaction.
    ///</remarks>
    ///<example>
    ///The following Delphi code shows the ConnectionString needed to connect to InterBase.
    ///var
    ///  Factory: System.Data.Common.DbProviderFactory;
    ///  Connection: System.Data.Common.DbConnection;
    ///begin
    ///    Factory := System.Data.Common.DbProviderFactories.GetFactory('Borland.Data.AdoDbxClient');
    ///    Connection := Factory.CreateConnection();
    ///    Connection.ConnectionString := 'ConnectionName=IBCONNECTION'
    ///    Connection.Open;
    ///</example>
    ///
  [ToolboxBitmap(typeof(TAdoDbxConnection))]
  TAdoDbxConnection = class(DbConnection, ICloneable)
    strict private
      class var
        FSchemaItems:          TStringList;
        FStateChangeClosed:    StateChangeEventArgs;
        FStateChangeOpen:      StateChangeEventArgs;
        FConnectionFactory:    TDBXConnectionFactory;
      var
      FConnectionString:      String;
      FDriverName:            String;
//      FDatabase:            String;
//      FServerVersion:       String;
//      FConnectionState:     ConnectionState;
      FConnectionTimeout:     Integer;
      FDbxExtension:          TAdoDbxExtension;


      function AdoDbxIsolation(Isolation: IsolationLevel): TDBXIsolation;
    private
      FDbxConnection:         TDBXConnection;
      FClonedConnection:      TAdoDbxConnection;
      FDBXContext:            TDBXContext;
      FBlobDataType:          TDBXType;
      FBlobSubType:           TDBXType;
      FStringDataType:        TDBXType;

      function GetMetaDataCollections: DataTable;
      function GetDataSourceInformation: DataTable;
      function GetRestrictions: DataTable;
      function GetDbxExtension: TAdoDbxExtension;
      class procedure InitSchemaItems; static;
      property DbxConnection: TDBXConnection read FDbxConnection;

      function GetClonedConnectionIfNeeded(): TAdoDbxConnection;



    strict protected
      function BeginDbTransaction(Isolation: IsolationLevel): DbTransaction; override;
      function CreateDbCommand(): DbCommand; override;
    public
      // This is a special property that was added just for
      // testing.  This allows us to simiulate an asp.net app
      // where the dbxconnections.ini cannot be found.
      //
      procedure set_ConnectionFactory(ConnectionFactory: TDBXConnectionFactory);
      function get_ConnectionString: String; override;
      procedure set_ConnectionString(ConnectionString: String); override;
      function get_Database: String; override;
      function get_DataSource: String; override;
      function get_ServerVersion: String; override;
      function get_State: ConnectionState; override;
      function get_ConnectionTimeout: Integer; override;
      function Clone: TObject;

      class constructor Create;

      ///<summary>
      ///  Destroys a TAdoDbxConnection instance.
      ///</summary>
      ///<remarks>
      ///  This method should not be called directly.  Call either the Close or Free method instead.
      ///</remarks>
      destructor Destroy; override;
      ///<summary>
      ///  Creates a new instance of a TAdoDbxConnection object, which represents an open connection to a specified data source.
      ///</summary>
      ///<remarks>
      ///  The TAdoDbxConnection object represents a connection to a specified data source. The TAdoDbxConnection object contains the connection string, along with other properties. You need to explicitly open and close connections using the Open and Close methods, respectively. There is no notion in the .NET framework of an implicit open or close operation.
      // Public null constructor used by ECO to drop this component on a form.
      ///</remarks>
      constructor Create(); overload;
      ///<summary>
      ///  Creates a new instance of a TAdoDbxConnection object, which represents an open connection to a specified data source.
      ///</summary>
      ///<remarks>
      ///  The TAdoDbxConnection object represents a connection to a specified data source. The TAdoDbxConnection object contains the connection string, along with other properties. You need to explicitly open and close connections using the Open and Close methods, respectively. There is no notion in the .NET framework of an implicit open or close operation.
      ///</remarks>
      constructor Create(const ConnectionString: string); overload;

      ///<summary>
      ///  Changes the current database for a connection.
      ///</summary>
      ///<remarks>
      ///  ChangeDatabase switches the connection to a specified database.
      ///</remarks>
      procedure ChangeDatabase(DatabaseName: String); override;
      ///<summary>
      ///  Contains the propertie settings necessary to connect to a database.
      ///</summary>
      ///<remarks>
      ///  The ConnectionString property must be set before opening a connection. You must separate keyword value pairs by semicolons (;).  Names are not case sensitive.  Most applications will only need to set the ConnectionName name property which identifies a collection of properties stored in a dbxconnections.ini file.  Alternatively, an application can specify all properties from the dbxconnections.ini and dbxdriver.ini file for the database being connected to.
      ///</remarks>
      procedure Open(); override;
      ///  Close database connection.
      ///</summary>
      ///<remarks>
      ///  Close rolls back any pending transactions and releases the connection to the connection pool or closes the connection if there is no pool. Calling Close more than once does not raise an exception.
      ///</remarks>
      procedure Close(); override;

      ///<summary>
      ///  Gets schema information for the connected data source.
      ///</summary>
      ///<remarks>
      ///  GetSchema obtains schema information for the connected data source.
      ///</remarks>
      function GetSchema: DataTable; override;
      ///<summary>
      ///  Gets schema information for the connected data source.
      ///</summary>
      ///<remarks>
      ///  GetSchema obtains schema information for the connected data source.
      ///</remarks>
      function GetSchema(Name: String): DataTable; override;
      ///<summary>
      ///  Gets schema information for the connected data source.
      ///</summary>
      ///<remarks>
      ///  GetSchema obtains schema information for the connected data source.
      ///</remarks>
      function GetSchema(Name: String; Restrictions: array of String): DataTable; override;
      ///<summary>
      ///  Informational object containing non System.Data methods.
      ///</summary>
      property Dbx: TAdoDbxExtension read GetDbxExtension;
    published
      ///<summary>
      ///  Contains the information necessary to connect to a database.
      ///</summary>
      ///<remarks>
      ///  This property must be set before opening a connection. These keyword value pairs must be separated by semicolons (;).  Names are not case sensitive.  Most applications will only need to set the ConnectionName name property which identifies a collection of properties stored in a dbxconnections.ini file.  Alternatively, an application can specify all properties from the dbxconnections.ini and dbxdriver.ini file for the database being connected to.
      ///</remarks>
      property ConnectionString: String read get_ConnectionString write set_ConnectionString;
      ///<summary>
      ///  Contains the name of the current database or the database to be connected.
      ///</summary>
      ///<remarks>
      ///  Database contains the name of the current database or the database to be connected. You can get or set the database name.
      ///</remarks>
      property Database: String read get_Database;
      ///<summary>
      ///  Name of database server to which to connect.
      ///</summary>
      ///<returns>
      ///  The name of database server to which to connect.
      ///</returns>
      property DataSource: String read get_DataSource;
      ///<summary>
      ///  Server version of connected database.
      ///</summary>
      ///<remarks>
      ///  ServerVersion contains a string representing the server version of connected database.
      ///</remarks>
      property ServerVersion: String read get_ServerVersion;
      ///<summary>
      ///  Gets or sets the current state of the connection.
      ///</summary>
      ///<returns>
      ///  State contains the current ConnectionState value
      ///</returns>
      property State: ConnectionState read get_State;
      ///<summary>
      ///  Returns the time to wait while trying to establish a connection.
      ///</summary>
      ///<remarks>
      ///  ConnectionTimeout contains the number of seconds to wait while trying to establish a connection before terminating the attempt and generating an error.
      ///</remarks>
      property ConnectionTimeout: Integer read get_ConnectionTimeout;
  end;

  TAdoDbxExtension = class
    strict private
      FConnection:  TAdoDbxConnection;

    public
      constructor Create(Connection: TAdoDbxConnection);
      ///<summary>
      ///  Retrieves vendor specific information. An empty string is returned
      ///  if the property is not supported.
      ///</summary>
      function GetVendorProperty(const Name: WideString): WideString;
  end;

  TAdoDbxTransaction = class(DbTransaction)
    strict private
      FTransaction: TDBXTransaction;
      FConnection:  TAdoDbxConnection;
      FIsolation:   IsolationLevel;
    private
      constructor Create(DbxTransaction: TDBXTransaction; Connection: TAdoDbxConnection; Isolation: IsolationLevel);

    strict protected
      function  get_DbConnection: DbConnection; override;

    public
      destructor Destroy; override;
      function  get_IsolationLevel: IsolationLevel; override;
      procedure Commit; override;
      procedure Rollback; override;

  end;

  TAdoDbxParameterCollection = class;


///<summary>
///  Use the TAdoDbxCommand constructor to create a new instance of a TAdoDbxCommand object. The TAdoDbxCommand object is created automatically in your project when you create a TAdoDbxDataAdapter object. The TAdoDbxCommand object provides the means for executing SQL statements and stored procedures.
///
///TAdoDbxCommand is an implementation of the .NET DbCommand class.
///
///The CommandType property specifies whether a SQL statement, a table name, or a stored procedure name is being used in the CommandText property.
///
///- The Connection property should be set to a valid TAdoDbxConnection.
///- The Transaction property must be set to a valid TAdoDbxTransaction, to execute a SQL statement in the context of a transaction.
///Depending on the type of SQL statement being executed, you can use one of the following methods:
///
///- ExecuteReader. Used for Select statements and stored procedures that return a reader or multiple readers. A new TAdoDbxDataReader is returned if ExecuteReader successfully processes the SQL statement. You cannot update data when using a TAdoDbxDataReader object. To update data, use the TAdoDbxDataAdapter object.
///- ExecuteScalar. Similar to ExecuteReader but returns only the first column of the first record as an object and is primarily used to execute SQL to return aggregate values.
///- ExecuteNonQuery. Executes DDL or non-Select DML statements or stored procedures that return no dataset. On successful execution of a DML statement, ExecuteNonQuery returns the number of rows affected in the database.
///To execute parameterized SQL, you can specify the CommandText values with parameter markers. The ? character is used as a parameter marker. Currently, there is no support for named parameters. During preparation, the database-specific provider implementation takes care of converting the ? parameter markers to database-specific parameter markers and also takes care of generating the appropriate SQL for calling a stored procedure.
///
///When executing the same SQL repeatedly, call the Prepare method once and bind parameters. You specify parameters by adding a TadoDbxParameterCollection to the TAdoDbxCommand.Parameters property. Preparing a parameterized SQL statement on most databases creates an execution plan on the server that is then used during subsequent execution of the same SQL with different parameter values.
///
///Once the TAdoDbxCommand is complete, calling Dispose (or Free in Delphi) frees all of the statement resources allocated by the provider.
///</summary>


  [ToolboxBitmap(typeof(TAdoDbxCommand))]
  TAdoDbxCommand = class(DbCommand, ICloneable)
    private
      FDbxCommand:            TDBXCommand;
      FCommandText:           String;
      FCommandType:           CommandType;
      FDbConnection:          TAdoDbxConnection;
      FParameterCollection:   TAdoDbxParameterCollection;
      FDbTransaction:         DbTransaction;
      FDesignTimeVisible:     Boolean;
      FUpdatedRowSource:      UpdateRowSource;
      FNeedDbxValueTypes:     Boolean;
      FDBXReader:             TDBXReader;
      FDBXValueTypes:         TDBXValueTypes;

      procedure InitDbxCommand;

    private
      FDBXContext:        TDBXContext;
      constructor Create(DBXContext: TDBXContext; DbConnection: TAdoDbxConnection); overload;

      function FindValueType(Name: String): TDBXValueType;

    strict protected
      function  CreateDbParameter: DbParameter; override;
      function  ExecuteDbDataReader(Behavior: CommandBehavior): DbDataReader; override;

      function  get_DbConnection: DbConnection; override;
      procedure set_DbConnection(Connection: DbConnection); override;
      function  get_DbTransaction: DbTransaction; override;
      procedure set_DbTransaction(Transaction: DbTransaction); override;
      function  get_DbParameterCollection: DbParameterCollection; override;

    public
      procedure SetDbxValueTypes(SqlSelect: String);
      procedure SetNeedDbxValueTypes(NeedDbxValueTypes: Boolean);
      function  get_CommandText: String; override;
      procedure set_CommandText(CommandText: String); override;
      function  get_CommandTimeout: Integer; override;
      procedure set_CommandTimeout(Timeout: Integer); override;
      function  get_CommandType: CommandType; override;
      procedure set_CommandType(CommandType: CommandType); override;
      function  get_DesignTimeVisible: Boolean; override;
      procedure set_DesignTimeVisible(DesignTimeVisible: Boolean); override;
      function  get_UpdatedRowSource: UpdateRowSource; override;
      procedure set_UpdatedRowSource(UpdatedRowSource: UpdateRowSource); override;

      function Clone: TObject;

      constructor Create(); overload;
      ///<summary>
      /// Destroys a TAdoDbxCommand instance by calling the Close method
      ///</summary>
      ///Cancel attempts to cancel a TAdoDbxCommand. If a command is in progress, it is cancelled. No exception is generated if the cancel fails. If no command is in progress, nothing happens.
      ///<remarks>
      ///This method destroys a TAdoDbxCommand instance, freeing all its resources.
      ///Note:  Developers should rarely call Destroy directly; calling Dispose (or Free in Delphi) maps the call to the destructor.
      ///</remarks>
      destructor Destroy; override;

      ///<summary>
      /// Attempts to cancel a TAdoDbxCommand.
      ///</summary>
      ///Cancel attempts to cancel a TAdoDbxCommand. If a command is in progress, it is cancelled. No exception is generated if the cancel fails. If no command is in progress, nothing happens.
      ///<remarks>
      ///</remarks>
      procedure Cancel; override;
      ///<summary>
      ///Executes a SQL statement against a connection object.
      ///</summary>
      ///<remarks>
      ///  ExecuteNonQuery does not return data, but does allow you to perform SQL UPDATE, INSERT, or DELETE statements to modify a database. ExecuteNonQuery returns the number of rows affected for executing UPDATE, INSERT, or DELETE statements and -1 otherwise.
      ///</remarks>
      function  ExecuteNonQuery: Integer; override;
      ///<summary>
      ///Execute a SQL query and return the first column of the first row of data.
      ///</summary>
      ///<remarks>
      ///  ExecuteScalar returns only the first column of the first row of data from a SQL query.
      ///</remarks>
      function  ExecuteScalar: System.Object; override;
      ///<summary>
      ///Create a prepared version of a command on the data source.
      ///</summary>
      ///<remarks>
      ///Prepare creates a compiler version of a SQL command on the data source. If the CommandType property is TableDirect, Prepare does nothing.
      ///</remarks>
      procedure Prepare; override;
      ///<summary>
      ///Determines whether or not a command is visible at design time.
      ///</summary>
      ///<remarks>
      ///  A boolean that can be set on a TAdoDbxCommand to determine the command's visibility during design time.
      ///</remarks>
      property DesignTimeVisible: Boolean read get_DesignTimeVisible write set_DesignTimeVisible;
   published
      ///<summary>
      ///Gets or sets the SQL statement, table name, or stored procedure to execute at the data source.
      ///</summary>
      ///<remarks>
      ///When you set the CommandType property to StoredProcedure, you set the CommandText property to the name of the stored procedure. You might need to use escape character syntax if your stored procedure name contains special characters, such as underscores. The command executes this stored procedure when you call either the ExecuteReader, ExecuteScalar, or ExecuteNonQuery methods. When you set the CommandType property to TableDirect, you set the CommandText property to the name of the table you want to access. You might need to use escape character syntax if any of the tables contain special characters.
      ///</remarks>
      property CommandText: String read get_CommandText write set_CommandText;
      ///<summary>
      ///Gets or sets the time, in seconds, before terminating a long-running SQL command.
      ///</summary>
      ///<remarks>
      ///CommandTimeout gets or set the wait time in seconds before terminating a command and generating an error.
      ///</remarks>
      property CommandTimeout: Integer read get_CommandTimeout write set_CommandTimeout;
      ///<summary>
      ///  Gets or sets the CommandType that indicates how to interpret the CommandText property.
      ///</summary>
      ///<remarks>
      ///When you set the CommandType property to StoredProcedure, you should set the CommandText property to the name of the stored procedure. The command executes this stored procedure when you call the ExecuteScalar, ExecuteReader, or ExecuteNonQuery methods. The Connection, CommandType and CommandText properties cannot be set if the current connection is performing an execute or fetch operation.
      ///
      ///AdoDbxClient supports the ? symbol as a placeholder for passing parameters to a SQL statement or a stored procedure called by a TAdoDbxCommand when CommandType is set to Text.
      ///+Type  Description
      /// Text   A SQL command. Default.
      /// TableDirect   If you set the CommandType property to TableDirect, set the CommandText property to the name of the table you want to access. You might need to use escape characters or other qualifying characters if the tables contain special characters. When you call one of the Execute methods, the query returns all rows and columns.
      /// StoredProcedure   The name of a stored procedure.
      ///</remarks>
      property CommandType: CommandType read get_CommandType write set_CommandType;

      ///<summary>
      ///Gets the TAdoDbxParameterCollection.
      ///</summary>
      ///<remarks>
      ///The parameters of the SQL statement or stored procedure. The default is an empty collection.
      ///
      ///You cannot use named parameters for passing parameters to a SQL Statement or a stored procedure called by a TAdoDbxCommand when CommandType is set to Text. In this case, the question mark (?) placeholder must be used. For example: SELECT * FROM Employee WHERE EmployeeID = ? . The order in which TAdoDbxParameter objects are added to the TAdoDbxParameterCollection must directly correspond to the position of the question mark placeholder for the parameter.
      ///
      ///If the parameters in the collection do not match the requirements of the query to be executed, you may get an error.
      ///</remarks>
      property Parameters: DbParameterCollection read get_DbParameterCollection;

      ///<summary>
      ///Provide the transaction in which the TAdoDbxCommand executes.
      ///</summary>
      ///<remarks>
      ///Specify the transaction you want the command to execute within. You must already have created the transaction prior to naming it with the Transaction property on the TAdoDbxCommand.
      ///
      ///Warning:  You cannot set the Transaction property if it is already set to a specific value and the command is in the process of executing. If you set the transaction property to a TAdoDbxTransaction object that is not connected to the same TAdoDbxConnection as the TAdoDbxCommand object, an exception is thrown the next time you attempt to execute a statement.
      ///</remarks>
      property Transaction: DbTransaction read get_DbTransaction write set_DbTransaction;

      ///<summary>
      ///Gets or sets how command results are applied to the <c>DataRow</c> when used by the Update method of the TAdoDbxDataAdapter.
      ///</summary>
      ///<remarks>
      ///Use one of the following UpdatedRowSource values. The default is Both unless the command is automatically generated; then the default is None.
      ///+Constant  Value  Description
      ///None   0   Do not fetch new data for row at execution of command. Default if the command is automatically generated.
      ///OutputParameters   1   Fetch new data for the row using output parameters.
      ///FirstReturnedRecord   2   Fetch new data for the row using the first returned record.
      ///Both   3   Fetch new data for the row using the first returned record and output parameters. Default.
      ///</remarks>
      property UpdateRowSource: UpdateRowSource read get_UpdatedRowSource write set_UpdatedRowSource;

      property Connection: TAdoDbxConnection read FDbConnection write FDbConnection;
  end;

  TObjectArray = array of System.Object;

  ///<summary>
  ///A TAdoDbxDataReader is returned as a result of a SELECT or stored procedure execution from a call to TAdoDbxCommand.ExecuteReader. Because there is no public constructor, you cannot directly instantiate a TAdoDbxDataReader. Instead, obtain the TAdoDbxDataReader through the ExecuteReader method of the TAdoDbxCommand object.
  ///</summary>
  ///
  ///<remarks>
  ///The TAdoDbxDataReader class is an implementation of the ADO.NET DbDataReader class.
  ///
  ///The TAdoDbxDataReader provides a forward-only reader and the associated metadata. TAdoDbxDataReader methods such as GetName, GetDataTypeName, GetFieldType, and GetDataTypeName provide the metadata.
  ///
  ///For all of these methods, you must pass the ordinal of the column, which is zero-based, in the ordinal. Given a column name, GetOrdinal returns the column ordinal or position in the select list. GetName, GetDataTypeName, and GetFieldType return the name, SQL datatype name, and the .NET Framework System.Type, respectively, for a particular column. GetSchemaTable also can be used to retrieve the metadata of a column as a DataTable.
  ///
  ///You can call TAdoDbxDataReader.Read to fetch records one after the other until a false value is returned, which indicates that you have hit the EOF. Before accessing individual column values, you can check to see if the data is NULL by calling IsDBNull. Then, depending on the datatype, you can call one of the field accessor methods, such as GetInt16, GetInt32, or GetFloat.
  ///
  ///You can access BLOB data as a byte array or a character array by calling GetBytes or GetChars. A null buffer passed to these methods returns the size of the BLOB data available. The current implementation of TAdoDbxDataReader does not support fetching BLOB data by specifying offsets.
  ///
  ///The initial state of the TAdoDbxDataReader returned from a call to TAdoDbxCommand.ExecuteReader is open. Once all of the records have been fetched, you can call the Close method to free all of the column-related resources. To find out if a TAdoDbxDataReader is closed, you can check the IsClosed property. If the TAdoDbxDataReader is closed, it returns True, otherwise False. If the CommandBehavior parameter is CloseConnection in ExecuteReader, the TAdoDbxConnection used for executing the SQL is also closed when the TAdoDbxDataReader is closed. The NextResult method returns True if more results are available from a stored procedure execution.
 ///</remarks>
  TAdoDbxDataReader = class(DbDataReader)
    strict private
      FCommandBehavior:   CommandBehavior;
      FDbxCommand:        TDBXCommand;
      FDbxReader:         TDBXReader;
      FPeekAheadRead:     Boolean;
    private
      FDBXContext:        TDBXContext;
      FDbConnection:      TAdoDbxConnection;
      constructor Create(DBXContext: TDBXContext; DbxCommand: TDBXCommand; DbxReader: TDBXReader; Behavior: CommandBehavior; DbConnection: TAdoDbxConnection);
    public
      function get_Depth: Integer; override;
      function get_FieldCount: Integer; override;
      function get_HasRows: Boolean; override;
      function get_IsClosed: Boolean; override;
      function get_RecordsAffected: Integer; override;
      function get_Item(Ordinal: Integer): TObject; overload; override;
      function get_Item(Name: String): TObject; overload; override;


      ///<summary>
      ///  Destroys a TAdoDbxDataReader instance.
      ///</summary>
      ///<remarks>
      /// This method should not be called directly.  Call the Close or Free method instead.
      ///</remarks>
      destructor Destroy; override;

      ///<summary>
      ///  Closes the DbDataReader.
      ///</summary>
      ///<remarks>
      /// This method should be called as soon as the TAdoDBXDataReader is no longer needed to free up resources.
      ///</remarks>
      procedure Close; override;
      function  GetDataTypeName(Ordinal: Integer): String; override;
      function  GetEnumerator: IEnumerator; override;
      function  GetFieldType(Ordinal: Integer): System.Type; override;
      function  GetName(Ordinal: Integer): String; override;
      function  GetOrdinal(Name: String): Integer; override;
      ///<summary>
      ///</summary>
      ///<remarks>
      ///</remarks>
      function  GetSchemaTable: DataTable; override;

      function  GetBoolean(Ordinal: Integer): Boolean; override;
      function  GetByte(Ordinal: Integer): Byte; override;

      ///<summary>
      ///  Get column value into an TBytes.
      ///</summary>
      /// <param name="Ordinal">Column Ordinal to read from.</param>
      /// <param name="DataOffset">Offset into the data to start reading from.</param>
      /// <param name="Bytes">Byte array to read into.</param>
      /// <param name="Length">Max number of bytes to read.</param>
      ///<returns>
      ///  Number of bytes read.
      ///</returns>
      function  GetBytes(Ordinal: Integer; DataOffset: Int64;
                         Bytes: TBytes; BufferOffset: Integer;
                         Length: Integer): Int64; override;

      function  GetChar(Ordinal: Integer): Char; override;
      ///<summary>
      ///  Get column value into an array of chars.
      ///</summary>
      /// <param name="Ordinal">Column Ordinal to read from.</param>
      /// <param name="DataOffset">Offset into the data to start reading from.</param>
      /// <param name="Bytes">char array to read into.</param>
      /// <param name="Length">Max number of chars to read.</param>
      ///<returns>
      ///  Number of chars read.
      ///</returns>
      function  GetChars(Ordinal: Integer; DataOffset: Int64;
                         Bytes: array of char; BufferOffset: Integer;
                         Length: Integer): Int64; override;
      function  GetDateTime(Ordinal: Integer): DateTime; override;
      function  GetDecimal(Ordinal: Integer): Decimal; override;
      function  GetDouble(Ordinal: Integer): double; override;
      function  GetFloat(Ordinal: Integer): single; override;
      function  GetGuid(Ordinal: Integer): Guid; override;
      function  GetInt16(Ordinal: Integer): Smallint; override;
      function  GetInt32(Ordinal: Integer): Integer; override;
      function  GetInt64(Ordinal: Integer): Int64; override;
      function  GetString(Ordinal: Integer): String; override;
      function  GetValue(ordinal: Integer): TObject; override;
      function  GetValues(Values: TObjectArray): Integer; override;
      function  IsDBNull(Ordinal: Integer): Boolean; override;
      function  NextResult: Boolean; override;
      function  Read: Boolean; override;
      function  GetData(Index: Integer): IDataReader;

      ///<summary>
      ///  Gets or sets the depth of nesting for the current row.
      ///</summary>
      ///<remarks>
      ///  Depth returns the nesting depth of the current row in the current table. The outermost table has a depth of 0.
      ///</remarks>
      property Depth: Integer read get_Depth;
      ///<summary>
      ///  Number of Columns in this DbDataReader
      ///</summary>
      ///<result>
      /// Number of Columns in this DbDataReader
      ///</result>
      property FieldCount: Integer read get_FieldCount;
      ///<summary>
      ///  Indicates whether a TAdoDbxDataReader has rows.
      ///</summary>
      ///<remarks>
      /// HasRows is true when the TAdoDbxDataReader has one or more rows; false otherwise.
      ///</remarks>
      property HasRows: Boolean read get_HasRows;
      property IsClosed: Boolean read get_IsClosed;
      property RecordsAffected: Integer read get_RecordsAffected;
      property Item[Ordinal: Integer]: TObject read get_Item; default;
      property Item[Name: String]: TObject read get_Item; default;

    end;

  TAdoDbxParameterCollection = class(DbParameterCollection)
    private
      FDBXParameters:   TDBXParameterList;
      FParameters:      ArrayList;
    strict protected
      function  GetParameter(Ordinal: Integer): DbParameter; override;
      function  GetParameter(Name: String): DbParameter; override;
      procedure SetParameter(Ordinal: Integer; Parameter: DbParameter); override;
      procedure SetParameter(Name: String; Parameter: DbParameter); override;

    private
      FDBXContext:        TDBXContext;
      constructor Create(DBXContext: TDBXContext; DbxParameters: TDBXParameterList);
      function  AddExisting(Parameter: TAdoDbxParameter): Integer;
      procedure SetPendingValues(Connection: TAdoDbxConnection; Command: TAdoDbxCommand);
    public
      destructor Destroy; override;
      function  Add(Value: TObject): Integer; override;
      procedure AddRange(Values: System.Array); override;
      procedure Clear; override;
      function  Contains(Value: TObject): Boolean; override;// overload;
      function  Contains(Value: string): Boolean; override;// overload;
      procedure CopyTo(Values: System.Array; Index: Integer); override;
      function  GetEnumerator: IEnumerator; override;
      function  IndexOf(Parameter: TObject): Integer; override;// overload;
      function  IndexOf(Name: String): Integer; override;// overload;
      procedure Insert(Ordinal: Integer; Parameter: TObject); override;
      procedure RemoveAt(Ordinal: Integer); override;
      procedure RemoveAt(Name: String); override;
      procedure Remove(Parameter: TObject); override;

      function  get_Count: Integer; override;
      function  get_IsFixedSize: Boolean; override;
      function  get_IsReadOnly: Boolean; override;
      function  get_IsSynchronized: Boolean; override;

//      function  get_Item(Ordinal: Integer): DbParameter; override; overload;
//      procedure set_Item(Ordinal: Integer; Parameter: DbParameter); override; overload;
//      function  get_Item(Name: String): DbParameter; override; overload;
//      procedure set_Item(Name: String; Parameter: DbParameter); override; overload;

      function  get_SyncRoot: TObject; override;
//      function  get_DbType: DbType; override;
//      procedure set_DbType(DbType: DbType); override;
//      function  get_DbType: DbType; override;
//      procedure set_DbType(DbType: DbType); override;

  end;

///<summary>
///  Represents a parameter that is passed to or from a command.
///</summary>
///  <remarks>
///  If you are using parameterized SQL or stored procedures, you can pass parameters to them using the TAdoDbxParameter class. The Direction property determines whether a parameter is an input parameter, an output parameter, or a return value. You can create a new instance of a TAdoDbxParameter object using the simple constructor syntax. You can also specify a number of overloaded values in the constructor.

/// The TAdoDbxParameter class is an implementation of the ADO.NET DbParameter class.

/// To pass runtime parameters for a parameterized SQL statement or stored procedure,
/// use the TAdoDbxParameterCollection class. An empty TAdoDbxParameterCollection
/// is returned by the TAdoDbxCommand.Parameters property. After successfully
/// preparing the command, parameters are added to the TAdoDbxParameterCollection
/// by calling the Add method and passing the parameter information such as name,
/// datatype, precision, scale, size, and so on. You can use one of the overloaded
/// Add methods or you can set individual TAdoDbxParameter properties such as
/// Direction, Precision, Scale, DbType and Size.
///
/// Parameter names must be unique, and the parameters must be added to the
/// TAdoDbxParameterCollection in the same order in which parameter markers
/// appear in the SQL.  The Direction property, by default, is set to
/// ParameterDirection.Input. In the case of stored procedures,
/// it can be set to Output, InputOutput, or ReturnValue. If the inout
/// parameter is expected to return more data than the input, you should
/// specify the Precision to a size large enough to hold the output data.
///
/// Note:  Not all databases support all the different parameter directions.
///
/// While specifying the parameter datatype, you can use either System.Type
/// or the ADO.NET logical type and the subtype. You should set the
/// Value property with the runtime value for all parameters before executing
/// the command. After successful execution, output data is available in the
/// Value property.
///  </remarks>
  TAdoDbxParameter = class(DbParameter, ICloneable)
    private
      FDbxContext:              TDbxContext;
      FSourceColumn:            String;
      FSourceColumnNullMapping: Boolean;
      FSourceVersion:           DataRowVersion;
      FConnection:              TAdoDbxConnection;
      FName:                    String;
      FPendingValue:            Tobject;

    private
      FDBXParameter:            TDBXParameterEx;
      FDbxTypeOverridden:       Boolean;
      procedure OnError(DBXError: TDBXError);
      procedure SetPendingValue(Connection: TAdoDbxConnection);
      procedure SetPendingValueAndType(Connection: TAdoDbxConnection);
    public
      function  get_DbType: DbType; override;
      procedure set_DbType(DbType: DbType); override;
      function  get_Direction: ParameterDirection; override;
      procedure set_Direction(Direction: ParameterDirection); override;
      function  get_IsNullable: Boolean; override;
      procedure set_IsNullable(IsNullable: Boolean); override;
      function  get_ParameterName: String; override;
      procedure set_ParameterName(ParameterName: String); override;
      function  get_Size: Integer; override;
      procedure set_Size(Size: Integer); override;
      function  get_SourceColumn: String; override;
      procedure set_SourceColumn(SourceColumn: String); override;
      function  get_SourceColumnNullMapping: Boolean; override;
      procedure set_SourceColumnNullMapping(SourceColumnNullMapping: Boolean); override;
      function  get_SourceVersion: DataRowVersion; override;
      procedure set_SourceVersion(SourceVersion: DataRowVersion); override;
      function  get_Precision: Byte;
      procedure set_Precision(Precision: Byte);
      function  get_Scale: Byte;
      procedure set_Scale(Scale: Byte);
      function  get_Value: TObject; override;
      procedure set_Value(Value: TObject); override;
      function get_DbxDataType: Integer;
      function get_DbxSubType:  Integer;
      procedure set_DbxDataType(DbxDataType: Integer);
      procedure set_DbxSubType(DbxSubType: Integer);

      destructor Destroy; override;
///<summary>
///
///</summary>
///  <remarks>
///  </remarks>
      constructor Create(DbxContext: TDBXContext); overload;
      constructor Create(DbxParameter: TDBXParameterEx; Connection: TAdoDbxConnection); overload;
      function Clone: TObject; virtual;
      procedure ResetDbType; override;
  published
      property DbType: DbType read get_DbType write set_DbType;
      property Direction: ParameterDirection read get_Direction write set_Direction;
      property IsNullable: Boolean read get_IsNullable write set_IsNullable;
      property ParameterName: String read get_ParameterName write set_ParameterName;
      property Size: Integer read get_Size write set_Size;
      property SourceColumn: String read get_SourceColumn write set_SourceColumn;
      property SourceColumnNullMapping: Boolean read get_SourceColumnNullMapping write set_SourceColumnNullMapping;
      property SourceVersion: DataRowVersion read get_SourceVersion write set_SourceVersion;
      property Precision: Byte read get_Precision write set_Precision;
      property Scale: Byte read get_Scale write set_Scale;
      [TypeConverter(typeof(StringConverter))]
      property Value: TObject read get_Value write set_Value;
      property DbxDataType: Integer read get_DbxDataType write set_DbxDataType;
      property DbxSubType: Integer read get_DbxSubType write set_DbxSubType;


  end;

  TAdoDbxRowUpdatedEventArgs = class(RowUpdatedEventArgs)
  public
    function get_Command: TAdoDbxCommand;

    property Command: TAdoDbxCommand read get_Command;
  end;

  TAdoDbxRowUpdatingEventArgs = class(RowUpdatingEventArgs)
  public
    function get_Command: TAdoDbxCommand;
    procedure set_Command(const Value: TAdoDbxCommand);

    property Command: TAdoDbxCommand read get_Command write set_Command;
  end;

  TAdoDbxRowUpdatingEventHandler = procedure(Sender: System.Object; e: TAdoDbxRowUpdatingEventArgs) of object;
  TAdoDbxRowUpdatedEventHandler = procedure(Sender: System.Object; e: TAdoDbxRowUpdatedEventArgs) of object;

  [ToolboxBitmap(typeof(TAdoDbxDataAdapter))]
  TAdoDbxDataAdapter = class(DbDataAdapter)
  strict private
    class var FEventRowUpdated: System.Object;
    class var FEventRowUpdating: System.Object;
  strict protected

    function CreateRowUpdatingEvent(dataRow: DataRow; command: IDbCommand; statementType: StatementType; tableMapping: DataTableMapping): RowUpdatingEventArgs; override;
    function CreateRowUpdatedEvent(dataRow: DataRow; command: IDbCommand; statementType: StatementType; tableMapping: DataTableMapping): RowUpdatedEventArgs; override;

    procedure OnRowUpdated(value: RowUpdatedEventArgs); override;
    procedure OnRowUpdating(value: RowUpdatingEventArgs); override;
  public
    function get_SelectCommand: TAdoDbxCommand;
    function get_DeleteCommand: TAdoDbxCommand;
    function get_InsertCommand: TAdoDbxCommand;
    function get_UpdateCommand: TAdoDbxCommand;
    procedure set_SelectCommand(const Value: TAdoDbxCommand);
    procedure set_DeleteCommand(const Value: TAdoDbxCommand);
    procedure set_InsertCommand(const Value: TAdoDbxCommand);
    procedure set_UpdateCommand(const Value: TAdoDbxCommand);
    procedure add_RowUpdated(const Value: TAdoDbxRowUpdatedEventHandler);
    procedure add_RowUpdating(const Value: TAdoDbxRowUpdatingEventHandler);
    procedure remove_RowUpdated(const Value: TAdoDbxRowUpdatedEventHandler);
    procedure remove_RowUpdating(const Value: TAdoDbxRowUpdatingEventHandler);

    class constructor Create;

    constructor Create; overload;
    constructor Create(Command: TAdoDbxCommand); overload;
    constructor Create(const selectCommandText, selectConnectionString: string); overload;
    constructor Create(const selectCommandText: string; selectConnection: TAdoDbxConnection); overload;

    property SelectCommand: TAdoDbxCommand read get_SelectCommand write set_SelectCommand;
    property InsertCommand: TAdoDbxCommand read get_InsertCommand write set_InsertCommand;
    property DeleteCommand: TAdoDbxCommand read get_DeleteCommand write set_DeleteCommand;
    property UpdateCommand: TAdoDbxCommand read get_UpdateCommand write set_UpdateCommand;

    property RowUpdated: TAdoDbxRowUpdatedEventHandler add add_RowUpdated remove remove_RowUpdated;
    property RowUpdating: TAdoDbxRowUpdatingEventHandler add add_RowUpdating remove remove_RowUpdating;
  end;

  TAdoDbxDataSourceEnumerator = class(DbDataSourceEnumerator)

  end;

  ///<summary>
  ///  Generates single-table commands as part of the operation of the TAdoDbxDataAdapter.
  ///</summary>
  ///<remarks>
  ///The TAdoDbxCommandBuilder class is used to automatically generate single-table commands to reconcile changes made to a DataSet with its underlying database.
  ///
  ///TAdoDbxCommandBuilder implements the ADO.NET <code>DbCommandBuilder</code> class.
  ///
  ///You can generate SQL commands based on the SelectCommand property, which you must set prior to executing any of the other TAdoDbxCommandBuilder methods. The results of the SelectCommand are used to return metadata that is then used to construct the arguments to the InsertCommand, UpdateCommand, or DeleteCommand methods. If you want to achieve greater performance, you might want to consider using direct commands, rather than using the TAdoDbxCommandBuilder.
  ///
  ///If you review the SQL statements generated for the UpdateCommand and DeleteCommand, you see that they each contain a WHERE clause that specifies that the row can only be updated if it contains all original values and hasn't been deleted from the database. Records are not locked and therefore the TAdoDbxCommandBuilder operates on the basis of optimistic concurrency. If you try to update or delete a record that has been changed by another user, the operation throws a DBConcurrencyException.
  ///
  ///Note:  You can only use the TAdoDbxCommandBuilder on standalone tables. If you try to update a column that participates in a foreign-key constraint, you might encounter a failure.
  ///
  ///Warning:  The SelectCommand must return at least one primary key or unique column.
  ///</remarks>
  [ToolboxBitmap(typeof(TAdoDbxCommandBuilder))]
  TAdoDbxCommandBuilder = class(DbCommandBuilder)
  strict protected
    procedure ApplyParameterInfo(parameter: DbParameter; row: DataRow;
      statementType: StatementType; whereClause: Boolean); override;
    function GetParameterName(parameterOrdinal: Integer): string; override;
    function GetParameterName(parameterName: string): string; override;
    function GetParameterPlaceholder(parameterOrdinal: Integer): string;
      override;
    procedure SetRowUpdatingHandler(adapter: DbDataAdapter); override;
    procedure AdoDbxRowUpdatingHandler(Sender: System.Object; e: TAdoDbxRowUpdatingEventArgs);
  public
    function QuoteIdentifier(unquotedIdentifier: string):string; override;
    function UnquoteIdentifier(quotedIdentifier: string):string; override;
    ///<summary>
    ///Creates an instance of TAdoDbxCommandBuilder
    ///</summary>
    ///<remarks>
    ///This constructor creates and initializes an instance of TAdoDbxCommandBuilder.
    ///</remarks>
    constructor Create; overload;
    constructor Create(Adapter: TAdoDbxDataAdapter); overload;
  end;

  ///<summary Localizable Categories used for connection string builder UI.</summary>
  [AttributeUsage(AttributeTargets.All)]
  TLocalizableConnectionStringCategory = class(CategoryAttribute)
  strict protected
    function GetLocalizedString(Value: string): string; override;
  public
    const
      ///<summary>Dynalink related properties</summary>
      Dynalink = 'Dynalink'; // do not localize
      ///<summary>Driver configuration related properties</summary>
      DriverConfiguration = 'DriverConfiguration'; // do not localize
      ///<summary>Database related properties</summary>
      DataBase = 'Database'; // do not Localize
  end;

resourcestring
  resDynalink = 'Dynalink';
  resDriverConfiguration = 'Driver Configuration';
  resDataBase = 'Database';

type
  TAdoDbxConnectionStringBuilder = class(DbConnectionStringBuilder)
  public
    constructor Create;
    function get_ConnectionName: string;
    function get_Database: string;
    function get_DelegateConnection: string;
    function get_DelegateDriver: string;
    function get_DriverAssembly: string;
    function get_DriverAssemblyLoader: string;
    function get_DriverName: string;
    function get_DriverPackage: string;
    function get_DriverPackageLoader: string;
    function get_DriverUnit: string;
    function get_ErrorResourceFile: string;
    function get_GetDriverFunc: string;
    function get_HostName: string;
    function get_IsolationLevel: Integer;
    function get_LibraryName: string;
    function get_MaxBlobSize: Integer;
    function get_MetaDataAssemblyLoader: string;
    function get_MetaDataPackageLoader: string;
    function get_Password: string;
    function get_Port: Integer;
    function get_ProductVersion: string;
    function get_Role: string;
    function get_SchemaOverride: string;
    function get_User_Name: string;
    function get_VendorLib: string;
    procedure set_ConnectionName(const Value: string);
    procedure set_Database(const Value: string);
    procedure set_DelegateConnection(const Value: string);
    procedure set_DelegateDriver(const Value: string);
    procedure set_DriverAssembly(const Value: string);
    procedure set_DriverAssemblyLoader(const Value: string);
    procedure set_DriverName(const Value: string);
    procedure set_DriverPackage(const Value: string);
    procedure set_DriverPackageLoader(const Value: string);
    procedure set_DriverUnit(const Value: string);
    procedure set_ErrorResourceFile(const Value: string);
    procedure set_GetDriverFunc(const Value: string);
    procedure set_HostName(const Value: string);
    procedure set_IsolationLevel(const Value: Integer);
    procedure set_LibraryName(const Value: string);
    procedure set_MaxBlobSize(const Value: Integer);
    procedure set_MetaDataAssemblyLoader(const Value: string);
    procedure set_MetaDataPackageLoader(const Value: string);
    procedure set_Password(const Value: string);
    procedure set_Port(const Value: Integer);
    procedure set_ProductVersion(const Value: string);
    procedure set_Role(const Value: string);
    procedure set_SchemaOverride(const Value: string);
    procedure set_User_Name(const Value: string);
    procedure set_VendorLib(const Value: string);

    procedure set_Item(keyword: string; value: TObject); override;
    function get_Item(keyword: string): TObject; override;
    function TryGetValue(keyword: string; out value: TObject): Boolean; override;

    property DriverName: string read get_DriverName write set_DriverName;
    property ConnectionName: string read get_ConnectionName write set_ConnectionName;
    property DelegateDriver: string read get_DelegateDriver write set_DelegateDriver;
    property ErrorResourceFile: string read get_ErrorResourceFile write set_ErrorResourceFile;

    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.DriverConfiguration)]
    property GetDriverFunc: string read get_GetDriverFunc write set_GetDriverFunc;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.DriverConfiguration)]
    property VendorLib: string read get_VendorLib write set_VendorLib;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.DriverConfiguration)]
    property DriverUnit: string read get_DriverUnit write set_DriverUnit;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.DriverConfiguration)]
    property DriverPackage: string read get_DriverPackage write set_DriverPackage;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.DriverConfiguration)]
    property DriverAssembly: string read get_DriverAssembly write set_DriverAssembly;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.DriverConfiguration)]
    property DriverPackageLoader: string read get_DriverPackageLoader write set_DriverPackageLoader;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.DriverConfiguration)]
    property DriverAssemblyLoader: string read get_DriverAssemblyLoader write set_DriverAssemblyLoader;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.DriverConfiguration)]
    property MetaDataPackageLoader: string read get_MetaDataPackageLoader write set_MetaDataPackageLoader;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.DriverConfiguration)]
    property MetaDataAssemblyLoader: string read get_MetaDataAssemblyLoader write set_MetaDataAssemblyLoader;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.Dynalink)]
    property LibraryName: string read get_LibraryName write set_LibraryName;
  published
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.Database)]
    property HostName: string read get_HostName write set_HostName;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.Database)]
    property Port: Integer read get_Port write set_Port;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.Database)]
    property Database: string read get_Database write set_Database;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.Database)]
    property User_Name: string read get_User_Name write set_User_Name;
    [PasswordPropertyText(true)]
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.Database)]
    property Password: string read get_Password write set_Password;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.Database)]
    property Role: string read get_Role write set_Role;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.Database)]
    property IsolationLevel: Integer read get_IsolationLevel write set_IsolationLevel;
    property MaxBlobSize: Integer read get_MaxBlobSize write set_MaxBlobSize;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.DriverConfiguration)]
    property DelegateConnection: string read get_DelegateConnection write set_DelegateConnection;
    property SchemaOverride: string read get_SchemaOverride write set_SchemaOverride;
    [TLocalizableConnectionStringCategory(TLocalizableConnectionStringCategory.DriverConfiguration)]
    property ProductVersion: string read get_ProductVersion write set_ProductVersion;
  end;

  DbxDataSourceDescriptionAttribute = class(DescriptionAttribute)
    public
      constructor Create;
      function get_TypeId: System.Object; override;
  end;

  DbxDataSourceDisplayNameAttribute = class(DisplayNameAttribute)
    public
      constructor Create;
      function get_TypeId: System.Object; override;
  end; 

  DbxDataSource = class;

  [assembly: TagPrefix('Borland.Data', 'dbx')]  // define default asp.net tag prefix
  [DbxDataSourceDisplayName(), DbxDataSourceDescription(), ToolboxBitmap(typeof(DbxDataSource))]
  DbxDataSource = class(SqlDataSource)
    private
      procedure DbxSelecting(sender: TObject; args: SqlDataSourceSelectingEventArgs);
      procedure DbxUpdating(sender: TObject; args: SqlDataSourceCommandEventArgs);
      procedure DbxInserting(sender: TObject; args: SqlDataSourceCommandEventArgs);
      procedure DbxDeleting(sender: TObject; args: SqlDataSourceCommandEventArgs);
      procedure SetEvents;
    public
      constructor Create(); overload;
      constructor Create(ConnectionString: String; SelectCommand: String); overload;
      constructor Create(ProviderName: String; ConnectionString: String; SelectCommand: String); overload;
  end;

  resourcestring
    SCommandAlreadyPrepared   = 'Command already prepared';
    SUnSupported              = 'Unsupported Operation';
    SInvalidFieldType         = 'Invalid field type:  %s';

  implementation

uses
  System.Text,
  DbxSqlScanner,
  DbxMetadataUtil;

type
  TAdoDbxSchemaItem = class
    private
      FMetaDataCommand:   String;
      FRestrictions:      array of String;
      FNumberOfIdentifierParts: Integer;
      FNumberOfPeriodSeparatedParts: Integer;
    public
      constructor Create( Command:    String;
                          Restrictions: array of String;
                          UniqueIdentifiers: Integer);
      function CreateCommandText(const RestrictionValues: array of String; const QuoteChar, QuotePrefix, QuoteSuffix: string): String;
      function ComputePeriodSeparatedRestrictions: Integer;
  end;

const
  cQuote = '"';

{ TDbProviderFactory }

class procedure TAdoDbxProviderFactory.AddValueTypes(sql: String;
  ValueTypes: TDBXValueTypes);
begin
  if not FValueTypesCache.Contains(sql) then
  begin
    try
      FValueTypesCache.Add(sql, ValueTypes);
    except on Ex: ArgumentException do
      // Rare race condition where the item is there.
    end;
  end;
end;

procedure TAdoDbxProviderFactory.AdoDbxException(DBXError: TDBXError);
begin
  raise TAdoDbxException.Create(DBXError);
end;

class constructor TAdoDbxProviderFactory.Create;
begin
  Instance := TAdoDbxProviderFactory.Create(TDBXDriverHelp.CreateTDBXContext);
end;


constructor TAdoDbxProviderFactory.Create(DbxContext: TDBXContext);
begin
  inherited Create;
  FDBXContext := DBXContext;
end;

function TAdoDbxProviderFactory.CreateCommand: DbCommand;
begin
  Result := TAdoDbxCommand.Create();
end;

function TAdoDbxProviderFactory.CreateCommandBuilder: DbCommandBuilder;
begin
  Result := TAdoDbxCommandBuilder.Create;
end;

function TAdoDbxProviderFactory.CreateConnection: DbConnection;
begin
  Result := TAdoDbxConnection.Create;
end;

function TAdoDbxProviderFactory.CreateConnectionStringBuilder: DbConnectionStringBuilder;
begin
  Result := TAdoDbxConnectionStringBuilder.Create;
end;

function TAdoDbxProviderFactory.CreateDataAdapter: DbDataAdapter;
begin
  Result := TAdoDbxDataAdapter.Create;
end;

function TAdoDbxProviderFactory.CreateDataSourceEnumerator: DbDataSourceEnumerator;
begin
  Result := nil;
end;

function TAdoDbxProviderFactory.CreateParameter: DbParameter;
begin
  Result := TAdoDbxParameter.Create(FDbxContext);
end;


class function TAdoDbxProviderFactory.DbxToAdoParameterDirection(
  DbxParameterDirection: TDBXParameterDirection): ParameterDirection;
begin
  case DbxParameterDirection of
    TDBXParameterDirections.InParameter:       Result := ParameterDirection.Input;
    TDBXParameterDirections.OutParameter:      Result := ParameterDirection.Output;
    TDBXParameterDirections.InOutParameter:    Result := ParameterDirection.InputOutput;
    TDBXParameterDirections.ReturnParameter:   Result := ParameterDirection.ReturnValue;
    else
      Result := ParameterDirection.Input;
  end;

end;

class function TAdoDbxProviderFactory.AdoToDbxParameterDirection(
  AdoParameterDirection: ParameterDirection): TDBXParameterDirection;
begin
  case AdoParameterDirection of
    ParameterDirection.Input:               Result := TDBXParameterDirections.InParameter;
    ParameterDirection.Output:              Result := TDBXParameterDirections.OutParameter;
    ParameterDirection.InputOutput:         Result := TDBXParameterDirections.InOutParameter;
    ParameterDirection.ReturnValue:         Result := TDBXParameterDirections.ReturnParameter;
    else
                                            Result := TDBXParameterDirections.InParameter;
  end;

end;

class procedure  TAdoDbxProviderFactory.AdoToDbxType(Connection: TAdoDbxConnection; AdoType: DbType; var DbxDataType: Integer; var DbxSubType: Integer);
begin
  case AdoType of
    System.Data.DbType.String:
      begin
        DbxDataType := TDBXDataTypes.BlobType;
        DbxSubType := TDBXDataTypes.WideMemoSubType;
      end;
    System.Data.DbType.AnsiString:
      begin
        DbxDataType := TDBXDataTypes.BlobType;
        DbxSubType := TDBXDataTypes.MemoSubType;
      end;
    System.Data.DbType.Binary:
      begin
        if Connection <> nil then
        begin
          DbxDataType := Connection.FBlobDataType;
          DbxSubType  := Connection.FBlobSubType;
        end else
        begin
          DbxDataType := TDBXDataTypes.UnknownType;
          DbxSubType  := TDBXDataTypes.UnknownType;
        end;
      end;
    System.Data.DbType.Boolean:     DbxDataType := TDBXDataTypes.BooleanType;
    System.Data.DbType.Byte:        DbxDataType := TDBXDataTypes.UnknownType;
    System.Data.DbType.Currency:    DbxDataType := TDBXDataTypes.UnknownType;
    System.Data.DbType.Date:        DbxDataType := TDBXDataTypes.DateType;
    System.Data.DbType.DateTime:    DbxDataType := TDBXDataTypes.TimeStampType;
    System.Data.DbType.Decimal:     DbxDataType := TDBXDataTypes.BcdType;
    System.Data.DbType.Double:      DbxDataType := TDBXDataTypes.DoubleType;
    System.Data.DbType.Guid:        DbxDataType := TDBXDataTypes.UnknownType;
    System.Data.DbType.Int16:       DbxDataType := TDBXDataTypes.Int16Type;
    System.Data.DbType.Int32:       DbxDataType := TDBXDataTypes.Int32Type;
    System.Data.DbType.Int64:       DbxDataType := TDBXDataTypes.Int64Type;
    System.Data.DbType.SByte:       DbxDataType := TDBXDataTypes.UnknownType;
    System.Data.DbType.Single:      DbxDataType := TDBXDataTypes.DoubleType;
    System.Data.DbType.Time:        DbxDataType := TDBXDataTypes.TimeType;
    System.Data.DbType.UInt16:      DbxDataType := TDBXDataTypes.UInt16Type;
    System.Data.DbType.UInt32:      DbxDataType := TDBXDataTypes.Uint32Type;
    System.Data.DbType.UInt64:      DbxDataType := TDBXDataTypes.Uint64Type;
    System.Data.DbType.Object:      DbxDataType := TDBXDataTypes.UnknownType;
    System.Data.DbType.VarNumeric:  DbxDataType := TDBXDataTypes.UnknownType;
    System.Data.DbType.AnsiStringFixedLength:  DbxDataType := TDBXDataTypes.AnsiStringType;
    System.Data.DbType.StringFixedLength:  DbxDataType := TDBXDataTypes.WideStringType;
    System.Data.DbType.Xml:         DbxDataType := TDBXDataTypes.UnknownType;
    else
                                    DbxDataType := TDBXDataTypes.UnknownType;
  end;
end;

class function TAdoDbxProviderFactory.DbxToAdoType(DbxType: TDBXType): DbType;
begin

  case DbxType of
    TDBXDataTypes.WideStringType:       Result := System.Data.DbType.String;
    TDBXDataTypes.AnsiStringType:          Result := System.Data.DbType.AnsiString;
    TDBXDataTypes.VarBytesType:         Result := System.Data.DbType.Binary;
    TDBXDataTypes.BooleanType:          Result := System.Data.DbType.Boolean;
//    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Byte;
//    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Currency;
    TDBXDataTypes.DateType:             Result := System.Data.DbType.Date;
    TDBXDataTypes.TimeStampType:        Result := System.Data.DbType.DateTime;
    TDBXDataTypes.BcdType:              Result := System.Data.DbType.Decimal;
    TDBXDataTypes.DoubleType:           Result := System.Data.DbType.Double;
//    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Guid;
    TDBXDataTypes.Int16Type:            Result := System.Data.DbType.Int16;
    TDBXDataTypes.Int32Type:            Result := System.Data.DbType.Int32;
    TDBXDataTypes.Int64Type:            Result := System.Data.DbType.Int64;
//    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.SByte;
//    TDBXDataTypes.FloatType:            Result := System.Data.DbType.Single;
    TDBXDataTypes.TimeType:             Result := System.Data.DbType.Time;
    TDBXDataTypes.UInt16Type:           Result := System.Data.DbType.UInt16;
    TDBXDataTypes.Uint32Type:           Result := System.Data.DbType.UInt32;
    TDBXDataTypes.Uint64Type:           Result := System.Data.DbType.UInt64;
//    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.VarNumeric;
//    TDBXDataTypes.AnsiStringType:          Result := System.Data.DbType.AnsiStringFixedLength;
//    TDBXDataTypes.WideStringType:       Result := System.Data.DbType.StringFixedLength;
//    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Xml;
    else
                                     Result := System.Data.DbType.Object;
  end;
end;


class function TAdoDbxProviderFactory.DbxToSystemType(
  DbxType, DbxSubType: TDBXType): System.Type;
type
  TCharArray = array of Char;
begin
  case DbxType of
    TDBXDataTypes.WideStringType:       Result := typeof(String);
    TDBXDataTypes.AnsiStringType:          Result := typeof(String);
    TDBXDataTypes.BlobType,
    TDBXDataTypes.VarBytesType:
    begin
      if (DbxSubtype = TDBXDataTypes.MemoSubType) or (DbxSubType = TDBXDataTypes.WideMemoSubType) then
      begin
        Result := typeof(String)
      end
      else
        Result := typeof(TBytes);
    end;
    TDBXDataTypes.BooleanType:          Result := typeof(Boolean);
//    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Byte;
//    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Currency;
    TDBXDataTypes.DateType:             Result := typeof(DateTime);
    TDBXDataTypes.TimeStampType:        Result := typeof(DateTime);
    TDBXDataTypes.BcdType:              Result := typeof(Decimal);
    TDBXDataTypes.DoubleType:           Result := typeof(double);
//    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Guid;
    TDBXDataTypes.Int16Type:            Result := typeof(SmallInt);
    TDBXDataTypes.Int32Type:            Result := typeof(Integer);
    TDBXDataTypes.Int64Type:            Result := typeof(Int64);
//    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.SByte;
//    TDBXDataTypes.FloatType:            Result := System.Data.DbType.Single;
    TDBXDataTypes.TimeType:             Result := typeof(DateTime);
    TDBXDataTypes.UInt16Type:           Result := typeof(uint16);
    TDBXDataTypes.Uint32Type:           Result := typeof(uint32);
    TDBXDataTypes.Uint64Type:           Result := typeof(uint64);
//    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.VarNumeric;
//    TDBXDataTypes.AnsiStringType:          Result := System.Data.DbType.AnsiStringFixedLength;
//    TDBXDataTypes.WideStringType:       Result := System.Data.DbType.StringFixedLength;
//    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Xml;
    else
                                     Result := typeof(TObject);
  end;

end;

destructor TAdoDbxProviderFactory.Destroy;
begin

  inherited;
end;

//class function TAdoDbxProviderFactory.DateTimeToDate(
//  DateTimeValue: TDBXTime): TDBXDate;
//begin
//
//end;

//class function TAdoDbxProviderFactory.DateTimeToTime(
//  DateTimeValue: TDBXTime): TDBXTime;
//begin
//
//end;

//class function TAdoDbxProviderFactory.DateTimeToTSQLTimeStamp(
//  DateTimeValue: DateTime): TSQLTimeStamp;
//begin
//
//end;

class function TAdoDbxProviderFactory.DateToDateTime(Date: TDBXDate): DateTime;
var
  TimeStamp: TTimeStamp;
begin
  TimeStamp.Time := 0;
  TimeStamp.Date := Date;
  Result := TimeStampToDateTime(TimeStamp).ToDateTime(nil);//IFormatProvider(nil));
end;

class function TAdoDbxProviderFactory.TimeToDateTime(Time: TDBXTime): DateTime;
var
  TimeStamp: TTimeStamp;
begin
  TimeStamp.Time := Time;
  TimeStamp.Date := DateDelta;
  Result := TimeStampToDateTime(TimeStamp).ToDateTime(nil);//IFormatProvider(nil));
end;

class function TAdoDbxProviderFactory.GetRowBytesOrStringValue(Value: TDBXValue): TObject;
var
  Bytes:        TBytes;
begin
  if Value.ValueType.SubType = TDBXDataTypes.WideMemoSubType then
    result := Value.GetWideString
  else if Value.ValueType.SubType = TDBXDataTypes.MemoSubType then
    Result := Value.GetAnsiString
  else
  begin
    SetLength(Bytes, Value.GetValueSize);
    Value.GetBytes(0, Bytes, 0, Length(Bytes));
    Result := Bytes;
  end;
end;


class function TAdoDbxProviderFactory.GetRowValue(DbxRow: TDBXValue): TObject;
begin
  if (DbxRow = nil) or DbxRow.IsNull then
    Result := DBNull.Value
  else begin
    case DbxRow.ValueType.DataType of
      TDBXDataTypes.WideStringType:       Result := DbxRow.GetWideString;
      TDBXDataTypes.AnsiStringType:          Result := DbxRow.GetAnsiString;
      TDBXDataTypes.VarBytesType:         Result := GetRowBytesOrStringValue(DbxRow);
      TDBXDataTypes.BooleanType:          Result := TObject(DbxRow.GetBoolean);
  //    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Byte;
  //    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Currency;
      TDBXDataTypes.DateType:             Result := DateToDateTime(DbxRow.GetDate);
      TDBXDataTypes.TimeStampType:        Result := DbxRow.GetTimestamp.ToDateTime(nil);//IFormatProvider(nil));
      TDBXDataTypes.BcdType:              Result := DbxRow.GetBCD.ToDecimal(nil);//IFormatProvider(nil));
      TDBXDataTypes.DoubleType:            Result := TObject(DbxRow.GetDouble);
  //    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Guid;
      TDBXDataTypes.Int16Type:            Result := TObject(DbxRow.GetInt16);
      TDBXDataTypes.Int32Type:            Result := TObject(DbxRow.GetInt32);
      TDBXDataTypes.Int64Type:            Result := TObject(DbxRow.GetInt64);
  //    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.SByte;
  //    TDBXDataTypes.FloatType:            Result := System.Data.DbType.Single;
      TDBXDataTypes.TimeType:             Result := TimeToDateTime(DbxRow.GetTime);
      TDBXDataTypes.UInt16Type:           Result := TObject(DbxRow.GetInt16);
      TDBXDataTypes.Uint32Type:           Result := TObject(DbxRow.GetInt32);
      TDBXDataTypes.Uint64Type:           Result := TObject(DbxRow.GetInt64);
      TDBXDataTypes.BlobType:             Result := GetRowBytesOrStringValue(DbxRow);
  //    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.VarNumeric;
  //    TDBXDataTypes.AnsiStringType:          Result := System.Data.DbType.AnsiStringFixedLength;
  //    TDBXDataTypes.WideStringType:       Result := System.Data.DbType.StringFixedLength;
  //    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Xml;
      else
                                       Result := System.Data.DbType.Object;
    end;
  end;

end;

class function TAdoDbxProviderFactory.GetValueTypes(sql: String): TDBXValueTypes;
var
  Value: TObject;
begin
  Value := FValueTypesCache.Item[sql];
  if Value = nil then
    Result := nil
  else
    Result := Value as TDBXvaluetypes;
end;

function TAdoDbxProviderFactory.ReadCanCreateDataSourceEnumerator: Boolean;
begin
  Result := true;
end;

class procedure TAdoDbxProviderFactory.SystemToDbxType(
  Connection: TAdoDbxConnection; SystemType: System.Type;
  var DbxDataType, DbxSubtype: TDBXType);
begin
  DbxDatatype := TDBXDataTypes.UnknownType;
  DbxSubtype  := TDBXDataTypes.UnknownType;
  case (System.Type.GetTypeCode(SystemType)) of
    TypeCode.String, TypeCode.Char:
      begin
      if Connection <> nil then
        DbxDataType := Connection.FStringDataType
      else
        DbxDataType := TDBXDataTypes.AnsiStringType;
      end;
    TypeCode.Byte, TypeCode.SByte:
      begin
        DbxDataType := TDBXDataTypes.Int16Type;
      end;
    TypeCode.UInt16, TypeCode.Int16:
      begin
        DbxDataType := TDBXDataTypes.Int16Type;
      end;
    TypeCode.UInt32, TypeCode.Int32:
      begin
        DbxDataType := TDBXDataTypes.Int32Type;
      end;
    TypeCode.UInt64, TypeCode.Int64:
      begin
        DbxDataType := TDBXDataTypes.Int64Type;
      end;
    TypeCode.Boolean:
      begin
        DbxDataType := TDBXDataTypes.BooleanType;
      end;
    TypeCode.Single:
      begin
        DbxDataType := TDBXDataTypes.DoubleType;
      end;
    TypeCode.Double:
      begin
        DbxDataType := TDBXDataTypes.DoubleType;
      end;
    TypeCode.Decimal:
      begin
        DbxDataType := TDBXDataTypes.BcdType;
      end;
    TypeCode.DateTime:
      begin
        DbxDataType := TDBXDataTypes.TimeStampType;
      end;
  end;
end;

class procedure TAdoDbxProviderFactory.Unsupported(DbxContext: TDBXContext);
begin
  DbxContext.Error(TDBXErrorCodes.NotSupported, SUnSupported);
end;

//function TDbProviderFactory.CreatePermission(
//  State: System.Security.Permissions.PermissionState): System.Security.CodeAccessPermission;
//begin
//  Result := inherited CreatePermission(State);
//end;

{ TDbConnection }


function TAdoDbxConnection.AdoDbxIsolation(
  Isolation: IsolationLevel): TDBXIsolation;
begin
  case Isolation of
    IsolationLevel.ReadCommitted:
      Result := TDBXIsolations.ReadCommitted;
    IsolationLevel.ReadUncommitted,
    IsolationLevel.Chaos:
      Result := TDBXIsolations.DirtyRead;
    IsolationLevel.RepeatableRead:
      Result := TDBXIsolations.RepeatableRead;
    IsolationLevel.Serializable:
      Result := TDBXIsolations.Serializable;
    IsolationLevel.Snapshot:
      Result := TDBXIsolations.SnapShot;
    else
      Result := TDBXIsolations.ReadCommitted;
  end;
end;

function TAdoDbxConnection.BeginDbTransaction(Isolation: IsolationLevel): DbTransaction;
begin
  Result := TAdoDbxTransaction.Create(FDbxConnection.BeginTransaction(AdoDbxIsolation(Isolation)), Self, Isolation);
end;

procedure TAdoDbxConnection.ChangeDatabase(DatabaseName: String);
begin
  TAdoDbxProviderFactory.Unsupported(FDBXContext);
end;

function TAdoDbxConnection.Clone: TObject;
var
  Copy: TAdoDbxConnection;
begin
  Copy                := TAdoDbxConnection(MemberwiseClone);
  Copy.FDbxConnection := nil;
  Result              := Copy;
end;

procedure TAdoDbxConnection.Close;
begin
  FreeAndNil(FClonedConnection);
  OnStateChange(FStateChangeClosed);
  FreeAndNil(FDbxExtension);
  try
    FreeAndNil(FDbxConnection);
  except
    FDbxConnection := nil;
    raise;
  end;
end;


constructor TAdoDbxConnection.Create;
begin
  inherited Create;
end;

constructor TAdoDbxConnection.Create(const ConnectionString: string);
begin
  Create;
  Self.ConnectionString := ConnectionString;
end;

class constructor TAdoDbxConnection.Create;
begin
  FStateChangeClosed := StateChangeEventArgs.Create(ConnectionState.Open, ConnectionState.Closed);
  FStateChangeOpen := StateChangeEventArgs.Create(ConnectionState.Closed, ConnectionState.Open);
end;

function TAdoDbxConnection.CreateDbCommand: DbCommand;
begin
  Result := TAdoDbxCommand.Create(FDBXContext, Self);
  Result.Connection := self;
end;

destructor TAdoDbxConnection.Destroy;
begin
  Close;
  inherited;
end;

function TAdoDbxConnection.GetSchema: DataTable;
begin
  Result := inherited GetSchema;
end;

function TAdoDbxConnection.GetSchema(Name: String): DataTable;
begin
  Result := GetSchema(Name, []);
end;

function TAdoDbxConnection.GetClonedConnectionIfNeeded: TAdoDbxConnection;
begin
  if Assigned(FClonedConnection) then
    Result := FClonedConnection
  else
  begin
    if FDbxConnection.DatabaseMetaData.MaxCommands > 1 then
      Result := Self
    else
    begin
      FClonedConnection := TAdoDbxConnection.Create;
      FClonedConnection.ConnectionString := ConnectionString;
      FClonedConnection.Open;
      Result := FClonedConnection;
    end
  end;
end;

function TAdoDbxConnection.GetDataSourceInformation: DataTable;
var
  Row:              DataRow;
begin
    Result := DataTable.Create;
    Result.Columns.Add(DbMetaDataColumnNames.CompositeIdentifierSeparatorPattern, typeof(string));
    Result.Columns.Add(DbMetaDataColumnNames.DataSourceProductName, typeof(string));
    Result.Columns.Add(DbMetaDataColumnNames.DataSourceProductVersion, typeof(string));
    Result.Columns.Add(DbMetaDataColumnNames.DataSourceProductVersionNormalized, typeof(string));
    Result.Columns.Add(DbMetaDataColumnNames.GroupByBehavior, typeof(GroupByBehavior));
    Result.Columns.Add(DbMetaDataColumnNames.IdentifierPattern, typeof(string));
    Result.Columns.Add(DbMetaDataColumnNames.IdentifierCase, typeof(IdentifierCase));
    Result.Columns.Add(DbMetaDataColumnNames.OrderByColumnsInSelect, typeof(Boolean));
    Result.Columns.Add(DbMetaDataColumnNames.ParameterMarkerFormat, typeof(string));
    Result.Columns.Add(DbMetaDataColumnNames.ParameterMarkerPattern, typeof(string));
    Result.Columns.Add(DbMetaDataColumnNames.ParameterNameMaxLength, typeof(Integer));
    Result.Columns.Add(DbMetaDataColumnNames.ParameterNamePattern, typeof(string));
    Result.Columns.Add(DbMetaDataColumnNames.QuotedIdentifierPattern, typeof(string));
    Result.Columns.Add(DbMetaDataColumnNames.QuotedIdentifierCase, typeof(IdentifierCase));
    Result.Columns.Add(DbMetaDataColumnNames.StatementSeparatorPattern, typeof(string));
    Result.Columns.Add(DbMetaDataColumnNames.StringLiteralPattern, typeof(string));
    Result.Columns.Add(DbMetaDataColumnNames.SupportedJoinOperators, typeof(SupportedJoinOperators));

    Row := Result.NewRow;
    Row[DbMetaDataColumnNames.CompositeIdentifierSeparatorPattern] := '.';
    Row[DbMetaDataColumnNames.DataSourceProductName] := TDBXConnectionEx(FDbxConnection).ProductName;
    Row[DbMetaDataColumnNames.DataSourceProductVersion] := TDbxConnectionEx(FDbxConnection).ProductVersion;
    Row[DbMetaDataColumnNames.DataSourceProductVersionNormalized] := TDbxConnectionEx(FDbxConnection).ProductVersion;
    Row[DbMetaDataColumnNames.ParameterMarkerPattern] := '?';
    Row[DbMetaDataColumnNames.ParameterMarkerFormat] := '?';
    Row[DbMetaDataColumnNames.ParameterNameMaxLength] := TObject(0);
    Row[DbMetaDataColumnNames.ParameterNamePattern] := '(^[\\p{Lo}\\p{Lu}\\p{Ll}][\\p{Lo}\\p{Lu}\\p{Ll}\\p{Nd}$_]*$)|(^\"([^\"\\0]|\"\")*\"$)';
//    Row[DbMetaDataColumnNames.IdentifierPattern] := '(^[\\p{Lo}\\p{Lu}\\p{Ll}][\\p{Lo}\\p{Lu}\\p{Ll}\\p{Nd}$_]*$)|(^\"([^\"\\0]|\"\")*\"$)';
//    Row[DbMetaDataColumnNames.OrderByColumnsInSelect] := false;
//    Row[DbMetaDataColumnNames.QuotedIdentifierPattern] := '';
//    Row[DbMetaDataColumnNames.StatementSeparatorPattern] := ';';
//    Row[DbMetaDataColumnNames.StringLiteralPattern] := '';
//    Row[DbMetaDataColumnNames.GroupByBehavior] := GroupByBehavior.MustContainAll;
//    Row[DbMetaDataColumnNames.IdentifierCase] := IdentifierCase.Insensitive;
//    Row[DbMetaDataColumnNames.QuotedIdentifierCase] := IdentifierCase.Sensitive;
//    Row[DbMetaDataColumnNames.SupportedJoinOperators] := SupportedJoinOperators.Inner or SupportedJoinOperators.FullOuter or SupportedJoinOperators.LeftOuter or SupportedJoinOperators.RightOuter;

    Result.Rows.Add(Row);

end;

function TAdoDbxConnection.GetMetaDataCollections: DataTable;
var
  Row:      DataRow;
  Index:    Integer;
  Item:     TAdoDbxSchemaItem;
begin
    Result := DataTable.Create;
    Result.Columns.Add(DbMetaDataColumnNames.CollectionName, typeof(string));
    Result.Columns.Add(DbMetaDataColumnNames.NumberOfRestrictions, typeof(Integer));
    Result.Columns.Add(DbMetaDataColumnNames.NumberOfIdentifierParts, typeof(Integer));

    for Index := 0 to FSchemaItems.Count -1 do
    begin
      Item := FSchemaItems.Objects[Index] as TAdoDbxSchemaItem;
      Row := Result.NewRow;
      Row[DbMetaDataColumnNames.CollectionName] := FschemaItems[Index];
      Row[DbMetaDataColumnNames.NumberOfRestrictions] := TObject(Length(Item.FRestrictions));
      Row[DbMetaDataColumnNames.NumberOfIdentifierParts] := TObject(Item.FNumberOfIdentifierParts);
      Result.Rows.Add(Row);
    end;

end;

function TAdoDbxConnection.GetRestrictions: DataTable;
var
  Row:              DataRow;
  Index:            Integer;
  RestrictionIndex: Integer;
  Item:             TAdoDbxSchemaItem;
begin
    Result := DataTable.Create;
    Result.Columns.Add(DbMetaDataColumnNames.CollectionName, typeof(string));
    Result.Columns.Add(TAdoDbxMetaDataColumnNames.RestrictionName, typeof(string));
    Result.Columns.Add(TAdoDbxMetaDataColumnNames.RestrictionDefault, typeof(string));
    Result.Columns.Add(TAdoDbxMetaDataColumnNames.RestrictionNumber, typeof(Integer));

    for Index := 0 to FSchemaItems.Count -1 do
    begin
      Item := FSchemaItems.Objects[Index] as TAdoDbxSchemaItem;
      for RestrictionIndex := 0 to Length(Item.FRestrictions) - 1 do
      begin
        Row := Result.NewRow;
        Row[DbMetaDataColumnNames.CollectionName]           := FschemaItems[Index];
        Row[TAdoDbxMetaDataColumnNames.RestrictionName]     := Item.FRestrictions[RestrictionIndex];
        Row[TAdoDbxMetaDataColumnNames.RestrictionDefault]  := nil;
        Row[TAdoDbxMetaDataColumnNames.RestrictionNumber]   := TObject(Index);
        Result.Rows.Add(Row);
      end;
    end;
end;

function TAdoDbxConnection.GetSchema(Name: String;
  Restrictions: array of String): DataTable;
var
  DBXCommand:       TDBXCommand;
  AdoDbxDataReader: TAdoDbxDataReader;
  ItemIndex:        Integer;
  DatabaseMetaData: TDBXDatabaseMetaDataEx; 
begin
  if Name = DbMetaDataCollectionNames.DataSourceInformation then
    Result := GetDataSourceInformation
  else if Name = DbMetaDataCollectionNames.MetaDataCollections then
    Result := GetMetaDataCollections
  else if Name = DbMetaDataCollectionNames.Restrictions then
    Result := GetRestrictions
  else
  begin
    ItemIndex := FSchemaItems.IndexOf(Name);
    if ItemIndex > -1 then
    begin
      AdoDbxDataReader := nil;
      DatabaseMetaData :=  FDBXConnection.DatabaseMetaData as TDBXDatabaseMetaDataEx;
      DBXCommand := FDbxConnection.CreateCommand;
      try
        DBXCommand.CommandType := TDBXCommandTypes.DbxMetaData;

        DBXCommand.Text := TAdoDbxSchemaItem(FSchemaItems.Objects[ItemIndex]).CreateCommandText(Restrictions,
          DatabaseMetaData.QuoteChar, DatabaseMetaData.QuotePrefix, DatabaseMetaData.QuoteSuffix);
        AdoDbxDataReader := TAdoDbxDataReader.Create(FDBXContext, DBXCommand, DBXCommand.ExecuteQuery, CommandBehavior.Default, Self);
        Result := DataTable.Create;
        Result.Load(AdoDbxDataReader);
      finally
        DBXCommand.Free;
        AdoDbxDataReader.Free;
      end;
    end else
      Result := inherited GetSchema(Name, Restrictions);
  end;
end;

function TAdoDbxConnection.GetDbxExtension: TAdoDbxExtension;
begin
  if FDbxExtension = nil then
    FDbxExtension := TAdoDbxExtension.Create(self);
  Result := FDbxExtension;
end;

function TAdoDbxConnection.get_ConnectionString: String;
begin
  Result := FConnectionString;
end;

function TAdoDbxConnection.get_ConnectionTimeout: Integer;
begin
  Result := FConnectionTimeout;
end;

function TAdoDbxConnection.get_Database: String;
begin
  if Assigned(FDbxConnection) then
    Result := TDBXConnectionEx(FDbxConnection).ConnectionProperty[TDBXPropertyNames.Database]
  else
    Result := '';
end;

function TAdoDbxConnection.get_DataSource: String;
begin
  if Assigned(FDbxConnection) then
    Result := TDBXConnectionEx(FDbxConnection).ConnectionProperty[TDBXPropertyNames.HostName]
  else
    Result := '';
end;

function TAdoDbxConnection.get_ServerVersion: String;
begin
  if Assigned(FDbxConnection) then
    Result := TDBXConnectionEx(FDbxConnection).ProductVersion
  else
    Result := '';
end;

function TAdoDbxConnection.get_State: ConnectionState;
begin
  if FDbxConnection = nil then
    Result := ConnectionState.Closed
  else
    Result := ConnectionState.Open;
end;

class procedure TAdoDbxConnection.InitSchemaItems;
begin
  FSchemaItems := TStringList.Create;
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.Schemas,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommandsEx.GetSchemas, ['CatalogName'], 1));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.Tables,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommands.GetTables, ['CatalogName', 'SchemaName', 'TableName', 'TableType'], 3));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.Views,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommandsEx.GetViews, ['CatalogName', 'SchemaName', 'ViewName'], 3));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.Columns,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommands.GetColumns, ['CatalogName', 'SchemaName', 'TableName'], 3));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.Indexes,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommands.GetIndexes, ['CatalogName', 'SchemaName', 'TableName'], 3));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.IndexColumns,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommands.GetIndexColumns, ['CatalogName', 'SchemaName', 'TableName', 'IndexName'], 4));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.ForeignKeys,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommands.GetForeignKeys, ['CatalogName', 'SchemaName', 'TableName'], 3));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.ForeignKeyColumns,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommands.GetForeignKeyColumns, ['CatalogName', 'SchemaName', 'TableName', 'ForeignKeyName', 'PrimaryOrForeignKey'], 4));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.Procedures,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommands.GetProcedures, ['CatalogName', 'SchemaName', 'ProcedureName', 'ProcedureType'], 3));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.ProcedureSources,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommandsEx.GetProcedureSources, ['CatalogName', 'SchemaName', 'ProcedureName'], 3));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.ProcedureParameters,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommands.GetProcedureParameters, ['CatalogName', 'SchemaName', 'ProcedureName'], 3));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.Synonyms,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommandsEx.GetSynonyms, ['CatalogName', 'SchemaName', 'SynonymName'], 3));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.Packages,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommands.GetPackages, ['CatalogName', 'SchemaName', 'PackageName'], 3));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.PackageProcedures,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommandsEx.GetPackageProcedures, ['CatalogName', 'SchemaName', 'PackageName', 'ProcedureName', 'ProcedureType'], 4));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.PackageProcedureParameters,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommandsEx.GetPackageProcedureParameters, ['CatalogName', 'SchemaName', 'PackageName', 'ProcedureName'], 4));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.PackageSources,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommandsEx.GetPackageSources, ['CatalogName', 'SchemaName', 'PackageName'], 3));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.Users,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommands.GetUsers, [], 0));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.Roles,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommandsEx.GetRoles, [], 0));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.DataTypes,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommands.GetDataTypes, [], 0));
  FSchemaItems.AddObject(TDBXMetaDataCollectionName.ReservedWords,
    TAdoDbxSchemaItem.Create(TDBXMetaDataCommandsEx.GetReservedWords, [], 0));
end;

threadvar
  CurrentConnectionQuoteChar: string;
  CurrentConnectionQuotePrefix: string;
  CurrentConnectionQuoteSuffix: string;
  HasCurrentConnectionQuoteInfo: Boolean;

procedure TAdoDbxConnection.Open;
var
  ConnectionFactory:  TDBXConnectionFactory;
  DbxProperties:      TDBXProperties;
//  Strings:            TStringList;
  ConnectionName:     String;
  ProductName:        String;
  UseProperties:      Boolean;
  DbMetadata: TDBXDatabaseMetaDataEx;
  AutoDetectProvider: Boolean;
begin
  if FDbxConnection = nil then
  begin
    DbxProperties     := TDBXProperties.Create;
    DbxProperties.SetProperties(FConnectionString);
  //  Strings           := TStringList.Create;
  //  Strings.Delimiter := ';'; { Do not localize.}
  //  Strings.DelimitedText := FConnectionString;
  //  DbxProperties.AddProperties(Strings);
    ConnectionName := DbxProperties[TDBXPropertyNames.ConnectionName];
    ConnectionFactory := FConnectionFactory;
    if ConnectionFactory = nil then
    begin
      try
        ConnectionFactory := TDBXConnectionFactory.GetConnectionFactory;
      except
        ConnectionFactory := TDBXMemoryConnectionFactory.Create;
        ConnectionFactory.Open;
      end;
    end;

    UseProperties := false;
    if ConnectionName = '' then
      UseProperties := true
    else if DbxProperties.Properties.Count > 1 then
    begin
      if DbxProperties.Properties.IndexOfName(TDBXPropertyNames.DriverName) >= 0 then
        UseProperties := true;
    end;
         

    if UseProperties then       
    begin
      FDriverName := DbxProperties[TDBXPropertyNames.DriverName];
      FDbxConnection := ConnectionFactory.GetConnection(DbxProperties);
      AutoDetectProvider := (DbxProperties['AutoDetectProvider'].ToLower() <> 'false'); // do not resource
    end else
    begin
      FDriverName := ConnectionFactory
      .GetConnectionProperties(ConnectionName)[TDBXPropertyNames.DriverName];      

      FDbxConnection := ConnectionFactory
      .GetConnection(ConnectionName, DbxProperties[TDBXPropertyNames.UserName], DbxProperties[TDBXPropertyNames.Password]);
      AutoDetectProvider := ConnectionFactory
      .GetConnectionProperties(ConnectionName)['AutoDetectProvider'].ToLower() <> 'false'; // do not resource
      //  Strings.Free;
      DbxProperties.Free;
    end;
    FDbxConnection.OnErrorEvent := TAdoDbxProviderFactory.Instance.AdoDbxException;

    FBlobDataType := TDBXDataTypes.UnknownType;
    FBlobSubType  := TDBXDataTypes.UnknownType;
    FStringDataType := TDBXDataTypes.AnsiStringType;
    ProductName := TDBXConnectionEx(FDbxConnection).ProductName;
    if (WideCompareText(ProductName, 'BlackfishSQL') = 0) then { do not resource }
    begin
      FBlobDataType := TDBXDataTypes.BlobType;
      FBlobSubType := TDBXDataTypes.BinarySubType;
      FStringDataType := TDBXDataTypes.WideStringType;
    end
    else if (WideCompareText(ProductName, 'Interbase') = 0) then {do not resource}
    begin
      FBlobDataType := TDBXDataTypes.BlobType;
      FBlobSubType := TDBXDataTypes.BinarySubType;
    end
    else if (WideCompareText(ProductName, 'MySql') = 0) then {do not resource}
    begin
      FBlobDataType := TDBXDataTypes.BlobType;
      FBlobSubType := TDBXDataTypes.BinarySubType;
    end;
    DbMetadata := TDBXDatabaseMetaDataEx(FDbxConnection.DatabaseMetaData);
    if AutoDetectProvider then
    begin
      CurrentConnectionQuoteChar := DbMetadata.QuoteChar;
      CurrentConnectionQuotePrefix := DbMetadata.QuotePrefix;
      CurrentConnectionQuoteSuffix := DbMetadata.QuoteSuffix;
      HasCurrentConnectionQuoteInfo := True;
    end
    else
      HasCurrentConnectionQuoteInfo := False;
    OnStateChange(FStateChangeOpen);
  end;
end;

procedure TAdoDbxConnection.set_ConnectionFactory(
  ConnectionFactory: TDBXConnectionFactory);
begin
  FConnectionFactory := ConnectionFactory;
end;

procedure TAdoDbxConnection.set_ConnectionString(ConnectionString: String);
begin
  FConnectionString := ConnectionString;
end;

{ TAdoDbxExtension }

constructor TAdoDbxExtension.Create(Connection: TAdoDbxConnection);
begin
  inherited Create;
  FConnection := Connection;
end;

function TAdoDbxExtension.GetVendorProperty(const Name: WideString): WideString;
begin
  Result := TDbxConnectionEx(FConnection.DbxConnection).GetVendorProperty(Name);
end;

{ TAdoDbxCommand }

procedure TAdoDbxCommand.Cancel;
begin
  TAdoDbxProviderFactory.Unsupported(FDbxContext);
end;

function TAdoDbxCommand.Clone: TObject;
var
  Copy: TAdoDbxCommand;
  Index: Integer;
begin
  Copy := TAdoDbxCommand(MemberwiseClone);
  Copy.FDbxCommand          := nil;
  Copy.FParameterCollection := nil;
  Copy.CommandText          := CommandText;
  Copy.CommandType          := CommandType;
  Copy.InitDbxCommand;
  for Index := 0 to Parameters.Count - 1 do
  begin
    Copy.Parameters.Add(TAdoDbxParameter(Parameters[Index]).Clone);
    Copy.Parameters[Index].Value := Parameters[Index].Value;
  end;
  Result := Copy;
end;

constructor TAdoDbxCommand.Create(DBXContext: TDBXContext; DbConnection: TAdoDbxConnection);
begin
  inherited Create;
  FDbConnection := DbConnection;
  FDesignTimeVisible := true;
end;

constructor TAdoDbxCommand.Create;
begin
  inherited Create;
  FDesignTimeVisible := true;
end;

function TAdoDbxCommand.CreateDbParameter: DbParameter;
begin
  InitDbxCommand;
  // There could be a dbx delegate driver, so let thd dbx command create
  // the parameter.
  //
  Result := TAdoDbxParameter.Create(TDBXParameterEx(FDbxCommand.CreateParameter), FDbConnection);
end;

destructor TAdoDbxCommand.Destroy;
begin
  FreeAndNil(FDbxCommand);
  inherited;
end;

function TAdoDbxCommand.ExecuteDbDataReader(
  Behavior: CommandBehavior): DbDataReader;
var
  Ordinal: Integer;
  DbxValueTypes: TDBXValueTypes;
begin
  InitDbxCommand;
  if FParameterCollection <> nil then
    FParameterCollection.SetPendingValues(FDbConnection, Self);
  FDBXReader := FDbxCommand.ExecuteQuery;
  if FNeedDbxValueTypes then
  begin
    SetLength(DBXValueTypes, FDBXReader.ColumnCount);
    for Ordinal := 0 to FDBXReader.ColumnCount - 1 do
    begin
        DBXValueTypes[Ordinal] := FDBXReader.ValueType[Ordinal];
    end;
    TAdoDbxProviderFactory.AddValueTypes(CommandText+FDbConnection.ConnectionString, DbxValueTypes);
  end;
  Result := TAdoDbxDataReader.Create(FDBXContext, FDbxCommand, FDbXReader, Behavior, FDbConnection);
end;

function TAdoDbxCommand.ExecuteNonQuery: Integer;
begin
  InitDbxCommand;
  FDBXReader := nil;
  if FParameterCollection <> nil then
    FParameterCollection.SetPendingValues(FDbConnection, Self);
  FDbxCommand.ExecuteUpdate;
  Result := Integer(FDbxCommand.RowsAffected);
end;

function TAdoDbxCommand.ExecuteScalar: System.Object;
var
  Reader: DbDataReader;
begin
  Reader := ExecuteDbDataReader(CommandBehavior.SingleResult);
  try
    if Reader.Read then
      Result := Reader.GetValue(0)
    else
      Result := DBNull.Value;
  finally
    Reader.Free;
  end;
end;

procedure TAdoDbxCommand.InitDbxCommand;
var
  DbxCommandType: String;
  Ordinal:        Integer;
  Count:          Integer;
begin
  if FDbxCommand = nil then
    FDbxCommand := FDbConnection.DbxConnection.CreateCommand;
  if FDbxCommand.Text <> FCommandText then
    FDbxCommand.Text := FCommandText;

  DbxCommandType := FDbxCommand.CommandType;
  if FCommandType = System.Data.CommandType.StoredProcedure then
  begin
    if (DbxCommandType <> TDBXCommandTypes.DbxStoredProcedure) then
      FDbxCommand.CommandType := TDBXCommandTypes.DbxStoredProcedure;
  end else
  begin
    if (DbxCommandType <> TDBXCommandTypes.DbxSQL) then
      FDbxCommand.CommandType := TDBXCommandTypes.DbxSQL;
  end;

  if (FParameterCollection <> nil) and (FParameterCollection.Count <> FDbxCommand.Parameters.Count) then
  begin
    // Avoid assert that makes sure the two lists have
    // the same number of members.
    //
    Count := FParameterCollection.FParameters.Count;
    FParameterCollection.FDBXParameters := FDBXCommand.Parameters;
    for Ordinal := 0 to Count - 1 do
    begin
      FDbxCommand.Parameters.AddParameter(TAdoDbxParameter(FParameterCollection[Ordinal]).FDBXParameter);
    end;
  end;
end;

procedure TAdoDbxCommand.SetNeedDbxValueTypes(NeedDbxValueTypes: Boolean);
begin
  FNeedDbxValueTypes := NeedDbxValueTypes;
end;

function TAdoDbxCommand.FindValueType(Name: String): TDBXValueType;
var
  Ordinal:      Integer;
  Count:        Integer;
begin
  Result := nil;
  if FDBXValueTypes <> nil then
  begin
    Count := Length(FDBXValueTypes);
    for Ordinal := 0 to Count -1 do
    begin
      if WideCompareText(FDBXValueTypes[Ordinal].Name, Name) = 0 then
      begin
        Result := FDBXValueTypes[Ordinal];
        exit;
      end;
    end;
  end;
end;

procedure TAdoDbxCommand.SetDbxValueTypes(SqlSelect: String);
begin
  FDBXValueTypes := TAdoDbxProviderFactory.GetValueTypes(SqlSelect+FDbConnection.ConnectionString);
end;

function TAdoDbxCommand.get_CommandText: String;
begin
  Result := FCommandText;
end;

function TAdoDbxCommand.get_CommandTimeout: Integer;
begin
  Result := 0;
  if Assigned(FDbConnection) and Assigned(FDbConnection.DbxConnection) then
  begin
    InitDbxCommand;
    if FDbxCommand is TDBXCommandEx then
      Result := TDBXCommandEx(FDbxCommand).CommandTimeout;
  end;
end;

function TAdoDbxCommand.get_CommandType: CommandType;
begin
  Result := FCommandType;
end;

function TAdoDbxCommand.get_DbConnection: DbConnection;
begin
  Result := FDbConnection;
end;

function TAdoDbxCommand.get_DbParameterCollection: DbParameterCollection;
var
  DbxParameters: TDBXParameterList;
begin
//  InitDbxCommand;
  if FDbxCommand = nil then
    DbxParameters := nil
  else
    DbxParameters := FDbxCommand.Parameters;
  if FParameterCollection = nil then
    FParameterCollection := TAdoDbxParameterCollection.Create(FDBXContext, DBXParameters);
  Result := FParameterCollection;
end;

function TAdoDbxCommand.get_DbTransaction: DbTransaction;
begin
  Result := FDbTransaction;
end;

function TAdoDbxCommand.get_DesignTimeVisible: Boolean;
begin
  Result := FDesignTimeVisible;
end;

function TAdoDbxCommand.get_UpdatedRowSource: UpdateRowSource;
begin
  Result := FUpdatedRowSource;
end;

procedure TAdoDbxCommand.Prepare;
var
  Index: Integer;
  ParametersCollection: TAdoDbxParameterCollection;
begin
  InitDbxCommand;
  FDbxCommand.Prepare;
  if (FParameterCollection = nil) and (FDbxCommand.Parameters.Count > 0) then
  begin
    ParametersCollection := TAdoDbxParameterCollection(Parameters);
    for Index := 0 to FDbxCommand.Parameters.Count - 1 do
    begin
      ParametersCollection.AddExisting(TAdoDbxParameter.Create(TDBXParameterEx(FDbxCommand.Parameters[Index]), FDbConnection));
    end;
  end;
  
end;

procedure TAdoDbxCommand.set_CommandText(CommandText: String);
begin
  FCommandText := CommandText;
  if FDbxCommand <> nil then
    FDbxCommand.Text := CommandText; // Clears FPrepared state if text set to same value.
end;

procedure TAdoDbxCommand.set_CommandTimeout(Timeout: Integer);
begin
  if Assigned(FDbConnection) and Assigned(FDbConnection.DbxConnection) then
  begin
    InitDbxCommand;
    if FDbxCommand is TDBXCommandEx then
      TDBXCommandEx(FDbxCommand).CommandTimeout := CommandTimeout;
  end;
end;

procedure TAdoDbxCommand.set_CommandType(CommandType: CommandType);
begin
  FCommandType := CommandType;
end;

procedure TAdoDbxCommand.set_DbConnection(Connection: DbConnection);
begin
  if (FdbConnection <> Connection) then
    FreeAndNil(FDbxCommand);
  FdbConnection := TAdoDbxConnection(Connection);
  FDBXContext   := FDbConnection.FDBXContext;
end;

procedure TAdoDbxCommand.set_DbTransaction(Transaction: DbTransaction);
begin
  FDbTransaction := Transaction;
end;

procedure TAdoDbxCommand.set_DesignTimeVisible(DesignTimeVisible: Boolean);
begin
  FDesignTimeVisible := DesignTimeVisible;
end;


procedure TAdoDbxCommand.set_UpdatedRowSource(
  UpdatedRowSource: UpdateRowSource);
begin
  FUpdatedRowSource := UpdatedRowSource;
end;

{ TAdoDbxParameter }

constructor TAdoDbxParameter.Create(DbxContext: TDBXContext);
begin
  inherited Create;
  FDBXParameter := TDBXParameterEx(TDBXDriverHelp.CreateTDBXParameter(DbxContext));
  SourceVersion := DataRowVersion.Original;
end;


function TAdoDbxParameter.Clone: TObject;
var
  Copy: TAdoDbxParameter;
begin
  Copy := TAdoDbxParameter(MemberwiseClone);
  if FDBXParameter <> nil then
  begin
//    Copy.FDBXParameter := TDBXParameterEx(TDBXDriverHelp.CreateTDBXParameter(FDbxContext));
    Copy.FDBXParameter := TDBXParameterEx(TDBXParameterEx(FDBXParameter).Clone);
  end;
  Result := Copy;
end;

constructor TAdoDbxParameter.Create(DbxParameter: TDBXParameterEx; Connection: TAdoDbxConnection);
begin
  inherited Create;
  FDBXParameter := DbxParameter;
  FConnection :=   Connection;
  SourceVersion := DataRowVersion.Original;
end;

destructor TAdoDbxParameter.Destroy;
begin
  inherited;
end;

function TAdoDbxParameter.get_DbType: DbType;
begin
  Result := TAdoDbxProviderFactory.DbxToAdoType(FDBXParameter.DataType);
end;

function TAdoDbxParameter.get_DbxSubType: Integer;
begin
  Result := FDBXParameter.SubType;
end;

function TAdoDbxParameter.get_DbxDataType: Integer;
begin
  Result := FDBXParameter.DataType;
end;

function TAdoDbxParameter.get_Direction: ParameterDirection;
begin
  Result := TAdoDbxProviderFactory.DbxToAdoParameterDirection(FDbxParameter.ParameterDirection);
end;

function TAdoDbxParameter.get_IsNullable: Boolean;
begin
  Result := FDbxParameter.Nullable;
end;

function TAdoDbxParameter.get_ParameterName: String;
begin
  Result := FDbxParameter.Name;
end;

function TAdoDbxParameter.get_Precision: Byte;
begin
  Result := Byte(FDBXParameter.Precision);
end;

function TAdoDbxParameter.get_Scale: Byte;
begin
  Result := FDbxParameter.Scale;
end;

function TAdoDbxParameter.get_Size: Integer;
begin
  Result := Integer(FDBXParameter.Size);
end;

function TAdoDbxParameter.get_SourceColumn: String;
begin
  Result := FSourceColumn;
end;

function TAdoDbxParameter.get_SourceColumnNullMapping: Boolean;
begin
  Result := FSourceColumnNullMapping;
end;

function TAdoDbxParameter.get_SourceVersion: DataRowVersion;
begin
  Result := FSourceVersion;
end;

function TAdoDbxParameter.get_Value: TObject;
begin
  if FPendingValue <> nil then
    Result := FPendingValue
  else
    Result := TAdoDbxProviderFactory.GetRowValue(FDbxParameter.Value);
end;

procedure TAdoDbxParameter.OnError(DBXError: TDBXError);
begin
  if FDbxContext <> nil then
    FDbxContext.OnError(DBXError)
  else
    raise DBXError;
end;

procedure TAdoDbxParameter.ResetDbType;
begin

end;

procedure TAdoDbxParameter.set_DbType(DbType: DbType);
var
  DbxDataType: Integer;
  DbxSubType: Integer;
begin
  if not FDbxTypeOverridden then
  begin
    TAdoDBXProviderFactory.AdoToDbxType(FConnection, DbType, DbxDataType, DbxSubType);
    FDBXParameter.DataType  := DbxDataType;
    FDBXParameter.SubType   := DbxSubType;
  end;
end;

procedure TAdoDbxParameter.set_DbxSubType(DbxSubType: Integer);
begin
  FDbxTypeOverridden := true;
  FDBXParameter.SubType := DbxSubType;
end;

procedure TAdoDbxParameter.set_DbxDataType(DbxDataType: Integer);
begin
  FDbxTypeOverridden := true;
  FDBXParameter.DataType := DbxDataType;
end;

procedure TAdoDbxParameter.set_Direction(Direction: ParameterDirection);
begin
  FDBXParameter.ParameterDirection := TAdoDBXProviderFactory.AdoToDbxParameterDirection(Direction);
end;

procedure TAdoDbxParameter.set_IsNullable(IsNullable: Boolean);
begin
  FDBXParameter.Nullable := IsNullable;
end;

procedure TAdoDbxParameter.set_ParameterName(ParameterName: String);
begin
  FName := ParameterName;
  FDBXParameter.Name := ParameterName;
end;

procedure TAdoDbxParameter.set_Precision(Precision: Byte);
begin
  FDBXParameter.Precision := Precision;
end;

procedure TAdoDbxParameter.set_Scale(Scale: Byte);
begin
  FDBXParameter.Scale := Scale;
end;

procedure TAdoDbxParameter.set_Size(Size: Integer);
begin
  FDBXParameter.Size := Size;
end;

procedure TAdoDbxParameter.set_SourceColumn(SourceColumn: String);
begin
  FSourceColumn := SourceColumn;
end;

procedure TAdoDbxParameter.set_SourceColumnNullMapping(
  SourceColumnNullMapping: Boolean);
begin
  FSourceColumnNullMapping  := SourceColumnNullMapping;
end;

procedure TAdoDbxParameter.set_SourceVersion(SourceVersion: DataRowVersion);
begin
  FSourceVersion := SourceVersion;
end;

procedure TAdoDbxParameter.set_Value(Value: TObject);
begin
  if Value = nil then
    FPendingValue := DbNull.Value
  else
    FPendingValue := Value;
end;

procedure TAdoDbxParameter.SetPendingValue(Connection: TAdoDbxConnection);
var
  Value: TObject;
begin
  Value := FPendingValue;
  if Value <> nil then
  begin

    if (Value = DbNull.Value) and (FDBXParameter.DataType <> TDBXDataTypes.UnknownType) then
      FDBXParameter.Value.SetNull
    else
      case FDBXParameter.DataType of
        TDBXDataTypes.WideStringType:   FDBXParameter.Value.SetWideString(Value.ToString);
        TDBXDataTypes.AnsiStringType:   FDBXParameter.Value.SetAnsiString(Value.ToString);
        TDBXDataTypes.VarBytesType,
        TDBXDataTypes.BlobType:
        begin
          if Value is TBytes then
            FDBXParameter.Value.SetDynamicBytes(0, TBytes(Value), 0, Length(TBytes(Value)))
          else if FDBXParameter.SubType = TDBXDataTypes.MemoSubType then
            FDBXParameter.Value.SetAnsiString(String(Value))
          else if FDBXParameter.SubType = TDBXDataTypes.WideMemoSubType then
            FDBXParameter.Value.SetWideString(String(Value))
          else
            OnError(
            TDBXError.Create(TDBXErrorCodes.InvalidType, WideFormat(SInvalidFieldType, [Value.GetType.ToString])));


        end;
        TDBXDataTypes.BooleanType:      FDBXParameter.Value.SetBoolean(Convert.ToBoolean(Value));
    //    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Byte;
    //    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Currency;
        TDBXDataTypes.DateType:         FDBXParameter.Value.SetDate(DateTimeToTimeStamp(TDateTime.FromObject(Value)).Date);
        TDBXDataTypes.TimeStampType:    FDBXParameter.Value.SetTimestamp(TSQLTimeStamp.FromObject(Convert.ToDateTime(Value)));

        // Parses this correct '-12345678901234.5678'.
  // Truncates the last two digits of this:  '12345678901234.567',
  //      TDBXDataTypes.BcdType:          FDBXParameter.Value.SetBCD(TBcd.Create(Value.ToString, FDBXParameter.Precision, FDBXParameter.Scale));

        TDBXDataTypes.BcdType:          FDBXParameter.Value.SetBCD(StrToBcd(Value.ToString));
        TDBXDataTypes.DoubleType:        FDBXParameter.Value.SetDouble(Convert.ToDouble(Value));
    //    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.Guid;
        TDBXDataTypes.Int16Type:
          begin
            if Value is Byte then
              FDBXParameter.Value.SetInt16(Convert.ToByte(Value))
            else
              FDBXParameter.Value.SetInt16(Convert.ToInt16(Value));
          end;
        TDBXDataTypes.Int32Type:        FDBXParameter.Value.SetInt32(Convert.ToInt32(Value));
        TDBXDataTypes.Int64Type:        FDBXParameter.Value.SetInt64(Convert.ToInt64(Value));
    //    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.SByte;
    //    TDBXDataTypes.FloatType:            Result := System.Data.DbType.Single;
        TDBXDataTypes.TimeType:          FDBXParameter.Value.SetTime(DateTimeToTimeStamp(TDateTime.FromObject(Value)).Time);
        TDBXDataTypes.UInt16Type:        FDBXParameter.Value.SetInt16(Convert.ToUInt16(Value));
        TDBXDataTypes.UInt32Type:        FDBXParameter.Value.SetInt32(Convert.ToUInt32(Value));
        TDBXDataTypes.UInt64Type:        FDBXParameter.Value.SetInt64(Convert.ToUInt64(Value));
    //    TDBXDataTypes.UnknownType:          Result := System.Data.DbType.VarNumeric;
    //    TDBXDataTypes.AnsiStringType:          Result := System.Data.DbType.AnsiStringFixedLength;
    //    TDBXDataTypes.WideStringType:       Result := System.Data.DbType.StringFixedLength;
        TDBXDataTypes.UnknownType:
        begin
          SetPendingValueAndType(Connection);
        end
        else
          FDbxContext.OnError(TDBXError.Create(TDBXErrorCodes.UnsupportedFieldType, Format(SInvalidFieldType, [Value.GetType.Name])));
      end;
    end;
  FPendingValue := nil;
end;

procedure TAdoDbxParameter.SetPendingValueAndType(Connection: TAdoDbxConnection);
var
  ValueDbxType:    TDBXType;
  ValueDbxSubType: TDBXType;
begin
  TAdoDbxProviderFactory.SystemToDbxType(Connection, FPendingValue.GetType, ValueDbxType, ValueDbxSubType);
  if ValueDbxType <> TDBXDataTypes.UnknownType then
  begin
    DbxDataType     := ValueDbxType;
    DbxSubType  := ValueDbxSubType;
    SetPendingValue(Connection);
  end;
end;

{ TAdoDbxParameterCollection }

function TAdoDbxParameterCollection.Add(Value: TObject): Integer;
var
  Parameter: TAdoDbxParameter;
begin
  Parameter := TAdoDbxParameter(Value);
  if Assigned(FDBXParameters) then
    FDBXParameters.AddParameter(Parameter.FDBXParameter);
  Result := FParameters.Add(Parameter);
end;

function TAdoDbxParameterCollection.AddExisting(
  Parameter: TAdoDbxParameter): Integer;
begin
  Result := FParameters.Add(Parameter);
end;

procedure TAdoDbxParameterCollection.AddRange(Values: System.Array);
var
  Index: Integer;
begin
  for Index := 0 to Values.Length - 1 do
    Add(Values[Index]);
end;

procedure TAdoDbxParameterCollection.Clear;
begin
  inherited;
  FParameters.Clear;
  if Assigned(FDBXParameters) then
    FDBXParameters.ClearParameters;
end;

function TAdoDbxParameterCollection.Contains(Value: string): Boolean;
begin
  Result := IndexOf(Value) > -1;
end;

function TAdoDbxParameterCollection.Contains(Value: TObject): Boolean;
begin
  Result := FParameters.Contains(Value);
end;

procedure TAdoDbxParameterCollection.CopyTo(Values: System.Array;
  Index: Integer);
begin
  FParameters.CopyTo(Values, Index);
end;

constructor TAdoDbxParameterCollection.Create(DBXContext: TDBXContext; DbxParameters: TDBXParameterList);
begin
  inherited Create;
  FDBXContext     := DBXContext;
  FDBXParameters  := DbxParameters;
  FParameters     := ArrayList.Create;
end;

destructor TAdoDbxParameterCollection.Destroy;
begin
  inherited;
end;

function TAdoDbxParameterCollection.GetEnumerator: IEnumerator;
begin
  Result := FParameters.GetEnumerator;
end;

function TAdoDbxParameterCollection.GetParameter(Name: String): DbParameter;
var
  Ordinal: Integer;
begin
  Ordinal := IndexOf(Name);
  if Ordinal < 0 then
    Result := nil
  else
    Result := DbParameter(FParameters[Ordinal]);
end;

function TAdoDbxParameterCollection.GetParameter(Ordinal: Integer): DbParameter;
begin
  Result := DbParameter(FParameters[Ordinal]);
end;

function TAdoDbxParameterCollection.get_Count: Integer;
begin
  Assert( (FDBXParameters = nil)
          or (FDBXParameters.Count = 0)
          or (FDBXParameters.Count = FParameters.Count));
  Result := FParameters.Count;
end;

function TAdoDbxParameterCollection.get_IsFixedSize: Boolean;
begin
  Result := FParameters.IsFixedSize;
end;

function TAdoDbxParameterCollection.get_IsReadOnly: Boolean;
begin
  Result := FParameters.IsReadOnly;
end;

function TAdoDbxParameterCollection.get_IsSynchronized: Boolean;
begin
  Result := FParameters.IsSynchronized;
end;

function TAdoDbxParameterCollection.get_SyncRoot: TObject;
begin
  Result := FParameters.SyncRoot;
end;

procedure TAdoDbxParameterCollection.SetPendingValues(Connection: TAdoDbxConnection; Command: TAdoDbxCommand);
var
  Ordinal:        Integer;
  Count:          Integer;
  Parameter:      TAdoDbxParameter;
  ValueTypes:     TDBXValueTypes;
  ValueType:      TDBXValueType;
  HasValueTypes:  Boolean;
begin
  Count := FParameters.Count;
  ValueTypes := Command.FDBXValueTypes;

  if (ValueTypes = nil) or (Length(ValueTypes) = 0) then
    HasValueTypes := false
  else
    HasValueTypes := true;

  for Ordinal := 0 to Count - 1 do
  begin
    Parameter := TAdoDbxParameter(FParameters[Ordinal]);
    if HasValueTypes then
    begin
      ValueType := Command.FindValueType(Parameter.FName);
      if ValueType <> nil then
      begin
        Parameter.DbxDataType := ValueType.DataType;
        Parameter.DbxSubType  := ValueType.SubType;
        Parameter.Precision   := ValueType.Precision;
        Parameter.Scale       := ValueType.Scale;
        Parameter.Size        := ValueType.Size;
      end;
    end;
    if Parameter.FPendingValue <> nil then
      Parameter.SetPendingValue(Connection);
  end;
end;

function TAdoDbxParameterCollection.IndexOf(Name: String): Integer;
var
  Ordinal:      Integer;
  Count:        Integer;
  CurrentName:  WideString;
begin
  Count := FParameters.Count;
  for Ordinal := 0 to Count - 1 do
  begin
    CurrentName := TAdoDbxParameter(FParameters[Ordinal]).FName;
    if WideCompareText(CurrentName, Name) = 0 then
    begin
      Result := Ordinal;
      exit;
    end;
  end;
  Result := -1;
end;

function TAdoDbxParameterCollection.IndexOf(Parameter: TObject): Integer;
begin
  Result := FParameters.IndexOf(Parameter);
end;

procedure TAdoDbxParameterCollection.Insert(Ordinal: Integer;
  Parameter: TObject);
var
  AdoDbxParameter:  TAdoDbxParameter;
begin
  AdoDbxParameter := TAdoDbxParameter(Parameter);
  if Assigned(FDBXParameters) then
    FDBXParameters.InsertParameter(Ordinal, AdoDbxParameter.FDBXParameter);
  FParameters.Insert(Ordinal, Parameter);
end;

procedure TAdoDbxParameterCollection.Remove(Parameter: TObject);
var
  AdoDbxParameter:  TAdoDbxParameter;
begin
  AdoDbxParameter := TAdoDbxParameter(Parameter);
  if Assigned(FDBXParameters) then
    FDBXParameters.RemoveParameter(AdoDbxParameter.FDBXParameter);
  FParameters.Remove(Parameter);
end;

procedure TAdoDbxParameterCollection.RemoveAt(Name: String);
begin
  RemoveAt(IndexOf(Name));
end;

procedure TAdoDbxParameterCollection.RemoveAt(Ordinal: Integer);
begin
    Remove(FParameters[Ordinal]);
end;

procedure TAdoDbxParameterCollection.SetParameter(Name: String;
  Parameter: DbParameter);
begin
  SetParameter(IndexOf(Name), Parameter);
end;

procedure TAdoDbxParameterCollection.SetParameter(Ordinal: Integer;
  Parameter: DbParameter);
var
  AdoDbxParameter: TAdoDbxParameter;
begin
  AdoDbxParameter := TAdoDbxParameter(FParameters[Ordinal]);
  FParameters[Ordinal] := AdoDbxParameter;
  if Assigned(FDBXParameters) then
    FDBXParameters.SetParameter(Ordinal, AdoDbxParameter.FDBXParameter);
end;

{ TAdoDbxTransaction }

procedure TAdoDbxTransaction.Commit;
begin
  // This will set FTransaction to nil.
  FTransaction.Connection.CommitFreeAndNil(FTransaction);
end;

constructor TAdoDbxTransaction.Create(DbxTransaction: TDBXTransaction; Connection: TAdoDbxConnection; Isolation: IsolationLevel);
begin
  inherited Create;
  FTransaction := DbxTransaction;
  FConnection  := Connection;
  FIsolation   := Isolation;
end;

destructor TAdoDbxTransaction.Destroy;
begin
  inherited;
end;

function TAdoDbxTransaction.get_DbConnection: DbConnection;
begin
  Result := FConnection;
end;

function TAdoDbxTransaction.get_IsolationLevel: IsolationLevel;
begin
  Result := FIsolation;
end;

procedure TAdoDbxTransaction.Rollback;
begin
  inherited;
  // This will set FTransaction to nil.
  FTransaction.Connection.RollbackFreeAndNil(FTransaction);
end;

{ TAdoDbxDataReader }

procedure TAdoDbxDataReader.Close;
begin
  FPeekAheadRead := false;
  FreeAndNil(FDbxReader);
end;

constructor TAdoDbxDataReader.Create(DBXContext: TDBXContext; DbxCommand: TDBXCommand; DbxReader: TDBXReader; Behavior: CommandBehavior; DbConnection: TAdoDbxConnection);
begin
  inherited Create;
  FDBXContext       := DBXContext;
  FCommandBehavior  := Behavior;
  FDbxCommand       := DbxCommand;
  FDbxReader        := DbxReader;
  FDbConnection     := DbConnection;
end;

destructor TAdoDbxDataReader.Destroy;
begin
  inherited
end;

//procedure TAdoDbxDataReader.Dispose;
//begin
//
//  inherited;
//end;

function TAdoDbxDataReader.GetBoolean(Ordinal: Integer): Boolean;
begin
  Result := FDbxReader[Ordinal].GetBoolean;
end;

function TAdoDbxDataReader.GetByte(Ordinal: Integer): Byte;
begin
  Result := Byte(0);
  FDbxReader.OnErrorEvent(TDBXError.Create(TDBXErrorCodes.UnsupportedFieldType, Format(SInvalidFieldType, [TObject(Result).GetType.Name])));
end;

function TAdoDbxDataReader.GetBytes(Ordinal: Integer; dataOffset: Int64;
  Bytes: TBytes; BufferOffset, Length: Integer): Int64;
begin
  Result := FDbxReader[Ordinal].GetBytes(dataOffset, Bytes, BufferOffset, Length);
end;

function TAdoDbxDataReader.GetChar(Ordinal: Integer): Char;
begin
  Result := #0;
  FDbxReader.OnErrorEvent(TDBXError.Create(TDBXErrorCodes.UnsupportedFieldType, Format(SInvalidFieldType, [TObject(Result).GetType.Name])));
end;

function TAdoDbxDataReader.GetChars(Ordinal: Integer; dataOffset: Int64;
  Bytes: array of char; BufferOffset, Length: Integer): Int64;
begin
  Result := 0;
  FDbxReader.OnErrorEvent(TDBXError.Create(TDBXErrorCodes.UnsupportedFieldType, Format(SInvalidFieldType, [TObject(Result).GetType.Name])));
end;

function TAdoDbxDataReader.GetData(Index: Integer): IDataReader;
begin
  TAdoDbxProviderFactory.Unsupported(FDBXContext);
end;

function TAdoDbxDataReader.GetDataTypeName(Ordinal: Integer): String;
begin
  Result := TDBXValueTypeEx.DataTypeName(FDbxReader.ValueType[Ordinal].DataType);
end;

function TAdoDbxDataReader.GetDateTime(Ordinal: Integer): DateTime;
begin
  case FDbxReader.ValueType[Ordinal].DataType of
    TDBXDataTypes.TimeType:             Result := TAdoDbxProviderFactory.TimeToDateTime(FDbxReader[Ordinal].GetTime);
    TDBXDataTypes.DateType:             Result := TAdoDbxProviderFactory.DateToDateTime(FDbxReader[Ordinal].GetDate);
    TDBXDataTypes.TimeStampType:        Result := FDbxReader[Ordinal].GetTimestamp.ToDateTime(nil);//IFormatProvider(nil));
    else
      TAdoDbxProviderFactory.Unsupported(FDbxContext);
  end;
end;

function TAdoDbxDataReader.GetDecimal(Ordinal: Integer): Decimal;
begin
  Result := FDBXReader[Ordinal].GetBCD.ToDecimal(nil);//IFormatProvider(nil));
end;

function TAdoDbxDataReader.GetDouble(Ordinal: Integer): double;
begin
  Result := FDBXReader[Ordinal].GetDouble;
end;

function TAdoDbxDataReader.GetEnumerator: IEnumerator;
begin
  Result := DbEnumerator.Create(Self, FCommandBehavior = CommandBehavior.CloseConnection);
end;

function TAdoDbxDataReader.GetFieldType(Ordinal: Integer): System.Type;
var
  ValueType: TDBXValueType;
begin
  ValueType := FDbxReader.ValueType[Ordinal];
  Result := TAdoDbxProviderFactory.DbxToSystemType(ValueType.DataType,
    ValueType.SubType);
end;

function TAdoDbxDataReader.GetFloat(Ordinal: Integer): single;
begin
  Result := 0;
  FDbxReader.OnErrorEvent(TDBXError.Create(TDBXErrorCodes.UnsupportedFieldType, Format(SInvalidFieldType, [TObject(Result).GetType.Name])));
end;

function TAdoDbxDataReader.GetGuid(Ordinal: Integer): Guid;
begin
  FDbxReader.OnErrorEvent(TDBXError.Create(TDBXErrorCodes.UnsupportedFieldType, Format(SInvalidFieldType, [TObject(Result).GetType.Name])));
  Result := Guid.Empty;
end;

function TAdoDbxDataReader.GetInt16(Ordinal: Integer): Smallint;
begin
  Result := FDbxReader[Ordinal].GetInt16;
end;

function TAdoDbxDataReader.GetInt32(Ordinal: Integer): Integer;
begin
  Result := FDbxReader[Ordinal].GetInt32;
end;

function TAdoDbxDataReader.GetInt64(Ordinal: Integer): Int64;
begin
  Result := FDBXReader[Ordinal].GetInt64;
end;

function TAdoDbxDataReader.GetName(Ordinal: Integer): String;
begin
  Result := FDbxReader.ValueType[Ordinal].Name;
end;

function TAdoDbxDataReader.GetOrdinal(Name: String): Integer;
begin
  Result := FDbxReader.GetOrdinal(Name);
end;

const
  SelectId = 1;
  FromId = 2;

type
  TTableInfo = record
    SchemaName: string;
    TableName: string;
  end;

function ParseTableNameFromSql(const QuoteChar, QuotePrefix, QuoteSuffix, Sql: string): TTableInfo;
var
  SqlScanner: TDBXSqlScanner;
  Token: Integer;
  Id: WideString;

  function TokenMatchesOrEos(Token, Match: Integer): Boolean;
  begin
    Result := (Token = Match) or (Token = TDBXSqlScanner.TokenEos);
  end;

begin
  SqlScanner := TDBXSqlScanner.Create(QuoteChar, QuotePrefix, QuoteSuffix);
  SqlScanner.RegisterId('select', SelectId);
  SqlScanner.RegisterId('from', FromId);
  Result.SchemaName := '';
  Result.TableName := '';
  SqlScanner.Init(Sql);

  Token := SqlScanner.NextToken;
  while Token <> SqlScanner.TokenEos do
  begin
    case Token of
      SelectId:
      begin
        Token := SqlScanner.NextToken;
        while not TokenMatchesOrEos(Token,  FromId) do
        begin
          case Token of
            SqlScanner.TokenOpenParen:
            begin
              repeat
                 Token := SqlScanner.NextToken;
              until TokenMatchesOrEos(Token, SqlScanner.TokenCloseParen);
            end;
          else
            Token := SqlScanner.NextToken;
          end;
        end;
      end;
      FromId:
      begin
        repeat
          Token := SqlScanner.NextToken;
        until TokenMatchesOrEos(Token, SqlScanner.TokenId);
        Id := SqlScanner.Id;
        Token := SqlScanner.NextToken;
        if Token = SqlScanner.TokenPeriod then
        begin
          Result.SchemaName := Id;
          SqlScanner.NextToken;
          Result.TableName := SqlScanner.Id;
        end
        else
          Result.TableName := Id;
        break;
      end
      else
        Token := SqlScanner.NextToken;
    end;
  end;
end;

function TAdoDbxDataReader.GetSchemaTable: DataTable;
var
  DatabaseMetaData: TDBXDatabaseMetaDataEx;
  SchemaRow:    DataRow;
  ColumnCount:  Integer;
  Ordinal:      Integer;
  ValueType:    TDBXValueType;
  TableInfo: TTableInfo;
  Indexes: DataTable;
  Index: DataRow;
  IndexColumns: DataTable;
  IndexColumn: DataRow;
begin
  Result := DataTable.Create;
  Result.Columns.Add(SchemaTableColumn.ColumnName, typeof(String));
  Result.Columns.Add(SchemaTableColumn.ColumnOrdinal, typeof(Integer));
  Result.Columns.Add(SchemaTableColumn.ColumnSize, typeof(Integer));
  Result.Columns.Add(SchemaTableColumn.NumericPrecision, typeof(Integer));
  Result.Columns.Add(SchemaTableColumn.NumericScale, typeof(Integer));
  Result.Columns.Add(SchemaTableColumn.IsUnique, typeof(Boolean));
  Result.Columns.Add(SchemaTableColumn.IsKey, typeof(Boolean));
  Result.Columns.Add(SchemaTableColumn.BaseSchemaName, typeof(String));
  Result.Columns.Add(SchemaTableColumn.BaseTableName, typeof(String));
  Result.Columns.Add(SchemaTableColumn.BaseColumnName, typeof(String));
  Result.Columns.Add(SchemaTableColumn.DataType, typeof(System.Type));
  Result.Columns.Add(SchemaTableColumn.AllowDBNull, typeof(Boolean));
  Result.Columns.Add(SchemaTableColumn.ProviderType, typeof(String));
  Result.Columns.Add(SchemaTableColumn.IsAliased, typeof(Boolean));
  Result.Columns.Add(SchemaTableColumn.IsLong, typeof(Boolean));
  Result.Columns.Add(SchemaTableOptionalColumn.IsAutoIncrement, typeof(Boolean));
  Result.Columns.Add(SchemaTableOptionalColumn.IsRowVersion, typeof(Boolean));
  Result.Columns.Add(SchemaTableOptionalColumn.IsHidden, typeof(Boolean));
  Result.Columns.Add(SchemaTableOptionalColumn.IsReadOnly, typeof(Boolean));
  Result.Columns.Add(TAdoDbxSchemaTableColumnNames.DbxDataType, typeof(Integer));
  Result.Columns.Add(TAdoDbxSchemaTableColumnNames.DbxSubType, typeof(Integer));
  Result.Columns.Add(TAdoDbxSchemaTableColumnNames.DbxPrecision, typeof(Integer));
  ColumnCount := FDbxReader.ColumnCount;

  DatabaseMetaData :=  FDbConnection.FDBXConnection.DatabaseMetaData as TDBXDatabaseMetaDataEx;
  TableInfo := ParseTableNameFromSql(DatabaseMetaData.QuoteChar,
    DatabaseMetaData.QuotePrefix, DatabaseMetaData.QuoteSuffix,
    FDbxCommand.Text);
  IndexColumns := nil;
  if TableInfo.TableName <> nil then
  begin
    Indexes := FDbConnection.GetClonedConnectionIfNeeded
      .GetSchema(TDBXMetaDataCollectionName.Indexes,
      [nil, TableInfo.SchemaName, TableInfo.TableName]);
      
    for Index in Indexes.Rows do
    begin
      if Boolean(Index['IsPrimary']) then
      begin
        IndexColumns := FDbConnection.GetClonedConnectionIfNeeded
          .GetSchema(TDBXMetaDataCollectionName.IndexColumns,
          [nil, TableInfo.SchemaName, TableInfo.TableName, Index['IndexName'].ToString]);
        break;
      end;
    end;
  end;

  for Ordinal := 0 to ColumnCount - 1 do
  begin
    SchemaRow := Result.NewRow;
    ValueType := FDbxReader.ValueType[Ordinal];

    SchemaRow[SchemaTableColumn.ColumnName] := ValueType.Name;
    SchemaRow[SchemaTableColumn.ColumnOrdinal] := TObject(Ordinal);
    // IB returns 1 for blob size.  Some others return 0.
    //
    if (ValueType.DataType = TDBXDataTypes.BlobType) and (ValueType.Size < 2) then
      SchemaRow[SchemaTableColumn.ColumnSize] := TObject(Integer(Int32.MaxValue))
    else
      SchemaRow[SchemaTableColumn.ColumnSize] := TObject(Integer(ValueType.Size));
    SchemaRow[TAdoDbxSchemaTableColumnNames.DbxPrecision] := TObject(ValueType.Precision);

      //    SchemaRow[SchemaTableColumn.ColumnSize] := TObject(Integer(ValueType.Precision));

    //      SchemaRow[SchemaTableColumn.NumericPrecision] := metadata.getPrecision(Ordinal);
    SchemaRow[SchemaTableColumn.NumericScale] := TObject(ValueType.Scale);
    SchemaRow[SchemaTableColumn.IsUnique] := TObject(ValueType.AutoIncrement);
    SchemaRow[SchemaTableColumn.BaseSchemaName] := TableInfo.SchemaName;
    SchemaRow[SchemaTableColumn.BaseTableName] := TableInfo.TableName;
    SchemaRow[SchemaTableColumn.BaseColumnName] := ValueType.Name;
    SchemaRow[SchemaTableColumn.DataType] := TAdoDbxProviderFactory.DbxToSystemType(ValueType.DataType, ValueType.SubType);
    SchemaRow[SchemaTableColumn.AllowDBNull] := TObject(ValueType.Nullable);
//        SchemaRow[SchemaTableColumn.IsAliased] := isDifferent(FDbxReader.;
    SchemaRow[SchemaTableColumn.IsLong] := TObject(ValueType.Searchable <> true);
    SchemaRow[SchemaTableOptionalColumn.IsAutoIncrement] := TObject(ValueType.AutoIncrement);
    SchemaRow[SchemaTableOptionalColumn.IsRowVersion] := TObject(false);
    SchemaRow[SchemaTableOptionalColumn.IsHidden] := TObject(false);
    SchemaRow[SchemaTableOptionalColumn.IsReadOnly] := TObject(ValueType.ReadOnly or ValueType.AutoIncrement);
    SchemaRow[TAdoDbxSchemaTableColumnNames.DbxDataType] := TObject(ValueType.DataType);
    SchemaRow[TAdoDbxSchemaTableColumnNames.DbxSubType] := TObject(ValueType.SubType);
    if Assigned(IndexColumns) then
    begin
      for IndexColumn in IndexColumns.Rows do
      begin
        if ValueType.Name = IndexColumn['ColumnName'].ToString then
        begin
          SchemaRow[SchemaTableColumn.IsKey] := TObject(True);
          Break;
        end;
      end;
    end;

    Result.Rows.Add(SchemaRow);
  end;
end;

function TAdoDbxDataReader.GetString(Ordinal: Integer): String;
begin
  case FDBXReader.ValueType[Ordinal].DataType of
    TDBXDataTypes.AnsiStringType:
      Result := FDBXReader[Ordinal].GetAnsiString;
    TDBXDataTypes.WideStringType:
      Result := FDBXReader[Ordinal].GetWideString;
    TDBXDataTypes.BlobType:
      if FDBXReader.ValueType[Ordinal].SubType = TDBXDataTypes.WideMemoSubType then
        Result := FDBXReader[Ordinal].GetWideString
      else
        Result := FDBXReader[Ordinal].GetAnsiString;
  end;
end;

function TAdoDbxDataReader.GetValue(Ordinal: Integer): TObject;
begin
  Result := TAdoDbxProviderFactory.GetRowValue(FDbxReader[Ordinal]);
end;

function TAdoDbxDataReader.GetValues(Values: TObjectArray): Integer;
var
  Max: Integer;
  Ordinal: Integer;
begin
  Max := FDbxReader.ColumnCount;
  if Max > Length(Values) then
    Max := Length(Values);
  for Ordinal := 0 to Max - 1 do
  begin
    Values[Ordinal] := TAdoDbxProviderFactory.GetRowValue(FDbxReader[Ordinal]);
  end;
  Result := Max;
end;

function TAdoDbxDataReader.get_Depth: Integer;
begin
  Result := 0;
end;

function TAdoDbxDataReader.get_FieldCount: Integer;
begin
  Result := FDbxReader.ColumnCount;
end;

function TAdoDbxDataReader.get_HasRows: Boolean;
begin
  if FPeekAheadRead or Read then
    FPeekAheadRead := true;
  Result := FPeekAheadRead;
end;

function TAdoDbxDataReader.get_IsClosed: Boolean;
begin
  Result := (FDbxReader = nil);
end;

function TAdoDbxDataReader.get_Item(Ordinal: Integer): TObject;
begin
  Result := TAdoDbxProviderFactory.GetRowValue(FDbxReader[Ordinal]);
end;

function TAdoDbxDataReader.get_Item(Name: String): TObject;
begin
  Result := TAdoDbxProviderFactory.GetRowValue(FDbxReader[Name]);
end;

function TAdoDbxDataReader.get_RecordsAffected: Integer;
begin
  Result := FDbxCommand.RowsAffected;
end;

function TAdoDbxDataReader.IsDBNull(Ordinal: Integer): Boolean;
begin
  Result := FDbxReader[Ordinal].IsNull;
end;

function TAdoDbxDataReader.NextResult: Boolean;
begin
  Close;
  FDbxReader := FDbxCommand.GetNextReader;
  Result := (FDbxReader <> nil);
end;

function TAdoDbxDataReader.Read: Boolean;
begin
  if FPeekAheadRead then
  begin
    FPeekAheadRead := false;
    Result := true;
  end else
  begin
    if FDbxReader.Next then
      Result := true
    else
    begin
      Result := false;
      Free;
    end;
  end;
end;

{ TAdoDbxException }

constructor TAdoDbxException.Create(DBXError: TDBXError);
begin
  inherited Create(DBXError.Message, DBXError.ErrorCode);
end;

constructor TAdoDbxException.Create(Message: String);
begin
  inherited Create(Message);
end;

{ TAdoDbxDataAdapter }

procedure TAdoDbxDataAdapter.add_RowUpdated(
  const Value: TAdoDbxRowUpdatedEventHandler);
begin
  Events.AddHandler(FEventRowUpdated, @Value);
end;

procedure TAdoDbxDataAdapter.add_RowUpdating(
  const Value: TAdoDbxRowUpdatingEventHandler);
begin
  Events.AddHandler(FEventRowUpdating, @Value);
end;

constructor TAdoDbxDataAdapter.Create(Command: TAdoDbxCommand);
begin
  Create;
  SelectCommand := Command;
end;

constructor TAdoDbxDataAdapter.Create;
begin
  inherited Create;
end;

constructor TAdoDbxDataAdapter.Create(const selectCommandText: string;
  selectConnection: TAdoDbxConnection);
var
  Command: TAdoDbxCommand;
begin
  Command := TAdoDbxCommand(selectConnection.CreateCommand);
  Command.CommandText := selectCommandText;
  Create(Command);
end;       

function TAdoDbxDataAdapter.CreateRowUpdatedEvent(dataRow: DataRow;
  command: IDbCommand; statementType: StatementType;
  tableMapping: DataTableMapping): RowUpdatedEventArgs;
begin
  Result := TAdoDbxRowUpdatedEventArgs.Create(dataRow, command, statementType, tableMapping);
end;

function TAdoDbxDataAdapter.CreateRowUpdatingEvent(dataRow: DataRow;
  command: IDbCommand; statementType: StatementType;
  tableMapping: DataTableMapping): RowUpdatingEventArgs;
begin
  Result := TAdoDbxRowUpdatingEventArgs.Create(dataRow, command, statementType, tableMapping);
end;

constructor TAdoDbxDataAdapter.Create(const selectCommandText,
  selectConnectionString: string);
begin
  Create(selectCommandText, TAdoDbxConnection.Create(selectConnectionString));
end;

class constructor TAdoDbxDataAdapter.Create;
begin
  FEventRowUpdated := System.Object.Create;
  FEventRowUpdating := System.Object.Create;
end;

function TAdoDbxDataAdapter.get_DeleteCommand: TAdoDbxCommand;
begin
  Result := TAdoDbxCommand(inherited DeleteCommand);
end;

function TAdoDbxDataAdapter.get_InsertCommand: TAdoDbxCommand;
begin
  Result := TAdoDbxCommand(inherited InsertCommand);
end;

function TAdoDbxDataAdapter.get_SelectCommand: TAdoDbxCommand;
begin
  Result := TAdoDbxCommand(inherited SelectCommand);
end;

function TAdoDbxDataAdapter.get_UpdateCommand: TAdoDbxCommand;
begin
  Result := TAdoDbxCommand(inherited UpdateCommand);
end;

procedure TAdoDbxDataAdapter.OnRowUpdated(value: RowUpdatedEventArgs);
var
  Handler: TAdoDbxRowUpdatedEventHandler;
begin
  Handler := TAdoDbxRowUpdatedEventHandler(Events[FEventRowUpdated]);
  if Assigned(Handler) and (Value is TAdoDbxRowUpdatedEventArgs) then
    Handler(Self, TAdoDbxRowUpdatedEventArgs(value));
end;

procedure TAdoDbxDataAdapter.OnRowUpdating(value: RowUpdatingEventArgs);
var
  Handler: TAdoDbxRowUpdatingEventHandler;
begin
  Handler := TAdoDbxRowUpdatingEventHandler(Events[FEventRowUpdating]);
  if Assigned(Handler) and (Value is TAdoDbxRowUpdatingEventArgs) then
    Handler(Self, TAdoDbxRowUpdatingEventArgs(value));
end;

procedure TAdoDbxDataAdapter.remove_RowUpdated(
  const Value: TAdoDbxRowUpdatedEventHandler);
begin
  Events.RemoveHandler(FEventRowUpdated, @Value);
end;

procedure TAdoDbxDataAdapter.remove_RowUpdating(
  const Value: TAdoDbxRowUpdatingEventHandler);
begin
  Events.RemoveHandler(FEventRowUpdating, @Value);
end;

procedure TAdoDbxDataAdapter.set_DeleteCommand(const Value: TAdoDbxCommand);
begin
  inherited DeleteCommand := Value;
end;

procedure TAdoDbxDataAdapter.set_InsertCommand(const Value: TAdoDbxCommand);
begin
  inherited InsertCommand := Value;
end;

procedure TAdoDbxDataAdapter.set_SelectCommand(const Value: TAdoDbxCommand);
begin
  inherited SelectCommand := Value;
end;

procedure TAdoDbxDataAdapter.set_UpdateCommand(const Value: TAdoDbxCommand);
begin
  inherited UpdateCommand := Value;
end;

{ TAdoDbxCommandBuilder }

procedure TAdoDbxCommandBuilder.AdoDbxRowUpdatingHandler(Sender: TObject;
  e: TAdoDbxRowUpdatingEventArgs);
begin
  inherited RowUpdatingHandler(e);
end;

procedure TAdoDbxCommandBuilder.ApplyParameterInfo(parameter: DbParameter;
  row: DataRow; statementType: StatementType; whereClause: Boolean);
var
  AdoDbxParameter: TAdoDbxParameter;
begin
  inherited;
  AdoDbxParameter := TAdoDbxParameter(parameter);
  AdoDbxParameter.DbxSubType:= Integer(row[TAdoDbxSchemaTableColumnNames.DbxSubType]);
  AdoDbxParameter.DbxDataType := Integer(row[TAdoDbxSchemaTableColumnNames.DbxDataType]);
  AdoDbxParameter.Precision := Integer(row[TAdoDbxSchemaTableColumnNames.DbxPrecision]);
  AdoDbxParameter.Scale := Integer(row[SchemaTableColumn.NumericScale]);
  AdoDbxParameter.Size := Integer(row[SchemaTableColumn.ColumnSize]);
end;

constructor TAdoDbxCommandBuilder.Create(Adapter: TAdoDbxDataAdapter);
begin
  Create;
  Self.DataAdapter := Adapter;
end;

constructor TAdoDbxCommandBuilder.Create;
begin
  inherited;
  QuotePrefix := cQuote;
  QuoteSuffix := cQuote;
end;

function TAdoDbxCommandBuilder.GetParameterName(parameterOrdinal: Integer): string;
begin
  Result := System.String.Format(':p{0}', [parameterOrdinal]);
end;

function TAdoDbxCommandBuilder.GetParameterName(parameterName: string): string;
begin
  Result := System.String.Format(':{0}', [parameterName]);
end;

function TAdoDbxCommandBuilder.GetParameterPlaceholder(parameterOrdinal: Integer): string;
begin
  Result := '?';
end;

function TAdoDbxCommandBuilder.QuoteIdentifier(
  unquotedIdentifier: string): string;
var
  DatabaseMetaData: TDBXDatabaseMetaDataEx;
  QuoteChar: string;
  QuotePrefix: string;
  QuoteSuffix: string;
begin
  if Assigned(DataAdapter) and Assigned(DataAdapter.SelectCommand) and Assigned(DataAdapter.SelectCommand.Connection) then
  begin
    DatabaseMetaData := TAdoDbxConnection(DataAdapter.SelectCommand.Connection).DbxConnection.DatabaseMetaData as TDBXDatabaseMetaDataEx;
    QuoteChar := DatabaseMetadata.QuoteChar;
    QuotePrefix := DatabaseMetadata.QuotePrefix;
    QuoteSuffix := DatabaseMetadata.QuoteSuffix;
  end
  else if HasCurrentConnectionQuoteInfo then
  begin
    QuoteChar := CurrentConnectionQuoteChar;
    QuotePrefix := CurrentConnectionQuotePrefix;
    QuoteSuffix := CurrentConnectionQuoteSuffix;
  end
  else
  begin
    QuoteChar := cQuote;
    QuotePrefix := cQuote;
    QuoteSuffix := cQuote;
  end;
  Result := TDBXMetadataUtil.QuoteIdentifier(unquotedIdentifier, QuoteChar, QuotePrefix, QuoteSuffix);
end;

procedure TAdoDbxCommandBuilder.SetRowUpdatingHandler(adapter: DbDataAdapter);
var
  DatabaseMetaData: TDBXDatabaseMetaDataEx;
begin
  if adapter = Self.DataAdapter then
    Exclude(TAdoDbxDataAdapter(adapter).RowUpdating, AdoDbxRowUpdatingHandler)
  else
  begin
    Include(TAdoDbxDataAdapter(adapter).RowUpdating, AdoDbxRowUpdatingHandler);
    if Assigned(adapter) and Assigned(adapter.SelectCommand) and Assigned(adapter.SelectCommand.Connection) then
    begin
      DatabaseMetaData := TAdoDbxConnection(adapter.SelectCommand.Connection).DbxConnection.DatabaseMetaData as TDBXDatabaseMetaDataEx;
      QuotePrefix := DatabaseMetadata.QuotePrefix;
      QuoteSuffix := DatabaseMetadata.QuoteSuffix;
    end;
  end;
end;

function TAdoDbxCommandBuilder.UnquoteIdentifier(
  quotedIdentifier: string): string;
var
  DatabaseMetaData: TDBXDatabaseMetaDataEx;
  QuoteChar: string;
  QuotePrefix: string;
  QuoteSuffix: string;
begin
  if Assigned(DataAdapter) and Assigned(DataAdapter.SelectCommand) and Assigned(DataAdapter.SelectCommand.Connection) then
  begin
    DatabaseMetaData := TAdoDbxConnection(DataAdapter.SelectCommand.Connection).DbxConnection.DatabaseMetaData as TDBXDatabaseMetaDataEx;
    QuoteChar := DatabaseMetadata.QuoteChar;
    QuotePrefix := DatabaseMetadata.QuotePrefix;
    QuoteSuffix := DatabaseMetadata.QuoteSuffix;
  end
  else if HasCurrentConnectionQuoteInfo then
  begin
    QuoteChar := CurrentConnectionQuoteChar;
    QuotePrefix := CurrentConnectionQuotePrefix;
    QuoteSuffix := CurrentConnectionQuoteSuffix;
  end
  else
  begin
    QuoteChar := cQuote;
    QuotePrefix := cQuote;
    QuoteSuffix := cQuote;
  end;
  Result := TDBXMetadataUtil.UnquotedIdentifier(quotedIdentifier, QuoteChar, QuotePrefix, QuoteSuffix);
end;

{ TAdoDbxRowUpdatingEventArgs }

function TAdoDbxRowUpdatingEventArgs.get_Command: TAdoDbxCommand;
begin
  Result := TAdoDbxCommand(inherited Command);
end;

procedure TAdoDbxRowUpdatingEventArgs.set_Command(const Value: TAdoDbxCommand);
begin
  inherited Command := Value;
end;

{ TAdoDbxRowUpdatedEventArgs }

function TAdoDbxRowUpdatedEventArgs.get_Command: TAdoDbxCommand;
begin
  Result := TAdoDbxCommand(inherited Command);
end;

{ TAdoDbxSchemaItem }

constructor TAdoDbxSchemaItem.Create(Command: String;
  Restrictions: array of String; UniqueIdentifiers: Integer);
begin
  inherited Create;
  FMetaDataCommand    := Command;
  FRestrictions       := Restrictions;
  FNumberOfIdentifierParts  := UniqueIdentifiers;
  FNumberOfPeriodSeparatedParts := ComputePeriodSeparatedRestrictions;
end;

function TAdoDbxSchemaItem.CreateCommandText(
  const RestrictionValues: array of String; const QuoteChar, QuotePrefix, QuoteSuffix: string): String;
var
  Index:                    Integer;
  MissingRestrictionCount:  Integer;
  MaxRestrictionCount:      Integer;
  ValueCount:               Integer;
  Value: string;
begin
  MaxRestrictionCount := Length(FRestrictions);
  ValueCount := Length(RestrictionValues);

  MissingRestrictionCount := MaxRestrictionCount - ValueCount;

  Result := FMetaDataCommand;
  if MaxRestrictionCount > 0 then
  begin
    Index := 0;

    Result := Result + ' ';

    while (Index < MaxRestrictionCount) do
    begin
      if (Index < MissingRestrictionCount) or (RestrictionValues[Index-MissingRestrictionCount] = nil) then
      begin
        if Index < FNumberOfIdentifierParts then
          Result := Result + '%';
      end
      else
      begin
        Value := RestrictionValues[Index-MissingRestrictionCount];
        if FNumberOfIdentifierParts > Index then        
          Value := TDBXMetaDataUtil.QuoteIdentifier(Value,
            QuoteChar, QuotePrefix, QuoteSuffix);
        Result := Result + Value;
      end;
      inc(Index);
      if Index < MaxRestrictionCount then
      begin
        if FNumberOfPeriodSeparatedParts > Index then
          Result := Result + '.'
        else
          Result := Result + ' ';
      end;
    end;
  end;
end;

function TAdoDbxSchemaItem.ComputePeriodSeparatedRestrictions: Integer;
begin
  if FMetaDataCommand = TDBXMetaDataCommands.GetIndexColumns then
    Result := 3  // catalog.schema.table index
  else if FMetaDataCommand = TDBXMetaDataCommands.GetForeignKeyColumns then
    Result := 3  // catalog.schema.table foreignkey [PrimaryKey|ForeignKey]
  else
    Result := FNumberOfIdentifierParts;
end;

{ TAdoDbxConnectionStringBuilder }

constructor TAdoDbxConnectionStringBuilder.Create;
begin
  inherited Create(True);
end;

function TAdoDbxConnectionStringBuilder.get_ConnectionName: string;
begin
  Result := string(Self[TDbxPropertyNames.ConnectionName]);
end;

function TAdoDbxConnectionStringBuilder.get_Database: string;
begin
  Result := string(Self[TDbxPropertyNames.Database]);
end;

function TAdoDbxConnectionStringBuilder.get_DelegateConnection: string;
begin
  Result := string(Self[TDbxPropertyNames.DelegateConnection]);
end;

function TAdoDbxConnectionStringBuilder.get_DelegateDriver: string;
begin
  Result := string(Self[TDbxPropertyNames.DelegateDriver]);
end;

function TAdoDbxConnectionStringBuilder.get_DriverAssembly: string;
begin
  Result := string(Self[TDbxPropertyNames.DriverAssembly]);
end;

function TAdoDbxConnectionStringBuilder.get_DriverAssemblyLoader: string;
begin
  Result := string(Self[TDbxPropertyNames.DriverAssemblyLoader]);
end;

function TAdoDbxConnectionStringBuilder.get_DriverName: string;
begin
  Result := string(Self[TDbxPropertyNames.DriverName]);
end;

function TAdoDbxConnectionStringBuilder.get_DriverPackage: string;
begin
  Result := string(Self[TDbxPropertyNames.DriverPackage]);
end;

function TAdoDbxConnectionStringBuilder.get_DriverPackageLoader: string;
begin
  Result := string(Self[TDbxPropertyNames.DriverPackageLoader]);
end;

function TAdoDbxConnectionStringBuilder.get_DriverUnit: string;
begin
  Result := string(Self[TDbxPropertyNames.DriverUnit]);
end;

function TAdoDbxConnectionStringBuilder.get_ErrorResourceFile: string;
begin
  Result := string(Self[TDbxPropertyNames.ErrorResourceFile]);
end;

function TAdoDbxConnectionStringBuilder.get_GetDriverFunc: string;
begin
  Result := string(Self[TDbxPropertyNames.GetDriverFunc]);
end;

function TAdoDbxConnectionStringBuilder.get_HostName: string;
begin
  Result := string(Self[TDbxPropertyNames.HostName]);
end;

function TAdoDbxConnectionStringBuilder.get_IsolationLevel: Integer;
begin
  Result := Integer(Self[TDbxPropertyNames.IsolationLevel]);
end;

function TAdoDbxConnectionStringBuilder.get_Item(keyword: string): TObject;
begin
  Result := inherited get_Item(keyword);
end;

function TAdoDbxConnectionStringBuilder.get_LibraryName: string;
begin
  Result := string(Self[TDbxPropertyNames.LibraryName]);
end;

function TAdoDbxConnectionStringBuilder.get_MaxBlobSize: Integer;
begin
  Result := Integer(Self[TDbxPropertyNames.MaxBlobSize]);
end;

function TAdoDbxConnectionStringBuilder.get_MetaDataAssemblyLoader: string;
begin
  Result := string(Self[TDbxPropertyNamesEx.MetaDataAssemblyLoader]);
end;

function TAdoDbxConnectionStringBuilder.get_MetaDataPackageLoader: string;
begin
  Result := string(Self[TDbxPropertyNamesEx.MetaDataPackageLoader]);
end;

function TAdoDbxConnectionStringBuilder.get_Password: string;
begin
  Result := string(Self[TDbxPropertyNames.Password]);
end;

function TAdoDbxConnectionStringBuilder.get_Port: Integer;
begin
  Result := Integer(Self[TDbxPropertyNames.Port]);
end;

function TAdoDbxConnectionStringBuilder.get_ProductVersion: string;
begin
  Result := string(Self[TDbxPropertyNamesEx.ProductVersion]);
end;

function TAdoDbxConnectionStringBuilder.get_Role: string;
begin
  Result := string(Self[TDbxPropertyNames.Role]);
end;

function TAdoDbxConnectionStringBuilder.get_SchemaOverride: string;
begin
  Result := string(Self[TDbxPropertyNames.SchemaOverride]);
end;

function TAdoDbxConnectionStringBuilder.get_User_Name: string;
begin
  Result := string(Self[TDbxPropertyNames.UserName]);
end;

function TAdoDbxConnectionStringBuilder.get_VendorLib: string;
begin
  Result := string(Self[TDbxPropertyNames.VendorLib]);
end;

procedure TAdoDbxConnectionStringBuilder.set_ConnectionName(const Value: string);
begin
  Self[TDbxPropertyNames.ConnectionName] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_Database(const Value: string);
begin
  Self[TDbxPropertyNames.Database] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_DelegateConnection(const Value: string);
begin
  Self[TDbxPropertyNames.DelegateConnection] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_DelegateDriver(const Value: string);
begin
  Self[TDbxPropertyNames.DelegateDriver] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_DriverAssembly(const Value: string);
begin
  Self[TDbxPropertyNames.DriverAssembly] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_DriverAssemblyLoader(const Value: string);
begin
  Self[TDbxPropertyNames.DriverAssemblyLoader] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_DriverName(const Value: string);
begin
  Self[TDbxPropertyNames.DriverName] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_DriverPackage(const Value: string);
begin
  Self[TDbxPropertyNames.DriverPackage] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_DriverPackageLoader(const Value: string);
begin
  Self[TDbxPropertyNames.DriverPackageLoader] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_DriverUnit(const Value: string);
begin
  Self[TDbxPropertyNames.DriverUnit] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_ErrorResourceFile(const Value: string);
begin
  Self[TDbxPropertyNames.ErrorResourceFile] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_GetDriverFunc(const Value: string);
begin
  Self[TDbxPropertyNames.GetDriverFunc] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_HostName(const Value: string);
begin
  Self[TDbxPropertyNames.HostName] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_IsolationLevel(const Value: Integer);
begin
  Self[TDbxPropertyNames.IsolationLevel] := &Object(Value);
end;

procedure TAdoDbxConnectionStringBuilder.set_Item(keyword: string;
  value: TObject);
begin
  inherited;
end;

procedure TAdoDbxConnectionStringBuilder.set_LibraryName(const Value: string);
begin
  Self[TDbxPropertyNames.LibraryName] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_MaxBlobSize(const Value: Integer);
begin
  Self[TDbxPropertyNames.MaxBlobSize] := &Object(Value);
end;

procedure TAdoDbxConnectionStringBuilder.set_MetaDataAssemblyLoader(const Value: string);
begin
  Self[TDBXPropertyNamesEx.MetaDataAssemblyLoader] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_MetaDataPackageLoader(const Value: string);
begin
  Self[TDbxPropertyNamesEx.MetaDataPackageLoader] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_Password(const Value: string);
begin
  Self[TDbxPropertyNames.Password] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_Port(const Value: Integer);
begin
  Self[TDbxPropertyNames.Port] := &Object(Value);
end;

procedure TAdoDbxConnectionStringBuilder.set_ProductVersion(const Value: string);
begin
  Self[TDbxPropertyNamesEx.ProductVersion] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_Role(const Value: string);
begin
  Self[TDbxPropertyNames.Role] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_SchemaOverride(const Value: string);
begin
  Self[TDbxPropertyNames.SchemaOverride] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_User_Name(const Value: string);
begin
  Self[TDbxPropertyNames.UserName] := Value;
end;

procedure TAdoDbxConnectionStringBuilder.set_VendorLib(const Value: string);
begin
  Self[TDbxPropertyNames.VendorLib] := Value;
end;

function TAdoDbxConnectionStringBuilder.TryGetValue(keyword: string; out value: TObject): Boolean;
begin
  Result := inherited TryGetValue(keyword, value);
end;

{ TLocalizableConnectionStringCategory }

function TLocalizableConnectionStringCategory.GetLocalizedString(
  Value: string): string;
begin
  if Value = Dynalink then
    Result := resDynalink
  else if Value = DataBase then
    Result := resDataBase
  else
    Result := resDriverConfiguration;
end;

resourcestring
  resDbxDataSourceDescription = 'Connect to any SQL database supported by CodeGear dbExpress, such as InterBase, MySQL, Oracle, DB2, or Microsoft SQL Server.';
  resDbxDataSourceDisplayName = 'DBXDatabase';
  
{ DbxDataSourceDescriptionAttribute }

constructor DbxDataSourceDescriptionAttribute.Create;
begin
  inherited Create(resDbxDataSourceDescription);
end;

function DbxDataSourceDescriptionAttribute.get_TypeId: System.Object;
begin
  Result := typeof(DescriptionAttribute);
end;

{ DbxDataSourceDisplayNameAttribute }

constructor DbxDataSourceDisplayNameAttribute.Create;
begin
  inherited Create(resDbxDataSourceDisplayName);
end;

function DbxDataSourceDisplayNameAttribute.get_TypeId: System.Object;
begin
  Result := typeof(DisplayNameAttribute);
end;


{ DbxDataSource }

constructor DbxDataSource.Create;
begin
   inherited Create;
  SetEvents;
end;

constructor DbxDataSource.Create(ConnectionString, SelectCommand: String);
begin
  inherited Create(ConnectionString, SelectCommand);
  SetEvents;
end;

constructor DbxDataSource.Create(ProviderName, ConnectionString,
  SelectCommand: String);
begin
  inherited Create(ProviderName, ConnectionString, SelectCommand);
  SetEvents;
end;

procedure DbxDataSource.SetEvents;
begin
  Include(Self.Selecting, DbxSelecting);
  Include(Self.Updating, DbxUpdating);
  Include(Self.Deleting, DbxDeleting);
  Include(Self.Inserting, DbxInserting);
end;

procedure DbxDataSource.DbxDeleting(sender: TObject;
  args: SqlDataSourceCommandEventArgs);
begin
  if args.Command is TAdoDbxCommand then
    (args.Command as TAdoDbxCommand).SetDbxValueTypes(SelectCommand);
end;

procedure DbxDataSource.DbxInserting(sender: TObject;
  args: SqlDataSourceCommandEventArgs);
begin
  if args.Command is TAdoDbxCommand then
    (args.Command as TAdoDbxCommand).SetDbxValueTypes(SelectCommand);
end;

procedure DbxDataSource.DbxSelecting(sender: TObject;
  args: SqlDataSourceSelectingEventArgs);
begin
  if args.Command is TAdoDbxCommand then
    (args.Command as TAdoDbxCommand).SetNeedDbxValueTypes(true);
end;

procedure DbxDataSource.DbxUpdating(sender: TObject;
  args: SqlDataSourceCommandEventArgs);
begin
  if args.Command is TAdoDbxCommand then
    (args.Command as TAdoDbxCommand).SetDbxValueTypes(SelectCommand);
end;


initialization
  TAdoDbxConnection.InitSchemaItems;
  TAdoDbxProviderFactory.FValueTypesCache := HashTable.Synchronized(HashTable.Create);
end.
