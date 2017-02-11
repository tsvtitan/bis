unit BisDesignInit;

interface

uses BisIfaceModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;                                                      

exports
  InitIfaceModule;

implementation

uses BisCore, BisDesignConsts,
     BisDesignMainFm, BisDesignDataFirmTypesFm, BisDesignDataFirmsFm, BisDesignDataAccountsFm,
     BisDesignDataRolesFm, BisDesignDataRolesAndAccountsFm, BisDesignDataApplicationsFm,
     BisDesignDataInterfacesFm, BisDesignDataAccountRolesFm, BisDesignDataProfilesFm,
     BisDesignDataSessionsFm, BisDesignDataPermissionsFm, BisDesignDataApplicationInterfacesFm,
     BisDesignDataMenusFm, BisDesignDataReportsFm, BisDesignDataScriptsFm,
     BisDesignJournalActionsFm, BisDesignDataDocumentsFm, BisDesignDataConstsFm,
     BisDesignDataLocksFm, BisDesignDataLocalitiesFm, BisDesignDataStreetsFm,
     BisDesignDataTasksFm, BisDesignDataExchangesFm, 

     BisDesignDataFirmEditFm,

     BisDesignExchangeFm, BisDesignDataAlarmEditFm, BisDesignDataAlarmsFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule do begin

    if IsMainModule then
      Ifaces.AddClass(TBisDesignMainFormIface);

    Classes.Add(TBisDesignDataFirmTypesFormIface);
    Classes.Add(TBisDesignDataLocalitiesFormIface);
    Classes.Add(TBisDesignDataStreetsFormIface);
    Classes.Add(TBisDesignDataFirmsFormIface);
    Classes.Add(TBisDesignDataAccountsFormIface);
    Classes.Add(TBisDesignDataRolesFormIface);
    Classes.Add(TBisDesignDataApplicationsFormIface);
    Classes.Add(TBisDesignDataInterfacesFormIface);
    Classes.Add(TBisDesignDataAccountRolesFormIface);
    Classes.Add(TBisDesignDataProfilesFormIface);
    Classes.Add(TBisDesignDataSessionsFormIface);
    Classes.Add(TBisDesignDataPermissionsFormIface);
    Classes.Add(TBisDesignDataApplicationInterfacesFormIface);
    Classes.Add(TBisDesignDataRolesAndAccountsFormIface);
    Classes.Add(TBisDesignDataMenusFormIface);
    Classes.Add(TBisDesignDataConstsFormIface);
    Classes.Add(TBisDesignDataLocksFormIface);
    Classes.Add(TBisDesignDataTasksFormIface);
    Classes.Add(TBisDesignDataExchangesFormIface);

    Classes.Add(TBisDesignJournalActionsFormIface);

    Classes.Add(TBisDesignDataFirmInsertFormIface);

    Classes.Add(TBisDesignExchangeFormIface);
    Classes.Add(TBisDesignDataAlarmInsertFormIface);
    Classes.Add(TBisDesignDataAlarmsFormIface);

  end;
end;

end.
