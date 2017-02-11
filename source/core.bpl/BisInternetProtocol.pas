unit BisInternetProtocol;

interface

uses Windows, Classes, SysUtils, ActiveX, UrlMon, ComObj, {ComServ, }WinInet;

const
   Class_BisInternetProtocol: TGUID='{18E6911B-45EA-43E6-8869-E78DDBF3AE41}';

type
  TBisInternetProtocol=class;

  TBisOnGetDocumentByUrl=procedure(const Url: string; Stream: TMemoryStream; var Found: Boolean) of object;

  TBisComObjectFactory=class(TComObjectFactory)
  private
    FOnGetDocumentByUrl: TBisOnGetDocumentByUrl;
  public
    function CreateComObject(const Controller: IUnknown): TComObject; override;

    property OnGetDocumentByUrl: TBisOnGetDocumentByUrl read FOnGetDocumentByUrl write FOnGetDocumentByUrl;
  end;

  TBisInternetProtocol=class(TComObject,IInternetProtocol)//,IInternetProtocolRoot,IInternetProtocolInfo)
  private
    FUrl: string;
    FMemStream: TMemoryStream;
    FOnGetDocumentByUrl: TBisOnGetDocumentByUrl;
    function DecodeUrl(const AStr: String): String;
    function ExpandURL(URL: string): Boolean;
    procedure WriteText(const Text: string);
  protected
    function Start(szUrl: LPCWSTR; OIProtSink: IInternetProtocolSink;
      OIBindInfo: IInternetBindInfo; grfPI, dwReserved: DWORD): HResult; stdcall;
    function Continue(const ProtocolData: TProtocolData): HResult; stdcall;
    function Abort(hrReason: HResult; dwOptions: DWORD): HResult; stdcall;
    function Terminate(dwOptions: DWORD): HResult; stdcall;
    function Suspend: HResult; stdcall;
    function Resume: HResult; stdcall;

    function Read(pv: Pointer; cb: ULONG; out cbRead: ULONG): HResult; stdcall;
    function Seek(dlibMove: LARGE_INTEGER; dwOrigin: DWORD; out libNewPosition: ULARGE_INTEGER): HResult; stdcall;
    function LockRequest(dwOptions: DWORD): HResult; stdcall;
    function UnlockRequest: HResult; stdcall;

    procedure DoGetDocumentByUrl(var Found: Boolean);

  public
    procedure Initialize; override;
    destructor Destroy; override;

    property OnGetDocumentByUrl: TBisOnGetDocumentByUrl read FOnGetDocumentByUrl write FOnGetDocumentByUrl;
  end;

{var
  BisInternetProtocolClassFactory: TBisComObjectFactory=nil;}
  
{function RegisterNameSpace(const Url: string): Boolean;
function UnRegisterNameSpace(const Url: string): Boolean;}

implementation

uses Math{, HTTPApp};

var
  InternetSession: IInternetSession;
  ProtSink: IInternetProtocolSink;
  BindInfo: IInternetBindInfo;

{function RegisterNameSpace(const Url: string): Boolean;
var
  hr: HResult;
begin
  Result:=false;
  hr:=CoInternetGetSession(0,InternetSession,0);
  if Succeeded(hr) then begin
    hr:=InternetSession.RegisterNameSpace(BisInternetProtocolClassFactory,IID_IInternetProtocol,StringToOleStr(Url),0,nil,0);
    Result:=Succeeded(hr);
  end;
end;

function UnRegisterNameSpace(const Url: string): Boolean;
begin
  Result:=false;
  if not Assigned(InternetSession) then exit;
  Result:=Succeeded(InternetSession.UnregisterNameSpace(BisInternetProtocolClassFactory,StringToOleStr(Url)));
  InternetSession:=nil;
  ProtSink:=nil;
  BindInfo:=nil;
end;}

{ TBisComObjectFactory }

function TBisComObjectFactory.CreateComObject(const Controller: IUnknown): TComObject;
begin
  Result:=Inherited CreateComObject(Controller);
  if Result is TBisInternetProtocol then
    with TBisInternetProtocol(Result) do begin
      OnGetDocumentByUrl:=Self.FOnGetDocumentByUrl;
    end;
end;


{ TBisInternetProtocol }

procedure TBisInternetProtocol.Initialize;
begin
  inherited;
  FMemStream:=TMemoryStream.Create;
end;

destructor TBisInternetProtocol.Destroy;
begin
  FMemStream.Free;
  inherited;
end;

function TBisInternetProtocol.DecodeUrl(const AStr: String): String;
var
  Sp, Rp, Cp: PChar;
begin
  SetLength(Result, Length(AStr));
  Sp := PChar(AStr);
  Rp := PChar(Result);
  while Sp^ <> #0 do
  begin
    if not (Sp^ in ['+','%']) then
      Rp^ := Sp^
    else
      if Sp^ = '+' then
        Rp^ := ' '
      else
      begin
        inc(Sp);
        if Sp^ = '%' then
          Rp^ := '%'
        else
        begin
          Cp := Sp;
          Inc(Sp);
          Rp^ := Chr(StrToInt(Format('$%s%s',[Cp^, Sp^])));
        end;
      end;
    Inc(Rp);
    Inc(Sp);
  end;
  SetLength(Result, Rp - PChar(Result));
end;

function TBisInternetProtocol.ExpandURL(URL: string): Boolean;
begin
  // dunnow how this could happen
  if (Pos(':', URL) = 0) then
  begin
  	Result := False;
    Exit;
  end;
  // strip off the ework:
  FURL := Copy(URL, Pos(':', URL)+1, Length(URL));
  FURL:=DecodeUrl(FUrl);
  Result := True;
end;

procedure TBisInternetProtocol.WriteText(const Text: string);
begin
  FMemStream.Clear;
  FMemStream.WriteBuffer(Pointer(Text)^,Length(Text));
  FMemStream.Position:=0;
end;

procedure TBisInternetProtocol.DoGetDocumentByUrl(var Found: Boolean);
begin
  if Assigned(FOnGetDocumentByUrl) then
    FOnGetDocumentByUrl(FUrl,FMemStream,Found);
end;

function TBisInternetProtocol.Start(szUrl: LPCWSTR; OIProtSink: IInternetProtocolSink;
  OIBindInfo: IInternetBindInfo; grfPI, dwReserved: DWORD): HResult; stdcall;

  procedure WriteDefault;
  begin
    WriteText('<HTML></HTML>');
  end;

var
  Found: Boolean;
begin

  ProtSink:= OIProtSink;
  BindInfo:=OIBindInfo;

  ExpandURL(szURL);

  WriteDefault;
  Found:=false;

  DoGetDocumentByUrl(Found);

  if not Found then
    WriteDefault;

  ProtSink.ReportData(BSCF_FIRSTDATANOTIFICATION or BSCF_INTERMEDIATEDATANOTIFICATION or
                      BSCF_LASTDATANOTIFICATION or BSCF_DATAFULLYAVAILABLE,
                      FMemStream.Size, FMemStream.Size);

  Result := S_OK;
end;

function TBisInternetProtocol.Read(pv: Pointer; cb: ULONG; out cbRead: ULONG): HResult; stdcall;
begin

  Result := S_OK;

  // calcualte the ammount of data to be read
  cbRead := Min(FMemStream.Size-FMemStream.Position, cb);

  // read in the data
  if (FMemStream.Position < FMemStream.Size) then begin
    FMemStream.ReadBuffer(pv^, cbRead);
  end;

  // have we finished?
  if Assigned(ProtSink) then
    if (FMemStream.Position = FMemStream.Size) then begin
      ProtSink.ReportResult(S_OK, 0, nil);
      Result := S_FALSE;
    end else begin
      ProtSink.ReportProgress(BINDSTATUS_BEGINDOWNLOADDATA or
                              BINDSTATUS_DOWNLOADINGDATA or
                              BINDSTATUS_ENDDOWNLOADDATA,nil);
    end;

end;

function TBisInternetProtocol.Continue(const ProtocolData: TProtocolData): HResult; stdcall;
begin
  Result:=S_OK;
end;

function TBisInternetProtocol.Abort(hrReason: HResult; dwOptions: DWORD): HResult; stdcall;
begin
  Result:=S_OK;
end;

function TBisInternetProtocol.Terminate(dwOptions: DWORD): HResult; stdcall;
begin
  Result:=S_OK;
end;

function TBisInternetProtocol.Suspend: HResult; stdcall;
begin
  Result:=S_OK;
end;

function TBisInternetProtocol.Resume: HResult; stdcall;
begin
  Result:=S_OK;
end;

function TBisInternetProtocol.Seek(dlibMove: LARGE_INTEGER; dwOrigin: DWORD; out libNewPosition: ULARGE_INTEGER): HResult; stdcall;
begin
  Result:=S_OK;
end;

function TBisInternetProtocol.LockRequest(dwOptions: DWORD): HResult; stdcall;
var
  LBindInfo: TBindInfo;
  BINDF: DWORD;

  // generate a string of any data passed in the request
  // TODO - cope with other data types other than HGlobal
  function GetData : string;
  begin
    Result := '';
    if LBindInfo.stgmedData.tymed = TYMED_HGLOBAL then
    begin
    	if (LBindInfo.stgmedData.hGlobal <> 0) then
      begin
        Result := Copy(StrPas(PChar(LBindInfo.stgmedData.hGlobal)), 1, GlobalSize(LBindInfo.stgmedData.hGlobal));
      end;
    end;
  end;

  // returns the data type of the operation
  function GetDataType : string;
  begin
    case LBindInfo.stgmedData.tymed of
      TYMED_NULL : Result := 'None';
      TYMED_GDI : Result := 'GDI';
      TYMED_MFPICT : Result := 'Metafile picture';
      TYMED_ENHMF : Result := 'Enhanced metafile';
      TYMED_HGLOBAL : Result := 'Global memory';
      TYMED_FILE : Result := 'File';
      TYMED_ISTREAM : Result := 'IStream interface';
      TYMED_ISTORAGE : Result := 'IStorage interface';
    else
      Result := 'Unknown';
    end;
  end;

  // generate a string to represent the type of this operation
  function GetOperation : string;
  begin
    case LBindInfo.dwBindVerb of
      BINDVERB_GET : Result := 'Get';
      BINDVERB_POST : Result := 'Post';
      BINDVERB_PUT : Result := 'Put';
      BINDVERB_CUSTOM : Result := LBindInfo.szCustomVerb;
    else
      Result := 'Unknown';
    end;
  end;

  
begin
  LBindInfo.cbSize := SizeOf(LBindInfo);
  if Assigned(BindInfo) then begin
    BindInfo.GetBindInfo(BINDF, LBindInfo);
  end;
  Result:=S_OK;
end;

function TBisInternetProtocol.UnlockRequest: HResult; stdcall;
begin
  Result:=S_OK;
end;

initialization
{  BisInternetProtocolClassFactory:=TBisComObjectFactory.Create(nil, TBisInternetProtocol, Class_BisInternetProtocol,
                                                               'BisInternetProtocol', '', ciInternal, tmSingle);}
finalization
//  BisInternetProtocolClassFactory:=nil;

end.