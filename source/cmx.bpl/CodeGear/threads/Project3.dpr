program Project3;

uses
  Forms,
  UnitThreads in 'UnitThreads.pas' {FormThreads};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormThreads, FormThreads);
  Application.Run;
end.
