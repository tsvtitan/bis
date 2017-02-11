unit BisFtpClient;

interface

uses BisModules, BisIfaceModules;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;

implementation

uses BisFtpClientMainFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  MainIface:=AModule.Ifaces.AddClass(TBisFtpClientMainFormIface);
end;

end.
