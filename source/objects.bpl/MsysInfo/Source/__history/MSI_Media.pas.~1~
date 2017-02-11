
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Media Detection Part                    }
{           version 5.4 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Media;

interface

uses
  SysUtils, Windows, Classes, MMSystem;

type
  TMedia = class(TPersistent)
  private
    FDevice,
    FAUX,
    FMIDIIn,
    FMixer,
    FWAVEOut,
    FWAVEIn,
    FMIDIOut: TStrings;
    FSCI: integer;
    FGPI: integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
  published
    property GamePortIndex: integer read FGPI write FGPI stored false;
    property SoundCardIndex: integer read FSCI write FSCI stored False;
    property Devices :TStrings read FDevice write FDevice stored false;
    property WAVEIn :TStrings read FWAVEIn write FWAVEIn stored false;
    property WAVEOut :TStrings read FWAVEOut write FWAVEOut stored false;
    property MIDIIn :TStrings read FMIDIIn write FMIDIIn stored false;
    property MIDIOut :TStrings read FMIDIOut write FMIDIOut stored false;
    property AUX :TStrings read FAUX write FAUX stored false;
    property Mixer :TStrings read FMixer write FMixer stored false;
  end;

implementation

uses Registry, MiTeC_Routines, MSI_Devices;

{ TMedia }

constructor TMedia.Create;
begin
  inherited;
  FDevice:=TStringList.Create;
  FWaveIn:=TStringList.Create;
  FWaveOut:=TStringList.Create;
  FMIDIIn:=TStringList.Create;
  FMIDIOut:=TStringList.Create;
  FMixer:=TStringList.Create;
  FAUX:=TStringList.Create;
end;

destructor TMedia.Destroy;
begin
  FDevice.Free;
  FWaveIn.Free;
  FWaveOut.Free;
  FMIDIIn.Free;
  FMIDIOut.Free;
  FMixer.Free;
  FAUX.Free;
  inherited;
end;

procedure TMedia.GetInfo;
var
  WOC :PWAVEOutCaps;
  WIC :PWAVEInCaps;
  MOC :PMIDIOutCaps;
  MIC :PMIDIInCaps;
  AXC :PAUXCaps;
  MXC :PMixerCaps;
  i,j,n: integer;
  s: string;
const
  rv = 'DriverDesc';
  rvMediaClass = 'MEDIA';
begin
  try

  FDevice.Clear;
  GetClassDevices(ClassKey,rvMediaClass,DescValue,FDevice);
  FSCI:=-1;
  FGPI:=-1;

  with TDevices.Create do begin
    GetInfo;
    for i:=0 to DeviceCount-1 do
      if Devices[i].DeviceClass=dcMEDIA then begin
        if Devices[i].FriendlyName='' then
          s:=Devices[i].Description
        else
          s:=Devices[i].FriendlyName;
        j:=FDevice.IndexOf(s);
        if j<>-1 then begin
          if pos('GAME',UpperCase(s))>0 then
            FGPI:=j
          else
            if (Devices[i].Location<>'') and (FSCI=-1) then
              FSCI:=j;
        end;
      end;
    Free;
  end;

  new(WOC);
  n:=waveOutGetNumDevs;
  for i:=0 to n-1 do
    if WAVEOutGetDevCaps(i,WOC,SizeOf(TWAVEOutCaps))=MMSYSERR_NOERROR then begin
      s:=strpas(WOC^.szPname)+' v'+inttostr(hi(WOC^.vDriverVersion))+'.'+inttostr(hi(WOC^.vDriverVersion));
      if FWaveOut.IndexOf(s)=-1 then
        FWAVEOut.Add(s);
    end;
  dispose(WOC);

  new(WIC);
  n:=waveInGetNumDevs;
  for i:=0 to n-1 do
    if WAVEinGetDevCaps(i,WIC,SizeOf(TWAVEInCaps))=MMSYSERR_NOERROR then begin
      s:=strpas(WIC^.szPname)+' v'+inttostr(hi(WIC^.vDriverVersion))+'.'+inttostr(hi(WIC^.vDriverVersion));
      if FWaveIn.IndexOf(s)=-1 then
        FWAVEIn.Add(s);
    end;
  dispose(WIC);

  new(MOC);
  n:=midiOutGetNumDevs;
  for i:=0 to n-1 do
    if MIDIoutGetDevCaps(i,MOC,SizeOf(TMIDIOutCaps))=MMSYSERR_NOERROR then begin
      s:=strpas(MOC^.szPname)+' v'+inttostr(hi(MOC^.vDriverVersion))+'.'+inttostr(hi(MOC^.vDriverVersion));
      if FMIDIOut.IndexOf(s)=-1 then
        FMIDIout.Add(s);
    end;
  dispose(MOC);

  new(MIC);
  n:=midiInGetNumDevs;
  for i:=0 to n-1 do
    if MIDIinGetDevCaps(i,MIC,SizeOf(TMIDIInCaps))=MMSYSERR_NOERROR then begin
      s:=strpas(MIC^.szPname)+' v'+inttostr(hi(MIC^.vDriverVersion))+'.'+inttostr(hi(MIC^.vDriverVersion));
      if FMIDIIn.IndexOf(s)=-1 then
        FMIDIin.Add(s);
    end;
  dispose(MIC);

  new(AXC);
  n:=auxGetNumDevs;
  for i:=0 to n-1 do
    if AUXGetDevCaps(i,AXC,SizeOf(TAUXCaps))=MMSYSERR_NOERROR then begin
      s:=strpas(AXC^.szPname)+' v'+inttostr(hi(AXC^.vDriverVersion))+'.'+inttostr(hi(AXC^.vDriverVersion));
      if FAUX.IndexOf(s)=-1 then
        FAUX.Add(s);
    end;
  dispose(AXC);

  new(MXC);
  n:=mixerGetNumDevs;
  for i:=0 to n-1 do
    if MixerGetDevCaps(i,MXC,SizeOf(TMixerCaps))=MMSYSERR_NOERROR then begin
      s:=strpas(MXC^.szPname)+' v'+inttostr(hi(MXC^.vDriverVersion))+'.'+inttostr(hi(MXC^.vDriverVersion));
      if FMixer.IndexOf(s)=-1 then
        FMixer.Add(s);
    end;
  dispose(MXC);

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TMedia.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TMedia.Report(var sl: TStringList);
begin
  with sl do begin
    Add('[Media]');
    StringsToRep(Devices,'Count','Device',sl);
    Add('[Sound]');
    StringsToRep(WaveIn,'WaveInCount','WaveIn',sl);
    StringsToRep(WaveOut,'WaveOutCount','WaveOut',sl);
    StringsToRep(MIDIIn,'MIDIInCount','MIDIIn',sl);
    StringsToRep(MIDIIn,'MIDIOutCount','MIDIOut',sl);
    StringsToRep(AUX,'AUXCount','AUX',sl);
    StringsToRep(Mixer,'MixerCount','Mixer',sl);
  end;
end;

end.
