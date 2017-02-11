{-----------------------------------------------------------}
{----Purpose : VirtualStringTree Descendant Emulating both  }
{              TTreeNodes & TListItems.                     }
{    By      : Ir. G.W. van der Vegt                        }
{    For     :                                              }
{    Module  : VirtualStringTreeData.pas                    }
{    Depends : VirtualTrees 3.2.1                           }
{    Version : 3.2.1                                        }    
{-----------------------------------------------------------}
{ ddmmyyyy comment                                          }
{ -------- -------------------------------------------------}
{ 08072001-Initial version.                                 }
{         -Removed AbsoluteIndex code.                      }                      
{ 11072001-Added an Unique Id to link VirtualstringTree and }
{          Data in collection Items.                        }
{         -TListItems Emulation now works in Indexes of     }
{          the Collection (they renumber) and TTreeNodes    }
{          emulation always works on Nodes and therefor     }
{          works with the Id only.                          }
{         -With the Idx/Id appending one can see nicely that}
{          collections silently renumber.                   }
{         -Replaced all Cardinals with Integer for to get   }
{          an error value of -1.                            }
{         -Added Recursive Deletion of Nodes.               }
{         -Added TTreeNode properties Count, Expanded,      }
{          Focused, HasChildren, Level and Selected.        }
{         -Added GetFirstNode.                              } 
{         -Added Checkboxes property.                       }
{ 20082001-Removed Id and started using Node Pointer        }
{          instead.                                         }
{         -Now using the CollectionItem's internal unique   }
{          Id as link from VT back to Collection. Stored    }
{          value in NodeData.                               }
{         -Integrated into a TVirtualStringTree descendant. }                      
{         -Solved Problem with first node.                  }
{         -Assign seems to work.                            }
{ 20092001-Ported to 2.5.34 and made it a                   }
{          TCustomVirtualStringTree Descendant.             }
{         -Removed Default n/a captions/texts.              }
{ 21092001-Added other (nog OnGetText) properties.          }
{ 14102001-Made compatible with 2.5.40.                     }
{ 07022002-Fixed AddChild(nil,'caption');                   }
{ 03023002-Fixed same bug in AddNode and 2 other functions. }
{         -Changed Checkboxes to TriState because it's more }
{          usefull for trees.                               }
{ 19032002-Removed Memory Leaks with Snoop.                 }
{ 08052002-Started on Sorting of Data.                      }
{         -Added new OnCompareNodes that silently is called }
{          by an overriden DoCompare.                       }
{ 10052002-Made compatible with 3.2.1.                      }
{         -Made it partially aware of AutoSort. It only     }
{          reacts to Caption changes as changes to other    }
{          colums seem to be caught by VirtualStringTree.   }
{         -Implemented OnCompareNodes event needed for      }
{          sorting. Beware to test if subitems exist when   }
{          sorting because it may get called early before   }
{          the Subitems are added.                          }
{
    SAMPLE:
    
    procedure TForm1.VirtualStringTreeData1CompareNodes(<P>
      Sender: TBaseVirtualTree; Node1, Node2: TVirtualListViewItem;
      Column: TColumnIndex; var Result: Integer);
    begin
      case column of
        -1,
         0 : Result:=CompareText(Node1.Caption,Node2.Caption);
      else
        begin
          if (Node1.SubItems.Count>=Column) and (Node2.SubItems.Count>=Column)
            then Result:=CompareText(Node1.SubItems[Column-1],Node2.SubItems[Column-1])
            else Result:=0;
        end
      end
    end;
}
{-----------------------------------------------------------}
{ TODO:   -Exceptions for things that won't/                }
{          can't/shouldn't happen.                          }
{         -Move Checkboxes and others into TreeOptions.     }
{         -See what to use, Index or Id for insert stuff.   }
{         -Editing on design time still fails.              }
{         -Limit sorting to calling only if                 }
{          something in the sortcolumn has changed.         }
{-----------------------------------------------------------}
{
@abstract(provides a emulation of Both TTreeNodes and TListItems
for usage with VirtualStringTree.)
@author(G.W. van der Vegt <wvd_vegt@knoware.nl>)
@created(July 08, 2001)
@lastmod(May 10, 2002)
This unit an Emulation of both the TTreeNodes and TListItems datastructures so
they can be used with the TVirtualStringTree. By setting the TVirtualStringTree
property the Datasize is set to 4 to be able to hold the Id of the nodes used to
link the collection of data to the actual nodes.
Only data for the Caption (and possible Subitems) are stored in this collection. Other
properties like checked are retrieved from the TVirtualStringTree itself.
@LINK(RttiGrid) is an example of this object.
}
unit VirtualStringTreeData;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualTrees, Imglist;

{ DEFINE DEBUG}

type
  {Forward Declaration}
  TVirtualListViewItem   = class;
  TVirtualListViewItems  = class;

  TVTDCompareEvent = procedure(Sender: TBaseVirtualTree; Node1, Node2: TVirtualListViewItem; Column: TColumnIndex;
    var Result: Integer) of object;

  TVirtualStringTreeData = class(TCustomVirtualStringTree)
  private
    { Private declarations }

    {A Collection containing the actual Tree/ListView of Content.}
    FVirtualListViewItems : TVirtualListViewItems;
    FOnCompareEvent: TVTDCompareEvent;
    {This will set the checktype of all nodes and in/exclude
     voCheckSupport from the VirtualTreeView's options. If set for a tree,
     all nodes will have checkboxes. If thats not the intention one can set
     (and quickly reset fi nessecary) the checked property of the items that
     need a checkbox. This will }
//  FCheckBoxes: Boolean;
//  procedure SetCheckBoxes(const Value: Boolean);
  protected
    { Protected declarations }
    function GetOptionsClass: TTreeOptionsClass; override;
    procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString); override;
    procedure DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var Index: Integer); override;
    function DoCompare(Node1, Node2: PVirtualNode; Column: TColumnIndex): Integer; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
  //Default Properties
    property Align;          
    property Alignment;
    property Anchors;
    property AnimationDuration;
    property AutoExpandDelay;
    property AutoScrollDelay;
    property AutoScrollInterval;
    property Background;
    property BackgroundOffsetX;
    property BackgroundOffsetY;
    property BiDiMode;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    property BorderStyle;
    property ButtonFillMode;
    property ButtonStyle;
    property BorderWidth;
    property ChangeDelay;
    property CheckImageKind;
    property ClipboardFormats;
    property Color;
    property Colors;
    property Constraints;
    property Ctl3D;
    property CustomCheckImages;
    property DefaultNodeHeight;
    property DefaultPasteMode;
    property DefaultText;
    property DragHeight;
    property DragKind;
    property DragImageKind;
    property DragMode;
    property DragOperations;
    property DragType;
    property DragWidth;
    property DrawSelectionMode;
    property EditDelay;
    property Enabled;
    property Font;
    property Header;
    property HintAnimation;
    property HintMode;
    property HotCursor;
    property Images;
    property IncrementalSearch;
    property IncrementalSearchDirection;
    property IncrementalSearchStart;
    property IncrementalSearchTimeout;
    property Indent;
    property LineMode;
    property LineStyle;
    property Margin;
    property NodeAlignment;
    property NodeDataSize;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RootNodeCount;
    property ScrollBarOptions;
    property SelectionCurveRadius;
    property ShowHint;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    property TextMargin;
    property TreeOptions;
    property Visible;
    property WantTabs;

  //Default EventHandlers
    property OnAfterCellPaint;
    property OnAfterItemErase;
    property OnAfterItemPaint;
    property OnAfterPaint;
    property OnBeforeCellPaint;
    property OnBeforeItemErase;
    property OnBeforeItemPaint;
    property OnBeforePaint;
    property OnChange;
    property OnChecked;
    property OnChecking;
    property OnClick;
    property OnCollapsed;
    property OnCollapsing;
    property OnColumnClick;
    property OnColumnDblClick;
    property OnColumnResize;
    { This property is called when toAutoSort is enabled in the AutoOptions.}
    property OnCompareNodes : TVTDCompareEvent read FOnCompareEvent write FOnCompareEvent;
    property OnCreateDataObject;
    property OnCreateDragManager;
    property OnCreateEditor;
    property OnDblClick;
    property OnDragAllowed;
    property OnDragOver;
    property OnDragDrop;
    property OnEditCancelled;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpanded;
    property OnExpanding;
    property OnFocusChanged;
    property OnFocusChanging;
    property OnFreeNode;
//  property OnGetText;
    property OnPaintText;
    property OnGetHelpContext;
    property OnGetImageIndex;
    property OnGetHint;
    property OnGetLineStyle;
    property OnGetNodeDataSize;
    property OnGetPopupMenu;
    property OnGetUserClipboardFormats;
    property OnHeaderClick;
    property OnHeaderDblClick;
    property OnHeaderDragged;
    property OnHeaderDragging;
    property OnHeaderDraw;
    property OnHeaderMouseDown;
    property OnHeaderMouseMove;
    property OnHeaderMouseUp;
    property OnHotChange;
    property OnIncrementalSearch;
    property OnInitChildren;
    property OnInitNode;
    property OnKeyAction;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnLoadNode;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnNewText;
    property OnNodeCopied;
    property OnNodeCopying;
    property OnNodeMoved;
    property OnNodeMoving;
    property OnPaintBackground;
    property OnRenderOLEData;
    property OnResetNode;
    property OnResize;
    property OnSaveNode;
    property OnScroll;
    property OnShortenString;
    property OnStartDock;
    property OnStartDrag;
    property OnStructureChange;
    property OnUpdating;

  //New Properties
    {This will set the checktype of all nodes and in/exclude
     voCheckSupport from the VirtualTreeView's options. If set for a tree,
     all nodes will have checkboxes. If thats not the intention one can set
     (and quickly reset if nessecary) the checked property of the items that
     need a checkbox.}
//  property CheckBoxes : Boolean read FCheckBoxes write SetCheckBoxes;
    property Data : TVirtualListViewItems read FVirtualListViewItems write FVirtualListViewItems stored True;
    property Items: TVirtualListViewItems read FVirtualListViewItems write FVirtualListViewItems stored True;
    property Nodes: TVirtualListViewItems read FVirtualListViewItems write FVirtualListViewItems stored True;
  end;

{-----------------------------------------------------------}

  {A collection Item containing one line's data.}
  TVirtualListViewItem = class(TCollectionItem)
  private
    { Private Declarations }

    {The Subitems StringsList.}
    FSubItems: TStrings;
    {The Caption String.}
    FCaption: String;
    {An Id to link The VirtualStringTree to the Collectoin}
    FNode: PVirtualNode;
    {The ImageIndex.}
    FImageIndex : TImageIndex;
             
    {GetProperty Function.}
    function GetChecked: Boolean;
    {GetProperty Function.}
    function GetLevel: Integer;
    {GetProperty Function.}
    function GetCount: Integer;
    {GetProperty Function.}
    function GetHasChildren: Boolean;
    {GetProperty Function.}
    function GetSelected: Boolean;
    {GetProperty Function.}
    function GetFocused: Boolean;
    {GetProperty Function.}
    function GetExpanded: Boolean;
    {GetProperty Function.}
    function GetParent: TVirtualListViewItem;
    {GetProperty Function.}
    function GetImageIndex: TImageIndex;

    {SetProperty Procedure.}
    procedure SetChecked(const Value: Boolean);
    {SetProperty Procedure.}
    procedure SetSubItems(const Value: TStrings);
    {SetProperty Procedure.}
    procedure SetSelected(const Value: Boolean);
    {SetProperty Procedure.}
    procedure SetFocussed(const Value: Boolean);
    {SetProperty Procedure.}
    procedure SetExpanded(const Value: Boolean);
    {SetProperty Procedure.}
    procedure SetNode(const Value: PVirtualNode);
    {SetProperty Procedure.}
    procedure SetCaption(const Value: String);
    {SetProperty Procedure.}
    procedure SetImageIndex(const Value : TImageIndex);
  public
    { Public Declarations }

    {A Basic Constructor.}
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    {Assign}
    procedure Assign(Source: TPersistent); override; 

    {Node Property, Not Editable}
    property  Node : PVirtualNode read fNode
                                  write SetNode;

    //TListItem

    //TTreeNode

   //Common for TListItem/TTreeNode
  published
    { Published Declarations }

    //TListItem
    {Caption String.}
    property Caption  : String   read  FCaption
                                 write SetCaption;
    {Checked Property.}
    property Checked  : Boolean  read  GetChecked
                                 write SetChecked;
    {Subitem String.}
    property SubItems : TStrings read  FSubItems
                                 write SetSubItems;

    //TTreeNode
    {Text is equal to Caption.}
    property Text     : String    read  FCaption
                                  write SetCaption;
    {Number of Children of a Node. Only returns the immediate children.}
    property Count    : Integer   read GetCount;
    {True if the node is expanded.}
    property Expanded : Boolean   read  GetExpanded
                                  write SetExpanded;
    {True if the Node has Children}
    property HasChildren: Boolean read GetHasChildren;
    {Item Level, 0 for RootNodes.}
    property Level    : Integer   read GetLevel;
  //property OverlayIndex: Integer;
    property Parent   : TVirtualListViewItem read GetParent;     

    //Common for TListItem/TTreeNode
   {True if the node has the focus.}
    property Focused  : Boolean read GetFocused
                                write SetFocussed;
    property ImageIndex: TImageIndex read GetImageIndex
                                     write SetImageIndex;
    property Selected : Boolean read GetSelected
                                write SetSelected;
  //property StateIndex: Integer read GetStateIndex;
  end;

{-----------------------------------------------------------}

  {A collection containing the Tree/Listviews data.}
  TVirtualListViewItems = class(TOwnedCollection) //Owned
  private
    { Private Declarations }

    {Reference to the Owner.}
    FVirtualTree : TVirtualStringTreeData;

    {GetProperty Function.}
    function  GetItem(Index: Integer): TVirtualListViewItem;

    {SetProperty Procedure.}
    procedure SetItem(Index: Integer; Value: TVirtualListViewItem);
  protected
    { Protected Declarations }

    {Find a VirtualNode with AbsoluteIndex ndx by traversing the Tree's Data.}
    function _Locate(const aNode: PVirtualNode): Integer;

    procedure _CheckBox(aNode : PVirtualNode);
  public
    { Public Declarations }

    {A Constructor that takes a reference to the VirtualListViewData Owner.}
//  constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);

    //TListItems
    {Add a Collection Item.}
    function  Add: TVirtualListViewItem;
    {Insert a Collection Item Before.}
    function  Insert(Index: Integer): TVirtualListViewItem; overload; 
    {Delete a Collection Item.}
    procedure Delete(Index: Integer); 

    //TTreeNodes
    {Add a Collection Item.}
    function  AddNode(Node: TVirtualListViewItem; const S: string): TVirtualListViewItem; 
    {Add a Child Collection Item.}
    function  AddChild(Node: TVirtualListViewItem; const S: string) : TVirtualListViewItem;
    {Add a First Child Collection Item.}
    function  AddChildFirst(Node: TVirtualListViewItem; const S: string) : TVirtualListViewItem;
    {Add a First Collection Item.}
    function  AddFirst(Node: TVirtualListViewItem; const S: string) : TVirtualListViewItem;
    {Inserts a Collection Item.}
    function Insert(Node: TVirtualListViewItem; const S: string): TVirtualListViewItem; overload; 
    {Delete a Collection Item.}
    procedure DeleteNode(Node: TVirtualListViewItem); 
    {Get the First Node of a Tree.}
    function  GetFirstNode: TVirtualListViewItem;

    //Common for TListItems/TTreeNodes

    {Clear All Collection Items.}
    procedure Clear;
                                        
    {The Items of the Collection.}
    property  Items[Index: Integer]: TVirtualListViewItem read GetItem write SetItem; default;
  published
    { Published Declarations }

    {Reference to the Owner.}
    property  VirtualTree : TVirtualStringTreeData read FVirtualTree write FVirtualTree;
    {A Counter used for generating new ID's.}
  end;

{-----------------------------------------------------------}

procedure Register;

implementation

{-----------------------------------------------------------}

procedure Register;
begin
  RegisterComponents('Virtual', [TVirtualStringTreeData]);
end;

{-----------------------------------------------------------}

{$IFNDEF DEBUG}
procedure OutputDebugString(Msg : PChar);
begin
end;
{$ENDIF}

{-----------------------------------------------------------}

{ TVirtualListViewItem }

procedure TVirtualListViewItem.Assign(Source: TPersistent);
begin
//inherited;

  FSubItems.Assign(TVirtualListViewItem(Source).SubItems);
  FCaption:=TVirtualListViewItem(Source).Caption;
  FImageIndex:=TVirtualListViewItem(Source).ImageIndex;
  FNode:=TVirtualListViewItem(Source).Node;

  TVirtualListViewItems(Collection).VirtualTree.Paint;
end;

{-----------------------------------------------------------}

constructor TVirtualListViewItem.Create(Collection: TCollection);
begin
  inherited;

  FNode    :=nil;
  FCaption :='';
  FSubItems:=TStringList.Create;
end;

{-----------------------------------------------------------}

destructor TVirtualListViewItem.Destroy;
begin
  SetLength(FCaption,0);

  FreeAndNil(fSubItems);

  inherited;
end;

function TVirtualListViewItem.GetChecked: Boolean;
begin
  if Assigned(Node)
    then Result:=(Node.CheckState=csCheckedNormal)
    else Result:=False; //Error
end;

{-----------------------------------------------------------}

function TVirtualListViewItem.GetCount: Integer;
begin
  if Assigned(Node)
    then Result:=TVirtualListViewItems(Collection).VirtualTree.ChildCount[Node]
    else Result:=-1; //Error
end;

{-----------------------------------------------------------}

function TVirtualListViewItem.GetExpanded: Boolean;
begin
  if Assigned(Node)
    then Result:=(TVirtualListViewItems(Collection).VirtualTree.Expanded[Node])
    else Result:=False; //Error
end;

{-----------------------------------------------------------}

function TVirtualListViewItem.GetFocused: Boolean;
begin
  if Assigned(Node)
    then Result:=(TVirtualListViewItems(Collection).VirtualTree.FocusedNode=Node)
    else Result:=False; //Error
end;

{-----------------------------------------------------------}

function TVirtualListViewItem.GetHasChildren: Boolean;
begin
  if Assigned(Node)
    then Result:=TVirtualListViewItems(Collection).VirtualTree.HasChildren[Node]
    else Result:=False; //Error
end;

{-----------------------------------------------------------}

function TVirtualListViewItem.GetImageIndex: TImageIndex;
begin
  Result:=FImageIndex;
end;

function TVirtualListViewItem.GetLevel: Integer;
begin
  if Assigned(Node)
    then Result:=TVirtualListViewItems(Collection).VirtualTree.GetNodeLevel(Node)
    else Result:=-1; //Error
end;

{-----------------------------------------------------------}

function TVirtualListViewItem.GetParent: TVirtualListViewItem;
begin
  if Assigned(Node) and (TVirtualListViewItems(Collection).VirtualTree.GetNodeLevel(Node)>0)
    then Result:=TVirtualListViewItems(Collection).Items[TVirtualListViewItems(Collection)._Locate(Node.Parent)]
    else Result:=nil
end;

{-----------------------------------------------------------}

function TVirtualListViewItem.GetSelected: Boolean;
begin
  if Assigned(Node)
    then Result:=TVirtualListViewItems(Collection).VirtualTree.Selected[Node]
    else Result:=False; //Error
end;

{-----------------------------------------------------------}

procedure TVirtualListViewItem.SetCaption(const Value: String);
begin
  if Value<>FCaption
    then
      begin
        OutputDebugString(PChar(Format('Changing Caption %s to %s Index %d, Id %d',[FCaption,Value,Index,Id])));
        FCaption := Value;
        if Assigned(Node)
          then TVirtualListViewItems(Collection).VirtualTree.InvalidateNode(Node);

       with TVirtualStringTreeData(TVirtualListViewItems(Collection).VirtualTree) do
         if (Header.SortColumn<=0) and (toAutoSort in TVirtualTreeOptions(TreeOptions).AutoOptions) then
           SortTree(Header.SortColumn, Header.SortDirection, True);
      end;
end;

{-----------------------------------------------------------}

procedure TVirtualListViewItem.SetChecked(const Value: Boolean);
begin
  if Assigned(Node)
    then
      with TVirtualListViewItems(Collection).VirtualTree do
        begin
          case Value of
            True  : CheckState[Node]:=csCheckedNormal;
            False : CheckState[Node]:=csUnCheckedNormal;
          end;
          Node.CheckType:=ctTriStateCheckBox;
          TStringTreeOptions(TreeOptions).MiscOptions:=TStringTreeOptions(TreeOptions).MiscOptions+[toCheckSupport];
        end
    else ;//Error
end;

{-----------------------------------------------------------}

procedure TVirtualListViewItem.SetExpanded(const Value: Boolean);
begin
  if Assigned(Node)
    then TVirtualListViewItems(Collection).VirtualTree.Expanded[Node]:=Value
    else ; //Error
end;

{-----------------------------------------------------------}

procedure TVirtualListViewItem.SetFocussed(const Value: Boolean);
begin
  if Assigned(Node)
    then TVirtualListViewItems(Collection).VirtualTree.FocusedNode:=Node
    else ; //Error
end;

{-----------------------------------------------------------}

procedure TVirtualListViewItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex:=Value;
end;

procedure TVirtualListViewItem.SetNode(const Value: PVirtualNode);
begin
  FNode:=Value;
end;

{-----------------------------------------------------------}

procedure TVirtualListViewItem.SetSelected(const Value: Boolean);
begin
  if Assigned(Node)
    then TVirtualListViewItems(Collection).VirtualTree.Selected[Node]:=Value
    else ; //Error
end;

{-----------------------------------------------------------}

procedure TVirtualListViewItem.SetSubItems(const Value: TStrings);
begin
  if Value <> nil
    then FSubItems.Assign(Value);
//veg:todo better..
{
  with TVirtualStringTreeData(TVirtualListViewItems(Collection).VirtualTree) do
    if (Header.SortColumn>0) and (toAutoSort in TVirtualTreeOptions(TreeOptions).AutoOptions) then
      SortTree(Header.SortColumn, Header.SortDirection, True);
}
end;

{-----------------------------------------------------------}

{ TVirtualListViewItems }

////////////
//TListItems
////////////

function TVirtualListViewItems.Add: TVirtualListViewItem;
begin
  Result:=TVirtualListViewItem(inherited Add);
  Result.Caption:='';
  Result.ImageIndex:=-1;
  Result.Node:=VirtualTree.AddChild(VirtualTree.RootNode,Pointer(Result.Id));
  _CheckBox(Result.Node);
  OutputDebugString(PChar(Format('Adding %s Index %d, Id %d',[Result.Caption,Result.Index,Result.Id])));  
end;

{-----------------------------------------------------------}

procedure TVirtualListViewItems.Delete(Index: Integer);
var
  i : Integer;
  aChild,
  aNode : PVirtualNode;
begin
  BeginUpdate;

  OutputDebugString(PChar(Format('Deleting %s Index %d, Id %d',[Items[Index].Caption,Index,Items[Index].Id])));

  aNode:=Items[Index].Node;
  for i:=aNode.ChildCount downto 1 do
    begin
      aChild:=VirtualTree.GetFirstChild(aNode);
      Delete(_Locate(aChild)); //Recurse
    end;
  VirtualTree.DeleteNode(aNode);

  inherited;

  EndUpdate;
end;

{-----------------------------------------------------------}

function TVirtualListViewItems.Insert(
  Index: Integer): TVirtualListViewItem;
var
  aNode: PVirtualNode;
begin
  BeginUpdate;

  aNode:=Items[Index].Node;

  Result:=TVirtualListViewItem(inherited Insert(Index));

  Result.Node:=VirtualTree.InsertNode(aNode,amInsertAfter,Pointer(Result.Id));
  _CheckBox(Result.Node);

  OutputDebugString(PChar(Format('Inserting %s Index %d, Id %d',[Result.Caption,Result.Index,Result.Id])));  

  EndUpdate;

//VirtualTree.Paint;
  VirtualTree.InvalidateNode(Result.Node);
end;

{-----------------------------------------------------------}

////////////
//TTreeNodes
////////////

function TVirtualListViewItems.AddNode(Node: TVirtualListViewItem;
  const S: string): TVirtualListViewItem;
begin
  BeginUpdate;

  Result := TVirtualListViewItem(inherited Add);
  Result.Caption:=s;

  if Assigned(VirtualTree)
    then
      begin
        if Assigned(Node)
          then Result.Node:=VirtualTree.InsertNode(Node.Node,amInsertAfter,Pointer(Result.Id))
          else Result.Node:=VirtualTree.InsertNode(nil,amInsertAfter,Pointer(Result.Id));
        _CheckBox(Result.Node);
      end;

  OutputDebugString(Pchar(Format('AddNode(%d)',[Result.Index])));

  EndUpdate;
end;

{-----------------------------------------------------------}

function TVirtualListViewItems.AddChild(Node: TVirtualListViewItem;
  const S: string): TVirtualListViewItem;
begin
  BeginUpdate;

  Result := TVirtualListViewItem(inherited Add);

  if Assigned(VirtualTree)
    then
      begin
        if Assigned(Node)
          then Result.Node:=VirtualTree.AddChild(Node.Node,Pointer(Result.Id))
          else Result.Node:=VirtualTree.AddChild(nil,Pointer(Result.Id));
        _CheckBox(Result.Node);
      end;

  Result.Caption:=s;

  OutputDebugString(Pchar(Format('AddChild(%d)',[Result.Index])));

  EndUpdate;
end;

{-----------------------------------------------------------}

function TVirtualListViewItems.AddChildFirst(Node: TVirtualListViewItem;
  const S: string): TVirtualListViewItem;
begin
  BeginUpdate;

  Result := Add();
  Result.Caption:=s;
  if Assigned(Node)
    then Result.Node:=VirtualTree.InsertNode(Node.Node,amAddChildFirst,Pointer(Result.Id))
    else Result.Node:=VirtualTree.InsertNode(nil,amAddChildFirst,Pointer(Result.Id));
  _CheckBox(Result.Node);

  OutputDebugString(Pchar(Format('AddChildFirst(%d)',[Result.Index])));

  EndUpdate;
end;

{-----------------------------------------------------------}

function TVirtualListViewItems.AddFirst(Node: TVirtualListViewItem;
  const S: string): TVirtualListViewItem;
begin
  BeginUpdate;

  Result := TVirtualListViewItem(inherited Add);
  Result.Caption:=s;
  if Assigned(Node)
    then Result.Node:=VirtualTree.InsertNode(Node.Node.Parent,amAddChildFirst,Pointer(Result.Id))
    else Result.Node:=VirtualTree.InsertNode(nil,amAddChildFirst,Pointer(Result.Id));
  _CheckBox(Result.Node);

  OutputDebugString(Pchar(Format('AddFirst(%d)',[Result.Index])));

  EndUpdate;
end;

{-----------------------------------------------------------}

procedure TVirtualListViewItems.DeleteNode(Node: TVirtualListViewItem);
begin
  Delete(Node.Index);
end;

{-----------------------------------------------------------}

function TVirtualListViewItems.GetFirstNode: TVirtualListViewItem;
var
  ndx : Integer;
begin
  ndx:=Integer(VirtualTree.GetNodedata(VirtualTree.GetFirst)^);
  Result:=TVirtualListViewItem(FindItemID(ndx));
end;

{-----------------------------------------------------------}

function TVirtualListViewItems.Insert(Node: TVirtualListViewItem;
  const S: string): TVirtualListViewItem;
begin
  Result:=Insert(FindItemID(Node.Id).Index);
  Result.Caption:=s;

  VirtualTree.InvalidateNode(Result.Node);
end;

{-----------------------------------------------------------}

////////////
//Common
////////////

procedure TVirtualListViewItems.Clear;
begin
  BeginUpdate;

  VirtualTree.Clear;

  EndUpdate;

  inherited;
end;

{-----------------------------------------------------------}

procedure TVirtualListViewItems._CheckBox(aNode : PVirtualNode);
begin
  if (toCheckSupport in TStringTreeOptions(FVirtualTree.TreeOptions).MiscOptions)
    then aNode.CheckType:=ctTriStateCheckBox
    else aNode.CheckType:=ctNone;
end;

{-----------------------------------------------------------}

function TVirtualListViewItems.GetItem(
  Index: Integer): TVirtualListViewItem;
begin
  Result := TVirtualListViewItem(inherited GetItem(Index));
end;

{-----------------------------------------------------------}

procedure TVirtualListViewItems.SetItem(Index: Integer; Value: TVirtualListViewItem);
begin
  inherited SetItem(Index, Value);
end;

{-----------------------------------------------------------}

function TVirtualListViewItems._Locate(const aNode: PVirtualNode): Integer;
var
  ndx : Integer;
begin
  ndx:=Integer(FVirtualTree.GetNodedata(aNode)^);
  Result:=FindItemID(ndx).Index;
end;

{-----------------------------------------------------------}

{ TVirtualStringTreeData }

constructor TVirtualStringTreeData.Create(AOwner: TComponent);
begin
  inherited;

  NodeDataSize:=Sizeof(Integer);
  
  FVirtualListViewItems:=TVirtualListViewItems.Create(Self,TVirtualListViewItem);
  FVirtualListViewItems.VirtualTree:=Self;
end;

{-----------------------------------------------------------}

destructor TVirtualStringTreeData.Destroy;
begin
  FreeAndNil(FVirtualListViewItems);

  inherited;
end;

function TVirtualStringTreeData.DoCompare(Node1, Node2: PVirtualNode;
  Column: TColumnIndex): Integer;
begin
  Result:=0;
  if Assigned(FOnCompareEvent)
    then FOnCompareEvent(Self,Items[Items._Locate(Node1)],Items[Items._Locate(Node2)],Column,Result);
end;

procedure TVirtualStringTreeData.DoGetImageIndex(Node: PVirtualNode;
  Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
  var Index: Integer);
var
  ndx : Integer;
begin
  if Column=0
    then
      begin
        ndx:=Data._Locate(Node);
        if (ndx>=0) and (ndx<Data.Count) and Assigned(Data.Items[ndx])
          then Index:=Data.Items[ndx].ImageIndex;
        Ghosted:=False;
      end;
end;

procedure TVirtualStringTreeData.DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString); 
var
  ndx : Integer;
begin
  ndx:=Data._Locate(Node);
  if (ndx>=0) and (ndx<Data.Count) and Assigned(Data.Items[ndx])
    then
      begin
      //OutputDebugString(PChar(Format('Row%d,Col%d',[ndx,Column])));
        if (Column<=0)
          then
{$IFDEF DEBUG}
            CellText:=Format(Data.Items[ndx].Caption+':Index=%d,Id%d',[ndx,Data.Items[ndx].Id])
{$ELSE  DEBUG}
            CellText:=Data.Items[ndx].Caption
{$ENDIF DEBUG}
          else
            begin
              if Assigned(FVirtualListViewItems.Items[ndx].SubItems) and
                 (Column<=FVirtualListViewItems.Items[ndx].SubItems.Count)
                then
{$IFDEF DEBUG}
                CellText:=Format(FVirtualListViewItems.Items[ndx].SubItems[Column-1]+':Index=%d,Id%d',[ndx,Data.Items[ndx].Id])
{$ELSE  DEBUG}
                CellText:=FVirtualListViewItems.Items[ndx].SubItems[Column-1]
{$ENDIF DEBUG}
                else CellText:='';
            end
      end;
end;

{-----------------------------------------------------------}
{
procedure TVirtualStringTreeData.SetCheckBoxes(const Value: Boolean);
var
  aNode: PVirtualNode;
  ct: TCheckType;
begin
  ct:=ctNone; //To get Rid of Warning..
  case value of
    True : ct:=ctCheckBox;
    False: ct:=ctNone;
  end;

  case value of
    True : TStringTreeOptions(TreeOptions).MiscOptions:=TStringTreeOptions(TreeOptions).MiscOptions+[toCheckSupport];
    False: TStringTreeOptions(TreeOptions).MiscOptions:=TStringTreeOptions(TreeOptions).MiscOptions-[toCheckSupport];
  end;

  aNode:=GetFirst;
  if Assigned(aNode)
    then
      while (aNode<>nil) do
        begin
          CheckType[aNode]:=ct;
          aNode:=GetNext(aNode);
        end;
end;
}
{-----------------------------------------------------------}

function TVirtualStringTreeData.GetOptionsClass: TTreeOptionsClass;
begin
  Result := TStringTreeOptions;
end;

{-----------------------------------------------------------}

end.
