program sip;

uses
  Forms,
  SipClientFm in 'SipClientFm.pas' {SipClientForm},
  IdUDPServer in '..\..\omnet.bpl\Indy\Core\IdUDPServer.pas',
  IdUDPBase in '..\..\omnet.bpl\Indy\Core\IdUDPBase.pas',
  BisCrypter in '..\..\core.bpl\BisCrypter.pas',
  BisSip in 'BisSip.pas',
  BisUtils in 'BisUtils.pas',
  BisSdp in 'BisSdp.pas',
  BisRtp in 'BisRtp.pas',
  WavePlayers in '..\..\omaudio.bpl\WaveAudio\WavePlayers.pas',
  Acm in '..\..\omaudio.bpl\AcmComponents\Acm.pas',
  msacm in '..\..\omaudio.bpl\AcmComponents\msacm.pas',
  WaveUtils in '..\..\omaudio.bpl\WaveAudio\WaveUtils.pas',
  BisSipPhone in 'BisSipPhone.pas',
  WaveStorage in '..\..\omaudio.bpl\WaveAudio\WaveStorage.pas',
  IdDNSResolver in '..\..\omnet.bpl\Indy\Protocols\IdDNSResolver.pas',
  BisIPUtils in 'BisIPUtils.pas',
  IpTypes in '..\..\objects.bpl\IPHlpApi\Pas\IpTypes.pas',
  IpExport in '..\..\objects.bpl\IPHlpApi\Pas\IpExport.pas',
  IpFunctions in '..\..\objects.bpl\IPHlpApi\Pas\IpFunctions.pas',
  IpHlpApi in '..\..\objects.bpl\IPHlpApi\Pas\IpHlpApi.pas',
  IpIfConst in '..\..\objects.bpl\IPHlpApi\Pas\IpIfConst.pas',
  IpRtrMib in '..\..\objects.bpl\IPHlpApi\Pas\IpRtrMib.pas',
  BisDtmf in 'BisDtmf.pas',
  BisFileDirs in '..\..\core.bpl\BisFileDirs.pas',
  BisThread in 'BisThread.pas',
  BisWave in '..\..\omaudio.bpl\BisWave.pas',
  DTMF in 'DTMF.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSipClientForm, SipClientForm);
  Application.Run;
end.
