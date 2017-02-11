unit BisSipPhone;

interface

uses SysUtils, Classes, Contnrs, mmSystem,
     IdGlobal, IdUdpServer, IdUdpClient, IdSocketHandle,
     BisSip, BisSdp, BisRtp, BisAcmDrivers;

type
  TBisSipPhone=class;

  TBisSipPhoneTransport=class(TBisSipTransport)
  private
    FPhone: TBisSipPhone;
    FServer: TIdUdpServer;
    FLock: TCriticalSection;
    FEnabled: Boolean;
    procedure ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
  protected
    class function GetName: String; override;
    function GetActive: Boolean; override;
    procedure SetActive(const Value: Boolean); override;
    function Send(Host: String; Port: Integer; Data: String): Boolean; override;
  public
    constructor Create(Phone: TBisSipPhone); reintroduce;
    destructor Destroy; override;

    property Enabled: Boolean read FEnabled write FEnabled;
  end;

  TBisSipPhoneRegistrar=class(TBisSipRegistrar)
  private
    FPhone: TBisSipPhone;
    FDestroy: Boolean;
  protected
    procedure DoRegister; override;
    procedure DoSessionCreate(Session: TBisSipSession); override;
    procedure DoSessionDestroy(Session: TBisSipSession); override;
    function DoSessionAccept(Session: TBisSipSession; Message: TBisSipMessage): Boolean; override;
    procedure DoSessionRing(Session: TBisSipSession); override;
    procedure DoSessionProgress(Session: TBisSipSession); override;
    procedure DoSessionConfirm(Session: TBisSipSession); override;
    procedure DoSessionTerminate(Session: TBisSipSession); override;
    function DoSessionAlive(Session: TBisSipSession): Boolean; override;
  public
    constructor Create(Phone: TBisSipPhone); reintroduce;
  end;

  TBisSipPhoneLine=class;

  TBisSipPhoneLinePlayThread=class(TThread)
  private
//    FEvent: THandle;
    FData: TBytes;
    FLine: TBisSipPhoneLine;
    FStream: TMemoryStream;
    FLoopCount: Integer;
    FEnd: Boolean;
    procedure SendData;
  public
    constructor Create(Line: TBisSipPhoneLine); reintroduce;
    destructor Destroy; override;
    procedure Execute; override;
  end;

  TBisSipPhoneLineSendThread=class(TThread)
  private
    FData: TBytes;
    FLine: TBisSipPhoneLine;
    procedure GetSendData;
  public
    constructor Create(Line: TBisSipPhoneLine); reintroduce;
    destructor Destroy; override;
    procedure Execute; override;
  end;

  TBisSipPhoneLineDirection=(ldUnknown,ldIncoming,ldOutgoing);
  TBisSipPhoneLineHoldMode=(lhmStandart,lhmEmulate);

  TBisSipPhoneLine=class(TObject)
  private
    FPhone: TBisSipPhone;
    FLock: TCriticalSection;
    FLinks: TObjectList;
    FNotifies: TObjectList;
    FPlayThread: TBisSipPhoneLinePlayThread;
    FSendThread: TBisSipPhoneLineSendThread;
    FNumber: String;
    FSession: TBisSipSession;
    FWaitHoldUnHold: Boolean;
    FHolding: Boolean;
//    FTempStream: TMemoryStream;
    FLastTickCount: Integer;
    FRinging: Boolean;

    FRemoteHost: String;
    FRemoteIP: String;
    FRemotePort: Integer;
    FRemoteFormat: String;
    FRemoteSessionId: LongWord;
    FRemoteSessionVersion: LongWord;
    FRemotePayloadType: TBisRtpPacketPayloadType;
    FRemoteRtpmaps: TBisSdp;
    FRemoteChannels: Word;
    FRemoteSamplesPerSec: LongWord;
    FRemoteBitsPerSample: Word;
    FRemoteDriverFormat: TBisAcmDriverFormat;
    FRemotePacketTime: Word;
    FRemoteModeType: TBisSdpModeAttrType;

    FLocalIP: String;
    FLocalSessionId: LongWord;
    FLocalSessionVersion: LongWord;
    FLocalPayloadType: TBisRtpPacketPayloadType;
    FLocalEncondingType: TBisSdpRtpmapAttrEncodingType;
    FLocalChannels: Word;
    FLocalSamplesPerSec: LongWord;
    FLocalBitsPerSample: Word;
    FLocalDriverFormat: TBisAcmDriverFormat;
    FLocalPacketTime: Word;
    FLocalEmptyAddress: String;

    FSequence: Word;
    FTimeStamp: LongWord;
    FSSRCIdentifier: LongWord;
    FServer: TIdUdpServer;
    FBinding: TIdSocketHandle;
    FInPackets: TBisRtpPackets;
    FOutPackets: TBisRtpPackets;

    procedure StartPlayThread(Stream: TStream; LoopCount: Integer);
    procedure StopPlayThread;
    procedure StartSendThread;
    procedure StopSendThread;
    procedure PlayThreadTerminate(Sender: TObject);
    procedure SendThreadTerminate(Sender: TObject);
    procedure RemoveNotifies;
    procedure SendData(Data: TBytes);
    procedure ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
    function GetPayloadLength(PayloadType: TBisRtpPacketPayloadType; PacketTime, BitsPerSample, Channels: Word): Integer;
    function GetPacketTime(PayloadType: TBisRtpPacketPayloadType; BitsPerSample, Channels: Word): Integer;
    function DefaultRemotePacket(Packet: TBisRtpPacket): Boolean;
    function SetMessage(Message: TBisSipMessage): Boolean;
    function TryToActive: Boolean;
    function LongWordSwap(LW: LongWord): LongWord;
    function WordSwap(W: Word): Word;
    function SendPacket(Packet: TBisRtpPacket; WithAdd: Boolean): Boolean;
    procedure SendConfirm;
    function GetInFormat: PWaveFormatEx;
    function GetActive: Boolean;
    procedure SetLocalDriverFormat;
    function GetDirection: TBisSipPhoneLineDirection;
    function GetOutFormat: PWaveFormatEx;
    procedure HoldUnHold(Flag: Boolean);
    function GetPlaying: Boolean;
    function HasFreshData: Boolean;
  protected
    procedure DoInData(const Data: Pointer; const DataSize: Cardinal);
    procedure DoInExtraData(Packet: TBisRtpPacket; Rtmap: TBisSdpRtpmapAttr);
    function DoOutData(const Data: Pointer; const DataSize: Cardinal): Boolean;
    procedure DoPlayEnd;
  public
    constructor Create(Phone: TBisSipPhone);
    destructor Destroy; override;

    procedure Dial(Number: String);
    procedure Answer;
    procedure Hangup;
    procedure Hold;
    procedure UnHold;

    procedure Link(Line: TBisSipPhoneLine);
    procedure Unlink(Line: TBisSipPhoneLine);

    procedure Play(Stream: TStream; LoopCount: Integer=MaxInt);
    procedure Stop;

    property Active: Boolean read GetActive;
    property Number: String read FNumber;
    property Direction: TBisSipPhoneLineDirection read GetDirection;
    property Holding: Boolean read FHolding;
    property Playing: Boolean read GetPlaying;

    property InPackets: TBisRtpPackets read FInPackets;
    property InFormat: PWaveFormatEx read GetInFormat;

    property OutPackets: TBisRtpPackets read FOutPackets;
    property OutFormat: PWaveFormatEx read GetOutFormat;

    property RemotePayloadType: TBisRtpPacketPayloadType read FRemotePayloadType;
    property LocalPayloadType: TBisRtpPacketPayloadType read FLocalPayloadType;
  end;

  TBisSipPhoneLines=class(TObjectList)
  private
    FPhone: TBisSipPhone;
    function GetItem(Index: Integer): TBisSipPhoneLine;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;  
  public
    constructor Create(Phone: TBisSipPhone);

    function Add(Session: TBisSipSession): TBisSipPhoneLine;
    function Find(Session: TBisSipSession): TBisSipPhoneLine;
    function Exists(Line: TBisSipPhoneLine): Boolean;
    function LastLocalPort: Integer;

    property Items[Index: Integer]: TBisSipPhoneLine read GetItem; default;
  end;

  TBisSipPhoneAcmDrivers=class(TBisAcmDrivers)
  private
    function PayloadTypeToFormatTag(PayloadType: TBisRtpPacketPayloadType): LongWord;
    function FormatToPayloadType(DriverFormat: TBisAcmDriverFormat): TBisRtpPacketPayloadType;
  public
    function FindFormat(DriverName, FormatName: String;
                        Channels: Word; SamplesPerSec: Longword; BitsPerSample: Word): TBisAcmDriverFormat; overload;
    function FindFormat(PayloadType: TBisRtpPacketPayloadType;
                        Channels: Word; SamplesPerSec: Longword; BitsPerSample: Word): TBisAcmDriverFormat; overload;
  end;

  TBisSipPhoneEvent=procedure (Sender: TBisSipPhone) of object;
  TBisSipPhoneSendDataEvent=procedure (Sender: TBisSipPhone; Host: String; Port: Integer; Data: String) of object;
  TBisSipPhoneReceiveDataEvent=TBisSipPhoneSendDataEvent;
  TBisSipPhoneLineEvent=procedure (Sender: TBisSipPhone; Line: TBisSipPhoneLine) of object;
  TBisSipPhoneLineCheckEvent=function (Sender: TBisSipPhone; Line: TBisSipPhoneLine): Boolean of object;
  TBisSipPhoneLineInDataEvent=procedure (Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal) of object;
  TBisSipPhoneLineOutDataEvent=function (Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal): Boolean of object;
  TBisSipPhoneLineInExtraDataEvent=procedure (Sender: TBisSipPhone; Line: TBisSipPhoneLine; Packet: TBisRtpPacket; Rtmap: TBisSdpRtpmapAttr) of object;

  TBisSipPhone=class(TComponent)
  private
    FRemotePort: Integer;
    FLocalPort: Integer;
    FLocalIP: String;
    FRemoteHost: String;
    FPassword: String;
    FLocalHost: String;
    FUserName: String;
    FUserAgent: String;
    FConnected: Boolean;
    FMaxForwards: Integer;
    FExpires: Integer;
    FMaxLines: Integer;
    FScheme: String;
    FProtocol: String;
    FRequestTimeOut: Integer;
    FRequestRetryCount: Integer;
    FUseReceived: Boolean;
    FKeepAlive: Integer;
    FUseRport: Boolean;
    FUseTrasnportNameInUri: Boolean;
    FUsePortInUri: Boolean;
    FUseGlobalSequence: Boolean;

    FLineDriverName: String;
    FLineFormatName: String;
    FLineIdleTimeOut: Integer;
    FLineLocalPort: Integer;
    FLineBitsPerSample: Word;
    FLineSamplesPerSec: LongWord;
    FLineChannels: Word;
    FLineConfirmCount: Integer;
    FLineHoldMode: TBisSipPhoneLineHoldMode;

    FTransport: TBisSipPhoneTransport;
    FRegistrar: TBisSipPhoneRegistrar;
    FLines: TBisSipPhoneLines;
    FDrivers: TBisSipPhoneAcmDrivers;

    FOnSendData: TBisSipPhoneSendDataEvent;
    FOnReceiveData: TBisSipPhoneReceiveDataEvent;
    FOnConnect: TBisSipPhoneEvent;
    FOnDisconnect: TBisSipPhoneEvent;
    FOnLineCheck: TBisSipPhoneLineCheckEvent;
    FOnLineRing: TBisSipPhoneLineEvent;
    FOnLineCreate: TBisSipPhoneLineEvent;
    FOnLineDestroy: TBisSipPhoneLineEvent;
    FOnLineInData: TBisSipPhoneLineInDataEvent;
    FOnLineConnect: TBisSipPhoneLineEvent;
    FOnLineDisconnect: TBisSipPhoneLineEvent;
    FOnLineOutData: TBisSipPhoneLineOutDataEvent;
    FOnLineHold: TBisSipPhoneLineEvent;
    FOnLinePlayEnd: TBisSipPhoneLineEvent;
    FOnLineInExtraData: TBisSipPhoneLineInExtraDataEvent;
    FOnLinePlayBegin: TBisSipPhoneLineEvent;

  protected


  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;
    procedure Dial(Number: String);
    procedure Answer(Line: TBisSipPhoneLine);
    procedure Hangup(Line: TBisSipPhoneLine);
    procedure Hold(Line: TBisSipPhoneLine);
    procedure Unhold(Line: TBisSipPhoneLine);

    property Connected: Boolean read FConnected;
    property Transport: TBisSipPhoneTransport read FTransport;

    property Scheme: String read FScheme write FScheme;
    property Protocol: String read FProtocol write FProtocol; 
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property RemoteHost: String read FRemoteHost write FRemoteHost;
    property RemotePort: Integer read FRemotePort write FRemotePort;
    property LocalHost: String read FLocalHost write FLocalHost;
    property LocalPort: Integer read FLocalPort write FLocalPort;
    property UserAgent: String read FUserAgent write FUserAgent;
    property Expires: Integer read FExpires write FExpires;
    property MaxForwards: Integer read FMaxForwards write FMaxForwards;
    property MaxLines: Integer read FMaxLines write FMaxLines;
    property KeepAlive: Integer read FKeepAlive write FKeepAlive;
    property UseReceived: Boolean read FUseReceived write FUseReceived;
    property UseRport: Boolean read FUseRport write FUseRport;
    property UseTrasnportNameInUri: Boolean read FUseTrasnportNameInUri write FUseTrasnportNameInUri;
    property UsePortInUri: Boolean read FUsePortInUri write FUsePortInUri;
    property UseGlobalSequence: Boolean read FUseGlobalSequence write FUseGlobalSequence;
    property RequestRetryCount: Integer read FRequestRetryCount write FRequestRetryCount;
    property RequestTimeOut: Integer read FRequestTimeOut write FRequestTimeOut;

    property LineIdleTimeOut: Integer read FLineIdleTimeOut write FLineIdleTimeOut;
    property LineLocalPort: Integer read FLineLocalPort write FLineLocalPort;
    property LineDriverName: String read FLineDriverName write FLineDriverName;
    property LineFormatName: String read FLineFormatName write FLineFormatName; 
    property LineChannels: Word read FLineChannels write FLineChannels;
    property LineSamplesPerSec: LongWord read FLineSamplesPerSec write FLineSamplesPerSec;
    property LineBitsPerSample: Word read FLineBitsPerSample write FLineBitsPerSample;
    property LineConfirmCount: Integer read FLineConfirmCount write FLineConfirmCount;
    property LineHoldMode: TBisSipPhoneLineHoldMode read FLineHoldMode write FLineHoldMode;

    property OnSendData: TBisSipPhoneSendDataEvent read FOnSendData write FOnSendData;
    property OnReceiveData: TBisSipPhoneReceiveDataEvent read FOnReceiveData write FOnReceiveData;
    property OnConnect: TBisSipPhoneEvent read FOnConnect write FOnConnect;
    property OnDisconnect: TBisSipPhoneEvent read FOnDisconnect write FOnDisconnect;
    property OnLineCreate: TBisSipPhoneLineEvent read FOnLineCreate write FOnLineCreate;
    property OnLineDestroy: TBisSipPhoneLineEvent read FOnLineDestroy write FOnLineDestroy;
    property OnLineCheck: TBisSipPhoneLineCheckEvent read FOnLineCheck write FOnLineCheck;
    property OnLineRing: TBisSipPhoneLineEvent read FOnLineRing write FOnLineRing;
    property OnLineConnect: TBisSipPhoneLineEvent read FOnLineConnect write FOnLineConnect;
    property OnLineInData: TBisSipPhoneLineInDataEvent read FOnLineInData write FOnLineInData;
    property OnLineInExtraData: TBisSipPhoneLineInExtraDataEvent read FOnLineInExtraData write FOnLineInExtraData;
    property OnLineOutData: TBisSipPhoneLineOutDataEvent read FOnLineOutData write FOnLineOutData;
    property OnLineDisconnect: TBisSipPhoneLineEvent read FOnLineDisconnect write FOnLineDisconnect;
    property OnLineHold: TBisSipPhoneLineEvent read FOnLineHold write FOnLineHold;
    property OnLinePlayBegin: TBisSipPhoneLineEvent read FOnLinePlayBegin write FOnLinePlayBegin;  
    property OnLinePlayEnd: TBisSipPhoneLineEvent read FOnLinePlayEnd write FOnLinePlayEnd;
  end;


implementation

uses Windows, DateUtils,
     IdStack, IdDnsResolver,
     BisUtils, BisIPUtils;

function ResolveSipIPAndPort(Scheme,Transport,Host: String; var IP: String; var Port: Integer): Boolean;

  function ResolveA(Server,Target: String): Boolean;
  var
    Resolver: TIdDNSResolver;
    ResultRecord: TResultRecord;
    i: Integer;
    Rec: TARecord;
  begin
    Result:=false;
    try
      Resolver:=TIdDNSResolver.Create(nil);
      try
        Resolver.Host:=Server;
        Resolver.QueryType:=[qtA];
        Resolver.Resolve(Target);
        for i:=0 to Resolver.QueryResult.Count-1 do begin
          ResultRecord:=Resolver.QueryResult.Items[i];
          if ResultRecord is TARecord then begin
            Rec:=TARecord(ResultRecord);
            Result:=IsIP(Rec.IPAddress);
            if Result then begin
              IP:=Rec.IPAddress;
              exit;
            end;
          end;
        end;
      finally
        Resolver.Free;
      end;
    except
      //
    end;
  end;

  function ResolveService(Server: String): Boolean;
  var
    Resolver: TIdDNSResolver;
    ResultRecord: TResultRecord;
    Domain: String;
    i: Integer;
    Rec: TSRVRecord;
  begin
    Result:=false;
    try
      Resolver:=TIdDNSResolver.Create(nil);
      try
        Domain:=Format('_%s._%s.%s',[Scheme,Transport,Host]);
        Domain:=AnsiLowerCase(Domain);
        Resolver.Host:=Server;
        Resolver.QueryType:=[qtService];
        Resolver.Resolve(Domain);
        for i:=0 to Resolver.QueryResult.Count-1 do begin
          ResultRecord:=Resolver.QueryResult.Items[i];
          if ResultRecord is TSRVRecord then begin
            Rec:=TSRVRecord(ResultRecord);
            Result:=IsIP(Rec.Target);
            if not Result then
              Result:=ResolveA(Server,Rec.Target);
            if Result then begin
              Port:=Rec.Port;
              exit;
            end;
          end;
        end;
      finally
        Resolver.Free;
      end;
    except
      //
    end;
  end;

var
  Strings: TStringList;
  i: Integer;
begin
  Result:=false;
  if Trim(Host)<>'' then begin
    Strings:=TStringList.Create;
    try
      GetDNSList(Strings);
      for i:=0 to Strings.Count-1 do begin
        Result:=ResolveService(Strings[i]);
        if Result then
          exit;
      end;
    finally
      Strings.Free;
    end;
  end;
end;

function ResolveIP(Host: String): String;
begin
  Result:='';
  try
    Result:=GStack.ResolveHost(Host);
  except
    //
  end;
end;

{ TBisSipPhoneTransport }

constructor TBisSipPhoneTransport.Create(Phone: TBisSipPhone);
begin
  inherited Create;
  FPhone:=Phone;
  FEnabled:=true;
  FLock:=TCriticalSection.Create;
  FServer:=TIdUDPServer.Create(nil);
  FServer.OnUDPRead:=ServerUDPRead;
  FServer.ThreadedEvent:=false;
end;

destructor TBisSipPhoneTransport.Destroy;
begin
  FServer.Free;
  FLock.Free;
  inherited Destroy;
end;

class function TBisSipPhoneTransport.GetName: String;
begin
  Result:='UDP';
end;

function TBisSipPhoneTransport.GetActive: Boolean;
begin
  Result:=FServer.Active;
end;

procedure TBisSipPhoneTransport.SetActive(const Value: Boolean);
begin
  FServer.Active:=Value;
end;

procedure TBisSipPhoneTransport.ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
var
  S: String;
begin
  if Assigned(FPhone) and Assigned(FPhone.FRegistrar) and
     Assigned(FPhone.FTransport) and FPhone.FTransport.Enabled then begin
{    if (ABinding.PeerIP=FPhone.FRegistrar.RemoteIP) and
       (ABinding.PeerPort=FPhone.FRegistrar.RemotePort)  then begin}
      FLock.Enter;
      try
        S:=BytesToString(AData);
        if Assigned(FPhone.FOnReceiveData) then
          FPhone.FOnReceiveData(FPhone,ABinding.PeerIP,ABinding.PeerPort,S);
        Receivers.Receive(S);
      finally
        FLock.Leave;
      end;
//    end;
  end;
end;

function TBisSipPhoneTransport.Send(Host: String; Port: Integer; Data: String): Boolean;
begin
  Result:=false;
  if Assigned(FPhone) and 
     Assigned(FPhone.FTransport) and FPhone.FTransport.Enabled then begin
    FLock.Enter;
    try
      Result:=Length(Data)>0;
      if Result then begin
        try
          if Assigned(FPhone.FOnSendData) then
            FPhone.FOnSendData(FPhone,Host,Port,Data);

          FServer.Send(Host,Port,Data);

          Result:=true;
        except
          on E: Exception do begin
            Result:=false;
          end;
        end;
      end;
    finally
      FLock.Leave;
    end;
  end;
end;

{ TBisSipPhoneRegistrar }

constructor TBisSipPhoneRegistrar.Create(Phone: TBisSipPhone);
begin
  inherited Create;
  FPhone:=Phone;
end;

procedure TBisSipPhoneRegistrar.DoRegister;
begin
  with FPhone do begin
    FConnected:=Registered;
    if FConnected then begin
      if Assigned(FOnConnect) then
        FOnConnect(FPhone);
    end else begin
      if Assigned(FOnDisconnect) then
        FOnDisconnect(FPhone);
    end;
  end;
end;

procedure TBisSipPhoneRegistrar.DoSessionCreate(Session: TBisSipSession);
var
  Line: TBisSipPhoneLine;
begin
  with FPhone do begin
    Line:=FLines.Add(Session);
    if Assigned(FOnLineCreate) then
      FOnLineCreate(FPhone,Line);
  end;
end;

procedure TBisSipPhoneRegistrar.DoSessionDestroy(Session: TBisSipSession);
var
  Line: TBisSipPhoneLine;
begin
  if not FDestroy then begin
    with FPhone do begin
      Line:=FLines.Find(Session);
      if Assigned(Line) and Assigned(FOnLineDestroy) then
        FOnLineDestroy(FPhone,Line);
      FLines.Remove(Line);
    end;
  end;
end;

function TBisSipPhoneRegistrar.DoSessionAccept(Session: TBisSipSession; Message: TBisSipMessage): Boolean;

  function GetLineNumber: String;
  var
    From: TBisSipFrom;
  begin
    Result:='';
    From:=TBisSipFrom(Message.Headers.Find(TBisSipFrom));
    if Assigned(From) then begin
      Result:=From.Display;
      if Trim(Result)='' then
        Result:=From.User;
    end;
  end;

var
  Line: TBisSipPhoneLine;
begin
  Result:=false;
  with FPhone do begin
    Line:=FLines.Find(Session);
    if Assigned(Line) and (FLines.Count<FMaxLines) then begin
      case Session.Direction of
        sdIncoming: begin
          Line.FNumber:=GetLineNumber;
          if Assigned(FOnLineCheck) then begin
            Result:=FOnLineCheck(FPhone,Line);
            if Result then
              Result:=Line.SetMessage(Message);
          end;
        end;
        sdOutgoing: begin
          if Assigned(FOnLineCheck) then begin
            Result:=FOnLineCheck(FPhone,Line);
            if Result then
              Result:=Line.SetMessage(Message);
          end;
        end;
      end;
    end;
  end;
end;

procedure TBisSipPhoneRegistrar.DoSessionRing(Session: TBisSipSession);
var
  Line: TBisSipPhoneLine;
begin
  with FPhone do begin
    Line:=FLines.Find(Session);
    if Assigned(Line) and not Line.FRinging and Assigned(FOnLineRing) then begin
      Line.FRinging:=true;
      FOnLineRing(FPhone,Line);
    end;
  end;
end;

procedure TBisSipPhoneRegistrar.DoSessionProgress(Session: TBisSipSession);
begin
  DoSessionRing(Session);
end;

procedure TBisSipPhoneRegistrar.DoSessionConfirm(Session: TBisSipSession);
var
  Line: TBisSipPhoneLine;
begin
  with FPhone do begin
    Line:=FLines.Find(Session);
    if Assigned(Line) then begin
      if not Line.FWaitHoldUnHold then begin
        Line.SendConfirm;
        Line.StartSendThread;
        if Assigned(FOnLineConnect) then
          FOnLineConnect(FPhone,Line);
      end else begin
        Line.FWaitHoldUnHold:=false;
        Line.FHolding:=not Line.FHolding;
        if Line.FHolding then
          Line.StopSendThread
        else
          Line.StartSendThread;
        if Assigned(FOnLineHold) then
          FOnLineHold(FPhone,Line);
      end;
    end;
  end;
end;

procedure TBisSipPhoneRegistrar.DoSessionTerminate(Session: TBisSipSession);
var
  Line: TBisSipPhoneLine;
begin
  with FPhone do begin
    Line:=FLines.Find(Session);
    if Assigned(Line) then begin
      if Assigned(FOnLineDisconnect) then
        FOnLineDisconnect(FPhone,Line);
    end;
  end;
end;

function TBisSipPhoneRegistrar.DoSessionAlive(Session: TBisSipSession): Boolean;
var
  Line: TBisSipPhoneLine;
begin
  Result:=false;
  with FPhone do begin
    Line:=FLines.Find(Session);
    if Assigned(Line) then
      Result:=Line.Active and (Line.HasFreshData or Line.Holding);
  end;
end;

{ TBisSipPhoneLinePlayThread }

constructor TBisSipPhoneLinePlayThread.Create(Line: TBisSipPhoneLine);
begin
  inherited Create(true);
  FLine:=Line;
  FStream:=TMemoryStream.Create;
//  FEvent:=CreateEvent(nil,false,false,nil);
end;

destructor TBisSipPhoneLinePlayThread.Destroy;
begin
{  SetEvent(FEvent);
  CloseHandle(FEvent);}
  FStream.Free;
  inherited Destroy;
end;

procedure TBisSipPhoneLinePlayThread.SendData;
begin
  FLine.SendData(FData);
end;

procedure TBisSipPhoneLinePlayThread.Execute;
var
  L: Integer;
  Flag: Boolean;
  LCount: Integer;
begin
  if Assigned(FLine) then begin
    with FLine do begin
      LCount:=0;
      FEnd:=false;
      L:=GetPayloadLength(FLocalPayloadType,FLocalPacketTime,FLocalBitsPerSample,FLocalChannels);
      SetLength(FData,L);
      FStream.Position:=0;
      Flag:=true;
      while Flag do begin
        Flag:=FStream.Position<FStream.Size;
        if Flag then begin
          Sleep(FLine.FLocalPacketTime);
//          WaitForSingleObject(FEvent,INFINITE);
          FStream.Read(Pointer(FData)^,L);
          Synchronize(Self.SendData);
        end else begin
          Inc(LCount);
          if FLoopCount>LCount then begin
            FStream.Position:=0;
            Flag:=true;
          end else
            FEnd:=true;
        end;
        if Terminated or not Flag then
          break;
      end;
    end;
  end;
end;

{ TBisSipPhoneLineSendThread }

constructor TBisSipPhoneLineSendThread.Create(Line: TBisSipPhoneLine);
begin
  inherited Create(true);
  FLine:=Line;
end;

destructor TBisSipPhoneLineSendThread.Destroy;
begin
  inherited Destroy;
end;

procedure TBisSipPhoneLineSendThread.GetSendData;
begin
  if FLine.DoOutData(FData,Length(FData)) then
    FLine.SendData(FData);
end;

procedure TBisSipPhoneLineSendThread.Execute;
var
  L: Integer;
begin
  if Assigned(FLine) then begin
    with FLine do begin
      L:=GetPayloadLength(FLocalPayloadType,FLocalPacketTime,FLocalBitsPerSample,FLocalChannels);
      SetLength(FData,L);
      while not Terminated do begin
        Sleep(FLine.FLocalPacketTime);
        Synchronize(Self.GetSendData);
      end;
    end;
  end;
end;

{ TBisSipPhoneLine }

constructor TBisSipPhoneLine.Create(Phone: TBisSipPhone);
begin
  inherited Create;
  FPhone:=Phone;

  FLock:=TCriticalSection.Create;

  FServer:=TIdUDPServer.Create(nil);
  FServer.OnUDPRead:=ServerUDPRead;
  FServer.ThreadedEvent:=true;

  FBinding:=FServer.Bindings.Add;

  FInPackets:=TBisRtpPackets.Create;
  FOutPackets:=TBisRtpPackets.Create;

  FRemoteRtpmaps:=TBisSdp.Create;

  FLinks:=TObjectList.Create(false);

  FNotifies:=TObjectList.Create(false);

  FLocalSessionId:=Integer(Self);
  FLocalSessionVersion:=0;
  FLocalEmptyAddress:='0.0.0.0';

  FRemoteDriverFormat:=nil;

  FLocalChannels:=FPhone.LineChannels;
  FLocalSamplesPerSec:=FPhone.LineSamplesPerSec;
  FLocalBitsPerSample:=FPhone.LineBitsPerSample;
  FLocalDriverFormat:=FPhone.FDrivers.FindFormat(FPhone.LineDriverName,FPhone.LineFormatName,
                                                 FLocalChannels,FLocalSamplesPerSec,FLocalBitsPerSample);
  FLocalPayloadType:=FPhone.FDrivers.FormatToPayloadType(FLocalDriverFormat);
  FLocalEncondingType:=TBisSdpRtpmapAttr.PayloadTypeToEncodingType(FLocalPayloadType);
  FLocalPacketTime:=GetPacketTime(FLocalPayloadType,FLocalBitsPerSample,FLocalChannels);

  Randomize;
  FSequence:=Random(MaxByte);
  FSSRCIdentifier:=Random(MaxInt);

end;

destructor TBisSipPhoneLine.Destroy;
begin
  FSession:=nil;
  StopPlayThread;
  StopSendThread;
  RemoveNotifies;
  FNotifies.Free;
  FLinks.Free;
  FRemoteRtpmaps.Free;
  FOutPackets.Free;
  FInPackets.Free;
  FServer.Free;
  FLock.Free;
  inherited Destroy;
end;

procedure TBisSipPhoneLine.RemoveNotifies;
var
  i: Integer;
  Item: TBisSipPhoneLine;
begin
  for i:=0 to FNotifies.Count-1 do begin
    Item:=TBisSipPhoneLine(FNotifies.Items[i]);
    Item.FLinks.Remove(Self);
  end;
end;

procedure TBisSipPhoneLine.StopPlayThread;
begin
  if Assigned(FPlayThread) then begin
    FPlayThread.FreeOnTerminate:=false;
    FPlayThread.Free;
    FPlayThread:=nil;
  end;
end;

procedure TBisSipPhoneLine.PlayThreadTerminate(Sender: TObject);
var
  Flag: Boolean;
begin
  if Assigned(FPlayThread) then begin
    Flag:=FPlayThread.FEnd;
    FPlayThread:=nil;
    if Flag then
      DoPlayEnd;
  end;
end;

procedure TBisSipPhoneLine.StartPlayThread(Stream: TStream; LoopCount: Integer);
var
  OldPos: Int64;
  Size: Int64;
begin
  StopSendThread;
  StopPlayThread;
  if Active and not Assigned(FPlayThread) and Assigned(Stream) then begin
    OldPos:=Stream.Position;
    try
      Size:=Stream.Size-Stream.Position;
      if Size>0 then begin
        FPlayThread:=TBisSipPhoneLinePlayThread.Create(Self);
        FPlayThread.FStream.CopyFrom(Stream,Size);
        FPlayThread.FLoopCount:=LoopCount;
        FPlayThread.FreeOnTerminate:=true;
        FPlayThread.OnTerminate:=PlayThreadTerminate;
        FPlayThread.Resume;

        if Assigned(FPhone.FOnLinePlayBegin) then
          FPhone.FOnLinePlayBegin(FPhone,Self);
      end;
    finally
      Stream.Position:=OldPos;
    end;
  end;
end;

procedure TBisSipPhoneLine.StopSendThread;
begin
  if Assigned(FSendThread) then begin
    FSendThread.FreeOnTerminate:=false;
    FSendThread.Free;
    FSendThread:=nil;
  end;
end;

procedure TBisSipPhoneLine.SendThreadTerminate(Sender: TObject);
begin
  FSendThread:=nil;
end;

procedure TBisSipPhoneLine.StartSendThread;
begin
  StopPlayThread;
  StopSendThread;
  if Active and not Assigned(FSendThread) then begin
    FSendThread:=TBisSipPhoneLineSendThread.Create(Self);
    FSendThread.FreeOnTerminate:=true;
    FSendThread.OnTerminate:=SendThreadTerminate;
    FSendThread.Resume;
  end;
end;

procedure TBisSipPhoneLine.Stop;
begin
  StopPlayThread;
end;

procedure TBisSipPhoneLine.Play(Stream: TStream; LoopCount: Integer);
begin
  StartPlayThread(Stream,LoopCount);
end;

function TBisSipPhoneLine.GetPlaying: Boolean;
begin
  Result:=Assigned(FPlayThread);
end;

function TBisSipPhoneLine.GetActive: Boolean;
begin
  Result:=FServer.Active and
          Assigned(FSession) and (FSession.State in [ssProcessing,ssConfirming]);
end;

function TBisSipPhoneLine.GetDirection: TBisSipPhoneLineDirection;
begin
  Result:=ldUnknown;
  if Assigned(FSession) then begin
    case FSession.Direction of
      sdIncoming: Result:=ldIncoming;
      sdOutgoing: Result:=ldOutgoing;
    end;
  end;
end;

function TBisSipPhoneLine.GetInFormat: PWaveFormatEx;
begin
  Result:=nil;
  if Assigned(FRemoteDriverFormat) then
    Result:=FRemoteDriverFormat.WaveFormat;
end;

function TBisSipPhoneLine.GetOutFormat: PWaveFormatEx;
begin
  Result:=nil;
  if Assigned(FLocalDriverFormat) then
    Result:=FLocalDriverFormat.WaveFormat;
end;

procedure TBisSipPhoneLine.DoInData(const Data: Pointer; const DataSize: Cardinal);
begin
  if not FHolding and Assigned(FPhone.FOnLineInData) then
    FPhone.FOnLineInData(FPhone,Self,Data,DataSize);
end;

procedure TBisSipPhoneLine.DoInExtraData(Packet: TBisRtpPacket; Rtmap: TBisSdpRtpmapAttr);
begin
  if Assigned(FPhone.FOnLineInExtraData) then
    FPhone.FOnLineInExtraData(FPhone,Self,Packet,Rtmap);
end;

function TBisSipPhoneLine.DoOutData(const Data: Pointer; const DataSize: Cardinal): Boolean;
begin
  Result:=false;  
  if not FHolding and Assigned(FPhone.FOnLineOutData) then
    Result:=FPhone.FOnLineOutData(FPhone,Self,Data,DataSize);
end;

procedure TBisSipPhoneLine.DoPlayEnd;
begin
  if Assigned(FPhone.FOnLinePlayEnd) then
    FPhone.FOnLinePlayEnd(FPhone,Self);
end;

procedure TBisSipPhoneLine.Link(Line: TBisSipPhoneLine);
begin
  if Active and Assigned(Line) and Line.Active then begin
    if FLinks.IndexOf(Line)=-1 then begin
      Line.FNotifies.Add(Self);
      FLinks.Add(Line);
    end;
  end;
end;

procedure TBisSipPhoneLine.Unlink(Line: TBisSipPhoneLine);
begin
  if Assigned(Line) then begin
    FLinks.Remove(Line);
    Line.FNotifies.Remove(Self);
  end;
end;

function TBisSipPhoneLine.WordSwap(W: Word): Word;
begin
  Result:=Lo(W)+Hi(W);
end;

function TBisSipPhoneLine.LongWordSwap(LW: LongWord): LongWord;
begin
  Result:=Swap(LW shr 16)+Swap(LW) shl 16;
end;

function TBisSipPhoneLine.SetMessage(Message: TBisSipMessage): Boolean;

  function SetApplicationSdp: Boolean;
  var
    ContentLength: TBisSipContentLength;
    Origin: TBisSdpOrigin;
    Media: TBisSdpMedia;
    Connection: TBisSdpConnection;
    RtpmapAttr: TBisSdpRtpmapAttr;
    NewRtpmapAttr: TBisSdpRtpmapAttr;
    PtimeAttr: TBisSdpPtimeAttr;
    ModeAttr: TBisSdpModeAttr;
    Sdp, List: TBisSdp;
    i: Integer;
  begin
    Result:=Assigned(FRemoteDriverFormat);
    ContentLength:=TBisSipContentLength(Message.Headers.Find(TBisSipContentLength));
    if Assigned(ContentLength) and (ContentLength.AsInteger>0) then begin
      Sdp:=TBisSdp.Create;
      List:=TBisSdp.Create(false);
      try
        Sdp.Parse(Message.Body.AsString);

        Origin:=TBisSdpOrigin(Sdp.Find(TBisSdpOrigin));
        if Assigned(Origin) then begin
          FRemoteSessionId:=Origin.SessionId;
          FRemoteSessionVersion:=Origin.SessionVersion;
        end;

        Media:=TBisSdpMedia(Sdp.Find(TBisSdpMedia));
        if Assigned(Media) then begin
          FRemotePort:=Media.Port;
          FRemoteFormat:=Media.Formats.Text;

          Result:=(Media.MediaType=mtAudio) and (Media.ProtoType=mptRTPAVP);
        end;

        if Result then begin

          Connection:=TBisSdpConnection(Sdp.Find(TBisSdpConnection));
          if Assigned(Connection) then begin
            FRemoteHost:=Connection.Address;
            FRemoteIP:=FRemoteHost;
          end;

          FRemoteDriverFormat:=nil;
          FRemoteRtpmaps.Clear;

          Sdp.GetDescs(TBisSdpRtpmapAttr,List);

          for i:=0 to List.Count-1 do begin
            RtpmapAttr:=TBisSdpRtpmapAttr(List.Items[i]);

            if not Assigned(FRemoteDriverFormat) then begin
              FRemotePayloadType:=RtpmapAttr.PayloadType;
              FRemoteChannels:=RtpmapAttr.Channels;
              FRemoteSamplesPerSec:=RtpmapAttr.SamplesPerSec;
              FRemoteBitsPerSample:=RtpmapAttr.BitsPerSample;
              FRemoteDriverFormat:=FPhone.FDrivers.FindFormat(FRemotePayloadType,FRemoteChannels,
                                                              FRemoteSamplesPerSec,FRemoteBitsPerSample);
            end;

            if Assigned(FRemoteDriverFormat) then begin
              NewRtpmapAttr:=TBisSdpRtpmapAttr.Create;
              NewRtpmapAttr.CopyFrom(RtpmapAttr);
              FRemoteRtpmaps.Add(NewRtpmapAttr);
            end;
          end;

          PtimeAttr:=TBisSdpPtimeAttr(Sdp.Find(TBisSdpPtimeAttr));
          if Assigned(PtimeAttr) then
            FRemotePacketTime:=PtimeAttr.Value;

          ModeAttr:=TBisSdpModeAttr(Sdp.Find(TBisSdpModeAttr));
          if Assigned(ModeAttr) then
            FRemoteModeType:=ModeAttr.ModeType;

          Result:=Assigned(FRemoteDriverFormat);
        end;
      finally
        List.Free;
        Sdp.Free;
      end;
    end;
  end;

begin
  Result:=false;
  if Assigned(FSession) and Assigned(Message)  then begin
    case FSession.ContentTypeKind of
      ctkUnknown: ;
      ctkApplicationSdp: Result:=SetApplicationSdp;
    end;
  end;
end;

function TBisSipPhoneLine.SendPacket(Packet: TBisRtpPacket; WithAdd: Boolean): Boolean;
var
  Data: String;
begin
  Result:=false;
  if FServer.Active and Assigned(Packet) then begin
    if Packet.GetData(Data) then begin
      FServer.Send(FRemoteIP,FRemotePort,Data);
      if WithAdd then
        FOutPackets.Add(Packet);
      Result:=true;
    end;
  end;
end;

procedure TBisSipPhoneLine.SendConfirm;
var
  i: Integer;
  Packet: TBisRtpPacket;
  L: Integer;
  Data: TBytes;
  Sent: Boolean;
begin
  if Active then begin
    L:=GetPayloadLength(FLocalPayloadType,FLocalPacketTime,FLocalBitsPerSample,FLocalChannels);
    if L>0 then begin
      SetLength(Data,L);
      FTimeStamp:=GetTickCountEx;

      for i:=0 to FPhone.FLineConfirmCount-1 do begin
        Sent:=false;
        FillChar(Pointer(Data)^,L,i);

        Packet:=TBisRtpPacket.Create;
        try
          Packet.Version:=vSecond;
          Packet.Padding:=false;
          Packet.Extension:=false;
          Packet.Marker:=false;
          Packet.PayloadType:=FLocalPayloadType;
          Packet.Sequence:=FSequence;
          Packet.TimeStamp:=FTimeStamp;
          Packet.SSRCIdentifier:=FSSRCIdentifier;
          Packet.ExternalHeader:=ToBytes('');
          Packet.Payload:=Data;

          Sent:=SendPacket(Packet,false);
          if Sent then begin
            Inc(FSequence,1);
            Inc(FTimeStamp,L);
          end else begin
            break;
          end;

        finally
          if not Sent then
            Packet.Free;
        end;
      end;
    end;
  end;
end;

function TBisSipPhoneLine.GetPacketTime(PayloadType: TBisRtpPacketPayloadType; BitsPerSample, Channels: Word): Integer;
begin
  Result:=0;
  case PayloadType of
    ptPCMU,ptPCMA,ptGSM: Result:=20;
  end;
end;

function TBisSipPhoneLine.GetPayloadLength(PayloadType: TBisRtpPacketPayloadType; PacketTime, BitsPerSample, Channels: Word): Integer;
begin
  Result:=0;
  case PayloadType of
    ptPCMU,ptPCMA,ptGSM: Result:=PacketTime*BitsPerSample*Channels;
  end;
end;

function TBisSipPhoneLine.DefaultRemotePacket(Packet: TBisRtpPacket): Boolean;
var
  L: Integer;
begin
  Result:=(Packet.Version=vSecond) and
          (Packet.PayloadType=FRemotePayloadType);
  if Result then begin
    L:=GetPayloadLength(FRemotePayloadType,FRemotePacketTime,FRemoteBitsPerSample,FRemoteChannels);
    Result:=Length(Packet.Payload)=L;
  end;
end;

procedure TBisSipPhoneLine.SendData(Data: TBytes);
var
  L: Integer;
  Packet: TBisRtpPacket;
  Sent: Boolean;
begin
  L:=Length(Data);
  if L>0 then begin
    Sent:=false;
    Packet:=TBisRtpPacket.Create;
    try
      Packet.Version:=vSecond;
      Packet.Padding:=false;
      Packet.Extension:=false;
      Packet.Marker:=false;
      Packet.PayloadType:=FLocalPayloadType;
      Packet.Sequence:=FSequence;
      Packet.TimeStamp:=FTimeStamp;
      Packet.SSRCIdentifier:=FSSRCIdentifier;
      Packet.ExternalHeader:=ToBytes('');
      Packet.Payload:=Data;

      Sent:=SendPacket(Packet,true);
      if Sent then begin
        Inc(FSequence,1);
        Inc(FTimeStamp,L);
      end;
        
    finally
      if not Sent then
        Packet.Free;
    end;
  end;
end;

function TBisSipPhoneLine.HasFreshData: Boolean;
var
  TCount: Integer;
begin
  TCount:=GetTickCountEx;
  Result:=(TCount-FLastTickCount)<=FRemotePacketTime*10;
end;

procedure TBisSipPhoneLine.ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);

  procedure SendLinks(D: TBytes);
  var
    i: Integer;
    Item: TBisSipPhoneLine;
  begin
    for i:=0 to FLinks.Count-1 do begin
      Item:=TBisSipPhoneLine(FLinks.Items[i]);
      Item.SendData(D);        
    end;
  end;   

  procedure SendResponse;
  var
    D: TBytes;
    L: Integer;
  begin
    L:=GetPayloadLength(FLocalPayloadType,FLocalPacketTime,FLocalBitsPerSample,FLocalChannels);
    SetLength(D,L);
    if DoOutData(D,L) then
      SendData(D);
  end;

var
  Packet: TBisRtpPacket;
  Default: Boolean;
  L: Integer;
  i: Integer;
  PayloadType: TBisRtpPacketPayloadType;
  Rtpmap: TBisSdpRtpmapAttr;
begin
{  if (ABinding.PeerIP=FRemoteIP) and
     (ABinding.PeerPort=FRemotePort)  then begin}

    FLastTickCount:=GetTickCountEx; 
    L:=Length(AData);
    if (L>0) then begin

      Default:=false;
      Packet:=TBisRtpPacket.Create;
      try
        Packet.Parse(AData);
        Default:=DefaultRemotePacket(Packet);
        if Default then begin

          FInPackets.Add(Packet);
          DoInData(Pointer(Packet.Payload),Length(Packet.Payload));
  //        SendLinks(Packet.Payload);}

{          if Assigned(FPlayThread) then begin
            SetEvent(FPlayThread.FEvent)
          end else
            SendResponse;}

        end else begin

          PayloadType:=Packet.PayloadType;
          for i:=0 to FRemoteRtpmaps.Count-1 do begin
            Rtpmap:=TBisSdpRtpmapAttr(FRemoteRtpmaps.Items[i]);
            if PayloadType=Rtpmap.PayloadType then begin
              Default:=true;
              FInPackets.Add(Packet);
              DoInExtraData(Packet,Rtpmap);
            end;
          end;

        end;
      finally
        if not Default then
          Packet.Free;
      end;
    end;
//  end;
end;

function TBisSipPhoneLine.TryToActive: Boolean;
var
  First: Integer;
  MaxPort: Integer;
begin
  Result:=false;
  if not FServer.Active then begin
    First:=FBinding.Port;
    MaxPort:=POWER_2;
    while First<MaxPort do begin
      try
        FBinding.Port:=First;
        FServer.Active:=true;
        Result:=true;
        break;
      except
        on E: Exception do begin
          FServer.Active:=false;
          Inc(First,2);
        end;
      end;
    end;
  end;
end;

procedure TBisSipPhoneLine.Dial(Number: String);
var
  Sdp: TBisSdp;
  Media: TBisSdpMedia;
begin
  if Assigned(FSession) and (FSession.State=ssReady) and
     (FSession.Direction=sdOutgoing) then begin
    FNumber:=Number;
    if Assigned(FLocalDriverFormat) and (FLocalPayloadType<>ptUnknown) and TryToActive then begin
      Sdp:=TBisSdp.Create;
      try
        with Sdp do begin
          AddVersion;
          AddOrigin(FLocalSessionId,FLocalSessionVersion,oatIP4,FLocalIP);
          AddSession;
          AddConnection(oatIP4,FLocalIP);
          AddTiming;
          Media:=AddMedia(mtAudio,FBinding.Port,mptRTPAVP);
          if Assigned(Media) then
             Media.Formats.Add(TBisSdpRtpmapAttr.PayloadTypeToName(FLocalPayloadType));
          AddRtpmapAttr(FLocalPayloadType,FLocalEncondingType,FLocalSamplesPerSec);
          AddPtimeAttr(FLocalPacketTime);
          AddModeAttr(matSendrecv);
        end;
        FSession.RequestInvite(FNumber,Sdp.AsString,ctkApplicationSdp);
      finally
        Sdp.Free;
      end;
    end;
  end;
end;

procedure TBisSipPhoneLine.SetLocalDriverFormat;
var
  Rtpmap: TBisSdpRtpmapAttr;
  i: Integer;
begin
  for i:=0 to FRemoteRtpmaps.Count-1 do begin
    Rtpmap:=TBisSdpRtpmapAttr(FRemoteRtpmaps.Items[i]);
    FLocalDriverFormat:=FPhone.FDrivers.FindFormat(Rtpmap.PayloadType,Rtpmap.Channels,
                                                   Rtpmap.SamplesPerSec,Rtpmap.BitsPerSample);
    if Assigned(FLocalDriverFormat) then begin
      FLocalPayloadType:=Rtpmap.PayloadType;
      FLocalEncondingType:=Rtpmap.EncodingType;
      FLocalChannels:=Rtpmap.Channels;
      FLocalSamplesPerSec:=Rtpmap.SamplesPerSec;
      FLocalBitsPerSample:=Rtpmap.BitsPerSample;
      FLocalPacketTime:=GetPacketTime(Rtpmap.PayloadType,Rtpmap.BitsPerSample,Rtpmap.Channels);
      exit;
    end;
  end;
end;

procedure TBisSipPhoneLine.Answer;

  function GetSdpBody(var Body: String): Boolean;
  var
    Sdp: TBisSdp;
    Media: TBisSdpMedia;
  begin
    Result:=false;
    if Assigned(FLocalDriverFormat) and (FLocalPayloadType<>ptUnknown) and TryToActive then begin
      Sdp:=TBisSdp.Create;
      try
        with Sdp do begin
          AddVersion;
          AddOrigin(FLocalSessionId,FLocalSessionVersion,oatIP4,FLocalIP);
          AddSession;
          AddConnection(oatIP4,FLocalIP);
          AddTiming;
          Media:=AddMedia(mtAudio,FBinding.Port,mptRTPAVP);
          if Assigned(Media) then
             Media.Formats.Add(TBisSdpRtpmapAttr.PayloadTypeToName(FLocalPayloadType));
          AddRtpmapAttr(FLocalPayloadType,FLocalEncondingType,FLocalSamplesPerSec);
          AddPtimeAttr(FLocalPacketTime);
          AddModeAttr(matSendrecv);
        end;
        Body:=Sdp.AsString;
        Result:=true
      finally
        Sdp.Free;
      end;
    end;
  end;

var
  Body: String;
begin
  if FPhone.Connected and
     Assigned(FSession) and (FSession.State in [ssRinging,ssProgressing]) and
     (FSession.Direction in [sdIncoming,sdOutgoing]) and
     (FSession.ContentTypeKind=ctkApplicationSdp) then begin

    SetLocalDriverFormat;
    if GetSdpBody(Body) then begin
      case FSession.Direction of
        sdIncoming: FSession.ResponseInviteOK(Body,ctkApplicationSdp);
        sdOutgoing: ;
      end;
    end;
  end;
end;

procedure TBisSipPhoneLine.Hangup;
begin
  if FPhone.Connected and Assigned(FSession) and
     (FSession.Direction in [sdIncoming,sdOutgoing]) and
     (FSession.State in [ssBreaking,ssWaiting,ssRinging,ssProgressing,ssProcessing]) then begin
    case FSession.State of
      ssBreaking: FPhone.FRegistrar.Sessions.Remove(FSession);
      ssWaiting: FSession.RequestCancel;
      ssRinging,ssProgressing: begin
        case FSession.Direction of
          sdIncoming: FSession.ResponseInviteBusyHere;
          sdOutgoing: FSession.RequestCancel;
        end;
      end;
      ssProcessing: FSession.RequestBye;
    end;
  end;
end;

procedure TBisSipPhoneLine.HoldUnHold(Flag: Boolean);
var
  Sdp: TBisSdp;
  Media: TBisSdpMedia;
begin
  if FPhone.Connected and
     Assigned(FSession) and (FSession.State=ssProcessing) and
     (FSession.Direction in [sdIncoming,sdOutgoing]) and
     Active then begin

    if Assigned(FLocalDriverFormat) and (FLocalPayloadType<>ptUnknown) then begin
      if FPhone.FLineHoldMode=lhmStandart then begin
        Sdp:=TBisSdp.Create;
        try
          Inc(FLocalSessionVersion);
          with Sdp do begin
            AddVersion;
            AddOrigin(FLocalSessionId,FLocalSessionVersion,oatIP4,FLocalIP);
            AddSession;
            AddConnection(oatIP4,iff(Flag,FLocalEmptyAddress,FLocalIP));
            AddTiming;
            Media:=AddMedia(mtAudio,FBinding.Port,mptRTPAVP);
            if Assigned(Media) then
               Media.Formats.Add(TBisSdpRtpmapAttr.PayloadTypeToName(FLocalPayloadType));
            AddRtpmapAttr(FLocalPayloadType,FLocalEncondingType,FLocalSamplesPerSec);
            AddPtimeAttr(FLocalPacketTime);
            AddModeAttr(iff(Flag,matSendonly,matSendrecv));
          end;
          FSession.RequestInvite(FNumber,Sdp.AsString,ctkApplicationSdp);
          FWaitHoldUnHold:=true;
        finally
          Sdp.Free;
        end;
      end else begin
        FHolding:=Flag;
        if FHolding then
          StopSendThread
        else
          StartSendThread;
        if Assigned(FPhone.FOnLineHold) then
          FPhone.FOnLineHold(FPhone,Self);
      end;
    end;
    
  end;
end;

procedure TBisSipPhoneLine.Hold;
begin
  HoldUnHold(true);
end;

procedure TBisSipPhoneLine.UnHold;
begin
  HoldUnHold(false);
end;


{ TBisSipPhoneLines }

constructor TBisSipPhoneLines.Create(Phone: TBisSipPhone);
begin
  inherited Create;
  FPhone:=Phone;
end;

function TBisSipPhoneLines.GetItem(Index: Integer): TBisSipPhoneLine;
begin
  Result:=TBisSipPhoneLine(inherited Items[Index]);
end;

function TBisSipPhoneLines.LastLocalPort: Integer;
begin
  Result:=FPhone.LineLocalPort;
  if Count>0 then begin
    Result:=Items[Count-1].FBinding.Port;
  end;
end;

procedure TBisSipPhoneLines.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if Assigned(Ptr) and OwnsObjects and (Action=lnDeleted) then begin
    FPhone.FRegistrar.FDestroy:=true;
    try
      TBisSipPhoneLine(Ptr).Hangup;
      FPhone.FRegistrar.Sessions.Remove(TBisSipPhoneLine(Ptr).FSession);
    finally
      FPhone.FRegistrar.FDestroy:=false;
    end;
  end;
  inherited Notify(Ptr,Action);
end;

function TBisSipPhoneLines.Exists(Line: TBisSipPhoneLine): Boolean;
begin
  Result:=IndexOf(Line)<>-1;
end;

function TBisSipPhoneLines.Find(Session: TBisSipSession): TBisSipPhoneLine;
var
  i: Integer;
  Item: TBisSipPhoneLine;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.FSession=Session then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisSipPhoneLines.Add(Session: TBisSipSession): TBisSipPhoneLine;
begin
  Result:=TBisSipPhoneLine.Create(FPhone);
  Result.FSession:=Session;
  Result.FLocalIP:=FPhone.FRegistrar.LocalIP;
  Result.FBinding.IP:=FPhone.FLocalIP;
  Result.FBinding.Port:=LastLocalPort;
  inherited Add(Result);
end;

{ TBisSipPhoneAcmDrivers }

function TBisSipPhoneAcmDrivers.PayloadTypeToFormatTag(PayloadType: TBisRtpPacketPayloadType): LongWord;
begin
  Result:=0;
  case PayloadType of
    ptPCMU: Result:=$0007;
    ptGSM: Result:=$0031;
    ptG723: Result:=$0043;
    ptPCMA: Result:=$0006;
  end;
end;

function TBisSipPhoneAcmDrivers.FormatToPayloadType(DriverFormat: TBisAcmDriverFormat): TBisRtpPacketPayloadType;
begin
  Result:=ptUnknown;
  if Assigned(DriverFormat) then begin
    if Assigned(DriverFormat.WaveFormat) then begin
      case DriverFormat.WaveFormat.wFormatTag of
        $0007: Result:=ptPCMU;
        $0031: Result:=ptGSM;
        $0043: Result:=ptG723;
        $0006: Result:=ptPCMA;
      end;
    end;
  end;
end;

function TBisSipPhoneAcmDrivers.FindFormat(DriverName, FormatName: String;
                                           Channels: Word; SamplesPerSec: Longword; BitsPerSample: Word): TBisAcmDriverFormat;
begin
  Result:=inherited FindFormat(DriverName,FormatName,Channels,SamplesPerSec,BitsPerSample);
end;

function TBisSipPhoneAcmDrivers.FindFormat(PayloadType: TBisRtpPacketPayloadType;
                                           Channels: Word; SamplesPerSec: Longword; BitsPerSample: Word): TBisAcmDriverFormat;
var
  FormatTag: LongWord;
begin
  Result:=nil;
  FormatTag:=PayloadTypeToFormatTag(PayloadType);
  if FormatTag>0 then
    Result:=inherited FindFormat('',FormatTag,Channels,SamplesPerSec,BitsPerSample);
end;

{ TBisSipPhone }

constructor TBisSipPhone.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FScheme:=DefaultScheme;
  FProtocol:=DefaultProtocol;
  FLocalHost:='localhost';
  FLocalPort:=DefaultSipPort;;
  FMaxForwards:=70;
  FExpires:=3600;
  FMaxLines:=10;
  FKeepAlive:=30;
  FRequestRetryCount:=5;
  FRequestTimeOut:=3;
  FLineHoldMode:=lhmEmulate;

  FLineIdleTimeOut:=60;
  FLineLocalPort:=20000;
  FLineDriverName:='';
  FLineFormatName:='CCITT A-Law';
  FLineChannels:=1;
  FLineSamplesPerSec:=8000;
  FLineBitsPerSample:=8;
  FLineConfirmCount:=0;

  FTransport:=TBisSipPhoneTransport.Create(Self);

  FRegistrar:=TBisSipPhoneRegistrar.Create(Self);
  FRegistrar.Transport:=FTransport;

  FLines:=TBisSipPhoneLines.Create(Self);

  FDrivers:=TBisSipPhoneAcmDrivers.Create;

  FConnected:=false;
end;

destructor TBisSipPhone.Destroy;
begin
  FDrivers.Free;
  FLines.Free;
  if FRegistrar.Registered then
    FRegistrar.Register(false);
  FRegistrar.Free;
  FTransport.Free;
  inherited Destroy;
end;

procedure TBisSipPhone.Connect;
var
  IP: String;
  Port: Integer;
begin
  Disconnect;
  if not FConnected then begin

    FRegistrar.Scheme:=FScheme;
    FRegistrar.Protocol:=FProtocol;
    FRegistrar.RemoteHost:=FRemoteHost;
    FRegistrar.RemoteIP:=FRemoteHost;
    FRegistrar.RemotePort:=FRemotePort;
    if IsIP(FRemoteHost) then
      FRegistrar.RemoteIP:=FRemoteHost
    else begin
      if ResolveSipIPAndPort(FRegistrar.Scheme,FRegistrar.TransportName,FRemoteHost,IP,Port) then begin
        FRegistrar.RemoteIP:=IP;
        FRegistrar.RemotePort:=Port;
      end;
    end;
//    FRegistrar.LocalHost:=FLocalHost;
    FLocalIP:=ResolveIP(FLocalHost);
    FRegistrar.LocalIP:=FLocalIP;
    FRegistrar.LocalPort:=FLocalPort;
    FRegistrar.UserName:=FUserName;
    FRegistrar.Password:=FPassword;
    FRegistrar.Expires:=FExpires;
    FRegistrar.UserAgent:=FUserAgent;
    FRegistrar.MaxForwards:=FMaxForwards;
    FRegistrar.KeepAlive:=FKeepAlive;
    FRegistrar.UseReceived:=FUseReceived;
    FRegistrar.UseRport:=FUseRport;
    FRegistrar.UseTrasnportNameInUri:=FUseTrasnportNameInUri;
    FRegistrar.UsePortInUri:=FUsePortInUri;
    FRegistrar.UseGlobalSequence:=FUseGlobalSequence;
    FRegistrar.WaitRetryCount:=FRequestRetryCount;
    FRegistrar.WaitTimeOut:=FRequestTimeOut*1000;
    FRegistrar.SessionIdleTimeOut:=FLineIdleTimeOut*1000;

    FTransport.Active:=false;
    if not FTransport.Active then begin
      FTransport.FServer.Bindings.Clear;
      with FTransport.FServer.Bindings.Add do begin
        IP:=FRegistrar.LocalIP;
        Port:=FLocalPort;
      end;
      FTransport.Active:=true;
    end;

    FRegistrar.Register(true);
  end;
end;

procedure TBisSipPhone.Disconnect;
begin
  if FConnected then begin
    FRegistrar.Register(false,true);
  end;
end;

procedure TBisSipPhone.Dial(Number: String);
var
  Line: TBisSipPhoneLine;
  Session: TBisSipSession;
begin
  if FConnected then begin
    Session:=FRegistrar.Sessions.Add(sdOutgoing);
    Line:=FLines.Find(Session);
    if Assigned(Line) then begin
      Line.Dial(Number);
    end;
  end;
end;

procedure TBisSipPhone.Answer(Line: TBisSipPhoneLine);
begin
  if FConnected and FLines.Exists(Line) then
    Line.Answer;
end;

procedure TBisSipPhone.Hangup(Line: TBisSipPhoneLine);
begin
  if FConnected and FLines.Exists(Line) then
    Line.Hangup;
end;

procedure TBisSipPhone.Hold(Line: TBisSipPhoneLine);
begin
  if FConnected and FLines.Exists(Line) then
    Line.Hold;
end;

procedure TBisSipPhone.Unhold(Line: TBisSipPhoneLine);
begin
  if FConnected and FLines.Exists(Line) then
    Line.UnHold;
end;

end.
