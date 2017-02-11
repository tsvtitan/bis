unit BisIngit;

interface

uses BisMapModules, BisProviderModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitMapModule(AModule: TBisMapModule); stdcall;
procedure InitProviderModule(AModule: TBisProviderModule); stdcall;

exports
  InitMapModule,
  InitProviderModule;

implementation

uses BisIngitMapFm, BisIngitMapGetRouteDistancePrv;

procedure InitMapModule(AModule: TBisMapModule); stdcall;
begin
  AModule.MapClass:=TBisIngitMapFormIface;
end;

procedure InitProviderModule(AModule: TBisProviderModule); stdcall;
begin
  AModule.Providers.AddClass(TBisIngitMapGetRouteDistanceProvider);
end;

end.
