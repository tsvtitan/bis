program sppech;

uses
  Forms,
  SpeechFm in 'SpeechFm.pas' {SpeechForm},
  BisSpeech in 'BisSpeech.pas',
  BisWave in '..\BisWave.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSpeechForm, SpeechForm);
  Application.Run;
end.
