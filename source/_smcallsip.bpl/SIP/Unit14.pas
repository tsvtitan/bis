unit Unit14;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSipClientForm = class(TForm)
    LabelHost: TLabel;
    EditHost: TEdit;
    LabelPort: TLabel;
    EditPort: TEdit;
    LabelUserName: TLabel;
    EditUserName: TEdit;
    LabelPassword: TLabel;
    EditPassword: TEdit;
    ButtonRegister: TButton;
    ButtonUnRegister: TButton;
    procedure ButtonRegisterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SipClientForm: TSipClientForm;

implementation

{$R *.dfm}

procedure TSipClientForm.ButtonRegisterClick(Sender: TObject);
begin
  //
end;

end.
