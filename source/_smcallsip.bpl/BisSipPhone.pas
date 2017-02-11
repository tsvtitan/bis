unit BisSipPhone;

interface

uses SysUtils, Classes, Contnrs, mmSystem, SyncObjs,
     IdGlobal, IdUdpServer, IdUdpClient, IdSocketHandle, IdException,
     WaveACMDrivers,
     BisSip, BisSdp, BisRtp, BisWave, BisThread;

type
  TBisSipPhone=class;

  TBisSipPhoneTransportUDPServer=class(TIdUDPServer)
  end;

  TBisSipPhoneTransport=class(TBisSipTransport)
  private
    FPhone: TBisSipPhone;
    FServer: TBisSipPhoneTransportUDPServer;
    FLock: TCriticalSection;
    FEnabled: Boolean;
    procedure ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure ServerUDPException(Sender: TObject; ABinding: TIdSocketHandle; const AMessage: String; const AExceptionClass: TClass);
    function GetListenThread: TThread;
  protected
    class function GetName: String; override;
    function GetActive: Boolean; override;
    procedure SetActive(const Value: Boolean); override;
    function Send(Host: String; Port: Integer; Data: String): Boolean; override;
  public
    constructor Create(Phone: TBisSipPhone); reintroduce;
    destructor Destroy; override;

    property ListenThread: TThread read GetListenThread;

    property Enabled: Boolean read FEnabled write FEnabled; 
  end;

  TBisSipPhoneRegistrar=class(TBisSipRegistrar)
  private
    FPhone: TBisSipPhone;
    FDestroying: Boolean;
  protected
    procedure DoRegister; override;
    procedure DoMessageTimeout(Message: TBisSipMessage; var TryRegister: Boolean); override;
    procedure DoSessionCreate(Session: TBisSipSession); override;
    procedure DoSessionDestroy(Session: TBisSipSession); override;
    function DoSessionAccept(Session: TBisSipSession; Message: TBisSipMessage): Boolean; override;
    procedure DoSessionRing(Session: TBisSipSession); override;
    procedure DoSessionProgress(Session: TBisSipSession); override;
    procedure DoSessionConfirm(Session: TBisSipSession); override;
    procedure DoSessionTerminate(Session: TBisSipSession); override;
    function DoSessionAlive(Session: TBisSipSession): Boolean; override;
    procedure DoSessionTimeout(Session: TBisSipSession; var TryRegister: Boolean); override;
    procedure DoSessionContent(Session: TBisSipSession; Content: String); override;
  public
    constructor Create(Phone: TBisSipPhone); reintroduce;
  end;

  TBisSipPhoneLine=class;

  TBisSipPhoneLinePlayThread=class(TBisThread)
  private
    FLine: TBisSipPhoneLine;
    FStream: TMemoryStream;
    FLoopCount: Integer;
    FEnd: Boolean;
    FEvent: TEvent;
  public
    constructor Create(Line: TBisSipPhoneLine); reintroduce;
    destructor Destroy; override;
    procedure Execute; override;
    procedure Terminate;
  end;

  TBisSipPhoneLineUDPServer=class(TIdUDPServer)
  protected
    function GetBinding: TIdSocketHandle; override;
  end;

  TBisSipPhoneLineDirection=(ldUnknown,ldIncoming,ldOutgoing);
  TBisSipPhoneLineHoldMode=(lhmStandart,lhmEmulate);

  TBisSipPhoneLine=class(TObject)
  private
    FPhone: TBisSipPhone;
    FLock: TCriticalSection;
    FPlayThread: TBisSipPhoneLinePlayThread;
    FNumber: String;
    FSession: TBisSipSession;
    FWaitHoldUnHold: Boolean;
    FHolding: Boolean;
    FLastTickCount: Integer;
    FRinging: Boolean;
    FSweepTimeout: Integer;

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
    FRemoteDriverFormat: TWaveAcmDriverFormat;
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
    FLocalDriverFormat: TWaveAcmDriverFormat;
    FLocalPacketTime: Word;
    FLocalEmptyAddress: String;

    FSequence: Word;
    FTimeStamp: LongWord;
    FSSRCIdentifier: LongWord;
    FServer: TBisSipPhoneLineUDPServer;
    FBinding: TIdSocketHandle;
    FInPackets: TBisRtpPackets;
    FOutPackets: TBisRtpPackets;                 

    procedure StartPlayThread(Stream: TStream; LoopCount: Integer);
    procedure StopPlayThread;
    procedure TerminatePlayThread(Sender: TObject);
    procedure ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure ServerUDPException(Sender: TObject; ABinding: TIdSocketHandle; const AMessage: String; const AExceptionClass: TClass);
    function GetPayloadLength(PayloadType: TBisRtpPacketPayloadType; PacketTime, BitsPerSample, Channels: Word): Integer;
    function GetPacketTime(PayloadType: TBisRtpPacketPayloadType; BitsPerSample, Channels: Word): Integer;
    function DefaultRemotePacket(Packet: TBisRtpPacket): Boolean;
//    function SetMessage(Message: TBisSipMessage): Boolean;
    function SetContent(Content: String): Boolean;
    function TryToActive: Boolean;
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
    function GetListenThread: TThread;
    function GetRemotePayloadLength: Integer;
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
    procedure PlayStart(Stream: TStream; LoopCount: Integer=MaxInt);
    procedure PlayStop;
    procedure SendData(Data: TBytes); overload;
    procedure SendData(const Data: Pointer; const DataSize: Cardinal); overload;

    property Active: Boolean read GetActive;
    property Number: String read FNumber;
    property Direction: TBisSipPhoneLineDirection read GetDirection;
    property Holding: Boolean read FHolding;
    property Playing: Boolean read GetPlaying;
    property ListenThread: TThread read GetListenThread;

    property InPackets: TBisRtpPackets read FInPackets;
    property InFormat: PWaveFormatEx read GetInFormat;

    property OutPackets: TBisRtpPackets read FOutPackets;
    property OutFormat: PWaveFormatEx read GetOutFormat;

    property RemotePayloadType: TBisRtpPacketPayloadType read FRemotePayloadType;
    property RemotePayloadLength: Integer read GetRemotePayloadLength;

    property LocalPayloadType: TBisRtpPacketPayloadType read FLocalPayloadType;
    property LocalPacketTime: Word read FLocalPacketTime;   
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
    function ActiveCount: Integer;

    property Items[Index: Integer]: TBisSipPhoneLine read GetItem; default;
  end;

  TBisSipPhoneAcmDrivers=class(TBisAcmDrivers)
  private
    function PayloadTypeToFormatTag(PayloadType: TBisRtpPacketPayloadType): LongWord;
    function FormatToPayloadType(DriverFormat: TWaveAcmDriverFormat): TBisRtpPacketPayloadType;
  public
    function FindFormat(DriverName, FormatName: String;
                        Channels: Word; SamplesPerSec: Longword; BitsPerSample: Word): TWaveAcmDriverFormat; overload;
    function FindFormat(PayloadType: TBisRtpPacketPayloadType;
                        Channels: Word; SamplesPerSec: Longword; BitsPerSample: Word): TWaveAcmDriverFormat; overload;
  end;

  TBisSipPhoneSweepThread=class(TBisThread)
  private
    FPhone: TBisSipPhone;
    FEvent: TEvent;
  public
    constructor Create(Phone: TBisSipPhone); reintroduce;
    destructor Destroy; override;
    procedure Execute; override;
    procedure Terminate;
  end;

  TBisSipPhoneEvent=procedure (Sender: TBisSipPhone) of object;
  TBisSipPhoneSendDataEvent=procedure (Sender: TBisSipPhone; Host: String; Port: Integer; Data: String) of object;
  TBisSipPhoneReceiveDataEvent=TBisSipPhoneSendDataEvent;
  TBisSipPhoneErrorEvent=procedure (Sender: TBisSipPhone; const Message: String) of object;
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
    FSweepThread: TBisSipPhoneSweepThread;

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
    FCollectInPackets: Boolean;
    FCollectOutPackets: Boolean;
    FOnLineTimeout: TBisSipPhoneLineEvent;
    FOnError: TBisSipPhoneErrorEvent;
    FLineSweepInterval: Integer;
    function GetBusy: Boolean;
    procedure SweepLines;

    procedure StartSweepThread;
    procedure StopSweepThread;
    procedure SweepThreadTerminate(Sender: TObject);
  protected
    procedure DoError(const Message: String);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;
    function AddLine(Direction: TBisSipPhoneLineDirection): TBisSipPhoneLine;
    procedure Dial(Number: String);
    procedure Answer(Line: TBisSipPhoneLine);
    procedure Hangup(Line: TBisSipPhoneLine);
    procedure Hold(Line: TBisSipPhoneLine);
    procedure Unhold(Line: TBisSipPhoneLine);

    property Connected: Boolean read FConnected;
    property Transport: TBisSipPhoneTransport read FTransport;
    property Lines: TBisSipPhoneLines read FLines;
    property Busy: Boolean read GetBusy;

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
    property CollectInPackets: Boolean read FCollectInPackets write FCollectInPackets;
    property CollectOutPackets: Boolean read FCollectOutPackets write FCollectOutPackets;

    property LineIdleTimeOut: Integer read FLineIdleTimeOut write FLineIdleTimeOut;
    property LineLocalPort: Integer read FLineLocalPort write FLineLocalPort;
    property LineDriverName: String read FLineDriverName write FLineDriverName;
    property LineFormatName: String read FLineFormatName write FLineFormatName;
    property LineChannels: Word read FLineChannels write FLineChannels;
    property LineSamplesPerSec: LongWord read FLineSamplesPerSec write FLineSamplesPerSec;
    property LineBitsPerSample: Word read FLineBitsPerSample write FLineBitsPerSample;
    property LineConfirmCount: Integer read FLineConfirmCount write FLineConfirmCount;
    property LineHoldMode: TBisSipPhoneLineHoldMode read FLineHoldMode write FLineHoldMode;
    property LineSweepInterval: Integer read FLineSweepInterval write FLineSweepInterval; 

    property OnSendData: TBisSipPhoneSendDataEvent read FOnSendData write FOnSendData;
    property OnReceiveData: TBisSipPhoneReceiveDataEvent read FOnReceiveData write FOnReceiveData;
    property OnConnect: TBisSipPhoneEvent read FOnConnect write FOnConnect;
    property OnDisconnect: TBisSipPhoneEvent read FOnDisconnect write FOnDisconnect;
    property OnError: TBisSipPhoneErrorEvent read FOnError write FOnError; 
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
    property OnLineTimeout: TBisSipPhoneLineEvent read FOnLineTimeout write FOnLineTimeout;
  end;


implementation

uses Windows, DateUtils,
     IdStack, IdDnsResolver,
     BisUtils, BisIPUtils, BisCore;

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

  FServer:=TBisSipPhoneTransportUDPServer.Create(nil);
  FServer.OnUDPRead:=ServerUDPRead;
  FServer.OnUDPException:=ServerUDPException;
  FServer.ThreadedEvent:=false;
  FServer.ThreadName:='SipPhoneTransport';
end;

destructor TBisSipPhoneTransport.Destroy;
begin
  FServer.OnUDPRead:=nil;
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

function TBisSipPhoneTransport.GetListenThread: TThread;
begin
  Result:=FServer.FListenerThread;
end;

procedure TBisSipPhoneTransport.SetActive(const Value: Boolean);
begin
  FServer.Active:=Value;
end;

procedure TBisSipPhoneTransport.ServerUDPException(Sender: TObject; ABinding: TIdSocketHandle; const AMessage: String;
                                                   const AExceptionClass: TClass);
begin
  if Assigned(FPhone) and (Trim(AMessage)<>'') then
    FPhone.DoError(AMessage);
end;

procedure TBisSipPhoneTransport.ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
var
  S: String;
begin
  if Assigned(FPhone) and Assigned(FPhone.FRegistrar) and
     Assigned(FPhone.FTransport) and FPhone.FTransport.Enabled then begin
    if (ABinding.PeerIP=FPhone.FRegistrar.RemoteIP) and
       (ABinding.PeerPort=FPhone.FRegistrar.RemotePort)  then begin
      try
        S:=BytesToString(AData);
        if Assigned(FPhone.FOnReceiveData) then
          FPhone.FOnReceiveData(FPhone,ABinding.PeerIP,ABinding.PeerPort,S);
        Receivers.Receive(S);
      except
        On E: Exception do begin
          FPhone.DoError(E.Message);
        end;
      end;
    end;
  end;
end;

function TBisSipPhoneTransport.Send(Host: String; Port: Integer; Data: String): Boolean;
begin
  Result:=false;
  if Assigned(FPhone) and
     Assigned(FPhone.FTransport) and FPhone.FTransport.Enabled then begin
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
          FPhone.DoError(E.Message);
        end;
      end;
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

procedure TBisSipPhoneRegistrar.DoMessageTimeout(Message: TBisSipMessage; var TryRegister: Boolean);
begin
  //
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
  if not FDestroying then begin
    FDestroying:=true;
    try
      with FPhone do begin
        Line:=FLines.Find(Session);
        if Assigned(Line) and Assigned(FOnLineDestroy) then
          FOnLineDestroy(FPhone,Line);
        FLines.Remove(Line);
      end;
    finally
      FDestroying:=false;
    end;
  end;
end;

procedure TBisSipPhoneRegistrar.DoSessionContent(Session: TBisSipSession; Content: String);
var
  Line: TBisSipPhoneLine;
begin
  with FPhone do begin
    Line:=FLines.Find(Session);
    if Assigned(Line) then
      Line.SetContent(Content);
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
    if Assigned(Line) and (FLines.ActiveCount<FMaxLines) then begin
      case Session.Direction of
        sdIncoming: begin
          Line.FNumber:=GetLineNumber;
          if Assigned(FOnLineCheck) then begin
            Result:=FOnLineCheck(FPhone,Line);
            if Result then
              Result:=Line.SetContent(Message.Body.Text);
          end;
        end;
        sdOutgoing: begin
          if Assigned(FOnLineCheck) then begin
            Result:=FOnLineCheck(FPhone,Line);
            if Result then
              Result:=Line.SetContent(Message.Body.Text);
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
        if Assigned(FOnLineConnect) then
          FOnLineConnect(FPhone,Line);
      end else begin
        Line.FWaitHoldUnHold:=false;
        Line.FHolding:=not Line.FHolding;
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
    if Assigned(Line) then begin
      Result:=Line.Active;
      if (Session.State=ssProcessing) then
        Result:=Line.HasFreshData;
    end;
  end;
end;

procedure TBisSipPhoneRegistrar.DoSessionTimeout(Session: TBisSipSession; var TryRegister: Boolean);
var
  Line: TBisSipPhoneLine;
begin
  with FPhone do begin
    Line:=FLines.Find(Session);
    if Assigned(Line) then begin
      if Assigned(FOnLineTimeout) then
        FOnLineTimeout(FPhone,Line);      
    end;
  end;
end;

{ TBisSipPhoneLinePlayThread }

constructor TBisSipPhoneLinePlayThread.Create(Line: TBisSipPhoneLine);
begin
  inherited Create;
  FreeOnTerminate:=true;
  Priority:=tpHighest;
  FLine:=Line;
  FStream:=TMemoryStream.Create;
  FEvent:=TEvent.Create(nil,false,false,'');
end;

destructor TBisSipPhoneLinePlayThread.Destroy;
begin
  FLine:=nil;
  FEvent.SetEvent;
  FEvent.Free;
  FStream.Free;
  inherited Destroy;
end;

procedure TBisSipPhoneLinePlayThread.Terminate;
begin
  FEvent.SetEvent;
  inherited Terminate;
end;

procedure TBisSipPhoneLinePlayThread.Execute;
var
  L: Integer;
  Flag: Boolean;
  LCount: Integer;
  AData: TBytes;
  Ret: TWaitResult;
begin
  inherited Execute;
  if Assigned(FLine) then begin
    with FLine do begin
      LCount:=0;
      FEnd:=false;
      L:=GetPayloadLength(FLocalPayloadType,FLocalPacketTime,FLocalBitsPerSample,FLocalChannels);
      SetLength(AData,L);
      FStream.Position:=0;
      Flag:=true;
      while Flag do begin
        Flag:=FStream.Position<FStream.Size;
        if Flag then begin
          FEvent.ResetEvent;
          Ret:=FEvent.WaitFor(FLocalPacketTime);
          if not Terminated then begin
            if Ret=wrTimeout then begin
              FStream.Read(Pointer(AData)^,L);
              if Assigned(FLine) then
                SendData(AData);
            end else
              Terminate;
          end;
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

{ TBisSipPhoneLineUDPServer }

function TBisSipPhoneLineUDPServer.GetBinding: TIdSocketHandle;
begin
  Result:=inherited GetBinding;
  if Assigned(FListenerThread) then begin
    FListenerThread.Priority:=tpHighest;
  end;
end;

{ TBisSipPhoneLine }

constructor TBisSipPhoneLine.Create(Phone: TBisSipPhone);
begin
  inherited Create;
  FPhone:=Phone;

  FLock:=TCriticalSection.Create;

  FServer:=TBisSipPhoneLineUDPServer.Create(nil);
  FServer.OnUDPRead:=ServerUDPRead;
  FServer.OnUDPException:=ServerUDPException;
  FServer.ThreadedEvent:=true;
  FServer.ThreadName:='SipPhoneLineListen';

  FBinding:=FServer.Bindings.Add;

  FInPackets:=TBisRtpPackets.Create;
  FOutPackets:=TBisRtpPackets.Create;

  FRemoteRtpmaps:=TBisSdp.Create;

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
  FRemoteRtpmaps.Free;
  FOutPackets.Free;
  FInPackets.Free;
  FServer.OnUDPRead:=nil;
  FServer.Free;
  FLock.Free;
  inherited Destroy;
end;

procedure TBisSipPhoneLine.StopPlayThread;
begin
  if Assigned(FPlayThread) then begin
    FPlayThread.Terminate;
    FPlayThread:=nil;
{    FPlayThread.FreeOnTerminate:=false;
    FPlayThread.Free;
    FPlayThread:=nil;}
  end;
end;

procedure TBisSipPhoneLine.TerminatePlayThread(Sender: TObject);
var
  Flag: Boolean;
  Thread: TBisSipPhoneLinePlayThread;
begin
  if Assigned(Sender) and (Sender is TBisSipPhoneLinePlayThread) then begin
    Thread:=TBisSipPhoneLinePlayThread(Sender);
    Flag:=Thread.FEnd;
    if Flag then
      DoPlayEnd;
  end;
end;

procedure TBisSipPhoneLine.StartPlayThread(Stream: TStream; LoopCount: Integer);
var
  OldPos: Int64;
  Size: Int64;
begin
  StopPlayThread;
  if Active and not Assigned(FPlayThread) and Assigned(Stream) then begin
    OldPos:=Stream.Position;
    try
      Size:=Stream.Size-Stream.Position;
      if Size>0 then begin
        FPlayThread:=TBisSipPhoneLinePlayThread.Create(Self);
        FPlayThread.FStream.CopyFrom(Stream,Size);
        FPlayThread.FLoopCount:=LoopCount;
//        FPlayThread.FreeOnTerminate:=true;
        FPlayThread.OnTerminate:=TerminatePlayThread;
        FPlayThread.Resume;

        if Assigned(FPhone.FOnLinePlayBegin) then
          FPhone.FOnLinePlayBegin(FPhone,Self);
      end;
    finally
      Stream.Position:=OldPos;
    end;
  end;
end;

procedure TBisSipPhoneLine.PlayStop;
begin
  StopPlayThread;
end;

procedure TBisSipPhoneLine.PlayStart(Stream: TStream; LoopCount: Integer);
begin
  StartPlayThread(Stream,LoopCount);
end;

function TBisSipPhoneLine.GetPlaying: Boolean;
begin
  Result:=Assigned(FPlayThread);
end;

function TBisSipPhoneLine.GetRemotePayloadLength: Integer;
begin
  Result:=GetPayloadLength(FRemotePayloadType,FRemotePacketTime,FRemoteBitsPerSample,FRemoteChannels);
end;

function TBisSipPhoneLine.GetActive: Boolean;
begin
  Result:=FServer.Active and Assigned(FSession);
  if Result then begin
    Result:=(FSession.State in [ssProcessing,ssConfirming]);
  end;
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

function TBisSipPhoneLine.GetListenThread: TThread;
begin
  Result:=FServer.FListenerThread;
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

{function TBisSipPhoneLine.SetMessage(Message: TBisSipMessage): Boolean;

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
end;}

function TBisSipPhoneLine.SetContent(Content: String): Boolean;

  function SetApplicationSdp: Boolean;
  var
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
    if Trim(Content)<>'' then begin
      Sdp:=TBisSdp.Create;
      List:=TBisSdp.Create(false);
      try
        Sdp.Parse(Content);

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
  if Assigned(FSession) then begin
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
      if WithAdd and FPhone.FCollectOutPackets then
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
            Inc(FSequence);
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

procedure TBisSipPhoneLine.SendData(const Data: Pointer; const DataSize: Cardinal);
var
  D: TBytes;
begin
  FLock.Enter;
  try
    SetLength(D,DataSize);
    Move(Data^,D,DataSize);
    SendData(D);
  finally
    FLock.Leave;
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
  try
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
          Inc(FSequence);
          Inc(FTimeStamp,L);
        end;

      finally
        if not Sent then
          Packet.Free;
      end;
    end;
  except
    On E: Exception do begin
      FPhone.DoError(E.Message);
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

procedure TBisSipPhoneLine.ServerUDPException(Sender: TObject; ABinding: TIdSocketHandle; const AMessage: String;
                                              const AExceptionClass: TClass);
begin
  if Assigned(FPhone) and (Trim(AMessage)<>'') then
    FPhone.DoError(AMessage);
end;

procedure TBisSipPhoneLine.ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
var
  Packet: TBisRtpPacket;
  Default: Boolean;
  L: Integer;
  i: Integer;
  PayloadType: TBisRtpPacketPayloadType;
  Rtpmap: TBisSdpRtpmapAttr;
begin
  FLock.Enter;
  try
    if (ABinding.PeerIP=FRemoteIP) and
       (ABinding.PeerPort=FRemotePort)  then begin
      try
        FLastTickCount:=GetTickCountEx;
        FSweepTimeout:=0;
        
        L:=Length(AData);
        if (L>0) then begin

          Default:=false;
          Packet:=TBisRtpPacket.Create;
          try
            Packet.Parse(AData);
            Default:=DefaultRemotePacket(Packet);
            if Default then begin

              if FPhone.FCollectInPackets then
                FInPackets.Add(Packet);

              DoInData(Pointer(Packet.Payload),Length(Packet.Payload));

            end else begin

              PayloadType:=Packet.PayloadType;
              for i:=0 to FRemoteRtpmaps.Count-1 do begin
                Rtpmap:=TBisSdpRtpmapAttr(FRemoteRtpmaps.Items[i]);
                if PayloadType=Rtpmap.PayloadType then begin
                  Default:=true;
                  if FPhone.FCollectInPackets then
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
      except
        On E: Exception do begin
          FPhone.DoError(E.Message);
        end;
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

function TBisSipPhoneLine.TryToActive: Boolean;
var
  First: Integer;
  MaxPort: Integer;
begin
  Result:=false;
  if not FServer.Active then begin
    Core.ExceptNotifier.IngnoreExceptions.Add(EIdException);
    try
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
    finally
      Core.ExceptNotifier.IngnoreExceptions.Remove(EIdException);
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
var
  Line: TBisSipPhoneLine;
begin
  Line:=TBisSipPhoneLine(Ptr);
  if Assigned(Line) and OwnsObjects and (Action=lnDeleted) then begin
    Line.Hangup;
    if not FPhone.FRegistrar.FDestroying then begin
      FPhone.FRegistrar.FDestroying:=true;
      try
        FPhone.FRegistrar.Sessions.Remove(Line.FSession);
        inherited Notify(Ptr,Action);
      finally
        FPhone.FRegistrar.FDestroying:=false;
      end;
    end else
      inherited Notify(Ptr,Action);
  end else
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

function TBisSipPhoneLines.ActiveCount: Integer;
var
  i: Integer;
  Item: TBisSipPhoneLine;
begin
  Result:=0;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.Active then
      Inc(Result);
  end;
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

function TBisSipPhoneAcmDrivers.FormatToPayloadType(DriverFormat: TWaveAcmDriverFormat): TBisRtpPacketPayloadType;
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
                                           Channels: Word; SamplesPerSec: Longword; BitsPerSample: Word): TWaveAcmDriverFormat;
begin
  Result:=inherited FindFormat(DriverName,FormatName,Channels,SamplesPerSec,BitsPerSample);
end;

function TBisSipPhoneAcmDrivers.FindFormat(PayloadType: TBisRtpPacketPayloadType;
                                           Channels: Word; SamplesPerSec: Longword; BitsPerSample: Word): TWaveAcmDriverFormat;
var
  FormatTag: LongWord;
begin
  Result:=nil;
  FormatTag:=PayloadTypeToFormatTag(PayloadType);
  if FormatTag>0 then
    Result:=inherited FindFormat('',FormatTag,Channels,SamplesPerSec,BitsPerSample);
end;

{ TBisSipPhoneSweepThread }

constructor TBisSipPhoneSweepThread.Create(Phone: TBisSipPhone);
begin
  inherited Create;
  FreeOnTerminate:=true;
  FPhone:=Phone;
  FEvent:=TEvent.Create(nil,false,false,'');
end;

destructor TBisSipPhoneSweepThread.Destroy;
begin
  FEvent.SetEvent;
  FEvent.Free;
  FPhone:=nil;
  inherited Destroy;
end;

procedure TBisSipPhoneSweepThread.Terminate;
begin
  FEvent.SetEvent;
  inherited Terminate;
end;

procedure TBisSipPhoneSweepThread.Execute;
var
  Ret: TWaitResult;
begin
  inherited Execute;
  if Assigned(FPhone) then begin
    while not Terminated do begin
      FEvent.ResetEvent;
      Ret:=FEvent.WaitFor(FPhone.FLineSweepInterval);
      if not Terminated then begin
        if (Ret=wrTimeout) and Assigned(FPhone) then begin
          Synchronize(FPhone.SweepLines);
        end else
          Terminate;
      end;
    end;
  end;
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
  FMaxLines:=3;
  FKeepAlive:=30;
  FRequestRetryCount:=5;
  FRequestTimeOut:=3000;
  FCollectInPackets:=true;
  FCollectOutPackets:=true;

  FLineHoldMode:=lhmEmulate;
  FLineIdleTimeOut:=60000;
  FLineLocalPort:=20000;
  FLineDriverName:='';
  FLineFormatName:='CCITT A-Law';
  FLineChannels:=1;
  FLineSamplesPerSec:=8000;
  FLineBitsPerSample:=8;
  FLineConfirmCount:=3;
  FLineSweepInterval:=3000;
  FLineIdleTimeOut:=10000;

  FTransport:=TBisSipPhoneTransport.Create(Self);

  FLines:=TBisSipPhoneLines.Create(Self);

  FRegistrar:=TBisSipPhoneRegistrar.Create(Self);
  FRegistrar.Transport:=FTransport;

  FDrivers:=TBisSipPhoneAcmDrivers.Create;

  FConnected:=false;
end;

destructor TBisSipPhone.Destroy;
begin
  StopSweepThread;
  FDrivers.Free;
  FRegistrar.Free;
  FLines.Free;
  FTransport.Free;
  inherited Destroy;
end;

function TBisSipPhone.GetBusy: Boolean;
begin
  Result:=FLines.ActiveCount>=FMaxLines;
end;

procedure TBisSipPhone.StopSweepThread;
begin
  if Assigned(FSweepThread) then begin
    FSweepThread.Terminate;
    FSweepThread:=nil;
  end;
end;

procedure TBisSipPhone.SweepThreadTerminate(Sender: TObject);
begin
  //
end;

procedure TBisSipPhone.StartSweepThread;
begin
  StopSweepThread;
  if not Assigned(FSweepThread) and (FLineSweepInterval>0) then begin
    FSweepThread:=TBisSipPhoneSweepThread.Create(Self);
    FSweepThread.OnTerminate:=SweepThreadTerminate;
    FSweepThread.Resume;
  end;
end;

procedure TBisSipPhone.SweepLines;
var
  i: Integer;
  Line: TBisSipPhoneLine;
  NeedFree: Boolean;
begin
  if Assigned(FSweepThread) and not FSweepThread.Terminated then begin
    for i:=Lines.Count-1 downto 0 do begin
      Line:=Lines.Items[i];
      if not FSweepThread.Terminated then begin
        if Line.Active then begin
          NeedFree:=false;
          if Line.FSession.State in [ssProcessing] then
            NeedFree:=Line.FSweepTimeout>FLineIdleTimeOut;
          if NeedFree and Assigned(FRegistrar) then
             FRegistrar.DoSessionDestroy(Line.FSession);
        end;
        Inc(Line.FSweepTimeout,FLineSweepInterval);
      end else
        break;
    end;
  end;
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
    FRegistrar.WaitTimeOut:=FRequestTimeOut;
//    FRegistrar.SessionIdleTimeOut:=FLineIdleTimeOut;

    StartSweepThread;

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

    StopSweepThread;
  end;
end;

procedure TBisSipPhone.DoError(const Message: String);
begin
  if Assigned(FOnError) then
    FOnError(Self,Message);
end;

function TBisSipPhone.AddLine(Direction: TBisSipPhoneLineDirection): TBisSipPhoneLine;
var
  ADirection: TBisSipSessionDirection;
  Session: TBisSipSession;
begin
  ADirection:=sdUnknown;
  case Direction of
    ldIncoming: ADirection:=sdIncoming;
    ldOutgoing: ADirection:=sdOutgoing;
  end;
  Session:=FRegistrar.Sessions.Add(ADirection);
  Result:=FLines.Find(Session);
end;

procedure TBisSipPhone.Dial(Number: String);
var
  Line: TBisSipPhoneLine;
begin
  if FConnected then begin
    Line:=AddLine(ldOutgoing);
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