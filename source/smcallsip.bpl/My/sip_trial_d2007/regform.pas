unit regform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TRegistrationForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    ServerEdit: TEdit;
    UserEdit: TEdit;
    PasswordEdit: TEdit;
    STUNEdit: TEdit;
    StunBox: TCheckBox;
    Button2: TButton;
    ProxyEdit: TEdit;
    Label4: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StunBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses IniFiles;

procedure TRegistrationForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOk then
  begin
    if Length(ServerEdit.Text) = 0 then
      raise Exception.Create('Please enter SIP server.');
  end;
end;

procedure TRegistrationForm.StunBoxClick(Sender: TObject);
begin
  STUNEdit.Enabled := StunBox.Checked;
  if not StunBox.Checked then
    STUNEdit.Text := '';
end;

end.
