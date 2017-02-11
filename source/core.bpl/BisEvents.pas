unit BisEvents;

interface

uses Windows, Classes, SysUtils, Contnrs, SyncObjs,
     BisValues, BisLocks, BisThreads;

type
  TBisEvent=class;

  TBisEventParam=class(TObject)
  private
    FName: String;
    FValue: Variant;
  public
    function AsString: String;
    function AsInteger: Integer;

    property Name: String read FName;
    property Value: Variant read FValue write FValue;

  end;

  TBisEventParams=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisEventParam;
    function GetValue(Name: String): Variant;
  public
    function Add(Name: String; Value: Variant): TBisEventParam;
    function Find(Name: String): TBisEventParam;
    procedure CopyFrom(Source: TBisEventParams; WithClear: Boolean=true);

    property Items[Index: Integer]: TBisEventParam read GetItem; default;
    property Value[Name: String]: Variant read GetValue;
  end;

  TBisEventHandler=function(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean of object;

  TBisEvent=class(TBisLock)
  private
    FName: String;
    FHandler: TBisEventHandler;
    FThreaded: Boolean;
    FEnabled: Boolean;
    FThreads: TBisThreads;
    procedure ThreadEnd(Thread: TBisThread);
  public
    constructor Create; override;
    destructor Destroy; override;
    function Execute(InParams, OutParams: TBisEventParams): Boolean; overload;
    function Execute(InParams: TBisEventParams): Boolean; overload;

    property Handler: TBisEventHandler read FHandler;

    property Name: String read FName write FName;
    property Enabled: Boolean read FEnabled write FEnabled;
    property Threaded: Boolean read FThreaded write FThreaded;
  end;

  TBisEvents=class(TBisLocks)
  private
    function GetItem(Index: Integer): TBisEvent;
  public
    constructor Create; override;
    destructor Destroy; override;

    function Add(const Name: String; Handler: TBisEventHandler; Threaded: Boolean): TBisEvent; reintroduce; overload;
    function LockAdd(const Name: String; Handler: TBisEventHandler; Threaded: Boolean): TBisEvent; reintroduce; overload;

    procedure GetEvents(const Name: String; Events: TBisEvents);

    property Items[Index: Integer]: TBisEvent read GetItem; default;
  end;

implementation

uses Variants,
     BisUtils;


{ TBisEventParams }

function TBisEventParams.Add(Name: String; Value: Variant): TBisEventParam;
begin
  Result:=Find(Name);
  if not Assigned(Result) then begin
    Result:=TBisEventParam.Create;
    Result.FName:=Name;
    Result.FValue:=Value;
    inherited Add(Result);
  end else
    Result:=nil;
end;

procedure TBisEventParams.CopyFrom(Source: TBisEventParams; WithClear: Boolean=true);
var
  i: Integer;
  Item: TBisEventParam;
begin
  if WithClear then
    Clear;
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Item:=Source.Items[i];
      Add(Item.Name,Item.Value);
    end;
  end;
end;

function TBisEventParams.Find(Name: String): TBisEventParam;
var
  i: Integer;
  Item: TBisEventParam;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.Name,Name) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisEventParams.GetItem(Index: Integer): TBisEventParam;
begin
  Result:=TBisEventParam(inherited Items[Index]);
end;

function TBisEventParams.GetValue(Name: String): Variant;
var
  Item: TBisEventParam;
begin
  Result:=Null;
  Item:=Find(Name);
  if Assigned(Item) then
    Result:=Item.Value;
end;

type
  TBisEventThread=class(TBisThread)
  private
    FEvent: TBisEvent;
    FExecuted: Boolean;
    FInParams: TBisEventParams;
    FOutParams: TBisEventParams;

    procedure SyncExecute;
  protected
    procedure DoWork; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

{ TBisEventThread }

constructor TBisEventThread.Create;
begin
  inherited Create;
  FInParams:=TBisEventParams.Create;
  FOutParams:=TBisEventParams.Create;
end;

destructor TBisEventThread.Destroy;
begin
  FOutParams.Free;
  FInParams.Free;
  FEvent:=nil;
  inherited Destroy;
end;

procedure TBisEventThread.SyncExecute;
begin
  if Assigned(FEvent) then
    FExecuted:=FEvent.FHandler(FEvent,FInParams,FOutParams)
end;

procedure TBisEventThread.DoWork;
begin
  if Assigned(FEvent) and Assigned(FEvent.Handler) then begin
    if FEvent.Threaded then
      FExecuted:=FEvent.FHandler(FEvent,FInParams,FOutParams)
    else
      Synchronize(SyncExecute);
  end;
end;

{ TBisEventParam }

function TBisEventParam.AsInteger: Integer;
begin
  Result:=VarToIntDef(FValue,0);
end;

function TBisEventParam.AsString: String;
begin
  Result:=VarToStrDef(FValue,'');
end;

{ TBisEvent }

constructor TBisEvent.Create;
begin
  inherited Create;
  FEnabled:=true;
  FThreads:=TBisThreads.Create;
end;

destructor TBisEvent.Destroy;
begin
  FreeAndNilEx(FThreads);
  inherited Destroy;
end;

procedure TBisEvent.ThreadEnd(Thread: TBisThread);
begin
  if Assigned(FThreads) then
    FThreads.LockRemove(Thread);
end;

function TBisEvent.Execute(InParams, OutParams: TBisEventParams): Boolean;
var
  Thread: TBisEventThread;
begin
  Lock;
  try
    Result:=false;
    if Assigned(FHandler) and FEnabled then begin
      Thread:=TBisEventThread.Create;
      Thread.FEvent:=Self;
      Thread.FInParams.CopyFrom(InParams);
      Thread.FOutParams.CopyFrom(OutParams);
      Thread.OnEnd:=ThreadEnd;
      if Assigned(OutParams) then begin
        Thread.Start(true);
        OutParams.CopyFrom(Thread.FOutParams);
        Result:=Thread.FExecuted;
        Thread.Free;
      end else begin
        FThreads.LockAdd(Thread);
        Thread.Start(false);
        Result:=true;
      end;
    end;
  finally
    UnLock;
  end;
end;

function TBisEvent.Execute(InParams: TBisEventParams): Boolean;
begin
  Result:=Execute(InParams,nil);
end;

{ TBisEvents }

constructor TBisEvents.Create;
begin
  inherited Create;
end;

destructor TBisEvents.Destroy;
begin
  inherited Destroy;
end;

function TBisEvents.GetItem(Index: Integer): TBisEvent;
begin
  Result:=TBisEvent(inherited Items[Index]);
end;

procedure TBisEvents.GetEvents(const Name: String; Events: TBisEvents);
var
  i: Integer;
  Item: TBisEvent;
begin
  if Assigned(Events) then begin
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if AnsiSameText(Item.Name,Name) then begin
        Events.Add(Item);
      end;
    end;
  end;
end;

function TBisEvents.Add(const Name: String; Handler: TBisEventHandler; Threaded: Boolean): TBisEvent;
begin
  Result:=TBisEvent.Create;
  Result.FName:=Name;
  Result.FHandler:=Handler;
  Result.FThreaded:=Threaded;
  inherited Add(Result);
end;

function TBisEvents.LockAdd(const Name: String; Handler: TBisEventHandler; Threaded: Boolean): TBisEvent;
begin
  Lock;
  try
    Result:=Add(Name,Handler,Threaded); 
  finally
    UnLock;
  end;
end;


end.
