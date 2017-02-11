unit BisCallServerInit;

interface

uses Classes, Sysutils, Contnrs, DB, mmSystem, ExtCtrls, SyncObjs,
     WaveUtils,
     BisObject, BisCoreObjects, BisServers, BisModules, BisServerModules,               
     BisDataSet, BisDataParams, BisNotifyEvents, BisEvents, BisLogger,
     BisConnections, BisAudioWave, BisVariants, BisThreads, BisLocks,
     BisCallServerHandlers, BisCallServerChannels, BisCallServerScenarios,
     BisCallServerHandlerModules;

type
  TBisCallServer=class;
  TBisCallServerLine=class;

  TBisCallServerLineChannelWay=(lcwInvalid,lcwIncomingExternal,lcwIncomingInternal,
                                           lcwOutgoingExternal,lcwOutgoingInternal,
                                           lcwSearchExternal,lcwSearchInternal);
  TBisCallServerLineTypeEnd=(lteServerClose,lteCallerClose,lteAcceptorClose,lteServerCancel,
                             lteCallerCancel,lteAcceptorCancel,lteTimeout);

  TBisCallServerLinePlayObj=class(TBisLock)
  end;

  TBisCallServerLinePlayEndProc=procedure (Channel: TBisCallServerChannel;
                                           Obj: TBisCallServerLinePlayObj;
                                           Finished,Terminated: Boolean; Position: Cardinal) of object;

  TBisCallServerLineMenuList=class(TBisLocks)
  private
    function GetItem(Index: Integer): TBisCallServerScenarioMenu;
  public
    function Empty: Boolean;
    function Last: TBisCallServerScenarioMenu;
    function Path: String;

    property Items[Index: Integer]: TBisCallServerScenarioMenu read GetItem; default;
  end;

  TBisCallServerLine=class(TBisLock)
  private
    FServer: TBisCallServer;
    FScenario: TBisCallServerScenario;
    FMenuList: TBisCallServerLineMenuList;

    FInternalFormat: TWaveFormatEx;

    FSearchThread: TBisWaitThread;
    FSearchEvent: TEvent;
    FSearchLocation: TBisCallServerHandlerLocation;
    FSearchAcceptorType: TBisCallServerChannelAcceptorType;
    FSearchAcceptor: Variant;
    FSearchCanceled: Boolean;

    FInPlayThread: TBisWaitThread;
    FOutPlayThread: TBisWaitThread;

    FInStream: TMemoryStream;
    FOutStream: TMemoryStream;
    FInLockStream: TCriticalSection;
    FOutLockStream: TCriticalSection;
    FLockSaveCall: TCriticalSection;

    FCodeMessages: TBisDataSet;
    FInChannel: TBisCallServerChannel;
    FOutChannel: TBisCallServerChannel;

    FDataFormat: PWaveFormatEx;

    FAlreadySaved: Boolean;
    FNotAnswered: Boolean;
    FReadyForTalk: Boolean; 

    FId: Variant;
    FCurrentCallId: Variant;
    FCallResultId: Variant;
    FDirection: Variant;
    FOperatorId: Variant;
    FFirmId: Variant;
    FCreatorId: Variant;
    FDateCreate: Variant;
    FCallerId: Variant;
    FCallerName: Variant;
    FCallerPatronymic: Variant;
    FCallerPhone: Variant;
    FCallerDiversion: Variant;
    FAcceptorId: Variant;
    FAcceptorPhone: Variant;
    FDateFound: Variant;
    FDateBegin: Variant;
    FDateEnd: Variant;
    FTypeEnd: Variant;
    FCallerAudio: TMemoryStream;
    FAcceptorAudio: TMemoryStream;
    FInChannelName: Variant;
    FOutChannelName: Variant;

    FSLineFormat: String;
    FSCommand: String;
    FSCommandError: String;
    FSIncomingCall: String;
    FSOutgoingCall: String;
    FSChannelCheckStart: String;
    FSAcceptorDial: String;
    FSSearchStart: String;
    FSChannelRingStart: String;
    FSChannelBusyStart: String;
    FSChannelConnectStart: String;
    FSChannelDisconnectStart: String;
    FSChannelCodeStart: String;
    FSChannelCodeFound: String;
    FSChannelHoldStart: String;
    FSChannelUnHoldStart: String;
    FSChannelError: String;
    FSChannelTimeOutStart: String;
    FSChannelCheckFail: String;
    FSChannelRingFail: String;
    FSChannelBusyFail: String;
    FSChannelConnectFail: String;
    FSChannelDisconnectFail: String;
    FSChannelCodeFail: String;
    FSChannelHoldFail: String;
    FSChannelUnHoldFail: String;
    FSChannelTimeOutFail: String;
    FSChannelDataStart: String;
    FSChannelDataFail: String;
    FSChannelPlayStart: String;
    FSChannelPlayFail: String;
    FSChannelStopStart: String;
    FSChannelStopFail: String;
    FSScenarioStep: String;

    function ChannelNotFinished(Channel: TBisCallServerChannel): Boolean;
    function ChannelWorking(Channel: TBisCallServerChannel): Boolean;

    procedure PlayStart(Channel: TBisCallServerChannel;
                        Obj: TBisCallServerLinePlayObj;  
                        EndProc: TBisCallServerLinePlayEndProc;
                        Wave: TBisAudioWave; Infinite: Boolean);
    procedure PlayStop(Channel: TBisCallServerChannel);

    function GetWaveWithConsts(Channel: TBisCallServerChannel; Text: String; Wave: TBisAudioWave): Boolean;
    procedure GetWaveByTextWithTimeout(Channel: TBisCallServerChannel; Text: String; Timeout: Cardinal; Wave: TBisAudioWave);

    procedure StepPlayStart(Channel: TBisCallServerChannel; Step: TBisCallServerScenarioStep);
    procedure StepPlayEnd(Channel: TBisCallServerChannel; Obj: TBisCallServerLinePlayObj;
                          Finished,Terminated: Boolean; Position: Cardinal);

    procedure MenusPlayStart(Channel: TBisCallServerChannel; Text: String;
                             Timeout: Cardinal; Menus: TBisCallServerScenarioMenus);

    procedure MenuPlayStart(Channel: TBisCallServerChannel; Wave: TBisAudioWave;
                            Menu: TBisCallServerScenarioMenu; OutMessageIds: TBisVariants);
    procedure MenuPlayEnd(Channel: TBisCallServerChannel; Obj: TBisCallServerLinePlayObj;
                          Finished,Terminated: Boolean; Position: Cardinal);

    procedure ChannelPlayEnd(Channel: TBisCallServerChannel; Obj: TBisCallServerLinePlayObj;
                             Finished,Terminated: Boolean; Position: Cardinal);

    procedure UnLockOutMessages(Channel: TBisCallServerChannel; OutMessageIds: TBisVariants; Sent: Boolean);

    procedure SetTypeEnd(TE: TBisCallServerLineTypeEnd);
    function Way(Channel: TBisCallServerChannel): TBisCallServerLineChannelWay;
    procedure LoggerWrite(const Message: String; Channel: TBisCallServerChannel=nil; LogType: TBisLoggerType=ltInformation);

    function InsertCall(CallId: Variant): Variant;
    function UpdateCall: Boolean;
    procedure SaveCall(WithDateEnd: Boolean);
    function NewCall(CallId: Variant): Boolean;

    procedure SearchStart(Location: TBisCallServerHandlerLocation; AcceptorType: TBisCallServerChannelAcceptorType; Acceptor: Variant);
    procedure SearchStop;
    procedure SearchAccept;
    procedure SearchCancel;
    procedure SearchNext(AsNew: Boolean);
    procedure SearchThreadTimeout(Thread: TBisWaitThread);
    procedure SearchThreadEnd(Thread: TBisThread);
    procedure SearchThreadError(Thread: TBisThread; const E: Exception);

    procedure SetChannelProps(Channel: TBisCallServerChannel; Enabled: Boolean);
    procedure SetInChannel(const Value: TBisCallServerChannel);
    procedure SetOutChannel(const Value: TBisCallServerChannel);

    function ConvertData(InFormat,OutFormat: PWaveFormatEx; InData: Pointer; InSize: Cardinal;
                         OutStream: TMemoryStream; OnlyData: Boolean=true): Boolean;

    procedure ChannelPlay(Channel: TBisCallServerChannel; Wave: TBisAudioWave);
    procedure ChannelStop(Channel: TBisCallServerChannel);
    procedure ChannelRing(Channel: TBisCallServerChannel);
    procedure ChannelConnect(Channel: TBisCallServerChannel);
    procedure ChannelDisconnect(Channel: TBisCallServerChannel);
    function ChannelCheck(Channel: TBisCallServerChannel): Boolean;
    procedure ChannelBusy(Channel: TBisCallServerChannel);
    procedure ChannelCode(Channel: TBisCallServerChannel; const Code: Char);
    procedure SendData(Channel: TBisCallServerChannel; Format: PWaveFormatEx; const Data: Pointer; const DataSize: LongWord);
    procedure PlayData(Channel: TBisCallServerChannel; Format: PWaveFormatEx; const Data: Pointer; const DataSize: LongWord);
    procedure ChannelData(Channel: TBisCallServerChannel; const Data: Pointer; const DataSize: LongWord);
    procedure ChannelHold(Channel: TBisCallServerChannel);
    procedure ChannelUnHold(Channel: TBisCallServerChannel);
    procedure ChannelError(Channel: TBisCallServerChannel; const Error: String);
    procedure ChannelTimeout(Channel: TBisCallServerChannel);

    function CanFree: Boolean;
    procedure TryRemoveChannels;
    function RemoveByChannel(Channel: TBisCallServerChannel): Boolean;


  public
    constructor Create(Server: TBisCallServer); reintroduce;
    destructor Destroy; override;

    property SLineFormat: String read FSLineFormat write FSLineFormat;
    property SCommand: String read FSCommand write FSCommand;
    property SScenarioStep: String read FSScenarioStep write FSScenarioStep; 
  end;

  TBisCallServerLines=class(TBisLocks)
  private
    function GetItem(Index: Integer): TBisCallServerLine;
  protected
    procedure DoItemRemove(Item: TObject); override;  
  public
    destructor Destroy; override;
    function Find(Channel: TBisCallServerChannel): TBisCallServerLine;
    function LockFind(Channel: TBisCallServerChannel): TBisCallServerLine;
    function AddChannel(Channel: TBisCallServerChannel; Server: TBisCallServer): TBisCallServerLine; reintroduce;
    function LockAddChannel(Channel: TBisCallServerChannel; Server: TBisCallServer): TBisCallServerLine;
    procedure RemoveByChannel(Channel: TBisCallServerChannel);
    procedure LockRemoveByChannel(Channel: TBisCallServerChannel);

    property Items[Index: Integer]: TBisCallServerLine read GetItem; default;
  end;

  TBisCallServer=class(TBisServer)
  private
    FLines: TBisCallServerLines;
    FModules: TBisCallServerHandlerModules;
    FScenarios: TBisCallServerScenarios;
    FActive: Boolean;
    FInternalFormat: TPCMFormat;
    FSearchInterval: Integer;
    FPacketTime: Word;
    FSweepInterval: Cardinal;
    FDialMusic: TBisAudioWave;
    FHoldMusic: TBisAudioWave;
    FSweepThread: TBisWaitThread;

    procedure SweepThreadTimeout(Thread: TBisWaitThread);
    procedure ChangeParams(Sender: TObject);
    procedure ModulesCreateModule(Modules: TBisModules; Module: TBisModule);
    procedure HandlersCreateHandler(Handlers: TBisCallServerHandlers; Handler: TBisCallServerHandler);
    procedure ChannelsCreate(Channels: TBisCallServerChannels; Channel: TBisCallServerChannel);
    procedure ChannelsDestroy(Channels: TBisCallServerChannels; Channel: TBisCallServerChannel);
  protected
    function GetStarted: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure Start; override;
    procedure Stop; override;

  end;

procedure InitServerModule(AModule: TBisServerModule); stdcall;

exports
  InitServerModule;

implementation

uses Windows, Dialogs, Variants, TypInfo, StrUtils,
     AsyncCalls,
     WaveStorage,
     BisCore, BisConsts, BisUtils, BisProvider, BisConfig, BisFilterGroups,
     BisValues, BisParams, BisAudioUtils, BisDeadlocks,  
     BisCallServerConsts;


procedure InitServerModule(AModule: TBisServerModule); stdcall;
begin
  AModule.ServerClass:=TBisCallServer;
end;

type
  TBisCallServerLineSearchThread=class(TBisWaitThread)
  end;

  TBisCallServerLinePlayThreadObject=class(TBisLock)
  end;

  TBisCallServerLinePlayThread=class(TBisWaitThread)
  private
    FPosition: LongWord;
    FLine: TBisCallServerLine;
    FChannel: TBisCallServerChannel;
    FEndProc: TBisCallServerLinePlayEndProc;
    FWave: TBisAudioWave;
    FInfinite: Boolean;
    FObj: TBisCallServerLinePlayObj;
  protected
    procedure DoTimeout; override;
    procedure DoEnd; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function CanStart: Boolean; override;
    procedure Start(Wait: Boolean=false); overload; override;   
    procedure Start(Timeout: Cardinal; Line: TBisCallServerLine;
                    Channel: TBisCallServerChannel;
                    Obj: TBisCallServerLinePlayObj;
                    EndProc: TBisCallServerLinePlayEndProc;
                    Wave: TBisAudioWave; Infinite: Boolean); reintroduce; overload; 
    procedure CleanUp;
  end;

  TBisCallServerLinePlayInThread=class(TBisCallServerLinePlayThread)
  end;

  TBisCallServerLinePlayOutThread=class(TBisCallServerLinePlayThread)
  end;

{ TBisCallServerLinePlayThread }

constructor TBisCallServerLinePlayThread.Create;
begin
  inherited Create;
  RestrictByZero:=true;
  FWave:=TBisAudioWave.Create;
end;

destructor TBisCallServerLinePlayThread.Destroy;
begin
  Stop;
  CleanUp;
  FWave.Free;
  inherited Destroy;
end;

procedure TBisCallServerLinePlayThread.CleanUp;
begin
  FLine:=nil;
  FChannel:=nil;
  FObj:=nil;
  FEndProc:=nil;
end;

procedure TBisCallServerLinePlayThread.DoEnd;
var
  AObj: TBisCallServerLinePlayObj;
  NewPos: Cardinal;
begin
  try
    AObj:=FObj;
    if Assigned(FChannel) and Assigned(FEndProc) then begin
      NewPos:=FPosition+Timeout;
      FEndProc(FChannel,AObj,FWave.Length<=NewPos,Terminated,NewPos);
    end;
  finally
    FreeAndNilEx(AObj);
  end;
end;

procedure TBisCallServerLinePlayThread.DoTimeout;
var
  L,L2: Cardinal;
  W: TBisAudioWave;
  Data: Pointer;
begin
  L:=FWave.Length;
  if (FPosition+Timeout)<=L then begin
    W:=TBisAudioWave.Create;
    try
      W.Copy(FWave,FPosition,Timeout);
      if (W.Length=Timeout) then begin
        L:=W.DataSize;
        GetMem(Data,L);
        try
          L2:=W.Stream.Read(Data^,L);
          Inc(FPosition,Timeout);
          if Assigned(FLine) and Assigned(FChannel) then
            FLine.PlayData(FChannel,W.WaveFormat,Data,L2);
        finally
          FreeMem(Data,L);
        end;
      end;
    finally
      Reset;
      W.Free;
    end;
  end else
    if FInfinite and (L>0) then begin
      FPosition:=0;
      Reset;
    end;
end;

function TBisCallServerLinePlayThread.CanStart: Boolean;
begin
  Result:=inherited CanStart and (FWave.Length>0);
end;

procedure TBisCallServerLinePlayThread.Start(Wait: Boolean);
begin
  if CanStart then
    inherited Start(Wait)
  else
    DoEnd;
end;

procedure TBisCallServerLinePlayThread.Start(Timeout: Cardinal; Line: TBisCallServerLine;
                                             Channel: TBisCallServerChannel;
                                             Obj: TBisCallServerLinePlayObj;
                                             EndProc: TBisCallServerLinePlayEndProc;
                                             Wave: TBisAudioWave; Infinite: Boolean);
begin
  Self.Timeout:=Timeout;
  FPosition:=0;
  FLine:=Line;
  FChannel:=Channel;
  FObj:=Obj;
  FEndProc:=EndProc;
  FWave.Assign(Wave);
  FInfinite:=Infinite;
  Start;
end;

{ TBisCallServerLineMenuList }

function TBisCallServerLineMenuList.Empty: Boolean;
begin
  Result:=Count=0;
end;

function TBisCallServerLineMenuList.GetItem(Index: Integer): TBisCallServerScenarioMenu;
begin
  Result:=TBisCallServerScenarioMenu(inherited Items[Index]);
end;

function TBisCallServerLineMenuList.Last: TBisCallServerScenarioMenu;
begin
  Result:=nil;
  if not Empty then
    Result:=Items[Count-1];
end;

function TBisCallServerLineMenuList.Path: String;
var
  i: Integer;
  Item: TBisCallServerScenarioMenu;
begin
  Result:='';
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Result:=iff(i=0,Item.Name,Result+'/'+Item.Name);
  end;
end;

{ TBisCallServerLine }

constructor TBisCallServerLine.Create(Server: TBisCallServer);
begin
  inherited Create;
  FServer:=Server;

  FScenario:=nil;

  FMenuList:=TBisCallServerLineMenuList.Create;
  FMenuList.OwnsObjects:=false;

  FSearchThread:=TBisCallServerLineSearchThread.Create(FServer.FSearchInterval);
  FSearchThread.StopOnDestroy:=true;
  FSearchThread.OnTimeout:=SearchThreadTimeout;
  FSearchThread.OnEnd:=SearchThreadEnd;
  FSearchThread.OnError:=SearchThreadError;

  FSearchEvent:=TEvent.Create(nil,true,false,'');

  FInLockStream:=TCriticalSection.Create;
  FOutLockStream:=TCriticalSection.Create;
  FInStream:=TMemoryStream.Create;
  FOutStream:=TMemoryStream.Create;

  FLockSaveCall:=TCriticalSection.Create;

  FCodeMessages:=TBisDataSet.Create(nil);

  FillChar(FInternalFormat,SizeOf(FInternalFormat),0);
  SetPCMAudioFormatS(@FInternalFormat,FServer.FInternalFormat);

  FId:=GetUniqueID;
  FCurrentCallId:=Null;
  FCallResultId:=Null;
  FDirection:=Null;
  FOperatorId:=Null;
  FFirmId:=Null;
  FCreatorId:=Null;
  FDateCreate:=Null;
  FCallerId:=Null;
  FCallerName:=Null;
  FCallerPatronymic:=Null;
  FCallerPhone:=Null;
  FCallerDiversion:=Null;
  FAcceptorId:=Null;
  FAcceptorPhone:=Null;
  FDateFound:=Null;
  FDateBegin:=Null;
  FDateEnd:=Null;
  FTypeEnd:=Null;
  FInChannelName:=Null;
  FOutChannelName:=Null;
  
  FCallerAudio:=TMemoryStream.Create;
  FAcceptorAudio:=TMemoryStream.Create;

  FInPlayThread:=TBisCallServerLinePlayInThread.Create;
  FInPlayThread.StopOnDestroy:=true;

  FOutPlayThread:=TBisCallServerLinePlayOutThread.Create;
  FOutPlayThread.StopOnDestroy:=true;

  FSLineFormat:='%s: %s';
  FSScenarioStep:='�������� %s ��� = %s';

  FSCommand:='������� %s';
  FSCommandError:='������� %s ��������� � �������: %s';
  FSIncomingCall:='�������� �����';
  FSOutgoingCall:='��������� �����';
  FSAcceptorDial:='������ �� %s (%s)';
  FSSearchStart:='������ ������ ...';

  FSChannelCheckStart:='������ �������� (%s) ...';
  FSChannelCheckFail:='�������� �� ������. %s';
  FSChannelRingStart:='������ ...';
  FSChannelRingFail:='������ �� ������. %s';
  FSChannelBusyStart:='������ ...';
  FSChannelBusyFail:='������ �� ������. %s';
  FSChannelConnectStart:='����������� ...';
  FSChannelConnectFail:='����������� �� ������. %s';
  FSChannelDisconnectStart:='���������� ...';
  FSChannelDisconnectFail:='���������� �� ������. %s';
  FSChannelCodeStart:='��� (%s) ...';
  FSChannelCodeFound:='���� %s';
  FSChannelCodeFail:='��� �� ������. %s';
  FSChannelHoldStart:='��������� ...';
  FSChannelHoldFail:='��������� �� ������. %s';
  FSChannelUnHoldStart:='������ ��������� ...';
  FSChannelUnHoldFail:='������ ��������� �� ������. %s';
  FSChannelError:='%s';
  FSChannelTimeOutStart:='����� ������� ...';
  FSChannelTimeOutFail:='����� ������� �� ������. %s';
  FSChannelDataStart:='������ ...';
  FSChannelDataFail:='������ �� ������. %s';
  FSChannelPlayStart:='���������������� ������ ...';
  FSChannelPlayFail:='���������������� ������ �� ������. %s';
  FSChannelStopStart:='��������� ������ ...';
  FSChannelStopFail:='��������� ������ �� ������. %s';

end;

destructor TBisCallServerLine.Destroy;
begin
  SetTypeEnd(lteServerClose);
  SaveCall(true);

  FOutPlayThread.Free;
  FInPlayThread.Free;

  if Assigned(FOutChannel) then begin
    SetChannelProps(FOutChannel,false);
    FOutChannel.Hangup;
  end;
  if Assigned(FInChannel) then begin
    SetChannelProps(FInChannel,false);
    FInChannel.Hangup;
  end;

  FSearchEvent.SetEvent;
  FSearchThread.Free;
  FSearchEvent.Free;
  SetInChannel(nil);
  SetOutChannel(nil);
  FAcceptorAudio.Free;
  FCallerAudio.Free;
  FCodeMessages.Free;
  FLockSaveCall.Free;
  FOutStream.Free;
  FInStream.Free;
  FOutLockStream.Free;
  FInLockStream.Free;
  FMenuList.Free;
  FreeAndNilEx(FScenario);
  FServer:=nil;
  inherited Destroy;
end;

function TBisCallServerLine.ChannelNotFinished(Channel: TBisCallServerChannel): Boolean;
begin
  Result:=Assigned(Channel) and (Channel.State<>csFinished);
end;

function TBisCallServerLine.ChannelWorking(Channel: TBisCallServerChannel): Boolean;
begin
  Result:=Assigned(Channel) and (Channel.State in [csProcessing,csHolding]);
end;

procedure TBisCallServerLine.PlayStart(Channel: TBisCallServerChannel;
                                       Obj: TBisCallServerLinePlayObj;
                                       EndProc: TBisCallServerLinePlayEndProc;
                                       Wave: TBisAudioWave; Infinite: Boolean);
begin
  PlayStop(Channel);
  case Way(Channel) of
    lcwIncomingExternal,lcwIncomingInternal: begin
      TBisCallServerLinePlayInThread(FInPlayThread).Start(FServer.FPacketTime,Self,Channel,Obj,EndProc,Wave,Infinite);
    end;
    lcwOutgoingExternal,lcwOutgoingInternal: begin
      TBisCallServerLinePlayOutThread(FOutPlayThread).Start(FServer.FPacketTime,Self,Channel,Obj,EndProc,Wave,Infinite);
    end;
  end;
end;

procedure TBisCallServerLine.PlayStop(Channel: TBisCallServerChannel);
begin
  case Way(Channel) of
    lcwIncomingExternal,lcwIncomingInternal: FInPlayThread.Stop;
    lcwOutgoingExternal,lcwOutgoingInternal: FOutPlayThread.Stop;
  end;
end;

function TBisCallServerLine.GetWaveWithConsts(Channel: TBisCallServerChannel; Text: String; Wave: TBisAudioWave): Boolean;
var
  S: String;
begin
  Result:=false;
  if Assigned(Wave) and Wave.Valid then begin
    try
      S:=Text;
      S:=Trim(ReplaceText(S,'%NAME',VarToStrDef(FCallerName,'')));
      S:=Trim(ReplaceText(S,'%PATRONYMIC',VarToStrDef(FCallerPatronymic,'')));
      GetAudioTextWave(S,Wave);
      Result:=true;
    except
      On E: Exception do
        LoggerWrite(E.Message,Channel,ltError);
    end;
  end;
end;

procedure TBisCallServerLine.GetWaveByTextWithTimeout(Channel: TBisCallServerChannel; Text: String; Timeout: Cardinal; Wave: TBisAudioWave);
var
  W: TBisAudioWave;
begin
  if Assigned(Wave) and Wave.Valid then begin
    W:=TBisAudioWave.Create;
    try
      W.BeginRewrite(Wave.WaveFormat);
      W.EndRewrite;
      if GetWaveWithConsts(Channel,Text,W) then begin
        Wave.InsertSilence(Wave.Length,Timeout);
        Wave.Insert(Wave.Length,W);
      end;
    finally
      W.Free;
    end;
  end;
end;

procedure TBisCallServerLine.SetTypeEnd(TE: TBisCallServerLineTypeEnd);
begin
  if VarIsNull(FTypeEnd) then begin
    FTypeEnd:=TE;
    FAlreadySaved:=false;
  end;
end;

function TBisCallServerLine.Way(Channel: TBisCallServerChannel): TBisCallServerLineChannelWay;
begin
  Result:=lcwInvalid;
  if Assigned(Channel) then begin
    case Channel.Location of
      clInternal: begin
        if Channel=FInChannel then
          Result:=lcwIncomingInternal
        else if Channel=FOutChannel then
          Result:=lcwOutgoingInternal
        else 
          Result:=lcwSearchInternal;
      end;
      clExternal: begin
        if Channel=FInChannel then
          Result:=lcwIncomingExternal
        else if Channel=FOutChannel then
          Result:=lcwOutgoingExternal
        else
          Result:=lcwSearchExternal;
      end;
    end;
  end;
end;

procedure TBisCallServerLine.LoggerWrite(const Message: String; Channel: TBisCallServerChannel; LogType: TBisLoggerType);
var
  S: String;
  S1,S2: String;
  W: String;
begin
  if Assigned(FServer) and (Trim(Message)<>'') then begin
    S1:='';
    if Assigned(Channel) then begin
      W:=GetEnumName(TypeInfo(TBisCallServerLineChannelWay),Integer(Way(Channel)));
      S1:=Channel.ChannelName+' | '+W;
    end;
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

function TBisCallServerLine.InsertCall(CallId: Variant): Variant;
var
  P: TBisProvider;
  Ret: Variant;
begin
  Result:=Null;
  if VarIsNull(Result) then begin
    try
      P:=TBisProvider.Create(nil);
      try
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
          AddInvisible('CALLER_DIVERSION').Value:=FCallerDiversion;
        end;
        P.Execute;
        if P.Success then
          Result:=Ret;
      finally
        P.Free;
      end;
    except
      On E: Exception do
        LoggerWrite(E.Message,nil,ltError);
    end;
  end;
end;

function TBisCallServerLine.UpdateCall: Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  if not VarIsNull(FCurrentCallId) then begin
    try
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='U_CALL';
        with P.Params do begin
          with AddInvisible('CALL_ID') do begin
            Older('OLD_CALL_ID');
            Value:=FCurrentCallId;
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
          AddInvisible('CALLER_DIVERSION').Value:=FCallerDiversion;
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
    except
      On E: Exception do
        LoggerWrite(E.Message,nil,ltError);
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
  FInStream.Clear;
  FOutStream.Clear;
  FCurrentCallId:=InsertCall(CallId);
  Result:=not VarIsNull(FCurrentCallId);
end;

function TBisCallServerLine.ConvertData(InFormat,OutFormat: PWaveFormatEx; InData: Pointer; InSize: Cardinal;
                                        OutStream: TMemoryStream; OnlyData: Boolean): Boolean;
var
  Converter: TBisAudioWaveConverter;
begin
  Result:=false;
  try
    if Assigned(InFormat) and Assigned(OutFormat) and (InSize>0) and Assigned(OutStream) then begin
      Converter:=TBisAudioWaveConverter.Create;
      try
        if Converter.BeginRewrite(InFormat) then begin
          Converter.Write(InData^,InSize);
          Converter.EndRewrite;
          if Converter.ConvertTo(OutFormat) then begin
            if OnlyData then
              Converter.Stream.Position:=Converter.DataOffset
            else
              Converter.Stream.Position:=0;
            OutStream.Position:=OutStream.Size;
            OutStream.CopyFrom(Converter.Stream,Converter.Stream.Size-Converter.Stream.Position);
            Result:=True;
          end;
        end;
      finally
        Converter.Free;
      end;
    end;
  except
    On E: Exception do
      LoggerWrite(E.Message,nil,ltError);
  end;
end;

procedure TBisCallServerLine.SaveCall(WithDateEnd: Boolean);
begin
  if FLockSaveCall.TryEnter then begin
    try
      if not FAlreadySaved then begin

        if WithDateEnd then
          FDateEnd:=Core.ServerDate;

        FInLockStream.Enter;
        try
          FCallerAudio.Clear;
          if FInStream.Size>0 then begin
            FInStream.Position:=0;
            ConvertData(FDataFormat,FDataFormat,FInStream.Memory,FInStream.Size,FCallerAudio,false);
            FInStream.Position:=FInStream.Size;
            FCallerAudio.Position:=0;
          end;
        finally
          FInLockStream.Leave;
        end;

        FOutLockStream.Enter;
        try
          FAcceptorAudio.Clear;
          if FOutStream.Size>0 then begin
            FOutStream.Position:=0;
            ConvertData(FDataFormat,FDataFormat,FOutStream.Memory,FOutStream.Size,FAcceptorAudio,false);
            FOutStream.Position:=FOutStream.Size;
            FAcceptorAudio.Position:=0;
          end;
        finally
          FOutLockStream.Leave;
        end;

        FAlreadySaved:=UpdateCall;
      end;
    finally
      FLockSaveCall.Leave;
    end;
  end;
end;

procedure TBisCallServerLine.SearchThreadTimeout(Thread: TBisWaitThread);

  procedure ChannelHangup(Channel: TBisCallServerChannel);
  begin
    if Assigned(Channel) and
       not (Channel.State in [csProcessing,csHolding]) then begin
      Channel.Hangup;
    end;
  end;

  procedure ChannelFree(Channel: TBisCallServerChannel; WithHangup: Boolean=false);
  begin
    if Assigned(Channel) then begin
      SetChannelProps(Channel,false);
      if WithHangup then
        ChannelHangup(Channel);
      Channel.LockRemove;
    end;
  end;

  function WaitHangup(Channel: TBisCallServerChannel): Boolean;
  var
    Ret: TWaitResult;
    T: Cardinal;
  begin
    Result:=false;
    if Assigned(Channel) then begin
      T:=Channel.HangupTimeout;
      ChannelHangup(Channel);
      FSearchEvent.ResetEvent;
      Ret:=FSearchEvent.WaitFor(T);
      case Ret of
        wrSignaled: Result:=true;
      end;
    end;
  end;

  function WaitAnswer(Channel: TBisCallServerChannel): Boolean;
  var
    Ret: TWaitResult;
  begin
    Result:=false;
    if Assigned(Channel) then begin
      FSearchCanceled:=true;
      FNotAnswered:=false;
      FSearchEvent.ResetEvent;
      Ret:=FSearchEvent.WaitFor(Channel.AnswerTimeout);
      case Ret of
        wrSignaled: begin
          if FSearchCanceled then begin
            WaitHangup(Channel);
          end else
            Result:=True;
        end;
      else
        FNotAnswered:=true;
        WaitHangup(Channel);
      end;
    end;
  end;

  function WaitDial(SearchHandler: TBisCallServerHandler; Acceptor: Variant;
                    var Channel: TBisCallServerChannel): Boolean;

    function OutgoingPhonePrepare(Channel: TBisCallServerChannel): Variant;
    var
      P: TBisProvider;
    begin
      Result:=Null;
      try
        P:=TBisProvider.Create(nil);
        try
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
      except
        On E: Exception do
          LoggerWrite(E.Message,nil,ltError);
      end;
    end;

    function GetOutChannel(Acceptor: Variant): TBisCallServerChannel;
    var
      NewAcceptor: Variant;
      S: String;
    begin
      Result:=SearchHandler.AddOutgoingChannel(FCurrentCallId,FCallerId,FCallerPhone);
      if Assigned(Result) then begin
        SetChannelProps(Result,true);
        case FSearchAcceptorType of
          catPhone: NewAcceptor:=OutgoingPhonePrepare(Result);
        else
          NewAcceptor:=Acceptor;
        end;
        S:=GetEnumName(TypeInfo(TBisCallServerChannelAcceptorType),Integer(FSearchAcceptorType));
        LoggerWrite(FormatEx(FSAcceptorDial,[NewAcceptor,S]),Result);
        Result.Dial(NewAcceptor,FSearchAcceptorType);
      end;
    end;

  var
    Ret: TWaitResult;
  begin
    Result:=false;
    Channel:=GetOutChannel(Acceptor);
    if Assigned(Channel) then begin
      FSearchCanceled:=false;
      FSearchEvent.ResetEvent;
      Ret:=FSearchEvent.WaitFor(Channel.DialTimeout);
      case Ret of
        wrSignaled: begin
          if not FSearchCanceled then
            Result:=WaitAnswer(Channel)
          else
            WaitHangup(Channel)
        end;
      else
        ChannelFree(Channel);
      end;
    end;
  end;

  procedure GetAcceptorsBySessions(Acceptors: TBisVariants);
  var
    P: TBisProvider;
  begin
    if not VarIsNull(FCurrentCallId) then begin
      try
        P:=TBisProvider.Create(nil);
        try
          P.ProviderName:='GET_CALL_SESSIONS';
          P.FieldNames.Add('SESSION_ID');
          with P.Params do begin
            AddInvisible('CALL_ID').Value:=FCurrentCallId;
            AddInvisible('SESSION_ID',ptOutput);
            AddInvisible('ACCOUNT_ID',ptOutput);
          end;
          P.OpenWithExecute;
          if P.Active then begin
            P.First;
            while not P.Eof do begin
              Acceptors.Add(P.FieldByName('SESSION_ID').Value);
              P.Next;
            end;
          end;
        finally
          P.Free;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,nil,ltError);
      end;
    end;
  end;

var
  Handlers: TObjectList;
  Acceptors: TBisVariants;
  i,j: Integer;
  OperatorId: Variant;
  Found: Boolean;
  SearchHandler: TBisCallServerHandler;
  Channel: TBisCallServerChannel;
begin
  if (FSearchLocation<>hlUnknown) and Assigned(FInChannel) and
     (Way(FInChannel) in [lcwIncomingExternal,lcwIncomingInternal]) then begin

    Found:=false;
    try
      try
        Handlers:=TObjectList.Create(false);
        Acceptors:=TBisVariants.Create;
        try

          case FSearchAcceptorType of
            catPhone: begin
              if not VarIsNull(FSearchAcceptor) then
                Acceptors.Add(FSearchAcceptor);
            end;
            catSession: GetAcceptorsBySessions(Acceptors);
          end;

          if Acceptors.Count>0 then begin
            OperatorId:=iff(FSearchLocation=hlInternal,Null,FOperatorId);
            FServer.FModules.GetHandlers(FSearchLocation,[hdBoth,hdOutgoing],OperatorId,Handlers);
            for i:=0 to Handlers.Count-1 do begin
              SearchHandler:=TBisCallServerHandler(Handlers.Items[i]);
              if not Thread.Terminated then begin
                for j:=0 to Acceptors.Count-1 do begin
                  if not Thread.Terminated then begin
                    Found:=WaitDial(SearchHandler,Acceptors.Items[j].Value,Channel);
                    if Found then begin
                      exit;
                    end;
                  end else
                    break;
                end;
              end else
                break;
            end;
          end;

        finally
          Acceptors.Free;
          Handlers.Free;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,nil,ltError);

      end;
    finally
      if not Found then
        Thread.Reset;
    end;
  end;
end;

procedure TBisCallServerLine.SearchThreadEnd(Thread: TBisThread);
begin
  FSearchEvent.SetEvent;
end;

procedure TBisCallServerLine.SearchThreadError(Thread: TBisThread; const E: Exception);
begin
  if Assigned(E) then
    LoggerWrite(E.Message,nil,ltError);
end;

procedure TBisCallServerLine.SearchStart(Location: TBisCallServerHandlerLocation;
                                         AcceptorType: TBisCallServerChannelAcceptorType; Acceptor: Variant);
begin
  SearchStop;
  FSearchLocation:=Location;
  FSearchAcceptorType:=AcceptorType;
  FSearchAcceptor:=Acceptor;
  FSearchThread.Start;
end;

procedure TBisCallServerLine.SearchStop;
begin
  FSearchThread.Stop;
end;

procedure TBisCallServerLine.SearchAccept;
begin
  FSearchCanceled:=false;
  FSearchEvent.SetEvent;
end;

procedure TBisCallServerLine.SearchCancel;
begin
  FSearchCanceled:=true;
  FSearchEvent.SetEvent;
end;

procedure TBisCallServerLine.SearchNext(AsNew: Boolean);
begin
  SaveCall(true);
  if AsNew then
    NewCall(GetUniqueID);
  SearchCancel;
end;

procedure TBisCallServerLine.SetChannelProps(Channel: TBisCallServerChannel; Enabled: Boolean);
begin
  if Assigned(Channel) then begin
    if Enabled then begin
      Channel.OnPlay:=ChannelPlay;
      Channel.OnStop:=ChannelStop;
      Channel.OnCheck:=ChannelCheck;
      Channel.OnRing:=ChannelRing;
      Channel.OnBusy:=ChannelBusy;
      Channel.OnConnect:=ChannelConnect;
      Channel.OnDisconnect:=ChannelDisconnect;
      Channel.OnCode:=ChannelCode;
      Channel.OnData:=ChannelData;
      Channel.OnHold:=ChannelHold;
      Channel.OnUnHold:=ChannelUnHold;
      Channel.OnError:=ChannelError;
      Channel.OnTimeout:=ChannelTimeout;
    end else begin
      Channel.OnPlay:=nil;
      Channel.OnStop:=nil;
      Channel.OnCheck:=nil;
      Channel.OnRing:=nil;
      Channel.OnBusy:=nil;
      Channel.OnConnect:=nil;
      Channel.OnDisconnect:=nil;
      Channel.OnCode:=nil;
      Channel.OnData:=nil;
      Channel.OnHold:=nil;
      Channel.OnUnHold:=nil;
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
              FDirection:=1;
              FOperatorId:=P.ParamByName('OPERATOR_ID').Value;
              FFirmId:=P.ParamByName('FIRM_ID').Value;
              FCreatorId:=Channel.CreatorId;
              FDateCreate:=Core.ServerDate;
              FCallerId:=Channel.CallerId;
              FCallerName:=Null;
              FCallerPatronymic:=Null;
              FCallerPhone:=Channel.CallerPhone;
              FCallerDiversion:=Channel.CallerDiversion;
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
    Scenario: TBisCallServerScenario;
  begin
    Result:=false;
    Phone:=Channel.CallerPhone;
    if not VarIsNull(Phone) then begin
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='INCOMING_CALL_CHECK';
        with P.Params do begin
          AddInvisible('CALLER_PHONE').Value:=Phone;
          AddInvisible('CALLER_DIVERSION').Value:=Channel.CallerDiversion;
          AddInvisible('CHANNEL').Value:=Channel.ChannelName;
          AddInvisible('ACCOUNT_ID',ptOutput);
          AddInvisible('NAME',ptOutput);
          AddInvisible('PATRONYMIC',ptOutput);
          AddInvisible('PHONE',ptOutput);
          AddInvisible('OPERATOR_ID',ptOutput);
          AddInvisible('FIRM_ID',ptOutput);
          AddInvisible('SCENARIO_NAME',ptOutput);
          AddInvisible('CHECKED',ptOutput);
        end;
        P.Execute;
        if P.Success then begin

          FreeAndNilEx(FScenario);
          Scenario:=FServer.FScenarios.FindDefault(P.ParamByName('SCENARIO_NAME').AsString);
          if Assigned(Scenario) then begin
            FScenario:=TBisCallServerScenario.Create;
            FScenario.CopyFrom(Scenario);
          end;
          
          FCallResultId:=Null;
          FDirection:=0;
          FOperatorId:=P.ParamByName('OPERATOR_ID').Value;
          FFirmId:=P.ParamByName('FIRM_ID').Value;
          FCreatorId:=Channel.CreatorId;
          FDateCreate:=Core.ServerDate;
          FCallerId:=P.ParamByName('ACCOUNT_ID').Value;
          FCallerName:=P.ParamByName('NAME').Value;
          FCallerPatronymic:=P.ParamByName('PATRONYMIC').Value;
          FCallerPhone:=P.ParamByName('PHONE').Value;
          FCallerDiversion:=Channel.CallerDiversion;
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

var
  W: TBisCallServerLineChannelWay;  
begin
  Result:=false;
  try
    W:=Way(Channel);
    case W of
      lcwIncomingExternal: begin
        LoggerWrite(FormatEx(FSChannelCheckStart,[FSIncomingCall]),Channel);
        Result:=IncomingCheck;
      end;
      lcwIncomingInternal: begin
        LoggerWrite(FormatEx(FSChannelCheckStart,[FSOutgoingCall]),Channel);
        Result:=OutgoingCheck;
      end;
    else
      Result:=true;
    end;
  except
    On E: Exception do
      LoggerWrite(FormatEx(FSChannelCheckFail,[E.Message]),Channel,ltError);
  end;
end;

type
  TBisCallServerLinePlayChannel=class(TBisCallServerLinePlayObj)
  private
    FChannel: TBisCallServerChannel;
  end;

procedure TBisCallServerLine.ChannelPlayEnd(Channel: TBisCallServerChannel; Obj: TBisCallServerLinePlayObj;
                                            Finished,Terminated: Boolean; Position: Cardinal);
var
  AObj: TBisCallServerLinePlayChannel;
begin
  if Assigned(Obj) and (Obj is TBisCallServerLinePlayChannel) then begin
    AObj:=TBisCallServerLinePlayChannel(Obj);
    if Assigned(AObj.FChannel) then
      AObj.FChannel.PlayEnd(Position);
  end;
end;

procedure TBisCallServerLine.ChannelPlay(Channel: TBisCallServerChannel; Wave: TBisAudioWave);
var
  Obj: TBisCallServerLinePlayChannel;
begin
  try
    LoggerWrite(FSChannelPlayStart,Channel);
    Obj:=TBisCallServerLinePlayChannel.Create;
    Obj.FChannel:=Channel;
    PlayStart(FOutChannel,Obj,ChannelPlayEnd,Wave,false);
  except
    On E: Exception do
      LoggerWrite(FormatEx(FSChannelPlayFail,[E.Message]),Channel,ltError);
  end;
end;

procedure TBisCallServerLine.ChannelStop(Channel: TBisCallServerChannel);
begin
  try
    LoggerWrite(FSChannelStopStart,Channel);
    PlayStop(Channel);
  except
    On E: Exception do
      LoggerWrite(FormatEx(FSChannelStopFail,[E.Message]),Channel,ltError);
  end;
end;

procedure TBisCallServerLine.ChannelRing(Channel: TBisCallServerChannel);
var
  W: TBisCallServerLineChannelWay;
begin
  try
    LoggerWrite(FSChannelRingStart,Channel);
    W:=Way(Channel);
    case W of
      lcwInvalid: ;
      lcwIncomingExternal: begin
        Channel.Answer;
        SetOutChannel(nil);
        SearchStart(hlInternal,catSession,Null);
      end;
      lcwIncomingInternal: begin
        SetOutChannel(nil);
        SearchStart(hlExternal,Channel.AcceptorType,Channel.Acceptor);
      end;
      lcwSearchInternal,lcwSearchExternal: begin
        FReadyForTalk:=false;
        SearchAccept;
        FDateFound:=Core.ServerDate;
        if Assigned(FInChannel) then
          FInChannel.SetOutChannel(Channel);
        if W in [lcwSearchInternal] then
          FAcceptorId:=Channel.AcceptorId;
        FAlreadySaved:=false;  
        SaveCall(false);
      end;
    end;
  except
    On E: Exception do
      LoggerWrite(FormatEx(FSChannelRingFail,[E.Message]),Channel,ltError);
  end;
end;

type
  TBisCallServerLinePlayStep=class(TBisCallServerLinePlayObj)
  private
    FStep: TBisCallServerScenarioStep;
  end;

procedure TBisCallServerLine.StepPlayStart(Channel: TBisCallServerChannel; Step: TBisCallServerScenarioStep);
var
  Wave: TBisAudioWave;

  procedure GetWaveByText;
  var
    W: TBisAudioWave;
  begin
    W:=TBisAudioWave.Create;
    try
      W.BeginRewrite(Wave.WaveFormat);
      W.EndRewrite;
      if GetWaveWithConsts(Channel,Step.AsString,W) then
        Wave.Insert(Wave.Length,W);
    finally
      W.Free;
    end;
  end;

  procedure GetWaveByAudio;
  var
    Stream: TStringStream;
    W: TBisAudioWave;
  begin
    W:=TBisAudioWave.Create;
    Stream:=TStringStream.Create(Step.AsString);
    try
      W.LoadFromStream(Stream);
      if W.ConvertToPCM(Wave.PCMFormat) then
        Wave.Insert(Wave.Length,W);
    finally
      Stream.Free;
      W.Free;
    end;
  end;

  procedure GetWaveByRepeat;
  var
    AStep: TBisCallServerScenarioStep;
  begin
    if Assigned(FScenario) then begin
      AStep:=FScenario.Steps.LockFind(Step.AsString);
      if Assigned(AStep) then begin
        Wave.Insert(Wave.Length,AStep.Wave);
      end;
    end;
  end;

  procedure GetWaveByHoldMusic;
  var
    W: TBisAudioWave;
    Text: String;
  begin
    if Assigned(FScenario) then begin
      Text:=Step.AsString;
      if Trim(Text)<>'' then
        GetWaveByAudio
      else begin
        FScenario.Params.Lock;
        W:=TBisAudioWave.Create;
        try
          if FScenario.Params.GetHoldMusic(W) then
            if W.ConvertToPCM(Wave.PCMFormat) then
              Wave.Insert(Wave.Length,W);
        finally
          W.Free;
          FScenario.Params.UnLock;
        end;
      end;
    end;
  end;

  procedure TryStepType;
  begin
    try
      case Step.StepType of
        sstText: GetWaveByText;
        sstAudio: GetWaveByAudio;
        sstRepeat: GetWaveByRepeat;
        sstHoldMusic: GetWaveByHoldMusic;
      end;
    except
      on E: Exception do
        LoggerWrite(E.Message,Channel,ltError);
    end;
  end;

var
  Obj: TBisCallServerLinePlayStep;
begin
  if Assigned(Step) and Assigned(FScenario) then begin
    LoggerWrite(FormatEx(FSScenarioStep,[FScenario.Name,Step.Name]),Channel);
    Step.Lock;
    Wave:=TBisAudioWave.Create;
    try
      Wave.BeginRewrite(@FInternalFormat);
      Wave.EndRewrite;
      Wave.InsertSilence(0,Step.Timeout);
      TryStepType;
      Step.Wave.Assign(Wave);
      Step.Wave.Delete(0,Step.Timeout);
      Obj:=TBisCallServerLinePlayStep.Create;
      Obj.FStep:=Step;
      PlayStart(Channel,Obj,StepPlayEnd,Wave,false);
    finally
      Wave.Free;
      Step.UnLock;
    end;
  end else begin
    if not FReadyForTalk then begin
      SetTypeEnd(lteServerCancel);
      Channel.Hangup;
    end;
  end;
end;

procedure TBisCallServerLine.StepPlayEnd(Channel: TBisCallServerChannel; Obj: TBisCallServerLinePlayObj;
                                         Finished,Terminated: Boolean; Position: Cardinal);
var
  Step: TBisCallServerScenarioStep;
begin
  if Assigned(Obj) and (Obj is  TBisCallServerLinePlayStep) then begin
    Step:=TBisCallServerLinePlayStep(Obj).FStep;
    if Step.TryLock then begin
      try
        if Finished and not Terminated then
          StepPlayStart(Channel,FScenario.Steps.LockNext(Step))
      finally
        Step.UnLock;
      end;
    end;
  end;
end;

procedure TBisCallServerLine.ChannelConnect(Channel: TBisCallServerChannel);
var
  W: TBisCallServerLineChannelWay;
begin
  try
    LoggerWrite(FSChannelConnectStart,Channel);
    W:=Way(Channel);
    case W of
      lcwInvalid:;
      lcwIncomingExternal: begin
        FDataFormat:=Channel.InFormat;
        FInChannelName:=Channel.ChannelName;
        if not Assigned(FScenario) then
          PlayStart(Channel,nil,nil,FServer.FHoldMusic,true)
        else
          StepPlayStart(Channel,FScenario.Steps.LockFirst);
      end;
      lcwIncomingInternal: begin
        FDataFormat:=Channel.InFormat;
        FInChannelName:=Channel.ChannelName;
      end;
      lcwOutgoingInternal: ;
      lcwOutgoingExternal: ;
      lcwSearchInternal: begin
        FReadyForTalk:=true;
        PlayStop(FInChannel);
        SearchAccept;
//        SearchStop;
        SetOutChannel(Channel);
        FOutChannelName:=Channel.ChannelName;
        FDateBegin:=Core.ServerDate;
      end;
      lcwSearchExternal: begin
        SearchAccept;
  //      SearchStop;
        SetOutChannel(Channel);
        FOutChannelName:=Channel.ChannelName;
        FDateBegin:=Core.ServerDate;
        if Assigned(FInChannel) then
          FInChannel.Answer;
      end;
    end;
  except
    On E: Exception do
      LoggerWrite(FormatEx(FSChannelConnectFail,[E.Message]),Channel,ltError);
  end;
end;

procedure TBisCallServerLine.ChannelDisconnect(Channel: TBisCallServerChannel);

  procedure SetChannelEvent(AChannel: TBisCallServerChannel; Event: Boolean);
  begin
    if Assigned(AChannel) then begin
      if not Event then
        AChannel.OnDisconnect:=nil
      else
        AChannel.OnDisconnect:=ChannelDisconnect;
    end;
  end;

var
  TE: TBisCallServerLineTypeEnd;
begin
  try
    LoggerWrite(FSChannelDisconnectStart,Channel);
    PlayStop(Channel);
    case Way(Channel) of
      lcwInvalid: ;
      lcwIncomingExternal,lcwIncomingInternal: begin
        SearchCancel;
        SetTypeEnd(iff(ChannelWorking(FOutChannel),lteCallerClose,lteCallerCancel));
        if ChannelNotFinished(FOutChannel) then begin
          SetChannelEvent(FOutChannel,false);
          try
            FOutChannel.Hangup;
          finally
            SetChannelEvent(FOutChannel,true);
          end;
        end;
      end;
      lcwOutgoingExternal, lcwOutgoingInternal: begin
        FCallResultId:=FOutChannel.CallResultId;
        SetTypeEnd(iff(ChannelWorking(FInChannel),lteAcceptorClose,lteAcceptorCancel));
        if ChannelNotFinished(FInChannel) then begin
          SetChannelEvent(FInChannel,false);
          try
            FInChannel.Hangup;
          finally
            SetChannelEvent(FInChannel,true);
          end;
        end;
      end;
      lcwSearchExternal: begin
        SetTypeEnd(iff(FNotAnswered,lteTimeout,lteAcceptorCancel));
      end;
      lcwSearchInternal: begin
        SetTypeEnd(iff(FNotAnswered,lteTimeout,lteAcceptorCancel));
        TE:=TBisCallServerLineTypeEnd(VarToIntDef(FTypeEnd,Integer(lteTimeout)));
        SearchNext(TE in [lteTimeout,lteAcceptorCancel]);
      end;
    end;
  except
    On E: Exception do
      LoggerWrite(FormatEx(FSChannelDisconnectFail,[E.Message]),Channel,ltError);
  end;
end;

procedure TBisCallServerLine.ChannelBusy(Channel: TBisCallServerChannel);
begin
  try
    LoggerWrite(FSChannelBusyStart,Channel);
    case Way(Channel) of
      lcwSearchInternal,lcwSearchExternal: begin
        SearchCancel;
      end;
    end;
  except
    On E: Exception do
      LoggerWrite(FormatEx(FSChannelBusyFail,[E.Message]),Channel,ltError);
  end;
end;

procedure TBisCallServerLine.SendData(Channel: TBisCallServerChannel; Format: PWaveFormatEx;
                                      const Data: Pointer; const DataSize: LongWord);

  function MakeInternalStream(Volume: Integer; Stream: TMemoryStream): Boolean;
  var
    Converter: TBisAudioWaveConverter;
  begin
    Result:=false;
    if Assigned(Format) and (DataSize>0) then begin
      Converter:=TBisAudioWaveConverter.Create;
      try
        Converter.BeginRewrite(Format);
        Converter.Write(Data^,DataSize);
        Converter.EndRewrite;
        if Converter.ConvertTo(@FInternalFormat) then begin
          Converter.ChangeVolume(Volume);
          Converter.Stream.Position:=Converter.DataOffset;
          Stream.Clear;
          Stream.CopyFrom(Converter.Stream,Converter.Stream.Size-Converter.Stream.Position);
          Stream.Position:=0;
          Result:=true;
        end;
      finally
        Converter.Free;
      end;
    end;
  end;

  procedure SendStream(Stream: TMemoryStream);
  var
    RealStream: TMemoryStream;
  begin
    if Stream.Size>0 then begin
      RealStream:=TMemoryStream.Create;
      try
        if ConvertData(@FInternalFormat,Channel.OutFormat,Stream.Memory,Stream.Size,RealStream) then
          Channel.Send(RealStream.Memory,RealStream.Size);
      finally
        RealStream.Free;
      end;
    end;
  end;
  
var
  Stream: TMemoryStream;  
begin
  try
    if Assigned(Channel) and (Channel.State in [csProcessing]) then begin
      Stream:=TMemoryStream.Create;
      try
        if MakeInternalStream(Channel.Volume,Stream) then
          SendStream(Stream);
      finally
        Stream.Free;
      end;
    end;
  except
    On E: Exception do begin
      LoggerWrite('DataSize='+IntToStr(DataSize),Channel,ltError);
      LoggerWrite(E.Message,Channel,ltError);
    end;
  end;
end;

procedure TBisCallServerLine.PlayData(Channel: TBisCallServerChannel; Format: PWaveFormatEx;
                                      const Data: Pointer; const DataSize: LongWord);
begin
  SendData(Channel,Format,Data,DataSize);

  FOutLockStream.Enter;
  try
    ConvertData(Format,FDataFormat,Data,DataSize,FOutStream);
  finally
    FOutLockStream.Leave;
  end;

end;


procedure TBisCallServerLine.ChannelData(Channel: TBisCallServerChannel; const Data: Pointer; const DataSize: LongWord);
begin
  try
    case Way(Channel) of
      lcwIncomingExternal,lcwIncomingInternal: begin

        SendData(FOutChannel,Channel.InFormat,Data,DataSize);

        FInLockStream.Enter;
        try
          ConvertData(Channel.InFormat,FDataFormat,Data,DataSize,FInStream);
        finally
          FInLockStream.Leave;
        end;

      end;
      lcwOutgoingExternal,lcwOutgoingInternal: begin

        SendData(FInChannel,Channel.OutFormat,Data,DataSize);

        FOutLockStream.Enter;
        try
          ConvertData(Channel.OutFormat,FDataFormat,Data,DataSize,FOutStream);
        finally
          FOutLockStream.Leave;
        end;

      end;
    end;
  except
    On E: Exception do
      LoggerWrite(FormatEx(FSChannelDataFail,[E.Message]),Channel,ltError);
  end;
end;

procedure TBisCallServerLine.ChannelHold(Channel: TBisCallServerChannel);
var
  Wave: TBisAudioWave;
begin
  try
    LoggerWrite(FSChannelHoldStart,Channel);
    Wave:=TBisAudioWave.Create;
    try
      if not Assigned(FScenario) then
        Wave.Assign(FServer.FHoldMusic)
      else begin
        FScenario.Params.Lock;
        try
          FScenario.Params.GetHoldMusic(Wave);
        finally
          FScenario.Params.UnLock;
        end;
      end;
      case Way(Channel) of
        lcwIncomingExternal,lcwIncomingInternal: PlayStart(FOutChannel,nil,nil,Wave,true);
        lcwOutgoingExternal,lcwOutgoingInternal: PlayStart(FInChannel,nil,nil,Wave,true);
      end;
    finally
      Wave.Free;
    end;
  except
    On E: Exception do
      LoggerWrite(FormatEx(FSChannelHoldFail,[E.Message]),Channel,ltError);
  end;
end;

procedure TBisCallServerLine.ChannelUnHold(Channel: TBisCallServerChannel);
begin
  try
    LoggerWrite(FSChannelUnHoldStart,Channel);
    case Way(Channel) of
      lcwIncomingExternal,lcwIncomingInternal: PlayStop(FOutChannel);
      lcwOutgoingExternal,lcwOutgoingInternal: PlayStop(FInChannel);
    end;
  except
    On E: Exception do
      LoggerWrite(FormatEx(FSChannelUnHoldFail,[E.Message]),Channel,ltError);
  end;
end;

procedure TBisCallServerLine.ChannelError(Channel: TBisCallServerChannel; const Error: String);
begin
  LoggerWrite(FormatEx(FSChannelError,[Error]),Channel);
end;

procedure TBisCallServerLine.ChannelTimeout(Channel: TBisCallServerChannel);
begin
  try
    LoggerWrite(FSChannelTimeOutStart,Channel);
  except
    On E: Exception do
      LoggerWrite(FormatEx(FSChannelTimeOutFail,[E.Message]),Channel,ltError);
  end;
end;

procedure TBisCallServerLine.MenusPlayStart(Channel: TBisCallServerChannel; Text: String;
                                            Timeout: Cardinal; Menus: TBisCallServerScenarioMenus);
var
  Wave: TBisAudioWave;
  i: Integer;
  Item: TBisCallServerScenarioMenu;
begin
  if Assigned(Menus) then begin
    Menus.Lock;
    Wave:=TBisAudioWave.Create;
    try
      if Menus.Wave.Empty then begin
        Wave.BeginRewrite(@FInternalFormat);
        Wave.EndRewrite;
        GetWaveByTextWithTimeout(Channel,Text,Timeout,Wave);
        for i:=0 to Menus.Count-1 do begin
          Item:=Menus[i];
          GetWaveByTextWithTimeout(Channel,Item.Before,Item.Timeout,Wave);
        end;
        Menus.Wave.Assign(Wave);
      end else
        Wave.Assign(Menus.Wave);

      PlayStart(Channel,nil,nil,Wave,true);
    finally
      Wave.Free;
      Menus.UnLock;
    end;
  end;
end;

type
  TBisCallServerLinePlayMenu=class(TBisCallServerLinePlayObj)
  private
    FMenu: TBisCallServerScenarioMenu;
    FOutMessageIds: TBisVariants;
  public
    constructor Create(Menu: TBisCallServerScenarioMenu; OutMessageIds: TBisVariants); reintroduce;
    destructor Destroy; override;
  end;

{ TBisCallServerLinePlayMenu }

constructor TBisCallServerLinePlayMenu.Create(Menu: TBisCallServerScenarioMenu; OutMessageIds: TBisVariants);
begin
  inherited Create;
  FMenu:=Menu;
  FOutMessageIds:=TBisVariants.Create;
  FOutMessageIds.CopyFrom(OutMessageIds);
end;

destructor TBisCallServerLinePlayMenu.Destroy;
begin
  FOutMessageIds.Free;
  inherited Destroy;
end;

procedure TBisCallServerLine.UnLockOutMessages(Channel: TBisCallServerChannel; OutMessageIds: TBisVariants; Sent: Boolean);

  procedure SetParams(Params: TBisParams; OutMessageId: Variant);
  begin
    with Params do begin
      AddInvisible('OUT_MESSAGE_ID').Value:=OutMessageId;
      AddInvisible('SENT').Value:=Integer(Sent);
    end;
  end;
  
var
  P: TBisProvider;
  i: Integer;
begin
  if OutMessageIds.Count>0 then begin
    try
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='UNLOCK_OUT_MESSAGE';
        for i:=0 to OutMessageIds.Count-1 do begin
          if i=0 then
            SetParams(P.Params,OutMessageIds[i].Value)
          else
            SetParams(P.PackageAfter.Add,OutMessageIds[i].Value);
        end;
        P.Execute;
      finally
        P.Free;
      end;
    except
      On E: Exception do
        LoggerWrite(E.Message,Channel,ltError);
    end;
  end;
end;

procedure TBisCallServerLine.MenuPlayStart(Channel: TBisCallServerChannel; Wave: TBisAudioWave;
                                           Menu: TBisCallServerScenarioMenu; OutMessageIds: TBisVariants);
var
  Obj: TBisCallServerLinePlayMenu;
begin
  if Assigned(Wave) and Assigned(Menu) then begin
    Menu.Lock;
    try
      Obj:=TBisCallServerLinePlayMenu.Create(Menu,OutMessageIds);
      PlayStart(Channel,Obj,MenuPlayEnd,Wave,false);
    finally
      Menu.UnLock;
    end;
  end;
end;

procedure TBisCallServerLine.MenuPlayEnd(Channel: TBisCallServerChannel; Obj: TBisCallServerLinePlayObj;
                                         Finished,Terminated: Boolean; Position: Cardinal);
var
  Menu: TBisCallServerScenarioMenu;
  Text: String;
  Timeout: Cardinal;
  NewMenus: TBisCallServerScenarioMenus;
  Flag: Boolean;
begin
  if Assigned(Obj) and (Obj is TBisCallServerLinePlayMenu) then begin
    Menu:=TBisCallServerLinePlayMenu(Obj).FMenu;
    UnLockOutMessages(Channel,TBisCallServerLinePlayMenu(Obj).FOutMessageIds,Finished);
    case Menu.MenuEnd of
      sceNothing: begin
        FMenuList.Lock;
        try
          FMenuList.Remove(Menu);
          if not FMenuList.Empty then
            FMenuList.Remove(FMenuList.Last);
          Flag:=false;
          NewMenus:=nil;
          Timeout:=0;
          if not FMenuList.Empty then begin
            Text:=FMenuList.Last.After;
            Timeout:=FMenuList.Last.Timeout;
            NewMenus:=FMenuList.Last.Menus;
            Flag:=true;
          end else begin
            if Assigned(FScenario) then begin
              Text:=FScenario.Params.MainMenuText;
              Timeout:=FScenario.Params.MainMenuTimeout;
              NewMenus:=FScenario.Menus;
              Flag:=true;
            end;
          end;
          if Flag and not Terminated then
            MenusPlayStart(Channel,Text,Timeout,NewMenus)
          else
            if not FReadyForTalk then begin
              SetTypeEnd(lteServerCancel);
              Channel.Hangup;
            end;
        finally
          FMenuList.UnLock;
        end;
      end;
      sceHangup: begin
        if not FReadyForTalk then begin
          SetTypeEnd(lteServerCancel);
          Channel.Hangup;
        end;
      end;
      sceStep: begin
        if Assigned(FScenario) and not Terminated then
          StepPlayStart(Channel,FScenario.Steps.LockFind(Menu.AsString))
        else
          if not FReadyForTalk then begin
            SetTypeEnd(lteServerCancel);
            Channel.Hangup;
          end;
        FMenuList.LockClear;
      end;
    end;
  end;
end;

procedure TBisCallServerLine.ChannelCode(Channel: TBisCallServerChannel; const Code: Char);

  function GetMenuCodeWave(MenuValue,MenuText: String; MenuTimeout: Cardinal;
                           Wave: TBisAudioWave; OutMessageIds: TBisVariants): Boolean;

    procedure ExecuteCommand(CommandString,Code: String; SenderId, Contact, CodeMessageId, InMessageId: Variant);
    var
      S: String;
      i: Integer;
      Params: TBisValues;
      Param: TBisValue;
      StartupInfo: TStartupInfo;
      ProcessInfo: TProcessInformation;
      Ret: Boolean;
    begin
      if Trim(CommandString)<>'' then begin
        Params:=TBisValues.Create;
        try
          Params.Add('TEXT_IN',MenuValue);
          Params.Add('CODE',Code);
          Params.Add('SENDER_ID',VarToStrDef(SenderId,''));
          Params.Add('CONTACT',VarToStrDef(Contact,''));
          Params.Add('CODE_MESSAGE_ID',VarToStrDef(CodeMessageId,''));
          Params.Add('IN_MESSAGE_ID',VarToStrDef(InMessageId,''));

          S:=CommandString;
          for i:=0 to Params.Count-1 do begin
            Param:=Params.Items[i];
            S:=AnsiReplaceText(S,'%'+Param.Name,'"'+VarToStrDef(Param.Value,'')+'"');
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
    end;

    function ProcessInMessage(Locked: String; SenderId,Contact: Variant;
                              var Code,CommandString,Answer: String; var Exists: Boolean;
                              var CodeMessageId, InMessageId: Variant): Boolean;
    var
      P: TBisProvider;
    begin
      Result:=false;
      try
        P:=TBisProvider.Create(nil);
        try
          P.ProviderName:='PROCESS_IN_MESSAGE';
          with P.Params do begin
            AddInvisible('ACCOUNT_ID').Value:=SenderId;
            AddInvisible('CONTACT').Value:=Contact;
            AddInvisible('TEXT_IN').Value:=MenuValue;
            AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
            AddInvisible('CHANNEL').Value:=FInChannelName;
            AddInvisible('FIRM_ID').Value:=FFirmId;
            AddInvisible('OPERATOR_ID').Value:=FOperatorId;
            AddInvisible('LOCKED').Value:=Locked;
            AddInvisible('CODE_MESSAGE_ID',ptOutput);
            AddInvisible('CODE',ptOutput);
            AddInvisible('COMMAND_STRING',ptOutput);
            AddInvisible('ANSWER',ptOutput);
            AddInvisible('IN_MESSAGE_ID',ptOutput);
            AddInvisible('LOCK_COUNT',ptOutput);
          end;
          P.Execute;
          if P.Success then begin
            Result:=true;
            Code:=P.ParamByName('LOCK_COUNT').AsString;
            CommandString:=P.ParamByName('COMMAND_STRING').AsString;
            Answer:=P.ParamByName('ANSWER').AsString;
            Exists:=P.ParamByName('LOCK_COUNT').AsInteger>0;
            CodeMessageId:=P.ParamByName('CODE_MESSAGE_ID').Value;
            InMessageId:=P.ParamByName('IN_MESSAGE_ID').Value;
          end;
        finally
          P.Free;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,nil,ltError);
      end;
    end;

    function FieldReplace(DataSet: TBisDataSet; Field: TField): String;
    var
      i: Integer;
      F: TField;
    begin
      Result:='';
      if Assigned(Field) then begin
        Result:=Field.AsString;
        for i:=0 to DataSet.Fields.Count-1 do begin
          F:=DataSet.Fields[i];
          if F<>Field then
            Result:=ReplaceText(Result,'%'+F.FieldName,F.AsString);
        end;
      end;
    end;

    function StringsEmpty(Strings: TStringList): Boolean;
    begin
      Result:=(Strings.Count=0) or (Trim(Strings.Text)='');
    end;

    procedure GetWaveByStrigns(Strings: TStringList);
    var
      i: Integer;
    begin
      for i:=0 to Strings.Count-1 do
        GetWaveByTextWithTimeout(Channel,Strings[i],MenuTimeout,Wave);
    end;

  var
    Locked: String;
    SenderId, Contact: Variant;
    Code,CommandString, Answer: String;
    Exists: Boolean;
    CodeMessageId, InMessageId: Variant;
    Ret: Boolean;
    P: TBisProvider;
    S: String;
    Strings: TStringList;
  begin
    Result:=false;
    try
      Locked:=GetUniqueID;
      SenderId:=FCallerId;
      Contact:=FCallerPhone;
      Code:='';
      CommandString:='';
      Answer:='';
      Exists:=false;
      Ret:=ProcessInMessage(Locked,SenderId,Contact,
                            Code,CommandString,Answer,Exists,
                            CodeMessageId,InMessageId);
      if Ret then begin

        ExecuteCommand(CommandString,Code,SenderId,Contact,CodeMessageId,InMessageId);
        
        Strings:=TStringList.Create;
        try

          if Exists then begin
            P:=TBisProvider.Create(nil);
            try
              P.ProviderName:='S_OUT_MESSAGES';
              with P.FieldNames do begin
                AddInvisible('OUT_MESSAGE_ID');
                AddInvisible('CREATOR_ID');
                AddInvisible('RECIPIENT_ID');
                AddInvisible('DATE_CREATE');
                AddInvisible('TEXT_OUT');
                AddInvisible('CONTACT');
                AddInvisible('DELIVERY');
                AddInvisible('FLASH');
                AddInvisible('DESCRIPTION');
                AddInvisible('CREATOR_NAME');
                AddInvisible('RECIPIENT_NAME');
                AddInvisible('RECIPIENT_PHONE');
              end;
              P.FilterGroups.Add.Filters.Add('LOCKED',fcEqual,Locked).CheckCase:=true;
              with P.Orders do begin
                Add('PRIORITY');
                Add('DATE_BEGIN');
              end;
              P.Open;
              if P.Active then begin
                P.First;
                while not P.Eof do begin
                  OutMessageIds.Add(P.FieldByName('OUT_MESSAGE_ID').Value);
                  S:=FieldReplace(P,P.FieldByName('TEXT_OUT'));
                  Strings.Add(S);
                  P.Next;
                end;
              end;
            finally
              P.Free;
            end;
          end;

          if StringsEmpty(Strings) then
            Strings.Add(Answer);

          if StringsEmpty(Strings) then
            Strings.Add(MenuText);

          Result:=not StringsEmpty(Strings);
          if Result then
            GetWaveByStrigns(Strings);

        finally
          Strings.Free;
        end;
      end;
    except
      On E: Exception do
        LoggerWrite(E.Message,Channel,ltError);
    end;
  end;

var
  Menus: TBisCallServerScenarioMenus;
  Menu: TBisCallServerScenarioMenu;
  Text: String;
  Timeout: Cardinal;
  NewMenus: TBisCallServerScenarioMenus;
  Wave: TBisAudioWave;
  OutMessageIds: TBisVariants;
begin
  try
    LoggerWrite(FormatEx(FSChannelCodeStart,[Code]),Channel);
    if not FReadyForTalk then
      case Way(Channel) of
        lcwIncomingExternal: begin
          if FMenuList.TryLock and Assigned(FScenario) then begin
            try
              if FMenuList.Empty then
                Menus:=FScenario.Menus
              else
                Menus:=FMenuList.Last.Menus;

              if Assigned(Menus) then begin
                if Menus.TryLock then begin
                  try
                    Menu:=Menus.Find(Code);
                    if Assigned(Menu) then begin
                      FMenuList.Add(Menu);
                      LoggerWrite(FormatEx(FSChannelCodeFound,[FMenuList.Path]),Channel);
                      case Menu.MenuType of
                        sctMenu: MenusPlayStart(Channel,Menu.After,Menu.Timeout,Menu.Menus);
                        sctCode: begin
                          FMenuList.Remove(Menu);
                          Wave:=TBisAudioWave.Create;
                          OutMessageIds:=TBisVariants.Create;
                          try
                            Wave.BeginRewrite(@FInternalFormat);
                            Wave.EndRewrite;
                            if GetMenuCodeWave(Menu.AsString,Menu.After,Menu.Timeout,Wave,OutMessageIds) then
                              MenuPlayStart(Channel,Wave,Menu,OutMessageIds)
                            else begin
                              UnLockOutMessages(Channel,OutMessageIds,false);
                              case Menu.MenuEnd of
                                sceHangup: begin
                                  if not FReadyForTalk then begin
                                    SetTypeEnd(lteServerCancel);
                                    Channel.Hangup;
                                  end;
                                end;
                                sceStep: begin
                                  StepPlayStart(Channel,FScenario.Steps.LockFind(Menu.AsString));
                                  FMenuList.Clear;
                                end;
                              end;
                            end;
                          finally
                            OutMessageIds.Free;
                            Wave.Free
                          end;
                        end;
                        sctDial: ;
                        sctReturn: begin
                          FMenuList.Remove(Menu);
                          if not FMenuList.Empty then
                            FMenuList.Remove(FMenuList.Last);
                          case Menu.MenuEnd of
                            sceNothing: begin
                              if not FMenuList.Empty then begin
                                Text:=FMenuList.Last.After;
                                Timeout:=FMenuList.Last.Timeout;
                                NewMenus:=FMenuList.Last.Menus;
                              end else begin
                                Text:=FScenario.Params.MainMenuText;
                                Timeout:=FScenario.Params.MainMenuTimeout;
                                NewMenus:=FScenario.Menus;
                              end;
                              MenusPlayStart(Channel,Text,Timeout,NewMenus);
                            end;
                            sceHangup: begin
                              if not FReadyForTalk then begin
                                SetTypeEnd(lteServerCancel);
                                Channel.Hangup;
                              end;
                            end;
                            sceStep: begin
                              StepPlayStart(Channel,FScenario.Steps.LockFind(Menu.AsString));
                              FMenuList.Clear;
                            end;
                          end;
                        end;
                      end;
                    end;
                  finally
                    Menus.UnLock;
                  end;
                end;
              end;
            finally
              FMenuList.UnLock;
            end;
          end;
        end;
      end;
  except
    on E: Exception do
      LoggerWrite(FormatEx(FSChannelCodeFail,[E.Message]),Channel,ltError);
  end;
end;

function TBisCallServerLine.CanFree: Boolean;
begin
  Result:=not Assigned(FOutChannel) and not Assigned(FInChannel);
end;

procedure TBisCallServerLine.TryRemoveChannels;

  procedure RemoveChannel(Channel: TBisCallServerChannel; Flag: Boolean);
  begin
    if Assigned(Channel) then begin
      if not Channel.Alive or Flag then
        Channel.LockRemove;
    end;
  end;
  
begin
  RemoveChannel(FInChannel,Assigned(FOutChannel) and not FOutChannel.Alive);
  RemoveChannel(FOutChannel,false);
end;

function TBisCallServerLine.RemoveByChannel(Channel: TBisCallServerChannel): Boolean;
var
  W: TBisCallServerLineChannelWay;
begin
  try
    SaveCall(true);
    W:=Way(Channel);
    case W of
      lcwIncomingExternal,lcwIncomingInternal: begin
        PlayStop(Channel);
        SearchCancel;
//        SearchStop;
        SetInChannel(nil);
        ChannelDisconnect(FOutChannel);
      end;
      lcwOutgoingExternal,lcwOutgoingInternal: begin
        PlayStop(Channel);
        SearchCancel;
//        SearchStop;
        SetOutChannel(nil);
        ChannelDisconnect(FInChannel);
      end;
      lcwSearchExternal,lcwSearchInternal: begin
        if W=lcwSearchExternal then begin
          SearchCancel;
//          SearchStop;
        end;
        SetChannelProps(Channel,false);
      end;
    end;
  finally
    Result:=CanFree;
  end;
end;

{ TBisCallServerLines }

destructor TBisCallServerLines.Destroy;
begin
  inherited Destroy;
end;

procedure TBisCallServerLines.DoItemRemove(Item: TObject);
begin
  inherited DoItemRemove(Item);
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
          cdIncoming: Found:=Item.Way(Channel) in [lcwIncomingExternal,lcwIncomingInternal];
          cdOutgoing: begin
            Found:=Item.Way(Channel) in [lcwOutgoingExternal,lcwOutgoingInternal];
            if not Found then
              Found:=Item.Way(Channel) in [lcwSearchExternal,lcwSearchInternal];
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

function TBisCallServerLines.LockFind(Channel: TBisCallServerChannel): TBisCallServerLine;
begin
  Lock;
  try
    Result:=Find(Channel);
  finally
    UnLock;
  end;
end;

function TBisCallServerLines.AddChannel(Channel: TBisCallServerChannel; Server: TBisCallServer): TBisCallServerLine;
begin
  Result:=nil;
  if Assigned(Channel) then begin
    if (Channel.Direction=cdIncoming) then begin
      Result:=TBisCallServerLine.Create(Server);
      if Assigned(Result) then begin
        Result.SetInChannel(Channel);
        inherited Add(Result);
      end;
    end;
  end;
end;

function TBisCallServerLines.LockAddChannel(Channel: TBisCallServerChannel; Server: TBisCallServer): TBisCallServerLine;
begin
  Lock;
  try
    Result:=AddChannel(Channel,Server); 
  finally
    UnLock;
  end;
end;

procedure TBisCallServerLines.RemoveByChannel(Channel: TBisCallServerChannel);
var
  Line: TBisCallServerLine;
begin
  if Assigned(Channel) then begin
    Line:=Find(Channel);
    if Assigned(Line) then
      if Line.RemoveByChannel(Channel) then
        Remove(Line);
  end;
end;

procedure TBisCallServerLines.LockRemoveByChannel(Channel: TBisCallServerChannel);
begin
  Lock;
  try
    RemoveByChannel(Channel);
  finally
    UnLock;
  end;
end;

type
  TBisCallServerSweepThread=class(TBisWaitThread)
  end;

{ TBisCallServer }

constructor TBisCallServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Params.OnChange:=ChangeParams;

  FInternalFormat:=Mono16bit8000Hz;
  FSearchInterval:=1000;
  FPacketTime:=20;
  FSweepInterval:=1000;

  FDialMusic:=TBisAudioWave.Create;
  FHoldMusic:=TBisAudioWave.Create;

  FModules:=TBisCallServerHandlerModules.Create(Self);
  FModules.OnCreateModule:=ModulesCreateModule;

  FScenarios:=TBisCallServerScenarios.Create;

  FLines:=TBisCallServerLines.Create;
//  FLines.OnItemRemove:=LinesItemRemove;

  FSweepThread:=TBisCallServerSweepThread.Create;
  FSweepThread.OnTimeout:=SweepThreadTimeout;
  FSweepThread.RestrictByZero:=true;

end;

destructor TBisCallServer.Destroy;
begin
  Stop;
  FSweepThread.Free;
  FLines.Free;
  FScenarios.Free;
  FModules.Free;
  FHoldMusic.Free;
  FDialMusic.Free;
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

procedure TBisCallServer.SweepThreadTimeout(Thread: TBisWaitThread);
var
  i: Integer;
  Line: TBisCallServerLine;
  Flag: Boolean;
begin
  try
    if FLines.TryLock then begin
      try
        for i:=FLines.Count-1 downto 0 do begin
          Line:=FLines.Items[i];
          try
            Flag:=true;
            if Flag and Line.TryLock then begin
              try
                Flag:=Line.CanFree;
                if not Flag then
                  Line.TryRemoveChannels
                else
                  FLines.Remove(Line);
              finally
                if FLines.IndexOf(Line)<>-1 then
                  Line.UnLock;
              end;
            end;
          except
            On E: Exception do
              LoggerWrite(E.Message,ltError);
          end; 
        end;
      finally
        FLines.UnLock;
      end;
    end;
  finally
    Thread.Reset;
  end;
end;

procedure TBisCallServer.ChangeParams(Sender: TObject);
var
  Stream: TMemoryStream;
begin
  Stream:=TMemoryStream.Create;
  try
    with Params do begin
    
      SaveToDataSet(SParamModules,FModules.Table);
      FScenarios.CopyFromDataSet(AsString(SParamScenarios));
      FInternalFormat:=AsEnumeration(SParamInternalFormat,TypeInfo(TPCMFormat),FInternalFormat);
      FSearchInterval:=AsInteger(SParamSearchInterval,FSearchInterval);
      FPacketTime:=AsInteger(SParamPacketTime,FPacketTime);
      FSweepInterval:=AsInteger(SParamSweepInterval,FSweepInterval);

    //  FSweepInterval:=1000;

      Stream.Clear;
      SaveToStream(SParamDialMusic,Stream);
      Stream.Position:=0;
      FDialMusic.LoadFromStream(Stream);

      Stream.Clear;
      SaveToStream(SParamHoldMusic,Stream);
      Stream.Position:=0;
      FHoldMusic.LoadFromStream(Stream);

    end;
  finally
    Stream.Free;
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
    Handler.Channels.OnChannelCreate:=ChannelsCreate;
    Handler.Channels.OnChannelDestroy:=ChannelsDestroy;
  end;
end;

procedure TBisCallServer.ChannelsCreate(Channels: TBisCallServerChannels; Channel: TBisCallServerChannel);
begin
  FLines.LockAddChannel(Channel,Self);
end;

procedure TBisCallServer.ChannelsDestroy(Channels: TBisCallServerChannels; Channel: TBisCallServerChannel);
begin
  FLines.LockRemoveByChannel(Channel);
end;

procedure TBisCallServer.Start;
begin
  Stop;
  if not FActive and Enabled then begin
    LoggerWrite(SStart);
    try

      FLines.Clear;
      FModules.Load;
      FModules.Connect;
      FSweepThread.Timeout:=FSweepInterval;
      FSweepThread.Start;
      FActive:=true;
      LoggerWrite(SStartSuccess);
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(SStartFail,[E.Message]),ltError);
      end;
    end;
  end;
end;

procedure TBisCallServer.Stop;
begin
  if FActive then begin
    LoggerWrite(SStop);
    try
      FSweepThread.Stop;
      FLines.Clear;
      FModules.Disconnect;
      FModules.Unload;
      FActive:=false;
      LoggerWrite(SStopSuccess);
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(SStopFail,[E.Message]),ltError);
      end;
    end;
  end;
end;

end.
