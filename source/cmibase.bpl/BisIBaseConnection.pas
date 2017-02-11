unit BisIBaseConnection;

interface

uses Windows, Classes, Contnrs, DB, Variants,
     Forms, Controls,
     IB, IBDatabase, IBStoredProc, IBQuery, IBSQLMonitor, IBUtils,
     BisObject, BisConnectionModules, BisCore,
     BisDataSet, BisConfig, BisProfile, BisInterfaces,
     BisParams, BisParam, BisIfaces, BisMenus, BisConnections,
     BisPermissions, BisLogger, BisTasks, BisEvents, BisAlarmsFm;

type
  TBisIBaseConnection=class;
  TBisIBaseSessions=class;

  TBisIBaseProc=class(TIBStoredProc)
  private
    FSParamPrefix: String;
    procedure SetNullToParamValues;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CopyParamsFrom(Source: TBisParams);
    procedure CopyParamsTo(Source: TBisParams);
    function GetQueryText: String;
    
    property SParamPrefix: String read FSParamPrefix write FSParamPrefix;
  end;

  TBisIBaseQuery=class(TIBQuery)
  private
    FFetchCount: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    procedure FetchAll;
    function GetQueryText: String;

    property FetchCount: Integer read FFetchCount;
  end;

  TBisIBaseTransaction=class(TIBTransaction)
  private
    FTimeOut: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property TimeOut: Integer read FTimeOut write FTimeOut;
  end;

  TBisIBaseDatabase=class(TIBDatabase)
  private
    function GetUserName: String;
    procedure SetUserName(Value: String);
    function GetPassword: String;
    procedure SetPassword(Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    procedure CopyFrom(Source: TBisIBaseDatabase);

    property UserName: String read GetUserName write SetUserName;
    property Password: String read GetPassword write SetPassword;
  end;

  TBisIBaseConnectionClass=class of TBisIBaseConnection;

  TBisIBaseSession=class(TBisObject)
  private
    FLock: TRTLCriticalSection;
    FSessions: TBisIBaseSessions;
    FSessionId: Variant;
    FConnection: TBisIBaseConnection;
    FDatabase: TBisIBaseDatabase;
    FTransaction: TBisIBaseTransaction;
    FApplicationId: Variant;
    FAccountId: Variant;
    FUserName: String;
    FPassword: String;
    FDateCreate: TDateTime;
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
    FSExecuteSetParams: String;
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
    FTranTimeOut: Integer;

    procedure LoggerWrite(const Message: String; LogType: TBisLoggerType=ltInformation);
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
  public
    constructor Create(ASessions: TBisIBaseSessions); reintroduce; virtual;
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
    property Database: TBisIBaseDatabase read FDatabase;
    property Connection: TBisIBaseConnection read FConnection write FConnection;
    property ApplicationId: Variant read FApplicationId write FApplicationId;
    property AccountId: Variant read FAccountId write FAccountId;
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property DateCreate: TDateTime read FDateCreate write FDateCreate;
    property TranIdleTimer: Integer read FTranTimeOut write FTranTimeOut;
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
    property SExecuteSetParams: String read FSExecuteSetParams write FSExecuteSetParams;
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

  TBisIBaseSessionClass=class of TBisIBaseSession;

  TBisIBaseSessions=class(TObjectList)
  private
    FConnection: TBisIBaseConnection;
    FSFormatSchemaName: String;
    function GetItems(Index: Integer): TBisIBaseSession;

  protected
    function GetSessionClass: TBisIBaseSessionClass; virtual;
  public
    constructor Create(AConnection: TBisIBaseConnection); virtual;
    destructor Destroy; override;

    function Add(SessionId: Variant; DateCreate: TDateTime;
                 ApplicationId, AccountId: Variant; UserName, Password: String;
                 DbUserName, DbPassword: String; SessionParams, IPList: String;
                 IsNew: Boolean): TBisIBaseSession;
    function Find(SessionId: Variant): TBisIBaseSession;
    procedure Remove(Session: TBisIBaseSession; WithDelete: Boolean);
    procedure CopyFrom(Source: TBisIBaseSessions; IsClear: Boolean);

    property Items[Index: Integer]: TBisIBaseSession read GetItems;

    property SFormatSchemaName: String read FSFormatSchemaName write FSFormatSchemaName;
  end;

  TBisIBaseSessionsClass=class of TBisIBaseSessions;

  TBisIBaseConnection=class(TBisConnection)
  private
    FLock: TRTLCriticalSection;
    FDefaultDatabase: TBisIBaseDatabase;
    FLinkedRealDefaultDatabase: TBisIBaseDatabase;
    FSessions: TBisIBaseSessions;
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
    FSImportScriptStart: String;
    FSImportScriptSql: String;
    FSImportScriptFail: String;
    FSImportTableStart: String;
    FSImportTableSql: String;
    FSImportTableFail: String;
    FSImportTableSuccess: String;
    FSImportTableParam: String;
    FSSqlUpdate: String;
    FSSQLGetKeys: String;
    FSImportTableEmpty: String;
    FSSqlSessions: String;
    FCheckProductVersion: Boolean;
    FMaxRecordCount: Integer;

    procedure Lock;
    procedure UnLock;
    function GetDbUserName(UserName, Password: String; var AccountId, FirmId, FirmSmallName: Variant;
                           var DbUserName, DbPassword: String): Boolean;
    function ApplicationExists(ApplicationId,AccountId: Variant; ProductVersion: String): Boolean;
    function SessionExists(SessionId: Variant): Boolean;
    function SessionFind(SessionId: Variant): TBisIBaseSession;
    function GetTableName(SQL: String; var Where: String): String;
    procedure ImportScript(Stream: TStream);
    procedure ImportTable(Stream: TStream);
    procedure ExportScript(const Value: String; Stream: TStream; Params: TBisConnectionExportParams=nil);
    procedure ExportTable(const Value: String; Stream: TStream; Params: TBisConnectionExportParams=nil);
    procedure ChangeParams(Sender: TObject);
    function GetPrefix: String;
    function GetTimeOut: Integer;
    function PreparePrefix(AName: String): String;
    function GetInternalServerDate: TDateTime;
    function GetSessionIDs: String;
    function GetRealRealDefaultDatabase: TBisIBaseDatabase;
  protected
    function GetFieldNameQuote: String; override;
    function GetRecordsFilterDateValue(Value: TDateTime): String; override;
    function GetConnected: Boolean; override;
    function GetWorking: Boolean; override;
    function GetSessionCount: Integer; override;

    function GetSessionsClass: TBisIBaseSessionsClass; virtual;

    property RealDefaultDatabase: TBisIBaseDatabase read GetRealRealDefaultDatabase;
    property Sessions: TBisIBaseSessions read FSessions; 
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
    procedure CheckSessions; override;

    property SSqlGetDbUserName: String read FSSqlGetDbUserName write FSSqlGetDbUserName;
    property SSqlApplicationExists: String read FSSqlApplicationExists write FSSqlApplicationExists;
    property SSqlSessionExists: String read FSSqlSessionExists write FSSqlSessionExists;
    property SSqlSessions: String read FSSqlSessions write FSSqlSessions;
    property SSqlGetServerDate: String read FSSqlGetServerDate write FSSqlGetServerDate;
    property SFieldNameQuote: String read FSFieldNameQuote write FSFieldNameQuote;
    property SFormatDateTimeValue: String read FSFormatDateTimeValue write FSFormatDateTimeValue;
    property SSqlInsert: String read FSSqlInsert write FSSqlInsert;
    property SSqlUpdate: String read FSSqlUpdate write FSSqlUpdate;
    property SSQLGetKeys: String read FSSQLGetKeys write FSSQLGetKeys;
    property SFormatFilterDateValue: String read FSFormatFilterDateValue write FSFormatFilterDateValue;
  published

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


procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;

exports
  InitConnectionModule;

implementation

uses SysUtils, DateUtils, ActiveX, FMtBcd, TypInfo, StrUtils,
     BisIBaseConsts, BisUtils, BisExceptions, BisNetUtils,
     BisConsts, BisCoreUtils, BisFilterGroups;


procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;
begin
  AModule.ConnectionClass:=TBisIBaseConnection;
end;

{ TBisIBaseProc }

constructor TBisIBaseProc.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisIBaseProc.GetQueryText: String;
var
  Str: TStringList;
  i: Integer;
  Param: TParam;
  S: String;
  V: String;
begin
  Str:=TStringList.Create;
  try
    Str.Text:=SelectSQL.Text;
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

procedure TBisIBaseProc.CopyParamsFrom(Source: TBisParams);
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

procedure TBisIBaseProc.CopyParamsTo(Source: TBisParams);
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

procedure TBisIBaseProc.SetNullToParamValues;
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

{ TBisIBaseQuery }

constructor TBisIBaseQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisIBaseQuery.FetchAll;
begin
  FFetchCount:=0;
  First;
  while not Eof do begin
    Inc(FFetchCount);
    Next;
  end;
  First;
end;

function TBisIBaseQuery.GetQueryText: String;
var
  Str: TStringList;
  i: Integer;
  Param: TParam;
  S: String;
  V: String;
begin
  Str:=TStringList.Create;
  try
    Str.Text:=SelectSQL.Text;
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

{ TBisIBaseTransaction }

constructor TBisIBaseTransaction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoStopAction:=saRollback;
  DefaultAction:=TARollback;
  Params.Text:=STransactionParams;
end;

destructor TBisIBaseTransaction.Destroy;
begin
  inherited Destroy;
end;

{ TBisIBaseDatabase }

constructor TBisIBaseDatabase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LoginPrompt:=false;
end;

function TBisIBaseDatabase.GetUserName: String;
begin
  Result:=Params.Values[SDBParamUserName];
end;

procedure TBisIBaseDatabase.SetUserName(Value: String);
begin
  Params.Values[SDBParamUserName]:=Value;
end;

function TBisIBaseDatabase.GetPassword: String;
begin
  Result:=Params.Values[SDBParamPassword];
end;

procedure TBisIBaseDatabase.SetPassword(Value: String);
begin
  Params.Values[SDBParamPassword]:=Value;
end;

procedure TBisIBaseDatabase.CopyFrom(Source: TBisIBaseDatabase);
var
  ASource: TBisIBaseDatabase;
begin
  if Source is TBisIBaseDatabase then begin
    ASource:=TBisIBaseDatabase(Source);
    Self.DatabaseName:=ASource.DatabaseName;
    Self.Params.Text:=ASource.Params.Text;
    Self.LoginPrompt:=ASource.LoginPrompt;
  end;
end;

{ TBisIBaseSession }

constructor TBisIBaseSession.Create(ASessions: TBisIBaseSessions);
begin
  inherited Create(nil);
  InitializeCriticalSection(FLock);

  FSessions:=ASessions;
  FDatabase:=TBisIBaseDatabase.Create(nil);
  FTransaction:=TBisIBaseTransaction.Create(nil);

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
  FSExecuteSetParams:='��������� ������. ������ ��������� ...';
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

  FSCheckPermissions:='NAME=%s';
  FSFormatDateTime:='yyyy-mm-dd hh:nn:ss';  // English
  FSSqlInsert:='INSERT INTO /*PREFIX*/SESSIONS (SESSION_ID,APPLICATION_ID,ACCOUNT_ID,DATE_CREATE,DATE_CHANGE,PARAMS) '+
               'VALUES (%s,%s,%s,%s,CURRENT_TIMESTAMP,:PARAMS)';
  FSSqlUpdate:='UPDATE /*PREFIX*/SESSIONS SET DATE_CHANGE=CURRENT_TIMESTAMP, QUERY_TEXT=:QUERY_TEXT, DURATION=:DURATION '+
               'WHERE SESSION_ID=%s';
  FSSqlUpdateParams:='UPDATE /*PREFIX*/SESSIONS SET DATE_CHANGE=CURRENT_TIMESTAMP, PARAMS=:PARAMS, '+
                     'QUERY_TEXT=:QUERY_TEXT, DURATION=:DURATION '+
                     'WHERE SESSION_ID=%s ';
  FSSqlDelete:='DELETE FROM /*PREFIX*/SESSIONS WHERE SESSION_ID=%s';
  FSSqlLoadPermissions:='SELECT P.INTERFACE_ID, I.NAME, P.RIGHT_ACCESS, P."VALUE" '+
                        'FROM /*PREFIX*/PERMISSIONS P JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=P.INTERFACE_ID '+
                        'WHERE P.ACCOUNT_ID IN (%s)';
  FSSqlLoadLocks:='SELECT METHOD, OBJECT, DESCRIPTION, IP_LIST FROM /*PREFIX*/LOCKS '+
                  'WHERE ((DATE_BEGIN<=%s AND DATE_END IS NULL) OR (DATE_BEGIN<=%s AND DATE_END>=%s)) '+
                  'AND APPLICATION_ID=%s AND (ACCOUNT_ID IN (%s) OR ACCOUNT_ID IS NULL) '+
                  'ORDER BY DATE_BEGIN';
  FSSqlLoadRoles:='SELECT ROLE_ID FROM /*PREFIX*/ACCOUNT_ROLES WHERE ACCOUNT_ID=%s';
  FSSqlLoadProfile:='SELECT P.PROFILE FROM /*PREFIX*/PROFILES P WHERE P.APPLICATION_ID=%s AND P.ACCOUNT_ID=%s';
  FSSqlSaveProfile:='UPDATE /*PREFIX*/PROFILES SET PROFILE=:PROFILE WHERE APPLICATION_ID=%s AND ACCOUNT_ID=%s';
  FSSqlLoadInterfaces:='SELECT AI.INTERFACE_ID, AI.PRIORITY, AI.AUTO_RUN, I.NAME, I.DESCRIPTION, '+
                       'I."MODULE_NAME", I.MODULE_INTERFACE, I.INTERFACE_TYPE, '+
                       'S.SCRIPT_ID, S.ENGINE AS SCRIPT_ENGINE, S.PLACE AS SCRIPT_PLACE, '+
                       'R.REPORT_ID, R.ENGINE AS REPORT_ENGINE, R.PLACE AS REPORT_PLACE, '+
                       'D.DOCUMENT_ID, D.OLE_CLASS AS DOCUMENT_OLE_CLASS, D.PLACE AS DOCUMENT_PLACE '+
                       'FROM /*PREFIX*/APPLICATION_INTERFACES AI '+
                       'JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=AI.INTERFACE_ID '+
                       'LEFT JOIN /*PREFIX*/SCRIPTS S ON S.SCRIPT_ID=AI.INTERFACE_ID '+
                       'LEFT JOIN /*PREFIX*/REPORTS R ON R.REPORT_ID=AI.INTERFACE_ID '+
                       'LEFT JOIN /*PREFIX*/DOCUMENTS D ON D.DOCUMENT_ID=AI.INTERFACE_ID '+
                       'WHERE AI.APPLICATION_ID=%s AND AI.ACCOUNT_ID IN (%s) '+
                       'ORDER BY AI.PRIORITY';
  FSSqlGetRecords:='SELECT %s FROM %s %s %s %s %s';
  FSSqlGetRecordsCount:='SELECT COUNT(*) FROM (%s)';
  FSSqlLoadMenus:='SELECT M.MENU_ID, M.PARENT_ID, M.NAME, M.DESCRIPTION, M.INTERFACE_ID, '+
                  'M.SHORTCUT, M.PICTURE, M.PRIORITY '+
                  'FROM /*PREFIX*/APPLICATION_MENUS AP '+
                  'JOIN /*PREFIX*/MENUS M ON M.MENU_ID=AP.MENU_ID '+
                  'WHERE AP.APPLICATION_ID=%s '+
                  'AND (M.INTERFACE_ID IN (SELECT INTERFACE_ID FROM /*PREFIX*/APPLICATION_INTERFACES '+
                                           'WHERE APPLICATION_ID=AP.APPLICATION_ID AND ACCOUNT_ID IN (%s)) '+
                  'OR M.INTERFACE_ID IS NULL) '+
                  'ORDER BY M."LEVEL", M.PRIORITY ';
  FSSqlLoadTasks:='SELECT TASK_ID, NAME, DESCRIPTION, INTERFACE_ID, '+
                  'ENABLED, DATE_BEGIN, OFFSET, DATE_END, SCHEDULE, PRIORITY, '+
                  'PROC_NAME, COMMAND_STRING, DAY_FREQUENCY, WEEK_FREQUENCY, '+
                  'MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY, '+
                  'MONTH_DAY, JANUARY, FEBRUARY, MARCH, APRIL, MAY, JUNE, '+
                  'JULY, AUGUST, SEPTEMBER, OCTOBER, NOVEMBER, DECEMBER, '+
                  'REPEAT_ENABLED, REPEAT_TYPE, REPEAT_VALUE, REPEAT_COUNT, '+
                  'DATE_EXECUTE, RESULT_STRING '+
                  'FROM /*PREFIX*/TASKS '+
                  'WHERE APPLICATION_ID=%s AND (ACCOUNT_ID IN (%s) OR ACCOUNT_ID IS NULL) '+
                  'ORDER BY DATE_BEGIN';
  FSSqlSaveTask:='UPDATE /*PREFIX*/TASKS SET DATE_EXECUTE=%s, RESULT_STRING=%s WHERE TASK_ID=%s';
  FSSqlLoadAlarms:='SELECT ALARM_ID, TYPE_ALARM, DATE_BEGIN, CAPTION, TEXT_ALARM, A1.USER_NAME '+
                   'FROM /*PREFIX*/ALARMS A '+
                   'JOIN /*PREFIX*/ACCOUNTS A1 ON A1.ACCOUNT_ID=A.SENDER_ID '+
                   'WHERE ((A.DATE_BEGIN<=CURRENT_TIMESTAMP AND A.DATE_END IS NULL) OR '+
                   '(A.DATE_BEGIN<=CURRENT_TIMESTAMP AND A.DATE_END>=CURRENT_TIMESTAMP)) '+
                   'AND (A.RECIPIENT_ID IN (%s) OR A.RECIPIENT_ID IS NULL) '+
                   'ORDER BY A.DATE_BEGIN';
  FSSqlLoadScript:='SELECT SCRIPT, PLACE FROM /*PREFIX*/SCRIPTS WHERE SCRIPT_ID=%s';
  FSSqlLoadReport:='SELECT REPORT, PLACE FROM /*PREFIX*/REPORTS WHERE REPORT_ID=%s';
  FSSqlLoadDocument:='SELECT DOCUMENT, PLACE FROM /*PREFIX*/DOCUMENTS WHERE DOCUMENT_ID=%s';
  FSParamPrefix:='';


  TranslateObject(Self,TBisIBaseSession);
end;

destructor TBisIBaseSession.Destroy;
begin
  FParams.Free;
  FIPList.Free;
  FLocks.Free;
  FRoles.Free;
  FPermissions.Free;
  FTransaction.Free;
  FDatabase.ForceClose;
  FDatabase.Free;
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

procedure TBisIBaseSession.LoggerWrite(const Message: String; LogType: TBisLoggerType=ltInformation);
var
  S: String;
begin
  if Assigned(FConnection) and (Trim(Message)<>'') then begin
    S:=FormatEx(FSSessionFormat,[VarToStrDef(FSessionId,''),Message]);
    FConnection.LoggerWrite(S,LogType);
  end;
end;

function TBisIBaseSession.GetPrefix: String;
begin
  Result:='';
  if Assigned(FConnection) then
    Result:=FConnection.GetPrefix;
end;

function TBisIBaseSession.PreparePrefix(AName: String): String;
begin
  Result:=AName;
  if Assigned(FConnection) then
    Result:=FConnection.PreparePrefix(AName);
end;

function TBisIBaseSession.GetRoleIds: String;
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

procedure TBisIBaseSession.Lock;
begin
  EnterCriticalSection(FLock);
end;

procedure TBisIBaseSession.Unlock;
begin
  LeaveCriticalSection(FLock);
end;

procedure TBisIBaseSession.Insert;
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Stream: TMemoryStream;
  Sql: String;
begin
  Lock;
  try
    if FDatabase.Connected then begin
      LoggerWrite(FSInsertStart);
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        Stream:=TMemoryStream.Create;
        try
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
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
          Tran.Commit;
          LoggerWrite(FSInsertSuccess);
        finally
          Stream.Free;
          Tran.Free;
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

procedure TBisIBaseSession.Update(WithParams: Boolean=false; QueryText: String=''; Duration: Integer=-1);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Stream: TMemoryStream;
  Sql: String;
begin
  Lock;
  try
    if Assigned(FConnection) and FDatabase.Connected then begin
      LoggerWrite(FSUpdateStart);
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        Stream:=TMemoryStream.Create;
        try
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
          Query.ParamCheck:=true;
          if WithParams then begin
            Sql:=FormatEx(FSSqlUpdateParams,[QuotedStr(VarToStrDef(FSessionId,''))])
          end else begin
            Sql:=FormatEx(FSSqlUpdate,[QuotedStr(VarToStrDef(FSessionId,''))]);
          end;
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          Query.SQL.Text:=Sql;
          if WithParams then begin
            FParams.SaveToStream(Stream);
            Stream.Position:=0;
            Query.ParamByName('PARAMS').LoadFromStream(Stream,ftBlob);
          end;
          Query.ParamByName('QUERY_TEXT').Value:=Iff(Trim(QueryText)<>'',Trim(QueryText),NULL);
          Query.ParamByName('DURATION').Value:=Iff(Duration<>-1,Duration,NULL);
//          LoggerWrite(FormatEx(FSUpdateSql,[Query.GetQueryText]));
          LoggerWrite(FormatEx(FSUpdateSql,[Sql]));

          Query.ExecSQL;
          Tran.Commit;
          LoggerWrite(FSUpdateSuccess);
        finally
          Stream.Free;
          Query.Free;
          Tran.Free;
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

procedure TBisIBaseSession.Delete;
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Sql: String;
begin
  Lock;
  try
    if FDatabase.Connected then begin
      LoggerWrite(FSDeleteStart);
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        try
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
          Sql:=FormatEx(FSSqlDelete,[QuotedStr(VarToStrDef(FSessionId,''))]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSDeleteSql,[Sql]));
          Query.SQL.Text:=Sql;
          Query.ExecSQL;
          Tran.Commit;
          LoggerWrite(FSDeleteSuccess);
        finally
          Tran.Free;
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

procedure TBisIBaseSession.LoadPermissions;
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  S: String;
  Sql: String;
begin
  Lock;
  try
    S:=GetRoleIds;
    if FDatabase.Connected and (Trim(S)<>'') then begin
      Query:=TBisIBaseQuery.Create(nil);
      Tran:=TBisIBaseTransaction.Create(nil);
      try
        FDatabase.AddTransaction(Tran);
        Tran.AddDatabase(FDatabase);
        Tran.TimeOut:=FTranTimeOut;
        Tran.Active:=true;
        Query.Transaction:=Tran;
        Query.Database:=FDatabase;
        Sql:=FormatEx(FSSqlLoadPermissions,[S]);
        Query.SQL.Text:=ReplaceText(Sql,SPrefix,GetPrefix);
        Query.Open;
        if Query.Active then begin
          FPermissions.CreateTable(Query);
          FPermissions.CopyRecords(Query);
        end;
      finally
        Tran.Free;
        Query.Free;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisIBaseSession.LoadRoles;
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Sql: String;
begin
  Lock;
  try
    if FDatabase.Connected then begin
      FRoles.Clear;
      Query:=TBisIBaseQuery.Create(nil);
      Tran:=TBisIBaseTransaction.Create(nil);
      try
        FDatabase.AddTransaction(Tran);
        Tran.AddDatabase(FDatabase);
        Tran.TimeOut:=FTranTimeOut;
        Tran.Active:=true;
        Query.Transaction:=Tran;
        Query.Database:=FDatabase;
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
        Tran.Free;
        Query.Free;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisIBaseSession.LoadLocks;
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  S: String;
  Sql: String;
  ADate: String;
begin
  Lock;
  try
    S:=GetRoleIds;
    if FDatabase.Connected and (Trim(S)<>'') then begin
      Query:=TBisIBaseQuery.Create(nil);
      Tran:=TBisIBaseTransaction.Create(nil);
      try
        FDatabase.AddTransaction(Tran);
        Tran.AddDatabase(FDatabase);
        Tran.TimeOut:=FTranTimeOut;
        Tran.Active:=true;
        Query.Transaction:=Tran;
        Query.Database:=FDatabase;
        ADate:=QuotedStr(FormatDateTime(FSFormatDateTime,FDateCreate));
        Sql:=FormatEx(FSSqlLoadLocks,[ADate,ADate,ADate,QuotedStr(VarToStrDef(FApplicationId,'')),S]);
        Query.SQL.Text:=ReplaceText(Sql,SPrefix,GetPrefix);
        Query.Open;
        if Query.Active then begin
          FLocks.CreateTable(Query);
          FLocks.CopyRecords(Query);
        end;
      finally
        Tran.Free;
        Query.Free;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisIBaseSession.CheckPermissions(AObjectName: String; APermissions: TBisPermissions);
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

procedure TBisIBaseSession.CheckLocks(AMethod: String=''; AObject: String='');
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

procedure TBisIBaseSession.LoadProfile(Profile: TBisProfile);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Sql: String;
begin
  Lock;
  try
    if Assigned(Profile) and FDatabase.Connected then begin
      LoggerWrite(FSLoadProfileStart);
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        try
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
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
          Tran.Free;
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

procedure TBisIBaseSession.SaveProfile(Profile: TBisProfile);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Stream: TMemoryStream;
  Sql: String;
begin
  Lock;
  try
    if Assigned(Profile) and FDatabase.Connected then begin
      LoggerWrite(FSSaveProfileStart);
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        Stream:=TMemoryStream.Create;
        try
          Profile.SaveToStream(Stream);
          Stream.Position:=0;
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
          Query.ParamCheck:=true;
          Sql:=FormatEx(FSSqlSaveProfile,[QuotedStr(VarToStrDef(FApplicationId,'')),QuotedStr(VarToStrDef(FAccountId,''))]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSSaveProfileSql,[Sql]));
          Query.SQL.Text:=Sql;
          Query.ParamByName('PROFILE').LoadFromStream(Stream,ftBlob);
          Query.ExecSQL;
          Tran.Commit;
          LoggerWrite(FSSaveProfileSuccess);
        finally
          Stream.Free;
          Tran.Free;
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

procedure TBisIBaseSession.LoadInterfaces(Interfaces: TBisInterfaces);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  AInterface: TBisInterface;
  S: String;
  AID: String;
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
    if Assigned(Interfaces) and FDatabase.Connected and (Trim(S)<>'') then begin
      LoggerWrite(FSLoadInterfacesStart);
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        try
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
          Sql:=FormatEx(FSSqlLoadInterfaces,[QuotedStr(VarToStrDef(FApplicationId,'')),S]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSLoadInterfacesSql,[Sql]));
          Query.SQL.Text:=Sql;
          Query.Open;
          if Query.Active then begin
            Query.FetchAll;
            while not Query.Eof do begin
              AID:=Query.FieldByName('INTERFACE_ID').AsString;
              AType:=TBisInterfaceType(Query.FieldByName('INTERFACE_TYPE').AsInteger);
              AObjectName:=Query.FieldByName('NAME').AsString;
              AInterface:=Interfaces.FindById(AID);
              if not Assigned(AInterface) then begin
                case AType of
                  BisInterfaces.itInternal: begin
                    AInterface:=Interfaces.AddInternal(AID,AObjectName,
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
          Tran.Free;
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

procedure TBisIBaseSession.CopyData(FromDataSet: TDataSet; ToDataSet: TBisDataSet; AllCount: Integer);

  function FetchAll(MaxCount: Integer): Integer;
  begin
    Result:=0;
    FromDataSet.First;
    while not FromDataSet.Eof do begin
      Inc(Result);
      if Result>=MaxCount then
        break;
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
        FetchCount:=FetchAll(FConnection.FMaxRecordCount);
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

procedure TBisIBaseSession.GetRecords(DataSet: TBisDataSet; var QueryText: String);

  procedure DefaultGetRecords(ADataSet: TBisDataSet);
  var
    Query: TBisIBaseQuery;
    Tran: TBisIBaseTransaction;
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
    if Trim(ADataSet.ProviderName)<>'' then begin
      AProvider:=PreparePrefix(ADataSet.ProviderName);
      Query:=TBisIBaseQuery.Create(nil);
      Tran:=TBisIBaseTransaction.Create(nil);
      try
        FDatabase.AddTransaction(Tran);
        Tran.AddDatabase(FDatabase);
        Tran.TimeOut:=FTranTimeOut;
        Tran.Active:=true;
        Query.Transaction:=Tran;
        Query.Database:=FDatabase;
        Query.ParamCheck:=ADataSet.Params.Count>0;

        FieldNames:=FConnection.GetRecordsFieldNames(ADataSet,ADataSet.FieldNames);
        Params:=FConnection.GetRecordsParams(ADataSet,ADataSet.Params);
        Filters:=FConnection.GetRecordsFilterGroups(ADataSet.FilterGroups);
        Groups:=FConnection.GetRecordsGroups(ADataSet,ADataSet.FieldNames);
        Orders:=FConnection.GetRecordsOrders(ADataSet.Orders);

        SQL:=Trim(FormatEx(FSSqlGetRecords,[FieldNames,AProvider,Params,Filters,Groups,Orders]));
        AllCount:=0;

        if ADataSet.FetchCount>0 then begin
          SQLCount:=Trim(FormatEx(FSSqlGetRecords,['COUNT(*)',AProvider,Params,Filters,Groups,''])); // Interbase
          LoggerWrite(FormatEx(FSGetRecordsSqlCount,[SQLCount]));
          Query.SQL.Text:=SQLCount;
          Query.Open;
          if not Query.IsEmpty then
            AllCount:=Query.Fields[0].AsInteger;
        end else begin
          AllCount:=MaxInt;
        end;

        Query.Close;
        Query.SQL.Text:=SQL;
        QueryText:=Query.GetQueryText;

        LoggerWrite(FormatEx(FSGetRecordsSql,[QueryText]));
        Query.Open;

        CopyData(Query,ADataSet,AllCount);
      finally
        Tran.Free;
        Query.Free;
      end;
    end;
  end;

  procedure CollectionGetRecords;
  var
    i: Integer;
    Item: TBisDataSetCollectionItem;
    ADataSet: TBisDataSet;
  begin
    for i:=0 to DataSet.Collection.Count-1 do begin
      Item:=DataSet.Collection.Items[i];
      ADataSet:=TBisDataSet.Create(nil);
      try
        ADataSet.InGetRecords:=true;
        ADataSet.ProviderName:=Item.ProviderName;
        ADataSet.FieldNames.CopyFrom(Item.FieldNames);
        ADataSet.FilterGroups.CopyFrom(Item.FilterGroups);
        ADataSet.Params.CopyFrom(Item.Params);
        ADataSet.Orders.CopyFrom(Item.Orders);
        DefaultGetRecords(ADataSet);
        Item.SetDataSet(ADataSet);
      finally
        ADataSet.Free;
      end;
    end;
  end;

begin
  Lock;
  try
    if Assigned(DataSet) and FDatabase.Connected then begin
      LoggerWrite(FSGetRecordsStart);
      try
        DefaultGetRecords(DataSet);
        CollectionGetRecords;
        LoggerWrite(FSGetRecordsSuccess);
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

{procedure TBisIBaseSession.GetRecords(DataSet: TBisDataSet; var QueryText: String);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
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
    if Assigned(DataSet) and FDatabase.Connected then begin
      LoggerWrite(FSGetRecordsStart);
      try
        AProvider:=PreparePrefix(DataSet.ProviderName);
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        try
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
          Query.ParamCheck:=DataSet.Params.Count>0;

          FieldNames:=FConnection.GetRecordsFieldNames(DataSet,DataSet.FieldNames);
          Params:=FConnection.GetRecordsParams(DataSet,DataSet.Params);
          Filters:=FConnection.GetRecordsFilterGroups(DataSet.FilterGroups);
          Groups:=FConnection.GetRecordsGroups(DataSet,DataSet.FieldNames);
          Orders:=FConnection.GetRecordsOrders(DataSet.Orders);

          SQL:=Trim(FormatEx(FSSqlGetRecords,[FieldNames,AProvider,Params,Filters,Groups,Orders]));
          AllCount:=0;

          if DataSet.FetchCount>0 then begin
            SQLCount:=Trim(FormatEx(FSSqlGetRecords,['COUNT(*)',AProvider,Params,Filters,Groups,''])); // Interbase
            LoggerWrite(FormatEx(FSGetRecordsSqlCount,[SQLCount]));
            Query.SQL.Text:=SQLCount;
            Query.Open;
            if not Query.IsEmpty then
              AllCount:=Query.Fields[0].AsInteger;
          end else begin
            AllCount:=MaxInt;
          end;

          Query.Close;
          Query.SQL.Text:=SQL;
          QueryText:=Query.GetQueryText;

          LoggerWrite(FormatEx(FSGetRecordsSql,[QueryText]));
          Query.Open;

          CopyData(Query,DataSet,AllCount);

          LoggerWrite(FSGetRecordsSuccess);
        finally
          Tran.Free;
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
end; }

procedure TBisIBaseSession.DumpParams(Params: TBisParams);
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

procedure TBisIBaseSession.DumpParams(Params: TParams);
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

procedure TBisIBaseSession.Execute(DataSet: TBisDataSet; var QueryText: String);

  procedure SetSessionId(Proc: TBisIBaseProc);
  var
    Param: TParam;
  begin
    Param:=Proc.Params.FindParam('SESSION_ID');
    if Assigned(Param) then
      Param.Value:=FSessionId;
  end;

  function ExecuteOpen(Proc: TBisIBaseProc; OpenDataSet: TBisDataSet; Tran: TBisIBaseTransaction): TDataSet;
  var
    Query: TBisIBaseQuery;
    i: Integer;
    FieldNames: String;
    Filters: String;
    Groups: String;
    Orders: String;
    Params: String;
    Param: TParam;
    NewParam: TParam;
    First: Boolean;
    SQL: String;
  begin
    Result:=Proc;
    if Assigned(Proc) then begin
      Query:=TBisIBaseQuery.Create(nil);
      try
        Query.Transaction:=Tran;
        Query.Database:=FDatabase;
        Query.ParamCheck:=false;
        First:=true;
        Params:='';
        for i:=0 to Proc.Params.Count-1 do begin
          Param:=Proc.Params[i];
          if (Param.ParamType in [ptInput,ptInputOutput]) then begin

            NewParam:=TParam(Query.Params.Add);
            NewParam.Name:=Param.Name;
            NewParam.Value:=Param.Value;
            NewParam.DataType:=Param.DataType;
            NewParam.ParamType:=Param.ParamType;

            if First then begin
              Params:=':'+Param.Name;
              First:=false;
            end else Params:=Params+',:'+Param.Name;
          end;
        end;
        if Trim(Params)<>'' then begin
          Params:='('+Params+')';
          Query.ParamCheck:=true;
        end;

        FieldNames:=FConnection.GetRecordsFieldNames(DataSet,DataSet.FieldNames);
        Filters:=FConnection.GetRecordsFilterGroups(DataSet.FilterGroups);
        Groups:=FConnection.GetRecordsGroups(DataSet,DataSet.FieldNames);
        Orders:=FConnection.GetRecordsOrders(DataSet.Orders);

        SQL:=Trim(FormatEx(FSSqlGetRecords,[FieldNames,Proc.StoredProcName,Params,Filters,Groups,Orders]));

        Query.SQL.Text:=SQL;
        QueryText:=Query.GetQueryText;

//        Query.SQL.Text:=FormatEx('SELECT * FROM %s%s',[Proc.StoredProcName,Params]);
//        QueryText:=Query.GetQueryText;
        Query.Open;
        if Query.Active then begin
          OpenDataSet.CreateTable(Query);
          OpenDataSet.CopyRecords(Query);
          Result:=OpenDataSet;
        end;
      finally
        Query.Free;
      end;
    end;
  end;

  procedure ExecutePackage(Tran: TBisIBaseTransaction; Package: TBisPackageParams);
  var
    i: Integer;
    Proc: TBisIBaseProc;
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
          Proc:=TBisIBaseProc.Create(nil);
          try
            Proc.Transaction:=Tran;
            Proc.Database:=FDatabase;
            Proc.SParamPrefix:=FSParamPrefix;
            Proc.StoredProcName:=AProvider;
            Proc.Prepare;

            LoggerWrite(FormatEx(FSExecuteProvider,[AProvider]));

            Proc.SetNullToParamValues;
            SetSessionId(Proc);
            Proc.CopyParamsFrom(Params);
            DumpParams(Proc.Params);

            LoggerWrite(FSExecuteSetParams);
            
            Proc.ExecProc;

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
  Proc: TBisIBaseProc;
  AProvider: String;
  Tran: TBisIBaseTransaction;
  FromDataSet: TDataSet;
  OpenDataSet: TBisDataSet;
begin
  Lock;
  try
    if Assigned(DataSet) and FDatabase.Connected then begin
      LoggerWrite(FSExecuteStart);
      try
        AProvider:=PreparePrefix(DataSet.ProviderName);
        Proc:=TBisIBaseProc.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        OpenDataSet:=TBisDataSet.Create(nil);
        try

          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Proc.Transaction:=Tran;
          Proc.Database:=FDatabase;
          Proc.SParamPrefix:=FSParamPrefix;
          Proc.StoredProcName:=AProvider;
          Proc.Prepare;

          LoggerWrite(FormatEx(FSExecuteProvider,[AProvider]));

          Proc.SetNullToParamValues;
          SetSessionId(Proc);
          Proc.CopyParamsFrom(DataSet.Params);
          DumpParams(Proc.Params);

          FromDataSet:=Proc;

          QueryText:=Proc.GetQueryText;

          LoggerWrite(FSExecuteSetParams);

          AllCount:=MaxInt;
          if DataSet.InGetRecords then begin

            FromDataSet:=ExecuteOpen(Proc,OpenDataSet,Tran);

            Proc.CopyParamsTo(DataSet.Params);
            DumpParams(DataSet.Params);
          end else begin
            try
              ExecutePackage(Tran,DataSet.PackageBefore);

              Proc.ExecProc;

              Proc.CopyParamsTo(DataSet.Params);
              DumpParams(DataSet.Params);

              ExecutePackage(Tran,DataSet.PackageAfter);

              Tran.Commit;

            except
              on E: Exception do begin
                Tran.Rollback;
                raise;
              end;
            end;
          end;

          CopyData(FromDataSet,DataSet,AllCount);

          LoggerWrite(FSExecuteSuccess);
        finally
          OpenDataSet.Free;
          Tran.Free;
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

procedure TBisIBaseSession.LoadMenus(Menus: TBisMenus);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
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
    if Assigned(Menus) and FDatabase.Connected and (Trim(S)<>'') then begin
      LoggerWrite(FSLoadMenusStart);
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        try
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
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
          Tran.Free;
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

procedure TBisIBaseSession.LoadTasks(Tasks: TBisTasks);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Task: TBisTask;
  S: String;
  ID: String;
  AObjectName: String;
  Sql: String;
begin
  Lock;
  try
    S:=GetRoleIds;
    if Assigned(Tasks) and FDatabase.Connected and (Trim(S)<>'') then begin
      LoggerWrite(FSLoadTasksStart);
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        try
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
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
                  Offset:=Query.FieldByName('OFFSET').AsInteger;
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
          Tran.Free;
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

procedure TBisIBaseSession.SaveTask(Task: TBisTask);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Sql: String;
begin
  Lock;
  try
    if Assigned(Task) and FDatabase.Connected then begin
      LoggerWrite(FSSaveTaskStart);
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        try
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
          Sql:=FormatEx(FSSqlSaveTask,[QuotedStr(FormatDateTime(FSFormatDateTime,Task.DateExecute)),
                                       QuotedStr(Task.ResultString),QuotedStr(Task.ID)]);
          Sql:=ReplaceText(Sql,SPrefix,GetPrefix);
          LoggerWrite(FormatEx(FSSaveTaskSql,[Sql]));
          Query.SQL.Text:=Sql;
          Query.ExecSQL;
          Tran.Commit;
          LoggerWrite(FSSaveTaskSuccess);
        finally
          Tran.Free;
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

procedure TBisIBaseSession.LoadAlarms(Alarms: TBisAlarms);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Alarm: TBisAlarm;
  S: String;
  ID: String;
  Sql: String;
begin
  Lock;
  try
    S:=GetRoleIds;
    if Assigned(Alarms) and FDatabase.Connected and (Trim(S)<>'') then begin
      LoggerWrite(FSLoadAlarmsStart);
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        try
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
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
          Tran.Free;
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

procedure TBisIBaseSession.LoadScript(ScriptId: Variant; Stream: TStream);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  FileStream: TFileStream;
  S: String;
  Sql: String;
begin
  Lock;
  try
    if Assigned(Stream) and FDatabase.Connected then begin
      LoggerWrite(FSLoadScriptStart);
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        try
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
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
          Tran.Free;
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

procedure TBisIBaseSession.LoadReport(ReportId: Variant; Stream: TStream);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  FileStream: TFileStream;
  S: String;
  Sql: String;
begin
  Lock;
  try
    if Assigned(Stream) and FDatabase.Connected then begin
      LoggerWrite(FSLoadReportStart);
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        try
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
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
          Tran.Free;
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

procedure TBisIBaseSession.LoadDocument(DocumentId: Variant; Stream: TStream);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  FileStream: TFileStream;
  S: String;
  Sql: String;
begin
  Lock;
  try
    if Assigned(Stream) and FDatabase.Connected then begin
      LoggerWrite(FSLoadDocumentStart);
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
        try
          FDatabase.AddTransaction(Tran);
          Tran.AddDatabase(FDatabase);
          Tran.TimeOut:=FTranTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=FDatabase;
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
          Tran.Free;
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

{ TBisIBaseSessions }

constructor TBisIBaseSessions.Create(AConnection: TBisIBaseConnection);
begin
  inherited Create;
  FConnection:=AConnection;
end;

destructor TBisIBaseSessions.Destroy;
begin
  inherited Destroy;
end;

function TBisIBaseSessions.GetSessionClass: TBisIBaseSessionClass;
begin
  Result:=TBisIBaseSession;
end;

function TBisIBaseSessions.GetItems(Index: Integer): TBisIBaseSession;
begin
  Result:=TBisIBaseSession(inherited Items[Index]);
end;

function TBisIBaseSessions.Add(SessionId: Variant; DateCreate: TDateTime;
                               ApplicationId, AccountId: Variant; UserName, Password: String;
                               DbUserName, DbPassword: String; SessionParams, IPList: String;
                               IsNew: Boolean): TBisIBaseSession;
var
  Session: TBisIBaseSession;
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
        Session.TranIdleTimer:=FConnection.GetTimeOut;

        with Session.Database do begin
          CopyFrom(FConnection.RealDefaultDatabase);
          UserName:=DbUserName;
          Password:=DbPassword;
          Connected:=true;
        end;

        Session.Params.Text:=SessionParams;
        Session.IPList.Text:=IPList;

        Session.Connection:=FConnection;
        if IsNew then begin
          FConnection.CheckSessions;
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

function TBisIBaseSessions.Find(SessionId: Variant): TBisIBaseSession;
var
  i: Integer;
  Item: TBisIBaseSession;
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

procedure TBisIBaseSessions.Remove(Session: TBisIBaseSession; WithDelete: Boolean);
begin
  if Assigned(Session) then begin
    if WithDelete then
      Session.Delete;
    inherited Remove(Session);
  end;
end;

procedure TBisIBaseSessions.CopyFrom(Source: TBisIBaseSessions; IsClear: Boolean);
var
  i: Integer;
  Item: TBisIBaseSession;
  Session: TBisIBaseSession;
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
                     Item.Database.UserName,Item.Database.Password,
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


{ TBisIBaseConnection }

constructor TBisIBaseConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InitializeCriticalSection(FLock);
  Params.OnChange:=ChangeParams;

  FCheckProductVersion:=true;
  FMaxRecordCount:=50000;

  FDefaultDatabase:=TBisIBaseDatabase.Create(Self);
  FLinkedRealDefaultDatabase:=nil;

  FSessions:=GetSessionsClass.Create(Self);

  Core.ExceptNotifier.IngnoreExceptions.Add(EIBInterBaseError);

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

  FSSqlGetDbUserName:='SELECT A.ACCOUNT_ID, A.FIRM_ID, F.SMALL_NAME AS FIRM_SMALL_NAME, A.DB_USER_NAME, A.DB_PASSWORD, A."PASSWORD" '+
                      'FROM /*PREFIX*/ACCOUNTS A '+
                      'LEFT JOIN /*PREFIX*/FIRMS F ON F.FIRM_ID=A.FIRM_ID '+
                      'WHERE UPPER(A.USER_NAME)=%s AND A.LOCKED<>1';
  FSSqlApplicationExists:='SELECT A.LOCKED, P.PROFILE, A.PRODUCT_VERSION '+
                          'FROM /*PREFIX*/PROFILES P '+
                          'JOIN /*PREFIX*/APPLICATIONS A ON A.APPLICATION_ID=P.APPLICATION_ID '+
                          'WHERE P.APPLICATION_ID=%s '+
                          'AND P.ACCOUNT_ID=%s';
  FSSqlSessionExists:='SELECT SESSION_ID FROM /*PREFIX*/SESSIONS WHERE SESSION_ID=%s';
  FSSqlSessions:='SELECT SESSION_ID FROM /*PREFIX*/SESSIONS WHERE SESSION_ID IN (%s)';
  FSSqlGetServerDate:='SELECT DISTINCT(CURRENT_TIMESTAMP) FROM /*PREFIX*/APPLICATIONS';
  FSFieldNameQuote:='"';
  FSFormatDateTimeValue:='yyyy-mm-dd hh:nn:ss';
  FSFormatDateValue:='yyyy-mm-dd';
  FSSqlInsert:='INSERT INTO %s (%s) VALUES (%s)';
  FSSqlUpdate:='UPDATE %s SET %s WHERE %s';
  FSSQLGetKeys:='SELECT I.RDB$FIELD_NAME '+
                'FROM RDB$RELATION_CONSTRAINTS RC, RDB$INDEX_SEGMENTS I, RDB$INDICES IDX '+
                'WHERE (I.RDB$INDEX_NAME = RC.RDB$INDEX_NAME) AND '+
                '(IDX.RDB$INDEX_NAME = RC.RDB$INDEX_NAME) AND '+
                '(RC.RDB$CONSTRAINT_TYPE = ''PRIMARY KEY'') AND '+
                '(RC.RDB$RELATION_NAME = %s) '+
                'ORDER BY I.RDB$FIELD_POSITION';
  FSFormatFilterDateValue:='%s';

  DisableMonitoring;
end;

destructor TBisIBaseConnection.Destroy;
begin
  FSessions.Free;
  FLinkedRealDefaultDatabase:=nil;
  FDefaultDatabase.Free;
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

function TBisIBaseConnection.GetSessionsClass: TBisIBaseSessionsClass;
begin
  Result:=TBisIBaseSessions;
end;

function TBisIBaseConnection.GetRealRealDefaultDatabase: TBisIBaseDatabase;
begin
  Result:=FDefaultDatabase;
  if Assigned(FLinkedRealDefaultDatabase) then
    Result:=FLinkedRealDefaultDatabase;
end;

procedure TBisIBaseConnection.Lock;
begin
  EnterCriticalSection(FLock);
  FWorking:=true;
end;

procedure TBisIBaseConnection.UnLock;
begin
  LeaveCriticalSection(FLock);
  FWorking:=false;
end;

function TBisIBaseConnection.CloneConnection(const SessionId: Variant; WithDefault: Boolean=true): TBisConnection;
var
  Clone: TBisIBaseConnection;
  Item, Session: TBisIBaseSession;
begin
  Result:=inherited CloneConnection(SessionId);
  if Assigned(Result) and (Result is TBisIBaseConnection) then begin
    Clone:=TBisIBaseConnection(Result);
    if WithDefault then begin
      Clone.FDefaultDatabase.CopyFrom(FDefaultDatabase);
      Clone.FDefaultDatabase.Connected:=FDefaultDatabase.Connected;
      CLone.FLinkedRealDefaultDatabase:=nil;
    end else
      CLone.FLinkedRealDefaultDatabase:=FDefaultDatabase;
    Item:=FSessions.Find(SessionId);
    if Assigned(Item) then begin
      Session:=Clone.Sessions.Add(Item.SessionId,Item.DateCreate,Item.ApplicationId,
                                  Item.AccountId,Item.UserName,Item.Password,
                                  Item.Database.UserName,Item.Database.Password,
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

procedure TBisIBaseConnection.RemoveConnection(Connection: TBisConnection; const SessionId: Variant; IsLogout: Boolean);
var
  Session: TBisIBaseSession;
begin
  if Assigned(Connection) and (Connection is TBisIBaseConnection) and (Connection<>Self) then begin
    if IsLogout then begin
      Session:=FSessions.Find(SessionId);
      if Assigned(Session) then
        FSessions.Remove(Session,false);
    end else
      FSessions.CopyFrom(TBisIBaseConnection(Connection).Sessions,false);
  end;
  inherited RemoveConnection(Connection,SessionId,IsLogout);
end;

procedure TBisIBaseConnection.ChangeParams(Sender: TObject);
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
      if AnsiSameText(Param.ParamName,SDBParamDatabase) then begin
        FDefaultDatabase.DatabaseName:=Param.Value;
        Flag:=false;
      end;
      if AnsiSameText(Param.ParamName,SDBParamPrefix) or
         AnsiSameText(Param.ParamName,SDBParamTimeOut) or
         AnsiSameText(Param.ParamName,SDBParamCheckProductVersion)or
         AnsiSameText(Param.ParamName,SDBParamMaxRecordCount) then begin
        Flag:=false;
        if AnsiSameText(Param.ParamName,SDBParamCheckProductVersion) then
          FCheckProductVersion:=Boolean(StrToIntDef(Param.Value,Integer(true)));
        if AnsiSameText(Param.ParamName,SDBParamMaxRecordCount) then
          FMaxRecordCount:=StrToIntDef(Param.Value,FMaxRecordCount);
      end;

      if Flag then
        Str.Add(FormatEx('%s=%s',[Param.ParamName,Param.Value]));
    end;
    FDefaultDatabase.Params.Text:=Str.Text;
  finally
    Str.Free;
  end;
end;

function TBisIBaseConnection.GetPrefix: String;
var
  Param: TBisConnectionParam;
begin
  Result:='';
  Param:=Params.Find(SDBParamPrefix);
  if Assigned(Param) then
    Result:=Param.Value;
end;

function TBisIBaseConnection.GetTimeOut: Integer;
var
  Param: TBisConnectionParam;
begin
  Result:=0;
  Param:=Params.Find(SDBParamTimeOut);
  if Assigned(Param) then
    Result:=VarToIntDef(Param.Value,Result);
end;

function TBisIBaseConnection.PreparePrefix(AName: String): String;
begin
  Result:=Format('%s%s',[GetPrefix,AName]);
end;

procedure TBisIBaseConnection.Init;
begin
  inherited Init;
  ChangeParams(Params);
end;

function TBisIBaseConnection.GetDbUserName(UserName, Password: String;
                                           var AccountId, FirmId, FirmSmallName: Variant; var DbUserName, DbPassword: String): Boolean;
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Sql: String;
  AAccountId: String;
  NewPass: String;
  MD: String;
begin
  Lock;
  try
    Result:=false;
    if RealDefaultDatabase.Connected then begin
      Query:=TBisIBaseQuery.Create(nil);
      Tran:=TBisIBaseTransaction.Create(nil);
      try
        RealDefaultDatabase.AddTransaction(Tran);
        Tran.AddDatabase(RealDefaultDatabase);
        Tran.TimeOut:=GetTimeOut;
        Tran.Active:=true;
        Query.Transaction:=Tran;
        Query.Database:=RealDefaultDatabase;
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
        Tran.Free;
        Query.Free;
      end;
    end;
  finally
    Unlock;
  end;
end;

function TBisIBaseConnection.ApplicationExists(ApplicationId,AccountId: Variant; ProductVersion: String): Boolean;
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Sql: String;
begin
  Lock;
  try
    Result:=false;
    if RealDefaultDatabase.Connected then begin
      Query:=TBisIBaseQuery.Create(nil);
      Tran:=TBisIBaseTransaction.Create(nil);
      try
        RealDefaultDatabase.AddTransaction(Tran);
        Tran.AddDatabase(RealDefaultDatabase);
        Tran.TimeOut:=GetTimeOut;
        Tran.Active:=true;
        Query.Transaction:=Tran;
        Query.Database:=RealDefaultDatabase;
        Sql:=FormatEx(FSSqlApplicationExists,[QuotedStr(VarToStrDef(ApplicationId,'')),QuotedStr(VarToStrDef(AccountId,''))]);
        Query.SQL.Text:=ReplaceText(Sql,SPrefix,GetPrefix);
        Query.Open;
        if Query.Active and not Query.IsEmpty then begin
          Result:=not Boolean(Query.FieldByName('LOCKED').AsInteger);
          if Result and FCheckProductVersion then
            Result:=AnsiSameText(Query.FieldByName('PRODUCT_VERSION').AsString,ProductVersion);           
        end;
      finally
        Tran.Free;
        Query.Free;
      end;
    end;
  finally
    Unlock;
  end;
end;

function TBisIBaseConnection.SessionExists(SessionId: Variant): Boolean;
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Sql: String;
begin
  Lock;
  try
    Result:=false;
    if RealDefaultDatabase.Connected then begin
      Query:=TBisIBaseQuery.Create(nil);
      Tran:=TBisIBaseTransaction.Create(nil);
      try
        RealDefaultDatabase.AddTransaction(Tran);
        Tran.AddDatabase(RealDefaultDatabase);
        Tran.TimeOut:=GetTimeOut;
        Tran.Active:=true;
        Query.Transaction:=Tran;
        Query.Database:=RealDefaultDatabase;
        Sql:=FormatEx(FSSqlSessionExists,[QuotedStr(VarToStrDef(SessionId,''))]);
        Query.SQL.Text:=ReplaceText(Sql,SPrefix,GetPrefix);
        Query.Open;
        Result:=Query.Active and not Query.IsEmpty;
      finally
        Tran.Free;
        Query.Free;
      end;
    end;
  finally
    Unlock;
  end;
end;

function TBisIBaseConnection.SessionFind(SessionId: Variant): TBisIBaseSession;
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

function TBisIBaseConnection.GetSessionIDs: String;
var
  i: Integer;
  Item: TBisIBaseSession;
begin
  Result:='';
  for i:=0 to FSessions.Count-1 do begin
    Item:=FSessions.Items[i];
    if Trim(Item.SessionId)<>'' then begin
      Result:=iff(Result<>'',Result+',','')+QuotedStr(Item.SessionId);
    end;
  end;
end;

procedure TBisIBaseConnection.CheckSessions;
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Sql: String;
  S: String;
  Session: TBisIBaseSession;
  i: Integer;
begin
  Lock;
  try
    S:=GetSessionIDs;
    if RealDefaultDatabase.Connected and (Trim(S)<>'') then begin
      Query:=TBisIBaseQuery.Create(nil);
      Tran:=TBisIBaseTransaction.Create(nil);
      try
        RealDefaultDatabase.AddTransaction(Tran);
        Tran.AddDatabase(RealDefaultDatabase);
        Tran.TimeOut:=GetTimeOut;
        Tran.Active:=true;
        Query.Transaction:=Tran;
        Query.Database:=RealDefaultDatabase;
        Sql:=FormatEx(FSSqlSessions,[S]);
        Query.SQL.Text:=ReplaceText(Sql,SPrefix,GetPrefix);
        Query.Open;
        if Query.Active then begin
          for i:=FSessions.Count-1 downto 0 do begin
            Session:=FSessions.Items[i];
            if not Query.Locate(Query.Fields[0].FieldName,Session.SessionId,[]) then
              FSessions.Remove(Session,false);
          end;
        end;
      finally
        Tran.Free;
        Query.Free;
      end;
    end;
  finally
    Unlock;
  end;
end;

function TBisIBaseConnection.GetFieldNameQuote: String;
begin
  Result:=FSFieldNameQuote;
end;

function TBisIBaseConnection.GetRecordsFilterDateValue(Value: TDateTime): String;
var
  D: TDate;
begin
  D:=DateOf(Value);
  if D<>Value then
    Result:=FormatEx(FSFormatFilterDateValue,[QuotedStr(FormatDateTime(FSFormatDateTimeValue,Value))])
  else
    Result:=FormatEx(FSFormatFilterDateValue,[QuotedStr(FormatDateTime(FSFormatDateValue,Value))]);
end;

function TBisIBaseConnection.GetConnected: Boolean;
begin
  Result:=RealDefaultDatabase.Connected;
end;

function TBisIBaseConnection.GetWorking: Boolean;
begin
  Result:=FWorking;
end;

function TBisIBaseConnection.GetSessionCount: Integer;
begin
  Result:=FSessions.Count;
end;

procedure TBisIBaseConnection.Connect;
begin
  Lock;
  try
    try
      RealDefaultDatabase.Connected:=false;
      RealDefaultDatabase.Connected:=true;
    except
      On E: Exception do
        raise EBisConnection.CreateFmt(ECConnectFailed,SConnectFailed,[E.Message]);
    end;
  finally
    UnLock;
  end;
end;

procedure TBisIBaseConnection.Disconnect;
begin
  Lock;
  try
    try
      if FSessions.Count=0 then
        RealDefaultDatabase.Connected:=false;
    except
      On E: Exception do
        raise EBisConnection.CreateFmt(E�DisconnectFailed,SDisconnectFailed,[E.Message]);
    end;
  finally
    UnLock;
  end;
end;

function TBisIBaseConnection.GetTableName(SQL: String; var Where: String): String;
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

procedure TBisIBaseConnection.ImportScript(Stream: TStream);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  SQL: String;
begin
  Lock;
  try
    if (Stream.Size>0) and RealDefaultDatabase.Connected then begin
      Stream.Position:=0;
      SetLength(SQL,Stream.Size);
      Stream.ReadBuffer(Pointer(SQL)^,Stream.Size);
      if Trim(SQL)<>'' then begin
        LoggerWrite(FSImportScriptStart);
        try
          Query:=TBisIBaseQuery.Create(nil);
          Tran:=TBisIBaseTransaction.Create(nil);
          try
            RealDefaultDatabase.AddTransaction(Tran);
            Tran.AddDatabase(RealDefaultDatabase);
            Tran.TimeOut:=GetTimeOut;
            Tran.Active:=true;
            Query.Transaction:=Tran;
            Query.Database:=RealDefaultDatabase;
            Query.ParamCheck:=false;
            SQL:=Trim(SQL);
            LoggerWrite(FormatEx(FSImportScriptSql,[SQL]));
            Query.SQL.Text:=ReplaceText(SQL,SPrefix,GetPrefix);;
            Tran.Active:=false;
            try
//              Tran.StartTransaction;
              Tran.Active:=true;
              Query.ExecSQL;
              if Tran.Active then
                Tran.Commit;
              LoggerWrite(FSImportScriptSuccess);
            except
              On E: Exception do begin
                Tran.Rollback;
                raise Exception.Create(E.Message);
              end;
            end;
          finally
            Tran.Free;
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

procedure TBisIBaseConnection.ImportTable(Stream: TStream);

  procedure GetKeys(TableName: String; Keys: TStrings);
  var
    Query: TBisIBaseQuery;
    Tran: TBisIBaseTransaction;
    SQL: String;
  begin
    Query:=TBisIBaseQuery.Create(nil);
    Tran:=TBisIBaseTransaction.Create(nil);
    try
      RealDefaultDatabase.AddTransaction(Tran);
      Tran.AddDatabase(RealDefaultDatabase);
      Tran.TimeOut:=GetTimeOut;
      Tran.Active:=true;
      Query.Transaction:=Tran;
      Query.Database:=RealDefaultDatabase;
      SQL:=FormatEx(FSSQLGetKeys,[QuotedStr(PreparePrefix(TableName))]);
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
      Tran.Free;
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
    Query: TBisIBaseQuery;
    Tran: TBisIBaseTransaction;
    i: Integer;
    Field: TField;
    Fields: String;
    Values: String;
    Param: TParam;
    SQL: String;
  begin
    Result:=false;
    try
      Query:=TBisIBaseQuery.Create(nil);
      Tran:=TBisIBaseTransaction.Create(nil);
      try
        RealDefaultDatabase.AddTransaction(Tran);
        Tran.AddDatabase(RealDefaultDatabase);
        Tran.TimeOut:=GetTimeOut;
        Tran.Active:=true;
        Query.Transaction:=Tran;
        Query.Database:=RealDefaultDatabase;
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
              ftTimeStamp: Param.DataType:=ftDateTime;
            end;
            Param.Value:=Field.Value;
          end;
        end;
        DumpParams(Query.Params);
        Tran.Active:=false;
//        Tran.StartTransaction;
        Tran.Active:=true;
        Query.ExecSQL;
        Tran.Commit;
        Result:=true;
      finally
        Tran.Free;
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
    Query: TBisIBaseQuery;
    Tran: TBisIBaseTransaction;
    i: Integer;
    Field: TField;
    FieldValues: String;
    Condition: String;
    Param: TParam;
    SQL: String;
  begin
    Result:=false;
    try
      Query:=TBisIBaseQuery.Create(nil);
      Tran:=TBisIBaseTransaction.Create(nil);
      try
        RealDefaultDatabase.AddTransaction(Tran);
        Tran.AddDatabase(RealDefaultDatabase);
        Tran.TimeOut:=GetTimeOut;
        Tran.Active:=true;
        Query.Transaction:=Tran;
        Query.Database:=RealDefaultDatabase;
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
              ftTimeStamp: Param.DataType:=ftDateTime;
            end;
            Param.Value:=Field.Value;
          end;
        end;
//        DumpParams(Query.Params);
        Tran.Active:=false;
//        Tran.StartTransaction;
        Tran.Active:=true;
        Query.ExecSQL;
        Tran.Commit;
        Result:=true;
      finally
        Tran.Free;
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
    if (Stream.Size>0) and RealDefaultDatabase.Connected then begin
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

procedure TBisIBaseConnection.Import(ImportType: TBisConnectionImportType; Stream: TStream);
begin
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
end;

procedure TBisIBaseConnection.ExportScript(const Value: String; Stream: TStream; Params: TBisConnectionExportParams=nil);
begin
  Lock;
  try

  finally
    Unlock;
  end;
end;

procedure TBisIBaseConnection.ExportTable(const Value: String; Stream: TStream; Params: TBisConnectionExportParams=nil);
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  DataSet: TBisDataSet;
  TableName: String;
  Where: String;
  FromPos, FetchCount: Integer;
  Position: Integer;
begin
  Lock;
  try
    if RealDefaultDatabase.Connected then begin
      try
        Query:=TBisIBaseQuery.Create(nil);
        Tran:=TBisIBaseTransaction.Create(nil);
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
          RealDefaultDatabase.AddTransaction(Tran);
          Tran.AddDatabase(RealDefaultDatabase);
          Tran.TimeOut:=GetTimeOut;
          Tran.Active:=true;
          Query.Transaction:=Tran;
          Query.Database:=RealDefaultDatabase;
          Query.UniDirectional:=true;
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
          Tran.Free;
          Query.Free;
        end;
      except
        On E: Exception do begin
          raise;
        end;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TBisIBaseConnection.Export(ExportType: TBisConnectionExportType; const Value: String;
                                     Stream: TStream; Params: TBisConnectionExportParams=nil);
begin
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
end;

function TBisIBaseConnection.GetInternalServerDate: TDateTime;
var
  Query: TBisIBaseQuery;
  Tran: TBisIBaseTransaction;
  Sql: String;
  Value: Variant;
begin
  Lock;
  try
    Result:=Now;
    if RealDefaultDatabase.Connected then begin
      Query:=TBisIBaseQuery.Create(nil);
      Tran:=TBisIBaseTransaction.Create(nil);
      try
        RealDefaultDatabase.AddTransaction(Tran);
        Tran.AddDatabase(RealDefaultDatabase);
        Tran.TimeOut:=GetTimeOut;
        Tran.Active:=true;
        Query.Transaction:=Tran;
        Query.Database:=RealDefaultDatabase;
        Sql:=FSSqlGetServerDate;
        Query.SQL.Text:=ReplaceText(Sql,SPrefix,GetPrefix);
        Query.Open;
        if Query.Active and not Query.IsEmpty then begin
          Value:=Query.Fields[0].Value;
          if not VarIsNull(Value) then
            Result:=VarToDateDef(Value,Result);
        end;
      finally
        Tran.Free;
        Query.Free;
      end;
    end;
  finally
    UnLock;
  end;
end;

function TBisIBaseConnection.GetServerDate: TDateTime;
begin
  try
    Result:=GetInternalServerDate;
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECGetServerDateFailed,SGetServerDateFailed,[E.Message]);
  end;
end;

function TBisIBaseConnection.Login(const ApplicationId: Variant; const UserName,Password: String; Params: TBisConnectionLoginParams=nil): Variant;
var
  UserDefault: Boolean;
  AccountId: Variant;
  FirmId: Variant;
  FirmSmallName: Variant;
  DbUserName: String;
  DbPassword: String;
  ASession: TBisIBaseSession;
  SessionParams, IPList: String;
  ProductVersion: String;
begin
  try
    if GetDbUserName(UserName,Password,AccountId,FirmId,FirmSmallName,DbUserName,DbPassword) then begin

      ProductVersion:='';
      if Assigned(Params) then
        ProductVersion:=Params.ProductVersion;

      if ApplicationExists(ApplicationId,AccountId,ProductVersion) then begin

        UserDefault:=(Trim(DbUserName)='') or
                     AnsiSameText(RealDefaultDatabase.UserName,DbUserName);
        if UserDefault then begin
          DbUserName:=RealDefaultDatabase.UserName;
          DbPassword:=RealDefaultDatabase.Password;
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

procedure TBisIBaseConnection.Logout(const SessionId: Variant);
var
  ASession: TBisIBaseSession;
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

function TBisIBaseConnection.Check(const SessionId: Variant; var ServerDate: TDateTime): Boolean;
var
  ASession: TBisIBaseSession;
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

procedure TBisIBaseConnection.Update(const SessionId: Variant; Params: TBisConfig=nil);
var
  ASession: TBisIBaseSession;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) then begin
      T:=GetTickCount(F);
      try
        ASession.CheckLocks(SRefreshPermissions);
        ASession.Params.CopyFrom(Params);
      finally
        ASession.Update(Assigned(Params),'',GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECUpdateFailed,SUpdateFailed,[E.Message]);
  end;
end;

procedure TBisIBaseConnection.LoadProfile(const SessionId: Variant; Profile: TBisProfile);
var
  ASession: TBisIBaseSession;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Profile) then begin
      T:=GetTickCount(F);
      try
        ASession.CheckLocks(SLoadProfile);
        ASession.LoadProfile(Profile);
      finally
        ASession.Update(False,'',GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadProfileFailed,SLoadProfileFailed,[E.Message]);
  end;
end;

procedure TBisIBaseConnection.SaveProfile(const SessionId: Variant; Profile: TBisProfile);
var
  ASession: TBisIBaseSession;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Profile) then begin
      T:=GetTickCount(F);
      try
        ASession.CheckLocks(SSaveProfile);
        ASession.SaveProfile(Profile);
      finally
        ASession.Update(False,'',GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECSaveProfileFailed,SSaveProfileFailed,[E.Message]);
  end;
end;

procedure TBisIBaseConnection.RefreshPermissions(const SessionId: Variant);
var
  ASession: TBisIBaseSession;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) then begin
      T:=GetTickCount(F);
      try
        ASession.CheckLocks(SRefreshPermissions);
        ASession.LoadRoles;
        ASession.LoadPermissions;
      finally
        ASession.Update(False,'',GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECRefreshPermissionsFailed,SRefreshPermissionsFailed,[E.Message]);
  end;
end;

procedure TBisIBaseConnection.LoadInterfaces(const SessionId: Variant; Interfaces: TBisInterfaces);
var
  ASession: TBisIBaseSession;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Interfaces) then begin
      T:=GetTickCount(F);
      try                                                       
        ASession.CheckLocks(SLoadInterfaces);
        ASession.LoadInterfaces(Interfaces);
      finally
        ASession.Update(False,'',GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadInterfacesFailed,SLoadInterfacesFailed,[E.Message]);
  end;
end;

procedure TBisIBaseConnection.GetRecords(const SessionId: Variant; DataSet: TBisDataSet);
var
  ASession: TBisIBaseSession;
  Query: String;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(DataSet) then begin
      T:=GetTickCount(F);
      try
        ASession.CheckLocks(SGetRecords,DataSet.ProviderName);
        ASession.GetRecords(DataSet,Query);
      finally
        ASession.Update(false,Query,GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECGetRecordsFailed,SGetRecordsFailed,[E.Message]);
  end;
end;

procedure TBisIBaseConnection.Execute(const SessionId: Variant; DataSet: TBisDataSet);
var
  ASession: TBisIBaseSession;
  Query: String;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(DataSet) then begin
      T:=GetTickCount(F);
      try
        ASession.CheckLocks(SExecute,DataSet.ProviderName);
        ASession.Execute(DataSet,Query);
      finally
        ASession.Update(False,Query,GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECExecuteFailed,SExecuteFailed,[E.Message]);
  end;
end;

procedure TBisIBaseConnection.LoadMenus(const SessionId: Variant; Menus: TBisMenus);
var
  ASession: TBisIBaseSession;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Menus) then begin
      T:=GetTickCount(F);
      try
        ASession.CheckLocks(SLoadMenus);
        ASession.LoadMenus(Menus);
      finally
        ASession.Update(False,'',GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadMenusFailed,SLoadMenusFailed,[E.Message]);
  end;
end;

procedure TBisIBaseConnection.LoadTasks(const SessionId: Variant; Tasks: TBisTasks);
var
  ASession: TBisIBaseSession;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Tasks) then begin
      T:=GetTickCount(F);
      try
        ASession.CheckLocks(SLoadTasks);
        ASession.LoadTasks(Tasks);
      finally
        ASession.Update(False,'',GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadTasksFailed,SLoadTasksFailed,[E.Message]);
  end;
end;

procedure TBisIBaseConnection.SaveTask(const SessionId: Variant; Task: TBisTask);
var
  ASession: TBisIBaseSession;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Task) then begin
      T:=GetTickCount(F);
      try
        ASession.CheckLocks(SSaveTask);
        ASession.SaveTask(Task);
      finally
        ASession.Update(False,'',GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECSaveTaskFailed,SSaveTaskFailed,[E.Message]);
  end;
end;

procedure TBisIBaseConnection.LoadAlarms(const SessionId: Variant; Alarms: TBisAlarms);
var
  ASession: TBisIBaseSession;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Alarms) then begin
      T:=GetTickCount(F);
      try
        ASession.CheckLocks(SLoadAlarms);
        ASession.LoadAlarms(Alarms);
      finally
        ASession.Update(False,'',GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadAlarmsFailed,SLoadAlarmsFailed,[E.Message]);
  end;
end;

procedure TBisIBaseConnection.LoadScript(const SessionId: Variant; ScriptId: Variant; Stream: TStream);
var
  ASession: TBisIBaseSession;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Stream) then begin
      T:=GetTickCount(F);
      try
        ASession.CheckLocks(SLoadScript);
        ASession.LoadScript(ScriptId,Stream);
      finally
        ASession.Update(False,'',GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadScriptFailed,SLoadScriptFailed,[E.Message]);
  end;
end;

procedure TBisIBaseConnection.LoadReport(const SessionId: Variant; ReportId: Variant; Stream: TStream);
var
  ASession: TBisIBaseSession;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Stream) then begin
      T:=GetTickCount(F);
      try
        ASession.CheckLocks(SLoadReport);
        ASession.LoadReport(ReportId,Stream);
      finally
        ASession.Update(False,'',GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadReportFailed,SLoadReportFailed,[E.Message]);
  end;
end;

procedure TBisIBaseConnection.LoadDocument(const SessionId: Variant; DocumentId: Variant; Stream: TStream);
var
  ASession: TBisIBaseSession;
  T, F: Int64;
begin
  try
    ASession:=SessionFind(SessionId);
    if Assigned(ASession) and Assigned(Stream) then begin
      T:=GetTickCount(F);
      try
        ASession.CheckLocks(SLoadDocument);
        ASession.LoadDocument(DocumentId,Stream);
      finally
        ASession.Update(False,'',GetTickDifference(T,F,dtMilliSec));
      end;
    end else
      raise EBisConnection.Create(ECInvalidSession,SInvalidSession);
  except
    on E: Exception do
      raise EBisConnection.CreateFmt(ECLoadDocumentFailed,SLoadDocumentFailed,[E.Message]);
  end;
end;

end.



