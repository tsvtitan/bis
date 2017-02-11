unit BisCmxConnection;

interface

uses Windows, Classes, Contnrs, DB, Variants,
     SqlExpr, DBXCommon, Forms, Controls, 
     BisObject, BisConnectionModules, BisCore,
     BisDataSet, BisConfig, BisProfile, BisInterfaces,
     BisParams, BisParam, BisIfaces, BisMenus, BisTasks,
     BisConnections, BisPermissions, BisLogger, BisAlarmsFm;

type
  TBisCmxConnection=class;
  TBisCmxSessions=class;

  TBisCmxProc=class(TSQLStoredProc)
  private
    FSParamPrefix: String;
    FCacheEnabled: Boolean;
    procedure SetNullToParamValues;
  protected
    procedure SetCommandText(const Value: WideString); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CopyParamsFrom(Source: TBisParams);
    procedure CopyParamsTo(Source: TBisParams);
    function GetQueryText: String;

    property SParamPrefix: String read FSParamPrefix write FSParamPrefix;
    property CacheEnabled: Boolean read FCacheEnabled write FCacheEnabled; 
  end;

  TBisCmxQuery=class(TSqlQuery)
  private
    FFetchCount: Integer;
  public
    procedure FetchAll;
    function GetQueryText: String;

    property FetchCount: Integer read FFetchCount;
  end;

  TBisCmxTable=class(TSqlTable)
  end;

  TBisCmxSqlConnection=class(TSqlConnection)
  private
    function GetUserName: String;
    procedure SetUserName(Value: String);
    function GetPassword: String;
    procedure SetPassword(Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    procedure CopyFrom(Source: TBisCmxSqlConnection);

    property UserName: String read GetUserName write SetUserName;
    property Password: String read GetPassword write SetPassword;
  end;

  TBisCmxSqlConnectionClass=class of TBisCmxSqlConnection;

  TBisCmxSession=class(TBisObject)
  private
    FLock: TRTLCriticalSection;
    FSessions: TBisCmxSessions;
    FSessionId: Variant;
    FConnection: TBisCmxConnection;
    FSqlConnection: TBisCmxSqlConnection;
    FApplicationId: Variant;
    FAccountId: Variant;
    FUserName: String;
    FPassword: String;
    FDateCreate: TDateTime;
    FDateUpdate: TDateTime;
    FPermissions: TBisDataSet;
    FRoles: TStringList;
    FLocks: TBisDataSet;
    FIPList: TStringList;
    FParams: TBisConfig;

    FSSqlInsert: String;
    FSFormatDateTime: String;
    FSSqlUpdate: String;
    FSSqlDelete: String;
    FSSqlLoadPermissions: String;
    FSSqlLoadRoles: String;
    FSSqlLoadLocks: String;
    FSCheckPermissions: String;
    FSSqlLoadProfile: String;
    FSSqlSaveProfile: String;
    FSSqlLoadInterfaces: String;
    FSSqlGetRecords: String;
    FSSqlGetRecordsCount: String;
    FSSqlLoadMenus: String;
    FSSqlLoadScript: String;
    FSSqlLoadReport: String;
    FSSqlLoadDocument: String;
    FSParamPrefix: String;
    FSSessionFormat: String;
    FSInsertStart: String;
    FSInsertSuccess: String;
    FSInsertFail: String;
    FSUpdateStart: String;
    FSUpdateSuccess: String;
    FSUpdateFail: String;
    FSDeleteStart: String;
    FSDeleteFail: String;
    FSDeleteSuccess: String;
    FSLoadProfileFail: String;
    FSLoadProfileSuccess: String;
    FSLoadProfileStart: String;
    FSSaveProfileStart: String;
    FSSaveProfileFail: String;
    FSSaveProfileSuccess: String;
    FSLoadInterfacesSuccess: String;
    FSLoadInterfacesStart: String;
    FSLoadInterfacesFail: String;
    FSGetRecordsSuccess: String;
    FSGetRecordsStart: String;
    FSGetRecordsFail: String;
    FSGetRecordsSql: String;
    FSGetRecordsSqlCount: String;
    FSLoadMenusFail: String;
    FSLoadMenusSuccess: String;
    FSLoadMenusStart: String;
    FSLoadScriptStart: String;
    FSLoadScriptFail: String;
    FSLoadScriptSuccess: String;
    FSLoadScriptSql: String;
    FSLoadReportStart: String;
    FSLoadReportFail: String;
    FSLoadReportSuccess: String;
    FSLoadReportSql: String;
    FSLoadDocumentStart: String;
    FSLoadDocumentFail: String;
    FSLoadDocumentSuccess: String;
    FSLoadDocumentSql: String;
    FSLoadMenusSql: String;
    FSLoadInterfacesSql: String;
    FSSaveProfileSql: String;
    FSLoadProfileSql: String;
    FSDeleteSql: String;
    FSUpdateSql: String;
    FSInsertSql: String;
    FSExecuteStart: String;
    FSExecuteFail: String;
    FSExecuteSuccess: String;
    FSExecuteProvider: String;
    FSExecuteParam: String;
    FSExecutePackageStart: String;
    FSExecutePackageEnd: String;
    FSSqlLoadTasks: String;
    FSLoadTasksStart: String;
    FSLoadTasksSql: String;
    FSLoadTasksFail: String;
    FSLoadTasksSuccess: String;
    FSSqlSaveTask: String;
    FSSaveTaskStart: String;
    FSSaveTaskSql: String;
    FSSaveTaskFail: String;
    FSSaveTaskSuccess: String;
    FSLoadAlarmsFail: String;
    FSLoadAlarmsSuccess: String;
    FSLoadAlarmsStart: String;
    FSLoadAlarmsSql: String;
    FSSqlLoadAlarms: String;
    FSSqlUpdateParams: String;

    procedure LoggerWrite(const Message: String; LogType: TBisLoggerType=ltInformation; const LoggerName: String='');
    procedure CheckPermissions(AObjectName: String; APermissions: TBisPermissions);
    procedure CheckLocks(AMethod: String=''; AObject: String='');
    procedure DumpParams(Params: TBisParams); overload;
    procedure DumpParams(Params: TParams); overload;
    function GetRoleIds: String;
    procedure CopyData(FromDataSet: TDataSet; ToDataSet: TBisDataSet; AllCount: Integer);
    function GetPrefix: String;
    function PreparePrefix(AName: String): String;
    procedure Lock;
    procedure Unlock;
  protected
    function ExecuteOpen(Proc: TBisCmxProc; OpenDataSet: TBisDataSet): TDataSet; virtual;  
  public
    constructor Create(ASessions: TBisCmxSessions); reintroduce; virtual;
    destructor Destroy; override;

    procedure Insert;
    procedure Update(WithParams: Boolean=false; QueryText: String=''; Duration: Integer=-1);
    procedure Delete;
    procedure LoadPermissions;
    procedure LoadRoles;
    procedure LoadLocks;

    procedure LoadProfile(Profile: TBisProfile); virtual;
    procedure SaveProfile(Profile: TBisProfile); virtual;
    procedure LoadInterfaces(Interfaces: TBisInterfaces); virtual;
    procedure GetRecords(DataSet: TBisDataSet; var QueryText: String); virtual;
    procedure Execute(DataSet: TBisDataSet; var QueryText: String); virtual;
    procedure LoadMenus(Menus: TBisMenus); virtual;
    procedure LoadTasks(Tasks: TBisTasks); virtual;
    procedure SaveTask(Task: TBisTask); virtual;
    procedure LoadAlarms(Alarms: TBisAlarms); virtual;
    procedure LoadScript(ScriptId: Variant; Stream: TStream); virtual;
    procedure LoadReport(ReportId: Variant; Stream: TStream); virtual;
    procedure LoadDocument(DocumentId: Variant; Stream: TStream); virtual;

    property SessionId: Variant read FSessionId write FSessionId;
    property SqlConnection: TBisCmxSqlConnection read FSqlConnection;
    property Connection: TBisCmxConnection read FConnection write FConnection;
    property ApplicationId: Variant read FApplicationId write FApplicationId;
    property AccountId: Variant read FAccountId write FAccountId;
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property DateCreate: TDateTime read FDateCreate write FDateCreate;
    property Permissions: TBisDataSet read FPermissions;
    property Roles: TStringList read FRoles;
    property Locks: TBisDataSet read FLocks;
    property IPList: TStringList read FIPList;
    property Params: TBisConfig read FParams;

    property SCheckPermissions: String read FSCheckPermissions write FSCheckPermissions;
    property SFormatDateTime: String read FSFormatDateTime write FSFormatDateTime;
    property SSqlInsert: String read FSSqlInsert write FSSqlInsert;
    property SSqlUpdate: String read FSSqlUpdate write FSSqlUpdate;
    property SSqlUpdateParams: String read FSSqlUpdateParams write FSSqlUpdateParams;
    property SSqlDelete: String read FSSqlDelete write FSSqlDelete;
    property SSqlLoadPermissions: String read FSSqlLoadPermissions write FSSqlLoadPermissions;
    property SSqlLoadRoles: String read FSSqlLoadRoles write FSSqlLoadRoles;
    property SSqlLoadLocks: String read FSSqlLoadLocks write FSSqlLoadLocks; 
    property SSqlLoadProfile: String read FSSqlLoadProfile write FSSqlLoadProfile;
    property SSqlSaveProfile: String read FSSqlSaveProfile write FSSqlSaveProfile;
    property SSqlLoadInterfaces: String read FSSqlLoadInterfaces write FSSqlLoadInterfaces;
    property SSqlGetRecords: String read FSSqlGetRecords write FSSqlGetRecords;
    property SSqlGetRecordsCount: String read FSSqlGetRecordsCount write FSSqlGetRecordsCount;
    property SSqlLoadMenus: String read FSSqlLoadMenus write FSSqlLoadMenus;
    property SSqlLoadTasks: String read FSSqlLoadTasks write FSSqlLoadTasks;
    property SSqlSaveTask: String read FSSqlSaveTask write FSSqlSaveTask;
    property SSqlLoadAlarms: String read FSSqlLoadAlarms write FSSqlLoadAlarms;
    property SSqlLoadScript: String read FSSqlLoadScript write FSSqlLoadScript;
    property SSqlLoadReport: String read FSSqlLoadReport write FSSqlLoadReport;
    property SSqlLoadDocument: String read FSSqlLoadDocument write FSSqlLoadDocument;
    property SParamPrefix: String read FSParamPrefix write FSParamPrefix;
  published
    property SSessionFormat: String read FSSessionFormat write FSSessionFormat;

    property SInsertStart: String read FSInsertStart write FSInsertStart;
    property SInsertSql: String read FSInsertSql write FSInsertSql;
    property SInsertSuccess: String read FSInsertSuccess write FSInsertSuccess;
    property SInsertFail: String read FSInsertFail write FSInsertFail;

    property SUpdateStart: String read FSUpdateStart write FSUpdateStart;
    property SUpdateSql: String read FSUpdateSql write FSUpdateSql;
    property SUpdateSuccess: String read FSUpdateSuccess write FSUpdateSuccess;
    property SUpdateFail: String read FSUpdateFail write FSUpdateFail;

    property SDeleteStart: String read FSDeleteStart write FSDeleteStart;
    property SDeleteSql: String read FSDeleteSql write FSDeleteSql;
    property SDeleteSuccess: String read FSDeleteSuccess write FSDeleteSuccess;
    property SDeleteFail: String read FSDeleteFail write FSDeleteFail;

    property SLoadProfileStart: String read FSLoadProfileStart write FSLoadProfileStart;
    property SLoadProfileSql: String read FSLoadProfileSql write FSLoadProfileSql;
    property SLoadProfileSuccess: String read FSLoadProfileSuccess write FSLoadProfileSuccess;
    property SLoadProfileFail: String read FSLoadProfileFail write FSLoadProfileFail;

    property SSaveProfileStart: String read FSSaveProfileStart write FSSaveProfileStart;
    property SSaveProfileSql: String read FSSaveProfileSql write FSSaveProfileSql;
    property SSaveProfileSuccess: String read FSSaveProfileSuccess write FSSaveProfileSuccess;
    property SSaveProfileFail: String read FSSaveProfileFail write FSSaveProfileFail;

    property SLoadInterfacesStart: String read FSLoadInterfacesStart write FSLoadInterfacesStart;
    property SLoadInterfacesSql: String read FSLoadInterfacesSql write FSLoadInterfacesSql;
    property SLoadInterfacesSuccess: String read FSLoadInterfacesSuccess write FSLoadInterfacesSuccess;
    property SLoadInterfacesFail: String read FSLoadInterfacesFail write FSLoadInterfacesFail;

    property SGetRecordsStart: String read FSGetRecordsStart write FSGetRecordsStart;
    property SGetRecordsSql: String read FSGetRecordsSql write FSGetRecordsSql;
    property SGetRecordsSqlCount: String read FSGetRecordsSqlCount write FSGetRecordsSqlCount;
    property SGetRecordsSuccess: String read FSGetRecordsSuccess write FSGetRecordsSuccess;
    property SGetRecordsFail: String read FSGetRecordsFail write FSGetRecordsFail;

    property SExecuteStart: String read FSExecuteStart write FSExecuteStart;
    property SExecuteProvider: String read FSExecuteProvider write FSExecuteProvider;
    property SExecuteParam: String read FSExecuteParam write FSExecuteParam;
    property SExecutePackageStart: String read FSExecutePackageStart write FSExecutePackageStart;
    property SExecutePackageEnd: String read FSExecutePackageEnd write FSExecutePackageEnd;
    property SExecuteSuccess: String read FSExecuteSuccess write FSExecuteSuccess;
    property SExecuteFail: String read FSExecuteFail write FSExecuteFail;

    property SLoadMenusStart: String read FSLoadMenusStart write FSLoadMenusStart;
    property SLoadMenusSql: String read FSLoadMenusSql write FSLoadMenusSql;
    property SLoadMenusSuccess: String read FSLoadMenusSuccess write FSLoadMenusSuccess;
    property SLoadMenusFail: String read FSLoadMenusFail write FSLoadMenusFail;

    property SLoadTasksStart: String read FSLoadTasksStart write FSLoadTasksStart;
    property SLoadTasksSql: String read FSLoadTasksSql write FSLoadTasksSql;
    property SLoadTasksSuccess: String read FSLoadTasksSuccess write FSLoadTasksSuccess;
    property SLoadTasksFail: String read FSLoadTasksFail write FSLoadTasksFail;

    property SSaveTaskStart: String read FSSaveTaskStart write FSSaveTaskStart;
    property SSaveTaskSql: String read FSSaveTaskSql write FSSaveTaskSql;
    property SSaveTaskSuccess: String read FSSaveTaskSuccess write FSSaveTaskSuccess;
    property SSaveTaskFail: String read FSSaveTaskFail write FSSaveTaskFail;

    property SLoadAlarmsStart: String read FSLoadAlarmsStart write FSLoadAlarmsStart;
    property SLoadAlarmsSql: String read FSLoadAlarmsSql write FSLoadAlarmsSql;
    property SLoadAlarmsSuccess: String read FSLoadAlarmsSuccess write FSLoadAlarmsSuccess;
    property SLoadAlarmsFail: String read FSLoadAlarmsFail write FSLoadAlarmsFail;

    property SLoadScriptStart: String read FSLoadScriptStart write FSLoadScriptStart;
    property SLoadScriptSql: String read FSLoadScriptSql write FSLoadScriptSql;
    property SLoadScriptSuccess: String read FSLoadScriptSuccess write FSLoadScriptSuccess;
    property SLoadScriptFail: String read FSLoadScriptFail write FSLoadScriptFail;

    property SLoadReportStart: String read FSLoadReportStart write FSLoadReportStart;
    property SLoadReportSql: String read FSLoadReportSql write FSLoadReportSql;
    property SLoadReportSuccess: String read FSLoadReportSuccess write FSLoadReportSuccess;
    property SLoadReportFail: String read FSLoadReportFail write FSLoadReportFail;

    property SLoadDocumentStart: String read FSLoadDocumentStart write FSLoadDocumentStart;
    property SLoadDocumentSql: String read FSLoadDocumentSql write FSLoadDocumentSql;
    property SLoadDocumentSuccess: String read FSLoadDocumentSuccess write FSLoadDocumentSuccess;
    property SLoadDocumentFail: String read FSLoadDocumentFail write FSLoadDocumentFail;

  end;

  TBisCmxSessionClass=class of TBisCmxSession;

  TBisCmxSessions=class(TObjectList)
  private
    FConnection: TBisCmxConnection;
    FSSchemaOverride: String;
    FSFormatSchemaName: String;
    function GetItems(Index: Integer): TBisCmxSession;

  protected
    function GetSessionClass: TBisCmxSessionClass; virtual;
  public
    constructor Create(AConnection: TBisCmxConnection); virtual;
    destructor Destroy; override;

    function Add(SessionId: Variant; DateCreate: TDateTime;
                 ApplicationId, AccountId: Variant; UserName, Password: String;
                 DbUserName, DbPassword: String; SessionParams, IPList: String;
                 IsNew: Boolean): TBisCmxSession;
    function Find(SessionId: Variant): TBisCmxSession;
    procedure Remove(Session: TBisCmxSession; WithDelete: Boolean);
    procedure CopyFrom(Source: TBisCmxSessions; IsClear: Boolean);

    property Items[Index: Integer]: TBisCmxSession read GetItems;

    property SSchemaOverride: String read FSSchemaOverride write FSSchemaOverride;
    property SFormatSchemaName: String read FSFormatSchemaName write FSFormatSchemaName;
  end;

  TBisCmxSessionsClass=class of TBisCmxSessions;

  TBisCmxConnection=class(TBisConnection)
  private
    FLock: TRTLCriticalSection;
    FDefaultConnection: TBisCmxSqlConnection;
    FLinkedDefaultConnection: TBisCmxSqlConnection;
    FSessions: TBisCmxSessions;
    FWorking: Boolean;

    FSSqlGetDbUserName: String;
    FSSqlApplicationExists: String;
    FSSqlSessionExists: String;
    FSSqlGetServerDate: String;
    FSFieldNameQuote: String;
    FSFormatDateTimeValue: String;
    FSFormatDateValue: String;
    FSSqlInsert: String;
    FSFormatFilterDateValue: String;
    FSImportScriptSuccess: String;
    FSImportTableStart: String;
    FSImportTableSql: String;
    FSImportTableFail: String;
    FSImportScriptStart: String;
    FSImportTableSuccess: String;
    FSImportScriptSql: String;
    FSImportTableParam: String;
    FSImportScriptFail: String;
    FSSqlUpdate: String;
    FSSQLGetKeys: String;
    FSImportTableEmpty: String;
{    FSExecSqlStart: String;
    FSExecSqlSuccess: String;
    FSExecSqlFail: String;
    FSExecSqlSql: String;}

    procedure Lock;
    procedure UnLock;
    function GetDbUserName(UserName, Password: String; var AccountId, FirmId, FirmSmallName: Variant;
                           var DbUserName, DbPassword: String): Boolean;
    function ApplicationExists(ApplicationId,AccountId: Variant): Boolean;
    function SessionExists(SessionId: Variant): Boolean;
    function SessionFind(SessionId: Variant): TBisCmxSession;
    function GetTableName(SQL: String; var Where: String): String;
    procedure ImportScript(Stream: TStream);
    procedure ImportTable(Stream: TStream);
    procedure ExportScript(const Value: String; Stream: TStream; Params: TBisConnectionExportParams=nil);
    procedure ExportTable(const Value: String; Stream: TStream; Params: TBisConnectionExportParams=nil);
    procedure ChangeParams(Sender: TObject);
    function GetPrefix: String;
    function PreparePrefix(AName: String): String;
    function GetInternalServerDate: TDateTime;
    function GetDataBase: String;
    function GetRealDefaultConnection: TBisCmxSqlConnection;
  protected
    function GetFieldNameQuote: String; override;
    function GetRecordsFilterDateValue(Value: TDateTime): String; override;
    function GetConnected: Boolean; override;
    function GetWorking: Boolean; override;

    function GetSessionsClass: TBisCmxSessionsClass; virtual;

    property RealDefaultConnection: TBisCmxSqlConnection read GetRealDefaultConnection;
    property Sessions: TBisCmxSessions read FSessions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init; override;

    procedure Connect; override;
    procedure Disconnect; override;
    procedure Import(ImportType: TBisConnectionImportType; Stream: TStream); override;
    procedure Export(ExportType: TBisConnectionExportType; const Value: String;
                     Stream: TStream; Params: TBisConnectionExportParams=nil); override;
    function GetServerDate: TDateTime; override;

    function Login(const ApplicationId: Variant; const UserName,Password: String; Params: TBisConnectionLoginParams=nil): Variant; override;
    procedure Logout(const SessionId: Variant); override;
    function Check(const SessionId: Variant; var ServerDate: TDateTime): Boolean; override;
    procedure Update(const SessionId: Variant; Params: TBisConfig=nil); override;
    procedure LoadProfile(const SessionId: Variant; Profile: TBisProfile); override;
    procedure SaveProfile(const SessionId: Variant; Profile: TBisProfile); override;
    procedure RefreshPermissions(const SessionId: Variant); override;
    procedure LoadInterfaces(const SessionId: Variant; Interfaces: TBisInterfaces); override;
    procedure GetRecords(const SessionId: Variant; DataSet: TBisDataSet); override;
    procedure Execute(const SessionId: Variant; DataSet: TBisDataSet); override;
    procedure LoadMenus(const SessionId: Variant; Menus: TBisMenus); override;
    procedure LoadTasks(const SessionId: Variant; Tasks: TBisTasks); override;
    procedure SaveTask(const SessionId: Variant; Task: TBisTask); override;
    procedure LoadAlarms(const SessionId: Variant; Alarms: TBisAlarms); override;
    procedure LoadScript(const SessionId: Variant; ScriptId: Variant; Stream: TStream); override;
    procedure LoadReport(const SessionId: Variant; ReportId: Variant; Stream: TStream); override;
    procedure LoadDocument(const SessionId: Variant; DocumentId: Variant; Stream: TStream); override;

    function CloneConnection(const SessionId: Variant; WithDefault: Boolean=true): TBisConnection; override;
    procedure RemoveConnection(Connection: TBisConnection; const SessionId: Variant; IsLogout: Boolean); override;

    property SSqlGetDbUserName: String read FSSqlGetDbUserName write FSSqlGetDbUserName;
    property SSqlApplicationExists: String read FSSqlApplicationExists write FSSqlApplicationExists;
    property SSqlSessionExists: String read FSSqlSessionExists write FSSqlSessionExists;
    property SSqlGetServerDate: String read FSSqlGetServerDate write FSSqlGetServerDate;
    property SFieldNameQuote: String read FSFieldNameQuote write FSFieldNameQuote;
    property SFormatDateTimeValue: String read FSFormatDateTimeValue write FSFormatDateTimeValue;
    property SFormatDateValue: String read FSFormatDateValue write FSFormatDateValue;
    property SSqlInsert: String read FSSqlInsert write FSSqlInsert;
    property SSqlUpdate: String read FSSqlUpdate write FSSqlUpdate;
    property SSQLGetKeys: String read FSSQLGetKeys write FSSQLGetKeys;
    property SFormatFilterDateValue: String read FSFormatFilterDateValue write FSFormatFilterDateValue;
  published

{    property SExecSqlStart: String read FSExecSqlStart write FSExecSqlStart;
    property SExecSqlSql: String read FSExecSqlSql write FSExecSqlSql;
    property SExecSqlSuccess: String read FSExecSqlSuccess write FSExecSqlSuccess;
    property SExecSqlFail: String read FSExecSqlFail write FSExecSqlFail;}

    property SImportScriptStart: String read FSImportScriptStart write FSImportScriptStart;
    property SImportScriptSql: String read FSImportScriptSql write FSImportScriptSql;
    property SImportScriptSuccess: String read FSImportScriptSuccess write FSImportScriptSuccess;
    property SImportScriptFail: String read FSImportScriptFail write FSImportScriptFail;

    property SImportTableStart: String read FSImportTableStart write FSImportTableStart;
    property SImportTableSql: String read FSImportTableSql write FSImportTableSql;
    property SImportTableSuccess: String read FSImportTableSuccess write FSImportTableSuccess;
    property SImportTableEmpty: String read FSImportTableEmpty write FSImportTableEmpty;
    property SImportTableFail: String read FSImportTableFail write FSImportTableFail;
    property SImportTableParam: String read FSImportTableParam write FSImportTableParam;
    
  end;

implementation

uses SysUtils, DateUtils, ActiveX, FMtBcd, TypInfo, StrUtils,
     BisCmxConsts, BisUtils, BisExceptions, BisNetUtils,
     BisConsts, BisCoreUtils, BisFilterGroups;


{ TBisCmxProc }

constructor TBisCmxProc.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisCmxProc.GetQueryText: String;
var
  Str: TStringList;
  i: Integer;
  Param: TParam;
  S: String;
  V: String;
begin
  Str:=TStringList.Create;
  try
    Str.Text:=StoredProcName;
    for i:=Params.Count-1 downto 0 do begin
      Param:=Params.Items[i];
      if VarIsNull(Param.Value) then
        V:='NULL'
      else V:=Param.AsString;
      S:=FormatEx('%s=%s',[Param.Name,V]);
      Str.Add(S);
    end;
    Result:=Trim(Str.Text);
  finally
    Str.Free;
  end;
end;

procedure TBisCmxProc.CopyParamsFrom(Source: TBisParams);
var
  Item: TBisParam;

  procedure SetToParam(ParamName: String; Value: Variant);
  var
    Param: TParam;
    S: String;
  begin
    S:=SParamPrefix+ParamName;
    Param:=Params.FindParam(S);
    if Assigned(Param) then begin
      if Item.ParamType in [ptInput,ptInputOutput] then begin
        Param.Value:=Value;
      end;
    end;
  end;

var
  i,j: Integer;
begin
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Item:=Source.Items[i];
      SetToParam(Item.ParamName,Item.Value);
      for j:=0 to Item.Olders.Count-1 do begin
        SetToParam(Item.Olders.Strings[j],Item.OldValue);
      end;
    end;
  end;
end;

procedure TBisCmxProc.CopyParamsTo(Source: TBisParams);
var
  Item: TBisParam;

  procedure GetFromParam;
  var
    Param: TParam;
    S: String;
  begin
    S:=SParamPrefix+Item.ParamName;
    Param:=Params.FindParam(S);
    if Assigned(Param) then begin
      if Item.ParamType in [ptOutput,ptInputOutput] then begin
        Item.Value:=Param.Value;
      end;
    end;
  end;

var
  i: Integer;
begin
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Item:=Source.Items[i];
      GetFromParam;
    end;
  end;
end;

procedure TBisCmxProc.SetNullToParamValues;
var
  i: Integer;
  Param: TParam;
begin
  for i:=Params.Count-1 downto 0 do begin
    Param:=Params.Items[i];
    if Trim(Param.Name)<>'' then begin
      Param.Value:=Null;
{      if Param.ParamType in [ptInputOutput,ptOutput] then
        Param.Value:='';}

    end else
      Params.Delete(i);
  end;
end;

procedure TBisCmxProc.SetCommandText(const Value: WideString);
begin
  if not FCacheEnabled then
    inherited SetCommandText(Value);
end;

{ TBisCmxQuery }

procedure TBisCmxQuery.FetchAll;
begin
  FFetchCount:=0;
  First;
  while not Eof do begin
    Inc(FFetchCount);
    Next;
  end;
  First;
end;

function TBisCmxQuery.GetQueryText: String;
var
  Str: TStringList;
  i: Integer;
  Param: TParam;
  S: String;
  V: String;
begin
  Str:=TStringList.Create;
  try
    Str.Text:=SQL.Text;
    for i:=Params.Count-1 downto 0 do begin
      Param:=Params.Items[i];
      if VarIsNull(Param.Value) then
        V:='NULL'
      else V:=Param.AsString;
      S:=FormatEx('%s=%s',[Param.Name,V]);
      Str.Add(S);
    end;
    Result:=Trim(Str.Text);
  finally
    Str.Free;
  end;
end;

{ TBisCmxSqlConnection }

constructor TBisCmxSqlConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LoginPrompt:=false;
  LoadParamsOnConnect:=false;
  ParamsLoaded:=false;
  SQLHourGlass:=false;
end;

function TBisCmxSqlConnection.GetUserName: String;
begin
  Result:=Params.Values[TDBXPropertyNames.UserName];
end;

procedure TBisCmxSqlConnection.SetUserName(Value: String);
begin
  Params.Values[TDBXPropertyNames.UserName]:=Value;
end;

function TBisCmxSqlConnection.GetPassword: String;
begin
  Result:=Params.Values[TDBXPropertyNames.Password];
end;

procedure TBisCmxSqlConnection.SetPassword(Value: String);
begin
  Params.Values[TDBXPropertyNames.Password]:=Value;
end;

procedure TBisCmxSqlConnection.CopyFrom(Source: TBisCmxSqlConnection);
var
  ASource: TBisCmxSqlConnection;
begin
  if Source is TBisCmxSqlConnection then begin
    ASource:=TBisCmxSqlConnection(Source);
    Self.DriverName:=ASource.DriverName;
    Self.LibraryName:=ASource.LibraryName;
    Self.VendorLib:=ASource.VendorLib;
    Self.GetDriverFunc:=ASource.GetDriverFunc;
    Self.Params.Text:=ASource.Params.Text;
  end;
end;

{ TBisCmxSession }

constructor TBisCmxSession.Create(ASessions: TBisCmxSessions);
begin
  inherited Create(nil);
  InitializeCriticalSection(FLock);
  
  FSessions:=ASessions;
  FSqlConnection:=TBisCmxSqlConnection.Create(nil);
  FPermissions:=TBisDataSet.Create(nil);
  FRoles:=TStringList.Create;
  FLocks:=TBisDataSet.Create(nil);
  FIPList:=TStringList.Create;
  FParams:=TBisConfig.Create(nil);

  FSSessionFormat:='%s: %s';

  FSInsertStart:='������ �������� ������ ...';
  FSInsertSql:='������ �������� ������ => %s';
  FSInsertSuccess:='������ ������� �������.';
  FSInsertFail:='������ �� �������. %s';

  FSUpdateStart:='������ ���������� ������ ...';
  FSUpdateSql:='������ ���������� ������ => %s';
  FSUpdateSuccess:='������ ��������� �������.';
  FSUpdateFail:='������ �� ���������. %s';

  FSDeleteStart:='������ �������� ������ ...';
  FSDeleteSql:='������ �������� ������ => %s';
  FSDeleteSuccess:='������ ������� �������.';
  FSDeleteFail:='������ �� �������. %s';

  FSLoadProfileStart:='������ �������� ������� ...';
  FSLoadProfileSql:='������ �������� ������� => %s';
  FSLoadProfileSuccess:='������� �������� �������.';
  FSLoadProfileFail:='������� �� ��������. %s';

  FSSaveProfileStart:='������ ���������� ������� ...';
  FSSaveProfileSql:='������ ���������� ������� => %s';
  FSSaveProfileSuccess:='������� �������� �������.';
  FSSaveProfileFail:='������� �� ��������. %s';

  FSLoadInterfacesStart:='������ �������� ����������� ...';
  FSLoadInterfacesSql:='������ �������� ����������� => %s';
  FSLoadInterfacesSuccess:='���������� ��������� �������.';
  FSLoadInterfacesFail:='���������� �� ���������. %s';

  FSGetRecordsStart:='������ ��������� ������� ...';
  FSGetRecordsSql:='������ ��������� ������� => %s';
  FSGetRecordsSqlCount:='������ ���������� ������� => %s';
  FSGetRecordsSuccess:='������ �������� �������.';
  FSGetRecordsFail:='������ �� ��������. %s';

  FSExecuteStart:='������ ���������� ��������� ...';
  FSExecuteProvider:='��� ��������� => %s';
  FSExecuteParam:='�������� => %s ��� ��������� => %s ��� ������ => %s �������� => %s';
  FSExecutePackageStart:='������ ���������� ������ ...';
  FSExecutePackageEnd:='��������� ���������� ������ ...';
  FSExecuteSuccess:='��������� ��������� �������.';
  FSExecuteFail:='��������� �� ���������. %s';

  FSLoadMenusStart:='������ �������� ���� ...';
  FSLoadMenusSql:='������ �������� ���� => %s';
  FSLoadMenusSuccess:='���� ��������� �������.';
  FSLoadMenusFail:='���� �� ���������. %s';

  FSLoadTasksStart:='������ �������� ������� ...';
  FSLoadTasksSql:='������ �������� ������� => %s';
  FSLoadTasksSuccess:='������� ��������� �������.';
  FSLoadTasksFail:='������� �� ���������. %s';

  FSSaveTaskStart:='������ ���������� ������� ...';
  FSSaveTaskSql:='������ ���������� ������� => %s';
  FSSaveTaskSuccess:='������� ��������� �������.';
  FSSaveTaskFail:='������� �� ���������. %s';

  FSLoadAlarmsStart:='������ �������� ���������� ...';
  FSLoadAlarmsSql:='������ �������� ���������� => %s';
  FSLoadAlarmsSuccess:='���������� ��������� �������.';
  FSLoadAlarmsFail:='��������� �� ���������. %s';

  FSLoadScriptStart:='������ �������� ������� ...';
  FSLoadScriptSql:='������ �������� ������� => %s';
  FSLoadScriptSuccess:='������ �������� �������.';
  FSLoadScriptFail:='������ �� ��������. %s';

  FSLoadReportStart:='������ �������� ������ ...';
  FSLoadReportSql:='������ �������� ������ => %s';
  FSLoadReportSuccess:='����� �������� �������.';
  FSLoadReportFail:='����� �� ��������. %s';

  FSLoadDocumentStart:='������ �������� ��������� ...';
  FSLoadDocumentSql:='������ �������� ��������� => %s';
  FSLoadDocumentSuccess:='�������� �������� �������.';
  FSLoadDocumentFail:='�������� �� ��������. %s';

  TranslateObject(Self,TBisCmxSession);
end;

destructor TBisCmxSession.Destroy;
begin
  FParams.Free;
  FIPList.Free;
  FLocks.Free;
  FRoles.Free;
  FPermissions.Free;
  FSqlConnection.Free;
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

procedure TBisCmxSession.LoggerWrite(const Message: String; LogType: TBisLoggerType=ltInformation; const LoggerName: String='');
var
  S: String;
begin
  if Assigned(FConnection) and (Trim(Message)<>'') then begin
    S:=FormatEx(FSSessionFormat,[VarToStrDef(FSessionId,''),Message]);
    FConnection.LoggerWrite(S,LogType,LoggerName);
  end;
end;

function TBisCmxSession.GetPrefix: String;
begin
  Result:='';
  if Assigned(FConnection) then
    Result:=FConnection.GetPrefix;
end;

function TBisCmxSession.PreparePrefix(AName: String): String;
begin
  Result:=AName;
  if Assigned(FConnection) then
    Result:=FConnection.PreparePrefix(AName);
end;

function TBisCmxSession.GetRoleIds: String;
var
  i: Integer;
begin
  Result:=QuotedStr(VarToStrDef(FAccountId,''));
  for i:=0 to FRoles.Count-1 do begin
    if Trim(FRoles[i])<>'' then begin
      Result:=Result+','+QuotedStr(FRoles[i]);
    end;
  end;
end;

procedure TBisCmxSession.Lock;
begin
  EnterCriticalSection(FLock);
end;

procedure TBisCmxSession.Unlock;
begin
  LeaveCriticalSection(FLock);
end;

procedure TBisCmxSession.Insert;
var
  Query: TBisCmxQuery;
  Stream: TMemoryStream;
  Sql: String;
begin
  Lock;
  try
    if Assigned(FParams) and FSqlConnection.Connected then begin
      LoggerWrite(FSInsertStart);
      try
        Query:=TBisCmxQuery.Create(nil);
        Stream:=TMemoryStream.Create;
        try
          Query.SQLConnection:=FSqlConnection;
          Query.ParamCheck:=true;
          Sql:=FormatEx(FSSqlInsert,[QuotedStr(VarToStrDef(FSessionId,'')),QuotedStr(VarToStrDef(FApplicationId,'')),
                                     QuotedStr(VarToStrDef(FAccountId,'')),
                                     QuotedStr(FormatDateTime(FSFormatDateTime,FDateCreate))]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSInsertSql,[Sql]));
          Query.SQL.Text:=Sql;
          FParams.SaveToStream(Stream);
          Stream.Position:=0;
          Query.ParamByName('PARAMS').LoadFromStream(Stream,ftBlob);
          Query.ExecSQL;
          LoggerWrite(FSInsertSuccess);
        finally
          Stream.Free;
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSInsertFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.Update(WithParams: Boolean=false; QueryText: String=''; Duration: Integer=-1);
var
  Query: TBisCmxQuery;
  Stream: TMemoryStream;
  Sql: String;
begin
  Lock;
  try
    if Assigned(FConnection) and FSqlConnection.Connected then begin
      LoggerWrite(FSUpdateStart);
      try
        Query:=TBisCmxQuery.Create(nil);
        Stream:=TMemoryStream.Create;
        try
          FDateUpdate:=FConnection.GetServerDate;
          Query.SQLConnection:=FSqlConnection;
          Query.ParamCheck:=true;
          if WithParams then begin
            Sql:=FormatEx(FSSqlUpdateParams,[QuotedStr(VarToStrDef(FSessionId,''))]);
          end else begin
            Sql:=FormatEx(FSSqlUpdate,[QuotedStr(VarToStrDef(FSessionId,''))]);
          end;
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          Query.SQL.Text:=Sql;
          if WithParams then begin
            Stream.Clear;
            FParams.SaveToStream(Stream);
            Stream.Position:=0;
            Query.ParamByName('PARAMS').LoadFromStream(Stream,ftBlob);
          end;
          if Trim(QueryText)<>'' then begin
            Stream.Clear;
            Stream.Write(Pointer(QueryText)^,Length(QueryText));
            Stream.Position:=0;
            Query.ParamByName('QUERY_TEXT').LoadFromStream(Stream,ftBlob);
          end else begin
            Query.ParamByName('QUERY_TEXT').Value:='';
            Query.ParamByName('QUERY_TEXT').Value:=Null;
          end;
//          Query.ParamByName('QUERY_TEXT').Value:=Iff(Trim(QueryText)<>'',Trim(QueryText),NULL);
          if Duration<>-1 then begin
            Query.ParamByName('DURATION').Value:=Duration; 
          end else begin
            Query.ParamByName('DURATION').Value:=0;
            Query.ParamByName('DURATION').Value:=Null;
          end;
//          Query.ParamByName('DURATION').Value:=Iff(Duration<>-1,Duration,NULL);

          LoggerWrite(FormatEx(FSUpdateSql,[Query.GetQueryText]));

          Query.ExecSQL;
          LoggerWrite(FSUpdateSuccess);
        finally
          Stream.Free;
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSUpdateFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.Delete;
var
  Query: TBisCmxQuery;
  Sql: String;
begin
  Lock;
  try
    if FSqlConnection.Connected then begin
      LoggerWrite(FSDeleteStart);
      try
        Query:=TBisCmxQuery.Create(nil);
        try
          Query.SQLConnection:=FSqlConnection;
          Sql:=FormatEx(FSSqlDelete,[QuotedStr(VarToStrDef(FSessionId,''))]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSDeleteSql,[Sql]));
          Query.SQL.Text:=Sql;
          Query.ExecSQL;
          LoggerWrite(FSDeleteSuccess);
        finally
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSDeleteFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.LoadPermissions;
var
  Query: TBisCmxQuery;
  S: String;
  Sql: String;
begin
  Lock;
  try
    S:=GetRoleIds;
    if FSqlConnection.Connected and (Trim(S)<>'') then begin
      Query:=TBisCmxQuery.Create(nil);
      try
        Query.SQLConnection:=FSqlConnection;
        Sql:=FormatEx(FSSqlLoadPermissions,[S]);
        Query.SQL.Text:=ReplaceText(Sql,SPrefix,GetPrefix);
        Query.Open;
        if Query.Active then begin
          FPermissions.CreateTable(Query);
          FPermissions.CopyRecords(Query);
        end;
      finally
        Query.Free;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.LoadRoles;
var
  Query: TBisCmxQuery;
  Sql: String;
begin
  Lock;
  try
    if FSqlConnection.Connected then begin
      FRoles.Clear;
      Query:=TBisCmxQuery.Create(nil);
      try
        Query.SQLConnection:=FSqlConnection;
        Sql:=FormatEx(FSSqlLoadRoles,[QuotedStr(VarToStrDef(FAccountId,''))]);
        Query.SQL.Text:=ReplaceText(Sql,SPrefix,GetPrefix);
        Query.Open;
        if Query.Active then begin
          Query.First;
          while not Query.Eof do begin
            FRoles.Add(Query.FieldByName('ROLE_ID').AsString);
            Query.Next;
          end;
        end;
      finally
        Query.Free;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.LoadLocks;
var
  Query: TBisCmxQuery;
  S: String;
  Sql: String;
  ADate: String;
begin
  Lock;
  try
    S:=GetRoleIds;
    if FSqlConnection.Connected and (Trim(S)<>'') then begin
      Query:=TBisCmxQuery.Create(nil);
      try
        Query.SQLConnection:=FSqlConnection;
        ADate:=QuotedStr(FormatDateTime(FSFormatDateTime,FDateCreate));
        Sql:=FormatEx(FSSqlLoadLocks,[ADate,ADate,ADate,QuotedStr(VarToStrDef(FApplicationId,'')),S]);
        Query.SQL.Text:=ReplaceText(Sql,SPrefix,GetPrefix);
        Query.Open;
        if Query.Active then begin
          FLocks.CreateTable(Query);
          FLocks.CopyRecords(Query);
        end;
      finally
        Query.Free;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.CheckPermissions(AObjectName: String; APermissions: TBisPermissions);
var
  Access: String;
  Perm: TBisPermission;
  Value: String;
  Index: Integer;
begin
  if Assigned(APermissions) then
    if FPermissions.Active and not FPermissions.IsEmpty then begin
      APermissions.Clear;
      FPermissions.Filter:=FormatEx(FSCheckPermissions,[QuotedStr(AObjectName)]);
      FPermissions.Filtered:=true;
      try
        FPermissions.First;
        while not FPermissions.Eof do begin
          Access:=FPermissions.FieldByName('RIGHT_ACCESS').AsString;
          Perm:=APermissions.Find(Access);
          if not Assigned(Perm) then
            Perm:=APermissions.Add(Access);
          if Assigned(Perm) then begin
            Value:=FPermissions.FieldByName('VALUE').AsString;
            Index:=Perm.Values.IndexOf(Value);
            if Index=-1 then
              Index:=Perm.Values.Add(Value);
            Perm.Exists[Index]:=true;
          end;
          FPermissions.Next;
        end;
      finally
        FPermissions.Filtered:=false;
        FPermissions.Filter:='';
      end;
    end;
end;

procedure TBisCmxSession.CheckLocks(AMethod: String=''; AObject: String='');
var
  Met: String;
  Obj: String;
  Desc: String;
  List: TStringList;

  function ListFound: Boolean;
  var
    i: Integer;
  begin
    Result:=false;
    for i:=0 to IPList.Count-1 do begin
      if MatchIP(Trim(IPList[i]),List) then begin
        Result:=true;
        exit;
      end;
    end;
  end;

begin
  if Assigned(FLocks) then begin
    if FLocks.Active and not FLocks.IsEmpty then begin
      FLocks.First;
      List:=TStringList.Create;
      try
        while not FLocks.Eof do begin
          Met:=FLocks.FieldByName('METHOD').AsString;
          if (Trim(Met)='') or AnsiSameText(Met,AMethod) then begin
            Obj:=FLocks.FieldByName('OBJECT').AsString;
            if (Trim(Obj)='') or AnsiSameText(Obj,AObject) then begin
              List.Text:=FLocks.FieldByName('IP_LIST').AsString;
              if (Trim(List.Text)='') or ListFound then begin
                Desc:=FLocks.FieldByName('DESCRIPTION').AsString;
                raise Exception.Create(Desc);
              end;
            end;
          end;
          FLocks.Next;
        end;
      finally
        List.Free;
      end;
    end;
  end;
end;

procedure TBisCmxSession.LoadProfile(Profile: TBisProfile);
var
  Query: TBisCmxQuery;
  Sql: String;
begin
  Lock;
  try
    if Assigned(Profile) and FSqlConnection.Connected then begin
      LoggerWrite(FSLoadProfileStart);
      try
        Query:=TBisCmxQuery.Create(nil);
        try
          Query.SQLConnection:=FSqlConnection;
          Sql:=FormatEx(FSSqlLoadProfile,[QuotedStr(VarToStrDef(FApplicationId,'')),QuotedStr(VarToStrDef(FAccountId,''))]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSLoadProfileSql,[Sql]));
          Query.SQL.Text:=Sql;
          Query.Open;
          if Query.Active and not Query.IsEmpty then begin
            Profile.Text:=Query.FieldByName('PROFILE').AsString;
          end;
          LoggerWrite(FSLoadProfileSuccess);
        finally
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSLoadProfileFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.SaveProfile(Profile: TBisProfile);
var
  Query: TBisCmxQuery;
  Stream: TMemoryStream;
  Sql: String;
begin
  Lock;
  try
    if Assigned(Profile) and FSqlConnection.Connected then begin
      LoggerWrite(FSSaveProfileStart);
      try
        Query:=TBisCmxQuery.Create(nil);
        Stream:=TMemoryStream.Create;
        try
          Profile.SaveToStream(Stream);
          Stream.Position:=0;
          Query.SQLConnection:=FSqlConnection;
          Query.ParamCheck:=true;
          Sql:=FormatEx(FSSqlSaveProfile,[QuotedStr(VarToStrDef(FApplicationId,'')),QuotedStr(VarToStrDef(FAccountId,''))]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSSaveProfileSql,[Sql]));
          Query.SQL.Text:=Sql;
          Query.ParamByName('PROFILE').LoadFromStream(Stream,ftBlob);
          Query.ExecSQL;
          LoggerWrite(FSSaveProfileSuccess);
        finally
          Stream.Free;
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSSaveProfileFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.CopyData(FromDataSet: TDataSet; ToDataSet: TBisDataSet; AllCount: Integer);

  function FetchAll: Integer;
  begin
    Result:=0;
    FromDataSet.First;
    while not FromDataSet.Eof do begin
      Inc(Result);
      FromDataSet.Next;
    end;
    FromDataSet.First;
  end;

var
  FetchCount: Integer;
  StartPos: Integer;
  RealCount: Integer;
  RecCount: Integer;
  AActive: Boolean;
begin
  if Assigned(FromDataSet) and Assigned(ToDataSet) then begin

    AActive:=FromDataSet.Active;


    if AActive then begin

      if ToDataSet.FetchCount<0 then begin
        FetchCount:=FetchAll;
        AllCount:=FetchCount;
      end;

      ToDataSet.BeginUpdate;
      try
        if ToDataSet.Active then
          StartPos:=ToDataSet.RecordCount
        else StartPos:=0;

        RealCount:=ToDataSet.FetchCount;
        if RealCount<0 then begin
          RealCount:=AllCount-StartPos
        end else begin
          if (StartPos+RealCount)>AllCount then
            RealCount:=AllCount-StartPos;
        end;

        RecCount:=0;
        if not ToDataSet.Active then begin
          ToDataSet.CreateTable(FromDataSet);
        end;

        while not FromDataSet.Eof do begin
          if (RecCount>=StartPos) then begin
            if (RecCount<(StartPos+RealCount)) then begin
              ToDataSet.CopyRecord(FromDataSet);
            end else
              break;
          end;
          Inc(RecCount);
          FromDataSet.Next;
        end;

        ToDataSet.First;
        ToDataSet.ServerRecordCount:=AllCount;

      finally
        ToDataSet.EndUpdate;
      end;
    end;
  end;
end;

procedure TBisCmxSession.GetRecords(DataSet: TBisDataSet; var QueryText: String);
var
  Query: TBisCmxQuery;
  SQL: String;
  SQLCount: String;
  AllCount: Integer;
  FieldNames: String;
  Params: String;
  Filters: String;
  Groups: String;
  Orders: String;
  AProvider: String;
begin
  Lock;
  try
    if Assigned(DataSet) and FSqlConnection.Connected then begin
      LoggerWrite(FSGetRecordsStart);
      try
        AProvider:=PreparePrefix(DataSet.ProviderName);
        Query:=TBisCmxQuery.Create(nil);
        try
          Query.SQLConnection:=FSqlConnection;
          Query.ParamCheck:=DataSet.Params.Count>0;

          FieldNames:=FConnection.GetRecordsFieldNames(DataSet,DataSet.FieldNames);
          Params:=FConnection.GetRecordsParams(DataSet,DataSet.Params);
          Filters:=FConnection.GetRecordsFilterGroups(DataSet.FilterGroups);
          Groups:=FConnection.GetRecordsGroups(DataSet,DataSet.FieldNames);
          Orders:=FConnection.GetRecordsOrders(DataSet.Orders);

          SQL:=Trim(FormatEx(FSSqlGetRecords,[FieldNames,AProvider,Params,Filters,Groups,Orders]));
          LoggerWrite(FormatEx(FSGetRecordsSql,[SQL]));
          AllCount:=0;

          if DataSet.FetchCount>0 then begin
          //  SQLCount:=Trim(Format(FSSqlGetRecordsCount,[SQL]));  Oracle, MsSql
            SQLCount:=Trim(FormatEx(FSSqlGetRecords,['COUNT(*)',AProvider,Params,Filters,Groups,''])); // Interbase
            LoggerWrite(FormatEx(FSGetRecordsSqlCount,[SQLCount]));
            Query.SQL.Text:=SQLCount;
  //          Query.CopyParamsFrom(DataSet.Params);
            Query.Open;
            if not Query.IsEmpty then
              AllCount:=Query.Fields[0].AsInteger;
          end else begin
            AllCount:=MaxInt;
          end;

          Query.Close;
          Query.SQL.Text:=SQL;
          QueryText:=Query.GetQueryText;
  //        Query.CopyParamsFrom(DataSet.Params);
          Query.Open;
          LoggerWrite(FSGetRecordsSuccess);

          CopyData(Query,DataSet,AllCount);

        finally
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSGetRecordsFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    UnLock;
  end;
end;

procedure TBisCmxSession.DumpParams(Params: TBisParams);
var
  S1: String;
  S2: String;
  S3: String;
  i: Integer;
  Param: TBisParam;
begin
  if Assigned(Params) then begin
    for i:=0 to Params.Count-1 do begin
      Param:=Params.Items[i];
      if Param.Empty then
        S1:=SNull
      else S1:=VarToStrDef(Param.Value,'');
      if Length(S1)>MaxValueSize then
        S1:=Copy(S1,1,MaxValueSize)+'...';

      S2:=GetEnumName(TypeInfo(TParamType),Integer(Param.ParamType));
      S3:=GetEnumName(TypeInfo(TFieldType),Integer(Param.DataType));

      LoggerWrite(FormatEx(FSExecuteParam,[Param.ParamName,S2,S3,S1]));
    end;
  end;
end;

procedure TBisCmxSession.DumpParams(Params: TParams);
var
  S: String;
  S1: String;
  S2: String;
  S3: String;
  i: Integer;
  Param: TParam;
begin
  if Assigned(Params) then begin
    for i:=0 to Params.Count-1 do begin
      Param:=Params.Items[i];
      if Param.IsNull then
        S1:=SNull
      else S1:=VarToStrDef(Param.Value,'');
      if Length(S1)>MaxValueSize then
        S1:=Copy(S1,1,MaxValueSize)+'...';

      S:=Param.Name;
      S2:=GetEnumName(TypeInfo(TParamType),Integer(Param.ParamType));
      S3:=GetEnumName(TypeInfo(TFieldType),Integer(Param.DataType));

      LoggerWrite(FormatEx(FSExecuteParam,[S,S2,S3,S1]));
    end;
  end;
end;

function TBisCmxSession.ExecuteOpen(Proc: TBisCmxProc; OpenDataSet: TBisDataSet): TDataSet;
begin
  Result:=Proc;
  if Assigned(Proc) then
    Proc.Open;
end;

procedure TBisCmxSession.Execute(DataSet: TBisDataSet; var QueryText: String);

  procedure SetSessionId(Proc: TBisCmxProc);
  var
    Param: TParam;
  begin
    Param:=Proc.Params.FindParam('SESSION_ID');
    if Assigned(Param) then
      Param.Value:=FSessionId;
  end;

  procedure ExecutePackage(Package: TBisPackageParams);
  var
    i: Integer;
    Proc: TBisCmxProc;
    Params: TBisParams;
    AProvider: String;
  begin
    if Package.Count>0 then begin
      LoggerWrite(FSExecutePackageStart);
      try
        for i:=0 to Package.Count-1 do begin
          Params:=Package.Items[i];
          AProvider:=iff(Trim(Params.ProviderName)<>'',Params.ProviderName,DataSet.ProviderName);
          AProvider:=PreparePrefix(AProvider);
          Proc:=TBisCmxProc.Create(nil);
          try
            Proc.SParamPrefix:=FSParamPrefix;
            Proc.SQLConnection:=FSqlConnection;
            Proc.StoredProcName:=AProvider;

            LoggerWrite(FormatEx(FSExecuteProvider,[AProvider]));

            Proc.SetNullToParamValues;
            SetSessionId(Proc);
            Proc.CopyParamsFrom(Params);
            DumpParams(Proc.Params);

            Proc.ExecProc;

            LoggerWrite(FSExecuteSuccess);
            Proc.CopyParamsTo(Params);
            DumpParams(Params);

            LoggerWrite(FSExecuteSuccess);
          finally
            Proc.Free;
          end;
        end;
      finally
        LoggerWrite(FSExecutePackageEnd);
      end;
    end;
  end;

var
  AllCount: Integer;
  Proc: TBisCmxProc;
  AProvider: String;
  Transaction: TDBXTransaction;
  FromDataSet: TDataSet;
  OpenDataSet: TBisDataSet;
begin
  Lock;
  try
    if Assigned(DataSet) and FSqlConnection.Connected then begin
      LoggerWrite(FSExecuteStart);
      try
        AProvider:=PreparePrefix(DataSet.ProviderName);
        Proc:=TBisCmxProc.Create(nil);
        OpenDataSet:=TBisDataSet.Create(nil);
        try
          Proc.SParamPrefix:=FSParamPrefix;
          Proc.SQLConnection:=FSqlConnection;
          Proc.SchemaName:=FConnection.GetDataBase;
          Proc.StoredProcName:=AProvider;

          LoggerWrite(FormatEx(FSExecuteProvider,[AProvider]));

          Proc.SetNullToParamValues;
          SetSessionId(Proc);
          Proc.CopyParamsFrom(DataSet.Params);
          DumpParams(Proc.Params);

          FromDataSet:=Proc;

          QueryText:=Proc.GetQueryText;

          AllCount:=MaxInt;
          if DataSet.InGetRecords then begin

            FromDataSet:=ExecuteOpen(Proc,OpenDataSet);

            LoggerWrite(FSExecuteSuccess);
            Proc.CopyParamsTo(DataSet.Params);
            DumpParams(DataSet.Params);
          end else begin
            Transaction:=FSqlConnection.BeginTransaction;
            try

              ExecutePackage(DataSet.PackageBefore);

              Proc.ExecProc;

              LoggerWrite(FSExecuteSuccess);
              Proc.CopyParamsTo(DataSet.Params);
              DumpParams(DataSet.Params);

              ExecutePackage(DataSet.PackageAfter);

              FSqlConnection.CommitFreeAndNil(Transaction);
            except
              on E: Exception do begin
                FSqlConnection.RollbackFreeAndNil(Transaction);
                raise;
              end;
            end;
          end;

          CopyData(FromDataSet,DataSet,AllCount);

          LoggerWrite(FSExecuteSuccess);
        finally
          OpenDataSet.Free;
          Proc.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSExecuteFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.LoadInterfaces(Interfaces: TBisInterfaces);
var
  Query: TBisCmxQuery;
  AInterface: TBisInterface;
  S: String;
  ID: String;
  AType: TBisInterfaceType;
  AObjectName: String;
  AScriptId: Variant;
  AReportId: Variant;
  ADocumentId: Variant;
  Sql: String;
begin
  Lock;
  try
    S:=GetRoleIds;
    if Assigned(Interfaces) and FSqlConnection.Connected and (Trim(S)<>'') then begin
      LoggerWrite(FSLoadInterfacesStart);
      try
        Query:=TBisCmxQuery.Create(nil);
        try
          Query.SQLConnection:=FSqlConnection;
          Sql:=FormatEx(FSSqlLoadInterfaces,[QuotedStr(VarToStrDef(FApplicationId,'')),S]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSLoadInterfacesSql,[Sql]));
          Query.SQL.Text:=Sql;
          Query.Open;
          if Query.Active then begin
            Query.FetchAll;
            while not Query.Eof do begin
              ID:=Query.FieldByName('INTERFACE_ID').AsString;
              AType:=TBisInterfaceType(Query.FieldByName('INTERFACE_TYPE').AsInteger);
              AObjectName:=Query.FieldByName('NAME').AsString;
              AInterface:=Interfaces.FindById(ID);
              if not Assigned(AInterface) then begin
                case AType of
                  BisInterfaces.itInternal: begin
                    AInterface:=Interfaces.AddInternal(ID,AObjectName,
                                                       Query.FieldByName('MODULE_NAME').AsString,
                                                       Query.FieldByName('MODULE_INTERFACE').AsString);
                  end;
                  BisInterfaces.itScript: begin
                    AScriptId:=Query.FieldByName('SCRIPT_ID').Value;
                    if not VarIsNull(AScriptId) then
                      AInterface:=Interfaces.AddScript(AScriptId,AObjectName,
                                                       Query.FieldByName('SCRIPT_ENGINE').AsString,
                                                       TBisScriptPlace(Query.FieldByName('SCRIPT_PLACE').AsInteger));
                  end;
                  BisInterfaces.itReport: begin
                    AReportId:=Query.FieldByName('REPORT_ID').Value;
                    if not VarIsNull(AReportId) then
                      AInterface:=Interfaces.AddReport(AReportId,AObjectName,
                                                       Query.FieldByName('REPORT_ENGINE').AsString,
                                                       TBisReportPlace(Query.FieldByName('REPORT_PLACE').AsInteger));
                  end;
                  BisInterfaces.itDocument: begin
                    ADocumentId:=Query.FieldByName('DOCUMENT_ID').Value;
                    if not VarIsNull(ADocumentId) then
                      AInterface:=Interfaces.AddDocument(ADocumentId,AObjectName,
                                                         Query.FieldByName('DOCUMENT_OLE_CLASS').AsString,
                                                         TBisDocumentPlace(Query.FieldByName('DOCUMENT_PLACE').AsInteger));
                  end;
                end;
              end;
              if Assigned(AInterface) then begin
                with AInterface do begin
                  Description:=Query.FieldByName('DESCRIPTION').AsString;
                  InterfaceType:=AType;
                  AutoShow:=Boolean(Query.FieldByName('AUTO_RUN').AsInteger);
                  CheckPermissions(AInterface.ObjectName,AInterface.Permissions);
                end;
              end;
              Query.Next;
            end;
            LoggerWrite(FSLoadInterfacesSuccess);
          end;
        finally
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSLoadInterfacesFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.LoadMenus(Menus: TBisMenus);
var
  Query: TBisCmxQuery;
  Menu: TBisMenu;
  S: String;
  ID: String;
  ParentID: String;
  Stream: TMemoryStream;
  Sql: String;
begin
  Lock;
  try
    S:=GetRoleIds;
    if Assigned(Menus) and FSqlConnection.Connected and (Trim(S)<>'') then begin
      LoggerWrite(FSLoadMenusStart);
      try
        Query:=TBisCmxQuery.Create(nil);
        try
          Query.SQLConnection:=FSqlConnection;
          Sql:=FormatEx(FSSqlLoadMenus,[QuotedStr(VarToStrDef(FApplicationId,'')),S]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSLoadMenusSql,[Sql]));
          Query.SQL.Text:=Sql;
          Query.Open;
          if Query.Active then begin
            Query.FetchAll;
            while not Query.Eof do begin

              ID:=Query.FieldByName('MENU_ID').AsString;
              ParentID:=Query.FieldByName('PARENT_ID').AsString;
              Menu:=Menus.AddByID(ID,ParentID);
              if Assigned(Menu) then begin
                Menu.InterfaceID:=Query.FieldByName('INTERFACE_ID').AsString;
                Menu.Caption:=Query.FieldByName('NAME').AsString;
                Menu.Description:=Query.FieldByName('DESCRIPTION').AsString;
                Menu.ShortCut:=Query.FieldByName('SHORTCUT').AsInteger;
                Menu.Priority:=Query.FieldByName('PRIORITY').AsInteger;
                Stream:=TMemoryStream.Create;
                try
                  TBlobField(Query.FieldByName('PICTURE')).SaveToStream(Stream);
                  Stream.Position:=0;
                  Menu.Picture.LoadFromStream(Stream);
                finally
                  Stream.Free;
                end;
              end;

              Query.Next;
            end;
            LoggerWrite(FSLoadMenusSuccess);
          end;
        finally
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSLoadMenusFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.LoadTasks(Tasks: TBisTasks);
var
  Query: TBisCmxQuery;
  Task: TBisTask;
  S: String;
  ID: String;
  AObjectName: String;
  Sql: String;
begin
  Lock;
  try
    S:=GetRoleIds;
    if Assigned(Tasks) and FSqlConnection.Connected and (Trim(S)<>'') then begin
      LoggerWrite(FSLoadTasksStart);
      try
        Query:=TBisCmxQuery.Create(nil);
        try
          Query.SQLConnection:=FSqlConnection;
          Sql:=FormatEx(FSSqlLoadTasks,[QuotedStr(VarToStrDef(FApplicationId,'')),S]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSSqlLoadTasks,[Sql]));
          Query.SQL.Text:=Sql;
          Query.Open;
          if Query.Active then begin
            Query.FetchAll;
            while not Query.Eof do begin

              ID:=Query.FieldByName('TASK_ID').AsString;
              AObjectName:=Query.FieldByName('NAME').AsString;
              Task:=Tasks.FindByID(ID);
              if not Assigned(Task) then
                Task:=Tasks.Add(ID,AObjectName);
              if Assigned(Task) then begin
                with Task do begin
                  Description:=Query.FieldByName('DESCRIPTION').AsString;
                  Enabled:=Boolean(Query.FieldByName('ENABLED').AsInteger);
                  Priority:=TBisTaskPriority(Query.FieldByName('PRIORITY').AsInteger);
                  Schedule:=TBisTaskSchedule(Query.FieldByName('SCHEDULE').AsInteger);
                  InterfaceID:=Query.FieldByName('INTERFACE_ID').AsString;
                  ProcName:=Query.FieldByName('PROC_NAME').AsString;
                  CommandString:=Query.FieldByName('COMMAND_STRING').AsString;
                  DateBegin:=Query.FieldByName('DATE_BEGIN').AsDateTime;
                  DateEnd:=Query.FieldByName('DATE_END').AsDateTime;
                  DayFrequency:=Query.FieldByName('DAY_FREQUENCY').AsInteger;
                  WeekFrequency:=Query.FieldByName('WEEK_FREQUENCY').AsInteger;
                  Monday:=Boolean(Query.FieldByName('MONDAY').AsInteger);
                  Tuesday:=Boolean(Query.FieldByName('TUESDAY').AsInteger);
                  Wednesday:=Boolean(Query.FieldByName('WEDNESDAY').AsInteger);
                  Thursday:=Boolean(Query.FieldByName('THURSDAY').AsInteger);
                  Friday:=Boolean(Query.FieldByName('FRIDAY').AsInteger);
                  Saturday:=Boolean(Query.FieldByName('SATURDAY').AsInteger);
                  Sunday:=Boolean(Query.FieldByName('SUNDAY').AsInteger);
                  MonthDay:=Query.FieldByName('MONTH_DAY').AsInteger;
                  January:=Boolean(Query.FieldByName('JANUARY').AsInteger);
                  February:=Boolean(Query.FieldByName('FEBRUARY').AsInteger);
                  March:=Boolean(Query.FieldByName('MARCH').AsInteger);
                  April:=Boolean(Query.FieldByName('APRIL').AsInteger);
                  May:=Boolean(Query.FieldByName('MAY').AsInteger);
                  June:=Boolean(Query.FieldByName('JUNE').AsInteger);
                  July:=Boolean(Query.FieldByName('JULY').AsInteger);
                  August:=Boolean(Query.FieldByName('AUGUST').AsInteger);
                  September:=Boolean(Query.FieldByName('SEPTEMBER').AsInteger);
                  October:=Boolean(Query.FieldByName('OCTOBER').AsInteger);
                  November:=Boolean(Query.FieldByName('NOVEMBER').AsInteger);
                  December:=Boolean(Query.FieldByName('DECEMBER').AsInteger);
                  RepeatEnabled:=Boolean(Query.FieldByName('REPEAT_ENABLED').AsInteger);
                  RepeatValue:=Query.FieldByName('REPEAT_VALUE').AsInteger;
                  RepeatType:=TBisTaskRepeat(Query.FieldByName('REPEAT_TYPE').AsInteger);
                  RepeatCount:=Query.FieldByName('REPEAT_COUNT').AsInteger;
                  DateExecute:=Query.FieldByName('DATE_EXECUTE').AsDateTime;
                  ResultString:=Query.FieldByName('RESULT_STRING').AsString;
                end;
              end;
              Query.Next;
            end;
            LoggerWrite(FSLoadTasksSuccess);
          end;
        finally
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSLoadTasksFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.SaveTask(Task: TBisTask);
var
  Query: TBisCmxQuery;
  Sql: String;
begin
  Lock;
  try
    if Assigned(Task) and FSqlConnection.Connected then begin
      LoggerWrite(FSSaveTaskStart);
      try
        Query:=TBisCmxQuery.Create(nil);
        try
          Query.SQLConnection:=FSqlConnection;
          Sql:=FormatEx(FSSqlSaveTask,[QuotedStr(FormatDateTime(FSFormatDateTime,Task.DateExecute)),
                                       QuotedStr(Task.ResultString),QuotedStr(Task.ID)]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSSaveTaskSql,[Sql]));
          Query.SQL.Text:=Sql;
          Query.ExecSQL;
          LoggerWrite(FSSaveTaskSuccess);
        finally
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSSaveTaskFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.LoadAlarms(Alarms: TBisAlarms);
var
  Query: TBisCmxQuery;
  Alarm: TBisAlarm;
  S: String;
  ID: String;
  Sql: String;
begin
  Lock;
  try
    S:=GetRoleIds;
    if Assigned(Alarms) and FSqlConnection.Connected and (Trim(S)<>'') then begin
      LoggerWrite(FSLoadAlarmsStart);
      try
        Query:=TBisCmxQuery.Create(nil);
        try
          Query.SQLConnection:=FSqlConnection;
          Sql:=FormatEx(FSSqlLoadAlarms,[S]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSSqlLoadAlarms,[Sql]));
          Query.SQL.Text:=Sql;
          Query.Open;
          if Query.Active then begin
            Query.FetchAll;
            while not Query.Eof do begin

              ID:=Query.FieldByName('ALARM_ID').AsString;
              Alarm:=Alarms.FindByID(ID);
              if not Assigned(Alarm) then
                Alarm:=Alarms.Add(ID);
              if Assigned(Alarm) then begin
                with Alarm do begin
                  TypeAlarm:=TBisAlarmType(Query.FieldByName('TYPE_ALARM').AsInteger);
                  DateBegin:=Query.FieldByName('DATE_BEGIN').AsDateTime;
                  Caption:=Query.FieldByName('CAPTION').AsString;
                  Text:=Query.FieldByName('TEXT_ALARM').AsString;
                  SenderName:=Query.FieldByName('USER_NAME').AsString;
                end;
              end;
              Query.Next;
            end;
            LoggerWrite(FSLoadAlarmsSuccess);
          end;
        finally
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSLoadAlarmsFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.LoadScript(ScriptId: Variant; Stream: TStream);
var
  Query: TBisCmxQuery;
  FileStream: TFileStream;
  S: String;
  Sql: String;
begin
  Lock;
  try
    if Assigned(Stream) and FSqlConnection.Connected then begin
      LoggerWrite(FSLoadScriptStart);
      try
        Query:=TBisCmxQuery.Create(nil);
        try
          Query.SQLConnection:=FSqlConnection;
          Sql:=FormatEx(FSSqlLoadScript,[QuotedStr(VarToStrDef(ScriptId,''))]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSLoadScriptSql,[Sql]));
          Query.SQL.Text:=Sql;
          Query.Open;
          if Query.Active and not Query.IsEmpty then begin
            if Query.FieldByName('SCRIPT').IsBlob then begin
              case TBisScriptPlace(Query.FieldByName('PLACE').AsInteger) of
                spDatabase: TBlobField(Query.FieldByName('SCRIPT')).SaveToStream(Stream);
                spFileSystem: begin
                  S:=Query.FieldByName('SCRIPT').AsString;
                  if FileExists(S) then begin
                    FileStream:=nil;
                    try
                      FileStream:=TFileStream.Create(S,fmOpenRead);
                      Stream.CopyFrom(FileStream,FileStream.Size);
                    finally
                      FreeAndNilEx(FileStream);
                    end;
                  end;
                end;
              end;
              Stream.Position:=0;
            end;
          end;
          LoggerWrite(FSLoadScriptSuccess);
        finally
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSLoadScriptFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.LoadReport(ReportId: Variant; Stream: TStream);
var
  Query: TBisCmxQuery;
  FileStream: TFileStream;
  S: String;
  Sql: String;
begin
  Lock;
  try
    if Assigned(Stream) and FSqlConnection.Connected then begin
      LoggerWrite(FSLoadReportStart);
      try
        Query:=TBisCmxQuery.Create(nil);
        try
          Query.SQLConnection:=FSqlConnection;
          Sql:=FormatEx(FSSqlLoadReport,[QuotedStr(VarToStrDef(ReportId,''))]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSLoadReportSql,[Sql]));
          Query.SQL.Text:=Sql;
          Query.Open;
          if Query.Active and not Query.IsEmpty then begin
            if Query.FieldByName('REPORT').IsBlob then begin
              case TBisReportPlace(Query.FieldByName('PLACE').AsInteger) of
                rpDatabase: TBlobField(Query.FieldByName('REPORT')).SaveToStream(Stream);
                rpFileSystem: begin
                  S:=Query.FieldByName('REPORT').AsString;
                  if FileExists(S) then begin
                    FileStream:=nil;
                    try
                      FileStream:=TFileStream.Create(S,fmOpenRead);
                      Stream.CopyFrom(FileStream,FileStream.Size);
                    finally
                      FreeAndNilEx(FileStream);
                    end;
                  end;
                end;
              end;
              Stream.Position:=0;
            end;
          end;
          LoggerWrite(FSLoadReportSuccess);
        finally
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSLoadReportFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxSession.LoadDocument(DocumentId: Variant; Stream: TStream);
var
  Query: TBisCmxQuery;
  FileStream: TFileStream;
  S: String;
  Sql: String;
begin
  Lock;
  try
    if Assigned(Stream) and FSqlConnection.Connected then begin
      LoggerWrite(FSLoadDocumentStart);
      try
        Query:=TBisCmxQuery.Create(nil);
        try
          Query.SQLConnection:=FSqlConnection;
          Sql:=FormatEx(FSSqlLoadDocument,[QuotedStr(VarToStrDef(DocumentId,''))]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSLoadDocumentSql,[Sql]));
          Query.SQL.Text:=Sql;
          Query.Open;
          if Query.Active and not Query.IsEmpty then begin
            if Query.FieldByName('DOCUMENT').IsBlob then begin
              case TBisDocumentPlace(Query.FieldByName('PLACE').AsInteger) of
                dpDatabase: TBlobField(Query.FieldByName('DOCUMENT')).SaveToStream(Stream);
                dpFileSystem: begin
                  S:=Query.FieldByName('DOCUMENT').AsString;
                  if FileExists(S) then begin
                    FileStream:=nil;
                    try
                      FileStream:=TFileStream.Create(S,fmOpenRead);
                      Stream.CopyFrom(FileStream,FileStream.Size);
                    finally
                      FreeAndNilEx(FileStream);
                    end;
                  end;
                end;
              end;
              Stream.Position:=0;
            end;
          end;
          LoggerWrite(FSLoadDocumentSuccess);
        finally
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSLoadDocumentFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

{ TBisCmxSessions }

constructor TBisCmxSessions.Create(AConnection: TBisCmxConnection);
begin
  inherited Create;
  FConnection:=AConnection;
end;

destructor TBisCmxSessions.Destroy;
begin
  inherited Destroy;
end;

function TBisCmxSessions.GetSessionClass: TBisCmxSessionClass;
begin
  Result:=TBisCmxSession;
end;

function TBisCmxSessions.GetItems(Index: Integer): TBisCmxSession;
begin
  Result:=TBisCmxSession(inherited Items[Index]);
end;

function TBisCmxSessions.Add(SessionId: Variant; DateCreate: TDateTime;
                             ApplicationId, AccountId: Variant; UserName, Password: String;
                             DbUserName, DbPassword: String; SessionParams, IPList: String;
                             IsNew: Boolean): TBisCmxSession;
var
  Session: TBisCmxSession;
  Index: Integer;
  OverrideUserName: String;
begin
  Result:=nil;
  if Assigned(FConnection) then begin
    try
      Session:=GetSessionClass.Create(Self);
      if Assigned(Session) then begin
        Session.SessionId:=SessionId;
        Session.DateCreate:=DateCreate;
        Session.ApplicationId:=ApplicationId;
        Session.AccountId:=AccountId;
        Session.UserName:=UserName;
        Session.Password:=Password;

        with Session.SqlConnection do begin
          CopyFrom(FConnection.RealDefaultConnection);
          UserName:=DbUserName;
          Password:=DbPassword;
          ConnectionName:=VarToStrDef(SessionId,'');


          Index:=Params.IndexOfName(FSSchemaOverride);
          if Index<>-1 then begin
            OverrideUserName:=FConnection.RealDefaultConnection.UserName;
      //      Params.Values[FSSchemaOverride]:=FormatEx(FSFormatSchemaName,[OverrideUserName]);
          end;

          ParamsLoaded:=true;
          Connected:=true;
        end;
        Session.SqlConnection.AutoClone:=false;

        Session.Params.Text:=SessionParams;
        Session.IPList.Text:=IPList;

        Session.Connection:=FConnection;
        if IsNew then begin
          Session.Insert;
          Session.LoadRoles;
          Session.LoadPermissions;
          Session.LoadLocks;
        end;

        inherited Add(Session);
        Result:=Session;
      end;
    except
      on E: Exception do begin
        FreeAndNilEx(Session);
        raise;
      end;
    end;
  end;
end;

function TBisCmxSessions.Find(SessionId: Variant): TBisCmxSession;
var
  i: Integer;
  Item: TBisCmxSession;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if VarSameValue(Item.SessionId,SessionId) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

procedure TBisCmxSessions.Remove(Session: TBisCmxSession; WithDelete: Boolean);
begin
  if Assigned(Session) then begin
    if WithDelete then
      Session.Delete;
    inherited Remove(Session);
  end;
end;

procedure TBisCmxSessions.CopyFrom(Source: TBisCmxSessions; IsClear: Boolean);
var
  i: Integer;
  Item: TBisCmxSession;
  Session: TBisCmxSession;
begin
  if IsClear then
    Clear;
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Item:=Source.Items[i];
      Session:=Find(Item.SessionId);
      if not Assigned(Session) then begin
        Session:=Add(Item.SessionId,Item.DateCreate,Item.ApplicationId,
                     Item.AccountId,Item.UserName,Item.Password,
                     Item.SqlConnection.UserName,Item.SqlConnection.Password,
                     Item.Params.Text,Item.IPList.Text,false);
        if Assigned(Session) then begin
          Session.Roles.Text:=Item.Roles.Text;
          Session.Permissions.CreateTable(Item.Permissions);
          Session.Permissions.CopyRecords(Item.Permissions);
          Session.Locks.CreateTable(Item.Locks);
          Session.Locks.CopyRecords(Item.Locks);
        end;
      end;
    end;
  end;
end;

{ TBisCmxConnection }

constructor TBisCmxConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InitializeCriticalSection(FLock);
  Params.OnChange:=ChangeParams;

  FDefaultConnection:=TBisCmxSqlConnection.Create(Self);
  FDefaultConnection.LoadParamsOnConnect:=false;
  FDefaultConnection.AutoClone:=false;

  FLinkedDefaultConnection:=nil;

  FSessions:=GetSessionsClass.Create(Self);

  Core.ExceptNotifier.IngnoreExceptions.Add(TDBXError);

{  FSExecSqlStart:='������ ���������� ������� ...';
  FSExecSqlSql:='����� ������� => %s';
  FSExecSqlSuccess:='������ �������� �������.';
  FSExecSqlFail:='������ �� ��������. %s';}

  FSImportScriptStart:='������ ���������� ������� ������� ...';
  FSImportScriptSql:='����� ������� => %s';
  FSImportScriptSuccess:='������ ������� �������� �������.';
  FSImportScriptFail:='������ ������� �� ��������. %s';

  FSImportTableStart:='������ ���������� ������� ������� ...';
  FSImportTableSql:='����� ������� => %s';
  FSImportTableSuccess:='������ ������� �������� �������.';
  FSImportTableEmpty:='������� �� �������� ��� ������.';
  FSImportTableFail:='������ ������� �� ��������. %s';
  FSImportTableParam:='�������� => %s ��� ��������� => %s ��� ������ => %s �������� => %s';


end;

destructor TBisCmxConnection.Destroy;
begin
  FSessions.Free;
  FLinkedDefaultConnection:=nil;
  FDefaultConnection.Free;
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

function TBisCmxConnection.GetSessionsClass: TBisCmxSessionsClass;
begin
  Result:=TBisCmxSessions;
end;

procedure TBisCmxConnection.Lock;
begin
  EnterCriticalSection(FLock);
  FWorking:=true;
end;

procedure TBisCmxConnection.UnLock;
begin
  LeaveCriticalSection(FLock);
  FWorking:=false;
end;

function TBisCmxConnection.CloneConnection(const SessionId: Variant; WithDefault: Boolean=true): TBisConnection;
var
  Clone: TBisCmxConnection;
  Item, Session: TBisCmxSession;
begin
  Result:=inherited CloneConnection(SessionId);
  if Assigned(Result) and (Result is TBisCmxConnection) then begin
    Clone:=TBisCmxConnection(Result);
    if WithDefault then begin
      Clone.FDefaultConnection.CopyFrom(FDefaultConnection);
      Clone.FDefaultConnection.Connected:=FDefaultConnection.Connected;
      Clone.FLinkedDefaultConnection:=nil;
    end else
      Clone.FLinkedDefaultConnection:=FDefaultConnection;
    Item:=FSessions.Find(SessionId);
    if Assigned(Item) then begin
      Session:=Clone.Sessions.Add(Item.SessionId,Item.DateCreate,Item.ApplicationId,
                                  Item.AccountId,Item.UserName,Item.Password,
                                  Item.SqlConnection.UserName,Item.SqlConnection.Password,
                                  Item.Params.Text,Item.IPList.Text,false);
      if Assigned(Session) then begin
        Session.Roles.Text:=Item.Roles.Text;
        Session.Permissions.CreateTable(Item.Permissions);
        Session.Permissions.CopyRecords(Item.Permissions);
        Session.Locks.CreateTable(Item.Locks);
        Session.Locks.CopyRecords(Item.Locks);
      end;
    end;
  end;
end;

procedure TBisCmxConnection.RemoveConnection(Connection: TBisConnection; const SessionId: Variant; IsLogout: Boolean);
var
  Session: TBisCmxSession;
begin
  if Assigned(Connection) and (Connection is TBisCmxConnection) and (Connection<>Self) then begin
    if IsLogout then begin
      Session:=FSessions.Find(SessionId);
      if Assigned(Session) then
        FSessions.Remove(Session,false);
    end else
      FSessions.CopyFrom(TBisCmxConnection(Connection).Sessions,false);
  end;
  inherited RemoveConnection(Connection,SessionId,IsLogout);
end;


procedure TBisCmxConnection.ChangeParams(Sender: TObject);
var
  Str: TStringList;
  i: Integer;
  Param: TBisConnectionParam;
  Flag: Boolean;
begin
  Str:=TStringList.Create;
  try
    for i:=0 to Params.Count-1 do begin
      Param:=Params.Items[i];
      Flag:=true;
      if AnsiSameText(Param.ParamName,SDBParamDriverName) then begin
        FDefaultConnection.DriverName:=Param.Value;
        Flag:=false;
      end;
      if AnsiSameText(Param.ParamName,SDBParamLibraryName) then begin
        FDefaultConnection.LibraryName:=Param.Value;
        Flag:=false;
      end;
      if AnsiSameText(Param.ParamName,SDBParamVendorLib) then begin
        FDefaultConnection.VendorLib:=Param.Value;
        Flag:=false;
      end;
      if AnsiSameText(Param.ParamName,SDBParamGetDriverFunc) then begin
        FDefaultConnection.GetDriverFunc:=Param.Value;
        Flag:=false;
      end;
      if Flag then
        Str.Add(FormatEx('%s=%s',[Param.ParamName,Param.Value]));
    end;
    FDefaultConnection.Params.Text:=Str.Text;
    FDefaultConnection.ParamsLoaded:=true;
  finally
    Str.Free;
  end;
end;

function TBisCmxConnection.GetDataBase: String;
var
  Param: TBisConnectionParam;
begin
  Result:='';
  Param:=Params.Find(SDBParamDatabase);
  if Assigned(Param) then
    Result:=Param.Value;
end;

function TBisCmxConnection.GetPrefix: String;
var
  Param: TBisConnectionParam;
begin
  Result:='';
  Param:=Params.Find(SDBParamPrefix);
  if Assigned(Param) then
    Result:=Param.Value;
end;

function TBisCmxConnection.PreparePrefix(AName: String): String;
begin
  Result:=Format('%s%s',[GetPrefix,AName]);
end;

procedure TBisCmxConnection.Init;
begin
  inherited Init;
  ChangeParams(Params);
end;

function TBisCmxConnection.GetDbUserName(UserName, Password: String;
                                         var AccountId, FirmId, FirmSmallName: Variant; var DbUserName, DbPassword: String): Boolean;
var
  Query: TBisCmxQuery;
  Sql: String;
  AAccountId: String;
  NewPass: String;
  MD: String;
begin
  Lock;
  try
    Result:=false;
    if RealDefaultConnection.Connected then begin
      Query:=TBisCmxQuery.Create(nil);
      try
        Query.SQLConnection:=RealDefaultConnection;
        Sql:=FormatEx(FSSqlGetDbUserName,[QuotedStr(AnsiUpperCase(UserName))]);
        Query.SQL.Text:=ReplaceText(Sql,SPrefix,GetPrefix);
        Query.Open;
        if Query.Active and not Query.IsEmpty then begin
          NewPass:=Query.FieldByName('PASSWORD').AsString;
          AAccountId:=Query.FieldByName('ACCOUNT_ID').AsString;
          MD:=MD5(AAccountId+Password+AAccountId);
          if (NewPass=Password) or AnsiSameText(NewPass,MD) then begin
            AccountId:=Query.FieldByName('ACCOUNT_ID').Value;
            FirmId:=Query.FieldByName('FIRM_ID').Value;
            FirmSmallName:=Query.FieldByName('FIRM_SMALL_NAME').Value;
            DbUserName:=Query.FieldByName('DB_USER_NAME').AsString;
            DbPassword:=Query.FieldByName('DB_PASSWORD').AsString;
            Result:=true;
          end;
        end;
      finally
        Query.Free;
      end;
    end;
  finally
    Unlock;
  end;
end;

function TBisCmxConnection.ApplicationExists(ApplicationId, AccountId: Variant): Boolean;
var
  Query: TBisCmxQuery;
  Sql: String;
begin
  Lock;
  try
    Result:=false;
    if RealDefaultConnection.Connected then begin
      Query:=TBisCmxQuery.Create(nil);
      try
        Query.SQLConnection:=RealDefaultConnection;
        Sql:=FormatEx(FSSqlApplicationExists,[QuotedStr(VarToStrDef(ApplicationId,'')),QuotedStr(VarToStrDef(AccountId,''))]);
        Query.SQL.Text:=ReplaceText(Sql,SPrefix,GetPrefix);
        Query.Open;
        if Query.Active and not Query.IsEmpty then begin
          Result:=not Boolean(Query.FieldByName('LOCKED').AsInteger);
        end;
      finally
        Query.Free;
      end;
    end;
  finally
    Unlock;
  end;
end;

function TBisCmxConnection.SessionExists(SessionId: Variant): Boolean;
var
  Query: TBisCmxQuery;
  Sql: String;
begin
  Lock;
  try
    Result:=false;
    if RealDefaultConnection.Connected then begin
      Query:=TBisCmxQuery.Create(nil);
      try
        Query.SQLConnection:=RealDefaultConnection;
        Sql:=FormatEx(FSSqlSessionExists,[QuotedStr(VarToStrDef(SessionId,''))]);
        Query.SQL.Text:=ReplaceText(Sql,SPrefix,GetPrefix);
        Query.Open;
        Result:=Query.Active and not Query.IsEmpty;
      finally
        Query.Free;
      end;
    end;
  finally
    Unlock;
  end;
end;

function TBisCmxConnection.SessionFind(SessionId: Variant): TBisCmxSession;
var
  Exists: Boolean;
begin
  Exists:=SessionExists(SessionId);
  Result:=FSessions.Find(SessionId);
  if not Exists and Assigned(Result) then begin
    FSessions.Remove(Result,true);
    Result:=nil;
  end;
end;

function TBisCmxConnection.GetFieldNameQuote: String;
begin
  Result:=FSFieldNameQuote;
end;

function TBisCmxConnection.GetRecordsFilterDateValue(Value: TDateTime): String;
var
  D: TDate;
begin
  D:=DateOf(Value);
  if D<>Value then
    Result:=FormatEx(FSFormatFilterDateValue,[QuotedStr(FormatDateTime(FSFormatDateTimeValue,Value))])
  else
    Result:=FormatEx(FSFormatFilterDateValue,[QuotedStr(FormatDateTime(FSFormatDateValue,Value))]);
end;

function TBisCmxConnection.GetConnected: Boolean;
begin
  Result:=RealDefaultConnection.Connected;
end;

function TBisCmxConnection.GetWorking: Boolean;
begin
  Result:=FWorking;
end;

procedure TBisCmxConnection.Connect;
begin
  Lock;
  try
    inherited Connect;
    try
      RealDefaultConnection.Connected:=false;
      RealDefaultConnection.Connected:=true;
    except
      On E: Exception do
        raise EBisConnection.CreateFmt(ECConnectFailed,SConnectFailed,[E.Message]);
    end;
  finally
    UnLock;
  end;
end;

procedure TBisCmxConnection.Disconnect;
begin
  Lock;
  try
    inherited Disconnect;
    try
      if FSessions.Count=0 then
        RealDefaultConnection.Connected:=false;
    except
      On E: Exception do
        raise EBisConnection.CreateFmt(E�DisconnectFailed,SDisconnectFailed,[E.Message]);
    end;
  finally
    UnLock;
  end;
end;

function TBisCmxConnection.GetTableName(SQL: String; var Where: String): String;
var
  APos: Integer;
  i: Integer;
  Ch: Char;
const
  Chars=[' ',#13,#10,#0];
begin
  Result:='';
  APos:=Pos(UpperCase(SFrom),UpperCase(SQL));
  if APos>0 then begin
    Result:=Copy(SQL,APos+Length(SFrom)+1,Length(SQL));
    for i:=1 to Length(Result) do begin
      Ch:=Result[i];
      if Ch in Chars then begin
        Result:=Copy(Result,1,i-1);
        Result:=Trim(Result);
        break;
      end;
    end;
  end;
  APos:=Pos(UpperCase(SWhere),UpperCase(SQL));
  if APos>0 then begin
    Where:=Copy(SQL,APos+Length(SWhere)+1,Length(SQL));
  end;
end;

procedure TBisCmxConnection.ImportScript(Stream: TStream);
var
  Query: TBisCmxQuery;
  SQL: String;
begin
  Lock;
  try
    if (Stream.Size>0) and RealDefaultConnection.Connected then begin
      Stream.Position:=0;
      SetLength(SQL,Stream.Size);
      Stream.ReadBuffer(Pointer(SQL)^,Stream.Size);
      if Trim(SQL)<>'' then begin
        LoggerWrite(FSImportScriptStart);
        try
          Query:=TBisCmxQuery.Create(nil);
          try
            Query.SQLConnection:=RealDefaultConnection;
            Query.ParamCheck:=false;
            SQL:=Trim(SQL);
            LoggerWrite(FormatEx(FSImportScriptSql,[SQL]));
            Query.SQL.Text:=ReplaceText(SQL,SPrefix,GetPrefix);;
            Query.ExecSQL;
            LoggerWrite(FSImportScriptSuccess);
          finally
            Query.Free;
          end;
        except
          On E: Exception do begin
            LoggerWrite(FormatEx(FSImportScriptFail,[E.Message]),ltError);
            raise;
          end;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxConnection.ImportTable(Stream: TStream);

  procedure GetKeys(TableName: String; Keys: TStrings);
  var
    Query: TBisCmxQuery;
    SQL: String;
  begin
    Query:=TBisCmxQuery.Create(nil);
    try
      Query.SQLConnection:=RealDefaultConnection;
      SQL:=FormatEx(FSSQLGetKeys,[QuotedStr(PreparePrefix(TableName)),QuotedStr(GetDataBase)]);
      SQL:=ReplaceText(SQL,SPrefix,GetPrefix);
      Query.SQL.Text:=SQL;
      Query.Open;
      if Query.Active and not Query.IsEmpty then begin
        Query.First;
        while not Query.Eof do begin
          Keys.Add(Trim(Query.Fields[0].AsString));
          Query.Next;
        end;
      end;
    finally
      Query.Free;
    end;
  end;

  procedure DumpParams(Params: TParams);
  var
    S: String;
    S1: String;
    S2: String;
    S3: String;
    i: Integer;
    Param: TParam;
  begin
    if Assigned(Params) then begin
      for i:=0 to Params.Count-1 do begin
        Param:=Params.Items[i];
        if Param.IsNull then
          S1:=SNull
        else S1:=VarToStrDef(Param.Value,'');
        if Length(S1)>MaxValueSize then
          S1:=Copy(S1,1,MaxValueSize)+'...';

        S:=Param.Name;
        S2:=GetEnumName(TypeInfo(TParamType),Integer(Param.ParamType));
        S3:=GetEnumName(TypeInfo(TFieldType),Integer(Param.DataType));

        LoggerWrite(FormatEx(FSImportTableParam,[S,S2,S3,S1]));
      end;
    end;
  end;

  function TryInsert(DataSet: TBisDataSet; var Error: String): Boolean;
  var
    Query: TBisCmxQuery;
    i: Integer;
    Field: TField;
    Fields: String;
    Values: String;
    Param: TParam;
    SQL: String;
  begin
    Result:=false;
    try
      Query:=TBisCmxQuery.Create(nil);
      try
        Query.SQLConnection:=RealDefaultConnection;
        Query.ParamCheck:=true;
        for i:=0 to DataSet.FieldCount-1 do begin
          Field:=DataSet.Fields[i];
          if i=0 then begin
            Fields:=FSFieldNameQuote+Field.FieldName+FSFieldNameQuote;
            Values:=':'+Field.FieldName;
          end else begin
            Fields:=Fields+','+FSFieldNameQuote+Field.FieldName+FSFieldNameQuote;
            Values:=Values+',:'+Field.FieldName;
          end;
        end;
        SQL:=FormatEx(FSSqlInsert,[PreparePrefix(DataSet.TableName),Fields,Values]);
        SQL:=ReplaceText(SQL,SPrefix,GetPrefix);
        LoggerWrite(FormatEx(FSImportTableSql,[SQL]));
        Query.SQL.Text:=SQL;
        for i:=0 to Query.Params.Count-1 do begin
          Param:=Query.Params[i];
          Field:=DataSet.FindField(Param.Name);
          if Assigned(Field) then begin
            Param.DataType:=Field.DataType;
            case Param.DataType of
              ftDateTime: Param.DataType:=ftTimeStamp;   // ??? Interbase
            end;
            Param.Value:=Field.Value;
          end;
        end;
        DumpParams(Query.Params);
        Query.ExecSQL;
        Result:=true;
      finally
        Query.Free;
      end;
    except
      On E: Exception do begin
        Error:=E.Message;
      end;
    end;
  end;

  function TryUpdate(DataSet: TBisDataSet; Keys: TStringList; var Error: String): Boolean;
  var
    Query: TBisCmxQuery;
    i: Integer;
    Field: TField;
    FieldValues: String;
    Condition: String;
    Param: TParam;
    SQL: String;
  begin
    Result:=false;
    try
      Query:=TBisCmxQuery.Create(nil);
      try
        Query.SQLConnection:=RealDefaultConnection;
        Query.ParamCheck:=true;
        for i:=0 to DataSet.FieldCount-1 do begin
          Field:=DataSet.Fields[i];
          if i=0 then begin
            FieldValues:=FSFieldNameQuote+Field.FieldName+FSFieldNameQuote;
          end else begin
            FieldValues:=FieldValues+','+FSFieldNameQuote+Field.FieldName+FSFieldNameQuote;
          end;
          FieldValues:=FieldValues+'=:'+Field.FieldName;
        end;
        for i:=0 to Keys.Count-1 do begin
          if i=0 then
            Condition:=FSFieldNameQuote+Keys[i]+FSFieldNameQuote
          else
            Condition:=Condition+' '+GetRecordsFilterOperator(foAnd)+' '+FSFieldNameQuote+Keys[i]+FSFieldNameQuote;
          Condition:=Condition+'=:'+Keys[i];
        end;
        SQL:=FormatEx(FSSqlUpdate,[PreparePrefix(DataSet.TableName),FieldValues,Condition]);
        SQL:=ReplaceText(SQL,SPrefix,GetPrefix);
        LoggerWrite(FormatEx(FSImportTableSql,[SQL]));
        Query.SQL.Text:=SQL;
        for i:=0 to Query.Params.Count-1 do begin
          Param:=Query.Params[i];
          Field:=DataSet.FindField(Param.Name);
          if Assigned(Field) then begin
            Param.DataType:=Field.DataType;
            case Param.DataType of
              ftDateTime: Param.DataType:=ftTimeStamp;   // ??? Interbase
            end;
            Param.Value:=Field.Value;
          end;
        end;
//        DumpParams(Query.Params);
        Query.ExecSQL;
        Result:=true;
      finally
        Query.Free;
      end;
    except
      On E: Exception do begin
        Error:=E.Message;
      end;
    end;
  end;

var
  DataSet: TBisDataSet;
  Error: String;
  Keys: TStringList;
begin
  Lock;
  try
    if (Stream.Size>0) and RealDefaultConnection.Connected then begin
      LoggerWrite(FSImportTableStart);
      try
        DataSet:=TBisDataSet.Create(nil);
        Keys:=TStringList.Create;
        try
          DataSet.LoadFromStream(Stream);
          DataSet.Open;
          if DataSet.Active and not DataSet.Empty then begin
            GetKeys(DataSet.TableName,Keys);
            DataSet.First;
            while not DataSet.Eof do begin

              Error:='';
              if not TryInsert(DataSet,Error) then
                if not TryUpdate(DataSet,Keys,Error) then
                  raise Exception.Create(Error);

              DataSet.Next;
            end;
            LoggerWrite(FSImportTableSuccess);
          end else
            LoggerWrite(FSImportTableEmpty);
        finally
          Keys.Free;
          DataSet.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSImportTableFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxConnection.Import(ImportType: TBisConnectionImportType; Stream: TStream);
begin
  Lock;
  try
    inherited Import(ImportType,Stream);
    try
      if Assigned(Stream) then begin
        case ImportType of
          itScript: ImportScript(Stream);
          itTable: ImportTable(Stream);
        end;
      end;
    except
      on E: Exception do
        raise EBisConnection.CreateFmt(ECImportFailed,SImportFailed,[E.Message]);
    end;
  finally
    UnLock;
  end;
end;

procedure TBisCmxConnection.ExportScript(const Value: String; Stream: TStream; Params: TBisConnectionExportParams=nil);
begin
end;

procedure TBisCmxConnection.ExportTable(const Value: String; Stream: TStream; Params: TBisConnectionExportParams=nil);
var
  Query: TBisCmxQuery;
  DataSet: TBisDataSet;
  TableName: String;
  Where: String;
  FromPos, FetchCount: Integer;
  Position: Integer;
begin
  Lock;
  try
    try
      if RealDefaultConnection.Connected then begin
        Query:=TBisCmxQuery.Create(nil);
        DataSet:=TBisDataSet.Create(nil);
        try
          FromPos:=0;
          FetchCount:=MaxInt;
          if Assigned(Params) then begin
            FromPos:=Params.FromPosition;
            if FromPos<0 then
              FromPos:=0;
            FetchCount:=Params.FetchCount;
            if FetchCount<0 then
              FetchCount:=MaxInt;
          end;
          Query.SQLConnection:=RealDefaultConnection;
          Query.Sql.Text:=Value;
          Query.Open;
          if Query.Active then begin
            TableName:=GetTableName(Value,Where);
            Position:=0;
            Query.First;
            DataSet.CreateTable(Query);
            while not Query.Eof do begin
              if Position>=FromPos then begin
                if Position<(FromPos+FetchCount) then
                  DataSet.CopyRecord(Query,true,true)
                else
                  break;
              end;
              Inc(Position);
              Query.Next;
            end;
            DataSet.TableName:=TableName;
            DataSet.SaveToStream(Stream);
          end;
        finally
          DataSet.Free;
          Query.Free;
        end;
      end;
    except
      On E: Exception do begin
        raise;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisCmxConnection.Export(ExportType: TBisConnectionExportType; const Value: String;
                                   Stream: TStream; Params: TBisConnectionExportParams=nil);
begin
  Lock;
  try
    inherited Export(ExportType,Value,Stream,Params);
    try
      if Assigned(Stream) then begin
        case ExportType of
          etScript: ExportScript(Value,Stream,Params);
          etTable: ExportTable(Value,Stream,Params);
        end;
      end;
    except
      on E: Exception do
        raise EBisConnection.CreateFmt(ECExportFailed,SExportFailed,[E.Message]);
    end;
  finally
    UnLock;
  end;
end;

function TBisCmxConnection.GetInternalServerDate: TDateTime;
var
  Query: TBisCmxQuery;
  Sql: String;
  Value: Variant;
begin
  Lock;
  try
    Result:=Now;
    if RealDefaultConnection.Connected then begin
      Query:=TBisCmxQuery.Create(nil);
      try
        Query.SQLConnection:=RealDefaultConnection;
        Sql:=FSSqlGetServerDate;
        Query.SQL.Text:=ReplaceText(Sql,SPrefix,GetPrefix);
        Query.Open;
        if Query.Active and not Query.IsEmpty then begin
          Value:=Query.Fields[0].Value;
          if not VarIsNull(Value) then
            Result:=VarToDateDef(Value,Result);
        end;
      finally
        Query.Free;
      end;
    end;
  finally
    UnLock;
  end;
end;

function TBisCmxConnection.GetServerDate: TDateTime;
begin
  try
    Result:=GetInternalServerDate;
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECGetServerDateFailed,SGetServerDateFailed,[E.Message]);
  end;
end;

function TBisCmxConnection.Login(const ApplicationId: Variant; const UserName,Password: String; Params: TBisConnectionLoginParams=nil): Variant;
var
  UserDefault: Boolean;
  AccountId: Variant;
  FirmId: Variant;
  FirmSmallName: Variant;
  DbUserName: String;
  DbPassword: String;
  ASession: TBisCmxSession;
  SessionParams, IPList: String;
begin
  try
    if GetDbUserName(UserName,Password,AccountId,FirmId,FirmSmallName,DbUserName,DbPassword) then begin
      if ApplicationExists(ApplicationId,AccountId) then begin
        UserDefault:=(Trim(DbUserName)='') or
                     AnsiSameText(RealDefaultConnection.UserName,DbUserName);
        if UserDefault then begin
          DbUserName:=RealDefaultConnection.UserName;
          DbPassword:=RealDefaultConnection.Password;
        end;

        if Assigned(Params) then begin
          SessionParams:=Params.SessionParams.Text;
          IPList:=Params.IPList.Text;
        end;
        
        ASession:=FSessions.Add(GetUniqueID,GetInternalServerDate,
                                ApplicationId,AccountId,UserName,Password,
                                DbUserName,DbPassword,SessionParams,IPList,true);
        if Assigned(ASession) then begin
          try
            if Assigned(Params) then begin
              Params.AccountId:=AccountId;
              Params.FirmId:=FirmId;
              Params.FirmSmallName:=FirmSmallName;
            end;
          
            ASession.CheckLocks(SLogin);
            Result:=ASession.SessionId;
          except
            on E: Exception do begin
              FSessions.Remove(ASession,true);
              raise;
            end;
          end;
        end else
          raise Exception.Create(SSessionCreateFailed);

      end else
        raise Exception.Create(SApplicationNotFoundOrLocked);

    end else
      raise Exception.CreateFmt(SAccountNotFoundOrLocked,[UserName]);

  except
    On E: Exception do
      raise EBisConnection.CreateFmt(ECLoginFailed,SLoginFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.Logout(const SessionId: Variant);
var
  ASession: TBisCmxSession;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) then begin
      ASession.Update;
      ASession.CheckLocks(SLogout);
      FSessions.Remove(ASession,true);
    end;
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLogoutFailed,SLogoutFailed,[E.Message]);
  end;
end;

function TBisCmxConnection.Check(const SessionId: Variant; var ServerDate: TDateTime): Boolean;
var
  ASession: TBisCmxSession;
begin
  try
    ASession:=SessionFind(SessionId);
    Result:=Assigned(ASession);
    if Result then
      ServerDate:=GetInternalServerDate;
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECCheckFailed,SCheckFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.Update(const SessionId: Variant; Params: TBisConfig=nil);
var
  ASession: TBisCmxSession;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) then begin
      ASession.Params.CopyFrom(Params);
      ASession.Update(Assigned(Params));
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECUpdateFailed,SUpdateFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.LoadProfile(const SessionId: Variant; Profile: TBisProfile);
var
  ASession: TBisCmxSession;
  T: TTime;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Profile) then begin
      T:=Time;
      try
        ASession.CheckLocks(SLoadProfile);
        ASession.LoadProfile(Profile);
      finally
        ASession.Update(False,'',MilliSecondsBetween(Time,T));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadProfileFailed,SLoadProfileFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.SaveProfile(const SessionId: Variant; Profile: TBisProfile);
var
  ASession: TBisCmxSession;
  T: TTime;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Profile) then begin
      T:=Time;
      try
        ASession.CheckLocks(SSaveProfile);
        ASession.SaveProfile(Profile);
      finally
        ASession.Update(False,'',MilliSecondsBetween(Time,T));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECSaveProfileFailed,SSaveProfileFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.RefreshPermissions(const SessionId: Variant);
var
  ASession: TBisCmxSession;
  T: TTime;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) then begin
      T:=Time;
      try
        ASession.CheckLocks(SRefreshPermissions);
        ASession.LoadRoles;
        ASession.LoadPermissions;
      finally
        ASession.Update(False,'',MilliSecondsBetween(Time,T));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECRefreshPermissionsFailed,SRefreshPermissionsFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.LoadInterfaces(const SessionId: Variant; Interfaces: TBisInterfaces);
var
  ASession: TBisCmxSession;
  T: TTime;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Interfaces) then begin
      T:=Time;
      try
        ASession.CheckLocks(SLoadInterfaces);
        ASession.LoadInterfaces(Interfaces);
      finally
        ASession.Update(False,'',MilliSecondsBetween(Time,T));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadInterfacesFailed,SLoadInterfacesFailed,[E.Message]);
  end;
end;

function TBisCmxConnection.GetRealDefaultConnection: TBisCmxSqlConnection;
begin
  Result:=FDefaultConnection;
  if Assigned(FLinkedDefaultConnection) then
    Result:=FLinkedDefaultConnection;
end;

procedure TBisCmxConnection.GetRecords(const SessionId: Variant; DataSet: TBisDataSet);
var
  ASession: TBisCmxSession;
  Query: String;
  T: TTime;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(DataSet) then begin
      T:=Time;
      try
        ASession.CheckLocks(SGetRecords,DataSet.ProviderName);
        ASession.GetRecords(DataSet,Query);
      finally
        ASession.Update(false,Query,MilliSecondsBetween(Time,T));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECGetRecordsFailed,SGetRecordsFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.Execute(const SessionId: Variant; DataSet: TBisDataSet);
var
  ASession: TBisCmxSession;
  Query: String;
  T: TTime;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(DataSet) then begin
      T:=Time;
      try
        ASession.CheckLocks(SExecute,DataSet.ProviderName);
        ASession.Execute(DataSet,Query);
      finally
        ASession.Update(False,Query,MilliSecondsBetween(Time,T));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECExecuteFailed,SExecuteFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.LoadMenus(const SessionId: Variant; Menus: TBisMenus);
var
  ASession: TBisCmxSession;
  T: TTime;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Menus) then begin
      T:=Time;
      try
        ASession.CheckLocks(SLoadMenus);
        ASession.LoadMenus(Menus);
      finally
        ASession.Update(False,'',MilliSecondsBetween(Time,T));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadMenusFailed,SLoadMenusFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.LoadTasks(const SessionId: Variant; Tasks: TBisTasks);
var
  ASession: TBisCmxSession;
  T: TTime;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Tasks) then begin
      T:=Time;
      try
        ASession.CheckLocks(SLoadTasks);
        ASession.LoadTasks(Tasks);
      finally
        ASession.Update(False,'',MilliSecondsBetween(Time,T));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadTasksFailed,SLoadTasksFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.SaveTask(const SessionId: Variant; Task: TBisTask);
var
  ASession: TBisCmxSession;
  T: TTime;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Task) then begin
      T:=Time;
      try
        ASession.CheckLocks(SSaveTask);
        ASession.SaveTask(Task);
      finally
        ASession.Update(False,'',MilliSecondsBetween(Time,T));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECSaveTaskFailed,SSaveTaskFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.LoadAlarms(const SessionId: Variant; Alarms: TBisAlarms);
var
  ASession: TBisCmxSession;
  T: TTime;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Alarms) then begin
      T:=Time;
      try
        ASession.CheckLocks(SLoadAlarms);
        ASession.LoadAlarms(Alarms);
      finally
        ASession.Update(False,'',MilliSecondsBetween(Time,T));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadAlarmsFailed,SLoadAlarmsFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.LoadScript(const SessionId: Variant; ScriptId: Variant; Stream: TStream);
var
  ASession: TBisCmxSession;
  T: TTime;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Stream) then begin
      T:=Time;
      try
        ASession.CheckLocks(SLoadScript);
        ASession.LoadScript(ScriptId,Stream);
      finally
        ASession.Update(False,'',MilliSecondsBetween(Time,T));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadScriptFailed,SLoadScriptFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.LoadReport(const SessionId: Variant; ReportId: Variant; Stream: TStream);
var
  ASession: TBisCmxSession;
  T: TTime;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Stream) then begin
      T:=Time;
      try
        ASession.CheckLocks(SLoadReport);
        ASession.LoadReport(ReportId,Stream);
      finally
        ASession.Update(False,'',MilliSecondsBetween(Time,T));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadReportFailed,SLoadReportFailed,[E.Message]);
  end;
end;

procedure TBisCmxConnection.LoadDocument(const SessionId: Variant; DocumentId: Variant; Stream: TStream);
var
  ASession: TBisCmxSession;
  T: TTime;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Stream) then begin
      T:=Time;
      try
        ASession.CheckLocks(SLoadDocument);
        ASession.LoadDocument(DocumentId,Stream);
      finally
        ASession.Update(False,'',MilliSecondsBetween(Time,T));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadDocumentFailed,SLoadDocumentFailed,[E.Message]);
  end;
end;

end.



