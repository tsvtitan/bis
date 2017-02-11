﻿unit BisSystemUtils;

interface

uses Windows, Classes, Contnrs;

type
  TBisSystemServiceType=(stUnknown,stKernelDriver,stFileSystemDriver,stAdapter,stRecognizerDriver,stDriver,
                         stWin32OwnProcess,stWin32ShareProcess,stInteractiveProcess,stTypeAll);

  TBisSystemServiceState=(ssUnknown,ssStopped,ssStartPending,ssStopPending,ssRunning,
                          ssContinuePending,ssPausePending,ssPaused);

  TBisSystemService=class(TObject)
  private
    FName: String;
    FProcessID: Cardinal;
    FDisplayName: String;
    FServiceType: TBisSystemServiceType;
    FServiceState: TBisSystemServiceState;
    FFileName: String;
    FCommandLine: String;
  public
    property Name: String read FName write FName;
    property ProcessID: Cardinal read FProcessID write FProcessID;
    property DisplayName: String read FDisplayName write FDisplayName;
    property ServiceType: TBisSystemServiceType read FServiceType write FServiceType;
    property ServiceState: TBisSystemServiceState read FServiceState write FServiceState;
    property FileName: String read FFileName write FFileName;
    property CommandLine: String read FCommandLine write FCommandLine; 
  end;

  TBisSystemServices=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisSystemService;
  public
    constructor Create;
    procedure Refresh;
    function Find(const ServiceName: String): TBisSystemService;
    procedure GetServices(const ProcessID: Cardinal; Services: TBisSystemServices); overload;
    procedure GetServices(const FileName: String; Services: TBisSystemServices); overload;

    property Items[Index: Integer]: TBisSystemService read GetItem; default;
  end;

  TBisSystemProcess=class(TObject)
  private
    FFileName: String;
    FProcessID: Cardinal;
    FCreateTime: TDateTime;
    FUserName: String;
    FDomainName: String;
    FName: String;
    FCommandLine: String;
  public
    constructor Create;
    destructor Destroy; override;

    property Name: String read FName write FName;
    property FileName: String read FFileName write FFileName;
    property CommandLine: String read FCommandLine write FCommandLine;
    property ProcessID: Cardinal read FProcessID write FProcessID;
    property CreateTime: TDateTime read FCreateTime write FCreateTime;
    property UserName: String read FUserName write FUserName;
    property DomainName: String read FDomainName write FDomainName;
  end;

  TBisSystemProcesses=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisSystemProcess;
  public
    constructor Create;
    procedure Refresh;
    function Find(const ProcessID: Cardinal): TBisSystemProcess;
    procedure GetProcesses(const FileName: String; Processes: TBisSystemProcesses);

    property Items[Index: Integer]: TBisSystemProcess read GetItem; default;
  end;

function EnablePrivilege(const Privilege: string): Boolean;
function ShutDown(const Message: String; TimeOut: Integer; Forced: Boolean; Reboot: Boolean): Boolean;
function ProcessExists(const ProcessID: Cardinal): Boolean;
function ProcessStart(const FileName, CommandLine: String; var ProcessID: Cardinal): Boolean;
function ProcessStop(const ProcessID, Timeout: Cardinal): Boolean;
function ServiceStart(const ServiceName: String; const Timeout: Cardinal): Boolean;
function ServiceStop(const ServiceName: String; const Timeout: Cardinal): Boolean;

const
  SSeShutdownPrivilege='SeShutdownPrivilege';
  SSeDebugPrivilege='SeDebugPrivilege';

implementation

uses Messages, SysUtils, WinSvc, Psapi,
     BisUtils, BisConsts;

const
  SystemBasicInformation = 0;
  SystemPerformanceInformation = 2;
  SystemTimeOfDayInformation = 3;
  SystemProcessesAndThreadsInformation = 5;

  STATUS_INFO_LENGTH_MISMATCH = $C0000004;

type

  SYSTEM_BASIC_INFORMATION = packed record
    AlwaysZero              : ULONG;
    uKeMaximumIncrement     : ULONG;
    uPageSize               : ULONG;
    uMmNumberOfPhysicalPages: ULONG;
    uMmLowestPhysicalPage   : ULONG;
    uMmHighestPhysicalPage  : ULONG;
    uAllocationGranularity  : ULONG;
    pLowestUserAddress      : POINTER;
    pMmHighestUserAddress   : POINTER;
    uKeActiveProcessors     : POINTER;
    bKeNumberProcessors     : BYTE;
    Filler                  : array [0..2] of BYTE;
  end;
  PSYSTEM_BASIC_INFORMATION = ^SYSTEM_BASIC_INFORMATION;

  SYSTEM_PERFORMANCE_INFORMATION = packed record
    nIdleTime               : INT64;
    dwSpare                 : array [0..75]of DWORD;
  end;
  PSYSTEM_PERFORMANCE_INFORMATION = ^SYSTEM_PERFORMANCE_INFORMATION;

  SYSTEM_TIME_INFORMATION = packed record
    nKeBootTime             : INT64;
    nKeSystemTime           : INT64;
    nExpTimeZoneBias        : INT64;
    uCurrentTimeZoneId      : ULONG;
    dwReserved              : DWORD;
  end;
  PSYSTEM_TIME_INFORMATION = ^SYSTEM_TIME_INFORMATION;

  SYSTEM_THREADS  = packed record
    KernelTime: LARGE_INTEGER;
    UserTime: LARGE_INTEGER;
    CreateTime: LARGE_INTEGER;
    WaitTime: ULONG;
    StartAddress: Pointer;
    UniqueProcess: DWORD;
    UniqueThread: DWORD;
    Priority: Integer;
    BasePriority: Integer;
    ContextSwitchCount: ULONG;
    State: Longint;
    WaitReason: Longint;
  end;
  PSYSTEM_THREADS = ^SYSTEM_THREADS;

  SYSTEM_PROCESS_INFORMATION = packed record
    NextOffset: ULONG;
    ThreadCount: ULONG;
    Reserved1: array [0..5] of ULONG;
    CreateTime: FILETIME;
    UserTime: FILETIME;
    KernelTime: FILETIME;
    ModuleNameLength: WORD;
    ModuleNameMaxLength: WORD;
    ModuleName: PWideChar;
    BasePriority: ULONG;
    ProcessID: ULONG;
    InheritedFromUniqueProcessID: ULONG;
    HandleCount: ULONG;
    Reserved2 : array[0..1] of ULONG;
    PeakVirtualSize : ULONG;
    VirtualSize : ULONG;
    PageFaultCount : ULONG;
    PeakWorkingSetSize : ULONG;
    WorkingSetSize : ULONG;
    QuotaPeakPagedPoolUsage : ULONG;
    QuotaPagedPoolUsage : ULONG;
    QuotaPeakNonPagedPoolUsage : ULONG;
    QuotaNonPagedPoolUsage : ULONG;
    PageFileUsage : ULONG;
    PeakPageFileUsage : ULONG;
    PrivatePageCount : ULONG;
    ReadOperationCount : LARGE_INTEGER;
    WriteOperationCount : LARGE_INTEGER;
    OtherOperationCount : LARGE_INTEGER;
    ReadTransferCount : LARGE_INTEGER;
    WriteTransferCount : LARGE_INTEGER;
    OtherTransferCount : LARGE_INTEGER;
    ThreadInfo: array [0..0] of SYSTEM_THREADS;
  end;
  PSYSTEM_PROCESS_INFORMATION = ^SYSTEM_PROCESS_INFORMATION;


  _UNICODE_STRING = record
    Length: Word;
    MaximumLength: Word;
    Buffer: LPWSTR;
  end;
  UNICODE_STRING = _UNICODE_STRING;

  PROCESS_BASIC_INFORMATION = packed record
    ExitStatus: DWORD;
    PebBaseAddress: Pointer;
    AffinityMask: DWORD;
    BasePriority: DWORD;
    UniqueProcessId: DWORD;
    InheritedUniquePID:DWORD;
  end;

const
  NtDll='ntdll.dll';
  Advapi32='advapi32.dll';

var
  NtDllHandle: THandle=0;
  NtDllLoaded: Boolean=false;
  _NtQuerySystemInformation: function(SystemInformationClass: DWORD;  SystemInformation: Pointer;
                                      SystemInformationLength: DWORD; var ReturnLength: DWORD): DWORD; stdcall;
  _NtQueryInformationProcess: function(ProcessHandle: THandle; ProcessInformationClass: DWORD; ProcessInformation: Pointer;
                                       ProcessInformationLength: DWORD; var ReturnLength: DWORD): DWORD; stdcall;

function InitNtDll: Boolean;
begin
  Result:=False;
  if NtDllHandle=0 then NtDllHandle:=LoadLibrary(NtDll);
  if NtDllHandle>HINSTANCE_ERROR then begin
    _NtQuerySystemInformation:=GetProcAddress(NtDllHandle,'NtQuerySystemInformation');
    _NtQueryInformationProcess:=GetProcAddress(NtDllHandle,'NtQueryInformationProcess');
    Result:=Assigned(_NtQuerySystemInformation) and
            Assigned(_NtQueryInformationProcess);
  end;
end;

procedure DoneNtDll;
begin
  if NtDllHandle<>0 then
    FreeLibrary(NtDllHandle);
  NtDllHandle:=0;
end;

type
  _SC_ENUM_TYPE = (SC_ENUM_PROCESS_INFO);
  SC_ENUM_TYPE = _SC_ENUM_TYPE;

  LPBYTE = PBYTE;

  _SERVICE_STATUS_PROCESS = record
    dwServiceType: DWORD;
    dwCurrentState: DWORD;
    dwControlsAccepted: DWORD;
    dwWin32ExitCode: DWORD;
    dwServiceSpecificExitCode: DWORD;
    dwCheckPoint: DWORD;
    dwWaitHint: DWORD;
    dwProcessId: DWORD;
    dwServiceFlags: DWORD;
  end;
  SERVICE_STATUS_PROCESS = _SERVICE_STATUS_PROCESS;

  _ENUM_SERVICE_STATUS_PROCESS = record
    lpServiceName: LPSTR;
    lpDisplayName: LPSTR;
    ServiceStatusProcess: SERVICE_STATUS_PROCESS;
  end;
  ENUM_SERVICE_STATUS_PROCESS = _ENUM_SERVICE_STATUS_PROCESS;
  LPENUM_SERVICE_STATUS_PROCESS = ^ENUM_SERVICE_STATUS_PROCESS;

var
  Advapi32Handle: THandle=0;
  Advapi32Loaded: Boolean=false;
  _OpenSCManager: function (lpMachineName: LPCTSTR; lpDatabaseName: LPCTSTR; dwDesiredAccess: DWORD): SC_HANDLE; stdcall;
  _OpenService: function (hSCManager: SC_HANDLE; lpServiceName: PChar; dwDesiredAccess: DWORD): SC_HANDLE; stdcall;
  _StartService: function (hService: SC_HANDLE; dwNumServiceArgs: DWORD; lpServiceArgVectors: PChar): BOOL; stdcall;
  _ControlService: function (hService: SC_HANDLE; dwControl: DWORD; var lpServiceStatus: TServiceStatus): BOOL; stdcall;
  _QueryServiceConfig: function (hService: SC_HANDLE; lpServiceConfig: PQueryServiceConfig;
                                 cbBufSize: DWORD; var pcbBytesNeeded: DWORD): BOOL; stdcall;
  _QueryServiceStatus: function (hService: SC_HANDLE; var lpServiceStatus: TServiceStatus): BOOL; stdcall;
  _CloseServiceHandle: function (hSCObject: SC_HANDLE): BOOL; stdcall;
  _EnumServicesStatusEx: function (hSCManager: SC_HANDLE; InfoLevel: SC_ENUM_TYPE;
                                  dwServiceType: DWORD; dwServiceState: DWORD; lpServices: LPBYTE;
                                  cbBufSize: DWORD; var pcbBytesNeeded, lpServicesReturned, lpResumeHandle: DWORD;
                                  pszGroupName: LPCTSTR): BOOL; stdcall;
function InitAdvapi32: Boolean;
begin
  Result:=False;
  if Advapi32Handle=0 then Advapi32Handle:=LoadLibrary(Advapi32);
  if Advapi32Handle>HINSTANCE_ERROR then begin
    _OpenSCManager:=GetProcAddress(Advapi32Handle,'OpenSCManagerA');
    _OpenService:=GetProcAddress(Advapi32Handle,'OpenServiceA');
    _StartService:=GetProcAddress(Advapi32Handle,'StartServiceA');
    _ControlService:=GetProcAddress(Advapi32Handle,'ControlService');
    _QueryServiceStatus:=GetProcAddress(Advapi32Handle,'QueryServiceStatus');
    _QueryServiceConfig:=GetProcAddress(Advapi32Handle,'QueryServiceConfigA');
    _CloseServiceHandle:=GetProcAddress(Advapi32Handle,'CloseServiceHandle');
    _EnumServicesStatusEx:=GetProcAddress(Advapi32Handle,'EnumServicesStatusExA');
    Result:=Assigned(_OpenSCManager) and
            Assigned(_OpenService) and
            Assigned(_StartService) and
            Assigned(_ControlService) and
            Assigned(_CloseServiceHandle) and
            Assigned(_QueryServiceStatus) and
            Assigned(_QueryServiceConfig) and
            Assigned(_EnumServicesStatusEx);
  end;
end;

procedure DoneAdvapi32;
begin
  if Advapi32Handle<>0 then
    FreeLibrary(Advapi32Handle);
  Advapi32Handle:=0;
end;

function EnablePrivilege(const Privilege: string): Boolean;
var
  TokenHandle: THandle;
  TokenPrivileges: TTokenPrivileges;
  ReturnLength: Cardinal;
begin
  Result:= False;
  if OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, TokenHandle) then begin
    try
      LookupPrivilegeValue(nil, PAnsiChar(Privilege), TokenPrivileges.Privileges[0].Luid);
      TokenPrivileges.PrivilegeCount:= 1;
      TokenPrivileges.Privileges[0].Attributes:= SE_PRIVILEGE_ENABLED;
      if AdjustTokenPrivileges(TokenHandle, False, TokenPrivileges, 0, nil, ReturnLength) then
        Result:= True;
    finally
      CloseHandle(TokenHandle);
    end;
  end;
end;

function ShutDown(const Message: String; TimeOut: Integer; Forced: Boolean; Reboot: Boolean): Boolean;
var
  Flags: UINT;
const
  SHTDN_REASON_MAJOR_APPLICATION=$00040000;  
begin
  EnablePrivilege(SSeShutdownPrivilege);
  if (Trim(Message)='') or (TimeOut>0) then begin
    Result:=InitiateSystemShutdown(nil,PChar(Message),TimeOut,Forced,Reboot);
  end else begin
    Flags:=EWX_SHUTDOWN;
    if Reboot then
      Flags:=EWX_REBOOT;
    if Forced then
      Flags:=Flags or EWX_FORCEIFHUNG;
    Result:=ExitWindowsEx(Flags,SHTDN_REASON_MAJOR_APPLICATION);
  end;
end;

function ProcessExists(const ProcessID: Cardinal): Boolean;
var
  ProcessHandle: Cardinal;
begin
  Result:=false;
  ProcessHandle:=OpenProcess(PROCESS_QUERY_INFORMATION,false,ProcessID);
  if ProcessHandle>0 then begin
    try
      Result:=true;
    finally
      CloseHandle(ProcessHandle);
    end;
  end;
end;

function ProcessStart(const FileName, CommandLine: String; var ProcessID: Cardinal): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  StartCommandLine: String;
begin
  FillChar(StartupInfo,SizeOf(TStartupInfo),0);
  with StartupInfo do begin
    cb:=SizeOf(TStartupInfo);
    wShowWindow:=SW_SHOWDEFAULT;
  end;
  StartCommandLine:=FileName;
  if Trim(CommandLine)<>'' then
    StartCommandLine:=StartCommandLine+' '+CommandLine;
  Result:=CreateProcess(nil,PChar(StartCommandLine),nil,nil,False,
                        NORMAL_PRIORITY_CLASS,nil,nil,StartupInfo,ProcessInfo);
  if Result then
    ProcessID:=ProcessInfo.dwProcessId;
end;

type
  TEnumInfo=packed record
    Handles: TList;
    ProcessID: Cardinal;
  end;
  PEnumInfo=^TEnumInfo;

function EnumWindowsProc(Handle: HWnd; lParam: LPARAM): BOOL; stdcall;
var
  Info: PEnumInfo;
  HandlePID: Cardinal;
  Flag: Boolean;
begin
  if Handle=0 then
    Result:=false
  else begin
    Info:=PEnumInfo(lParam);
    if Assigned(Info) then begin
      HandlePID:=0;
      GetWindowThreadProcessId(Handle,HandlePID);
      Flag:=HandlePID=Info.ProcessID;
      if Flag then
        Info.Handles.Add(Pointer(Handle));
    end;
    Result:=true;
  end;
end;

function ProcessStop(const ProcessID, Timeout: Cardinal): Boolean;

  function TryEndSession(ProcessHandle: THandle): Boolean;
  var
    Info: TEnumInfo;
    Handles: TList;
    Handle: HWnd;
    i: Integer;
    Ret: DWORD;
  begin
    Handles:=TList.Create;
    try
      Result:=false;
      Info.Handles:=Handles;
      Info.ProcessID:=ProcessID;
      if EnumWindows(@EnumWindowsProc,LPARAM(@Info)) then begin

        for i:=0 to Handles.Count-1 do begin
          Handle:=HWnd(Handles.Items[i]);
          PostMessage(Handle,WM_CLOSE,0,0);
          PostMessage(Handle,WM_QUIT,0,0);
          PostMessage(Handle,WM_SYSCOMMAND,SC_CLOSE,0);
          PostMessage(Handle,WM_ENDSESSION,WPARAM(True),LPARAM(ENDSESSION_DEFAULT));
        end;

        Ret:=WaitForSingleObject(ProcessHandle,Timeout);

        case Ret of
          WAIT_FAILED: Result:=false;
          WAIT_OBJECT_0: Result:=true;
        else
          Result:=false;
        end;

      end;
    finally
      Handles.Free;
    end;
  end;

var
  ProcessHandle: THandle;
begin
  Result:=false;
  ProcessHandle:=OpenProcess(PROCESS_ALL_ACCESS,false,ProcessID);
  if ProcessHandle>0 then begin
    try
      Result:=TryEndSession(ProcessHandle);
      if not Result then
        Result:=TerminateProcess(ProcessHandle,0);
    finally
      CloseHandle(ProcessHandle);
    end;
  end;
end;

function ServiceStart(const ServiceName: String; const Timeout: Cardinal): Boolean;
var
  SC,SVC: SC_HANDLE;
  Status: TServiceStatus;
  Temp: PChar;
  dwCheckPoint: DWord;
begin
  Result:=false;
  if Advapi32Loaded then begin
    Status.dwCurrentState:=1;
    SC:=_OpenSCManager(nil,nil,SC_MANAGER_CONNECT);
    if SC>0 then begin
      try
        SVC:=_OpenService(SC,PChar(ServiceName),SERVICE_START or SERVICE_QUERY_STATUS);
        if SVC>0 then begin
          try
            Temp:=nil;
            if _StartService(SVC,0,temp) then
              if _QueryServiceStatus(SVC,Status) then begin
                while (Status.dwCurrentState<>SERVICE_RUNNING) do begin
                  dwCheckPoint:=Status.dwCheckPoint;
                  //Sleep(Status.dwWaitHint);
                  Sleep(Timeout);
                  if (not _QueryServiceStatus(SVC,Status)) then
                    break;
                  if (Status.dwCheckPoint < dwCheckPoint) then
                    break;
                end;
              end;
          finally
            _CloseServiceHandle(SVC);
          end;
        end;
      finally
        _CloseServiceHandle(SC);
      end;
    end;
    Result:=Status.dwCurrentState=SERVICE_RUNNING;
  end;
end;

function ServiceStop(const ServiceName: String; const TimeOut: Cardinal): Boolean;
var
  SC,SVC: SC_HANDLE;
  Status: TServiceStatus;
  dwCheckPoint: DWord;
begin
  Result:=false;
  if Advapi32Loaded then begin
    Status.dwCurrentState:=1;
    SC:=_OpenSCManager(nil,nil,SC_MANAGER_CONNECT);
    if SC>0 then begin
      try
        SVC:=_OpenService(SC,PChar(ServiceName),SERVICE_STOP or SERVICE_QUERY_STATUS);
        if SVC>0 then begin
          try
            if _ControlService(SVC,SERVICE_CONTROL_STOP,Status) then
              if _QueryServiceStatus(SVC,Status) then begin
                while (Status.dwCurrentState<>SERVICE_STOPPED) do begin
                  dwCheckPoint:=Status.dwCheckPoint;
//                  Sleep(Status.dwWaitHint);
                  Sleep(TimeOut);
                  if (not _QueryServiceStatus(SVC,Status)) then
                    break;
                  if (Status.dwCheckPoint < dwCheckPoint) then
                    break;
                end;
              end;
          finally
            _CloseServiceHandle(SVC);
          end;
        end;
      finally
        _CloseServiceHandle(SC);
      end;
    end;
    Result:=Status.dwCurrentState=SERVICE_STOPPED;
  end;
end;

function GetNumberProcessors: Cardinal;
var
  ReturnLength: DWORD;
  SBI: SYSTEM_BASIC_INFORMATION;
begin
  Result:=0;
  if NtDllLoaded then begin
    _NtQuerySystemInformation(0, @SBI, SizeOf(SYSTEM_BASIC_INFORMATION),ReturnLength);
    Result:= SBI.bKeNumberProcessors;
  end;
end;

function GetProcessFileName(const ProcessHandle: THandle): String;
var
  FileName: array[0..MAX_PATH] of Char;
  Len: DWORD;
begin
  Result:='';
  FillChar(FileName,SizeOf(FileName),0);
  Len:=GetModuleFileNameEx(ProcessHandle,0,@FileName,SizeOf(FileName));
  if Len>0 then
    Result:=FileName;
end;

function GetFilePath(const FileName: String; var CommandLine: String): String;
var
  APos: Integer;
  Strings: TStringList;
  i: Integer;
  S: String;
  Flag: Boolean;
begin
  Result:='';
  APos:=AnsiPos('/',FileName);
  if APos=0 then
    APos:=AnsiPos('-',FileName);
  if APos>0 then begin
    Result:=Copy(FileName,1,APos-1);
    ParseBetween(Result,'"','"',Result);
    Result:=Trim(Result);
    CommandLine:=Trim(Copy(FileName,APos,Length(FileName)));
  end else begin
    Strings:=TStringList.Create;
    try
      GetStringsByString(FileName,' ',Strings);
      S:='';
      Flag:=false;
      for i:=0 to Strings.Count-1 do begin
        S:=S+' '+Strings[i];
        if not Flag and FileExists(Trim(S)) then begin
          Result:=Trim(S);
          Flag:=true;
          S:='';
        end;
      end;
      CommandLine:=Trim(S);
      if Trim(Result)='' then begin
        Result:=CommandLine;
        CommandLine:='';
      end;
      ParseBetween(Result,'"','"',Result);
    finally
      Strings.Free;
    end;
  end;
end;

type
 PTOKEN_USER = ^TOKEN_USER;
 _TOKEN_USER = record
   User : TSidAndAttributes;
 end;
 TOKEN_USER = _TOKEN_USER;

function GetProcessUserName(const ProcessHandle: THandle; var DomainName: String): String;
var
  TokenHandle: THandle;
  ReturnLength: DWORD;
  TknUser: PTOKEN_USER;
  UserName: array[0..255] of Char;
  UserNameLen: DWORD;
  Domain: array[0..255] of Char;
  DomainLen: DWORD;
  Use: SID_NAME_USE;
begin
  Result:='';
  if OpenProcessToken(ProcessHandle,TOKEN_QUERY,TokenHandle) then begin
    try
      GetTokenInformation(TokenHandle, TokenUser, nil, 0, ReturnLength);
      if GetLastError = ERROR_INSUFFICIENT_BUFFER then begin
        GetMem(TknUser,ReturnLength);
        if ReturnLength>0 then begin
          try
            if GetTokenInformation(TokenHandle,TokenUser,
                                   TknUser,ReturnLength,ReturnLength) then begin
              FillChar(UserName,SizeOf(UserName),0);
              FillChar(DomainName,SizeOf(DomainName),0);
              if LookupAccountSid(nil, TknUser.User.Sid,@UserName,UserNameLen,@Domain,DomainLen,Use) then begin
                Result:=UserName;
                DomainName:=Domain;
              end;
            end;
          finally
            FreeMem(TknUser,ReturnLength);
          end;
        end;
      end;
    finally
      CloseHandle(TokenHandle);
    end;
  end;
end;

function GetProcessCommandLine(const ProcessHandle: THandle; const FileName: String): String;
const
  STATUS_SUCCESS = $00000000;
  OffsetProcessParametersx32 = $10;//16
  OffsetCommandLinex32 = $40;//64
var
  CommandLine: UNICODE_STRING;
  CommandLineContents: WideString;
  PBI: PROCESS_BASIC_INFORMATION;
  ReturnLength: DWORD;
  rtlUserProcAddress: Pointer;
  APos: Integer;
  S: String;
begin
  Result:='';
  // get the PROCESS_BASIC_INFORMATION to access to the PEB Address
  if (_NtQueryInformationProcess(ProcessHandle,0,@PBI,SizeOf(PBI),ReturnLength)=STATUS_SUCCESS) and
     (ReturnLength=SizeOf(PBI)) then begin
    //get the address of the RTL_USER_PROCESS_PARAMETERS struture
    if ReadProcessMemory(ProcessHandle,
                         Pointer(Longint(PBI.PEBBaseAddress)+OffsetProcessParametersx32),
                         @rtlUserProcAddress,SizeOf(Pointer),ReturnLength) then begin
      if ReadProcessMemory(ProcessHandle,
                           Pointer(Longint(rtlUserProcAddress)+OffsetCommandLinex32),
                           @CommandLine,SizeOf(CommandLine),ReturnLength) then begin
        SetLength(CommandLineContents,CommandLine.length);
        //get the CommandLine field
        if ReadProcessMemory(ProcessHandle,CommandLine.Buffer,
                             @CommandLineContents[1],CommandLine.Length,ReturnLength) then begin
          Result:=WideCharLenToString(PWideChar(CommandLineContents),CommandLine.length div 2);
          S:=Result;
          APos:=AnsiPos('\??\',S);
          if APos>0 then
            Delete(S,1,Length('\??\'));

          Result:='';
          
          S:=GetFilePath(S,Result);

{          APos:=AnsiPos(S,Result);
          if (APos>0) and (Length(Result)>Length(S)) then begin
            Result:=Copy(Result,APos+Length(S),Length(Result));
            Delete(Result,1,1);
            Result:=Trim(Result);
          end else begin
            S:=ExtractFileName(FileName);
            APos:=AnsiPos(S,Result);
            if (APos>0) and (Length(Result)>Length(S)) then begin
              Result:=Copy(Result,APos+Length(S),Length(Result));
              Delete(Result,1,1);
              Result:=Trim(Result);
            end;
          end;}
        end;
      end;
   end;
 end;
end;

function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
var
  LocalFileTime: TFileTime;
  ATimeExt: Integer;
//  SystemTime: TSystemTime;
begin
  FileTimeToLocalFileTime(FileTime,LocalFileTime);
  FileTimeToDosDateTime(LocalFileTime,LongRec(ATimeExt).Hi, LongRec(ATimeExt).Lo);
  Result:=FileDateToDateTime(ATimeExt);
//  FileTimeToSystemTime(FileTime,SystemTime);
//  Result:=SystemTimeToDateTime(SystemTime);
end;

{ TBisSystemServices }

constructor TBisSystemServices.Create;
begin
  inherited Create;
  EnablePrivilege(SSeDebugPrivilege);
end;

function TBisSystemServices.GetItem(Index: Integer): TBisSystemService;
begin
  Result:=TBisSystemService(inherited Items[Index]);
end;

function TBisSystemServices.Find(const ServiceName: String): TBisSystemService;
var
  Item: TBisSystemService;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.Name,ServiceName) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

procedure TBisSystemServices.GetServices(const FileName: String; Services: TBisSystemServices);
var
  Item: TBisSystemService;
  i: Integer;
begin
  if Assigned(Services) then begin
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if AnsiSameText(Item.FileName,FileName) then
        Services.Add(Item);
    end;
  end;
end;

procedure TBisSystemServices.GetServices(const ProcessID: Cardinal; Services: TBisSystemServices);
var
  Item: TBisSystemService;
  i: Integer;
begin
  if Assigned(Services) then begin
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if Item.ProcessID=ProcessID then
        Services.Add(Item);
    end;
  end;
end;

procedure TBisSystemServices.Refresh;
var
  SC, SVC: SC_HANDLE;
  BufSize: DWORD;
  BytesNeeded, ServicesReturned, ResumeHandle: DWORD;
  Ret: BOOL;
  Services: LPBYTE;
  Temp: LPENUM_SERVICE_STATUS_PROCESS;
  i: Integer;
  Service: TBisSystemService;
  ServiceConfig: PQueryServiceConfig;
  CommandLine: String;
begin
  Clear;
  if Advapi32Loaded then begin
    SC:=_OpenSCManager(nil,nil,SC_MANAGER_ENUMERATE_SERVICE or SC_MANAGER_CONNECT);
    if SC > 0 then begin
      try
        BufSize:=0;
        BytesNeeded:=0;
        ServicesReturned:=0;
        ResumeHandle:=0;
        _EnumServicesStatusEx(SC,SC_ENUM_PROCESS_INFO,SERVICE_WIN32,SERVICE_STATE_ALL,nil,
                              BufSize,BytesNeeded,ServicesReturned,ResumeHandle,nil);
        if (BytesNeeded>0) then begin
          BufSize:=BytesNeeded;

          GetMem(Services,BytesNeeded);
          try
            Ret:=_EnumServicesStatusEx(SC,SC_ENUM_PROCESS_INFO,SERVICE_WIN32,SERVICE_STATE_ALL,Services,
                                       BufSize,BytesNeeded,ServicesReturned,ResumeHandle,nil);
            if Ret then begin
              Temp:=LPENUM_SERVICE_STATUS_PROCESS(Services);
              for i:=0 to ServicesReturned-1 do begin
                if Assigned(Temp) then begin
                  SVC:=_OpenService(SC,Temp^.lpServiceName,SERVICE_QUERY_CONFIG);
                  if SVC>0 then begin
                    try
                      Service:=TBisSystemService.Create;
                      Service.Name:=Temp^.lpServiceName;
                      Service.DisplayName:=Temp^.lpDisplayName;

                      case Temp^.ServiceStatusProcess.dwServiceType of
                        SERVICE_KERNEL_DRIVER: Service.ServiceType:=stKernelDriver;
                        SERVICE_FILE_SYSTEM_DRIVER: Service.ServiceType:=stFileSystemDriver;
                        SERVICE_ADAPTER: Service.ServiceType:=stAdapter;
                        SERVICE_RECOGNIZER_DRIVER: Service.ServiceType:=stRecognizerDriver;
                        SERVICE_WIN32: Service.ServiceType:=stDriver;
                        SERVICE_WIN32_OWN_PROCESS: Service.ServiceType:=stWin32OwnProcess;
                        SERVICE_WIN32_SHARE_PROCESS: Service.ServiceType:=stWin32ShareProcess;
                        SERVICE_INTERACTIVE_PROCESS: Service.ServiceType:=stInteractiveProcess;
                        SERVICE_TYPE_ALL: Service.ServiceType:=stTypeAll;
                      else
                        Service.ServiceType:=stUnknown;
                      end;

                      case Temp^.ServiceStatusProcess.dwCurrentState of
                        SERVICE_STOPPED: Service.ServiceState:=ssStopped;
                        SERVICE_START_PENDING: Service.ServiceState:=ssStartPending;
                        SERVICE_STOP_PENDING: Service.ServiceState:=ssStopPending;
                        SERVICE_RUNNING: Service.ServiceState:=ssRunning;
                        SERVICE_CONTINUE_PENDING: Service.ServiceState:=ssContinuePending;
                        SERVICE_PAUSE_PENDING: Service.ServiceState:=ssPausePending;
                        SERVICE_PAUSED: Service.ServiceState:=ssPaused;
                      else
                        Service.ServiceState:=ssUnknown;
                      end;

                      Service.ProcessID:=Temp^.ServiceStatusProcess.dwProcessId;

                      _QueryServiceConfig(SVC,nil,0,BytesNeeded);
                      if BytesNeeded>0 then begin
                        GetMem(ServiceConfig,BytesNeeded);
                        try
                          if _QueryServiceConfig(SVC,ServiceConfig,BytesNeeded,BytesNeeded) then begin
                            Service.FileName:=GetFilePath(ServiceConfig.lpBinaryPathName,CommandLine);
                            Service.CommandLine:=CommandLine;
                          end;
                        finally
                          FreeMem(ServiceConfig,BytesNeeded);
                        end;
                      end;

                      Add(Service);

                    finally
                      _CloseServiceHandle(SVC);
                    end;
                  end;
                end;
                Inc(Temp);
              end;
            end;
          finally
            FreeMem(Services);
          end;
        end;
      finally
        CloseServiceHandle(SC);
      end;
    end
  end;
end;

{ TBisSystemProcess }

constructor TBisSystemProcess.Create;
begin
  inherited Create;
end;

destructor TBisSystemProcess.Destroy;
begin
  inherited Destroy;
end;

{ TBisSystemProcesses }

constructor TBisSystemProcesses.Create;
begin
  inherited Create;
  EnablePrivilege(SSeDebugPrivilege);
end;

function TBisSystemProcesses.GetItem(Index: Integer): TBisSystemProcess;
begin
  Result:=TBisSystemProcess(inherited Items[Index]);
end;

function TBisSystemProcesses.Find(const ProcessID: Cardinal): TBisSystemProcess;
var
  i: Integer;
  Item: TBisSystemProcess;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.ProcessID=ProcessID then begin
      Result:=Item;
      exit;
    end;
  end;
end;

procedure TBisSystemProcesses.GetProcesses(const FileName: String; Processes: TBisSystemProcesses);
var
  i: Integer;
  Item: TBisSystemProcess;
begin
  if Assigned(Processes) then begin
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if AnsiSameText(Item.FileName,FileName) then
        Processes.Add(Item);
    end;
  end;
end;

procedure TBisSystemProcesses.Refresh;
var
  Process: TBisSystemProcess;
  ProcessHandle: THandle;
  ReturnLength: DWORD;
  SI,Temp: PSYSTEM_PROCESS_INFORMATION;
  FileName: String;
  DomainName: String;
begin
  Clear;
  if NtDllLoaded then begin
    ReturnLength:=0;
    if _NtQuerySystemInformation(SystemProcessesAndThreadsInformation,nil,0,ReturnLength)<>STATUS_INFO_LENGTH_MISMATCH then Exit;
    if ReturnLength > 0 then begin
      GetMem(SI,ReturnLength);
      try
        if _NtQuerySystemInformation(SystemProcessesAndThreadsInformation,SI,ReturnLength,ReturnLength)=0 then begin
          Temp:=SI;
          repeat
            if Assigned(Temp^.ModuleName) then begin
              ProcessHandle:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,false,Temp^.ProcessID);
              try
                FileName:=GetProcessFileName(ProcessHandle);
                FileName:=ExpandFileName(FileName);

                if FileExists(FileName) then begin

                  Process:=TBisSystemProcess.Create;
                  Process.Name:=Temp^.ModuleName;
                  Process.FileName:=FileName;
                  Process.CommandLine:=GetProcessCommandLine(ProcessHandle,FileName);
                  Process.ProcessID:=Temp^.ProcessID;
                  Process.CreateTime:=FileTimeToDateTime(Temp^.CreateTime);
                  Process.UserName:=GetProcessUserName(ProcessHandle,DomainName);
                  Process.DomainName:=DomainName;

                  Add(Process);
                end;
              finally
                CloseHandle(ProcessHandle);
              end;
            end;
            if Temp^.NextOffset=0 then
              break;
            Temp:=Pointer(DWORD(Temp)+Temp^.NextOffset);
          until false;
        end;
      finally
        FreeMem(SI);
      end;
    end;
  end;
end;

initialization
  NtDllLoaded:=InitNtDll;
  Advapi32Loaded:=InitAdvapi32;

finalization
  NtDllLoaded:=false;
  DoneNtDll;
  Advapi32Loaded:=false;
  DoneAdvapi32;

end.
