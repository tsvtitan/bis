unit BisLoto;

interface

uses BisIfaceModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;
                                       
implementation

uses BisCore, BisLotoConsts,
     BisLotoMainFm, BisLotoDataMembersFm, BisLotoDataTiragesFm,
     BisLotoTicketImportFm, BisLotoTicketManageFm, BisLotoLotteryFm,
     BisLotoSiteExportIface;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule.Ifaces do begin

    if IsMainModule then
      AddClass(TBisLotoMainFormIface);

    AddClass(TBisLotoDataMembersFormIface);  
    TiragesIface:=TBisLotoDataTiragesFormIface(AddClass(TBisLotoDataTiragesFormIface));

    ImportIface:=TBisLotoTicketImportFormIface(AddClass(TBisLotoTicketImportFormIface));  
    ManageIface:=TBisLotoTicketManageFormIface(AddClass(TBisLotoTicketManageFormIface));
    LotteryIface:=TBisLotoLotteryFormIface(AddClass(TBisLotoLotteryFormIface));
    ExportIface:=TBisLotoSiteExportIface(AddClass(TBisLotoSiteExportIface));

  end;
end;

end.
