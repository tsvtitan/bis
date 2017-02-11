unit BisHttpServerHandlerIngitMapWm;

interface

uses
  SysUtils, Classes, HTTPApp, DB, Contnrs, SyncObjs,
  BisHttpServerIngitMapFrm, BisHttpServerHandlers;

type

  TBisHttpServerHandlerIngitMapWebModule = class(TWebModule)
    procedure BisHttpServerHandlerIngitMapWebModuleDefaultAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    FHandler: TBisHttpServerHandler;
    FSCoordinates: String;
    FSDistance: String;

    function Execute(Request: TWebRequest; Response: TWebResponse): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    property Handler: TBisHttpServerHandler read FHandler write FHandler;
  published
    property SCoordinates: String read FSCoordinates write FSCoordinates;
    property SDistance: String read FSDistance write FSDistance;
  end;

var
  BisHttpServerHandlerIngitMapWebModule: TBisHttpServerHandlerIngitMapWebModule;
  FMapFrame: TBisHttpServerIngitMapFrame;

implementation

{$R *.dfm}

uses Windows, Variants, StrUtils,
     BisConsts, BisUtils, BisProvider, BisCore, BisLogger, BisFilterGroups, BisCoreUtils,
     BisHttpServerHandlerIngitMapConsts;

var
  FLock: TCriticalSection;

{ TBisHttpServerHandlerMessageWebModule }

constructor TBisHttpServerHandlerIngitMapWebModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSCoordinates:='������������ ������1=%s �������1=%s ������2=%s �������2=%s';
  FSDistance:='����������=%s';
end;

function TBisHttpServerHandlerIngitMapWebModule.Execute(Request: TWebRequest; Response: TWebResponse): Boolean;

  function ReadCoordinates(var Lat1,Lon1,Lat2,Lon2: Double): Boolean;

    function PrepearFloat(S: String; var F: Double): Boolean;
    begin
      S:=ReplaceText(S,'.',DecimalSeparator);
      S:=ReplaceText(S,',',DecimalSeparator);
      Result:=TryStrToFloat(S,F);
    end;

  begin
    Result:=false;
    if Trim(Request.Query)<>'' then begin
      if not PrepearFloat(Request.QueryFields.Values['lat1'],Lat1) then  exit;
      if not PrepearFloat(Request.QueryFields.Values['lon1'],Lon1) then  exit;
      if not PrepearFloat(Request.QueryFields.Values['lat2'],Lat2) then  exit;
      if not PrepearFloat(Request.QueryFields.Values['lon2'],Lon2) then  exit;
      Result:=true;
    end;
  end;

  function CalculateDistance(Lat1,Lon1,Lat2,Lon2: Double): Integer;
  begin
    FLock.Enter;
    try
      Result:=0;
      if FMapFrame.MapLoaded then
        Result:=Round(FMapFrame.GetRouteDistance(Lat1,Lon1,Lat2,Lon2));
    finally
      FLock.Leave;
    end;
  end;

  procedure WriteDistance(Distance: Integer);
  begin
    Response.Content:=IntToStr(Distance);
  end;

  procedure LoggerWrite(Message: String; LogType: TBisLoggerType=ltInformation);
  begin
    BisCoreUtils.ClassLoggerWrite(ClassName,Message,LogType);
  end;
  
var
  RequestStream: TMemoryStream;
  Flag: Boolean;
  Lat1, Lon1: Double;
  Lat2, Lon2: Double;
  Distance: Integer;
begin
  Result:=false;
  if Assigned(FHandler) then begin
    try
      RequestStream:=TMemoryStream.Create;
      try
        RequestStream.WriteBuffer(Pointer(Request.Content)^,Length(Request.Content));
        RequestStream.Position:=0;

        Lat1:=0.0;
        Lon1:=0.0;
        Lat2:=0.0;
        Lon2:=0.0;

        Flag:=ReadCoordinates(Lat1,Lon1,Lat2,Lon2);

        LoggerWrite(FormatEx(FSCoordinates,[FloatToStr(Lat1),FloatToStr(Lon1),FloatToStr(Lat2),FloatToStr(Lon2)]));

        if Flag then begin
          Distance:=CalculateDistance(Lat1,Lon1,Lat2,Lon2);

          LoggerWrite(FormatEx(FSDistance,[IntToStr(Distance)]));

          if Assigned(Response.ContentStream) then begin
            WriteDistance(Distance);
            Result:=true;
          end;
        end;

      finally
        RequestStream.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(E.Message,ltError);
      end;
    end;
  end;
end;

procedure TBisHttpServerHandlerIngitMapWebModule.BisHttpServerHandlerIngitMapWebModuleDefaultAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled:=Execute(Request,Response);
end;

initialization
  FLock:=TCriticalSection.Create;
  FMapFrame:=TBisHttpServerIngitMapFrame.Create(nil);

finalization
  FMapFrame.Free;
  FLock.Free;
  
end.
