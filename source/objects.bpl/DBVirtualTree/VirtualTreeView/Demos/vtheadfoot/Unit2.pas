unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, VirtualGHFStringTree,
  StdCtrls, ComCtrls, VirtualTrees;

type
  TForm2 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    GHF: TVirtualGHFStringTree;
    GH, F: THeaderControl;
  end;

var
  Form2        : TForm2;

implementation

uses Unit3;

{$R *.DFM}

procedure TForm2.Button1Click(Sender: TObject);
begin
  GH := THeaderControl.Create(Self);
  GH.Parent := Self;
  F := THeaderControl.Create(Self);
  F.Parent := Self;

  GHF := TVirtualGHFStringTree.Create(Self);
  GHF.Parent := Self;
  GHF.Left := 10;
  GHF.Width := ClientWidth - 20;
  GHF.Top := 40;
  GHF.Height := Button1.Top - GHF.Top - 40;
  GHF.Anchors := [akLeft, akTop, akRight, akBottom];

  GH.Sections.Clear;
  GH.Sections.Add.Text := 'setup';
  GH.Sections.Add.Text := 'results';
  GH.Sections.Add.Text := 'scripted';
  GH.Sections.Add.Text := 'empty';

  F.Sections.Clear;
  F.Sections.Add.Text := 'avg1';
  F.Sections.Add.Text := 'avg2';
  F.Sections.Add.Text := 'avg3';
  F.Sections.Add.Text := 'avg4';
  F.Sections.Add.Text := 'avg5';

  with GHF.Header.Columns.Add do
    begin
      Text := 'col1';
      Tag := 0;
      MaxWidth := 60;
    end;
  with GHF.Header.Columns.Add do
    begin
      Text := 'col2';
      Tag := 0;
      MaxWidth := 60;
    end;
  with GHF.Header.Columns.Add do
    begin
      Text := 'col3';
      Tag := 1;
    end;
  with GHF.Header.Columns.Add do
    begin
      Text := 'col4';
      Tag := 1;
    end;
  with GHF.Header.Columns.Add do
    begin
      Text := 'col5';
      Tag := 2;
    end;

  GHF.GroupHeader := GH;
  GHF.Footer := F;

  GHF.AddChild(GHF.AddChild(GHF.AddChild(GHF.AddChild(nil))));
  GHF.AddChild(GHF.AddChild(GHF.AddChild(GHF.AddChild(nil))));
  GHF.AddChild(GHF.AddChild(GHF.AddChild(nil)));
  GHF.AddChild(GHF.AddChild(nil));
  GHF.AddChild(nil);

//GHF.Perform(WM_MOVE,GHF.Left,GHF.Top);
end;

end.

