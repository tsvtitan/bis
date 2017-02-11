
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Machine Detection Part                  }
{           version 5.4 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Machine;

interface

uses
  SysUtils, Windows, Classes;

type
  TMachine = class(TPersistent)
  private
    FName: string;
    FLastBoot: TDatetime;
    FUser: string;
    FSystemUpTime: Extended;
    FBIOSExtendedInfo: string;
    FBIOSCopyright: string;
    FBIOSName: string;
    FBIOSDate: string;
    FScrollLock: Boolean;
    FNumLock: Boolean;
    FCapsLock: Boolean;
    FComp: string;
    function GetSystemUpTime: Extended;
  public
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property Name :string read FName write FName stored false;
    property User :string read FUser write FUser stored false;
    property SystemUpTime :Extended read FSystemUpTime write FSystemUpTime stored false;
    property LastBoot :TDatetime read FLastBoot write FLastBoot stored false;
    property BIOSCopyright :string read FBIOSCopyright write FBIOSCopyright stored false;
    property BIOSDate :string read FBIOSDate write FBIOSDate stored false;
    property BIOSExtendedInfo :string read FBIOSExtendedInfo write FBIOSExtendedInfo stored false;
    property BIOSName :string read FBIOSName write FBIOSName stored false;
    property CapsLock: Boolean read FCapsLock write FCapsLock stored false;
    property NumLock: Boolean read FNumLock write FNumLock stored false;
    property ScrollLock: Boolean read FScrollLock write FScrollLock stored false;
    property Computer: string read FComp Write FComp stored False;
  end;

implementation

uses
  Registry, MiTeC_Routines;

{ TMachine }

function TMachine.GetSystemUpTime: Extended;
begin
  try
    FSystemUpTime:=GetTickCount/1000;
  except
    FSystemUpTime:=0;
  end;
  result:=FSystemUpTime;
end;

procedure TMachine.GetInfo;
var
  bdata :pchar;
  KeyState : TKeyBoardState;
  sl: TStrings;
const
  cBIOSName = $FE061;
  cBIOSDate = $FFFF5;
  cBIOSExtInfo = $FEC71;
  cBIOSCopyright = $FE091;

  rkBIOS = {HKEY_LOCAL_MACHINE\}'HARDWARE\DESCRIPTION\System';
    rvBiosDate = 'SystemBiosDate';
    rvBiosID = 'Identifier';
    rvBiosVersion = 'SystemBiosVersion';

  rvComputerClass = 'Computer';

begin
  try

  sl:=TStringList.Create;
  try
    FLastBoot:=Now-(GetTickCount/1000)/(24*3600);
  except
    FLastBoot:=0;
  end;
  FSystemUpTime:=GetSystemUpTime;
  FName:=GetMachine;
  FUser:=GetUser;
  if isNT then begin
    with TRegistry.Create do begin
      rootkey:=HKEY_LOCAL_MACHINE;
      if OpenKey(rkBIOS,false) then begin
        if ValueExists(rvBIOSID) then
          FBiosName:=ReadString(rvBIOSID);
        if ValueExists(rvBIOSVersion) then begin
          bdata:=AllocMem(255);
          try
            readbinarydata(rvBIOSVersion,bdata^,255);
            FBIOSCopyright:=strpas(pchar(bdata));
          except
          end;
          FreeMem(bdata);
        end;
        if ValueExists(rvBIOSDate) then
          FBIOSDate:=ReadString(rvBIOSDate);
        closekey;
      end;
      free;
    end;
  end else begin
    FBIOSName:=string(pchar(ptr(cBIOSName)));
    FBIOSDate:=string(pchar(ptr(cBIOSDate)));
    FBIOSCopyright:=string(pchar(ptr(cBIOSCopyright)));
    FBIOSExtendedInfo:=string(pchar(ptr(cBIOSExtInfo)));
  end;
  GetKeyboardState(KeyState);
  FCapsLock:=KeyState[VK_CAPITAL]=1;
  FNumLock:=KeyState[VK_NUMLOCK]=1;
  FScrollLock:=KeyState[VK_SCROLL]=1;
  GetClassDevices(ClassKey,rvComputerClass,DescValue,sl);
  if sl.Count>0 then
    FComp:=sl[0]
  else
    FComp:='';
  sl.Free;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TMachine.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;


procedure TMachine.Report(var sl: TStringList);
begin
  with sl do begin
    Add('[Machine]');
    Add(Format('Name=%s',[Name]));
    Add(Format('User=%s',[User]));
    Add(Format('BIOS name=%s',[BIOSName]));
    Add(Format('BIOS Copyright=%s',[BIOSCopyright]));
    Add(Format('BIOS Date=%s',[BIOSDate]));
    Add(Format('BIOS Extended info=%s',[BIOSExtendedInfo]));
    Add(Format('Last Boot=%s',[DateTimeToStr(LastBoot)]));
    Add(Format('System Up Time=%s',[FormatSeconds(SystemUpTime,true,false,false)]));
    Add(Format('Computer=%s',[Computer]));
  end;
end;

end.
