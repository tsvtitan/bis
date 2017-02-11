unit BisOrders;

interface

uses Classes, Contnrs;

type

  TBisOrderType=(otNone,otAsc,otDesc);

  TBisOrder=class(TObject)
  private
    FFieldName: string;
    FCaption: String;
    FOrderType: TBisOrderType;
  public
    property Caption: String read FCaption write FCaption;
    property FieldName: String read FFieldName write FFieldName;
    property OrderType: TBisOrderType read FOrderType write FOrderType;
  end;

  TBisOrders=class(TObjectList)
  private
    function GetEnabled: Boolean;
    function GetItems(Index: Integer): TBisOrder;
  public
    function Find(const FieldName: string): TBisOrder;
    function Add(const FieldName: string; OrderType: TBisOrderType=otAsc): TBisOrder;
    procedure CopyFrom(Source: TBisOrders; IsClear: Boolean=true);

    procedure WriteData(Writer: TWriter);
    procedure ReadData(Reader: TReader);

    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    
    property Items[Index: Integer]: TBisOrder read GetItems;
    property Enabled: Boolean read GetEnabled;
  end;

implementation

uses SysUtils,
     BisConsts;

{ TBisOrders }

function TBisOrders.GetItems(Index: Integer): TBisOrder;
begin
  Result:=TBisOrder(inherited Items[Index]);
end;

function TBisOrders.Find(const FieldName: string): TBisOrder;
var
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    if AnsiSameText(Items[i].FieldName,FieldName) then begin
      Result:=Items[i];
      exit;
    end;
  end;
end;

function TBisOrders.Add(const FieldName: string; OrderType: TBisOrderType): TBisOrder;
begin
  Result:=nil;
  if not Assigned(Find(FieldName)) then begin
    Result:=TBisOrder.Create;
    Result.FieldName:=FieldName;
    Result.OrderType:=OrderType;
    inherited Add(Result);
  end;
end;

procedure TBisOrders.CopyFrom(Source: TBisOrders; IsClear: Boolean=true);
var
  i: Integer;
  Item,ItemNew: TBisOrder;
begin
  if IsClear then
    Clear;
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Item:=Source.Items[i];
      ItemNew:=Add(Item.FieldName,Item.OrderType);
      if Assigned(ItemNew) then
        ItemNew.Caption:=Item.Caption;
    end;
  end;
end;

function TBisOrders.GetEnabled: Boolean;
var
  i: Integer;
begin
  Result:=false;
  for i:=0 to Count-1 do
    if Items[i].OrderType<>otNone then begin
      Result:=true;
      break;
    end;
end;

procedure TBisOrders.WriteData(Writer: TWriter);
var
  i: Integer;
  Item: TBisOrder;
begin
  Writer.WriteListBegin;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Writer.WriteString(Item.FieldName);
    Writer.WriteInteger(Integer(Item.OrderType));
    Writer.WriteString(Item.Caption);
  end;
  Writer.WriteListEnd;
end;

procedure TBisOrders.ReadData(Reader: TReader);
var
  Item: TBisOrder;
begin
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    Item:=Add(Reader.ReadString,TBisOrderType(Reader.ReadInteger));
    if Assigned(Item) then begin
      Item.Caption:=Reader.ReadString;
    end;
  end;
  Reader.ReadListEnd;
end;

procedure TBisOrders.SaveToStream(Stream: TStream);
var
  Writer: TWriter;
begin
  Writer:=TWriter.Create(Stream,WriterBufferSize);
  try
    WriteData(Writer);
  finally
    Writer.Free;
  end;
end;

procedure TBisOrders.LoadFromStream(Stream: TStream);
var
  Reader: TReader;
begin
  Reader:=TReader.Create(Stream,ReaderBufferSize);
  try
    ReadData(Reader);
  finally
    Reader.Free;
  end;
end;

end.
