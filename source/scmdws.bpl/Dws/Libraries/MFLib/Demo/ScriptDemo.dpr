program ScriptDemo;

uses
  Forms,
  ScriptDemoWin in 'ScriptDemoWin.pas' {frmScriptDemo},
  mwPasToRtf in 'mwPasToRtf.pas',
  ScriptDemoTest in 'ScriptDemoTest.pas' {frmTest};

{$R *.RES}

begin
  Application.Title := 'ScriptDemo';
  Application.CreateForm(TfrmScriptDemo, frmScriptDemo);
  Application.CreateForm(TfrmTest, frmTest);
  Application.Run;
end.
