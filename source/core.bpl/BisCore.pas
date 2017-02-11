unit BisCore;
                                    
interface

uses Windows, Classes, SysUtils, Controls, SyncObjs,
     BisObject, BisCmdLine, BisConfig, BisLogger, BisLocalBase, BisProfile,
     BisDataSet,
     BisConnectionModules, BisIfaceModules, BisServerModules,
     BisObjectModules,  BisScriptModules, BisReportModules, 
     BisProviderModules,
     BisIfaces, BisApplication, BisExceptNotifier, BisThreads,
     BisSplashFm, BisAboutFm, BisLanguage, BisLoginFm, BisInterfaces, BisConnections,
     BisProvider, BisDataFm, BisNotifyEvents, BisProgressEvents, BisAudit, BisMenus,
     BisTasks, BisEvents, BisWatchGroups, BisAlarmsFm,
     BisCoreIntf;

type
  TBisCoreDataSelectIntoMode=(imInterface,imIfaceClass,imIface);

  TBisCoreTask=class(TBisTask)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCore=class(TBisObject,IBisCore)
  private
    FThreadTime: TBisWaitThread;
    FOldHintWindowClass: THintWindowClass;

    FMutexHandle: THandle;
    FMessageID: UINT;

    FThreadIDs: TStringList;

    FTasks: TBisTasks;
    FExceptNotifier: TBisExceptNotifier;
    FCmdLine: TBisCmdLine;
    FConfig: TBisConfig;
    FLogger: TBisLogger;
    FLocalbase: TBisLocalBase;
    FAudit: TBisAudit;

    FWatchGroups: TBisWatchGroups;
    FWatchSessionId: TBisWatch;
    FWatchServerDate: TBisWatch;
    FWatchLastError: TBisWatch;

    FObjectModules: TBisObjectModules;
    FScriptModules: TBisScriptModules;
    FReportModules: TBisReportModules;
    FConnectionModules: TBisConnectionModules;
    FProviderModules: TBisProviderModules;
    FServerModules: TBisServerModules;
    FIfaceModules: TBisIfaceModules;

    FSplashIface: TBisSplashFormIface;
    FAboutIface: TBisAboutFormIface;
    FLoginIface: TBisLoginFormIface;
    FApplication: TBisApplication;
    FLanguage: TBisLanguage;
    FIfaces: TBisIfaces;
    FInterfaces: TBisInterfaces;
    FProfile: TBisProfile;

    FContentEvents: TBisNotifyEvents;
    FProgressEvents: TBisProgressEvents;
    FAfterLoginEvents: TBisNotifyEvents;
    FBeforeLogoutEvents: TBisNotifyEvents;
    FAfterRunEvents: TBisNotifyEvents;
    FEvents: TBisEvents;

    FEventDeleteSession: TBisEvent;
    FEventCheckSession: TBisEvent;
    FEventRefreshTasks: TBisEvent;
    FEventTerminate: TBisEvent;
    FEventMessage: TBisEvent;
    FEventExecuteCommand: TBisEvent;
    FEventCreateFile: TBisEvent;
    FEventDeleteFile: TBisEvent;
    FEventTerminateProcess: TBisEvent;

    FSStartDelim: String;
    FSStartDir: String;
    FSStartCmd: String;
    FSStartMode: String;
    FSStartAction: String;
    FSStartModuleInfo: String;
    FSStartConfigFileName: String;
    FSStartLoggerFileName: String;
    FSStartConfigText: String;
    FSBeginSnapshot: String;
    FSEndSnapshot: String;
    FSFinishDelim: String;

    FCheckPermissions: Boolean;
    FEditIfaceAsModal: Boolean;
    FIfaceOnlyOneForm: Boolean;
    FSIfaceNotFound: String;
    FSIfaceClassNotFound: String;
    FSInterfaceNotFound: String;

    FSCmdParamConfigDesc: String;
    FSCmdParamLogDesc: String;
    FSCmdParamBaseDesc: String;
    FSCmdParamHelpDesc: String;
    FSCmdParamInstallDesc: String;
    FSCmdParamUninstallDesc: String;
    FSCmdParamServiceDesc: String;
    FSCmdParamCommandDesc: String;
    FSCmdParamShowDesc: String;
    FSCmdParamNoLoginDesc: String;
    FSCmdParamSetDesc: String;

    FSConfigNotFound: String;
    FSNotConnected: String;
    FTranslateToLog: Boolean;
    FNoLogin: Boolean;
    FServerDate: TDateTime;
    FInited: Boolean;
    FSApplicationExit: String;
    FProductVersion: String;
    FSApplicationID: String;
    FSApplicationName: String;
    FSApplicationTitle: String;
    FSApplicationVersion: String;
    FAction: TBisCoreAction;

    procedure SetAction;
    function GetAction: TBisCoreAction;

    procedure RunStandalone;
    procedure RunAutomation;
    procedure RunRegserver;
    procedure RunUnregserver;
    procedure Terminate;

    procedure ThreadTimeTimeout(Thread: TBisWaitThread);
    function GetInited: Boolean;
    function GetMode: TBisCoreMode;
    procedure SnapshotModules;
    procedure InfoToLog;
    function CheckCryptHash: Boolean;
    function Exists: Boolean;
    procedure ApplicationMessage(var Msg: TMsg; var Handled: Boolean);
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
    function GetConnection: TBisConnection;
    function GetLogged: Boolean;
    function GetSessionId: Variant;
    function GetAccountId: Variant;
    function GetAccountUserName: String;
    function GetConfigFile: String;
    procedure SetConfigFile(Value: String);
    function LoggerGetThreadName(Logger: TBisLogger; const ThreadID: Cardinal): String;

    procedure ModulesLoad;
    procedure ModulesUnLoad;
    procedure IfacesLoadOptions;
    procedure IfacesSaveOptions;
    procedure IfacesShow;
    procedure IfacesHide;

    procedure RunDefault;
    procedure RunInstall;
    procedure RunUninstall;
    procedure RunCommand;
    procedure RunShow;
    procedure RunSet;
    procedure RunSave;
    procedure RunHelp;

    function GetFirmId: Variant;

    function EventHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function GetWatchValue(Watch: TBisWatch): Variant;
    procedure ExceptNotifierException(Notifier: TBisExceptNotifier; E: Exception);
    procedure ExceptNotifierSetThreadName(Notifier: TBisExceptNotifier; const ThreadID: Cardinal; const ThreadName: String);
    function GetFirmSmallName: Variant;
    procedure ApplicationExit(Sender: TObject; const ExitMode: TBisApplicationExitMode);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Done; reintroduce;

    function Translate(S: String): String;
    procedure RefreshPermissions;
    procedure ReloadInterfaces;
    procedure RefreshContents;
    procedure Progress(const Min, Max, Position: Integer; var Interrupted: Boolean);
    function GetThreadName(const ThreadID: Cardinal): String;

    function FindIface(ObjectName: String): TBisIface; overload;
    function FindIface(IfaceClass: TBisIfaceClass): TBisIface; overload;
    function GetIface(ObjectName: String): TBisIface;
    function FindIfaceClass(ClassName: String): TBisIfaceClass;
    function GetIfaceClass(ClassName: String): TBisIfaceClass;
    function FindInterface(ObjectName: String): TBisInterface;
    function GetInterface(ObjectName: String): TBisInterface;

    function DataSelectInto(DataName: String; DataSet: TBisDataSet;
                            LocateFields: String; LocateValues: Variant;
                            MultiSelect: Boolean=false; Mode: TBisCoreDataSelectIntoMode=imInterface;
                            NewInstance: Boolean=true): Boolean;

    property Mode: TBisCoreMode read GetMode;
    property Action: TBisCoreAction read GetAction;

    property Tasks: TBisTasks read FTasks;
    property ExceptNotifier: TBisExceptNotifier read FExceptNotifier;
    property CmdLine: TBisCmdLine read FCmdLine;
    property Config: TBisConfig read FConfig;
    property Logger: TBisLogger read FLogger;
    property LocalBase: TBisLocalBase read FLocalBase;
    property Audit: TBisAudit read FAudit;

    property WatchGroups: TBisWatchGroups read FWatchGroups;

    property ObjectModules: TBisObjectModules read FObjectModules;
    property ScriptModules: TBisScriptModules read FScriptModules;
    property ReportModules: TBisReportModules read FReportModules;
    property ConnectionModules: TBisConnectionModules read FConnectionModules;
    property ProviderModules: TBisProviderModules read FProviderModules;
    property ServerModules: TBisServerModules read FServerModules;
    property IfaceModules: TBisIfaceModules read FIfaceModules;

    property SplashIface: TBisSplashFormIface read FSplashIface;
    property AboutIface: TBisAboutFormIface read FAboutIface;
    property LoginIface: TBisLoginFormIface read FLoginIface;
    property Ifaces: TBisIfaces read FIfaces;
    property Interfaces: TBisInterfaces read FInterfaces;
    property Application: TBisApplication read FApplication;
    property Language: TBisLanguage read FLanguage;
    property Profile: TBisProfile read FProfile;

    property ContentEvents: TBisNotifyEvents read FContentEvents;
    property ProgressEvents: TBisProgressEvents read FProgressEvents;
    property AfterLoginEvents: TBisNotifyEvents read FAfterLoginEvents;
    property BeforeLogoutEvents: TBisNotifyEvents read FBeforeLogoutEvents;
    property AfterRunEvents: TBisNotifyEvents read FAfterRunEvents;
    property Events: TBisEvents read FEvents;

    property SessionId: Variant read GetSessionId;
    property Connection: TBisConnection read GetConnection;
    property Logged: Boolean read GetLogged;
    property AccountId: Variant read GetAccountId;
    property AccountUserName: String read GetAccountUserName;
    property FirmId: Variant read GetFirmId;
    property FirmSmallName: Variant read GetFirmSmallName;                          

    property CheckPermissions: Boolean read FCheckPermissions;                                           
    property EditIfaceAsModal: Boolean read FEditIfaceAsModal;
    property IfaceOnlyOneForm: Boolean read FIfaceOnlyOneForm;
    property TranslateToLog: Boolean read FTranslateToLog;
    property NoLogin: Boolean read FNoLogin;
    property Inited: Boolean read FInited;
    property ProductVersion: String read FProductVersion;

    property ServerDate: TDateTime read FServerDate write FServerDate;
  published

    property SStartModuleInfo: String read FSStartModuleInfo write FSStartModuleInfo;
    property SBeginSnapshot: String read FSBeginSnapshot write FSBeginSnapshot;
    property SEndSnapshot: String read FSEndSnapshot write FSEndSnapshot;
    property SIfaceNotFound: String read FSIfaceNotFound write FSIfaceNotFound;
    property SIfaceClassNotFound: String read FSIfaceClassNotFound write FSIfaceClassNotFound;
    property SInterfaceNotFound: String read FSInterfaceNotFound write FSInterfaceNotFound;
    property SNotConnected: String read FSNotConnected write FSNotConnected;
    property SApplicationExit: String read FSApplicationExit write FSApplicationExit;

    property SApplicationID: String read FSApplicationID write FSApplicationID;
    property SApplicationName: String read FSApplicationName write FSApplicationName;
    property SApplicationTitle: String read FSApplicationTitle write FSApplicationTitle;
    property SApplicationVersion: String read FSApplicationVersion write FSApplicationVersion;

    property SCmdParamConfigDesc: String read FSCmdParamConfigDesc write FSCmdParamConfigDesc;
    property SCmdParamLogDesc: String read FSCmdParamLogDesc write FSCmdParamLogDesc;
    property SCmdParamBaseDesc: String read FSCmdParamBaseDesc write FSCmdParamBaseDesc; 
    property SCmdParamServiceDesc: String read FSCmdParamServiceDesc write FSCmdParamServiceDesc;
    property SCmdParamInstallDesc: String read FSCmdParamInstallDesc write FSCmdParamInstallDesc;
    property SCmdParamUninstallDesc: String read FSCmdParamUninstallDesc write FSCmdParamUninstallDesc;
    property SCmdParamCommandDesc: String read FSCmdParamCommandDesc write FSCmdParamCommandDesc;
    property SCmdParamHelpDesc: String read FSCmdParamHelpDesc write FSCmdParamHelpDesc;
    property SCmdParamShowDesc: String read FSCmdParamShowDesc write FSCmdParamShowDesc;
    property SCmdParamNoLoginDesc: String read FSCmdParamNoLoginDesc write FSCmdParamNoLoginDesc;

  end;

var
  Core: TBisCore=nil;
  ApplicationFinished: Boolean=false;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;

implementation

uses TypInfo, StrUtils, DateUtils, Variants, Forms, Graphics, SvcMgr, DB, mmSystem,
     BisCryptUtils, BisCoreUtils, BisConsts, BisModuleInfo, BisCrypter, BisValues,
     BisStandaloneApplication, BisServiceApplication, BisExceptions, BisSystemUtils,
     BisDialogs, BisUtils, BisHintEx, BisExecuteIface, BisConnectionUtils,
     BisConnectionEditFm, BisMemoFm, BisServerMainFm, BisDeadlocks; 


procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
var
  IsMainModule: Boolean;
begin
  IsMainModule:=false;
  if Assigned(Core) then
    IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule do begin

    if IsMainModule then
      Ifaces.AddClass(TBisServerMainFormIface);

    Ifaces.AddClass(TBisSplashFormIface);
    Ifaces.AddClass(TBisAboutFormIface);
    Ifaces.AddClass(TBisAlarmsFormIface);

  end;
end;

{ TBisCoreTask }

constructor TBisCoreTask.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Schedule:=tscRun;
  IfaceClass:=TBisAboutFormIface;
  Enabled:=false;
end;

type
  TBisCoreTimeThread=class(TBisWaitThread)
  end;

{ TBisCore }

constructor TBisCore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FServerDate:=Now;

  Core:=Self;

  GlobalDeadlocks.Clear;

  GlobalDeadlocks.StackEnabled:=false;

  FOldHintWindowClass:=HintWindowClass;
  HintWindowClass:=TBisHintWindowEx;

  FProductVersion:=GetProductVersion(GetModuleName(HInstance));

  GetCryptInfoFromResource(CryptInfo);

  Forms.Application.OnMessage:=ApplicationMessage;
  Forms.Application.OnIdle:=ApplicationIdle;

  FThreadIDs:=TStringList.Create;
  FThreadIDs.AddObject('Main',TObject(GetCurrentThreadId));

  FTasks:=TBisTasks.Create(Self);

  FContentEvents:=TBisNotifyEvents.Create;
  FProgressEvents:=TBisProgressEvents.Create;
  FAfterLoginEvents:=TBisNotifyEvents.Create;
  FBeforeLogoutEvents:=TBisNotifyEvents.Create;
  FAfterRunEvents:=TBisNotifyEvents.Create;
  FEvents:=TBisEvents.Create;

  FWatchGroups:=TBisWatchGroups.Create;

  with FWatchGroups.Add(ObjectName) do begin
    FWatchSessionId:=Watches.Add('SessionId',GetWatchValue);
    FWatchServerDate:=Watches.Add('ServerDate',GetWatchValue);
    FWatchLastError:=Watches.Add('LastError','');
  end;

  FCmdLine:=TBisCmdLine.Create(Self);

  FConfig:=TBisConfig.Create(Self);
  FConfig.CmdLine:=FCmdLine;

  FLogger:=TBisLogger.Create(Self);
  FLogger.CmdLine:=FCmdLine;
  FLogger.Config:=FConfig;
  FLogger.OnGetThreadName:=LoggerGetThreadName;

  FLocalbase:=TBisLocalBase.Create(Self);
  FLocalbase.CmdLine:=FCmdLine;
  FLocalbase.Config:=FConfig;
  FLocalbase.Logger:=FLogger;
  FLocalBase.CrypterKey:=DefaultKey;
  FLocalBase.CrypterAlgorithm:=DefaultCipherAlgorithm;
  FLocalBase.CrypterMode:=DefaultCipherMode;

  FExceptNotifier:=TBisExceptNotifier.Create(Self);
  FExceptNotifier.Logger:=FLogger;
  FExceptNotifier.LocalBase:=FLocalbase;
  FExceptNotifier.OnException:=ExceptNotifierException;
  FExceptNotifier.OnSetThreadName:=ExceptNotifierSetThreadName;

  FAudit:=TBisAudit.Create(Self);
  FAudit.Localbase:=FLocalbase;

  FTasks.AddTask(FAudit);
  FTasks.AddClass(TBisCoreTask);

  FLanguage:=TBisLanguage.Create(Self);
  FLanguage.LocalBase:=FLocalbase;

  FObjectModules:=TBisObjectModules.Create(Self);
  FScriptModules:=TBisScriptModules.Create(Self);
  FReportModules:=TBisReportModules.Create(Self);
  FConnectionModules:=TBisConnectionModules.Create(Self);
  FProviderModules:=TBisProviderModules.Create(Self);
  FServerModules:=TBisServerModules.Create(Self);
  FIfaceModules:=TBisIfaceModules.Create(Self);

  FSplashIface:=TBisSplashFormIface.Create(Self);
  FAboutIface:=TBisAboutFormIface.Create(Self);
  FLoginIface:=TBisLoginFormIface.Create(Self);

  FIfaces:=TBisIfaces.Create(Self);
  FIfaces.AddClass(TBisAboutFormIface);
  FIfaces.AddClass(TBisExecuteIface);
  FIfaces.AddClass(TBisConnectionEditFormIface);
  FIfaces.AddClass(TBisServerFormIface);

  FInterfaces:=TBisInterfaces.Create(Self);

  FProfile:=TBisProfile.Create(Self);

  FEventDeleteSession:=FEvents.Add(SEventDeleteSession,EventHandler,false);
  FEventCheckSession:=FEvents.Add(SEventCheckSession,EventHandler,false);
  FEventRefreshTasks:=FEvents.Add(SEventRefreshTasks,EventHandler,false);
  FEventTerminate:=FEvents.Add(SEventTerminate,EventHandler,false);
  FEventMessage:=FEvents.Add(SEventMessage,EventHandler,false);
  FEventExecuteCommand:=FEvents.Add(SEventExecuteCommand,EventHandler,false);
  FEventCreateFile:=FEvents.Add(SEventCreateFile,EventHandler,false);
  FEventDeleteFile:=FEvents.Add(SEventDeleteFile,EventHandler,false);
  FEventTerminateProcess:=FEvents.Add(SEventTerminateProcess,EventHandler,false);

  FThreadTime:=TBisCoreTimeThread.Create(100);
  FThreadTime.Priority:=tpTimeCritical;
  FThreadTime.StopOnDestroy:=true;
  FThreadTime.OnTimeout:=ThreadTimeTimeout;
  FThreadTime.Start;
  
  FSStartDelim:='-';
  FSStartDir:='�����=%s';
  FSStartCmd:='��������� ������=%s';
  FSStartMode:='�����=%s';
  FSStartAction:='��������=%s';
  FSStartModuleInfo:='������=%s ������=%s (%s) ������=%d ���=%s';
  FSStartConfigFileName:='���������������� ����=%s';
  FSStartLoggerFileName:='���� �����������=%s';
  FSStartConfigText:='����� ����������������� �����=%s';
  FSBeginSnapshot:='������ ������ ����� ������� ...';
  FSEndSnapshot:='��������� ������ ����� �������.';
  FSFinishDelim:='*';

  FSIfaceNotFound:='��������� %s �� ������.';
  FSIfaceClassNotFound:='������������ ����� %s �� ������.';
  FSInterfaceNotFound:='��������� %s �� ������.';
  FSConfigNotFound:='Config file %s not found.';
  FSNotConnected:='��� ����������.';
  FSApplicationExit:='����� �� ���������� �� �������: %s';

  FSApplicationID:='������������� ����������';
  FSApplicationName:='��� ����������';
  FSApplicationTitle:='��������� ����������';
  FSApplicationVersion:='������ ����������';

  FSCmdParamConfigDesc:='����������� ����� ������������� [/config test.ini]';
  FSCmdParamBaseDesc:='����������� ����� ���������� [/base test.bis]';
  FSCmdParamLogDesc:='����������� ����� ������� [/log test.log]';
  FSCmdParamHelpDesc:='������ �� ��������� ������';
  FSCmdParamInstallDesc:='��������� ������ [/install /service name="Name"]';
  FSCmdParamUninstallDesc:='�������� ������ [/uninstall /service name="Name"]';
  FSCmdParamServiceDesc:='������ ������';
  FSCmdParamCommandDesc:='���������� ������ ������ [/command test]';
  FSCmdParamShowDesc:='������ ����������� [/show test.txt ��� /show test]';
  FSCmdParamSetDesc:='��������� ���������� [/set param_values.txt ��� /set param=value ��� /set param=value.txt]';
  FSCmdParamNoLoginDesc:='��� ����������';

end;

destructor TBisCore.Destroy;
begin
  HintWindowClass:=FOldHintWindowClass;

  FTasks.Clear;
  
  FThreadTime.Free;

  FEvents.Remove(FEventDeleteFile);
  FEvents.Remove(FEventCreateFile);
  FEvents.Remove(FEventExecuteCommand);
  FEvents.Remove(FEventTerminateProcess);
  FEvents.Remove(FEventMessage);
  FEvents.Remove(FEventTerminate);
  FEvents.Remove(FEventRefreshTasks);
  FEvents.Remove(FEventCheckSession);
  FEvents.Remove(FEventDeleteSession);

  FProfile.Free;
  FInterfaces.Free;
  FIfaces.Free;
  FLoginIface.Free;
  FAboutIface.Free;
  FSplashIface.Free;

  FIfaceModules.Free;
  FServerModules.Free;
  FProviderModules.Free;
  FConnectionModules.Free;
  FReportModules.Free;
  FScriptModules.Free;
  FObjectModules.Free;

  FLanguage.Free;
  FExceptNotifier.Free;
  FLocalbase.Free;
  FLogger.Free;
  FConfig.Free;
  FCmdLine.Free;

  FWatchGroups.Free;

  FEvents.Free;
  FAfterRunEvents.Free;
  FAfterLoginEvents.Free;
  FBeforeLogoutEvents.Free;
  FProgressEvents.Free;
  FContentEvents.Free;
  FTasks.Free;

  FThreadIDs.Free;
  
  Core:=nil;
  inherited Destroy;
end;

procedure TBisCore.Init;
var
  Buffer: String;
  Flag: Boolean;
begin
  inherited Init;
  FInited:=false;
  
  FTasks.Init;
  FCmdLine.Init;

  FNoLogin:=FCmdLine.ParamExists(SCmdParamNoLogin);

  FConfig.Init;
  if not FileExists(FConfig.FileName) then begin
    ShowError(FormatEx(FSConfigNotFound,[FConfig.FileName]));                
    exit;
  end;

  FConfig.Load;

  FSStartDelim:=FConfig.Read(ObjectName,SCoreStartDelim,FSStartDelim);
  FSStartDir:=FConfig.Read(ObjectName,SCoreStartDir,FSStartDir);
  FSStartCmd:=FConfig.Read(ObjectName,SCoreStartCmd,FSStartCmd);
  FSStartMode:=FConfig.Read(ObjectName,SCoreStartMode,FSStartMode);
  FSStartAction:=FConfig.Read(ObjectName,SCoreStartAction,FSStartAction);
  FSStartModuleInfo:=FConfig.Read(ObjectName,SCoreStartModuleInfo,FSStartModuleInfo);
  FSStartConfigFileName:=FConfig.Read(ObjectName,SCoreStartConfigFileName,FSStartConfigFileName);
  FSStartLoggerFileName:=FConfig.Read(ObjectName,SCoreStartLoggerFileName,FSStartLoggerFileName);
  FSStartConfigText:=FConfig.Read(ObjectName,SCoreStartConfigText,FSStartConfigText);
  FSFinishDelim:=FConfig.Read(ObjectName,SCoreFinishDelim,FSFinishDelim);

  FLogger.Init;
  FLogger.Load;

  SetAction;
  InfoToLog;

  FLocalbase.Init;
  FLocalbase.Load;

  if FLocalbase.ReadParam(SParamCheckPermissions,Buffer) then begin
    if TryStrToBool(Buffer,Flag) then
      FCheckPermissions:=Flag;
  end;
  if FLocalbase.ReadParam(SParamEditIfaceAsModal,Buffer) then begin
    if TryStrToBool(Buffer,Flag) then
      FEditIfaceAsModal:=Flag;
  end;
  if FLocalbase.ReadParam(SParamIfaceOnlyOneForm,Buffer) then begin
    if TryStrToBool(Buffer,Flag) then
      FIfaceOnlyOneForm:=Flag;
  end;
  if FLocalbase.ReadParam(SParamTranslateToLog,Buffer) then begin
    if TryStrToBool(Buffer,Flag) then
      FTranslateToLog:=Flag;
  end;

  FAudit.Init;
  FAudit.Load;

  FLanguage.Load;
  
  TranslateObject(Self);
  TranslateObject(FCmdLine);
  TranslateObject(FConfig);
  TranslateObject(FLogger);
  TranslateObject(FLocalbase);

  FExceptNotifier.Init;
  FSplashIface.Init;
  FAboutIface.Init;
  FLoginIface.Init;

  FObjectModules.Init;
  FScriptModules.Init;
  FReportModules.Init;
  FConnectionModules.Init;
  FProviderModules.Init;
  FServerModules.Init;
  FIfaceModules.Init;

  FIfaces.Init;
  FInterfaces.Init;
  FProfile.Init;

  FInited:=true;
end;

procedure TBisCore.Done;
begin
  inherited Done;

  FProfile.Done;
  FInterfaces.Done;
  FIfaces.Done;

  FIfaceModules.Done;
  FServerModules.Done;
  FProviderModules.Done;
  FConnectionModules.Done;
  FReportModules.Done;
  FScriptModules.Done;
  FObjectModules.Done;

  FLoginIface.Done;                                            
  FAboutIface.Done;
  FSplashIface.Done;
  FIfaceModules.Done;
  FExceptNotifier.Done;
  FAudit.Done;
  FLocalbase.Done;

  FLogger.Write(DupeString(FSFinishDelim,CountFinishDelim));
  FLogger.Save;
  FLogger.Done;
  FConfig.Done;
  FCmdLine.Done;
  FTasks.Done;

end;

procedure TBisCore.ThreadTimeTimeout(Thread: TBisWaitThread);
begin
  try
    FServerDate:=IncMilliSecond(FServerDate,Thread.Timeout);
  finally
    Thread.Reset;
  end;
end;

function TBisCore.GetInited: Boolean;
begin
  Result:=FInited;
end;

function TBisCore.GetMode: TBisCoreMode;
begin
  Result:=smStandalone;
  if FCmdLine.ParamExists(SCmdParamService) then begin
    Result:=smService;
    exit;
  end;
end;

function TBisCore.GetConfigFile: String;
begin
  Result:=FConfig.FileName;
end;

procedure TBisCore.SetConfigFile(Value: String);
begin
  FConfig.FileName:=Value;
end;

function TBisCore.GetSessionId: Variant;
begin
  Result:=FLoginIface.SessionId;
end;                                        

function TBisCore.GetAccountId: Variant;
begin
  Result:=FLoginIface.AccountId;
end;

function TBisCore.GetAccountUserName: String;
begin
  Result:=FLoginIface.AccountUserName;
end;

function TBisCore.GetAction: TBisCoreAction;
begin
  Result:=FAction;
end;

function TBisCore.GetLogged: Boolean;
begin
  Result:=FLoginIface.Logged;
end;

function TBisCore.GetConnection: TBisConnection;
begin
  Result:=FLoginIface.Connection;
end;

function TBisCore.GetFirmId: Variant;
begin
  Result:=FLoginIface.FirmId;
end;

function TBisCore.GetFirmSmallName: Variant;
begin
  Result:=FLoginIface.FirmSmallName;
end;

function TBisCore.GetThreadName(const ThreadID: Cardinal): String;
var
  Index: Integer;
begin
  Result:='';
  Index:=FThreadIDs.IndexOfObject(TObject(ThreadID));
  if Index>-1 then
    Result:=FThreadIDs.Strings[Index];
end;

function TBisCore.LoggerGetThreadName(Logger: TBisLogger; const ThreadID: Cardinal): String;
begin
  Result:=GetThreadName(ThreadID);
end;

function TBisCore.Exists: Boolean;
var
  Ret: DWord;
  S: String;
  Crypter: TBisCrypter;
begin
  Crypter:=TBisCrypter.Create;
  try
    S:=AnsiUpperCase(FormatEx(SMutexFormat,[FConfig.FileName,FLogger.FileName,FLocalbase.FileName]));
    S:=Crypter.HashString(S,DefaultHashAlgorithm,DefaultHashFormat);
    FMessageID:=RegisterWindowMessage(Pchar(S));
    FMutexHandle:=CreateMutex(nil,false,PChar(S));
    Ret:=GetLastError;
    Result:=Ret=ERROR_ALREADY_EXISTS;
    if Result then
      PostMessage(HWND_BROADCAST,FMessageID,0,0);
  finally
    Crypter.Free;
  end;
end;

procedure TBisCore.SetAction;
begin
  FAction:=saDefault;
  if FCmdLine.ParamExists(SCmdParamHelp) or
     FCmdLine.ParamExists(SCmdParamQ) then begin
    FAction:=saHelp;
    exit;
  end;
  if FCmdLine.ParamExists(SCmdParamInstall) then begin
    FAction:=saInstall;
    exit;
  end;
  if FCmdLine.ParamExists(SCmdParamUninstall) then begin
    FAction:=saUninstall;
    exit;
  end;
  if FCmdLine.ParamExists(SCmdParamCommand) then begin
    FAction:=saCommand;
    exit;
  end;
  if FCmdLine.ParamExists(SCmdParamShow) then begin
    FAction:=saShow;
    exit;
  end;
  if FCmdLine.ParamExists(SCmdParamSet) then begin
    FAction:=saSet;
    exit;
  end;
  if FCmdLine.ParamExists(FLocalbase.CrypterKey) then begin
    FAction:=saSave;
    exit;
  end;
end;

procedure TBisCore.SnapshotModules;
var
  ModuleInfo: TBisModuleInfo;
  MI: TBisModuleInfo;
  i: Integer;
  S: String;
begin
  with FLogger do begin
    Write(FSBeginSnapshot,ltInformation,Self.ObjectName);
    ModuleInfo:=TBisModuleInfo.Create(FCmdLine.FileName);
    try
      ModuleInfo.GetModules;
      ModuleInfo.Modules.Sort;
      for i:=0 to ModuleInfo.Modules.Count-1 do begin
        S:=ModuleInfo.Modules.Strings[i];
        MI:=TBisModuleInfo.Create(S);
        try
          Write(FormatEx(FSStartModuleInfo,[S,MI.FileVersion,MI.ProductVersion,MI.FileSize,MI.FileHash]),ltInformation,Self.ObjectName);
        finally
          MI.Free;
        end;
      end;
    finally
      ModuleInfo.Free;
    end;
    Write(FSEndSnapshot,ltInformation,Self.ObjectName);
  end;
end;

procedure TBisCore.InfoToLog;
begin
  with FLogger do begin
    Write(DupeString(FSStartDelim,CountStartDelim));
    Write(FormatEx(FSStartDir,[ExtractFileDir(FCmdLine.FileName)]),ltInformation,Self.ObjectName);
    Write(FormatEx(FSStartCmd,[FCmdLine.Text]),ltInformation,Self.ObjectName);
    Write(FormatEx(FSStartMode,[GetEnumName(TypeInfo(TBisCoreMode),Integer(Self.Mode))]),ltInformation,Self.ObjectName);
    Write(FormatEx(FSStartAction,[GetEnumName(TypeInfo(TBisCoreAction),Integer(Self.Action))]),ltInformation,Self.ObjectName);
    Write(FormatEx(FSStartLoggerFileName,[FLogger.FileName]),ltInformation,Self.ObjectName);
    Write(FormatEx(FSStartConfigFileName,[FConfig.FileName]),ltInformation,Self.ObjectName);
    Write(FormatEx(FSStartConfigText,[FConfig.Text]),ltInformation,Self.ObjectName);
  end;
end;

function TBisCore.CheckCryptHash: Boolean;
var
  CryptHash: String;
  BaseCryptHash: String;
begin
  Result:=true;
  if FLocalBase.ReadParam(SParamCryptHash,BaseCryptHash) then begin
    CryptHash:=GetHashCryptInfo(CryptInfo);
    Result:=AnsiSameText(CryptHash,BaseCryptHash);
  end;
end;

procedure TBisCore.ModulesLoad;
begin
  FObjectModules.Load;
  FScriptModules.Load;
  FReportModules.Load;
  FConnectionModules.Load;
  FProviderModules.Load;
  FServerModules.Load;
  FIfaceModules.Load;
end;

procedure TBisCore.ModulesUnLoad;
begin
  FIfaceModules.Unload;
  FServerModules.Unload;
  FProviderModules.Unload;
  FConnectionModules.Unload;
  FReportModules.Unload;
  FScriptModules.Unload;
  FObjectModules.Unload;
end;

procedure TBisCore.IfacesLoadOptions;
begin
  FIfaces.IfacesLoadOptions;
  FIfaceModules.IfacesLoadOptions;
  FInterfaces.IfacesLoadOptions;
end;

procedure TBisCore.IfacesSaveOptions;
begin
  FInterfaces.IfacesSaveOptions;
  FIfaceModules.IfacesSaveOptions;
  FIfaces.IfacesSaveOptions;
end;

procedure TBisCore.IfacesShow;
begin
  FIfaces.IfacesShow;
  FIfaceModules.IfacesShow;
  FInterfaces.IfacesShow;
end;

procedure TBisCore.IfacesHide;
begin
  FInterfaces.IfacesHide;
  FIfaceModules.IfacesHide;
  FIfaces.IfacesHide;
end;

procedure TBisCore.RunDefault;
var
  FlagNext: Boolean;
begin
  FApplication.Init;
  FSplashIface.Show;
  ModulesLoad;
  try
    SnapshotModules;
    FlagNext:=true;
    if FLoginIface.Enabled and not FNoLogin then
      FlagNext:=FLoginIface.Login;
    if FlagNext then begin
      FInterfaces.IfacesCreate;
      FSplashIface.BringToFront;
      FServerModules.StartServers;
      IfacesLoadOptions;
      FApplication.FreeTemp;
      IfacesShow;
      try
        FTasks.Start;
        FAfterRunEvents.Call;
        SnapshotModules;
        FSplashIface.Hide;
        FApplication.Run;
      finally
        ApplicationFinished:=true;
        FServerModules.StopServers;
        FConnectionModules.CancelAll;
        FTasks.Stop;
        IfacesSaveOptions;
        IfacesHide;
        FInterfaces.IfacesFree; 
        FLoginIface.Logout;
      end;
    end;
  finally
    ModulesUnLoad;
  end;
end;

procedure TBisCore.RunInstall;
begin
  FApplication.Init;
  FApplication.Install;
end;

procedure TBisCore.RunUninstall;
begin
  FApplication.Init;
  FApplication.Uninstall;
end;

procedure TBisCore.RunCommand;

  procedure TryToShowIfaces;
  var
    Table: TBisDataSet;
    Stream: TMemoryStream;
    Command: String;
    S: String;
    ModuleName: String;
    AEnabled: Boolean;
    Module: TBisIfaceModule;
    IfaceName: String;
    Iface: TBisIface;
    AClass: TBisIfaceClass;
    Param: TBisCmdParam;
  begin
    Stream:=TMemoryStream.Create;
    Table:=TBisDataSet.Create(nil);
    try
      if FLocalbase.ReadParam(SParamCommands,Stream) then begin
        Stream.Position:=0;
        Table.LoadFromStream(Stream);
        Table.Open;
        if Table.Active then begin
          Table.First;
          while not Table.Eof do begin
            Command:=Table.FieldByName(SFieldName).AsString;
            S:=FCmdLine.ValueByParam(SCmdParamCommand,0);
            AEnabled:=Boolean(Table.FieldByName(SFieldEnabled).AsInteger);
            if AEnabled and AnsiSameText(Command,S) then begin
              Iface:=nil;
              ModuleName:=Table.FieldByName(SFieldModule).AsString;
              IfaceName:=Table.FieldByName(SFieldIface).AsString;
              if (Trim(ModuleName)='') or AnsiSameText(ModuleName,Self.ObjectName) then begin
                Iface:=TBisIface(FIfaces.Find(IfaceName));
              end else begin
                ModuleName:=ModuleName+TBisIfaceModule.GetObjectName;
                Module:=TBisIfaceModule(FIfaceModules.Find(ModuleName));
                if Assigned(Module) then begin
                  Iface:=TBisIface(Module.Ifaces.Find(IfaceName));
                  if not Assigned(Iface) then begin
                    AClass:=Module.Classes.Find(IfaceName);
                    if Assigned(AClass) then begin
                      Iface:=Module.Ifaces.AddClass(AClass);
                    end;
                  end;
                end;
              end;
              if Assigned(Iface) then begin
                Param:=FCmdLine.Params.Find(SCmdParamCommand);
                if Assigned(Param) then begin
                  Iface.LoadOptions;
                  try
                    Iface.ShowByCommand(Param,Command);
                  finally
                    Iface.SaveOptions;
                  end;
                end;
              end;
            end;
            Table.Next;
          end;
        end;
      end;
    finally
      Table.Free;
      Stream.Free;
    end;
  end;
    
var
  FlagNext: Boolean;
begin
  FApplication.Init;
  ModulesLoad;
  try
    FlagNext:=true;
    if FLoginIface.Enabled and not FNoLogin then
      FlagNext:=FLoginIface.Login;
    if FlagNext then begin
      FApplication.FreeTemp;
      try
        FTasks.Start;
        FAfterRunEvents.Call;
        SnapshotModules;
        TryToShowIfaces;
      finally
        ApplicationFinished:=true;
        FConnectionModules.CancelAll;
        FTasks.Stop;
        FLoginIface.Logout;
      end;
    end;
  finally
    ModulesUnLoad;
  end;
end;

procedure TBisCore.RunShow;

  procedure InterfacesShow;
  var
    i: Integer;
    List: TStringList;
    S: String;
    Flag: Boolean;
    AInterface: TBisInterface;
    Command: String;
  begin
    List:=TStringList.Create;
    try
      Command:=SCmdParamShow;
      S:=PrepareFileName(FCmdLine,'',Command,Flag);
      if Flag and FileExists(S) then
        List.LoadFromFile(S)
      else List.Add(ExtractFileName(S));
      for i:=0 to List.Count-1 do begin
        AInterface:=TBisInterface(FInterfaces.Find(List.Strings[i]));
        if not Assigned(AInterface) then
          AInterface:=FInterfaces.FindByID(List.Strings[i]);
        if Assigned(AInterface) then
          AInterface.IfaceShowAsMainForm(i=0);
      end;
    finally
      List.Free;
    end;
  end;
  
var
  FlagNext: Boolean;
begin
  FApplication.Init;
  FSplashIface.Show;
  ModulesLoad;
  try
    FlagNext:=true;
    if FLoginIface.Enabled and not FNoLogin then
      FlagNext:=FLoginIface.Login;
    if FlagNext then begin
      FInterfaces.IfacesCreate;
      FSplashIface.BringToFront;
      IfacesLoadOptions;
      FServerModules.StartServers;
      FApplication.FreeTemp;
      try
        FTasks.Start;
        InterfacesShow;
        FAfterRunEvents.Call;
        SnapshotModules;
        FSplashIface.Hide;
        FApplication.Run;
      finally
        ApplicationFinished:=true;
        FServerModules.StopServers;
        FConnectionModules.CancelAll;
        FTasks.Stop;
        IfacesSaveOptions;
        FInterfaces.IfacesFree;
        FLoginIface.Logout;
      end;
    end;
  finally
    ModulesUnLoad;
  end;
end;

procedure TBisCore.RunSet;

  procedure TryToSetParams;
  var
    Param: TBisCmdParam;
    S: String;
    V: TBisValue;
  begin
    if FLocalbase.BaseLoaded then begin
      Param:=FCmdLine.Params.Find(SCmdParamSet);
      if Assigned(Param) and (Param.Values.Count>0) then begin
        V:=Param.Values[0];
        S:='';
        if Trim(V.Name)='' then
          S:=ExpandFileNameEx(V.AsString)
        else
          S:=ExpandFileNameEx(V.Name);
        if FileExists(S) then
          FLocalbase.SetFile(S)
        else
          FLocalbase.SetParamValue(V.Name,V.AsString);
      end;
    end;
  end;

begin
  FApplication.Init;
  FApplication.FreeTemp;
  try
    SnapshotModules;
    TryToSetParams;
  finally
    ApplicationFinished:=true;
  end;
end;

procedure TBisCore.RunSave;

  procedure TryToSaveParams;
  var
    InfoFile: String;
    Key: String;
    Param: TBisCmdParam;
    ACryptInfo: TBisCryptInfo;
  begin
    if FLocalbase.BaseLoaded then begin
      Param:=FCmdLine.Params.Find(FLocalbase.CrypterKey);
      if Assigned(Param) then begin
        if (Param.Values.Count>0) then begin
          Key:=Trim(Param.Values[0].AsString);
        end;
        if Length(Key)=Length(GetUniqueID) then
          FLocalbase.CrypterKey:=Key;
        if (Param.Values.Count>1) then begin
          InfoFile:=Param.Values[1].AsString;
          InfoFile:=ExpandFileNameEx(InfoFile);
          SetCryptInfo(ACryptInfo,FLocalbase.CrypterAlgorithm,FLocalbase.CrypterMode,FLocalbase.CrypterKey);
          CryptInfoSaveToFile(InfoFile,ACryptInfo);
          FLocalbase.SetParamValue(SParamCryptHash,GetHashCryptInfo(ACryptInfo),false);
        end;
        FLocalbase.Save;
      end;
    end;
  end;
  
begin
  FApplication.Init;
  FApplication.FreeTemp;
  try
    SnapshotModules;
    TryToSaveParams;
  finally
    ApplicationFinished:=true;
  end;
end;

procedure TBisCore.RunHelp;
var
  List: TStringList;
const
  FormatCommand='/%s - %s';
  FormatInfo='%s: %s';

  procedure SetInfo;
  begin
    List.Add(Format(FormatInfo,[FSApplicationID,FApplication.ID]));
    List.Add(Format(FormatInfo,[FSApplicationName,FApplication.ObjectName]));
    List.Add(Format(FormatInfo,[FSApplicationTitle,FApplication.Title]));
    List.Add(Format(FormatInfo,[FSApplicationVersion,FApplication.Version]));
  end;

  procedure SetInternalCommands;
  begin
    List.Add(Format(FormatCommand,[SCmdParamConfig,FSCmdParamConfigDesc]));
    List.Add(Format(FormatCommand,[SCmdParamLog,FSCmdParamLogDesc]));
    List.Add(Format(FormatCommand,[SCmdParamBase,FSCmdParamBaseDesc]));
    List.Add(Format(FormatCommand,[SCmdParamHelp,FSCmdParamHelpDesc]));
    List.Add(Format(FormatCommand,[SCmdParamService,FSCmdParamServiceDesc]));
    List.Add(Format(FormatCommand,[SCmdParamInstall,FSCmdParamInstallDesc]));
    List.Add(Format(FormatCommand,[SCmdParamUninstall,FSCmdParamUninstallDesc]));
    List.Add(Format(FormatCommand,[SCmdParamShow,FSCmdParamShowDesc]));
    List.Add(Format(FormatCommand,[SCmdParamSet,FSCmdParamSetDesc]));
    List.Add(Format(FormatCommand,[SCmdParamNoLogin,FSCmdParamNoLoginDesc]));
  end;

  procedure SetExternalCommands;
  var
    Table: TBisDataSet;
    Stream: TMemoryStream;
    Command: String;
    S: String;
    Field: TField;
    AEnabled: Boolean;
    AVisible: Boolean;
    Flag: Boolean;
  begin
    Flag:=FLocalbase.BaseLoaded and CheckCryptHash;
    if Flag then begin
      Stream:=TMemoryStream.Create;
      Table:=TBisDataSet.Create(nil);
      try
        if FLocalbase.ReadParam(SParamCommands,Stream) then begin
          Stream.Position:=0;
          Table.LoadFromStream(Stream);
          Table.Open;
          if Table.Active then begin
            Table.First;
            while not Table.Eof do begin
              Command:=Table.FieldByName(SFieldName).AsString;
              AEnabled:=Boolean(Table.FieldByName(SFieldEnabled).AsInteger);
              Field:=Table.FindField(SFieldVisible);
              AVisible:=true;
              if Assigned(Field) then
                AVisible:=Boolean(Field.AsInteger);
              if AEnabled and AVisible then begin
                S:=Format(FormatCommand,[Format('%s %s',[SCmdParamCommand,Command]),'']);
                Field:=Table.FindField(SFieldDescription);
                if Assigned(Field) then
                  S:=Format(FormatCommand,[Format('%s %s',[SCmdParamCommand,Command]),Field.AsString]);
                List.Add(S);
              end;
              Table.Next;
            end;
          end;
        end;
      finally
        Table.Free;
        Stream.Free;
      end;
    end else
      List.Add(Format(FormatCommand,[SCmdParamCommand,FSCmdParamCommandDesc]));
  end;

var
  S: String;
begin
  FApplication.Init;
  List:=TStringList.Create;
  try
    FApplication.FreeTemp;
    SetInfo;
    List.Add('');
    SetInternalCommands;
    List.Add('');
    SetExternalCommands;
    S:=Trim(List.Text);
    if S<>'' then begin
      ShowInfo(S);
    end;
  finally
    List.Free;
  end;
end;

procedure TBisCore.ApplicationExit(Sender: TObject; const ExitMode: TBisApplicationExitMode);
var
  Reason: String;
begin
  Reason:=GetEnumName(TypeInfo(TBisApplicationExitMode),Integer(ExitMode));
  FLogger.Write(FormatEx(FSApplicationExit,[Reason]),ltInformation,ObjectName);
  if ExitMode in [emLogOff,emShutdown] then begin
    if Mode=smStandalone then begin
      case Action of
        saDefault: begin
          ApplicationFinished:=true;
          FServerModules.StopServers;
          FConnectionModules.CancelAll;
          FTasks.Stop;
          IfacesSaveOptions;
          IfacesHide;
          FInterfaces.IfacesFree;
          FLoginIface.Logout;
          ModulesUnLoad;
        end;
        saInstall: ;
        saUninstall: ;
        saHelp: ;
        saCommand: begin
          ApplicationFinished:=true;
          FLoginIface.Logout;
          ModulesUnLoad;
        end;
        saShow: begin
          ApplicationFinished:=true;
          FServerModules.StopServers;
          FConnectionModules.CancelAll;
          FTasks.Stop;
          IfacesSaveOptions;
          FInterfaces.IfacesFree;
          FLoginIface.Logout;
          ModulesUnLoad;
        end;
        saSet: begin
          ApplicationFinished:=true;
        end;
        saSave: begin
          ApplicationFinished:=true;
        end;
      end;
      timeEndPeriod(1);
      FAudit.Application:=nil;
      Done;
    end;
  end;
end;

procedure TBisCore.RunStandalone;

  function GetApplicationByMode: TBisApplicationClass;
  begin
    Result:=nil;
    case Mode of
      smStandalone: Result:=TBisStandaloneApplication;
      smService: Result:=TBisServiceApplication;
    end;
  end;

var
  FlagNext: Boolean;
  ApplicationClass: TBisApplicationClass;
begin
  if not Exists then begin
    ApplicationClass:=GetApplicationByMode;
    if Assigned(ApplicationClass) then begin
      FApplication:=ApplicationClass.Create(Self);
      timeBeginPeriod(1);
      try
        ApplicationFinished:=false;
        SnapshotModules;
        FApplication.OnExit:=ApplicationExit;
        FAudit.Application:=FApplication;
        case Mode of
          smStandalone, smService: begin
            case Action of
              saDefault,saCommand,saShow,saSet,saSave: begin
                FlagNext:=not FLocalbase.Enabled or
                          (FLocalbase.Enabled and FLocalbase.BaseLoaded and CheckCryptHash);
                if FlagNext then begin
                  case Action of
                    saDefault: RunDefault;
                    saCommand: RunCommand;
                    saShow: RunShow;
                    saSet: RunSet;
                    saSave: RunSave;
                  end;
                end;
              end;
              saInstall: RunInstall;
              saUninstall: RunUninstall;
              saHelp: RunHelp;
            end;
          end;
        end;
      finally
        timeEndPeriod(1);
        FAudit.Application:=nil;
        FApplication.OnExit:=nil;
        FreeAndNilEx(FApplication);
      end;
    end;
  end else begin

  end;
end;

procedure TBisCore.RunAutomation;
begin
end;

procedure TBisCore.RunRegserver;
begin
end;

procedure TBisCore.RunUnregserver;
begin
end;

procedure TBisCore.Terminate;
begin
  if Assigned(FApplication) then
    FApplication.Terminate;
end;

function TBisCore.Translate(S: String): String;
begin
  Result:=FLanguage.Translate(S);
end;

procedure TBisCore.ReloadInterfaces;
begin
  if DefaultLoadInterfaces(FInterfaces) then
    FInterfaces.IfacesRefresh;
end;

procedure TBisCore.RefreshPermissions;
begin
  DefaultRefreshPermissions;
end;

procedure TBisCore.RefreshContents;
begin
  FContentEvents.Call;
end;

procedure TBisCore.Progress(const Min, Max, Position: Integer; var Interrupted: Boolean);
begin
  FProgressEvents.Progress(Min,Max,Position,Interrupted);
end;

procedure TBisCore.ApplicationMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if (Msg.message=FMessageID) and Assigned(FApplication) and Assigned(Forms.Application) then begin
    Forms.Application.Restore;
    if Assigned(Forms.Application.MainForm) and not FApplication.TempExists then begin
      Forms.Application.MainForm.Show;
      Forms.Application.MainForm.BringToFront;
    end;
    Handled:=true;
  end;
end;

procedure TBisCore.ApplicationIdle(Sender: TObject; var Done: Boolean);
begin
end;

function TBisCore.FindIface(ObjectName: String): TBisIface;
var
  i,j: Integer;
  Iface: TBisIface;
  AInterface: TBisInterface;
  Module: TBisIfaceModule;
begin
  Result:=nil;
  if Assigned(Core) then begin

    for i:=0 to FIfaces.Count-1 do begin
      Iface:=FIfaces.Items[i];
      if Assigned(Iface) then begin
        if AnsiSameText(Iface.ObjectName,ObjectName) then begin
          Result:=Iface;
          exit;
        end;
      end;
    end;

    for i:=0 to Core.IfaceModules.Count-1 do begin
      Module:=Core.IfaceModules.Items[i];
      if Module.Enabled then begin
        for j:=0 to Module.Ifaces.Count-1 do begin
          Iface:=Module.Ifaces.Items[j];
          if AnsiSameText(Iface.ObjectName,ObjectName) then begin
            Result:=Iface;
            exit;
          end;
        end;
      end;
    end;

    for i:=0 to FInterfaces.Count-1 do begin
      AInterface:=FInterfaces.Items[i];
      Iface:=AInterface.Iface;
      if Assigned(Iface) then begin
        if AnsiSameText(Iface.ObjectName,ObjectName) then begin
          Result:=Iface;
          exit;
        end;
      end;
    end;

  end;
end;

function TBisCore.FindIface(IfaceClass: TBisIfaceClass): TBisIface;
var
  i,j: Integer;
  Iface: TBisIface;
  AInterface: TBisInterface;
  Module: TBisIfaceModule;
begin
  Result:=nil;
  if Assigned(Core) and Assigned(IfaceClass) then begin

    for i:=0 to FIfaces.Count-1 do begin
      Iface:=FIfaces.Items[i];
      if Assigned(Iface) then begin
        if IsClassParent(Iface.ClassType,IfaceClass) then begin
          Result:=Iface;
          exit;
        end;
      end;
    end;

    for i:=0 to Core.IfaceModules.Count-1 do begin
      Module:=Core.IfaceModules.Items[i];
      if Module.Enabled then begin
        for j:=0 to Module.Ifaces.Count-1 do begin
          Iface:=Module.Ifaces.Items[j];
          if IsClassParent(Iface.ClassType,IfaceClass) then begin
            Result:=Iface;
            exit;
          end;
        end;
      end;
    end;

    for i:=0 to FInterfaces.Count-1 do begin
      AInterface:=FInterfaces.Items[i];
      Iface:=AInterface.Iface;
      if Assigned(Iface) then begin
        if IsClassParent(Iface.ClassType,IfaceClass) then begin
          Result:=Iface;
          exit;
        end;
      end;
    end;

  end;
end;

function TBisCore.GetIface(ObjectName: String): TBisIface;
begin
  Result:=FindIface(ObjectName);
  if not Assigned(Result) then
    raise Exception.CreateFmt(FSIfaceNotFound,[ObjectName]);
end;

function TBisCore.FindIfaceClass(ClassName: String): TBisIfaceClass;
var
  i,j: Integer;
  Iface: TBisIface;
  Module: TBisIfaceModule;
  S: String;
  AInterface: TBisInterface;
  AClass: TBisIfaceClass;
begin
  Result:=nil;
  if Assigned(Core) then begin

    for i:=0 to FIfaces.Count-1 do begin
      Iface:=FIfaces.Items[i];
      if Assigned(Iface) then begin
        S:=Iface.ClassName;
        if AnsiSameText(S,ClassName) then begin
          Result:=TBisIfaceClass(Iface.ClassType);
          exit;
        end;
      end;
    end;

    for i:=0 to Core.IfaceModules.Count-1 do begin
      Module:=Core.IfaceModules.Items[i];
      if Module.Enabled then begin
        for j:=0 to Module.Ifaces.Count-1 do begin
          Iface:=Module.Ifaces.Items[j];
          S:=Iface.ClassName;
          if AnsiSameText(S,ClassName) then begin
            Result:=TBisIfaceClass(Iface.ClassType);
            exit;
          end;
        end;
      end;
    end;

    for i:=0 to Core.IfaceModules.Count-1 do begin
      Module:=Core.IfaceModules.Items[i];
      if Module.Enabled then begin
        for j:=0 to Module.Classes.Count-1 do begin
          AClass:=Module.Classes.Items[j];
          S:=AClass.ClassName;
          if AnsiSameText(S,ClassName) then begin
            Result:=AClass;
            exit;
          end;
        end;
      end;
    end;
    
    for i:=0 to FInterfaces.Count-1 do begin
      AInterface:=FInterfaces.Items[i];
      Iface:=AInterface.Iface;
      if Assigned(Iface) then begin
        S:=Iface.ClassName;
        if AnsiSameText(S,ClassName) then begin
          Result:=TBisIfaceClass(Iface.ClassType);
          exit;
        end;
      end;
    end;
    
  end;
end;

function TBisCore.GetIfaceClass(ClassName: String): TBisIfaceClass;
begin
  Result:=FindIfaceClass(ClassName);
  if not Assigned(Result) then
    raise Exception.CreateFmt(FSIfaceClassNotFound,[ClassName]);
end;

function TBisCore.FindInterface(ObjectName: String): TBisInterface;
begin
  Result:=TBisInterface(Core.Interfaces.Find(ObjectName));
end;

function TBisCore.GetInterface(ObjectName: String): TBisInterface;
begin
  Result:=FindInterface(ObjectName);
  if not Assigned(Result) then
    raise Exception.CreateFmt(FSInterfaceNotFound,[ObjectName]);
end;

function TBisCore.DataSelectInto(DataName: String; DataSet: TBisDataSet;
                                 LocateFields: String; LocateValues: Variant;
                                 MultiSelect: Boolean; Mode: TBisCoreDataSelectIntoMode;
                                 NewInstance: Boolean): Boolean;
var
  AClass: TBisIfaceClass;
  AIface: TBisIface;
  AInterface: TBisInterface;
  DataIface: TBisDataFormIface;
begin
  Result:=false;
  AClass:=nil;
  AIface:=nil;
  case Mode of
    imIfaceClass: AClass:=GetIfaceClass(DataName);
    imIface: begin
      AIface:=GetIface(DataName);
      if Assigned(AIface) then
        AClass:=TBisIfaceClass(AIface.ClassType);
    end;
    imInterface: begin
      AInterface:=GetInterface(DataName);
      if Assigned(AInterface) then begin
        AIface:=AInterface.Iface;
        if Assigned(AIface) then
          AClass:=TBisIfaceClass(AIface.ClassType);
      end;
    end;
  end;
  if Assigned(AClass) and IsClassParent(AClass,TBisDataFormIface) then begin
    if NewInstance then
      DataIface:=TBisDataFormIfaceClass(AClass).Create(nil)
    else DataIface:=TBisDataFormIface(AIface);
    if Assigned(DataIface) then begin
      try
        DataIface.FilterGroups.CopyFrom(DataSet.FilterGroups,false);
        DataIface.LocateFields:=LocateFields;
        DataIface.LocateValues:=LocateValues;
        DataIface.MultiSelect:=MultiSelect;
        Result:=DataIface.SelectInto(DataSet);
      finally
        if NewInstance then
          DataIface.Free;
      end;                             
    end;
  end;
end;

function TBisCore.EventHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;

  function TryDeleteSessions: Boolean;
  var
    P: TBisEventParam;
  begin
    Result:=false;
    P:=InParams.Find(SSessionId);
    if Assigned(FLoginIface) and
       Assigned(P) and VarSameValue(P.Value,FLoginIface.SessionId)  then begin
      FLoginIface.Logout;
      Result:=true;
    end;
  end;

  function TryCheckSessions: Boolean;
  begin
    Result:=DefaultCheckSessions;
  end;

  function TryRefreshTasks: Boolean;
  var
    Flag: Boolean;
  begin                                                  
    Result:=false;
    if FTasks.Enabled then begin
      Flag:=FTasks.Running;
      if Flag then FTasks.Stop;
      try
        FTasks.InternalClear;
        DefaultLoadTasks(FTasks);
        Result:=true;
      finally
        if Flag then FTasks.Start;
      end;
    end;
  end;

  function TryTerminate: Boolean;
  var
    P: TBisEventParam;
  begin
    P:=InParams.Find(SMessage);
    if Assigned(P) and (Trim(P.AsString)<>'') then
      ShowInfo(P.AsString);
    Application.Terminate;
    ProcessStop(GetCurrentProcessId,1000);
    Result:=true;
  end;

  function TryMessage: Boolean;
  var
    P1,P2,P3: TBisEventParam;
    Mode,TimeOut: Integer;
  begin
    Result:=false;
    P1:=InParams.Find(SMessage);
    if Assigned(P1) and (Trim(P1.AsString)<>'') then begin
      Mode:=0;
      P2:=InParams.Find(SMode);
      if Assigned(P2) then
        Mode:=P2.AsInteger;
      TimeOut:=DefaultShowTimeOut;
      P3:=InParams.Find(STimeOut);
      if Assigned(P3) then
        TimeOut:=P3.AsInteger;
      case Mode of
        0: ShowInfo(P1.AsString,TimeOut);
        1: ShowWarning(P1.AsString,TimeOut);
        2: ShowError(P1.AsString,TimeOut);
      else
        ShowInfo(P1.AsString,TimeOut);
      end;
      Result:=true;
    end;
  end;

  function TryExecuteCommand: Boolean;
  var
    P1,P2,P3: TBisEventParam;
    StartupInfo: TStartupInfo;
    ProcessInfo: TProcessInformation;
    Mode: Word;
    TimeOut: Integer; 
    Ret2: DWord;
  begin
    Result:=false;
    P1:=InParams.Find(SCommand);
    if Assigned(P1) then begin
      Mode:=HIDE_WINDOW;
      P2:=InParams.Find(SMode);
      if Assigned(P2) then
        Mode:=P2.AsInteger;
      FillChar(StartupInfo,SizeOf(TStartupInfo),0);
      with StartupInfo do begin
        cb:=SizeOf(TStartupInfo);
        wShowWindow:=Mode;
        dwFlags:=STARTF_USESHOWWINDOW;
      end;
      Result:=CreateProcess(nil,PChar(P1.AsString),nil,nil,False,
                            NORMAL_PRIORITY_CLASS,nil,nil,StartupInfo,ProcessInfo);
      if Result then begin
        TimeOut:=0;
        P3:=InParams.Find(STimeOut);
        if Assigned(P3) then
          TimeOut:=P3.AsInteger;

        Ret2:=STATUS_WAIT_0;  
        if TimeOut>0 then
          Ret2:=WaitForSingleObject(ProcessInfo.hProcess,TimeOut);

        Result:=(Ret2=STATUS_WAIT_0) or (Ret2=WAIT_TIMEOUT);
      end;
    end;
  end;

  function TryCreateFile: Boolean;
  var
    P1,P2: TBisEventParam;
    Stream: TFileStream;
    S: String;
  begin
    Result:=false;
    P1:=InParams.Find(SFileName);
    if Assigned(P1) and (Trim(P1.AsString)<>'') then begin
      // need to create directory before
      Stream:=TFileStream.Create(P1.AsString,fmCreate);
      try
        P2:=InParams.Find(SData);
        if Assigned(P2) then begin
          S:=P2.AsString;
          Stream.Write(Pointer(S)^,Length(S));
        end;
        Result:=true;
      finally
        Stream.Free;
      end;
    end;                                              
  end;

  function TryDeleteFile: Boolean;
  var
    P1: TBisEventParam;
  begin
    Result:=false;
    P1:=InParams.Find(SFileName);
    if Assigned(P1) and (Trim(P1.AsString)<>'') then begin
      if FileExists(P1.AsString) then
        Result:=DeleteFile(P1.AsString)
      else if DirectoryExists(P1.AsString) then begin
        // need to delete directories
      end;
    end;
  end;

  
  function TryTerminateProcess: Boolean;
{  var
    P1,P2: TBisEventParam;}
  begin
    Result:=false;

  end;

begin
  Result:=false;
  try
    if Event=FEventDeleteSession then Result:=TryDeleteSessions
    else if Event=FEventCheckSession then Result:=TryCheckSessions
    else if Event=FEventRefreshTasks then Result:=TryRefreshTasks
    else if Event=FEventTerminate then Result:=TryTerminate
    else if Event=FEventMessage then Result:=TryMessage
    else if Event=FEventExecuteCommand then Result:=TryExecuteCommand
    else if Event=FEventCreateFile then Result:=TryCreateFile
    else if Event=FEventDeleteFile then Result:=TryDeleteFile
    else if Event=FEventTerminateProcess then Result:=TryTerminateProcess;
  except
    on E: Exception do begin
      FLogger.Write(E.Message,ltError,ObjectName);
    end;
  end;
end;

function TBisCore.GetWatchValue(Watch: TBisWatch): Variant;
begin
  Result:=Null;
  if Watch=FWatchSessionId then Result:=SessionId
  else if Watch=FWatchServerDate then Result:=ServerDate;
end;

procedure TBisCore.ExceptNotifierException(Notifier: TBisExceptNotifier; E: Exception);
begin
  if Assigned(E) then
    FWatchLastError.Value:=E.Message;
end;

procedure TBisCore.ExceptNotifierSetThreadName(Notifier: TBisExceptNotifier; const ThreadID: Cardinal; const ThreadName: String);
var
  Index: Integer;
begin
  Index:=FThreadIDs.IndexOfObject(TObject(ThreadID));
  if Index>-1 then
    FThreadIDs.Strings[Index]:=ThreadName
  else
    FThreadIDs.AddObject(ThreadName,TObject(ThreadID));
end;

initialization
  RegisterClass(TBisCore);

end.
