unit BisHttpServerHandlerMobile;

interface

uses Classes,
     HTTPApp,
     BisHttpServerHandlerModules, BisHttpServerHandlers,
     BisHttpServerHandlerMobileWm;

type

  TBisHttpServerHandlerMobile=class(TBisHttpServerHandler)
  private
    FWebModule: TBisHttpServerHandlerMobileWebModule;
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
     BisHttpServerHandlerMobileConsts;

procedure InitHttpServerHandlerModule(AModule: TBisHttpServerHandlerModule); stdcall;
begin
  AModule.HandlerClass:=TBisHttpServerHandlerMobile;
end;

{ TBisHttpServerHandlerMobile }

constructor TBisHttpServerHandlerMobile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWebModule:=TBisHttpServerHandlerMobileWebModule.Create(Self);
  FWebModule.Handler:=Self;
  
end;

destructor TBisHttpServerHandlerMobile.Destroy;
begin
  FWebModule.Free;
  inherited Destroy;
end;

procedure TBisHttpServerHandlerMobile.Init;
begin
  inherited Init;
end;

function TBisHttpServerHandlerMobile.HandleRequest(Request: TWebRequest; Response: TWebResponse): Boolean;
begin
  if FWebModule is TBisHttpServerHandlerMobileWebModule then begin
  end;
  Result:=IWebRequestHandler(FWebModule).HandleRequest(Request,Response);
end;

procedure TBisHttpServerHandlerMobile.CopyFrom(Source: TBisHttpServerHandler);
begin
  inherited CopyFrom(Source);
  if Assigned(Source) then begin
  end;
end;

end.