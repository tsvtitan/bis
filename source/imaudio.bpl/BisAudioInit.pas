unit BisAudioInit;

interface

uses BisModules, BisIfaceModules;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;                 

exports
  InitIfaceModule;

implementation

uses BisAudioDataSampleVoicesFm, BisAudioTextFm, BisAudioFormatFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  with AModule do begin
    Classes.Add(TBisAudioDataSampleVoicesFormIface);
    Classes.Add(TBisAudioTextFormIface);
    Classes.Add(TBisAudioFormatFormIface);
  end;
end;

end.
