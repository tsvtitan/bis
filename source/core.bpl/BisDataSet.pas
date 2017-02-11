unit BisDataSet;

interface

uses Classes, DB, Controls, Forms, WideStrings, Contnrs,

     kbmMemBinaryStreamFormat, kbmMemTable,

     BisFieldNames, BisFilterGroups, BisOrders, BisParams,
     BisParam;

type
  TBisDataSet=class;

  TBisDataSetStreamFormat=class(TkbmBinaryStreamFormat)
  protected
    procedure BeforeSave(ADataset:TkbmCustomMemTable); override;
    procedure BeforeLoad(ADataset:TkbmCustomMemTable); override;

    procedure AfterSave(ADataset:TkbmCustomMemTable); override;
    procedure AfterLoad(ADataset:TkbmCustomMemTable); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDataSetOpenMode=(omOpen,omExecute);

  TBisDataSetCollectionItem=class(TObject)
  private
    FName: String;
    FFieldNames: TBisFieldNames;
    FProviderName: String;
    FFilterGroups: TBisFilterGroups;
    FParams: TBisParams;
    FOrders: TBisOrders;
    FReturn: TMemoryStream;
    FOpenMode: TBisDataSetOpenMode;
    FPackageAfter: TBisPackageParams;
    FPackageBefore: TBisPackageParams;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetDataSet(DataSet: TBisDataSet);
    function GetDataSet(DataSet: TBisDataSet): Boolean;

    property Name: String read FName;
    property FieldNames: TBisFieldNames read FFieldNames;
    property FilterGroups: TBisFilterGroups read FFilterGroups;
    property Orders: TBisOrders read FOrders;
    property Params: TBisParams read FParams;
    property PackageBefore: TBisPackageParams read FPackageBefore;
    property PackageAfter: TBisPackageParams read FPackageAfter;

    property OpenMode: TBisDataSetOpenMode read FOpenMode write FOpenMode;
    property ProviderName: String read FProviderName write FProviderName;
  end;

  TBisDataSetCollection=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisDataSetCollectionItem;
  public
    function Find(const Name: String): TBisDataSetCollectionItem;
    function Add(OpenMode: TBisDataSetOpenMode=omOpen): TBisDataSetCollectionItem;
    function AddOpen: TBisDataSetCollectionItem;
    function AddExecute: TBisDataSetCollectionItem;
    function AddDataSet(DataSet: TBisDataSet): TBisDataSetCollectionItem;
    procedure CopyFrom(Source: TBisDataSetCollection; WithClear: Boolean=true);

    procedure WriteData(Writer: TWriter);
    procedure ReadData(Reader: TReader);

    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);

    property Items[Index: Integer]: TBisDataSetCollectionItem read GetItem; default;
  end;

  TBisDataSetPackage=class(TBisPackageParams)
  end;

  TBisDataSetSortType=TBisOrderType;

  TBisDataSet=class(TkbmMemTable)
  private
    FStreamFormat: TBisDataSetStreamFormat;
    FFieldNames: TBisFieldNames;
    FFilterGroups: TBisFilterGroups;
    FProviderName: String;
    FTempBookmark: TBookmark;
    FOldAfterScroll: TDataSetNotifyEvent;
    FOldBeforeScroll: TDataSetNotifyEvent;
    FOldBeforePost: TDataSetNotifyEvent;
    FOldFilter: String;
    FOldFiltered: Boolean;
    FOldReadOnly: Boolean;
    FSDisplayFormat: String;
    FFetchCount: Integer;
    FServerRecordCount: Integer;
    FOrders: TBisOrders;
    FParams: TBisParams;
    FInGetRecords: Boolean;
    FInExecute: Boolean;
    FParentDataSet: TBisDataSet;
    FOnUpdateCounters: TNotifyEvent;
    FTableName: String;
    FExtendedSaving: Boolean;
    FOpenMode: TBisDataSetOpenMode;
    FPackageBefore: TBisDataSetPackage;
    FPackageAfter: TBisDataSetPackage;
    FOnSynchronize: TNotifyEvent;
{    FOnInternalOpen: TNotifyEvent;
    FOnInternalExecute: TNotifyEvent;}
    FUseCache: Boolean;
    FCalculateDisabled: Boolean;
    FCalculateFieldNames: TBisFieldNames;
    FCollectionBefore: TBisDataSetCollection;
    FCollectionAfter: TBisDataSetCollection;
    FNeedOpen: Boolean;
    function GetData: String;
    procedure SetData(Value: String);
    function GetEmpty: Boolean;
    function GetFieldValue(FieldName: String; var Value: Variant): Boolean;
    function FindFieldByParam(Param: TBisParam): TField;
    function GetCheckSum: String;
    procedure CopyCollection(CollectionFrom,CollectionTo: TBisDataSetCollection; Stream: TMemoryStream);
    procedure CopyPackage(PackageFrom,PackageTo: TBisPackageParams; Stream: TMemoryStream);
  protected

    procedure CreateFields; override;
    procedure DestroyFields; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalOpen; override;
    procedure InternalClose; override;
    procedure InternalExecute; virtual;

    procedure DoOnCalcFields; override;
    procedure DoUpdateCounters; virtual;
    procedure DoSynchronize; virtual;

    procedure DoInternalOpen; virtual;
    procedure DoInternalExecute; virtual;
    procedure DoInternalClose; virtual;

    property NeedOpen: Boolean read FNeedOpen write FNeedOpen;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetFieldNames(List: TStrings); override;
    function Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean; override;

    procedure InitCalcFieldDefs;
    function GetInfo(const Delimeter: String=''): String;
    procedure MoveData(Up: Boolean);
    procedure CreateStructure(Source: TDataSet; IsClear: Boolean=true);
    procedure CopyRecord(Source: TDataSet; AppenRecord: Boolean=true; ChangeMode: Boolean=true);
    procedure CopyRecords(Source: TDataSet); reintroduce;
    procedure CreateTable(Source: TDataSet=nil); reintroduce;
    procedure CopyFrom(Source: TBisDataSet);
    procedure EmptyTable; reintroduce;
    procedure BeginUpdate(WithBookmark: Boolean=true; WithFilter: Boolean=false);
    procedure EndUpdate(WithScroll: Boolean=false);
    procedure ThrowBookmark;
    procedure Sort(const FieldNames: String; SortType: TBisDataSetSortType);
    procedure OpenWithExecute;
    procedure Execute;
    procedure InsertIntoParent;
    procedure UpdateIntoParent;
    procedure DeleteFromParent;
    procedure LinkFields;
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(const FileName: String);
    procedure GetKeyFieldsValuesByParams(AParams: TBisParams; var AFields: string; var AValues: Variant);
    procedure GetKeyFieldsValues(var AFields: string; var AValues: Variant);
    function ParamByName(const ParamName: String; Counter: Integer=0): TBisParam;
    procedure Synchronize;

    procedure SetExecuteFrom(Source: TBisDataSet);
    procedure GetExecuteFrom(Source: TBisDataSet);

    procedure SetGetRecordsFrom(Source: TBisDataSet);
    procedure GetGetRecordsFrom(Source: TBisDataSet);

    property FieldNames: TBisFieldNames read FFieldNames;
    property FilterGroups: TBisFilterGroups read FFilterGroups;
    property Orders: TBisOrders read FOrders;
    property Params: TBisParams read FParams;
    property PackageBefore: TBisDataSetPackage read FPackageBefore;
    property PackageAfter: TBisDataSetPackage read FPackageAfter;
    property CollectionBefore: TBisDataSetCollection read FCollectionBefore;
    property CollectionAfter: TBisDataSetCollection read FCollectionAfter;

    property Empty: Boolean read GetEmpty;
    property CheckSum: String read GetCheckSum;

    property Data: String read GetData write SetData;
    property ProviderName: String read FProviderName write FProviderName;
    property FetchCount: Integer read FFetchCount write FFetchCount;
    property ServerRecordCount: Integer read FServerRecordCount write FServerRecordCount;
    property ParentDataSet: TBisDataSet read FParentDataSet write FParentDataSet;
    property TableName: String read FTableName write FTableName;
    property ExtendedSaving: Boolean read FExtendedSaving write FExtendedSaving;
    property InGetRecords: Boolean read FInGetRecords write FInGetRecords;
    property InExecute: Boolean read FInExecute write FInExecute;
    property OpenMode: TBisDataSetOpenMode read FOpenMode write FOpenMode;
    property UseCache: Boolean read FUseCache write FUseCache;
    property CalculateDisabled: Boolean read FCalculateDisabled write FCalculateDisabled;

    property OnUpdateCounters: TNotifyEvent read FOnUpdateCounters write FOnUpdateCounters;
    property OnSynchronize: TNotifyEvent read FOnSynchronize write FOnSynchronize;
{    property OnInternalExecute: TNotifyEvent read FOnInternalExecute write FOnInternalExecute;
    property OnInternalOpen: TNotifyEvent read FOnInternalOpen write FOnInternalOpen;}

  published

  end;

implementation

uses Windows, TypInfo, SysUtils, Variants, Math,
     BisUtils, BisConsts, BisDialogs, BisCrypter;

const
  BISFileVersion=1000;

{ TBisDataSetStreamFormat }

constructor TBisDataSetStreamFormat.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  sfUsingIndex:=[];
//  sfDeltas:=[];
//  sfCalculated:=[sfSaveCalculated,sfLoadCalculated];
  sfCalculated:=[];
  FileVersion:=BISFileVersion;
end;

procedure TBisDataSetStreamFormat.BeforeSave(ADataset: TkbmCustomMemTable);
begin
  inherited BeforeSave(ADataSet);
  if (FileVersion>=BISFileVersion) and Assigned(ADataSet) and (ADataSet is TBisDataSet) then begin
    Writer.WriteString(TBisDataSet(ADataSet).TableName);
  end;
end;

procedure TBisDataSetStreamFormat.BeforeLoad(ADataset: TkbmCustomMemTable);
begin
  inherited BeforeLoad(ADataSet);
  if (FileVersion>=BISFileVersion) and Assigned(ADataSet) and (ADataSet is TBisDataSet) then begin
    TBisDataSet(ADataSet).TableName:=Reader.ReadString;
  end;
end;

procedure TBisDataSetStreamFormat.AfterSave(ADataset: TkbmCustomMemTable);
var
  DS: TBisDataSet;
begin
  if Assigned(Writer) and (ADataSet is TBisDataSet) then begin
    DS:=TBisDataSet(ADataSet);
    if DS.FExtendedSaving then begin
      Writer.WriteString(DS.ProviderName);
      Writer.WriteInteger(DS.FetchCount);
      Writer.WriteInteger(DS.ServerRecordCount);
      DS.FieldNames.WriteData(Writer);
      DS.FilterGroups.WriteData(Writer);
      DS.Orders.WriteData(Writer);
      DS.Params.WriteData(Writer);
      DS.PackageBefore.WriteData(Writer);
      DS.PackageAfter.WriteData(Writer);
      DS.CollectionBefore.WriteData(Writer);
      DS.CollectionAfter.WriteData(Writer);
    end;
  end;
  inherited AfterSave(ADataSet);
end;

procedure TBisDataSetStreamFormat.AfterLoad(ADataset: TkbmCustomMemTable);
var
  DS: TBisDataSet;
begin
  if Assigned(Reader) and (ADataSet is TBisDataSet) then begin
    DS:=TBisDataSet(ADataSet);
    if DS.ExtendedSaving then begin
      DS.ProviderName:=Reader.ReadString;
      DS.FetchCount:=Reader.ReadInteger;
      DS.ServerRecordCount:=Reader.ReadInteger;
      DS.FieldNames.ReadData(Reader);
      DS.FilterGroups.ReadData(Reader);
      DS.Orders.ReadData(Reader);
      DS.Params.ReadData(Reader);
      DS.PackageBefore.ReadData(Reader);
      DS.PackageAfter.ReadData(Reader);
      DS.CollectionBefore.ReadData(Reader);
      DS.CollectionAfter.ReadData(Reader);
    end;
  end;
  inherited AfterLoad(ADataSet);
end;

{ TBisDataSetCollectionItem }

constructor TBisDataSetCollectionItem.Create;
begin
  inherited Create;
  FName:=GetUniqueID;
  FFieldNames:=TBisFieldNames.Create;
  FFilterGroups:=TBisFilterGroups.Create;
  FOrders:=TBisOrders.Create;
  FParams:=TBisParams.Create;
  FPackageBefore:=TBisPackageParams.Create;
  FPackageAfter:=TBisPackageParams.Create;
  FReturn:=TMemoryStream.Create;
end;

destructor TBisDataSetCollectionItem.Destroy;
begin
  FReturn.Free;
  FPackageAfter.Free;
  FPackageBefore.Free;
  FParams.Free;
  FOrders.Free;
  FFilterGroups.Free;
  FFieldNames.Free;
  inherited Destroy;
end;

function TBisDataSetCollectionItem.GetDataSet(DataSet: TBisDataSet): Boolean;
begin
  Result:=false;
  if Assigned(DataSet) and (FReturn.Size>0) then begin
    DataSet.BeginUpdate;
    try
      DataSet.Close;
      FReturn.Position:=0;
      DataSet.LoadFromStream(FReturn);
      FReturn.Position:=0;
      DataSet.First;
      Result:=DataSet.Active;
    finally
      DataSet.EndUpdate;
    end;
  end;
end;

procedure TBisDataSetCollectionItem.SetDataSet(DataSet: TBisDataSet);
begin
  if Assigned(DataSet) then begin
    if DataSet.Active then begin
      FReturn.Clear;
      DataSet.SaveToStream(FReturn);
      FReturn.Position:=0;
    end;
  end;
end;

{ TBisDataSetCollection }

function TBisDataSetCollection.Find(const Name: String): TBisDataSetCollectionItem;
var
  i: Integer;
  Item: TBisDataSetCollectionItem;
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

function TBisDataSetCollection.Add(OpenMode: TBisDataSetOpenMode=omOpen): TBisDataSetCollectionItem;
begin
  Result:=TBisDataSetCollectionItem.Create;
  Result.OpenMode:=OpenMode;
  inherited Add(Result);
end;

function TBisDataSetCollection.AddExecute: TBisDataSetCollectionItem;
begin
  Result:=Add(omExecute);
end;

function TBisDataSetCollection.AddOpen: TBisDataSetCollectionItem;
begin
  Result:=Add(omOpen);
end;

function TBisDataSetCollection.AddDataSet(DataSet: TBisDataSet): TBisDataSetCollectionItem;
begin
  Result:=nil;
  if Assigned(DataSet) then begin
    Result:=Add(DataSet.OpenMode);
    Result.ProviderName:=DataSet.ProviderName;
    Result.FieldNames.CopyFrom(DataSet.FieldNames,true);
    Result.FilterGroups.CopyFrom(DataSet.FilterGroups,true);
    Result.Orders.CopyFrom(DataSet.Orders,true);
    Result.Params.CopyFrom(DataSet.Params,true);
    Result.PackageBefore.CopyFrom(DataSet.PackageBefore,true);
    Result.PackageAfter.CopyFrom(DataSet.PackageAfter,true);
  end;
end;

function TBisDataSetCollection.GetItem(Index: Integer): TBisDataSetCollectionItem;
begin
  Result:=TBisDataSetCollectionItem(inherited Items[Index]);
end;

procedure TBisDataSetCollection.CopyFrom(Source: TBisDataSetCollection; WithClear: Boolean);
var
  i: Integer;
  ItemSource,ItemAdd: TBisDataSetCollectionItem;
begin
  if WithClear then
    Clear;
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      ItemSource:=Source.Items[i];
      ItemAdd:=Find(ItemSource.Name);
      if not Assigned(ItemAdd) then begin
        ItemAdd:=Add;
        ItemAdd.FName:=ItemSource.Name;
      end;
      ItemAdd.ProviderName:=ItemSource.ProviderName;
      ItemAdd.OpenMode:=ItemSource.OpenMode;
      ItemAdd.FieldNames.CopyFrom(ItemSource.FieldNames);
      ItemAdd.FilterGroups.CopyFrom(ItemSource.FilterGroups);
      ItemAdd.Orders.CopyFrom(ItemSource.Orders);
      ItemAdd.Params.CopyFrom(ItemSource.Params);
      ItemAdd.PackageBefore.CopyFrom(ItemSource.PackageBefore);
      ItemAdd.PackageAfter.CopyFrom(ItemSource.PackageAfter);

      ItemSource.FReturn.Position:=0;
      ItemAdd.FReturn.CopyFrom(ItemSource.FReturn,ItemSource.FReturn.Size);
    end;
  end;
end;

procedure TBisDataSetCollection.ReadData(Reader: TReader);
var
  Item: TBisDataSetCollectionItem;
begin
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    Item:=Add;
    if Assigned(Item) then begin
      Item.FName:=Reader.ReadString;
      Item.ProviderName:=Reader.ReadString;
      Item.OpenMode:=TBisDataSetOpenMode(Reader.ReadInteger);
      Item.FieldNames.ReadData(Reader);
      Item.FilterGroups.ReadData(Reader);
      Item.Orders.ReadData(Reader);
      Item.Params.ReadData(Reader);
      Item.PackageBefore.ReadData(Reader);
      Item.PackageAfter.ReadData(Reader);
      Item.FReturn.SetSize(Reader.ReadInteger);
      Reader.Read(Item.FReturn.Memory^,Item.FReturn.Size);
    end;
  end;
  Reader.ReadListEnd;
end;

procedure TBisDataSetCollection.WriteData(Writer: TWriter);
var
  i: Integer;
  Item: TBisDataSetCollectionItem;
begin
  Writer.WriteListBegin;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Writer.WriteString(Item.FName);
    Writer.WriteString(Item.ProviderName);
    Writer.WriteInteger(Integer(Item.OpenMode));
    Item.FieldNames.WriteData(Writer);
    Item.FilterGroups.WriteData(Writer);
    Item.Orders.WriteData(Writer);
    Item.Params.WriteData(Writer);
    Item.PackageBefore.WriteData(Writer);
    Item.PackageAfter.WriteData(Writer);
    Writer.WriteInteger(Item.FReturn.Size);
    Writer.Write(Item.FReturn.Memory^,Item.FReturn.Size);
  end;
  Writer.WriteListEnd;
end;

procedure TBisDataSetCollection.LoadFromStream(Stream: TStream);
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

procedure TBisDataSetCollection.SaveToStream(Stream: TStream);
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

{ TBisDataSet }

constructor TBisDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStreamFormat:=TBisDataSetStreamFormat.Create(nil);
  DefaultFormat:=FStreamFormat;
  FFieldNames:=TBisFieldNames.Create;
  FFilterGroups:=TBisFilterGroups.Create;
  FOrders:=TBisOrders.Create;
  FParams:=TBisParams.Create;
  FPackageBefore:=TBisDataSetPackage.Create;
  FPackageAfter:=TBisDataSetPackage.Create;
  FCollectionBefore:=TBisDataSetCollection.Create;
  FCollectionAfter:=TBisDataSetCollection.Create;
  FCalculateFieldNames:=TBisFieldNames.Create;
  FCalculateFieldNames.OwnsObjects:=false;

  FFetchCount:=-1;
  FSDisplayFormat:='DisplayFormat';
  
  FUseCache:=true;
  FNeedOpen:=true;

  IgnoreReadOnly:=true;
  FTempBookmark:=nil;
end;

destructor TBisDataSet.Destroy;
begin
  if Assigned(FTempBookmark) and
     BookmarkValid(FTempBookmark) then begin
    FreeBookmark(FTempBookmark);
  end;
  FCalculateFieldNames.Free; 
  FCollectionAfter.Free;
  FCollectionBefore.Free;
  FPackageAfter.Free;
  FPackageBefore.Free;
  FParams.Free;
  FOrders.Free;
  FFilterGroups.Free;
  FFieldNames.Free;
  DefaultFormat:=nil;
  FStreamFormat.Free;
  inherited Destroy;
end;

function TBisDataSet.GetCheckSum: String;
var
  Crypter: TBisCrypter;
  S,S1,S2,S3,S4,S5,S6,S7: String;
  i,j: Integer;
  FieldName: TBisFieldName;
  Param: TBisParam;
  FilterGroup: TBisFilterGroup;
  Filter: TBisFilter;
  Order: TBisOrder;
  Flag: Boolean;
begin
  Result:='';
  Crypter:=TBisCrypter.Create;
  try
    S:=ProviderName;

    for i:=0 to FieldNames.Count-1 do begin
      FieldName:=FieldNames.Items[i];
      if i=0 then
        S:=S+' FieldNames:'+FieldName.FieldName
      else
        S:=S+','+FieldName.FieldName;
    end;

    for i:=0 to Params.Count-1 do begin
      Param:=Params.Items[i];
      S1:=GetEnumName(TypeInfo(TParamType),Integer(Param.ParamType));
      S2:=VarToStrDef(Param.Value,'');
      S2:=Format('%s=%s (%s)',[Param.ParamName,S2,S1]);
      if i=0 then
        S:=S+' Params:'+S2
      else
        S:=S+','+S2;
    end;

    Flag:=true;
    for i:=0 to FilterGroups.Count-1 do begin
      FilterGroup:=FilterGroups.Items[i];
      if FilterGroup.Enabled then begin
        S1:=GetEnumName(TypeInfo(TBisFilterOperator),Integer(FilterGroup.&Operator));
        if Flag then begin
          S:=S+' FilterGroups:'+FilterGroup.GroupName;
          Flag:=false;
        end else                                                                              
          S:=S+','+S1+FilterGroup.GroupName;
        for j:=0 to FilterGroup.Filters.Count-1 do begin
          Filter:=FilterGroup.Filters.Items[j];
          S1:=GetEnumName(TypeInfo(TBisFilterCondition),Integer(Filter.Condition));
          S2:=VarToStrDef(Filter.Value,'');
          S3:=GetEnumName(TypeInfo(TBisFilterOperator),Integer(Filter.&Operator));
          S4:=GetEnumName(TypeInfo(TBisFilterType),Integer(Filter.FilterType));
          S5:=GetEnumName(TypeInfo(Boolean),Integer(Filter.CheckCase));
          S6:=GetEnumName(TypeInfo(Boolean),Integer(Filter.RightSide));
          S7:=GetEnumName(TypeInfo(Boolean),Integer(Filter.LeftSide));
          S7:=Format('%s %s %s (%s,%s,%s,%s,%s)',[Filter.FieldName,S1,S2,S3,S4,S5,S6,S7]);
          if j=0 then
            S:=S+' Filters='+S7
          else
            S:=S+','+S7;
        end;
      end;
    end;

    for i:=0 to Orders.Count-1 do begin
      Order:=Orders.Items[i];
      S1:=GetEnumName(TypeInfo(TBisOrderType),Integer(Order.OrderType));
      S2:=Format('%s=%s',[Order.FieldName,S1]);
      if i=0 then
        S:=S+' Orders:'+S2
      else
        S:=S+','+S2;
    end;

    Result:=Crypter.HashString(S,haMD5,hfHEX);
  finally
    Crypter.Free;
  end;
end;

function TBisDataSet.GetInfo(const Delimeter: String): String;
var
  i: Integer;
  S,T: String;
  Field: TField;
begin
  Result:='';
  for i:=0 to Fields.Count-1 do begin
    Field:=Fields[i];
    if not VarIsNull(Field.Value) then
      S:=VarToStrDef(Field.Value,'')
    else S:='NULL';
    if Length(S)>100 then
      S:=Copy(S,1,100)+' ...';
    T:=GetEnumName(TypeInfo(TFieldType),Integer(Field.DataType));
    T:=Copy(T,3,Length(T));
    if i=0 then
      Result:=Format('%s|%s=[%s]',[Field.FieldName,T,S])
    else
      Result:=Result+Delimeter+Format('%s|%s=[%s]',[Field.FieldName,T,S]);
  end;
  Result:=Trim(Result);
end;

procedure TBisDataSet.BeginUpdate(WithBookmark, WithFilter: Boolean);
begin
  FTempBookmark:=nil;
  if WithBookmark then
    FTempBookmark:=GetBookmark;
  DisableControls;
  FOldAfterScroll:=AfterScroll;
  AfterScroll:=nil;
  FOldBeforeScroll:=BeforeScroll;
  BeforeScroll:=nil;
  FOldBeforePost:=BeforePost;
  BeforePost:=nil;
  FOldFilter:=Filter;
  if not WithFilter then
    Filter:='';
  FOldFiltered:=Filtered;
  if FOldFiltered<>Filtered then
    Filtered:=false;
  FOldReadOnly:=ReadOnly;
  ReadOnly:=false;
end;

procedure TBisDataSet.EmptyTable;
begin
  inherited EmptyTable;
  DoUpdateCounters;
end;

procedure TBisDataSet.EndUpdate(WithScroll: Boolean);
begin
  ReadOnly:=FOldReadOnly;
  Filter:=FOldFilter;
  if FOldFiltered<>Filtered then
    Filtered:=FOldFiltered;
  if Active and
     Assigned(FTempBookmark) and
     BookmarkValid(FTempBookmark) then begin
    GotoBookmark(FTempBookmark);
    FreeBookmark(FTempBookmark);
    FTempBookmark:=nil;
  end;
  BeforePost:=FOldBeforePost;
  BeforeScroll:=FOldBeforeScroll;
  EnableControls;
  AfterScroll:=FOldAfterScroll;
  if WithScroll and Assigned(AfterScroll) then
    AfterScroll(Self);
end;

procedure TBisDataSet.ThrowBookmark;
begin
  FTempBookmark:=nil;
end;

procedure TBisDataSet.MoveData(Up: Boolean);
var
  isLast: Boolean;
  TempDataSet: TBisDataSet;
begin
  if Active and not IsEmpty then begin
    isLast:=RecNo=RecordCount;
    TempDataSet:=TBisDataSet.Create(nil);
    try
      TempDataSet.CreateTableAs(Self,[]);
      TempDataSet.Open;
      TempDataSet.Append;
      TempDataSet.CopyFields(Self);
      TempDataSet.Post;
      with Self do begin
        Delete;
        if Up then begin
          if not isLast then
            Prior;
          Insert;
        end else begin
          Next;
          if not Eof then
            Insert
          else Append;
        end;
        try
          Self.CopyFields(TempDataSet);
        finally
          Post;
        end;
      end;
    finally
      TempDataSet.Free;
    end;
  end;
end;

function TBisDataSet.GetData: String;
var
  Stream: TMemoryStream;
begin
  Stream:=TMemoryStream.Create;
  try
    SaveToStream(Stream);
    SetLength(Result,Stream.Size);
    Stream.Position:=0;
    Stream.Read(Pointer(Result)^,Stream.Size);
  finally
    Stream.Free;
  end;
end;

function TBisDataSet.GetEmpty: Boolean;
begin
  Result:=IsEmpty;
end;

procedure TBisDataSet.SetData(Value: String);
var
  Stream: TMemoryStream;
begin
  Stream:=TMemoryStream.Create;
  try
    Stream.Write(Pointer(Value)^,Length(Value));
    try
      Stream.Position:=0;
      LoadFromStream(Stream);
    except
    end;
  finally
    Stream.Free;
  end;
end;

{procedure TBisDataSet.CreateTableAsDataSet(DataSet: TDataSet; WithRecords: Boolean);
begin
  CreateTableAs(DataSet,[]);
  if WithRecords then
    LoadFromDataSet(DataSet,[]);
end;}

procedure TBisDataSet.CreateStructure(Source: TDataSet; IsClear: Boolean);
var
  i: Integer;
  AField: TField;
  FieldDef: TFieldDef;
  APrecision: Integer;
const
  SPrecision='Precision';
begin
  if Assigned(Source) then begin
    Close;
    if IsClear then
      FieldDefs.Clear;

    for i:=0 to Source.Fields.Count-1 do begin
      FieldDef:=FieldDefs.AddFieldDef;
      AField:=Source.Fields[i];
      FieldDef.Name:=AField.FieldName;
      if (AField.DataType in [ftBCD]) and
         (AField.Size=0) then begin
        FieldDef.DataType:=ftInteger;
      end else
        FieldDef.DataType:=AField.DataType;
      FieldDef.Size:=AField.Size;
      APrecision:=0;
      if IsPublishedProp(AField,SPrecision) then
        APrecision:=GetOrdProp(AField,SPrecision);
      FieldDef.Precision:=APrecision;
      FieldDef.Required:=false;
      FieldDef.InternalCalcField:=AField.FieldKind=fkInternalCalc;
    end;

    InitCalcFieldDefs;

  end;
end;

procedure TBisDataSet.CreateTable(Source: TDataSet);
var
  Old: Boolean;
begin
  Old:=FNeedOpen;
  try
    FNeedOpen:=false;
    CreateStructure(Source);
    inherited CreateTable;
    Open;
  finally
    FNeedOpen:=Old;
  end;
end;

procedure TBisDataSet.CopyFrom(Source: TBisDataSet);
var
  Stream: TMemoryStream;
begin
  if Assigned(Source) then begin
    Stream:=TMemoryStream.Create;
    try
      Source.SaveToStream(Stream);
      Stream.Position:=0;
      LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;
end;

procedure TBisDataSet.CopyRecord(Source: TDataSet; AppenRecord, ChangeMode: Boolean);
var
  i: Integer;
  Field: TField;
  AValue: Variant;
begin
  if ChangeMode then begin
    CheckBrowseMode;
    if AppenRecord then
      Append
    else
      Edit;
  end;
  try
    for i:=0 to Source.Fields.Count-1 do begin
      with Source.Fields[i] do begin
        AValue:=Value;
        Field:=Fields.FindField(FieldName);
        if Assigned(Field) then begin
          if not VarIsNull(AValue) then begin
            Field.Clear;
            Field.Value:=AValue;
          end else begin
            Field.Value:=Null;
          end;
        end;
      end;
    end;
  finally
    if ChangeMode then
      Post;
  end;
end;

procedure TBisDataSet.CopyRecords(Source: TDataSet);
begin
  if Assigned(Source) then begin
    if Source.Active then begin
      Source.DisableControls;
      try
        Source.First;
        while not Source.Eof do begin
          CopyRecord(Source);
          Source.Next;
        end;
      finally
        Source.EnableControls;
      end;
    end;
  end;
end;

procedure TBisDataSet.LinkFields;
var
  i: Integer;
  Def: TBisFieldName;
  Field: TField;
begin
  FCalculateFieldNames.Clear;
  for i:=0 to Fields.Count-1 do begin
    Field:=Fields[i];
    Def:=FFieldNames.Find(Field.FieldName);
    if Assigned(Def) then begin
      Def.Field:=Field;
      if Def.Calculated then begin
        if Assigned(Def.OnCalculate) then
          FCalculateFieldNames.Add(Def);
      end else
        Field.ReadOnly:=false;
      if IsPublishedProp(Field,FSDisplayFormat) then begin
        SetPropValue(Field,FSDisplayFormat,Def.DisplayFormat);
      end;
    end;
  end;
end;

procedure TBisDataSet.LoadFromFile(const FileName: String);
var
  Old: Boolean;
begin
  Old:=FNeedOpen;
  try
    FNeedOpen:=false;
    Close;
    inherited LoadFromFile(FileName);
    Open;
    LinkFields;
  finally
    FNeedOpen:=Old;
  end;
end;

procedure TBisDataSet.LoadFromStream(Stream: TStream);
var
  Old: Boolean;
begin
  Old:=FNeedOpen;
  try
    FNeedOpen:=false;
    Close;
    inherited LoadFromStream(Stream);
    Open;
    LinkFields;
  finally
    FNeedOpen:=Old;
  end;
end;

function TBisDataSet.Locate(const KeyFields: string; const KeyValues: Variant; Options: TLocateOptions): Boolean;
begin
  Result:=inherited Locate(KeyFields,KeyValues,Options);
end;

procedure TBisDataSet.CreateFields;
begin
  inherited CreateFields;
  LinkFields;
end;

procedure TBisDataSet.DestroyFields;
var
  i: Integer;
  Def: TBisFieldName;
begin
  inherited DestroyFields;
  for i:=0 to FFieldNames.Count-1 do begin
    Def:=FFieldNames.Items[i];
    Def.Field:=nil;
  end;
end;

procedure TBisDataSet.InitCalcFieldDefs;
var
  i: Integer;
  Def: TBisFieldName;
  FieldDef: TFieldDef;
  Index: Integer;
begin
  for i:=0 to FFieldNames.Count-1 do begin
    Def:=FFieldNames.Items[i];
    if Def.Calculated then begin
      Index:=FieldDefs.IndexOf(Def.FieldName);
      if Index=-1 then begin
        FieldDef:=FieldDefs.AddFieldDef;
        with FieldDef do begin
          Name:=Def.FieldName;
          DataType:=Def.DataType;
          Size:=Def.Size;
          Precision:=Def.Precision;
          InternalCalcField:=true;
        end;
      end;
    end;
  end;
end;

procedure TBisDataSet.InternalInitFieldDefs;
begin
  inherited InternalInitFieldDefs;
  InitCalcFieldDefs;
end;

procedure TBisDataSet.Sort(const FieldNames: String; SortType: TBisDataSetSortType);
var
  Options: TkbmMemTableCompareOptions;
begin
  Options:=[];
  case SortType of
    otNone: SortDefault;
    otAsc: SortOn(FieldNames,Options);
    otDesc: begin
      Options:=Options+[mtcoDescending];
      SortOn(FieldNames,Options);
    end;
  end;
end;

procedure TBisDataSet.Synchronize;
begin
  DoSynchronize;
end;

procedure TBisDataSet.DoInternalOpen;
begin
{  if Assigned(FOnInternalOpen) then
    FOnInternalOpen(Self);}
end;

procedure TBisDataSet.InternalOpen;
var
  AFilterGroups: TBisFilterGroups;
  AFields: TStringList;
  i: Integer;
  Field: TField;
begin
  if FNeedOpen and not FInGetRecords and
    ((Trim(FProviderName)<>'') or (FCollectionBefore.Count>0) or (FCollectionAfter.Count>0) or 
     (Assigned(FParentDataSet) and FParentDataSet.Active) or not Active)then begin
     
    FInGetRecords:=true;
    AFilterGroups:=TBisFilterGroups.Create;
    AFilterGroups.CopyFrom(FFilterGroups);
    try

      if FOpenMode=omOpen then begin

        if Assigned(MasterSource) and Assigned(MasterSource.DataSet) and
           MasterSource.DataSet.Active and
          (Trim(MasterFields)<>'') then begin
          AFields:=TStringList.Create;
          try
            GetStringsByString(MasterFields,';',AFields);
            if AFields.Count>0 then begin
              with FFilterGroups.Add do begin
                for i:=0 to AFields.Count-1 do begin
                  Field:=MasterSource.DataSet.FindField(AFields[i]);
                  if Assigned(Field) then begin
                    if not VarIsNull(Field.Value) then
                      Filters.Add(AFields[i],fcEqual,Field.Value)
                    else
                      Filters.Add(AFields[i],fcIsNull,Null);
                  end;
                end;
              end;
            end;
          finally
            AFields.Free;
          end;
        end;


        if (Trim(FProviderName)<>'') or (FCollectionBefore.Count>0) or (FCollectionAfter.Count>0) then begin

          DoInternalOpen;

        end else begin

          if Assigned(FParentDataSet) and FParentDataSet.Active then begin
            CreateTable(FParentDataSet);
            BeginUpdate;
            try
              CopyRecords(FParentDataSet);
              First;
            finally
              EndUpdate;
            end;
          end else
            inherited InternalOpen;
        end;

      end else
        InternalExecute;

    finally
      FFilterGroups.CopyFrom(AFilterGroups);
      AFilterGroups.Free;
      FInGetRecords:=false;
    end;
  end else
    inherited InternalOpen;
end;

procedure TBisDataSet.DoInternalClose;
begin
  //
end;

procedure TBisDataSet.DoInternalExecute;
begin
{  if Assigned(FOnInternalExecute) then
    FOnInternalExecute(Self);}
end;

procedure TBisDataSet.InternalClose;
begin
  inherited InternalClose;
  DoInternalClose;
end;

procedure TBisDataSet.InternalExecute;
begin
  if not FInExecute and
     ((Trim(FProviderName)<>'') or (FCollectionBefore.Count>0) or (FCollectionAfter.Count>0)) then begin

    FInExecute:=true;
    try
      Params.ValueToStored;

      DoInternalExecute;
      
    finally
      FInExecute:=false;
    end;
  end;
end;

procedure TBisDataSet.OpenWithExecute;
var
  OldMode: TBisDataSetOpenMode;
begin
  OldMode:=FOpenMode;
  try
    FOpenMode:=omExecute;
    Open;
  finally
    FOpenMode:=OldMode;
  end;
end;

function TBisDataSet.ParamByName(const ParamName: String; Counter: Integer=0): TBisParam;
begin
  Result:=FParams.ParamByName(ParamName,Counter);
end;

procedure TBisDataSet.Execute;
begin
  InternalExecute;
end;

function TBisDataSet.GetFieldValue(FieldName: String; var Value: Variant): Boolean;
var
  Param: TBisParam;
begin
  Param:=FParams.Find(FieldName);
  if not Assigned(Param) then
    Param:=FParams.FindByDuplicate(FieldName);
  Result:=Assigned(Param);
  if Result then begin
    if Param.Empty then
      Value:=Null
    else
      Value:=Param.StoredValue;
  end;
end;

procedure TBisDataSet.InsertIntoParent;
var
  i: Integer;
  Field: TField;
  Value: Variant;
begin
  if Assigned(FParentDataSet) and FParentDataSet.Active then begin
    FParentDataSet.BeginUpdate(false);
    try
      FParentDataSet.Append;
      for i:=0 to FParentDataSet.Fields.Count-1 do begin
        Field:=FParentDataSet.Fields[i];
        if GetFieldValue(Field.FieldName,Value) then
          Field.Value:=Value;
      end;
      FParentDataSet.Post;
      FParentDataSet.ServerRecordCount:=FParentDataSet.ServerRecordCount+1;
      FParentDataSet.DoUpdateCounters;
    finally
      FParentDataSet.EndUpdate(true);
    end;
  end;
end;

procedure TBisDataSet.GetFieldNames(List: TStrings);
var
  OldFetchCount: Integer;
begin
  inherited GetFieldNames(List);
  if List.Count=0 then begin
    OldFetchCount:=FetchCount;
    try
      FetchCount:=0;
      Open;
      inherited GetFieldNames(List);
    finally
      FetchCount:=OldFetchCount; 
    end;
  end;
end;

function TBisDataSet.FindFieldByParam(Param: TBisParam): TField;
var
  i: Integer;
begin
  Result:=FindField(Param.ParamName);
  if not Assigned(Result) then begin
    for i:=0 to Param.Duplicates.Count-1 do begin
      Result:=FindField(Param.Duplicates[i]);
      if Assigned(Result) then
        exit;
    end;
  end;
end;

procedure TBisDataSet.GetKeyFieldsValuesByParams(AParams: TBisParams; var AFields: string; var AValues: Variant);
var
  i: Integer;
  Field: TField;
  ACount: Integer;
  Item: TBisParam;
begin
  if Assigned(AParams) and (AParams.Count>0) then begin
    with AParams do begin
      ACount:=0;
      for i:=0 to Count-1 do begin
        Item:=Items[i];
        Field:=FindFieldByParam(Item);
        if Assigned(Field) and Item.IsKey then
          Inc(ACount);
      end;

      if ACount>0 then begin
        AValues:=VarArrayCreate([0,ACount-1],varVariant);
        ACount:=0;
        for i:=0 to Count-1 do begin
          Item:=Items[i];
          Field:=FindFieldByParam(Item);
          if Assigned(Field) and Item.IsKey then begin
            if ACount=0 then AFields:=Field.FieldName
            else AFields:=AFields+';'+Field.FieldName;
            AValues[ACount]:=Item.OldValue;
            inc(ACount);
          end;
        end;
      end;
    end;
  end;
end;

procedure TBisDataSet.GetKeyFieldsValues(var AFields: string; var AValues: Variant);
var
  i: Integer;
  Field: TField;
  ACount: Integer;
  Item: TBisFieldName;
begin
  if Active and not IsEmpty and (FFieldNames.Count>0) then begin
    with FFieldNames do begin
      ACount:=0;
      for i:=0 to Count-1 do begin
        Item:=Items[i];
        Field:=FindField(Item.FieldName);
        if Assigned(Field) and Item.IsKey then
          Inc(ACount);
      end;

      if ACount>0 then begin
        AValues:=VarArrayCreate([0,ACount-1],varVariant);
        ACount:=0;
        for i:=0 to Count-1 do begin
          Item:=Items[i];
          Field:=FindField(Item.FieldName);
          if Assigned(Field) and Item.IsKey then begin
            if ACount=0 then AFields:=Item.FieldName
            else AFields:=AFields+';'+Item.FieldName;
            AValues[ACount]:=Field.Value;
            inc(ACount);
          end;
        end;
      end;
    end;
  end;
end;

procedure TBisDataSet.UpdateIntoParent;
var
  i: Integer;
  AFields: string;
  AValues: Variant;
  Field: TField;
  FlagFound: Boolean;
  Value: Variant;
begin
  if Assigned(FParentDataSet) and FParentDataSet.Active then begin

    FlagFound:=false;

    FParentDataSet.BeginUpdate(false);
    try
      FParentDataSet.GetKeyFieldsValuesByParams(FParams,AFields,AValues);
      if (Trim(AFields)<>'') then
        FlagFound:=FParentDataSet.Locate(AFields,AValues,[loCaseInsensitive]);

      if FlagFound then begin
        FParentDataSet.Edit;
        for i:=0 to FParentDataSet.Fields.Count-1 do begin
          Field:=FParentDataSet.Fields[i];
          if GetFieldValue(Field.FieldName,Value) then
            Field.Value:=Value;
        end;
        FParentDataSet.DoSynchronize;
        FParentDataSet.Post;
        FParentDataSet.DoUpdateCounters;
      end;
    finally
      FParentDataSet.EndUpdate(true);
    end;
  end;
end;

procedure TBisDataSet.DeleteFromParent;
var
  AFields: string;
  AValues: Variant;
begin
  if Assigned(FParentDataSet) and FParentDataSet.Active and not FParentDataSet.IsEmpty then begin
    FParentDataSet.BeginUpdate(false);
    try
      FParentDataSet.GetKeyFieldsValuesByParams(FParams,AFields,AValues);
      if (Trim(AFields)<>'') then begin
        if FParentDataSet.Locate(AFields,AValues,[loCaseInsensitive]) then begin
          FParentDataSet.Delete;
          FParentDataSet.ServerRecordCount:=FParentDataSet.ServerRecordCount-1;
          FParentDataSet.DoUpdateCounters;
        end;
      end;
    finally
      FParentDataSet.EndUpdate(true);
    end;
  end;
end;

procedure TBisDataSet.DoOnCalcFields;
var
  i: Integer;
  FieldName: TBisFieldName;
begin
 if not FCalculateDisabled then begin
   inherited DoOnCalcFields;
   with FCalculateFieldNames do begin
     for i:=0 to Count-1 do begin
       FieldName:=Items[i];
       Self.FieldByName(FieldName.FieldName).Value:=FieldName.OnCalculate(FieldName,Self);
     end;
   end;
 end;
end;

procedure TBisDataSet.DoSynchronize;
begin
  if Assigned(FOnSynchronize) then
    FOnSynchronize(Self);
end;

procedure TBisDataSet.DoUpdateCounters;
begin
  if Assigned(FOnUpdateCounters) then
    FOnUpdateCounters(Self);
end;

procedure TBisDataSet.CopyCollection(CollectionFrom,CollectionTo: TBisDataSetCollection; Stream: TMemoryStream);
var
  i: Integer;
  ItemSource, ItemAdd: TBisDataSetCollectionItem;
begin
  CollectionTo.Clear;
  for i:=0 to CollectionFrom.Count-1 do begin
    ItemSource:=CollectionFrom.Items[i];
    ItemAdd:=CollectionTo.Add;

    ItemAdd.FName:=ItemSource.FName;
    ItemAdd.ProviderName:=ItemSource.ProviderName;
    ItemAdd.OpenMode:=ItemSource.OpenMode;

    Stream.Clear;
    ItemSource.FieldNames.SaveToStream(Stream);
    Stream.Position:=0;
    ItemAdd.FieldNames.LoadFromStream(Stream);

    Stream.Clear;
    ItemSource.FilterGroups.SaveToStream(Stream);
    Stream.Position:=0;
    ItemAdd.FilterGroups.LoadFromStream(Stream);

    Stream.Clear;
    ItemSource.Orders.SaveToStream(Stream);
    Stream.Position:=0;
    ItemAdd.Orders.LoadFromStream(Stream);

    Stream.Clear;
    ItemSource.Params.SaveToStream(Stream);
    Stream.Position:=0;
    ItemAdd.Params.LoadFromStream(Stream);

    Stream.Clear;
    ItemSource.PackageBefore.SaveToStream(Stream);
    Stream.Position:=0;
    ItemAdd.PackageBefore.LoadFromStream(Stream);

    Stream.Clear;
    ItemSource.PackageAfter.SaveToStream(Stream);
    Stream.Position:=0;
    ItemAdd.PackageAfter.LoadFromStream(Stream);
  end;
end;

procedure TBisDataSet.CopyPackage(PackageFrom, PackageTo: TBisPackageParams; Stream: TMemoryStream);
var
  Package: TBisPackageParams;
begin
  Package:=TBisPackageParams.Create;
  try
    Package.CopyFrom(PackageFrom,true,false);
    Stream.Clear;
    Package.SaveToStream(Stream);
    Stream.Position:=0;
    PackageTo.ReadDataOnlyInvisible:=true;
    PackageTo.LoadFromStream(Stream);
  finally
    Package.Free;
  end;
end;

procedure TBisDataSet.SetExecuteFrom(Source: TBisDataSet);
var
  Stream: TMemoryStream;
  AParams: TBisParams;
begin
  if Assigned(Source) then begin
    Stream:=TMemoryStream.Create;
    AParams:=TBisParams.Create;
    try
      FProviderName:=Source.ProviderName;
      FFetchCount:=Source.FetchCount;
      FInGetRecords:=Source.InGetRecords;
      FUseCache:=Source.UseCache;
      FOpenMode:=Source.OpenMode;

      Source.FieldNames.SaveToStream(Stream);
      Stream.Position:=0;
      FFieldNames.LoadFromStream(Stream);

      Stream.Clear;
      Source.FilterGroups.SaveToStream(Stream);
      Stream.Position:=0;
      FFilterGroups.LoadFromStream(Stream);

      Stream.Clear;
      Source.Orders.SaveToStream(Stream);
      Stream.Position:=0;
      FOrders.LoadFromStream(Stream);

      AParams.CopyFrom(Source.Params,true,false);
      Stream.Clear;
      AParams.SaveToStream(Stream);
      Stream.Position:=0;
      FParams.ReadDataOnlyInvisible:=true;
      FParams.LoadFromStream(Stream);

      CopyPackage(Source.PackageBefore,FPackageBefore,Stream);
      CopyPackage(Source.PackageAfter,FPackageAfter,Stream);

      CopyCollection(Source.CollectionBefore,FCollectionBefore,Stream);
      CopyCollection(Source.CollectionAfter,FCollectionAfter,Stream);

    finally
      AParams.Free;
      Stream.Free;
    end;
  end;
end;

procedure TBisDataSet.GetExecuteFrom(Source: TBisDataSet);
var
  Stream: TMemoryStream;
begin
  if Assigned(Source) then begin
    Stream:=TMemoryStream.Create;
    try
      if Source.Active then begin
        Source.SaveToStream(Stream);
        Stream.Position:=0;
        if Stream.Size>0 then begin
          BeginUpdate;
          try
            LoadFromStream(Stream);
            First;
          finally
            EndUpdate;
          end;
        end;
      end;
      FServerRecordCount:=Source.ServerRecordCount;

      FParams.CopyFrom(Source.Params,false,false,[ptOutput,ptInputOutput,ptResult]);

      FPackageBefore.CopyFrom(Source.PackageBefore,false,false,[ptOutput,ptInputOutput,ptResult]);
      FPackageAfter.CopyFrom(Source.PackageAfter,false,false,[ptOutput,ptInputOutput,ptResult]);

      FCollectionBefore.CopyFrom(Source.CollectionBefore,false);
      FCollectionAfter.CopyFrom(Source.CollectionAfter,false);
    finally
      Stream.Free;
    end;
  end;
end;

procedure TBisDataSet.SetGetRecordsFrom(Source: TBisDataSet);
var
  Stream: TMemoryStream;
  AParams: TBisParams;
begin
  if Assigned(Source) then begin
    Stream:=TMemoryStream.Create;
    AParams:=TBisParams.Create;
    try
      FProviderName:=Source.ProviderName;
      FFetchCount:=Source.FetchCount;
      FInGetRecords:=Source.InGetRecords;
      FUseCache:=Source.UseCache;
      FOpenMode:=Source.OpenMode;

      Source.FieldNames.SaveToStream(Stream);
      Stream.Position:=0;
      FFieldNames.LoadFromStream(Stream);

      Stream.Clear;
      Source.FilterGroups.SaveToStream(Stream);
      Stream.Position:=0;
      FFilterGroups.LoadFromStream(Stream);

      Stream.Clear;
      Source.Orders.SaveToStream(Stream);
      Stream.Position:=0;
      FOrders.LoadFromStream(Stream);

{      Stream.Clear;
      Source.Params.SaveToStream(Stream);
      Stream.Position:=0;
      FParams.LoadFromStream(Stream);

      Stream.Clear;
      Source.PackageBefore.SaveToStream(Stream);
      Stream.Position:=0;
      FPackageBefore.LoadFromStream(Stream);

      Stream.Clear;
      Source.PackageAfter.SaveToStream(Stream);
      Stream.Position:=0;
      FPackageAfter.LoadFromStream(Stream);}

      AParams.CopyFrom(Source.Params,true,false);
      Stream.Clear;
      AParams.SaveToStream(Stream);
      Stream.Position:=0;
      FParams.ReadDataOnlyInvisible:=true;
      FParams.LoadFromStream(Stream);

      CopyPackage(Source.PackageBefore,FPackageBefore,Stream);
      CopyPackage(Source.PackageAfter,FPackageAfter,Stream);

      CopyCollection(Source.CollectionBefore,FCollectionBefore,Stream);
      CopyCollection(Source.CollectionAfter,FCollectionAfter,Stream);

    finally
      AParams.Free;
      Stream.Free;
    end;
  end;
end;

procedure TBisDataSet.GetGetRecordsFrom(Source: TBisDataSet);
var
  Stream: TMemoryStream;
begin
  if Assigned(Source) then begin
    Stream:=TMemoryStream.Create;
    try
      if Source.Active then begin
        Source.SaveToStream(Stream);
        Stream.Position:=0;
        if Stream.Size>0 then begin
          BeginUpdate;
          try
            LoadFromStream(Stream);
            First;
          finally
            EndUpdate;
          end;
        end;
      end;
      FServerRecordCount:=Source.ServerRecordCount;

      FPackageBefore.CopyFrom(Source.PackageBefore,false,false,[ptOutput,ptInputOutput,ptResult]);
      FPackageAfter.CopyFrom(Source.PackageAfter,false,false,[ptOutput,ptInputOutput,ptResult]);

      FCollectionBefore.CopyFrom(Source.CollectionBefore,false);
      FCollectionAfter.CopyFrom(Source.CollectionAfter,false);
    finally
      Stream.Free;
    end;
  end;
end;

end.
