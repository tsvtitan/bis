(*
  This file is a part of New Audio Components package v. 1.4
  Copyright (c) 2002-2008, Andrei Borovsky. All rights reserved.
  See the LICENSE file for more details.
  You can contact me at anb@symmetrica.net
*)

(* $Id: ACS_DXAudio.pas 387 2008-02-18 07:32:59Z andrei.borovsky $ *)

unit ACS_DXAudio;

(* Title: ACS_DXAudio
    Components which deal with audio hardware I/O using the DirectX API. *)

interface

uses
  SysUtils, Classes, Forms, ACS_Types, ACS_Classes, Windows, DSWrapper, _DirectSound;

{$DEFINE USE_EXTENDED_SPEC_FOR_24_BPS }

const

  DS_BUFFER_SIZE = $10000; // Size in frames, not in bytes;
  DS_POLLING_INTERVAL = 200; //milliseconds

type

  TUnderrunEvent = procedure(Sender : TComponent) of object;
  TOverrunEvent = procedure(Sender : TComponent) of object;

  (* Class: TDXAudioOut
      Performs audio playback using the DirectX API.
      Descends from <TAuOutput>. *)

  TDXAudioOut = class(TAuOutput)
  private
    Freed : Boolean;
    DSW : DSoundWrapper;
    Devices : DSW_Devices;
    Chan, SR, BPS : Integer;
    EndOfInput, StartInput : Boolean;
    Buf : PBuffer8;
    FDeviceNumber : Integer;
    FDeviceCount : Integer;
    _BufSize : Integer;
    FBufferSize : Integer;
    FillByte : Byte;
    FUnderruns, _TmpUnderruns : LongWord;
    FOnUnderrun : TUnderrunEvent;
    procedure SetDeviceNumber(i : Integer);
    function GetDeviceName(Number : Integer) : String;
    function GetVolume : Integer;
    procedure SetVolume(value : Integer);
  protected
    procedure Done; override;
    function DoOutput(Abort : Boolean):Boolean; override;
    procedure Prepare; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Pause;
    procedure Resume;
    (* Property: DeviceCount
         This read only property returns the number of logical output DirectSound devices. *)
    property DeviceCount : Integer read FDeviceCount;
    (* Property: DeviceName
         This read only array property returns the name of the device
         specified by its number. Valid numbers range from 0 to
         <DeviceCount> - 1. *)
    property DeviceName[Number : Integer] : String read GetDeviceName;
    (* Property: Underruns
         This read only property returns the number of internal buffer
         underruns that have occurred during playback. *)
    property Underruns : LongWord read FUnderruns;
    (* Property: BufferSize
         Use this property to set the component's internal buffer size if the
         default one doesn't suit you. *)
    property BufferSize : Integer read FBufferSize write FBufferSize;
    (* Property: Volume
         Use this property to set or get the volume of the sound being played.
         The default value is 0 which corresponds to the original volume of
         the sound. Valid values range from -10000 (silence) to 0. The Volume
         property allows you to make the played sound softer than the original
         one, but not louder. *)
    property Volume : Integer read GetVolume write SetVolume;
  published
    (* Property: DeviceNumber
         Use this property to select the playback device by number. The
         default value is 0 which corresponds to the default audio output
         device in your system. Valid numbers range from 0 to <DeviceCount> -
         1. *)
    property DeviceNumber : Integer read FDeviceNumber write SetDeviceNumber;
    (* Property: OnUnderrun
         OnUnderrun event is raised when the component has run out of data.
         This can happen if the component receives data at slow rate from a
         slow CD-ROM unit or a network link. You will also get OnUnderrun
         event when unpausing paused playback (this is a normal situation).
         Usually TDXAudioOut successfully recovers from underruns by itself,
         but this causes pauses in playback so if you start to receive
         OnUnderrun events, you may try to increase the speed rate of data
         passing to the component, if you can. Yo can check the <Underruns>
         property for the total number of underruns. *)
    property OnUnderrun : TUnderrunEvent read FOnUnderrun write FOnUnderrun;
  end;

  (* Class: TDXAudioIn
      Performs audio recording from a sound card using the DirectX API.
      Descends from <TAuInput>. *)

  TDXAudioIn = class(TAuInput)
  private
    DSW : DSoundWrapper;
    Devices : DSW_Devices;
    _BufSize : Integer;
    Buf : PBuffer8;
    FDeviceNumber : Integer;
    FDeviceCount : Integer;
    FBPS, FChan, FFreq : LongWord;
    FOpened : Integer;
    FSamplesToRead : Int64;
    FRecTime : Integer;
    FOverruns : LongWord;
    FOnOverrun : TOverrunEvent;
    procedure SetDeviceNumber(i : Integer);
    function GetDeviceName(Number : Integer) : String;
    procedure OpenAudio;
    procedure CloseAudio;
    procedure SetRecTime(aRecTime : Integer);
  protected
    function GetTotalTime : LongWord; override;
    function GetTotalSamples : Int64; override;
    function GetBPS : LongWord; override;
    function GetCh : LongWord; override;
    function GetSR : LongWord; override;
    procedure GetDataInternal(var Buffer : Pointer; var Bytes : LongWord); override;
    procedure InitInternal; override;
    procedure FlushInternal; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure _Pause; override;
    procedure _Resume; override;
    (* Property: DeviceCount
         This read only property returns the number of logical DirectSound
         input devices. *)
    property DeviceCount : Integer read FDeviceCount;
    (* Property: DeviceName[Number : Integer]
         This read only array property returns the name of the device
         specified by its number. Valid numbers range from 0 to
         <DeviceCount> - 1. *)
    property DeviceName[Number : Integer] : String read GetDeviceName;
    (* Property: Overruns
         This read only property returns the number of internal buffer
         overruns that have occurred during recording. *)
    property Overruns : LongWord read FOverruns;
  published
    (* Property: SamplesToRead
         Use this property to set the number of samples (frames) the component
         should record. If you set this property value to -1 the component
         will be endlessly recording until you stop it. *)
    property SamplesToRead : Int64 read FSamplesToRead write FSamplesToRead;
    (* Property: DeviceNumber
         Use this property to select the recording device by number. The
         property default value is 0 which corresponds to the default audio
         input device in your system. Valid numbers range from 0 to
         <DeviceCount> - 1. *)
    property DeviceNumber : Integer read FDeviceNumber write SetDeviceNumber;
    (* Property: InBitsPerSample
        Use this property to set the number of bits per sample in the audio
        stream the component will provide. Possible values are 8, 16, and 24
        (the last one depends on the capabilities of your hardware). *)
    property InBitsPerSample : LongWord read GetBPS write FBPS stored True;
    (* Property: InChannels
        Use this property to set the number of channels in the audio stream
        the component will provide. Possible values are 1 (mono), and 2
        (stereo). *)
    property InChannels : LongWord read GetCh write FChan stored True;
    (* Property: InSampleRate
        Use this property to set the sample rate of the audio stream the
        component will provide. Possible values range from 4000 to 128000
        (depends on the capabilities of your hardware). *)
    property InSampleRate : LongWord read GetSR write FFreq stored True;
    (* Property: RecTime
         Use this property to set the recording duration (in seconds). If set
         this property overrides the value of <BytesToRead>. If you set this
         property value to -1 (the default) the component will be endlessly
         recording until you stop it. *)
    property RecTime : Integer read FRecTime write SetRecTime;
    (* Property: OnOverrun
         OnOverrun event is raised when this component provides data faster
         than the rest of audio-processing chain can consume. It indicates
         that some data is lost. You may also get OnOverrun event when
         unpausing paused recording (this is a normal situation). To get the
         total number of overruns read the <Overruns> property. *)
    property OnOverrun : TOverrunEvent read FOnOverrun write FOnOverrun;
  end;

implementation

function _Min(x1, x2 : Integer) : Integer;
begin
  if x1 < x2 then
    Result := x1
  else
    Result := x2;
end;

procedure TDXAudioOut.Prepare;
var
  Res : HResult;
  Wnd : HWND;
  Form : TForm;
  FormatExt : TWaveFormatExtensible;
begin
  Freed := False;
  if (FDeviceNumber >= FDeviceCount) then raise EAuException.Create('Invalid device number');
  FInput.Init;
  Chan := FInput.Channels;
  SR := FInput.SampleRate;
  BPS := FInput.BitsPerSample;
  DSW_Init(DSW);
  Res := DSW_InitOutputDevice(DSW, @(Devices.dinfo[FDeviceNumber].guid));
  if Res <> 0 then raise EAuException.Create('Failed to create DirectSound device');
  if Owner is TForm then
  begin
    Form := Owner as TForm;
    Wnd := Form.Handle;
  end else Wnd := 0;
  _BufSize := FBufferSize*(BPS shr 3)*Chan;
  GetMem(Buf, _BufSize);
  if BPS <> 8 then
    FillByte := 0
  else
    FillByte := 128;
//    Res := DSW_InitOutputBuffer(DSW, Wnd, BPS, SR, Chan, _BufSize);
      FillChar(FormatExt, SizeOf(FormatExt), 0);

{$IFDEF USE_EXTENDED_SPEC_FOR_24_BPS }
    if (Chan < 3) and (BPS <> 24) then
{$ENDIF}

{$IFNDEF USE_EXTENDED_SPEC_FOR_24_BPS }
     if Chan < 3 then
{$ENDIF}

    begin
      FormatExt.Format.wFormatTag := 1; //WAVE_FORMAT_PCM;
      FormatExt.Format.cbSize := 0;
    end else
    begin
      FormatExt.Format.wFormatTag := WAVE_FORMAT_EXTENSIBLE;
      FormatExt.Format.cbSize := SizeOf(FormatExt) - SizeOf(FormatExt.Format);
      FormatExt.SubFormat := KSDATAFORMAT_SUBTYPE_PCM;
      if Chan = 2 then
         FormatExt.dwChannelMask := $3;
      if Chan = 6 then
        FormatExt.dwChannelMask := $3F;
      if Chan = 8 then
        FormatExt.dwChannelMask := $FF;
    end;
    FormatExt.Format.nChannels := Chan;
    FormatExt.Format.nSamplesPerSec := SR;
    FormatExt.Format.wBitsPerSample := BPS;
    FormatExt.Format.nBlockAlign := Chan*BPS shr 3;
    FormatExt.Format.nAvgBytesPerSec :=  SR*FormatExt.Format.nBlockAlign;
 //   FormatExt.wValidBitsPerSample := BPS;
//    FormatExt.wSamplesPerBlock := 0;
//   FormatExt.wReserved := 0;
//    FormatExt.SubFormat := 1;

    Res := DSW_InitOutputBufferEx(DSW, Wnd, FormatExt, _BufSize);
  if Res <> 0 then raise EAuException.Create('Failed to create DirectSound buffer' + IntToHex(Res, 8));
  StartInput := True;
  EndOfInput := False;
  _TmpUnderruns := 0;
end;

procedure TDXAudioOut.Done;
begin
  if not Freed then
  begin
    DSW_Term(DSW);
    FreeMem(Buf);
  end;
  Finput.Flush;
  Freed := True;
end;

function TDXAudioOut.DoOutput;
var
  Len, lb, counter : LongWord;
//  Res : HRESULT;
  PlayTime, CTime : LongWord;
begin
  Result := True;
  if not Busy then Exit;
  if not CanOutput then
  begin
    Result := False;
    Exit;
  end;
  if StartInput then
  begin
    Len := FInput.FillBuffer(Buf, _BufSize, EndOfInput);
    DSW_WriteBlock(DSW, @Buf[0], Len);
    DSW_StartOutput(DSW);
    StartInput := False;
  end;
  if Abort then
  begin
    DSW_StopOutput(DSW);
    CanOutput := False;
    Result := False;
    Exit;
  end;
  if EndOfInput then
  begin
    CanOutput := False;
    PlayTime := Round(_BufSize/(Chan*(BPS div 8)*SR))*1000;
    CTime := 0;
    while CTime < PlayTime do
    begin
      Sleep(100);
      DSW_FillEmptySpace(DSW, FillByte);
      Inc(CTime, 100);
    end;
    DSW_StopOutput(DSW);
    Result := False;
    Exit;
  end;
  counter := 0;
  repeat
    Sleep(DS_POLLING_INTERVAL);
    DSW_QueryOutputSpace(DSW, lb);
    lb := lb - (lb mod DSW.dsw_BytesPerFrame);
    Inc(counter);
    if counter > 16 then
    begin
      FExceptionMessage := 'Audio output error';
      if Assigned(FOnThreadException) then
        EventHandler.PostGenericEvent(Self, FOnThreadException);
      Result := False;
      Exit;
    end;
  until lb <> 0;
  Len := FInput.FillBuffer(Buf, _Min(lb, _BufSize), EndOfInput);
  DSW_WriteBlock(DSW, @Buf[0], Len);
  if EndOfInput then
    DSW_FillEmptySpace(DSW, FillByte);
  if _TmpUnderruns <> DSW.dsw_OutputUnderflows then
  begin
    FUnderruns := DSW.dsw_OutputUnderflows;
    _TmpUnderruns := DSW.dsw_OutputUnderflows;
    DSW_StopOutput(DSW);
    DSW_FillEmptySpace(DSW, FillByte);
    if Assigned(FOnUnderrun) then
      EventHandler.PostGenericEvent(Self, FOnUnderrun);
    DSW_RestartOutput(DSW); //StartInput := True;
  end;
end;

constructor TDXAudioOut.Create;
begin
  inherited Create(AOwner);
  FBufferSize := DS_BUFFER_SIZE;
  DSW_EnumerateOutputDevices(@Devices);
  FDeviceCount := Devices.devcount;
end;

destructor TDXAudioOut.Destroy;
begin
  inherited Destroy;
end;

procedure TDXAudioOut.Pause;
begin
  inherited Pause;
  if EndOfInput then Exit;
  DSW_StopOutput(DSW);
end;

procedure TDXAudioOut.Resume;
begin
  if EndOfInput then Exit;
  DSW_RestartOutput(DSW);
  inherited Resume;
end;

procedure TDXAudioOut.SetDeviceNumber(i : Integer);
begin
  FDeviceNumber := i
end;

function TDXAudioOut.GetDeviceName(Number : Integer) : String;
begin
  if (Number < FDeviceCount) then Result := PChar(@(Devices.dinfo[Number].Name[0]))
  else Result := '';
end;

constructor TDXAudioIn.Create;
begin
  inherited Create(AOwner);
  FBPS := 8;
  FChan := 1;
  FFreq := 8000;
  FSize := -1;
  FRecTime := -1;
  FSamplesToRead := -1;
//  if not (csDesigning in ComponentState) then
//  begin
//    if not LibdswLoaded then
//    raise EACSException.Create('Library dswrapper.dll not found');
//  end;
  DSW_EnumerateInputDevices(@Devices);
  FDeviceCount := Devices.devcount;
end;

destructor TDXAudioIn.Destroy;
begin
  DSW_Term(DSW);
  inherited Destroy;
end;

procedure TDXAudioIn.OpenAudio;
var
  Res : HResult;
  S : String;
begin
  if FOpened = 0 then
  begin
    DSW_Init(DSW);
    //if not Assigned(DSW_InitInputDevice) then raise EACSException.Create('Failed');
    Res := DSW_InitInputDevice(DSW, @(Devices.dinfo[FDeviceNumber].guid));
    if Res <> 0 then
    begin
      case res of
        DSERR_ALLOCATED : S := 'DSERR_ALLOCATED';
        DSERR_INVALIDPARAM : S := 'DSERR_INVALIDPARAM';
        DSERR_INVALIDCALL : S := 'DSERR_INVALIDCALL';
        DSERR_GENERIC : S := 'DSERR_GENERIC';
        DSERR_BADFORMAT : S := 'DSERR_BADFORMAT';
        DSERR_UNSUPPORTED : S:= 'DSERR_UNSUPPORTED';
        DSERR_NODRIVER : S := 'DSERR_NODRIVER';
        DSERR_ALREADYINITIALIZED : S := 'DSERR_ALREADYINITIALIZED';
        else S := 'Unknown';
      end;
      raise EAuException.Create('Failed to create DirectSound device: ' + S);
    end;
    _BufSize := DS_BUFFER_SIZE*(FBPS shr 3)*FChan;
    GetMem(Buf, _BufSize);
    Res := DSW_InitInputBuffer(DSW, FBPS, FFreq, FChan, _BufSize);
    if Res <> 0 then raise EAuException.Create('Failed to create DirectSound buffer');
  end;
  Inc(FOpened);
end;

procedure TDXAudioIn.CloseAudio;
begin
  if FOpened = 1 then
  begin
    DSW_Term(DSW);
    FreeMem(Buf);
  end;
  if FOpened > 0 then Dec(FOpened);
end;

function TDXAudioIn.GetBPS;
begin
  Result := FBPS;
end;

function TDXAudioIn.GetCh;
begin
  Result := FChan;
end;

function TDXAudioIn.GetSR;
begin
  Result := FFreq;
end;

procedure TDXAudioIn.InitInternal;
begin
  if Busy then raise EAuException.Create('The component is busy');
  if (FDeviceNumber >= FDeviceCount) then raise EAuException.Create('Invalid device number');
{$WARNINGS OFF}
  if FRecTime > 0 then FSamplesToRead := FRecTime*FFreq;
{$WARNINGS ON}
  BufEnd := 0;
  BufStart := 1;
  FPosition := 0;
  Busy := True;
  FSampleSize := FChan*FBPS div 8;
  if FSamplesToRead > 0 then
    FSize := FSamplesToRead*FSampleSize
  else
    FSize := -1;
  OpenAudio;
  DSW_StartInput(DSW);
end;

procedure TDXAudioIn.FlushInternal;
begin
  DSW_StopInput(DSW);
  CloseAudio;
  Busy := False;
end;

procedure TDXAudioIn.GetDataInternal;
var
  l : INteger;
begin
  if not Busy then  raise EAuException.Create('The Stream is not opened');
  if  (FSamplesToRead >=0) and (FPosition >= FSize) then
  begin
    Buffer := nil;
    Bytes := 0;
    Exit;
  end;
  if BufStart >= BufEnd then
  begin
    BufStart := 0;
    Sleep(DS_POLLING_INTERVAL);
    DSW_QueryInputFilled(DSW, l);
    if l > _BufSize then
    begin
      l := _BufSize; (* We have lost some data.
                        Generally this shouldn't happen. *)
      Inc(FOverruns);
      if Assigned(FOnOverrun) then
        EventHandler.PostGenericEvent(Self, FOnOverrun);
    end;
//    l := l - (l mod 1024);
    DSW_ReadBlock(DSW, @Buf[0], l);
    BufEnd := l;
  end;
  if Bytes > (BufEnd - BufStart) then
    Bytes := BufEnd - BufStart;
  if (FSize > 0) and (Bytes > FSize - FPosition) then
    Bytes := FSize - FPosition;
  Buffer := @Buf[BufStart];
  Inc(BufStart, Bytes);
  Inc(FPosition, Bytes);
end;

procedure TDXAudioIn.SetRecTime;
begin
  FRecTime := aRecTime;
{$WARNINGS OFF}
  if FRecTime >= 0 then FSamplesToRead := FRecTime*FFreq
  else FSamplesToRead := -1;
 {$WARNINGS ON}

end;

procedure TDXAudioIn.SetDeviceNumber(i : Integer);
begin
  FDeviceNumber := i
end;

function TDXAudioIn.GetDeviceName(Number : Integer) : String;
begin
  if (Number < FDeviceCount) then Result := PChar(@(Devices.dinfo[Number].Name[0]))
  else Result := '';
end;

function TDXAudioIn.GetTotalTime : LongWord;
var
  BytesPerSec : Integer;
begin
  BytesPerSec := FFreq*FSampleSize;
  if FSamplesToRead < 0 then Result := 0
  else
  Result := Round(FSamplesToRead/BytesPerSec);
end;

function TDXAudioIn.GetTotalSamples : Int64;
begin
  Result := FSamplesToRead;
end;


procedure TDXAudioIn._Pause;
begin
  DSW_StopInput(DSW);
end;

procedure TDXAudioIn._Resume;
begin
  DSW_StartInput(DSW);
end;

procedure TDXAudioOut.SetVolume;
begin
  dsw_SetVolume(DSW, value);
end;

function TDXAudioOut.GetVolume;
begin
  dsw_GetVolume(DSW, Result);
end;

end.
