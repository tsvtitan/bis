unit BisCmxMssql;

interface

uses BisConnectionModules;

procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;

exports
  InitConnectionModule;

implementation

uses BisCmxMssqlConnection;

procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;
begin
  AModule.ConnectionClass:=TBisCmxMsSqlConnection;
end;

end.
