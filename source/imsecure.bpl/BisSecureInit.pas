unit BisSecureInit;

interface

uses BisIfaceModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;

implementation

uses BisSecureMainFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  AModule.Ifaces.AddClass(TBisSecureMainFormIface);
end;

end.
