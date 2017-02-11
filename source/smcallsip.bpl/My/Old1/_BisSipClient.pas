unit BisSipClient;

interface

uses Windows, Classes, Contnrs,

     IdGlobal, IdSocketHandle,
     IdUDPServer;

type
  TBisSipClient=class;

  TBisSipUdpServer=class(TIdUDPServer)
  private
    FParent: TBisSipClient;
  protected
    procedure DoUDPRead(AData: TIdBytes; ABinding: TIdSocketHandle); override;
  public
    constructor Create(AOwner: TComponent); reintroduce;
  end;


  TBisSipParam=class(TObject)
  protected
    class function GetName: String; virtual; abstract;
  public
    constructor Create;
    function AsString: String;
  end;

  TBisSipParamClass=class of TBisSipParam;

  TBisSipViaParam=class(TBisSipParam)
  protected
    class function GetName: String; override;
  end;

  TBisSipParams=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisSipParam;
  public
    function Find(Name: String): TBisSipParam;
    procedure GetStrings(Strings: TStrings);

    function Add(AClass: TBisSipParamClass): TBisSipParam;
    function AddVia(Protocol, Transport, Host, Port: String): TBisSipViaParam;

    property Items[Index: Integer]: TBisSipParam read GetItem; default;
  end;

  TBisSipMessage=class(TObject)
  private
    FParams: TBisSipParams;
  protected
    class function GetName: String; virtual; abstract;
    function GetHeader: String; virtual;
  public
    constructor Create;
    destructor Destroy; override;

    function AsString: String;

    property Params: TBisSipParams read FParams;
  end;

  TBisSipMessages=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisSipMessage;
  public
    property Items[Index: Integer]: TBisSipMessage read GetItem; default;
  end;

  TBisSipRequest=class(TBisSipMessage)
  private
    FScheme, FUser, FHost, FPort, FProtocol: String;
  protected
    function GetHeader: String; override;
  public
    constructor Create(Scheme, User, Host, Port, Protocol: String);
  end;

  TBisSipRegisterRequest=class(TBisSipRequest)
  protected
    class function GetName: String; override;
  end;

  TBisSipClient=class(TComponent)
  private
    FPassword: String;
    FUserName: String;
    FLocalHost: String;
    FLocalPort: Integer;
    FUserAgent: String;
    FRegistered: Boolean;
    FRemotePort: Integer;
    FRemoteHost: String;
    FUdpServer: TBisSipUdpServer;
    FRequests: TBisSipMessages;
    FScheme: String;
    FProtocol: String;
    FTransport: String; 
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Register;
    procedure UnRegister;

    property Registered: Boolean read FRegistered;
    property Scheme: String read FScheme;
    property Protocol: String read FProtocol;
    property Transport: String read FTransport;   

    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property UserAgent: String read FUserAgent write FUserAgent;
    property LocalHost: String read FLocalHost write FLocalHost;
    property LocalPort: Integer read FLocalPort write FLocalPort;
    property RemoteHost: String read FRemoteHost write FRemoteHost;
    property RemotePort: Integer read FRemotePort write FRemotePort;

  end;

implementation

uses SysUtils, Dialogs;

function Iff(IsTrue: Boolean; ValueTrue, ValueFalse: Variant): Variant;
begin
  if IsTrue then Result:=ValueTrue
  else Result:=ValueFalse;
end;

{ TBisSipUdpServer }

constructor TBisSipUdpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ThreadedEvent:=true;
end;

procedure TBisSipUdpServer.DoUDPRead(AData: TIdBytes; ABinding: TIdSocketHandle);
begin
  inherited DoUDPRead(AData,ABinding);

end;

{ TBisSipParam }

constructor TBisSipParam.Create;
begin
  inherited Create;
end;

function TBisSipParam.AsString: String;
begin
  Result:='';
end;

{ TBisSipViaParam }

class function TBisSipViaParam.GetName: String;
begin
  Result:='Via';
end;

{ TBisSipParams }

function TBisSipParams.Find(Name: String): TBisSipParam;
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
end;

function TBisSipParams.GetItem(Index: Integer): TBisSipParam;
begin
  Result:=TBisSipParam(inherited Items[Index]);
end;

procedure TBisSipParams.GetStrings(Strings: TStrings);
var
  i: Integer;
  Item: TBisSipParam;
begin
  if Assigned(Strings) then begin
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      Strings.Add(Item.AsString);
    end;
  end;
end;

function TBisSipParams.Add(AClass: TBisSipParamClass): TBisSipParam;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    Result:=Find(AClass.GetName);
    if not Assigned(Result) then begin
      Result:=AClass.Create;
      inherited Add(Result);
    end;
  end;
end;

function TBisSipParams.AddVia(Protocol, Transport, Host, Port: String): TBisSipViaParam;
begin

end;

{ TBisSipMessage }

constructor TBisSipMessage.Create;
begin
  inherited Create;
  FParams:=TBisSipParams.Create;
end;

destructor TBisSipMessage.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

function TBisSipMessage.GetHeader: String;
begin
  Result:='';
end;

function TBisSipMessage.AsString: String;
var
  Strings: TStringList;
begin
  Strings:=TStringList.Create;
  try
    Strings.Add(GetHeader);
    FParams.GetStrings(Strings);
    Result:=Trim(Strings.Text);
  finally
    Strings.Free;
  end;
end;

{ TBisSipMessages }

function TBisSipMessages.GetItem(Index: Integer): TBisSipMessage;
begin
  Result:=TBisSipMessage(inherited Items[Index]);
end;

{ TBisSipRequest }

constructor TBisSipRequest.Create(Scheme, User, Host, Port, Protocol: String);
begin
  inherited Create;
  FScheme:=Scheme;
  FUser:=User;
  FHost:=Host;
  FPort:=Port;
  FProtocol:=Protocol;
end;

function TBisSipRequest.GetHeader: String;
begin
  Result:=Trim(Format('%s %s%s%s%s %s',[GetName,
                                        iff(FScheme<>'',FScheme+':',''),
                                        iff(FUser<>'',FUser+'@',''),
                                        iff(FHost<>'',FHost,''),
                                        iff(FPort<>'',':'+FPort,''),
                                        iff(FProtocol<>'',FProtocol,'')]));
end;

{ TBisSipRegisterRequest }

class function TBisSipRegisterRequest.GetName: String;
begin
  Result:='REGISTER';
end;

{ TBisSipClient }

constructor TBisSipClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  FScheme:='sip';
  FProtocol:='SIP/2.0';
  FTransport:='UDP';

  FUserAgent:=Copy(ClassName,5,MaxInt);

  FUdpServer:=TBisSipUdpServer.Create(nil);
  FUdpServer.FParent:=Self;

  FRequests:=TBisSipMessages.Create;
end;

destructor TBisSipClient.Destroy;
begin
  UnRegister;
  FRequests.Free;
  FUdpServer.Free;
  inherited Destroy;
end;

procedure TBisSipClient.Register;
var
  Request: TBisSipRegisterRequest;
begin
  UnRegister;
  if not FRegistered then begin
    Request:=TBisSipRegisterRequest.Create(FScheme,'',FRemoteHost,'',FProtocol);
    FRequests.Add(Request);
    FUdpServer.Send(FRemoteHost,FRemotePort,Request.AsString);
  end;
end;

procedure TBisSipClient.UnRegister;
begin
  if FRegistered then begin

  end;
end;

end.
