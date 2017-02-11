unit ObjStatus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, GWXLib_TLB, ImgList, StdCtrls, ExtCtrls;

type
  TObjStatusForm = class(TForm)
    Tree: TTreeView;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    ChecksImageList: TImageList;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TreeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    visMode:   integer;
    GWCtrl: TGWControl;
    rootDB: TTreeNode;
    procedure AddTreeItems(parent: TTreeNode; tbl: IGWTable; isDB: boolean);
    procedure setVisMode(vm: integer);
    procedure UpdateAll();
  public
    procedure UpdateObjects(GWControl: TGWControl; forceShow: boolean);
  end;

var
  ObjStatusForm: TObjStatusForm;

implementation

{$R *.dfm}

procedure TObjStatusForm.UpdateObjects(GWControl: TGWControl; forceShow: boolean);
begin
  GWCtrl:=GWControl;
  if not Visible and not forceShow then exit;
  UpdateAll();
  if forceShow then Show;
end;

procedure TObjStatusForm.UpdateAll();
var
  tbl: IGWTable;
begin
  Tree.Items.BeginUpdate;
  //Tree.Items.Clear;
  AddTreeItems(nil, GWCtrl.getExplore as IGWTable, false);
  tbl:=GWCtrl.getExploreDb as IGWTable;
  if tbl.rowCount>0 then begin
    if rootDB=nil then rootDB:=Tree.Items.AddChild(nil, 'DBs, tables');
    rootDB.ImageIndex:=3;
    rootDB.SelectedIndex:=3;
    AddTreeItems(rootDB, tbl, true);
    rootDB.Expand(false);
  end
  else if rootDB<>nil then begin
    Tree.Items.Delete(rootDB);
    rootDB:=nil;
  end;
  Tree.Items.EndUpdate;
end;

procedure TObjStatusForm.AddTreeItems(parent: TTreeNode; tbl: IGWTable; isDB: boolean);
var
  p,v: integer;
  node,n,fst : TTreeNode;
  s: string;
begin
  // mark all items as not existent
  if parent<>nil then fst:=parent.getFirstChild else fst:=Tree.Items.GetFirstNode;
  // fst is the 1st item of this level
  n:=fst;
  while n<>nil do begin
    if n<>rootDB then n.ImageIndex:=-1;
    n:=n.getNextSibling;
  end;

  if tbl=nil then exit;
  p:=tbl.MoveFirst;
  while p>=0 do begin
    v:=tbl.getValue(0); // 0 - state of visibility
    if v<>0 then begin
      s:=tbl.getText(1); // 1 is name
      node:=nil;
      n:=fst;
      while n<>nil do begin
        if n.Text=s then begin node:=n; break; end;
        n:=n.getNextSibling;
      end;
      // search with the same name
      if node=nil then node:=Tree.Items.AddChild(parent, s);
      v:=(v shr (visMode*2)) and 3;
      node.ImageIndex:=v-1;
      node.SelectedIndex:=v-1;
      if not isDB then
        if tbl.getValue(2) <> 27 then  // 2 is level
          AddTreeItems(node, IDispatch(tbl.getValue(3)) as IGWTable, isDB); // 3 is child table
    end;
    p:=tbl.MoveNext
  end;

  n:=fst;
  while n<>nil do begin
    node:=n.getNextSibling;
    if n.ImageIndex=-1 then Tree.Items.Delete(n);
    n:=node;
  end;
end;


procedure TObjStatusForm.FormCreate(Sender: TObject);
begin
  rootDB:=nil;
  visMode:=0;
end;

procedure TObjStatusForm.RadioButton1Click(Sender: TObject);
begin
 setVisMode(0);
end;

procedure TObjStatusForm.RadioButton2Click(Sender: TObject);
begin
 setVisMode(1);
end;

procedure TObjStatusForm.RadioButton3Click(Sender: TObject);
begin
 setVisMode(2);
end;

procedure TObjStatusForm.RadioButton4Click(Sender: TObject);
begin
 setVisMode(3);
end;

procedure TObjStatusForm.setVisMode(vm: integer);
begin
  if vm=visMode then exit;
  visMode:=vm;
  UpdateAll();
end;

procedure TObjStatusForm.Button1Click(Sender: TObject);
begin
  UpdateAll();
end;

procedure TObjStatusForm.TreeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  node, par: TTreeNode;
  HT: THitTests;
  isDb: boolean;
  name, pname, md: string;
  i:  integer;
begin
  if Button<>mbLeft then exit;
  node:=Tree.GetNodeAt(X,Y);
  if (node=nil) or (node=rootDB) then exit;
  HT := Tree.GetHitTestInfoAt(X, Y);
  if not (htOnIcon in HT) then exit;

  par:=node;
  while par.Parent<>nil do par:=par.Parent;
  isDb:=par=rootDB;

  name:=node.Text;
  //may be more than 1 codifier, in this case we must put '{codifier name}:' before name of object or group
  if not isDB and (par<>node) then begin
    pname:=par.Text;
    i:=Length(pname);
    if (i>=2) and (pname[1]='{') and (pname[i]='}') then name:=pname+':'+name;
  end;

  case visMode of
    0: md:='V';
    1: md:='M';
    2: md:='C';
    3: md:='T';
  end;
  if node.ImageIndex=0 then i:=0 else i:=1;

  if isDB then GWCtrl.exploreDbApply(name, i, md) else GWCtrl.exploreApply(name, i, md);
  UpdateAll();
  GWCtrl.Refresh;
end;

end.
