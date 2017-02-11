unit MainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, mmSystem,

  BisAudioWave, BisAudioSpectrum;

type
  TMainForm = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditFreq1: TEdit;
    LabelFreq1: TLabel;
    Memo: TMemo;
    LabelFreq2: TLabel;
    EditFreq2: TEdit;
    ButtonClear: TButton;
    LabelThreshold: TLabel;
    EditThreshold: TEdit;
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
  private
    FRecorder: TBisAudioLiveRecorder;
    FSpectrum: TBisAudioSpectrum;

    procedure SpectrumDetect(Sender: TBisAudioSpectrum; const Freq: Word; const Level: Integer);
    procedure RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);
    procedure RecorderActivate(Sender: TObject);
    procedure RecorderDeactivate(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  MainForm: TMainForm;

implementation

uses WaveUtils;

{$R *.dfm}

{ TMainForm }

constructor TMainForm.Create(AOwner: TComponent);
var
  F: TWaveFormatEx;
  L: Cardinal;
  F1: TPCMFormat;
begin
  inherited Create(AOwner);

  FSpectrum:=TBisAudioSpectrum.Create;
  FSpectrum.WindowSize:=1024;
  FSpectrum.OnDetect:=SpectrumDetect;

  F1:=Mono8bit8000Hz;
  SetPCMAudioFormatS(@F,F1);
  
  L:=FSpectrum.WindowSize*F.nChannels*(F.wBitsPerSample div 8);
  L:=GetWaveAudioLength(@F,L);

  FRecorder:=TBisAudioLiveRecorder.Create(nil);
  FRecorder.DeviceID:=0;
  FRecorder.Async:=false;
//  FRecorder.BufferLength:=L;
  FRecorder.BufferLength:=400;
  FRecorder.BufferCount:=1;
  FRecorder.PCMFormat:=F1;

  FRecorder.OnData:=RecorderData;
  FRecorder.OnActivate:=RecorderActivate;
  FRecorder.OnDeactivate:=RecorderDeactivate;

  FSpectrum.SetFormat(FRecorder.PCMFormat);

end;

destructor TMainForm.Destroy;
begin
  FRecorder.Stop(true);
  FRecorder.Free;
  FSpectrum.Free;
  inherited Destroy;
end;

procedure TMainForm.RecorderActivate(Sender: TObject);
begin
  ButtonStart.Enabled:=false;
  ButtonStop.Enabled:=true;
end;

procedure TMainForm.RecorderDeactivate(Sender: TObject);
begin
  ButtonStart.Enabled:=true;
  ButtonStop.Enabled:=false;
end;

procedure TMainForm.RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);
begin
  FreeIt:=true;
  FSpectrum.Write(Buffer,BufferSize);
end;

procedure TMainForm.ButtonClearClick(Sender: TObject);
begin
  Memo.Clear;
end;

procedure TMainForm.ButtonStartClick(Sender: TObject);
begin
  FSpectrum.LowFreq:=StrToIntDef(EditFreq1.Text,300);
  FSpectrum.HighFreq:=StrToIntDef(EditFreq2.Text,500);
  FSpectrum.Threshold:=StrToIntDef(EditThreshold.Text,100);
  FRecorder.Start;
end;

procedure TMainForm.ButtonStopClick(Sender: TObject);
begin
  FRecorder.Stop;
end;

procedure TMainForm.SpectrumDetect(Sender: TBisAudioSpectrum; const Freq: Word; const Level: Integer);
begin
  Memo.Lines.Add(Format('Frequency = %d  Level = %d',[Freq,Level]));
end;


end.
