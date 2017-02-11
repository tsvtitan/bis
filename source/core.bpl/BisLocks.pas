unit BisLocks;

interface

uses Windows, Classes, Contnrs, SyncObjs;

type

  TBisCritical=class(TCriticalSection)
  private
    FEvent: TEvent;
    FMissedPeriod: Cardinal;
    FName: String;
    FMaxTimeout: Cardinal;
    FSpinCount: Cardinal;
    procedure SetSpinCount(const Value: Cardinal);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function TryLock(const Timeout: Cardinal=0): Boolean;
    procedure Lock(const Timeout: Cardinal=0);
    procedure UnLock;

    property Section: TRTLCriticalSection read FSection;
    property MissedPeriod: Cardinal read FMissedPeriod;

    property Name: String read FName write FName;
    property MaxTimeout: Cardinal read FMaxTimeout write FMaxTimeout;
    property SpinCount: Cardinal read FSpinCount write SetSpinCount;
  end;

  TBisCriticals=class;

  TBisCriticalsRemoveEvent=procedure (Sender: TBisCriticals; Item: TObject) of object;

  TBisCriticals=class(TObjectList)
  private
    FCritical: TBisCritical;
    FOnItemRemove: TBisCriticalsRemoveEvent;
    FMaxCount: Integer;
    function GetEmpty: Boolean;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    procedure DoItemRemove(Item: TObject); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Add(Item: TObject): Boolean; virtual;

    function LockAdd(Item: TObject): Boolean;
    procedure LockRemove(Item: TObject);
    procedure LockClear;

    function TryLock(const Timeout: Cardinal=0): Boolean;
    procedure Lock(const Timeout: Cardinal=0);
    procedure UnLock;

    property Empty: Boolean read GetEmpty;
    property Critical: TBisCritical read FCritical;

    property MaxCount: Integer read FMaxCount write FMaxCount;
    property OnItemRemove: TBisCriticalsRemoveEvent read FOnItemRemove write FOnItemRemove;
  end;

  TBisLock=class(TBisCritical)
  end;

  TBisLocks=class(TBisCriticals)
  end;

type
  TBisLockStep=(lsLocking,lsLocked,lsUnlocking,lsUnlocked,lsLockFailed);
  TBisLockSteps=set of TBisLockStep;
  TBisLockProc=procedure (Critical: TBisCritical; Step: TBisLockStep);
  PBisLockProc=^TBisLockProc;

procedure AddLockProc(Proc: TBisLockProc);
procedure RemoveLockProc(Proc: TBisLockProc);

implementation

uses Sysutils,
     BisUtils, BisConsts;

var
  LockProcList: TThreadList=nil;

procedure AddLockProc(Proc: TBisLockProc);
var
  List: TList;
begin
  if Assigned(LockProcList) then begin
    List:=LockProcList.LockList;
    try
      if List.IndexOf(@Proc)=-1 then
        List.Add(@Proc);
    finally
      LockProcList.UnlockList;
    end;
  end;
end;

procedure RemoveLockProc(Proc: TBisLockProc);
begin
  if Assigned(LockProcList) then
    LockProcList.Remove(@Proc);
end;

procedure LockProcListCall(Critical: TBisCritical; Step: TBisLockStep);
var
  i: Integer;
  List: TList;
  Proc: TBisLockProc;
begin
  if Assigned(LockProcList) then begin
    List:=LockProcList.LockList;
    try
      for i:=0 to List.Count-1 do begin
        @Proc:=List.Items[i];
        if Assigned(@Proc) then
          Proc(Critical,Step);
      end;
    finally
      LockProcList.UnlockList;
    end;
  end;
end;

{function ItCanBeDeadlock(CriticalSection: TBisCriticalSection): Boolean;
begin
  Result:=false;
  if Assigned(CriticalSection) and Assigned(@CriticalSection.Section) then begin
    Result:=(CriticalSection.Section.RecursionCount>0) and
            (CriticalSection.Section.OwningThread<>GetCurrentThreadId);
  end;
end;}

{ TBisCritical }

constructor TBisCritical.Create;
begin
  inherited Create;
  FName:=GetUniqueID;
  FMaxTimeout:=300;
  FEvent:=TEvent.Create(nil,true,false,'');
  SpinCount:=4000;
end;

destructor TBisCritical.Destroy;
begin
  FEvent.SetEvent;
  FreeAndNilEx(FEvent);
  inherited Destroy;
end;

procedure TBisCritical.SetSpinCount(const Value: Cardinal);
begin
  if Value<>FSpinCount then begin
    SetCriticalSectionSpinCount(FSection,Value);
    FSpinCount:=Value;
  end;
end;

function TBisCritical.TryLock(const Timeout: Cardinal): Boolean;
var
  Ret: TWaitResult;
  MaxCount: Cardinal;
begin
  LockProcListCall(Self,lsLocking);
  FMissedPeriod:=0;
  Result:=TryEnter;
  if not Result then begin
    MaxCount:=iff(Timeout<>0,Timeout,FMaxTimeout);
    while Assigned(FEvent) and (FMissedPeriod<MaxCount)  do begin
      FEvent.ResetEvent;
      Ret:=FEvent.WaitFor(1);
      if (Ret in [wrTimeout]) then begin
        Result:=TryEnter;
        if Result then
          break
        else
          Inc(FMissedPeriod);
      end else
        break;
    end;
  end;
  if Result then
    LockProcListCall(Self,lsLocked)
  else
    LockProcListCall(Self,lsLockFailed);
end;

procedure TBisCritical.Lock(const Timeout: Cardinal);
begin
  if not TryLock(Timeout) then
    raise Exception.Create(SLockTimeout); 
end;

procedure TBisCritical.UnLock;
begin
  LockProcListCall(Self,lsUnlocking);
  Leave;
  LockProcListCall(Self,lsUnlocked);
end;

{ TBisCriticals }

constructor TBisCriticals.Create;
begin
  inherited Create;
  FCritical:=TBisCritical.Create;
  FMaxCount:=-1;
end;

destructor TBisCriticals.Destroy;
begin
  LockClear;
  FCritical.Free;
  inherited Destroy;
end;

procedure TBisCriticals.DoItemRemove(Item: TObject);
begin
  if Assigned(FOnItemRemove) then
    FOnItemRemove(Self,Item);
end;

function TBisCriticals.TryLock(const Timeout: Cardinal): Boolean;
begin
  Result:=FCritical.TryLock(Timeout);
end;

procedure TBisCriticals.Lock(const Timeout: Cardinal);
begin
  FCritical.Lock(Timeout);
end;

procedure TBisCriticals.UnLock;
begin
  FCritical.UnLock;
end;

procedure TBisCriticals.LockClear;
begin
  Lock;
  try
    Clear;
  finally
    UnLock;
  end;
end;

procedure TBisCriticals.LockRemove(Item: TObject);
begin
  Lock;
  try
    Remove(Item);
  finally
    UnLock;
  end;
end;

procedure TBisCriticals.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Action=lnDeleted then
    if Assigned(Ptr) then
      DoItemRemove(Ptr);
  inherited Notify(Ptr,Action);
end;

function TBisCriticals.Add(Item: TObject): Boolean;
begin

  if FMaxCount>-1 then
    if Count>0 then
      if (Count+1)>FMaxCount then
        Delete(0);

  Result:=inherited Add(Item)>-1;
end;

function TBisCriticals.LockAdd(Item: TObject): Boolean;
begin
  Lock;
  try
    Result:=Add(Item);
  finally
    UnLock;
  end;
end;

function TBisCriticals.GetEmpty: Boolean;
begin
  Result:=Count=0;
end;

initialization
  LockProcList:=TThreadList.Create;

finalization
  FreeAndNilEx(LockProcList);


end.
