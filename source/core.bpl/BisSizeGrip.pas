unit BisSizeGrip;

interface

uses Messages, Windows, Classes, Graphics, Controls;

type

  TBisSizeGripStyle = ( sgsClassic, sgsWinXP );

  TBisSizeGrip = class(TComponent)
  private
    FParent: TWinControl;
    FVisible: boolean;
    FStyle: TBisSizeGripStyle;
    FSizeGripRect: TRect;
    FOldWndProc: TWndMethod;        
    procedure AttachControl;
    procedure DetachControl;
    procedure SetParent(const Value: TWinControl);
    procedure SetVisible(const Value: boolean);
    procedure SetNewStyle(const Value: TBisSizeGripStyle);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure GetGripRect(var Rect: TRect); virtual;
    procedure PaintIt(DC: HDC; const Rect: TRect); virtual;
    procedure NewWndProc(var Msg: TMessage); virtual;
    procedure InvalidateGrip;
    procedure UpdateGrip;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Visible: boolean read FVisible write SetVisible default true;
    property Parent: TWinControl read FParent write SetParent;
    property Style: TBisSizeGripStyle read FStyle write SetNewStyle default sgsClassic;
  end;

implementation

uses UxTheme, Themes;

{ TBisSizeGrip }

{constructor TBisSizeGrip.Create(aOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=[csNoStdEvents, csOpaque, csFixedWidth, csFixedHeight, csParentBackground];
  Anchors:=[akRight, akBottom];
  Cursor:=crSizeNWSE;
  Width:=GetSystemMetrics(SM_CXHSCROLL);
  Constraints.MinWidth:=Width;
  Height:=GetSystemMetrics(SM_CXVSCROLL);
  Constraints.MinHeight:=Height;
  DoubleBuffered:=false;
end;

procedure TBisSizeGrip.CreateParams(var Params: TCreateParams);
var
  R: TRect;
begin
  inherited CreateParams(Params);
  CreateSubClass(Params, 'SCROLLBAR');
  Params.Style := Params.Style or WS_CLIPSIBLINGS or SBS_SIZEGRIP or SBS_SIZEBOXBOTTOMRIGHTALIGN;
  with Params.WindowClass do
    style := style and not (CS_HREDRAW or CS_VREDRAW);
  if Windows.GetClientRect(Params.WndParent, R) then begin
    Params.X := R.Left;
    Params.Y := R.Top;
    Params.Width := R.Right - R.Left;
    Params.Height := R.Bottom - R.Top;
  end;
end;

procedure TBisSizeGrip.CreateWnd;
begin
  inherited CreateWnd;
  if HandleAllocated then
    SendToBack;
end;}

type
  TWinControlAccess = class(TWinControl);

const
  CEmptyRect: TRect = ( Left: 0; Top: 0; Right: 0; Bottom: 0; );

{ TBisSizeGrip }

constructor TBisSizeGrip.Create(AOwner: TComponent);
begin
  inherited;

  FVisible := true;
  FStyle := sgsClassic;

  if Assigned(AOwner) then
    if AOwner.ComponentState * [csLoading, csReading] = [] then
    begin
      // Automatically take the owner as the target control
      if AOwner is TWinControl then
        Parent := TWinControl(AOwner)
      else if AOwner is TControl then
        Parent := TControl(AOwner).Parent;
    end;
end;

destructor TBisSizeGrip.Destroy;
begin
  Parent := nil;
  inherited;
end;

procedure TBisSizeGrip.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if Operation = opRemove then
    if AComponent = FParent then
      Parent := nil;
end;

procedure TBisSizeGrip.InvalidateGrip;
begin
  if (FParent <> nil) and
     (FSizeGripRect.Right > FSizeGripRect.Left) and
     (FSizeGripRect.Bottom > FSizeGripRect.Top) then
    if FParent.HandleAllocated then
      InvalidateRect(FParent.Handle, @FSizeGripRect, TRUE);
end;

procedure TBisSizeGrip.UpdateGrip;
begin
  GetGripRect(FSizeGripRect);
  InvalidateGrip;
end;

procedure TBisSizeGrip.AttachControl;
begin
  if @FOldWndProc = nil then
    if ([csDesigning, csDestroying] * ComponentState = []) and
       (FParent <> nil) and
       FVisible and
       ([csDesigning, csDestroying] * FParent.ComponentState = []) then
    begin
      FOldWndProc := FParent.WindowProc;
      FParent.WindowProc := NewWndProc;
      UpdateGrip;
    end;
end;

procedure TBisSizeGrip.DetachControl;
begin
  if @FOldWndProc <> nil then
  begin
    FParent.WindowProc := FOldWndProc;
    FOldWndProc := nil;

    InvalidateGrip;
    FSizeGripRect := CEmptyRect;
  end;
end;

procedure TBisSizeGrip.SetParent(const Value: TWinControl);
begin
  if Value <> FParent then
  begin
    if FParent <> nil then
      FParent.RemoveFreeNotification(Self);

    DetachControl;
    FParent := Value;
    AttachControl;

    if FParent <> nil then
      FParent.FreeNotification(Self);
  end;
end;

procedure TBisSizeGrip.SetVisible(const Value: boolean);
begin
  if FVisible <> Value then
  begin
    DetachControl;
    FVisible := Value;
    AttachControl;
  end;
end;

procedure TBisSizeGrip.SetNewStyle(const Value: TBisSizeGripStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    InvalidateGrip;
  end;
end;

procedure TBisSizeGrip.NewWndProc(var Msg: TMessage);
var
  pt: TPoint;
  dc: HDC;
begin
  if (not Assigned(FOldWndProc)) or (FParent = nil) then
    exit;

  case Msg.Msg of
    WM_PAINT: begin
      FOldWndProc(Msg);
      if TWMPaint(Msg).DC = 0 then
      begin
        dc := GetDC(FParent.Handle);
        try
          PaintIt(dc, FSizeGripRect);
        finally
          ReleaseDC(FParent.Handle, dc);
        end;
      end
    end;

    WM_NCHITTEST: begin
      with TWMNcHitTest(Msg) do
        pt := FParent.ScreenToClient(Point(XPos, YPos));
      if not PtInRect(FSizeGripRect, pt) then
        FOldWndProc(TMessage(Msg))
      else if Parent.UseRightToLeftScrollBar then
        Msg.Result := HTBOTTOMLEFT
      else
        Msg.Result := HTBOTTOMRIGHT;
    end;

    WM_SIZE: begin
      InvalidateGrip;
      FOldWndProc(Msg);
      UpdateGrip;
    end;

    else
      FOldWndProc(Msg);
  end;
end;

procedure TBisSizeGrip.GetGripRect(var Rect: TRect);
var
  DC: HDC;
  Size, Size2: TSize;
begin
  if Assigned(FParent) and ThemeServices.ThemesEnabled then begin
    Size.cx := GetSystemMetrics(SM_CXVSCROLL);
    Size.cy := GetSystemMetrics(SM_CYHSCROLL);

    DC := GetDC(FParent.Handle);
    try
      if GetThemePartSize(ThemeServices.Theme[teStatus], DC,
                          SP_GRIPPER, 0, nil, TS_TRUE, Size2) = S_OK then
      begin
        if Size2.cx > Size.cx then
          Size.cx := Size2.cx;
        if Size2.cy > Size.cy then
          Size.cy := Size2.cy;
      end;
    finally
      ReleaseDC(Parent.Handle, DC);
    end;

    Rect := Parent.ClientRect;
    if Parent.UseRightToLeftScrollBar then
      Rect.Right := Rect.Left + Size.cx
    else
      Rect.Left := Rect.Right - Size.cx;
    Rect.Top := Rect.Bottom - Size.cy;
  end else begin
    if FParent <> nil then
    begin
      Rect := FParent.ClientRect;
      if Parent.UseRightToLeftScrollBar then
        Rect.Right := Rect.Left + 15
      else
        Rect.Left := Rect.Right - 15;
      Rect.Top := Rect.Bottom - 15;
    end
    else
      Rect := CEmptyRect;
  end;
end;

procedure TBisSizeGrip.PaintIt(DC: HDC; const Rect: TRect);
const
  StartX = 4;
  StartY = 4;
var
  ch, cm, cs: COLORREF;

  procedure Paint3(clr: COLORREF; delta: integer);
  var
    pen, oldpen: HPen;
  begin
    pen := CreatePen(PS_SOLID, 0, clr);
    try
      oldpen := SelectObject(DC, pen);
      try
        MoveToEx(DC, Rect.Right - delta, Rect.Bottom - 1, nil);
        LineTo(DC, Rect.Right, Rect.Bottom - 1 - delta);
        inc(delta, 4);
        MoveToEx(DC, Rect.Right - delta, Rect.Bottom - 1, nil);
        LineTo(DC, Rect.Right, Rect.Bottom - 1 - delta);
        inc(delta, 4);
        MoveToEx(DC, Rect.Right - delta, Rect.Bottom - 1, nil);
        LineTo(DC, Rect.Right, Rect.Bottom - 1 - delta);
      finally
        SelectObject(DC, oldpen);
      end;
    finally
      DeleteObject(pen);
    end;
  end;

  procedure PaintBox(x, y: integer);
  begin
    SetPixel(DC, x,     y,     cs);
    SetPixel(DC, x + 1, y,     cs);
    SetPixel(DC, x,     y + 1, cs);
    SetPixel(DC, x + 1, y + 1, cm);
    SetPixel(DC, x + 2, y + 1, ch);
    SetPixel(DC, x + 1, y + 2, ch);
    SetPixel(DC, x + 2, y + 2, ch);
  end;

  function MixColors(c1, c2: COLORREF): COLORREF;
  begin
    Result := RGB((GetRValue(c1) + GetRValue(c2)) div 2,
                  (GetGValue(c1) + GetGValue(c2)) div 2,
                  (GetBValue(c1) + GetBValue(c2)) div 2);
  end;

begin
  if (not ThemeServices.ThemesEnabled) or
     (DrawThemeBackground(ThemeServices.Theme[teStatus], DC,
                          SP_GRIPPER, 0, Rect, @Rect) <> S_OK) then begin

    ch := ColorToRgb(clBtnHighlight);
    cs := ColorToRgb(clBtnShadow);
    // Original look is cm := cs!
    cm := MixColors(ColorToRgb(TWinControlAccess(FParent).Color), cs);

    case FStyle of
      sgsWinXP: begin
        PaintBox(Rect.Right - StartX,     Rect.Bottom - StartY - 8);
        PaintBox(Rect.Right - StartX - 4, Rect.Bottom - StartY - 4);
        PaintBox(Rect.Right - StartX,     Rect.Bottom - StartY - 4);
        PaintBox(Rect.Right - StartX - 8, Rect.Bottom - StartY);
        PaintBox(Rect.Right - StartX - 4, Rect.Bottom - StartY);
        PaintBox(Rect.Right - StartX,     Rect.Bottom - StartY);
      end;

      else begin
        Paint3(cs, 2);
        Paint3(cm, 3);
        Paint3(ch, 4);
      end;
    end;
  end;  
end;

end.