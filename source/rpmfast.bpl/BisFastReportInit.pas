unit BisFastReportInit;

interface

uses BisReportModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitReportModule(AModule: TBisReportModule); stdcall;

exports
  InitReportModule;

implementation

uses BisFastReportFm, BisFastReportEditorFm;

procedure InitReportModule(AModule: TBisReportModule); stdcall;
begin
  AModule.ReportClass:=TBisFastReportFormIface;
  AModule.ReportEditorClass:=TBisFastReportEditorFormIface;
end;

end.
