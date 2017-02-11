unit BisBarcodeScanner;

interface

uses Classes, SysUtils,
     CPort,
     BisCoreObjects;

type
  TBisBarcodeScannerBarcodeEvent=procedure(Sender: TObject; const Barcode: String) of object;
  TBisBarcodeScannerStatusEvent=procedure(Sender: TObject; const Message: String) of object;

  TBisBaudRate = (brCustom, br110, br300, br600, br1200, br2400, br4800, br9600, br14400,
                  br19200, br38400, br56000, br57600, br115200, br128000, br256000);
  TBisStopBits = (sbOneStopBit, sbOne5StopBits, sbTwoStopBits);
  TBisDataBits = (dbFive, dbSix, dbSeven, dbEight);

  TBisBarcodeScanner=class(TBisCoreObject)
  private
    FComPort: TCustomComPort;
    FOnBarcode: TBisBarcodeScannerBarcodeEvent;
    FTempStr: String;
    FOnStatus: TBisBarcodeScannerStatusEvent;
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
    FBarCodeSize: Integer;
    procedure ComPortRxChar(Sender: TObject; Count: Integer);
    procedure ComPortAfterOpen(Sender: TObject);
    procedure ComPortAfterClose(Sender: TObject);
    procedure ComPortError(Sender: TObject; Errors: TComErrors);
    function GetConnected: Boolean;
    function GetPort: String;
    procedure SetPort(const Value: String);
    function GetBaudRate: TBisBaudRate;
    function GetDataBits: TBisDataBits;
    function GetStopBits: TBisStopBits;
    procedure SetBisBaudRate(const Value: TBisBaudRate);
    procedure SetDataBits(const Value: TBisDataBits);
    procedure SetStopBits(const Value: TBisStopBits);
  protected
    procedure DoBarcode(const Barcode: String); virtual;
    procedure DoStatus(const Message: String); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnet;

    property Port: String read GetPort write SetPort;
    property BaudRate: TBisBaudRate read GetBaudRate write SetBisBaudRate;
    property StopBits: TBisStopBits read GetStopBits write SetStopBits;
    property DataBits: TBisDataBits read GetDataBits write SetDataBits;
    property BarCodeSize: Integer read FBarCodeSize write FBarCodeSize;

    property Connected: Boolean read GetConnected;

    property OnBarcode: TBisBarcodeScannerBarcodeEvent read FOnBarcode write FOnBarcode;
    property OnStatus: TBisBarcodeScannerStatusEvent read FOnStatus write FOnStatus;
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

{ TBisBarcodeScanner }

constructor TBisBarcodeScanner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FComPort:=TCustomComPort.Create(Self);
  FComPort.BaudRate:=CPort.br9600;
  FComPort.DataBits:=CPort.dbEight;
  FComPort.StopBits:=CPort.sbOneStopBit;
  FComPort.OnRxChar:=ComPortRxChar;
  FComPort.OnAfterOpen:=ComPortAfterOpen;
  FComPort.OnAfterClose:=ComPortAfterClose;
  FComPort.OnError:=ComPortError;
  BarCodeSize:=13;

  FSDisconnected:='���������� ���������.';
  FSConnected:='���������� �����������.';
  FSFramingError:='���������� ������ �����������.';
  FSBufferOverrun:='A charachter buffer overrun has occured. The next charachter is lost.';
  FSParityError:='The hardware detected a parity error.';
  FSBreakCondition:='The hardware detected a break condition.';
  FSIOError:='An I/O error occured during communication with the device.';
  FSModeNotSupported:='The requested mode is not supported.';
  FSBufferOverflow:='An input buffer overflow has occured.';
  FSBufferFull:='The output buffer is full.';
end;

destructor TBisBarcodeScanner.Destroy;
begin
  FComPort.Free;
  inherited Destroy;
end;

procedure TBisBarcodeScanner.DoBarcode(const Barcode: String);
begin
  if Assigned(FOnBarcode) then
    FOnBarcode(Self,Barcode);
end;

procedure TBisBarcodeScanner.DoStatus(const Message: String);
begin
  if Assigned(FOnStatus) then
    FOnStatus(Self,Message);
end;

procedure TBisBarcodeScanner.ComPortAfterClose(Sender: TObject);
begin
  DoStatus(FSDisconnected);
end;

procedure TBisBarcodeScanner.ComPortAfterOpen(Sender: TObject);
begin
  DoStatus(FSConnected); 
  FTempStr:='';
end;

procedure TBisBarcodeScanner.ComPortError(Sender: TObject; Errors: TComErrors);
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

procedure TBisBarcodeScanner.ComPortRxChar(Sender: TObject; Count: Integer);
var
  S: String;
begin
  FComPort.ReadStr(S,Count);
  if (Length(FTempStr)+Length(S))<BarCodeSize then begin
    FTempStr:=FTempStr+S;
  end else begin
    FTempStr:=Copy(FTempStr+S,1,BarCodeSize);
    DoBarcode(FTempStr);
    FTempStr:='';
  end;
end;

procedure TBisBarcodeScanner.Connect;
begin
  try
    FComPort.Connected:=true;
  except
    on E: Exception do
      DoStatus(E.Message);
  end;
end;

procedure TBisBarcodeScanner.Disconnet;
begin
  try
    FComPort.Connected:=false;
  except
    on E: Exception do
      DoStatus(E.Message);
  end;
end;

function TBisBarcodeScanner.GetConnected: Boolean;
begin
  Result:=FComPort.Connected;
end;

function TBisBarcodeScanner.GetPort: String;
begin
  Result:=FComPort.Port;
end;

function TBisBarcodeScanner.GetBaudRate: TBisBaudRate;
begin
  Result:=TBisBaudRate(FComPort.BaudRate);
end;

function TBisBarcodeScanner.GetDataBits: TBisDataBits;
begin
  Result:=TBisDataBits(FComPort.DataBits);
end;

function TBisBarcodeScanner.GetStopBits: TBisStopBits;
begin
  Result:=TBisStopBits(FComPort.StopBits);
end;

procedure TBisBarcodeScanner.SetBisBaudRate(const Value: TBisBaudRate);
begin
  FComPort.BaudRate:=TBaudRate(Value);
end;

procedure TBisBarcodeScanner.SetDataBits(const Value: TBisDataBits);
begin
  FComPort.DataBits:=TDataBits(Value);
end;

procedure TBisBarcodeScanner.SetPort(const Value: String);
begin
  FComPort.Port:=Value;
end;

procedure TBisBarcodeScanner.SetStopBits(const Value: TBisStopBits);
begin
  FComPort.StopBits:=TStopBits(Value);
end;

end.
