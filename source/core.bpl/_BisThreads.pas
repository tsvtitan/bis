unit BisThreads;

interface

uses Classes, SysUtils, SyncObjs;

const
  ThreadNameAddress=$406D1388;

type
  TBisThreadNameInfo = record
    RecType: LongWord;  // Must be 0x1000
    Name: PChar;        // Pointer to name (in user address space)
    ThreadID: LongWord; // Thread ID (-1 indicates caller thread)
    Flags: LongWord;    // Reserved for future use. Must be zero
  end;
  PBisThreadNameInfo=^TBisThreadNameInfo;

  TBisThread=class;
  
  TBisThreadEvent=procedure(Thread: TBisThread) of object;

  TBisThread=class(TThread)
  private
    FName: String;
    FOnTerminate: TBisThreadEvent;
    procedure SetName(const Value: String);
    function GetTerminated: Boolean;
  protected
    procedure DoTerminate; override;
    procedure Execute; override;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Terminate; virtual;
    procedure CleanUp; virtual;

    function Exists: Boolean;
    procedure Synchronize(AMethod: TThreadMethod);
    procedure Queue(AMethod: TThreadMethod);

    property Terminated: Boolean read GetTerminated;

    property Name: String read FName write SetName;
    
    property OnTerminate: TBisThreadEvent read FOnTerminate write FOnTerminate;
  end;

  TBisWaitThread=class;

  TBisWaitThreadEvent=procedure(Thread: TBisWaitThread) of object;

  TBisWaitThread=class(TBisThread)
  private
    FEvent: TEvent;
    FTimeout: Cardinal;
    FOnTimeout: TBisWaitThreadEvent;
  protected
    procedure Execute; override;
    procedure DoTimeout; virtual;
  public
    constructor Create(const Timeout: Cardinal); reintroduce;
    destructor Destroy; override;
    procedure Terminate; override;
    procedure CleanUp; override;

    property OnTimeout: TBisWaitThreadEvent read FOnTimeout write FOnTimeout;
  end;

  TBisWorkThread=class;

  TBisWorkThreadEvent=procedure(Sender: TBisWorkThread) of object;
  TBisWorkThreadEndEvent=procedure(Sender: TBisWorkThread; E: Exception=nil) of object;
  TBisWorkThreadTimeoutEvent=procedure(Sender: TBisWorkThread; var Forced: Boolean) of object;

  TBisWorkThread=class(TBisThread)
  private
    FWorking: Boolean;
    FDestroying: Boolean;
    FDestroyed: Boolean;
    FForced: Boolean;
    FWaitThread: TBisWaitThread;
    FOnWorkBegin: TBisWorkThreadEvent;
    FOnWorkEnd: TBisWorkThreadEndEvent;
    FOnWork: TBisWorkThreadEvent;
    FOnTimeout: TBisWorkThreadTimeoutEvent;
    FTimeout: Cardinal;
    FWorkPeriod: Int64;
    procedure WaitThreadTerminate(Thread: TBisThread);
    procedure WaitThreadTimeout(Thread: TBisWaitThread);
    procedure WaitThreadCleanUp;
    procedure WaitThreadInit;
  protected
    procedure DoTerminate; override;
    procedure Execute; override;
    procedure DoWorkBegin; virtual;
    procedure DoWorkEnd(E: Exception); virtual;
    procedure DoWork; virtual;
    procedure DoTimeout(var Forced: Boolean); virtual;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Terminate; override;
    procedure CleanUp; override;

    property Working: Boolean read FWorking;
    property WorkPeriod: Int64 read FWorkPeriod;

    property Timeout: Cardinal read FTimeout write FTimeout;

    property OnWorkBegin: TBisWorkThreadEvent read FOnWorkBegin write FOnWorkBegin;
    property OnWorkEnd: TBisWorkThreadEndEvent read FOnWorkEnd write FOnWorkEnd;
    property OnWork: TBisWorkThreadEvent read FOnWork write FOnWork;
    property OnTimeout: TBisWorkThreadTimeoutEvent read FOnTimeout write FOnTimeout;
  end;

procedure SetThreadName(AName: String);

implementation

uses Windows,
     BisUtils;

var
  FThreads: TThreadList=nil;

procedure ClearThreads;
var
  i: Integer;
  Item: TBisThread;
  List: TList;
begin
  if Assigned(FThreads) then begin
    List:=FThreads.LockList;
    try
      for i:=List.Count-1 downto 0 do begin
        Item:=TBisThread(List.Items[i]);
        if Item.Exists then
          TerminateThread(Item.Handle,0);
        Item.Free;  
        List.Remove(Item);
      end;
    finally
      FThreads.UnlockList;
    end;
  end;
end;
  
procedure SetThreadName(AName: String);
var
  LThreadNameInfo: TBisThreadNameInfo;
begin
  if Trim(AName)<>'' then begin
    with LThreadNameInfo do begin
      RecType := $1000;
      Name := PChar(AName);
      ThreadID := $FFFFFFFF;
      Flags := 0;
    end;
    try
      // This is a wierdo Windows way to pass the info in
      RaiseException(ThreadNameAddress, 0, SizeOf(LThreadNameInfo) div SizeOf(LongWord),PDWord(@LThreadNameInfo));
    except
      //
    end;
  end;
end;

{ TBisThread }

constructor TBisThread.Create;
begin
  inherited Create(true);
  FName:=Copy(ClassName,5,Length(ClassName)-4-Length('Thread'));
  FThreads.Add(Self);
end;

destructor TBisThread.Destroy;
begin
  FThreads.Remove(Self);
  inherited Destroy;
end;

procedure TBisThread.DoTerminate;
begin
  if Assigned(FOnTerminate) then
    FOnTerminate(Self);
end;

procedure TBisThread.Execute;
begin
  SetThreadName(FName);
end;

procedure TBisThread.SetName(const Value: String);
begin
  FName := Value;
  if ThreadID=GetCurrentThreadId then
    SetThreadName(FName);
end;

procedure TBisThread.Terminate;
begin
  inherited Terminate;
end;

procedure TBisThread.CleanUp;
begin
  OnTerminate:=nil;
end;

function TBisThread.Exists: Boolean;
var
  Ret: DWord;
begin
  Ret:=WaitForSingleObject(Handle,0);
  Result:=Ret=WAIT_TIMEOUT;
end;

function TBisThread.GetTerminated: Boolean;
begin
  Result:=inherited Terminated;
end;

procedure TBisThread.Queue(AMethod: TThreadMethod);
begin
  inherited Queue(AMethod);
end;

procedure TBisThread.Synchronize(AMethod: TThreadMethod);
begin
  inherited Synchronize(AMethod);
end;

{ TBisWaitThread }

constructor TBisWaitThread.Create(const Timeout: Cardinal);
begin
  inherited Create;
  FreeOnTerminate:=true;
  FTimeout:=Timeout;
  FEvent:=TEvent.Create(nil,false,false,'');
end;

destructor TBisWaitThread.Destroy;
begin
  FEvent.SetEvent;
  FreeAndNil(FEvent);
  inherited Destroy;
end;

procedure TBisWaitThread.DoTimeout;
begin
  if Assigned(FOnTimeout) then
    FOnTimeout(Self);
end;

procedure TBisWaitThread.Execute;
var
  Ret: TWaitResult;
begin
  inherited Execute;
  FEvent.ResetEvent;
  Ret:=FEvent.WaitFor(FTimeout);
  if (Ret=wrTimeout) then
    DoTimeout;
end;

procedure TBisWaitThread.Terminate;
begin
  inherited Terminate;
  if Assigned(FEvent) then
    FEvent.SetEvent;
end;

procedure TBisWaitThread.CleanUp;
begin
  inherited CleanUp;
  FOnTimeout:=nil;
end;

type
  TBisWaitWorkThread=class(TBisWaitThread)
  private
    FWork: TBisWorkThread;
    procedure WorkTimeout;
  protected
    procedure DoTimeout; override;
  public
    procedure CleanUp; override;
  end;

{ TBisWaitWorkThread }

procedure TBisWaitWorkThread.CleanUp;
begin
  inherited CleanUp;
  FWork:=nil;
end;

procedure TBisWaitWorkThread.WorkTimeout;
begin
  inherited DoTimeout;
end;

procedure TBisWaitWorkThread.DoTimeout;
begin
  if Assigned(FWork) then
    WorkTimeout;
  //  Queue(FWork,WorkTimeout);
end;

{ TBisWorkThread }

constructor TBisWorkThread.Create;
begin
  inherited Create;
  FTimeout:=0;
end;

destructor TBisWorkThread.Destroy;
begin
  FDestroying:=true;
//  WaitThreadInit;
  inherited Destroy;
  FDestroyed:=true;
end;

procedure TBisWorkThread.CleanUp;
begin
  inherited CleanUp;
  FOnWorkBegin:=nil;
  FOnWorkEnd:=nil;
  FOnWork:=nil;
  FOnTerminate:=nil;
end;

procedure TBisWorkThread.DoWorkBegin;
begin
  if Assigned(FOnWorkBegin) then
    FOnWorkBegin(Self);
end;

procedure TBisWorkThread.DoWork;
begin
  if Assigned(FOnWork) then
    FOnWork(Self);
end;

procedure TBisWorkThread.DoWorkEnd(E: Exception);
begin
  if Assigned(FOnWorkEnd) then
    FOnWorkEnd(Self,E);
end;

procedure TBisWorkThread.DoTimeout(var Forced: Boolean);
begin
  if Assigned(FOnTimeout) then
    FOnTimeout(Self,Forced);
end;

procedure TBisWorkThread.DoTerminate;
begin
  if not FForced then
    WaitThreadCleanUp;
  inherited DoTerminate;
end;

procedure TBisWorkThread.Execute;
var
  Tick, Freq: Int64;
begin
  inherited Execute;

  FWorkPeriod:=0;
  FWorking:=true;
  try
    try

      DoWorkBegin;

      Tick:=GetTickCount(Freq);
      try
        DoWork;
      finally
        FWorkPeriod:=GetTickDifference(Tick,Freq,dtMilliSec);
      end;

      DoWorkEnd(nil);
    except
      On E: Exception do
        DoWorkEnd(E);
    end;
  finally
    FWorking:=false;
  end;
end;

procedure TBisWorkThread.WaitThreadTerminate(Thread: TBisThread);
begin
  if Assigned(FWaitThread) then
    FWaitThread.CleanUp;
  FWaitThread:=nil;
end;

procedure TBisWorkThread.WaitThreadCleanUp;
begin
  if Assigned(FWaitThread) then begin
    FWaitThread.CleanUp;
    if GetCurrentThreadId=ThreadID then begin
      FWaitThread.FreeOnTerminate:=false;
      FWaitThread.Free;
    end else
      FWaitThread.Terminate;

    FWaitThread:=nil;
  end;
end;

procedure TBisWorkThread.WaitThreadTimeout(Thread: TBisWaitThread);
var
  Flag: Boolean;
begin
  if FWorking and Exists and not FDestroyed then begin
    Flag:=false;
    DoTimeout(Flag);
    if Flag then begin
      TerminateThread(Handle,0);
      FForced:=True;
      DoTerminate;
      FWorking:=false;
      if not FDestroying and FreeOnTerminate and Assigned(Self) then
        Self.Free;
    end;
  end;
end;

procedure TBisWorkThread.WaitThreadInit;
begin
  WaitThreadCleanUp;
  if FWorking and Exists and (FTimeout>0) then begin
     
    FWaitThread:=TBisWaitWorkThread.Create(FTimeout);
    FWaitThread.FreeOnTerminate:=true;
    FWaitThread.OnTerminate:=WaitThreadTerminate;
    FWaitThread.OnTimeout:=WaitThreadTimeout;
    TBisWaitWorkThread(FWaitThread).FWork:=Self;
    FWaitThread.Resume;
  end;
end;

procedure TBisWorkThread.Terminate;
var
  OldTerminated: Boolean;
begin
  OldTerminated:=Terminated;
  inherited Terminate;
  if not OldTerminated and Terminated then
    WaitThreadInit;
end;

initialization
  SetThreadName('Main');
  FThreads:=TThreadList.Create;

finalization
  ClearThreads;
  FreeAndNil(FThreads);


end.
