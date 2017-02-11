unit TreeViewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, GWXLib_TLB, StdCtrls, ExtCtrls;

type
  TTreeForm = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ObjTree: TTreeView;
    AttrTree: TTreeView;
  private
    procedure AddTreeItems(parent: TTreeNode; tbl: IGWTable; Tree: TTreeView);
  public
    procedure ShowTable(ctrl: TGWControl);
  end;

var
  TreeForm: TTreeForm;

implementation

{$R *.dfm}

procedure TTreeForm.ShowTable(ctrl: TGWControl);
var
  tbl:IGWTable;
begin
  ObjTree.Items.Clear;
  AttrTree.Items.Clear;

  tbl:=ctrl.getAliasCodes as IGWTable;
  AddTreeItems(nil, tbl, ObjTree);

  tbl:=ctrl.getAliasAttributes as IGWTable;
  AddTreeItems(nil, tbl, AttrTree);

  ShowModal;
end;

procedure TTreeForm.AddTreeItems(parent: TTreeNode; tbl: IGWTable; Tree: TTreeView);
var
  r, rows: integer;
  node : TTreeNode;
begin
  rows:=tbl.rowCount;

  tbl.MoveFirst;
  for r:=1 to rows do begin
    node:=Tree.Items.AddChild(parent, tbl.getValue(0));
    if tbl.getValue(1) <> 27 then begin
      AddTreeItems(node, IDispatch(tbl.getValue(2)) as IGWTable, Tree);
    end;
    tbl.MoveNext
  end;
end;


end.
