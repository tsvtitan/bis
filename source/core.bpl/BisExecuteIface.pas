unit BisExecuteIface;

interface

uses
     BisIfaces, BisCmdLine;

type

  TBisExecuteIface=class(TBisIface)
  public
    procedure ShowByCommand(Param: TBisCmdParam; const Command: String); override;
  end;

implementation

uses BisCore, BisConsts, BisProvider;

{ TBisExecuteIface }

procedure TBisExecuteIface.ShowByCommand(Param: TBisCmdParam; const Command: String);
var
  P: TBisProvider;
begin
  if Assigned(Core) then begin
    P:=TBisProvider.Create(nil);
    try
      P.UseShowError:=true;
     // P.ProviderName:=Core.CmdLine.ValueByParam(SCmdParamCommand,1);
      P.ProviderName:=Param.Next(Command);
      P.Execute;
    finally
      P.Free;
    end;
  end;
end;

end.
