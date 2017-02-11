unit BisServers;

interface

uses Classes, Contnrs,
     BisObject, BisCoreObjects, BisDataSet, BisDataParams,
     BisServerModuleIntf;

type

  TBisServer=class(TBisCoreObject)
  private
    FEnabled: Boolean;
    FParams: TBisDataValueParams;
    FWorking: Boolean;
    FModule: IBisServerModule;
    FSStopFail: String;
    FSStartFail: String;
    FSStop: String;
    FSStart: String;
    FSStopSuccess: String;
    FSStartSuccess: String;
  protected
    function GetStarted: Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start; virtual;
    procedure Stop; virtual;
    procedure SaveParams; virtual;

    property Started: Boolean read GetStarted;
    property Params: TBisDataValueParams read FParams;

    property Working: Boolean read FWorking write FWorking;
    property Enabled: Boolean read FEnabled write FEnabled;
    property Module: IBisServerModule read FModule write FModule;
  published
    property SStart: String read FSStart write FSStart;
    property SStartSuccess: String read FSStartSuccess write FSStartSuccess;
    property SStartFail: String read FSStartFail write FSStartFail;

    property SStop: String read FSStop write FSStop;
    property SStopSuccess: String read FSStopSuccess write FSStopSuccess;
    property SStopFail: String read FSStopFail write FSStopFail;
  end;

  TBisServerClass=class of TBisServer;

  TBisServers=class(TBisCoreObjects)
  private
    function GetItems(Index: Integer): TBisServer;
    function GetWorking: Boolean;
    function GetStarted: Boolean;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    function AddClass(AClass: TBisServerClass; const ObjectName: String=''): TBisServer;
    function AddServer(AServer: TBisServer): Boolean;

    procedure Start;
    procedure Stop;

    property Items[Index: Integer]: TBisServer read GetItems;
    property Working: Boolean read GetWorking;
    property Started: Boolean read GetStarted;
  end;

implementation

uses SysUtils,
     BisUtils, BisConsts;

{ TBisServer }

constructor TBisServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParams:=TBisDataValueParams.Create;

  FSStart:='Запуск сервера ...';
  FSStartSuccess:='Запуск сервера прошел успешно.';
  FSStartFail:='Запуск сервера не прошел. %s';

  FSStop:='Остановка сервера ...';
  FSStopSuccess:='Остановка сервера прошла успешно.';
  FSStopFail:='Остановка сервера не прошла. %s';

  
end;

destructor TBisServer.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

function TBisServer.GetStarted: Boolean;
begin
  Result:=false;
end;

procedure TBisServer.SaveParams;
begin
  if Assigned(FModule) then
    FModule.SaveServerParams(Self);
end;

procedure TBisServer.Start;
begin
end;

procedure TBisServer.Stop;
begin
end;

{ TBisServers }

function TBisServers.GetItems(Index: Integer): TBisServer;
begin
  Result:=TBisServer(inherited Items[Index]);
end;

function TBisServers.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisServer;
end;

{function TBisServers.GetStarted: Boolean;
var
  i: Integer;
begin
  Result:=false;
  for i:=0 to Count-1 do begin
    if i=0 then
      Result:=Items[i].Started
    else
      Result:=Result and Items[i].Started;
  end;
end;}

function TBisServers.GetStarted: Boolean;
var
  i: Integer;
  Item: TBisServer; 
begin
  Result:=false;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.Enabled and Item.Started then begin
      Result:=true;
      break;
    end;
  end;
end;

function TBisServers.GetWorking: Boolean;
var
  i: Integer;
  Item: TBisServer; 
begin
  Result:=false;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.Enabled and Item.Working then begin
      Result:=true;
      break;
    end;
  end;
end;

procedure TBisServers.Start;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    if Items[i].Enabled then
      Items[i].Start;
  end;
end;

procedure TBisServers.Stop;
var
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Items[i].Stop;
  end;
end;

function TBisServers.AddClass(AClass: TBisServerClass; const ObjectName: String): TBisServer;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    Result:=AClass.Create(Self);
    if Trim(ObjectName)<>'' then
      Result.ObjectName:=ObjectName;
    if not Assigned(Find(Result.ObjectName)) then begin
      AddObject(Result);
    end else begin
      FreeAndNilEx(Result);
    end;
  end;
end;

function TBisServers.AddServer(AServer: TBisServer): Boolean;
begin
  Result:=false;
  if not Assigned(Find(AServer.ObjectName)) then begin
    AddObject(AServer);
    Result:=true;
  end;
end;


end.
