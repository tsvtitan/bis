program Project12;

uses
  Forms,
  Unit15 in 'Unit15.pas' {MainForm},
  IBStoredProc in 'IBStoredProc.pas',
  DB in 'DB.pas',
  IBCustomDataSet in 'IBCustomDataSet.pas',
  IBDatabase in 'IBDatabase.pas',
  IBSQL in 'IBSQL.pas',
  IBBlob in 'IBBlob.pas',
  BisThreads in '..\..\core.bpl\BisThreads.pas',
  BisUtils in '..\..\core.bpl\BisUtils.pas',
  Unit1 in 'Unit1.pas' {WaitForm},
  Classes in 'Classes.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:=true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TWaitForm, WaitForm);
  Application.Run;
  ApplicationFinished:=true;
end.