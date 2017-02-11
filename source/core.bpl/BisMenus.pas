unit BisMenus;

interface

uses Classes,
     BisObject, BisCoreObjects, BisPicture, BisInterfaces, BisIfaces;

type
  TBisMenus=class;

  TBisMenusClass=class of TBisMenus;

  TBisMenu=class(TBisCoreObject)
  private
    FShortCut: TShortCut;
    FParent: TBisMenu;
    FPicture: TBisPicture;
    FChilds: TBisMenus;
    FID: String;
    FParentID: String;
    FInterfaceID: String;
    FPriority: Integer;
    FMenus: TBisMenus;
    FIface: TBisIface;
    function GetID: String;
    procedure SetID(const Value: String);
    procedure SetInterfaceID(const Value: String);
  protected
    procedure SetIface(AIface: TBisIface); virtual;
    property Menus: TBisMenus read FMenus write FMenus;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Show;
    function CanShow: Boolean;

    property ID: String read GetID write SetID;
    property ParentID: String read FParentID write FParentID;
    property InterfaceID: String read FInterfaceID write SetInterfaceID;
    property Iface: TBisIface read FIface write SetIface;
    property ShortCut: TShortCut read FShortCut write FShortCut;
    property Parent: TBisMenu read FParent write FParent;
    property Childs: TBisMenus read FChilds write FChilds;
    property Picture: TBisPicture read FPicture;
    property Priority: Integer read FPriority write FPriority;
  end;

  TBisMenus=class(TBisCoreObjects)
  private
    FInterfaces: TBisInterfaces;
    function GetItems(Index: Integer): TBisMenu;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function Add(ID: String): TBisMenu; reintroduce;
    function AddByID(ID, ParentID: String): TBisMenu;
    function FindByID(ID: String): TBisMenu;
    procedure PackMenus;

    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);

    property Items[Index: Integer]: TBisMenu read GetItems;
    property Interfaces: TBisInterfaces read FInterfaces write FInterfaces;
  end;

implementation

uses SysUtils, Variants,
     BisUtils, BisConsts, BisFm;

{ TBisMenu }

constructor TBisMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPicture:=TBisPicture.Create;
end;

destructor TBisMenu.Destroy;
begin
  FreeAndNilEx(FChilds);
  FPicture.Free;
  inherited Destroy;
end;

function TBisMenu.GetID: String;
begin
  Result:=FID;
end;

procedure TBisMenu.SetID(const Value: String);
begin
  FID:=Value;
end;

procedure TBisMenu.SetIface(AIface: TBisIface);
begin
  FIface:=AIface;
end;

procedure TBisMenu.SetInterfaceID(const Value: String);
var
  AInterface: TBisInterface;
begin
  FInterfaceID := Value;
  FIface:=nil;
  if (Trim(FInterfaceID)<>'') and Assigned(FMenus) and Assigned(FMenus.Interfaces) then begin
    AInterface:=FMenus.Interfaces.FindById(FInterfaceID);
    if Assigned(AInterface) then
      Iface:=AInterface.Iface;
  end;
end;

function TBisMenu.CanShow: Boolean;
begin
  Result:=Assigned(FIface) and FIface.CanShow;
end;

procedure TBisMenu.Show;
begin
  if CanShow then
    FIface.Show;
end;

{ TBisMenus }

constructor TBisMenus.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Unique:=false;
end;

function TBisMenus.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisMenu;
end;

function TBisMenus.GetItems(Index: Integer): TBisMenu;
begin
  Result:=TBisMenu(inherited Items[Index]);
end;

function TBisMenus.Add(ID: String): TBisMenu;
begin
  Result:=TBisMenu(inherited Add(''));
  Result.ID:=ID;
end;

function TBisMenus.AddByID(ID, ParentID: String): TBisMenu;
var
  ParentMenu: TBisMenu;
begin
  ParentMenu:=FindById(ParentID);
  if Assigned(ParentMenu) then begin
    Result:=TBisMenu(ParentMenu.Childs.Add(ID));
    Result.Childs:=TBisMenusClass(Self.ClassType).Create(Result);
    Result.Parent:=ParentMenu;
    Result.ParentID:=ParentID;
  end else begin
    Result:=Add(ID);
    Result.Childs:=TBisMenusClass(Self.ClassType).Create(Result);
  end;
  Result.Menus:=Self;
end;

function TBisMenus.FindById(ID: String): TBisMenu;
var
  Flag: Boolean;

  procedure FindRecurse(Menus: TBisMenus);
  var
    i: Integer;
    Item: TBisMenu;
  begin
    if Flag then
      exit;
    for i:=0 to Menus.Count-1 do begin
      Item:=Menus.Items[i];
      if VarSameValue(Item.ID,ID) then begin
        Result:=Item;
        Flag:=true;
        break;
      end else
        FindRecurse(Item.Childs);
    end;
  end;

begin
  Result:=nil;
  Flag:=false;
  FindRecurse(Self);
end;

procedure TBisMenus.PackMenus;

   procedure PackRecurse(Menus: TBisMenus);
   var
     i: Integer;
     Item: TBisMenu;
   begin
     for i:=Menus.Count-1 downto 0 do begin
       Item:=Menus.Items[i];
       PackRecurse(Item.Childs);
       if (Item.Childs.Count=0) and not Assigned(Item.Iface) and
          (Item.Caption<>SMenuDelim) then begin
         Menus.Delete(i);
       end;
     end;
   end;

begin
  PackRecurse(Self);
end;

procedure TBisMenus.SaveToStream(Stream: TStream);

  procedure WriteMenus(Writer: TWriter; Menus: TBisMenus);
  var
    i: Integer;
    Item: TBisMenu;
    Stream: TMemoryStream;
  begin
    Writer.WriteListBegin;
    for i:=0 to Menus.Count-1 do begin
      Item:=Menus.Items[i];
      Writer.WriteString(Item.ID);
      Writer.WriteString(Item.ParentID);
      Writer.WriteString(Item.InterfaceID);
      Writer.WriteString(Item.Caption);
      Writer.WriteString(Item.Description);
      Writer.WriteInteger(Item.ShortCut);
      Writer.WriteInteger(Item.Priority);

      Stream:=TMemoryStream.Create;
      try
        Item.Picture.SaveToStream(Stream);
        Stream.Position:=0;
        Writer.WriteInteger(Stream.Size);
        Writer.Write(Stream.Memory^,Stream.Size);
      finally
        Stream.Free;
      end;

      WriteMenus(Writer,Item.Childs);
    end;
    Writer.WriteListEnd;
  end;

var
  Writer: TWriter;
begin
  Writer:=TWriter.Create(Stream,WriterBufferSize);
  try
    WriteMenus(Writer,Self);
  finally
    Writer.Free;
  end;
end;

procedure TBisMenus.LoadFromStream(Stream: TStream);

  procedure ReadMenus(Reader: TReader; Menus: TBisMenus; Parent: TBisMenu=nil);
  var
    Item: TBisMenu;
    Stream: TMemoryStream;
    ID: String;
  begin
    Reader.ReadListBegin;
    while not Reader.EndOfList do begin
      ID:=Reader.ReadString;
      Item:=AddByID(ID,Reader.ReadString);
      if Assigned(Item) then begin

        Item.InterfaceID:=Reader.ReadString;
        Item.Caption:=Reader.ReadString;
        Item.Description:=Reader.ReadString;
        Item.ShortCut:=Reader.ReadInteger;
        Item.Priority:=Reader.ReadInteger;

        Stream:=TMemoryStream.Create;
        try
          Stream.Size:=Reader.ReadInt64;
          Reader.Read(Stream.Memory^,Stream.Size);
          Stream.Position:=0;
          Item.Picture.LoadFromStream(Stream);
        finally
          Stream.Free;
        end;

        ReadMenus(Reader,Item.Childs,Item);

      end;
    end;
    Reader.ReadListEnd;
  end;

var
  Reader: TReader;
begin
  Reader:=TReader.Create(Stream,ReaderBufferSize);
  try
    ReadMenus(Reader,Self);
  finally
    Reader.Free;
  end;
end;

end.
