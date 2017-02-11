program threads;

uses
  Forms,
  MainFm in 'MainFm.pas' {MainForm},
  BisThreads in '..\BisThreads.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
