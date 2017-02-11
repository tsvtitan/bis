unit BisDataGridFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, DBActns, ActnList, DB,
  ComCtrls, ToolWin, ExtCtrls, Grids, DBGrids, StdCtrls,
  VirtualTrees, {VirtualDBTreeEx,}
  BisDataFrm, BisDBTree, BisOrders, BisDataSet, BisProvider, BisFieldNames;

type
  TBisDataGridFrame = class(TBisDataFrame)
    GridPattern: TDBGrid;
    procedure GridPatternDblClick(Sender: TObject);
  private
    FOldColumn: Integer;
    FGrid: TBisDBTree;
    FInterrupted: Boolean;
    FLastActiveControl: TWinControl;
    procedure GridProgress(Sender: TBisDBTree; const Min,Max,Position: Integer; var Interrupted: Boolean);
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
  protected
    procedure Update; override;
    procedure DoSynchronize; override;
    procedure DoBeforeOpenRecords; override;
    procedure DoAfterOpenRecords; override;
    function GetCurrentProvider: TBisProvider; override;
    function GetCurrentControl: TWinControl; override;
    function GetMultiSelect: Boolean; override;
    procedure SetMultiSelect(const Value: Boolean); override;
    function GetSelectedFieldName: TBisFieldName; override;
    function GetReportPattern: TComponent; override;
    function GetCountString: String; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure EnableControls(AEnabled: Boolean); override;
    procedure OpenRecords; override;
    function CanFirstRecord: Boolean; override;
    procedure FirstRecord; override;
    function CanPriorRecord: Boolean; override;
    procedure PriorRecord; override;
    function CanNextRecord: Boolean; override;
    procedure NextRecord; override;
    function CanLastRecord: Boolean; override;
    procedure LastRecord; override;
    function LocateRecord(Fields: String; Values: Variant): Boolean; override;
    function CanInfoRecord: Boolean; override;
    function SelectInto(DataSet: TBisDataSet): Boolean; override;
    function CanClose: Boolean; override;
  published
    property Grid: TBisDBTree read FGrid;
  end;

var
  BisDataGridFrame: TBisDataGridFrame;

implementation

uses BisUtils;

{$R *.dfm}

{ TBisDataGridFrame }

constructor TBisDataGridFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FGrid:=TBisDBTree.Create(Self);
  FGrid.Parent:=GridPattern.Parent;
  FGrid.SetBounds(GridPattern.Left,GridPattern.Top,GridPattern.Width,GridPattern.Height);
  FGrid.Align:=GridPattern.Align;
  FGrid.ReadOnly:=GridPattern.ReadOnly;
  FGrid.PopupMenu:=GridPattern.PopupMenu;
  FGrid.DataSource:=DataSource;
  FGrid.Images:=ImageList;
  FGrid.SortEnabled:=true;
  FGrid.NavigatorVisible:=true;
  FGrid.SearchEnabled:=true;
  FGrid.SortColumnVisible:=true;
  FGrid.ChessVisible:=false;
  FGrid.GridEmulate:=true;
  FGrid.RowVisible:=true;
  FGrid.GradientVisible:=true;
  FGrid.AutoResizeableColumns:=false;
  FGrid.TabOrder:=GridPattern.TabOrder;
  FGrid.OnDblClick:=GridPattern.OnDblClick;
  FGrid.OnKeyDown:=GridPattern.OnKeyDown;
  FGrid.OnProgress:=GridProgress;

  GridPattern.DataSource:=nil;
  GridPattern.Parent:=nil;
end;

destructor TBisDataGridFrame.Destroy;
begin
  FInterrupted:=true;
  FGrid.DataSource:=nil;
  FreeAndNilEx(FGrid);
  inherited Destroy;
end;

procedure TBisDataGridFrame.DoSynchronize;
begin
  inherited DoSynchronize;
  FGrid.Synchronize;
end;

procedure TBisDataGridFrame.GridProgress(Sender: TBisDBTree; const Min, Max, Position: Integer;
                                         var Interrupted: Boolean);
begin
  if Position=Min then
    FInterrupted:=false;
  Interrupted:=FInterrupted;
  Progress(Min,Max,Position,Interrupted);
end;

procedure TBisDataGridFrame.EnableControls(AEnabled: Boolean);
begin
  inherited EnableControls(AEnabled);
  FGrid.Enabled:=AEnabled;
end;

function TBisDataGridFrame.GetCurrentProvider: TBisProvider;
begin
  Result:=inherited GetCurrentProvider;
end;

function TBisDataGridFrame.GetCountString: String;
begin
  Result:=inherited GetCountString;
  if Assigned(FGrid) then
    Result:=IntToStr(FGrid.TotalCount);
end;

function TBisDataGridFrame.GetCurrentControl: TWinControl;
begin
  Result:=FGrid;
end;

procedure TBisDataGridFrame.GridPatternDblClick(Sender: TObject);
begin
  if ActionUpdate.Visible and ActionUpdate.Enabled then begin
    ActionUpdate.Execute;
  end else
    if ActionView.Visible and  ActionView.Enabled then
      ActionView.Execute;
end;

procedure TBisDataGridFrame.Init;
begin
  inherited Init;
  FGrid.CopyFromFieldNames(Provider.FieldNames);
end;

procedure TBisDataGridFrame.DoBeforeOpenRecords;
begin
  inherited DoBeforeOpenRecords;
  FLastActiveControl:=ActiveControl;
  FGrid.Enabled:=false;
  FOldColumn:=FGrid.FocusedColumn;
  FGrid.BeginUpdate;
end;

procedure TBisDataGridFrame.DoAfterOpenRecords;
begin
  try
    FGrid.RefreshNodes;
    FGrid.EndUpdate;
    FGrid.First;
    if FOldColumn>-1 then
      FGrid.FocusedColumn:=FOldColumn;
    FGrid.Enabled:=true;
    inherited DoAfterOpenRecords;
  finally
    ActiveControl:=FLastActiveControl;
    if not Assigned(ActiveControl) then
      ActiveControl:=FGrid;
  end;
end;

procedure TBisDataGridFrame.OpenRecords;
begin
  inherited OpenRecords;
end;

function TBisDataGridFrame.CanClose: Boolean;
begin
  Result:=inherited CanClose and
          not (tsBuilding in FGrid.States);
end;

function TBisDataGridFrame.CanFirstRecord: Boolean;
begin
  Result:=FGrid.CanFirst;
end;

procedure TBisDataGridFrame.FirstRecord;
begin
  if Assigned(FGrid) then
    FGrid.First;
end;

function TBisDataGridFrame.CanInfoRecord: Boolean;
begin
  Result:=inherited CanInfoRecord and FGrid.Focused;
end;

function TBisDataGridFrame.CanLastRecord: Boolean;
begin
  Result:=FGrid.CanLast;
end;

procedure TBisDataGridFrame.LastRecord;
begin
  FGrid.Last;
end;

function TBisDataGridFrame.CanNextRecord: Boolean;
begin
  Result:=FGrid.CanNext;
end;

procedure TBisDataGridFrame.NextRecord;
begin
  FGrid.Next;
end;

function TBisDataGridFrame.CanPriorRecord: Boolean;
begin
  Result:=FGrid.CanPrior;
end;

procedure TBisDataGridFrame.CMDialogKey(var Message: TCMDialogKey);
begin
  if Message.CharCode=VK_ESCAPE then begin
    FInterrupted:=true;
    Application.ProcessMessages;
  end;
end;

procedure TBisDataGridFrame.PriorRecord;
begin
  FGrid.Prior;
end;

function TBisDataGridFrame.GetMultiSelect: Boolean;
begin
  Result:=FGrid.MultiSelect;
end;

function TBisDataGridFrame.GetReportPattern: TComponent;
begin
  Result:=FGrid;
end;

function TBisDataGridFrame.GetSelectedFieldName: TBisFieldName;
var
  P: TBisProvider;
begin
  Result:=nil;
  if Assigned(FGrid) then begin
    P:=GetCurrentProvider;
    if Assigned(P) then
      Result:=P.FieldNames.Find(FGrid.SelectedFieldName);
  end;
end;

procedure TBisDataGridFrame.SetMultiSelect(const Value: Boolean);
begin
  FGrid.MultiSelect:=Value;
end;

procedure TBisDataGridFrame.Update;
begin
  inherited Update;
  FGrid.Update;
end;

function TBisDataGridFrame.LocateRecord(Fields: String; Values: Variant): Boolean;
begin
  Result:=inherited LocateRecord(Fields,Values);
  if Result then begin
    FGrid.ScrollIntoSelect;
  end;
end;

function TBisDataGridFrame.SelectInto(DataSet: TBisDataSet): Boolean;
var
  Node: PVirtualNode;
  Data: PBisDBTreeNodeData;
  Fields: String;
  Values: Variant;
begin
  if not FGrid.MultiSelect then
    Result:=inherited SelectInto(DataSet)
  else begin
    if Assigned(DataSet) and Provider.Active then begin
      DataSet.CreateTable(Provider);
      Provider.GetKeyFieldsValues(Fields,Values);

      if FGrid.SelectedCount>0 then begin
        Provider.BeginUpdate(true);
        try
          Node:=FGrid.GetFirstSelected;
          while Assigned(Node) do begin

            Data:=FGrid.GetNodeData(Node);
            if Assigned(Data) then begin
              if Provider.Locate(Fields,Data.KeyValues,[loCaseInsensitive]) then begin
                DataSet.CopyRecord(Provider);
              end;
            end;

            Node:=FGrid.GetNextSelected(Node);
          end;
        finally
          Provider.First;
          Provider.EndUpdate;
        end;
      end;

      Result:=DataSet.Active and not DataSet.Empty;
    end else
      Result:=inherited SelectInto(DataSet);
  end;
end;

end.
