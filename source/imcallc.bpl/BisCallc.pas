unit BisCallc;

interface

uses BisIfaceModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;

implementation

uses BisCallcMainFm,
     BisCallcHbookCurrencyFm, BisCallcHbookVariantsFm, BisCallcHbookAgreementsFm,
     BisCallcHbookAccountFirmsFm, BisCallcHbookGroupsFm, BisCallcHbookAccountGroupsFm,
     BisCallcHbookActionsFm, BisCallcHbookAccountActionsFm, BisCallcHbookResultsFm,
     BisCallcHbookActionResultsFm, BisCallcHbookStatusesFm, BisCallcHbookCasesFm,
     BisCallcHbookDebtorsFm, BisCallcHbookDealsFm, BisCallcHbookPaymentsFm,
     BisCallcHbookTasksFm, BisCallcHbookTaskDocumentsFm, BisCallcHbookPatternsFm,
     BisCallcTaskOperatorFm, BisCallcTaskLeaderFm, BisCallcTaskClerkFm, BisCallcTaskManagerFm,
     BisCallcHbookPlansFm,  BisCallcHbookPlanActionsFm, BisCallcImportFm,
     BisCallcHbookActionReportsFm, BisCallcTakeBellFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  with AModule.Ifaces do begin
    MainIface:=TBisCallcMainFormIface(AddClass(TBisCallcMainFormIface));

    AddClass(TBisCallcHbookCurrencyFormIface);
    AddClass(TBisCallcHbookVariantsFormIface);
    AddClass(TBisCallcHbookAgreementsFormIface);
    AddClass(TBisCallcHbookAccountFirmsFormIface);
    AddClass(TBisCallcHbookPatternsFormIface);
    AddClass(TBisCallcHbookGroupsFormIface);
    AddClass(TBisCallcHbookAccountGroupsFormIface);
    AddClass(TBisCallcHbookActionsFormIface);
    AddClass(TBisCallcHbookAccountActionsFormIface);
    AddClass(TBisCallcHbookResultsFormIface);
    AddClass(TBisCallcHbookActionResultsFormIface);
    AddClass(TBisCallcHbookStatusesFormIface);
    AddClass(TBisCallcHbookCasesFormIface);
    AddClass(TBisCallcHbookDebtorsFormIface);
    AddClass(TBisCallcHbookDealsFormIface);
    AddClass(TBisCallcHbookPaymentsFormIface);
    AddClass(TBisCallcHbookTasksFormIface);
    AddClass(TBisCallcHbookTaskDocumentsFormIface);
    AddClass(TBisCallcHbookPlansFormIface);
    AddClass(TBisCallcHbookPlanActionsFormIface);
    AddClass(TBisCallcHbookActionReportsFormIface);
    AddClass(TBisCallcTaskOperatorFormIface);
    AddClass(TBisCallcTaskLeaderFormIface);
    AddClass(TBisCallcTaskClerkFormIface);
    AddClass(TBisCallcTaskManagerFormIface);
    AddClass(TBisCallcImportFormIface);
    AddClass(TBisCallcTakeBellFormIface);
  end;

end;

end.
