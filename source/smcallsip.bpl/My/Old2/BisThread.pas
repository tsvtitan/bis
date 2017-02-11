unit BisThread;

interface

uses Classes;

type
  TBisThread=class(TThread)
  private
    FName: String;
  public
    constructor Create; virtual;
    procedure Execute; override;

    property Name: String read FName write FName;
  end;

implementation

uses Windows, SysUtils{,
     {BisCore};


procedure SetThreadName(AName: String);
type
  TThreadNameInfo = record
    RecType: LongWord;  // Must be 0x1000
    Name: PChar;        // Pointer to name (in user address space)
    ThreadID: LongWord; // Thread ID (-1 indicates caller thread)
    Flags: LongWord;    // Reserved for future use. Must be zero
  end;
var
  LThreadNameInfo: TThreadNameInfo;
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
      RaiseException($406D1388, 0, SizeOf(LThreadNameInfo) div SizeOf(LongWord),PDWord(@LThreadNameInfo));
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

procedure TBisThread.Execute;
begin
  SetThreadName(FName);
{  if Assigned(Core) and Assigned(Core.ExceptNotifier) then begin
    with Core.ExceptNotifier do begin
      IngnoreExceptions.Add(Exception);
      try
        SetThreadName(FName);
      finally
        IngnoreExceptions.Remove(Exception);
      end;
    end;
  end;}
end;

initialization
  SetThreadName('Main');
  
end.
