{*******************************************************}
{                                                       }
{          MiTeC MDI Button Group Component             }
{                                                       }
{            version 1.0 for Delphi 2006                }
{                                                       }
{            Copyright © 2007 Michal Mutl               }
{                                                       }
{*******************************************************}

unit MDIButtonGroup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, CommCtrl, CategoryButtons, ButtonGroup;

const
  cAbout = 'MDI ButtonGroup Control 1.0 - Copyright © 2007 Michal Mutl';

type
  PNotifyEvent = ^TNotifyEvent;

  TMDIButtonGroup = class(TButtonGroup)
  private
    FAbout: string;
    FActivateList, FDestroyList: TList;
    FOnBeforeDrawButton: TGrpButtonDrawEvent;
    FOnAfterDrawButton: TGrpButtonDrawEvent;
    FOnDrawButton: TGrpButtonDrawEvent;
    FOnDrawIcon: TGrpButtonDrawIconEvent;
    FOnDrawText: TGrpButtonDrawEvent;
    FRegularButtonColor: TColor;
    FSelectedButtonColor: TColor;
    FHotButtonColor: TColor;
    FHotButton: Integer;
    FAutoSize: boolean;
    function CalcButtonsPerRow: Integer;
    function CalcRowsSeen: Integer;
    procedure RemoveTab(AChild: TForm);
    procedure ChildActivate(Sender: TObject);
    procedure ChildDestroy(Sender: TObject);
    procedure SetOnDrawButton(const Value: TGrpButtonDrawEvent);
    procedure SetOnDrawIcon(const Value: TGrpButtonDrawIconEvent);
    procedure SetHotButtonColor(const Value: TColor);
    procedure SetRegularButtonColor(const Value: TColor);
    procedure SetSelectedButtonColor(const Value: TColor);
    function GetCaption(index: integer): string;
    function GetCount: integer;
    function GetGlyph(index: integer): integer;
    function GetHint(index: integer): string;
    function GetChild(index: integer): TForm;
    function GetMinimized: integer;
    procedure SetCaption(index: integer; const Value: string);
    procedure SetGlyph(index: integer; const Value: integer);
    procedure SetHint(index: integer; const Value: string);
    function GetActiveChild: TForm;
    procedure SetAutoSize(const Value: boolean);
  protected
    procedure DoItemClicked(const Index: Integer); override;
    procedure DrawButton(Index: Integer; Canvas: TCanvas; Rect: TRect; State: TButtonDrawState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddButton(AChild: TForm; AImageIndex: Integer; AHint: string);
    procedure MinimizeAll;
    procedure CloseAll;
    function GetChildIndex(AChild: TForm): integer;

    property ActiveMDIChild :TForm read GetActiveChild;
    property MDIChildCount :integer read GetCount;
    property MDIChildren[index :integer] :TForm read GetChild;
    property MinimizedCount :integer read GetMinimized;
    property Captions[index :integer]: string read GetCaption write SetCaption;
    property Glyphs[index :integer]: integer read GetGlyph write SetGlyph;
    property Hints[index :integer]: string read GetHint write SetHint;
    property HotButtonIndex: Integer read FHotButton;
  published
    property About: string read FAbout;
    property AutoSize: boolean read FAutoSize write SetAutoSize;
    property HotButtonColor: TColor read FHotButtonColor write SetHotButtonColor default $00EFD3C6;
    property RegularButtonColor: TColor read FRegularButtonColor write SetRegularButtonColor nodefault;
    property SelectedButtonColor: TColor read FSelectedButtonColor write SetSelectedButtonColor nodefault;

    property OnAfterDrawButton: TGrpButtonDrawEvent read FOnAfterDrawButton write FOnAfterDrawButton;
    property OnBeforeDrawButton: TGrpButtonDrawEvent read FOnBeforeDrawButton write FOnBeforeDrawButton;
    property OnDrawButton: TGrpButtonDrawEvent read FOnDrawButton write SetOnDrawButton;
    property OnDrawIcon: TGrpButtonDrawIconEvent read FOnDrawIcon write SetOnDrawIcon;
    property OnDrawText: TGrpButtonDrawEvent read FOnDrawText write FOnDrawText;
  end;

procedure Register;

implementation

uses GraphUtil;

procedure Register;
begin
  RegisterComponents('MiTeC', [TMDIButtonGroup]);
end;

{ TMDIButtonGroup }

procedure TMDIButtonGroup.AddButton;
var
  i :integer;
  ae,de :PNotifyEvent;
begin
  if Assigned(AChild) then begin
    for i:=0 to Self.Items.Count-1 do
      if TForm(Self.Items[i].Data)=AChild then
        Exit;
    with Self.Items.Add do begin
      Caption:=AChild.Caption;
      Hint:=AHint;
      ImageIndex:=AImageIndex;
      Data:=AChild;
    end;
    if Assigned(AChild.OnActivate) then begin
      new(ae);
      ae^:=AChild.OnActivate;
      FActivateList.add(ae)
    end else
      FActivateList.Add(nil);
    if Assigned(AChild.OnDestroy) then begin
      new(de);
      de^:=AChild.OnDestroy;
      FDestroyList.Add(de);
    end else
      FDestroyList.Add(nil);
    AChild.Hint:=AHint;
    AChild.OnActivate:=ChildActivate;
    AChild.OnDestroy:=ChildDestroy;

    Self.ItemIndex:=Self.Items.Count-1;
    Self.Invalidate;

    ScrollIntoView(Self.ItemIndex);
  end;
end;

function TMDIButtonGroup.CalcButtonsPerRow: Integer;
begin
  if gboFullSize in ButtonOptions then
    Result:=1
  else begin
    Result:=ClientWidth div ButtonWidth;
    if Result=0 then
      Result:=1;
  end;
end;

function TMDIButtonGroup.CalcRowsSeen: Integer;
begin
  Result:=ClientHeight div ButtonHeight
end;

procedure TMDIButtonGroup.ChildActivate(Sender: TObject);
var
  i :integer;
begin
  if not(Sender is TMDIButtonGroup) then
    for i:=0 to Self.Items.Count-1 do
      if Self.Items[i].Data=Sender then begin
        Self.ItemIndex:=i;
        Break;
      end;

  if (Self.ItemIndex>-1) then begin
    if Assigned(FActivateList[Self.ItemIndex]) then
      TNotifyEvent(FActivateList[Self.ItemIndex]^)(TForm(Self.Items[Self.ItemIndex].Data));
    ScrollIntoView(Self.ItemIndex);  
  end;
end;

procedure TMDIButtonGroup.ChildDestroy(Sender: TObject);
var
  i,idx :integer;
begin
  idx:=-1;
  try
    if Assigned(Sender) and (Sender is TForm) then
      for i:=0 to Self.Items.Count-1 do
        if Assigned(Self.Items[i].Data) and (Self.Items[i].Data=Sender) then begin
          idx:=i;
          Break;
        end;
    if (idx>-1) then begin
      if Assigned(FDestroyList[idx]) then
        TNotifyEvent(FDestroyList[idx]^)(TForm(Self.Items[idx].Data));
      FActivateList.Delete(idx);
      FDestroyList.Delete(idx);
      Self.Items.Delete(idx);
    end;

    Self.ItemIndex:=GetChildIndex(TForm(Owner).ActiveMDIChild);
  except
  end;
end;

procedure TMDIButtonGroup.CloseAll;
var
  i,n,idx :integer;
begin
  n:=TForm(Owner).MDIChildCount;
  for i:=n-1 downto 0 do begin
    TForm(Owner).MDIChildren[i].Close;
  end;
end;

constructor TMDIButtonGroup.Create(AOwner: TComponent);
var
  i :integer;
begin
  FAbout:=cAbout;
  if not(AOwner is TCustomForm) then begin
    raise Exception.Create('MDIButtonGroup can be put only on Form.');
    inherited Destroy;
  end else
    if TForm(AOwner).FormStyle<>fsMDIForm then begin
      raise Exception.Create('MDIButtonGroup can be put only on MDIForm.');
      inherited Destroy;
    end;
  for i:=0 to AOwner.ComponentCount-1 do
    if AOwner.Components[i] is TMDIButtonGroup then begin
      raise Exception.Create('Only one MDIButtonGroup can be put on MDIForm.');
      inherited Destroy;
    end;
  inherited;

  FActivateList:=TList.Create;
  FDestroyList:=TList.Create;

  FHotButtonColor:=$00EFD3C6;
  FSelectedButtonColor:=clInfoBk;
  FRegularButtonColor:=GetHighlightColor(clBtnFace, 15);
  Self.ButtonWidth:=100;
  Self.ButtonHeight:=22;
  Self.Height:=22;
  Self.BorderStyle:=bsNone;
  Self.ButtonOptions:=[gboGroupStyle,gboShowCaptions];
  Self.ShowHint:=True;
end;

destructor TMDIButtonGroup.Destroy;
begin
  FActivateList.Free;
  FDestroyList.Free;
  PopupMenu:=nil;
  inherited;
end;

procedure TMDIButtonGroup.DoItemClicked(const Index: Integer);
var
  child :TForm;
begin
  Self.ItemIndex:=Index;
  if Self.ItemIndex>-1 then begin
    Child:=TForm(Self.Items[Self.ItemIndex].Data);
    SendMessage(Child.Handle,WM_NCACTIVATE,WA_ACTIVE,0);
    Child.SetFocus;
    Child.BringToFront;
    if Child.WindowState=wsMinimized then
      Child.WindowState:=wsNormal;
  end;
  inherited;
  UpdateButton(Self.ItemIndex);
end;

procedure TMDIButtonGroup.DrawButton(Index: Integer; Canvas: TCanvas;
  Rect: TRect; State: TButtonDrawState);
var
  TextLeft, TextTop: Integer;
  RectHeight: Integer;
  ImgTop: Integer;
  TextOffset: Integer;
  FillColor: TColor;
  EdgeColor: TColor;
  InsertIndication: TRect;
  TextRect: TRect;
  OrgRect: TRect;
  Caption: string;
begin
  if Assigned(FOnDrawButton) and (not (csDesigning in ComponentState)) then
    FOnDrawButton(Self, Index, Canvas, Rect, State)
  else
  begin
    OrgRect := Rect;
    if Assigned(FOnBeforeDrawButton) then
      FOnBeforeDrawButton(Self, Index, Canvas, Rect, State);
    InflateRect(Rect, -1, -1);

    Canvas.Font.Color := clBtnText;
    if bdsHot in State then
    begin
      FillColor := FHotButtonColor;
      if bdsSelected in State then
        FillColor := GetShadowColor(FillColor, -10);
      EdgeColor := GetShadowColor(FillColor);
    end
    else if bdsSelected in State then
    begin
      FillColor := FSelectedButtonColor;
      EdgeColor := GetShadowColor(FillColor);
    end
    else
    begin
      FillColor := FRegularButtonColor;
      if (bdsFocused in State) then
        EdgeColor := GetShadowColor(FSelectedButtonColor)
      else
        EdgeColor := GetShadowColor(FillColor);
    end;

    Canvas.Brush.Color := FillColor;
    if FillColor <> clNone then
    begin
      Canvas.FillRect(Rect);
      { Draw the edge outline }
      Canvas.Brush.Color := EdgeColor;
      Canvas.FrameRect(Rect);
    end;

    if bdsFocused in State then
    begin
      InflateRect(Rect, -1, -1);
      Canvas.FrameRect(Rect);
    end;

    Canvas.Brush.Color := FillColor;

    { Compute the text location }
    TextLeft := Rect.Left + 4;
    RectHeight := Rect.Bottom - Rect.Top;
    TextTop := Rect.Top + (RectHeight - Canvas.TextHeight('Wg')) div 2;

    if gboFullSize in ButtonOptions then
      Inc(TextLeft, 4);  // indent, slightly

    if TextTop < Rect.Top then
      TextTop := Rect.Top;
    if bdsDown in State then
    begin
      Inc(TextTop);
      Inc(TextLeft);
    end;

    { Draw the icon - prefer the event }
    TextOffset := 0;
    if Assigned(FOnDrawIcon) then
      FOnDrawIcon(Self, Index, Canvas, OrgRect, State, TextOffset)
    else if (Images <> nil) and (Items[Index].ImageIndex > -1) and
        (Items[Index].ImageIndex < Images.Count) then
    begin
      ImgTop := Rect.Top + (RectHeight - Images.Height) div 2;
      if ImgTop < Rect.Top then
        ImgTop := Rect.Top;
      if bdsDown in State then
        Inc(ImgTop);
      Images.Draw(Canvas, TextLeft - 1, ImgTop, Items[Index].ImageIndex);
      TextOffset := Images.Width + 1;
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

    if gboShowCaptions in ButtonOptions then
    begin
      if FillColor = clNone then
        Canvas.Brush.Style := bsClear;

      { Avoid clipping the image }
      Inc(TextLeft, TextOffset);
      TextRect.Left := TextLeft;
      TextRect.Right := Rect.Right - 2;
      TextRect.Top := TextTop;
      TextRect.Bottom := Rect.Bottom -1;

      if Assigned(FOnDrawText) then
        FOnDrawText(Self, Index, Canvas, TextRect, State)
      else
      begin
        Caption := Items[Index].Caption;
        Canvas.TextRect(TextRect, Caption, [tfEndEllipsis]);
      end;
    end;

    if Assigned(FOnAfterDrawButton) then
      FOnAfterDrawButton(Self, Index, Canvas, OrgRect, State);
  end;
  Canvas.Brush.Color := Color; { Restore the original color }
end;

function TMDIButtonGroup.GetActiveChild: TForm;
begin
  Result:=GetChild(Self.ItemIndex);
end;

function TMDIButtonGroup.GetCaption(index: integer): string;
begin
  if (index>-1) and (index<Self.Items.Count) then
    Result:=Self.Items[index].Caption
  else
    Result:='';
end;

function TMDIButtonGroup.GetChild(index: integer): TForm;
begin
  if (index>-1) and (index<Self.Items.Count) then
    Result:=TForm(Self.Items[index].Data)
  else
    Result:=nil;
end;

function TMDIButtonGroup.GetChildIndex(AChild: TForm): integer;
var
  i: integer;
begin
  Result:=-1;
  for i:=0 to Self.MDIChildCount-1 do
    if Self.MDIChildren[i]=AChild then begin
      Result:=i;
      Break;
    end;
end;

function TMDIButtonGroup.GetCount: integer;
var
  i: Integer;
begin
  Result:=0;
  for i:=0 to Self.Items.Count-1 do
    if Assigned(Self.Items[i].Data) and (TObject(Self.Items[i].Data) is TForm) then
      Inc(Result);
end;

function TMDIButtonGroup.GetGlyph(index: integer): integer;
begin
  if (index>-1) and (index<Self.Items.Count) then
    Result:=Self.Items[index].ImageIndex
  else
    Result:=-1;
end;

function TMDIButtonGroup.GetHint(index: integer): string;
begin
  if (index>-1) and (index<Self.Items.Count) then
    Result:=Self.Items[index].Hint
  else
    Result:='';
end;

function TMDIButtonGroup.GetMinimized: integer;
var
  i :integer;
begin
  Result:=0;
  for i:=0 to Self.Items.Count-1 do
    if GetChild(i).WindowState=wsMinimized then
      Inc(Result);
end;

procedure TMDIButtonGroup.MinimizeAll;
var
  i,n :integer;
begin
  n:=TForm(Owner).MDIChildCount;
  for i:=n-1 downto 0 do
    TForm(Owner).MDIChildren[i].WindowState:=wsMinimized;
  TForm(Owner).ArrangeIcons;
end;

procedure TMDIButtonGroup.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  FHotButton:=Self.IndexOfButtonAt(X,Y);
end;

procedure TMDIButtonGroup.RemoveTab(AChild: TForm);
var
  i :integer;
begin
  if Assigned(AChild) then
    for i:=0 to Self.Items.Count-1 do
      if TForm(Self.Items[i])=AChild then begin
        Self.Items.Delete(i);
        FActivateList.Delete(i);
        FDestroyList.Delete(i);
        Break;
      end;
end;


procedure TMDIButtonGroup.Resize;
var
  RowsSeen: Integer;
  ButtonsPerRow: Integer;
  TotalRowsNeeded: Integer;
begin
  inherited;

  RowsSeen:=CalcRowsSeen;
  ButtonsPerRow:=CalcButtonsPerRow;

  if FAutoSize then begin
    Windows.ShowScrollBar(Handle,SB_VERT,False);
    TotalRowsNeeded:=Items.Count div ButtonsPerRow;
    if Items.Count mod ButtonsPerRow<>0 then
      Inc(TotalRowsNeeded);
    Height:=TotalRowsNeeded*ButtonHeight;
  end else begin
    Height:=ButtonHeight;
    inherited;
  end;
end;

procedure TMDIButtonGroup.SetAutoSize(const Value: boolean);
begin
  if FAutoSize<>Value then begin
    FAutoSize:=Value;
    Resize;
    Invalidate;
  end;
end;

procedure TMDIButtonGroup.SetCaption(index: integer; const Value: string);
begin
  if (index>-1) and (index<Self.Items.Count) then
    Self.Items[index].Caption:=Value;
end;

procedure TMDIButtonGroup.SetGlyph(index: integer; const Value: integer);
begin
  if (index>-1) and (index<Self.Items.Count) then
    Self.Items[index].ImageIndex:=Value;
end;

procedure TMDIButtonGroup.SetHint(index: integer; const Value: string);
begin
  if (index>-1) and (index<Self.Items.Count) then
    Self.Items[index].Hint:=Value;
end;

procedure TMDIButtonGroup.SetHotButtonColor(const Value: TColor);
begin
  if FHotButtonColor<>Value then begin
    FHotButtonColor:=Value;
    Invalidate;
  end;
end;

procedure TMDIButtonGroup.SetOnDrawButton(const Value: TGrpButtonDrawEvent);
begin
  FOnDrawButton := Value;
  Invalidate;
end;

procedure TMDIButtonGroup.SetOnDrawIcon(const Value: TGrpButtonDrawIconEvent);
begin
  FOnDrawIcon := Value;
  Invalidate;
end;

procedure TMDIButtonGroup.SetRegularButtonColor(const Value: TColor);
begin
  if FRegularButtonColor<>Value then begin
    FRegularButtonColor:=Value;
    Invalidate;
  end;
end;

procedure TMDIButtonGroup.SetSelectedButtonColor(const Value: TColor);
begin
  if FSelectedButtonColor<>Value then begin
    FSelectedButtonColor:=Value;
    Invalidate;
  end;
end;

end.
