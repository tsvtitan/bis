
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               OS Detection Part                       }
{           version 5.6 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_OS;

interface

uses
  SysUtils, Windows, Classes;

type
  TTimeZone = class(TPersistent)
  private
    FStdBias: integer;
    FDayBias: integer;
    FBias: integer;
    FDisp: string;
    FStd: string;
    FDayStart: TDatetime;
    FStdStart: TDatetime;
    FDay: string;
    FMap: string;
  public
    procedure GetInfo;
    procedure Report(var sl :TStringList);
    property MapID: string read FMap;
  published
    property DisplayName: string read FDisp write FDisp stored False;
    property StandardName: string read FStd write FStd stored False;
    property DaylightName: string read FDay write FDay stored False;
    property DaylightStart: TDatetime read FDayStart write FDayStart stored False;
    property StandardStart: TDatetime read FStdStart write FStdStart stored False;
    property Bias: integer read FBias write FBias stored False;
    property DaylightBias: integer read FDayBias write FDayBias stored False;
    property StandardBias: integer read FStdBias write FStdBias stored False;
  end;

const
  VER_NT_WORKSTATION       = $0000001;
  VER_NT_DOMAIN_CONTROLLER = $0000002;
  VER_NT_SERVER            = $0000003;

  VER_SUITE_SMALLBUSINESS            = $0000002;
  VER_SUITE_ENTERPRISE               = $0000004;
  VER_SUITE_BACKOFFICE               = $0000008;
  VER_SUITE_COMMUNICATIONS           = $0000010;
  VER_SUITE_TERMINAL                 = $0000020;
  VER_SUITE_SMALLBUSINESS_RESTRICTED = $0000040;
  VER_SUITE_EMBEDDEDNT               = $0000080;
  VER_SUITE_DATACENTER               = $0000100;


type
  POSVersionInfoEx = ^TOSVersionInfoEx;
  TOSVersionInfoEx = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array [0..127] of Char;
    wServicePackMajor: Word;
    wServicePackMinor: Word;
    wSuiteMask: Word;
    wProductType: Byte;
    wReserved: Byte;
  end;

  TNtProductType = (ptUnknown, ptWorkStation, ptServer, ptAdvancedServer);

  TNTSuite = (suSmallBusiness, suEnterprise, suBackOffice, suCommunications,
              suTerminal, suSmallBusinessRestricted, suEmbeddedNT, suDataCenter);
  TNTSuites = set of TNTSuite;

  TNTSpecific = class(TPersistent)
  private
    FSPMinorVer: Word;
    FSPMajorVer: Word;
    FProduct: TNTProductType;
    FSuites: TNTSuites;
  public
    procedure GetInfo;
    procedure Report(var sl: TStringList);
    procedure Report_InstalledSuites(var sl: TStringList);
  published
    property ProductType: TNTProductType read FProduct write FProduct stored False;
    property InstalledSuites: TNTSuites read FSuites write FSuites stored False;
    property ServicePackMajorVersion: Word read FSPMajorVer write FSPMajorVer stored False;
    property ServicePackMinorVersion: Word read FSPMinorVer write FSPMinorVer stored False;
  end;

  TOperatingSystem = class(TPersistent)
  private
    FBuildNumber: integer;
    FMajorVersion: integer;
    FMinorVersion: integer;
    FPlatform: string;
    FCSD: string;
    FVersion: string;
    FRegUser: string;
    FProductID: string;
    FRegOrg: string;
    FEnv: TStrings;
    FDirs: TStrings;
    FTZ: TTimeZone;
    FNTSpec: TNTSpecific;
    FProductKey: string;
    FDVD: string;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property MajorVersion :integer read FMajorVersion write FMajorVersion stored false;
    property MinorVersion :integer read FMinorVersion write FMinorVersion stored false;
    property BuildNumber :integer read FBuildNumber write FBuildNumber stored false;
    property Platform :string read FPlatform write FPlatform stored false;
    property Version :string read FVersion write FVersion stored false;
    property CSD :string read FCSD write FCSD stored false;
    property ProductID :string read FProductID write FProductID stored false;
    property ProductKey :string read FProductKey write FProductKey stored False;
    property RegisteredUser :string read FRegUser write FRegUser stored false;
    property RegisteredOrg :string read FRegOrg write FRegOrg stored false;
    property TimeZone :TTimeZone read FTZ write FTZ stored false;
    property Environment :TStrings read FEnv write FEnv stored false;
    property Folders: TStrings read FDirs write FDirs stored False;
    property NTSpecific: TNTSpecific read FNTSpec write FNTSpec stored False;
    property DVDRegion: string read FDVD write FDVD stored False;
  end;

function GetVersionEx(lpVersionInformation: POSVersionInfoEx): BOOL; stdcall;

implementation

uses
  ShlObj, Registry, MiTeC_Routines;

function GetVersionEx; external kernel32 name 'GetVersionExA';

{ TTimeZone }

type
  TRegTimeZoneInfo = packed record
    Bias: Longint;
    StandardBias: Longint;
    DaylightBias: Longint;
    StandardDate: TSystemTime;
    DaylightDate: TSystemTime;
  end;

function GetTZDaylightSavingInfoForYear(
    TZ: TTimeZoneInformation; year: word;
    var DaylightDate, StandardDate: TDateTime;
    var DaylightBias, StandardBias: longint): boolean;
begin
  Result:=false;
  try
    if (TZ.DaylightDate.wMonth <> 0) and
       (TZ.StandardDate.wMonth <> 0) then begin
      DaylightDate:=DSTDate2Date(TZ.DaylightDate,year);
      StandardDate:=DSTDate2Date(TZ.StandardDate,year);
      DaylightBias:=TZ.Bias+TZ.DaylightBias;
      StandardBias:=TZ.Bias+TZ.StandardBias;
      Result:=true;
    end;
  except
  end;
end;

function CompareSysTime(st1, st2: TSystemTime): integer;
begin
  if st1.wYear<st2.wYear then
    Result:=-1
  else
    if st1.wYear>st2.wYear then
      Result:=1
    else
      if st1.wMonth<st2.wMonth then
        Result:=-1
      else
        if st1.wMonth>st2.wMonth then
          Result:=1
        else
          if st1.wDayOfWeek<st2.wDayOfWeek then
            Result:=-1
          else
            if st1.wDayOfWeek>st2.wDayOfWeek then
              Result:=1
            else
              if st1.wDay<st2.wDay then
                Result:=-1
              else
                if st1.wDay>st2.wDay then
                  Result:=1
                else
                  if st1.wHour<st2.wHour then
                    Result:=-1
                  else
                    if st1.wHour>st2.wHour then
                      Result:=1
                    else
                      if st1.wMinute<st2.wMinute then
                        Result:=-1
                      else
                        if st1.wMinute>st2.wMinute then
                          Result:=1
                         else
                           if st1.wSecond<st2.wSecond then
                             Result:=-1
                           else
                             if st1.wSecond>st2.wSecond then
                               Result:=1
                             else
                               if st1.wMilliseconds<st2.wMilliseconds then
                                 Result:=-1
                               else
                                 if st1.wMilliseconds>st2.wMilliseconds then
                                   Result:=1
                                 else
                                   Result:=0;
end;

function IsEqualTZ(tz1, tz2: TTimeZoneInformation): boolean;
begin
  Result:=(tz1.Bias=tz2.Bias) and
          (tz1.StandardBias=tz2.StandardBias) and
          (tz1.DaylightBias=tz2.DaylightBias) and
          (CompareSysTime(tz1.StandardDate,tz2.StandardDate)=0) and
          (CompareSysTime(tz1.DaylightDate,tz2.DaylightDate)=0) and
          (WideCharToString(tz1.StandardName)=WideCharToString(tz2.StandardName)) and
          (WideCharToString(tz1.DaylightName)=WideCharToString(tz2.DaylightName));
end;

procedure TTimeZone.GetInfo;
var
  TZKey: string;
  RTZ: TRegTimeZoneInfo;
  HomeTZ, RegTZ: TTimeZoneInformation;
  y,m,d,i: Word;
  sl: TStringList;
const
  rkNTTimeZones = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones';
  rk9xTimeZones = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows\CurrentVersion\Time Zones';
  rkTimeZone = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Control\TimeZoneInformation';
  rvTimeZone = 'StandardName';
begin
  try

  GetTimeZoneInformation(HomeTZ);
  sl:=TStringList.Create;
  with TRegistry.create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if IsNT then
      TZKey:=rkNTTimeZones
    else
      TZKey:=rk9xTimeZones;
    if OpenKey(TZKey,False) then begin
      GetKeyNames(sl);
      CloseKey;
      for i:=0 to sl.Count-1 do
        if OpenKey(TZKey+'\'+sl[i],False) then begin
          if GetDataSize('TZI')=SizeOf(RTZ) then begin
            ReadBinaryData('TZI',RTZ,SizeOf(RTZ));
            StringToWideChar(ReadString('Std'),@RegTZ.StandardName,SizeOf(RegTZ.StandardName) div SizeOf(WideChar));
            StringToWideChar(ReadString('Dlt'),@RegTZ.DaylightName,SizeOf(RegTZ.DaylightName) div SizeOf(WideChar));
            RegTZ.Bias:=RTZ.Bias;
            RegTZ.StandardBias:=RTZ.StandardBias;
            RegTZ.DaylightBias:=RTZ.DaylightBias;
            RegTZ.StandardDate:=RTZ.StandardDate;
            RegTZ.DaylightDate:=RTZ.DaylightDate;
            if IsEqualTZ(HomeTZ,RegTZ) then begin
              FDisp:=ReadString('Display');
              try
                FMap:=ReadString('MapID');
              except
                FMap:='';
              end;
              Break;
            end;
          end;
          CloseKey;
        end;
    end;
    Free;
  end;
  FBias:=HomeTZ.Bias;
  FStd:=HomeTZ.StandardName;
  FDay:=HomeTZ.DaylightName;
  DecodeDate(Date,y,m,d);
  GetTZDaylightSavingInfoForYear(HomeTZ,y,FDayStart,FStdStart,FDayBias,FStdBias);
  sl.Free;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TTimeZone.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TTimeZone.Report(var sl: TStringList);
begin
  with sl do begin
    Add('[Time Zone]');
    Add(Format('TimeZone=%s',[DisplayName]));
    Add(Format('StdName=%s',[DateTimeToStr(StandardStart)]));
    Add(Format('StdBias=%d',[StandardBias]));
    Add(Format('DlghtName=%s',[DateTimeToStr(DaylightStart)]));
    Add(Format('DlghtBias=%d',[DaylightBias]));
  end;
end;


{ TOperatingSystem }

constructor TOperatingSystem.Create;
begin
  inherited;
  FEnv:=TStringList.Create;
  FDirs:=TStringList.Create;
  FTZ:=TTimeZone.Create;
  FNTSpec:=TNTSpecific.Create;
end;

destructor TOperatingSystem.Destroy;
begin
  FEnv.Free;
  FDirs.Free;
  FTZ.Free;
  FNTSpec.Free;
  inherited;
end;


procedure TOperatingSystem.GetInfo;
var
  OS :TOSVersionInfo;
  OK: Boolean;
  p: pchar;
  n: DWORD;
  WinH: HWND;
  s: string;
const
  rkOSInfo95 = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows\CurrentVersion';
  rkOSInfoNT = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows NT\CurrentVersion';
  rkSP6a = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\WindowsNT\CurrentVersion\Hotfix\Q246009';

  rvInstalled = 'Installed';
  rvVersionName95 = 'Version';
  rvVersionNameNT = 'CurrentType';
  rvRegOrg = 'RegisteredOrganization';
  rvRegOwn = 'RegisteredOwner';
  rvProductID = 'ProductID';
  rvProductKey = 'ProductKey';
  rvDVD = 'DVD_Region';

  cUserProfile = 'USERPROFILE';
  cUserProfileReg = {HKEY_CURRENT_USER\}'Software\Microsoft\Windows\CurrentVersion\ProfileList';
  cUserProfileRec = {HKEY_CURRENT_USER\}'SOFTWARE\Microsoft\Windows\CurrentVersion\ProfileReconciliation';
  cProfileDir = 'ProfileDirectory';
begin
  try

  FDirs.Clear;
  TimeZone.GetInfo;
  NTSpecific.GetInfo;
  ZeroMemory(@OS,SizeOf(OS));
  OS.dwOSVersionInfoSize:=SizeOf(OS);
  Windows.GetVersionEx(OS);
  MajorVersion:=OS.dwMajorVersion;
  MinorVersion:=OS.dwMinorVersion;
  BuildNumber:=word(OS.dwBuildNumber);
  case OS.dwPlatformId of
    VER_PLATFORM_WIN32s        :Platform:='Windows 3.1x';
    VER_PLATFORM_WIN32_WINDOWS :Platform:='Windows 9x';
    VER_PLATFORM_WIN32_NT      :Platform:='Windows NT';
  end;
  CSD:=strpas(OS.szCSDVersion);

  Version:='';
  RegisteredUser:='';
  RegisteredOrg:='';
  ProductID:='';
  with TRegistry.create do begin
    rootkey:=HKEY_LOCAL_MACHINE;
    if IsNT then
      OK:=OpenKey(rkOSInfoNT,False)
    else
      OK:=OpenKey(rkOSInfo95,False);
    if OK then begin
      if isnt then begin
        if ValueExists(rvVersionNameNT) then
          Version:=ReadString(rvVersionNameNT);
      end else
        if ValueExists(rvVersionName95) then
           Version:=ReadString(rvVersionName95);
      if ValueExists(rvRegOrg) then
        RegisteredOrg:=ReadString(rvRegOrg);
      if ValueExists(rvRegOwn) then
        RegisteredUser:=ReadString(rvRegOwn);
      if ValueExists(rvProductID) then
        ProductID:=ReadString(rvProductID);
      if ValueExists(rvProductKey) then
        ProductKey:=ReadString(rvProductKey);
      if ValueExists(rvDVD) then
        DVDRegion:=ReadString(rvDVD);

      FDirs.Add('CommonFiles='+ReadString('CommonFilesDir'));
      FDirs.Add('ProgramFiles='+ReadString('ProgramFilesDir'));
      FDirs.Add('Device='+ReadString('DevicePath'));
      FDirs.Add('OtherDevice='+ReadString('OtherDevicePath'));
      FDirs.Add('Media='+ReadString('MediaPath'));
      FDirs.Add('Config='+ReadString('ConfigPath'));
      FDirs.Add('Wallpaper='+ReadString('WallPaperDir'));
      CloseKey;

      if IsNT then  begin
        if CSD='Service Pack 6' then
          if OpenKey(rkSP6a,False) then begin
            if ValueExists(rvInstalled) then
              if ReadInteger(rvInstalled)=1 then
                CSD:='Service Pack 6a';
            CloseKey;
          end;
      end;
    end;
    Free;
  end;

  n:=MAX_PATH;
  p:=StrAlloc(n);

  GetWindowsDirectory(p,n);
  FDirs.Add('Windows='+StrPas(p));

  GetSystemDirectory(p,n);
  FDirs.Add('System='+StrPas(p));

  GetTempPath(n,p);
  FDirs.Add('Temp='+StrPas(p));

  StrDispose(p);

  WinH:=GetDesktopWindow;
  FDirs.Add('AppData='+GetSpecialFolder(WinH,CSIDL_APPDATA));
  FDirs.Add('CommonDesktopDir='+GetSpecialFolder(WinH,CSIDL_COMMON_DESKTOPDIRECTORY));
  FDirs.Add('CommonAltStartUp='+GetSpecialFolder(WinH,CSIDL_COMMON_ALTSTARTUP));
  FDirs.Add('RecycleBin='+GetSpecialFolder(WinH,CSIDL_BITBUCKET));
  FDirs.Add('CommonPrograms='+GetSpecialFolder(WinH,CSIDL_COMMON_PROGRAMS));
  FDirs.Add('CommonStartMenu='+GetSpecialFolder(WinH,CSIDL_COMMON_STARTMENU));
  FDirs.Add('CommonStartup='+GetSpecialFolder(WinH,CSIDL_COMMON_STARTUP));
  FDirs.Add('CommonFavorites='+GetSpecialFolder(WinH,CSIDL_COMMON_FAVORITES));
  FDirs.Add('Cookies='+GetSpecialFolder(WinH,CSIDL_COOKIES));
  FDirs.Add('Controls='+GetSpecialFolder(WinH,CSIDL_CONTROLS));
  FDirs.Add('Desktop='+GetSpecialFolder(WinH,CSIDL_DESKTOP));
  FDirs.Add('DesktopDir='+GetSpecialFolder(WinH,CSIDL_DESKTOPDIRECTORY));
  FDirs.Add('Favorites='+GetSpecialFolder(WinH,CSIDL_FAVORITES));
  FDirs.Add('Drives='+GetSpecialFolder(WinH,CSIDL_DRIVES));
  FDirs.Add('Fonts='+GetSpecialFolder(WinH,CSIDL_FONTS));
  FDirs.Add('History='+GetSpecialFolder(WinH,CSIDL_HISTORY));
  FDirs.Add('Internet='+GetSpecialFolder(WinH,CSIDL_INTERNET));
  FDirs.Add('InternetCache='+GetSpecialFolder(WinH,CSIDL_INTERNET_CACHE));
  FDirs.Add('NetWork='+GetSpecialFolder(WinH,CSIDL_NETWORK));
  FDirs.Add('NetHood='+GetSpecialFolder(WinH,CSIDL_NETHOOD));
  FDirs.Add('MyDocuments='+GetSpecialFolder(WinH,CSIDL_PERSONAL));
  FDirs.Add('PrintHood='+GetSpecialFolder(WinH,CSIDL_PRINTHOOD));
  FDirs.Add('Printers='+GetSpecialFolder(WinH,CSIDL_PRINTERS));
  FDirs.Add('Programs='+GetSpecialFolder(WinH,CSIDL_PROGRAMS));
  FDirs.Add('Recent='+GetSpecialFolder(WinH,CSIDL_RECENT));
  FDirs.Add('SendTo='+GetSpecialFolder(WinH,CSIDL_SENDTO));
  FDirs.Add('StartMenu='+GetSpecialFolder(WinH,CSIDL_STARTMENU));
  FDirs.Add('StartUp='+GetSpecialFolder(WinH,CSIDL_STARTUP));
  FDirs.Add('Templates='+GetSpecialFolder(WinH,CSIDL_TEMPLATES));
  s:=ReverseStr(FDirs.Values['Desktop']);
  s:=ReverseStr(Copy(s,Pos('\',s)+1,255));
  FDirs.Add('Profile='+s);
  FEnv.Clear;
  GetEnvironment(FEnv);

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TOperatingSystem.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TOperatingSystem.Report(var sl: TStringList);
begin
  with sl do begin
    Add('[Operating System]');
    Add(Format('Platform=%s',[Platform]));
    Add(Format('VersionName=%s',[Version]));
    Add(Format('Version=%d.%d',[MajorVersion,MinorVersion]));
    Add(Format('BuildNumber=%d',[BuildNumber]));
    Add(Format('CSD=%s',[CSD]));
    Add(Format('ProductID=%s',[ProductID]));
    Add(Format('ProductKey=%s',[ProductKey]));
    Add(Format('RegUser=%s',[RegisteredUser]));
    Add(Format('RegOrganization=%s',[RegisteredOrg]));
    Add(Format('DVDRegion=%s',[DVDRegion]));
    NTSpecific.Report(sl);
    Add('[Environment]');
    AddStrings(Environment);
    Add('[Folders]');
    AddStrings(Folders);
    TimeZone.Report(sl);
  end;
end;


{ TNTSpecific }

procedure TNTSpecific.GetInfo;
var
  VersionInfo: TOSVersionInfoEx;
  OS :TOSVersionInfo;
  s: string;
const
  rkProductTypeNT = {HKEY_LOCAL_MACHINE\}'System\CurrentControlSet\Control\ProductOptions';
  rvProductType = 'ProductType';
begin
  try

  ZeroMemory(@OS,SizeOf(OS));
  OS.dwOSVersionInfoSize:=SizeOf(OS);
  Windows.GetVersionEx(OS);
  if (OS.dwPlatformId=VER_PLATFORM_WIN32_NT) and (OS.dwMajorVersion=5) then begin
    ZeroMemory(@VersionInfo,SizeOf(VersionInfo));
    VersionInfo.dwOSVersionInfoSize:=SizeOf(VersionInfo);
    if GetVersionEx(@VersionInfo) then begin
      case VersionInfo.wProductType of
        VER_NT_WORKSTATION: FProduct:=ptWorkStation;
        VER_NT_DOMAIN_CONTROLLER: FProduct:=ptAdvancedServer;
        VER_NT_SERVER: FProduct:=ptServer;
      end;
      FSuites:=[];
      if VersionInfo.wSuiteMask and VER_SUITE_SMALLBUSINESS=VER_SUITE_SMALLBUSINESS then
        FSuites:=FSuites+[suSmallBusiness];
      if VersionInfo.wSuiteMask and VER_SUITE_ENTERPRISE=VER_SUITE_ENTERPRISE then
        FSuites:=FSuites+[suEnterprise];
      if VersionInfo.wSuiteMask and VER_SUITE_BACKOFFICE=VER_SUITE_BACKOFFICE then
        FSuites:=FSuites+[suBackOffice];
      if VersionInfo.wSuiteMask and VER_SUITE_COMMUNICATIONS=VER_SUITE_COMMUNICATIONS then
        FSuites:=FSuites+[suCommunications];
      if VersionInfo.wSuiteMask and VER_SUITE_TERMINAL=VER_SUITE_TERMINAL then
        FSuites:=FSuites+[suTerminal];
      if VersionInfo.wSuiteMask and VER_SUITE_SMALLBUSINESS_RESTRICTED=VER_SUITE_SMALLBUSINESS_RESTRICTED then
        FSuites:=FSuites+[suSmallBusinessRestricted];
      if VersionInfo.wSuiteMask and VER_SUITE_EMBEDDEDNT=VER_SUITE_EMBEDDEDNT then
        FSuites:=FSuites+[suEmbeddedNT];
      if VersionInfo.wSuiteMask and VER_SUITE_DATACENTER=VER_SUITE_DATACENTER then
        FSuites:=FSuites+[suDataCenter];
      FSPMajorVer:=VersionInfo.wServicePackMajor;
      FSPMinorVer:=VersionInfo.wServicePackMinor;
    end;
  end;
  if FProduct=ptUnknown then
    with TRegistry.Create do begin
      if OpenKey(rkProductTypeNT,False) then begin
        s:=ReadString(rvProductType);
        if s='WinNT' then
          FProduct:=ptWorkStation
        else
          if s='ServerNT' then
            FProduct:=ptServer
          else
            if s='LanmanNT' then
              FProduct:=ptAdvancedServer;
        CloseKey;
      end;
      Free;
    end;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TNTSpecific.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TNTSpecific.Report(var sl: TStringList);
begin
  with sl do begin
    Add('[NT Specific]');
    case ProductType of
      ptUnknown: Add('ProductType=Unknown');
      ptWorkStation: Add('ProductType=Workstation');
      ptServer: Add('ProductType=Server');
      ptAdvancedServer: Add('ProductType=Advanced Server');
    end;
    Report_InstalledSuites(sl);
    Add(Format('ServicePackMajorVersion=%d',[ServicePackMajorVersion]));
    Add(Format('ServicePackMinorVersion=%d',[ServicePackMinorVersion]));
  end;
end;

procedure TNTSpecific.Report_InstalledSuites(var sl: TStringList);
begin
  with sl do begin
    Add(Format('Microsoft Small Business Server=%d',
               [integer(suSmallBusiness in InstalledSuites)]));
    Add(Format('Windows 2000 Advanced Server=%d',
               [integer(suEnterprise in InstalledSuites)]));
    Add(Format('Microsoft BackOffice Components=%d',
               [integer(suBackOffice in InstalledSuites)]));
    Add(Format('Communications=%d',
               [integer(suCommunications in InstalledSuites)]));
    Add(Format('Terminal Services=%d',
               [integer(suSmallBusiness in InstalledSuites)]));
    Add(Format('Microsoft Small Business Server with the restrictive client license in force=%d',
               [integer(suSmallBusinessRestricted in InstalledSuites)]));
    Add(Format('Terminal Services=%d',
               [integer(suSmallBusiness in InstalledSuites)]));
    Add(Format('Embedded NT=%d',
               [integer(suEmbeddedNT in InstalledSuites)]));
    Add(Format('Windows 2000 Datacenter Server=%d',
               [integer(suDataCenter in InstalledSuites)]));
  end;
end;

end.
