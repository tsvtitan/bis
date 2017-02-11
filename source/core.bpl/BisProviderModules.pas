unit BisProviderModules;

interface

uses Classes,
     BisObject, BisModules, BisProvider, BisProviders, BisLocks;

type
  TBisProviderModule=class;

  TBisProviderModuleInitProc=procedure (AModule: TBisProviderModule); stdcall;

  TBisProviderModule=class(TBisModule)
  private
    FInitProc: TBisProviderModuleInitProc;
    FProviders: TBisProviders;
  protected
    procedure DoInitProc(AModule: TBisModule); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Unload; override;

    property Providers: TBisProviders read FProviders;
  end;

  TBisProviderModules=class(TBisModules)
  private
    FLock: TBisLock;
    function GetItem(Index: Integer): TBisProviderModule;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Unload; override;
    function LockFindProvider(ProviderName: String): TBisProvider;


    property Items[Index: Integer]: TBisProviderModule read GetItem; default;
  end;

implementation

uses Windows, SysUtils,
     BisConsts, BisLogger, BisUtils;

{ TBisProviderModule }

constructor TBisProviderModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProviders:=TBisProviders.Create;
end;

destructor TBisProviderModule.Destroy;
begin
  FProviders.Free;
  inherited Destroy;
end;

procedure TBisProviderModule.DoInitProc(AModule: TBisModule);
begin
  @FInitProc:=GetProcAddress(Module,PChar(SInitProviderModule));
  if Assigned(@FInitProc) then begin
    try
      FInitProc(Self);
//      FProviders.Init;
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

procedure TBisProviderModule.Init;
begin
  inherited Init;
end;

procedure TBisProviderModule.Unload;
begin
  FProviders.Clear;
  inherited Unload;
end;

{ TBisProviderModules }

constructor TBisProviderModules.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLock:=TBisLock.Create;
end;

function TBisProviderModules.GetItem(Index: Integer): TBisProviderModule;
begin
  Result:=TBisProviderModule(inherited Items[Index]);
end;

function TBisProviderModules.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisProviderModule;
end;

procedure TBisProviderModules.Unload;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Items[i].Providers.Clear;
  end;
  inherited Unload;
end;

destructor TBisProviderModules.Destroy;
begin
  FLock.Free;
  inherited Destroy;
end;

function TBisProviderModules.LockFindProvider(ProviderName: String): TBisProvider;
var
  i: Integer;
  Item: TBisProviderModule;
  P: TBisProvider;
begin
  Result:=nil;
  FLock.Lock;
  try
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      P:=Item.Providers.Find(ProviderName);
      if Assigned(P) then begin
        Result:=P;
        break;
      end;
    end;
  finally
    FLock.UnLock;
  end;
end;


end.
