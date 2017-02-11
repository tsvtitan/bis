program ide;

uses
  Forms,
  ide_editor in 'ide_editor.pas' {editor},
  ide_debugoutput in 'ide_debugoutput.pas' {debugoutput};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Teditor, editor);
  Application.CreateForm(Tdebugoutput, debugoutput);
  Application.Run;
end.
