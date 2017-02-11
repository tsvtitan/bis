
{*******************************************************}
{                                                       }
{         MiTeC System Information Components           }
{          CPU Usage Evaluation Component               }
{           version 1.1 for Delphi 3,4,5                }
{                                                       }
{           Copyright © 2001 Michal Mutl                }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_CPUUsage;

interface

uses
  SysUtils, Windows, Classes, ExtCtrls;

type
  TOnIntervalEvent = procedure (Sender: TObject; Value: DWORD) of object;

  TMCPUUsage = class(TComponent)
  private
    Timer: TTimer;
    FOnInterval: TOnIntervalEvent;
    FLastValue, FValue: comp;
    FReady: Boolean;
    function GetActive: Boolean;
    function GetInterval: DWORD;
    procedure SetActive(const Value: Boolean);
    procedure SetInterval(const Value: DWORD);
    procedure OnTimer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Active: Boolean read GetActive write SetActive;
    property Interval: DWORD read GetInterval write SetInterval;
    property OnInterval: TOnIntervalEvent read FOnInterval write FOnInterval;
  end;

function Init9xCPUData: Boolean;
function Get9xCPUUsage: integer;
procedure Release9xCPUData;

function InitNTCPUData: Boolean;
function GetNTCPUUsage: comp;
procedure ReleaseNTCPUData;

const
  ObjCounter = 'KERNEL\CPUUsage';
  StartStat = 'PerfStats\StartStat';
  StatData = 'PerfStats\StatData';
  StopStat = 'PerfStats\StopStat';

implementation

{$R 'MSI_CPUUsage.dcr'}

uses MiTeC_Routines, Registry;

type
  PULONG = ^ULONG;

  ULONG = DWORD;

  NTSTATUS = ULONG;

  PVOID = Pointer;

  _SYSTEM_INFORMATION_CLASS = (
          SystemBasicInformation,
          SystemProcessorInformation,
          SystemPerformanceInformation,
          SystemTimeOfDayInformation,
          SystemNotImplemented1,
          SystemProcessesAndThreadsInformation,
          SystemCallCounts,
          SystemConfigurationInformation,
          SystemProcessorTimes,
          SystemGlobalFlag,
          SystemNotImplemented2,
          SystemModuleInformation,
          SystemLockInformation,
          SystemNotImplemented3,
          SystemNotImplemented4,
          SystemNotImplemented5,
          SystemHandleInformation,
          SystemObjectInformation,
          SystemPagefileInformation,
          SystemInstructionEmulationCounts,
          SystemInvalidInfoClass1,
          SystemCacheInformation,
          SystemPoolTagInformation,
          SystemProcessorStatistics,
          SystemDpcInformation,
          SystemNotImplemented6,
          SystemLoadImage,
          SystemUnloadImage,
          SystemTimeAdjustment,
          SystemNotImplemented7,
          SystemNotImplemented8,
          SystemNotImplemented9,
          SystemCrashDumpInformation,
          SystemExceptionInformation,
          SystemCrashDumpStateInformation,
          SystemKernelDebuggerInformation,
          SystemContextSwitchInformation,
          SystemRegistryQuotaInformation,
          SystemLoadAndCallImage,
          SystemPrioritySeparation,
          SystemNotImplemented10,
          SystemNotImplemented11,
          SystemInvalidInfoClass2,
          SystemInvalidInfoClass3,
          SystemTimeZoneInformation,
          SystemLookasideInformation,
          SystemSetTimeSlipEvent,
          SystemCreateSession,
          SystemDeleteSession,
          SystemInvalidInfoClass4,
          SystemRangeStartInformation,
          SystemVerifierInformation,
          SystemAddVerifier,
          SystemSessionProcessesInformation);
     SYSTEM_INFORMATION_CLASS = _SYSTEM_INFORMATION_CLASS;

     _SYSTEM_PROCESSOR_TIMES = packed record
          IdleTime,
          KernelTime,
          UserTime,
          DpcTime,
          InterruptTime: int64;
          InterruptCount: ULONG;
     end;

     SYSTEM_PROCESSOR_TIMES = _SYSTEM_PROCESSOR_TIMES;
     PSYSTEM_PROCESSOR_TIMES = ^_SYSTEM_PROCESSOR_TIMES;

  TNativeQuerySystemInformation = function(
          SystemInformationClass: SYSTEM_INFORMATION_CLASS;
          SystemInformation: PVOID;
          SystemInformationLength: ULONG;
          ReturnLength: PULONG
          ): NTSTATUS; stdcall;

const
  NTDLL_DLL_Name = 'NTDLL.DLL';

  STATUS_SUCCESS = $00000000;
  STATUS_INFO_LENGTH_MISMATCH = $C0000004;

  Timer100N = 10000000;
  Timer1S = 1000;

var
  CPUSize, Cpu9xUsage: DWORD;
  CPUNTUsage: PSYSTEM_PROCESSOR_TIMES;
  Reg: TRegistry;

  NTDLL_DLL: THandle = 0;
  ZwQuerySystemInformation: TNativeQuerySystemInformation = nil;

function Init9xCPUData: Boolean;
begin
  Reg:=TRegistry.Create;
  with Reg do
    try
      Rootkey:=HKEY_DYN_DATA;
      if OpenKey(StartStat,False) then begin
        GetDataType(ObjCounter);
        ReadBinaryData(ObjCounter,CPU9xUsage,GetDataSize(ObjCounter));
        CloseKey;
        if not OpenKey(StatData,False) then
          raise Exception.Create('Unable to read performance data');
      end else
        raise Exception.Create('Unable to start performance monitoring');
    finally
      Result:=CurrentPath=StatData;
    end;
end;

function Get9xCPUUsage: integer;
begin
  with Reg do begin
    ReadBinaryData(ObjCounter,CPU9xUsage,4);
  end;
  Result:=Cpu9xUsage;
end;

procedure Release9xCPUData;
begin
  with Reg do begin
    CloseKey;
    if OpenKey(StopStat,False) then begin
      GetDataType(ObjCounter);
      GetDataType(ObjCounter);
      ReadBinaryData(ObjCounter,CPU9xUsage,GetDataSize(ObjCounter));
      CloseKey;
    end;
    Free;
  end;
end;

function InitNTCPUData: Boolean;
var
  R: NTSTATUS;
  n: DWORD;
begin
  n:=0;
  CPUNTUsage:=AllocMem(SizeOf(SYSTEM_PROCESSOR_TIMES));
  R:=ZwQuerySystemInformation(SystemProcessorTimes,CPUNTUsage,SizeOf(SYSTEM_PROCESSOR_TIMES),nil);
  while R=STATUS_INFO_LENGTH_MISMATCH do begin
    Inc(n);
    ReallocMem(CPUNTUsage,n*SizeOf(CPUNTUsage^));
    R:=ZwQuerySystemInformation(SystemProcessorTimes,CPUNTUsage,n*SizeOf(SYSTEM_PROCESSOR_TIMES),nil);
  end;
  CPUSize:=n*SizeOf(CPUNTUsage^);
  Result:=R=STATUS_SUCCESS;
end;

function GetNTCPUUsage;
begin
  ZwQuerySystemInformation(SystemProcessorTimes,CPUNTUsage,CPUSize,nil);
  Result:=CPUNTUsage^.IdleTime;
end;

procedure ReleaseNTCPUData;
begin
  Freemem(CPUNTUsage);
end;

{ TMCPUUsage }

constructor TMCPUUsage.Create(AOwner: TComponent);
begin
  inherited;
  Timer:=TTimer.Create(Self);
  Timer.Interval:=1000;
  Timer.Enabled:=False;
  if IsNT then
    FReady:=InitNTCPUData
  else
    FReady:=Init9xCPUData;
  if FReady then
    Timer.OnTimer:=OnTimer;
end;

destructor TMCPUUsage.Destroy;
begin
  Timer.Free;
  if FReady then begin
    if IsNT then
      ReleaseNTCPUData
    else
      Release9xCPUData;
  end;
  inherited;
end;

function TMCPUUsage.GetActive: Boolean;
begin
  Result:=Timer.Enabled;
end;

function TMCPUUsage.GetInterval: DWORD;
begin
  Result:=Timer.Interval;
end;

procedure TMCPUUsage.OnTimer(Sender: TObject);
var
  v: DWORD;
begin
  if IsNT then begin
    FLastValue:=FValue;
    FValue:=GetNTCPUUsage;
    v:=Round((Timer100n-(FValue-FLastValue)/(Timer.Interval/Timer1s))/Timer100n*100);
  end else
    v:=Get9xCPUUsage;
  if Assigned(FOnInterval) then
    FOnInterval(Self,v);
end;

procedure TMCPUUsage.SetActive(const Value: Boolean);
begin
  Timer.Enabled:=Value and FReady;
end;

procedure TMCPUUsage.SetInterval(const Value: DWORD);
begin
  Timer.Interval:=Value;
end;

initialization
  if IsNT then begin
    if NTDLL_DLL=0 then
      NTDLL_DLL:=GetModuleHandle(NTDLL_DLL_name);
    if NTDLL_DLL<>0 then
      @ZwQuerySystemInformation:=GetProcAddress(NTDLL_DLL,'ZwQuerySystemInformation');
  end;
end.
