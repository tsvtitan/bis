
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               APM Detection Part                      }
{           version 5.4 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_APM;

interface

uses
  SysUtils, Windows, Classes;

type
  TPowerStatus = (psUnknown, psOffline, psOnline);
  
  TBatteryStatus = (bsUnknown, bsHigh, bsLow, bsCritical, bsCharging, bsNoBattery);

  TAPM = class(TPersistent)
  private
    FBatteryLifePercent: Byte;
    FBatteryLifeFullTime: DWORD;
    FBatteryLifeTime: DWORD;
    FACPowerStatus: TPowerStatus;
    FBatteryChargeStatus: TBatteryStatus;
  public
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property ACPowerStatus :TPowerStatus read FACPowerStatus write FACPowerStatus stored false;
    property BatteryChargeStatus :TBatteryStatus read FBatteryChargeStatus write FBatteryChargeStatus stored false;
    property BatteryLifePercent :Byte read FBatteryLifePercent write FBatteryLifePercent stored false;
    property BatteryLifeTime :DWORD read FBatteryLifeTime write FBatteryLifeTime stored false;
    property BatteryLifeFullTime :DWORD read FBatteryLifeFullTime write FBatteryLifeFullTime stored false;
  end;

implementation

uses
  MiTeC_Routines;

{ TAPM }

procedure TAPM.GetInfo;
var
  PS :TSystemPowerStatus;
  OK: Boolean;
begin
  try

  FACPowerStatus:=psUnknown;
  FBatteryChargeStatus:=bsUnknown;
  FBatteryLifePercent:=0;
  FBatteryLifeTime:=0;
  FBatteryLifeFullTime:=0;
  ok:=GetSystemPowerStatus(PS);
  if OK then begin
    case PS.ACLineStatus of
      0 : FACPowerStatus:=psOffLine;
      1 : FACPowerStatus:=psOnLine;
      else FACPowerStatus:=psUnknown;
    end;
    if (PS.BatteryFlag or 1)=1 then
      FBatteryChargeStatus:=bsHigh
    else
      if (PS.BatteryFlag or 2)=2 then
        FBatteryChargeStatus:=bsLow
      else
        if (PS.BatteryFlag or 4)=4 then
          FBatteryChargeStatus:=bsCritical
        else
          if (PS.BatteryFlag or 8)=8 then
            FBatteryChargeStatus:=bsCharging
          else
            if (PS.BatteryFlag or 128)=128 then
              FBatteryChargeStatus:=bsNoBattery
            else
              FBatteryChargeStatus:=bsUnknown;
    FBatteryLifePercent:=PS.BatteryLifePercent;
    FBatteryLifeTime:=PS.BatteryLifeTime;
    FBatteryLifeFullTime:=PS.BatteryFullLifeTime;
  end;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TAPM.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TAPM.Report(var sl: TStringList);
var
  s: string;
begin
  with sl do begin
    Add('[Advanced Power Management]');
    case ACPowerStatus of
      psUnknown: s:='Unknown';
      psOnline: s:='Online';
      psOffline: s:='Offline';
    end;
    Add(Format('ACPowerStatus=%s',[s]));
    case BatteryChargeStatus of
      bsUnknown: s:='Unknown';
      bsHigh: s:='High';
      bsLow: s:='Low';
      bsCritical: s:='Critical';
      bsCharging: s:='Charging';
      bsNoBattery: s:='No Battery';
    end;
    Add(Format('BatteryChargeStatus=%s',[s]));
    if BatteryLifePercent<=100 then begin
      Add(Format('BattreyLifeFullTime=%s',[FormatSeconds(BatteryLifeFullTime,true,false,false)]));
      Add(Format('BatteryLifeTime=%s',[FormatSeconds(BatteryLifeTime,true,false,false)]));
    end;
  end;
end;


end.
