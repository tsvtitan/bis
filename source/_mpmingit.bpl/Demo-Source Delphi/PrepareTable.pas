unit PrepareTable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GWXLib_TLB, Grids, StdCtrls, ExtCtrls, IniFiles, StrUtils;

type
  TPrepareTableForm = class(TForm)
    Grid: TStringGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    List: TListBox;
    Label1: TLabel;
    Panel3: TPanel;
    Comment: TLabel;
    LoadCmdMemo: TMemo;
    Label2: TLabel;
    StyleMemo: TMemo;
    Label3: TLabel;
    OkBtn: TButton;
    Button2: TButton;
    ColumnsBtn: TButton;
    procedure FormResize(Sender: TObject);
    procedure ListClick(Sender: TObject);
    procedure GridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure OkBtnClick(Sender: TObject);
    procedure ColumnsBtnClick(Sender: TObject);
  private
    ini: TIniFile;
    procedure PrepareList(tbl: IGWTable);
    procedure FillGrid(section: string);
  public
    function PrepareGWTable(ctrl: TGWControl; out loadcmd, style: string): IGWTable;
  end;

var
  PrepareTableForm: TPrepareTableForm;

implementation

uses TableColumns;

{$R *.dfm}

function TPrepareTableForm.PrepareGWTable(ctrl: TGWControl; out loadcmd, style: string): IGWTable;
var
  col, row, k: integer;
  val: string;

begin
  loadcmd:='';
  style:='';
  result:=nil;
  LoadCmdMemo.Text:='';
  StyleMemo.Text:='';
  Comment.Caption:='';
  FillGrid('');
// GWControl.LoadedMaps as IGWTable
//  DecimalSeparator
  PrepareList(ctrl.LoadedMaps as IGWTable);

  ShowModal;

  ini.Free;
  if ModalResult<>mrOK then exit;

  result:=ctrl.CreateGWTable as IGWTable;
  // adding columns
  for col:=1 to Grid.ColCount-1 do
    result.addColumn(Grid.Cells[col,0], Grid.Cells[col,1], Grid.Cells[col,2]);
  // adding rows
  for row:=3 to Grid.RowCount-1 do begin
    result.addNew();
    // setting field values of this row
    for col:=1 to Grid.ColCount-1 do begin
      val:=Grid.Cells[col,row];
      // for double fields we must replace '.' to char defined in system as decimal separator
      if Grid.Cells[col,0]='DOUBLE' then
        for k:=1 to Length(val) do
          if val[k]='.' then val[k]:=DecimalSeparator;
      // set string value that will be converted to integer or double automatically
      result.setValue(val, col-1);
    end;
  end;

  loadcmd:=LoadCmdMemo.Text;
  style:=StyleMemo.Text;
end;

procedure TPrepareTableForm.PrepareList(tbl: IGWTable);
var
  j,p: integer;
  line, section: string;
begin
  List.Items.Clear;
  ini:=TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  p:=tbl.MoveFirst;
  while p>=0 do begin
    section:='Tables on '+tbl.getText(0);
    p:=tbl.MoveNext;

    for j:=1 to 200 do begin
      line:=Ini.ReadString(section, 'table'+IntToStr(j), '');
      if line='' then break;
      List.Items.Add(line);
    end;

  end;
end;

procedure TPrepareTableForm.FormResize(Sender: TObject);
begin
  LoadCmdMemo.Width:=Panel3.ClientWidth;
  StyleMemo.Width:=Panel3.ClientWidth;
end;

procedure TPrepareTableForm.ListClick(Sender: TObject);
var
  section: string;
  function GetIniMultistring(param: string): string;
  var
    s: string;
    j: integer;
  begin
    result:='';
    s:=Ini.ReadString(section, param, '');
    if s<>'' then result:=s
    else for j:=1 to 100 do begin
      s:=Ini.ReadString(section, param+IntToStr(j), '');
      if s='' then break;
      result:=result+s+#13#10;
    end;
  end;
begin
  if List.ItemIndex<0 then exit;
  section:=List.Items[List.ItemIndex];
  Comment.Caption:=Ini.ReadString(section, 'comment', '');
  LoadCmdMemo.Text:=GetIniMultistring('LoadCmd');
  StyleMemo.Text:=GetIniMultistring('Style');
  FillGrid(section);
end;

function SplitLine(line: string): TStringList;
var
  i: integer;
begin
  result:=TStringList.Create;
  while line<>'' do begin
    line:=TrimLeft(line);
    if line='' then break;
    if line[1]='"' then begin     // quoted
      Delete(line,1,1);
      i:=Pos('"',line);
      if i>0 then begin result.Add(LeftStr(line,i-1)); Delete(line, 1, i); end
      else begin result.Add(line); line:=''; end;
    end
    else begin
      i:=2;
      while (i<=Length(line)) and not (line[i] in [' ', ',', ';']) do inc(i);
      result.Add(LeftStr(line,i-1));
      Delete(line, 1, i-1);
    end;
    line:=TrimLeft(line);
    if (line='') or (line[1]<>',') then break;
    Delete(line,1,1);
  end;
end;

procedure SplitColumnLine(line: string; out ftype, fname, fdescr: string);
var
 sl: TStringList;
begin
 sl:=SplitLine(line);
 if sl.Count>0 then ftype:=sl[0];
 if sl.Count>1 then fname:=sl[1];
 if sl.Count>2 then fdescr:=sl[2];
 sl.Free;
end;

procedure TPrepareTableForm.FillGrid(section: string);
var
  line, ftype, fname, fdescr: string;
  col, row: integer;
  sl: TStringList;
begin
  Grid.RowCount:=4;
  Grid.ColCount:=2;
  Grid.FixedCols:=1;
  Grid.FixedRows:=3;

  Grid.Cells[0,0]:='Type';
  Grid.Cells[0,1]:='Name';
  Grid.Cells[0,2]:='Description';
  Grid.Cells[0,3]:='*';
  Grid.ColWidths[0]:=50;
  Grid.Cells[1,0]:='';
  Grid.Cells[1,1]:='';
  Grid.Cells[1,2]:='';
  Grid.Cells[1,3]:='';

  if section='' then exit;

  // adding columns
  for col:=1 to 100 do begin
    line:=Ini.ReadString(section, 'column'+IntToStr(col), '');
    if line='' then break;
    SplitColumnLine(line, ftype, fname, fdescr);
    Grid.ColCount:=col+1;
    Grid.Cells[col,0]:=ftype;
    Grid.Cells[col,1]:=fname;
    Grid.Cells[col,2]:=fdescr;
  end;
  // filling rows
  for row:=1 to 100 do begin
    line:=Ini.ReadString(section, 'row'+IntToStr(row), '');
    if line='' then break;
    sl:=SplitLine(line);
    Grid.RowCount:=Grid.RowCount+1;
    Grid.Cells[0,Grid.RowCount-1]:='*';
    for col:=1 to Grid.ColCount-1 do Grid.Cells[col,Grid.RowCount-1]:='';
    Grid.Cells[0,Grid.RowCount-2]:=IntToStr(row);
    for col:=1 to sl.Count do
      if col<Grid.ColCount then Grid.Cells[col,Grid.RowCount-2]:=sl[col-1];
    sl.Free;
  end;
end;

procedure TPrepareTableForm.GridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin // adds row if editing in the last row
  if (Value<>'') and (ARow=Grid.RowCount-1) then begin
    Grid.RowCount:=Grid.RowCount+1;
    Grid.Cells[0,Grid.RowCount-1]:='*';
    Grid.Cells[0,Grid.RowCount-2]:=IntToStr(ARow-2);
  end
end;

procedure TPrepareTableForm.OkBtnClick(Sender: TObject);
begin
  if (Grid.Cells[1,0]<>'') and (Grid.RowCount>3) then ModalResult:=mrOK;
end;

procedure TPrepareTableForm.ColumnsBtnClick(Sender: TObject);
begin
  TableColumnForm.EditColumns(Grid);
end;

end.
