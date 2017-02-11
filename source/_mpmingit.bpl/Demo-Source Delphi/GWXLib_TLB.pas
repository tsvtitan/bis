unit GWXLib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 8291 $
// File generated on 03.04.2009 11:00:00 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\GWX6\gwx.dll (1)
// LIBID: {FA7A5EA3-D402-11D2-A719-00C00CB08F5B}
// LCID: 0
// Helpfile: 
// HelpString: GWX 1.0 Type Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\W2003S\system32\stdole2.tlb)
// Errors:
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'set' of IGWControl.exploreApply changed to 'set_'
//   Hint: Parameter 'Type' of IGWControl.exploreApply changed to 'Type_'
//   Hint: Parameter 'set' of IGWControl.exploreDbApply changed to 'set_'
//   Hint: Parameter 'Type' of IGWControl.exploreDbApply changed to 'Type_'
//   Error creating palette bitmap of (TGWTable) : Server C:\GWX6\gwx.dll contains no icons
//   Error creating palette bitmap of (TGWGraphics) : Server C:\GWX6\gwx.dll contains no icons
//   Error creating palette bitmap of (TGWRoute) : Server C:\GWX6\gwx.dll contains no icons
//   Error creating palette bitmap of (TGWStringList) : Server C:\GWX6\gwx.dll contains no icons
//   Error creating palette bitmap of (TGWObject) : Server C:\GWX6\gwx.dll contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  GWXLibMajorVersion = 1;
  GWXLibMinorVersion = 0;

  LIBID_GWXLib: TGUID = '{FA7A5EA3-D402-11D2-A719-00C00CB08F5B}';

  IID_IGWStringList: TGUID = '{BD885540-EAA1-11D2-A748-00C00CB08F5B}';
  IID_IGWObject: TGUID = '{84BB8F21-FB50-11D2-A754-00C00CB08F5B}';
  DIID__IGWControlEvents: TGUID = '{FA7A5EB1-D402-11D2-A719-00C00CB08F5B}';
  IID_IGWTable: TGUID = '{911F84E5-1A4A-11D3-B3C9-004033280B14}';
  IID_IGWRoute: TGUID = '{EB64D84A-4BC9-463D-B8FF-69E2220A3B06}';
  IID_IGWGraphics: TGUID = '{D61686E3-7BD3-11D3-B4A2-004033280B14}';
  IID_IGWControl: TGUID = '{FA7A5EAF-D402-11D2-A719-00C00CB08F5B}';
  IID_IGWProjection: TGUID = '{BBC4DE60-D974-11D2-A72A-00C00CB08F5B}';
  IID_IGWProjectionAcc: TGUID = '{EE91F415-4DE1-4789-9516-63DC1845617C}';
  CLASS_GWControl: TGUID = '{FA7A5EB0-D402-11D2-A719-00C00CB08F5B}';
  CLASS_GWTable: TGUID = '{42384EE2-1814-11D3-B3C7-004033280B14}';
  CLASS_GWGraphics: TGUID = '{D61686E4-7BD3-11D3-B4A2-004033280B14}';
  CLASS_GWRoute: TGUID = '{E7268863-2A7D-41E8-B77E-22E50F184484}';
  CLASS_GWStringList: TGUID = '{07DF5DA4-55AA-4CD9-B5FE-19BF0A55ADA2}';
  CLASS_GWObject: TGUID = '{662343F8-A007-486E-A567-DC8B6FFD08F9}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum tagGWX_ObjectType
type
  tagGWX_ObjectType = TOleEnum;
const
  GWX_GeoObject = $00000000;
  GWX_DBObject = $00000001;
  GWX_GraphicObject = $00000002;
  GWX_DBConObject = $00000003;
  GWX_UnknownObject = $FFFFFFFF;

// Constants for enum tagGWX_MouseAction
type
  tagGWX_MouseAction = TOleEnum;
const
  GWX_LButtonDown = $00000001;
  GWX_RButtonDown = $00000002;
  GWX_LButtonUp = $00000004;
  GWX_RButtonUp = $00000008;
  GWX_MouseMove = $00000010;
  GWX_LButtonDblClk = $00000020;
  GWX_RButtonDblClk = $00000040;

// Constants for enum GWX_KeyboardAction
type
  GWX_KeyboardAction = TOleEnum;
const
  GWX_Char = $00000001;
  GWX_KeyDown = $00000002;
  GWX_KeyUp = $00000003;
  GWX_SysKeyDown = $00000004;
  GWX_SysKeyUp = $00000005;

// Constants for enum GWX_RoutePointType
type
  GWX_RoutePointType = TOleEnum;
const
  GWX_RoutePointRestrict = $00000000;
  GWX_RoutePointStart = $00000001;
  GWX_RoutePointIntermediate = $00000002;
  GWX_RoutePointFinish = $00000003;

// Constants for enum tagGWX_DBF2MapResult
type
  tagGWX_DBF2MapResult = TOleEnum;
const
  GWX_DBF2Map_Ok = $00000000;
  GWX_DBF2Map_MapNoAttached = $00000001;
  GWX_DBF2Map_BadStyle = $00000002;
  GWX_DBF2Map_DBFNotFound = $00000003;
  GWX_DBF2Map_ServerError = $00000004;

// Constants for enum GWX_MouseType
type
  GWX_MouseType = TOleEnum;
const
  GWX_MouseTypeNull = $00000000;
  GWX_MouseTypeMove = $00000001;
  GWX_MouseTypeUp = $00000002;
  GWX_MouseTypeUpDown = $00000003;
  GWX_MouseTypeDown = $00000004;
  GWX_MouseTypeDownUp = $00000005;
  GWX_MouseTypeRotate = $00000006;
  GWX_MouseTypeCenter = $00000007;
  GWX_MouseTypeLocate = $00000008;

// Constants for enum tagGWX_MapType
type
  tagGWX_MapType = TOleEnum;
const
  GWX_MapTypeChart = $00000000;
  GWX_MapTypeChart1 = $00000001;
  GWX_MapTypePlan = $00000002;
  GWX_MapTypeTopo = $00000003;

// Constants for enum GWX_ProjectionType
type
  GWX_ProjectionType = TOleEnum;
const
  GWX_Projection_Null = $00000000;
  GWX_Projection_Merkator = $00000001;
  GWX_Projection_MerkatorSeamless = $00000002;
  GWX_Projection_Conical = $00000003;
  GWX_Projection_Spherical = $00000004;

// Constants for enum GWX_Errors
type
  GWX_Errors = TOleEnum;
const
  GWX_Ok = $00000000;
  GWX_AlreadyLoaded = $00000001;
  GWX_MapFileMissing = $00000002;
  GWX_InvalidMapFile = $00000003;
  GWX_UnknownFormat = $00000004;
  GWX_SystemError = $00000005;
  GWX_CodifierMissing = $00000006;
  GWX_LookupMissing = $00000007;
  GWX_HaspNotInstalled = $00000008;
  GWX_HaspNotFound = $00000009;
  GWX_LicenceMissing = $0000000A;
  GWX_MapNotLoaded = $0000000B;
  GWX_BadLoadCmd = $0000000C;
  GWX_BadStyle = $0000000D;
  GWX_NotTableObject = $0000000E;
  GWX_TableNotLoaded = $0000000F;
  GWX_ObjectsNotFound = $00000010;
  GWX_BaseNotLoaded = $00000011;
  GWX_BadLoadStructure = $00000012;
  GWX_BadLoadField = $00000013;
  GWX_LoadModeTwice = $00000014;
  GWX_LoadTableAndStruct = $00000015;
  GWX_FrameFileMissing = $00000016;
  GWX_RasterLoadError = $00000017;
  GWX_DesignLoadError = $00000018;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IGWStringList = interface;
  IGWStringListDisp = dispinterface;
  IGWObject = interface;
  IGWObjectDisp = dispinterface;
  _IGWControlEvents = dispinterface;
  IGWTable = interface;
  IGWTableDisp = dispinterface;
  IGWRoute = interface;
  IGWRouteDisp = dispinterface;
  IGWGraphics = interface;
  IGWGraphicsDisp = dispinterface;
  IGWControl = interface;
  IGWControlDisp = dispinterface;
  IGWProjection = interface;
  IGWProjectionAcc = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  GWControl = IGWControl;
  GWTable = IGWTable;
  GWGraphics = IGWGraphics;
  GWRoute = IGWRoute;
  GWStringList = IGWStringList;
  GWObject = IGWObject;


// *********************************************************************//
// Interface: IGWStringList
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {BD885540-EAA1-11D2-A748-00C00CB08F5B}
// *********************************************************************//
  IGWStringList = interface(IDispatch)
    ['{BD885540-EAA1-11D2-A748-00C00CB08F5B}']
    function Get_ItemCount: Integer; safecall;
    function MoveFirst: Integer; safecall;
    function MoveNext: Integer; safecall;
    function Get_Item: WideString; safecall;
    property ItemCount: Integer read Get_ItemCount;
    property Item: WideString read Get_Item;
  end;

// *********************************************************************//
// DispIntf:  IGWStringListDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {BD885540-EAA1-11D2-A748-00C00CB08F5B}
// *********************************************************************//
  IGWStringListDisp = dispinterface
    ['{BD885540-EAA1-11D2-A748-00C00CB08F5B}']
    property ItemCount: Integer readonly dispid 1;
    function MoveFirst: Integer; dispid 2;
    function MoveNext: Integer; dispid 3;
    property Item: WideString readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IGWObject
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {84BB8F21-FB50-11D2-A754-00C00CB08F5B}
// *********************************************************************//
  IGWObject = interface(IDispatch)
    ['{84BB8F21-FB50-11D2-A754-00C00CB08F5B}']
    function Get_ID: Integer; safecall;
    function Get_type_: tagGWX_ObjectType; safecall;
    function Get_Acronym: WideString; safecall;
    function Get_MetricsType: LongWord; safecall;
    function Get_Metrics(out paLen: OleVariant): OleVariant; safecall;
    function Get_Attributes: IUnknown; safecall;
    function getLinks(const nameDbf: WideString): IUnknown; safecall;
    function Get_Length: Integer; safecall;
    function Get_Square: Integer; safecall;
    function Get_Links: IUnknown; safecall;
    function Get_Visible: Integer; safecall;
    procedure Set_Visible(pVal: Integer); safecall;
    function Get_Marked: Integer; safecall;
    procedure Set_Marked(pVal: Integer); safecall;
    function Get_Contoured: Integer; safecall;
    procedure Set_Contoured(pVal: Integer); safecall;
    function Get_Twinkling: Integer; safecall;
    procedure Set_Twinkling(pVal: Integer); safecall;
    property ID: Integer read Get_ID;
    property type_: tagGWX_ObjectType read Get_type_;
    property Acronym: WideString read Get_Acronym;
    property MetricsType: LongWord read Get_MetricsType;
    property Metrics[out paLen: OleVariant]: OleVariant read Get_Metrics;
    property Attributes: IUnknown read Get_Attributes;
    property Length: Integer read Get_Length;
    property Square: Integer read Get_Square;
    property Links: IUnknown read Get_Links;
    property Visible: Integer read Get_Visible write Set_Visible;
    property Marked: Integer read Get_Marked write Set_Marked;
    property Contoured: Integer read Get_Contoured write Set_Contoured;
    property Twinkling: Integer read Get_Twinkling write Set_Twinkling;
  end;

// *********************************************************************//
// DispIntf:  IGWObjectDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {84BB8F21-FB50-11D2-A754-00C00CB08F5B}
// *********************************************************************//
  IGWObjectDisp = dispinterface
    ['{84BB8F21-FB50-11D2-A754-00C00CB08F5B}']
    property ID: Integer readonly dispid 1;
    property type_: tagGWX_ObjectType readonly dispid 2;
    property Acronym: WideString readonly dispid 3;
    property MetricsType: LongWord readonly dispid 4;
    property Metrics[out paLen: OleVariant]: OleVariant readonly dispid 5;
    property Attributes: IUnknown readonly dispid 6;
    function getLinks(const nameDbf: WideString): IUnknown; dispid 7;
    property Length: Integer readonly dispid 8;
    property Square: Integer readonly dispid 9;
    property Links: IUnknown readonly dispid 10;
    property Visible: Integer dispid 11;
    property Marked: Integer dispid 12;
    property Contoured: Integer dispid 13;
    property Twinkling: Integer dispid 14;
  end;

// *********************************************************************//
// DispIntf:  _IGWControlEvents
// Flags:     (4096) Dispatchable
// GUID:      {FA7A5EB1-D402-11D2-A719-00C00CB08F5B}
// *********************************************************************//
  _IGWControlEvents = dispinterface
    ['{FA7A5EB1-D402-11D2-A719-00C00CB08F5B}']
    procedure MouseAction(Action: tagGWX_MouseAction; uMsg: Integer; x: Integer; y: Integer; 
                          out bHandled: Integer); dispid 1;
    procedure SelfDraw(hDC: Integer; left: Integer; top: Integer; right: Integer; bottom: Integer); dispid 2;
    procedure Select(South: Double; West: Double; North: Double; East: Double); dispid 3;
    procedure KeyboardAction(Action: GWX_KeyboardAction; uMsg: Integer; KeyCode: Integer; 
                             out bHandled: Integer); dispid 4;
    procedure RouteProgress(PercentDone: Integer; var CanContinue: Integer); dispid 5;
    procedure DrawCoordGrid(var DeltaLat: Integer; var DeltaLon: Integer; var LineColor: Integer; 
                            var ZOrder: Integer); dispid 6;
  end;

// *********************************************************************//
// Interface: IGWTable
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {911F84E5-1A4A-11D3-B3C9-004033280B14}
// *********************************************************************//
  IGWTable = interface(IDispatch)
    ['{911F84E5-1A4A-11D3-B3C9-004033280B14}']
    function addNew: Integer; safecall;
    function colCount: Integer; safecall;
    function colName(ColIndex: Integer): WideString; safecall;
    function colType(ColIndex: Integer): WideString; safecall;
    function getIndex: Integer; safecall;
    function getValue(ColIndex: Integer): OleVariant; safecall;
    function MoveFirst: Integer; safecall;
    function moveLast: Integer; safecall;
    function MoveNext: Integer; safecall;
    function move(var1: OleVariant; var2: OleVariant; var3: OleVariant): Integer; safecall;
    function setValue(value: OleVariant; ColIndex: Integer): Integer; safecall;
    procedure sort(ColIndex: Integer; Asc: Integer; Dist: Integer); safecall;
    function rowCount: Integer; safecall;
    function getTable(ColIndex: Integer): IUnknown; safecall;
    function getText(ColIndex: Integer): WideString; safecall;
    procedure remove; safecall;
    function colDescription(ColIndex: Integer): WideString; safecall;
    function addColumn(const colType: WideString; const colName: WideString; 
                       const colDescription: WideString): Integer; safecall;
    function IndexOf(const colName: WideString): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IGWTableDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {911F84E5-1A4A-11D3-B3C9-004033280B14}
// *********************************************************************//
  IGWTableDisp = dispinterface
    ['{911F84E5-1A4A-11D3-B3C9-004033280B14}']
    function addNew: Integer; dispid 1;
    function colCount: Integer; dispid 2;
    function colName(ColIndex: Integer): WideString; dispid 3;
    function colType(ColIndex: Integer): WideString; dispid 4;
    function getIndex: Integer; dispid 5;
    function getValue(ColIndex: Integer): OleVariant; dispid 6;
    function MoveFirst: Integer; dispid 7;
    function moveLast: Integer; dispid 8;
    function MoveNext: Integer; dispid 9;
    function move(var1: OleVariant; var2: OleVariant; var3: OleVariant): Integer; dispid 10;
    function setValue(value: OleVariant; ColIndex: Integer): Integer; dispid 11;
    procedure sort(ColIndex: Integer; Asc: Integer; Dist: Integer); dispid 12;
    function rowCount: Integer; dispid 13;
    function getTable(ColIndex: Integer): IUnknown; dispid 14;
    function getText(ColIndex: Integer): WideString; dispid 15;
    procedure remove; dispid 16;
    function colDescription(ColIndex: Integer): WideString; dispid 17;
    function addColumn(const colType: WideString; const colName: WideString; 
                       const colDescription: WideString): Integer; dispid 18;
    function IndexOf(const colName: WideString): Integer; dispid 19;
  end;

// *********************************************************************//
// Interface: IGWRoute
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EB64D84A-4BC9-463D-B8FF-69E2220A3B06}
// *********************************************************************//
  IGWRoute = interface(IDispatch)
    ['{EB64D84A-4BC9-463D-B8FF-69E2220A3B06}']
    function Get_Width: Double; safecall;
    procedure Set_Width(pVal: Double); safecall;
    function Get_Height: Double; safecall;
    procedure Set_Height(pVal: Double); safecall;
    function Get_Weight: Double; safecall;
    procedure Set_Weight(pVal: Double); safecall;
    function Get_VehicleType: WideString; safecall;
    procedure Set_VehicleType(const pVal: WideString); safecall;
    function Get_StartTime: TDateTime; safecall;
    procedure Set_StartTime(pVal: TDateTime); safecall;
    function Get_OptimizeByTime: Integer; safecall;
    procedure Set_OptimizeByTime(pVal: Integer); safecall;
    function Get_ReorderPoints: Integer; safecall;
    procedure Set_ReorderPoints(pVal: Integer); safecall;
    function Get_ProgressDelay: Integer; safecall;
    procedure Set_ProgressDelay(pVal: Integer); safecall;
    function Get_VehicleTypes: IUnknown; safecall;
    function Get_RouteLength: Integer; safecall;
    function Get_RouteDuration: Integer; safecall;
    function Get_RoutePointsCount: Integer; safecall;
    function GetPointName(Lat: Double; Lon: Double): WideString; safecall;
    procedure DeletePoints; safecall;
    procedure AddPoint(Lat: Double; Lon: Double; PointType: GWX_RoutePointType; 
                       const Name: WideString; Index: Integer); safecall;
    function CalculateRoute: Integer; safecall;
    function GetRoute: IUnknown; safecall;
    function Get_Priority: Integer; safecall;
    procedure Set_Priority(pVal: Integer); safecall;
    function Get_OptimizeTimeRatio: Double; safecall;
    procedure Set_OptimizeTimeRatio(pVal: Double); safecall;
    function Get_OptimizePriorityRatio: Double; safecall;
    procedure Set_OptimizePriorityRatio(pVal: Double); safecall;
    function GetVariants: IUnknown; safecall;
    function GetVariantsTable: IUnknown; safecall;
    property Width: Double read Get_Width write Set_Width;
    property Height: Double read Get_Height write Set_Height;
    property Weight: Double read Get_Weight write Set_Weight;
    property VehicleType: WideString read Get_VehicleType write Set_VehicleType;
    property StartTime: TDateTime read Get_StartTime write Set_StartTime;
    property OptimizeByTime: Integer read Get_OptimizeByTime write Set_OptimizeByTime;
    property ReorderPoints: Integer read Get_ReorderPoints write Set_ReorderPoints;
    property ProgressDelay: Integer read Get_ProgressDelay write Set_ProgressDelay;
    property VehicleTypes: IUnknown read Get_VehicleTypes;
    property RouteLength: Integer read Get_RouteLength;
    property RouteDuration: Integer read Get_RouteDuration;
    property RoutePointsCount: Integer read Get_RoutePointsCount;
    property Priority: Integer read Get_Priority write Set_Priority;
    property OptimizeTimeRatio: Double read Get_OptimizeTimeRatio write Set_OptimizeTimeRatio;
    property OptimizePriorityRatio: Double read Get_OptimizePriorityRatio write Set_OptimizePriorityRatio;
  end;

// *********************************************************************//
// DispIntf:  IGWRouteDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EB64D84A-4BC9-463D-B8FF-69E2220A3B06}
// *********************************************************************//
  IGWRouteDisp = dispinterface
    ['{EB64D84A-4BC9-463D-B8FF-69E2220A3B06}']
    property Width: Double dispid 1;
    property Height: Double dispid 2;
    property Weight: Double dispid 3;
    property VehicleType: WideString dispid 4;
    property StartTime: TDateTime dispid 5;
    property OptimizeByTime: Integer dispid 6;
    property ReorderPoints: Integer dispid 7;
    property ProgressDelay: Integer dispid 8;
    property VehicleTypes: IUnknown readonly dispid 9;
    property RouteLength: Integer readonly dispid 10;
    property RouteDuration: Integer readonly dispid 11;
    property RoutePointsCount: Integer readonly dispid 12;
    function GetPointName(Lat: Double; Lon: Double): WideString; dispid 13;
    procedure DeletePoints; dispid 14;
    procedure AddPoint(Lat: Double; Lon: Double; PointType: GWX_RoutePointType; 
                       const Name: WideString; Index: Integer); dispid 15;
    function CalculateRoute: Integer; dispid 16;
    function GetRoute: IUnknown; dispid 17;
    property Priority: Integer dispid 18;
    property OptimizeTimeRatio: Double dispid 19;
    property OptimizePriorityRatio: Double dispid 20;
    function GetVariants: IUnknown; dispid 21;
    function GetVariantsTable: IUnknown; dispid 22;
  end;

// *********************************************************************//
// Interface: IGWGraphics
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D61686E3-7BD3-11D3-B4A2-004033280B14}
// *********************************************************************//
  IGWGraphics = interface(IDispatch)
    ['{D61686E3-7BD3-11D3-B4A2-004033280B14}']
    procedure load(const filename: WideString); safecall;
    procedure write(const filename: WideString); safecall;
    function getTable: IUnknown; safecall;
  end;

// *********************************************************************//
// DispIntf:  IGWGraphicsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D61686E3-7BD3-11D3-B4A2-004033280B14}
// *********************************************************************//
  IGWGraphicsDisp = dispinterface
    ['{D61686E3-7BD3-11D3-B4A2-004033280B14}']
    procedure load(const filename: WideString); dispid 1;
    procedure write(const filename: WideString); dispid 2;
    function getTable: IUnknown; dispid 3;
  end;

// *********************************************************************//
// Interface: IGWControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FA7A5EAF-D402-11D2-A719-00C00CB08F5B}
// *********************************************************************//
  IGWControl = interface(IDispatch)
    ['{FA7A5EAF-D402-11D2-A719-00C00CB08F5B}']
    function Get_MapName: WideString; safecall;
    procedure Set_MapName(const pVal: WideString); safecall;
    function Get_CurScale: Double; safecall;
    procedure Set_CurScale(pVal: Double); safecall;
    procedure SetGeoCenter(Lat: Double; Lon: Double); safecall;
    procedure GetGeoCenter(out Lat: Double; out Lon: Double); safecall;
    function Get_InfoTooltip: Integer; safecall;
    procedure Set_InfoTooltip(pVal: Integer); safecall;
    function Get_MapAttached: Integer; safecall;
    procedure Overview; safecall;
    function DBF2Map(const DBFPathName: WideString; const Style: WideString): tagGWX_DBF2MapResult; safecall;
    procedure DeleteDBF(const DBFName: WideString); safecall;
    function Get_DBFLoadedList: IUnknown; safecall;
    function GetInfo(Lat: Double; Lon: Double): IUnknown; safecall;
    function Search(const Context: WideString): IUnknown; safecall;
    function SearchAddress(const Address: WideString; out Lat: Double; out Lon: Double): Integer; safecall;
    function GetInfoRect(South: Double; West: Double; North: Double; East: Double): IUnknown; safecall;
    procedure selectObject(ID: Integer; Select: Integer); safecall;
    procedure Refresh; safecall;
    function getAliasCodes: IUnknown; safecall;
    function getAliasAttributes: IUnknown; safecall;
    function getObject(ID: Integer): IUnknown; safecall;
    function getModulePath: WideString; safecall;
    function Get_mouseLeftType: GWX_MouseType; safecall;
    procedure Set_mouseLeftType(pVal: GWX_MouseType); safecall;
    function Get_mouseRightType: GWX_MouseType; safecall;
    procedure Set_mouseRightType(pVal: GWX_MouseType); safecall;
    procedure getMapInfo(out TypeMap: tagGWX_MapType; out Scale: Integer; 
                         out paGeoFrame: OleVariant; out paMetreFrame: OleVariant); safecall;
    function getMeasure(coord: OleVariant): Integer; safecall;
    function getUnloaderDBF: IUnknown; safecall;
    function showAddress(const Address: WideString): Integer; safecall;
    function GetInfoPolygon(paPolygon: OleVariant; mode: Integer): IUnknown; safecall;
    procedure getBitmap(const sFileName: WideString; North: Double; West: Double; South: Double; 
                        East: Double; pixWidth: Integer; pixHeight: Integer; nFontSize: Integer); safecall;
    function getExplore: IUnknown; safecall;
    procedure exploreApply(const Name: WideString; set_: Integer; const Type_: WideString); safecall;
    function getExploreDb: IUnknown; safecall;
    procedure exploreDbApply(const Name: WideString; set_: Integer; const Type_: WideString); safecall;
    procedure setPassWord(const pw: WideString); safecall;
    procedure Geo2Dev(Lat: Double; Lon: Double; out x: Integer; out y: Integer); safecall;
    procedure Dev2GeoString(x: Integer; y: Integer; out Lat: WideString; out Lon: WideString); safecall;
    procedure Dev2Geo(x: Integer; y: Integer; out Lat: Double; out Lon: Double); safecall;
    function Get_CurAngle: Double; safecall;
    procedure Set_CurAngle(pVal: Double); safecall;
    function Get_CoordGrid: Integer; safecall;
    procedure Set_CoordGrid(pVal: Integer); safecall;
    function Get_SmoothDrawing: Integer; safecall;
    procedure Set_SmoothDrawing(pVal: Integer); safecall;
    function Get_ScrollBars: Integer; safecall;
    procedure Set_ScrollBars(pVal: Integer); safecall;
    function Get_ClientEdge: Integer; safecall;
    procedure Set_ClientEdge(pVal: Integer); safecall;
    function Get_QuickRedraw: Integer; safecall;
    procedure Set_QuickRedraw(pVal: Integer); safecall;
    function Get_Projection: GWX_ProjectionType; safecall;
    procedure Set_Projection(pVal: GWX_ProjectionType); safecall;
    function Get_LoadedMaps: IUnknown; safecall;
    function AddMap(const MapName: WideString; const LookupName: WideString): GWX_Errors; safecall;
    procedure RemoveMap(const MapName: WideString); safecall;
    function SetLookup(const LookupName: WideString; const MapName: WideString): Integer; safecall;
    function GetAvailableLookups(const MapOrCodifierName: WideString): IUnknown; safecall;
    function Table2Map(const LoadCmd: WideString; const Style: WideString; const pTable: IUnknown): GWX_Errors; safecall;
    function CreateGWTable: IUnknown; safecall;
    function CreateGWRoute(const MapName: WideString): IUnknown; safecall;
    function GetDistancePath(Lat1: Double; Lon1: Double; Lat2: Double; Lon2: Double; 
                             ResType: Integer): OleVariant; safecall;
    function FindNearestAddress(Lat: Double; Lon: Double): WideString; safecall;
    function getObjectTable(ID: Integer): IUnknown; safecall;
    procedure setObjectVisibility(ID: Integer; const visMode: WideString); safecall;
    function ModifyTable(const command: WideString; redraw: Integer): Integer; safecall;
    function Get_LicenceDialogLanguage: WideString; safecall;
    procedure Set_LicenceDialogLanguage(const pVal: WideString); safecall;
    property MapName: WideString read Get_MapName write Set_MapName;
    property CurScale: Double read Get_CurScale write Set_CurScale;
    property InfoTooltip: Integer read Get_InfoTooltip write Set_InfoTooltip;
    property MapAttached: Integer read Get_MapAttached;
    property DBFLoadedList: IUnknown read Get_DBFLoadedList;
    property mouseLeftType: GWX_MouseType read Get_mouseLeftType write Set_mouseLeftType;
    property mouseRightType: GWX_MouseType read Get_mouseRightType write Set_mouseRightType;
    property CurAngle: Double read Get_CurAngle write Set_CurAngle;
    property CoordGrid: Integer read Get_CoordGrid write Set_CoordGrid;
    property SmoothDrawing: Integer read Get_SmoothDrawing write Set_SmoothDrawing;
    property ScrollBars: Integer read Get_ScrollBars write Set_ScrollBars;
    property ClientEdge: Integer read Get_ClientEdge write Set_ClientEdge;
    property QuickRedraw: Integer read Get_QuickRedraw write Set_QuickRedraw;
    property Projection: GWX_ProjectionType read Get_Projection write Set_Projection;
    property LoadedMaps: IUnknown read Get_LoadedMaps;
    property LicenceDialogLanguage: WideString read Get_LicenceDialogLanguage write Set_LicenceDialogLanguage;
  end;

// *********************************************************************//
// DispIntf:  IGWControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FA7A5EAF-D402-11D2-A719-00C00CB08F5B}
// *********************************************************************//
  IGWControlDisp = dispinterface
    ['{FA7A5EAF-D402-11D2-A719-00C00CB08F5B}']
    property MapName: WideString dispid 1;
    property CurScale: Double dispid 2;
    procedure SetGeoCenter(Lat: Double; Lon: Double); dispid 3;
    procedure GetGeoCenter(out Lat: Double; out Lon: Double); dispid 4;
    property InfoTooltip: Integer dispid 5;
    property MapAttached: Integer readonly dispid 6;
    procedure Overview; dispid 7;
    function DBF2Map(const DBFPathName: WideString; const Style: WideString): tagGWX_DBF2MapResult; dispid 8;
    procedure DeleteDBF(const DBFName: WideString); dispid 9;
    property DBFLoadedList: IUnknown readonly dispid 10;
    function GetInfo(Lat: Double; Lon: Double): IUnknown; dispid 11;
    function Search(const Context: WideString): IUnknown; dispid 12;
    function SearchAddress(const Address: WideString; out Lat: Double; out Lon: Double): Integer; dispid 13;
    function GetInfoRect(South: Double; West: Double; North: Double; East: Double): IUnknown; dispid 14;
    procedure selectObject(ID: Integer; Select: Integer); dispid 15;
    procedure Refresh; dispid 18;
    function getAliasCodes: IUnknown; dispid 19;
    function getAliasAttributes: IUnknown; dispid 20;
    function getObject(ID: Integer): IUnknown; dispid 21;
    function getModulePath: WideString; dispid 22;
    property mouseLeftType: GWX_MouseType dispid 23;
    property mouseRightType: GWX_MouseType dispid 24;
    procedure getMapInfo(out TypeMap: tagGWX_MapType; out Scale: Integer; 
                         out paGeoFrame: OleVariant; out paMetreFrame: OleVariant); dispid 25;
    function getMeasure(coord: OleVariant): Integer; dispid 26;
    function getUnloaderDBF: IUnknown; dispid 27;
    function showAddress(const Address: WideString): Integer; dispid 28;
    function GetInfoPolygon(paPolygon: OleVariant; mode: Integer): IUnknown; dispid 29;
    procedure getBitmap(const sFileName: WideString; North: Double; West: Double; South: Double; 
                        East: Double; pixWidth: Integer; pixHeight: Integer; nFontSize: Integer); dispid 30;
    function getExplore: IUnknown; dispid 31;
    procedure exploreApply(const Name: WideString; set_: Integer; const Type_: WideString); dispid 33;
    function getExploreDb: IUnknown; dispid 34;
    procedure exploreDbApply(const Name: WideString; set_: Integer; const Type_: WideString); dispid 35;
    procedure setPassWord(const pw: WideString); dispid 36;
    procedure Geo2Dev(Lat: Double; Lon: Double; out x: Integer; out y: Integer); dispid 37;
    procedure Dev2GeoString(x: Integer; y: Integer; out Lat: WideString; out Lon: WideString); dispid 38;
    procedure Dev2Geo(x: Integer; y: Integer; out Lat: Double; out Lon: Double); dispid 39;
    property CurAngle: Double dispid 40;
    property CoordGrid: Integer dispid 41;
    property SmoothDrawing: Integer dispid 42;
    property ScrollBars: Integer dispid 43;
    property ClientEdge: Integer dispid 44;
    property QuickRedraw: Integer dispid 45;
    property Projection: GWX_ProjectionType dispid 46;
    property LoadedMaps: IUnknown readonly dispid 47;
    function AddMap(const MapName: WideString; const LookupName: WideString): GWX_Errors; dispid 48;
    procedure RemoveMap(const MapName: WideString); dispid 49;
    function SetLookup(const LookupName: WideString; const MapName: WideString): Integer; dispid 50;
    function GetAvailableLookups(const MapOrCodifierName: WideString): IUnknown; dispid 51;
    function Table2Map(const LoadCmd: WideString; const Style: WideString; const pTable: IUnknown): GWX_Errors; dispid 52;
    function CreateGWTable: IUnknown; dispid 53;
    function CreateGWRoute(const MapName: WideString): IUnknown; dispid 54;
    function GetDistancePath(Lat1: Double; Lon1: Double; Lat2: Double; Lon2: Double; 
                             ResType: Integer): OleVariant; dispid 55;
    function FindNearestAddress(Lat: Double; Lon: Double): WideString; dispid 56;
    function getObjectTable(ID: Integer): IUnknown; dispid 57;
    procedure setObjectVisibility(ID: Integer; const visMode: WideString); dispid 58;
    function ModifyTable(const command: WideString; redraw: Integer): Integer; dispid 59;
    property LicenceDialogLanguage: WideString dispid 60;
  end;

// *********************************************************************//
// Interface: IGWProjection
// Flags:     (0)
// GUID:      {BBC4DE60-D974-11D2-A72A-00C00CB08F5B}
// *********************************************************************//
  IGWProjection = interface(IUnknown)
    ['{BBC4DE60-D974-11D2-A72A-00C00CB08F5B}']
    function Dev2Geo(x: Integer; y: Integer; out Lat: Double; out Lon: Double): HResult; stdcall;
    function Geo2Dev(Lat: Double; Lon: Double; out x: Integer; out y: Integer): HResult; stdcall;
    function Dev2GeoString(x: Integer; y: Integer; out Lat: WideString; out Lon: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IGWProjectionAcc
// Flags:     (0)
// GUID:      {EE91F415-4DE1-4789-9516-63DC1845617C}
// *********************************************************************//
  IGWProjectionAcc = interface(IUnknown)
    ['{EE91F415-4DE1-4789-9516-63DC1845617C}']
    function Dev2GeoAcc(x: Integer; y: Integer; out Lat: Double; out Lon: Double): HResult; stdcall;
    function Geo2DevAcc(Lat: Double; Lon: Double; out x: Integer; out y: Integer): HResult; stdcall;
    function Dev2GeoStringAcc(x: Integer; y: Integer; out Lat: WideString; out Lon: WideString): HResult; stdcall;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TGWControl
// Help String      : GWControl Class
// Default Interface: IGWControl
// Def. Intf. DISP? : No
// Event   Interface: _IGWControlEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TGWControlMouseAction = procedure(ASender: TObject; Action: tagGWX_MouseAction; uMsg: Integer; 
                                                      x: Integer; y: Integer; out bHandled: Integer) of object;
  TGWControlSelfDraw = procedure(ASender: TObject; hDC: Integer; left: Integer; top: Integer; 
                                                   right: Integer; bottom: Integer) of object;
  TGWControlSelect = procedure(ASender: TObject; South: Double; West: Double; North: Double; 
                                                 East: Double) of object;
  TGWControlKeyboardAction = procedure(ASender: TObject; Action: GWX_KeyboardAction; uMsg: Integer; 
                                                         KeyCode: Integer; out bHandled: Integer) of object;
  TGWControlRouteProgress = procedure(ASender: TObject; PercentDone: Integer; 
                                                        var CanContinue: Integer) of object;
  TGWControlDrawCoordGrid = procedure(ASender: TObject; var DeltaLat: Integer; 
                                                        var DeltaLon: Integer; 
                                                        var LineColor: Integer; var ZOrder: Integer) of object;

  TGWControl = class(TOleControl)
  private
    FOnMouseAction: TGWControlMouseAction;
    FOnSelfDraw: TGWControlSelfDraw;
    FOnSelect: TGWControlSelect;
    FOnKeyboardAction: TGWControlKeyboardAction;
    FOnRouteProgress: TGWControlRouteProgress;
    FOnDrawCoordGrid: TGWControlDrawCoordGrid;
    FIntf: IGWControl;
    function  GetControlInterface: IGWControl;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_DBFLoadedList: IUnknown;
    function Get_LoadedMaps: IUnknown;
  public
    procedure SetGeoCenter(Lat: Double; Lon: Double);
    procedure GetGeoCenter(out Lat: Double; out Lon: Double);
    procedure Overview;
    function DBF2Map(const DBFPathName: WideString; const Style: WideString): tagGWX_DBF2MapResult;
    procedure DeleteDBF(const DBFName: WideString);
    function GetInfo(Lat: Double; Lon: Double): IUnknown;
    function Search(const Context: WideString): IUnknown;
    function SearchAddress(const Address: WideString; out Lat: Double; out Lon: Double): Integer;
    function GetInfoRect(South: Double; West: Double; North: Double; East: Double): IUnknown;
    procedure selectObject(ID: Integer; Select: Integer);
    procedure Refresh;
    function getAliasCodes: IUnknown;
    function getAliasAttributes: IUnknown;
    function getObject(ID: Integer): IUnknown;
    function getModulePath: WideString;
    procedure getMapInfo(out TypeMap: tagGWX_MapType; out Scale: Integer; 
                         out paGeoFrame: OleVariant; out paMetreFrame: OleVariant);
    function getMeasure(coord: OleVariant): Integer;
    function getUnloaderDBF: IUnknown;
    function showAddress(const Address: WideString): Integer;
    function GetInfoPolygon(paPolygon: OleVariant; mode: Integer): IUnknown;
    procedure getBitmap(const sFileName: WideString; North: Double; West: Double; South: Double; 
                        East: Double; pixWidth: Integer; pixHeight: Integer; nFontSize: Integer);
    function getExplore: IUnknown;
    procedure exploreApply(const Name: WideString; set_: Integer; const Type_: WideString);
    function getExploreDb: IUnknown;
    procedure exploreDbApply(const Name: WideString; set_: Integer; const Type_: WideString);
    procedure setPassWord(const pw: WideString);
    procedure Geo2Dev(Lat: Double; Lon: Double; out x: Integer; out y: Integer);
    procedure Dev2GeoString(x: Integer; y: Integer; out Lat: WideString; out Lon: WideString);
    procedure Dev2Geo(x: Integer; y: Integer; out Lat: Double; out Lon: Double);
    function AddMap(const MapName: WideString; const LookupName: WideString): GWX_Errors;
    procedure RemoveMap(const MapName: WideString);
    function SetLookup(const LookupName: WideString; const MapName: WideString): Integer;
    function GetAvailableLookups(const MapOrCodifierName: WideString): IUnknown;
    function Table2Map(const LoadCmd: WideString; const Style: WideString; const pTable: IUnknown): GWX_Errors;
    function CreateGWTable: IUnknown;
    function CreateGWRoute(const MapName: WideString): IUnknown;
    function GetDistancePath(Lat1: Double; Lon1: Double; Lat2: Double; Lon2: Double; 
                             ResType: Integer): OleVariant;
    function FindNearestAddress(Lat: Double; Lon: Double): WideString;
    function getObjectTable(ID: Integer): IUnknown;
    procedure setObjectVisibility(ID: Integer; const visMode: WideString);
    function ModifyTable(const command: WideString; redraw: Integer): Integer;
    property  ControlInterface: IGWControl read GetControlInterface;
    property  DefaultInterface: IGWControl read GetControlInterface;
    property MapAttached: Integer index 6 read GetIntegerProp;
    property DBFLoadedList: IUnknown index 10 read GetIUnknownProp;
    property LoadedMaps: IUnknown index 47 read GetIUnknownProp;
  published
    property Anchors;
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property MapName: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property CurScale: Double index 2 read GetDoubleProp write SetDoubleProp stored False;
    property InfoTooltip: Integer index 5 read GetIntegerProp write SetIntegerProp stored False;
    property mouseLeftType: TOleEnum index 23 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property mouseRightType: TOleEnum index 24 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property CurAngle: Double index 40 read GetDoubleProp write SetDoubleProp stored False;
    property CoordGrid: Integer index 41 read GetIntegerProp write SetIntegerProp stored False;
    property SmoothDrawing: Integer index 42 read GetIntegerProp write SetIntegerProp stored False;
    property ScrollBars: Integer index 43 read GetIntegerProp write SetIntegerProp stored False;
    property ClientEdge: Integer index 44 read GetIntegerProp write SetIntegerProp stored False;
    property QuickRedraw: Integer index 45 read GetIntegerProp write SetIntegerProp stored False;
    property Projection: TOleEnum index 46 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property LicenceDialogLanguage: WideString index 60 read GetWideStringProp write SetWideStringProp stored False;
    property OnMouseAction: TGWControlMouseAction read FOnMouseAction write FOnMouseAction;
    property OnSelfDraw: TGWControlSelfDraw read FOnSelfDraw write FOnSelfDraw;
    property OnSelect: TGWControlSelect read FOnSelect write FOnSelect;
    property OnKeyboardAction: TGWControlKeyboardAction read FOnKeyboardAction write FOnKeyboardAction;
    property OnRouteProgress: TGWControlRouteProgress read FOnRouteProgress write FOnRouteProgress;
    property OnDrawCoordGrid: TGWControlDrawCoordGrid read FOnDrawCoordGrid write FOnDrawCoordGrid;
  end;

// *********************************************************************//
// The Class CoGWTable provides a Create and CreateRemote method to          
// create instances of the default interface IGWTable exposed by              
// the CoClass GWTable. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGWTable = class
    class function Create: IGWTable;
    class function CreateRemote(const MachineName: string): IGWTable;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TGWTable
// Help String      : GWTable Class
// Default Interface: IGWTable
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TGWTableProperties= class;
{$ENDIF}
  TGWTable = class(TOleServer)
  private
    FIntf: IGWTable;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TGWTableProperties;
    function GetServerProperties: TGWTableProperties;
{$ENDIF}
    function GetDefaultInterface: IGWTable;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IGWTable);
    procedure Disconnect; override;
    function addNew: Integer;
    function colCount: Integer;
    function colName(ColIndex: Integer): WideString;
    function colType(ColIndex: Integer): WideString;
    function getIndex: Integer;
    function getValue(ColIndex: Integer): OleVariant;
    function MoveFirst: Integer;
    function moveLast: Integer;
    function MoveNext: Integer;
    function move(var1: OleVariant; var2: OleVariant; var3: OleVariant): Integer;
    function setValue(value: OleVariant; ColIndex: Integer): Integer;
    procedure sort(ColIndex: Integer; Asc: Integer; Dist: Integer);
    function rowCount: Integer;
    function getTable(ColIndex: Integer): IUnknown;
    function getText(ColIndex: Integer): WideString;
    procedure remove;
    function colDescription(ColIndex: Integer): WideString;
    function addColumn(const colType: WideString; const colName: WideString; 
                       const colDescription: WideString): Integer;
    function IndexOf(const colName: WideString): Integer;
    property DefaultInterface: IGWTable read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TGWTableProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TGWTable
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TGWTableProperties = class(TPersistent)
  private
    FServer:    TGWTable;
    function    GetDefaultInterface: IGWTable;
    constructor Create(AServer: TGWTable);
  protected
  public
    property DefaultInterface: IGWTable read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoGWGraphics provides a Create and CreateRemote method to          
// create instances of the default interface IGWGraphics exposed by              
// the CoClass GWGraphics. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGWGraphics = class
    class function Create: IGWGraphics;
    class function CreateRemote(const MachineName: string): IGWGraphics;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TGWGraphics
// Help String      : GWGraphics Class
// Default Interface: IGWGraphics
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TGWGraphicsProperties= class;
{$ENDIF}
  TGWGraphics = class(TOleServer)
  private
    FIntf: IGWGraphics;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TGWGraphicsProperties;
    function GetServerProperties: TGWGraphicsProperties;
{$ENDIF}
    function GetDefaultInterface: IGWGraphics;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IGWGraphics);
    procedure Disconnect; override;
    procedure load(const filename: WideString);
    procedure write(const filename: WideString);
    function getTable: IUnknown;
    property DefaultInterface: IGWGraphics read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TGWGraphicsProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TGWGraphics
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TGWGraphicsProperties = class(TPersistent)
  private
    FServer:    TGWGraphics;
    function    GetDefaultInterface: IGWGraphics;
    constructor Create(AServer: TGWGraphics);
  protected
  public
    property DefaultInterface: IGWGraphics read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoGWRoute provides a Create and CreateRemote method to          
// create instances of the default interface IGWRoute exposed by              
// the CoClass GWRoute. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGWRoute = class
    class function Create: IGWRoute;
    class function CreateRemote(const MachineName: string): IGWRoute;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TGWRoute
// Help String      : GWRoute Class
// Default Interface: IGWRoute
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TGWRouteProperties= class;
{$ENDIF}
  TGWRoute = class(TOleServer)
  private
    FIntf: IGWRoute;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TGWRouteProperties;
    function GetServerProperties: TGWRouteProperties;
{$ENDIF}
    function GetDefaultInterface: IGWRoute;
  protected
    procedure InitServerData; override;
    function Get_Width: Double;
    procedure Set_Width(pVal: Double);
    function Get_Height: Double;
    procedure Set_Height(pVal: Double);
    function Get_Weight: Double;
    procedure Set_Weight(pVal: Double);
    function Get_VehicleType: WideString;
    procedure Set_VehicleType(const pVal: WideString);
    function Get_StartTime: TDateTime;
    procedure Set_StartTime(pVal: TDateTime);
    function Get_OptimizeByTime: Integer;
    procedure Set_OptimizeByTime(pVal: Integer);
    function Get_ReorderPoints: Integer;
    procedure Set_ReorderPoints(pVal: Integer);
    function Get_ProgressDelay: Integer;
    procedure Set_ProgressDelay(pVal: Integer);
    function Get_VehicleTypes: IUnknown;
    function Get_RouteLength: Integer;
    function Get_RouteDuration: Integer;
    function Get_RoutePointsCount: Integer;
    function Get_Priority: Integer;
    procedure Set_Priority(pVal: Integer);
    function Get_OptimizeTimeRatio: Double;
    procedure Set_OptimizeTimeRatio(pVal: Double);
    function Get_OptimizePriorityRatio: Double;
    procedure Set_OptimizePriorityRatio(pVal: Double);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IGWRoute);
    procedure Disconnect; override;
    function GetPointName(Lat: Double; Lon: Double): WideString;
    procedure DeletePoints;
    procedure AddPoint(Lat: Double; Lon: Double; PointType: GWX_RoutePointType; 
                       const Name: WideString; Index: Integer);
    function CalculateRoute: Integer;
    function GetRoute: IUnknown;
    function GetVariants: IUnknown;
    function GetVariantsTable: IUnknown;
    property DefaultInterface: IGWRoute read GetDefaultInterface;
    property VehicleTypes: IUnknown read Get_VehicleTypes;
    property RouteLength: Integer read Get_RouteLength;
    property RouteDuration: Integer read Get_RouteDuration;
    property RoutePointsCount: Integer read Get_RoutePointsCount;
    property Width: Double read Get_Width write Set_Width;
    property Height: Double read Get_Height write Set_Height;
    property Weight: Double read Get_Weight write Set_Weight;
    property VehicleType: WideString read Get_VehicleType write Set_VehicleType;
    property StartTime: TDateTime read Get_StartTime write Set_StartTime;
    property OptimizeByTime: Integer read Get_OptimizeByTime write Set_OptimizeByTime;
    property ReorderPoints: Integer read Get_ReorderPoints write Set_ReorderPoints;
    property ProgressDelay: Integer read Get_ProgressDelay write Set_ProgressDelay;
    property Priority: Integer read Get_Priority write Set_Priority;
    property OptimizeTimeRatio: Double read Get_OptimizeTimeRatio write Set_OptimizeTimeRatio;
    property OptimizePriorityRatio: Double read Get_OptimizePriorityRatio write Set_OptimizePriorityRatio;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TGWRouteProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TGWRoute
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TGWRouteProperties = class(TPersistent)
  private
    FServer:    TGWRoute;
    function    GetDefaultInterface: IGWRoute;
    constructor Create(AServer: TGWRoute);
  protected
    function Get_Width: Double;
    procedure Set_Width(pVal: Double);
    function Get_Height: Double;
    procedure Set_Height(pVal: Double);
    function Get_Weight: Double;
    procedure Set_Weight(pVal: Double);
    function Get_VehicleType: WideString;
    procedure Set_VehicleType(const pVal: WideString);
    function Get_StartTime: TDateTime;
    procedure Set_StartTime(pVal: TDateTime);
    function Get_OptimizeByTime: Integer;
    procedure Set_OptimizeByTime(pVal: Integer);
    function Get_ReorderPoints: Integer;
    procedure Set_ReorderPoints(pVal: Integer);
    function Get_ProgressDelay: Integer;
    procedure Set_ProgressDelay(pVal: Integer);
    function Get_VehicleTypes: IUnknown;
    function Get_RouteLength: Integer;
    function Get_RouteDuration: Integer;
    function Get_RoutePointsCount: Integer;
    function Get_Priority: Integer;
    procedure Set_Priority(pVal: Integer);
    function Get_OptimizeTimeRatio: Double;
    procedure Set_OptimizeTimeRatio(pVal: Double);
    function Get_OptimizePriorityRatio: Double;
    procedure Set_OptimizePriorityRatio(pVal: Double);
  public
    property DefaultInterface: IGWRoute read GetDefaultInterface;
  published
    property Width: Double read Get_Width write Set_Width;
    property Height: Double read Get_Height write Set_Height;
    property Weight: Double read Get_Weight write Set_Weight;
    property VehicleType: WideString read Get_VehicleType write Set_VehicleType;
    property StartTime: TDateTime read Get_StartTime write Set_StartTime;
    property OptimizeByTime: Integer read Get_OptimizeByTime write Set_OptimizeByTime;
    property ReorderPoints: Integer read Get_ReorderPoints write Set_ReorderPoints;
    property ProgressDelay: Integer read Get_ProgressDelay write Set_ProgressDelay;
    property Priority: Integer read Get_Priority write Set_Priority;
    property OptimizeTimeRatio: Double read Get_OptimizeTimeRatio write Set_OptimizeTimeRatio;
    property OptimizePriorityRatio: Double read Get_OptimizePriorityRatio write Set_OptimizePriorityRatio;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoGWStringList provides a Create and CreateRemote method to          
// create instances of the default interface IGWStringList exposed by              
// the CoClass GWStringList. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGWStringList = class
    class function Create: IGWStringList;
    class function CreateRemote(const MachineName: string): IGWStringList;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TGWStringList
// Help String      : GWStringList Class
// Default Interface: IGWStringList
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TGWStringListProperties= class;
{$ENDIF}
  TGWStringList = class(TOleServer)
  private
    FIntf: IGWStringList;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TGWStringListProperties;
    function GetServerProperties: TGWStringListProperties;
{$ENDIF}
    function GetDefaultInterface: IGWStringList;
  protected
    procedure InitServerData; override;
    function Get_ItemCount: Integer;
    function Get_Item: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IGWStringList);
    procedure Disconnect; override;
    function MoveFirst: Integer;
    function MoveNext: Integer;
    property DefaultInterface: IGWStringList read GetDefaultInterface;
    property ItemCount: Integer read Get_ItemCount;
    property Item: WideString read Get_Item;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TGWStringListProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TGWStringList
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TGWStringListProperties = class(TPersistent)
  private
    FServer:    TGWStringList;
    function    GetDefaultInterface: IGWStringList;
    constructor Create(AServer: TGWStringList);
  protected
    function Get_ItemCount: Integer;
    function Get_Item: WideString;
  public
    property DefaultInterface: IGWStringList read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoGWObject provides a Create and CreateRemote method to          
// create instances of the default interface IGWObject exposed by              
// the CoClass GWObject. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGWObject = class
    class function Create: IGWObject;
    class function CreateRemote(const MachineName: string): IGWObject;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TGWObject
// Help String      : GWObject Class
// Default Interface: IGWObject
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TGWObjectProperties= class;
{$ENDIF}
  TGWObject = class(TOleServer)
  private
    FIntf: IGWObject;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TGWObjectProperties;
    function GetServerProperties: TGWObjectProperties;
{$ENDIF}
    function GetDefaultInterface: IGWObject;
  protected
    procedure InitServerData; override;
    function Get_ID: Integer;
    function Get_type_: tagGWX_ObjectType;
    function Get_Acronym: WideString;
    function Get_MetricsType: LongWord;
    function Get_Metrics(out paLen: OleVariant): OleVariant;
    function Get_Attributes: IUnknown;
    function Get_Length: Integer;
    function Get_Square: Integer;
    function Get_Links: IUnknown;
    function Get_Visible: Integer;
    procedure Set_Visible(pVal: Integer);
    function Get_Marked: Integer;
    procedure Set_Marked(pVal: Integer);
    function Get_Contoured: Integer;
    procedure Set_Contoured(pVal: Integer);
    function Get_Twinkling: Integer;
    procedure Set_Twinkling(pVal: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IGWObject);
    procedure Disconnect; override;
    function getLinks(const nameDbf: WideString): IUnknown;
    property DefaultInterface: IGWObject read GetDefaultInterface;
    property ID: Integer read Get_ID;
    property type_: tagGWX_ObjectType read Get_type_;
    property Acronym: WideString read Get_Acronym;
    property MetricsType: LongWord read Get_MetricsType;
    property Metrics[out paLen: OleVariant]: OleVariant read Get_Metrics;
    property Attributes: IUnknown read Get_Attributes;
    property Length: Integer read Get_Length;
    property Square: Integer read Get_Square;
    property Links: IUnknown read Get_Links;
    property Visible: Integer read Get_Visible write Set_Visible;
    property Marked: Integer read Get_Marked write Set_Marked;
    property Contoured: Integer read Get_Contoured write Set_Contoured;
    property Twinkling: Integer read Get_Twinkling write Set_Twinkling;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TGWObjectProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TGWObject
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TGWObjectProperties = class(TPersistent)
  private
    FServer:    TGWObject;
    function    GetDefaultInterface: IGWObject;
    constructor Create(AServer: TGWObject);
  protected
    function Get_ID: Integer;
    function Get_type_: tagGWX_ObjectType;
    function Get_Acronym: WideString;
    function Get_MetricsType: LongWord;
    function Get_Metrics(out paLen: OleVariant): OleVariant;
    function Get_Attributes: IUnknown;
    function Get_Length: Integer;
    function Get_Square: Integer;
    function Get_Links: IUnknown;
    function Get_Visible: Integer;
    procedure Set_Visible(pVal: Integer);
    function Get_Marked: Integer;
    procedure Set_Marked(pVal: Integer);
    function Get_Contoured: Integer;
    procedure Set_Contoured(pVal: Integer);
    function Get_Twinkling: Integer;
    procedure Set_Twinkling(pVal: Integer);
  public
    property DefaultInterface: IGWObject read GetDefaultInterface;
  published
    property Visible: Integer read Get_Visible write Set_Visible;
    property Marked: Integer read Get_Marked write Set_Marked;
    property Contoured: Integer read Get_Contoured write Set_Contoured;
    property Twinkling: Integer read Get_Twinkling write Set_Twinkling;
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TGWControl.InitControlData;
const
  CEventDispIDs: array [0..5] of DWORD = (
    $00000001, $00000002, $00000003, $00000004, $00000005, $00000006);
  CControlData: TControlData2 = (
    ClassID: '{FA7A5EB0-D402-11D2-A719-00C00CB08F5B}';
    EventIID: '{FA7A5EB1-D402-11D2-A719-00C00CB08F5B}';
    EventCount: 6;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnMouseAction) - Cardinal(Self);
end;

procedure TGWControl.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IGWControl;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TGWControl.GetControlInterface: IGWControl;
begin
  CreateControl;
  Result := FIntf;
end;

function TGWControl.Get_DBFLoadedList: IUnknown;
begin
    Result := DefaultInterface.DBFLoadedList;
end;

function TGWControl.Get_LoadedMaps: IUnknown;
begin
    Result := DefaultInterface.LoadedMaps;
end;

procedure TGWControl.SetGeoCenter(Lat: Double; Lon: Double);
begin
  DefaultInterface.SetGeoCenter(Lat, Lon);
end;

procedure TGWControl.GetGeoCenter(out Lat: Double; out Lon: Double);
begin
  DefaultInterface.GetGeoCenter(Lat, Lon);
end;

procedure TGWControl.Overview;
begin
  DefaultInterface.Overview;
end;

function TGWControl.DBF2Map(const DBFPathName: WideString; const Style: WideString): tagGWX_DBF2MapResult;
begin
  Result := DefaultInterface.DBF2Map(DBFPathName, Style);
end;

procedure TGWControl.DeleteDBF(const DBFName: WideString);
begin
  DefaultInterface.DeleteDBF(DBFName);
end;

function TGWControl.GetInfo(Lat: Double; Lon: Double): IUnknown;
begin
  Result := DefaultInterface.GetInfo(Lat, Lon);
end;

function TGWControl.Search(const Context: WideString): IUnknown;
begin
  Result := DefaultInterface.Search(Context);
end;

function TGWControl.SearchAddress(const Address: WideString; out Lat: Double; out Lon: Double): Integer;
begin
  Result := DefaultInterface.SearchAddress(Address, Lat, Lon);
end;

function TGWControl.GetInfoRect(South: Double; West: Double; North: Double; East: Double): IUnknown;
begin
  Result := DefaultInterface.GetInfoRect(South, West, North, East);
end;

procedure TGWControl.selectObject(ID: Integer; Select: Integer);
begin
  DefaultInterface.selectObject(ID, Select);
end;

procedure TGWControl.Refresh;
begin
  DefaultInterface.Refresh;
end;

function TGWControl.getAliasCodes: IUnknown;
begin
  Result := DefaultInterface.getAliasCodes;
end;

function TGWControl.getAliasAttributes: IUnknown;
begin
  Result := DefaultInterface.getAliasAttributes;
end;

function TGWControl.getObject(ID: Integer): IUnknown;
begin
  Result := DefaultInterface.getObject(ID);
end;

function TGWControl.getModulePath: WideString;
begin
  Result := DefaultInterface.getModulePath;
end;

procedure TGWControl.getMapInfo(out TypeMap: tagGWX_MapType; out Scale: Integer; 
                                out paGeoFrame: OleVariant; out paMetreFrame: OleVariant);
begin
  DefaultInterface.getMapInfo(TypeMap, Scale, paGeoFrame, paMetreFrame);
end;

function TGWControl.getMeasure(coord: OleVariant): Integer;
begin
  Result := DefaultInterface.getMeasure(coord);
end;

function TGWControl.getUnloaderDBF: IUnknown;
begin
  Result := DefaultInterface.getUnloaderDBF;
end;

function TGWControl.showAddress(const Address: WideString): Integer;
begin
  Result := DefaultInterface.showAddress(Address);
end;

function TGWControl.GetInfoPolygon(paPolygon: OleVariant; mode: Integer): IUnknown;
begin
  Result := DefaultInterface.GetInfoPolygon(paPolygon, mode);
end;

procedure TGWControl.getBitmap(const sFileName: WideString; North: Double; West: Double; 
                               South: Double; East: Double; pixWidth: Integer; pixHeight: Integer; 
                               nFontSize: Integer);
begin
  DefaultInterface.getBitmap(sFileName, North, West, South, East, pixWidth, pixHeight, nFontSize);
end;

function TGWControl.getExplore: IUnknown;
begin
  Result := DefaultInterface.getExplore;
end;

procedure TGWControl.exploreApply(const Name: WideString; set_: Integer; const Type_: WideString);
begin
  DefaultInterface.exploreApply(Name, set_, Type_);
end;

function TGWControl.getExploreDb: IUnknown;
begin
  Result := DefaultInterface.getExploreDb;
end;

procedure TGWControl.exploreDbApply(const Name: WideString; set_: Integer; const Type_: WideString);
begin
  DefaultInterface.exploreDbApply(Name, set_, Type_);
end;

procedure TGWControl.setPassWord(const pw: WideString);
begin
  DefaultInterface.setPassWord(pw);
end;

procedure TGWControl.Geo2Dev(Lat: Double; Lon: Double; out x: Integer; out y: Integer);
begin
  DefaultInterface.Geo2Dev(Lat, Lon, x, y);
end;

procedure TGWControl.Dev2GeoString(x: Integer; y: Integer; out Lat: WideString; out Lon: WideString);
begin
  DefaultInterface.Dev2GeoString(x, y, Lat, Lon);
end;

procedure TGWControl.Dev2Geo(x: Integer; y: Integer; out Lat: Double; out Lon: Double);
begin
  DefaultInterface.Dev2Geo(x, y, Lat, Lon);
end;

function TGWControl.AddMap(const MapName: WideString; const LookupName: WideString): GWX_Errors;
begin
  Result := DefaultInterface.AddMap(MapName, LookupName);
end;

procedure TGWControl.RemoveMap(const MapName: WideString);
begin
  DefaultInterface.RemoveMap(MapName);
end;

function TGWControl.SetLookup(const LookupName: WideString; const MapName: WideString): Integer;
begin
  Result := DefaultInterface.SetLookup(LookupName, MapName);
end;

function TGWControl.GetAvailableLookups(const MapOrCodifierName: WideString): IUnknown;
begin
  Result := DefaultInterface.GetAvailableLookups(MapOrCodifierName);
end;

function TGWControl.Table2Map(const LoadCmd: WideString; const Style: WideString; 
                              const pTable: IUnknown): GWX_Errors;
begin
  Result := DefaultInterface.Table2Map(LoadCmd, Style, pTable);
end;

function TGWControl.CreateGWTable: IUnknown;
begin
  Result := DefaultInterface.CreateGWTable;
end;

function TGWControl.CreateGWRoute(const MapName: WideString): IUnknown;
begin
  Result := DefaultInterface.CreateGWRoute(MapName);
end;

function TGWControl.GetDistancePath(Lat1: Double; Lon1: Double; Lat2: Double; Lon2: Double; 
                                    ResType: Integer): OleVariant;
begin
  Result := DefaultInterface.GetDistancePath(Lat1, Lon1, Lat2, Lon2, ResType);
end;

function TGWControl.FindNearestAddress(Lat: Double; Lon: Double): WideString;
begin
  Result := DefaultInterface.FindNearestAddress(Lat, Lon);
end;

function TGWControl.getObjectTable(ID: Integer): IUnknown;
begin
  Result := DefaultInterface.getObjectTable(ID);
end;

procedure TGWControl.setObjectVisibility(ID: Integer; const visMode: WideString);
begin
  DefaultInterface.setObjectVisibility(ID, visMode);
end;

function TGWControl.ModifyTable(const command: WideString; redraw: Integer): Integer;
begin
  Result := DefaultInterface.ModifyTable(command, redraw);
end;

class function CoGWTable.Create: IGWTable;
begin
  Result := CreateComObject(CLASS_GWTable) as IGWTable;
end;

class function CoGWTable.CreateRemote(const MachineName: string): IGWTable;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GWTable) as IGWTable;
end;

procedure TGWTable.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{42384EE2-1814-11D3-B3C7-004033280B14}';
    IntfIID:   '{911F84E5-1A4A-11D3-B3C9-004033280B14}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGWTable.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IGWTable;
  end;
end;

procedure TGWTable.ConnectTo(svrIntf: IGWTable);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TGWTable.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TGWTable.GetDefaultInterface: IGWTable;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TGWTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TGWTableProperties.Create(Self);
{$ENDIF}
end;

destructor TGWTable.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TGWTable.GetServerProperties: TGWTableProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TGWTable.addNew: Integer;
begin
  Result := DefaultInterface.addNew;
end;

function TGWTable.colCount: Integer;
begin
  Result := DefaultInterface.colCount;
end;

function TGWTable.colName(ColIndex: Integer): WideString;
begin
  Result := DefaultInterface.colName(ColIndex);
end;

function TGWTable.colType(ColIndex: Integer): WideString;
begin
  Result := DefaultInterface.colType(ColIndex);
end;

function TGWTable.getIndex: Integer;
begin
  Result := DefaultInterface.getIndex;
end;

function TGWTable.getValue(ColIndex: Integer): OleVariant;
begin
  Result := DefaultInterface.getValue(ColIndex);
end;

function TGWTable.MoveFirst: Integer;
begin
  Result := DefaultInterface.MoveFirst;
end;

function TGWTable.moveLast: Integer;
begin
  Result := DefaultInterface.moveLast;
end;

function TGWTable.MoveNext: Integer;
begin
  Result := DefaultInterface.MoveNext;
end;

function TGWTable.move(var1: OleVariant; var2: OleVariant; var3: OleVariant): Integer;
begin
  Result := DefaultInterface.move(var1, var2, var3);
end;

function TGWTable.setValue(value: OleVariant; ColIndex: Integer): Integer;
begin
  Result := DefaultInterface.setValue(value, ColIndex);
end;

procedure TGWTable.sort(ColIndex: Integer; Asc: Integer; Dist: Integer);
begin
  DefaultInterface.sort(ColIndex, Asc, Dist);
end;

function TGWTable.rowCount: Integer;
begin
  Result := DefaultInterface.rowCount;
end;

function TGWTable.getTable(ColIndex: Integer): IUnknown;
begin
  Result := DefaultInterface.getTable(ColIndex);
end;

function TGWTable.getText(ColIndex: Integer): WideString;
begin
  Result := DefaultInterface.getText(ColIndex);
end;

procedure TGWTable.remove;
begin
  DefaultInterface.remove;
end;

function TGWTable.colDescription(ColIndex: Integer): WideString;
begin
  Result := DefaultInterface.colDescription(ColIndex);
end;

function TGWTable.addColumn(const colType: WideString; const colName: WideString; 
                            const colDescription: WideString): Integer;
begin
  Result := DefaultInterface.addColumn(colType, colName, colDescription);
end;

function TGWTable.IndexOf(const colName: WideString): Integer;
begin
  Result := DefaultInterface.IndexOf(colName);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TGWTableProperties.Create(AServer: TGWTable);
begin
  inherited Create;
  FServer := AServer;
end;

function TGWTableProperties.GetDefaultInterface: IGWTable;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoGWGraphics.Create: IGWGraphics;
begin
  Result := CreateComObject(CLASS_GWGraphics) as IGWGraphics;
end;

class function CoGWGraphics.CreateRemote(const MachineName: string): IGWGraphics;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GWGraphics) as IGWGraphics;
end;

procedure TGWGraphics.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{D61686E4-7BD3-11D3-B4A2-004033280B14}';
    IntfIID:   '{D61686E3-7BD3-11D3-B4A2-004033280B14}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGWGraphics.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IGWGraphics;
  end;
end;

procedure TGWGraphics.ConnectTo(svrIntf: IGWGraphics);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TGWGraphics.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TGWGraphics.GetDefaultInterface: IGWGraphics;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TGWGraphics.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TGWGraphicsProperties.Create(Self);
{$ENDIF}
end;

destructor TGWGraphics.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TGWGraphics.GetServerProperties: TGWGraphicsProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TGWGraphics.load(const filename: WideString);
begin
  DefaultInterface.load(filename);
end;

procedure TGWGraphics.write(const filename: WideString);
begin
  DefaultInterface.write(filename);
end;

function TGWGraphics.getTable: IUnknown;
begin
  Result := DefaultInterface.getTable;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TGWGraphicsProperties.Create(AServer: TGWGraphics);
begin
  inherited Create;
  FServer := AServer;
end;

function TGWGraphicsProperties.GetDefaultInterface: IGWGraphics;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoGWRoute.Create: IGWRoute;
begin
  Result := CreateComObject(CLASS_GWRoute) as IGWRoute;
end;

class function CoGWRoute.CreateRemote(const MachineName: string): IGWRoute;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GWRoute) as IGWRoute;
end;

procedure TGWRoute.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{E7268863-2A7D-41E8-B77E-22E50F184484}';
    IntfIID:   '{EB64D84A-4BC9-463D-B8FF-69E2220A3B06}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGWRoute.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IGWRoute;
  end;
end;

procedure TGWRoute.ConnectTo(svrIntf: IGWRoute);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TGWRoute.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TGWRoute.GetDefaultInterface: IGWRoute;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TGWRoute.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TGWRouteProperties.Create(Self);
{$ENDIF}
end;

destructor TGWRoute.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TGWRoute.GetServerProperties: TGWRouteProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TGWRoute.Get_Width: Double;
begin
    Result := DefaultInterface.Width;
end;

procedure TGWRoute.Set_Width(pVal: Double);
begin
  DefaultInterface.Set_Width(pVal);
end;

function TGWRoute.Get_Height: Double;
begin
    Result := DefaultInterface.Height;
end;

procedure TGWRoute.Set_Height(pVal: Double);
begin
  DefaultInterface.Set_Height(pVal);
end;

function TGWRoute.Get_Weight: Double;
begin
    Result := DefaultInterface.Weight;
end;

procedure TGWRoute.Set_Weight(pVal: Double);
begin
  DefaultInterface.Set_Weight(pVal);
end;

function TGWRoute.Get_VehicleType: WideString;
begin
    Result := DefaultInterface.VehicleType;
end;

procedure TGWRoute.Set_VehicleType(const pVal: WideString);
  { Warning: The property VehicleType has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.VehicleType := pVal;
end;

function TGWRoute.Get_StartTime: TDateTime;
begin
    Result := DefaultInterface.StartTime;
end;

procedure TGWRoute.Set_StartTime(pVal: TDateTime);
begin
  DefaultInterface.Set_StartTime(pVal);
end;

function TGWRoute.Get_OptimizeByTime: Integer;
begin
    Result := DefaultInterface.OptimizeByTime;
end;

procedure TGWRoute.Set_OptimizeByTime(pVal: Integer);
begin
  DefaultInterface.Set_OptimizeByTime(pVal);
end;

function TGWRoute.Get_ReorderPoints: Integer;
begin
    Result := DefaultInterface.ReorderPoints;
end;

procedure TGWRoute.Set_ReorderPoints(pVal: Integer);
begin
  DefaultInterface.Set_ReorderPoints(pVal);
end;

function TGWRoute.Get_ProgressDelay: Integer;
begin
    Result := DefaultInterface.ProgressDelay;
end;

procedure TGWRoute.Set_ProgressDelay(pVal: Integer);
begin
  DefaultInterface.Set_ProgressDelay(pVal);
end;

function TGWRoute.Get_VehicleTypes: IUnknown;
begin
    Result := DefaultInterface.VehicleTypes;
end;

function TGWRoute.Get_RouteLength: Integer;
begin
    Result := DefaultInterface.RouteLength;
end;

function TGWRoute.Get_RouteDuration: Integer;
begin
    Result := DefaultInterface.RouteDuration;
end;

function TGWRoute.Get_RoutePointsCount: Integer;
begin
    Result := DefaultInterface.RoutePointsCount;
end;

function TGWRoute.Get_Priority: Integer;
begin
    Result := DefaultInterface.Priority;
end;

procedure TGWRoute.Set_Priority(pVal: Integer);
begin
  DefaultInterface.Set_Priority(pVal);
end;

function TGWRoute.Get_OptimizeTimeRatio: Double;
begin
    Result := DefaultInterface.OptimizeTimeRatio;
end;

procedure TGWRoute.Set_OptimizeTimeRatio(pVal: Double);
begin
  DefaultInterface.Set_OptimizeTimeRatio(pVal);
end;

function TGWRoute.Get_OptimizePriorityRatio: Double;
begin
    Result := DefaultInterface.OptimizePriorityRatio;
end;

procedure TGWRoute.Set_OptimizePriorityRatio(pVal: Double);
begin
  DefaultInterface.Set_OptimizePriorityRatio(pVal);
end;

function TGWRoute.GetPointName(Lat: Double; Lon: Double): WideString;
begin
  Result := DefaultInterface.GetPointName(Lat, Lon);
end;

procedure TGWRoute.DeletePoints;
begin
  DefaultInterface.DeletePoints;
end;

procedure TGWRoute.AddPoint(Lat: Double; Lon: Double; PointType: GWX_RoutePointType; 
                            const Name: WideString; Index: Integer);
begin
  DefaultInterface.AddPoint(Lat, Lon, PointType, Name, Index);
end;

function TGWRoute.CalculateRoute: Integer;
begin
  Result := DefaultInterface.CalculateRoute;
end;

function TGWRoute.GetRoute: IUnknown;
begin
  Result := DefaultInterface.GetRoute;
end;

function TGWRoute.GetVariants: IUnknown;
begin
  Result := DefaultInterface.GetVariants;
end;

function TGWRoute.GetVariantsTable: IUnknown;
begin
  Result := DefaultInterface.GetVariantsTable;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TGWRouteProperties.Create(AServer: TGWRoute);
begin
  inherited Create;
  FServer := AServer;
end;

function TGWRouteProperties.GetDefaultInterface: IGWRoute;
begin
  Result := FServer.DefaultInterface;
end;

function TGWRouteProperties.Get_Width: Double;
begin
    Result := DefaultInterface.Width;
end;

procedure TGWRouteProperties.Set_Width(pVal: Double);
begin
  DefaultInterface.Set_Width(pVal);
end;

function TGWRouteProperties.Get_Height: Double;
begin
    Result := DefaultInterface.Height;
end;

procedure TGWRouteProperties.Set_Height(pVal: Double);
begin
  DefaultInterface.Set_Height(pVal);
end;

function TGWRouteProperties.Get_Weight: Double;
begin
    Result := DefaultInterface.Weight;
end;

procedure TGWRouteProperties.Set_Weight(pVal: Double);
begin
  DefaultInterface.Set_Weight(pVal);
end;

function TGWRouteProperties.Get_VehicleType: WideString;
begin
    Result := DefaultInterface.VehicleType;
end;

procedure TGWRouteProperties.Set_VehicleType(const pVal: WideString);
  { Warning: The property VehicleType has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.VehicleType := pVal;
end;

function TGWRouteProperties.Get_StartTime: TDateTime;
begin
    Result := DefaultInterface.StartTime;
end;

procedure TGWRouteProperties.Set_StartTime(pVal: TDateTime);
begin
  DefaultInterface.Set_StartTime(pVal);
end;

function TGWRouteProperties.Get_OptimizeByTime: Integer;
begin
    Result := DefaultInterface.OptimizeByTime;
end;

procedure TGWRouteProperties.Set_OptimizeByTime(pVal: Integer);
begin
  DefaultInterface.Set_OptimizeByTime(pVal);
end;

function TGWRouteProperties.Get_ReorderPoints: Integer;
begin
    Result := DefaultInterface.ReorderPoints;
end;

procedure TGWRouteProperties.Set_ReorderPoints(pVal: Integer);
begin
  DefaultInterface.Set_ReorderPoints(pVal);
end;

function TGWRouteProperties.Get_ProgressDelay: Integer;
begin
    Result := DefaultInterface.ProgressDelay;
end;

procedure TGWRouteProperties.Set_ProgressDelay(pVal: Integer);
begin
  DefaultInterface.Set_ProgressDelay(pVal);
end;

function TGWRouteProperties.Get_VehicleTypes: IUnknown;
begin
    Result := DefaultInterface.VehicleTypes;
end;

function TGWRouteProperties.Get_RouteLength: Integer;
begin
    Result := DefaultInterface.RouteLength;
end;

function TGWRouteProperties.Get_RouteDuration: Integer;
begin
    Result := DefaultInterface.RouteDuration;
end;

function TGWRouteProperties.Get_RoutePointsCount: Integer;
begin
    Result := DefaultInterface.RoutePointsCount;
end;

function TGWRouteProperties.Get_Priority: Integer;
begin
    Result := DefaultInterface.Priority;
end;

procedure TGWRouteProperties.Set_Priority(pVal: Integer);
begin
  DefaultInterface.Set_Priority(pVal);
end;

function TGWRouteProperties.Get_OptimizeTimeRatio: Double;
begin
    Result := DefaultInterface.OptimizeTimeRatio;
end;

procedure TGWRouteProperties.Set_OptimizeTimeRatio(pVal: Double);
begin
  DefaultInterface.Set_OptimizeTimeRatio(pVal);
end;

function TGWRouteProperties.Get_OptimizePriorityRatio: Double;
begin
    Result := DefaultInterface.OptimizePriorityRatio;
end;

procedure TGWRouteProperties.Set_OptimizePriorityRatio(pVal: Double);
begin
  DefaultInterface.Set_OptimizePriorityRatio(pVal);
end;

{$ENDIF}

class function CoGWStringList.Create: IGWStringList;
begin
  Result := CreateComObject(CLASS_GWStringList) as IGWStringList;
end;

class function CoGWStringList.CreateRemote(const MachineName: string): IGWStringList;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GWStringList) as IGWStringList;
end;

procedure TGWStringList.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{07DF5DA4-55AA-4CD9-B5FE-19BF0A55ADA2}';
    IntfIID:   '{BD885540-EAA1-11D2-A748-00C00CB08F5B}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGWStringList.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IGWStringList;
  end;
end;

procedure TGWStringList.ConnectTo(svrIntf: IGWStringList);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TGWStringList.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TGWStringList.GetDefaultInterface: IGWStringList;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TGWStringList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TGWStringListProperties.Create(Self);
{$ENDIF}
end;

destructor TGWStringList.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TGWStringList.GetServerProperties: TGWStringListProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TGWStringList.Get_ItemCount: Integer;
begin
    Result := DefaultInterface.ItemCount;
end;

function TGWStringList.Get_Item: WideString;
begin
    Result := DefaultInterface.Item;
end;

function TGWStringList.MoveFirst: Integer;
begin
  Result := DefaultInterface.MoveFirst;
end;

function TGWStringList.MoveNext: Integer;
begin
  Result := DefaultInterface.MoveNext;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TGWStringListProperties.Create(AServer: TGWStringList);
begin
  inherited Create;
  FServer := AServer;
end;

function TGWStringListProperties.GetDefaultInterface: IGWStringList;
begin
  Result := FServer.DefaultInterface;
end;

function TGWStringListProperties.Get_ItemCount: Integer;
begin
    Result := DefaultInterface.ItemCount;
end;

function TGWStringListProperties.Get_Item: WideString;
begin
    Result := DefaultInterface.Item;
end;

{$ENDIF}

class function CoGWObject.Create: IGWObject;
begin
  Result := CreateComObject(CLASS_GWObject) as IGWObject;
end;

class function CoGWObject.CreateRemote(const MachineName: string): IGWObject;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GWObject) as IGWObject;
end;

procedure TGWObject.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{662343F8-A007-486E-A567-DC8B6FFD08F9}';
    IntfIID:   '{84BB8F21-FB50-11D2-A754-00C00CB08F5B}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGWObject.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IGWObject;
  end;
end;

procedure TGWObject.ConnectTo(svrIntf: IGWObject);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TGWObject.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TGWObject.GetDefaultInterface: IGWObject;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TGWObject.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TGWObjectProperties.Create(Self);
{$ENDIF}
end;

destructor TGWObject.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TGWObject.GetServerProperties: TGWObjectProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TGWObject.Get_ID: Integer;
begin
    Result := DefaultInterface.ID;
end;

function TGWObject.Get_type_: tagGWX_ObjectType;
begin
    Result := DefaultInterface.type_;
end;

function TGWObject.Get_Acronym: WideString;
begin
    Result := DefaultInterface.Acronym;
end;

function TGWObject.Get_MetricsType: LongWord;
begin
    Result := DefaultInterface.MetricsType;
end;

function TGWObject.Get_Metrics(out paLen: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Metrics[paLen];
end;

function TGWObject.Get_Attributes: IUnknown;
begin
    Result := DefaultInterface.Attributes;
end;

function TGWObject.Get_Length: Integer;
begin
    Result := DefaultInterface.Length;
end;

function TGWObject.Get_Square: Integer;
begin
    Result := DefaultInterface.Square;
end;

function TGWObject.Get_Links: IUnknown;
begin
    Result := DefaultInterface.Links;
end;

function TGWObject.Get_Visible: Integer;
begin
    Result := DefaultInterface.Visible;
end;

procedure TGWObject.Set_Visible(pVal: Integer);
begin
  DefaultInterface.Set_Visible(pVal);
end;

function TGWObject.Get_Marked: Integer;
begin
    Result := DefaultInterface.Marked;
end;

procedure TGWObject.Set_Marked(pVal: Integer);
begin
  DefaultInterface.Set_Marked(pVal);
end;

function TGWObject.Get_Contoured: Integer;
begin
    Result := DefaultInterface.Contoured;
end;

procedure TGWObject.Set_Contoured(pVal: Integer);
begin
  DefaultInterface.Set_Contoured(pVal);
end;

function TGWObject.Get_Twinkling: Integer;
begin
    Result := DefaultInterface.Twinkling;
end;

procedure TGWObject.Set_Twinkling(pVal: Integer);
begin
  DefaultInterface.Set_Twinkling(pVal);
end;

function TGWObject.getLinks(const nameDbf: WideString): IUnknown;
begin
  Result := DefaultInterface.getLinks(nameDbf);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TGWObjectProperties.Create(AServer: TGWObject);
begin
  inherited Create;
  FServer := AServer;
end;

function TGWObjectProperties.GetDefaultInterface: IGWObject;
begin
  Result := FServer.DefaultInterface;
end;

function TGWObjectProperties.Get_ID: Integer;
begin
    Result := DefaultInterface.ID;
end;

function TGWObjectProperties.Get_type_: tagGWX_ObjectType;
begin
    Result := DefaultInterface.type_;
end;

function TGWObjectProperties.Get_Acronym: WideString;
begin
    Result := DefaultInterface.Acronym;
end;

function TGWObjectProperties.Get_MetricsType: LongWord;
begin
    Result := DefaultInterface.MetricsType;
end;

function TGWObjectProperties.Get_Metrics(out paLen: OleVariant): OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Metrics[paLen];
end;

function TGWObjectProperties.Get_Attributes: IUnknown;
begin
    Result := DefaultInterface.Attributes;
end;

function TGWObjectProperties.Get_Length: Integer;
begin
    Result := DefaultInterface.Length;
end;

function TGWObjectProperties.Get_Square: Integer;
begin
    Result := DefaultInterface.Square;
end;

function TGWObjectProperties.Get_Links: IUnknown;
begin
    Result := DefaultInterface.Links;
end;

function TGWObjectProperties.Get_Visible: Integer;
begin
    Result := DefaultInterface.Visible;
end;

procedure TGWObjectProperties.Set_Visible(pVal: Integer);
begin
  DefaultInterface.Set_Visible(pVal);
end;

function TGWObjectProperties.Get_Marked: Integer;
begin
    Result := DefaultInterface.Marked;
end;

procedure TGWObjectProperties.Set_Marked(pVal: Integer);
begin
  DefaultInterface.Set_Marked(pVal);
end;

function TGWObjectProperties.Get_Contoured: Integer;
begin
    Result := DefaultInterface.Contoured;
end;

procedure TGWObjectProperties.Set_Contoured(pVal: Integer);
begin
  DefaultInterface.Set_Contoured(pVal);
end;

function TGWObjectProperties.Get_Twinkling: Integer;
begin
    Result := DefaultInterface.Twinkling;
end;

procedure TGWObjectProperties.Set_Twinkling(pVal: Integer);
begin
  DefaultInterface.Set_Twinkling(pVal);
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TGWControl]);
  RegisterComponents(dtlServerPage, [TGWTable, TGWGraphics, TGWRoute, TGWStringList, 
    TGWObject]);
end;

end.
