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
// File generated on 17.06.2010 10:59:28 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\GWX75\BIN\gwx.dll (1)
// LIBID: {FA7A5EA3-D402-11D2-A719-00C00CB08F5B}
// LCID: 0
// Helpfile: 
// HelpString: GWX 1.0 Type Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\STDOLE2.TLB)
// Errors:
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'set' of IGWControl.exploreApply changed to 'set_'
//   Hint: Parameter 'Type' of IGWControl.exploreApply changed to 'Type_'
//   Hint: Parameter 'set' of IGWControl.exploreDbApply changed to 'set_'
//   Hint: Parameter 'Type' of IGWControl.exploreDbApply changed to 'Type_'
//   Error creating palette bitmap of (TGWTable) : Server C:\GWX75\BIN\gwx.dll contains no icons
//   Error creating palette bitmap of (TGWGraphics) : Server C:\GWX75\BIN\gwx.dll contains no icons
//   Error creating palette bitmap of (TGWRoute) : Server C:\GWX75\BIN\gwx.dll contains no icons
//   Error creating palette bitmap of (TGWStringList) : Server C:\GWX75\BIN\gwx.dll contains no icons
//   Error creating palette bitmap of (TGWObject) : Server C:\GWX75\BIN\gwx.dll contains no icons
//   Error creating palette bitmap of (TGWXDeliveryCar) : Server C:\GWX75\BIN\gwx.dll contains no icons
//   Error creating palette bitmap of (TGWXDeliveryJob) : Server C:\GWX75\BIN\gwx.dll contains no icons
//   Error creating palette bitmap of (TGWXDelivery) : Server C:\GWX75\BIN\gwx.dll contains no icons
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

  IID_IGWObject: TGUID = '{84BB8F21-FB50-11D2-A754-00C00CB08F5B}';
  IID_IGWTable: TGUID = '{911F84E5-1A4A-11D3-B3C9-004033280B14}';
  DIID__IGWControlEvents: TGUID = '{FA7A5EB1-D402-11D2-A719-00C00CB08F5B}';
  IID_IGWRoute: TGUID = '{EB64D84A-4BC9-463D-B8FF-69E2220A3B06}';
  IID_IGWStringList: TGUID = '{BD885540-EAA1-11D2-A748-00C00CB08F5B}';
  IID_IGWGraphics: TGUID = '{D61686E3-7BD3-11D3-B4A2-004033280B14}';
  IID_IGWControl: TGUID = '{FA7A5EAF-D402-11D2-A719-00C00CB08F5B}';
  IID_IGWProjection: TGUID = '{BBC4DE60-D974-11D2-A72A-00C00CB08F5B}';
  IID_IGWXDelivery: TGUID = '{E3465126-5EF7-482C-8C48-393941EB5713}';
  IID_IGWXDeliveryCar: TGUID = '{85DD6B4F-A29B-4F5B-AE7B-5023D3182126}';
  IID_IGWXDeliveryJob: TGUID = '{5F2C8425-988B-400B-BF9B-ACFB9C972EF0}';
  IID_IGWProjectionAcc: TGUID = '{EE91F415-4DE1-4789-9516-63DC1845617C}';
  CLASS_GWControl: TGUID = '{FA7A5EB0-D402-11D2-A719-00C00CB08F5B}';
  CLASS_GWTable: TGUID = '{42384EE2-1814-11D3-B3C7-004033280B14}';
  CLASS_GWGraphics: TGUID = '{D61686E4-7BD3-11D3-B4A2-004033280B14}';
  CLASS_GWRoute: TGUID = '{E7268863-2A7D-41E8-B77E-22E50F184484}';
  CLASS_GWStringList: TGUID = '{07DF5DA4-55AA-4CD9-B5FE-19BF0A55ADA2}';
  CLASS_GWObject: TGUID = '{662343F8-A007-486E-A567-DC8B6FFD08F9}';
  CLASS_GWXDeliveryCar: TGUID = '{27254A91-AF88-4F8D-B131-45F644AAABDF}';
  CLASS_GWXDeliveryJob: TGUID = '{6A1BDC7C-2736-4758-962E-855FF4D66F66}';
  CLASS_GWXDelivery: TGUID = '{13BA2C05-8BD2-444F-B8A8-5036F269EF15}';

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

// Constants for enum GWX_OptimizeMode
type
  GWX_OptimizeMode = TOleEnum;
const
  GWX_OptimizeTime = $00000000;
  GWX_OptimizeLength = $00000001;
  GWX_OptimizeLengthWeight = $00000002;
  GWX_OptimizeLengthConsumption = $00000003;

// Constants for enum GWX_DistributionMethod
type
  GWX_DistributionMethod = TOleEnum;
const
  GWX_FarthestFirst = $00000000;
  GWX_ConcurrentJobs = $00000001;
  GWX_FarthestDirections = $00000002;
  GWX_FavorableCombinations = $00000003;
  GWX_PreDistributed = $00000004;

// Constants for enum GWX_VariantSubject
type
  GWX_VariantSubject = TOleEnum;
const
  GWX_VariantWidth = $00000000;
  GWX_VariantHeight = $00000001;
  GWX_VariantWeight = $00000002;
  GWX_VariantPriority = $00000003;
  GWX_VariantCargo = $00000004;
  GWX_VariantLicence = $00000005;

// Constants for enum GWX_DeliveryState
type
  GWX_DeliveryState = TOleEnum;
const
  GWX_DataDefinition = $00000000;
  GWX_Calculation = $00000001;
  GWX_Rearrangement = $00000002;

// Constants for enum GWX_SearchAddressResult
type
  GWX_SearchAddressResult = TOleEnum;
const
  GWX_FoundOK = $00000000;
  GWX_WithAdmission = $00000001;
  GWX_BulkNotFound = $00000002;
  GWX_HouseNotFound = $00000003;
  GWX_StreetNotFound = $00000004;
  GWX_Fail = $00000005;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IGWObject = interface;
  IGWObjectDisp = dispinterface;
  IGWTable = interface;
  IGWTableDisp = dispinterface;
  _IGWControlEvents = dispinterface;
  IGWRoute = interface;
  IGWRouteDisp = dispinterface;
  IGWStringList = interface;
  IGWStringListDisp = dispinterface;
  IGWGraphics = interface;
  IGWGraphicsDisp = dispinterface;
  IGWControl = interface;
  IGWControlDisp = dispinterface;
  IGWProjection = interface;
  IGWXDelivery = interface;
  IGWXDeliveryDisp = dispinterface;
  IGWXDeliveryCar = interface;
  IGWXDeliveryCarDisp = dispinterface;
  IGWXDeliveryJob = interface;
  IGWXDeliveryJobDisp = dispinterface;
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
  GWXDeliveryCar = IGWXDeliveryCar;
  GWXDeliveryJob = IGWXDeliveryJob;
  GWXDelivery = IGWXDelivery;


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
    function Get_Attributes: IGWTable; safecall;
    function getLinks(const nameDbf: WideString): IGWTable; safecall;
    function Get_Length: Integer; safecall;
    function Get_Square: Integer; safecall;
    function Get_Links: IGWTable; safecall;
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
    property Attributes: IGWTable read Get_Attributes;
    property Length: Integer read Get_Length;
    property Square: Integer read Get_Square;
    property Links: IGWTable read Get_Links;
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
    property Attributes: IGWTable readonly dispid 6;
    function getLinks(const nameDbf: WideString): IGWTable; dispid 7;
    property Length: Integer readonly dispid 8;
    property Square: Integer readonly dispid 9;
    property Links: IGWTable readonly dispid 10;
    property Visible: Integer dispid 11;
    property Marked: Integer dispid 12;
    property Contoured: Integer dispid 13;
    property Twinkling: Integer dispid 14;
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
    function moveFirst: Integer; safecall;
    function moveLast: Integer; safecall;
    function moveNext: Integer; safecall;
    function move(var1: OleVariant; var2: OleVariant; var3: OleVariant): Integer; safecall;
    function setValue(value: OleVariant; ColIndex: Integer): Integer; safecall;
    procedure sort(ColIndex: Integer; Asc: Integer; Dist: Integer); safecall;
    function rowCount: Integer; safecall;
    function getTable(ColIndex: Integer): IGWTable; safecall;
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
    function moveFirst: Integer; dispid 7;
    function moveLast: Integer; dispid 8;
    function moveNext: Integer; dispid 9;
    function move(var1: OleVariant; var2: OleVariant; var3: OleVariant): Integer; dispid 10;
    function setValue(value: OleVariant; ColIndex: Integer): Integer; dispid 11;
    procedure sort(ColIndex: Integer; Asc: Integer; Dist: Integer); dispid 12;
    function rowCount: Integer; dispid 13;
    function getTable(ColIndex: Integer): IGWTable; dispid 14;
    function getText(ColIndex: Integer): WideString; dispid 15;
    procedure remove; dispid 16;
    function colDescription(ColIndex: Integer): WideString; dispid 17;
    function addColumn(const colType: WideString; const colName: WideString; 
                       const colDescription: WideString): Integer; dispid 18;
    function IndexOf(const colName: WideString): Integer; dispid 19;
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
    function Get_VehicleTypes: IGWStringList; safecall;
    function Get_RouteLength: Integer; safecall;
    function Get_RouteDuration: Integer; safecall;
    function Get_RoutePointsCount: Integer; safecall;
    function GetPointName(Lat: Double; Lon: Double): WideString; safecall;
    procedure DeletePoints; safecall;
    procedure AddPoint(Lat: Double; Lon: Double; PointType: GWX_RoutePointType; 
                       const Name: WideString; Index: Integer); safecall;
    function CalculateRoute: Integer; safecall;
    function GetRoute: IGWTable; safecall;
    function Get_Priority: Integer; safecall;
    procedure Set_Priority(pVal: Integer); safecall;
    function Get_OptimizeTimeRatio: Double; safecall;
    procedure Set_OptimizeTimeRatio(pVal: Double); safecall;
    function Get_OptimizePriorityRatio: Double; safecall;
    procedure Set_OptimizePriorityRatio(pVal: Double); safecall;
    function GetVariants: IGWStringList; safecall;
    function GetVariantsTable: IGWTable; safecall;
    property Width: Double read Get_Width write Set_Width;
    property Height: Double read Get_Height write Set_Height;
    property Weight: Double read Get_Weight write Set_Weight;
    property VehicleType: WideString read Get_VehicleType write Set_VehicleType;
    property StartTime: TDateTime read Get_StartTime write Set_StartTime;
    property OptimizeByTime: Integer read Get_OptimizeByTime write Set_OptimizeByTime;
    property ReorderPoints: Integer read Get_ReorderPoints write Set_ReorderPoints;
    property ProgressDelay: Integer read Get_ProgressDelay write Set_ProgressDelay;
    property VehicleTypes: IGWStringList read Get_VehicleTypes;
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
    property VehicleTypes: IGWStringList readonly dispid 9;
    property RouteLength: Integer readonly dispid 10;
    property RouteDuration: Integer readonly dispid 11;
    property RoutePointsCount: Integer readonly dispid 12;
    function GetPointName(Lat: Double; Lon: Double): WideString; dispid 13;
    procedure DeletePoints; dispid 14;
    procedure AddPoint(Lat: Double; Lon: Double; PointType: GWX_RoutePointType; 
                       const Name: WideString; Index: Integer); dispid 15;
    function CalculateRoute: Integer; dispid 16;
    function GetRoute: IGWTable; dispid 17;
    property Priority: Integer dispid 18;
    property OptimizeTimeRatio: Double dispid 19;
    property OptimizePriorityRatio: Double dispid 20;
    function GetVariants: IGWStringList; dispid 21;
    function GetVariantsTable: IGWTable; dispid 22;
  end;

// *********************************************************************//
// Interface: IGWStringList
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {BD885540-EAA1-11D2-A748-00C00CB08F5B}
// *********************************************************************//
  IGWStringList = interface(IDispatch)
    ['{BD885540-EAA1-11D2-A748-00C00CB08F5B}']
    function Get_ItemCount: Integer; safecall;
    function moveFirst: Integer; safecall;
    function moveNext: Integer; safecall;
    function Get_Item: WideString; safecall;
    function GetItem(Index: Integer): WideString; safecall;
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
    function moveFirst: Integer; dispid 2;
    function moveNext: Integer; dispid 3;
    property Item: WideString readonly dispid 4;
    function GetItem(Index: Integer): WideString; dispid 5;
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
    function getTable: IGWTable; safecall;
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
    function getTable: IGWTable; dispid 3;
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
    function Get_DBFLoadedList: IGWStringList; safecall;
    function GetInfo(Lat: Double; Lon: Double): IGWTable; safecall;
    function Search(const Context: WideString): IGWTable; safecall;
    function SearchAddress(const Address: WideString; out Lat: Double; out Lon: Double): Integer; safecall;
    function GetInfoRect(South: Double; West: Double; North: Double; East: Double): IGWTable; safecall;
    procedure selectObject(ID: Integer; Select: Integer); safecall;
    procedure Refresh; safecall;
    function getAliasCodes: IGWTable; safecall;
    function getAliasAttributes: IGWTable; safecall;
    function getObject(ID: Integer): IGWObject; safecall;
    function getModulePath: WideString; safecall;
    function Get_mouseLeftType: GWX_MouseType; safecall;
    procedure Set_mouseLeftType(pVal: GWX_MouseType); safecall;
    function Get_mouseRightType: GWX_MouseType; safecall;
    procedure Set_mouseRightType(pVal: GWX_MouseType); safecall;
    procedure getMapInfo(out TypeMap: tagGWX_MapType; out Scale: Integer; 
                         out paGeoFrame: OleVariant; out paMetreFrame: OleVariant); safecall;
    function getMeasure(coord: OleVariant): Integer; safecall;
    function getUnloaderDBF: IGWTable; safecall;
    function showAddress(const Address: WideString): Integer; safecall;
    function GetInfoPolygon(paPolygon: OleVariant; mode: Integer): IGWTable; safecall;
    procedure getBitmap(const sFileName: WideString; North: Double; West: Double; South: Double; 
                        East: Double; pixWidth: Integer; pixHeight: Integer; nFontSize: Integer); safecall;
    function getExplore: IGWTable; safecall;
    procedure exploreApply(const Name: WideString; set_: Integer; const Type_: WideString); safecall;
    function getExploreDb: IGWTable; safecall;
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
    function Get_LoadedMaps: IGWTable; safecall;
    function AddMap(const MapName: WideString; const LookupName: WideString): GWX_Errors; safecall;
    procedure RemoveMap(const MapName: WideString); safecall;
    function SetLookup(const LookupName: WideString; const MapName: WideString): Integer; safecall;
    function GetAvailableLookups(const MapOrCodifierName: WideString): IGWTable; safecall;
    function Table2Map(const LoadCmd: WideString; const Style: WideString; const pTable: IGWTable): GWX_Errors; safecall;
    function CreateGWTable: IGWTable; safecall;
    function CreateGWRoute(const MapName: WideString): IGWRoute; safecall;
    function GetDistancePath(Lat1: Double; Lon1: Double; Lat2: Double; Lon2: Double; 
                             ResType: Integer): OleVariant; safecall;
    function FindNearestAddress(Lat: Double; Lon: Double): WideString; safecall;
    function getObjectTable(ID: Integer): IGWTable; safecall;
    procedure setObjectVisibility(ID: Integer; const visMode: WideString); safecall;
    function ModifyTable(const command: WideString; redraw: Integer): Integer; safecall;
    function Get_LicenceDialogLanguage: WideString; safecall;
    procedure Set_LicenceDialogLanguage(const pVal: WideString); safecall;
    function CreateGWXDelivery(const MapName: WideString): IGWXDelivery; safecall;
    function Get_InfoTooltipScrollable: WordBool; safecall;
    procedure Set_InfoTooltipScrollable(pVal: WordBool); safecall;
    function SearchAddressEx(const AddressIn: WideString; flags: LongWord; out Lat: Double; 
                             out Lon: Double; out AddressOut: WideString): GWX_SearchAddressResult; safecall;
    function Get_SmoothZooming: Integer; safecall;
    procedure Set_SmoothZooming(pVal: Integer); safecall;
    function Get_PopupTools: Integer; safecall;
    procedure Set_PopupTools(pVal: Integer); safecall;
    function Get_MoveHelper: Integer; safecall;
    procedure Set_MoveHelper(pVal: Integer); safecall;
    function Get_DirectDraw: Integer; safecall;
    procedure Set_DirectDraw(pVal: Integer); safecall;
    procedure ShowLicences; safecall;
    property MapName: WideString read Get_MapName write Set_MapName;
    property CurScale: Double read Get_CurScale write Set_CurScale;
    property InfoTooltip: Integer read Get_InfoTooltip write Set_InfoTooltip;
    property MapAttached: Integer read Get_MapAttached;
    property DBFLoadedList: IGWStringList read Get_DBFLoadedList;
    property mouseLeftType: GWX_MouseType read Get_mouseLeftType write Set_mouseLeftType;
    property mouseRightType: GWX_MouseType read Get_mouseRightType write Set_mouseRightType;
    property CurAngle: Double read Get_CurAngle write Set_CurAngle;
    property CoordGrid: Integer read Get_CoordGrid write Set_CoordGrid;
    property SmoothDrawing: Integer read Get_SmoothDrawing write Set_SmoothDrawing;
    property ScrollBars: Integer read Get_ScrollBars write Set_ScrollBars;
    property ClientEdge: Integer read Get_ClientEdge write Set_ClientEdge;
    property QuickRedraw: Integer read Get_QuickRedraw write Set_QuickRedraw;
    property Projection: GWX_ProjectionType read Get_Projection write Set_Projection;
    property LoadedMaps: IGWTable read Get_LoadedMaps;
    property LicenceDialogLanguage: WideString read Get_LicenceDialogLanguage write Set_LicenceDialogLanguage;
    property InfoTooltipScrollable: WordBool read Get_InfoTooltipScrollable write Set_InfoTooltipScrollable;
    property SmoothZooming: Integer read Get_SmoothZooming write Set_SmoothZooming;
    property PopupTools: Integer read Get_PopupTools write Set_PopupTools;
    property MoveHelper: Integer read Get_MoveHelper write Set_MoveHelper;
    property DirectDraw: Integer read Get_DirectDraw write Set_DirectDraw;
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
    property DBFLoadedList: IGWStringList readonly dispid 10;
    function GetInfo(Lat: Double; Lon: Double): IGWTable; dispid 11;
    function Search(const Context: WideString): IGWTable; dispid 12;
    function SearchAddress(const Address: WideString; out Lat: Double; out Lon: Double): Integer; dispid 13;
    function GetInfoRect(South: Double; West: Double; North: Double; East: Double): IGWTable; dispid 14;
    procedure selectObject(ID: Integer; Select: Integer); dispid 15;
    procedure Refresh; dispid 18;
    function getAliasCodes: IGWTable; dispid 19;
    function getAliasAttributes: IGWTable; dispid 20;
    function getObject(ID: Integer): IGWObject; dispid 21;
    function getModulePath: WideString; dispid 22;
    property mouseLeftType: GWX_MouseType dispid 23;
    property mouseRightType: GWX_MouseType dispid 24;
    procedure getMapInfo(out TypeMap: tagGWX_MapType; out Scale: Integer; 
                         out paGeoFrame: OleVariant; out paMetreFrame: OleVariant); dispid 25;
    function getMeasure(coord: OleVariant): Integer; dispid 26;
    function getUnloaderDBF: IGWTable; dispid 27;
    function showAddress(const Address: WideString): Integer; dispid 28;
    function GetInfoPolygon(paPolygon: OleVariant; mode: Integer): IGWTable; dispid 29;
    procedure getBitmap(const sFileName: WideString; North: Double; West: Double; South: Double; 
                        East: Double; pixWidth: Integer; pixHeight: Integer; nFontSize: Integer); dispid 30;
    function getExplore: IGWTable; dispid 31;
    procedure exploreApply(const Name: WideString; set_: Integer; const Type_: WideString); dispid 33;
    function getExploreDb: IGWTable; dispid 34;
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
    property LoadedMaps: IGWTable readonly dispid 47;
    function AddMap(const MapName: WideString; const LookupName: WideString): GWX_Errors; dispid 48;
    procedure RemoveMap(const MapName: WideString); dispid 49;
    function SetLookup(const LookupName: WideString; const MapName: WideString): Integer; dispid 50;
    function GetAvailableLookups(const MapOrCodifierName: WideString): IGWTable; dispid 51;
    function Table2Map(const LoadCmd: WideString; const Style: WideString; const pTable: IGWTable): GWX_Errors; dispid 52;
    function CreateGWTable: IGWTable; dispid 53;
    function CreateGWRoute(const MapName: WideString): IGWRoute; dispid 54;
    function GetDistancePath(Lat1: Double; Lon1: Double; Lat2: Double; Lon2: Double; 
                             ResType: Integer): OleVariant; dispid 55;
    function FindNearestAddress(Lat: Double; Lon: Double): WideString; dispid 56;
    function getObjectTable(ID: Integer): IGWTable; dispid 57;
    procedure setObjectVisibility(ID: Integer; const visMode: WideString); dispid 58;
    function ModifyTable(const command: WideString; redraw: Integer): Integer; dispid 59;
    property LicenceDialogLanguage: WideString dispid 60;
    function CreateGWXDelivery(const MapName: WideString): IGWXDelivery; dispid 61;
    property InfoTooltipScrollable: WordBool dispid 62;
    function SearchAddressEx(const AddressIn: WideString; flags: LongWord; out Lat: Double; 
                             out Lon: Double; out AddressOut: WideString): GWX_SearchAddressResult; dispid 63;
    property SmoothZooming: Integer dispid 64;
    property PopupTools: Integer dispid 65;
    property MoveHelper: Integer dispid 66;
    property DirectDraw: Integer dispid 67;
    procedure ShowLicences; dispid 68;
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
// Interface: IGWXDelivery
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {E3465126-5EF7-482C-8C48-393941EB5713}
// *********************************************************************//
  IGWXDelivery = interface(IDispatch)
    ['{E3465126-5EF7-482C-8C48-393941EB5713}']
    function AddCar: IGWXDeliveryCar; safecall;
    function GetCar(IndexOrName: OleVariant): IGWXDeliveryCar; safecall;
    function AddJob: IGWXDeliveryJob; safecall;
    function GetJob(IndexOrName: OleVariant): IGWXDeliveryJob; safecall;
    function Get_OptimizeMode: GWX_OptimizeMode; safecall;
    procedure Set_OptimizeMode(pVal: GWX_OptimizeMode); safecall;
    function Get_DistributionMethod: GWX_DistributionMethod; safecall;
    procedure Set_DistributionMethod(pVal: GWX_DistributionMethod); safecall;
    function Get_TripInterval: Double; safecall;
    procedure Set_TripInterval(pVal: Double); safecall;
    function Get_PathFromGarage: WordBool; safecall;
    procedure Set_PathFromGarage(pVal: WordBool); safecall;
    function Get_PathToGarage: WordBool; safecall;
    procedure Set_PathToGarage(pVal: WordBool); safecall;
    function Get_PointOnce: WordBool; safecall;
    procedure Set_PointOnce(pVal: WordBool); safecall;
    function Get_MultiTrip: WordBool; safecall;
    procedure Set_MultiTrip(pVal: WordBool); safecall;
    function Get_StackUnloading: WordBool; safecall;
    procedure Set_StackUnloading(pVal: WordBool); safecall;
    function Get_ProgressDelay: Integer; safecall;
    procedure Set_ProgressDelay(pVal: Integer); safecall;
    procedure CalculateRoutes; safecall;
    procedure Reset; safecall;
    function GetVariants(varSubject: GWX_VariantSubject): IGWStringList; safecall;
    function GetErrors: IGWStringList; safecall;
    function Get_TotalJobsCount: Integer; safecall;
    function Get_NotResolvedJobsCount: Integer; safecall;
    function Get_TotalLength: Double; safecall;
    function Get_TotalTime: Double; safecall;
    function Get_State: GWX_DeliveryState; safecall;
    procedure Set_State(pVal: GWX_DeliveryState); safecall;
    property OptimizeMode: GWX_OptimizeMode read Get_OptimizeMode write Set_OptimizeMode;
    property DistributionMethod: GWX_DistributionMethod read Get_DistributionMethod write Set_DistributionMethod;
    property TripInterval: Double read Get_TripInterval write Set_TripInterval;
    property PathFromGarage: WordBool read Get_PathFromGarage write Set_PathFromGarage;
    property PathToGarage: WordBool read Get_PathToGarage write Set_PathToGarage;
    property PointOnce: WordBool read Get_PointOnce write Set_PointOnce;
    property MultiTrip: WordBool read Get_MultiTrip write Set_MultiTrip;
    property StackUnloading: WordBool read Get_StackUnloading write Set_StackUnloading;
    property ProgressDelay: Integer read Get_ProgressDelay write Set_ProgressDelay;
    property TotalJobsCount: Integer read Get_TotalJobsCount;
    property NotResolvedJobsCount: Integer read Get_NotResolvedJobsCount;
    property TotalLength: Double read Get_TotalLength;
    property TotalTime: Double read Get_TotalTime;
    property State: GWX_DeliveryState read Get_State write Set_State;
  end;

// *********************************************************************//
// DispIntf:  IGWXDeliveryDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {E3465126-5EF7-482C-8C48-393941EB5713}
// *********************************************************************//
  IGWXDeliveryDisp = dispinterface
    ['{E3465126-5EF7-482C-8C48-393941EB5713}']
    function AddCar: IGWXDeliveryCar; dispid 1;
    function GetCar(IndexOrName: OleVariant): IGWXDeliveryCar; dispid 2;
    function AddJob: IGWXDeliveryJob; dispid 3;
    function GetJob(IndexOrName: OleVariant): IGWXDeliveryJob; dispid 4;
    property OptimizeMode: GWX_OptimizeMode dispid 5;
    property DistributionMethod: GWX_DistributionMethod dispid 6;
    property TripInterval: Double dispid 7;
    property PathFromGarage: WordBool dispid 8;
    property PathToGarage: WordBool dispid 9;
    property PointOnce: WordBool dispid 10;
    property MultiTrip: WordBool dispid 11;
    property StackUnloading: WordBool dispid 12;
    property ProgressDelay: Integer dispid 13;
    procedure CalculateRoutes; dispid 14;
    procedure Reset; dispid 15;
    function GetVariants(varSubject: GWX_VariantSubject): IGWStringList; dispid 16;
    function GetErrors: IGWStringList; dispid 17;
    property TotalJobsCount: Integer readonly dispid 18;
    property NotResolvedJobsCount: Integer readonly dispid 19;
    property TotalLength: Double readonly dispid 20;
    property TotalTime: Double readonly dispid 21;
    property State: GWX_DeliveryState dispid 22;
  end;

// *********************************************************************//
// Interface: IGWXDeliveryCar
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {85DD6B4F-A29B-4F5B-AE7B-5023D3182126}
// *********************************************************************//
  IGWXDeliveryCar = interface(IDispatch)
    ['{85DD6B4F-A29B-4F5B-AE7B-5023D3182126}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const pVal: WideString); safecall;
    function Get_Description: WideString; safecall;
    procedure Set_Description(const pVal: WideString); safecall;
    procedure SetGarage(Lat: Double; Lon: Double; const Description: WideString); safecall;
    function Get_MaxWeight: Double; safecall;
    procedure Set_MaxWeight(pVal: Double); safecall;
    function Get_MaxVolume: Double; safecall;
    procedure Set_MaxVolume(pVal: Double); safecall;
    function Get_MaxCost: Double; safecall;
    procedure Set_MaxCost(pVal: Double); safecall;
    function Get_MaxJobNumber: Integer; safecall;
    procedure Set_MaxJobNumber(pVal: Integer); safecall;
    function Get_CarType: WideString; safecall;
    procedure Set_CarType(const pVal: WideString); safecall;
    function Get_WorkBegin: TDateTime; safecall;
    procedure Set_WorkBegin(pVal: TDateTime); safecall;
    function Get_WorkEnd: TDateTime; safecall;
    procedure Set_WorkEnd(pVal: TDateTime); safecall;
    function Get_MaxRouteLength: Double; safecall;
    procedure Set_MaxRouteLength(pVal: Double); safecall;
    function Get_MaxRouteTime: Double; safecall;
    procedure Set_MaxRouteTime(pVal: Double); safecall;
    function Get_SpeedCoefficient: Double; safecall;
    procedure Set_SpeedCoefficient(pVal: Double); safecall;
    function Get_OwnWeight: Double; safecall;
    procedure Set_OwnWeight(pVal: Double); safecall;
    function Get_FuelConsumption: Double; safecall;
    procedure Set_FuelConsumption(pVal: Double); safecall;
    function Get_Cargo: Double; safecall;
    procedure Set_Cargo(pVal: Double); safecall;
    function Get_Width: Double; safecall;
    procedure Set_Width(pVal: Double); safecall;
    function Get_Height: Double; safecall;
    procedure Set_Height(pVal: Double); safecall;
    function Get_Licence: WideString; safecall;
    procedure Set_Licence(const pVal: WideString); safecall;
    function Get_ResRouteLength: Double; safecall;
    function Get_ResRouteTime: Double; safecall;
    function Get_ResJobCount: Integer; safecall;
    function Get_ResViolationsCount: Integer; safecall;
    function Get_ResRouteBegin: TDateTime; safecall;
    function Get_ResRouteEnd: TDateTime; safecall;
    function Get_ResPointsCount: Integer; safecall;
    function GetRoute: IGWTable; safecall;
    procedure GetPosition(time: TDateTime; out Lat: Double; out Lon: Double; 
                          out RtPointIx: Integer; out PathPointIx: Integer; out JobCount: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Description: WideString read Get_Description write Set_Description;
    property MaxWeight: Double read Get_MaxWeight write Set_MaxWeight;
    property MaxVolume: Double read Get_MaxVolume write Set_MaxVolume;
    property MaxCost: Double read Get_MaxCost write Set_MaxCost;
    property MaxJobNumber: Integer read Get_MaxJobNumber write Set_MaxJobNumber;
    property CarType: WideString read Get_CarType write Set_CarType;
    property WorkBegin: TDateTime read Get_WorkBegin write Set_WorkBegin;
    property WorkEnd: TDateTime read Get_WorkEnd write Set_WorkEnd;
    property MaxRouteLength: Double read Get_MaxRouteLength write Set_MaxRouteLength;
    property MaxRouteTime: Double read Get_MaxRouteTime write Set_MaxRouteTime;
    property SpeedCoefficient: Double read Get_SpeedCoefficient write Set_SpeedCoefficient;
    property OwnWeight: Double read Get_OwnWeight write Set_OwnWeight;
    property FuelConsumption: Double read Get_FuelConsumption write Set_FuelConsumption;
    property Cargo: Double read Get_Cargo write Set_Cargo;
    property Width: Double read Get_Width write Set_Width;
    property Height: Double read Get_Height write Set_Height;
    property Licence: WideString read Get_Licence write Set_Licence;
    property ResRouteLength: Double read Get_ResRouteLength;
    property ResRouteTime: Double read Get_ResRouteTime;
    property ResJobCount: Integer read Get_ResJobCount;
    property ResViolationsCount: Integer read Get_ResViolationsCount;
    property ResRouteBegin: TDateTime read Get_ResRouteBegin;
    property ResRouteEnd: TDateTime read Get_ResRouteEnd;
    property ResPointsCount: Integer read Get_ResPointsCount;
  end;

// *********************************************************************//
// DispIntf:  IGWXDeliveryCarDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {85DD6B4F-A29B-4F5B-AE7B-5023D3182126}
// *********************************************************************//
  IGWXDeliveryCarDisp = dispinterface
    ['{85DD6B4F-A29B-4F5B-AE7B-5023D3182126}']
    property Name: WideString dispid 1;
    property Description: WideString dispid 2;
    procedure SetGarage(Lat: Double; Lon: Double; const Description: WideString); dispid 3;
    property MaxWeight: Double dispid 4;
    property MaxVolume: Double dispid 5;
    property MaxCost: Double dispid 6;
    property MaxJobNumber: Integer dispid 7;
    property CarType: WideString dispid 8;
    property WorkBegin: TDateTime dispid 9;
    property WorkEnd: TDateTime dispid 10;
    property MaxRouteLength: Double dispid 11;
    property MaxRouteTime: Double dispid 12;
    property SpeedCoefficient: Double dispid 13;
    property OwnWeight: Double dispid 14;
    property FuelConsumption: Double dispid 15;
    property Cargo: Double dispid 16;
    property Width: Double dispid 17;
    property Height: Double dispid 18;
    property Licence: WideString dispid 19;
    property ResRouteLength: Double readonly dispid 20;
    property ResRouteTime: Double readonly dispid 21;
    property ResJobCount: Integer readonly dispid 22;
    property ResViolationsCount: Integer readonly dispid 23;
    property ResRouteBegin: TDateTime readonly dispid 24;
    property ResRouteEnd: TDateTime readonly dispid 25;
    property ResPointsCount: Integer readonly dispid 26;
    function GetRoute: IGWTable; dispid 27;
    procedure GetPosition(time: TDateTime; out Lat: Double; out Lon: Double; 
                          out RtPointIx: Integer; out PathPointIx: Integer; out JobCount: Integer); dispid 28;
  end;

// *********************************************************************//
// Interface: IGWXDeliveryJob
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5F2C8425-988B-400B-BF9B-ACFB9C972EF0}
// *********************************************************************//
  IGWXDeliveryJob = interface(IDispatch)
    ['{5F2C8425-988B-400B-BF9B-ACFB9C972EF0}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const pVal: WideString); safecall;
    procedure SetGetPoint(Lat: Double; Lon: Double; const Description: WideString); safecall;
    procedure SetPutPoint(Lat: Double; Lon: Double; const Description: WideString); safecall;
    function Get_GetTimeAfter: TDateTime; safecall;
    procedure Set_GetTimeAfter(pVal: TDateTime); safecall;
    function Get_GetTimeBefore: TDateTime; safecall;
    procedure Set_GetTimeBefore(pVal: TDateTime); safecall;
    function Get_PutTimeAfter: TDateTime; safecall;
    procedure Set_PutTimeAfter(pVal: TDateTime); safecall;
    function Get_PutTimeBefore: TDateTime; safecall;
    procedure Set_PutTimeBefore(pVal: TDateTime); safecall;
    function Get_Weight: Double; safecall;
    procedure Set_Weight(pVal: Double); safecall;
    function Get_Volume: Double; safecall;
    procedure Set_Volume(pVal: Double); safecall;
    function Get_Cost: Double; safecall;
    procedure Set_Cost(pVal: Double); safecall;
    function Get_Priority: Integer; safecall;
    procedure Set_Priority(pVal: Integer); safecall;
    function Get_CarTypes: WideString; safecall;
    procedure Set_CarTypes(const pVal: WideString); safecall;
    function Get_GetDuration: Double; safecall;
    procedure Set_GetDuration(pVal: Double); safecall;
    function Get_PutDuration: Double; safecall;
    procedure Set_PutDuration(pVal: Double); safecall;
    function Get_MaxTransportDuration: Double; safecall;
    procedure Set_MaxTransportDuration(pVal: Double); safecall;
    function Get_IndexInRouteGet: Integer; safecall;
    procedure Set_IndexInRouteGet(pVal: Integer); safecall;
    function Get_IndexInRoutePut: Integer; safecall;
    procedure Set_IndexInRoutePut(pVal: Integer); safecall;
    function Get_CarName: WideString; safecall;
    procedure Set_CarName(const pVal: WideString); safecall;
    function Get_GetTime: TDateTime; safecall;
    function Get_PutTime: TDateTime; safecall;
    property Name: WideString read Get_Name write Set_Name;
    property GetTimeAfter: TDateTime read Get_GetTimeAfter write Set_GetTimeAfter;
    property GetTimeBefore: TDateTime read Get_GetTimeBefore write Set_GetTimeBefore;
    property PutTimeAfter: TDateTime read Get_PutTimeAfter write Set_PutTimeAfter;
    property PutTimeBefore: TDateTime read Get_PutTimeBefore write Set_PutTimeBefore;
    property Weight: Double read Get_Weight write Set_Weight;
    property Volume: Double read Get_Volume write Set_Volume;
    property Cost: Double read Get_Cost write Set_Cost;
    property Priority: Integer read Get_Priority write Set_Priority;
    property CarTypes: WideString read Get_CarTypes write Set_CarTypes;
    property GetDuration: Double read Get_GetDuration write Set_GetDuration;
    property PutDuration: Double read Get_PutDuration write Set_PutDuration;
    property MaxTransportDuration: Double read Get_MaxTransportDuration write Set_MaxTransportDuration;
    property IndexInRouteGet: Integer read Get_IndexInRouteGet write Set_IndexInRouteGet;
    property IndexInRoutePut: Integer read Get_IndexInRoutePut write Set_IndexInRoutePut;
    property CarName: WideString read Get_CarName write Set_CarName;
    property GetTime: TDateTime read Get_GetTime;
    property PutTime: TDateTime read Get_PutTime;
  end;

// *********************************************************************//
// DispIntf:  IGWXDeliveryJobDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5F2C8425-988B-400B-BF9B-ACFB9C972EF0}
// *********************************************************************//
  IGWXDeliveryJobDisp = dispinterface
    ['{5F2C8425-988B-400B-BF9B-ACFB9C972EF0}']
    property Name: WideString dispid 1;
    procedure SetGetPoint(Lat: Double; Lon: Double; const Description: WideString); dispid 2;
    procedure SetPutPoint(Lat: Double; Lon: Double; const Description: WideString); dispid 3;
    property GetTimeAfter: TDateTime dispid 4;
    property GetTimeBefore: TDateTime dispid 5;
    property PutTimeAfter: TDateTime dispid 6;
    property PutTimeBefore: TDateTime dispid 7;
    property Weight: Double dispid 8;
    property Volume: Double dispid 9;
    property Cost: Double dispid 10;
    property Priority: Integer dispid 11;
    property CarTypes: WideString dispid 12;
    property GetDuration: Double dispid 13;
    property PutDuration: Double dispid 14;
    property MaxTransportDuration: Double dispid 15;
    property IndexInRouteGet: Integer dispid 16;
    property IndexInRoutePut: Integer dispid 17;
    property CarName: WideString dispid 18;
    property GetTime: TDateTime readonly dispid 19;
    property PutTime: TDateTime readonly dispid 20;
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
    function Get_DBFLoadedList: IGWStringList;
    function Get_LoadedMaps: IGWTable;
  public
    procedure SetGeoCenter(Lat: Double; Lon: Double);
    procedure GetGeoCenter(out Lat: Double; out Lon: Double);
    procedure Overview;
    function DBF2Map(const DBFPathName: WideString; const Style: WideString): tagGWX_DBF2MapResult;
    procedure DeleteDBF(const DBFName: WideString);
    function GetInfo(Lat: Double; Lon: Double): IGWTable;
    function Search(const Context: WideString): IGWTable;
    function SearchAddress(const Address: WideString; out Lat: Double; out Lon: Double): Integer;
    function GetInfoRect(South: Double; West: Double; North: Double; East: Double): IGWTable;
    procedure selectObject(ID: Integer; Select: Integer);
    procedure Refresh;
    function getAliasCodes: IGWTable;
    function getAliasAttributes: IGWTable;
    function getObject(ID: Integer): IGWObject;
    function getModulePath: WideString;
    procedure getMapInfo(out TypeMap: tagGWX_MapType; out Scale: Integer; 
                         out paGeoFrame: OleVariant; out paMetreFrame: OleVariant);
    function getMeasure(coord: OleVariant): Integer;
    function getUnloaderDBF: IGWTable;
    function showAddress(const Address: WideString): Integer;
    function GetInfoPolygon(paPolygon: OleVariant; mode: Integer): IGWTable;
    procedure getBitmap(const sFileName: WideString; North: Double; West: Double; South: Double; 
                        East: Double; pixWidth: Integer; pixHeight: Integer; nFontSize: Integer);
    function getExplore: IGWTable;
    procedure exploreApply(const Name: WideString; set_: Integer; const Type_: WideString);
    function getExploreDb: IGWTable;
    procedure exploreDbApply(const Name: WideString; set_: Integer; const Type_: WideString);
    procedure setPassWord(const pw: WideString);
    procedure Geo2Dev(Lat: Double; Lon: Double; out x: Integer; out y: Integer);
    procedure Dev2GeoString(x: Integer; y: Integer; out Lat: WideString; out Lon: WideString);
    procedure Dev2Geo(x: Integer; y: Integer; out Lat: Double; out Lon: Double);
    function AddMap(const MapName: WideString; const LookupName: WideString): GWX_Errors;
    procedure RemoveMap(const MapName: WideString);
    function SetLookup(const LookupName: WideString; const MapName: WideString): Integer;
    function GetAvailableLookups(const MapOrCodifierName: WideString): IGWTable;
    function Table2Map(const LoadCmd: WideString; const Style: WideString; const pTable: IGWTable): GWX_Errors;
    function CreateGWTable: IGWTable;
    function CreateGWRoute(const MapName: WideString): IGWRoute;
    function GetDistancePath(Lat1: Double; Lon1: Double; Lat2: Double; Lon2: Double; 
                             ResType: Integer): OleVariant;
    function FindNearestAddress(Lat: Double; Lon: Double): WideString;
    function getObjectTable(ID: Integer): IGWTable;
    procedure setObjectVisibility(ID: Integer; const visMode: WideString);
    function ModifyTable(const command: WideString; redraw: Integer): Integer;
    function CreateGWXDelivery(const MapName: WideString): IGWXDelivery;
    function SearchAddressEx(const AddressIn: WideString; flags: LongWord; out Lat: Double; 
                             out Lon: Double; out AddressOut: WideString): GWX_SearchAddressResult;
    procedure ShowLicences;
    property  ControlInterface: IGWControl read GetControlInterface;
    property  DefaultInterface: IGWControl read GetControlInterface;
    property MapAttached: Integer index 6 read GetIntegerProp;
    property DBFLoadedList: IGWStringList read Get_DBFLoadedList;
    property LoadedMaps: IGWTable read Get_LoadedMaps;
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
    property InfoTooltipScrollable: WordBool index 62 read GetWordBoolProp write SetWordBoolProp stored False;
    property SmoothZooming: Integer index 64 read GetIntegerProp write SetIntegerProp stored False;
    property PopupTools: Integer index 65 read GetIntegerProp write SetIntegerProp stored False;
    property MoveHelper: Integer index 66 read GetIntegerProp write SetIntegerProp stored False;
    property DirectDraw: Integer index 67 read GetIntegerProp write SetIntegerProp stored False;
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
    function moveFirst: Integer;
    function moveLast: Integer;
    function moveNext: Integer;
    function move(var1: OleVariant; var2: OleVariant; var3: OleVariant): Integer;
    function setValue(value: OleVariant; ColIndex: Integer): Integer;
    procedure sort(ColIndex: Integer; Asc: Integer; Dist: Integer);
    function rowCount: Integer;
    function getTable(ColIndex: Integer): IGWTable;
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
    function getTable: IGWTable;
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
    function Get_VehicleTypes: IGWStringList;
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
    function GetRoute: IGWTable;
    function GetVariants: IGWStringList;
    function GetVariantsTable: IGWTable;
    property DefaultInterface: IGWRoute read GetDefaultInterface;
    property VehicleTypes: IGWStringList read Get_VehicleTypes;
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
    function Get_VehicleTypes: IGWStringList;
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
    function moveFirst: Integer;
    function moveNext: Integer;
    function GetItem(Index: Integer): WideString;
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
    function Get_Attributes: IGWTable;
    function Get_Length: Integer;
    function Get_Square: Integer;
    function Get_Links: IGWTable;
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
    function getLinks(const nameDbf: WideString): IGWTable;
    property DefaultInterface: IGWObject read GetDefaultInterface;
    property ID: Integer read Get_ID;
    property type_: tagGWX_ObjectType read Get_type_;
    property Acronym: WideString read Get_Acronym;
    property MetricsType: LongWord read Get_MetricsType;
    property Metrics[out paLen: OleVariant]: OleVariant read Get_Metrics;
    property Attributes: IGWTable read Get_Attributes;
    property Length: Integer read Get_Length;
    property Square: Integer read Get_Square;
    property Links: IGWTable read Get_Links;
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
    function Get_Attributes: IGWTable;
    function Get_Length: Integer;
    function Get_Square: Integer;
    function Get_Links: IGWTable;
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


// *********************************************************************//
// The Class CoGWXDeliveryCar provides a Create and CreateRemote method to          
// create instances of the default interface IGWXDeliveryCar exposed by              
// the CoClass GWXDeliveryCar. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGWXDeliveryCar = class
    class function Create: IGWXDeliveryCar;
    class function CreateRemote(const MachineName: string): IGWXDeliveryCar;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TGWXDeliveryCar
// Help String      : GWXDeliveryCar Class
// Default Interface: IGWXDeliveryCar
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TGWXDeliveryCarProperties= class;
{$ENDIF}
  TGWXDeliveryCar = class(TOleServer)
  private
    FIntf: IGWXDeliveryCar;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TGWXDeliveryCarProperties;
    function GetServerProperties: TGWXDeliveryCarProperties;
{$ENDIF}
    function GetDefaultInterface: IGWXDeliveryCar;
  protected
    procedure InitServerData; override;
    function Get_Name: WideString;
    procedure Set_Name(const pVal: WideString);
    function Get_Description: WideString;
    procedure Set_Description(const pVal: WideString);
    function Get_MaxWeight: Double;
    procedure Set_MaxWeight(pVal: Double);
    function Get_MaxVolume: Double;
    procedure Set_MaxVolume(pVal: Double);
    function Get_MaxCost: Double;
    procedure Set_MaxCost(pVal: Double);
    function Get_MaxJobNumber: Integer;
    procedure Set_MaxJobNumber(pVal: Integer);
    function Get_CarType: WideString;
    procedure Set_CarType(const pVal: WideString);
    function Get_WorkBegin: TDateTime;
    procedure Set_WorkBegin(pVal: TDateTime);
    function Get_WorkEnd: TDateTime;
    procedure Set_WorkEnd(pVal: TDateTime);
    function Get_MaxRouteLength: Double;
    procedure Set_MaxRouteLength(pVal: Double);
    function Get_MaxRouteTime: Double;
    procedure Set_MaxRouteTime(pVal: Double);
    function Get_SpeedCoefficient: Double;
    procedure Set_SpeedCoefficient(pVal: Double);
    function Get_OwnWeight: Double;
    procedure Set_OwnWeight(pVal: Double);
    function Get_FuelConsumption: Double;
    procedure Set_FuelConsumption(pVal: Double);
    function Get_Cargo: Double;
    procedure Set_Cargo(pVal: Double);
    function Get_Width: Double;
    procedure Set_Width(pVal: Double);
    function Get_Height: Double;
    procedure Set_Height(pVal: Double);
    function Get_Licence: WideString;
    procedure Set_Licence(const pVal: WideString);
    function Get_ResRouteLength: Double;
    function Get_ResRouteTime: Double;
    function Get_ResJobCount: Integer;
    function Get_ResViolationsCount: Integer;
    function Get_ResRouteBegin: TDateTime;
    function Get_ResRouteEnd: TDateTime;
    function Get_ResPointsCount: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IGWXDeliveryCar);
    procedure Disconnect; override;
    procedure SetGarage(Lat: Double; Lon: Double; const Description: WideString);
    function GetRoute: IGWTable;
    procedure GetPosition(time: TDateTime; out Lat: Double; out Lon: Double; 
                          out RtPointIx: Integer; out PathPointIx: Integer; out JobCount: Integer);
    property DefaultInterface: IGWXDeliveryCar read GetDefaultInterface;
    property ResRouteLength: Double read Get_ResRouteLength;
    property ResRouteTime: Double read Get_ResRouteTime;
    property ResJobCount: Integer read Get_ResJobCount;
    property ResViolationsCount: Integer read Get_ResViolationsCount;
    property ResRouteBegin: TDateTime read Get_ResRouteBegin;
    property ResRouteEnd: TDateTime read Get_ResRouteEnd;
    property ResPointsCount: Integer read Get_ResPointsCount;
    property Name: WideString read Get_Name write Set_Name;
    property Description: WideString read Get_Description write Set_Description;
    property MaxWeight: Double read Get_MaxWeight write Set_MaxWeight;
    property MaxVolume: Double read Get_MaxVolume write Set_MaxVolume;
    property MaxCost: Double read Get_MaxCost write Set_MaxCost;
    property MaxJobNumber: Integer read Get_MaxJobNumber write Set_MaxJobNumber;
    property CarType: WideString read Get_CarType write Set_CarType;
    property WorkBegin: TDateTime read Get_WorkBegin write Set_WorkBegin;
    property WorkEnd: TDateTime read Get_WorkEnd write Set_WorkEnd;
    property MaxRouteLength: Double read Get_MaxRouteLength write Set_MaxRouteLength;
    property MaxRouteTime: Double read Get_MaxRouteTime write Set_MaxRouteTime;
    property SpeedCoefficient: Double read Get_SpeedCoefficient write Set_SpeedCoefficient;
    property OwnWeight: Double read Get_OwnWeight write Set_OwnWeight;
    property FuelConsumption: Double read Get_FuelConsumption write Set_FuelConsumption;
    property Cargo: Double read Get_Cargo write Set_Cargo;
    property Width: Double read Get_Width write Set_Width;
    property Height: Double read Get_Height write Set_Height;
    property Licence: WideString read Get_Licence write Set_Licence;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TGWXDeliveryCarProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TGWXDeliveryCar
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TGWXDeliveryCarProperties = class(TPersistent)
  private
    FServer:    TGWXDeliveryCar;
    function    GetDefaultInterface: IGWXDeliveryCar;
    constructor Create(AServer: TGWXDeliveryCar);
  protected
    function Get_Name: WideString;
    procedure Set_Name(const pVal: WideString);
    function Get_Description: WideString;
    procedure Set_Description(const pVal: WideString);
    function Get_MaxWeight: Double;
    procedure Set_MaxWeight(pVal: Double);
    function Get_MaxVolume: Double;
    procedure Set_MaxVolume(pVal: Double);
    function Get_MaxCost: Double;
    procedure Set_MaxCost(pVal: Double);
    function Get_MaxJobNumber: Integer;
    procedure Set_MaxJobNumber(pVal: Integer);
    function Get_CarType: WideString;
    procedure Set_CarType(const pVal: WideString);
    function Get_WorkBegin: TDateTime;
    procedure Set_WorkBegin(pVal: TDateTime);
    function Get_WorkEnd: TDateTime;
    procedure Set_WorkEnd(pVal: TDateTime);
    function Get_MaxRouteLength: Double;
    procedure Set_MaxRouteLength(pVal: Double);
    function Get_MaxRouteTime: Double;
    procedure Set_MaxRouteTime(pVal: Double);
    function Get_SpeedCoefficient: Double;
    procedure Set_SpeedCoefficient(pVal: Double);
    function Get_OwnWeight: Double;
    procedure Set_OwnWeight(pVal: Double);
    function Get_FuelConsumption: Double;
    procedure Set_FuelConsumption(pVal: Double);
    function Get_Cargo: Double;
    procedure Set_Cargo(pVal: Double);
    function Get_Width: Double;
    procedure Set_Width(pVal: Double);
    function Get_Height: Double;
    procedure Set_Height(pVal: Double);
    function Get_Licence: WideString;
    procedure Set_Licence(const pVal: WideString);
    function Get_ResRouteLength: Double;
    function Get_ResRouteTime: Double;
    function Get_ResJobCount: Integer;
    function Get_ResViolationsCount: Integer;
    function Get_ResRouteBegin: TDateTime;
    function Get_ResRouteEnd: TDateTime;
    function Get_ResPointsCount: Integer;
  public
    property DefaultInterface: IGWXDeliveryCar read GetDefaultInterface;
  published
    property Name: WideString read Get_Name write Set_Name;
    property Description: WideString read Get_Description write Set_Description;
    property MaxWeight: Double read Get_MaxWeight write Set_MaxWeight;
    property MaxVolume: Double read Get_MaxVolume write Set_MaxVolume;
    property MaxCost: Double read Get_MaxCost write Set_MaxCost;
    property MaxJobNumber: Integer read Get_MaxJobNumber write Set_MaxJobNumber;
    property CarType: WideString read Get_CarType write Set_CarType;
    property WorkBegin: TDateTime read Get_WorkBegin write Set_WorkBegin;
    property WorkEnd: TDateTime read Get_WorkEnd write Set_WorkEnd;
    property MaxRouteLength: Double read Get_MaxRouteLength write Set_MaxRouteLength;
    property MaxRouteTime: Double read Get_MaxRouteTime write Set_MaxRouteTime;
    property SpeedCoefficient: Double read Get_SpeedCoefficient write Set_SpeedCoefficient;
    property OwnWeight: Double read Get_OwnWeight write Set_OwnWeight;
    property FuelConsumption: Double read Get_FuelConsumption write Set_FuelConsumption;
    property Cargo: Double read Get_Cargo write Set_Cargo;
    property Width: Double read Get_Width write Set_Width;
    property Height: Double read Get_Height write Set_Height;
    property Licence: WideString read Get_Licence write Set_Licence;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoGWXDeliveryJob provides a Create and CreateRemote method to          
// create instances of the default interface IGWXDeliveryJob exposed by              
// the CoClass GWXDeliveryJob. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGWXDeliveryJob = class
    class function Create: IGWXDeliveryJob;
    class function CreateRemote(const MachineName: string): IGWXDeliveryJob;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TGWXDeliveryJob
// Help String      : GWXDeliveryJob Class
// Default Interface: IGWXDeliveryJob
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TGWXDeliveryJobProperties= class;
{$ENDIF}
  TGWXDeliveryJob = class(TOleServer)
  private
    FIntf: IGWXDeliveryJob;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TGWXDeliveryJobProperties;
    function GetServerProperties: TGWXDeliveryJobProperties;
{$ENDIF}
    function GetDefaultInterface: IGWXDeliveryJob;
  protected
    procedure InitServerData; override;
    function Get_Name: WideString;
    procedure Set_Name(const pVal: WideString);
    function Get_GetTimeAfter: TDateTime;
    procedure Set_GetTimeAfter(pVal: TDateTime);
    function Get_GetTimeBefore: TDateTime;
    procedure Set_GetTimeBefore(pVal: TDateTime);
    function Get_PutTimeAfter: TDateTime;
    procedure Set_PutTimeAfter(pVal: TDateTime);
    function Get_PutTimeBefore: TDateTime;
    procedure Set_PutTimeBefore(pVal: TDateTime);
    function Get_Weight: Double;
    procedure Set_Weight(pVal: Double);
    function Get_Volume: Double;
    procedure Set_Volume(pVal: Double);
    function Get_Cost: Double;
    procedure Set_Cost(pVal: Double);
    function Get_Priority: Integer;
    procedure Set_Priority(pVal: Integer);
    function Get_CarTypes: WideString;
    procedure Set_CarTypes(const pVal: WideString);
    function Get_GetDuration: Double;
    procedure Set_GetDuration(pVal: Double);
    function Get_PutDuration: Double;
    procedure Set_PutDuration(pVal: Double);
    function Get_MaxTransportDuration: Double;
    procedure Set_MaxTransportDuration(pVal: Double);
    function Get_IndexInRouteGet: Integer;
    procedure Set_IndexInRouteGet(pVal: Integer);
    function Get_IndexInRoutePut: Integer;
    procedure Set_IndexInRoutePut(pVal: Integer);
    function Get_CarName: WideString;
    procedure Set_CarName(const pVal: WideString);
    function Get_GetTime: TDateTime;
    function Get_PutTime: TDateTime;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IGWXDeliveryJob);
    procedure Disconnect; override;
    procedure SetGetPoint(Lat: Double; Lon: Double; const Description: WideString);
    procedure SetPutPoint(Lat: Double; Lon: Double; const Description: WideString);
    property DefaultInterface: IGWXDeliveryJob read GetDefaultInterface;
    property GetTime: TDateTime read Get_GetTime;
    property PutTime: TDateTime read Get_PutTime;
    property Name: WideString read Get_Name write Set_Name;
    property GetTimeAfter: TDateTime read Get_GetTimeAfter write Set_GetTimeAfter;
    property GetTimeBefore: TDateTime read Get_GetTimeBefore write Set_GetTimeBefore;
    property PutTimeAfter: TDateTime read Get_PutTimeAfter write Set_PutTimeAfter;
    property PutTimeBefore: TDateTime read Get_PutTimeBefore write Set_PutTimeBefore;
    property Weight: Double read Get_Weight write Set_Weight;
    property Volume: Double read Get_Volume write Set_Volume;
    property Cost: Double read Get_Cost write Set_Cost;
    property Priority: Integer read Get_Priority write Set_Priority;
    property CarTypes: WideString read Get_CarTypes write Set_CarTypes;
    property GetDuration: Double read Get_GetDuration write Set_GetDuration;
    property PutDuration: Double read Get_PutDuration write Set_PutDuration;
    property MaxTransportDuration: Double read Get_MaxTransportDuration write Set_MaxTransportDuration;
    property IndexInRouteGet: Integer read Get_IndexInRouteGet write Set_IndexInRouteGet;
    property IndexInRoutePut: Integer read Get_IndexInRoutePut write Set_IndexInRoutePut;
    property CarName: WideString read Get_CarName write Set_CarName;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TGWXDeliveryJobProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TGWXDeliveryJob
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TGWXDeliveryJobProperties = class(TPersistent)
  private
    FServer:    TGWXDeliveryJob;
    function    GetDefaultInterface: IGWXDeliveryJob;
    constructor Create(AServer: TGWXDeliveryJob);
  protected
    function Get_Name: WideString;
    procedure Set_Name(const pVal: WideString);
    function Get_GetTimeAfter: TDateTime;
    procedure Set_GetTimeAfter(pVal: TDateTime);
    function Get_GetTimeBefore: TDateTime;
    procedure Set_GetTimeBefore(pVal: TDateTime);
    function Get_PutTimeAfter: TDateTime;
    procedure Set_PutTimeAfter(pVal: TDateTime);
    function Get_PutTimeBefore: TDateTime;
    procedure Set_PutTimeBefore(pVal: TDateTime);
    function Get_Weight: Double;
    procedure Set_Weight(pVal: Double);
    function Get_Volume: Double;
    procedure Set_Volume(pVal: Double);
    function Get_Cost: Double;
    procedure Set_Cost(pVal: Double);
    function Get_Priority: Integer;
    procedure Set_Priority(pVal: Integer);
    function Get_CarTypes: WideString;
    procedure Set_CarTypes(const pVal: WideString);
    function Get_GetDuration: Double;
    procedure Set_GetDuration(pVal: Double);
    function Get_PutDuration: Double;
    procedure Set_PutDuration(pVal: Double);
    function Get_MaxTransportDuration: Double;
    procedure Set_MaxTransportDuration(pVal: Double);
    function Get_IndexInRouteGet: Integer;
    procedure Set_IndexInRouteGet(pVal: Integer);
    function Get_IndexInRoutePut: Integer;
    procedure Set_IndexInRoutePut(pVal: Integer);
    function Get_CarName: WideString;
    procedure Set_CarName(const pVal: WideString);
    function Get_GetTime: TDateTime;
    function Get_PutTime: TDateTime;
  public
    property DefaultInterface: IGWXDeliveryJob read GetDefaultInterface;
  published
    property Name: WideString read Get_Name write Set_Name;
    property GetTimeAfter: TDateTime read Get_GetTimeAfter write Set_GetTimeAfter;
    property GetTimeBefore: TDateTime read Get_GetTimeBefore write Set_GetTimeBefore;
    property PutTimeAfter: TDateTime read Get_PutTimeAfter write Set_PutTimeAfter;
    property PutTimeBefore: TDateTime read Get_PutTimeBefore write Set_PutTimeBefore;
    property Weight: Double read Get_Weight write Set_Weight;
    property Volume: Double read Get_Volume write Set_Volume;
    property Cost: Double read Get_Cost write Set_Cost;
    property Priority: Integer read Get_Priority write Set_Priority;
    property CarTypes: WideString read Get_CarTypes write Set_CarTypes;
    property GetDuration: Double read Get_GetDuration write Set_GetDuration;
    property PutDuration: Double read Get_PutDuration write Set_PutDuration;
    property MaxTransportDuration: Double read Get_MaxTransportDuration write Set_MaxTransportDuration;
    property IndexInRouteGet: Integer read Get_IndexInRouteGet write Set_IndexInRouteGet;
    property IndexInRoutePut: Integer read Get_IndexInRoutePut write Set_IndexInRoutePut;
    property CarName: WideString read Get_CarName write Set_CarName;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoGWXDelivery provides a Create and CreateRemote method to          
// create instances of the default interface IGWXDelivery exposed by              
// the CoClass GWXDelivery. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoGWXDelivery = class
    class function Create: IGWXDelivery;
    class function CreateRemote(const MachineName: string): IGWXDelivery;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TGWXDelivery
// Help String      : GWXDelivery Class
// Default Interface: IGWXDelivery
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TGWXDeliveryProperties= class;
{$ENDIF}
  TGWXDelivery = class(TOleServer)
  private
    FIntf: IGWXDelivery;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TGWXDeliveryProperties;
    function GetServerProperties: TGWXDeliveryProperties;
{$ENDIF}
    function GetDefaultInterface: IGWXDelivery;
  protected
    procedure InitServerData; override;
    function Get_OptimizeMode: GWX_OptimizeMode;
    procedure Set_OptimizeMode(pVal: GWX_OptimizeMode);
    function Get_DistributionMethod: GWX_DistributionMethod;
    procedure Set_DistributionMethod(pVal: GWX_DistributionMethod);
    function Get_TripInterval: Double;
    procedure Set_TripInterval(pVal: Double);
    function Get_PathFromGarage: WordBool;
    procedure Set_PathFromGarage(pVal: WordBool);
    function Get_PathToGarage: WordBool;
    procedure Set_PathToGarage(pVal: WordBool);
    function Get_PointOnce: WordBool;
    procedure Set_PointOnce(pVal: WordBool);
    function Get_MultiTrip: WordBool;
    procedure Set_MultiTrip(pVal: WordBool);
    function Get_StackUnloading: WordBool;
    procedure Set_StackUnloading(pVal: WordBool);
    function Get_ProgressDelay: Integer;
    procedure Set_ProgressDelay(pVal: Integer);
    function Get_TotalJobsCount: Integer;
    function Get_NotResolvedJobsCount: Integer;
    function Get_TotalLength: Double;
    function Get_TotalTime: Double;
    function Get_State: GWX_DeliveryState;
    procedure Set_State(pVal: GWX_DeliveryState);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IGWXDelivery);
    procedure Disconnect; override;
    function AddCar: IGWXDeliveryCar;
    function GetCar(IndexOrName: OleVariant): IGWXDeliveryCar;
    function AddJob: IGWXDeliveryJob;
    function GetJob(IndexOrName: OleVariant): IGWXDeliveryJob;
    procedure CalculateRoutes;
    procedure Reset;
    function GetVariants(varSubject: GWX_VariantSubject): IGWStringList;
    function GetErrors: IGWStringList;
    property DefaultInterface: IGWXDelivery read GetDefaultInterface;
    property TotalJobsCount: Integer read Get_TotalJobsCount;
    property NotResolvedJobsCount: Integer read Get_NotResolvedJobsCount;
    property TotalLength: Double read Get_TotalLength;
    property TotalTime: Double read Get_TotalTime;
    property OptimizeMode: GWX_OptimizeMode read Get_OptimizeMode write Set_OptimizeMode;
    property DistributionMethod: GWX_DistributionMethod read Get_DistributionMethod write Set_DistributionMethod;
    property TripInterval: Double read Get_TripInterval write Set_TripInterval;
    property PathFromGarage: WordBool read Get_PathFromGarage write Set_PathFromGarage;
    property PathToGarage: WordBool read Get_PathToGarage write Set_PathToGarage;
    property PointOnce: WordBool read Get_PointOnce write Set_PointOnce;
    property MultiTrip: WordBool read Get_MultiTrip write Set_MultiTrip;
    property StackUnloading: WordBool read Get_StackUnloading write Set_StackUnloading;
    property ProgressDelay: Integer read Get_ProgressDelay write Set_ProgressDelay;
    property State: GWX_DeliveryState read Get_State write Set_State;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TGWXDeliveryProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TGWXDelivery
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TGWXDeliveryProperties = class(TPersistent)
  private
    FServer:    TGWXDelivery;
    function    GetDefaultInterface: IGWXDelivery;
    constructor Create(AServer: TGWXDelivery);
  protected
    function Get_OptimizeMode: GWX_OptimizeMode;
    procedure Set_OptimizeMode(pVal: GWX_OptimizeMode);
    function Get_DistributionMethod: GWX_DistributionMethod;
    procedure Set_DistributionMethod(pVal: GWX_DistributionMethod);
    function Get_TripInterval: Double;
    procedure Set_TripInterval(pVal: Double);
    function Get_PathFromGarage: WordBool;
    procedure Set_PathFromGarage(pVal: WordBool);
    function Get_PathToGarage: WordBool;
    procedure Set_PathToGarage(pVal: WordBool);
    function Get_PointOnce: WordBool;
    procedure Set_PointOnce(pVal: WordBool);
    function Get_MultiTrip: WordBool;
    procedure Set_MultiTrip(pVal: WordBool);
    function Get_StackUnloading: WordBool;
    procedure Set_StackUnloading(pVal: WordBool);
    function Get_ProgressDelay: Integer;
    procedure Set_ProgressDelay(pVal: Integer);
    function Get_TotalJobsCount: Integer;
    function Get_NotResolvedJobsCount: Integer;
    function Get_TotalLength: Double;
    function Get_TotalTime: Double;
    function Get_State: GWX_DeliveryState;
    procedure Set_State(pVal: GWX_DeliveryState);
  public
    property DefaultInterface: IGWXDelivery read GetDefaultInterface;
  published
    property OptimizeMode: GWX_OptimizeMode read Get_OptimizeMode write Set_OptimizeMode;
    property DistributionMethod: GWX_DistributionMethod read Get_DistributionMethod write Set_DistributionMethod;
    property TripInterval: Double read Get_TripInterval write Set_TripInterval;
    property PathFromGarage: WordBool read Get_PathFromGarage write Set_PathFromGarage;
    property PathToGarage: WordBool read Get_PathToGarage write Set_PathToGarage;
    property PointOnce: WordBool read Get_PointOnce write Set_PointOnce;
    property MultiTrip: WordBool read Get_MultiTrip write Set_MultiTrip;
    property StackUnloading: WordBool read Get_StackUnloading write Set_StackUnloading;
    property ProgressDelay: Integer read Get_ProgressDelay write Set_ProgressDelay;
    property State: GWX_DeliveryState read Get_State write Set_State;
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

function TGWControl.Get_DBFLoadedList: IGWStringList;
begin
    Result := DefaultInterface.DBFLoadedList;
end;

function TGWControl.Get_LoadedMaps: IGWTable;
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

function TGWControl.GetInfo(Lat: Double; Lon: Double): IGWTable;
begin
  Result := DefaultInterface.GetInfo(Lat, Lon);
end;

function TGWControl.Search(const Context: WideString): IGWTable;
begin
  Result := DefaultInterface.Search(Context);
end;

function TGWControl.SearchAddress(const Address: WideString; out Lat: Double; out Lon: Double): Integer;
begin
  Result := DefaultInterface.SearchAddress(Address, Lat, Lon);
end;

function TGWControl.GetInfoRect(South: Double; West: Double; North: Double; East: Double): IGWTable;
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

function TGWControl.getAliasCodes: IGWTable;
begin
  Result := DefaultInterface.getAliasCodes;
end;

function TGWControl.getAliasAttributes: IGWTable;
begin
  Result := DefaultInterface.getAliasAttributes;
end;

function TGWControl.getObject(ID: Integer): IGWObject;
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

function TGWControl.getUnloaderDBF: IGWTable;
begin
  Result := DefaultInterface.getUnloaderDBF;
end;

function TGWControl.showAddress(const Address: WideString): Integer;
begin
  Result := DefaultInterface.showAddress(Address);
end;

function TGWControl.GetInfoPolygon(paPolygon: OleVariant; mode: Integer): IGWTable;
begin
  Result := DefaultInterface.GetInfoPolygon(paPolygon, mode);
end;

procedure TGWControl.getBitmap(const sFileName: WideString; North: Double; West: Double; 
                               South: Double; East: Double; pixWidth: Integer; pixHeight: Integer; 
                               nFontSize: Integer);
begin
  DefaultInterface.getBitmap(sFileName, North, West, South, East, pixWidth, pixHeight, nFontSize);
end;

function TGWControl.getExplore: IGWTable;
begin
  Result := DefaultInterface.getExplore;
end;

procedure TGWControl.exploreApply(const Name: WideString; set_: Integer; const Type_: WideString);
begin
  DefaultInterface.exploreApply(Name, set_, Type_);
end;

function TGWControl.getExploreDb: IGWTable;
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

function TGWControl.GetAvailableLookups(const MapOrCodifierName: WideString): IGWTable;
begin
  Result := DefaultInterface.GetAvailableLookups(MapOrCodifierName);
end;

function TGWControl.Table2Map(const LoadCmd: WideString; const Style: WideString; 
                              const pTable: IGWTable): GWX_Errors;
begin
  Result := DefaultInterface.Table2Map(LoadCmd, Style, pTable);
end;

function TGWControl.CreateGWTable: IGWTable;
begin
  Result := DefaultInterface.CreateGWTable;
end;

function TGWControl.CreateGWRoute(const MapName: WideString): IGWRoute;
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

function TGWControl.getObjectTable(ID: Integer): IGWTable;
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

function TGWControl.CreateGWXDelivery(const MapName: WideString): IGWXDelivery;
begin
  Result := DefaultInterface.CreateGWXDelivery(MapName);
end;

function TGWControl.SearchAddressEx(const AddressIn: WideString; flags: LongWord; out Lat: Double; 
                                    out Lon: Double; out AddressOut: WideString): GWX_SearchAddressResult;
begin
  Result := DefaultInterface.SearchAddressEx(AddressIn, flags, Lat, Lon, AddressOut);
end;

procedure TGWControl.ShowLicences;
begin
  DefaultInterface.ShowLicences;
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

function TGWTable.moveFirst: Integer;
begin
  Result := DefaultInterface.moveFirst;
end;

function TGWTable.moveLast: Integer;
begin
  Result := DefaultInterface.moveLast;
end;

function TGWTable.moveNext: Integer;
begin
  Result := DefaultInterface.moveNext;
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

function TGWTable.getTable(ColIndex: Integer): IGWTable;
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

function TGWGraphics.getTable: IGWTable;
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

function TGWRoute.Get_VehicleTypes: IGWStringList;
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

function TGWRoute.GetRoute: IGWTable;
begin
  Result := DefaultInterface.GetRoute;
end;

function TGWRoute.GetVariants: IGWStringList;
begin
  Result := DefaultInterface.GetVariants;
end;

function TGWRoute.GetVariantsTable: IGWTable;
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

function TGWRouteProperties.Get_VehicleTypes: IGWStringList;
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

function TGWStringList.moveFirst: Integer;
begin
  Result := DefaultInterface.moveFirst;
end;

function TGWStringList.moveNext: Integer;
begin
  Result := DefaultInterface.moveNext;
end;

function TGWStringList.GetItem(Index: Integer): WideString;
begin
  Result := DefaultInterface.GetItem(Index);
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

function TGWObject.Get_Attributes: IGWTable;
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

function TGWObject.Get_Links: IGWTable;
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

function TGWObject.getLinks(const nameDbf: WideString): IGWTable;
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

function TGWObjectProperties.Get_Attributes: IGWTable;
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

function TGWObjectProperties.Get_Links: IGWTable;
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

class function CoGWXDeliveryCar.Create: IGWXDeliveryCar;
begin
  Result := CreateComObject(CLASS_GWXDeliveryCar) as IGWXDeliveryCar;
end;

class function CoGWXDeliveryCar.CreateRemote(const MachineName: string): IGWXDeliveryCar;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GWXDeliveryCar) as IGWXDeliveryCar;
end;

procedure TGWXDeliveryCar.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27254A91-AF88-4F8D-B131-45F644AAABDF}';
    IntfIID:   '{85DD6B4F-A29B-4F5B-AE7B-5023D3182126}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGWXDeliveryCar.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IGWXDeliveryCar;
  end;
end;

procedure TGWXDeliveryCar.ConnectTo(svrIntf: IGWXDeliveryCar);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TGWXDeliveryCar.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TGWXDeliveryCar.GetDefaultInterface: IGWXDeliveryCar;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TGWXDeliveryCar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TGWXDeliveryCarProperties.Create(Self);
{$ENDIF}
end;

destructor TGWXDeliveryCar.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TGWXDeliveryCar.GetServerProperties: TGWXDeliveryCarProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TGWXDeliveryCar.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TGWXDeliveryCar.Set_Name(const pVal: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := pVal;
end;

function TGWXDeliveryCar.Get_Description: WideString;
begin
    Result := DefaultInterface.Description;
end;

procedure TGWXDeliveryCar.Set_Description(const pVal: WideString);
  { Warning: The property Description has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Description := pVal;
end;

function TGWXDeliveryCar.Get_MaxWeight: Double;
begin
    Result := DefaultInterface.MaxWeight;
end;

procedure TGWXDeliveryCar.Set_MaxWeight(pVal: Double);
begin
  DefaultInterface.Set_MaxWeight(pVal);
end;

function TGWXDeliveryCar.Get_MaxVolume: Double;
begin
    Result := DefaultInterface.MaxVolume;
end;

procedure TGWXDeliveryCar.Set_MaxVolume(pVal: Double);
begin
  DefaultInterface.Set_MaxVolume(pVal);
end;

function TGWXDeliveryCar.Get_MaxCost: Double;
begin
    Result := DefaultInterface.MaxCost;
end;

procedure TGWXDeliveryCar.Set_MaxCost(pVal: Double);
begin
  DefaultInterface.Set_MaxCost(pVal);
end;

function TGWXDeliveryCar.Get_MaxJobNumber: Integer;
begin
    Result := DefaultInterface.MaxJobNumber;
end;

procedure TGWXDeliveryCar.Set_MaxJobNumber(pVal: Integer);
begin
  DefaultInterface.Set_MaxJobNumber(pVal);
end;

function TGWXDeliveryCar.Get_CarType: WideString;
begin
    Result := DefaultInterface.CarType;
end;

procedure TGWXDeliveryCar.Set_CarType(const pVal: WideString);
  { Warning: The property CarType has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.CarType := pVal;
end;

function TGWXDeliveryCar.Get_WorkBegin: TDateTime;
begin
    Result := DefaultInterface.WorkBegin;
end;

procedure TGWXDeliveryCar.Set_WorkBegin(pVal: TDateTime);
begin
  DefaultInterface.Set_WorkBegin(pVal);
end;

function TGWXDeliveryCar.Get_WorkEnd: TDateTime;
begin
    Result := DefaultInterface.WorkEnd;
end;

procedure TGWXDeliveryCar.Set_WorkEnd(pVal: TDateTime);
begin
  DefaultInterface.Set_WorkEnd(pVal);
end;

function TGWXDeliveryCar.Get_MaxRouteLength: Double;
begin
    Result := DefaultInterface.MaxRouteLength;
end;

procedure TGWXDeliveryCar.Set_MaxRouteLength(pVal: Double);
begin
  DefaultInterface.Set_MaxRouteLength(pVal);
end;

function TGWXDeliveryCar.Get_MaxRouteTime: Double;
begin
    Result := DefaultInterface.MaxRouteTime;
end;

procedure TGWXDeliveryCar.Set_MaxRouteTime(pVal: Double);
begin
  DefaultInterface.Set_MaxRouteTime(pVal);
end;

function TGWXDeliveryCar.Get_SpeedCoefficient: Double;
begin
    Result := DefaultInterface.SpeedCoefficient;
end;

procedure TGWXDeliveryCar.Set_SpeedCoefficient(pVal: Double);
begin
  DefaultInterface.Set_SpeedCoefficient(pVal);
end;

function TGWXDeliveryCar.Get_OwnWeight: Double;
begin
    Result := DefaultInterface.OwnWeight;
end;

procedure TGWXDeliveryCar.Set_OwnWeight(pVal: Double);
begin
  DefaultInterface.Set_OwnWeight(pVal);
end;

function TGWXDeliveryCar.Get_FuelConsumption: Double;
begin
    Result := DefaultInterface.FuelConsumption;
end;

procedure TGWXDeliveryCar.Set_FuelConsumption(pVal: Double);
begin
  DefaultInterface.Set_FuelConsumption(pVal);
end;

function TGWXDeliveryCar.Get_Cargo: Double;
begin
    Result := DefaultInterface.Cargo;
end;

procedure TGWXDeliveryCar.Set_Cargo(pVal: Double);
begin
  DefaultInterface.Set_Cargo(pVal);
end;

function TGWXDeliveryCar.Get_Width: Double;
begin
    Result := DefaultInterface.Width;
end;

procedure TGWXDeliveryCar.Set_Width(pVal: Double);
begin
  DefaultInterface.Set_Width(pVal);
end;

function TGWXDeliveryCar.Get_Height: Double;
begin
    Result := DefaultInterface.Height;
end;

procedure TGWXDeliveryCar.Set_Height(pVal: Double);
begin
  DefaultInterface.Set_Height(pVal);
end;

function TGWXDeliveryCar.Get_Licence: WideString;
begin
    Result := DefaultInterface.Licence;
end;

procedure TGWXDeliveryCar.Set_Licence(const pVal: WideString);
  { Warning: The property Licence has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Licence := pVal;
end;

function TGWXDeliveryCar.Get_ResRouteLength: Double;
begin
    Result := DefaultInterface.ResRouteLength;
end;

function TGWXDeliveryCar.Get_ResRouteTime: Double;
begin
    Result := DefaultInterface.ResRouteTime;
end;

function TGWXDeliveryCar.Get_ResJobCount: Integer;
begin
    Result := DefaultInterface.ResJobCount;
end;

function TGWXDeliveryCar.Get_ResViolationsCount: Integer;
begin
    Result := DefaultInterface.ResViolationsCount;
end;

function TGWXDeliveryCar.Get_ResRouteBegin: TDateTime;
begin
    Result := DefaultInterface.ResRouteBegin;
end;

function TGWXDeliveryCar.Get_ResRouteEnd: TDateTime;
begin
    Result := DefaultInterface.ResRouteEnd;
end;

function TGWXDeliveryCar.Get_ResPointsCount: Integer;
begin
    Result := DefaultInterface.ResPointsCount;
end;

procedure TGWXDeliveryCar.SetGarage(Lat: Double; Lon: Double; const Description: WideString);
begin
  DefaultInterface.SetGarage(Lat, Lon, Description);
end;

function TGWXDeliveryCar.GetRoute: IGWTable;
begin
  Result := DefaultInterface.GetRoute;
end;

procedure TGWXDeliveryCar.GetPosition(time: TDateTime; out Lat: Double; out Lon: Double; 
                                      out RtPointIx: Integer; out PathPointIx: Integer; 
                                      out JobCount: Integer);
begin
  DefaultInterface.GetPosition(time, Lat, Lon, RtPointIx, PathPointIx, JobCount);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TGWXDeliveryCarProperties.Create(AServer: TGWXDeliveryCar);
begin
  inherited Create;
  FServer := AServer;
end;

function TGWXDeliveryCarProperties.GetDefaultInterface: IGWXDeliveryCar;
begin
  Result := FServer.DefaultInterface;
end;

function TGWXDeliveryCarProperties.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TGWXDeliveryCarProperties.Set_Name(const pVal: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := pVal;
end;

function TGWXDeliveryCarProperties.Get_Description: WideString;
begin
    Result := DefaultInterface.Description;
end;

procedure TGWXDeliveryCarProperties.Set_Description(const pVal: WideString);
  { Warning: The property Description has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Description := pVal;
end;

function TGWXDeliveryCarProperties.Get_MaxWeight: Double;
begin
    Result := DefaultInterface.MaxWeight;
end;

procedure TGWXDeliveryCarProperties.Set_MaxWeight(pVal: Double);
begin
  DefaultInterface.Set_MaxWeight(pVal);
end;

function TGWXDeliveryCarProperties.Get_MaxVolume: Double;
begin
    Result := DefaultInterface.MaxVolume;
end;

procedure TGWXDeliveryCarProperties.Set_MaxVolume(pVal: Double);
begin
  DefaultInterface.Set_MaxVolume(pVal);
end;

function TGWXDeliveryCarProperties.Get_MaxCost: Double;
begin
    Result := DefaultInterface.MaxCost;
end;

procedure TGWXDeliveryCarProperties.Set_MaxCost(pVal: Double);
begin
  DefaultInterface.Set_MaxCost(pVal);
end;

function TGWXDeliveryCarProperties.Get_MaxJobNumber: Integer;
begin
    Result := DefaultInterface.MaxJobNumber;
end;

procedure TGWXDeliveryCarProperties.Set_MaxJobNumber(pVal: Integer);
begin
  DefaultInterface.Set_MaxJobNumber(pVal);
end;

function TGWXDeliveryCarProperties.Get_CarType: WideString;
begin
    Result := DefaultInterface.CarType;
end;

procedure TGWXDeliveryCarProperties.Set_CarType(const pVal: WideString);
  { Warning: The property CarType has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.CarType := pVal;
end;

function TGWXDeliveryCarProperties.Get_WorkBegin: TDateTime;
begin
    Result := DefaultInterface.WorkBegin;
end;

procedure TGWXDeliveryCarProperties.Set_WorkBegin(pVal: TDateTime);
begin
  DefaultInterface.Set_WorkBegin(pVal);
end;

function TGWXDeliveryCarProperties.Get_WorkEnd: TDateTime;
begin
    Result := DefaultInterface.WorkEnd;
end;

procedure TGWXDeliveryCarProperties.Set_WorkEnd(pVal: TDateTime);
begin
  DefaultInterface.Set_WorkEnd(pVal);
end;

function TGWXDeliveryCarProperties.Get_MaxRouteLength: Double;
begin
    Result := DefaultInterface.MaxRouteLength;
end;

procedure TGWXDeliveryCarProperties.Set_MaxRouteLength(pVal: Double);
begin
  DefaultInterface.Set_MaxRouteLength(pVal);
end;

function TGWXDeliveryCarProperties.Get_MaxRouteTime: Double;
begin
    Result := DefaultInterface.MaxRouteTime;
end;

procedure TGWXDeliveryCarProperties.Set_MaxRouteTime(pVal: Double);
begin
  DefaultInterface.Set_MaxRouteTime(pVal);
end;

function TGWXDeliveryCarProperties.Get_SpeedCoefficient: Double;
begin
    Result := DefaultInterface.SpeedCoefficient;
end;

procedure TGWXDeliveryCarProperties.Set_SpeedCoefficient(pVal: Double);
begin
  DefaultInterface.Set_SpeedCoefficient(pVal);
end;

function TGWXDeliveryCarProperties.Get_OwnWeight: Double;
begin
    Result := DefaultInterface.OwnWeight;
end;

procedure TGWXDeliveryCarProperties.Set_OwnWeight(pVal: Double);
begin
  DefaultInterface.Set_OwnWeight(pVal);
end;

function TGWXDeliveryCarProperties.Get_FuelConsumption: Double;
begin
    Result := DefaultInterface.FuelConsumption;
end;

procedure TGWXDeliveryCarProperties.Set_FuelConsumption(pVal: Double);
begin
  DefaultInterface.Set_FuelConsumption(pVal);
end;

function TGWXDeliveryCarProperties.Get_Cargo: Double;
begin
    Result := DefaultInterface.Cargo;
end;

procedure TGWXDeliveryCarProperties.Set_Cargo(pVal: Double);
begin
  DefaultInterface.Set_Cargo(pVal);
end;

function TGWXDeliveryCarProperties.Get_Width: Double;
begin
    Result := DefaultInterface.Width;
end;

procedure TGWXDeliveryCarProperties.Set_Width(pVal: Double);
begin
  DefaultInterface.Set_Width(pVal);
end;

function TGWXDeliveryCarProperties.Get_Height: Double;
begin
    Result := DefaultInterface.Height;
end;

procedure TGWXDeliveryCarProperties.Set_Height(pVal: Double);
begin
  DefaultInterface.Set_Height(pVal);
end;

function TGWXDeliveryCarProperties.Get_Licence: WideString;
begin
    Result := DefaultInterface.Licence;
end;

procedure TGWXDeliveryCarProperties.Set_Licence(const pVal: WideString);
  { Warning: The property Licence has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Licence := pVal;
end;

function TGWXDeliveryCarProperties.Get_ResRouteLength: Double;
begin
    Result := DefaultInterface.ResRouteLength;
end;

function TGWXDeliveryCarProperties.Get_ResRouteTime: Double;
begin
    Result := DefaultInterface.ResRouteTime;
end;

function TGWXDeliveryCarProperties.Get_ResJobCount: Integer;
begin
    Result := DefaultInterface.ResJobCount;
end;

function TGWXDeliveryCarProperties.Get_ResViolationsCount: Integer;
begin
    Result := DefaultInterface.ResViolationsCount;
end;

function TGWXDeliveryCarProperties.Get_ResRouteBegin: TDateTime;
begin
    Result := DefaultInterface.ResRouteBegin;
end;

function TGWXDeliveryCarProperties.Get_ResRouteEnd: TDateTime;
begin
    Result := DefaultInterface.ResRouteEnd;
end;

function TGWXDeliveryCarProperties.Get_ResPointsCount: Integer;
begin
    Result := DefaultInterface.ResPointsCount;
end;

{$ENDIF}

class function CoGWXDeliveryJob.Create: IGWXDeliveryJob;
begin
  Result := CreateComObject(CLASS_GWXDeliveryJob) as IGWXDeliveryJob;
end;

class function CoGWXDeliveryJob.CreateRemote(const MachineName: string): IGWXDeliveryJob;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GWXDeliveryJob) as IGWXDeliveryJob;
end;

procedure TGWXDeliveryJob.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6A1BDC7C-2736-4758-962E-855FF4D66F66}';
    IntfIID:   '{5F2C8425-988B-400B-BF9B-ACFB9C972EF0}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGWXDeliveryJob.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IGWXDeliveryJob;
  end;
end;

procedure TGWXDeliveryJob.ConnectTo(svrIntf: IGWXDeliveryJob);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TGWXDeliveryJob.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TGWXDeliveryJob.GetDefaultInterface: IGWXDeliveryJob;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TGWXDeliveryJob.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TGWXDeliveryJobProperties.Create(Self);
{$ENDIF}
end;

destructor TGWXDeliveryJob.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TGWXDeliveryJob.GetServerProperties: TGWXDeliveryJobProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TGWXDeliveryJob.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TGWXDeliveryJob.Set_Name(const pVal: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := pVal;
end;

function TGWXDeliveryJob.Get_GetTimeAfter: TDateTime;
begin
    Result := DefaultInterface.GetTimeAfter;
end;

procedure TGWXDeliveryJob.Set_GetTimeAfter(pVal: TDateTime);
begin
  DefaultInterface.Set_GetTimeAfter(pVal);
end;

function TGWXDeliveryJob.Get_GetTimeBefore: TDateTime;
begin
    Result := DefaultInterface.GetTimeBefore;
end;

procedure TGWXDeliveryJob.Set_GetTimeBefore(pVal: TDateTime);
begin
  DefaultInterface.Set_GetTimeBefore(pVal);
end;

function TGWXDeliveryJob.Get_PutTimeAfter: TDateTime;
begin
    Result := DefaultInterface.PutTimeAfter;
end;

procedure TGWXDeliveryJob.Set_PutTimeAfter(pVal: TDateTime);
begin
  DefaultInterface.Set_PutTimeAfter(pVal);
end;

function TGWXDeliveryJob.Get_PutTimeBefore: TDateTime;
begin
    Result := DefaultInterface.PutTimeBefore;
end;

procedure TGWXDeliveryJob.Set_PutTimeBefore(pVal: TDateTime);
begin
  DefaultInterface.Set_PutTimeBefore(pVal);
end;

function TGWXDeliveryJob.Get_Weight: Double;
begin
    Result := DefaultInterface.Weight;
end;

procedure TGWXDeliveryJob.Set_Weight(pVal: Double);
begin
  DefaultInterface.Set_Weight(pVal);
end;

function TGWXDeliveryJob.Get_Volume: Double;
begin
    Result := DefaultInterface.Volume;
end;

procedure TGWXDeliveryJob.Set_Volume(pVal: Double);
begin
  DefaultInterface.Set_Volume(pVal);
end;

function TGWXDeliveryJob.Get_Cost: Double;
begin
    Result := DefaultInterface.Cost;
end;

procedure TGWXDeliveryJob.Set_Cost(pVal: Double);
begin
  DefaultInterface.Set_Cost(pVal);
end;

function TGWXDeliveryJob.Get_Priority: Integer;
begin
    Result := DefaultInterface.Priority;
end;

procedure TGWXDeliveryJob.Set_Priority(pVal: Integer);
begin
  DefaultInterface.Set_Priority(pVal);
end;

function TGWXDeliveryJob.Get_CarTypes: WideString;
begin
    Result := DefaultInterface.CarTypes;
end;

procedure TGWXDeliveryJob.Set_CarTypes(const pVal: WideString);
  { Warning: The property CarTypes has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.CarTypes := pVal;
end;

function TGWXDeliveryJob.Get_GetDuration: Double;
begin
    Result := DefaultInterface.GetDuration;
end;

procedure TGWXDeliveryJob.Set_GetDuration(pVal: Double);
begin
  DefaultInterface.Set_GetDuration(pVal);
end;

function TGWXDeliveryJob.Get_PutDuration: Double;
begin
    Result := DefaultInterface.PutDuration;
end;

procedure TGWXDeliveryJob.Set_PutDuration(pVal: Double);
begin
  DefaultInterface.Set_PutDuration(pVal);
end;

function TGWXDeliveryJob.Get_MaxTransportDuration: Double;
begin
    Result := DefaultInterface.MaxTransportDuration;
end;

procedure TGWXDeliveryJob.Set_MaxTransportDuration(pVal: Double);
begin
  DefaultInterface.Set_MaxTransportDuration(pVal);
end;

function TGWXDeliveryJob.Get_IndexInRouteGet: Integer;
begin
    Result := DefaultInterface.IndexInRouteGet;
end;

procedure TGWXDeliveryJob.Set_IndexInRouteGet(pVal: Integer);
begin
  DefaultInterface.Set_IndexInRouteGet(pVal);
end;

function TGWXDeliveryJob.Get_IndexInRoutePut: Integer;
begin
    Result := DefaultInterface.IndexInRoutePut;
end;

procedure TGWXDeliveryJob.Set_IndexInRoutePut(pVal: Integer);
begin
  DefaultInterface.Set_IndexInRoutePut(pVal);
end;

function TGWXDeliveryJob.Get_CarName: WideString;
begin
    Result := DefaultInterface.CarName;
end;

procedure TGWXDeliveryJob.Set_CarName(const pVal: WideString);
  { Warning: The property CarName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.CarName := pVal;
end;

function TGWXDeliveryJob.Get_GetTime: TDateTime;
begin
    Result := DefaultInterface.GetTime;
end;

function TGWXDeliveryJob.Get_PutTime: TDateTime;
begin
    Result := DefaultInterface.PutTime;
end;

procedure TGWXDeliveryJob.SetGetPoint(Lat: Double; Lon: Double; const Description: WideString);
begin
  DefaultInterface.SetGetPoint(Lat, Lon, Description);
end;

procedure TGWXDeliveryJob.SetPutPoint(Lat: Double; Lon: Double; const Description: WideString);
begin
  DefaultInterface.SetPutPoint(Lat, Lon, Description);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TGWXDeliveryJobProperties.Create(AServer: TGWXDeliveryJob);
begin
  inherited Create;
  FServer := AServer;
end;

function TGWXDeliveryJobProperties.GetDefaultInterface: IGWXDeliveryJob;
begin
  Result := FServer.DefaultInterface;
end;

function TGWXDeliveryJobProperties.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TGWXDeliveryJobProperties.Set_Name(const pVal: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := pVal;
end;

function TGWXDeliveryJobProperties.Get_GetTimeAfter: TDateTime;
begin
    Result := DefaultInterface.GetTimeAfter;
end;

procedure TGWXDeliveryJobProperties.Set_GetTimeAfter(pVal: TDateTime);
begin
  DefaultInterface.Set_GetTimeAfter(pVal);
end;

function TGWXDeliveryJobProperties.Get_GetTimeBefore: TDateTime;
begin
    Result := DefaultInterface.GetTimeBefore;
end;

procedure TGWXDeliveryJobProperties.Set_GetTimeBefore(pVal: TDateTime);
begin
  DefaultInterface.Set_GetTimeBefore(pVal);
end;

function TGWXDeliveryJobProperties.Get_PutTimeAfter: TDateTime;
begin
    Result := DefaultInterface.PutTimeAfter;
end;

procedure TGWXDeliveryJobProperties.Set_PutTimeAfter(pVal: TDateTime);
begin
  DefaultInterface.Set_PutTimeAfter(pVal);
end;

function TGWXDeliveryJobProperties.Get_PutTimeBefore: TDateTime;
begin
    Result := DefaultInterface.PutTimeBefore;
end;

procedure TGWXDeliveryJobProperties.Set_PutTimeBefore(pVal: TDateTime);
begin
  DefaultInterface.Set_PutTimeBefore(pVal);
end;

function TGWXDeliveryJobProperties.Get_Weight: Double;
begin
    Result := DefaultInterface.Weight;
end;

procedure TGWXDeliveryJobProperties.Set_Weight(pVal: Double);
begin
  DefaultInterface.Set_Weight(pVal);
end;

function TGWXDeliveryJobProperties.Get_Volume: Double;
begin
    Result := DefaultInterface.Volume;
end;

procedure TGWXDeliveryJobProperties.Set_Volume(pVal: Double);
begin
  DefaultInterface.Set_Volume(pVal);
end;

function TGWXDeliveryJobProperties.Get_Cost: Double;
begin
    Result := DefaultInterface.Cost;
end;

procedure TGWXDeliveryJobProperties.Set_Cost(pVal: Double);
begin
  DefaultInterface.Set_Cost(pVal);
end;

function TGWXDeliveryJobProperties.Get_Priority: Integer;
begin
    Result := DefaultInterface.Priority;
end;

procedure TGWXDeliveryJobProperties.Set_Priority(pVal: Integer);
begin
  DefaultInterface.Set_Priority(pVal);
end;

function TGWXDeliveryJobProperties.Get_CarTypes: WideString;
begin
    Result := DefaultInterface.CarTypes;
end;

procedure TGWXDeliveryJobProperties.Set_CarTypes(const pVal: WideString);
  { Warning: The property CarTypes has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.CarTypes := pVal;
end;

function TGWXDeliveryJobProperties.Get_GetDuration: Double;
begin
    Result := DefaultInterface.GetDuration;
end;

procedure TGWXDeliveryJobProperties.Set_GetDuration(pVal: Double);
begin
  DefaultInterface.Set_GetDuration(pVal);
end;

function TGWXDeliveryJobProperties.Get_PutDuration: Double;
begin
    Result := DefaultInterface.PutDuration;
end;

procedure TGWXDeliveryJobProperties.Set_PutDuration(pVal: Double);
begin
  DefaultInterface.Set_PutDuration(pVal);
end;

function TGWXDeliveryJobProperties.Get_MaxTransportDuration: Double;
begin
    Result := DefaultInterface.MaxTransportDuration;
end;

procedure TGWXDeliveryJobProperties.Set_MaxTransportDuration(pVal: Double);
begin
  DefaultInterface.Set_MaxTransportDuration(pVal);
end;

function TGWXDeliveryJobProperties.Get_IndexInRouteGet: Integer;
begin
    Result := DefaultInterface.IndexInRouteGet;
end;

procedure TGWXDeliveryJobProperties.Set_IndexInRouteGet(pVal: Integer);
begin
  DefaultInterface.Set_IndexInRouteGet(pVal);
end;

function TGWXDeliveryJobProperties.Get_IndexInRoutePut: Integer;
begin
    Result := DefaultInterface.IndexInRoutePut;
end;

procedure TGWXDeliveryJobProperties.Set_IndexInRoutePut(pVal: Integer);
begin
  DefaultInterface.Set_IndexInRoutePut(pVal);
end;

function TGWXDeliveryJobProperties.Get_CarName: WideString;
begin
    Result := DefaultInterface.CarName;
end;

procedure TGWXDeliveryJobProperties.Set_CarName(const pVal: WideString);
  { Warning: The property CarName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.CarName := pVal;
end;

function TGWXDeliveryJobProperties.Get_GetTime: TDateTime;
begin
    Result := DefaultInterface.GetTime;
end;

function TGWXDeliveryJobProperties.Get_PutTime: TDateTime;
begin
    Result := DefaultInterface.PutTime;
end;

{$ENDIF}

class function CoGWXDelivery.Create: IGWXDelivery;
begin
  Result := CreateComObject(CLASS_GWXDelivery) as IGWXDelivery;
end;

class function CoGWXDelivery.CreateRemote(const MachineName: string): IGWXDelivery;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GWXDelivery) as IGWXDelivery;
end;

procedure TGWXDelivery.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{13BA2C05-8BD2-444F-B8A8-5036F269EF15}';
    IntfIID:   '{E3465126-5EF7-482C-8C48-393941EB5713}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGWXDelivery.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IGWXDelivery;
  end;
end;

procedure TGWXDelivery.ConnectTo(svrIntf: IGWXDelivery);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TGWXDelivery.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TGWXDelivery.GetDefaultInterface: IGWXDelivery;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TGWXDelivery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TGWXDeliveryProperties.Create(Self);
{$ENDIF}
end;

destructor TGWXDelivery.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TGWXDelivery.GetServerProperties: TGWXDeliveryProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TGWXDelivery.Get_OptimizeMode: GWX_OptimizeMode;
begin
    Result := DefaultInterface.OptimizeMode;
end;

procedure TGWXDelivery.Set_OptimizeMode(pVal: GWX_OptimizeMode);
begin
  DefaultInterface.Set_OptimizeMode(pVal);
end;

function TGWXDelivery.Get_DistributionMethod: GWX_DistributionMethod;
begin
    Result := DefaultInterface.DistributionMethod;
end;

procedure TGWXDelivery.Set_DistributionMethod(pVal: GWX_DistributionMethod);
begin
  DefaultInterface.Set_DistributionMethod(pVal);
end;

function TGWXDelivery.Get_TripInterval: Double;
begin
    Result := DefaultInterface.TripInterval;
end;

procedure TGWXDelivery.Set_TripInterval(pVal: Double);
begin
  DefaultInterface.Set_TripInterval(pVal);
end;

function TGWXDelivery.Get_PathFromGarage: WordBool;
begin
    Result := DefaultInterface.PathFromGarage;
end;

procedure TGWXDelivery.Set_PathFromGarage(pVal: WordBool);
begin
  DefaultInterface.Set_PathFromGarage(pVal);
end;

function TGWXDelivery.Get_PathToGarage: WordBool;
begin
    Result := DefaultInterface.PathToGarage;
end;

procedure TGWXDelivery.Set_PathToGarage(pVal: WordBool);
begin
  DefaultInterface.Set_PathToGarage(pVal);
end;

function TGWXDelivery.Get_PointOnce: WordBool;
begin
    Result := DefaultInterface.PointOnce;
end;

procedure TGWXDelivery.Set_PointOnce(pVal: WordBool);
begin
  DefaultInterface.Set_PointOnce(pVal);
end;

function TGWXDelivery.Get_MultiTrip: WordBool;
begin
    Result := DefaultInterface.MultiTrip;
end;

procedure TGWXDelivery.Set_MultiTrip(pVal: WordBool);
begin
  DefaultInterface.Set_MultiTrip(pVal);
end;

function TGWXDelivery.Get_StackUnloading: WordBool;
begin
    Result := DefaultInterface.StackUnloading;
end;

procedure TGWXDelivery.Set_StackUnloading(pVal: WordBool);
begin
  DefaultInterface.Set_StackUnloading(pVal);
end;

function TGWXDelivery.Get_ProgressDelay: Integer;
begin
    Result := DefaultInterface.ProgressDelay;
end;

procedure TGWXDelivery.Set_ProgressDelay(pVal: Integer);
begin
  DefaultInterface.Set_ProgressDelay(pVal);
end;

function TGWXDelivery.Get_TotalJobsCount: Integer;
begin
    Result := DefaultInterface.TotalJobsCount;
end;

function TGWXDelivery.Get_NotResolvedJobsCount: Integer;
begin
    Result := DefaultInterface.NotResolvedJobsCount;
end;

function TGWXDelivery.Get_TotalLength: Double;
begin
    Result := DefaultInterface.TotalLength;
end;

function TGWXDelivery.Get_TotalTime: Double;
begin
    Result := DefaultInterface.TotalTime;
end;

function TGWXDelivery.Get_State: GWX_DeliveryState;
begin
    Result := DefaultInterface.State;
end;

procedure TGWXDelivery.Set_State(pVal: GWX_DeliveryState);
begin
  DefaultInterface.Set_State(pVal);
end;

function TGWXDelivery.AddCar: IGWXDeliveryCar;
begin
  Result := DefaultInterface.AddCar;
end;

function TGWXDelivery.GetCar(IndexOrName: OleVariant): IGWXDeliveryCar;
begin
  Result := DefaultInterface.GetCar(IndexOrName);
end;

function TGWXDelivery.AddJob: IGWXDeliveryJob;
begin
  Result := DefaultInterface.AddJob;
end;

function TGWXDelivery.GetJob(IndexOrName: OleVariant): IGWXDeliveryJob;
begin
  Result := DefaultInterface.GetJob(IndexOrName);
end;

procedure TGWXDelivery.CalculateRoutes;
begin
  DefaultInterface.CalculateRoutes;
end;

procedure TGWXDelivery.Reset;
begin
  DefaultInterface.Reset;
end;

function TGWXDelivery.GetVariants(varSubject: GWX_VariantSubject): IGWStringList;
begin
  Result := DefaultInterface.GetVariants(varSubject);
end;

function TGWXDelivery.GetErrors: IGWStringList;
begin
  Result := DefaultInterface.GetErrors;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TGWXDeliveryProperties.Create(AServer: TGWXDelivery);
begin
  inherited Create;
  FServer := AServer;
end;

function TGWXDeliveryProperties.GetDefaultInterface: IGWXDelivery;
begin
  Result := FServer.DefaultInterface;
end;

function TGWXDeliveryProperties.Get_OptimizeMode: GWX_OptimizeMode;
begin
    Result := DefaultInterface.OptimizeMode;
end;

procedure TGWXDeliveryProperties.Set_OptimizeMode(pVal: GWX_OptimizeMode);
begin
  DefaultInterface.Set_OptimizeMode(pVal);
end;

function TGWXDeliveryProperties.Get_DistributionMethod: GWX_DistributionMethod;
begin
    Result := DefaultInterface.DistributionMethod;
end;

procedure TGWXDeliveryProperties.Set_DistributionMethod(pVal: GWX_DistributionMethod);
begin
  DefaultInterface.Set_DistributionMethod(pVal);
end;

function TGWXDeliveryProperties.Get_TripInterval: Double;
begin
    Result := DefaultInterface.TripInterval;
end;

procedure TGWXDeliveryProperties.Set_TripInterval(pVal: Double);
begin
  DefaultInterface.Set_TripInterval(pVal);
end;

function TGWXDeliveryProperties.Get_PathFromGarage: WordBool;
begin
    Result := DefaultInterface.PathFromGarage;
end;

procedure TGWXDeliveryProperties.Set_PathFromGarage(pVal: WordBool);
begin
  DefaultInterface.Set_PathFromGarage(pVal);
end;

function TGWXDeliveryProperties.Get_PathToGarage: WordBool;
begin
    Result := DefaultInterface.PathToGarage;
end;

procedure TGWXDeliveryProperties.Set_PathToGarage(pVal: WordBool);
begin
  DefaultInterface.Set_PathToGarage(pVal);
end;

function TGWXDeliveryProperties.Get_PointOnce: WordBool;
begin
    Result := DefaultInterface.PointOnce;
end;

procedure TGWXDeliveryProperties.Set_PointOnce(pVal: WordBool);
begin
  DefaultInterface.Set_PointOnce(pVal);
end;

function TGWXDeliveryProperties.Get_MultiTrip: WordBool;
begin
    Result := DefaultInterface.MultiTrip;
end;

procedure TGWXDeliveryProperties.Set_MultiTrip(pVal: WordBool);
begin
  DefaultInterface.Set_MultiTrip(pVal);
end;

function TGWXDeliveryProperties.Get_StackUnloading: WordBool;
begin
    Result := DefaultInterface.StackUnloading;
end;

procedure TGWXDeliveryProperties.Set_StackUnloading(pVal: WordBool);
begin
  DefaultInterface.Set_StackUnloading(pVal);
end;

function TGWXDeliveryProperties.Get_ProgressDelay: Integer;
begin
    Result := DefaultInterface.ProgressDelay;
end;

procedure TGWXDeliveryProperties.Set_ProgressDelay(pVal: Integer);
begin
  DefaultInterface.Set_ProgressDelay(pVal);
end;

function TGWXDeliveryProperties.Get_TotalJobsCount: Integer;
begin
    Result := DefaultInterface.TotalJobsCount;
end;

function TGWXDeliveryProperties.Get_NotResolvedJobsCount: Integer;
begin
    Result := DefaultInterface.NotResolvedJobsCount;
end;

function TGWXDeliveryProperties.Get_TotalLength: Double;
begin
    Result := DefaultInterface.TotalLength;
end;

function TGWXDeliveryProperties.Get_TotalTime: Double;
begin
    Result := DefaultInterface.TotalTime;
end;

function TGWXDeliveryProperties.Get_State: GWX_DeliveryState;
begin
    Result := DefaultInterface.State;
end;

procedure TGWXDeliveryProperties.Set_State(pVal: GWX_DeliveryState);
begin
  DefaultInterface.Set_State(pVal);
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TGWControl]);
  RegisterComponents(dtlServerPage, [TGWTable, TGWGraphics, TGWRoute, TGWStringList, 
    TGWObject, TGWXDeliveryCar, TGWXDeliveryJob, TGWXDelivery]);
end;

end.
