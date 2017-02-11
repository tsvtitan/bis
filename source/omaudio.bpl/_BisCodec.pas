unit BisCodec;

interface

uses Windows, Classes,
     ACS_Wave, ACS_WinMedia,

     BisCoreObjects;

const
  DefWavToWmaBitrate=128;

type

  TBisCodec=class(TBisCoreObject)
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

{ TBisCodec }

constructor TBisCodec.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWaveIn:=TWaveIn.Create(Self);
  FWmaOut:=TWmaOut.Create(Self);
end;

destructor TBisCodec.Destroy;
begin
  FWmaOut.Free;
  FWaveIn.Free;
  inherited Destroy;
end;

procedure TBisCodec.WavToWma(InFileName, OutFileName: String; Bitrate: Integer);
begin
  FWaveIn.FileName:=InFileName;
  FWmaOut.FileName:=OutFileName;
  FWmaOut.DesiredBitrate:=Bitrate;
  FWmaOut.Input:=FWaveIn;
  FWmaOut.Run;
end;


end.
