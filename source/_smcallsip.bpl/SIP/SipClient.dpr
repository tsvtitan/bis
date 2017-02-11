program SipClient;

uses
  Forms,
  SipClientFm in 'SipClientFm.pas' {SipClientForm},
  IdSipCore in 'src\IdSipCore.pas',
  IdSipRegistration in 'src\IdSipRegistration.pas',
  IdSipStackInterface in 'src\IdSipStackInterface.pas',
  BisSipStack in 'BisSipStack.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSipClientForm, SipClientForm);
  Application.Run;
end.
