unit BisUpdateMapFile;

interface

uses Windows, Classes;

const
//   CommandLineLength=1025;
   CommandLineLength=256;
   MutexNameLength=32;

type
  TBisUpdateType=(utUnknown,utError,utSuccess);

  TBisUpdateInfo=record
    CommandLine: array[0..CommandLineLength-1] of char;
    UpdateType: TBisUpdateType;
    MutexName: array[0..MutexNameLength-1] of char;
  end;
  PBisUpdateInfo=^TBisUpdateInfo;

  TBisUpdateMapFile=class(TComponent)
  private
    FMapName: String;
    FMapHandle: THandle;
    FMapMemory: Pointer;
    procedure FreeMapFile;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Exists: Boolean;
    procedure CreateMapFile(const AMapName: String);
    procedure OpenMapFile(const AMapName: String);

    function ReadUpdateType: TBisUpdateType;
    procedure WriteUpdateType(AType: TBisUpdateType);
    function ReadCommandLine: String;
    procedure WriteCommandLine(CommandLine: String);
    function ReadMutexName: String;
    procedure WriteMutexName(MutexName: String);

    property MapName: String read FMapName;
  end;

implementation

uses SysUtils;

{ TBisUpdateMapFile }

constructor TBisUpdateMapFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMapHandle:=0;
  FMapMemory:=nil;
end;

destructor TBisUpdateMapFile.Destroy;
begin
  FreeMapFile;
  inherited Destroy;
end;

function TBisUpdateMapFile.Exists: Boolean;
begin
  Result:=(FMapHandle<>0) and Assigned(FMapMemory); 
end;

procedure TBisUpdateMapFile.FreeMapFile;
begin
  if Exists then begin
    UnmapViewOfFile(FMapMemory);
    FMapMemory:=nil;
    CloseHandle(FMapHandle);
    FMapHandle:=0;
  end;
end;

procedure TBisUpdateMapFile.CreateMapFile(const AMapName: String);
begin
  FreeMapFile;

  FMapHandle:=CreateFileMapping(MAXDWORD,nil,PAGE_READWRITE,0,SizeOf(TBisUpdateInfo),PChar(AMapName));
  if (FMapHandle=INVALID_HANDLE_VALUE) or (FMapHandle=0) then
    exit;

  FMapMemory:=MapViewOfFile(FMapHandle,FILE_MAP_ALL_ACCESS,0,0,0);
  if not Assigned(FMapMemory) then begin
    CloseHandle(FMapHandle);
    FMapHandle:=0;
    exit;
  end;

  FMapName:=AMapName;
end;

procedure TBisUpdateMapFile.OpenMapFile(const AMapName: String);
begin
  FreeMapFile;

  FMapHandle:=OpenFileMapping(FILE_MAP_ALL_ACCESS,false,PChar(AMapName));
  if (FMapHandle=INVALID_HANDLE_VALUE)or(FMapHandle=0) then
    exit;

  FMapMemory:=MapViewOfFile(FMapHandle,FILE_MAP_ALL_ACCESS,0,0,0);
  if not Assigned(FMapMemory) then begin
    CloseHandle(FMapHandle);
    exit;
  end;

  FMapName:=AMapName;
end;

function TBisUpdateMapFile.ReadCommandLine: String;
var
  Info: TBisUpdateInfo;
begin
  Result:='';
  if Exists then begin
    Move(FMapMemory^,Info,SizeOf(Info));
    Result:=Info.CommandLine;
  end;
end;

function TBisUpdateMapFile.ReadMutexName: String;
var
  Info: TBisUpdateInfo;
begin
  Result:='';
  if Exists then begin
    Move(FMapMemory^,Info,SizeOf(Info));
    Result:=Info.MutexName;
  end;
end;

function TBisUpdateMapFile.ReadUpdateType: TBisUpdateType;
var
  Info: TBisUpdateInfo;
begin
  Result:=utUnknown;
  if Exists then begin
    Move(FMapMemory^,Info,SizeOf(Info));
    Result:=Info.UpdateType;
  end;
end;

procedure TBisUpdateMapFile.WriteCommandLine(CommandLine: String);
var
  Info: TBisUpdateInfo;
begin
  if Exists then begin
    Move(FMapMemory^,Info,SizeOf(Info));
    StrCopy(Info.CommandLine,PChar(Copy(CommandLine,1,CommandLineLength)));
    Move(Info,FMapMemory^,SizeOf(Info));
  end;
end;

procedure TBisUpdateMapFile.WriteMutexName(MutexName: String);
var
  Info: TBisUpdateInfo;
begin
  if Exists then begin
    Move(FMapMemory^,Info,SizeOf(Info));
    StrCopy(Info.MutexName,PChar(Copy(MutexName,1,MutexNameLength)));
    Move(Info,FMapMemory^,SizeOf(Info));
  end;
end;

procedure TBisUpdateMapFile.WriteUpdateType(AType: TBisUpdateType);
var
  Info: TBisUpdateInfo;
begin
  if Exists then begin
    Move(FMapMemory^,Info,SizeOf(Info));
    Info.UpdateType:=AType;
    Move(Info,FMapMemory^,SizeOf(Info));
  end;
end;

end.
