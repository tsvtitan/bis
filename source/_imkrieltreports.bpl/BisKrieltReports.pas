unit BisKrieltReports;

interface

uses BisModules, BisIfaceModules;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;

implementation

uses BisKrieltReportsFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  BisKrieltReportsIface:=AModule.Ifaces.AddClass(TBisKrieltReportsFormIface);
end;

end.
