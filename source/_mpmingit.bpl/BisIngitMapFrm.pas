unit BisIngitMapFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Menus, ActnPopup, ActnList, ComCtrls, ToolWin, StdCtrls, ExtCtrls,
  ActiveX,
  GWXLib_TLB,
  BisMapFrm;

type
  TBisIngitMapFrame = class(TBisMapFrame)
  private
    FMap: TGWControl;
    FFileName: String;
    FCurrentLat: Extended;
    FCurrentLon: Extended;
    function TranslateLength(ALength: Double): Double;
    procedure ScaleRoute(Points: TBisMapFramePoints);
  protected
    function GetCurrentLat: Double; override;
    function GetCurrentLon: Double; override;
    procedure MapMouseAction(ASender: TObject; Action: tagGWX_MouseAction; uMsg: Integer; x: Integer; y: Integer; out bHandled: Integer); virtual;
    procedure MapKeyboardAction(ASender: TObject; Action: TOleEnum; uMsg, KeyCode: Integer; out bHandled: Integer); virtual;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure PrepareMap; override;
    function MapExists: Boolean; override;
    function MapLoaded: Boolean; override;
    procedure LoadFromFile(const FileName: String); override;

    procedure OpenMap; override;
    procedure OverviewMap; override;
    procedure MoveMap; override;
    procedure ZoomInMap; override;
    procedure ZoomOutMap; override;
    procedure DistanceMap; override;
    procedure RouteMap; override;

    function GetRouteDistance(Lat1, Lon1, Lat2, Lon2: Double): Double; override;
    function GetRouteDistance(Points: TBisMapFramePoints): Double; override;

    procedure VisibleRoute(Points: TBisMapFramePoints); override;

    property Map: TGWControl read FMap;
  end;

implementation

uses
     BisLogger, BisUtils;

{$R *.dfm}

{ TBisIngitMapFrame }

constructor TBisIngitMapFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  try
    FMap:=TGWControl.Create(Self);
    FMap.Parent:=PanelMap;
    FMap.Align:=alClient;
    FMap.OnMouseAction:=MapMouseAction;
    FMap.OnKeyboardAction:=MapKeyboardAction;
    FMap.mouseLeftType:=1;
    FMap.mouseRightType:=0;
  except
    On E: Exception do
      LoggerWrite(E.Message,ltError);
  end;
end;

destructor TBisIngitMapFrame.Destroy;
begin
  if Assigned(FMap) then
    FMap.MapName:='';
  FMap.Free;
  inherited Destroy;
end;

procedure TBisIngitMapFrame.LoadFromFile(const FileName: String);
begin
  if FileExists(FileName) then begin
    FFileName:=FileName;
    OpenMap;
  end;
end;

function TBisIngitMapFrame.MapExists: Boolean;
begin
  Result:=Assigned(FMap) and FileExists(FMap.MapName);
end;

function TBisIngitMapFrame.MapLoaded: Boolean;
begin
  Result:=Assigned(FMap) and (FMap.MapAttached>0);
end;

function TBisIngitMapFrame.GetCurrentLat: Double;
begin
  Result:=inherited GetCurrentLat;
  if MapLoaded then
    Result:=FCurrentLat;
end;

function TBisIngitMapFrame.GetCurrentLon: Double;
begin
  Result:=inherited GetCurrentLon;
  if MapLoaded then
    Result:=FCurrentLon;
end;

procedure TBisIngitMapFrame.MapMouseAction(ASender: TObject; Action: tagGWX_MouseAction; uMsg, x, y: Integer; out bHandled: Integer);
var
  Pt: TPoint;
  Lat,Lon: Double;
begin
  if MapLoaded then begin

    if Action=GWX_RButtonDown then begin
      FMap.Dev2Geo(x,y,Lat,Lon);
      FCurrentLat:=Lat;
      FCurrentLon:=Lon;
      Pt.X:=X;
      Pt.Y:=Y;
      Pt:=FMap.ClientToScreen(Pt);
      Popup.Popup(Pt.X,Pt.Y);
    end;

    if Action=GWX_MouseMove then begin
      FMap.Dev2Geo(x,y,Lat,Lon);
      FCurrentLat:=Lat;
      FCurrentLon:=Lon;
    end;

    case Mode of
      mmRoute: begin
        if Action=GWX_LButtonDown then begin


        end;
      end;
    end;
    
  end;
  
end;

procedure TBisIngitMapFrame.MapKeyboardAction(ASender: TObject; Action: TOleEnum; uMsg, KeyCode: Integer; out bHandled: Integer);
var
  Pt: TPoint;
begin
  if (KeyCode=VK_F10) then begin
    Pt.X:=0;
    Pt.Y:=0;
    Pt:=FMap.ClientToScreen(Pt);
    Popup.Popup(Pt.X,Pt.Y);
  end;
end;

procedure TBisIngitMapFrame.OpenMap;
begin
  if Assigned(FMap) then begin
    if (FMap.MapAttached>0) then
      FMap.MapName:='';
    try
      FMap.MapName:=FFileName;
    except
      On E: Exception do begin
        FFileName:='';
        LoggerWrite(E.Message,ltError);
      end;
    end;
  end else
    FFileName:='';
end;

procedure TBisIngitMapFrame.OverviewMap;
begin
  if CanOverviewMap then
    FMap.Overview;
end;

procedure TBisIngitMapFrame.PrepareMap;
begin
  inherited;
  if Assigned(FMap) then
    FMap.DoObjectVerb(OLEIVERB_SHOW);
end;

procedure TBisIngitMapFrame.MoveMap;
begin
  if CanMoveMap then begin
    inherited MoveMap;
    FMap.mouseLeftType:=1;
  end;
end;

procedure TBisIngitMapFrame.ZoomInMap;
begin
  if CanZoomInMap then begin
    inherited ZoomInMap;
    FMap.mouseLeftType:=3;
  end;
end;

procedure TBisIngitMapFrame.ZoomOutMap;
begin
  if CanZoomOutMap then begin
    inherited ZoomOutMap;
    FMap.mouseLeftType:=5;
  end;
end;

procedure TBisIngitMapFrame.DistanceMap;
begin
  inherited DistanceMap;

end;

procedure TBisIngitMapFrame.RouteMap;
begin
  if CanRouteMap then begin
    inherited RouteMap;
    FMap.mouseLeftType:=0;
  end;
end;

function TBisIngitMapFrame.TranslateLength(ALength: Double): Double;
begin
  Result:=ALength;
end;

function TBisIngitMapFrame.GetRouteDistance(Lat1, Lon1, Lat2, Lon2: Double): Double;
var
  Points: TBisMapFramePoints;
begin
  Result:=0.0;
  if MapLoaded then begin
    Points:=TBisMapFramePoints.Create;
    try
      Points.AddPoint(Lat1,Lon1);
      Points.AddPoint(Lat2,Lon2);
      Result:=GetRouteDistance(Points);
    finally
      Points.Free;
    end;
  end;
end;

function TBisIngitMapFrame.GetRouteDistance(Points: TBisMapFramePoints): Double;
var
  Route: IGWRoute;
  i: Integer;
  Item: TBisMapFramePoint;
  pname: string;
  ptype: Integer;
begin
  Result:=0.0;
  if MapLoaded and Assigned(Points) then begin
    Route:=FMap.CreateGWRoute('') as IGWRoute;
    if Assigned(Route) then begin
      Route.DeletePoints;

      for i:=0 to Points.Count-1 do begin
        Item:=Points.Items[i];

        if i=0 then
          ptype:=GWX_RoutePointStart
        else if i=(Points.Count-1) then
          ptype:=GWX_RoutePointFinish
        else ptype:=GWX_RoutePointIntermediate;

        pname:=Route.GetPointName(Item.Lat,Item.lon);
        Route.AddPoint(Item.Lat,Item.lon,ptype,pname,i);
      end;

      if Route.CalculateRoute>0 then begin
        Result:=TranslateLength(Route.RouteLength);
      end;

    end;
  end;
end;

procedure TBisIngitMapFrame.ScaleRoute(Points: TBisMapFramePoints);
var
  i: Integer;
  LLat, TLon: Double;
  RLat, BLon: Double;
  Item: TBisMapFramePoint;
  x1, y1: Integer;
  rx, ry: Double;
  lat, lon: Double;
begin
  if MapLoaded and Assigned(Points) then begin
    LLat:=0.0;
    TLon:=0.0;
    RLat:=0.0;
    BLon:=0.0;
    for i:=0 to Points.Count-1 do begin
      Item:=Points.Items[i];
      if i=0 then begin
        LLat:=Item.Lat;
        TLon:=Item.Lon;
        RLat:=Item.Lat;
        BLon:=Item.Lon;
      end else begin

        if (Item.Lat<LLat) then
          LLat:=Item.Lat;

        if (Item.Lon<TLon) then
          TLon:=Item.Lon;

        if (Item.Lat>RLat) then
          RLat:=Item.Lat;

        if (Item.Lon>BLon) then
          BLon:=Item.Lon;

      end;
    end;

    lat:=(RLat+LLat)/2;
    lon:=(BLon+TLon)/2;

    FMap.Overview;
    FMap.Geo2Dev(lat,lon,x1,y1);

    if x1<0 then
      x1:=0;

    if y1<0 then
      y1:=0;

    rx:=1;
    if x1>0 then
      rx:=FMap.ClientWidth/x1;

    ry:=1;
    if y1>0 then
      ry:=FMap.ClientHeight/y1;

    if rx>ry then
      rx:=ry;

    FMap.CurScale:=FMap.CurScale/rx;

    FMap.SetGeoCenter(lat,lon);
  end;
end;

procedure TBisIngitMapFrame.VisibleRoute(Points: TBisMapFramePoints);
var
  i: Integer;
  ptype: Integer;
  Item: TBisMapFramePoint;
  fs: TFormatSettings;
  pname: string;
  m: String;
  Route: IGWRoute;
  tbl: IGWTable;
  p,p2: Integer;
  Lat,Lon: Double;
  Path: IGWTable;
  RoutePoints: TBisMapFramePoints;
begin
  if MapLoaded and Assigned(Points) then begin

    FMap.DeleteDBF('ROUTE POINTS');
    FMap.DeleteDBF('ROUTE LINES');

    FMap.Table2Map('name="ROUTE POINTS";descr="Points of the route";'+
                   'structure="ix integer index, type integer point type, info text point info";',
                   'm @501 "gwp.otl" [type]+20', nil);

    GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, fs);
    fs.DecimalSeparator:='.';

    Route:=FMap.CreateGWRoute('') as IGWRoute;
    if Assigned(Route) then begin
      Route.DeletePoints;

      for i:=0 to Points.Count-1 do begin
        Item:=Points.Items[i];

        if i=0 then
          ptype:=GWX_RoutePointStart
        else if i=(Points.Count-1) then
          ptype:=GWX_RoutePointFinish
        else ptype:=GWX_RoutePointIntermediate;

        m:='P E '+FloatToStr(Item.lon, fs)+' '+FloatToStr(Item.lat, fs)+';';

        pname:=Route.GetPointName(Item.Lat,Item.lon);
        Route.AddPoint(Item.Lat,Item.lon,ptype,pname,i);

        FMap.ModifyTable('insert into [ROUTE POINTS] set [type]='+IntToStr(ptype)+
                         ', [ix]='+IntToStr(i)+
                         ', [info]="'+pname+'", metrics="'+m+'"', 1);

      end;
      Route.CalculateRoute;

      tbl:=Route.GetRoute as IGWTable;
      FMap.Table2Map('name="ROUTE LINES";descr="Route path";metrics=[Metrics];','p @500 Crimson 205', tbl);

      if Assigned(tbl) then begin
        RoutePoints:=TBisMapFramePoints.Create;
        try
          p:=tbl.MoveFirst;
          while p>=0 do begin
            Lat:=VarToExtendedDef(tbl.getValue(1),0.0);
            Lon:=VarToExtendedDef(tbl.getValue(2),0.0);
            RoutePoints.AddPoint(Lat,Lon);
            Path:=tbl.getTable(7) as IGWTable;
            if Assigned(Path) then begin
              p2:=Path.MoveFirst;
              while p2>=0 do begin
                Lat:=VarToExtendedDef(Path.getValue(0),0.0);
                Lon:=VarToExtendedDef(Path.getValue(1),0.0);
                RoutePoints.AddPoint(Lat,Lon);
                p2:=Path.MoveNext;
              end;
            end;
            p:=tbl.MoveNext;
          end;
          ScaleRoute(RoutePoints);
        finally
          RoutePoints.Free;
        end;
      end;
    end;

  end;
end;



end.
