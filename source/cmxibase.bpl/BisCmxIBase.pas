unit BisCmxIBase;

interface

uses BisConnectionModules;

procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;

exports
  InitConnectionModule;

implementation

uses BisCmxIBaseConnection;

procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;
begin
  AModule.ConnectionClass:=TBisCmxIBaseConnection;
end;

end.
