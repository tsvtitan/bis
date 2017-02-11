unit BisThread;

interface

uses Classes;

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

  TBisThread=class(TThread)
  private
    FName: String;
    function GetTerminated: Boolean;
    procedure SetName(const Value: String);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Execute; override;
    function Exists: Boolean;

    property Name: String read FName write SetName;

    property Terminated: Boolean read GetTerminated;
  end;

procedure SetThreadName(AName: String);
  
implementation

uses Windows, SysUtils;


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
end;

destructor TBisThread.Destroy;
begin
  TerminateThread(Handle,0);
  inherited Destroy;
end;

procedure TBisThread.Execute;
begin
  SetThreadName(FName);
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

procedure TBisThread.SetName(const Value: String);
begin
  FName := Value;
  SetThreadName(FName);
end;

{initialization
  SetThreadName('Main'); }
  
end.
