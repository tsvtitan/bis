unit BisHttpServerHandlerEvent;

interface

uses Classes,
     HTTPApp,
     BisHttpServerHandlerModules, BisHttpServerHandlers,
     BisHttpServerHandlerEventWm;

type

  TBisHttpServerHandlerEvent=class(TBisHttpServerHandler)
  private
    FWebModule: TBisHttpServerHandlerEventWebModule;
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
     BisCore, BisUtils, BisConsts, BisHttpServerHandlerEventConsts;

procedure InitHttpServerHandlerModule(AModule: TBisHttpServerHandlerModule); stdcall;
begin
  AModule.HandlerClass:=TBisHttpServerHandlerEvent;
end;

{ TBisHttpServerHandlerEvent }

constructor TBisHttpServerHandlerEvent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWebModule:=TBisHttpServerHandlerEventWebModule.Create(Self);
  FWebModule.Handler:=Self;
end;

destructor TBisHttpServerHandlerEvent.Destroy;
begin
  FWebModule.Free;
  inherited Destroy;
end;

procedure TBisHttpServerHandlerEvent.Init;
begin
  inherited Init;
end;

function TBisHttpServerHandlerEvent.HandleRequest(Request: TWebRequest; Response: TWebResponse): Boolean;
begin
  if FWebModule is TBisHttpServerHandlerEventWebModule then begin
  end;
  Result:=IWebRequestHandler(FWebModule).HandleRequest(Request,Response);
end;

procedure TBisHttpServerHandlerEvent.CopyFrom(Source: TBisHttpServerHandler);
begin
  inherited CopyFrom(Source);
  if Assigned(Source) then begin
  end;
end;

end.
