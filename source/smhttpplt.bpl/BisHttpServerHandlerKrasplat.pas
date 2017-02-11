unit BisHttpServerHandlerKrasplat;

interface

uses Classes,
     HTTPApp,
     BisHttpServerHandlerModules, BisHttpServerHandlers,
     BisHttpServerHandlerKrasplatWm;

type

  TBisHttpServerHandlerKrasplat=class(TBisHttpServerHandler)
  private
    FWebModule: TBisHttpServerHandlerKrasplatWebModule;
    FClientKey: String;
    FServerKey: String;
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

uses SysUtils, Variants,
     BisCore, BisUtils, BisConsts, BisDataParams,
     BisHttpServerHandlerKrasplatConsts;

procedure InitHttpServerHandlerModule(AModule: TBisHttpServerHandlerModule); stdcall;
begin
  AModule.HandlerClass:=TBisHttpServerHandlerKrasplat;
end;

{ TBisHttpServerHandlerKrasplat }

constructor TBisHttpServerHandlerKrasplat.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWebModule:=TBisHttpServerHandlerKrasplatWebModule.Create(Self);
  FWebModule.Handler:=Self;
end;

destructor TBisHttpServerHandlerKrasplat.Destroy;
begin
  FWebModule.Free;
  inherited Destroy;
end;

procedure TBisHttpServerHandlerKrasplat.Init;
begin
  inherited Init;

  with Params do begin
    FClientKey:=AsString(SParamClientKey);
    FServerKey:=AsString(SParamServerKey);
  end;

end;

function TBisHttpServerHandlerKrasplat.HandleRequest(Request: TWebRequest; Response: TWebResponse): Boolean;
begin
  if FWebModule is TBisHttpServerHandlerKrasplatWebModule then begin
     TBisHttpServerHandlerKrasplatWebModule(FWebModule).ClientKey:=FClientKey;
     TBisHttpServerHandlerKrasplatWebModule(FWebModule).ServerKey:=FServerKey;
  end;
  Result:=IWebRequestHandler(FWebModule).HandleRequest(Request,Response);
end;

procedure TBisHttpServerHandlerKrasplat.CopyFrom(Source: TBisHttpServerHandler);
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisHttpServerHandlerKrasplat) then begin
    FClientKey:=TBisHttpServerHandlerKrasplat(Source).FClientKey;
    FServerKey:=TBisHttpServerHandlerKrasplat(Source).FServerKey;
  end;
end;

end.
