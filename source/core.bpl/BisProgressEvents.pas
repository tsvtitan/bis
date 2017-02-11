unit BisProgressEvents;

interface

uses Classes, Contnrs;

type

  TProgressEvent=procedure (const Min,Max,Position: Integer; var Interrupted: Boolean) of object;

  TBisProgressEvent=class(TObject)
  private
    FEvent: TProgressEvent;
    FEnabled: Boolean;
  public
    constructor Create;
    procedure Progress(const Min, Max, Position: Integer; var Interrupted: Boolean);

    property Event: TProgressEvent read FEvent write FEvent;
    property Enabled: Boolean read FEnabled write FEnabled;
  end;

  TBisProgressEvents=class(TObjectList)
  private
    FEnabled: Boolean;
    function GetItems(Index: Integer): TBisProgressEvent;
  public
    constructor Create;
    function Add(Event: TProgressEvent): TBisProgressEvent;
    procedure Progress(const Min, Max, Position: Integer; var Interrupted: Boolean);

    property Items[Index: Integer]: TBisProgressEvent read GetItems;
    property Enabled: Boolean read FEnabled write FEnabled; 
  end;

implementation

{ TBisProgressEvent }

constructor TBisProgressEvent.Create;
begin
  inherited Create;
  FEnabled:=true;
end;

procedure TBisProgressEvent.Progress(const Min, Max, Position: Integer; var Interrupted: Boolean);
begin
  if Assigned(FEvent) and FEnabled then
    FEvent(Min,Max,Position,Interrupted);
end;

{ TBisProgressEvents }

constructor TBisProgressEvents.Create;
begin
  inherited Create;
  FEnabled:=true;
end;

function TBisProgressEvents.Add(Event: TProgressEvent): TBisProgressEvent;
begin
  Result:=TBisProgressEvent.Create;
  Result.Event:=Event;
  inherited Add(Result);
end;

function TBisProgressEvents.GetItems(Index: Integer): TBisProgressEvent;
begin
  Result:=TBisProgressEvent(inherited Items[Index]);
end;

procedure TBisProgressEvents.Progress(const Min, Max, Position: Integer; var Interrupted: Boolean);
var
  i: Integer;
  Item: TBisProgressEvent;
begin
  if FEnabled then
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      Item.Progress(Min,Max,Position,Interrupted);
    end;
end;

end.
