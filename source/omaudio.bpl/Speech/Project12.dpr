program Project12;

uses
  Forms,
  Unit15 in 'Unit15.pas' {Form15},
  BisSpeech in 'BisSpeech.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm15, Form15);
  Application.Run;
end.
