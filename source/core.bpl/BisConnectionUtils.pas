unit BisConnectionUtils;

interface

uses Classes, SyncObjs,
     BisConfig, BisProfile, BisMenus, BisTasks, BisDataSet,
     BisAlarmsFm, BisInterfaces;

function DefaultLogin(var Canceled: Boolean): Boolean;
function DefaultExists: Boolean;
function DefaultExistsLogged: Boolean;
function DefaultCheck: Boolean;
function DefaultCheckSessions: Boolean;
function DefaultRefreshPermissions: Boolean;
function DefaultUpdate(Params: TBisConfig=nil): Boolean;
function DefaultSaveProfile(Profile: TBisProfile): Boolean;
function DefaultLoadMenus(Menus: TBisMenus): Boolean;
function DefaultLoadTasks(Tasks: TBisTasks): Boolean;
function DefaultSaveTask(Task: TBisTask): Boolean;
function DefaultLoadAlarms(Alarms: TBisAlarms): Boolean;
function DefaultLoadInterfaces(Interfaces: TBisInterfaces): Boolean;
function DefaultLoadDocument(DocumentId: Variant; Stream: TStream): Boolean;
function DefaultLoadReport(ReportId: Variant; Stream: TStream): Boolean;
function DefaultLoadScript(ScriptId: Variant; Stream: TStream): Boolean;
function DefaultExecute(DataSet: TBisDataSet): Boolean;
function DefaultGetRecords(DataSet: TBisDataSet): Boolean;
function DefaultCancel(DataSet: TBisDataSet=nil): Boolean;

procedure DefaultLoginThreaded;

implementation

uses SysUtils,
     AsyncCalls,
     BisCore, BisUtils, BisConsts, BisProvider, BisLogger, BisThreads;

var
  FLock: TCriticalSection;

procedure CoreLogout;
begin
  Core.LoginIface.Logout;
end;

function CoreLogin(var Canceled: Boolean): Boolean;
begin
  Result:=false;
  if not Core.LoginIface.Logged and
     not Core.LoginIface.InLogin then begin
    Core.LoginIface.LoginDelayed:=true;
    Result:=Core.LoginIface.Login;
    if Result then
      Core.LoginIface.LoginDelayed:=false
    else
      Canceled:=Core.LoginIface.Canceled;  
  end;
end;
  
function DefaultLogin(var Canceled: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(FLock) then begin
    FLock.Enter;
    try
      if Assigned(Core) and Assigned(Core.LoginIface) and not ApplicationFinished then begin
        Result:=Core.LoginIface.Logged;
        if not Result and not Core.LoginIface.InLogin then begin
          if not IsMainThread then begin
            EnterMainThread;
            try
              if IsMainThread then begin
                CoreLogout;
                Result:=CoreLogin(Canceled);
              end;
            finally
              LeaveMainThread;
            end;
          end else begin
            CoreLogout;
            Result:=CoreLogin(Canceled);
          end;
        end;
      end;
    finally
      FLock.Leave;
    end;
  end;
end;

function DefaultExists: Boolean;
begin
  Result:=false;
  if Assigned(Core) and {Assigned(Core.Connection) and
     Core.Connection.Enabled and }not Core.NoLogin then
    Result:=true;
end;

function DefaultExistsLogged: Boolean;
begin
  Result:=DefaultExists;
  if Result then
    Result:=Core.Logged;
end;

function DefaultCheck: Boolean;
var
  ADate: TDateTime;
  T: TDateTime;
begin
  Result:=false;
  if DefaultExists and Core.LoginIface.Enabled and not Core.NoLogin then begin
    if Core.LoginIface.Logged then begin
      ADate:=NullDate;
      T:=Now;
      try
        if Core.LoginIface.Connection.Check(Core.LoginIface.SessionId,ADate) then begin
          ADate:=ADate-(Now-T)/2;
          Core.ServerDate:=ADate;
          Result:=true;
        end else
          Core.LoginIface.Logged:=false;
      except
        On E: Exception do begin
          Core.Logger.Write(E.Message,ltError);
          Core.LoginIface.Logged:=false;
        end;
      end;
    end;
  end;
end;

function DefaultCheckLogin: Boolean;
var
  Canceled: Boolean;
begin
  Result:=false;
  if DefaultExists then begin
    Result:=DefaultCheck;
    while not Result do begin
      Canceled:=false;
      Result:=DefaultLogin(Canceled);
      if Result or Canceled or ApplicationFinished then
        break;
    end;
  end;
end;

function DefaultCheckSessions: Boolean;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Core.Connection.CheckSessions;
    Result:=true;
  end;
end;

function DefaultRefreshPermissions: Boolean;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Core.Connection.RefreshPermissions(Core.SessionId);
    Result:=true;
  end;
end;

function DefaultUpdate(Params: TBisConfig=nil): Boolean;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Core.Connection.Update(Core.SessionId,Params);
    Result:=true;
  end;
end;

function DefaultSaveProfile(Profile: TBisProfile): Boolean;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Core.Connection.SaveProfile(Core.SessionId,Profile);
    Result:=true;
  end;
end;

function DefaultLoadMenus(Menus: TBisMenus): Boolean;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Core.Connection.LoadMenus(Core.SessionId,Menus);
    Result:=true;
  end;
end;

function DefaultLoadTasks(Tasks: TBisTasks): Boolean;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Core.Connection.LoadTasks(Core.SessionId,Tasks);
    Result:=true;
  end;
end;

function DefaultSaveTask(Task: TBisTask): Boolean;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Core.Connection.SaveTask(Core.SessionId,Task);
    Result:=true;
  end;
end;

function DefaultLoadAlarms(Alarms: TBisAlarms): Boolean;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Core.Connection.LoadAlarms(Core.SessionId,Alarms);
    Result:=true;
  end;
end;

function DefaultLoadInterfaces(Interfaces: TBisInterfaces): Boolean;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Core.Connection.LoadInterfaces(Core.SessionId,Interfaces);
    Result:=true;
  end;
end;

function DefaultLoadDocument(DocumentId: Variant; Stream: TStream): Boolean;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Core.Connection.LoadDocument(Core.SessionId,DocumentId,Stream);
    Result:=true;
  end;
end;

function DefaultLoadReport(ReportId: Variant; Stream: TStream): Boolean;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Core.Connection.LoadReport(Core.SessionId,ReportId,Stream);
    Result:=true;
  end;
end;

function DefaultLoadScript(ScriptId: Variant; Stream: TStream): Boolean;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Core.Connection.LoadScript(Core.SessionId,ScriptId,Stream);
    Result:=true;
  end;
end;

function DefaultExecute(DataSet: TBisDataSet): Boolean;
var
  Provider: TBisProvider;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Provider:=nil;
    if Assigned(DataSet) and Assigned(Core.ProviderModules) then
      Provider:=Core.ProviderModules.LockFindProvider(DataSet.ProviderName);

    if not Assigned(Provider) then begin
      Core.Connection.Execute(Core.SessionId,DataSet);
      Result:=true;
    end else begin
      Provider.Handle(DataSet);
      Result:=true;
    end;
  end;
end;

function DefaultGetRecords(DataSet: TBisDataSet): Boolean;
var
  Provider: TBisProvider;
begin
  Result:=false;
  if DefaultCheckLogin then begin
    Provider:=nil;
    if Assigned(DataSet) and Assigned(Core.ProviderModules) then
      Provider:=Core.ProviderModules.LockFindProvider(DataSet.ProviderName);

    if not Assigned(Provider) then begin
      Core.Connection.GetRecords(Core.SessionId,DataSet);
      Result:=true;
    end else begin
      Provider.Handle(DataSet);
      Result:=true;
    end;
  end;
end;

function DefaultCancel(DataSet: TBisDataSet=nil): Boolean;
var
  CheckSum: String;
begin
  Result:=false;
  if DefaultCheckLogin then begin

    CheckSum:='';
    if Assigned(DataSet) then
      CheckSum:=DataSet.CheckSum;

    Core.Connection.Cancel(Core.SessionId,CheckSum);
    Result:=true;
  end;
end;

var
  FCheckThread: TBisThread=nil;

type
  TBisCheckThread=class(TBisThread)
  protected
    procedure DoWork; override;
    procedure DoEnd; override;
  public
    destructor Destroy; override;
  end;

{ TBisCheckThread}

destructor TBisCheckThread.Destroy;
begin
  FCheckThread:=nil;
  inherited Destroy;
end;

procedure TBisCheckThread.DoEnd;
begin
  inherited DoEnd;
  Synchronize(Free);
end;

procedure TBisCheckThread.DoWork;
var
  Canceled: Boolean;
begin
  if DefaultExists then
    DefaultLogin(Canceled);
end;

procedure DefaultLoginThreaded;
begin
  if not Assigned(FCheckThread) then begin
    FCheckThread:=TBisCheckThread.Create;
    FCheckThread.Start;
  end;
end;


initialization
  FLock:=TCriticalSection.Create;

finalization
  FreeAndNilEx(FLock);


end.
