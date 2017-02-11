unit BisUtilsInit;

interface

uses BisModules, BisIfaceModules;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;                 

exports
  InitIfaceModule;

implementation

uses BisCore, BisUtilsFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
var
  IsMainModule: Boolean;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  if IsMainModule then
    AModule.Ifaces.AddClass(TBisUtilsMainFormIface);

  AModule.Ifaces.AddClass(TBisUtilsFormIface);
end;

end.
