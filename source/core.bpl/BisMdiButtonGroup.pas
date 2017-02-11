unit BisMdiButtonGroup;

interface

uses
  Windows, SysUtils, Classes, Controls, ImgList, Forms, Messages,
  Graphics, StdCtrls, GraphUtil, CategoryButtons;

type
  TBisMdiGrpButtonItem = class;
  TBisMdiGrpButtonItemClass = class of TBisMdiGrpButtonItem;
  TBisMdiGrpButtonItems = class;
  TBisMdiGrpButtonItemsClass = class of TBisMdiGrpButtonItems;

  TBisMdiGrpButtonOptions = set of (gboAllowReorder, gboFullSize, gboGroupStyle,
    gboShowCaptions);

  TBisMdiGrpButtonEvent = procedure(Sender: TObject; Index: Integer) of object;
  TBisMdiGrpButtonDrawEvent = procedure(Sender: TObject; Index: Integer;
    Canvas: TCanvas; Rect: TRect; State: TButtonDrawState) of object;
  TBisMdiGrpButtonDrawIconEvent = procedure(Sender: TObject; Index: Integer;
    Canvas: TCanvas; Rect: TRect; State: TButtonDrawState; var TextOffset: Integer) of object;
  TBisMdiGrpButtonReorderEvent = procedure(Sender: TObject; OldIndex, NewIndex: Integer) of object;

  TBisMdiButtonGroupDrawingStyle = (dsNormal, dsGradient);

  TBisMdiButtonGroupCanAddEvent=function (Sender: TObject; AForm: TForm): Boolean of object;

  { Note: TBisMdiButtonGroup requires (Win98 | Win NT 4.0) or above }
  TBisMdiButtonGroup = class(TCustomControl)
  private
    FDownIndex: Integer;
    FDragIndex: Integer;
    FDragStartPos: TPoint;
    FDragStarted: Boolean;
    FDragImageList: TDragImageList;
    FHiddenItems: Integer; { Hidden rows or Hidden columns, depending on the flow }
    FHotIndex: Integer;
    FInsertLeft, FInsertTop, FInsertRight, FInsertBottom: Integer;
    FIgnoreUpdate: Boolean;
    FScrollBarMax: Integer;
    FPageAmount: Integer;
    FButtonItems: TBisMdiGrpButtonItems;
    FButtonOptions: TBisMdiGrpButtonOptions;
    FButtonWidth, FButtonHeight: Integer;
    FBorderStyle: TBorderStyle;
    FFocusIndex: Integer;
    FItemIndex: Integer;
    FImageChangeLink: TChangeLink;
    FImages: TCustomImageList;
    FMouseInControl: Boolean;
    FOnButtonClicked: TBisMdiGrpButtonEvent;
    FOnClick: TNotifyEvent;
    FOnHotButton: TBisMdiGrpButtonEvent;
    FOnDrawIcon: TBisMdiGrpButtonDrawIconEvent;
    FOnDrawButton: TBisMdiGrpButtonDrawEvent;
    FOnBeforeDrawButton: TBisMdiGrpButtonDrawEvent;
    FOnAfterDrawButton: TBisMdiGrpButtonDrawEvent;
    FOnReorderButton: TBisMdiGrpButtonReorderEvent;
    FScrollBarShown: Boolean;

    FMdiClientInstance: TFarProc;
    FDefMdiClientProc: TFarProc;
    FMdiClientHandle: THandle;
    FGradientStartColor: TColor;
    FGradientDirection: TGradientDirection;
    FGradientEndColor: TColor;
    FDrawingStyle: TBisMdiButtonGroupDrawingStyle;
    FHotTrackColor: TColor;
    FMargin: Cardinal;
    FActivating: Boolean;
    FCaption: TCaption;
    FOnCanAdd: TBisMdiButtonGroupCanAddEvent;

    procedure AutoScroll(ScrollCode: TScrollCode);
    procedure ImageListChange(Sender: TObject);
    function CalcButtonsPerRow: Integer;
    function CalcRowsSeen: Integer;
    procedure DoFillRect(const Rect: TRect; Empty: Boolean=false);
    procedure ScrollPosChanged(ScrollCode: TScrollCode;
      ScrollPos: Integer);
    procedure SetOnDrawButton(const Value: TBisMdiGrpButtonDrawEvent);
    procedure SetOnDrawIcon(const Value: TBisMdiGrpButtonDrawIconEvent);
    procedure SetBorderStyle(const Value: TBorderStyle);
    procedure SeTBisMdiGrpButtonItems(const Value: TBisMdiGrpButtonItems);
    procedure SetButtonHeight(const Value: Integer);
    procedure SeTBisMdiGrpButtonOptions(const Value: TBisMdiGrpButtonOptions);
    procedure SetButtonWidth(const Value: Integer);
    procedure SetItemIndex(const Value: Integer);
    procedure SetImages(const Value: TCustomImageList);
    procedure ShowScrollBar(const Visible: Boolean);
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    procedure CNKeydown(var Message: TWMKeyDown); message CN_KEYDOWN;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMMouseLeave(var Message: TMessage); message WM_MOUSELEAVE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure SetDragIndex(const Value: Integer);
    procedure MdiClientWndProc(var Message: TMessage);
    procedure SetMdiClientHandle(const Value: THandle);
    function IsGradientEndColorStored: Boolean;
    procedure SetGradientDirection(const Value: TGradientDirection);
    procedure SetGradientEndColor(const Value: TColor);
    procedure SetGradientStartColor(const Value: TColor);
    procedure SetDrawingStyle(const Value: TBisMdiButtonGroupDrawingStyle);
  protected
    function CreateButton: TBisMdiGrpButtonItem; virtual;
    procedure CreateHandle; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoEndDrag(Target: TObject; X: Integer; Y: Integer); override;
    procedure DoHotButton; dynamic;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure DoReorderButton(const OldIndex, NewIndex: Integer);
    procedure DoStartDrag(var DragObject: TDragObject); override;
    procedure DragOver(Source: TObject; X: Integer; Y: Integer;
      State: TDragState; var Accept: Boolean); override;
    procedure DrawButton(Index: Integer; Canvas: TCanvas;
      Rect: TRect; State: TButtonDrawState); virtual;
    procedure DoItemClicked(const Index: Integer); virtual;
    function GetButtonClass: TBisMdiGrpButtonItemClass; virtual;
    function GetButtonsClass: TBisMdiGrpButtonItemsClass; virtual;
    function GetDragImages: TDragImageList; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure Resize; override;
    procedure UpdateButton(const Index: Integer);
    procedure UpdateAllButtons;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    { DragIndex: If a drag operation is coming from this control, it is
      because they are dragging the item at DragIndex. Set DragIndex to
      control which item is being dragged before manually calling
      BeginDrag. }
    property DragIndex: Integer read FDragIndex write SetDragIndex;
    property DragImageList: TDragImageList read FDragImageList;
    procedure DragDrop(Source: TObject; X: Integer; Y: Integer); override;
    function GetButtonRect(const Index: Integer): TRect;
    function IndexOfButtonAt(const X, Y: Integer): Integer;
    { RemoveInsertionPoints: Removes the insertion points added by
      SetInsertionPoints }
    procedure RemoveInsertionPoints;
    procedure ScrollIntoView(const Index: Integer);
    { SetInsertionPoints: Draws an insert line for inserting at
      InsertionIndex. Shows/Hides  }
    procedure SetInsertionPoints(const InsertionIndex: Integer);
    { TargetIndexAt: Gives you the target insertion index given a
      coordinate. If it is above half of a current button, it inserts
      above it. If it is below the half, it inserts after it. }
    function TargetIndexAt(const X, Y: Integer): Integer;

    function FindItem(Form: TForm): TBisMdiGrpButtonItem;
    function AddItem(Form: TForm): TBisMdiGrpButtonItem;
    procedure RemoveItem(Form: TForm);
    procedure ActivateItem(Form: TForm);

    property Canvas;
    property MdiClientHandle: THandle read FMdiClientHandle write SetMdiClientHandle;
  published
    property Align;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property ButtonHeight: Integer read FButtonHeight write SetButtonHeight default 24;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth default 24;
    property ButtonOptions: TBisMdiGrpButtonOptions read FButtonOptions write SeTBisMdiGrpButtonOptions default [gboShowCaptions];
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Height default 100;
    property Images: TCustomImageList read FImages write SetImages;
    property Items: TBisMdiGrpButtonItems read FButtonItems write SeTBisMdiGrpButtonItems;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Width default 100;
    property Visible;

    property DrawingStyle: TBisMdiButtonGroupDrawingStyle read FDrawingStyle write SetDrawingStyle default dsNormal;
    property GradientDirection: TGradientDirection read FGradientDirection write SetGradientDirection default gdVertical;
    property GradientStartColor: TColor read FGradientStartColor write SetGradientStartColor default clWindow;
    property GradientEndColor: TColor read FGradientEndColor write SetGradientEndColor stored IsGradientEndColorStored;
    property HotTrackColor: TColor read FHotTrackColor write FHotTrackColor default $00EFD3C6;
    property Margin: Cardinal read FMargin write FMargin;
    property Caption: TCaption read FCaption write FCaption;

    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnButtonClicked: TBisMdiGrpButtonEvent read FOnButtonClicked write FOnButtonClicked;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnHotButton: TBisMdiGrpButtonEvent read FOnHotButton write FOnHotButton;
    property OnAfterDrawButton: TBisMdiGrpButtonDrawEvent read FOnAfterDrawButton write FOnAfterDrawButton;
    property OnBeforeDrawButton: TBisMdiGrpButtonDrawEvent read FOnBeforeDrawButton write FOnBeforeDrawButton;
    property OnDrawButton: TBisMdiGrpButtonDrawEvent read FOnDrawButton write SetOnDrawButton;
    property OnDrawIcon: TBisMdiGrpButtonDrawIconEvent read FOnDrawIcon write SetOnDrawIcon;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnReorderButton: TBisMdiGrpButtonReorderEvent read FOnReorderButton write FOnReorderButton;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDock;
    property OnStartDrag;
    property OnCanAdd: TBisMdiButtonGroupCanAddEvent read FOnCanAdd write FOnCanAdd;  
  end;

  TBisMdiGrpButtonItem = class(TBaseButtonItem)
  private
    FForm: TForm;
    function GeTBisMdiButtonGroup: TBisMdiButtonGroup;
    function GetCollection: TBisMdiGrpButtonItems;
    procedure SetCollection(const Value: TBisMdiGrpButtonItems); reintroduce;
    function GetCaption: TCaption;
    function GetHint: String;
  protected
    function GetNotifyTarget: TComponent; override;
  public
    procedure ScrollIntoView; override;
    property Collection: TBisMdiGrpButtonItems read GetCollection write SetCollection;
  published
    property ButtonGroup: TBisMdiButtonGroup read GeTBisMdiButtonGroup;
    property Caption: TCaption read GetCaption;
    property Hint: String read GetHint;

    property Form: TForm read FForm write FForm;
  end;

  TBisMdiGrpButtonItems = class(TCollection)
  private
    FButtonGroup: TBisMdiButtonGroup;
    FOriginalID: Integer;
    function GetItem(Index: Integer): TBisMdiGrpButtonItem;
    procedure SetItem(Index: Integer; const Value: TBisMdiGrpButtonItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(const ButtonGroup: TBisMdiButtonGroup);
    function Add: TBisMdiGrpButtonItem;
    function AddItem(Item: TBisMdiGrpButtonItem; Index: Integer): TBisMdiGrpButtonItem;
    procedure BeginUpdate; override;
    function Insert(Index: Integer): TBisMdiGrpButtonItem;
    property Items[Index: Integer]: TBisMdiGrpButtonItem read GetItem write SetItem; default;
    property ButtonGroup: TBisMdiButtonGroup read FButtonGroup;
  end;

implementation

uses Themes, ExtCtrls, Types;

{ TBisMdiButtonGroup }

constructor TBisMdiButtonGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 150;
  Height := 29;
  ControlStyle := [csDoubleClicks, csCaptureMouse, csDisplayDragImage, csPannable];
  BevelInner:=bvNone;
  BevelOuter:=bvNone;
  FButtonItems := GetButtonsClass.Create(Self);
  FButtonOptions := [gboGroupStyle,gboShowCaptions];
  FBorderStyle:=bsNone;
  FButtonWidth := 23;
  FButtonHeight := 22;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FDoubleBuffered := True;
  FHotIndex := -1;
  FDownIndex := -1;
  FItemIndex := -1;
  FDragIndex := -1;
  FInsertBottom := -1;
  FInsertTop := -1;
  FInsertLeft := -1;
  FInsertRight := -1;
  FDragImageList := TDragImageList.Create(nil);
  FFocusIndex := -1;
  FHotTrackColor:=$00EFD3C6;
  FGradientStartColor:=clWindow;
  FGradientEndColor:=$00CAC4C6;
  FMargin:=4;
  FMdiClientInstance:=Classes.MakeObjectInstance(MdiClientWndProc);

  TabStop := True;
end;

function TBisMdiButtonGroup.CreateButton: TBisMdiGrpButtonItem;
begin
  Result := GetButtonClass.Create(FButtonItems);
end;

procedure TBisMdiButtonGroup.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if (FBorderStyle = bsSingle) then
  begin
    Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;
end;

destructor TBisMdiButtonGroup.Destroy;
begin
  if FMdiClientHandle <> 0 then
    SetWindowLong(FMdiClientHandle,GWL_WNDPROC,LongInt(FDefMdiClientProc));
  Classes.FreeObjectInstance(FMdiClientInstance);
  FDragImageList.Free;
  FButtonItems.Free;
  FImageChangeLink.Free;
  inherited;
end;

function TBisMdiButtonGroup.GetButtonClass: TBisMdiGrpButtonItemClass;
begin
  Result := TBisMdiGrpButtonItem;
end;

function TBisMdiButtonGroup.GetButtonRect(const Index: Integer): TRect;
var
  ButtonsPerRow: Integer;
  HiddenCount: Integer;
  Item: Integer;
  Row, Col: Integer;
begin
  ButtonsPerRow := CalcButtonsPerRow;
  HiddenCount := FHiddenItems*ButtonsPerRow;
  { Subtract out what we can't see }
  Item := Index - HiddenCount;

  Row := Item div ButtonsPerRow;
  Result.Top := Row*FButtonHeight;
  if gboFullSize in FButtonOptions then
  begin
    Result.Left := 0;
    Result.Right := ClientWidth;
  end
  else
  begin
    Col := Item mod ButtonsPerRow;
    Result.Left := Col*FButtonWidth;
    Result.Right := Result.Left + FButtonWidth;
  end;
  Result.Bottom := Result.Top + FButtonHeight;
end;

function TBisMdiButtonGroup.GetButtonsClass: TBisMdiGrpButtonItemsClass;
begin
  Result := TBisMdiGrpButtonItems;
end;

procedure TBisMdiButtonGroup.ImageListChange(Sender: TObject);
begin
  UpdateAllButtons;
end;

procedure TBisMdiButtonGroup.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
begin
  inherited;
  if (Operation = opRemove) then
  begin
    if AComponent = Images then
      Images := nil
    else
      if AComponent is TBasicAction then
        for I := 0 to FButtonItems.Count - 1 do
          if AComponent = FButtonItems[I].Action then
            FButtonItems[I].Action := nil;
  end;
end;

procedure TBisMdiButtonGroup.Paint;
var
  ButtonCount: Integer;
  RowsSeen, ButtonsPerRow: Integer;
  HiddenCount, VisibleCount: Integer;
  CurOffset: TPoint;
  RowPos: Integer;
  X: Integer;
  ItemRect: TRect;
  ActualWidth, ActualHeight: Integer;
  DrawState: TButtonDrawState;
  ARect: TRect;
  Text: String;
begin
  Canvas.Brush.Color := clBtnFace;
  ButtonCount := FButtonItems.Count;
  if ButtonCount > 0 then
  begin
    RowsSeen := CalcRowsSeen;
    ButtonsPerRow := CalcButtonsPerRow;
    HiddenCount := FHiddenItems * ButtonsPerRow;
    VisibleCount := RowsSeen*ButtonsPerRow;
      
    if (HiddenCount + VisibleCount) > ButtonCount then
      VisibleCount := ButtonCount - HiddenCount; { We can see more items than we have }

    CurOffset.X := 0; { Start at the very top left }
    CurOffset.Y := 0;
    RowPos := 0;
    if gboFullSize in ButtonOptions then
      ActualWidth := ClientWidth
    else
      ActualWidth := FButtonWidth;
    ActualHeight := FButtonHeight;

    for X := HiddenCount to HiddenCount + VisibleCount - 1 do
    begin
      ItemRect := Bounds(CurOffset.X, CurOffset.Y, ActualWidth, ActualHeight);
      DrawState := [];
      if X = FHotIndex then
      begin
        Include(DrawState, bdsHot);
        if X = FDownIndex then
          Include(DrawState, bdsDown);
      end;
      if X = FItemIndex then
        Include(DrawState, bdsSelected);

      if X = FInsertTop then
        Include(DrawState, bdsInsertTop)
      else if X = FInsertBottom then
        Include(DrawState, bdsInsertBottom)
      else if X = FInsertRight then
        Include(DrawState, bdsInsertRight)
      else if X = FInsertLeft then
        Include(DrawState, bdsInsertLeft);
      if (X = FFocusIndex) and Focused then
        Include(DrawState, bdsFocused);

      DrawButton(X, Canvas, ItemRect, DrawState);
      Inc(RowPos);
      { Should we go to the next line? }
      if RowPos >= ButtonsPerRow then
      begin
        { Erase to the end }
        Inc(CurOffset.X, ActualWidth);
        DoFillRect(Rect(CurOffset.X, CurOffset.Y, ClientWidth,
          CurOffset.Y + ActualHeight));
        RowPos := 0;
        CurOffset.X := 0;
        Inc(CurOffset.Y, ActualHeight);
      end
      else
        Inc(CurOffset.X, ActualWidth);
    end;
    { Erase to the end }
    DoFillRect(Rect(CurOffset.X, CurOffset.Y,
      ClientWidth, CurOffset.Y + ActualHeight));
    { Erase to the bottom }
    DoFillRect(Rect(0, CurOffset.Y + ActualHeight, ClientWidth, ClientHeight));
  end else begin

    DoFillRect(ClientRect,true);

    if (FCaption<>'') then begin
      ARect:=GetClientRect;
      ARect.Top:=ARect.Top+(ARect.Bottom-ARect.Top) div 2 - Canvas.TextHeight(FCaption) div 2;
      Text:=FCaption;
      Canvas.Brush.Style:=bsClear;
      Canvas.TextRect(ARect,Text,[tfCenter,tfEndEllipsis]);
      Canvas.Brush.Style:=bsSolid;
    end;

  end;
end;


function TBisMdiButtonGroup.CalcButtonsPerRow: Integer;
begin
  if gboFullSize in ButtonOptions then
    Result := 1
  else
  begin
    Result := ClientWidth div FButtonWidth;
    if Result = 0 then
      Result := 1;
  end;
end;

function TBisMdiButtonGroup.CalcRowsSeen: Integer;
begin
  Result := ClientHeight div FButtonHeight
end;

procedure TBisMdiButtonGroup.MdiClientWndProc(var Message: TMessage);

  procedure Default;
  begin
    with Message do
      Result := CallWindowProc(FDefMdiClientProc, FMdiClientHandle, Msg, wParam, lParam);
  end;

  function FindForm(Handle: THandle): TForm;
  var
    Control: TWinControl;
  begin
    Result:=nil;
    Control:=FindControl(Handle);
    if Assigned(Control) and (Control is TForm) then begin
      Result:=TForm(Control);
    end;
  end;

  procedure MdiActivate;
  begin
    with Message do
      Result := CallWindowProc(FDefMdiClientProc, FMdiClientHandle, Msg, wParam, lParam);

    ActivateItem(FindForm(Message.Result));
  end;

  procedure MdiCreate;
  begin
    with Message do
      Result := CallWindowProc(FDefMdiClientProc, FMdiClientHandle, Msg, wParam, lParam);

    AddItem(FindForm(Message.Result));
  end;

  procedure MdiDestroy;
  begin
    RemoveItem(FindForm(Message.WParam));

    with Message do
      Result := CallWindowProc(FDefMdiClientProc, FMdiClientHandle, Msg, wParam, lParam);
  end;

begin
  if Assigned(FDefMdiClientProc) then
    with Message do
      case Msg of
        WM_MDIGETACTIVE: MdiActivate;
        WM_MDICREATE: MdiCreate;
        WM_MDIDESTROY: MdiDestroy;
      else
        Default;
      end;
end;

procedure TBisMdiButtonGroup.Resize;
var
  RowsSeen: Integer;
  ButtonsPerRow: Integer;
  TotalRowsNeeded: Integer;
  ScrollInfo: TScrollInfo;
begin
  inherited;
  { Reset the original position }
  FHiddenItems := 0;

  { How many rows can we show? }
  RowsSeen := CalcRowsSeen;
  ButtonsPerRow := CalcButtonsPerRow;

  { Do we have to take the scrollbar into consideration? }
  if (ButtonsPerRow*RowsSeen < FButtonItems.Count) then
  begin
    TotalRowsNeeded := FButtonItems.Count div ButtonsPerRow;
    if FButtonItems.Count mod ButtonsPerRow <> 0 then
      Inc(TotalRowsNeeded);

    if TotalRowsNeeded > RowsSeen then
      FPageAmount := RowsSeen
    else
      FPageAmount := TotalRowsNeeded;

    { Adjust the max to NOT contain the page amount }
    FScrollBarMax := TotalRowsNeeded - FPageAmount;

    ScrollInfo.cbSize := SizeOf(TScrollInfo);
    ScrollInfo.fMask := SIF_RANGE or SIF_POS or SIF_PAGE;
    ScrollInfo.nMin := 0;
    ScrollInfo.nMax := TotalRowsNeeded - 1;
    ScrollInfo.nPos := 0;
    ScrollInfo.nPage := FPageAmount;

    SetScrollInfo(Handle, SB_VERT, ScrollInfo, False);
    ShowScrollBar(True);
  end
  else
    ShowScrollBar(False);
end;

procedure TBisMdiButtonGroup.SetBorderStyle(const Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TBisMdiButtonGroup.SetButtonHeight(const Value: Integer);
begin
  if (FButtonHeight <> Value) and (Value > 0) then
  begin
    FButtonHeight := Value;
    UpdateAllButtons;
  end;
end;

procedure TBisMdiButtonGroup.SeTBisMdiGrpButtonItems(const Value: TBisMdiGrpButtonItems);
begin
  FButtonItems.Assign(Value);
end;

procedure TBisMdiButtonGroup.SeTBisMdiGrpButtonOptions(const Value: TBisMdiGrpButtonOptions);
begin
  if FButtonOptions <> Value then
  begin
    FButtonOptions := Value;
    if not (gboGroupStyle in FButtonOptions) then
      FItemIndex := -1;
    if HandleAllocated then
    begin
      Resize;
      UpdateAllButtons;
    end;
  end;
end;

procedure TBisMdiButtonGroup.SetButtonWidth(const Value: Integer);
begin
  if (FButtonWidth <> Value) and (Value > 0) then
  begin
    FButtonWidth := Value;
    UpdateAllButtons;
  end;
end;

procedure TBisMdiButtonGroup.SetImages(const Value: TCustomImageList);
begin
  if Images <> Value then
  begin
    if Images <> nil then
      Images.UnRegisterChanges(FImageChangeLink);
    FImages := Value;
    if Images <> nil then
    begin
      Images.RegisterChanges(FImageChangeLink);
      Images.FreeNotification(Self);
   end;
   UpdateAllButtons;
  end;
end;

procedure TBisMdiButtonGroup.SetItemIndex(const Value: Integer);
var
  OldIndex: Integer;
begin
  if (FItemIndex <> Value) and (gboGroupStyle in ButtonOptions) then
  begin
    OldIndex := FItemIndex;
    { Assign the index before painting }
    FItemIndex := Value;
    FFocusIndex := Value; { Assign it to the focus item too }
    UpdateButton(OldIndex);

    UpdateButton(FItemIndex);
  end;
end;

procedure TBisMdiButtonGroup.SetMdiClientHandle(const Value: THandle);
begin
  if FMdiClientHandle<>Value then begin

    if FMdiClientHandle <> 0 then
      SetWindowLong(FMdiClientHandle,GWL_WNDPROC,LongInt(FDefMdiClientProc));

    FMdiClientHandle:=Value;

    if FMdiClientHandle<>0 then begin
      FDefMdiClientProc:=Pointer(GetWindowLong(FMdiClientHandle,GWL_WNDPROC));
      SetWindowLong(FMdiClientHandle,GWL_WNDPROC,Longint(FMdiClientInstance));
    end;
  end;
end;

const
  cScrollBarKind = SB_VERT;

procedure TBisMdiButtonGroup.ShowScrollBar(const Visible: Boolean);
begin
  if Visible <> FScrollBarShown then
  begin
    FScrollBarShown := Visible;
    Windows.ShowScrollBar(Handle, cScrollBarKind, Visible);
  end;
end;

procedure TBisMdiButtonGroup.UpdateAllButtons;
begin
  Invalidate;
end;

procedure TBisMdiButtonGroup.UpdateButton(const Index: Integer);
var
  R: TRect;
begin
  { Just invalidate one button's rect }
  if Index >= 0 then
  begin
    R := GetButtonRect(Index);
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TBisMdiButtonGroup.WMHScroll(var Message: TWMHScroll);
begin
  with Message do
    ScrollPosChanged(TScrollCode(ScrollCode), Pos);
end;

procedure TBisMdiButtonGroup.WMVScroll(var Message: TWMVScroll);
begin
  with Message do
    ScrollPosChanged(TScrollCode(ScrollCode), Pos);
end;

procedure TBisMdiButtonGroup.ScrollPosChanged(ScrollCode: TScrollCode;
  ScrollPos: Integer);
var
  OldPos: Integer;
begin
  OldPos := FHiddenItems;
  if (ScrollCode = scLineUp) and (FHiddenItems > 0) then
    Dec(FHiddenItems)
  else if (ScrollCode = scLineDown) and (FHiddenItems < FScrollBarMax) then
    Inc(FHiddenItems)
  else if (ScrollCode = scPageUp) then
  begin
    Dec(FHiddenItems, FPageAmount);
    if FHiddenItems < 0 then
      FHiddenItems := 0;
  end
  else if ScrollCode = scPageDown then
  begin
    Inc(FHiddenItems, FPageAmount);
    if FHiddenItems > FScrollBarMax then
      FHiddenItems := FScrollBarMax;
  end
  else if ScrollCode in [scPosition, scTrack] then
    FHiddenItems := ScrollPos
  else if ScrollCode = scTop then
    FHiddenItems := 0
  else if ScrollCode = scBottom then
    FHiddenItems := FScrollBarMax;                         
  if OldPos <> FHiddenItems then
  begin
    SetScrollPos(Handle, cScrollBarKind, FHiddenItems, True);
    Invalidate;
  end;
end;

procedure TBisMdiButtonGroup.DoFillRect(const Rect: TRect; Empty: Boolean=false);
begin
  if ParentBackground and ThemeServices.ThemesEnabled then
    ThemeServices.DrawParentBackground(Handle, Canvas.Handle, nil, False, @Rect)
  else begin
    if FDrawingStyle=dsNormal then
      Canvas.FillRect(Rect)
    else
      GradientFillCanvas(Canvas,FGradientStartColor,FGradientEndColor,Rect,gdVertical);
  end;
end;

procedure TBisMdiButtonGroup.DrawButton(Index: Integer; Canvas: TCanvas;
  Rect: TRect; State: TButtonDrawState);
var
  TextLeft, TextTop: Integer;
  RectHeight: Integer;
  ImgTop: Integer;
  TextOffset: Integer;
  ButtonItem: TBisMdiGrpButtonItem;
  FillColor: TColor;
  EdgeColor: TColor;
  InsertIndication: TRect;
  TextRect: TRect;
  OrgRect: TRect;
  Text: string;
begin
  if Assigned(FOnDrawButton) and (not (csDesigning in ComponentState)) then
    FOnDrawButton(Self, Index, Canvas, Rect, State)
  else
  begin
    OrgRect := Rect;

    Canvas.Font := Font;
    if bdsSelected in State then
    begin
      Canvas.Brush.Color := GetShadowColor(FHotTrackColor, -25);
      Canvas.Font.Color := clBtnText;
    end
    else if bdsDown in State then
    begin
      Canvas.Brush.Color := GetShadowColor(FHotTrackColor, -25);
      Canvas.Font.Color := clBtnText;
    end
    else if bdsHot in State then
    begin
      Canvas.Brush.Color := FHotTrackColor;
      Canvas.Font.Color := clBtnText;
    end
    else
    begin
      Canvas.Brush.Color := clBtnFace;
      Canvas.Font.Color := clBtnText;
    end;

    if Assigned(FOnBeforeDrawButton) then
      FOnBeforeDrawButton(Self, Index, Canvas, Rect, State);

    FillColor := Canvas.Brush.Color;
    EdgeColor := GetShadowColor(FillColor, -25);
    Canvas.FillRect(Rect);

   { if FDrawingStyle=dsNormal then
      InflateRect(Rect, -2, -1); }

    if (bdsHot in State) or (bdsDown in State) or (bdsSelected in State) then  begin
      EdgeColor := GetShadowColor(EdgeColor, -50);

      { Draw the edge outline }
      Canvas.Brush.Color := EdgeColor;
      Canvas.FrameRect(Rect);
      Canvas.Brush.Color := FillColor;
    end else begin
      if FDrawingStyle=dsGradient then
        GradientFillCanvas(Canvas,FGradientStartColor,FGradientEndColor,Rect,gdVertical);
    end;

    { Compute the text location }
    TextLeft := Rect.Left + 4;
    RectHeight := Rect.Bottom - Rect.Top;
     TextTop := Rect.Top + (RectHeight - Canvas.TextHeight('Wg')) div 2; { Do not localize } 
    if TextTop < Rect.Top then
      TextTop := Rect.Top;

    if FDrawingStyle=dsNormal then
      if bdsDown in State then
      begin
        Inc(TextTop);
        Inc(TextLeft);
      end;

    ButtonItem := FButtonItems[Index];
    { Draw the icon - prefer the event }
    TextOffset := FMargin;
    if Assigned(FOnDrawIcon) then
      FOnDrawIcon(Self, Index, Canvas, OrgRect, State, TextOffset)
    else if (FImages <> nil) and (ButtonItem.ImageIndex > -1) and
        (ButtonItem.ImageIndex < FImages.Count) then
    begin
      ImgTop := Rect.Top + (RectHeight - FImages.Height) div 2;
      if ImgTop < Rect.Top then
        ImgTop := Rect.Top;

      if FDrawingStyle=dsNormal then
        if bdsDown in State then
          Inc(ImgTop);

      FImages.Draw(Canvas, TextLeft - 1, ImgTop, ButtonItem.ImageIndex);
      TextOffset := FImages.Width + 1;
    end;

    { Show insert indications }
    if [bdsInsertLeft, bdsInsertTop, bdsInsertRight, bdsInsertBottom] * State <> [] then
    begin
      Canvas.Brush.Color := GetShadowColor(EdgeColor);
      InsertIndication := Rect;
      if bdsInsertLeft in State then
      begin
        Dec(InsertIndication.Left, 2);
        InsertIndication.Right := InsertIndication.Left + 2;
      end
      else if bdsInsertTop in State then
      begin
        Dec(InsertIndication.Top);
        InsertIndication.Bottom := InsertIndication.Top + 2;
      end
      else if bdsInsertRight in State then
      begin
        Inc(InsertIndication.Right, 2);
        InsertIndication.Left := InsertIndication.Right - 2;
      end
      else if bdsInsertBottom in State then
      begin
        Inc(InsertIndication.Bottom);
        InsertIndication.Top := InsertIndication.Bottom - 2;
      end;
      Canvas.FillRect(InsertIndication);
      Canvas.Brush.Color := FillColor;
    end;

    if gboShowCaptions in FButtonOptions then
    begin
      { Avoid clipping the image }
      Inc(TextLeft, TextOffset);
      TextRect.Left := TextLeft;
      TextRect.Right := Rect.Right - Integer(FMargin);
      TextRect.Top := TextTop;
      TextRect.Bottom := Rect.Bottom -1;
      Text := ButtonItem.Caption;
      Canvas.Brush.Style:=bsClear;
      Canvas.TextRect(TextRect, Text, [tfEndEllipsis]);
      Canvas.Brush.Style:=bsSolid;
    end;

  (*  if bdsFocused in State then
    begin
      { Draw the focus rect }
      InflateRect(Rect, -2, -2);
      Canvas.DrawFocusRect(Rect);
    end; *)

    if Assigned(FOnAfterDrawButton) then
      FOnAfterDrawButton(Self, Index, Canvas, OrgRect, State);
  end;
  Canvas.Brush.Color := Color; { Restore the original color }
end;

procedure TBisMdiButtonGroup.SetOnDrawButton(const Value: TBisMdiGrpButtonDrawEvent);
begin
  FOnDrawButton := Value;
  Invalidate;
end;

procedure TBisMdiButtonGroup.SetOnDrawIcon(const Value: TBisMdiGrpButtonDrawIconEvent);
begin
  FOnDrawIcon := Value;
  Invalidate;
end;

procedure TBisMdiButtonGroup.CreateHandle;
begin
  inherited CreateHandle;
  { Make sure that we are showing the scroll bars, if needed }
  Resize;
end;

procedure TBisMdiButtonGroup.WMMouseLeave(var Message: TMessage);
begin
  FMouseInControl := False;
  if FHotIndex <> -1 then
  begin
    UpdateButton(FHotIndex);
    FHotIndex := -1;
    DoHotButton;
  end;
  if FDragImageList.Dragging then
  begin
    FDragImageList.HideDragImage;
    RemoveInsertionPoints;
    UpdateWindow(Handle);
    FDragImageList.ShowDragImage;
  end;
end;

procedure TBisMdiButtonGroup.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
  begin
    { Focus ourselves, when clicked, like a button would }
    if not Focused then
      Windows.SetFocus(Handle);

    FDragStarted := False;
    FDownIndex := IndexOfButtonAt(X, Y);
    if FDownIndex <> -1 then
    begin
      if gboAllowReorder in ButtonOptions then
        FDragIndex := FDownIndex;
      FDragStartPos := Point(X, Y);
      { If it is the same as the selected, don't do anything }
      if FDownIndex <> FItemIndex then
        UpdateButton(FDownIndex)
      else
        FDownIndex := -1;
    end;
  end;
end;

procedure TBisMdiButtonGroup.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewHotIndex, OldHotIndex: Integer;
  EventTrack: TTrackMouseEvent;
  DragThreshold: Integer;
begin
  inherited;
  { Was the drag threshold met? }
  if (gboAllowReorder in ButtonOptions) and (FDragIndex <> -1) then
  begin
    DragThreshold := Mouse.DragThreshold;
    if (Abs(FDragStartPos.X - X) >= DragThreshold) or
        (Abs(FDragStartPos.Y - Y) >= DragThreshold) then
    begin
      FDragStartPos.X := X; { Used in the start of the drag }
      FDragStartPos.Y := Y;
      FDownIndex := -1; { Stops repaints and clicks }
      if FHotIndex <> -1 then
      begin
        OldHotIndex := FHotIndex;
        FHotIndex := -1;
        UpdateButton(OldHotIndex);
        { We must have the window process the paint message before
          the drag operation starts }
        UpdateWindow(Handle);
        DoHotButton;
      end;
      FDragStarted := True;
      BeginDrag(True, -1);
      Exit;
    end;
  end;

  NewHotIndex := IndexOfButtonAt(X, Y);
  if NewHotIndex <> FHotIndex then
  begin
    OldHotIndex := FHotIndex;
    FHotIndex := NewHotIndex;
    UpdateButton(OldHotIndex);
    if FHotIndex <> -1 then
      UpdateButton(FHotIndex);
    DoHotButton;
  end;
  if not FMouseInControl then
  begin
    FMouseInControl := True;
    EventTrack.cbSize := SizeOf(TTrackMouseEvent);
    EventTrack.dwFlags := TME_LEAVE;
    EventTrack.hwndTrack := Handle;
    EventTrack.dwHoverTime := 0;
    TrackMouseEvent(EventTrack);
  end;
end;

procedure TBisMdiButtonGroup.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  LastDown: Integer;
begin
  inherited;
  if (Button = mbLeft) and (not FDragStarted) then
  begin
    LastDown := FDownIndex;
    FDownIndex := -1;
    FDragIndex := -1;
    if (LastDown <> -1) and (IndexOfButtonAt(X, Y) = LastDown)
      and (FDragIndex = -1) then
    begin
      UpdateButton(LastDown);
      DoItemClicked(LastDown);
      if gboGroupStyle in ButtonOptions then
        ItemIndex := LastDown;
    end
    else if LastDown <> -1 then
      UpdateButton(LastDown);
    if Assigned(FOnClick) then
      FOnClick(Self);
  end;
  FDragStarted := False;
end;

function TBisMdiButtonGroup.IndexOfButtonAt(const X, Y: Integer): Integer;
var
  ButtonsPerRow: Integer;
  HiddenCount: Integer;
  Row, Col: Integer;
begin
  Result := -1;
  { Is it within our X and Y bounds first? }
  if (X >= 0) and (X < Width) and (Y >= 0) and (Y < Height) then
  begin
    ButtonsPerRow := CalcButtonsPerRow;
    HiddenCount := FHiddenItems*ButtonsPerRow;
    Row := Y div FButtonHeight;
    if gboFullSize in FButtonOptions then
      Col := 0
    else
      Col := X div FButtonWidth;

    Result := HiddenCount + Row*ButtonsPerRow + Col;
    if Result >= FButtonItems.Count then
      Result := -1
    else if (Row+1)*FButtonHeight > Height then
      Result := -1; { Item is clipped }
  end;
end;

function TBisMdiButtonGroup.IsGradientEndColorStored: Boolean;
begin
  Result := FGradientEndColor <> GetShadowColor(clBtnFace, -25);
end;

procedure TBisMdiButtonGroup.DoItemClicked(const Index: Integer);
begin
  if Assigned(FButtonItems[Index].OnClick) then
    FButtonItems[Index].OnClick(Self)
  else if Assigned(FOnButtonClicked) then
    FOnButtonClicked(Self, Index)
  else if Assigned(Items[Index].Form) then begin
    FActivating:=true;
    try
      with Items[Index].Form do begin
        if Visible and HandleAllocated then begin
          if (WindowState=wsMinimized) then begin
            ShowWindow(Handle,SW_SHOW);
            ShowWindow(Handle,SW_RESTORE);
          end;
          BringToFront;
        end;
      end;
    finally
      FActivating:=false;
    end;
  end;
end;

procedure TBisMdiButtonGroup.DragDrop(Source: TObject; X, Y: Integer);
var
  TargetIndex: Integer;
begin
  if (Source = Self) and (gboAllowReorder in ButtonOptions) then
  begin
    RemoveInsertionPoints;
    TargetIndex := TargetIndexAt(X, Y);
    if TargetIndex > FDragIndex then
      Dec(TargetIndex); { Account for moving ourselves }
    if TargetIndex <> -1 then
      DoReorderButton(FDragIndex, TargetIndex);
    FDragIndex := -1;
  end
  else
    inherited;
end;

const
  cScrollBuffer = 6;

procedure TBisMdiButtonGroup.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  OverIndex: Integer;
begin
  if (Source = Self) and (gboAllowReorder in ButtonOptions) then
  begin
    { If the mouse is within the bottom cScrollBuffer pixels,
      then "auto-scroll" }
    if (FHiddenItems < FScrollBarMax) and (Y <= Height) and
         (Y >= Height - cScrollBuffer) and (X >= 0) and (X <= Width) then
      AutoScroll(scLineDown)
    else if (FHiddenItems > 0) and (Y >= 0) and
         (Y <= cScrollBuffer) and (X >= 0) and (X <= Width) then
      AutoScroll(scLineUp);

    OverIndex := TargetIndexAt(X, Y);
    { Don't accept when it is the same as the start or right after us }
    Accept := (OverIndex <> -1) and (OverIndex <> FDragIndex) and
      (OverIndex <> FDragIndex + 1) and (Items.Count > 1);
    FDragImageList.HideDragImage;
    if Accept and (State <> dsDragLeave) then
      SetInsertionPoints(OverIndex)
    else
      RemoveInsertionPoints;
    UpdateWindow(Handle);
    FDragImageList.ShowDragImage;
  end
  else
    inherited DragOver(Source, X, Y, State, Accept);
end;

procedure TBisMdiButtonGroup.DoHotButton;
begin
  if Assigned(FOnHotButton) then
    FOnHotButton(Self, FHotIndex);
end;

procedure TBisMdiButtonGroup.DoStartDrag(var DragObject: TDragObject);
var
  ButtonRect: TRect;
  State: TButtonDrawState;
  DragImage: TBitmap;
begin
  inherited DoStartDrag(DragObject);
  if FDragIndex <> -1 then
  begin
    DragImage := TBitmap.Create;
    try
      ButtonRect := GetButtonRect(FDragIndex);
      DragImage.Width := ButtonRect.Right - ButtonRect.Left;
      DragImage.Height := ButtonRect.Bottom - ButtonRect.Top;
      State := [bdsDragged];
      if FItemIndex = FDragIndex then
        State := State + [bdsSelected];
      DrawButton(FDragIndex, DragImage.Canvas,
        Rect(0, 0, DragImage.Width, DragImage.Height), State);
      FDragImageList.Clear;
      FDragImageList.Width := DragImage.Width;
      FDragImageList.Height := DragImage.Height;
      FDragImageList.Add(DragImage, nil);
      with FDragImageList.DragHotspot do
      begin
        X := FDragStartPos.X - ButtonRect.Left - Mouse.DragThreshold;
        Y := FDragStartPos.Y - ButtonRect.Top - Mouse.DragThreshold;
      end;
    finally
      DragImage.Free;
    end;
  end
  else
    FDragImageList.Clear; { No drag image } 
end;

function TBisMdiButtonGroup.GetDragImages: TDragImageList;
begin
  Result := FDragImageList;
end;

procedure TBisMdiButtonGroup.RemoveInsertionPoints;
  procedure ClearSelection(var Index: Integer);
  var
    OldIndex: Integer;
  begin
    if Index <> -1 then
    begin
      OldIndex := Index;
      Index := -1;
      UpdateButton(OldIndex);
    end;
  end;

begin
  ClearSelection(FInsertTop);
  ClearSelection(FInsertLeft);
  ClearSelection(FInsertRight);
  ClearSelection(FInsertBottom);
end;

procedure TBisMdiButtonGroup.DoReorderButton(const OldIndex, NewIndex: Integer);
var
  OldIndexID: Integer;
begin
  FIgnoreUpdate := True;
  try
    if FItemIndex <> -1 then
      OldIndexID := Items[FItemIndex].ID
    else
      OldIndexID := -1;
    FButtonItems.Items[OldIndex].Index := NewIndex;
    if OldIndexID <> -1 then
      FItemIndex := Items.FindItemID(OldIndexID).Index;
  finally
    FIgnoreUpdate := False;
  end;
  Invalidate;
  if Assigned(FOnReorderButton) then
    FOnReorderButton(Self, OldIndex, NewIndex);
end;

procedure TBisMdiButtonGroup.AutoScroll(ScrollCode: TScrollCode);

  function ShouldContinue(out Delay: Integer): Boolean;
  const
    cMaxDelay = 500;
  begin
    { Are we autoscrolling up or down? }
    if ScrollCode = scLineDown then
    begin
      Result := FHiddenItems < FScrollBarMax;
      if Result then
      begin
        { Is the mouse still in position? }
        with ScreenToClient(Mouse.CursorPos) do
        begin
          if (X < 0) or (X > Width) or
             (Y > Height) or (Y < Height - cScrollBuffer) then
            Result := False
          else if Y < (Height - cScrollBuffer div 2) then
            Delay := cMaxDelay
          else
            Delay := cMaxDelay div 2; { A little faster }
        end
      end;
    end
    else
    begin
      Result := FHiddenItems > 0;
      if Result then
      begin
        with ScreenToClient(Mouse.CursorPos) do
          if (X < 0) or (X > Width) or
             (Y < 0) or (Y > cScrollBuffer) then
            Result := False
        else if Y > (cScrollBuffer div 2) then
          Delay := cMaxDelay
        else
          Delay := cMaxDelay div 2;
      end;
    end;
  end;
var
  CurrentTime, StartTime, ElapsedTime: Longint;
  Delay: Integer;
begin
  FDragImageList.HideDragImage;
  RemoveInsertionPoints;
  FDragImageList.ShowDragImage;

  CurrentTime := 0;
  while (ShouldContinue(Delay)) do
  begin
    StartTime := GetCurrentTime;
    ElapsedTime := StartTime - CurrentTime;
    if ElapsedTime < Delay then
      Sleep(Delay - ElapsedTime);
    CurrentTime := StartTime;

    FDragImageList.HideDragImage;
    ScrollPosChanged(ScrollCode, 0{ Ignored});
    UpdateWindow(Handle);
    FDragImageList.ShowDragImage;
  end;
end;

function TBisMdiButtonGroup.TargetIndexAt(const X, Y: Integer): Integer;
var
  ButtonRect: TRect;
  LastRect: TRect;
begin
  Result := IndexOfButtonAt(X, Y);
  if Result = -1 then
  begin
    LastRect := GetButtonRect(Items.Count);
    if (Y >= LastRect.Bottom) then
      Result := Items.Count
    else if (Y >= LastRect.Top) then
      if (gboFullSize in FButtonOptions) or (X >= LastRect.Left) then
        Result := Items.Count; { After the last item }
  end;
  if (Result > -1) and (Result < Items.Count) then
  begin
    { Before the index, or after it? }
    ButtonRect := GetButtonRect(Result);
    if CalcButtonsPerRow = 1 then
    begin
      if Y > (ButtonRect.Top + (ButtonRect.Bottom - ButtonRect.Top) div 2) then
        Inc(Result); { Insert above the item below it (after the index) }
    end
    else
      if X > (ButtonRect.Left + (ButtonRect.Right - ButtonRect.Left) div 2) then
        Inc(Result)
  end;
end;

procedure TBisMdiButtonGroup.CNKeydown(var Message: TWMKeyDown);
var
  IncAmount: Integer;

  procedure FixIncAmount(const StartValue: Integer);
  begin
    { Keep it within the bounds }
    if StartValue + IncAmount >= FButtonItems.Count then
      IncAmount := FButtonItems.Count - StartValue - 1
    else if StartValue + IncAmount < 0 then
      IncAmount := 0 - StartValue; 
  end;

var
  NewIndex: Integer;

begin
  IncAmount := 0;
  if Message.CharCode = VK_DOWN then
    IncAmount := CalcButtonsPerRow
  else if Message.CharCode = VK_UP then
    IncAmount := -1*CalcButtonsPerRow
  else if Message.CharCode = VK_LEFT then
    IncAmount := -1
  else if Message.CharCode = VK_RIGHT then
    IncAmount := 1
  else if Message.CharCode = VK_NEXT then
    IncAmount := CalcRowsSeen
  else if Message.CharCode = VK_PRIOR then
    IncAmount := -1*CalcRowsSeen
  else if Message.CharCode = VK_HOME then
  begin
    if gboGroupStyle in ButtonOptions then
      IncAmount := -1*FItemIndex
    else
      IncAmount := -1*FFocusIndex;
  end
  else if Message.CharCode = VK_END then
  begin
    if gboGroupStyle in ButtonOptions then
      IncAmount := FButtonItems.Count - FItemIndex
    else
      IncAmount := FButtonItems.Count - FFocusIndex;
  end
  else if (Message.CharCode = VK_RETURN) or (Message.CharCode = VK_SPACE) then
  begin
    if (gboGroupStyle in ButtonOptions) and (FItemIndex <> -1) then
      DoItemClicked(FItemIndex) { Click the current item index }
    else if (gboGroupStyle in ButtonOptions) and
        (FFocusIndex >= 0) and (FFocusIndex < FButtonItems.Count) then
      DoItemClicked(FFocusIndex) { Click the focused index }
    else
      inherited;
  end
  else
    inherited;

  if IncAmount <> 0 then
  begin
    if gboGroupStyle in ButtonOptions then
      FixIncAmount(FItemIndex)
    else
      FixIncAmount(FFocusIndex);
    if IncAmount <> 0 then
    begin
      { Do the actual scrolling work }
      if gboGroupStyle in ButtonOptions then
      begin
        NewIndex := ItemIndex + IncAmount;
        ScrollIntoView(NewIndex);
        ItemIndex := NewIndex;
      end
      else
      begin
        NewIndex := FFocusIndex+ IncAmount;
        ScrollIntoView(NewIndex);
        UpdateButton(FFocusIndex);
        FFocusIndex := NewIndex;
        UpdateButton(FFocusIndex);
      end;
    end;
  end;
end;

procedure TBisMdiButtonGroup.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  UpdateButton(FFocusIndex)
end;

procedure TBisMdiButtonGroup.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if (FFocusIndex = -1) and (FButtonItems.Count > 0)  then
    FFocusIndex := 0; { Focus the first item }
  UpdateButton(FFocusIndex)
end;

procedure TBisMdiButtonGroup.ScrollIntoView(const Index: Integer);
var
  RowsSeen, ButtonsPerRow, HiddenCount, VisibleCount: Integer;
begin
  if (Index >= 0) and (Index < FButtonItems.Count) then
  begin
    ButtonsPerRow := CalcButtonsPerRow;
    HiddenCount := FHiddenItems*ButtonsPerRow;
    if Index < HiddenCount then
    begin
      { We have to scroll above to get the item insight }
      while (Index <= HiddenCount) and (FHiddenItems > 0) do
      begin
        ScrollPosChanged(scLineUp, 0);
        HiddenCount := FHiddenItems*ButtonsPerRow;
      end;
    end
    else
    begin
      RowsSeen := CalcRowsSeen;
      VisibleCount := RowsSeen*ButtonsPerRow;
      { Do we have to scroll down to see the item? }
      while Index >= (HiddenCount + VisibleCount) do
      begin
        ScrollPosChanged(scLineDown, 0);
        HiddenCount := FHiddenItems*ButtonsPerRow;
      end;
    end;
  end;
end;

procedure TBisMdiButtonGroup.CMHintShow(var Message: TCMHintShow);
var
  ItemIndex: Integer;
begin
  Message.Result := 1; { Don't show the hint }
  if Message.HintInfo.HintControl = Self then
  begin
    ItemIndex := IndexOfButtonAt(Message.HintInfo.CursorPos.X, Message.HintInfo.CursorPos.Y);
    if (ItemIndex >= 0) and (ItemIndex < Items.Count) then
    begin
      { Only show the hint if the item's text is truncated }
      if Items[ItemIndex].Hint <> '' then
        Message.HintInfo.HintStr := Items[ItemIndex].Hint
      else
      begin
        // corbin - finish..
      //  Canvas.TextRect(TextRect, Items[ItemIndex].Caption, [tfEndEllipsis]);
        Message.HintInfo.HintStr := Items[ItemIndex].Caption;
      end;
      if (Items[ItemIndex].ActionLink <> nil) then
        Items[ItemIndex].ActionLink.DoShowHint(Message.HintInfo.HintStr);
      Message.HintInfo.CursorRect := GetButtonRect(ItemIndex);
      Message.Result := 0; { Show the hint }
    end;
  end;
end;

procedure TBisMdiButtonGroup.Assign(Source: TPersistent);
begin
  if Source is TBisMdiButtonGroup then
  begin
    Items := TBisMdiButtonGroup(Source).Items;
    ButtonHeight := TBisMdiButtonGroup(Source).ButtonHeight;
    ButtonWidth := TBisMdiButtonGroup(Source).ButtonWidth;
    ButtonOptions := TBisMdiButtonGroup(Source).ButtonOptions;
  end
  else
    inherited;
end;

procedure TBisMdiButtonGroup.SetInsertionPoints(const InsertionIndex: Integer);
begin
  if FInsertTop <> InsertionIndex then 
  begin
    RemoveInsertionPoints;

    if CalcButtonsPerRow = 1 then
    begin
      FInsertTop := InsertionIndex;
      FInsertBottom := InsertionIndex - 1;
    end
    else
    begin
      { More than one button per row, so use Left/Right separators }
      FInsertLeft := InsertionIndex;
      FInsertRight := InsertionIndex - 1;
    end;

    UpdateButton(FInsertTop);
    UpdateButton(FInsertLeft);
    UpdateButton(FInsertBottom);
    UpdateButton(FInsertRight);

    UpdateWindow(Handle);
  end;
end;

procedure TBisMdiButtonGroup.DoEndDrag(Target: TObject; X, Y: Integer);
begin
  inherited;
  FDragIndex := -1;
  RemoveInsertionPoints;
end;

procedure TBisMdiButtonGroup.SetDragIndex(const Value: Integer);
begin
  FDragIndex := Value;
  FDragStarted := True;
end;

procedure TBisMdiButtonGroup.SetDrawingStyle(const Value: TBisMdiButtonGroupDrawingStyle);
begin
  FDrawingStyle := Value;
end;

procedure TBisMdiButtonGroup.SetGradientDirection(const Value: TGradientDirection);
begin
  FGradientDirection := Value;
end;

procedure TBisMdiButtonGroup.SetGradientEndColor(const Value: TColor);
begin
  FGradientEndColor := Value;
end;

procedure TBisMdiButtonGroup.SetGradientStartColor(const Value: TColor);
begin
  FGradientStartColor := Value;
end;

function TBisMdiButtonGroup.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
  if not Result then
  begin
    UpdateButton(FHotIndex);
    FHotIndex := -1;
    Result := True;
    if (FScrollBarMax > 0) and (Shift = []) then
      ScrollPosChanged(scLineDown, 0)
    else if (FScrollBarMax > 0) and (ssCtrl in Shift) then
      ScrollPosChanged(scPageDown, 0)
{    else if ssShift in Shift then
    begin
      NextButton := GetNextButton(SelectedItem, True);
      if NextButton <> nil then
        SelectedItem := NextButton;
    end;
    }
  end;
end;

function TBisMdiButtonGroup.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
  if not Result then
  begin
    UpdateButton(FHotIndex);
    FHotIndex := -1;
    Result := True;
    if (FScrollBarMax > 0) and (Shift = []) then
      ScrollPosChanged(scLineUp, 0)
    else if (FScrollBarMax > 0) and (ssCtrl in Shift) then
      ScrollPosChanged(scPageUp, 0)
{    else if ssShift in Shift then
    begin
      NextButton := GetNextButton(SelectedItem, False);
      if NextButton <> nil then
        SelectedItem := NextButton;
    end;
    }
  end;
end;

function TBisMdiButtonGroup.FindItem(Form: TForm): TBisMdiGrpButtonItem;
var
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Items.Count-1 do begin
    if Items[i].Form=Form then begin
      Result:=Items[i];
      exit;
    end;
  end;
end;

procedure TBisMdiButtonGroup.RemoveItem(Form: TForm);
var
  Item: TBisMdiGrpButtonItem;
begin
  Item:=FindItem(Form);
  if Assigned(Item) then
    Items.Delete(Item.Index);
end;

procedure TBisMdiButtonGroup.ActivateItem(Form: TForm);
var
  Item: TBisMdiGrpButtonItem;
begin
  if not FActivating then begin
    FActivating:=true;
    try
      Item:=FindItem(Form);
      if Assigned(Item) then begin
        if ItemIndex<>Item.Index then
          ScrollIntoView(Item.Index);
        ItemIndex:=Item.Index;
      end else
        ItemIndex:=-1;
    finally
      FActivating:=false;
    end;
  end;
end;

function TBisMdiButtonGroup.AddItem(Form: TForm): TBisMdiGrpButtonItem;
var
  FlagAdd: Boolean;
begin
  Result:=nil;
  FlagAdd:=Assigned(Form);
  if FlagAdd and Assigned(FOnCanAdd) then
    FlagAdd:=FOnCanAdd(Self,Form);
  if FlagAdd then begin
    Result:=FindItem(Form);
    if not Assigned(Result) then
      Result:=Items.Add;
    if Assigned(Result) then begin
      Result.Form:=Form;
    end;
  end;
end;

{ TBisMdiGrpButtonItem }

function TBisMdiGrpButtonItem.GetHint: String;
begin
  Result:=inherited Hint;
  if Assigned(FForm) and (FForm.Hint<>'') then
    Result:=FForm.Hint;
end;

function TBisMdiGrpButtonItem.GeTBisMdiButtonGroup: TBisMdiButtonGroup;
begin
  Result := Collection.ButtonGroup;
end;

function TBisMdiGrpButtonItem.GetCaption: TCaption;
begin
  Result:=inherited Caption;
  if Assigned(FForm) and (FForm.Caption<>'') then
    Result:=FForm.Caption;
end;

function TBisMdiGrpButtonItem.GetCollection: TBisMdiGrpButtonItems;
begin
  Result := TBisMdiGrpButtonItems(inherited Collection);
end;

function TBisMdiGrpButtonItem.GetNotifyTarget: TComponent;
begin
  Result := TComponent(ButtonGroup);
end;

procedure TBisMdiGrpButtonItem.ScrollIntoView;
begin
  TBisMdiGrpButtonItems(Collection).FButtonGroup.ScrollIntoView(Index);
end;

procedure TBisMdiGrpButtonItem.SetCollection(const Value: TBisMdiGrpButtonItems);
begin
  inherited Collection := Value;
end;

{ TBisMdiGrpButtonItems }

function TBisMdiGrpButtonItems.Add: TBisMdiGrpButtonItem;
begin
  Result := TBisMdiGrpButtonItem(inherited Add);
end;

function TBisMdiGrpButtonItems.AddItem(Item: TBisMdiGrpButtonItem;
  Index: Integer): TBisMdiGrpButtonItem;
begin
  if (Item = nil) and (FButtonGroup <> nil) then
    Result := FButtonGroup.CreateButton
  else
    Result := Item;
  if Assigned(Result) then
  begin
    Result.Collection := Self;
    if Index < 0 then
      Index := Count - 1;
    Result.Index := Index;
  end;
end;

procedure TBisMdiGrpButtonItems.BeginUpdate;
begin
  if UpdateCount = 0 then
    if FButtonGroup.ItemIndex <> -1 then
      FOriginalID := Items[FButtonGroup.ItemIndex].ID
    else
      FOriginalID := -1;
  inherited;
end;

constructor TBisMdiGrpButtonItems.Create(const ButtonGroup: TBisMdiButtonGroup);
begin
  if ButtonGroup <> nil then
    inherited Create(ButtonGroup.GetButtonClass)
  else
    inherited Create(TBisMdiGrpButtonItem);
  FButtonGroup := ButtonGroup;
  FOriginalID := -1;
end;

function TBisMdiGrpButtonItems.GetItem(Index: Integer): TBisMdiGrpButtonItem;
begin
  Result := TBisMdiGrpButtonItem(inherited GetItem(Index));
end;

function TBisMdiGrpButtonItems.GetOwner: TPersistent;
begin
  Result := FButtonGroup;
end;

function TBisMdiGrpButtonItems.Insert(Index: Integer): TBisMdiGrpButtonItem;
begin
  Result := AddItem(nil, Index);
end;

procedure TBisMdiGrpButtonItems.SetItem(Index: Integer; const Value: TBisMdiGrpButtonItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TBisMdiGrpButtonItems.Update(Item: TCollectionItem);
var
  AItem: TCollectionItem;
begin
  if (UpdateCount = 0) and (not FButtonGroup.FIgnoreUpdate) then
  begin
    if Item <> nil then
      FButtonGroup.UpdateButton(Item.Index)
    else
    begin
      if (FOriginalID <> -1) then
        AItem := FindItemID(FOriginalID)
      else
        AItem := nil;
      if AItem = nil then
      begin
        FButtonGroup.FItemIndex := -1;
        FButtonGroup.FFocusIndex := -1;
      end
      else if gboGroupStyle in FButtonGroup.ButtonOptions then
        FButtonGroup.FItemIndex := AItem.Index;
      FButtonGroup.Resize;
      FButtonGroup.UpdateAllButtons;
    end;
  end;
end;


end.
