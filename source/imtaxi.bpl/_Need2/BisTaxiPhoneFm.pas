unit BisTaxiPhoneFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Contnrs, DB, ZLib, ExtCtrls, ImgList, ActnList, StdActns,
  Tabs, ComCtrls, Buttons, Menus, ActnPopup, MMSystem, SyncObjs,
  WaveUtils, WaveMixer, WaveACMDrivers,
  IdUDPServer, IdGlobal, IdSocketHandle, IdException,                                                     
  BisFm, BisEvents, BisCrypter, BisValues, BisThreads,
  BisAudioWave, 
  BisTaxiPhoneFrm, BisControls;

type
  TBisTaxiPhoneChannels=class;

  TBisTaxiPhoneAcceptorType=(atPhone,atAccount,atComputer,atSession);

  TBisTaxiPhoneMessageDirection=(mdIncoming,mdOutgoing);

  TBisTaxiPhoneMessage=class(TBisValues)
  private
    FName: String;
    FDirection: TBisTaxiPhoneMessageDirection;
    function GetSessionId: Variant;
    function GetChannelId: String;
    function GetSequence: Integer;
    function GetCallId: Variant;
    function GetRemoteSessionId: Variant;
    function GetDataPort: Integer;
    function GetFormatTag: Word;
    function GetBitsPerSample: Word;
    function GetChannels: Word;
    function GetSamplesPerSec: LongWord;
    function GetDataSize: Integer;
    function GetCallerId: Variant;
    function GetCallerPhone: Variant;
  public
    constructor Create(Direction: TBisTaxiPhoneMessageDirection; Name: String; Params: TBisEventParams=nil); virtual;
    destructor Destroy; override;
    procedure CopyFrom(Params: TBisEventParams); virtual;
    function AsString: String; virtual;

    procedure AddSessionId(Value: Variant);
    procedure AddRemoteSessionId(Value: Variant);
    procedure AddChannelId(Value: String);
    procedure AddSequence(Value: Integer);
    procedure AddCallId(Value: Variant);
    procedure AddCallerId(Value: Variant);
    procedure AddCallerPhone(Value: Variant);
    procedure AddDataPort(Value: Integer);
    procedure AddFormatTag(Value: Word);
    procedure AddChannels(Value: Word);
    procedure AddSamplesPerSec(Value: LongWord);
    procedure AddBitsPerSample(Value: Word);
    procedure AddDataSize(Value: Integer);
    procedure AddAcceptor(Value: Variant);
    procedure AddAcceptorType(Value: TBisTaxiPhoneAcceptorType);
    procedure AddCallResultId(Value: Variant);

    property Direction: TBisTaxiPhoneMessageDirection read FDirection;
    property Name: String read FName;
    property SessionId: Variant read GetSessionId;
    property RemoteSessionId: Variant read GetRemoteSessionId;
    property ChannelId: String read GetChannelId;
    property Sequence: Integer read GetSequence;
    property CallId: Variant read GetCallId;
    property DataPort: Integer read GetDataPort;
    property FormatTag: Word read GetFormatTag;
    property Channels: Word read GetChannels;
    property SamplesPerSec: LongWord read GetSamplesPerSec;
    property BitsPerSample: Word read GetBitsPerSample;
    property DataSize: Integer read GetDataSize;
    property CallerId: Variant read GetCallerId;
    property CallerPhone: Variant read GetCallerPhone;
  end;

  TBisTaxiPhoneResponseType=(rtUnknown,rtOK,rtCancel,rtError);

  TBisTaxiPhoneResponse=class(TBisTaxiPhoneMessage)
  private
    function GetRequestName: String;
    function GetResponseType: TBisTaxiPhoneResponseType;
    function GetMessage: String;
  public

    procedure AddRequestName(Value: String);
    procedure AddResponseType(Value: TBisTaxiPhoneResponseType);
    procedure AddMessage(Value: String);

    property RequestName: String read GetRequestName;
    property ResponseType: TBisTaxiPhoneResponseType read GetResponseType;
    property Message: String read GetMessage;
  end;

  TBisTaxiPhoneResponses=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisTaxiPhoneResponse;
  public
    property Items[Index: Integer]: TBisTaxiPhoneResponse read GetItem; default;
  end;

  TBisTaxiPhoneRequest=class(TBisTaxiPhoneMessage)
  private
    FResponses: TBisTaxiPhoneResponses;
  public
    constructor Create(Direction: TBisTaxiPhoneMessageDirection; Name: String; Params: TBisEventParams=nil); override;
    destructor Destroy; override;

    property Responses: TBisTaxiPhoneResponses read FResponses;
  end;

  TBisTaxiPhoneRequests=class(TObjectList)
  private
    FSequence: Integer;
    function GetItem(Index: Integer): TBisTaxiPhoneRequest;
  public
    function Find(Response: TBisTaxiPhoneResponse): TBisTaxiPhoneRequest;
    function NextSequence: Integer;

    property Items[Index: Integer]: TBisTaxiPhoneRequest read GetItem; default;
    property Sequence: Integer read FSequence;
  end;

  TBisTaxiPhoneWaitThread=class(TBisThread)
  private
    FMessage: TBisTaxiPhoneMessage;
    FEvent: TEvent;
    FTimeout: Integer;
    FCounter: Integer;
    FOnTimeOut: TNotifyEvent;
    FInTimeout: Boolean;
    procedure DoTimeOut;
  public
    constructor Create(Message: TBisTaxiPhoneMessage; TimeOut: Integer); reintroduce;
    destructor Destroy; override;
    procedure Execute; override;
    procedure Terminate; override;
  end;

  TBisTaxiPhoneWaitThreads=class(TObjectList)
  private
    FOnTimeOut: TNotifyEvent;
    function GetItem(Index: Integer): TBisTaxiPhoneWaitThread;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create;
    destructor Destroy; override;

    function Add(Message: TBisTaxiPhoneMessage; TimeOut: Integer; Counter: Integer=0): TBisTaxiPhoneWaitThread;
    procedure RemoveBy(Message: TBisTaxiPhoneMessage);

    property Items[Index: Integer]: TBisTaxiPhoneWaitThread read GetItem; default;
  end;

  TBisTaxiPhoneChannel=class;

  TBisTaxiPhoneChannelSendThread=class(TBisThread)
  private
    FChannel: TBisTaxiPhoneChannel;
    FEvent: TEvent;
  public
    constructor Create(Channel: TBisTaxiPhoneChannel); reintroduce;
    destructor Destroy; override;
    procedure Execute; override;
    procedure Terminate; override;
  end;

  TBisTaxiPhoneChannelUDPServer=class(TIdUDPServer)
  protected
    function GetBinding: TIdSocketHandle; override;
  end;

  TBisTaxiPhoneChannelState=(csNothing,csRinning,csProcessing,csHolding,csFinished);

  TBisTaxiPhoneChannel=class(TObject)
  private
    FChannels: TBisTaxiPhoneChannels;
    FLock: TCriticalSection;
    FRequests: TBisTaxiPhoneRequests;
    FWaits: TBisTaxiPhoneWaitThreads;
    FFrame: TBisTaxiPhoneFrame;
    FServer: TBisTaxiPhoneChannelUDPServer;
    FSendThread: TBisTaxiPhoneChannelSendThread;

    FCallId: Variant;

    FId: String;
    FState: TBisTaxiPhoneChannelState;
    FProcessExists: Boolean;
    FPacketTime: Word;
    FDataSize: Cardinal;

    FIP: String;
    FPort: Integer;
    FUseCompressor: Boolean;
    FCompressorLevel: TCompressionLevel;
    FUseCrypter: Boolean;
    FCrypterKey: String;
    FCrypterAlgorithm: TBisCipherAlgorithm;
    FCrypterMode: TBisCipherMode;

    FRemoteSessionId: Variant;
    FRemoteIP: String;
    FRemotePort: Integer;
    FRemoteUseCompressor: Boolean;
    FRemoteCompressorLevel: TCompressionLevel;
    FRemoteUseCrypter: Boolean;
    FRemoteCrypterKey: String;
    FRemoteCrypterAlgorithm: TBisCipherAlgorithm;
    FRemoteCrypterMode: TBisCipherMode;
    FRemoteDataPort: Integer;
    FRemoteFormat: TWaveAcmDriverFormat;
    FRemoteDataSize: Integer;

    FStatus: String;
    FSequence: Integer;

//    procedure DoStatus(AStatus: String);
    procedure SetPacketTimeAndDataSize;

    procedure TerminateSendThread(Sender: TObject);
    procedure StopSendThread(Wait: Boolean);
    procedure StartSendThread;

    procedure FrameClose(Sender: TObject);
    procedure FrameSelect(Sender: TObject);
    procedure FrameHold(Sender: TObject);
    function FrameGetCallId(Frame: TBisTaxiPhoneFrame): Variant;

    procedure ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure ServerUDPException(Sender: TObject; ABinding: TIdSocketHandle; const AMessage: String; const AExceptionClass: TClass);
    function GetActive: Boolean;
    function DataPort: Integer;

    procedure WaitsTimeOut(Sender: TObject);

    function EncodeString(Key, S: String; Algorithm: TBisCipherAlgorithm; Mode: TBisCipherMode): String;
    function CompressString(S: String; Level: TCompressionLevel): String;
    procedure GetSendData;
//    procedure SendData(const Data: Pointer; const DataSize: Cardinal);
    function SendEvent(Event: String): Boolean;
    procedure SendMessage(Message: TBisTaxiPhoneMessage; WithWait: Boolean);
    function TryServerActive: Boolean;

    function GetServerSessionId: Variant;
    function GetRemoteEventParams(SessionId: Variant): Boolean;
    function GetCallInfo(CallIdOrPhone: Variant): Boolean;
    function TransformPhone(Phone: Variant): Variant;
    procedure ApplyCallResult;
    
    function DialRequest(Request: TBisTaxiPhoneRequest): Boolean;
    function AnswerRequest(Request: TBisTaxiPhoneRequest): Boolean;
    function HangupRequest(Request: TBisTaxiPhoneRequest): Boolean;

    function DialResponse(Response: TBisTaxiPhoneResponse; var FreeChannel: Boolean): Boolean;
    function AnswerResponse(Response: TBisTaxiPhoneResponse; var FreeChannel: Boolean): Boolean;
    function HangupResponse(Response: TBisTaxiPhoneResponse; var FreeChannel: Boolean): Boolean;
    function HoldResponse(Response: TBisTaxiPhoneResponse; var FreeChannel: Boolean): Boolean;
    function UnHoldResponse(Response: TBisTaxiPhoneResponse; var FreeChannel: Boolean): Boolean;

  public
    constructor Create(AChannels: TBisTaxiPhoneChannels);
    destructor Destroy; override;

    procedure Close;
    procedure Dial(Acceptor: String; AcceptorType: TBisTaxiPhoneAcceptorType);
    procedure Answer;
    procedure Hangup;
    procedure Hold;
    procedure UnHold;

    property Active: Boolean read GetActive;
    property Status: String read FStatus;
  end;

  TBisTaxiPhoneForm=class;

  TBisTaxiPhoneChannels=class(TObjectList)
  private
    FForm: TBisTaxiPhoneForm;
    FIP: String;
    FPort: Integer;
    FUseCompressor: Boolean;
    FCompressorLevel: TCompressionLevel;
    FUseCrypter: Boolean;
    FCrypterKey: String;
    FCrypterAlgorithm: TBisCipherAlgorithm;
    FCrypterMode: TBisCipherMode;
    FEventResult: TBisEvent;
    FEventDial: TBisEvent;
    FEventAnswer: TBisEvent;
    FEventHangup: TBisEvent;
    FLastNum: Integer;
    FWaitRetryCount: Integer;
    FWaitTimeout: Integer;
    FFreeOnLast: Boolean;
    function ExistsActive(Channel: TBisTaxiPhoneChannel): Boolean;
    function GetFrameTop(AFrame: TBisTaxiPhoneFrame): Integer;
    function GetItem(Index: Integer): TBisTaxiPhoneChannel;
    procedure ReOrderFrames;
    procedure SetFrameProps(Channel: TBisTaxiPhoneChannel);
    function MaxDataPort(Default: Integer): Integer;
    function ResultHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function AnswerHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function DialHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function HangupHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function GetNum: Integer;
  public
    constructor Create(Form: TBisTaxiPhoneForm);
    destructor Destroy; override;
    function CanAdd: Boolean;
    function Add(Id: String; Incoming: Boolean): TBisTaxiPhoneChannel;
    function AddIncoming(Request: TBisTaxiPhoneRequest): TBisTaxiPhoneChannel;
//    function AddOutgoing(OrderId: Variant): TBisTaxiPhoneChannel;
    function AddOutgoing: TBisTaxiPhoneChannel;
    function Find(Id: String): TBisTaxiPhoneChannel;
    procedure ExcludeHold(Channel: TBisTaxiPhoneChannel);
    function Height: Integer;
    procedure Remove(Channel: TBisTaxiPhoneChannel);
    function CanClose: Boolean;
    procedure StartIncomingMusic;
    procedure StartOutgoingMusic;
    procedure StartVoicePlayer(Channel: TBisTaxiPhoneChannel);
    procedure StartRecorder(Channel: TBisTaxiPhoneChannel);
    procedure StopMusic;
    procedure StopVoicePlayer;
    procedure StopRecorder;
    function GetCurrent: TBisTaxiPhoneChannel;
    function ActiveCount: Integer;

    property Items[Index: Integer]: TBisTaxiPhoneChannel read GetItem; default;

  end;

  TBisTaxiPhoneFormSelectPhoneType=(sptNone,sptClient,sptDriver,sptDispatcher,sptAccount);

  TBisTaxiPhoneForm = class(TBisForm)
    TabSet: TTabSet;
    ImageList: TImageList;
    PopupActionBarPhone: TPopupActionBar;
    MenuItemAccountPhone: TMenuItem;
    MenuItemDriverPhone: TMenuItem;
    MenuItemClientPhone: TMenuItem;
    MenuItemDispatcherPhone: TMenuItem;
    PanelControl: TPanel;
    PageControl: TPageControl;
    TabSheetPhone: TTabSheet;
    ButtonMicOff: TSpeedButton;
    ButtonBreak: TSpeedButton;
    ButtonSelect: TBitBtn;
    ComboBoxAcceptorType: TComboBox;
    ButtonDial: TBitBtn;
    TabSheetOptions: TTabSheet;
    LabelPlayerDevice: TLabel;
    LabelRecorderDevice: TLabel;
    LabelFormat: TLabel;
    LabelMaxChannels: TLabel;
    LabelTransparent: TLabel;
    ComboBoxPlayerDevice: TComboBox;
    ComboBoxRecorderDevice: TComboBox;
    TrackBarPlayer: TTrackBar;
    TrackBarRecorder: TTrackBar;
    EditFormat: TEdit;
    ButtonFormat: TButton;
    EditMaxChannels: TEdit;
    UpDownMaxChannels: TUpDown;
    TrackBarTransparent: TTrackBar;
    StatusBar: TStatusBar;
    ComboBoxAcceptor: TComboBox;
    LabelNoChannels: TLabel;
    LabelBuffer: TLabel;
    EditBuffer: TEdit;
    UpDownBuffer: TUpDown;
    EditBufferCount: TEdit;
    UpDownBufferCount: TUpDown;
    CheckBoxAutoAnswer: TCheckBox;
    TimerAutoAnswer: TTimer;
    EditAutoAnswer: TEdit;
    UpDownAutoAnswer: TUpDown;
    procedure TabSetChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure ButtonSelectClick(Sender: TObject);
    procedure ComboBoxAcceptorTypeChange(Sender: TObject);
    procedure PopupActionBarPhonePopup(Sender: TObject);
    procedure MenuItemClientPhoneClick(Sender: TObject);
    procedure MenuItemDriverPhoneClick(Sender: TObject);
    procedure MenuItemAccountPhoneClick(Sender: TObject);
    procedure ButtonMicOffClick(Sender: TObject);
    procedure ButtonBreakClick(Sender: TObject);
    procedure TrackBarPlayerChange(Sender: TObject);
    procedure ComboBoxPlayerDeviceChange(Sender: TObject);
    procedure ComboBoxRecorderDeviceChange(Sender: TObject);
    procedure TrackBarRecorderChange(Sender: TObject);
    procedure ButtonFormatClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TrackBarTransparentChange(Sender: TObject);
    procedure ButtonDialClick(Sender: TObject);
    procedure MenuItemDispatcherPhoneClick(Sender: TObject);
    procedure EditMaxChannelsChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBoxAcceptorChange(Sender: TObject);
    procedure TimerAutoAnswerTimer(Sender: TObject);
    procedure CheckBoxAutoAnswerClick(Sender: TObject);
  private
    FPhone: String;
    FComputer: String;
    FAccount: String;
    FSession: String;
    FAccountId: Variant;
    FSessionId: Variant;
    FBeforeShowed: Boolean;
    FVoicePlayerLock: TCriticalSection;
    FRecorderLock: TCriticalSection;
    FSelectPhoneType: TBisTaxiPhoneFormSelectPhoneType;
    FOldAcceptorType: TBisTaxiPhoneAcceptorType;
    FDrivers: TBisACMDrivers;
    FFormat: TWaveACMDriverFormat;
    FRecorderStream: TMemoryStream;
    FRecorder: TBisLiveAudioRecorder;
    FRecorderMixer: TBisAudioMixer;
    FRecorderMixerLine: TAudioMixerLine;
    FRecorderBufferSize: Cardinal;
    FVoicePlayerStream: TMemoryStream;
    FVoicePlayer: TBisLiveAudioPlayer;
    FVoicePlayerBufferSize: Cardinal;
    FMusicPlayer: TBisStockAudioPlayer;
    FPlayerMixerLine: TAudioMixerLine;
    FPlayerMixer: TBisAudioMixer;
    FChannels: TBisTaxiPhoneChannels;
    FOldPlayerIndex: Integer;
    FOldRecorderIndex: Integer;
    FOldPlayerDeviceCaption: String;
    FOldRecorderDeviceCaption: String;
    FIncomingStream: TMemoryStream;
    FOutgoingStream: TMemoryStream;
    FLastDialChannel: TBisTaxiPhoneChannel; 
    FSMicEnabled: String;
    FSMicDisabled: String;
    FSBreakEnabled: String;
    FSBreakDisabled: String;
    
    function GetAcceptorType: TBisTaxiPhoneAcceptorType;
    procedure SetAcceptorType(Value: TBisTaxiPhoneAcceptorType);
    function GetAcceptor: String;
    procedure SetAcceptor(Value: String);
    function GetFormatDescription(Format: TWaveACMDriverFormat): String;
    function CanSelectAccountPhone: Boolean;
    procedure SelectAccountPhone;
    function CanSelectDriverPhone: Boolean;
    procedure SelectDriverPhone;
    function CanSelectClientPhone: Boolean;
    procedure SelectClientPhone;
    function CanSelectDispatcherPhone: Boolean;
    procedure SelectDispatcherPhone;
    function CanSelectAccount: Boolean;
    procedure SelectAccount;
    function CanSelectComputer: Boolean;
    procedure SelectComputer;
    function CanSelectSession: Boolean;
    procedure SelectSession;
    procedure UpdateMicOffButton;
    procedure UpdateBreakButton;
    procedure UpdateTrackBarPlayer;
    procedure UpdateTrackBarRecorder;
    procedure UpdateButtonDial;
    procedure UpdateHeight;
    procedure UpdateChannel(AChannel: TBisTaxiPhoneChannel);
    procedure ConnectionUpdate(AEnabled: Boolean);
    procedure GetLocalEventParams;
//  function VoicePlayerDataPtr(Sender: TObject; var Buffer: Pointer; var NumLoops: Cardinal; var FreeIt: Boolean): Cardinal;
    function VoicePlayerData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var NumLoops: Cardinal): Cardinal;
    procedure InData(Channel: TBisTaxiPhoneChannel; const Data: Pointer; const DataSize: Cardinal);
    procedure RecorderFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
    procedure RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);
    function OutData(Channel: TBisTaxiPhoneChannel; const Data: Pointer; const DataSize: Cardinal): Boolean;
    procedure VoicePlayerActivate(Sender: TObject);
    procedure VoicePlayerDeactivate(Sender: TObject);
    procedure RecorderActivate(Sender: TObject);
    procedure RecorderDeactivate(Sender: TObject);
    procedure Ring(Channel: TBisTaxiPhoneChannel);
    procedure StartRecorder(Channel: TBisTaxiPhoneChannel);
    procedure StartVoicePlayer(Channel: TBisTaxiPhoneChannel);
  protected
    procedure ReadProfileParams; override;
    procedure WriteProfileParams; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure BeforeShow; override;

    function CanDial: Boolean;
    procedure Dial;

  published
    property SMicEnabled: String read FSMicEnabled write FSMicEnabled;
    property SMicDisabled: String read FSMicDisabled write FSMicDisabled;
    property SBreakEnabled: String read FSBreakEnabled write FSBreakEnabled;
    property SBreakDisabled: String read FSBreakDisabled write FSBreakDisabled;
  end;

  TBisTaxiPhoneFormIface=class(TBisFormIface)
  private
    FNumber: String;
    function GetCallId: Variant;
    function GetLastForm: TBisTaxiPhoneForm;
    function GetPhone: String;
  protected
     function CreateForm: TBisForm; override;  
  public
    constructor Create(AOwner: TComponent); override;
//    procedure Dial(Number: String; OrderId: Variant);
    procedure Dial(Number: String);

    property CallId: Variant read GetCallId;
    property Phone: String read GetPhone;
    property LastForm: TBisTaxiPhoneForm read GetLastForm;
  end;

var
  BisTaxiPhoneForm: TBisTaxiPhoneForm;

implementation

uses Math,
     IdUDPClient,
     BisCore, BisProvider, BisUtils, BisDialogs, BisConfig, BisIfaces, BisDataFm,
     BisConnectionUtils, BisAudioFormatFm,
     BisParamEditDataSelect, BisDataSet, BisParam, BisFilterGroups, BisLogger, BisNetUtils,
     BisDesignDataAccountsFm, BisDesignDataRolesAndAccountsFm, BisDesignDataSessionsFm,
     BisTaxiConsts, BisTaxiDataDriversFm, BisTaxiDataClientsFm, BisTaxiDataDispatchersFm;

{$R *.dfm}

function GetEventParams(SessionId: Variant;
                        var IP: String; var Port: Integer;
                        var UseCompressor: Boolean; var CompressorLevel: TCompressionLevel;
                        var UseCrypter: Boolean; var CrypterKey: String;
                        var CrypterAlgorithm: TBisCipherAlgorithm; var CrypterMode: TBisCipherMode): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  if not Result then begin
    P:=TBisProvider.Create(nil);
    try
      P.UseShowError:=false;
      P.UseWaitCursor:=false;
      P.ProviderName:='GET_EVENT_PARAMS';
      with P.Params do begin
        AddInvisible('SESSION_ID').Value:=SessionId;
        AddInvisible('IP',ptOutput);
        AddInvisible('PORT',ptOutput);
        AddInvisible('USE_CRYPTER',ptOutput);
        AddInvisible('CRYPTER_KEY',ptOutput);
        AddInvisible('CRYPTER_ALGORITHM',ptOutput);
        AddInvisible('CRYPTER_MODE',ptOutput);
        AddInvisible('USE_COMPRESSOR',ptOutput);
        AddInvisible('COMPRESSOR_LEVEL',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        IP:=P.ParamByName('IP').AsString;
        Port:=P.ParamByName('PORT').AsInteger;
        UseCrypter:=Boolean(P.ParamByName('USE_CRYPTER').AsInteger);
        CrypterKey:=P.ParamByName('CRYPTER_KEY').AsString;
        CrypterAlgorithm:=TBisCipherAlgorithm(P.ParamByName('CRYPTER_ALGORITHM').AsInteger);
        CrypterMode:=TBisCipherMode(P.ParamByName('CRYPTER_MODE').AsInteger);
        UseCompressor:=Boolean(P.ParamByName('USE_COMPRESSOR').AsInteger);
        CompressorLevel:=TCompressionLevel(P.ParamByName('COMPRESSOR_LEVEL').AsInteger);
        Result:=Trim(IP)<>'';
      end;
    finally
      P.Free;
    end;
  end;
end;


{ TBisTaxiPhoneFormIface }

constructor TBisTaxiPhoneFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiPhoneForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
  ShowType:=stDefault;
  FNumber:='';
end;

function TBisTaxiPhoneFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(LastForm) then begin
    if FNumber<>'' then begin
      with LastForm do begin
        SetAcceptorType(atPhone);
        SetAcceptor(FNumber);
      end;
      FNumber:='';
    end;
  end;
end;

function TBisTaxiPhoneFormIface.GetLastForm: TBisTaxiPhoneForm;
begin
  Result:=TBisTaxiPhoneForm(inherited LastForm);
end;

procedure TBisTaxiPhoneFormIface.Dial(Number: String);
var
  Last: TBisTaxiPhoneForm;
begin
  Last:=LastForm;
  if not Assigned(Last) then begin
    FNumber:=Trim(Number);
    Show;
  end else begin
    Last.SetAcceptorType(atPhone);
    Last.SetAcceptor(Number);
    Last.Dial;
  end;
end;

function TBisTaxiPhoneFormIface.GetCallId: Variant;
var
  Last: TBisTaxiPhoneForm;
  Channel: TBisTaxiPhoneChannel;
begin
  Result:=Null;
  Last:=LastForm;
  if Assigned(Last) then begin
    Channel:=Last.FChannels.GetCurrent;
    if Assigned(Channel) then
      Result:=Channel.FCallId;
  end;
end;

function TBisTaxiPhoneFormIface.GetPhone: String;
var
  Last: TBisTaxiPhoneForm;
  Channel: TBisTaxiPhoneChannel;
begin
  Result:='';
  Last:=LastForm;
  if Assigned(Last) then begin
    Channel:=Last.FChannels.GetCurrent;
    if Assigned(Channel) and Assigned(Channel.FFrame) then
      Result:=Channel.FFrame.LabelName.Caption;
  end;
end;

{ TBisTaxiPhoneMessage }

constructor TBisTaxiPhoneMessage.Create(Direction: TBisTaxiPhoneMessageDirection; Name: String; Params: TBisEventParams);
begin
  inherited Create;
  FDirection:=Direction;
  FName:=Name;
  CopyFrom(Params);
end;

destructor TBisTaxiPhoneMessage.Destroy;
begin
  inherited Destroy;
end;

procedure TBisTaxiPhoneMessage.CopyFrom(Params: TBisEventParams);
var
  i: Integer;
  Param: TBisEventParam;
  V: Variant;
  S: String;
begin
  if Assigned(Params) then begin
    Clear;
    for i:=0 to Params.Count-1 do begin
      Param:=Params[i];
      if not VarIsNull(Param.Value) then begin
        V:=Param.Value;
        case VarType(V) of
          varOleStr,varString: begin
            S:=VarToStrDef(V,'');
            if S='' then
              V:=Null;
          end;
        end;
      end else
        V:=Null;
      Add(Param.Name,V);
    end;
  end;
end;

function TBisTaxiPhoneMessage.AsString: String;
var
  Config: TBisConfig;
  i: Integer;
  Item: TBisValue;
begin
  Result:='';
  if Trim(FName)<>'' then begin
    Config:=TBisConfig.Create(nil);
    try
      for i:=0 to Count-1 do begin
        Item:=Items[i];
        Config.Write(FName,Item.Name,Item.Value);
      end;
      Result:=Trim(Config.Text);
    finally
      Config.Free;
    end;
  end;
end;

function TBisTaxiPhoneMessage.GetCallId: Variant;
begin
  Result:=GetValue('CallId');
end;

function TBisTaxiPhoneMessage.GetChannelId: String;
begin
  Result:=VarToStrDef(GetValue('ChannelId'),'');
end;

function TBisTaxiPhoneMessage.GetDataPort: Integer;
begin
  Result:=VarToIntDef(GetValue('DataPort'),0);
end;

function TBisTaxiPhoneMessage.GetRemoteSessionId: Variant;
begin
  Result:=GetValue('RemoteSessionId');
end;

function TBisTaxiPhoneMessage.GetSessionId: Variant;
begin
  Result:=GetValue('SessionId');
end;

function TBisTaxiPhoneMessage.GetSequence: Integer;
begin
  Result:=VarToIntDef(GetValue('Sequence'),0);
end;

function TBisTaxiPhoneMessage.GetFormatTag: Word;
begin
  Result:=VarToIntDef(GetValue('FormatTag'),0);
end;

function TBisTaxiPhoneMessage.GetChannels: Word;
begin
  Result:=VarToIntDef(GetValue('Channels'),0);
end;

function TBisTaxiPhoneMessage.GetSamplesPerSec: LongWord;
begin
  Result:=VarToIntDef(GetValue('SamplesPerSec'),0);
end;

function TBisTaxiPhoneMessage.GetBitsPerSample: Word;
begin
  Result:=VarToIntDef(GetValue('BitsPerSample'),0);
end;

function TBisTaxiPhoneMessage.GetDataSize: Integer;
begin
  Result:=VarToIntDef(GetValue('DataSize'),0);
end;

function TBisTaxiPhoneMessage.GetCallerId: Variant;
begin
  Result:=GetValue('CallerId');
end;

function TBisTaxiPhoneMessage.GetCallerPhone: Variant;
begin
  Result:=GetValue('CallerPhone');
end;

procedure TBisTaxiPhoneMessage.AddCallId(Value: Variant);
begin
  Add('CallId',Value);
end;

procedure TBisTaxiPhoneMessage.AddCallResultId(Value: Variant);
begin
  Add('CallResultId',Value);
end;

procedure TBisTaxiPhoneMessage.AddCallerId(Value: Variant);
begin
  Add('CallerId',Value);
end;

procedure TBisTaxiPhoneMessage.AddCallerPhone(Value: Variant);
begin
  Add('CallerPhone',Value);
end;

procedure TBisTaxiPhoneMessage.AddChannelId(Value: String);
begin
  Add('ChannelId',Value);
end;

procedure TBisTaxiPhoneMessage.AddDataPort(Value: Integer);
begin
  Add('DataPort',Value);
end;

procedure TBisTaxiPhoneMessage.AddRemoteSessionId(Value: Variant);
begin
  Add('RemoteSessionId',Value);
end;

procedure TBisTaxiPhoneMessage.AddSequence(Value: Integer);
begin
  Add('Sequence',Value);
end;

procedure TBisTaxiPhoneMessage.AddSessionId(Value: Variant);
begin
  Add('SessionId',Value);
end;

procedure TBisTaxiPhoneMessage.AddFormatTag(Value: Word);
begin
  Add('FormatTag',Value);
end;


procedure TBisTaxiPhoneMessage.AddChannels(Value: Word);
begin
  Add('Channels',Value);
end;

procedure TBisTaxiPhoneMessage.AddSamplesPerSec(Value: LongWord);
begin
  Add('SamplesPerSec',Value);
end;

procedure TBisTaxiPhoneMessage.AddBitsPerSample(Value: Word);
begin
  Add('BitsPerSample',Value);
end;

procedure TBisTaxiPhoneMessage.AddDataSize(Value: Integer);
begin
  Add('DataSize',Value);
end;

procedure TBisTaxiPhoneMessage.AddAcceptor(Value: Variant);
begin
  Add('Acceptor',Value);
end;

procedure TBisTaxiPhoneMessage.AddAcceptorType(Value: TBisTaxiPhoneAcceptorType);
begin
  Add('AcceptorType',Value);
end;

{ TBisTaxiPhoneResponse }

procedure TBisTaxiPhoneResponse.AddMessage(Value: String);
begin
  Add('Message',Value);
end;

procedure TBisTaxiPhoneResponse.AddRequestName(Value: String);
begin
  Add('RequestName',Value);
end;

procedure TBisTaxiPhoneResponse.AddResponseType(Value: TBisTaxiPhoneResponseType);
begin
  Add('ResponseType',Integer(Value));
end;

function TBisTaxiPhoneResponse.GetMessage: String;
begin
  Result:=VarToStrDef(GetValue('Message'),'');
end;

function TBisTaxiPhoneResponse.GetRequestName: String;
begin
  Result:=VarToStrDef(GetValue('RequestName'),'');
end;

function TBisTaxiPhoneResponse.GetResponseType: TBisTaxiPhoneResponseType;
begin
  Result:=TBisTaxiPhoneResponseType(VarToIntDef(GetValue('ResponseType'),Integer(rtUnknown)));
end;

{ TBisTaxiPhoneResponses }

function TBisTaxiPhoneResponses.GetItem(Index: Integer): TBisTaxiPhoneResponse;
begin
  Result:=TBisTaxiPhoneResponse(inherited Items[Index]);
end;

{ TBisTaxiPhoneRequest }

constructor TBisTaxiPhoneRequest.Create(Direction: TBisTaxiPhoneMessageDirection; Name: String; Params: TBisEventParams=nil);
begin
  inherited Create(Direction,Name,Params);
  FResponses:=TBisTaxiPhoneResponses.Create;
end;

destructor TBisTaxiPhoneRequest.Destroy;
begin
  FResponses.Free;
  inherited Destroy;
end;

{ TBisTaxiPhoneRequests }

function TBisTaxiPhoneRequests.Find(Response: TBisTaxiPhoneResponse): TBisTaxiPhoneRequest;
var
  i: Integer;
  Item: TBisTaxiPhoneRequest;
begin
  Result:=nil;
  if Assigned(Response) then begin
    for i:=Count-1 downto 0 do begin
      Item:=Items[i];
      if AnsiSameText(Item.Name,Response.RequestName) and
         (Item.Sequence=Response.Sequence) then begin
        Result:=Item;
        exit;
      end;
    end;
  end;
end;

function TBisTaxiPhoneRequests.GetItem(Index: Integer): TBisTaxiPhoneRequest;
begin
  Result:=TBisTaxiPhoneRequest(inherited Items[Index]);
end;

function TBisTaxiPhoneRequests.NextSequence: Integer;
begin
  Inc(FSequence);
  Result:=FSequence;
end;

{ TBisTaxiPhoneWaitThread }

constructor TBisTaxiPhoneWaitThread.Create(Message: TBisTaxiPhoneMessage; TimeOut: Integer);
begin
  inherited Create;
//  FreeOnTerminate:=false;
  FMessage:=Message;
  FTimeout:=TimeOut;
  FEvent:=TEvent.Create(nil,false,false,'');
end;

destructor TBisTaxiPhoneWaitThread.Destroy;
begin
  FEvent.SetEvent;
  FEvent.Free;
  inherited Destroy;
end;

procedure TBisTaxiPhoneWaitThread.Terminate;
begin
  FEvent.SetEvent;
  inherited Terminate;
end;

procedure TBisTaxiPhoneWaitThread.DoTimeOut;
begin
  Inc(FCounter);
  if Assigned(FOnTimeOut) then
    FOnTimeOut(Self);
end;

procedure TBisTaxiPhoneWaitThread.Execute;
var
  Ret: TWaitResult;
begin
  inherited Execute;
  FEvent.ResetEvent;
  Ret:=FEvent.WaitFor(FTimeOut);
  if (Ret=wrTimeout) and not Terminated then begin
    FInTimeout:=true;
    try
      Synchronize(DoTimeOut);
    finally
      FInTimeout:=false;
    end;
  end;
end;

{ TBisTaxiPhoneWaitThreads }

constructor TBisTaxiPhoneWaitThreads.Create;
begin
  inherited Create(true);
end;

destructor TBisTaxiPhoneWaitThreads.Destroy;
begin
  inherited Destroy;
end;

function TBisTaxiPhoneWaitThreads.GetItem(Index: Integer): TBisTaxiPhoneWaitThread;
begin
  Result:=TBisTaxiPhoneWaitThread(inherited Items[Index]);
end;

procedure TBisTaxiPhoneWaitThreads.Notify(Ptr: Pointer; Action: TListNotification);
var
  Item: TBisTaxiPhoneWaitThread; 
begin
  Item:=TBisTaxiPhoneWaitThread(Ptr);
  if OwnsObjects and Assigned(Item) and (Action=lnDeleted) then begin
    Item.Terminate;
 {   if not Item.FInTimeout then begin
      Item.FreeOnTerminate:=false;
      Item.WaitFor;
      inherited Notify(Ptr,Action);
    end else begin }
//      Item.FreeOnTerminate:=true;
      OwnsObjects:=false;
      try
        inherited Notify(Ptr,Action);
      finally
        OwnsObjects:=true;
      end;
   // end;
  end else
    inherited Notify(Ptr,Action);
end;

function TBisTaxiPhoneWaitThreads.Add(Message: TBisTaxiPhoneMessage; TimeOut: Integer; Counter: Integer): TBisTaxiPhoneWaitThread;
begin
  Result:=TBisTaxiPhoneWaitThread.Create(Message,TimeOut);
  Result.FOnTimeOut:=FOnTimeOut;
  Result.FCounter:=Counter;
  inherited Add(Result);
end;

procedure TBisTaxiPhoneWaitThreads.RemoveBy(Message: TBisTaxiPhoneMessage);
var
  i: Integer;
  Item: TBisTaxiPhoneWaitThread;
 // OldFlag: Boolean;
begin
  for i:=Count-1 downto 0 do begin
    Item:=Items[i];
    if Item.FMessage=Message then begin
    {  OldFlag:=Item.FInTimeout;
      try
        Item.FInTimeout:=true;   }
        Remove(Item);
    {  finally
        Item.FInTimeout:=OldFlag;
      end;   }
    end;
  end;
end;

{ TBisTaxiPhoneChannelSendThread }

constructor TBisTaxiPhoneChannelSendThread.Create(Channel: TBisTaxiPhoneChannel);
begin
  inherited Create;
//  FreeOnTerminate:=true;
  Priority:=tpHighest;
  FChannel:=Channel;
  FEvent:=TEvent.Create(nil,false,false,'');
end;

destructor TBisTaxiPhoneChannelSendThread.Destroy;
begin
  FEvent.SetEvent;
  FEvent.Free;
  inherited Destroy;
end;

procedure TBisTaxiPhoneChannelSendThread.Terminate;
begin
  FEvent.SetEvent;
  inherited Terminate;
end;

procedure TBisTaxiPhoneChannelSendThread.Execute;
var
  Ret: TWaitResult;
begin
  inherited Execute;
  try
    if Assigned(FChannel) then begin
      with FChannel do begin
        while not Terminated do begin
          FEvent.ResetEvent;
          Ret:=FEvent.WaitFor(FPacketTime);
          if (Ret=wrTimeout) and not Terminated then
            GetSendData
          else
            break;
        end;
      end;
    end;
  except
    On E: Exception do
      if Assigned(FChannel) and Assigned(FChannel.FChannels) and
         Assigned(FChannel.FChannels.FForm) then
        FChannel.FChannels.FForm.LoggerWrite(E.Message);

  end;
end;

{ TBisTaxiPhoneChannelUDPServer }

function TBisTaxiPhoneChannelUDPServer.GetBinding: TIdSocketHandle;
begin
  Result:=inherited GetBinding;
  if Assigned(FListenerThread) then begin
    FListenerThread.Priority:=tpHighest;
  end;
end;

{ TBisTaxiPhoneChannel }

constructor TBisTaxiPhoneChannel.Create(AChannels: TBisTaxiPhoneChannels);
begin
  inherited Create;
  FChannels:=AChannels;

  FLock:=TCriticalSection.Create;

  FFrame:=TBisTaxiPhoneFrame.Create(nil);
  FFrame.OnClose:=FrameClose;
  FFrame.OnSelect:=FrameSelect;
  FFrame.OnHold:=FrameHold;
  FFrame.OnGetCallId:=FrameGetCallId;

  FRequests:=TBisTaxiPhoneRequests.Create;

  FWaits:=TBisTaxiPhoneWaitThreads.Create;
  FWaits.FOnTimeOut:=WaitsTimeOut;

  FServer:=TBisTaxiPhoneChannelUDPServer.Create(nil);
  FServer.ThreadedEvent:=true;
  FServer.ThreadName:='TaxiPhoneChannelListen';
  FServer.OnUDPRead:=ServerUDPRead;
  FServer.OnUDPException:=ServerUDPException;

  FCallId:=Null;
  FPacketTime:=20;
  FSequence:=0;

  SetPacketTimeAndDataSize;

end;

destructor TBisTaxiPhoneChannel.Destroy;
begin
  StopSendThread(true);
  FServer.OnUDPRead:=nil;
  FServer.Free;
  FWaits.Free;
  FRequests.Free;
  FFrame.Free;
  FLock.Free;
  if Assigned(FChannels) and Assigned(FChannels.FForm) and
     (FChannels.FForm.FLastDialChannel=Self) then
    FChannels.FForm.FLastDialChannel:=nil;
  FChannels:=nil;
  inherited Destroy;
end;

{procedure TBisTaxiPhoneChannel.DoStatus(AStatus: String);
begin
  if Assigned(FChannels) then begin
    FStatus:=AStatus;
    FChannels.FForm.UpdateChannel(Self);
  end;
end;}

procedure TBisTaxiPhoneChannel.SetPacketTimeAndDataSize;
var
  Format: TWaveAcmDriverFormat;
  W: PWaveFormatEx;
  Total: Extended;
begin
  Format:=FChannels.FForm.FFormat;
  if Assigned(Format) then begin
    W:=Format.WaveFormat;
    if W.nBlockAlign>1 then begin
      Total:=W.nChannels*(W.nAvgBytesPerSec/1000);
      FPacketTime:=Round(W.nBlockAlign/Total);
      FDataSize:=W.nBlockAlign;
    end else begin
      Total:=W.nChannels*(W.nAvgBytesPerSec/1000);
      FDataSize:=Round(Total*FPacketTime);
    end;
  end;
end;

procedure TBisTaxiPhoneChannel.TerminateSendThread(Sender: TObject);
begin
  FSendThread:=nil;
end;

procedure TBisTaxiPhoneChannel.StopSendThread(Wait: Boolean);
var
  Thread: TBisTaxiPhoneChannelSendThread;
begin
  Wait:=true;
  if Assigned(FSendThread) then begin
    Thread:=FSendThread;
{    if Wait then
      Thread.FreeOnTerminate:=false;}
    Thread.Terminate;
    if Wait then begin
//      Thread.WaitFor;
      Thread.Free;
    end;
  end;
end;

procedure TBisTaxiPhoneChannel.StartSendThread;
begin
  StopSendThread(true);
  if Active and not Assigned(FSendThread) then begin
    FSendThread:=TBisTaxiPhoneChannelSendThread.Create(self);
//    FSendThread.OnTerminate:=TerminateSendThread;
//    FSendThread.Resume;
  end;
end;

procedure TBisTaxiPhoneChannel.FrameSelect(Sender: TObject);
begin
  if Assigned(FChannels) then begin
    FChannels.ExcludeHold(Self);
    case FState of
      csNothing: ;
      csRinning: Answer;
      csProcessing: ;
      csHolding: Unhold;
      csFinished: ;
    end;
  end;
end;

procedure TBisTaxiPhoneChannel.FrameClose(Sender: TObject);
begin
  if Assigned(FChannels) then begin
    case FState of
      csNothing: FChannels.Remove(Self);
      csRinning,csProcessing,csHolding: Hangup;
      csFinished: begin
        ApplyCallResult;
        FChannels.Remove(Self);
      end;
    end;
  end;
end;

procedure TBisTaxiPhoneChannel.FrameHold(Sender: TObject);
begin
  if Assigned(FChannels) then begin
    case FState of
      csNothing: ;
      csRinning: ;
      csProcessing: Hold;
      csHolding: ;
      csFinished: ;
    end;
  end;
end;

function TBisTaxiPhoneChannel.GetActive: Boolean;
begin
  Result:=FServer.Active and (FServer.Bindings.Count=1) and Assigned(FFrame);
end;

function TBisTaxiPhoneChannel.FrameGetCallId(Frame: TBisTaxiPhoneFrame): Variant;
begin
  Result:=FCallId;
end;

procedure TBisTaxiPhoneChannel.ServerUDPException(Sender: TObject; ABinding: TIdSocketHandle; const AMessage: String;
                                                  const AExceptionClass: TClass);
begin
  if Assigned(FChannels) and Assigned(FChannels.FForm) then
    FChannels.FForm.LoggerWrite(AMessage,ltError);
end;

procedure TBisTaxiPhoneChannel.ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
var
  L: Integer;
//  Sequence: Cardinal;
begin
  FLock.Enter;
  try
    L:=Length(AData);
    if (L=FRemoteDataSize) and (FState=csProcessing) and
       Assigned(FChannels) and Assigned(FChannels.FForm) then begin
      try
        FChannels.FForm.InData(Self,AData,L);
      except
        On E: Exception do begin
          FChannels.FForm.LoggerWrite(E.Message,ltError);
        end;
      end;
    end;
{    L:=Length(AData);
    if (L=FRemoteDataSize+SizeOf(Sequence)) and (FState=csProcessing) and
       Assigned(FChannels) and Assigned(FChannels.FForm) then begin
      try
        Move(Pointer(AData)^,Sequence,SizeOf(Sequence));
        FChannels.FForm.InData(Self,Pointer(Cardinal(AData)+SizeOf(Sequence)),L-SizeOf(Sequence));
        FChannels.FForm.LoggerWrite(IntToStr(Sequence),ltInformation);
      except
        On E: Exception do begin
          FChannels.FForm.LoggerWrite(E.Message,ltError);
        end;
      end;
    end;}
  finally
    FLock.Leave;
  end;
end;

function TBisTaxiPhoneChannel.DataPort: Integer;
begin
  Result:=0;
  if FServer.Bindings.Count>0 then
    Result:=FServer.Bindings[0].Port;
end;

procedure TBisTaxiPhoneChannel.WaitsTimeOut(Sender: TObject);
var
  Wait: TBisTaxiPhoneWaitThread;
begin
  if Assigned(Sender) and (Sender is TBisTaxiPhoneWaitThread) then begin                                       
    Wait:=TBisTaxiPhoneWaitThread(Sender);
    try
      if Assigned(Wait.FMessage) and Assigned(FChannels) then begin
        if Wait.FCounter<FChannels.FWaitRetryCount then begin
          if SendEvent(Wait.FMessage.AsString) then
//            FWaits.Add(Wait.FMessage,FChannels.FWaitTimeOut,Wait.FCounter).Resume;
        end else begin
          FState:=csFinished;
          FFrame.Finished:=true;
          StopSendThread(false);
          FChannels.StopMusic;
          if not FChannels.ExistsActive(Self) then begin
            FChannels.StopVoicePlayer;
            FChannels.StopRecorder;
          end;
        end;
      end;
    finally
      FWaits.Remove(Wait);
    end;
  end;
end;

function TBisTaxiPhoneChannel.EncodeString(Key, S: String; Algorithm: TBisCipherAlgorithm; Mode: TBisCipherMode): String;
var
  Crypter: TBisCrypter;
begin
  Crypter:=TBisCrypter.Create;
  try
    Result:=Crypter.EncodeString(Key,S,Algorithm,Mode);
  finally
    Crypter.Free;
  end;
end;

procedure TBisTaxiPhoneChannel.Close;
begin
  if (FState in [csHolding,csProcessing,csFinished]) and
     (Assigned(FFrame) and FFrame.Incoming and not FFrame.Flashing) then begin
    if FFrame.QueryCallResultId then
      Hangup;
  end;
end;

function TBisTaxiPhoneChannel.CompressString(S: String; Level: TCompressionLevel): String;
var
  Zip: TCompressionStream;
  TempStream: TMemoryStream;
begin
  TempStream:=TMemoryStream.Create;
  try
    Zip:=TCompressionStream.Create(Level,TempStream);
    try
      Zip.Write(Pointer(S)^,Length(S));
    finally
      Zip.Free;
    end;
    TempStream.Position:=0;
    SetLength(Result,TempStream.Size);
    TempStream.Read(Pointer(Result)^,Length(Result))
  finally
    TempStream.Free;
  end;
end;

procedure TBisTaxiPhoneChannel.GetSendData;
var
  L: Integer;
  D: TBytes;
  S: String;
begin
  FLock.Enter;
  try
    if Assigned(FChannels) and Assigned(FChannels.FForm) then begin
      L:=FDataSize;
      SetLength(D,L);
      if FChannels.FForm.OutData(Self,D,L) then begin
        SetLength(S,L);
        Move(Pointer(D)^,Pointer(S)^,L);
        FServer.Send(FRemoteIP,FRemoteDataPort,S);
//        FChannels.FForm.LoggerWrite('Send');
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

{procedure TBisTaxiPhoneChannel.SendData(const Data: Pointer; const DataSize: Cardinal);
var
  L: Integer;
  S: String;
begin
  FLock.Enter;
  try
    if (DataSize=FDataSize) and Assigned(FChannels) and Assigned(FChannels.FForm) then begin
      L:=DataSize;
      SetLength(S,L);
      Move(Data^,Pointer(S)^,L);
      FChannels.FForm.LoggerWrite('Send');
      FServer.Send(FRemoteIP,FRemoteDataPort,S);
    end;
  finally
    FLock.Leave;
  end;
end;}

function TBisTaxiPhoneChannel.SendEvent(Event: String): Boolean;
var
  Udp: TIdUDPClient;
  S: String;
begin
  Result:=false;
  if Event<>'' then begin
    Udp:=TIdUDPClient.Create(nil);
    try
      S:=Event;

      if FRemoteUseCompressor then
        S:=CompressString(S,FRemoteCompressorLevel);

      if FRemoteUseCrypter then
        S:=EncodeString(FRemoteCrypterKey,S,
                        FRemoteCrypterAlgorithm,FRemoteCrypterMode);

      Udp.Host:=FRemoteIP;
      Udp.Port:=FRemotePort;
      Udp.BufferSize:=Length(S);
      Udp.Connect;
      Udp.Send(S);
      Result:=true;
    finally
      Udp.Free;
    end;
  end;
end;

procedure TBisTaxiPhoneChannel.SendMessage(Message: TBisTaxiPhoneMessage; WithWait: Boolean);
begin
  if Assigned(Message) and Assigned(FChannels) then begin
    if SendEvent(Message.AsString) and (FChannels.FWaitRetryCount>0) and WithWait then
//      FWaits.Add(Message,FChannels.FWaitTimeOut).Resume;
  end;
end;

function TBisTaxiPhoneChannel.GetServerSessionId: Variant;
var
  P: TBisProvider;
begin
  Result:=Null;
  P:=TBisProvider.Create(nil);
  try
    P.UseWaitCursor:=false;
    P.ProviderName:='GET_CALL_SERVER_SESSION_ID';
    P.Params.AddInvisible('SERVER_SESSION_ID',ptOutput);
    P.Execute;
    if P.Success then
      Result:=P.ParamByName('SERVER_SESSION_ID').Value;
  finally
    P.Free;
  end;
end;

function TBisTaxiPhoneChannel.GetRemoteEventParams(SessionId: Variant): Boolean;
begin
  Result:=GetEventParams(SessionId,
                         FRemoteIP,FRemotePort,FRemoteUseCompressor,FRemoteCompressorLevel,
                         FRemoteUseCrypter,FRemoteCrypterKey,FRemoteCrypterAlgorithm,FRemoteCrypterMode);
end;

function TBisTaxiPhoneChannel.GetCallInfo(CallIdOrPhone: Variant): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  P:=TBisProvider.Create(nil);
  try
    P.UseWaitCursor:=false;
    P.ProviderName:='GET_CALL_INFO';
    with P.Params do begin
      AddInvisible('CALL_INFO').Value:=CallIdOrPhone;
      AddInvisible('CALL_NAME',ptOutput);
      AddInvisible('CALL_GROUP',ptOutput);
      AddInvisible('CALL_DESCRIPTION',ptOutput);
      AddInvisible('CALL_KIND',ptOutput);
      AddInvisible('CALL_NAME_DESCRIPTION',ptOutput);
      AddInvisible('CALL_LINE_NAME',ptOutput);
    end;
    P.Execute;
    if P.Success then begin
      FFrame.CallName:=P.ParamByName('CALL_NAME').AsString;
      FFrame.CallGroup:=P.ParamByName('CALL_GROUP').AsString;
      FFrame.CallDescription:=P.ParamByName('CALL_DESCRIPTION').AsString;
      FFrame.CallKind:=TBisTaxiPhoneCallKind(P.ParamByName('CALL_KIND').AsInteger);
      FFrame.CallNameDescription:=P.ParamByName('CALL_NAME_DESCRIPTION').AsString;
      FFrame.CallLineName:=P.ParamByName('CALL_LINE_NAME').AsString;
      Result:=true;
    end;
  finally
    P.Free;
  end;
end;

function TBisTaxiPhoneChannel.TransformPhone(Phone: Variant): Variant;
var
  P: TBisProvider;
begin
  Result:=Phone;
  P:=TBisProvider.Create(nil);
  try
    P.UseWaitCursor:=false;
    P.ProviderName:='TRANSFORM_PHONE';
    with P.Params do begin
      AddInvisible('IN_PHONE').Value:=Phone;
      AddInvisible('OUT_PHONE',ptOutput);
    end;
    P.Execute;
    if P.Success then
      Result:=P.ParamByName('OUT_PHONE').Value;
  finally
    P.Free;
  end;
end;

procedure TBisTaxiPhoneChannel.ApplyCallResult;
var
  P: TBisProvider;
begin
  if not VarIsNull(FCallId) and
     (Assigned(FFrame) and FFrame.CallResultQueried) and
     (FFrame.Incoming) then begin
    P:=TBisProvider.Create(nil);
    try
      P.UseWaitCursor:=false;
      P.ProviderName:='APPLY_CALL_RESULT';
      with P.Params do begin
        AddInvisible('CALL_ID').Value:=FCallId;
        AddInvisible('CALL_RESULT_ID').Value:=FFrame.CallResultId;
      end;
      P.Execute;
      if P.Success then
        FCallId:=Null;
    finally
      P.Free;
    end;
  end;
end;

function TBisTaxiPhoneChannel.TryServerActive: Boolean;
var
  First: Integer;
  MaxPort: Integer;
begin
  Result:=false;
  if not FServer.Active and Assigned(FChannels) then begin
    Core.ExceptNotifier.IngnoreExceptions.Add(EIdException);
    try
      First:=FPort;
      Inc(First);
      First:=FChannels.MaxDataPort(First);
      MaxPort:=POWER_2;
      while First<MaxPort do begin
        if not UDPPortExists(FIP,First) then begin
          try
            FServer.Bindings.Clear;
            with FServer.Bindings.Add do begin
              IP:=FIP;
              Port:=First;
            end;
            FServer.Active:=true;
            Result:=true;
            break;
          except
            on E: Exception do begin
              FServer.Active:=false;
              Inc(First);
            end;
          end;
        end else
          Inc(First);
      end;
    finally
      Core.ExceptNotifier.IngnoreExceptions.Remove(EIdException);
    end;
  end;
end;

function TBisTaxiPhoneChannel.DialRequest(Request: TBisTaxiPhoneRequest): Boolean;

  procedure SendResponse(AMessage: String; AResponseType: TBisTaxiPhoneResponseType);
  var
    Response: TBisTaxiPhoneResponse;
  begin
   { Response:=TBisTaxiPhoneResponse.Create(mdOutgoing,SEventResult);
    with Response do begin
      AddSessionId(FRemoteSessionId);
      AddRemoteSessionId(Core.SessionId);
      AddChannelId(FId);
      AddRequestName(Request.Name);
      AddSequence(Request.Sequence);
      AddResponseType(AResponseType);
      AddMessage(AMessage);
    end;
    Request.Responses.Add(Response);
    SendEvent(Response.AsString); }
  end;

var
  Message: String;
  ResponseType: TBisTaxiPhoneResponseType;
begin
  Result:=false;
  if Assigned(Request) and Assigned(Core) then begin
    Message:='';
    ResponseType:=rtUnknown;
    try
      try
        FRemoteSessionId:=Request.RemoteSessionId;
        FRemoteDataPort:=Request.DataPort;
        FRemoteFormat:=FChannels.FForm.FDrivers.FindFormat('',Request.FormatTag,Request.Channels,
                                                           Request.SamplesPerSec,Request.BitsPerSample);
        FRemoteDataSize:=Request.DataSize;
        if GetRemoteEventParams(FRemoteSessionId) and Assigned(FRemoteFormat) then begin
          ResponseType:=rtCancel;
          if FChannels.CanAdd then begin
            Result:=GetCallInfo(Request.CallId);
            if Result then begin
              FState:=csRinning;
              FFrame.Flashing:=true;
              FChannels.SetFrameProps(Self);
              FChannels.StartIncomingMusic;
              FChannels.FForm.Ring(Self);
              ResponseType:=rtOK;
            end;
          end;
        end;
      except
        On E: Exception do begin
          Message:=E.Message;
          ResponseType:=rtError;
        end;
      end;
    finally
      SendResponse(Message,ResponseType);


      if ResponseType=rtOK then
        if Assigned(FChannels) and Assigned(FChannels.FForm) then begin
          with FChannels.FForm do begin
            TimerAutoAnswer.Enabled:=false;
            FLastDialChannel:=nil;
            if CheckBoxAutoAnswer.Checked then begin
              FLastDialChannel:=Self;
              TimerAutoAnswer.Interval:=UpDownAutoAnswer.Position*1000;
              TimerAutoAnswer.Enabled:=true;
            end;
          end;
        end;

    end;
  end;
end;

function TBisTaxiPhoneChannel.AnswerRequest(Request: TBisTaxiPhoneRequest): Boolean;

  procedure SendResponse(AMessage: String; AResponseType: TBisTaxiPhoneResponseType);
  var
    Response: TBisTaxiPhoneResponse;
  begin
   { Response:=TBisTaxiPhoneResponse.Create(mdOutgoing,SEventResult);
    with Response do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(FId);
      AddRequestName(Request.Name);
      AddSequence(Request.Sequence);
      AddResponseType(AResponseType);
      AddMessage(AMessage);
    end;
    Request.Responses.Add(Response);
    SendEvent(Response.AsString);  }
  end;

var
  Message: String;
  ResponseType: TBisTaxiPhoneResponseType;
begin
  Result:=false;
  if Assigned(Request) and Assigned(FChannels) and Assigned(Core) then begin
    Message:='';
    ResponseType:=rtUnknown;
    try
      try
        ResponseType:=rtCancel;
        FRemoteDataPort:=Request.DataPort;
        FRemoteFormat:=FChannels.FForm.FDrivers.FindFormat('',Request.FormatTag,Request.Channels,
                                                           Request.SamplesPerSec,Request.BitsPerSample);
        FRemoteDataSize:=Request.DataSize;
        if Assigned(FRemoteFormat) then begin
          FState:=csProcessing;
          FChannels.ExcludeHold(Self);
          FProcessExists:=true;
          FFrame.StartTime:=Now;
          FFrame.TimerTime.Enabled:=true;
          FFrame.Active:=true;
          StopSendThread(false);
          FChannels.StopMusic;
          FChannels.StartVoicePlayer(Self);
          FChannels.StartRecorder(Self);
          StartSendThread;
          ResponseType:=rtOK;
        end;
        Result:=true;
      except
        On E: Exception do begin
          Message:=E.Message;
          ResponseType:=rtError;
        end;
      end;
    finally
      SendResponse(Message,ResponseType);
    end;
  end;
end;

function TBisTaxiPhoneChannel.HangupRequest(Request: TBisTaxiPhoneRequest): Boolean;

  procedure SendResponse(AMessage: String; AResponseType: TBisTaxiPhoneResponseType);
  var
    Response: TBisTaxiPhoneResponse;
  begin
   { Response:=TBisTaxiPhoneResponse.Create(mdOutgoing,SEventResult);
    with Response do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(FId);
      AddRequestName(Request.Name);
      AddSequence(Request.Sequence);
      AddResponseType(AResponseType);
      AddMessage(AMessage);
    end;
    Request.Responses.Add(Response);
    SendEvent(Response.AsString); }
  end;

var
  Message: String;
  ResponseType: TBisTaxiPhoneResponseType;
begin
  Result:=false;
  if Assigned(Request) and Assigned(FChannels) and Assigned(Core) then begin
    Message:='';
    ResponseType:=rtUnknown;
    try
      try
        FState:=csFinished;
        FFrame.Finished:=true;
        StopSendThread(false);
        FChannels.StopMusic;
        if not FChannels.ExistsActive(Self) then begin
          FChannels.StopVoicePlayer;
          FChannels.StopRecorder;
        end;
        ResponseType:=rtOK;
        Result:=true;
      except
        On E: Exception do begin
          Message:=E.Message;
          ResponseType:=rtError;
        end;
      end;
    finally
      SendResponse(Message,ResponseType);
    end;
  end;
end;

function TBisTaxiPhoneChannel.DialResponse(Response: TBisTaxiPhoneResponse; var FreeChannel: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(Response) and Assigned(FChannels) and (FState=csNothing) then begin
    case Response.ResponseType of
      rtUnknown: ;
      rtOK: begin
        FState:=csRinning;
        FFrame.Flashing:=true;
        FChannels.StartOutgoingMusic;
        if not FChannels.ExistsActive(Self) then begin
          FChannels.StopVoicePlayer;
          FChannels.StopRecorder;
        end;
        Result:=true;
      end;
      rtCancel: begin
        FState:=csFinished;
        FFrame.Disable;
        Result:=true;
      end;
      rtError: ;
    end;
  end;
end;

function TBisTaxiPhoneChannel.AnswerResponse(Response: TBisTaxiPhoneResponse; var FreeChannel: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(Response) and Assigned(FChannels) and (FState=csRinning) then begin
    case Response.ResponseType of
      rtUnknown: ;
      rtOK: begin
        FState:=csProcessing;
        FProcessExists:=true;
        FFrame.StartTime:=Now;
        FFrame.TimerTime.Enabled:=true;
        FFrame.Active:=true;
        StopSendThread(false);
        FChannels.StopMusic;
        FChannels.StartVoicePlayer(Self);
        FChannels.StartRecorder(Self);
        StartSendThread;
        Result:=true;
      end;
      rtCancel: ;
      rtError: ;
    end;
  end;
end;

function TBisTaxiPhoneChannel.HangupResponse(Response: TBisTaxiPhoneResponse; var FreeChannel: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(Response) and Assigned(FChannels) then begin
    case Response.ResponseType of
      rtUnknown: ;
      rtOK: begin
        FState:=csFinished;
        FFrame.Finished:=true;
        StopSendThread(false);
        FChannels.StopMusic;
        if not FChannels.ExistsActive(Self) then begin
          FChannels.StopVoicePlayer;
          FChannels.StopRecorder;
        end;
        ApplyCallResult;
        FreeChannel:=true;
        Result:=true;
      end;
      rtCancel: ;
      rtError: ;
    end;
  end;
end;

function TBisTaxiPhoneChannel.HoldResponse(Response: TBisTaxiPhoneResponse; var FreeChannel: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(Response) then begin
    case Response.ResponseType of
      rtUnknown: ;
      rtOK: begin
        FState:=csHolding;
        FFrame.Active:=false;
        StopSendThread(false);
        FChannels.StopMusic;
        if not FChannels.ExistsActive(Self) then begin
          FChannels.StopVoicePlayer;
          FChannels.StopRecorder;
        end;
        Result:=true;
      end;
      rtCancel: ;
      rtError: ;
    end;
  end;
end;

function TBisTaxiPhoneChannel.UnHoldResponse(Response: TBisTaxiPhoneResponse; var FreeChannel: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(Response) then begin
    case Response.ResponseType of
      rtUnknown: ;
      rtOK: begin
        FState:=csProcessing;
        FFrame.Active:=true;
        StopSendThread(false);
        FChannels.StopMusic;
        FChannels.StartVoicePlayer(Self);
        FChannels.StartRecorder(Self);
        StartSendThread;
        Result:=true;
      end;
      rtCancel: ;
      rtError: ;
    end;
  end;
end;

procedure TBisTaxiPhoneChannel.Dial(Acceptor: String; AcceptorType: TBisTaxiPhoneAcceptorType);
var
  Request: TBisTaxiPhoneRequest;
  Format: TWaveAcmDriverFormat;
begin
  Format:=FChannels.FForm.FFormat;
  if Assigned(Format) and (FState=csNothing) then begin
    FRemoteSessionId:=GetServerSessionId;
    if not VarIsNull(FRemoteSessionId) then begin
      FCallId:=GetUniqueID;
      if GetRemoteEventParams(FRemoteSessionId) and TryServerActive then begin
      {  Request:=TBisTaxiPhoneRequest.Create(mdOutgoing,SEventDial);
        with Request do begin
          AddSessionId(FRemoteSessionId);
          AddRemoteSessionId(Core.SessionId);
          AddChannelId(FId);
          AddSequence(FRequests.NextSequence);
          AddDataPort(Self.DataPort);
          with Format.WaveFormat^ do begin
            AddFormatTag(wFormatTag);
            AddChannels(nChannels);
            AddSamplesPerSec(nSamplesPerSec);
            AddBitsPerSample(wBitsPerSample);
          end;
          AddCallId(FCallId);
          AddCallerId(Core.AccountId);
          AddCallerPhone(Null);
          AddDataSize(FDataSize);
          AddAcceptor(Acceptor);
          AddAcceptorType(AcceptorType);
        end;
        FRequests.Add(Request);
        SendMessage(Request,true); }
      end;
    end else begin
      FState:=csFinished;
      FFrame.Disable;
    end;
  end;
end;

procedure TBisTaxiPhoneChannel.Answer;
var
  Request: TBisTaxiPhoneRequest;
  Format: TWaveAcmDriverFormat;
begin
  Format:=FChannels.FForm.FFormat;
  if Assigned(Format) and (FState=csRinning) and TryServerActive then begin
   { Request:=TBisTaxiPhoneRequest.Create(mdOutgoing,SEventAnswer);
    with Request do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(FId);
      AddSequence(FRequests.NextSequence);
      AddDataPort(Self.DataPort);
      with Format.WaveFormat^ do begin
        AddFormatTag(wFormatTag);
        AddChannels(nChannels);
        AddSamplesPerSec(nSamplesPerSec);
        AddBitsPerSample(wBitsPerSample);
      end;
      AddDataSize(FDataSize);
    end;
    FRequests.Add(Request);
    SendMessage(Request,true); }
  end;
end;

procedure TBisTaxiPhoneChannel.Hangup;
var
  Request: TBisTaxiPhoneRequest;
begin
  if Assigned(FFrame) and (FState in [csRinning,csProcessing,csHolding]) then begin
  {  Request:=TBisTaxiPhoneRequest.Create(mdOutgoing,SEventHangup);
    with Request do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(FId);
      AddSequence(FRequests.NextSequence);
      AddCallResultId(FFrame.CallResultId);
    end;
    FRequests.Add(Request);
    SendMessage(Request,true);}
  end;
end;

procedure TBisTaxiPhoneChannel.Hold;
var
  Request: TBisTaxiPhoneRequest;
begin
  if FState in [csProcessing] then begin
   { Request:=TBisTaxiPhoneRequest.Create(mdOutgoing,SEventHold);
    with Request do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(FId);
      AddSequence(FRequests.NextSequence);
    end;
    FRequests.Add(Request);
    SendMessage(Request,true);   }
  end;
end;

procedure TBisTaxiPhoneChannel.UnHold;
var
  Request: TBisTaxiPhoneRequest;
begin
  if FState in [csHolding] then begin
  {  Request:=TBisTaxiPhoneRequest.Create(mdOutgoing,SEventUnHold);
    with Request do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(FId);
      AddSequence(FRequests.NextSequence);
    end;
    FRequests.Add(Request);
    SendMessage(Request,true); }
  end;
end;

{ TBisTaxiPhoneChannels }

constructor TBisTaxiPhoneChannels.Create(Form: TBisTaxiPhoneForm);
begin
  inherited Create(true);
  FForm:=Form;

  with Core.Events do begin
  {  FEventResult:=Add(SEventResult,ResultHandler,false);
    FEventDial:=Add(SEventDial,DialHandler,false);
    FEventAnswer:=Add(SEventAnswer,AnswerHandler,false);
    FEventHangup:=Add(SEventHangup,HangupHandler,false);  }
  end;
end;

destructor TBisTaxiPhoneChannels.Destroy;
begin
  with Core.Events do begin
  {  Remove(FEventHangup);
    Remove(FEventAnswer);
    Remove(FEventDial);
    Remove(FEventResult); }
  end;
  FForm:=nil;
  inherited Destroy;
end;

function TBisTaxiPhoneChannels.Find(Id: String): TBisTaxiPhoneChannel;
var
  i: Integer;
  Item: TBisTaxiPhoneChannel;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Id,Item.FId) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisTaxiPhoneChannels.GetItem(Index: Integer): TBisTaxiPhoneChannel;
begin
  Result:=TBisTaxiPhoneChannel(inherited Items[Index]);
end;

function TBisTaxiPhoneChannels.GetNum: Integer;
begin
  if FLastNum>=99999 then
    FLastNum:=0;
  Inc(FLastNum);
  Result:=FLastNum;
end;

procedure TBisTaxiPhoneChannels.ExcludeHold(Channel: TBisTaxiPhoneChannel);
var
  i: Integer;
  Item: TBisTaxiPhoneChannel;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if (Item<>Channel) then begin
      Item.Hold;
    end;
  end;
end;

function TBisTaxiPhoneChannels.ExistsActive(Channel: TBisTaxiPhoneChannel): Boolean;
var
  i: Integer;
  Item: TBisTaxiPhoneChannel;
begin
  Result:=false;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if (Item<>Channel) then begin
      if Item.FState=csProcessing then begin
        Result:=true;
        exit;
      end;
    end;
  end;
end;

function TBisTaxiPhoneChannels.GetCurrent: TBisTaxiPhoneChannel;
var
  Channel: TBisTaxiPhoneChannel;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Channel:=Items[i];
    if Channel.FState=csProcessing then begin
      Result:=Channel;
      exit;
    end;
  end;
end;

function TBisTaxiPhoneChannels.GetFrameTop(AFrame: TBisTaxiPhoneFrame): Integer;
var
  i: Integer;
  Channel: TBisTaxiPhoneChannel;
begin
  Result:=FForm.ComboBoxAcceptorType.Top+FForm.ComboBoxAcceptorType.Height+10;
  for i:=0 to Count-1 do begin
    Channel:=Items[i];
    if Channel.FFrame=AFrame then
      Break;
    Result:=Result+Channel.FFrame.Height+5;
  end;
end;

procedure TBisTaxiPhoneChannels.Remove(Channel: TBisTaxiPhoneChannel);
begin
  inherited Remove(Channel);
  ReOrderFrames;
  FForm.UpdateButtonDial;
  FForm.UpdateHeight;
  FForm.UpdateChannel(nil);
  if FFreeOnLast then
    FForm.Close; 
end;

procedure TBisTaxiPhoneChannels.ReOrderFrames;
var
  i: Integer;
  Channel: TBisTaxiPhoneChannel;
begin
  for i:=0 to Count-1 do begin
    Channel:=Items[i];
    Channel.FFrame.Top:=GetFrameTop(Channel.FFrame);
  end;
end;

function TBisTaxiPhoneChannels.Height: Integer;
var
  i: Integer;
  Channel: TBisTaxiPhoneChannel;
begin
  Result:=0;
  for i:=0 to Count-1 do begin
    Channel:=Items[i];
    Result:=Result+Channel.FFrame.Height+5;
  end;
end;

procedure TBisTaxiPhoneChannels.SetFrameProps(Channel: TBisTaxiPhoneChannel);
begin
  if Assigned(Channel) and Assigned(FForm) then begin
    with Channel do begin
      FFrame.Parent:=FForm.TabSheetPhone;
      FFrame.Num:=GetNum;
      FFrame.Top:=GetFrameTop(FFrame);
      FFrame.Left:=FForm.ComboBoxAcceptorType.Left;
      FFrame.Width:=FForm.TabSheetPhone.ClientWidth-FForm.ComboBoxAcceptorType.Left-5;
      FFrame.AutoHeight;
      FFrame.Anchors:=[akLeft,akTop,akRight];
    end;
    FForm.UpdateButtonDial;
    FForm.UpdateHeight;
  end;
end;

function TBisTaxiPhoneChannels.MaxDataPort(Default: Integer): Integer;
var
  i: Integer;
  Item: TBisTaxiPhoneChannel;
begin
  Result:=Default;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.DataPort>Default then
      Result:=Item.DataPort;
  end;
end;

function TBisTaxiPhoneChannels.ActiveCount: Integer;
var
  i: Integer;
  Item: TBisTaxiPhoneChannel;
begin
  Result:=0;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.FState in [csRinning,csProcessing,csHolding] then
      Inc(Result);
  end;
end;

function TBisTaxiPhoneChannels.CanAdd: Boolean;
var
  i: Integer;
  Item: TBisTaxiPhoneChannel;
begin
  Result:=Assigned(FForm) and not FForm.ButtonBreak.Down;
  if Result then begin
    Result:=FForm.UpDownMaxChannels.Position>ActiveCount;
    if Result then begin
      for i:=0 to Count-1 do begin
        Item:=Items[i];
        if Item.FFrame.InQueryCallResultId then begin
          Result:=false;
          exit;
        end;
      end;
    end;
  end;
end;

function TBisTaxiPhoneChannels.CanClose: Boolean;
var
  i: Integer;
begin
  Result:=Count=0;
  if not Result and not FFreeOnLast then begin
    FFreeOnLast:=true;
    for i:=Count-1 downto 0 do begin
      Items[i].Close;
    end;
  end;
end;

function TBisTaxiPhoneChannels.Add(Id: String; Incoming: Boolean): TBisTaxiPhoneChannel;
begin
  Result:=Find(Id);
  if not Assigned(Result) then begin
    Result:=TBisTaxiPhoneChannel.Create(Self);
    Result.FId:=Id;
    Result.FIP:=FIP;
    Result.FPort:=FPort;
    Result.FUseCompressor:=FUseCompressor;
    Result.FCompressorLevel:=FCompressorLevel;
    Result.FUseCrypter:=FUseCrypter;
    Result.FCrypterKey:=FCrypterKey;
    Result.FCrypterAlgorithm:=FCrypterAlgorithm;
    Result.FCrypterMode:=FCrypterMode;
    Result.FFrame.Incoming:=Incoming;
    inherited Add(Result);
  end;
end;

function TBisTaxiPhoneChannels.AddIncoming(Request: TBisTaxiPhoneRequest): TBisTaxiPhoneChannel;
begin
  Result:=nil;
  if Assigned(Request) then begin
    Result:=Add(Request.ChannelId,true);
    if Assigned(Result) then begin
      Result.FCallId:=Request.CallId;
      Result.FRequests.Add(Request);
    end;
  end;
end;

function TBisTaxiPhoneChannels.AddOutgoing: TBisTaxiPhoneChannel;
begin
  Result:=Add(GetUniqueID,false);
end;

procedure TBisTaxiPhoneChannels.StartIncomingMusic;
begin
  if Assigned(FForm) then begin
    if not ExistsActive(nil) then begin
      with FForm do begin
        if FIncomingStream.Size>0 then begin
          FIncomingStream.Position:=0;
          FMusicPlayer.PlayStream(FIncomingStream);
        end;
      end;
    end;
  end;
end;

procedure TBisTaxiPhoneChannels.StartOutgoingMusic;
begin
  if Assigned(FForm) then begin
    with FForm do begin
      if FOutgoingStream.Size>0 then begin
        FOutgoingStream.Position:=0;
        FMusicPlayer.PlayStream(FOutgoingStream);
      end;
    end;
  end;
end;

procedure TBisTaxiPhoneChannels.StartVoicePlayer(Channel: TBisTaxiPhoneChannel);
begin
  if Assigned(FForm) then
    FForm.StartVoicePlayer(Channel);
end;

procedure TBisTaxiPhoneChannels.StartRecorder(Channel: TBisTaxiPhoneChannel);
begin
  if Assigned(FForm) then
    FForm.StartRecorder(Channel);
end;

procedure TBisTaxiPhoneChannels.StopMusic;
begin
  if Assigned(FForm) then begin
    FForm.FMusicPlayer.Stop;
    FForm.FMusicPlayer.WaitForStop;
  end;
end;

procedure TBisTaxiPhoneChannels.StopRecorder;
begin
  if Assigned(FForm) then begin
    FForm.FRecorder.Active:=false;
    FForm.FRecorder.WaitForStop;
  end;
end;

procedure TBisTaxiPhoneChannels.StopVoicePlayer;
begin
  if Assigned(FForm) then begin
    FForm.FVoicePlayer.Active:=false;
    FForm.FVoicePlayer.WaitForStop;
  end;
end;

function TBisTaxiPhoneChannels.ResultHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Response: TBisTaxiPhoneResponse;
  Request: TBisTaxiPhoneRequest;
  Channel: TBisTaxiPhoneChannel;
  FreeChannel: Boolean;
begin
  Result:=false;
  Response:=TBisTaxiPhoneResponse.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Response) then begin
    Channel:=Find(Response.ChannelId);
    if Assigned(Channel) then begin
      Request:=Channel.FRequests.Find(Response);
      if Assigned(Request) then begin
        Channel.FWaits.RemoveBy(Request);
        Request.Responses.Add(Response);

        FreeChannel:=false;

      {  if AnsiSameText(Response.RequestName,SEventDial) then
          Result:=Channel.DialResponse(Response,FreeChannel);

        if AnsiSameText(Response.RequestName,SEventAnswer) then
          Result:=Channel.AnswerResponse(Response,FreeChannel);

        if AnsiSameText(Response.RequestName,SEventHangup) then
          Result:=Channel.HangupResponse(Response,FreeChannel);

        if AnsiSameText(Response.RequestName,SEventHold) then
          Result:=Channel.HoldResponse(Response,FreeChannel);

        if AnsiSameText(Response.RequestName,SEventUnHold) then
          Result:=Channel.UnHoldResponse(Response,FreeChannel); }

        if not Result then
          Request.Responses.Remove(Response);

        if FreeChannel then begin
          Remove(Channel);
        end;

      end else
        Response.Free;
    end else
      Response.Free;
  end;
end;

function TBisTaxiPhoneChannels.DialHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Request: TBisTaxiPhoneRequest;
  Channel: TBisTaxiPhoneChannel;
begin
  Result:=false;
  Request:=TBisTaxiPhoneRequest.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Request) then begin
    Channel:=AddIncoming(Request);
    if Assigned(Channel) then begin
      Result:=Channel.DialRequest(Request);
      if not Result then
        Remove(Channel);
    end else
      Request.Free;
  end;
end;

function TBisTaxiPhoneChannels.AnswerHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Request: TBisTaxiPhoneRequest;
  Channel: TBisTaxiPhoneChannel;
begin
  Result:=false;
  Request:=TBisTaxiPhoneRequest.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Request) then begin
    Channel:=Find(Request.ChannelId);
    if Assigned(Channel) then begin
      Channel.FRequests.Add(Request);
      Result:=Channel.AnswerRequest(Request);
    end else
      Request.Free;
  end;
end;

function TBisTaxiPhoneChannels.HangupHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Request: TBisTaxiPhoneRequest;
  Channel: TBisTaxiPhoneChannel;
begin
  Result:=false;
  Request:=TBisTaxiPhoneRequest.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Request) then begin
    Channel:=Find(Request.ChannelId);
    if Assigned(Channel) then begin
      Channel.FRequests.Add(Request);
      Result:=Channel.HangupRequest(Request);
      if not Channel.FProcessExists then
        Remove(Channel);
    end else
      Request.Free;
  end;
end;

{ TBisTaxiPhoneForm }

constructor TBisTaxiPhoneForm.Create(AOwner: TComponent);
var
  Buffer: String;
  DriverName, FormatName: String;
  Channels: Integer;
  SamplesPerSec: Integer;
  BitsPerSample: Integer;
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  SizesStored:=true;

  FVoicePlayerLock:=TCriticalSection.Create;
  FRecorderLock:=TCriticalSection.Create;

  TrackBarTransparent.Position:=AlphaBlendValue;

{  FIncomingStream:=TMemoryStream.Create;
  if Core.LocalBase.ParamExists(SParamIncomingMusic) then
    Core.LocalBase.ReadParam(SParamIncomingMusic,FIncomingStream);

  FOutgoingStream:=TMemoryStream.Create;
  if Core.LocalBase.ParamExists(SParamOutgoingMusic) then
    Core.LocalBase.ReadParam(SParamOutgoingMusic,FOutgoingStream);

  FChannels:=TBisTaxiPhoneChannels.Create(Self);
  FChannels.FWaitRetryCount:=0;
  FChannels.FWaitTimeout:=3000;   
  if Core.LocalBase.ReadParam(SParamRequestRetryCount,Buffer) then
     FChannels.FWaitRetryCount:=StrToIntDef(Buffer,FChannels.FWaitRetryCount);
  if Core.LocalBase.ReadParam(SParamRequestTimeout,Buffer) then
     FChannels.FWaitTimeout:=StrToIntDef(Buffer,FChannels.FWaitTimeout);

  FDrivers:=TBisACMDrivers.Create;
  DriverName:='';
  FormatName:='CCITT A-Law';
//  FormatName:='GSM 6.10';
  Channels:=1;
  SamplesPerSec:=8000;
  BitsPerSample:=8;
//  BitsPerSample:=0;
  if Core.LocalBase.ReadParam(SParamAudioDriverName,Buffer) then DriverName:=Buffer;
  if Core.LocalBase.ReadParam(SParamAudioFormatName,Buffer) then FormatName:=Buffer;
  if Core.LocalBase.ReadParam(SParamAudioChannels,Buffer) then TryStrToInt(Buffer,Channels);
  if Core.LocalBase.ReadParam(SParamAudioSamplesPerSec,Buffer) then TryStrToInt(Buffer,SamplesPerSec);
  if Core.LocalBase.ReadParam(SParamAudioBitsPerSample,Buffer) then TryStrToInt(Buffer,BitsPerSample);
  FFormat:=FDrivers.FindFormat(DriverName,FormatName,Channels,SamplesPerSec,BitsPerSample);  }

  EditFormat.Text:=GetFormatDescription(FFormat);

  FRecorderStream:=TMemoryStream.Create;

  FRecorder:=TBisLiveAudioRecorder.Create(Self);
  FRecorder.DeviceID:=0;
  FRecorder.Async:=true;
  FRecorder.PCMFormat:=nonePCM;
  FRecorder.OnFormat:=RecorderFormat;
  FRecorder.OnData:=RecorderData;
  FRecorder.OnActivate:=RecorderActivate;
  FRecorder.OnDeactivate:=RecorderDeactivate;

//  ComboBoxRecorderDevice.Items.Add(FRecorder.GetDeviceNameByID(WAVE_MAPPER));
  FRecorder.FillDevices(ComboBoxRecorderDevice.Items);
  if ComboBoxRecorderDevice.Items.Count>0 then
    ComboBoxRecorderDevice.ItemIndex:=0;

  FRecorderMixer:=TBisAudioMixer.Create(nil);
  FRecorderMixer.MixerName:=FRecorder.DeviceName;

  FVoicePlayerStream:=TMemoryStream.Create;

  FVoicePlayer:=TBisLiveAudioPlayer.Create(nil);
  FVoicePlayer.DeviceID:=0;
  FVoicePlayer.PCMFormat:=nonePCM;
  FVoicePlayer.PCMFormat:=Mono16bit8000Hz;
  FVoicePlayer.BufferInternally:=true;
//  FVoicePlayer.BufferInternally:=false;
  FVoicePlayer.Async:=true;
//FVoicePlayer.OnDataPtr:=VoicePlayerDataPtr;
  FVoicePlayer.OnData:=VoicePlayerData;
  FVoicePlayer.OnActivate:=VoicePlayerActivate;
  FVoicePlayer.OnDeactivate:=VoicePlayerDeactivate;

//  ComboBoxPlayerDevice.Items.Add(FPlayer.GetDeviceNameByID(WAVE_MAPPER));
  FVoicePlayer.FillDevices(ComboBoxPlayerDevice.Items);
  if ComboBoxPlayerDevice.Items.Count>0 then
    ComboBoxPlayerDevice.ItemIndex:=0;

  FMusicPlayer:=TBisStockAudioPlayer.Create(nil);
  FMusicPlayer.DeviceID:=0;
  FMusicPlayer.Async:=true;

  FPlayerMixer:=TBisAudioMixer.Create(nil);
  FPlayerMixer.MixerName:=FVoicePlayer.DeviceName;

  PageControl.ActivePage:=TabSheetPhone;

  FAccountId:=Null;
  FSessionId:=Null;
  FSelectPhoneType:=sptNone;
  FOldAcceptorType:=atPhone;

  ComboBoxAcceptorType.ItemIndex:=Integer(atPhone);
  ComboBoxAcceptorTypeChange(nil);

  UpdateButtonDial;

  FSMicEnabled:='ќтключить микрофон';
  FSMicDisabled:='¬ключить микрофон';
  FSBreakEnabled:='”йти на перерыв';
  FSBreakDisabled:='¬ыйти с перерыва';

end;

destructor TBisTaxiPhoneForm.Destroy;
begin
//  FChannel:=nil;
  FPlayerMixerLine:=nil;
  FPlayerMixer.Free;
  FMusicPlayer.Stop;
  FMusicPlayer.WaitForStop;
  FMusicPlayer.Free;
  FVoicePlayer.Active:=false;
  FVoicePlayer.WaitForStop;
  FVoicePlayer.Free;
  FVoicePlayerStream.Free;
  FRecorderMixerLine:=nil;
  FRecorderMixer.Free;
  FRecorder.Active:=false;
  FRecorder.WaitForStop;
  FRecorder.Free;
  FRecorderStream.Free;
  FDrivers.Free;
  FChannels.Free;
  FOutgoingStream.Free;
  FIncomingStream.Free;
  FVoicePlayerLock.Free;
  inherited Destroy;
end;

procedure TBisTaxiPhoneForm.ReadProfileParams;
begin
  inherited ReadProfileParams;
  ComboBoxPlayerDevice.ItemIndex:=ProfileRead('ComboBoxPlayerDevice.ItemIndex',ComboBoxPlayerDevice.ItemIndex);
  ComboBoxPlayerDeviceChange(nil);
  ComboBoxRecorderDevice.ItemIndex:=ProfileRead('ComboBoxRecorderDevice.ItemIndex',ComboBoxRecorderDevice.ItemIndex);
  ComboBoxRecorderDeviceChange(nil);
  TrackBarPlayer.Position:=ProfileRead('TrackBarPlayer.Position',TrackBarPlayer.Position);
  TrackBarPlayerChange(nil);
  TrackBarRecorder.Position:=ProfileRead('TrackBarRecorder.Position',TrackBarRecorder.Position);
  TrackBarRecorderChange(nil);
  TrackBarTransparent.Position:=ProfileRead('TrackBarTransparent.Position',TrackBarTransparent.Position);
  TrackBarTransparentChange(nil);
  UpDownMaxChannels.Position:=ProfileRead('UpDownMaxChannels.Position',UpDownMaxChannels.Position);
  UpDownBuffer.Position:=ProfileRead('UpDownBuffer.Position',UpDownBuffer.Position);
  CheckBoxAutoAnswer.Checked:=ProfileRead('CheckBoxAutoAnswer.Checked',CheckBoxAutoAnswer.Checked);
  UpDownAutoAnswer.Position:=ProfileRead('UpDownAutoAnswer.Position',UpDownAutoAnswer.Position);
end;

procedure TBisTaxiPhoneForm.WriteProfileParams;
begin
  inherited WriteProfileParams;
  ProfileWrite('ComboBoxPlayerDevice.ItemIndex',ComboBoxPlayerDevice.ItemIndex);
  ProfileWrite('ComboBoxRecorderDevice.ItemIndex',ComboBoxRecorderDevice.ItemIndex);
  ProfileWrite('TrackBarPlayer.Position',TrackBarPlayer.Position);
  ProfileWrite('TrackBarRecorder.Position',TrackBarRecorder.Position);
  ProfileWrite('TrackBarTransparent.Position',TrackBarTransparent.Position);
  ProfileWrite('UpDownMaxChannels.Position',UpDownMaxChannels.Position);
  ProfileWrite('UpDownBuffer.Position',UpDownBuffer.Position);
  ProfileWrite('CheckBoxAutoAnswer.Checked',CheckBoxAutoAnswer.Checked);
  ProfileWrite('UpDownAutoAnswer.Position',UpDownAutoAnswer.Position);
end;

function TBisTaxiPhoneForm.GetAcceptorType: TBisTaxiPhoneAcceptorType;
begin
  Result:=TBisTaxiPhoneAcceptorType(ComboBoxAcceptorType.ItemIndex);
end;

procedure TBisTaxiPhoneForm.SetAcceptorType(Value: TBisTaxiPhoneAcceptorType);
begin
  ComboBoxAcceptorType.ItemIndex:=Integer(Value);
end;

function TBisTaxiPhoneForm.GetAcceptor: String;
begin
  Result:='';
  case GetAcceptorType of
    atPhone: Result:=Trim(FPhone);
    atAccount: Result:=VarToStrDef(FAccountId,'');
    atComputer: Result:=Trim(FComputer);
    atSession: Result:=VarToStrDef(FSessionId,'');
  end;
end;

procedure TBisTaxiPhoneForm.SetAcceptor(Value: String);
begin
  case GetAcceptorType of
    atPhone: begin
      FPhone:=Trim(Value);
      ComboBoxAcceptor.Text:=FPhone;
    end;
    atAccount: FAccountId:=iff(Trim(Value)<>'',Value,Null);
    atComputer: FComputer:=Trim(Value);
    atSession: FSessionId:=iff(Trim(Value)<>'',Value,Null);
  end;
end;

function TBisTaxiPhoneForm.GetFormatDescription(Format: TWaveACMDriverFormat): String;
const
  Channels: array[1..2] of String = ('ћоно', '—терео');
begin
  Result:='Ќе поддерживаетс€';
  if Assigned(Format) and Assigned(Format.WaveFormat) then begin
    with Format.WaveFormat^ do begin
      if wBitsPerSample <> 0 then
        if nChannels in [1..2] then
          Result := FormatEx('%.3f к√ц; %d бит; %s', [nSamplesPerSec / 1000, wBitsPerSample, Channels[nChannels]])
        else
          Result := FormatEx('%.3f к√ц; %d бит; %d канала(ов)', [nSamplesPerSec / 1000, wBitsPerSample, nChannels])
      else
        if nChannels in [1..2] then
          Result := FormatEx('%.3f к√ц; %s', [nSamplesPerSec / 1000, Channels[nChannels]])
        else
          Result := FormatEx('%.3f к√ц; %d канала(ов)', [nSamplesPerSec / 1000, nChannels]);
      Result:=FormatEx('%s: %s (%s)',[Format.Name,Result,Format.Driver.LongName]);
    end;
  end;
end;

procedure TBisTaxiPhoneForm.EditMaxChannelsChange(Sender: TObject);
begin
  UpdateButtonDial;
end;

procedure TBisTaxiPhoneForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ConnectionUpdate(false);
end;

procedure TBisTaxiPhoneForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=FChannels.CanClose;
end;

procedure TBisTaxiPhoneForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Index: Integer;
begin
  if (ssCtrl in Shift) then begin
    if Char(Key) in ['1'..'2'] then begin
      Index:=StrToIntDef(Char(Key),1)-1;
      if TabSet.Tabs.Count>Index then begin
        if TabSet.TabIndex<>Index then
          TabSet.TabIndex:=Index;
      end;
    end;
  end;
end;

procedure TBisTaxiPhoneForm.Init;
begin
  inherited Init;
  FOldPlayerDeviceCaption:=LabelPlayerDevice.Caption;
  FOldRecorderDeviceCaption:=LabelRecorderDevice.Caption;
  UpdateMicOffButton;
  UpdateBreakButton;
end;

procedure TBisTaxiPhoneForm.StartVoicePlayer(Channel: TBisTaxiPhoneChannel);
begin
  if Assigned(Channel) then begin
    FVoicePlayerStream.Clear;
    FVoicePlayerBufferSize:=Cardinal(UpDownBuffer.Position);
    FVoicePlayer.BufferLength:=Channel.FPacketTime;
    FVoicePlayer.BufferCount:=UpDownBufferCount.Position;
{    FVoicePlayerBufferSize:=100;
    FVoicePlayer.BufferLength:=1000;
    FVoicePlayer.BufferCount:=20;}

    FVoicePlayer.Active:=true;
    FVoicePlayer.WaitForStart;
  end;
end;

procedure TBisTaxiPhoneForm.VoicePlayerActivate(Sender: TObject);
begin
  FVoicePlayerLock.Enter;
  try
    //
  finally
    FVoicePlayerLock.Leave;
  end;
end;

procedure TBisTaxiPhoneForm.VoicePlayerDeactivate(Sender: TObject);
begin
  FVoicePlayerLock.Enter;
  try
    //
  finally
    FVoicePlayerLock.Leave;
  end;
end;

function TBisTaxiPhoneForm.VoicePlayerData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var NumLoops: Cardinal): Cardinal;
var
  ASize: Cardinal;
  MaxSize: Cardinal;
  Temp: TMemoryStream;
begin
  FVoicePlayerLock.Enter;
  try
    Result:=1;
    NumLoops:=0;
    FVoicePlayerStream.Position:=0;
    ASize:=FVoicePlayerStream.Size;
    if ASize>=BufferSize then begin
      MaxSize:=Round((BufferSize*FVoicePlayerBufferSize)/FVoicePlayer.BufferLength);
      if ASize>MaxSize then begin
        ASize:=MaxSize;
        FVoicePlayerStream.Position:=FVoicePlayerStream.Size-ASize;
      end;
      FVoicePlayerStream.Read(Buffer^,BufferSize);
      ASize:=FVoicePlayerStream.Size-FVoicePlayerStream.Position;
      if ASize>0 then begin
        Temp:=TMemoryStream.Create;
        try
          Temp.CopyFrom(FVoicePlayerStream,ASize);
          Temp.Position:=0;
          FVoicePlayerStream.Clear;
          FVoicePlayerStream.CopyFrom(Temp,ASize);
        finally
          Temp.Free;
        end;
      end else
        FVoicePlayerStream.Clear;
      Result:=BufferSize;
    end;
  finally
    FVoicePlayerLock.Leave;
  end;
end;

procedure TBisTaxiPhoneForm.InData(Channel: TBisTaxiPhoneChannel; const Data: Pointer; const DataSize: Cardinal);
var
  Converter: TBisWaveConverter;
  ASize: Integer;
begin
  FVoicePlayerLock.Enter;
  try
    if Assigned(Channel) and Assigned(Channel.FRemoteFormat) then begin
      Converter:=TBisWaveConverter.Create;
      try
        Converter.BeginRewrite(Channel.FRemoteFormat.WaveFormat);
        Converter.Write(Pointer(Data)^,DataSize);
        Converter.EndRewrite;
        if Converter.ConvertToPCM(FVoicePlayer.PCMFormat) then begin
          Converter.Stream.Position:=Converter.DataOffset;
          ASize:=Converter.Stream.Size-Converter.Stream.Position;
          if ASize>0 then begin
            FVoicePlayerStream.Position:=FVoicePlayerStream.Size;
            FVoicePlayerStream.CopyFrom(Converter.Stream,ASize);
          end;
        end;
      finally
        Converter.Free;
      end;
    end;
  finally
    FVoicePlayerLock.Leave;
  end;
end;

procedure TBisTaxiPhoneForm.StartRecorder(Channel: TBisTaxiPhoneChannel);
begin
  if Assigned(Channel) then begin
    FRecorderStream.Clear;
    FRecorderBufferSize:=Cardinal(UpDownBuffer.Position);
    FRecorder.BufferLength:=Channel.FPacketTime;
    FRecorder.BufferCount:=UpDownBufferCount.Position;
    FRecorder.Active:=true;
    FRecorder.WaitForStart;
  end;
end;

procedure TBisTaxiPhoneForm.RecorderFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
begin
  FreeIt:=false;
  pWaveFormat:=nil;
  if Assigned(FFormat) then begin
    pWaveFormat:=FFormat.WaveFormat;
  end;
end;

procedure TBisTaxiPhoneForm.RecorderActivate(Sender: TObject);
begin
  FRecorderLock.Enter;
  try
    //
  finally
    FRecorderLock.Leave;
  end;
end;

procedure TBisTaxiPhoneForm.RecorderDeactivate(Sender: TObject);
begin
  FRecorderLock.Enter;
  try
   //   
  finally
    FRecorderLock.Leave;
  end;
end;

procedure TBisTaxiPhoneForm.RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);
begin
  FRecorderLock.Enter;
  try
    FreeIt:=true;
    if (BufferSize>0) and not ButtonMicOff.Down then begin
      FRecorderStream.Position:=FRecorderStream.Size;
      FRecorderStream.Write(Buffer^,BufferSize);
    end;
  finally
    FRecorderLock.Leave;
  end;
end;

function TBisTaxiPhoneForm.OutData(Channel: TBisTaxiPhoneChannel; const Data: Pointer; const DataSize: Cardinal): Boolean;
var
  ASize: Cardinal;
  Temp: TMemoryStream;
  MaxSize: Cardinal;
begin
  Result:=false;
  FRecorderLock.Enter;
  try
    FRecorderStream.Position:=0;
    ASize:=FRecorderStream.Size;
    if ASize>=DataSize then begin
      MaxSize:=Round((DataSize*(FRecorderBufferSize))/FRecorder.BufferLength);
      if ASize>MaxSize then begin
        ASize:=MaxSize;
        FRecorderStream.Position:=FRecorderStream.Size-ASize;
      end;
      FRecorderStream.Read(Data^,DataSize);
      ASize:=FRecorderStream.Size-FRecorderStream.Position;
      if ASize>0 then begin
        Temp:=TMemoryStream.Create;
        try
          Temp.CopyFrom(FRecorderStream,ASize);
          Temp.Position:=0;
          FRecorderStream.Clear;
          FRecorderStream.CopyFrom(Temp,ASize);
        finally
          Temp.Free;
        end;
      end else
        FRecorderStream.Clear;
      Result:=true;
    end;
  finally
    FRecorderLock.Leave;
  end;
end;

procedure TBisTaxiPhoneForm.Ring(Channel: TBisTaxiPhoneChannel);
begin
  if Assigned(Channel) then begin
    if Assigned(Forms.Application) then begin
      if not FChannels.ExistsActive(Channel) then begin
        with Forms.Application do begin
          Restore;
          if Assigned(MainForm) then
            Self.BringToFront;
        end;
      end;
    end;
  end;
end;

procedure TBisTaxiPhoneForm.MenuItemAccountPhoneClick(Sender: TObject);
begin
  SelectAccountPhone;
end;

procedure TBisTaxiPhoneForm.MenuItemClientPhoneClick(Sender: TObject);
begin
  SelectClientPhone;
end;

procedure TBisTaxiPhoneForm.MenuItemDispatcherPhoneClick(Sender: TObject);
begin
  SelectDispatcherPhone;
end;

procedure TBisTaxiPhoneForm.MenuItemDriverPhoneClick(Sender: TObject);
begin
  SelectDriverPhone;
end;

procedure TBisTaxiPhoneForm.PopupActionBarPhonePopup(Sender: TObject);
begin
  MenuItemAccountPhone.Enabled:=CanSelectAccountPhone;
  MenuItemDriverPhone.Enabled:=CanSelectDriverPhone;
  MenuItemClientPhone.Enabled:=CanSelectClientPhone;
  MenuItemDispatcherPhone.Enabled:=CanSelectDispatcherPhone;
end;

procedure TBisTaxiPhoneForm.TabSetChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
  if NewTab=TabSheetPhone.PageIndex then begin
    WriteProfileParams;
    SaveProfileParams;
    PageControl.ActivePage:=TabSheetPhone
  end else begin
    PageControl.ActivePage:=TabSheetOptions;
  end;

  UpdateHeight;  
end;

procedure TBisTaxiPhoneForm.TimerAutoAnswerTimer(Sender: TObject);
begin
  TimerAutoAnswer.Enabled:=false;
  FChannels.ExcludeHold(FLastDialChannel);
  if Assigned(FLastDialChannel) then
    FLastDialChannel.Answer;
end;

procedure TBisTaxiPhoneForm.TrackBarPlayerChange(Sender: TObject);
begin
  if Assigned(FPlayerMixerLine) then
    FPlayerMixerLine.Volume:=TrackBarPlayer.Position;
end;

procedure TBisTaxiPhoneForm.TrackBarRecorderChange(Sender: TObject);
begin
  if Assigned(FRecorderMixerLine) then
    FRecorderMixerLine.Volume:=TrackBarRecorder.Position;
end;

procedure TBisTaxiPhoneForm.TrackBarTransparentChange(Sender: TObject);
begin
  AlphaBlendValue:=TrackBarTransparent.Position;
end;

procedure TBisTaxiPhoneForm.UpdateBreakButton;
begin
  if ButtonBreak.Down then
    ButtonBreak.Hint:=FSBreakDisabled
  else
    ButtonBreak.Hint:=FSBreakEnabled;
  ConnectionUpdate(not ButtonBreak.Down);
end;

procedure TBisTaxiPhoneForm.UpdateButtonDial;
begin
  ButtonDial.Enabled:=CanDial;
end;

procedure TBisTaxiPhoneForm.UpdateChannel(AChannel: TBisTaxiPhoneChannel);
begin
  if Assigned(AChannel) and AChannel.FFrame.Active then begin
    StatusBar.SimpleText:=AChannel.Status;
  end else begin
    StatusBar.SimpleText:=' ';
  end;
  StatusBar.Update;
end;

procedure TBisTaxiPhoneForm.UpdateHeight;
var
  H0, H1,H2: Integer;
begin
  if PageControl.ActivePage=TabSheetPhone then begin
    H0:=90;
    H1:=120;
    H2:=FChannels.Height;
    Constraints.MinHeight:=H1;
    if (H0+H2)>H1 then
      Constraints.MinHeight:=H0+H2;
  end else begin
    Constraints.MinHeight:=260;
  end;
  Height:=Constraints.MinHeight;
  LabelNoChannels.Visible:=FChannels.Count=0;
end;

procedure TBisTaxiPhoneForm.UpdateMicOffButton;
begin
  if ButtonMicOff.Down then
    ButtonMicOff.Hint:=FSMicDisabled
  else
    ButtonMicOff.Hint:=FSMicEnabled;
end;

procedure TBisTaxiPhoneForm.UpdateTrackBarPlayer;
var
  DestID,LineID: Integer;
begin
  TrackBarPlayer.OnChange:=nil;
  try
    FPlayerMixer.MixerName:=FVoicePlayer.DeviceName;
    if FPlayerMixer.FindMixerLine(FPlayerMixer.Master.ComponentType,DestID,LineID) then begin
      FPlayerMixer.DestinationID:=DestID;
      FPlayerMixerLine:=FPlayerMixer.Lines[LineID];
    end else
      FPlayerMixerLine:=FPlayerMixer.Master;

    if Assigned(FPlayerMixerLine) then begin
      TrackBarPlayer.Position:=FPlayerMixerLine.Volume;
      TrackBarPlayer.Enabled:=true;
      LabelPlayerDevice.Caption:=FormatEx('%s %s',[FOldPlayerDeviceCaption,FPlayerMixerLine.Name]);
    end else begin
      TrackBarPlayer.Position:=0;
      TrackBarPlayer.Enabled:=false;
      LabelPlayerDevice.Caption:=FOldPlayerDeviceCaption;
    end;
  finally
    TrackBarPlayer.OnChange:=TrackBarPlayerChange;
  end;
end;

procedure TBisTaxiPhoneForm.UpdateTrackBarRecorder;
var
  DestID,LineID: Integer;
begin
  TrackBarRecorder.OnChange:=nil;
  try
    FRecorderMixer.MixerName:=FRecorder.DeviceName;
    if FRecorderMixer.FindMixerLine(cmSrcMicrophone,DestID,LineID) then begin
      FRecorderMixer.DestinationID:=DestID;
      FRecorderMixerLine:=FRecorderMixer.Lines[LineID];
    end else
      FRecorderMixerLine:=nil;

    if Assigned(FRecorderMixerLine) then begin
      TrackBarRecorder.Position:=FRecorderMixerLine.Volume;
      TrackBarRecorder.Enabled:=true;
      LabelRecorderDevice.Caption:=FormatEx('%s %s',[FOldRecorderDeviceCaption,FRecorderMixerLine.Name]);
    end else begin
      TrackBarRecorder.Position:=0;
      TrackBarRecorder.Enabled:=false;
      LabelRecorderDevice.Caption:=FOldRecorderDeviceCaption;
    end;
  finally
    TrackBarRecorder.OnChange:=TrackBarRecorderChange;
  end;
end;

procedure TBisTaxiPhoneForm.ConnectionUpdate(AEnabled: Boolean);
var
  Params: TBisConfig;
begin
  if Assigned(Core) then begin
    Params:=TBisConfig.Create(nil);
    try
      Params.Write(ObjectName,'Enabled',AEnabled);
      DefaultUpdate(Params)
    finally
      Params.Free;
    end;
  end;
end;

procedure TBisTaxiPhoneForm.GetLocalEventParams;
begin
  if Assigned(Core) then begin
    with FChannels do begin
      GetEventParams(Core.SessionId,
                     FIP,FPort,FUseCompressor,FCompressorLevel,
                     FUseCrypter,FCrypterKey,FCrypterAlgorithm,FCrypterMode);
    end;
  end;
end;

procedure TBisTaxiPhoneForm.BeforeShow;
var
  Acceptor: String;
begin
  inherited BeforeShow;
  ConnectionUpdate(true);
  GetLocalEventParams;

  UpdateTrackBarPlayer;
  UpdateTrackBarRecorder;
  UpdateHeight;

  Acceptor:=GetAcceptor;
  if Acceptor<>'' then
    Dial;
  
  FBeforeShowed:=true;
end;

procedure TBisTaxiPhoneForm.ComboBoxAcceptorChange(Sender: TObject);
begin
  case GetAcceptorType of
    atPhone: FPhone:=ComboBoxAcceptor.Text;
    atAccount: FAccount:=ComboBoxAcceptor.Text;
    atComputer: FComputer:=ComboBoxAcceptor.Text;
    atSession: FSession:=ComboBoxAcceptor.Text;
  end;
  UpdateButtonDial;
end;

procedure TBisTaxiPhoneForm.ComboBoxAcceptorTypeChange(Sender: TObject);
var
  NewAcceptorType: TBisTaxiPhoneAcceptorType;
begin
  NewAcceptorType:=GetAcceptorType;
  if FOldAcceptorType<>NewAcceptorType then begin
    case NewAcceptorType of
      atPhone: begin
//        ComboBoxAcceptor.ReadOnly:=false;
        ComboBoxAcceptor.Color:=clWindow;
        ComboBoxAcceptor.Text:=FPhone;
        ButtonSelect.Enabled:=CanSelectAccountPhone or CanSelectDriverPhone or
                              CanSelectClientPhone or CanSelectDispatcherPhone;
      end;
      atAccount: begin
//        ComboBoxAcceptor.ReadOnly:=true;
        ComboBoxAcceptor.Color:=clBtnFace;
        ComboBoxAcceptor.Text:=FAccount;
        ButtonSelect.Enabled:=CanSelectAccount;
      end;
      atComputer: begin
//        ComboBoxAcceptor.ReadOnly:=false;
        ComboBoxAcceptor.Color:=clWindow;
        ComboBoxAcceptor.Text:=FComputer;
        ButtonSelect.Enabled:=CanSelectComputer;
      end;
      atSession: begin
//        ComboBoxAcceptor.ReadOnly:=true;
        ComboBoxAcceptor.Color:=clBtnFace;
        ComboBoxAcceptor.Text:=FSession;
        ButtonSelect.Enabled:=CanSelectSession;
      end;
    end;
    FOldAcceptorType:=NewAcceptorType;
  end;
  if FBeforeShowed and ComboBoxAcceptor.CanFocus then
    ComboBoxAcceptor.SetFocus;
end;

procedure TBisTaxiPhoneForm.ComboBoxPlayerDeviceChange(Sender: TObject);
var
  Index: Integer;
  DeviceID: Cardinal;
begin
  Index:=ComboBoxPlayerDevice.ItemIndex;
  if Index<>FOldPlayerIndex then begin
    if Index>-1 then begin
    {  DeviceID:=WAVE_MAPPER;
      if Index>0 then
        DeviceID:=Index-1;}
      DeviceID:=Index;  
      FVoicePlayer.DeviceID:=DeviceID;
      FMusicPlayer.DeviceID:=DeviceID;
      UpdateTrackBarPlayer;
    end;
    FOldPlayerIndex:=Index;
  end;
end;

procedure TBisTaxiPhoneForm.ComboBoxRecorderDeviceChange(Sender: TObject);
var
  Index: Integer;
  DeviceID: Cardinal;
begin
  Index:=ComboBoxRecorderDevice.ItemIndex;
  if Index<>FOldRecorderIndex then begin
    if Index>-1 then begin
{      DeviceID:=WAVE_MAPPER;
      if Index>0 then
        DeviceID:=Index-1;}
      DeviceID:=Index;
      FRecorder.DeviceID:=DeviceID;
      UpdateTrackBarRecorder;
    end;
    FOldRecorderIndex:=Index;
  end;
end;

function TBisTaxiPhoneForm.CanSelectAccount: Boolean;
var
  AIface: TBisDesignDataRolesAndAccountsFormIface;
begin
  AIface:=TBisDesignDataRolesAndAccountsFormIface.Create(nil);
  try
    AIface.Init;
    Result:=AIface.CanShow;
  finally
    AIface.Free;
  end;
end;

procedure TBisTaxiPhoneForm.SelectAccount;
var
  AIface: TBisDesignDataRolesAndAccountsFormIface;
  DS: TBisDataSet;
begin
  if CanSelectAccount then begin
    AIface:=TBisDesignDataRolesAndAccountsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ACCOUNT_ID';
      AIface.LocateValues:=FAccountId;
      AIface.MultiSelect:=false;
      if AIface.SelectInto(DS) then begin
        FAccountId:=DS.FieldByName('ACCOUNT_ID').Value;
        ComboBoxAcceptor.Text:=DS.FieldByName('USER_NAME').AsString;
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

function TBisTaxiPhoneForm.CanSelectDriverPhone: Boolean;
var
  AIface: TBisTaxiDataDriversFormIface;
begin
  AIface:=TBisTaxiDataDriversFormIface.Create(nil);
  try
    AIface.Init;
    Result:=AIface.CanShow;
  finally
    AIface.Free;
  end;
end;

procedure TBisTaxiPhoneForm.SelectDriverPhone;
var
  AIface: TBisTaxiDataDriversFormIface;
  DS: TBisDataSet;
begin
  if CanSelectDriverPhone then begin
    AIface:=TBisTaxiDataDriversFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      if AIface.SelectInto(DS) then begin
        ComboBoxAcceptor.Text:=DS.FieldByName('PHONE').AsString;
        FSelectPhoneType:=sptDriver;
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

function TBisTaxiPhoneForm.CanSelectAccountPhone: Boolean;
var
  AIface: TBisDesignDataAccountsFormIface;
begin
  AIface:=TBisDesignDataAccountsFormIface.Create(nil);
  try
    AIface.Init;
    Result:=AIface.CanShow;
  finally
    AIface.Free;
  end;
end;

procedure TBisTaxiPhoneForm.SelectAccountPhone;
var
  AIface: TBisDesignDataAccountsFormIface;
  DS: TBisDataSet;
begin
  if CanSelectAccountPhone then begin
    AIface:=TBisDesignDataAccountsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      if AIface.SelectInto(DS) then begin
        ComboBoxAcceptor.Text:=DS.FieldByName('PHONE').AsString;
        FSelectPhoneType:=sptAccount;
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

function TBisTaxiPhoneForm.CanSelectClientPhone: Boolean;
var
  AIface: TBisTaxiDataClientsFormIface;
begin
  AIface:=TBisTaxiDataClientsFormIface.Create(nil);
  try
    AIface.Init;
    Result:=AIface.CanShow;
  finally
    AIface.Free;
  end;
end;

procedure TBisTaxiPhoneForm.SelectClientPhone;
var
  AIface: TBisTaxiDataClientsFormIface;
  DS: TBisDataSet;
begin
  if CanSelectClientPhone then begin
    AIface:=TBisTaxiDataClientsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      if AIface.SelectInto(DS) then begin
        ComboBoxAcceptor.Text:=DS.FieldByName('PHONE').AsString;
        FSelectPhoneType:=sptClient;
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

function TBisTaxiPhoneForm.CanSelectDispatcherPhone: Boolean;
var
  AIface: TBisTaxiDataDispatchersFormIface;
begin
  AIface:=TBisTaxiDataDispatchersFormIface.Create(nil);
  try
    AIface.Init;
    Result:=AIface.CanShow;
  finally
    AIface.Free;
  end;
end;

procedure TBisTaxiPhoneForm.SelectDispatcherPhone;
var
  AIface: TBisTaxiDataDispatchersFormIface;
  DS: TBisDataSet;
begin
  if CanSelectDispatcherPhone then begin
    AIface:=TBisTaxiDataDispatchersFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      if AIface.SelectInto(DS) then begin
        ComboBoxAcceptor.Text:=DS.FieldByName('PHONE').AsString;
        FSelectPhoneType:=sptDispatcher;
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

function TBisTaxiPhoneForm.CanSelectComputer: Boolean;
begin
  Result:=true;
end;

procedure TBisTaxiPhoneForm.SelectComputer;
var
  S: String;
  Title: String;
begin
  if CanSelectComputer then begin
    Title:=FormatEx('%s %s',[ButtonSelect.Hint,ComboBoxAcceptorType.Text,ComboBoxAcceptor.Text]);
    S:=ShowDialog(Title,ComboBoxAcceptor.Text,sdfNetwork,[sdoBrowseForComputer]);
    if S<>ComboBoxAcceptor.Text then begin
      ComboBoxAcceptor.Text:=S;
      FSelectPhoneType:=sptClient;
    end;
  end;
end;

function TBisTaxiPhoneForm.CanSelectSession: Boolean;
var
  AIface: TBisDesignDataSessionsFormIface;
begin
  AIface:=TBisDesignDataSessionsFormIface.Create(nil);
  try
    AIface.Init;
    Result:=AIface.CanShow;
  finally
    AIface.Free;
  end;
end;

procedure TBisTaxiPhoneForm.CheckBoxAutoAnswerClick(Sender: TObject);
begin
  EditAutoAnswer.Enabled:=CheckBoxAutoAnswer.Checked;
  UpDownAutoAnswer.Enabled:=CheckBoxAutoAnswer.Checked;
end;

procedure TBisTaxiPhoneForm.SelectSession;
var
  AIface: TBisDesignDataSessionsFormIface;
  DS: TBisDataSet;
begin
  if CanSelectAccount then begin
    AIface:=TBisDesignDataSessionsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='SESSION_ID';
      AIface.LocateValues:=FSessionId;
      AIface.MultiSelect:=false;
      AIface.FilterGroups.Add.Filters.Add('SESSION_ID',fcNotEqual,Core.SessionId).CheckCase:=true;
      if AIface.SelectInto(DS) then begin
        FSessionId:=DS.FieldByName('SESSION_ID').Value;
        ComboBoxAcceptor.Text:=Format('%s %s',[DS.FieldByName('DATE_CREATE').AsString,
                                           DS.FieldByName('APPLICATION_NAME').AsString]);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiPhoneForm.ButtonBreakClick(Sender: TObject);
begin
  UpdateBreakButton;
end;

procedure TBisTaxiPhoneForm.ButtonDialClick(Sender: TObject);
begin
  Dial;
end;

procedure TBisTaxiPhoneForm.ButtonFormatClick(Sender: TObject);
var
  Form: TBisAudioFormatForm;
begin
  Form:=TBisAudioFormatForm.Create(nil);
  try
    Form.Drivers:=FDrivers;
    Form.Format:=FFormat;
    if Form.ShowModal=mrOk then begin
      FFormat:=Form.Format;
      EditFormat.Text:=GetFormatDescription(FFormat);
    end;                                                                       
  finally
    Form.Free;
  end;
end;

procedure TBisTaxiPhoneForm.ButtonMicOffClick(Sender: TObject);
begin
  if Assigned(FRecorderMixer.Master) then
    FRecorderMixer.Master.Mute:=ButtonMicOff.Down;
  UpdateMicOffButton;
end;

procedure TBisTaxiPhoneForm.ButtonSelectClick(Sender: TObject);
var
  Pt: TPoint;
begin
  case GetAcceptorType of
    atPhone: begin
      Pt:=TabSheetPhone.ClientToScreen(Point(ButtonSelect.Left,ButtonSelect.Top+ButtonSelect.Height));
      PopupActionBarPhone.Popup(Pt.X,Pt.Y);
    end;
    atAccount: SelectAccount;
    atComputer: SelectComputer;
    atSession: SelectSession;
  end;
end;

function TBisTaxiPhoneForm.CanDial: Boolean;
begin
  Result:=UpDownMaxChannels.Position>FChannels.ActiveCount;
  if Result then begin
    Result:=Trim(GetAcceptor)<>'';
  end;
end;

procedure TBisTaxiPhoneForm.Dial;
var
  Channel: TBisTaxiPhoneChannel;
  Acceptor: Variant;
  AcceptorType: TBisTaxiPhoneAcceptorType;
  S: String;
begin
  Acceptor:=GetAcceptor;
  AcceptorType:=GetAcceptorType;
  if CanDial then begin
    if AcceptorType=atPhone then begin
      S:=VarToStrDef(Acceptor,'');
      if ComboBoxAcceptor.Items.IndexOf(S)=-1 then
        ComboBoxAcceptor.Items.Add(S);
    end;
    SetAcceptor('');
    Channel:=FChannels.AddOutgoing;
    if Assigned(Channel) then begin
      Update;
      if AcceptorType=atPhone then
        Acceptor:=Channel.TransformPhone(Acceptor);
      if Channel.GetCallInfo(Acceptor) then begin
        FChannels.ExcludeHold(Channel);
        FChannels.SetFrameProps(Channel);
        Update;
        Channel.Dial(Acceptor,AcceptorType);
      end else
        FChannels.Remove(Channel);
    end;
  end else begin
    SetAcceptor('');
  end;
end;

end.
