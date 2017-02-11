library udfibase;

uses
  Windows,
  BisUdfIBase in 'udfibase.dll\BisUdfIBase.pas',
  IdHTTP in 'omnet.bpl\Indy\Protocols\IdHTTP.pas',
  IdUDPClient in 'omnet.bpl\Indy\Core\IdUDPClient.pas',
  IdURI in 'omnet.bpl\Indy\Protocols\IdURI.pas',
  BisCrypter in 'core.bpl\BisCrypter.pas',
  IdIcmpClient in 'omnet.bpl\Indy\Core\IdIcmpClient.pas',
  BisNetUtils in 'core.bpl\BisNetUtils.pas',
  IpRtrMib in 'objects.bpl\IPHlpApi\Pas\IpRtrMib.pas',
  IpTypes in 'objects.bpl\IPHlpApi\Pas\IpTypes.pas',
  IpExport in 'objects.bpl\IPHlpApi\Pas\IpExport.pas',
  IpFunctions in 'objects.bpl\IPHlpApi\Pas\IpFunctions.pas',
  IpHlpApi in 'objects.bpl\IPHlpApi\Pas\IpHlpApi.pas';

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
  IsMultiThread := True;
  Randomize;
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
