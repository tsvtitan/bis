program sip;

uses
  Forms,
  SipClientFm in 'SipClientFm.pas' {SipClientForm},
  BisSipClient in 'BisSipClient.pas',
  IdUDPServer in '..\..\omnet.bpl\Indy\Core\IdUDPServer.pas',
  IdUDPBase in '..\..\omnet.bpl\Indy\Core\IdUDPBase.pas',
  BisCrypter in '..\..\core.bpl\BisCrypter.pas',
  BisSip in 'BisSip.pas',
  BisUtils in 'BisUtils.pas',
  BisSipMessages in 'BisSipMessages.pas',
  BisSdp in 'BisSdp.pas',
  BisSipUtils in 'BisSipUtils.pas',
  BisRtp in 'BisRtp.pas',
  WavePlayers in '..\..\omaudio.bpl\WaveAudio\WavePlayers.pas',
  Acm in '..\..\omaudio.bpl\AcmComponents\Acm.pas',
  msacm in '..\..\omaudio.bpl\AcmComponents\msacm.pas',
  WaveUtils in '..\..\omaudio.bpl\WaveAudio\WaveUtils.pas',
  BisSipPhone in 'BisSipPhone.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSipClientForm, SipClientForm);
  Application.Run;
end.
