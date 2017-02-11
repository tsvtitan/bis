unit dws2PasGenRegister;

interface

uses
  Classes;

procedure Register;

implementation

uses
  dws2PasGenerator, dws2UnitUtils;

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2PascalCodeGenerator]);
end;

end.
