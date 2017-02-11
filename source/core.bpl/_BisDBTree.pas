unit BisDBTree;

interface

uses Classes, ImgList, Windows, Graphics, Controls, DBGrids, Menus, DB, Messages,
     VirtualTrees, VirtualDBTreeEx,
     BisOrders, BisFieldNames, BisValues, BisGradient;

type

  TBisDBTreeSortingEvent=procedure(Sender: TObject; FieldName: String; OrderType: TBisOrderType; var Success: Boolean) of object;
  TBisDBTreeSearchingEvent=procedure(Sender: TObject; FieldName: String; Text: String; var Success: Boolean) of object;

  TBisDBTreeNode=record
    Caption: String;
    Values: TBisValues;
    NormalIndex: Integer;
    LastIndex: Integer;
    OpenIndex: Integer;
  end;
  PBisDBTreeNode=^TBisDBTreeNode;

  TBisDBTreeColumn=class(TVirtualTreeColumn)
  private
    FFieldName: TBisFieldName;
  published
    property FieldName: TBisFieldName read FFieldName write FFieldName;

  end;

  TBisDBTree=class(TBaseVirtualDBTreeEx)
  private
    FNormalIndex: Integer;
    FLastIndex: Integer;
    FOpenIndex: Integer;
    FIndicators: TImageList;
    FNavigatorColumn: TVirtualTreeColumn;
    FNavigatorVisible: Boolean;
    FDefaultTextDrawing: Boolean;
    FOldPaintInfo: TVTPaintInfo;
    FOldDrawFormat: Cardinal;
    FSearchEnabled: Boolean;
    FSearchColor: TColor;
    FRowColor: TColor;
    FSortEnabled: Boolean;
    FOnSorting: TBisDBTreeSortingEvent;
    FNumberVisible: Boolean;
    FChessVisible: Boolean;
    FChessColor: TColor;
    FSortColumnColor: TColor;
    FSortColumnVisible: Boolean;
    FOnSearching: TBisDBTreeSearchingEvent;
    FGridEmulate: Boolean;
    FRowVisible: Boolean;
    FAutoResizeableColumns: Boolean;
    FStopAutoResizeColumns: Boolean;
    FVerticalScrollBarVisible: Boolean;
    FSaveColumnsWidth: Integer;
    FSaveEmptyWidth: Integer;
    FGradientVisible: Boolean;
    FGradientBeginColor: TColor;
    FGradientEndColor: TColor;
    FGradientStyle: TBisGradientStyle;

    procedure CreateNavigatorColumn;
    procedure DestroyNavigatorColumn;
    procedure SetNavigatorVisible(const Value: Boolean);
    procedure DefaultTextDrawing(Text: WideString; Rect: TRect);
    procedure SetSearchEnabled(const Value: Boolean);
    procedure SetNumberVisible(const Value: Boolean);
    procedure ResizeNavigatorColumn;
    procedure SetChessVisible(const Value: Boolean);
    procedure SetChessColor(const Value: TColor);
    procedure SetSortColumnColor(const Value: TColor);
    procedure SetSortColumnVisible(const Value: Boolean);
    function GetVisibleIndex(Node: PVirtualNode): Cardinal;
    function GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);
    procedure SetGridEmulate(const Value: Boolean);
    procedure SetRowVisible(const Value: Boolean);
    function GetMultiSelect: Boolean;
    procedure SetMultiSelect(const Value: Boolean);
    procedure SetAutoResizeableColumns(const Value: Boolean);
    function GetSelectedFieldName: TBisFieldName;
    procedure SetGradientVisible(const Value: Boolean);
    procedure SetGradientEndColor(const Value: TColor);
    procedure SetGradientBeginColor(const Value: TColor);
    procedure SetGradientStyle(const Value: TBisGradientStyle);
  protected
    function GetColumnClass: TVirtualTreeColumnClass; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;

    Procedure DataLinkActiveChanged; override;
    procedure DataLinkChanged; override;
    procedure DoReadNodeFromDB(Node: PVirtualNode); override;
    procedure DoFreeNode(Node: PVirtualNode); override;
    function DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
                             var Ghosted: Boolean; var Index: Integer): TCustomImageList; override;
    procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;  var Text: WideString); override;
    procedure DoAfterCellPaint(Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect); override;
    function DoFocusChanging(OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex): Boolean; override;
    procedure DoBeforeCellPaint(Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect); override;
    procedure DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex; TextType: TVSTTextType); override;
    procedure DoTextDrawing(var PaintInfo: TVTPaintInfo; Text: WideString; CellRect: TRect; DrawFormat: Cardinal); override;
    function DoIncrementalSearch(Node: PVirtualNode; const Text: WideString): Integer; override;
    procedure DoHeaderDragged(Column: TColumnIndex; OldPosition: TColumnPosition); override;
    procedure DoHeaderDraggedOut(Column: TColumnIndex; DropPosition: TPoint); override;
    procedure DoHeaderClick(Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function DoCompare(Node1, Node2: PVirtualNode; Column: TColumnIndex): Integer; Override;
    function DoGetPopupMenu(Node: PVirtualNode; Column: TColumnIndex; Position: TPoint): TPopupMenu; Override;
    procedure DoShowScrollbar(Bar: Integer; Show: Boolean); override;
    function DoPaintBackground(Canvas: TCanvas; R: TRect): Boolean; override;
    procedure DoBeforePaint(Canvas: TCanvas); override;


    procedure DoSorting(FieldName: String; OrderType: TBisOrderType; var Success: Boolean); virtual;
    procedure DoSearching(FieldName: String; Text: String; var Success: Boolean); virtual;

    function GetColumnByFieldName(FieldName: TBisFieldName): Integer;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CancelIncrementalSearch; override;
    procedure CopyFromFieldNames(FieldNames: TBisFieldNames; WithClear: Boolean=true);

    function CanFirst: Boolean;
    procedure First;
    function CanPrior: Boolean;
    procedure Prior;
    function CanNext: Boolean;
    procedure Next;
    function CanLast: Boolean;
    procedure Last;

    procedure FirstState;
    procedure ScrollIntoSelect;
    procedure ResizeColumnsByMaxWidth;
    procedure OrderByFieldName(FieldName: TBisFieldName; OrderType: TBisOrderType);
    procedure Synchronize;

    property SelectedFieldName: TBisFieldName read GetSelectedFieldName;

    property NormalIndex: Integer read FNormalIndex write FNormalIndex;
    property LastIndex: Integer read FLastIndex write FLastIndex;
    property OpenIndex: Integer read FOpenIndex write FOpenIndex;
    property NavigatorVisible: Boolean read FNavigatorVisible write SetNavigatorVisible;
    property SearchEnabled: Boolean read FSearchEnabled write SetSearchEnabled;
    property SearchColor: TColor read FSearchColor write FSearchColor;
    property SortEnabled: Boolean read FSortEnabled write FSortEnabled;
    property NumberVisible: Boolean read FNumberVisible write SetNumberVisible;
    property ChessVisible: Boolean read FChessVisible write SetChessVisible;
    property ChessColor: TColor read FChessColor write SetChessColor;
    property SortColumnColor: TColor read FSortColumnColor write SetSortColumnColor;
    property SortColumnVisible: Boolean read FSortColumnVisible write SetSortColumnVisible;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property GridEmulate: Boolean read FGridEmulate write SetGridEmulate;
    property RowVisible: Boolean read FRowVisible write SetRowVisible;
    property RowColor: TColor read FRowColor write FRowColor;
    property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
    property AutoResizeableColumns: Boolean read FAutoResizeableColumns write SetAutoResizeableColumns;

    property GradientVisible: Boolean read FGradientVisible write SetGradientVisible;
    property GradientStyle: TBisGradientStyle read FGradientStyle write SetGradientStyle;
    property GradientBeginColor: TColor read FGradientBeginColor write SetGradientBeginColor;
    property GradientEndColor: TColor read FGradientEndColor write SetGradientEndColor;

    property OnSorting: TBisDBTreeSortingEvent read FOnSorting write FOnSorting;
    property OnSearching: TBisDBTreeSearchingEvent read FOnSearching write FOnSearching;

  end;

implementation

{$R *.res} 

uses Variants, SysUtils, StrUtils, Themes, Dialogs,
     BisConsts, BisUtils;

{ TBisDBTree }

const
  bmArrow = 'BISDBTREEGARROW';
  bmEdit = 'BISDBTREEEDIT';
  bmInsert = 'BISDBTREEINSERT';
  bmMultiDot = 'BISDBTREEMULTIDOT';
  bmMultiArrow = 'BISDBTREEMULTIARROW';


constructor TBisDBTree.Create(AOwner: TComponent);
var
  Bmp: TBitmap;
begin
  inherited Create(AOwner);

  DBNodeDataSize:=SizeOf(TBisDBTreeNode);

  FNormalIndex:=-1;
  FLastIndex:=-1;
  FOpenIndex:=-1;

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

  FSearchColor:=ColorSearching;
  FRowColor:=ColorControlFocused;
  FChessColor:=ColorChess;
  FSortColumnColor:=ColorSorted;
  FGradientVisible:=false;
  FGradientStyle:=gsVertical;
  FGradientBeginColor:=clWhite;
  FGradientEndColor:=ColorSelected;

  Colors.FocusedColor:=clHighlightText;
  Colors.FocusedSelectionColor:=clHighlight;

  Header.Options:=[hoShowSortGlyphs,hoVisible,hoDblClickResize,hoAutoSpring,hoColumnResize,hoDrag];
  if ThemeServices.ThemesEnabled then
    Header.Options:=Header.Options+[hoHotTrack];

  TreeOptions.MiscOptions:=[toFullRepaintOnResize,toGridExtensions,toReportMode,toWheelPanning];
  TreeOptions.PaintOptions:=[toShowDropmark,toShowHorzGridLines,toShowTreeLines,toShowVertGridLines,toThemeAware,toShowBackground];
  TreeOptions.SelectionOptions:=[toExtendedFocus,toCenterScrollIntoView];
//  TreeOptions.SelectionOptions:=[toExtendedFocus]-[toCenterScrollIntoView];


//  DBOptions:=DBOptions-[dboTrackChanges];
  Margin:=0;
  TextMargin:=2;
  Header.Height:=DefaultNodeHeight;
//  Header.Style:=hsFlatButtons;

end;

destructor TBisDBTree.Destroy;
begin
  DestroyNavigatorColumn;
  FIndicators.Free;
  inherited Destroy;
end;

procedure TBisDBTree.CopyFromFieldNames(FieldNames: TBisFieldNames; WithClear: Boolean);
var
  Column: TBisDBTreeColumn;
  i: Integer;
  Item: TBisFieldName;
  FlagKey: Boolean;
  FlagParent: Boolean;
  FlagView: Boolean;
  OldNavigatorVisible: Boolean;
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
      FlagView:=false;
      for i:=0 to FieldNames.Count-1 do begin
        Item:=FieldNames.Items[i];

        if Item.IsKey and FlagKeyEmpty then begin
          if not FlagKey then begin
            KeyFieldNames:=Item.FieldName;
            FlagKey:=true;
          end else
            KeyFieldNames:=KeyFieldNames+';'+Item.FieldName;
        end;

        if Item.IsParent and FlagParentEmpty then begin
          if not FlagParent then begin
            ParentFieldNames:=Item.FieldName;
            FlagParent:=true;
          end else
            ParentFieldNames:=ParentFieldNames+';'+Item.FieldName;
        end;

        if ((Item.Caption)<>'') then begin
          Column:=TBisDBTreeColumn(Header.Columns.Add);
          Column.Text:=Item.Caption;
          Column.FieldName:=Item;
          if Item.Visible then
            Column.Options:=Column.Options+[coVisible]
          else Column.Options:=Column.Options-[coVisible];

//          Column.Options:=Column.Options+[coFixed];

          case Item.Alignment of
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

          if not FlagView and Item.Visible and (Trim(ViewFieldName)='') then begin
            ViewFieldName:=Item.FieldName;
            FlagView:=true;
          end;

        end;
      end;

      if FGridEmulate then
        ParentFieldNames:='';
        
    end;
  finally
    AutoResizeableColumns:=OldAutoResizeable;
    NavigatorVisible:=OldNavigatorVisible;
  end;
end;


procedure TBisDBTree.CreateNavigatorColumn;
begin
  if not Assigned(FNavigatorColumn) then begin
    FNavigatorColumn:=TVirtualTreeColumn(Header.Columns.Insert(0));
    FNavigatorColumn.Options:=FNavigatorColumn.Options-[coAllowClick,coDraggable,coEnabled,coResizable,
                                                        coParentColor,coShowDropMark,coAutoSpring]+[coFixed];
    FNavigatorColumn.Alignment:=taRightJustify;
    FNavigatorColumn.Position:=0;
    ResizeNavigatorColumn;
  end;
end;

procedure TBisDBTree.DestroyNavigatorColumn;
begin
  if Assigned(FNavigatorColumn) then begin
    Header.Columns.Delete(FNavigatorColumn.Index);
    FNavigatorColumn:=nil;
  end;
end;

function TBisDBTree.GetColumnClass: TVirtualTreeColumnClass;
begin
  Result:=TBisDBTreeColumn;
end;

procedure TBisDBTree.CancelIncrementalSearch;
begin
  inherited CancelIncrementalSearch;
  InvalidateNode(FocusedNode);
end;

procedure TBisDBTree.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if FSearchEnabled and (Key=VK_ESCAPE) then begin
    CancelIncrementalSearch;
  end;
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
      W:=W+Canvas.TextWidth(DupeString('9',L))+L+1;
    end;
    FNavigatorColumn.MaxWidth:=W;
    FNavigatorColumn.MinWidth:=W;
    FNavigatorColumn.Width:=W;
  end;
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

procedure TBisDBTree.SetGradientBeginColor(const Value: TColor);
begin
  FGradientBeginColor := Value;
  Invalidate;
end;

procedure TBisDBTree.SetGradientVisible(const Value: Boolean);
begin
  FGradientVisible := Value;
  Invalidate;
end;

procedure TBisDBTree.SetGridEmulate(const Value: Boolean);
begin
  FGridEmulate := Value;
  if FGridEmulate then begin
    DBOptions:=DBOptions+[dboListView]-[dboAlwaysStructured];
    TreeOptions.PaintOptions:=TreeOptions.PaintOptions-[toShowButtons,toShowRoot];
  end else begin
    DBOptions:=DBOptions-[dboListView]+[dboAlwaysStructured];
    TreeOptions.PaintOptions:=TreeOptions.PaintOptions+[toShowButtons,toShowRoot];
  end;
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

function TBisDBTree.GetReadOnly: Boolean;
begin
  Result:=dboReadOnly in DBOptions;
end;

procedure TBisDBTree.SetReadOnly(const Value: Boolean);
begin
  DBOptions:=DBOptions+[dboReadOnly];
end;

procedure TBisDBTree.SetAutoResizeableColumns(const Value: Boolean);
begin
  FAutoResizeableColumns := Value;
  Resize;
end;

procedure TBisDBTree.SetRowVisible(const Value: Boolean);
begin
  FRowVisible := Value;
  Invalidate;
end;

procedure TBisDBTree.SetSearchEnabled(const Value: Boolean);
begin
  FSearchEnabled := Value;
  if FSearchEnabled then begin
    IncrementalSearch:=isAll;
  end else begin
    IncrementalSearch:=isNone;
  end;
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
var
  Hash: String;
  Node: PVirtualNode;
  Data: PDBVTData;
begin
  Hash:=KeyFields.AsHash;
  Node:=FindChild(Nil,Hash);
  If Assigned(Node) Then begin
    Data:=GetNodeData(Node);
    if Assigned(Data) then begin
      Data.Status:=dbnsEdit;
      ReadNodeFromDB(Node);
    end;
  End;
end;

procedure TBisDBTree.DoReadNodeFromDB(Node: PVirtualNode);
var
  Data: PBisDBTreeNode;
  i: Integer;
  AColumn: TBisDBTreeColumn;
  StartI: Integer;
  S: String;
  DS: TDataSet;
  Field: TField;
begin
  Data:=GetDBNodeData(Node);
  if Assigned(DataSource) and Assigned(Data) then begin
    DS:=DataSource.DataSet;
    if Assigned(DS) and DS.Active and not DS.IsEmpty then begin
      Field:=DS.FieldByName(ViewFieldName);
      if Assigned(Field) then begin
        Data.Caption:=Field.AsString;
        Data.NormalIndex:=FNormalIndex;
        Data.LastIndex:=FLastIndex;
        Data.OpenIndex:=FOpenIndex;
        if Header.Columns.Count>0 then begin
          StartI:=0;
          if Assigned(FNavigatorColumn) then
            StartI:=1;
          Data.Values:=TBisValues.Create;
          for i:=StartI to Header.Columns.Count-1 do begin
            AColumn:=TBisDBTreeColumn(Header.Columns.Items[i]);
            if Assigned(AColumn) and Assigned(AColumn.FieldName) then begin
              S:=AColumn.FieldName.FieldName;
              Data.Values.Add(S,DataSource.DataSet.FieldByName(S).Value);
            end;
          end;
        end;
      end;
    end;
  end;
  inherited DoReadNodeFromDB(Node);
end;

procedure TBisDBTree.DoFreeNode(Node: PVirtualNode);
var
  Data: PBisDBTreeNode;
begin
  Data:=GetDBNodeData(Node);
  if Assigned(Data) then begin
    FreeAndNilEx(Data.Values);
  end;
  inherited DoFreeNode(Node);
end;

function TBisDBTree.DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind;  Column: TColumnIndex;
                                    var Ghosted: Boolean;  var Index: Integer): TCustomImageList;
var
  Data: PBisDBTreeNode;
begin
  Data:=GetDBNodeData(Node);
  if Assigned(Data) then begin
    if Column=Header.MainColumn then begin
      case Kind of
        ikNormal,ikSelected: begin
           if Node.ChildCount=0 then begin
             Index:=Data.LastIndex;
           end else begin
             if vsExpanded in Node.States then
               Index:=Data.OpenIndex
             else
               Index:=Data.NormalIndex;
           end;
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

procedure TBisDBTree.DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString);
var
  AColumn: TBisDBTreeColumn;
  Data: PBisDBTreeNode;
  Index: Integer;
  S: String;
  Item: TBisValue;
begin
  AColumn:=TBisDBTreeColumn(Header.Columns[Column]);
  Data:=GetDBNodeData(Node);
  if Assigned(AColumn) and Assigned(Data) then begin
    Index:=Column;
    if Assigned(FNavigatorColumn) then begin
      if Index=0 then
        Text:=''
      else begin
        Index:=Index-1;
      end;
    end;

    if (Header.Columns.Count>0) and (Index>-1) then begin
      if Assigned(AColumn.FieldName) and Assigned(Data.Values) then begin
        Item:=Data.Values.Find(AColumn.FieldName.FieldName);
        if Assigned(Item) then
          Text:=VarToStrDef(Item.Value,'');
      end;
    end else
      Text:=Data.Caption;

    if Assigned(AColumn.FieldName) and (Trim(Text)<>'') then begin
      S:=AColumn.FieldName.DisplayFormat;
      if Trim(S)<>'' then begin
        case AColumn.FieldName.DataType of
          ftSmallint,ftInteger,ftWord,ftFloat,ftCurrency,ftLargeint,ftFMTBcd,ftBCD: Text:=FormatFloat(S,StrToFloatDef(Text,0.0));
          ftDate,ftTime,ftDateTime,ftTimeStamp: Text:=FormatDateTime(S,StrToDateTimeDef(Text,NullDate));
        end;
      end;
    end;

  end else
    inherited DoGetText(Node,Column,TextType,Text);
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

function TBisDBTree.DoPaintBackground(Canvas: TCanvas; R: TRect): Boolean;
begin
  if FGradientVisible then begin
    Canvas.Brush.Style:=bsSolid;
//    Canvas.Brush.Color:=clRed;
//    Canvas.FillRect(GetClientRect);

    DrawGradient(Canvas,GetClientRect,FGradientStyle,FGradientBeginColor,FGradientEndColor);
    Result:=true;
  end else
    Result:=inherited DoPaintBackground(Canvas,R);
end;

procedure TBisDBTree.DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex; TextType: TVSTTextType);
begin
  inherited DoPaintText(Node,Canvas,Column,TextType);
end;

procedure TBisDBTree.DoTextDrawing(var PaintInfo: TVTPaintInfo; Text: WideString; CellRect: TRect; DrawFormat: Cardinal);
begin
  inherited DoTextDrawing(PaintInfo,Text,CellRect,DrawFormat);
  if not FDefaultTextDrawing then begin
    FOldPaintInfo:=PaintInfo;
    FOldDrawFormat:=DrawFormat;
  end;
end;

procedure TBisDBTree.ResizeColumnsByMaxWidth;
var
  Column: TBisDBTreeColumn;
  i: Integer;
begin
  for i:=0 to Header.Columns.Count-1 do begin
    Column:=TBisDBTreeColumn(Header.Columns[i]);
    if Assigned(Column) and Assigned(Column.FieldName) then begin
      Column.Width:=GetMaxColumnWidth(Column.Position);
    end;
  end;
end;

procedure TBisDBTree.DataLinkActiveChanged;
var
  Column: TBisDBTreeColumn;
  i: Integer;
  Field: TField;
  FieldName: TBisFieldName;
begin
  inherited DataLinkActiveChanged;
  if Assigned(DataSource) and Assigned(DataSource.DataSet) and DataSource.DataSet.Active then begin
    for i:=0 to Header.Columns.Count-1 do begin
      Column:=TBisDBTreeColumn(Header.Columns[i]);
      FieldName:=Column.FieldName;
      if Assigned(Column) and Assigned(FieldName) then begin
        Field:=DataSource.DataSet.FindField(FieldName.FieldName);
        if Assigned(Field) then begin
          if FieldName.Alignment=daDefault then begin
            Column.Alignment:=Field.Alignment;
          end;
          if FieldName.Width=0 then begin
            Header.Columns.AnimatedResize(Column.Position,GetMaxColumnWidth(Column.Position));
          end;
        end;
      end;
    end;
    if Assigned(FNavigatorColumn) then
      FocusedColumn:=1
    else FocusedColumn:=0;
  end;
end;

procedure TBisDBTree.DataLinkChanged;
begin
  inherited DataLinkChanged;
  ResizeNavigatorColumn;
end;

procedure TBisDBTree.DefaultTextDrawing(Text: WideString; Rect: TRect);
begin
  FDefaultTextDrawing:=true;
  try
    if Assigned(FOldPaintInfo.Canvas) then
      DoTextDrawing(FOldPaintInfo,Text,Rect,FOldDrawFormat);
  finally
    FDefaultTextDrawing:=false;
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

procedure TBisDBTree.DoBeforePaint(Canvas: TCanvas);
begin
  inherited DoBeforePaint(Canvas);
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
          if dbtsEditing in DBStatus then
            Index:=1;
          if dbtsInsert in DBStatus then
            Index:=2;
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
          Rect.Right:=L;
          DefaultTextDrawing(S,Rect);
        end;
      end;
    end;
  end;

  if Assigned(Node) and (Node=FocusedNode) then begin
    if (Column=FocusedColumn) then begin
      if FSearchEnabled and (Length(SearchBuffer)>0) then begin
        AColumn:=TBisDBTreeColumn(Header.Columns[Column]);
        if Assigned(AColumn) and Assigned(AColumn.FieldName) then begin
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
    AColumn:=TBisDBTreeColumn(Header.Columns[Column]);
    if Assigned(AColumn) and Assigned(AColumn.FieldName) then begin
      case AColumn.FieldName.VisualType of
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
                if AColumn.FieldName.VisualType=vtCheckBox then
                  DrawFrameControl(Canvas.Handle,Rect,DFC_BUTTON,DFCS_CHECKED)
                else DrawFrameControl(Canvas.Handle,Rect,DFC_BUTTON,DFCS_BUTTONRADIO or DFCS_CHECKED);
              end else begin
                if AColumn.FieldName.VisualType=vtCheckBox then begin
                  Details:=ThemeServices.GetElementDetails(tbCheckBoxCheckedNormal);
                  ThemeServices.DrawElement(Canvas.Handle, Details, Rect);
                end else begin
                  Details:=ThemeServices.GetElementDetails(tbRadioButtonCheckedNormal);
                  ThemeServices.DrawElement(Canvas.Handle, Details, Rect);
                end;
              end;
            end else begin
              if not ThemeServices.ThemesEnabled then begin
                if AColumn.FieldName.VisualType=vtCheckBox then
                  DrawFrameControl(Canvas.Handle,Rect,DFC_BUTTON,DFCS_BUTTONCHECK)
                else DrawFrameControl(Canvas.Handle,Rect,DFC_BUTTON,DFCS_BUTTONRADIO);
              end else begin
                if AColumn.FieldName.VisualType=vtCheckBox then begin
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

function TBisDBTree.DoFocusChanging(OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex): Boolean;
begin
  Result:=inherited DoFocusChanging(OldNode,NewNode,OldColumn,NewColumn);
  if Assigned(FNavigatorColumn) and (OldColumn<>NewColumn) then begin
    Result:=Result and (NewColumn>0);
  end;
end;

function TBisDBTree.DoCompare(Node1, Node2: PVirtualNode; Column: TColumnIndex): Integer;
var
  FieldName: TBisFieldName;

  procedure CompareByNumber;
  var
    ND1, ND2: PBisDBTreeNode;
    V1, V2: Variant;
    E1, E2: Extended;
  begin
    ND1:=GetDBNodeData(Node1);
    ND2:=GetDBNodeData(Node2);
    if Assigned(ND1) and Assigned(ND2) then begin
      V1:=ND1.Values.GetValue(FieldName.FieldName);
      V2:=ND2.Values.GetValue(FieldName.FieldName);
      E1:=VarToExtendedDef(V1,0.0);
      E2:=VarToExtendedDef(V2,0.0);
      if E1>E2 then
        Result:=1
      else Result:=-1;
    end;
  end;

  procedure CompareByDateTime;
  var
    ND1, ND2: PBisDBTreeNode;
    V1, V2: Variant;
    D1, D2: TDateTime;
  begin
    ND1:=GetDBNodeData(Node1);
    ND2:=GetDBNodeData(Node2);
    if Assigned(ND1) and Assigned(ND2) then begin
      V1:=ND1.Values.GetValue(FieldName.FieldName);
      V2:=ND2.Values.GetValue(FieldName.FieldName);
      D1:=VarToDateDef(V1,0.0);
      D2:=VarToDateDef(V2,0.0);
      if D1>D2 then
        Result:=1
      else Result:=-1;
    end;
  end;

  procedure CompareByString;
  var
    ND1, ND2: PBisDBTreeNode;
    V1, V2: Variant;
    S1, S2: String;
  begin
    ND1:=GetDBNodeData(Node1);
    ND2:=GetDBNodeData(Node2);
    if Assigned(ND1) and Assigned(ND2) then begin
      V1:=ND1.Values.GetValue(FieldName.FieldName);
      V2:=ND2.Values.GetValue(FieldName.FieldName);
      S1:=VarToStrDef(V1,'');
      S2:=VarToStrDef(V2,'');
      if S1>S2 then
        Result:=1
      else Result:=-1;
    end;
  end;

var
  AColumn: TBisDBTreeColumn;
begin
  Result:=0;
  if (Header.SortColumn<>NoColumn) and Assigned(Node1) and Assigned(Node2) and
     (Column=Header.SortColumn) then begin
    AColumn:=TBisDBTreeColumn(Header.Columns[Column]);
    if Assigned(AColumn) then begin
      FieldName:=AColumn.FieldName;
      if Assigned(FieldName) then begin
        case FieldName.DataType of
          ftSmallint,ftInteger,ftWord,ftFloat,ftCurrency,ftLargeint: CompareByNumber;
          ftDate,ftTime,ftDateTime,ftTimeStamp: CompareByDateTime;
        else
          CompareByString;
        end;
      end;
    end;
  end else
    Result:=inherited DoCompare(Node1,Node2,Column);
end;

procedure TBisDBTree.DoSearching(FieldName, Text: String; var Success: Boolean);
begin
  if Assigned(FOnSearching) then
    FOnSearching(Self,FieldName,Text,Success);
end;

procedure TBisDBTree.DoShowScrollbar(Bar: Integer; Show: Boolean);
begin
  inherited DoShowScrollbar(Bar,Show);
  if Bar=SB_VERT then begin
    if FVerticalScrollBarVisible<>Show then begin
      FVerticalScrollBarVisible:=Show;
//      Perform(WM_WINDOWPOSCHANGED, 0, 0);
    end;
  end;
end;

function TBisDBTree.DoIncrementalSearch(Node: PVirtualNode; const Text: WideString): Integer;
var
{  Column: TBisDBTreeColumn;
  Success: Boolean;}
  S: String;
  APos: Integer;
begin
  Result:=1;
  if FocusedColumn<>NoColumn then begin
{    Column:=TBisDBTreeColumn(Header.Columns[FocusedColumn]);
    Success:=false;
    DoSearching(Column.FieldName,Text,Success);
    if Success then
      Result:=0;}
    if Assigned(Node) then begin
      S:=Self.Text[Node,FocusedColumn];
      APos:=AnsiPos(AnsiUpperCase(Text),AnsiUpperCase(S));
      if APos=1 then
        Result:=0;

    end;
  end;
end;

procedure TBisDBTree.DoSorting(FieldName: String; OrderType: TBisOrderType;  var Success: Boolean);
begin
  if Assigned(FOnSorting) then begin
    FOnSorting(Self,FieldName,OrderType,Success);
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
      AColumn:=TBisDBTreeColumn(Header.Columns[Column]);
      if Assigned(AColumn) and Assigned(AColumn.FieldName) then begin
        DoSorting(AColumn.FieldName.FieldName,OrderType,Success);
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
 { if Header.MainColumn<>-1 then begin
    if Header.MainColumn=Column then begin
      if Assigned(FNavigatorColumn) then
        Header.Columns[Column].Position:=FNavigatorColumn.Position+1
      else
        Header.Columns[Column].Position:=0;
    end else begin
      if Header.Columns[Header.MainColumn].Position>Header.Columns[Column].Position then
        Header.Columns[Column].Position:=OldPosition;
    end;
  end; }
  inherited DoHeaderDragged(Column,OldPosition);
end;

procedure TBisDBTree.DoHeaderDraggedOut(Column: TColumnIndex; DropPosition: TPoint);
begin
  inherited DoHeaderDraggedOut(Column,DropPosition);
end;

function TBisDBTree.CanFirst: Boolean;
var
  Node: PVirtualNode;
begin
  Node:=GetFirst;
  Result:=Assigned(FocusedNode) and Assigned(Node) and
          (Node<>FocusedNode);
//  Result:=Assigned(Node) and (Node<>FocusedNode);
end;

procedure TBisDBTree.First;
begin
  if CanFirst then begin
    FocusedNode:=GetFirst;
    if Assigned(FocusedNode) then begin
      ClearSelection;
      Selected[FocusedNode]:=True;
      ScrollIntoView(FocusedNode,true);
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
     // ScrollIntoView(FocusedNode,true);
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
     // ScrollIntoView(FocusedNode,true);
    end;
  end;
end;

function TBisDBTree.CanLast: Boolean;
var
  Node: PVirtualNode;
begin
  Node:=GetLast;
  Result:=Assigned(FocusedNode) and Assigned(Node) and 
          (Node<>FocusedNode);
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

procedure TBisDBTree.FirstState;
begin
  CollapseAll;
  if Assigned(RootNode) then
    if RootNode.ChildCount=1 then
      Expanded[RootNode]:=true;

  Header.SortColumn:=NoColumn;
  SortTree(NoColumn,Header.SortDirection);

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

procedure TBisDBTree.ScrollIntoSelect;
begin
  if Assigned(FocusedNode) then
    ScrollIntoView(FocusedNode,true);
end;

function TBisDBTree.GetColumnByFieldName(FieldName: TBisFieldName): Integer;
var
  i: Integer;
  Column: TBisDBTreeColumn;
begin
  Result:=-1;
  for i:=0 to Header.Columns.Count-1 do begin
    Column:=TBisDBTreeColumn(Header.Columns[i]);
    if Assigned(Column) and (Column.FieldName=FieldName) then begin
      Result:=i;
      break;
    end;
  end;
end;

procedure TBisDBTree.OrderByFieldName(FieldName: TBisFieldName;  OrderType: TBisOrderType);
var
  Column: Integer;
begin
  if Assigned(FieldName) then begin
    Column:=GetColumnByFieldName(FieldName);
    if Column>-1 then begin
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
      if Assigned(FocusedNode) then begin
        ClearSelection;
        Selected[FocusedNode]:=True;
        ScrollIntoView(FocusedNode,true);
      end;
    end;
  end;
end;

function TBisDBTree.GetSelectedFieldName: TBisFieldName;
var
  Column: TBisDBTreeColumn;
begin
  Result:=nil;
  if FocusedColumn<>-1 then begin
    Column:=TBisDBTreeColumn(Header.Columns[FocusedColumn]);
    if Assigned(Column) then
      Result:=Column.FieldName;
  end;
end;

end.
