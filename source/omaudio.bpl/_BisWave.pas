unit BisWave;

interface

uses Windows, Classes,
     MMSystem,
     WaveRecorders, WavePlayers, WaveMixer, WaveStorage, WaveUtils,
     WaveACM, WaveACMDrivers;

type
  TBisLiveAudioRecorder=class(TLiveAudioRecorder)
  private
    FStarting: Boolean;
    FStopping: Boolean;
  protected
    procedure DoActivate; override;
    procedure DoDeactivate; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetDeviceNameByID(ADeviceID: Cardinal): String;
    procedure FillDevices(Strings: TStrings);

    procedure Start(Wait: Boolean=false);
    procedure Stop(Wait: Boolean=false);
  end;

  TBisLiveAudioPlayer=class(TLiveAudioPlayer)
  private
    FStarting: Boolean;
    FStopping: Boolean;
  protected
    procedure DoActivate; override;
    procedure DoDeactivate; override;
  public
    constructor Create(AOwner: TComponent); override;

    function GetDeviceNameByID(ADeviceID: Cardinal): String;
    procedure FillDevices(Strings: TStrings);

    procedure Start(Wait: Boolean=false);
    procedure Stop(Wait: Boolean=false);
  end;

  TBisStockAudioPlayerDataEvent=procedure (Sender: TObject; const Buffer: Pointer; BufferSize: DWord) of object;

  TBisStockAudioPlayer=class(TStockAudioPlayer)
  private
    FCounter: Integer;
    FLoopCount: Integer;
    FStream: TStream;
    FStopped: Boolean;
    FOnStop: TNotifyEvent;
    FOnData: TBisStockAudioPlayerDataEvent;
    FSpeedFactor: Single;
    procedure SetSpeedFactor(const Value: Single);
  protected
    function GetActive: Boolean; override;
    procedure DoActivate; override;
    procedure DoDeactivate; override;
    procedure GetWaveFormat(var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean); override;
    function GetWaveData(const Buffer: Pointer; BufferSize: DWORD; var NumLoops: DWORD): DWORD; override;
    procedure DoStop; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PlayStream(Stream: TStream; LoopCount: Integer=MaxInt);
    procedure Stop;

    property SpeedFactor: Single read FSpeedFactor write SetSpeedFactor;

    property OnStop: TNotifyEvent read FOnStop write FOnStop;
    property OnData: TBisStockAudioPlayerDataEvent read FOnData write FOnData;
  end;

  TBisAudioMixer=class(TAudioMixer)
  end;

  TBisWave=class(TWave)
  end;

  TBisWaveConverter=class(TWaveConverter)
  end;

  TBisACMDrivers=class(TWaveACMDrivers)
  end;

implementation

uses SysUtils;

{ TBisLiveAudioRecorder }

constructor TBisLiveAudioRecorder.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WaveThreadName:=Copy(ClassName,5,Length(ClassName)-4);
end;

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

procedure TBisLiveAudioRecorder.DoActivate;
begin
  inherited DoActivate;
  FStarting:=false;
end;

procedure TBisLiveAudioRecorder.DoDeactivate;
begin
  inherited DoDeactivate;
  FStopping:=false;
end;

procedure TBisLiveAudioRecorder.Start(Wait: Boolean);
begin
  if not Active and not FStarting and not FStopping then begin
    FStarting:=true;
    Active:=true;
    if Wait then
      WaitForStart;
  end;
end;

procedure TBisLiveAudioRecorder.Stop(Wait: Boolean);
begin
  if Active and not FStopping and not FStarting then begin
    FStopping:=true;
    Active:=false;
    if Wait then
      WaitForStop;
  end;
end;

{ TBisLiveAudioPlayer }

constructor TBisLiveAudioPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WaveThreadName:=Copy(ClassName,5,Length(ClassName)-4);
end;

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

procedure TBisLiveAudioPlayer.DoActivate;
begin
  inherited DoActivate;
  FStarting:=false;
end;

procedure TBisLiveAudioPlayer.DoDeactivate;
begin
  inherited DoDeactivate;
  FStopping:=false;
end;

procedure TBisLiveAudioPlayer.Start(Wait: Boolean=false);
begin
  if not Active and not FStarting and not FStopping then begin
    FStarting:=true;
    Active:=true;
    if Wait then
      WaitForStart;
  end;
end;

procedure TBisLiveAudioPlayer.Stop(Wait: Boolean=false);
begin
  if Active and not FStopping and not FStarting then begin
    FStopping:=true;
    Active:=false;
    if Wait then
      WaitForStop;
  end;
end;

{ TBisStockAudioPlayer }

constructor TBisStockAudioPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCounter:=0;
  FSpeedFactor:=1.0;
end;

destructor TBisStockAudioPlayer.Destroy;
begin
  Stop;
  inherited Destroy;
end;

procedure TBisStockAudioPlayer.DoActivate;
begin
  inherited DoActivate;
  Inc(FCounter);
end;

procedure TBisStockAudioPlayer.DoDeactivate;
begin
  inherited DoDeactivate;
  if (FCounter<FLoopCount) and not FStopped then begin
    if Assigned(FStream) then begin
      inherited PlayStream(FStream);
    end;
  end else
    DoStop; 
end;

procedure TBisStockAudioPlayer.DoStop;
begin
  if Assigned(FOnStop) then
    FOnStop(Self);
end;

function TBisStockAudioPlayer.GetActive: Boolean;
begin
  Result:=inherited GetActive;
end;

function TBisStockAudioPlayer.GetWaveData(const Buffer: Pointer; BufferSize: DWORD; var NumLoops: DWORD): DWORD;
begin
  Result:=inherited GetWaveData(Buffer,BufferSize,NumLoops);
  if Assigned(FOnData) then
    FOnData(Self,Buffer,Result);
end;

procedure TBisStockAudioPlayer.GetWaveFormat(var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
begin
  inherited GetWaveFormat(pWaveFormat,FreeIt);
  if Assigned(pWaveFormat) then
    pWaveFormat.nSamplesPerSec:=Round(FSpeedFactor*pWaveFormat.nSamplesPerSec);
end;

procedure TBisStockAudioPlayer.PlayStream(Stream: TStream; LoopCount: Integer);
begin
  Stop;
  WaitForStop;
  if not Active then begin
    FCounter:=0;
    FLoopCount:=LoopCount;
    FStream:=Stream;
    FStopped:=false;
    inherited PlayStream(Stream);
    WaitForStart;
  end;
end;

procedure TBisStockAudioPlayer.SetSpeedFactor(const Value: Single);
begin
  FSpeedFactor:=Value;
end;

procedure TBisStockAudioPlayer.Stop;
begin
  if Active then begin
    FStopped:=true;
    inherited Stop;
  end;
end;

end.
