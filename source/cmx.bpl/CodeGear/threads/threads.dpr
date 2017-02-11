program threads;

uses
  Forms,
  UnitThreads in 'UnitThreads.pas' {FormThreads};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:=true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormThreads, FormThreads);
  Application.Run;
end.
