program leaks;

uses
  Forms,
  UnitLeak in 'UnitLeak.pas' {FormLeaks};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormLeaks, FormLeaks);
  Application.Run;
end.
