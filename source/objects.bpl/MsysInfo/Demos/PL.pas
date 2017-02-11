unit PL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmPerfLib = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Tree: TTreeView;
    Box: TListBox;
    sb: TStatusBar;
    Panel4: TPanel;
    Panel6: TPanel;
    Timer: TTimer;
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure TreeDblClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    PerfLib: TObject;
  public
    procedure Refresh;
  end;

var
  frmPerfLib: TfrmPerfLib;

implementation

uses MiTeC_Routines, MiTeC_PerfLib9x, MiTeC_PerfLibNT, CP;

{$R *.DFM}

{ TfrmPerfLib }

procedure TfrmPerfLib.Refresh;
var
  szObj, szCtr: string;
  i,j,k: integer;
  Child, Root: TTreeNode;
begin
  Screen.Cursor:=crHourGlass;
  if IsNT then begin
    PerfLib:=TPerfLibNT.Create;
    with TPerfLibNT(PerfLib) do begin
      Refresh;
      sb.Panels[0].Text:=Format('Performance Library %d.%d',[Version, Revision]);
      for i:=0 to ObjectCount-1 do begin
        Root:=Tree.Items.Add(nil,Objects[i].Name);
        for j:=0 to Objects[i].CounterCount-1 do
          Child:=Tree.Items.AddChild(Root,Objects[i].Counters[j].Name);
      end;
    end;
  end else
    if IsOSR2 or Is98 or IsME then begin
      PerfLib:=TPerfLib9x.Create;
      with TPerfLib9x(PerfLib) do begin
        Open;
        for i:=Names.Count-1 downto 0 do begin
          k:=Pos('\',Names[i]);
          if k>0 then begin
            szObj:=Copy(Names[i],1,k-1);
            szCtr:=Copy(Names[i],k+1,255);
          end;
          Root:=Tree.Items.GetFirstNode;
          while Assigned(Root) do
            if Root.Text=szObj then
              Break
            else
              Root:=Root.GetNextSibling;
          if not Assigned(Root) then
            Root:=Tree.Items.Add(nil,szObj);
          if szCtr<>'' then
            Child:=Tree.Items.AddChild(Root,szCtr);
        end;
      end;
    end;
  Screen.Cursor:=crDefault;
end;

procedure TfrmPerfLib.TreeChange(Sender: TObject; Node: TTreeNode);
var
  i,oi,ci: integer;
  s: string;
begin
  if Assigned(Node) then begin
    Box.Items.Clear;
    if IsNT then begin
      TPerfLibNT(PerfLib).TakeSnapShot;
      if Assigned(Node.Parent) then
        oi:=TPerfLibNT(PerfLib).GetIndexByName(Node.Parent.Text)
      else
        oi:=TPerfLibNT(PerfLib).GetIndexByName(Node.Text);
      if Assigned(Node.Parent) then
        s:=TPerfLibNT(PerfLib).Objects[oi].Counters[ci].DataStrEx[0]
      else
        s:='';
      if TPerfLibNT(PerfLib).Objects[oi].InstanceCount>0 then begin
        for i:=0 to TPerfLibNT(PerfLib).Objects[oi].InstanceCount-1 do begin
          s:=TPerfLibNT(PerfLib).Objects[oi].Instances[i].Name;
          if Assigned(Node.Parent) then begin
            ci:=TPerfLibNT(PerfLib).Objects[oi].GetCntrIndexByName(Node.Text);
            s:=s+' = '+TPerfLibNT(PerfLib).Objects[oi].Counters[ci].DataStrEx[i];
          end;
          Box.Items.Add(s);
        end;
      end else
        Box.Items.Add(s);
    end else begin
      if Assigned(Node.Parent) then
        Box.Items.Add(Format('%d',[TPerfLib9x(PerfLib).SysData[Node.Parent.Text+'\'+Node.Text]]));
    end;
  end;
end;

procedure TfrmPerfLib.TreeDblClick(Sender: TObject);
begin
  if Assigned(Tree.Selected.Parent) then
    ShowPropsDlg(PerfLib,VarArrayOf([Tree.Selected.Text,Tree.Selected.Parent.Text]))
  else
    ShowPropsDlg(PerfLib,Tree.Selected.Text);
end;

procedure TfrmPerfLib.TimerTimer(Sender: TObject);
begin
  TreeChange(Tree,Tree.Selected);
end;

end.
