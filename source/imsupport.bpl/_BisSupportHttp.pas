unit BisSupportHttp;

interface


uses Windows, Classes, Controls, DB,
     WinInet, ZLib,
     Ras, RasUtils, RasHelperClasses,
     IdHttp, IdComponent, IdGlobal,
     BisCrypter, BisSupportTypes;

type
  TBisSupportHttp=class;

  TBisSupportHttpFormat=(hfRaw,hfXml);

  TBisSupportHttpType=(htDirect,htRemote,htModem);

  TBisSupportHttpInternetType=(hitUnknown,hitModem,hitLan,hitProxy);

  TBisDialer=class(TRasDialer)
  end;

  TBisSupportHttpProgressEvent=procedure(Sender: TObject; Min,Max,Position: Integer; var Breaked: Boolean) of object;

  TBisSupportHttp=class(TIdHttp)
  private
    FConnectionType: TBisSupportHttpType;
    FRemoteAuto: Boolean;
    FRemoteName: String;
    FInternet: DWord;
    FDialer: TBisDialer;
    FConnected: Boolean;
    FWorkCountMax: Integer;

    FUseCrypter: Boolean;
    FCrypterAlgorithm: TBisCipherAlgorithm;
    FCrypterMode: TBisCipherMode;
    FCrypterKey: String;
    FPath: String;
    FProtocol: String;
    FUseCompressor: Boolean;
    FParentHandle: THandle;
    FOnProgress: TBisSupportHttpProgressEvent;
    FStreamFormat: TBisSupportHttpFormat;
    FCompressorLevel: TCompressionLevel;

    function GetFullUrl(const Document: String=''): String;
    function GetKey(Key: String): String;
    function ExecuteMethod(Method: TBisSupportMethod; List: TBisSupportList=nil): Boolean;
    procedure Compress(Stream: TStream);
    procedure Decompress(Stream: TStream);

    function GetInternetType: TBisSupportHttpInternetType;
    procedure DialerNotify(Sender: TObject; State: TRasConnState; ErrorCode: DWORD);
    procedure ConnectionWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Integer);
    procedure ConnectionWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
    procedure ConnectionWorkEnd(ASender: TObject; AWorkMode: TWorkMode);

    procedure ConnectDirect;
    procedure ConnectRemote;
    procedure ConnectModem;

    procedure DisconnectDirect;
    procedure DisconnectRemote;
    procedure DisconnectModem;
  protected
    procedure DoOnConnected; override;
    procedure DoProgress(Min,Max,Position: Integer; var Breaked: Boolean); virtual;
  public
    constructor Create(AOwner: TComponent); 
    destructor Destroy; override;
    procedure Connect; reintroduce;
    procedure Disconnect; reintroduce;
    function GetList(List: TBisSupportList): Boolean;
    function GetFiles(List: TBisSupportList): Boolean;

    property ConnectionType: TBisSupportHttpType read FConnectionType write FConnectionType;
    property RemoteAuto: Boolean read FRemoteAuto write FRemoteAuto;
    property RemoteName: String read FRemoteName write FRemoteName;

    property UseCrypter: Boolean read FUseCrypter write FUseCrypter;
    property CrypterAlgorithm: TBisCipherAlgorithm read FCrypterAlgorithm write FCrypterAlgorithm;
    property CrypterMode: TBisCipherMode read FCrypterMode write FCrypterMode;
    property CrypterKey: String read FCrypterKey write FCrypterKey;
    property Path: String read FPath write FPath;
    property Protocol: String read FProtocol write FProtocol;
    property UseCompressor: Boolean read FUseCompressor write FUseCompressor;
    property CompressorLevel: TCompressionLevel read FCompressorLevel write FCompressorLevel;
    property StreamFormat: TBisSupportHttpFormat read FStreamFormat write FStreamFormat;

    property ParentHandle: THandle read FParentHandle write FParentHandle;

    property Dialer: TBisDialer read FDialer;

    property Host;
    property Port;

    property OnProgress: TBisSupportHttpProgressEvent read FOnProgress write FOnProgress;
  end;

implementation

uses SysUtils, Forms, Variants, ActiveX, 
     IdAssignedNumbers,
     ALXmlDoc,
     BisBase64, BisUtils,
     BisSupportConsts;


{ TBisSupportHttp }

constructor TBisSupportHttp.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);

  FDialer:=TBisDialer.Create;
  FDialer.Mode:=dmSync;
  FDialer.OnNotify:=DialerNotify;

  OnWorkBegin:=ConnectionWorkBegin;
  OnWork:=ConnectionWork;
  OnWorkEnd:=ConnectionWorkEnd;

  FCompressorLevel:=clFastest;
end;

destructor TBisSupportHttp.Destroy;
begin
  FDialer.OnNotify:=nil;
  FDialer.Free;
  inherited Destroy;
end;

procedure TBisSupportHttp.DoOnConnected;
begin
  inherited DoOnConnected;
end;

function TBisSupportHttp.GetInternetType: TBisSupportHttpInternetType;
var
  Connected: Bool;
  dwFlags: Dword;
begin
  Result:=hitUnknown;
  Connected:=InternetGetConnectedState(@dwFlags,0) and ((dwFlags and INTERNET_CONNECTION_MODEM_BUSY)=0);
  if Connected then begin
    if (dwFlags and INTERNET_CONNECTION_MODEM)=1 then Result:=hitModem;
    if (dwFlags and INTERNET_CONNECTION_LAN)=1 then Result:=hitLan;
    if (dwFlags and INTERNET_CONNECTION_PROXY)=1 then Result:=hitProxy;
  end;
end;

procedure TBisSupportHttp.DialerNotify(Sender: TObject; State: TRasConnState;
  ErrorCode: DWORD);
begin
  FConnected:=FDialer.Active;
end;

procedure TBisSupportHttp.DoProgress(Min,Max,Position: Integer; var Breaked: Boolean);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self,Min,Max,Position,Breaked);
end;

procedure TBisSupportHttp.ConnectionWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Integer);
var
  Breaked: Boolean;
begin
  FWorkCountMax:=AWorkCountMax;
  DoProgress(0,AWorkCountMax,0,Breaked);
  if Breaked then
    inherited Disconnect;
end;

procedure TBisSupportHttp.ConnectionWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
var
  Breaked: Boolean;
begin
  DoProgress(0,FWorkCountMax,AWorkCount,Breaked);
  if Breaked then
    inherited Disconnect;
end;

procedure TBisSupportHttp.ConnectionWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
var
  Breaked: Boolean;
begin
  DoProgress(0,0,0,Breaked);
  if Breaked then
    inherited Disconnect;
end;

procedure TBisSupportHttp.ConnectDirect;
var
  AConnected: Boolean;
begin
  AConnected:=false;
  try
    ExecuteMethod(umConnect,nil);
    AConnected:=true;
  finally
    FConnected:=AConnected;
  end;
end;

procedure TBisSupportHttp.ConnectRemote;
var
  InternetType: TBisSupportHttpInternetType;
  Ret: Dword;
  dwConnection: DWord;
  AConnected: Boolean;
  NewRemoteName: string;
  S: String;
begin
  AConnected:=false;
  try
    if FRemoteAuto then
      NewRemoteName:=''
    else
      NewRemoteName:=FRemoteName;
    InternetType:=GetInternetType;
    if InternetType<>hitLan then begin
      if FRemoteAuto then begin
        AConnected:=InternetAutoDial(INTERNET_AUTODIAL_FORCE_UNATTENDED,FParentHandle);
      end else begin
        Ret:=InternetDial(FParentHandle,PChar(FRemoteName),INTERNET_AUTODIAL_FORCE_UNATTENDED,@dwConnection,0);
        if Ret=ERROR_SUCCESS then begin
          FInternet:=dwConnection;
          AConnected:=true;
        end;
      end;
    end else AConnected:=true;

    if AConnected then begin
      S:=GetFullUrl;
      InternetGoOnline(PChar(S),FParentHandle,0);
      ExecuteMethod(umConnect);
    end;
  finally
    FConnected:=AConnected;
  end;
end;

procedure TBisSupportHttp.ConnectModem;
var
  InternetType: TBisSupportHttpInternetType;
  Ret: Dword;
  AConnected: Boolean;
  S: String;
begin
  AConnected:=false;
  try
    Ret:=ERROR_SUCCESS;
    InternetType:=GetInternetType;
    if InternetType<>hitLan then begin
      try
        FDialer.Dial;
      except
        On E: EWin32Error do begin
          Ret:=E.ErrorCode;
        end;
      end;
      if Ret=ERROR_SUCCESS then begin
        FInternet:=FDialer.ConnHandle;
        AConnected:=true;
      end;
    end else AConnected:=true;

    if AConnected then begin
      S:=GetFullUrl;
      InternetGoOnline(PChar(S),FParentHandle,0);
      ExecuteMethod(umConnect);
    end;
  finally
    FConnected:=AConnected;
  end;
end;

procedure TBisSupportHttp.Connect;
begin
  if not FConnected then
    case FConnectionType of
      htDirect: ConnectDirect;
      htRemote: ConnectRemote;
      htModem: ConnectModem;
    end;
end;

procedure TBisSupportHttp.DisconnectDirect;
begin
  ExecuteMethod(umDisconnect);
  FConnected:=false;
end;

procedure TBisSupportHttp.DisconnectRemote;
var
  InternetType: TBisSupportHttpInternetType;
begin
  ExecuteMethod(umDisconnect);
  InternetType:=GetInternetType;
  if InternetType<>hitLan then begin
    if FRemoteAuto then
      InternetAutodialHangup(0)
    else begin
      InternetHangUp(FInternet,0);
    end;
  end;
  FConnected:=false;
end;

procedure TBisSupportHttp.DisconnectModem;
var
  InternetType: TBisSupportHttpInternetType;
begin
  ExecuteMethod(umDisconnect);
  InternetType:=GetInternetType;
  if InternetType<>hitLan then begin
    try
      if FDialer.Active then
        FDialer.HangUp;
    except
    end;
  end;
  FConnected:=false;
end;

procedure TBisSupportHttp.Disconnect;
begin
  if FConnected then
    case FConnectionType of
      htDirect: DisconnectDirect;
      htRemote: DisconnectRemote;
      htModem: DisconnectModem;
    end;
end;

function TBisSupportHttp.GetFullUrl(const Document: String=''): String;
begin
  Result:='';
  try
    URL.Host:=Host;
    URL.Port:=IntToStr(Port);
    URL.Protocol:=FProtocol;
    URL.Path:=FPath;
    URL.Document:=Document;
    Result:=URL.GetFullURI([]);
  except
  end;
end;

function TBisSupportHttp.GetKey(Key: String): String;
begin
  Result:=Key;
end;

procedure TBisSupportHttp.Compress(Stream: TStream);
var
  Zip: TCompressionStream;
  TempStream: TMemoryStream;
begin
  if Assigned(Stream) then begin
    TempStream:=TMemoryStream.Create;
    try
      Zip:=TCompressionStream.Create(FCompressorLevel,TempStream);
      try
        Stream.Position:=0;
        Zip.CopyFrom(Stream,Stream.Size);
      finally
        Zip.Free;
      end;
      Stream.Size:=0;
      TempStream.Position:=0;
      Stream.CopyFrom(TempStream,TempStream.Size);
      Stream.Position:=0;
    finally
      TempStream.Free;
    end;
  end;
end;

procedure TBisSupportHttp.Decompress(Stream: TStream);
var
  Zip: TDecompressionStream;
  Count: Integer;
  Buffer: array[0..1023] of Char;
  TempStream: TMemoryStream;
begin
  if Assigned(Stream) then begin
    TempStream:=TMemoryStream.Create;
    try
      Stream.Position:=0; 
      Zip:=TDecompressionStream.Create(Stream);
      try
        repeat
          Count:=Zip.Read(Buffer,SizeOf(Buffer));
          TempStream.Write(Buffer,Count);
        until Count=0;
      finally
        Zip.Free;
      end;
      TempStream.Position:=0;
      Stream.Size:=0;
      Stream.CopyFrom(TempStream,TempStream.Size);
      Stream.Position:=0;
    finally
      TempStream.Free;
    end;
  end;
end;

function TBisSupportHttp.ExecuteMethod(Method: TBisSupportMethod; List: TBisSupportList): Boolean;

  procedure WriteRawStream(Rnd: String; Stream: TMemoryStream);
  var
    ListStream: TMemoryStream;
    Writer: TWriter;
  begin
    ListStream:=TMemoryStream.Create;
    try
      if Assigned(List) then begin
        List.SaveToStream(ListStream,sfRaw);
        ListStream.Position:=0;
      end;

      Writer:=TWriter.Create(Stream,WriterBufferSize);
      try
        Writer.WriteString(Rnd);
        Writer.WriteInteger(Integer(Method));
        Writer.WriteInteger(ListStream.Size);
      finally
        Writer.Free;
      end;

      if ListStream.Size>0 then
        Stream.CopyFrom(ListStream,ListStream.Size);

    finally
      ListStream.Free;
    end;
  end;

  function ReadRawStream(Stream: TMemoryStream; var Error: String): Boolean;
  var
    ListStream: TMemoryStream;
    Reader: TReader;
    ASize: Int64;
  begin
    ListStream:=TMemoryStream.Create;
    try
      Result:=false;
      
      Reader:=TReader.Create(Stream,ReaderBufferSize);
      try
        Reader.ReadString; // read Rnd
        Result:=Reader.ReadBoolean;
        Error:=Reader.ReadString;
        ASize:=Reader.ReadInt64;
      finally
        Reader.Free;
      end;

      if ASize>0 then begin
        ListStream.Clear;
        ListStream.CopyFrom(Stream,ASize);
        ListStream.Position:=0;
      end;

      if Assigned(List) and (ListStream.Size>0) then
        List.LoadFromStream(ListStream,sfRaw);
        
    finally
      ListStream.Free;
    end;
  end;

  procedure WriteXmlStream(Rnd: String; Stream: TMemoryStream);
  var
    Xml: TALXMLDocument;
    Data: TALXMLNode;
    ListStream: TMemoryStream;
  begin
    Xml:=TALXMLDocument.Create(nil);
    try
      Xml.Active:=true;
      Xml.Version:='1.0';
      Xml.Encoding:='windows-1251';
      Xml.StandAlone:='yes';
      Data:=Xml.AddChild('data');
      Data.AddChild('rnd').NodeValue:=Rnd;
      Data.AddChild('method').NodeValue:=Method;
      if Assigned(List) then begin
        ListStream:=TMemoryStream.Create;
        try
          List.SaveToStream(ListStream,sfXml);
          ListStream.Position:=0;
          Data.AddChild('list').LoadFromStream(ListStream);
        finally
          ListStream.Free;
        end;
      end;
      Xml.SaveToStream(Stream);
      Stream.Position:=0;
    finally
      Xml.Free;
    end;
  end;

  function ReadXmlStream(Stream: TMemoryStream; var Error: String): Boolean;
  var
    Xml: TALXMLDocument;
    i,j: Integer;
    Node,Data: TALXMLNode;
    ListStream: TMemoryStream;
  begin
    Xml:=TALXMLDocument.Create(nil);
    try
      Result:=false;
      Xml.LoadFromStream(Stream);
      for i:=0 to Xml.ChildNodes.Count-1 do begin
        Node:=Xml.ChildNodes[i];
        if AnsiSameText(Node.NodeName,'data') then begin
          Data:=Node;
          for j:=0 to Data.ChildNodes.Count-1 do begin
            Node:=Data.ChildNodes[j];
            if AnsiSameText(Node.NodeName,'rnd') then ; // read Rnd
            if AnsiSameText(Node.NodeName,'success') then Result:=Boolean(VarToIntDef(Node.NodeValue,0));
            if AnsiSameText(Node.NodeName,'error') then Error:=VarToStrDef(Node.NodeValue,'');
            if AnsiSameText(Node.NodeName,'list') then begin
              if Assigned(List) then begin
                ListStream:=TMemoryStream.Create;
                try
                  Node.SaveToStream(ListStream);
                  ListStream.Position:=0;
                  List.LoadFromStream(ListStream,sfXml);
                finally
                  ListStream.Free;
                end;
              end;
            end;
          end;
        end;
      end;
    finally
      Xml.Free;
    end;
  end;

var
  RequestStream: TMemoryStream;
  ResponseStream: TMemoryStream;
  TempStream: TMemoryStream;
  FullUrl: String;
  Key: String;
  Rnd: String;
  Error: String;
  Crypter: TBisCrypter;
  Success: Boolean;
begin
  RequestStream:=TMemoryStream.Create;
  ResponseStream:=TMemoryStream.Create;
  TempStream:=TMemoryStream.Create;
  Crypter:=TBisCrypter.Create;
  try
    Result:=false;

    FullUrl:=GetFullUrl();
    Key:=GetKey(FCrypterKey);
    Rnd:=GetUniqueID;

    case FStreamFormat of
      hfRaw: WriteRawStream(Rnd,TempStream);
      hfXml: WriteXmlStream(Rnd,TempStream);
    end;

    if FUseCompressor then
      Compress(TempStream);

    RequestStream.Clear;
    TempStream.Position:=0;
    if FUseCrypter then
      Crypter.EncodeStream(Key,TempStream,RequestStream,FCrypterAlgorithm,FCrypterMode)
    else
      RequestStream.CopyFrom(TempStream,TempStream.Size);

    RequestStream.Position:=0;

    Post(FullUrl,RequestStream,ResponseStream);

    Key:=GetKey(FCrypterKey);
    
    ResponseStream.Position:=0;
    TempStream.Clear;
    if FUseCrypter then
      Crypter.DecodeStream(Key,ResponseStream,TempStream,FCrypterAlgorithm,FCrypterMode)
    else
      TempStream.CopyFrom(ResponseStream,ResponseStream.Size);

    if FUseCompressor then
      Decompress(TempStream);

    Success:=false;
    TempStream.Position:=0;

    if TempStream.Size>0 then begin

      case FStreamFormat of
        hfRaw: Success:=ReadRawStream(TempStream,Error);
        hfXml: Success:=ReadXmlStream(TempStream,Error);
      end;

    end;

    Result:=Success;
    if not Result then
      raise Exception.Create(Error);

  finally
    Crypter.Free;
    TempStream.Free;
    ResponseStream.Free;
    RequestStream.Free;
  end;
end;

function TBisSupportHttp.GetList(List: TBisSupportList): Boolean;
begin
  Result:=false;
  if FConnected and Assigned(List) then begin
    Result:=ExecuteMethod(umGetList,List);
  end;
end;

function TBisSupportHttp.GetFiles(List: TBisSupportList): Boolean;
begin
  Result:=false;
  if FConnected and Assigned(List) then begin
    Result:=ExecuteMethod(umGetFiles,List);
  end;
end;

end.
