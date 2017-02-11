unit BisCallServerEventMessages;

interface

uses Classes, Contnrs,
     BisValues, BisEvents,
     BisCallServerChannels;

type
  TBisCallServerEventMessageDirection=(mdIncoming,mdOutgoing);

  TBisCallServerEventMessage=class(TBisValues)
  private
    FName: String;
    FDirection: TBisCallServerEventMessageDirection;
    function GetSessionId: Variant;
    function GetChannelId: String;
    function GetSequence: Integer;
    function GetCallId: Variant;
    function GetCallResultId: Variant;
    function GetRemoteSessionId: Variant;
    function GetDataPort: Integer;
    function GetBitsPerSample: Word;
    function GetChannels: Word;
    function GetFormatTag: Word;
    function GetSamplesPerSec: LongWord;
    function GetDataSize: Integer;
    function GetCallerId: Variant;
    function GetCallerPhone: Variant;
    function GetAcceptor: Variant;
    function GetAcceptorType: TBisCallServerChannelAcceptorType;
  public
    constructor Create(Direction: TBisCallServerEventMessageDirection; Name: String; Params: TBisEventParams=nil); virtual;
    destructor Destroy; override;
    procedure CopyFrom(Params: TBisEventParams);
    function AsString: String; virtual;

    procedure AddSessionId(Value: Variant);
    procedure AddRemoteSessionId(Value: Variant);
    procedure AddChannelId(Value: String);
    procedure AddSequence(Value: Integer);
    procedure AddCallId(Value: Variant);
    procedure AddCallerId(Value: Variant);
    procedure AddCallerPhone(Value: Variant);
    procedure AddDataPort(Value: Integer);
    procedure AddFormatTag(Value: Word);
    procedure AddChannels(Value: Word);
    procedure AddSamplesPerSec(Value: LongWord);
    procedure AddBitsPerSample(Value: Word);
    procedure AddDataSize(Value: Word);
    procedure AddPacketTime(Value: Word);

    property Name: String read FName;
    property SessionId: Variant read GetSessionId;
    property RemoteSessionId: Variant read GetRemoteSessionId;
    property ChannelId: String read GetChannelId;
    property Sequence: Integer read GetSequence;
    property CallId: Variant read GetCallId;
    property CallResultId: Variant read GetCallResultId; 
    property CallerId: Variant read GetCallerId;
    property CallerPhone: Variant read GetCallerPhone;
    property DataPort: Integer read GetDataPort;
    property FormatTag: Word read GetFormatTag;
    property Channels: Word read GetChannels;
    property SamplesPerSec: LongWord read GetSamplesPerSec;
    property BitsPerSample: Word read GetBitsPerSample;
    property DataSize: Integer read GetDataSize;
    property Acceptor: Variant read GetAcceptor;
    property AcceptorType: TBisCallServerChannelAcceptorType read GetAcceptorType;  
  end;

  TBisCallServerEventResponseType=(rtUnknown,rtOK,rtBusy,rtError);

  TBisCallServerEventResponse=class(TBisCallServerEventMessage)
  private
    function GetRequestName: String;
    function GetMessage: String;
    function GetResponseType: TBisCallServerEventResponseType;
  public
    procedure AddRequestName(Value: String);
    procedure AddResponseType(Value: TBisCallServerEventResponseType);
    procedure AddMessage(Value: String);

    property RequestName: String read GetRequestName;
    property ResponseType: TBisCallServerEventResponseType read GetResponseType;
    property Message: String read GetMessage;
  end;

  TBisCallServerEventResponses=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisCallServerEventResponse;
  public
    property Items[Index: Integer]: TBisCallServerEventResponse read GetItem; default;
  end;

  TBisCallServerEventRequest=class(TBisCallServerEventMessage)
  private
    FResponses: TBisCallServerEventResponses;
  public
    constructor Create(Direction: TBisCallServerEventMessageDirection; Name: String; Params: TBisEventParams=nil); override;
    destructor Destroy; override;

    property Responses: TBisCallServerEventResponses read FResponses;
  end;

  TBisCallServerEventRequests=class(TObjectList)
  private
    FSequence: Integer;
    function GetItem(Index: Integer): TBisCallServerEventRequest;
  public
    function Find(Response: TBisCallServerEventResponse): TBisCallServerEventRequest;
    function NextSequence: Integer;

    property Items[Index: Integer]: TBisCallServerEventRequest read GetItem; default;
    property Sequence: Integer read FSequence;
  end;


implementation

uses SysUtils, Variants,
     BisUtils, BisConfig;

{ TBisCallServerEventMessage }

constructor TBisCallServerEventMessage.Create(Direction: TBisCallServerEventMessageDirection; Name: String; Params: TBisEventParams=nil);
begin
  inherited Create;
  FName:=Name;
  FDirection:=Direction;
  CopyFrom(Params);
end;

destructor TBisCallServerEventMessage.Destroy;
begin
  inherited Destroy;
end;

procedure TBisCallServerEventMessage.CopyFrom(Params: TBisEventParams);
var
  i: Integer;
  Param: TBisEventParam;
  V: Variant;
  S: String;
begin
  if Assigned(Params) then begin
    Clear;
    for i:=0 to Params.Count-1 do begin
      Param:=Params[i];
      if not VarIsNull(Param.Value) then begin
        V:=Param.Value;
        case VarType(V) of
          varOleStr,varString: begin
            S:=VarToStrDef(V,'');
            if S='' then
              V:=Null;
          end;
        end;
      end else
        V:=Null;
      Add(Param.Name,V);
    end;
  end;
end;

function TBisCallServerEventMessage.AsString: String;
var
  Config: TBisConfig;
  i: Integer;
  Item: TBisValue;
begin
  Result:='';
  if Trim(FName)<>'' then begin
    Config:=TBisConfig.Create(nil);
    try
      for i:=0 to Count-1 do begin
        Item:=Items[i];
        Config.Write(FName,Item.Name,Item.Value);
      end;
      Result:=Trim(Config.Text);
    finally
      Config.Free;
    end;
  end;
end;

function TBisCallServerEventMessage.GetCallId: Variant;
begin
  Result:=GetValue('CallId');
end;

function TBisCallServerEventMessage.GetCallResultId: Variant;
begin
  Result:=GetValue('CallResultId');
end;

function TBisCallServerEventMessage.GetCallerId: Variant;
begin
  Result:=GetValue('CallerId');
end;

function TBisCallServerEventMessage.GetCallerPhone: Variant;
begin
  Result:=GetValue('CallerPhone');
end;

function TBisCallServerEventMessage.GetChannelId: String;
begin
  Result:=VarToStrDef(GetValue('ChannelId'),'');
end;

function TBisCallServerEventMessage.GetDataPort: Integer;
begin
  Result:=VarToIntDef(GetValue('DataPort'),0);
end;

function TBisCallServerEventMessage.GetRemoteSessionId: Variant;
begin
  Result:=GetValue('RemoteSessionId');
end;

function TBisCallServerEventMessage.GetSessionId: Variant;
begin
  Result:=GetValue('SessionId');
end;

function TBisCallServerEventMessage.GetSequence: Integer;
begin
  Result:=VarToIntDef(GetValue('Sequence'),0);
end;

function TBisCallServerEventMessage.GetFormatTag: Word;
begin
  Result:=VarToIntDef(GetValue('FormatTag'),0);
end;

function TBisCallServerEventMessage.GetChannels: Word;
begin
  Result:=VarToIntDef(GetValue('Channels'),0);
end;

function TBisCallServerEventMessage.GetSamplesPerSec: LongWord;
begin
  Result:=VarToIntDef(GetValue('SamplesPerSec'),0);
end;

function TBisCallServerEventMessage.GetBitsPerSample: Word;
begin
  Result:=VarToIntDef(GetValue('BitsPerSample'),0);
end;

function TBisCallServerEventMessage.GetDataSize: Integer;
begin
  Result:=VarToIntDef(GetValue('DataSize'),0);
end;

function TBisCallServerEventMessage.GetAcceptor: Variant;
begin
  Result:=GetValue('Acceptor');
end;

function TBisCallServerEventMessage.GetAcceptorType: TBisCallServerChannelAcceptorType;
begin
  Result:=TBisCallServerChannelAcceptorType(VarToIntDef(GetValue('AcceptorType'),Integer(catPhone)));
end;

procedure TBisCallServerEventMessage.AddCallId(Value: Variant);
begin
  Add('CallId',Value);
end;

procedure TBisCallServerEventMessage.AddCallerId(Value: Variant);
begin
  Add('CallerId',Value);
end;

procedure TBisCallServerEventMessage.AddCallerPhone(Value: Variant);
begin
  Add('CallerPhone',Value);
end;

procedure TBisCallServerEventMessage.AddChannelId(Value: String);
begin
  Add('ChannelId',Value);
end;

procedure TBisCallServerEventMessage.AddDataPort(Value: Integer);
begin
  Add('DataPort',Value);
end;

procedure TBisCallServerEventMessage.AddRemoteSessionId(Value: Variant);
begin
  Add('RemoteSessionId',Value);
end;

procedure TBisCallServerEventMessage.AddSequence(Value: Integer);
begin
  Add('Sequence',Value);
end;

procedure TBisCallServerEventMessage.AddSessionId(Value: Variant);
begin
  Add('SessionId',Value);
end;

procedure TBisCallServerEventMessage.AddFormatTag(Value: Word);
begin
  Add('FormatTag',Value);
end;

procedure TBisCallServerEventMessage.AddChannels(Value: Word);
begin
  Add('Channels',Value);
end;

procedure TBisCallServerEventMessage.AddSamplesPerSec(Value: LongWord);
begin
  Add('SamplesPerSec',Value);
end;

procedure TBisCallServerEventMessage.AddBitsPerSample(Value: Word);
begin
  Add('BitsPerSample',Value);
end;

procedure TBisCallServerEventMessage.AddDataSize(Value: Word);
begin
  Add('DataSize',Value);
end;

procedure TBisCallServerEventMessage.AddPacketTime(Value: Word);
begin
  Add('PacketTime',Value);
end;

{ TBisCallServerEventResponse }

function TBisCallServerEventResponse.GetMessage: String;
begin
  Result:=VarToStrDef(GetValue('Message'),'');
end;

function TBisCallServerEventResponse.GetRequestName: String;
begin
  Result:=VarToStrDef(GetValue('RequestName'),'');
end;

function TBisCallServerEventResponse.GetResponseType: TBisCallServerEventResponseType;
begin
  Result:=TBisCallServerEventResponseType(VarToIntDef(GetValue('ResponseType'),Integer(rtUnknown)));
  if not (Result in [rtOK,rtBusy,rtError]) then
    Result:=rtUnknown;
end;

procedure TBisCallServerEventResponse.AddResponseType(Value: TBisCallServerEventResponseType);
begin
  Add('ResponseType',Integer(Value));
end;

procedure TBisCallServerEventResponse.AddMessage(Value: String);
begin
  Add('Message',Value);
end;

procedure TBisCallServerEventResponse.AddRequestName(Value: String);
begin
  Add('RequestName',Value);
end;

{ TBisCallServerEventResponses }

function TBisCallServerEventResponses.GetItem(Index: Integer): TBisCallServerEventResponse;
begin
  Result:=TBisCallServerEventResponse(inherited Items[Index]);
end;

{ TBisCallServerEventRequest }

constructor TBisCallServerEventRequest.Create(Direction: TBisCallServerEventMessageDirection; Name: String; Params: TBisEventParams=nil); 
begin
  inherited Create(Direction,Name,Params);
  FResponses:=TBisCallServerEventResponses.Create;
end;

destructor TBisCallServerEventRequest.Destroy;
begin
  FResponses.Free;
  inherited Destroy;
end;

{ TBisCallServerEventRequests }

function TBisCallServerEventRequests.Find(Response: TBisCallServerEventResponse): TBisCallServerEventRequest;
var
  i: Integer;
  Item: TBisCallServerEventRequest;
begin
  Result:=nil;
  if Assigned(Response) then begin
    for i:=Count-1 downto 0 do begin
      Item:=Items[i];
      if AnsiSameText(Item.Name,Response.RequestName) and
         (Item.Sequence=Response.Sequence) then begin
        Result:=Item;
        exit;
      end;
    end;
  end;
end;

function TBisCallServerEventRequests.GetItem(Index: Integer): TBisCallServerEventRequest;
begin
  Result:=TBisCallServerEventRequest(inherited Items[Index]);
end;

function TBisCallServerEventRequests.NextSequence: Integer;
begin
  Inc(FSequence);
  Result:=FSequence;
end;

end.
