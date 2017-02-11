unit BisTaxiDataDriverWeekScheduleFrm;

interface
                                          
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids,
  VirtualTrees, 
  BisDataFrm, BisDbTree, BisDataGridFrm;                                                                

type
  TBisTaxiDataDriverWeekScheduleFrame = class(TBisDataGridFrame)
    PanelBottom: TPanel;
    LabelSum: TLabel;
  private
    FDriverId: Variant;
    FCanChange: Boolean;
    FSum: Integer;
    function GetFieldCount(H: Integer): String;
    function GetFieldExists(H: Integer): String;
    procedure FillDataSet;
    procedure FillEmptyDataSet;
    procedure ApplyFor;
    procedure SetSum;
    procedure GridDblClick(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
                                  Column: TColumnIndex; CellRect: TRect);
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  public
    constructor Create(AOwner: TComponent); override;
    procedure OpenRecords; override;

    property DriverId: Variant read FDriverId write FDriverId;
    property CanChange: Boolean read FCanChange write FCanChange;
  end;

implementation

uses
     BisUtils, BisProvider, BisFilterGroups, BisFieldNames;

{$R *.dfm}

{ TBisTaxiDataDriverWeekScheduleFrame }

constructor TBisTaxiDataDriverWeekScheduleFrame.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  with Provider.FieldDefs do begin
    Add('ID',ftString,32);
    Add('WEEK_DAY',ftInteger);
    Add('DAY_NAME',ftString,10);
    for i:=0 to 24-1 do begin
      Add(GetFieldCount(i),ftInteger);
      Add(GetFieldExists(i),ftInteger);
    end;
  end;

  with Provider.FieldNames do begin
    AddKey('ID');
    Add('DAY_NAME','����',40).Alignment:=daCenter;
    for i:=0 to 24-1 do begin
      Add(GetFieldCount(i),IntToStr(i),25).Alignment:=daCenter;
      Add(GetFieldExists(i),IntToStr(i),30).Visible:=false;
    end;
    Add('WEEK_DAY','���� ������',40).Visible:=false;
  end;
  Provider.CreateTable();

  Grid.SortEnabled:=false;
  Grid.ChessVisible:=false;
  Grid.OnDblClick:=GridDblClick;
  Grid.OnBeforeCellPaint:=GridBeforeCellPaint;
  Grid.OnPaintText:=GridPaintText;
  Grid.OnKeyDown:=GridKeyDown;

  FDriverId:=Null;
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
    TargetCanvas.Brush.Color:=iff(WeekDay>=5,clWebLightCoral,clBtnFace);
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
          TargetCanvas.Brush.Color:=clLime;
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
  day: Integer;
  newday: Integer;
  hour: Integer;
begin
  Provider.EmptyTable;
  for day:=0 to 7-1 do begin
    Provider.Append;
    Provider.FieldByName('ID').Value:=GetUniqueID;
    Provider.FieldByName('WEEK_DAY').AsInteger:=day;
    newday:=day+2;
    if newday>7 then
      newday:=1;
    Provider.FieldByName('DAY_NAME').AsString:=ShortDayNames[newday];
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

procedure TBisTaxiDataDriverWeekScheduleFrame.FillDataSet;
var
  P1,P2: TBisProvider;
  Found: Boolean;
  WD: Integer;
  H: Integer;
begin
  FSum:=0;
  SetSum;
  
  P1:=TBisProvider.Create(nil);
  P2:=TBisProvider.Create(nil);
  try
    P1.ProviderName:='S_DRIVER_WEEK_SCHEDULES';
    with P1.FieldNames do begin
      AddInvisible('WEEK_DAY');
      AddInvisible('DAY_HOUR');
    end;
    P1.FilterGroups.Add.Filters.Add('DRIVER_ID',fcEqual,FDriverId);
    P1.Orders.Add('WEEK_DAY');
    P1.Orders.Add('DAY_HOUR');
    P1.Open;

    P2.ProviderName:='GET_DRIVER_WEEK_SHCHEDULES';
    with P2.FieldNames do begin
      AddInvisible('WEEK_DAY');
      AddInvisible('DAY_HOUR');
      AddInvisible('DRIVER_COUNT');
    end;
    P2.OpenWithExecute;

    if P1.Active and P2.Active then begin
      FillEmptyDataSet;

      Provider.BeginUpdate(false);
      try

        P1.First;
        while not P1.Eof do begin
          WD:=P1.FieldByName('WEEK_DAY').AsInteger;
          Found:=Provider.Locate('WEEK_DAY',WD,[]);
          if Found then begin
            H:=P1.FieldByName('DAY_HOUR').AsInteger;
            Provider.Edit;
            Provider.FieldByName(GetFieldExists(H)).AsInteger:=Integer(true);
            Provider.Post;
            Inc(FSum);
          end;
          P1.Next;
        end;

        SetSum;

        P2.First;
        while not P2.Eof do begin
          WD:=P2.FieldByName('WEEK_DAY').AsInteger;
          Found:=Provider.Locate('WEEK_DAY',WD,[]);
          if Found then begin
            H:=P2.FieldByName('DAY_HOUR').AsInteger;
            Provider.Edit;
            Provider.FieldByName(GetFieldCount(H)).AsInteger:=P2.FieldByName('DRIVER_COUNT').AsInteger;
            Provider.Post;
            Grid.Synchronize;
          end;
          P2.Next;
        end;

        Provider.First;

      finally
        Provider.EndUpdate(false);
      end;

    end;
  finally
    P2.Free;
    P1.Free;
  end;
end;

procedure TBisTaxiDataDriverWeekScheduleFrame.OpenRecords;
begin
  Grid.DataSource:=nil;
  try
    inherited OpenRecords;
    FillDataSet;
  finally
    Grid.DataSource:=DataSource;
  end;
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
            Count:=Provider.FieldByName(GetFieldCount(H)).AsInteger-1;
            Provider.FieldByName(GetFieldCount(H)).Value:=Iff(Count>0,Count,Null);
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


end.