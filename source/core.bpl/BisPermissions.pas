unit BisPermissions;

interface

uses Classes,
     BisObject, BisCoreObjects;

type

  TBisPermission=class(TBisCoreObject)
  private
    FValues: TStringList;
    function GetExists(Index: Integer): Boolean;
    procedure SetExists(Index: Integer; Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisPermission);

    property Values: TStringList read FValues;
    property Exists[Index: Integer]: Boolean read GetExists write SetExists;
  end;

  TBisPermissions=class(TBisCoreObjects)
  private
    FEnabled: Boolean;
    FSValueOpen: String;
    FSValueClose: String;
    function GetItems(Index: Integer): TBisPermission;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function Add(PermissionName: String): TBisPermission; reintroduce;
    function AddDefault(PermissionName: String): TBisPermission;
    function Exists(PermissionName, Value: String): Boolean; overload;
    function Exists(PermissionName: String): Boolean; overload;
    procedure CopyFrom(Source: TBisPermissions; WithClear: Boolean=true); virtual;
    function Find(PermissionName: String): TBisPermission; reintroduce; 

    property Items[Index: Integer]: TBisPermission read GetItems;
    property Enabled: Boolean read FEnabled write FEnabled;
  published
    property SValueOpen: String read FSValueOpen write FSValueOpen;
    property SValueClose: String read FSValueClose write FSValueClose;
  end;

implementation

uses SysUtils,
     BisConsts, BisCore, BisInterfaces, BisIfaces;

{ TBisPermission }

constructor TBisPermission.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FValues:=TStringList.Create;
end;

destructor TBisPermission.Destroy;
begin
  FValues.Free;
  inherited Destroy;
end;

function TBisPermission.GetExists(Index: Integer): Boolean;
begin
  Result:=false;
  if (Index>=0) and (Index<FValues.Count) then
    Result:=Boolean(Integer(FValues.Objects[Index]));
end;

procedure TBisPermission.SetExists(Index: Integer; Value: Boolean);
var
  i: Integer;
begin
  if (Index>=0) and (Index<FValues.Count) then begin
    for i:=0 to FValues.Count-1 do begin
      FValues.Objects[i]:=TObject(Integer(false));
    end;
    FValues.Objects[Index]:=TObject(Integer(Value));
  end;
end;

procedure TBisPermission.CopyFrom(Source: TBisPermission);
var
  i: Integer;
begin
  if Assigned(Source) then begin
    ObjectName:=Source.ObjectName;
    FValues.Clear;
    for i:=0 to Source.Values.Count-1 do
      FValues.AddObject(Source.Values[i],Source.Values.Objects[i]);
  end;
end;

{ TBisPermissions }

constructor TBisPermissions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSValueOpen:='������';
  FSValueClose:='������';
end;

function TBisPermissions.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisPermission;
end;

function TBisPermissions.GetItems(Index: Integer): TBisPermission;
begin
  Result:=TBisPermission(inherited Items[Index]);
end;

function TBisPermissions.Add(PermissionName: String): TBisPermission;
begin
  Result:=TBisPermission(inherited Add(PermissionName));
end;

function TBisPermissions.AddDefault(PermissionName: String): TBisPermission;
begin
  Result:=Add(PermissionName);
  if Assigned(Result) then begin
    Result.Values.Add(FSValueOpen);
    Result.Values.Add(FSValueClose);
  end;
end;

function TBisPermissions.Exists(PermissionName, Value: String): Boolean;
var
  Perm: TBisPermission;
  Index: Integer;
  i: Integer;
  AInterface: TBisInterface;
  AIface: TBisIface;
begin
  Result:=false;
  if FEnabled and Core.CheckPermissions then begin

    Perm:=nil;
    
    if Assigned(ParentObject) then begin
      for i:=0 to Core.Interfaces.Count-1 do begin
        AInterface:=Core.Interfaces.Items[i];
        if Assigned(AInterface) then begin
          AIface:=AInterface.Iface;
          if Assigned(AIface) and (AIface<>ParentObject) and
             (AIface.ClassName=ParentObject.ClassName) and
             AnsiSameText(AIface.ObjectName,ParentObject.ObjectName) then begin
            Perm:=TBisPermission(AIface.Permissions.Find(PermissionName));
            break;
          end;
        end;
      end;
    end;

    if not Assigned(Perm) then
      Perm:=TBisPermission(Find(PermissionName));

    if Assigned(Perm) then begin
      Index:=Perm.Values.IndexOf(Value);
      Result:=Index<>-1;
      if Index<>-1 then
        Result:=Perm.Exists[Index];
    end;
  end else
    Result:=true;
end;

function TBisPermissions.Exists(PermissionName: String): Boolean;
begin
  Result:=Exists(PermissionName,FSValueOpen);
end;

procedure TBisPermissions.CopyFrom(Source: TBisPermissions; WithClear: Boolean);
var
  i,j: Integer;
  ItemSource, Item: TBisPermission;
  Index: Integer;
begin
  if Assigned(Source) then begin
    if WithClear then
      Clear;
    for i:=0 to Source.Count-1 do begin
      ItemSource:=Source.Items[i];
      Item:=Find(ItemSource.ObjectName);
      if not Assigned(Item) then
        Item:=Add(ItemSource.ObjectName);
      if Assigned(Item) then begin
        for j:=0 to ItemSource.Values.Count-1 do begin
          Index:=Item.Values.IndexOf(ItemSource.Values[j]);
          if Index=-1 then
            Index:=Item.Values.Add(ItemSource.Values[j]);
          Item.Exists[Index]:=ItemSource.Exists[j];
        end;
      end;
    end;
  end;
end;

function TBisPermissions.Find(PermissionName: String): TBisPermission;
begin
  Result:=TBisPermission(inherited Find(PermissionName));
end;


end.
