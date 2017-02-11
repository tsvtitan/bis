unit VirtualButtonTree;

interface

uses
  Windows, Messages, VirtualTrees, Graphics;

type

  TClickInfo = Record
    Node: PVirtualNode;
    Column: TColumnIndex;
    Point: TPoint;
    Clicking: Boolean;
  end;

  TVTGetButtonInfo = procedure(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var ButtonRect: TRect;
    var HasButton: Boolean; var Caption: String) of object;
  TVTButtonClick = procedure(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex) of object;

  TVirtualButtonTree = class(TVirtualStringTree)
  private
    NodeClicked : TClickInfo;
    FOnGetButtonInfo: TVTGetButtonInfo;
    FOnButtonClick: TVTButtonClick;
  protected
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure DoAfterCellPaint(Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect); override;
  published
    property OnGetButtonInfo: TVTGetButtonInfo read FOnGetButtonInfo write FOnGetButtonInfo;
    property OnButtonClick: TVTButtonClick read FOnButtonClick write FOnButtonClick;
  end;

  procedure Register;

implementation

uses Types, Controls, Classes;

procedure Register;
begin
  RegisterComponents( 'Virtual Controls',[TVirtualButtonTree] );
end;

{ TVirtualButtonTree }

procedure TVirtualButtonTree.DoAfterCellPaint(Canvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
var
  ButtonRect: TRect;
  HasButton: Boolean;
  Caption: String;
begin
  if Assigned(FOnGetButtonInfo) then
  begin
      HasButton := False; // Asume there is no button in te cell
      ButtonRect := CellRect;
      FOnGetButtonInfo( Self, Node, Column, ButtonRect, HasButton, Caption);
      if HasButton then //User says there is a button here
      with Canvas do
      begin
        Brush.Style := bsClear;
        Font.Assign( Self.Font );
        Font.Style := Font.Style + [fsBold];
        if (Node = NodeClicked.Node) and (NodeClicked.Clicking) and (Column = NodeClicked.Column) then
        begin
          DrawEdge(Handle, ButtonRect, BDR_SUNKENINNER, BF_RECT or BF_MIDDLE);
          ButtonRect.Top := ButtonRect.Top + 1;
          ButtonRect.Left := ButtonRect.Left + 1;
        end
        else
          DrawEdge(Handle, ButtonRect, BDR_RAISEDINNER, BF_RECT or BF_MIDDLE);
        if Length(Caption) > 0 then
          DrawText( Handle, PChar(Caption),Length(Caption),ButtonRect,DT_CENTER);
        exit;
      end;
  end;
  inherited;
end;

procedure TVirtualButtonTree.WMLButtonDown(var Message: TWMLButtonDown);
begin
  NodeClicked.Clicking := True;
  Inherited;
end;

procedure TVirtualButtonTree.WMLButtonUp(var Message: TWMLButtonUp);
begin
  if Assigned(FOnButtonClick) and (NodeClicked.Node <> nil) and (NodeClicked.Clicking) then
    FOnButtonClick(Self, NodeClicked.Node, NodeClicked.Column);
  NodeClicked.Clicking := False;
  Inherited;
end;

procedure TVirtualButtonTree.WMNCHitTest(var Message: TWMNCHitTest);
var
  HitInfo: THitInfo;
  CellRect, ButtonRect, RealButtonRect: TRect;
  HasButton: Boolean;
  ClientPoint: TPoint;
  Dummy: String;
begin
    if (NodeClicked.Node <> nil) then
      InvalidateNode(NodeClicked.Node);

    ClientPoint := ScreenToClient(Point(Message.XPos, Message.YPos));
    GetHitTestInfoAt(ClientPoint.X, ClientPoint.Y, True, HitInfo);

    if (HitInfo.HitNode = nil) then
    begin
      inherited;
      exit;
    end;

    if Assigned(FOnGetButtonInfo) then
    begin
      CellRect := GetDisplayRect(HitInfo.HitNode, HitInfo.HitColumn, False, False);  // Get the cell's rect
      HasButton := False; // Asume there is no button in te cell
      // The default button's size is the whole cell size
      ButtonRect := Rect(0,0,CellRect.Right - CellRect.Left, CellRect.Bottom - CellRect.Top);
      FOnGetButtonInfo( Self, HitInfo.HitNode, HitInfo.HitColumn, ButtonRect, HasButton, Dummy);
      if HasButton then //User says there is a button here
      begin
        RealButtonRect := Rect( CellRect.Left + ButtonRect.Left, CellRect.Top + ButtonRect.Top, 0, 0);
        RealButtonRect.Bottom := RealButtonRect.Top + (ButtonRect.Bottom-ButtonRect.Top);
        RealButtonRect.Right := RealButtonRect.Left + (ButtonRect.Right-ButtonRect.Left)+1;
        if PtInRect( RealButtonRect, ClientPoint) then
        begin
          NodeClicked.Node := HitInfo.HitNode;
          NodeClicked.Column := HitInfo.HitColumn;
          NodeClicked.Point := ClientPoint;
          NodeClicked.Point := ClientPoint;

          InvalidateNode(HitInfo.HitNode);
        end
        else
          NodeClicked.Node := Nil;
      end
      else
        NodeClicked.Node := Nil;
    end;
  inherited;
end;


end.
