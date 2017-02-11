program SimpleDemo;

uses
  Forms,
  SimpleDemoWin in 'SimpleDemoWin.pas' {FSimpleDemo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFSimpleDemo, FSimpleDemo);
  Application.Run;
end.
