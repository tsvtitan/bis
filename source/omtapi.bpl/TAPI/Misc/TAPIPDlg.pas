unit TAPIPDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TAPIPhoneConfigDlg;

type
  TPhoneSelectDlg = class(TForm)
    ComboBox1: TComboBox;
    TAPIPhoneConfigDlg1: TTAPIPhoneConfigDlg;
    Button1: TButton;
    Button3: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private-Deklarationen }
    FList:TList;
  public
    { Public-Deklarationen }
    property List:TList read FList write FList;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  end;

var
  PhoneSelectDlg: TPhoneSelectDlg;

implementation

{$R *.DFM}

uses TAPIPhoneSelectDialog;

{ TPhoneSelectDlg }

constructor TPhoneSelectDlg.Create(AOwner: TComponent);
begin
  inherited;
  FList:=Tlist.Create;
end;

destructor TPhoneSelectDlg.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TPhoneSelectDlg.Button1Click(Sender: TObject);
begin
  TAPIPhoneConfigDlg1.Execute;
end;

procedure TPhoneSelectDlg.FormCreate(Sender: TObject);
begin
  Button2.Enabled:=False;
  TAPIPhoneConfigDlg1.Device:=TTAPIPhoneSelectDialog(Owner).SelectDevice;
end;

procedure TPhoneSelectDlg.ComboBox1Change(Sender: TObject);
var ND:TPhoneDevItem;
    ii:Integer;
begin
  If ComboBox1.ItemIndex=-1 then
  begin
    Button1.Enabled:=False;
    Button3.Enabled:=False;
  end
  else
  begin
    Button1.Enabled:=True;
    Button3.Enabled:=True;
  end;
  ii:=0;
  while ComboBox1.Text <>PPhoneDevItem(FList.Items[ii])^.DevName do
  Inc(ii);
  ND:=PPhoneDevItem(FList.Items[ii])^;
  TTAPIPhoneSelectDialog(Owner).DeviceChange(ComboBox1,ND);
end;

end.
