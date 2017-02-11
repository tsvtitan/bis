unit BisRtpAcmDrivers;

interface

uses MMSystem,
     WaveAcmDrivers,
     BisRtp,
     BisAudioWave;

type
  TBisRtpAcmDrivers=class(TBisAudioAcmDrivers)
  public
    function PayloadTypeToFormatTag(PayloadType: TBisRtpPacketPayloadType): LongWord;
    function FormatToPayloadType(DriverFormat: TWaveAcmDriverFormat): TBisRtpPacketPayloadType;

    function FindFormat(DriverName, FormatName: String;
                        Channels: Word; SamplesPerSec: Longword; BitsPerSample: Word): TWaveAcmDriverFormat; overload;
    function FindFormat(PayloadType: TBisRtpPacketPayloadType;
                        Channels: Word; SamplesPerSec: Longword; BitsPerSample: Word): TWaveAcmDriverFormat; overload;
    function FindFormat(WaveFormat: PWaveFormatEx): TWaveAcmDriverFormat; overload;
  end;

implementation

{ TBisRtpAcmDrivers }

function TBisRtpAcmDrivers.PayloadTypeToFormatTag(PayloadType: TBisRtpPacketPayloadType): LongWord;
begin
  Result:=0;
  case PayloadType of
    ptPCMU: Result:=$0007;
    ptGSM: Result:=$0031;
    ptG723: Result:=$0043;
    ptPCMA: Result:=$0006;
  end;
end;

function TBisRtpAcmDrivers.FormatToPayloadType(DriverFormat: TWaveAcmDriverFormat): TBisRtpPacketPayloadType;
begin
  Result:=ptUnknown;
  if Assigned(DriverFormat) then begin
    if Assigned(DriverFormat.WaveFormat) then begin
      case DriverFormat.WaveFormat.wFormatTag of
        $0007: Result:=ptPCMU;
        $0031: Result:=ptGSM;
        $0043: Result:=ptG723;
        $0006: Result:=ptPCMA;
      end;
    end;
  end;
end;

function TBisRtpAcmDrivers.FindFormat(DriverName, FormatName: String;
                                      Channels: Word; SamplesPerSec: Longword; BitsPerSample: Word): TWaveAcmDriverFormat;
begin
  Result:=inherited FindFormat(DriverName,FormatName,Channels,SamplesPerSec,BitsPerSample);
end;

function TBisRtpAcmDrivers.FindFormat(PayloadType: TBisRtpPacketPayloadType;
                                      Channels: Word; SamplesPerSec: Longword; BitsPerSample: Word): TWaveAcmDriverFormat;
var
  FormatTag: LongWord;
begin
  Result:=nil;
  FormatTag:=PayloadTypeToFormatTag(PayloadType);
  if FormatTag>0 then
    Result:=inherited FindFormat('',FormatTag,Channels,SamplesPerSec,BitsPerSample);
end;

function TBisRtpAcmDrivers.FindFormat(WaveFormat: PWaveFormatEx): TWaveAcmDriverFormat;
begin
  Result:=nil;
  if Assigned(WaveFormat) then
    Result:=FindFormat('',WaveFormat.wFormatTag,WaveFormat.nChannels,WaveFormat.nSamplesPerSec,WaveFormat.wBitsPerSample);
end;

end.
