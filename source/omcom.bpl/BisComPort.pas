unit BisComPort;

interface

uses Classes, SysUtils,
     CPort, CPortTypes,
     BisCoreObjects;

type
  TBisComPortStatusEvent=procedure(Sender: TObject; const Message: String) of object;

  TBisComPortBaudRate = (brCustom, br110, br300, br600, br1200, br2400, br4800, br9600, br14400,
                         br19200, br38400, br56000, br57600, br115200, br128000, br256000);
  TBisComPortStopBits = (sbOneStopBit, sbOne5StopBits, sbTwoStopBits);
  TBisComPortDataBits = (dbFive, dbSix, dbSeven, dbEight);
  TBisComPortParityBits=(prNone, prOdd, prEven, prMark, prSpace);

  TBisComPort=class(TBisCoreObject)
  private
    FComPort: TCustomComPort;
    FOnStatus: TBisComPortStatusEvent;
    FSDisconnected: String;
    FSConnected: String;
    FSFramingError: String;
    FSBufferOverrun: String;
    FSParityError: String;
    FSBreakCondition: String;
    FSIOError: String;
    FSModeNotSupported: String;
    FSBufferOverflow: String;
    FSBufferFull: String;
    procedure ComPortAfterOpen(Sender: TObject);
    procedure ComPortAfterClose(Sender: TObject);
    procedure ComPortError(Sender: TObject; Errors: TComErrors);
    function GetConnected: Boolean;
    function GetPort: String;
    procedure SetPort(const Value: String);
    function GetBaudRate: TBisComPortBaudRate;
    function GetDataBits: TBisComPortDataBits;
    function GetStopBits: TBisComPortStopBits;
    procedure SeTBisComPortBaudRate(const Value: TBisComPortBaudRate);
    procedure SetDataBits(const Value: TBisComPortDataBits);
    procedure SetStopBits(const Value: TBisComPortStopBits);
    function GetParityBits: TBisComPortParityBits;
    procedure SetParityBits(const Value: TBisComPortParityBits);
  protected
    procedure DoStatus(const Message: String); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect; virtual;
    procedure Disconnect; virtual;

    property Port: String read GetPort write SetPort;
    property BaudRate: TBisComPortBaudRate read GetBaudRate write SeTBisComPortBaudRate;
    property StopBits: TBisComPortStopBits read GetStopBits write SetStopBits;
    property DataBits: TBisComPortDataBits read GetDataBits write SetDataBits;
    property ParityBits: TBisComPortParityBits read GetParityBits write SetParityBits; 

    property Connected: Boolean read GetConnected;
    property ComPort: TCustomComPort read FComPort; 

    property OnStatus: TBisComPortStatusEvent read FOnStatus write FOnStatus;
  published
    property SDisconnected: String read FSDisconnected write FSDisconnected;
    property SConnected: String read FSConnected write FSConnected;
    property SFramingError: String read FSFramingError write FSFramingError;
    property SBufferOverrun: String read FSBufferOverrun write FSBufferOverrun;
    property SParityError: String read FSParityError write FSParityError;
    property SBreakCondition: String read FSBreakCondition write FSBreakCondition;
    property SIOError: String read FSIOError write FSIOError;
    property SModeNotSupported: String read FSModeNotSupported write FSModeNotSupported;
    property SBufferOverflow: String read FSBufferOverflow write FSBufferOverflow;
    property SBufferFull: String read FSBufferFull write FSBufferFull;
  end;

implementation

uses BisUtils;

{ TBisComPort }

constructor TBisComPort.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComPort:=TCustomComPort.Create(Self);
  FComPort.BaudRate:=CPortTypes.br9600;
  FComPort.DataBits:=CPortTypes.dbEight;
  FComPort.StopBits:=CPortTypes.sbOneStopBit;
  FComPort.Parity.Bits:=CPortTypes.prNone;
  FComPort.OnAfterOpen:=ComPortAfterOpen;
  FComPort.OnAfterClose:=ComPortAfterClose;
  FComPort.OnError:=ComPortError;

  FSDisconnected:='Соединение разорвано %s.';
  FSConnected:='Соединение установлено %s.';
  FSFramingError:='Обнаружина ошибка конструкции.';
  FSBufferOverrun:='A charachter buffer overrun has occured. The next charachter is lost.';
  FSParityError:='The hardware detected a parity error.';
  FSBreakCondition:='The hardware detected a break condition.';
  FSIOError:='An I/O error occured during communication with the device.';
  FSModeNotSupported:='The requested mode is not supported.';
  FSBufferOverflow:='An input buffer overflow has occured.';
  FSBufferFull:='The output buffer is full.';
end;

destructor TBisComPort.Destroy;
begin
  FComPort.Free;
  inherited Destroy;
end;

procedure TBisComPort.DoStatus(const Message: String);
begin
  if Assigned(FOnStatus) then
    FOnStatus(Self,Message);
end;

procedure TBisComPort.ComPortAfterClose(Sender: TObject);
begin
  DoStatus(FormatEx(FSDisconnected,[FComPort.Port]));
end;

procedure TBisComPort.ComPortAfterOpen(Sender: TObject);
begin
  DoStatus(FormatEx(FSConnected,[FComPort.Port])); 
end;

procedure TBisComPort.ComPortError(Sender: TObject; Errors: TComErrors);
begin
  if Errors = [] then Exit;
  if ceFrame in Errors then
    DoStatus(FSFramingError);
  if ceOverrun in Errors then
    DoStatus(FSBufferOverrun);
  if ceRxParity in Errors  then
    DoStatus(FSParityError);
  if ceBreak in Errors  then
    DoStatus(FSBreakCondition);
  if ceIO in Errors  then
    DoStatus(FSIOError);
  if ceMode in Errors  then
    DoStatus(FSModeNotSupported);
  if ceRxOver in Errors  then
    DoStatus(FSBufferOverflow);
  if ceTxFull in Errors  then
    DoStatus(FSBufferFull);
end;

procedure TBisComPort.Connect;
begin
  try
    FComPort.Connected:=true;
  except
    on E: Exception do
      DoStatus(E.Message);
  end;
end;

procedure TBisComPort.Disconnect;
begin
  try
    FComPort.Connected:=false;
  except
    on E: Exception do
      DoStatus(E.Message);
  end;
end;

function TBisComPort.GetConnected: Boolean;
begin
  Result:=FComPort.Connected;
end;

function TBisComPort.GetParityBits: TBisComPortParityBits;
begin
 Result:=TBisComPortParityBits(FComPort.Parity.Bits);
end;

function TBisComPort.GetPort: String;
begin
  Result:=FComPort.Port;
end;

function TBisComPort.GetBaudRate: TBisComPortBaudRate;
begin
  Result:=TBisComPortBaudRate(FComPort.BaudRate);
end;

function TBisComPort.GetDataBits: TBisComPortDataBits;
begin
  Result:=TBisComPortDataBits(FComPort.DataBits);
end;

function TBisComPort.GetStopBits: TBisComPortStopBits;
begin
  Result:=TBisComPortStopBits(FComPort.StopBits);
end;

procedure TBisComPort.SetBisComPortBaudRate(const Value: TBisComPortBaudRate);
begin
  FComPort.BaudRate:=TBaudRate(Value);
end;

procedure TBisComPort.SetDataBits(const Value: TBisComPortDataBits);
begin
  FComPort.DataBits:=TDataBits(Value);
end;

procedure TBisComPort.SetParityBits(const Value: TBisComPortParityBits);
begin
  FComPort.Parity.Bits:=TParityBits(Value);
end;

procedure TBisComPort.SetPort(const Value: String);
begin
  FComPort.Port:=Value;
end;

procedure TBisComPort.SetStopBits(const Value: TBisComPortStopBits);
begin
  FComPort.StopBits:=TStopBits(Value);
end;

end.
