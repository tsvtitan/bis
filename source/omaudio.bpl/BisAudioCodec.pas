unit BisAudioCodec;

interface

uses Windows, Classes,
     ACS_Wave, ACS_WinMedia,

     BisCoreObjects;

const
  DefWavToWmaBitrate=128;

type

  TBisAudioCodec=class(TBisCoreObject)
  public
    FWaveIn: TWaveIn;
    FWmaOut: TWmaOut;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure WavToWma(InFileName, OutFileName: String; Bitrate: Integer=DefWavToWmaBitrate);
  end;

implementation

uses SysUtils, ActiveX;

{ TBisAudioCodec }

constructor TBisAudioCodec.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWaveIn:=TWaveIn.Create(Self);
  FWmaOut:=TWmaOut.Create(Self);
end;

destructor TBisAudioCodec.Destroy;
begin
  FWmaOut.Free;
  FWaveIn.Free;
  inherited Destroy;
end;

procedure TBisAudioCodec.WavToWma(InFileName, OutFileName: String; Bitrate: Integer);
begin
  FWaveIn.FileName:=InFileName;
  FWmaOut.FileName:=OutFileName;
  FWmaOut.DesiredBitrate:=Bitrate;
  FWmaOut.Input:=FWaveIn;
  FWmaOut.Run;
end;


end.
