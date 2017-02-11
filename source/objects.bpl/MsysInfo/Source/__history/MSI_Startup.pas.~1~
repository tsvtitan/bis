
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{           Startup Runs Detection Part                 }
{           version 5.6 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Startup;

interface

uses
  SysUtils, Windows, Classes;

type
  TRunType = (rtHKCU, rtHKLM, rtOnce, rtUser, rtCommon, rtWinINI);

  TStartup = class(TPersistent)
  private
    FHKCU_Runs: TStringList;
    FHKLM_Runs: TStringList;
    FOnce_Runs: TStringList;
    FUser_Runs: TStringList;
    FCommon_Runs: TStringList;
    FWININI_Runs: TStringList;

    function GetCommonRun(Index: integer): string;
    function GetHKCU(Index: integer): string;
    function GetHKLM(Index: integer): string;
    function GetRunOnce(Index: integer): string;
    function GetUserRun(Index: integer): string;
    function GetCount: integer;
    procedure SetCount(const Value: integer);
    function GetCommonCount: integer;
    function GetHKCUCount: integer;
    function GetHKLMCount: integer;
    function GetOnceCount: integer;
    function GetUserCount: integer;
    function GetWININICount: integer;
    function GetWININIRun(Index: integer): string;

    procedure ClearList(var L: TStringList);
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);

    property HKCU_Runs[Index: integer]: string read GetHKCU;
    property HKCU_Count: integer read GetHKCUCount;
    property HKLM_Runs[Index: integer]: string read GetHKLM;
    property HKLM_Count: integer read GetHKLMCount;
    property Once_Runs[Index: integer]: string read GetRunOnce;
    property Once_Count: integer read GetOnceCount;
    property User_Runs[Index: integer]: string read GetUserRun;
    property User_Count: integer read GetUserCount;
    property Common_Runs[Index: integer]: string read GetCommonRun;
    property Common_Count: integer read GetCommonCount;
    property WinINI_Runs[Index: integer]: string read GetWININIRun;
    property WinINI_Count: integer read GetWININICount;

    function GetRunCommand(AType: TRunType; Index: integer): string;
  published
    property RunsCount: integer read GetCount write SetCount stored False;
  end;


implementation

uses Registry, MiTeC_Routines, ShlObj, INIFiles;

{ TStartup }

procedure TStartup.ClearList(var L: TStringList);
var
  p :PChar;
begin
  while L.count>0 do begin
   p:=PChar(L.Objects[L.count-1]);
   Freemem(p);
   L.Delete(L.count-1);
  end;
end;

constructor TStartup.Create;
begin
  FHKCU_Runs:=TStringList.Create;
  FHKLM_Runs:=TStringList.Create;
  FOnce_Runs:=TStringList.Create;
  FUser_Runs:=TStringList.Create;
  FCommon_Runs:=TStringList.Create;
  FWININI_Runs:=TStringList.Create;
end;

destructor TStartup.Destroy;
begin
  ClearList(FHKCU_Runs);
  ClearList(FHKLM_Runs);
  ClearList(FOnce_Runs);
  ClearList(FUser_Runs);
  ClearList(FCommon_Runs);
  ClearList(FWININI_Runs);

  FHKCU_Runs.Free;
  FHKLM_Runs.Free;
  FOnce_Runs.Free;
  FUser_Runs.Free;
  FCommon_Runs.Free;
  FWININI_Runs.Free;
  inherited;
end;

function TStartup.GetCommonCount: integer;
begin
  Result:=FCommon_Runs.Count;
end;

function TStartup.GetCommonRun(Index: integer): string;
begin
  try
    Result:=FCommon_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetCount: integer;
begin
  Result:=FHKCU_Runs.Count+
          FHKLM_Runs.Count+
          FOnce_Runs.Count+
          FUser_Runs.Count+
          FCommon_Runs.Count+
          FWININI_Runs.Count;
end;

function TStartup.GetHKCU(Index: integer): string;
begin
  try
    Result:=FHKCU_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetHKCUCount: integer;
begin
  Result:=FHKCU_Runs.Count;
end;

function TStartup.GetHKLM(Index: integer): string;
begin
  try
    Result:=FHKLM_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetHKLMCount: integer;
begin
  Result:=FHKLM_Runs.Count;
end;

procedure TStartup.GetInfo;
const
  rk_Run = 'Software\Microsoft\Windows\CurrentVersion\Run';
  rk_Once = 'Software\Microsoft\Windows\CurrentVersion\RunOnce';
var
  i: integer;
  sl: TStringList;
  s,f,a: string;
  p: PChar;
  WinH: HWND;
  fi: TSearchRec;
begin
  try

  ClearList(FHKCU_Runs);
  ClearList(FHKLM_Runs);
  ClearList(FOnce_Runs);
  ClearList(FUser_Runs);
  ClearList(FCommon_Runs);
  ClearList(FWININI_Runs);

  sl:=nil;
  with TRegistry.Create do

    try
      sl:=TStringList.Create;
      sl.Clear;
      RootKey:=HKEY_CURRENT_USER;
      if OpenKey(rk_Run,False) then begin
        GetValueNames(sl);
        for i:=0 to sl.Count-1 do begin
          s:=ReadString(sl[i]);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FHKCU_Runs.AddObject(sl[i],@p^);
        end;
        CloseKey;
      end;

      sl.Clear;
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKey(rk_Run,False) then begin
        GetValueNames(sl);
        for i:=0 to sl.Count-1 do begin
          s:=ReadString(sl[i]);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FHKLM_Runs.AddObject(sl[i],@p^);
        end;
        CloseKey;
      end;

      sl.Clear;
      RootKey:=HKEY_CURRENT_USER;
      if OpenKey(rk_Once,False) then begin
        GetValueNames(sl);
        for i:=0 to sl.Count-1 do begin
          s:=ReadString(sl[i]);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FOnce_Runs.AddObject(sl[i],@p^);
        end;
        CloseKey;
      end;
      sl.Clear;
      RootKey:=HKEY_LOCAL_MACHINE;
      if OpenKey(rk_Once,False) then begin
        GetValueNames(sl);
        for i:=0 to sl.Count-1 do begin
          s:=ReadString(sl[i]);
          p:=AllocMem(Length(s)+1);
          StrPCopy(p,s);
          FOnce_Runs.AddObject(sl[i],@p^);
        end;
        CloseKey;
      end;

      WinH:=GetDesktopWindow;

      s:=GetSpecialFolder(WinH,CSIDL_COMMON_STARTUP);
      if (s<>'') and (s[Length(s)]='\') then
        SetLength(s,Length(s)-1);
      if FindFirst(s+'\*.lnk',faArchive,fi)=0 then begin
        ResolveLink(s+'\'+fi.Name,f,a);
        f:=f+' '+a;
        p:=AllocMem(Length(f)+1);
        StrPCopy(p,f);
        FCommon_Runs.AddObject(Copy(fi.Name,1,Length(fi.Name)-4),@p^);
        while FindNext(fi)=0 do begin
          ResolveLink(s+'\'+fi.Name,f,a);
          f:=f+' '+a;
          p:=AllocMem(Length(f)+1);
          StrPCopy(p,f);
          FCommon_Runs.AddObject(Copy(fi.Name,1,Length(fi.Name)-4),@p^);
        end;
      end;

      s:=GetSpecialFolder(WinH,CSIDL_STARTUP);
      if (s<>'') and (s[Length(s)]='\') then
        SetLength(s,Length(s)-1);
      if FindFirst(s+'\*.lnk',faArchive,fi)=0 then begin
        ResolveLink(s+'\'+fi.Name,f,a);
        f:=f+' '+a;
        p:=AllocMem(Length(f)+1);
        StrPCopy(p,f);
        FUser_Runs.AddObject(Copy(fi.Name,1,Length(fi.Name)-4),@p^);
        while FindNext(fi)=0 do begin
          ResolveLink(s+'\'+fi.Name,f,a);
          f:=f+' '+a;
          p:=AllocMem(Length(f)+1);
          StrPCopy(p,f);
          FUser_Runs.AddObject(Copy(fi.Name,1,Length(fi.Name)-4),@p^);
        end;
      end;

      with TINIFile.Create('WIN.INI') do begin
        ReadSectionValues('windows',sl);
        for i:=0 to sl.Count-1 do
          if (LowerCase(sl.Names[i])='run') or (LowerCase(sl.Names[i])='load') then begin
            f:=TrimAll(ReadString('windows',sl.Names[i],''));
            if f<>'' then begin
              p:=AllocMem(Length(f)+1);
              StrPCopy(p,f);
              FWININI_Runs.AddObject(sl.Names[i],@p^);
            end;
          end;
        Free;
      end;

    finally
      SysUtils.FindClose(fi);
      if Assigned(sl) then
        sl.Free;
      Free;
    end;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),PChar(Self.ClassName+'.GetInfo'),MB_OK or MB_ICONERROR);
    end;
  end;
end;

function TStartup.GetOnceCount: integer;
begin
  Result:=FOnce_Runs.Count;
end;

function TStartup.GetRunCommand(AType: TRunType; Index: integer): string;
begin
  try
    case AType of
      rtHKCU: Result:=StrPas(PChar(FHKCU_Runs.Objects[Index]));
      rtHKLM: Result:=StrPas(PChar(FHKLM_Runs.Objects[Index]));
      rtOnce: Result:=StrPas(PChar(FOnce_Runs.Objects[Index]));
      rtUser: Result:=StrPas(PChar(FUser_Runs.Objects[Index]));
      rtCommon: Result:=StrPas(PChar(FCommon_Runs.Objects[Index]));
      rtWININI: Result:=StrPas(PChar(FWININI_Runs.Objects[Index]));
    end;
  except
    Result:='';
  end;
end;

function TStartup.GetRunOnce(Index: integer): string;
begin
  try
    Result:=FOnce_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetUserCount: integer;
begin
  Result:=FUser_Runs.Count;
end;

function TStartup.GetUserRun(Index: integer): string;
begin
  try
    Result:=FUser_Runs[Index];
  except
    Result:='';
  end;
end;

function TStartup.GetWININICount: integer;
begin
  Result:=FWININI_Runs.Count;
end;

function TStartup.GetWININIRun(Index: integer): string;
begin
  try
    Result:=FWININI_Runs[Index];
  except
    Result:='';
  end;
end;

procedure TStartup.Report(var sl: TStringList);
var
  i,n: integer;
begin
  with sl do begin
    Add('[User Startup]');
    n:=User_Count;
    Add(Format('Count=%d',[n]));
    for i:=0 to n-1 do
      Add(Format('%s=%s',[User_Runs[i],GetRunCommand(rtUser,i)]));

    Add('[Common Startup]');
    n:=Common_Count;
    Add(Format('Count=%d',[n]));
    for i:=0 to n-1 do
      Add(Format('%s=%s',[Common_Runs[i],GetRunCommand(rtCommon,i)]));

    Add('[HKLM Run]');
    n:=HKLM_Count;
    Add(Format('Count=%d',[n]));
    for i:=0 to n-1 do
      Add(Format('%s=%s',[HKLM_Runs[i],GetRunCommand(rtHKLM,i)]));

    Add('[HKCU Run]');
    n:=HKCU_Count;
    Add(Format('Count=%d',[n]));
    for i:=0 to n-1 do
      Add(Format('%s=%s',[HKCU_Runs[i],GetRunCommand(rtHKCU,i)]));

    Add('[Run Once]');
    n:=Once_Count;
    Add(Format('Count=%d',[n]));
    for i:=0 to n-1 do
      Add(Format('%s=%s',[Once_Runs[i],GetRunCommand(rtOnce,i)]));
  end;
end;

procedure TStartup.SetCount(const Value: integer);
begin

end;

end.
