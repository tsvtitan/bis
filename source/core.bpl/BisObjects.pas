unit BisObjects;

interface

uses Classes, Contnrs,
     BisObject, BisObjectsIntf;

type

  TBisObjects=class(TBisObject,IBisObjects)
  private
    FUnique: Boolean;
    FObjects: TObjectList;
    FOnItemFree: TNotifyEvent;
    function GetItem(Index: Integer): TBisObject;
    function GetCount: Integer;
    function GetOwnsObjects: Boolean;
    procedure SetOwnsObjects(const Value: Boolean);
  protected
    function GetObjectClass: TBisObjectClass; virtual;
    procedure DoItemFree(Obj: TBisObject); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Done; override;
    function Find(ObjectName: String): TBisObject;
    function FindByCaption(Caption: String): TBisObject;
    function Add(ObjectName: String): TBisObject; virtual;
    procedure AddObject(Obj: TBisObject);
    procedure Delete(Index: Integer);
    procedure Remove(Obj: TBisObject);
    procedure Clear;

    property Unique: Boolean read FUnique write FUnique;
    property Items[Index: Integer]: TBisObject read GetItem; default;
    property Count: Integer read GetCount;

    property OwnsObjects: Boolean read GetOwnsObjects write SetOwnsObjects;
    property OnItemFree: TNotifyEvent read FOnItemFree write FOnItemFree; 
  end;

implementation

uses Windows, SysUtils;

type
  TTempObjectList=class(TObjectList)
  private
    FParent: TBisObjects; 
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  end;

{ TTempObjectList }

procedure TTempObjectList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if (Action=lnDeleted) and Assigned(Ptr) and Assigned(FParent)then 
    FParent.DoItemFree(TBisObject(Ptr));  
  inherited Notify(Ptr,Action);
end;

{ TBisObjects }

constructor TBisObjects.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FObjects:=TTempObjectList.Create(true);
  TTempObjectList(FObjects).FParent:=Self;
  FUnique:=true;
end;

destructor TBisObjects.Destroy;
begin
  FObjects.Free;
  inherited Destroy;
end;

function TBisObjects.GetItem(Index: Integer): TBisObject;
begin
  Result:=TBisObject(FObjects.Items[Index]);
end;

function TBisObjects.GetCount: Integer;
begin
  Result:=FObjects.Count;
end;

function TBisObjects.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisObject;
end;

function TBisObjects.GetOwnsObjects: Boolean;
begin
  Result:=FObjects.OwnsObjects;
end;

procedure TBisObjects.Init;
var
  i: Integer;
  Item: TBisObject;
begin
  inherited Init;
  for i:=0 to FObjects.Count-1 do begin
    Item:=Items[i];
    Item.Init;
  end; 
end;

procedure TBisObjects.Done;
begin
  inherited Done;
end;

function TBisObjects.Find(ObjectName: String): TBisObject;
var
  Item: TBisObject;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.ObjectName,ObjectName) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisObjects.FindByCaption(Caption: String): TBisObject;
var
  Item: TBisObject;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.Caption,Caption) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisObjects.Add(ObjectName: String): TBisObject;
var
  AClass: TBisObjectClass;
begin
  Result:=nil;
  if FUnique then begin
    Result:=Find(ObjectName);
    if Assigned(Result) then begin
      Result:=nil;
      exit;
    end;
  end;
  AClass:=GetObjectClass;
  if Assigned(AClass) then begin
    Result:=AClass.Create(Self);
    Result.ObjectName:=ObjectName;
    Result.Init;
    FObjects.Add(Result);
  end;
end;

procedure TBisObjects.AddObject(Obj: TBisObject);
begin
  FObjects.Add(Obj);
end;

procedure TBisObjects.Clear;
begin
  FObjects.Clear;
end;

procedure TBisObjects.Delete(Index: Integer);
begin
  FObjects.Delete(Index);
end;

procedure TBisObjects.DoItemFree(Obj: TBisObject);
begin
  if Assigned(FOnItemFree) then
    FOnItemFree(Self);
end;

procedure TBisObjects.Remove(Obj: TBisObject);
begin
  FObjects.Remove(Obj);
end;

procedure TBisObjects.SetOwnsObjects(const Value: Boolean);
begin
  FObjects.OwnsObjects:=Value;
end;

end.

