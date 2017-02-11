unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XComDrv;

type
  TForm6 = class(TForm)
    XModem1: TXModem;
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    XComm1: TXComm;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure XModem1Connect(Sender: TObject);
    procedure XModem1Data(Sender: TObject; const Received: Cardinal);
    procedure XModem1Disconnect(Sender: TObject);
    procedure XModem1HayesAT(Sender: TObject; AT: THayesAT);
    procedure XModem1Read(Sender: TObject);
    procedure XModem1Send(Sender: TObject);
    procedure XModem1CommEvent(Sender: TObject; const Events: TDeviceEvents);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

uses TypInfo;

{$R *.dfm}

procedure TForm6.Button1Click(Sender: TObject);
begin
  XComm1.OnData:=XModem1Data;
  Memo1.Lines.Add('====================');

  XComm1.SendString(Edit1.Text+#13);
end;

procedure TForm6.Button2Click(Sender: TObject);
var
  S: String;
begin
  XComm1.OnData:=nil;
  try
    XComm1.SendString(#27);
    XComm1.SendString('AT'#13);
    XComm1.WaitForString(['AT','OK','ERROR'],5000);
    XComm1.ReadString(S);
    Memo1.Lines.Add(S);  
{    XComm1.SendString('AT+CGMI'#13);
    XComm1.ReadString(S);
    Memo1.Lines.Add(S);  }
  finally
    
  end;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
//  XModem1.OpenDevice;
  XComm1.OpenDevice;
end;

procedure TForm6.XModem1CommEvent(Sender: TObject; const Events: TDeviceEvents);
begin
  Memo1.Lines.Add('CommEvent');
  if deChar in Events then
     Memo1.Lines.Add('deChar');
  if deFlag in Events then
     Memo1.Lines.Add('deFlag');
  if deOutEmpty in Events then
     Memo1.Lines.Add('deOutEmpty');
  if deBreak in Events then
     Memo1.Lines.Add('deBreak');

end;

procedure TForm6.XModem1Connect(Sender: TObject);
begin
  Memo1.Lines.Add('Connect');
end;

procedure TForm6.XModem1Data(Sender: TObject; const Received: Cardinal);
var
  Buffer: String;
begin
 SetLength(Buffer,Received);
  XComm1.ReadData(Pointer(Buffer)^,Received);
  Memo1.Lines.Add('Data');
  if Buffer<>'' then
    Memo1.Lines.Add('Data string=['+Buffer+']');
end;

procedure TForm6.XModem1Disconnect(Sender: TObject);
begin
  Memo1.Lines.Add('Disconnect');
end;

procedure TForm6.XModem1HayesAT(Sender: TObject; AT: THayesAT);
begin
  Memo1.Lines.Add('HayesAT');
end;

procedure TForm6.XModem1Read(Sender: TObject);
var
  S: String;
begin
  Memo1.Lines.Add('Read '+S);
//  XComm1.ReadString(S);
//  Memo1.Lines.Add('Read string='+S);

end;

procedure TForm6.XModem1Send(Sender: TObject);
begin
  Memo1.Lines.Add('Send');
end;

end.
