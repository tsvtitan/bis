unit UnitThreads;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Contnrs, SyncObjs,

  SqlExpr, StdCtrls, ExtCtrls, ComCtrls;

type
  TFormThreads=class;

  TConnectionThread=class(TThread)
  private
    FParent: TFormThreads;
    procedure UpdateCounters;
    procedure UpdateMissCounters;
  public
    procedure Execute; override;

    property Parent: TFormThreads read FParent write FParent;
  end;

  TConnectionMainThread=class(TThread)
  private
    FParent: TFormThreads;
    FCounter: Integer;
    FEvent: THandle;
    FInterval: Integer;
    FLastError: String;
    procedure UpdateCounters;
    procedure UpdateMissCounters;
  protected
    function GetWhile: Boolean; virtual;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    procedure Execute; override;

    property Parent: TFormThreads read FParent write FParent;
    property Event: THandle read FEvent write FEvent;
    property Interval: Integer read FInterval write FInterval;
    property LastError: String read FLastError; 
  end;

  TConnectionMainThreadOne=class(TConnectionMainThread)
  protected
    function GetWhile: Boolean; override;
  end;

  TAllThread=class(TThread)
  private
    FParent: TFormThreads;
    FThread: TConnectionMainThreadOne;
    procedure ThreadTerminate(Sender: TObject);
  public
    procedure Execute; override;
    destructor Destroy; override;

    property Parent: TFormThreads read FParent write FParent;
  end;

  TFormThreads = class(TForm)
    LabelThreadCount: TLabel;
    ButtonAdd: TButton;
    ButtonRemove: TButton;
    LabelMainExecuteCount: TLabel;
    LabelMainLockCount: TLabel;
    LabelThreadExecuteCount: TLabel;
    ButtonSuspend: TButton;
    LabelCurrentThread: TLabel;
    ButtonSuspendThreads: TButton;
    LabelInterval: TLabel;
    EditInterval: TEdit;
    UpDownInterval: TUpDown;
    ButtonExecute: TButton;
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonRemoveClick(Sender: TObject);
    procedure ButtonSuspendClick(Sender: TObject);
    procedure ButtonSuspendThreadsClick(Sender: TObject);
    procedure ButtonExecuteClick(Sender: TObject);
  private
    FLock: TRTLCriticalSection;
    FMainExecuteCount: Integer;
    FMainExecuteMissCount: Integer;
    FThreadExecuteCount: Integer;
    FThreadExecuteMissCount: Integer;
    FMainThread: TConnectionMainThread;
    FThreads: TThreadList;
//    FThread: TConnectionMainThreadOne;
    FThread: TAllThread;
    FConnection: TSQLConnection;
    procedure ThreadTerminate(Sender: TObject);
    procedure UpdateThreadCount;
    procedure UpdateMainLockCount;
    procedure UpdateMainExecuteCount;
    procedure UpdateThreadExecuteCount;
    procedure UpdateCurrentThread(Thread: TThread);
    procedure ClearThreads;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddThread;
    procedure RemoveThread;
    procedure Execute;
  end;

var
  FormThreads: TFormThreads;
  ListConnection: TObjectList;

implementation

{$R *.dfm}

uses WinSock;

function GetHostNameEx: String;
const
  WSVer = $101;
var
  wsaData: TWSAData;
  Buf: array [0..127] of Char;
begin
  Result := '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      Result:=Buf;
    end;
    WSACleanup;
  end;
end;

procedure GetStringsByString(const S,Delim: String; Strings: TStrings);
var
  Apos: Integer;
  S1,S2: String;
begin
  if Assigned(Strings) then begin
    Apos:=-1;
    S2:=S;
    while Apos<>0 do begin
      Apos:=AnsiPos(Delim,S2);
      if Apos>0 then begin
        S1:=Copy(S2,1,Apos-Length(Delim));
        S2:=Copy(S2,Apos+Length(Delim),Length(S2));
        if S1<>'' then
          Strings.AddObject(S1,TObject(Apos))
        else begin
          if Length(S2)>0 then
            APos:=-1;
        end;
      end else
        Strings.AddObject(S2,TObject(Apos));
    end;
  end;
end;

function GetDatabaseName: String;
var
  Str: TStringList;
begin
  Str:=TStringList.Create;
  try
//    Result:=ExtractFilePath(Application.ExeName)+'INTERBASE.IB';
    Result:=ExtractFilePath(Application.ExeName)+'FIREBIRD.FDB';
    GetStringsByString(Result,':',Str);
    if Str.Count<=2 then
      Result:=GetHostNameEx+':'+Result;
  finally
    Str.Free;
  end;
end;

function AddConnection(AOwner: TComponent): TSQLConnection;
begin
  Result:=TSQLConnection.Create(AOwner);
  with Result do begin
    LoadParamsOnConnect:=false;
    AutoClone:=false;

    DriverName := 'Interbase';
    GetDriverFunc := 'getSQLDriverINTERBASE';
    LibraryName := 'dbxint30.dll';
    VendorLib := 'gds32.dll';

{    DriverName:='Firebird';
    GetDriverFunc := 'getSQLDriverFIREBIRD';
    LibraryName := 'dbxfb40.dll';
    VendorLib := 'gds32.dll'; }

    Params.Add('User_Name=SYSDBA');
    Params.Add('Password=masterkey');
    Params.Add(Format('Database=%s',[GetDatabaseName]));
    Params.Add('RoleName=');
    Params.Add('ServerCharSet=');
    Params.Add('SQLDialect=3');
    Params.Add('BlobSize=-1');
    Params.Add('ErrorResourceFile=');
    Params.Add('LocaleCode=0000');
    Params.Add('CommitRetain=False');
    Params.Add('WaitOnLock=True');
    Params.Add('Interbase TransIsolation=ReadCommited');
    Params.Add('Trim Char=False');
    ParamsLoaded:=true;
    Open;
  end;
end;

procedure ExecuteSqlStoredProc(Connection: TSQLConnection);
var
  Proc: TSQLStoredProc;
  S: String;
begin
  if Connection.Connected then begin
    Proc:=TSQLStoredProc.Create(nil);
    try
      Proc.SQLConnection:=Connection;

      Proc.StoredProcName:='PROC_EMPTY';
      Proc.ExecProc;

      Proc.StoredProcName:='PROC_ONE_IN_PARAM';
      Proc.Params[0].AsString:='Hello';
      Proc.ExecProc;

      Proc.StoredProcName:='PROC_ONE_OUT_PARAM';
      Proc.ExecProc;
      S:=Proc.Params[0].AsString;
      if S<>'' then

      Proc.StoredProcName:='PROC_OUT_IN_PARAM';
      Proc.Params[0].AsString:='Hello';
      Proc.ExecProc;
      S:=Proc.Params[1].AsString;
      if S<>'' then

    finally
      Proc.Free;
    end;
  end;
end;

procedure ExecuteSqlQuery(Connection: TSQLConnection);
var
  Query: TSQLQuery;
begin
  if Connection.Connected then begin
    Query:=TSQLQuery.Create(nil);
    try
      Query.SQLConnection:=Connection;

      Query.SQL.Text:='SELECT * FROM TABLE_ONE_RECORD';
      Query.Open;

      Query.Close;
      Query.SQL.Text:='INSERT INTO TABLE_INSERT (ID) VALUES (1)';
      Query.ExecSQL;

      Query.SQL.Text:='UPDATE TABLE_UPDATE SET NAME=''Test'' WHERE ID=1';
      Query.ExecSQL;

      Query.SQL.Text:='DELETE FROM TABLE_DELETE WHERE ID=1';
      Query.ExecSQL;
    finally
      Query.Free;
    end;
  end;
end;

{ TConnectionThread }

procedure TConnectionThread.UpdateCounters;
begin
  if Assigned(FParent) then begin
    Inc(FParent.FThreadExecuteCount);
    FParent.UpdateThreadExecuteCount;
    FParent.UpdateCurrentThread(Self);
  end;
end;

procedure TConnectionThread.UpdateMissCounters;
begin
  if Assigned(FParent) then begin
    Inc(FParent.FThreadExecuteMissCount);
    FParent.UpdateThreadExecuteCount;
  end;
end;

procedure TConnectionThread.Execute;
begin
  while not Terminated do begin

    if Assigned(FParent) then begin

      EnterCriticalSection(FParent.FLock);
      try
        try
          ExecuteSqlStoredProc(FParent.FConnection);
          ExecuteSqlQuery(FParent.FConnection);
          Synchronize(UpdateCounters);
        except
          On E: Exception do begin

          end;
        end;
      finally
        LeaveCriticalSection(FParent.FLock);
      end;

      Sleep(FParent.UpDownInterval.Position);
    end;
  end;
end;

{ TConnectionMainThread }

constructor TConnectionMainThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FEvent:=CreateEvent(nil,false,false,nil);
end;

destructor TConnectionMainThread.Destroy;
begin
  SetEvent(FEvent);
  CloseHandle(FEvent);
  inherited Destroy;
end;

procedure TConnectionMainThread.UpdateCounters;
begin
  if Assigned(FParent) then begin
    Inc(FParent.FMainExecuteCount);
    FParent.UpdateMainExecuteCount;
    FParent.UpdateCurrentThread(Self);
  end;
end;

procedure TConnectionMainThread.UpdateMissCounters;
begin
  if Assigned(FParent) then begin
    Inc(FParent.FMainExecuteMissCount);
    FParent.UpdateMainExecuteCount;
  end;
end;

function TConnectionMainThread.GetWhile: Boolean;
begin
  Result:=not Terminated;
end;

procedure TConnectionMainThread.Execute;
begin
  FCounter:=0;
  while GetWhile do begin

    ResetEvent(FEvent);
    
    inc(FCounter);
    ReturnValue:=1;
    if Assigned(FParent) then begin

      EnterCriticalSection(FParent.FLock);
      try
        FLastError:='';
        try
          ExecuteSqlStoredProc(FParent.FConnection);
          ExecuteSqlQuery(FParent.FConnection);
          Sleep(FInterval);
          ReturnValue:=2;
          SetEvent(FEvent);
          Synchronize(UpdateCounters);
        except
          On E: Exception do begin
            FLastError:=E.Message;
            SetEvent(FEvent);
          end;
        end;
      finally
        LeaveCriticalSection(FParent.FLock);
      end;

      if GetWhile then
        Sleep(FParent.UpDownInterval.Position);
    end;
  end;
end;

{ TConnectionMainThreadOne }

function TConnectionMainThreadOne.GetWhile: Boolean;
begin
  Result:=FCounter<=0;
end;


{ TAllThread }

destructor TAllThread.Destroy;
begin
  if Assigned(FThread) then begin
    FThread.FreeOnTerminate:=false;
    FThread.Suspend;
    FThread.Free;
  end;

  inherited Destroy;
end;

procedure TAllThread.ThreadTerminate(Sender: TObject);
begin
 // FThread:=nil;
end;

procedure TAllThread.Execute;
begin
  while not Terminated do begin

    if Assigned(FParent) then begin

      FThread:=TConnectionMainThreadOne.Create(true);
      FThread.FreeOnTerminate:=true;
      FThread.Interval:=1;
      FThread.Parent:=FParent;
      FThread.OnTerminate:=ThreadTerminate;
      FThread.Resume;

      WaitForSingleObject(FThread.Event,INFINITE);

      if Assigned(FThread) then begin
        if FThread.LastError<>'' then ;
        if FThread.ReturnValue=2 then ;
      end;
    end;
  end;
end;

{ TFormThreads }

constructor TFormThreads.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);


  InitializeCriticalSection(FLock);
//  SetCriticalSectionSpinCount(FLock,100);
  FThreads:=TThreadList.Create;
  FConnection:=AddConnection(Self);

  FMainThread:=TConnectionMainThread.Create(true);
  FMainThread.Parent:=Self;
//  ButtonSuspend.Click;
end;

destructor TFormThreads.Destroy;
begin
  if Assigned(FThread) then begin
    FThread.FreeOnTerminate:=false;
    FThread.Suspend;
    FThread.Free;
  end;

  FMainThread.Free;

  ClearThreads;
  FThreads.Free;
  FConnection.Free;
  DeleteCriticalSection(FLock);

  inherited Destroy;
end;

procedure TFormThreads.ClearThreads;
var
  i: Integer;
  List: TList;
  Thread: TConnectionThread;
begin
  List:=FThreads.LockList;
  try
    for i:=0 to List.Count-1 do begin
      Thread:=TConnectionThread(List.Items[i]);
      Thread.Free;
    end;
  finally
    FThreads.UnlockList;
  end;
end;

procedure TFormThreads.UpdateCurrentThread(Thread: TThread);
var
  Index: Integer;
  List: TList;
begin
  List:=FThreads.LockList;
  try
    Index:=List.IndexOf(Thread);
    LabelCurrentThread.Caption:=Format('Current Thread Index: %d',[Index]);
    LabelCurrentThread.Update;
  finally
    FThreads.UnlockList;
  end;
end;

procedure TFormThreads.UpdateMainExecuteCount;
begin
  LabelMainExecuteCount.Caption:=Format('Main Execute Count (Miss): %d (%d)',[FMainExecuteCount,FMainExecuteMissCount]);
  LabelMainExecuteCount.Update;
end;

procedure TFormThreads.UpdateMainLockCount;
begin
  LabelMainLockCount.Caption:=Format('Main Lock Count: %d',[Abs(FLock.LockCount)]);
  LabelMainLockCount.Update;
end;

procedure TFormThreads.UpdateThreadCount;
var
  List: TList;
begin
  List:=FThreads.LockList;
  try
    LabelThreadCount.Caption:=Format('Thread count: %d',[List.Count]);
    LabelThreadCount.Update;
  finally
    FThreads.UnlockList;
  end;
end;

procedure TFormThreads.UpdateThreadExecuteCount;
begin
  LabelThreadExecuteCount.Caption:=Format('Thread Execute Count (Miss): %d (%d)',[FThreadExecuteCount,FThreadExecuteMissCount]);
  LabelThreadExecuteCount.Update;
end;

procedure TFormThreads.AddThread;
var
  Thread: TConnectionThread;
begin
  Thread:=TConnectionThread.Create(true);
  FThreads.Add(Thread);
  UpdateThreadCount;
  Thread.Parent:=Self;
  Thread.Resume;
end;

procedure TFormThreads.RemoveThread;
var
  Thread: TConnectionThread;
  List: TList;
begin
  List:=FThreads.LockList;
  try
    if List.Count>0 then begin
      Thread:=TConnectionThread(List[List.Count-1]);
      List.Remove(Thread);
      Thread.Free;
    end;
  finally
    FThreads.UnlockList;
  end;
  UpdateThreadCount;
end;

procedure TFormThreads.ButtonAddClick(Sender: TObject);
begin
  AddThread;
end;

procedure TFormThreads.ButtonExecuteClick(Sender: TObject);
begin
  Execute;
end;

procedure TFormThreads.ButtonSuspendClick(Sender: TObject);
begin
  FMainThread.Suspended:=not FMainThread.Suspended;
  if not FMainThread.Suspended then
    ButtonSuspend.Caption:='Suspend Main Thread'
  else
    ButtonSuspend.Caption:='Resume Main Thread';
end;

procedure TFormThreads.ButtonSuspendThreadsClick(Sender: TObject);
var
  i: Integer;
  List: TList;
  Thread: TConnectionThread;
begin
  List:=FThreads.LockList;
  try
    for i:=0 to List.Count-1 do begin
      Thread:=TConnectionThread(List[i]);
      Thread.Suspended:=not Thread.Suspended;
    end;

    if ButtonSuspendThreads.Caption='Suspend Threads' then
      ButtonSuspendThreads.Caption:='Resume Threads'
    else
      ButtonSuspendThreads.Caption:='Suspend Threads';

  finally
    FThreads.UnlockList;
  end;
end;

procedure TFormThreads.ButtonRemoveClick(Sender: TObject);
begin
  RemoveThread;
end;

procedure TFormThreads.ThreadTerminate(Sender: TObject);
begin
  FThread:=nil;
end;

procedure TFormThreads.Execute;
begin
  if Assigned(FThread) then begin
    FThread.FreeOnTerminate:=false;
    FThread.Suspend;
    FThread.Free;
  end;

//  FThread:=TConnectionMainThreadOne.Create(true);
  FThread:=TAllThread.Create(true);
  FThread.FreeOnTerminate:=true;
  FThread.Parent:=Self;
  FThread.OnTerminate:=ThreadTerminate;
//  FThread.Interval:=2000;
  FThread.Resume;

//  WaitForSingleObject(FThread.Event,INFINITE);
{  while Assigned(FThread) do
    Application.ProcessMessages;

  ShowMessage('Ok'); }
end;


initialization
  ListConnection:=TObjectList.Create;

finalization
  ListConnection.Free;

end.