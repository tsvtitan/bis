unit BisSip;

interface

uses Classes, Contnrs, SyncObjs;

type

  TBisSipHeader=class(TObject)
  protected
    class function GetName: String; virtual;
    procedure Parse(const Body: String); virtual;
    function AsString: String; virtual;
    procedure CopyFrom(Source: TBisSipHeader); virtual;
    function Empty: Boolean; virtual;
    function NameEqual: String; virtual;
  public
    constructor Create;

    property Name: String read GetName;
  end;

  TBisSipHeaderClass=class of TBisSipHeader;

  TBisSipSimple=class(TBisSipHeader)
  private
    FValue: String;
  public
    procedure Parse(const Body: String); override;
    function AsString: String; override;
    procedure CopyFrom(Source: TBisSipHeader); override;

    function AsInteger: Integer;

    property Value: String read FValue;
  end;

  TBisSipVia=class(TBisSipHeader)
  private
    FProtocol, FTransport, FHost, FPort: String;
    FRport, FBranch, FReceived: String;
  protected
    class function GetName: String; override;
  public
    procedure Parse(const Body: String); override;
    function AsString: String; override;
    procedure CopyFrom(Source: TBisSipHeader); override;
  end;

  TBisSipFrom=class(TBisSipHeader)
  private
    FDisplay, FScheme, FUser, FHost, FPort: String;
    FTag, FExpires, FQ: String;
    FUriUser, FUriCpc, FUriTransport: String;
    function HeadersAsString: String;
    function GetUri: String;
  protected
    class function GetName: String; override;
  public
    procedure Parse(const Body: String); override;
    function AsString: String; override;
    procedure CopyFrom(Source: TBisSipHeader); override;
    function Empty: Boolean; override;

    property Display: String read FDisplay;
    property User: String read FUser;
    property Uri: String read GetUri;
  end;

  TBisSipTo=class(TBisSipFrom)
  protected
    class function GetName: String; override;
  end;

  TBisSipContact=class(TBisSipFrom)
  protected
    class function GetName: String; override;
  end;

  TBisSipPAssertedIdentity=class(TBisSipFrom)
  protected
    class function GetName: String; override;
  end;

  TBisSipCallID=class(TBisSipSimple)
  protected
    class function GetName: String; override;
  end;

  TBisSipPrivacy=class(TBisSipSimple)
  protected
    class function GetName: String; override;
  end;

  TBisSipCSeq=class(TBisSipHeader)
  private
    FNum, FRequestName: String;
  protected
    class function GetName: String; override;
  public
    procedure Parse(const Body: String); override;
    function AsString: String; override;
    procedure CopyFrom(Source: TBisSipHeader); override;

    property Num: String read FNum write FNum;
    property RequestName: String read FRequestName write FRequestName;
  end;

  TBisSipReason=class(TBisSipHeader)
  private
    FValue, FCause, FText: String;
  protected
    class function GetName: String; override;
  public
    procedure Parse(const Body: String); override;
    procedure CopyFrom(Source: TBisSipHeader); override;
  end;

  TBisSipOrganization=class(TBisSipSimple)
  protected
    class function GetName: String; override;
  end;

  TBisSipUserAgent=class(TBisSipSimple)
  protected
    class function GetName: String; override;
  end;

  TBisSipSubject=class(TBisSipSimple)
  protected
    class function GetName: String; override;
  end;
  
  TBisSipAllowType=(atINVITE,atACK,atBYE,atCANCEL,atINFO,atMESSAGE,atPRACK,atUPDATE,atOPTIONS,atREGISTER,atREFER,atSUBSCRIBE);
  TBisSipAllowTypes=set of TBisSipAllowType;

  TBisSipAllow=class(TBisSipHeader)
  private
    FTypes: TBisSipAllowTypes;
    function GetStringByType(AllowType: TBisSipAllowType): String;
  protected
    class function GetName: String; override;
  public
    function AsString: String; override;
    procedure CopyFrom(Source: TBisSipHeader); override;
  end;

  TBisSipMaxForwards=class(TBisSipSimple)
  protected
    class function GetName: String; override;
  end;

  TBisSipExpires=class(TBisSipSimple)
  protected
    class function GetName: String; override;
  end;

  TBisSipContentTypeKind=(ctkUnknown,ctkApplicationSdp);

  TBisSipContentType=class(TBisSipSimple)
  private
    function GetKind: TBisSipContentTypeKind;
  protected
    class function GetName: String; override;
  public
    class function NameToKind(Name: String): TBisSipContentTypeKind;
    class function KindToName(Kind: TBisSipContentTypeKind): String;
    
    property Kind: TBisSipContentTypeKind read GetKind;
  end;

  TBisSipContentLength=class(TBisSipSimple)
  protected
    class function GetName: String; override;
  end;

  TBisSipContentDisposition=class(TBisSipHeader)
  private
    FValue, FHandling: String;
  protected
    class function GetName: String; override;
  public
    procedure Parse(const Body: String); override;
    procedure CopyFrom(Source: TBisSipHeader); override;
  end;

  TBisSipAuthenticateAlgorithmType=(aatUnknown,aatMD5);

  TBisSipWWWAuthenticate=class(TBisSipHeader)
  private
    FAuthorization, FRealm, FNonce, FOpaque, FAlgorithm, FQop: String;
  protected
    class function GetName: String; override;
  public
    procedure Parse(const Body: String); override;
    procedure CopyFrom(Source: TBisSipHeader); override;
  end;

  TBisSipProxyAuthenticate=class(TBisSipHeader)
  private
    FAuthorization, FRealm, FNonce, FOpaque, FAlgorithm, FQop: String;
  protected
    class function GetName: String; override;
  public
    procedure Parse(const Body: String); override;
    procedure CopyFrom(Source: TBisSipHeader); override;
  end;

  TBisSipAuthorization=class(TBisSipHeader)
  private
    FUserName, FPassword, FRequestName, FUri: String;
    FAuthorization, FRealm, FNonce: String;
    FQop, FCnonce, FOpaque: String;
    FAlgorithm, FNC: String;
    function GetAlgorithmType: TBisSipAuthenticateAlgorithmType;
  protected
    class function GetName: String; override;
  public
    class function AlgorithmTypeToName(AlgorithmType: TBisSipAuthenticateAlgorithmType): String;
    class function AlgorithmNameToType(Algorithm: String): TBisSipAuthenticateAlgorithmType;
    procedure CopyFrom(Source: TBisSipHeader); override;
    function AsString: String; override;

    property AlgorithmType: TBisSipAuthenticateAlgorithmType read GetAlgorithmType;

    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property RequestName: String read FRequestName write FRequestName;
    property Uri: String read FUri write FUri; 
    property Realm: String read FRealm write FRealm; 
    property Nonce: String read FNonce write FNonce;
    property Qop: String read FQop write FQop;
    property Cnonce: String read FCnonce write FCnonce;
    property Opaque: String read FOpaque write FOpaque;
    property Algorithm: String read FAlgorithm write FAlgorithm;
    property NC: String read FNC write FNC; 
  end;

  TBisSipProxyAuthorization=class(TBisSipAuthorization)
  protected
    class function GetName: String; override;
  end;

  TBisSipSupported=class(TBisSipSimple)
  protected
    class function GetName: String; override;
  end;

  TBisSipDate=class(TBisSipSimple)
  protected
    class function GetName: String; override;
  end;

  TBisSipAllowEvents=class(TBisSipSimple)
  protected
    class function GetName: String; override;
  end;

  TBisSipXFSSupport=class(TBisSipSimple)
  protected
    class function GetName: String; override;
  end;

  TBisSipHeaders=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisSipHeader;
  public
    function Find(AClass: TBisSipHeaderClass): TBisSipHeader; overload;
    procedure GetStrings(Strings: TStrings);

    function Add(AClass: TBisSipHeaderClass): TBisSipHeader;
    function AddVia(Protocol, Transport, Host, Port, Branch, RPort, Received: String): TBisSipVia;
    function AddFrom(Display, Scheme, User, Host, Port, Tag, UriUser, UriCpc, UriTransport: String): TBisSipFrom;
    function AddTo(Display, Scheme, User, Host, Port, Tag, UriUser, UriCpc, UriTransport: String): TBisSipTo;
    function AddContact(Display, Scheme, User, Host, Port, Tag, Expires, Q,
                        UriUser, UriCpc, UriTransport: String): TBisSipContact; overload;
    function AddContact: TBisSipContact; overload;
    function AddCallID(Value: String): TBisSipCallID;
    function AddCSeq(Num, RequestName: String): TBisSipCSeq;
    function AddUserAgent(Value: String): TBisSipUserAgent;
    function AddAllow(Types: TBisSipAllowTypes): TBisSipAllow;
    function AddMaxForwards(Value: String): TBisSipMaxForwards;
    function AddExpires(Value: String): TBisSipExpires;
    function AddContentType(Value: String): TBisSipContentType; overload;
    function AddContentType(Kind: TBisSipContentTypeKind): TBisSipContentType; overload;
    function AddContentLength(Value: String): TBisSipContentLength;
    function AddAuthorization(Username, Password, RequestName, Uri: String): TBisSipAuthorization;
    function AddProxyAuthorization(Username, Password, RequestName, Uri: String): TBisSipProxyAuthorization;

    function ParseHeader(const Line: String): TBisSipHeader;

    procedure CopyFrom(Source: TBisSipHeaders; WithClear: Boolean=true); overload;
    procedure CopyFrom(Source: TBisSipHeaders; AClasses: array of TBisSipHeaderClass); overload;

    property Items[Index: Integer]: TBisSipHeader read GetItem; default;
  end;

  TBisSipBody=class(TStringList)
  public
    function AsString: String;
    function Length: Integer;
  end;

  TBisSipMessage=class(TObject)
  private
    FHeaders: TBisSipHeaders;
    FBody: TBisSipBody;
    function GetCSeqNum: String;
    procedure SetCSeqNum(const Value: String);
  protected
    procedure GetHeader(Strings: TStrings); virtual;
    procedure GetBody(Strings: TStrings); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisSipMessage); virtual;

    function AsString: String;

    property Headers: TBisSipHeaders read FHeaders;
    property Body: TBisSipBody read FBody;

    property CSeqNum: String read GetCSeqNum write SetCSeqNum;
  end;

  TBisSipMessageClass=class of TBisSipMessage;

  TBisSipResponseKind=(rkUnknown,

                       rkTrying,rkRinging,rkCallIsBeingForwarded,rkQueued,rkSessionProgress,

                       rkOK,rkAccepted,

                       rkMultipleChoices,rkMovedPermanently,rkMovedTemporarily,rkUseProxy,rkAlternativeService,

                       rkBadRequest,rkUnauthorized,rkPaymentRequired,rkForbidden,rkNotFound,rkMethodNotAllowed,rkNotAcceptableClient,
                       rkProxyAuthenticationRequired,rkRequestTimeout,rkGone,rkRequestEntityTooLarge,rkRequestURITooLarge,
                       rkUnsupportedMediaType,rkUnsupportedURIScheme,rkBadExtension,rkExtensionRequired,rkIntervalTooBrief,
                       rkTemporarilyUnavailable,rkCallLegOrTransactionDoesNotExist,rkLoopDetected,rkTooManyHops,rkAddressIncomplete,
                       rkAmbiguous,rkBusyHere,rkRequestTerminated,rkNotAcceptableHere,rkBadEvent,rkRequestPending,rkUndecipherable,

                       rkInternalServerError,rkNotImplemented,rkBadGateway,rkServiceUnavailable,rkServerTimeOut,
                       rkSIPVersionNotSupported,rkMessageTooLarge,

                       rkBusyEverywhere,rkDecline,rkDoesNotExistAnywhere,rkNotAcceptableGlobal);

  TBisSipResponse=class(TBisSipMessage)
  private
    FCode: String;
    FProtocol: String;
    FDescription: String;
    function GetResponseKind: TBisSipResponseKind;
  protected
    procedure GetHeader(Strings: TStrings); override;
  public
    constructor Create(Protocol, Code, Description: String); reintroduce;

    property ResponseKind: TBisSipResponseKind read GetResponseKind;

  end;

  TBisSipMessages=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisSipMessage;
  public
    constructor Create; virtual;

    property Items[Index: Integer]: TBisSipMessage read GetItem; default;
  end;

  TBisSipResponses=class(TBisSipMessages)
  private
    function GetItem(Index: Integer): TBisSipResponse;
  public
    procedure Add(Response: TBisSipResponse);
    function FindByKind(ResponseKind: TBisSipResponseKind): TBisSipResponse;

    property Items[Index: Integer]: TBisSipResponse read GetItem; default;
  end;

  TBisSipRequestType=(rtUNKNOWN,rtREGISTER,rtINVITE,rtACK,rtBYE,rtCANCEL);
  TBisSipRequestTypes=type of TBisSipRequestType;
  TBisSipRequestDirection=(rdIncoming,rdOutgoing);

  TBisSipRequest=class(TBisSipMessage)
  private
    FName: String;
    FScheme, FUser, FHost, FPort, FProtocol: String;
    FTransport: String;
    FResponses: TBisSipResponses;
    FDirection: TBisSipRequestDirection;
    function GetUri: String;
    function GetRequestType: TBisSipRequestType;
  protected
    procedure GetHeader(Strings: TStrings); override;
  public
    constructor Create; overload; override;
    constructor Create(Direction: TBisSipRequestDirection; RequestType: TBisSipRequestType; Request: TBisSipRequest;
                       WithHeaders: Boolean=true; WithBody: Boolean=true); reintroduce; overload;
    constructor Create(Direction: TBisSipRequestDirection; Name, Scheme, User, Host, Port, Protocol, Transport: String); reintroduce; overload;
    constructor Create(Direction: TBisSipRequestDirection; RequestType: TBisSipRequestType; Scheme, User, Host, Port, Protocol, Transport: String); reintroduce; overload;
    constructor Create(Direction: TBisSipRequestDirection; Name, Uri, Protocol: String); reintroduce; overload;
    constructor Create(Direction: TBisSipRequestDirection; RequestType: TBisSipRequestType; Uri, Protocol: String); reintroduce; overload;
    destructor Destroy; override;
    class function RequestTypeToName(&Type: TBisSipRequestType): String;
    class function RequestNameToType(Name: String; var &Type: TBisSipRequestType): Boolean;
    procedure CopyFrom(Source: TBisSipMessage); override;

    property Name: String read FName;
    property Uri: String read GetUri;
    property RequestType: TBisSipRequestType read GetRequestType;
    property Responses: TBisSipResponses read FResponses;
    property Direction: TBisSipRequestDirection read FDirection;

  end;

  TBisSipRequests=class(TBisSipMessages)
  private
    function GetItem(Index: Integer): TBisSipRequest;
  public
    procedure Add(Request: TBisSipRequest);
    function FindBy(Sequence,RequestName: String): TBisSipRequest;
    function FindByType(RequestType: TBisSipRequestType): TBisSipRequest;
    function GetRequest(Response: TBisSipResponse): TBisSipRequest;
    function Exists(Request: TBisSipRequest): Boolean;

    property Items[Index: Integer]: TBisSipRequest read GetItem; default;
  end;

  TBisSipTimer=class;

  TBisSipTimerEvent=procedure(Sender: TBisSipTimer) of object;

  TBisSipTimer=class(TThread)
  private
    FInterval: Integer;
    FOnTimer: TBisSipTimerEvent;
    FData: TObject;
    procedure DoTimer;
  public
    constructor Create(Interval: Integer; OnTimer: TBisSipTimerEvent);
    destructor Destroy; override;
    procedure Execute; override;
    procedure Terminate;

    property Data: TObject read FData;
  end;

  TBisSipTimers=class(TObjectList)
  private
    FLock: TCriticalSection;
    function GetItem(Index: Integer): TBisSipTimer;
    procedure TimerTerminate(Sender: TObject);
    procedure TerminateAll;
  public
    constructor Create;
    destructor Destroy; override;

    function AddMilliSeconds(MilliSeconds: Integer; OnTimer: TBisSipTimerEvent; Data: TObject=nil): TBisSipTimer;
    function AddSeconds(Seconds: Integer; OnTimer: TBisSipTimerEvent; Data: TObject=nil): TBisSipTimer;
    function AddMinutes(Minutes: Integer; OnTimer: TBisSipTimerEvent; Data: TObject=nil): TBisSipTimer;

    procedure RemoveBy(OnTimer: TBisSipTimerEvent; Data: TObject=nil);

    property Items[Index: Integer]: TBisSipTimer read GetItem; default;
  end;

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
//    FTransport: String;
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

  TBisSipRegistrar=class;

  TBisSipSessionState=(ssReady,ssWaiting,ssRinging,ssConfirming,ssBreaking,ssProcessing,ssTrying,ssProgressing,ssDestroying);

  TBisSipSessionDirection=(sdUnknown,sdIncoming,sdOutgoing);

  TBisSipSession=class(TBisSipReceiver)
  private
    FRequests: TBisSipRequests;
    FRegistrar: TBisSipRegistrar;
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
    constructor Create(Registrar: TBisSipRegistrar; Direction: TBisSipSessionDirection); reintroduce;
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
    FRegistrar: TBisSipRegistrar;
    function GetSession(Index: Integer): TBisSipSession;
  public
    constructor Create(Registrar: TBisSipRegistrar); reintroduce;
    function FindByID(ID: String): TBisSipSession; reintroduce;
    function Add(ID: String; Direction: TBisSipSessionDirection): TBisSipSession; overload;
    function Add(Direction: TBisSipSessionDirection): TBisSipSession; overload;

    property Items[Index: Integer]: TBisSipSession read GetSession; default;
  end;

  TBisSipMessageWait=class(TThread)
  private
    FTimeOut: Integer;
    FOnTimeOut: TNotifyEvent;
    FMessage: TBisSipMessage;
    FCounter: Integer;
//    FInterrupted: Boolean;
    procedure DoTimeOut;
  public
    constructor Create(TimeOut: Integer; Message: TBisSipMessage);
    destructor Destroy; override;
    procedure Execute; override;
    procedure Terminate;

    property Counter: Integer read FCounter;
  end;

  TBisSipMessageWaits=class(TObjectList)
  private
    FOnTimeOut: TNotifyEvent;
    FOnTerminate: TNotifyEvent;
    FLock: TCriticalSection;
    function GetItem(Index: Integer): TBisSipMessageWait;
    procedure TerminateAll;
  protected
    property Items[Index: Integer]: TBisSipMessageWait read GetItem; default;

    property OnTimeOut: TNotifyEvent read FOnTimeOut write FOnTimeOut;
    property OnTerminate: TNotifyEvent read FOnTerminate write FOnTerminate;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(TimeOut: Integer; Message: TBisSipMessage; Counter: Integer=0): TBisSipMessageWait;
    procedure RemoveBy(Message: TBisSipMessage);
  end;

  TBisSipRegistrarEvent=procedure (Sender: TBisSipRegistrar) of object;
  TBisSipRegistrarAcceptEvent=function (Sender: TBisSipRegistrar; Session: TBisSipSession; Message: TBisSipMessage): Boolean of object;
  TBisSipRegistrarSessionEvent=procedure (Sender: TBisSipRegistrar; Session: TBisSipSession) of object;
  TBisSipRegistrarAliveEvent=function (Sender: TBisSipRegistrar; Session: TBisSipSession): Boolean of object;

  TBisSipRegistrar=class(TBisSipReceiver)
  private
    FScheme, FProtocol: String;
    FRemoteHost: String;
    FRemotePort: Integer;
    FRemoteIP: String;
    FLocalIP: String;
    FLocalPort: Integer;
//    FLocalHost: String;
    FUserName: String;
    FPassword: String;
    FExpires: Integer;
    FQ: String;
    FUserAgent: String;
    FSequence: Integer;
    FTransport: TBisSipTransport;
    FRequests: TBisSipRequests;
    FMaxForwards: Integer;
    FOnRegister: TBisSipRegistrarEvent;
    FRegistered: Boolean;
    FWaitRetryCount: Integer;
    FWaitTimeOut: Integer;
    FUseRport: Boolean;
    FKeepAliveQuery: String;
    FSessionIdleTimeOut: Integer;
    FSessionAlive: Integer;

    FLastRequest: TBisSipRequest;
    FOnWaitTimeOut: TBisSipRegistrarEvent;
    FWaits: TBisSipMessageWaits;
    FSessions: TBisSipSessions;
    FKeepAlive: Integer;
    FUseReceived: Boolean;
    FTimers: TBisSipTimers;

    FOnSessionRing: TBisSipRegistrarSessionEvent;
    FOnSessionProgress: TBisSipRegistrarSessionEvent;
    FOnSessionCreate: TBisSipRegistrarSessionEvent;
    FOnSessionDestroy: TBisSipRegistrarSessionEvent;
    FOnSessionConfirm: TBisSipRegistrarSessionEvent;
    FOnSessionTerminate: TBisSipRegistrarSessionEvent;
    FOnSessionAccept: TBisSipRegistrarAcceptEvent;
    FOnSessionAlive: TBisSipRegistrarAliveEvent;
    FUseTrasnportNameInUri: Boolean;
    FUsePortInUri: Boolean;
    FUseGlobalSequence: Boolean;

    procedure SendRequest(Request: TBisSipRequest; WithWait: Boolean=true);
    procedure SendResponse(Response: TBisSipResponse; WithWait: Boolean=false);
    procedure SetTransport(const Value: TBisSipTransport);
    procedure WaitsTimeOut(Sender: TObject);
    procedure WaitsTerminate(Sender: TObject);
    procedure AddReceiver(Receiver: TBisSipReceiver);
    procedure RemoveReceiver(Receiver: TBisSipReceiver);
    procedure RemoveWaits(Session: TBisSipSession);
    function GetTransportName: String;
    procedure RegisterTimer(Sender: TBisSipTimer);
    procedure KeepAliveTimer(Sender: TBisSipTimer);
    procedure SessionTimer(Sender: TBisSipTimer);
    procedure FirstRegister(Request: TBisSipRequest=nil);
    function GetUri: String;
  protected
    function ReceiveRequest(Request: TBisSipRequest): Boolean; override;
    function ReceiveResponse(Response: TBisSipResponse): Boolean; override;
    procedure DoRegister; virtual;
    procedure DoWaitTimeOut; virtual;
    procedure DoSessionCreate(Session: TBisSipSession); virtual;
    procedure DoSessionDestroy(Session: TBisSipSession); virtual;
    function DoSessionAccept(Session: TBisSipSession; Message: TBisSipMessage): Boolean; virtual;
    procedure DoSessionRing(Session: TBisSipSession); virtual;
    procedure DoSessionProgress(Session: TBisSipSession); virtual;
    procedure DoSessionConfirm(Session: TBisSipSession); virtual;
    procedure DoSessionTerminate(Session: TBisSipSession); virtual;
    function DoSessionAlive(Session: TBisSipSession): Boolean; virtual;
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
//    property LocalHost: String read FLocalHost write FLocalHost;
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
    property WaitRetryCount: Integer read FWaitRetryCount write FWaitRetryCount;
    property WaitTimeOut: Integer read FWaitTimeOut write FWaitTimeOut;
    property SessionAlive: Integer read FSessionAlive write FSessionAlive;
    property SessionIdleTimeOut: Integer read FSessionIdleTimeOut write FSessionIdleTimeOut;

    property OnRegister: TBisSipRegistrarEvent read FOnRegister write FOnRegister;
    property OnWaitTimeOut: TBisSipRegistrarEvent read FOnWaitTimeOut write FOnWaitTimeOut;
    property OnSessionCreate: TBisSipRegistrarSessionEvent read FOnSessionCreate write FOnSessionCreate;
    property OnSessionDestroy: TBisSipRegistrarSessionEvent read FOnSessionDestroy write FOnSessionDestroy; 
    property OnSessionAccept: TBisSipRegistrarAcceptEvent read FOnSessionAccept write FOnSessionAccept; 
    property OnSessionRing: TBisSipRegistrarSessionEvent read FOnSessionRing write FOnSessionRing;
    property OnSessionProgress: TBisSipRegistrarSessionEvent read FOnSessionProgress write FOnSessionProgress;
    property OnSessionConfirm: TBisSipRegistrarSessionEvent read FOnSessionConfirm write FOnSessionConfirm;
    property OnSessionTerminate: TBisSipRegistrarSessionEvent read FOnSessionTerminate write FOnSessionTerminate;
    property OnSessionAlive: TBisSipRegistrarAliveEvent read FOnSessionAlive write FOnSessionAlive; 

  end;


const
  DefaultSipPort=5060;
  DefaultScheme='sip';
  DefaultProtocol='SIP/2.0';
  
implementation

uses Windows, SysUtils, TypInfo,
     BisUtils, BisCrypter;

var
  FHeaderClasses: TClassList=nil;
  FResponseKinds: TObjectList=nil;

type
  TBisSipResponseKindInfo=class(TObject)
  private
    FKind: TBisSipResponseKind;
    FCode: String;
    FDescription: String;
  public
    constructor Create(Kind: TBisSipResponseKind; Code: Integer; Description: String);

    property Kind: TBisSipResponseKind read FKind;
    property Code: String read FCode;
    property Description: String read FDescription; 
  end;

{ TBisSipResponseKindInfo }

constructor TBisSipResponseKindInfo.Create(Kind: TBisSipResponseKind; Code: Integer; Description: String);
begin
  inherited Create;
  FKind:=Kind;
  FCode:=IntToStr(Code);
  FDescription:=Description
end;

function GetResponseKindInfo(ResponseKind: TBisSipResponseKind): TBisSipResponseKindInfo;
var
  i: Integer;
  Item: TBisSipResponseKindInfo;
begin
  Result:=nil;
  if Assigned(FResponseKinds) then begin
    for i:=0 to FResponseKinds.Count-1 do begin
      Item:=TBisSipResponseKindInfo(FResponseKinds.Items[i]);
      if Item.FKind=ResponseKind then begin
        Result:=Item;
        exit;
      end;
    end;
  end;
end;

function ResponseKindToCode(Code: String; var ResponseKind: TBisSipResponseKind): Boolean;
var
  i: Integer;
  Item: TBisSipResponseKindInfo;
begin
  Result:=false;
  if Assigned(FResponseKinds) then begin
    for i:=0 to FResponseKinds.Count-1 do begin
      Item:=TBisSipResponseKindInfo(FResponseKinds.Items[i]);
      if AnsiSameText(Item.FCode,Code) then begin
        ResponseKind:=Item.FKind;
        Result:=true;
        exit;
      end;
    end;
  end;
end;

function FindHeaderClass(const AName: String): TBisSipHeaderClass;
var
  i: Integer;
  AClass: TBisSipHeaderClass;
begin
  Result:=nil;
  if Assigned(FHeaderClasses) then begin
    for i:=0 to FHeaderClasses.Count-1 do begin
      AClass:=TBisSipHeaderClass(FHeaderClasses[i]);
      if AnsiSameText(AClass.GetName,AName) then begin
        Result:=AClass;
        exit;
      end;
    end;
  end;
end;

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

function ParseUri(const Uri: String; var Scheme, User, Host, Port, Transport: String): Boolean;
var
  ASchemeUser, AHostPort: String;
  Strings: TStringList;
  i: Integer;
  N,V: String;
begin
  Strings:=TStringList.Create;
  try
    GetStringsByString(Uri,';',Strings);
    for i:=0 to Strings.Count-1 do begin
      if i=0 then begin
        if ParseName(Trim(Strings[i]),'@',ASchemeUser,AHostPort) then begin
          ParseName(ASchemeUser,':',Scheme,User);
          ParseName(AHostPort,':',Host,Port);
        end;
      end else begin
        if ParseName(Trim(Strings[i]),'=',N,V) then begin
          if AnsiSameText(N,'transport') then
            Transport:=V;
        end;
      end;
    end;
    Result:=Scheme<>'';
  finally
    Strings.Free;
  end;
end;

{ TBisSipHeader }

constructor TBisSipHeader.Create;
begin
  inherited Create;
end;

function TBisSipHeader.Empty: Boolean;
begin
  Result:=AsString='';
end;

function TBisSipHeader.AsString: String;
begin
  Result:='';
end;

procedure TBisSipHeader.CopyFrom(Source: TBisSipHeader);
begin
end;

class function TBisSipHeader.GetName: String;
begin
  Result:='';
end;

function TBisSipHeader.NameEqual: String;
begin
  Result:=GetName;
  Result:=iff(Result<>'',Result+':','');
end;

procedure TBisSipHeader.Parse(const Body: String);
begin
end;

{ TBisSipSimple }

function TBisSipSimple.AsInteger: Integer;
begin
  TryStrToInt(FValue,Result);
end;

function TBisSipSimple.AsString: String;
var
  S: String;
begin
  S:=Format('%s %s',[NameEqual,FValue]);
  Result:=Trim(S);
end;

procedure TBisSipSimple.CopyFrom(Source: TBisSipHeader);
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipSimple) then
    FValue:=TBisSipSimple(Source).FValue;
end;

procedure TBisSipSimple.Parse(const Body: String);
begin
  FValue:=Body;
end;

{ TBisSipVia }

procedure TBisSipVia.CopyFrom(Source: TBisSipHeader);
var
  ViaSource: TBisSipVia;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipVia) then begin
    ViaSource:=TBisSipVia(Source);

    FProtocol:=ViaSource.FProtocol;
    FTransport:=ViaSource.FTransport;
    FHost:=ViaSource.FHost;
    FPort:=ViaSource.FPort;
    FRport:=ViaSource.FRport;
    FBranch:=ViaSource.FBranch;
    FReceived:=ViaSource.FReceived;
  end;
end;

class function TBisSipVia.GetName: String;
begin
  Result:='Via';
end;

procedure TBisSipVia.Parse(const Body: String);

  procedure ParseProtocolHost(S: String);
  var
    AProtocolTransport,AHostPort: String;
    Temp: TStringList;
  begin
    S:=Trim(S);
    if ParseName(S,' ',AProtocolTransport,AHostPort) then begin
      Temp:=TStringList.Create;
      try
        GetStringsByString(AProtocolTransport,'/',Temp);
        if Temp.Count>1 then begin
          FProtocol:=Temp[0]+'/'+Temp[1];
          if Temp.Count>2 then begin
            FTransport:=Temp[2];
          end;
        end;
        ParseName(AHostPort,':',FHost,FPort);
      finally
        Temp.Free;
      end;
    end;
  end;

  procedure ParseOther(S: String);
  var
    AName, AValue: String;
  begin
    if ParseName(S,'=',AName,AValue) then begin
      if AnsiSameText(AName,'received') then FReceived:=AValue;
      if AnsiSameText(AName,'branch') then FBranch:=AValue;
      if AnsiSameText(AName,'rport') then FRport:=AValue;
    end;
  end;

var
  Strings: TStringList;
  i: Integer;
begin
  Strings:=TStringList.Create;
  try
    GetStringsByString(Body,';',Strings);
    if Strings.Count>0 then begin
      ParseProtocolHost(Strings[0]);
      if Strings.Count>1 then begin
        for i:=1 to Strings.Count-1 do
          ParseOther(Strings[i]);
      end;
    end;
  finally
    Strings.Free;
  end;
end;

function TBisSipVia.AsString: String;
var
  S: String;
begin
  S:=Format('%s %s%s %s%s%s%s%s',[NameEqual,
                                  iff(FProtocol<>'',FProtocol,''),
                                  iff(FTransport<>'','/'+FTransport,''),
                                  iff(FHost<>'',FHost,''),
                                  iff(FPort<>'',':'+FPort,''),
                                  iff(FRport<>'',';rport='+FRport,';rport'),
                                  iff(FBranch<>'',';branch='+FBranch,''),
                                  iff(FReceived<>'',';received='+FReceived,'')]);
  Result:=Trim(S);
end;

{ TBisSipFrom }

procedure TBisSipFrom.CopyFrom(Source: TBisSipHeader);
var
  FromSource: TBisSipFrom;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipFrom) then begin
    FromSource:=TBisSipFrom(Source);

    FDisplay:=FromSource.FDisplay;
    FScheme:=FromSource.FScheme;
    FUser:=FromSource.FUser;
    FHost:=FromSource.FHost;
    FPort:=FromSource.FPort;
    FTag:=FromSource.FTag;
    FExpires:=FromSource.FExpires;
    FQ:=FromSource.FQ;
    FUriUser:=FromSource.FUriUser;
    FUriCpc:=FromSource.FUriCpc;
    FUriTransport:=FromSource.FUriTransport;
  end;
end;

class function TBisSipFrom.GetName: String;
begin
  Result:='From';
end;

procedure TBisSipFrom.Parse(const Body: String);

  procedure ParseUriOther(S: String);
  var
    AName, AValue: String;
  begin
    if ParseName(S,'=',AName,AValue) then begin
      if AnsiSameText(AName,'user') then FUriUser:=AValue;
      if AnsiSameText(AName,'cpc') then FUriCpc:=AValue;
      if AnsiSameText(AName,'transport') then FUriTransport:=AValue;
    end;
  end;

  procedure ParseUri(S: String);
  var
    ADisplay, AUriRaw, AUri: String;
    ASchemeUser, AHostPort: String;
    Temp: TStringList;
    i: Integer;
  begin
    if ParseName(S,' ',ADisplay,AUriRaw) then begin
      if AUriRaw='' then begin
        AUriRaw:=ADisplay;
        ADisplay:='';
      end;
      ParseBetween(ADisplay,'"','"',FDisplay);
      if ParseBetween(AUriRaw,'<','>',AUri) then begin
        Temp:=TStringList.Create;
        try
          GetStringsByString(AUri,';',Temp);
          if Temp.Count>0 then begin
            if ParseName(Temp[0],'@',ASchemeUser,AHostPort) then begin
              ParseName(ASchemeUser,':',FScheme,FUser);
              ParseName(AHostPort,':',FHost,FPort);
            end;
            if Temp.Count>1 then begin
              for i:=1 to Temp.Count-1 do
                ParseUriOther(Temp[i]);
            end;
          end;
        finally
          Temp.Free;
        end;
      end;
    end;
  end;

  procedure ParseOther(S: String);
  var
    AName, AValue: String;
  begin
    if ParseName(S,'=',AName,AValue) then begin
      if AnsiSameText(AName,'tag') then FTag:=AValue;
      if AnsiSameText(AName,'expires') then FExpires:=AValue;
      if AnsiSameText(AName,'q') then FQ:=AValue;
    end;
  end;

var
  Strings: TStringList;
  i: Integer;
  S1,S2: String;
begin
  Strings:=TStringList.Create;
  try
    if ParseName(Body,'>',S1,S2) then begin
      ParseUri(S1+'>');
      GetStringsByString(S2,';',Strings);
      if Strings.Count>0 then begin
        for i:=0 to Strings.Count-1 do
          ParseOther(Strings[i]);
      end;
    end;
  finally
    Strings.Free;
  end;
end;

function TBisSipFrom.Empty: Boolean;
begin
  Result:=HeadersAsString='<>';
end;

function TBisSipFrom.HeadersAsString: String;
begin
  Result:=Format('%s<%s%s%s%s%s%s%s>%s%s%s',[iff(FDisplay<>'','"'+FDisplay+'" ',''),
                                             iff(FScheme<>'',FScheme+':',''),
                                             iff(FUser<>'',FUser+'@',''),
                                             iff(FHost<>'',FHost,''),
                                             iff(FPort<>'',':'+FPort,''),
                                             iff(FUriUser<>'',';user='+FUriUser,''),
                                             iff(FUriCpc<>'',';cpc='+FUriCpc,''),
                                             iff(FUriTransport<>'',';transport='+FUriTransport,''),
                                             iff(FTag<>'',';tag='+FTag,''),
                                             iff(FExpires<>'',';expires='+FExpires,''),
                                             iff(FQ<>'',';q='+FQ,'')]);
  Result:=Trim(Result);                                       
end;

function TBisSipFrom.AsString: String;
var
  S: String;
  S1: String;
begin
  S1:=HeadersAsString;

  if S1='<>' then
    S1:='*';

  S:=Format('%s %s',[NameEqual,S1]);
  Result:=Trim(S);
end;

function TBisSipFrom.GetUri: String;
begin
  Result:=Format('%s%s%s%s%s%s%s',[iff(FScheme<>'',FScheme+':',''),
                                   iff(FUser<>'',FUser+'@',''),
                                   iff(FHost<>'',FHost,''),
                                   iff(FPort<>'',':'+FPort,''),
                                   iff(FUriUser<>'',';user='+FUriUser,''),
                                   iff(FUriCpc<>'',';cpc='+FUriCpc,''),
                                   iff(FUriTransport<>'',';transport='+FUriTransport,'')]);
  Result:=Trim(Result);
end;

{ TBisSipTo }

class function TBisSipTo.GetName: String;
begin
  Result:='To';
end;

{ TBisSipContact }

class function TBisSipContact.GetName: String;
begin
  Result:='Contact';
end;

{ TBisSipPAssertedIdentity }

class function TBisSipPAssertedIdentity.GetName: String;
begin
  Result:='P-Asserted-Identity';
end;

{ TBisSipCallID }

class function TBisSipCallID.GetName: String;
begin
  Result:='Call-ID';
end;

{ TBisSipPrivacy }

class function TBisSipPrivacy.GetName: String;
begin
  Result:='Privacy';
end;

{ TBisSipCSeq }

procedure TBisSipCSeq.CopyFrom(Source: TBisSipHeader);
var
  CSeqSource: TBisSipCSeq;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipCSeq) then begin
    CSeqSource:=TBisSipCSeq(Source);

    FNum:=CSeqSource.FNum;
    FRequestName:=CSeqSource.FRequestName;
  end;
end;

class function TBisSipCSeq.GetName: String;
begin
  Result:='CSeq';
end;

procedure TBisSipCSeq.Parse(const Body: String);
begin
  ParseName(Body,' ',FNum,FRequestName);
end;

function TBisSipCSeq.AsString: String;
var
  S: String;
begin
  S:=Format('%s %s %s',[NameEqual,
                        iff(FNum<>'',FNum,''),
                        iff(FRequestName<>'',FRequestName,'')]);
  Result:=Trim(S);
end;

{ TBisSipReason }

procedure TBisSipReason.CopyFrom(Source: TBisSipHeader);
var
  Reason: TBisSipReason;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipReason) then begin
    Reason:=TBisSipReason(Source);

    FValue:=Reason.FValue;
    FCause:=Reason.FCause;
    FText:=Reason.FText;
  end;
end;

class function TBisSipReason.GetName: String;
begin
  Result:='Reason';
end;

procedure TBisSipReason.Parse(const Body: String);

  procedure ParseOther(S: String);
  var
    AName, AValue: String;
  begin
    if ParseName(S,'=',AName,AValue) then begin
      if AnsiSameText(AName,'cause') then FCause:=AValue;
      if AnsiSameText(AName,'text') then begin
        ParseBetween(AValue,'"','"',FText);
      end;
    end;
  end;

var
  Strings: TStringList;
  i: Integer;
begin
  Strings:=TStringList.Create;
  try
    GetStringsByString(Body,';',Strings);
    if Strings.Count>0 then begin
      FValue:=Strings[0];
      if Strings.Count>1 then begin
        for i:=1 to Strings.Count-1 do
          ParseOther(Strings[i]);
      end;
    end;
  finally
    Strings.Free;
  end;
end;

{ TBisSipOrganization }

class function TBisSipOrganization.GetName: String;
begin
  Result:='Organization';
end;

{ TBisSipUserAgent }

class function TBisSipUserAgent.GetName: String;
begin
  Result:='User-Agent';
end;

{ TBisSipSubject }

class function TBisSipSubject.GetName: String;
begin
  Result:='Subject';
end;

{ TBisSipAllow }

procedure TBisSipAllow.CopyFrom(Source: TBisSipHeader);
var
  Allow: TBisSipAllow;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipAllow) then begin
    Allow:=TBisSipAllow(Source);

    FTypes:=Allow.FTypes;
  end;
end;

class function TBisSipAllow.GetName: String;
begin
  Result:='Allow';
end;

function TBisSipAllow.GetStringByType(AllowType: TBisSipAllowType): String;
var
  S: String;
begin
  S:=GetEnumName(TypeInfo(TBisSipAllowType),Integer(AllowType));
  Result:=Copy(S,3,Length(S));
end;

function TBisSipAllow.AsString: String;
var
  S: String;
  Ident: String;
  i: TBisSipAllowType;
begin
  S:='';

  for i:=atInvite to atMessage do begin
    Ident:=GetStringByType(i);
    if i in FTypes then
      S:=Iff(S='',Ident,S+', '+Ident);
  end;

  if S<>'' then
    S:=Format('%s %s',[NameEqual,S]);

  Result:=Trim(S);
end;

{ TBisSipMaxForwards }

class function TBisSipMaxForwards.GetName: String;
begin
  Result:='Max-Forwards';
end;

{ TBisSipExpires }

class function TBisSipExpires.GetName: String;
begin
  Result:='Expires';
end;

{ TBisSipContentType }

class function TBisSipContentType.GetName: String;
begin
  Result:='Content-Type';
end;

class function TBisSipContentType.NameToKind(Name: String): TBisSipContentTypeKind;
begin
  Result:=ctkUnknown;
  if AnsiSameText(Name,'application/sdp') then Result:=ctkApplicationSdp;
end;

class function TBisSipContentType.KindToName(Kind: TBisSipContentTypeKind): String;
begin
  Result:='';
  case Kind of
    ctkUnknown: ;
    ctkApplicationSdp: Result:='application/sdp';
  end;
end;

function TBisSipContentType.GetKind: TBisSipContentTypeKind;
begin
  Result:=NameToKind(FValue);
end;

{ TBisSipContentLength }

class function TBisSipContentLength.GetName: String;
begin
  Result:='Content-Length';
end;

{ TBisSipContentDisposition }

procedure TBisSipContentDisposition.CopyFrom(Source: TBisSipHeader);
var
  ContentDisposition: TBisSipContentDisposition;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipContentDisposition) then begin
    ContentDisposition:=TBisSipContentDisposition(Source);

    FValue:=ContentDisposition.FValue;
    FHandling:=ContentDisposition.FHandling;
  end;
end;

class function TBisSipContentDisposition.GetName: String;
begin
  Result:='Content-Disposition';
end;

procedure TBisSipContentDisposition.Parse(const Body: String);

  procedure ParseOther(S: String);
  var
    AName, AValue: String;
  begin
    if ParseName(S,'=',AName,AValue) then begin
      if AnsiSameText(AName,'handling') then FHandling:=AValue;
    end;
  end;

var
  Strings: TStringList;
  i: Integer;
begin
  Strings:=TStringList.Create;
  try
    GetStringsByString(Body,';',Strings);
    if Strings.Count>0 then begin
      FValue:=Strings[0];
      if Strings.Count>1 then begin
        for i:=1 to Strings.Count-1 do
          ParseOther(Strings[i]);
      end;
    end;
  finally
    Strings.Free;
  end;
end;

{ TBisSipWWWAuthenticate }

procedure TBisSipWWWAuthenticate.CopyFrom(Source: TBisSipHeader);
var
  AuthenticateSource: TBisSipWWWAuthenticate;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipWWWAuthenticate) then begin
    AuthenticateSource:=TBisSipWWWAuthenticate(Source);

    FAuthorization:=AuthenticateSource.FAuthorization;
    FRealm:=AuthenticateSource.FRealm;
    FNonce:=AuthenticateSource.FNonce;
    FOpaque:=AuthenticateSource.FOpaque;
    FAlgorithm:=AuthenticateSource.FAlgorithm;
    FQop:=AuthenticateSource.FQop;
  end;
end;

class function TBisSipWWWAuthenticate.GetName: String;
begin
  Result:='WWW-Authenticate';
end;

procedure TBisSipWWWAuthenticate.Parse(const Body: String);
var
  Strings: TStringList;
  i: Integer;
  AName,AValue: String;
  S0,S: String;
begin
  Strings:=TStringList.Create;
  try
    GetStringsByString(Body,',',Strings);
    for i:=0 to Strings.Count-1 do begin
      if i=0 then begin
        if ParseName(Trim(Strings[i]),' ',FAuthorization,S0) then
          Strings[i]:=S0;
      end;
      if ParseName(Trim(Strings[i]),'=',AName,AValue) then begin
        ParseBetween(AValue,'"','"',S);
        if AnsiSameText(AName,'realm') then FRealm:=S;
        if AnsiSameText(AName,'nonce') then FNonce:=S;
        if AnsiSameText(AName,'opaque') then FOpaque:=S;
        if AnsiSameText(AName,'algorithm') then FAlgorithm:=S;
        if AnsiSameText(AName,'qop') then FQop:=S;
      end;
    end;
  finally
    Strings.Free;
  end;
end;

{ TBisSipProxyAuthenticate }

procedure TBisSipProxyAuthenticate.CopyFrom(Source: TBisSipHeader);
var
  AuthenticateSource: TBisSipProxyAuthenticate;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipProxyAuthenticate) then begin
    AuthenticateSource:=TBisSipProxyAuthenticate(Source);

    FAuthorization:=AuthenticateSource.FAuthorization;
    FRealm:=AuthenticateSource.FRealm;
    FNonce:=AuthenticateSource.FNonce;
    FOpaque:=AuthenticateSource.FOpaque;
    FAlgorithm:=AuthenticateSource.FAlgorithm;
    FQop:=AuthenticateSource.FQop;
  end;
end;

class function TBisSipProxyAuthenticate.GetName: String;
begin
  Result:='Proxy-Authenticate';
end;

procedure TBisSipProxyAuthenticate.Parse(const Body: String);
var
  Strings: TStringList;
  i: Integer;
  AName,AValue: String;
  S0,S: String;
begin
  Strings:=TStringList.Create;
  try
    GetStringsByString(Body,',',Strings);
    for i:=0 to Strings.Count-1 do begin
      if i=0 then begin
        if ParseName(Trim(Strings[i]),' ',FAuthorization,S0) then
          Strings[i]:=S0;
      end;
      if ParseName(Trim(Strings[i]),'=',AName,AValue) then begin
        ParseBetween(AValue,'"','"',S);
        if AnsiSameText(AName,'realm') then FRealm:=S;
        if AnsiSameText(AName,'nonce') then FNonce:=S;
        if AnsiSameText(AName,'opaque') then FOpaque:=S;
        if AnsiSameText(AName,'algorithm') then FAlgorithm:=S;
        if AnsiSameText(AName,'qop') then FQop:=S;
      end;
    end;
  finally
    Strings.Free;
  end;
end;


{ TBisSipAuthorization }

procedure TBisSipAuthorization.CopyFrom(Source: TBisSipHeader);
var
  AuthorizationSource: TBisSipAuthorization;
  WWWAuthenticateSource: TBisSipWWWAuthenticate;
  ProxyAuthenticateSource: TBisSipProxyAuthenticate;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) then begin

    if (Source is TBisSipAuthorization) then begin
      AuthorizationSource:=TBisSipAuthorization(Source);

      FUsername:=AuthorizationSource.FUsername;
      FPassword:=AuthorizationSource.FPassword;
      FUri:=AuthorizationSource.FUri;
      FAuthorization:=AuthorizationSource.FAuthorization;
      FRealm:=AuthorizationSource.FRealm;
      FNonce:=AuthorizationSource.FNonce;
      FQop:=AuthorizationSource.FQop;
      FCnonce:=AuthorizationSource.FCnonce;
      FOpaque:=AuthorizationSource.FOpaque;
      FAlgorithm:=AuthorizationSource.FAlgorithm;
    end;

    if Source is TBisSipWWWAuthenticate then begin
      WWWAuthenticateSource:=TBisSipWWWAuthenticate(Source);

      FAuthorization:=WWWAuthenticateSource.FAuthorization;
      FRealm:=WWWAuthenticateSource.FRealm;
      FNonce:=WWWAuthenticateSource.FNonce;
      FQop:=WWWAuthenticateSource.FQop;
      FCnonce:=WWWAuthenticateSource.FOpaque;
      FOpaque:=WWWAuthenticateSource.FOpaque;
      FAlgorithm:=WWWAuthenticateSource.FAlgorithm;
    end;

    if Source is TBisSipProxyAuthenticate then begin
      ProxyAuthenticateSource:=TBisSipProxyAuthenticate(Source);

      FAuthorization:=ProxyAuthenticateSource.FAuthorization;
      FRealm:=ProxyAuthenticateSource.FRealm;
      FNonce:=ProxyAuthenticateSource.FNonce;
      FQop:=ProxyAuthenticateSource.FQop;
      FCnonce:=ProxyAuthenticateSource.FOpaque;
      FOpaque:=ProxyAuthenticateSource.FOpaque;
      FAlgorithm:=ProxyAuthenticateSource.FAlgorithm;
    end;

  end;
end;

class function TBisSipAuthorization.GetName: String;
begin
  Result:='Authorization';
end;

class function TBisSipAuthorization.AlgorithmNameToType(Algorithm: String): TBisSipAuthenticateAlgorithmType;
var
  i: TBisSipAuthenticateAlgorithmType;
  S: String;
begin
  Result:=aatUnknown;
  for i:=aatMD5 to aatMD5 do begin
    S:=AlgorithmTypeToName(i);
    if AnsiSameText(S,Algorithm) then begin
      Result:=i;
      exit;
    end;
  end;
end;

class function TBisSipAuthorization.AlgorithmTypeToName(AlgorithmType: TBisSipAuthenticateAlgorithmType): String;
var
  S: String;
begin
  Result:='';
  if AlgorithmType<>aatUnknown then begin
    S:=GetEnumName(TypeInfo(TBisSipAuthenticateAlgorithmType),Integer(AlgorithmType));
    Result:=Copy(S,4,Length(S));
    Result:=AnsiUpperCase(Result);
  end;
end;

function TBisSipAuthorization.GetAlgorithmType: TBisSipAuthenticateAlgorithmType;
begin
  Result:=AlgorithmNameToType(FAlgorithm);
end;

function TBisSipAuthorization.AsString: String;

  function GetResponse: String;
  var
    A1, A2: String;
  begin
    Result:='';
    case AlgorithmType of
      aatMD5: begin
        A1:=Format('%s:%s:%s',[FUsername,FRealm,FPassword]);
        A1:=AnsiLowerCase(MD5(A1));
        A2:=Format('%s:%s',[FRequestName,FUri]);
        A2:=AnsiLowerCase(MD5(A2));
//        Result:=Format('%s:%s:%s:%s:auth:%s',[A1,FNonce,Nc,FCnonce,A2]);
        Result:=Format('%s:%s:%s:%s:%s:%s',[A1,FNonce,FNC,FCnonce,FQop,A2]);
        Result:=AnsiLowerCase(MD5(Result));
      end;
    end;
  end;

var
  S: String;
  Response: String;
begin
  if FNC='' then
    FNC:='00000001';

  if FCnonce='' then
    FCnonce:=FNonce;

  if AlgorithmType=aatUnknown then
    FAlgorithm:=AlgorithmTypeToName(aatMD5);
   
  Response:=GetResponse;
  S:=Format('%s %s %s%s%s%s%s%s%s%s%s%s',[NameEqual,
                                          iff(FAuthorization<>'',FAuthorization,''),
                                          iff(FUsername<>'','username="'+FUsername+'"',''),
                                          iff(FRealm<>'',',realm="'+FRealm+'"',''),
                                          iff(FNonce<>'',',nonce="'+FNonce+'"',''),
                                          iff(FUri<>'',',uri="'+FUri+'"',''),
                                          iff(Response<>'',',response="'+Response+'"',''),
                                          iff(FQop<>'',',qop="'+FQop+'"',''),
                                          iff(FCnonce<>'',',cnonce="'+FCnonce+'"',''),
                                          iff(FNC<>'',',nc='+FNC,''),
                                          iff(FOpaque<>'',',opaque="'+FOpaque+'"',''),
                                          iff(FAlgorithm<>'',',algorithm='+FAlgorithm,'')]);
  Result:=Trim(S);
end;

{ TBisSipProxyAuthorization }

class function TBisSipProxyAuthorization.GetName: String;
begin
  Result:='Proxy-Authorization';
end;

{ TBisSipSupported }

class function TBisSipSupported.GetName: String;
begin
  Result:='Supported';
end;

{ TBisSipDate }

class function TBisSipDate.GetName: String;
begin
  Result:='Date';
end;

{ TBisSipAllowEvents }

class function TBisSipAllowEvents.GetName: String;
begin
  Result:='Allow-Events';
end;

{ TBisSipXFSSupport }

class function TBisSipXFSSupport.GetName: String;
begin
  Result:='X-FS-Support';
end;

{ TBisSipHeaders }

function TBisSipHeaders.Find(AClass: TBisSipHeaderClass): TBisSipHeader;
var
  i: Integer;
  Item: TBisSipHeader;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if IsClassParent(Item.ClassType,AClass) then begin
        Result:=Item;
        exit;
      end;
    end;
  end;
end;

function TBisSipHeaders.GetItem(Index: Integer): TBisSipHeader;
begin
  Result:=TBisSipHeader(inherited Items[Index]);
end;

procedure TBisSipHeaders.GetStrings(Strings: TStrings);
var
  i: Integer;
  S: String;
  Item: TBisSipHeader;
begin
  if Assigned(Strings) then begin
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      S:=Item.AsString;
      if Trim(S)<>'' then
        Strings.Add(S);
    end;
  end;
end;

function TBisSipHeaders.Add(AClass: TBisSipHeaderClass): TBisSipHeader;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    Result:=Find(AClass);
    if not Assigned(Result) then begin
      Result:=AClass.Create;
      inherited Add(Result);
    end;
  end;
end;

function TBisSipHeaders.AddVia(Protocol, Transport, Host, Port, Branch, RPort, Received: String): TBisSipVia;
begin
  Result:=TBisSipVia(Add(TBisSipVia));
  if Assigned(Result) then begin
    Result.FProtocol:=Protocol;
    Result.FTransport:=Transport;
    Result.FHost:=Host;
    Result.FPort:=Port;
    Result.FBranch:=Branch;
    Result.FRport:=RPort;
    Result.FReceived:=Received;
  end;
end;

function TBisSipHeaders.AddFrom(Display, Scheme, User, Host, Port, Tag, UriUser, UriCpc, UriTransport: String): TBisSipFrom;
begin
  Result:=TBisSipFrom(Add(TBisSipFrom));
  if Assigned(Result) then begin
    Result.FDisplay:=Display;
    Result.FScheme:=Scheme;
    Result.FUser:=User;
    Result.FHost:=Host;
    Result.FPort:=Port;
    Result.FTag:=Tag;
    Result.FUriUser:=UriUser;
    Result.FUriCpc:=UriCpc;
    Result.FUriTransport:=UriTransport;
  end;
end;

function TBisSipHeaders.AddTo(Display, Scheme, User, Host, Port, Tag, UriUser, UriCpc, UriTransport: String): TBisSipTo;
begin
  Result:=TBisSipTo(Add(TBisSipTo));
  if Assigned(Result) then begin
    Result.FDisplay:=Display;
    Result.FScheme:=Scheme;
    Result.FUser:=User;
    Result.FHost:=Host;
    Result.FPort:=Port;
    Result.FTag:=Tag;
    Result.FUriUser:=UriUser;
    Result.FUriCpc:=UriCpc;
    Result.FUriTransport:=UriTransport;
  end;
end;

function TBisSipHeaders.AddContact(Display, Scheme, User, Host, Port, Tag, Expires, Q,
                                   UriUser, UriCpc, UriTransport: String): TBisSipContact;
begin
  Result:=AddContact;
  if Assigned(Result) then begin
    Result.FDisplay:=Display;
    Result.FScheme:=Scheme;
    Result.FUser:=User;
    Result.FHost:=Host;
    Result.FPort:=Port;
    Result.FTag:=Tag;
    Result.FUriUser:=UriUser;
    Result.FUriCpc:=UriCpc;
    Result.FUriTransport:=UriTransport;
    Result.FExpires:=Expires;
    Result.FQ:=Q;
  end;
end;

function TBisSipHeaders.AddContact: TBisSipContact;
begin
  Result:=TBisSipContact(Add(TBisSipContact));
end;

function TBisSipHeaders.AddCallID(Value: String): TBisSipCallID;
begin
  Result:=TBisSipCallID(Add(TBisSipCallID));
  if Assigned(Result) then begin
    Result.FValue:=Value;
  end;
end;

function TBisSipHeaders.AddCSeq(Num, RequestName: String): TBisSipCSeq;
begin
  Result:=TBisSipCSeq(Add(TBisSipCSeq));
  if Assigned(Result) then begin
    Result.FNum:=Num;
    Result.FRequestName:=RequestName;
  end;
end;

function TBisSipHeaders.AddUserAgent(Value: String): TBisSipUserAgent;
begin
  Result:=TBisSipUserAgent(Add(TBisSipUserAgent));
  if Assigned(Result) then begin
    Result.FValue:=Value;
  end;
end;

function TBisSipHeaders.AddAllow(Types: TBisSipAllowTypes): TBisSipAllow;
begin
  Result:=TBisSipAllow(Add(TBisSipAllow));
  if Assigned(Result) then begin
    Result.FTypes:=Types;
  end;
end;

function TBisSipHeaders.AddMaxForwards(Value: String): TBisSipMaxForwards;
begin
  Result:=TBisSipMaxForwards(Add(TBisSipMaxForwards));
  if Assigned(Result) then begin
    Result.FValue:=Value;
  end;
end;

function TBisSipHeaders.AddExpires(Value: String): TBisSipExpires;
begin
  Result:=TBisSipExpires(Add(TBisSipExpires));
  if Assigned(Result) then begin
    Result.FValue:=Value;
  end;
end;

function TBisSipHeaders.AddContentType(Value: String): TBisSipContentType;
begin
  Result:=TBisSipContentType(Add(TBisSipContentType));
  if Assigned(Result) then begin
    Result.FValue:=Value;
  end;
end;

function TBisSipHeaders.AddContentType(Kind: TBisSipContentTypeKind): TBisSipContentType;
begin
  Result:=AddContentType(TBisSipContentType.KindToName(Kind));
end;

function TBisSipHeaders.AddContentLength(Value: String): TBisSipContentLength;
begin
  Result:=TBisSipContentLength(Add(TBisSipContentLength));
  if Assigned(Result) then begin
    Result.FValue:=Value;
  end;
end;

function TBisSipHeaders.AddAuthorization(Username, Password, RequestName, Uri: String): TBisSipAuthorization;
begin
  Result:=TBisSipAuthorization(Add(TBisSipAuthorization));
  if Assigned(Result) then begin
    Result.FUsername:=Username;
    Result.FPassword:=Password;
    Result.FRequestName:=RequestName;
    Result.FUri:=Uri;
  end;
end;

function TBisSipHeaders.AddProxyAuthorization(Username, Password, RequestName, Uri: String): TBisSipProxyAuthorization;
begin
  Result:=TBisSipProxyAuthorization(Add(TBisSipProxyAuthorization));
  if Assigned(Result) then begin
    Result.FUsername:=Username;
    Result.FPassword:=Password;
    Result.FRequestName:=RequestName;
    Result.FUri:=Uri;
  end;
end;

function TBisSipHeaders.ParseHeader(const Line: String): TBisSipHeader;
var
  Name, Body: String;
  AClass: TBisSipHeaderClass;
begin
  Result:=nil;
  if ParseName(Line,':',Name,Body) then begin
    AClass:=FindHeaderClass(Name);
    if Assigned(AClass) then begin
      Result:=AClass.Create;
      Result.Parse(Trim(Body));
      inherited Add(Result);
    end;
  end;
end;

procedure TBisSipHeaders.CopyFrom(Source: TBisSipHeaders; WithClear: Boolean);
var
  i: Integer;
  Header: TBisSipHeader;
  NewHeader: TBisSipHeader;
begin
  if WithClear then
    Clear;
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Header:=Source[i];
      NewHeader:=Add(TBisSipHeaderClass(Header.ClassType));
      if Assigned(NewHeader) then
        NewHeader.CopyFrom(Header);
    end;
  end;
end;

procedure TBisSipHeaders.CopyFrom(Source: TBisSipHeaders; AClasses: array of TBisSipHeaderClass);
var
  i: Integer;
  Header: TBisSipHeader;
  NewHeader: TBisSipHeader;
begin
  if Assigned(Source) then begin
    for i:=Low(AClasses) to High(AClasses) do begin
      Header:=Source.Find(AClasses[i]);
      if Assigned(Header) then begin
        NewHeader:=Add(AClasses[i]);
        if Assigned(NewHeader) then
          NewHeader.CopyFrom(Header);
      end;
    end;
  end;
end;

{ TBisSipBody }

function TBisSipBody.AsString: String;
begin
  Result:=Trim(Text);
end;

function TBisSipBody.Length: Integer;
begin
  Result:=System.Length(AsString);
end;

{ TBisSipMessage }

constructor TBisSipMessage.Create;
begin
  inherited Create;
  FHeaders:=TBisSipHeaders.Create;
  FBody:=TBisSipBody.Create;
end;

destructor TBisSipMessage.Destroy;
begin
  FBody.Free;
  FHeaders.Free;
  inherited Destroy;
end;

procedure TBisSipMessage.CopyFrom(Source: TBisSipMessage);
begin
  if Assigned(Source) then begin
    FHeaders.CopyFrom(Source.Headers);
    FBody.Assign(Source.Body);
  end;
end;

procedure TBisSipMessage.GetHeader(Strings: TStrings);
begin
  FHeaders.GetStrings(Strings);
end;

procedure TBisSipMessage.GetBody(Strings: TStrings);
begin
  Strings.AddStrings(FBody);
end;

function TBisSipMessage.AsString: String;
var
  Strings, Temp: TStringList;
begin
  Strings:=TStringList.Create;
  Temp:=TStringList.Create;
  try
    GetHeader(Strings);
    if Strings.Count>0 then begin
      GetBody(Temp);
      if Temp.Count>0 then begin
        Strings.Add('');
        Strings.AddStrings(Temp);
      end;
    end;
    Result:=Trim(Strings.Text);
    Result:=Result+iff(Temp.Count=0,#13#10+#13#10,#13#10);
  finally
    Temp.Free;
    Strings.Free;
  end;
end;

function TBisSipMessage.GetCSeqNum: String;
var
  CSeq: TBisSipCSeq;
begin
  Result:='';
  CSeq:=TBisSipCSeq(Headers.Find(TBisSipCSeq));
  if Assigned(CSeq) then
    Result:=CSeq.Num;
end;

procedure TBisSipMessage.SetCSeqNum(const Value: String);
var
  CSeq: TBisSipCSeq;
begin
  CSeq:=TBisSipCSeq(Headers.Find(TBisSipCSeq));
  if Assigned(CSeq) then
    CSeq.Num:=Value;
end;

{ TBisSipResponse }

constructor TBisSipResponse.Create(Protocol, Code, Description: String);
begin
  inherited Create;
  FCode:=Code;
  FProtocol:=Protocol;
  FDescription:=Description;
end;

procedure TBisSipResponse.GetHeader(Strings: TStrings);
var
  S: String;
begin
  if Assigned(Strings) then begin
    S:=Format('%s %s %s',[FProtocol,FCode,FDescription]);
    Strings.Add(Trim(S));
  end;
  inherited GetHeader(Strings);
end;

function TBisSipResponse.GetResponseKind: TBisSipResponseKind;
begin
  ResponseKindToCode(FCode,Result);
end;

{ TBisSipRequest }

constructor TBisSipRequest.Create;
begin
  inherited Create;
  FResponses:=TBisSipResponses.Create;
end;

destructor TBisSipRequest.Destroy;
begin
  FResponses.Free;
  inherited Destroy;
end;

constructor TBisSipRequest.Create(Direction: TBisSipRequestDirection; Name, Scheme, User, Host, Port, Protocol, Transport: String);
begin
  Create;
  FDirection:=Direction;
  FName:=Name;
  FScheme:=Scheme;
  FUser:=User;
  FHost:=Host;
  FPort:=Port;
  FProtocol:=Protocol;
  FTransport:=Transport;
end;

constructor TBisSipRequest.Create(Direction: TBisSipRequestDirection; RequestType: TBisSipRequestType;
                                  Scheme, User,  Host, Port, Protocol, Transport: String);
begin
  Create(Direction,RequestTypeToName(RequestType),Scheme,User,Host,Port,Protocol,Transport);
end;

constructor TBisSipRequest.Create(Direction: TBisSipRequestDirection; Name, Uri, Protocol: String);
{var
  ASchemeUser, AHostPort: String;
  Strings: TStringList;
  i: Integer;
  N,V: String;}
begin
  Create(Direction,Name,'','','','',Protocol,'');
  ParseUri(Uri,FScheme,FUser,FHost,FPort,FTransport);

{  Strings:=TStringList.Create;
  try
    Create(Direction,Name,'','','','',Protocol,'');
{    GetStringsByString(Uri,';',Strings);
    for i:=0 to Strings.Count-1 do begin
      if i=0 then begin
        if ParseName(Trim(Strings[i]),'@',ASchemeUser,AHostPort) then begin
          ParseName(ASchemeUser,':',FScheme,FUser);
          ParseName(AHostPort,':',FHost,FPort);
        end;
      end else begin
        if ParseName(Trim(Strings[i]),'=',N,V) then begin
          if AnsiSameText(N,'transport') then
            FTransport:=V;
        end;
      end;
    end;}
{  finally
    Strings.Free;
  end;}
end;

constructor TBisSipRequest.Create(Direction: TBisSipRequestDirection; RequestType: TBisSipRequestType; Uri, Protocol: String);
begin
  Create(Direction,RequestTypeToName(RequestType),Uri,Protocol);
end;

constructor TBisSipRequest.Create(Direction: TBisSipRequestDirection; RequestType: TBisSipRequestType; Request: TBisSipRequest;
                                  WithHeaders: Boolean=true; WithBody: Boolean=true);
begin
  Create;
  if Assigned(Request) then begin
    CopyFrom(Request);
    FDirection:=Direction;
    FName:=RequestTypeToName(RequestType);
    if not WithHeaders then
      Headers.Clear;
    if not WithBody then
      Body.Clear;
  end;
end;

procedure TBisSipRequest.CopyFrom(Source: TBisSipMessage);
var
  Request: TBisSipRequest;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipRequest) then begin
    Request:=TBisSipRequest(Source);

    FName:=Request.FName;
    FScheme:=Request.FScheme;
    FUser:=Request.FUser;
    FHost:=Request.FHost;
    FPort:=Request.FPort;
    FProtocol:=Request.FProtocol;
    FTransport:=Request.FTransport;
  end;
end;

function TBisSipRequest.GetUri: String;
begin
  Result:=Format('%s%s%s%s%s',[iff(FScheme<>'',FScheme+':',''),
                               iff(FUser<>'',FUser+'@',''),
                               iff(FHost<>'',FHost,''),
                               iff(FPort<>'',':'+FPort,''),
                               iff(FTransport<>'',';transport='+FTransport,'')]);
  Result:=Trim(Result);
end;

procedure TBisSipRequest.GetHeader(Strings: TStrings);
var
  S: String;
begin
  if Assigned(Strings) then begin
    S:=Format('%s %s %s',[FName,GetUri,iff(FProtocol<>'',FProtocol,'')]);
    Strings.Add(Trim(S));
  end;
  inherited GetHeader(Strings);
end;

class function TBisSipRequest.RequestTypeToName(&Type: TBisSipRequestType): String;
var
  S: String;
begin
  S:=GetEnumName(TypeInfo(TBisSipRequestType),Integer(&Type));
  Result:=Copy(S,3,Length(S));
end;

class function TBisSipRequest.RequestNameToType(Name: String; var &Type: TBisSipRequestType): Boolean;
var
  i: TBisSipRequestType;
  S: String;
begin
  Result:=false;
  for i:=rtUNKNOWN to rtCANCEL do begin
    S:=RequestTypeToName(i);
    if AnsiSameText(S,Name) then begin
      Result:=true;
      &Type:=i;
      exit;
    end;
  end;
end;

function TBisSipRequest.GetRequestType: TBisSipRequestType;
begin
  Result:=rtUNKNOWN;
  RequestNameToType(FName,Result);
end;

{ TBisSipMessages }

constructor TBisSipMessages.Create;
begin
  inherited Create;
end;

function TBisSipMessages.GetItem(Index: Integer): TBisSipMessage;
begin
  Result:=TBisSipMessage(inherited Items[Index]);
end;

{ TBisSipResponses }

function TBisSipResponses.GetItem(Index: Integer): TBisSipResponse;
begin
  Result:=TBisSipResponse(inherited Items[Index]);
end;

procedure TBisSipResponses.Add(Response: TBisSipResponse);
begin
  inherited Add(Response);
end;

function TBisSipResponses.FindByKind(ResponseKind: TBisSipResponseKind): TBisSipResponse;
var
  i: Integer;
  Item: TBisSipResponse;
begin
  Result:=nil;
  for i:=Count-1 downto 0 do begin
    Item:=Items[i];
    if Item.ResponseKind=ResponseKind then begin
      Result:=Item;
      exit;
    end;
  end;
end;

{ TBisSipRequests }

function TBisSipRequests.GetItem(Index: Integer): TBisSipRequest;
begin
  Result:=TBisSipRequest(inherited Items[Index]);
end;

procedure TBisSipRequests.Add(Request: TBisSipRequest);
begin
  inherited Add(Request);
end;

function TBisSipRequests.Exists(Request: TBisSipRequest): Boolean;
begin
  Result:=IndexOf(Request)<>-1;
end;

function TBisSipRequests.FindBy(Sequence,RequestName: String): TBisSipRequest;
var
  i: Integer;
  Item: TBisSipRequest;
begin
  Result:=nil;
  for i:=Count-1 downto 0 do begin
    Item:=Items[i];
    if AnsiSameText(Item.CSeqNum,Sequence) and
       AnsiSameText(Item.Name,RequestName) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisSipRequests.FindByType(RequestType: TBisSipRequestType): TBisSipRequest;
var
  i: Integer;
  Item: TBisSipRequest;
begin
  Result:=nil;
  for i:=Count-1 downto 0 do begin
    Item:=Items[i];
    if Item.RequestType=RequestType then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisSipRequests.GetRequest(Response: TBisSipResponse): TBisSipRequest;
var
  CSeq: TBisSipCSeq;
begin
  Result:=nil;
  if Assigned(Response) then begin
    CSeq:=TBisSipCSeq(Response.Headers.Find(TBisSipCSeq));
    if Assigned(CSeq) then
      Result:=FindBy(CSeq.Num,CSeq.RequestName);
  end;
end;

{ TBisSipTimer }

constructor TBisSipTimer.Create(Interval: Integer; OnTimer: TBisSipTimerEvent);
begin
  inherited Create(True);
  FInterval:=Interval;
  FOnTimer:=OnTimer;
end;

destructor TBisSipTimer.Destroy;
begin
  Terminate;
  inherited Destroy;
end;

procedure TBisSipTimer.DoTimer;
begin
  if Assigned(FOnTimer) then
    FOnTimer(Self);
end;

procedure TBisSipTimer.Execute;
var
  T1: Cardinal;
  AInterval: Integer;
begin
  T1:=GetTickCountEx;
  AInterval:=0;
  while not Terminated do begin
    if (AInterval>=FInterval) then begin
      Synchronize(DoTimer);
      T1:=GetTickCountEx;
    end else
      Sleep(1);
    AInterval:=GetTickCountEx-T1;
  end;
end;

procedure TBisSipTimer.Terminate;
begin
  FOnTimer:=nil;
  FData:=nil;
  inherited Terminate;
end;

{ TBisSipTimers }

constructor TBisSipTimers.Create;
begin
  inherited Create(false);
  FLock:=TCriticalSection.Create;
end;

destructor TBisSipTimers.Destroy;
begin
  TerminateAll;
  FLock.Free;
  inherited Destroy;
end;

function TBisSipTimers.GetItem(Index: Integer): TBisSipTimer;
begin
  Result:=TBisSipTimer(inherited Items[Index]);
end;

procedure TBisSipTimers.TerminateAll;
var
  i: Integer;
  Item: TBisSipTimer;
begin
  FLock.Enter;
  try
    for i:=Count-1 downto 0 do begin
      Item:=Items[i];
      Item.FreeOnTerminate:=false;
      Remove(Item);
      Item.Free;
    end;
  finally
    FLock.Leave;
  end;
end;

procedure TBisSipTimers.TimerTerminate(Sender: TObject);
begin
  if Assigned(Sender) then
    Remove(Sender);
end;

function TBisSipTimers.AddMilliSeconds(MilliSeconds: Integer; OnTimer: TBisSipTimerEvent; Data: TObject): TBisSipTimer;
begin
  FLock.Enter;
  try
    Result:=nil;
    if MilliSeconds>0 then begin
      Result:=TBisSipTimer.Create(MilliSeconds,OnTimer);
      Result.FData:=Data;
      Result.OnTerminate:=TimerTerminate;
      inherited Add(Result);
      Result.Resume;
    end;
  finally
    FLock.Leave;
  end;
end;

function TBisSipTimers.AddSeconds(Seconds: Integer; OnTimer: TBisSipTimerEvent; Data: TObject): TBisSipTimer;
begin
  Result:=AddMilliSeconds(Seconds*1000,OnTimer,Data);
end;

function TBisSipTimers.AddMinutes(Minutes: Integer; OnTimer: TBisSipTimerEvent; Data: TObject): TBisSipTimer;
begin
  Result:=AddSeconds(Minutes*60,OnTimer,Data);
end;

procedure TBisSipTimers.RemoveBy(OnTimer: TBisSipTimerEvent; Data: TObject);
var
  i: Integer;
  Item: TBisSipTimer;
begin
  FLock.Enter;
  try
    for i:=Count-1 downto 0 do begin
      Item:=Items[i];
      if (@Item.FOnTimer=@OnTimer) and (Item.FData=Data) then begin
        Item.Terminate; 
        Remove(Item);
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

{ TBisSipReceiver }

constructor TBisSipReceiver.Create;
begin
  inherited Create;
  FID:=GetUniqueID;
end;

destructor TBisSipReceiver.Destroy;
begin
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
//          if AnsiSameText(Registrar.Uri,Uri) then begin
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
    if Assigned(Registrar) and Registrar.Registered then begin
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

    FRegistrar.FWaits.RemoveBy(Request);
    FRequests.Add(Request);
    Result:=true;
    Flag:=false;
    
    case Request.RequestType of
      rtUNKNOWN,rtREGISTER: ;
      rtINVITE: begin
        if FState=ssReady then begin
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
  end;

  procedure ProcessSessionProgress(Request: TBisSipRequest);
  begin
    FState:=ssProgressing;
    FRegistrar.DoSessionProgress(Self);
  end;

  procedure ProcessRinging(Request: TBisSipRequest);
  begin
    FState:=ssRinging;
    FRegistrar.DoSessionRing(Self);
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
      FRegistrar.FWaits.RemoveBy(Request);
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

{ TBisSipMessageWait }

constructor TBisSipMessageWait.Create(TimeOut: Integer; Message: TBisSipMessage);
begin
  inherited Create(true);
  FreeOnTerminate:=true;
  FTimeOut:=TimeOut;
  FMessage:=Message;
//  FInterrupted:=false;
end;

destructor TBisSipMessageWait.Destroy;
begin
  Terminate;
  inherited Destroy;
end;

procedure TBisSipMessageWait.DoTimeOut;
begin
  Inc(FCounter);
  if Assigned(FOnTimeOut) then
    FOnTimeOut(Self);
end;

procedure TBisSipMessageWait.Execute;
var
  T1: Cardinal;
  ATimeOut: Integer;
begin
  if Assigned(FOnTimeOut) then begin
    T1:=GetTickCountEx;
    ATimeOut:=0;
    while not Terminated {and not FInterrupted }do begin
      if (ATimeOut>=FTimeOut) then begin
        Synchronize(DoTimeOut);
        break;
      end else
        Sleep(1);
      ATimeOut:=GetTickCountEx-T1;
    end;
  end;
end;

procedure TBisSipMessageWait.Terminate;
begin
  OnTerminate:=nil;
//  FInterrupted:=true;
  FOnTimeOut:=nil;
  FMessage:=nil;
  inherited Terminate;
end;

{ TBisSipMessageWaits }

constructor TBisSipMessageWaits.Create;
begin
  inherited Create(false);
  FLock:=TCriticalSection.Create;
end;

destructor TBisSipMessageWaits.Destroy;
begin
  TerminateAll;
  FLock.Free;
  inherited Destroy;
end;

function TBisSipMessageWaits.GetItem(Index: Integer): TBisSipMessageWait;
begin
  Result:=TBisSipMessageWait(inherited Items[Index]);
end;

procedure TBisSipMessageWaits.TerminateAll;
var
  i: Integer;
  Item: TBisSipMessageWait;
begin
  FLock.Enter;
  try
    for i:=Count-1 downto 0 do begin
      Item:=TBisSipMessageWait(Items[i]);
      Item.FreeOnTerminate:=false;
      Remove(Item);
      Item.Free;
    end;
  finally
    FLock.Leave;
  end;
end;

function TBisSipMessageWaits.Add(TimeOut: Integer; Message: TBisSipMessage; Counter: Integer=0): TBisSipMessageWait;
begin
  FLock.Enter;
  try
    Result:=TBisSipMessageWait.Create(TimeOut,Message);
    Result.FOnTimeOut:=FOnTimeOut;
    Result.FCounter:=Counter;
    Result.OnTerminate:=FOnTerminate;
    inherited Add(Result);
  finally
    FLock.Leave;
  end;
end;

procedure TBisSipMessageWaits.RemoveBy(Message: TBisSipMessage);
var
  i: Integer;
  Item: TBisSipMessageWait;
begin
  FLock.Enter;
  try
    for i:=Count-1 downto 0 do begin
      Item:=TBisSipMessageWait(Items[i]);
      if Item.FMessage=Message then begin
        Item.Terminate;
        Remove(Item);
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

{ TBisSipRegistrar }

constructor TBisSipRegistrar.Create;
begin
  inherited Create;
  FScheme:=DefaultScheme;
  FProtocol:=DefaultProtocol;

  FWaits:=TBisSipMessageWaits.Create;
  FWaits.OnTimeOut:=WaitsTimeOut;
  FWaits.OnTerminate:=WaitsTerminate;

  FTimers:=TBisSipTimers.Create;

  FRequests:=TBisSipRequests.Create;

  FSessions:=TBisSipSessions.Create(Self);

  FLastRequest:=nil;

  FExpires:=3600;
  FQ:='0.9';
  FMaxForwards:=70;
  FSequence:=0;
  FKeepAlive:=30;
  FKeepAliveQuery:=#13#10#13#10;
  FWaitRetryCount:=5;
  FWaitTimeOut:=3000;
  FSessionIdleTimeOut:=60000;
  FSessionAlive:=1000;

  FUseGlobalSequence:=true;
end;

destructor TBisSipRegistrar.Destroy;
begin
  RemoveReceiver(Self);
  if Assigned(FLastRequest) then begin
    FLastRequest.Free;
    FLastRequest:=nil;
  end;
  FSessions.Free;
  FRequests.Free;
  FTimers.Free;
  FWaits.Free;
  inherited Destroy;
end;

procedure TBisSipRegistrar.AddReceiver(Receiver: TBisSipReceiver);
begin
  if Assigned(FTransport) then
    FTransport.Receivers.Add(Receiver);
end;

procedure TBisSipRegistrar.RemoveReceiver(Receiver: TBisSipReceiver);
begin
  if Assigned(FTransport) then
    FTransport.Receivers.Remove(Receiver);
end;

procedure TBisSipRegistrar.RemoveWaits(Session: TBisSipSession);
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
        FWaits.RemoveBy(Response);
      end;
      FWaits.RemoveBy(Request);
    end;
  end;
end;

function TBisSipRegistrar.GetUri: String;
begin
  Result:=Format('%s%s%s%s%s',[iff(FScheme<>'',FScheme+':',''),
                               iff(FUserName<>'',FUserName+'@',''),
                               iff(FLocalIP<>'',FLocalIP,''),
                               iff(FUsePortInUri and (FLocalPort<>0),':'+IntToStr(FLocalPort),''),
                               iff(FUseTrasnportNameInUri and (TransportName<>''),';transport='+TransportName,'')]);
  Result:=Trim(Result);
end;

function TBisSipRegistrar.CheckUri(Uri: String): Boolean;
var
  S1,S2,S3,S4,S5: String;
begin
  Result:=false;
  if Uri<>'' then begin
    if ParseUri(Uri,S1,S2,S3,S4,S5) then begin
      Result:=AnsiSameText(FScheme,S1);
      if Result and (S2<>'') then begin
        Result:=AnsiSameText(FUserName,S2);
      {  if Result and (S3<>'') then
          Result:=AnsiSameText(FLocalIP,S3); }
      end;
    end;
  end;
end;

function TBisSipRegistrar.DoSessionAccept(Session: TBisSipSession; Message: TBisSipMessage): Boolean;
begin
  Result:=true;
  if Assigned(FOnSessionAccept) then
    Result:=FOnSessionAccept(Self,Session,Message);
end;

function TBisSipRegistrar.DoSessionAlive(Session: TBisSipSession): Boolean;
begin
  Result:=false;
  if Assigned(FOnSessionAlive) then
    Result:=FOnSessionAlive(Self,Session);
end;

procedure TBisSipRegistrar.DoSessionCreate(Session: TBisSipSession);
begin
  if Assigned(FOnSessionCreate) then
    FOnSessionCreate(Self,Session);
end;

procedure TBisSipRegistrar.DoSessionDestroy(Session: TBisSipSession);
begin
  if Assigned(FOnSessionDestroy) then
    FOnSessionDestroy(Self,Session);
end;

procedure TBisSipRegistrar.DoSessionProgress(Session: TBisSipSession);
begin
  if Assigned(FOnSessionProgress) then
    FOnSessionProgress(Self,Session);
end;

procedure TBisSipRegistrar.DoSessionRing(Session: TBisSipSession);
begin
  if Assigned(FOnSessionRing) then
    FOnSessionRing(Self,Session);
end;

procedure TBisSipRegistrar.DoSessionTerminate(Session: TBisSipSession);
begin
  if Assigned(FOnSessionTerminate) then
    FOnSessionTerminate(Self,Session);
end;

procedure TBisSipRegistrar.DoSessionConfirm(Session: TBisSipSession);
begin
  if Assigned(FOnSessionConfirm) then
    FOnSessionConfirm(Self,Session);
end;

procedure TBisSipRegistrar.DoRegister;
begin
  if Assigned(FOnRegister) then
    FOnRegister(Self);
end;

procedure TBisSipRegistrar.DoWaitTimeOut;
begin
  if Assigned(FOnWaitTimeOut) then
    FOnWaitTimeOut(Self);  
end;

function TBisSipRegistrar.GetTransportName: String;
begin
  Result:='';
  if Assigned(FTransport) then
    Result:=FTransport.Name;
end;

function TBisSipRegistrar.NextSequence: String;
begin
  Inc(FSequence);
  Result:=IntToStr(FSequence);
end;

procedure TBisSipRegistrar.SetTransport(const Value: TBisSipTransport);
begin
  RemoveReceiver(Self);
  FTransport:=Value;
  RemoveReceiver(Self);
  AddReceiver(Self);
end;

function TBisSipRegistrar.UriLocalPort: String;
begin
  Result:='';
  if FUsePortInUri then
    Result:=IntToStr(FLocalPort);
end;

function TBisSipRegistrar.UriRemotePort: String;
begin
  Result:='';
  if FUsePortInUri then
    Result:=IntToStr(FRemotePort);
end;

function TBisSipRegistrar.UriTransportName: String;
begin
  Result:='';
  if FUseTrasnportNameInUri then
    Result:=GetTransportName;
end;

procedure TBisSipRegistrar.WaitsTerminate(Sender: TObject);
begin
  if Assigned(Sender) and (Sender is TBisSipMessageWait) then begin
    FWaits.Remove(Sender);
  end;
end;

procedure TBisSipRegistrar.WaitsTimeOut(Sender: TObject);
var
  Wait: TBisSipMessageWait;
begin
  if Assigned(Sender) and (Sender is TBisSipMessageWait) then begin
    Wait:=TBisSipMessageWait(Sender);
    if Assigned(Wait.FMessage) and Assigned(FTransport) then begin
      if Wait.Counter<FWaitRetryCount then begin
        if FTransport.Send(FRemoteIP,FRemotePort,Wait.FMessage.AsString) then
          FWaits.Add(FWaitTimeOut,Wait.FMessage,Wait.Counter).Resume;
      end else begin
        if Wait.FMessage is TBisSipRequest then
          FirstRegister(TBisSipRequest(Wait.FMessage))
        else
          FirstRegister;
        DoWaitTimeOut;
      end;
    end;
  end;
end;

procedure TBisSipRegistrar.SendRequest(Request: TBisSipRequest; WithWait: Boolean=true);
begin
  if Assigned(Request) then begin
    if Assigned(FTransport) then begin
      if FTransport.Send(FRemoteIP,FRemotePort,Request.AsString) and WithWait then
        FWaits.Add(FWaitTimeOut,Request).Resume;
    end;
  end;
end;

procedure TBisSipRegistrar.SendResponse(Response: TBisSipResponse; WithWait: Boolean=false);
begin
  if Assigned(Response) then begin
    if Assigned(FTransport) then begin
      if FTransport.Send(FRemoteIP,FRemotePort,Response.AsString) and WithWait then
        FWaits.Add(FWaitTimeOut,Response).Resume;
    end;
  end;
end;

function TBisSipRegistrar.ReceiveRequest(Request: TBisSipRequest): Boolean;
begin
  Result:=inherited ReceiveRequest(Request);
end;

function TBisSipRegistrar.ReceiveResponse(Response: TBisSipResponse): Boolean;

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
        if FUseReceived and (Trim(ResponseVia.FReceived)<>'') then begin
          Contact.FHost:=ResponseVia.FReceived;
          FLocalIP:=ResponseVia.FReceived;
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
      FWaits.RemoveBy(Request);
      Result:=StrToIntDef(Response.CSeqNum,0)>=FSequence;;
      if Result then begin
        Request.Responses.Add(Response);
        case Response.ResponseKind of
          rkUnauthorized: begin
            if FRegistered then begin
              FRegistered:=false;
              DoRegister;
              FTimers.RemoveBy(SessionTimer);
              FTimers.RemoveBy(KeepAliveTimer);
              FTimers.RemoveBy(RegisterTimer);
            end;
            ProcessUnauthorized(Request);
          end;
          rkOK: begin
            if not FRegistered then begin
              FRegistered:=true;
              DoRegister;
              SendLastRequest;
              FTimers.AddSeconds(FExpires,RegisterTimer);
              FTimers.AddSeconds(FKeepAlive,KeepAliveTimer);
              FTimers.AddMilliSeconds(FSessionAlive,SessionTimer);
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

procedure TBisSipRegistrar.FirstRegister(Request: TBisSipRequest=nil);
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

procedure TBisSipRegistrar.RegisterTimer(Sender: TBisSipTimer);
begin
  Sender.Terminate;
  FirstRegister;
end;

procedure TBisSipRegistrar.KeepAliveTimer(Sender: TBisSipTimer);
begin
  if FRegistered then begin
    if Assigned(FTransport) then begin
      if not FTransport.Send(FRemoteIP,FRemotePort,FKeepAliveQuery) then begin
        Sender.Terminate;
        FirstRegister;
      end;
    end;
  end;
end;

procedure TBisSipRegistrar.SessionTimer(Sender: TBisSipTimer);
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
end;

procedure TBisSipRegistrar.Register(Active: Boolean; Initial: Boolean=false);
var
  Request: TBisSipRequest;
begin
  if Initial then begin
    FSequence:=0;
  end;
  
  if Assigned(FTransport) then begin
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

initialization
  FHeaderClasses:=TClassList.Create;
  with FHeaderClasses do begin
    Add(TBisSipVia);
    Add(TBisSipFrom);
    Add(TBisSipTo);
    Add(TBisSipContact);
    Add(TBisSipPAssertedIdentity);
    Add(TBisSipCallID);
    Add(TBisSipPrivacy);
    Add(TBisSipCSeq);
    Add(TBisSipReason);
    Add(TBisSipOrganization);
    Add(TBisSipUserAgent);
    Add(TBisSipSubject);
    Add(TBisSipAllow);
    Add(TBisSipMaxForwards);
    Add(TBisSipExpires);
    Add(TBisSipContentType);
    Add(TBisSipContentLength);
    Add(TBisSipContentDisposition);
    Add(TBisSipWWWAuthenticate);
    Add(TBisSipProxyAuthenticate);
    Add(TBisSipAuthorization);
    Add(TBisSipProxyAuthorization);
    Add(TBisSipSupported);
    Add(TBisSipDate);
    Add(TBisSipAllowEvents);
    Add(TBisSipXFSSupport);
  end;

  FResponseKinds:=TObjectList.Create;
  with FResponseKinds do begin
    Add(TBisSipResponseKindInfo.Create(rkTrying,100,'Trying'));
    Add(TBisSipResponseKindInfo.Create(rkRinging,180,'Ringing'));
    Add(TBisSipResponseKindInfo.Create(rkCallIsBeingForwarded,181,'Call Is Being Forwarded'));
    Add(TBisSipResponseKindInfo.Create(rkQueued,182,'Queued'));
    Add(TBisSipResponseKindInfo.Create(rkSessionProgress,183,'Session Progress'));
    Add(TBisSipResponseKindInfo.Create(rkOK,200,'OK'));
    Add(TBisSipResponseKindInfo.Create(rkAccepted,202,'Accepted'));
    Add(TBisSipResponseKindInfo.Create(rkMultipleChoices,300,'Multiple Choices'));
    Add(TBisSipResponseKindInfo.Create(rkMovedPermanently,301,'Moved Permanently'));
    Add(TBisSipResponseKindInfo.Create(rkMovedTemporarily,302,'Moved Temporarily'));
    Add(TBisSipResponseKindInfo.Create(rkUseProxy,305,'Use Proxy'));
    Add(TBisSipResponseKindInfo.Create(rkBadRequest,400,'Bad Request'));
    Add(TBisSipResponseKindInfo.Create(rkUnauthorized,401,'Unauthorized'));
    Add(TBisSipResponseKindInfo.Create(rkPaymentRequired,402,'Payment Required'));
    Add(TBisSipResponseKindInfo.Create(rkForbidden,403,'Forbidden'));
    Add(TBisSipResponseKindInfo.Create(rkNotFound,404,'Not Found'));
    Add(TBisSipResponseKindInfo.Create(rkMethodNotAllowed,405,'Method Not Allowed'));
    Add(TBisSipResponseKindInfo.Create(rkNotAcceptableClient,406,'Not Acceptable Client'));
    Add(TBisSipResponseKindInfo.Create(rkProxyAuthenticationRequired,407,'Proxy Authentication Required'));
    Add(TBisSipResponseKindInfo.Create(rkRequestTimeout,408,'Request Timeout'));
    Add(TBisSipResponseKindInfo.Create(rkGone,410,'Gone'));
    Add(TBisSipResponseKindInfo.Create(rkRequestEntityTooLarge,413,'Request Entity Too Large'));
    Add(TBisSipResponseKindInfo.Create(rkRequestURITooLarge,414,'Request URI Too Large'));
    Add(TBisSipResponseKindInfo.Create(rkUnsupportedMediaType,415,'Unsupported Media Type'));
    Add(TBisSipResponseKindInfo.Create(rkUnsupportedURIScheme,416,'Unsupported URI Scheme'));
    Add(TBisSipResponseKindInfo.Create(rkBadExtension,420,'Bad Extension'));
    Add(TBisSipResponseKindInfo.Create(rkExtensionRequired,421,'Extension Required'));
    Add(TBisSipResponseKindInfo.Create(rkIntervalTooBrief,423,'Interval Too Brief'));
    Add(TBisSipResponseKindInfo.Create(rkTemporarilyUnavailable,480,'Temporarily Unavailable'));
    Add(TBisSipResponseKindInfo.Create(rkCallLegOrTransactionDoesNotExist,481,'Call Leg Or Transaction Does Not Exist'));
    Add(TBisSipResponseKindInfo.Create(rkLoopDetected,482,'Loop Detected'));
    Add(TBisSipResponseKindInfo.Create(rkTooManyHops,483,'Too Many Hops'));
    Add(TBisSipResponseKindInfo.Create(rkAddressIncomplete,484,'Address Incomplete'));
    Add(TBisSipResponseKindInfo.Create(rkAmbiguous,485,'Ambiguous'));
    Add(TBisSipResponseKindInfo.Create(rkBusyHere,486,'Busy Here'));
    Add(TBisSipResponseKindInfo.Create(rkRequestTerminated,487,'Request Terminated'));
    Add(TBisSipResponseKindInfo.Create(rkNotAcceptableHere,488,'Not Acceptable Here'));
    Add(TBisSipResponseKindInfo.Create(rkBadEvent,489,'Bad Event'));
    Add(TBisSipResponseKindInfo.Create(rkRequestPending,491,'Request Pending'));
    Add(TBisSipResponseKindInfo.Create(rkUndecipherable,493,'Undecipherable'));
    Add(TBisSipResponseKindInfo.Create(rkInternalServerError,500,'Internal Server Error'));
    Add(TBisSipResponseKindInfo.Create(rkNotImplemented,501,'Not Implemented'));
    Add(TBisSipResponseKindInfo.Create(rkBadGateway,502,'Bad Gateway'));
    Add(TBisSipResponseKindInfo.Create(rkServiceUnavailable,503,'Service Unavailable'));
    Add(TBisSipResponseKindInfo.Create(rkServerTimeOut,504,'Server TimeOut'));
    Add(TBisSipResponseKindInfo.Create(rkSIPVersionNotSupported,505,'SIP Version Not Supported'));
    Add(TBisSipResponseKindInfo.Create(rkMessageTooLarge,513,'Message Too Large'));
    Add(TBisSipResponseKindInfo.Create(rkBusyEverywhere,600,'Busy Everywhere'));
    Add(TBisSipResponseKindInfo.Create(rkDecline,603,'Decline'));
    Add(TBisSipResponseKindInfo.Create(rkDoesNotExistAnywhere,604,'Does Not Exist Anywhere'));
    Add(TBisSipResponseKindInfo.Create(rkNotAcceptableGlobal,606,'Not Acceptable Global'));
  end;

finalization
  FResponseKinds.Free;
  FHeaderClasses.Free;

end.
