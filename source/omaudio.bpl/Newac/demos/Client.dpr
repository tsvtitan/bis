program Client;

uses
  Forms,
  ClientFm in 'ClientFm.pas' {ClientForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
