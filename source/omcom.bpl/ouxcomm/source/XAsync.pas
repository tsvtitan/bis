unit XAsync;

(**************************************************************************
 *     This unit is part of XComDrv.                                      *
 *                                                                        *
 *     Asynchronous I/O device operations                                 *
 *     Version 2.0                                                        *
 **************************************************************************)

{$H+,R-,B-}

interface

uses
  Windows, SysUtils;

resourcestring
  SHInvalidHandle = 'Invalid HASYNC handle value.';

type
  HASYNC = type THandle;
  TAsyncProc = procedure (Success: Boolean; Data: Pointer; Count: Longint) of object;
  TWaitProc = function: Boolean of object;

  EAsyncError = class(Exception);

function IsHandleValid(Handle: HASYNC): Boolean;
function IsAsyncDone(Handle: HASYNC): Boolean;
function InternalInitAsync(Handle: THandle; AsyncProc: TAsyncProc;
  AutoClose: Boolean): HASYNC;
function InternalCloseAsync(Handle: HASYNC): Boolean;
function InternalReadAsync(Handle: HASYNC; var Data; Count: DWORD;
  const SynThread: Boolean = True): DWORD;
function InternalReadStringAsync(Handle: HASYNC; var Data: string;
  const SynThread: Boolean = True): DWORD;
function InternalWriteAsync(Handle: HASYNC; const Data; Count: DWORD;
  const SynThread: Boolean = True): DWORD;
function InternalWaitAsync(Handle: HASYNC; Process: TWaitProc): Boolean;

function WriteComm(Handle: THandle; const Data: string): Integer; overload;
function WriteComm(Handle: THandle; const Data; const Size: Integer): Integer; overload;
function ReadComm(Handle: THandle; var Data: string): Integer; overload;
function ReadComm(Handle: THandle; var Data; const Size: Integer): Integer; overload;
function SetRXTime(Handle: THandle; const TimeOut, m: DWORD): Boolean;

implementation

uses
  Forms, Classes;

type
  TAsyncOptions = set of (asDone, asSuccess, asFree, asString, asSynchronize);
  PAsync = ^TAsync;
  TAsync = record
    ADeviceHandle: THandle;  //Handle to device
    AHandle: THandle; //Internal handle
    ABuffer: Pointer;
    ACount: DWORD;
    AOverlapped: TOverlapped;
    AAsyncProc: TAsyncProc;
    AOptions: TAsyncOptions;
  end;

  TAsyncThread = class(TThread)
  private
    FAsync: PAsync;
  protected
    procedure DoAsyncProc;
    procedure Execute; override;
  public
    constructor Create(Handle: HASYNC); virtual;
  end;

{TAsyncThread}
constructor TAsyncThread.Create(Handle: HASYNC);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FAsync := PAsync(Handle);
  Exclude(FAsync^.AOptions, asDone);
end;

procedure TAsyncThread.DoAsyncProc;
begin
  with FAsync^ do
    AAsyncProc(asSuccess in AOptions, ABuffer, ACount);
end;

procedure TAsyncThread.Execute;
var
  nCount: DWORD;
  PStr: PString;
begin
  with FAsync^ do
  begin
    WaitForSingleObject(AOverlapped.hEvent, INFINITE);
    if GetOverlappedResult(ADeviceHandle, AOverlapped, nCount, False) then
      Include(AOptions, asSuccess);
    ACount := nCount;
    if asString in AOptions then
    begin
      PStr := ABuffer;
      SetLength(PStr^, ACount);
    end;
    CloseHandle(AOverlapped.hEvent);
    if Assigned(AAsyncProc) then
    begin
      if asSynchronize in AOptions
        then Synchronize(DoAsyncProc)
        else DoAsyncProc;
    end;
    Include(AOptions, asDone);
    if asFree in AOptions then InternalCloseAsync(THandle(FAsync));
  end;
end;

{Internal}
function InitOverlapped: TOverlapped;
begin
  FillChar(Result, SizeOf(Result), 0);
  Result.hEvent := CreateEvent(nil, True, True, nil);
end;

procedure InternalStartThread(Handle: HASYNC);
var AT: TAsyncThread;
begin
  AT := TAsyncThread.Create(Handle);
  AT.Resume;
end;

function IsHandleValid(Handle: HASYNC): Boolean;
begin
  try
    Result := (Handle<>0) and (PAsync(Handle)^.AHandle=$FFFFFFFF-Handle);
  except
    Result := False;
  end;
end;

function IsAsyncDone(Handle: HASYNC): Boolean;
begin
  Result := not IsHandleValid(Handle) or (asDone in PAsync(Handle)^.AOptions);
end;

procedure InternalCheckHandle(Handle: HASYNC);
begin
  if not IsHandleValid(Handle) then raise EAsyncError.Create(SHInvalidHandle);
end;

function InternalInitAsync(Handle: THandle; AsyncProc: TAsyncProc;
  AutoClose: Boolean): HASYNC;
var P: ^TAsync;
begin
  GetMem(P, SizeOf(TAsync));
  try
    Result := THandle(P);  
    P^.ADeviceHandle := Handle;
    P^.AAsyncProc := AsyncProc;
    with P^ do
    begin
      ABuffer := nil;
      ACount := 0;
      AHandle := $FFFFFFFF-Result;
      AOptions := [asDone];
      if AutoClose then Include(AOptions, asFree);
    end;
  except
    FreeMem(P, SizeOf(TAsync));
    raise;
  end;
end;

function InternalCloseAsync(Handle: HASYNC): Boolean;
var P: PAsync;
begin
  InternalCheckHandle(Handle);
  P := PAsync(Handle);
  Result := (asDone in P^.AOptions);
  if Result then
  try
    P^.AHandle := 0;
  finally
    FreeMem(P, SizeOf(TAsync));
  end;
end;

function InternalReadStringAsync(Handle: HASYNC; var Data: string;
  const SynThread: Boolean = True): DWORD;
var
  ComStat: TComStat;
  P: PAsync;
begin
  InternalCheckHandle(Handle);
  P := PAsync(Handle);
  with P^ do
  begin
    AOverlapped := InitOverlapped;
    Include(AOptions, asString);
    ABuffer := @Data;
    if SynThread then Include(AOptions, asSynchronize);
    if ClearCommError(ADeviceHandle, Result, @ComStat) then
      SetLength(Data, ComStat.cbInQue)
    else
      ComStat.cbInQue := 0;
    ReadFile(ADeviceHandle, Data[1], ComStat.cbInQue, Result, @AOverlapped);
  end;
  InternalStartThread(Handle);
end;

function InternalReadAsync(Handle: HASYNC; var Data; Count: DWORD;
  const SynThread: Boolean = True): DWORD;
var P: PAsync;
begin
  InternalCheckHandle(Handle);
  P := PAsync(Handle);
  with P^ do
  begin
    ABuffer := @Data;
    if SynThread then Include(AOptions, asSynchronize);
    AOverlapped := InitOverlapped;
    ReadFile(ADeviceHandle, Data, Count, Result, @AOverlapped);
  end;
  InternalStartThread(Handle);
end;

function InternalWriteAsync(Handle: HASYNC; const Data; Count: DWORD;
  const SynThread: Boolean = True): DWORD;
var P: PAsync;
begin
  InternalCheckHandle(Handle);
  P := PAsync(Handle);
  with P^ do
  begin
    AOverlapped := InitOverlapped;
    if SynThread then Include(AOptions, asSynchronize);
    WriteFile(ADeviceHandle, Data, Count, Result, @AOverlapped);
  end;
  InternalStartThread(Handle);
end;

function InternalWaitAsync(Handle: HASYNC; Process: TWaitProc): Boolean;
begin
  InternalCheckHandle(Handle);
  with PAsync(Handle)^ do
  begin
    Result := asFree in AOptions;
    Exclude(AOptions, asFree);
    while not (asDone in AOptions) do
    begin
      Application.ProcessMessages;
      if Assigned(Process) and Process then
      begin
        if Result then Include(AOptions, asFree);
        Result := False;
        Break;
      end;
    end;
  end;
  if Result then
    InternalCloseAsync(Handle)
  else
    Result := asDone in PAsync(Handle)^.AOptions;
end;

function WriteComm(Handle: THandle; const Data: string): Integer;
var
  Ovl: TOverlapped;
  n: Cardinal;
begin
  Result := -1;
  Ovl := InitOverlapped;
  WriteFile(Handle, Data[1], Length(Data), n, @Ovl);
  WaitForSingleObject(Ovl.hEvent, INFINITE);
  if GetOverlappedResult(Handle, Ovl, n, False) then
    Result := n;
  CloseHandle(Ovl.hEvent);
end;

function WriteComm(Handle: THandle; const Data; const Size: Integer): Integer;
var
  Ovl: TOverlapped;
  n: Cardinal;
begin
  Result := -1;
  Ovl := InitOverlapped;
  WriteFile(Handle, Data, Size, n, @Ovl);
  WaitForSingleObject(Ovl.hEvent, INFINITE);
  if GetOverlappedResult(Handle, Ovl, n, False) then
    Result := n;
  CloseHandle(Ovl.hEvent);
end;

function ReadComm(Handle: THandle; var Data: string): Integer;
var
  Ovl: TOverlapped;
  n: Cardinal;
begin
  Result := -1;
  if (Length(Data)<0) then Exit;
  Ovl := InitOverlapped;
  ReadFile(Handle, Data[1], Length(Data), n, @Ovl);
  WaitForSingleObject(Ovl.hEvent, INFINITE);
  if GetOverlappedResult(Handle, Ovl, n, False) then
    Result := n;
  CloseHandle(Ovl.hEvent);
end;

function ReadComm(Handle: THandle; var Data; const Size: Integer): Integer;
var
  Ovl: TOverlapped;
  n: Cardinal;
begin
  Result := -1;
  Ovl := InitOverlapped;
  ReadFile(Handle, Data, Size, n, @Ovl);
  WaitForSingleObject(Ovl.hEvent, INFINITE);
  if GetOverlappedResult(Handle, Ovl, n, False) then
    Result := n;
  CloseHandle(Ovl.hEvent);
end;

function SetRXTime(Handle: THandle; const TimeOut, m: DWORD): Boolean;
var tm: TCommTimeouts;
begin
  Result := False;
  if GetCommTimeouts(Handle, tm) then
  begin
    tm.ReadIntervalTimeout := TimeOut;
    tm.ReadTotalTimeoutMultiplier := m;
    Result := SetCommTimeouts(Handle, tm);
  end;
end;

end.