program testfreq;

uses
  Forms,
  MainFm in 'MainFm.pas' {MainForm},
  BisAudioWave in '..\BisAudioWave.pas',
  BisAudioSpectrum in '..\BisAudioSpectrum.pas',
  fftspec in '..\FftSpec\fftspec.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
