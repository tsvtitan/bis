unit BisIngitMapGetRouteDistancePrv;

interface

uses Windows, Classes,
     BisProvider, BisDataSet, BisIngitMapFrm;

type

  TBisIngitMapGetRouteDistanceProvider=class(TBisProvider)
  private
    FMapFrame: TBisIngitMapFrame;
    FLock: TRTLCriticalSection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Handle(DataSet: TBisDataSet); override;
  end;

implementation

uses SysUtils,
     BisCore, BisUtils;

{ TBisIngitMapGetRouteDistanceProvider }

constructor TBisIngitMapGetRouteDistanceProvider.Create(AOwner: TComponent);
var
  Buffer: String;
begin
  inherited Create(AOwner);
  InitializeCriticalSection(FLock);
  ProviderName:='GET_ROUTE_DISTANCE';

  Buffer:='';
  Core.LocalBase.ReadParam('MapFileName',Buffer);

  FMapFrame:=TBisIngitMapFrame.Create(Self);
  FMapFrame.LoadFromFile(Buffer);
  FMapFrame.PrepareMap;
end;

destructor TBisIngitMapGetRouteDistanceProvider.Destroy;
begin
  FMapFrame.Free;
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

procedure TBisIngitMapGetRouteDistanceProvider.Handle(DataSet: TBisDataSet);
var
  Lat1, Lon1: Double;
  Lat2, Lon2: Double;
  T: TDateTime;
begin
  EnterCriticalSection(FLock);
  T:=Time;
  try
    if Assigned(DataSet) and FMapFrame.MapLoaded then begin
      with DataSet.Params do begin
        Lat1:=ParamByName('LAT1').AsExtended;
        Lon1:=ParamByName('LON1').AsExtended;
        Lat2:=ParamByName('LAT2').AsExtended;
        Lon2:=ParamByName('LON2').AsExtended;
      end;
      DataSet.Params.ParamByName('DISTANCE').Value:=FMapFrame.GetRouteDistance(Lat1,Lon1,Lat2,Lon2);
    end;
  finally
    LoggerWrite(FormatEx('%s = %s',[DataSet.ProviderName,FormatDateTime('hh:nn.sss',Time-T)]));
    LeaveCriticalSection(FLock);
  end;
end;

end.
