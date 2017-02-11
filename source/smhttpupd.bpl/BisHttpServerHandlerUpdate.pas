unit BisHttpServerHandlerUpdate;

interface

uses Classes,
     HTTPApp,
     BisHttpServerHandlerModules, BisHttpServerHandlers,
     BisHttpServerHandlerUpdateWm;

type

  TBisHttpServerHandlerUpdate=class(TBisHttpServerHandler)
  private
    FWebModule: TBisHttpServerHandlerUpdateWebModule;
    FDirectory: String;
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
     BisUtils, BisConsts, BisDataParams,
     BisHttpServerHandlerUpdateConsts;

procedure InitHttpServerHandlerModule(AModule: TBisHttpServerHandlerModule); stdcall;
begin
  AModule.HandlerClass:=TBisHttpServerHandlerUpdate;
end;

{ TBisHttpServerHandlerUpdate }

constructor TBisHttpServerHandlerUpdate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWebModule:=TBisHttpServerHandlerUpdateWebModule.Create(Self);
  FWebModule.Handler:=Self;
end;

destructor TBisHttpServerHandlerUpdate.Destroy;
begin
  FWebModule.Free;
  inherited Destroy;
end;

procedure TBisHttpServerHandlerUpdate.Init;
begin
  inherited Init;

  FDirectory:=ExpandFileNameEx(Params.AsString(SParamDirectory));

end;

function TBisHttpServerHandlerUpdate.HandleRequest(Request: TWebRequest; Response: TWebResponse): Boolean;
begin
  if FWebModule is TBisHttpServerHandlerUpdateWebModule then begin
    TBisHttpServerHandlerUpdateWebModule(FWebModule).Directory:=FDirectory;
  end;
  Result:=IWebRequestHandler(FWebModule).HandleRequest(Request,Response);
end;

procedure TBisHttpServerHandlerUpdate.CopyFrom(Source: TBisHttpServerHandler);
begin
  inherited CopyFrom(Source);
  if Assigned(Source) then begin
    FDirectory:=TBisHttpServerHandlerUpdate(Source).FDirectory;
  end;
end;

end.
