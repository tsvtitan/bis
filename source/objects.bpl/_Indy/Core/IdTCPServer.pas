{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  12002: IdTCPServer.pas
{
{   Rev 1.66    10/8/2004 10:11:02 PM  BGooijen
{ uncommented intercept code
}
{
{   Rev 1.65    2004.08.13 10:55:38  czhower
{ Removed IFDEF
}
{
{   Rev 1.64    08.08.2004 10:43:10  OMonien
{ temporary Thread.priority fix for Kylix
}
{
{   Rev 1.63    6/11/2004 12:41:52 PM  JPMugaas
{ Reuse Address now reenabled.
}
{
    Rev 1.62    6/1/2004 1:22:28 PM  DSiders
  Added TODO for TerminateWaitTimeout.
}
{
{   Rev 1.61    28/04/2004 15:54:40  HHariri
{ Changed thread priority for scheduler
}
{
{   Rev 1.60    2004.04.22 11:44:48 PM  czhower
{ Boosted thread priority of listener thread.
}
{
{   Rev 1.59    2004.03.06 10:40:34 PM  czhower
{ Changed IOHandler management to fix bug in server shutdowns.
}
{
{   Rev 1.58    2004.03.01 5:12:40 PM  czhower
{ -Bug fix for shutdown of servers when connections still existed (AV)
{ -Implicit HELP support in CMDserver
{ -Several command handler bugs
{ -Additional command handler functionality.
}
{
{   Rev 1.57    2004.02.03 4:16:56 PM  czhower
{ For unit name changes.
}
{
{   Rev 1.56    2004.01.20 10:03:36 PM  czhower
{ InitComponent
}
{
{   Rev 1.55    1/3/2004 11:49:30 PM  BGooijen
{ the server creates a default binding for IPv6 now too, if IPv6 is supported
}
{
{   Rev 1.54    2003.12.28 8:04:54 PM  czhower
{ Shutdown fix for .net.
}
{
{   Rev 1.53    2003.11.29 6:03:46 PM  czhower
{ Active = True now works when set at design time.
}
{
{   Rev 1.52    2003.10.21 12:19:02 AM  czhower
{ TIdTask support and fiber bug fixes.
}
{
{   Rev 1.51    2003.10.18 9:33:30 PM  czhower
{ Boatload of bug fixes to command handlers.
}
{
{   Rev 1.50    2003.10.18 8:04:28 PM  czhower
{ Fixed bug with setting active at design time.
}
{
    Rev 1.49    10/15/2003 11:10:00 PM  DSiders
  Added localization comments.
  Added resource srting for exception raised in TIdTCPServer.SetScheduler.
}
{
{   Rev 1.48    2003.10.15 4:34:38 PM  czhower
{ Bug fix for shutdown.
}
{
{   Rev 1.47    2003.10.14 11:18:12 PM  czhower
{ Fix for AV on shutdown and other bugs
}
{
{   Rev 1.46    2003.10.11 5:51:38 PM  czhower
{ -VCL fixes for servers
{ -Chain suport for servers (Super core)
{ -Scheduler upgrades
{ -Full yarn support
}
{
{   Rev 1.45    10/5/2003 9:55:26 PM  BGooijen
{ TIdTCPServer works on D7 and DotNet now
}
{
{   Rev 1.44    10/5/2003 03:07:48 AM  JPMugaas
{ Should compile.
}
{
{   Rev 1.43    2003.10.01 9:11:28 PM  czhower
{ .Net
}
{
{   Rev 1.42    2003.09.30 1:23:08 PM  czhower
{ Stack split for DotNet
}
{
{   Rev 1.41    2003.09.19 10:11:22 PM  czhower
{ Next stage of fiber support in servers.
}
{
{   Rev 1.40    2003.09.19 11:54:34 AM  czhower
{ -Completed more features necessary for servers
{ -Fixed some bugs
}
{
{   Rev 1.39    2003.09.18 4:43:18 PM  czhower
{ -Removed IdBaseThread
{ -Threads now have default names
}
{
    Rev 1.37    7/6/2003 8:04:10 PM  BGooijen
  Renamed IdScheduler* to IdSchedulerOf*
}
{
{   Rev 1.36    2003.06.30 9:41:06 PM  czhower
{ Fix for AV during server shut down.
}
{
    Rev 1.35    6/25/2003 3:57:58 PM  BGooijen
  Disconnecting the context is now inside try...except
}
{
    Rev 1.34    6/8/2003 2:13:02 PM  BGooijen
  Made ContextClass public
}
{
    Rev 1.33    6/5/2003 12:43:26 PM  BGooijen
  changed short circuit fix code
}
{
{   Rev 1.32    2003.06.04 10:14:08 AM  czhower
{ Removed short circuit dependency and fixed some older irrelevant code.
}
{
    Rev 1.31    6/3/2003 11:49:38 PM  BGooijen
  removed AV in TIdTCPServer.DoExecute (hopefully)
}
{
{   Rev 1.30    5/26/2003 04:29:58 PM  JPMugaas
{ Removed GenerateReply and ParseReply.  Those are now obsolete duplicate
{ functions in the new design.
}
{
{   Rev 1.29    2003.05.26 10:35:26 PM  czhower
{ Fixed spelling typo.
}
{
{   Rev 1.28    5/26/2003 12:20:00 PM  JPMugaas
}
{
{   Rev 1.27    2003.05.26 11:38:22 AM  czhower
}
{
{   Rev 1.26    5/25/2003 03:38:04 AM  JPMugaas
}
{
{   Rev 1.25    5/25/2003 03:26:38 AM  JPMugaas
}
{
    Rev 1.24    5/20/2003 12:43:52 AM  BGooijen
  changeable reply types
}
{
    Rev 1.23    5/13/2003 2:56:40 PM  BGooijen
  changed GetGreating to SendGreeting
}
{
    Rev 1.21    4/4/2003 8:09:46 PM  BGooijen
  moved some consts tidcmdtcpserver, changed DoExecute to return
  .connection.connected
}
{
    Rev 1.20    3/25/2003 9:04:06 PM  BGooijen
  Scheduler in IOHandler is now updated when the scheduler is removed
}
{
    Rev 1.19    3/23/2003 11:33:34 PM  BGooijen
  Updates the scheduler in the iohandler when scheduler/iohandler is changed
}
{
    Rev 1.18    3/22/2003 11:44:08 PM  BGooijen
  ServerIntercept now logs connects/disconnects
}
{
    Rev 1.17    3/22/2003 1:46:02 PM  BGooijen
  Better handling of exceptions in TIdListenerThread.Run (could cause mem leaks
  first (in non-paged-memory))
}
{
    Rev 1.16    3/21/2003 5:55:54 PM  BGooijen
  Added code for serverIntercept
}
{
{   Rev 1.15    3/21/2003 11:44:00 AM  JPMugaas
{ Updated with a OnBeforeConnect event for the TIdMappedPort components.
}
{
    Rev 1.14    3/20/2003 12:18:32 PM  BGooijen
  Moved ReplyExceptionCode from TIdTCPServer to TIdCmdTCPServer
}
{
    Rev 1.13    3/13/2003 10:18:26 AM  BGooijen
  Server side fibers, bug fixes
}
{
{   Rev 1.12    2003.02.18 5:52:16 PM  czhower
{ Fix for warnings and logic error.
}
{
    Rev 1.11    1/23/2003 8:33:16 PM  BGooijen
}
{
    Rev 1.10    1/23/2003 11:05:48 AM  BGooijen
}
{
    Rev 1.9    1/20/2003 12:50:44 PM  BGooijen
  Added a Contexts propperty, which contains all contexts for that server
  Moved the commandhandlers to TIdCmdTCPServer
}
{
{   Rev 1.8    1-18-2003 0:00:30  BGooijen
{ Removed TIdContext.OnCreate
{ Added ContextCreated
}
{
{   Rev 1.7    1-17-2003 23:44:32  BGooijen
{ added support code for TIdContext.OnCreate
}
{
{   Rev 1.6    1-17-2003 22:22:10  BGooijen
{ new design
}
{
{   Rev 1.5    1-10-2003 23:59:22  BGooijen
{ Connection is now freed in destructor of TIdContext
}
{
{   Rev 1.4    1-10-2003 19:46:22  BGooijen
{ The context was not freed, now it is
}
{
{   Rev 1.3    1-9-2003 11:52:28  BGooijen
{ changed construction of TIdContext to Create(AServer: TIdTCPServer)
{ added TIdContext property .Server
}
{
{   Rev 1.2    1-3-2003 19:05:56  BGooijen
{ added FContextClass:TIdContextClass to TIdTcpServer
{ added Data:TObject to TIdContext
}
{
{   Rev 1.1    1-1-2003 16:42:10  BGooijen
{ Changed TIdThread to TIdYarn
{ Added TIdContext
}
{
{   Rev 1.0    11/13/2002 09:00:42 AM  JPMugaas
}
{
Original Author and Maintainer:
 - Chad Z. Hower a.k.a Kudzu
2002-01-01 - Andrew P.Rybin
 - bug fix (MaxConnections, SetActive(FALSE)), TerminateListenerThreads, DoExecute
2002-04-17 - Andrew P.Rybin
 - bug fix: if exception raised in OnConnect, Threads.Remove and ThreadMgr.ReleaseThread are not called
}

unit IdTCPServer;

interface

uses
  Classes, SysUtils,
  IdComponent,IdContext, IdGlobal, IdException,
  IdIntercept, IdIOHandler, IdIOHandlerStack,
  IdReply, IdScheduler, IdSchedulerOfThread, IdServerIOHandler,
  IdServerIOHandlerStack, IdSocketHandle, IdStackConsts, IdTCPConnection,
  IdThread, IdYarn;

const
  IdListenQueueDefault = 15;

type
  TIdTCPServer = class;

  // This is the thread that listens for incoming connections and spawns
  // new ones to handle each one
  TIdListenerThread = class(TIdThread)
  protected
    FBinding: TIdSocketHandle;
    FServer: TIdTCPServer;
    FOnBeforeRun: TIdNotifyThreadEvent;
    //
    procedure AfterRun; override;
    procedure BeforeRun; override;
    procedure Run; override;
  public
    constructor Create(AServer: TIdTCPServer; ABinding: TIdSocketHandle); reintroduce;
    //
    property Binding: TIdSocketHandle read FBinding write FBinding;
    property Server: TIdTCPServer read FServer;
    property OnBeforeRun: TIdNotifyThreadEvent read FOnBeforeRun write FOnBeforeRun;
  End;

  TIdListenExceptionEvent = procedure(AThread: TIdListenerThread; AException: Exception) of object;
  TIdServerThreadExceptionEvent = procedure(AContext:TIdContext; AException: Exception) of object;
  TIdServerThreadEvent = procedure(AContext:TIdContext) of object;

  TIdTCPServer = class(TIdComponent)
  protected
    FActive: Boolean;
    FScheduler: TIdScheduler;
    FBindings: TIdSocketHandles;
    FContextClass: TIdContextClass;
    FImplicitScheduler: Boolean;
    FImplicitIOHandler: Boolean;
    FIntercept: TIdServerIntercept;
    FIOHandler: TIdServerIOHandler;
    FListenerThreads: TThreadList;
    FListenQueue: integer;
    FMaxConnections: Integer;
    FReuseSocket: TIdReuseSocket;
    FTerminateWaitTime: Integer;
    FContexts: TThreadList;
    FOnBeforeConnect: TIdServerThreadEvent;
    FOnConnect: TIdServerThreadEvent;
    FOnDisconnect: TIdServerThreadEvent;
    FOnException: TIdServerThreadExceptionEvent;
    FOnExecute: TIdServerThreadEvent;
    FOnListenException: TIdListenExceptionEvent;
    FOnAfterBind: TNotifyEvent;
    FOnBeforeListenerRun: TIdNotifyThreadEvent;
    //
    procedure CheckActive;
    procedure ContextCreated(AContext:TIdContext); virtual;
    procedure DoAfterBind; virtual;
    procedure DoBeforeConnect(AContext:TIdContext); virtual;
    procedure DoConnect(AContext: TIdContext); virtual;
    procedure DoDisconnect(AContext: TIdContext); virtual;
    procedure DoException(AContext: TIdContext; AException: Exception);
    function DoExecute(AContext: TIdContext): Boolean; virtual;
    procedure DoListenException(
      AThread: TIdListenerThread;
      AException: Exception);
    procedure DoMaxConnectionsExceeded(
      AIOHandler: TIdIOHandler
      ); virtual;
    function GetDefaultPort: TIdPort;
    procedure InitComponent; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
     override;
    // This is needed for POP3's APOP authentication.  For that,
    // you send a unique challenge to the client dynamically.
    procedure SendGreeting(AContext: TIdContext; AGreeting: TIdReply); virtual;
    procedure SetActive(AValue: Boolean); virtual;
    procedure SetBindings(const AValue: TIdSocketHandles); virtual;
    procedure SetDefaultPort(const AValue: TIdPort); virtual;
    procedure SetIntercept(const AValue: TIdServerIntercept); virtual;
    procedure SetIOHandler(const AValue: TIdServerIOHandler); virtual;
    procedure SetScheduler(const AValue: TIdScheduler); virtual;
    procedure Startup; virtual;
    procedure Shutdown; virtual;
    procedure TerminateAllThreads;
    procedure TerminateListenerThreads;
  public
    destructor Destroy; override;
    //
    property Contexts: TThreadList read FContexts;
    property ContextClass:TIdContextClass read FContextClass write FContextClass;
    property ImplicitIOHandler: Boolean read FImplicitIOHandler;
    property ImplicitScheduler: Boolean read FImplicitScheduler;
  published
    property Active: Boolean read FActive write SetActive default False;
    property Bindings: TIdSocketHandles read FBindings write SetBindings;
    property DefaultPort: TIdPort read GetDefaultPort write SetDefaultPort;
    property Intercept: TIdServerIntercept read FIntercept write SetIntercept;
    property IOHandler: TIdServerIOHandler read FIOHandler write SetIOHandler;
    property ListenQueue: integer read FListenQueue write FListenQueue default IdListenQueueDefault;
    property MaxConnections: Integer read FMaxConnections write FMaxConnections default 0;
    // right after binding all sockets
    property OnAfterBind: TNotifyEvent read FOnAfterBind write FOnAfterBind;
    property OnBeforeListenerRun: TIdNotifyThreadEvent read FOnBeforeListenerRun write FOnBeforeListenerRun;
    property OnBeforeConnect: TIdServerThreadEvent read
       FOnBeforeConnect write FOnBeforeConnect;
    // Occurs in the context of the peer thread
    property OnConnect: TIdServerThreadEvent read FOnConnect write FOnConnect;
    // Occurs in the context of the peer thread
    property OnExecute: TIdServerThreadEvent read FOnExecute write FOnExecute;
    // Occurs in the context of the peer thread
    property OnDisconnect: TIdServerThreadEvent read FOnDisconnect write FOnDisconnect;
    // Occurs in the context of the peer thread
    property OnException: TIdServerThreadExceptionEvent read FOnException write FOnException;
    property OnListenException: TIdListenExceptionEvent read FOnListenException
      write FOnListenException;
    property ReuseSocket: TIdReuseSocket read FReuseSocket write FReuseSocket default rsOSDependent;
    property TerminateWaitTime: Integer read FTerminateWaitTime
     write FTerminateWaitTime default 5000;
    property Scheduler: TIdScheduler read FScheduler write SetScheduler;
  end;
  EIdTCPServerError = class(EIdException);
  EIdNoExecuteSpecified = class(EIdTCPServerError);
  EIdTerminateThreadTimeout = class(EIdTCPServerError);

implementation

uses
  IdGlobalCore,
  IdResourceStringsCore, IdReplyRFC,
  IdSchedulerOfThreadDefault, IdStack,
  IdThreadSafe;

{ TIdTCPServer }

procedure TIdTCPServer.CheckActive;
begin
  if Active and (not (csDesigning in ComponentState)) and (not (csLoading in ComponentState))
    then begin
    raise EIdTCPServerError.Create(RSCannotPerformTaskWhileServerIsActive);
  end;
end;

procedure TIdTcpServer.ContextCreated(AContext:TIdContext);
begin
//
end;

destructor TIdTCPServer.Destroy;
begin
  Active := False;

  if (FIOHandler <> nil) and FImplicitIOHandler then begin
    FreeAndNil(FIOHandler);
  end;

  // Destroy bindings first
  FreeAndNil(FBindings);
  //
  FreeAndNil(FContexts);
  inherited;
end;

procedure TIdTCPServer.DoAfterBind;
begin
  if Assigned(FOnAfterBind) then begin
    FOnAfterBind(Self);
  end;
end;

procedure TIdTCPServer.SendGreeting(AContext: TIdContext; AGreeting: TIdReply);
begin
  AContext.Connection.IOHandler.Write(AGreeting.FormattedReply);
end;

procedure TIdTCPServer.DoConnect(AContext: TIdContext);
begin
  if Assigned(Intercept) then begin
    AContext.Connection.IOHandler.Intercept := Intercept.Accept(
      AContext.Connection);
    if Assigned(AContext.Connection.IOHandler.Intercept) then begin
      AContext.Connection.IOHandler.Intercept.Connect(AContext.Connection);
   end;
  end;
  if Assigned(OnConnect) then begin
    OnConnect(AContext);
  end;
end;

procedure TIdTCPServer.DoDisconnect(AContext: TIdContext);
begin
  if Assigned(OnDisconnect) then begin
    OnDisconnect(AContext);
  end;
  if Assigned(Intercept) then begin
    if Assigned(AContext.Connection.IOHandler) then begin
      if Assigned(AContext.Connection.IOHandler.Intercept) then begin
        AContext.Connection.IOHandler.Intercept.DisConnect;
        AContext.Connection.IOHandler.Intercept.free;
        AContext.Connection.IOHandler.Intercept:=nil;
      end;
    end;
  end;
end;

procedure TIdTCPServer.DoException(AContext: TIdContext; AException: Exception);
begin
  if Assigned(OnException) then begin
    OnException(AContext, AException);
  end;
end;

function TIdTCPServer.DoExecute(AContext: TIdContext): Boolean;
begin
  if Assigned(OnExecute) then begin
    OnExecute(AContext);
  end;
  Result := False;
  if AContext <> nil then begin
    if AContext.Connection <> nil then begin
      Result := AContext.Connection.Connected;
    end;
  end;
end;

procedure TIdTCPServer.DoListenException(AThread: TIdListenerThread; AException: Exception);
begin
  if Assigned(FOnListenException) then begin
    FOnListenException(AThread, AException);
  end;
end;

function TIdTCPServer.GetDefaultPort: TIdPort;
begin
  Result := FBindings.DefaultPort;
end;

procedure TIdTCPServer.Loaded;
begin
  inherited Loaded;
  // Active = True must not be performed before all other props are loaded
  if Active then begin
    FActive := False;
    Active := True;
  end;
end;

procedure TIdTCPServer.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  // Remove the reference to the linked components if they are deleted
  if (Operation = opRemove) then begin
    if AComponent = Scheduler then begin
      TerminateAllThreads;
      Scheduler := nil;
    end else if AComponent = FIntercept then begin
      FIntercept := nil;
    end else if AComponent = FIOHandler then begin
      FIOHandler := nil;
    end;
  end;
end;

procedure TIdTCPServer.SetActive(AValue: Boolean);
begin
   // At design time we just set the value and save it for run time
  if (csDesigning in ComponentState)
   // During loading we ignore it till all other properties are set. Loaded
   // will recall it to toggle it
   or (csLoading in ComponentState)
   then begin
    FActive := AValue;
  end else if FActive <> AValue then begin
    if AValue then begin
      Startup;
    end else begin
      Shutdown;
    end;
  end;
end;

procedure TIdTCPServer.SetBindings(const AValue: TIdSocketHandles);
begin
  FBindings.Assign(AValue);
end;

procedure TIdTCPServer.SetDefaultPort(const AValue: TIdPort);
begin
  FBindings.DefaultPort := AValue;
end;

procedure TIdTCPServer.SetIntercept(const AValue: TIdServerIntercept);
begin
  FIntercept := AValue;
  // Add self to the intercept's notification list
  if Assigned(FIntercept) then begin
    FIntercept.FreeNotification(Self);
  end;
end;

procedure TIdTCPServer.SetScheduler(const AValue: TIdScheduler);
var
  LScheduler: TIdScheduler;
begin
  EIdException.IfTrue(Active, RSTCPServerSchedulerAlreadyActive);

  // If implicit one already exists free it
  // Free the default Thread manager
  if ImplicitScheduler then begin
    // Under D8 notification gets called after .Free of FreeAndNil, but before
    // its set to nil with a side effect of IDisposable. To counteract this we
    // set it to nil first.
    // -Kudzu
    LScheduler := FScheduler;
    FScheduler := nil;
    FreeAndNil(LScheduler);
    //
    FImplicitScheduler := False;
  end;

  FScheduler := AValue;
  // Ensure we will be notified when the component is freed, even is it's on
  // another form
  if AValue <> nil then begin
    AValue.FreeNotification(self);
  end;
  if FIOHandler <> nil then begin
    FIOHandler.SetScheduler(FScheduler);
  end;
end;

procedure TIdTCPServer.SetIOHandler(const AValue: TIdServerIOHandler);
begin
  if Assigned(FIOHandler) and FImplicitIOHandler then begin
    FImplicitIOHandler := false;
    FreeAndNil(FIOHandler);
  end;
  FIOHandler := AValue;
  if AValue <> nil then begin
    AValue.FreeNotification(self);
  end;
  if FIOHandler <> nil then begin
    FIOHandler.SetScheduler(FScheduler);
  end;
end;

//APR-011207: for safe-close Ex: SQL Server ShutDown 1) stop listen 2) wait until all clients go out
procedure TIdTCPServer.TerminateListenerThreads;
var
  i: Integer;
  LListenerThread: TIdListenerThread;
  LListenerThreads: TList;
Begin
  if FListenerThreads <> nil then begin
    LListenerThreads := FListenerThreads.LockList; try
      for i:= 0 to LListenerThreads.Count - 1 do begin
        LListenerThread := TIdListenerThread(LListenerThreads[i]);
        with LListenerThread do begin
          // Stop listening
          Terminate;
          Binding.CloseSocket;
          // Tear down Listener thread
          WaitFor;
          Free;
        end;
      end;
    finally FListenerThreads.UnlockList; end;
    FreeAndNil(FListenerThreads);
  end;
end;

procedure TIdTCPServer.TerminateAllThreads;
var
  i: Integer;
begin
  // TODO:  reimplement support for TerminateWaitTimeout

  //BGO: find out why TerminateAllThreads is sometimes called multiple times
  //Kudzu: Its because of notifications. It calls shutdown when the Scheduler is
  // set to nil and then again on destroy.
  if Contexts <> nil then begin
    with Contexts.LockList do try
      for i := 0 to Count - 1 do begin
        // Dont call disconnect with true. Otheriwse it frees the IOHandler and the thread
        // is still running which often causes AVs and other.
        TIdContext(Items[i]).Connection.Disconnect(False);
      end;
    finally Contexts.UnLockList; end;
  end;

  // Scheduler may be nil during destroy which calls TerminateAllThreads
  // This happens with explicit schedulers
  if Scheduler <> nil then begin
    Scheduler.TerminateAllYarns;
  end;
end;

procedure TIdTCPServer.DoBeforeConnect(AContext: TIdContext);
begin
  if Assigned(OnBeforeConnect) then begin
    OnBeforeConnect(AContext);
  end;
end;

procedure TIdTCPServer.DoMaxConnectionsExceeded(
  AIOHandler: TIdIOHandler
  );
begin
end;

procedure TIdTCPServer.InitComponent;
begin
  inherited;
  FBindings := TIdSocketHandles.Create(Self);
  FContexts := TThreadList.Create;
  FContextClass := TIdContext;
  //
  FTerminateWaitTime := 5000;
  FListenQueue := IdListenQueueDefault;
  //TODO: When reestablished, use a sleeping thread instead
//  fSessionTimer := TTimer.Create(self);
end;

procedure TIdTCPServer.Shutdown;
begin
  // Must set to False here. SetScheduler checks this
  FActive := False;
  //
  TerminateListenerThreads;
  // Tear down ThreadMgr
  try
    TerminateAllThreads;
  finally
    {//bgo TODO: fix this: and TIdThreadSafeList(Threads).IsCountLessThan(1)}
    // DONE -oAPR: BUG! Threads still live, Mgr dead ;-(
    if ImplicitScheduler then begin
      Scheduler := nil;
    end;
  end;
end;

procedure TIdTCPServer.Startup;
var
  i: Integer;
  LListenerThread: TIdListenerThread;
begin
  // Set up bindings
  if Bindings.Count = 0 then begin
    Bindings.Add; // IPv4
    if GStack.SupportsIPv6 then begin // maybe add a property too, so
      with Bindings.Add do begin      // the developer can switch it on/off
        IPVersion := Id_IPv6;
      end;
    end;
  end;
  // Setup IOHandler
  if not Assigned(FIOHandler) then begin
    IOHandler := TIdServerIOHandlerStack.Create(self);  {TIdServerIOHandlerStack.Create(self);}
    FImplicitIOHandler := True;
  end;
  //
  IOHandler.Init;
  //
  // Set up scheduler
  if Scheduler = nil then begin
    Scheduler := TIdSchedulerOfThreadDefault.Create(Self);
    // Useful in debugging and for thread names
    Scheduler.Name := Name + 'Scheduler';   {do not localize}
    FImplicitScheduler := true;
  end;
  Scheduler.Init;
  // Set up listener threads
  i := 0;
  try
    while i < Bindings.Count do begin
      with Bindings[i] do begin
        AllocateSocket;
        if (FReuseSocket = rsTrue) or ((FReuseSocket = rsOSDependent) and (GOSType = otLinux))
          then begin
             SetSockOpt(Id_SOL_SOCKET, Id_SO_REUSEADDR,Id_SO_True);
        end;
        Bind;
      end;
      Inc(i);
    end;
  except
    Dec(i); // the one that failed doesn't need to be closed
    while i >= 0 do begin
      Bindings[i].CloseSocket;
      Dec(i);
    end;
    FActive := True;
    SetActive(False); // allow descendants to clean up
    raise;
  end;
  DoAfterBind;
  FListenerThreads := TThreadList.Create;
  for i := 0 to Bindings.Count - 1 do begin
    Bindings[i].Listen(FListenQueue);
    LListenerThread := TIdListenerThread.Create(Self, Bindings[i]);
    LListenerThread.Name := Name + ' Listener #' + IntToStr(i + 1); {do not localize}
    LListenerThread.OnBeforeRun := OnBeforeListenerRun;
    //Todo: Implement proper priority handling for Linux
    //http://www.midnightbeach.com/jon/pubs/2002/BorCon.London/Sidebar.3.html
    LListenerThread.Priority := tpListener;
    FListenerThreads.Add(LListenerThread);
    LListenerThread.Start;
  end;
  FActive := True;
end;

{ TIdListenerThread }

procedure TIdListenerThread.AfterRun;
begin
  inherited;
  // Close just own binding. The rest will be closed from their coresponding
  // threads
  FBinding.CloseSocket;
end;

procedure TIdListenerThread.BeforeRun;
begin
  inherited;
  if Assigned(FOnBeforeRun) then begin
    FOnBeforeRun(Self);
  end;
end;

constructor TIdListenerThread.Create(AServer: TIdTCPServer; ABinding: TIdSocketHandle);
begin
  inherited Create;
  FBinding := ABinding;
  FServer := AServer;
end;

procedure TIdListenerThread.Run;
var
  LContext: TIdContext;
  LIOHandler: TIdIOHandler;
  LPeer: TIdTCPConnection;
  LYarn: TIdYarn;
begin
  LContext := nil;
  LPeer := nil;
  LYarn := nil;
  try
    // GetYarn can raise exceptions
    LYarn := Server.Scheduler.AcquireYarn;

    LIOHandler := Server.IOHandler.Accept(Binding, Self, LYarn);
    if LIOHandler = nil then begin
      // Listening has finished
      Stop;
      Abort;
    end else begin
      // We have accepted the connection and need to handle it
      LPeer := TIdTCPConnection.Create(nil);
      LPeer.IOHandler := LIOHandler;
      LPeer.ManagedIOHandler := True;
    end;

    // LastRcvTimeStamp := Now;  // Added for session timeout support
    // ProcessingTimeout := False;
    if (Server.MaxConnections > 0) // Check MaxConnections
     and (TIdThreadSafeList(Server.Contexts).IsCountLessThan(Server.MaxConnections) = False)
     then begin
      FServer.DoMaxConnectionsExceeded(LIOHandler);
      LPeer.Disconnect;
      Abort;
    end;
    // Create and init context
    LContext := Server.FContextClass.Create(LPeer, LYarn, Server.Contexts);
    // We set these instead of having the context call them directly
    // because they are protected methods. Also its good to keep
    // Context indepent of the server as well.
    LContext.OnBeforeRun := Server.DoConnect;
    LContext.OnRun := Server.DoExecute;
    LContext.OnAfterRun := Server.DoDisconnect;
    //
    Server.ContextCreated(LContext);
    //
    // If all ok, lets start the yarn
    Server.Scheduler.StartYarn(LYarn, LContext);
  except
    on E: Exception do begin
      FreeAndNil(LContext);
      FreeAndNil(LPeer);
      // Must terminate - likely has not started yet
      if LYarn <> nil then begin
        Server.Scheduler.TerminateYarn(LYarn);
      end;
      // EAbort is used to kick out above and destroy yarns and other, but
      // we dont want to show the user
      if not (E is EAbort) then begin
        Server.DoListenException(Self, E);
      end;
    end;
  end;
end;

end.

