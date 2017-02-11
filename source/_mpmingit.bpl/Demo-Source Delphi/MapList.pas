unit MapList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, ComCtrls, ExtCtrls, GWXLib_TLB;

type
  TMapListForm = class(TForm)
    Panel1: TPanel;
    List: TListView;
    ListImages: TImageList;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
  private
    GWControl: TGWControl;
    procedure UpdateList;
  public
    procedure ShowList(ctrl: TGWControl);
  end;

var
  MapListForm: TMapListForm;

implementation

{$R *.dfm}

procedure TMapListForm.ShowList(ctrl: TGWControl);
begin
  GWControl:=ctrl;
  UpdateList;
  ShowModal;
end;

procedure TMapListForm.UpdateList;
var
  tbl: IGWTable;
  p: integer;
  item: TListItem;
  dblist: IGWStringList;
begin
  List.Items.Clear;
  tbl:=GWControl.LoadedMaps as IGWTable;
  p:=tbl.MoveFirst;
  while p>=0 do begin
  // name, descr, scale, cdf, lookup, frame
    item:=List.Items.Add;
    item.ImageIndex:=0;
    item.Caption:=tbl.getText(0);
    item.SubItems.Add(tbl.getText(1));
    item.SubItems.Add(IntToStr(tbl.getValue(2)));
    item.SubItems.Add(tbl.getText(4));
    item.SubItems.Add(tbl.getText(5));
    item.SubItems.Add(tbl.getText(6)+' '+tbl.getText(7)+' '+tbl.getText(6)+' '+tbl.getText(9));
    p:=tbl.MoveNext;
  end;

  dblist:=GWControl.DBFLoadedList as IGWStringList;
  p:=dblist.MoveFirst;
  while p<>0 do begin
    item:=List.Items.Add;
    item.ImageIndex:=1;
    item.Caption:=dblist.Item;
    item.SubItems.Add('Table');
    p:=dblist.MoveNext;
  end;
end;

procedure TMapListForm.Button1Click(Sender: TObject);
var
  i: integer;
  item: TListItem;
begin
  for i:=List.Items.Count-1 downto 0 do begin
    item:=List.Items[i];
    if not item.Selected then continue;
    if item.ImageIndex=0 // is map
    then GWControl.RemoveMap(item.Caption)
    else GWControl.DeleteDBF(item.Caption);
  end;
  UpdateList();
end;

end.
