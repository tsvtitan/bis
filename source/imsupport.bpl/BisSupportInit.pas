unit BisSupportInit;

interface

uses BisIfaceModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;                 

exports
  InitIfaceModule;

implementation

uses BisCore,
     BisSupportFm, BisSupportMainFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
var
  IsMainModule: Boolean;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule.Ifaces do begin
    if IsMainModule then
      AddClass(TBisSupportMainFormIface);
  end;
  AModule.Classes.Add(TBisSupportFormIface);
end;

end.
