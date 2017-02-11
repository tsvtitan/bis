unit BisLoaderUpdate;

interface

function UpdateFiles(CommandLine: String; FileName: String): Boolean;

implementation

uses Windows, SysUtils, Classes, ActiveX,
     BisUpdateMapFile;

var
  FProcessHandle: THandle;

function PrepareClassID(S: string): string;
begin
  Result:=Copy(s, 26, 12)+Copy(s, 21, 4)+Copy(s, 16, 4)+Copy(s, 11, 4)+Copy(s, 2, 8);
end;

function CreateClassID: string;
var
  ClassID: TCLSID;
  P: PWideChar;
begin
  CoCreateGuid(ClassID);
  StringFromCLSID(ClassID, P);
  Result := P;
  CoTaskMemFree(P);
end;

function GetUniqueID: String;
var
  s: string;
begin
  s:=Copy(CreateClassID, 1, 37);
  Result:=PrepareClassID(s);
end;

function CreateUpdateProcess(FileName, MapName: String): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  S: String;
begin
  FillChar(StartupInfo,SizeOf(TStartupInfo),0);
  with StartupInfo do begin
    cb:=SizeOf(TStartupInfo);
    wShowWindow:=SW_SHOWDEFAULT;
  end;
  S:=Format('%s %s',[FileName,MapName]);
  Result:=CreateProcess(nil,PChar(S),nil,nil,False,
                        NORMAL_PRIORITY_CLASS,nil,nil,StartupInfo,ProcessInfo);
  if Result then
    FProcessHandle:=ProcessInfo.hProcess;
end;

function CheckUpdateProcess: Boolean;
var
  Ret: DWord;
begin
  Ret:=WaitForSingleObject(FProcessHandle,1000);
  Result:=Ret=WAIT_TIMEOUT;
end;

function UpdateFiles(CommandLine: String; FileName: String): Boolean;
var
  Ret: DWord;
  MapName: String;
  MutexName: String;
  MapFile: TBisUpdateMapFile;
  Flag: Boolean;
  UpdateType: TBisUpdateType;
begin
  Result:=false;
  MapFile:=TBisUpdateMapFile.Create(nil);
  try
    MapName:=GetUniqueID;
    MapFile.CreateMapFile(MapName);
    if MapFile.Exists then begin
      MapFile.WriteCommandLine(CommandLine);
      MutexName:=GetUniqueID;
      CreateMutex(nil,false,PChar(MutexName));
      Ret:=GetLastError;
      if Ret<>ERROR_ALREADY_EXISTS then begin
        MapFile.WriteMutexName(MutexName);
        if CreateUpdateProcess(FileName,MapName) then begin
          Flag:=false;
          while not Flag do begin
            UpdateType:=MapFile.ReadUpdateType;
            case UpdateType of
              utUnknown: Flag:=not CheckUpdateProcess;
              //utError: Flag:=true;
              utError, utSuccess: begin
                Flag:=true;
                Result:=true;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    MapFile.Free;
  end;
end;

end.