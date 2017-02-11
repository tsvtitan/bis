unit BisOmStd;

interface

uses BisObjectModules;

procedure InitObjectModule(AModule: TBisObjectModule); stdcall;

exports
  InitObjectModule;

implementation

uses BisOmStdSystem, BisOmStdSysUtils, BisOmStdClasses,
     BisOmStdControls, BisOmStdForms, BisOmStdDialogs;

procedure InitObjectModule(AModule: TBisObjectModule); stdcall;
begin
  with AModule.ScriptUnits do begin
    AddClass(TBisSystemScriptUnit);
    AddClass(TBisSysUtilsScriptUnit);
    AddClass(TBisClassesScriptUnit);
    AddClass(TBisControlsScriptUnit);
    AddClass(TBisFormsScriptUnit);
    AddClass(TBisDialogsScriptUnit);
  end;
end;

end.
