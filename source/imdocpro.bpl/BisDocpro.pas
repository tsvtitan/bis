unit BisDocpro;

interface

uses BisIfaceModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;
                                       
implementation

uses BisDocproMainFm, BisDocproHbookViewsFm, BisDocproHbookPlansFm,
     BisDocproHbookDocsFm, BisDocproHbookPositionsFm, BisDocproHbookMotionsFm,
     BisDocproManagementFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  with AModule.Ifaces do begin
    MainIface:=TBisDocproMainFormIface(AddClass(TBisDocproMainFormIface));

    AddClass(TBisDocproHbookViewsFormIface);
    AddClass(TBisDocproHbookPlansFormIface);
    AddClass(TBisDocproHbookDocsFormIface);
    AddClass(TBisDocproHbookPositionsFormIface);
    AddClass(TBisDocproHbookMotionsFormIface);

    ManagementIface:=TBisDocproManagementFormIface(AddClass(TBisDocproManagementFormIface));
  end;
end;

end. 
