unit BisSip;

interface

uses Classes, Contnrs,
     BisLocks;

type

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

  TBisSipHeader=class(TObject)
  protected
    class function GetName: String; virtual;
    procedure Parse(const Body: String); virtual;
    function AsString: String; virtual;
    function Empty: Boolean; virtual;
    function NameEqual: String; virtual;
  public
    constructor Create;
    procedure CopyFrom(Source: TBisSipHeader); virtual;

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

    property Host: String read FHost write FHost; 
    property Rport: String read FRport write FRport;
    property Branch: String read FBranch write FBranch;
    property Received: String read FReceived write FReceived;  
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

    property Tag: String read FTag write FTag;
    property Host: String read FHost write FHost; 
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

  TBisSipDiversion=class(TBisSipFrom)
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

  TBisSipMessage=class(TBisLock)
  private
    FHeaders: TBisSipHeaders;
    FBody: TBisSipBody;
    function GetCSeqNum: String;
    procedure SetCSeqNum(const Value: String);
  protected
    procedure GetHeader(Strings: TStrings); virtual;
    procedure GetBody(Strings: TStrings); virtual;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisSipMessage); virtual;

    function AsString: String;

    property Headers: TBisSipHeaders read FHeaders;
    property Body: TBisSipBody read FBody;

    property CSeqNum: String read GetCSeqNum write SetCSeqNum;
  end;

  TBisSipMessageClass=class of TBisSipMessage;

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

  TBisSipMessages=class(TBisLocks)
  private
    function GetItem(Index: Integer): TBisSipMessage;
  public
    constructor Create; override;

    property Items[Index: Integer]: TBisSipMessage read GetItem; default;

  end;

  TBisSipResponses=class(TBisSipMessages)
  private
    function GetItem(Index: Integer): TBisSipResponse;
  public
    function FindByKind(ResponseKind: TBisSipResponseKind): TBisSipResponse;
    function LockFindByKind(ResponseKind: TBisSipResponseKind): TBisSipResponse;

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
    function FindBy(Sequence,RequestName: String): TBisSipRequest;
    function FindByType(RequestType: TBisSipRequestType): TBisSipRequest;
    function LockFindByType(RequestType: TBisSipRequestType): TBisSipRequest;
    function GetRequest(Response: TBisSipResponse): TBisSipRequest;
    function LockGetRequest(Response: TBisSipResponse): TBisSipRequest;
//    function Exists(Request: TBisSipRequest): Boolean;

    property Items[Index: Integer]: TBisSipRequest read GetItem; default;
  end;

function FindResponseKindInfo(ResponseKind: TBisSipResponseKind): TBisSipResponseKindInfo;
function ParseUri(const Uri: String; var Scheme, User, Host, Port, Transport: String): Boolean;

implementation

uses Windows, SysUtils, TypInfo,
     BisUtils, BisCryptUtils;

var
  FHeaderClasses: TClassList=nil;
  FResponseKinds: TObjectList=nil;

{ TBisSipResponseKindInfo }

constructor TBisSipResponseKindInfo.Create(Kind: TBisSipResponseKind; Code: Integer; Description: String);
begin
  inherited Create;
  FKind:=Kind;
  FCode:=IntToStr(Code);
  FDescription:=Description
end;

function FindResponseKindInfo(ResponseKind: TBisSipResponseKind): TBisSipResponseKindInfo;
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

{ TBisSipDiversion }

class function TBisSipDiversion.GetName: String;
begin
  Result:='Diversion';
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
begin
  Create(Direction,Name,'','','','',Protocol,'');
  ParseUri(Uri,FScheme,FUser,FHost,FPort,FTransport);
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

function TBisSipResponses.LockFindByKind(ResponseKind: TBisSipResponseKind): TBisSipResponse;
begin
  Lock;
  try
    Result:=FindByKind(ResponseKind);
  finally
    UnLock;
  end;
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

{function TBisSipRequests.Exists(Request: TBisSipRequest): Boolean;
begin
  Result:=IndexOf(Request)<>-1;
end;}

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

function TBisSipRequests.LockFindByType(RequestType: TBisSipRequestType): TBisSipRequest;
begin
  Lock;
  try
    Result:=FindByType(RequestType); 
  finally
    UnLock;
  end;
end;

function TBisSipRequests.LockGetRequest(Response: TBisSipResponse): TBisSipRequest;
begin
  Lock;
  try
    Result:=GetRequest(Response);
  finally
    UnLock;
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
    Add(TBisSipDiversion);
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
