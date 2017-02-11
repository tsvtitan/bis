program DwsDemo;

uses
  Forms,
  DwsDemoWin in 'DwsDemoWin.pas' {FDwsDemo},
  mwPasToRtf in 'mwPasToRtf.pas',
  DwsDemoTest in 'DwsDemoTest.pas' {FTest};

{$R *.RES}

begin
  Application.Title := 'ScriptDemo';
  Application.CreateForm(TFDwsDemo, FDwsDemo);
  Application.CreateForm(TFTest, FTest);
  Application.Run;
end.
