unit SipClient;

interface

uses Classes, Contnrs,
     BisSip, BisThreads;

type

  TBisSipReceiver=class(TObject)
  private
    FID: String;
  protected
    function ReceiveRequest(Request: TBisSipRequest): Boolean; virtual;
    function ReceiveResponse(Response: TBisSipResponse): Boolean; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property ID: String read FID write FID;
  end;

  TBisSipReceiverClass=class of TBisSipReceiver;

  TBisSipReceivers=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisSipReceiver;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Receive(Data: String);
    function FindByID(ID: String): TBisSipReceiver;
    procedure GetReceivers(AClass: TBisSipReceiverClass; Receivers: TBisSipReceivers);

    property Items[Index: Integer]: TBisSipReceiver read GetItem; default;
  end;

  TBisSipTransport=class;

  TBisSipTransport=class(TObject)
  private
    FReceivers: TBisSipReceivers;
  protected
    class function GetName: String; virtual;
    function GetActive: Boolean; virtual;
    procedure SetActive(const Value: Boolean); virtual;
    function Send(Host: String; Port: Integer; Data: String): Boolean; virtual;

    property Receivers: TBisSipReceivers read FReceivers;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property Name: String read GetName;
    property Active: Boolean read GetActive write SetActive;

  end;

  TBisSipClient=class;

  TBisSipSessionState=(ssReady,ssWaiting,ssRinging,ssConfirming,ssBreaking,ssProcessing,ssTrying,ssProgressing,ssDestroying);

  TBisSipSessionDirection=(sdUnknown,sdIncoming,sdOutgoing);

  TBisSipSession=class(TBisSipReceiver)
  private
    FRequests: TBisSipRequests;
    FRegistrar: TBisSipClient;
    FState: TBisSipSessionState;
    FReadyForDestroy: Boolean;
    FDirection: TBisSipSessionDirection;
    FContentTypeKind: TBisSipContentTypeKind;
    FIdleTimeOut: Integer;
    FSequence: Integer;
    function Accept(Message: TBisSipMessage): Boolean;
    function ValidSequence(Sequence: String): Boolean;
  protected
    function ReceiveRequest(Request: TBisSipRequest): Boolean; override;
    function ReceiveResponse(Response: TBisSipResponse): Boolean; override;
  public
    constructor Create(Registrar: TBisSipClient; Direction: TBisSipSessionDirection); reintroduce;
    destructor Destroy; override;

    procedure ResponseInviteOK(Body: String; ContentTypeKind: TBisSipContentTypeKind=ctkApplicationSdp);
    procedure ResponseInviteBusyHere;

    procedure RequestBye;
    procedure RequestInvite(User, Body: String; ContentTypeKind: TBisSipContentTypeKind=ctkApplicationSdp);
    procedure RequestCancel;

    function NextSequence: String;

    property State: TBisSipSessionState read FState;
    property Direction: TBisSipSessionDirection read FDirection;
    property ContentTypeKind: TBisSipContentTypeKind read FContentTypeKind;
  end;

  TBisSipSessions=class(TBisSipReceivers)
  private
    FRegistrar: TBisSipClient;
    function GetSession(Index: Integer): TBisSipSession;
  public
    constructor Create(Registrar: TBisSipClient); reintroduce;
    function FindByID(ID: String): TBisSipSession; reintroduce;
    function FindByMessage(Message: TBisSipMessage): TBisSipSession; 
    function Add(ID: String; Direction: TBisSipSessionDirection): TBisSipSession; overload;
    function Add(Direction: TBisSipSessionDirection): TBisSipSession; overload;

    property Items[Index: Integer]: TBisSipSession read GetSession; default;
  end;

  TBisSipMessageWaitThread=class(TBisWaitThread)
  private
    FMessage: TBisSipMessage;
  public
    constructor Create(const TimeOut: Cardinal; Message: TBisSipMessage); reintroduce;
    procedure CleanUp; override;
  end;

  TBisSipMessageWaitThreads=class(TBisThreads)
  private
    FOnTimeOut: TBisWaitThreadEvent;
    FTimeOut: Cardinal;
    function GetItem(Index: Integer): TBisSipMessageWaitThread;
    procedure ItemDestroy(Thread: TBisThread);
  protected
    procedure DoItemFree(Item: TObject); override;  
  public
    function LockAdd(Message: TBisSipMessage): TBisSipMessageWaitThread; reintroduce;
    procedure LockRemoveBy(Message: TBisSipMessage);

    property Items[Index: Integer]: TBisSipMessageWaitThread read GetItem; default;
  end;
  
  TBisSipClientEvent=procedure (Sender: TBisSipClient) of object;
  TBisSipClientAcceptEvent=function (Sender: TBisSipClient; Session: TBisSipSession; Message: TBisSipMessage): Boolean of object;
  TBisSipClientSessionEvent=procedure (Sender: TBisSipClient; Session: TBisSipSession) of object;
  TBisSipClientSessionTimeoutEvent=procedure (Sender: TBisSipClient; Session: TBisSipSession; var TryRegister: Boolean) of object;
  TBisSipClientAliveEvent=function (Sender: TBisSipClient; Session: TBisSipSession): Boolean of object;
  TBisSipClientMessageTimeoutEvent=procedure (Sender: TBisSipClient; Message: TBisSipMessage; var TryRegister: Boolean) of object;
  TBisSipClientSessionContentEvent=procedure (Sender: TBisSipClient; Session: TBisSipSession; Content: String) of object;

  TBisSipClient=class(TBisSipReceiver)
  private
    FScheme, FProtocol: String;
    FRemoteHost: String;
    FRemotePort: Integer;
    FRemoteIP: String;
    FLocalIP: String;
    FLocalPort: Integer;
    FUserName: String;
    FPassword: String;
    FExpires: Integer;
    FQ: String;
    FUserAgent: String;
    FSequence: Integer;
    FTransport: TBisSipTransport;
    FRequests: TBisSipRequests;
    FMaxForwards: Integer;
    FOnRegister: TBisSipClientEvent;
    FRegistered: Boolean;
    FWaitRetryCount: Cardinal;
    FUseRport: Boolean;
    FKeepAliveQuery: String;
    FSessionIdleTimeOut: Integer;
    FSessionAlive: Integer;
    FUseTrasnportNameInUri: Boolean;
    FUsePortInUri: Boolean;
    FUseGlobalSequence: Boolean;

    FLastRequest: TBisSipRequest;
    FWaits: TBisSipMessageWaitThreads;
    FSessions: TBisSipSessions;
    FKeepAlive: Integer;
    FUseReceived: Boolean;
    FReceived: String;
//    FTimers: TBisSipTimerThreads;

    FSExpiresTimer: String;
    FSAliveTimer: String;

    FOnSessionRing: TBisSipClientSessionEvent;
    FOnSessionProgress: TBisSipClientSessionEvent;
    FOnSessionCreate: TBisSipClientSessionEvent;
    FOnSessionDestroy: TBisSipClientSessionEvent;
    FOnSessionConfirm: TBisSipClientSessionEvent;
    FOnSessionTerminate: TBisSipClientSessionEvent;
    FOnSessionAccept: TBisSipClientAcceptEvent;
    FOnSessionAlive: TBisSipClientAliveEvent;
    FOnMessageTimeout: TBisSipClientMessageTimeoutEvent;
    FOnSessionTimeout: TBisSipClientSessionTimeoutEvent;
    FOnSessionContent: TBisSipClientSessionContentEvent;

    procedure SendRequest(Request: TBisSipRequest; WithWait: Boolean=true);
    procedure SendResponse(Response: TBisSipResponse; WithWait: Boolean=false);
    procedure SetTransport(const Value: TBisSipTransport);
    procedure WaitsTimeOut(Thread: TBisWaitThread);
    procedure AddReceiver(Receiver: TBisSipReceiver);
    procedure RemoveReceiver(Receiver: TBisSipReceiver);
    procedure RemoveWaits(Session: TBisSipSession);
    function GetTransportName: String;
//    procedure RegisterTimer(Sender: TBisSipTimerThread);
//    procedure KeepAliveTimer(Sender: TBisSipTimerThread);
//    procedure SessionTimer(Sender: TBisSipTimerThread);
    procedure FirstRegister(Request: TBisSipRequest=nil);
    function GetUri: String;
    function GetWaitTimeOut: Cardinal;
    procedure SetWaitTimeOut(const Value: Cardinal);
  protected
    function ReceiveRequest(Request: TBisSipRequest): Boolean; override;
    function ReceiveResponse(Response: TBisSipResponse): Boolean; override;
    procedure DoRegister; virtual;
    procedure DoMessageTimeout(Message: TBisSipMessage; var TryRegister: Boolean); virtual;
    procedure DoSessionCreate(Session: TBisSipSession); virtual;
    procedure DoSessionDestroy(Session: TBisSipSession); virtual;
    function DoSessionAccept(Session: TBisSipSession; Message: TBisSipMessage): Boolean; virtual;
    procedure DoSessionRing(Session: TBisSipSession); virtual;
    procedure DoSessionProgress(Session: TBisSipSession); virtual;
    procedure DoSessionConfirm(Session: TBisSipSession); virtual;
    procedure DoSessionTerminate(Session: TBisSipSession); virtual;
    function DoSessionAlive(Session: TBisSipSession): Boolean; virtual;
    procedure DoSessionTimeout(Session: TBisSipSession; var TryRegister: Boolean); virtual;
    procedure DoSessionContent(Session: TBisSipSession; Content: String); virtual;
  public
    constructor Create; override;
    destructor Destroy; override;
    function NextSequence: String;

    procedure Register(Active: Boolean; Initial: Boolean=false);
    function UriTransportName: String;
    function UriLocalPort: String;
    function UriRemotePort: String;
    function CheckUri(Uri: String): Boolean;

    property Sessions: TBisSipSessions read FSessions;
    property Registered: Boolean read FRegistered;
    property Uri: String read GetUri;
    property TransportName: String read GetTransportName;

    property Transport: TBisSipTransport read FTransport write SetTransport;
    property Scheme: String read FScheme write FScheme;
    property Protocol: String read FProtocol write FProtocol;
    property RemoteHost: String read FRemoteHost write FRemoteHost;
    property RemoteIP: String read FRemoteIP write FRemoteIP;
    property RemotePort: Integer read FRemotePort write FRemotePort;
    property LocalIP: String read FLocalIP write FLocalIP;
    property LocalPort: Integer read FLocalPort write FLocalPort;
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property Expires: Integer read FExpires write FExpires;
    property UserAgent: String read FUserAgent write FUserAgent;
    property MaxForwards: Integer read FMaxForwards write FMaxForwards;
    property KeepAlive: Integer read FKeepAlive write FKeepAlive;
    property KeepAliveQuery: String read FKeepAliveQuery write FKeepAliveQuery;
    property UseReceived: Boolean read FUseReceived write FUseReceived;
    property UseRport: Boolean read FUseRport write FUseRport;
    property UseTrasnportNameInUri: Boolean read FUseTrasnportNameInUri write FUseTrasnportNameInUri;
    property UsePortInUri: Boolean read FUsePortInUri write FUsePortInUri;
    property UseGlobalSequence: Boolean read FUseGlobalSequence write FUseGlobalSequence;
    property WaitRetryCount: Cardinal read FWaitRetryCount write FWaitRetryCount;
    property WaitTimeOut: Cardinal read GetWaitTimeOut write SetWaitTimeOut;
    property SessionAlive: Integer read FSessionAlive write FSessionAlive;
    property SessionIdleTimeOut: Integer read FSessionIdleTimeOut write FSessionIdleTimeOut;

    property OnRegister: TBisSipClientEvent read FOnRegister write FOnRegister;
    property OnMessageTimeout: TBisSipClientMessageTimeoutEvent read FOnMessageTimeout write FOnMessageTimeout;
    property OnSessionCreate: TBisSipClientSessionEvent read FOnSessionCreate write FOnSessionCreate;
    property OnSessionDestroy: TBisSipClientSessionEvent read FOnSessionDestroy write FOnSessionDestroy; 
    property OnSessionAccept: TBisSipClientAcceptEvent read FOnSessionAccept write FOnSessionAccept; 
    property OnSessionRing: TBisSipClientSessionEvent read FOnSessionRing write FOnSessionRing;
    property OnSessionProgress: TBisSipClientSessionEvent read FOnSessionProgress write FOnSessionProgress;
    property OnSessionConfirm: TBisSipClientSessionEvent read FOnSessionConfirm write FOnSessionConfirm;
    property OnSessionTerminate: TBisSipClientSessionEvent read FOnSessionTerminate write FOnSessionTerminate;
    property OnSessionAlive: TBisSipClientAliveEvent read FOnSessionAlive write FOnSessionAlive;
    property OnSessionTimeout: TBisSipClientSessionTimeoutEvent read FOnSessionTimeout write FOnSessionTimeout; 
    property OnSessionContent: TBisSipClientSessionContentEvent read FOnSessionContent write FOnSessionContent; 

  end;


implementation

{ TBisSipReceiver }

constructor TBisSipReceiver.Create;
begin
  inherited Create;
  FID:=GetUniqueID;
//  FLock:=TCriticalSection.Create;
end;

destructor TBisSipReceiver.Destroy;
begin
//  FLock.Free;
  inherited Destroy;
end;

function TBisSipReceiver.ReceiveRequest(Request: TBisSipRequest): Boolean;
begin
  Result:=false;
end;

function TBisSipReceiver.ReceiveResponse(Response: TBisSipResponse): Boolean;
begin
  Result:=false;
end;

{ TBisSipReceivers }

function TBisSipReceivers.GetItem(Index: Integer): TBisSipReceiver;
begin
  Result:=TBisSipReceiver(inherited Items[Index]);
end;

procedure TBisSipReceivers.GetReceivers(AClass: TBisSipReceiverClass; Receivers: TBisSipReceivers);
var
  i: Integer;
  Item: TBisSipReceiver;
begin
  if Assigned(AClass) then begin
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if IsClassParent(Item.ClassType,AClass) then begin
        Receivers.Add(Item)
      end;
    end;
  end;
end;

constructor TBisSipReceivers.Create;
begin
  inherited Create(true);
end;

destructor TBisSipReceivers.Destroy;
begin
  inherited Destroy;
end;

function TBisSipReceivers.FindByID(ID: String): TBisSipReceiver;
var
  i: Integer;
  Item: TBisSipReceiver;
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

procedure TBisSipReceivers.Receive(Data: String);

  function ParseStrings(Strings: TStrings; Headers: TBisSipHeaders;
                        var H1, H2, H3: String; var LastIndex: Integer): Boolean;
  var
    Temp: TStringList;
    i: Integer;
    S: String;
  begin
    Result:=Strings.Count>0;
    if Result then begin
      Temp:=TStringList.Create;
      try
        GetStringsByString(Strings[0],' ',Temp);
        if Temp.Count>0 then begin
          H1:=Temp[0];
          if Temp.Count>1 then begin
            H2:=Temp[1];
            if Temp.Count>2 then begin
              for i:=2 to Temp.Count-1 do
                H3:=Trim(H3+' '+Temp[i]);
            end;
          end;
        end;
        Result:=(H1<>'');
        if Result and (Strings.Count>1) then begin
          LastIndex:=Strings.Count;
          for i:=1 to Strings.Count-1 do begin
            S:=Trim(Strings[i]);
            if S<>'' then
              Headers.ParseHeader(S)
            else begin
              LastIndex:=i;
              break
            end;
          end;
        end;
      finally
        Temp.Free;
      end;
    end;
  end;

  function ParseBody(Strings: TStrings; LastIndex: Integer): String;
  var
    i: Integer;
    Temp: TStringList;
  begin
    Temp:=TStringList.Create;
    try
      for i:=LastIndex to Strings.Count-1 do
        Temp.Add(Strings[i]);
      Result:=Trim(Temp.Text);
    finally
      Temp.Free;
    end;
  end;

  procedure ReceiverRequest(Receiver: TBisSipReceiver;
                            Name, Uri, Protocol: String;
                            Headers: TBisSipHeaders; Body: String);
  var
    Request: TBisSipRequest;
  begin
    Request:=TBisSipRequest.Create(rdIncoming,Name,Uri,Protocol);
    Request.Headers.CopyFrom(Headers);
    Request.Body.Text:=Body;
    if not Receiver.ReceiveRequest(Request) then
      Request.Free;
  end;

  procedure ReceiverResponse(Receiver: TBisSipReceiver;
                             Protocol, Code, Description: String;
                             Headers: TBisSipHeaders; Body: String);
  var
    Response: TBisSipResponse;
  begin
    Response:=TBisSipResponse.Create(Protocol,Code,Description);
    Response.Headers.CopyFrom(Headers);
    Response.Body.Text:=Body;
    if not Receiver.ReceiveResponse(Response) then
      Response.Free;
  end;

  function TryToRemoveSession(Session: TBisSipSession): Boolean;
  begin
    Result:=false;
    if Assigned(Session) and (Session.State=ssDestroying) then
      if Assigned(Session.FRegistrar) then begin
        Session.FRegistrar.Sessions.Remove(Session);
        Result:=true;
      end;
  end;
  
  procedure PlanTimeOut(Receiver: TBisSipReceiver);
  begin
    if Assigned(Receiver) and (Receiver is TBisSipSession) then begin
      TBisSipSession(Receiver).FIdleTimeOut:=0; 
    end;
  end;

  procedure UnknownRequest(ID, Name, Uri, Protocol: String;
                           Headers: TBisSipHeaders; Body: String);

    function FindRegistrar: TBisSipRegistrar;
    var
      Receivers: TBisSipReceivers;
      Registrar: TBisSipRegistrar;
      i: Integer;
    begin
      Result:=nil;
      Receivers:=TBisSipReceivers.Create;
      try
        Receivers.OwnsObjects:=false;
        GetReceivers(TBisSipRegistrar,Receivers);
        for i:=0 to Receivers.Count-1 do begin
          Registrar:=TBisSipRegistrar(Receivers.Items[i]);
          if Registrar.CheckUri(Uri) then begin
            Result:=Registrar;
            exit;
          end;
        end;
      finally
        Receivers.Free;
      end;
    end;

  var
    Registrar: TBisSipRegistrar;
    Session: TBisSipSession;
    Request: TBisSipRequest;
    RequestType: TBisSipRequestType;
  begin
    Registrar:=FindRegistrar;
    if Assigned(Registrar) {and Registrar.Registered }then begin
      if TBisSipRequest.RequestNameToType(Name,RequestType) and (RequestType=rtINVITE) then begin
        Session:=Registrar.Sessions.Add(ID,sdIncoming);
        if Assigned(Session) then begin
          try
            Request:=TBisSipRequest.Create(rdIncoming,RequestType,Uri,Protocol);
            Request.Headers.CopyFrom(Headers);
            Request.Body.Text:=Body;
            if not Session.ReceiveRequest(Request) then
              Request.Free;
          finally
            if Session.FReadyForDestroy then
              if not TryToRemoveSession(Session) then
                PlanTimeOut(Session);
          end;
        end;
      end;
    end;
  end;

  function TryToRemoveReceiver(var Receiver: TBisSipReceiver; WithReadyForDestroy: Boolean): Boolean;
  var
    Flag: Boolean;
  begin
    Result:=false;
    if (Receiver is TBisSipSession) then begin
      Flag:=true;
      if WithReadyForDestroy then
        Flag:=TBisSipSession(Receiver).FReadyForDestroy;
      if Flag then begin
        Result:=TryToRemoveSession(TBisSipSession(Receiver));
        if Result then
          Receiver:=nil;
      end;
    end;
  end;

var
  Strings: TStrings;
  Headers: TBisSipHeaders;
  H1, H2, H3: String;
  LastIndex: Integer;
  IsRequest: Boolean;
  RequestType: TBisSipRequestType;
  CallID: TBisSipCallID;
  Receiver: TBisSipReceiver;
  Body: String;
begin
  Strings:=TStringList.Create;
  Headers:=TBisSipHeaders.Create;
  try
    Strings.Text:=Trim(Data);
    if ParseStrings(Strings,Headers,H1,H2,H3,LastIndex) then begin
      CallID:=TBisSipCallID(Headers.Find(TBisSipCallID));
      if Assigned(CallID) then begin
        Receiver:=FindByID(CallID.Value);
        IsRequest:=TBisSipRequest.RequestNameToType(H1,RequestType) and (RequestType<>rtUNKNOWN);
        Body:=ParseBody(Strings,LastIndex);
        if Assigned(Receiver) then begin
          if not TryToRemoveReceiver(Receiver,false) then begin
            try
              if IsRequest then
                ReceiverRequest(Receiver,H1,H2,H3,Headers,Body)
              else
                ReceiverResponse(Receiver,H1,H2,H3,Headers,Body);
            finally
              if not TryToRemoveReceiver(Receiver,true) then
                PlanTimeOut(Receiver);
            end;
          end;
        end else begin
          if IsRequest then
            UnknownRequest(CallID.Value,H1,H2,H3,Headers,Body);
        end;
      end;
    end;
  finally
    Headers.Free;
    Strings.Free;
  end;
end;

{ TBisSipTransport }

constructor TBisSipTransport.Create;
begin
  inherited Create;
  FReceivers:=TBisSipReceivers.Create;
  FReceivers.OwnsObjects:=false;
//  FReceivers.FTransport:=GetName;
end;

destructor TBisSipTransport.Destroy;
begin
  FReceivers.Free;
  inherited Destroy;
end;

class function TBisSipTransport.GetName: String;
begin
  Result:='';
end;

function TBisSipTransport.Send(Host: String; Port: Integer; Data: String): Boolean;
begin
  Result:=false;
end;

procedure TBisSipTransport.SetActive(const Value: Boolean);
begin
end;

function TBisSipTransport.GetActive: Boolean;
begin
  Result:=false;
end;

{ TBisSipSession }

constructor TBisSipSession.Create(Registrar: TBisSipRegistrar; Direction: TBisSipSessionDirection);
begin
  inherited Create;
  FID:=GetUniqueID;
  FDirection:=Direction;
  FRequests:=TBisSipRequests.Create;
  FRegistrar:=Registrar;
  if Assigned(FRegistrar) then begin
    FRegistrar.AddReceiver(Self);
    FRegistrar.DoSessionCreate(Self);
  end;
  FSequence:=0;
end;

destructor TBisSipSession.Destroy;
begin
  if Assigned(FRegistrar) then begin
    FRegistrar.RemoveWaits(Self);
    FRegistrar.RemoveReceiver(Self);
    FRegistrar.DoSessionDestroy(Self);
  end;
  FRequests.Free;
  inherited Destroy;
end;

function TBisSipSession.NextSequence: String;
begin
  Result:='';
  if Assigned(FRegistrar) then begin
    if FRegistrar.UseGlobalSequence then
      Result:=FRegistrar.NextSequence
    else begin
      Inc(FSequence);
      Result:=IntToStr(FSequence);
    end;
  end;
end;

function TBisSipSession.ValidSequence(Sequence: String): Boolean;
var
  I1,I2: Integer;
begin
  Result:=false;
  if Assigned(FRegistrar) then begin
    I1:=StrToIntDef(Sequence,0);
    if FRegistrar.UseGlobalSequence then
      I2:=FRegistrar.FSequence
    else
      I2:=FSequence;
    Result:=I1>=I2;  
  end;
end;

procedure TBisSipSession.ResponseInviteOK(Body: String; ContentTypeKind: TBisSipContentTypeKind=ctkApplicationSdp);
var
  InviteRequest: TBisSipRequest;
  RingingResponse: TBisSipResponse;
  Response: TBisSipResponse;
  RKI: TBisSipResponseKindInfo;
begin
  if Assigned(FRegistrar) and (FState in [ssRinging,ssProgressing]) and (FDirection=sdIncoming) then begin
    RKI:=GetResponseKindInfo(rkOK);
    if Assigned(RKI) then begin
      InviteRequest:=FRequests.FindByType(rtINVITE);
      if Assigned(InviteRequest) then begin
        RingingResponse:=InviteRequest.Responses.FindByKind(rkRinging);
        if Assigned(RingingResponse) then begin
          Response:=TBisSipResponse.Create(FRegistrar.Protocol,RKI.Code,RKI.Description);
          Response.Body.Text:=Body;
          with Response.Headers do begin
            CopyFrom(RingingResponse.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
            AddContact('',FRegistrar.Scheme,FRegistrar.UserName,FRegistrar.LocalIP,FRegistrar.UriLocalPort,'','','','','',FRegistrar.UriTransportName); //???
            AddAllow([atINVITE,atACK,atCANCEL,atBYE]);
            AddContentType(ContentTypeKind);
            AddContentLength(IntToStr(Response.Body.Length));
          end;
          InviteRequest.Responses.Add(Response);
          FRegistrar.SendResponse(Response,false);
          FState:=ssConfirming;
        end;
      end;
    end;
  end;
end;

procedure TBisSipSession.ResponseInviteBusyHere;
var
  InviteRequest: TBisSipRequest;
  RingingResponse: TBisSipResponse;
  Response: TBisSipResponse;
  RKI: TBisSipResponseKindInfo;
begin
  if Assigned(FRegistrar) then begin
    if (FState in [ssRinging,ssProgressing]) and (FDirection=sdIncoming) then begin
      RKI:=GetResponseKindInfo(rkBusyHere);
      if Assigned(RKI) then begin
        InviteRequest:=FRequests.FindByType(rtINVITE);
        if Assigned(InviteRequest) then begin
          RingingResponse:=InviteRequest.Responses.FindByKind(rkRinging);
          if Assigned(RingingResponse) then begin
            Response:=TBisSipResponse.Create(FRegistrar.Protocol,RKI.Code,RKI.Description);
            with Response.Headers do begin
              CopyFrom(RingingResponse.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
              AddContentLength(IntToStr(Response.Body.Length));
            end;
            InviteRequest.Responses.Add(Response);
            FRegistrar.SendResponse(Response,false);
            FState:=ssDestroying;
          end else begin
            FState:=ssDestroying;
            FRegistrar.DoSessionTerminate(Self);
            FReadyForDestroy:=true;
          end;
        end;
      end;
    end else begin
      FState:=ssDestroying;
      FRegistrar.DoSessionTerminate(Self);
      FReadyForDestroy:=true;
    end;
  end;
end;

procedure TBisSipSession.RequestBye;
var
  AckRequest: TBisSipRequest;
  Request: TBisSipRequest;
  AFrom, ATo: TBisSipFrom;
begin
  if Assigned(FRegistrar) then begin
    if (FState=ssProcessing) and (FDirection in [sdIncoming,sdOutgoing]) then begin
      AckRequest:=FRequests.FindByType(rtACK);
      if Assigned(AckRequest) then begin
        Request:=nil;
        case FDirection of
          sdIncoming: begin
            AFrom:=TBisSipFrom(AckRequest.Headers.Find(TBisSipFrom));
            ATo:=TBisSipTo(AckRequest.Headers.Find(TBisSipTo));
            if Assigned(AFrom) and Assigned(ATo) then begin
              Request:=TBisSipRequest.Create(rdOutgoing,rtBYE,
                                             iff(AckRequest.Direction=rdIncoming,AFrom.Uri,ATo.Uri),
                                             FRegistrar.Protocol);
              with Request.Headers do begin
                AddVia(FRegistrar.Protocol,FRegistrar.TransportName,FRegistrar.LocalIP,IntToStr(FRegistrar.LocalPort),GetBranch,'','');
                if AckRequest.Direction=rdIncoming then begin
                  Add(TBisSipFrom).CopyFrom(ATo);
                  Add(TBisSipTo).CopyFrom(AFrom);
                end else begin
                  Add(TBisSipFrom).CopyFrom(AFrom);
                  Add(TBisSipTo).CopyFrom(ATo);
                end;
                AddCallID(ID);
                AddCSeq(NextSequence,Request.Name);
                AddMaxForwards(IntToStr(FRegistrar.MaxForwards));
                AddContentLength(IntToStr(Request.Body.Length))
              end;
            end;
          end;
          sdOutgoing: begin
            AFrom:=TBisSipFrom(AckRequest.Headers.Find(TBisSipFrom));
            ATo:=TBisSipTo(AckRequest.Headers.Find(TBisSipTo));
            if Assigned(AFrom) and Assigned(ATo) then begin
              Request:=TBisSipRequest.Create(rdOutgoing,rtBYE,
                                             iff(AckRequest.Direction=rdIncoming,AFrom.Uri,ATo.Uri),
                                             FRegistrar.Protocol);
              with Request.Headers do begin
                AddVia(FRegistrar.Protocol,FRegistrar.TransportName,FRegistrar.LocalIP,IntToStr(FRegistrar.LocalPort),GetBranch,'','');
                if AckRequest.Direction=rdIncoming then begin
                  Add(TBisSipFrom).CopyFrom(ATo);
                  Add(TBisSipTo).CopyFrom(AFrom);
                end else begin
                  Add(TBisSipFrom).CopyFrom(AFrom);
                  Add(TBisSipTo).CopyFrom(ATo);
                end;
                AddCallID(ID);
                AddCSeq(NextSequence,Request.Name);
                AddMaxForwards(IntToStr(FRegistrar.MaxForwards));
                AddContentLength(IntToStr(Request.Body.Length))
              end;
            end;
          end;
        end;
        if Assigned(Request) then begin
          FRequests.Add(Request);
          FRegistrar.SendRequest(Request);
{          FState:=ssDestroying;
          FRegistrar.DoSessionTerminate(Self);}
        end;
      end;
    end else begin
      FState:=ssDestroying;
      FRegistrar.DoSessionTerminate(Self);
      FReadyForDestroy:=true;
    end;
  end;
end;

procedure TBisSipSession.RequestInvite(User, Body: String; ContentTypeKind: TBisSipContentTypeKind);
var
  AckRequest: TBisSipRequest;
  Request: TBisSipRequest;
  AFrom, ATo: TBisSipFrom;
  AVia: TBisSipVia;
begin
  if Assigned(FRegistrar) and
    (((FState=ssReady) and (FDirection=sdOutgoing)) or
     ((FState=ssProcessing) and (FDirection in [sdIncoming,sdOutgoing]))) then begin
    FContentTypeKind:=ContentTypeKind;
    Request:=nil;
    case FState of
      ssReady: begin
        Request:=TBisSipRequest.Create(rdOutgoing,rtINVITE,
                                       FRegistrar.Scheme,User,FRegistrar.RemoteHost,FRegistrar.UriRemotePort,
                                       FRegistrar.Protocol,FRegistrar.UriTransportName);
        Request.Body.Text:=Body;
        with Request.Headers do begin
          AddVia(FRegistrar.Protocol,FRegistrar.TransportName,FRegistrar.LocalIP,IntToStr(FRegistrar.LocalPort),GetBranch,'','');
          AddFrom('',FRegistrar.Scheme,FRegistrar.UserName,FRegistrar.RemoteHost,FRegistrar.UriRemotePort,GetTag,'','',FRegistrar.UriTransportName); // ???
          AddTo('',FRegistrar.Scheme,User,FRegistrar.RemoteHost,FRegistrar.UriRemotePort,'','','',FRegistrar.UriTransportName); // ???
          AddCallID(ID);
          AddCSeq(NextSequence,Request.Name);
          AddAllow([atINVITE,atACK,atCANCEL,atBYE]);
          AddContact('',FRegistrar.Scheme,FRegistrar.UserName,FRegistrar.LocalIP,FRegistrar.UriLocalPort,'','','','','',FRegistrar.UriTransportName); ///???
          AddMaxForwards(IntToStr(FRegistrar.MaxForwards));
          AddContentType(ContentTypeKind);
          AddContentLength(IntToStr(Request.Body.Length));
        end;
      end;
      ssProcessing: begin
        case FDirection of
          sdIncoming: begin
            AckRequest:=FRequests.FindByType(rtACK);
            if Assigned(AckRequest) then begin
              AFrom:=TBisSipFrom(AckRequest.Headers.Find(TBisSipFrom));
              ATo:=TBisSipTo(AckRequest.Headers.Find(TBisSipTo));
              if Assigned(AckRequest) and Assigned(AFrom) and Assigned(ATo) then begin
                Request:=TBisSipRequest.Create(rdOutgoing,rtINVITE,
                                               iff(AckRequest.Direction=rdIncoming,AFrom.Uri,ATo.Uri),
                                               FRegistrar.Protocol);
                Request.Body.Text:=Body;
                with Request.Headers do begin
                  AddVia(FRegistrar.Protocol,FRegistrar.TransportName,FRegistrar.LocalIP,IntToStr(FRegistrar.LocalPort),GetBranch,'','');
                  if AckRequest.Direction=rdIncoming then begin
                    Add(TBisSipFrom).CopyFrom(ATo);
                    Add(TBisSipTo).CopyFrom(AFrom);
                  end else begin
                    Add(TBisSipFrom).CopyFrom(AFrom);
                    Add(TBisSipTo).CopyFrom(ATo);
                  end;
                  AddCallID(ID);
                  AVia:=TBisSipVia(Find(TBisSipVia));
                  if Assigned(AVia) then
                    AVia.FBranch:=GetBranch;
                  AddCSeq(NextSequence,Request.Name);
                  AddAllow([atINVITE,atACK,atCANCEL,atBYE]);
                  AddContact('',FRegistrar.Scheme,FRegistrar.UserName,FRegistrar.LocalIP,FRegistrar.UriLocalPort,'','','','','',FRegistrar.UriTransportName); //???
                  AddMaxForwards(IntToStr(FRegistrar.MaxForwards));
                  AddContentType(ContentTypeKind);
                  AddContentLength(IntToStr(Request.Body.Length));
                end;
              end;
            end;
          end;
          sdOutgoing: begin
            AckRequest:=FRequests.FindByType(rtACK);
            if Assigned(AckRequest) then begin
              Request:=TBisSipRequest.Create(rdOutgoing,rtINVITE,AckRequest.Uri,FRegistrar.Protocol);
              Request.Body.Text:=Body;
              with Request.Headers do begin
                CopyFrom(AckRequest.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID]);
                AVia:=TBisSipVia(Find(TBisSipVia));
                if Assigned(AVia) then
                  AVia.FBranch:=GetBranch;
                AddCSeq(NextSequence,Request.Name);
                AddAllow([atINVITE,atACK,atCANCEL,atBYE]);
                AddContact('',FRegistrar.Scheme,FRegistrar.UserName,FRegistrar.LocalIP,FRegistrar.UriLocalPort,'','','','','',FRegistrar.UriTransportName); //???
                AddMaxForwards(IntToStr(FRegistrar.MaxForwards));
                AddContentType(ContentTypeKind);
                AddContentLength(IntToStr(Request.Body.Length));
              end;
            end;
          end;
        end;
      end;
    end;
    if Assigned(Request) then begin
      FRequests.Add(Request);
      FRegistrar.SendRequest(Request);
      FState:=ssWaiting;
    end;
  end;
end;

procedure TBisSipSession.RequestCancel;
var
  InviteRequest: TBisSipRequest;
  RingingResponse: TBisSipResponse;
  Request: TBisSipRequest;
  CSeq: TBisSipCSeq;
begin
  if Assigned(FRegistrar) then begin
    if (FState in [ssWaiting,ssRinging,ssProgressing]) and (FDirection=sdOutgoing) then begin
      InviteRequest:=FRequests.FindByType(rtINVITE);
      if Assigned(InviteRequest) then begin
        if Assigned(InviteRequest) then begin
          RingingResponse:=InviteRequest.Responses.FindByKind(rkRinging);
          if Assigned(RingingResponse) then begin
            Request:=TBisSipRequest.Create(rdOutgoing,rtCANCEL,InviteRequest.Uri,FRegistrar.Protocol);
            with Request.Headers do begin
              CopyFrom(RingingResponse.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
              CSeq:=TBisSipCSeq(Find(TBisSipCSeq));
              if Assigned(CSeq) then
                CSeq.RequestName:=Request.Name;
              AddMaxForwards(IntToStr(FRegistrar.MaxForwards));
              AddContentLength(IntToStr(Request.Body.Length))
            end;
            FState:=ssBreaking;
          end else begin
            Request:=TBisSipRequest.Create(rdOutgoing,rtCANCEL,InviteRequest.Uri,FRegistrar.Protocol);
            with Request.Headers do begin
              CopyFrom(InviteRequest.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
              CSeq:=TBisSipCSeq(Find(TBisSipCSeq));
              if Assigned(CSeq) then
                CSeq.RequestName:=Request.Name;
              AddMaxForwards(IntToStr(FRegistrar.MaxForwards));
              AddContentLength(IntToStr(Request.Body.Length))
            end;
            FState:=ssBreaking;
          end;
          FRequests.Add(Request);
          FRegistrar.SendRequest(Request);
        end;
      end;
    end else begin
      FState:=ssDestroying;
      FRegistrar.DoSessionTerminate(Self);
      FReadyForDestroy:=true;
    end;
  end;
end;

function TBisSipSession.Accept(Message: TBisSipMessage): Boolean;
begin
  Result:=true;
  if Assigned(FRegistrar) then
    Result:=FRegistrar.DoSessionAccept(Self,Message);
end;

function TBisSipSession.ReceiveRequest(Request: TBisSipRequest): Boolean;

  procedure ResponseForbidden;
  var
    Response: TBisSipResponse;
    RKI: TBisSipResponseKindInfo;
  begin
    RKI:=GetResponseKindInfo(rkForbidden);
    if Assigned(RKI) then begin
      Response:=TBisSipResponse.Create(FRegistrar.Protocol,RKI.Code,RKI.Description);
      with Response.Headers do begin
        CopyFrom(Request.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq,TBisSipContact,TBisSipExpires]);
        AddContentLength(IntToStr(Response.Body.Length));
      end;
      Request.Responses.Add(Response);
      FRegistrar.SendResponse(Response,false);
    end;
  end;

  procedure ResponseNotAcceptableClient;
  var
    Response: TBisSipResponse;
    RKI: TBisSipResponseKindInfo;
  begin
    RKI:=GetResponseKindInfo(rkNotAcceptableClient);
    if Assigned(RKI) then begin
      Response:=TBisSipResponse.Create(FRegistrar.Protocol,RKI.Code,RKI.Description);
      with Response.Headers do begin
        CopyFrom(Request.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq,TBisSipContact,TBisSipExpires]);
        AddContentLength(IntToStr(Response.Body.Length));
      end;
      Request.Responses.Add(Response);
      FRegistrar.SendResponse(Response,false);
    end;
  end;

  function ResponseTrying: TBisSipResponse;
  var
    Response: TBisSipResponse;
    RKI: TBisSipResponseKindInfo;
    ATo: TBisSipTo;
  begin
    Result:=nil;
    RKI:=GetResponseKindInfo(rkTrying);
    if Assigned(RKI) then begin
      Response:=TBisSipResponse.Create(FRegistrar.Protocol,RKI.Code,RKI.Description);
      with Response.Headers do begin
        CopyFrom(Request.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
        ATo:=TBisSipTo(Find(TBisSipTo));
        if Assigned(ATo) then
          ATo.FTag:=GetTag;
        AddContentLength(IntToStr(Response.Body.Length));
      end;
      Result:=Response;
      Request.Responses.Add(Response);
      FRegistrar.SendResponse(Response,false);
    end;
  end;

  procedure ResponseSessionProgress;
  begin
  end;

  procedure ResponseRinging(TryingResponse: TBisSipResponse);
  var
    Response: TBisSipResponse;
    RKI: TBisSipResponseKindInfo;
  begin
    if Assigned(TryingResponse) then begin
      RKI:=GetResponseKindInfo(rkRinging);
      if Assigned(RKI) then begin
        Response:=TBisSipResponse.Create(FRegistrar.Protocol,RKI.Code,RKI.Description);
        with Response.Headers do begin
          CopyFrom(Request.Headers,[TBisSipVia,TBisSipFrom,TBisSipCallID,TBisSipCSeq]);
          CopyFrom(TryingResponse.Headers,[TBisSipTo]);
          AddContentLength(IntToStr(Response.Body.Length));
        end;
        Request.Responses.Add(Response);
        FRegistrar.SendResponse(Response,false);
      end;
    end;
  end;

  procedure ResponseOK;
  var
    Response: TBisSipResponse;
    RKI: TBisSipResponseKindInfo;
  begin
    RKI:=GetResponseKindInfo(rkOK);
    if Assigned(RKI) then begin
      Response:=TBisSipResponse.Create(FRegistrar.Protocol,RKI.Code,RKI.Description);
      with Response.Headers do begin
        CopyFrom(Request.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
        AddContentLength(IntToStr(Response.Body.Length));
      end;
      Request.Responses.Add(Response);
      FRegistrar.SendResponse(Response,false);
    end;
  end;

  procedure ResponseRequestTerminated;
  var
    Response: TBisSipResponse;
    RKI: TBisSipResponseKindInfo;
    CSeq: TBisSipCSeq;
  begin
    RKI:=GetResponseKindInfo(rkRequestTerminated);
    if Assigned(RKI) then begin
      Response:=TBisSipResponse.Create(FRegistrar.Protocol,RKI.Code,RKI.Description);
      with Response.Headers do begin
        CopyFrom(Request.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
        AddContentLength(IntToStr(Response.Body.Length));
      end;
      CSeq:=TBisSipCSeq(Response.Headers.Find(TBisSipCSeq));
      if Assigned(CSeq) then
        CSeq.FRequestName:=TBisSipRequest.RequestTypeToName(rtINVITE);
      Request.Responses.Add(Response);
      FRegistrar.SendResponse(Response,false);
    end;
  end;

  procedure ProcessInvite;
  var
    ContentType: TBisSipContentType;
    TryingResponse: TBisSipResponse;
  begin
    if FState=ssReady then begin
      ContentType:=TBisSipContentType(Request.Headers.Find(TBisSipContentType));
      if Assigned(ContentType) then begin
        FContentTypeKind:=ContentType.Kind;
        if Accept(Request) then begin
          TryingResponse:=ResponseTrying;
          ResponseSessionProgress;
          ResponseRinging(TryingResponse);
          FState:=ssRinging;
          FRegistrar.DoSessionRing(Self);
        end else begin
          ResponseNotAcceptableClient;
          FState:=ssDestroying;
        end;
      end;
    end else begin
      FRegistrar.DoSessionContent(Self,Request.Body.Text);
      ResponseOK;
      FState:=ssConfirming;
    end;
  end;

  procedure ProcessAck;
  begin
    FState:=ssProcessing;
    FRegistrar.DoSessionConfirm(Self);
  end;

  procedure ProcessBye;
  begin
    ResponseOK;
    FState:=ssDestroying;
    FRegistrar.DoSessionTerminate(Self);
    FReadyForDestroy:=true;
  end;

  procedure ProcessCancel;
  begin
    ResponseOK;
    ResponseRequestTerminated;
    FState:=ssDestroying;
    FRegistrar.DoSessionTerminate(Self);
  end;

  procedure Unsupported;
  begin
    ResponseForbidden;
    FState:=ssDestroying;
    FRegistrar.DoSessionTerminate(Self);
    FReadyForDestroy:=true;
  end;

var
  Flag: Boolean;
begin
  Result:=inherited ReceiveRequest(Request);
  if Assigned(FRegistrar) and Assigned(Request) and
     (FDirection in [sdIncoming,sdOutgoing]) then begin

    FRegistrar.FWaits.LockRemoveBy(Request);
    FRequests.Add(Request);
    Result:=true;
    Flag:=true;

    case Request.RequestType of
      rtUNKNOWN,rtREGISTER: ;
      rtINVITE: begin
        if FState in [ssReady,ssProcessing] then begin
          ProcessInvite;
          Flag:=true;
        end;
      end;
      rtACK: begin
        if FState in [ssConfirming,ssBreaking] then begin
          ProcessAck;
          Flag:=true;
        end;
      end;
      rtBYE: begin
        if FState in [ssProcessing,ssWaiting] then begin
          ProcessBye;
          Flag:=true;
        end;
      end;
      rtCANCEL: begin
        if FState in [ssRinging,ssProgressing] then begin
          ProcessCancel;
          Flag:=true;
        end;
      end;
    end;

    if not Flag then
      Unsupported;

  end;
end;

function TBisSipSession.ReceiveResponse(Response: TBisSipResponse): Boolean;

  procedure RequestAck(Request: TBisSipRequest; NewBranch: Boolean=true);
  var
    AckRequest: TBisSipRequest;
    CSeq: TBisSipCSeq;
    Via: TBisSipVia;
  begin
    AckRequest:=TBisSipRequest.Create(rdOutgoing,rtACK,Request.Uri,FRegistrar.Protocol);
    with AckRequest.Headers do begin
      if (Request.Direction=rdIncoming) then begin
        CopyFrom(Response.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
      end else begin
        if FState=ssBreaking then begin
          CopyFrom(Response.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
        end else begin
          if NewBranch then begin
            AddVia(FRegistrar.Protocol,FRegistrar.TransportName,FRegistrar.LocalIP,IntToStr(FRegistrar.LocalPort),GetBranch,'','');
            CopyFrom(Response.Headers,[TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
          end else begin
            CopyFrom(Response.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
            Via:=TBisSipVia(Find(TBisSipVia));
            if Assigned(Via) then
              Via.FRport:='';
          end;
        end;
      end;
      CSeq:=TBisSipCSeq(Find(TBisSipCSeq));
      if Assigned(CSeq) then
        CSeq.RequestName:=AckRequest.Name;
      AddMaxForwards(IntToStr(FRegistrar.FMaxForwards));  
      AddContentLength(IntToStr(AckRequest.Body.Length))
    end;
    FRequests.Add(AckRequest);
    FRegistrar.SendRequest(AckRequest,false);
  end;

  procedure ProcessBadRequest(Request: TBisSipRequest);
  begin
    // need something in response
    FState:=ssDestroying;
    FRegistrar.DoSessionTerminate(Self);
  end;

  procedure ProcessTrying(Request: TBisSipRequest);
  begin
    FState:=ssTrying;
    FRegistrar.DoSessionContent(Self,Response.Body.Text);
  end;

  procedure ProcessSessionProgress(Request: TBisSipRequest);
  begin
    FState:=ssProgressing;
    FRegistrar.DoSessionProgress(Self);
    FRegistrar.DoSessionContent(Self,Response.Body.Text);
  end;

  procedure ProcessRinging(Request: TBisSipRequest);
  begin
    FState:=ssRinging;
    FRegistrar.DoSessionRing(Self);
    FRegistrar.DoSessionContent(Self,Response.Body.Text);
  end;

  procedure ProcessOK(Request: TBisSipRequest);
  begin
    if FState=ssProcessing then begin
      FState:=ssDestroying;
      FRegistrar.DoSessionTerminate(Self);
      FReadyForDestroy:=true;
    end else begin
      if Accept(Response) then begin
        RequestAck(Request);
        FState:=ssProcessing;
        FRegistrar.DoSessionConfirm(Self);
      end else begin
        RequestAck(Request);
        FState:=ssProcessing;
        RequestBye;
      end;
    end;
  end;

  procedure ProcessRequestTerminated(Request: TBisSipRequest);
  begin
    RequestAck(Request);
    FState:=ssDestroying;
    FRegistrar.DoSessionTerminate(Self);
    FReadyForDestroy:=true;
  end;

  procedure RequestWithProxyAuthorization(Request: TBisSipRequest);
  var
    Authenticate: TBisSipProxyAuthenticate;
    Authorization: TBisSipProxyAuthorization;
    NewRequest: TBisSipRequest;
  begin
    Authenticate:=TBisSipProxyAuthenticate(Response.Headers.Find(TBisSipProxyAuthenticate));
    if Assigned(Authenticate) then begin

      NewRequest:=TBisSipRequest.Create(rdOutgoing,Request.RequestType,Request);
      NewRequest.CSeqNum:=NextSequence;

      Authorization:=TBisSipProxyAuthorization(NewRequest.Headers.Find(TBisSipProxyAuthorization));
      if not Assigned(Authorization) then
        Authorization:=NewRequest.Headers.AddProxyAuthorization(FRegistrar.FUserName,FRegistrar.FPassword,Request.Name,Request.Uri);

      if Assigned(Authorization) then
        Authorization.CopyFrom(Authenticate);

      FRequests.Add(NewRequest);
      FRegistrar.SendRequest(NewRequest);
    end;
  end;

  procedure ProcessProxyAuthenticationRequired(Request: TBisSipRequest);
  begin
    RequestAck(Request,false);
    RequestWithProxyAuthorization(Request);
    FState:=ssWaiting;
  end;

var
  Request: TBisSipRequest;
begin
  Result:=inherited ReceiveResponse(Response);
  if Assigned(FRegistrar) and Assigned(Response) then begin
    Request:=FRequests.GetRequest(Response);
    if Assigned(Request) then begin
      FRegistrar.FWaits.LockRemoveBy(Request);
      Result:=ValidSequence(Response.CSeqNum);
      if Result then begin
        Request.Responses.Add(Response);
        case Response.ResponseKind of
          rkTrying: begin
            if FState=ssWaiting then
              ProcessTrying(Request);
          end;
          rkSessionProgress: begin
            if FState in [ssWaiting,ssTrying] then
              ProcessSessionProgress(Request);
          end;
          rkRinging: begin
            if FState in [ssWaiting,ssTrying,ssProgressing] then
              ProcessRinging(Request);
          end;
          rkOK: begin
            if FState in [ssRinging,ssWaiting,ssTrying,ssProcessing,ssProgressing] then
              ProcessOK(Request);
          end;
          rkRequestTerminated: begin
            if FState=ssBreaking then
              ProcessRequestTerminated(Request);
          end;
          rkBadRequest: begin
            if FState=ssWaiting then
              ProcessBadRequest(Request);
          end;
          rkForbidden: begin
    //        FRegistrar.FirstRegister(Request);
          end;
          rkProxyAuthenticationRequired: begin
            if FState=ssTrying then
              ProcessProxyAuthenticationRequired(Request);
          end;
        end;
      end;
    end;
  end;
end;

{ TBisSipSessions }

constructor TBisSipSessions.Create(Registrar: TBisSipRegistrar);
begin
  inherited Create;
  FRegistrar:=Registrar;
end;

function TBisSipSessions.FindByID(ID: String): TBisSipSession;
begin
  Result:=TBisSipSession(inherited FindByID(ID));
end;

function TBisSipSessions.FindByMessage(Message: TBisSipMessage): TBisSipSession;
var
  CallID: TBisSipCallID;
begin
  Result:=nil;
  if Assigned(Message) then begin
    CallID:=TBisSipCallID(Message.Headers.Find(TBisSipCallID));
    if Assigned(CallID) then
      Result:=FindByID(CallID.Value);
  end;
end;

function TBisSipSessions.GetSession(Index: Integer): TBisSipSession;
begin
  Result:=TBisSipSession(inherited Items[Index]);
end;

function TBisSipSessions.Add(ID: String; Direction: TBisSipSessionDirection): TBisSipSession;
begin
  Result:=FindByID(ID);
  if not Assigned(Result) then begin
    Result:=TBisSipSession.Create(FRegistrar,Direction);
    Result.FID:=ID;
    inherited Add(Result);
  end;
end;

function TBisSipSessions.Add(Direction: TBisSipSessionDirection): TBisSipSession;
begin
  Result:=Add(GetUniqueID,Direction);
end;

{ TBisSipMessageWaitThread }

constructor TBisSipMessageWaitThread.Create(const TimeOut: Cardinal; Message: TBisSipMessage);
begin
  inherited Create(TimeOut);
  FMessage:=Message;
end;

procedure TBisSipMessageWaitThread.CleanUp;
begin
  inherited CleanUp;
  FMessage:=nil;
end;


{ TBisSipMessageWaitThreads }

function TBisSipMessageWaitThreads.GetItem(Index: Integer): TBisSipMessageWaitThread;
begin
  Result:=TBisSipMessageWaitThread(inherited Items[Index]);
end;

function TBisSipMessageWaitThreads.LockAdd(Message: TBisSipMessage): TBisSipMessageWaitThread;
begin
  Lock;
  try
    Result:=TBisSipMessageWaitThread.Create(FTimeOut,Message);
    Result.FreeOnTerminate:=true;
    Result.OnTimeout:=FOnTimeOut;
    Result.OnDestroy:=ItemDestroy;
    Result.Threaded:=false;
    inherited Add(Result);
  finally
    UnLock;
  end;
end;

procedure TBisSipMessageWaitThreads.DoItemFree(Item: TObject);
var
  Thread: TBisSipMessageWaitThread;
begin
  Thread:=TBisSipMessageWaitThread(Item);
  Thread.CleanUp;
  Thread.FreeOnTerminate:=not Destroying;
  Thread.Terminate;
end;

procedure TBisSipMessageWaitThreads.ItemDestroy(Thread: TBisThread);
begin
  Lock;
  OwnsObjects:=false;
  try
    Remove(Thread);
  finally
    OwnsObjects:=true;
    UnLock;
  end;
end;

procedure TBisSipMessageWaitThreads.LockRemoveBy(Message: TBisSipMessage);
var
  i: Integer;
  Item: TBisSipMessageWaitThread;
begin
  Lock;
  OwnsObjects:=false;
  try
    for i:=Count-1 downto 0 do begin
      Item:=TBisSipMessageWaitThread(Items[i]);
      if Item.FMessage=Message then
        Remove(Item);
    end;
  finally
    OwnsObjects:=true;
    UnLock;
  end;
end;

{ TBisSipClient }

constructor TBisSipClient.Create;
begin
  inherited Create;
  FScheme:=DefaultScheme;
  FProtocol:=DefaultProtocol;

  FWaits:=TBisSipMessageWaitThreads.Create;
  FWaits.FOnTimeOut:=WaitsTimeOut;
  FWaits.FTimeOut:=3000;

//  FTimers:=TBisSipTimerThreads.Create;}

  FRequests:=TBisSipRequests.Create;

  FSessions:=TBisSipSessions.Create(Self);

  FLastRequest:=nil;

  FExpires:=3600;
  FQ:='0.9';
  FMaxForwards:=70;
  FSequence:=0;
  FKeepAlive:=30000;
  FKeepAliveQuery:=#13#10#13#10;
  FWaitRetryCount:=5;
  FSessionIdleTimeOut:=60000;
//FSessionAlive:=1000;
  FSessionAlive:=0;
  FUseGlobalSequence:=false;

  FSExpiresTimer:='SipExpiresTimer';
  FSAliveTimer:='SipAliveTimer';

end;

destructor TBisSipClient.Destroy;
begin
  RemoveReceiver(Self);
  if Assigned(FLastRequest) then begin
    FLastRequest.Free;
    FLastRequest:=nil;
  end;
  FSessions.Free;
  FRequests.Free;
//  FTimers.Free;
  FWaits.Free;
  inherited Destroy;
end;

procedure TBisSipClient.AddReceiver(Receiver: TBisSipReceiver);
begin
  if Assigned(FTransport) then
    FTransport.Receivers.Add(Receiver);
end;

procedure TBisSipClient.RemoveReceiver(Receiver: TBisSipReceiver);
begin
  if Assigned(FTransport) then
    FTransport.Receivers.Remove(Receiver);
end;

procedure TBisSipClient.RemoveWaits(Session: TBisSipSession);
var
  i,x: Integer;
  Request: TBisSipRequest;
  Response: TBisSipResponse;
begin
  if Assigned(Session) then begin
    for i:=Session.FRequests.Count-1 downto 0 do begin
      Request:=Session.FRequests.Items[i];
      for x:=Request.FResponses.Count-1 downto 0 do begin
        Response:=Request.FResponses.Items[x];
        FWaits.LockRemoveBy(Response);
      end;
      FWaits.LockRemoveBy(Request);
    end;
  end;
end;

function TBisSipClient.GetUri: String;
begin
  Result:=Format('%s%s%s%s%s',[iff(FScheme<>'',FScheme+':',''),
                               iff(FUserName<>'',FUserName+'@',''),
                               iff(FLocalIP<>'',FLocalIP,''),
                               iff(FUsePortInUri and (FLocalPort<>0),':'+IntToStr(FLocalPort),''),
                               iff(FUseTrasnportNameInUri and (TransportName<>''),';transport='+TransportName,'')]);
  Result:=Trim(Result);
end;

function TBisSipClient.GetWaitTimeOut: Cardinal;
begin
  Result:=FWaits.FTimeOut;
end;

function TBisSipClient.CheckUri(Uri: String): Boolean;
var
  S1,S2,S3,S4,S5: String;
begin
  Result:=false;
  if Uri<>'' then begin
    if ParseUri(Uri,S1,S2,S3,S4,S5) then begin
      Result:=AnsiSameText(FScheme,S1);
      if Result and (S2<>'') then begin
        Result:=AnsiSameText(FUserName,S2);
        if Result and (S3<>'') then
          Result:=AnsiSameText(FLocalIP,S3) or AnsiSameText(FReceived,S3);
      end;
    end;
  end;
end;

function TBisSipClient.DoSessionAccept(Session: TBisSipSession; Message: TBisSipMessage): Boolean;
begin
  Result:=true;
  if Assigned(FOnSessionAccept) then
    Result:=FOnSessionAccept(Self,Session,Message);
end;

function TBisSipClient.DoSessionAlive(Session: TBisSipSession): Boolean;
begin
  Result:=false;
  if Assigned(FOnSessionAlive) then
    Result:=FOnSessionAlive(Self,Session);
end;

procedure TBisSipClient.DoSessionCreate(Session: TBisSipSession);
begin
  if Assigned(FOnSessionCreate) then
    FOnSessionCreate(Self,Session);
end;

procedure TBisSipClient.DoSessionDestroy(Session: TBisSipSession);
begin
  if Assigned(FOnSessionDestroy) then
    FOnSessionDestroy(Self,Session);
end;

procedure TBisSipClient.DoSessionContent(Session: TBisSipSession; Content: String);
begin
  if Assigned(FOnSessionContent) then
    FOnSessionContent(Self,Session,Content);
end;

procedure TBisSipClient.DoSessionProgress(Session: TBisSipSession);
begin
  if Assigned(FOnSessionProgress) then
    FOnSessionProgress(Self,Session);
end;

procedure TBisSipClient.DoSessionRing(Session: TBisSipSession);
begin
  if Assigned(FOnSessionRing) then
    FOnSessionRing(Self,Session);
end;

procedure TBisSipClient.DoSessionTerminate(Session: TBisSipSession);
begin
  if Assigned(FOnSessionTerminate) then
    FOnSessionTerminate(Self,Session);
end;

procedure TBisSipClient.DoSessionTimeout(Session: TBisSipSession; var TryRegister: Boolean);
begin
  if Assigned(FOnSessionTimeout) then
    FOnSessionTimeout(Self,Session,TryRegister);
end;

procedure TBisSipClient.DoSessionConfirm(Session: TBisSipSession);
begin
  if Assigned(FOnSessionConfirm) then
    FOnSessionConfirm(Self,Session);
end;

procedure TBisSipClient.DoRegister;
begin
  if Assigned(FOnRegister) then
    FOnRegister(Self);
end;

procedure TBisSipClient.DoMessageTimeOut(Message: TBisSipMessage; var TryRegister: Boolean);
begin
  if Assigned(FOnMessageTimeout) then
    FOnMessageTimeout(Self,Message,TryRegister);  
end;

function TBisSipClient.GetTransportName: String;
begin
  Result:='';
  if Assigned(FTransport) then
    Result:=FTransport.Name;
end;

function TBisSipClient.NextSequence: String;
begin
  Inc(FSequence);
  Result:=IntToStr(FSequence);
end;

procedure TBisSipClient.SetTransport(const Value: TBisSipTransport);
begin
  RemoveReceiver(Self);
  FTransport:=Value;
  RemoveReceiver(Self);
  AddReceiver(Self);
end;

procedure TBisSipClient.SetWaitTimeOut(const Value: Cardinal);
begin

end;

function TBisSipClient.UriLocalPort: String;
begin
  Result:='';
  if FUsePortInUri then
    Result:=IntToStr(FLocalPort);
end;

function TBisSipClient.UriRemotePort: String;
begin
  Result:='';
  if FUsePortInUri then
    Result:=IntToStr(FRemotePort);
end;

function TBisSipClient.UriTransportName: String;
begin
  Result:='';
  if FUseTrasnportNameInUri then
    Result:=GetTransportName;
end;

procedure TBisSipClient.WaitsTimeOut(Thread: TBisWaitThread);
var
  Wait: TBisSipMessageWaitThread;
  Session: TBisSipSession;
  TryRegister: Boolean;
begin
  if Assigned(Thread) and (Thread is TBisSipMessageWaitThread) then begin
    Wait:=TBisSipMessageWaitThread(Thread);
    if Assigned(Wait.FMessage) and Assigned(FTransport) then begin
      if Wait.Counter<FWaitRetryCount then begin
        if FTransport.Send(FRemoteIP,FRemotePort,Wait.FMessage.AsString) then
          Wait.Reset;
      end else begin
        TryRegister:=true;
        Session:=FSessions.FindByMessage(Wait.FMessage);
        if Assigned(Session) then
          DoSessionTimeout(Session,TryRegister)
        else
          DoMessageTimeOut(Wait.FMessage,TryRegister);
        if TryRegister then begin
          if Wait.FMessage is TBisSipRequest then
            FirstRegister(TBisSipRequest(Wait.FMessage))
          else
            FirstRegister(nil);
        end; 
      end;
    end;
  end;
end;

procedure TBisSipClient.SendRequest(Request: TBisSipRequest; WithWait: Boolean=true);
begin
  if Assigned(Request) then begin
    if Assigned(FTransport) then begin
      if FTransport.Send(FRemoteIP,FRemotePort,Request.AsString) and (FWaitRetryCount>0) and WithWait then
        FWaits.LockAdd(Request).Start;
    end;
  end;
end;

procedure TBisSipClient.SendResponse(Response: TBisSipResponse; WithWait: Boolean=false);
begin
  if Assigned(Response) then begin
    if Assigned(FTransport) then begin
      if FTransport.Send(FRemoteIP,FRemotePort,Response.AsString) and (FWaitRetryCount>0) and WithWait then
        FWaits.LockAdd(Response).Start;
    end;
  end;
end;

function TBisSipClient.ReceiveRequest(Request: TBisSipRequest): Boolean;
begin
  Result:=inherited ReceiveRequest(Request);
end;

function TBisSipClient.ReceiveResponse(Response: TBisSipResponse): Boolean;

  procedure ProcessUnauthorized(Request: TBisSipRequest);
  var
    ResponseVia: TBisSipVia;
    Via: TBisSipVia;
    Contact: TBisSipContact;
    NewRequest: TBisSipRequest;
    Authorization: TBisSipAuthorization;
    WWWAuthenticate: TBisSipWWWAuthenticate;
  begin
    Contact:=TBisSipContact(Request.Headers.Find(TBisSipContact));
    if Assigned(Contact) and not Contact.Empty then begin

      ResponseVia:=TBisSipVia(Response.Headers.Find(TBisSipVia));
      if Assigned(ResponseVia) then begin
        FReceived:=ResponseVia.FReceived;
        if FUseReceived and (Trim(FReceived)<>'') then begin
          Contact.FHost:=FReceived;
          FLocalIP:=FReceived;
        end;
        if FUseRport and (Trim(ResponseVia.FRport)<>'') then begin
          FLocalPort:=StrToIntDef(ResponseVia.FRport,FLocalPort);
        end;
      end;

      NewRequest:=TBisSipRequest.Create(rdOutgoing,Request.RequestType,Request);
      NewRequest.CSeqNum:=NextSequence;

      Via:=TBisSipVia(NewRequest.Headers.Find(TBisSipVia));
      if Assigned(Via) then
        Via.FHost:=FLocalIP;

      Authorization:=TBisSipAuthorization(NewRequest.Headers.Find(TBisSipAuthorization));
      if not Assigned(Authorization) then
        Authorization:=NewRequest.Headers.AddAuthorization(FUserName,FPassword,Request.Name,Request.Uri);

      if Assigned(Authorization) then begin
        WWWAuthenticate:=TBisSipWWWAuthenticate(Response.Headers.Find(TBisSipWWWAuthenticate));
        if Assigned(WWWAuthenticate) then
          Authorization.CopyFrom(WWWAuthenticate)
        else begin
          // find Proxy Authenticate
        end;
      end;

      FRequests.Add(NewRequest);
      SendRequest(NewRequest);
    end;
  end;

  procedure SendLastRequest;
  var
    NewRequest: TBisSipRequest;
  begin
    if Assigned(FLastRequest) then begin

      NewRequest:=TBisSipRequest.Create(rdOutgoing,FLastRequest.RequestType,FLastRequest);
      NewRequest.CSeqNum:=NextSequence;

      FRequests.Add(NewRequest);
      SendRequest(FLastRequest);
    end;
  end;
  
var
  Request: TBisSipRequest;
begin
  Result:=inherited ReceiveResponse(Response);
  if Assigned(Response) then begin
    Request:=FRequests.GetRequest(Response);
    if Assigned(Request) and (Request.RequestType=rtREGISTER) then begin
      FWaits.LockRemoveBy(Request);
      Result:=StrToIntDef(Response.CSeqNum,0)>=FSequence;
      if Result then begin
        Request.Responses.Add(Response);
        case Response.ResponseKind of
          rkUnauthorized: begin
            if FRegistered then begin
              FRegistered:=false;
              DoRegister;
//              FTimers.RemoveBy(KeepAliveTimer);
            end;
            ProcessUnauthorized(Request);
          end;
          rkOK: begin
            if not FRegistered then begin
              FRegistered:=true;
              DoRegister;
              SendLastRequest;
//              FTimers.RemoveBy(KeepAliveTimer);
//              FTimers.AddMilliSeconds(FSAliveTimer,FKeepAlive,KeepAliveTimer);
            end;
          end;
          rkForbidden: begin
           // Register(true);
          end;
        end;
      end;
    end;
  end;
end;

procedure TBisSipClient.FirstRegister(Request: TBisSipRequest=nil);
begin
  if Assigned(FLastRequest) then begin
    FLastRequest.Free;
    FLastRequest:=nil;
  end;
  if Assigned(Request) and (Request.RequestType<>rtREGISTER) and (Request.Direction=rdOutgoing) then begin
    FLastRequest:=TBisSipRequest.Create(rdOutgoing,Request.RequestType,Request);
  end;
  FRegistered:=false;
  DoRegister;
  Register(true);
end;

{procedure TBisSipClient.RegisterTimer(Sender: TBisSipTimerThread);
begin
  FirstRegister;
end;}

{procedure TBisSipClient.KeepAliveTimer(Sender: TBisSipTimerThread);
begin
  if FRegistered then begin
    if Assigned(FTransport) then begin
      if not FTransport.Send(FRemoteIP,FRemotePort,FKeepAliveQuery) then begin
//        FTimers.Remove(Sender);
        FirstRegister;
      end;
    end;
  end;
end;}

{procedure TBisSipClient.SessionTimer(Sender: TBisSipTimerThread);
var
  i: Integer;
  Item: TBisSipSession;
begin
  for i:=FSessions.Count-1 downto 0 do begin
    Item:=FSessions.Items[i];
    if Item.FIdleTimeOut>=FSessionIdleTimeOut then begin
      if not DoSessionAlive(Item) then begin
        if FRegistered then begin
          case Item.FState of
            ssReady: ;
            ssWaiting,ssConfirming: Item.RequestCancel;
            ssRinging,ssProgressing: begin
              case Item.Direction of
                sdIncoming: Item.ResponseInviteBusyHere;
                sdOutgoing: Item.RequestCancel;
              end;
            end;
            ssProcessing: Item.RequestBye;
            ssBreaking: begin
              Item.FState:=ssDestroying;
              DoSessionTerminate(Item);
              Item.FReadyForDestroy:=true;
            end;
            ssDestroying: Item.FReadyForDestroy:=true;
          end;
          if Item.FReadyForDestroy then
            FSessions.Remove(Item);
        end else begin
          Item.FState:=ssDestroying;
          DoSessionTerminate(Item);
          FSessions.Remove(Item);
        end;
      end else
        Item.FIdleTimeOut:=0;
    end;
    Inc(Item.FIdleTimeOut,FSessionAlive);
  end;
end;}

procedure TBisSipClient.Register(Active: Boolean; Initial: Boolean=false);
var
  Request: TBisSipRequest;
begin
  if Initial then begin
    FSequence:=0;
  end;
//  FTimers.RemoveBy(RegisterTimer);
  if Assigned(FTransport) then begin
    Request:=TBisSipRequest.Create(rdOutgoing,TBisSipRequest.RequestTypeToName(rtREGISTER),
                                   FScheme,'',FRemoteHost,'',FProtocol,UriTransportName);
    if Active then begin
//      FTimers.AddSeconds(FSExpiresTimer,FExpires,RegisterTimer);
      with Request do begin
        with Headers do begin
          AddVia(FProtocol,Self.FTransport.Name,FLocalIP,IntToStr(FLocalPort),GetBranch,'','');
          AddFrom('',FScheme,FUserName,FRemoteHost,UriRemotePort,GetTag,'','',UriTransportName); //???
          AddTo('',FScheme,FUserName,FRemoteHost,UriRemotePort,'','','',UriTransportName);//???
          AddCallID(FID);
          AddCSeq(NextSequence,Request.Name);
          AddContact('',FScheme,FUserName,FLocalIP,UriLocalPort,'',IntToStr(FExpires),FQ,'','',UriTransportName); //???
          AddUserAgent(FUserAgent);
          AddAllow([atINVITE,atACK,atBYE,atCANCEL]);
          AddMaxForwards(IntToStr(FMaxForwards));
          AddExpires(IntToStr(FExpires));
          AddContentLength(IntToStr(Body.Length));
        end;
      end;
    end else begin
      with Request do begin
        with Headers do begin
          AddVia(FProtocol,Self.FTransport.Name,FLocalIP,IntToStr(FLocalPort),GetBranch,'','');
          AddFrom('',FScheme,FUserName,FRemoteHost,UriRemotePort,GetTag,'','',UriTransportName); //???
          AddTo('',FScheme,FUserName,FRemoteHost,UriRemotePort,'','','',UriTransportName); //???
          AddCallID(FID);
          AddCSeq(NextSequence,Request.Name);
          AddContact;
          AddAllow([atINVITE,atACK,atBYE,atCANCEL]);
          AddMaxForwards(IntToStr(FMaxForwards));
          AddExpires('0');
          AddContentLength(IntToStr(Body.Length));
        end;
      end;
    end;
    FRequests.Add(Request);
    SendRequest(Request);
  end;
end;

end.
