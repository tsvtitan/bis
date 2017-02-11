unit BisDBTree;

interface

uses Windows, Classes, Controls, Graphics, DB, Contnrs,
     VirtualTrees;

type
  TBisDBTreeColumn=class;

  TBisDBTreeNodeDataValue=class(TObject)
  public
    var Column: TBisDBTreeColumn;
    var Value: Variant;
  end;

  TBisDBTreeNodeDataValues=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisDBTreeNodeDataValue;
  public
    function Find(Column: TBisDBTreeColumn): TBisDBTreeNodeDataValue;
    function FindField(Field: TField): TBisDBTreeNodeDataValue;
    function Add(Column: TBisDBTreeColumn; Value: Variant): TBisDBTreeNodeDataValue;

    procedure Resync;

    property Items[Index: Integer]: TBisDBTreeNodeDataValue read GetItem; default;
  end;

  TBisDBTreeNodeData=record
    Bookmark: Pointer;
    RecNo: Integer;
    Values: TBisDBTreeNodeDataValues;
  end;
  PBisDBTreeNodeData=^TBisDBTreeNodeData;

  TBisDBTree=class;

  TBisDBTreeDataLink=class(TDataLink)
  private
    FTree: TBisDBTree;
    FInserting: Boolean;
    FAppend: Boolean;

    FOldDataSetBeforeInsert: TDataSetNotifyEvent;
    FOldDataSetAfterInsert: TDataSetNotifyEvent;
    FOldDataSetAfterPost: TDataSetNotifyEvent;
    FOldDataSetAfterCancel: TDataSetNotifyEvent;
    FOldDataSetBeforeDelete: TDataSetNotifyEvent;
    FOldDataSetAfterDelete: TDataSetNotifyEvent;

    procedure SetOldDataSetEvents;
    procedure SetNewDataSetEvents;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);

    procedure DataSetBeforeInsert(DataSet: TDataSet);
    procedure DataSetAfterInsert(DataSet: TDataSet);
    procedure DataSetAfterPost(DataSet: TDataSet);
    procedure DataSetAfterCancel(DataSet: TDataSet);
    procedure DataSetBeforeDelete(DataSet: TDataSet);
    procedure DataSetAfterDelete(DataSet: TDataSet);
  protected
    procedure DataEvent(Event: TDataEvent; Info: Longint); override;
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure RecordChanged(Field: TField); override;
  public
    constructor Create(ATree: TBisDBTree);
    destructor Destroy; override;

    property Tree: TBisDBTree read FTree;

    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

  TBisDBTreeColumn=class(TVirtualTreeColumn)
  private
    FFieldName: String;
    FDisplayFormat: String;
    procedure SetFieldName(const Value: String);
    function GetField: TField;
  protected
    function GetTree: TBisDBTree;
  public
    property FieldName: String read FFieldName write SetFieldName;
    property DisplayFormat: String read FDisplayFormat write FDisplayFormat;
    property Field: TField read GetField;
  end;

  TBisDBTreeHeader=class;

  TBisDBTreeColumns=class(TVirtualTreeColumns)
  private
    function GetItem(Index: TColumnIndex): TBisDBTreeColumn;
    procedure SetItem(Index: TColumnIndex; const Value: TBisDBTreeColumn);
    function GetHeader: TBisDBTreeHeader;
  public
    function Add: TBisDBTreeColumn; reintroduce;

    property Header: TBisDBTreeHeader read GetHeader;

    property Items[Index: TColumnIndex]: TBisDBTreeColumn read GetItem write SetItem; default;
  end;

  TBisDBTreeHeader=class(TVTHeader)
  private
    function GetColumns: TBisDBTreeColumns;
    function GetTree: TBisDBTree;
  protected
    function GetColumnsClass: TVirtualTreeColumnsClass; override;
  public
    property Columns: TBisDBTreeColumns read GetColumns;
    property Tree: TBisDBTree read GetTree;
  end;

  TBisDBTreeProgressEvent=procedure(Sender: TBisDBTree; Min,Max,Position: Integer; var Breaked: Boolean) of object;

  TBisDBTree=class(TVirtualStringTree)
  private
    FDataLink: TBisDBTreeDataLink;
    FDataLinkActiveChanging: Boolean;
    FDataLinkDataSetChanging: Boolean;
    FDataLinkRecordChanging: Boolean;
    FDataLinkDataSetDeleting: Boolean;
    FDataLinkDataSetInserting: Boolean;
    FGettingText: Boolean;
    FGridEmulate: Boolean;
    FFocusChanging: Boolean;
    FOnProgress: TBisDBTreeProgressEvent;
    FKeyFields: TStringList;
    FParentFields: TStringList;

    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    function GetHeader: TBisDBTreeHeader;
    function GetSelectedField: TField;
    function FindNode(RecNo: Integer): PVirtualNode;
    procedure SelectNode(Node: PVirtualNode; Scroll: Boolean);
    procedure RefreshNodeRecNo(Node: PVirtualNode; Offset: Integer);
    procedure RefreshNodes;
    function FindFields(Strings: TStrings): Boolean;

    procedure BeforeDataEvent(Event: TDataEvent);
    procedure DataLinkActiveChanged;
    procedure DataLinkDataSetChanged;
    procedure DataLinkRecordChanged(Field: TField);
    procedure DataLinkDataSetDelete(After: Boolean);
    procedure DataLinkDataSetInsertOrAppend(Append: Boolean);
    procedure DataLinkDataSetAfterPost;

    procedure SetGridEmulate(const Value: Boolean);
    procedure SetSearchEnabled(const Value: Boolean);
    function GetMultiSelect: Boolean;
    procedure SetMultiSelect(const Value: Boolean);
    function GetSearchEnabled: Boolean;
    function GetKeyFieldName: String;
    procedure SetKeyFieldName(const Value: String);
    function GetParentFieldName: String;
    procedure SetParentFieldName(const Value: String);
  protected
    function GetDataSet: TDataSet;
    function GetColumnClass: TVirtualTreeColumnClass; override;
    function GetHeaderClass: TVTHeaderClass; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure DoFreeNode(Node: PVirtualNode); override;
    procedure DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex; TextType: TVSTTextType); override;
    procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString); override;
    procedure DoFocusChange(Node: PVirtualNode; Column: TColumnIndex); override;

    procedure DoReadNode(Node: PVirtualNode); virtual;
    procedure DoProgress(Min,Max,Position: Integer; var Breaked: Boolean); virtual;

    property DataLink: TBisDBTreeDataLink read FDataLink;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CancelIncrementalSearch; override;

    property Header: TBisDBTreeHeader read GetHeader;
    property SelectedField: TField read GetSelectedField;

    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property GridEmulate: Boolean read FGridEmulate write SetGridEmulate;
    property SearchEnabled: Boolean read GetSearchEnabled write SetSearchEnabled;
    property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
    property KeyFieldName: String read GetKeyFieldName write SetKeyFieldName;
    property ParentFieldName: String read GetParentFieldName write SetParentFieldName;

    property OnProgress: TBisDBTreeProgressEvent read FOnProgress write FOnProgress; 
  end;

implementation

uses SysUtils, Consts, DBConsts, Variants, Themes, Forms;

function GetStringByStrings(Strings: TStrings; Delim: String): String;
var
  i: Integer;
begin
  Result:='';
  for i:=0 to Strings.Count-1 do begin
    if i=0 then
      Result:=Strings[i]
    else
      Result:=Result+Delim+Strings[i]
  end;
end;

procedure GetStringsByString(S: String; Delim: String; Strings: TStrings);
var
  Apos: Integer;
  S1,S2: String;
begin
  if Assigned(Strings) then begin
    Apos:=-1;
    S2:=S;
    while Apos<>0 do begin
      Apos:=AnsiPos(Delim,S2);
      if Apos>0 then begin
        S1:=Copy(S2,1,Apos-Length(Delim));
        S2:=Copy(S2,Apos+Length(Delim),Length(S2));
        if S1<>'' then
          Strings.AddObject(S1,TObject(Apos))
        else begin
          if Length(S2)>0 then
            APos:=-1;
        end;
      end else
        Strings.AddObject(S2,TObject(Apos));
    end;
  end;
end;

{ TBisDBTreeNodeDataValues }

function TBisDBTreeNodeDataValues.Add(Column: TBisDBTreeColumn; Value: Variant): TBisDBTreeNodeDataValue;
begin
  Result:=nil;
  if not Assigned(Find(Column)) then begin
    Result:=TBisDBTreeNodeDataValue.Create;
    Result.Column:=Column;
    Result.Value:=Value;
    inherited Add(Result);
  end;
end;

function TBisDBTreeNodeDataValues.Find(Column: TBisDBTreeColumn): TBisDBTreeNodeDataValue;
var
  Item: TBisDBTreeNodeDataValue;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.Column=Column then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisDBTreeNodeDataValues.FindField(Field: TField): TBisDBTreeNodeDataValue;
var
  Item: TBisDBTreeNodeDataValue;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if (Item.Column.Field=Field) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisDBTreeNodeDataValues.GetItem(Index: Integer): TBisDBTreeNodeDataValue;
begin
  Result:=TBisDBTreeNodeDataValue(inherited Items[Index]);
end;

procedure TBisDBTreeNodeDataValues.Resync;
var
  i: Integer;
  Item: TBisDBTreeNodeDataValue;
  Field: TField;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Field:=Item.Column.Field;
    if Assigned(Field) and Assigned(Field.DataSet) and Field.DataSet.Active then
      Item.Value:=Field.Value;
  end;
end;

{ TBisDBTreeDataLink }

constructor TBisDBTreeDataLink.Create(ATree: TBisDBTree);
begin
  inherited Create;
  FTree:=ATree;
  VisualControl:=True;
end;

destructor TBisDBTreeDataLink.Destroy;
begin
  SetOldDataSetEvents;
  inherited Destroy;
end;

procedure TBisDBTreeDataLink.SetOldDataSetEvents;
begin
  if Assigned(DataSet) then begin
    DataSet.BeforeInsert:=FOldDataSetBeforeInsert;
    DataSet.AfterInsert:=FOldDataSetAfterInsert;
    DataSet.AfterPost:=FOldDataSetAfterPost;
    DataSet.AfterCancel:=FOldDataSetAfterCancel;
    DataSet.BeforeDelete:=FOldDataSetBeforeDelete;
    DataSet.AfterDelete:=FOldDataSetAfterDelete;
  end;
end;

procedure TBisDBTreeDataLink.SetNewDataSetEvents;
begin
  if Assigned(DataSet) then begin
    FOldDataSetBeforeInsert:=DataSet.BeforeInsert;
    FOldDataSetAfterInsert:=DataSet.AfterInsert;
    FOldDataSetAfterPost:=DataSet.AfterPost;
    FOldDataSetAfterCancel:=DataSet.AfterCancel;
    FOldDataSetBeforeDelete:=DataSet.BeforeDelete;
    FOldDataSetAfterDelete:=DataSet.AfterDelete;

    DataSet.BeforeInsert:=DataSetBeforeInsert;
    DataSet.AfterInsert:=DataSetAfterInsert;
    DataSet.AfterPost:=DataSetAfterPost;
    DataSet.AfterCancel:=DataSetAfterCancel;
    DataSet.BeforeDelete:=DataSetBeforeDelete;
    DataSet.AfterDelete:=DataSetAfterDelete;
  end;
end;

function TBisDBTreeDataLink.GetDataSource: TDataSource;
begin
  Result:=inherited DataSource;
end;

procedure TBisDBTreeDataLink.SetDataSource(const Value: TDataSource);
begin
  if Value<>inherited DataSource then begin
    SetOldDataSetEvents;
    inherited DataSource:=Value;
    SetNewDataSetEvents;
  end;
end;

procedure TBisDBTreeDataLink.DataSetBeforeInsert(DataSet: TDataSet);
begin
  FInserting:=true;
  if Assigned(FOldDataSetBeforeInsert) then
    FOldDataSetBeforeInsert(DataSet);
end;

procedure TBisDBTreeDataLink.DataSetAfterInsert(DataSet: TDataSet);
begin
  FAppend:=DataSet.Eof;
  if Assigned(FOldDataSetAfterInsert) then
    FOldDataSetAfterInsert(DataSet);
end;

procedure TBisDBTreeDataLink.DataSetAfterPost(DataSet: TDataSet);
begin
  if FInserting then begin
    FTree.DataLinkDataSetInsertOrAppend(FAppend);
    FInserting:=false;
  end;
  FTree.DataLinkDataSetAfterPost;
  if Assigned(FOldDataSetAfterPost) then
    FOldDataSetAfterPost(DataSet);
end;

procedure TBisDBTreeDataLink.DataSetAfterCancel(DataSet: TDataSet);
begin
  FInserting:=false;
  if Assigned(FOldDataSetAfterCancel) then
    FOldDataSetAfterCancel(nil);
end;

procedure TBisDBTreeDataLink.DataSetBeforeDelete(DataSet: TDataSet);
begin
  FTree.DataLinkDataSetDelete(false);
  if Assigned(FOldDataSetBeforeDelete) then
    FOldDataSetBeforeDelete(DataSet);
end;

procedure TBisDBTreeDataLink.DataSetAfterDelete(DataSet: TDataSet);
begin
  FTree.DataLinkDataSetDelete(true);
  if Assigned(FOldDataSetAfterDelete) then
    FOldDataSetAfterDelete(DataSet);
end;

procedure TBisDBTreeDataLink.DataEvent(Event: TDataEvent; Info: Integer);
var
  I: Integer;
begin
  FTree.BeforeDataEvent(Event);
  try
    i:=Info;
    case Event of
      deFieldChange: i:=Info; // Change Value
      deRecordChange: i:=Info; // Edit
      deDataSetChange: i:=Info; // First, Last, EnableControls, Insert, Append, Delete, Post, Cancel
      deDataSetScroll: i:=Info; // Prior, Next, MoveBy
      deLayoutChange: i:=Info;
      deUpdateRecord: i:=Info; // Post
      deUpdateState: i:=Info; // Open, Close, Insert, Append, Edit, Post, Cancel
      deCheckBrowseMode: i:=Info;  // First, Prior, Next, MoveBy, Insert, Append, Delete, Edit, Post, Cancel
      dePropertyChange: i:=Info;
      deFieldListChange: i:=Info;
      deFocusControl: i:=Info;
      deParentScroll: i:=Info;
      deConnectChange: i:=Info;
      deReconcileError: i:=Info;
      deDisabledStateChange: i:=Info; // Append (DisableControl)
    end;
    inherited DataEvent(Event,i);
  finally
    //
  end;
end;

procedure TBisDBTreeDataLink.DataSetChanged;
begin
  if not FInserting then
    FTree.DataLinkDataSetChanged;
end;

procedure TBisDBTreeDataLink.ActiveChanged;
begin
  FTree.DataLinkActiveChanged;
end;

procedure TBisDBTreeDataLink.RecordChanged(Field: TField);
begin
  if not FInserting then
    FTree.DataLinkRecordChanged(Field);
end;

{ TBisDBTreeColumn }

function TBisDBTreeColumn.GetTree: TBisDBTree;
begin
  if Assigned(Collection) and (Collection is TBisDBTreeColumns) then
    Result := TBisDBTreeColumns(Collection).Header.Tree
  else
    Result := nil;
end;

function TBisDBTreeColumn.GetField: TField;
var
  ATree: TBisDBTree;
  DataSet: TDataSet;
begin
  Result:=nil;
  ATree:=GetTree;
  if Assigned(ATree) then begin
    DataSet:=ATree.GetDataSet;
    if Assigned(DataSet) then
      Result:=DataSet.FindField(FFieldName);
  end;
end;

procedure TBisDBTreeColumn.SetFieldName(const Value: String);
begin
  FFieldName:=Value;
  Changed(False);
end;

{ TBisDBTreeColumns }

function TBisDBTreeColumns.Add: TBisDBTreeColumn;
begin
  Result:=TBisDBTreeColumn(inherited Add);
end;

function TBisDBTreeColumns.GetHeader: TBisDBTreeHeader;
begin
  Result:=TBisDBTreeHeader(inherited Header);
end;

function TBisDBTreeColumns.GetItem(Index: TColumnIndex): TBisDBTreeColumn;
begin
  Result:=TBisDBTreeColumn(inherited Items[Index]);
end;

procedure TBisDBTreeColumns.SetItem(Index: TColumnIndex; const Value: TBisDBTreeColumn);
begin
  inherited Items[Index]:=Value;
end;

{ TBisDBTreeHeader }

function TBisDBTreeHeader.GetColumns: TBisDBTreeColumns;
begin
  Result:=TBisDBTreeColumns(inherited Columns);
end;

function TBisDBTreeHeader.GetColumnsClass: TVirtualTreeColumnsClass;
begin
  Result:=TBisDBTreeColumns;
end;

function TBisDBTreeHeader.GetTree: TBisDBTree;
begin
  Result:=TBisDBTree(inherited TreeView);
end;

{ TBisDBTree }

constructor TBisDBTree.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  NodeDataSize:=SizeOf(TBisDBTreeNodeData);

  Header.Options:=[hoShowSortGlyphs,hoVisible,hoDblClickResize,hoAutoSpring,hoColumnResize,hoDrag];
  if ThemeServices.ThemesEnabled then
    Header.Options:=Header.Options+[hoHotTrack];

  TreeOptions.MiscOptions:=[toFullRepaintOnResize,toGridExtensions,toReportMode,toWheelPanning];
  TreeOptions.PaintOptions:=[toShowDropmark,toShowHorzGridLines,toShowTreeLines,toShowVertGridLines,toThemeAware,toShowBackground];
  TreeOptions.SelectionOptions:=[toExtendedFocus{,toCenterScrollIntoView}];

  FDataLink:=TBisDBTreeDataLink.Create(Self);

  FKeyFields:=TStringList.Create;
  FParentFields:=TStringList.Create;

  GridEmulate:=true;
end;

destructor TBisDBTree.Destroy;
begin
  FParentFields.Free;
  FKeyFields.Free;
  FDataLink.Free;
  inherited Destroy;
end;

procedure TBisDBTree.CancelIncrementalSearch;
begin
  inherited CancelIncrementalSearch;
  InvalidateNode(FocusedNode);
end;

procedure TBisDBTree.DoFocusChange(Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PBisDBTreeNodeData;
  DataSet: TDataSet;
begin
  Data:=GetNodeData(Node);
  DataSet:=GetDataSet;
  if Assigned(Data) and Assigned(DataSet) and DataSet.Active then begin
    if not FDataLinkDataSetChanging and
       not FDataLinkDataSetInserting then begin
      FFocusChanging:=true;
      try
        DataSet.RecNo:=Data.RecNo;
      finally
        FFocusChanging:=false;
      end;
    end;
  end;
  inherited DoFocusChange(Node,Column);
end;

procedure TBisDBTree.DoFreeNode(Node: PVirtualNode);
var
  Data: PBisDBTreeNodeData;
begin
  Data:=GetNodeData(Node);
  if Assigned(Data) then
    Data.Values.Free;
  inherited DoFreeNode(Node);
end;

procedure TBisDBTree.DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex; TextType: TVSTTextType);
begin
  //
end;

type
  THackDataSet=class(TDataSet)
  end;

procedure TBisDBTree.DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString);

  function GetTextByColumn(AColumn: TBisDBTreeColumn): String;
  var
    Field: TField;
    S: String;
  begin
    Result:='';
    Field:=AColumn.Field;
    if Assigned(Field) then begin
      Result:=VarToStrDef(Field.Value,'');
      S:=AColumn.DisplayFormat;
      if S<>'' then begin
        case Field.DataType of
          ftSmallint,ftInteger,ftWord,ftFloat,ftCurrency,ftLargeint,ftFMTBcd: Result:=FormatFloat(S,StrToFloatDef(Result,0.0));
          ftDate,ftTime,ftDateTime,ftTimeStamp: Result:=FormatDateTime(S,StrToDateTimeDef(Result,0.0));
        end;
      end;
    end;
  end;

var
  Data: PBisDBTreeNodeData;
  AColumn: TBisDBTreeColumn;
  Item: TBisDBTreeNodeDataValue;
  DataSet: TDataSet;
  B: TBookmark;
begin
  Data:=GetNodeData(Node);
  AColumn:=Header.Columns[Column];
  DataSet:=GetDataSet;
  if Assigned(Data) and Assigned(AColumn) and
     Assigned(DataSet) and DataSet.Active then begin
//     not FDataLinkDataSetInserting and
    if not FDataLinkDataSetDeleting and
       not FDataLinkActiveChanging then begin

      FGettingText:=true;
      B:=DataSet.GetBookmark;
      try
         if Assigned(Data.Bookmark) and
            DataSet.BookmarkValid(Data.Bookmark) then begin

           THackDataSet(DataSet).InternalGotoBookmark(Data.Bookmark);
           DataSet.Resync([rmExact, rmCenter]);

           Text:=GetTextByColumn(AColumn);

         end;

      finally
        if Assigned(B) and DataSet.BookmarkValid(B) then
          THackDataSet(DataSet).InternalGotoBookmark(B);
        FGettingText:=false;
      end;

{        Text:='';
        if Assigned(Data.Values) then begin
          Item:=Data.Values.Find(AColumn);
          if Assigned(Item) then
            Text:=VarToStrDef(Item.Value,'');
        end;
        if Text<>'' then begin
          Field:=AColumn.Field;
          if Assigned(Field) then begin
            S:=AColumn.DisplayFormat;
            if S<>'' then begin
              case Field.DataType of
                ftSmallint,ftInteger,ftWord,ftFloat,ftCurrency,ftLargeint,ftFMTBcd: Text:=FormatFloat(S,StrToFloatDef(Text,0.0));
                ftDate,ftTime,ftDateTime,ftTimeStamp: Text:=FormatDateTime(S,StrToDateTimeDef(Text,0.0));
              end;
            end;
          end;
        end;}
    end else if FDataLinkActiveChanging then begin

      Text:=GetTextByColumn(AColumn);

    end;
  end;
end;

procedure TBisDBTree.DoProgress(Min, Max, Position: Integer; var Breaked: Boolean);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self,Min,Max,Position,Breaked);
end;

function TBisDBTree.GetColumnClass: TVirtualTreeColumnClass;
begin
  Result:=TBisDBTreeColumn;
end;

function TBisDBTree.GetDataSet: TDataSet;
begin
  Result:=FDataLink.DataSet;
end;

function TBisDBTree.GetDataSource: TDataSource;
begin
  Result:=FDataLink.DataSource;
end;

function TBisDBTree.GetHeader: TBisDBTreeHeader;
begin
  Result:=TBisDBTreeHeader(inherited Header);
end;

function TBisDBTree.GetHeaderClass: TVTHeaderClass;
begin
  Result:=TBisDBTreeHeader;
end;

procedure TBisDBTree.SetDataSource(const Value: TDataSource);
begin
  if Value=FDatalink.Datasource then Exit;
  if Assigned(Value) then
    if Assigned(Value.DataSet) then
      if Value.DataSet.IsUnidirectional then
        DatabaseError(SDataSetUnidirectional);
  FDataLink.DataSource:=Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TBisDBTree.SetGridEmulate(const Value: Boolean);
begin
  if Value<>FGridEmulate then begin
    FGridEmulate:=Value;
    if FGridEmulate then begin
      TreeOptions.PaintOptions:=TreeOptions.PaintOptions-[toShowButtons,toShowRoot];
    end else begin
      TreeOptions.PaintOptions:=TreeOptions.PaintOptions+[toShowButtons,toShowRoot];
    end;
    RefreshNodes;
  end;
end;

function TBisDBTree.GetKeyFieldName: String;
begin
  Result:=GetStringByStrings(FKeyFields,';');
end;

procedure TBisDBTree.SetKeyFieldName(const Value: String);
begin
  FKeyFields.Clear;
  GetStringsByString(Value,';',FKeyFields);
end;

function TBisDBTree.GetParentFieldName: String;
begin
  Result:=GetStringByStrings(FParentFields,';');
end;

procedure TBisDBTree.SetParentFieldName(const Value: String);
begin
  FParentFields.Clear;
  GetStringsByString(Value,';',FParentFields);
end;

function TBisDBTree.GetMultiSelect: Boolean;
begin
  Result:=toMultiSelect in TreeOptions.SelectionOptions;
end;

procedure TBisDBTree.SetMultiSelect(const Value: Boolean);
begin
  if Value then
    TreeOptions.SelectionOptions:=TreeOptions.SelectionOptions+[toMultiSelect]
  else
    TreeOptions.SelectionOptions:=TreeOptions.SelectionOptions-[toMultiSelect];
end;

procedure TBisDBTree.SetSearchEnabled(const Value: Boolean);
begin
  if Value then
    IncrementalSearch:=isAll
  else
    IncrementalSearch:=isNone;
end;

function TBisDBTree.GetSearchEnabled: Boolean;
begin
  Result:=IncrementalSearch=isAll;
end;

function TBisDBTree.GetSelectedField: TField;
var
  Index: TColumnIndex;
begin
  Index:=FocusedColumn;
  if Index<>-1 then
    Result:=Header.Columns[Index].Field
  else
    Result:=nil;
end;

procedure TBisDBTree.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if SearchEnabled and (Key=VK_ESCAPE) then
    CancelIncrementalSearch;
  inherited KeyDown(Key,Shift);
end;

procedure TBisDBTree.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  HitInfo: THitInfo;
  Pt: TPoint;
begin
  if Button=mbRight then begin
    GetCursorPos(Pt);
    GetHitTestInfoAt(X,Y,True,HitInfo);
    if Assigned(HitInfo.HitNode) then begin
      if not MultiSelect then
        ClearSelection;
      FocusedNode:=HitInfo.HitNode;
      Selected[HitInfo.HitNode]:=True;
    end;
  end;
  inherited MouseDown(Button,Shift,X,Y);
end;

function TBisDBTree.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
var
  OldNode: PVirtualNode;
begin
  inherited DoMouseWheelDown(Shift,MousePos);
  OldNode:=FocusedNode;
  FocusedNode:=GetNext(OldNode);
  if Assigned(FocusedNode) then begin
    Selected[FocusedNode]:=True;
    ScrollIntoView(FocusedNode,true);
    Selected[OldNode]:=false;
  end else
    FocusedNode:=OldNode;
  Result:=true;
end;

function TBisDBTree.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
var
  OldNode: PVirtualNode;
begin
  inherited DoMouseWheelUp(Shift,MousePos);
  OldNode:=FocusedNode;
  FocusedNode:=GetPrevious(OldNode);
  if Assigned(FocusedNode) then begin
    Selected[FocusedNode]:=True;
    ScrollIntoView(FocusedNode,true);
    Selected[OldNode]:=false;
  end else
    FocusedNode:=OldNode;
  Result:=true;
end;

procedure TBisDBTree.BeforeDataEvent(Event: TDataEvent);
var
  DataSet: TDataSet;
begin
  DataSet:=GetDataSet;
  if Assigned(DataSet) then begin
    case Event of
      deFieldChange: ;
      deRecordChange: ;
      deDataSetChange: ;
      deDataSetScroll: ;
      deLayoutChange: Enabled:=not Enabled;
      deUpdateRecord: ;
      deUpdateState: ;
      deCheckBrowseMode: ;//Result:=not FDataLoading;
      dePropertyChange: ;
      deFieldListChange: ;
      deFocusControl: ;
      deParentScroll: ;
      deConnectChange: ;
      deReconcileError: ;
      deDisabledStateChange: Enabled:=false;
    end;
  end;
end;

procedure TBisDBTree.DoReadNode(Node: PVirtualNode);
var
  DataSet: TDataSet;
  Data: PBisDBTreeNodeData;
  Column: TBisDBTreeColumn;
  Field: TField;
  i: Integer;
begin
  DataSet:=GetDataSet;
  if Assigned(Node) and Assigned(DataSet) then begin
    Data:=GetNodeData(Node);
    if Assigned(Data) and DataSet.Active then begin
      Data.Bookmark:=DataSet.GetBookmark;
      Data.RecNo:=DataSet.RecNo;
      if not Assigned(Data.Values) then
        Data.Values:=TBisDBTreeNodeDataValues.Create;
      if Assigned(Data.Values) then begin
        for i:=0 to Header.Columns.Count-1 do begin
          Column:=Header.Columns[i];
          Field:=Column.Field;
          if Assigned(Field) then begin
            Data.Values.Add(Column,Field.Value);
          end;
        end;
      end;
    end;
  end;
end;

procedure TBisDBTree.RefreshNodes;
var
  DataSet: TDataSet;

  procedure BuildGrid;
  var
    B: TBookmark;
    Node: PVirtualNode;
    Disabled: Boolean;
    RCount: Integer;
    Breaked: Boolean;
    Position: Integer;
  begin
    B:=DataSet.GetBookmark;
    Disabled:=DataSet.ControlsDisabled;
    if not Disabled then begin
      DataSet.DisableControls;
      Disabled:=true;
    end;
    Position:=1;
    RCount:=DataSet.RecordCount;
    DoProgress(0,RCount,0,Breaked);
    try
      Clear;
      DataSet.First;
      while not DataSet.Eof do begin
        DoProgress(0,RCount,Position,Breaked);
        Node:=AddChild(nil,nil);
        DoReadNode(Node);
        if Breaked then
          break;        
        Inc(Position);
        DataSet.Next;
      end;
    finally
      DoProgress(0,RCount,0,Breaked);
      if Assigned(B) and DataSet.BookmarkValid(B) then
        DataSet.GotoBookmark(B);
      if Disabled then
        DataSet.EnableControls;
    end;
  end;

  procedure BuildTree;
  var
    B: TBookmark;
    ParentNode: PVirtualNode;
    Node: PVirtualNode;
    Disabled: Boolean;
    RCount: Integer;
    Breaked: Boolean;
    Position: Integer;
  begin
    if FindFields(FKeyFields) and  FindFields(FParentFields) then begin
      B:=DataSet.GetBookmark;
      Disabled:=DataSet.ControlsDisabled;
      if not Disabled then begin
        DataSet.DisableControls;
        Disabled:=true;
      end;
      Position:=1;
      RCount:=DataSet.RecordCount;
      DoProgress(0,RCount,0,Breaked);
      try
        Clear;
        DataSet.First;
        while not DataSet.Eof do begin
          DoProgress(0,RCount,Position,Breaked);
          Node:=AddChild(nil,nil);
          DoReadNode(Node);
          if Breaked then
            break;
          Inc(Position);
          DataSet.Next;
        end;
      finally
        DoProgress(0,RCount,0,Breaked);
        if Assigned(B) and DataSet.BookmarkValid(B) then
          DataSet.GotoBookmark(B);
        if Disabled then
          DataSet.EnableControls;
      end;
    end;
  end;

begin
  DataSet:=GetDataSet;
  if Assigned(DataSet) then begin
    if DataSet.Active then begin
      if FGridEmulate then
        BuildGrid
      else
        BuildTree;
    end;
  end;
end;

procedure TBisDBTree.DataLinkActiveChanged;
var
  DataSet: TDataSet;
begin
  if not FDataLinkActiveChanging then begin
    FDataLinkActiveChanging:=true;
    try
      DataSet:=GetDataSet;
      if Assigned(DataSet) then begin
        case DataSet.State of
          dsBrowse: begin
            RefreshNodes;
          end;
          dsInactive: Clear;
        end;
      end;
    finally
      FDataLinkActiveChanging:=false;
    end;
  end;
end;

function TBisDBTree.FindFields(Strings: TStrings): Boolean;
var
  DataSet: TDataSet;
  i: Integer;
  Flag: Boolean;
begin
  Result:=false;
  DataSet:=GetDataSet;
  if Assigned(DataSet) and DataSet.Active then begin
    for i:=0 to Strings.Count-1 do begin
      Flag:=Assigned(DataSet.FindField(Strings[i]));
      if i=0 then
        Result:=Flag
      else
        Result:=Result and Flag;
    end;
  end;
end;

function TBisDBTree.FindNode(RecNo: Integer): PVirtualNode;
var
  Node: PVirtualNode;
  Data: PBisDBTreeNodeData;
begin
  Result:=nil;
  Node:=GetFirst;
  while Assigned(Node) do begin
    if Assigned(Node) then begin
      Data:=GetNodeData(Node);
      if Assigned(Data) and (Data.RecNo=RecNo) then begin
        Result:=Node;
        break;
      end;
    end;
    Node:=GetNext(Node);
  end;
end;

procedure TBisDBTree.SelectNode(Node: PVirtualNode; Scroll: Boolean);
var
  Data: PBisDBTreeNodeData;
begin
  if Assigned(Node) then begin
    ClearSelection;
    Selected[Node]:=True;
    FocusedNode:=Node;
    Data:=GetNodeData(Node);
    if Assigned(Data) and Assigned(Data.Values) then
      Data.Values.Resync;
    if Scroll then
      ScrollIntoView(Node,true);
  end;
end;

procedure TBisDBTree.DataLinkDataSetChanged;
var
  DataSet: TDataSet;
  Node: PVirtualNode;
begin
  if not FDataLinkDataSetChanging and not FGettingText then begin
    FDataLinkDataSetChanging:=true;
    try
      DataSet:=GetDataSet;
      if Assigned(DataSet) and DataSet.Active then begin
        case DataSet.State of
          dsBrowse: begin
            Node:=FindNode(DataSet.RecNo);
            SelectNode(Node,not FFocusChanging and not FDataLinkDataSetDeleting);
          end;
          dsEdit: ;
        end;
      end;
    finally
      FDataLinkDataSetChanging:=false;
    end;
  end;
end;

procedure TBisDBTree.DataLinkRecordChanged(Field: TField);
var
  DataSet: TDataSet;
  Node: PVirtualNode;
  Data: PBisDBTreeNodeData;
  Item: TBisDBTreeNodeDataValue;
begin
  if not FDataLinkRecordChanging then begin
    FDataLinkRecordChanging:=true;
    try
      DataSet:=GetDataSet;
      if Assigned(DataSet) and DataSet.Active and
         Assigned(Field) and (DataSet.State=dsEdit) then begin
        Node:=FocusedNode;
        if Assigned(Node) then begin
          Data:=GetNodeData(Node);
          if Assigned(Data) and Assigned(Data.Values) then begin
            Item:=Data.Values.FindField(Field);
            if Assigned(Item) then
              Item.Value:=Field.Value;
          end;
        end;
      end;
    finally
      FDataLinkRecordChanging:=false;
    end;
  end;
end;

procedure TBisDBTree.RefreshNodeRecNo(Node: PVirtualNode; Offset: Integer);
var
  Data: PBisDBTreeNodeData;
begin
  while Assigned(Node) do begin
    if Assigned(Node) then begin
      Data:=GetNodeData(Node);
      if Assigned(Data) then
        Data.RecNo:=Data.RecNo+Offset;
    end;
    Node:=GetNext(Node);
  end;
end;

procedure TBisDBTree.DataLinkDataSetDelete(After: Boolean);
var
  DataSet: TDataSet;
  Node,NextNode: PVirtualNode;
  Data: PBisDBTreeNodeData;
begin
  FDataLinkDataSetDeleting:=not After;
  if not FDataLinkDataSetDeleting then begin
    FDataLinkDataSetDeleting:=true;
    try
      DataSet:=GetDataSet;
      if Assigned(DataSet) and DataSet.Active then begin
        Node:=FocusedNode;
        if Assigned(Node) then begin
          FocusedNode:=nil;
          Data:=GetNodeData(Node);
          if Assigned(Data) then begin
            NextNode:=GetNext(Node);
            DeleteNode(Node);
            RefreshNodeRecNo(NextNode,-1);
            SelectNode(NextNode,false);
          end;
        end;
      end;
    finally
      FDataLinkDataSetDeleting:=false;
    end;
  end;
end;

procedure TBisDBTree.DataLinkDataSetInsertOrAppend(Append: Boolean);
var
  DataSet: TDataSet;
  Node,NewNode: PVirtualNode;
  Data: PBisDBTreeNodeData;
begin
  if not FDataLinkDataSetInserting then begin
    FDataLinkDataSetInserting:=true;
    try
      DataSet:=GetDataSet;
      if Assigned(DataSet) and DataSet.Active then begin
        Node:=FocusedNode;
        if Assigned(Node) then begin
          Data:=GetNodeData(Node);
          if Assigned(Data) then begin
            if Append then begin
              NewNode:=InsertNode(nil,amAddChildLast,nil);
              DoReadNode(NewNode);
            end else begin
              NewNode:=InsertNode(nil,amAddChildLast,nil);
              MoveTo(NewNode,Node,amInsertBefore,false);
              DoReadNode(NewNode);
              RefreshNodeRecNo(Node,1);
            end;
            SelectNode(NewNode,false);
          end;
        end;
      end;
    finally
      FDataLinkDataSetInserting:=false;
    end;
  end;
end;

procedure TBisDBTree.DataLinkDataSetAfterPost;
var
  DataSet: TDataSet;
  Node: PVirtualNode;
  Data: PBisDBTreeNodeData;
begin
  DataSet:=GetDataSet;
  if Assigned(DataSet) and DataSet.Active then begin
    Node:=FindNode(DataSet.RecNo);
    if Assigned(Node) then begin
      Data:=GetNodeData(Node);
      if Assigned(Data) and Assigned(Data.Values) then
        Data.Values.Resync;
      RepaintNode(Node);
    end;
  end;
end;

end.
