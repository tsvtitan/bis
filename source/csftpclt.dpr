library csftpclt;

uses
  ComServ,
  BisCsFtpClient in 'csftpclt.dll\BisCSFtpClient.pas';

{$R *.res}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;
  
begin
end.
