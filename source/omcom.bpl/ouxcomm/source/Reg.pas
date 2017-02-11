unit Reg;

interface
uses
  Classes, XComDrv;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('XComDrv',[TXModem, TXComm]);
end;

end.
