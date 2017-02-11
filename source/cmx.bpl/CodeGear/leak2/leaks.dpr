program leaks;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  BisLeak in 'BisLeak.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:=true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
