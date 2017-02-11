unit ObjList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GWXLib_TLB, ComCtrls, ExtCtrls, StdCtrls, ObjProp, ObPropTbl;

type
  TObjListForm = class(TForm)
    Panel1: TPanel;
    List: TListView;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Edit1: TEdit;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    GWCtrl: TGWControl;
  public
    procedure ShowTable(tbl: IGWTable; ctrl: TGWControl);
  end;

var
  ObjListForm: TObjListForm;

implementation

{$R *.dfm}

procedure TObjListForm.ShowTable(tbl: IGWTable; ctrl: TGWControl);
var
  item: TListItem;
  p: integer;
  function ObjTypeStr(t: integer): string;
  begin
    case t of
      GWX_GeoObject: result:='Map object';
      GWX_DBObject: result:='DB object';
      GWX_GraphicObject: result:='Graphics object';
      GWX_DBConObject: result:='Link object';
      GWX_UnknownObject: result:='Unknown object';
    end;
  end;
begin
  GWCtrl:=ctrl;
  List.Items.Clear;
  p:=tbl.MoveFirst;
  while p>=0 do begin
    item:=List.Items.Add;
    item.Caption:=tbl.getText(0);
    item.SubItems.Add(ObjTypeStr(tbl.getValue(1)));
    item.SubItems.Add(tbl.getText(2));
    item.SubItems.Add(StringReplace(tbl.getText(3), #13, '¶',[rfReplaceAll]));
    p:=tbl.MoveNext;
  end;
  ShowModal;
end;

procedure TObjListForm.Button1Click(Sender: TObject);
var
  item: TListItem;
  obj:  IGWObject;
begin
// show properties of selected item
  item:=List.Selected;
  if item=nil then exit;
  try
    obj:=GWCtrl.getObject(StrToInt(item.Caption)) as IGWObject;
    if obj<>nil then ObjectForm.ShowObject(obj, GWCtrl, false);
  finally
  end;
end;

procedure TObjListForm.Button2Click(Sender: TObject);
var
  item: TListItem;
  obj:  IGWObject;
begin
  item:=List.Selected;
  if item<>nil then
    GWCtrl.selectObject(StrToInt(item.Caption), 0);
end;

procedure TObjListForm.Button3Click(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to List.Items.Count-1 do
    GWCtrl.selectObject(StrToInt(List.Items[i].Caption), 2);
end;

procedure TObjListForm.Button4Click(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to List.Items.Count-1 do
    GWCtrl.selectObject(StrToInt(List.Items[i].Caption), -2);
end;

procedure TObjListForm.Button5Click(Sender: TObject);
var
  item: TListItem;
  obj:  IGWObject;
  objf: TObjectForm;
begin
// show properties of selected item
  item:=List.Selected;
  if item=nil then exit;
  try
    obj:=GWCtrl.getObject(StrToInt(item.Caption)) as IGWObject;
    if obj<>nil then begin
     Application.CreateForm(TObjectForm, objf);
     objf.ShowObject(obj, GWCtrl, true);
    end;
  finally
  end;
end;


procedure TObjListForm.Button6Click(Sender: TObject);
var
  item: TListItem;
  obj:  IGWObject;
begin
  item:=List.Selected;
  if item<>nil then
    GWCtrl.setObjectVisibility(StrToInt(item.Caption), edit1.Text);
end;

procedure TObjListForm.Button7Click(Sender: TObject);
var
  item: TListItem;
  obj:  IGWObject;
  id:   integer;
begin
  item:=List.Selected;
  if item=nil then exit;
  id:=StrToInt(item.Caption);
  ObjPropTable.ShowObject(id, GWCtrl);
end;

end.
