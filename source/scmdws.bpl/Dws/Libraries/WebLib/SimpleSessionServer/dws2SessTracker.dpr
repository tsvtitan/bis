program dws2SessTracker;

uses
  QForms,
  loTrackerClientMain in 'loTrackerClientMain.pas' {Form1},
  loTrackerClient in 'loTrackerClient.pas' {DataModule2: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDataModule2, DataModule2);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
