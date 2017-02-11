unit BisMess;

interface

uses BisIfaceModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;                 

exports
  InitIfaceModule;

implementation

uses BisCore, BisDataFm, BisMessConsts,
     BisMessMainFm, BisMessDataOutMessagesFm, BisMessDataOutMessageEditFm,
     BisMessDataCodeMessagesFm, BisMessDataInMessagesFm, BisMessDataPatternMessagesFm,
     BisMessDataAccountsFm, BisMessDataRolesFm,
     BisMessDataOutMessageInsertExFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule do begin

    if IsMainModule then
      Ifaces.AddClass(TBisMessMainFormIface);

{    Ifaces.AddClass(TBisMessDataOutMessagesFormIface);
    Ifaces.AddClass(TBisMessDataCodeMessagesFormIface);
    Ifaces.AddClass(TBisMessDataInMessagesFormIface);
    Ifaces.AddClass(TBisMessDataPatternMessagesFormIface);
    Ifaces.AddClass(TBisMessDataAccountsFormIface);
    Ifaces.AddClass(TBisMessDataRolesFormIface);

    Ifaces.AddClass(TBisMessDataOutMessageInsertFormIface);
    Ifaces.AddClass(TBisMessDataOutMessageInsertExFormIface);}

    Classes.Add(TBisMessDataOutMessagesFormIface);
    Classes.Add(TBisMessDataCodeMessagesFormIface);
    Classes.Add(TBisMessDataInMessagesFormIface);
    Classes.Add(TBisMessDataPatternMessagesFormIface);
    Classes.Add(TBisMessDataAccountsFormIface);
    Classes.Add(TBisMessDataRolesFormIface);

    Classes.Add(TBisMessDataOutMessageInsertFormIface);
    Classes.Add(TBisMessDataOutMessageInsertExFormIface);

  end;
end;

end.
