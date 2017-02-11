unit Unit21;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TAPISystem, TAPIAddress, TAPICall, TAPITon, TAPILines,
  TAPIDevices, TAPIServices, DevConf, TAPIPhone, TAPIWave,

//  JclSysInfo,

  BisTapi, BisCodec;

type
  TForm21 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    Button3: TButton;
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FTapi: TBisTapi;
    FCodec: TBisCodec;
    procedure TapiMessage(Sender: TObject; Message: String);
    procedure TapiConnect(Sender: TObject);
    procedure TapiDisconnect(Sender: TObject);
    procedure TapiAfterRecord(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form21: TForm21;

implementation

{$R *.dfm}

procedure TForm21.FormCreate(Sender: TObject);
begin

  FTapi:=TBisTapi.Create(Self);
//  FTapi.TimeRecord:=60;
  FTapi.RecordFromLine:=true;
  FTapi.RecordFile:='c:\1.wav';
  FTapi.OnMessage:=TapiMessage;
  FTapi.OnConnect:=TapiConnect;
  FTapi.OnDisconnect:=TapiDisconnect;
  FTapi.OnAfterRecord:=TapiAfterRecord;
  FTapi.GetDevices(ComboBox1.Items);



  Button1.Enabled:=false;
  Button2.Enabled:=false;
end;

procedure TForm21.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FTapi.EndCall;
  FTapi.Free;
end;


procedure TForm21.Button1Click(Sender: TObject);
begin
  Button1.Enabled:=false;
  Button2.Enabled:=false;
  FTapi.PhoneNumber:=Edit1.Text;
  FTapi.BeginCall;
end;

procedure TForm21.Button2Click(Sender: TObject);
begin
  FTapi.EndCall;
end;

procedure TForm21.Button3Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
end;

procedure TForm21.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex<>-1 then begin
    FTapi.DeviceName:=ComboBox1.Items.Strings[ComboBox1.ItemIndex];
    Button1.Enabled:=FTapi.Active;
    Button2.Enabled:=false;
  end else begin
    Button1.Enabled:=false;
    Button2.Enabled:=false;
  end;
end;

procedure TForm21.TapiConnect(Sender: TObject);
begin
  Button1.Enabled:=false;
  Button2.Enabled:=true;
end;

procedure TForm21.TapiDisconnect(Sender: TObject);
begin
  Button1.Enabled:=true;
  Button2.Enabled:=false;
end;

procedure TForm21.TapiMessage(Sender: TObject; Message: String);
begin
  Memo1.Lines.Add(Message);
  Application.ProcessMessages;
end;

procedure TForm21.TapiAfterRecord(Sender: TObject);
begin
  if FileExists(FTapi.RecordFile) then begin
    FCodec:=TBisCodec.Create(Self);
    try
      FCodec.WavToWma(FTapi.RecordFile,'c:\1.wma');
    finally
      FCodec.Free;
    end;
  end;
end;

end.
