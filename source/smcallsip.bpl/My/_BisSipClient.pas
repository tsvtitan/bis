unit BisSipClient;

interface

uses Classes, Contnrs, SysUtils, SyncObjs,
     IdGlobal, IdUdpServer, IdTCPServer, IdSocketHandle,
     BisSip, BisLocks, BisThreads;

type
  TBisSipRequestMethod=procedure (Request: TBisSipRequest) of object;

  TBisSipReceiver=class(TBisLock)
  private
    FID: String;
    FRequests: TBisSipRequests;
  protected
    function ReceiveRequest(Request: TBisSipRequest): Boolean; virtual;
    function ReceiveResponse(Response: TBisSipResponse): Boolean; virtual;

    property Requests: TBisSipRequests read FRequests;
  public
    constructor Create; override;
    destructor Destroy; override;

    property ID: String read FID write FID;
  end;

  TBisSipReceiverClass=class of TBisSipReceiver;

  TBisSipReceivers=class(TBisLocks)
  private
    function GetItem(Index: Integer): TBisSipReceiver;
  public

    function FindByID(ID: String): TBisSipReceiver;
    function LockFindByID(ID: String): TBisSipReceiver;
    procedure GetReceivers(AClass: TBisSipReceiverClass; Receivers: TBisSipReceivers);

    property Items[Index: Integer]: TBisSipReceiver read GetItem; default;
  end;

  TBisSipClient=class;

  TBisSipUdpServer=class(TIdUDPServer)
  end;

  TBisSipTcpServer=class(TIdTCPServer)
  end;

  TBisSipTransportMode=(tmUDP,tmTCP);

  TBisSipTransport=class(TObject)
  private
    FClient: TBisSipClient;
    FReceivers: TBisSipReceivers;
    FUdpServer: TBisSipUdpServer;
    FTcpServer: TBisSipTcpServer;
    FMode: TBisSipTransportMode;
    FDefaultIP: String;
    FLock: TCriticalSection;
    FThreads: TBisThreads;
    FCheckRemoteIP: Boolean;

    function TryActive: Boolean;
    procedure Disable;

    procedure UdpServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure UdpServerUDPException(Sender: TObject; ABinding: TIdSocketHandle; const AMessage: String; const AExceptionClass: TClass);

    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetMode(const Value: TBisSipTransportMode);

    procedure ThreadWork(Thread: TBisThread);
    procedure ThreadEnd(Thread: TBisThread; const AException: Exception);
    function GetMaxThreadCount: Integer;
    procedure SetMaxThreadCount(const Value: Integer);
  protected
    function GetName: String;
    function Send(Host: String; Port: Integer; Data: String): Boolean; virtual;

    property Receivers: TBisSipReceivers read FReceivers;
  public
    constructor Create(Client: TBisSipClient); virtual;
    destructor Destroy; override;

    property Name: String read GetName;

    property Active: Boolean read GetActive write SetActive;
    property Mode: TBisSipTransportMode read FMode write SetMode;
    property DefaultIP: String read FDefaultIP write FDefaultIP;
    property CheckRemoteIP: Boolean read FCheckRemoteIP write FCheckRemoteIP;
    property MaxThreadCount: Integer read GetMaxThreadCount write SetMaxThreadCount;
  end;

  TBisSipSessionState=(ssReady,ssWaiting,ssRinging,ssConfirming,ssBreaking,ssProcessing,ssTrying,ssProgressing,ssDestroying);

  TBisSipSessionDirection=(sdUnknown,sdIncoming,sdOutgoing);

  TBisSipSession=class(TBisSipReceiver)
  private

    FClient: TBisSipClient;
    FState: TBisSipSessionState;
    FReadyForDestroy: Boolean;
    FDirection: TBisSipSessionDirection;
    FContentTypeKind: TBisSipContentTypeKind;
    FSequence: Integer;
    function ValidSequence(Sequence: String): Boolean;
    procedure SendRequest(Request: TBisSipRequest; Method: TBisSipRequestMethod; WithWait: Boolean);
    procedure SendResponse(Request: TBisSipRequest; Response: TBisSipResponse);
    procedure WaitBye(Request: TBisSipRequest);
    procedure WaitInvite(Request: TBisSipRequest);
    procedure WaitCancel(Request: TBisSipRequest);
    procedure WaitProxyAuthorization(Request: TBisSipRequest);
  protected
    function ReceiveRequest(Request: TBisSipRequest): Boolean; override;
    function ReceiveResponse(Response: TBisSipResponse): Boolean; override;
  public
    constructor Create(Client: TBisSipClient; Direction: TBisSipSessionDirection); reintroduce;
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
    FClient: TBisSipClient;
    function GetSession(Index: Integer): TBisSipSession;
  public
    constructor Create(Client: TBisSipClient); reintroduce;
    function FindByID(ID: String): TBisSipSession; reintroduce;
    function FindByMessage(Message: TBisSipMessage): TBisSipSession;
    function LockFindByMessage(Message: TBisSipMessage): TBisSipSession;
    function Add(ID: String; Direction: TBisSipSessionDirection): TBisSipSession; reintroduce; overload;
    function LockAdd(ID: String; Direction: TBisSipSessionDirection): TBisSipSession;

    property Items[Index: Integer]: TBisSipSession read GetSession; default;
  end;

  TBisSipRequestWaitThread=class(TBisWaitThread)
  private
    FRequest: TBisSipRequest;
    FMethod: TBisSipRequestMethod;
    procedure DoMethod;
  public
    constructor Create(const TimeOut: Cardinal; Request: TBisSipRequest; Method: TBisSipRequestMethod); reintroduce;
    destructor Destroy; override;

  end;

  TBisSipRequestWaitThreads=class(TBisThreads)
  private
    FOnTimeOut: TBisWaitThreadEvent;
    FOnEnd: TBisThreadEndEvent;
    FTimeOut: Cardinal;
    function GetItem(Index: Integer): TBisSipRequestWaitThread;
    procedure ThreadEnd(Thread: TBisThread; const AException: Exception);
  protected
    procedure DoItemFree(Item: TObject); override;
  public
    function LockAdd(Request: TBisSipRequest; Method: TBisSipRequestMethod): TBisSipRequestWaitThread; reintroduce;
    procedure LockRemoveBy(Request: TBisSipRequest); overload;
    procedure LockRemoveBy(Method: TBisSipRequestMethod); overload;

    property Items[Index: Integer]: TBisSipRequestWaitThread read GetItem; default;
  end;

  TBisSipClientState=(csDefault,csRegistering,csUnRegistering);

  TBisSipClientEvent=procedure (Client: TBisSipClient) of object;
  TBisSipClientAcceptEvent=function (Client: TBisSipClient; Session: TBisSipSession; Message: TBisSipMessage): Boolean of object;
  TBisSipClientSessionEvent=procedure (Client: TBisSipClient; Session: TBisSipSession) of object;
  TBisSipClientSessionTimeoutEvent=procedure (Client: TBisSipClient; Session: TBisSipSession; var TryRegister: Boolean) of object;
  TBisSipClientSessionRequestEvent=procedure (Client: TBisSipClient; Session: TBisSipSession; Request: TBisSipRequest) of object;
  TBisSipClientSessionResponseEvent=procedure (Client: TBisSipClient; Session: TBisSipSession;
                                               Request: TBisSipRequest; Response: TBisSipResponse) of object;
  TBisSipClientAliveEvent=function (Client: TBisSipClient; Session: TBisSipSession): Boolean of object;
  TBisSipClientTimeoutEvent=procedure (Client: TBisSipClient; var Interrupted: Boolean) of object;
  TBisSipClientSessionContentEvent=procedure (Client: TBisSipClient; Session: TBisSipSession; Content: String) of object;
  TBisSipClientErrorEvent=procedure (Client: TBisSipClient; const Error: String) of object;
  TBisSipClientSendEvent=procedure (Client: TBisSipClient; Host: String; Port: Integer; Data: String) of object;
  TBisSipClientReceiveEvent=TBisSipClientSendEvent;

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
    FQ: String;
    FUserAgent: String;
    FSequence: Integer;
    FTransport: TBisSipTransport;
    FMaxForwards: Integer;
    FOnRegister: TBisSipClientEvent;
    FRegistered: Boolean;
    FWaitRetryCount: Cardinal;
    FUseRport: Boolean;
    FKeepAliveQuery: String;
    FUseTrasnportNameInUri: Boolean;
    FUsePortInUri: Boolean;
    FUseGlobalSequence: Boolean;
    FState: TBisSipClientState;

    FWaits: TBisSipRequestWaitThreads;
    FSessions: TBisSipSessions;
    FUseReceived: Boolean;
    FReceived: String;
    FRegisterThread: TBisWaitThread;
    FKeepAliveThread: TBisWaitThread;

    FOnError: TBisSipClientErrorEvent;
    FOnReceive: TBisSipClientReceiveEvent;
    FOnSend: TBisSipClientSendEvent;
    FOnTimeout: TBisSipClientTimeoutEvent;
    
    FOnSessionRing: TBisSipClientSessionEvent;
    FOnSessionProgress: TBisSipClientSessionEvent;
    FOnSessionCreate: TBisSipClientSessionEvent;
    FOnSessionDestroy: TBisSipClientSessionEvent;
    FOnSessionConfirm: TBisSipClientSessionEvent;
    FOnSessionTerminate: TBisSipClientSessionEvent;
    FOnSessionAccept: TBisSipClientAcceptEvent;
    FOnSessionTimeout: TBisSipClientSessionTimeoutEvent;
    FOnSessionContent: TBisSipClientSessionContentEvent;
    FOnSessionRequest: TBisSipClientSessionRequestEvent;
    FOnSessionResponse: TBisSipClientSessionResponseEvent;

    procedure RegisterThreadTimeout(Thread: TBisWaitThread);
    procedure KeepAliveThreadTimeout(Thread: TBisWaitThread);

    procedure SendRequest(Request: TBisSipRequest; Method: TBisSipRequestMethod; WithWait,WithAdd: Boolean);
    procedure SendResponse(Response: TBisSipResponse);
    procedure WaitsTimeOut(Thread: TBisWaitThread);
    procedure WaitsEnd(Thread: TBisThread; const AException: Exception);
    procedure RemoveWaits(Session: TBisSipSession);
    function GetTransportName: String;
    function GetWaitTimeOut: Cardinal;
    procedure SetWaitTimeOut(const Value: Cardinal);
    function GetExpires: Cardinal;
    procedure SetExpires(const Value: Cardinal);
    function GetKeepAliveInterval: Cardinal;
    procedure SetKeepAliveInterval(const Value: Cardinal);
    procedure WaitRegister(Request: TBisSipRequest);
    procedure WaitUnRegister(Request: TBisSipRequest);
  protected
    function ReceiveRequest(Request: TBisSipRequest): Boolean; override;
    function ReceiveResponse(Response: TBisSipResponse): Boolean; override;

    procedure DoRegister; virtual;
    procedure DoError(const Error: String); virtual;
    procedure DoSend(Host: String; Port: Integer; Data: String); virtual;
    procedure DoReceive(Host: String; Port: Integer; Data: String); virtual;
    procedure DoTimeout(var Interrupted: Boolean); virtual;

    procedure DoSessionCreate(Session: TBisSipSession); virtual;
    procedure DoSessionDestroy(Session: TBisSipSession); virtual;
    function DoSessionAccept(Session: TBisSipSession; Message: TBisSipMessage): Boolean; virtual;
    procedure DoSessionRing(Session: TBisSipSession); virtual;
    procedure DoSessionProgress(Session: TBisSipSession); virtual;
    procedure DoSessionConfirm(Session: TBisSipSession); virtual;
    procedure DoSessionTerminate(Session: TBisSipSession); virtual;
    procedure DoSessionTimeout(Session: TBisSipSession; var TryRegister: Boolean); virtual;
    procedure DoSessionContent(Session: TBisSipSession; Content: String); virtual;
    procedure DoSessionRequest(Session: TBisSipSession; Request: TBisSipRequest); virtual;
    procedure DoSessionResponse(Session: TBisSipSession; Request: TBisSipRequest; Response: TBisSipResponse); virtual;
  public
    constructor Create; override;
    destructor Destroy; override;
    function NextSequence: String;

    procedure Register(Active: Boolean; Initial: Boolean=false);
    function UriTransportName: String;
    function UriLocalPort: String;
    function UriRemotePort: String;
//    function CheckUri(Uri: String): Boolean;
    procedure Terminate;

    property Sessions: TBisSipSessions read FSessions;
    property Registered: Boolean read FRegistered;
  //  property Uri: String read GetUri;
    property Transport: TBisSipTransport read FTransport;
    property State: TBisSipClientState read FState;

    property Scheme: String read FScheme write FScheme;
    property Protocol: String read FProtocol write FProtocol;
    property RemoteHost: String read FRemoteHost write FRemoteHost;
    property RemoteIP: String read FRemoteIP write FRemoteIP;
    property RemotePort: Integer read FRemotePort write FRemotePort;
    property LocalIP: String read FLocalIP write FLocalIP;
    property LocalPort: Integer read FLocalPort write FLocalPort;
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property Expires: Cardinal read GetExpires write SetExpires;
    property UserAgent: String read FUserAgent write FUserAgent;
    property MaxForwards: Integer read FMaxForwards write FMaxForwards;
    property KeepAliveInterval: Cardinal read GetKeepAliveInterval write SetKeepAliveInterval;
    property KeepAliveQuery: String read FKeepAliveQuery write FKeepAliveQuery;
    property UseReceived: Boolean read FUseReceived write FUseReceived;
    property UseRport: Boolean read FUseRport write FUseRport;
    property UseTrasnportNameInUri: Boolean read FUseTrasnportNameInUri write FUseTrasnportNameInUri;
    property UsePortInUri: Boolean read FUsePortInUri write FUsePortInUri;
    property UseGlobalSequence: Boolean read FUseGlobalSequence write FUseGlobalSequence;
    property WaitRetryCount: Cardinal read FWaitRetryCount write FWaitRetryCount;
    property WaitTimeOut: Cardinal read GetWaitTimeOut write SetWaitTimeOut;

    property OnRegister: TBisSipClientEvent read FOnRegister write FOnRegister;
    property OnError: TBisSipClientErrorEvent read FOnError write FOnError;
    property OnReceive: TBisSipClientReceiveEvent read FOnReceive write FOnReceive;
    property OnSend: TBisSipClientSendEvent read FOnSend write FOnSend;
    property OnTimeout: TBisSipClientTimeoutEvent read FOnTimeout write FOnTimeout;

    property OnSessionCreate: TBisSipClientSessionEvent read FOnSessionCreate write FOnSessionCreate;
    property OnSessionDestroy: TBisSipClientSessionEvent read FOnSessionDestroy write FOnSessionDestroy;
    property OnSessionAccept: TBisSipClientAcceptEvent read FOnSessionAccept write FOnSessionAccept;
    property OnSessionRing: TBisSipClientSessionEvent read FOnSessionRing write FOnSessionRing;
    property OnSessionProgress: TBisSipClientSessionEvent read FOnSessionProgress write FOnSessionProgress;
    property OnSessionConfirm: TBisSipClientSessionEvent read FOnSessionConfirm write FOnSessionConfirm;
    property OnSessionTerminate: TBisSipClientSessionEvent read FOnSessionTerminate write FOnSessionTerminate;
    property OnSessionTimeout: TBisSipClientSessionTimeoutEvent read FOnSessionTimeout write FOnSessionTimeout;
    property OnSessionContent: TBisSipClientSessionContentEvent read FOnSessionContent write FOnSessionContent;
    property OnSessionRequest: TBisSipClientSessionRequestEvent read FOnSessionRequest write FOnSessionRequest;
    property OnSessionResponse: TBisSipClientSessionResponseEvent read FOnSessionResponse write FOnSessionResponse; 

  end;

const
  DefaultSipPort=5060;
  DefaultScheme='sip';
  DefaultProtocol='SIP/2.0';

implementation

uses Windows, 
     BisUtils, BisCrypter, BisNetUtils;

function GetBranch: String;
var
  Crypter: TBisCrypter;
begin
  Crypter:=TBisCrypter.Create;
  try
    Result:=Crypter.HashString(GetUniqueID,haCRC32,hfHEX);
    Result:='z9hG4bK'+Result;
  finally
    Crypter.Free;
  end;
end;

function GetTag: String;
var
  Crypter: TBisCrypter;
begin
  Crypter:=TBisCrypter.Create;
  try
    Result:=Crypter.HashString(GetUniqueID,haCRC32,hfHEX);
  finally
    Crypter.Free;
  end;
end;

{ TBisSipReceiver }

constructor TBisSipReceiver.Create;
begin
  inherited Create;
  FID:=GetUniqueID;
  FRequests:=TBisSipRequests.Create;
end;

destructor TBisSipReceiver.Destroy;
begin
  FRequests.Free;
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

function TBisSipReceivers.LockFindByID(ID: String): TBisSipReceiver;
begin
  Lock;
  try
    Result:=FindByID(ID);
  finally
    UnLock;
  end;
end;

type
  TBisSipReceiveThread=class(TBisThread)
  private
    FData: String;
    FIP: String;
    FPort: Integer;
  end;

{ TBisSipTransport }

constructor TBisSipTransport.Create(Client: TBisSipClient);
begin
  inherited Create;
  FClient:=Client;

  FLock:=TCriticalSection.Create;

  FReceivers:=TBisSipReceivers.Create;
  FReceivers.OwnsObjects:=false;
  FReceivers.Add(Client);

  FUdpServer:=TBisSipUdpServer.Create(nil);
  FUdpServer.OnUDPRead:=UdpServerUDPRead;
  FUdpServer.OnUDPException:=UdpServerUDPException;
  FUdpServer.ThreadedEvent:=true;
  FUdpServer.ThreadName:='SipUdpTransport';

  FTcpServer:=TBisSipTcpServer.Create(nil);

  FThreads:=TBisThreads.Create;
  FThreads.MaxCount:=10;

  FMode:=tmUDP;
  FDefaultIP:='0.0.0.0';
  FCheckRemoteIP:=true;
end;

destructor TBisSipTransport.Destroy;
begin
  FreeAndNilEx(FThreads);
  FTcpServer.Free;
  FUdpServer.Free;
  FReceivers.Remove(FClient);
  FReceivers.Free;
  FLock.Free;
  inherited Destroy;
end;

procedure TBisSipTransport.ThreadEnd(Thread: TBisThread; const AException: Exception);
begin
  if Assigned(FThreads) then
    FThreads.LockRemove(Thread);
end;

function TBisSipTransport.GetName: String;
begin
  Result:='';
  case FMode of
    tmUDP: Result:='UDP';
    tmTCP: Result:='TCP';
  end;
end;

procedure TBisSipTransport.SetMaxThreadCount(const Value: Integer);
begin
  FThreads.MaxCount:=Value;
end;

procedure TBisSipTransport.SetMode(const Value: TBisSipTransportMode);
var
  Old: Boolean;
begin
  if FMode<>Value then begin
    Old:=Active;
    try
      Active:=false;
      FMode:=Value;
    finally
      Active:=Old;
    end;
  end;
end;

procedure TBisSipTransport.Disable;
begin
  FUdpServer.OnUDPRead:=nil;
  if FUdpServer.Active then begin
    FUdpServer.Active:=false;
    FUdpServer.Bindings.Clear;
  end;
  if FTcpServer.Active then begin
    FTcpServer.Active:=false;
    FTcpServer.Bindings.Clear;
  end;
end;

function TBisSipTransport.TryActive: Boolean;

  function SetPort(IP: String; P: Integer): Boolean;
  var
    B: TIdSocketHandle;
  begin
    Result:=false;
    case FMode of
      tmUDP: begin
        if not UDPPortExists(IP,P) then begin
          try
            FUdpServer.Bindings.Clear;
            B:=FUdpServer.Bindings.Add;
            if Assigned(B) then begin
              B.IP:=IP;
              B.Port:=P;
              FUdpServer.Active:=true;
              Result:=FUdpServer.Active;
              if Result then
                FUdpServer.OnUDPRead:=UdpServerUDPRead;
            end;
          except
            FUdpServer.Active:=false;
            FUdpServer.OnUDPRead:=nil;
          end;
        end;
      end;
      tmTCP: begin
        if not TCPPortExists(IP,P) then begin
          try
            FTcpServer.Bindings.Clear;
            B:=FTcpServer.Bindings.Add;
            if Assigned(B) then begin
              B.IP:=IP;
              B.Port:=P;
              FTcpServer.Active:=true;
              Result:=FTcpServer.Active;
            end;
          except
            FTcpServer.Active:=false;
          end;
        end;
      end;
    end;
  end;

var
  First: Integer;
  MaxPort: Integer;
begin
  Result:=false;
  Disable;
  if not Active then begin
    FLock.Enter;
    try
      First:=FClient.LocalPort;
      MaxPort:=POWER_2;
      while First<MaxPort do begin
        Result:=SetPort(FDefaultIP,First);
        if not Result then
          Inc(First)
        else begin
          FClient.LocalPort:=First;
          break;
        end;
      end;
    finally
      FLock.Leave;
    end;
  end;
end;

procedure TBisSipTransport.SetActive(const Value: Boolean);
begin
  try
    if Value then
      TryActive
    else
      Disable;
  except
    On E: Exception do
      FClient.DoError(E.Message);
  end;                                                             
end;

function TBisSipTransport.GetActive: Boolean;
begin
  Result:=false;
  case FMode of
    tmUDP: Result:=FUdpServer.Active;
    tmTCP: Result:=FTcpServer.Active;
  end;
end;

function TBisSipTransport.GetMaxThreadCount: Integer;
begin
  Result:=FThreads.MaxCount;
end;

function TBisSipTransport.Send(Host: String; Port: Integer; Data: String): Boolean;
begin
  Result:=false;
  try
    if Active then begin

      FClient.DoSend(Host,Port,Data);

      case FMode of
        tmUDP: begin
          FUdpServer.Send(Host,Port,Data);
          Result:=true;
        end;
        tmTCP: begin

        end;
      end;
    end;
  except
    On E: Exception do
      FClient.DoError(E.Message);
  end;
end;

procedure TBisSipTransport.UdpServerUDPException(Sender: TObject; ABinding: TIdSocketHandle; const AMessage: String;
                                                 const AExceptionClass: TClass);
begin
  FClient.DoError(AMessage);
end;

procedure TBisSipTransport.ThreadWork(Thread: TBisThread);

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
    if Assigned(Session) and (Session.State=ssDestroying) then begin
      FClient.Sessions.LockRemove(Session);
      Result:=true;
    end;
  end;
  
  procedure UnknownRequest(ID, Name, Uri, Protocol: String;
                           Headers: TBisSipHeaders; Body: String);
  var
    Session: TBisSipSession;
    Request: TBisSipRequest;
    RequestType: TBisSipRequestType;
  begin
    if TBisSipRequest.RequestNameToType(Name,RequestType) and (RequestType=rtINVITE) then begin
      Session:=FClient.Sessions.LockAdd(ID,sdIncoming);
      if Assigned(Session) then begin
        if Session.TryLock then begin
          try
            Request:=TBisSipRequest.Create(rdIncoming,RequestType,Uri,Protocol);
            Request.Headers.CopyFrom(Headers);
            Request.Body.Text:=Body;
            if not Session.ReceiveRequest(Request) then
              Request.Free;
          finally
            Session.UnLock;
            if Session.FReadyForDestroy then
              TryToRemoveSession(Session);
          end;
        end else
          FClient.Sessions.LockRemove(Session);
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
  AThread: TBisSipReceiveThread;
begin
  AThread:=TBisSipReceiveThread(Thread);
  if Assigned(AThread) then begin
    try
      FClient.DoReceive(AThread.FIP,AThread.FPort,AThread.FData);
      
      Strings:=TStringList.Create;
      Headers:=TBisSipHeaders.Create;
      try
        Strings.Text:=Trim(AThread.FData);
        if ParseStrings(Strings,Headers,H1,H2,H3,LastIndex) then begin
          CallID:=TBisSipCallID(Headers.Find(TBisSipCallID));
          if Assigned(CallID) then begin
            IsRequest:=TBisSipRequest.RequestNameToType(H1,RequestType) and (RequestType<>rtUNKNOWN);
            Body:=ParseBody(Strings,LastIndex);
            Receiver:=FReceivers.LockFindByID(CallID.Value);
            if Assigned(Receiver) then begin
              if Receiver.TryLock then begin
                try
                  if not TryToRemoveReceiver(Receiver,false) then begin
                    try
                      if IsRequest then
                        ReceiverRequest(Receiver,H1,H2,H3,Headers,Body)
                      else
                        ReceiverResponse(Receiver,H1,H2,H3,Headers,Body);
                    finally
                      TryToRemoveReceiver(Receiver,true);
                    end;
                  end;
                finally
                  if Assigned(Receiver) then
                    Receiver.UnLock;
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
    except
      On E: Exception do
        FClient.DoError(E.Message);
    end;
  end;
end;

procedure TBisSipTransport.UdpServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
var
  Flag: Boolean;
  Thread: TBisSipReceiveThread;
begin
  try
    if Active then begin

      Flag:=true;
      if FCheckRemoteIP then
        Flag:=(ABinding.PeerIP=FClient.RemoteIP) and
              (ABinding.PeerPort=FClient.RemotePort);

      if Flag then begin
        FThreads.Lock;
        try
          if FThreads.Count<FThreads.MaxCount then begin
            Thread:=TBisSipReceiveThread.Create;
            Thread.OnWork:=ThreadWork;
            Thread.OnEnd:=ThreadEnd;
            Thread.FData:=BytesToString(AData);
            Thread.FIP:=ABinding.PeerIP;
            Thread.FPort:=ABinding.PeerPort;
            FThreads.Add(Thread);
            Thread.Start;
          end;
        finally
          FThreads.UnLock;
        end;
      end;
    end;
  except
    On E: Exception do
      FClient.DoError(E.Message);
  end;
end;

{ TBisSipSession }

constructor TBisSipSession.Create(Client: TBisSipClient; Direction: TBisSipSessionDirection);
begin
  inherited Create;
  Requests.MaxCount:=25;
  FID:=GetUniqueID;
  FDirection:=Direction;
  FClient:=Client;
  if Assigned(FClient) then begin
    FClient.Transport.Receivers.LockAdd(Self);
    FClient.DoSessionCreate(Self);
  end;
  FSequence:=0;
end;

destructor TBisSipSession.Destroy;
begin
  if Assigned(FClient) then begin
    FClient.RemoveWaits(Self);
    FClient.Transport.Receivers.LockRemove(Self);
    FClient.DoSessionDestroy(Self);
  end;
  inherited Destroy;
end;

function TBisSipSession.NextSequence: String;
begin
  Result:='';
  if Assigned(FClient) then begin
    if FClient.UseGlobalSequence then
      Result:=FClient.NextSequence
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
  if Assigned(FClient) then begin
    I1:=StrToIntDef(Sequence,0);
    if FClient.UseGlobalSequence then
      I2:=FClient.FSequence
    else
      I2:=FSequence;
    Result:=I1>=I2;
  end;
end;

procedure TBisSipSession.SendRequest(Request: TBisSipRequest; Method: TBisSipRequestMethod; WithWait: Boolean);
begin
  Requests.LockAdd(Request);
  FClient.SendRequest(Request,Method,WithWait,false);
end;

procedure TBisSipSession.SendResponse(Request: TBisSipRequest; Response: TBisSipResponse);
begin
  if Assigned(Request) then
    Request.Responses.LockAdd(Response);
  FClient.SendResponse(Response);  
end;

procedure TBisSipSession.WaitBye(Request: TBisSipRequest);
begin
  FState:=ssDestroying;
  FClient.DoSessionTerminate(Self);
  FReadyForDestroy:=true;
  Free;
end;

procedure TBisSipSession.WaitInvite(Request: TBisSipRequest);
begin
  WaitBye(Request);
end;

procedure TBisSipSession.WaitCancel(Request: TBisSipRequest);
begin
  WaitBye(Request);
end;

procedure TBisSipSession.WaitProxyAuthorization(Request: TBisSipRequest);
begin
  WaitBye(Request);
end;

procedure TBisSipSession.ResponseInviteOK(Body: String; ContentTypeKind: TBisSipContentTypeKind=ctkApplicationSdp);
var
  InviteRequest: TBisSipRequest;
  RingingResponse: TBisSipResponse;
  Response: TBisSipResponse;
  RKI: TBisSipResponseKindInfo;
begin
  if (FState in [ssRinging,ssProgressing]) and (FDirection=sdIncoming) then begin
    RKI:=FindResponseKindInfo(rkOK);
    if Assigned(RKI) then begin
      InviteRequest:=Requests.LockFindByType(rtINVITE);
      if Assigned(InviteRequest) then begin
        RingingResponse:=InviteRequest.Responses.LockFindByKind(rkRinging);
        if Assigned(RingingResponse) then begin
          RingingResponse.Lock;
          try
            Response:=TBisSipResponse.Create(FClient.Protocol,RKI.Code,RKI.Description);
            Response.Body.Text:=Body;
            with Response.Headers do begin
              CopyFrom(RingingResponse.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
              AddContact('',FClient.Scheme,FClient.UserName,FClient.LocalIP,FClient.UriLocalPort,'','','','','',FClient.UriTransportName); //???
              AddAllow([atINVITE,atACK,atCANCEL,atBYE]);
              AddContentType(ContentTypeKind);
              AddContentLength(IntToStr(Response.Body.Length));
            end;
            SendResponse(InviteRequest,Response);
            FState:=ssConfirming;
          finally
            RingingResponse.UnLock;
          end;
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
  if (FState in [ssRinging,ssProgressing]) and (FDirection=sdIncoming) then begin
    RKI:=FindResponseKindInfo(rkBusyHere);
    if Assigned(RKI) then begin
      InviteRequest:=Requests.LockFindByType(rtINVITE);
      if Assigned(InviteRequest) then begin
        RingingResponse:=InviteRequest.Responses.LockFindByKind(rkRinging);
        if Assigned(RingingResponse) then begin
          RingingResponse.Lock;
          try
            Response:=TBisSipResponse.Create(FClient.Protocol,RKI.Code,RKI.Description);
            with Response.Headers do begin
              CopyFrom(RingingResponse.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
              AddContentLength(IntToStr(Response.Body.Length));
            end;
            SendResponse(InviteRequest,Response);
            FState:=ssDestroying;
          finally
            RingingResponse.UnLock;
          end;
        end else begin
          FState:=ssDestroying;
          FClient.DoSessionTerminate(Self);
          FReadyForDestroy:=true;
        end;
      end;
    end;
  end else begin
    FState:=ssDestroying;
    FClient.DoSessionTerminate(Self);
    FReadyForDestroy:=true;
  end;
end;

procedure TBisSipSession.RequestBye;
var
  AckRequest: TBisSipRequest;
  Request: TBisSipRequest;
  AFrom, ATo: TBisSipFrom;
begin
  if (FState=ssProcessing) and (FDirection in [sdIncoming,sdOutgoing]) then begin
    AckRequest:=Requests.LockFindByType(rtACK);
    if Assigned(AckRequest) then begin
      Request:=nil;
      case FDirection of
        sdIncoming: begin
          AFrom:=TBisSipFrom(AckRequest.Headers.Find(TBisSipFrom));
          ATo:=TBisSipTo(AckRequest.Headers.Find(TBisSipTo));
          if Assigned(AFrom) and Assigned(ATo) then begin
            Request:=TBisSipRequest.Create(rdOutgoing,rtBYE,
                                           iff(AckRequest.Direction=rdIncoming,AFrom.Uri,ATo.Uri),
                                           FClient.Protocol);
            with Request.Headers do begin
              AddVia(FClient.Protocol,FClient.Transport.Name,FClient.LocalIP,IntToStr(FClient.LocalPort),GetBranch,'','');
              if AckRequest.Direction=rdIncoming then begin
                Add(TBisSipFrom).CopyFrom(ATo);
                Add(TBisSipTo).CopyFrom(AFrom);
              end else begin
                Add(TBisSipFrom).CopyFrom(AFrom);
                Add(TBisSipTo).CopyFrom(ATo);
              end;
              AddCallID(ID);
              AddCSeq(NextSequence,Request.Name);
              AddMaxForwards(IntToStr(FClient.MaxForwards));
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
                                           FClient.Protocol);
            with Request.Headers do begin
              AddVia(FClient.Protocol,FClient.Transport.Name,FClient.LocalIP,IntToStr(FClient.LocalPort),GetBranch,'','');
              if AckRequest.Direction=rdIncoming then begin
                Add(TBisSipFrom).CopyFrom(ATo);
                Add(TBisSipTo).CopyFrom(AFrom);
              end else begin
                Add(TBisSipFrom).CopyFrom(AFrom);
                Add(TBisSipTo).CopyFrom(ATo);
              end;
              AddCallID(ID);
              AddCSeq(NextSequence,Request.Name);
              AddMaxForwards(IntToStr(FClient.MaxForwards));
              AddContentLength(IntToStr(Request.Body.Length))
            end;
          end;
        end;
      end;
      if Assigned(Request) then begin
        SendRequest(Request,WaitBye,true);
        FState:=ssBreaking;
      end;
    end;
  end else begin
    FState:=ssDestroying;
    FClient.DoSessionTerminate(Self);
    FReadyForDestroy:=true;
  end;
end;

procedure TBisSipSession.RequestInvite(User, Body: String; ContentTypeKind: TBisSipContentTypeKind);
var
  AckRequest: TBisSipRequest;
  Request: TBisSipRequest;
  AFrom, ATo: TBisSipFrom;
  AVia: TBisSipVia;
begin
  if (((FState=ssReady) and (FDirection=sdOutgoing)) or
     ((FState=ssProcessing) and (FDirection in [sdIncoming,sdOutgoing]))) then begin
    FContentTypeKind:=ContentTypeKind;
    Request:=nil;
    case FState of
      ssReady: begin
        Request:=TBisSipRequest.Create(rdOutgoing,rtINVITE,
                                       FClient.Scheme,User,FClient.RemoteHost,FClient.UriRemotePort,
                                       FClient.Protocol,FClient.UriTransportName);
        Request.Body.Text:=Body;
        with Request.Headers do begin
          AddVia(FClient.Protocol,FClient.Transport.Name,FClient.LocalIP,IntToStr(FClient.LocalPort),GetBranch,'','');
          AddFrom('',FClient.Scheme,FClient.UserName,FClient.RemoteHost,FClient.UriRemotePort,GetTag,'','',FClient.UriTransportName); // ???
          AddTo('',FClient.Scheme,User,FClient.RemoteHost,FClient.UriRemotePort,'','','',FClient.UriTransportName); // ???
          AddCallID(ID);
          AddCSeq(NextSequence,Request.Name);
          AddAllow([atINVITE,atACK,atCANCEL,atBYE]);
          AddContact('',FClient.Scheme,FClient.UserName,FClient.LocalIP,FClient.UriLocalPort,'','','','','',FClient.UriTransportName); ///???
          AddMaxForwards(IntToStr(FClient.MaxForwards));
          AddContentType(ContentTypeKind);
          AddContentLength(IntToStr(Request.Body.Length));
        end;
      end;
      ssProcessing: begin
        case FDirection of
          sdIncoming: begin
            AckRequest:=Requests.LockFindByType(rtACK);
            if Assigned(AckRequest) then begin
              AFrom:=TBisSipFrom(AckRequest.Headers.Find(TBisSipFrom));
              ATo:=TBisSipTo(AckRequest.Headers.Find(TBisSipTo));
              if Assigned(AckRequest) and Assigned(AFrom) and Assigned(ATo) then begin
                Request:=TBisSipRequest.Create(rdOutgoing,rtINVITE,
                                               iff(AckRequest.Direction=rdIncoming,AFrom.Uri,ATo.Uri),
                                               FClient.Protocol);
                Request.Body.Text:=Body;
                with Request.Headers do begin
                  AddVia(FClient.Protocol,FClient.Transport.Name,FClient.LocalIP,IntToStr(FClient.LocalPort),GetBranch,'','');
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
                    AVia.Branch:=GetBranch;
                  AddCSeq(NextSequence,Request.Name);
                  AddAllow([atINVITE,atACK,atCANCEL,atBYE]);
                  AddContact('',FClient.Scheme,FClient.UserName,FClient.LocalIP,FClient.UriLocalPort,'','','','','',FClient.UriTransportName); //???
                  AddMaxForwards(IntToStr(FClient.MaxForwards));
                  AddContentType(ContentTypeKind);
                  AddContentLength(IntToStr(Request.Body.Length));
                end;
              end;
            end;
          end;
          sdOutgoing: begin
            AckRequest:=Requests.LockFindByType(rtACK);
            if Assigned(AckRequest) then begin
              Request:=TBisSipRequest.Create(rdOutgoing,rtINVITE,AckRequest.Uri,FClient.Protocol);
              Request.Body.Text:=Body;
              with Request.Headers do begin
                CopyFrom(AckRequest.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID]);
                AVia:=TBisSipVia(Find(TBisSipVia));
                if Assigned(AVia) then
                  AVia.Branch:=GetBranch;
                AddCSeq(NextSequence,Request.Name);
                AddAllow([atINVITE,atACK,atCANCEL,atBYE]);
                AddContact('',FClient.Scheme,FClient.UserName,FClient.LocalIP,FClient.UriLocalPort,'','','','','',FClient.UriTransportName); //???
                AddMaxForwards(IntToStr(FClient.MaxForwards));
                AddContentType(ContentTypeKind);
                AddContentLength(IntToStr(Request.Body.Length));
              end;
            end;
          end;
        end;
      end;
    end;
    if Assigned(Request) then begin
      SendRequest(Request,WaitInvite,true);
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
  if (FState in [ssWaiting,ssRinging,ssProgressing]) and (FDirection=sdOutgoing) then begin
    InviteRequest:=Requests.LockFindByType(rtINVITE);
    if Assigned(InviteRequest) then begin
      RingingResponse:=InviteRequest.Responses.LockFindByKind(rkRinging);
      if Assigned(RingingResponse) then begin
        RingingResponse.Lock;
        try
          Request:=TBisSipRequest.Create(rdOutgoing,rtCANCEL,InviteRequest.Uri,FClient.Protocol);
          with Request.Headers do begin
            CopyFrom(RingingResponse.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
            CSeq:=TBisSipCSeq(Find(TBisSipCSeq));
            if Assigned(CSeq) then
              CSeq.RequestName:=Request.Name;
            AddMaxForwards(IntToStr(FClient.MaxForwards));
            AddContentLength(IntToStr(Request.Body.Length))
          end;
          FState:=ssBreaking;
        finally
          RingingResponse.UnLock;
        end;
      end else begin
        Request:=TBisSipRequest.Create(rdOutgoing,rtCANCEL,InviteRequest.Uri,FClient.Protocol);
        with Request.Headers do begin
          CopyFrom(InviteRequest.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
          CSeq:=TBisSipCSeq(Find(TBisSipCSeq));
          if Assigned(CSeq) then
            CSeq.RequestName:=Request.Name;
          AddMaxForwards(IntToStr(FClient.MaxForwards));
          AddContentLength(IntToStr(Request.Body.Length))
        end;
        FState:=ssBreaking;
      end;
      SendRequest(Request,WaitCancel,true);
    end;
  end else begin
    FState:=ssDestroying;
    FClient.DoSessionTerminate(Self);
    FReadyForDestroy:=true;
  end;
end;

function TBisSipSession.ReceiveRequest(Request: TBisSipRequest): Boolean;

  procedure ResponseForbidden;
  var
    Response: TBisSipResponse;
    RKI: TBisSipResponseKindInfo;
  begin
    RKI:=FindResponseKindInfo(rkForbidden);
    if Assigned(RKI) then begin
      Response:=TBisSipResponse.Create(FClient.Protocol,RKI.Code,RKI.Description);
      with Response.Headers do begin
        CopyFrom(Request.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq,TBisSipContact,TBisSipExpires]);
        AddContentLength(IntToStr(Response.Body.Length));
      end;
      SendResponse(Request,Response);
    end;
  end;

  procedure ResponseNotAcceptableClient;
  var
    Response: TBisSipResponse;
    RKI: TBisSipResponseKindInfo;
  begin
    RKI:=FindResponseKindInfo(rkNotAcceptableClient);
    if Assigned(RKI) then begin
      Response:=TBisSipResponse.Create(FClient.Protocol,RKI.Code,RKI.Description);
      with Response.Headers do begin
        CopyFrom(Request.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq,TBisSipContact,TBisSipExpires]);
        AddContentLength(IntToStr(Response.Body.Length));
      end;
      SendResponse(Request,Response);
    end;
  end;

  procedure ResponseBusyHere;
  var
    Response: TBisSipResponse;
    RKI: TBisSipResponseKindInfo;
  begin
    RKI:=FindResponseKindInfo(rkBusyHere);
    if Assigned(RKI) then begin
      Response:=TBisSipResponse.Create(FClient.Protocol,RKI.Code,RKI.Description);
      with Response.Headers do begin
        CopyFrom(Request.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq,TBisSipContact,TBisSipExpires]);
        AddContentLength(IntToStr(Response.Body.Length));
      end;
      SendResponse(Request,Response);
    end;
  end;

  function ResponseTrying: TBisSipResponse;
  var
    Response: TBisSipResponse;
    RKI: TBisSipResponseKindInfo;
    ATo: TBisSipTo;
  begin
    Result:=nil;
    RKI:=FindResponseKindInfo(rkTrying);
    if Assigned(RKI) then begin
      Response:=TBisSipResponse.Create(FClient.Protocol,RKI.Code,RKI.Description);
      with Response.Headers do begin
        CopyFrom(Request.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
        ATo:=TBisSipTo(Find(TBisSipTo));
        if Assigned(ATo) then
          ATo.Tag:=GetTag;
        AddContentLength(IntToStr(Response.Body.Length));
      end;
      Result:=Response;
      SendResponse(Request,Response);
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
      RKI:=FindResponseKindInfo(rkRinging);
      if Assigned(RKI) then begin
        Response:=TBisSipResponse.Create(FClient.Protocol,RKI.Code,RKI.Description);
        with Response.Headers do begin
          CopyFrom(Request.Headers,[TBisSipVia,TBisSipFrom,TBisSipCallID,TBisSipCSeq]);
          CopyFrom(TryingResponse.Headers,[TBisSipTo]);
          AddContentLength(IntToStr(Response.Body.Length));
        end;
        SendResponse(Request,Response);
      end;
    end;
  end;

  procedure ResponseOK;
  var
    Response: TBisSipResponse;
    RKI: TBisSipResponseKindInfo;
  begin
    RKI:=FindResponseKindInfo(rkOK);
    if Assigned(RKI) then begin
      Response:=TBisSipResponse.Create(FClient.Protocol,RKI.Code,RKI.Description);
      with Response.Headers do begin
        CopyFrom(Request.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
        AddContentLength(IntToStr(Response.Body.Length));
      end;
      SendResponse(Request,Response);
    end;
  end;

  procedure ResponseRequestTerminated;
  var
    Response: TBisSipResponse;
    RKI: TBisSipResponseKindInfo;
    CSeq: TBisSipCSeq;
  begin
    RKI:=FindResponseKindInfo(rkRequestTerminated);
    if Assigned(RKI) then begin
      Response:=TBisSipResponse.Create(FClient.Protocol,RKI.Code,RKI.Description);
      with Response.Headers do begin
        CopyFrom(Request.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
        AddContentLength(IntToStr(Response.Body.Length));
      end;
      CSeq:=TBisSipCSeq(Response.Headers.Find(TBisSipCSeq));
      if Assigned(CSeq) then
        CSeq.RequestName:=TBisSipRequest.RequestTypeToName(rtINVITE);
      SendResponse(Request,Response);
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
        TryingResponse:=ResponseTrying;
        ResponseSessionProgress;
        ResponseRinging(TryingResponse);
        if FClient.DoSessionAccept(Self,Request) then begin
          FState:=ssRinging;
          FClient.DoSessionRing(Self);
        end else begin
          ResponseBusyHere;
          FState:=ssDestroying;
        end;
      end;
    end else begin
      FClient.DoSessionContent(Self,Request.Body.Text);
      ResponseOK;
      FState:=ssConfirming;
    end;
  end;

  procedure ProcessAck;
  begin
    FState:=ssProcessing;
    FClient.DoSessionConfirm(Self);
  end;

  procedure ProcessBye;
  begin
    ResponseOK;
    FState:=ssDestroying;
    FClient.DoSessionTerminate(Self);
    FReadyForDestroy:=true;
  end;

  procedure ProcessCancel;
  begin
    ResponseOK;
    ResponseRequestTerminated;
    FState:=ssDestroying;
    FClient.DoSessionTerminate(Self);
    FReadyForDestroy:=true; // ???
  end;

  procedure Unsupported;
  begin
    ResponseForbidden;
    FState:=ssDestroying;
    FClient.DoSessionTerminate(Self);
    FReadyForDestroy:=true;
  end;

begin
  Result:=false;
  if Assigned(FClient) and Assigned(Request) and
     (FDirection in [sdIncoming,sdOutgoing]) then begin
    if Request.TryLock then begin
      try
        FClient.FWaits.LockRemoveBy(Request);
        FClient.DoSessionRequest(Self,Request);

        Requests.LockAdd(Request);
        
        case Request.RequestType of
          rtUNKNOWN,rtREGISTER: ;
          rtINVITE: begin
            if FState in [ssReady,ssProcessing] then begin
              ProcessInvite;
              Result:=true;
            end;
          end;
          rtACK: begin
            if FState in [ssConfirming,ssBreaking] then begin
              ProcessAck;
              Result:=true;
            end;
          end;
          rtBYE: begin
            if FState in [ssProcessing,ssWaiting] then begin
              ProcessBye;
              Result:=true;
            end;
          end;
          rtCANCEL: begin
            if FState in [ssRinging,ssProgressing] then begin
              ProcessCancel;
              Result:=true;
            end;
          end;
        end;

        if not Result then begin
          Requests.Lock;
          Requests.OwnsObjects:=false;
          try
            Requests.Remove(Request);
          finally
            Requests.OwnsObjects:=true;
            Requests.UnLock;
          end;
        end;

      finally
        Request.UnLock;
      end;
    end;
  end;
end;

function TBisSipSession.ReceiveResponse(Response: TBisSipResponse): Boolean;

  procedure RequestAck(Request: TBisSipRequest; NewBranch: Boolean=true);
  var
    AckRequest: TBisSipRequest;
    CSeq: TBisSipCSeq;
    Via: TBisSipVia;
  begin
    AckRequest:=TBisSipRequest.Create(rdOutgoing,rtACK,Request.Uri,FClient.Protocol);
    with AckRequest.Headers do begin
      if (Request.Direction=rdIncoming) then begin
        CopyFrom(Response.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
      end else begin
        if FState=ssBreaking then begin
          CopyFrom(Response.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
        end else begin
          if NewBranch then begin
            AddVia(FClient.Protocol,FClient.Transport.Name,FClient.LocalIP,IntToStr(FClient.LocalPort),GetBranch,'','');
            CopyFrom(Response.Headers,[TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
          end else begin
            CopyFrom(Response.Headers,[TBisSipVia,TBisSipFrom,TBisSipTo,TBisSipCallID,TBisSipCSeq]);
            Via:=TBisSipVia(Find(TBisSipVia));
            if Assigned(Via) then
              Via.Rport:='';
          end;
        end;
      end;
      CSeq:=TBisSipCSeq(Find(TBisSipCSeq));
      if Assigned(CSeq) then
        CSeq.RequestName:=AckRequest.Name;
      AddMaxForwards(IntToStr(FClient.FMaxForwards));  
      AddContentLength(IntToStr(AckRequest.Body.Length))
    end;
    SendRequest(AckRequest,nil,false);
  end;

  procedure ProcessBadRequest(Request: TBisSipRequest);
  begin
    // need something in response
    FState:=ssDestroying;
    FClient.DoSessionTerminate(Self);
  end;

  procedure ProcessTrying(Request: TBisSipRequest);
  begin
    FState:=ssTrying;
    FClient.DoSessionContent(Self,Response.Body.Text);
  end;

  procedure ProcessSessionProgress(Request: TBisSipRequest);
  begin
    FState:=ssProgressing;
    FClient.DoSessionProgress(Self);
    FClient.DoSessionContent(Self,Response.Body.Text);
  end;

  procedure ProcessRinging(Request: TBisSipRequest);
  begin
    FState:=ssRinging;
    FClient.DoSessionRing(Self);
    FClient.DoSessionContent(Self,Response.Body.Text);
  end;

  procedure ProcessOK(Request: TBisSipRequest);
  begin
    if FState in [ssProcessing,ssBreaking] then begin
      FState:=ssDestroying;
      FClient.DoSessionTerminate(Self);
      FReadyForDestroy:=true;
    end else begin
      if FClient.DoSessionAccept(Self,Response) then begin
        RequestAck(Request);
        FState:=ssProcessing;
        FClient.DoSessionConfirm(Self);
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
    FClient.DoSessionTerminate(Self);
    FReadyForDestroy:=true;
  end;

  procedure ProcessBusyHere(Request: TBisSipRequest);
  begin
//    RequestAck(Request);
    FState:=ssDestroying;
    FClient.DoSessionTerminate(Self);
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
        Authorization:=NewRequest.Headers.AddProxyAuthorization(FClient.FUserName,FClient.FPassword,Request.Name,Request.Uri);

      if Assigned(Authorization) then
        Authorization.CopyFrom(Authenticate);

      SendRequest(NewRequest,WaitProxyAuthorization,true);
    end;
  end;

  procedure ProcessProxyAuthenticationRequired(Request: TBisSipRequest);
  begin
    RequestAck(Request,false);
    RequestWithProxyAuthorization(Request);
    FState:=ssWaiting;
  end;

  procedure ProcessTemporarilyUnavailable(Request: TBisSipRequest);
  begin
    FState:=ssDestroying;
    FClient.DoSessionTerminate(Self);
    FReadyForDestroy:=true;
  end;

  procedure ProcessServiceUnavailable(Request: TBisSipRequest);
  begin
    FState:=ssDestroying;
    FClient.DoSessionTerminate(Self);
    FReadyForDestroy:=true;
  end;

var
  Request: TBisSipRequest;
  Flag: Boolean;
begin
  Result:=false;
  if Assigned(FClient) and Assigned(Response) then begin
    if Response.TryLock then begin
      try
        Request:=Requests.LockGetRequest(Response);
        if Assigned(Request) then begin
          if Request.TryLock then begin
            try
              FClient.FWaits.LockRemoveBy(Request);
              FClient.DoSessionResponse(Self,Request,Response);

              Flag:=ValidSequence(Response.CSeqNum);
              if Flag then begin

                case Response.ResponseKind of
                  rkTrying: begin
                    if FState=ssWaiting then begin
                      ProcessTrying(Request);
                      Result:=true;
                    end;
                  end;
                  rkSessionProgress: begin
                    if FState in [ssWaiting,ssTrying] then begin
                      ProcessSessionProgress(Request);
                      Result:=true;
                    end;
                  end;
                  rkRinging: begin
                    if FState in [ssWaiting,ssTrying,ssProgressing] then begin
                      ProcessRinging(Request);
                      Result:=true;
                    end;
                  end;
                  rkOK: begin
                    if FState in [ssRinging,ssWaiting,ssTrying,ssProcessing,ssProgressing,ssBreaking] then begin
                      ProcessOK(Request);
                      Result:=true;
                    end;
                  end;
                  rkRequestTerminated: begin
                    if FState=ssBreaking then begin
                      ProcessRequestTerminated(Request);
                      Result:=true;
                    end;
                  end;
                  rkBusyHere: begin
                    if FState=ssProgressing then begin
                      ProcessBusyHere(Request);
                      Result:=true;
                    end;
                  end;
                  rkBadRequest: begin
                    if FState=ssWaiting then begin
                      ProcessBadRequest(Request);
                      Result:=true;
                    end;
                  end;
                  rkForbidden: begin
            //        FClient.WaitRegister(Request);
                  end;
                  rkProxyAuthenticationRequired: begin
                    if FState=ssTrying then begin
                      ProcessProxyAuthenticationRequired(Request);
                      Result:=true;
                    end;
                  end;
                  rkTemporarilyUnavailable: begin
                    ProcessTemporarilyUnavailable(Request);
                    Result:=true;
                  end;
                  rkServiceUnavailable: begin
                    ProcessServiceUnavailable(Request);
                    Result:=true;
                  end;
                end;

                if Result then
                  Request.Responses.LockAdd(Response);
              end;
            finally
              Request.UnLock;
            end;
          end;
        end;
      finally
        Response.UnLock;
      end;
    end;
  end;
end;

{ TBisSipSessions }

constructor TBisSipSessions.Create(Client: TBisSipClient);
begin
  inherited Create;
  FClient:=Client;
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
    Result:=TBisSipSession.Create(FClient,Direction);
    Result.FID:=iff(Trim(ID)<>'',ID,GetUniqueID);
    inherited Add(Result);
  end;
end;

function TBisSipSessions.LockAdd(ID: String; Direction: TBisSipSessionDirection): TBisSipSession;
begin
  Lock;
  try
    Result:=Add(ID,Direction);
  finally
    UnLock;
  end;
end;

function TBisSipSessions.LockFindByMessage(Message: TBisSipMessage): TBisSipSession;
begin
  Lock;
  try
    Result:=FindByMessage(Message); 
  finally
    UnLock;
  end;
end;

{ TBisSipRequestWaitThread }

constructor TBisSipRequestWaitThread.Create(const TimeOut: Cardinal; Request: TBisSipRequest; Method: TBisSipRequestMethod);
begin
  inherited Create(TimeOut);
  FRequest:=Request;
  FMethod:=Method;
end;

destructor TBisSipRequestWaitThread.Destroy;
begin
  FRequest:=nil;
  FMethod:=nil;
  inherited Destroy;
end;

procedure TBisSipRequestWaitThread.DoMethod;
begin
  if Assigned(FMethod) then
    FMethod(FRequest);
end;

{ TBisSipRequestWaitThreads }

procedure TBisSipRequestWaitThreads.DoItemFree(Item: TObject);
{var
  Thread: TBisSipRequestWaitThread;}
begin
  if Assigned(Item) and (Item is TBisSipRequestWaitThread) then begin
  {  Thread:=TBisSipRequestWaitThread(Item);
    Thread.Lock;
    try
      Thread.FRequest:=nil;
      Thread.FMethod:=nil;
    finally
      Thread.UnLock;
    end; }
  end;
end;

function TBisSipRequestWaitThreads.GetItem(Index: Integer): TBisSipRequestWaitThread;
begin
  Result:=TBisSipRequestWaitThread(inherited Items[Index]);
end;

procedure TBisSipRequestWaitThreads.ThreadEnd(Thread: TBisThread; const AException: Exception);
begin
  if Assigned(Self) then begin
    if Assigned(FOnEnd) then
      FOnEnd(Thread,AException);
    Self.LockRemove(Thread);
  end;
end;

function TBisSipRequestWaitThreads.LockAdd(Request: TBisSipRequest; Method: TBisSipRequestMethod): TBisSipRequestWaitThread;
begin
  Lock;
  try
    Result:=TBisSipRequestWaitThread.Create(FTimeOut,Request,Method);
    Result.OnTimeout:=FOnTimeOut;
    Result.OnEnd:=ThreadEnd;
    inherited Add(Result);
  finally
    UnLock;
  end;
end;

procedure TBisSipRequestWaitThreads.LockRemoveBy(Method: TBisSipRequestMethod);
var
  i: Integer;
  Item: TBisSipRequestWaitThread;
begin
  Lock;
  try
    for i:=Count-1 downto 0 do begin
      Item:=TBisSipRequestWaitThread(Items[i]);
      if @Item.FMethod=@Method then
        Remove(Item);
    end;
  finally
    UnLock;
  end;
end;

procedure TBisSipRequestWaitThreads.LockRemoveBy(Request: TBisSipRequest);
var
  i: Integer;
  Item: TBisSipRequestWaitThread;
begin
  Lock;
  try
    for i:=Count-1 downto 0 do begin
      Item:=TBisSipRequestWaitThread(Items[i]);
      if Item.FRequest=Request then
        Remove(Item);
    end;
  finally
    UnLock;
  end;
end;

type
  TBisSipRegisterThread=class(TBisWaitThread)
  end;

  TBisSipKeepAliveThread=class(TBisWaitThread)
  end;

{ TBisSipClient }

constructor TBisSipClient.Create;
begin
  inherited Create;
  Requests.MaxCount:=100;

  FScheme:=DefaultScheme;
  FProtocol:=DefaultProtocol;

  FTransport:=TBisSipTransport.Create(Self);

  FWaits:=TBisSipRequestWaitThreads.Create;
  FWaits.FOnTimeOut:=WaitsTimeOut;
  FWaits.FOnEnd:=WaitsEnd;
  FWaits.FTimeOut:=3000;

  FSessions:=TBisSipSessions.Create(Self);

  FRegisterThread:=TBisSipRegisterThread.Create;
  FRegisterThread.Timeout:=3600*1000;
  FRegisterThread.RestrictByZero:=true;
  FRegisterThread.OnTimeout:=RegisterThreadTimeout;

  FKeepAliveThread:=TBisSipKeepAliveThread.Create;
  FKeepAliveThread.Timeout:=30*000;
  FKeepAliveThread.RestrictByZero:=true;
  FKeepAliveThread.OnTimeout:=KeepAliveThreadTimeout;
  

  FQ:='0.9';
  FMaxForwards:=70;
  FSequence:=0;
  FKeepAliveQuery:=#13#10#13#10;
  FWaitRetryCount:=5;
  FUseGlobalSequence:=false;

end;

destructor TBisSipClient.Destroy;
begin
  FKeepAliveThread.Free;
  FRegisterThread.Free;
  FSessions.Free;
  FWaits.Free;
  FreeAndNilEx(FTransport);
  inherited Destroy;
end;

procedure TBisSipClient.RegisterThreadTimeout(Thread: TBisWaitThread);
begin
  try

    WaitRegister(nil);
  finally
    Thread.Reset;
  end;
end;

procedure TBisSipClient.KeepAliveThreadTimeout(Thread: TBisWaitThread);
begin
  try
    if FRegistered and (FState=csDefault) then
      FTransport.Send(FRemoteIP,FRemotePort,FKeepAliveQuery);
  finally
    Thread.Reset;
  end;
end;

procedure TBisSipClient.RemoveWaits(Session: TBisSipSession);
var
  i: Integer;
  Request: TBisSipRequest; 
begin
  if Assigned(Session) then begin
    Session.Requests.Lock;
    try
      for i:=Session.Requests.Count-1 downto 0 do begin
        Request:=Session.Requests.Items[i];
        Request.Lock;
        try
          FWaits.LockRemoveBy(Request);
        finally
          Request.UnLock;
        end;
      end;
    finally
      Session.Requests.UnLock;
    end;
  end;
end;

procedure TBisSipClient.DoSend(Host: String; Port: Integer; Data: String);
begin
  if Assigned(FOnSend) then
    FOnSend(Self,Host,Port,Data);
end;

function TBisSipClient.DoSessionAccept(Session: TBisSipSession; Message: TBisSipMessage): Boolean;
begin
  Result:=true;
  if Assigned(FOnSessionAccept) then
    Result:=FOnSessionAccept(Self,Session,Message);
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

procedure TBisSipClient.DoSessionRequest(Session: TBisSipSession; Request: TBisSipRequest);
begin
  if Assigned(FOnSessionRequest) then
    FOnSessionRequest(Self,Session,Request);
end;

procedure TBisSipClient.DoSessionResponse(Session: TBisSipSession; Request: TBisSipRequest; Response: TBisSipResponse);
begin
  if Assigned(FOnSessionResponse) then
    FOnSessionResponse(Self,Session,Request,Response);
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

procedure TBisSipClient.DoTimeout(var Interrupted: Boolean);
begin
  if Assigned(FOnTimeout) then
    FOnTimeout(Self,Interrupted);
end;

procedure TBisSipClient.DoSessionConfirm(Session: TBisSipSession);
begin
  if Assigned(FOnSessionConfirm) then
    FOnSessionConfirm(Self,Session);
end;

procedure TBisSipClient.DoReceive(Host: String; Port: Integer; Data: String);
begin
  if Assigned(FOnReceive) then
    FOnReceive(Self,Host,Port,Data);
end;

procedure TBisSipClient.DoRegister;
begin
  if Assigned(FOnRegister) then
    FOnRegister(Self);
end;

procedure TBisSipClient.DoError(const Error: String);
begin
  if Assigned(FOnError) then
    FOnError(Self,Error);
end;

function TBisSipClient.GetTransportName: String;
begin
  Result:=FTransport.Name;
end;

function TBisSipClient.NextSequence: String;
begin
  Lock;
  try
    Inc(FSequence);
    Result:=IntToStr(FSequence);
  finally
    UnLock;
  end;
end;

function TBisSipClient.GetExpires: Cardinal;
begin
  Result:=FRegisterThread.Timeout div 1000;
end;

function TBisSipClient.GetKeepAliveInterval: Cardinal;
begin
  Result:=FKeepAliveThread.Timeout;
end;

procedure TBisSipClient.SetExpires(const Value: Cardinal);
begin
  FRegisterThread.Timeout:=Value*1000;
end;

procedure TBisSipClient.SetKeepAliveInterval(const Value: Cardinal);
begin
  FKeepAliveThread.Timeout:=Value;
end;

procedure TBisSipClient.SetWaitTimeOut(const Value: Cardinal);
begin
  FWaits.FTimeOut:=Value;
end;

function TBisSipClient.GetWaitTimeOut: Cardinal;
begin
  Result:=FWaits.FTimeOut;
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

procedure TBisSipClient.WaitsEnd(Thread: TBisThread; const AException: Exception);
begin
  if Assigned(AException) then
    DoError(AException.Message);
end;

procedure TBisSipClient.WaitsTimeOut(Thread: TBisWaitThread);
var
  Wait: TBisSipRequestWaitThread;
  Interrupted: Boolean;
  Data: String;
begin
  try
    if Assigned(Thread) and (Thread is TBisSipRequestWaitThread) then begin
      Wait:=TBisSipRequestWaitThread(Thread);
      if Assigned(Wait.FRequest) then begin
        Data:=Wait.FRequest.AsString;
        Interrupted:=Wait.Counter>=FWaitRetryCount;
        DoTimeout(Interrupted);
        if not Interrupted then begin
          if Assigned(FTransport) and FTransport.Send(FRemoteIP,FRemotePort,Data) then
            Wait.Reset;
        end else
          Wait.DoMethod;
      end;
    end;
  except
    on E: Exception do
      DoError(E.Message);
  end;
end;

procedure TBisSipClient.SendRequest(Request: TBisSipRequest; Method: TBisSipRequestMethod; WithWait: Boolean; WithAdd: Boolean);
begin
  if Assigned(Request) then begin
    if WithAdd then
      Requests.LockAdd(Request);
    if FTransport.Send(FRemoteIP,FRemotePort,Request.AsString) and WithWait then
      FWaits.LockAdd(Request,Method).Start;
  end;
end;

procedure TBisSipClient.SendResponse(Response: TBisSipResponse);
begin
  if Assigned(Response) then
    FTransport.Send(FRemoteIP,FRemotePort,Response.AsString);
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
        FReceived:=ResponseVia.Received;
        if FUseReceived and (Trim(FReceived)<>'') then begin
          Contact.Host:=FReceived;
          FLocalIP:=FReceived;
        end;
        if FUseRport and (Trim(ResponseVia.Rport)<>'') then begin
          FLocalPort:=StrToIntDef(ResponseVia.Rport,FLocalPort);
        end;
      end;

      NewRequest:=TBisSipRequest.Create(rdOutgoing,Request.RequestType,Request);
      NewRequest.CSeqNum:=NextSequence;

      Via:=TBisSipVia(NewRequest.Headers.Find(TBisSipVia));
      if Assigned(Via) then
        Via.Host:=FLocalIP;

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

      SendRequest(NewRequest,WaitRegister,true,true);
    end;
  end;

var
  Request: TBisSipRequest;
begin
  Result:=false;
  if Assigned(Response) then begin
    if Response.TryLock then begin
      try
        Request:=Requests.LockGetRequest(Response);
        if Assigned(Request) and (Request.RequestType=rtREGISTER) then begin
          if Request.TryLock then begin
            try
              FWaits.LockRemoveBy(Request);
              Result:=StrToIntDef(Response.CSeqNum,0)>=FSequence;
              if Result then begin
                Request.Responses.LockAdd(Response);
                case Response.ResponseKind of
                  rkUnauthorized: begin
                    if FRegistered and (FState in [csUnRegistering]) then begin
                      Terminate;
                    end;
                    ProcessUnauthorized(Request);
                  end;
                  rkOK: begin
                    if not FRegistered then begin
                      if (FState in [csRegistering]) then begin
                        FRegisterThread.Start;
                        FKeepAliveThread.Start;
                        FRegistered:=true;
                        FState:=csDefault;
                        DoRegister;
                      end;
                    end else begin
                      FRegisterThread.Start;
                      FKeepAliveThread.Start;
                      FState:=csDefault;
                      DoRegister;
                    end;
                  end;
                  rkForbidden: begin
                   // Register(true);
                  end;
                end;
              end;
            finally
              Request.UnLock;
            end;
          end;
        end;
      finally
        Response.UnLock;
      end;
    end;
  end;
end;

procedure TBisSipClient.WaitRegister(Request: TBisSipRequest);
var
  Flag: Boolean;
begin
  Flag:=true;

  if Assigned(Request) then
    if Request.RequestType=rtREGISTER then
      Flag:=FState in [csDefault,csRegistering];

  Register(Flag);
end;

procedure TBisSipClient.WaitUnRegister(Request: TBisSipRequest);
begin
  Terminate;
end;

procedure TBisSipClient.Register(Active: Boolean; Initial: Boolean=false);
var
  Request: TBisSipRequest;
  Method: TBisSipRequestMethod;
begin
  if Initial then
    FSequence:=0;

  FRegisterThread.Stop;
  FKeepAliveThread.Stop;
  FTransport.Active:=true;

  Method:=nil;
  Request:=TBisSipRequest.Create(rdOutgoing,TBisSipRequest.RequestTypeToName(rtREGISTER),
                                 FScheme,'',FRemoteHost,'',FProtocol,UriTransportName);
  if Active then begin
    with Request do begin
      with Headers do begin
        AddVia(FProtocol,Self.FTransport.Name,FLocalIP,IntToStr(FLocalPort),GetBranch,'','');
        AddFrom('',FScheme,FUserName,FRemoteHost,UriRemotePort,GetTag,'','',UriTransportName); //???
        AddTo('',FScheme,FUserName,FRemoteHost,UriRemotePort,'','','',UriTransportName);//???
        AddCallID(FID);
        AddCSeq(NextSequence,Request.Name);
        AddContact('',FScheme,FUserName,FLocalIP,UriLocalPort,'',IntToStr(Expires),FQ,'','',UriTransportName); //???
        AddUserAgent(FUserAgent);
        AddAllow([atINVITE,atACK,atBYE,atCANCEL]);
        AddMaxForwards(IntToStr(FMaxForwards));
        AddExpires(IntToStr(Expires));
        AddContentLength(IntToStr(Body.Length));
      end;
    end;
    FState:=csRegistering;
    Method:=WaitRegister;
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
    FState:=csUnRegistering;
    Method:=WaitUnRegister;
  end;
  SendRequest(Request,Method,true,true);
end;

procedure TBisSipClient.Terminate;
begin
  if FState in [csRegistering,csUnRegistering] then begin
    FRegisterThread.Stop;
    FKeepAliveThread.Stop;
    FWaits.LockClear;
    FSessions.LockClear;
    FTransport.Active:=false;
    FRegistered:=false;
    FState:=csDefault;
    DoRegister;
  end;
end;

end.
