unit BisProvider;

interface

uses Windows, SysUtils, Classes, DB, Controls, ExtCtrls, SyncObjs,
     BisDataSet, BisLogger, BisThreads;

type
  TBisProvider=class(TBisDataSet)
  private
    FDestroying: Boolean;
    FObjectName: String;
    FUseException: Boolean;
    FThreaded: Boolean;
    FThread: TBisThread;
    FCancelThread: TBisWaitThread;
    FOnThreadBegin: TNotifyEvent;
    FOnThreadEnd: TNotifyEvent;
    FSuccess: Boolean;
    FError: String;
    FPeriod: Int64;
    FOldScreenCursor: TCursor;
    FUseWaitCursor: Boolean;
    FUseShowError: Boolean;
    FUseShowWait: Boolean;
    FWaitForm: TComponent;
    FWaitTimeout: Integer;
    FWaitStatus: String;
    FWaitAsModal: Boolean;
    FWaitInterval: Integer;
    FWaitTimer: TTimer;
    FWaitPeriod: Int64;
    FWaitFreq: Int64;
    FMinWaitPeriod: Integer;
    FWorking: Boolean;

    procedure WaitShowTimer(Sender: TObject);
    procedure WaitHideTimer(Sender: TObject);
    procedure WaitFormCancel(Sender: TObject);
    procedure ThreadBegin(Thread: TBisThread);
    procedure ThreadWork(Thread: TBisThread);
    procedure ThreadEnd(Thread: TBisThread);
    procedure ThreadError(Thread: TBisThread; const E: Exception);
    procedure ThreadDestroy(Thread: TBisThread);
    procedure CancelThreadTimeout(Thread: TBisWaitThread);
    procedure DoThreadBegin;
    procedure DoThreadEnd;
    procedure SaveScreenCursor;
    procedure RestoreScreenCursor;
    procedure ShowWait;
    procedure UpdateWait(CanCancel: Boolean);
    procedure HideWait;
    function GetActive: Boolean;
  protected
    class function GetObjectName: String; virtual;
    procedure DoInternalOpen; override;
    procedure DoInternalClose; override;
    procedure DoInternalExecute; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoggerWrite(const Message: String; LogType: TBisLoggerType=ltInformation; const LoggerName: String=''); virtual;
    procedure Handle(DataSet: TBisDataSet); virtual;

    procedure Terminate;

    property Success: Boolean read FSuccess;
    property Error: String read FError;
    property Period: Int64 read FPeriod;
    property Active: Boolean read GetActive;
    property Working: Boolean read FWorking;

    property ObjectName: String read FObjectName write FObjectName;
    property Threaded: Boolean read FThreaded write FThreaded;
    property UseWaitCursor: Boolean read FUseWaitCursor write FUseWaitCursor;
    property UseShowError: Boolean read FUseShowError write FUseShowError;
    property UseShowWait: Boolean read FUseShowWait write FUseShowWait;
    property WaitTimeout: Integer read FWaitTimeout write FWaitTimeout;
    property WaitStatus: String read FWaitStatus write FWaitStatus;
    property WaitAsModal: Boolean read FWaitAsModal write FWaitAsModal;
    property WaitInterval: Integer read FWaitInterval write FWaitInterval;
    property MinWaitPeriod: Integer read FMinWaitPeriod write FMinWaitPeriod;

    property OnThreadBegin: TNotifyEvent read FOnThreadBegin write FOnThreadBegin;
    property OnThreadEnd: TNotifyEvent read FOnThreadEnd write FOnThreadEnd;

  end;

  TBisProviderClass=class of TBisProvider;

implementation

uses Variants, Forms,
     BisUtils, BisCore, BisDialogs, BisConnectionUtils,
     BisWaitFm;

type     
  TBisProviderThread=class(TBisThread)
  private
    FDataSet: TBisDataSet;
    FExecuting: Boolean;
    FInGetRecords: Boolean;
    FInExecute: Boolean;
    procedure GetDataSet(DS: TBisDataSet);
    procedure SetDataSet(DS: TBisDataSet);
    procedure CreateDataSet;
    procedure FreeDataSet;
  protected
    property Executing: Boolean read FExecuting;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

  TBisProviderOpenThread=class(TBisProviderThread)
  end;

  TBisProviderExecuteThread=class(TBisProviderThread)
  public
    constructor Create; override;
  end;

{ TBisProviderThread }

constructor TBisProviderThread.Create;
begin
  inherited Create;
  FDataSet:=nil;
end;

destructor TBisProviderThread.Destroy;
begin
  FreeDataSet;
  inherited Destroy;
end;

procedure TBisProviderThread.CreateDataSet;
begin
  FreeDataSet;
  FDataSet:=TBisDataSet.Create(nil);
end;

procedure TBisProviderThread.FreeDataSet;
begin
  if Assigned(FDataSet) then
    FreeAndNilEx(FDataSet);
end;

procedure TBisProviderThread.GetDataSet(DS: TBisDataSet);
begin
  if Assigned(FDataSet) and Assigned(DS) then begin

    if FExecuting then
      FDataSet.SetExecuteFrom(DS)
    else
      FDataSet.SetGetRecordsFrom(DS);

    FDataSet.InGetRecords:=FInGetRecords;
    FDataSet.InExecute:=FInExecute;
  end;
end;

procedure TBisProviderThread.SetDataSet(DS: TBisDataSet);
begin
  if Assigned(FDataSet) and Assigned(DS) then begin
    if FExecuting then
      DS.GetExecuteFrom(FDataSet)
    else
      DS.GetGetRecordsFrom(FDataSet);
  end;
end;

{ TBisProviderExecuteThread }

constructor TBisProviderExecuteThread.Create;
begin
  inherited Create;
  FExecuting:=true;
end;

{ TBisProvider }

constructor TBisProvider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FObjectName:=GetObjectName;
  FUseWaitCursor:=IsMainThread;
  FUseShowError:=IsMainThread;

  FCancelThread:=TBisWaitThread.Create(100);
  FCancelThread.OnTimeout:=CancelThreadTimeout;

  FUseShowWait:=false;
  FWaitAsModal:=false;
  FWaitTimeout:=10;
  FWaitTimer:=nil;
  FMinWaitPeriod:=500;
  FWorking:=false;
end;

destructor TBisProvider.Destroy;
begin
  HideWait;
  FCancelThread.Free;
  FreeAndNilEx(FThread);
  FDestroying:=true;
  inherited Destroy;
end;

function TBisProvider.GetActive: Boolean;
begin
  Result:=inherited Active and not FWorking;
end;

class function TBisProvider.GetObjectName: String;
begin
  Result:=GetNameByClass(ClassName);
end;

procedure TBisProvider.Handle(DataSet: TBisDataSet);
begin
  //
end;

procedure TBisProvider.LoggerWrite(const Message: String; LogType: TBisLoggerType; const LoggerName: String);
var
  S: String;
begin
  if Assigned(Core.Logger) then begin
    S:=LoggerName;
    if Trim(S)='' then
      S:=Self.ObjectName;
    Core.Logger.Write(Message,LogType,S);
  end;
end;

procedure TBisProvider.WaitFormCancel(Sender: TObject);
begin
  Terminate;
end;

procedure TBisProvider.WaitHideTimer(Sender: TObject);
begin
  if Assigned(FWaitTimer) then
    FreeAndNilEx(FWaitTimer);
  if Assigned(FWaitForm) then begin
    if FWaitAsModal and FThreaded then
      TBisWaitForm(FWaitForm).Close
    else
      FreeAndNilEx(FWaitForm);
  end;
end;

procedure TBisProvider.WaitShowTimer(Sender: TObject);

  function GetOwner: TComponent;
  var
    List: TList;
  begin
    List:=TList.Create;
    try
      Result:=Owner;
      while Assigned(Result) do begin
        if (Assigned(Result) and (Result is TForm)) or
           (List.IndexOf(Result)<>-1) then
          break;
        List.Add(Result);
        Result:=Owner.Owner;
      end;
    finally
      List.Free;
    end;
  end;

var
  Form: TBisWaitForm;
  FlagModal: Boolean;
  AOwner: TComponent;
begin
  if Assigned(FWaitTimer) then
    FreeAndNilEx(FWaitTimer);

  if not Assigned(FWaitForm) and Assigned(Core) and
     (Core.NoLogin or (not Core.NoLogin and Core.Logged)) and
     Assigned(Application) and not IsIconic(Application.Handle) then begin

    FlagModal:=FWaitAsModal and FThreaded;
    FWaitPeriod:=GetTickCount(FWaitFreq);

    AOwner:=GetOwner;

    Form:=TBisWaitForm.Create(AOwner);
    try
      FWaitForm:=Form;
      Form.Init;
      Form.Position:=poOwnerFormCenter;
      Form.FormStyle:=iff(FlagModal,fsNormal,fsStayOnTop);
      Form.Timeout:=FWaitTimeout;
      Form.OnCancel:=WaitFormCancel;
      Form.ButtonCancel.Enabled:=FThreaded;
      Form.LabelStatus.Caption:=FWaitStatus;

      if Assigned(AOwner) and (AOwner is TForm) then
        TForm(AOwner).Update;
      
      if FlagModal then
        Form.ShowModal
      else begin
        Form.Show;
        Form.Update;
      end;
    finally
      if FlagModal then begin
        Form.Free;
        FWaitForm:=nil;
      end;
    end;
  end;
end;

procedure TBisProvider.ShowWait;
begin
  HideWait;
  if FUseShowWait then begin
    if IsMainThread then begin
      if not FThreaded then begin
        WaitShowTimer(nil);
      end else begin
        FWaitTimer:=TTimer.Create(nil);
        FWaitTimer.OnTimer:=WaitShowTimer;
        FWaitTimer.Interval:=FWaitInterval;
        if FWaitTimer.Interval=0 then
          FWaitTimer.Interval:=1;
        FWaitTimer.Enabled:=true;
      end;
    end;
  end;
end;

procedure TBisProvider.UpdateWait(CanCancel: Boolean);
begin
  if IsMainThread then begin
    if Assigned(FWaitForm) then begin
      TBisWaitForm(FWaitForm).Timer.Enabled:=CanCancel;
      TBisWaitForm(FWaitForm).ButtonCancel.Enabled:=CanCancel;
      TBisWaitForm(FWaitForm).Update;
    end;
  end;
end;

procedure TBisProvider.HideWait;
var
  Interval: Cardinal;
  Diff: Int64;
begin
  if Assigned(FWaitTimer) then
    FreeAndNilEx(FWaitTimer);
  if IsMainThread then begin
    if Assigned(FWaitForm) then begin
      Diff:=GetTickDifference(FWaitPeriod,FWaitFreq,dtMilliSec);
      if FMinWaitPeriod<Diff then
        WaitHideTimer(nil)
      else begin
        Interval:=FMinWaitPeriod-Diff;

        FWaitTimer:=TTimer.Create(nil);
        FWaitTimer.OnTimer:=WaitHideTimer;
        FWaitTimer.Interval:=Interval;
        if FWaitTimer.Interval=0 then
          FWaitTimer.Interval:=1;
        FWaitTimer.Enabled:=true;
      end;
    end;
  end;
end;

procedure TBisProvider.SaveScreenCursor;
begin
  if FUseWaitCursor then begin
    FOldScreenCursor:=Screen.Cursor;
    Screen.Cursor:=crHourglass;
  end;
end;

procedure TBisProvider.RestoreScreenCursor;
begin
  if FUseWaitCursor then
    Screen.Cursor:=FOldScreenCursor;
end;

procedure TBisProvider.DoInternalClose;
begin
  inherited DoInternalClose;
  Terminate;
end;

procedure TBisProvider.DoInternalOpen;
var
  T,F: Int64;
begin
  FSuccess:=false;
  FError:='';
  FPeriod:=0;
  if not FThreaded then begin
    try
      ShowWait;
      SaveScreenCursor;
      FWorking:=true;
      T:=GetTickCount(F);
      try
        inherited DoInternalOpen;
        FSuccess:=DefaultGetRecords(Self);
      finally
        FPeriod:=GetTickDifference(T,F,dtMilliSec);
        FWorking:=false;
        RestoreScreenCursor;
        HideWait;
      end;
    except
      on E: Exception do begin
        if FUseShowError and IsMainThread then begin
          inherited Active:=false;
          FDuringAfterOpen:=true;
          ShowError(E.Message);
        end else
          raise;
      end;
    end;
  end else begin
    if (Trim(ProviderName)<>'') or (CollectionBefore.Count>0) or (CollectionAfter.Count>0) then begin
      inherited Active:=false;
      FDuringAfterOpen:=true;
    end else
      inherited InternalOpen;

    if not Assigned(FThread) then begin
      FWorking:=true;
      FUseException:=true;
      FThread:=TBisProviderOpenThread.Create;
      TBisProviderOpenThread(FThread).FInGetRecords:=InGetRecords;
      TBisProviderOpenThread(FThread).FInExecute:=InExecute;
      FThread.FreeOnEnd:=true;
      FThread.OnBegin:=ThreadBegin;
      FThread.OnWork:=ThreadWork;
      FThread.OnEnd:=ThreadEnd;
      FThread.OnError:=ThreadError;
      FThread.OnDestroy:=ThreadDestroy;
      FThread.Start;
    end;

  end;
end;

procedure TBisProvider.DoInternalExecute;
var
  T,F: Int64;
begin
  FSuccess:=false;
  FError:='';
  FPeriod:=0;
  if not FThreaded then begin
    try
      ShowWait;
      SaveScreenCursor;
      FWorking:=true;
      T:=GetTickCount(F);
      try
        inherited DoInternalExecute;
        FSuccess:=DefaultExecute(Self);
      finally
        FPeriod:=GetTickDifference(T,F,dtMilliSec);
        FWorking:=false;
        RestoreScreenCursor;
        HideWait;
      end;
    except
      on E: Exception do begin
        if FUseShowError and IsMainThread then begin
          ShowError(E.Message);
        end else
          raise;
      end;
    end;
  end else begin
    if not Assigned(FThread) then begin
      FWorking:=true;
      FUseException:=true;
      FThread:=TBisProviderExecuteThread.Create;
      TBisProviderExecuteThread(FThread).FInGetRecords:=InGetRecords;
      TBisProviderExecuteThread(FThread).FInExecute:=InExecute;
      FThread.FreeOnEnd:=true;
      FThread.OnBegin:=ThreadBegin;
      FThread.OnWork:=ThreadWork;
      FThread.OnEnd:=ThreadEnd;
      FThread.OnError:=ThreadError;
      FThread.OnDestroy:=ThreadDestroy;
      FThread.Start;
    end;
  end;
end;

procedure TBisProvider.DoThreadBegin;
begin
  try

    ShowWait;

    SaveScreenCursor;

    if Assigned(FThread) then
      TBisProviderThread(FThread).GetDataSet(Self);

    if Assigned(FOnThreadBegin) then
      FOnThreadBegin(Self);

  except
    on E: Exception do begin
      LoggerWrite(E.Message,ltError);
    end;
  end;
end;

procedure TBisProvider.DoThreadEnd;
begin
  try
    UpdateWait(false);

    if Assigned(FThread) then
      TBisProviderThread(FThread).SetDataSet(Self);

    RestoreScreenCursor;

    HideWait;

    if not FSuccess then begin
      if FUseShowError and FUseException then
        ShowError(FError)
    end;

    if Assigned(FOnThreadEnd) then
      FOnThreadEnd(Self);

  except
    on E: Exception do begin
      LoggerWrite(E.Message,ltError);
    end;
  end;
end;

procedure TBisProvider.Terminate;
begin
  if not FDestroying and FWorking then begin
    FUseException:=false;
    if FThreaded and Assigned(FThread) then begin
      FThread.Terminate;
      FCancelThread.Start;
    end else
      DefaultCancel(Self);
  end;
end;

procedure TBisProvider.ThreadBegin(Thread: TBisThread);
begin
  TBisProviderThread(Thread).CreateDataSet;
  Thread.Synchronize(DoThreadBegin);
end;

procedure TBisProvider.ThreadWork(Thread: TBisThread);
var
  AThread: TBisProviderThread;
begin
  AThread:=TBisProviderThread(Thread);
  if AThread.Executing then
    FSuccess:=DefaultExecute(AThread.FDataSet)
  else
    FSuccess:=DefaultGetRecords(AThread.FDataSet);
end;

procedure TBisProvider.ThreadEnd(Thread: TBisThread);
begin
  try
    FPeriod:=Thread.WorkPeriod;
    FWorking:=false;
    Thread.Synchronize(DoThreadEnd);
  finally
    TBisProviderThread(Thread).FreeDataSet;
  end;
end;

procedure TBisProvider.ThreadError(Thread: TBisThread; const E: Exception);
var
  ASuccess: Boolean;
begin
  if FWorking then begin
    ASuccess:=FSuccess;
    FSuccess:=false;
    if FUseException and Assigned(E) then begin
      inherited Active:=false;
      if not TBisProviderThread(FThread).Executing then
        FDuringAfterOpen:=true;
      FError:=E.Message;
    end else
      FSuccess:=ASuccess;
  end;
end;

procedure TBisProvider.ThreadDestroy(Thread: TBisThread);
begin
  if Thread=FThread then
    FThread:=nil;
end;

procedure TBisProvider.CancelThreadTimeout(Thread: TBisWaitThread);
begin
  try
    DefaultCancel(Self);
  except
    //
  end;
end;

end.
