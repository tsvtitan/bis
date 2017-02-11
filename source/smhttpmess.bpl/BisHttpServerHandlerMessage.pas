unit BisHttpServerHandlerMessage;

interface

uses Classes,
     HTTPApp,
     BisHttpServerHandlerModules, BisHttpServerHandlers,
     BisHttpServerHandlerMessageWm;

type

  TBisHttpServerHandlerMessage=class(TBisHttpServerHandler)
  private
    FWebModule: TBisHttpServerHandlerMessageWebModule;
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
     BisUtils, BisConsts, BisHttpServerHandlerMessageConsts;

procedure InitHttpServerHandlerModule(AModule: TBisHttpServerHandlerModule); stdcall;
begin
  AModule.HandlerClass:=TBisHttpServerHandlerMessage;
end;

{ TBisHttpServerHandlerMessage }

constructor TBisHttpServerHandlerMessage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWebModule:=TBisHttpServerHandlerMessageWebModule.Create(Self);
  FWebModule.Handler:=Self;
end;

destructor TBisHttpServerHandlerMessage.Destroy;
begin
  FWebModule.Free;
  inherited Destroy;
end;

procedure TBisHttpServerHandlerMessage.Init;
begin
  inherited Init;
end;

function TBisHttpServerHandlerMessage.HandleRequest(Request: TWebRequest; Response: TWebResponse): Boolean;
begin
  if FWebModule is TBisHttpServerHandlerMessageWebModule then begin
    //
  end;
  Result:=IWebRequestHandler(FWebModule).HandleRequest(Request,Response);
end;

procedure TBisHttpServerHandlerMessage.CopyFrom(Source: TBisHttpServerHandler);
begin
  inherited CopyFrom(Source);
  if Assigned(Source) then begin
    //
  end;
end;

end.
