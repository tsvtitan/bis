
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Process Detection Part                  }
{           version 5.6 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}


unit MSI_Processes;

interface

uses
  SysUtils, Windows, Classes;

type
  TProcesses = class(TPersistent)
  private
    FProcessList: TStringlist;

    function GetProcessList(var List: TStringList; FullPath: Boolean {$IFDEF SUPPORTS_DEFAULTPARAMS} = True {$ENDIF}): Boolean;
    function GetProcessCount: integer;
    function GetProcessName(Index: integer): string;
    procedure SetProcessCount(const Value: integer);

    procedure ClearList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property ProcessCount: integer read GetProcessCount write SetProcessCount;
  public
    property ProcessNames[Index: integer]: string read GetProcessName;

    function GetPidFromProcessName(const ProcessName: string): DWORD;
    function GetProcessNameFromWnd(Wnd: HWND): string;
    function GetProcessNameFromPid(PID: DWORD): string;

    function TerminateProcess(PID: DWORD; Timeout: Integer): Boolean;

    function GetTasksList(var List: TStringList): Boolean;
  end;

implementation

uses MiTeC_PSAPI, MiTeC_Routines, MiTeC_ToolHelp32, Messages;

{ TProcesses }

constructor TProcesses.Create;
begin
  FProcessList:=TStringList.Create;
end;

destructor TProcesses.Destroy;
begin
  ClearList;
  FProcessList.Free;
  inherited;
end;

procedure TProcesses.GetInfo;
begin
  try
    ClearList;
    GetProcessList(FProcessList,True);
  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TProcesses.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

function TProcesses.GetPidFromProcessName(
  const ProcessName: string): DWORD;
var
  i: Integer;
begin
  Result:=INVALID_HANDLE_VALUE;
  i:=FProcessList.IndexOf(ProcessName);
  if i>-1 then
    Result:=DWORD(FProcessList.Objects[I]);
end;

function TProcesses.GetProcessCount: integer;
begin
  Result:=FProcessList.Count;
end;

function TProcesses.GetProcessName(Index: integer): string;
begin
  try
    Result:=FProcessList[Index];
  except
    Result:='';
  end;
end;

function TProcesses.GetProcessNameFromPid(PID: DWORD): string;
var
  i: integer;
begin
  Result:='';
  i:=FProcessList.IndexOfObject(Pointer(PID));
  if i>-1 then
    Result:=FProcessList[i];
end;

function TProcesses.GetProcessNameFromWnd(Wnd: HWND): string;
var
  PID: DWORD;
  i: Integer;
begin
  Result:='';
  if IsWindow(Wnd) then begin
    PID:=INVALID_HANDLE_VALUE;
    GetWindowThreadProcessId(Wnd,@PID);
    i:=FProcessList.IndexOfObject(Pointer(PID));
    if i>-1 then
      Result:=FProcessList[i];
  end;
end;

function TProcesses.GetTasksList;

  function EnumWindowsProc(Wnd: HWND; List: TStrings): Boolean; stdcall;
  var
    ParentWnd: HWND;
    ExStyle: DWORD;
    Caption: array [0..255] of Char;
  begin
    if IsWindowVisible(Wnd) then begin
      ParentWnd:=GetWindowLong(Wnd,GWL_HWNDPARENT);
      ExStyle:=GetWindowLong(Wnd,GWL_EXSTYLE);
      if ((ParentWnd=0) or (ParentWnd=GetDesktopWindow)) and
        ((ExStyle and WS_EX_TOOLWINDOW=0) or (ExStyle and WS_EX_APPWINDOW<>0)) and
        (GetWindowText(Wnd,Caption,SizeOf(Caption))>0) then
          List.AddObject(Caption,Pointer(Wnd));
    end;
    Result:=True;
  end;

begin
  Result:=EnumWindows(@EnumWindowsProc,Integer(List));
end;

procedure TProcesses.Report(var sl: TStringList);
var
  i,n: integer;
begin
  with sl do begin
    Add('[Processes]');
    n:=ProcessCount;
    Add(Format('Count=%d',[n]));
    for i:=0 to n-1 do 
      Add(Format('%d=%s',[GetPIDFromProcessName(ProcessNames[i]),ProcessNames[i]]));
  end;
end;

function TProcesses.GetProcessList;

  function ProcessFileName(PID: DWORD): string;
  var
    Handle: THandle;
  begin
    Result:='';
    Handle:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,False,PID);
    if Handle<>0 then
      try
        SetLength(Result,MAX_PATH);
        if FullPath then begin
          if GetModuleFileNameEx(Handle,0,PChar(Result),MAX_PATH)>0 then
            SetLength(Result,StrLen(PChar(Result)))
          else
            Result:='';
        end else begin
          if GetModuleBaseName(Handle,0,PChar(Result),MAX_PATH)>0 then
            SetLength(Result,StrLen(PChar(Result)))
          else
            Result:='';
        end;
      finally
        CloseHandle(Handle);
      end;
  end;

  function BuildList_ToolHelp32: Boolean;
  var
    SnapProcHandle: THandle;
    ProcEntry: TProcessEntry32;
    NextProc: Boolean;
    FileName: string;
  begin
    SnapProcHandle:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
    Result:=(SnapProcHandle<>INVALID_HANDLE_VALUE);
    if Result then
      try
        ProcEntry.dwSize:=SizeOf(ProcEntry);
        NextProc:=Process32First(SnapProcHandle,ProcEntry);
        while NextProc do begin
          if ProcEntry.th32ProcessID=0 then begin
            FileName:='System Idle Process';
          end else begin
            if GetOS=os2K then begin
              FileName:=ProcessFileName(ProcEntry.th32ProcessID);
              if FileName='' then
                FileName:=ProcEntry.szExeFile;
            end else begin
              FileName:=ProcEntry.szExeFile;
              if not FullPath then
                FileName:=ExtractFileName(FileName);
            end;
          end;
          List.AddObject(FileName,Pointer(ProcEntry.th32ProcessID));
          NextProc:=Process32Next(SnapProcHandle,ProcEntry);
        end;
      finally
        CloseHandle(SnapProcHandle);
      end;
  end;

  function BuildList_PSAPI: Boolean;
  var
    PIDs: array [0..1024] of DWORD;
    Needed: DWORD;
    i: Integer;
    FileName: string;
  begin
    Result:=EnumProcesses(@PIDs,SizeOf(PIDs),Needed);
    if Result then begin
      for i:=0 to (Needed div SizeOf(DWORD))-1 do begin
        case PIDs[I] of
          0: FileName:='System Idle Process';
          2: if GetOS=osNT4 then
              FileName:='System Process'
            else
              FileName:=ProcessFileName(PIDs[i]);
          8: if GetOS=os2K then
              FileName:='System Process'
            else
              FileName:=ProcessFileName(PIDs[i]);
        else
          FileName:=ProcessFileName(PIDs[i]);
        end;
        if FileName<>'' then
          List.AddObject(FileName,Pointer(PIDs[i]));
      end;
    end;
  end;

begin
  if GetOS=osNT4 then
    Result:=BuildList_PSAPI
  else
    Result:=BuildList_ToolHelp32;
end;

function TProcesses.TerminateProcess(PID: DWORD;
  Timeout: Integer): Boolean;
var
  ProcessHandle: THandle;

  function EnumWindowsProc(Wnd: HWND; ProcessID: DWORD): Boolean; stdcall;
  var
    PID: DWORD;
  begin
    GetWindowThreadProcessId(Wnd,@PID);
    if ProcessID=PID then
      PostMessage(Wnd,WM_CLOSE,0,0);
    Result:=True;
  end;

begin
  Result:=False;
  if PID<>GetCurrentProcessId then begin
    ProcessHandle:=OpenProcess(SYNCHRONIZE or PROCESS_TERMINATE,False,PID);
    try
      if ProcessHandle<>0 then begin
        EnumWindows(@EnumWindowsProc,PID);
        if WaitForSingleObject(ProcessHandle,Timeout)=WAIT_OBJECT_0 then
          Result:=True //Clean
        else
          if TerminateProcess(ProcessHandle,0) then
            Result:=True; //Kill
      end;
    finally
      CloseHandle(ProcessHandle);
    end;
  end;
end;

procedure TProcesses.SetProcessCount(const Value: integer);
begin

end;

procedure TProcesses.ClearList;
{var
  p :PDWORD;}
begin
  while FProcessList.count>0 do begin
   FProcessList.Objects[FProcessList.count-1];
   FProcessList.Delete(FProcessList.count-1);
  end;
end;

initialization
  if GetOS=osNT4 then
    InitPSAPI;
finalization
  if GetOS=osNT4 then
    FreePSAPI;
end.
