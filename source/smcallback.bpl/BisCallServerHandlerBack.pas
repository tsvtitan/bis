unit BisCallServerHandlerBack;

interface

uses Windows, SysUtils, Classes, Contnrs, ZLib, mmSystem, SyncObjs,
     WaveAcmDrivers, WaveUtils,
     BisEvents, BisNotifyEvents, BisCrypter, BisValues, BisConnections, BisThreads,
     BisAudioWave,
     BisCallServerHandlerModules, BisCallServerHandlers,
     BisCallServerChannels;

type
  TBisCallServerHandlerBack=class;

  TBisCallServerChannelBacks=class;

  TBisCallServerChannelBack=class(TBisCallServerChannel)
  private
    FHandler: TBisCallServerHandlerBack;
    FCallerId: Variant;
    FCallId: Variant;
    FAcceptor: Variant;
    FAcceptorType: TBisCallServerChannelAcceptorType;
    FCreatorId: Variant;
    FDateCreate: TDateTime;
    FOutMessageId: Variant;
    FWave: TBisAudioWave;
    FRunning: Boolean;
    FAlready: Boolean;
    FSuccessPosition: Cardinal;
  protected
    function GetActive: Boolean; override;
    function GetCallId: Variant; override;
    function GetDirection: TBisCallServerChannelDirection; override;
    function GetCallerId: Variant; override;
    function GetAcceptor: Variant; override;
    function GetAcceptorType: TBisCallServerChannelAcceptorType; override;
    function GetCreatorId: Variant; override;
    function GetDateCreate: TDateTime; override;
  public
    constructor Create(AChannels: TBisCallServerChannels); override;
    destructor Destroy; override;
    procedure Answer; override;
    procedure Hangup; override;
    procedure PlayEnd(const Position: Cardinal); override;
  end;

  TBisCallServerChannelBacks=class(TBisCallServerChannels)
  private
    FHandler: TBisCallServerHandlerBack;
    function GetItem(Index: Integer): TBisCallServerChannelBack;
  protected
//    procedure DoChannelDestroy(Channel: TBisCallServerChannel); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Add(Id: String; CallId: Variant): TBisCallServerChannelBack; reintroduce;
    function AddChannel(OutMessageId: Variant; Phone: String;
                        Wave: TBisAudioWave; SuccessPosition: Cardinal): TBisCallServerChannelBack;
    function LockAddChannel(OutMessageId: Variant; Phone: String;
                            Wave: TBisAudioWave; SuccessPosition: Cardinal): TBisCallServerChannelBack;

    property Items[Index: Integer]: TBisCallServerChannelBack read GetItem; default;
  end;

  TBisCallServerHandlerBack=class(TBisCallServerHandler)
  private
    FServerThread: TBisWaitThread;
    FChannelThreads: TBisThreads;
    FInterval: Integer;
    FMaxCount: Integer;
    FPeriod: Integer;
    FBeforeText: String;
    FAfterText: String;
    FOperatorIds: TStringList;
    FBeforeWave: TBisAudioWave;
    FAfterWave: TBisAudioWave;
    FBeforeSilence: Cardinal;
    FAfterSilence: Cardinal;
    FInternalFormat: TPCMFormat;

    FSOutMessageParams: String;
    FSUnlockOutMessageStart: String;
    FSLockMessages: String;
    FSOutMessagesStart: String;
    FSUnlockOutMessageFail: String;
    FSOutMessageSendFail: String;
    FSUnlockOutMessageSuccess: String;
    FSOutMessageSendSuccess: String;
    FSOutMessagesStartAll: String;
    FSGetAudioSuccess: String;
    FSGetAudioFail: String;
    FSGetAudioStart: String;

    function GetChannels: TBisCallServerChannelBacks;

    function GetAudio(Text: String; Wave: TBisAudioWave): Boolean;
    function UnlockMessage(OutMessageId: Variant; Sent: Boolean): Boolean;

    procedure ChannelThreadsItemRemove(Sender: TBisThreads; Item: TBisThread);
    procedure ChannelThreadWork(Thread: TBisThread);
    procedure ChannelThreadDestroy(Thread: TBisThread);
    procedure ServerThreadTimeout(Thread: TBisWaitThread);

  protected
    function GetChannelsClass: TBisCallServerChannelsClass; override;
    function GetConnected: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Connect; override;
    procedure Disconnect; override;

    property Channels: TBisCallServerChannelBacks read GetChannels;
  published
    property SOutMessagesStart: String read FSOutMessagesStart write FSOutMessagesStart;
    property SOutMessagesStartAll: String read FSOutMessagesStartAll write FSOutMessagesStartAll;
    property SLockMessages: String read FSLockMessages write FSLockMessages;
    property SOutMessageParams: String read FSOutMessageParams write FSOutMessageParams;

    property SOutMessageSendSuccess: String read FSOutMessageSendSuccess write FSOutMessageSendSuccess;
    property SOutMessageSendFail: String read FSOutMessageSendFail write FSOutMessageSendFail;

    property SUnlockOutMessageStart: String read FSUnlockOutMessageStart write FSUnlockOutMessageStart;
    property SUnlockOutMessageSuccess: String read FSUnlockOutMessageSuccess write FSUnlockOutMessageSuccess;
    property SUnlockOutMessageFail: String read FSUnlockOutMessageFail write FSUnlockOutMessageFail;

    property SGetAudioStart: String read FSGetAudioStart write FSGetAudioStart;
    property SGetAudioSuccess: String read FSGetAudioSuccess write FSGetAudioSuccess;
    property SGetAudioFail: String read FSGetAudioFail write FSGetAudioFail;
  end;

procedure InitCallServerHandlerModule(AModule: TBisCallServerHandlerModule); stdcall;

exports
  InitCallServerHandlerModule;

implementation

uses Variants, DB,
     BisCore, BisProvider, BisFilterGroups, BisUtils, BisDataParams,
     BisConfig, BisConsts, BisLogger, BisNetUtils, BisDataSet,
     BisAudioUtils, BisAudioTextPhrases,
     BisCallServerHandlerBackConsts;

procedure InitCallServerHandlerModule(AModule: TBisCallServerHandlerModule); stdcall;
begin
  AModule.HandlerClass:=TBisCallServerHandlerBack;
end;

{ TBisCallServerChannelBack }

constructor TBisCallServerChannelBack.Create(AChannels: TBisCallServerChannels);
begin
  inherited Create(AChannels);

  FCallerId:=Core.AccountId;
  FCallId:=Null;
  FAcceptor:=Null;
  FCreatorId:=FCallerId;
  FDateCreate:=Core.ServerDate;
  FOutMessageId:=Null;
  FWave:=TBisAudioWave.Create;
end;

destructor TBisCallServerChannelBack.Destroy;
begin
  if not FAlready and Assigned(FHandler) then
    FHandler.UnlockMessage(FOutMessageId,false);
  FWave.Free;
  inherited Destroy;
end;

function TBisCallServerChannelBack.GetActive: Boolean;
begin
  Result:=FRunning;
end;

function TBisCallServerChannelBack.GetCallerId: Variant;
begin
  Result:=FCallerId;
end;

function TBisCallServerChannelBack.GetCallId: Variant;
begin
  Result:=FCallId;
end;

function TBisCallServerChannelBack.GetAcceptor: Variant;
begin
  Result:=FAcceptor;
end;

function TBisCallServerChannelBack.GetAcceptorType: TBisCallServerChannelAcceptorType;
begin
  Result:=FAcceptorType;
end;

function TBisCallServerChannelBack.GetCreatorId: Variant;
begin
  Result:=FCreatorId;
end;

function TBisCallServerChannelBack.GetDateCreate: TDateTime;
begin
  Result:=FDateCreate;
end;

function TBisCallServerChannelBack.GetDirection: TBisCallServerChannelDirection;
begin
  Result:=cdIncoming;
end;

procedure TBisCallServerChannelBack.Answer;
begin
  inherited Answer;
  DoPlay(FWave);
  FRunning:=true;
  FAlready:=false;
end;

procedure TBisCallServerChannelBack.Hangup;
begin
  inherited Hangup;
  DoStop;
  FRunning:=false;
end;

procedure TBisCallServerChannelBack.PlayEnd(const Position: Cardinal);
begin
  inherited PlayEnd(Position);
  if not FAlready and Assigned(FHandler) then
    FAlready:=FHandler.UnlockMessage(FOutMessageId,Position>=FSuccessPosition);
  DoDisconnect;
  LockRemove;
end;

{ TBisCallServerChannelBacks }

constructor TBisCallServerChannelBacks.Create;
begin
  inherited Create;
end;

destructor TBisCallServerChannelBacks.Destroy;
begin
  inherited Destroy;
end;

function TBisCallServerChannelBacks.GetItem(Index: Integer): TBisCallServerChannelBack;
begin
  Result:=TBisCallServerChannelBack(inherited Items[Index]);
end;

function TBisCallServerChannelBacks.Add(Id: String; CallId: Variant): TBisCallServerChannelBack;
begin
  Result:=nil;
  if not Assigned(Result) then begin
    Result:=TBisCallServerChannelBack(inherited AddClass(TBisCallServerChannelBack,false));
    if Assigned(Result) then begin
      Result.FCallId:=CallId;
      Result.FHandler:=FHandler;
    end;
  end;
end;

function TBisCallServerChannelBacks.AddChannel(OutMessageId: Variant; Phone: String;
                                               Wave: TBisAudioWave; SuccessPosition: Cardinal): TBisCallServerChannelBack;
begin
  Result:=Add(GetUniqueID,GetUniqueID);
  if Assigned(Result) then begin
    Result.FAcceptorType:=catPhone;
    Result.FAcceptor:=Phone;
    Result.FOutMessageId:=OutMessageId;
    Result.FWave.Assign(Wave);
    Result.FSuccessPosition:=SuccessPosition;
    DoChannelCreate(Result);
  end;
end;

function TBisCallServerChannelBacks.LockAddChannel(OutMessageId: Variant; Phone: String;
                                                   Wave: TBisAudioWave; SuccessPosition: Cardinal): TBisCallServerChannelBack;
begin
  Lock;
  try
    Result:=AddChannel(OutMessageId,Phone,Wave,SuccessPosition);
  finally
    UnLock;
  end;
end;

type
  TBisCallBackChannelThread=class(TBisThread)
  private
    FOutMessageId: Variant;
    FTextOut: String;
    FPhone: String;
  end;

  TBisCallBackServerThread=class(TBisWaitThread)
  end;

{ TBisCallServerHandlerBack }

constructor TBisCallServerHandlerBack.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Channels.FHandler:=Self;

  FOperatorIds:=TStringList.Create;

  FInternalFormat:=Mono16bit8000Hz;

  FBeforeWave:=TBisAudioWave.Create;
  FAfterWave:=TBisAudioWave.Create;

  FServerThread:=TBisCallBackServerThread.Create;
  FServerThread.OnTimeout:=ServerThreadTimeout;

  FChannelThreads:=TBisThreads.Create;
  FChannelThreads.OwnsObjects:=false;
  FChannelThreads.OnItemRemove:=ChannelThreadsItemRemove;

  FSOutMessagesStart:='��������� ��������� ��������� ��� ��������� %s ...';
  FSOutMessagesStartAll:='��������� ��������� ��������� ��� ���� ���������� ...';
  FSLockMessages:='������������� %d ��������� ���������.';
  FSOutMessageParams:='��������� ���������� ���������: �������������=>%s �����=>%s �����=>%s';
  FSOutMessageSendSuccess:='��������� ��������� ���������� �������.';
  FSOutMessageSendFail:='��������� ��������� �� ����������.';
  FSUnlockOutMessageStart:='������ ������������� ��������� ...';
  FSUnlockOutMessageSuccess:='������������� ��������� ��������� �������.';
  FSUnlockOutMessageFail:='������������� ��������� �� ���������. %s';
  FSGetAudioStart:='��������� ����� ��� ������ (%s) ...';
  FSGetAudioSuccess:='��������� ����� ��������� �������. ����� ���� %d';
  FSGetAudioFail:='��������� ����� �� ���������. %s';

end;

destructor TBisCallServerHandlerBack.Destroy;
begin
  Disconnect;
  FreeAndNilEx(FChannelThreads);
  FServerThread.Free;
  FAfterWave.Free;
  FBeforeWave.Free;
  FOperatorIds.Free;
  inherited Destroy;
end;

procedure TBisCallServerHandlerBack.Init;
begin
  inherited Init;
  with Params do begin
    FInterval:=AsInteger(SParamInterval,FInterval);
    FMaxCount:=AsInteger(SParamMaxCount,FMaxCount);
    FPeriod:=AsInteger(SParamPeriod,FPeriod);
    FBeforeText:=AsString(SParamBeforeText);
    FAfterText:=AsString(SParamAfterText);
    FBeforeSilence:=AsInteger(SParamBeforeSilence);
    FAfterSilence:=AsInteger(SParamAfterSilence);
    FInternalFormat:=AsEnumeration(SParamInternalFormat,TypeInfo(TPCMFormat),FInternalFormat);
    FOperatorIds.Text:=Trim(AsString(SParamOperatorIds));
  end;
end;

function TBisCallServerHandlerBack.GetChannels: TBisCallServerChannelBacks;
begin
  Result:=TBisCallServerChannelBacks(inherited Channels);
end;

function TBisCallServerHandlerBack.GetChannelsClass: TBisCallServerChannelsClass;
begin
  Result:=TBisCallServerChannelBacks;
end;

function TBisCallServerHandlerBack.GetAudio(Text: String; Wave: TBisAudioWave): Boolean;
var
  Phrases: TBisAudioTextPhrases;
begin
  Result:=false;
  LoggerWrite(FormatEx(FSGetAudioStart,[Text]));
  try
    Phrases:=TBisAudioTextPhrases.Create;
    try
      GetAudioTextPhrases(Text,Phrases);
      GetAudioPhrasesWave(Phrases,Wave);
      Result:=true;
      LoggerWrite(FormatEx(FSGetAudioSuccess,[Phrases.Count]));
    finally
      Phrases.Free;
    end;
  except
    on E: Exception do
      LoggerWrite(FormatEx(FSGetAudioFail,[E.Message]),ltError);
  end;
end;

function TBisCallServerHandlerBack.UnlockMessage(OutMessageId: Variant; Sent: Boolean): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  LoggerWrite(FSUnlockOutMessageStart);
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='UNLOCK_OUT_MESSAGE';
    with P.Params do begin
      AddInvisible('OUT_MESSAGE_ID').Value:=OutMessageId;
      AddInvisible('SENT').Value:=Integer(Sent);
      AddInvisible('MESSAGE_ID').Value:=Null;
    end;
    try
      P.Execute;
      Result:=P.Success;
      if Result then
        LoggerWrite(FSUnlockOutMessageSuccess);
    except
      On E: Exception do
        LoggerWrite(FormatEx(FSUnlockOutMessageFail,[E.Message]),ltError);
    end;
  finally
    P.Free;
  end;
end;

procedure TBisCallServerHandlerBack.ChannelThreadWork(Thread: TBisThread);

  function Merge(Wave: TBisAudioWave): Cardinal;
  var
    W: TBisAudioWave;
    Position: Cardinal;
  begin
    W:=TBisAudioWave.Create;
    try
      Position:=0;
      W.BeginRewrite(Wave.WaveFormat);
      W.EndRewrite;
      if not FBeforeWave.Empty then begin
        W.Insert(Position,FBeforeWave);
        Inc(Position,FBeforeWave.Length);
      end;
      W.InsertSilence(Position,FBeforeSilence);
      Inc(Position,FBeforeSilence);
      W.Insert(Position,Wave);
      Inc(Position,Wave.Length);
      Result:=Position;
      W.InsertSilence(Position,FAfterSilence);
      Inc(Position,FAfterSilence);
      if not FAfterWave.Empty then begin
        W.Insert(Position,FAfterWave);
      end;
      Wave.Assign(W);
    finally
      W.Free;
    end;
  end;

var
  Wave: TBisAudioWave;
  AThread: TBisCallBackChannelThread;
  Channel: TBisCallServerChannelBack;
  FreeChannel: Boolean;
  SuccessPosition: Cardinal;
begin
  AThread:=TBisCallBackChannelThread(Thread);

  Wave:=TBisAudioWave.Create;
  try
    Wave.BeginRewritePCM(FInternalFormat);
    Wave.EndRewrite;
    if GetAudio(AThread.FTextOut,Wave) and not Thread.Terminated then begin
      SuccessPosition:=Merge(Wave);
      Channel:=Channels.LockAddChannel(AThread.FOutMessageId,AThread.FPhone,Wave,SuccessPosition);
      if Assigned(Channel) then begin
        if not Thread.Terminated then begin
          FreeChannel:=true;
          Channel.Lock;
          try
            if Channel.DoCheck then begin
              Channel.DoRing;
              FreeChannel:=false;
            end;
          finally
            Channel.Unlock;
            if FreeChannel then
              Channels.LockRemove(Channel);
          end;
        end else
          Channels.LockRemove(Channel);
      end;
    end else
      UnlockMessage(AThread.FOutMessageId,false);
  finally
    Wave.Free;
  end;
end;

procedure TBisCallServerHandlerBack.ChannelThreadsItemRemove(Sender: TBisThreads; Item: TBisThread);
begin
  Item.OnDestroy:=nil;
  if Item.Working and Sender.Destroying then
    Item.Stop
  else
    Item.Terminate;
end;

procedure TBisCallServerHandlerBack.ChannelThreadDestroy(Thread: TBisThread);
begin
  if Assigned(FChannelThreads) and not FChannelThreads.Destroying then
    FChannelThreads.LockRemove(Thread);
end;

procedure TBisCallServerHandlerBack.ServerThreadTimeout(Thread: TBisWaitThread);

  procedure OutMessages(OperatorId: Variant);
  const
    PhoneChars=['+','0','1','2','3','4','5','6','7','8','9'];
  var
    Locked: String;
    PSelect: TBisProvider;
    PLock: TBisProvider;
    LockCount: Integer;
    i: Integer;
    S: String;
    Field: TField;
    TextOut: String;
    Dest: String;
    MessageId: Variant;
    OutMessageId: Variant;
    NeedUnlock: Boolean;
    ChannelThread: TBisCallBackChannelThread;
  begin
    if VarIsNull(OperatorId) then
      LoggerWrite(FSOutMessagesStartAll)
    else
      LoggerWrite(FormatEx(FSOutMessagesStart,[VarToStrDef(OperatorId,'')]));
    PLock:=TBisProvider.Create(nil);
    try
      Locked:=GetUniqueID;
      PLock.ProviderName:='LOCK_OUT_MESSAGES';
      with PLock.Params do begin
        AddInvisible('MAX_COUNT').Value:=FMaxCount;
        AddInvisible('LOCKED').Value:=Locked;
        AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
        AddInvisible('PERIOD').Value:=iff(FPeriod=0,MaxInt,FPeriod);
        AddInvisible('CHANNEL').Value:=Null;
        AddInvisible('OPERATOR_ID').Value:=OperatorId;
        AddInvisible('LOCK_COUNT',ptOutput).Value:=0;
      end;
      try
        PLock.Execute;
        if PLock.Success then begin
          LockCount:=PLock.Params.ParamByName('LOCK_COUNT').AsInteger;
          LoggerWrite(FormatEx(FSLockMessages,[LockCount]));

          if LockCount>0 then begin

            PSelect:=TBisProvider.Create(nil);
            try
              PSelect.ProviderName:='S_OUT_MESSAGES';
              with PSelect do begin
                with FieldNames do begin
                  AddInvisible('OUT_MESSAGE_ID');
                  AddInvisible('CREATOR_ID');
                  AddInvisible('RECIPIENT_ID');
                  AddInvisible('DATE_CREATE');
                  AddInvisible('TEXT_OUT');
                  AddInvisible('CONTACT');
                  AddInvisible('DELIVERY');
                  AddInvisible('FLASH');
                  AddInvisible('DEST_PORT');
                  AddInvisible('DESCRIPTION');
                  AddInvisible('SOURCE');
                  AddInvisible('CREATOR_NAME');
                  AddInvisible('RECIPIENT_NAME');
                  AddInvisible('RECIPIENT_PHONE');
                end;
                with FilterGroups.Add do begin
                  Filters.Add('LOCKED',fcEqual,Locked).CheckCase:=true;
                  Filters.Add('DATE_OUT',fcIsNull,Null);
                  Filters.Add('TYPE_MESSAGE',fcEqual,DefaultTypeMessage);
                end;
                with Orders do begin
                  Add('PRIORITY');
                  Add('DATE_BEGIN');
                end;
              end;
              try
                PSelect.Open;
                if PSelect.Active and not PSelect.IsEmpty then begin
                  PSelect.First;
                  while not PSelect.Eof do begin
                    MessageId:=Null;
                    OutMessageId:=PSelect.FieldByName('OUT_MESSAGE_ID').Value;
                    NeedUnlock:=true;
                    try
                      if not Thread.Terminated then begin

                        S:=PSelect.FieldByName('TEXT_OUT').AsString;
                        for i:=0 to PSelect.Fields.Count-1 do begin
                          Field:=PSelect.Fields[i];
                          if not AnsiSameText(Field.FieldName,'TEXT_OUT') then
                            S:=StringReplace(S,'%'+Field.FieldName,VarToStrDef(Field.Value,''),[rfReplaceAll, rfIgnoreCase]);
                        end;
                        TextOut:=S;

                        Dest:=GetOnlyChars(PSelect.FieldByName('CONTACT').AsString,PhoneChars);
                        if Dest<>'' then begin

                          LoggerWrite(FormatEx(FSOutMessageParams,[VarToStrDef(OutMessageId,''),Dest,TextOut]));

                          ChannelThread:=TBisCallBackChannelThread.Create;
                          with ChannelThread do begin
                            FOutMessageId:=OutMessageId;
                            FTextOut:=TextOut;
                            FPhone:=Dest;
                            OnWork:=ChannelThreadWork;
                            OnDestroy:=ChannelThreadDestroy;
                            FreeOnEnd:=true;
                            StopOnDestroy:=false;
                            Start;
                          end;
                          FChannelThreads.LockAdd(ChannelThread);

                          NeedUnlock:=false;

                        end;
                      end;
                      PSelect.Next;
                    finally
                      if NeedUnlock then
                        UnlockMessage(OutMessageId,false);
                    end;
                  end;
                end;
              except
                On E: Exception do
                  LoggerWrite(E.Message,ltError);
              end;
            finally
              PSelect.Free;
            end;
          end;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      PLock.Free;
    end;
  end;

  procedure OutMessagesByOperators;
  var
    i: Integer;
  begin
    if FOperatorIds.Count>0 then begin
      for i:=0 to FOperatorIds.Count-1 do begin
        if Thread.Terminated then
          break;
         OutMessages(FOperatorIds[i]); 
      end;
    end else
      OutMessages(Null);
  end;

begin
  if Assigned(Core) then begin
    try
      try
        OutMessagesByOperators;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      Thread.Reset;
    end;
  end;
end;

function TBisCallServerHandlerBack.GetConnected: Boolean;
begin
  Result:=FServerThread.Working;
end;

procedure TBisCallServerHandlerBack.Connect;
begin
  Disconnect;
  if not Connected and Enabled then begin
    LoggerWrite(SConnect);
    try
      inherited Connect;

      FBeforeWave.BeginRewritePCM(FInternalFormat);
      FBeforeWave.EndRewrite;
      GetAudio(FBeforeText,FBeforeWave);

      FAfterWave.BeginRewritePCM(FInternalFormat);
      FAfterWave.EndRewrite;
      GetAudio(FAfterText,FAfterWave);

      FServerThread.Timeout:=FInterval;
      FServerThread.Start;
      LoggerWrite(SConnectSuccess);
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(SConnectFail,[E.Message]),ltError);
      end;
    end;
  end;
end;

procedure TBisCallServerHandlerBack.Disconnect;
begin
  if Connected then begin
    LoggerWrite(SDisconnect);
    try
      inherited Disconnect;
      FServerThread.Stop;
      FChannelThreads.LockClear;
      LoggerWrite(SDisconnectSuccess);
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(SDisconnectFail,[E.Message]),ltError);
      end;
    end;   
  end;
end;

end.
