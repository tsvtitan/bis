unit BisUtil;

interface

uses BisModules, BisIfaceModules;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;                 

exports
  InitIfaceModule;

implementation

uses BisCore, BisUtilFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
var
  IsMainModule: Boolean;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  if IsMainModule then
    AModule.Ifaces.AddClass(TBisUtilMainFormIface);

  AModule.Ifaces.AddClass(TBisUtilFormIface);
end;

end.
