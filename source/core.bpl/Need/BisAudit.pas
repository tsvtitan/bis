unit BisAudit;

interface

uses Windows, Classes,
     BisObject, BisLocalbase, BisApplication, BisIfaces, BisThread;

type
  TBisAudit=class;

  TBisAuditThread=class(TBisThread)
  private
    FParent: TBisAudit;
    procedure Audit;
  public
    procedure Execute; override;

    property Parent: TBisAudit read FParent write FParent;
  end;

  TBisAuditMode=(amTerminate,amShow);

  TBisAudit=class(TBisObject)
  private
    FThread: TBisAuditThread;
    FLocalbase: TBisLocalBase;
    FApplication: TBisApplication;
    FDate: Variant;
    FSecond: Integer;
    FEnabled: Boolean;
    FCount: Variant;
    FMode: TBisAuditMode;
    FModuleName: String;
    FIfaceName: String;
    FFailed: Boolean;
    procedure ThreadTerminate(Sender: TObject);
    procedure Load;
    procedure Audit;
  protected
    property Failed: Boolean read FFailed write FFailed;
    property Second: Integer read FSecond write FSecond;
    property Mode: TBisAuditMode read FMode write FMode;
    property ModuleName: String read FModuleName write FModuleName;
    property IfaceName: String read FIfaceName write FIfaceName;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure Start;
    procedure Stop;
    procedure Save;

    property Localbase: TBisLocalBase read FLocalbase write FLocalbase;
    property Application: TBisApplication read FApplication write FApplication;
    property Enabled: Boolean read FEnabled write FEnabled;
    property Date: Variant read FDate write FDate;
    property Count: Variant read FCount write FCount;

  end;


implementation

uses Variants, SysUtils, Math, DateUtils,
     BisConfig, BisConsts, BisUtils, BisCore, BisFm,
     BisIfaceModules;

{ TBisAuditThread }

procedure TBisAuditThread.Audit;
begin
  if Assigned(FParent) then
    FParent.Audit;
end;

procedure TBisAuditThread.Execute;
var
  SleepTime: Integer;
  SleepDelta: Integer;
  Flag: Boolean;
begin
  inherited Execute;
  Randomize;
  if Assigned(FParent) and FParent.Enabled then begin
    while not Terminated do begin

      SleepTime:=FParent.Second*1000;
      SleepDelta:=Random(SleepTime);
      Flag:=Odd(SleepDelta);
      if Flag then
        SleepTime:=SleepTime+SleepDelta
      else SleepTime:=SleepTime-SleepDelta;
      Sleep(SleepTime);

      Synchronize(Audit);

      if FParent.Failed then
        exit;
      
    end;
  end;
end;

{ TBisAudit }

constructor TBisAudit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSecond:=5;
  FDate:=Null;
  FCount:=Null;
  FMode:=amTerminate;
  FModuleName:='';
  FIfaceName:='';
end;

destructor TBisAudit.Destroy;
begin
  FreeAndNilEx(FThread);
  inherited Destroy;
end;

procedure TBisAudit.Init;
begin
  inherited Init;
  Load;
end;

procedure TBisAudit.Load;
var
  Config: TBisConfig;
  S: String;
  D: TDateTime;
  C: Integer;
  FS: TFormatSettings;
begin
  if Assigned(FLocalbase) then begin
    Config:=TBisConfig.Create(Self);
    try
      if FLocalbase.ReadToConfig(ObjectName,Config) then begin

        FEnabled:=Config.Read(ObjectName,SEnabled,false);
        FSecond:=Config.Read(ObjectName,SSecond,FSecond);

        FDate:=Null;
        S:=Config.Read(ObjectName,SDate,'');
        FS.DateSeparator:='.';
        FS.ShortDateFormat:=SDateFormat;
        if TryStrToDate(S,D,FS) then
          if D<>NullDate then
            FDate:=D;

        FCount:=Null;
        S:=Config.Read(ObjectName,SCount,'');
        C:=StrToIntDef(S,-1);
        if C<>-1 then
          FCount:=C;

        FModuleName:=Config.Read(ObjectName,SModule,FModuleName);
        FIfaceName:=Config.Read(ObjectName,SIface,FIfaceName);
        FMode:=Config.Read(ObjectName,SMode,FMode);

      end;
    finally
      Config.Free;
    end;
  end;
end;

procedure TBisAudit.Save;
var
  Config: TBisConfig;
  S: String;
begin
  if Assigned(FLocalbase) then begin
    Config:=TBisConfig.Create(Self);
    try
      Config.Write(ObjectName,SEnabled,FEnabled);
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
      FLocalbase.Save;
    finally
      Config.Free;
    end;
  end;
end;

procedure TBisAudit.Start;
begin
  if FEnabled then begin
    Stop;
    if not Assigned(FThread) then begin
      FThread:=TBisAuditThread.Create(true);
      FThread.Parent:=Self;
      FThread.OnTerminate:=ThreadTerminate;
      FThread.Resume;
    end;
  end;
end;

procedure TBisAudit.Stop;
begin
  FreeAndNilEx(FThread);
end;

procedure TBisAudit.ThreadTerminate(Sender: TObject);
begin
  if FFailed then begin
    FThread:=nil;
    case FMode of
      amTerminate: begin
        if Assigned(FApplication) then
          FApplication.Terminate;
      end;
      amShow: begin
//        ReloadParams;
        Start;
      end;
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
      Result:=D1>D2;
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
      if Assigned(Module) then begin
???        Iface:=TBisIface(Module.Ifaces.Find(FIfaceName));
        if Assigned(Iface) then begin
          if Iface is TBisFormIface then
            TBisFormIface(Iface).ShowModal
          else
            Iface.Show;
        end;
      end;
      if not Assigned(Iface) then
        FMode:=amTerminate;
    end;
  end;
end;

end.
