unit XComDrv;

(**************************************************************************
 *     XComDrv                                                            *
 *                                                                        *
 *     Authors    : Ondrej Urik, Alexander Grischenko                     *
 *     Site       : http://xcomdrv.host.sk                                * 
 *     Mail       : xcomdrv@host.sk                                       *
 *     Version    : 1.0 $rev. 20 March 2002                               *
 *     Released   : March, 2002                                           *
 *     Platform   : D4-D?, CB4-CB?                                        *
 *                                                                        *
 *                                                                        *
 *     USE AT YOUR OWN RISK. AUTHORS ARE NOT LIABLE FOR ANY DAMAGES       *
 *     CAUSED BY USE OF THIS SOFTWARE. YOU MAY MODIFY THIS UNIT AND ALL   *
 *     OTHER UNITS THAT ARE PART OF THIS PROJECT IN ANY WAY, BUT PLEASE   *
 *     DO NOT CLAIM THAT YOU WROTE THE ORIGINAL.                          *
 *                                                                        *
 *     NOTE                                                               *
 *     1. If you find any bugs or if you got some good ideas that         *
 *     could help or improve any of the components please send a mail     *
 *     to xcomdrv@host.sk. Thanx.                                         *
 *     2. Unit is designed for Win9x and WinNT platforms. If you find     *
 *     any problems using this unit on WinNT/Win2000/WinME send me short  *
 *     description of the problem to above mail address.                  *
 *                                                                        *
 *     You may modify, distribute and sell XComDrv under any circum-      *
 *     stances. BUT by using this project you agree that the authors      *
 *     (Ondrej Urik, Alexander Grischenko) are not liable for any         *
 *     damage caused, directly or indirectly, by use or abuse of this     *
 *     project.                                                           *
 *                                                                        * 
 *     USE AT YOUR OWN RISK!                                              *
 *                                                                        *
 *     Ondrej Urik                       Alexander Grischenko             *
 *     01826 Plevnik-Drienove 12         Riga                             *
 *     Slovak Republic                   Latvia                           *
 *     ondrej.urik@pobox.sk              gralex@mailbox.riga.lv           *
 *                                                                        *
 **************************************************************************)

{$H+,R-,B-}
{$MINENUMSIZE 4}
{$I XCOMSWITCH.INC}

interface

uses
  Windows, SysUtils, Classes, Forms, XAsync;

type
  TDeviceEvent = (deChar, deFlag, deOutEmpty, deCTS, deDSR, deRLSD,
    deBreak, deError, deRing, dePrintError, deIn80Full, deProv1, deProv2);
  TDeviceEvents = set of TDeviceEvent;

  TCommEvent = procedure ( Sender: TObject; const Events: TDeviceEvents ) of object;
  TDataEvent = procedure ( Sender: TObject; const Received: DWORD ) of object;

  TObjectMethod = procedure of object;

  TBaudRate = ( br110, br300, br600, br1200, br2400, br4800, br9600, br14400,
    br19200, br38400, br56000, br57600, br115200, br128000, br256000, brCustom );

  TFlowControl = ( fcNone, fcRtsCts, fcDtrDsr, fcSoftware, fcCustom );

  TRTSSettings = set of ( fsCTSOut, fsRTSEnabled, fsRTSHandshake );
  TDTRSettings = set of ( fsDSROut, fsDTREnabled, fsDTRHandshake );
  TXOnXOffSettings = set of (fsInX, fsOutX);

  TDataBits = ( db4, db5, db6, db7, db8 );
  TStopBits = ( sb1, sb1p5, sb2 );
  TParity = ( paNone, paOdd, paEven, paMark, paSpace );

  TCommOption = ( coAbortOnError, coDiscardNull, coDSRSensitivity,
    coErrorChar, coParityCheck, coTXContinueOnXOff, coLeaveDTROpen );
  TCommOptions = set of TCommOption;

  TBreakStatus = ( brClear, brSet );
  TLockState = set of (loSend, loRead);

  TCustomComm = class;

  TEventState = set of ( esBefore, esAfter );

  TCommPlugin = class ( TComponent )
  private
    FComm: TCustomComm;
  protected
    EventState: TEventState;
    LockState: TLockState;
    function CommValid: boolean;
    procedure SetComm( Value: TCustomComm ); virtual;
    procedure HandleEvents( var Events: TDeviceEvents ); dynamic;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property Comm: TCustomComm read FComm write SetComm;
  end;

  TCommDataControl = class ( TPersistent )
  private
    FDataBits        : TDataBits;
    FParity          : TParity;
    FStopBits        : TStopBits;
    FComm            : TCustomComm;
    procedure SetDataBits( Value: TDataBits );
    procedure SetParity( Value: TParity );
    procedure SetStopBits( Value: TStopBits );
    function GetDataBits: TDataBits;
    function GetParity: TParity;
    function GetStopBits: TStopBits;
  protected
    procedure AssignTo( Dest: TPersistent ); override;
  public
    constructor Create( AComm: TCustomComm ); virtual;
  published
    property DataBits  : TDataBits read GetDataBits write SetDataBits;
    property Parity    : TParity read GetParity write SetParity;
    property StopBits  : TStopBits read GetStopBits write SetStopBits;
  end;

  TCommBuffers = class ( TPersistent )
  private
    FInputSize       : word;
    FInputTime       : word;
    FOutputSize      : word;
    FOutputTime      : word;
    FComm            : TCustomComm;
    procedure SetIOSize( Index: integer; Value: word );
    function GetIOSize( Index: integer ): word;
  protected
    procedure AssignTo( Dest: TPersistent ); override;
  public
    constructor Create( AComm: TCustomComm ); virtual;
  published
    property InputSize     : word index 0 read GetIOSize write SetIOSize;
    property OutputSize    : word index 1 read GetIOSize write SetIOSize;
    property InputTimeout  : word read FInputTime write FInputTime;
    property OutputTimeout : word read FOutputTime write FOutputTime;
  end;

  TCommEventChars = class ( TPersistent )
  private
    FXonChar         : char;
    FXoffChar        : char;
    FErrorChar       : char;
    FEventChar       : char;
    FEofChar         : char;
    FComm            : TCustomComm;
    procedure SetCommChar( Index: integer; Value: char );
    function GetCommChar( Index: integer ): char;
  protected
    procedure AssignTo( Dest: TPersistent ); override;
  public
    constructor Create( AComm: TCustomComm ); virtual;
  published
    property XonChar   : char index 0 read GetCommChar write SetCommChar;
    property XoffChar  : char index 1 read GetCommChar write SetCommChar;
    property EofChar   : char index 2 read GetCommChar write SetCommChar;
    property ErrorChar : char index 3 read GetCommChar write SetCommChar;
    property EventChar : char index 4 read GetCommChar write SetCommChar;
  end;

  TCommTimeoutsEx = class ( TPersistent )
  private
    FReadInterval    : DWORD;
    FReadMultiplier  : DWORD;
    FReadConstant    : DWORD;
    FWriteMultiplier : DWORD;
    FWriteConstant   : DWORD;
    FComm            : TCustomComm;
    procedure SetInterval( Index: integer; Value: DWORD);
    function GetInterval( Index: integer ): DWORD;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create( AComm: TCustomComm ); virtual;
  published
    property ReadInterval    : DWORD index 0 read GetInterval write SetInterval;
    property ReadMultiplier  : DWORD index 1 read GetInterval write SetInterval;
    property ReadConstant    : DWORD index 2 read GetInterval write SetInterval;
    property WriteMultiplier : DWORD index 3 read GetInterval write SetInterval;
    property WriteConstant   : DWORD index 4 read GetInterval write SetInterval;
  end;

  TCommStatus = set of ( csCTSHold, csDTRHold, csRLSDHold, csXOffHold,
    csXOffSent, csEofSent, csWaitingTX );

  TCustomComm = class( TComponent )
  private
    FHandle          : HFILE;
    FBaudRate        : TBaudRate;
    FBaudValue       : DWORD;
    FBuffers         : TCommBuffers;
    FDataControl     : TCommDataControl;
    FDeviceName      : string;
    FDTRSettings     : TDTRSettings;
    FEventChars      : TCommEventChars;
    FEvents          : TDeviceEvents;
    FFlowControl     : TFlowControl;
    FOptions         : TCommOptions;
    FRTSSettings     : TRTSSettings;
    FSynchronize     : boolean;
    FTimeouts        : TCommTimeoutsEx;
    FXOnXOffSettings : TXOnXOffSettings;
    FOnCommEvent     : TCommEvent;
    FOnData          : TDataEvent;
    FOnRead          : TNotifyEvent;
    FOnSend          : TNotifyEvent;
    FCommThread      : TThread;
    FLocked          : TLockState;
    FPaused          : integer;
    FPlugins         : TList;
    FSavedAsyncProc  : TAsyncProc;
    FUpdating        : boolean;
    procedure SetBaudRate( Value: TBaudRate );
    procedure SetBaudValue( Value: DWORD );
    procedure SetBuffers( Value: TCommBuffers );
    procedure SetRTSSettings( Value: TRTSSettings );
    procedure SetDeviceName( Value: string );
    procedure SetDataControl( Value: TCommDataControl );
    procedure SetDTRSettings( Value: TDTRSettings );
    procedure SetEventChars( Value: TCommEventChars );
    procedure SetTimeouts( Value: TCommTimeoutsEx );
    procedure SetFlowControl( Value: TFlowControl );
    procedure SetCommOptions( Value: TCommOptions );
    procedure SetXOnXOffSettings( Value: TXOnXOffSettings );
    {$IFDEF X_DEBUG}
    procedure SetOpened( Value: Boolean );
    {$ENDIF}
    procedure SetPaused( Value: boolean );
    procedure UpdateFlowSettings( Flags: integer );
    function GetBaudRate: TBaudRate;
    function GetBaudValue: DWORD;
    function GetRTSSettings: TRTSSettings;
    function GetDTRSettings: TDTRSettings;
    function GetXOnXOffSettings: TXOnXOffSettings;
    function GetCommOptions: TCommOptions;
    function GetOpened: boolean;
    function GetCommStatus: TCommStatus;
    function GetCount( Index: integer ): DWORD;
    function GetMaxBaud: TBaudRate;
    function GetTotalReceived: DWORD;
    function GetPaused: boolean;
    function UpdateDCB: boolean;
    function UpdateBuffers: boolean;
    function UpdateTimeouts: boolean;
    procedure InternalAsyncProc( Success: boolean; Data: Pointer; Count: Longint );
    {Plugin support}
    procedure AddPlugin( Value: TCommPlugin );
    procedure RemovePlugin( Value: TCommPlugin );
    function GetPlugin( Index: integer ): TCommPlugin;
    function GetPluginCount: integer;
    procedure ClearPlugins;
  protected
    FTotalRead       : DWORD;
    FTotalSent       : DWORD;
    procedure UpdateEvents( Events: TDeviceEvents );
    procedure HandleEvents( Events: TDeviceEvents ); dynamic;
    procedure ReceiveData( Received: DWORD ); dynamic;
    function GetLocked: TLockState; virtual;
    property Plugins[Index: integer]: TCommPlugin read GetPlugin;
    property PluginCount: integer read GetPluginCount;
  public
    property Handle         : HFILE read FHandle;
    property CommStatus     : TCommStatus read GetCommStatus;
    property Locked         : TLockState read GetLocked;
    property MaxBaud        : TBaudRate read GetMaxBaud;
    property InCount        : DWORD index 0 read GetCount;
    property OutCount       : DWORD index 1 read GetCount;
    property Opened         : boolean read GetOpened
      {$IFDEF X_DEBUG}write SetOpened stored False default False{$ENDIF};
    property Paused         : boolean read GetPaused write SetPaused;
    property PauseCount     : integer read FPaused;
    property TotalReceived  : DWORD read GetTotalReceived;
    property TotalSent      : DWORD read FTotalSent;
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function OpenDevice: boolean; virtual;
    procedure CloseDevice; virtual;

    procedure BeginUpdate;
    function EndUpdate: Boolean;

    procedure ToggleBreak( Status: TBreakStatus );
    procedure ToggleDTR( Status: TBreakStatus );
    procedure ToggleRTS( Status: TBreakStatus );
    procedure ToggleXonXoff( Status: TBreakStatus );

    function PurgeIn: boolean;
    function PurgeOut: boolean;

    function SendDataEx( const Data; DataSize, Timeout: DWORD ): DWORD;
    function SendData( const Data; DataSize: DWORD ): DWORD;
    function SendByte( const Value: byte ): boolean;
    function SendString( const Value: string ): boolean;

    function ReadDataEx( var Data; MaxDataSize, Timeout: DWORD ): DWORD;
    function ReadData( var Data; MaxDataSize: DWORD ): DWORD;
    function ReadByte( var Value: byte ): boolean;
    function ReadString( var Value: string ): boolean; overload;
    function ReadString( var Value: string; Len: integer ): boolean; overload;

    // by TSV
    function WaitForString( const Value: array of string; Timeout: DWORD; var Data: String): integer;

    {Async support}
    function InitAsync( AsyncProc: TAsyncProc; AutoClose: boolean ): HASYNC;
    function SendAsync( Async: HASYNC; const Data; DataSize: DWORD ): DWORD;
    function SendStringAsync( Async: HASYNC; const Value: string ): DWORD;
    function ReadAsync( Async: HASYNC; var Data; DataSize: DWORD ): DWORD;
    function ReadStringAsync( Async: HASYNC; var Value: string ): DWORD;
    function WaitAsync( Async: HASYNC; Process: TWaitProc ): boolean;
    function CloseAsync( Async: HASYNC ): boolean;
  protected
    property BaudRate    : TBaudRate read GetBaudRate write SetBaudRate;
    property Buffers     : TCommBuffers read FBuffers write SetBuffers;
    property BaudValue   : DWORD read GetBaudValue write SetBaudValue;
    property RTSSettings : TRTSSettings read GetRTSSettings write SetRTSSettings;
    property DataControl : TCommDataControl read FDataControl write SetDataControl;
    property DeviceName  : string read FDeviceName write SetDeviceName;
    property DTRSettings : TDTRSettings read GetDTRSettings write SetDTRSettings;
    property EventChars  : TCommEventChars read FEventChars write SetEventChars;
    property FlowControl : TFlowControl read FFlowControl write SetFlowControl;
    property MonitorEvents: TDeviceEvents read FEvents write FEvents;
    property Options     : TCommOptions read GetCommOptions write SetCommOptions;
    property Synchronize : boolean read FSynchronize write FSynchronize;
    property Timeouts    : TCommTimeoutsEx read FTimeouts write SetTimeouts;
    property XOnXOffSettings: TXOnXOffSettings read GetXOnXOffSettings write SetXOnXOffSettings;
    property OnCommEvent : TCommEvent read FOnCommEvent write FOnCommEvent;
    property OnData      : TDataEvent read FOnData write FOnData;
    property OnRead      : TNotifyEvent read FOnRead write FOnRead;
    property OnSend      : TNotifyEvent read FOnSend write FOnSend;
  end;

  TXComm = class ( TCustomComm )
  published
    property BaudRate;
    property BaudValue;
    property Buffers;
    property RTSSettings;
    property DataControl;
    property DeviceName;
    property DTRSettings;
    property EventChars;
    property MonitorEvents;
    property FlowControl;
    property Options;
    property Synchronize;
    property Timeouts;
    property XOnXOffSettings;

    property OnCommEvent;
    property OnData;
    property OnRead;
    property OnSend;

    {$IFDEF X_DEBUG}
    property Opened;
    {$ENDIF}
  end;

type  {Modem support}

  TDialType = ( dtPulse, dtTone );
  TConnectType = ( ctDial, ctDirect, ctWait );

  TConnectingEvent = procedure ( Sender: TObject; const ConnectType: TConnectType ) of object;

  TModemSettings = class ( TPersistent )
  private
    FInitString      : string;
    FResetString     : string;
    FDialNumber      : string;
    FSpeed           : Longint;
    FDialType        : TDialType;
    FConnectType     : TConnectType;
    FWaitRings       : byte;
    procedure SetSpeed( Value: longint );
  protected
    procedure AssignTo( Dest: TPersistent ); override;
  public
    constructor Create;
  published
    property DialType    : TDialType read FDialType write FDialType;
    property DialNumber  : string read FDialNumber write FDialNumber;
    property ConnectType : TConnectType read FConnectType write FConnectType;
    property InitString  : string read FInitString write FInitString;
    property ResetString : string read FResetString write FResetString;
    property Speed       : Longint read FSpeed write SetSpeed;
    property WaitRings   : byte read FWaitRings write FWaitRings;
  end;

  THayesAT = record
    Command: string;
    Data: string;
    Result: string;
    ME: integer;
  end;

  THayesATEvent = procedure ( Sender: TObject; AT: THayesAT ) of object;
  TLineStatus = set of ( lsCTS, lsDSR, lsRing, lsCD );
  TModemState = set of ( msInstalled, msConnected, msCommandState, msATSent,
    msConnecting, msWaitingCall, msDisconnecting );

  TCustomModem = class( TCustomComm )
  private
    FModemState      : TModemState;
    FModemSettings   : TModemSettings;
    FOnHayesAT       : THayesATEvent;
    FOnConnect       : TNotifyEvent;
    FOnDisconnect    : TNotifyEvent;
    FOnRing          : TNotifyEvent;
    FOnConnecting    : TConnectingEvent;
    FOnDisconnecting : TNotifyEvent;
    FOnChangeCS      : TNotifyEvent;
    FBuffer          : string;
    FCommand         : string;
    FECChar          : char;
    WLocked          : Boolean;
    WHayesAT         : THayesAT;
    WRegSent         : Boolean;
    WCmdPresent      : Boolean;
    procedure SetModemSettings( Value: TModemSettings );
    function InitCommand( Value: string ): boolean;
    function GetInstalled: boolean;
    function GetConnected: boolean;
    function GetLineStatus: TLineStatus;
    function GetModemState: TModemState;
    function GetEnterCmd: string;
  protected
    procedure ReceiveData( Received: DWORD ); override;
    procedure HandleEvents( Events: TDeviceEvents ); override;
    function GetLocked: TLockState; override;
    procedure HandleAT( AT: THayesAT ); dynamic;
    procedure DoConnect; virtual;
    procedure DoDisconnect; virtual;
    procedure DoConnecting( ConnectType: TConnectType ); virtual;
    procedure DoDisconnecting; virtual;
    procedure DoChangeCmdState; virtual;
  public
    property Connected: boolean read GetConnected;
    property Installed: boolean read GetInstalled;
    property LineStatus: TLineStatus read GetLineStatus;
    property ModemState: TModemState read GetModemState;

    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function OpenDevice: boolean; override;
    procedure CloseDevice; override;

    function ResetModem: boolean;
    function InitModem: boolean;
    function Connect(WaitResult: boolean): boolean;
    procedure Disconnect;
    procedure LowerDTR;

    function SendCommand( const Value: string ): boolean;
    function SetRegisterValue( Reg, Value: byte ): boolean;
    function GetRegisterValue( Reg: byte; var Value: byte ): boolean;

    function EnterCommandState: boolean;
    function ExitCommandState: boolean;

    function WaitForAT( Timeout: DWORD ): THayesAT;
  protected
    property ModemSettings    : TModemSettings read FModemSettings write SetModemSettings;
    property OnHayesAT        : THayesATEvent read FOnHayesAT write FOnHayesAT;
    property OnConnect        : TNotifyEvent read FOnConnect write FOnConnect;
    property OnConnecting     : TConnectingEvent read FOnConnecting write FOnConnecting;
    property OnDisconnect     : TNotifyEvent read FOnDisconnect write FOnDisconnect;
    property OnDisconnecting  : TNotifyEvent read FOnDisconnecting write FOnDisconnecting;
    property OnRing           : TNotifyEvent read FOnRing write FOnRing;
    property OnChangeCmdState : TNotifyEvent read FOnChangeCS write FOnChangeCS;
  end;

  TXModem = class( TCustomModem )
  published
    property BaudRate;
    property BaudValue;
    property Buffers;
    property RTSSettings;
    property DataControl;
    property DeviceName;
    property DTRSettings;
    property EventChars;
    property MonitorEvents;
    property FlowControl;
    property ModemSettings;
    property Options;
    property Synchronize;
    property Timeouts;
    property XOnXOffSettings;

    property OnChangeCmdState;
    property OnCommEvent;
    property OnConnect;
    property OnConnecting;
    property OnData;
    property OnDisconnect;
    property OnDisconnecting;
    property OnHayesAT;
    property OnRead;
    property OnRing;
    property OnSend;

    {$IFDEF X_DEBUG}
    property Opened;
    {$ENDIF}
  end;

function GetRXTimeout( const Baud, DataSize: DWORD ): DWORD;

function DataBitsToChar( const DataBits: TDataBits ): char;
function CharToDataBits( const ch: char ): TDataBits;
function StopBitsToStr( const StopBits: TStopBits ): string;
function StrToStopBits( const Str: string ): TStopBits;

function FlowControlToStr( const fc: TFlowControl ): string;
function StrToFlowControl( const Str: string ): TFlowControl;

function ParityToStr( const Parity: TParity ): string;
function StrToParity( const Str: string ): TParity;

function BaudRateToStr( const BaudRate: TBaudRate ): string;
function StrToBaudRate( const Str: string ): TBaudRate;

function GetTickCount: DWORD;

const
  {Modem int results}
  ME_INVALID       = -1;
  ME_OK            = $0000;
  ME_CONNECT       = $0001;
  ME_RING          = $0002;
  ME_NOCARRIER     = $0003;
  ME_ERROR         = $0004;
  ME_NODIALTONE    = $0005;
  ME_BUSY          = $0006;
  ME_NOANSWER      = $0007;
  ME_UNKNOWN       = $FFFF;

  MB_MINBAUD = 300;

  STR_FLOWCONTROL : array [TFlowControl] of string =
    ( 'None', 'CTS/RTS', 'DTR/DSR', 'XOn/XOff', 'Custom' );
  STR_PARITY : array [TParity] of string =
    ( 'None', 'Odd', 'Even', 'Mark', 'Space' );
  STR_STOPBITS : array [TStopBits] of string =
    ( '1', '1.5', '2' );


function ATShortToLong( var s: string ): boolean;
function ATResultToME( s: string ): integer;

implementation
uses XComErr;

const
  BaudRate_: array[br110..br256000] of DWORD =
    (CBR_110, CBR_300, CBR_600, CBR_1200, CBR_2400, CBR_4800, CBR_9600,
     CBR_14400, CBR_19200, CBR_38400, CBR_56000, CBR_57600, CBR_115200,
     CBR_128000, CBR_256000);

  dcb_Binary              = $00000001;
  dcb_ParityCheck         = $00000002;
  dcb_OutxCtsFlow         = $00000004;
  dcb_OutxDsrFlow         = $00000008;
  dcb_DtrControlEnable    = $00000010;
  dcb_DtrControlHandshake = $00000020;
  dcb_DsrSensitivity      = $00000040;
  dcb_TXContinueOnXoff    = $00000080;
  dcb_OutX                = $00000100;
  dcb_InX                 = $00000200;
  dcb_ErrorChar           = $00000400;
  dcb_DiscardNull         = $00000800;
  dcb_RtsControlEnable    = $00001000;
  dcb_RtsControlHandshake = $00002000;
  dcb_AbortOnError        = $00004000;
{$IFDEF OLDFLOW}
  dcb_DtrDsrControl       = dcb_Binary or dcb_OutxDsrFlow or dcb_DtrControlEnable or dcb_DtrControlHandshake;
  dcb_RtsCtsControl       = dcb_Binary or dcb_OutxCtsFlow or dcb_RtsControlEnable or dcb_RtsControlHandshake;
  dcb_XOnXOffControl      = dcb_Binary or dcb_InX or dcb_OutX;
{$ELSE}
  dcb_DtrDsrControl       = dcb_Binary or dcb_OutxDsrFlow or dcb_DtrControlEnable or dcb_RtsControlEnable;
  dcb_RtsCtsControl       = dcb_Binary or dcb_OutxCtsFlow or dcb_RtsControlHandshake or dcb_DtrControlEnable;
  dcb_XOnXOffControl      = dcb_Binary or dcb_InX or dcb_OutX or dcb_DtrControlEnable;
{$ENDIF}
  EV_COMMEVENTS = $1FFB;

procedure ConvertErrorFmt( const Ident: string; const Args: array of const );
begin
  raise EConvertError.CreateFmt(Ident, Args);
end;

function GetRXTimeout( const Baud, DataSize: DWORD ): DWORD;
begin
  Result := Round(DataSize/Baud*10000)+1;
end;

function DataBitsToChar( const DataBits: TDataBits ): char;
begin
  Result := Char(ord(DataBits)+52);
end;

{$WARNINGS OFF}
function CharToDataBits( const ch: char ): TDataBits;
begin
  if (ch in ['4'..'8'])
    then Result := TDataBits(byte(ch)-52)
    else ConvertErrorFmt(SInvalidDataBits, [ch]);
end;

function StopBitsToStr( const StopBits: TStopBits ): string;
begin
  Result := STR_STOPBITS[StopBits];
end;

function StrToStopBits( const Str: string ): TStopBits;
begin
  for Result := sb1 to sb2 do
    if Str=STR_STOPBITS[Result] then Exit;
  ConvertErrorFmt(SInvalidStopBits, [Str]);
end;

function FlowControlToStr( const fc: TFlowControl ): string;
begin
  Result := STR_FLOWCONTROL[fc];
end;

function StrToFlowControl( const Str: string ): TFlowControl;
begin
  for Result := fcNone to fcSoftware do
    if UpperCase(Str)=UpperCase(STR_FLOWCONTROL[Result]) then Exit;
  ConvertErrorFmt(SInvalidFlowControl, [Str]);
end;

function ParityToStr( const Parity: TParity ): string;
begin
  Result := STR_PARITY[Parity];
end;

function StrToParity( const Str: string ): TParity;
begin
  for Result := paNone to paSpace do
    if UpperCase(Str)=UpperCase(STR_PARITY[Result]) then Exit;
  ConvertErrorFmt(SInvalidParity, [Str]);
end;

function BaudRateToStr(const BaudRate: TBaudRate): string;
begin
  if (BaudRate<>brCustom)
    then Result := IntToStr(BAUDRATE_[BaudRate])
    else Result := '';
end;

function StrToBaudRate(const Str: string): TBaudRate;
var i: integer;
begin
  for Result := br110 to br256000 do
    if (Str=IntToStr(BAUDRATE_[Result])) then Exit;
  Result := brCustom;
  if (Str='')
    then i := 0
    else i := 1;
  while (i>0) and (i<=Length(Str)) do
    if (Str[i] in ['0'..'9'])
      then Inc(i)
      else i := 0;
  if (i=0) then ConvertErrorFmt(SInvalidBaudRate, [Str]);
end;
{$WARNINGS ON}

procedure SetDCB(var DCB: TDCB);
begin
  FillChar(DCB, SizeOf(DCB), 0);
  DCB.DCBLength := SizeOf(DCB);
end;

function GetCommState(Handle: HFILE; var DCB: TDCB): Boolean;
begin
  SetDCB(DCB);
  Result := Windows.GetCommState(Handle, DCB);
end;

type
  TCommEventThread = class( TThread )
  private
    FStopEvent       : THandle;
    FEventMask       : DWORD;
    FComm            : TCustomComm;
  protected
    procedure Execute; override;
    procedure DoOnSignal;
  public
    constructor Create( AComm: TCustomComm ); virtual;
    destructor Destroy; override;
  end;

{-- TCommEventThread --}

constructor TCommEventThread.Create( AComm: TCustomComm );
begin
  inherited Create(True);
  FComm          := AComm;
  FStopEvent     := CreateEvent(nil, True, False, nil);
  SetCommMask(FComm.Handle, EV_COMMEVENTS);
  Resume;
end;

destructor TCommEventThread.Destroy;
begin
  SetEvent(FStopEvent);
  Sleep(0);
  inherited Destroy;
end;

procedure TCommEventThread.Execute;
var
  EventHandles: array [0..1] of THandle;
  Overlapped: TOverlapped;
  Signaled, BytesTrans: DWORD;
begin
  FillChar(Overlapped, SizeOf(Overlapped), 0);
  Overlapped.hEvent := CreateEvent(nil, True, True, nil);
  EventHandles[0] := FStopEvent;
  EventHandles[1] := Overlapped.hEvent;
  repeat
    WaitCommEvent(FComm.Handle, FEventMask, @Overlapped);
    Signaled := WaitForMultipleObjects(2, @EventHandles, False, INFINITE);
    case Signaled of
      WAIT_OBJECT_0 + 1:
        if GetOverlappedResult(FComm.Handle, Overlapped, BytesTrans, False) then
        begin
          if FComm.Synchronize
            then Synchronize(DoOnSignal)
            else DoOnSignal;
        end else Break;
      else Break;
    end;
  until False;
  SetCommMask(FComm.Handle, 0);
  CloseHandle(Overlapped.hEvent);
  CloseHandle(FStopEvent);
end;

procedure TCommEventThread.DoOnSignal;
begin
  if (FEventMask<>0) and (FComm<>nil) then
    FComm.UpdateEvents(TDeviceEvents(Word(FEventMask)));
end;

{-- TCommPlugin --}

constructor TCommPlugin.Create( AOwner: TComponent );
begin
  inherited Create(AOwner);
  FComm := nil;
  EventState := [esBefore];
  LockState := [];
end;

destructor TCommPlugin.Destroy;
begin
  SetComm(nil);
  inherited Destroy;
end;

procedure TCommPlugin.HandleEvents( var Events: TDeviceEvents );
begin
end;

procedure TCommPlugin.Notification( AComponent: TComponent;
  Operation: TOperation );
begin
  if (Operation=opRemove) and (AComponent=FComm) then FComm := nil;
end;

procedure TCommPlugin.SetComm( Value: TCustomComm );
begin
  if (Value<>FComm) then
  begin
    if (FComm<>nil) then FComm.RemovePlugin(Self);
    if (Value<>nil) then Value.AddPlugin(Self);
    FComm := Value;
  end;
end;

function TCommPlugin.CommValid: boolean;
begin
  Result := FComm<>nil;
  if not Result then XCommError(SNoDevice, DEC_NODEVICE);
end;

{-- TCommDataControl --}

constructor TCommDataControl.Create( AComm: TCustomComm );
begin
  inherited Create;
  FComm          := AComm;
  FDataBits      := db8;
  FParity        := paNone;
  FStopBits      := sb1;
end;

procedure TCommDataControl.SetDataBits( Value: TDataBits );
begin
  if Value<>FDataBits then
  begin
    FDataBits := Value;
    if FComm.Opened and not FComm.FUpdating then
      FComm.UpdateDCB;
  end;
end;

procedure TCommDataControl.SetParity( Value: Tparity );
begin
  if Value<>FParity then
  begin
    FParity := Value;
    if FComm.Opened and not FComm.FUpdating then
      FComm.UpdateDCB;
  end;
end;

procedure TCommDataControl.SetStopBits( Value: TStopBits );
begin
  if Value<>FStopBits then
  begin
    FStopBits := Value;
    if FComm.Opened and not FComm.FUpdating then
      FComm.UpdateDCB;
  end;
end;

function TCommDataControl.GetDataBits: TDataBits;
var DCB: TDCB;
begin
  if FComm.Opened and GetCommState(FComm.Handle, DCB) then
    Result := TDataBits(DCB.ByteSize-(8+Ord(db8)))
  else
    Result := FDataBits;
end;

function TCommDataControl.GetParity: TParity;
var DCB: TDCB;
begin
  if FComm.Opened and GetCommState(FComm.Handle, DCB) then
    Result := TParity(DCB.Parity)
  else
    Result := FParity;
end;

function TCommDataControl.GetStopBits: TStopBits;
var DCB: TDCB;
begin
  if FComm.Opened and GetCommState(FComm.Handle, DCB) then
    Result := TStopBits(DCB.StopBits)
  else
    Result := FStopBits;
end;

procedure TCommDataControl.AssignTo( Dest: TPersistent );
begin
  if Dest is TCommDataControl then
  begin
    FDataBits := TCommDataControl(Dest).DataBits;
    FParity   := TCommDataControl(Dest).Parity;
    FStopBits := TCommDataControl(Dest).StopBits;
    if FComm.Opened and not FComm.FUpdating then
      FComm.UpdateDCB;
  end
   else inherited AssignTo(Dest);
end;

{-- TCommBuffers --}

constructor TCommBuffers.Create( AComm: TCustomComm );
begin
  inherited Create;
  FComm          := AComm;
  FInputSize     := 2048;
  FInputTime     := 500;
  FOutputSize    := 2048;
  FOutputTime    := 500;
end;

procedure TCommBuffers.SetIOSize( Index: integer; Value: word );
var
  CanUpdate: Boolean;
  UpLimit: word;

  function IsWinNT: Boolean;
  var ver: TOSVERSIONINFO;
  begin
    ver.dwOSVersionInfoSize := SizeOf(ver);
    Result := GetVersionEx(ver) and
      (ver.dwPlatformId = VER_PLATFORM_WIN32_NT) and
      (MAKELONG(ver.dwMinorVersion, ver.dwMajorVersion) >= $00040000);
  end;

begin
  if IsWinNT
    then UpLimit := 4096
    else UpLimit := 8192;
  if Value>UpLimit then Value := UpLimit;
  if Value<128 then Value := 128;
  CanUpdate := False;
  case Index of
    0: if FInputSize<>Value then
    begin
      FInputSize   := Value;
      CanUpdate    := True;
    end;
    1: if FOutputSize<>Value then
    begin
      FOutputSize  := Value;
      CanUpdate    := True;
    end;
  end;
  if CanUpdate and FComm.Opened and not FComm.FUpdating then
    FComm.UpdateBuffers;
end;

function TCommBuffers.GetIOSize( Index: integer ): word;
var cp: TCommProp;
begin
  Result := 65535;
  if FComm.Opened and GetCommProperties(FComm.Handle, cp) then
  case Index of
    0: if cp.dwCurrentRXQueue=0
      then Result := FInputSize
      else Result := cp.dwCurrentRXQueue;
    1: if cp.dwCurrentTXQueue=0
      then Result := FInputSize
      else Result := cp.dwCurrentTXQueue;
  end else
  case Index of
    0: Result := FInputSize;
    1: Result := FOutputSize;
  end;
end;

procedure TCommBuffers.AssignTo( Dest: TPersistent );
begin
  if (Dest is TCommBuffers) then
  begin
    FInputTime  := TCommBuffers(Dest).InputTimeout;
    FOutputTime := TCommBuffers(Dest).OutputTimeout;
    FInputSize  := TCommBuffers(Dest).InputSize;
    FOutputSize := TCommBuffers(Dest).OutputSize;
    if FComm.Opened and not FComm.FUpdating then
      FComm.UpdateBuffers;
  end
  else inherited AssignTo(Dest);
end;

{-- TCommEventChars --}

constructor TCommEventChars.Create( AComm: TCustomComm );
begin
  inherited Create;
  FComm          := AComm;
  FXonChar       := #17;
  FXoffChar      := #19;
  FEofChar       := #0;
  FErrorChar     := #0;
  FEventChar     := #10;
end;

procedure TCommEventChars.SetCommChar( Index: integer; Value: char );
var CanUpdate: Boolean;
begin
  CanUpdate := False;
  case Index of
    0: if FXonChar<>Value then
    begin
      FXonChar  := Value;
      CanUpdate := True;
    end;
    1: if FXoffChar<>Value then
    begin
      FXoffChar := Value;
      CanUpdate := True;
    end;
    2: if FEofChar<>Value then
    begin
      FEofChar  := Value;
      CanUpdate := True;
    end;
    3: if FErrorChar<>Value then
    begin
      FErrorChar := Value;
      CanUpdate  := True;
    end;
    4: if FEventChar<>Value then
    begin
      FEventChar := Value;
      CanUpdate  := True;
    end;
  end;
  if CanUpdate and FComm.Opened and not FComm.FUpdating then
    FComm.UpdateDCB;
end;

function TCommEventChars.GetCommChar( Index: integer ): char;
var dcb: TDCB;
begin
  Result := #0;
  if FComm.Opened and GetCommState(FComm.Handle, dcb) then
  case Index of
    0: Result := dcb.XOnChar;
    1: Result := dcb.XOffChar;
    2: Result := dcb.EOfChar;
    3: Result := dcb.ErrorChar;
    4: Result := dcb.EvtChar;
  end else
  case Index of
    0: Result := FXonChar;
    1: Result := FXoffChar;
    2: Result := FEofChar;
    3: Result := FErrorChar;
    4: Result := FEventChar;
  end;
end;

procedure TCommEventChars.AssignTo( Dest: TPersistent );
begin
  if (Dest is TCommEventChars) then
  begin
    FXonChar   := TCommEventChars(Dest).XonChar;
    FXoffChar  := TCommEventChars(Dest).XoffChar;
    FEofChar   := TCommEventChars(Dest).EofChar;
    FErrorChar := TCommEventChars(Dest).ErrorChar;
    FEventChar := TCommEventChars(Dest).EventChar;
    if FComm.Opened and not FComm.FUpdating then
      FComm.UpdateDCB;
  end
  else inherited AssignTo(Dest);
end;

{-- TCommTimeoutsEx --}

constructor TCommTimeoutsEx.Create( AComm: TCustomComm );
begin
  inherited Create;
  FComm             := AComm;
  FReadInterval     := 1;
  FReadMultiplier   := 0;
  FReadConstant     := 1;
  FWriteMultiplier  := 0;
  FWriteConstant    := 1;
end;

procedure TCommTimeoutsEx.SetInterval( Index: integer; Value: DWORD);
var CanUpdate: Boolean;
begin
  CanUpdate := False;
  case Index of
    0: if FReadInterval<>Value then
    begin
      FReadInterval := Value;
      CanUpdate     := True;
    end;
    1: if FReadMultiplier<>Value then
    begin
      FReadMultiplier := Value;
      CanUpdate       := True;
    end;
    2: if FReadConstant<>Value then
    begin
      FReadConstant := Value;
      CanUpdate     := True;
    end;
    3: if FWriteMultiplier<>Value then
    begin
      FWriteMultiplier := Value;
      CanUpdate        := True;
    end;
    4: if FWriteConstant<>Value then
    begin
      FWriteConstant := Value;
      CanUpdate      := True;
    end;
  end;
  if CanUpdate and FComm.Opened and not FComm.FUpdating then
    FComm.UpdateTimeouts;
end;

function TCommTimeoutsEx.GetInterval( Index: integer ): DWORD;
var tms: TCommTimeouts;
begin
  Result := 0;
  if FComm.Opened and GetCommTimeouts(FComm.Handle, tms) then
  case Index of
    0: Result := tms.ReadIntervalTimeout;
    1: Result := tms.ReadTotalTimeoutMultiplier;
    2: Result := tms.ReadTotalTimeoutConstant;
    3: Result := tms.WriteTotalTimeoutMultiplier;
    4: Result := tms.WriteTotalTimeoutConstant;
  end else
  case Index of
    0: Result := FReadInterval;
    1: Result := FReadMultiplier;
    2: Result := FReadConstant;
    3: Result := FWriteMultiplier;
    4: Result := FWriteConstant;
  end;
end;

procedure TCommTimeoutsEx.AssignTo( Dest: TPersistent );
begin
  if (Dest is TCommTimeoutsEx) then
  begin
    FReadInterval    := TCommTimeoutsEx(Dest).ReadInterval;
    FReadMultiplier  := TCommTimeoutsEx(Dest).ReadMultiplier;
    FReadConstant    := TCommTimeoutsEx(Dest).ReadConstant;
    FWriteMultiplier := TCommTimeoutsEx(Dest).WriteMultiplier;
    FWriteConstant   := TCommTimeoutsEx(Dest).WriteConstant;
    if FComm.Opened and not FComm.FUpdating then
      FComm.UpdateTimeouts;
  end
  else inherited AssignTo(Dest);
end;


{-- TCustomComm --}

constructor TCustomComm.Create( AOwner: TComponent );
begin
  inherited Create(AOwner);
  FHandle        := INVALID_HANDLE_VALUE;
  FDeviceName    := 'COM2';
  FBaudRate      := br9600;
  FBaudValue     := 9600;
  FOptions       := [];
  FFlowControl   := fcNone;
  FDataControl   := TCommDataControl.Create(Self);
  FBuffers       := TCommBuffers.Create(Self);
  FEventChars    := TCommEventChars.Create(Self);
  FTimeouts      := TCommTimeoutsEx.Create(Self);
  FTotalRead     := 0;
  FTotalSent     := 0;
  FEvents        := [deChar, deOutEmpty, deFlag];
  FUpdating      := False;
  FRTSSettings   := [];
  FDTRSettings   := [];
  FXOnXOffSettings := [];
  FSynchronize   := True;
  FPlugins       := TList.Create;
  FPaused        := 0;
end;

destructor TCustomComm.Destroy;
begin
  if Opened then
  begin
{$IFDEF X_DEBUG}
    if not (csDesigning in ComponentState) then
{$ENDIF}
    FCommThread.Free;
    CloseHandle(FHandle);
    FHandle:=INVALID_HANDLE_VALUE;  // Bigmike 2001.04.27
  end;
  FDataControl.Free;
  FBuffers.Free;
  FEventChars.Free;
  FTimeouts.Free;
  ClearPlugins;
  FPlugins.Free;
  inherited Destroy;
end;

procedure TCustomComm.SetDeviceName( Value: string );
begin
  if not Opened and (FDeviceName<>Value) then
    FDeviceName:=Value;
end;

procedure TCustomComm.SetDataControl( Value: TCommDataControl );
begin
  if (Value<>FDataControl) then
    FDataControl.Assign(Value);
end;

procedure TCustomComm.SetBuffers( Value: TCommBuffers );
begin
  if (Value<>FBuffers) then
    FBuffers.Assign(Value);
end;

procedure TCustomComm.SetEventChars( Value: TCommEventChars);
begin
   if (Value<>FEventChars) then
    FEventChars.Assign(Value);
end;

procedure TCustomComm.SetTimeouts( Value: TCommTimeoutsEx );
begin
   if (Value<>FTimeouts) then
    FTimeouts.Assign(Value);
end;

procedure TCustomComm.SetBaudRate(Value: TBaudRate);
begin
  if (FBaudRate<>Value) then
  begin
    FBaudRate := Value;
    if (Value<>brCustom) then
    begin
      FBaudValue := BAUDRATE_[Value];
      if Opened and not FUpdating then UpdateDCB;
    end;
  end;
end;

procedure TCustomComm.SetBaudValue( Value: DWORD );
begin
  if (FBaudRate=brCustom) and (Value<>FBaudValue) then
  begin
    FBaudValue := Value;
    if Opened and not FUpdating then UpdateDCB;
  end;
end;

procedure TCustomComm.SetFlowControl( Value: TFlowControl );
begin
  if (Value<>FlowControl) then
  begin
    FFlowControl := Value;
    if (Value<>fcCustom) then
    begin
      UpdateFlowSettings(0);
      if Opened and not FUpdating then UpdateDCB;
    end;
  end;
end;

procedure TCustomComm.SetRTSSettings( Value: TRTSSettings );
begin
  if (FFlowControl=fcCustom) and (Value<>RTSSettings) then
  begin
    FRTSSettings := Value;
    if Opened and not FUpdating then UpdateDCB;
  end;
end;

procedure TCustomComm.SetDTRSettings( Value: TDTRSettings );
begin
{$IFNDEF OLDFLOW}
  if (coLeaveDTROpen in FOptions) then
  begin
    Exclude(Value, fsDTRHandshake);
    Include(Value, fsDTREnabled);
  end;
  if (fsDTRhandshake in Value) and (fsDTREnabled in Value) then
  begin
    if (fsDTRhandshake in FDTRSettings)
      then Exclude(Value, fsDTRhandshake)
      else Exclude(Value, fsDTREnabled);
  end;
{$ENDIF}
  if (FFlowControl=fcCustom) and (Value<>DTRSettings) then
  begin
    FDTRSettings := Value;
    if Opened and not FUpdating then UpdateDCB;
  end;
end;

procedure TCustomComm.SetXOnXOffSettings( Value: TXOnXOffSettings );
begin
  if (FFlowControl=fcCustom) and (Value<>XOnXOffSettings) then
  begin
    FXOnXOffSettings := Value;
    if Opened and not FUpdating then UpdateDCB;
  end;
end;

procedure TCustomComm.UpdateFlowSettings( Flags: Integer );
begin
  if (Flags=0) or (not Opened and (FFlowControl<>fcCustom)) then
  begin
    FXOnXOffSettings := [];
    FRTSSettings := [];
    FDTRSettings := [];
{$IFDEF OLDFLOW}
    case FFlowControl of
      fcSoftware: FXOnXOffSettings := [fsInX, fsOutX];
      fcRtsCts: FRTSSettings := [fsCTSOut, fsRTSEnabled, fsRTSHandshake];
      fcDtrDsr: FDTRSettings := [fsDSROut, fsDTREnabled, fsDTRHandshake];
    end;
{$ELSE}
    case FFlowControl of
      fcSoftware: FXOnXOffSettings := [fsInX, fsOutX];
      fcRtsCts: FRTSSettings := [fsCTSOut, fsRTSHandshake];
      fcDtrDsr:
      begin
        FDTRSettings := [fsDSROut];
        FRTSSettings := [fsRTSEnabled];
      end;
    end;
    if (FFlowControl<>fcNone) then Include(FDTRSettings, fsDTREnabled);
    if (coLeaveDTROpen in FOptions) then
    begin
      Include(FDTRSettings, fsDTREnabled);
      Exclude(FDTRSettings, fsDTRHandshake);
    end;
{$ENDIF}
  end else if Opened then
  begin
    FDTRSettings := [];
    if (Flags and dcb_DTRControlHandshake<>0) then Include(FDTRSettings, fsDTRHandshake);
    if (Flags and dcb_DTRControlEnable<>0) then Include(FDTRSettings, fsDTREnabled);
    if (Flags and dcb_OutXDSRFlow<>0) then Include(FDTRSettings, fsDSROut);
    FRTSSettings := [];
    if (Flags and dcb_RTSControlHandshake<>0) then Include(FRTSSettings, fsRTSHandshake);
    if (Flags and dcb_RTSControlEnable<>0) then Include(FRTSSettings, fsRTSEnabled);
    if (Flags and dcb_OutXCTSFlow<>0) then Include(FRTSSettings, fsCTSOut);
    FXOnXOffSettings := [];
    if (Flags and dcb_OutX<>0) then Include(FXOnXOffSettings, fsOutX);
    if (Flags and dcb_InX<>0) then Include(FXOnXOffSettings, fsInX);
    if (coLeaveDTROpen in FOptions)
      then FOptions := [coLeaveDTROpen]
      else FOptions := [];
    if (Flags and dcb_ParityCheck<>0) then Include(FOptions, coParityCheck);
    if (Flags and dcb_DsrSensitivity<>0) then Include(FOptions, coDSRSensitivity);
    if (Flags and dcb_ErrorChar<>0) then Include(FOptions, coErrorChar);
    if (Flags and dcb_DiscardNull<>0) then Include(FOptions, coDiscardNull);
    if (Flags and dcb_AbortOnError<>0) then Include(FOptions, coAbortOnError);
    if (Flags and dcb_TXContinueOnXoff<>0) then Include(FOptions, coTXContinueOnXoff);
  end;
end;

procedure TCustomComm.SetCommOptions( Value: TCommOptions );
begin
  if Opened then
  begin
    if (coLeaveDTROpen in FOptions)
      then Include(Value, coLeaveDTROpen)
      else Exclude(Value, coLeaveDTROpen);
  end;
  if (Options<>Value) then
  begin
    FOptions := Value;
    if not Opened then UpdateFlowSettings(0)
    else if not FUpdating then UpdateDCB;
  end;
end;

function TCustomComm.GetBaudRate: TBaudRate;
var
  I: TBaudRate;
  Value: DWORD;
begin
  if Opened and (FBaudRate<>brCustom) then
  begin
    FBaudRate := brCustom;
    Value := GetBaudValue;
    for I:=br110 to br256000 do
      if BaudRate_[I]=Value then
      begin
        FBaudRate := I;
        Break;
      end;
  end;
  Result := FBaudRate;
end;

function TCustomComm.GetBaudValue: DWORD;
var DCB: TDCB;
begin
  if Opened and GetCommState(Handle, DCB)
    then Result := DCB.BaudRate
    else Result := FBaudValue;
  FBaudValue := Result;
end;

function TCustomComm.GetRTSSettings: TRTSSettings;
var DCB: TDCB;
begin
  if Opened and GetCommState(Handle, DCB) then
    UpdateFlowSettings(DCB.Flags);
  Result := FRTSSettings;
end;

function TCustomComm.GetDTRSettings: TDTRSettings;
var DCB: TDCB;
begin
  if Opened and GetCommState(Handle, DCB) then
    UpdateFlowSettings(DCB.Flags);
  Result := FDTRSettings;
end;

function TCustomComm.GetXOnXOffSettings: TXOnXOffSettings;
var DCB: TDCB;
begin
  if Opened and GetCommState(Handle, DCB) then
    UpdateFlowSettings(DCB.Flags);
  Result := FXOnXOffSettings;
end;

{function TCustomComm.GetFlowControl: TFlowControl;
var DCB: TDCB;
begin
  if Opened and GetCommState(Handle, DCB) then
    UpdateFlowSettings(DCB.Flags);
  Result := FFlowControl;
end;}

function TCustomComm.GetCommOptions: TCommOptions;
var DCB: TDCB;
begin
  if Opened and GetCommState(Handle, DCB) then
    UpdateFlowSettings(DCB.Flags);
  Result := FOptions;
end;

{Plugin support}
procedure TCustomComm.AddPlugin( Value: TCommPlugin );
begin
  FPlugins.Add(Value);
end;

procedure TCustomComm.RemovePlugin( Value: TCommPlugin );
begin
  FPlugins.Remove(Value);
end;

function TCustomComm.GetPlugin( Index: integer ): TCommPlugin;
begin
  Result := TCommPlugin(FPlugins.Items[Index]);
end;

function TCustomComm.GetPluginCount: integer;
begin
  Result := FPlugins.Count;
end;

procedure TCustomComm.ClearPlugins;
begin
  while (FPlugins.Count>0) do
    Plugins[0].SetComm(nil);
end;

function TCustomComm.UpdateDCB: Boolean;
var dcb: TDCB;
begin
  SetDCB(dcb);

  dcb.Flags                  := dcb_Binary;
  if fsDSROut in FDTRSettings then
    dcb.Flags                := dcb.Flags or dcb_OutxDsrFlow;
  if fsDTREnabled in FDTRSettings then
    dcb.Flags                := dcb.Flags or dcb_DtrControlEnable;
  if fsDTRHandshake in FDTRSettings then
    dcb.Flags                := dcb.Flags or dcb_DtrControlHandshake;

  if fsCTSOut in FRTSSettings then
    dcb.Flags                := dcb.Flags or dcb_OutxCtsFlow;
  if fsRTSEnabled in FRTSSettings then
    dcb.Flags                := dcb.Flags or dcb_RtsControlEnable;
  if fsRTSHandshake in FRTSSettings then
    dcb.Flags                := dcb.Flags or dcb_RtsControlHandshake;

  if fsInX in FXOnXOffSettings then
    dcb.Flags                := dcb.Flags or dcb_InX;
  if fsOutX in FXOnXOffSettings then
    dcb.Flags                := dcb.Flags or dcb_OutX;

  dcb.XONLim                 := FBuffers.FInputSize div 4;
  dcb.BaudRate               := FBaudValue;
  dcb.XOFFLim                := dcb.XONLim;
  dcb.ByteSize               := 8-Ord(db8)+Ord(FDataControl.FDataBits);
  dcb.Parity                 := ord(FDataControl.FParity);
  dcb.StopBits               := ord(FDataControl.FStopBits);
  dcb.XONChar                := FEventChars.FXOnChar;
  dcb.XOFFChar               := FEventChars.FXOffChar;
  dcb.EvtChar                := FEventChars.FEventChar;
  dcb.ErrorChar              := FEventChars.FErrorChar;
  dcb.EofChar                := FEventChars.FEofChar;

  if (coParityCheck in FOptions) then
    dcb.Flags                := dcb.Flags or dcb_ParityCheck;
  if (coDsrSensitivity in FOptions) then
    dcb.Flags                := dcb.Flags or dcb_DsrSensitivity;
  if (coErrorChar in FOptions) then
    dcb.Flags                := dcb.Flags or dcb_ErrorChar;
  if (coDiscardNull in FOptions) then
    dcb.Flags                := dcb.Flags or dcb_DiscardNull;
  if (coAbortOnError in FOptions) then
    dcb.Flags                := dcb.Flags or dcb_AbortOnError;
  if (coTXContinueOnXoff in FOptions) then
    dcb.Flags                := dcb.Flags or dcb_TXContinueOnXoff;
  if (coLeaveDTROpen in FOptions) then
    dcb.Flags                := dcb.Flags or dcb_DtrControlEnable;

  Result := SetCommState(FHandle, dcb);
  if not Result then XCommError(SInvalidDCB, DEC_INVALIDDCB);
end;

function TCustomComm.UpdateBuffers: boolean;
begin
  PurgeComm(FHandle, PURGE_TXCLEAR or PURGE_TXABORT or PURGE_RXCLEAR or PURGE_RXABORT);
  Result := SetupComm(FHandle, FBuffers.FInputSize, FBuffers.FOutputSize);
  if not Result then XCommError(SInvalidIOSize, DEC_INVALIDIOSIZE);
end;

function TCustomComm.UpdateTimeouts: boolean;
var tms: TCommTimeouts;
begin
  with FTimeouts, tms do
  begin
    ReadIntervalTimeout := FReadInterval;
    ReadTotalTimeoutMultiplier := FReadMultiplier;
    ReadTotalTimeoutConstant := FReadConstant;
    WriteTotalTimeoutMultiplier := FWriteMultiplier;
    WriteTotalTimeoutConstant := FWriteConstant;
  end;
  Result := SetCommTimeouts(FHandle, tms);
  if not Result then XCommError(SInvalidTimeouts, DEC_INVALIDTIMEOUTS);
end;

function TCustomComm.OpenDevice: boolean;
begin
  Result := not Opened;
  if not Result then
  begin
    XCommError(SCommOpened, DEC_OPENED);
    exit;
  end;
  FLocked := [];
  FPaused := 0;
  FUpdating := False;
  FHandle := CreateFile( pchar('\\.\'+FDeviceName),
                         GENERIC_READ or GENERIC_WRITE,
                         0,
                         nil,
                         OPEN_EXISTING,
                         FILE_FLAG_OVERLAPPED or FILE_ATTRIBUTE_NORMAL,
                         0
                        ) ;
  Result := Opened;
  if not Result then
  begin
    XCommError(Format(SDOpenError, [FDeviceName]), DEC_OPENERROR);
    Exit;
  end;
  {$IFDEF X_DEBUG}
  if not (csDesigning in ComponentState) then
  {$ENDIF}
  FCommThread := TCommEventThread.Create(Self);

  UpdateDCB;
  UpdateBuffers;
  UpdateTimeouts;
end;

procedure TCustomComm.BeginUpdate;
begin
  if not Opened
    then XCommError(SCommOpened, DEC_CLOSED)
    else FUpdating := True;
end;

function TCustomComm.EndUpdate: Boolean;
begin
  Result := False;
  if not Opened then XCommError(SCommOpened, DEC_CLOSED)
  else if FUpdating then
  begin
    FUpdating := False;
    Result := UpdateDCB and UpdateBuffers and UpdateTimeouts;
  end;
end;

procedure TCustomComm.CloseDevice;
begin
  if Opened then
  begin
    {$IFDEF X_DEBUG}
    if not (csDesigning in ComponentState) then
    {$ENDIF}
    FCommThread.Free;
    CloseHandle(FHandle);
    FHandle     := INVALID_HANDLE_VALUE;
    FTotalRead  := 0;
    FTotalSent  := 0;
    FPaused     := 0;
  end else XCommError(SCommClosed, DEC_CLOSED);
end;

{$IFDEF X_DEBUG}
procedure TCustomComm.SetOpened( Value: Boolean );
begin
  if Value and not Opened then OpenDevice
  else if not Value and Opened then CloseDevice
end;
{$ENDIF}

function TCustomComm.GetOpened: boolean;
begin
  Result := FHandle <> INVALID_HANDLE_VALUE;
end;

function TCustomComm.GetPaused: boolean;
begin
  Result := not Opened or (FPaused<>0);
end;

procedure TCustomComm.SetPaused( Value: boolean );
begin
  if Opened then
  begin
    if Value then Inc(FPaused)
    else if (FPaused>0) then Dec(FPaused);
  end;
end;

function TCustomComm.PurgeIn: boolean;
begin
  Result := False;
  if Opened then
  begin
    Inc(FTotalRead, InCount);
    Result := PurgeComm(FHandle, PURGE_RXABORT or PURGE_RXCLEAR);
  end else XCommError(SCommClosed, DEC_CLOSED);
end;

function TCustomComm.PurgeOut: boolean;
begin
  Result := False;
  if Opened
    then Result := PurgeComm(FHandle, PURGE_TXABORT or PURGE_TXCLEAR)
    else XCommError(SCommClosed, DEC_CLOSED);
end;

function TCustomComm.GetTotalReceived: DWORD;
begin
  if Opened
    then Result := FTotalRead + DWORD(InCount)
    else Result := 0;
end;

function TCustomComm.GetCommStatus: TCommStatus;
var ComStat: TCOMSTAT;
    e: DWORD;
begin
  if Opened then
  begin
    if ClearCommError(FHandle, e, @ComStat) then
      Result := TCommStatus(ComStat.Flags)
  end else
  begin
    Result := [];
    XCommError(SCommClosed, DEC_CLOSED);
  end;
end;

function TCustomComm.GetMaxBaud: TBaudRate;
var cp: TCommProp;
begin
  Result := br110;
  if Opened then
  begin
    GetCommProperties(Handle, cp);
    case cp.dwMaxBaud of
      BAUD_300: Result := br300;
      BAUD_600: Result := br600;
      BAUD_1200, BAUD_1800: Result := br1200;
      BAUD_2400: Result := br2400;
      BAUD_4800, BAUD_7200: Result := br4800;
      BAUD_9600: Result := br9600;
      BAUD_14400: Result := br14400;
      BAUD_19200: Result := br19200;
      BAUD_38400: Result := br38400;
      BAUD_56K: Result := br56000;
      BAUD_57600: Result := br57600;
      BAUD_115200: Result := br115200;
      BAUD_128K: Result := br128000;
      BAUD_USER: Result := brCustom;
    end;
  end else XCommError(SCommClosed, DEC_CLOSED);
end;

function TCustomComm.GetCount( Index: integer ): DWORD;
var
  stat: TCOMSTAT;
  errs: DWORD;
begin
  Result := 0;
  if Opened then
  begin
    ClearCommError(FHandle, errs, @stat);
    case Index of
      0: Result := DWORD(stat.cbInQue);
      1: Result := DWORD(stat.cbOutQue);
    end;
  end else XCommError(SCommClosed, DEC_CLOSED);
end;

{===> Alex}
function intSend(Handle: THandle; const Buffer; Count: dword): dword;
var Overlapped: TOverlapped;
    BytesWritten: dword;
begin
  FillChar(Overlapped, SizeOf(Overlapped), 0);
  Overlapped.hEvent := CreateEvent(nil, True, True, nil);
  WriteFile(Handle, Buffer, Count, BytesWritten, @Overlapped);
  WaitForSingleObject(Overlapped.hEvent, INFINITE);
  if not GetOverlappedResult(Handle, Overlapped, BytesWritten, False) then
    XCommWin32Error( SSendError, DEC_SENDERROR );
  CloseHandle(Overlapped.hEvent);
  Result := BytesWritten;
end;

{===> Alex}
function intRead(Handle: THandle; var Buffer; Count: dword): dword;
var Overlapped: TOverlapped;
    BytesRead: dword;
begin
  FillChar(Overlapped, SizeOf(Overlapped), 0);
  Overlapped.hEvent := CreateEvent(nil, True, True, nil);
  ReadFile(Handle, Buffer, Count, BytesRead, @Overlapped);
  WaitForSingleObject(Overlapped.hEvent, INFINITE);
  if not GetOverlappedResult(Handle, Overlapped, BytesRead, False) then
    XCommWin32Error( SReadError, DEC_READERROR );
  CloseHandle(Overlapped.hEvent);
  Result := BytesRead;
end;

function TCustomComm.SendDataEx( const Data; DataSize, Timeout: DWORD ): DWORD;
var nToSend, nSent, t1, t2: DWORD;
    DataPtr: PChar;
begin
  Result := 0;

  if not Opened then
  begin
    XCommError(SCommClosed, DEC_CLOSED);
    Exit;
  end;

  if loSend in Locked then
  begin
    XCommError(SLockedSend, DEC_LOCKEDSEND);
    Exit;
  end;

  if (DataSize=0) then Exit;

  DataPtr:=@Data;
  t1 := GetTickCount;
  while DataSize > 0 do
  begin
    nToSend := FBuffers.FOutputSize - OutCount;
    if nToSend > 0 then
    begin
      if nToSend > DataSize then nToSend := DataSize;
      nSent := intSend(FHandle, DataPtr^, nToSend);
      UpdateEvents([deOutEmpty]);
      if nSent > 0 then
      begin
        Inc(FTotalSent, nSent);
        Inc(Result, nSent);
        Dec(DataSize, nSent);
        DataPtr := DataPtr + nSent;
        Include(FLocked, loSend);
        try
          if Assigned(FOnSend) then FOnSend(Self);
        finally
          Exclude(FLocked, loSend);
        end;
        continue;
      end else
        Sleep(1);
    end else
      Sleep(1);
    t2:=GetTickCount;
    if ((t2-t1)>Timeout) then break;
  end;
end;

function TCustomComm.SendData( const Data; DataSize: DWORD ): DWORD;
begin
  Result := SendDataEx(Data, DataSize, FBuffers.OutputTimeout);
end;

function TCustomComm.SendByte( const Value: byte ): boolean;
begin
  Result := SendData(Value, 1) = 1;
end;

function TCustomComm.SendString( const Value: string ): boolean;
begin
  Result := SendData(Value[1], Length(Value)) = DWORD(Length(Value));
end;

function TCustomComm.ReadDataEx( var Data; MaxDataSize, Timeout: DWORD ): DWORD;
var nToRead, nRead, t1, t2: DWORD;
    DataPtr: PChar;
begin
  Result := 0;
  if not Opened then
  begin
    XCommError(SCommClosed, DEC_CLOSED);
    Exit;
  end;

  if loRead in Locked then
  begin
    XCommError(SLockedRead, DEC_LOCKEDREAD);
    Exit;
  end;

  if (MaxDataSize=0) then Exit;

  DataPtr:=@Data;
  t1 := GetTickCount;
  while MaxDataSize > 0 do
  begin
    nToRead := InCount;
    if nToRead > 0 then
    begin
      if nToRead > MaxDataSize then nToRead := MaxDataSize;
      nRead := intRead(FHandle, DataPtr^, nToRead);
      Inc(FTotalRead, nRead);
      Result := Result + nRead;
      MaxDataSize := MaxDataSize - nRead;
      DataPtr := DataPtr + nRead;
      Include(FLocked, loRead);
      try
        if (nRead>0) and Assigned(FOnRead) then
          FOnRead(Self);
      finally
        Exclude(FLocked, loRead);
      end;
      continue;
    end else
      Sleep(1);
    t2:=GetTickCount;
    if ((t2-t1)>Timeout) then break;
  end;
end;

function TCustomComm.ReadData( var Data; MaxDataSize: DWORD ): DWORD;
begin
  Result := ReadDataEx(Data, MaxDataSize, FBuffers.InputTimeout);
end;

function TCustomComm.ReadByte( var Value: byte ): boolean;
begin
  Result := ReadData(Value, 1) = 1;
end;

function TCustomComm.ReadString( var Value: string ): boolean;
var nRead: DWORD;
begin
  SetLength(Value, InCount);
  nRead := ReadData(Value[1], Length(Value));
  SetLength(Value, nRead);
  Result := (nRead>0);
end;

function TCustomComm.ReadString( var Value: string; Len: integer ): boolean;
begin
  Result:=(DWORD(Len)<=InCount) and (Len>0);
  if Result then
  begin
    SetLength(Value, Len);
    Result := ReadData(Value[1], Len) = DWORD(Len);
  end;
end;

procedure TCustomComm.UpdateEvents( Events: TDeviceEvents );
var I: integer;
begin
  if not Opened or (csDestroying in ComponentState) then Exit;
  for I:=0 to PluginCount-1 do
    if esBefore in Plugins[I].EventState then Plugins[I].HandleEvents(Events);
  HandleEvents(Events);
  for I:=0 to PluginCount-1 do
    if esAfter in Plugins[I].EventState then Plugins[I].HandleEvents(Events);
end;

procedure TCustomComm.HandleEvents( Events: TDeviceEvents );
begin
  if (deChar in Events) or (deFlag in Events) then ReceiveData(InCount);
  if (FPaused=0) and Assigned(FOnCommEvent) and (Events*FEvents<>[]) then
    FOnCommEvent(Self, Events*FEvents);
end;

procedure TCustomComm.ReceiveData( Received: DWORD );
begin
  if (FPaused=0) and Assigned(FOnData) then FOnData(Self, Received);
end;

procedure TCustomComm.ToggleBreak( Status: TBreakStatus );
const func_: array[TBreakStatus] of integer = ( CLRBREAK, SETBREAK );
begin
  if Opened
    then EscapeCommFunction(FHandle, func_[Status])
    else XCommError(SCommClosed, DEC_CLOSED);
end;

procedure TCustomComm.ToggleDTR( Status: TBreakStatus );
const func_: array[TBreakStatus] of integer = ( CLRDTR, SETDTR );
begin
  if Opened
    then EscapeCommFunction(FHandle, func_[Status])
    else XCommError(SCommClosed, DEC_CLOSED);
end;

procedure TCustomComm.ToggleRTS( Status: TBreakStatus );
const func_: array[TBreakStatus] of integer = ( CLRRTS, SETRTS );
begin
  if Opened
    then EscapeCommFunction(FHandle, func_[Status])
    else XCommError(SCommClosed, DEC_CLOSED);
end;

procedure TCustomComm.ToggleXonXoff( Status: TBreakStatus);
const func_: array[TBreakStatus] of integer = (SETXOFF,SETXON);
begin
  if Opened
    then EscapeCommFunction( FHandle, func_[Status])
    else XCommError(SCommClosed, DEC_CLOSED);
end;


function TCustomComm.WaitForString( const Value: array of string;
                                   Timeout: DWORD;  var Data: String): integer;
var ch: char;
    t1, t2: DWORD;
    i, nOut: integer;
begin
  Result := -1;
  if not Opened then
  begin
    XCommError(SCommClosed, DEC_CLOSED);
    Exit;
  end;
  if loRead in Locked then
  begin
    XCommError(SLockedRead, DEC_LOCKEDREAD);
    Exit;
  end;
  if (High(Value)=-1) then Exit;
  Paused := True;
  try
    t1:=GetTickCount;
    Data:='';
    nOut := 0;
    repeat
      if (ReadDataEx(ch, 1, 0)=1) then
      begin
        Data:=Data+ch;
        for i:=0 to High(Value) do
        if (Pos(Value[i], Data)>0) then
        begin
          Result := i;
          Break;
        end;
        Inc(nOut);
        if (nOut<10) and (InCount>0) then Continue;
      end;
      nOut := 0;
      t2:=GetTickCount;
      if (Timeout>0) and ((t2-t1)>=Timeout) then Break;
    until (Result<>-1) or Application.Terminated or not Opened;
  finally
    Paused := False;
  end;
end;

procedure TCustomComm.InternalAsyncProc( Success: boolean; Data: pointer; Count: integer );
begin
  if Success and (Data=nil) then
  begin
    Inc(FTotalSent, Count);
    if Assigned(FOnSend) then FOnSend(Self);
  end else if Success then
  begin
    Inc(FTotalRead, Count);
    if Assigned(FOnRead) then FOnRead(Self);
  end;
  if Assigned(FSavedAsyncProc) then
    FSavedAsyncProc(Success, Data, Count);
end;

function TCustomComm.InitAsync( AsyncProc: TAsyncProc; AutoClose: boolean ): HASYNC;
begin
  Result := 0;
  FSavedAsyncProc := AsyncProc;
  if Opened then
    Result := InternalInitAsync(FHandle, InternalAsyncProc, AutoClose)
  else
    XCommError(SCommClosed, DEC_CLOSED);
end;

function TCustomComm.CloseAsync( Async: HASYNC ): boolean;
begin
  Result := InternalCloseAsync(Async);
end;

function TCustomComm.SendAsync( Async: HASYNC; const Data; DataSize: DWORD ): DWORD;
begin
  Result := 0;
  if Opened then
  begin
    if loSend in Locked then
      XCommError(SLockedSend, DEC_LOCKEDSEND)
    else
    begin
      Result := InternalWriteAsync(Async, Data, DataSize);
      UpdateEvents([deOutEmpty]);
    end;
  end else
    XCommError(SCommClosed, DEC_CLOSED);
end;

function TCustomComm.SendStringAsync( Async: HASYNC; const Value: string ): DWORD;
begin
  Result := 0;
  if Opened then
  begin
    if loSend in Locked then
      XCommError(SLockedSend, DEC_LOCKEDSEND)
    else if Length(Value)>0 then
    begin
      Result := InternalWriteAsync(Async, Value[1], Length(Value));
      UpdateEvents([deOutEmpty]);
    end;
  end else
    XCommError(SCommClosed, DEC_CLOSED);
end;

function TCustomComm.ReadAsync( Async: HASYNC; var Data; DataSize: DWORD ): DWORD;
begin
  Result := 0;
  if Opened then
  begin
    if loRead in Locked then
      XCommError(SLockedRead, DEC_LOCKEDREAD)
    else
      Result := InternalReadAsync(Async, Data, DataSize);
  end else
    XCommError(SCommClosed, DEC_CLOSED);
end;

function TCustomComm.ReadStringAsync( Async: HASYNC; var Value: string ): DWORD;
begin
  Result := 0;
  if Opened then
  begin
    if loRead in Locked then
      XCommError(SLockedRead, DEC_LOCKEDREAD)
    else
      Result := InternalReadStringAsync(Async, Value);
  end else
    XCommError(SCommClosed, DEC_CLOSED);
end;

function TCustomComm.WaitAsync( Async: HASYNC; Process: TWaitProc ): boolean;
begin
  Result := False;
  if Opened then
    Result := InternalWaitAsync(Async, Process)
  else
    XCommError(SCommClosed, DEC_CLOSED);
end;

function TCustomComm.GetLocked: TLockState;
  function PluginLocked: TLockState;
  var I: integer;
  begin
    Result := FLocked;
    for I:=0 to PluginCount-1 do
    begin
      Result := Result + Plugins[I].LockState;
      if Result = [loRead, loSend] then Exit;
    end;
  end;
begin
  Result := [loRead, loSend];
  if Opened then Result := PluginLocked;
end;

{-- TModemSettings --}

constructor TModemSettings.Create;
begin
  inherited Create;
  FConnectType   := ctDial;
  FDialNumber    := '';
  FDialType      := dtTone;
  FInitString    := 'ATX&C1&D2&K3M0';
  FResetString   := 'ATZ';
  FSpeed         := 33600;
  FWaitRings     := 2;
end;

procedure TModemSettings.AssignTo( Dest: TPersistent );
begin
  if (Dest is TModemSettings) then
  begin
    FInitString  := TModemSettings(Dest).InitString;
    FResetString := TModemSettings(Dest).ResetString;
    FSpeed       := TModemSettings(Dest).Speed;
    FDialType    := TModemSettings(Dest).DialType;
    FDialNumber  := TModemSettings(Dest).DialNumber;
    FConnectType := TModemSettings(Dest).ConnectType;
    FWaitRings   := TModemSettings(Dest).WaitRings;
  end
  else
    inherited AssignTo(Dest);
end;

procedure TModemSettings.SetSpeed( Value: Longint );
begin
  case Value of
    0, 2400, 4800, 7200, 9600, 12000, 14400, 16800,
    19200, 21600, 24000, 26400, 28800, 31200, 33600,
    56000, 57600 : FSpeed := Value;
  end;
end;

{-- TCustomModem support--}
const
  MRC_: array [0..7] of string =
    ( 'OK', 'CONNECT', 'RING', 'NO CARRIER','ERROR', 'NO DIALTONE', 'BUSY',
     'NO ANSWER' );
  MRC_UNKNOWN = 'UNKNOWN';

function ATShortToLong( var s: string ): boolean;
var i, ec: integer;
begin
  Val(s, i, ec);
  Result := (ec = 0);
  if Result then
    case i of
      0..4: s := MRC_[i];
      6..8: s := MRC_[i-1];
 //     5, 9..26, 28..32, 34, 59..104: s := MRC_[ME_CONNECT];   //I'm not sure about this
      else s:='UNKNOWN';
    end;
end;


function ATResultToME( s: string ): integer;
var i: integer;
begin
  Result := ME_INVALID;
  if (s<>'') and (s[1] in ['0'..'9']) then
  begin
    s := Copy(s, 1, 3);
    ATShortToLong(s);
  end;
  if (s = MRC_UNKNOWN) then
    Result:=ME_UNKNOWN
  else if (s<>'') then
  for i:=0 to 7 do
    if (Pos(MRC_[i], s)=1) then
    begin
      Result:=i;
      Exit;
    end;
end;

procedure RemoveChar( const ch: char; var s: string );
var i: integer;
begin
  i := 1;
  while (i<=Length(s)) do
    if s[i]=ch then
      Delete(s, i, 1)
    else
      Inc(i);
end;

function StripAT(var CmdLine: string): Boolean;
var i: integer;
begin
  Result := False;
  RemoveChar(' ', CmdLine);
  i := 1;
  while (i<=Length(CmdLine)) do
  begin
    case CmdLine[i] of
      '+':
      begin
        while (i<=Length(CmdLine)) and not (CmdLine[i] in ['=', '?']) do
          Delete(CmdLine, i, 1);
        Delete(CmdLine, i, 1);
        Result := True;
      end;
      '-','#':
      begin
        while (i<=Length(CmdLine)) and
          not (CmdLine[i] in ['=', '?','0'..'9']) do
          Delete(CmdLine, i, 1);
        Delete(CmdLine, i, 1);
        Result := True;
      end;
      'D', 'd': Delete(CmdLine, i+1, MaxLongInt);
    end;
    Inc(i);
  end;
end;

function IsRegAT( Value: string ): boolean;
var i: integer;
  function FindRegAT( const Value: string): boolean;
  begin
    Result := (Length(Value) > 4) and (Copy(Value, 1, 3) = 'ATS') and
      (Pos('=', Value) in [4..7]);
    if Result and (Value[4]<>'=') then
    begin
      i:=4;
      while (Value[i] in ['0'..'9']) do
        inc(i);
      Result :=(Value[i] = '=') and (Value[i-1] in ['0'..'9']) and
        (Length(Value)>i);
    end
  end;
begin
  Result := False;
  StripAT(Value);
  Value := UpperCase(Value);
  repeat
    i := Pos('S', Value);
    if (i>0) then
    begin
      Result :=  FindRegAT('AT'+Copy(Value, i, Length(Value)-i+1));
      if Result then Break;
      Delete(Value, 1, i);
    end;
  until i=0;
end;

function ATPos( CmdLine, Cmd: string ): integer;
begin
  Result := 0;
  StripAT(CmdLine);
  if (Cmd='') or (Length(CmdLine)<2) then
    Exit;
  if (Copy(CmdLine, 1, 2) = 'AT') then
  begin
    if (Cmd[1] in ['A','D']) then
      SetLength(Cmd, 1)
    else if (Cmd[Length(Cmd)]='0') then
      SetLength(Cmd, Length(Cmd)-1);
    Result := 3;
    while (Result>0) do
    begin
      if (Copy(CmdLine, Result, Length(Cmd)) = Cmd)
        and (CmdLine[Result-1] in ['0'..'9','A'..'Z', '?','=',' ']) then
        Break
      else
        inc(Result);
      if (Result>Length(CmdLine)-Length(Cmd)+1) then
        Result:=0;
    end;
  end;
end;


function IsConnectAT( const CmdLine: string ): Byte;
begin
  Result := 0;
  if ((ATPos(CmdLine, 'D')>0) and (CmdLine[Length(CmdLine)]<>';')) then
    Result := 1;
  if (ATPos(CmdLine, 'A')>0) then
    Result := 2;
end;

function RegToStr(Value, Len: Byte): string;
begin
  Str(Value, Result);
  while (Length(Result)<Len) do Result := '0'+Result;
end;

{-- TCustomModem --}

constructor TCustomModem.Create( AOwner: TComponent );
begin
  inherited Create(AOwner);
  FModemSettings := TModemSettings.Create;
end;

destructor TCustomModem.Destroy;
begin
  inherited Destroy;
  FModemSettings.Free;
end;

function TCustomModem.OpenDevice: boolean;
begin
  Result := inherited OpenDevice;
  WRegSent := False;
  FModemState := [];
  WLocked := False;
end;

procedure TCustomModem.CloseDevice;
begin
  if Opened then
  begin
    if Connected then Disconnect;
    if (msConnected in FModemState) then DoDisconnect;
    inherited CloseDevice;
  end else XCommError(SCommClosed, DEC_CLOSED);
end;

procedure TCustomModem.SetModemSettings( Value: TModemSettings );
begin
  if (FModemSettings<>Value) then
    FModemSettings.Assign(Value);
end;

function TCustomModem.GetEnterCmd: string;
begin
  Result := FECChar+FECChar+FECChar;
end;

function TCustomModem.InitCommand( Value: string ): boolean;
var i: integer;
begin
  Result := False;
  if (BaudValue<MB_MINBAUD) or not Installed then Exit;
  FCommand := Value;
  if not WRegSent then
  repeat
    i := ATPos(Value, 'Q1');
    if (i>0) then Value[i+1] := '0';
  until (i=0);
  if (Value <> GetEnterCmd) and (UpperCase(Value) <> 'A/') then
    Value := Value+#13#10;
  PurgeIn; PurgeOut;
  FBuffer := '';
  Include(FModemState, msATSent);
  WLocked := False;
  try
    Result := SendString(Value);
  finally
    WLocked := True;
    if Result then
    begin
      if not WRegSent then
      case IsConnectAT(Value) of
        1: DoConnecting(ctDial);
        2: DoConnecting(ctDirect);
      end;
    end else
      Exclude(FModemState, msATSent);
  end;
end;

function TCustomModem.SendCommand( const Value: string ): boolean;
begin
  Result := False;
  if not Opened then
    XCommError(SCommClosed, DEC_CLOSED)
  else if not (msCommandState in ModemState)
  and ((Connected and (Value<>GetEnterCmd)) or not Connected) then
    XCommError(SNoCommandState, DEC_NOCOMMANDSTATE)
  else Result := not (msATSent in ModemState)
    and not IsRegAT(Value) and ((UpperCase(Copy(Value, 1, 2)) = 'AT')
    or (UpperCase(Value) = 'A/') or (Connected and (Value = GetEnterCmd)))
    and InitCommand(Value);
end;

function TCustomModem.SetRegisterValue( Reg, Value: byte ): boolean;
begin
  Result := False;
  if not Opened then
  begin
    XCommError(SCommClosed, DEC_CLOSED);
    Exit;
  end else if not (msCommandState in ModemState) then
  begin
    XCommError(SNoCommandState, DEC_NOCOMMANDSTATE);
    Exit;
  end;
  case Reg of
    2: if (Value > 0) then Value := byte('+');
    3: Value := 13;
    4: Value := 10;
  end;
  WRegSent := True;
  Paused := True;
  try
    Result := (msCommandState in ModemState) and not (msATSent in ModemState)
      and InitCommand('ATS'+RegToStr(Reg, 0)+'='+RegToStr(Value, 3)) and (WaitForAT(0).ME=ME_OK);
  finally
    Paused := False;
  end;
  if Result then
  case Reg of
    0: if not Connected then
    begin
      if (Value>0) and not (msWaitingCall in ModemState) then
        DoConnecting(ctWait)
      else if (Value=0) and (msWaitingCall in ModemState) then
      begin
        DoDisconnecting;
        Exclude(FModemState, msDisconnecting);
      end;
    end;
    2: FECChar := char(Value);
  end else WRegSent := False;
end;

function TCustomModem.GetRegisterValue( Reg: byte; var Value: byte ): boolean;
var AT: THayesAT;
begin
  Result := False;
  if not Opened then
  begin
    XCommError(SCommClosed, DEC_CLOSED);
    Exit;
  end else if not (msCommandState in ModemState) then
  begin
    XCommError(SNoCommandState, DEC_NOCOMMANDSTATE);
    Exit;
  end;
  WRegSent := True;
  Paused := True;
  try
    Result := not (msATSent in ModemState) and InitCommand('ATS'+RegToStr(Reg, 0)+'?');
    if Result then
    begin
      AT:=WaitForAT(0);
      Result:=(AT.ME=ME_OK) and (AT.Data<>'') and (Length(AT.Data)<=3);
      if Result then
      begin
        Val(AT.Data, Value, AT.ME);
        Result := (AT.ME=0);
      end;
    end else WRegSent := False;
  finally
    Paused := False;
  end;
end;

function TCustomModem.EnterCommandState: boolean;
begin
  if not Opened then
  begin
    Result := False;
    XCommError(SCommClosed, DEC_CLOSED);
    Exit;
  end;
  WLocked := False;
  Paused := True;
  try
    if Connected and (not (msCommandState in ModemState))
      and (FECChar<>#0) and InitCommand(GetEnterCmd)
      and (WaitForAT(0).ME = ME_OK) then begin end
    else if not Connected and not (msCommandState in ModemState) and Installed then
    begin
      FModemState := [msCommandState];
      DoChangeCmdState;
    end;
  finally
    Paused := False;
  end;
  Result := (msCommandState in ModemState);
  WLocked := Result;
end;

function TCustomModem.GetInstalled: boolean;
begin
  Result := Opened and (lsDSR in LineStatus);  //Seems to work OK.
end;

function TCustomModem.ExitCommandState: boolean;
begin
  if not Opened then
  begin
    Result := False;
    XCommError(SCommClosed, DEC_CLOSED);
    Exit;
  end;
  if Opened and not Connected and (msCommandState in ModemState) then
  begin
    Exclude(FModemState, msCommandState);
    Result := True;
    DoChangeCmdState;
  end else
  begin
    Paused := True;
    try
      Result := Connected and (msCommandState in ModemState) and InitCommand('ATO')
        and (WaitForAT(0).ME=ME_CONNECT);
    finally
      Paused := False;
    end;
  end;
  WLocked := not Result;
end;

procedure TCustomModem.ReceiveData( Received: DWORD );
var
  AT: THayesAT;
  s: string;

  procedure WaitRX;
  var t, Timeout: DWORD;
  begin
    t := GetTickCount;
    Timeout := GetRXTimeout(BaudValue, 1);
    while (GetTickCount-t<Timeout) and (InCount=0) do;
  end;

  procedure GetCommand;
  var sm: string[2];
  begin
    while (Length(s)>1) and (s[1]<#31) do
      Delete(s, 1, 1);
    AT.Command := '';
    sm := UpperCase(Copy(s, 1, 2));
    if (sm='AT') or (sm='A/') then
    begin
      while (s<>'') and (s[1]<>#13) do
      begin
        AT.Command := AT.Command+s[1];
        Delete(s, 1, 1);
      end;
    end else if (UpperCase(FCommand)<>'A/') then
      AT.Command := FCommand;
  end;

  procedure GetData;
  var I: integer;
  begin
    while (s<>'') and (s[1]=#13) do
      Delete(s, 1, 1);
    while (s<>'') and (s[Length(s)]=#13) do
      Delete(s, Length(s), 1);
    I := 0;
    repeat
      Inc(I);
      if I>Length(s) then I := 0;
      if (I>0) and (s[I]=#13) then
      begin
        Insert(#10, s, I+1);
        inc(I);
      end;
    until (I=0);
    AT.Data := s;
  end;


  function HasResult: boolean;
  var I: integer;
  begin
    Result := False;
    I := Length(s);
    if (I>0) and (s[I]=#13) then
    begin
      AT.Result := '';
      Dec(I);
      while (I>0) and (s[I]<>#13) do
      begin
        AT.Result := s[I]+AT.Result;
        Dec(I);
      end;
      if (I>0) then
      begin
        AT.ME := ATResultToME(AT.Result);
        WaitRX;
        if (AT.ME<>ME_INVALID) and (InCount=0) then
        begin
          Delete(s, I, MaxInt);
          GetCommand;
          GetData;
          Result := True;
        end;
      end;
    end;
  end;

begin
  if (msATSent in ModemState) then
  begin
    WLocked := False;
    ReadString(s);
    WLocked := True;
    s := FBuffer+s;
    RemoveChar(#10, s);
    if HasResult then
    begin
      FBuffer := '';
      Exclude(FModemState, msATSent);
      HandleAT(AT);
    end else FBuffer := s;
  end else if not (msCommandState in ModemState) then
    inherited ReceiveData(InCount);
end;

procedure TCustomModem.HandleEvents( Events: TDeviceEvents );
begin
  if (deRLSD in Events) and not (deRing in Events) and not (lsRing in LineStatus) then
  begin
    if (lsCD in LineStatus) then
    begin
      WCmdPresent := (msCommandState in ModemState);
      Exclude(FModemState, msCommandState);
      DoConnect;
    end else if (msConnected in FModemState) then
    begin
      if WCmdPresent then
      begin
        Include(FModemState, msCommandState);
        if not (msDisconnecting in ModemState) then
          DoDisconnecting;
      end;
      DoDisconnect;
    end;
  end;
  if Installed and (deRING in Events) and (not (deRLSD in EVents))
  and (msCommandState in ModemState) and Assigned(FOnRing) then FOnRing(Self);
  inherited HandleEvents(Events);
end;

procedure TCustomModem.HandleAT( AT: THayesAT );
begin
  if Connected then
  begin
    if (ATPos(AT.Command, 'O') > 0) and (AT.ME = ME_CONNECT) then
    begin
      Exclude(FModemState, msCommandState);
      DoChangeCmdState;
    end else if (AT.Command = GetEnterCmd) and (AT.ME = ME_OK) then
    begin
      Include(FModemState, msCommandState);
      DoChangeCmdState;
    end;
  end;
  if (msConnecting in ModemState) and Connected
    then AT.ME := ME_CONNECT;
  if (msConnecting in ModemState) and not (msWaitingCall in ModemState) then
  begin
    Exclude(FModemState, msConnecting);
    if (AT.ME<>ME_CONNECT) then DoDisconnecting;
    Exclude(FModemState, msDisconnecting);
  end;
  WHayesAT := AT;
  if not Paused and not WRegSent and Assigned(FOnHayesAT) then FOnHayesAT(Self, AT);
  WRegSent := False;
end;

procedure TCustomModem.DoConnect;
begin
  Include(FModemState, msConnected);
  try
    if Assigned(FOnConnect) then FOnConnect(Self);
  finally
    FModemState := [msConnected];
  end;
end;

procedure TCustomModem.DoDisconnect;
begin
  Exclude(FModemState, msConnected);
  try
    if Assigned(FOnDisconnect) then FOnDisconnect(Self);
  finally
    Exclude(FModemState, msDisconnecting);
  end;
end;

procedure TCustomModem.DoConnecting(ConnectType: TConnectType);
begin
  if (ConnectType = ctWait) then Include(FModemState, msWaitingCall);
  if not (msConnecting in ModemState) then
  begin
    Include(FModemState, msConnecting);
    if Assigned(FOnConnecting) then FOnConnecting(Self, ConnectType);
  end;
end;

procedure TCustomModem.DoDisconnecting;
begin
  if not (msDisconnecting in ModemState) then
  begin
    FModemState := FModemState-[msConnecting, msWaitingCall];
    Include(FModemState, msDisconnecting);
    if Assigned(FOnDisconnecting) then FOnDisconnecting(Self);
  end;
end;

procedure TCustomModem.DoChangeCmdState;
begin
  if Assigned(FOnChangeCS) then FOnChangeCS(Self);
end;

function TCustomModem.ResetModem: boolean;
begin
  Paused := True;
  try
    Result := SendCommand(FModemSettings.FResetString) and (WaitForAT(0).ME = ME_OK);
  finally
    Paused := False;
  end;
end;

function TCustomModem.InitModem: boolean;
begin
  Paused := True;
  try
    if (FModemSettings.FSpeed<>0) then
      Result := SendCommand('AT+MS=11,1,300,'+IntToStr(FModemSettings.FSpeed))
        and (WaitForAT(0).ME = ME_OK)
    else
      Result := True;
    Result := Result and SendCommand(FModemSettings.FInitString)
      and (WaitForAT(0).ME = ME_OK);
  finally
    Paused := False;
  end;
end;

function TCustomModem.WaitForAT( Timeout: DWORD ): THayesAT;
var t: DWORD;
begin
  FillChar(WHayesAT, SizeOf(THayesAT), 0);
  WHayesAT.ME := ME_INVALID;
  Result := WHayesAT;
  if not Opened then
  begin
    XCommError(SCommClosed, DEC_CLOSED);
    Exit;
  end else if not (msCommandState in ModemState)
  and (not (msATSent in ModemState) or ((msATSent in ModemState)
  and (FCommand<>GetEnterCmd))) then
  begin
    XCommError(SNoCommandState, DEC_NOCOMMANDSTATE);
    Exit;
  end;
  if not (msATSent in ModemState) then Exit;
  WHayesAT.ME := -2;
  t:=GetTickCount;
  repeat
    Application.ProcessMessages;
    if (Timeout>0) and (GetTickCount-t>Timeout) then
      Break;
  until (WHayesAT.ME<>-2) or Application.Terminated or not Opened or not Installed;
  if WHayesAT.ME = -2 then WHayesAT.ME := ME_INVALID;
  Result := WHayesAT;
end;

function TCustomModem.GetConnected: boolean;
begin
  Result := Opened and (lsCD in LineStatus);
end;

function TCustomModem.Connect(WaitResult: Boolean): boolean;
var s: string;
begin
  Result := False;
  case FModemSettings.ConnectType of
    ctDial:
    begin
      s:='ATD';
      case FModemSettings.FDialType of
        dtTone: s := s+'T';
        dtPulse: s := s+'P';
      end;
      s:=s+FModemSettings.FDialNumber;
    end;
    ctDirect: s := 'ATA';
    ctWait:
    begin
      if (FModemSettings.FWaitRings>0) and SetRegisterValue(0, FModemSettings.FWaitRings)
      then if WaitResult then
      begin
        repeat
          Application.ProcessMessages;
        until not (msWaitingCall in ModemState)
          or Application.Terminated or not Opened;
        Result := Connected;
      end;
      Exit;
    end;
  end;
  Paused := True;
  try
    if SendCommand(s) then if WaitResult then
      Result := (WaitForAT(0).ME = ME_CONNECT);
  finally
    Paused := False;
  end;
end;

procedure TCustomModem.Disconnect;
begin
  if not Opened then
  begin
    XCommError(SCommClosed, DEC_CLOSED);
    Exit;
  end;
  if (msWaitingCall in ModemState) then
    SetRegisterValue(0, 0)
  else if (msConnecting in ModemState) then
  begin
    DoDisconnecting;
    Paused := True;
    WLocked := False;
    try
      SendString(#13#10#27);
      WaitForAT(0);
    finally
      Paused := False;
      WLocked := True;
    end;
    Exclude(FModemState, msDisconnecting);
  end else if Connected and (FECChar<>#0) then
  begin
    DoDisconnecting;
    Paused := True;
    try
      if not (msCommandState in ModemState) and EnterCommandState
      and InitCommand('ATH') and (WaitForAT(0).ME = ME_OK) then
      begin
         if (msConnected in FModemState) then DoDisconnect;
         Exclude(FModemState, msDisconnecting);
      end;
    finally
      Paused := False;
    end;
  end;
end;

procedure TCustomModem.LowerDTR;
begin
  if not Opened then
  begin
    XCommError(SCommClosed, DEC_CLOSED);
    Exit;
  end;
  if fsDTREnabled in DTRSettings then
  begin
    if Connected then DoDisconnecting;
    ToggleBreak(brSet);
    ToggleDTR(brClear);
    ToggleBreak(brClear);
  end;
end;

function TCustomModem.GetLineStatus: TLineStatus;
var dwStatus: DWORD;
begin
  Result := [];
  if Opened and GetCommModemStatus(FHandle, dwStatus) then
  begin
    if (dwStatus and MS_CTS_ON <> 0) then Result := Result + [lsCTS];
    if (dwStatus and MS_DSR_ON <> 0) then Result := Result + [lsDSR];
    if (dwStatus and MS_RING_ON <> 0) then Result := Result + [lsRING];
    if (dwStatus and MS_RLSD_ON <> 0) then Result := Result + [lsCD];
  end else if not Opened then
    XCommError(SCommClosed, DEC_CLOSED);
end;

function TCustomModem.GetModemState: TModemState;
begin
  if Installed then
    Result := FModemState + [msInstalled]
  else
    Result := [];
end;

function TCustomModem.GetLocked: TLockState;
begin
  Result := inherited GetLocked;
  if (msCommandState in ModemState) and WLocked then
    Include(Result, loRead);
end;

//timing

{var
  I_ExtendedTicks: Boolean;
  I_Freq: Int64;

function GetTickCount: DWORD;
var L: Int64;
begin
  if I_ExtendedTicks and QueryPerformanceCounter(L) then
    Result := Round(L/I_Freq*1000)
  else
    Result := Windows.GetTickCount;
end;

function InitExtendedTicks: Boolean;
var L: Int64;
begin
   Result := QueryPerformanceFrequency(L);
   if Result then I_Freq := L;
end;

}

function GetTickCount: DWord;
var
  nTime, freq: Int64;
begin
  if QueryPerformanceFrequency(freq) then begin
    if QueryPerformanceCounter(nTime) then begin
      Result:=Trunc((nTime / Freq) * 1000) and High(Cardinal)
    end else begin
      Result:=Windows.GetTickCount;
    end;
  end else begin
    Result:=Windows.GetTickCount;
  end;
end;


initialization
 // I_ExtendedTicks := InitExtendedTicks;
finalization

end.