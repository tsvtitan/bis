{-----------------------------------------------------------}
{----Purpose : VT With Groupheader and Footer.              }
{    By      : Ir. G.W. van der Vegt                        }
{    For     : Fun                                          }
{    Module  : VirtualGHFStringTree.pas                     }
{    Depends : VT 3.2.1                                     }
{-----------------------------------------------------------}
{ ddmmyyyy comment                                          }
{ -------- -------------------------------------------------}
{ 05062002-Initial version.                                 }
{         -Footer Min/Maxwidth linked to VT Header.         }
{ 06062002-Implemented Min/MaxWdith width for groupheader.  }
{         -Set Fulldrag of THeadControls to False to prevent}
{          strange width problems when dragging exceeds     }
{          MaxWidth.                                        }
{         -Corrected some bugs.                             }
{         -Started on documentation.                        }
{-----------------------------------------------------------}
{ nr.    todo                                               }
{ ------ -------------------------------------------------- }
{ 1.     Scan for missing 3.2.1 properties.                 }
{-----------------------------------------------------------}

{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}

{
@abstract(Extends a TVirtualStringTree with a GroupHeader and Footer Control. )
@author(G.W. van der Vegt <wvd_vegt@knoware.nl>)
@created(Juli 05, 2002)
@lastmod(Juli 06, 2002)
This unit contains a TVirtualStringTree Descendant that can
be linked to two THeaderControls that will act as a
GroupHeader and a Footer. The Component takes care of the
synchronized resizing of the columns, sections and controls.
<P>
Just drop a TVirtualGHFStringTree and up to two
THeaderControls and link them to the TVirtualGHFStringTree.
Then add columns to both THeaderControls and Columns to
the TVirtualGHFStringTree's Header.
<P>
The Tag Value of the TVirtualGHFStringTree Header Columns is
used to group the columns and link them to a GroupHeader's
Section.
}

unit VirtualGHFStringTree;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualTrees, StdCtrls, Comctrls;

type
  { This TVirtualStringTree Descendant allows one to
    attach a GroupHeader and or Footer to a
    TVirtualStringTree.
    <P>
    Both GroupHeader and Footer are THeaderControl's.
    TVirtualGHFStringTree takes care of the synchronized
    resizing of all three components.
  }
  TVirtualGHFStringTree = class(TVirtualStringTree)
  private
    FGroupHeader: THeaderControl;
    FFooter: THeaderControl;
    function GetFooter: THeaderControl;
    function GetGroupHeader: THeaderControl;
    procedure SetFooter(const Value: THeaderControl);
    procedure SetGroupHeader(const Value: THeaderControl);
  protected
    { Description<P>
      Used for TreeOption in VirtualTreeView.        }
    function GetOptionsClass: TTreeOptionsClass; override;
    { Description<P>
      Sets the name of the Component and renames the GroupHeader
      and Footer controls accordingly. Do not call it directly
      but use the name property instead.
      <P>
      Parameters<P>
      NewName :   The new name of the Component. }
    procedure SetName(const NewName: TComponentName); override;

    { Description<P>
      Responds to Resizing the component by re-aligning
      the GroupHeader and Footer controls accordingly. Do
      not call directly.
      <P>
      Parameters<P>
      Message :   The WM_SIZE Message.        }
    procedure WMSize(var Message: TWMSize); message WM_SIZE;

    { Description<P>
      Responds to Moving the component by re-aligning
      the GroupHeader and Footer controls accordingly. Do
      not call directly.
      <P>
      Parameters<P>
      Message :   The WM_MOVE Message.        }
    procedure WMMove(var Message: TWMMove); message WM_MOVE;

    { Description<P>
      Called when the component's loading is finished. It
      will re-align the GroupHeader and Footer controls.
      Do not call directly. }
    procedure Loaded; override;

    { Description<P>
      Internally used to Resize the GroupHeader and Footer controls and
      update the MinWidth and Maxwith properties of both GroupHeader and Footer's
      Sections. Do not call directly. }
    procedure MyResize;

    { Description<P>
      Internally used to Resize the Columns and Sections.
      Do not call directly. }
    procedure ReAlignAll;

    { Description<P>
      Internally used to trap Column Resizing. Attached to
      the TVirtualStringTree's OnColumnResize Event.}
    procedure MyOnColumnResize(Sender: TVTHeader;
      Column: TColumnIndex);

    { Description<P>
      Internally used to trap Footer Section Resizing. Attached to
      the Footer's OnSectionTrack Event.}
    procedure MyOnFooterSectionTrack(HeaderControl: THeaderControl;
      Section: THeaderSection; Width: Integer; State: TSectionTrackState);

    { Description<P>
      Internally used to trap Group Header Section Resizing. Attached to
      the GroupHeader's OnSectionTrack Event.}
    procedure MyOnGroupHeaderSectionTrack(HeaderControl: THeaderControl;
      Section: THeaderSection; Width: Integer; State: TSectionTrackState);
  public
    { Description<P>
      Standard Constructor.
      <P>
      Parameters<P>
      AOwner : The owning Component.	}
    constructor Create(AOwner: TComponent); override;

    { Description<P>
      Standard Destructor. }
    destructor Destroy; override;
  published
    { Get/Sets the Footer value of the TVirtualGHFStringTree.
      The number of sections must be equal to the number of
      columns in the TVirtualGHFStringTree. MinWidth and MaxWidth
      are derived from the Header Columns.
      <P>
      Note<P>
      The Footer is renamed on basis of the TVirtualGHFStringTree's
      name to prevent problems with determining which THeaderControl belongs
      to which TVirtualGHFStringTree.}
    property Footer: THeaderControl read GetFooter write SetFooter;

    { Get/Sets the GroupHeader value of the TVirtualGHFStringTree.
      The Tag property of the HeaderColumn is used to determine
      which Header Columns belong to which GroupHeader Section.
      A group consists of adjacent Header Columns. The rightmost
      group(s) may be empty if their Indexes aren't used as the Tag Value
      in any Header Column. MinWidth and MaxWidth are derived from
      the Header Columns.
      <P>
      Note<P>
      The GroupHeader is renamed on basis of the TVirtualGHFStringTree's
      name to prevent problems with determining which THeaderControl belongs
      to which TVirtualGHFStringTree.}
    property GroupHeader: THeaderControl read GetGroupHeader write SetGroupHeader;

    //Default Properties:

    {Inherited from TVirtualStringTree.}
    property Align;
    {Inherited from TVirtualStringTree.}
    property Alignment;
    {Inherited from TVirtualStringTree.}
    property Anchors;
    {Inherited from TVirtualStringTree.}
    property AnimationDuration;
    {Inherited from TVirtualStringTree.}
    property AutoExpandDelay;
    {Inherited from TVirtualStringTree.}
    property AutoScrollDelay;
    {Inherited from TVirtualStringTree.}
    property AutoScrollInterval;
    {Inherited from TVirtualStringTree.}
    property Background;
    {Inherited from TVirtualStringTree.}
    property BackgroundOffsetX;
    {Inherited from TVirtualStringTree.}
    property BackgroundOffsetY;
    {Inherited from TVirtualStringTree.}
    property BiDiMode;
    {Inherited from TVirtualStringTree.}
    property BevelEdges;
    {Inherited from TVirtualStringTree.}
    property BevelInner;
    {Inherited from TVirtualStringTree.}
    property BevelOuter;
    {Inherited from TVirtualStringTree.}
    property BevelKind;
    {Inherited from TVirtualStringTree.}
    property BevelWidth;
    {Inherited from TVirtualStringTree.}
    property BorderStyle;
    {Inherited from TVirtualStringTree.}
    property ButtonFillMode;
    {Inherited from TVirtualStringTree.}
    {Inherited from TVirtualStringTree.}
    property ButtonStyle;
    {Inherited from TVirtualStringTree.}
    property BorderWidth;
    {Inherited from TVirtualStringTree.}
    property ChangeDelay;
    {Inherited from TVirtualStringTree.}
    property CheckImageKind;
    {Inherited from TVirtualStringTree.}
    property ClipboardFormats;
    {Inherited from TVirtualStringTree.}
    property Color;
    {Inherited from TVirtualStringTree.}
    property Colors;
    {Inherited from TVirtualStringTree.}
    property Constraints;
    {Inherited from TVirtualStringTree.}
    property Ctl3D;
    {Inherited from TVirtualStringTree.}
    property CustomCheckImages;
    {Inherited from TVirtualStringTree.}
    property DefaultNodeHeight;
    {Inherited from TVirtualStringTree.}
    property DefaultPasteMode;
    {Inherited from TVirtualStringTree.}
    property DefaultText;
    {Inherited from TVirtualStringTree.}
    property DragHeight;
    {Inherited from TVirtualStringTree.}
    property DragKind;
    {Inherited from TVirtualStringTree.}
    property DragImageKind;
    {Inherited from TVirtualStringTree.}
    property DragMode;
    {Inherited from TVirtualStringTree.}
    property DragOperations;
    {Inherited from TVirtualStringTree.}
    property DragType;
    {Inherited from TVirtualStringTree.}
    property DragWidth;
    {Inherited from TVirtualStringTree.}
    {Inherited from TVirtualStringTree.}
    property DrawSelectionMode;
    {Inherited from TVirtualStringTree.}
    property EditDelay;
    {Inherited from TVirtualStringTree.}
    property Enabled;
    {Inherited from TVirtualStringTree.}
    property Font;
    {Inherited from TVirtualStringTree.}
    property Header;
    {Inherited from TVirtualStringTree.}
    property HintAnimation;
    {Inherited from TVirtualStringTree.}
    property HintMode;
    {Inherited from TVirtualStringTree.}
    property HotCursor;
    {Inherited from TVirtualStringTree.}
    property Images;
    {Inherited from TVirtualStringTree.}
    property IncrementalSearch;
    {Inherited from TVirtualStringTree.}
    property IncrementalSearchDirection;
    {Inherited from TVirtualStringTree.}
    property IncrementalSearchStart;
    {Inherited from TVirtualStringTree.}
    property IncrementalSearchTimeout;
    {Inherited from TVirtualStringTree.}
    property Indent;
    {Inherited from TVirtualStringTree.}
    property LineMode;
    {Inherited from TVirtualStringTree.}
    property LineStyle;
    {Inherited from TVirtualStringTree.}
    property Margin;
    {Inherited from TVirtualStringTree.}
    property NodeAlignment;
    {Inherited from TVirtualStringTree.}
    property NodeDataSize;
    {Inherited from TVirtualStringTree.}
    property ParentBiDiMode;
    {Inherited from TVirtualStringTree.}
    property ParentColor default False;
    {Inherited from TVirtualStringTree.}
    property ParentCtl3D;
    {Inherited from TVirtualStringTree.}
    property ParentFont;
    {Inherited from TVirtualStringTree.}
    property ParentShowHint;
    {Inherited from TVirtualStringTree.}
    property PopupMenu;
    {Inherited from TVirtualStringTree.}
    property RootNodeCount;
    {Inherited from TVirtualStringTree.}
    property ScrollBarOptions;
    {Inherited from TVirtualStringTree.}
    property SelectionCurveRadius;
    {Inherited from TVirtualStringTree.}
    property ShowHint;
    {Inherited from TVirtualStringTree.}
    property StateImages;
    {Inherited from TVirtualStringTree.}
    property TabOrder;
    {Inherited from TVirtualStringTree.}
    property TabStop default True;
    {Inherited from TVirtualStringTree.}
    property TextMargin;
    {Inherited from TVirtualStringTree.}
    property TreeOptions;
    {Inherited from TVirtualStringTree.}
    property Visible;
    {Inherited from TVirtualStringTree.}
    property WantTabs;
    {Inherited from TVirtualStringTree.}

  //Default EventHandlers:

    {Inherited from TVirtualStringTree.}
    property OnAfterCellPaint;
    {Inherited from TVirtualStringTree.}
    property OnAfterItemErase;
    {Inherited from TVirtualStringTree.}
    property OnAfterItemPaint;
    {Inherited from TVirtualStringTree.}
    property OnAfterPaint;
    {Inherited from TVirtualStringTree.}
    property OnBeforeCellPaint;
    {Inherited from TVirtualStringTree.}
    property OnBeforeItemErase;
    {Inherited from TVirtualStringTree.}
    property OnBeforeItemPaint;
    {Inherited from TVirtualStringTree.}
    property OnBeforePaint;
    {Inherited from TVirtualStringTree.}
    property OnChange;
    {Inherited from TVirtualStringTree.}
    property OnChecked;
    {Inherited from TVirtualStringTree.}
    property OnChecking;
    {Inherited from TVirtualStringTree.}
    property OnClick;
    {Inherited from TVirtualStringTree.}
    property OnCollapsed;
    {Inherited from TVirtualStringTree.}
    property OnCollapsing;
    {Inherited from TVirtualStringTree.}
    property OnColumnClick;
    {Inherited from TVirtualStringTree.}
    property OnColumnDblClick;
    {Inherited from TVirtualStringTree.}
    property OnColumnResize;
    {Inherited from TVirtualStringTree.}
    property OnCompareNodes;
    {Inherited from TVirtualStringTree.}
    property OnCreateDataObject;
    {Inherited from TVirtualStringTree.}
    property OnCreateDragManager;
    {Inherited from TVirtualStringTree.}
    property OnCreateEditor;
    {Inherited from TVirtualStringTree.}
    property OnDblClick;
    {Inherited from TVirtualStringTree.}
    property OnDragAllowed;
    {Inherited from TVirtualStringTree.}
    property OnDragOver;
    {Inherited from TVirtualStringTree.}
    property OnDragDrop;
    {Inherited from TVirtualStringTree.}
    property OnEditCancelled;
    {Inherited from TVirtualStringTree.}
    property OnEdited;
    {Inherited from TVirtualStringTree.}
    property OnEditing;
    {Inherited from TVirtualStringTree.}
    property OnEndDock;
    {Inherited from TVirtualStringTree.}
    property OnEndDrag;
    {Inherited from TVirtualStringTree.}
    property OnEnter;
    {Inherited from TVirtualStringTree.}
    property OnExit;
    {Inherited from TVirtualStringTree.}
    property OnExpanded;
    {Inherited from TVirtualStringTree.}
    property OnExpanding;
    {Inherited from TVirtualStringTree.}
    property OnFocusChanged;
    {Inherited from TVirtualStringTree.}
    property OnFocusChanging;
    {Inherited from TVirtualStringTree.}
    property OnFreeNode;
    {Inherited from TVirtualStringTree.}
    property OnGetText;
    {Inherited from TVirtualStringTree.}
    property OnPaintText;
    {Inherited from TVirtualStringTree.}
    property OnGetHelpContext;
    {Inherited from TVirtualStringTree.}
    property OnGetImageIndex;
    {Inherited from TVirtualStringTree.}
    property OnGetHint;
    {Inherited from TVirtualStringTree.}
    property OnGetLineStyle;
    {Inherited from TVirtualStringTree.}
    property OnGetNodeDataSize;
    {Inherited from TVirtualStringTree.}
    property OnGetPopupMenu;
    {Inherited from TVirtualStringTree.}
    property OnGetUserClipboardFormats;
    {Inherited from TVirtualStringTree.}
    property OnHeaderClick;
    {Inherited from TVirtualStringTree.}
    property OnHeaderDblClick;
    {Inherited from TVirtualStringTree.}
    property OnHeaderDragged;
    {Inherited from TVirtualStringTree.}
    property OnHeaderDragging;
    {Inherited from TVirtualStringTree.}
    property OnHeaderDraw;
    {Inherited from TVirtualStringTree.}
    property OnHeaderMouseDown;
    {Inherited from TVirtualStringTree.}
    property OnHeaderMouseMove;
    {Inherited from TVirtualStringTree.}
    property OnHeaderMouseUp;
    {Inherited from TVirtualStringTree.}
    property OnHotChange;
    {Inherited from TVirtualStringTree.}
    property OnIncrementalSearch;
    {Inherited from TVirtualStringTree.}
    property OnInitChildren;
    {Inherited from TVirtualStringTree.}
    property OnInitNode;
    {Inherited from TVirtualStringTree.}
    property OnKeyAction;
    {Inherited from TVirtualStringTree.}
    property OnKeyDown;
    {Inherited from TVirtualStringTree.}
    property OnKeyPress;
    {Inherited from TVirtualStringTree.}
    property OnKeyUp;
    {Inherited from TVirtualStringTree.}
    property OnLoadNode;
    {Inherited from TVirtualStringTree.}
    property OnMouseDown;
    {Inherited from TVirtualStringTree.}
    property OnMouseMove;
    {Inherited from TVirtualStringTree.}
    property OnMouseUp;
    {Inherited from TVirtualStringTree.}
    property OnNewText;
    {Inherited from TVirtualStringTree.}
    property OnNodeCopied;
    {Inherited from TVirtualStringTree.}
    property OnNodeCopying;
    {Inherited from TVirtualStringTree.}
    property OnNodeMoved;
    {Inherited from TVirtualStringTree.}
    property OnNodeMoving;
    {Inherited from TVirtualStringTree.}
    property OnPaintBackground;
    {Inherited from TVirtualStringTree.}
    property OnRenderOLEData;
    {Inherited from TVirtualStringTree.}
    property OnResetNode;
    {Inherited from TVirtualStringTree.}
    property OnResize;
    {Inherited from TVirtualStringTree.}
    property OnSaveNode;
    {Inherited from TVirtualStringTree.}
    property OnScroll;
    {Inherited from TVirtualStringTree.}
    property OnShortenString;
    {Inherited from TVirtualStringTree.}
    property OnStartDock;
    {Inherited from TVirtualStringTree.}
    property OnStartDrag;
    {Inherited from TVirtualStringTree.}
    property OnStructureChange;
    {Inherited from TVirtualStringTree.}
    property OnUpdating;
  end;

{ Description
  Standard Register Routine for this component.        
  Registers TVirtualGHFStringTree to the 'Virtual Controls' tab of the component palette.  }
procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Virtual Controls', [TVirtualGHFStringTree]);
end;

function LineHeight(Canvas: TCanvas): Integer;
var
  tm           : TEXTMETRIC;
begin
  with Canvas do
    begin
      GetTextmetrics(handle, tm);
      Result := tm.tmHeight + tm.tmExternalLeading;
    end;
end;

{ TVirtualGHFStringTree }

constructor TVirtualGHFStringTree.Create(AOwner: TComponent);
begin
  inherited;

//Preset some settings so it looks like a R/O Memo
  DefaultNodeHeight := 13;                                                      //Measured against a plain TMemo so it looks equal to it.
  Header.Height := 17;                                                          //Measured against a TListView;

  with TStringTreeOptions(TreeOptions) do
    begin
      PaintOptions := PaintOptions + [toShowRoot, toShowTreeLines, toShowButtons, toHideFocusRect];
      SelectionOptions := SelectionOptions + [toFullRowSelect];
    end;

  Parent := TWinControl(AOwner);
  Header.Options := Header.Options + [hoVisible] - [hoRestrictDrag, hoDrag];
  BorderWidth := 0;
  BevelKind := bkNone;
  BorderStyle := bsNone;

  FGroupHeader := nil;
  FFooter := nil;

  OnColumnResize := MyOnColumnResize;

  Header.Height := Round(2.6 * lineHeight(Canvas));                             //34

  Hint := '';
end;

destructor TVirtualGHFStringTree.Destroy;
begin
{
  If Assigned(FGroupHeader) then
    begin
      FGroupHeader.Parent:=nil;
      FGroupHeader.Free;
    end;
  If Assigned(FFooter) then
    begin
      FFooter.Parent:=nil;
      FFooter.Free;
    end;
   }
  inherited;
end;

function TVirtualGHFStringTree.GetOptionsClass: TTreeOptionsClass;
begin
  Result := TStringTreeOptions;
end;

procedure TVirtualGHFStringTree.MyResize;
begin
  if Assigned(FGroupHeader) then
    begin
      FGroupHeader.Left := Left;
      FGroupHeader.Width := Width;
      FGroupHeader.Height := Round(1.6 * lineHeight(FGroupHeader.Canvas));      //1.9 = 25, 1.8 = 23, was 1.6 = 21
      FGroupHeader.Top := Top - Round(1.6 * lineHeight(FGroupHeader.Canvas));
    end;

  if Assigned(FFooter) then
    begin
      FFooter.Left := Left;
      FFooter.Width := Width;
      FFooter.Top := Self.Top + Self.Height;
      FFooter.Height := Round(2.6 * lineHeight(FFooter.Canvas));                //34
    end;
end;

procedure TVirtualGHFStringTree.MyOnColumnResize(Sender: TVTHeader;
  Column: TColumnIndex);
var
  ndx,
    w,
    i          : Integer;
begin
  ndx := Sender.Columns[Column].Tag;

  if not (assigned(GroupHeader)) or (ndx >= GroupHeader.Sections.Count) then Exit;

//Get Width of Group Header's columns
  w := 0;
  for i := 0 to Pred(Header.Columns.Count) do
    if (Sender.Columns[i].Tag = ndx) then Inc(w, Header.Columns[i].Width);
  GroupHeader.Sections[ndx].Width := w;
  GroupHeader.Update;

  if not (assigned(Footer)) or (Header.Columns.Count <> Footer.Sections.Count) then Exit;

  for i := 0 to Pred(Header.Columns.Count) do
    begin
      Footer.Sections[i].MinWidth := Header.Columns[i].MinWidth;
      Footer.Sections[i].MaxWidth := Header.Columns[i].MaxWidth;
      Footer.Sections[i].Width := Header.Columns[i].Width;
    end;

  Footer.Update;
end;

procedure TVirtualGHFStringTree.ReAlignAll;
var
  i, j         : TColumnIndex;
  MinW, MaxW   : Integer;
begin
  if assigned(GroupHeader) then
    begin
    //Loop through the Groupheaders Columns to calculated the Total MinWidth and MaxWidth
      for i := 0 to Pred(GroupHeader.Sections.Count) do
        begin
          MinW := -1;
          MaxW := -1;

          for j := 0 to Pred(Header.Columns.Count) do
            if (i = Header.Columns[j].Tag) then
              begin
                Inc(MinW, Header.Columns[j].MinWidth);
                Inc(MaxW, Header.Columns[j].MaxWidth);
              end;

          if (MinW <> -1) and (MaxW <> -1) then
            begin
              GroupHeader.Sections[i].MinWidth := MinW + 1;
              GroupHeader.Sections[i].MaxWidth := MaxW + 1;
            end;
        end;
    end;

//Loop through the Header Columns to copy their MinWidth and MaxWidth to the Footer
  if Assigned(Footer) then
    begin
      Footer.Sections.BeginUpdate;
      for i := 0 to Pred(Header.Columns.Count) do
        begin
          Footer.Sections[i].MinWidth := Header.Columns[i].MinWidth;
          Footer.Sections[i].MaxWidth := Header.Columns[i].MaxWidth;
        end;
      Footer.Sections.EndUpdate;
    end;

//Resize Every Column.
  for i := 0 to Pred(Header.Columns.Count) do
    MyOnColumnResize(Header, i);
end;

procedure TVirtualGHFStringTree.MyOnFooterSectionTrack(HeaderControl: THeaderControl;
  Section: THeaderSection; Width: Integer; State: TSectionTrackState);
begin
//Strange Effects when MaxWidth is Exceeded during Drag. Width seem to be Starting at zero again.
  OutputDebugString(PChar(IntToStr(Width)));
  Header.Columns[Section.Index].Width := Width;
  HeaderControl.Repaint;
  MyOnColumnResize(Header, Section.Index);
end;

procedure TVirtualGHFStringTree.MyOnGroupHeaderSectionTrack(HeaderControl: THeaderControl;
  Section: THeaderSection; Width: Integer; State: TSectionTrackState);
var
  d, i, gr, grw, sw: Integer;
  found        : Boolean;
  v, mid, sid  : Integer;
begin
//Strange Effects when MaxWidth is Exceeded during Drag. Width seem to be Starting at zero again.
  gr := Section.Index;

  found := False;
  grw := 0;
  for i := 0 to Pred(Header.Columns.Count) do
    if (Header.Columns[i].Tag = gr) then
      begin
        Inc(grw, Header.Columns[i].Width);
        Found := True;
      end;

  Section.Width := Width;

//Prevent Resizing when there are no columns for this GroupHeader Section.
  if not Found then exit;

  OutputDebugString(PChar(IntToStr(Width) + '+' + IntToStr(grw) + '+' + IntToStr(gr)));

  sw := Width;
  d := Abs(grw - sw);

//Now loop and Increment either the smallest or Decrement the largest column
//until the sizes match.
  Header.Columns.BeginUpdate;
  repeat
    found := false;

    if (d > 0) then
      begin
        if (grw - sw) > 0 then
          begin
          //Find largest
            v := -1;
            mid := 0;
            for i := 0 to Pred(Header.Columns.Count) do
              if (Header.Columns[i].Tag = gr) and (v < Header.Columns[i].Width) then
                begin
                  v := Header.Columns[i].Width;
                  mid := i;
                end;

            if (Header.Columns[mid].Width > Header.Columns[mid].MinWidth) then
              begin
                Header.Columns[mid].Width := Header.Columns[mid].Width - 1;
                Dec(d);
                Dec(grw);
                found := True;
              end;
          end
        else
          begin
          //Find smallest
            v := maxint;
            sid := 0;
            for i := 0 to Pred(Header.Columns.Count) do
              if (Header.Columns[i].Tag = gr) and (v > Header.Columns[i].Width) then
                begin
                  v := Header.Columns[i].Width;
                  sid := i;
                end;

            if (Header.Columns[sid].Width < Header.Columns[sid].MaxWidth) then
              begin
                Header.Columns[sid].Width := Header.Columns[sid].Width + 1;
                Dec(d);
                Inc(grw);
                found := True;
              end;
          end;
      end
  until (d = 0) or not found;
  Header.Columns.EndUpdate;
  Update;

//Prevent Resizing when there's no Footer
  if not (assigned(Footer)) or (Header.Columns.Count <> Footer.Sections.Count) then Exit;

  Footer.Sections.BeginUpdate;
  for i := 0 to Pred(Header.Columns.Count) do
    Footer.Sections[i].Width := Header.Columns[i].Width;
  Footer.Sections.EndUpdate;
  Footer.Update;
end;

procedure TVirtualGHFStringTree.SetName(const NewName: TComponentName);
begin
  inherited;

//Rename the headercontrols so we can see to who they belong.
//Makes it ieasier to find the newly dropped ones with their default names.
  if Assigned(FGroupHeader) then FGroupHeader.Name := NewName + '_GroupHeader';
  if Assigned(FFooter) then FFooter.Name := NewName + '_Footer';

//Update after the components name is changed won't hurt.
  MyResize;
  ReAlignAll;
end;

procedure TVirtualGHFStringTree.Loaded;
begin
  inherited;

//We need an update after the component is loaded to align everything.
  MyResize;
  ReAlignAll;
end;

function TVirtualGHFStringTree.GetGroupHeader: THeaderControl;
begin
  Result := FGroupHeader;
end;

procedure TVirtualGHFStringTree.SetGroupHeader(
  const Value: THeaderControl);
begin
  if Assigned(Value) then
    begin
    //Make sure to change some properties so we don't get problems.
      FGroupHeader := Value;
      FGroupHeader.Align := alNone;
      FGroupHeader.DoubleBuffered := True;

    //Prevent Strange Effects when MaxWidth is Exceeded during Drag. Width seem to be Starting at zero again.
      FGroupHeader.FullDrag := False;
      FGroupHeader.OnSectionTrack := MyOnGroupHeaderSectionTrack;

    //Rename the headercontrol so we can see to who they belong.
    //Makes it easier to find the newly dropped ones with their default names.
      FGroupHeader.Name := Name + '_GroupHeader';

    //Re-arrange all when adding or removing a header
      MyResize;
      ReAlignAll;
    end
  else
    begin
      FGroupHeader.OnSectionTrack := nil;
      FGroupHeader := Value;
    end;
end;

function TVirtualGHFStringTree.GetFooter: THeaderControl;
begin
  Result := FFooter;
end;

procedure TVirtualGHFStringTree.SetFooter(const Value: THeaderControl);
begin
  if Assigned(Value) then
    begin
    //Make sure to change some properties so we don't get problems.
      FFooter := Value;
      FFooter.Align := alNone;
      FFooter.DoubleBuffered := True;

    //Strange Effects when MaxWidth is Exceeded during Drag. Width seem to be Starting at zero again.
      FFooter.FullDrag := False;
      FFooter.OnSectionTrack := MyOnFooterSectionTrack;

    //Rename the headercontrols so we can see to who they belong.
    //Makes it easier to find the newly dropped ones with their default names.
      FFooter.Name := Name + '_Footer';

    //Re-arrange all when adding or removing a footer
      MyResize;
      ReAlignAll;
    end
  else
    begin
      FFooter.OnSectionTrack := nil;
      FFooter := Value;
    end;
end;

procedure TVirtualGHFStringTree.WMMove(var Message: TWMMove);
begin
  inherited;

//Re-arrange all when moving the component.
  MyResize;
  ReAlignAll;
end;

procedure TVirtualGHFStringTree.WMSize(var Message: TWMSize);
begin
  inherited;

//Re-arrange all when sizing the component.
  MyResize;
  ReAlignAll;
end;

end.

