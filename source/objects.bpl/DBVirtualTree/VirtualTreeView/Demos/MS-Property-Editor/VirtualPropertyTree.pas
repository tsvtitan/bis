unit VirtualPropertyTree;

// Version 1.0
//
// The contents of this Package are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The original code is Virtual Property Tree, first released on October 15, 2002.
//
// The initial developer of the original code is Carmi Grushko (sf_yourshadow@bezeqint.net)
//
//----------------------------------------------------------------------------------------------------------------------
//
// History :
// => 15/10/2002 - First release
//
//----------------------------------------------------------------------------------------------------------------------
//

interface

uses Windows, Messages, VirtualTrees, Classes, Controls, SysUtils, Graphics, StdCtrls,
     Forms, Buttons, Math, Dialogs;

type
  TDataType = ( dtInteger, dtString, dtCombo, dtColor, dtExtended );
  TField = record
    Name : string;
    Category : string;
    Data : pointer;
    DataType : TDataType;

    // dtCombo support
    ComboData : array of string;

    // dtInteger/dtExtended support
    MinValue,
    MaxValue : integer;
  end;
  PField = ^TField;

  TCategory = record
    Name : string;
    Fields : array of PField;
  end;
  TCategories = array of TCategory;

  TVTPropertyEdit = class(TCustomEdit)
  private
    FNode : PVirtualNode;
    ExecuteKillFocus : boolean;

    procedure WMChar(var Message: TWMChar); message WM_CHAR;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;

    procedure CancelEdit;
    procedure EndEdit;
    procedure UpdateParent;
  public
    constructor Create(AOwner : TComponent); override;
    procedure UpdateSize( ATree : TVirtualStringTree );
  end;

  TVTPropertyCombo = class( TComboBox )
  private
    FNode : PVirtualNode;
  protected
    procedure CreateWnd; override;
    procedure Change; override;      
  public
    procedure UpdateSize( ATree : TVirtualStringTree );
  end;

  TVTPropertyColor = class(TCustomControl)
  private
    FColor : TColor;

    FButton : TSpeedButton;
    FEdit : TVTPropertyEdit;

    procedure UpdateEdit;
    procedure MyButtonClick( Sender : TObject );
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner : TComponent); override;
    procedure UpdateSize( ATree : TVirtualStringTree );
  end;
  
  TVirtualPropertyTree = class( TVirtualStringTree )
  private
    FEdit : TVTPropertyEdit;
    FCombo : TVTPropertyCombo;
    FTridot : TVTPropertyColor;
    FCategories : TCategories;
    function IndexOf(CategoryName: string): integer;
    function GetButtonIndex(Node: PVirtualNode): integer;
    procedure MoveEditor( Node : PVirtualNode );
    function SetFieldValue( Node : PVirtualNode; Text : string ) : boolean;
    function GetNodeField( Node : PVirtualNode ) : PField;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMSize( var Message : TWMSize ); message WM_SIZE;
  protected
    procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var Text: WideString); override;
    procedure DoInitNode(Parent, Node: PVirtualNode; var InitStates: TVirtualNodeInitStates); override;
    procedure DoInitChildren(Node: PVirtualNode; var ChildCount: Cardinal); override;
    procedure DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex;
      TextType: TVSTTextType); override;
    procedure DoAfterItemPaint(Canvas: TCanvas; Node: PVirtualNode; ItemRect: TRect); override;
    function DoPaintBackground(Canvas: TCanvas; R: TRect): Boolean; override;
    procedure DoPaintNode(var PaintInfo: TVTPaintInfo); override;
    procedure DoChange(Node: PVirtualNode); override;
    procedure DoNewText(Node: PVirtualNode; Column: TColumnIndex; Text: WideString); override;

    procedure Loaded; override;

    procedure DetermineHitPositionLTR(var HitInfo: THitInfo; Offset, Right: Integer; Alignment: TAlignment); override;
  public
    Fields : array of TField;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure RefreshFields;

    property Categories: TCategories read FCategories write FCategories;
  end;

var
  EditorButtons : array[ 0..1 ] of TBitmap;

const
  ebDrop = 0;
  ebTridot = 1;

procedure Register;

{$R editor-buttons.res}

implementation

function FieldToStr( Field : TField ) : string;
begin
     with Field do
       case DataType of
         dtInteger:  Result := IntToStr( PInteger(Data)^ );
         dtString:   Result := PString(Data)^;
         dtCombo:    Result := ComboData[ PInteger(Data)^ ];
         dtColor:    Result := Format( '%d, %d, %d', [
                                                      (PColor(Data)^ and $000000FF) shr 0, // Red
                                                      (PColor(Data)^ and $0000FF00) shr 8, // Green
                                                      (PColor(Data)^ and $00FF0000) shr 16 // Blue
                                                    ] );
         dtExtended: Result := FloatToStr( PExtended(Data)^ );
       end;
end;

function MyStrToColor( Text : string ) : TColor;
var Values : array[0..2] of Byte;
    i : integer;
begin
     Text := Text + ',';

     for i := 0 to 2 do
     begin
          Values[i] := StrToInt( Copy(Text, 1, Pos(',', Text)-1 ) );
          Delete( Text, 1, Pos(',', Text) );
     end;

     Result := 0;
     Result := Result or Values[0] shl 0;
     Result := Result or Values[1] shl 8;
     Result := Result or Values[2] shl 16;
end;

function TVirtualPropertyTree.GetButtonIndex( Node : PVirtualNode ) : integer;
var DataType : TDataType;
begin
     Result := -1;
     if (Node^.Parent <> RootNode) then
     begin
          DataType := FCategories[Node^.Parent^.Index].Fields[Node^.Index]^.DataType;
          if (DataType = dtCombo) or (DataType = dtColor) then
            Result := 0;
     end else
     begin
          Result := -2;
     end;
end;

procedure Register;
begin
     RegisterComponents( 'Virtual Controls', [TVirtualPropertyTree] );
end;

// If EditorButtons[Index] is nil, we have to load it from resources; not before.
function AccessEditorBitmap( Index : integer ) : TBitmap;
begin
     if EditorButtons[Index] = nil then
     begin
          EditorButtons[Index] := TBitmap.Create;
          EditorButtons[Index].LoadFromResourceID( HInstance, Index+1 );
     end;

     Result := EditorButtons[Index];
end;

{ TVirtualPropertyTree }

constructor TVirtualPropertyTree.Create(AOwner: TComponent);
begin
     inherited;

     SetLength( Fields, 0 );
     SetLength( FCategories, 0 );

     // Editors
     FEdit := TVTPropertyEdit.Create( Self );
     with FEdit do
     begin
          Parent := Self;
          Hide;
     end;

     FCombo := TVTPropertyCombo.Create( Self );
     with FCombo do
     begin
          Parent := Self;
          Hide;
     end;

     FTridot := TVTPropertyColor.Create( Self );
     with FTridot do
     begin
          Parent := Self;
          Hide;
     end;
end;

procedure TVirtualPropertyTree.DetermineHitPositionLTR(
  var HitInfo: THitInfo; Offset, Right: Integer; Alignment: TAlignment);
begin
     inherited;
     if (HitInfo.HitColumn = 0) and (Offset in [0..14]) then
     begin
          Include( HitInfo.HitPositions, hiOnItemButton );
     end;
     if (HitInfo.HitColumn = 1) and (Offset > Right-17) and (vsSelected in HitInfo.HitNode^.States) and
        (GetButtonIndex( HitInfo.HitNode ) > -1) then
        HitInfo.HitPositions := [hiOnItemCheckbox];
end;

procedure TVirtualPropertyTree.DoAfterItemPaint(Canvas: TCanvas;
  Node: PVirtualNode; ItemRect: TRect);
begin
     with Canvas do
     begin
          Brush.Color := clWindow;
          FillRect( Rect(0, ItemRect.Top, 15, ItemRect.Bottom) );

          Pen.Color := Colors.GridLineColor;
          PolyLine( [Point(15, ItemRect.Top), Point(15, ItemRect.Bottom)] );

          // Modified from VirtualTrees.pas :
          //   Show node button if allowed, if there child nodes and at least one of the child
          //   nodes is visible or auto button hiding is disabled.
          if (vsHasChildren in Node.States) and
            not (vsAllChildrenHidden in Node.States) then
            PaintNodeButton( Canvas, Node, ItemRect, 3, 3, bdLeftToRight );
     end;
     inherited;
end;

procedure TVirtualPropertyTree.DoGetText(Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString);
begin
     if (Node^.Parent = RootNode) then
     begin
          if Column = 0 then
          begin
               Text := FCategories[Node^.Index].Name;
          end else
          begin
               Text := '';
          end;
     end else
     begin
          if Column = 0 then
            Text := (FCategories[Node^.Parent^.Index].Fields[Node^.Index])^.Name
          else
            Text := FieldToStr( (FCategories[Node^.Parent^.Index].Fields[Node^.Index])^ );
     end;

     inherited;
end;

procedure TVirtualPropertyTree.DoInitChildren(Node: PVirtualNode;
  var ChildCount: Cardinal);
begin
     ChildCount := Length( FCategories[Node^.Index].Fields );

     inherited;
end;

procedure TVirtualPropertyTree.DoInitNode(Parent, Node: PVirtualNode;
  var InitStates: TVirtualNodeInitStates);
begin
     if Node^.Parent = RootNode then
       Include( InitStates, ivsHasChildren );

     Include( InitStates, ivsExpanded );

     inherited;
end;

function TVirtualPropertyTree.DoPaintBackground(Canvas: TCanvas;
  R: TRect): Boolean;
begin
     with Canvas do
     begin
          Pen.Color := Colors.GridLineColor;
          PolyLine( [Point(15, 0), Point(15, GetTreeRect.Bottom)] );  // Check ! what about R ?!
     end;
     Result := inherited DoPaintBackground( Canvas, R );
end;

procedure TVirtualPropertyTree.DoPaintText(Node: PVirtualNode;
  const Canvas: TCanvas; Column: TColumnIndex; TextType: TVSTTextType);
begin
     if Node^.Parent = RootNode then
     begin
          Canvas.Font.Style := Canvas.Font.Style + [fsBold];
     end;

     if vsSelected in Node^.States then
     begin
          if Column = 1 then
            Canvas.Font.Color := Font.Color
          else
            Canvas.Font.Color := clWindow;
     end else
     begin
          Canvas.Font.Color := Font.Color;
     end;

     inherited;
end;

function TVirtualPropertyTree.IndexOf( CategoryName : string ) : integer;
var i : integer;
begin
     Result := -1;
     for i := 0 to Length(FCategories)-1 do
       if FCategories[i].Name = CategoryName then
       begin
            Result := i;
            exit;
       end;
end;

procedure TVirtualPropertyTree.RefreshFields;
var i, j, k : integer;
begin
     FEdit.Hide;
     FCombo.Hide;
     FTridot.Hide;

     ClearSelection;

     SetLength( FCategories, 0 );

     // Build Categories
     for i := 0 to Length(Fields)-1 do
     begin
          j := IndexOf( Fields[i].Category );
          if j <> -1 then
          begin
               // Add this field to this category
               k := Length( FCategories[j].Fields );
               SetLength( FCategories[j].Fields, k+1 );
               FCategories[j].Fields[k] := @(Fields[i]);
          end else
          begin
               // Create a new category
               j := Length( FCategories );
               SetLength( FCategories, j+1 );
               FCategories[j].Name := Fields[i].Category;
               SetLength( FCategories[j].Fields, 1 );
               FCategories[j].Fields[0] := @(Fields[i]);
          end;
     end;

     RootNodeCount := Length( FCategories );
     ReinitNode( nil, true );

     Header.Columns[0].Width := GetMaxColumnWidth( 0 );
end;

//----------------- TVTPropertyEdit --------------------------------------------------------------------------------------------

// Implementation of a generic node caption editor.

constructor TVTPropertyEdit.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);
  ShowHint := False;
  ParentShowHint := False;
  BorderStyle := bsNone;
  ExecuteKillFocus := true;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVTPropertyEdit.WMChar(var Message: TWMChar);

begin
  if not (Message.CharCode in [VK_ESCAPE{, VK_TAB}]) then
    inherited;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVTPropertyEdit.WMGetDlgCode(var Message: TWMGetDlgCode);

begin
  inherited;

  Message.Result := Message.Result or DLGC_WANTTAB;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVTPropertyEdit.WMKeyDown(var Message: TWMKeyDown);

// Handles some control keys.

begin
  case Message.CharCode of
    // pretend these keycodes were sent to the tree
    VK_ESCAPE:
      CancelEdit;
    VK_RETURN:
      EndEdit;
    VK_TAB:
      EndEdit;
    VK_UP:
      begin
        Message.CharCode := VK_LEFT;
        inherited;
      end;
    VK_DOWN:
      begin
        Message.CharCode := VK_RIGHT;
        inherited;
      end;
  else
    inherited;
  end;
end;

procedure TVirtualPropertyTree.DoPaintNode(var PaintInfo: TVTPaintInfo);
begin
     with PaintInfo do
     begin
          if Column = 1 then
          begin
               dec( ContentRect.Left, Margin );

               with Node^, (FCategories[Parent^.Index].Fields[Index])^ do
                 if (DataType = dtColor) and (Parent <> RootNode) then
                 begin
                      Canvas.Pen.Color := clBlack;
                      Canvas.Brush.Color := PColor(Data)^;
                      Canvas.Rectangle( ContentRect.Left+1, ContentRect.Top+1, ContentRect.Left+13, ContentRect.Bottom-1 );

                      inc( ContentRect.Left, 18 );
                 end;
          end;

          if (Column = 0) and (vsSelected in Node^.States) then
          begin
               Canvas.Brush.Color := clHighlight;
               Canvas.FillRect( CellRect );
          end;

          if (Column = 1) and (vsSelected in Node^.States) then
          begin
               Canvas.Brush.Color := Self.Color;
               Canvas.FillRect( CellRect );
          end;
     end;

     inherited;
end;

procedure TVirtualPropertyTree.DoChange(Node: PVirtualNode);
begin
     inherited;
     if (Node <> nil) and (vsSelected in Node^.States) then
       MoveEditor( Node );
end;

procedure TVirtualPropertyTree.MoveEditor(Node: PVirtualNode);
var Field : PField;
    i : integer;
begin
     // Move FEdit to Column 1 of Node
     Field := GetNodeField(Node);
     if (Field <> nil) then
     begin
          if (Field^.DataType = dtInteger) or (Field^.DataType = dtString) or
             (Field^.DataType = dtExtended) then
          begin
               FCombo.Hide;
               FTridot.Hide;
               with FEdit do
               begin
                    Hide;
                    Text := FieldToStr( Field^ );  
                    FNode := Node;
                    UpdateSize( Self );
                    Show;
               end;
          end else
          if (Field^.DataType = dtCombo) then
          begin
               FEdit.Hide;
               FTridot.Hide;
               with FCombo do
               begin
                    Hide;

                    Text := FieldToStr(Field^);
                    FNode := Node;

                    Items.Clear;
                    for i := 0 to Length(Field^.ComboData)-1 do
                      Items.Add( Field^.ComboData[i] );
                    ItemIndex := Items.IndexOf( Text );

                    UpdateSize( Self );

                    Show;
               end;
          end else
          if (Field^.DataType = dtColor) then
          begin
               FEdit.Hide;
               FCombo.Hide;
               with FTridot do
               begin
                    Hide;

                    with FEdit do
                    begin
                         Text := FieldToStr(Field^);
                         FNode := Node;
                    end;

                    FColor := PColor( Field^.Data )^;

                    UpdateSize( Self );

                    Show;
               end;
          end;
     end else
     begin
          // No editor
          FEdit.Hide;
          FCombo.Hide;
          FTridot.Hide;
     end;
end;

procedure TVTPropertyEdit.CancelEdit;
begin
     with (Owner as TVirtualPropertyTree) do
     begin
          ExecuteKillFocus := false;
          SetFocus;
          Self.Text := FieldToStr( FCategories[FNode^.Parent^.Index].Fields[FNode^.Index]^ );
          ExecuteKillFocus := true;
     end;
end;

procedure TVTPropertyEdit.EndEdit;
begin
     with (Owner as TVirtualPropertyTree) do
     begin
          ExecuteKillFocus := false;
          UpdateParent;
          SetFocus;
          ExecuteKillFocus := true;          
     end;
end;

procedure TVirtualPropertyTree.DoNewText(Node: PVirtualNode;
  Column: TColumnIndex; Text: WideString);
begin
     if SetFieldValue( Node, Text ) then
       inherited;
end;

function TVirtualPropertyTree.SetFieldValue(Node: PVirtualNode; Text: string) : boolean;
var Field : PField;
    t : integer;
    x : extended;
begin
     Result := true;
     Field := FCategories[Node^.Parent^.Index].Fields[Node^.Index];
     with Field^ do
     begin
          case DataType of
            dtInteger:  try
                          t := StrToInt( Text );
                          if (t >= MinValue) and (t <= MaxValue) then
                            PInteger(Data)^ := t
                          else
                            MessageBox( Handle, PChar(Format( 'Value must be between %d and %d', [MinValue, MaxValue])), 'Error', mb_ok or MB_ICONEXCLAMATION );
                        except
                          MessageBox( Handle, PChar(Format( '%s is not a valid number', [Text] )), 'Error', mb_ok or MB_ICONEXCLAMATION );
                        end;
            dtString:   PString(Data)^ := Text;
            dtCombo:    begin
                             // We assume (hope) that Text is one of ComboData
                             for t := 0 to Length(ComboData)-1 do
                             begin
                                  if ComboData[t] = Text then
                                  begin
                                       PInteger(Data)^ := t;
                                       break;
                                  end;
                             end;
                        end;
            dtColor:    PColor(Data)^ := MyStrToColor( Text );
            dtExtended: try
                          x := StrToFloat( Text );
                          if (x >= MinValue) and (x <= MaxValue) then
                            PExtended(Data)^ := x
                          else
                            MessageBox( Handle, PChar(Format( 'Value must be between %d and %d', [MinValue, MaxValue])), 'Error', mb_ok or MB_ICONEXCLAMATION );
                        except
                          MessageBox( Handle, PChar(Format( '%s is not a valid number', [Text] )), 'Error', mb_ok or MB_ICONEXCLAMATION );
                        end;
          end;
     end;
end;

function TVirtualPropertyTree.GetNodeField( Node : PVirtualNode ): PField;
begin
     Result := nil;
     if Node^.Parent <> RootNode then
       Result := FCategories[Node^.Parent^.Index].Fields[Node^.Index];
end;

procedure TVTPropertyEdit.WMKillFocus(var Message: TWMKillFocus);
begin
     if ExecuteKillFocus then
     begin
          EndEdit;
     end;
     inherited;
end;

procedure TVirtualPropertyTree.Loaded;
begin
     inherited;

     // Initialize things like Columns and Options
     Colors.GridLineColor := clSilver;
     DefaultNodeHeight := 16;
     EditDelay := 0;
     Header.AutoSizeIndex := 1;
     Header.Columns.Clear;
     with Header.Columns.Add do
     begin
          MaxWidth := MAXINT;
          Width := 80;
     end;
     with Header.Columns.Add do
     begin
          Options := [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible];
          Width := 229;
     end;
     Header.Options := [hoAutoResize, hoColumnResize, hoDblClickResize, hoDrag];

     Indent := 0;
     LineStyle := lsSolid;
     Margin := 16;
     TextMargin := 0;

     NodeDataSize := SizeOf( TField );
     RootNodeCount := 0;

     TreeOptions.MiscOptions := [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning];
     TreeOptions.PaintOptions := [toHideFocusRect, toHideSelection, toPopupMode, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages];
     TreeOptions.SelectionOptions := [toFullRowSelect];
end;

procedure TVirtualPropertyTree.WMLButtonDown(var Message: TWMLButtonDown);
var HitInfo : THitInfo;
begin
     inherited;

     GetHitTestInfoAt( Message.XPos, Message.YPos, true, HitInfo );

     // If we're talking about Drop-fields
     if (HitInfo.HitNode <> nil) and (HitInfo.HitPositions = [hiOnItemCheckbox]) then
       EditNode( HitInfo.HitNode, 0 );

     if (HitInfo.HitNode <> nil) and (hiOnItemButton in HitInfo.HitPositions) then
     begin
          Selected[FocusedNode] := false;
          FocusedNode := HitInfo.HitNode;
          Selected[FocusedNode] := true;
     end;
end;

destructor TVirtualPropertyTree.Destroy;
begin
     Finalize( FCategories );
     inherited;
end;

procedure TVirtualPropertyTree.WMSize(var Message: TWMSize);
begin
     inherited;
     if FEdit.Visible then
       FEdit.UpdateSize( Self );
     if FCombo.Visible then
       FCombo.UpdateSize( Self );
     if FTridot.Visible then
       FTridot.UpdateSize( Self );
end;

procedure TVTPropertyCombo.Change;
begin
     inherited;

     with (Owner as TVirtualPropertyTree) do
     begin
          if FieldToStr( FCategories[FNode^.Parent^.Index].Fields[FNode^.Index]^ ) <> Self.Text then
          begin
               DoNewText( FNode, 1, Self.Text );
               Self.Text := FieldToStr( FCategories[FNode^.Parent^.Index].Fields[FNode^.Index]^ );
          end;
     end;
end;

procedure TVTPropertyCombo.CreateWnd;
var r : TRect;
begin
     inherited;
     // Set the Edit part of the ComboBox to ReadOnly
     SendMessage( EditHandle, EM_SETREADONLY, 1, 0 );

     // Setting sizes and positions
     GetWindowRect( EditHandle, r );
     SetWindowPos( EditHandle, HWND_TOP, r.Left-1, r.Top+1, r.Bottom, r.Right, SWP_NOZORDER );
end;

procedure TVTPropertyCombo.UpdateSize(ATree: TVirtualStringTree);
var FBounds : TRect;
begin
     FBounds := ATree.GetDisplayRect( FNode, 1, false );
     dec( FBounds.Top, 3 );
     dec( FBounds.Left, 2 );
     inc( FBounds.Right, 4 );
     BoundsRect := FBounds;

     SetWindowRgn( Handle,
       CreateRectRgn( 2, 3, Width-3, Height-3 ), true );
end;

{ TVTPropertyColor }

constructor TVTPropertyColor.Create(AOwner: TComponent);
begin
     inherited;

     FEdit := TVTPropertyEdit.Create( AOwner );
     with FEdit do
     begin
          Parent := Self;
          ReadOnly := true;
     end;

     FButton := TSpeedButton.Create( Self );
     with FButton do
     begin
          Parent := Self;
          OnClick := MyButtonClick;
          Glyph := AccessEditorBitmap( ebTridot );
     end;
end;

procedure TVTPropertyColor.MyButtonClick(Sender: TObject);
var ColorDialog : TColorDialog;
begin
     ColorDialog := TColorDialog.Create( Self );
     with ColorDialog do
     begin
          Color := FColor;
          Options := [cdFullOpen, cdAnyColor];

          if Execute then
          begin
               FColor := Color;
               UpdateEdit;
               with FEdit do
               begin
                    EndEdit;
               end;
               Paint;
          end;
     end;
end;

procedure TVTPropertyColor.Paint;
begin
     inherited;
     with Canvas do
     begin
          Pen.Color := (Parent as TVirtualPropertyTree).Colors.GridLineColor;
          PolyLine( [ Point(0, 0), Point(Width, 0) ] );
          PolyLine( [ Point(0, Height-1), Point(Width, Height-1) ] );

          Pen.Color := clBlack;
          Brush.Color := FColor;
          Rectangle( 1, 2, 1+12, Height-2 );
     end;
end;

procedure TVTPropertyColor.UpdateEdit;
begin
     FEdit.Text := Format( '%d, %d, %d', [
                                                  (FColor and $000000FF) shr 0, // Red
                                                  (FColor and $0000FF00) shr 8, // Green
                                                  (FColor and $00FF0000) shr 16 // Blue
                                                ] );
end;

procedure TVTPropertyEdit.UpdateSize(ATree: TVirtualStringTree);
var FBounds : TRect;
begin
     FBounds := ATree.GetDisplayRect( FNode, 1, false );
     dec( FBounds.Bottom );
     inc( FBounds.Top );

     BoundsRect := FBounds;
end;

procedure TVTPropertyColor.UpdateSize(ATree: TVirtualStringTree);
var FBounds : TRect;
begin
     FBounds := ATree.GetDisplayRect( FEdit.FNode, 1, false );
     dec( FBounds.Top );
     inc( FBounds.Right );
     BoundsRect := FBounds;

     FEdit.BoundsRect := Rect( 18, 2, Width-17, Height-1 );
     FButton.BoundsRect := Rect( Width-18, 0, Width, Height );
end;

procedure TVTPropertyEdit.UpdateParent;
begin
     with (Owner as TVirtualPropertyTree) do
     begin
          if FieldToStr( FCategories[FNode^.Parent^.Index].Fields[FNode^.Index]^ ) <> Self.Text then
          begin
               DoNewText( FNode, 1, Self.Text );
               Self.Text := FieldToStr( FCategories[FNode^.Parent^.Index].Fields[FNode^.Index]^ );
          end;
     end;
end;

initialization

  EditorButtons[0] := nil;
  EditorButtons[1] := nil;

finalization

  EditorButtons[0].Free;
  EditorButtons[1].Free;

end.
