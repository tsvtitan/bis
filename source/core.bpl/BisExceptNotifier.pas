unit BisExceptNotifier;

interface

uses Classes, SysUtils, Contnrs,
     JclDebug,
     BisObject, BisLogger, BisConfig, BisLocalBase;

type

  TBisExceptNotifier=class;

  TBisExceptNotifierExceptionEvent=procedure (Notifier: TBisExceptNotifier; E: Exception) of object;
  TBisExceptNotifierSetThreadNameEvent=procedure (Notifier: TBisExceptNotifier; const ThreadID: Cardinal;
                                                  const ThreadName: String) of object;

  TBisExceptNotifier=class(TBisObject)
  private
    FLogger: TBisLogger;
    FEnabled: Boolean;
    FStackEnabled: Boolean;
    FStackOnlySource: Boolean;
    FStackAfterProcName: String;
    FOnException: TBisExceptNotifierExceptionEvent;
    FOnSetThreadName: TBisExceptNotifierSetThreadNameEvent;
    FLocalBase: TBisLocalBase;
    procedure ExceptNotifier(ExceptObj: TObject; ExceptAddr: Pointer; OSException: Boolean; PException: Pointer);
    procedure WriteStack;
  protected
    procedure DoException(E: Exception); virtual;
    procedure DoSetThreadName(ThreadId: Cardinal; const ThreadName: string); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    property Logger: TBisLogger read FLogger write FLogger;
    property Enabled: Boolean read FEnabled write FEnabled;
    property LocalBase: TBisLocalBase read FLocalBase write FLocalBase;

    property OnException: TBisExceptNotifierExceptionEvent read FOnException write FOnException;
    property OnSetThreadName: TBisExceptNotifierSetThreadNameEvent read FOnSetThreadName write FOnSetThreadName;
  end;


var
  ExceptNotifierIgnores: TClassList=nil;

procedure GetStack(Strings: TStrings; AfterProcName: String; OnlySource: Boolean=true);

implementation

uses Windows, Registry,
     JclHookExcept, JclSysInfo, JclFileUtils,
     BisConsts, BisThreads, BisUtils;

procedure GetStack(Strings: TStrings; AfterProcName: String; OnlySource: Boolean=true);
var
  Info: TJclStackInfoList;
  Item: TJclStackInfoItem;
  LInfo: TJclLocationInfo;
  i: Integer;
  Module: HMODULE;
  S,S1,S2: String;
  FixedProcName: String;
  Flag1,Flag2: Boolean;
begin
  if Assigned(Strings) then begin
    Info:=TJclStackInfoList.Create(true,0,nil);
    try
      Flag1:=Trim(AfterProcName)='';
      for i:=0 to Info.Count-1 do begin
        Item:=Info.Items[i];
        if GetLocationInfo(Item.CallerAdr,LInfo) then begin

          Module:=ModuleFromAddr(Item.CallerAdr);

          FixedProcName:=LInfo.ProcedureName;
          if Pos(LInfo.UnitName+'.',FixedProcName) = 1 then
             FixedProcName:=Copy(FixedProcName,Length(LInfo.UnitName)+2,Length(FixedProcName)-Length(LInfo.UnitName)-1);

          S1:=FixedProcName;
          if LInfo.UnitName<>'' then
            S1:=FormatEx('%s.%s',[LInfo.UnitName,S1]);

          if Flag1 then begin

            S:=ExtractFileName(GetModulePath(Module));

            Flag2:=true;
            if OnlySource then
              Flag2:=LInfo.LineNumber>0;

            if Flag2 then begin

              S2:='';
              if LInfo.LineNumber>0 then
                S2:=FormatEx('(Line %d "%s" %s)',[LInfo.LineNumber,LInfo.SourceName,S])
              else
                S2:=FormatEx('(%s)',[S]);

              S:=FormatEx('%s %s',[S1,S2]);

              Strings.Add(Trim(S));
            end;
          end else
            Flag1:=AnsiSameText(AfterProcName,S1)
        end;
      end;
    finally
      Info.Free;
    end;
  end;
end;

{ TBisExceptNotifier }

constructor TBisExceptNotifier.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  JclStackTrackingOptions:=[stStack, stExceptFrame, stRawMode, stAllModules, {stStaticModuleList,}
                            stDelayedTrace{, stTraceAllExceptions{, stMainThreadOnly}];
  JclStartExceptionTracking;
  JclAddExceptNotifier(ExceptNotifier,npNormal);
  FStackAfterProcName:='JclHookExcept.DoExceptNotify';
end;

destructor TBisExceptNotifier.Destroy;
begin
  JclRemoveExceptNotifier(ExceptNotifier);
  JclStopExceptionTracking;
  inherited Destroy;
end;

procedure TBisExceptNotifier.Init;
var
  Config: TBisConfig;
begin
  inherited Init;
  if Assigned(FLocalBase) then begin
    Config:=TBisConfig.Create(Self);
    try
      if FLocalBase.ReadToConfig(ObjectName,Config) then begin
        FEnabled:=Config.Read(ObjectName,SEnabled,FEnabled);
        FStackEnabled:=Config.Read(ObjectName,SStackEnabled,FStackEnabled);
        FStackOnlySource:=Config.Read(ObjectName,SStackOnlySource,FStackOnlySource);
        FStackAfterProcName:=Config.Read(ObjectName,SStackAfterProcName,FStackAfterProcName);
      end;
    finally
      Config.Free;
    end;
  end;
end;

procedure TBisExceptNotifier.DoException(E: Exception);
begin
  if Assigned(FOnException) then
    FOnException(Self,E);
end;

procedure TBisExceptNotifier.DoSetThreadName(ThreadId: Cardinal; const ThreadName: string);
begin
  if Assigned(FOnSetThreadName) then
    FOnSetThreadName(Self,ThreadId,ThreadName);
end;

procedure TBisExceptNotifier.ExceptNotifier(ExceptObj: TObject; ExceptAddr: Pointer; OSException: Boolean; PException: Pointer);
var
  S: String;
  ThreadInfo: PBisThreadNameInfo;
  P: PExceptionRecord;
begin
  P:=PExceptionRecord(PException);
  if OSException and Assigned(P) and (P^.ExceptionCode=ThreadNameAddress) then begin
    ThreadInfo:=@P^.ExceptionInformation;
    if Assigned(ThreadInfo) then
      DoSetThreadName(GetCurrentThreadId,ThreadInfo.Name);
    exit;
  end else
    if ExceptObj is Exception then
      DoException(Exception(ExceptObj));

  if FEnabled and Assigned(FLogger) and Assigned(ExceptNotifierIgnores) then begin
    if ExceptNotifierIgnores.IndexOf(ExceptObj.ClassType)=-1 then begin
      S:='Exception='+ExceptObj.ClassName;
      if ExceptObj is Exception then
        S:=S+': '+Exception(ExceptObj).Message;
      if OSException then
        S:=S+' (OS Exception)';

      FLogger.Write(Format('%s',[S]),ltError,Self.ObjectName);
      if FStackEnabled then
        WriteStack;
    end;
  end;
end;

procedure TBisExceptNotifier.WriteStack;
var
  Str: TStringList;
  i: Integer;
begin
  if Assigned(FLogger) then begin
    Str:=TStringList.Create;
    try
   //   GetStack(Str,'JclHookExcept.HookedExceptObjProc',FStackOnlySource);
      GetStack(Str,FStackAfterProcName,FStackOnlySource);
      for i:=0 to Str.Count-1 do
        FLogger.Write(Str[i],ltInformation,Self.ObjectName);
    finally
      Str.Free;
    end;
  end;
end;

initialization
  ExceptNotifierIgnores:=TClassList.Create;
  ExceptNotifierIgnores.Add(EAbort);
  ExceptNotifierIgnores.Add(EExternalException);
  ExceptNotifierIgnores.Add(ERegistryException);

finalization
  ExceptNotifierIgnores.Free;


end.
