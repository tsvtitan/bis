//ZylGSM
//Copyright by Zyl Soft 2003 - 2009


unit ZylGSM;

{$IFDEF VER200}
  {$define DELPHI6UP}
{$endif} 

{$IFDEF VER190}
  {$define DELPHI6UP}
{$endif}

{$IFDEF VER185}
  {$define DELPHI6UP}
{$endif}

{$IFDEF VER180}
  {$define DELPHI6UP}
{$endif}

{$IFDEF VER170}
  {$define DELPHI6UP}
{$endif}

{$ifdef VER150}
  {$define DELPHI6UP}
{$endif}

{$ifdef VER140}
  {$define DELPHI6UP}
{$endif}

{$ifdef VER130}
  {$ifdef BCB}
    {$define CPPB5}
  {$endif}
{$endif}

{$C-}
interface

uses
   SysUtils, Windows, Classes, Math, Registry, Messages, SyncObjs
   {$ifndef CPPB5}
   , Dialogs, Forms, Controls
   {$endif}
   {$ifdef DELPHI6UP}
   , DateUtils
   {$endif}
   ;

const
  dcb_Binary              = $00000001;
  dcb_ParityCheck         = $00000002;
  dcb_OutxCtsFlow         = $00000004;
  dcb_OutxDsrFlow         = $00000008;
  dcb_DtrControlMask      = $00000030;
  dcb_DtrControlDisable   = $00000000;
  dcb_DtrControlEnable    = $00000010;
  dcb_DtrControlHandshake = $00000020;
  dcb_DsrSensivity        = $00000040;
  dcb_TXContinueOnXoff    = $00000080;
  dcb_OutX                = $00000100;
  dcb_InX                 = $00000200;
  dcb_ErrorChar           = $00000400;
  dcb_NullStrip           = $00000800;
  dcb_RtsControlMask      = $00003000;
  dcb_RtsControlDisable   = $00000000;
  dcb_RtsControlEnable    = $00001000;
  dcb_RtsControlHandshake = $00002000;
  dcb_RtsControlToggle    = $00003000;
  dcb_AbortOnError        = $00004000;
  dcb_Reserveds           = $FFFF8000;

  Phone_SIM = 'SM';
  Phone_MEMORY = 'ME';

  sCannotConnect = 'Cannot connect to %s . %s';
type
  TCommPort =
    (spNone, spCOM1, spCOM2, spCOM3, spCOM4, spCOM5, spCOM6, spCOM7, spCOM8, spCOM9, spCOM10,
    spCOM11, spCOM12, spCOM13, spCOM14, spCOM15, spCOM16, spCOM17, spCOM18, spCOM19, spCOM20,
    spCOM21, spCOM22, spCOM23, spCOM24, spCOM25, spCOM26, spCOM27, spCOM28, spCOM29, spCOM30,
    spCOM31, spCOM32, spCOM33, spCOM34, spCOM35, spCOM36, spCOM37, spCOM38, spCOM39, spCOM40,
    spCOM41, spCOM42, spCOM43, spCOM44, spCOM45, spCOM46, spCOM47, spCOM48, spCOM49, spCOM50,
    spCOM51, spCOM52, spCOM53, spCOM54, spCOM55, spCOM56, spCOM57, spCOM58, spCOM59, spCOM60,
    spCOM61, spCOM62, spCOM63, spCOM64, spCOM65, spCOM66, spCOM67, spCOM68, spCOM69, spCOM70,
    spCOM71, spCOM72, spCOM73, spCOM74, spCOM75, spCOM76, spCOM77, spCOM78, spCOM79, spCOM80,
    spCOM81, spCOM82, spCOM83, spCOM84, spCOM85, spCOM86, spCOM87, spCOM88, spCOM89, spCOM90,
    spCOM91, spCOM92, spCOM93, spCOM94, spCOM95, spCOM96, spCOM97, spCOM98, spCOM99, spCOM100,
    spCOM101, spCOM102, spCOM103, spCOM104, spCOM105, spCOM106, spCOM107, spCOM108, spCOM109, spCOM110,
    spCOM111, spCOM112, spCOM113, spCOM114, spCOM115, spCOM116, spCOM117, spCOM118, spCOM119, spCOM120,
    spCOM121, spCOM122, spCOM123, spCOM124, spCOM125, spCOM126, spCOM127, spCOM128, spCOM129, spCOM130,
    spCOM131, spCOM132, spCOM133, spCOM134, spCOM135, spCOM136, spCOM137, spCOM138, spCOM139, spCOM140,
    spCOM141, spCOM142, spCOM143, spCOM144, spCOM145, spCOM146, spCOM147, spCOM148, spCOM149, spCOM150,
    spCOM151, spCOM152, spCOM153, spCOM154, spCOM155, spCOM156, spCOM157, spCOM158, spCOM159, spCOM160,
    spCOM161, spCOM162, spCOM163, spCOM164, spCOM165, spCOM166, spCOM167, spCOM168, spCOM169, spCOM170,
    spCOM171, spCOM172, spCOM173, spCOM174, spCOM175, spCOM176, spCOM177, spCOM178, spCOM179, spCOM180,
    spCOM181, spCOM182, spCOM183, spCOM184, spCOM185, spCOM186, spCOM187, spCOM188, spCOM189, spCOM190,
    spCOM191, spCOM192, spCOM193, spCOM194, spCOM195, spCOM196, spCOM197, spCOM198, spCOM199, spCOM200,
    spCOM201, spCOM202, spCOM203, spCOM204, spCOM205, spCOM206, spCOM207, spCOM208, spCOM209, spCOM210,
    spCOM211, spCOM212, spCOM213, spCOM214, spCOM215, spCOM216, spCOM217, spCOM218, spCOM219, spCOM220,
    spCOM221, spCOM222, spCOM223, spCOM224, spCOM225, spCOM226, spCOM227, spCOM228, spCOM229, spCOM230,
    spCOM231, spCOM232, spCOM233, spCOM234, spCOM235, spCOM236, spCOM237, spCOM238, spCOM239, spCOM240,
    spCOM241, spCOM242, spCOM243, spCOM244, spCOM245, spCOM246, spCOM247, spCOM248, spCOM249, spCOM250,
    spCOM251, spCOM252, spCOM253, spCOM254, spCOM255);

  TCommPortSet = set of TCommPort;
  TBaudRate = (br000075, br000110, br000134, br000150, br000300, br000600, br001200, br001800,
               br002400, br004800, br007200, br009600, br014400, br019200, br038400, br057600,
               br115200, br128000, br230400, br256000, br460800, brCustom);

  TStopBits = (sb1Bit, sb1_5Bits, sb2Bits);
  TDataWidth = (dw5Bits, dw6Bits, dw7Bits, dw8Bits);
  TParityBits = (pbNone, pbOdd, pbEven, pbMark, pbSpace);

  // Hardware Flow Control (None, None + RTS always on, RTS/CTS)
  THwFlowControl = (hfNONE, hfRTS, hfRTSCTS);
  // Software Flow Control (None, XON/XOFF)
  TSwFlowControl = (sfNONE, sfXONXOFF);

  TCallType = (ctVoice, ctData);

  TPDUSMS = record
    Length: AnsiString;
    Data: AnsiString;
  end;

  TConnectEvent = procedure(Sender: TObject; Port: TCommPort) of object;
  TSendReceiveEvent = procedure(Sender: TObject; Buffer: AnsiString) of object;
  TRingEvent = procedure(Sender: TObject; CallerNumber: AnsiString) of object;
  TNewMessageEvent = procedure(Sender: TObject; Location: AnsiString; Index: Integer) of object;
  TReadMessageEvent = procedure(Sender: TObject; MessageText, PhoneNumber, CenterNumber: AnsiString; Status: Integer) of object;
  TDetectEvent = procedure(Sender: TObject; const Port: TCommPort; const BaudRate: TBaudRate; var Cancel: Boolean) of object;

  TZylGSM = class(TComponent)
  private
    { Private declarations }
    FPort: AnsiString;
    FBaudRate: Integer;
    FCustomBaudRate: Integer;
    FDataWidth: Byte;
    FParity: Byte;
    FStopBits: Byte;
    FEnableDTROnOpen: Boolean;
    FEnableRTSOnOpen: Boolean;
    FHwFlowControl: THwFlowControl;
    FSwFlowControl: TSwFlowControl;

    FReadBuffer: AnsiString;

    FReadIntervalTimeout: Longint;
    FReadTotalTimeoutMultiplier: Longint;
    FReadTotalTimeoutConstant: Longint;
    FWriteTotalTimeoutMultiplier: Longint;
    FWriteTotalTimeoutConstant: Longint;

    FPriority: TThreadPriority;
    FNeedSynchronization: Boolean;
    FLastReceived: TDateTime;

    FDelay: Cardinal;

    FInputBuffer: Cardinal;
    FOutputBuffer: Cardinal;

    FVersion: Double;

    ComThread: TThread;

    ConnectedTo: TCommPort;

    FRegistered: Boolean;

    FAutoReadNewMessage: Boolean;

    FCancelDetect: Boolean;

    FOnReceive: TSendReceiveEvent;
    FOnSend: TSendReceiveEvent;
    FOnConnect: TConnectEvent;
    FOnDisconnect: TConnectEvent;
    FOnRing: TRingEvent;
    FOnNewMessage: TNewMessageEvent;
    FOnReadMessage: TReadMessageEvent;
    FOnDetect: TDetectEvent;

    function GetCommPort(): TCommPort;
    procedure SetCommPort(const Value: TCommPort);
    function GetBaudRate(): TBaudRate;
    procedure SetBaudRate(const Value: TBaudRate);
    function GetDataWidth(): TDataWidth;
    procedure SetDataWidth(const Value: TDataWidth);
    function GetStopBits(): TStopBits;
    procedure SetStopBits(const Value: TStopBits);
    function GetParity(): TParityBits;
    procedure SetParity(const Value: TParityBits);
    procedure SetCustomBaudRate(const Value: Integer);

    procedure SetEnableDTROnOpen(const Value: Boolean);
    procedure SetEnableRTSOnOpen(const Value: Boolean);
    procedure SetHwFlowControl(const Value: THwFlowControl);
    procedure SetSwFlowControl(const Value: TSwFlowControl);

    procedure SetPriority(const Value: TThreadPriority);

    function SetDCBState(const ComDevice: THandle): Boolean; overload;
    function SetDCBState(const pComDevice: THandle; const pBaudRate: TBaudRate): Boolean; overload;
    function SetTimeOuts(const ComDevice: THandle): Boolean;
    function SetBuffers(const ComDevice: THandle): Boolean;

    procedure ProcessAT();
    procedure HandleGSMEvents(strAT: AnsiString);
    function SafeCopy(const strText: AnsiString; nStart, nLength: Integer; const DefaultValue: AnsiString): AnsiString;

    function RunningInTheIDE(): Boolean;
  protected
    { Protected declarations }
    // GSM
    function StringToPDU(str: AnsiString): AnsiString;
    function StringToPDUSMS(PhoneNumber, CenterNumber, MessageText: AnsiString): TPDUSMS;
    //////
  public
    { Public declarations }

    property Version: Double read FVersion;
    property NeedSynchronization: Boolean read FNeedSynchronization write FNeedSynchronization;
    property LastReceived: TDateTime read FLastReceived write FLastReceived;

    // GSM
    function PDUToString(str: AnsiString): AnsiString;
    function PDUSMSToString(MessageText: AnsiString; var PhoneNumber, CenterNumber: AnsiString): AnsiString;
    //////

    //constructor
    constructor Create(AOwner: TComponent); override;
    //destructor
    destructor Destroy(); override;

    //starts communication
    procedure Open();
    //stops communication
    procedure Close();
    //returns the comm port where gps is connected to
    function IsConnected: TCommPort;
    //converts String to TCommPort
    function StringToCommPort(const Port: AnsiString): TCommPort;
    //converts TCommPort to String
    function CommPortToString(const Port: TCommPort): AnsiString;
    //comverts TBaudRate to integer
    function BaudRateToInt(const pBaudRate: TBaudRate): Integer;
    //comverts integer to TBaudRate
    function IntToBaudRate(const Value: Integer): TBaudRate;
    //sends a pascal string (NULL terminated if $H+ (default))
    function SendString(const str: AnsiString): Cardinal;
    //returns the existing serial ports of the system
    function GetExistingCommPorts: TCommPortSet;
    //detects GSM module
    function DetectGSM(const startBaudRate, endBaudRate: TBaudRate; var pPort: TCommPort;
                               var pBaudRate: TBaudRate): Boolean; overload;
    function DetectGSM(var pPort: TCommPort; var pBaudRate: TBaudRate): Boolean; overload;

    //-----public GSM methods-----//
    // dial in data mode
    procedure DialData(PhoneNumber: AnsiString);
    // dial in voice mode
    procedure DialVoice(PhoneNumber: AnsiString);
    // answer call
    procedure AnswerCall();
    // terminate call
    procedure TerminateCall();
    // send SMS as text
    procedure SendSmsAsText(PhoneNumber, CenterNumber, MessageText: AnsiString);
    // send SMS as PDU
    procedure SendSmsAsPDU(PhoneNumber, CenterNumber, MessageText: AnsiString);
    // delete SMS
    procedure DeleteSMS(Location: AnsiString; Index: Integer);
    // load SMS into OnReadMessage event
    procedure GetSMS(Location: AnsiString; Index: Integer);
  published
    { Published declarations }
    property Port: TCommPort read GetCommPort write SetCommPort default spNone;
    property BaudRate: TBaudRate read GetBaudRate write SetBaudRate default br004800;
    property DataWidth: TDataWidth read GetDataWidth write SetDataWidth default dw8Bits;
    property StopBits: TStopBits read GetStopBits write SetStopBits default sb1Bit;
    property Parity: TParityBits read GetParity write SetParity default pbNone;

    property EnableDTROnOpen: Boolean read FEnableDTROnOpen write SetEnableDTROnOpen default True;
    property EnableRTSOnOpen: Boolean read FEnableRTSOnOpen write SetEnableRTSOnOpen default True;
    property HwFlowControl: THwFlowControl read FHwFlowControl write SetHwFlowControl default hfNONE;
    property SwFlowControl: TSwFlowControl read FSwFlowControl write SetSwFlowControl default sfNONE;

    property Priority: TThreadPriority read FPriority write SetPriority default tpNormal;

    property CustomBaudRate: Integer read FCustomBaudRate write SetCustomBaudRate;

    property AutoReadNewMessage: Boolean read FAutoReadNewMessage write FAutoReadNewMessage default True;

    // fires when new data was received
    property OnReceive: TSendReceiveEvent read FOnReceive write FOnReceive;
    // fires when new data was sent
    property OnSend: TSendReceiveEvent read FOnSend write FOnSend;
    // fires after a new connection was established
    property OnConnect: TConnectEvent read FOnConnect write FOnConnect;
    // fires before a disconnection
    property OnDisconnect: TConnectEvent read FOnDisconnect write FOnDisconnect;
    // fires at incoming calls
    property OnRing: TRingEvent read FOnRing write FOnRing;
    // fires at new SMS
    property OnNewMessage: TNewMessageEvent read FOnNewMessage write FOnNewMessage;
    // fires when at a new SMS or when a SMS was requested
    property OnReadMessage: TReadMessageEvent read FOnReadMessage write FOnReadMessage;
    // detection progress
    property OnDetect: TDetectEvent read FOnDetect write FOnDetect;
  end;

  TComThread = class(TThread)
  private
    Owner: TZylGSM;
  protected
    procedure Execute();override;
  public
    ComDevice: THandle;
    constructor Create(AOwner: TZylGSM);
    function GetPortHandle(): THandle;
    destructor Destroy();override;
  end;

var
  CriticalSection: TCriticalSection;

procedure Register;

implementation

uses gsm_sms;

procedure Register;
begin
  RegisterComponents('Zyl Soft', [TZylGSM]);
end;

function TryStrToInt(const S: Ansistring; out Value: Integer): Boolean;
var
  E: Integer;
begin
  Val(S, Value, E);
  Result := E = 0;
end;

constructor TZylGSM.Create(AOwner: TComponent);
begin
  inherited;

  FVersion := 1.15;
  FRegistered := False;

  FPort := '';
  FBaudRate := 4800;
  FDataWidth := 8;
  FStopBits := 0;
  FParity := 0;

  FEnableDTROnOpen := True;
  FEnableRTSOnOpen := True;
  FHwFlowControl := hfNONE;
  FSwFlowControl := sfNONE;

  FPriority := tpNormal;
  FNeedSynchronization := False;
  FLastReceived := 0;

  FInputBuffer := 4096;
  FOutputBuffer := 4096;

  FReadIntervalTimeout := -1;
  FReadTotalTimeoutMultiplier := 0;
  FReadTotalTimeoutConstant := 0;
  FWriteTotalTimeoutMultiplier := 100;
  FWriteTotalTimeoutConstant := 1000;

  FReadBuffer := '';

  FDelay := 500;
  FCustomBaudRate := 0;

  FAutoReadNewMessage := True;

  FCancelDetect := False;

  FOnReceive := nil;
  FOnSend := nil;
  FOnConnect := nil;
  FOnDisconnect := nil;
  FOnRing := nil;
  FOnNewMessage := nil;
  FOnReadMessage := nil;
  FOnDetect := nil;

  ComThread := nil;
  ConnectedTo := spNone;
  CriticalSection := TCriticalSection.Create; 
end;

function TZylGSM.RunningInTheIDE(): Boolean;
begin
  Result := FindWindow('TAppBuilder', nil) > 0;
end;

function TZylGSM.StringToCommPort(const Port: AnsiString): TCommPort;
begin
  if Port = 'COM1' then
    Result := spCOM1
  else if Port = 'COM2' then
    Result := spCOM2
  else if Port = 'COM3' then
    Result := spCOM3
  else if Port = 'COM4' then
    Result := spCOM4
  else if Port = 'COM5' then
    Result := spCOM5
  else if Port = 'COM6' then
    Result := spCOM6
  else if Port = 'COM7' then
    Result := spCOM7
  else if Port = 'COM8' then
    Result := spCOM8
  else if Port = 'COM9' then
    Result := spCOM9
  else if Port = 'COM10' then
    Result := spCOM10
  else if Port = 'COM11' then
    Result := spCOM11
  else if Port = 'COM12' then
    Result := spCOM12
  else if Port = 'COM13' then
    Result := spCOM13
  else if Port = 'COM14' then
    Result := spCOM14
  else if Port = 'COM15' then
    Result := spCOM15
  else if Port = 'COM16' then
    Result := spCOM16
  else if Port = 'COM17' then
    Result := spCOM17
  else if Port = 'COM18' then
    Result := spCOM18
  else if Port = 'COM19' then
    Result := spCOM19
  else if Port = 'COM20' then
    Result := spCOM20
  else if Port = 'COM21' then
    Result := spCOM21
  else if Port = 'COM22' then
    Result := spCOM22
  else if Port = 'COM23' then
    Result := spCOM23
  else if Port = 'COM24' then
    Result := spCOM24
  else if Port = 'COM25' then
    Result := spCOM25
  else if Port = 'COM26' then
    Result := spCOM26
  else if Port = 'COM27' then
    Result := spCOM27
  else if Port = 'COM28' then
    Result := spCOM28
  else if Port = 'COM29' then
    Result := spCOM29
  else if Port = 'COM30' then
    Result := spCOM30
  else if Port = 'COM31' then
    Result := spCOM31
  else if Port = 'COM32' then
    Result := spCOM32
  else if Port = 'COM33' then
    Result := spCOM33
  else if Port = 'COM34' then
    Result := spCOM34
  else if Port = 'COM35' then
    Result := spCOM35
  else if Port = 'COM36' then
    Result := spCOM36
  else if Port = 'COM37' then
    Result := spCOM37
  else if Port = 'COM38' then
    Result := spCOM38
  else if Port = 'COM39' then
    Result := spCOM39
  else if Port = 'COM40' then
    Result := spCOM40
  else if Port = 'COM41' then
    Result := spCOM41
  else if Port = 'COM42' then
    Result := spCOM42
  else if Port = 'COM43' then
    Result := spCOM43
  else if Port = 'COM44' then
    Result := spCOM44
  else if Port = 'COM45' then
    Result := spCOM45
  else if Port = 'COM46' then
    Result := spCOM46
  else if Port = 'COM47' then
    Result := spCOM47
  else if Port = 'COM48' then
    Result := spCOM48
  else if Port = 'COM49' then
    Result := spCOM49
  else if Port = 'COM50' then
    Result := spCOM50
  else if Port = 'COM51' then
    Result := spCOM51
  else if Port = 'COM52' then
    Result := spCOM52
  else if Port = 'COM53' then
    Result := spCOM53
  else if Port = 'COM54' then
    Result := spCOM54
  else if Port = 'COM55' then
    Result := spCOM55
  else if Port = 'COM56' then
    Result := spCOM56
  else if Port = 'COM57' then
    Result := spCOM57
  else if Port = 'COM58' then
    Result := spCOM58
  else if Port = 'COM59' then
    Result := spCOM59
  else if Port = 'COM60' then
    Result := spCOM60
  else if Port = 'COM61' then
    Result := spCOM61
  else if Port = 'COM62' then
    Result := spCOM62
  else if Port = 'COM63' then
    Result := spCOM63
  else if Port = 'COM64' then
    Result := spCOM64
  else if Port = 'COM65' then
    Result := spCOM65
  else if Port = 'COM66' then
    Result := spCOM66
  else if Port = 'COM67' then
    Result := spCOM67
  else if Port = 'COM68' then
    Result := spCOM68
  else if Port = 'COM69' then
    Result := spCOM69
  else if Port = 'COM70' then
    Result := spCOM70
  else if Port = 'COM71' then
    Result := spCOM71
  else if Port = 'COM72' then
    Result := spCOM72
  else if Port = 'COM73' then
    Result := spCOM73
  else if Port = 'COM74' then
    Result := spCOM74
  else if Port = 'COM75' then
    Result := spCOM75
  else if Port = 'COM76' then
    Result := spCOM76
  else if Port = 'COM77' then
    Result := spCOM77
  else if Port = 'COM78' then
    Result := spCOM78
  else if Port = 'COM79' then
    Result := spCOM79
  else if Port = 'COM80' then
    Result := spCOM80
  else if Port = 'COM81' then
    Result := spCOM81
  else if Port = 'COM82' then
    Result := spCOM82
  else if Port = 'COM83' then
    Result := spCOM83
  else if Port = 'COM84' then
    Result := spCOM84
  else if Port = 'COM85' then
    Result := spCOM85
  else if Port = 'COM86' then
    Result := spCOM86
  else if Port = 'COM87' then
    Result := spCOM87
  else if Port = 'COM88' then
    Result := spCOM88
  else if Port = 'COM89' then
    Result := spCOM89
  else if Port = 'COM90' then
    Result := spCOM90
  else if Port = 'COM91' then
    Result := spCOM91
  else if Port = 'COM92' then
    Result := spCOM92
  else if Port = 'COM93' then
    Result := spCOM93
  else if Port = 'COM94' then
    Result := spCOM94
  else if Port = 'COM95' then
    Result := spCOM95
  else if Port = 'COM96' then
    Result := spCOM96
  else if Port = 'COM97' then
    Result := spCOM97
  else if Port = 'COM98' then
    Result := spCOM98
  else if Port = 'COM99' then
    Result := spCOM99
  else if Port = 'COM100' then
    Result := spCOM100
  else if Port = 'COM101' then
    Result := spCOM101
  else if Port = 'COM102' then
    Result := spCOM102
  else if Port = 'COM103' then
    Result := spCOM103
  else if Port = 'COM104' then
    Result := spCOM104
  else if Port = 'COM105' then
    Result := spCOM105
  else if Port = 'COM106' then
    Result := spCOM106
  else if Port = 'COM107' then
    Result := spCOM107
  else if Port = 'COM108' then
    Result := spCOM108
  else if Port = 'COM109' then
    Result := spCOM109
  else if Port = 'COM110' then
    Result := spCOM110
  else if Port = 'COM111' then
    Result := spCOM111
  else if Port = 'COM112' then
    Result := spCOM112
  else if Port = 'COM113' then
    Result := spCOM113
  else if Port = 'COM114' then
    Result := spCOM114
  else if Port = 'COM115' then
    Result := spCOM115
  else if Port = 'COM116' then
    Result := spCOM116
  else if Port = 'COM117' then
    Result := spCOM117
  else if Port = 'COM118' then
    Result := spCOM118
  else if Port = 'COM119' then
    Result := spCOM119
  else if Port = 'COM120' then
    Result := spCOM120
  else if Port = 'COM121' then
    Result := spCOM121
  else if Port = 'COM122' then
    Result := spCOM122
  else if Port = 'COM123' then
    Result := spCOM123
  else if Port = 'COM124' then
    Result := spCOM124
  else if Port = 'COM125' then
    Result := spCOM125
  else if Port = 'COM126' then
    Result := spCOM126
  else if Port = 'COM127' then
    Result := spCOM127
  else if Port = 'COM128' then
    Result := spCOM128
  else if Port = 'COM129' then
    Result := spCOM129
  else if Port = 'COM130' then
    Result := spCOM130
  else if Port = 'COM131' then
    Result := spCOM131
  else if Port = 'COM132' then
    Result := spCOM132
  else if Port = 'COM133' then
    Result := spCOM133
  else if Port = 'COM134' then
    Result := spCOM134
  else if Port = 'COM135' then
    Result := spCOM135
  else if Port = 'COM136' then
    Result := spCOM136
  else if Port = 'COM137' then
    Result := spCOM137
  else if Port = 'COM138' then
    Result := spCOM138
  else if Port = 'COM139' then
    Result := spCOM139
  else if Port = 'COM140' then
    Result := spCOM140
  else if Port = 'COM141' then
    Result := spCOM141
  else if Port = 'COM142' then
    Result := spCOM142
  else if Port = 'COM143' then
    Result := spCOM143
  else if Port = 'COM144' then
    Result := spCOM144
  else if Port = 'COM145' then
    Result := spCOM145
  else if Port = 'COM146' then
    Result := spCOM146
  else if Port = 'COM147' then
    Result := spCOM147
  else if Port = 'COM148' then
    Result := spCOM148
  else if Port = 'COM149' then
    Result := spCOM149
  else if Port = 'COM150' then
    Result := spCOM150
  else if Port = 'COM151' then
    Result := spCOM151
  else if Port = 'COM152' then
    Result := spCOM152
  else if Port = 'COM153' then
    Result := spCOM153
  else if Port = 'COM154' then
    Result := spCOM154
  else if Port = 'COM155' then
    Result := spCOM155
  else if Port = 'COM156' then
    Result := spCOM156
  else if Port = 'COM157' then
    Result := spCOM157
  else if Port = 'COM158' then
    Result := spCOM158
  else if Port = 'COM159' then
    Result := spCOM159
  else if Port = 'COM160' then
    Result := spCOM160
  else if Port = 'COM161' then
    Result := spCOM161
  else if Port = 'COM162' then
    Result := spCOM162
  else if Port = 'COM163' then
    Result := spCOM163
  else if Port = 'COM164' then
    Result := spCOM164
  else if Port = 'COM165' then
    Result := spCOM165
  else if Port = 'COM166' then
    Result := spCOM166
  else if Port = 'COM167' then
    Result := spCOM167
  else if Port = 'COM168' then
    Result := spCOM168
  else if Port = 'COM169' then
    Result := spCOM169
  else if Port = 'COM170' then
    Result := spCOM170
  else if Port = 'COM171' then
    Result := spCOM171
  else if Port = 'COM172' then
    Result := spCOM172
  else if Port = 'COM173' then
    Result := spCOM173
  else if Port = 'COM174' then
    Result := spCOM174
  else if Port = 'COM175' then
    Result := spCOM175
  else if Port = 'COM176' then
    Result := spCOM176
  else if Port = 'COM177' then
    Result := spCOM177
  else if Port = 'COM178' then
    Result := spCOM178
  else if Port = 'COM179' then
    Result := spCOM179
  else if Port = 'COM180' then
    Result := spCOM180
  else if Port = 'COM181' then
    Result := spCOM181
  else if Port = 'COM182' then
    Result := spCOM182
  else if Port = 'COM183' then
    Result := spCOM183
  else if Port = 'COM184' then
    Result := spCOM184
  else if Port = 'COM185' then
    Result := spCOM185
  else if Port = 'COM186' then
    Result := spCOM186
  else if Port = 'COM187' then
    Result := spCOM187
  else if Port = 'COM188' then
    Result := spCOM188
  else if Port = 'COM189' then
    Result := spCOM189
  else if Port = 'COM190' then
    Result := spCOM190
  else if Port = 'COM191' then
    Result := spCOM191
  else if Port = 'COM192' then
    Result := spCOM192
  else if Port = 'COM193' then
    Result := spCOM193
  else if Port = 'COM194' then
    Result := spCOM194
  else if Port = 'COM195' then
    Result := spCOM195
  else if Port = 'COM196' then
    Result := spCOM196
  else if Port = 'COM197' then
    Result := spCOM197
  else if Port = 'COM198' then
    Result := spCOM198
  else if Port = 'COM199' then
    Result := spCOM199
  else if Port = 'COM200' then
    Result := spCOM200
  else if Port = 'COM201' then
    Result := spCOM201
  else if Port = 'COM202' then
    Result := spCOM202
  else if Port = 'COM203' then
    Result := spCOM203
  else if Port = 'COM204' then
    Result := spCOM204
  else if Port = 'COM205' then
    Result := spCOM205
  else if Port = 'COM206' then
    Result := spCOM206
  else if Port = 'COM207' then
    Result := spCOM207
  else if Port = 'COM208' then
    Result := spCOM208
  else if Port = 'COM209' then
    Result := spCOM209
  else if Port = 'COM210' then
    Result := spCOM210
  else if Port = 'COM211' then
    Result := spCOM211
  else if Port = 'COM212' then
    Result := spCOM212
  else if Port = 'COM213' then
    Result := spCOM213
  else if Port = 'COM214' then
    Result := spCOM214
  else if Port = 'COM215' then
    Result := spCOM215
  else if Port = 'COM216' then
    Result := spCOM216
  else if Port = 'COM217' then
    Result := spCOM217
  else if Port = 'COM218' then
    Result := spCOM218
  else if Port = 'COM219' then
    Result := spCOM219
  else if Port = 'COM220' then
    Result := spCOM220
  else if Port = 'COM221' then
    Result := spCOM221
  else if Port = 'COM222' then
    Result := spCOM222
  else if Port = 'COM223' then
    Result := spCOM223
  else if Port = 'COM224' then
    Result := spCOM224
  else if Port = 'COM225' then
    Result := spCOM225
  else if Port = 'COM226' then
    Result := spCOM226
  else if Port = 'COM227' then
    Result := spCOM227
  else if Port = 'COM228' then
    Result := spCOM228
  else if Port = 'COM229' then
    Result := spCOM229
  else if Port = 'COM230' then
    Result := spCOM230
  else if Port = 'COM231' then
    Result := spCOM231
  else if Port = 'COM232' then
    Result := spCOM232
  else if Port = 'COM233' then
    Result := spCOM233
  else if Port = 'COM234' then
    Result := spCOM234
  else if Port = 'COM235' then
    Result := spCOM235
  else if Port = 'COM236' then
    Result := spCOM236
  else if Port = 'COM237' then
    Result := spCOM237
  else if Port = 'COM238' then
    Result := spCOM238
  else if Port = 'COM239' then
    Result := spCOM239
  else if Port = 'COM240' then
    Result := spCOM240
  else if Port = 'COM241' then
    Result := spCOM241
  else if Port = 'COM242' then
    Result := spCOM242
  else if Port = 'COM243' then
    Result := spCOM243
  else if Port = 'COM244' then
    Result := spCOM244
  else if Port = 'COM245' then
    Result := spCOM245
  else if Port = 'COM246' then
    Result := spCOM246
  else if Port = 'COM247' then
    Result := spCOM247
  else if Port = 'COM248' then
    Result := spCOM248
  else if Port = 'COM249' then
    Result := spCOM249
  else if Port = 'COM250' then
    Result := spCOM250
  else if Port = 'COM251' then
    Result := spCOM251
  else if Port = 'COM252' then
    Result := spCOM252
  else if Port = 'COM253' then
    Result := spCOM253
  else if Port = 'COM254' then
    Result := spCOM254
  else if Port = 'COM255' then
    Result := spCOM255
  else
    Result := spNone;
end;

function TZylGSM.CommPortToString(const Port: TCommPort): AnsiString;
begin
  if Port = spCOM1 then
    Result := 'COM1'
  else if Port = spCOM2 then
    Result := 'COM2'
  else if Port = spCOM3 then
    Result := 'COM3'
  else if Port = spCOM4 then
    Result := 'COM4'
  else if Port = spCOM5 then
    Result := 'COM5'
  else if Port = spCOM6 then
    Result := 'COM6'
  else if Port = spCOM7 then
    Result := 'COM7'
  else if Port = spCOM8 then
    Result := 'COM8'
  else if Port = spCOM9 then
    Result := 'COM9'
  else if Port = spCOM10 then
    Result := 'COM10'
  else if Port = spCOM11 then
    Result := 'COM11'
  else if Port = spCOM12 then
    Result := 'COM12'
  else if Port = spCOM13 then
    Result := 'COM13'
  else if Port = spCOM14 then
    Result := 'COM14'
  else if Port = spCOM15 then
    Result := 'COM15'
  else if Port = spCOM16 then
    Result := 'COM16'
  else if Port = spCOM17 then
    Result := 'COM17'
  else if Port = spCOM18 then
    Result := 'COM18'
  else if Port = spCOM19 then
    Result := 'COM19'
  else if Port = spCOM20 then
    Result := 'COM20'
  else if Port = spCOM21 then
    Result := 'COM21'
  else if Port = spCOM22 then
    Result := 'COM22'
  else if Port = spCOM23 then
    Result := 'COM23'
  else if Port = spCOM24 then
    Result := 'COM24'
  else if Port = spCOM25 then
    Result := 'COM25'
  else if Port = spCOM26 then
    Result := 'COM26'
  else if Port = spCOM27 then
    Result := 'COM27'
  else if Port = spCOM28 then
    Result := 'COM28'
  else if Port = spCOM29 then
    Result := 'COM29'
  else if Port = spCOM30 then
    Result := 'COM30'
  else if Port = spCOM31 then
    Result := 'COM31'
  else if Port = spCOM32 then
    Result := 'COM32'
  else if Port = spCOM33 then
    Result := 'COM33'
  else if Port = spCOM34 then
    Result := 'COM34'
  else if Port = spCOM35 then
    Result := 'COM35'
  else if Port = spCOM36 then
    Result := 'COM36'
  else if Port = spCOM37 then
    Result := 'COM37'
  else if Port = spCOM38 then
    Result := 'COM38'
  else if Port = spCOM39 then
    Result := 'COM39'
  else if Port = spCOM40 then
    Result := 'COM40'
  else if Port = spCOM41 then
    Result := 'COM41'
  else if Port = spCOM42 then
    Result := 'COM42'
  else if Port = spCOM43 then
    Result := 'COM43'
  else if Port = spCOM44 then
    Result := 'COM44'
  else if Port = spCOM45 then
    Result := 'COM45'
  else if Port = spCOM46 then
    Result := 'COM46'
  else if Port = spCOM47 then
    Result := 'COM47'
  else if Port = spCOM48 then
    Result := 'COM48'
  else if Port = spCOM49 then
    Result := 'COM49'
  else if Port = spCOM50 then
    Result := 'COM50'
  else if Port = spCOM51 then
    Result := 'COM51'
  else if Port = spCOM52 then
    Result := 'COM52'
  else if Port = spCOM53 then
    Result := 'COM53'
  else if Port = spCOM54 then
    Result := 'COM54'
  else if Port = spCOM55 then
    Result := 'COM55'
  else if Port = spCOM56 then
    Result := 'COM56'
  else if Port = spCOM57 then
    Result := 'COM57'
  else if Port = spCOM58 then
    Result := 'COM58'
  else if Port = spCOM59 then
    Result := 'COM59'
  else if Port = spCOM60 then
    Result := 'COM60'
  else if Port = spCOM61 then
    Result := 'COM61'
  else if Port = spCOM62 then
    Result := 'COM62'
  else if Port = spCOM63 then
    Result := 'COM63'
  else if Port = spCOM64 then
    Result := 'COM64'
  else if Port = spCOM65 then
    Result := 'COM65'
  else if Port = spCOM66 then
    Result := 'COM66'
  else if Port = spCOM67 then
    Result := 'COM67'
  else if Port = spCOM68 then
    Result := 'COM68'
  else if Port = spCOM69 then
    Result := 'COM69'
  else if Port = spCOM70 then
    Result := 'COM70'
  else if Port = spCOM71 then
    Result := 'COM71'
  else if Port = spCOM72 then
    Result := 'COM72'
  else if Port = spCOM73 then
    Result := 'COM73'
  else if Port = spCOM74 then
    Result := 'COM74'
  else if Port = spCOM75 then
    Result := 'COM75'
  else if Port = spCOM76 then
    Result := 'COM76'
  else if Port = spCOM77 then
    Result := 'COM77'
  else if Port = spCOM78 then
    Result := 'COM78'
  else if Port = spCOM79 then
    Result := 'COM79'
  else if Port = spCOM80 then
    Result := 'COM80'
  else if Port = spCOM81 then
    Result := 'COM81'
  else if Port = spCOM82 then
    Result := 'COM82'
  else if Port = spCOM83 then
    Result := 'COM83'
  else if Port = spCOM84 then
    Result := 'COM84'
  else if Port = spCOM85 then
    Result := 'COM85'
  else if Port = spCOM86 then
    Result := 'COM86'
  else if Port = spCOM87 then
    Result := 'COM87'
  else if Port = spCOM88 then
    Result := 'COM88'
  else if Port = spCOM89 then
    Result := 'COM89'
  else if Port = spCOM90 then
    Result := 'COM90'
  else if Port = spCOM91 then
    Result := 'COM91'
  else if Port = spCOM92 then
    Result := 'COM92'
  else if Port = spCOM93 then
    Result := 'COM93'
  else if Port = spCOM94 then
    Result := 'COM94'
  else if Port = spCOM95 then
    Result := 'COM95'
  else if Port = spCOM96 then
    Result := 'COM96'
  else if Port = spCOM97 then
    Result := 'COM97'
  else if Port = spCOM98 then
    Result := 'COM98'
  else if Port = spCOM99 then
    Result := 'COM99'
  else if Port = spCOM100 then
    Result := 'COM100'
  else if Port = spCOM101 then
    Result := 'COM101'
  else if Port = spCOM102 then
    Result := 'COM102'
  else if Port = spCOM103 then
    Result := 'COM103'
  else if Port = spCOM104 then
    Result := 'COM104'
  else if Port = spCOM105 then
    Result := 'COM105'
  else if Port = spCOM106 then
    Result := 'COM106'
  else if Port = spCOM107 then
    Result := 'COM107'
  else if Port = spCOM108 then
    Result := 'COM108'
  else if Port = spCOM109 then
    Result := 'COM109'
  else if Port = spCOM110 then
    Result := 'COM110'
  else if Port = spCOM111 then
    Result := 'COM111'
  else if Port = spCOM112 then
    Result := 'COM112'
  else if Port = spCOM113 then
    Result := 'COM113'
  else if Port = spCOM114 then
    Result := 'COM114'
  else if Port = spCOM115 then
    Result := 'COM115'
  else if Port = spCOM116 then
    Result := 'COM116'
  else if Port = spCOM117 then
    Result := 'COM117'
  else if Port = spCOM118 then
    Result := 'COM118'
  else if Port = spCOM119 then
    Result := 'COM119'
  else if Port = spCOM120 then
    Result := 'COM120'
  else if Port = spCOM121 then
    Result := 'COM121'
  else if Port = spCOM122 then
    Result := 'COM122'
  else if Port = spCOM123 then
    Result := 'COM123'
  else if Port = spCOM124 then
    Result := 'COM124'
  else if Port = spCOM125 then
    Result := 'COM125'
  else if Port = spCOM126 then
    Result := 'COM126'
  else if Port = spCOM127 then
    Result := 'COM127'
  else if Port = spCOM128 then
    Result := 'COM128'
  else if Port = spCOM129 then
    Result := 'COM129'
  else if Port = spCOM130 then
    Result := 'COM130'
  else if Port = spCOM131 then
    Result := 'COM131'
  else if Port = spCOM132 then
    Result := 'COM132'
  else if Port = spCOM133 then
    Result := 'COM133'
  else if Port = spCOM134 then
    Result := 'COM134'
  else if Port = spCOM135 then
    Result := 'COM135'
  else if Port = spCOM136 then
    Result := 'COM136'
  else if Port = spCOM137 then
    Result := 'COM137'
  else if Port = spCOM138 then
    Result := 'COM138'
  else if Port = spCOM139 then
    Result := 'COM139'
  else if Port = spCOM140 then
    Result := 'COM140'
  else if Port = spCOM141 then
    Result := 'COM141'
  else if Port = spCOM142 then
    Result := 'COM142'
  else if Port = spCOM143 then
    Result := 'COM143'
  else if Port = spCOM144 then
    Result := 'COM144'
  else if Port = spCOM145 then
    Result := 'COM145'
  else if Port = spCOM146 then
    Result := 'COM146'
  else if Port = spCOM147 then
    Result := 'COM147'
  else if Port = spCOM148 then
    Result := 'COM148'
  else if Port = spCOM149 then
    Result := 'COM149'
  else if Port = spCOM150 then
    Result := 'COM150'
  else if Port = spCOM151 then
    Result := 'COM151'
  else if Port = spCOM152 then
    Result := 'COM152'
  else if Port = spCOM153 then
    Result := 'COM153'
  else if Port = spCOM154 then
    Result := 'COM154'
  else if Port = spCOM155 then
    Result := 'COM155'
  else if Port = spCOM156 then
    Result := 'COM156'
  else if Port = spCOM157 then
    Result := 'COM157'
  else if Port = spCOM158 then
    Result := 'COM158'
  else if Port = spCOM159 then
    Result := 'COM159'
  else if Port = spCOM160 then
    Result := 'COM160'
  else if Port = spCOM161 then
    Result := 'COM161'
  else if Port = spCOM162 then
    Result := 'COM162'
  else if Port = spCOM163 then
    Result := 'COM163'
  else if Port = spCOM164 then
    Result := 'COM164'
  else if Port = spCOM165 then
    Result := 'COM165'
  else if Port = spCOM166 then
    Result := 'COM166'
  else if Port = spCOM167 then
    Result := 'COM167'
  else if Port = spCOM168 then
    Result := 'COM168'
  else if Port = spCOM169 then
    Result := 'COM169'
  else if Port = spCOM170 then
    Result := 'COM170'
  else if Port = spCOM171 then
    Result := 'COM171'
  else if Port = spCOM172 then
    Result := 'COM172'
  else if Port = spCOM173 then
    Result := 'COM173'
  else if Port = spCOM174 then
    Result := 'COM174'
  else if Port = spCOM175 then
    Result := 'COM175'
  else if Port = spCOM176 then
    Result := 'COM176'
  else if Port = spCOM177 then
    Result := 'COM177'
  else if Port = spCOM178 then
    Result := 'COM178'
  else if Port = spCOM179 then
    Result := 'COM179'
  else if Port = spCOM180 then
    Result := 'COM180'
  else if Port = spCOM181 then
    Result := 'COM181'
  else if Port = spCOM182 then
    Result := 'COM182'
  else if Port = spCOM183 then
    Result := 'COM183'
  else if Port = spCOM184 then
    Result := 'COM184'
  else if Port = spCOM185 then
    Result := 'COM185'
  else if Port = spCOM186 then
    Result := 'COM186'
  else if Port = spCOM187 then
    Result := 'COM187'
  else if Port = spCOM188 then
    Result := 'COM188'
  else if Port = spCOM189 then
    Result := 'COM189'
  else if Port = spCOM190 then
    Result := 'COM190'
  else if Port = spCOM191 then
    Result := 'COM191'
  else if Port = spCOM192 then
    Result := 'COM192'
  else if Port = spCOM193 then
    Result := 'COM193'
  else if Port = spCOM194 then
    Result := 'COM194'
  else if Port = spCOM195 then
    Result := 'COM195'
  else if Port = spCOM196 then
    Result := 'COM196'
  else if Port = spCOM197 then
    Result := 'COM197'
  else if Port = spCOM198 then
    Result := 'COM198'
  else if Port = spCOM199 then
    Result := 'COM199'
  else if Port = spCOM200 then
    Result := 'COM200'
  else if Port = spCOM201 then
    Result := 'COM201'
  else if Port = spCOM202 then
    Result := 'COM202'
  else if Port = spCOM203 then
    Result := 'COM203'
  else if Port = spCOM204 then
    Result := 'COM204'
  else if Port = spCOM205 then
    Result := 'COM205'
  else if Port = spCOM206 then
    Result := 'COM206'
  else if Port = spCOM207 then
    Result := 'COM207'
  else if Port = spCOM208 then
    Result := 'COM208'
  else if Port = spCOM209 then
    Result := 'COM209'
  else if Port = spCOM210 then
    Result := 'COM210'
  else if Port = spCOM211 then
    Result := 'COM211'
  else if Port = spCOM212 then
    Result := 'COM212'
  else if Port = spCOM213 then
    Result := 'COM213'
  else if Port = spCOM214 then
    Result := 'COM214'
  else if Port = spCOM215 then
    Result := 'COM215'
  else if Port = spCOM216 then
    Result := 'COM216'
  else if Port = spCOM217 then
    Result := 'COM217'
  else if Port = spCOM218 then
    Result := 'COM218'
  else if Port = spCOM219 then
    Result := 'COM219'
  else if Port = spCOM220 then
    Result := 'COM220'
  else if Port = spCOM221 then
    Result := 'COM221'
  else if Port = spCOM222 then
    Result := 'COM222'
  else if Port = spCOM223 then
    Result := 'COM223'
  else if Port = spCOM224 then
    Result := 'COM224'
  else if Port = spCOM225 then
    Result := 'COM225'
  else if Port = spCOM226 then
    Result := 'COM226'
  else if Port = spCOM227 then
    Result := 'COM227'
  else if Port = spCOM228 then
    Result := 'COM228'
  else if Port = spCOM229 then
    Result := 'COM229'
  else if Port = spCOM230 then
    Result := 'COM230'
  else if Port = spCOM231 then
    Result := 'COM231'
  else if Port = spCOM232 then
    Result := 'COM232'
  else if Port = spCOM233 then
    Result := 'COM233'
  else if Port = spCOM234 then
    Result := 'COM234'
  else if Port = spCOM235 then
    Result := 'COM235'
  else if Port = spCOM236 then
    Result := 'COM236'
  else if Port = spCOM237 then
    Result := 'COM237'
  else if Port = spCOM238 then
    Result := 'COM238'
  else if Port = spCOM239 then
    Result := 'COM239'
  else if Port = spCOM240 then
    Result := 'COM240'
  else if Port = spCOM241 then
    Result := 'COM241'
  else if Port = spCOM242 then
    Result := 'COM242'
  else if Port = spCOM243 then
    Result := 'COM243'
  else if Port = spCOM244 then
    Result := 'COM244'
  else if Port = spCOM245 then
    Result := 'COM245'
  else if Port = spCOM246 then
    Result := 'COM246'
  else if Port = spCOM247 then
    Result := 'COM247'
  else if Port = spCOM248 then
    Result := 'COM248'
  else if Port = spCOM249 then
    Result := 'COM249'
  else if Port = spCOM250 then
    Result := 'COM250'
  else if Port = spCOM251 then
    Result := 'COM251'
  else if Port = spCOM252 then
    Result := 'COM252'
  else if Port = spCOM253 then
    Result := 'COM253'
  else if Port = spCOM254 then
    Result := 'COM254'
  else if Port = spCOM255 then
    Result := 'COM255'
  else
    Result := '';
end;

function TZylGSM.IntToBaudRate(const Value: Integer): TBaudRate;
begin
  if Value = 75 then
  begin
    Result := br000075;
  end
  else if Value = 110 then
  begin
    Result := br000110;
  end
  else if Value = 134 then
  begin
    Result := br000134;
  end
  else if Value = 150 then
  begin
    Result := br000150;
  end
  else if Value = 300 then
  begin
    Result := br000300;
  end
  else if Value = 600 then
  begin
    Result := br000600;
  end
  else if Value = 1200 then
  begin
    Result := br001200;
  end
  else if Value = 1800 then
  begin
    Result := br001800;
  end
  else if Value = 2400 then
  begin
    Result := br002400;
  end
  else if Value = 4800 then
  begin
    Result := br004800;
  end
  else if Value = 7200 then
  begin
    Result := br007200;
  end
  else if Value = 9600 then
  begin
    Result := br009600;
  end
  else if Value = 14400 then
  begin
    Result := br014400;
  end
  else if Value = 19200 then
  begin
    Result := br019200;
  end
  else if Value = 38400 then
  begin
    Result := br038400;
  end
  else if Value = 57600 then
  begin
    Result := br057600;
  end
  else if Value = 115200 then
  begin
    Result := br115200;
  end
  else if Value = 128000 then
  begin
    Result := br128000;
  end
  else if Value = 230400 then
  begin
    Result := br230400;
  end
  else if Value = 256000 then
  begin
    Result := br256000;
  end
  else if Value = 460800 then
  begin
    Result := br460800;
  end
  else
  begin
    Result := brCustom;
  end;
end;

function TZylGSM.BaudRateToInt(const pBaudRate: TBaudRate): Integer;
begin
  if pBaudRate = br000075 then
  begin
    Result := 75;
  end
  else if pBaudRate = br000110 then
  begin
    Result := 110;
  end
  else if pBaudRate = br000134 then
  begin
    Result := 134;
  end
  else if pBaudRate = br000150 then
  begin
    Result := 150;
  end
  else if pBaudRate = br000300 then
  begin
    Result := 300;
  end
  else if pBaudRate = br000600 then
  begin
    Result := 600;
  end
  else if pBaudRate = br001200 then
  begin
    Result := 1200;
  end
  else if pBaudRate = br001800 then
  begin
    Result := 1800;
  end
  else if pBaudRate = br002400 then
  begin
    Result := 2400;
  end
  else if pBaudRate = br004800 then
  begin
    Result := 4800;
  end
  else if pBaudRate = br007200 then
  begin
    Result := 7200;
  end
  else if pBaudRate = br009600 then
  begin
    Result := 9600;
  end
  else if pBaudRate = br014400 then
  begin
    Result := 14400;
  end
  else if pBaudRate = br019200 then
  begin
    Result := 19200;
  end
  else if pBaudRate = br038400 then
  begin
    Result := 38400;
  end
  else if pBaudRate = br057600 then
  begin
    Result := 57600;
  end
  else if pBaudRate = br115200 then
  begin
    Result := 115200;
  end
  else if pBaudRate = br128000 then
  begin
    Result := 128000;
  end
  else if pBaudRate = br230400 then
  begin
    Result := 230400;
  end
  else if pBaudRate = br256000 then
  begin
    Result := 256000;
  end
  else if pBaudRate = br460800 then
  begin
    Result := 460800;
  end
  else
  begin
    Result := FCustomBaudRate;
  end;
end;

function TZylGSM.GetBaudRate: TBaudRate;
begin
  Result := IntToBaudRate(FBaudRate);
end;

procedure TZylGSM.SetBaudRate(const Value: TBaudRate);
begin
  FBaudRate := BaudRateToInt(Value);

  if Assigned(ComThread) then
    SetDCBState((ComThread as TComThread).ComDevice);
end;

procedure TZylGSM.SetCustomBaudRate(const Value: Integer);
begin
  FCustomBaudRate := Value;
  if BaudRate = brCustom then
  begin
    FBaudRate := FCustomBaudRate;
    if Assigned(ComThread) then
      SetDCBState((ComThread as TComThread).ComDevice);
  end;
end;

function TZylGSM.GetDataWidth: TDataWidth;
begin
  if FDataWidth = 5 then
    Result := dw5Bits
  else if FDataWidth = 6 then
    Result := dw6Bits
  else if FDataWidth = 7 then
    Result := dw7Bits
  else
    Result := dw8Bits;
end;

procedure TZylGSM.SetDataWidth(const Value: TDataWidth);
begin
  if Value = dw5Bits then
  begin
    if FStopBits <> 2 then
      FDataWidth := 5
    else
      raise Exception.Create('Invalid data-width and stop-bits combination.');
  end
  else if Value = dw6Bits then
  begin
    if FStopBits <> 1 then
      FDataWidth := 6
    else
      raise Exception.Create('Invalid data-width and stop-bits combination.');
  end
  else if Value = dw7Bits then
  begin
    if FStopBits <> 1 then
      FDataWidth := 7
    else
      raise Exception.Create('Invalid data-width and stop-bits combination.');
  end
  else
  begin
    if FStopBits <> 1 then
      FDataWidth := 8
    else
      raise Exception.Create('Invalid data-width and stop-bits combination.');
  end;

  if Assigned(ComThread) then
    SetDCBState((ComThread as TComThread).ComDevice);
end;

function TZylGSM.GetParity: TParityBits;
begin
  Result := pbNone;
  if FParity = 0 then
    Result := pbNone
  else if FParity = 1 then
    Result := pbOdd
  else if FParity = 2 then
    Result := pbEven
  else if FParity = 3 then
    Result := pbMark
  else if FParity = 4 then
    Result := pbSpace;
end;

procedure TZylGSM.SetParity(const Value: TParityBits);
begin
  if Value = pbNone then
    FParity := 0
  else if Value = pbOdd then
    FParity := 1
  else if Value = pbEven then
    FParity := 2
  else if Value = pbMark then
    FParity := 3
  else if Value = pbSpace then
    FParity := 4;

  if Assigned(ComThread) then
    SetDCBState((ComThread as TComThread).ComDevice);
end;

function TZylGSM.GetStopBits: TStopBits;
begin
  Result := sb1Bit;
  if FStopBits = 0 then
    Result := sb1Bit
  else if FStopBits = 1 then
    Result := sb1_5Bits
  else if FStopBits = 2 then
    Result := sb2Bits;
end;

procedure TZylGSM.SetStopBits(const Value: TStopBits);
begin
  if Value = sb1Bit then
  begin
    FStopBits := 0;
  end
  else if Value = sb1_5Bits then
  begin
    if (FDataWidth <> 6) and  (FDataWidth <> 7) and (FDataWidth <> 8) then
      FStopBits := 1
    else
      raise Exception.Create('Invalid data-width and stop-bits combination.');
  end
  else if Value = sb2Bits then
  begin
    if (FDataWidth <> 5) then
      FStopBits := 2
    else
      raise Exception.Create('Invalid data-width and stop-bits combination.');
  end;

  if Assigned(ComThread) then
    SetDCBState((ComThread as TComThread).ComDevice);
end;

procedure TZylGSM.SetEnableDTROnOpen(const Value: Boolean);
begin
  if FEnableDTROnOpen <> Value then
  begin
    FEnableDTROnOpen := Value;
    if Assigned(ComThread) then
      SetDCBState((ComThread as TComThread).ComDevice);
  end;
end;

procedure TZylGSM.SetEnableRTSOnOpen(const Value: Boolean);
begin
  if FEnableRTSOnOpen <> Value then
  begin
    FEnableRTSOnOpen := Value;
    if Assigned(ComThread) then
      SetDCBState((ComThread as TComThread).ComDevice);
  end;
end;

procedure TZylGSM.SetHwFlowControl(const Value: THwFlowControl);
begin
  if FHwFlowControl <> Value then
  begin
    FHwFlowControl := Value;
    if Assigned(ComThread) then
      SetDCBState((ComThread as TComThread).ComDevice);
  end;
end;

procedure TZylGSM.SetSwFlowControl(const Value: TSwFlowControl);
begin
  if FSwFlowControl <> Value then
  begin
    FSwFlowControl := Value;
    if Assigned(ComThread) then
      SetDCBState((ComThread as TComThread).ComDevice);
  end;
end;

function TZylGSM.GetCommPort: TCommPort;
begin
  Result := StringToCommPort(FPort);
end;

procedure TZylGSM.SetCommPort(const Value: TCommPort);
//var
//  IsActiv: Boolean;
begin
  if (StringToCommPort(FPort) <> Value) then
  begin
    {if Assigned(ComThread) then
    begin
      IsActiv := True;
      Self.Close;
    end
    else
    begin
      IsActiv := False;
    end;}

    FPort := CommPortToString(Value);

    {if IsActiv then
    begin
      if Value <> spNone then
      begin
        Self.Open;
      end
      else
      begin
        raise Exception.Create('Invalid port.');
      end;
    end;}
  end;
end;

procedure TZylGSM.SetPriority(const Value: TThreadPriority);
begin
  if FPriority <> Value then
  begin
    FPriority := Value;
    if Assigned(ComThread) then
      ComThread.Priority := FPriority;
  end;
end;

function TZylGSM.SetDCBState(const ComDevice: THandle): Boolean;
var
  dcbSerialParams: TDCB;
begin
  Result := True;
  if ComDevice <> INVALID_HANDLE_VALUE then
  begin
    //GetCommState(ComDevice, dcbSerialParams);
    // Clear all
    FillChar(dcbSerialParams, sizeof(dcbSerialParams), 0);

    dcbSerialParams.DCBlength := sizeof(DCB);
    dcbSerialParams.BaudRate := FBaudRate;
    dcbSerialParams.ByteSize := FDataWidth;
    dcbSerialParams.StopBits := FStopBits;
    dcbSerialParams.Parity := FParity;

    dcbSerialParams.Flags := dcb_Binary;
    // Enables the DTR line when the device is opened and leaves it on
    if FEnableDTROnOpen then
      dcbSerialParams.Flags := dcbSerialParams.Flags or dcb_DtrControlEnable;

    if FEnableRTSOnOpen then
      dcbSerialParams.Flags := dcbSerialParams.Flags or dcb_RtsControlEnable;

    // Kind of hw flow control to use
    case FHwFlowControl of
      // No hw flow control
      hfNONE:;
      // No hw flow control but set RTS high and leave it high
      hfRTS:
        dcbSerialParams.Flags := dcbSerialParams.Flags or dcb_RtsControlEnable;
      // RTS/CTS (request-to-send/clear-to-send) flow control
      hfRTSCTS:
        dcbSerialParams.Flags := dcbSerialParams.Flags or dcb_OutxCtsFlow or dcb_RtsControlHandshake;
    end;
    // Kind of sw flow control to use
    case FSwFlowControl of
      // No sw flow control
      sfNONE:;
      // XON/XOFF sw flow control
      sfXONXOFF:
        dcbSerialParams.Flags := dcbSerialParams.Flags or dcb_OutX or dcb_InX;
    end;

    // XON ASCII char - DC1, Ctrl-Q, ASCII 17
    dcbSerialParams.XONChar := #17;
    // XOFF ASCII char - DC3, Ctrl-S, ASCII 19
    dcbSerialParams.XOFFChar := #19;

    try
      if not SetCommState(ComDevice, dcbSerialParams) then
      begin
        Result := False;
        Close;
      end;
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;
end;

function TZylGSM.SetDCBState(const pComDevice: THandle; const pBaudRate: TBaudRate): Boolean;
var
  dcbSerialParams: TDCB;
begin
  try
    GetCommState(pComDevice, dcbSerialParams);
    dcbSerialParams.DCBlength := sizeof(DCB);
    dcbSerialParams.BaudRate := BaudRateToInt(pBaudRate);
    dcbSerialParams.ByteSize := 8;
    dcbSerialParams.StopBits := 0;
    dcbSerialParams.Parity := 0;

    dcbSerialParams.Flags := dcb_Binary;
    dcbSerialParams.Flags := dcbSerialParams.Flags or dcb_DtrControlEnable;
    dcbSerialParams.Flags := dcbSerialParams.Flags or dcb_RtsControlEnable;

    Result := SetCommState(pComDevice, dcbSerialParams);
  except
    Result := False;
  end;
end;

function TZylGSM.SetTimeOuts(const ComDevice: THandle): Boolean;
var
  toStruct: CommTimeOuts;
begin
  Result := True;
  if ComDevice <> INVALID_HANDLE_VALUE then
  begin
    toStruct.ReadIntervalTimeout := FReadIntervalTimeout;
    toStruct.ReadTotalTimeoutMultiplier := FReadTotalTimeoutMultiplier;
    toStruct.ReadTotalTimeoutConstant := FReadTotalTimeoutConstant;
    toStruct.WriteTotalTimeoutMultiplier := FWriteTotalTimeoutMultiplier;
    toStruct.WriteTotalTimeoutConstant := FWriteTotalTimeoutConstant;
    try
      if not SetCommTimeOuts(ComDevice, toStruct) then
        Result := False;
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;
end;

procedure TZylGSM.Open();
begin
  if StringToCommPort(FPort) <> ConnectedTo then
  begin
    if not FRegistered then
    begin
      SysUtils.Beep;
   (*   {$ifndef CPPB5}
      MessageDlg('ZylGSM - Demo version by Zyl Soft.', mtInformation, [mbOK], 0);
      {$endif}
      if not RunningInTheIDE() then
      begin
        {$ifndef CPPB5}
        MessageDlg('ZylGSM - Demo version runs only with Delphi or C++Builder IDE.', mtInformation, [mbOK], 0);
        Application.Terminate;
        {$else}
        System.Halt;
        {$endif}
        Exit;
      end;*)
    end;

    if Assigned(ComThread) then
    begin
      Self.Close();
    end;

    ComThread := TComThread.Create(Self);
    if not Assigned(ComThread) or (ConnectedTo = spNone) then
    begin
      if Assigned(ComThread) then
        Self.Close();

      raise Exception.Create(Format(sCannotConnect, [FPort, SysUtils.SysErrorMessage(GetLastError)]));
    end;

    if Assigned(ComThread) and (ConnectedTo <> spNone) then
    begin
      FLastReceived := 0;
      Sleep(50);
      if SendString('AT+CLIP=1;+CRC=1'#13) = 0 then
      begin
        Sleep(100);
        SendString('AT+CLIP=1;+CRC=1'#13);
      end;
      Sleep(100);
      SendString('AT+CNMI=2,1,0,0,0'#13);
      Sleep(100);
    end;
  end;  
end;

procedure TZylGSM.Close();
var
  nTimeout : Integer;
begin
  if Assigned(ComThread) then
  begin
    ComThread.Terminate;
    nTimeout := 0;
    while (ConnectedTo <> spNone) and (nTimeout < 500) do
    begin
      {$ifndef CPPB5}
      Application.ProcessMessages();
      {$endif}

      if nTimeout = 0 then
        Sleep(FDelay)
      else
        Sleep(15);

      nTimeout := nTimeout + 1;
    end;

    ComThread := nil;
  end
  else
  begin
    ConnectedTo := spNone;
  end;
end;

destructor TZylGSM.Destroy;
begin
  if Assigned(ComThread) then
    ComThread.Terminate;
  CriticalSection.Free;  
  inherited;
end;

function TZylGSM.IsConnected: TCommPort;
begin
  Result := ConnectedTo;
end;

constructor TComThread.Create(AOwner: TZylGSM);
begin
  inherited Create(False);

  Owner := AOwner;

  Owner.ConnectedTo := spNone;
  FreeOnTerminate := True;
  Priority := Owner.FPriority;

  try
    ComDevice := CreateFileA(PAnsiChar('\\.\' + Owner.FPort), GENERIC_READ or GENERIC_WRITE, 0, Nil, OPEN_EXISTING, 0, 0);
  except
    Owner.Close();
    Exit;
  end;

  if ComDevice = INVALID_HANDLE_VALUE then
  begin
    Owner.Close();
    Exit;
  end;

  try
    Owner.SetDCBState(ComDevice);
    Owner.SetTimeOuts(ComDevice);
    Owner.SetBuffers(ComDevice);
  except
    Owner.Close();
    Exit;
  end;

  Owner.ConnectedTo := Owner.StringToCommPort(Owner.FPort);

  if Assigned(Owner.FOnConnect) and (Owner.ConnectedTo <> spNone) then
    Owner.FOnConnect(Owner, Owner.ConnectedTo);
end;

function TComThread.GetPortHandle: THandle;
begin
  Result := ComDevice;
end;

destructor TComThread.Destroy;
begin
  try
    if Assigned(Owner) and not (csDestroying in Owner.ComponentState) and
       Assigned(Owner.FOnDisconnect) and (Owner.ConnectedTo <> spNone) then
      Owner.FOnDisconnect(Owner, Owner.ConnectedTo);
  except
  end;

  try
    if ComDevice <> INVALID_HANDLE_VALUE then
      PurgeComm(ComDevice, PURGE_RXCLEAR or PURGE_TXCLEAR or PURGE_RXABORT or PURGE_TXABORT);
  except
  end;

  try
    if ComDevice <> INVALID_HANDLE_VALUE then
    begin
      CloseHandle(ComDevice);
      ComDevice := INVALID_HANDLE_VALUE;
    end;
  except
  end;

  if Assigned(Owner) and not (csDestroying in Owner.ComponentState) then
    Owner.ConnectedTo := spNone;

  inherited Destroy;
end;

procedure TComThread.Execute;
var
  dwBytesRead: Cardinal;
  dwErrorCode: Cardinal;
  statPort: TCOMSTAT;
  dwBytesAvailable: Cardinal;
  strRead: AnsiString;
  {$ifdef UNICODE}
  pstrTmp: PAnsiChar;
  {$endif}
  nCounter: Integer;
begin
  nCounter := 1;
  while not Terminated and (ComDevice <> INVALID_HANDLE_VALUE) do
  begin
    if not Terminated and (ComDevice <> INVALID_HANDLE_VALUE) then
    begin
      CriticalSection.Enter;
      try
        dwErrorCode := 0;
        ClearCommError(ComDevice, dwErrorCode, @statPort);

        dwBytesAvailable := statPort.cbInQue;
        if not Terminated and (ComDevice <> INVALID_HANDLE_VALUE) and (dwBytesAvailable > 0) then
        begin
          {$ifndef UNICODE}
          SetLength(strRead, dwBytesAvailable + 1);
          ReadFile(ComDevice, PAnsiChar(strRead)^, dwBytesAvailable, dwBytesRead, Nil);
          {$else}
          GetMem(pstrTmp, dwBytesAvailable);
          try
            ReadFile(ComDevice, pstrTmp^, dwBytesAvailable, dwBytesRead, Nil);
            strRead := StrPas(pstrTmp);
          finally
            FreeMem(pstrTmp, dwBytesAvailable);
          end;
          {$endif}

          Owner.FLastReceived := Now;

          {$ifndef UNICODE}
          if not Terminated and (dwBytesRead > 0) then
          begin
            SetLength(strRead, dwBytesRead);
          end;
          {$endif}

          if nCounter mod 2 = 1 then
          begin
            Owner.FReadBuffer := UpperCase(strRead);
          end
          else
          begin
            Owner.FReadBuffer := Owner.FReadBuffer + UpperCase(strRead);
          end;
        end;
      except
      end;
      CriticalSection.Leave;
    end;

    if (nCounter mod 2 = 0) and (Length(Owner.FReadBuffer) > 0) then
    begin
      if Owner.FNeedSynchronization then
        Synchronize(Owner.ProcessAT)
      else
        Owner.ProcessAT;
    end;

    if not Terminated and (ComDevice <> INVALID_HANDLE_VALUE) then
      Sleep(Owner.FDelay);
    nCounter := nCounter + 1;

    if nCounter = 11 then
      nCounter := 1; 
  end;
end;

function TZylGSM.SendString(const str: AnsiString): Cardinal;
var
  dwBytesWritten: Cardinal;
begin
  dwBytesWritten := 0;
  if (ComThread <> nil) and ((ComThread as TComThread).GetPortHandle() <> INVALID_HANDLE_VALUE) then
  begin
    CriticalSection.Enter;
    try
      WriteFile((ComThread as TComThread).GetPortHandle, PAnsiChar(Str)^, strLen(PAnsiChar(str)), dwBytesWritten, Nil);

      if Assigned(FOnSend) then
      begin
        FOnSend(Self, Copy(str, 1, dwBytesWritten));
      end;
    except
      raise Exception.Create(FPort + ' is not open.');
    end;
    CriticalSection.Leave;
  end
  else
  begin
    raise Exception.Create(FPort + ' is not open.');
  end;
  Result := dwBytesWritten;
end;

function TZylGSM.SetBuffers(const ComDevice: THandle): Boolean;
begin
  if ComDevice <> INVALID_HANDLE_VALUE then
  begin
    try
      Result := SetupComm(ComDevice, FInputBuffer, FOutputBuffer);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;
end;

function TZylGSM.GetExistingCommPorts: TCommPortSet;
var
  reg: TRegistry;
  lst: TStringList;
  i: Integer;
  pCom: TCommPort;
begin
  Result  := [];
  reg := TRegistry.Create();
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM') then
  begin
    lst := TStringList.Create();
    reg.GetValueNames(lst);
    for i := 0 to lst.Count - 1 do
    begin
      pCom := StringToCommPort(reg.ReadString(lst[i]));
      if pCom <> spNone then
        Result := Result +  [pCom]
    end;
    lst.Free();
    reg.CloseKey();
  end;
  reg.Free();
end;

function TZylGSM.SafeCopy(const strText: AnsiString; nStart, nLength: Integer; const DefaultValue: AnsiString): AnsiString;
begin
  if (nStart > 0) and (nLength > 0) and (nStart + nLength - 1 <= Length(strText)) then
    Result := Copy(strText, nStart, nLength)
  else
    Result := DefaultValue;
end;

// AT---------------------------------------------------------------------------------

procedure TZylGSM.DialVoice(PhoneNumber: AnsiString);
begin
  SendString('ATD' + PhoneNumber + ';' + #13);
  Sleep(100);
end;

procedure TZylGSM.DialData(PhoneNumber: AnsiString);
begin
  SendString('ATD' + PhoneNumber + #13);
  Sleep(100);
end;

procedure TZylGSM.AnswerCall;
begin
  SendString('ATA' + #13);
  Sleep(100);
end;

procedure TZylGSM.TerminateCall;
begin
  SendString('AT+CHUP' + #13);
  Sleep(100);
end;

procedure TZylGSM.GetSMS(Location: AnsiString; Index: Integer);
begin
  SendString('AT+CPMS="' + Location + '"' + #13);
  Sleep(100);
  SendString('AT+CMGR=' + IntToStr(Index) + #13);
  Sleep(100);
end;

procedure TZylGSM.DeleteSMS(Location: AnsiString; Index: Integer);
begin
  SendString('AT+CPMS="' + Location + '"' + #13);
  Sleep(100);
  if Index >= 0 then
  begin
    SendString('AT+CMGD=' + IntToStr(Index) + #13);
  end
  else
  if (Index <= -1) and (Index >= -4)  then
  begin
    SendString('AT+CMGD=' + IntToStr(Index) + ',' + IntToStr(Abs(Index)) + #13);
  end;
  Sleep(100);
end;

procedure TZylGSM.SendSmsAsText(PhoneNumber, CenterNumber, MessageText: AnsiString);
begin
  // reset completely the previous request
  SendString(#27);
  Sleep(100);

  // starting
  SendString('AT'#13);
  Sleep(100);

  // set message format to text
  SendString('AT+CMGF=1'#13);
  Sleep(100);

  // set service center address
  if Trim(CenterNumber) <> '' then
  begin
    SendString('AT+CSCA="' + CenterNumber + '"'#13);
    Sleep(100);
  end;

  // send message
  SendString('AT+CMGS="' + PhoneNumber + '"'+#13);
  Sleep(100);
  SendString(MessageText + #26);
  Sleep(100);
end;

procedure TZylGSM.SendSmsAsPDU(PhoneNumber, CenterNumber, MessageText: AnsiString);
var
  msgPDU: TPDUSMS;
begin
  // reset completely the previous request
  SendString(#27);
  Sleep(100);

  // starting
  SendString('AT'#13);
  Sleep(100);

  // set message format to PDU
  SendString('AT+CMGF=0'#13); //PDU mode
  Sleep(100);

  // set service center address
  if Trim(CenterNumber) <> '' then
  begin
    SendString('AT+CSCA="' + CenterNumber + '"'#13);
    Sleep(100);
  end;

  // send message
  msgPDU := StringToPDUSMS(PhoneNumber, CenterNumber, MessageText);
  SendString('AT+CMGS=' + msgPDU.Length + #13);
  Sleep(100);
  SendString(msgPDU.Data + #26);
  Sleep(100);
end;

function TZylGSM.StringToPDU(str: AnsiString): AnsiString;
var
  i, InLen, OutLen, OutPos : Integer;
  RoundUp : Boolean;
  tempByte, nextByte : Byte;
begin
  // check for empty input
  if str = '' then
  begin
    Result := '';
    Exit;
  end;

  // init output string position
  OutPos := 1;

  // set length of output string
  InLen := Length(str);
  if InLen > 160 then
  begin
    str := Copy(str, 1, 160);
  end;

  RoundUp := (InLen * 7 mod 8) <> 0;
  OutLen := InLen * 7 div 8;
  if RoundUp then
    OutLen := OutLen + 1;
  SetLength(Result, OutLen);

  // encode output string
  for i := 1 to InLen do
  begin
    tempByte := Byte(str[i]);
    if (tempByte and $80) <> 0 then
      raise Exception.Create('Input string contains 8-bit data.');
    if (i < InLen) then
      nextByte := Byte(str[i + 1])
    else
      nextByte := 0;
    tempByte := tempByte shr ((i-1) mod 8);
    nextByte := nextByte shl (8 - (i mod 8));
    tempByte := tempByte or nextByte;
    Result[OutPos] := AnsiChar(tempByte);
    if i mod 8 <> 0 then
      OutPos := OutPos + 1;
  end;
end;

function TZylGSM.PDUToString(str: AnsiString): AnsiString;
{var
  i, InLen, OutLen, OutPos : Integer;
  tempByte, prevByte : Byte;}
var
  Converter: TSms;
begin
  Converter:=TSms.Create;
  try
    Converter.PDU:=str;
    Result:=Converter.Text+#13#10+
            Converter.MessageReference+#13#10+
            Converter.Number+#13#10+
            Converter.SMSC+#13#10+
            DateTimeToStr(Converter.TimeStamp);
  finally
    Converter.Free;
  end;
{    // check for empty input
    if str = '' then
      Exit;

    // init variables
    prevByte := 0;
    OutPos := 1;

    // set length of output string
    InLen := Length(str);
    // check if input string greater than 140 characters
    if InLen > 140 then
      str := Copy(str, 1, 140);

    OutLen := (InLen * 8) div 7;
    SetLength(Result, OutLen);

    // encode output string
    for i := 1 to InLen do
    begin
      tempByte := Byte(str[i]);
      tempByte := tempByte and not ($FF shl (7 - ((i - 1) mod 7)));
      tempByte := tempByte shl ((i - 1) mod 7);
      tempByte := tempByte or prevByte;
      Result[OutPos] := AnsiChar(tempByte);
      OutPos := OutPos + 1;

      // set prevByte for next round (or directly put it to Result)
      prevByte := Byte(str[i]);
      prevByte := prevByte shr (7 - ((i - 1) mod 7));
      if (i mod 7) = 0 then
      begin
        Result[OutPos] := AnsiChar(prevByte);
        OutPos := OutPos + 1;
        prevByte := 0;
      end;
    end;
    if Result[Length(Result)] = #0 then
      Result := Copy(Result, 1, Length(Result) - 1);}
end;

function TZylGSM.StringToPDUSMS(PhoneNumber, CenterNumber, MessageText: AnsiString): TPDUSMS;
var
  nLength, i: Integer;
  str: AnsiString;
  isInternationalCenterNumber: Boolean;
  isInternationalPhoneNumber: Boolean;
begin
  // clean CenterNumber from unwanted chars
  isInternationalCenterNumber := False;
  if (Length(CenterNumber) > 0) and (CenterNumber[1] = '+') then
  begin
    Delete(CenterNumber, 1, 1);
    isInternationalCenterNumber := True;
  end;
  if (Length(CenterNumber) > 1) and (CenterNumber[1] = '0') and (CenterNumber[2] = '0') then
  begin
    Delete(CenterNumber, 1, 2);
    isInternationalCenterNumber := True;
  end;

  // clean PhoneNumber from unwanted chars
  isInternationalPhoneNumber := False;
  if (Length(PhoneNumber) > 0) and (PhoneNumber[1] = '+') then
  begin
    Delete(PhoneNumber, 1, 1);
    isInternationalPhoneNumber := True;
  end;

  if (Length(PhoneNumber) > 1) and (PhoneNumber[1] = '0') and (PhoneNumber[2] = '0') then
  begin
    Delete(PhoneNumber, 1, 2);
    isInternationalPhoneNumber := True;
  end;

  // write the SMS Center information
  if Trim(CenterNumber) = '' then
  begin
    // write length of SMS Center information. Here the length is 0, which means that the SMS Center stored in the phone should be used
    Result.Data := '00';
  end
  else
  begin
    nLength := Length(CenterNumber);
    if Odd(nLength) then
      // if the length of the phone number is odd, then a trailing F has been added to form proper octets
      nLength := nLength + 1;
    // length of the SMS Center information in octect
    nLength := 1 + (nLength div 2);

    // write the length of the SMS Center information
    if nLength < 10 then
      Result.Data := '0' + IntToStr(nLength)
    else
      Result.Data := IntToStr(nLength);

    // write the type of address of the SMS Center
    if isInternationalCenterNumber then
      // 91 means international format of the phone number
      Result.Data := Result.Data + '91'
    else
      // 81 means national format of the phone number
      Result.Data := Result.Data + '81';

    // write SMS Center to PDU message (in decimal semi-octets)
    nLength := Length(CenterNumber);
    i := 1;
    while i < nLength do
    begin
      Result.Data := Result.Data + CenterNumber[i + 1] + CenterNumber[i];
      i := i + 2;
    end;

    // if the length of the phone number is odd, then a trailing F has been added to form proper octets
    if Odd(nLength) then
      Result.Data := Result.Data + 'F' + CenterNumber[nLength];
  end;

  // write the first octet of the SMS SUBMIT message
  Result.Data := Result.Data + '11';

  // write the TP message reference. "00" value lets the phone set the message reference number itself
  Result.Data := Result.Data + '00';

  // write the address length (length of phone number)
  Result.Data := Result.Data + Format ('%02.2x', [Length(PhoneNumber)]);

  // write the type of address
  if isInternationalPhoneNumber then
    // 91 indicates international format of the phone number
    Result.Data := Result.Data + '91'
  else
    // 81 indicates national format of the phone number
    Result.Data := Result.Data + '81';

  // write the phone number in semi octets
  nLength := Length(PhoneNumber);
  i := 1;
  while i < nLength do
  begin
    Result.Data := Result.Data + PhoneNumber[i + 1] + PhoneNumber[i];
    i := i + 2;
  end;

  // if the length of the phone number is odd, then a trailing F has been added
  if Odd(nLength) then
    Result.Data := Result.Data + 'F' + PhoneNumber[nLength];

  // TP PID - protocol identifier
  Result.Data := Result.Data + '00';

  // TP DCS. Data coding scheme. This message is coded according to the 7bit default alphabet.
  // Having "04" instead of "00" here, would indicate that the TP User Data field of this message
  // should be interpreted as 8bit rather than 7bit (used in smart messaging, OTA provisioning etc)
  Result.Data := Result.Data + '00';

  // TP validity period. "AA" means 4 days. This octet is optional, see bits 4 and 3 of the first octet
  Result.Data := Result.Data + 'AA';

  // length of SMS message converted to hexa
  Result.Data := Result.Data + Format ('%02.2x', [Length(MessageText)]);

  // add SMS message after transformation to PDU string
  str := StringToPDU(MessageText);
  for i := 1 to Length(str) do
    Result.Data := Result.Data + IntToHex(Byte(str[i]), 2);

  // set SMS length
  if Length(Result.Data) >= 2 then
    str := Copy(Result.Data, 1, 2)
  else if Length(Result.Data) = 1 then
    str := Copy(Result.Data, 1, 1)
  else
    str := '0';  

  if not TryStrToInt(str, nLength) then
    nLength := 0;
  nLength := (Length(Result.Data) div 2) - nLength - 1;
  Result.Length := IntToStr(nLength);
end;

function TZylGSM.PDUSMSToString(MessageText: AnsiString; var PhoneNumber, CenterNumber: AnsiString): AnsiString;
var
  nLength, i: Integer;
  str: AnsiString;
begin
  // init
  PhoneNumber := '';
  CenterNumber := '';
  Result := '';
  i := 1;

  // length of the center number
  str := SafeCopy(MessageText, i, 2, '0');

  if not TryStrToInt(str, nLength) then
    nLength := 0;

  i := i + 2;
  if nLength > 0 then
  begin
    // type of address of the SMS Center (91 means international format of the phone number)
    i := i + 2;

    // service center number (in decimal semi-octets). The length of the phone number is odd,
    // so a trailing F has been added to form proper octets.
    while i < (nLength * 2 + 3) do
    begin
      if MessageText[i] = 'F' then
        CenterNumber := CenterNumber + MessageText[i + 1]
      else
        CenterNumber := CenterNumber + MessageText[i + 1] + MessageText[i];
      i := i + 2;
    end;
  end
  else
    Exit;

  // first octet of this SMS DELIVER message.
  i := i + 2;

  // length of the sender number
  str := SafeCopy(MessageText, i, 2, '0');

  nLength := StrToInt('$' + str);
  i := i + 2;

  // type of address of the sender number
  i := i + 2;

  // change nLength to octets
  if Odd(nLength) then
    nLength := nLength + 1;
  nLength := nLength + i;
  while i < nLength do
  begin
    if MessageText[i] = 'F' then
      PhoneNumber := PhoneNumber + MessageText[i + 1]
    else
      PhoneNumber := PhoneNumber + MessageText[i + 1] + MessageText[i];
    i := i + 2;
  end;

  // TP PID - Protocol identifier.
  i := i + 2;

  // TP DCS Data coding scheme
  i := i + 2;

  // TP SCTS - Time stamp (semi-octets)
  i := i + 14;

  // TP UDL - User data length, length of message. The TP DCS field indicated 7-bit data,
  // so the length here is the number of septets. If the TP DCS field were set to
  // indicate 8bit data or Unicode, the length would be the number of octets.
  i := i + 2;

  nLength := Length(MessageText);

  // set pointer to start of message
  str := '';
  while i <= nLength do
  begin
    str := str + AnsiChar(StrToInt('$' + MessageText[i] + MessageText[i + 1]));
    i := i + 2;
  end;

  // change message to string
  Result := PDUToString(MessageText);
end;

procedure TZylGSM.ProcessAT();
var
  strBuffer: AnsiString;
begin
  if Assigned(ComThread) then
  begin
    strBuffer := FReadBuffer;
    FReadBuffer := '';
    if Assigned(FOnReceive) then
      FOnReceive(Self, strBuffer);

    // check for events
    HandleGSMEvents(strBuffer);
  end;  
end;

procedure TZylGSM.HandleGSMEvents(strAT: AnsiString);
var
  nPos: Integer;
  strClip: AnsiString;
  strStorage: AnsiString;
  memPos: Integer;
  strMessage, strPhoneNumber, strCenterNumber: AnsiString;
  nStatus: Integer;
begin
  if Pos('RING', strAT) > 0 then //incoming call
  begin
    strClip := '';
    nPos := Pos('+CLIP:', strAT);
    if nPos > 0 then
    begin
      strClip := SafeCopy(strAT, nPos, Length(strAT) - nPos + 1, '');
      nPos := Pos('"', strClip);
      if nPos > 0 then
      begin
        strClip := SafeCopy(strClip, nPos + 1, Length(strClip) - nPos, '');
        nPos := Pos('"', strClip);
        if nPos > 0 then
        begin
          strClip := SafeCopy(strClip, 1, nPos - 1, '');
        end
        else
        begin
          strClip := '';
        end;
      end
      else
      begin
        strClip := '';
      end;
    end;

    if Assigned(FOnRing) then
      FOnRing(Self, strClip);
  end
  else if Pos('+CMTI', strAT) > 0 then //new SMS
  begin
    strStorage := Phone_SIM;
    memPos := 0;
    nPos := Pos('+CMTI:', strAT);
    if nPos > 0 then
    begin
      strClip := SafeCopy(strAT, nPos, Length(strAT) - nPos + 1, '');
      nPos := Pos('"', strClip);
      if nPos > 0 then
      begin
        strClip := SafeCopy(strClip, nPos + 1, Length(strClip) - nPos, '');
        nPos := Pos('"', strClip);
        if nPos > 0 then
        begin
          strStorage := SafeCopy(strClip, 1, nPos - 1, '');
          strClip := SafeCopy(strAT, nPos, Length(strAT) - nPos + 1, '');
          nPos := Pos(',', strClip);
          if nPos > 0 then
          begin
            strClip := SafeCopy(strClip, nPos + 1, Length(strClip) - nPos - 2, '');
            if TryStrToInt(strClip, memPos) then
            begin
              if FAutoReadNewMessage then
                GetSMS(strStorage, memPos);
            end;
          end;
        end;
      end;
    end;

    if Assigned(FOnNewMessage) then
      FOnNewMessage(Self, strStorage, memPos);
  end
  else if Pos('+CMGR:', strAT) > 0 then //read SMS
  begin
    strMessage := '';
    nPos := Pos('+CMGR:', strAT);
    if nPos > 0 then
    begin
      strClip := SafeCopy(strAT, nPos + 6, Length(strAT) - nPos - 5, '');

      nPos := Pos(',', strClip);
      if not TryStrToInt(Trim(SafeCopy(strClip, 1, nPos - 1, '-1')), nStatus) then
        nStatus := -1;

      nPos := Pos(#13#10, strClip);
      if nPos > 0 then
        strMessage := SafeCopy(strClip, nPos + 2, Length(strClip) - nPos - 1, '');
      nPos := Pos(#13#10, strMessage);
      if nPos > 0 then
        strMessage := SafeCopy(strMessage, 1, nPos - 1, '');
    end;
    if Trim(strMessage) <> '' then
    begin
      strMessage := PDUSMSToString(strMessage, strPhoneNumber, strCenterNumber);
      if Assigned(FOnReadMessage) then
        FOnReadMessage(Self, strMessage, strPhoneNumber, strCenterNumber, nStatus);
    end;
  end;
end;

function TZylGSM.DetectGSM(const startBaudRate, endBaudRate: TBaudRate; var pPort: TCommPort;
  var pBaudRate: TBaudRate): Boolean;
var
  i: TCommPort;
  j: TBaudRate;
  pComDevice: THandle;
  dwBytesRead: DWORD;
  dwErrorCode: DWORD;
  statPort: TCOMSTAT;
  dwBytesAvailable: DWORD;
  strRead: AnsiString;
  {$ifdef UNICODE}
  pstrTmp: PAnsiChar;
  {$endif}
  portSet: TCommPortSet;
  k: Integer;
  atCounter: Integer;
  strBuffer: AnsiString;
  strAT: AnsiString;
  dwBytesWritten: Cardinal;
begin
  FCancelDetect := False;
  pPort := spNone;
  Result := False;
  pComDevice := INVALID_HANDLE_VALUE;

  portSet := GetExistingCommPorts();

  for i := spCOM1 to spCOM255 do
  begin
    if i in portSet then
    begin
      try
        if pComDevice <> INVALID_HANDLE_VALUE then
        begin
          try
            PurgeComm(pComDevice, PURGE_RXCLEAR or PURGE_TXCLEAR or PURGE_RXABORT or PURGE_TXABORT);
            CloseHandle(pComDevice);
            pComDevice := INVALID_HANDLE_VALUE;
            Sleep(50);
          except
          end;
        end;

        pComDevice := CreateFileA(PAnsiChar('\\.\' + CommPortToString(i)), GENERIC_READ or GENERIC_WRITE, 0, Nil, OPEN_EXISTING, 0, 0);
      except
        Continue;
      end;

      if pComDevice = INVALID_HANDLE_VALUE then
      begin
        Continue;
      end;

      for j := startBaudRate to endBaudRate do
      begin
        if Assigned(FOnDetect) then
          FOnDetect(Self, i, j, FCancelDetect);

        if FCancelDetect then
        begin
          CloseHandle(pComDevice);
          pPort := spNone;
          Result := False;
          Exit;
        end;

        try
          SetupComm(pComDevice, 4096, 4096);
          SetTimeOuts(pComDevice);
          Sleep(50);
        except
          Continue;
        end;

        try
          if not SetDCBState(pComDevice, j) then
            Continue;
          Sleep(50);  
        except
          Continue;
        end;

        strAT := 'AT'#13;
        //send AT check string
        try
          if (pComDevice <> INVALID_HANDLE_VALUE) then
          begin
            if not ClearCommError(pComDevice, dwErrorCode, @statPort) then
              Continue;

            if not WriteFile(pComDevice, PAnsiChar(strAT)^, strLen(PAnsiChar(strAT)), dwBytesWritten, Nil) then
              Continue;

            Sleep(50);
          end
          else
          begin
            Continue;
          end;
        except
          Continue;
        end;

        atCounter := 0;
        for k := 1 to 3 do
        begin
          strRead := '';
          try
            if not ClearCommError(pComDevice, dwErrorCode, @statPort) then
              Continue;

            if dwErrorCode <> 0 then
              Continue;

            dwBytesAvailable := statPort.cbInQue;
            if (pComDevice <> INVALID_HANDLE_VALUE) and (dwBytesAvailable > 0) then
            begin
              {$ifndef UNICODE}
              SetLength(strRead, dwBytesAvailable + 1);
              ReadFile(pComDevice, PAnsiChar(strRead)^, dwBytesAvailable, dwBytesRead, Nil);
              {$else}
              GetMem(pstrTmp, dwBytesAvailable);
              try
                ReadFile(pComDevice, pstrTmp^, dwBytesAvailable, dwBytesRead, Nil);
                strRead := StrPas(pstrTmp);
              finally
                FreeMem(pstrTmp, dwBytesAvailable);
              end;
              {$endif}

              if dwBytesRead > 0 then
              begin
                {$ifndef UNICODE}
                SetLength(strRead, dwBytesRead);
                {$endif}
                strBuffer := strRead;
                if (Pos('OK', strBuffer) > 0) then
                begin
                  atCounter := atCounter + 1;
                end;
              end;
            end;
          except
            Continue;
          end;
          if atCounter >= 1 then
          begin
            pPort := i;
            pBaudRate := j;
            Result := True;
            CloseHandle(pComDevice);
            Sleep(50);
            Exit;
          end;
          {$ifndef CPPB5}
          Application.ProcessMessages;
          {$endif}
          Sleep(500);
        end;
      end;
      Sleep(50);
      {$ifndef CPPB5}
      Application.ProcessMessages;
      {$endif}
    end;

    try
      PurgeComm(pComDevice, PURGE_RXCLEAR or PURGE_TXCLEAR or PURGE_RXABORT or PURGE_TXABORT);
      CloseHandle(pComDevice);
      pComDevice := INVALID_HANDLE_VALUE;
    except
    end;
  end;
end;

function TZylGSM.DetectGSM(var pPort: TCommPort; var pBaudRate: TBaudRate): Boolean;
begin
  Result := DetectGSM(br000075, br460800, pPort, pBaudRate);
end;


end.