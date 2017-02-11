unit BisCallPhoneMessages;

interface

uses Classes, Variants, Contnrs,
     BisValues, BisEvents;

type

  TBisCallPhoneAcceptorType=(atPhone,atAccount,atComputer,atSession);

  TBisCallPhoneMessageDirection=(mdIncoming,mdOutgoing);

  TBisCallPhoneMessage=class(TBisValues)
  private
    FName: String;
    FDirection: TBisCallPhoneMessageDirection;
    function GetSessionId: Variant;
    function GetChannelId: String;
    function GetSequence: Integer;
    function GetCallId: Variant;
    function GetRemoteSessionId: Variant;
    function GetDataPort: Integer;
    function GetFormatTag: Word;
    function GetBitsPerSample: Word;
    function GetChannels: Word;
    function GetSamplesPerSec: LongWord;
    function GetDataSize: Word;
    function GetCallerId: Variant;
    function GetCallerPhone: Variant;
    function GetPacketTime: Word;
  public
    constructor Create(Direction: TBisCallPhoneMessageDirection; Name: String; Params: TBisEventParams=nil); virtual;
    destructor Destroy; override;
    procedure CopyFrom(Params: TBisEventParams); virtual;
    function AsString: String; virtual;

    procedure AddSessionId(Value: Variant);
    procedure AddRemoteSessionId(Value: Variant);
    procedure AddChannelId(Value: String);
    procedure AddSequence(Value: Integer);
    procedure AddCallId(Value: Variant);
    procedure AddCallerId(Value: Variant);
    procedure AddCallerPhone(Value: Variant);
    procedure AddDataPort(Value: Integer);
    procedure AddAcceptor(Value: Variant);
    procedure AddAcceptorType(Value: TBisCallPhoneAcceptorType);
    procedure AddCallResultId(Value: Variant);

    property Direction: TBisCallPhoneMessageDirection read FDirection;
    property Name: String read FName;
    property SessionId: Variant read GetSessionId;
    property RemoteSessionId: Variant read GetRemoteSessionId;
    property ChannelId: String read GetChannelId;
    property Sequence: Integer read GetSequence;
    property CallId: Variant read GetCallId;
    property DataPort: Integer read GetDataPort;
    property FormatTag: Word read GetFormatTag;
    property Channels: Word read GetChannels;
    property SamplesPerSec: LongWord read GetSamplesPerSec;
    property BitsPerSample: Word read GetBitsPerSample;
    property DataSize: Word read GetDataSize;
    property PacketTime: Word read GetPacketTime;
    property CallerId: Variant read GetCallerId;
    property CallerPhone: Variant read GetCallerPhone;
  end;

  TBisCallPhoneResponseType=(rtUnknown,rtOK,rtBusy,rtError);

  TBisCallPhoneResponse=class(TBisCallPhoneMessage)
  private
    function GetRequestName: String;
    function GetResponseType: TBisCallPhoneResponseType;
    function GetMessage: String;
  public
    function Same(const RequestName: String): Boolean;

    procedure AddRequestName(Value: String);
    procedure AddResponseType(Value: TBisCallPhoneResponseType);
    procedure AddMessage(Value: String);

    property RequestName: String read GetRequestName;
    property ResponseType: TBisCallPhoneResponseType read GetResponseType;
    property Message: String read GetMessage;
  end;

  TBisCallPhoneResponses=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisCallPhoneResponse;
  public
    property Items[Index: Integer]: TBisCallPhoneResponse read GetItem; default;
  end;

  TBisCallPhoneRequest=class(TBisCallPhoneMessage)
  private
    FResponses: TBisCallPhoneResponses;
  public
    constructor Create(Direction: TBisCallPhoneMessageDirection; Name: String; Params: TBisEventParams=nil); override;
    destructor Destroy; override;

    property Responses: TBisCallPhoneResponses read FResponses;
  end;

  TBisCallPhoneRequests=class(TObjectList)
  private
    FSequence: Integer;
    function GetItem(Index: Integer): TBisCallPhoneRequest;
  public
    function Find(Response: TBisCallPhoneResponse): TBisCallPhoneRequest;
    function NextSequence: Integer;

    property Items[Index: Integer]: TBisCallPhoneRequest read GetItem; default;
    property Sequence: Integer read FSequence;
  end;


implementation


uses SysUtils,
     BisUtils, BisConfig;

{ TBisCallPhoneMessage }

constructor TBisCallPhoneMessage.Create(Direction: TBisCallPhoneMessageDirection; Name: String; Params: TBisEventParams);
begin
  inherited Create;
  FDirection:=Direction;
  FName:=Name;
  CopyFrom(Params);
end;

destructor TBisCallPhoneMessage.Destroy;
begin
  inherited Destroy;
end;

procedure TBisCallPhoneMessage.CopyFrom(Params: TBisEventParams);
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

function TBisCallPhoneMessage.AsString: String;
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

function TBisCallPhoneMessage.GetCallId: Variant;
begin
  Result:=GetValue('CallId');
end;

function TBisCallPhoneMessage.GetChannelId: String;
begin
  Result:=VarToStrDef(GetValue('ChannelId'),'');
end;

function TBisCallPhoneMessage.GetDataPort: Integer;
begin
  Result:=VarToIntDef(GetValue('DataPort'),0);
end;

function TBisCallPhoneMessage.GetRemoteSessionId: Variant;
begin
  Result:=GetValue('RemoteSessionId');
end;

function TBisCallPhoneMessage.GetSessionId: Variant;
begin
  Result:=GetValue('SessionId');
end;

function TBisCallPhoneMessage.GetSequence: Integer;
begin
  Result:=VarToIntDef(GetValue('Sequence'),0);
end;

function TBisCallPhoneMessage.GetFormatTag: Word;
begin
  Result:=VarToIntDef(GetValue('FormatTag'),0);
end;

function TBisCallPhoneMessage.GetPacketTime: Word;
begin
  Result:=VarToIntDef(GetValue('PacketTime'),0);
end;

function TBisCallPhoneMessage.GetChannels: Word;
begin
  Result:=VarToIntDef(GetValue('Channels'),0);
end;

function TBisCallPhoneMessage.GetSamplesPerSec: LongWord;
begin
  Result:=VarToIntDef(GetValue('SamplesPerSec'),0);
end;

function TBisCallPhoneMessage.GetBitsPerSample: Word;
begin
  Result:=VarToIntDef(GetValue('BitsPerSample'),0);
end;

function TBisCallPhoneMessage.GetDataSize: Word;
begin
  Result:=VarToIntDef(GetValue('DataSize'),0);
end;

function TBisCallPhoneMessage.GetCallerId: Variant;
begin
  Result:=GetValue('CallerId');
end;

function TBisCallPhoneMessage.GetCallerPhone: Variant;
begin
  Result:=GetValue('CallerPhone');
end;

procedure TBisCallPhoneMessage.AddCallId(Value: Variant);
begin
  Add('CallId',Value);
end;

procedure TBisCallPhoneMessage.AddCallResultId(Value: Variant);
begin
  Add('CallResultId',Value);
end;

procedure TBisCallPhoneMessage.AddCallerId(Value: Variant);
begin
  Add('CallerId',Value);
end;

procedure TBisCallPhoneMessage.AddCallerPhone(Value: Variant);
begin
  Add('CallerPhone',Value);
end;

procedure TBisCallPhoneMessage.AddChannelId(Value: String);
begin
  Add('ChannelId',Value);
end;

procedure TBisCallPhoneMessage.AddDataPort(Value: Integer);
begin
  Add('DataPort',Value);
end;

procedure TBisCallPhoneMessage.AddRemoteSessionId(Value: Variant);
begin
  Add('RemoteSessionId',Value);
end;

procedure TBisCallPhoneMessage.AddSequence(Value: Integer);
begin
  Add('Sequence',Value);
end;

procedure TBisCallPhoneMessage.AddSessionId(Value: Variant);
begin
  Add('SessionId',Value);
end;

{procedure TBisCallPhoneMessage.AddFormatTag(Value: Word);
begin
  Add('FormatTag',Value);
end;


procedure TBisCallPhoneMessage.AddChannels(Value: Word);
begin
  Add('Channels',Value);
end;

procedure TBisCallPhoneMessage.AddSamplesPerSec(Value: LongWord);
begin
  Add('SamplesPerSec',Value);
end;

procedure TBisCallPhoneMessage.AddBitsPerSample(Value: Word);
begin
  Add('BitsPerSample',Value);
end;

procedure TBisCallPhoneMessage.AddDataSize(Value: Integer);
begin
  Add('DataSize',Value);
end;}

procedure TBisCallPhoneMessage.AddAcceptor(Value: Variant);
begin
  Add('Acceptor',Value);
end;

procedure TBisCallPhoneMessage.AddAcceptorType(Value: TBisCallPhoneAcceptorType);
begin
  Add('AcceptorType',Value);
end;

{ TBisCallPhoneResponse }

procedure TBisCallPhoneResponse.AddMessage(Value: String);
begin
  Add('Message',Value);
end;

procedure TBisCallPhoneResponse.AddRequestName(Value: String);
begin
  Add('RequestName',Value);
end;

procedure TBisCallPhoneResponse.AddResponseType(Value: TBisCallPhoneResponseType);
begin
  Add('ResponseType',Integer(Value));
end;

function TBisCallPhoneResponse.GetMessage: String;
begin
  Result:=VarToStrDef(GetValue('Message'),'');
end;

function TBisCallPhoneResponse.GetRequestName: String;
begin
  Result:=VarToStrDef(GetValue('RequestName'),'');
end;

function TBisCallPhoneResponse.GetResponseType: TBisCallPhoneResponseType;
begin
  Result:=TBisCallPhoneResponseType(VarToIntDef(GetValue('ResponseType'),Integer(rtUnknown)));
end;

function TBisCallPhoneResponse.Same(const RequestName: String): Boolean;
begin
  Result:=AnsiSameText(RequestName,GetRequestName);
end;

{ TBisCallPhoneResponses }

function TBisCallPhoneResponses.GetItem(Index: Integer): TBisCallPhoneResponse;
begin
  Result:=TBisCallPhoneResponse(inherited Items[Index]);
end;

{ TBisCallPhoneRequest }

constructor TBisCallPhoneRequest.Create(Direction: TBisCallPhoneMessageDirection; Name: String; Params: TBisEventParams=nil);
begin
  inherited Create(Direction,Name,Params);
  FResponses:=TBisCallPhoneResponses.Create;
end;

destructor TBisCallPhoneRequest.Destroy;
begin
  FResponses.Free;
  inherited Destroy;
end;

{ TBisCallPhoneRequests }

function TBisCallPhoneRequests.Find(Response: TBisCallPhoneResponse): TBisCallPhoneRequest;
var
  i: Integer;
  Item: TBisCallPhoneRequest;
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

function TBisCallPhoneRequests.GetItem(Index: Integer): TBisCallPhoneRequest;
begin
  Result:=TBisCallPhoneRequest(inherited Items[Index]);
end;

function TBisCallPhoneRequests.NextSequence: Integer;
begin
  Inc(FSequence);
  Result:=FSequence;
end;


end.