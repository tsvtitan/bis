unit dws2IdeDialogRegister;

interface

uses
  Classes;

procedure Register;

implementation

uses dws2IdeDialog;

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2IdeDialog]);
end;

end.
