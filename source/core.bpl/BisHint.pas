unit BisHint;

interface

uses Windows, Classes, Controls, Graphics, stdctrls, Messages;

type

  TBisHint=class;

  TBisHintFillDirection = (fdNone,fdUp,fdDown,fdLeft,fdRight,fdHorzIn,fdHorzOut,fdVertIn,fdVertOut);
  TBisHintWayDirection = (wdHorz,wdVert);

  TBisHintWindow=class(THintWindow)
  private
    FHint: string;
    FHintComponent: TBisHint;
    procedure FillBackGround(Clr1, Clr2: TColor; Dir: TBisHintWayDirection; TwoWay: Boolean);
    function GetHintWidth(AHint: TBisHint; Default: Integer): Integer;
    function GetHintHeight(AHint: TBisHint; Default: Integer): Integer;
    function GetHintText(AHint: TBisHint; Default: string): string;
    function GetRealyCount(AHint: TBisHint): Integer;
  protected
    property HintComponent: TBisHint read FHintComponent write FHintComponent;    
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Paint;override;
    procedure CreateParams(var Params: TCreateParams);override;
    procedure ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer); override;
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override;
  end;

  TBisHintCaption=class(TCollectionItem)
  private
    FCaption: string;
    FBrush: TBrush;
    FFont: TFont;
    FPen: TPen;
    FAlignment: TAlignment;
    FToNewLine: Boolean;
    FWidth: Integer;
    FAutoSize: Boolean;
    procedure SetBrush(Value: TBrush);
    procedure SetFont(Value: TFont);
    procedure SetPen(Value: TPen);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
  published
    property Alignment: TAlignment read FAlignment write FAlignment;
    property AutoSize: Boolean read FAutoSize write FAutoSize;
    property Caption: string read FCaption write FCaption;
    property Brush: TBrush read FBrush write SetBrush;
    property Font: TFont read FFont write SetFont;
    property Pen: TPen read FPen write SetPen;
    property ToNewLine: Boolean read FToNewLine write FToNewLine;
    property Width: Integer read FWidth write FWidth;
  end;
  
  TBisHintCaptions=class(TCollection)
  private
    FHint: TBisHint;
    function GetHintCaption(Index: Integer): TBisHintCaption;
    procedure SetHintCaption(Index: Integer; Value: TBisHintCaption);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TBisHint);
    destructor Destroy; override;
    function  Add: TBisHintCaption;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): TBisHintCaption;
    property Items[Index: Integer]: TBisHintCaption read GetHintCaption write SetHintCaption;
  end;

  TBisHint=class(TComponent)
  private
   FOldWndMethod: TWndMethod;
   FFillDirection: TBisHintFillDirection;
   FEndColor: TColor;
   FStartColor: TColor;
   FBrush: TBrush;
   FFont: TFont;
   FPen: TPen;
   FShadowVisible: Boolean;
   FShadowColor: TColor;
   FShadowWidth: Integer;
   FCaption: TStrings;
   FCaptions: TBisHintCaptions;
   FAlignment: TAlignment;
   FLayout: TTextLayout;
   FControl: TControl;
   FReshowTimeout: Integer;
   FHideTimeout: Integer;
   FLeft: Integer;
   FHintPosX, FHintPosY: Integer;
   FHintRadius: Integer;
   FHintWidth: Integer;

   procedure SetBrush(Value: TBrush);
   procedure SetFont(Value: TFont);
   procedure SetPen(Value: TPen);
   procedure SetCaption(Value: TStrings);
   procedure SetCaptions(Value: TBisHintCaptions);
   procedure SetControl(Value: TControl);

   procedure ControlWindowProc(var Message: TMessage);

  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ActivateHint(Point: TPoint);overload;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

  published
    property Layout: TTextLayout read FLayout write FLayout;
    property Left: Integer read FLeft write FLeft;
    property Alignment: TAlignment read FAlignment write FAlignment;
    property Caption: TStrings read FCaption write SetCaption;
    property Captions: TBisHintCaptions read FCaptions write SetCaptions;
    property Control: TControl read FControl write SetControl;
    property FillDirection: TBisHintFillDirection read FFillDirection write FFillDirection;
    property StartColor: TColor read FStartColor write FStartColor;
    property EndColor: TColor read FEndColor write FEndColor;
    property Brush: TBrush read FBrush write SetBrush;
    property Font: TFont read FFont write SetFont;
    property Pen: TPen read FPen write SetPen;
    property ReshowTimeout: Integer read FReshowTimeout write FReshowTimeout;
    property HideTimeout: Integer read FHideTimeout write FHideTimeout;
    property HintPosX: Integer read FHintPosX write FHintPosX;
    property HintPosY: Integer read FHintPosY write FHintPosY;
    property HintRadius: Integer read FHintRadius write FHintRadius;
    property HintWidth: Integer read FHintWidth write FHintWidth;
    property ShadowVisible: Boolean read FShadowVisible write FShadowVisible;
    property ShadowColor: TColor read FShadowColor write FShadowColor;
    property ShadowWidth: Integer read FShadowWidth write FShadowWidth;

  end;

implementation

uses Forms, SysUtils;

{ TBisHintWindow }

constructor TBisHintWindow.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FHintComponent:=nil;
end;

destructor TBisHintWindow.Destroy;
begin
  inherited Destroy;
end;

procedure TBisHintWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := WS_POPUP OR WS_DISABLED;
end;

procedure TBisHintWindow.ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer); 
begin
  FHint:=AHint;
  FHintComponent:=AData;
  inherited;
end;

function TBisHintWindow.GetHintText(AHint: TBisHint; Default: string): string;
var
  i: Integer;
  hc: TBisHintCaption;
  s: string;
begin
  Result:=Default;
  if AHint=nil then exit;
  if AHint.Captions.Count=0 then begin
    Result:=Trim(AHint.Caption.Text);
  end else begin
    s:='';
    for i:=0 to AHint.Captions.Count-1 do begin
      hc:=AHint.Captions.Items[i];
      if hc.ToNewLine then s:=s+#13;
      s:=s+hc.Caption;
    end;
    Result:=s;
  end;
end;

function TBisHintWindow.GetHintWidth(AHint: TBisHint; Default: Integer): Integer;
var
  AFont: TFont;
  hc: TBisHintCaption;
  mw: Integer;
  s: string;
  i,cw: Integer;
begin
  Result:=Default;
  if AHint=nil then exit;
  AFont:=TFont.Create;
  try
    AFont.Assign(Canvas.Font);
    if AHint.Captions.Count=0 then begin
      Canvas.Font.Assign(AHint.Font);
      mw:=0;
      for i:=0 to AHint.Caption.Count-1 do begin
        cw:=Canvas.TextWidth(AHint.Caption.Strings[i]);
        if cw>mw then mw:=cw;
      end;
      Result:=mw+7;
    end else begin
      mw:=0;
      s:='';
      cw:=0;
      for i:=0 to AHint.Captions.Count-1 do begin
        hc:=AHint.Captions.Items[i];
        Canvas.Font.Assign(hc.Font);
        try
          s:=hc.Caption;
          if hc.ToNewLine then cw:=0;
          if hc.AutoSize then
           cw:=cw+Canvas.TextWidth(s)
          else cw:=cw+hc.Width;
          if cw>mw then mw:=cw;
        finally
          Canvas.Font.Assign(AFont);
        end;
      end;
      Result:=mw+6;
    end;
  finally
    Canvas.Font.Assign(AFont);
    AFont.Free;
  end;
end;

function TBisHintWindow.GetHintHeight(AHint: TBisHint; Default: Integer): Integer;
var
  AFont: TFont;
  mh: Integer;
  i,ch: Integer;
begin  
  Result:=Default;
  if AHint=nil then exit;
  AFont:=TFont.Create;
  try
    AFont.Assign(Canvas.Font);
    if AHint.Captions.Count=0 then begin
      Canvas.Font.Assign(AHint.Font);
      mh:=0;
      for i:=0 to AHint.Caption.Count-1 do begin
        ch:=Canvas.TextHeight(AHint.Caption.Strings[i]);
        mh:=ch+mh;
      end;
      Result:=mh+1;
    end else begin
{      mw:=0;
      s:='';
      cw:=0;
      for i:=0 to AHint.Captions.Count-1 do begin
        hc:=AHint.Captions.Items[i];
        Canvas.Font.Assign(hc.Font);
        try
          s:=hc.Caption;
          if hc.ToNewLine then cw:=0;
          if hc.AutoSize then
           cw:=cw+Canvas.TextWidth(s)
          else cw:=cw+hc.Width;
          if cw>mw then mw:=cw;
        finally
          Canvas.Font.Assign(AFont);
        end;
      end;
      Result:=mw+6;}
    end;
  finally
    Canvas.Font.Assign(AFont);
    AFont.Free;
  end;
end;

function TBisHintWindow.CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect;
begin
  if AData=nil then begin
    Result:=inherited CalcHintRect(MaxWidth,AHint,AData);
  end else begin
    Result:=inherited CalcHintRect(MaxWidth,GetHintText(TBisHint(AData),AHint),AData);
    Result.Right:=GetHintWidth(TBisHint(AData),Result.Right);
    Result.Bottom:=GetHintHeight(TBisHint(AData),Result.Bottom);
  end;
end;

function TBisHintWindow.GetRealyCount(AHint: TBisHint): Integer;
var
  i: Integer;
begin
  Result:=0;
  if AHint.Captions.Count>0 then Inc(Result);
  for i:=0 to AHint.Captions.Count-1 do begin
    if AHint.Captions.Items[i].ToNewLine then Inc(Result);
  end;
end;

procedure TBisHintWindow.Paint;
var
  OldBrush: TBrush;
  OldFont: TFont;
  OldPen: TPen;
  rt: TRect;
  i: Integer;
  s: string;
  h,w: Integer;
  x,y,ys,xs: Integer;

  hc: TBisHintCaption;
  RealyY,RealyCount: Integer;
  LastW: Integer;
begin
  rt:=GetClientRect;
  if FHintComponent<>nil then begin

    OldBrush:=TBrush.Create;
    OldFont:=TFont.Create;
    OldPen:=TPen.Create;
    OldBrush.Assign(Canvas.Brush);
    OldFont.Assign(Canvas.Font);
    OldPen.Assign(Canvas.Pen);
    try

      Canvas.Brush.Assign(FHintComponent.Brush);
      Canvas.Font.Assign(FHintComponent.Font);
      Canvas.Pen.Assign(FHintComponent.Pen);


      with FHintComponent do begin
       // PaintBounds;
        case FillDirection of
          fdNone: begin
            Canvas.FillRect(rt);
          end;
          fdUp: FillBackGround(StartColor, EndColor, wdHorz, False);
          fdDown: FillBackGround(EndColor, StartColor, wdHorz, False);
          fdLeft: FillBackGround(StartColor, EndColor, wdVert, False);
          fdRight: FillBackGround(EndColor, StartColor, wdVert, False);
          fdHorzOut: FillBackGround(StartColor, EndColor, wdHorz, True);
          fdHorzIn: FillBackGround(EndColor, StartColor, wdHorz, True);
          fdVertIn: FillBackGround(StartColor, EndColor, wdVert, True);
        else
          FillBackGround(EndColor, StartColor, wdVert, True);
        end;

      end;

      h:=rt.Bottom-rt.Top;
      w:=rt.Right-rt.Left;

      if FHintComponent.Captions.Count=0 then begin

        Canvas.Brush.Assign(FHintComponent.Brush);
        Canvas.Font.Assign(FHintComponent.Font);
        Canvas.Pen.Assign(FHintComponent.Pen);

        for i:=0 to FHintComponent.Caption.Count-1 do begin
          s:=FHintComponent.Caption.Strings[i];
          x:=0;
          y:=0;
          ys:=2;
          xs:=3;
          case FHintComponent.Alignment of
            taLeftJustify: x:=xs;
            taRightJustify: x:=w-Canvas.TextWidth(s)-xs-1;
            taCenter: x:=w div 2 - Canvas.TextWidth(s) div 2;
          end;
          case FHintComponent.Layout of
            tlTop: y:=ys+Canvas.TextHeight(s)*i;
            tlBottom: y:=(h div FHintComponent.Caption.Count)*(i+1)-Canvas.TextHeight(s)-ys;
            tlCenter: y:=(h div FHintComponent.Caption.Count)*i+(h div FHintComponent.Caption.Count) div 2 - Canvas.TextHeight(s) div 2;
          end;
          Canvas.TextOut(x,y,s);
        end;

      end else begin

        x:=2;
        RealyY:=0;
        LastW:=0;
        RealyCount:=GetRealyCount(FHintComponent);
        for i:=0 to FHintComponent.Captions.Count-1 do begin
          hc:=FHintComponent.Captions.Items[i];
          Canvas.Brush.Assign(hc.Brush);
          Canvas.Font.Assign(hc.Font);
          Canvas.Pen.Assign(hc.Pen);
          try
            s:=hc.Caption;
            if hc.ToNewLine then begin
              Inc(RealyY);
              x:=2;
              y:=(h div RealyCount)*RealyY + (h div RealyCount)div 2 - Canvas.TextHeight(hc.Caption) div 2;
            end else begin
              x:=x+LastW;
              y:=(h div RealyCount)*RealyY + (h div RealyCount)div 2 - Canvas.TextHeight(hc.Caption) div 2;
              if hc.AutoSize then
                LastW:=Canvas.TextWidth(s)
              else LastW:=hc.Width;
            end;
           Canvas.TextOut(x,y,s);
          finally
            Canvas.Brush.Assign(FHintComponent.Brush);
            Canvas.Font.Assign(FHintComponent.Font);
            Canvas.Pen.Assign(FHintComponent.Pen);
          end;
        end;

      end;

      Canvas.Brush.Style:=bsClear;
      Canvas.Rectangle(rt);


    finally
     Canvas.Brush.Assign(OldBrush);
     Canvas.Font.Assign(OldFont);
     Canvas.Pen.Assign(OldPen);
     OldBrush.Free;
     OldFont.Free;
     OldPen.Free;
    end;

  end else begin

    inherited Paint;

    Canvas.Brush.Style:=bsSolid;
    Canvas.Brush.Color:=clInfoBk;
    Canvas.FillRect(rt);

    Canvas.Brush.Style:=bsClear;
    Canvas.Font.Color:=clWindowText;
    Canvas.TextOut(3,2,FHint);

    Canvas.Brush.Style:=bsClear;
    Canvas.Pen.Color:=clBlack;
    Canvas.Rectangle(rt);

  end;
end;

procedure TBisHintWindow.FillBackGround(Clr1,Clr2: TColor; Dir: TBisHintWayDirection; TwoWay: Boolean);
var
  RGBFrom   : array[0..2] of Byte;    { from RGB values                     }
  RGBDiff   : array[0..2] of integer; { difference of from/to RGB values    }
  ColorBand : TRect;                  { color band rectangular coordinates  }
  I         : Integer;                { color band index                    }
  R         : Byte;                   { a color band's R value              }
  G         : Byte;                   { a color band's G value              }
  B         : Byte;                   { a color band's B value              }
  Last      : Integer;                { last value in loop }
begin
  { Extract from RGB values}
  RGBFrom[0] := GetRValue(ColorToRGB(Clr1));
  RGBFrom[1] := GetGValue(ColorToRGB(Clr1));
  RGBFrom[2] := GetBValue(ColorToRGB(Clr1));
  { Calculate difference of from and to RGB values}
  RGBDiff[0] := GetRValue(ColorToRGB(Clr2)) - RGBFrom[0];
  RGBDiff[1] := GetGValue(ColorToRGB(Clr2)) - RGBFrom[1];
  RGBDiff[2] := GetBValue(ColorToRGB(Clr2)) - RGBFrom[2];
  { Set pen sytle and mode}
  { Set color band's left and right coordinates }
  if Dir = wdHorz then
    begin
      ColorBand.Left := 0;
      ColorBand.Right := Width;
    end
  else
    begin
      ColorBand.Top := 0;
      ColorBand.Bottom := Height;
    end;
  { Set number of iterations to do }
  if TwoWay then
    Last := $7f
  else
    Last := $ff;
  for I := 0 to Last do begin
    { Calculate color band color}
    R := RGBFrom[0] + MulDiv(I,RGBDiff[0],Last);
    G := RGBFrom[1] + MulDiv(I,RGBDiff[1],Last);
    B := RGBFrom[2] + MulDiv(I,RGBDiff[2],Last);
    { Select brush and paint color band }
    Canvas.Brush.Color := RGB(R,G,B);
    if Dir = wdHorz then
      begin
        { Calculate color band's top and bottom coordinates}
        ColorBand.Top    := MulDiv (I    , Height, $100);
        ColorBand.Bottom := MulDiv (I + 1, Height, $100);
      end
    else
      begin
        { Calculate color band's left and right coordinates}
        ColorBand.Left  := MulDiv (I    , Width, $100);
        ColorBand.Right := MulDiv (I + 1, Width, $100);
      end;
    Canvas.FillRect(ColorBand);
    if TwoWay then begin
      { This is a two way fill, so do the other half }
      if Dir = wdHorz then
        begin
          { Calculate color band's top and bottom coordinates}
          ColorBand.Top    := MulDiv ($ff - I    , Height, $100);
          ColorBand.Bottom := MulDiv ($ff - I + 1, Height, $100);
        end
      else
        begin
          { Calculate color band's left and right coordinates}
          ColorBand.Left  := MulDiv ($ff - I    , Width, $100);
          ColorBand.Right := MulDiv ($ff - I + 1, Width, $100);
        end;
      Canvas.FillRect(ColorBand);
    end;
  end;
end;


{ TBisHintCaption }

constructor TBisHintCaption.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FBrush:=TBrush.Create;
  FBrush.Style:=bsClear;
  FFont:=TFont.Create;
  FPen:=TPen.Create;
  FAutoSize:=true;
end;

destructor TBisHintCaption.Destroy;
begin
  FBrush.Free;
  FFont.Free;
  FPen.Free;
  inherited;
end;

procedure TBisHintCaption.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TBisHintCaption.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TBisHintCaption.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

{ TBisHintCaptions }

constructor TBisHintCaptions.Create(AOwner: TBisHint);
begin
  inherited Create(TBisHintCaption);
  FHint:=AOwner; 
end;

destructor TBisHintCaptions.Destroy;
begin
  inherited;
end;

function TBisHintCaptions.GetHintCaption(Index: Integer): TBisHintCaption;
begin
  Result := TBisHintCaption(inherited Items[Index]);
end;

procedure TBisHintCaptions.SetHintCaption(Index: Integer; Value: TBisHintCaption);
begin
  Items[Index].Assign(Value);
end;

function TBisHintCaptions.GetOwner: TPersistent;
begin
  Result := FHint;
end;

function  TBisHintCaptions.Add: TBisHintCaption;
begin
  Result := TBisHintCaption(inherited Add);
end;

procedure TBisHintCaptions.Assign(Source: TPersistent);
begin
  if Source is TBisHint then begin
  end else
   inherited Assign(Source);
end;

procedure TBisHintCaptions.Clear;
begin
  inherited Clear;
end;

procedure TBisHintCaptions.Delete(Index: Integer);
begin
  Inherited Delete(Index);
end;

function TBisHintCaptions.Insert(Index: Integer): TBisHintCaption;
begin
  Result:=TBisHintCaption(Inherited Insert(Index));
end;

{ TBisHint }

constructor TBisHint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBrush:=TBrush.Create;
  FFont:=TFont.Create;
  FPen:=TPen.Create;
  FStartColor:=clBlue;
  FEndColor:=clBlack;
  FLayout:=tlCenter;
  FCaption:=TStringList.Create;
  FCaptions:=TBisHintCaptions.Create(Self);
  FReshowTimeout:=500;
  FHideTimeout:=500;
  FHintPosX:=-10;
  FHintPosY:=5;
  FShadowColor:=clPurple;
  FShadowVisible:=true;
  FShadowWidth:=6;
  FHintRadius:=9;
  FHintWidth:=100;
end;

destructor TBisHint.Destroy;
begin
  SetControl(nil);
  if Assigned(FCaptions) then
    FreeAndNil(FCaptions);
  if Assigned(FCaptions) then
    FreeAndNil(FCaption);
  if Assigned(FPen) then
    FreeAndNil(FPen);
  if Assigned(FFont) then
    FreeAndNil(FFont);
  if Assigned(FBrush) then
    FreeAndNil(FBrush);
  inherited Destroy;
end;

procedure TBisHint.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TBisHint.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TBisHint.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TBisHint.SetCaption(Value: TStrings);
begin
  FCaption.Assign(Value);
end;

procedure TBisHint.SetCaptions(Value: TBisHintCaptions);
begin
  FCaptions.Assign(Value);
end;

procedure TBisHint.ActivateHint(Point: TPoint);
begin
  Application.ActivateHint(Point);
end;

procedure TBisHint.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FControl) then
    SetControl(nil);
end;

procedure TBisHint.SetControl(Value: TControl);
begin
  if Value<>FControl then begin
    if FControl<>nil then
      FControl.WindowProc:=FOldWndMethod;
    if Value<>nil then begin
      FOldWndMethod:=Value.WindowProc;
      Application.ShowHint:=false;
      Application.ShowHint:=true;
    end else begin
      FOldWndMethod:=nil;
    end;
    FControl:=Value;
    if FControl<>nil then
      FControl.WindowProc:=ControlWindowProc;
  end;
end;

procedure TBisHint.ControlWindowProc(var Message: TMessage);
var
  P: PHintInfo;
begin
  case Message.Msg of
    CM_HINTSHOW: begin
      P:=Pointer(Message.LParam);
      if P.HintControl=FControl then begin
        P.HintData:=Self;
        P.HintWindowClass:=TBisHintWindow;
        P.ReshowTimeout:=FReshowTimeout;
        P.HideTimeout:=FHideTimeout;
        P.HintPos:=Point(P.HintPos.x+FHintPosX,P.HintPos.y+FHintPosY);
      end else begin
        P.HintData:=nil;
        P.HintWindowClass:=HintWindowClass;
      end;
    end;
    else
      if Assigned(FOldWndMethod) then
        FOldWndMethod(Message);
  end;
end;


end.
