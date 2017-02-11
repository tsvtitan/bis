unit BisCallServer;

interface

uses Classes, Sysutils, Contnrs, DB, mmSystem, ExtCtrls, SyncObjs,
     WaveUtils,
     BisObject, BisCoreObjects, BisServers, BisModules, BisServerModules,
     BisDataSet, BisLogger, BisNotifyEvents, BisEvents, BisDtmf,
     BisConnections, BisWave, BisVariants, BisThread,
     BisCallServerHandlers, BisCallServerChannels,
     BisCallServerHandlerModules;

type
  TBisCallServer=class;
  TBisCallServerLine=class;

  TBisCallServerLineDirection=(ldIncoming,ldOutgoing);
  TBisCallServerLineTypeEnd=(lteServerClose,lteCallerClose,lteAcceptorClose,lteServerCancel,
                             lteCallerCancel,lteAcceptorCancel,lteTimeout,lteSearch);
  TBisCallServerLinePlayState=(lpsNothing,lpsGreeting,lpsHolding,lpsNotfound,lpsConfirm,lpsWrong);

  TBisCallServerLineSearchHandlers=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisCallServerHandler;
  public
    procedure CopyFrom(Source: TBisCallServerLineSearchHandlers);

    property Items[Index: Integer]: TBisCallServerHandler read GetItem; default;
  end;

  TBisCallServerLineSearchThread=class(TBisThread)
  private
    FLine: TBisCallServerLine;
    FHandlers: TBisCallServerLineSearchHandlers;
    FEvent: TEvent;
    FAcceptors: TBisVariants;
    FAcceptor: Variant;
    FHandler: TBisCallServerHandler;
    FChannel: TBisCallServerChannel;
    FAcceptorType: TBisCallServerChannelAcceptorType;
    FInternal: Boolean;
    FWaitTimeout: Cardinal;
    FWaitInterval: Cardinal;
    FWaitCommand: Cardinal;
    FSessions: TBisDataSet;
//    FDestroy: Boolean;
    FCanceled: Boolean;
    FAccepted: Boolean;
//    FNotExists: Boolean;
    procedure AcceptorDial;
    procedure AcceptorFree;
    procedure AcceptorHangup;
  public
    constructor Create(Line: TBisCallServerLine; Internal: Boolean); reintroduce;
    destructor Destroy; override;
    procedure Execute; override;
    procedure CopyAcceptors(DataSet: TBisDataSet);
//    procedure Next(ADestroy: Boolean);
//    procedure Next(Kind: );
//    procedure Event;

    procedure Accept;
    procedure Cancel;
    procedure Terminate;
    function AccountId(SessionId: Variant): Variant;
  end;

  TBisCallServerLineSleepThread=class(TBisThread)
  private
    FInterval: Cardinal;
    FEvent: TEvent;
  public
    constructor Create(Interval: Cardinal); reintroduce;
    destructor Destroy; override;
    procedure Execute; override;
    procedure Terminate;
  end;

  TBisCallServerLine=class(TBisObject)
  private
    FServer: TBisCallServer;
    FLock: TCriticalSection;
    FInternalFormat: TWaveFormatEx;
    FConnection: TBisConnection;
    FConnectionSessionId: Variant;
    FInStream: TMemoryStream;
    FOutStream: TMemoryStream;
    FCodeMessages: TBisDataSet;
    FSearchThread: TBisCallServerLineSearchThread;
    FDtmfSleepThread: TBisCallServerLineSleepThread;
    FDtmfStream: TMemoryStream;
    FDtmf: TBisDtmf;
    FDtmfCommand: String;
    FNeedNotFound: Boolean;
    FHoldCount: Integer;
    FPlayState: TBisCallServerLinePlayState;
    FInChannel: TBisCallServerChannel;
    FOutChannel: TBisCallServerChannel;
    FAlreadySaved: Boolean;

    FId: Variant;
    FCurrentCallId: Variant;
    FCallResultId: Variant;
    FDirection: Variant;
    FOperatorId: Variant;
    FFirmId: Variant;
    FCreatorId: Variant;
    FDateCreate: Variant;
    FCallerId: Variant;
    FCallerPhone: Variant;
    FAcceptorId: Variant;
    FTempAcceptorId: Variant;
    FAcceptorPhone: Variant;
    FDateFound: Variant;
    FDateBegin: Variant;
    FDateEnd: Variant;
    FTypeEnd: Variant;
    FCallerAudio: TMemoryStream;
    FAcceptorAudio: TMemoryStream;
    FInChannelName: Variant;
//    FOutHandler: TBisCallServerHandler;
    FOutChannelName: Variant;

    FSLineFormat: String;
    FSCommand: String;
    FSCommandError: String;
    FSIncomingCall: String;
    FSOutgoingCall: String;
    FSChannelCheckStart: String;
    FSPlayGreetingStart: String;
    FSPlayHoldingStart: String;
    FSPlayNotfoundStart: String;
    FSPlayConfirmStart: String;
    FSPlayWrongStart: String;
    FSAcceptorDial: String;
    FSSearchStart: String;
    FSChannelRingStart: String;
    FSChannelCancelStart: String;
    FSChannelConnectStart: String;
    FSChannelDisconnectStart: String;
    FSChannelCodeStart: String;
    FSChannelHoldStart: String;
    FSChannelUnHoldStart: String;
    FSChannelPlayBeginStart: String;
    FSChannelPlayEndStart: String;
    FSChannelError: String;
    FSChannelTimeOutStart: String;

    procedure LoggerWrite(const Message: String; Channel: TBisCallServerChannel=nil; LogType: TBisLoggerType=ltInformation);

    procedure SetChannelProps(Channel: TBisCallServerChannel; Enabled: Boolean);
    procedure SetInChannel(const Value: TBisCallServerChannel);
    procedure SetOutChannel(const Value: TBisCallServerChannel);

    procedure AcceptorDial(Handler: TBisCallServerHandler; Acceptor: Variant;
                              AcceptorType: TBisCallServerChannelAcceptorType; var Channel: TBisCallServerChannel);
    procedure AcceptorHangup(Handler: TBisCallServerHandler; Channel: TBisCallServerChannel);

    procedure RefreshCodeMessages;
    function InsertCall(CallId: Variant): Variant;
    function UpdateCall(CallId: Variant): Boolean;
    procedure SaveCall(TypeEnd: Variant);
    function NewCall(CallId: Variant): Boolean;
    function GetSessions(DataSet: TBisDataSet): Boolean;
    procedure NextAcceptor(AInternal: Boolean;ANew: Boolean);

    procedure SearchThreadTerminate(Sender: TObject);
    procedure StopSearchThread(Accepted: Boolean);
    function StartSearchThread(Internal: Boolean): Boolean;

    procedure DtmfCode(Sender: TObject; const Code: Char);
    procedure DtmfSleepThreadTerminate(Sender: TObject);
    procedure StopDtmfSleepThread;
    procedure StartDtmfSleepThread;

    function ConvertStream(InStream, OutStream: TMemoryStream; Format: PWaveFormatEx; OnlyData: Boolean): Boolean;
    function MakeStream(Format: PWaveFormatEx; InStream, OutStream: TMemoryStream): Boolean; overload;

    function ChannelCheck(Channel: TBisCallServerChannel): Boolean;
    procedure ChannelRing(Channel: TBisCallServerChannel);
    procedure ChannelCancel(Channel: TBisCallServerChannel);
    procedure ChannelConnect(Channel: TBisCallServerChannel);
    procedure ChannelDisconnect(Channel: TBisCallServerChannel);
    procedure ChannelCode(Channel: TBisCallServerChannel; const Code: Char);
    procedure ChannelData(Channel: TBisCallServerChannel; const Data: Pointer; const DataSize: Cardinal);
    procedure ChannelHold(Channel: TBisCallServerChannel);
    procedure ChannelUnHold(Channel: TBisCallServerChannel);
    procedure ChannelPlayBegin(Channel: TBisCallServerChannel);
    procedure ChannelPlayEnd(Channel: TBisCallServerChannel);
    procedure ChannelError(Channel: TBisCallServerChannel; const Error: String);
    procedure ChannelTimeout(Channel: TBisCallServerChannel);

    function PlayGreeting(Channel: TBisCallServerChannel): Boolean;
    function PlayHolding(Channel: TBisCallServerChannel): Boolean;
    function PlayNotfound(Channel: TBisCallServerChannel): Boolean;
    function PlayConfirm(Channel: TBisCallServerChannel): Boolean;
    function PlayWrong(Channel: TBisCallServerChannel): Boolean;
  public
    constructor Create(Server: TBisCallServer); reintroduce;
    destructor Destroy; override;

    property InChannel: TBisCallServerChannel read FInChannel write SetInChannel;
    property OutChannel: TBisCallServerChannel read FOutChannel write SetOutChannel;

  published
    property SLineFormat: String read FSLineFormat write FSLineFormat;
    property SCommand: String read FSCommand write FSCommand;

  end;

  TBisCallServerLines=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisCallServerLine;
  public
    destructor Destroy; override;
    function Find(Channel: TBisCallServerChannel): TBisCallServerLine;
    function Add(Channel: TBisCallServerChannel; Server: TBisCallServer): TBisCallServerLine; reintroduce;
    procedure Remove(Channel: TBisCallServerChannel);

    property Items[Index: Integer]: TBisCallServerLine read GetItem; default;
  end;

  TBisCallServer=class(TBisServer)
  private
    FLines: TBisCallServerLines;
    FModules: TBisCallServerHandlerModules;
    FActive: Boolean;

    FGreetingStream: TMemoryStream;
    FHoldingStream: TMemoryStream;
    FConfirmStream: TMemoryStream;
    FWrongStream: TMemoryStream;
    FNotfoundStream: TMemoryStream;
    FMaxHoldCount: Integer;
    FDtmfEnabled: Boolean;
    FDtmfThreshold: Integer;
    FDtmfInterval: Integer;
    FPCMFormat: TPCMFormat;
    FConfirmSymbol: Char;
    FCancelSymbol: Char;
    FSearchInterval: Integer;
    FCommandTimeout: Integer;
    FInternalTimeout: Integer;
    FExternalTimeout: Integer;

    FSStart: String;
    FSStop: String;
    FSStopFail: String;
    FSStartFail: String;
    FSStopSuccess: String;
    FSStartSuccess: String;

    procedure ChangeParams(Sender: TObject);
    procedure ModulesCreateModule(Modules: TBisModules; Module: TBisModule);
    procedure HandlersCreateHandler(Handlers: TBisCallServerHandlers; Handler: TBisCallServerHandler);
    procedure ChannelsCreateChannel(Channels: TBisCallServerChannels; Channel: TBisCallServerChannel);
    procedure ChannelsDestroyChannel(Channels: TBisCallServerChannels; Channel: TBisCallServerChannel);
  protected
    function GetStarted: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure Start; override;
    procedure Stop; override;

  published
    property SStart: String read FSStart write FSStart;
    property SStartSuccess: String read FSStartSuccess write FSStartSuccess;
    property SStartFail: String read FSStartFail write FSStartFail;

    property SStop: String read FSStop write FSStop;
    property SStopSuccess: String read FSStopSuccess write FSStopSuccess;
    property SStopFail: String read FSStopFail write FSStopFail;


  end;

procedure InitServerModule(AModule: TBisServerModule); stdcall;

exports
  InitServerModule;

implementation

uses Windows, Dialogs, Variants, TypInfo,
     AsyncCalls,
     WaveStorage,
     BisCore, BisConsts, BisUtils, BisProvider, BisConfig, BisFilterGroups,
     BisValues,
     BisCallServerConsts;


procedure InitServerModule(AModule: TBisServerModule); stdcall;
begin
  AModule.ServerClass:=TBisCallServer;
end;

{ TBisCallServerLineSearchHandlers }

procedure TBisCallServerLineSearchHandlers.CopyFrom(Source: TBisCallServerLineSearchHandlers);
var
  i: Integer;
begin
  if Assigned(Source) then begin
    Clear;
    for i:=0 to Source.Count-1 do
      Add(Source.Items[i]);
  end;
end;

function TBisCallServerLineSearchHandlers.GetItem(Index: Integer): TBisCallServerHandler;
begin
  Result:=TBisCallServerHandler(inherited Items[Index]);
end;

{ TBisCallServerLineSearchThread }

constructor TBisCallServerLineSearchThread.Create(Line: TBisCallServerLine; Internal: Boolean);
begin
  inherited Create;
  FreeOnTerminate:=true;
  FLine:=Line;
  FInternal:=Internal;
  FHandlers:=TBisCallServerLineSearchHandlers.Create(false);
  FAcceptors:=TBisVariants.Create;
  FSessions:=TBisDataSet.Create(nil);
  FEvent:=TEvent.Create(nil,false,false,'');
end;

destructor TBisCallServerLineSearchThread.Destroy;
begin
  FEvent.SetEvent;
  FEvent.Free;
  FreeAndNilEx(FSessions);
  FreeAndNilEx(FAcceptors);
  FreeAndNilEx(FHandlers);
  FLine:=nil;
  inherited Destroy;
end;

function TBisCallServerLineSearchThread.AccountId(SessionId: Variant): Variant;
begin
  Result:=Null;
  if Assigned(FSessions) and FSessions.Active and not VarIsNull(SessionId) then begin
    try
      FSessions.Filter:=FormatEx('SESSION_ID=%s',[QuotedStr(VarToStrDef(SessionId,''))]);
      FSessions.Filtered:=true;
      if not FSessions.Empty then
        Result:=FSessions.FieldByName('ACCOUNT_ID').Value;
    finally
      FSessions.Filter:='';
      FSessions.Filtered:=false;
    end;
  end;
end;

procedure TBisCallServerLineSearchThread.CopyAcceptors(DataSet: TBisDataSet);
begin
  if Assigned(DataSet) and Assigned(FAcceptors) and Assigned(FSessions) then begin
    FAcceptors.Clear;
    FSessions.EmptyTable;
    if DataSet.Active then begin
      DataSet.First;
      FSessions.CreateTable(DataSet);
      while not DataSet.Eof do begin
        FAcceptors.Add(DataSet.FieldByName('SESSION_ID').Value);
        FSessions.CopyRecord(DataSet);
        DataSet.Next;
      end;
    end;
  end;
end;

{procedure TBisCallServerLineSearchThread.Event;
begin
  FEvent.SetEvent;
end;

{procedure TBisCallServerLineSearchThread.Next(ADestroy: Boolean);
begin
  FDestroy:=ADestroy;
  Event;
end;}

{procedure TBisCallServerLineSearchThread.Execute;
var
  i,j: Integer;
  Ret: TWaitResult;
begin
  inherited Execute;
  if Assigned(FLine) then begin

//    FWaitInterval:=1000;
//    FWaitCommand:=30000;
//    FWaitTimeout:=30000;

    FEvent.ResetEvent;
    Ret:=FEvent.WaitFor(FWaitInterval);
    if (Ret=wrTimeout) and not Terminated then begin
      for i:=0 to FHandlers.Count-1 do begin
        if not Terminated then begin
          FHandler:=FHandlers.Items[i];
          for j:=0 to FAcceptors.Count-1 do begin
            FAcceptor:=FAcceptors.Items[j].Value;
            Synchronize(AcceptorDial);
            FDestroy:=false;
            FEvent.ResetEvent;
            Ret:=FEvent.WaitFor(FWaitCommand);
            case Ret of
              wrSignaled: begin
                if FDestroy then
                  Synchronize(AcceptorFree)
                else begin
                  FDestroy:=false;
                  FEvent.ResetEvent;
                  Ret:=FEvent.WaitFor(FWaitTimeout);
                  case Ret of
                    wrSignaled: begin
                      if FDestroy then
                        Synchronize(AcceptorFree)
                      else 
                        Terminate;
                    end;
                    wrTimeout: begin
                      Synchronize(AcceptorTimeout);
                      FEvent.ResetEvent;
                      Ret:=FEvent.WaitFor(FWaitCommand);
                      case Ret of
                        wrSignaled: ;
                        wrTimeout: Synchronize(AcceptorFree);
                      else
                        Terminate;  
                      end;
                    end;
                  else
                    Terminate;
                  end;
                end;
              end;
              wrTimeout: Synchronize(AcceptorFree);
            else
              Terminate;
            end;
            if Terminated then
              break;
          end;
        end else
          break;
      end;
    end;
  end;
end;}


procedure TBisCallServerLineSearchThread.AcceptorDial;
begin
  FChannel:=nil;
  if Assigned(FLine) and Assigned(FHandler) then
     FLine.AcceptorDial(FHandler,FAcceptor,FAcceptorType,FChannel);
end;

procedure TBisCallServerLineSearchThread.AcceptorFree;
begin
  if Assigned(FHandler) and Assigned(FChannel) then begin
    FHandler.Channels.Remove(FChannel);
    FChannel:=nil;
  end;
end;

procedure TBisCallServerLineSearchThread.AcceptorHangup;
begin
  if Assigned(FLine) and Assigned(FHandler) and Assigned(FChannel) then begin
    FLine.AcceptorHangup(FHandler,FChannel);
    if not Assigned(FLine.FInChannel) then
      AcceptorFree;
  end;
end;

procedure TBisCallServerLineSearchThread.Accept;
begin
  FAccepted:=true;
  FEvent.SetEvent;
end;

procedure TBisCallServerLineSearchThread.Cancel;
begin
  FCanceled:=true;
  FEvent.SetEvent;
end;

procedure TBisCallServerLineSearchThread.Terminate;
begin
  FEvent.SetEvent;
  inherited Terminate;
end;

procedure TBisCallServerLineSearchThread.Execute;

  procedure Hangup;
  begin
    if not Terminated then begin
      Synchronize(AcceptorHangup);
      if Assigned(FChannel) then begin
        if not Terminated then begin
          FEvent.ResetEvent;
          FEvent.WaitFor(iff(FWaitCommand<=0,INFINITE,FWaitCommand));
          if not Terminated then
            Synchronize(AcceptorFree);
        end else
          Synchronize(AcceptorFree);
      end;
    end;
  end;

  function Answer: Boolean;
  var
    Ret: TWaitResult;
  begin
    Result:=false;
    if Assigned(FChannel) then begin
      if not Terminated then begin
        FAccepted:=false;
        FEvent.ResetEvent;
        Ret:=FEvent.WaitFor(FWaitTimeout);
        case Ret of
          wrSignaled: begin
            if FAccepted then
              Result:=true
            else
              Synchronize(AcceptorFree);
          end;
          wrTimeout: Hangup;
        else
          Synchronize(AcceptorFree);
        end;
      end else
        Synchronize(AcceptorFree);
    end;
  end;

  function Dial: Boolean;
  var
    Ret: TWaitResult;
  begin
    Result:=false;
    if not Terminated then begin
      Synchronize(AcceptorDial);
      if Assigned(FChannel) then begin
        if not Terminated then begin
          FCanceled:=false;
          FEvent.ResetEvent;
          Ret:=FEvent.WaitFor(iff(FWaitCommand<=0,INFINITE,FWaitCommand));
          case Ret of
            wrSignaled: begin
              if not FCanceled then
                Result:=Answer
              else
                Synchronize(AcceptorFree);
            end;
          else
            Synchronize(AcceptorFree);
          end;
        end else
          Synchronize(AcceptorFree);
      end;
    end;
  end;

var
  i,j: Integer;
  Ret: TWaitResult;
begin
  inherited Execute;
  if Assigned(FLine) then begin
    try
      FEvent.ResetEvent;
      Ret:=FEvent.WaitFor(FWaitInterval);
      if (Ret=wrTimeout) and not Terminated and Assigned(FHandlers) then begin
        for i:=0 to FHandlers.Count-1 do begin
          if not Terminated and Assigned(FHandlers) then begin
            FHandler:=FHandlers.Items[i];
            if not Terminated and Assigned(FAcceptors) then begin
              for j:=0 to FAcceptors.Count-1 do begin
                if not Terminated and Assigned(FAcceptors) then begin
                  FAcceptor:=FAcceptors.Items[j].Value;
                  if Dial then
                    exit;
                end else
                  break;
              end;
            end else
              break;
          end else
            break;
        end;
      end;
    except
      On E: Exception do begin
        if Assigned(FLine) then
          FLine.LoggerWrite(E.Message,nil,ltError);
      end;
    end;
  end;
end;

{ TBisCallServerLineSleepThread }

constructor TBisCallServerLineSleepThread.Create(Interval: Cardinal);
begin
  inherited Create;
  FreeOnTerminate:=true;
  FInterval:=Interval;
  FEvent:=TEvent.Create(nil,false,false,'');
end;

destructor TBisCallServerLineSleepThread.Destroy;
begin
  FEvent.SetEvent;
  FEvent.Free;
  inherited Destroy;
end;

procedure TBisCallServerLineSleepThread.Terminate;
begin
  FEvent.SetEvent;
  inherited Terminate;
end;

procedure TBisCallServerLineSleepThread.Execute;
begin
  inherited Execute;
  FEvent.ResetEvent;
  FEvent.WaitFor(FInterval);
end;

{ TBisCallServerLine }

constructor TBisCallServerLine.Create(Server: TBisCallServer);
begin
  inherited Create(nil);
  FServer:=Server;

  FLock:=TCriticalSection.Create;

  FConnection:=nil;
  FConnectionSessionId:=Null;
  if Assigned(Core) and Assigned(Core.Connection) then begin
    FConnection:=Core.Connection.CloneConnection(Core.SessionId,false);
    FConnectionSessionId:=Core.SessionId;
    FConnection.Connect;
  end;

  FInStream:=TMemoryStream.Create;
  FOutStream:=TMemoryStream.Create;

  FCodeMessages:=TBisDataSet.Create(nil);

  FillChar(FInternalFormat,SizeOf(FInternalFormat),0);
  SetPCMAudioFormatS(@FInternalFormat,FServer.FPCMFormat);

  FDtmfStream:=TMemoryStream.Create;

  FDtmf:=TBisDtmf.Create(nil);
  FDtmf.OnCode:=DtmfCode;
  FDtmf.Threshold:=FServer.FDtmfThreshold;
  FDtmf.SetFormat(@FInternalFormat);

  FNeedNotFound:=true;

  FId:=GetUniqueID;
  FCurrentCallId:=Null;
  FCallResultId:=Null;
  FDirection:=Null;
  FOperatorId:=Null;
  FFirmId:=Null;
  FCreatorId:=Null;
  FDateCreate:=Null;
  FCallerId:=Null;
  FCallerPhone:=Null;
  FAcceptorId:=Null;
  FTempAcceptorId:=Null;
  FAcceptorPhone:=Null;
  FDateFound:=Null;
  FDateBegin:=Null;
  FDateEnd:=Null;
  FTypeEnd:=Null;
  FInChannelName:=Null;
  FOutChannelName:=Null;
  FCallerAudio:=TMemoryStream.Create;
  FAcceptorAudio:=TMemoryStream.Create;

  FSLineFormat:='%s: %s';
  FSCommand:='������� %s';
  FSCommandError:='������� %s ��������� � �������: %s';
  FSIncomingCall:='�������� �����';
  FSOutgoingCall:='��������� �����';
  FSPlayGreetingStart:='������ ����������� ...';
  FSPlayHoldingStart:='������ ��������� ...';
  FSPlayNotfoundStart:='������ ��� ����������� ...';
  FSPlayConfirmStart:='������ ����������� ���� ��������� ...';
  FSPlayWrongStart:='������ ������������� ���� ��������� ...';
  FSAcceptorDial:='������ �� %s (%s)';
  FSSearchStart:='������ ������ ...';

  FSChannelCheckStart:='������ �������� (%s) ...';
  FSChannelRingStart:='������ ...';
  FSChannelCancelStart:='������ ...';
  FSChannelConnectStart:='����������� ...';
  FSChannelDisconnectStart:='���������� ...';
  FSChannelCodeStart:='��� ��������� ...';
  FSChannelHoldStart:='��������� ...';
  FSChannelUnHoldStart:='������ ��������� ...';
  FSChannelPlayBeginStart:='������ ������ ...';
  FSChannelPlayEndStart:='��������� ������ ...';
  FSChannelError:='������: %s';
  FSChannelTimeOutStart:='����� ������� ...';

end;

destructor TBisCallServerLine.Destroy;
begin
  StopDtmfSleepThread;
  StopSearchThread(false);
  SetInChannel(nil);
  SetOutChannel(nil);
  FAcceptorAudio.Free;
  FCallerAudio.Free;
  FDtmf.Free;
  FDtmfStream.Free;
  FCodeMessages.Free;
  FOutStream.Free;
  FInStream.Free;
  if Assigned(Core) and Assigned(Core.Connection) then begin
    Core.Connection.RemoveConnection(FConnection,FConnectionSessionId,false);
    FConnection:=nil;
  end;
  FLock.Free;
  inherited Destroy;
end;

procedure TBisCallServerLine.LoggerWrite(const Message: String; Channel: TBisCallServerChannel; LogType: TBisLoggerType);
var
  S: String;
  S1,S2: String;
begin
  if Assigned(FServer) and (Trim(Message)<>'') then begin
    S1:='';
    if Assigned(Channel) then
      S1:=Channel.ChannelName;
    if Trim(S1)<>'' then begin
      S2:=VarToStrDef(FCurrentCallId,'');
      if Trim(S2)<>'' then
        S1:=S1+' '+S2;
      S:=FormatEx(FSLineFormat,[S1,Message]);
    end else
      S:=Message;

    FServer.LoggerWrite(S,LogType);
  end;
end;

procedure TBisCallServerLine.SetChannelProps(Channel: TBisCallServerChannel; Enabled: Boolean);
begin
  if Assigned(Channel) then begin
    if Enabled then begin
      Channel.Connection:=FConnection;
      Channel.ConnectionSessionId:=FConnectionSessionId;
      Channel.OnCheck:=ChannelCheck;
      Channel.OnRing:=ChannelRing;
      Channel.OnCancel:=ChannelCancel;
      Channel.OnConnect:=ChannelConnect;
      Channel.OnDisconnect:=ChannelDisconnect;
      Channel.OnCode:=ChannelCode;
      Channel.OnData:=ChannelData;
      Channel.OnHold:=ChannelHold;
      Channel.OnUnHold:=ChannelUnHold;
      Channel.OnPlayBegin:=ChannelPlayBegin;
      Channel.OnPlayEnd:=ChannelPlayEnd;
      Channel.OnError:=ChannelError;
      Channel.OnTimeout:=ChannelTimeout;
    end else begin
      Channel.Connection:=nil;
      Channel.ConnectionSessionId:=Null;
      Channel.OnCheck:=nil;
      Channel.OnRing:=nil;
      Channel.OnCancel:=nil;
      Channel.OnConnect:=nil;
      Channel.OnDisconnect:=nil;
      Channel.OnCode:=nil;
      Channel.OnData:=nil;
      Channel.OnHold:=nil;
      Channel.OnUnHold:=nil;
      Channel.OnPlayBegin:=nil;
      Channel.OnPlayEnd:=nil;
      Channel.OnError:=nil;
      Channel.OnTimeout:=nil;
    end;
  end;
end;

procedure TBisCallServerLine.SetInChannel(const Value: TBisCallServerChannel);
begin
  SetChannelProps(FInChannel,false);
  FInChannel:=Value;
  SetChannelProps(FInChannel,true);
end;

procedure TBisCallServerLine.SetOutChannel(const Value: TBisCallServerChannel);
begin
  SetChannelProps(FOutChannel,false);
  FOutChannel:=Value;
  SetChannelProps(FOutChannel,true);
end;

procedure TBisCallServerLine.StopDtmfSleepThread;
begin
  if Assigned(FDtmfSleepThread) then begin
    FDtmfSleepThread.Terminate;
  end;
end;

procedure TBisCallServerLine.StartDtmfSleepThread;
begin
  if not Assigned(FDtmfSleepThread) and Assigned(FServer) then begin
    FDtmfSleepThread:=TBisCallServerLineSleepThread.Create(FServer.FDtmfInterval);
    FDtmfSleepThread.OnTerminate:=DtmfSleepThreadTerminate;
    FDtmfSleepThread.Resume;
  end;
end;

procedure TBisCallServerLine.DtmfCode(Sender: TObject; const Code: Char);
begin
  if not Assigned(FDtmfSleepThread) then begin
    LoggerWrite(FSChannelCodeStart,FInChannel);
    StartDtmfSleepThread;
    FDtmfCommand:=FDtmfCommand+Code;
  end;
end;

procedure TBisCallServerLine.DtmfSleepThreadTerminate(Sender: TObject);

  function GetCodeMessageId(TextIn: String; var RetCode,ProcName,CommandString,Answer: String): Variant;

    function FindByDelimeter(ACode,ADelimeter: String): Boolean;
    var
      S: String;
      APos: Integer;
    begin
      Result:=false;
      APos:=AnsiPos(ADelimeter,TextIn);
      if APos>0 then begin
        S:=Copy(TextIn,1,APos-1);
        Result:=AnsiSameText(S,ACode);
      end;
    end;

    function CheckCodeByDelimeter(ACode: String): Boolean;
    begin
      Result:=AnsiSameText(ACode,TextIn);
      if not Result then
        Result:=FindByDelimeter(ACode,':');
      if not Result then
        Result:=FindByDelimeter(ACode,'=');
      if not Result then
        Result:=FindByDelimeter(ACode,'-');
      if not Result then
        Result:=FindByDelimeter(ACode,' ');
    end;

    function FindByCode(var NewCode: String): Boolean;
    var
      Str: TStringList;
      i: Integer;
    begin
      Result:=CheckCodeByDelimeter(NewCode);
      if not Result then begin
        Str:=TStringList.Create;
        try
          GetStringsByString(NewCode,';',Str);
          for i:=0 to Str.Count-1 do begin
            if CheckCodeByDelimeter(Str[i]) then begin
              NewCode:=Str[i];
              Result:=true;
              break;
            end;
          end;
        finally
          Str.Free;
        end;
      end;
    end;

  var
    CodeMessageId: Variant;
    LCode: Integer;
    LTextIn: Integer;
    NewCode: String;
    ACode: String;
  begin
    Result:=Null;
    TextIn:=Trim(TextIn);
    LTextIn:=Length(TextIn);
    if (LTextIn>0) and FCodeMessages.Active and not FCodeMessages.IsEmpty then begin
      FCodeMessages.First;
      while not FCodeMessages.Eof do begin
        CodeMessageId:=FCodeMessages.FieldByName('CODE_MESSAGE_ID').Value;
        ACode:=Trim(FCodeMessages.FieldByName('CODE').AsString);
        LCode:=Length(ACode);
        NewCode:=ACode;
        if (LCode>0) and FindByCode(NewCode) then begin
          RetCode:=NewCode;
          ProcName:=FCodeMessages.FieldByName('PROC_NAME').AsString;
          CommandString:=FCodeMessages.FieldByName('COMMAND_STRING').AsString;
          Answer:=FCodeMessages.FieldByName('ANSWER').AsString;
          Result:=CodeMessageId;
          exit;
        end;
        FCodeMessages.Next;
      end;
    end;
  end;

  function WriteMessage(Contact, TextIn: String; SenderId, CodeMessageId, FirmId: Variant): Variant;
  var
    P: TBisProvider;
  begin
    Result:=Null;
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.StopException:=false;
      P.Connection:=FConnection;
      P.ConnectionSessionId:=FConnectionSessionId;
      P.ProviderName:='I_IN_MESSAGE';
      with P.Params do begin
        AddKey('IN_MESSAGE_ID');
        AddInvisible('SENDER_ID').Value:=SenderId;
        AddInvisible('CODE_MESSAGE_ID').Value:=CodeMessageId;
        AddInvisible('DATE_SEND').Value:=Core.ServerDate;
        AddInvisible('TEXT_IN').Value:=TextIn;
        AddInvisible('DATE_IN').Value:=Null;
        AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
        AddInvisible('CONTACT').Value:=Contact;
        AddInvisible('CHANNEL').Value:=FInChannelName;
        AddInvisible('FIRM_ID').Value:=FirmId;
        AddInvisible('OPERATOR_ID').Value:=Null;
      end;
      P.Execute;
      if P.Success then begin
        Result:=P.Params.ParamByName('IN_MESSAGE_ID').Value;
      end;
    finally
      P.Free;
    end;
  end;

  procedure ExecuteProc(ProcName: String; InMessageId: Variant);
  var
    P: TBisProvider;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.StopException:=false;
      P.WithWaitCursor:=false;
      P.Connection:=FConnection;
      P.ConnectionSessionId:=FConnectionSessionId;
      P.ProviderName:=ProcName;
      with P.Params do begin
        AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
        AddInvisible('IN_MESSAGE_ID').Value:=InMessageId;
      end;
      P.Execute;
      if P.Success then ;
    finally
      P.Free;
    end;
  end;

  procedure ExecuteCommand(ACode,CommandString: String; Contact,TextIn: String; SenderId, CodeMessageId, InMessageId: Variant);
  var
    S: String;
    i: Integer;
    Params: TBisValues;
    Param: TBisValue;
    StartupInfo: TStartupInfo;
    ProcessInfo: TProcessInformation;
    Ret: Boolean;
  begin
    Params:=TBisValues.Create;
    try
      Params.Add('IN_MESSAGE_ID',VarToStrDef(InMessageId,''));
      Params.Add('SENDER_ID',VarToStrDef(SenderId,''));
      Params.Add('CODE_MESSAGE_ID',VarToStrDef(CodeMessageId,''));
      Params.Add('TEXT_IN',TextIn);
      Params.Add('CONTACT',Contact);
      Params.Add('CODE',ACode);

      S:=CommandString;
      for i:=0 to Params.Count-1 do begin
        Param:=Params.Items[i];
        S:=StringReplace(S,'%'+Param.Name,'"'+VarToStrDef(Param.Value,'')+'"',[rfReplaceAll, rfIgnoreCase]);
      end;

      FillChar(StartupInfo,SizeOf(TStartupInfo),0);
      with StartupInfo do begin
        cb:=SizeOf(TStartupInfo);
        wShowWindow:=SW_SHOWDEFAULT;
      end;
      Ret:=CreateProcess(nil,PChar(S),nil,nil,False,
                         NORMAL_PRIORITY_CLASS,nil,nil,StartupInfo, ProcessInfo);
      if not Ret then
        raise Exception.Create(SysErrorMessage(GetLastError));

    finally
      Params.Free;
    end;
  end;

  function IncomingGranted(SenderId: Variant): Boolean;
  var
    P: TBisProvider;
  begin
    Result:=true;
    if not VarIsNull(SenderId) then begin
      P:=TBisProvider.Create(nil);
      try
        P.StopException:=false;
        P.WithWaitCursor:=false;
        P.Connection:=FConnection;
        P.ConnectionSessionId:=FConnectionSessionId;
        P.ProviderName:='GET_INCOMING_GRANTED';
        with P.Params do begin
          AddInvisible('ACCOUNT_ID').Value:=SenderId;
          AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
          AddInvisible('GRANTED',ptOutput);
        end;
        P.Execute;
        if P.Success then
          Result:=P.ParamByName('GRANTED').AsBoolean;
      finally
        P.Free;
      end;
    end;
  end;

var
  First: String;
  L: Integer;
  Last: Char;
  CodeMessageId: Variant;
  TextIn: String;
  RetCode: String;
  ProcName: String;
  CommandString: String;
  Answer: String;
  InMessageId: Variant;
begin
  try
    try
      First:=FDtmfCommand;
      LoggerWrite(FormatEx(FSCommand,[First]),FInChannel);
      L:=Length(FDtmfCommand);
      if L>0 then begin
        Last:=FDtmfCommand[L];
        if Last=FServer.FConfirmSymbol then begin
          TextIn:=Copy(FDtmfCommand,1,L-1);
          if Trim(TextIn)<>'' then begin
            CodeMessageId:=GetCodeMessageId(TextIn,RetCode,ProcName,CommandString,Answer);
            if IncomingGranted(FCallerId) then begin
              InMessageId:=WriteMessage(FCallerPhone,TextIn,FCallerId,CodeMessageId,Null);
              if not VarIsNull(InMessageId) then begin
                if not VarIsNull(CodeMessageId) then begin
                  if Trim(ProcName)<>'' then begin
                    ExecuteProc(ProcName,InMessageId);
                  end;
                  if Trim(CommandString)<>'' then
                    ExecuteCommand(RetCode,CommandString,FCallerPhone,TextIn,FCallerId,CodeMessageId,InMessageId);
                  PlayConfirm(FInChannel);
                end else
                  PlayWrong(FInChannel);
              end;
            end;
            FDtmfCommand:='';
          end else
            FDtmfCommand:='';
        end else if Last=FServer.FCancelSymbol then begin
          FDtmfCommand:='';
        end;
      end;
    finally
      FDtmfSleepThread:=nil;
    end;
  except
    On E: Exception do begin
      LoggerWrite(FormatEx(FSCommandError,[First,E.Message]),FInChannel,ltError);
    end;
  end;
end;

procedure TBisCallServerLine.RefreshCodeMessages;
var
  P: TBisProvider;
begin
  P:=TBisProvider.Create(nil);
  try
    P.StopException:=false;
    P.WithWaitCursor:=false;
    P.Connection:=FConnection;
    P.ConnectionSessionId:=FConnectionSessionId;
    P.ProviderName:='S_CODE_MESSAGES';
    with P.FieldNames do begin
      AddInvisible('CODE_MESSAGE_ID');
      AddInvisible('CODE');
      AddInvisible('PROC_NAME');
      AddInvisible('COMMAND_STRING');
      AddInvisible('ANSWER');
    end;
    P.FilterGroups.Add.Filters.Add('ENABLED',fcEqual,1);
    P.Orders.Add('CODE');
    P.Open;
    if P.Active then begin
      FCodeMessages.Close;
      FCodeMessages.CreateTable(P);
      FCodeMessages.CopyRecords(P);
    end;
  finally
    P.Free;
  end;
end;

function TBisCallServerLine.InsertCall(CallId: Variant): Variant;
var
  P: TBisProvider;
  Ret: Variant;
begin
  Result:=Null;
  if VarIsNull(Result) then begin
    P:=TBisProvider.Create(nil);
    try
      P.StopException:=false;
      P.WithWaitCursor:=false;
      P.Connection:=FConnection;
      P.ConnectionSessionId:=FConnectionSessionId;
      P.ProviderName:='I_CALL';
      Ret:=CallId;
      with P.Params do begin
        AddInvisible('CALL_ID').Value:=CallId;
        AddInvisible('LINE_ID').Value:=FId;
        AddInvisible('CALL_RESULT_ID').Value:=FCallResultId;
        AddInvisible('DIRECTION').Value:=FDirection;
        AddInvisible('OPERATOR_ID').Value:=FOperatorId;
        AddInvisible('FIRM_ID').Value:=FFirmId;
        AddInvisible('CREATOR_ID').Value:=FCreatorId;
        AddInvisible('DATE_CREATE').Value:=FDateCreate;
        AddInvisible('CALLER_ID').Value:=FCallerId;
        AddInvisible('CALLER_PHONE').Value:=FCallerPhone;
        AddInvisible('ACCEPTOR_ID').Value:=FAcceptorId;
        AddInvisible('ACCEPTOR_PHONE').Value:=FAcceptorPhone;
        AddInvisible('DATE_FOUND').Value:=FDateFound;
        AddInvisible('DATE_BEGIN').Value:=FDateBegin;
        AddInvisible('DATE_END').Value:=FDateEnd;
        AddInvisible('TYPE_END').Value:=FTypeEnd;
        AddInvisible('CALLER_AUDIO').LoadFromStream(FCallerAudio);
        AddInvisible('ACCEPTOR_AUDIO').LoadFromStream(FAcceptorAudio);
        AddInvisible('IN_CHANNEL').Value:=FInChannelName;
        AddInvisible('OUT_CHANNEL').Value:=FOutChannelName;
      end;
      P.Execute;
      if P.Success then
        Result:=Ret;
    finally
      P.Free;
    end;
  end;
end;

function TBisCallServerLine.UpdateCall(CallId: Variant): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  if not VarIsNull(CallId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.StopException:=false;
      P.WithWaitCursor:=false;
      P.Connection:=FConnection;
      P.ConnectionSessionId:=FConnectionSessionId;
      P.ProviderName:='U_CALL';
      with P.Params do begin
        with AddInvisible('CALL_ID') do begin
          Older('OLD_CALL_ID');
          Value:=CallId;
        end;
        AddInvisible('LINE_ID').Value:=FId;
        AddInvisible('CALL_RESULT_ID').Value:=FCallResultId;
        AddInvisible('DIRECTION').Value:=FDirection;
        AddInvisible('OPERATOR_ID').Value:=FOperatorId;
        AddInvisible('FIRM_ID').Value:=FFirmId;
        AddInvisible('CREATOR_ID').Value:=FCreatorId;
        AddInvisible('DATE_CREATE').Value:=FDateCreate;
        AddInvisible('CALLER_ID').Value:=FCallerId;
        AddInvisible('CALLER_PHONE').Value:=FCallerPhone;
        AddInvisible('ACCEPTOR_ID').Value:=FAcceptorId;
        AddInvisible('ACCEPTOR_PHONE').Value:=FAcceptorPhone;
        AddInvisible('DATE_FOUND').Value:=FDateFound;
        AddInvisible('DATE_BEGIN').Value:=FDateBegin;
        AddInvisible('DATE_END').Value:=FDateEnd;
        AddInvisible('TYPE_END').Value:=FTypeEnd;
        AddInvisible('CALLER_AUDIO').LoadFromStream(FCallerAudio);
        AddInvisible('ACCEPTOR_AUDIO').LoadFromStream(FAcceptorAudio);
        AddInvisible('IN_CHANNEL').Value:=FInChannelName;
        AddInvisible('OUT_CHANNEL').Value:=FOutChannelName;
      end;
      P.Execute;
      Result:=P.Success;
    finally
      P.Free;
    end;
  end;
end;

function TBisCallServerLine.GetSessions(DataSet: TBisDataSet): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  if not VarIsNull(FCurrentCallId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.StopException:=false;
      P.WithWaitCursor:=false;
      P.Connection:=FConnection;
      P.ConnectionSessionId:=FConnectionSessionId;
      P.ProviderName:='GET_CALL_SESSIONS';
      with P.Params do begin
        AddInvisible('CALL_ID').Value:=FCurrentCallId;
        AddInvisible('SESSION_ID',ptOutput);
        AddInvisible('ACCOUNT_ID',ptOutput);
      end;
      P.OpenWithExecute;
      if P.Active then begin
        DataSet.Close;
        DataSet.CreateTable(P);
        DataSet.CopyRecords(P);
        Result:=true;
      end;
    finally
      P.Free;
    end;
  end;
end;

function TBisCallServerLine.ChannelCheck(Channel: TBisCallServerChannel): Boolean;

  function OutgoingCheck: Boolean;
  var
    P: TBisProvider;
    CallerId: Variant;
  begin
    Result:=false;
    CallerId:=Channel.CallerId;
    if not VarIsNull(CallerId) then begin
      case Channel.AcceptorType of
        catPhone: begin
          P:=TBisProvider.Create(nil);
          try
            P.StopException:=false;
            P.WithWaitCursor:=false;
            P.Connection:=FConnection;
            P.ConnectionSessionId:=FConnectionSessionId;
            P.ProviderName:='OUTGOING_CALL_CHECK';
            with P.Params do begin
              AddInvisible('CALLER_ID').Value:=Channel.CallerId;
              AddInvisible('ACCEPTOR_PHONE').Value:=Channel.Acceptor;
              AddInvisible('ACCOUNT_ID',ptOutput);
              AddInvisible('PHONE',ptOutput);
              AddInvisible('OPERATOR_ID',ptOutput);
              AddInvisible('FIRM_ID',ptOutput);
              AddInvisible('CHECKED',ptOutput);
            end;
            P.Execute;
            if P.Success then begin
              FCallResultId:=Null;
              FDirection:=ldOutgoing;
              FOperatorId:=P.ParamByName('OPERATOR_ID').Value;
              FFirmId:=P.ParamByName('FIRM_ID').Value;
              FCreatorId:=Channel.CreatorId;
              FDateCreate:=Core.ServerDate;
              FCallerId:=Channel.CallerId;
              FCallerPhone:=Channel.CallerPhone;
              FAcceptorId:=P.ParamByName('ACCOUNT_ID').Value;
              FAcceptorPhone:=P.ParamByName('PHONE').Value;
              FDateFound:=Null;
              FDateBegin:=Null;
              FDateEnd:=Null;
              FTypeEnd:=Null;
              FCallerAudio.Clear;
              FAcceptorAudio.Clear;
              FInChannelName:=Channel.ChannelName;
              FOutChannelName:=Null;
              FCurrentCallId:=InsertCall(Channel.CallId);
              if not VarIsNull(FCurrentCallId) then
                Result:=P.ParamByName('CHECKED').AsBoolean;
            end;
          finally
            P.Free;
          end;
        end;
        catAccount: ;
        catComputer: ;
        catSession: ;
      end;
    end;
  end;

  function IncomingCheck: Boolean;
  var
    P: TBisProvider;
    Phone: Variant;
  begin
    Result:=false;
    Phone:=Channel.CallerPhone;
    if not VarIsNull(Phone) then begin
      P:=TBisProvider.Create(nil);
      try
        P.StopException:=false;
        P.WithWaitCursor:=false;
        P.Connection:=FConnection;
        P.ConnectionSessionId:=FConnectionSessionId;
        P.ProviderName:='INCOMING_CALL_CHECK';
        with P.Params do begin
          AddInvisible('CALLER_PHONE').Value:=Phone;
          AddInvisible('CHANNEL').Value:=Channel.ChannelName;
          AddInvisible('ACCOUNT_ID',ptOutput);
          AddInvisible('PHONE',ptOutput);
          AddInvisible('OPERATOR_ID',ptOutput);
          AddInvisible('FIRM_ID',ptOutput);
          AddInvisible('CHECKED',ptOutput);
        end;
        P.Execute;
        if P.Success then begin
          FCallResultId:=Null;
          FDirection:=ldIncoming;
          FOperatorId:=P.ParamByName('OPERATOR_ID').Value;
          FFirmId:=P.ParamByName('FIRM_ID').Value;
          FCreatorId:=Channel.CreatorId;
          FDateCreate:=Core.ServerDate;
          FCallerId:=P.ParamByName('ACCOUNT_ID').Value;
          FCallerPhone:=P.ParamByName('PHONE').Value;
          FAcceptorId:=Null;
          FAcceptorPhone:=Null;
          FDateFound:=Null;
          FDateBegin:=Null;
          FDateEnd:=Null;
          FTypeEnd:=Null;
          FCallerAudio.Clear;
          FAcceptorAudio.Clear;
          FInChannelName:=Channel.ChannelName;
          FOutChannelName:=Null;
          Result:=P.ParamByName('CHECKED').AsBoolean;
          if not Result then begin
            FDateEnd:=Core.ServerDate;
            FTypeEnd:=lteServerCancel;
          end;
          FCurrentCallId:=InsertCall(GetUniqueID);
        end;
      finally
        P.Free;
      end;
    end;
  end;

begin
  Result:=false;
  case Channel.Location of
    clInternal: begin
      if Channel=FInChannel then begin
        LoggerWrite(FormatEx(FSChannelCheckStart,[FSOutgoingCall]),Channel);
        Result:=OutgoingCheck;
      end else
        Result:=true;
    end;
    clExternal: begin
      if Channel=FInChannel then begin
        LoggerWrite(FormatEx(FSChannelCheckStart,[FSIncomingCall]),Channel);
        Result:=IncomingCheck;
      end else
        Result:=true;
    end;
  end;
end;

function TBisCallServerLine.ConvertStream(InStream,OutStream: TMemoryStream; Format: PWaveFormatEx; OnlyData: Boolean): Boolean;
var
  Converter: TBisWaveConverter;
  ASize: Integer;
  OldPos: Int64;
begin
  Result:=false;
  if Assigned(Format) then begin
    Converter:=TBisWaveConverter.Create;
    OldPos:=OutStream.Position;
    try
      InStream.Position:=0;
      Converter.LoadFromStream(InStream);
      if Converter.ConvertTo(Format) then begin
        Converter.Stream.Position:=0;
        if OnlyData then
          Converter.Stream.Position:=Converter.DataOffset;
        ASize:=Converter.Stream.Size-Converter.Stream.Position;
        if ASize>0 then begin
          OutStream.CopyFrom(Converter.Stream,ASize);
          Result:=true;
        end;
      end;
    finally
      OutStream.Position:=OldPos;
      Converter.Free;
    end;
  end;
end;

function TBisCallServerLine.MakeStream(Format: PWaveFormatEx; InStream, OutStream: TMemoryStream): Boolean;
var
  Converter: TBisWaveConverter;
  OldPos: Int64;
begin
  Result:=false;
  if Assigned(Format) then begin
    Converter:=TBisWaveConverter.Create;
    OldPos:=OutStream.Position;
    try
      if Converter.BeginRewrite(Format) then begin
        Converter.Write(InStream.Memory^,InStream.Size);
        Converter.EndRewrite;
        if not Converter.Empty then begin
          Converter.SaveToStream(OutStream);
          Result:=True;
        end;
      end;
    finally
      OutStream.Position:=OldPos;
      Converter.Free;
    end;
  end;
end;

function TBisCallServerLine.PlayGreeting(Channel: TBisCallServerChannel): Boolean;
var
  Stream: TMemoryStream;
begin
  Result:=false;
  if Assigned(Channel) then begin
    if FServer.FGreetingStream.Size>0 then begin
      Stream:=TMemoryStream.Create;
      try
        if ConvertStream(FServer.FGreetingStream,Stream,Channel.InFormat,true) then begin
          LoggerWrite(FSPlayGreetingStart,Channel);
          Channel.PlayStart(Stream,1);
          FPlayState:=lpsGreeting;
          Result:=true;
        end;
      finally
        Stream.Free;
      end;
    end;
  end;
end;

function TBisCallServerLine.PlayHolding(Channel: TBisCallServerChannel): Boolean;
var
  Stream: TMemoryStream;
begin
  Result:=false;
  if Assigned(Channel) then begin
    if (FServer.FMaxHoldCount>FHoldCount) and
       (FServer.FHoldingStream.Size>0) then begin
      Stream:=TMemoryStream.Create;
      try
        if ConvertStream(FServer.FHoldingStream,Stream,Channel.InFormat,true) then begin
          LoggerWrite(FSPlayHoldingStart,Channel);
          Channel.PlayStart(Stream,1);
          FPlayState:=lpsHolding;
          Result:=true;
        end;
      finally
        Stream.Free;
      end;
    end;
  end;
end;

function TBisCallServerLine.PlayNotfound(Channel: TBisCallServerChannel): Boolean;
var
  Stream: TMemoryStream;
begin
  Result:=false;
  if Assigned(Channel) then begin
    if FServer.FNotfoundStream.Size>0 then begin
      Stream:=TMemoryStream.Create;
      try
        if ConvertStream(FServer.FNotfoundStream,Stream,Channel.InFormat,true) then begin
          LoggerWrite(FSPlayNotfoundStart,Channel);
          Channel.PlayStart(Stream,1);
          FPlayState:=lpsNotfound;
          Result:=true;
        end;
      finally
        Stream.Free;
      end;
    end;
  end;
end;

function TBisCallServerLine.PlayConfirm(Channel: TBisCallServerChannel): Boolean;
var
  Stream: TMemoryStream;
begin
  Result:=false;
  if Assigned(Channel) then begin
    if FServer.FConfirmStream.Size>0 then begin
      Stream:=TMemoryStream.Create;
      try
        if ConvertStream(FServer.FConfirmStream,Stream,Channel.InFormat,true) then begin
          LoggerWrite(FSPlayConfirmStart,Channel);
          Channel.PlayStart(Stream,1);
          FPlayState:=lpsConfirm;
          Result:=true;
        end;
      finally
        Stream.Free;
      end;
    end;
  end;
end;

function TBisCallServerLine.PlayWrong(Channel: TBisCallServerChannel): Boolean;
var
  Stream: TMemoryStream;
begin
  Result:=false;
  if Assigned(Channel) then begin
    if FServer.FWrongStream.Size>0 then begin
      Stream:=TMemoryStream.Create;
      try
        if ConvertStream(FServer.FWrongStream,Stream,Channel.InFormat,true) then begin
          LoggerWrite(FSPlayWrongStart,Channel);
          Channel.PlayStart(Stream,1);
          FPlayState:=lpsWrong;
          Result:=true;
        end;
      finally
        Stream.Free;
      end;
    end;
  end;
end;

procedure TBisCallServerLine.SearchThreadTerminate(Sender: TObject);
var
  Internal: Boolean;  
begin
  if Assigned(FSearchThread) then begin
    Internal:=FSearchThread.FInternal;
    FSearchThread:=nil;
    if Assigned(FInChannel) and (FInChannel.State in [csProcessing]) then
      StartSearchThread(Internal);
  end;
end;

procedure TBisCallServerLine.StopSearchThread(Accepted: Boolean);
begin
  if Assigned(FSearchThread) then begin
    if Accepted then
      FSearchThread.Accept;
    FSearchThread.Terminate;
//    FSearchThread:=nil;
  end;
end;

procedure TBisCallServerLine.AcceptorDial(Handler: TBisCallServerHandler; Acceptor: Variant;
                                             AcceptorType: TBisCallServerChannelAcceptorType; var Channel: TBisCallServerChannel);

  function OutgoingPhonePrepare(Channel: TBisCallServerChannel): Variant;
  var
    P: TBisProvider;
  begin
    Result:=Acceptor;
    if Channel.Location=clExternal then begin
      P:=TBisProvider.Create(nil);
      try
        P.WithWaitCursor:=false;
        P.StopException:=false;
        P.Connection:=FConnection;
        P.ConnectionSessionId:=FConnectionSessionId;
        P.ProviderName:='OUTGOING_PHONE_PREPARE';
        with P.Params do begin
          AddInvisible('IN_PHONE').Value:=Acceptor;
          AddInvisible('CHANNEL').Value:=Channel.ChannelName;
          AddInvisible('OUT_PHONE',ptOutput);
        end;
        P.Execute;
        if P.Success then
          Result:=P.ParamByName('OUT_PHONE').Value;
      finally
        P.Free;
      end;
    end;
  end;
                                
var
  NewAcceptor: Variant;
  S: String;
begin
  SetOutChannel(nil);
  if Assigned(Handler) and Assigned(FInChannel) then begin
    if not VarIsNull(Acceptor) and Assigned(FSearchThread) then begin
      Channel:=Handler.AddOutgoingChannel(FCurrentCallId,FCallerId,FCallerPhone);
      if Assigned(Channel) then begin
        SetChannelProps(Channel,true);
        Channel.OutFormat:=FInChannel.InFormat;
        Channel.OutDataSize:=FInChannel.InDataSize;
        NewAcceptor:=Acceptor;
        if FSearchThread.FInternal then begin
          case AcceptorType of
            catSession: FTempAcceptorId:=FSearchThread.AccountId(Acceptor);
          else
            FTempAcceptorId:=Null;
          end;
        end else begin
          case AcceptorType of
            catPhone: NewAcceptor:=OutgoingPhonePrepare(Channel);
          end;
        end;
        S:=GetEnumName(TypeInfo(TBisCallServerChannelAcceptorType),Integer(AcceptorType));
        LoggerWrite(FormatEx(FSAcceptorDial,[NewAcceptor,S]),Channel);
        Channel.Dial(NewAcceptor,AcceptorType);
      end;
    end;
  end;
end;

procedure TBisCallServerLine.AcceptorHangup(Handler: TBisCallServerHandler; Channel: TBisCallServerChannel);
begin
  if Assigned(Handler) and Assigned(Channel) then begin
    if not (Channel.State in [csProcessing,csHolding]) then begin
      FTypeEnd:=lteTimeout;
      FDateEnd:=Core.ServerDate;
      FAlreadySaved:=false;
      Channel.Hangup;
    end;
  end;
end;

function TBisCallServerLine.StartSearchThread(Internal: Boolean): Boolean;
var
  DS: TBisDataSet;
  Handlers: TBisCallServerLineSearchHandlers;
begin
  Result:=false;
  StopSearchThread(false);

  if not VarIsNull(FCurrentCallId) and
     Assigned(FInChannel) and not Assigned(FOutChannel) and
     Assigned(FServer) and (FServer.FSearchInterval>0) then begin

    LoggerWrite(FSSearchStart,FInChannel);

    Handlers:=TBisCallServerLineSearchHandlers.Create(false);
    try
      if Internal then begin
        FServer.FModules.GetHandlers(hlInternal,Null,Handlers);
        if (Handlers.Count>0) and not Assigned(FSearchThread) then begin
          DS:=TBisDataSet.Create(nil);
          try
            if GetSessions(DS) then begin
              FSearchThread:=TBisCallServerLineSearchThread.Create(Self,true);
              with FSearchThread do begin
                OnTerminate:=SearchThreadTerminate;
                FHandlers.CopyFrom(Handlers);
                FAcceptorType:=catSession;
                CopyAcceptors(DS);
                FWaitInterval:=FServer.FSearchInterval;
                FWaitTimeout:=FServer.FInternalTimeout;
                FWaitCommand:=FServer.FCommandTimeout;
                Resume;
              end;
              Result:=true;
            end;
          finally
            DS.Free;
          end;
        end else begin
          FTypeEnd:=lteServerCancel;
          FInChannel.Hangup;
        end;
      end else begin
        FServer.FModules.GetHandlers(hlExternal,FOperatorId,Handlers);
        if (Handlers.Count>0) and not Assigned(FSearchThread) then begin
          FSearchThread:=TBisCallServerLineSearchThread.Create(Self,false);
          with FSearchThread do begin
            OnTerminate:=SearchThreadTerminate;
            FHandlers.CopyFrom(Handlers);
            FAcceptorType:=FInChannel.AcceptorType;
            FAcceptors.Add(FAcceptorPhone);
            FWaitInterval:=0;
            FWaitTimeout:=FServer.FExternalTimeout;
            FWaitCommand:=FServer.FCommandTimeout;
            Resume;
          end;
          Result:=true;
        end else begin
          FTypeEnd:=lteServerCancel;
          FInChannel.Hangup;
        end;
      end;
    finally
      Handlers.Free;
    end;
  end;
end;

function TBisCallServerLine.NewCall(CallId: Variant): Boolean;
begin
  FDateCreate:=Core.ServerDate;
  FAcceptorId:=Null;
  FDateFound:=Null;
  FDateBegin:=Null;
  FDateEnd:=Null;
  FTypeEnd:=Null;
  FCallerAudio.Clear;
  FAcceptorAudio.Clear;
  FCurrentCallId:=InsertCall(CallId);
  Result:=not VarIsNull(FCurrentCallId);
  FAlreadySaved:=false;
end;

procedure TBisCallServerLine.SaveCall(TypeEnd: Variant);
begin
  if not FAlreadySaved then begin
    FDateEnd:=Core.ServerDate;
    FTypeEnd:=iff(VarIsNull(FTypeEnd),TypeEnd,FTypeEnd);
    if Assigned(FOutChannel) then begin
      FOutChannelName:=FOutChannel.ChannelName;
      FAcceptorAudio.Clear;
      if FOutStream.Size>0 then begin
        FOutStream.Position:=0;
        MakeStream(FOutChannel.InFormat,FOutStream,FAcceptorAudio);
      end;
    end;
    if Assigned(FInChannel) then begin
      FInChannelName:=FInChannel.ChannelName;
      FCallerAudio.Clear;
      if FInStream.Size>0 then begin
        FInStream.Position:=0;
        MakeStream(FInChannel.InFormat,FInStream,FCallerAudio);
      end;
    end;
    FAlreadySaved:=UpdateCall(FCurrentCallId);
  end;
end;

procedure TBisCallServerLine.NextAcceptor(AInternal: Boolean; ANew: Boolean);
begin
  if ANew then
    NewCall(GetUniqueID);
  if Assigned(FSearchThread) then
    FSearchThread.Cancel
  else
    StartSearchThread(true);
end;

procedure TBisCallServerLine.ChannelRing(Channel: TBisCallServerChannel);
begin
  LoggerWrite(FSChannelRingStart,Channel);
  case Channel.Location of
    clInternal: begin
      if Channel=FInChannel then begin
        StartSearchThread(false);
      end else if not Assigned(FOutChannel) then begin
        SetOutChannel(Channel);
        FDateFound:=Core.ServerDate;
        FAcceptorId:=FTempAcceptorId;
        if Assigned(FSearchThread) then
           FSearchThread.Accept;
      end;
    end;
    clExternal: begin
      if Channel=FInChannel then begin
        Channel.Answer;
        RefreshCodeMessages;
      end else if not Assigned(FOutChannel) then begin
        SetOutChannel(Channel);
        FDateFound:=Core.ServerDate;
        if Assigned(FSearchThread) then
           FSearchThread.Accept;
      end;
    end;
  end;
end;

procedure TBisCallServerLine.ChannelCancel(Channel: TBisCallServerChannel);
begin
  LoggerWrite(FSChannelCancelStart,Channel);
  case Channel.Location of
    clInternal: begin
      if Channel=FInChannel then
        //
      else if Channel=FOutChannel then
        //
      else begin
        SetChannelProps(Channel,false);
        NextAcceptor(true,false);
      end;
    end;
  end;
end;

procedure TBisCallServerLine.ChannelConnect(Channel: TBisCallServerChannel);
begin
  LoggerWrite(FSChannelConnectStart,Channel);
  case Channel.Location of
    clInternal: begin
      if Channel=FOutChannel then begin
        if Assigned(FInChannel) then begin
          StopSearchThread(true);
          FDateBegin:=Core.ServerDate;
          FInChannel.OutFormat:=FOutChannel.InFormat;
          FInChannel.PlayStop;
//          FInChannel.SendStart;
        end;
      end;
    end;
    clExternal: begin
      if Channel=FInChannel then begin
        FDtmfStream.Clear;
        if not PlayGreeting(Channel) then begin
          PlayHolding(Channel);
          StartSearchThread(true);
        end;
      end else if Channel=FOutChannel then begin
        if Assigned(FInChannel) then begin
          FDateBegin:=Core.ServerDate;
          FInChannel.OutFormat:=FOutChannel.InFormat;
          FInChannel.OutDataSize:=FOutChannel.InDataSize;
          FInChannel.Answer;
          if Assigned(FSearchThread) then
            FSearchThread.Accept;
        end;
      end;
    end;
  end;
end;

procedure TBisCallServerLine.ChannelDisconnect(Channel: TBisCallServerChannel);
var
  Flag: Boolean;
begin
  LoggerWrite(FSChannelDisconnectStart,Channel);
  case Channel.Location of
    clInternal: begin
      if Channel=FInChannel then begin
        if Assigned(FOutChannel) then begin
          FOutChannel.OnDisconnect:=nil;
          try
            Flag:=FOutChannel.State in [csProcessing,csHolding];
            SaveCall(iff(Flag,lteCallerClose,lteCallerCancel));
            FOutChannel.Hangup;
            StopSearchThread(false);
          finally
            FOutChannel.OnDisconnect:=ChannelDisconnect;
          end;
        end else begin
          SaveCall(lteCallerCancel);
          if Assigned(FSearchThread) then
            FSearchThread.Cancel;
        end;
      end else if Channel=FOutChannel then begin
        if Assigned(FInChannel) then begin
          Flag:=FOutChannel.State in [csProcessing,csHolding];
          SaveCall(iff(Flag,lteAcceptorClose,lteAcceptorCancel));
          if Flag then begin
            FInChannel.OnDisconnect:=nil;
            try
              FInChannel.Hangup;
            finally
              FInChannel.OnDisconnect:=ChannelDisconnect;
            end;
          end else begin
            case FInChannel.State of
              csProcessing: begin
                SetOutChannel(nil);
                NextAcceptor(true,true);
              end;
              csFinished: StopSearchThread(false);
            end;
          end;
        end else begin
          SaveCall(lteServerClose);
          StopSearchThread(false);
        end;
      end else if not Assigned(FOutChannel) then begin
        if Assigned(FInChannel) then begin
          Flag:=Channel.State in [csProcessing,csHolding];
          SaveCall(iff(Flag,lteAcceptorClose,lteAcceptorCancel));
          if Flag then begin
            FInChannel.OnDisconnect:=nil;
            try
              FInChannel.Hangup;
            finally
              FInChannel.OnDisconnect:=ChannelDisconnect;
            end;
          end else
            NextAcceptor(true,true);
        end;
      end;
    end;
    clExternal: begin
      if Channel=FInChannel then begin
        if Assigned(FOutChannel) then begin
          FOutChannel.OnDisconnect:=nil;
          try
            Flag:=FOutChannel.State in [csProcessing,csHolding];
            SaveCall(iff(Flag,lteCallerClose,lteCallerCancel));
            FOutChannel.Hangup;
          finally
            FOutChannel.OnDisconnect:=ChannelDisconnect;
          end;
        end else begin
          SaveCall(lteCallerCancel);
        end;
      end else if Channel=FOutChannel then begin
        if Assigned(FInChannel) then begin
          FInChannel.OnDisconnect:=nil;
          try
            Flag:=FOutChannel.State in [csProcessing,csHolding];
            SaveCall(iff(Flag,lteAcceptorClose,lteAcceptorCancel));
            FInChannel.Hangup;
          finally
            FInChannel.OnDisconnect:=ChannelDisconnect;
          end;
        end;
      end;
    end;
  end;
end;

procedure TBisCallServerLine.ChannelCode(Channel: TBisCallServerChannel; const Code: Char);
begin
  case Channel.Location of
    clExternal: begin
      if Channel=FInChannel then begin
        if FServer.FDtmfEnabled then
          DtmfCode(nil,Code);
      end;
    end;
  end;
end;

procedure TBisCallServerLine.ChannelData(Channel: TBisCallServerChannel; const Data: Pointer; const DataSize: Cardinal);

  procedure DetectDtmf(Stream: TStream);
  var
    MaxCount: Integer;
    Temp: TMemoryStream;
    OldPos: Int64;
  begin
    OldPos:=Stream.Position;
    try
      MaxCount:=FServer.FDtmfThreshold;
      if (FDtmfStream.Size>MaxCount) then begin
        Temp:=TMemoryStream.Create;
        try
          FDtmfStream.Position:=0;
          FDtmf.LoadFromStream(FDtmfStream);
          FDtmfStream.Position:=Stream.Size;
          Temp.CopyFrom(FDtmfStream,FDtmfStream.Size-FDtmfStream.Position);
          Temp.CopyFrom(Stream,Stream.Size);
          Temp.Position:=0;
          FDtmfStream.Clear;
          FDtmfStream.CopyFrom(Temp,Temp.Size);
        finally
          Temp.Free;
        end;
      end else begin
        FDtmfStream.Position:=FDtmfStream.Size;
        FDtmfStream.CopyFrom(Stream,Stream.Size);
      end;
    finally
      Stream.Position:=OldPos;
    end;
  end;

  function MakeInStream(Format: PWaveFormatEx; Volume: Integer; AData: Pointer; ADataSize: Cardinal; Stream: TStream): Boolean;
  var
    Converter: TBisWaveConverter;
    OldPos: Int64;
  begin
    Result:=false;
    if Assigned(Format) then begin
      OldPos:=Stream.Position;
      Converter:=TBisWaveConverter.Create;
      try
        Converter.BeginRewrite(Format);
        Converter.Write(AData^,ADataSize);
        Converter.EndRewrite;
        if Converter.ConvertTo(@FInternalFormat) then begin
          Converter.ChangeVolume(Volume);
          Converter.Stream.Position:=Converter.DataOffset;
          Stream.CopyFrom(Converter.Stream,Converter.Stream.Size-Converter.Stream.Position);
          Result:=true;
        end;
      finally
        Converter.Free;
        Stream.Position:=OldPos;
      end;
    end;
  end;

  function MakeOutStream(Format: PWaveFormatEx; AData: Pointer; ADataSize: Cardinal; Stream: TStream): Boolean;
  var
    Converter: TBisWaveConverter;
    OldPos: Int64;
  begin
    Result:=false;
    if Assigned(Format) then begin
      OldPos:=Stream.Position;
      Converter:=TBisWaveConverter.Create;
      try
        Converter.BeginRewrite(@FInternalFormat);
        Converter.Write(AData^,ADataSize);
        Converter.EndRewrite;
        if Converter.ConvertTo(Format) then begin
          Converter.Stream.Position:=Converter.DataOffset;
          Stream.CopyFrom(Converter.Stream,Converter.Stream.Size-Converter.Stream.Position);
          Result:=true;
        end;
      finally
        Converter.Free;
        Stream.Position:=OldPos;
      end;
    end;
  end;

  procedure SendOut(AChannel: TBisCallServerChannel; Format: PWaveFormatEx; Stream: TMemoryStream);
  var
    OutStream: TMemoryStream;
  begin
    if Assigned(AChannel) and (AChannel.State=csProcessing) then begin
      OutStream:=TMemoryStream.Create;
      try
        if MakeOutStream(Format,Stream.Memory,Stream.Size,OutStream) then
          AChannel.Send(OutStream.Memory,OutStream.Size);
      finally
        OutStream.Free;
      end;
    end;
  end;

var
  Stream: TMemoryStream;
begin
  FLock.Enter;
  Stream:=TMemoryStream.Create;
  try
    if Channel=FInChannel then begin
      FInStream.Write(Data^,DataSize);
      if MakeInStream(Channel.InFormat,Channel.Volume,Data,DataSize,Stream) then begin
        if (Channel.Location=clExternal) and FServer.FDtmfEnabled then
          DetectDtmf(Stream);
        SendOut(FOutChannel,Channel.InFormat,Stream);
      end;
    end else if Channel=FOutChannel then begin
      FOutStream.Write(Data^,DataSize);
      if MakeInStream(Channel.InFormat,Channel.Volume,Data,DataSize,Stream) then
        SendOut(FInChannel,Channel.InFormat,Stream);
    end;
  finally
    Stream.Free;
    FLock.Leave;
  end;
end;

procedure TBisCallServerLine.ChannelHold(Channel: TBisCallServerChannel);
begin
  LoggerWrite(FSChannelHoldStart,Channel);
  case Channel.Location of
    clInternal: begin
      if Channel=FInChannel then begin
        if Assigned(FOutChannel) then begin
          FHoldCount:=0;
          FNeedNotFound:=false;
          PlayHolding(FOutChannel);
        end;
      end else if Channel=FOutChannel then begin
        if Assigned(FInChannel) then begin
          FHoldCount:=0;
          FNeedNotFound:=false;
          PlayHolding(FInChannel);
        end;
      end;
    end;
    clExternal: begin
      if Channel=FInChannel then begin

      end;
    end;
  end;
end;

procedure TBisCallServerLine.ChannelUnHold(Channel: TBisCallServerChannel);
begin
  LoggerWrite(FSChannelUnHoldStart,Channel);
  case Channel.Location of
    clInternal: begin
      if Channel=FOutChannel then begin
        if Assigned(FInChannel) then begin
          FInChannel.PlayStop;
//          FInChannel.SendStart;
        end;
      end else if Channel=FInChannel then begin
        if Assigned(FOutChannel) then begin
          FOutChannel.PlayStop;
//          FOutChannel.SendStart;
        end;
      end;
    end;
    clExternal: begin
      if Channel=FInChannel then begin

      end;
    end;
  end;
end;

procedure TBisCallServerLine.ChannelPlayBegin(Channel: TBisCallServerChannel);
begin
  LoggerWrite(FSChannelPlayBeginStart,Channel);
  case Channel.Location of
    clExternal: begin
      if Channel=FInChannel then begin
        case FPlayState of
          lpsHolding: Inc(FHoldCount);
        end;
      end;
    end;
  end;
end;

procedure TBisCallServerLine.ChannelPlayEnd(Channel: TBisCallServerChannel);
begin
  LoggerWrite(FSChannelPlayEndStart,Channel);
  case Channel.Location of
    clInternal: begin
    end;
    clExternal: begin
      case FPlayState of
        lpsGreeting: begin
          PlayHolding(Channel);
          StartSearchThread(true);
        end;
        lpsHolding: begin
          if FNeedNotFound then begin
            if not Assigned(FOutChannel) or
               (Assigned(FOutChannel) and not FOutChannel.Active) then begin
              if FServer.FMaxHoldCount>(FHoldCount+1) then begin
                PlayNotfound(Channel);
              end else begin
                FTypeEnd:=iff(VarIsNull(FTypeEnd),lteServerClose,Null);
                FDateEnd:=Core.ServerDate;
                FAlreadySaved:=false;
                Channel.Hangup;
              end;
            end;
          end else
            if not PlayHolding(Channel) then begin
              FTypeEnd:=iff(VarIsNull(FTypeEnd),lteServerClose,Null);
              FDateEnd:=Core.ServerDate;
              FAlreadySaved:=false;
              Channel.Hangup;
            end;
        end;
        lpsNotfound: begin
          if not PlayHolding(Channel) then begin
            FTypeEnd:=iff(VarIsNull(FTypeEnd),lteServerClose,Null);
            FDateEnd:=Core.ServerDate;
            FAlreadySaved:=false;
            Channel.Hangup;
          end;
        end;
        lpsConfirm: begin
          FTypeEnd:=iff(VarIsNull(FTypeEnd),lteServerClose,Null);
          FDateEnd:=Core.ServerDate;
          FAlreadySaved:=false;
          Channel.Hangup;
        end;
        lpsWrong: begin
          if not PlayHolding(Channel) then begin
            FTypeEnd:=iff(VarIsNull(FTypeEnd),lteServerClose,Null);
            FDateEnd:=Core.ServerDate;
            FAlreadySaved:=false;
            Channel.Hangup;
          end;
        end;
      end;
    end;
  end;
end;

procedure TBisCallServerLine.ChannelError(Channel: TBisCallServerChannel; const Error: String);
begin
  LoggerWrite(FormatEx(FSChannelError,[Error]),Channel);
end;

procedure TBisCallServerLine.ChannelTimeout(Channel: TBisCallServerChannel);
begin
  LoggerWrite(FSChannelTimeOutStart,Channel);
  if not Assigned(FOutChannel) then
    NextAcceptor(true,false);
end;

{ TBisCallServerLines }

destructor TBisCallServerLines.Destroy;
begin
  inherited Destroy;
end;

function TBisCallServerLines.GetItem(Index: Integer): TBisCallServerLine;
begin
  Result:=TBisCallServerLine(inherited Items[Index]);
end;

function TBisCallServerLines.Find(Channel: TBisCallServerChannel): TBisCallServerLine;
var
  Direction: TBisCallServerChannelDirection;
  i: Integer;
  Item: TBisCallServerLine;
  Found: Boolean;
begin
  Result:=nil;
  if Assigned(Channel) then begin
    Direction:=Channel.Direction;
    if Direction<>cdUnknown then begin
      for i:=0 to Count-1 do begin
        Item:=Items[i];
        Found:=false;
        case Direction of
          cdIncoming: Found:=Item.InChannel=Channel;
          cdOutgoing: begin
            Found:=Item.OutChannel=Channel;
            if not Found then begin
              if Assigned(Item.FSearchThread) and
                 (Item.FSearchThread.FChannel=Channel) then
                Found:=true; 
            end;
          end;
        end;
        if Found then begin
          Result:=Item;
          exit;
        end;
      end;
    end;
  end;
end;

function TBisCallServerLines.Add(Channel: TBisCallServerChannel; Server: TBisCallServer): TBisCallServerLine;
begin
  Result:=nil;
  if Assigned(Channel) then begin
    if (Channel.Direction=cdIncoming) then begin
      Result:=TBisCallServerLine.Create(Server);
      if Assigned(Result) then begin
        Result.InChannel:=Channel;
        inherited Add(Result);
      end;
    end;
  end;
end;

procedure TBisCallServerLines.Remove(Channel: TBisCallServerChannel);
var
  Line: TBisCallServerLine;
  NeedFree: Boolean;
begin
  if Assigned(Channel) then begin
    Line:=Find(Channel);
    if Assigned(Line) then begin

      if Channel=Line.FInChannel then begin
        Line.SetInChannel(nil);
      end else if Channel=Line.FOutChannel then begin
        Line.SetOutChannel(nil);
      end else begin
        if Assigned(Line.FSearchThread) and
           Assigned(Line.FSearchThread.FChannel) then begin
          Line.SetChannelProps(Line.FSearchThread.FChannel,false);
      //    Line.FSearchThread.FChannel:=nil;
        end;
      end;

      NeedFree:=not Assigned(Line.InChannel) and
                not Assigned(Line.OutChannel){ and
                not Assigned(Line.FSearchThread)};

      if NeedFree then begin
        Line.SaveCall(Line.FTypeEnd);
        inherited Remove(Line);
      end;
    end;
  end;
end;

{ TBisCallServer }

constructor TBisCallServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Params.OnChange:=ChangeParams;

  FGreetingStream:=TMemoryStream.Create;
  FHoldingStream:=TMemoryStream.Create;
  FConfirmStream:=TMemoryStream.Create;
  FWrongStream:=TMemoryStream.Create;
  FNotfoundStream:=TMemoryStream.Create;
  FMaxHoldCount:=3;
  FDtmfEnabled:=false;
  FDtmfThreshold:=900;
  FDtmfInterval:=250;
  FPCMFormat:=Mono16bit8000Hz;
  FSearchInterval:=1000;
  FInternalTimeout:=10000;
  FExternalTimeout:=30000;
  FCommandTimeout:=5000;

  FLines:=TBisCallServerLines.Create;

  FModules:=TBisCallServerHandlerModules.Create(Self);
  FModules.OnCreateModule:=ModulesCreateModule;

  FSStart:='�������� �������...';
  FSStartSuccess:='������ ��������� �������.';
  FSStartFail:='������ ��������� � �������: %s';
  FSStop:='�������� �������...';
  FSStopSuccess:='������ ��������� �������.';
  FSStopFail:='������ ��������� � �������: %s';

end;

destructor TBisCallServer.Destroy;
begin
  FModules.Free;
  FLines.Free;
  FNotfoundStream.Free;
  FWrongStream.Free;
  FConfirmStream.Free;
  FHoldingStream.Free;
  FGreetingStream.Free;
  inherited Destroy;
end;

function TBisCallServer.GetStarted: Boolean;
begin
  Result:=FActive;
end;

procedure TBisCallServer.Init;
begin
  inherited Init;
  FModules.Init;
end;

procedure TBisCallServer.ChangeParams(Sender: TObject);
var
  i: Integer;
  Param: TBisServerParam;
  Stream: TMemoryStream;
begin
  for i:=0 to Params.Count-1 do begin
    Param:=Params.Items[i];

    if AnsiSameText(Param.ParamName,SParamModules) then begin
      Stream:=TMemoryStream.Create;
      try
        Stream.WriteBuffer(Pointer(Param.Value)^,Length(Param.Value));
        if Stream.Size>0 then begin
          Stream.Position:=0;
          FModules.Table.Close;
          FModules.Table.LoadFromStream(Stream);
          FModules.Table.Open;
        end;
      finally
        Stream.Free;
      end;
    end;

    if AnsiSameText(Param.ParamName,SParamGreetingMusic) then begin
      FGreetingStream.Clear;
      FGreetingStream.Write(Pointer(Param.Value)^,Length(Param.Value));
      FGreetingStream.Position:=0;
    end;

    if AnsiSameText(Param.ParamName,SParamHoldingMusic) then begin
      FHoldingStream.Clear;
      FHoldingStream.Write(Pointer(Param.Value)^,Length(Param.Value));
      FHoldingStream.Position:=0;
    end;

    if AnsiSameText(Param.ParamName,SParamConfirmMusic) then begin
      FConfirmStream.Clear;
      FConfirmStream.Write(Pointer(Param.Value)^,Length(Param.Value));
      FConfirmStream.Position:=0;
    end;

    if AnsiSameText(Param.ParamName,SParamWrongMusic) then begin
      FWrongStream.Clear;
      FWrongStream.Write(Pointer(Param.Value)^,Length(Param.Value));
      FWrongStream.Position:=0;
    end;

    if AnsiSameText(Param.ParamName,SParamNotfoundMusic) then begin
      FNotfoundStream.Clear;
      FNotfoundStream.Write(Pointer(Param.Value)^,Length(Param.Value));
      FNotfoundStream.Position:=0;
    end;

    if AnsiSameText(Param.ParamName,SParamMaxHoldCount) then FMaxHoldCount:=StrToIntDef(Param.Value,FMaxHoldCount);
    if AnsiSameText(Param.ParamName,SParamDtmfEnabled) then FDtmfEnabled:=Boolean(StrToIntDef(Param.Value,Integer(FDtmfEnabled)));
    if AnsiSameText(Param.ParamName,SParamDtmfThreshold) then FDtmfThreshold:=StrToIntDef(Param.Value,FDtmfThreshold);
    if AnsiSameText(Param.ParamName,SParamDtmfInterval) then FDtmfInterval:=StrToIntDef(Param.Value,FDtmfInterval);
    if AnsiSameText(Param.ParamName,SParamPCMFormat) then FPCMFormat:=TPCMFormat(StrToIntDef(Param.Value,Integer(FPCMFormat)));

    if AnsiSameText(Param.ParamName,SParamConfirmSymbol) then begin
      FConfirmSymbol:=#0;
      if Length(Param.Value)>0 then
        FConfirmSymbol:=Param.Value[1];
    end;

    if AnsiSameText(Param.ParamName,SParamCancelSymbol) then begin
      FCancelSymbol:=#0;
      if Length(Param.Value)>0 then
        FCancelSymbol:=Param.Value[1];
    end;

    if AnsiSameText(Param.ParamName,SParamSearchInterval) then FSearchInterval:=StrToIntDef(Param.Value,Integer(FSearchInterval));
    if AnsiSameText(Param.ParamName,SParamInternalTimeout) then FInternalTimeout:=StrToIntDef(Param.Value,Integer(FInternalTimeout));
    if AnsiSameText(Param.ParamName,SParamExternalTimeout) then FExternalTimeout:=StrToIntDef(Param.Value,Integer(FExternalTimeout));
    if AnsiSameText(Param.ParamName,SParamCommandTimeout) then FCommandTimeout:=StrToIntDef(Param.Value,Integer(FCommandTimeout));

  end;
end;

procedure TBisCallServer.ModulesCreateModule(Modules: TBisModules; Module: TBisModule);
begin
  if Assigned(Module) and (Module is TBisCallServerHandlerModule) then begin
    TBisCallServerHandlerModule(Module).Handlers.OnCreateHandler:=HandlersCreateHandler;
  end;
end;

procedure TBisCallServer.HandlersCreateHandler(Handlers: TBisCallServerHandlers; Handler: TBisCallServerHandler);
begin
  if Assigned(Handler) then begin
    Handler.Channels.OnCreateChannel:=ChannelsCreateChannel;
    Handler.Channels.OnDestroyChannel:=ChannelsDestroyChannel;
  end;
end;

procedure TBisCallServer.ChannelsCreateChannel(Channels: TBisCallServerChannels; Channel: TBisCallServerChannel);
var
  Line: TBisCallServerLine;
begin
  Line:=FLines.Add(Channel,Self);
  if Assigned(Line) then ;
end;

procedure TBisCallServer.ChannelsDestroyChannel(Channels: TBisCallServerChannels; Channel: TBisCallServerChannel);
begin
  FLines.Remove(Channel);
end;

procedure TBisCallServer.Start;
begin
  LoggerWrite(FSStart);
  try
    FLines.Clear;
    FModules.Load;
    FModules.Connect;
    FActive:=true;
    LoggerWrite(FSStartSuccess);
  except
    On E: Exception do begin
      LoggerWrite(FormatEx(FSStartFail,[E.Message]),ltError);
    end;
  end;
end;

procedure TBisCallServer.Stop;
begin
  LoggerWrite(FSStop);
  try
    FModules.Disconnect;
    FModules.Unload;
    FActive:=false;
    LoggerWrite(FSStopSuccess);
  except
    On E: Exception do begin
      LoggerWrite(FormatEx(FSStopFail,[E.Message]),ltError);
    end;
  end;
end;

end.
