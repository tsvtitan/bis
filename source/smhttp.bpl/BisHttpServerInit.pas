unit BisHttpServerInit;

interface

uses Classes, Contnrs, ZLib,
     HTTPApp,
     IdHTTPServer, IdHttp, IdContext, IdCustomHTTPServer,
     BisObject, BisServers, BisServerModules, BisDataSet, BisCore, BisLogger,
     BisConnections, BisHttpServerHandlerModules, BisNotifyEvents,
     BisHttpServerHandlers, BisHttpServerRedirects, BisCrypter;

type
  TBisHttpServer=class;

  TBisIdHttpServerClient=class(TObject)
  private
    FID: String;
    FTick: Int64;
    FFreq: Int64;
  end;

  TBisIdHttpServerClients=class(TThreadList)
  end;

  TBisIdHttp=class(TIdHttp)
  end;

  TBisIdHttpServer=class(TIdHTTPServer)
  private
    FServer: TBisHttpServer;
    FClients: TBisIdHttpServerClients;
    FServerName: String;
    procedure CommandGet(AContext:TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    function GetRealyHost(Host: string; var Port: String): String;
    function GetKey(Host,Port,Path,Document,Key: String): String;
    procedure CompressStream(Stream: TStream; Level: TCompressionLevel);
    procedure DecompressStream(Stream: TStream);
    procedure DecodeStream(Key: String; Stream: TStream; Algorithm: TBisCipherAlgorithm; Mode: TBisCipherMode);
    procedure EncodeStream(Key: String; Stream: TStream; Algorithm: TBisCipherAlgorithm; Mode: TBisCipherMode);
    procedure HandlerResponseSendResponse(Sender: TObject);
  protected
    procedure DoConnect(AContext: TIdContext); override;
    procedure DoDisconnect(AContext: TIdContext); override;
    procedure DoCommandOther(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo); override;
    procedure DoCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo); override;

    property Server: TBisHttpServer read FServer write FServer;
  public
    constructor Create(AOnwer: TComponent); reintroduce;
    destructor Destroy; override;

    property ServerName: String read FServerName write FServerName;
  end;

  TBisHttpServer=class(TBisServer)
  private
    FIP: String;
    FPort: String;
    FServer: TBisIdHttpServer;
    FModules: TBisHttpServerHandlerModules;
    FRedirects: TBisHttpServerRedirects;
    FSDoCommandGetFail: String;
    FSHandlerNotFound: String;
    FSInvalidHandler: String;
    FSRequestPage: String;
    FSConnectRemote: String;
    FSStopRemote: String;
    FExtendedLog: Boolean;
    FConnectionUpdate: Boolean;
    FWhiteList: TStringList;
    FBlackList: TStringList;
    FSAccessDenied: String;
    FWhoamiUrl: String;
    FSWhoami: String;
    FAfterLoginEvent: TBisNotifyEvent;

    procedure ChangeParams(Sender: TObject);
    procedure AfterLoginEvent(Sender: TObject);
    procedure ConnectionUpdate(Empty: Boolean);
//    function Whoami(var IP, Host: String): Boolean;
  protected
    function GetStarted: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure Start; override;
    procedure Stop; override;

    property Modules: TBisHttpServerHandlerModules read FModules;
    property Redirects: TBisHttpServerRedirects read FRedirects;
    property WhiteList: TStringList read FWhiteList;
    property BlackList: TStringList read FBlackList;

    property ExtendedLog: Boolean read FExtendedLog write FExtendedLog;

  published

    property SConnectRemote: String read FSConnectRemote write FSConnectRemote;
    property SStopRemote: String read FSStopRemote write FSStopRemote;
    property SDoCommandGetFail: String read FSDoCommandGetFail write FSDoCommandGetFail;
    property SHandlerNotFound: String read FSHandlerNotFound write FSHandlerNotFound;
    property SInvalidHandler: String read FSInvalidHandler write FSInvalidHandler;
    property SRequestPage: String read FSRequestPage write FSRequestPage;
    property SAccessDenied: String read FSAccessDenied write FSAccessDenied;
    property SWhoami: String read FSWhoami write FSWhoami;
  end;

procedure InitServerModule(AModule: TBisServerModule); stdcall;

exports
  InitServerModule;

implementation

uses Windows, SysUtils, Dialogs,
     IdSocketHandle, IdAssignedNumbers, IdException, IdGlobal, IdStackWindows,
     IdAuthentication, IdSchedulerOfThread, IdThread,
     BisConsts, BisUtils, BisProvider, BisNetUtils, BisConfig, BisDataParams, BisThreads,
     BisExceptNotifier, BisHttpServerConsts, BisHttpServerResponse, BisHttpServerRequest;


procedure InitServerModule(AModule: TBisServerModule); stdcall;
begin
  AModule.ServerClass:=TBisHttpServer;
end;

{ TBisIdHttpServer }

constructor TBisIdHttpServer.Create(AOnwer: TComponent);
begin
  inherited Create;
  FClients:=TBisIdHttpServerClients.Create;
  OnCommandGet:=CommandGet;
end;

destructor TBisIdHttpServer.Destroy;
begin
  Active:=false;
  FClients.Free;
  inherited Destroy;
end;

procedure TBisIdHttpServer.CommandGet(AContext:TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  // Why???
end;

procedure TBisIdHttpServer.DoConnect(AContext: TIdContext);

  function CanConnect: Boolean;
  begin
    Result:=true;
    if FServer.WhiteList.Count>0 then
      Result:=MatchIP(AContext.Binding.PeerIP,FServer.WhiteList);
    if Result and (FServer.BlackList.Count>0)  then
      Result:=not MatchIP(AContext.Binding.PeerIP,FServer.BlackList);
  end;

var
  Client: TBisIdHttpServerClient;
  ID: String;
  F: Int64;
begin
  ID:='';
  SetThreadName('HttpServer');
  if Assigned(FServer) then begin
    FServer.Working:=true;
    FServer.LoggerWrite(FormatEx(FServer.SConnectRemote,[AContext.Binding.PeerIP,AContext.Binding.PeerPort]));
    Client:=TBisIdHttpServerClient.Create;
    Client.FID:=ID;
    Client.FTick:=GetTickCount(F);
    Client.FFreq:=F;
    FClients.Add(Client);
    AContext.Data:=Client;
    if not CanConnect then begin
      FServer.LoggerWrite(FormatEx(FServer.SAccessDenied,[ID]));
      AContext.Connection.Disconnect;
    end;
  end;
end;

procedure TBisIdHttpServer.DoDisconnect(AContext: TIdContext);
var
  Client: TBisIdHttpServerClient;
  List: TList;
  S: String;
  Tick: Int64;
begin
  Client:=TBisIdHttpServerClient(AContext.Data);
  if Assigned(FServer) and Assigned(Client) then begin
    List:=FClients.LockList;
    try
      Tick:=GetTickDifference(Client.FTick,Client.FFreq,dtMilliSec);
      S:=IntToStr(Tick);
      List.Remove(Client);
      FServer.Working:=List.Count>0;
      FServer.LoggerWrite(FormatEx(FServer.SStopRemote,[S]));
      Client.Free;
      AContext.Data:=nil;
    finally
      FClients.UnlockList;
    end;
  end;
end;

function TBisIdHttpServer.GetRealyHost(Host: string; var Port: String): String;
var
  APos: Integer;
const
  SDelim=':';
begin
  Apos:=Pos(SDelim,Host);
  if Apos>0 then begin
    Result:=Copy(Host,1,APos-1);
    Port:=Copy(Host,APos+Length(SDelim),Length(Host));
  end else begin
    Result:=Host;
  end;
end;

procedure TBisIdHttpServer.DoCommandOther(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
end;

function TBisIdHttpServer.GetKey(Host,Port,Path,Document,Key: String): String;
{var
  Crypter: TBisCrypter;}
begin
  Result:=Key;
{  Crypter:=TBisCrypter.Create;
  try
  //  Result:=Trim(Format('%s:%s%s%s+%s',[Host,Port,Path,Document,Key]));
    Result:=Trim(Format('%s',[Key]));
    //Result:=Crypter.HashString(Result,haMD5,hfHEX);
  finally
    Crypter.Free;
  end;}
end;

procedure TBisIdHttpServer.CompressStream(Stream: TStream; Level: TCompressionLevel);
var
  Zip: TCompressionStream;
  TempStream: TMemoryStream;
begin
  if Assigned(Stream) then begin
    TempStream:=TMemoryStream.Create;
    try
      Zip:=TCompressionStream.Create(Level,TempStream);
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

procedure TBisIdHttpServer.DecompressStream(Stream: TStream);
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

procedure TBisIdHttpServer.DecodeStream(Key: String; Stream: TStream; Algorithm: TBisCipherAlgorithm; Mode: TBisCipherMode);
var
  Crypter: TBisCrypter;
  TempStream: TMemoryStream;
begin
  if Assigned(Stream) then begin
    TempStream:=TMemoryStream.Create;
    Crypter:=TBisCrypter.Create;
    try
      Stream.Position:=0;
      Crypter.DecodeStream(Key,Stream,TempStream,Algorithm,Mode);
      TempStream.Position:=0;
      Stream.Size:=0;
      Stream.Position:=0;
      Stream.CopyFrom(TempStream,TempStream.Size);
      Stream.Position:=0;
    finally
      Crypter.Free;
      TempStream.Free;
    end;
  end;
end;

procedure TBisIdHttpServer.EncodeStream(Key: String; Stream: TStream; Algorithm: TBisCipherAlgorithm; Mode: TBisCipherMode);
var
  Crypter: TBisCrypter;
  TempStream: TMemoryStream;
begin
  if Assigned(Stream) then begin
    TempStream:=TMemoryStream.Create;
    Crypter:=TBisCrypter.Create;
    try
      Stream.Position:=0;
      Crypter.EncodeStream(Key,Stream,TempStream,Algorithm,Mode);
      TempStream.Position:=0;
      Stream.Size:=0;
      Stream.CopyFrom(TempStream,TempStream.Size);
      Stream.Position:=0;
    finally
      Crypter.Free;
      TempStream.Free;
    end;
  end;
end;

procedure TBisIdHttpServer.HandlerResponseSendResponse(Sender: TObject);
var
  Response: TBisHttpServerResponse;
  Key: String;
begin
  if Assigned(Sender) and (Sender is TBisHttpServerResponse) then begin
    Response:=TBisHttpServerResponse(Sender);
    if Assigned(Response.ContentStream) and Assigned(Response.Handler) then begin
      if Response.Handler.UseCompressor then
        CompressStream(Response.ContentStream,Response.Handler.CompressorLevel);
      if Response.Handler.UseCrypter then begin
        Key:=GetKey(Response.Host,Response.Port,Response.Path,Response.Script,Response.Handler.CrypterKey);
        EncodeStream(Key,Response.ContentStream,Response.Handler.CrypterAlgorithm,Response.Handler.CrypterMode);
      end;
    end;
  end;
end;

procedure TBisIdHttpServer.DoCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  NewHost: string;
  Client: TBisIdHttpServerClient;

  procedure CommandGetNotFound(ResponseNo: Integer; Error: string);
  begin
    AResponseInfo.ResponseNo:=ResponseNo;
    FServer.LoggerWrite(FormatEx(FServer.SDoCommandGetFail,[Error]),ltError);
  end;

  procedure LoggerWriteProperties;
  var
    Str: TStringList;
    i: Integer;
  begin
    FServer.LoggerWrite(FormatEx(FServer.SRequestPage,[ARequestInfo.Host,ARequestInfo.RawHTTPCommand]));
    if FServer.ExtendedLog then begin
      Str:=TStringList.Create;
      try
        GetObjectProperties(ARequestInfo,Str);
        for i:=0 to Str.Count-1 do
          FServer.LoggerWrite(FormatEx('%s',[Str.Strings[i]]));
      finally
        Str.Free;
      end;
    end;
  end;

var
  Request: TBisHttpServerRequest;
  Response: TBisHttpServerResponse;
  Original, NewHandler: TBisHttpServerHandler;
  Redirect: TBisHttpServerRedirect;
  OutPath,OutScript: string;
  InKey, OutKey: String;
  NewPort: String;
  Found: Boolean;
  Http: TBisIdHttp;
  FullUrl: String;
  TempStream: TMemoryStream;
  Str: TStringList;
  AccessGranted: Boolean;
begin
  Client:=TBisIdHttpServerClient(AContext.Data);                
  if Assigned(Client) and Assigned(FServer) then begin
    LoggerWriteProperties;
    NewPort:=IntToStr(AContext.Binding.Port);
    NewHost:=GetRealyHost(ARequestInfo.Host,NewPort);
    try
      // by handler
      Original:=FServer.Modules.FindHandler(NewHost,ARequestInfo.Document,OutPath,OutScript);
      if Assigned(Original) then begin
        ServerSoftware:=iff(Trim(Original.Software)<>'',Original.Software,Original.ObjectName);
      end else
        ServerSoftware:=FServer.ObjectName;

      Found:=Assigned(Original) and Original.Enabled and (ARequestInfo.CommandType in [hcGET,hcPOST]);
      if Found then begin

        AccessGranted:=true;
        if (Trim(Original.AuthRealm)<>'') then begin
          if not ARequestInfo.AuthExists and (Original.AuthUsers.Count>0) then begin
            AResponseInfo.AuthRealm:=Original.AuthRealm;
            AResponseInfo.WriteHeader;
            exit;
          end else begin
            AccessGranted:=Original.UserExists(ARequestInfo.AuthUsername,ARequestInfo.AuthPassword);
          end;
        end;

        if AccessGranted then begin
          NewHandler:=TBisHttpServerHandlerClass(Original.ClassType).Create(nil);
          try
            NewHandler.Enabled:=true;
            NewHandler.CopyFrom(Original);

            InKey:=GetKey(NewHost,NewPort,OutPath,OutScript,NewHandler.CrypterKey);

            if ARequestInfo.CommandType=hcPOST then begin

              if NewHandler.UseCrypter then
                DecodeStream(InKey,ARequestInfo.PostStream,NewHandler.CrypterAlgorithm,NewHandler.CrypterMode);

              if NewHandler.UseCompressor then
                DecompressStream(ARequestInfo.PostStream);

              ARequestInfo.UnparsedParams:=ReadStringFromStream(ARequestInfo.PostStream);
            end;

            Request:=TBisHttpServerRequest.Create(AContext,ARequestInfo,AResponseInfo);
            try
              Request.NewPathInfo:=OutScript;
              Response:=TBisHttpServerResponse.Create(Request,AContext,ARequestInfo,AResponseInfo);
              try
                Response.OnSendResponse:=HandlerResponseSendResponse;
                Response.Handler:=NewHandler;
                Response.Redirect:=nil;
                Response.Host:=NewHost;
                Response.Port:=NewPort;
                Response.Path:=OutPath;
                Response.Script:=OutScript;
                if NewHandler.HandleRequest(Request,Response) then begin
                  if not Response.Sent then begin
                    Response.SendResponse;
                  end;
                end else
                  CommandGetNotFound(PageNotFound,FServer.SInvalidHandler);

              finally
                Response.Free;
              end;
            finally
              Request.Free;
            end;

          finally
            NewHandler.Free;
          end;

        end else
          CommandGetNotFound(PageAccessDenied,FServer.SAccessDenied);
      end;

      // by redirect
      if not Found then begin
        Redirect:=FServer.Redirects.FindRedirect(NewHost,ARequestInfo.Document,OutPath,OutScript);
        Found:=Assigned(Redirect) and Redirect.Enabled and (ARequestInfo.CommandType in [hcGET,hcPOST]);
        if Found then begin
          Http:=TBisIdHttp.Create(nil);
          TempStream:=TMemoryStream.Create;
          try
            FullUrl:='';
            try
              Http.Request.UserAgent:='';

              if Trim(Redirect.OutParams.AuthUserName)<>'' then begin
                Http.Request.BasicAuthentication:=true;
                if not Assigned(Http.Request.Authentication) then
                  Http.Request.Authentication:=TIdBasicAuthentication.Create;
                Http.Request.Authentication.Username:=Redirect.OutParams.AuthUserName;
                Http.Request.Authentication.Password:=Redirect.OutParams.AuthPassword;
              end;

              
              Http.URL.Host:=Redirect.OutParams.Host;
              Http.URL.Port:=IntToStr(Redirect.OutParams.Port);
              Http.URL.Protocol:=Redirect.OutParams.Protocol;
              Http.URL.Path:=Redirect.OutParams.Path+OutScript;
              Http.Url.Document:='';
              Http.URL.Params:=iff(Trim(ARequestInfo.QueryParams)<>'','?'+ARequestInfo.QueryParams,'');
              FullUrl:=Http.URL.GetFullURI([]);
            except
            end;

            if Redirect.Mode=rmRedirect then begin

              AResponseInfo.Redirect(FullUrl);
              
            end else begin

              if Redirect.OutParams.UseProxy then begin
                Http.ProxyParams.ProxyServer:=Redirect.OutParams.ProxyHost;
                Http.ProxyParams.ProxyPort:=Redirect.OutParams.Port;
                Http.ProxyParams.ProxyUsername:=Redirect.OutParams.ProxyUserName;
                Http.ProxyParams.ProxyPassword:=Redirect.OutParams.ProxyPassword;
              end;

              InKey:=GetKey(NewHost,NewPort,OutPath,OutScript,Redirect.InParams.CrypterKey);
              OutKey:=GetKey(Http.Url.Host,Http.Url.Port,Http.Url.Path,Http.Url.Document,Redirect.OutParams.CrypterKey);

              case ARequestInfo.CommandType of
                hcGET: begin
                  Http.Get(FullUrl,TempStream);
                end;
                hcPOST: begin

                  if Redirect.InParams.UseCrypter then
                    DecodeStream(InKey,ARequestInfo.PostStream,Redirect.InParams.CrypterAlgorithm,Redirect.InParams.CrypterMode);

                  if Redirect.InParams.UseCompressor then
                    DecompressStream(ARequestInfo.PostStream);

                  if Redirect.OutParams.UseCompressor then
                    CompressStream(ARequestInfo.PostStream,Redirect.OutParams.CompressorLevel);

                  if Redirect.OutParams.UseCrypter then
                    EncodeStream(OutKey,ARequestInfo.PostStream,Redirect.OutParams.CrypterAlgorithm,Redirect.OutParams.CrypterMode);

                  Http.Post(FullUrl,ARequestInfo.PostStream,TempStream);

                end;
              end;

              if Redirect.OutParams.UseCrypter then
                DecodeStream(OutKey,TempStream,Redirect.OutParams.CrypterAlgorithm,Redirect.OutParams.CrypterMode);

              if Redirect.OutParams.UseCompressor then
                DecompressStream(TempStream);

              if Redirect.InParams.UseCompressor then
                CompressStream(TempStream,Redirect.InParams.CompressorLevel);

              if Redirect.InParams.UseCrypter then
                EncodeStream(InKey,TempStream,Redirect.InParams.CrypterAlgorithm,Redirect.InParams.CrypterMode);

              AResponseInfo.ContentStream:=TempStream;
              AResponseInfo.ContentEncoding:=Http.Response.ContentEncoding;
              AResponseInfo.ContentType:=Http.Response.ContentType;
              AResponseInfo.FreeContentStream:=false;
              AResponseInfo.WriteHeader;
              AResponseInfo.WriteContent;
            end;

          finally
            TempStream.Free;
            Http.Free;
          end;
        end;
      end;

      if not Found then begin
        OutScript:=StringReplace(ARequestInfo.Document,'/',PathDelim,[rfReplaceAll, rfIgnoreCase]);
        OutScript:=ExtractFileName(OutScript);
        Found:=AnsiSameText(OutScript,'whoami') and (Trim(ARequestInfo.RemoteIP)<>'') and (ARequestInfo.CommandType in [hcGET,hcPOST]);
        if Found then begin
          Str:=TStringList.Create;
          try
            Str.Add(ARequestInfo.RemoteIP);
            try
              Str.Add(GWindowsStack.HostByAddress(ARequestInfo.RemoteIP));
            except
            end;
            AResponseInfo.ContentText:=Trim(Str.Text);
            AResponseInfo.ContentType:='text/html';
            AResponseInfo.WriteHeader;
            AResponseInfo.WriteContent;
          finally
            Str.Free;
          end;
        end;
      end;

      if not Found then
        CommandGetNotFound(PageNotFound,FServer.SHandlerNotFound);

    except
      On E: Exception do
        CommandGetNotFound(PageNotFound,E.Message);
    end;
  end;
end;

{ TBisHttpServer }

constructor TBisHttpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Params.OnChange:=ChangeParams;
  FServer:=TBisIdHttpServer.Create(Self);
  FServer.Server:=Self;

  FModules:=TBisHttpServerHandlerModules.Create(Self);
  FRedirects:=TBisHttpServerRedirects.Create(Self);
  FWhiteList:=TStringList.Create;
  FBlackList:=TStringList.Create;

  FSStopRemote:='��������� ����������. ����� => %s';
  FSConnectRemote:='����������� ���������� � ip-������� %s:%d';
  FSDoCommandGetFail:='��������� ��������� ��������. %s';
  FSRequestPage:='��������� �������� [%s %s]';
  FSHandlerNotFound:='�� ������ ���������� ��������.';
  FSInvalidHandler:='�������� ���������� ��������.';
  FSAccessDenied:='������ ��������.';
  FSWhoami:='����������� ip-������ � ����� �� %s';

  if Assigned(Core) then begin
    FAfterLoginEvent:=Core.AfterLoginEvents.Add(AfterLoginEvent);
  end;
end;

destructor TBisHttpServer.Destroy;
begin
  if Assigned(Core) then begin
    Core.AfterLoginEvents.Remove(FAfterLoginEvent)
  end;
  
  FBlackList.Free;
  FWhiteList.Free;
  FRedirects.Free;
  FModules.Free;
  FServer.Free;
  inherited Destroy;
end;

function TBisHttpServer.GetStarted: Boolean;
begin
  Result:=FServer.Active;
end;

procedure TBisHttpServer.Init;
begin
  inherited Init;
  FServer.ServerSoftware:=ObjectName;
  FModules.Init;
  FRedirects.Init;
end;

procedure TBisHttpServer.AfterLoginEvent(Sender: TObject);
begin
  if FServer.Active then begin
    ConnectionUpdate(false);
  end;
end;

procedure TBisHttpServer.ChangeParams(Sender: TObject);
var
  IPs, Ports: TStringList;
  AIP, APort: String;
  SocketHandle: TIdSocketHandle;
begin

  with Params do begin

    FIP:=AsString(SParamIP);
    FPort:=AsString(SParamPort);
    FExtendedLog:=AsBoolean(SParamExtendedLog);
    FConnectionUpdate:=AsBoolean(SParamConnectionUpdate);
    FWhoamiUrl:=AsString(SParamWhoamiUrl);

    SaveToDataSet(SParamModules,FModules.Table);
    SaveToDataSet(SParamRedirects,FRedirects.Table);

    FWhiteList.Text:=AsString(SParamWhiteList);
    FBlackList.Text:=AsString(SParamBlackList);

  end;

  IPs:=TStringList.Create;
  Ports:=TStringList.Create;
  try
    FServer.Bindings.Clear;
    GetStringsByString(FIP,';',IPs);
    GetStringsByString(FPort,';',Ports);
    for AIP in IPs do begin
      for APort in Ports do begin
        SocketHandle:=FServer.Bindings.Add;
        SocketHandle.IP:=AIP;
        SocketHandle.Port:=StrToIntDef(APort,IdPORT_HTTP);
      end;
    end;
  finally
    Ports.Free;
    IPs.Free;
  end;
end;

procedure TBisHttpServer.ConnectionUpdate(Empty: Boolean);
{var
  Params: TBisConfig;
  Module: TBisHttpServerHandlerModule;
  Handler: TBisHttpServerHandler;
  j,i: Integer;
  NewIP: String;
  NewHost: String;
  IPList: TStringList;}
begin
  if FConnectionUpdate and Assigned(Core) then begin
 {   Params:=TBisConfig.Create(nil);
    IPList:=TStringList.Create;
    try
      NewIP:=Core.ExternalIP;
      NewHost:=Core.ExternalHost;
      GetIPList(IPList);
      if (FServer.Bindings.Count>0) then begin
        for i:=0 to FModules.Count-1 do begin
          Module:=FModules.Items[i];
          if Module.Enabled then begin
            for j:=0 to Module.Handlers.Count-1 do begin
              Handler:=Module.Handlers.Items[j];
              if Handler.Enabled then begin
                if not Empty then begin

                  if Trim(NewIP)='' then begin
                    if FServer.Bindings.Items[0].IP<>'0.0.0.0' then
                      NewIP:=FServer.Bindings.Items[0].IP
                    else begin
                      if IPList.Count>0 then
                        NewIP:=IPList[0];
                    end;
                  end;

                  if Trim(NewHost)='' then begin
                    if Handler.Host<>'*' then
                      NewHost:=Handler.Host
                    else begin
                      try
                        NewHost:=GWindowsStack.HostByAddress(NewIP);
                      except
                      end;
                    end;
                  end;

                  with Params do begin
                    Write(Handler.ObjectName,SParamIP,NewIP);
                    Write(Handler.ObjectName,SParamPort,FServer.Bindings.Items[0].Port);
                    Write(Handler.ObjectName,SParamListenIP,FServer.Bindings.Items[0].IP);
                    Write(Handler.ObjectName,SParamHost,NewHost);
                    Write(Handler.ObjectName,SParamPath,Handler.Path);
                    Write(Handler.ObjectName,SParamUseCrypter,Handler.UseCrypter);
                    Write(Handler.ObjectName,SParamCrypterAlgorithm,Handler.CrypterAlgorithm);
                    Write(Handler.ObjectName,SParamCrypterMode,Handler.CrypterMode);
                    Write(Handler.ObjectName,SParamCrypterKey,Handler.CrypterKey);
                    Write(Handler.ObjectName,SParamUseCompressor,Handler.UseCompressor);
                    Write(Handler.ObjectName,SParamCompressorLevel,Handler.CompressorLevel);
                  end;
                end else
                  Params.AddSection(Handler.ObjectName);
              end;
            end;
          end;
        end;
      end;
      Core.ConnectionUpdate(Params);
    finally
      IPList.Free;
      Params.Free;
    end;}
  end;
end; 

{function TBisHttpServer.Whoami(var IP, Host: String): Boolean;
var
  Http: TIdHttp;
  Str: TStringList;
begin
  Result:=false;
  if Trim(FWhoamiUrl)<>'' then begin
    LoggerWrite(FormatEx(FSWhoami,[FWhoamiUrl]));
    try
      Http:=TIdHttp.Create(nil);
      Str:=TStringList.Create;
      try
        Http.Request.UserAgent:='';

        Str.Text:=Http.Get(FWhoamiUrl);
        if Str.Count>0 then begin
          IP:=Trim(Str[0]);
          if Str.Count>1 then
            Host:=Trim(Str[1]);
        end;

        Result:=Trim(IP)<>'';

        if Result then
          LoggerWrite(Trim(Str.Text));
      finally
        Str.Free;
        Http.Free;
      end;
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  end;
end;}

procedure TBisHttpServer.Start;
begin
  LoggerWrite(SStart);
  try
    FModules.Load;
    ConnectionUpdate(false);
    FServer.Active:=true;
    LoggerWrite(SStartSuccess);
  except
    On E: Exception do begin
      LoggerWrite(FormatEx(SStartFail,[E.Message]),ltError);
    end;
  end;
end;

procedure TBisHttpServer.Stop;
begin
  LoggerWrite(SStop);
  try
    try
      ConnectionUpdate(true);
      FServer.Active:=false;
    finally
      FModules.Unload;
    end;
    LoggerWrite(SStopSuccess);
  except
    On E: Exception do begin
      LoggerWrite(FormatEx(SStopFail,[E.Message]),ltError);
    end;
  end;
end;

initialization
  ExceptNotifierIgnores.Add(EIdConnClosedGracefully);

end.
