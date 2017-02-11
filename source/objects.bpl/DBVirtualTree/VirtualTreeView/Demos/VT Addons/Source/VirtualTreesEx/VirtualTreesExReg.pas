unit VirtualTreesExReg;

interface

uses
  Classes, VirtualTreesEx;
  
procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Virtual Controls', [TVirtualStringTreeEx]);
end;

end.

