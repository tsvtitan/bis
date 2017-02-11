unit BisGsmModem;

interface

uses Windows, Classes, Contnrs,
     XComDrv, GsmSms,
     BisComPort, BisValues;

const
  WaitTimeOut=-1;
type
  TBisCustomComm=class(TCustomComm)
  end;

  TBisGsmModemStatusEvent=procedure (Sender: TObject; Message: String; Error: Boolean) of object;

  TBisGsmModemMessageMode=(mmUnknown,mmPdu,mmText);
  TBisGsmModemMessageModes=set of TBisGsmModemMessageMode;

  TBisGsmModemReadMessageType=(mtReceivedNew,mtReceivedRead,mtStoredUnsent,mtStoredSent,mtAll);
  TBisGsmModemReadMessageTypes=set of TBisGsmModemReadMessageType;

  TBisGsmModemMessage=class(TSMS)
  private
    FMode: TBisGsmModemMessageMode;
    FIndex: Integer;
    FStorage: String;
    FOriginalText: WideString;
    FOriginalNumber: String;
    FDestinationPort: Integer;
    FSourcePort: Integer;
    procedure SetOriginalText(const Value: WideString);
    procedure SetOriginalNumber(const Value: String);
  public
    constructor Create;

    property Mode: TBisGsmModemMessageMode read FMode write FMode;
    property Index: Integer read FIndex write FIndex;
    property Storage: String read FStorage write FStorage;
    property OriginalText: WideString read FOriginalText write SetOriginalText;
    property OriginalNumber: String read FOriginalNumber write SetOriginalNumber;
    property DestinationPort: Integer read FDestinationPort write FDestinationPort;
    property SourcePort: Integer read FSourcePort write FSourcePort;
  end;

  TBisGsmModemMessages=class(TObjectList)
  private
    function GetItems(Index: Integer): TBisGsmModemMessage;
  public
    function Add(Message: String; Mode: TBisGsmModemMessageMode; Index: Integer; Storage: String): TBisGsmModemMessage;

    property Items[Index: Integer]: TBisGsmModemMessage read GetItems;
  end;

  TBisGsmModem=class(TComponent)
  private
    FBuffer: String;
    FModem: TBisCustomComm;
    FConnected: Boolean;
    FHardReconnect: Boolean;
    FSupportModes: TBisGsmModemMessageModes;

    FManufacturer: String;
    FModel: String;
    FSerialNumber: String;
    FSubscriber: String;
    FNumbers: String;
    FServiceCenter: String;

    FSUnsupported: String;
    FSRequest: String;
    FSDelimiter: String;
    FSOK: String;
    FSError: String;

    FTimeout: Integer;
    FOnStatus: TBisGsmModemStatusEvent;
    FSConnect: String;
    FSDisconnect: String;
    FSResponse: String;

    function GetResponseBy(Request: String; NewTimeOut: Integer=-1): String;
    procedure Clear;
    function Ready: Boolean;
    function CommandOk(Request: String; NewTimeOut: Integer=-1): Boolean;
    function GetConnected: Boolean;
    function GetPort: String;
    procedure SetPort(const Value: String);
    function GetBaudRate: TBisComPortBaudRate;
    function GetBaudRateSpeed: Integer;
    function GetDataBits: TBisComPortDataBits;
    function GetParityBits: TBisComPortParityBits;
    function GetStopBits: TBisComPortStopBits;
    procedure SetBisComPortBaudRate(const Value: TBisComPortBaudRate);
    procedure SetDataBits(const Value: TBisComPortDataBits);
    procedure SetParityBits(const Value: TBisComPortParityBits);
    procedure SetStopBits(const Value: TBisComPortStopBits);

    procedure ModemData(Sender: TObject; const Received: DWORD);
    procedure ModemCommEvent(Sender: TObject; const Events: TDeviceEvents);

    function GetSupportedMessageModes: TBisGsmModemMessageModes;

    function Text8Bit(S: AnsiString): Boolean;
    procedure SetTimeout(const Value: Integer);

  protected
    function SendRequest(Request: String; WaitStrings: array of String; Wait: Boolean=true; NewTimeOut: Integer=WaitTimeOut): String;
    function SendRequestOk(Request: String; Wait: Boolean=true; NewTimeOut: Integer=WaitTimeOut): String;
    function GetResponseOk(var Response: String; const Request: String=''): Boolean;
    procedure DoStatus(Message: String; Error: Boolean=false); 
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function ParseNumbers(Response: String): String; virtual;
    function ParseServiceCenter(Response: String): String; virtual;

    procedure Connect; virtual;
    procedure Disconnect; virtual;

    procedure ReadPduMessages(Messages: TBisGsmModemMessages; Storage: String; Types: TBisGsmModemReadMessageTypes; MaxCount: Integer=-1);
    procedure ReadMessages(Messages: TBisGsmModemMessages; Storage: String;
                           Types: TBisGsmModemReadMessageTypes; Mode: TBisGsmModemMessageMode=mmUnknown; MaxCount: Integer=-1);

    function DeleteMessage(Message: TBisGsmModemMessage): Boolean;
    procedure DeleteMessages(Messages: TBisGsmModemMessages);
    procedure DeleteAllMessages(Storage: String);

    function SendPduMessage(Message: TBisGsmModemMessage): Boolean;
    function SendMessage(Message: TBisGsmModemMessage; Mode: TBisGsmModemMessageMode=mmUnknown): Boolean;
    procedure SendMessages(Messages: TBisGsmModemMessages; Mode: TBisGsmModemMessageMode=mmUnknown);

    property Manufacturer: String read FManufacturer;
    property Model: String read FModel;
    property Subscriber: String read FSubscriber;
    property Numbers: String read FNumbers;
    property SerialNumber: String read FSerialNumber;
    property ServiceCenter: String read FServiceCenter;

    property Connected: Boolean read GetConnected;

    property Port: String read GetPort write SetPort;
    property BaudRate: TBisComPortBaudRate read GetBaudRate write SetBisComPortBaudRate;
    property StopBits: TBisComPortStopBits read GetStopBits write SetStopBits;
    property DataBits: TBisComPortDataBits read GetDataBits write SetDataBits;
    property ParityBits: TBisComPortParityBits read GetParityBits write SetParityBits;
    property Timeout: Integer read FTimeout write SetTimeout;

    property OnStatus: TBisGsmModemStatusEvent read FOnStatus write FOnStatus;

  published
    property SConnect: String read FSConnect write FSConnect;
    property SDisconnect: String read FSDisconnect write FSDisconnect;
    property SUnsupported: String read FSUnsupported write FSUnsupported;
    property SRequest: String read FSRequest write FSRequest;
    property SResponse: String read FSResponse write FSResponse;
  end;

implementation

uses SysUtils, StrUtils, 
     BisUtils;

{ TBisGsmModemMessage }

constructor TBisGsmModemMessage.Create;
begin
  inherited Create;
  RequestReply:=false;
  FlashSMS:=false;
  StatusRequest:=false;
// old  dcs:=-1;
end;

procedure TBisGsmModemMessage.SetOriginalNumber(const Value: String);
begin
  FOriginalNumber := Value;
  Number:=FOriginalNumber;
end;

procedure TBisGsmModemMessage.SetOriginalText(const Value: WideString);
begin
  FOriginalText := Value;
  Text:=FOriginalText;
end;

{ TBisGsmModemMessages }

function TBisGsmModemMessages.GetItems(Index: Integer): TBisGsmModemMessage;
begin
  Result:=TBisGsmModemMessage(inherited Items[Index]);
end;

function TBisGsmModemMessages.Add(Message: String; Mode: TBisGsmModemMessageMode; Index: Integer; Storage: String): TBisGsmModemMessage;
begin
  Result:=TBisGsmModemMessage.Create;
  Result.Mode:=Mode;
  Result.Index:=Index;
  Result.Storage:=Storage;
  case Mode of
    mmPdu: Result.PDU:=Message;    
  end;
  inherited Add(Result);
end;


{ TBisGsmModem }

constructor TBisGsmModem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FModem:=TBisCustomComm.Create(Self);
  FModem.BaudRate:=XComDrv.br9600;
  FModem.DataControl.DataBits:= db8;
  FModem.DataControl.Parity:= paNone;
  FModem.DataControl.StopBits:= sb1;
  FModem.DTRSettings:= [];
  FModem.MonitorEvents:= [deChar, deFlag, deOutEmpty, deBreak, deError];
//  FModem.MonitorEvents:= [];
  FModem.FlowControl:= fcNone;
  FModem.Options:= [coDiscardNull];
  FModem.Synchronize:= true;
  FModem.OnData:=ModemData;
  FModem.OnCommEvent:=ModemCommEvent;

  FHardReconnect:=true;

  FSConnect:='Соединение с портом %s установлено.';
  FSDisconnect:='Соединение с портом %s разорвано.';
  FSUnsupported:='Команда %s не поддерживается.';
  FSRequest:='Запрос команды %s';
  FSResponse:='Ответ команды %s';
  FSDelimiter:=';';
  FSOK:='OK';
  FSError:='ERROR';

  FSupportModes:=[];

  Timeout:=1000;

end;

destructor TBisGsmModem.Destroy;
begin
  FModem.Free;
  inherited Destroy;
end;

procedure TBisGsmModem.DoStatus(Message: String; Error: Boolean=false);
begin
  if Assigned(FOnStatus) then
    FOnStatus(Self,Message,Error);
end;

procedure TBisGsmModem.SetDataBits(const Value: TBisComPortDataBits);
begin
  case Value of
    dbFive: FModem.DataControl.DataBits:=db5;
    dbSix: FModem.DataControl.DataBits:=db6;
    dbSeven: FModem.DataControl.DataBits:=db7;
    dbEight: FModem.DataControl.DataBits:=db8;
  end;
end;

procedure TBisGsmModem.SetParityBits(const Value: TBisComPortParityBits);
begin
 case Value of
   prNone: FModem.DataControl.Parity:=paNone;
   prOdd: FModem.DataControl.Parity:=paOdd;
   prEven: FModem.DataControl.Parity:=paEven;
   prMark: FModem.DataControl.Parity:=paMark;
   prSpace: FModem.DataControl.Parity:=paSpace;
 end;
end;

procedure TBisGsmModem.SetStopBits(const Value: TBisComPortStopBits);
begin
  case Value of
    sbOneStopBit: FModem.DataControl.StopBits:=sb1;
    sbOne5StopBits: FModem.DataControl.StopBits:=sb1p5;
    sbTwoStopBits: FModem.DataControl.StopBits:=sb2;
  end;
end;

procedure TBisGsmModem.SetTimeout(const Value: Integer);
begin
  FTimeout := Value;
  FModem.Buffers.InputTimeout:=Value;
  FModem.Buffers.OutputTimeout:=Value;
  FModem.Timeouts.ReadInterval:=Value;
  FModem.Timeouts.ReadConstant:=Value;
  FModem.Timeouts.WriteConstant:=Value;
end;

procedure TBisGsmModem.SetBisComPortBaudRate(const Value: TBisComPortBaudRate);
begin
  case Value of
    brCustom: FModem.BaudRate:=XComDrv.brCustom;
    br110: FModem.BaudRate:=XComDrv.br110;
    br300: FModem.BaudRate:=XComDrv.br300;
    br600: FModem.BaudRate:=XComDrv.br600;
    br1200: FModem.BaudRate:=XComDrv.br1200;
    br2400: FModem.BaudRate:=XComDrv.br2400;
    br4800: FModem.BaudRate:=XComDrv.br4800;
    br9600: FModem.BaudRate:=XComDrv.br9600;
    br14400: FModem.BaudRate:=XComDrv.br14400;
    br19200: FModem.BaudRate:=XComDrv.br19200;
    br38400: FModem.BaudRate:=XComDrv.br38400;
    br56000: FModem.BaudRate:=XComDrv.br56000;
    br57600: FModem.BaudRate:=XComDrv.br57600;
    br115200: FModem.BaudRate:=XComDrv.br115200;
    br128000: FModem.BaudRate:=XComDrv.br128000;
    br256000: FModem.BaudRate:=XComDrv.br256000;
  end;
end;

procedure TBisGsmModem.SetPort(const Value: String);
begin
  FModem.DeviceName:=Value;
end;

function TBisGsmModem.GetParityBits: TBisComPortParityBits;
begin
  Result:=prNone;
  case FModem.DataControl.Parity of
    paNone: Result:=prNone;
    paOdd: Result:=prOdd;
    paEven: Result:=prEven;
    paMark: Result:=prMark;
    paSpace: Result:=prSpace;
  end;
end;

function TBisGsmModem.GetStopBits: TBisComPortStopBits;
begin
  Result:=sbOneStopBit;
  case FModem.DataControl.StopBits of
    sb1: Result:=sbOneStopBit;
    sb1p5: Result:=sbOne5StopBits;
    sb2: Result:=sbTwoStopBits;
  end;
end;

function TBisGsmModem.GetDataBits: TBisComPortDataBits;
begin
  Result:=dbFive;
  case FModem.DataControl.DataBits of
    db5: Result:=dbFive;
    db6: Result:=dbSix;
    db7: Result:=dbSeven;
    db8: Result:=dbEight;
  end;
end;

function TBisGsmModem.GetBaudRate: TBisComPortBaudRate;
begin
  Result:=brCustom;
  case FModem.BaudRate of
    XComDrv.brCustom: Result:=brCustom;
    XComDrv.br110: Result:=br110;
    XComDrv.br300: Result:=br300;
    XComDrv.br600: Result:=br600;
    XComDrv.br1200: Result:=br1200;
    XComDrv.br2400: Result:=br2400;
    XComDrv.br4800: Result:=br4800;
    XComDrv.br9600: Result:=br9600;
    XComDrv.br14400: Result:=br14400;
    XComDrv.br19200: Result:=br19200;
    XComDrv.br38400: Result:=br38400;
    XComDrv.br56000: Result:=br56000;
    XComDrv.br57600: Result:=br57600;
    XComDrv.br115200: Result:=br115200;
    XComDrv.br128000: Result:=br128000;
    XComDrv.br256000: Result:=br256000;
  end;
end;

function TBisGsmModem.GetBaudRateSpeed: Integer;
begin
  Result:=0;
  case FModem.BaudRate of
    XComDrv.brCustom: Result:=0;
    XComDrv.br110: Result:=110;
    XComDrv.br300: Result:=300;
    XComDrv.br600: Result:=600;
    XComDrv.br1200: Result:=1200;
    XComDrv.br2400: Result:=2400;
    XComDrv.br4800: Result:=4800;
    XComDrv.br9600: Result:=9600;
    XComDrv.br14400: Result:=14400;
    XComDrv.br19200: Result:=19200;
    XComDrv.br38400: Result:=38400;
    XComDrv.br56000: Result:=56000;
    XComDrv.br57600: Result:=57600;
    XComDrv.br115200: Result:=115200;
    XComDrv.br128000: Result:=128000;
    XComDrv.br256000: Result:=256000;
  end;
end;

function TBisGsmModem.GetPort: String;
begin
  Result:=FModem.DeviceName;
end;

function TBisGsmModem.GetConnected: Boolean;
begin
  Result:=FModem.Opened and FConnected;
end;

procedure TBisGsmModem.ModemCommEvent(Sender: TObject; const Events: TDeviceEvents);
begin
  if deError in Events then begin
    DoStatus('Error',true);
  end;
end;

procedure TBisGsmModem.ModemData(Sender: TObject; const Received: DWORD);
var
  S: String;
begin
  SetLength(S,Received);
  FModem.ReadData(Pointer(S)^,Received);
  FBuffer:=FBuffer+S;
end;

function TBisGsmModem.SendRequest(Request: String; WaitStrings: array of String; Wait: Boolean=true;
                                  NewTimeOut: Integer=WaitTimeOut): String;

  function CalculateTimeOut(L: DWord; ATimeOut: Dword): DWord;
  var
    BytesPerSec: Extended;
  begin
    BytesPerSec:=GetBaudRateSpeed/8;
    Result:=Round(L/BytesPerSec*1000);
    if Result<ATimeOut then
      Result:=ATimeOut;
  end;

var
  S: String;
  ATimeOut: Dword;
  L: DWord;
Begin
  Result:='';
  If Request <> '' then begin
    DoStatus(FormatEx(FSRequest,[Request]));

    ATimeOut:=FTimeout;
    if NewTimeOut>-1 then
      ATimeOut:=NewTimeOut;

    L:=Length(Request);  
    ATimeOut:=CalculateTimeOut(L,ATimeOut);

    if FModem.SendDataEx(Request[1],L,ATimeOut)=L then begin
//    if FModem.SendString(Request) then begin
      if Wait then begin
        FModem.WaitForString(WaitStrings,ATimeOut,S);
        Result:=S;
        DoStatus(FormatEx(FSResponse,[Result]));
      end;
    end;
  end;
end;

function TBisGsmModem.SendRequestOk(Request: String; Wait: Boolean=true; NewTimeOut: Integer=WaitTimeOut): String;
begin
  Result:=SendRequest(Request,[FSOK+#13#10,FSError+#13#10],Wait,NewTimeOut);
end;

function TBisGsmModem.GetResponseOk(var Response: String; const Request: String=''): Boolean;
var
  S: String;
  i: Integer;
  Strings: TStringList;
begin
  Result:=false;
  S:=Trim(Response);
  Strings:=TStringList.Create;
  try
    S:=ReplaceText(S,#13#10,FSDelimiter);
    if UpperCase(S)=FSOK then begin
      Result:=true;
    end else begin
      GetStringsByString(S,FSDelimiter,Strings);
      if Strings.Count>0 then begin
        if Strings[0]=Request then
          Strings.Delete(0);
        if Strings.Count>0 then begin
          Response:='';
          for i:=0 to Strings.Count-2 do begin
            if i=0 then
              Response:=Strings[i]
            else Response:=Response+FSDelimiter+Strings[i];
          end;
          if UpperCase(Strings[Strings.Count-1])=FSOK then begin
            Result:=true;
          end;
        end;
      end
    end;
  finally
    Strings.Free;
  end;
end;

function TBisGsmModem.GetResponseBy(Request: String; NewTimeOut: Integer=-1): String;
var
  S: String;
begin
  try
    Result:='';
    S:=SendRequestOk(Request,true,NewTimeOut);
    if GetResponseOk(S,Request) then begin
      Result:=S;
    end else
      DoStatus(FormatEx(FSUnsupported,[Request]),true);
  except
    on E: Exception do
      DoStatus(E.Message,true);
  end;
end;

function TBisGsmModem.ParseNumbers(Response: String): String;
var
  Commands: TStringList;
  Command: String;
  Items: TStringList;
  i: Integer;
  Flag: Boolean;
begin
  Result:='';
  Commands:=TStringList.Create;
  Items:=TStringList.Create;
  try
    Flag:=false;
    GetStringsByString(Response,';',Commands);
    for i:=0 to Commands.Count-1 do begin
      Items.Clear;
      GetStringsByString(Commands[i],',',Items);
      Command:='';
      if Items.Count>0 then
        Command:=Trim(Items[0]);
      if (Items.Count>1) and AnsiSameText(Command,'+CNUM:') then begin
        if not Flag then
          Result:=Items[1]
        else Result:=Result+','+Items[1];
        Flag:=true;
      end;
    end;
    Result:=ReplaceText(Result,'"','');
  finally
    Items.Free;
    Commands.Free;
  end;
end;

function TBisGsmModem.ParseServiceCenter(Response: String): String;
var
  Commands: TStringList;
  S,S2: String;
const
  CSCA='+CSCA:';
begin
  Result:='';
  Commands:=TStringList.Create;
  try
    GetStringsByString(Response,',',Commands);
    if Commands.Count>0 then begin
      S:=Trim(Commands[0]);
      S2:=Copy(S,1,Length(CSCA));
      if AnsiSameText(CSCA,S2) then begin
        Result:=Trim(Copy(S,Length(S2)+1,Length(S)));
      end;
    end;
    Result:=ReplaceText(Result,'"','');
  finally
    Commands.Free;
  end;
end;

procedure TBisGsmModem.Clear;
begin
  SendRequest(#27,[],false); // clear
  SendRequestOk('AT+CLIP=1;+CRC=1'#13,true) // for Siemens
end;

function TBisGsmModem.CommandOk(Request: String; NewTimeOut: Integer): Boolean;
var
  S: String;
begin
  S:=SendRequestOk(Request,True,NewTimeOut);
  Result:=GetResponseOk(S,Request);
end;

function TBisGsmModem.Ready: Boolean;
begin
  Result:=CommandOk('AT'#13); // modem Ok
end;

procedure TBisGsmModem.Connect;
begin

  try
    if FModem.Opened then
      FModem.CloseDevice;

    if not FModem.Opened then
      FModem.OpenDevice;

    if FModem.Opened then begin
      DoStatus(FormatEx(FSConnect,[FModem.DeviceName]));
      Clear;
      if Ready then begin
        FSupportModes:=GetSupportedMessageModes;
        if FHardReconnect then begin
          FManufacturer:=GetResponseBy('AT+CGMI'#13); // manufacturer
          FModel:=GetResponseBy('AT+GMM'#13); // model
          FSubscriber:=GetResponseBy('AT+CIMI'#13); // subscriber (imsi)
          FNumbers:=ParseNumbers(GetResponseBy('AT+CNUM'#13)); // phone numbers
          FSerialNumber:=GetResponseBy('AT+CGSN'#13); // serialNumber (imei)
          FServiceCenter:=ParseServiceCenter(GetResponseBy('AT+CSCA?'#13)); // service center
          FHardReconnect:=false;
        end;
        FConnected:=true;
      end;
    end;

  except
    On E: Exception do
      DoStatus(E.Message,true);
  end;

end;

procedure TBisGsmModem.Disconnect;
begin
  try
    if FModem.Opened then begin
      FConnected:=false;
      FHardReconnect:=true;
      FManufacturer:='';
      FModel:='';
      FSubscriber:='';
      FNumbers:='';
      FSerialNumber:='';
      FServiceCenter:='';
      FModem.CloseDevice;
      if not FModem.Opened then
        DoStatus(FormatEx(FSDisconnect,[FModem.DeviceName]));
    end;
  except
    On E: Exception do
      DoStatus(E.Message,true);
  end;
end;

function TBisGsmModem.GetSupportedMessageModes: TBisGsmModemMessageModes;
begin
  Result:=[];
  try
    if CommandOk('AT+CMGF=0'#13) then // pdu mode
      Result:=Result+[mmPdu];
    if CommandOk('AT+CMGF=1'#13) then // text mode
      Result:=Result+[mmText];
  except
    On E: Exception do begin
      DoStatus(E.Message,true);
      FConnected:=false;
      FHardReconnect:=true;
    end;
  end;
end;

procedure TBisGsmModem.ReadPduMessages(Messages: TBisGsmModemMessages; Storage: String; Types: TBisGsmModemReadMessageTypes; MaxCount: Integer=-1);
var
  S: String;
  k: TBisGsmModemReadMessageType;
  i: Integer;
  Commands: TStringList;
  Command: String;
  Items: TStringList;
  Index: Integer;
  IndexS: String;
//  NCount: Integer;
const
  CMGL='+CMGL:';
begin
  try
    if Ready then begin
      if Assigned(Messages) and (Trim(Storage)<>'') then begin
        if CommandOk('AT+CMGF=0'#13) then begin // pdu mode
          if CommandOk('AT+CPMS="'+Storage+'"'+#13) then begin // storage

            for k:=mtReceivedNew to mtAll do begin
              if k in Types then begin
                S:=SendRequestOk('AT+CMGL='+IntToStr(Integer(k))+#13); // receive all messages
                if GetResponseOk(S,'AT+CMGL='+IntToStr(Integer(k))+#13) and (Trim(S)<>'') then begin
                  Commands:=TStringList.Create;
                  Items:=TStringList.Create;
                  try
                    Index:=-1;
                    GetStringsByString(S,';',Commands);
                    for i:=0 to Commands.Count-1 do begin
                      Command:=Trim(Commands[i]);
                      if not Odd(i) then begin
                        Items.Clear;
                        GetStringsByString(Command,',',Items);
                        if Items.Count>0 then begin
                          Command:=Trim(Items[0]);
                          S:=Copy(Command,1,Length(CMGL));
                          if AnsiSameText(CMGL,S) then begin
                            IndexS:=Trim(Copy(Command,Length(S)+1,Length(Command)));
                            Index:=StrToIntDef(IndexS,-1);
                          end;
                        end;
                      end else begin
                        if Index<>-1 then
                          Messages.Add(Command,mmPdu,Index,Storage);
                        Index:=-1;
                      end;
                    end;
                  finally
                    Items.Free;
                    Commands.Free;
                  end;
                end;
                
              end;
            end;

          end;
        end;
      end;
    end else
      FConnected:=false;
  except
    On E: Exception do begin
      DoStatus(E.Message,true);
      FConnected:=false;
      FHardReconnect:=true;
    end;
  end;
end;

procedure TBisGsmModem.ReadMessages(Messages: TBisGsmModemMessages; Storage: String;
                                    Types: TBisGsmModemReadMessageTypes;
                                    Mode: TBisGsmModemMessageMode=mmUnknown; MaxCount: Integer=-1);
var
  AMode: TBisGsmModemMessageMode;
begin
  AMode:=Mode;
  if Mode=mmUnknown then begin
    if mmPdu in FSupportModes then
      AMode:=mmPdu
    else if mmText in FSupportModes then
      AMode:=mmText;
  end;
  if AMode<>mmUnknown then begin
    case AMode of
      mmPdu: ReadPduMessages(Messages,Storage,Types,MaxCount);
      mmText: ;
    end;
  end;
end;

function TBisGsmModem.DeleteMessage(Message: TBisGsmModemMessage): Boolean;
begin
  Result:=false;
  try
    if Ready then begin
      if Assigned(Message) then begin
        if CommandOk('AT+CPMS="'+Message.Storage+'"'+#13) then begin // storage
          Result:=CommandOk('AT+CMGD='+IntToStr(Message.Index)+#13); // delete message
        end;
      end;
    end else
      FConnected:=false;
  except
    On E: Exception do begin
      DoStatus(E.Message,true);
      FConnected:=false;
      FHardReconnect:=true;
    end;
  end;
end;

procedure TBisGsmModem.DeleteMessages(Messages: TBisGsmModemMessages);
var
  i: Integer;
begin
  if Assigned(Messages) then begin
    for i:=0 to Messages.Count-1 do begin
      DeleteMessage(Messages.Items[i]);
    end;
  end;
end;

procedure TBisGsmModem.DeleteAllMessages(Storage: String);
{var
  S: String;
  Index: Integer;}
begin
(*  try
//    if Ready then begin
      if Trim(Storage)<>'' then begin
        S:=SendRequestOk('AT+CPMS="'+Storage+'"'+#13); // storage
        if GetResponseOk(S,'AT+CPMS="'+Storage+'"'+#13) then begin
          S:=GetResponseBy('AT+CPMS?'#13); // count
          S:=S;

      {    S:=SendRequestOk('AT+CMGD='+IntToStr(Index)+#13); // delete message
          GetResponseOk(S,'AT+CMGD='+IntToStr(Index)+#13);  }
        end;
      end;
  {  end else
      FConnected:=false;}
  except
    On E: Exception do begin
      DoStatus(E.Message,true);
      FConnected:=false;
    end;
  end;*)
end;

function TBisGsmModem.Text8Bit(S: AnsiString): Boolean;
var
  i: Integer;
  tempByte: Byte;
begin
  Result:=true;
  for i := 1 to Length(S) do  begin
    tempByte := Byte(S[i]);
    if (tempByte and $80) <> 0 then begin
      Result:=false;
      exit;
    end;
  end;
end;

function TBisGsmModem.SendPduMessage(Message: TBisGsmModemMessage): Boolean;
var
  NewMessage: TBisGsmModemMessage;
  PortUDHI: String;
  LUDHI, L: Integer;
  Flag8bit: Boolean;
  S: String;
  Mess: String;
  Temp: String;
  Pdu: string;
  P: Integer;
  Total: String;
  Ref: String;
  Udhi: String;
  i: Integer;
  Flag: Boolean;
  MaxLength: Integer;
const
  ASmsTimeOut=10000;
begin
  Result:=false;
  try
    if Ready then begin
      if Assigned(Message) then begin
        if CommandOk('AT+CMGF=0'#13) then begin // pdu mode

          PortUDHI:='';
          LUDHI:=0;
          if (Message.DestinationPort>0) or (Message.SourcePort>0) then begin
        //    PortUDHI:='0504'+IntToHex(Message.DestinationPort,4)+IntToHex(Message.SourcePort,4);
            PortUDHI:='0504'+IntToHex(Message.DestinationPort,4)+IntToHex(1,4);
            LUDHI:=(Length(PortUDHI) div 2);
          end;

          NewMessage:=TBisGsmModemMessage.Create;
          try
            NewMessage.StatusRequest:=Message.StatusRequest;
            NewMessage.FlashSMS:=Message.FlashSMS;
            NewMessage.StatusRequest:=Message.StatusRequest;
            NewMessage.Number:=Message.OriginalNumber;

            Mess:=Message.OriginalText;
            Flag8bit:=Text8Bit(Mess);

            MaxLength:=160;
            if not Flag8bit then
              MaxLength:=70;

            if LUDHI>0 then
              MaxLength:=MaxLength-LUDHI-1;

            if Length(Mess)<=MaxLength then begin

              NewMessage.Text:=Mess;
              if LUDHI>0 then
                NewMessage.UDHI:=IntToHex(LUDHI,2)+PortUDHI;

              Pdu:=NewMessage.PDU;
              S:=SendRequest('AT+CMGS='+IntToStr(NewMessage.TPLength)+#13,['>'#32]); // set length
              S:=SendRequestOk(Pdu+#26,True,ASmsTimeOut); // set message
              Result:=GetResponseOk(S);

            end else begin

              L:=(Length('0003000000') div 2);
              P:=MaxLength-LUDHI-L;

              Total:=IntToHex((Length(Mess) div P)+1,2);
              Ref:=IntToHex(1+Random(252),2);
              Udhi:='0003'+Ref+Total;
              Flag:=true;

              for i:=1 to StrToInt('$'+Total) do begin
                Temp:=Copy(Mess,1,P);
                Delete(Mess,1,P);
                NewMessage.Text:=Temp;
                NewMessage.UDHI:=IntToHex(LUDHI+L,2)+PortUDHI+Udhi+IntToHex(i,2);
                Pdu:=NewMessage.PDU;
                S:=SendRequest('AT+CMGS='+IntToStr(NewMessage.TPLength)+#13,['>'#32]); // set length
                S:=SendRequestOk(Pdu+#26,True,ASmsTimeOut); // set message
                Result:=Flag and GetResponseOk(S);
              end;

            end;
          finally
            NewMessage.Free;
          end;

          if Result then begin

          end;

        end;
      end;
    end else
      FConnected:=false;
  except
    On E: Exception do begin
      DoStatus(E.Message,true);
      FConnected:=false;
      FHardReconnect:=true;
    end;
  end;
end;

function TBisGsmModem.SendMessage(Message: TBisGsmModemMessage; Mode: TBisGsmModemMessageMode=mmUnknown): Boolean;
var
  AMode: TBisGsmModemMessageMode;
begin
  Result:=false;
  AMode:=Mode;
  if Mode=mmUnknown then begin
    if mmPdu in FSupportModes then
      AMode:=mmPdu
    else if mmText in FSupportModes then
      AMode:=mmText;
  end;
  if AMode<>mmUnknown then begin
    case AMode of
      mmPdu: Result:=SendPduMessage(Message);
      mmText: ;
    end;
  end;
end;

procedure TBisGsmModem.SendMessages(Messages: TBisGsmModemMessages; Mode: TBisGsmModemMessageMode=mmUnknown);
var
  i: Integer;
  AMode: TBisGsmModemMessageMode;
begin
  AMode:=Mode;
  if Mode=mmUnknown then begin
    if mmPdu in FSupportModes then
      AMode:=mmPdu
    else if mmText in FSupportModes then
      AMode:=mmText;
  end;
  if (AMode<>mmUnknown) and Assigned(Messages) then begin
    for i:=0 to Messages.Count-1 do begin
      SendMessage(Messages.Items[i],AMode);
    end;
  end;
end;

end.
