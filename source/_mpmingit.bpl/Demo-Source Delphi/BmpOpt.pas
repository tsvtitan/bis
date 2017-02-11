unit BmpOpt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TBitmapOptForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label7: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit7: TEdit;
    UpDown1: TUpDown;
    Label8: TLabel;
    Edit8: TEdit;
    Button3: TButton;
    SaveDialog: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    res_n, res_w, res_s, res_e: double;
    res_cx, res_cy, res_fs: integer;
  public
    procedure SetGeoRect(north, west, south, east: double);
    procedure GetGeoRect(out north, west, south, east: double);
    procedure SetBmpSize(w,h: integer);
    procedure GetBmpSize(out w,h: integer);
    procedure GetFontSize(out ms: integer);
    procedure GetFileName(out fn: string);
  end;

var
  BitmapOptForm: TBitmapOptForm;

implementation

{$R *.dfm}


procedure TBitmapOptForm.SetGeoRect(north, west, south, east: double);
begin
  Edit1.Text:=FloatToStr(north);
  Edit2.Text:=FloatToStr(west);
  Edit3.Text:=FloatToStr(south);
  Edit4.Text:=FloatToStr(east);
end;

procedure TBitmapOptForm.GetGeoRect(out north, west, south, east: double);
begin
  north:=res_n;
  west:=res_w;
  south:=res_s;
  east:=res_e;
end;

procedure TBitmapOptForm.SetBmpSize(w,h: integer);
begin
  Edit5.Text:=IntToStr(w);
  Edit6.Text:=IntToStr(h);
end;

procedure TBitmapOptForm.GetBmpSize(out w,h: integer);
begin
  w:=res_cx;
  h:=res_cy;
end;

procedure TBitmapOptForm.GetFontSize(out ms: integer);
begin
  ms:=res_fs;
end;

procedure TBitmapOptForm.Button1Click(Sender: TObject);
begin
  if  TryStrToFloat(Edit1.Text, res_n)
  and TryStrToFloat(Edit2.Text, res_w)
  and TryStrToFloat(Edit3.Text, res_s)
  and TryStrToFloat(Edit4.Text, res_e)
  and TryStrToInt(Edit5.Text, res_cx)
  and TryStrToInt(Edit6.Text, res_cy)
  and TryStrToInt(Edit7.Text, res_fs)
  then ModalResult:=mrOk;
end;

procedure TBitmapOptForm.Button3Click(Sender: TObject);
begin
  SaveDialog.FileName:=Edit8.Text;
  SaveDialog.InitialDir:=ExtractFileDir(Edit8.Text);
  if SaveDialog.Execute then Edit8.Text:=SaveDialog.FileName;
end;

procedure TBitmapOptForm.FormCreate(Sender: TObject);
var
  Buffer: array[0..MAX_PATH] of Char;
  fn: string;
  len: integer;
begin
  GetTempPath(SizeOf(Buffer) - 1, Buffer);
  fn:=Buffer;
  len:=Length(fn);
  if (fn[len]<>'\') and (fn[len]<>'/') then fn:=fn+'\';
  Edit8.Text:=fn+'gwx_tmp.bmp';
end;

procedure TBitmapOptForm.GetFileName(out fn: string);
begin
  fn:=Edit8.Text;
end;

end.
