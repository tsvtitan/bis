unit BisTaxiDataDriverWeekScheduleFrm;

interface
                                          
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids,
  VirtualTrees, 
  BisDataFrm, BisDbTree, BisDataSet, BisDataGridFrm;                                                                

type
  TBisTaxiDataDriverWeekScheduleFrame = class(TBisDataGridFrame)
    PanelBottom: TPanel;
    LabelSum: TLabel;
    ActionClear: TAction;
    N1: TMenuItem;
    MenuItemClear: TMenuItem;
    ActionClearAll: TAction;
    MenuItemClearAll: TMenuItem;
    procedure ActionClearUpdate(Sender: TObject);
    procedure ActionClearExecute(Sender: TObject);
    procedure ActionClearAllUpdate(Sender: TObject);
    procedure ActionClearAllExecute(Sender: TObject);
  private
    FDriverId: Variant;
    FCanChange: Boolean;
    FSum: Integer;
    FDSchedule: TDateTime;
    FDateSchedule: Variant;
    FDateBegin: TDateTime;
    FDateEnd: TDateTime;
    FWeekSchedules: TBisDataSetCollectionItem;
    FDriverSchedules: TBisDataSetCollectionItem;
    function GetFieldCount(H: Integer): String;
    function GetFieldExists(H: Integer): String;
    procedure FillEmptyDataSet;
    procedure ApplyFor;
    procedure SetSum;
    procedure GridDblClick(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
                                  Column: TColumnIndex; CellRect: TRect);
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    function ClearSchedule(WeekDay: Variant): Boolean;                            
    function CanClear: Boolean;
    procedure Clear;
    procedure ClearAll;
    function CheckDateSchedule(DayDate: Variant): Boolean;
  protected
    procedure DoAfterOpenRecords; override;
    procedure DoBeforeOpenRecords; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OpenRecords; override;

    property DriverId: Variant read FDriverId write FDriverId;
    property DateSchedule: Variant read FDateSchedule write FDateSchedule;

    property CanChange: Boolean read FCanChange write FCanChange;

  end;

implementation

uses DateUtils,
     BisCore, BisConsts, BisUtils, BisProvider, BisFilterGroups, BisFieldNames;

{$R *.dfm}

{ TBisTaxiDataDriverWeekScheduleFrame }

constructor TBisTaxiDataDriverWeekScheduleFrame.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  with Provider.FieldDefs do begin
    Add('WEEK_DAY',ftInteger);
    Add('DAY_NAME',ftString,100);
    Add('DAY_DATE',ftDateTime);
    for i:=0 to 24-1 do begin
      Add(GetFieldCount(i),ftInteger);
      Add(GetFieldExists(i),ftInteger);
    end;
  end;

  with Provider.FieldNames do begin
    Add('DAY_NAME','����',70).Alignment:=daCenter;
    for i:=0 to 24-1 do begin
      Add(GetFieldCount(i),IntToStr(i),25).Alignment:=daCenter;
      Add(GetFieldExists(i),IntToStr(i),30).Visible:=false;
    end;
    Add('WEEK_DAY','���� ������',40).Visible:=false;
    with Add('DAY_DATE','���� ���',40) do begin
      IsKey:=true;
      Visible:=false;
    end;
  end;
  Provider.CreateTable();

  Grid.SortEnabled:=false;
  Grid.ChessVisible:=false;
  Grid.OnDblClick:=GridDblClick;
  Grid.OnBeforeCellPaint:=GridBeforeCellPaint;
  Grid.OnPaintText:=GridPaintText;
  Grid.OnKeyDown:=GridKeyDown;

  FWeekSchedules:=nil;
  FDriverSchedules:=nil;

  FDriverId:=Null;
  FDateSchedule:=Null;
end;

function TBisTaxiDataDriverWeekScheduleFrame.GetFieldCount(H: Integer): String;
begin
  Result:=Format('HOUR_COUNT_%d',[H]);
end;

function TBisTaxiDataDriverWeekScheduleFrame.GetFieldExists(H: Integer): String;
begin
  Result:=Format('HOUR_EXISTS_%d',[H]);
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
                                                                  Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
var
  Exists: Boolean;
  Count: Integer;
  WeekDay: Integer;
  S: String;
  H: Integer;
  AColumn: TBisDBTreeColumn;
begin
  if Column=1 then begin
    WeekDay:=VarToIntDef(Grid.GetNodeValue(Node,'WEEK_DAY'),0);
    TargetCanvas.Brush.Style:=bsSolid;
    TargetCanvas.Brush.Color:=iff(WeekDay>=5,clWebLightCoral,clSkyBlue);
    TargetCanvas.FillRect(CellRect);
  end else begin
    AColumn:=Grid.Header.Columns[Column];
    if Assigned(AColumn) then begin
      S:=Copy(AColumn.FieldName,Length('HOUR_COUNT_')+1,MaxInt);
      if TryStrToInt(S,H) then begin
        S:=GetFieldExists(H);
        Exists:=Boolean(VarToIntDef(Grid.GetNodeValue(Node,S),0));
        if Exists then begin
          TargetCanvas.Brush.Style:=bsSolid;
          if CheckDateSchedule(Grid.GetNodeValue(Node,'DAY_DATE')) then
            TargetCanvas.Brush.Color:=clLime
          else TargetCanvas.Brush.Color:=clSilver;
          TargetCanvas.FillRect(CellRect);
        end else begin
          S:=GetFieldCount(H);
          Count:=VarToIntDef(Grid.GetNodeValue(Node,S),0);
          if Count>0 then begin
            TargetCanvas.Brush.Style:=bsSolid;
            TargetCanvas.Brush.Color:=clMoneyGreen;
            TargetCanvas.FillRect(CellRect);
          end;
        end;
      end;
    end;
  end;
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                                                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  if Column=1 then begin
    TargetCanvas.Font.Style:=[];
  end;
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.GridDblClick(Sender: TObject);
begin
  ApplyFor;
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=VK_SPACE then begin
    ApplyFor;
  end;
end;


procedure TBisTaxiDataDriverWeekScheduleFrame.FillEmptyDataSet;
var
  Day: Integer;
  Newday: Integer;
  Hour: Integer;
  D: TDateTime;
begin
  Provider.EmptyTable;

  D:=FDSchedule;
  
  for Day:=0 to 7-1 do begin
    Provider.Append;
    Provider.FieldByName('WEEK_DAY').AsInteger:=Day;
    Newday:=Day+2;
    if Newday>7 then
      Newday:=1;

    D:=IncDay(D);

    Provider.FieldByName('DAY_DATE').Value:=D;
    Provider.FieldByName('DAY_NAME').AsString:=FormatEx('%s | %s',[FormatDateTime('dd.mm',D),
                                                                   ShortDayNames[Newday]]);

    for hour:=0 to 24-1 do begin
      Provider.FieldByName(GetFieldCount(hour)).Value:=Null;
      Provider.FieldByName(GetFieldExists(hour)).AsInteger:=Integer(false);
    end;
    Provider.Post;
    
  end;
  Provider.First;
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.SetSum;
begin
  LabelSum.Caption:=IntToStr(FSum);
  LabelSum.Update;
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.DoAfterOpenRecords;
var
  D1,D2: TBisDataset;
  Found: Boolean;
  WD: Integer;
  DD: Variant;
  H: Integer;
begin
  if Assigned(FWeekSchedules) and Assigned(FDriverSchedules) then begin
    D1:=TBisDataset.Create(nil);
    D2:=TBisDataset.Create(nil);
    try
      if FWeekSchedules.GetDataSet(D1) and FDriverSchedules.GetDataSet(D2) then begin

        Provider.Close;
        Provider.CreateTable();
        FillEmptyDataSet;
        
        FSum:=0;
        SetSum;

        D1.First;
        while not D1.Eof do begin
          WD:=D1.FieldByName('WEEK_DAY').AsInteger;
          Found:=Provider.Locate('WEEK_DAY',WD,[]);
          if Found then begin
            H:=D1.FieldByName('DAY_HOUR').AsInteger;
            Provider.Edit;
            Provider.FieldByName(GetFieldExists(H)).AsInteger:=Integer(true);
            if CheckDateSchedule(Provider.FieldByName('DAY_DATE').Value) then
              Provider.FieldByName(GetFieldCount(H)).AsInteger:=1;
            Provider.Post;
            Inc(FSum);
          end;
          D1.Next;
        end;

        SetSum;

        D2.First;
        while not D2.Eof do begin
          DD:=D2.FieldByName('DAY_DATE').Value;
          Found:=Provider.Locate('DAY_DATE',DD,[]);
          if Found then begin
            H:=D2.FieldByName('DAY_HOUR').AsInteger;
            Provider.Edit;
            Provider.FieldByName(GetFieldCount(H)).AsInteger:=Provider.FieldByName(GetFieldCount(H)).AsInteger+
                                                              D2.FieldByName('DRIVER_COUNT').AsInteger;
            Provider.Post;
          end;
          D2.Next;
        end;
      end;
    finally
      D2.Free;
      D1.Free;
    end;
  end;
  inherited DoAfterOpenRecords;
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.DoBeforeOpenRecords;
var
  D1,D2: TBisDataSet;
  DSchedule: TDateTime;
  DW: Word;
begin
  inherited DoBeforeOpenRecords;

  if not VarIsNull(FDriverId) then begin
  
    DSchedule:=DateOf(Core.ServerDate);
    DW:=DayOfWeek(DSchedule);
    FDSchedule:=IncDay(DSchedule,-DW+1);
    FDateBegin:=IncDay(DateOf(FDSchedule));
    FDateEnd:=IncDay(FDateBegin,7);

    D1:=TBisDataSet.Create(nil);
    D2:=TBisDataSet.Create(nil);
    try
      D1.ProviderName:='S_DRIVER_WEEK_SCHEDULES';
      with D1.FieldNames do begin
        AddInvisible('WEEK_DAY');
        AddInvisible('DAY_HOUR');
      end;
      D1.FilterGroups.Add.Filters.Add('DRIVER_ID',fcEqual,FDriverId);
      D1.Orders.Add('WEEK_DAY');
      D1.Orders.Add('DAY_HOUR');

      D2.ProviderName:='GET_DRIVER_SCHEDULES';
      with D2.Params do begin
        AddInvisible('DATE_BEGIN').Value:=FDateBegin;
        AddInvisible('DATE_END').Value:=FDateEnd;
        AddInvisible('DRIVER_ID').Value:=FDriverId;
      end;
      with D2.FieldNames do begin
        AddInvisible('DAY_DATE');
        AddInvisible('DAY_HOUR');
        AddInvisible('DRIVER_COUNT');
      end;
      D2.OpenMode:=omExecute;

      Provider.CollectionAfter.Clear;

      FWeekSchedules:=Provider.CollectionAfter.AddDataSet(D1);
      FDriverSchedules:=Provider.CollectionAfter.AddDataSet(D2);

    finally
      D2.Free;
      D1.Free;
    end;
 end;

end;

procedure TBisTaxiDataDriverWeekScheduleFrame.OpenRecords;
begin
  inherited OpenRecords;
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.ActionClearAllExecute(Sender: TObject);
begin
  ClearAll;
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.ActionClearAllUpdate(Sender: TObject);
begin
  ActionClearAll.Enabled:=CanClear;
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.ActionClearExecute(Sender: TObject);
begin
  Clear;
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.ActionClearUpdate(Sender: TObject);
begin
  ActionClear.Enabled:=CanClear;
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.ApplyFor;
var
  P: TBisProvider;
  Exists: Boolean;
  S: String;
  H: Integer;
  Count: Integer;
  B: TBookmark;
begin
  if FCanChange and
     Provider.Active and not Provider.Empty and
     Assigned(Grid.SelectedField) then begin
     
    S:=Copy(Grid.SelectedFieldName,Length('HOUR_COUNT_')+1,MaxInt);
    if TryStrToInt(S,H) then begin
      B:=Provider.GetBookmark;
      P:=TBisProvider.Create(nil);
      try
        Exists:=Boolean(Provider.FieldByName(GetFieldExists(H)).AsInteger);
        if not Exists then begin
          P.ProviderName:='I_DRIVER_WEEK_SCHEDULE';
          with P.Params do begin
            AddInvisible('DRIVER_ID').Value:=FDriverId;
            AddInvisible('WEEK_DAY').Value:=Provider.FieldByName('WEEK_DAY').Value;
            AddInvisible('DAY_HOUR').Value:=H;
          end;
          P.Execute;
          if P.Success then begin
            Provider.Edit;
            if CheckDateSchedule(Provider.FieldByName('DAY_DATE').Value) then
              Provider.FieldByName(GetFieldCount(H)).AsInteger:=Provider.FieldByName(GetFieldCount(H)).AsInteger+1;
            Provider.FieldByName(GetFieldExists(H)).AsInteger:=Integer(true);
            Provider.Post;
            Inc(FSum);
          end;
        end else begin
          P.ProviderName:='D_DRIVER_WEEK_SCHEDULE';
          with P.Params do begin
            AddInvisible('OLD_DRIVER_ID').Value:=FDriverId;
            AddInvisible('OLD_WEEK_DAY').Value:=Provider.FieldByName('WEEK_DAY').Value;
            AddInvisible('OLD_DAY_HOUR').Value:=H;
          end;
          P.Execute;
          if P.Success then begin
            Provider.Edit;
            if CheckDateSchedule(Provider.FieldByName('DAY_DATE').Value) then begin
              Count:=Provider.FieldByName(GetFieldCount(H)).AsInteger-1;
              Provider.FieldByName(GetFieldCount(H)).Value:=Iff(Count>0,Count,Null);
            end;
            Provider.FieldByName(GetFieldExists(H)).AsInteger:=Integer(false);
            Provider.Post;
            Dec(FSum);
          end;
        end;
        SetSum;
      finally
        P.Free;
        if Assigned(B) and Provider.BookmarkValid(B) then
          Provider.GotoBookmark(B);
      end;
    end;
  end;
end;

function TBisTaxiDataDriverWeekScheduleFrame.ClearSchedule(WeekDay: Variant): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  if not VarIsNull(FDriverId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='C_DRIVER_WEEK_SCHEDULE';
      with P.Params do begin
        AddInvisible('DRIVER_ID').Value:=FDriverId;
        AddInvisible('WEEK_DAY').Value:=WeekDay;
      end;
      P.Execute;
      Result:=P.Success;
    finally
      P.Free;
    end;
  end;
end;

function TBisTaxiDataDriverWeekScheduleFrame.CanClear: Boolean;
begin
  Result:=Provider.Active and not Provider.Empty{ and (FSum>0)};
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.Clear;
begin
  if CanClear then begin
    if ClearSchedule(Provider.FieldByName('WEEK_DAY').Value) then
      RefreshRecords;
  end;
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.ClearAll;
begin
  if CanClear then begin
    if ClearSchedule(Null) then
      RefreshRecords;
  end;
end;

function TBisTaxiDataDriverWeekScheduleFrame.CheckDateSchedule(DayDate: Variant): Boolean;
var
  D1,D2: TDateTime;
begin
  Result:=false;
  if not VarIsNull(DayDate) and
     not VarIsNull(FDateSchedule) then begin
    D1:=VarToDateDef(DayDate,NullDate);
    D2:=VarToDateDef(FDateSchedule,NullDate);
    Result:=D1>=D2;
  end;
end;


end.
