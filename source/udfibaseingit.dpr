library udfibaseingit;

uses
  Windows,
  ActiveX,
  BisUdfIBaseIngit in 'udfibaseingit.dll\BisUdfIBaseIngit.pas',
  GWXLib_TLB in 'udfibaseingit.dll\GWXLib_TLB.pas',
  BisUdfIBaseIngitConfig in 'udfibaseingit.dll\BisUdfIBaseIngitConfig.pas',
  BisUdfIBaseIngitLog in 'udfibaseingit.dll\BisUdfIBaseIngitLog.pas';

{$R *.res}

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: begin
      Init;
    end;
    DLL_PROCESS_DETACH: begin
      Done;
    end;
  end;
end;

begin
  IsMultiThread:=true;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
