program Project11;

uses
  Forms,
  SipClientFm in 'SipClientFm.pas' {SipClientForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSipClientForm, SipClientForm);
  Application.Run;
end.
