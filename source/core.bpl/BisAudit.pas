unit BisAudit;

interface

uses Windows, Classes,
     BisObject, BisTasks,
     BisLocalbase, BisApplication, BisIfaces;

type

  TBisAuditMode=(amTerminate,amShow);

  TBisAudit=class(TBisTask)
  private
    FLocalbase: TBisLocalBase;
    FApplication: TBisApplication;
    FDate: Variant;
    FDefaultDate: Variant;
    FSeconds: Integer;
    FCount: Variant;
    FDefaultCount: Variant;
    FMode: TBisAuditMode;
    FModuleName: String;
    FIfaceName: String;
    FFailed: Boolean;
    FIfaceShowCount: Integer;
    procedure Audit;
  protected
    procedure Execute(Thread: TBisTaskThread); override;
    function GetWaitInterval: Cardinal; override;
    procedure DoEnd; override;

    property Failed: Boolean read FFailed write FFailed;
    property Seconds: Integer read FSeconds write FSeconds;
    property Mode: TBisAuditMode read FMode write FMode;
    property ModuleName: String read FModuleName write FModuleName;
    property IfaceName: String read FIfaceName write FIfaceName;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function CanStart: Boolean; override;
    procedure Save;
    procedure Load;

    property Localbase: TBisLocalBase read FLocalbase write FLocalbase;
    property Application: TBisApplication read FApplication write FApplication;
    property Date: Variant read FDate write FDate;
    property Count: Variant read FCount write FCount;

  end;


implementation

uses Variants, SysUtils, Math, DateUtils,
     BisConfig, BisConsts, BisUtils, BisCore, BisFm, BisSystemUtils,
     BisIfaceModules;

{ TBisAudit }

constructor TBisAudit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF AUDIT}
  Enabled:=true;
  FDefaultDate:=IncDay(Now,-1);
  FDefaultCount:=Null;
  {$ELSE}
  Enabled:=false;
  FDefaultDate:=Null;
  FDefaultCount:=Null;
  {$ENDIF}
  FDate:=FDefaultDate;
  FCount:=FDefaultCount;
  FSeconds:=60;
  FMode:=amTerminate;
  FModuleName:='';
  FIfaceName:='';
  FIfaceShowCount:=0;
end;

destructor TBisAudit.Destroy;
begin
  inherited Destroy;
end;

procedure TBisAudit.Init;
begin
  inherited Init;
end;

procedure TBisAudit.Load;
var
  Config: TBisConfig;                 
  S: String;
  D: TDateTime;
  C: Integer;
  FS: TFormatSettings;
  Success: Boolean;
begin
  if Assigned(FLocalbase) then begin
    Config:=TBisConfig.Create(Self);
    try
      Success:=FLocalbase.ReadToConfig(SParamLicense,Config,true);
      if Success then begin

        Enabled:=Config.Read(SParamLicense,SEnabled,Enabled);
        FSeconds:=Config.Read(SParamLicense,SSeconds,FSeconds);

        S:=Config.Read(SParamLicense,SDate,'');
        FS.DateSeparator:='.';
        FS.ShortDateFormat:=SDateFormat;
        if TryStrToDate(S,D,FS) then begin
          if D<>NullDate then
            FDate:=D;
        end else
          FDate:=FDefaultDate;

        S:=Config.Read(SParamLicense,SCount,'');
        C:=StrToIntDef(S,-1);
        if C<>-1 then
          FCount:=C
        else
          FCount:=FDefaultCount;

        FModuleName:=Config.Read(SParamLicense,SModule,FModuleName);
        FIfaceName:=Config.Read(SParamLicense,SIface,FIfaceName);
        FMode:=Config.Read(SParamLicense,SMode,FMode);

      end;
    finally
      Config.Free;
    end;
  end;
end;

procedure TBisAudit.Save;
var
  Config: TBisConfig;
//  S: String;
begin
  if Assigned(FLocalbase) then begin
    Config:=TBisConfig.Create(Self);
    try
  {    Config.Write(ObjectName,SEnabled,Enabled);
      Config.Write(ObjectName,SSecond,FSecond);
      if VarIsNull(FDate) then
        Config.Write(ObjectName,SDate,'')
      else begin
        S:=FormatDateTime(SDateFormat,VarToDateDef(FDate,NullDate));
        Config.Write(ObjectName,SDate,S);
      end;
      Config.Write(ObjectName,SCount,VarToStrDef(FCount,''));
      Config.Write(ObjectName,SModule,FModuleName);
      Config.Write(ObjectName,SIface,FIfaceName);
      Config.Write(ObjectName,SMode,FMode);

      FLocalbase.WriteFromConfig(ObjectName,Config);
      FLocalbase.Save;}
    finally
      Config.Free;
    end;
  end;
end;

procedure TBisAudit.Audit;

  function AuditByDate: Boolean;
  var
    D1,D2: TDateTime;
  begin
    Result:=false;
    if not VarIsNull(FDate) then begin
      D1:=DateOf(Now);
      D2:=VarToDateDef(FDate,NullDate);
      Result:=D1>=D2;
    end;
  end;

  function AuditByCount: Boolean;
  var
    V: Integer;
  begin
    Result:=false;
    if not VarIsNull(FCount) then begin
      V:=VarToIntDef(FCount,0);
      Result:=V<=0;
    end;
  end;

var
  Iface: TBisIface;
  MName: String;
  Module: TBisIfaceModule;
begin
  if Assigned(Core) then begin
    Failed:=AuditByDate;
    if not Failed then    
      Failed:=AuditByCount;
    if Failed and (FMode=amShow) then begin
      Iface:=nil;
      MName:=FModuleName+TBisIfaceModule.GetObjectName;
      Module:=TBisIfaceModule(Core.IfaceModules.Find(MName));
      if Assigned(Module) and (FIfaceShowCount<3) then begin
        Iface:=TBisIface(Module.Ifaces.Find(FIfaceName));
        if Assigned(Iface) then begin
          if Iface is TBisFormIface then
            TBisFormIface(Iface).ShowModal
          else
            Iface.Show;
          Inc(FIfaceShowCount);
        end;
      end;
      if not Assigned(Iface) then
        FMode:=amTerminate;
    end;
  end;
end;

function TBisAudit.GetWaitInterval: Cardinal;
var
  SleepTime: Integer;
  SleepDelta: Integer;
  Flag: Boolean;
begin
  Randomize;
  SleepTime:=FSeconds*1000;
  SleepDelta:=Random(SleepTime);
  Flag:=Odd(SleepDelta);
  if Flag then
    SleepTime:=SleepTime+SleepDelta
  else SleepTime:=SleepTime-SleepDelta;
  Result:=SleepTime;
end;

function TBisAudit.CanStart: Boolean;
begin
  Result:=inherited CanStart;
  if Result then begin
//    Result:=StrToTime('17:42')<=Time;
  end;
end;

procedure TBisAudit.Execute(Thread: TBisTaskThread);
begin
  Thread.Synchronize(Audit);
  if FFailed and (FMode=amTerminate) then begin
    Enabled:=false;
    Thread.Terminate;
  end;
end;

procedure TBisAudit.DoEnd;
begin
  if FFailed then begin
    case FMode of
      amTerminate: begin
        ProcessStop(GetCurrentProcessId,1000);
      end;
    end;
  end;
end;

end.