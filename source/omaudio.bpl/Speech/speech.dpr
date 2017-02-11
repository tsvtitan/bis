program speech;

uses
  Forms,
  SpeechFm in 'SpeechFm.pas' {SpeechForm},
  BisSpeech in 'BisSpeech.pas',
  SqlExpr in 'SqlExpr.pas',
  DBXInterbaseReadOnlyMetaData in 'DBXInterbaseReadOnlyMetaData.pas',
  DbxInterbase in 'DbxInterbase.pas',
  DBXInterbaseMetaData in 'DBXInterbaseMetaData.pas',
  DBXInterbaseMetaDataReader in 'DBXInterbaseMetaDataReader.pas',
  DBXInterbaseMetaDataWriter in 'DBXInterbaseMetaDataWriter.pas',
  DBXDynalink in 'DBXDynalink.pas',
  DBXCommon in 'DBXCommon.pas',
  BisAudioWave in '..\BisAudioWave.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSpeechForm, SpeechForm);
  Application.Run;
end.
