unit BisNotifyEvents;

interface

uses Classes, Contnrs;

type
  TBisNotifyEvent=class(TObject)
  private
    FEvent: TNotifyEvent;
    FObj: TObject;
  public
    procedure Call;
    
    property Event: TNotifyEvent read FEvent write FEvent;
    property Obj: TObject read FObj write FObj;
  end;

  TBisNotifyEvents=class(TObjectList)
  private
    function GetItems(Index: Integer): TBisNotifyEvent;
  public
    function Add(Event: TNotifyEvent; Obj: TObject=nil): TBisNotifyEvent;
    function Remove(Event: TBisNotifyEvent): Integer;
    procedure Call;

    property Items[Index: Integer]: TBisNotifyEvent read GetItems;
  end;

implementation

{ TBisNotifyEvent }

procedure TBisNotifyEvent.Call;
begin
  if Assigned(FEvent) then
    FEvent(FObj);
end;


{ TBisNotifyEvents }

function TBisNotifyEvents.GetItems(Index: Integer): TBisNotifyEvent;
begin
  Result:=TBisNotifyEvent(inherited Items[Index]);
end;

function TBisNotifyEvents.Remove(Event: TBisNotifyEvent): Integer;
begin
  Result:=-1;
  if Assigned(Event) then
    Result:=inherited Remove(Event);
end;

function TBisNotifyEvents.Add(Event: TNotifyEvent; Obj: TObject=nil): TBisNotifyEvent;
begin
  Result:=TBisNotifyEvent.Create;
  Result.Event:=Event;
  Result.Obj:=Obj;
  inherited Add(Result);
end;

procedure TBisNotifyEvents.Call;
var
  i: Integer;
  Item: TBisNotifyEvent;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Item.Call;
  end;
end;


end.
