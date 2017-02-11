unit BisCallServerHandlers;

interface

uses Classes, Contnrs,
     BisObject, BisCoreObjects, BisDataSet, BisVariants,
     BisCallServerChannels;

type
  TBisCallServerHandler=class;

  TBisCallServerHandlers=class;

  TBisCallServerHandlerLocation=(hlUnknown,hlInternal,hlExternal);

  TBisCallServerHandler=class(TBisCoreObject)
  private
    FParams: TBisDataSet;
    FOperatorIds: TBisVariants;
    FEnabled: Boolean;
    FChannels: TBisCallServerChannels;
    FLocation: TBisCallServerHandlerLocation;
    FVolume: Integer;
  protected
    function GetChannelsClass: TBisCallServerChannelsClass; virtual;
    function GetBusy: Boolean; virtual;
    function GetConnected: Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure Connect; virtual;
    procedure Disconnect; virtual;
    function AddOutgoingChannel(CallId,CallerId,CallerPhone: Variant): TBisCallServerChannel; virtual;

    property Params: TBisDataSet read FParams;
    property Channels: TBisCallServerChannels read FChannels;
    property Location: TBisCallServerHandlerLocation read FLocation;
    property OperatorIds: TBisVariants read FOperatorIds;
    property Volume: Integer read FVolume;
    property Connected: Boolean read GetConnected; 
    property Busy: Boolean read GetBusy;

    property Enabled: Boolean read FEnabled write FEnabled;
  end;

  TBisCallServerHandlerClass=class of TBisCallServerHandler;

  TBisCallServerHandlersCreateEvent=procedure (Handlers: TBisCallServerHandlers; Handler: TBisCallServerHandler) of object;
  TBisCallServerHandlersDestroyEvent=procedure (Handlers: TBisCallServerHandlers; Handler: TBisCallServerHandler) of object;

  TBisCallServerHandlers=class(TBisCoreObjects)
  private
    FOnCreateHandler: TBisCallServerHandlersCreateEvent;
    FOnDestroyHandler: TBisCallServerHandlersDestroyEvent;
    function GetItem(Index: Integer): TBisCallServerHandler;
  protected
    function GetObjectClass: TBisObjectClass; override;
    procedure RemoveNotify(Obj: TBisObject); override;
    procedure DoCreateHandler(Handler: TBisCallServerHandler); virtual;
    procedure DoDestroyHandler(Handler: TBisCallServerHandler); virtual;
  public
    destructor Destroy; override;


    function AddClass(AClass: TBisCallServerHandlerClass; const ObjectName: String=''): TBisCallServerHandler;
    function AddHandler(Handler: TBisCallServerHandler): Boolean;
    procedure Remove(Handler: TBisCallServerHandler);
    procedure Connect;
    procedure Disconnect;
    procedure GetHandlers(Location: TBisCallServerHandlerLocation; OperatorId: Variant; Handlers: TObjectList);

    property Items[Index: Integer]: TBisCallServerHandler read GetItem; default;

    property OnCreateHandler: TBisCallServerHandlersCreateEvent read FOnCreateHandler write FOnCreateHandler;
    property OnDestroyHandler: TBisCallServerHandlersDestroyEvent read FOnDestroyHandler write FOnDestroyHandler;
  end;


implementation

uses SysUtils, Variants,
     BisUtils, BisConsts,
     BisCallServerConsts;

{ TBisCallServerHandler }

constructor TBisCallServerHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParams:=TBisDataSet.Create(nil);
  FChannels:=GetChannelsClass.Create(Self);
  FOperatorIds:=TBisVariants.Create;
end;

destructor TBisCallServerHandler.Destroy;
begin
  FOperatorIds.Free;
  FChannels.Free;
  FParams.Free;
  inherited Destroy;
end;

procedure TBisCallServerHandler.Disconnect;
begin
  //
end;

procedure TBisCallServerHandler.Connect;
begin
  //
end;

function TBisCallServerHandler.AddOutgoingChannel(CallId,CallerId,CallerPhone: Variant): TBisCallServerChannel;
begin
  Result:=nil;
end;

function TBisCallServerHandler.GetBusy: Boolean;
begin
  Result:=false;
end;

function TBisCallServerHandler.GetChannelsClass: TBisCallServerChannelsClass;
begin
  Result:=TBisCallServerChannels;
end;

function TBisCallServerHandler.GetConnected: Boolean;
begin
  Result:=false;
end;

procedure TBisCallServerHandler.Init;
var
  N: String;
  V: String;
  Strings: TStringList;
  i: Integer;
begin
  inherited Init;
  if FParams.Active and not FParams.Empty then begin
    FParams.First;
    while not FParams.Eof do begin
      N:=FParams.FieldByName(SFieldName).AsString;
      V:=FParams.FieldByName(SFieldValue).AsString;

      if AnsiSameText(N,SParamLocation) then FLocation:=TBisCallServerHandlerLocation(StrToIntDef(V,Integer(FLocation)));
      if AnsiSameText(N,SParamVolume) then FVolume:=StrToIntDef(V,Integer(FVolume));

      if AnsiSameText(N,SParamOperatorIds) then begin
        Strings:=TStringList.Create;
        try
          FOperatorIds.Clear;
          Strings.Text:=Trim(V);
          for i:=0 to Strings.Count-1 do
            FOperatorIds.Add(Strings[i]);
        finally
          Strings.Free;
        end;
      end;

      FParams.Next;
    end;
  end;
  FChannels.Init;
end;

{ TBisCallServerHandlers }

destructor TBisCallServerHandlers.Destroy;
begin
  inherited Destroy;
end;

procedure TBisCallServerHandlers.DoCreateHandler(Handler: TBisCallServerHandler);
begin
  if Assigned(FOnCreateHandler) then
    FOnCreateHandler(Self,Handler);
end;

procedure TBisCallServerHandlers.DoDestroyHandler(Handler: TBisCallServerHandler);
begin
  if Assigned(FOnDestroyHandler) then
    FOnDestroyHandler(Self,Handler);
end;

function TBisCallServerHandlers.GetItem(Index: Integer): TBisCallServerHandler;
begin
  Result:=TBisCallServerHandler(inherited Items[Index]);
end;

function TBisCallServerHandlers.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisCallServerHandler;
end;

function TBisCallServerHandlers.AddClass(AClass: TBisCallServerHandlerClass; const ObjectName: String): TBisCallServerHandler;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    Result:=AClass.Create(Self);
    if Trim(ObjectName)<>'' then
      Result.ObjectName:=ObjectName;
    if not Assigned(Find(Result.ObjectName)) then begin
      AddObject(Result);
      DoCreateHandler(Result);
    end else begin
      FreeAndNilEx(Result);
    end;
  end;
end;

function TBisCallServerHandlers.AddHandler(Handler: TBisCallServerHandler): Boolean;
begin
  Result:=false;
  if not Assigned(Find(Handler.ObjectName)) then begin
    AddObject(Handler);
    Result:=true;
  end;
end;

procedure TBisCallServerHandlers.Remove(Handler: TBisCallServerHandler);
begin
  RemoveObject(Handler);
end;

procedure TBisCallServerHandlers.RemoveNotify(Obj: TBisObject);
begin
  if Assigned(Obj) and (Obj is TBisCallServerHandler) then
    DoDestroyHandler(TBisCallServerHandler(Obj));
  inherited RemoveNotify(Obj);
end;

procedure TBisCallServerHandlers.Connect;
var
  Item: TBisCallServerHandler;
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.Enabled then
      Item.Connect;
  end;
end;

procedure TBisCallServerHandlers.Disconnect;
var
  Item: TBisCallServerHandler;
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.Enabled then
      Item.Disconnect;
  end;
end;

procedure TBisCallServerHandlers.GetHandlers(Location: TBisCallServerHandlerLocation; OperatorId: Variant; Handlers: TObjectList);
var
  Item: TBisCallServerHandler;
  i: Integer;
  Flag: Boolean;
begin
  if Assigned(Handlers) then
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if Item.Enabled and (Item.Location=Location) and
         Item.Connected and not Item.Busy then begin
        Flag:=true;
        if not VarIsNull(OperatorId) then
          Flag:=Assigned(Item.OperatorIds.Find(OperatorId));
        if Flag then
          Handlers.Add(Item);
      end;
    end;
end;

end.
