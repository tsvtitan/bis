
{*******************************************************}
{                                                       }
{             MiTeC Delphi Runtime Library              }
{          Windows NT Process Status API Unit           }
{           version 1.1 for Delphi 3,4,5                }
{                                                       }
{            Copyright © 1998 Michal Mutl               }
{                                                       }
{*******************************************************}


unit MiTeC_PSAPI;

interface

uses Classes, Windows, ShellAPI, SysUtils;

type
  PHInst = ^HInst;
  TModuleInfo = record
    lpBaseOfDll : pointer;
    SizeOfImage : Integer;
    EntryPoint : pointer
  end;

  TPSAPIWsWatchInformation = record
    FaultingPc : pointer;
    FaultingVa : pointer
  end;

  TProcessMemoryCounters = record
    cb : Integer;
    PageFaultCount : Integer;
    PeakWorkingSetSize : Integer;
    WorkingSetSize : Integer;
    QuotaPeakPagedPoolUsage : Integer;
    QuotaPagedPoolUsage : Integer;
    QuotaPeakNonPagedPoolUsage : Integer;
    QuotaNonPagedPoolUsage : Integer;
    PagefileUsage : Integer;
    PeakPagefileUsage : Integer
  end;

  TaskEnumProcEx = function(threadID : DWORD; hMod16 : WORD; hTask16 : WORD; modName : PChar; fileName : PChar; param : DWORD) : BOOL; stdcall;

  function InitPSAPI: Boolean;
  function FreePSAPI: Boolean;
  function EnumProcesses(pidList : PInteger; cb : Integer; var cbNeeded : DWORD): boolean; stdcall;
  function EnumProcessModules(hProcess : THandle; moduleList : PHInst; cb : Integer; var cbNeeded : DWORD) : boolean; stdcall;
  function GetModuleBaseName(hProcess : THandle; module : HInst; BaseName : Pchar; size : Integer) : Integer; stdcall;
  function GetModuleFileNameEx(hProcess : THandle; module : HInst; FileName : PChar; size : Integer) : Integer; stdcall;
  function GetModuleInformation(hProcess : THandle; module : HInst; var info : TModuleInfo; size : Integer) : boolean; stdcall;
  function EmptyWorkingSet(hProcess : THandle) : boolean; stdcall;
  function QueryWorkingSet(hProcess : THandle; var pv; size : Integer) : boolean; stdcall;
  function InitializeProcessForWsWatch(hProcess : THandle) : boolean; stdcall;
  function GetWsChanges(hProcess : THandle; var WatchInfo : TPSAPIWsWatchInformation; size : Integer) : boolean; stdcall;
  function GetMappedFileName(hProcess : THandle; pv : pointer; FileName : PChar; size : Integer) : Integer; stdcall;
  function EnumDeviceDrivers(ImageBase : PInteger; cb : dword; var cbNeeded : dword) : boolean; stdcall;
  function GetDeviceDriverBaseName(ImageBase : Integer; BaseName : PChar; size : dword) : Integer; stdcall;
  function GetDeviceDriverFileName(ImageBase : Integer; FileName : PChar; size : dword) : Integer; stdcall;
  function GetProcessMemoryInfo(hProcess : THandle; var ProcessMemoryCounters : TProcessMemoryCounters; size : Integer) : boolean; stdcall;

  function InitVDM: Boolean;
  function FreeVDM: Boolean;
  function VDMEnumTaskWOWEx(pid : DWORD; callback : TaskEnumProcEx; param : DWORD) : Integer; stdcall;

type
  TVDMEnumTaskWOWEx = function (pid : DWORD; callback : TaskEnumProcEx; param : DWORD) : Integer; stdcall;

  TEnumProcesses = function (pidList : PInteger; cb : Integer; var cbNeeded : DWORD): boolean; stdcall;
  TEnumProcessModules = function (hProcess : THandle; moduleList : PHInst; cb : Integer; var cbNeeded : DWORD) : boolean; stdcall;
  TGetModuleBaseName = function (hProcess : THandle; module : HInst; BaseName : Pchar; size : Integer) : Integer; stdcall;
  TGetModuleFileNameEx = function (hProcess : THandle; module : HInst; FileName : PChar; size : Integer) : Integer; stdcall;
  TGetModuleInformation = function (hProcess : THandle; module : HInst; var info : TModuleInfo; size : Integer) : boolean; stdcall;
  TEmptyWorkingSet = function (hProcess : THandle) : boolean; stdcall;
  TQueryWorkingSet = function (hProcess : THandle; var pv; size : Integer) : boolean; stdcall;
  TInitializeProcessForWsWatch = function (hProcess : THandle) : boolean; stdcall;
  TGetWsChanges = function (hProcess : THandle; var WatchInfo : TPSAPIWsWatchInformation; size : Integer) : boolean; stdcall;
  TGetMappedFileName = function (hProcess : THandle; pv : pointer; FileName : PChar; size : Integer) : Integer; stdcall;
  TEnumDeviceDrivers = function (ImageBase : PInteger; cb : dword; var cbNeeded : dword) : boolean; stdcall;
  TGetDeviceDriverBaseName = function (ImageBase : Integer; BaseName : PChar; size : dword) : Integer; stdcall;
  TGetDeviceDriverFileName = function (ImageBase : Integer; FileName : PChar; size : dword) : Integer; stdcall;
  TGetProcessMemoryInfo = function (hProcess : THandle; var ProcessMemoryCounters : TProcessMemoryCounters; size : Integer) : boolean; stdcall;

var
  modulelist :PHInst;
  PSAPILoaded :Boolean;

implementation

const
  PSAPIDLL = 'psapi.dll';
  VDMDBGDLL = 'vdmdbg.dll';

var
  PSAPIHandle, VDMHandle: THandle;

  _VDMEnumTaskWOWEx :TVDMEnumTaskWOWEx;

  _EnumProcesses: TEnumProcesses;
  _EnumProcessModules: TEnumProcessModules;
  _GetModuleBaseName: TGetModuleBaseName;
  _GetModuleFileNameEx: TGetModuleFileNameEx;
  _GetModuleInformation: TGetModuleInformation;
  _EmptyWorkingSet: TEmptyWorkingSet;
  _QueryWorkingSet: TQueryWorkingSet;
  _InitializeProcessForWsWatch: TInitializeProcessForWsWatch;
  _GetWsChanges: TGetWsChanges;
  _GetMappedFileName: TGetMappedFileName;
  _EnumDeviceDrivers: TEnumDeviceDrivers;
  _GetDeviceDriverBaseName: TGetDeviceDriverBaseName;
  _GetDeviceDriverFileName: TGetDeviceDriverFileName;
  _GetProcessMemoryInfo: TGetProcessMemoryInfo;

function InitPSAPI: Boolean;
begin
  PSAPIHandle:=GetModuleHandle(PSAPIDLL);
  if PSAPIHandle = 0 then
    PSAPIHandle:=loadlibrary(psapidll);
  if PSAPIHandle<>0 then begin
    try
      @_EnumProcesses:=getprocaddress(PSAPIHandle,pchar('EnumProcesses'));
      @_EnumProcessModules:=getprocaddress(PSAPIHandle,pchar('EnumProcessModules'));
      @_GetModuleBaseName:=getprocaddress(PSAPIHandle,pchar('GetModuleBaseNameA'));
      @_GetModuleFileNameEx:=getprocaddress(PSAPIHandle,pchar('GetModuleFileNameExA'));
      @_GetModuleInformation:=getprocaddress(PSAPIHandle,pchar('GetModuleInformation'));
      @_EmptyWorkingSet:=getprocaddress(PSAPIHandle,pchar('EmptyWorkingSet'));
      @_QueryWorkingSet:=getprocaddress(PSAPIHandle,pchar('QueryWorkingSet'));
      @_InitializeProcessForWsWatch:=getprocaddress(PSAPIHandle,pchar('InitializeProcessForWsWatch'));
      @_GetWsChanges:=getprocaddress(PSAPIHandle,pchar('GetWsChanges'));
      @_GetMappedFileName:=getprocaddress(PSAPIHandle,pchar('GetMappedFileNameA'));
      @_EnumDeviceDrivers:=getprocaddress(PSAPIHandle,pchar('EnumDeviceDrivers'));
      @_GetDeviceDriverBaseName:=getprocaddress(PSAPIHandle,pchar('GetDeviceDriverBaseNameA'));
      @_GetDeviceDriverFileName:=getprocaddress(PSAPIHandle,pchar('GetDeviceDriverFileNameA'));
      @_GetProcessMemoryInfo:=getprocaddress(PSAPIHandle,pchar('GetProcessMemoryInfo'));
    except
      if not freepsapi then
        raise exception.create('Unload Error: '+psapidll+' ('+inttohex(getmodulehandle(psapidll),8)+')');
    end;
  end;
  result:=(PSAPIHandle<>0) and assigned(_EnumProcesses);
end;

function FreePSAPI: Boolean;
begin
  result:=freelibrary(psapihandle);
end;

function InitVDM: Boolean;
begin
  VDMHandle:=GetModuleHandle(VDMDBGDLL);
  if VDMHandle = 0 then
    VDMHandle:=loadlibrary(vdmdbgdll);
  if VDMHandle<>0 then begin
    try
      @_VDMEnumTaskWOWEx:=getprocaddress(VDMHandle,pchar('VDMEnumTaskWOWEx'));
    except
      if not freevdm then
        raise exception.create('Unload Error: '+vdmdbgdll+' ('+inttohex(getmodulehandle(vdmdbgdll),8)+')');
    end;
  end;
  result:=(VDMHandle<>0) and assigned(_VDMEnumTaskWOWEx);
end;

function FreeVDM: Boolean;
begin
  result:=freelibrary(vdmhandle);
end;

function VDMEnumTaskWOWEx;
begin
  if (vdmhandle<>0) and assigned(_VDMEnumTaskWOWEx) then
    result:=_VDMEnumTaskWOWEx(pid,callback,param)
  else
    result:=0;
end;

function EnumProcesses;
begin
  if (psapihandle<>0) and assigned(_EnumProcesses) then
    result:=_EnumProcesses(pidList,cb,cbNeeded)
  else
    result:=false;
end;

function EnumProcessModules;
begin
  if (psapihandle<>0) and assigned(_EnumProcessModules) then
    result:=_EnumProcessModules(hProcess,moduleList,cb,cbNeeded)
  else
    result:=false;
end;

function GetModuleBaseName(hProcess : THandle; module : HInst; BaseName : Pchar; size : Integer) : Integer; stdcall;
begin
  if (psapihandle<>0) and assigned(_GetModuleBaseName) then
    result:=_GetModuleBaseName(hProcess,module,BaseName,size)
  else
    result:=0;
end;

function GetModuleFileNameEx;
begin
  if (psapihandle<>0) and assigned(_GetModuleFileNameEx) then
    result:=_GetModuleFileNameEx(hProcess,module,FileName,size)
  else
    result:=0;
end;

function GetModuleInformation;
begin
  if (psapihandle<>0) and assigned(_GetModuleInformation) then
    result:=_GetModuleInformation(hProcess,module,info,size)
  else
    result:=false;
end;

function EmptyWorkingSet;
begin
  if (psapihandle<>0) and assigned(_EmptyWorkingSet) then
    result:=_EmptyWorkingSet(hProcess)
  else
    result:=false;
end;

function QueryWorkingSet;
begin
  if (psapihandle<>0) and assigned(_QueryWorkingSet) then
    result:=_QueryWorkingSet(hProcess,pv,size)
  else
    result:=false;
end;

function InitializeProcessForWsWatch;
begin
  if (psapihandle<>0) and assigned(_InitializeProcessForWsWatch) then
    result:=_InitializeProcessForWsWatch(hProcess)
  else
    result:=false;
end;

function GetWsChanges;
begin
  if (psapihandle<>0) and assigned(_GetWsChanges) then
    result:=_GetWsChanges(hProcess,WatchInfo,size)
  else
    result:=false;
end;

function GetMappedFileName;
begin
  if (psapihandle<>0) and assigned(_GetMappedFileName) then
    result:=_GetMappedFileName(hProcess,pv,FileName,size)
  else
    result:=0;
end;

function EnumDeviceDrivers;
begin
  if (psapihandle<>0) and assigned(_EnumDeviceDrivers) then
    result:=_EnumDeviceDrivers(ImageBase,cb,cbNeeded)
  else
    result:=false;
end;

function GetDeviceDriverBaseName;
begin
  if (psapihandle<>0) and assigned(_GetDeviceDriverBaseName) then
    result:=_GetDeviceDriverBaseName(ImageBase,BaseName,size)
  else
    result:=0;
end;

function GetDeviceDriverFileName;
begin
  if (psapihandle<>0) and assigned(_GetDeviceDriverFileName) then
    result:=_GetDeviceDriverFileName(ImageBase,FileName,size)
  else
    result:=0;
end;

function GetProcessMemoryInfo;
begin
  if (psapihandle<>0) and assigned(_GetProcessMemoryInfo) then
    result:=_GetProcessMemoryInfo(hProcess,ProcessMemoryCounters,size)
  else
    result:=false;
end;

initialization
  PSAPILoaded:=InitPSAPI;
finalization
  if PSAPILoaded then
    if not FreePSAPI then
      Exception.Create('Unload Error: PSAPI.DLL ('+inttohex(getmodulehandle('PSAPI.DLL'),8)+')');
end.

