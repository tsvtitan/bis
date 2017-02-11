unit TableColumns;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, ComCtrls;

type
  TTableColumnForm = class(TForm)
    List: TListView;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    TypeCombo: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    NameEdit: TEdit;
    Label3: TLabel;
    DescrEdit: TEdit;
    AddBtn: TButton;
    DeleteBtn: TButton;
    procedure ListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure TypeComboChange(Sender: TObject);
    procedure NameEditChange(Sender: TObject);
    procedure DescrEditChange(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
  private
  public
    procedure EditColumns(grid: TStringGrid);
  end;

var
  TableColumnForm: TTableColumnForm;

implementation

{$R *.dfm}

procedure TTableColumnForm.EditColumns(grid: TStringGrid);
var
  col,i,row: integer;
  item: TListItem;
begin
  // saving grid cells

  List.Items.Clear;
  for col:=1 to grid.ColCount-1 do begin
    if grid.Cells[col, 0]='' then break;
    item:=List.Items.Add;
    item.Caption:=grid.Cells[col, 0];
    item.SubItems.Add(grid.Cells[col, 1]);
    item.SubItems.Add(grid.Cells[col, 2]);
    item.SubItems.Add(IntToStr(col));
  end;
  if List.Items.Count>0 then List.Selected:=List.Items[0];
  ListSelectItem(Self, List.Selected, true);

  if ShowModal<>mrOk then exit;

  if List.Items.Count=0 then begin // clear all grid
    grid.RowCount:=4;
    grid.ColCount:=2;
    grid.FixedCols:=1;
    grid.FixedRows:=3;

    grid.Cells[0,0]:='Type';
    grid.Cells[0,1]:='Name';
    grid.Cells[0,2]:='Description';
    grid.Cells[0,3]:='*';
    grid.ColWidths[0]:=50;
    grid.Cells[1,0]:='';
    grid.Cells[1,1]:='';
    grid.Cells[1,2]:='';
    grid.Cells[1,3]:='';
    exit;
  end;

  for i:=0 to List.Items.Count-1 do begin
    item:=List.Items[i];
    if not TryStrToInt(item.SubItems[2],col) then begin
      grid.ColCount:=i+2;
      grid.ColWidths[i+1]:=grid.DefaultColWidth;
      for row:=3 to grid.RowCount-1 do grid.Cells[i+1,row]:='';
    end else if col<>i+1 then begin // copying from original column
      grid.ColWidths[i+1]:=grid.ColWidths[col];
      for row:=3 to grid.RowCount-1 do grid.Cells[i+1,row]:=grid.Cells[col,row];
    end;
    grid.Cells[i+1,0]:=item.Caption;
    grid.Cells[i+1,1]:=item.Subitems[0];
    grid.Cells[i+1,2]:=item.Subitems[1];
  end;
  grid.ColCount:=List.Items.Count+1;
end;

procedure TTableColumnForm.ListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if (Item=nil) or not Selected then begin
    TypeCombo.Enabled:=false;
    TypeCombo.ItemIndex:=-1;
    NameEdit.Enabled:=false;
    NameEdit.Text:='';
    DescrEdit.Enabled:=false;
    DescrEdit.Text:='';
  end else begin
    TypeCombo.Enabled:=true;
    TypeCombo.ItemIndex:=TypeCombo.Items.IndexOf(item.Caption);
    NameEdit.Enabled:=true;
    NameEdit.Text:=item.SubItems[0];
    DescrEdit.Enabled:=true;
    DescrEdit.Text:=item.SubItems[1];
  end;
end;

procedure TTableColumnForm.TypeComboChange(Sender: TObject);
var
  item: TListItem;
begin
  item:=List.Selected;
  if item<>nil then item.Caption:=TypeCombo.Items[TypeCombo.ItemIndex];
end;

procedure TTableColumnForm.NameEditChange(Sender: TObject);
var
  item: TListItem;
begin
  item:=List.Selected;
  if item<>nil then item.Subitems[0]:=NameEdit.Text;
end;

procedure TTableColumnForm.DescrEditChange(Sender: TObject);
var
  item: TListItem;
begin
  item:=List.Selected;
  if item<>nil then item.Subitems[1]:=DescrEdit.Text;
end;

procedure TTableColumnForm.AddBtnClick(Sender: TObject);
var
  item: TListItem;
begin
  item:=List.Items.Add;
  item.Caption:='TEXT';
  item.SubItems.Add('Column_'+IntToStr(List.Items.Count));
  item.SubItems.Add('');
  item.SubItems.Add('new');
  List.Selected:=item;
  ListSelectItem(Self, List.Selected, true);
  NameEdit.SetFocus;
  NameEdit.SelectAll;
end;

procedure TTableColumnForm.Button1Click(Sender: TObject);
var
  i,j: integer;
  ok: boolean;
  n: string;
begin
  // check that all names are different
  ok:=true;
  for i:=0 to List.Items.Count-2 do begin
    n:=List.Items[i].SubItems[0];
    for j:=i+1 to List.Items.Count-1 do
      if n=List.Items[j].SubItems[0] then begin
        ok:=false; break;
      end;
    if not ok then break;
  end;

  if ok then ModalResult:=mrOK
  else MessageDlg('Field '''+n+''' is defined twice', mtWarning, [mbOK],0);
end;

procedure TTableColumnForm.DeleteBtnClick(Sender: TObject);
var
  item: TListItem;
  ix: integer;
begin
  item:=List.Selected;
  if item=nil then begin Beep; exit; end;
  if MessageDlg('Delete field '''+item.SubItems[0]+'''?', mtConfirmation, [mbOK, mbCancel],0)<>mrOK then exit;

  ix:=List.Items.IndexOf(item);
  List.Items.Delete(ix);
end;

end.
