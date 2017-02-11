
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Display Detection Part                  }
{           version 5.5 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Display;

interface

uses
  SysUtils, Windows, Classes;

type
  TDisplayInfo = record
    DAC,
    Chipset: string;
    Memory: integer;
  end;

  TCurveCap = (ccCircles,ccPieWedges,ccChords,ccEllipses,ccWideBorders,ccStyledBorders,
               ccWideStyledBorders,ccInteriors,ccRoundedRects);
  TLineCap = (lcPolylines,lcMarkers,lcMultipleMarkers,lcWideLines,lcStyledLines,
               lcWideStyledLines,lcInteriors);
  TPolygonCap = (pcAltFillPolygons,pcRectangles,pcWindingFillPolygons,pcSingleScanlines,
                 pcWideBorders,pcStyledBorders,pcWideStyledBorders,pcInteriors);
  TRasterCap = (rcRequiresBanding,rcTranserBitmaps,rcBitmaps64K,rcSetGetDIBits,
                rcSetDIBitsToDevice,rcFloodfills,rcWindows2xFeatures,rcPaletteBased,
                rcScaling,rcStretchBlt,rcStretchDIBits);
  TTextCap = (tcCharOutPrec,tcStrokeOutPrec,tcStrokeClipPrec,tcCharRotation90,
              tcCharRotationAny,tcScaleIndependent,tcDoubledCharScaling,tcIntMultiScaling,
              tcAnyMultiExactScaling,tcDoubleWeightChars,tcItalics,tcUnderlines,
              tcStrikeouts,tcRasterFonts,tcVectorFonts,tcNoScrollUsingBlts);

  TCurveCaps = set of TCurveCap;
  TLineCaps = set of TLineCap;
  TPolygonCaps = set of TPolygonCap;
  TRasterCaps = set of TRasterCap;
  TTextCaps = set of TTextCap;

  TDisplay = class(TPersistent)
  private
    FVertRes: integer;
    FColorDepth: integer;
    FHorzRes: integer;
    FBIOSDate: string;
    FBIOSVersion: string;
    FPixelDiagonal: integer;
    FPixelHeight: integer;
    FVertSize: integer;
    FPixelWidth: integer;
    FHorzSize: integer;
    FTechnology: string;
    FCurveCaps: TCurveCaps;
    FLineCaps: TLineCaps;
    FPolygonCaps: TPolygonCaps;
    FRasterCaps: TRasterCaps;
    FTextCaps: TTextCaps;
    FMemory: integer;
    FChipset: string;
    FAdapter: string;
    FDAC: string;
    FModes: TStrings;
    FFontSize: DWORD;
  private
    FExtendedReport: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report_CurveCaps(ACaps :TStringList);
    procedure Report_LineCaps(ACaps :TStringList);
    procedure Report_PolygonCaps(ACaps :TStringList);
    procedure Report_RasterCaps(ACaps :TStringList);
    procedure Report_TextCaps(ACaps :TStringList);
    procedure Report(var sl :TStringList);

    property ExtendedReport: Boolean read FExtendedReport write FExtendedReport;
  published
    property Adapter :string read FAdapter write FAdapter stored false;
    property DAC :string read FDAC write FDAC stored false;
    property Chipset :string read FChipset write FChipset stored false;
    property Memory :Integer read FMemory write FMemory stored false;
    property HorzRes :integer read FHorzRes write FHorzRes stored false;
    property VertRes :integer read FVertRes write FVertRes stored false;
    property ColorDepth :integer read FColorDepth write FColorDepth stored false;
    // BIOS info is available only under NT
    property BIOSVersion :string read FBIOSVersion write FBIOSVersion stored false;
    property BIOSDate :string read FBIOSDate write FBIOSDate stored false;

    property Technology :string read FTechnology write FTechnology stored false;
    property PixelWidth :integer read FPixelWidth write FPixelWidth stored false;
    property PixelHeight :integer read FPixelHeight write FPixelHeight stored false;
    property PixelDiagonal :integer read FPixelDiagonal write FPixelDiagonal stored false;
    property RasterCaps :TRasterCaps read FRasterCaps write FRasterCaps stored false;
    property CurveCaps :TCurveCaps read FCurveCaps write FCurveCaps stored false;
    property LineCaps :TLineCaps read FLineCaps write FLineCaps stored false;
    property PolygonCaps :TPolygonCaps read FPolygonCaps write FPolygonCaps stored false;
    property TextCaps :TTextCaps read FTextCaps write FTextCaps stored false;
    property Modes :TStrings read FModes write FModes stored False;
    property FontResolution: DWORD read FFontSize Write FFontSize stored False;
  end;

implementation

uses Registry, MiTeC_Routines, MSI_Devices;

{ TDisplay }

procedure GetWin9xDisplayInfo(var InfoRecord: TDisplayInfo);
const
  rk = {HKEY_LOCAL_MACHINE\}'System\CurrentControlSet\Services\Class\Display\0000\INFO';
  rvDAC = 'DacType';
  rvChip = 'ChipType';
  rvMem = 'VideoMemory';
begin
  try

  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    if OpenKey(rk,false) then begin
      if ValueExists(rvDAC) then
        InfoRecord.DAC:=ReadString(rvDAC);
      if ValueExists(rvChip) then
        InfoRecord.Chipset:=ReadString(rvChip);
      if ValueExists(rvMem) then
        InfoRecord.Memory:=ReadInteger(rvMem);
      CloseKey;
    end;
    Free;
  end;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TDisplay.GetWin9xDisplayInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure GetWinNTDisplayInfo(AServiceName: string; var InfoRecord: TDisplayInfo);
var
  StrData :PChar;
//  IntData,
const
  rk = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Services\%s\Device0';
  rvDAC = 'HardwareInformation.DacType';
  rvChip = 'HardwareInformation.ChipType';
  rvMem = 'HardwareInformation.MemorySize';
begin
  try

  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    if OpenKey(Format(rk,[AServiceName]),false) then begin
      StrData:=StrAlloc(255);
      if ValueExists(rvDAC) then
        try
          ReadBinaryData(rvDAC,StrData^,255);
          InfoRecord.DAC:=GetStrFromBuf(PChar(StrData));
        except
        end;
      if ValueExists(rvChip) then
        try
          ReadBinaryData(rvChip,StrData^,255);
          InfoRecord.Chipset:=GetStrFromBuf(PChar(StrData));
        except
        end;
      if ValueExists(rvMem) then
        try
          {IntData:=StrAlloc(255);
          ReadBinaryData(rvMem,IntData,4);
          InfoRecord.Memory:=integer(IntData);
          StrDispose(IntData);}
          ReadBinaryData(rvMem,InfoRecord.Memory,4);
        except
        end;
      StrDispose(StrData);
      CloseKey;
    end;
    Free;
  end;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TDisplay.GetWinNTDisplayInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure GetVideoBIOSInfo(var Version, Date: string);
var
  StrData :PChar;
const
  rk = {HKEY_LOCAL_MACHINE\}'HARDWARE\DESCRIPTION\System';
  rvVideoBiosDate = 'VideoBiosDate';
  rvVideoBiosVersion = 'VideoBiosVersion';
begin
  try

  with TRegistry.Create do begin
    RootKey:=HKEY_LOCAL_MACHINE;
    if OpenKey(rk,false) then begin
      if ValueExists(rvVideoBIOSVersion) then begin
        try
          StrData:=StrAlloc(255);
          ReadBinaryData(rvVideoBIOSVersion,StrData^,151);
          Version:=StrPas(PChar(StrData));
          StrDispose(StrData);
        except
        end;
      end;
      if ValueExists(rvVideoBIOSDate) then
        Date:=ReadString(rvVideoBIOSDate);
      CloseKey;
    end;
    Free;
  end;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TDisplay.GetVideoBIOSInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TDisplay.GetInfo;
var
  i :integer;
  DevMode : TDevMode;
  Device: TDevice;
  InfoRec: TDisplayInfo;
begin
  try

  with TDevices.Create do begin
    GetInfo;
    for i:=0 to DeviceCount-1 do
      if Devices[i].DeviceClass=dcDisplay then begin
        Device:=Devices[i];
        Break;
      end;
    Free;
  end;

  if Device.FriendlyName='' then
    FAdapter:=Device.Description
  else
    FAdapter:=Device.FriendlyName;

  if IsNT then
    GetWinNTDisplayInfo(Device.Service,InfoRec)
  else
    GetWin9xDisplayInfo(InfoRec);

  FDAC:=InfoRec.DAC;
  FChipset:=InfoRec.Chipset;
  FMemory:=InfoRec.Memory;

  GetVideoBIOSInfo(FBIOSVersion,FBIOSDate);

  FFontSize:=GetDeviceCaps(GetDC(0),LOGPIXELSY);
  FHorzRes:=GetDeviceCaps(GetDC(0),windows.HORZRES);
  FVertRes:=GetDeviceCaps(GetDC(0),windows.VERTRES);
  FColorDepth:=GetDeviceCaps(GetDC(0),BITSPIXEL);
  case GetDeviceCaps(GetDC(0),windows.TECHNOLOGY) of
    DT_PLOTTER:    FTechnology:='Vector Plotter';
    DT_RASDISPLAY: FTechnology:='Raster Display';
    DT_RASPRINTER: FTechnology:='Raster Printer';
    DT_RASCAMERA:  FTechnology:='Raster Camera';
    DT_CHARSTREAM: FTechnology:='Character Stream';
    DT_METAFILE:   FTechnology:='Metafile';
    DT_DISPFILE:   FTechnology:='Display File';
  end;
  FHorzSize:=GetDeviceCaps(GetDC(0),HORZSIZE);
  FVertSize:=GetDeviceCaps(GetDC(0),VERTSIZE);
  FPixelWidth:=GetDeviceCaps(GetDC(0),ASPECTX);
  FPixelHeight:=GetDeviceCaps(GetDC(0),ASPECTY);
  FPixelDiagonal:=GetDeviceCaps(GetDC(0),ASPECTXY);
  FCurveCaps:=[];
  if GetDeviceCaps(GetDC(0),windows.CURVECAPS)<>CC_NONE then begin
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_CIRCLES)=CC_CIRCLES then
      FCurveCaps:=FCurveCaps+[ccCircles];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_PIE)=CC_PIE then
      FCurveCaps:=FCurveCaps+[ccPieWedges];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_CHORD)=CC_CHORD then
      FCurveCaps:=FCurveCaps+[ccChords];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_ELLIPSES)=CC_ELLIPSES then
      FCurveCaps:=FCurveCaps+[ccEllipses];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_WIDE)=CC_WIDE then
      FCurveCaps:=FCurveCaps+[ccWideBorders];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_STYLED)=CC_STYLED then
      FCurveCaps:=FCurveCaps+[ccStyledBorders];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_WIDESTYLED)=CC_WIDESTYLED then
      FCurveCaps:=FCurveCaps+[ccWideStyledBorders];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_INTERIORS)=CC_INTERIORS then
      FCurveCaps:=FCurveCaps+[ccInteriors];
    if (GetDeviceCaps(GetDC(0),windows.CURVECAPS) and CC_ROUNDRECT)=CC_ROUNDRECT then
      FCurveCaps:=FCurveCaps+[ccRoundedRects];
  end;
  FLineCaps:=[];
  if GetDeviceCaps(GetDC(0),windows.LINECAPS)<>LC_NONE then begin
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_POLYLINE)=LC_POLYLINE then
      FLineCaps:=FLineCaps+[lcPolylines];
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_MARKER)=LC_MARKER then
      FLineCaps:=FLineCaps+[lcMarkers];
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_POLYMARKER)=LC_POLYMARKER then
      FLineCaps:=FLineCaps+[lcMultipleMarkers];
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_WIDE)=LC_WIDE then
      FLineCaps:=FLineCaps+[lcWideLines];
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_STYLED)=LC_STYLED then
      FLineCaps:=FLineCaps+[lcStyledLines];
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_WIDESTYLED)=LC_WIDESTYLED then
      FLineCaps:=FLineCaps+[lcWideStyledLines];
    if (GetDeviceCaps(GetDC(0),windows.LINECAPS) and LC_INTERIORS)=LC_INTERIORS then
      FLineCaps:=FLineCaps+[lcInteriors];
  end;
  FPolygonCaps:=[];
  if GetDeviceCaps(GetDC(0),POLYGONALCAPS)<>PC_NONE then begin
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_POLYGON)=PC_POLYGON then
      FPolygonCaps:=FPolygonCaps+[pcAltFillPolygons];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_RECTANGLE)=PC_RECTANGLE then
      FPolygonCaps:=FPolygonCaps+[pcRectangles];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_WINDPOLYGON)=PC_WINDPOLYGON then
      FPolygonCaps:=FPolygonCaps+[pcWindingFillPolygons];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_SCANLINE)=PC_SCANLINE then
      FPolygonCaps:=FPolygonCaps+[pcSingleScanlines];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_WIDE)=PC_WIDE then
      FPolygonCaps:=FPolygonCaps+[pcWideBorders];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_STYLED)=PC_STYLED then
      FPolygonCaps:=FPolygonCaps+[pcStyledBorders];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_WIDESTYLED)=PC_WIDESTYLED then
      FPolygonCaps:=FPolygonCaps+[pcWideStyledBorders];
    if (GetDeviceCaps(GetDC(0),POLYGONALCAPS) and PC_INTERIORS)=PC_INTERIORS then
      FPolygonCaps:=FPolygonCaps+[pcInteriors];
  end;
  FRasterCaps:=[];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_BANDING)=RC_BANDING then
    FRasterCaps:=FRasterCaps+[rcRequiresBanding];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_BITBLT)=RC_BITBLT then
    FRasterCaps:=FRasterCaps+[rcTranserBitmaps];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_BITMAP64)=RC_BITMAP64 then
    FRasterCaps:=FRasterCaps+[rcBitmaps64K];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_DI_BITMAP)=RC_DI_BITMAP then
    FRasterCaps:=FRasterCaps+[rcSetGetDIBits];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_DIBTODEV)=RC_DIBTODEV then
    FRasterCaps:=FRasterCaps+[rcSetDIBitsToDevice];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_FLOODFILL)=RC_FLOODFILL then
    FRasterCaps:=FRasterCaps+[rcFloodfills];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_GDI20_OUTPUT)=RC_GDI20_OUTPUT then
    FRasterCaps:=FRasterCaps+[rcWindows2xFeatures];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_PALETTE)=RC_PALETTE then
    FRasterCaps:=FRasterCaps+[rcPaletteBased];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_SCALING)=RC_SCALING then
    FRasterCaps:=FRasterCaps+[rcScaling];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_STRETCHBLT)=RC_STRETCHBLT then
    FRasterCaps:=FRasterCaps+[rcStretchBlt];
  if (GetDeviceCaps(GetDC(0),windows.RASTERCAPS) and RC_STRETCHDIB)=RC_STRETCHDIB then
    FRasterCaps:=FRasterCaps+[rcStretchDIBits];
  FTextCaps:=[];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_OP_CHARACTER)=TC_OP_CHARACTER then
    FTextCaps:=FTextCaps+[tcCharOutPrec];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_OP_STROKE)=TC_OP_STROKE then
    FTextCaps:=FTextCaps+[tcStrokeOutPrec];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_CP_STROKE)=TC_CP_STROKE then
    FTextCaps:=FTextCaps+[tcStrokeClipPrec];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_CR_90)=TC_CR_90 then
    FTextCaps:=FTextCaps+[tcCharRotation90];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_CR_ANY)=TC_CR_ANY then
    FTextCaps:=FTextCaps+[tcCharRotationAny];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_SF_X_YINDEP)=TC_SF_X_YINDEP then
    FTextCaps:=FTextCaps+[tcScaleIndependent];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_SA_DOUBLE)=TC_SA_DOUBLE then
    FTextCaps:=FTextCaps+[tcDoubledCharScaling];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_SA_INTEGER)=TC_SA_INTEGER then
    FTextCaps:=FTextCaps+[tcIntMultiScaling];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_SA_CONTIN)=TC_SA_CONTIN then
    FTextCaps:=FTextCaps+[tcAnyMultiExactScaling];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_EA_DOUBLE)=TC_EA_DOUBLE then
    FTextCaps:=FTextCaps+[tcDoubleWeightChars];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_IA_ABLE)=TC_IA_ABLE then
    FTextCaps:=FTextCaps+[tcItalics];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_UA_ABLE)=TC_UA_ABLE then
    FTextCaps:=FTextCaps+[tcUnderlines];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and  TC_SO_ABLE)=TC_SO_ABLE then
    FTextCaps:=FTextCaps+[tcStrikeouts];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_RA_ABLE)=TC_RA_ABLE then
    FTextCaps:=FTextCaps+[tcRasterFonts];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_VA_ABLE)=TC_VA_ABLE then
    FTextCaps:=FTextCaps+[tcVectorFonts];
  if (GetDeviceCaps(GetDC(0),windows.TEXTCAPS) and TC_SCROLLBLT)=TC_SCROLLBLT then
    FTextCaps:=FTextCaps+[tcNoScrollUsingBlts];

  FModes.Clear;
  i:=0;
  while EnumDisplaySettings(nil,i,Devmode) do
    with Devmode do begin
      FModes.Add(Format('%d x %d - %d bit',[dmPelsWidth,dmPelsHeight,dmBitsPerPel]));
      Inc(i);
    end;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TDisplay.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TDisplay.Report_CurveCaps;
begin
  with ACaps do begin
    Add('[Curve Capabilities]');
    Add(Format('Circles=%d',[integer(ccCircles in CurveCaps)]));
    Add(Format('Pie Wedges=%d',[integer(ccPieWedges in CurveCaps)]));
    Add(Format('Chords=%d',[integer(ccChords in CurveCaps)]));
    Add(Format('Ellipses=%d',[integer(ccEllipses in CurveCaps)]));
    Add(Format('Wide Borders=%d',[integer(ccWideBorders in CurveCaps)]));
    Add(Format('Styled Borders=%d',[integer(ccStyledBorders in CurveCaps)]));
    Add(Format('Wide and Styled Borders=%d',[integer(ccWideStyledBorders in CurveCaps)]));
    Add(Format('Interiors=%d',[integer(ccInteriors in CurveCaps)]));
    Add(Format('Rounded Rectangles=%d',[integer(ccRoundedRects in CurveCaps)]));
  end;
end;

procedure TDisplay.Report_LineCaps;
begin
  with ACaps do begin
    Add('[Line Capabilities]');
    Add(Format('Polylines=%d',[integer(lcPolylines in LineCaps)]));
    Add(Format('Markers=%d',[integer(lcMarkers in LineCaps)]));
    Add(Format('Multiple Markers=%d',[integer(lcMultipleMarkers in LineCaps)]));
    Add(Format('Wide Lines=%d',[integer(lcWideLines in LineCaps)]));
    Add(Format('Styled Lines=%d',[integer(lcStyledLines in LineCaps)]));
    Add(Format('Wide and Styled Lines=%d',[integer(lcWideStyledLines in LineCaps)]));
    Add(Format('Interiors=%d',[integer(lcInteriors in LineCaps)]));
  end;
end;

procedure TDisplay.Report_PolygonCaps;
begin
  with ACaps do begin
    Add('[Polygonal Capabilities]');
    Add(Format('Alternate Fill Polygons=%d',[integer(pcAltFillPolygons in PolygonCaps)]));
    Add(Format('Rectangles=%d',[integer(pcRectangles in PolygonCaps)]));
    Add(Format('Winding Fill Polygons=%d',[integer(pcWindingFillPolygons in PolygonCaps)]));
    Add(Format('Single Scanlines=%d',[integer(pcSingleScanlines in PolygonCaps)]));
    Add(Format('Wide Borders=%d',[integer(pcWideBorders in PolygonCaps)]));
    Add(Format('Styled Borders=%d',[integer(pcStyledBorders in PolygonCaps)]));
    Add(Format('Wide and Styled Borders=%d',[integer(pcWideStyledBorders in PolygonCaps)]));
    Add(Format('Interiors=%d',[integer(pcInteriors in PolygonCaps)]));
  end;
end;

procedure TDisplay.Report_RasterCaps;
begin
  with ACaps do begin
    Add('[Raster Capabilities]');
    Add(Format('Requires Banding=%d',[integer(rcRequiresBanding in RasterCaps)]));
    Add(Format('Can Transer Bitmaps=%d',[integer(rcTranserBitmaps in RasterCaps)]));
    Add(Format('Supports Bitmaps > 64K=%d',[integer(rcBitmaps64K in RasterCaps)]));
    Add(Format('Supports SetDIBits and GetDIBits=%d',[integer(rcSetGetDIBits in RasterCaps)]));
    Add(Format('Supports SetDIBitsToDevice=%d',[integer(rcSetDIBitsToDevice in RasterCaps)]));
    Add(Format('Can Perform Floodfills=%d',[integer(rcFloodfills in RasterCaps)]));
    Add(Format('Supports Windows 2.0 Features=%d',[integer(rcWindows2xFeatures in RasterCaps)]));
    Add(Format('Palette Based=%d',[integer(rcPaletteBased in RasterCaps)]));
    Add(Format('Scaling=%d',[integer(rcScaling in RasterCaps)]));
    Add(Format('Supports StretchBlt=%d',[integer(rcStretchBlt in RasterCaps)]));
    Add(Format('Supports StretchDIBits=%d',[integer(rcStretchDIBits in RasterCaps)]));
  end;
end;

procedure TDisplay.Report_TextCaps;
begin
  with ACaps do begin
    Add('[Text Capabilities]');
    Add(Format('Capable of Character Output Precision=%d',[integer(tcCharOutPrec in TextCaps)]));
    Add(Format('Capable of Stroke Output Precision=%d',[integer(tcStrokeOutPrec in TextCaps)]));
    Add(Format('Capable of Stroke Clip Precision=%d',[integer(tcStrokeClipPrec in TextCaps)]));
    Add(Format('Supports 90 Degree Character Rotation=%d',[integer(tcCharRotation90 in TextCaps)]));
    Add(Format('Supports Character Rotation to Any Angle=%d',[integer(tcCharRotationAny in TextCaps)]));
    Add(Format('X And Y Scale Independent=%d',[integer(tcScaleIndependent in TextCaps)]));
    Add(Format('Supports Doubled Character Scaling=%d',[integer(tcDoubledCharScaling in TextCaps)]));
    Add(Format('Supports Integer Multiples Only When Scaling=%d',[integer(tcIntMultiScaling in TextCaps)]));
    Add(Format('Supports Any Multiples For Exact Character Scaling=%d',[integer(tcAnyMultiExactScaling in TextCaps)]));
    Add(Format('Supports Double Weight Characters=%d',[integer(tcDoubleWeightChars in TextCaps)]));
    Add(Format('Supports Italics=%d',[integer(tcItalics in TextCaps)]));
    Add(Format('Supports Underlines=%d',[integer(tcUnderlines in TextCaps)]));
    Add(Format('Supports Strikeouts=%d',[integer(tcStrikeouts in TextCaps)]));
    Add(Format('Supports Raster Fonts=%d',[integer(tcRasterFonts in TextCaps)]));
    Add(Format('Supports Vector Fonts=%d',[integer(tcVectorFonts in TextCaps)]));
    Add(Format('Cannot Scroll Using Blts=%d',[integer(tcNoScrollUsingBlts in TextCaps)]));
  end;
end;

constructor TDisplay.Create;
begin
  inherited;
  FModes:=TStringList.Create;
  FExtendedReport:=true;
end;

destructor TDisplay.Destroy;
begin
  FModes.Free;
  inherited;
end;

procedure TDisplay.Report(var sl: TStringList);
begin
  with sl do begin
    Add('[Display]');
    Add(Format('Adapter=%s',[Adapter]));
    Add(Format('Chipset=%s',[Chipset]));
    Add(Format('DAC=%s',[DAC]));
    Add(Format('Memory=%d',[Memory]));
    Add(Format('BIOSVersion=%s',[BIOSVersion]));
    Add(Format('BIOSDate=%s',[BIOSDate]));
    Add(Format('Technology=%s',[Technology]));
    Add(Format('HorzRes=%d',[HorzRes]));
    Add(Format('VertRes=%d',[VertRes]));
    Add(Format('ColorDepth=%d',[ColorDepth]));
    Add(Format('PixelWidth=%d',[PixelWidth]));
    Add(Format('PixelHeight=%d',[PixelHeight]));
    Add(Format('PixelDiag=%d',[PixelDiagonal]));
    Add(Format('FontRes=%d',[FontResolution]));
    if FExtendedReport then begin
      Add('[Video Modes]');
      StringsToRep(Modes,'Count','Mode',sl);
      Report_CurveCaps(sl);
      Report_LineCaps(sl);
      Report_PolygonCaps(sl);
      Report_RasterCaps(sl);
      Report_TextCaps(sl);
    end;  
  end;
end;


end.
