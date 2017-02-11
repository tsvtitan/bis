unit BisCallcDealsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Contnrs,
  BisCallcTaskFrm, BisCallcDealsFrameTasksFrm, BisReportFrm;

type
  TBisCallcDealsFrameSheet=class(TObject)
  private
    FTabSheet: TTabSheet;
    FReport: TBisReportFrame;
  public
    constructor Create;
    destructor Destroy; override;

    property TabSheet: TTabSheet read FTabSheet;
    property Report: TBisReportFrame read FReport write FReport;
  end;

  TBisCallcDealsFrameSheets=class(TObjectList)
  private
    FEnabled: Boolean;
    function GetItem(Index: Integer): TBisCallcDealsFrameSheet;
    procedure SetEnabled(const Value: Boolean);
  public
    function Add(Caption: String): TBisCallcDealsFrameSheet;

    property Items[Index: Integer]: TBisCallcDealsFrameSheet read GetItem;
    property Enabled: Boolean read FEnabled write SetEnabled;
  end;

  TBisCallcDealsFrame = class(TBisCallcTaskFrame)
    PageControl: TPageControl;
    TabSheetTasks: TTabSheet;
    procedure PageControlChange(Sender: TObject);
  private
    FTasksFrame: TBisCallcDealsFrameTasksFrame;
    FSheets: TBisCallcDealsFrameSheets;
    FPurpose: Integer;
    FOldPageActiveIndex: Integer;
    procedure RefreshDeals;
    procedure RefreshReports;
    procedure ReportGetParamValue(Sender: TBisReportFrame; const ParamName: String; var Value: Variant);
    function GetTasksVisible: Boolean;
    procedure SetTasksVisible(const Value: Boolean);
    procedure TasksFrameTaskChecked(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure RefreshControls; override;
    function ExecuteTask(PerformerId: Variant; ResultId: Variant; Description: String; DateTask: TDateTime; PlanId: Variant): Boolean; override;

    property Purpose: Integer read FPurpose write FPurpose;
    property TasksVisible: Boolean read GetTasksVisible write SetTasksVisible;
  end;

var
  BisCallcDealsFrame: TBisCallcDealsFrame;

implementation

uses BisProvider, BisFilterGroups, BisUtils, BisFastReportFrm, BisCore;

{$R *.dfm}

{ TBisCallcDealsFrameSheet }

constructor TBisCallcDealsFrameSheet.Create;
begin
  inherited Create;
  FTabSheet:=TTabSheet.Create(nil);
end;

destructor TBisCallcDealsFrameSheet.Destroy;
begin
  FreeAndNilEx(FReport);
  FTabSheet.Free;
  inherited;
end;

{ TBisCallcDealsFrameSheets}

function TBisCallcDealsFrameSheets.Add(Caption: String): TBisCallcDealsFrameSheet;
begin
  Result:=TBisCallcDealsFrameSheet.Create;
  Result.TabSheet.Caption:=Caption;
  inherited Add(Result);
end;

function TBisCallcDealsFrameSheets.GetItem( Index: Integer): TBisCallcDealsFrameSheet;
begin
  Result:=TBisCallcDealsFrameSheet(inherited Items[Index]);
end;

procedure TBisCallcDealsFrameSheets.SetEnabled(const Value: Boolean);
var
  i: Integer;
begin
  FEnabled:=Value;
  for I:=0 to Count-1 do begin
    Items[i].TabSheet.Enabled:=Value;
    Items[i].TabSheet.TabVisible:=Value;
  end;
end;

{ TBisCallcTasksFrame }

constructor TBisCallcDealsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTasksFrame:=TBisCallcDealsFrameTasksFrame.Create(Self);
  FTasksFrame.Align:=alClient;
  FTasksFrame.Parent:=TabSheetTasks;
  FTasksFrame.OnTaskChecked:=TasksFrameTaskChecked;
  FSheets:=TBisCallcDealsFrameSheets.Create;
end;

destructor TBisCallcDealsFrame.Destroy;
begin
  TaskId:=Null;
  PageControl.ActivePageIndex:=0;
  PageControl.Update;
  FSheets.Free;
  FTasksFrame.Free;
  inherited Destroy;
end;

function TBisCallcDealsFrame.ExecuteTask(PerformerId: Variant; ResultId: Variant; Description: String; DateTask: TDateTime; PlanId: Variant): Boolean;
begin
  Result:=FTasksFrame.ExecuteTask(PerformerId,ResultId,Description,DateTask,PlanId);
  TaskId:=Null;
end;

procedure TBisCallcDealsFrame.Init;
begin
  inherited Init;
  FTasksFrame.Init;
end;

procedure TBisCallcDealsFrame.RefreshControls;
begin
  inherited RefreshControls;
  RefreshDeals;
end;

procedure TBisCallcDealsFrame.RefreshDeals;
begin
  PageControl.ActivePageIndex:=0;
  FOldPageActiveIndex:=-1;
  FTasksFrame.Purpose:=FPurpose;
  FTasksFrame.DealId:=DealId;
  FTasksFrame.DealNum:=DealNum;
  FTasksFrame.TaskId:=TaskId;
  FTasksFrame.TaskName:=TaskName;
  FTasksFrame.ActionId:=ActionId;
  FTasksFrame.OnlyOneTask:=OnlyOneTask;
  FTasksFrame.RefreshRecords;
  RefreshReports;
end;

procedure TBisCallcDealsFrame.RefreshReports;
var
  P: TBisProvider;
  Sheet: TBisCallcDealsFrameSheet;
  ReportType: Integer;
  AClass: TBisReportFrameClass;
begin
  FSheets.Clear;
  if not VarIsNull(ActionId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_ACTION_REPORTS';
      with P.FieldNames do begin
        AddInvisible('REPORT_ID');
        AddInvisible('REPORT_NAME');
        AddInvisible('REPORT_TYPE');
      end;
      P.FilterGroups.Add.Filters.Add('ACTION_ID',fcEqual,ActionId);
      P.Orders.Add('PRIORITY');
      P.Open;
      if P.Active and not P.IsEmpty then begin
        P.First;
        while not P.Eof do begin
          ReportType:=P.FieldByName('REPORT_TYPE').AsInteger;
          AClass:=nil;
          case ReportType of
            0: AClass:=TBisFastReportFrame;
          end;
          if Assigned(AClass) then begin
            Sheet:=FSheets.Add(P.FieldByName('REPORT_NAME').AsString);
            if Assigned(Sheet) then begin
              with Sheet do begin
                Report:=AClass.Create(nil);
                Report.Parent:=Sheet.TabSheet;
                Report.Align:=alClient;
                Report.ReportId:=P.FieldByName('REPORT_ID').Value;
                Report.OnGetParamValue:=ReportGetParamValue;
                TabSheet.PageControl:=PageControl;
                TabSheet.TabVisible:=FTasksFrame.CheckedCount>0;
              end;
            end;
          end;
          P.Next;
        end;
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisCallcDealsFrame.PageControlChange(Sender: TObject);
var
  Sheet: TBisCallcDealsFrameSheet;
begin
  if FOldPageActiveIndex<>PageControl.ActivePageIndex then begin
    if PageControl.ActivePageIndex>0 then begin
      Sheet:=FSheets.Items[PageControl.ActivePageIndex-1];
      Sheet.Report.RefreshReport;
    end;
    FOldPageActiveIndex:=PageControl.ActivePageIndex;
  end;
end;

procedure TBisCallcDealsFrame.ReportGetParamValue(Sender: TBisReportFrame; const ParamName: String; var Value: Variant);
var
  i: Integer;
  OldCursor: TCursor;
  AId: Variant;
  Position: Integer;
  S: String;
  Breaked: Boolean;
  AChecked: Boolean;
  Str: TStringList;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  Str:=TStringList.Create;
  try
    Str.Duplicates:=dupIgnore;

    if AnsiSameText(ParamName,'DIALOG_VISIBLE') then begin
      Value:=0;
    end;
    if AnsiSameText(ParamName,'DEAL_IDS') then begin

      with FTasksFrame do begin
        if Provider.Active and not Provider.IsEmpty then begin
          Core.Progress(0,0,0,Breaked);
          Provider.BeginUpdate(true);
          try
            Position:=1;
            Provider.First;
            while not Provider.Eof do begin
              AChecked:=Boolean(Provider.FieldByName('CHECKED').AsInteger);
              if AChecked then begin
                AId:=Provider.FieldByName('DEAL_ID').Value;
                if not VarIsNull(AId) then begin
                  S:=VarToStrDef(AId,'');
                  if Trim(S)<>'' then
                    Str.Add(S);
                end;
              end;
              Core.Progress(0,Provider.RecordCount,Position,Breaked);
              Inc(Position);
              Provider.Next;
            end;
          finally
            Provider.EndUpdate;
            Core.Progress(0,0,0,Breaked); 
          end;
        end;
      end;

      S:='';
      for i:=0 to Str.Count-1 do begin
        if i=0 then
          S:=Str.Strings[i]
        else S:=S+';'+Str.Strings[i];
      end;

      Value:=S;
    end;
  finally
    Str.Free;
    Screen.Cursor:=OldCursor;
  end;
end;

function TBisCallcDealsFrame.GetTasksVisible: Boolean;
begin
  Result:=FTasksFrame.TasksVisible;
end;

procedure TBisCallcDealsFrame.SetTasksVisible(const Value: Boolean);
begin
  FTasksFrame.TasksVisible:=Value;
end;

procedure TBisCallcDealsFrame.TasksFrameTaskChecked(Sender: TObject);
var
  TaskChanged: Boolean;
  OldTaskId: Variant;
  TempTaskId: Variant;
  AChecked: Boolean;
begin
  TaskChanged:=false;
  OldTaskId:=TaskId;
  AChecked:=Boolean(FTasksFrame.Provider.FieldByName('CHECKED').AsInteger);
  TempTaskId:=FTasksFrame.Provider.FieldByName('TASK_ID').Value;

  if AChecked then begin
    TaskChanged:=FTasksFrame.CheckedCount=1;
    if TaskChanged then
      TaskId:=TempTaskId;
{  end else begin
    TaskChanged:=(FTasksFrame.CheckedCount=1) and not VarSameValue(FTasksFrame.FirstTaskId,TempTaskId);
    if TaskChanged then
      TaskId:=FTasksFrame.FirstTaskId;}
  end;

  FSheets.Enabled:=FTasksFrame.CheckedCount>0;
  if Assigned(OnChangeControls) then
    OnChangeControls(FSheets.Enabled,TaskChanged);
end;

end.
