unit BisFotom;

interface

uses BisModules, BisIfaceModules;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;                 

exports
  InitIfaceModule;

implementation

uses BisFotomMainFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  MainIface:=AModule.Ifaces.AddClass(TBisFotomMainFormIface);
end;

end.
