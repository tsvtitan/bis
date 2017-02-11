unit BisHttpServerHandlerFiles;

interface

uses Classes,
     HTTPApp,
     BisHttpServerHandlerModules, BisHttpServerHandlers,
     BisHttpServerHandlerFilesWm;

type

  TBisHttpServerHandlerFiles=class(TBisHttpServerHandler)
  private
    FWebModule: TBisHttpServerHandlerFilesWebModule;
    FFiles: TStringList;
    FTypes: TStringList;
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
     BisHttpServerHandlerFilesConsts;

procedure InitHttpServerHandlerModule(AModule: TBisHttpServerHandlerModule); stdcall;
begin
  AModule.HandlerClass:=TBisHttpServerHandlerFiles;
end;

{ TBisHttpServerHandlerFiles }

constructor TBisHttpServerHandlerFiles.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWebModule:=TBisHttpServerHandlerFilesWebModule.Create(Self);
  FWebModule.Handler:=Self;
  FFiles:=TStringList.Create;
  FTypes:=TStringList.Create;
end;

destructor TBisHttpServerHandlerFiles.Destroy;
begin
  FTypes.Free;
  FFiles.Free;
  FWebModule.Free;
  inherited Destroy;
end;

procedure TBisHttpServerHandlerFiles.Init;
begin
  inherited Init;

  with Params do begin
    FFiles.Text:=Trim(AsString(SParamFiles));
    FTypes.Text:=Trim(AsString(SParamTypes));
  end;

end;

function TBisHttpServerHandlerFiles.HandleRequest(Request: TWebRequest; Response: TWebResponse): Boolean;
begin
  if FWebModule is TBisHttpServerHandlerFilesWebModule then begin
    with TBisHttpServerHandlerFilesWebModule(FWebModule) do begin
      Files.Assign(FFiles);
      Types.Assign(FTypes);
    end;
  end;
  Result:=IWebRequestHandler(FWebModule).HandleRequest(Request,Response);
end;

procedure TBisHttpServerHandlerFiles.CopyFrom(Source: TBisHttpServerHandler);
begin
  inherited CopyFrom(Source);
  if Assigned(Source) then begin
    FFiles.Assign(TBisHttpServerHandlerFiles(Source).FFiles);
    FTypes.Assign(TBisHttpServerHandlerFiles(Source).FTypes);
  end;
end;

end.
