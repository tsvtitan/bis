unit VirtualTreesEx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualTrees;

type
  // Extended options; existing option sets cannot be extended unfortunately.
  TVTExtendedOption = (
    toBufferUpdates,         // Hold tree image in backbuffer during updates.
    toShadeBuffer            // Shade the backbuffer similar to windows shutdown desktop effect.
  );
  TVTExtendedOptions = set of TVTExtendedOption;

const
  DefaultExtendedOptions = [toShadeBuffer];

type
  TCustomVirtualTreeExOptions = class(TStringTreeOptions)
  private
    FExtendedOptions: TVTExtendedOptions;
  protected
    property ExtendedOptions: TVTExtendedOptions read FExtendedOptions write FExtendedOptions;
  public
    constructor Create(AOwner: TBaseVirtualTree); override;
    procedure AssignTo(Dest: TPersistent); override;
  end;

  TVirtualTreeExOptions = class(TCustomVirtualTreeExOptions)
  published
    property ExtendedOptions;
  end;

  TCustomVirtualStringTreeEx = class(TVirtualStringTree)
  protected
    procedure WMSetRedraw(var Msg: TMessage); message WM_SETREDRAW;
    procedure SetOptions(const Value: TVirtualTreeExOptions);
    function GetOptions: TVirtualTreeExOptions;
  protected
    FUpdateBuffer: TBitmap;
    procedure DoUpdating(State: TVTUpdateState); override;
    function GetOptionsClass: TTreeOptionsClass; override;
    procedure Paint; override;
    procedure ShadeBitmap(Bitmap: TBitmap); virtual;
  public
    destructor Destroy; override;
  end;

  TVirtualStringTreeEx = class(TCustomVirtualStringTreeEx)
  published
    property TreeOptions: TVirtualTreeExOptions read GetOptions write SetOptions;
  end;

implementation

{ TCustomVirtualTreeExOptions }

constructor TCustomVirtualTreeExOptions.Create(AOwner: TBaseVirtualTree);
begin
  inherited;
  FExtendedOptions := DefaultExtendedOptions;
end;

procedure TCustomVirtualTreeExOptions.AssignTo(Dest: TPersistent);
begin
  if Dest is TCustomVirtualTreeExOptions then
    with Dest as TCustomVirtualTreeExOptions do
      ExtendedOptions := self.ExtendedOptions;

  inherited;
end;

{ TCustomVirtualStringTreeEx }

destructor TCustomVirtualStringTreeEx.Destroy;
begin
  FreeAndNil(FUpdateBuffer);
  inherited;
end;

function TCustomVirtualStringTreeEx.GetOptionsClass: TTreeOptionsClass;
begin
  result := TVirtualTreeExOptions;
end;

function TCustomVirtualStringTreeEx.GetOptions: TVirtualTreeExOptions;
begin
  result := TVirtualTreeExOptions(inherited TreeOptions);
end;

procedure TCustomVirtualStringTreeEx.SetOptions(const Value: TVirtualTreeExOptions);
begin
  (inherited TreeOptions).Assign(Value);
end;

// Prepare or free buffer on update begin / end.
procedure TCustomVirtualStringTreeEx.DoUpdating(State: TVTUpdateState);
var
  Window: TRect;
begin
  inherited;

  if HandleAllocated and (toBufferUpdates in GetOptions.ExtendedOptions) then
    if State = usBegin then
    begin
      FreeAndNil(FUpdateBuffer);
      FUpdateBuffer := TBitmap.Create;
      FUpdateBuffer.PixelFormat := pf32Bit;
      FUpdateBuffer.Width := ClientWidth;
      FUpdateBuffer.Height := ClientHeight;

      Window := ClientRect;
      OffsetRect(Window, -OffsetX, -OffsetY);
      PaintTree(FUpdateBuffer.Canvas, Window, Point(0, 0),
          [poBackground, poColumnColor, poDrawFocusRect, poDrawSelection,
          poGridLines]);

      if toShadeBuffer in GetOptions.ExtendedOptions then
      begin
        ShadeBitmap(FUpdateBuffer);
        Paint;
      end;
    end
    else if State = usEnd then
      FreeAndNil(FUpdateBuffer);
end;

// Copy buffer if update is in progress.
procedure TCustomVirtualStringTreeEx.Paint;
begin
  if (FUpdateBuffer = nil) or not (toBufferUpdates in GetOptions.ExtendedOptions) then
    inherited
  else
    with Canvas.ClipRect do
      BitBlt(Canvas.Handle, Left, Top, Right - Left, Bottom - Top,
          FUpdateBuffer.Canvas.Handle, Left, Top, SRCCOPY);
end;

// Mimic windows "shutdown effect" on Bitmap.
procedure TCustomVirtualStringTreeEx.ShadeBitmap(Bitmap: TBitmap);
var
  Tmp: TBitmap;

  // Paint checkered brush on Bitmap.
  procedure BrushBitmap(Bitmap: TBitmap);
  var
    BrushMap: TBitmap;
    i: Byte;
  begin
    BrushMap := TBitmap.Create;
    try
      with BrushMap, BrushMap.Canvas do
      begin
        PixelFormat := pf1Bit;
        Width := 8;
        Height := 8;
        for i := 0 to 7 do
          if not Odd(i) then
            PByte(ScanLine[i])^ := 1 + 4 + 16 + 64
          else
            PByte(ScanLine[i])^ := 2 + 8 + 32 + 128;
      end;

      with Bitmap do
      begin
        Canvas.Brush.Bitmap := BrushMap;
        Canvas.CopyMode := $00A000C9;
        Canvas.CopyRect(Rect(0, 0, Width, Height), Canvas, Rect(0, 0, 0, 0));
      end;
    finally
      BrushMap.Free;
    end;
  end;

begin
  if MMXAvailable then
  begin // Alpha blending...
    Tmp := TBitmap.Create;
    with Tmp do
      try
        PixelFormat := pf32Bit;
        Width := Bitmap.Width;
        Height := Bitmap.Height;
        BrushBitmap(Tmp);
        AlphaBlend(Canvas.Handle, Bitmap.Canvas.Handle, Rect(0, 0, Bitmap.Width, Bitmap.Height),
            Point(0, 0), bmConstantAlpha, 180, -30);
      finally
        Free;
      end;
  end else // No MMX...
    BrushBitmap(Bitmap);
end;

// We need paint messages during buffered updates...
procedure TCustomVirtualStringTreeEx.WMSetRedraw(var Msg: TMessage);
begin
  if (FUpdateBuffer = nil) or not (toBufferUpdates in GetOptions.ExtendedOptions) then
    inherited
  else
    Msg.Result := 0;
end;

end.

