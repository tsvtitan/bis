unit BisSipParams;

interface

uses Classes, Contnrs;

type

  TBisSipParam=class(TObject)
  protected
    class function GetName: String; virtual;
    procedure Parse(const Body: String); virtual;
    function AsString: String; virtual;
    procedure CopyFrom(Source: TBisSipParam); virtual;
    function Empty: Boolean; virtual;
  public
    constructor Create;
  end;

  TBisSipParamClass=class of TBisSipParam;

  TBisSipSimpleParam=class(TBisSipParam)
  private
    FValue: String;
  protected
    procedure Parse(const Body: String); override;
  public
    function AsString: String; override;
    procedure CopyFrom(Source: TBisSipParam); override;
  end;

  TBisSipViaParam=class(TBisSipParam)
  private
    FProtocol, FTransport, FHost, FPort: String;
    FRport, FBranch, FReceived: String;
  protected
    procedure Parse(const Body: String); override;
  public
    class function GetName: String; override;
    function AsString: String; override;
    procedure CopyFrom(Source: TBisSipParam); override;

    property Branch: String read FBranch write FBranch;
  end;

  TBisSipFromParam=class(TBisSipParam)
  private
    FDisplay, FScheme, FUser, FHost, FPort: String;
    FTag, FExpires, FQ: String;
    FUriUser, FUriCpc: String;
    function ParamsAsString: String;
  protected
    procedure Parse(const Body: String); override;
  public
    class function GetName: String; override;
    function AsString: String; override;
    procedure CopyFrom(Source: TBisSipParam); override;
    function Empty: Boolean; override;
  end;

  TBisSipToParam=class(TBisSipFromParam)
  public
    class function GetName: String; override;
  end;

  TBisSipContactParam=class(TBisSipFromParam)
  public
    class function GetName: String; override;
  end;

  TBisSipCallIDParam=class(TBisSipSimpleParam)
  public
    class function GetName: String; override;
  end;

  TBisSipCSeqParam=class(TBisSipParam)
  private
    FNum, FRequestName: String;
  protected
    procedure Parse(const Body: String); override;
  public
    class function GetName: String; override;
    function AsString: String; override;
    procedure CopyFrom(Source: TBisSipParam); override;

    property Num: String read FNum write FNum;
    property RequestName: String read FRequestName; 
  end;

  TBisSipUserAgentParam=class(TBisSipSimpleParam)
  public
    class function GetName: String; override;
  end;

// INVITE,ACK,CANCEL,BYE,INFO,PRACK,UPDATE,OPTIONS,REGISTER,REFER,SUBSCRIBE SibirTelecom

  TBisSipAllowType=(atINVITE,atACK,atBYE,atCANCEL,atINFO,atMESSAGE,atPRACK,atUPDATE,atOPTIONS,atREGISTER,atREFER,atSUBSCRIBE);
  TBisSipAllowTypes=set of TBisSipAllowType;

  TBisSipAllowParam=class(TBisSipParam)
  private
    FTypes: TBisSipAllowTypes;
    function GetStringByType(AllowType: TBisSipAllowType): String;
  public
    class function GetName: String; override;
    function AsString: String; override;
  end;

  TBisSipMaxForwardsParam=class(TBisSipSimpleParam)
  public
    class function GetName: String; override;
  end;

  TBisSipExpiresParam=class(TBisSipSimpleParam)
  public
    class function GetName: String; override;
  end;

  TBisSipContentLengthParam=class(TBisSipSimpleParam)
  public
    class function GetName: String; override;
  end;

  TBisSipWWWAuthenticateParam=class(TBisSipParam)
  private
    FAuthorization, FRealm, FNonce, FOpaque, FQop: String;
  protected
    procedure Parse(const Body: String); override;
  public
    class function GetName: String; override;
    procedure CopyFrom(Source: TBisSipParam); override;
  end;

  TBisSipAuthorizationAlgorithm=(aaMD5);

  TBisSipAuthorizationParam=class(TBisSipParam)
  private
    FScheme, FHost, FRequestName: String;
    FAuthorization, FUsername, FPassword, FRealm, FNonce: String;
    FQop, FCnonce, FOpaque: String;
    FAlgorithm: TBisSipAuthorizationAlgorithm;
    function GetStringByAlgorithm(Algorithm: TBisSipAuthorizationAlgorithm): String;
  public
    class function GetName: String; override;
    procedure CopyFrom(Source: TBisSipParam); override;
    function AsString: String; override;
  end;

  TBisSipParams=class(TObjectList)
  private
//    function Find(Name: String): TBisSipParam; overload;
    function GetItem(Index: Integer): TBisSipParam;
  public
    function Find(AClass: TBisSipParamClass): TBisSipParam; overload;

    procedure GetStrings(Strings: TStrings);

    function Add(AClass: TBisSipParamClass): TBisSipParam;
    function AddVia(Protocol, Transport, Host, Port, Branch: String): TBisSipViaParam;
    function AddFrom(Display, Scheme, User, Host, Port, Tag: String): TBisSipFromParam;
    function AddTo(Display, Scheme, User, Host, Port, Tag: String): TBisSipToParam;
    function AddContact(Display, Scheme, User, Host, Port, Tag, Expires, Q: String): TBisSipContactParam; overload;
    function AddContact: TBisSipContactParam; overload;
    function AddCallID(Value: String): TBisSipCallIDParam;
    function AddCSeq(Num, RequestName: String): TBisSipCSeqParam;
    function AddUserAgent(Value: String): TBisSipUserAgentParam;
    function AddAllow(Types: TBisSipAllowTypes): TBisSipAllowParam;
    function AddMaxForwards(Value: String): TBisSipMaxForwardsParam;
    function AddExpires(Value: String): TBisSipExpiresParam;
    function AddContentLength(Value: String): TBisSipContentLengthParam;
    function AddAuthorization(Scheme, Username, Password, Host, RequestName: String): TBisSipAuthorizationParam;

    function ParseParam(const Line: String): TBisSipParam;

    procedure CopyFrom(Source: TBisSipParams; WithClear: Boolean=true);

    property Items[Index: Integer]: TBisSipParam read GetItem; default;
  end;

implementation

uses Windows, SysUtils, TypInfo,
     BisUtils;

var
  FParamClasses: TClassList=nil;

function FindParamClass(AName: String): TBisSipParamClass;
var
  i: Integer;
  AClass: TBisSipParamClass;
begin
  Result:=nil;
  if Assigned(FParamClasses) then begin
    for i:=0 to FParamClasses.Count-1 do begin
      AClass:=TBisSipParamClass(FParamClasses[i]);
      if AnsiSameText(AClass.GetName,AName) then begin
        Result:=AClass;
        exit;
      end;
    end;
  end;
end;

function ParseName(const S, Delim: String; var Name, Value: String): Boolean;
var
  APos: Integer;
begin
  APos:=AnsiPos(Delim,S);
  if APos>0 then begin
    Name:=Copy(S,1,APos-1);
    Value:=Copy(S,APos+Length(Delim),Length(S));
  end else
    Name:=S;
  Result:=(Name<>'') or (Value<>'');
end;

function ParseBetween(const S, LDelim, RDelim: String; var Value: String): Boolean;
var
  APos: Integer;
  S1: String;
begin
  APos:=AnsiPos(LDelim,S);
  if APos>0 then begin
    Value:=Copy(S,1,APos-1);
    S1:=Copy(S,APos+Length(LDelim),Length(S));
    APos:=AnsiPos(RDelim,S1);
    if APos>0 then begin
      Value:=Copy(S1,1,APos-1);
    end else
      Value:=S1;
  end else
    Value:=S;
  Result:=Value<>'';
end;

{ TBisSipParam }

constructor TBisSipParam.Create;
begin
  inherited Create;
end;

function TBisSipParam.Empty: Boolean;
begin
  Result:=AsString='';
end;

function TBisSipParam.AsString: String;
begin
  Result:='';
end;

procedure TBisSipParam.CopyFrom(Source: TBisSipParam);
begin
end;

class function TBisSipParam.GetName: String;
begin
  Result:='';
end;

procedure TBisSipParam.Parse(const Body: String);
begin
end;

{ TBisSipSimpleParam }

function TBisSipSimpleParam.AsString: String;
var
  S: String;
begin
  S:=Format('%s: %s',[GetName,FValue]);
  Result:=Trim(S);
end;

procedure TBisSipSimpleParam.CopyFrom(Source: TBisSipParam);
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipSimpleParam) then
    FValue:=TBisSipSimpleParam(Source).FValue;
end;

procedure TBisSipSimpleParam.Parse(const Body: String);
begin
  FValue:=Body;
end;

{ TBisSipViaParam }

procedure TBisSipViaParam.CopyFrom(Source: TBisSipParam);
var
  ViaSource: TBisSipViaParam;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipViaParam) then begin
    ViaSource:=TBisSipViaParam(Source);

    FProtocol:=ViaSource.FProtocol;
    FTransport:=ViaSource.FTransport;
    FHost:=ViaSource.FHost;
    FPort:=ViaSource.FPort;
    FRport:=ViaSource.FRport;
    FBranch:=ViaSource.FBranch;
    FReceived:=ViaSource.FReceived;
  end;
end;

class function TBisSipViaParam.GetName: String;
begin
  Result:='Via';
end;

procedure TBisSipViaParam.Parse(const Body: String);

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

function TBisSipViaParam.AsString: String;
var
  S: String;
begin
  S:=Format('%s: %s%s %s%s%s%s%s',[GetName,
                                   iff(FProtocol<>'',FProtocol,''),
                                   iff(FTransport<>'','/'+FTransport,''),
                                   iff(FHost<>'',FHost,''),
                                   iff(FPort<>'',':'+FPort,''),
                                   iff(FRport<>'',';rport='+FRport,';rport'),
                                   iff(FBranch<>'',';branch='+FBranch,''),
                                   iff(FReceived<>'',';received='+FReceived,'')]);
  Result:=Trim(S);
end;

{ TBisSipFromParam }

procedure TBisSipFromParam.CopyFrom(Source: TBisSipParam);
var
  FromSource: TBisSipFromParam;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipFromParam) then begin
    FromSource:=TBisSipFromParam(Source);

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
  end;
end;

class function TBisSipFromParam.GetName: String;
begin
  Result:='From';
end;

procedure TBisSipFromParam.Parse(const Body: String);

  procedure ParseUriOther(S: String);
  var
    AName, AValue: String;
  begin
    if ParseName(S,'=',AName,AValue) then begin
      if AnsiSameText(AName,'user') then FUriUser:=AValue;
      if AnsiSameText(AName,'cpc') then FUriCpc:=AValue;
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
begin
  Strings:=TStringList.Create;
  try
    GetStringsByString(Body,';',Strings);
    if Strings.Count>0 then begin
      ParseUri(Strings[0]);
      if Strings.Count>1 then begin
        for i:=1 to Strings.Count-1 do
          ParseOther(Strings[i]);
      end;
    end;
  finally
    Strings.Free;
  end;
end;

function TBisSipFromParam.Empty: Boolean;
begin
  Result:=ParamsAsString='<>';
end;

function TBisSipFromParam.ParamsAsString: String;
begin
  Result:=Format('%s<%s%s%s%s>%s%s%s',[iff(FDisplay<>'','"'+FDisplay+'" ',''),
                                       iff(FScheme<>'',FScheme+':',''),
                                       iff(FUser<>'',FUser+'@',''),
                                       iff(FHost<>'',FHost,''),
                                       iff(FPort<>'',':'+FPort,''),
                                       iff(FTag<>'',';tag='+FTag,''),
                                       iff(FExpires<>'',';expires='+FExpires,''),
                                       iff(FQ<>'',';q='+FQ,'')]);
  Result:=Trim(Result);                                       
end;

function TBisSipFromParam.AsString: String;
var
  S: String;
  S1: String;
begin
  S1:=ParamsAsString;

  if S1='<>' then
    S1:='*';

  S:=Format('%s: %s',[GetName,S1]);
  Result:=Trim(S);
end;

{ TBisSipToParam }

class function TBisSipToParam.GetName: String;
begin
  Result:='To';
end;

{ TBisSipContactParam }

class function TBisSipContactParam.GetName: String;
begin
  Result:='Contact';
end;

{ TBisSipCallIDParam }

class function TBisSipCallIDParam.GetName: String;
begin
  Result:='Call-ID';
end;

{ TBisSipCSeqParam }

procedure TBisSipCSeqParam.CopyFrom(Source: TBisSipParam);
var
  CSeqSource: TBisSipCSeqParam;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipCSeqParam) then begin
    CSeqSource:=TBisSipCSeqParam(Source);

    FNum:=CSeqSource.FNum;
    FRequestName:=CSeqSource.FRequestName;
  end;
end;

class function TBisSipCSeqParam.GetName: String;
begin
  Result:='CSeq';
end;

procedure TBisSipCSeqParam.Parse(const Body: String);
begin
  ParseName(Body,' ',FNum,FRequestName);
end;

function TBisSipCSeqParam.AsString: String;
var
  S: String;
begin
  S:=Format('%s: %s %s',[GetName,
                         iff(FNum<>'',FNum,''),
                         iff(FRequestName<>'',FRequestName,'')]);
  Result:=Trim(S);
end;

{ TBisSipUserAgentParam }

class function TBisSipUserAgentParam.GetName: String;
begin
  Result:='User-Agent';
end;

{ TBisSipAllowParam }

class function TBisSipAllowParam.GetName: String;
begin
  Result:='Allow';
end;

function TBisSipAllowParam.GetStringByType(AllowType: TBisSipAllowType): String;
var
  S: String;
begin
  S:=GetEnumName(TypeInfo(TBisSipAllowType),Integer(AllowType));
  Result:=Copy(S,3,Length(S));
end;

function TBisSipAllowParam.AsString: String;
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
    S:=Format('%s: %s',[GetName,S]);

  Result:=Trim(S);
end;

{ TBisSipMaxForwardsParam }

class function TBisSipMaxForwardsParam.GetName: String;
begin
  Result:='Max-Forwards';
end;

{ TBisSipExpiresParam }

class function TBisSipExpiresParam.GetName: String;
begin
  Result:='Expires';
end;

{ TBisSipContentLengthParam }

class function TBisSipContentLengthParam.GetName: String;
begin
  Result:='Content-Length';
end;

{ TBisSipWWWAuthenticateParam }

procedure TBisSipWWWAuthenticateParam.CopyFrom(Source: TBisSipParam);
var
  AuthenticateSource: TBisSipWWWAuthenticateParam;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisSipWWWAuthenticateParam) then begin
    AuthenticateSource:=TBisSipWWWAuthenticateParam(Source);

    FAuthorization:=AuthenticateSource.FAuthorization;
    FRealm:=AuthenticateSource.FRealm;
    FNonce:=AuthenticateSource.FNonce;
    FOpaque:=AuthenticateSource.FOpaque;
    FQop:=AuthenticateSource.FQop;
  end;
end;

class function TBisSipWWWAuthenticateParam.GetName: String;
begin
  Result:='WWW-Authenticate';
end;

procedure TBisSipWWWAuthenticateParam.Parse(const Body: String);
var
  AParams: String;
  Strings: TStringList;
  i: Integer;
  AName,AValue: String;
  S: String;
begin
  if ParseName(Body,' ',FAuthorization,AParams) then begin
    Strings:=TStringList.Create;
    try
      GetStringsByString(AParams,',',Strings);
      for i:=0 to Strings.Count-1 do begin
        if ParseName(Strings[i],'=',AName,AValue) then begin
          ParseBetween(AValue,'"','"',S);
          if AnsiSameText(AName,'realm') then FRealm:=S;
          if AnsiSameText(AName,'nonce') then FNonce:=S;
          if AnsiSameText(AName,'opaque') then FOpaque:=S;
          if AnsiSameText(AName,'qop') then FQop:=S;
        end;
      end;
    finally
      Strings.Free;
    end;
  end;
end;

{ TBisSipAuthorizationParam }

procedure TBisSipAuthorizationParam.CopyFrom(Source: TBisSipParam);
var
  AuthorizationSource: TBisSipAuthorizationParam;
  AuthenticateSource: TBisSipWWWAuthenticateParam;
begin
  inherited CopyFrom(Source);
  if Assigned(Source) then begin

    if (Source is TBisSipAuthorizationParam) then begin
      AuthorizationSource:=TBisSipAuthorizationParam(Source);

      FScheme:=AuthorizationSource.FScheme;
      FHost:=AuthorizationSource.FHost;
      FAuthorization:=AuthorizationSource.FAuthorization;
      FUsername:=AuthorizationSource.FUsername;
      FPassword:=AuthorizationSource.FPassword;
      FRealm:=AuthorizationSource.FRealm;
      FNonce:=AuthorizationSource.FNonce;
      FQop:=AuthorizationSource.FQop;
      FCnonce:=AuthorizationSource.FCnonce;
      FOpaque:=AuthorizationSource.FOpaque;
      FAlgorithm:=AuthorizationSource.FAlgorithm;
    end;

    if Source is TBisSipWWWAuthenticateParam then begin
      AuthenticateSource:=TBisSipWWWAuthenticateParam(Source);

      FAuthorization:=AuthenticateSource.FAuthorization;
      FRealm:=AuthenticateSource.FRealm;
      FNonce:=AuthenticateSource.FNonce;
      FQop:=AuthenticateSource.FQop;
      FCnonce:=AuthenticateSource.FOpaque;
      FOpaque:=AuthenticateSource.FOpaque;
    end;

  end;
end;

class function TBisSipAuthorizationParam.GetName: String;
begin
  Result:='Authorization';
end;

function TBisSipAuthorizationParam.GetStringByAlgorithm(Algorithm: TBisSipAuthorizationAlgorithm): String;
var
  S: String;
begin
  S:=GetEnumName(TypeInfo(TBisSipAuthorizationAlgorithm),Integer(Algorithm));
  Result:=Copy(S,3,Length(S));
end;

function TBisSipAuthorizationParam.AsString: String;

  function GetResponse(Uri, Nc: String): String;
  var
    A1, A2: String;
  begin
    Result:='';
    case FAlgorithm of
      aaMD5: begin
        A1:=Format('%s:%s:%s',[FUsername,FRealm,FPassword]);
        A1:=AnsiLowerCase(MD5(A1));
        A2:=Format('%s:%s',[FRequestName,Uri]);
        A2:=AnsiLowerCase(MD5(A2));
        Result:=Format('%s:%s:%s:%s:auth:%s',[A1,FNonce,Nc,FOpaque,A2]);
        Result:=AnsiLowerCase(MD5(Result));
      end;
    end;
  end;

var
  S: String;
  Uri: String;
  Nc: String;
  Response: String;
  Algorithm: String;
begin
  Uri:=Format('%s%s',[iff(FScheme<>'',FScheme+':',''),iff(FHost<>'',FHost,'')]);
  Nc:='00000001';
  Response:=GetResponse(Uri,Nc);
  Algorithm:=GetStringByAlgorithm(FAlgorithm);
  S:=Format('%s: %s %s%s%s%s%s%s%s%s%s%s',[GetName,
                                           iff(FAuthorization<>'',FAuthorization,''),
                                           iff(FUsername<>'','username="'+FUsername+'"',''),
                                           iff(FRealm<>'',',realm="'+FRealm+'"',''),
                                           iff(FNonce<>'',',nonce="'+FNonce+'"',''),
                                           iff(Uri<>'',',uri="'+Uri+'"',''),
                                           iff(Response<>'',',response="'+Response+'"',''),
                                           iff(FQop<>'',',qop="'+FQop+'"',''),
                                           iff(FCnonce<>'',',cnonce="'+FCnonce+'"',''),
                                           iff(Nc<>'',',nc='+Nc,''),
                                           iff(FOpaque<>'',',opaque="'+FOpaque+'"',''),
                                           iff(Algorithm<>'',',algorithm='+Algorithm,'')]);
  Result:=Trim(S);
end;

{ TBisSipParams }

{function TBisSipParams.Find(Name: String): TBisSipParam;
var
  i: Integer;
  Item: TBisSipParam;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.GetName,Name) then begin
      Result:=Item;
      exit;
    end;
  end;
end;}

function TBisSipParams.Find(AClass: TBisSipParamClass): TBisSipParam;
var
  i: Integer;
  Item: TBisSipParam;
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

function TBisSipParams.GetItem(Index: Integer): TBisSipParam;
begin
  Result:=TBisSipParam(inherited Items[Index]);
end;

procedure TBisSipParams.GetStrings(Strings: TStrings);
var
  i: Integer;
  S: String;
  Item: TBisSipParam;
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

function TBisSipParams.Add(AClass: TBisSipParamClass): TBisSipParam;
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

function TBisSipParams.AddVia(Protocol, Transport, Host, Port, Branch: String): TBisSipViaParam;
begin
  Result:=TBisSipViaParam(Add(TBisSipViaParam));
  if Assigned(Result) then begin
    Result.FProtocol:=Protocol;
    Result.FTransport:=Transport;
    Result.FHost:=Host;
    Result.FPort:=Port;
    Result.FBranch:=Branch;
  end;
end;

function TBisSipParams.AddFrom(Display, Scheme, User, Host, Port, Tag: String): TBisSipFromParam;
begin
  Result:=TBisSipFromParam(Add(TBisSipFromParam));
  if Assigned(Result) then begin
    Result.FDisplay:=Display;
    Result.FScheme:=Scheme;
    Result.FUser:=User;
    Result.FHost:=Host;
    Result.FPort:=Port;
    Result.FTag:=Tag;
  end;
end;

function TBisSipParams.AddTo(Display, Scheme, User, Host, Port, Tag: String): TBisSipToParam;
begin
  Result:=TBisSipToParam(Add(TBisSipToParam));
  if Assigned(Result) then begin
    Result.FDisplay:=Display;
    Result.FScheme:=Scheme;
    Result.FUser:=User;
    Result.FHost:=Host;
    Result.FPort:=Port;
    Result.FTag:=Tag;
  end;
end;

function TBisSipParams.AddContact(Display, Scheme, User, Host, Port, Tag, Expires, Q: String): TBisSipContactParam;
begin
  Result:=AddContact;
  if Assigned(Result) then begin
    Result.FDisplay:=Display;
    Result.FScheme:=Scheme;
    Result.FUser:=User;
    Result.FHost:=Host;
    Result.FPort:=Port;
    Result.FTag:=Tag;
    Result.FExpires:=Expires;
    Result.FQ:=Q;
  end;
end;

function TBisSipParams.AddContact: TBisSipContactParam;
begin
  Result:=TBisSipContactParam(Add(TBisSipContactParam));
end;

function TBisSipParams.AddCallID(Value: String): TBisSipCallIDParam;
begin
  Result:=TBisSipCallIDParam(Add(TBisSipCallIDParam));
  if Assigned(Result) then begin
    Result.FValue:=Value;
  end;
end;

function TBisSipParams.AddCSeq(Num, RequestName: String): TBisSipCSeqParam;
begin
  Result:=TBisSipCSeqParam(Add(TBisSipCSeqParam));
  if Assigned(Result) then begin
    Result.FNum:=Num;
    Result.FRequestName:=RequestName;
  end;
end;

function TBisSipParams.AddUserAgent(Value: String): TBisSipUserAgentParam;
begin
  Result:=TBisSipUserAgentParam(Add(TBisSipUserAgentParam));
  if Assigned(Result) then begin
    Result.FValue:=Value;
  end;
end;

function TBisSipParams.AddAllow(Types: TBisSipAllowTypes): TBisSipAllowParam;
begin
  Result:=TBisSipAllowParam(Add(TBisSipAllowParam));
  if Assigned(Result) then begin
    Result.FTypes:=Types;
  end;
end;

function TBisSipParams.AddMaxForwards(Value: String): TBisSipMaxForwardsParam;
begin
  Result:=TBisSipMaxForwardsParam(Add(TBisSipMaxForwardsParam));
  if Assigned(Result) then begin
    Result.FValue:=Value;
  end;
end;

function TBisSipParams.AddExpires(Value: String): TBisSipExpiresParam;
begin
  Result:=TBisSipExpiresParam(Add(TBisSipExpiresParam));
  if Assigned(Result) then begin
    Result.FValue:=Value;
  end;
end;

function TBisSipParams.AddContentLength(Value: String): TBisSipContentLengthParam;
begin
  Result:=TBisSipContentLengthParam(Add(TBisSipContentLengthParam));
  if Assigned(Result) then begin
    Result.FValue:=Value;
  end;
end;

function TBisSipParams.AddAuthorization(Scheme, Username, Password, Host, RequestName: String): TBisSipAuthorizationParam;
begin
  Result:=TBisSipAuthorizationParam(Add(TBisSipAuthorizationParam));
  if Assigned(Result) then begin
    Result.FScheme:=Scheme;
    Result.FUsername:=Username;
    Result.FPassword:=Password;
    Result.FHost:=Host;
    Result.FRequestName:=RequestName;
  end;
end;

function TBisSipParams.ParseParam(const Line: String): TBisSipParam;
var
  Name, Body: String;
  AClass: TBisSipParamClass;
begin
  Result:=nil;
  if ParseName(Line,':',Name,Body) then begin
    AClass:=FindParamClass(Name);
    if Assigned(AClass) then begin
      Result:=AClass.Create;
      Result.Parse(Trim(Body));
      inherited Add(Result);
    end;
  end;
end;

procedure TBisSipParams.CopyFrom(Source: TBisSipParams; WithClear: Boolean);
var
  i: Integer;
  Param: TBisSipParam;
  NewParam: TBisSipParam;
begin
  if WithClear then
    Clear;
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Param:=Source[i];
      NewParam:=Add(TBisSipParamClass(Param.ClassType));
      if Assigned(NewParam) then
        NewParam.CopyFrom(Param);
    end;
  end;
end;

initialization
  FParamClasses:=TClassList.Create;
  with FParamClasses do begin
    Add(TBisSipViaParam);
    Add(TBisSipFromParam);
    Add(TBisSipToParam);
    Add(TBisSipContactParam);
    Add(TBisSipCallIDParam);
    Add(TBisSipCSeqParam);
    Add(TBisSipUserAgentParam);
    Add(TBisSipAllowParam);
    Add(TBisSipMaxForwardsParam);
    Add(TBisSipExpiresParam);
    Add(TBisSipContentLengthParam);
    Add(TBisSipWWWAuthenticateParam);
    Add(TBisSipAuthorizationParam);
  end;

finalization
  FParamClasses.Free;

end.
