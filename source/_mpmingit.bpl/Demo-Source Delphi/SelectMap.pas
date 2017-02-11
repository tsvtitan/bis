unit SelectMap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TSelectMapForm = class(TForm)
    List: TListView;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SelectedItems: TStringList;
    procedure ClearList;
    procedure AddToList(m, f: string);
  end;

var
  SelectMapForm: TSelectMapForm;

implementation

{$R *.dfm}

procedure TSelectMapForm.Button1Click(Sender: TObject);
var i: integer;
begin
  SelectedItems.Clear;
  for i:=0 to List.Items.Count-1 do begin
    if list.Items.Item[i].Selected then
      SelectedItems.Add(list.Items.Item[i].SubItems[0]);
  end;
  if SelectedItems.Count>0 then ModalResult:=mrOk;
end;

procedure TSelectMapForm.FormCreate(Sender: TObject);
begin
  SelectedItems:=TStringList.Create;
end;

procedure TSelectMapForm.FormDestroy(Sender: TObject);
begin
  SelectedItems.Free;
end;

procedure TSelectMapForm.ClearList;
begin
  List.Items.Clear;
end;
procedure TSelectMapForm.AddToList(m, f: string);
var
  item: TListItem;
begin
  item:=List.Items.Add;
  item.Caption:=m;
  item.SubItems.Add(f);
end;

end.
