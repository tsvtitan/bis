unit BisMessInit;

interface

uses BisModules, BisIfaceModules;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;                 

exports
  InitIfaceModule;

implementation

uses BisCore, BisMessConsts,
     BisMessDataPatternMessagesFm, BisMessDataCodeMessagesFm,
     BisMessDataInMessagesFm, BisMessDataOperatorsFm,
     BisMessDataOutMessageEditFm, BisMessDataOutMessageInsertExFm,
     BisMessDataOutMessagesImportFm, BisMessDataOutMessagesFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule do begin
    Classes.Add(TBisMessDataPatternMessagesFormIface);
    Classes.Add(TBisMessDataCodeMessagesFormIface);
    Classes.Add(TBisMessDataOperatorsFormIface);
    Classes.Add(TBisMessDataInMessagesFormIface);
    Classes.Add(TBisMessDataOutMessagesFormIface);
    Classes.Add(TBisMessDataOutMessageInsertFormIface);
    Classes.Add(TBisMessDataOutMessageInsertExFormIface);
    Classes.Add(TBisMessDataOutMessagesImportFormIface);
  end;
end;

end.
