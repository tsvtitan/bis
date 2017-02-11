library udfmysql;

uses
  Windows,
  BisUdfMysql in 'udfmysql.dll\BisUdfMysql.pas';

{$R *.res}  

exports
  GET_UNIQUE_ID_init,
  GET_UNIQUE_ID_deinit,
  GET_UNIQUE_ID;

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
  IsMultiThread := True;
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
