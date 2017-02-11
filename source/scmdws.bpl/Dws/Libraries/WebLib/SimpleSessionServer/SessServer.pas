unit SessServer;

interface

uses
  SysUtils, Types, Classes, Variants, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, loSessionTrackingDM, QGrids, QDBGrids, QMenus, QTypes,
  QExtCtrls, QDBCtrls, loTrackerClient, QComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    edit2: TEdit;
    ProgressBar1: TProgressBar;
    MainMenu1: TMainMenu;
    Server1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    ShutDown1: TMenuItem;
    About1: TMenuItem;
    Label1: TLabel;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ShutDown1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.xfm}

uses DB;

procedure TForm1.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  showmessage('Session Tracking Server 0.0.1 for DWSII 1.0');
end;
                  
procedure TForm1.Exit1Click(Sender: TObject);
begin
   close;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  loSessionTrackingDM.DataModule1.TTime := strtofloat(edit1.Text);
end;

procedure TForm1.edit2Change(Sender: TObject);
begin
  loSessionTrackingDM.DataModule1.STime := strtofloat(edit2.Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  loSessionTrackingDM.MyBaseFileName := edit3.text;
  loSessionTrackingDM.DataModule1 := loSessionTrackingDM.TDataModule1.Create(Application);
  loSessionTrackingDM.DataModule1.TTime := strtofloat(edit1.Text);
  loSessionTrackingDM.DataModule1.STime := strtofloat(edit2.Text);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  freeandnil(loSessionTrackingDM.DataModule1);
end;

procedure TForm1.ShutDown1Click(Sender: TObject);
begin
  close;
end;

end.
