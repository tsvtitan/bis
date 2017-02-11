unit ObjProp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GWXLib_TLB, ComCtrls;

type
  TObjectForm = class(TForm)
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    List: TListView;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    GWCtrl: TGWControl;
    GWObj:  IGWObject;
    IsPermanent: boolean;
    procedure AddPropVal(const p, v: string);
  public
    procedure ShowObject(obj: IGWObject; ctrl: TGWControl; permanent: boolean);
  end;

var
  ObjectForm: TObjectForm;

implementation

{$R *.dfm}

procedure TObjectForm.AddPropVal(const p, v: string);
var
  item: TListItem;
begin
  item:=List.Items.Add;
  item.Caption:=p;
  item.SubItems.Add(v);
end;

procedure TObjectForm.ShowObject(obj: IGWObject; ctrl: TGWControl; permanent: boolean);
var
  paLen: OleVariant;
  coords: array of double;

    function TypeToStr(t: integer):string;
    begin
      case t of
        GWX_GeoObject: result:='Map object';
        GWX_DBObject: result:='DB object';
        GWX_GraphicObject: result:='Graphics object';
        GWX_DBConObject: result:='Link object';
        GWX_UnknownObject: result:='Unknown object';
      end;
    end;
    procedure AddTable(const cap: string;  tbl: IGWTable);
    var p: integer;
    begin
      if tbl=nil then exit;
      p:=tbl.MoveFirst;
      if p<0 then exit;
      AddPropVal('---------------------','----- '+cap+' -----');
      while p>=0 do begin
       AddPropVal(tbl.getText(0), tbl.getText(1));
        p:=tbl.MoveNext;
      end;
    end;
begin
  IsPermanent:=permanent;
  GWObj:=obj;
  GWCtrl:=ctrl;
  List.Clear;

  AddPropVal('ID', IntToStr(obj.ID));
  AddPropVal('Type', TypeToStr(obj.type_));
  AddPropVal('Acronym',obj.Acronym);
  AddPropVal('Length of boundary', IntToStr(obj.Length));
  coords:=obj.Metrics[paLen];
  AddPropVal('South side', FloatToStr(coords[2]));
  AddPropVal('West side', FloatToStr(coords[3]));
  AddPropVal('North side', FloatToStr(coords[4]));
  AddPropVal('East side', FloatToStr(coords[5]));
  AddTable('Attributes', obj.Attributes as IGWTable);
  AddTable('Links', obj.Links as IGWTable);

  CheckBox1.Checked:=obj.Visible<>0;
  CheckBox2.Checked:=obj.Marked<>0;
  CheckBox3.Checked:=obj.Contoured<>0;
  CheckBox4.Checked:=obj.Twinkling<>0;
  if permanent then Show
  else ShowModal;
end;

procedure TObjectForm.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked
  then GWObj.Visible:=1
  else GWObj.Visible:=0;
  GWCtrl.Refresh;
end;

procedure TObjectForm.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked
  then GWObj.Marked:=1
  else GWObj.Marked:=0;
  GWCtrl.Refresh;
end;

procedure TObjectForm.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked
  then GWObj.Contoured:=1
  else GWObj.Contoured:=0;
  GWCtrl.Refresh;
end;

procedure TObjectForm.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked
  then GWObj.Twinkling:=1
  else GWObj.Twinkling:=0;
  GWCtrl.Refresh;
end;

procedure TObjectForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if IsPermanent then Action:=caFree
  else Action:=caHide;
end;

end.
