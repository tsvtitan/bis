{$A8} {$R-}
{*************************************************************}
{                                                             }
{       CodeGear Delphi Visual Component Library              }
{       InterBase Express core components                     }
{                                                             }
{       Copyright (c) 1998-2007 CodeGear                      }
{                                                             }
{    InterBase Express is based in part on the product        }
{    Free IB Components, written by Gregory H. Deatz for      }
{    Hoagland, Longo, Moran, Dunst & Doukas Company.          }
{    Free IB Components is used under license.                }
{                                                             }
{    Additional code created by Jeff Overcash and used        }
{    with permission.                                         }
{*************************************************************}

unit IBDatabase;

interface

uses
  SysUtils, Classes,
  {$IFDEF MSWINDOWS}
    Windows, Messages,
  {$ENDIF}                                                                            
  IBHeader, IBExternals, DB, IB, IBUtils, IBIntf;

const
  DPBPrefix = 'isc_dpb_';       {do not localize}
  DPBConstantNames: array[1..isc_dpb_last_dpb_constant] of string = (
    'cdd_pathname',                  {do not localize}
    'allocation',                    {do not localize}
    'journal',                       {do not localize}
    'page_size',                     {do not localize}
    'num_buffers',                   {do not localize}
    'buffer_length',                 {do not localize}
    'debug',                         {do not localize}
    'garbage_collect',               {do not localize}
    'verify',                        {do not localize}
    'sweep',                         {do not localize}
    'enable_journal',                {do not localize}
    'disable_journal',               {do not localize}
    'dbkey_scope',                   {do not localize}
    'number_of_users',               {do not localize}
    'trace',                         {do not localize}
    'no_garbage_collect',            {do not localize}
    'damaged',                       {do not localize}
    'license',                       {do not localize}
    'sys_user_name',                 {do not localize}
    'encrypt_key',                   {do not localize}
    'activate_shadow',               {do not localize}
    'sweep_interval',                {do not localize}
    'delete_shadow',                 {do not localize}
    'force_write',                   {do not localize}
    'begin_log',                     {do not localize}
    'quit_log',                      {do not localize}
    'no_reserve',                    {do not localize}
    'user_name',                     {do not localize}
    'password',                      {do not localize}
    'password_enc',                  {do not localize}
    'sys_user_name_enc',             {do not localize}
    'interp',                        {do not localize}
    'online_dump',                   {do not localize}
    'old_file_size',                 {do not localize}
    'old_num_files',                 {do not localize}
    'old_file_name',                 {do not localize}
    'old_start_page',                {do not localize}
    'old_start_seqno',               {do not localize}
    'old_start_file',                {do not localize}
    'drop_walfile',                  {do not localize}
    'old_dump_id',                   {do not localize}
    'wal_backup_dir',                {do not localize}
    'wal_chkptlen',                  {do not localize}
    'wal_numbufs',                   {do not localize}
    'wal_bufsize',                   {do not localize}
    'wal_grp_cmt_wait',              {do not localize}
    'lc_messages',                   {do not localize}
    'lc_ctype',                      {do not localize}
    'cache_manager',                 {do not localize}
    'shutdown',                      {do not localize}
    'online',                        {do not localize}
    'shutdown_delay',                {do not localize}
    'reserved',                      {do not localize}
    'overwrite',                     {do not localize}
    'sec_attach',                    {do not localize}
    'disable_wal',                   {do not localize}
    'connect_timeout',               {do not localize}
    'dummy_packet_interval',         {do not localize}
    'gbak_attach',                   {do not localize}
    'sql_role_name',                 {do not localize}
    'set_page_buffers',              {do not localize}
    'working_directory',             {do not localize}
    'sql_dialect',                   {do not localize}
    'set_db_readonly',               {do not localize}
    'set_db_sql_dialect',            {do not localize}
    'gfix_attach',                   {do not localize}
    'gstat_attach',                  {do not localize}
    'gbak_ods_version',              {do not localize}
    'gbak_ods_minor_version',        {do not localize}
    'set_group_commit',              {do not localize}
    'gbak_validate',                 {do not localize}
    'client_interbase_var',          {do not localize}
    'admin_option',                  {do not localize}
    'flush_interval',                {do not localize}
    'instance_name',                 {do not localize}
    'old_overwrite',                 {do not localize}
    'archive_database',              {do not localize}
    'archive_journals',              {do not localize}
    'archive_sweep',                 {do not localize}
    'archive_dumps',                 {do not localize}
    'archive_recover',               {do not localize}
    'recover_until',                 {do not localize}
    'force');                        {do not localize}

  TPBPrefix = 'isc_tpb_';            {do not localize}
  TPBConstantNames: array[1..isc_tpb_last_tpb_constant] of string = (
    'consistency',                   {do not localize}
    'concurrency',                   {do not localize}
    'shared',                        {do not localize}
    'protected',                     {do not localize}
    'exclusive',                     {do not localize}
    'wait',                          {do not localize}
    'nowait',                        {do not localize}
    'read',                          {do not localize}
    'write',                         {do not localize}
    'lock_read',                     {do not localize}
    'lock_write',                    {do not localize}
    'verb_time',                     {do not localize}
    'commit_time',                   {do not localize}
    'ignore_limbo',                  {do not localize}
    'read_committed',                {do not localize}
    'autocommit',                    {do not localize}
    'rec_version',                   {do not localize}
    'no_rec_version',                {do not localize}
    'restart_requests',              {do not localize}
    'no_auto_undo',                  {do not localize}
    'no_savepoint'                   {do not localize}
  );

type

  TIBDatabase = class;
  TIBTransaction = class;
  TIBBase = class;

  TIBDatabaseLoginEvent = procedure(Database: TIBDatabase;
    LoginParams: TStrings) of object;

  IIBEventNotifier = interface
  ['{9427DE09-46F7-4E1D-8B92-C1F88B47BF6D}']  {do not localize}
    procedure RegisterEvents;
    procedure UnRegisterEvents;
    function GetAutoRegister: Boolean;
  end;

  TIBSchema = class(TObject)
  public
    procedure FreeNodes; virtual; abstract;
    function Has_DEFAULT_VALUE(Relation, Field : String) : Boolean; virtual; abstract;
    function Has_COMPUTED_BLR(Relation, Field : String) : Boolean; virtual; abstract;
    function In_Key(Relation, Field : String) : Boolean; virtual; abstract;
  end;

  TIBFileName = type string;
  { TIBDatabase }
  TIBDataBase = class(TCustomConnection)
  private
    FHiddenPassword: string;
    FIBLoaded: Boolean;
    FOnLogin: TIBDatabaseLoginEvent;
    FTraceFlags: TTraceFlags;
    FDBSQLDialect: Integer;
    FSQLDialect: Integer;
    FOnDialectDowngradeWarning: TNotifyEvent;
    FCanTimeout: Boolean;
    FSQLObjects: TList;
    FTransactions: TList;
    FDBName: TIBFileName;
    FDBParams: TStrings;
    FDBParamsChanged: Boolean;
    FDPB: PChar;
    FDPBLength: Short;
    FHandle: TISC_DB_HANDLE;
    FHandleIsShared: Boolean;
    FOnIdleTimer: TNotifyEvent;
    FDefaultTransaction: TIBTransaction;
    FInternalTransaction: TIBTransaction;
    FTimer: TIBTimer;
    FUserNames: TStringList;
    FEventNotifiers : TList;
    FAllowStreamedConnected: Boolean;
    FSchema : TIBSchema;
    FGDSLibrary : IGDSLibrary;
    procedure EnsureInactive;
    function GetDBSQLDialect: Integer;
    function GetSQLDialect: Integer;
    procedure SetSQLDialect(const Value: Integer);
    procedure ValidateClientSQLDialect;
    procedure DBParamsChange(Sender: TObject);
    procedure DBParamsChanging(Sender: TObject);
    function GetSQLObject(Index: Integer): TIBBase;
    function GetSQLObjectCount: Integer;
    function GetDBParamByDPB(const Idx: Integer): String;
    function GetIdleTimer: Integer;
    function GetTransaction(Index: Integer): TIBTransaction;
    function GetTransactionCount: Integer;
    function Login: Boolean;
    procedure SetDatabaseName(const Value: TIBFileName);
    procedure SetDBParamByDPB(const Idx: Integer; Value: String);
    procedure SetDBParams(Value: TStrings);
    procedure SetDefaultTransaction(Value: TIBTransaction);
    procedure SetIdleTimer(Value: Integer);
    procedure TimeoutConnection(Sender: TObject);
    function GetIsReadOnly: Boolean;
    function AddSQLObject(ds: TIBBase): Integer;
    procedure RemoveSQLObject(Idx: Integer);
    procedure RemoveSQLObjects;
    procedure InternalClose(Force: Boolean);

  protected
    procedure DoConnect; override;
    procedure DoDisconnect; override;
    function GetConnected: Boolean; override;
    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddEventNotifier(Notifier : IIBEventNotifier);
    procedure RemoveEventNotifier(Notifier : IIBEventNotifier);
    procedure ApplyUpdates(const DataSets: array of TDataSet);
    procedure CloseDataSets;
    procedure CheckActive;
    procedure CheckInactive;
    procedure CreateDatabase;
    procedure DropDatabase;
    procedure ForceClose;
    procedure GetFieldNames(const TableName: string; List: TStrings);
    procedure GetTableNames(List: TStrings; SystemTables: Boolean = False);
    function IndexOfDBConst(st: String): Integer;
    function TestConnected: Boolean;
    procedure CheckDatabaseName;
    function Call(ErrCode: ISC_STATUS; RaiseError: Boolean): ISC_STATUS;
    function AddTransaction(TR: TIBTransaction): Integer;
    function FindTransaction(TR: TIBTransaction): Integer;
    function FindDefaultTransaction(): TIBTransaction;
    procedure RemoveTransaction(Idx: Integer);
    procedure RemoveTransactions;
    procedure SetHandle(Value: TISC_DB_HANDLE);
    procedure OnlineDump(Files : Array of String; Sizes : Array of Integer;
         Full, Overwrite : Boolean);

    property Handle: TISC_DB_HANDLE read FHandle;
    property IsReadOnly: Boolean read GetIsReadOnly;
    property DBParamByDPB[const Idx: Integer]: String read GetDBParamByDPB
                                                      write SetDBParamByDPB;
    property SQLObjectCount: Integer read GetSQLObjectCount;
    property SQLObjects[Index: Integer]: TIBBase read GetSQLObject;
    property HandleIsShared: Boolean read FHandleIsShared;
    property TransactionCount: Integer read GetTransactionCount;
    property Transactions[Index: Integer]: TIBTransaction read GetTransaction;
    property InternalTransaction: TIBTransaction read FInternalTransaction;

    {Schema functions}
    function Has_DEFAULT_VALUE(Relation, Field : String) : Boolean;
    function Has_COMPUTED_BLR(Relation, Field : String) : Boolean;
    function In_Key(Relation, Field : String) : Boolean;
    procedure FlushSchema;

  published
    property Connected;
    property DatabaseName: TIBFileName read FDBName write SetDatabaseName;
    property Params: TStrings read FDBParams write SetDBParams;
    property LoginPrompt default True;
    property DefaultTransaction: TIBTransaction read FDefaultTransaction
                                                 write SetDefaultTransaction;
    property IdleTimer: Integer read GetIdleTimer write SetIdleTimer default 0;
    property SQLDialect : Integer read GetSQLDialect write SetSQLDialect default 3;
    property DBSQLDialect : Integer read FDBSQLDialect;
    property TraceFlags: TTraceFlags read FTraceFlags write FTraceFlags default [];
    property AllowStreamedConnected : Boolean read FAllowStreamedConnected write FAllowStreamedConnected default true;
    property AfterConnect;
    property AfterDisconnect;
    property BeforeConnect;
    property BeforeDisconnect;
    property OnLogin: TIBDatabaseLoginEvent read FOnLogin write FOnLogin;
    property OnIdleTimer: TNotifyEvent read FOnIdleTimer write FOnIdleTimer;
    property OnDialectDowngradeWarning: TNotifyEvent read FOnDialectDowngradeWarning write FOnDialectDowngradeWarning;
  end;

  { TIBTransaction }

  TIBTransactionAction = (TARollback, TACommit, TARollbackRetaining, TACommitRetaining);
  TAutoStopAction = (saNone, saRollback, saCommit, saRollbackRetaining, saCommitRetaining);

  TIBTransaction = class(TComponent)
  private
    FIBLoaded: Boolean;
    FCanTimeout         : Boolean;
    FDatabases          : TList;
    FSQLObjects         : TList;
    FDefaultDatabase    : TIBDatabase;
    FHandle             : TISC_TR_HANDLE;
    FHandleIsShared     : Boolean;
    FOnIdleTimer          : TNotifyEvent;
    FStreamedActive     : Boolean;
    FTPB                : PChar;
    FTPBLength          : Short;
    FTimer              : TIBTimer;
    FDefaultAction      : TIBTransactionAction;
    FTRParams           : TStrings;
    FTRParamsChanged    : Boolean;
    FAutoStarted : Boolean;
    FAutoStopAction: TAutoStopAction;
    FAllowAutoStart: Boolean;
    FGDSLibrary : IGDSLibrary;
    FTransactionID: integer;
    procedure EnsureNotInTransaction;
    procedure EndTransaction(Action: TIBTransactionAction; Force: Boolean);
    function GetDatabase(Index: Integer): TIBDatabase;
    function GetDatabaseCount: Integer;
    function GetSQLObject(Index: Integer): TIBBase;
    function GetSQLObjectCount: Integer;
    function GetInTransaction: Boolean;
    function GetIdleTimer: Integer;
    procedure BeforeDatabaseDisconnect(DB: TIBDatabase);
    procedure SetActive(Value: Boolean);
    procedure SetDefaultAction(Value: TIBTransactionAction);
    procedure SetDefaultDatabase(Value: TIBDatabase);
    procedure SetIdleTimer(Value: Integer);
    procedure SetTRParams(Value: TStrings);
    procedure TimeoutTransaction(Sender: TObject);
    procedure TRParamsChange(Sender: TObject);
    procedure TRParamsChanging(Sender: TObject);
    function AddSQLObject(ds: TIBBase): Integer;
    procedure RemoveSQLObject(Idx: Integer);
    procedure RemoveSQLObjects;
    function GetTransactionID: integer;
  protected
    procedure Loaded; override;
    procedure SetHandle(Value: TISC_TR_HANDLE);
    procedure Notification( AComponent: TComponent; Operation: TOperation); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Call(ErrCode: ISC_STATUS; RaiseError: Boolean): ISC_STATUS;
    procedure Commit;
    procedure CommitRetaining;
    procedure Rollback;
    procedure RollbackRetaining;
    procedure StartTransaction;
    procedure AutoStartTransaction;
    procedure ReleaseSavepoint(Name : String);
    procedure RollbackSavepoint(Name : String);
    procedure StartSavepoint(Name : String);
    procedure CheckInTransaction;
    procedure CheckNotInTransaction;
    procedure CheckAutoStop;

    function AddDatabase(db: TIBDatabase): Integer;
    function FindDatabase(db: TIBDatabase): Integer;
    function FindDefaultDatabase: TIBDatabase;
    procedure RemoveDatabase(Idx: Integer);
    procedure RemoveDatabases;
    procedure CheckDatabasesInList;

    property DatabaseCount: Integer read GetDatabaseCount;
    property Databases[Index: Integer]: TIBDatabase read GetDatabase;
    property SQLObjectCount: Integer read GetSQLObjectCount;
    property SQLObjects[Index: Integer]: TIBBase read GetSQLObject;
    property Handle: TISC_TR_HANDLE read FHandle;
    property HandleIsShared: Boolean read FHandleIsShared;
    property InTransaction: Boolean read GetInTransaction;
    property TPB: PChar read FTPB;
    property TPBLength: Short read FTPBLength;
    property TransactionID: integer read GetTransactionID;
  published
    property Active: Boolean read GetInTransaction write SetActive default false;
    property AllowAutoStart : Boolean read FAllowAutoStart write FAllowAutoStart default true;
    property DefaultDatabase: TIBDatabase read FDefaultDatabase
                                           write SetDefaultDatabase;
    property IdleTimer: Integer read GetIdleTimer write SetIdleTimer default 0;
    property DefaultAction: TIBTransactionAction read FDefaultAction write SetDefaultAction default taCommit;
    property Params: TStrings read FTRParams write SetTRParams;
    property AutoStopAction : TAutoStopAction read FAutoStopAction write FAutoStopAction default saNone;
    property OnIdleTimer: TNotifyEvent read FOnIdleTimer write FOnIdleTimer;
  end;

  { TIBBase }

  { Virtually all components in IB are "descendents" of TIBBase.
    It is to more easily manage the database and transaction
    connections. }
  TIBBase = class(TObject)
  protected
    FDatabase: TIBDatabase;
    FIndexInDatabase: Integer;
    FTransaction: TIBTransaction;
    FIndexInTransaction: Integer;
    FOwner: TObject;
    FBeforeDatabaseDisconnect: TNotifyEvent;
    FAfterDatabaseDisconnect: TNotifyEvent;
    FOnDatabaseFree: TNotifyEvent;
    FBeforeTransactionEnd: TNotifyEvent;
    FAfterTransactionEnd: TNotifyEvent;
    FOnTransactionFree: TNotifyEvent;

    procedure DoBeforeDatabaseDisconnect; virtual;
    procedure DoAfterDatabaseDisconnect; virtual;
    procedure DoDatabaseFree; virtual;
    procedure DoBeforeTransactionEnd; virtual;
    procedure DoAfterTransactionEnd; virtual;
    procedure DoTransactionFree; virtual;
    function GetDBHandle: PISC_DB_HANDLE; virtual;
    function GetTRHandle: PISC_TR_HANDLE; virtual;
    procedure SetDatabase(Value: TIBDatabase); virtual;
    procedure SetTransaction(Value: TIBTransaction); virtual;
  public
    constructor Create(AOwner: TObject);
    destructor Destroy; override;
    procedure CheckDatabase; virtual;
    procedure CheckTransaction; virtual;
  public
    property BeforeDatabaseDisconnect: TNotifyEvent read FBeforeDatabaseDisconnect
                                                   write FBeforeDatabaseDisconnect;
    property AfterDatabaseDisconnect: TNotifyEvent read FAfterDatabaseDisconnect
                                                  write FAfterDatabaseDisconnect;
    property OnDatabaseFree: TNotifyEvent read FOnDatabaseFree write FOnDatabaseFree;
    property BeforeTransactionEnd: TNotifyEvent read FBeforeTransactionEnd write FBeforeTransactionEnd;
    property AfterTransactionEnd: TNotifyEvent read FAfterTransactionEnd write FAfterTransactionEnd;
    property OnTransactionFree: TNotifyEvent read FOnTransactionFree write FOnTransactionFree;
    property Database: TIBDatabase read FDatabase
                                    write SetDatabase;
    property DBHandle: PISC_DB_HANDLE read GetDBHandle;
    property Owner: TObject read FOwner;
    property TRHandle: PISC_TR_HANDLE read GetTRHandle;
    property Transaction: TIBTransaction read FTransaction
                                          write SetTransaction;
  end;

procedure GenerateDPB(sl: TStrings; var DPB: string; var DPBLength: Short);
procedure GenerateTPB(sl: TStrings; var TPB: string; var TPBLength: Short);


implementation

uses IBSQLMonitor, IBCustomDataSet, IBDatabaseInfo, IBSQL,
     typInfo, IBXConst, IBErrorCodes;

type

  TFieldNode = class(TObject)
  public
    FieldName : String;
    COMPUTED_BLR : Boolean;
    DEFAULT_VALUE : boolean;
    In_Key : Boolean;
  end;

  TSchema = class(TIBSchema)
  private
    FRelations : TStringList;
    FQuery : TIBSQL;
    FPQuery : TIBSQL;
    function Add_Node(Relation, Field : String) : TFieldNode;
  public
    constructor Create(ADatabase : TIBDatabase);
    destructor Destroy; override;
    procedure FreeNodes; override;
    function Has_DEFAULT_VALUE(Relation, Field : String) : Boolean; override;
    function Has_COMPUTED_BLR(Relation, Field : String) : Boolean; override;
    function In_Key(Relation, Field : String) : Boolean; override;
  end;

{ TIBDatabase }

constructor TIBDatabase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGDSLibrary := GetGDSLibrary;
  FIBLoaded := False;
  FGDSLibrary.CheckIBLoaded;
  FIBLoaded := True;
  LoginPrompt := True;
  FSQLObjects := TList.Create;
  FTransactions := TList.Create;
  FDBName := '';
  FDBParams := TStringList.Create;
  FDBParamsChanged := True;
  TStringList(FDBParams).OnChange := DBParamsChange;
  TStringList(FDBParams).OnChanging := DBParamsChanging;
  FDPB := nil;
  FHandle := nil;
  FUserNames := nil;
  FInternalTransaction := TIBTransaction.Create(self);
  FInternalTransaction.DefaultDatabase := Self;
  FDBSQLDialect := 3;
  FSQLDialect := 3;
  FTraceFlags := [];
  FEventNotifiers := TList.Create;
  FAllowStreamedConnected := true;
  FSchema := TSchema.Create(self);
end;

destructor TIBDatabase.Destroy;
var
  i: Integer;
begin
  if FIBLoaded then
  begin
    IdleTimer := 0;
    if FHandle <> nil then
    try
      Close;
    except
      ForceClose;
    end;
    for i := 0 to FSQLObjects.Count - 1 do
      if FSQLObjects[i] <> nil then
        SQLObjects[i].DoDatabaseFree;
    RemoveSQLObjects;
    RemoveTransactions;
    FInternalTransaction.Free;
    FreeMem(FDPB);
    FDPB := nil;
    FDBParams.Free;
    FSQLObjects.Free;
    FUserNames.Free;
    FTransactions.Free;
    FEventNotifiers.Free;
    FSchema.Free;
  end;
  FGDSLibrary := nil;
  inherited Destroy;
end;

function TIBDatabase.Call(ErrCode: ISC_STATUS;
  RaiseError: Boolean): ISC_STATUS;
var
  sqlcode: Long;
  IBErrorCode: Long;
  local_buffer: array[0..IBHugeLocalBufferLength - 1] of char;
  usr_msg: string;
  status_vector: PISC_STATUS;
  IBDataBaseErrorMessages: TIBDataBaseErrorMessages;

  procedure SaveDataBaseError;
  begin
    usr_msg := '';

    { Get a local reference to the status vector.
      Get a local copy of the IBDataBaseErrorMessages options.
      Get the SQL error code }
    status_vector := StatusVector;
    IBErrorCode := StatusVectorArray[1];
    IBDataBaseErrorMessages := GetIBDataBaseErrorMessages;
    sqlcode := FGDSLibrary.isc_sqlcode(status_vector);

    if (ShowSQLCode in IBDataBaseErrorMessages) then
      usr_msg := usr_msg + 'SQLCODE: ' + IntToStr(sqlcode); {do not localize}
    Exclude(IBDataBaseErrorMessages, ShowSQLMessage);
    if (ShowSQLMessage in IBDataBaseErrorMessages) then
    begin
      FGDSLibrary.isc_sql_interprete(sqlcode, local_buffer, IBLocalBufferLength);
      if (ShowSQLCode in IBDataBaseErrorMessages) then
        usr_msg := usr_msg + CRLF;
      usr_msg := usr_msg + string(local_buffer);
    end;

    if (ShowIBMessage in IBDataBaseErrorMessages) then
    begin
      if (ShowSQLCode in IBDataBaseErrorMessages) or
         (ShowSQLMessage in IBDataBaseErrorMessages) then
        usr_msg := usr_msg + CRLF;
      while (FGDSLibrary.isc_interprete(local_buffer, @status_vector) > 0) do
      begin
        if (usr_msg <> '') and (usr_msg[Length(usr_msg)] <> LF) then
          usr_msg := usr_msg + CRLF;
        usr_msg := usr_msg + string(local_buffer);
      end;
    end;
    if (usr_msg <> '') and (usr_msg[Length(usr_msg)] = '.') then
      Delete(usr_msg, Length(usr_msg), 1);
  end;

begin
  result := ErrCode;
  FCanTimeout := False;
  {Handle when the Error is due to a Database disconnect.  Call the
  OnConnectionLost if it exists.}
  if RaiseError and (CheckStatusVector([isc_lost_db_connection]) or
                     CheckStatusVector([isc_net_read_err]) or
                     CheckStatusVector([isc_net_write_err])) then
  begin
    SaveDataBaseError;
    ForceClose;
    if (MonitorHook <> nil) then
      MonitorHook.SendError(IntToStr(sqlcode) + ' ' + IntToStr(IBErrorCode) + ' ' + usr_msg, self);
    raise EIBInterBaseError.Create(sqlcode, IBErrorCode, usr_msg);
  end;
  if RaiseError and (ErrCode > 0) then
    IBDataBaseError;
end;

procedure TIBDatabase.CheckActive;
begin
  if StreamedConnected and (not Connected) then
    Loaded;
  if FHandle = nil then
    IBError(ibxeDatabaseClosed, [nil]);
end;

procedure TIBDatabase.EnsureInactive;
begin
  if csDesigning in ComponentState then
  begin
    if FHandle <> nil then
      Close;
  end
end;

procedure TIBDatabase.CheckInactive;
begin
  if FHandle <> nil then
    IBError(ibxeDatabaseOpen, [nil]);
end;

procedure TIBDatabase.CheckDatabaseName;
begin
  if (FDBName = '') then
    IBError(ibxeDatabaseNameMissing, [nil]);
end;

function TIBDatabase.AddSQLObject(ds: TIBBase): Integer;
begin
  result := 0;
  if (ds.Owner is TIBCustomDataSet) then
      RegisterClient(TDataSet(ds.Owner));
  while (result < FSQLObjects.Count) and (FSQLObjects[result] <> nil) do
    Inc(result);
  if (result = FSQLObjects.Count) then
    FSQLObjects.Add(ds)
  else
    FSQLObjects[result] := ds;
end;

function TIBDatabase.AddTransaction(TR: TIBTransaction): Integer;
begin
  result := FindTransaction(TR);
  if result <> -1 then
  begin
    result := -1;
    exit;
  end;
  result := 0;
  while (result < FTransactions.Count) and (FTransactions[result] <> nil) do
    Inc(result);
  if (result = FTransactions.Count) then
    FTransactions.Add(TR)
  else
    FTransactions[result] := TR;
end;

procedure TIBDatabase.DoDisconnect;
var
  i : Integer;
begin
  for i := 0 to FEventNotifiers.Count - 1 do
    IIBEventNotifier(FEventNotifiers[i]).UnRegisterEvents;
  if Connected then
  try
    InternalClose(False);
  except
    ForceClose;
    raise
  end;
  FDBSQLDialect := 1;
end;

procedure TIBDatabase.CreateDatabase;
var
  tr_handle: TISC_TR_HANDLE;
begin
  CheckInactive;
  tr_handle := nil;
  Call(
    FGDSLibrary.isc_dsql_execute_immediate(StatusVector, @FHandle, @tr_handle, 0,
                               PChar('CREATE DATABASE ''' + FDBName + ''' ' + {do not localize}
                               Params.Text), SQLDialect, nil), True);
  FDBSQLDialect := GetDBSQLDialect;
end;

procedure TIBDatabase.DropDatabase;
var
  i: Integer;
begin
  { We can only drop an active database connection.  Before dropping
    disconnect the different objectso n hte conenction sdo they are not
    left in a bad state }
  CheckActive;
  { Tell all connected SQLObjects that we're disconnecting. }
  for i := 0 to FSQLObjects.Count - 1 do
  begin
    if FSQLObjects[i] <> nil then
      SQLObjects[i].DoBeforeDatabaseDisconnect;
  end;
  { Tell all connected transactions that we're disconnecting.
    This is so transactions can commit/rollback, accordingly }
  for i := 0 to FTransactions.Count - 1 do
  begin
    if FTransactions[i] <> nil then
      Transactions[i].BeforeDatabaseDisconnect(Self);
  end;
  Call(FGDSLibrary.isc_drop_database(StatusVector, @FHandle), True);
end;

procedure TIBDatabase.DBParamsChange(Sender: TObject);
begin
  FDBParamsChanged := True;
end;

procedure TIBDatabase.DBParamsChanging(Sender: TObject);
begin
  EnsureInactive;
  CheckInactive;
end;

function TIBDatabase.FindTransaction(TR: TIBTransaction): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to FTransactions.Count - 1 do
    if TR = Transactions[i] then
    begin
      result := i;
      break;
    end;
end;

function TIBDatabase.FindDefaultTransaction(): TIBTransaction;
var
  i: Integer;
begin
  result := FDefaultTransaction;
  if result = nil then
  begin
    for i := 0 to FTransactions.Count - 1 do
      if (Transactions[i] <> nil) and
        (TIBTransaction(Transactions[i]).DefaultDatabase = self) and
        (TIBTransaction(Transactions[i]) <> FInternalTransaction) then
       begin
         result := TIBTransaction(Transactions[i]);
         break;
       end;
  end;
end;

procedure TIBDatabase.ForceClose;
begin
  if Connected then
  begin
    if Assigned(BeforeDisconnect) then
      BeforeDisconnect(Self);
    SendConnectEvent(False);
    InternalClose(True);
    if Assigned(AfterDisconnect) then
      AfterDisconnect(Self);
  end;
end;

function TIBDatabase.GetConnected: Boolean;
begin
  result := FHandle <> nil;
end;

function TIBDatabase.GetSQLObject(Index: Integer): TIBBase;
begin
  result := FSQLObjects[Index];
end;

function TIBDatabase.GetSQLObjectCount: Integer;
var
  i: Integer;
begin
  result := 0;
  for i := 0 to FSQLObjects.Count - 1 do if FSQLObjects[i] <> nil then
    Inc(result);
end;

function TIBDatabase.GetDBParamByDPB(const Idx: Integer): String;
var
  ConstIdx, EqualsIdx: Integer;
begin
  if (Idx > 0) and (Idx <= isc_dpb_last_dpb_constant) then
  begin
    ConstIdx := IndexOfDBConst(DPBConstantNames[Idx]);
    if ConstIdx = -1 then
      result := ''
    else
    begin
      result := Params[ConstIdx];
      EqualsIdx := Pos('=', result); {mbcs ok}
      if EqualsIdx = 0 then
        result := ''
      else
        result := Copy(result, EqualsIdx + 1, Length(result));
    end;
  end
  else
    result := '';
end;

function TIBDatabase.GetIdleTimer: Integer;
begin
  if Assigned(FTimer) then
    Result := FTimer.Interval
  else
    Result := 0;
end;

function TIBDatabase.GetTransaction(Index: Integer): TIBTransaction;
begin
  result := FTransactions[Index];
end;

function TIBDatabase.GetTransactionCount: Integer;
var
  i: Integer;
begin
  result := 0;
  for i := 0 to FTransactions.Count - 1 do
    if FTransactions[i] <> nil then
      Inc(result);
end;

function TIBDatabase.IndexOfDBConst(st: String): Integer;
var
  i, pos_of_str: Integer;
begin
  result := -1;
  for i := 0 to Params.Count - 1 do
  begin
    pos_of_str := Pos(st, AnsiLowerCase(Params[i])); {mbcs ok}
    if (pos_of_str = 1) or (pos_of_str = Length(DPBPrefix) + 1) then
    begin
      result := i;
      break;
    end;
  end;
end;

procedure TIBDatabase.InternalClose(Force: Boolean);
var
  i: Integer;
  oldHandle : TISC_DB_HANDLE;
begin
  CheckActive;

  { If we are being forced close this is normally an abnormal connection loss.
    The underlying datasets will need to know that connection is not active
    the underlying objects are told the connection is going away }
  if Force then
  begin
    oldHandle := FHandle;
    FHandle := nil;
  end
  else
    oldHandle := nil;

  for i := 0 to FSQLObjects.Count - 1 do
  begin
    try
      if FSQLObjects[i] <> nil then
        SQLObjects[i].DoBeforeDatabaseDisconnect;
    except
      if not Force then
        raise;
    end;
  end;
  { Tell all connected transactions that we're disconnecting.
    This is so transactions can commit/rollback, accordingly
  }
  for i := 0 to FTransactions.Count - 1 do
  begin
    try
      if FTransactions[i] <> nil then
        Transactions[i].BeforeDatabaseDisconnect(Self);
    except
      if not Force then
        raise;
    end;
  end;

  if Force then
    FHandle := oldHandle;

  if (not HandleIsShared) and
     (Call(FGDSLibrary.isc_detach_database(StatusVector, @FHandle), False) > 0) and
     (not Force) then
    IBDataBaseError
  else
  begin
    FHandle := nil;
    FHandleIsShared := False;
  end;

  if (not (csDesigning in ComponentState)) and (MonitorHook <> nil) then
    MonitorHook.DBDisconnect(Self);

  for i := 0 to FSQLObjects.Count - 1 do
    if FSQLObjects[i] <> nil then
      SQLObjects[i].DoAfterDatabaseDisconnect;
end;

procedure TIBDatabase.Loaded;
var
  i: integer;
begin
  try
    If (not FAllowStreamedConnected) and
       (not (csDesigning in ComponentState)) then
    begin
      StreamedConnected := false;
      for i := 0 to FTransactions.Count - 1 do
        if  FTransactions[i] <> nil then
          with TIBTransaction(FTransactions[i]) do
            FStreamedActive := False;
    end;
    if StreamedConnected and (not Connected) then
    begin
      inherited Loaded;
      for i := 0 to FTransactions.Count - 1 do
        if  FTransactions[i] <> nil then
        begin
          with TIBTransaction(FTransactions[i]) do
            if not Active then
              if FStreamedActive and not InTransaction then
              begin
                StartTransaction;
                FStreamedActive := False;
              end;
        end;
      if (FDefaultTransaction <> nil) and
         (FDefaultTransaction.FStreamedActive) and
         (not FDefaultTransaction.InTransaction) then
        FDefaultTransaction.StartTransaction;
      StreamedConnected := False;
    end;
  except
    if csDesigning in ComponentState then
      if Assigned(ApplicationHandleException) then
        ApplicationHandleException(Self)
    else
      raise;
  end;
end;

procedure TIBDatabase.Notification( AComponent: TComponent;
                                        Operation: TOperation);
var
  i: Integer;
begin
  inherited Notification( AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDefaultTransaction) then
  begin
    i := FindTransaction(FDefaultTransaction);
    if (i <> -1) then
      RemoveTransaction(i);
    FDefaultTransaction := nil;
  end;
end;

procedure TIBDataBase.OnlineDump(Files: array of String;
  Sizes: array of Integer; Full, Overwrite : Boolean);
var
  sl : TStringList;
  i : Integer;
  DPB : String;
begin
  if (Length(Sizes) > 0) and (abs(Length(Sizes) - Length(Files)) > 1)  then
    raise Exception.Create(SFileSizeDumpCountIncompatibility);
  sl := TStringList.Create;
  try
    sl.Values['user_name'] := Params.Values['user_name'];
    sl.Values['password'] := Params.Values['password'];
    sl.Values['online_dump'] := '1';       {do not localize}
    if Overwrite then
      sl.Values['overwrite'] := '1'        {do not localize}
    else
      sl.Values['overwrite'] := '0';        {do not localize}
    for i := Low(Files) to High(Files) do
    begin
      sl.Values['old_file_name'] := Files[i];  {do not localize}
      if i <= High(Sizes) then
        sl.Values['old_file_size'] := IntToStr(Sizes[i]); {do not localize}
    end;
    GenerateDPB(sl, DPB, FDPBLength);
    IBAlloc(FDPB, 0, FDPBLength);
    Move(DPB[1], FDPB[0], FDPBLength);
    if Call(FGDSLibrary.isc_attach_database(StatusVector, Length(FDBName),
                           PChar(FDBName), @FHandle,
                           FDPBLength, FDPB), False) > 0 then
    begin
      FHandle := nil;
      IBDataBaseError;
    end;
  finally
    sl.Free;
  end;
end;

function TIBDatabase.Login: Boolean;
var
  IndexOfUser, IndexOfPassword: Integer;
  Username, Password, OldPassword: String;
  LoginParams: TStrings;

  procedure HidePassword;
  var
    I: Integer;
    IndexAt: Integer;
  begin
    IndexAt := 0;
    for I := 0 to Params.Count -1 do
      if Pos('password', LowerCase(Trim(Params.Names[i]))) = 1 then {mbcs ok}
      begin
        FHiddenPassword := Params.Values[Params.Names[i]];
        IndexAt := I;
        break;
      end;
    if IndexAt <> 0 then
      Params.Delete(IndexAt);
  end;

begin
  if Assigned(FOnLogin) then
  begin
    result := True;
    LoginParams := TStringList.Create;
    try
      LoginParams.Assign(Params);
      FOnLogin(Self, LoginParams);
      Params.Assign(LoginParams);
      HidePassword;
    finally
      LoginParams.Free;
    end;
  end
  else
  begin
    IndexOfUser := IndexOfDBConst(DPBConstantNames[isc_dpb_user_name]);
    if IndexOfUser <> -1 then
      Username := Copy(Params[IndexOfUser],
                                         Pos('=', Params[IndexOfUser]) + 1, {mbcs ok}
                                         Length(Params[IndexOfUser]));
    IndexOfPassword := IndexOfDBConst(DPBConstantNames[isc_dpb_password]);
    if IndexOfPassword <> -1 then
    begin
      Password := Copy(Params[IndexOfPassword],
                                         Pos('=', Params[IndexOfPassword]) + 1, {mbcs ok}
                                         Length(Params[IndexOfPassword]));
      OldPassword := password;
    end;
    if Assigned(LoginDialogExProc) then
      result := LoginDialogExProc(DatabaseName, Username, Password, False)
    else
    begin
      if (MonitorHook <> nil) then
        MonitorHook.SendError(SLoginPromptFailure, self);
      raise EIBError.Create(SLoginPromptFailure);
    end;
    if result then
    begin
      if IndexOfUser = -1 then
        Params.Add(DPBConstantNames[isc_dpb_user_name] + '=' + Username)
      else
        Params[IndexOfUser] := DPBConstantNames[isc_dpb_user_name] +
                                 '=' + Username;
      if (Password = OldPassword) then
        FHiddenPassword := ''
      else
      begin
        if OldPassword <> '' then
          HidePassword;
        FHiddenPassword := Password;
      end;
    end;
  end;
end;

procedure TIBDatabase.DoConnect;
var
  DPB: String;
  TempDBParams: TStrings;
  i : Integer;
begin
  CheckInactive;
  CheckDatabaseName;
  if (not LoginPrompt) and (FHiddenPassword <> '') then
  begin
    FHiddenPassword := '';
    FDBParamsChanged := True;
  end;
  { Use builtin login prompt if requested }
  if LoginPrompt and not Login then
    IBError(ibxeOperationCancelled, [nil]);
  { Generate a new DPB if necessary }
  if (FDBParamsChanged) then
  begin
    FDBParamsChanged := False;
    if (not LoginPrompt) or (FHiddenPassword = '') then
      GenerateDPB(FDBParams, DPB, FDPBLength)
    else
    begin
      TempDBParams := TStringList.Create;
      try
       TempDBParams.Assign(FDBParams);
       TempDBParams.Add('password=' + FHiddenPassword);
       GenerateDPB(TempDBParams, DPB, FDPBLength);
      finally
       TempDBParams.Free;
      end;
    end;
    IBAlloc(FDPB, 0, FDPBLength);
    Move(DPB[1], FDPB[0], FDPBLength);
  end;
  if Call(FGDSLibrary.isc_attach_database(StatusVector, Length(FDBName),
                         PChar(FDBName), @FHandle,
                         FDPBLength, FDPB), False) > 0 then
  begin
    FHandle := nil;
    IBDataBaseError;
  end;
  FDBSQLDialect := GetDBSQLDialect;
  ValidateClientSQLDialect;
  if (not (csDesigning in ComponentState)) and (MonitorHook <> nil) then
    MonitorHook.DBConnect(Self);
  for i := 0 to FEventNotifiers.Count - 1 do
    if IIBEventNotifier(FEventNotifiers[i]).GetAutoRegister then
      IIBEventNotifier(FEventNotifiers[i]).RegisterEvents;
end;

procedure TIBDatabase.RemoveSQLObject(Idx: Integer);
var
  ds: TIBBase;
begin
  if (Idx >= 0) and (FSQLObjects[Idx] <> nil) then
  begin
    ds := SQLObjects[Idx];
    FSQLObjects[Idx] := nil;
    ds.Database := nil;
    if (ds.owner is TDataSet) then
      UnregisterClient(TDataSet(ds.Owner));
  end;
end;

procedure TIBDatabase.RemoveSQLObjects;
var
  i: Integer;
begin
  for i := 0 to FSQLObjects.Count - 1 do if FSQLObjects[i] <> nil then
  begin
    RemoveSQLObject(i);
    if (TIBBase(FSQLObjects[i]).owner is TDataSet) then
      UnregisterClient(TDataSet(TIBBase(FSQLObjects[i]).owner));
  end;
end;

procedure TIBDatabase.RemoveTransaction(Idx: Integer);
var
  TR: TIBTransaction;
begin
  if ((Idx >= 0) and (FTransactions[Idx] <> nil)) then
  begin
    TR := Transactions[Idx];
    FTransactions[Idx] := nil;
    TR.RemoveDatabase(TR.FindDatabase(Self));
    if TR = FDefaultTransaction then
      FDefaultTransaction := nil;
  end;
end;

procedure TIBDatabase.RemoveTransactions;
var
  i: Integer;
begin
  for i := 0 to FTransactions.Count - 1 do if FTransactions[i] <> nil then
    RemoveTransaction(i);
end;

procedure TIBDatabase.SetDatabaseName(const Value: TIBFileName);
begin
  if FDBName <> Value then
  begin
    EnsureInactive;
    CheckInactive;
    FDBName := Value;
    FSchema.FreeNodes;
  end;
end;

procedure TIBDatabase.SetDBParamByDPB(const Idx: Integer; Value: String);
var
  ConstIdx: Integer;
begin
  ConstIdx := IndexOfDBConst(DPBConstantNames[Idx]);
  if (Value = '') then
  begin
    if ConstIdx <> -1 then
      Params.Delete(ConstIdx);
  end
  else
  begin
    if (ConstIdx = -1) then
      Params.Add(DPBConstantNames[Idx] + '=' + Value)
    else
      Params[ConstIdx] := DPBConstantNames[Idx] + '=' + Value;
  end;
end;

procedure TIBDatabase.SetDBParams(Value: TStrings);
begin
  FDBParams.Assign(Value);
end;

procedure TIBDatabase.SetDefaultTransaction(Value: TIBTransaction);
var
  i: Integer;
begin
  if (FDefaultTransaction <> nil) and (FDefaultTransaction <> Value) then
  begin
    i := FindTransaction(FDefaultTransaction);
    if (i <> -1) and (FDefaultTransaction.DefaultDatabase <> self) then
      RemoveTransaction(i);
  end;
  if (Value <> nil) and (FDefaultTransaction <> Value) then
  begin
    Value.AddDatabase(Self);
    AddTransaction(Value);
  end;
  FDefaultTransaction := Value;
end;

procedure TIBDatabase.SetHandle(Value: TISC_DB_HANDLE);
begin
  if HandleIsShared then
    Close
  else
    CheckInactive;
  FHandle := Value;
  FHandleIsShared := (Value <> nil);
end;

procedure TIBDatabase.SetIdleTimer(Value: Integer);
begin
  if Value < 0 then
    IBError(ibxeTimeoutNegative, [nil])
  else
    if (Value = 0) then
      FreeAndNil(FTimer)
    else
      if (Value > 0) then
      begin
        if not Assigned(FTimer) then
        begin
          FTimer := TIBTimer.Create(Self);
          FTimer.Enabled := False;
          FTimer.Interval := 0;
          FTimer.OnTimer := TimeoutConnection;
        end;
        FTimer.Interval := Value;
        if not (csDesigning in ComponentState) then
          FTimer.Enabled := True;
      end;
end;

function TIBDatabase.TestConnected: Boolean;
var
  local_buffer: array[0..IBLocalBufferLength - 1] of Char;
  DatabaseInfoCommand: Char;
begin
  result := Connected;
  if result then
  try
    { poke the server to see if connected }
    DatabaseInfoCommand := Char(isc_info_base_level);
    Call(FGDSLibrary.isc_database_info(StatusVector, @Handle, 1, @DatabaseInfoCommand,
                           IBLocalBufferLength, local_buffer), True);
  except
    ForceClose;
    result := False;
  end;
end;

procedure TIBDatabase.TimeoutConnection(Sender: TObject);
begin
  if Connected then
  begin
    if FCanTimeout then
    begin
      ForceClose;
      if Assigned(FOnIdleTimer) then
        FOnIdleTimer(Self);
    end
    else
      FCanTimeout := True;
  end;
end;

function TIBDatabase.GetIsReadOnly: Boolean;
var
  DatabaseInfo: TIBDatabaseInfo;
begin
  DatabaseInfo := TIBDatabaseInfo.Create(self);
  DatabaseInfo.Database := self;
  if (DatabaseInfo.ODSMajorVersion < 10) then
    result := false
  else
  begin
    if (DatabaseInfo.ReadOnly = 0) then
      result := false
    else
      result := true;
  end;
  DatabaseInfo.Free;
end;

function TIBDatabase.GetSQLDialect: Integer;
begin
  Result := FSQLDialect;
end;

procedure TIBDatabase.SetSQLDialect(const Value: Integer);
begin
  if (Value < 1) then IBError(ibxeSQLDialectInvalid, [nil]);
  if ((FHandle = nil) or (Value <= FDBSQLDialect))  then
    FSQLDialect := Value
  else
    IBError(ibxeSQLDialectInvalid, [nil]);
end;

function TIBDatabase.GetDBSQLDialect: Integer;
var
  DatabaseInfo: TIBDatabaseInfo;
begin
  DatabaseInfo := TIBDatabaseInfo.Create(self);
  DatabaseInfo.Database := self;
  result := DatabaseInfo.DBSQLDialect;
  DatabaseInfo.Free;
end;

procedure TIBDatabase.ValidateClientSQLDialect;
begin
  if (FDBSQLDialect < FSQLDialect) then
  begin
    FSQLDialect := FDBSQLDialect;
    if Assigned (FOnDialectDowngradeWarning) then
      FOnDialectDowngradeWarning(self);
  end;
end;

procedure TIBDatabase.ApplyUpdates(const DataSets: array of TDataSet);
var
  I: Integer;
  DS: TIBCustomDataSet;
  TR: TIBTransaction;
begin
  TR := nil;
  for I := 0 to High(DataSets) do
  begin
    DS := TIBCustomDataSet(DataSets[I]);
    if DS.Database <> Self then
      IBError(ibxeUpdateWrongDB, [nil]);
    if TR = nil then
      TR := DS.Transaction;
    if (DS.Transaction <> TR) or (TR = nil) then
      IBError(ibxeUpdateWrongTR, [nil]);
  end;
  TR.CheckInTransaction;
  for I := 0 to High(DataSets) do
  begin
    DS := TIBCustomDataSet(DataSets[I]);
    DS.ApplyUpdates;
  end;
  TR.CommitRetaining;
end;

procedure TIBDatabase.CloseDataSets;
var
  i: Integer;
begin
  for i := 0 to DataSetCount - 1 do
    if (DataSets[i] <> nil) then
      DataSets[i].close;
end;

procedure TIBDatabase.GetFieldNames(const TableName: string; List: TStrings);
var
  Query: TIBSQL;
begin
  if TableName = '' then
    IBError(ibxeNoTableName, [nil]);
  if not Connected then
    Open;
  if not FInternalTransaction.Active then
    FInternalTransaction.StartTransaction;
  Query := TIBSQL.Create(self);
  try
    Query.GoToFirstRecordOnExecute := False;
    Query.Database := Self;
    Query.Transaction := FInternalTransaction;
    Query.SQL.Text := 'Select R.RDB$FIELD_NAME ' + {do not localize}
      'from RDB$RELATION_FIELDS R, RDB$FIELDS F ' + {do not localize}
      'where R.RDB$RELATION_NAME = ' + {do not localize}
      '''' +
      FormatIdentifierValue(SQLDialect, QuoteIdentifier(SQLDialect, TableName)) +
      ''' ' +
      'and R.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME ' + {do not localize}
      'ORDER BY RDB$FIELD_POSITION'; {do not localize}
    Query.Prepare;
    Query.ExecQuery;
    with List do
    begin
      BeginUpdate;
      try
        Clear;
        while (not Query.EOF) and (Query.Next <> nil) do
          List.Add(TrimRight(Query.Current.ByName('RDB$FIELD_NAME').AsString)); {do not localize}
      finally
        EndUpdate;
      end;
    end;
  finally
    Query.free;
    FInternalTransaction.Commit;
  end;
end;

procedure TIBDatabase.GetTableNames(List: TStrings; SystemTables: Boolean);
var
  Query : TIBSQL;
begin
  if not (csReading in ComponentState) then
  begin
    if not Connected then
      Open;
    if not FInternalTransaction.Active then
      FInternalTransaction.StartTransaction;
    Query := TIBSQL.Create(self);
    try
      Query.GoToFirstRecordOnExecute := False;
      Query.Database := Self;
      Query.Transaction := FInternalTransaction;
      if SystemTables then
        Query.SQL.Text := 'Select RDB$RELATION_NAME from RDB$RELATIONS ' + {do not localize}
                          ' where RDB$VIEW_BLR is NULL ' + {do not localize}
                          'ORDER BY RDB$RELATION_NAME' {do not localize}
      else
        Query.SQL.Text := 'Select RDB$RELATION_NAME from RDB$RELATIONS ' + {do not localize}
                          ' where RDB$VIEW_BLR is NULL and RDB$SYSTEM_FLAG = 0 ' + {do not localize}
                          'ORDER BY RDB$RELATION_NAME'; {do not localize}
      Query.Prepare;
      Query.ExecQuery;
      with List do
      begin
        BeginUpdate;
        try
          Clear;
          while (not Query.EOF) and (Query.Next <> nil) do
            List.Add(TrimRight(Query.Current[0].AsString));
        finally
          EndUpdate;
        end;
      end;
    finally
      Query.Free;
      FInternalTransaction.Commit;
    end;
  end;
end;

procedure TIBDataBase.AddEventNotifier(Notifier: IIBEventNotifier);
begin
  FEventNotifiers.Add(Pointer(Notifier));
end;

procedure TIBDataBase.RemoveEventNotifier(Notifier: IIBEventNotifier);
var
  Index : Integer;
begin
  Index := FEventNotifiers.IndexOf(Pointer(Notifier));
  if Index >= 0 then
    FEventNotifiers.Delete(Index);
end;

function TIBDataBase.In_Key(Relation, Field: String): Boolean;
begin
  Result := FSchema.In_Key(Relation, Field);
end;

function TIBDataBase.Has_COMPUTED_BLR(Relation, Field: String): Boolean;
begin
  Result := FSchema.Has_COMPUTED_BLR(Relation, Field);
end;

function TIBDataBase.Has_DEFAULT_VALUE(Relation, Field: String): Boolean;
begin
  Result := FSchema.Has_DEFAULT_VALUE(Relation, Field);
end;

procedure TIBDataBase.FlushSchema;
begin
  FSchema.FreeNodes;
end;

{ TIBTransaction }

constructor TIBTransaction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGDSLibrary := GetGDSLibrary;
  FIBLoaded := False;
  FGDSLibrary.CheckIBLoaded;
  FIBLoaded := True;
  FDatabases := TList.Create;
  FSQLObjects := TList.Create;
  FHandle := nil;
  FTPB := nil;
  FTPBLength := 0;
  FTRParams := TStringList.Create;
  FTRParamsChanged := True;
  TStringList(FTRParams).OnChange := TRParamsChange;
  TStringList(FTRParams).OnChanging := TRParamsChanging;
  FDefaultAction := taCommit;
  FAllowAutoStart := true;
  FTransactionID := 0;
end;

destructor TIBTransaction.Destroy;
var
  i: Integer;
begin
  if FIBLoaded then
  begin
    if InTransaction then
      case FDefaultAction of
        TACommit, TACommitRetaining :
          EndTransaction(TACommit, True);
        TARollback, TARollbackRetaining :
          EndTransaction(TARollback, True);
      end;
    for i := 0 to FSQLObjects.Count - 1 do
      if FSQLObjects[i] <> nil then
        SQLObjects[i].DoTransactionFree;
    RemoveSQLObjects;
    RemoveDatabases;
    FreeMem(FTPB);
    FTPB := nil;
    FTRParams.Free;
    FSQLObjects.Free;
    FDatabases.Free;
  end;
  FGDSLibrary := nil;
  inherited Destroy;
end;

function TIBTransaction.Call(ErrCode: ISC_STATUS;
  RaiseError: Boolean): ISC_STATUS;
var
  i: Integer;
begin
  result := ErrCode;
  for i := 0 to FDatabases.Count - 1 do if FDatabases[i] <> nil then
    Databases[i].FCanTimeout := False;
  FCanTimeout := False;
  {Handle when the Error is due to a Database disconnect.  Pass it on to
   FDatabase so it can handle this}
  if CheckStatusVector([isc_lost_db_connection]) then
    FDefaultDatabase.Call(ErrCode, RaiseError)
  else
    if RaiseError and (result > 0) then
      IBDataBaseError;
end;

procedure TIBTransaction.CheckDatabasesInList;
begin
  if GetDatabaseCount = 0 then
    IBError(ibxeNoDatabasesInTransaction, [nil]);
end;

procedure TIBTransaction.CheckInTransaction;
begin
  if FStreamedActive and (not InTransaction) then
    Loaded;
  if (FHandle = nil) then
    IBError(ibxeNotInTransaction, [nil]);
end;

procedure TIBTransaction.EnsureNotInTransaction;
begin
  if csDesigning in ComponentState then
  begin
    if FHandle <> nil then
      Rollback;
  end;
end;

procedure TIBTransaction.CheckNotInTransaction;
begin
  if (FHandle <> nil) then
    IBError(ibxeInTransaction, [nil]);
end;

procedure TIBTransaction.CheckAutoStop;
var
  i: Integer;
  AllClosed : Boolean;
begin
  if (FAutoStopAction = saNone) or (not InTransaction) or (not FAutoStarted)  then
    exit;
  AllClosed := true;
  i := 0;
  while AllClosed and (i < FSQLObjects.Count) do
  begin
    if FSQLObjects[i] <> nil then
    begin
      if (TIBBase(FSQLObjects[i]).owner is TIBCustomDataSet) then
        AllClosed := not TIBCustomDataSet(TIBBase(FSQLObjects[i]).owner).Active
    end;
    Inc(i);
  end;
  if AllClosed then
    case FAutoStopAction of
      saRollback : EndTransaction(TARollBack, false);
      saCommit : EndTransaction(TACommit, false);
      saRollbackRetaining : EndTransaction(TARollbackRetaining, false);
      saCommitRetaining : EndTransaction(TACommitRetaining, false);
    end;
end;

function TIBTransaction.AddDatabase(db: TIBDatabase): Integer;
var
  i: Integer;
  NilFound: Boolean;
begin
  i := FindDatabase(db);
  if i <> -1 then
  begin
    result := i;
    exit;
  end;
  NilFound := False;
  i := 0;
  while (not NilFound) and (i < FDatabases.Count) do
  begin
    NilFound := (FDatabases[i] = nil);
    if (not NilFound) then
      Inc(i);
  end;
  if (NilFound) then
  begin
    FDatabases[i] := db;
    result := i;
  end
  else
  begin
    result := FDatabases.Count;
    FDatabases.Add(db);
  end;
end;

function TIBTransaction.AddSQLObject(ds: TIBBase): Integer;
begin
  result := 0;
  while (result < FSQLObjects.Count) and (FSQLObjects[result] <> nil) do
    Inc(result);
  if (result = FSQLObjects.Count) then
    FSQLObjects.Add(ds)
  else
    FSQLObjects[result] := ds;
end;

procedure TIBTransaction.Commit;
begin
  EndTransaction(TACommit, False);
end;

procedure TIBTransaction.CommitRetaining;
begin
  EndTransaction(TACommitRetaining, False);
end;

procedure TIBTransaction.EndTransaction(Action: TIBTransactionAction;
  Force: Boolean);
var
  status: ISC_STATUS;
  i: Integer;
  OldAutoStop : TAutoStopAction;

begin
  CheckInTransaction;
  case Action of
    TARollback, TACommit:
    begin
      if (HandleIsShared) and
         (Action <> FDefaultAction) and
         (not Force) then
        IBError(ibxeCantEndSharedTransaction, [nil]);
      OldAutoStop := FAutoStopAction;
      FAutoStopAction := saNone;
      try
        for i := 0 to FSQLObjects.Count - 1 do
          if FSQLObjects[i] <> nil then
            SQLObjects[i].DoBeforeTransactionEnd;
      finally
        FAutoStopAction := OldAutoStop;
      end;
      if InTransaction then
      begin
        if HandleIsShared then
        begin
          FHandle := nil;
          FHandleIsShared := False;
          status := 0;
        end
        else
          if (Action = TARollback) then
            status := Call(FGDSLibrary.isc_rollback_transaction(StatusVector, @FHandle), False)
          else
            status := Call(FGDSLibrary.isc_commit_transaction(StatusVector, @FHandle), False);
        if ((Force) and (status > 0)) then
          status := Call(FGDSLibrary.isc_rollback_transaction(StatusVector, @FHandle), False);
        if Force then
          FHandle := nil
        else
          if (status > 0) then
          try
            IBDataBaseError;
          except
            on E : EIBError do
            begin
              if (E.SQLCode = -902) and (E.IBErrorCode = 335544721) then
                DefaultDatabase.ForceClose;
              raise;
            end;
          end;
        for i := 0 to FSQLObjects.Count - 1 do if FSQLObjects[i] <> nil then
          SQLObjects[i].DoAfterTransactionEnd;
      end;
      FTransactionID := 0;
    end;
    TACommitRetaining:
      Call(FGDSLibrary.isc_commit_retaining(StatusVector, @FHandle), True);
    TARollbackRetaining:
      Call(FGDSLibrary.isc_rollback_retaining(StatusVector, @FHandle), True);
  end;
  if (not (csDesigning in ComponentState)) and (MonitorHook <> nil) then
  begin
    case Action of
      TACommit:
        MonitorHook.TRCommit(Self);
      TARollback:
        MonitorHook.TRRollback(Self);
      TACommitRetaining:
        MonitorHook.TRCommitRetaining(Self);
      TARollbackRetaining:
        MonitorHook.TRRollbackRetaining(Self);
    end;
  end;
  if not Active then
  begin
    FAutoStarted := FALSE;
  end;
end;

function TIBTransaction.GetDatabase(Index: Integer): TIBDatabase;
begin
  result := FDatabases[Index];
end;

function TIBTransaction.GetDatabaseCount: Integer;
var
  i, Cnt: Integer;
begin
  result := 0;
  Cnt := FDatabases.Count - 1;
  for i := 0 to Cnt do if FDatabases[i] <> nil then
    Inc(result);
end;

function TIBTransaction.GetSQLObject(Index: Integer): TIBBase;
begin
  result := FSQLObjects[Index];
end;

function TIBTransaction.GetSQLObjectCount: Integer;
var
  i, Cnt: Integer;
begin
  result := 0;
  Cnt := FSQLObjects.Count - 1;
  for i := 0 to Cnt do if FSQLObjects[i] <> nil then
    Inc(result);
end;

function TIBTransaction.GetInTransaction: Boolean;
begin
  result := (FHandle <> nil);
end;

function TIBTransaction.FindDatabase(db: TIBDatabase): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to FDatabases.Count - 1 do
    if db = TIBDatabase(FDatabases[i]) then
    begin
      result := i;
      break;
    end;
end;

function TIBTransaction.FindDefaultDatabase: TIBDatabase;
var
  i: Integer;
begin
  result := FDefaultDatabase;
  if result = nil then
  begin
    for i := 0 to FDatabases.Count - 1 do
      if (TIBDatabase(FDatabases[i]) <> nil) and
        (TIBDatabase(FDatabases[i]).DefaultTransaction = self) then
      begin
        result := TIBDatabase(FDatabases[i]);
        break;
      end;
  end;
end;


function TIBTransaction.GetIdleTimer: Integer;
begin
  if Assigned(FTimer) then
    Result := FTimer.Interval
  else
    Result := 0;
end;

procedure TIBTransaction.Loaded;
begin
  inherited Loaded;
end;

procedure TIBTransaction.BeforeDatabaseDisconnect(DB: TIBDatabase);
begin
  if InTransaction then
    case FDefaultAction of
      TACommit, TACommitRetaining :
        EndTransaction(TACommit, True);
      TARollback, TARollbackRetaining :
        EndTransaction(TARollback, True);
    end;
end;

procedure TIBTransaction.RemoveDatabase(Idx: Integer);
var
  DB: TIBDatabase;
begin
  if ((Idx >= 0) and (FDatabases[Idx] <> nil)) then
  begin
    DB := Databases[Idx];
    FDatabases[Idx] := nil;
    DB.RemoveTransaction(DB.FindTransaction(Self));
    if DB = FDefaultDatabase then
      FDefaultDatabase := nil;
  end;
end;

procedure TIBTransaction.RemoveDatabases;
var
  i: Integer;
begin
  for i := 0 to FDatabases.Count - 1 do if FDatabases[i] <> nil then
    RemoveDatabase(i);
end;

procedure TIBTransaction.RemoveSQLObject(Idx: Integer);
var
  ds: TIBBase;
begin
  if ((Idx >= 0) and (FSQLObjects[Idx] <> nil)) then
  begin
    ds := SQLObjects[Idx];
    FSQLObjects[Idx] := nil;
    ds.Transaction := nil;
  end;
end;

procedure TIBTransaction.RemoveSQLObjects;
var
  i: Integer;
begin
  for i := 0 to FSQLObjects.Count - 1 do if FSQLObjects[i] <> nil then
    RemoveSQLObject(i);
end;

procedure TIBTransaction.Rollback;
begin
  EndTransaction(TARollback, False);
end;

procedure TIBTransaction.RollbackRetaining;
begin
  EndTransaction(TARollbackRetaining, False);
end;

procedure TIBTransaction.SetActive(Value: Boolean);
begin
  if csReading in ComponentState then
    FStreamedActive := Value
  else
    if Value and not InTransaction then
      StartTransaction
    else
      if not Value and InTransaction then
        Rollback;
end;

procedure TIBTransaction.SetDefaultAction(Value: TIBTransactionAction);
begin
  if (Value = taRollbackRetaining) and (FGDSLibrary.GetIBClientVersion < 6) then
    IBError(ibxeIB60feature, [nil]);
  FDefaultAction := Value;
end;

procedure TIBTransaction.SetDefaultDatabase(Value: TIBDatabase);
var
  i: integer;
begin
  if (FDefaultDatabase <> nil) and (FDefaultDatabase <> Value) then
  begin
    i := FDefaultDatabase.FindTransaction(self);
    if (i <> -1) then
      FDefaultDatabase.RemoveTransaction(i);
  end;
  if (Value <> nil) and (FDefaultDatabase <> Value) then
  begin
    Value.AddTransaction(Self);
    AddDatabase(Value);
    for i := 0 to FSQLObjects.Count - 1 do
      if (FSQLObjects[i] <> nil) and
         (TIBBase(FSQLObjects[i]).Database = nil) then
        SetOrdProp(TIBBase(FSQLObjects[i]).Owner, 'Database', Integer(Value));
  end;
  FDefaultDatabase := Value;
end;

procedure TIBTransaction.SetHandle(Value: TISC_TR_HANDLE);
begin
  if (HandleIsShared) then
    case FDefaultAction of
      TACommit, TACommitRetaining :
        EndTransaction(TACommit, True);
      TARollback, TARollbackRetaining :
        EndTransaction(TARollback, True);
    end
  else
    CheckNotInTransaction;
  FHandle := Value;
  FHandleIsShared := (Value <> nil);
end;

procedure TIBTransaction.Notification( AComponent: TComponent;
                                        Operation: TOperation);
var
  i: Integer;
begin
  inherited Notification( AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDefaultDatabase) then
  begin
    i := FindDatabase(FDefaultDatabase);
    if (i <> -1) then
      RemoveDatabase(i);
    FDefaultDatabase := nil;
  end;
end;

procedure TIBTransaction.SetIdleTimer(Value: Integer);
begin
  if Value < 0 then
    IBError(ibxeTimeoutNegative, [nil])
  else
    if (Value = 0) then
      FreeAndNil(FTimer)
    else
      if (Value > 0) then
      begin
        if not Assigned(FTimer) then
        begin
          FTimer := TIBTimer.Create(Self);
          FTimer.Enabled := False;
          FTimer.Interval := 0;
          FTimer.OnTimer := TimeoutTransaction;
        end;
        FTimer.Interval := Value;
        if not (csDesigning in ComponentState) then
          FTimer.Enabled := True;
      end;
end;

procedure TIBTransaction.SetTRParams(Value: TStrings);
begin
  FTRParams.Assign(Value);
end;

procedure TIBTransaction.StartTransaction;
var
  pteb: PISC_TEB_ARRAY;
  TPB: String;
  i: Integer;
begin
  CheckNotInTransaction;
  CheckDatabasesInList;
  for i := 0 to FDatabases.Count - 1 do
   if  FDatabases[i] <> nil then
   begin
     with TIBDatabase(FDatabases[i]) do
     if not Connected then
       if StreamedConnected then
       begin
         Open;
         StreamedConnected := False;
       end
       else
         IBError(ibxeDatabaseClosed, [nil]);
   end;
  if FTRParamsChanged then
  begin
    FTRParamsChanged := False;
    GenerateTPB(FTRParams, TPB, FTPBLength);
    if FTPBLength > 0 then
    begin
      IBAlloc(FTPB, 0, FTPBLength);
      Move(TPB[1], FTPB[0], FTPBLength);
    end;
  end;

  pteb := nil;
  IBAlloc(pteb, 0, DatabaseCount * SizeOf(TISC_TEB));
  try
    for i := 0 to DatabaseCount - 1 do if Databases[i] <> nil then
    begin
      pteb^[i].db_handle := @(Databases[i].Handle);
      pteb^[i].tpb_length := FTPBLength;
      pteb^[i].tpb_address := FTPB;
    end;
    if Call(FGDSLibrary.isc_start_multiple(StatusVector, @FHandle,
                               DatabaseCount, PISC_TEB(pteb)), False) > 0 then
    begin
      FHandle := nil;
      IBDataBaseError;
    end;
    if (not (csDesigning in ComponentState)) and (MonitorHook <> nil) then
      MonitorHook.TRStart(Self);
  finally
    FreeMem(pteb);
  end;
end;

procedure TIBTransaction.TimeoutTransaction(Sender: TObject);
begin
  if InTransaction then
  begin
    if FCanTimeout then
    begin
      EndTransaction(FDefaultAction, True);
      FCanTimeout := True;
      if Assigned(FOnIdleTimer) then
        FOnIdleTimer(Self);
    end
    else
      FCanTimeout := True;
  end;
end;

procedure TIBTransaction.TRParamsChange(Sender: TObject);
begin
  FTRParamsChanged := True;
end;

procedure TIBTransaction.TRParamsChanging(Sender: TObject);
begin
  EnsureNotInTransaction;
  CheckNotInTransaction;
end;

procedure TIBTransaction.AutoStartTransaction;
begin
  if AllowAutoStart or (csDesigning in ComponentState) then
  begin
    StartTransaction;
    FAutoStarted := true;
  end;
end;

procedure TIBTransaction.ReleaseSavepoint(Name: String);
begin
  CheckInTransaction;
  Call(FGDSLibrary.isc_release_savepoint(StatusVector, @FHandle,
                               PChar(Name)), False);
end;

procedure TIBTransaction.RollbackSavepoint(Name: String);
begin
  CheckInTransaction;
  Call(FGDSLibrary.isc_rollback_savepoint(StatusVector, @FHandle,
                               PChar(Name), 0), False);
end;

procedure TIBTransaction.StartSavepoint(Name: String);
begin
  CheckInTransaction;
  Call(FGDSLibrary.isc_start_savepoint(StatusVector, @FHandle,
                               PChar(Name)), False);
end;

function TIBTransaction.GetTransactionID: integer;
var
  length: Integer;
  result_buffer: array[0..31] of char;
  _TransactionInfoCommand: Char;
begin
  CheckInTransaction;
  if FTransactionID = 0 then
  begin
    _TransactionInfoCommand := Char(isc_info_tra_id);
    Call(FGDSLibrary.isc_transaction_info(StatusVector, @Handle, 1,
        @_TransactionInfoCommand, 32, result_buffer), True);
    length := FGDSLibrary.isc_vax_integer(@result_buffer[1], 2);
    FTransactionID := FGDSLibrary.isc_vax_integer(@result_buffer[3], length);
  end;
  Result := FTransactionID;
end;

{ TIBBase }
constructor TIBBase.Create(AOwner: TObject);
begin
  FOwner := AOwner;
end;

destructor TIBBase.Destroy;
begin
  SetDatabase(nil);
  SetTransaction(nil);
  inherited Destroy;
end;

procedure TIBBase.CheckDatabase;
begin
  if (FDatabase = nil) then
    IBError(ibxeDatabaseNotAssigned, [nil]);
  FDatabase.CheckActive;
end;

procedure TIBBase.CheckTransaction;
begin
  if FTransaction = nil then
    IBError(ibxeTransactionNotAssigned, [nil]);
  FTransaction.CheckInTransaction;
end;

function TIBBase.GetDBHandle: PISC_DB_HANDLE;
begin
  CheckDatabase;
  result := @FDatabase.Handle;
end;

function TIBBase.GetTRHandle: PISC_TR_HANDLE;
begin
  CheckTransaction;
  result := @FTransaction.Handle;
end;

procedure TIBBase.DoBeforeDatabaseDisconnect;
begin
  if Assigned(BeforeDatabaseDisconnect) then
    BeforeDatabaseDisconnect(Self);
end;

procedure TIBBase.DoAfterDatabaseDisconnect;
begin
  if Assigned(AfterDatabaseDisconnect) then
    AfterDatabaseDisconnect(Self);
end;

procedure TIBBase.DoDatabaseFree;
begin
  if Assigned(OnDatabaseFree) then
    OnDatabaseFree(Self);
  SetDatabase(nil);
end;

procedure TIBBase.DoBeforeTransactionEnd;
begin
  if Assigned(BeforeTransactionEnd) then
    BeforeTransactionEnd(Self);
end;

procedure TIBBase.DoAfterTransactionEnd;
begin
  if Assigned(AfterTransactionEnd) then
    AfterTransactionEnd(Self);
end;

procedure TIBBase.DoTransactionFree;
begin
  if Assigned(OnTransactionFree) then
    OnTransactionFree(Self);
  SetTransaction(nil);
end;

procedure TIBBase.SetDatabase(Value: TIBDatabase);
begin
  if (FDatabase <> nil) then
    FDatabase.RemoveSQLObject(FIndexInDatabase);
  FDatabase := Value;
  if (FDatabase <> nil) then
  begin
    FIndexInDatabase := FDatabase.AddSQLObject(Self);
    if (FTransaction = nil) then
      Transaction := FDatabase.FindDefaultTransaction;
  end;
end;

procedure TIBBase.SetTransaction(Value: TIBTransaction);
begin
  if (FTransaction <> nil) then
    FTransaction.RemoveSQLObject(FIndexInTransaction);
  FTransaction := Value;
  if (FTransaction <> nil) then
  begin
    FIndexInTransaction := FTransaction.AddSQLObject(Self);
    if (FDatabase = nil) then
      Database := FTransaction.FindDefaultDatabase;
  end;
end;

{ GenerateDPB -
  Given a string containing a textual representation
  of the database parameters, generate a database
  parameter buffer, and return it and its length
  in DPB and DPBLength, respectively. }

procedure GenerateDPB(sl: TStrings; var DPB: string; var DPBLength: Short);
var
  i, j, pval: Integer;
  DPBVal: UShort;
  ParamName, ParamValue: string;
begin
  { The DPB is initially empty, with the exception that
    the DPB version must be the first byte of the string. }
  DPBLength := 1;
  DPB := Char(isc_dpb_version1);

  {Iterate through the textual database parameters, constructing
   a DPB on-the-fly }
  for i := 0 to sl.Count - 1 do
  begin
    { Get the parameter's name and value from the list,
      and make sure that the name is all lowercase with
      no leading 'isc_dpb_' prefix
    }
    if (Trim(sl.Names[i]) = '') then
      continue;
    ParamName := LowerCase(sl.Names[i]); {mbcs ok}
    ParamValue := Copy(sl[i], Pos('=', sl[i]) + 1, Length(sl[i])); {mbcs ok}  {do not localize}
    if (Pos(DPBPrefix, ParamName) = 1) then {mbcs ok}
      Delete(ParamName, 1, Length(DPBPrefix));
     { We want to translate the parameter name to some Integer
       value. We do this by scanning through a list of known
       database parameter names (DPBConstantNames, defined above) }
    DPBVal := 0;
    { Find the parameter }
    for j := 1 to isc_dpb_last_dpb_constant do
      if (ParamName = DPBConstantNames[j]) then
      begin
        DPBVal := j;
        break;
      end;
     {  A database parameter either contains a string value (case 1)
       or an Integer value (case 2)
       or no value at all (case 3)
       or an error needs to be generated (case else)  }
    case DPBVal of
      isc_dpb_user_name, isc_dpb_password, isc_dpb_password_enc,
      isc_dpb_sys_user_name, isc_dpb_license, isc_dpb_encrypt_key,
      isc_dpb_lc_messages, isc_dpb_lc_ctype, isc_dpb_sql_role_name,
      isc_dpb_sql_dialect, isc_dpb_instance_name, isc_dpb_old_file_name:
      begin
        if DPBVal = isc_dpb_sql_dialect then
          ParamValue[1] := Char(Ord(ParamValue[1]) - 48);
        DPB := DPB + Char(DPBVal) + Char(Length(ParamValue)) + ParamValue;
        Inc(DPBLength, 2 + Length(ParamValue));
      end;
      isc_dpb_num_buffers, isc_dpb_dbkey_scope, isc_dpb_force_write,
      isc_dpb_no_reserve, isc_dpb_damaged, isc_dpb_verify,
      isc_dpb_online_dump, isc_dpb_overwrite, isc_dpb_old_file_size:
      begin
        DPB := DPB + Char(DPBVal) + #1 + Char(StrToInt(ParamValue));
        Inc(DPBLength, 3);
      end;
      isc_dpb_sweep:
      begin
        DPB := DPB + Char(DPBVal) + #1 + Char(isc_dpb_records);
        Inc(DPBLength, 3);
      end;
      isc_dpb_sweep_interval:
      begin
        pval := StrToInt(ParamValue);
        DPB := DPB + Char(DPBVal) + #4 + PChar(@pval)[0] + PChar(@pval)[1] +
               PChar(@pval)[2] + PChar(@pval)[3];
        Inc(DPBLength, 6);
      end;
      isc_dpb_activate_shadow, isc_dpb_delete_shadow, isc_dpb_begin_log,
      isc_dpb_quit_log:
      begin
        DPB := DPB + Char(DPBVal) + #1 + #0;
        Inc(DPBLength, 3);
      end;
      else
      begin
        if (DPBVal > 0) and
           (DPBVal <= isc_dpb_last_dpb_constant) then
          IBError(ibxeDPBConstantNotSupported, [DPBConstantNames[DPBVal]])
        else
          IBError(ibxeDPBConstantUnknownEx, [sl.Names[i]]);
      end;
    end;
  end;
end;

{ GenerateTPB -
  Given a string containing a textual representation
  of the transaction parameters, generate a transaction
  parameter buffer, and return it and its length in
  TPB and TPBLength, respectively. }
procedure GenerateTPB(sl: TStrings; var TPB: string; var TPBLength: Short);
var
  i, j, TPBVal, ParamLength: Integer;
  ParamName, ParamValue: string;
begin
  TPB := '';
  if (sl.Count = 0) then
    TPBLength := 0
  else
  begin
    TPBLength := sl.Count + 1;
    TPB := TPB + Char(isc_tpb_version3);
  end;
  for i := 0 to sl.Count - 1 do
  begin
    if (Trim(sl[i]) =  '') then
    begin
      Dec(TPBLength);
      Continue;
    end;
    if (Pos('=', sl[i]) = 0) then {mbcs ok}    {do not localize}
      ParamName := LowerCase(sl[i]) {mbcs ok}
    else
    begin
      ParamName := LowerCase(sl.Names[i]); {mbcs ok}
      ParamValue := Copy(sl[i], Pos('=', sl[i]) + 1, Length(sl[i])); {mbcs ok}  {do not localize}
    end;
    if (Pos(TPBPrefix, ParamName) = 1) then {mbcs ok}
      Delete(ParamName, 1, Length(TPBPrefix));
    TPBVal := 0;
    { Find the parameter }
    for j := 1 to isc_tpb_last_tpb_constant do
      if (ParamName = TPBConstantNames[j]) then
      begin
        TPBVal := j;
        break;
      end;
    { Now act on it }
    case TPBVal of
      isc_tpb_consistency, isc_tpb_exclusive, isc_tpb_protected,
      isc_tpb_concurrency, isc_tpb_shared, isc_tpb_wait, isc_tpb_nowait,
      isc_tpb_read, isc_tpb_write, isc_tpb_ignore_limbo,
      isc_tpb_read_committed, isc_tpb_rec_version, isc_tpb_no_rec_version,
      isc_tpb_restart_requests, isc_tpb_no_auto_undo, isc_tpb_no_savepoint :
        TPB := TPB + Char(TPBVal);
      isc_tpb_lock_read, isc_tpb_lock_write:
      begin
        TPB := TPB + Char(TPBVal);
        { Now set the string parameter }
        ParamLength := Length(ParamValue);
        Inc(TPBLength, ParamLength + 1);
        TPB := TPB + Char(ParamLength) + ParamValue;
      end;
      else
      begin
        if (TPBVal > 0) and
           (TPBVal <= isc_tpb_last_tpb_constant) then
          IBError(ibxeTPBConstantNotSupported, [TPBConstantNames[TPBVal]])
        else
          IBError(ibxeTPBConstantUnknownEx, [sl.Names[i]]);
      end;
    end;
  end;
end;

{ TSchema }

function TSchema.Add_Node(Relation, Field : String) : TFieldNode;
var
  FField : TFieldNode;
  FFieldList : TStringList;
  DidActivate : Boolean;
  i : Integer;
begin
  FFieldList := TStringList.Create;
  FRelations.AddObject(Relation, FFieldList);
  Result := nil;

  DidActivate := not FQuery.Database.InternalTransaction.InTransaction;
  if DidActivate then
    FQuery.Database.InternalTransaction.StartTransaction;
  FQuery.Params[0].AsString := Relation;
  FQuery.ExecQuery;
  while not FQuery.Eof do
  begin
    FField := TFieldNode.Create;
    FField.FieldName := FQuery.Fields[3].AsTrimString;
    FField.DEFAULT_VALUE := not (FQuery.Fields[1].IsNull and FQuery.Fields[2].IsNull);
    FField.COMPUTED_BLR := not FQuery.Fields[0].IsNull;
    FField.In_Key := false;
    FFieldList.AddObject(FField.FieldName, FField);
    if FField.FieldName = Field then
      Result := FField;
    FQuery.Next;
  end;
  FQuery.Close;

  FPQuery.Params[0].AsString := Relation;
  FPQuery.ExecQuery;
  while not FPQuery.Eof do
  begin
    i := FFieldList.IndexOf(FPQuery.Fields[0].AsTrimString);
    if i < 0 then
    begin
      FField := TFieldNode.Create;
      FField.FieldName := FPQuery.Fields[0].AsTrimString;
      FField.DEFAULT_VALUE := false;
      FField.COMPUTED_BLR := false;
      FField.In_Key := true;
      FFieldList.AddObject(FField.FieldName, FField);
      if FField.FieldName = Field then
        Result := FField;
    end
    else
      TFieldNode(FFieldList.Objects[i]).In_Key := true;
    FPQuery.Next;
  end;

  FPQuery.Close;

  if DidActivate then
    FQuery.Database.InternalTransaction.Commit;
end;

constructor TSchema.Create(ADatabase : TIBDatabase);
const
  SDefaultSQL = 'Select F.RDB$COMPUTED_BLR, ' + {do not localize}
                'F.RDB$DEFAULT_VALUE, R.RDB$DEFAULT_VALUE, R.RDB$FIELD_NAME ' + {do not localize}
                'from RDB$RELATION_FIELDS R, RDB$FIELDS F ' + {do not localize}
                'where R.RDB$RELATION_NAME = :RELATION ' +  {do not localize}
                'and R.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME '+ {do not localize}
                'and ((not F.RDB$COMPUTED_BLR is NULL) or ' + {do not localize}
                '     (not (F.RDB$DEFAULT_VALUE is NULL and R.RDB$DEFAULT_VALUE is NULL))) '; {do not localize}
  SPrimaryKey = 'SELECT RDB$FIELD_NAME, RDB$FIELD_POSITION ' + {do not localize}
                'FROM RDB$RELATION_CONSTRAINTS RR JOIN RDB$INDEX_SEGMENTS RI ON ' + {do not localize}
                '     RR.RDB$INDEX_NAME = RI.RDB$INDEX_NAME ' + {do not localize}
                'WHERE RDB$RELATION_NAME = :relation_name AND ' + {do not localize}
                '      RDB$CONSTRAINT_TYPE = ''PRIMARY KEY '' ' + {do not localize}
                'ORDER BY RDB$FIELD_POSITION '; {do not localize}
begin
  FRelations := TStringList.Create;
  FQuery := TIBSQL.Create(ADatabase);
  FQuery.Transaction := ADatabase.InternalTransaction;
  FQuery.SQL.Text := SDefaultSQL;
  FPQuery := TIBSQL.Create(ADatabase);
  FPQuery.Transaction := ADatabase.InternalTransaction;
  FPQuery.SQL.Text := SPrimaryKey;
end;

destructor TSchema.Destroy;
begin
  FreeNodes;
  FRelations.Free;
  FQuery.Free;
  FPQuery.Free;
  inherited;
end;

procedure TSchema.FreeNodes;
var
  FFieldList : TStringList;
  i, j : Integer;
begin
  for i := FRelations.Count - 1 downto 0 do
  begin
    FFieldList := TStringList(FRelations.Objects[i]);
    for j := FFieldList.Count - 1 downto 0 do
      TFieldNode(FFieldList.Objects[j]).Free;
    FFieldList.Free;
    FRelations.Delete(i);
  end;
end;

function TSchema.Has_COMPUTED_BLR(Relation, Field: String): Boolean;
var
  FRelationList : TStringList;
  FField : TFieldNode;
  i : Integer;
begin
  i := FRelations.IndexOf(Relation);
  FField := nil;
  if i >= 0 then
  begin
    FRelationList := TStringList(FRelations.Objects[i]);
    i := FRelationList.IndexOf(Field);
    if i >= 0 then
      FField := TFieldNode(FRelationList.Objects[i]);
  end
  else
    FField := Add_Node(Relation, Field);
  if Assigned(FField) then
    Result := Ffield.COMPUTED_BLR
  else
    Result := false;
end;

function TSchema.Has_DEFAULT_VALUE(Relation, Field: String): Boolean;
var
  FRelationList : TStringList;
  FField : TFieldNode;
  i : Integer;
begin
  i := FRelations.IndexOf(Relation);
  FField := nil;
  if i >= 0 then
  begin
    FRelationList := TStringList(FRelations.Objects[i]);
    i := FRelationList.IndexOf(Field);
    if i >= 0 then
      FField := TFieldNode(FRelationList.Objects[i]);
  end
  else
    FField := Add_Node(Relation, Field);
  if Assigned(FField) then
    Result := Ffield.DEFAULT_VALUE
  else
    Result := false;
end;

function TSchema.In_Key(Relation, Field: String): Boolean;
var
  FRelationList : TStringList;
  FField : TFieldNode;
  i : Integer;
begin
  i := FRelations.IndexOf(Relation);
  FField := nil;
  if i >= 0 then
  begin
    FRelationList := TStringList(FRelations.Objects[i]);
    i := FRelationList.IndexOf(Field);
    if i >= 0 then
      FField := TFieldNode(FRelationList.Objects[i]);
  end
  else
    FField := Add_Node(Relation, Field);
  if Assigned(FField) then
    Result := Ffield.In_Key
  else
    Result := false;
end;

end.

