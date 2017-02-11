unit BisObjectModules;

interface

uses Classes,
     BisObject, BisModules,
     BisScriptUnits;

type
  TBisObjectModule=class;

  TBisObjectModuleInitProc=procedure (AModule: TBisObjectModule); stdcall;

  TBisObjectModule=class(TBisModule)
  private
    FInitProc: TBisObjectModuleInitProc;
    FScriptUnits: TBisScriptUnits;
  protected
    procedure DoInitProc(AModule: TBisModule); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Unload; override;

    property ScriptUnits: TBisScriptUnits read FScriptUnits;
  end;

  TBisObjectModules=class(TBisModules)
  private
    function GetItem(Index: Integer): TBisObjectModule;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    procedure Unload; override;

    property Items[Index: Integer]: TBisObjectModule read GetItem;  default;
  end;


implementation

uses Windows, SysUtils, 
     BisConsts, BisLogger, BisUtils;

{ TBisObjectModule }

constructor TBisObjectModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScriptUnits:=TBisScriptUnits.Create(Self);
end;

destructor TBisObjectModule.Destroy;
begin
  FScriptUnits.Free;
  inherited Destroy;
end;

procedure TBisObjectModule.DoInitProc(AModule: TBisModule);
begin
  @FInitProc:=GetProcAddress(Module,PChar(SInitObjectModule));
  if Assigned(@FInitProc) then begin
    try
      FInitProc(Self);
      FScriptUnits.Init;
      LoggerWrite(FormatEx(SInitSuccess,[FileName]));
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(SInitFailed,[FileName,E.Message]),ltError);
      end;
    end;
  end else begin
    LoggerWrite(FormatEx(SInitProcNotFound,[FileName]),ltError);
  end;
end;

procedure TBisObjectModule.Unload;
begin
  FScriptUnits.Clear;
  inherited Unload;
end;

{ TBisObjectModules }

function TBisObjectModules.GetItem(Index: Integer): TBisObjectModule;
begin
  Result:=TBisObjectModule(inherited Items[Index]);
end;

function TBisObjectModules.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisObjectModule;
end;

procedure TBisObjectModules.Unload;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Items[i].ScriptUnits.Clear;
  end;
  inherited Unload;
end;

end.
