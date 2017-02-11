unit BisTasks;

interface

uses Classes, Contnrs, SyncObjs, Variants, SysUtils,
     BisObject, BisCoreObjects, BisIfaces, BisInterfaces, BisNotifyEvents,
     BisThreads, BisDataSet;

type
  TBisTaskPriority=TThreadPriority;

  TBisTaskSchedule=(tscRun,tscOnce,tscEveryDay,tscEveryWeek,tscEveryMonth);

  TBisTaskRepeat=(trSecond,trMinute,trHour,trDay,trWeek,trMonth);

  TBisTaskExecute=class(TObject)
  private
    FResultString: String;
    FDateEnd: TDateTime;
    FDateBegin: TDateTime;
    FIsRepeat: Boolean;
    FDifference: Integer;
  public
    property DateBegin: TDateTime read FDateBegin write FDateBegin;
    property DateEnd: TDateTime read FDateEnd write FDateEnd;
    property ResultString: String read FResultString write FResultString;
    property IsRepeat: Boolean read FIsRepeat write FIsRepeat;
    property Difference: Integer read FDifference write FDifference; 
  end;

  TBisTaskExecutes=class(TObjectList)
  private
    FDelay: Integer;
    function GetItem(Index: Integer): TBisTaskExecute;
  public
    function Add(DateBegin: TDateTime; ResultString: String; IsRepeat: Boolean; Difference: Integer): TBisTaskExecute;
    function Find(DateExecute: TDateTime; Offset: Integer): TBisTaskExecute;
    function Exists(DateExecute: TDateTime; Offset: Integer): Boolean;
    procedure DeletePrevious;

    property Items[Index: Integer]: TBisTaskExecute read GetItem;

    property Delay: Integer read FDelay write FDelay;
  end;

  TBisTaskThread=class(TBisWaitThread)
  end;

  TBisTask=class(TBisCoreObject)
  private
    FIfaces: TBisIfaces;
    FExecutes: TBisTaskExecutes;
    FRunFlag: Boolean;
    FRepeatExists: Boolean;
    FAfterRunEvent: TBisNotifyEvent;
    FThread: TBisTaskThread;
    FEnabled: Boolean;
    FPriority: TBisTaskPriority;
    FSchedule: TBisTaskSchedule;
    FID: String;
    FCommandString: String;
    FDateBegin: TDateTime;
    FDateEnd: TDateTime;
    FDayFrequency: Integer;
    FWeekFrequency: Integer;
    FSunday: Boolean;
    FWednesday: Boolean;
    FTuesday: Boolean;
    FFriday: Boolean;
    FMonthDay: Integer;
    FThursday: Boolean;
    FMonday: Boolean;
    FJanuary: Boolean;
    FSaturday: Boolean;
    FApril: Boolean;
    FNovember: Boolean;
    FMay: Boolean;
    FDecember: Boolean;
    FAugust: Boolean;
    FFebruary: Boolean;
    FJune: Boolean;
    FMarch: Boolean;
    FJuly: Boolean;
    FOctober: Boolean;
    FSeptember: Boolean;
    FRepeatEnabled: Boolean;
    FRepeatType: TBisTaskRepeat;
    FRepeatValue: Integer;
    FRepeatCount: Integer;
    FDateExecute: TDateTime;
    FResultString: String;
    FInterfaceID: String;
    FIfaceClass: TBisIfaceClass;
    FOffset: Integer;
    FDifference: Integer;
    FDataSet: TBisDataSet;

    FRealDateBegin: TDateTime;
    FProcName: String;
    FOnEnd: TNotifyEvent;

    function GetInterface: TBisInterface;
    procedure AfterRun(Sender: TObject);
    procedure InterfaceShow;
    procedure IfaceClassShow;
    function DateBeginWithOffset(var Delta: Integer): TDateTime;
    procedure ThreadTimeout(Thread: TBisWaitThread);
    procedure ThreadEnd(Thread: TBisThread);
    function GetWorking: Boolean;
  protected
    procedure Execute(Thread: TBisTaskThread); virtual;
    function GetWaitInterval: Cardinal; virtual;
    procedure DoEnd; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanStart: Boolean; virtual;
    procedure Start(Wait: Boolean=false); virtual;
    procedure Stop; virtual;
    procedure Reset;

    procedure WriteData(Writer: TWriter);
    procedure ReadData(Reader: TReader);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);

    property WaitInterval: Cardinal read GetWaitInterval;
    property Working: Boolean read GetWorking;
    property &Interface: TBisInterface read GetInterface;

    property IfaceClass: TBisIfaceClass read FIfaceClass write FIfaceClass;
    
    property ID: String read FID write FID;
    property Enabled: Boolean read FEnabled write FEnabled;
    property Priority: TBisTaskPriority read FPriority write FPriority;
    property Schedule: TBisTaskSchedule read FSchedule write FSchedule;
    property InterfaceID: String read FInterfaceID write FInterfaceID;
    property ProcName: String read FProcName write FProcName;
    property CommandString: String read FCommandString write FCommandString;
    property DateBegin: TDateTime read FDateBegin write FDateBegin;
    property Offset: Integer read FOffset write FOffset; 
    property DateEnd: TDateTime read FDateEnd write FDateEnd;
    property DayFrequency: Integer read FDayFrequency write FDayFrequency;
    property WeekFrequency: Integer read FWeekFrequency write FWeekFrequency;
    property Monday: Boolean read FMonday write FMonday;
    property Tuesday: Boolean read FTuesday write FTuesday;
    property Wednesday: Boolean read FWednesday write FWednesday;
    property Thursday: Boolean read FThursday write FThursday;
    property Friday: Boolean read FFriday write FFriday;
    property Saturday: Boolean read FSaturday write FSaturday;
    property Sunday: Boolean read FSunday write FSunday;
    property MonthDay: Integer read FMonthDay write FMonthDay;
    property January: Boolean read FJanuary write FJanuary;
    property February: Boolean read FFebruary write FFebruary;
    property March: Boolean read FMarch write FMarch;
    property April: Boolean read FApril write FApril;
    property May: Boolean read FMay write FMay;
    property June: Boolean read FJune write FJune;
    property July: Boolean read FJuly write FJuly;
    property August: Boolean read FAugust write FAugust;
    property September: Boolean read FSeptember write FSeptember;
    property October: Boolean read FOctober write FOctober;
    property November: Boolean read FNovember write FNovember;
    property December: Boolean read FDecember write FDecember;
    property RepeatEnabled: Boolean read FRepeatEnabled write FRepeatEnabled;
    property RepeatValue: Integer read FRepeatValue write FRepeatValue;
    property RepeatType: TBisTaskRepeat read FRepeatType write FRepeatType;
    property RepeatCount: Integer read FRepeatCount write FRepeatCount;
    property DateExecute: TDateTime read FDateExecute write FDateExecute;
    property ResultString: String read FResultString write FResultString;

    property OnEnd: TNotifyEvent read FOnEnd write FOnEnd; 
  end;

  TBisTaskClass=class of TBisTask;

  TBisTasks=class(TBisCoreObjects)
  private
    FThread: TBisWaitThread;
    FLock: TCriticalSection;
    FEnabled: Boolean;
    function GetItem(Index: Integer): TBisTask;
    procedure ThreadTimeout(Thread: TBisWaitThread);
    procedure ResetTasks;
    procedure StopTasks;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FindByID(ID: String): TBisTask;
    function Add(ID: String; ObjectName: String): TBisTask; reintroduce;
    function AddClass(AClass: TBisTaskClass): TBisTask;
    function AddTask(ATask: TBisTask): Boolean;
    procedure InternalClear;
    procedure Start;
    procedure Stop;
    procedure WriteData(Writer: TWriter);
    procedure ReadData(Reader: TReader);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    function Running: Boolean;

    property Items[Index: Integer]: TBisTask read GetItem;

    property Enabled: Boolean read FEnabled write FEnabled;

  end;

implementation

uses Windows, DateUtils, Math,
     BisUtils, BisCore, BisConsts, BisLogger,
     BisConnections, BisConnectionUtils;

{ TBisTaskExecutes }

function TBisTaskExecutes.GetItem(Index: Integer): TBisTaskExecute;
begin
  Result:=TBisTaskExecute(inherited Items[Index]);
end;

function TBisTaskExecutes.Add(DateBegin: TDateTime;  ResultString: String; IsRepeat: Boolean; Difference: Integer): TBisTaskExecute;
begin
  Result:=TBisTaskExecute.Create;
  Result.DateBegin:=DateBegin;
  Result.DateEnd:=NullDate;
  Result.ResultString:=ResultString;
  Result.IsRepeat:=IsRepeat;
  Result.Difference:=Difference;
  inherited Add(Result);
end;

function TBisTaskExecutes.Find(DateExecute: TDateTime; Offset: Integer): TBisTaskExecute;
var
  i: Integer;
  Item: TBisTaskExecute;
  FLag: Boolean;
  DBegin,DEnd,D: TDateTime;
begin
  Result:=nil;
  for i:=Count-1 downto 0 do begin
    Item:=Items[i];
    if (Item.DateEnd<>NullDate) then begin
      FLag:=false;
      if Abs(Offset)>0 then begin
        DBegin:=IncSecond(Item.DateBegin,-Item.Difference);
        DEnd:=IncSecond(DBegin,Offset);
        if DBegin>DEnd then begin
          D:=DBegin;
          DBegin:=DEnd;
          DEnd:=D;
        end;
        Flag:=(DBegin<=DateExecute) and (DateExecute<=DEnd);
      end;
      if ((Item.DateBegin<=DateExecute) and (DateExecute<=IncMilliSecond(Item.DateEnd,FDelay))) or Flag then begin
        Result:=Item;
        break;
      end;
    end;
  end;
end;

procedure TBisTaskExecutes.DeletePrevious;
var
  i: Integer;
  Index: Integer;
  Item: TBisTaskExecute;
begin
  Index:=-1;

  for i:=Count-1 downto 0 do begin
    Item:=Items[i];
    if HoursBetween(Item.DateBegin,Now)>=1 then begin
//    if SecondsBetween(Item.DateBegin,Now)>=10 then begin
      Index:=i-1;
      break;
    end;
  end;

  for i:=Index downto 0 do
    Delete(i);

end;

function TBisTaskExecutes.Exists(DateExecute: TDateTime; Offset: Integer): Boolean;
begin
  Result:=Assigned(Find(DateExecute,Offset));
end;

{ TBisTask }

constructor TBisTask.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIfaces:=TBisIfaces.Create(nil);
  FExecutes:=TBisTaskExecutes.Create;
  FExecutes.Delay:=999;

  FThread:=TBisTaskThread.Create;
  FThread.OnTimeout:=ThreadTimeout;
  FThread.OnEnd:=ThreadEnd;
  FThread.RestrictByZero:=false;

  FRunFlag:=false;
  FPriority:=tpNormal;
  FSchedule:=tscRun;
  FDateBegin:=Now;

  if Assigned(Core) then begin
    FAfterRunEvent:=Core.AfterRunEvents.Add(AfterRun,Self);
  end;
end;

destructor TBisTask.Destroy;
begin
  if Assigned(Core) then begin
    Core.AfterRunEvents.Remove(FAfterRunEvent);
  end;
  Stop;
  FThread.Free;
  FreeAndNilEx(FDataSet);
  FExecutes.Free;
  FIfaces.Free;
  inherited Destroy;
end;

procedure TBisTask.DoEnd;
begin
  if Assigned(FOnEnd) then
    FOnEnd(Self);
end;

procedure TBisTask.ThreadEnd(Thread: TBisThread);
begin
  Thread.Synchronize(DoEnd);
end;

procedure TBisTask.ThreadTimeout(Thread: TBisWaitThread);
begin
  Execute(TBisTaskThread(Thread));
end;

procedure TBisTask.AfterRun(Sender: TObject);
begin
  case FSchedule of
    tscRun: begin
      FRunFlag:=true;
      FDateBegin:=Now;
      Reset;
    end;
  end;
end;

function TBisTask.GetInterface: TBisInterface;
begin
  Result:=nil;
  if (Trim(FInterfaceID)<>'') and Assigned(Core) then
    Result:=Core.Interfaces.FindByID(FInterfaceID);
end;

function TBisTask.GetWaitInterval: Cardinal;
begin
  Result:=0;
end;

function TBisTask.GetWorking: Boolean;
begin
  Result:=FThread.Working; 
end;

procedure TBisTask.IfaceClassShow;
var
  AIface: TBisIface;
begin
  if Assigned(FIfaceClass) then begin
    AIface:=FIfaces.AddClass(FIfaceClass);
    if Assigned(AIface) then begin
      AIface.Init;
      AIface.LoadOptions;
      AIface.Show;
    end;
  end;
end;

procedure TBisTask.InterfaceShow;
var
  AInterface: TBisInterface;
begin
  AInterface:=GetInterface;
  if Assigned(AInterface) and not AInterface.IfaceWorking then begin
    AInterface.IfaceShow;
  end;
end;

procedure TBisTask.Execute(Thread: TBisTaskThread);

  function IDExists: Boolean;
  begin
    Result:=(Trim(FID)<>'');
  end;

  function ProcExists: Boolean;
  begin
    Result:=(Trim(FProcName)<>'');
  end;

  function TryConnection: Boolean;
  begin
    Result:=true;
    if DefaultExists then
      Result:=DefaultCheck;
  end;
  
  procedure ExecuteProc;
  begin
    if IDExists and ProcExists and DefaultExistsLogged and
       not Assigned(FDataSet) then begin

     FDataSet:=TBisDataSet.Create(Self);
     try
       FDataSet.ProviderName:=FProcName;
       with FDataSet.Params do begin
         Clear;
         AddInvisible(SFieldTaskId).Value:=FID;
         AddInvisible(SFieldAccountId).Value:=Core.AccountId;
       end;
       Core.Connection.Execute(Core.SessionId,FDataSet);
     finally
       FreeAndNilEx(FDataSet);
     end;

    end;
  end;

  procedure ExecuteCommand;
  var
    S: String;
    StartupInfo: TStartupInfo;
    ProcessInfo: TProcessInformation;
    Ret: Boolean;
  begin
    if Trim(FCommandString)<>'' then begin
      S:=FCommandString;
      FillChar(StartupInfo,SizeOf(TStartupInfo),0);
      with StartupInfo do begin
        cb:=SizeOf(TStartupInfo);
        wShowWindow:=SW_SHOWDEFAULT;
      end;
      Ret:=CreateProcess(nil,PChar(S),nil,nil,False,
                         NORMAL_PRIORITY_CLASS,nil,nil,StartupInfo, ProcessInfo);
      if not Ret then
        raise Exception.Create(SysErrorMessage(GetLastError));
    end;
  end;

  procedure ExecuteInterface;
  begin
    if Trim(FInterfaceID)<>'' then
      Thread.Synchronize(InterfaceShow);
  end;

  procedure ExecuteIfaceClass;
  begin
    if Assigned(FIfaceClass) then
      Thread.Synchronize(IfaceClassShow);
  end;

  procedure SaveTask;
  begin
    if IDExists and DefaultExistsLogged then begin
      try
        Core.Connection.SaveTask(Core.SessionId,Self);
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    end;
  end;

var
  Item: TBisTaskExecute;
begin
  if Assigned(Core) then begin
    Item:=FExecutes.Add(Now,FResultString,FRepeatExists,FDifference);
    try
      if TryConnection then begin
        try
          FResultString:='';
          if not Thread.Terminated then
            ExecuteProc;
          if not Thread.Terminated then
            ExecuteCommand;
          if not Thread.Terminated then
            ExecuteInterface;
          if not Thread.Terminated then
            ExecuteIfaceClass;
        except
          On E: Exception do begin
            LoggerWrite(E.Message,ltError);
            FResultString:=E.Message;
          end;
        end;
      end else
        DefaultLoginThreaded;
    finally
      Reset;
      FDateExecute:=Now;
      SaveTask;
      Item.DateEnd:=FDateExecute;
      FExecutes.DeletePrevious;
      FRunFlag:=false;
    end;
  end;
end;

function TBisTask.DateBeginWithOffset(var Delta: Integer): TDateTime;
begin
  Randomize;
  if Abs(FOffset)>0 then begin
    Delta:=RandomRange(0,Abs(FOffset));
    if FOffset<0 then
      Delta:=-Delta;
    Result:=IncSecond(FDateBegin,Delta)
  end else
    Result:=FDateBegin;
end;

procedure TBisTask.Reset;
var
  Delta: Integer;
begin
  Delta:=0;
  FRealDateBegin:=DateBeginWithOffset(Delta);
  FDifference:=Delta;
end;

function TBisTask.CanStart: Boolean;

  function EndExists(ADate: TDateTime): Boolean;
  begin
    Result:=false;
    if FDateEnd<>NullDate then
      Result:=ADate>FDateEnd;
  end;

  function RepeatExists(ANow, ADateBegin: TDateTime; WithDateEnd: Boolean): Boolean;
  var
    Def1, Def2: TDateTime;
    Flag: Boolean;
    Value: Integer;
    ModValue: Integer;
  begin
    Def1:=ANow;
    Result:=false;
    Flag:=FRepeatEnabled and (FRepeatValue>0);
    if Flag then begin
      Def2:=ADateBegin;
      Value:=0;
      case FRepeatType of
        trSecond: begin
          Value:=SecondsBetween(Def2,Def1);
          Def2:=IncSecond(Def2,Value);
        end;
        trMinute: begin
          Value:=MinutesBetween(Def2,Def1);
          Def2:=IncMinute(Def2,Value);
        end;
        trHour: begin
          Value:=HoursBetween(Def2,Def1);
          Def2:=IncHour(Def2,Value);
        end;
        trDay: begin
          Value:=DaysBetween(Def2,Def1);
          Def2:=IncDay(Def2,Value);
        end;
        trWeek: begin
          Value:=WeeksBetween(Def2,Def1);
          Def2:=IncWeek(Def2,Value);
        end;
        trMonth: begin
          Value:=MonthsBetween(Def2,Def1);
          Def2:=IncMonth(Def2,Value);
        end;
      end;
      ModValue:=(Value mod FRepeatValue);
      Result:=(Def2<=Def1) and (ModValue=0) and
              (IncMilliSecond(Def2,FExecutes.Delay)>Def1);
      if Result and (FRepeatCount>0) then begin
        if FRepeatValue>0 then
          Result:=(Value div FRepeatValue)<=FRepeatCount;
      end;
      if Result and WithDateEnd then
        Result:=not EndExists(Def2);
      if Result then
        FRepeatExists:=true;
    end;
  end;

  function RunExists: Boolean;
  var
    Def: TDateTime;
  begin
    Def:=Now;
    Result:=not FExecutes.Exists(Def,FOffset);
    if Result then begin
      Result:=FRunFlag;
      if not Result then
        Result:=RepeatExists(Def,FRealDateBegin,false);
    end;
  end;

  function OnceExists: Boolean;
  var
    Def: TDateTime;
  begin
    Def:=Now;
    Result:=not FExecutes.Exists(Def,FOffset);
    if Result then begin
      Result:=(FRealDateBegin<=Def) and (IncMilliSecond(FRealDateBegin,FExecutes.Delay)>Def);
      if not Result then
        Result:=RepeatExists(Def,FRealDateBegin,false);
    end;
  end;

  function EveryDayExists: Boolean;
  var
    Def1,Def2: TDateTime;
    Date1,Date2: TDateTime;
    Time1,Time2: TDateTime;
    Frequency: Integer;
    Days, ModDays: Integer;
    RepeatDate: TDateTime;
  begin
    Def1:=Now;
    Result:=not FExecutes.Exists(Def1,FOffset);
    if Result and (FDayFrequency>0) then begin
      Frequency:=FDayFrequency;
      Date1:=DateOf(Def1);
      Time1:=TimeOf(Def1);
      Def2:=FRealDateBegin;
      Date2:=DateOf(Def2);
      Time2:=TimeOf(Def2);
      Days:=DaysBetween(Def2,Def1);
      ModDays:=(Days mod Frequency);
      Result:=(Date2<=Date1) and (ModDays=0) and
              (Time2<=Time1) and (IncMilliSecond(Time2,FExecutes.Delay)>Time1);
      if Result then
        Result:=not EndExists(Def1)
      else begin
        RepeatDate:=IncDay(FRealDateBegin,Days);
        if (ModDays=0) then
          Result:=RepeatExists(Def1,RepeatDate,True);
      end;
    end;
  end;

  function EveryWeekExists: Boolean;

    function GetDayWeekFlag(D: TDateTime): Boolean;
    var
      DayWeek: Integer;
    begin
      Result:=false;
      DayWeek:=DayOfTheWeek(D);
      case DayWeek of
        1: Result:=FMonday;
        2: Result:=FTuesday;
        3: Result:=FWednesday;
        4: Result:=FThursday;
        5: Result:=FFriday;
        6: Result:=FSaturday;
        7: Result:=FSunday;
      end;
    end;

  var
    Def1,Def2: TDateTime;
    Date1,Date2: TDateTime;
    Time1,Time2: TDateTime;
    Frequency: Integer;
    Weeks, ModWeeks: Integer;
    RepeatDate: TDateTime;
    Days: Integer;
  begin
    Def1:=Now;
    Result:=not FExecutes.Exists(Def1,FOffset);
    if Result and (FWeekFrequency>0) then begin
      Frequency:=FWeekFrequency;
      Date1:=DateOf(Def1);
      Time1:=TimeOf(Def1);
      Def2:=FRealDateBegin;
      Date2:=DateOf(Def2);
      Time2:=TimeOf(Def2);
      Days:=DaysBetween(Def2,Def1);
      Weeks:=WeeksBetween(Def2,Def1);
      ModWeeks:=(Weeks mod Frequency);
      Result:=(Date2<=Date1) and GetDayWeekFlag(Def1) and (ModWeeks=0) and
              (Time2<=Time1) and (IncMilliSecond(Time2,FExecutes.Delay)>Time1);
      if Result then
        Result:=not EndExists(Def1)
      else begin
        RepeatDate:=IncDay(FRealDateBegin,(Days mod DaysPerWeek));
        RepeatDate:=IncWeek(RepeatDate,Weeks);
        if GetDayWeekFlag(RepeatDate) and (ModWeeks=0) then
          Result:=RepeatExists(Def1,RepeatDate,True);
      end;
    end;
  end;

  function EveryMonthExists: Boolean;

    function GetMonthYearFlag(D: TDateTime): Boolean;
    var
      MonthYear: Integer;
    begin
      Result:=false;
      MonthYear:=MonthOfTheYear(D);
      case MonthYear of
        1: Result:=FJanuary;
        2: Result:=FFebruary;
        3: Result:=FMarch;
        4: Result:=FApril;
        5: Result:=FMay;
        6: Result:=FJune;
        7: Result:=FJuly;
        8: Result:=FAugust;
        9: Result:=FSeptember;
        10: Result:=FOctober;
        11: Result:=FNovember;
        12: Result:=FDecember;
      end;
    end;

  var
    Def1,Def2: TDateTime;
    Date1,Date2: TDateTime;
    Time1,Time2: TDateTime;
    AMonthDay: Integer;
    RepeatDate: TDateTime;
    Months: Integer;
  begin
    Def1:=Now;
    Result:=not FExecutes.Exists(Def1,FOffset);
    if Result and (FMonthDay>0) then begin
      Date1:=DateOf(Def1);
      Time1:=TimeOf(Def1);
      Def2:=FRealDateBegin;
      Date2:=DateOf(Def2);
      Time2:=TimeOf(Def2);
      Months:=MonthsBetween(Def2,Def1);
      AMonthDay:=DayOfTheMonth(Def1);
      Result:=(Date2<=Date1) and GetMonthYearFlag(Def1) and (FMonthDay=AMonthDay) and
              (Time2<=Time1) and (IncMilliSecond(Time2,FExecutes.Delay)>Time1);
      if Result then
        Result:=not EndExists(Def1)
      else begin
        RepeatDate:=IncMonth(FRealDateBegin,(Months mod MonthsPerYear));
        if GetMonthYearFlag(RepeatDate) and (FMonthDay=DayOfTheMonth(RepeatDate)) then
          Result:=RepeatExists(Def1,RepeatDate,True);
      end;
    end;
  end;

begin
  Result:=Assigned(Core) and FEnabled;
  if Result then begin
    Result:=not FThread.Exists;
    if not Result then
      Result:=(FThread.Exists and (FThread.Suspended or FThread.Terminated));
  end;
  if Result then begin
    FRepeatExists:=false;
    case FSchedule of
      tscRun: Result:=RunExists;
      tscOnce: Result:=OnceExists;
      tscEveryDay: Result:=EveryDayExists;
      tscEveryWeek: Result:=EveryWeekExists;
      tscEveryMonth: Result:=EveryMonthExists;
    end;
  end;
end;

procedure TBisTask.Start(Wait: Boolean);
begin
  Stop;
  if CanStart then begin
    if FEnabled then begin
      FThread.Priority:=FPriority;
      FThread.Timeout:=GetWaitInterval;
      FThread.Start(Wait);
    end;
  end;
end;

procedure TBisTask.Stop;

  procedure DataSetCancel;
  begin
    if Assigned(Core) and Core.Logged and Assigned(FDataSet) then begin
      try
        Core.Connection.Cancel(Core.SessionId,FDataSet.CheckSum);
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    end;
  end;

begin
  if FThread.Working then
    DataSetCancel;
  FThread.Stop;
end;

procedure TBisTask.WriteData(Writer: TWriter);
begin
  Writer.WriteString(FID);
  Writer.WriteString(ObjectName);
  Writer.WriteString(Description);
  Writer.WriteBoolean(FEnabled);
  Writer.WriteInteger(Integer(FPriority));
  Writer.WriteInteger(Integer(FSchedule));
  Writer.WriteString(FInterfaceID);
  Writer.WriteString(FProcName);
  Writer.WriteString(FCommandString);
  Writer.WriteDate(FDateBegin);
  Writer.WriteInteger(FOffset);
  Writer.WriteDate(FDateEnd);
  Writer.WriteInteger(FDayFrequency);
  Writer.WriteInteger(FWeekFrequency);
  Writer.WriteBoolean(FMonday);
  Writer.WriteBoolean(FTuesday);
  Writer.WriteBoolean(FWednesday);
  Writer.WriteBoolean(FThursday);
  Writer.WriteBoolean(FFriday);
  Writer.WriteBoolean(FSaturday);
  Writer.WriteBoolean(FSunday);
  Writer.WriteInteger(FMonthDay);
  Writer.WriteBoolean(FJanuary);
  Writer.WriteBoolean(FFebruary);
  Writer.WriteBoolean(FMarch);
  Writer.WriteBoolean(FApril);
  Writer.WriteBoolean(FMay);
  Writer.WriteBoolean(FJune);
  Writer.WriteBoolean(FJuly);
  Writer.WriteBoolean(FAugust);
  Writer.WriteBoolean(FSeptember);
  Writer.WriteBoolean(FOctober);
  Writer.WriteBoolean(FNovember);
  Writer.WriteBoolean(FDecember);
  Writer.WriteBoolean(FRepeatEnabled);
  Writer.WriteInteger(FRepeatValue);
  Writer.WriteInteger(Integer(FRepeatType));
  Writer.WriteInteger(FRepeatCount);
  Writer.WriteDate(FDateExecute);
  Writer.WriteString(FResultString);
end;

procedure TBisTask.SaveToStream(Stream: TStream);
var
  Writer: TWriter;
begin
  Writer:=TWriter.Create(Stream,WriterBufferSize);
  try
    WriteData(Writer);
  finally
    Writer.Free;
  end;
end;

procedure TBisTask.ReadData(Reader: TReader);
begin
  FID:=Reader.ReadString;
  ObjectName:=Reader.ReadString;
  Description:=Reader.ReadString;
  FEnabled:=Reader.ReadBoolean;
  FPriority:=TBisTaskPriority(Reader.ReadInteger);
  FSchedule:=TBisTaskSchedule(Reader.ReadInteger);
  FInterfaceID:=Reader.ReadString;
  FProcName:=Reader.ReadString;
  FCommandString:=Reader.ReadString;
  FDateBegin:=Reader.ReadDate;
  FOffset:=Reader.ReadInteger;
  FDateEnd:=Reader.ReadDate;
  FDayFrequency:=Reader.ReadInteger;
  FWeekFrequency:=Reader.ReadInteger;
  FMonday:=Reader.ReadBoolean;
  FTuesday:=Reader.ReadBoolean;
  FWednesday:=Reader.ReadBoolean;
  FThursday:=Reader.ReadBoolean;
  FFriday:=Reader.ReadBoolean;
  FSaturday:=Reader.ReadBoolean;
  FSunday:=Reader.ReadBoolean;
  FMonthDay:=Reader.ReadInteger;
  FJanuary:=Reader.ReadBoolean;
  FFebruary:=Reader.ReadBoolean;
  FMarch:=Reader.ReadBoolean;
  FApril:=Reader.ReadBoolean;
  FMay:=Reader.ReadBoolean;
  FJune:=Reader.ReadBoolean;
  FJuly:=Reader.ReadBoolean;
  FAugust:=Reader.ReadBoolean;
  FSeptember:=Reader.ReadBoolean;
  FOctober:=Reader.ReadBoolean;
  FNovember:=Reader.ReadBoolean;
  FDecember:=Reader.ReadBoolean;
  FRepeatEnabled:=Reader.ReadBoolean;
  FRepeatValue:=Reader.ReadInteger;
  FRepeatType:=TBisTaskRepeat(Reader.ReadInteger);
  FRepeatCount:=Reader.ReadInteger;
  FDateExecute:=Reader.ReadDate;
  FResultString:=Reader.ReadString;
end;

procedure TBisTask.LoadFromStream(Stream: TStream);
var
  Reader: TReader;
begin
  Reader:=TReader.Create(Stream,ReaderBufferSize);
  try
    ReadData(Reader);
  finally
    Reader.Free;
  end;
end;


type
  TBisTasksThread=class(TBisWaitThread)
  end;

{ TBisTasks }

constructor TBisTasks.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled:=true;

  FLock:=TCriticalSection.Create;

  FThread:=TBisTasksThread.Create(1);
  FThread.OnTimeout:=ThreadTimeout;
  FThread.Priority:=tpTimeCritical;

end;

destructor TBisTasks.Destroy;
begin
  Stop;
  FThread.Free;
  FLock.Free;
  inherited Destroy;
end;

procedure TBisTasks.ThreadTimeout(Thread: TBisWaitThread);
var
  i: Integer;
  Task: TBisTask;
begin
  try
    for i:=0 to Count-1 do begin
      Task:=Items[i];
      if Task.Enabled then
        if Task.CanStart then
          Task.Start(false);
    end;
  finally
    Thread.Reset;
  end;
end;

procedure TBisTasks.InternalClear;
var
  i: Integer;
  Item: TBisTask;
begin
  FLock.Enter;
  try
    for i:=Count-1 downto 0 do begin
      Item:=Items[i];
      if Item.ClassType=TBisTask then
        Remove(Item);
    end;
  finally
    FLock.Leave;
  end;
end;

procedure TBisTasks.ResetTasks;
var
  i: Integer;
begin
  FLock.Enter;
  try
    for i:=0 to Count-1 do
      Items[i].Reset;
  finally
    FLock.Leave;
  end;
end;

function TBisTasks.Running: Boolean;
begin
  Result:=not FThread.Suspended;
end;

procedure TBisTasks.StopTasks;
var
  i: Integer;
begin
  FLock.Enter;
  try
    for i:=0 to Count-1 do
      Items[i].Stop;
  finally
    FLock.Leave;
  end;
end;

procedure TBisTasks.Start;
begin
  Stop;
  if FEnabled then begin
    ResetTasks;
    FThread.Start;
  end;
end;

procedure TBisTasks.Stop;
begin
  StopTasks;
  FThread.Stop;
end;

function TBisTasks.GetItem(Index: Integer): TBisTask;
begin
  Result:=TBisTask(inherited Items[Index]);
end;

function TBisTasks.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisTask;
end;

function TBisTasks.FindByID(ID: String): TBisTask;
var
  i: Integer;
  Item: TBisTask;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.ID,ID) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisTasks.Add(ID, ObjectName: String): TBisTask;
var
  AClass: TBisTaskClass;
begin
  Result:=FindByID(ID);
  if not Assigned(Result) then begin
    AClass:=TBisTaskClass(GetObjectClass);
    if Assigned(AClass) then begin
      Result:=AClass.Create(Self);
      Result.ID:=ID;
      Result.ObjectName:=ObjectName;
      AddObject(Result);
    end;
  end;
end;

function TBisTasks.AddClass(AClass: TBisTaskClass): TBisTask;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    Result:=AClass.Create(Self);
    if not Assigned(Find(Result.ObjectName)) then begin
      AddObject(Result);
    end else begin
      FreeAndNilEx(Result);
    end;
  end;
end;

function TBisTasks.AddTask(ATask: TBisTask): Boolean;
begin
  Result:=false;
  if Assigned(ATask) and not Assigned(Find(ATask.ObjectName)) then begin
    AddObject(ATask);
    Result:=true;
  end;
end;

procedure TBisTasks.WriteData(Writer: TWriter);
var
  i: Integer;
  Item: TBisTask;
begin
  Writer.WriteListBegin;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.ClassType=TBisTask then
      Item.WriteData(Writer);
  end;
  Writer.WriteListEnd;
end;

procedure TBisTasks.SaveToStream(Stream: TStream);
var
  Writer: TWriter;
begin
  Writer:=TWriter.Create(Stream,WriterBufferSize);
  try
    WriteData(Writer);
  finally
    Writer.Free;
  end;
end;

procedure TBisTasks.ReadData(Reader: TReader);
var
  Item: TBisTask;
  Flag: Boolean;
begin
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    Flag:=true;
    Item:=TBisTask.Create(nil);
    try
      Item.ReadData(Reader);
      if not Assigned(FindByID(Item.ID)) then
        Flag:=not AddTask(Item);
    finally
      if Flag then
        Item.Free;
    end;
  end;
  Reader.ReadListEnd;
end;

procedure TBisTasks.LoadFromStream(Stream: TStream);
var
  Reader: TReader;
begin
  Reader:=TReader.Create(Stream,ReaderBufferSize);
  try
    ReadData(Reader);
  finally
    Reader.Free;
  end;
end;

end.

