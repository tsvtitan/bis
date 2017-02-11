unit BisHttpServerIngitMapFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Menus, ActnPopup, ActnList, ComCtrls, Contnrs,
  ToolWin, StdCtrls, ExtCtrls, ActiveX,
  GWXLib_TLB, BisFrm;

type
 TBisHttpServerIngitMapFramePoint=class(TObject)
  public
    var Lat: Double;
    var Lon: Double;

    constructor Create; 
  end;

  TBisHttpServerIngitMapFramePoints=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisHttpServerIngitMapFramePoint;
  public
    function AddPoint(Lat, Lon: Double): TBisHttpServerIngitMapFramePoint;

    property Items[Index: Integer]: TBisHttpServerIngitMapFramePoint read GetItem;
  end;

  TBisHttpServerIngitMapFrame = class(TBisFrame)
  private
    FMap: TGWControl;
    FFileName: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function MapLoaded: Boolean;
    procedure OpenMap;
    procedure PrepareMap;
    procedure LoadFromFile(const FileName: String);

    function GetRouteDistance(Lat1, Lon1, Lat2, Lon2: Double): Double; overload;
    function GetRouteDistance(Points: TBisHttpServerIngitMapFramePoints): Double; overload;
 
    property Map: TGWControl read FMap;
  end;

implementation

uses BisLogger, BisUtils;

{$R *.dfm}

{ TBisHttpServerIngitMapFramePoint }

constructor TBisHttpServerIngitMapFramePoint.Create;
begin
  inherited Create;
  Lat:=0.0;
  Lon:=0.0;
end;

{ TBisHttpServerIngitMapFramePoints }

function TBisHttpServerIngitMapFramePoints.AddPoint(Lat, Lon: Double): TBisHttpServerIngitMapFramePoint;
begin
  Result:=TBisHttpServerIngitMapFramePoint.Create;
  Result.Lat:=Lat;
  Result.Lon:=Lon;
  inherited Add(Result);
end;

function TBisHttpServerIngitMapFramePoints.GetItem(Index: Integer): TBisHttpServerIngitMapFramePoint;
begin
  Result:=TBisHttpServerIngitMapFramePoint(inherited Items[Index]);
end;

{ TBisHttpServerIngitMapFrame }

constructor TBisHttpServerIngitMapFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  try
    FMap:=TGWControl.Create(Self);
    FMap.Parent:=Self;
    FMap.Align:=alClient;
    FMap.mouseLeftType:=1;
    FMap.mouseRightType:=0;
  except
    On E: Exception do
      LoggerWrite(E.Message,ltError);
  end;
end;

destructor TBisHttpServerIngitMapFrame.Destroy;
begin
  if Assigned(FMap) then
    FMap.MapName:='';
  FMap.Free;
  inherited Destroy;
end;

procedure TBisHttpServerIngitMapFrame.OpenMap;
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

procedure TBisHttpServerIngitMapFrame.LoadFromFile(const FileName: String);
begin
  if FileExists(FileName) then begin
    FFileName:=FileName;
    OpenMap;
  end;
end;

procedure TBisHttpServerIngitMapFrame.PrepareMap;
begin
  inherited;
  if Assigned(FMap) then
    FMap.DoObjectVerb(OLEIVERB_SHOW);
end;

function TBisHttpServerIngitMapFrame.MapLoaded: Boolean;
begin
  Result:=Assigned(FMap) and (FMap.MapAttached>0);
end;

function TBisHttpServerIngitMapFrame.GetRouteDistance(Lat1, Lon1, Lat2, Lon2: Double): Double;
var
  Points: TBisHttpServerIngitMapFramePoints;
begin
  Result:=0.0;
  if MapLoaded then begin
    Points:=TBisHttpServerIngitMapFramePoints.Create;
    try
      Points.AddPoint(Lat1,Lon1);
      Points.AddPoint(Lat2,Lon2);
      Result:=GetRouteDistance(Points);
    finally
      Points.Free;
    end;
  end;
end;

function TBisHttpServerIngitMapFrame.GetRouteDistance(Points: TBisHttpServerIngitMapFramePoints): Double;
var
  Route: IGWRoute;
  i: Integer;
  Item: TBisHttpServerIngitMapFramePoint;
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

      if Route.CalculateRoute>0 then
        Result:=Route.RouteLength;

    end;
  end;
end;


end.
