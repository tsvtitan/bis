program Server;

uses
  Forms,
  ServerFm in 'ServerFm.pas' {ServerForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
