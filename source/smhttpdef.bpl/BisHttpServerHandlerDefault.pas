unit BisHttpServerHandlerDefault;

interface

uses Classes,
     HTTPApp,
     BisDataSet,
     BisHttpServerHandlerModules, BisHttpServerHandlers,
     BisHttpServerHandlerDefaultWm;

type

  TBisHttpServerHandlerDefault=class(TBisHttpServerHandler)
  private
    FWebModule: TBisHttpServerHandlerDefaultWebModule;
    FConnections: TBisDataSet;
    FConnectTimeOut: Integer;
    FMaxSessionCount: Integer;
    FRandomStringSize: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function HandleRequest(Request: TWebRequest; Response: TWebResponse): Boolean; override;
    procedure CopyFrom(Source: TBisHttpServerHandler); override;
  end;

procedure InitHttpServerHandlerModule(AModule: TBisHttpServerHandlerModule); stdcall;

exports
  InitHttpServerHandlerModule;

implementation

uses SysUtils,
     BisConsts, BisDataParams,
     BisHttpServerHandlerDefaultConsts;

procedure InitHttpServerHandlerModule(AModule: TBisHttpServerHandlerModule); stdcall;
begin
  AModule.HandlerClass:=TBisHttpServerHandlerDefault;
end;

{ TBisHttpServerHandlerDefault }

constructor TBisHttpServerHandlerDefault.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWebModule:=TBisHttpServerHandlerDefaultWebModule.Create(Self);
  FWebModule.Handler:=Self;
  FConnections:=TBisDataSet.Create(nil);
  FConnectTimeOut:=100;
  FMaxSessionCount:=MaxInt;
  FRandomStringSize:=3*1024;
end;

destructor TBisHttpServerHandlerDefault.Destroy;
begin
  FConnections.Free;
  FWebModule.Free;
  inherited Destroy;
end;

procedure TBisHttpServerHandlerDefault.Init;
begin
  inherited Init;
  with Params do begin
    SaveToDataSet(SParamConnections,FConnections);
    FConnectTimeOut:=AsInteger(SParamConnectTimeOut,FConnectTimeOut);
    FMaxSessionCount:=AsInteger(SParamMaxSessionCount,FMaxSessionCount);
    FRandomStringSize:=AsInteger(SParamRandomStringSize,FRandomStringSize);
  end;
end;

function TBisHttpServerHandlerDefault.HandleRequest(Request: TWebRequest; Response: TWebResponse): Boolean;
begin
  if FWebModule is TBisHttpServerHandlerDefaultWebModule then begin
    with TBisHttpServerHandlerDefaultWebModule(FWebModule) do begin
      Connections.CopyFromDataSet(FConnections);
      ConnectTimeOut:=FConnectTimeOut;
      MaxSessionCount:=FMaxSessionCount;
      RandomStringSize:=FRandomStringSize;
    end;
  end;
  Result:=IWebRequestHandler(FWebModule).HandleRequest(Request,Response);
end;

procedure TBisHttpServerHandlerDefault.CopyFrom(Source: TBisHttpServerHandler);
var
  Handler: TBisHttpServerHandlerDefault;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisHttpServerHandlerDefault) then begin
    Handler:=TBisHttpServerHandlerDefault(Source);
    FConnections.Close;
    if Handler.FConnections.Active then begin
      FConnections.CreateTable(Handler.FConnections);
      FConnections.CopyRecords(Handler.FConnections);
    end;
    FConnectTimeOut:=Handler.FConnectTimeOut;
    FMaxSessionCount:=Handler.FMaxSessionCount;
    FRandomStringSize:=Handler.FRandomStringSize;
  end;
end;

end.
