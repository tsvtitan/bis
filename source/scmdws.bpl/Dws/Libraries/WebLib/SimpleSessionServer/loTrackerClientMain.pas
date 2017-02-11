unit loTrackerClientMain;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QTypes, QExtCtrls, SyncObjs;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FQActive: Boolean;
    Lock: TCriticalSection;
    procedure SetQActive(const Value: Boolean);
    { Private declarations }
  public
    { Public declarations }
    property QActive: Boolean read FQActive write SetQActive;

  end;

var
  Form1: TForm1;

implementation
uses loTrackerClient, dws2SessionBasics;
{$R *.xfm}

procedure TForm1.Button1Click(Sender: TObject);
var AList: TStringList;
  i: integer;
  s:string;
begin
  Lock.Acquire;
  try
    QActive := True;
    AList := TStringList.Create;
    try
      memo1.lines.Clear;
      DataModule2.client.Connect;
      s := DataModule2.client.ReadLn(SLF);
      memo1.Lines.add(s);
      s := DataModule2.client.ReadLn(SLF);
      memo1.Lines.add(s);
      DataModule2.client.Write(inttostr(EnumerateSessions) + SLF);
      DataModule2.client.Write('AS' + SLF);
      AList.Text := DataModule2.client.ReadLn(SLF);
      memo1.lines.add(inttostr(AList.Count) + ' Sessions');
      for i := 0 to AList.Count - 1 do
      begin
        memo1.lines.add(AList[i]);
      end;
      DataModule2.client.Disconnect;
    finally
      AList.Free;
    end;
    QActive := False;
  finally
    Lock.Release;
  end;
end;

procedure TForm1.SetQActive(const Value: Boolean);
begin
  if Value then button1.Enabled := False else button1.Enabled := True;
  FQActive := Value;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Button1Click(self);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Lock := TCriticalSection.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Lock.Free;
end;

end.

