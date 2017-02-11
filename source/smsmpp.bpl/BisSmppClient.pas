unit BisSmppClient;

interface

uses Classes, SysUtils, Contnrs, SyncObjs,
     IdCustomTCPServer, IdTCPClient, IdSocketHandle, IdContext,
     BisSmpp, BisThreads, BisLocks;

type
  TBisSmppClient=class;

  TBisSmppClientTransport=class(TIdTCPClient)
  private
    FClient: TBisSmppClient;
    FLock: TBisLock;
  protected
    procedure DoOnDisconnected; override;
  public
    constructor Create(Client: TBisSmppClient); reintroduce;
    destructor Destroy; override;
    procedure DisconnectNotifyPeer; override;
    function SendData(Data: TBytes): Boolean;
    function RecvData(var Data: TBytes; const TimeOut: Integer): Boolean;
    function DataExists: Boolean;
  end;

  TBisSmppRequests=class(TBisLocks)
  end;
  
  TBisSmppClientMode=(cmTransmitter,cmReceiver,cmTransceiver);

  TBisSmppClientEvent=procedure (Sender: TBisSmppClient) of object;
  TBisSmppClientErrorEvent=procedure (Sender: TBisSmppClient; const Message: String) of object;
  TBisSmppClientRequestEvent=procedure (Sender: TBisSmppClient; Request: TBisSmppRequest) of object;
  TBisSmppClientResponseEvent=procedure (Sender: TBisSmppClient; Response: TBisSmppResponse) of object;

  TBisSmppClient=class(TComponent)
  private
    FTransport: TBisSmppClientTransport;
    FThread: TBisWaitThread;
    FRequests: TBisSmppRequests;
    FHost: String;
    FPort: Integer;
    FSystemId: String;
    FPassword: String;
    FSystemType: String;
    FMode: TBisSmppClientMode;
    FTypeOfNumber: TBisSmppTypeOfNumber;
    FPlanIndicator: TBisSmppNumberingPlanIndicator;
    FRange: String;
    FBound: Boolean;
    FConnected: Boolean;
    FSequenceNumber: Cardinal;
    FOnError: TBisSmppClientErrorEvent;
    FOnConnect: TBisSmppClientEvent;
    FOnDisconnect: TBisSmppClientEvent;
    FOnRequest: TBisSmppClientRequestEvent;
    FOnResponse: TBisSmppClientResponseEvent;
    FCheckTimeout: Cardinal;
    FAutoReconnect: Boolean;
    FReadTimeout: Integer;
    FIP: String;

    function GetConnected: Boolean;
    function TransportConnected: Boolean;
    function GetStatusDesc(Message: TBisSmppMessage): String;
    function Success(Response: TBisSmppResponse): Boolean;
    function CreateMessage(Data: TBytes): TBisSmppMessage;

    function ProcessRequest(Request: TBisSmppRequest): Boolean;
    function SendResponse(Response: TBisSmppResponse): Boolean;
    function SendRequest(Request: TBisSmppRequest): Boolean;
    function RecvResponse(var Response: TBisSmppResponse): Boolean;

    procedure Bind;
    procedure UnBind;
    procedure SetTransportReadTimeout(const Value: Integer);
    function SendWait(Request: TBisSmppRequest; ResponseClass: TBisSmppResponseClass): Boolean;

    procedure ThreadTimeout(Thread: TBisWaitThread);
  protected
    procedure DoConnect;
    procedure DoDisconnect;
    procedure DoError(const Message: String);
    procedure DoRequest(Request: TBisSmppRequest);
    procedure DoResponse(Response: TBisSmppResponse);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;

    function Send(Request: TBisSmppSubmitSmRequest): Boolean; overload;
    function Send(Request: TBisSmppSubmitMultiRequest): Boolean; overload;
    function Send(Request: TBisSmppQuerySmRequest): Boolean; overload;
    function Send(Request: TBisSmppCancelSmRequest): Boolean; overload;

    property Connected: Boolean read GetConnected;
    property Bound: Boolean read FBound;
    property IP: String read FIP;

    property Host: String read FHost write FHost;
    property Port: Integer read FPort write FPort;
    property SystemId: String read FSystemId write FSystemId;
    property Password: String read FPassword write FPassword;
    property SystemType: String read FSystemType write FSystemType;
    property TypeOfNumber: TBisSmppTypeOfNumber read FTypeOfNumber write FTypeOfNumber;
    property PlanIndicator: TBisSmppNumberingPlanIndicator read FPlanIndicator write FPlanIndicator;
    property Range: String read FRange write FRange;
    property Mode: TBisSmppClientMode read FMode write FMode;
    property TransportReadTimeout: Integer read FReadTimeout write SetTransportReadTimeout;
    property CheckTimeout: Cardinal read FCheckTimeout write FCheckTimeout;
    property AutoReconnect: Boolean read FAutoReconnect write FAutoReconnect; 

    property OnConnect: TBisSmppClientEvent read FOnConnect write FOnConnect;
    property OnDisconnect: TBisSmppClientEvent read FOnDisconnect write FOnDisconnect;
    property OnError: TBisSmppClientErrorEvent read FOnError write FOnError;
    property OnRequest: TBisSmppClientRequestEvent read FOnRequest write FOnRequest;
    property OnResponse: TBisSmppClientResponseEvent read FOnResponse write FOnResponse;
  end;

implementation

uses Windows, DateUtils,
     IdGlobal, IdStack, IdExceptionCore, IdIOHandlerSocket,
     BisUtils, BisNetUtils;

const
  MaxSequenceNumber=$7FFFFFFF;

{ TBisSmppClientTransport }

constructor TBisSmppClientTransport.Create(Client: TBisSmppClient);
begin
  inherited Create(nil);
  FClient:=Client;
  FLock:=TBisLock.Create;
end;

destructor TBisSmppClientTransport.Destroy;
begin
  FLock.Free;
  inherited Destroy;
end;

function TBisSmppClientTransport.DataExists: Boolean;
begin
  Result:=false;
  if Assigned(FIOHandler) then
    Result:=not FIOHandler.InputBufferIsEmpty;
end;

procedure TBisSmppClientTransport.DisconnectNotifyPeer;
begin
  inherited DisconnectNotifyPeer;
  if Assigned(FIOHandler) then
    FIOHandler.InputBuffer.Clear;
end;

procedure TBisSmppClientTransport.DoOnDisconnected;
begin
  inherited DoOnDisconnected;
  FClient.FConnected:=false;
end;

{function TBisSmppClientTransport.IP: String;
var
  B: TIdSocketHandle;
begin
  Result:='';
  if Assigned(FIOHandler) and (FIOHandler is TIdIOHandlerSocket) then begin
    B:=TIdIOHandlerSocket(FIOHandler).Binding;
    if Assigned(B) then
      Result:=B.IP;
  end;
end;}

function TBisSmppClientTransport.SendData(Data: TBytes): Boolean;
var
  Size: Cardinal;
  DSize: TBytes;
begin
  Result:=false;
  if Assigned(FIOHandler) then begin
    FLock.Lock;
    try
      if FIOHandler.Connected then begin

        SetLength(DSize,SizeOf(Cardinal));
        Size:=Length(Data)+SizeOf(DSize);
        Move(Size,Pointer(DSize)^,Length(DSize));
        InvertBytes(DSize);

        FIOHandler.WriteBufferOpen;
        FIOHandler.Write(DSize);
        FIOHandler.Write(Data);
        FIOHandler.WriteBufferClose;

        Result:=FIOHandler.Connected;
      end;
    finally
      FLock.UnLock;
    end;
  end;
end;

function TBisSmppClientTransport.RecvData(var Data: TBytes; const TimeOut: Integer): Boolean;
var
  Size: Cardinal;
  DSize: TBytes;
begin
  Result:=false;
  if Assigned(FIOHandler) then begin
    FLock.Lock;
    try
      if FIOHandler.Connected then begin
        FIOHandler.ReadTimeout:=TimeOut;

        FIOHandler.ReadBytes(DSize,SizeOf(Size));
        InvertBytes(DSize);
        Move(Pointer(DSize)^,Size,Length(DSize));
        FIOHandler.ReadBytes(Data,Size-SizeOf(Size));

        Result:=FIOHandler.Connected;
      end;
    finally
      FLock.UnLock;
    end;
  end;
end;

type
  TBisSmppClientThread=class(TBisWaitThread)
  end;

{ TBisSmppClient }

constructor TBisSmppClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FRequests:=TBisSmppRequests.Create;
  FRequests.MaxCount:=10;

  FReadTimeout:=1000;

  FTransport:=TBisSmppClientTransport.Create(self);
  FTransport.ReadTimeout:=FReadTimeout;

  FThread:=TBisSmppClientThread.Create;
  FThread.OnTimeout:=ThreadTimeout;

end;

destructor TBisSmppClient.Destroy;
begin
  Disconnect;
  FThread.Free;
  FTransport.Free;
  FRequests.Free;
  inherited Destroy;
end;

function TBisSmppClient.TransportConnected: Boolean;
begin
  try
    Sleep(1);
    Result:=FTransport.Connected;
  except
    Result:=false;
  end;
end;

function TBisSmppClient.GetConnected: Boolean;
begin
  Result:=FConnected and FBound and TransportConnected;
end;

function TBisSmppClient.GetStatusDesc(Message: TBisSmppMessage): String;
var
  Item: TBisSmppCommandStatusInfo;
begin
  Result:='';
  if Assigned(Message) then begin
    Item:=FindStatusInfo(Message.CommandStatus);
    if Assigned(Item) then
      Result:=Item.Description;
  end;
end;

function TBisSmppClient.Success(Response: TBisSmppResponse): Boolean;
begin
  Result:=false;
  if Assigned(Response) then
    Result:=Response.CommandStatus=csNoError;
end;

procedure TBisSmppClient.SetTransportReadTimeout(const Value: Integer);
begin
  FTransport.FLock.Lock;
  try
    FReadTimeout:=Value;
    FTransport.ReadTimeout:=Value;
  finally
    FTransport.FLock.UnLock;
  end;
end;

procedure TBisSmppClient.DoConnect;
begin
  if Assigned(FOnConnect) then
    FOnConnect(Self);
end;

procedure TBisSmppClient.DoDisconnect;
begin
  if Assigned(FOnDisconnect) then
    FOnDisconnect(Self);
end;

procedure TBisSmppClient.DoError(const Message: String);
begin
  if Assigned(FOnError) then
    FOnError(Self,Message);
end;

procedure TBisSmppClient.DoRequest(Request: TBisSmppRequest);
begin
  if Assigned(FOnRequest) then
    FOnRequest(Self,Request);
end;

procedure TBisSmppClient.DoResponse(Response: TBisSmppResponse);
begin
  if Assigned(FOnResponse) then
    FOnResponse(Self,Response);
end;

function TBisSmppClient.CreateMessage(Data: TBytes): TBisSmppMessage;

  function GetCommandId(Bytes: TBytes; var CommandId: Cardinal): Boolean;
  var
    Stream: TBisSmppStream;
  begin
    Result:=false;
    if Length(Bytes)>0 then begin
      Stream:=TBisSmppStream.Create;
      try
        Stream.WriteBytes(Bytes);
        Stream.Position:=0;
        if Stream.Size>0 then begin
          CommandId:=Stream.ReadInteger;
          Result:=true;
        end;
      finally
        Stream.Free;
      end;
    end;
  end;

var
  CommandId: Cardinal;
  MessageClass: TBisSmppMessageClass;
begin
  Result:=nil;
  if Length(Data)>0 then begin
    if GetCommandId(Data,CommandId) then begin
      MessageClass:=FindMessageClass(CommandId);
      if Assigned(MessageClass) then begin
        Result:=MessageClass.Create;
        Result.SetData(Data);
      end;
    end;
  end;
end;

function TBisSmppClient.SendResponse(Response: TBisSmppResponse): Boolean;
var
  Data: TBytes;
begin
  Result:=false;
  if FConnected and Assigned(Response) then begin
    try
      DoResponse(Response);
      if Response.GetData(Data) then
        Result:=FTransport.SendData(Data);
    except
      On E: Exception do begin
        DoError(E.Message);
        FBound:=false;
      end;
    end;
  end;
end;

function TBisSmppClient.ProcessRequest(Request: TBisSmppRequest): Boolean;
begin
  Result:=false;
  if Assigned(Request) then begin

    if Request is TBisSmppOutbindRequest then begin
      // DoOutbind?
    end;

    if Request is TBisSmppDeliverSmRequest then begin
      Request.Response:=TBisSmppDeliverSmResponse.Create;
      Request.Response.SetRequest(Request);
      Result:=Assigned(Request.Response);
    end;

    if Request is TBisSmppEnquireLinkRequest then begin
      Request.Response:=TBisSmppEnquireLinkResponse.Create;
      Request.Response.SetRequest(Request);
      Result:=Assigned(Request.Response);
    end;

    if Request is TBisSmppAlertNotificationRequest then begin
      // DoAlertNotification?
    end;

  end;
end;

function TBisSmppClient.RecvResponse(var Response: TBisSmppResponse): Boolean;
var
  Data: TBytes;
  Message: TBisSmppMessage;
begin
  Result:=false;
  if FConnected then begin
    try
      Result:=FTransport.RecvData(Data,FReadTimeout);
      if Result then begin;
         Message:=CreateMessage(Data);
         if Assigned(Message) then begin
           if IsClassParent(Message.ClassType,TBisSmppResponse) then begin
             Response:=TBisSmppResponse(Message);
             DoResponse(Response);
             Result:=true;
           end else
             Message.Free;
         end;
      end;
    except
      On E: Exception do begin
        DoError(E.Message);
        if E is EIdReadTimeout then begin // sometimes we don't receive the response
          Result:=TransportConnected;
          if Result then
            Result:=ServerExists(FIP,FPort,FReadTimeout);
          FBound:=Result;
        end else
          FBound:=false;
      end;
    end;
  end;
end;

function TBisSmppClient.SendRequest(Request: TBisSmppRequest): Boolean;
var
  Data: TBytes;
begin
  Result:=false;
  if FConnected and Assigned(Request) then begin
    try
      Inc(FSequenceNumber);
      if FSequenceNumber>MaxSequenceNumber then
        FSequenceNumber:=0;

      Request.SequenceNumber:=FSequenceNumber;
      DoRequest(Request);

      if Request.GetData(Data) then
        Result:=FTransport.SendData(Data);
    except
      On E: Exception do begin
        DoError(E.Message);
        FBound:=false;
      end;
    end;
  end;
end;

procedure TBisSmppClient.Bind;
var
  Request: TBisSmppBindRequest;
  Response: TBisSmppResponse;
begin
  if FConnected and not FBound then begin

    Request:=nil;
    case FMode of
      cmTransmitter: Request:=TBisSmppBindTransmitterRequest.Create;
      cmReceiver: Request:=TBisSmppBindReceiverRequest.Create;
      cmTransceiver: Request:=TBisSmppBindTransceiverRequest.Create;
    end;

    if Assigned(Request) then begin

      FRequests.LockAdd(Request);

      Request.SystemId:=FSystemId;
      Request.Password:=FPassword;
      Request.SystemType:=FSystemType;
      Request.AddrTon:=FTypeOfNumber;
      Request.AddrNpi:=FPlanIndicator;
      Request.AddressRange:=Range;

      if SendRequest(Request) then begin
        Response:=nil;
        if RecvResponse(Response) and Assigned(Response) and
           IsClassParent(Response.ClassType,TBisSmppBindResponse) then begin
          FBound:=Success(Response);
          if not FBound then
            DoError(GetStatusDesc(Response));
        end;
      end;
    end;

  end;
end;

procedure TBisSmppClient.UnBind;
var
  Request: TBisSmppUnBindRequest;
  Response: TBisSmppResponse;
begin
  if FConnected and FBound then begin
    Request:=TBisSmppUnBindRequest.Create;

    FRequests.LockAdd(Request);

    if SendRequest(Request) then begin
      Response:=nil;
      if RecvResponse(Response) and Assigned(Response) and
        (Response is TBisSmppUnBindResponse) then begin
        if Success(Response) then
          FBound:=false
        else
          DoError(GetStatusDesc(Response));
      end;
    end else
      FBound:=false;
  end;
end;

procedure TBisSmppClient.ThreadTimeout(Thread: TBisWaitThread);

  function LocalRecvRequest(var Request: TBisSmppRequest): Boolean;
  var
    Data: TBytes;
    Message: TBisSmppMessage;
    Response: TBisSmppResponse;
  begin
    Result:=false;
    if FConnected then begin
      try
        if FTransport.RecvData(Data,1) then begin
          Message:=CreateMessage(Data);
          if Assigned(Message) then begin
            if IsClassParent(Message.ClassType,TBisSmppRequest) then begin
              Request:=TBisSmppRequest(Message);

              FRequests.LockAdd(Request);

              DoRequest(Request);
              Result:=true;
            end else if IsClassParent(Message.ClassType,TBisSmppResponse) then begin

              Response:=TBisSmppResponse(Message);

              DoResponse(Response);

            end else
              Message.Free;
          end;
        end;
      except
        On E: Exception do begin
          if not (E is EIdReadTimeout) then
            FBound:=TransportConnected;
        end;
      end;
    end;
  end;

var
  Request: TBisSmppRequest;
begin
  try
    if LocalRecvRequest(Request) then
      if ProcessRequest(Request) then
        SendResponse(Request.Response);
  finally
    Thread.Reset;
  end;
end;

procedure TBisSmppClient.Connect;
begin
  Disconnect;
  FIP:=ResolveIP(FHost);
  if not FConnected and ServerExists(FIP,FPort,FReadTimeout) then begin
    try
      FRequests.LockClear;
      FSequenceNumber:=0;
      FTransport.Connect(FHost,FPort);
      FConnected:=true;
      Bind;
      if FBound then begin
        FThread.Timeout:=FCheckTimeout;
        FThread.Start;
        DoConnect;
      end;
    except
      On E: Exception do
        DoError(E.Message);
    end;
  end;
end;

procedure TBisSmppClient.Disconnect;
begin
  if FConnected then begin
    try
      FThread.Stop;
      UnBind;
{      if not FBound then begin
        try
          FTransport.Disconnect;
        except
        end;
        FConnected:=false;
        DoDisconnect;
        if FAutoReconnect then
          Connect;
      end;}
      try
        FTransport.Disconnect;
      except
      end;
      FConnected:=false;
      DoDisconnect;
      if FAutoReconnect then
        Connect;
    except
      on E: Exception do
        DoError(E.Message);
    end;
  end;
end;

function TBisSmppClient.SendWait(Request: TBisSmppRequest; ResponseClass: TBisSmppResponseClass): Boolean;
var
  Response: TBisSmppResponse;
begin
  Result:=false;
  if Assigned(Request) then begin

    FRequests.LockAdd(Request);

    if FConnected and FBound then begin
      if SendRequest(Request) then begin
        Response:=nil;
        Result:=RecvResponse(Response);
        if Result and Assigned(Response) and IsClassParent(Response.ClassType,ResponseClass) then begin
          Request.Response:=Response;
          Result:=Success(Response);
          if not Result then
            DoError(GetStatusDesc(Response));
        end;
      end;
    end;
  end;
end;

function TBisSmppClient.Send(Request: TBisSmppSubmitSmRequest): Boolean;
begin
  Result:=SendWait(Request,TBisSmppSubmitSmResponse);
end;

function TBisSmppClient.Send(Request: TBisSmppSubmitMultiRequest): Boolean;
begin
  Result:=SendWait(Request,TBisSmppSubmitMultiResponse);
end;

function TBisSmppClient.Send(Request: TBisSmppQuerySmRequest): Boolean;
begin
  Result:=SendWait(Request,TBisSmppQuerySmResponse);
end;

function TBisSmppClient.Send(Request: TBisSmppCancelSmRequest): Boolean;
begin
  Result:=SendWait(Request,TBisSmppCancelSmResponse);
end;

end.