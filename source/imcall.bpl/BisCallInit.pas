unit BisCallInit;

interface

uses BisModules, BisIfaceModules;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;                 

exports
  InitIfaceModule;

implementation

uses BisCore, BisCallConsts,
     BisCallDataCallResultsFm, BisCallDataCallsFm,
     BisCallPhoneFm
     ;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule do begin
    Classes.Add(TBisCallDataCallResultsFormIface);
    Classes.Add(TBisCallDataCallsFormIface);
    Classes.Add(TBisCallDataInCallsFormIface);
    Classes.Add(TBisCallDataOutCallsFormIface);
    Classes.Add(TBisCallPhoneFormIface);
  end;
end;

end.
