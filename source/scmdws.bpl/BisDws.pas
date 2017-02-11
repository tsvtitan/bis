unit BisDws;

interface

uses BisScriptModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitScriptModule(AModule: TBisScriptModule); stdcall;

exports
  InitScriptModule;

implementation

uses BisDwsScriptIface;

procedure InitScriptModule(AModule: TBisScriptModule); stdcall;
begin
  AModule.ScriptClass:=TBisDwsScriptIface;
end;

end.