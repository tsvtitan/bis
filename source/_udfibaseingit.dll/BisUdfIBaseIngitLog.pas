unit BisUdfIBaseIngitLog;

interface

uses Classes;

type
  TBisUdfIBaseIngitLogType=(ltInformation,ltWarning,ltError);
  
type

  TBisUdfIBaseIngitLog=class(TComponent)
  private
    FFileStream: TFileStream;
    FIsInit: Boolean;
    FClearOnInit: Boolean;
    FFileName: string;
    FActive: Boolean;
  protected
    function GetIsInit: Boolean;
    function GetClearOnInit: Boolean;
    procedure SetClearOnInit(Value: Boolean);
    function GetFileName: String;

    property IsInit: Boolean read GetIsInit;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init(const FileName: String); virtual;
    procedure Done; virtual; 
    function Write(const Message: String; LogType: TBisUdfIBaseIngitLogType=ltInformation): Boolean;
    function WriteInfo(const Message: String): Boolean;
    function WriteError(const Message: String): Boolean;
    function WriteWarn(const Message: String): Boolean;

    procedure Clear; 

    property Active: Boolean read FActive write FActive; 
  end;

implementation

uses SysUtils;

{ TBisUdfIBaseIngitLog }

constructor TBisUdfIBaseIngitLog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFileStream:=nil;
  FActive:=true;
end;

destructor TBisUdfIBaseIngitLog.Destroy;
begin
  Done;
  inherited Destroy;
end;

procedure TBisUdfIBaseIngitLog.Init(const FileName: String); 
begin
  if not FIsInit and not Assigned(FFileStream) then begin
    FFileName:=FileName;
    try
      if not FileExists(FileName) or FClearOnInit then begin
        FFileStream:=TFileStream.Create(FileName,fmCreate);
        FreeAndNil(FFileStream);
      end;

      FFileStream:=TFileStream.Create(FileName,fmOpenWrite or fmShareDenyNone);
      FFileStream.Position:=FFileStream.Size;
      FIsInit:=true;
    except
    end;  
  end;
end;

procedure TBisUdfIBaseIngitLog.Done; 
begin
  if Assigned(FFileStream) then begin
    FreeAndNil(FFileStream);
    FIsInit:=false;
  end;  
end;

function TBisUdfIBaseIngitLog.Write(const Message: String; LogType: TBisUdfIBaseIngitLogType): Boolean; 
var
  Buffer: String;
  S: string;
const
  SUnknown='U';
  SInformation='I';
  SWarning='W';
  SError='E';
  SFormatMessage='%s [%s]: %s';
  SFormatDateTime='dd.mm.yy hh:nn:ss.zzz';
  SReturn=#13#10;
begin
  Result:=false;
  S:=SUnknown;
  case LogType of
    ltInformation: S:=SInformation;
    ltWarning: S:=SWarning;
    ltError: S:=SError;
  end;
  Buffer:=Format(SFormatMessage,[FormatDateTime(SFormatDateTime,Now),S,Message]);
  if Assigned(FFileStream) then begin
    Buffer:=Buffer+SReturn;
    FFileStream.Write(Pointer(Buffer)^,Length(Buffer));
  end;
end;

function TBisUdfIBaseIngitLog.WriteInfo(const Message: String): Boolean;
begin
  Result:=Write(Message,ltInformation);
end;

function TBisUdfIBaseIngitLog.WriteError(const Message: String): Boolean;
begin
  Result:=Write(Message,ltError);
end;

function TBisUdfIBaseIngitLog.WriteWarn(const Message: String): Boolean;
begin
  Result:=Write(Message,ltWarning);
end;

function TBisUdfIBaseIngitLog.GetIsInit: Boolean; 
begin
  Result:=FIsInit;
end;

function TBisUdfIBaseIngitLog.GetClearOnInit: Boolean; 
begin
  Result:=FClearOnInit;
end;

procedure TBisUdfIBaseIngitLog.SetClearOnInit(Value: Boolean); 
begin
  FClearOnInit:=Value;
end;

procedure TBisUdfIBaseIngitLog.Clear; 
var
  Old: Boolean;
begin
  FActive:=true;
  Old:=FClearOnInit;
  try
    Done;
    FClearOnInit:=true;
    Init(FFileName);
  finally
    FClearOnInit:=Old;
    FActive:=true;
  end;
end;

function TBisUdfIBaseIngitLog.GetFileName: String;
begin
  Result:=FFileName;
end;

end.
