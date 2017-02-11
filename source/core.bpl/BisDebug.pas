unit BisDebug;

interface

uses Classes, SysUtils, Contnrs,
     JclDebug,
     BisObject, BisLogger, BisConfig;

type

  TBisDebug=class(TBisObject)
  private
    FLogger: TBisLogger;
    FConfig: TBisConfig;
    FEnabled: Boolean;
    FStacked: Boolean;
    FIngnoreExceptions: TClassList;
    procedure ExceptNotifier(ExceptObj: TObject; ExceptAddr: Pointer; OSException: Boolean);
    procedure WriteStack;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure InitByParent(AObject: TBisObject); override;

    property Logger: TBisLogger read FLogger write FLogger;
    property Config: TBisConfig read FConfig write FConfig;
    property Enabled: Boolean read FEnabled write FEnabled;
  end;


implementation

uses
     JclHookExcept,
     BisLoggerIntf, BisCoreConsts;

{ TBisDebug }

constructor TBisDebug.Create;
begin
  inherited Create;
  FIngnoreExceptions:=TClassList.Create;
  FIngnoreExceptions.Add(EAbort);
  FIngnoreExceptions.Add(EExternalException);

  JclStackTrackingOptions:=[stStack, stExceptFrame, stRawMode, stAllModules, stStaticModuleList,
                            stDelayedTrace, stTraceAllExceptions{, stMainThreadOnly}];
  JclStartExceptionTracking;
  JclAddExceptNotifier(ExceptNotifier,npNormal);
end;

destructor TBisDebug.Destroy;
begin
  JclRemoveExceptNotifier(ExceptNotifier);
  JclStopExceptionTracking;
  FIngnoreExceptions.Free;
  inherited Destroy;
end;

procedure TBisDebug.InitByParent(AObject: TBisObject);
begin
  inherited InitByParent(AObject);
  if Assigned(FConfig) then begin
    FEnabled:=FConfig.Read(Self.ObjectName,SEnabled,FEnabled);
    FStacked:=FConfig.Read(Self.ObjectName,SStacked,FStacked);
  end;
end;

procedure TBisDebug.ExceptNotifier(ExceptObj: TObject; ExceptAddr: Pointer; OSException: Boolean);
var
  S: String;
begin
  if FEnabled and Assigned(FLogger) then begin
    if FIngnoreExceptions.IndexOf(ExceptObj.ClassType)=-1 then begin
      S:='Exception='+ExceptObj.ClassName;
      if ExceptObj is Exception then
        S:=S+': '+Exception(ExceptObj).Message;
      if OSException then
        S:=S+' (OS Exception)';
      FLogger.Write(Format('%s',[S]),ltError,Self.ObjectName);
      if FStacked then
        WriteStack;
    end;
  end;
end;

procedure TBisDebug.WriteStack;
var
  Info: TJclStackInfoList;
  Str: TStringList;
  i: Integer;
begin
  Str:=TStringList.Create;
  try
    Info:=TJclStackInfoList.Create(true,0,nil);
    try
      Info.AddToStrings(Str,True,True,True,True);
      if Assigned(FLogger) then begin
        for i:=0 to Str.Count-1 do begin
          FLogger.Write(Str[i],ltInformation,Self.ObjectName);
        end;
      end;
    finally
      Info.Free;
    end;
  finally
    Str.Free;
  end;
end;

end.
