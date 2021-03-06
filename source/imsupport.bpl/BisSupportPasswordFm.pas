unit BisSupportPasswordFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDialogFm, BisControls;

type
  TBisSupportPasswordForm = class(TBisDialogForm)
    LabelPassword: TLabel;
    EditPassword: TEdit;
    procedure EditPasswordChange(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisSupportPasswordForm: TBisSupportPasswordForm;

implementation

{$R *.dfm}

constructor TBisSupportPasswordForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  EditPassword.Password:=true;
end;

procedure TBisSupportPasswordForm.EditPasswordChange(Sender: TObject);
begin
  ButtonOk.Enabled:=Trim(EditPassword.Text)<>'';
end;

end.
