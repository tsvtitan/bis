unit sipclient;

{$include sipcompilers.inc}

interface

{$IFDEF DELPHI_6_UP}
uses SysUtils, Classes, sip, sipints, Messages, mmSystem, Windows, SyncObjs, WavFiles, conference, recorder;
{$ELSE}
uses SysUtils, Classes, sip, sipints, Messages, mmSystem, Windows, SyncObjs, WavFiles, Forms, conference, recorder;
{$ENDIF}

type
  TOnLog = procedure(Sender: TObject; const Text: String) of object;
  TOnInvite = procedure(Sender: TObject; const ACall: ISipCall) of object;
  TOnInviteOk = procedure(Sender: TObject; const ACall: ISipCall) of object;
  TOnDtmf = procedure(Sender: TObject; const ACall: ISipCall; const Dtmf: String) of object;
  TOnWavStopped = procedure(Sender: TObject; const ACall: ISipCall) of object;
  TOnBye = procedure(Sender: TObject; const ACall: ISipCall) of object;
  TOnRingback = procedure(Sender: TObject; const ACall: ISipCall) of object;
  TOnRegistrationOk = procedure(Sender: TObject; const AAccount: ISipAccount) of object;
  TOnRegistrationBye = procedure(Sender: TObject; const AAccount: ISipAccount) of object;

type
  TDtmfMethod = (dtmfInBand, dtmfRFC2833, dtmfSipInfo);

type
  TSipClient = class(TComponent)
  private
    FSipEngine: ISipEngine;
    FOnLog: TOnLog;
    FOnInvite: TOnInvite;
    FOnInviteOk: TOnInviteOk;
    FOnDtmf: TOnDtmf;
    FOnWavStopped: TOnWavStopped;
    FOnBye: TOnBye;
    FOnRingback: TOnRingback;
    FOnRegistrationOk: TOnRegistrationOk;
    FOnRegistrationBye: TOnRegistrationBye;
    FLocalPort: Integer;
    FActive: Boolean;
    FWindowHandle: THandle;
    FRtpPortMin: Integer;
    FRtpPortMax: Integer;
    FSilenceThreshold: Integer;
    FSilenceTimeout: Integer;
    FDtmfMethod: TDtmfMethod;
    FCS: TCriticalSection;
    procedure WndProc(var Message: TMessage);
    procedure SetActive(const Value: Boolean);
    function GetSilenceThreshold: Integer;
    function LoadWavFromResource(const N: Integer): IWavFile;
  protected
    procedure SetRtpPortMin(const Value: Integer);
    procedure SetRtpPortMax(const Value: Integer);
    function GetSilenceThresold: Integer;
    procedure SetSilenceThreshold(const Value: Integer);
    function GetSilenceTimeout: Integer;
    procedure SetSilenceTimeout(const Value: Integer);
    procedure OnSipLogHandler(var Msg: TMessage);
    procedure OnSipInviteHandler(var Msg: TMessage);
    procedure OnSipInviteOkHandler(var Msg: TMessage);
    procedure OnDtmfHandler(var Msg: TMessage);
    procedure OnWavStoppedHandler(var Msg: TMessage);
    procedure OnSipByeHandler(var Msg: TMessage);
    procedure OnRegOkHandler(var Msg: TMessage);
    procedure OnRegByeHandler(var Msg: TMessage);
    procedure OnRingbackHandler(var Msg: TMessage);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CreateConference: ISipConference;
    function CreateRecorder: ISipRecorder;
    function  AddAccount(const Server, User, Password: String; const Proxy: String = ''; const STUN: String = ''): ISipAccount;
    function  AddCall(Account: ISipAccount; PhoneNumber: String; InDevice: Cardinal = WAVE_MAPPER; OutDevice: Cardinal = WAVE_MAPPER): ISipCall;
    procedure HoldCall(const Call: ISipCall);
    procedure TransferCall(const Call: ISipCall; const PhoneNumber: String);
    procedure UnHoldCall(const Call: ISipCall);
    procedure AnswerCall(const Call: ISipCall);
    procedure EndCall(const Call: ISipCall);
    procedure SendBusy(const Call: ISipCall);
    procedure SendDtmf(const Call: ISipCall; const Digit: String);
    procedure PlayWavFile(const Call: ISipCall; const FileName: String); overload;
    procedure PlayWavFile(const Call: ISipCall; const WavFile: IWavFile); overload;
    procedure PlayText(const Call: ISipCall; const Text: String; const VoiceIndex: Integer = 0);
    procedure StopWavFile(const Call: ISipCall);
    procedure RegisterAccount(const Account: ISipAccount);
    procedure SeldTextMessage(const Account: ISipAccount; const PhoneNumber, Text: String);
    procedure UnRegisterAccount(const Account: ISipAccount);
    property Active: Boolean read FActive write SetActive;
  published
    property LocalPort: Integer read FLocalPort write FLocalPort;
    property RtpPortMin: Integer read FRtpPortMin write SetRtpPortMin;
    property RtpPortMax: Integer read FRtpPortMax write SetRtpPortMax;
    property DtmfMethod: TDtmfMethod read FDtmfMethod write FDtmfMethod;
    property OnLog: TOnLog read FOnLog write FOnLog;
    property OnInvite: TOnInvite read FOnInvite write FOnInvite;
    property OnInviteOk: TOnInviteOk read FOnInviteOk write FOnInviteOk;
    property OnDtmf: TOnDtmf read FOnDtmf write FOnDtmf;
    property OnWavStopped: TOnWavStopped read FOnWavStopped write FOnWavStopped;
    property OnBye: TOnBye read FOnBye write FOnBye;
    property OnRingback: TOnRingback read FOnRingback write FOnRingback;
    property OnRegistrationOk: TOnRegistrationOk read FOnRegistrationOk write FOnRegistrationOk;
    property OnRegistrationBye: TOnRegistrationBye read FOnRegistrationBye write FOnRegistrationBye;
    property SilenceThreshold: Integer read GetSilenceThreshold write SetSilenceThreshold;
    property SilenceTimeout: Integer read GetSilenceTimeout write SetSilenceTimeout;
  end;

procedure Register;

implementation

{$R wav.res}
{$R sipclient.dcr}

procedure Register;
begin
  RegisterComponents('VoIP', [TSipClient]);
end;

{ TSipClient }

function TSipClient.AddCall(Account: ISipAccount; PhoneNumber: String; InDevice: Cardinal = WAVE_MAPPER; OutDevice: Cardinal = WAVE_MAPPER): ISipCall;
begin
  Result := FSipEngine.MakeCall(Account, PhoneNumber, InDevice, OutDevice);
end;

function TSipClient.AddAccount(const Server, User, Password: String; const Proxy: String = ''; const STUN: String = ''): ISipAccount;
begin
  Result := FSipEngine.AddAccount(STUN, Server, User, Password, Proxy);
end;

procedure TSipClient.AnswerCall(const Call: ISipCall);
begin
  FSipEngine.Answer(Call);
  if Assigned(FOnInviteOk) then
    FOnInviteOk(Self, Call);
end;

constructor TSipClient.Create(AOwner: TComponent);
begin
  inherited;
  {$IFDEF DELPHI_6_UP}
  FWindowHandle := Classes.AllocateHWnd(WndProc);
  {$ELSE}
  FWindowHandle := AllocateHWnd(WndProc);
  {$ENDIF}
  FSilenceThreshold := 500;
  FSilenceTimeout := 5000;
  FActive := False;
  FLocalPort := 5075;
  FRtpPortMin := BASE_RTP_PORT;
  FRtpPortMax := FRtpPortMin + 2000;
  FCS := TCriticalSection.Create;
  FDtmfMethod := dtmfInBand;
end;

destructor TSipClient.Destroy;
begin
  if Assigned(FSipEngine) then
  begin
    if FSipEngine.Active then
      FSipEngine.Active := False;
    FSipEngine := nil;
  end;
  FCS.Free;
  {$IFDEF DELPHI_6_UP}
  Classes.DeallocateHWnd(FWindowHandle);
  {$ELSE}
  DeallocateHWnd(FWindowHandle);
  {$ENDIF}
  inherited;
end;

procedure TSipClient.EndCall(const Call: ISipCall);
begin
  FSipEngine.HangUp(Call);
end;

procedure TSipClient.HoldCall(const Call: ISipCall);
begin
  FSipEngine.Hold(Call);
end;

procedure TSipClient.OnDtmfHandler(var Msg: TMessage);
var
  C: ISipCall;
  s: String;
begin
  C := IInterface(Msg.lParam) as ISipCall;
  try
    s := Char(Msg.WParam);
    if Assigned(FOnDtmf) then
      FOnDtmf(Self, C, s);
  finally
    C._Release;
  end;
end;

procedure TSipClient.OnWavStoppedHandler(var Msg: TMessage);
var
  C: ISipCall;
  s: String;
begin
  C := IInterface(Msg.lParam) as ISipCall;
  try
    s := Char(Msg.WParam);
    if Assigned(FOnWavStopped) then
      FOnWavStopped(Self, C);
  finally
    C._Release;
  end;
end;

procedure TSipClient.OnRegByeHandler(var Msg: TMessage);
var
  R: ISipAccount;
begin
  R := IInterface(Msg.lParam) as ISipAccount;
  try
    if Assigned(FOnRegistrationBye) then
      FOnRegistrationBye(Self, R);
  finally
//    R._Release;
  end;
end;

procedure TSipClient.OnRegOkHandler(var Msg: TMessage);
var
  R: ISipAccount;
begin
  R := IInterface(Msg.lParam) as ISipAccount;
  try
    if Assigned(FOnRegistrationOk) then
      FOnRegistrationOk(Self, R);
  finally
    R._Release;
  end;
end;

procedure TSipClient.OnSipByeHandler(var Msg: TMessage);
var
  C: ISipCall;
begin
  C := IInterface(Msg.lParam) as ISipCall;
  try
    C.Lock;
    try
      if Assigned(FOnBye) then
        FOnBye(Self, C);
    finally
      C.Unlock;
    end;
  finally
    C._Release;
  end;
end;

procedure TSipClient.OnSipInviteHandler(var Msg: TMessage);
var
  C: ISipCall;
  Event: Boolean;
begin
  Event := False;
  C := IInterface(Msg.lParam) as ISipCall;
  try
    C.Lock;
    try
      if C.State = csInactive then
      begin
        C.State := csRinging;
        Event := True;
      end;
    finally
      C.Unlock;
    end;  
  finally
    C._Release;
  end;
  if Assigned(FOnInvite) and Event then
    FOnInvite(Self, C);

end;

procedure TSipClient.OnSipInviteOkHandler(var Msg: TMessage);
var
  C: ISipCall;
begin
  C := IInterface(Msg.lParam) as ISipCall;
  try
    if Assigned(FOnInviteOk) then
      FOnInviteOk(Self, C);
  finally
    C._Release;
  end;
end;

procedure TSipClient.OnSipLogHandler(var Msg: TMessage);
var
  M: ILogMessage;
begin
  M := IInterface(Msg.lParam) as ILogMessage;
  try
    if Assigned(FOnLog) then
      FOnLog(Self, String(M.Text));
  finally
    M._Release;
  end;
end;

procedure TSipClient.PlayWavFile(const Call: ISipCall;
  const FileName: String);
begin
  FSipEngine.PlayWavFile(Call, FileName);
end;

procedure TSipClient.PlayWavFile(const Call: ISipCall; const WavFile: IWavFile);
begin
  WavFile.Position := 0;
  Call.PlayWavFile(WavFile);
end;

procedure TSipClient.RegisterAccount(const Account: ISipAccount);
begin
  Account.RegistrationTime := Now;
  FSipEngine.RegisterAccount(Account);
end;

procedure TSipClient.SendBusy(const Call: ISipCall);
begin
  FSipEngine.SendBusy(Call);
  FSipEngine.RemoveCall(Call);
  if Assigned(FOnBye) then
    FOnBye(Self, Call);
end;

procedure TSipClient.SetActive(const Value: Boolean);
begin
  FActive := Value;
  if FActive then
  begin
    FSipEngine := CreateSipEngine(FLocalPort, FWindowHandle);
    FSipEngine.SetSilenceThreshold(FSilenceThreshold);
    FSipEngine.SetSilenceTimeout(FSilenceTimeout);
    FSipEngine.RtpPortMin := FRtpPortMin;
    FSipEngine.RtpPortMax := FRtpPortMax;
    FSipEngine.Active := True;
  end
  else
  begin
    if Assigned(FSipEngine) then
      FSipEngine.Active := False;
    FSipEngine := nil;
  end;
end;

procedure TSipClient.UnHoldCall(const Call: ISipCall);
begin
  FSipEngine.UnHold(Call);
end;

procedure TSipClient.UnRegisterAccount(const Account: ISipAccount);
begin
  FSipEngine.Disconnect(Account);
end;

procedure TSipClient.WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_SIP_LOG then
    OnSipLoghandler(Message)
  else if Message.Msg = WM_SIP_INVITE then
    OnSipInviteHandler(Message)
  else if Message.Msg = WM_SIP_INVITE_OK then
    OnSipInviteOkHandler(Message)
  else if Message.Msg = WM_DTMF then
    OnDtmfHandler(Message)
  else if Message.Msg = WM_RING_BACK then
    OnRingbackHandler(Message)
  else if Message.Msg = WM_SIP_BYE then
    OnSipByeHandler(Message)
  else if Message.Msg = WM_REG_OK then
    OnRegOkHandler(Message)
  else if Message.Msg = WM_REG_BYE then
    OnRegByeHandler(Message)
  else if Message.Msg = WM_STOP_PLAYING then
    OnWavStoppedHandler(Message)
  else
    DefWindowProc(FWindowHandle, Message.Msg, Message.WParam, Message.LParam);
end;

function TSipClient.GetSilenceThresold: Integer;
begin
  Result := FSilenceThreshold;
end;

procedure TSipClient.SetSilenceThreshold(const Value: Integer);
begin
  FSilenceThreshold := Value;
  if Assigned(FSipEngine) then
    FSipEngine.SilenceThreshold := Value;
end;

function TSipClient.GetSilenceThreshold: Integer;
begin
  Result := FSilenceThreshold;
end;

function TSipClient.GetSilenceTimeout: Integer;
begin
  Result := FSilenceTimeout;
end;

procedure TSipClient.SetSilenceTimeout(const Value: Integer);
begin
  FSilenceTimeout := Value;
  if Assigned(FSipEngine) then
    FSipEngine.SilenceTimeout := Value;
end;

procedure TSipClient.StopWavFile(const Call: ISipCall);
begin
  Call.PlayWavFile(nil);
end;

procedure TSipClient.PlayText(const Call: ISipCall; const Text: String; const VoiceIndex: Integer = 0);
begin
  FSipEngine.PlayText(Call, Text, VoiceIndex);
end;

procedure TSipClient.SetRtpPortMax(const Value: Integer);
begin
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
  if Value < (RtpPortMin+2) then
    raise Exception.Create('RtpPortMAx max must be at least RtpPortMin + 2');
  FRtpPortMax := Value;
end;

procedure TSipClient.SetRtpPortMin(const Value: Integer);
begin
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
  if Value < (RtpPortMin+2) then
    raise Exception.Create('RtpPortMin max must be at least RtpPortMax - 2');
  FRtpPortMin := Value;
end;

procedure TSipClient.TransferCall(const Call: ISipCall;
  const PhoneNumber: String);
begin
  if (Call.CallType = ctIncoming) and (Call.State = csRinging) then
    begin
      FSipEngine.TransferCall(Call, PhoneNumber);
      if Assigned(FOnBye) then
        FOnBye(Self, Call);
    end
  else
    FSipEngine.TransferCall(Call, PhoneNumber);
end;

procedure TSipClient.SeldTextMessage(const Account: ISipAccount;
  const PhoneNumber, Text: String);
begin
  FSipEngine.SendTextMessage(Account, PhoneNumber, Text);
end;

procedure TSipClient.SendDtmf(const Call: ISipCall; const Digit: String);
var
  w: IWavFile;
  c: Char;
begin
  c := #0;
  if Length(Digit) > 0 then
    c := Digit[1];
  case FDtmfMethod of
  dtmfInBand:
  begin
    case c of
    '0': w := LoadWavFromResource(10);
    '1': w := LoadWavFromResource(1);
    '2': w := LoadWavFromResource(2);
    '3': w := LoadWavFromResource(3);
    '4': w := LoadWavFromResource(4);
    '5': w := LoadWavFromResource(5);
    '6': w := LoadWavFromResource(6);
    '7': w := LoadWavFromResource(7);
    '8': w := LoadWavFromResource(8);
    '9': w := LoadWavFromResource(9);
    '*': w := LoadWavFromResource(11);
    '#': w := LoadWavFromResource(12);
    end;
    PlayWavFile(Call, w);
  end;
  dtmfSipInfo: FSipEngine.SendDtmfInfo(Call, Digit);
  dtmfRFC2833: FSipEngine.SetDtmfCode(Call, Digit);
  end;
end;

function TSipClient.LoadWavFromResource(const N: Integer): IWavFile;
var
  rs: TResourceStream;
begin
  FCS.Enter;
  try
    rs := TResourceStream.CreateFromID(hInstance, N, RT_RCDATA);
    try
      Result := TWavStream.CreateFromStream(rs);
    finally
      rs.Free;
    end;
  finally
    FCS.Leave;
  end;
end;

function TSipClient.CreateConference: ISipConference;
begin
  Result := TSipConference.Create;
end;

function TSipClient.CreateRecorder: ISipRecorder;
begin
  Result := TSipRecorder.Create;
end;

procedure TSipClient.OnRingbackHandler(var Msg: TMessage);
var
  C: ISipCall;
begin
  C := IInterface(Msg.lParam) as ISipCall;
  try
    C.Lock;
    try
      if Assigned(FOnRingback) then
        FOnRingback(Self, C);
    finally
      C.Unlock;
    end;
  finally
    C._Release;
  end;
end;

end.
