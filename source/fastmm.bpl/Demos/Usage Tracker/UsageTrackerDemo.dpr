program UsageTrackerDemo;

uses
  FastMM4 in '..\..\FastMM4.pas',
  FastMM4Messages in '..\..\FastMM4Messages.pas',
  Forms,
  DemoForm in 'DemoForm.pas' {fDemo};

{$R *.res}

{Enable large address space support for this demo}
{$SetPEFlags $20}

begin
  ReportMemoryLeaksOnShutdown:=true;
  Application.Initialize;
  Application.CreateForm(TfDemo, fDemo);
  Application.Run;
end.
