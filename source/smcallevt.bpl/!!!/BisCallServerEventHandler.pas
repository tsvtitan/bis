unit BisCallServerEventHandler;

interface

uses Windows, Classes, ZLib,
     IdGlobal, IdSocketHandle, IdUDPServer,
     BisEvents, BisCrypter,
     BisCallServerHandlerModules, BisCallServerHandlers,
     BisCallServerChannels;

type
  TBisCallServerEventHandler=class;

  TBisCallServerEventChannels=class;

  TBisCallServerEventChannel=class(TBisCallServerChannel)
  private
    FHandler: TBisCallServerEventHandler;
    FLocalServer: TIdUDPServer;

    FRemoteServerSessionId: String;
    FRemoteServerPort: Integer;
    FRemoteServerDataPort: Integer;
    FRemoteServerHost: String;
    FRemoteServerUseCrypter: Boolean;
    FRemoteServerCrypterKey: String;
    FRemoteServerCrypterAlgorithm: TBisCipherAlgorithm;
    FRemoteServerCrypterMode: TBisCipherMode;
    FRemoteServerUseCompressor: Boolean;
    FRemoteServerCompressorLevel: TCompressionLevel;

    procedure LocalServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure SetParams(InParams: TBisEventParams);
    function EncodeString(Key, S: String; Algorithm: TBisCipherAlgorithm; Mode: TBisCipherMode): String;
    function CompressString(S: String; Level: TCompressionLevel): String;
    function SendEvent(Event: TBisEvent; InParams: TBisEventParams): Boolean;
    procedure InviteResponse(Success: Boolean; Error: String);
    procedure CancelResponse(Success: Boolean);
  protected
    function GetActive: Boolean; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  {  procedure Open; override;
    procedure Close; override;}
  end;

  TBisCallServerEventChannels=class(TBisCallServerChannels)
  private
    FHandler: TBisCallServerEventHandler;
    function GetItem(Index: Integer): TBisCallServerEventChannel;
  public
    function Add(Id: String): TBisCallServerEventChannel; reintroduce;
    function Find(Id: String): TBisCallServerEventChannel; reintroduce;

    property Items[Index: Integer]: TBisCallServerEventChannel read GetItem; default;
  end;

  TBisCallServerEventHandler=class(TBisCallServerHandler)
  private
    FLock: TRTLCriticalSection;
    FEventResult: TBisEvent;
    FEventInvite: TBisEvent;
    FEventCancel: TBisEvent;

    function EventHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function GetChannels: TBisCallServerEventChannels;
    procedure Lock;
    procedure UnLock;
  protected
    function GetChannelsClass: TBisCallServerChannelsClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
//    function CanInvite(Contact: String): Boolean; override;
//    procedure Invite(SessionId, LineId, Contact: String); override;

    property Channels: TBisCallServerEventChannels read GetChannels;
  end;

procedure InitCallServerHandlerModule(AModule: TBisCallServerHandlerModule); stdcall;

exports
  InitCallServerHandlerModule;

implementation

uses SysUtils, Variants, DB,
     IdUDPClient,
     BisCore, BisProvider, BisFilterGroups, BisUtils, BisConfig,
     BisCallServerEventHandlerConsts;

procedure InitCallServerHandlerModule(AModule: TBisCallServerHandlerModule); stdcall;
begin
  AModule.HandlerClass:=TBisCallServerEventHandler;
end;

{ TBisCallServerEventChannel }

constructor TBisCallServerEventChannel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLocalServer:=TIdUDPServer.Create(nil);
  FLocalServer.ThreadedEvent:=true;
  FLocalServer.OnUDPRead:=LocalServerUDPRead;
end;

destructor TBisCallServerEventChannel.Destroy;
begin
//  Close;
  FLocalServer.Free;
  inherited Destroy;
end;

function TBisCallServerEventChannel.GetActive: Boolean;
begin
  Result:=FLocalServer.Active and (FLocalServer.Bindings.Count=1);
end;

procedure TBisCallServerEventChannel.InviteResponse(Success: Boolean; Error: String);
var
  InParams: TBisEventParams;
begin
  if Active then begin
    InParams:=TBisEventParams.Create;
    try
      InParams.Add('SessionId',FRemoteServerSessionId);
//      InParams.Add('Id',Id);
      InParams.Add('Event',FHandler.FEventInvite.Name);
      InParams.Add('DataPort',FLocalServer.Bindings[0].Port);
      InParams.Add('Success',Success);
      InParams.Add('Error',Error);
      SendEvent(FHandler.FEventResult,InParams);
    finally
      InParams.Free;
    end;
  end;
end;

procedure TBisCallServerEventChannel.CancelResponse(Success: Boolean);
var
  InParams: TBisEventParams;
begin
  if Active then begin
    InParams:=TBisEventParams.Create;
    try
      InParams.Add('SessionId',FRemoteServerSessionId);
//      InParams.Add('Id',Id);
      InParams.Add('Event',FHandler.FEventCancel.Name);
      InParams.Add('Success',Success);
      SendEvent(FHandler.FEventResult,InParams);
    finally
      InParams.Free;
    end;
  end;
end;

procedure TBisCallServerEventChannel.SetParams(InParams: TBisEventParams);
begin
  if Assigned(InParams) then begin
    FRemoteServerSessionId:=VarToStrDef(InParams.Value['RemoteSessionId'],'');
    FRemoteServerHost:=VarToStrDef(InParams.Value['Host'],'');
    FRemoteServerPort:=VarToIntDef(InParams.Value['Port'],0);
    FRemoteServerDataPort:=VarToIntDef(InParams.Value['DataPort'],0);
    FRemoteServerUseCrypter:=Boolean(VarToIntDef(InParams.Value['UseCrypter'],0));
    FRemoteServerCrypterKey:=VarToStrDef(InParams.Value['CrypterKey'],'');
    FRemoteServerCrypterAlgorithm:=TBisCipherAlgorithm(VarToIntDef(InParams.Value['CrypterAlgorithm'],0));
    FRemoteServerCrypterMode:=TBisCipherMode(VarToIntDef(InParams.Value['CrypterMode'],0));
    FRemoteServerUseCompressor:=Boolean(VarToIntDef(InParams.Value['UseCompressor'],0));
    FRemoteServerCompressorLevel:=TCompressionLevel(VarToIntDef(InParams.Value['CompressorLevel'],0));
//    CreatorId:=VarToStrDef(InParams.Value['CreatorId'],'');
{    CallType:=TBisCallServerChannelCallType(VarToIntDef(InParams.Value['CallType'],0));
    CallerId:=VarToStrDef(InParams.Value['CallerId'],'');
    CallerPhone:=VarToStrDef(InParams.Value['CallerPhone'],'');
    Acceptor:=VarToStrDef(InParams.Value['Acceptor'],'');
    AcceptorType:=TBisCallServerChannelAcceptorType(VarToIntDef(InParams.Value['AcceptorType'],0));}
  end;
end;

function TBisCallServerEventChannel.EncodeString(Key, S: String; Algorithm: TBisCipherAlgorithm; Mode: TBisCipherMode): String;
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

function TBisCallServerEventChannel.CompressString(S: String; Level: TCompressionLevel): String;
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

function TBisCallServerEventChannel.SendEvent(Event: TBisEvent; InParams: TBisEventParams): Boolean;
var
  Udp: TIdUDPClient;
  Config: TBisConfig;
  S: String;
  i: Integer;
  Param: TBisEventParam;
begin
  Result:=false;
  if Assigned(InParams) then begin
    Udp:=TIdUDPClient.Create(nil);
    Config:=TBisConfig.Create(nil);
    try
      for i:=0 to InParams.Count-1 do begin
        Param:=InParams.Items[i];
        Config.Write(Event.Name,Param.Name,Param.AsString);
      end;
      S:=Trim(Config.Text);

      if FRemoteServerUseCompressor then
        S:=CompressString(S,FRemoteServerCompressorLevel);

      if FRemoteServerUseCrypter then
        S:=EncodeString(FRemoteServerCrypterKey,S,
                        FRemoteServerCrypterAlgorithm,FRemoteServerCrypterMode);

      Udp.Host:=FRemoteServerHost;
      Udp.Port:=FRemoteServerPort;
      Udp.BufferSize:=Length(S);
      Udp.Connect;
      Udp.Send(S);
      Result:=true;
    finally
      Config.Free;
      Udp.Free;
    end;
  end;
end;

{procedure TBisCallServerEventChannel.Close;
begin
  if Active then begin
    FLocalServer.Active:=false;
    FLocalServer.Bindings.Clear;
  end;
end;}

{procedure TBisCallServerEventChannel.Open;
var
  LocalListenIP: String;
  LocalPort: Integer;

  function GetEventParams: Boolean;
  var
    P: TBisProvider;
  begin
    Result:=false;
    if not Result then begin
      P:=TBisProvider.Create(nil);
      try
        P.WithWaitCursor:=false;
        P.ProviderName:='GET_EVENT_PARAMS';
        with P.Params do begin
          AddInvisible('LISTEN_IP',ptOutput);
          AddInvisible('PORT',ptOutput);
        end;
        P.Execute;
        if P.Success then begin
          LocalListenIP:=P.ParamByName('LISTEN_IP').AsString;
          LocalPort:=P.ParamByName('PORT').AsInteger;
          
          Result:=Trim(LocalListenIP)<>'';
        end;
      finally
        P.Free;
      end;
    end;
  end;

var
  SocketHandle: TIdSocketHandle;
  MaxPort: Integer;
  i: Integer;
begin
  if not Active then begin
    if GetEventParams then begin
      SocketHandle:=FLocalServer.Bindings.Add;
      SocketHandle.IP:=LocalListenIP;
      MaxPort:=POWER_2;
      for i:=LocalPort+1 to MaxPort do begin
        try
          SocketHandle.Port:=i;
          FLocalServer.Active:=true;
          break;
        except
          on E: Exception do begin
            FLocalServer.Active:=false;
          end;
        end;
      end;
    end;
  end;
end;}

procedure TBisCallServerEventChannel.LocalServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
begin
//  FLocalServer.se
end;

{ TBisCallServerEventChannels }

function TBisCallServerEventChannels.Add(Id: String): TBisCallServerEventChannel;
begin
{  Result:=TBisCallServerEventChannel(AddClass(TBisCallServerEventChannel,Id));
  if Assigned(Result) then
    Result.FHandler:=FHandler;}
end;

function TBisCallServerEventChannels.Find(Id: String): TBisCallServerEventChannel;
begin
  Result:=TBisCallServerEventChannel(inherited Find(Id));
end;

function TBisCallServerEventChannels.GetItem(Index: Integer): TBisCallServerEventChannel;
begin
  Result:=TBisCallServerEventChannel(inherited Items[Index]);
end;

{ TBisCallServerEventHandler }

constructor TBisCallServerEventHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Channels.FHandler:=Self;
  InitializeCriticalSection(FLock);
  with Core.Events do begin
    FEventResult:=Add('065EEAC4562FAC03419F3F467152C71B',EventHandler,true);
    FEventInvite:=Add('A6F419FB25B7BDB94FEEA83F5BDE0B95',EventHandler,true);
    FEventCancel:=Add('124114A766D3AC904F928682F88E585A',EventHandler,true);
  end;
end;

destructor TBisCallServerEventHandler.Destroy;
begin
  with Core.Events do begin
    Remove(FEventCancel);
    Remove(FEventInvite);
    Remove(FEventResult);
  end;
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

function TBisCallServerEventHandler.GetChannels: TBisCallServerEventChannels;
begin
  Result:=TBisCallServerEventChannels(inherited Channels);
end;

function TBisCallServerEventHandler.GetChannelsClass: TBisCallServerChannelsClass;
begin
  Result:=TBisCallServerEventChannels;
end;

procedure TBisCallServerEventHandler.Lock;
begin
  EnterCriticalSection(FLock);
end;

procedure TBisCallServerEventHandler.UnLock;
begin
  LeaveCriticalSection(FLock);
end;

{function TBisCallServerEventHandler.CanInvite(Contact: String): Boolean;
begin
  Result:=inherited CanInvite(Contact);
  if not Result then
    Result:=Length(Trim(Contact))=Length(GetUniqueID);
end;}

function TBisCallServerEventHandler.EventHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Channel: TBisCallServerEventChannel;
  Id: String;
  AName: String;
  Error: String;
begin
  Lock;
  try
    Result:=false;
    AName:=VarToStrDef(InParams.Value['Name'],'');
    if AnsiSameText(AName,ObjectName) then begin
      Id:=VarToStrDef(InParams.Value['Id'],'');
      if Event=FEventInvite then begin
        Channel:=Channels.Find(Id);
        if not Assigned(Channel) then begin
          Channel:=Channels.Add(Id);
          if Assigned(Channel) then begin
//            Channel.Close;
            Channel.SetParams(InParams);
//            Channel.Open;
            if Channel.Active then begin
              try
                Error:='';
                try
//                  Result:=Channel.DoInvite;
                  Sleep(2000);
          //        raise Exception.Create('Нет доступных линий.');
                except
                  On E: Exception do begin
                    Error:=E.Message;
                  end;
                end;
              finally
                Channel.InviteResponse(Result,Error);
              end;
            end;
          end;
        end;
      end;
      if Event=FEventCancel then begin
        Channel:=Channels.Find(Id);
        if Assigned(Channel) then begin
          if Channel.Active then begin
//            Result:=Channel.DoCancel;
            Channel.CancelResponse(Result);
            Channels.Remove(Channel);
          end;
        end;
      end;
    end;
  finally
    UnLock;
  end;
end;

{procedure TBisCallServerEventHandler.Invite(Contact: String);
begin
  inherited Invite(Contact);

end;}

end.
