unit BisScriptModules;

interface

uses Classes,
     BisObject, BisModules, BisScriptIface;

type
  TBisScriptModule=class;

  TBisScriptModuleInitProc=procedure (AModule: TBisScriptModule); stdcall;

  TBisScriptModule=class(TBisModule)
  private
    FInitProc: TBisScriptModuleInitProc;
    FScriptClass: TBisScriptIfaceClass;
  protected
    procedure DoInitProc(AModule: TBisModule); override;
  public
    property ScriptClass: TBisScriptIfaceClass read FScriptClass write FScriptClass;
  end;

  TBisScriptModules=class(TBisModules)
  private
    function GetItem(Index: Integer): TBisScriptModule;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    procedure Unload; override;
    function Find(ObjectName: String): TBisScriptModule; reintroduce;

    property Items[Index: Integer]: TBisScriptModule read GetItem; default;
  end;


implementation

uses Windows, SysUtils,
     BisConsts, BisLogger, BisUtils;

{ TBisScriptModule }

procedure TBisScriptModule.DoInitProc(AModule: TBisModule);
begin
  @FInitProc:=GetProcAddress(Module,PChar(SInitScriptModule));
  if Assigned(@FInitProc) then begin
    try
      FInitProc(Self);
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

{ TBisScriptModules }

function TBisScriptModules.Find(ObjectName: String): TBisScriptModule;
begin
  Result:=TBisScriptModule(inherited Find(ObjectName));
end;

function TBisScriptModules.GetItem(Index: Integer): TBisScriptModule;
begin
  Result:=TBisScriptModule(inherited Items[Index]);
end;

function TBisScriptModules.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisScriptModule;
end;

procedure TBisScriptModules.Unload;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Items[i].ScriptClass:=nil;
  end;
  inherited Unload;
end;

end.
