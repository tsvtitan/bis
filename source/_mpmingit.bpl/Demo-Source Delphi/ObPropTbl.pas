unit ObPropTbl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GWXLib_TLB, ComCtrls;

type
  TObjPropTable = class(TForm)
    List: TListView;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    procedure visChange(Sender: TObject);
  private
    { Private declarations }
    ObjID: integer;
    GWCtrl: TGWControl;
 public
    procedure ShowObject(id: integer; ctrl: TGWControl);
  end;

var
  ObjPropTable: TObjPropTable;

implementation

{$R *.dfm}

procedure TObjPropTable.ShowObject(id: integer; ctrl: TGWControl);
var
  p: integer;
  tbl: IGWTable;
  item: TListItem;
  prop, val: string;
begin
  ObjID:=id;
  GWCtrl:=ctrl;
  tbl:=GWCtrl.getObjectTable(id) as IGWTable;
  List.Items.Clear;

  if tbl<>nil then begin;
    p:=tbl.MoveFirst;
     while p>=0 do begin
       item:=List.Items.Add;
       prop:=tbl.getText(0);
       val:=tbl.getText(1);
       item.Caption:=prop;
       item.SubItems.Add(val);
       if prop='Visibility' then begin
         CheckBox1.Checked:=Pos('V', val)>0;
         CheckBox2.Checked:=Pos('M', val)>0;
         CheckBox3.Checked:=Pos('C', val)>0;
         CheckBox4.Checked:=Pos('T', val)>0;
       end;
       p:=tbl.MoveNext;
     end;
  end;
  ShowModal;
end;

procedure TObjPropTable.visChange(Sender: TObject);
var vis: string;
begin
  vis:='';
  if CheckBox1.Checked then vis:=vis+'V';
  if CheckBox2.Checked then vis:=vis+'M';
  if CheckBox3.Checked then vis:=vis+'C';
  if CheckBox4.Checked then vis:=vis+'T';
  GWCtrl.setObjectVisibility(ObjID, vis);
end;

end.
