program sip;

uses
  Forms,
  SipClientFm in 'SipClientFm.pas' {SipClientForm},
  IpRtrMib in '..\..\objects.bpl\IPHlpApi\Pas\IpRtrMib.pas',
  IpTypes in '..\..\objects.bpl\IPHlpApi\Pas\IpTypes.pas',
  IpFunctions in '..\..\objects.bpl\IPHlpApi\Pas\IpFunctions.pas',
  IpHlpApi in '..\..\objects.bpl\IPHlpApi\Pas\IpHlpApi.pas',
  IpExport in '..\..\objects.bpl\IPHlpApi\Pas\IpExport.pas',
  BisBase64 in '..\..\core.bpl\BisBase64.pas',
  DIMime in '..\..\objects.bpl\DIMime\Source\DIMime.pas',
  BisUtils in '..\..\core.bpl\BisUtils.pas',
  BisNetUtils in '..\..\core.bpl\BisNetUtils.pas',
  IdDNSResolver in '..\..\omnet.bpl\Indy\Protocols\IdDNSResolver.pas',
  WaveUtils in '..\..\omaudio.bpl\WaveAudio\WaveUtils.pas',
  WavePlayers in '..\..\omaudio.bpl\WaveAudio\WavePlayers.pas',
  WaveRecorders in '..\..\omaudio.bpl\WaveAudio\WaveRecorders.pas',
  WaveStorage in '..\..\omaudio.bpl\WaveAudio\WaveStorage.pas',
  BisThreads in '..\..\core.bpl\BisThreads.pas',
  WaveAcmDrivers in '..\..\omaudio.bpl\waveaudio\WaveAcmDrivers.pas',
  WaveAcm in '..\..\omaudio.bpl\WaveAudio\WaveAcm.pas',
  WaveIO in '..\..\omaudio.bpl\waveaudio\WaveIO.pas',
  WaveOut in '..\..\omaudio.bpl\waveaudio\WaveOut.pas',
  BisLocks in '..\..\core.bpl\BisLocks.pas',
  BisObjects in '..\..\core.bpl\BisObjects.pas',
  BisObject in '..\..\core.bpl\BisObject.pas',
  BisObjectsIntf in '..\..\core.bpl\BisObjectsIntf.pas',
  BisObjectIntf in '..\..\core.bpl\BisObjectIntf.pas',
  BisExceptNotifier in 'BisExceptNotifier.pas',
  BisAudioWave in '..\..\omaudio.bpl\BisAudioWave.pas',
  BisAudioDtmf in '..\..\omaudio.bpl\BisAudioDtmf.pas',
  BisRtp in '..\BisRtp.pas',
  BisSdp in '..\BisSdp.pas',
  BisSip in '..\BisSip.pas',
  BisSipClient in '..\BisSipClient.pas',
  BisSipPhone in '..\BisSipPhone.pas',
  BisAudioSpectrum in '..\..\omaudio.bpl\BisAudioSpectrum.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSipClientForm, SipClientForm);
  Application.Run;
end.
