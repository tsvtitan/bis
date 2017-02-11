{-----------------------------------------------------------}
{----Purpose : Ini file viewer VirtualStringTree            }
{    By      : Ir. G.W. van der Vegt                        }
{    For     : -                                            }
{    Module  : VirtualMemo.pas                              }
{    Depends : TVirtualStringTree 3.2.1                     }
{    Version : 3.2.1                                        }
{-----------------------------------------------------------}
{ ddmmyyyy comment                                          }
{ -------- -------------------------------------------------}
{ 22082001-Initial version.                                 }
{ 21092001-Added other (nog OnGetText) properties.          }
{ 14102001-Made compatible with 2.5.40.                     }
{ 19032002-Removed Memory Leaks with Snoop.                 }
{ 10052002-Made compatible with 3.2.1.                      }
{-----------------------------------------------------------}
{ nr.    todo                                               }
{ ------ -------------------------------------------------- }
{ 1.                                                        }
{-----------------------------------------------------------}
{
@abstract(provides a TreeView of an ini file.)
@author(G.W. van der Vegt <wvd_vegt@knoware.nl>)
@created(July 08, 2001)
@lastmod(May 10, 2002)
This component shows an ini file as a treeview. It's GetText method
is tied directly to the IniFile Api so it stores no data in the
treeview. Beware it is slow on windows nt as nt can store parts of ini
files in the registry. So don't be suprised to see more entries than
when simple opening the ini file in notepad.
}
unit VirtualIniTree;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualTrees, IniFiles;

type
  TVirtualIniTree = class(TCustomVirtualStringTree)
  private
    {The filename of the ini file opened.}
    fIniFile: String;
    {The ini file opened.}
    fIni: TIniFile;
    {Set Property handler for the IniFile Property.}
    procedure SetIniFile(const Value: String);
    {Virtual TreeView GetText Handler.}
    procedure MyGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    { Private declarations }
  protected
    { Protected declarations }
    {Used for TreeOption in VirtualTreeView.}
    function GetOptionsClass: TTreeOptionsClass; override;
  public
    { Public declarations }
    {The constructor.}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
  //Default Properties
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
    {The Ini file shown.}
    property IniFile : String read fIniFile write SetIniFile;
  end;

procedure Register;

implementation

{ TVirtualIniTree }

constructor TVirtualIniTree.Create(AOwner: TComponent);
begin
  inherited;

//Preset some settings so it looks like a R/O Memo
  DefaultNodeHeight:=13;      //Measured against a plain TMemo so it looks equal to it.
  Header.Height    :=17;      //Measured against a TListView;

  with TStringTreeOptions(TreeOptions) do
    begin
      PaintOptions    :=PaintOptions    +[toShowRoot,toShowTreeLines,toShowButtons,toHideFocusRect];
      SelectionOptions:=SelectionOptions+[toFullRowSelect];
    end;

  ParentColor:=True;
  TextMargin :=0;

//Set the OnGetTextHandler
  OnGetText     :=MyGetText;
end;

procedure TVirtualIniTree.SetIniFile(const Value: String);
var
  sl : TStringList;
begin
  if FileExists(Value)
    then
      begin
        fIniFile := Value;
        if Assigned(fIni) then fIni.Free;
        fIni:=TIniFile.Create(fIniFile);
        sl:=TStringList.Create;
        fIni.ReadSections(sl);
        RootNodeCount:=sl.Count;
        sl.Free;
      end
    else
      begin
        fIniFile:='';
        RootNodeCount:=0;
        fIni.Free;
        fIni:=nil;
      end;
end;

procedure TVirtualIniTree.MyGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  s  : String;
  sl : TStringList;
begin
  inherited;

  sl:=TStringList.Create;
  case Column of

    0 : begin
          if (TVirtualIniTree(Sender).GetNodeLevel(Node)=0)
            then
              begin
                fIni.ReadSections(sl);
                s:=sl[Node.Index];
                CellText:='['+s+']';
                fIni.ReadSection(s,sl);
                if (TVirtualIniTree(Sender).ChildCount[Node]<>Cardinal(sl.Count))
                  then TVirtualIniTree(Sender).ChildCount[Node]:=sl.Count;
              end
            else
              begin
                fIni.ReadSections(sl);
                fIni.ReadSection(sl[Node.Parent.Index],sl);
                CellText:=sl[Node.Index];
              end;
        end;

    1 : if (TVirtualIniTree(Sender).GetNodeLevel(Node)=0)
          then CellText:=''
          else
            begin
              fIni.ReadSections(sl);
              s:=sl[Node.Parent.Index];
              fIni.ReadSection(s,sl);
              CellText:=fIni.ReadString(s,sl[Node.Index],'n/a')
            end;
  end;

  sl.Free;
end;

function TVirtualIniTree.GetOptionsClass: TTreeOptionsClass;
begin
  Result := TStringTreeOptions;
end;

procedure Register;
begin
  RegisterComponents('Virtual Controls', [TVirtualIniTree]);
end;

destructor TVirtualIniTree.Destroy;
begin
  SetLength(fIniFile,0);

  inherited;
end;

end.
