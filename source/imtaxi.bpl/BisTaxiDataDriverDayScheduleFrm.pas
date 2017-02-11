unit BisTaxiDataDriverDayScheduleFrm;

interface
                                          
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids,
  VirtualTrees, 
  BisDataFrm, BisDbTree, BisDataGridFrm, BisDataSet, BisControls;                                                                

type
  TBisTaxiDataDriverDayScheduleFrame = class(TBisDataGridFrame)
    PanelBottom: TPanel;
    LabelSum: TLabel;
    PanelTop: TPanel;
    LabelWorkDays: TLabel;
    EditWorkDays: TEdit;
    UpDownWorkDays: TUpDown;
    LabelRestDays: TLabel;
    EditRestDays: TEdit;
    UpDownRestDays: TUpDown;
    ActionClear: TAction;
    N1: TMenuItem;
    MenuItemClear: TMenuItem;
    ActionClearAll: TAction;
    MenuItemClearAll: TMenuItem;
    procedure EditWorkDaysChange(Sender: TObject);
    procedure ActionClearUpdate(Sender: TObject);
    procedure ActionClearExecute(Sender: TObject);
    procedure ActionClearAllUpdate(Sender: TObject);
    procedure ActionClearAllExecute(Sender: TObject);
    procedure LabelSumClick(Sender: TObject);
  private
    FDriverId: Variant;
    FCanChange: Boolean;
    FSum: Integer;
    FDateSchedule: Variant;
    FDateBegin: TDateTime;
    FDateEnd: TDateTime;
    FDSchedule: TDateTime;
    FMaxDays: Integer;
    FDaySchedules: TBisDataSetCollectionItem;
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
    function ClearSchedule(WorkDay: Variant): Boolean;
    function CanClear: Boolean;
    procedure Clear;
    procedure ClearAll;
    function CheckDateSchedule(DayDate: Variant): Boolean;
  protected
    procedure DoAfterOpenRecords; override;
    procedure DoBeforeOpenRecords; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CanRefreshRecords: Boolean; override;
    procedure OpenRecords; override;
    procedure BeforeShow; override;
    procedure SetEvents(AEnabled: Boolean);

    property DriverId: Variant read FDriverId write FDriverId;
    property DateSchedule: Variant read FDateSchedule write FDateSchedule;

    property CanChange: Boolean read FCanChange write FCanChange;
  end;

implementation

uses DateUtils,
     BisCore, BisConsts, BisUtils, BisProvider, BisFilterGroups, BisFieldNames;

{$R *.dfm}

{ TBisTaxiDataDriverDayScheduleFrame }

constructor TBisTaxiDataDriverDayScheduleFrame.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  with Provider.FieldDefs do begin
    Add('WORK_DAY',ftInteger);
    Add('WEEK_DAY',ftInteger);
    Add('REST_OR_WORK',ftInteger);
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
    Add('WORK_DAY','������� ����',40).Visible:=false;
    Add('WEEK_DAY','���� ������',40).Visible:=false;
    Add('REST_OR_WORK','���� ������',40).Visible:=false;
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

  UpDownWorkDays.Associate:=nil;
  UpDownRestDays.Associate:=nil;

  SetEvents(false);

  FDaySchedules:=nil;
  FDriverSchedules:=nil;

  FDriverId:=Null;
  FDateSchedule:=Null;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.BeforeShow;
var
  Old: String;
  V: Integer;
begin
  inherited BeforeShow;
  Old:=EditWorkDays.Text;
  UpDownWorkDays.Associate:=EditWorkDays;
  if TryStrToInt(Old,V) then
    UpDownWorkDays.Position:=V;
  EditWorkDays.Text:=Old;

  Old:=EditRestDays.Text;
  UpDownRestDays.Associate:=EditRestDays;
  if TryStrToInt(Old,V) then
    UpDownRestDays.Position:=V;
  EditRestDays.Text:=Old;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.SetEvents(AEnabled: Boolean);
begin
  if AEnabled then begin
    EditWorkDays.OnChange:=EditWorkDaysChange;
    EditRestDays.OnChange:=EditWorkDaysChange;
  end else begin
    EditWorkDays.OnChange:=nil;
    EditRestDays.OnChange:=nil;
  end;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.EditWorkDaysChange(Sender: TObject);
begin
  RefreshRecords;
end;

function TBisTaxiDataDriverDayScheduleFrame.GetFieldCount(H: Integer): String;
begin
  Result:=Format('HOUR_COUNT_%d',[H]);
end;

function TBisTaxiDataDriverDayScheduleFrame.GetFieldExists(H: Integer): String;
begin
  Result:=Format('HOUR_EXISTS_%d',[H]);
end;

procedure TBisTaxiDataDriverDayScheduleFrame.GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
                                                                  Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
var
  Exists: Boolean;
  Count: Integer;
  WeekDay: Integer;
  RestOrWork: Boolean;
  S: String;
  H: Integer;
  AColumn: TBisDBTreeColumn;
begin
  if Column=1 then begin
    WeekDay:=VarToIntDef(Grid.GetNodeValue(Node,'WEEK_DAY'),0);
    TargetCanvas.Brush.Style:=bsSolid;
    TargetCanvas.Brush.Color:=iff(WeekDay in [1,7],clWebLightCoral,clSkyBlue);
    TargetCanvas.FillRect(CellRect);
  end else begin
    AColumn:=Grid.Header.Columns[Column];
    if Assigned(AColumn) then begin
      RestOrWork:=Boolean(VarToIntDef(Grid.GetNodeValue(Node,'REST_OR_WORK'),0));
      S:=Copy(AColumn.FieldName,Length('HOUR_COUNT_')+1,MaxInt);
      if TryStrToInt(S,H) then begin
        S:=GetFieldExists(H);
        Exists:=Boolean(VarToIntDef(Grid.GetNodeValue(Node,S),0));
        if Exists then begin
          if RestOrWork then begin
            TargetCanvas.Brush.Style:=bsSolid;
            TargetCanvas.Brush.Color:=clBtnFace;
          end else begin
            TargetCanvas.Brush.Style:=bsSolid;
            if CheckDateSchedule(Grid.GetNodeValue(Node,'DAY_DATE')) then
              TargetCanvas.Brush.Color:=clLime
            else TargetCanvas.Brush.Color:=clSilver;
          end;
          TargetCanvas.FillRect(CellRect);
        end else begin
          S:=GetFieldCount(H);
          Count:=VarToIntDef(Grid.GetNodeValue(Node,S),0);
          if Count>0 then begin
            if RestOrWork then begin
              TargetCanvas.Brush.Style:=bsSolid;
              TargetCanvas.Brush.Color:=clBtnFace;
            end else begin
              TargetCanvas.Brush.Style:=bsSolid;
              TargetCanvas.Brush.Color:=clMoneyGreen;
            end;
            TargetCanvas.FillRect(CellRect);
          end else begin
            if RestOrWork then begin
              TargetCanvas.Brush.Style:=bsSolid;
              TargetCanvas.Brush.Color:=clBtnFace;
              TargetCanvas.FillRect(CellRect);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                                                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
begin
  //
end;

procedure TBisTaxiDataDriverDayScheduleFrame.LabelSumClick(Sender: TObject);
begin
  Grid.Visible:=false;
  Grid.Parent:=PanelData;
  Grid.Visible:=true;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.GridDblClick(Sender: TObject);
begin
  ApplyFor;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=VK_SPACE then begin
    ApplyFor;
  end;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.FillEmptyDataSet;
var
  Day: Integer;
  Hour: Integer;
  Flag: Boolean;
  RealDay: Integer;
  D: TDateTime;
begin
  Provider.EmptyTable;

  RealDay:=0;
  Flag:=false;
  D:=FDSchedule;

  for Day:=0 to FMaxDays-1 do begin

    if Day>=UpDownWorkDays.Position then
      Flag:=true;

    Provider.Append;
    Provider.FieldByName('DAY_DATE').Value:=D;
    Provider.FieldByName('WEEK_DAY').AsInteger:=DayOfWeek(D);
    Provider.FieldByName('DAY_NAME').AsString:=FormatEx('%s | %s',[FormatDateTime('dd.mm',D),
                                                                   ShortDayNames[DayOfWeek(D)]]);
    Provider.FieldByName('REST_OR_WORK').AsInteger:=Integer(Flag);
    if not Flag then begin
      Provider.FieldByName('WORK_DAY').AsInteger:=RealDay;
      Inc(RealDay);
    end else
      Provider.FieldByName('WORK_DAY').Value:=Null;

    for hour:=0 to 24-1 do begin
      Provider.FieldByName(GetFieldCount(Hour)).Value:=Null;
      Provider.FieldByName(GetFieldExists(Hour)).AsInteger:=Integer(false);
    end;
    Provider.Post;

    D:=IncDay(D);
  end;

  Provider.First;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.SetSum;
begin
  LabelSum.Caption:=IntToStr(FSum);
  LabelSum.Update;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.DoAfterOpenRecords;
var
  D1,D2: TBisDataset;
  Found: Boolean;
  WD: Integer;
  DD: Variant;
  H: Integer;
begin
  if Assigned(FDaySchedules) and Assigned(FDriverSchedules) then begin
    D1:=TBisDataset.Create(nil);
    D2:=TBisDataset.Create(nil);
    try
      if FDaySchedules.GetDataSet(D1) and FDriverSchedules.GetDataSet(D2) then begin

        Provider.Close;
        Provider.CreateTable;
        FillEmptyDataSet;
        
        FSum:=0;
        SetSum;

        D1.First;
        while not D1.Eof do begin
          WD:=D1.FieldByName('WORK_DAY').AsInteger;
          Found:=Provider.Locate('WORK_DAY',WD,[]);
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

procedure TBisTaxiDataDriverDayScheduleFrame.DoBeforeOpenRecords;
var
  D1,D2: TBisDataSet;
  DSchedule: TDateTime;
  DBegin: TDateTime;
  Offset: Integer;
begin
  inherited DoBeforeOpenRecords;

  if not VarIsNull(FDriverId) and not VarIsNull(FDateSchedule) then begin

    DBegin:=VarToDateDef(FDateSchedule,Core.ServerDate);
    DSchedule:=DateOf(Core.ServerDate);
    Offset:=DaysBetween(DBegin,DSchedule);
    if DBegin>DSchedule then
      Offset:=-Offset;
    FMaxDays:=UpDownWorkDays.Position+UpDownRestDays.Position;
    FDSchedule:=IncDay(DSchedule,-(Offset mod FMaxDays));
    FDateBegin:=DateOf(FDSchedule);
    FDateEnd:=DateOf(IncDay(FDSchedule,FMaxDays));

    D1:=TBisDataSet.Create(nil);
    D2:=TBisDataSet.Create(nil);
    try
      D1.ProviderName:='S_DRIVER_DAY_SCHEDULES';
      with D1.FieldNames do begin
        AddInvisible('WORK_DAY');
        AddInvisible('DAY_HOUR');
      end;
      D1.FilterGroups.Add.Filters.Add('DRIVER_ID',fcEqual,FDriverId);
      D1.Orders.Add('WORK_DAY');
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

      FDaySchedules:=Provider.CollectionAfter.AddDataSet(D1);
      FDriverSchedules:=Provider.CollectionAfter.AddDataSet(D2);

    finally
      D2.Free;
      D1.Free;
    end;
 end;

end;

procedure TBisTaxiDataDriverDayScheduleFrame.OpenRecords;
begin
  inherited OpenRecords;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.ActionClearAllExecute(Sender: TObject);
begin
  ClearAll;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.ActionClearAllUpdate(Sender: TObject);
begin
  ActionClearAll.Enabled:=CanClear;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.ActionClearExecute(Sender: TObject);
begin
  Clear;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.ActionClearUpdate(Sender: TObject);
begin
  ActionClear.Enabled:=CanClear;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.ApplyFor;
var
  P: TBisProvider;
  Exists: Boolean;
  S: String;
  H: Integer;
  Count: Integer;
  B: TBookmark;
  WD: Variant;
begin
  if FCanChange and
     Provider.Active and not Provider.Empty and
     Assigned(Grid.SelectedField) then begin
     
    S:=Copy(Grid.SelectedFieldName,Length('HOUR_COUNT_')+1,MaxInt);
    WD:=Provider.FieldByName('WORK_DAY').Value;
    if TryStrToInt(S,H) and not VarIsNull(WD) then begin
      B:=Provider.GetBookmark;
      P:=TBisProvider.Create(nil);
      try
        Exists:=Boolean(Provider.FieldByName(GetFieldExists(H)).AsInteger);
        if not Exists then begin
          P.ProviderName:='I_DRIVER_DAY_SCHEDULE';
          with P.Params do begin
            AddInvisible('DRIVER_ID').Value:=FDriverId;
            AddInvisible('WORK_DAY').Value:=WD;
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
          P.ProviderName:='D_DRIVER_DAY_SCHEDULE';
          with P.Params do begin
            AddInvisible('OLD_DRIVER_ID').Value:=FDriverId;
            AddInvisible('OLD_WORK_DAY').Value:=WD;
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

function TBisTaxiDataDriverDayScheduleFrame.ClearSchedule(WorkDay: Variant): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  if not VarIsNull(FDriverId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='C_DRIVER_DAY_SCHEDULE';
      with P.Params do begin
        AddInvisible('DRIVER_ID').Value:=FDriverId;
        AddInvisible('WORK_DAY').Value:=WorkDay;
      end;
      P.Execute;
      Result:=P.Success;
    finally
      P.Free;
    end;
  end;
end;

function TBisTaxiDataDriverDayScheduleFrame.CanClear: Boolean;
begin
  Result:=Provider.Active and not Provider.Empty{ and (FSum>0)};
end;

function TBisTaxiDataDriverDayScheduleFrame.CanRefreshRecords: Boolean;
begin
  Result:=inherited CanRefreshRecords;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.Clear;
var
  WorkDay: Variant;
begin
  if CanClear then begin
    WorkDay:=Provider.FieldByName('WORK_DAY').Value;
    if not VarIsNull(WorkDay) and ClearSchedule(WorkDay) then
      RefreshRecords;
  end;
end;

procedure TBisTaxiDataDriverDayScheduleFrame.ClearAll;
begin
  if CanClear then begin
    if ClearSchedule(Null) then
      RefreshRecords;
  end;
end;

function TBisTaxiDataDriverDayScheduleFrame.CheckDateSchedule(DayDate: Variant): Boolean;
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
