
{******************************************}
{                                          }
{             FastReport v4.0              }
{               Report Tree                }
{                                          }
{         Copyright (c) 1998-2007          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxReportTree;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, frxClass
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxReportTreeForm = class(TForm)
    Tree: TTreeView;
    procedure FormShow(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure TreeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FComponents: TList;
    FDesigner: TfrxCustomDesigner;
    FNodes: TList;
    FReport: TfrxReport;
    FUpdating: Boolean;
    FOnSelectionChanged: TNotifyEvent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetColor(Value: TColor);
    procedure UpdateItems;
    procedure UpdateSelection;
    property OnSelectionChanged: TNotifyEvent read FOnSelectionChanged
      write FOnSelectionChanged;
  end;


implementation

{$R *.DFM}

uses frxRes, frxDesgn, frxDsgnIntf;

type
  THackWinControl = class(TWinControl);


{ TfrxReportTreeForm }

constructor TfrxReportTreeForm.Create(AOwner: TComponent);
begin
  inherited;
  FComponents := TList.Create;
  FNodes := TList.Create;
{$IFDEF UseTabset}
  Tree.BevelKind := bkFlat;
{$ELSE}
  Tree.BorderStyle := bsSingle;
{$ENDIF}
end;

destructor TfrxReportTreeForm.Destroy;
begin
  FComponents.Free;
  FNodes.Free;
  inherited;
end;

procedure TfrxReportTreeForm.FormShow(Sender: TObject);
begin
  UpdateItems;
end;

procedure TfrxReportTreeForm.UpdateItems;

  procedure SetImageIndex(Node: TTreeNode; Index: Integer);
  begin
    Node.ImageIndex := Index;
    Node.StateIndex := Index;
    Node.SelectedIndex := Index;
  end;

  procedure EnumItems(c: TfrxComponent; RootNode: TTreeNode);
  var
    i: Integer;
    Node: TTreeNode;
    Item: TfrxObjectItem;
  begin
    Node := Tree.Items.AddChild(RootNode, c.Name);
    FComponents.Add(c);
    FNodes.Add(Node);
    Node.Data := c;
    if c is TfrxReport then
    begin
      Node.Text := 'Report';
      SetImageIndex(Node, 34);
    end
    else if c is TfrxReportPage then
      SetImageIndex(Node, 35)
    else if c is TfrxDialogPage then
      SetImageIndex(Node, 36)
    else if c is TfrxDataPage then
      SetImageIndex(Node, 37)
    else if c is TfrxBand then
      SetImageIndex(Node, 40)
    else
    begin
      for i := 0 to frxObjects.Count - 1 do
      begin
        Item := frxObjects[i];
        if Item.ClassRef = c.ClassType then
        begin
          SetImageIndex(Node, Item.ButtonImageIndex);
          break;
        end;
      end;
    end;

    if c is TfrxDataPage then
    begin
      for i := 0 to c.Objects.Count - 1 do
        if TObject(c.Objects[i]) is TfrxDialogComponent then
          EnumItems(c.Objects[i], Node)
    end
    else
      for i := 0 to c.Objects.Count - 1 do
        EnumItems(c.Objects[i], Node);
  end;

begin
  Tree.Items.BeginUpdate;
  Tree.Items.Clear;
  FComponents.Clear;
  FNodes.Clear;
  EnumItems(FReport, nil);

  Tree.FullExpand;
  UpdateSelection;
  Tree.Items.EndUpdate;
end;

procedure TfrxReportTreeForm.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  if FUpdating then Exit;
  FDesigner.SelectedObjects.Clear;
  FDesigner.SelectedObjects.Add(Tree.Selected.Data);
  if Assigned(FOnSelectionChanged) then
    FOnSelectionChanged(Self);
end;

procedure TfrxReportTreeForm.SetColor(Value: TColor);
begin
  Tree.Color := Value;
  UpdateItems;
end;

procedure TfrxReportTreeForm.FormCreate(Sender: TObject);
begin
  FDesigner := TfrxCustomDesigner(Owner);
  FReport := FDesigner.Report;
  Tree.Images := frxResources.ObjectImages;
  Caption := frxGet(2200);

  if UseRightToLeftAlignment then
    FlipChildren(True);
end;

procedure TfrxReportTreeForm.UpdateSelection;
var
  c: TComponent;
  i: Integer;
begin
  if FDesigner.SelectedObjects.Count = 0 then Exit;
  c := FDesigner.SelectedObjects[0];
  FUpdating := True;

  i := FComponents.IndexOf(c);
  if i <> -1 then
  begin
    TTreeNode(FNodes[i]).Selected := True;
    Tree.TopItem := TTreeNode(FNodes[i]);
  end;

  FUpdating := False;
end;

procedure TfrxReportTreeForm.TreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Delete then
  begin
    THackWinControl(TfrxDesignerForm(FDesigner).Workspace).KeyDown(Key, Shift);
  end;
end;

end.


//c6320e911414fd32c7660fd434e23c87