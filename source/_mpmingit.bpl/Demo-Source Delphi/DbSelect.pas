unit DbSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GWXLib_TLB, IniFiles, StrUtils, ExtCtrls;

type
  TDbForm = class(TForm)
    List: TListBox;
    Label1: TLabel;
    Comment: TLabel;
    Style: TMemo;
    SaveDialog: TSaveDialog;
    Panel1: TPanel;
    Button1: TButton;
    Filename: TEdit;
    Label3: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    OkBtn: TButton;
    Button3: TButton;
    procedure ListClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    ini: TIniFile;
    BaseDir: string;
    res_name, res_style: string;
  public
    function Execute(tbl: IGWTable; dir: string): boolean;
    procedure GetResult(out dbname, dbstyle: string);
  end;

var
  DbForm: TDbForm;

implementation

{$R *.dfm}

function TDbForm.Execute(tbl: IGWTable; dir: string): boolean;
var
  i,j,p: integer;
  line, section: string;
  isLoaded: boolean;
begin
  // filling database descriptions
  BaseDir:=dir;
  List.Items.Clear;
  Comment.Caption:='';
  Filename.Text:='';
  Style.Lines.Clear;
  ini:=TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));


  for i:=1 to 100 do begin
    line:=Ini.ReadString('maps', 'map'+IntToStr(i), '');
    if line='' then break;
    p:=pos('|', line);
    if p=0 then continue;
    line:=ExtractFileName(RightStr(line,Length(line)-p)); // line is filename.chart
    isLoaded:=false;
    p:=tbl.MoveFirst;
    while p>=0 do begin
      if CompareText(line, tbl.getText(0))=0 then begin isLoaded:=true; break; end;
      p:=tbl.MoveNext;
    end;
    if not isLoaded then continue;
    section:='DBs on '+line;
    for j:=1 to 200 do begin
      line:=Ini.ReadString(section, 'db'+IntToStr(j), '');
      if line='' then break;
      List.Items.Add(line);
    end;
  end;


  result:=ShowModal=mrOK;
  ini.Free;
end;

procedure TDbForm.ListClick(Sender: TObject);
var
  j,ix: integer;
  section, s, txt: string;
begin
  ix:=List.ItemIndex;
  if ix<0 then exit;
  section:=List.Items[List.ItemIndex];
  Comment.Caption:=Ini.ReadString(section, 'comment', '');
  Filename.Text:=BaseDir+Ini.ReadString(section, 'db', '');
  Style.Lines.Clear;
  s:=Ini.ReadString(section, 'style', '');
  if s<>'' then txt:=s
  else for j:=1 to 100 do begin
    s:=Ini.ReadString(section, 'style'+IntToStr(j), '');
    if s='' then break;
    txt:=txt+s+#13#10;
  end;
  Style.Text:=txt;
end;

procedure TDbForm.Button1Click(Sender: TObject);
begin
  SaveDialog.FileName:=Filename.Text;
  SaveDialog.InitialDir:=ExtractFileDir(Filename.Text);
  if SaveDialog.Execute then Filename.Text:=SaveDialog.FileName;
end;

procedure TDbForm.OkBtnClick(Sender: TObject);
begin
  res_name:=Filename.Text;
  res_style:=Style.Text;
  ModalResult:=mrOK;
end;

procedure TDbForm.GetResult(out dbname, dbstyle: string);
begin
  dbname:=res_name;
  dbstyle:=res_style;
end;

end.
