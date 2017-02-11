unit BisMapInit;

interface

uses BisModules, BisIfaceModules;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;                 

exports
  InitIfaceModule;

implementation

uses BisCore, BisMapConsts,
     BisMapDataMapObjectsFm, BisMapDataMapRoutesFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule do begin
    Classes.Add(TBisMapDataMapObjectsFormIface);
    Classes.Add(TBisMapDataMapRoutesFormIface);
  end;
end;

end.
