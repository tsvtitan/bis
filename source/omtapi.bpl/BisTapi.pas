unit BisTapi;

interface

uses Windows, Classes, MMSystem,
     TAPIAddress, TAPICall, TAPILines, TAPIServices, TAPIDevices, TAPIPhone,
     TAPIWave, TAPISystem,
     BisCoreObjects, BisObjectModules;

type
  TBisTapiMessageEvent=procedure (Sender: TObject; Message: String) of object;

  TBisTapi=class(TBisCoreObject)
  private
    FLineService: TTAPILineService;
    FLineDevice: TTAPILineDevice;
    FLine: TTAPILine;
    FCallParams: TCallParams;
    FOutboundCall: TTAPICall;
    FAddress: TTAPIAddress;
    FPhoneService: TTAPIPhoneService;
    FPhoneDevice: TTAPIPhoneDevice;
    FPhone: TTAPIPhone;
    FWaveDevice: TTAPIWaveDevice;
    FInCall: Boolean;

    FOnMessage: TBisTapiMessageEvent;
    FPhoneNumber: String;
    FPhonePrefix: String;
    FOnConnect: TNotifyEvent;
    FOnDisconnect: TNotifyEvent;

    FSAccepted: String;
    FSBusy: String;
    FSConnecting: String;
    FSDisconnecting: String;
    FSDialing: String;
    FSProceeding: String;
    FSIdle: String;
    FSOffering: String;
    FSHold: String;
    FSRingBack: String;
    FSTempFailure: String;
    FSForwarded: String;
    FSQOSUnavail: String;
    FSNoAnswer: String;
    FSCancelled: String;
    FSNumberChanged: String;
    FSBlocked: String;
    FSIncompatible: String;
    FSDoNotDisturb: String;
    FSNoDialtone: String;
    FSUnavail: String;
    FSBadAddress: String;
    FSReject: String;
    FSPickup: String;
    FSOutOfOrder: String;
    FSUnreachable: String;
    FSCongestion: String;
    FOnAfterRecord: TNotifyEvent;
    FSRecordEnd: String;
    FSRecordBegin: String;
    FSInvalidLine: String;
    FRecordFromLine: Boolean;
    FSReply: String;

    function GetDeviceName: String;
    procedure SetDeviceName(const Value: String);
    function GetDeviceId: Cardinal;
    procedure SetDeviceId(const Value: Cardinal);
    function GetPhoneDeviceId: Cardinal;
    procedure OutboundCallStateConnected(Sender: TObject; ConnectedMode: TLineConnectedModes; Rights: TLineCallPrivileges);
    procedure OutboundCallStateDisconnected(Sender: TObject; DisconnectedMode: TLineDisconnectMode; Rights: TLineCallPrivileges);
    procedure OutboundCallStateAccepted(Sender: TObject; Rights: TLineCallPrivileges);
    procedure OutboundCallStateBusy(Sender: TObject; BusyMode: TLineBusyMode; Rights: TLineCallPrivileges);
    procedure OutboundCallStateDialing(Sender: TObject; Rights: TLineCallPrivileges);
    procedure OutboundCallStateProceeding(Sender: TObject; Rights: TLineCallPrivileges);
    procedure OutboundCallnStateIdle(Sender: TObject; Rights: TLineCallPrivileges);
    procedure OutboundCallStateOffering(Sender: TObject; OfferingMode: TLineOfferingModes; Rights: TLineCallPrivileges);
    procedure OutboundCallStateRingBack(Sender: TObject; Rights: TLineCallPrivileges);
    procedure OutboundCallStateOnHold(Sender: TObject; Rights: TLineCallPrivileges);
    procedure OutboundCallStateUnknown(Sender: TObject; Rights: TLineCallPrivileges);
    procedure OutboundCallStateDialTone(Sender: TObject; DialTonMode: TLineDialToneMode; Rights: TLineCallPrivileges);
    procedure OutboundCallReply(Sender: TObject; AsyncFunc: TAsyncFunc; Error: Dword);
    function GetTimeRecord: Integer;
    procedure SetTimeRecord(const Value: Integer);
    function GetRecordFile: String;
    procedure SetRecordFile(const Value: String);
    procedure SetOnAfterRecord(const Value: TNotifyEvent);
    procedure WaveDeviceAfterRecord(Sender: TObject);
    procedure SetPhoneModes;
    procedure LineAfterOpen(Sender: TObject);
    function GetActive: Boolean;
  protected
    procedure DoMessage(Message: String);
    procedure DoConnect;
    procedure DoDisconnect;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginCall;
    procedure EndCall;
    procedure GetDevices(Strings: TStrings);
    function DeviceExists: Boolean;

    property Active: Boolean read GetActive; 
    property DeviceName: String read GetDeviceName write SetDeviceName;
    property DeviceId: Cardinal read GetDeviceId write SetDeviceId;
    property PhoneNumber: String read FPhoneNumber write FPhoneNumber;
    property PhonePrefix: String read FPhonePrefix write FPhonePrefix;
    property RecordFromLine: Boolean read FRecordFromLine write FRecordFromLine;
    property TimeRecord: Integer read GetTimeRecord write SetTimeRecord;
    property RecordFile: String read GetRecordFile write SetRecordFile;

    property OnMessage: TBisTapiMessageEvent read FOnMessage write FOnMessage;
    property OnConnect: TNotifyEvent read FOnConnect write FOnConnect;
    property OnDisconnect: TNotifyEvent read FOnDisconnect write FOnDisconnect;
    property OnAfterRecord: TNotifyEvent read FOnAfterRecord write SetOnAfterRecord;

  published

    property SConnecting: String read FSConnecting write FSConnecting;
    property SDisconnecting: String read FSDisconnecting write FSDisconnecting;
    property SAccepted: String read FSAccepted write FSAccepted;
    property SBusy: String read FSBusy write FSBusy;
    property SDialing: String read FSDialing write FSDialing;
    property SProceeding: String read FSProceeding write FSProceeding;
    property SIdle: String read FSIdle write FSIdle;
    property SOffering: String read FSOffering write FSOffering;
    property SRingBack: String read FSRingBack write FSRingBack;
    property SHold: String read FSHold write FSHold;
    property SReject: String read FSReject write FSReject;
    property SPickup: String read FSPickup write FSPickup;
    property SForwarded: String read FSForwarded write FSForwarded;
    property SNoAnswer: String read FSNoAnswer write FSNoAnswer;
    property SBadAddress: String read FSBadAddress write FSBadAddress;
    property SUnreachable: String read FSUnreachable write FSUnreachable;
    property SCongestion: String read FSCongestion write FSCongestion;
    property SIncompatible: String read FSIncompatible write FSIncompatible;
    property SUnavail: String read FSUnavail write FSUnavail;
    property SNoDialtone: String read FSNoDialtone write FSNoDialtone;
    property SNumberChanged: String read FSNumberChanged write FSNumberChanged;
    property SOutOfOrder: String read FSOutOfOrder write FSOutOfOrder;
    property STempFailure: String read FSTempFailure write FSTempFailure;
    property SQOSUnavail: String read FSQOSUnavail write FSQOSUnavail;
    property SBlocked: String read FSBlocked write FSBlocked;
    property SDoNotDisturb: String read FSDoNotDisturb write FSDoNotDisturb;
    property SCancelled: String read FSCancelled write FSCancelled;
    property SRecordBegin: String read FSRecordBegin write FSRecordBegin;
    property SRecordEnd: String read FSRecordEnd write FSRecordEnd;
    property SInvalidLine: String read FSInvalidLine write FSInvalidLine;
    property SReply: String read FSReply write FSReply;

  end;

procedure InitObjectModule(AModule: TBisObjectModule); stdcall;

exports
  InitObjectModule;

implementation

uses SysUtils;

procedure InitObjectModule(AModule: TBisObjectModule); stdcall;
begin
  //
end;

{ TBisTapi }

constructor TBisTapi.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FLineService:=TTAPILineService.Create(nil);
  FLineService.Active:=true;

  FLineDevice:=TTAPILineDevice.Create(nil);
  FLineDevice.Service:=FLineService;

  FLine:=TTAPILine.Create(Self); // need self why ??? but use in notify callback messages
  FLine.Device:=FLineDevice;
  FLine.CallPrivileges:=[cpOwner];
  FLine.AfterOpen:=LineAfterOpen;

  FCallParams:=TCallParams.Create(nil);
  FCallParams.CallParamFlags:=[cpfIdle];
  FCallParams.DeviceClass:=FLineDevice.DeviceClass;

  FOutboundCall:=TTAPICall.Create(Self);  // need self why ??? but use in notify callback messages
  FOutboundCall.MakeCallParams:=FCallParams;
  FOutboundCall.OnStateConnected:=OutboundCallStateConnected;
  FOutboundCall.OnStateDisconnected:=OutboundCallStateDisconnected;
  FOutboundCall.OnStateAccepted:=OutboundCallStateAccepted;
  FOutboundCall.OnStateBusy:=OutboundCallStateBusy;
  FOutboundCall.OnStateDialing:=OutboundCallStateDialing;
  FOutboundCall.OnStateProceeding:=OutboundCallStateProceeding;
  FOutboundCall.OnStateIdle:=OutboundCallnStateIdle;
  FOutboundCall.OnStateOffering:=OutboundCallStateOffering;
  FOutboundCall.OnStateRingBack:=OutboundCallStateRingBack;
  FOutboundCall.OnStateOnHold:=OutboundCallStateOnHold;
  FOutboundCall.OnStateUnknown:=OutboundCallStateUnknown;
  FOutboundCall.OnStateDialTone:=OutboundCallStateDialTone;
  FOutboundCall.OnReply:=OutboundCallReply;

  FWaveDevice:=TTAPIWaveDevice.Create(Self);
  FWaveDevice.AutoSave:=false;
  FWaveDevice.NumBuffers:=MaxInt;
  FWaveDevice.Call:=FOutboundCall;
  FWaveDevice.AfterRecord:=WaveDeviceAfterRecord;

  FAddress:=TTAPIAddress.Create(Self); // need self why ??? but use in notify callback messages
  FAddress.Line:=FLine;
  FAddress.OutboundCall:=FOutboundCall;

  FPhoneService:=TTAPIPhoneService.Create(nil);
  FPhoneService.InitOptions:=ieoUseEvent;
  FPhoneService.Active:=true;

  FPhoneDevice:=TTAPIPhoneDevice.Create(nil);
  FPhoneDevice.Service:=FPhoneService;

  FPhone:=TTAPIPhone.Create(Self);
  FPhone.Device:=FPhoneDevice;


  FSConnecting:='���������� ...';
  FSDisconnecting:='���������� ...';
  FSAccepted:='������ ������';
  FSBusy:='����� ������';
  FSDialing:='����� ������ ...';
  FSProceeding:='Proceeding';
  FSIdle:='�������� ...';
  FSOffering:='Offering';
  FSRingBack:='RingBack';
  FSHold:='��������� ...';
  FSReject:='�����';
  FSPickup:='Pickup';
  FSForwarded:='�������������';
  FSNoAnswer:='��� ������';
  FSBadAddress:='������������ �����';
  FSUnreachable:='����������';
  FSCongestion:='���������� �����';
  FSIncompatible:='������������� �����';
  FSUnavail:='�����������';
  FSNoDialtone:='NoDialtone';
  FSNumberChanged:='NumberChanged';
  FSOutOfOrder:='OutOfOrder';
  FSTempFailure:='TempFailure';
  FSQOSUnavail:='QOSUnavail';
  FSBlocked:='����� ������������';
  FSDoNotDisturb:='DoNotDisturb';
  FSCancelled:='��������';
  FSRecordBegin:='������ ������ ...';
  FSRecordEnd:='������ ��������� ...';
  FSInvalidLine:='�������� �����';
  FSReply:='�����';

end;

destructor TBisTapi.Destroy;
begin
  FPhone.Active:=false;
  FPhoneService.Active:=false;
  FLine.Active:=false;
  FLineService.Active:=false;

  FPhoneService.Free;
  FPhoneDevice.Free;
  FPhone.Free;
  FAddress.Free;
  FWaveDevice.Free;
  FOutboundCall.Free;
  FCallParams.Free;
  FLine.Free;
  FLineDevice.Free;
  FLineService.Free;
  inherited Destroy;
end;

procedure TBisTapi.SetPhoneModes;
begin
  try
    if pfSetHookSwitchSpeaker in FPhone.Device.Caps.PhoneFeatures then
      FPhone.SpeakerHookSwitchMode:=phsmMicSpeaker;

    if FPhone.Device.Caps.SpeakerHookSwitchVolumeFlag then
      FPhone.SpeakerVolume:=$FFFF;

    if pfSetHookSwitchHandset in FPhone.Device.Caps.PhoneFeatures then
      FPhone.HandSetHookSwitchMode:=phsmMicSpeaker;

    if FPhone.Device.Caps.HandsetHookSwitchVolumeFlag then
      FPhone.HandSetVolume:=$FFFF;

    if pfSetHookSwitchHeadSet in FPhone.Device.Caps.PhoneFeatures then
      FPhone.HeadSetHookSwitchMode:=phsmMicSpeaker;

    if FPhone.Device.Caps.HeadsetHookSwitchVolumeFlag then
      FPhone.HeadSetVolume:=$FFFF;

  except
  end;
end;

procedure TBisTapi.LineAfterOpen(Sender: TObject);
begin
  FPhone.Active:=false;
  FPhoneDevice.ID:=GetPhoneDeviceId;
  FPhone.Active:=true;
end;

procedure TBisTapi.DoConnect;
begin
  if Assigned(FOnConnect) then
    FOnConnect(Self);

  SetPhoneModes;

  if RecordFromLine then begin
    FWaveDevice.RecordMessage;
  end;

  PlaySound(nil,HInstance,SND_PURGE);

  SetPhoneModes;
end;

procedure TBisTapi.DoDisconnect;
begin
  PlaySound(nil,hInstance,SND_PURGE);

  if RecordFromLine then begin
    FWaveDevice.StopRec;
  end;

  FOutboundCall.DeallocateCall;

  FPhone.Active:=False;
  FLine.Active:=False;
  FPhoneService.Active:=False;
  FLineService.Active:=False;

  if Assigned(FOnDisconnect) then
    FOnDisconnect(Self);
end;

procedure TBisTapi.DoMessage(Message: String);
begin
  if Assigned(FOnMessage) then
    FOnMessage(Self,Message);
end;

procedure TBisTapi.OutboundCallStateConnected(Sender: TObject; ConnectedMode: TLineConnectedModes; Rights: TLineCallPrivileges);
begin
  DoConnect;
  DoMessage(FSConnecting);
end;

procedure TBisTapi.OutboundCallStateDisconnected(Sender: TObject; DisconnectedMode: TLineDisconnectMode; Rights: TLineCallPrivileges);
begin
  case DisconnectedMode of
    dmNormal: ;
    dmUnknown: ;
    dmReject: DoMessage(FSReject);
    dmPickup: DoMessage(FSPickup);
    dmForwarded: DoMessage(FSForwarded);
    dmBusy: DoMessage(FSDisconnecting);
    dmNoAnswer: DoMessage(FSNoAnswer);
    dmBadAddress: DoMessage(FSBadAddress);
    dmUnreachable: DoMessage(FSUnreachable);
    dmCongestion: DoMessage(FSCongestion);
    dmIncompatible: DoMessage(FSIncompatible);
    dmUnavail: DoMessage(FSUnavail);
    dmNoDialtone: DoMessage(FSNoDialtone);
    dmNumberChanged: DoMessage(FSNumberChanged);
    dmOutOfOrder: DoMessage(FSOutOfOrder);
    dmTempFailure: DoMessage(FSTempFailure);
    dmQOSUnavail: DoMessage(FSQOSUnavail);
    dmBlocked: DoMessage(FSBlocked);
    dmDoNotDisturb: DoMessage(FSDoNotDisturb);
    dmCancelled: DoMessage(FSCancelled);
  end;
  DoDisconnect;
end;

procedure TBisTapi.OutboundCallStateAccepted(Sender: TObject;  Rights: TLineCallPrivileges);
begin
  DoMessage(FSAccepted);
end;

procedure TBisTapi.OutboundCallStateDialing(Sender: TObject; Rights: TLineCallPrivileges);
begin
  PlaySound(nil,hInstance,SND_PURGE);
  DoMessage(FSDialing);
end;

procedure TBisTapi.OutboundCallStateBusy(Sender: TObject; BusyMode: TLineBusyMode; Rights: TLineCallPrivileges);
begin
  PlaySound(nil,hInstance,SND_PURGE);
  if lcfCompleteCall in FOutBoundCall.Status.Features then  begin
    FOutBoundCall.CompletionMode:=lccmCampon;
    FOutBoundCall.CompleteCall;
  end;
  DoMessage(FSBusy);
end;

procedure TBisTapi.OutboundCallStateProceeding(Sender: TObject; Rights: TLineCallPrivileges);
begin
 // DoMessage(FSProceeding);
end;

procedure TBisTapi.OutboundCallnStateIdle(Sender: TObject; Rights: TLineCallPrivileges);
begin
  DoDisconnect;
  DoMessage(FSIdle);
end;

procedure TBisTapi.OutboundCallStateOffering(Sender: TObject; OfferingMode: TLineOfferingModes; Rights: TLineCallPrivileges);
begin
  DoMessage(FSOffering);
end;

procedure TBisTapi.OutboundCallStateRingBack(Sender: TObject; Rights: TLineCallPrivileges);
begin
  DoMessage(FSRingBack);
end;

procedure TBisTapi.OutboundCallStateOnHold(Sender: TObject;  Rights: TLineCallPrivileges);
begin
  DoMessage(FSHold);
end;

procedure TBisTapi.OutboundCallStateUnknown(Sender: TObject;  Rights: TLineCallPrivileges);
begin
  FOutBoundCall.SetMediaMode([mmInteractiveVoice]);
end;

procedure TBisTapi.OutboundCallStateDialTone(Sender: TObject;  DialTonMode: TLineDialToneMode; Rights: TLineCallPrivileges);
begin
  DoMessage('DialTone');
end;

procedure TBisTapi.OutboundCallReply(Sender: TObject; AsyncFunc: TAsyncFunc; Error: Dword);
begin
 // DoMessage(FSReply);
end;

procedure TBisTapi.GetDevices(Strings: TStrings);
var
  i: Integer;
  TempLineDevice: TTAPILineDevice;
  Caps: TLineDeviceCaps;
begin
  if Assigned(Strings) then begin
    try
      try
        FLineService.Active:=true;
      except
      end;
      TempLineDevice:=TTAPILineDevice.Create(nil);
      TempLineDevice.Service:=FLineService;
      try
        for i:=0 to FLineService.NumDevice-1 do begin
          TempLineDevice.ID:=i;
          try
            Caps:=TempLineDevice.Caps;
            if Assigned(Caps) then begin
              if mmInteractiveVoice in Caps.MediaModes then
                Strings.AddObject(Caps.Name,TObject(i));
            end;
          except
          end;
        end;
      finally
        TempLineDevice.Free;
      end;
    finally
    end;
  end;
end;

function TBisTapi.GetPhoneDeviceId: Cardinal;
begin
  Result:=0;
  try
    Result:=FLine.PhoneID;
  except
  end;
end;

function TBisTapi.GetActive: Boolean;
begin
  Result:=FLine.Active and FPhone.Active; 
end;

function TBisTapi.GetDeviceId: Cardinal;
begin
  Result:=FLineDevice.ID;
end;

procedure TBisTapi.SetDeviceId(const Value: Cardinal);
begin
  FLineDevice.ID:=Value;
end;

function TBisTapi.DeviceExists: Boolean;
var
  i: Integer;
  Devices: TStringList;
  S: String;
begin
  Result:=false;
  Devices:=TStringList.Create;
  try
    GetDevices(Devices);
    S:=DeviceName;
    for i:=0 to Devices.Count-1 do begin
      if AnsiSametext(Devices[i],DeviceName) then begin
        Result:=True;
        break;
      end;
    end;
  finally
    Devices.Free;
  end;
end;

function TBisTapi.GetDeviceName: String;
begin
  Result:=FLineDevice.Caps.Name;
end;

procedure TBisTapi.SetDeviceName(const Value: String);
var
  i: Integer;
  Devices: TStringList;
begin
  Devices:=TStringList.Create;
  try
    GetDevices(Devices);
    for i:=0 to Devices.Count-1 do begin
      if AnsiSametext(Devices[i],Value) then begin
        try
          FPhone.Active:=False;
          FLine.Active:=False;
          FPhoneService.Active:=False;
          FLineService.Active:=False;
          FLineDevice.ID:=Integer(Devices.Objects[i]);
          FLineService.Active:=True;
          FPhoneService.Active:=True;
          FLine.Active:=True;
          FPhone.Active:=False;
          FLine.Active:=False;
        except
        end;
        break;
      end;
    end;
  finally
    Devices.Free;
  end;
end;

procedure TBisTapi.SetOnAfterRecord(const Value: TNotifyEvent);
begin
  FOnAfterRecord := Value;
end;

function TBisTapi.GetRecordFile: String;
begin
  Result:=FWaveDevice.RecordFile;
end;

procedure TBisTapi.SetRecordFile(const Value: String);
begin
  FWaveDevice.RecordFile:=Value;
end;

function TBisTapi.GetTimeRecord: Integer;
begin
  Result:=FWaveDevice.NumBuffers;
end;

procedure TBisTapi.SetTimeRecord(const Value: Integer);
begin
  FWaveDevice.NumBuffers:=Value;
end;

procedure TBisTapi.WaveDeviceAfterRecord(Sender: TObject);
begin
  if Assigned(FOnAfterRecord) then
    FOnAfterRecord(Sender);
end;

procedure TBisTapi.BeginCall;
begin
  try
    FInCall:=true;
    FLineService.Active:=True;
    FPhoneService.Active:=True;
    FLine.Active:=True;
    FAddress.Address:=FPhonePrefix+FPhoneNumber;
    FAddress.MakeCall;
  except
    on E: Exception do begin
      DoDisconnect;
      DoMessage(FSInvalidLine);
    end;
  end;
end;

procedure TBisTapi.EndCall;
begin
  if FInCall then begin
    FOutboundCall.Drop;
    DoDisconnect;
    DoMessage(FSDisconnecting);
    FInCall:=false;
  end;
end;



end.
