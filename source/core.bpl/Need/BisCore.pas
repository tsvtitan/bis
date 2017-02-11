unit BisCore;

interface

uses Windows, Classes, SysUtils, Controls,
     BisObject, BisCmdLine, BisConfig, BisLogger, BisLocalBase, BisProfile,
     BisDataSet,
     BisConnectionModules, BisIfaceModules, BisServerModules,
     BisObjectModules,  BisScriptModules, BisReportModules, BisMapModules,
     BisProviderModules,
     BisIfaces, BisApplication, BisExceptNotifier,
     BisSplashFm, BisAboutFm, BisLanguage, BisLoginFm, BisInterfaces, BisConnections,
     BisProvider, BisDataFm, BisNotifyEvents, BisProgressEvents, BisAudit, BisMenus,
     BisTasks,
     BisCoreIntf;

type
  TBisCoreDataSelectIntoMode=(imInterface,imIfaceClass,imIface);

  TBisCore=class(TBisObject,IBisCore)
  private
    FOldHintWindowClass: THintWindowClass;

    FMutexHandle: THandle;
    FMessageID: UINT;

    FTasks: TBisTasks;
    FExceptNotifier: TBisExceptNotifier;
    FCmdLine: TBisCmdLine;
    FConfig: TBisConfig;
    FLogger: TBisLogger;
    FLocalbase: TBisLocalBase;
    FAudit: TBisAudit;

    FObjectModules: TBisObjectModules;
    FScriptModules: TBisScriptModules;
    FReportModules: TBisReportModules;
    FMapModules: TBisMapModules;
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
    FProgressEvents2: TBisProgressEvents;
    FAfterLoginEvents: TBisNotifyEvents;
    FBeforeLogoutEvents: TBisNotifyEvents;

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

    FSConfigNotFound: String;
    FSNotConnected: String;
    FTranslateToLog: Boolean;
    FNoLogin: Boolean;

    procedure RunStandalone;
    procedure RunAutomation;
    procedure RunRegserver;
    procedure RunUnregserver;
    procedure Terminate;

    function GetInited: Boolean;
    function GetMode: TBisCoreMode;
    function GetAction: TBisCoreAction;
    procedure SnapshotModules;
    procedure InfoToLog;
    function CheckCryptHash: Boolean;
    function Exists: Boolean;
    procedure ApplicationException(Sender: TObject; E: Exception);
    procedure ApplicationMessage(var Msg: TMsg; var Handled: Boolean);
    function GetConnection: TBisConnection;
    function GetLogged: Boolean;
    function GetSessionId: String;
    function GetAccountId: String;
    function GetAccountUserName: String;
    function GetConfigFile: String;
    procedure SetConfigFile(Value: String);

    procedure LoadModules;
    procedure UnLoadModules;

    procedure RunDefault;
    procedure RunInstall;
    procedure RunUninstall;
    procedure RunCommand;
    procedure RunShow;
    procedure RunHelp;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Done; reintroduce;

    function Translate(S: String): String;
    procedure RefreshPermissions;
    procedure ReloadInterfaces;
    procedure RefreshContents;
    procedure Progress(const Min, Max, Position: Integer; var Breaked: Boolean);
    procedure Progress2(const Min, Max, Position: Integer; var Breaked: Boolean);

    function FindIface(ObjectName: String): TBisIface;
    function GetIface(ObjectName: String): TBisIface;
    function FindIfaceClass(ClassName: String): TBisIfaceClass;
    function GetIfaceClass(ClassName: String): TBisIfaceClass;
    function FindInterface(ObjectName: String): TBisInterface;
    function GetInterface(ObjectName: String): TBisInterface;

    function DataSelectInto(DataName: String; Provider: TBisProvider;
                            LocateFields: String; LocateValues: Variant;
                            MultiSelect: Boolean=false; Mode: TBisCoreDataSelectIntoMode=imInterface;
                            NewInstance: Boolean=true): Boolean;

    procedure ConnectionCheck;
    procedure ConnectionGetRecords(DataSet: TBisDataSet);
    procedure ConnectionExecute(DataSet: TBisDataSet);
    procedure ConnectionLoadMenus(Menus: TBisMenus);
    procedure ConnectionLoadScript(ScriptId: String; Stream: TStream);
    procedure ConnectionLoadReport(ReportId: String; Stream: TStream);
    procedure ConnectionLoadDocument(DocumentId: String; Stream: TStream);
    function ConnectionGetServerDate: TDateTime;


    property Mode: TBisCoreMode read GetMode;
    property Action: TBisCoreAction read GetAction;

    property Tasks: TBisTasks read FTasks;  
    property ExceptNotifier: TBisExceptNotifier read FExceptNotifier;
    property CmdLine: TBisCmdLine read FCmdLine;
    property Config: TBisConfig read FConfig;
    property Logger: TBisLogger read FLogger;
    property LocalBase: TBisLocalBase read FLocalBase;
    property Audit: TBisAudit read FAudit;

    property ObjectModules: TBisObjectModules read FObjectModules;
    property ScriptModules: TBisScriptModules read FScriptModules;
    property ReportModules: TBisReportModules read FReportModules;
    property MapModules: TBisMapModules read FMapModules;
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
    property ProgressEvents2: TBisProgressEvents read FProgressEvents2;
    property AfterLoginEvents: TBisNotifyEvents read FAfterLoginEvents;
    property BeforeLogoutEvents: TBisNotifyEvents read FBeforeLogoutEvents;

    property SessionId: String read GetSessionId;
    property Connection: TBisConnection read GetConnection;
    property Logged: Boolean read GetLogged;
    property AccountId: String read GetAccountId;
    property AccountUserName: String read GetAccountUserName;
    property ServerDate: TDateTime read ConnectionGetServerDate;

    property CheckPermissions: Boolean read FCheckPermissions;
    property EditIfaceAsModal: Boolean read FEditIfaceAsModal;
    property IfaceOnlyOneForm: Boolean read FIfaceOnlyOneForm;
    property TranslateToLog: Boolean read FTranslateToLog;
    property NoLogin: Boolean read FNoLogin;

  published

    property SStartModuleInfo: String read FSStartModuleInfo write FSStartModuleInfo;
    property SBeginSnapshot: String read FSBeginSnapshot write FSBeginSnapshot;
    property SEndSnapshot: String read FSEndSnapshot write FSEndSnapshot;
    property SIfaceNotFound: String read FSIfaceNotFound write FSIfaceNotFound;
    property SIfaceClassNotFound: String read FSIfaceClassNotFound write FSIfaceClassNotFound;
    property SInterfaceNotFound: String read FSInterfaceNotFound write FSInterfaceNotFound;
    property SNotConnected: String read FSNotConnected write FSNotConnected; 

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

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;  

exports
  InitIfaceModule;

implementation

uses TypInfo, StrUtils, Variants, Forms, Graphics, SvcMgr, DB,
     BisCryptUtils, BisCoreUtils, BisConsts, BisModuleInfo, BisCrypter,
     BisStandaloneApplication, BisServiceApplication, BisExceptions,
     BisDialogs, BisUtils, BisHintEx, BisExecuteIface, BisCoreThreads,
     BisConnectionEditFm, BisMemoFm;


procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  with AModule.Ifaces do begin
    AddClass(TBisSplashFormIface);
    AddClass(TBisAboutFormIface);
  end;
end;

{ TBisCore }

constructor TBisCore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Core:=Self;
  FOldHintWindowClass:=HintWindowClass;
  HintWindowClass:=TBisHintWindowEx;

  GetCryptInfo(CryptInfo);

//  Forms.Application.OnException:=ApplicationException;
  Forms.Application.OnMessage:=ApplicationMessage;

  FTasks:=TBisTasks.Create(Self);

  FContentEvents:=TBisNotifyEvents.Create;
  FProgressEvents:=TBisProgressEvents.Create;
  FProgressEvents2:=TBisProgressEvents.Create;
  FAfterLoginEvents:=TBisNotifyEvents.Create;
  FBeforeLogoutEvents:=TBisNotifyEvents.Create;

  FCmdLine:=TBisCmdLine.Create(Self);

  FConfig:=TBisConfig.Create(Self);
  FConfig.CmdLine:=FCmdLine;

  FLogger:=TBisLogger.Create(Self);
  FLogger.CmdLine:=FCmdLine;
  FLogger.Config:=FConfig;

  FExceptNotifier:=TBisExceptNotifier.Create(Self);
  FExceptNotifier.Logger:=FLogger;

  FLocalbase:=TBisLocalBase.Create(Self);
  FLocalbase.CmdLine:=FCmdLine;
  FLocalbase.Config:=FConfig;
  FLocalbase.Logger:=FLogger;
  FLocalBase.CrypterKey:=DefaultKey;
  FLocalBase.CrypterAlgorithm:=DefaultCipherAlgorithm;
  FLocalBase.CrypterMode:=DefaultCipherMode;

  FAudit:=TBisAudit.Create(Self);
  FAudit.Localbase:=FLocalbase;

  FLanguage:=TBisLanguage.Create(Self);
  FLanguage.LocalBase:=FLocalbase;

  FObjectModules:=TBisObjectModules.Create(Self);
  FScriptModules:=TBisScriptModules.Create(Self);
  FReportModules:=TBisReportModules.Create(Self);
  FMapModules:=TBisMapModules.Create(Self);
  FConnectionModules:=TBisConnectionModules.Create(Self);
  FProviderModules:=TBisProviderModules.Create(Self);
  FServerModules:=TBisServerModules.Create(Self);
  FIfaceModules:=TBisIfaceModules.Create(Self);

  FSplashIface:=TBisSplashFormIface.Create(Self);
  FAboutIface:=TBisAboutFormIface.Create(Self);
  FLoginIface:=TBisLoginFormIface.Create(Self);

  FIfaces:=TBisIfaces.Create(Self);
  FIfaces.AddClass(TBisConnectionEditFormIface);
  FIfaces.AddClass(TBisAboutFormIface);
  FIfaces.AddClass(TBisExecuteIface);

  FInterfaces:=TBisInterfaces.Create(Self);

  FProfile:=TBisProfile.Create(Self);

  FSStartDelim:='-';
  FSStartDir:='Папка=%s';
  FSStartCmd:='Командная строка=%s';
  FSStartMode:='Режим=%s';
  FSStartAction:='Действие=%s';
  FSStartModuleInfo:='Модуль=%s Версия=%s Размер=%d Хеш=%s';
  FSStartConfigFileName:='Конфигурационный файл=%s';
  FSStartLoggerFileName:='Файл логгирования=%s';
  FSStartConfigText:='Текст конфигурационного файла=%s';
  FSBeginSnapshot:='Начало снятия дампа модулей ...';
  FSEndSnapshot:='Окончание снятия дампа модулей.';
  FSIfaceNotFound:='Интерфейс %s не найден.';
  FSIfaceClassNotFound:='Интерфейсный класс %s не найден.';
  FSInterfaceNotFound:='Интерфейс %s не найден.';
  FSConfigNotFound:='Config file %s not found.';
  FSNotConnected:='Нет соединения.';

  FSCmdParamConfigDesc:='подключение файла настроек: /config test.ini';
  FSCmdParamBaseDesc:='подключение файла параметров: /base test.bis';
  FSCmdParamLogDesc:='подключение файла журнала: /log test.log';
  FSCmdParamHelpDesc:='помощь по командной строке: /help';
  FSCmdParamInstallDesc:='установка службы: /install /service';
  FSCmdParamUninstallDesc:='удаление службы: /uninstall /service';
  FSCmdParamServiceDesc:='запуск службы: /service';
  FSCmdParamCommandDesc:='выполнение других команд: /command test';
  FSCmdParamShowDesc:='запуск интерфейсов: /show test.txt или /show test';
  FSCmdParamNoLoginDesc:='без соединения: /nologin';
//  FSCmdParamShowModalDesc:='запуск интерфейсов модально: /config test.ini /showmodal test.txt';

end;

destructor TBisCore.Destroy;
begin
  HintWindowClass:=FOldHintWindowClass;
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
  FMapModules.Free;
  FReportModules.Free;
  FScriptModules.Free;
  FObjectModules.Free;

  FLanguage.Free;
  FAudit.Free;
  FLocalbase.Free;
  FExceptNotifier.Free;
  FLogger.Free;
  FConfig.Free;
  FCmdLine.Free;
  FAfterLoginEvents.Free;
  FBeforeLogoutEvents.Free;
  FProgressEvents2.Free;
  FProgressEvents.Free;
  FContentEvents.Free;
  FTasks.Free;
  Core:=nil;
  inherited Destroy;
end;

procedure TBisCore.Init;
var
  Buffer: String;
  Flag: Boolean;
begin
  inherited Init;

  FTasks.Init;
  FCmdLine.Init;

  FNoLogin:=FCmdLine.ParamExists(SCmdParamNoLogin);

  FConfig.Init;
  if not FileExists(FConfig.FileName) then begin
    ShowError(FormatEx(FSConfigNotFound,[FConfig.FileName]));
    Inited:=false;
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

  FLogger.Init;
  FLogger.Load;
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
  FMapModules.Init;
  FConnectionModules.Init;
  FProviderModules.Init;
  FServerModules.Init;
  FIfaceModules.Init;

  FIfaces.Init;
  FInterfaces.Init;
  FProfile.Init;

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
  FMapModules.Done;
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
  FLogger.Save;
  FLogger.Done;
  FConfig.Done;
  FCmdLine.Done;
  FTasks.Done;
end;

function TBisCore.GetInited: Boolean;
begin
  Result:=Inited;
end;

function TBisCore.GetMode: TBisCoreMode;
begin
  Result:=smStandalone;
  if FCmdLine.ParamExists(SCmdParamService) then begin
    Result:=smService;
    exit;
  end;
end;

function TBisCore.GetAction: TBisCoreAction;
begin
  Result:=saDefault;
  if FCmdLine.ParamExists(SCmdParamHelp) then begin
    Result:=saHelp;
    exit;
  end;
  if FCmdLine.ParamExists(SCmdParamInstall) then begin
    Result:=saInstall;
    exit;
  end;
  if FCmdLine.ParamExists(SCmdParamUninstall) then begin
    Result:=saUninstall;
    exit;
  end;
  if FCmdLine.ParamExists(SCmdParamCommand) then begin
    Result:=saCommand;
    exit;
  end;
  if FCmdLine.ParamExists(SCmdParamShow) then begin
    Result:=saShow;
    exit;
  end;
{  if FCmdLine.ParamExists(SCmdParamShowModal) then begin
    Result:=saShowModal;
    exit;
  end;}
end;

function TBisCore.GetConfigFile: String;
begin
  Result:=FConfig.FileName;
end;

procedure TBisCore.SetConfigFile(Value: String);
begin
  FConfig.FileName:=Value;
end;

function TBisCore.GetSessionId: String;
begin
  Result:=FLoginIface.Session;
end;

function TBisCore.GetAccountId: String;
begin
  Result:=FLoginIface.AccountId;
end;

function TBisCore.GetAccountUserName: String;
begin
  Result:=FLoginIface.AccountUserName;
end;

function TBisCore.GetLogged: Boolean;
begin
  Result:=FLoginIface.Logged;
end;

function TBisCore.GetConnection: TBisConnection;
begin
  Result:=FLoginIface.Connection;
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
          Write(FormatEx(FSStartModuleInfo,[S,MI.FileVersion,MI.FileSize,MI.FileHash]),ltInformation,Self.ObjectName);
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

procedure TBisCore.LoadModules;
begin
  FObjectModules.Load;
  FScriptModules.Load;
  FReportModules.Load;
  FMapModules.Load;
  FConnectionModules.Load;
  FProviderModules.Load;
  FServerModules.Load;
  FIfaceModules.Load;
end;

procedure TBisCore.UnLoadModules;
begin
  FIfaceModules.Unload;
  FServerModules.Unload;
  FProviderModules.Unload;
  FConnectionModules.Unload;
  FMapModules.Unload;
  FReportModules.Unload;
  FScriptModules.Unload;
  FObjectModules.Unload;
end;

procedure TBisCore.RunDefault;
var
  FlagNext: Boolean;
begin
  FApplication.Init;
  FSplashIface.Show;
  LoadModules;
  try
    SnapshotModules;
    FlagNext:=true;
    if FLoginIface.Enabled and not FNoLogin then
      FlagNext:=FLoginIface.Login;
    if FlagNext then begin
      FInterfaces.InitIfaces;
      FSplashIface.BringToFront;
      FServerModules.StartServers;
      FApplication.FreeTemp;
      FIfaces.Show;
      FIfaceModules.ShowIfaces;
      FInterfaces.ShowIfaces;
      try
        SnapshotModules;
        FSplashIface.Hide;
        FAudit.Start;
        FTasks.Start;
        FApplication.Run;
      finally
        FTasks.Stop;
        FAudit.Stop;
        FServerModules.StopServers;
        FInterfaces.HideIfaces;
        FIfaceModules.HideIfaces;
        FIfaces.Hide;
        FInterfaces.DoneIfaces;
        FLoginIface.Logout;
      end;
    end;
  finally
    UnLoadModules;
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

  procedure ShowIfaces;
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
              ModuleName:=Table.FieldByName(SFieldModule).AsString;
              IfaceName:=Table.FieldByName(SFieldIface).AsString;
              if (Trim(ModuleName)='') or AnsiSameText(ModuleName,Self.ObjectName) then begin
                Iface:=TBisIface(FIfaces.Find(IfaceName));
                if Assigned(Iface) then
                  Iface.ShowByCommand(Command);
              end else begin
                ModuleName:=ModuleName+TBisIfaceModule.GetObjectName;
                Module:=TBisIfaceModule(FIfaceModules.Find(ModuleName));
                if Assigned(Module) then begin
                  Iface:=TBisIface(Module.Ifaces.Find(IfaceName));
                  if Assigned(Iface) then
                    Iface.ShowByCommand(Command);
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
  LoadModules;
  try
    FlagNext:=true;
    if FLoginIface.Enabled and not FNoLogin then
      FlagNext:=FLoginIface.Login;
    if FlagNext then begin
      FApplication.FreeTemp;
      try
        SnapshotModules;
        ShowIfaces;
      finally
        FLoginIface.Logout;
      end;
    end;
  finally
    UnLoadModules;
  end;
end;

procedure TBisCore.RunShow;

  procedure ShowInterfaces;
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
        if Assigned(AInterface) then
          AInterface.ShowIfaceAsMainForm(i=0);
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
  LoadModules;
  try
    FlagNext:=true;
    if FLoginIface.Enabled and not FNoLogin then
      FlagNext:=FLoginIface.Login;
    if FlagNext then begin
      FInterfaces.InitIfaces;
      FSplashIface.BringToFront;
      FServerModules.StartServers;
      FApplication.FreeTemp;
      try
        SnapshotModules;
        FSplashIface.Hide;
        FAudit.Start;
        FTasks.Start;
        ShowInterfaces;
        FApplication.Run;
      finally
        FTasks.Stop;
        FAudit.Stop;
        FServerModules.StopServers;
        FInterfaces.DoneIfaces;
        FLoginIface.Logout;
      end;
    end;
  finally
    UnLoadModules;
  end;
end;

procedure TBisCore.RunHelp;
var
  List: TStringList;
const
  FormatCommand='/%s - %s';

  procedure GetInternalCommands;
  begin
    List.Add(Format(FormatCommand,[SCmdParamConfig,FSCmdParamConfigDesc]));
    List.Add(Format(FormatCommand,[SCmdParamLog,FSCmdParamLogDesc]));
    List.Add(Format(FormatCommand,[SCmdParamBase,FSCmdParamBaseDesc]));
    List.Add(Format(FormatCommand,[SCmdParamHelp,FSCmdParamHelpDesc]));
    List.Add(Format(FormatCommand,[SCmdParamService,FSCmdParamServiceDesc]));
    List.Add(Format(FormatCommand,[SCmdParamInstall,FSCmdParamInstallDesc]));
    List.Add(Format(FormatCommand,[SCmdParamUninstall,FSCmdParamUninstallDesc]));
    List.Add(Format(FormatCommand,[SCmdParamShow,FSCmdParamShowDesc]));
    List.Add(Format(FormatCommand,[SCmdParamNoLogin,FSCmdParamNoLoginDesc]));
  end;

  procedure GetExternalCommands;
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
    GetInternalCommands;
    GetExternalCommands;
    S:=Trim(List.Text);
    if S<>'' then begin
      ShowInfo(S);
    end;
  finally
    List.Free;
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
      try
        SnapshotModules;
        FAudit.Application:=FApplication;
        case Mode of
          smStandalone, smService: begin
            case Action of
              saDefault,saCommand,saShow: begin
                FlagNext:=FLocalbase.BaseLoaded and CheckCryptHash;
                if FlagNext then begin
                  case Action of
                    saDefault: RunDefault;
                    saCommand: RunCommand;
                    saShow: RunShow;
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
        FAudit.Application:=nil;
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
  if Logged then begin
    Connection.LoadInterfaces(SessionId,FInterfaces);
    FInterfaces.InitIfaces;
  end;
end;

procedure TBisCore.RefreshPermissions;
begin
  if Logged then begin
    Connection.RefreshPermissions(SessionId);
  end;
end;

procedure TBisCore.RefreshContents;
begin
  FContentEvents.Call;
end;

procedure TBisCore.Progress(const Min, Max, Position: Integer; var Breaked: Boolean);
begin
  FProgressEvents.Progress(Min,Max,Position,Breaked);
end;

procedure TBisCore.Progress2(const Min, Max, Position: Integer; var Breaked: Boolean);
begin
  FProgressEvents2.Progress(Min,Max,Position,Breaked);
end;

procedure TBisCore.ApplicationException(Sender: TObject; E: Exception);
begin
 { if E is EBisException then begin
    with EBisException(E) do begin
      ShowDetailError(Format('BIS-%s: %s',[FormatFloat('#0000',ErrorCode),Message]),HelpContext);
    end;
  end else }
    ShowError(E.Message);
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
      for j:=0 to Module.Ifaces.Count-1 do begin
        Iface:=Module.Ifaces.Items[j];
        if AnsiSameText(Iface.ObjectName,ObjectName) then begin
          Result:=Iface;
          exit;
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
      for j:=0 to Module.Ifaces.Count-1 do begin
        Iface:=Module.Ifaces.Items[j];
        S:=Iface.ClassName;
        if AnsiSameText(S,ClassName) then begin
          Result:=TBisIfaceClass(Iface.ClassType);
          exit;
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

function TBisCore.DataSelectInto(DataName: String; Provider: TBisProvider;
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
        DataIface.FilterGroups.CopyFrom(Provider.FilterGroups,false);
        DataIface.LocateFields:=LocateFields;
        DataIface.LocateValues:=LocateValues;
        DataIface.MultiSelect:=MultiSelect;
        Result:=DataIface.SelectInto(Provider);
      finally
        if NewInstance then
          DataIface.Free;
      end;
    end;
  end;
end;

procedure TBisCore.ConnectionCheck;
{var
  Flag: Boolean;}
begin
  CoreThreadCheck;
{  if FLoginIface.Enabled and not FNoLogin then begin
    if FLoginIface.Logged then begin

      try
        Flag:=not FLoginIface.Connection.Check(FLoginIface.Session);
      except
        On E: Exception do begin
          FLogger.Write(E.Message);
          Flag:=true;
        end;
      end;

      if Flag then
        FLoginIface.Logout;

    end else
      Flag:=true;

    if Flag and not FLoginIface.InLogin then begin

      if not FLoginIface.Login then
        raise Exception.Create(FSNotConnected);
    end;

  end;}
end;

function TBisCore.ConnectionGetServerDate: TDateTime;
begin
  Result:=CoreThreadGetServerDate;
{  Result:=Now;
  if Assigned(FLoginIface.Connection) then begin
    ConnectionCheck;
    if Logged then
      Result:=FLoginIface.Connection.GetServerDate;
  end;}
end;

procedure TBisCore.ConnectionLoadMenus(Menus: TBisMenus);
begin
  CoreThreadLoadMenus(Menus);
{  ConnectionCheck;
  if Logged then
    Connection.LoadMenus(SessionId,Menus);}
end;

procedure TBisCore.ConnectionLoadDocument(DocumentId: String; Stream: TStream);
begin
  CoreThreadLoadDocument(DocumentId,Stream);
{  ConnectionCheck;
  if Logged then
    Connection.LoadDocument(SessionId,DocumentId,Stream);}
end;

procedure TBisCore.ConnectionLoadReport(ReportId: String; Stream: TStream);
begin
  CoreThreadLoadReport(ReportId,Stream);
{  ConnectionCheck;
  if Logged then
    Connection.LoadReport(SessionId,ReportId,Stream);}
end;

procedure TBisCore.ConnectionLoadScript(ScriptId: String; Stream: TStream);
begin
  CoreThreadLoadScript(ScriptId,Stream);
{  ConnectionCheck;
  if Logged then
    Connection.LoadScript(SessionId,ScriptId,Stream);}
end;

procedure TBisCore.ConnectionExecute(DataSet: TBisDataSet);
{var
  Provider: TBisProvider;}
begin
  CoreThreadExecute(DataSet);
{  Provider:=nil;
  if Assigned(DataSet) then
    Provider:=FProviderModules.FindProvider(DataSet.ProviderName);

  if not Assigned(Provider) then begin
    ConnectionCheck;
    if Logged then
      Connection.Execute(SessionId,DataSet);
  end else
    Provider.Handle(DataSet);}
end;

procedure TBisCore.ConnectionGetRecords(DataSet: TBisDataSet);
{var
  Provider: TBisProvider;}
begin
  CoreThreadGetRecords(DataSet);
{  Provider:=nil;
  if Assigned(DataSet) then
    Provider:=FProviderModules.FindProvider(DataSet.ProviderName);

  if not Assigned(Provider) then begin
    ConnectionCheck;
    if Logged then
      Connection.GetRecords(SessionId,DataSet);
  end else
    Provider.Handle(DataSet);  }
end;

initialization
  RegisterClass(TBisCore);

end.
