{-----------------------------------------------------------}
{----Purpose : VirtualStringTree based TStringList Viewers. }
{    By      : Ir. G.W. van der Vegt                        }
{    For     : -                                            }
{    Module  : VirtualMemo.pas                              }
{    Depends : VirtualTrees 3.2.1                           }
{    Version : 3.2.1                                        }    
{-----------------------------------------------------------}
{ ddmmyyyy comment                                          }
{ -------- -------------------------------------------------}
{ 22082001-Initial version.                                 }
{ 19092001-Added TVirtualList and TVirtualNumberedMemo.     }
{         -Made compatible with 2.5.34.                     }
{         -Changed basse class into                         }
{          TCustomVirtualStringTree instead of              }
{          TVirtualStringTree.                              }
{ 21092001-Added other (nog OnGetText) properties.          }
{ 14102001-Made compatible with 2.5.40.                     }
{ 10052002-Made compatible with 3.2.1.                      }
{-----------------------------------------------------------}
{ nr.    todo                                               }
{ ------ -------------------------------------------------- }
{ 1.     Emulate Context Menu (Cut/Paste stuff).            }
{-----------------------------------------------------------}
{
@abstract(provides a 3 simple TStringList viewers.)
@author(G.W. van der Vegt <wvd_vegt@knoware.nl>)
@created(July 08, 2001)
@lastmod(May 10, 2002)
These components (@LINK(TVirtualMemo),@LINK(TVirtualNumberedMemo) and
@LINK(TVirtualList) show TStringLists that can be used to carry the
data of a VirtualStringTree. The OnGetText method is internally tied
to a method that reads from the TStringList. 
}
unit VirtualStringList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualTrees;

type
  TVirtualMemo = class(TCustomVirtualStringTree)
  private
    { Private declarations }
    FLines : TStringList;
    procedure MyGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
    TextType: TVSTTextType; var CellText: WideString); virtual;
    procedure MyLinesChanged(Sender: TObject);
  protected
    { Protected declarations }
    function  GetOptionsClass: TTreeOptionsClass; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas;
  published
    { Published declarations }

    {Inherited from TCustomVirtualStringTree.}         
    property Align;
    {Inherited from TCustomVirtualStringTree.}         
    property Alignment;
    {Inherited from TCustomVirtualStringTree.}         
    property Anchors;
    {Inherited from TCustomVirtualStringTree.}         
    property AnimationDuration;
    {Inherited from TCustomVirtualStringTree.}         
    property AutoExpandDelay;
    {Inherited from TCustomVirtualStringTree.}         
    property AutoScrollDelay;
    {Inherited from TCustomVirtualStringTree.}         
    property AutoScrollInterval;
    {Inherited from TCustomVirtualStringTree.}         
    property Background;
    {Inherited from TCustomVirtualStringTree.}         
    property BackgroundOffsetX;
    {Inherited from TCustomVirtualStringTree.}         
    property BackgroundOffsetY;
    {Inherited from TCustomVirtualStringTree.}         
    property BiDiMode;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelEdges;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelInner;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelOuter;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelKind;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelWidth;
    {Inherited from TCustomVirtualStringTree.}         
    property BorderStyle;
    {Inherited from TCustomVirtualStringTree.}         
    property ButtonFillMode;
    {Inherited from TCustomVirtualStringTree.}         
    {Inherited from TCustomVirtualStringTree.}         
    property ButtonStyle;
    {Inherited from TCustomVirtualStringTree.}         
    property BorderWidth;
    {Inherited from TCustomVirtualStringTree.}         
    property ChangeDelay;
    {Inherited from TCustomVirtualStringTree.}         
    property CheckImageKind;
    {Inherited from TCustomVirtualStringTree.}
    property ClipboardFormats;
    {Inherited from TCustomVirtualStringTree.}         
    property Color;
    {Inherited from TCustomVirtualStringTree.}         
    property Colors;
    {Inherited from TCustomVirtualStringTree.}         
    property Constraints;
    {Inherited from TCustomVirtualStringTree.}         
    property Ctl3D;
    {Inherited from TCustomVirtualStringTree.}         
    property CustomCheckImages;
    {Inherited from TCustomVirtualStringTree.}         
    property DefaultNodeHeight;
    {Inherited from TCustomVirtualStringTree.}         
    property DefaultPasteMode;
    {Inherited from TCustomVirtualStringTree.}         
    property DefaultText;
    {Inherited from TCustomVirtualStringTree.}         
    property DragHeight;
    {Inherited from TCustomVirtualStringTree.}         
    property DragKind;
    {Inherited from TCustomVirtualStringTree.}         
    property DragImageKind;
    {Inherited from TCustomVirtualStringTree.}         
    property DragMode;
    {Inherited from TCustomVirtualStringTree.}         
    property DragOperations;
    {Inherited from TCustomVirtualStringTree.}         
    property DragType;
    {Inherited from TCustomVirtualStringTree.}         
    property DragWidth;
    {Inherited from TCustomVirtualStringTree.}         
    {Inherited from TCustomVirtualStringTree.}         
    property DrawSelectionMode;
    {Inherited from TCustomVirtualStringTree.}         
    property EditDelay;
    {Inherited from TCustomVirtualStringTree.}         
    property Enabled;
    {Inherited from TCustomVirtualStringTree.}         
    property Font;
    {Inherited from TCustomVirtualStringTree.}
    property Header;
    {Inherited from TCustomVirtualStringTree.}
    property HintAnimation;
    {Inherited from TCustomVirtualStringTree.}
    property HintMode;
    {Inherited from TCustomVirtualStringTree.}
    property HotCursor;
    {Inherited from TCustomVirtualStringTree.}
    property Images;
    {Inherited from TCustomVirtualStringTree.}
    property IncrementalSearch;
    {Inherited from TCustomVirtualStringTree.}
    property IncrementalSearchDirection;
    {Inherited from TCustomVirtualStringTree.}
    property IncrementalSearchStart;
    {Inherited from TCustomVirtualStringTree.}
    property IncrementalSearchTimeout;
    {Inherited from TCustomVirtualStringTree.}
    property Indent;
    {Inherited from TCustomVirtualStringTree.}
    property LineMode;
    {Inherited from TCustomVirtualStringTree.}
    property LineStyle;
    {Inherited from TCustomVirtualStringTree.}
    property Margin;
    {Inherited from TCustomVirtualStringTree.}
    property NodeAlignment;
    {Inherited from TCustomVirtualStringTree.}
    property NodeDataSize;
    {Inherited from TCustomVirtualStringTree.}
    property ParentBiDiMode;
    {Inherited from TCustomVirtualStringTree.}
    property ParentColor default False;
    {Inherited from TCustomVirtualStringTree.}
    property ParentCtl3D;
    {Inherited from TCustomVirtualStringTree.}
    property ParentFont;
    {Inherited from TCustomVirtualStringTree.}
    property ParentShowHint;
    {Inherited from TCustomVirtualStringTree.}
    property PopupMenu;
    {Inherited from TCustomVirtualStringTree.}
    property RootNodeCount;
    {Inherited from TCustomVirtualStringTree.}
    property ScrollBarOptions;
    {Inherited from TCustomVirtualStringTree.}
    property SelectionCurveRadius;
    {Inherited from TCustomVirtualStringTree.}
    property ShowHint;
    {Inherited from TCustomVirtualStringTree.}
    property StateImages;
    {Inherited from TCustomVirtualStringTree.}
    property TabOrder;
    {Inherited from TCustomVirtualStringTree.}
    property TabStop default True;
    {Inherited from TCustomVirtualStringTree.}
    property TextMargin;
    {Inherited from TCustomVirtualStringTree.}
    property TreeOptions;
    {Inherited from TCustomVirtualStringTree.}
    property Visible;
    {Inherited from TCustomVirtualStringTree.}
    property WantTabs;
    {Inherited from TCustomVirtualStringTree.}

  //Default EventHandlers
    {Inherited from TCustomVirtualStringTree.}
    property OnAfterCellPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnAfterItemErase;
    {Inherited from TCustomVirtualStringTree.}
    property OnAfterItemPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnAfterPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnBeforeCellPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnBeforeItemErase;
    {Inherited from TCustomVirtualStringTree.}
    property OnBeforeItemPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnBeforePaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnChange;
    {Inherited from TCustomVirtualStringTree.}
    property OnChecked;
    {Inherited from TCustomVirtualStringTree.}
    property OnChecking;
    {Inherited from TCustomVirtualStringTree.}
    property OnClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnCollapsed;
    {Inherited from TCustomVirtualStringTree.}
    property OnCollapsing;
    {Inherited from TCustomVirtualStringTree.}
    property OnColumnClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnColumnDblClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnColumnResize;
    {Inherited from TCustomVirtualStringTree.}
    property OnCompareNodes;
    {Inherited from TCustomVirtualStringTree.}
    property OnCreateDataObject;
    {Inherited from TCustomVirtualStringTree.}
    property OnCreateDragManager;
    {Inherited from TCustomVirtualStringTree.}
    property OnCreateEditor;
    {Inherited from TCustomVirtualStringTree.}
    property OnDblClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnDragAllowed;
    {Inherited from TCustomVirtualStringTree.}
    property OnDragOver;
    {Inherited from TCustomVirtualStringTree.}
    property OnDragDrop;
    {Inherited from TCustomVirtualStringTree.}
    property OnEditCancelled;
    {Inherited from TCustomVirtualStringTree.}
    property OnEdited;
    {Inherited from TCustomVirtualStringTree.}
    property OnEditing;
    {Inherited from TCustomVirtualStringTree.}
    property OnEndDock;
    {Inherited from TCustomVirtualStringTree.}
    property OnEndDrag;
    {Inherited from TCustomVirtualStringTree.}
    property OnEnter;
    {Inherited from TCustomVirtualStringTree.}
    property OnExit;
    {Inherited from TCustomVirtualStringTree.}
    property OnExpanded;
    {Inherited from TCustomVirtualStringTree.}
    property OnExpanding;
    {Inherited from TCustomVirtualStringTree.}
    property OnFocusChanged;
    {Inherited from TCustomVirtualStringTree.}
    property OnFocusChanging;
    {Inherited from TCustomVirtualStringTree.}
    property OnFreeNode;
//  property OnGetText;
    {Inherited from TCustomVirtualStringTree.}
    property OnPaintText;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetHelpContext;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetImageIndex;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetHint;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetLineStyle;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetNodeDataSize;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetPopupMenu;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetUserClipboardFormats;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderDblClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderDragged;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderDragging;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderDraw;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderMouseDown;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderMouseMove;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderMouseUp;
    {Inherited from TCustomVirtualStringTree.}
    property OnHotChange;
    {Inherited from TCustomVirtualStringTree.}
    property OnIncrementalSearch;
    {Inherited from TCustomVirtualStringTree.}
    property OnInitChildren;
    {Inherited from TCustomVirtualStringTree.}
    property OnInitNode;
    {Inherited from TCustomVirtualStringTree.}
    property OnKeyAction;
    {Inherited from TCustomVirtualStringTree.}
    property OnKeyDown;
    {Inherited from TCustomVirtualStringTree.}
    property OnKeyPress;
    {Inherited from TCustomVirtualStringTree.}
    property OnKeyUp;
    {Inherited from TCustomVirtualStringTree.}
    property OnLoadNode;
    {Inherited from TCustomVirtualStringTree.}
    property OnMouseDown;
    {Inherited from TCustomVirtualStringTree.}
    property OnMouseMove;
    {Inherited from TCustomVirtualStringTree.}
    property OnMouseUp;
    {Inherited from TCustomVirtualStringTree.}
    property OnNewText;
    {Inherited from TCustomVirtualStringTree.}
    property OnNodeCopied;
    {Inherited from TCustomVirtualStringTree.}
    property OnNodeCopying;
    {Inherited from TCustomVirtualStringTree.}
    property OnNodeMoved;
    {Inherited from TCustomVirtualStringTree.}
    property OnNodeMoving;
    {Inherited from TCustomVirtualStringTree.}
    property OnPaintBackground;
    {Inherited from TCustomVirtualStringTree.}
    property OnRenderOLEData;
    {Inherited from TCustomVirtualStringTree.}
    property OnResetNode;
    {Inherited from TCustomVirtualStringTree.}
    property OnResize;
    {Inherited from TCustomVirtualStringTree.}
    property OnSaveNode;
    {Inherited from TCustomVirtualStringTree.}
    property OnScroll;
    {Inherited from TCustomVirtualStringTree.}
    property OnShortenString;
    {Inherited from TCustomVirtualStringTree.}
    property OnStartDock;
    {Inherited from TCustomVirtualStringTree.}
    property OnStartDrag;
    {Inherited from TCustomVirtualStringTree.}
    property OnStructureChange;
    {Inherited from TCustomVirtualStringTree.}
    property OnUpdating;

  //New Properties
    property Lines : TStringList read FLines write FLines;
  end;

  TVirtualList = class(TVirtualMemo)
  private
    procedure MyGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
    TextType: TVSTTextType; var CellText: WideString); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }

    {Inherited from TCustomVirtualStringTree.}         
    property Align;
    {Inherited from TCustomVirtualStringTree.}         
    property Alignment;
    {Inherited from TCustomVirtualStringTree.}         
    property Anchors;
    {Inherited from TCustomVirtualStringTree.}         
    property AnimationDuration;
    {Inherited from TCustomVirtualStringTree.}         
    property AutoExpandDelay;
    {Inherited from TCustomVirtualStringTree.}         
    property AutoScrollDelay;
    {Inherited from TCustomVirtualStringTree.}         
    property AutoScrollInterval;
    {Inherited from TCustomVirtualStringTree.}         
    property Background;
    {Inherited from TCustomVirtualStringTree.}         
    property BackgroundOffsetX;
    {Inherited from TCustomVirtualStringTree.}         
    property BackgroundOffsetY;
    {Inherited from TCustomVirtualStringTree.}         
    property BiDiMode;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelEdges;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelInner;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelOuter;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelKind;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelWidth;
    {Inherited from TCustomVirtualStringTree.}         
    property BorderStyle;
    {Inherited from TCustomVirtualStringTree.}         
    property ButtonFillMode;
    {Inherited from TCustomVirtualStringTree.}         
    {Inherited from TCustomVirtualStringTree.}         
    property ButtonStyle;
    {Inherited from TCustomVirtualStringTree.}         
    property BorderWidth;
    {Inherited from TCustomVirtualStringTree.}         
    property ChangeDelay;
    {Inherited from TCustomVirtualStringTree.}         
    property CheckImageKind;
    {Inherited from TCustomVirtualStringTree.}
    property ClipboardFormats;
    {Inherited from TCustomVirtualStringTree.}         
    property Color;
    {Inherited from TCustomVirtualStringTree.}         
    property Colors;
    {Inherited from TCustomVirtualStringTree.}         
    property Constraints;
    {Inherited from TCustomVirtualStringTree.}         
    property Ctl3D;
    {Inherited from TCustomVirtualStringTree.}         
    property CustomCheckImages;
    {Inherited from TCustomVirtualStringTree.}         
    property DefaultNodeHeight;
    {Inherited from TCustomVirtualStringTree.}         
    property DefaultPasteMode;
    {Inherited from TCustomVirtualStringTree.}         
    property DefaultText;
    {Inherited from TCustomVirtualStringTree.}         
    property DragHeight;
    {Inherited from TCustomVirtualStringTree.}         
    property DragKind;
    {Inherited from TCustomVirtualStringTree.}         
    property DragImageKind;
    {Inherited from TCustomVirtualStringTree.}         
    property DragMode;
    {Inherited from TCustomVirtualStringTree.}         
    property DragOperations;
    {Inherited from TCustomVirtualStringTree.}         
    property DragType;
    {Inherited from TCustomVirtualStringTree.}         
    property DragWidth;
    {Inherited from TCustomVirtualStringTree.}         
    {Inherited from TCustomVirtualStringTree.}         
    property DrawSelectionMode;
    {Inherited from TCustomVirtualStringTree.}         
    property EditDelay;
    {Inherited from TCustomVirtualStringTree.}         
    property Enabled;
    {Inherited from TCustomVirtualStringTree.}         
    property Font;
    {Inherited from TCustomVirtualStringTree.}
    property Header;
    {Inherited from TCustomVirtualStringTree.}
    property HintAnimation;
    {Inherited from TCustomVirtualStringTree.}
    property HintMode;
    {Inherited from TCustomVirtualStringTree.}
    property HotCursor;
    {Inherited from TCustomVirtualStringTree.}
    property Images;
    {Inherited from TCustomVirtualStringTree.}
    property IncrementalSearch;
    {Inherited from TCustomVirtualStringTree.}
    property IncrementalSearchDirection;
    {Inherited from TCustomVirtualStringTree.}
    property IncrementalSearchStart;
    {Inherited from TCustomVirtualStringTree.}
    property IncrementalSearchTimeout;
    {Inherited from TCustomVirtualStringTree.}
    property Indent;
    {Inherited from TCustomVirtualStringTree.}
    property LineMode;
    {Inherited from TCustomVirtualStringTree.}
    property LineStyle;
    {Inherited from TCustomVirtualStringTree.}
    property Margin;
    {Inherited from TCustomVirtualStringTree.}
    property NodeAlignment;
    {Inherited from TCustomVirtualStringTree.}
    property NodeDataSize;
    {Inherited from TCustomVirtualStringTree.}
    property ParentBiDiMode;
    {Inherited from TCustomVirtualStringTree.}
    property ParentColor default False;
    {Inherited from TCustomVirtualStringTree.}
    property ParentCtl3D;
    {Inherited from TCustomVirtualStringTree.}
    property ParentFont;
    {Inherited from TCustomVirtualStringTree.}
    property ParentShowHint;
    {Inherited from TCustomVirtualStringTree.}
    property PopupMenu;
    {Inherited from TCustomVirtualStringTree.}
    property RootNodeCount;
    {Inherited from TCustomVirtualStringTree.}
    property ScrollBarOptions;
    {Inherited from TCustomVirtualStringTree.}
    property SelectionCurveRadius;
    {Inherited from TCustomVirtualStringTree.}
    property ShowHint;
    {Inherited from TCustomVirtualStringTree.}
    property StateImages;
    {Inherited from TCustomVirtualStringTree.}
    property TabOrder;
    {Inherited from TCustomVirtualStringTree.}
    property TabStop default True;
    {Inherited from TCustomVirtualStringTree.}
    property TextMargin;
    {Inherited from TCustomVirtualStringTree.}
    property TreeOptions;
    {Inherited from TCustomVirtualStringTree.}
    property Visible;
    {Inherited from TCustomVirtualStringTree.}
    property WantTabs;
    {Inherited from TCustomVirtualStringTree.}

  //Default EventHandlers
    {Inherited from TCustomVirtualStringTree.}
    property OnAfterCellPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnAfterItemErase;
    {Inherited from TCustomVirtualStringTree.}
    property OnAfterItemPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnAfterPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnBeforeCellPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnBeforeItemErase;
    {Inherited from TCustomVirtualStringTree.}
    property OnBeforeItemPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnBeforePaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnChange;
    {Inherited from TCustomVirtualStringTree.}
    property OnChecked;
    {Inherited from TCustomVirtualStringTree.}
    property OnChecking;
    {Inherited from TCustomVirtualStringTree.}
    property OnClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnCollapsed;
    {Inherited from TCustomVirtualStringTree.}
    property OnCollapsing;
    {Inherited from TCustomVirtualStringTree.}
    property OnColumnClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnColumnDblClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnColumnResize;
    {Inherited from TCustomVirtualStringTree.}
    property OnCompareNodes;
    {Inherited from TCustomVirtualStringTree.}
    property OnCreateDataObject;
    {Inherited from TCustomVirtualStringTree.}
    property OnCreateDragManager;
    {Inherited from TCustomVirtualStringTree.}
    property OnCreateEditor;
    {Inherited from TCustomVirtualStringTree.}
    property OnDblClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnDragAllowed;
    {Inherited from TCustomVirtualStringTree.}
    property OnDragOver;
    {Inherited from TCustomVirtualStringTree.}
    property OnDragDrop;
    {Inherited from TCustomVirtualStringTree.}
    property OnEditCancelled;
    {Inherited from TCustomVirtualStringTree.}
    property OnEdited;
    {Inherited from TCustomVirtualStringTree.}
    property OnEditing;
    {Inherited from TCustomVirtualStringTree.}
    property OnEndDock;
    {Inherited from TCustomVirtualStringTree.}
    property OnEndDrag;
    {Inherited from TCustomVirtualStringTree.}
    property OnEnter;
    {Inherited from TCustomVirtualStringTree.}
    property OnExit;
    {Inherited from TCustomVirtualStringTree.}
    property OnExpanded;
    {Inherited from TCustomVirtualStringTree.}
    property OnExpanding;
    {Inherited from TCustomVirtualStringTree.}
    property OnFocusChanged;
    {Inherited from TCustomVirtualStringTree.}
    property OnFocusChanging;
    {Inherited from TCustomVirtualStringTree.}
    property OnFreeNode;
//  property OnGetText;
    {Inherited from TCustomVirtualStringTree.}
    property OnPaintText;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetHelpContext;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetImageIndex;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetHint;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetLineStyle;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetNodeDataSize;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetPopupMenu;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetUserClipboardFormats;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderDblClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderDragged;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderDragging;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderDraw;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderMouseDown;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderMouseMove;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderMouseUp;
    {Inherited from TCustomVirtualStringTree.}
    property OnHotChange;
    {Inherited from TCustomVirtualStringTree.}
    property OnIncrementalSearch;
    {Inherited from TCustomVirtualStringTree.}
    property OnInitChildren;
    {Inherited from TCustomVirtualStringTree.}
    property OnInitNode;
    {Inherited from TCustomVirtualStringTree.}
    property OnKeyAction;
    {Inherited from TCustomVirtualStringTree.}
    property OnKeyDown;
    {Inherited from TCustomVirtualStringTree.}
    property OnKeyPress;
    {Inherited from TCustomVirtualStringTree.}
    property OnKeyUp;
    {Inherited from TCustomVirtualStringTree.}
    property OnLoadNode;
    {Inherited from TCustomVirtualStringTree.}
    property OnMouseDown;
    {Inherited from TCustomVirtualStringTree.}
    property OnMouseMove;
    {Inherited from TCustomVirtualStringTree.}
    property OnMouseUp;
    {Inherited from TCustomVirtualStringTree.}
    property OnNewText;
    {Inherited from TCustomVirtualStringTree.}
    property OnNodeCopied;
    {Inherited from TCustomVirtualStringTree.}
    property OnNodeCopying;
    {Inherited from TCustomVirtualStringTree.}
    property OnNodeMoved;
    {Inherited from TCustomVirtualStringTree.}
    property OnNodeMoving;
    {Inherited from TCustomVirtualStringTree.}
    property OnPaintBackground;
    {Inherited from TCustomVirtualStringTree.}
    property OnRenderOLEData;
    {Inherited from TCustomVirtualStringTree.}
    property OnResetNode;
    {Inherited from TCustomVirtualStringTree.}
    property OnResize;
    {Inherited from TCustomVirtualStringTree.}
    property OnSaveNode;
    {Inherited from TCustomVirtualStringTree.}
    property OnScroll;
    {Inherited from TCustomVirtualStringTree.}
    property OnShortenString;
    {Inherited from TCustomVirtualStringTree.}
    property OnStartDock;
    {Inherited from TCustomVirtualStringTree.}
    property OnStartDrag;
    {Inherited from TCustomVirtualStringTree.}
    property OnStructureChange;
    {Inherited from TCustomVirtualStringTree.}
    property OnUpdating;

  //Inherited
    {Inherited from TVirtualMemo.}
    property Lines;
  end;
  
  TVirtualNumberedMemo = class(TVirtualMemo)
  private
    procedure MyGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
    TextType: TVSTTextType; var CellText: WideString); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    {Inherited from TCustomVirtualStringTree.}         
    property Align;
    {Inherited from TCustomVirtualStringTree.}         
    property Alignment;
    {Inherited from TCustomVirtualStringTree.}         
    property Anchors;
    {Inherited from TCustomVirtualStringTree.}         
    property AnimationDuration;
    {Inherited from TCustomVirtualStringTree.}         
    property AutoExpandDelay;
    {Inherited from TCustomVirtualStringTree.}         
    property AutoScrollDelay;
    {Inherited from TCustomVirtualStringTree.}         
    property AutoScrollInterval;
    {Inherited from TCustomVirtualStringTree.}         
    property Background;
    {Inherited from TCustomVirtualStringTree.}         
    property BackgroundOffsetX;
    {Inherited from TCustomVirtualStringTree.}         
    property BackgroundOffsetY;
    {Inherited from TCustomVirtualStringTree.}         
    property BiDiMode;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelEdges;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelInner;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelOuter;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelKind;
    {Inherited from TCustomVirtualStringTree.}         
    property BevelWidth;
    {Inherited from TCustomVirtualStringTree.}         
    property BorderStyle;
    {Inherited from TCustomVirtualStringTree.}         
    property ButtonFillMode;
    {Inherited from TCustomVirtualStringTree.}         
    {Inherited from TCustomVirtualStringTree.}         
    property ButtonStyle;
    {Inherited from TCustomVirtualStringTree.}         
    property BorderWidth;
    {Inherited from TCustomVirtualStringTree.}         
    property ChangeDelay;
    {Inherited from TCustomVirtualStringTree.}         
    property CheckImageKind;
    {Inherited from TCustomVirtualStringTree.}
    property ClipboardFormats;
    {Inherited from TCustomVirtualStringTree.}         
    property Color;
    {Inherited from TCustomVirtualStringTree.}
    property Colors;
    {Inherited from TCustomVirtualStringTree.}         
    property Constraints;
    {Inherited from TCustomVirtualStringTree.}         
    property Ctl3D;
    {Inherited from TCustomVirtualStringTree.}         
    property CustomCheckImages;
    {Inherited from TCustomVirtualStringTree.}         
    property DefaultNodeHeight;
    {Inherited from TCustomVirtualStringTree.}         
    property DefaultPasteMode;
    {Inherited from TCustomVirtualStringTree.}         
    property DefaultText;
    {Inherited from TCustomVirtualStringTree.}         
    property DragHeight;
    {Inherited from TCustomVirtualStringTree.}         
    property DragKind;
    {Inherited from TCustomVirtualStringTree.}
    property DragImageKind;
    {Inherited from TCustomVirtualStringTree.}         
    property DragMode;
    {Inherited from TCustomVirtualStringTree.}         
    property DragOperations;
    {Inherited from TCustomVirtualStringTree.}         
    property DragType;
    {Inherited from TCustomVirtualStringTree.}         
    property DragWidth;
    {Inherited from TCustomVirtualStringTree.}         
    {Inherited from TCustomVirtualStringTree.}         
    property DrawSelectionMode;
    {Inherited from TCustomVirtualStringTree.}         
    property EditDelay;
    {Inherited from TCustomVirtualStringTree.}         
    property Enabled;
    {Inherited from TCustomVirtualStringTree.}         
    property Font;
    {Inherited from TCustomVirtualStringTree.}
    property Header;
    {Inherited from TCustomVirtualStringTree.}
    property HintAnimation;
    {Inherited from TCustomVirtualStringTree.}
    property HintMode;
    {Inherited from TCustomVirtualStringTree.}
    property HotCursor;
    {Inherited from TCustomVirtualStringTree.}
    property Images;
    {Inherited from TCustomVirtualStringTree.}
    property IncrementalSearch;
    {Inherited from TCustomVirtualStringTree.}
    property IncrementalSearchDirection;
    {Inherited from TCustomVirtualStringTree.}
    property IncrementalSearchStart;
    {Inherited from TCustomVirtualStringTree.}
    property IncrementalSearchTimeout;
    {Inherited from TCustomVirtualStringTree.}
    property Indent;
    {Inherited from TCustomVirtualStringTree.}
    property LineMode;
    {Inherited from TCustomVirtualStringTree.}
    property LineStyle;
    {Inherited from TCustomVirtualStringTree.}
    property Margin;
    {Inherited from TCustomVirtualStringTree.}
    property NodeAlignment;
    {Inherited from TCustomVirtualStringTree.}
    property NodeDataSize;
    {Inherited from TCustomVirtualStringTree.}
    property ParentBiDiMode;
    {Inherited from TCustomVirtualStringTree.}
    property ParentColor default False;
    {Inherited from TCustomVirtualStringTree.}
    property ParentCtl3D;
    {Inherited from TCustomVirtualStringTree.}
    property ParentFont;
    {Inherited from TCustomVirtualStringTree.}
    property ParentShowHint;
    {Inherited from TCustomVirtualStringTree.}
    property PopupMenu;
    {Inherited from TCustomVirtualStringTree.}
    property RootNodeCount;
    {Inherited from TCustomVirtualStringTree.}
    property ScrollBarOptions;
    {Inherited from TCustomVirtualStringTree.}
    property SelectionCurveRadius;
    {Inherited from TCustomVirtualStringTree.}
    property ShowHint;
    {Inherited from TCustomVirtualStringTree.}
    property StateImages;
    {Inherited from TCustomVirtualStringTree.}
    property TabOrder;
    {Inherited from TCustomVirtualStringTree.}
    property TabStop default True;
    {Inherited from TCustomVirtualStringTree.}
    property TextMargin;
    {Inherited from TCustomVirtualStringTree.}
    property TreeOptions;
    {Inherited from TCustomVirtualStringTree.}
    property Visible;
    {Inherited from TCustomVirtualStringTree.}
    property WantTabs;
    {Inherited from TCustomVirtualStringTree.}

  //Default EventHandlers
    {Inherited from TCustomVirtualStringTree.}
    property OnAfterCellPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnAfterItemErase;
    {Inherited from TCustomVirtualStringTree.}
    property OnAfterItemPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnAfterPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnBeforeCellPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnBeforeItemErase;
    {Inherited from TCustomVirtualStringTree.}
    property OnBeforeItemPaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnBeforePaint;
    {Inherited from TCustomVirtualStringTree.}
    property OnChange;
    {Inherited from TCustomVirtualStringTree.}
    property OnChecked;
    {Inherited from TCustomVirtualStringTree.}
    property OnChecking;
    {Inherited from TCustomVirtualStringTree.}
    property OnClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnCollapsed;
    {Inherited from TCustomVirtualStringTree.}
    property OnCollapsing;
    {Inherited from TCustomVirtualStringTree.}
    property OnColumnClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnColumnDblClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnColumnResize;
    {Inherited from TCustomVirtualStringTree.}
    property OnCompareNodes;
    {Inherited from TCustomVirtualStringTree.}
    property OnCreateDataObject;
    {Inherited from TCustomVirtualStringTree.}
    property OnCreateDragManager;
    {Inherited from TCustomVirtualStringTree.}
    property OnCreateEditor;
    {Inherited from TCustomVirtualStringTree.}
    property OnDblClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnDragAllowed;
    {Inherited from TCustomVirtualStringTree.}
    property OnDragOver;
    {Inherited from TCustomVirtualStringTree.}
    property OnDragDrop;
    {Inherited from TCustomVirtualStringTree.}
    property OnEditCancelled;
    {Inherited from TCustomVirtualStringTree.}
    property OnEdited;
    {Inherited from TCustomVirtualStringTree.}
    property OnEditing;
    {Inherited from TCustomVirtualStringTree.}
    property OnEndDock;
    {Inherited from TCustomVirtualStringTree.}
    property OnEndDrag;
    {Inherited from TCustomVirtualStringTree.}
    property OnEnter;
    {Inherited from TCustomVirtualStringTree.}
    property OnExit;
    {Inherited from TCustomVirtualStringTree.}
    property OnExpanded;
    {Inherited from TCustomVirtualStringTree.}
    property OnExpanding;
    {Inherited from TCustomVirtualStringTree.}
    property OnFocusChanged;
    {Inherited from TCustomVirtualStringTree.}
    property OnFocusChanging;
    {Inherited from TCustomVirtualStringTree.}
    property OnFreeNode;
//  property OnGetText;
    {Inherited from TCustomVirtualStringTree.}
    property OnPaintText;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetHelpContext;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetImageIndex;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetHint;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetLineStyle;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetNodeDataSize;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetPopupMenu;
    {Inherited from TCustomVirtualStringTree.}
    property OnGetUserClipboardFormats;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderDblClick;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderDragged;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderDragging;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderDraw;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderMouseDown;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderMouseMove;
    {Inherited from TCustomVirtualStringTree.}
    property OnHeaderMouseUp;
    {Inherited from TCustomVirtualStringTree.}
    property OnHotChange;
    {Inherited from TCustomVirtualStringTree.}
    property OnIncrementalSearch;
    {Inherited from TCustomVirtualStringTree.}
    property OnInitChildren;
    {Inherited from TCustomVirtualStringTree.}
    property OnInitNode;
    {Inherited from TCustomVirtualStringTree.}
    property OnKeyAction;
    {Inherited from TCustomVirtualStringTree.}
    property OnKeyDown;
    {Inherited from TCustomVirtualStringTree.}
    property OnKeyPress;
    {Inherited from TCustomVirtualStringTree.}
    property OnKeyUp;
    {Inherited from TCustomVirtualStringTree.}
    property OnLoadNode;
    {Inherited from TCustomVirtualStringTree.}
    property OnMouseDown;
    {Inherited from TCustomVirtualStringTree.}
    property OnMouseMove;
    {Inherited from TCustomVirtualStringTree.}
    property OnMouseUp;
    {Inherited from TCustomVirtualStringTree.}
    property OnNewText;
    {Inherited from TCustomVirtualStringTree.}
    property OnNodeCopied;
    {Inherited from TCustomVirtualStringTree.}
    property OnNodeCopying;
    {Inherited from TCustomVirtualStringTree.}
    property OnNodeMoved;
    {Inherited from TCustomVirtualStringTree.}
    property OnNodeMoving;
    {Inherited from TCustomVirtualStringTree.}
    property OnPaintBackground;
    {Inherited from TCustomVirtualStringTree.}
    property OnRenderOLEData;
    {Inherited from TCustomVirtualStringTree.}
    property OnResetNode;
    {Inherited from TCustomVirtualStringTree.}
    property OnResize;
    {Inherited from TCustomVirtualStringTree.}
    property OnSaveNode;
    {Inherited from TCustomVirtualStringTree.}
    property OnScroll;
    {Inherited from TCustomVirtualStringTree.}
    property OnShortenString;
    {Inherited from TCustomVirtualStringTree.}
    property OnStartDock;
    {Inherited from TCustomVirtualStringTree.}
    property OnStartDrag;
    {Inherited from TCustomVirtualStringTree.}
    property OnStructureChange;
    {Inherited from TCustomVirtualStringTree.}
    property OnUpdating;

  //Inherited
    {Inherited from TVirtualMemo.}
    property Lines;
  end;
  
procedure Register;

{ DEFINE DEBUG}

implementation

{$IFNDEF DEBUG}
procedure OutputDebugString(msg : PChar);
begin
end;
{$ENDIF DEBUG}

{ TVirtualMemo }

constructor TVirtualMemo.Create(AOwner: TComponent);
begin
  inherited;

//Preset some settings so it looks like a R/O Memo
  DefaultNodeHeight:=13;      //Measured against a plain TMemo so it looks equal to it.
  Header.Height:=17;          //Measured against a TListView;
  
  with TStringTreeOptions(TreeOptions) do
   begin
     PaintOptions    :=PaintOptions    -[toShowRoot,toShowTreeLines,toShowButtons];
     PaintOptions    :=PaintOptions    +[toHideFocusRect];
     SelectionOptions:=SelectionOptions+[toFullRowSelect];
   end;
   
  ParentColor:=True;
  TextMargin :=0;

//Set the OnGetTextHandler  
  OnGetText     :=MyGetText;

//Create the StringList and attach a
//OnChange handler so we see whenever the
//content changes. 
  FLines:=TStringList.Create;
  Lines.OnChange:=MyLinesChanged;
end;

destructor TVirtualMemo.Destroy;
begin
  FreeAndNil(FLines);

  inherited;
end;

procedure TVirtualMemo.MyGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  if (Node.Index<Cardinal(FLines.Count))
    then CellText:=Flines[Node.Index]
    else CellText:='error';
  OutputDebugString(PChar(Format('Requesting line %d',[Node.Index])));    
end;

procedure TVirtualMemo.MyLinesChanged(Sender: TObject);
begin
  RootNodeCount:=FLines.Count;
  OutputDebugString(PChar(Format('Linecount %d',[FLines.Count])));  
end;

function TVirtualMemo.GetOptionsClass: TTreeOptionsClass;
begin
  Result := TStringTreeOptions;
end;

{ TVirtualList }

constructor TVirtualList.Create(AOwner: TComponent);
var
  col : TVirtualTreeColumn;
begin
  inherited;

  Header.Columns.Clear;
  
  col:=Header.Columns.Add;
  col.Text:='Name';
  col.Width:=100;

  col:=Header.Columns.Add;
  col.Text:='Value';
  col.Width:=100;

  Header.AutoSizeIndex:=1;
  Header.Options:=Header.Options+[hoAutoResize,hoVisible];
end;

procedure TVirtualList.MyGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  aName : String;
  aPos  : Integer;
begin
  aName:=FLines[Node.Index];
  aPos :=Pos('=',aName);
  case Column of
    0 : if (aPos=0)
          then CellText:=aName
          else CellText:=Copy(aName,1,aPos-1);
    1 : if (aPos=0)
          then CellText:='n/a'
          else CellText:=Copy(aName,aPos+1,Length(aName));
  end;
end;

{ TVirtualNumberedMemo }

constructor TVirtualNumberedMemo.Create(AOwner: TComponent);
var
  col : TVirtualTreeColumn;
begin
  inherited;

  Header.Columns.Clear;
  
  col:=Header.Columns.Add;
  col.Text:='No';
  col.Width:=50;
  col.Alignment:=taRightJustify;

  col:=Header.Columns.Add;
  col.Text:='';
  col.Width:=10;

  col:=Header.Columns.Add;
  col.Text:='Text';
  col.Width:=100;

  Header.AutoSizeIndex:=2;
  Header.Options:=Header.Options+[hoAutoResize,hoVisible];
end;

procedure TVirtualNumberedMemo.MyGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  case column of
    0 : CellText:=IntToStr(Node.Index);
    1 : CellText:='';
    2 : CellText:=Lines[Node.Index];
  end;
end;

procedure Register;
begin
  RegisterComponents('Virtual Controls', [TVirtualMemo,TVirtualNumberedMemo,TVirtualList]);
end;

end.
