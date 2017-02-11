program Project22;

uses
  Forms,
  Unit22 in 'Unit22.pas' {Form22};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm22, Form22);
  Application.Run;
end.
