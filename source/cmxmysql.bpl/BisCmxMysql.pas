unit BisCmxMysql;

interface

uses BisConnectionModules;

procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;

exports
  InitConnectionModule;

implementation

uses BisCmxMySqlConnection;

procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;
begin
  AModule.ConnectionClass:=TBisCmxMySqlConnection;
end;

end.
