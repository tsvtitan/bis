unit BisCmxOra;

interface

uses BisConnectionModules;

procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;

exports
  InitConnectionModule;

implementation

uses BisCmxOraConnection;

procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;
begin
  AModule.ConnectionClass:=TBisCmxOraConnection;
end;

end.
