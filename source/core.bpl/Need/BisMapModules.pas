unit BisMapModules;

interface

uses Classes,
     BisObject, BisModules, BisMapFm;

type
  TBisMapModule=class;

  TBisMapModuleInitProc=procedure (AModule: TBisMapModule); stdcall;

  TBisMapModule=class(TBisModule)
  private
    FInitProc: TBisMapModuleInitProc;
    FMapClass: TBisMapFormIfaceClass;
  protected
    procedure DoInitProc(AModule: TBisModule); override;
  public
    property MapClass: TBisMapFormIfaceClass read FMapClass write FMapClass;
  end;

  TBisMapModules=class(TBisModules)
  private
    function GetItem(Index: Integer): TBisMapModule;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    procedure Unload; override;

    property Items[Index: Integer]: TBisMapModule read GetItem; default;
  end;


implementation

uses Windows, SysUtils, 
     BisConsts, BisLogger, BisUtils;

{ TBisMapModule }

procedure TBisMapModule.DoInitProc(AModule: TBisModule);
begin
  @FInitProc:=GetProcAddress(Module,PChar(SInitMapModule));
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

{ TBisMapModules }

function TBisMapModules.GetItem(Index: Integer): TBisMapModule;
begin
  Result:=TBisMapModule(inherited Items[Index]);
end;

function TBisMapModules.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisMapModule;
end;

procedure TBisMapModules.Unload;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Items[i].MapClass:=nil;
  end;
  inherited Unload;
end;

end.
