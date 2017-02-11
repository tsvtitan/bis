unit BisSipClient;

interface

uses Windows, Classes, SysUtils, Contnrs, SyncObjs,

     IdGlobal, IdSocketHandle, IdStrings,
     IdUDPServer,

     BisSip, BisSipMessages, BisSdp;

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

  TBisSipRtpServer=class(TIdUDPServer)
  private
    FParent: TBisSipClient;
    FStreamIn: TFileStream;
    FSequence: Word;
    FSSRCIdentifier: LongWord;
    FStreamOut: TFileStream;
    FStreamOut2: TFileStream;
    FLock: TCriticalSection;
    FRemoteRtpHost: String;
    FRemoteRtpPort: Integer;

    procedure Test;
    procedure Response(Data: TBytes; ASequence: Word; SSRCIdentifier: LongWord);
  protected
    procedure DoUDPRead(AData: TIdBytes; ABinding: TIdSocketHandle); override;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  end;

  TBisSipClientSendEvent=procedure(Sender: TBisSipClient; Message: String) of object;
  TBisSipClientReceiveEvent=procedure (Sender: TBisSipClient; Message: String) of object;
  TBisSipClientRegisterEvent=procedure (Sender: TBisSipClient) of object;
  TBisSipClientDataEvent=procedure (Sender: TBisSipClient; Data: TBytes) of object;


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
    FRtpServer: TBisSipRtpServer;
    FRequests: TBisSipRequests;
    FResponses: TBisSipResponses;
    FScheme: String;
    FProtocol: String;
    FTransport: String;
    FExpires: Integer;
    FAllowTypes: TBisSipAllowTypes;
    FMaxForwards: Integer;
    FOnSend: TBisSipClientSendEvent;
    FOnReceive: TBisSipClientReceiveEvent;
    FMaxAuthRetry: Integer;
    FOnRegister: TBisSipClientRegisterEvent;
    FRegisterCallID: String;
    FInviteViaBranch: String;
    FInviteCallID: String;
    FInviteFromTag: String;
    FApplicationSdpContentType: String;
    FRemoteRtpPort: Integer;
    FActive: Boolean;
    FOnData: TBisSipClientDataEvent;

    function GetIpAddress(Host: String): String;
    procedure SendRequest(Request: TBisSipRequest);
    procedure ParseMessage(Message: String);

    procedure Start;
    procedure Stop;

  protected
    procedure DoSend(Message: String);
    procedure DoReceive(Message: String);
    procedure DoRegister;
    procedure DoData(Data: TBytes);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Register;
    procedure UnRegister;
    procedure Invite(AUserName: String);
    procedure Cancel(AUserName: String);
    procedure Bye(AUserName: String);

    procedure TestRtpServer(RemoteRtpPort: String);

    property Registered: Boolean read FRegistered;
    property Scheme: String read FScheme;
    property Protocol: String read FProtocol;
    property Transport: String read FTransport;
    property AllowTypes: TBisSipAllowTypes read FAllowTypes;
    property Active: Boolean read FActive;

    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property UserAgent: String read FUserAgent write FUserAgent;
    property LocalHost: String read FLocalHost write FLocalHost;
    property LocalPort: Integer read FLocalPort write FLocalPort;
    property RemoteHost: String read FRemoteHost write FRemoteHost;
    property RemotePort: Integer read FRemotePort write FRemotePort;
    property Expires: Integer read FExpires write FExpires;
    property MaxForwards: Integer read FMaxForwards write FMaxForwards;
    property MaxAuthRetry: Integer read FMaxAuthRetry write FMaxAuthRetry;

    property OnSend: TBisSipClientSendEvent read FOnSend write FOnSend;
    property OnReceive: TBisSipClientReceiveEvent read FOnReceive write FOnReceive;
    property OnRegister: TBisSipClientRegisterEvent read FOnRegister write FOnRegister;
    property OnData: TBisSipClientDataEvent read FOnData write FOnData;
  end;

implementation

uses Dialogs, DateUtils, Forms,
     BisUtils, BisSipUtils, BisRtp;

{ TBisSipUdpServer }

constructor TBisSipUdpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ThreadedEvent:=false;
end;

procedure TBisSipUdpServer.DoUDPRead(AData: TIdBytes; ABinding: TIdSocketHandle);
var
  S: String;
begin
  if Assigned(FParent) then begin
    S:=Trim(BytesToString(AData));
    FParent.ParseMessage(S);
    FParent.DoReceive(S);
  end;
end;



{ TBisSipRtpServer }

constructor TBisSipRtpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ThreadedEvent:=false;
  FLock:=TCriticalSection.Create;

  FStreamIn:=TFileStream.Create('c:\'+GetUniqueID,fmCreate);
  FStreamOut:=TFileStream.Create('c:\test_.mem',fmOpenRead);
  FStreamOut2:=TFileStream.Create('c:\test_2.mem',fmCreate or fmOpenWrite);

  Randomize;
  FSequence:=Random(MaxByte);
  FSSRCIdentifier:=Random(MaxInt);
end;

destructor TBisSipRtpServer.Destroy;
begin
  FStreamOut2.Free;
  FStreamOut.Free;
  FStreamIn.Free;
  FLock.Free;
  inherited Destroy;
end;

procedure TBisSipRtpServer.Response(Data: TBytes; ASequence: Word; SSRCIdentifier: LongWord);

  function LWSwap(LW: LongWord): LongWord;
  begin
    Result:=Swap(LW shr 16) + Swap(LW) shl 16;
  end;

var
  Packet: TBisRtpPacket;
  S: String;
begin
  if Length(Data)>0 then begin
    Packet:=TBisRtpPacket.Create;
    try
      Packet.Version:=vSecond;
      Packet.Padding:=false;
      Packet.Extension:=false;
      Packet.Marker:=false;
      Packet.PayloadType:=ptPCMU;
      Packet.Sequence:=ASequence;
  //    Packet.TimeStamp:=DateTimeToUnix(Now);
      Packet.TimeStamp:=LWSwap(GetTickCountEx);
      Packet.SSRCIdentifier:=SSRCIdentifier;
      Packet.ExternalHeader:=ToBytes('');
      Packet.Payload:=Data;
      S:=BytesToString(Packet.GetData);

      Send(FRemoteRtpHost,FRemoteRtpPort,S);

      FStreamOut2.Write(Pointer(Packet.Payload)^,Length(Packet.Payload));
    finally
      Packet.Free;
    end;
  end;
end;

procedure TBisSipRtpServer.Test;
var
  D: TBytes;
begin
  SetLength(D,20*8);
  Randomize;
  FSequence:=Random(MaxByte);
  FSSRCIdentifier:=Random(MaxInt);
  Response(D,FSequence,FSSRCIdentifier);
end;

procedure TBisSipRtpServer.DoUDPRead(AData: TIdBytes; ABinding: TIdSocketHandle);

  procedure DataResponse;
  var
    D: TBytes;
  begin
    SetLength(D,20*8);
    if FStreamOut.Position<FStreamOut.Size then begin
      FStreamOut.Read(Pointer(D)^,Length(D));
      Response(D,FSequence,FSSRCIdentifier);
      Inc(FSequence,256);
    end;
  end;

var
  Packet: TBisRtpPacket;
  L: Integer;
begin
  FLock.Enter;
  try
    if Assigned(FParent) then begin
      Packet:=TBisRtpPacket.Create;
      try
        Packet.Parse(AData);
        if Packet.Version=vSecond then begin
         // if Packet.PayloadType=ptPCMA then begin
            L:=Length(Packet.Payload);
            if L>0 then begin
              FStreamIn.Write(Pointer(Packet.Payload)^,L);
            end;

            FParent.DoData(Packet.Payload);

            DataResponse;
          end;
//        end;
      finally
        Packet.Free;
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

{ TBisSipClient }

constructor TBisSipClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FScheme:='sip';
  FProtocol:='SIP/2.0';
  FTransport:='UDP';
  FExpires:=60;
  FAllowTypes:=[atInvite,atAck,atBYE,atCANCEL];
  FMaxForwards:=20;
  FMaxAuthRetry:=3;
  FApplicationSdpContentType:='application/sdp';

  FUserAgent:=Copy(ClassName,5,MaxInt);

  FUdpServer:=TBisSipUdpServer.Create(nil);
  FUdpServer.FParent:=Self;

  FRtpServer:=TBisSipRtpServer.Create(nil);
  FRtpServer.FParent:=Self;

  FRequests:=TBisSipRequests.Create;
  FResponses:=TBisSipResponses.Create;
end;

destructor TBisSipClient.Destroy;
begin
  UnRegister;
  FResponses.Free;
  FRequests.Free;
  FRtpServer.Free;
  FUdpServer.Free;
  inherited Destroy;
end;

procedure TBisSipClient.DoData(Data: TBytes);
begin
  if Assigned(FOnData) then
    FOnData(Self,Data);  
end;

procedure TBisSipClient.DoReceive(Message: String);
begin
  if Assigned(FOnReceive) then
    FOnReceive(Self,Message);
end;

procedure TBisSipClient.DoRegister;
begin
  if Assigned(FOnRegister) then
    FOnRegister(Self);
end;

procedure TBisSipClient.DoSend(Message: String);
begin
  if Assigned(FOnSend) then
    FOnSend(Self,Message);
end;

procedure TBisSipClient.ParseMessage(Message: String);
var
  Response: TBisSipResponse;

  procedure ProccessOK;
  var
    LastRequest: TBisSipRequest;
  begin
    LastRequest:=FRequests.GetRequest(Response);
    if Assigned(LastRequest) then begin

      if LastRequest is TBisSipRegisterRequest then begin
        FRegistered:=true;
        DoRegister;
      end;

    end;
  end;

  procedure ProcessBadRequest;
  begin

  end;

  procedure ProcessUnauthorized;
  var
    SameCount: Integer;
    LastRequest: TBisSipRequest;
    Request: TBisSipRegisterRequest;
    Contact: TBisSipContact;
    CSeq: TBisSipCSeq;
//    Via: TBisSipVia;
    WWWAuthenticate: TBisSipWWWAuthenticate;
    Authorization: TBisSipAuthorization;
  begin
    LastRequest:=FRequests.GetRequest(Response);
    if Assigned(LastRequest) then begin

      if  LastRequest is TBisSipRegisterRequest then begin

        FRegistered:=false;
        DoRegister;

        Contact:=TBisSipContact(LastRequest.Headers.Find(TBisSipContact));
        if Assigned(Contact) and not Contact.Empty then begin

          SameCount:=FResponses.CountBy(rcUnauthorized);
          if FMaxAuthRetry>SameCount then begin
            Request:=TBisSipRegisterRequest.Create(TBisSipRegisterRequest(LastRequest));

{            Via:=TBisSipVia(Request.Headers.Find(TBisSipVia));
            if Assigned(Via) then
              Via.Branch:=GetUniqueID;}

            CSeq:=TBisSipCSeq(Request.Headers.Find(TBisSipCSeq));
            if Assigned(CSeq) then
              CSeq.Num:=FRequests.NextSequence;

            Authorization:=TBisSipAuthorization(Request.Headers.Find(TBisSipAuthorization));
            if not Assigned(Authorization) then
              Authorization:=Request.Headers.AddAuthorization(FUserName,FPassword,LastRequest.Name,LastRequest.Uri);
            if Assigned(Authorization) then begin
              WWWAuthenticate:=TBisSipWWWAuthenticate(Response.Headers.Find(TBisSipWWWAuthenticate));
              if Assigned(WWWAuthenticate) then
                Authorization.CopyFrom(WWWAuthenticate)
              else begin
                // find Proxy Authenticate
              end;
            end;

            FRequests.Add(Request);
            SendRequest(Request);
          end;
        end;
      end;

    end;
  end;

  procedure ProcessForbidden;
  begin
  end;

var
  ContentType: TBisSipContentType;
  Sdp: TBisSdp;
  Connection: TBisSdpConnection;
  Media: TBisSdpMedia;
begin
  Response:=FResponses.ParseResponse(Message);
  if Assigned(Response) then begin

    Sdp:=TBisSdp.Create;
    try
      ContentType:=TBisSipContentType(Response.Headers.Find(TBisSipContentType));
      if Assigned(ContentType) then begin
        case ContentType.Value of
          ctvUnknown: ;
          ctvApplicationSdp: begin
            Sdp.Parse(Response.Body.AsString);
            Connection:=TBisSdpConnection(Sdp.Find(TBisSdpConnection));
            Media:=TBisSdpMedia(Sdp.Find(TBisSdpMedia));
            if Assigned(Connection) and Assigned(Media) then begin
              FRemoteRtpPort:=Media.Port;
              FRtpServer.FRemoteRtpHost:=Connection.UnicastAddress;
              FRtpServer.FRemoteRtpPort:=FRemoteRtpPort;
//              ShowMessage(Connection.UnicastAddress+':'+IntToStr(Media.Port));
            end;

          end;
        end;
      end;

      case Response.ResponseCode of
        rcOK: ProccessOK;
        rcBadRequest: ProcessBadRequest;
        rcUnauthorized: ProcessUnauthorized;
        rcForbidden: ProcessForbidden;
        rcRinging: FRtpServer.Test;
      end;

      FResponses.Add(Response);
      
    finally
      Sdp.Free;
    end;

  end;
end;

procedure TBisSipClient.SendRequest(Request: TBisSipRequest);
var
  S: String;
begin
  if Assigned(Request) then begin
    S:=Request.AsString;
    if FUdpServer.Active then begin
      FUdpServer.Send(FRemoteHost,FRemotePort,S);
      DoSend(S);
    end;
  end;
end;

function TBisSipClient.GetIpAddress(Host: String): String;
begin
  Result:=Host;
end;

procedure TBisSipClient.Start;
begin
  Stop;
  FUdpServer.Bindings.Clear;
  with FUdpServer.Bindings.Add do begin
    IP:=GetIpAddress(FLocalHost);
    Port:=FLocalPort;
  end;
  FUdpServer.Active:=true;
end;

procedure TBisSipClient.Stop;
begin
  FUdpServer.Active:=false;
end;

procedure TBisSipClient.Register;
var
  Request: TBisSipRegisterRequest;
begin
  UnRegister;
  if not FRegistered then begin
    Start;
    Request:=TBisSipRegisterRequest.Create(FScheme,'',FRemoteHost,'',FProtocol);
    with Request do begin
      with Headers do begin
        AddVia(FProtocol,FTransport,FLocalHost,IntToStr(FLocalPort),GetBranch,'','');
        AddFrom('',FScheme,FUserName,FRemoteHost,'',GetTag);
        AddTo('',FScheme,FUserName,FRemoteHost,'','');
        FRegisterCallID:=GetUniqueID;
        AddCallId(FRegisterCallID);
        AddCSeq(FRequests.NextSequence,Request.Name);
        AddContact('',FScheme,FUserName,FLocalHost,IntToStr(FLocalPort),'',IntToStr(FExpires),'0.9');
        AddUserAgent(FUserAgent);
        AddAllow(FAllowTypes);
        AddMaxForwards(IntToStr(FMaxForwards));
        AddExpires(IntToStr(FExpires));
        AddContentLength(IntToStr(Body.Length));
      end;
    end;
    FRequests.Add(Request);
    SendRequest(Request);
  end;
end;

procedure TBisSipClient.UnRegister;
var
  Request: TBisSipRegisterRequest;
begin
  if FRegistered then begin
    Request:=TBisSipRegisterRequest.Create(FScheme,'',FRemoteHost,'',FProtocol);
    with Request do begin
      with Headers do begin
        AddVia(FProtocol,FTransport,FLocalHost,IntToStr(FLocalPort),GetBranch,'','');
        AddFrom('',FScheme,FUserName,FRemoteHost,'',GetTag);
        AddTo('',FScheme,FUserName,FRemoteHost,'','');
        AddCallId(FRegisterCallID);
        AddCSeq(FRequests.NextSequence,Request.Name);
        AddContact;
        AddAllow(FAllowTypes);
        AddMaxForwards(IntToStr(FMaxForwards));
        AddExpires('0');
        AddContentLength(IntToStr(Body.Length));
      end;
    end;
    FRequests.Add(Request);
    SendRequest(Request);
  end;
end;

procedure TBisSipClient.Invite(AUserName: String);
var
  Request: TBisSipInviteRequest;
  Sdp: TBisSdp;
begin
  if FRegistered then begin
    Sdp:=TBisSdp.Create;
    try
      FRtpServer.Active:=false;
      FRtpServer.Bindings.Clear;
      with FRtpServer.Bindings.Add do begin
        IP:=GetIpAddress(FLocalHost);
        Port:=22000;
      end;
      FRtpServer.Active:=true;

      Sdp.AddVersion('0');
      Sdp.AddOrigin('','12345','67890','IN','IP4',FRtpServer.Bindings[0].IP);
      Sdp.AddSession('');
      Sdp.AddConnection('IN','IP4',FRtpServer.Bindings[0].IP);
      Sdp.AddTiming('0','0');
      Sdp.AddMedia('audio',IntToStr(FRtpServer.Bindings[0].Port),'RTP/AVP','0');
      Sdp.AddRtpmapAttr('0','PCMU','8000');
      Sdp.AddPtimeAttr('20');
      Sdp.AddAttr('sendrecv');
//      Sdp.AddAttr('recvonly');
//      Sdp.AddAttr('sendonly');

      Request:=TBisSipInviteRequest.Create(FScheme,AUserName,FRemoteHost,'',FProtocol);
      with Request do begin
        Body.Text:=Sdp.AsString;
        with Headers do begin
          FInviteViaBranch:=GetBranch;
          AddVia(FProtocol,FTransport,FLocalHost,IntToStr(FLocalPort),FInviteViaBranch,'','');
          FInviteFromTag:=GetTag;
          AddFrom('',FScheme,FUserName,FRemoteHost,'',FInviteFromTag);
          AddTo('',FScheme,AUserName,FRemoteHost,'','');
          FInviteCallID:=GetUniqueID;
          AddCallID(FInviteCallID);
          AddCSeq(FRequests.NextSequence,Request.Name);
          AddContact('',FScheme,FUserName,FLocalHost,IntToStr(FLocalPort),'','','');
          AddAllow(FAllowTypes);
          AddMaxForwards(IntToStr(FMaxForwards));
          AddContentType(FApplicationSdpContentType);
          AddContentLength(IntToStr(Body.Length));
        end;
      end;
      FRequests.Add(Request);
      SendRequest(Request);
    finally
      Sdp.Free;
    end;

  end;
end;

procedure TBisSipClient.Cancel(AUserName: String);
var
  Request: TBisSipCancelRequest;
begin
  if FRegistered {and FActive} then begin
    Request:=TBisSipCancelRequest.Create(FScheme,AUserName,FRemoteHost,'',FProtocol);
    with Request do begin
      with Headers do begin
        AddVia(FProtocol,FTransport,FLocalHost,IntToStr(FLocalPort),FInviteViaBranch,IntToStr(FLocalPort),'95.188.95.231');
        AddFrom('',FScheme,FUserName,FRemoteHost,'',FInviteFromTag);
        AddTo('',FScheme,AUserName,FRemoteHost,'','');
        AddCallID(FInviteCallID);
        AddCSeq(FRequests.Sequence,Request.Name);
        AddMaxForwards(IntToStr(FMaxForwards));
        AddContentLength(IntToStr(Body.Length));
      end;
    end;
    FRequests.Add(Request);
    SendRequest(Request);
  end;
end;

procedure TBisSipClient.Bye(AUserName: String);
var
  Request: TBisSipByeRequest;
begin
  if FRegistered {and FActive} then begin
    Request:=TBisSipByeRequest.Create(FScheme,AUserName,FRemoteHost,IntToStr(FRemoteRtpPort),FProtocol);
    with Request do begin
      with Headers do begin
        AddVia(FProtocol,FTransport,FLocalHost,IntToStr(FLocalPort),GetBranch,'','');
        AddFrom('',FScheme,FUserName,FRemoteHost,'',FInviteFromTag);
        AddTo('',FScheme,AUserName,FRemoteHost,'','');
        AddCallID(FInviteCallID);
        AddCSeq(FRequests.NextSequence,Request.Name);
        AddMaxForwards(IntToStr(FMaxForwards));
        AddContentLength(IntToStr(Body.Length));
      end;
    end;
    FRequests.Add(Request);
    SendRequest(Request);
  end;
end;

procedure TBisSipClient.TestRtpServer(RemoteRtpPort: String);

  function LWSwap(LW: LongWord): LongWord;
  begin
    Result:=Swap(LW shr 16) + Swap(LW) shl 16;
  end;

var
  S: String;
  Stream: TFileStream;
  Stream2: TFileStream;
  Packet: TBisRtpPacket;
  D: TBytes;
  Sequence: Word;
  SSRCIdentifier: LongWord;
begin
//  FRtpServer.DoUDPRead(he);
  Randomize;
  Stream:=TFileStream.Create('c:\test_3.mem',fmOpenRead);
  Stream2:=TFileStream.Create('c:\test_4.mem',fmCreate);
  try
    Sequence:=Random(MaxByte);
    SSRCIdentifier:=Random(MaxInt);

    while Stream.Position<>Stream.Size do begin
      SetLength(D,20*8);
      Stream.Read(Pointer(D)^,Length(D));

      Packet:=TBisRtpPacket.Create;
      try
        Packet.Version:=vSecond;
        Packet.Padding:=false;
        Packet.Extension:=false;
        Packet.Marker:=false;
        Packet.PayloadType:=ptPCMU;
        Packet.Sequence:=Sequence;
        Packet.TimeStamp:=LWSwap(GetTickCountEx);
        Packet.SSRCIdentifier:=SSRCIdentifier;
        Packet.ExternalHeader:=ToBytes('');
        Packet.Payload:=D;
        S:=BytesToString(Packet.GetData);

        Stream2.Write(Pointer(Packet.Payload)^,Length(Packet.Payload));

        FRtpServer.Send(FRemoteHost,StrToIntDef(RemoteRtpPort,22000),S);

//        Packet.Parse(S);
        Application.ProcessMessages;

        Sleep(10);

        Inc(Sequence,256);
        
      finally
        Packet.Free;
      end;
    end;
  finally
    Stream2.Free;
    Stream.Free;
  end;
//  FRtpServer.DoUDPRead(he);
end;

end.
