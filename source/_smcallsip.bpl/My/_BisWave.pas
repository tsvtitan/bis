unit BisWave;

interface

uses Windows, Classes,
     MMSystem,
     WaveRecorders, WavePlayers, WaveMixer;

type
  TBisLiveAudioRecorder=class(TLiveAudioRecorder)
  public
    function GetDeviceNameByID(ADeviceID: Cardinal): String;
    procedure FillDevices(Strings: TStrings);
  end;

  TBisLiveAudioPlayer=class(TLiveAudioPlayer)
  public
    function GetDeviceNameByID(ADeviceID: Cardinal): String;
    procedure FillDevices(Strings: TStrings);
  end;

  TBisAudioMixer=class(TAudioMixer)
  end;

implementation

uses SysUtils;

{ TBisLiveAudioRecorder }

function TBisLiveAudioRecorder.GetDeviceNameByID(ADeviceID: Cardinal): String;
var
  DevCaps: TWaveInCaps;
begin
  if WaveInGetDevCaps(ADeviceID, @DevCaps, SizeOf(DevCaps)) = MMSYSERR_NOERROR then
    Result := StrPas(DevCaps.szPname)
  else
    Result := '';
end;

procedure TBisLiveAudioRecorder.FillDevices(Strings: TStrings);
var
  i: Cardinal;
begin
  if Assigned(Strings) then begin
    Strings.BeginUpdate;
    try
      for i:=0 to NumDevs-1 do begin
        Strings.Add(GetDeviceNameByID(i));
      end;
    finally
      Strings.EndUpdate;
    end;
  end;
end;

{ TBisLiveAudioPlayer }

function TBisLiveAudioPlayer.GetDeviceNameByID(ADeviceID: Cardinal): String;
var
  DevCaps: TWaveOutCaps;
begin
  if waveOutGetDevCaps(ADeviceID, @DevCaps, SizeOf(DevCaps)) = MMSYSERR_NOERROR then
    Result := StrPas(DevCaps.szPname)
  else
    Result := '';
end;

procedure TBisLiveAudioPlayer.FillDevices(Strings: TStrings);
var
  i: Cardinal;
begin
  if Assigned(Strings) then begin
    Strings.BeginUpdate;
    try
      for i:=0 to NumDevs-1 do begin
        Strings.Add(GetDeviceNameByID(i));
      end;
    finally
      Strings.EndUpdate;
    end;
  end;
end;

end.
