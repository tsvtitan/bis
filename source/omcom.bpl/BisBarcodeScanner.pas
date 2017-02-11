unit BisBarcodeScanner;

interface

uses Classes, SysUtils,
     CPort, CPortTypes,
     BisComPort;

type
  TBisBarcodeScannerBarcodeEvent=procedure(Sender: TObject; const Barcode: String) of object;

  TBisBarcodeScanner=class(TBisComPort)
  private
    FOnBarcode: TBisBarcodeScannerBarcodeEvent;
    FTempStr: String;
    FBarCodeSize: Integer;
    procedure ComPortRxChar(Sender: TObject; Count: Integer);
  protected
    procedure DoBarcode(const Barcode: String); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect; override;

    property OnBarcode: TBisBarcodeScannerBarcodeEvent read FOnBarcode write FOnBarcode;
    property BarCodeSize: Integer read FBarCodeSize write FBarCodeSize;
  end;

implementation

{ TBisBarcodeScanner }

constructor TBisBarcodeScanner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ComPort.OnRxChar:=ComPortRxChar;
  ComPort.SyncMethod:=smWindowSync;
  FBarCodeSize:=13;
end;

destructor TBisBarcodeScanner.Destroy;
begin
  inherited Destroy;
end;

procedure TBisBarcodeScanner.DoBarcode(const Barcode: String);
begin
  if Assigned(FOnBarcode) then
    FOnBarcode(Self,Barcode);
end;

procedure TBisBarcodeScanner.ComPortRxChar(Sender: TObject; Count: Integer);
var
  S: String;
begin
  ComPort.ReadStr(S,Count);
  if (Length(FTempStr)+Length(S))<FBarCodeSize then begin
    FTempStr:=FTempStr+S;
  end else begin
    FTempStr:=Copy(FTempStr+S,1,FBarCodeSize);
    DoBarcode(FTempStr);
    FTempStr:='';
   // ComPort.AbortAllAsync;
  end;
end;

procedure TBisBarcodeScanner.Connect;
begin
  inherited Connect;
  FTempStr:='';
end;


end.
