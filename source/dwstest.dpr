program dwstest;

uses
  Forms,
  Unit5 in 'dwstest.exe\Unit5.pas' {Form5},
  NewUnit in 'dwstest.exe\NewUnit.pas' {NewForm},
  UnitInmport in 'dwstest.exe\UnitInmport.pas',
  BrowserFrm in 'dwstest.exe\BrowserFrm.pas' {BrowserForm},
  BisProgram in 'dwstest.exe\BisProgram.pas',
  BisSysUtilsUnit in 'dwstest.exe\BisSysUtilsUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
