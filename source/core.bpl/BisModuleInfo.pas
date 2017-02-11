unit BisModuleInfo;

interface

uses Classes, 
     BisVersionInfo, BisCrypter;

type

  TBisModuleInfo=class(TBisVersionInfo)
  private
    FFileSize: Integer;
    FFileHash: String;
    FModules: TStringList;
    function GetFileSize: Integer;
    function GetFileHash: String;
  public
    constructor Create(const AFileName: string); override;
    destructor Destroy; override;
    procedure GetModules;
    procedure Report(Strings: TStringList);

    property FileVersion: String read GetFileVersion;
    property ProductVersion: String read GetProductVersion;
    property FileSize: Integer read FFileSize;
    property FileHash: String read FFileHash;
    property Modules: TStringList read FModules;
  end;

function GetProductVersion(const FileName: String): String;

implementation

uses Windows, SysUtils, psapi;

function GetProductVersion(const FileName: String): String;
var
  MI: TBisModuleInfo;
begin
  Result:='';
  if FileExists(FileName) then begin
    MI:=TBisModuleInfo.Create(FileName);
    try
      Result:=MI.ProductVersion;
    finally
      MI.Free;
    end;
  end;
end;

{ TBisModuleInfo }

constructor TBisModuleInfo.Create(const AFileName: string);
begin
  inherited Create(AFileName);
  FFileSize:=GetFileSize;
  FFileHash:=GetFileHash;
  FModules:=TStringList.Create;
end;

destructor TBisModuleInfo.Destroy;
begin
  FModules.Free;
  inherited Destroy;
end;

function TBisModuleInfo.GetFileSize: Integer;
var
  H: THandle;
begin
  H:=FileOpen(FileName,fmOpenRead or fmShareDenyNone);
  try
    Result:=Windows.GetFileSize(H,nil);
  finally
    FileClose(H);
  end;
end;

function TBisModuleInfo.GetFileHash: String;
var
  Crypter: TBisCrypter;
begin
  Crypter:=TBisCrypter.Create;
  try
    Result:=Crypter.HashFile(FileName,haMD5,hfHEX);
  finally
    Crypter.Free;
  end;
end;

procedure TBisModuleInfo.GetModules;

  procedure GetModulesNT;
  var
    ProcID: Integer;
    I: Integer;
    ProcHand: THandle;
    ModHandles: array[0..$3FFF - 1] of DWORD;
    ModInfo: TModuleInfo;
    ModName: array[0..MAX_PATH] of char;
    Count: DWord;
  begin
    ProcId:=GetCurrentProcessId;
    ProcHand:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,False,ProcID);
    if ProcHand<>0 then begin
      try
        EnumProcessModules(ProcHand,@ModHandles,SizeOf(ModHandles),Count);
        for I:=0 to (Count div SizeOf(DWORD))-1 do begin
          if (GetModuleFileNameEx(ProcHand,ModHandles[I],ModName,SizeOf(ModName))>0) and
              GetModuleInformation(ProcHand,ModHandles[I],@ModInfo,SizeOf(ModInfo)) then begin
            FModules.Add(ModName);
          end;
        end;
      finally
        CloseHandle(ProcHand);
      end;
    end;
  end;

begin
  FModules.Clear;
  case WindowsVersion of
    pvWindowsNT,pvWindows2000,pvWindowsXP,pvWindows2003: begin
      GetModulesNT;
    end;
  end;
end;

procedure TBisModuleInfo.Report(Strings: TStringList);
var
  MI: TBisModuleInfo;
  i: Integer;
  S: String;
begin
  try
    GetModules;
    Strings.Add(Format('Count modules=%d',[FModules.Count]));
    for i:=0 to FModules.Count-1 do begin
      S:=FModules.Strings[i];
      MI:=TBisModuleInfo.Create(S);
      try
        Strings.Add(Format('[%s]',[S]));
        Strings.Add(Format('Version=%s',[MI.FileVersion]));
        Strings.Add(Format('Size=%d',[MI.FileSize]));
        Strings.Add(Format('Hash=%s',[MI.FileHash]));
      finally
        MI.Free;
      end;
    end;
  except

  end;
end;

end.
