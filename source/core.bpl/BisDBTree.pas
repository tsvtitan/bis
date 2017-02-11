unit BisDBTree;

interface

uses Windows, Messages, Classes, Controls, Graphics, DB, Contnrs, DBGrids,
     ImgList, Menus,
     VirtualTrees,
     BisOrders, BisFieldNames, BisGradient;

type
  TBisDBTreeColumn=class;

  TBisDBTreeValueArray=array of Variant;
  PBisDBTreeValueArray=^TBisDBTreeValueArray;

  TBisDBTreeNodeData=record
    Bookmark: Pointer;
    KeyValues: TBisDBTreeValueArray;
    Values: TBisDBTreeValueArray;
  end;
  PBisDBTreeNodeData=^TBisDBTreeNodeData;

  TBisDBTree=class;

  TBisDBTreeDataLinkSetMode=(smDefault,smInsert,smAppend,smUpdate,smDelete);

  TBisDBTreeDataLink=class(TDataLink)
  private
    FTree: TBisDBTree;
    FMode: TBisDBTreeDataLinkSetMode;

    FOldDataSetAfterInsert: TDataSetNotifyEvent;
    FOldDataSetAfterEdit: TDataSetNotifyEvent;
    FOldDataSetAfterPost: TDataSetNotifyEvent;
    FOldDataSetAfterCancel: TDataSetNotifyEvent;
    FOldDataSetBeforeDelete: TDataSetNotifyEvent;
    FOldDataSetAfterDelete: TDataSetNotifyEvent;

    procedure SetOldDataSetEvents;
    procedure SetNewDataSetEvents;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);

    procedure DataSetAfterInsert(DataSet: TDataSet);
    procedure DataSetAfterEdit(DataSet: TDataSet);
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
    FVisualType: TBisFieldNameVisualType;
    FAlignmentDefault: Boolean;
    procedure SetFieldName(const Value: String);
    function GetField: TField;
  protected
    function GetTree: TBisDBTree;
  public
    property FieldName: String read FFieldName write SetFieldName;
    property DisplayFormat: String read FDisplayFormat write FDisplayFormat;
    property VisualType: TBisFieldNameVisualType read FVisualType write FVisualType;
    property AlignmentDefault: Boolean read FAlignmentDefault write FAlignmentDefault;

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
    function Find(FieldName: String): TBisDBTreeColumn;
    function VisibleCount: Integer;

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

  TBisDBTreeState=(tsActiveChanging,tsDataSetChanging,tsRecordChanging,tsDataSetDeleting,tsDataSetPosting,
                   tsBuilding,tsTextGetting,tsFocusChanging,tsDefaultTextDrawing);
  TBisDBTreeStates=set of TBisDBTreeState;


  TBisDBTreeSortEvent=procedure(Sender: TObject; FieldName: String; OrderType: TBisOrderType; var Success: Boolean) of object;
  TBisDBTreeProgressEvent=procedure(Sender: TBisDBTree; const Min,Max,Position: Integer; var Interrupted: Boolean) of object;

  TBisDBTree=class(TVirtualStringTree)
  private
    FDataLink: TBisDBTreeDataLink;
    FGridEmulate: Boolean;
    FOnProgress: TBisDBTreeProgressEvent;
    FKeyFields: TStringList;
    FParentFields: TStringList;
    FDirectScan: Boolean;
    FReadOnly: Boolean;
    FSortEnabled: Boolean;
    FOnSort: TBisDBTreeSortEvent;
    FNavigatorVisible: Boolean;
    FNavigatorColumn: TBisDBTreeColumn;
    FNumberVisible: Boolean;
    FSortColumnVisible: Boolean;
    FChessVisible: Boolean;
    FSortColumnColor: TColor;
    FChessColor: TColor;
    FRowVisible: Boolean;
    FRowColor: TColor;
    FGradientVisible: Boolean;
    FGradientStyle: TBisGradientStyle;
    FGradientEndColor: TColor;
    FGradientBeginColor: TColor;
    FAutoResizeableColumns: Boolean;
    FStopAutoResizeColumns: Boolean;
    FVerticalScrollBarVisible: Boolean;
    FSaveEmptyWidth: Integer;
    FSaveColumnsWidth: Integer;
    FNormalIndex: Integer;
    FLastIndex: Integer;
    FOpenIndex: Integer;
    FIndicators: TImageList;
    FOldPaintInfo: TVTPaintInfo;
    FOldDrawFormat: Cardinal;
    FSearchColor: TColor;
    FSearchEnabled: Boolean;
    FStates: TBisDBTreeStates;

    procedure CreateNavigatorColumn;
    procedure DestroyNavigatorColumn;
    procedure ResizeNavigatorColumn;

    procedure DefaultTextDrawing(Text: WideString; Rect: TRect);
    function GetVisibleIndex(Node: PVirtualNode): Cardinal;
    function GetDataSource: TDataSource;
    procedure SetDataSource(const Value: TDataSource);
    function GetHeader: TBisDBTreeHeader;
    function GetSelectedField: TField;
    function GetKeyValues(Fields: TStrings; Values: PBisDBTreeValueArray): Boolean;
    function FindNodeByKeyValues(KeyValues: PBisDBTreeValueArray; LastNode: PVirtualNode=nil): PVirtualNode;
    procedure GoToNode(Node: PVirtualNode);
    procedure SelectNode(Node: PVirtualNode; Scroll: Boolean);
    procedure Build;
    function FindFields(Fields: TStrings): Boolean;

    procedure BeforeDataEvent(Event: TDataEvent);
    procedure DataLinkActiveChanged;
    procedure DataLinkDataSetChanged;
    procedure DataLinkRecordChanged(Field: TField);
    procedure DataLinkDataSetDelete(After: Boolean);
    procedure DataLinkDataSetAfterPost(AMode: TBisDBTreeDataLinkSetMode);

    procedure SetGridEmulate(const Value: Boolean);
    procedure SetSearchEnabled(const Value: Boolean);
    function GetMultiSelect: Boolean;
    procedure SetMultiSelect(const Value: Boolean);
    function GetKeyFieldNames: String;
    procedure SetKeyFieldNames(const Value: String);
    function GetParentFieldNames: String;
    procedure SetParentFieldNames(const Value: String);
    procedure SetNavigatorVisible(const Value: Boolean);
    procedure SetNumberVisible(const Value: Boolean);
    procedure SetSortColumnVisible(const Value: Boolean);
    procedure SetChessVisible(const Value: Boolean);
    procedure SetSortColumnColor(const Value: TColor);
    procedure SetChessColor(const Value: TColor);
    procedure SetRowVisible(const Value: Boolean);
    procedure SetRowColor(const Value: TColor);
    procedure SetGradientVisible(const Value: Boolean);
    procedure SetGradientStyle(const Value: TBisGradientStyle);
    procedure SetGradientBeginColor(const Value: TColor);
    procedure SetGradientEndColor(const Value: TColor);
    procedure SetAutoResizeableColumns(const Value: Boolean);
    function GetSelectedFieldName: String;
    procedure SetFirstVisibleColumn;
    procedure SetFirstVisbleNode;
  protected
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;

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
    procedure DoHeaderClick(Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DoAfterCellPaint(Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect); override;
    procedure DoBeforeCellPaint(Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect); override;
    function DoPaintBackground(Canvas: TCanvas; R: TRect): Boolean; override;
    procedure DoShowScrollbar(Bar: Integer; Show: Boolean); override;
    function DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
                             var Ghosted: Boolean; var Index: Integer): TCustomImageList; override;
    procedure DoTextDrawing(var PaintInfo: TVTPaintInfo; Text: WideString; CellRect: TRect; DrawFormat: Cardinal); override;
    function DoFocusChanging(OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex): Boolean; override;
    function DoIncrementalSearch(Node: PVirtualNode; const Text: WideString): Integer; override;
    procedure DoHeaderDragged(Column: TColumnIndex; OldPosition: TColumnPosition); override;
    function DoCompare(Node1, Node2: PVirtualNode; Column: TColumnIndex): Integer; Override;
    function DoGetPopupMenu(Node: PVirtualNode; Column: TColumnIndex; Position: TPoint): TPopupMenu; Override;

    procedure DoReadNode(Node: PVirtualNode); virtual;
    procedure DoProgress(Min,Max,Position: Integer; var Interrupted: Boolean); virtual;
    procedure DoSort(FieldName: String; OrderType: TBisOrderType; var Success: Boolean); virtual;



    property DataLink: TBisDBTreeDataLink read FDataLink;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CancelIncrementalSearch; override;
    procedure CopyFromFieldNames(FieldNames: TBisFieldNames; WithClear: Boolean=true);
    procedure ScrollIntoSelect;
    function CanFirst: Boolean;
    procedure First;
    function CanPrior: Boolean;
    procedure Prior;
    function CanNext: Boolean;
    procedure Next;
    function CanLast: Boolean;
    procedure Last;
    procedure Synchronize;
    procedure CollapseAll;
    procedure RefreshNodes;

    function GetValueIndex(FieldName: String): Integer; overload;
    function GetValueIndex(Column: TBisDBTreeColumn): Integer; overload;
    function GetNodeValue(Node: PVirtualNode; FieldName: String): Variant;

    property Header: TBisDBTreeHeader read GetHeader;
    property SelectedField: TField read GetSelectedField;
    property SelectedFieldName: String read GetSelectedFieldName;
    property States: TBisDBTreeStates read FStates;
    property NavigatorColumn: TBisDBTreeColumn read FNavigatorColumn; 

    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property GridEmulate: Boolean read FGridEmulate write SetGridEmulate;
    property DirectScan: Boolean read FDirectScan write FDirectScan;
    property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
    property KeyFieldNames: String read GetKeyFieldNames write SetKeyFieldNames;
    property ParentFieldNames: String read GetParentFieldNames write SetParentFieldNames;

    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property SortEnabled: Boolean read FSortEnabled write FSortEnabled;
    property NavigatorVisible: Boolean read FNavigatorVisible write SetNavigatorVisible;
    property NumberVisible: Boolean read FNumberVisible write SetNumberVisible;
    property SortColumnVisible: Boolean read FSortColumnVisible write SetSortColumnVisible;
    property SortColumnColor: TColor read FSortColumnColor write SetSortColumnColor;
    property ChessVisible: Boolean read FChessVisible write SetChessVisible;
    property ChessColor: TColor read FChessColor write SetChessColor;
    property RowVisible: Boolean read FRowVisible write SetRowVisible;
    property RowColor: TColor read FRowColor write SetRowColor;
    property GradientVisible: Boolean read FGradientVisible write SetGradientVisible;
    property GradientStyle: TBisGradientStyle read FGradientStyle write SetGradientStyle;
    property GradientBeginColor: TColor read FGradientBeginColor write SetGradientBeginColor;
    property GradientEndColor: TColor read FGradientEndColor write SetGradientEndColor;
    property AutoResizeableColumns: Boolean read FAutoResizeableColumns write SetAutoResizeableColumns;
    property SearchEnabled: Boolean read FSearchEnabled write SetSearchEnabled;
    property SearchColor: TColor read FSearchColor write FSearchColor;

    property NormalIndex: Integer read FNormalIndex write FNormalIndex;
    property LastIndex: Integer read FLastIndex write FLastIndex;
    property OpenIndex: Integer read FOpenIndex write FOpenIndex;

    property OnProgress: TBisDBTreeProgressEvent read FOnProgress write FOnProgress;
    property OnSort: TBisDBTreeSortEvent read FOnSort write FOnSort;
  end;

implementation

{$R *.res}

uses SysUtils, Consts, DBConsts, Variants, Themes, Forms, StrUtils,
     BisConsts, BisUtils;

const
  bmArrow = 'BISDBTREEGARROW';
  bmEdit = 'BISDBTREEEDIT';
  bmInsert = 'BISDBTREEINSERT';
  bmMultiDot = 'BISDBTREEMULTIDOT';
  bmMultiArrow = 'BISDBTREEMULTIARROW';

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
    DataSet.AfterInsert:=FOldDataSetAfterInsert;
    DataSet.AfterEdit:=FOldDataSetAfterEdit;
    DataSet.AfterPost:=FOldDataSetAfterPost;
    DataSet.AfterCancel:=FOldDataSetAfterCancel;
    DataSet.BeforeDelete:=FOldDataSetBeforeDelete;
    DataSet.AfterDelete:=FOldDataSetAfterDelete;
  end;
end;

procedure TBisDBTreeDataLink.SetNewDataSetEvents;
begin
  if Assigned(DataSet) then begin
    FOldDataSetAfterInsert:=DataSet.AfterInsert;
    FOldDataSetAfterEdit:=DataSet.AfterEdit;
    FOldDataSetAfterPost:=DataSet.AfterPost;
    FOldDataSetAfterCancel:=DataSet.AfterCancel;
    FOldDataSetBeforeDelete:=DataSet.BeforeDelete;
    FOldDataSetAfterDelete:=DataSet.AfterDelete;

    DataSet.AfterInsert:=DataSetAfterInsert;
    DataSet.AfterEdit:=DataSetAfterEdit;
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

procedure TBisDBTreeDataLink.DataSetAfterInsert(DataSet: TDataSet);
begin
  if DataSet.Eof then
    FMode:=smAppend
  else
    FMode:=smInsert;
  if Assigned(FOldDataSetAfterInsert) then
    FOldDataSetAfterInsert(DataSet);
end;

procedure TBisDBTreeDataLink.DataSetAfterEdit(DataSet: TDataSet);
begin
  FMode:=smUpdate;
  if Assigned(FOldDataSetAfterEdit) then
    FOldDataSetAfterEdit(DataSet);
end;

procedure TBisDBTreeDataLink.DataSetAfterPost(DataSet: TDataSet);
begin
  FTree.DataLinkDataSetAfterPost(FMode);
  if Assigned(FOldDataSetAfterPost) then
    FOldDataSetAfterPost(DataSet);
end;

procedure TBisDBTreeDataLink.DataSetAfterCancel(DataSet: TDataSet);
begin
  FMode:=smDefault;
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
  FMode:=smDelete;
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
      deDataSetChange: begin
        i:=Info; // First, Last, EnableControls, Insert, Append, Delete, Post, Cancel
//        FTree.EndUpdate;
      end;  
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
      deDisabledStateChange: begin
        i:=Info; // Append (DisableControl)
  //      FTree.BeginUpdate;
      end;
    end;
    inherited DataEvent(Event,i);
  finally
    //
  end;
end;

procedure TBisDBTreeDataLink.DataSetChanged;
begin
  if not (FMode in [smDelete]) then
    FTree.DataLinkDataSetChanged;
end;

procedure TBisDBTreeDataLink.ActiveChanged;
begin
  FTree.DataLinkActiveChanged;
end;

procedure TBisDBTreeDataLink.RecordChanged(Field: TField);
begin
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

function TBisDBTreeColumns.Find(FieldName: String): TBisDBTreeColumn;
var
  Item: TBisDBTreeColumn;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.FieldName,FieldName) then begin
      Result:=Item;
      break;
    end;
  end;
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

function TBisDBTreeColumns.VisibleCount: Integer;
var
  i: Integer;
  Item: TBisDBTreeColumn;
begin
  Result:=0;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if (coVisible in Item.Options) and
       Assigned(Item.Field) then
      Inc(Result);
  end;
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
var
  Bmp: TBitmap;
begin
  inherited Create(AOwner);

  FNormalIndex:=-1;
  FLastIndex:=-1;
  FOpenIndex:=-1;

  NodeDataSize:=SizeOf(TBisDBTreeNodeData);

  Bmp := TBitmap.Create;
  try
    Bmp.LoadFromResourceName(HInstance, bmArrow);
    FIndicators := TImageList.CreateSize(Bmp.Width, Bmp.Height);
    FIndicators.AddMasked(Bmp, clWhite);
    Bmp.LoadFromResourceName(HInstance, bmEdit);
    FIndicators.AddMasked(Bmp, clWhite);
    Bmp.LoadFromResourceName(HInstance, bmInsert);
    FIndicators.AddMasked(Bmp, clWhite);
    Bmp.LoadFromResourceName(HInstance, bmMultiDot);
    FIndicators.AddMasked(Bmp, clWhite);
    Bmp.LoadFromResourceName(HInstance, bmMultiArrow);
    FIndicators.AddMasked(Bmp, clWhite);
  finally
    Bmp.Free;
  end;

  IncrementalSearchDirection:=sdForward;
  IncrementalSearchStart:=ssLastHit;
  
  Header.Options:=[hoShowSortGlyphs,hoVisible,hoDblClickResize,hoAutoSpring,hoColumnResize,hoDrag];
  if ThemeServices.ThemesEnabled then
    Header.Options:=Header.Options+[hoHotTrack];

  TreeOptions.MiscOptions:=[toFullRepaintOnResize,toGridExtensions,toReportMode,toWheelPanning];
  TreeOptions.PaintOptions:=[toShowDropmark,toShowHorzGridLines,toShowTreeLines,toShowVertGridLines,toThemeAware,toShowBackground];
  TreeOptions.SelectionOptions:=[toExtendedFocus,toRightClickSelect];
  TreeOptions.AutoOptions:=TreeOptions.AutoOptions-[toDisableAutoscrollOnFocus];

 // BiDiMode:=bdRightToLeft;

  FDataLink:=TBisDBTreeDataLink.Create(Self);

  FKeyFields:=TStringList.Create;
  FParentFields:=TStringList.Create;

  FSearchColor:=ColorSearching;
  FSortColumnColor:=ColorSorted;
  FChessColor:=ColorChess;
  FRowColor:=ColorControlFocused;

  FGradientVisible:=false;
  FGradientStyle:=gsVertical;
  FGradientBeginColor:=clWhite;
  FGradientEndColor:=ColorSelected;

  Colors.FocusedColor:=clHighlightText;
  Colors.FocusedSelectionColor:=clHighlight;
  
  Margin:=0;
  TextMargin:=2;
  Header.Height:=DefaultNodeHeight;

  GridEmulate:=true;
end;

procedure TBisDBTree.CreateNavigatorColumn;
begin
  if not Assigned(FNavigatorColumn) then begin
    FNavigatorColumn:=TBisDBTreeColumn(Header.Columns.Insert(0));
    FNavigatorColumn.Options:=FNavigatorColumn.Options-[coAllowClick,coDraggable,coEnabled,coResizable,
                                                        coParentColor,coShowDropMark,coAutoSpring]+[coFixed];
    FNavigatorColumn.Alignment:=taRightJustify;
    FNavigatorColumn.Text:='#';
    FNavigatorColumn.Position:=0;
    ResizeNavigatorColumn;
  end;
end;

destructor TBisDBTree.Destroy;
begin
  DestroyNavigatorColumn;
  FParentFields.Free;
  FKeyFields.Free;
  FDataLink.Free;
  FIndicators.Free;
  inherited Destroy;
end;

procedure TBisDBTree.DestroyNavigatorColumn;
begin
  if Assigned(FNavigatorColumn) then begin
    Header.Columns.Delete(FNavigatorColumn.Index);
    FNavigatorColumn:=nil;
  end;
end;

procedure TBisDBTree.CancelIncrementalSearch;
begin
  inherited CancelIncrementalSearch;
  InvalidateNode(FocusedNode);
end;

procedure TBisDBTree.DefaultTextDrawing(Text: WideString; Rect: TRect);
begin
  if not (tsDefaultTextDrawing in FStates) then begin
    Include(FStates,tsDefaultTextDrawing);
    try
      if Assigned(FOldPaintInfo.Canvas) then
        DoTextDrawing(FOldPaintInfo,Text,Rect,FOldDrawFormat);
    finally
      Exclude(FStates,tsDefaultTextDrawing);
    end;
  end;
end;

function TBisDBTree.CanFirst: Boolean;
var
  Node: PVirtualNode;
begin
  Node:=GetFirst;
  Result:=Assigned(Node) and (Node<>FocusedNode);
end;

procedure TBisDBTree.First;
begin
  if CanFirst then begin
    FocusedNode:=GetFirst;
    if Assigned(FocusedNode) then begin
      ClearSelection;
      Selected[FocusedNode]:=True;
      ScrollIntoView(FocusedNode,false);
    end;
  end;
end;

function TBisDBTree.CanLast: Boolean;
var
  Node: PVirtualNode;
begin
  Node:=GetLast;
  Result:=Assigned(Node) and (Node<>FocusedNode);
end;

procedure TBisDBTree.Last;
begin
  if CanLast then begin
    FocusedNode:=GetLast;
    if Assigned(FocusedNode) then begin
      ClearSelection;
      Selected[FocusedNode]:=True;
      ScrollIntoView(FocusedNode,true);
    end;
  end;
end;

function TBisDBTree.CanNext: Boolean;
var
  Node: PVirtualNode;
begin
  Node:=GetNext(FocusedNode);
  Result:=Assigned(Node);
end;

procedure TBisDBTree.Next;
begin
  if CanNext then begin
    FocusedNode:=GetNext(FocusedNode);
    if Assigned(FocusedNode) then begin
      ClearSelection;
      Selected[FocusedNode]:=True;
    end;
  end;
end;

function TBisDBTree.CanPrior: Boolean;
var
  Node: PVirtualNode;
begin
  Node:=GetPrevious(FocusedNode);
  Result:=Assigned(Node);
end;

procedure TBisDBTree.Prior;
begin
  if CanPrior then begin
    FocusedNode:=GetPrevious(FocusedNode);
    if Assigned(FocusedNode) then begin
      ClearSelection;
      Selected[FocusedNode]:=True;
    end;
  end;
end;

procedure TBisDBTree.CollapseAll;
begin
  FullCollapse(RootNode);
end;

procedure TBisDBTree.CopyFromFieldNames(FieldNames: TBisFieldNames; WithClear: Boolean);
var
  Column: TBisDBTreeColumn;
  i: Integer;
  Item: TBisFieldName;
  FlagKey: Boolean;
  FlagParent: Boolean;
  OldNavigatorVisible: Boolean;
  AKeyFieldNames: String;
  AParentFieldNames: String;
  FlagKeyEmpty: Boolean;
  FlagParentEmpty: Boolean;
  OldAutoResizeable: Boolean;
begin
  OldNavigatorVisible:=NavigatorVisible;
  OldAutoResizeable:=AutoResizeableColumns;
  try
    NavigatorVisible:=false;
    AutoResizeableColumns:=false;
    if WithClear then
      Header.Columns.Clear;

    if Assigned(FieldNames) then begin
      FlagKeyEmpty:=Trim(KeyFieldNames)='';
      FlagParentEmpty:=Trim(ParentFieldNames)='';
      FlagKey:=false;
      FlagParent:=false;
      for i:=0 to FieldNames.Count-1 do begin
        Item:=FieldNames.Items[i];

        if Item.IsKey and FlagKeyEmpty then begin
          if not FlagKey then begin
            AKeyFieldNames:=Item.FieldName;
            FlagKey:=true;
          end else
            AKeyFieldNames:=AKeyFieldNames+';'+Item.FieldName;
        end;

        if Item.IsParent and FlagParentEmpty then begin
          if not FlagParent then begin
            AParentFieldNames:=Item.FieldName;
            FlagParent:=true;
          end else
            AParentFieldNames:=AParentFieldNames+';'+Item.FieldName;
        end;

        if ((Item.Caption)<>'') then begin
          Column:=TBisDBTreeColumn(Header.Columns.Add);
          Column.Text:=Item.Caption;
          Column.FieldName:=Item.FieldName;
          Column.VisualType:=Item.VisualType;
          Column.DisplayFormat:=Item.DisplayFormat;

          if Item.Visible then
            Column.Options:=Column.Options+[coVisible]
          else Column.Options:=Column.Options-[coVisible];

          Column.AlignmentDefault:=false;
          case Item.Alignment of
            daDefault: Column.AlignmentDefault:=true;
            daLeft: Column.Alignment:=taLeftJustify;
            daCenter: Column.Alignment:=taCenter;
            daRight: Column.Alignment:=taRightJustify;
          end;
          if Item.Width>0 then begin
            Column.Width:=Item.Width
          end else if Item.Width=0 then begin
//            Column.Width:=50;
          end;
          Column.MinWidth:=20;

        end;
      end;

      KeyFieldNames:=AKeyFieldNames;

      if FGridEmulate then
        ParentFieldNames:=''
      else
        ParentFieldNames:=AParentFieldNames;

    end;
  finally
    AutoResizeableColumns:=OldAutoResizeable;
    NavigatorVisible:=OldNavigatorVisible;
  end;
end;

procedure TBisDBTree.DoAfterCellPaint(Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
var
  RightBorderFlag,
  NormalButtonStyle,
  NormalButtonFlags: Cardinal;
  Index: Integer;
  L: Integer;
  T: Integer;
  W: Integer;
  H: Integer;
  Rect: TRect;
  S: String;
  Vs: Integer;
  AColumn: TBisDBTreeColumn;
  Details: TThemedElementDetails;
begin
  if Assigned(FNavigatorColumn) then begin
    if Column=0 then begin

      if toShowVertGridLines in TreeOptions.PaintOptions then
        Inc(CellRect.Right);
      if toShowHorzGridLines in TreeOptions.PaintOptions then
        Inc(CellRect.Bottom);

      if not ThemeServices.ThemesEnabled then begin
        RightBorderFlag := BF_RIGHT;
        case Header.Style of
          hsThickButtons:
            begin
              NormalButtonStyle := BDR_RAISEDINNER or BDR_RAISEDOUTER;
              NormalButtonFlags := BF_LEFT or BF_TOP or BF_BOTTOM or BF_MIDDLE or BF_SOFT or BF_ADJUST;
            end;
          hsFlatButtons:
            begin
              NormalButtonStyle := BDR_RAISEDINNER;
              NormalButtonFlags := BF_LEFT or BF_TOP or BF_BOTTOM or BF_MIDDLE or BF_ADJUST;
            end;
        else
          begin
            NormalButtonStyle := BDR_RAISEDINNER;
            NormalButtonFlags := BF_RECT or BF_MIDDLE or BF_SOFT or BF_ADJUST;
          end;
        end;
        DrawEdge(Canvas.Handle, CellRect, NormalButtonStyle, NormalButtonFlags or RightBorderFlag);
      end else begin
        Details:=ThemeServices.GetElementDetails(thHeaderItemNormal);
        ThemeServices.DrawElement(Canvas.Handle, Details, CellRect);
      end;

      L:=CellRect.Right - FIndicators.Width - 3;
      T:=(CellRect.Bottom-CellRect.Top) div 2 - FIndicators.Height div 2 - 1;

      if Assigned(FocusedNode) then
        if Node=FocusedNode then begin
          Index:=0;
{          if dbtsEditing in DBStatus then
            Index:=1;
          if dbtsInsert in DBStatus then
            Index:=2;}
          FIndicators.Draw(Canvas,CellRect.Left+L,CellRect.Top+T,Index);
        end else begin
          if vsSelected in Node.States then begin
            Index:=3;
            FIndicators.Draw(Canvas,CellRect.Left+L,CellRect.Top+T,Index);
          end;
        end;

      if FNumberVisible then begin
        if Column=0 then begin
          S:=IntToStr(GetVisibleIndex(Node));
          Rect:=CellRect;
          Rect.Left:=Rect.Left;
          Rect.Right:=L-2;
          DefaultTextDrawing(S,Rect);
        end;
      end;
    end;
  end;

  if Assigned(Node) and (Node=FocusedNode) then begin
    if (Column=FocusedColumn) then begin
      if FSearchEnabled and (Length(SearchBuffer)>0) then begin
        AColumn:=Header.Columns[Column];
        if Assigned(AColumn) then begin
          S:=Copy(Text[Node,Column],1,Length(SearchBuffer));
          W:=Canvas.TextWidth(S);
          H:=Canvas.TextHeight(S);
          Rect:=GetDisplayRect(Node,Column,true,false);
          Rect.Left:=Rect.Left+TextMargin;
          Rect.Right:=Rect.Left+W+1;
          Rect.Top:=(CellRect.Bottom - CellRect.Top) div 2 - H div 2;
          Rect.Bottom:=(CellRect.Bottom - CellRect.Top) div 2 + H div 2 + 1;
          Canvas.Brush.Color:=FSearchColor;
          Canvas.FillRect(Rect);
          case AColumn.Alignment of
            taLeftJustify: Rect.Left:=Rect.Left;
            taRightJustify: Rect.Left:=Rect.Left;
            taCenter: Rect.Left:=Rect.Left;
          end;
          Rect.Right:=Rect.Right;
          FOldDrawFormat:=FOldDrawFormat and DT_LEFT;
          DefaultTextDrawing(S,Rect);
        end;
      end;
    end;
  end;

  if Assigned(Node) and (Column<>NoColumn) then begin
    S:=Text[Node,Column];
    AColumn:=Header.Columns[Column];
    if Assigned(AColumn) then begin
      case AColumn.VisualType of
        vtCheckBox, vtRadioButton: begin
          Rect:=CellRect;
          InflateRect(Rect,-1,-1);
          Canvas.FillRect(Rect);
          Rect:=CellRect;
          Rect.Top:=Rect.Top+2;
          Rect.Bottom:=Rect.Bottom-2;
          if TryStrToInt(S,Vs) then begin
            if Boolean(Vs) then begin
              if not ThemeServices.ThemesEnabled then begin
                if AColumn.VisualType=vtCheckBox then
                  DrawFrameControl(Canvas.Handle,Rect,DFC_BUTTON,DFCS_CHECKED)
                else DrawFrameControl(Canvas.Handle,Rect,DFC_BUTTON,DFCS_BUTTONRADIO or DFCS_CHECKED);
              end else begin
                if AColumn.VisualType=vtCheckBox then begin
                  Details:=ThemeServices.GetElementDetails(tbCheckBoxCheckedNormal);
                  ThemeServices.DrawElement(Canvas.Handle, Details, Rect);
                end else begin
                  Details:=ThemeServices.GetElementDetails(tbRadioButtonCheckedNormal);
                  ThemeServices.DrawElement(Canvas.Handle, Details, Rect);
                end;
              end;
            end else begin
              if not ThemeServices.ThemesEnabled then begin
                if AColumn.VisualType=vtCheckBox then
                  DrawFrameControl(Canvas.Handle,Rect,DFC_BUTTON,DFCS_BUTTONCHECK)
                else DrawFrameControl(Canvas.Handle,Rect,DFC_BUTTON,DFCS_BUTTONRADIO);
              end else begin
                if AColumn.VisualType=vtCheckBox then begin
                  Details:=ThemeServices.GetElementDetails(tbCheckBoxUncheckedNormal);
                  ThemeServices.DrawElement(Canvas.Handle, Details, Rect);
                end else begin
                  Details:=ThemeServices.GetElementDetails(tbRadioButtonUncheckedNormal);
                  ThemeServices.DrawElement(Canvas.Handle, Details, Rect);
                end;
              end;
            end;
          end;
        end;
      end;
    end;

  end; 

  inherited DoAfterCellPaint(Canvas,Node,Column,CellRect);
end;

procedure TBisDBTree.DoBeforeCellPaint(Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
var
  InChess: Boolean;
begin
  if FSortColumnVisible then begin
    if Column=Header.SortColumn then begin
      Canvas.Brush.Color:=FSortColumnColor;
      Canvas.FillRect(CellRect);
    end;
  end;

  if FChessVisible then begin
    InChess:=not Odd(GetVisibleIndex(Node));
    if InChess then begin
      Canvas.Brush.Color:=FChessColor;
      Canvas.FillRect(CellRect);
    end;
  end;

  if FRowVisible and (Node=FocusedNode) then begin
    if Column<>FocusedColumn then begin
      Canvas.Brush.Color:=FRowColor;
      Canvas.FillRect(CellRect);
    end;
  end;

  inherited DoBeforeCellPaint(Canvas,Node,Column,CellRect);
end;

function TBisDBTree.DoCompare(Node1, Node2: PVirtualNode; Column: TColumnIndex): Integer;
var
  AColumn: TBisDBTreeColumn;

  procedure CompareByNumber;
  var
    ND1, ND2: PBisDBTreeNodeData;
    V1, V2: Variant;
    E1, E2: Extended;
    AIndex: Integer;
  begin
    ND1:=GetNodeData(Node1);
    ND2:=GetNodeData(Node2);
    if Assigned(ND1) and Assigned(ND2) then begin
      AIndex:=GetValueIndex(AColumn);
      if AIndex<>-1 then begin
        V1:=ND1.Values[AIndex];
        V2:=ND2.Values[AIndex];
        E1:=VarToExtendedDef(V1,0.0);
        E2:=VarToExtendedDef(V2,0.0);
        if E1>E2 then
          Result:=1
        else Result:=-1;
      end;
    end;
  end;

  procedure CompareByDateTime;
  var
    ND1, ND2: PBisDBTreeNodeData;
    V1, V2: Variant;
    D1, D2: TDateTime;
    AIndex: Integer;
  begin
    ND1:=GetNodeData(Node1);
    ND2:=GetNodeData(Node2);
    if Assigned(ND1) and Assigned(ND2) then begin
      AIndex:=GetValueIndex(AColumn);
      if AIndex<>-1 then begin
        V1:=ND1.Values[AIndex];
        V2:=ND2.Values[AIndex];
        D1:=VarToDateDef(V1,0.0);
        D2:=VarToDateDef(V2,0.0);
        if D1>D2 then
          Result:=1
        else Result:=-1;
      end;
    end;
  end;

  procedure CompareByString;
  var
    ND1, ND2: PBisDBTreeNodeData;
    V1, V2: Variant;
    S1, S2: String;
    AIndex: Integer;
  begin
    ND1:=GetNodeData(Node1);
    ND2:=GetNodeData(Node2);
    if Assigned(ND1) and Assigned(ND2) then begin
      AIndex:=GetValueIndex(AColumn);
      if AIndex<>-1 then begin
        V1:=ND1.Values[AIndex];
        V2:=ND2.Values[AIndex];
        S1:=VarToStrDef(V1,'');
        S2:=VarToStrDef(V2,'');
        if S1>S2 then
          Result:=1
        else Result:=-1;
      end;
    end;
  end;
           
var
  Field: TField;
begin
  Result:=0;
  if (Header.SortColumn<>NoColumn) and Assigned(Node1) and Assigned(Node2) and
     (Column=Header.SortColumn) then begin
    AColumn:=Header.Columns[Column];
    if Assigned(AColumn) and (AColumn<>FNavigatorColumn) then begin
      Field:=AColumn.Field;
      if Assigned(Field) then begin
        case Field.DataType of
          ftSmallint,ftInteger,ftWord,ftFloat,ftCurrency,ftLargeint,ftBCD,ftFMTBcd: CompareByNumber;
          ftDate,ftTime,ftDateTime,ftTimeStamp: CompareByDateTime;
        else
          CompareByString;
        end;
      end;
    end;
  end else
    Result:=inherited DoCompare(Node1,Node2,Column);
end;

procedure TBisDBTree.DoFocusChange(Node: PVirtualNode; Column: TColumnIndex);
begin
  if not (tsFocusChanging in FStates) and
     not (tsDataSetChanging in FStates) and
     not (tsDataSetDeleting in FStates) and
     not (tsDataSetPosting in FStates) and
     not (tsTextGetting in FStates) then begin

    Include(FStates,tsFocusChanging);
    try
      GoToNode(Node);
      ResizeNavigatorColumn;
    finally
      Exclude(FStates,tsFocusChanging);
    end;
  end;

  inherited DoFocusChange(Node,Column);
end;

function TBisDBTree.DoFocusChanging(OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex): Boolean;
begin
  Result:=inherited DoFocusChanging(OldNode,NewNode,OldColumn,NewColumn);
  if Assigned(FNavigatorColumn) and (OldColumn<>NewColumn) then begin
    Result:=Result and (NewColumn>0);
  end;
end;

procedure TBisDBTree.DoFreeNode(Node: PVirtualNode);
var
  Data: PBisDBTreeNodeData;
begin
  Data:=GetNodeData(Node);
  if Assigned(Data) then begin
    Data.Bookmark:=nil;
    SetLength(Data.KeyValues,0);
    SetLength(Data.Values,0);
  end;
  inherited DoFreeNode(Node);
end;

function TBisDBTree.DoPaintBackground(Canvas: TCanvas; R: TRect): Boolean;
begin
  if FGradientVisible then begin
    Canvas.Brush.Style:=bsSolid;
    DrawGradient(Canvas,GetClientRect,FGradientStyle,FGradientBeginColor,FGradientEndColor);
    Result:=true;
  end else
    Result:=inherited DoPaintBackground(Canvas,R);
end;

procedure TBisDBTree.DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex; TextType: TVSTTextType);
begin
  inherited DoPaintText(Node,Canvas,Column,TextType);
end;

type
  THackDataSet=class(TDataSet)
  end;

function TBisDBTree.DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
                                    var Index: Integer): TCustomImageList;
begin
  if Column=Header.MainColumn then begin
    case Kind of
      ikNormal,ikSelected: begin
         if Node.ChildCount=0 then begin
           Index:=FLastIndex;
         end else begin
           if vsExpanded in Node.States then
             Index:=FOpenIndex
           else
             Index:=FNormalIndex;
         end;
      end;
    end;
  end;
  Result:=inherited DoGetImageIndex(Node,Kind,Column,Ghosted,Index);
end;

function TBisDBTree.DoGetPopupMenu(Node: PVirtualNode; Column: TColumnIndex; Position: TPoint): TPopupMenu;
begin
  Result:=nil;
end;

function TBisDBTree.GetNodeValue(Node: PVirtualNode; FieldName: String): Variant;
var
  Index: Integer;
  Data: PBisDBTreeNodeData;
begin
  Result:=Null;
  if Assigned(Node) then begin
    Index:=GetValueIndex(FieldName);
    if Index>-1 then begin
      Data:=GetNodeData(Node);
      if Assigned(Data) then
        Result:=Data.Values[Index];
    end;
  end;
end;

function TBisDBTree.GetValueIndex(Column: TBisDBTreeColumn): Integer;
begin
  Result:=-1;
  if Assigned(Column) then begin
    Result:=Column.Index;
    if FNavigatorVisible then
      Dec(Result);
  end;
end;

function TBisDBTree.GetValueIndex(FieldName: String): Integer;
var
  AColumn: TBisDBTreeColumn;
begin
  Result:=-1;
  AColumn:=Header.Columns.Find(FieldName);
  if Assigned(AColumn) then
    Result:=GetValueIndex(AColumn);
end;

procedure TBisDBTree.DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString);

  function GetTextByColumn(AColumn: TBisDBTreeColumn; Data: PBisDBTreeNodeData): String;
  var
    S: String;
    Field: TField;
    AIndex: Integer;
    Value: Variant;
  begin
    AIndex:=GetValueIndex(AColumn);
    if AIndex<>-1 then begin
      Value:=Data.Values[AIndex];
      if not VarIsNull(Value) then begin
        Result:=VarToStrDef(Value,'');
        S:=AColumn.DisplayFormat;
        if S<>'' then begin
          Field:=AColumn.Field;
          if Assigned(Field) then
            case Field.DataType of
              ftSmallint,ftInteger,ftWord,ftFloat,ftCurrency,ftLargeint,ftFMTBcd,ftBCD: Result:=FormatFloat(S,StrToFloatDef(Result,0.0));
              ftDate,ftTime,ftDateTime,ftTimeStamp: Result:=FormatDateTime(S,StrToDateTimeDef(Result,0.0));
            end;
        end;
      end;
    end;
  end;

var
  Data: PBisDBTreeNodeData;
  AColumn: TBisDBTreeColumn;
  Flag: Boolean;
begin
  AColumn:=Header.Columns[Column];
  Flag:=true;
  if FNavigatorVisible then
    Flag:=FNavigatorColumn<>AColumn;
  if Flag then begin
    Data:=GetNodeData(Node);
    if Assigned(Data) and Assigned(AColumn) and
       not (tsTextGetting in FStates) and
       not (tsDataSetChanging in FStates) then begin

      Include(FStates,tsTextGetting);
      try
        Text:=GetTextByColumn(AColumn,Data);
      finally
        Exclude(FStates,tsTextGetting);
      end;
      
    end;
  end;
end;

procedure TBisDBTree.DoHeaderClick(Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Success: Boolean;
  OrderType: TBisOrderType;
  AColumn: TBisDBTreeColumn;
begin
  if FSortEnabled and (Column>-1) then begin
    if Button = mbLeft then begin
      OrderType:=otNone;
      if Header.SortColumn <> Column then begin
        OrderType:=otAsc;
      end else begin
        case Header.SortDirection of
          sdAscending: OrderType:=otDesc;
          sdDescending: OrderType:=otNone;
        end;
      end;
      Success:=true;
      AColumn:=Header.Columns[Column];
      if Assigned(AColumn) then begin
        DoSort(AColumn.FieldName,OrderType,Success);
        if Success then begin
          case OrderType of
            otNone: begin
              Header.SortColumn:=NoColumn;
              SortTree(NoColumn,Header.SortDirection);
            end;
            otAsc: begin
              Header.SortDirection:=sdAscending;
              Header.SortColumn:=Column;
              SortTree(Column,Header.SortDirection);
            end;
            otDesc: begin
              Header.SortDirection:=sdDescending;
              Header.SortColumn:=Column;
              SortTree(Column,Header.SortDirection);
            end;
          end;
        end;
      end;
    end;
  end else
    inherited DoHeaderClick(Column,Button,Shift,X,Y);
end;

procedure TBisDBTree.DoHeaderDragged(Column: TColumnIndex; OldPosition: TColumnPosition);
begin
  if Assigned(FNavigatorColumn) then begin
    if FNavigatorColumn.Position>Header.Columns[Column].Position then
      Header.Columns[Column].Position:=OldPosition;
  end;
  inherited DoHeaderDragged(Column,OldPosition);
end;

function TBisDBTree.DoIncrementalSearch(Node: PVirtualNode; const Text: WideString): Integer;
var
  S: String;
  APos: Integer;
begin
  Result:=1;
  if FocusedColumn<>NoColumn then begin
    if Assigned(Node) then begin
      S:=Self.Text[Node,FocusedColumn];
      APos:=AnsiPos(AnsiUpperCase(Text),AnsiUpperCase(S));
      if APos=1 then
        Result:=0;
    end;
  end;
end;

procedure TBisDBTree.DoProgress(Min, Max, Position: Integer; var Interrupted: Boolean);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self,Min,Max,Position,Interrupted);
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

procedure TBisDBTree.SetFirstVisibleColumn;
var
  i, Index, NewIndex: Integer;
  Column: TBisDBTreeColumn;
begin
  if Header.Columns.Count>0 then begin
    if Assigned(FNavigatorColumn) then
      Index:=1
    else Index:=0;
  end else
    Index:=FocusedColumn;

  NewIndex:=Index;

  if Index>-1 then
    for i:=Index to Header.Columns.Count-1 do begin
      Column:=Header.Columns.Items[i];
      if coVisible in Column.Options then begin
        NewIndex:=i;
        break;
      end;
    end;

  FocusedColumn:=NewIndex;

end;

function TBisDBTree.GetHeader: TBisDBTreeHeader;
begin
  Result:=TBisDBTreeHeader(inherited Header);
end;

function TBisDBTree.GetHeaderClass: TVTHeaderClass;
begin
  Result:=TBisDBTreeHeader;
end;

procedure TBisDBTree.SetAutoResizeableColumns(const Value: Boolean);
begin
  FAutoResizeableColumns := Value;
  Resize;
end;

procedure TBisDBTree.SetChessColor(const Value: TColor);
begin
  FChessColor := Value;
  Invalidate;
end;

procedure TBisDBTree.SetChessVisible(const Value: Boolean);
begin
  FChessVisible := Value;
  Invalidate;
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

procedure TBisDBTree.SetGradientBeginColor(const Value: TColor);
begin
  FGradientBeginColor := Value;
  Invalidate;
end;

procedure TBisDBTree.SetGradientEndColor(const Value: TColor);
begin
  FGradientEndColor := Value;
  Invalidate;
end;

procedure TBisDBTree.SetGradientStyle(const Value: TBisGradientStyle);
begin
  FGradientStyle := Value;
  Invalidate;
end;

procedure TBisDBTree.SetGradientVisible(const Value: Boolean);
begin
  FGradientVisible := Value;
  Invalidate;
end;

procedure TBisDBTree.SetGridEmulate(const Value: Boolean);
begin
  if Value<>FGridEmulate then begin
    FGridEmulate:=Value;
    if FGridEmulate then begin
      TreeOptions.PaintOptions:=TreeOptions.PaintOptions-[toShowButtons,toShowRoot];
//      TreeOptions.SelectionOptions:=TreeOptions.SelectionOptions+[toCenterScrollIntoView];
    end else begin
      TreeOptions.PaintOptions:=TreeOptions.PaintOptions+[toShowButtons,toShowRoot];
//      TreeOptions.SelectionOptions:=TreeOptions.SelectionOptions-[toCenterScrollIntoView];
    end;
    RefreshNodes;
  end;
end;

function TBisDBTree.GetKeyFieldNames: String;
begin
  Result:=GetStringByStrings(FKeyFields,';');
end;

procedure TBisDBTree.SetKeyFieldNames(const Value: String);
begin
  FKeyFields.Clear;
  GetStringsByString(Value,';',FKeyFields);
end;

function TBisDBTree.GetParentFieldNames: String;
begin
  Result:=GetStringByStrings(FParentFields,';');
end;

procedure TBisDBTree.SetParentFieldNames(const Value: String);
begin
  FParentFields.Clear;
  GetStringsByString(Value,';',FParentFields);
end;

procedure TBisDBTree.SetRowColor(const Value: TColor);
begin
  FRowColor := Value;
  Invalidate;
end;

procedure TBisDBTree.SetRowVisible(const Value: Boolean);
begin
  FRowVisible := Value;
  Invalidate;
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

procedure TBisDBTree.SetNavigatorVisible(const Value: Boolean);
begin
  if FNavigatorVisible<>Value then begin
    FNavigatorVisible:=Value;
    if FNavigatorVisible then begin
      Header.MainColumn:=0;
      DestroyNavigatorColumn;
      CreateNavigatorColumn;
      Header.MainColumn:=1;
    end else begin
      DestroyNavigatorColumn;
      Header.MainColumn:=0;
    end;
  end;
end;

procedure TBisDBTree.SetNumberVisible(const Value: Boolean);
begin
  FNumberVisible := Value;
  if FNumberVisible then
    NavigatorVisible:=true;
  ResizeNavigatorColumn;
end;

procedure TBisDBTree.SetSearchEnabled(const Value: Boolean);
begin
  FSearchEnabled := Value;
  if Value then
    IncrementalSearch:=isAll
  else
    IncrementalSearch:=isNone;
end;

procedure TBisDBTree.SetSortColumnColor(const Value: TColor);
begin
  FSortColumnColor := Value;
  Invalidate;
end;

procedure TBisDBTree.SetSortColumnVisible(const Value: Boolean);
begin
  FSortColumnVisible := Value;
  Invalidate;
end;

procedure TBisDBTree.Synchronize;
begin
  DoReadNode(FocusedNode);
end;

procedure TBisDBTree.WMWindowPosChanged(var Message: TWMWindowPosChanged);

  procedure NewColumnWidths;
  var
    i: Integer;
    StartI: Integer;
    NewWidth: Integer;
    ScrollWidth: Integer;
    NavWidth: Integer;
    K: Extended;
  begin
    if not FStopAutoResizeColumns then begin
      FStopAutoResizeColumns:=true;
      Header.Columns.BeginUpdate;
      try
        NavWidth:=0;
        if Assigned(FNavigatorColumn) then
          NavWidth:=FNavigatorColumn.Width;
        ScrollWidth:=iff(FVerticalScrollBarVisible,GetSystemMetrics(SM_CXHSCROLL),0);
        NewWidth:=ClientWidth-NavWidth-FSaveEmptyWidth-ScrollWidth;
        K:=1;
        if FSaveColumnsWidth>0 then
          K:=NewWidth/FSaveColumnsWidth;
        StartI:=iff(Assigned(FNavigatorColumn),1,0);
        for i:=StartI to Header.Columns.Count-1 do begin
          Header.Columns[i].Width:=Round(Header.Columns[i].Width*K);
        end;
      finally
        Header.Columns.EndUpdate;
        FStopAutoResizeColumns:=False;
      end;
    end;
  end;

begin
  if FAutoResizeableColumns then
     NewColumnWidths;
  inherited;
end;

procedure TBisDBTree.WMWindowPosChanging(var Message: TWMWindowPosChanging);

  procedure SaveColumnsWidths;
  var
    i: Integer;
    StartI: Integer;
    ScrollWidth: Integer;
    NavWidth: Integer;
  begin
    if not FStopAutoResizeColumns then begin
      FSaveColumnsWidth:=0;
      StartI:=iff(Assigned(FNavigatorColumn),1,0);
      for i:=StartI to Header.Columns.Count-1 do begin
        FSaveColumnsWidth:=FSaveColumnsWidth+Header.Columns[i].Width;
      end;
      NavWidth:=0;
      if Assigned(FNavigatorColumn) then
        NavWidth:=FNavigatorColumn.Width;
      ScrollWidth:=iff(FVerticalScrollBarVisible,GetSystemMetrics(SM_CXHSCROLL),0);
      FSaveEmptyWidth:=ClientWidth-NavWidth-FSaveColumnsWidth-ScrollWidth;
    end;
  end;

begin
  inherited;
  if FAutoResizeableColumns then
     SaveColumnsWidths;
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

function TBisDBTree.GetSelectedFieldName: String;
var
  Column: TBisDBTreeColumn;
begin
  Result:='';
  if FocusedColumn<>-1 then begin
    Column:=Header.Columns[FocusedColumn];
    if Assigned(Column) then
      Result:=Column.FieldName;
  end;
end;

function TBisDBTree.GetVisibleIndex(Node: PVirtualNode): Cardinal;
begin
  Result:=0;
  while Assigned(Node) and (Node <> RootNode) do begin
    if vsVisible in Node.States then begin
      if Node <> RootNode then
        Inc(Result);
    end;
    Node:=GetPreviousVisible(Node);
  end;
end;

procedure TBisDBTree.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if SearchEnabled and (Key=VK_ESCAPE) then
    CancelIncrementalSearch;
  inherited KeyDown(Key,Shift);
end;

procedure TBisDBTree.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{var
  HitInfo: THitInfo;
  Pt: TPoint;}
begin
{  if Button=mbRight then begin
    GetCursorPos(Pt);
    GetHitTestInfoAt(X,Y,True,HitInfo);
    if Assigned(HitInfo.HitNode) then begin
      if not MultiSelect then
        ClearSelection;
      FocusedNode:=HitInfo.HitNode;
      Selected[HitInfo.HitNode]:=True;
    end;
  end;}
  inherited MouseDown(Button,Shift,X,Y);
end;

function TBisDBTree.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
var
  OldNode: PVirtualNode;
begin
  inherited DoMouseWheelDown(Shift,MousePos);
  OldNode:=FocusedNode;
  FocusedNode:=GetNextVisible(OldNode);
  if Assigned(FocusedNode) then begin
    Selected[FocusedNode]:=True;
  //  ScrollIntoView(FocusedNode,true);
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
  FocusedNode:=GetPreviousVisible(OldNode);
  if Assigned(FocusedNode) then begin
    Selected[FocusedNode]:=True;
  //  ScrollIntoView(FocusedNode,true);
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
      deLayoutChange: ; //Enabled:=not Enabled;
      deUpdateRecord: ;
      deUpdateState: ;
      deCheckBrowseMode: ;//Result:=not FDataLoading;
      dePropertyChange: ;
      deFieldListChange: ;
      deFocusControl: ;
      deParentScroll: ;
      deConnectChange: ;
      deReconcileError: ;
      deDisabledStateChange: ;//Enabled:=false;
    end;
  end;
end;

function TBisDBTree.GetKeyValues(Fields: TStrings; Values: PBisDBTreeValueArray): Boolean;
var
  i: Integer;
  DataSet: TDataSet;
begin
  Result:=false;
  DataSet:=GetDataSet;
  if Assigned(Values) and Assigned(DataSet) and DataSet.Active and FindFields(Fields) then begin
    if Length(Values^)<>Fields.Count then
      SetLength(Values^,Fields.Count);
    for i:=0 to Fields.Count-1 do
      Values^[Low(Values^)+i]:=DataSet.FieldByName(Fields[i]).Value;
  end;
end;

procedure TBisDBTree.DoReadNode(Node: PVirtualNode);
var
  DataSet: TDataSet;
  Data: PBisDBTreeNodeData;
  i: Integer;
  Field: TField;
  AColumn: TBisDBTreeColumn;
  AI,ACount: Integer;
begin
  DataSet:=GetDataSet;
  if Assigned(Node) and Assigned(DataSet) then begin
    Data:=GetNodeData(Node);
    if Assigned(Data) and DataSet.Active then begin
      Data.Bookmark:=DataSet.GetBookmark;
      GetKeyValues(FKeyFields,@Data.KeyValues);
      AI:=0;
      ACount:=Header.Columns.Count;
      if FNavigatorVisible then begin
        Dec(ACount);
        Inc(AI);
      end;
      if Length(Data.Values)<>ACount then
        SetLength(Data.Values,ACount);
      for i:=AI to Header.Columns.Count-1 do begin
        AColumn:=Header.Columns[i];
        Field:=AColumn.Field;
        if Assigned(Field) then
          Data.Values[i-AI]:=Field.Value;
      end;
    end;
  end;
end;

procedure TBisDBTree.DoShowScrollbar(Bar: Integer; Show: Boolean);
begin
  inherited DoShowScrollbar(Bar,Show);
  if Bar=SB_VERT then begin
    if FVerticalScrollBarVisible<>Show then
      FVerticalScrollBarVisible:=Show;
  end;
end;

procedure TBisDBTree.DoSort(FieldName: String; OrderType: TBisOrderType; var Success: Boolean);
begin
  if Assigned(FOnSort) then
    FOnSort(Self,FieldName,OrderType,Success);
end;

procedure TBisDBTree.DoTextDrawing(var PaintInfo: TVTPaintInfo; Text: WideString; CellRect: TRect;
                                   DrawFormat: Cardinal);
begin
  inherited DoTextDrawing(PaintInfo,Text,CellRect,DrawFormat);
  if not (tsDefaultTextDrawing in FStates) then begin
    FOldPaintInfo:=PaintInfo;
    FOldDrawFormat:=DrawFormat;
  end;
end;

function TBisDBTree.FindNodeByKeyValues(KeyValues: PBisDBTreeValueArray; LastNode: PVirtualNode=nil): PVirtualNode;
var
  Node,N1: PVirtualNode;
  Data: PBisDBTreeNodeData;
begin
  Result:=nil;
  if Length(KeyValues^)>0 then begin
    if Assigned(LastNode) then
      Node:=LastNode
    else
      Node:=GetFirst;
    while Assigned(Node) do begin
      if Assigned(Node) then begin
        Data:=GetNodeData(Node);
        if Assigned(Data) and
           ArraySameValues(Data.KeyValues,KeyValues^) then begin
          Result:=Node;
          break;
        end;
      end;
      if Assigned(LastNode) then begin
        N1:=Node;
        Node:=GetPreviousSibling(N1);
        if Assigned(Node) and (Node.Parent<>RootNode) then
          Node:=Node.Parent
        else
          Node:=GetPrevious(N1);
      end else
        Node:=GetNext(Node);
    end;
  end;
end;

procedure TBisDBTree.SetFirstVisbleNode;
begin
  CollapseAll;

  if Assigned(RootNode) then
    if RootNode.ChildCount=1 then
      Expanded[RootNode]:=true;

  Header.SortColumn:=NoColumn;
  SortTree(NoColumn,Header.SortDirection);

  First;
end;

procedure TBisDBTree.Build;
var
  DataSet: TDataSet;

  procedure BuildGrid;
  var
    B: TBookmark;
    Node: PVirtualNode;
    Disabled: Boolean;
    RCount: Integer;
    Interrupted: Boolean;
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
    Interrupted:=false;
    DoProgress(0,RCount,0,Interrupted);
    try
      DataSet.First;
      while not DataSet.Eof do begin
        Node:=AddChild(nil,nil);
        DoReadNode(Node);
        DoProgress(0,RCount,Position,Interrupted);
        if Interrupted then
          break;
        Inc(Position);
        DataSet.Next;
      end;
    finally
      DoProgress(0,RCount,0,Interrupted);
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
    Interrupted: Boolean;
    Position: Integer;
    ParentValues: TBisDBTreeValueArray;
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
      Interrupted:=false;
      DoProgress(0,RCount,0,Interrupted);
      try
        Node:=nil;
        DataSet.First;
        while not DataSet.Eof do begin
          GetKeyValues(FParentFields,@ParentValues);
          if FDirectScan then
            Node:=nil;
          ParentNode:=FindNodeByKeyValues(@ParentValues,Node);
          Node:=AddChild(ParentNode,nil);
          DoReadNode(Node);
          DoProgress(0,RCount,Position,Interrupted);
          if Interrupted then
            break;
          Inc(Position);
          DataSet.Next;
        end;
      finally
        DoProgress(0,RCount,0,Interrupted);
        if Assigned(B) and DataSet.BookmarkValid(B) then
          DataSet.GotoBookmark(B);
        if Disabled then
          DataSet.EnableControls;
      end;
    end;
  end;

begin
  if not (tsBuilding in FStates) then begin
    Include(FStates,tsBuilding);
    try
      Clear;
      DataSet:=GetDataSet;
      if Assigned(DataSet) then begin
        if DataSet.Active then begin
          if FGridEmulate then
            BuildGrid
          else
            BuildTree;
        end;
        ResizeNavigatorColumn;
      end;
    finally
      Exclude(FStates,tsBuilding);
    end;
  end;
end;

procedure TBisDBTree.ResizeNavigatorColumn;
var
  W: Integer;
  L: Integer;
  S: String;
begin
  if Assigned(FNavigatorColumn) then begin
    W:=IndicatorWidth+1;
    if FNumberVisible then begin
      S:=IntToStr(TotalCount);
      L:=Length(S);
      W:=W+Canvas.TextWidth(DupeString('9',L))+L+2;
    end;
    FNavigatorColumn.MaxWidth:=W;
    FNavigatorColumn.MinWidth:=W;
    FNavigatorColumn.Width:=W;
  end;
end;

procedure TBisDBTree.RefreshNodes;
var
  i: Integer;
  Column: TBisDBTreeColumn;
  Field: TField;
begin
  if Header.Columns.Count>0 then begin
    Build;

    for i:=0 to Header.Columns.Count-1 do begin
      Column:=Header.Columns[i];
      if Assigned(Column) then begin
        Field:=Column.Field;
        if Assigned(Field) then begin

          if Column.AlignmentDefault then
            Column.Alignment:=Field.Alignment;

          if Column.Width=0 then
            Header.Columns.AnimatedResize(Column.Position,GetMaxColumnWidth(Column.Position));

        end;
      end;
    end;

    SetFirstVisibleColumn;
    SetFirstVisbleNode;
  end;
end;

procedure TBisDBTree.DataLinkActiveChanged;
begin
  if not (tsActiveChanging in FStates) then begin
    Include(FStates,tsActiveChanging);
    try
    //  RefreshNodes;
    finally
      Exclude(FStates,tsActiveChanging);
    end;
  end;
end;

function TBisDBTree.FindFields(Fields: TStrings): Boolean;
var
  DataSet: TDataSet;
  i: Integer;
  Flag: Boolean;
begin
  Result:=false;
  if Fields.Count>0 then begin
    DataSet:=GetDataSet;
    if Assigned(DataSet) and DataSet.Active then begin
      for i:=0 to Fields.Count-1 do begin
        Flag:=Assigned(DataSet.FindField(Fields[i]));
        if i=0 then
          Result:=Flag
        else
          Result:=Result and Flag;
      end;
    end;
  end;
end;

procedure TBisDBTree.GoToNode(Node: PVirtualNode);
var
  Data: PBisDBTreeNodeData;
  DataSet: TDataSet;
begin
  if Assigned(Node) then begin
    Data:=GetNodeData(Node);
    DataSet:=GetDataSet;
    if Assigned(Data) and Assigned(DataSet) and DataSet.Active then begin
      if Assigned(Data.Bookmark) and DataSet.BookmarkValid(Data.Bookmark) then
        DataSet.GotoBookmark(Data.Bookmark);
    end;
  end;
end;

procedure TBisDBTree.ScrollIntoSelect;
begin
  if Assigned(FocusedNode) then
    ScrollIntoView(FocusedNode,true);
end;

procedure TBisDBTree.SelectNode(Node: PVirtualNode; Scroll: Boolean);
begin
  if not Selected[Node] then begin
    ClearSelection;
    Selected[Node]:=True;
  end;
  if FocusedNode<>Node then
    FocusedNode:=Node;
  if Assigned(Node) then
    IsVisible[Node]:=true;


  if Scroll then
    ScrollIntoView(Node,true);
end;

procedure TBisDBTree.DataLinkDataSetChanged;
var
  DataSet: TDataSet;
  Node: PVirtualNode;
  KeyValues: TBisDBTreeValueArray;
begin
  if not (tsDataSetChanging in FStates) and
     not (tsDataSetPosting in FStates) and
     not (tsDataSetDeleting in FStates) and
     not (tsTextGetting in FStates) and
     not (tsFocusChanging in FStates) and
     not (tsUpdating in TreeStates) and
     not (tsBuilding in FStates) then begin

    Include(FStates,tsDataSetChanging);
    try
      DataSet:=GetDataSet;
      if Assigned(DataSet) and DataSet.Active then begin
        case DataSet.State of
          dsBrowse: begin
            GetKeyValues(FKeyFields,@KeyValues);
            Node:=FindNodeByKeyValues(@KeyValues);
            SelectNode(Node,true);
          end;
          dsEdit: ;
        end;
      end;
    finally
      Exclude(FStates,tsDataSetChanging);
    end;
  end;
end;

procedure TBisDBTree.DataLinkRecordChanged(Field: TField);
var
  DataSet: TDataSet;
  Node: PVirtualNode;
  Data: PBisDBTreeNodeData;
begin
  if not (tsRecordChanging in FStates) then begin
    Include(FStates,tsRecordChanging);
    try
      DataSet:=GetDataSet;
      if Assigned(DataSet) and DataSet.Active and
         Assigned(Field) and (DataSet.State=dsEdit) then begin
        Node:=FocusedNode;
        if Assigned(Node) then begin
          Data:=GetNodeData(Node);
          if Assigned(Data) then ;
        end;
      end;
    finally
      Exclude(FStates,tsRecordChanging);
    end;
  end;
end;

procedure TBisDBTree.DataLinkDataSetDelete(After: Boolean);
var
  DataSet: TDataSet;
  Node,NextNode: PVirtualNode;
  Data: PBisDBTreeNodeData;
begin
  if After then begin
    if not (tsDataSetDeleting in FStates) and
       not (tsUpdating in TreeStates) then begin
      Include(FStates,tsDataSetDeleting);
      try
        DataSet:=GetDataSet;
        if Assigned(DataSet) and DataSet.Active then begin
          Node:=FocusedNode;
          if Assigned(Node) then begin
            FocusedNode:=nil;
            Data:=GetNodeData(Node);
            if Assigned(Data) then begin
              NextNode:=GetPrevious(Node);
              if not Assigned(NextNode) then
                NextNode:=GetNext(Node);
              
              DeleteNode(Node);
              SelectNode(NextNode,true);
              GoToNode(NextNode);
            end;
          end;
        end;
      finally
        Exclude(FStates,tsDataSetDeleting);
      end;
    end;
  end;
end;

procedure TBisDBTree.DataLinkDataSetAfterPost(AMode: TBisDBTreeDataLinkSetMode);
var
  DataSet: TDataSet;
  Node: PVirtualNode;
  KeyValues: TBisDBTreeValueArray;
  ParentNode: PVirtualNode;
  ParentValues: TBisDBTreeValueArray;
begin
  if not (tsDataSetPosting in FStates) and
     not (tsUpdating in TreeStates) and
     (AMode<>smDefault) then begin

    Include(FStates,tsDataSetPosting);
    try
      DataSet:=GetDataSet;
      if Assigned(DataSet) and DataSet.Active then begin
        case DataSet.State of
          dsBrowse: begin
            ParentNode:=nil;
            if not FGridEmulate then begin
              GetKeyValues(FParentFields,@ParentValues);
              ParentNode:=FindNodeByKeyValues(@ParentValues);
              if not Assigned(ParentNode) then
                ParentNode:=RootNode;
            end;
            if AMode in [smInsert,smAppend] then begin
              if AMode=smAppend then
                Node:=InsertNode(ParentNode,amAddChildLast,nil)
              else begin
                Node:=InsertNode(ParentNode,amAddChildLast,nil);
                if Assigned(FocusedNode) and (FocusedNode.Parent=ParentNode) then
                  MoveTo(Node,FocusedNode,amInsertBefore,false);
              end;
            end else begin
              GetKeyValues(FKeyFields,@KeyValues);
              Node:=FindNodeByKeyValues(@KeyValues);
            end;
            if Assigned(Node) then begin

              if Assigned(ParentNode) and (Node.Parent<>ParentNode) then
                MoveTo(Node,ParentNode,amAddChildLast,false);

              DoReadNode(Node);

              RepaintNode(Node);
            end;
          end;
        end;
      end;
    finally
      Exclude(FStates,tsDataSetPosting);
    end;

  end;
end;

end.