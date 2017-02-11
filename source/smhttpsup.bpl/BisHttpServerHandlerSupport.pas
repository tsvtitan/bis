unit BisHttpServerHandlerSupport;

interface

uses Classes,
     HTTPApp,
     BisDataSet,
     BisHttpServerHandlerModules, BisHttpServerHandlers,
     BisHttpServerHandlerSupportWm;

type

  TBisHttpServerHandlerSupport=class(TBisHttpServerHandler)
  private
    FWebModule: TBisHttpServerHandlerSupportWebModule;
    FProcesses: TBisDataSet;
    FShutReasons: TStringList;
    FPassword: String;
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
     BisCore, BisUtils, BisConsts, BisDataParams,
     BisHttpServerHandlerSupportConsts;

procedure InitHttpServerHandlerModule(AModule: TBisHttpServerHandlerModule); stdcall;
begin
  AModule.HandlerClass:=TBisHttpServerHandlerSupport;
end;

{ TBisHttpServerHandlerSupport }

constructor TBisHttpServerHandlerSupport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWebModule:=TBisHttpServerHandlerSupportWebModule.Create(Self);
  FWebModule.Handler:=Self;

  FProcesses:=TBisDataSet.Create(nil);
  FShutReasons:=TStringList.Create;
end;

destructor TBisHttpServerHandlerSupport.Destroy;
begin
  FShutReasons.Free;
  FProcesses.Free;
  FWebModule.Free;
  inherited Destroy;
end;

procedure TBisHttpServerHandlerSupport.Init;
begin
  inherited Init;
  Params.SaveToDataSet(SParamProcesses,FProcesses);
  FShutReasons.Text:=Params.AsString(SParamShutReasons);
  FPassword:=Params.AsString(SParamPassword);
end;

function TBisHttpServerHandlerSupport.HandleRequest(Request: TWebRequest; Response: TWebResponse): Boolean;
begin
  if FWebModule is TBisHttpServerHandlerSupportWebModule then begin
    with TBisHttpServerHandlerSupportWebModule(FWebModule) do begin
      Processes.CopyFromDataSet(FProcesses);
      ShutReasons.Assign(FShutReasons);
      Password:=FPassword;
    end;
  end;
  Result:=IWebRequestHandler(FWebModule).HandleRequest(Request,Response);
end;

procedure TBisHttpServerHandlerSupport.CopyFrom(Source: TBisHttpServerHandler);
var
  Support: TBisHttpServerHandlerSupport;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisHttpServerHandlerSupport) then begin
    Support:=TBisHttpServerHandlerSupport(Source);
    if Support.FProcesses.Active then begin
      FProcesses.CreateTable(Support.FProcesses);
      FProcesses.CopyRecords(Support.FProcesses);
    end;
    FShutReasons.Assign(Support.FShutReasons);
    FPassword:=Support.FPassword;
  end;
end;

end.
