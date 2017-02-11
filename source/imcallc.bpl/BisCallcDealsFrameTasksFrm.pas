unit BisCallcDealsFrameTasksFrm;

interface

uses Windows, Classes, Controls, Forms, DB, ActnList, ComCtrls, ToolWin, StdCtrls,
     ExtCtrls, Grids, DBGrids, Menus, ActnPopup, ImgList,
     BisDataEditFm, BisDataGridFrm, BisFieldNames, BisProvider, BisVariants,
     BisCallcDealsFrameTasksFilterFm, DBCtrls;

type

  TBisCallcDealsFrameTasksFrameTasksFrame=class(TBisDataGridFrame)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TBisCallcDealsFrameTasksFrame=class(TBisDataGridFrame)
    ActionChecking: TAction;
    N13: TMenuItem;
    N15: TMenuItem;
    ActionUnChecking: TAction;
    ActionCheckingAll: TAction;
    ActionUnCheckingAll: TAction;
    N16: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    GroupBoxTasks: TGroupBox;
    Splitter: TSplitter;
    PanelTasks: TPanel;
    DBMemoTaskDescription: TDBMemo;
    SplitterTasks: TSplitter;
    procedure ActionCheckingExecute(Sender: TObject);
    procedure ActionCheckingUpdate(Sender: TObject);
    procedure ActionUnCheckingExecute(Sender: TObject);
    procedure ActionUnCheckingUpdate(Sender: TObject);
    procedure ActionCheckingAllExecute(Sender: TObject);
    procedure ActionCheckingAllUpdate(Sender: TObject);
    procedure ActionUnCheckingAllExecute(Sender: TObject);
    procedure ActionUnCheckingAllUpdate(Sender: TObject);
  private
    FPurpose: Integer;
    FActionId: Variant;
    FTaskId: Variant;
    FFieldNameChecked: TBisFieldName;
    FTaskName: String;
    FDealNum: String;
    FDealId: Variant;
    FGroups: TBisVariants;
    FTasksFrame: TBisCallcDealsFrameTasksFrameTasksFrame;
    FCheckedCount: Integer;
    FOnTaskChecked: TNotifyEvent;
    FFirstBeforeFlag: Boolean;
    FOldIfaceFilterAfterExecute: TBisDataEditFormExecuteEvent;
    FFirstTaskId: Variant;
    FOnlyOneTask: Boolean;

    procedure RefreshGroups;
    procedure CheckingSelected(OnlySelected: Boolean; Checked: Boolean);
    procedure GridClick(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UnLockTasks;
    function LockTask: Boolean;
    function UnLockTask: Boolean;
    function GetTasksVisible: Boolean;
    procedure SetTasksVisible(const Value: Boolean);
    procedure ProviderAfterScroll(DataSet: TDataSet);
    procedure DoTaskChecked;
    procedure IfaceFilterAfterExecute(Sender: TBisDataEditForm; Provider: TBisProvider);
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;


    procedure OpenRecords; override;
    function CanChecking: Boolean;
    procedure Checking;
    function CanUnChecking: Boolean;
    procedure UnChecking;
    function CanCheckingAll: Boolean;
    procedure CheckingAll;
    function CanUnCheckingAll: Boolean;
    procedure UnCheckingAll;

    function ExecuteTask(PerformerId,ResultId: Variant; Description: String; DateTask: TDateTime; PlanId: Variant): Boolean;

    property Purpose: Integer read FPurpose write FPurpose;
    property DealId: Variant read FDealId write FDealId;
    property DealNum: String read FDealNum write FDealNum;
    property TaskId: Variant read FTaskId write FTaskId;
    property TaskName: String read FTaskName write FTaskName;
    property ActionId: Variant read FActionId write FActionId;
    property OnlyOneTask: Boolean read FOnlyOneTask write FOnlyOneTask; 
    property TasksVisible: Boolean read GetTasksVisible write SetTasksVisible;


    property CheckedCount: Integer read FCheckedCount;
    property FirstTaskId: Variant read FFirstTaskId; 

    property OnTaskChecked: TNotifyEvent read FOnTaskChecked write FOnTaskChecked;
  end;

implementation

uses Variants, SysUtils,
     VirtualTrees, VirtualDBTreeEx,
     BisFilterGroups, BisDBTree, BisParam, BisCore, BisUtils,
     BisLogger, BisCallcDealEditFm, BisCallcConsts;

{$R *.dfm}

{ TBisCallcDealsFrameTasksFrameTasksFrame }

constructor TBisCallcDealsFrameTasksFrameTasksFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Grid.NumberVisible:=true;
  Grid.AutoResizeableColumns:=true;
  ControlBar.Visible:=false;
  Grid.PopupMenu:=nil;
  with Provider do begin
    ProviderName:='S_TASKS';
    with FieldNames do begin
      AddKey('TASK_ID');
      AddInvisible('DEAL_ID');
      AddInvisible('DEAL_NUM');
      AddInvisible('ACTION_ID');
      AddInvisible('ACCOUNT_ID');
      AddInvisible('PERFORMER_ID');
      AddInvisible('RESULT_ID');
      AddInvisible('USER_NAME');
      AddInvisible('PERFORMER_USER_NAME');
      AddInvisible('DATE_CREATE');
      AddInvisible('DATE_BEGIN');
      AddInvisible('DESCRIPTION');
      Add('DATE_END','���� ����������',75);
      Add('ACTION_NAME','��������',70);
      Add('RESULT_NAME','���������',140);
    end;
    FilterGroups.Add.Filters.Add('RESULT_ID',fcIsNotNull,Null);
    Orders.Add('DATE_END');
  end;
end;

destructor TBisCallcDealsFrameTasksFrameTasksFrame.Destroy;
begin

  inherited Destroy;
end;


{ TBisCallcDealsFrameTasksFrame }

constructor TBisCallcDealsFrameTasksFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UpdateClass:=TBisCallcDealEditFormIface;
  FilterClass:=TBisCallcDealsFrameTasksFilterFormIface;
  ActionFilter.Visible:=true;
  ActionExport.Visible:=false;
  ActionViewing.Visible:=true;
  ActionInsert.Visible:=false;
  ActionDuplicate.Visible:=false;
  ActionDelete.Visible:=false;
  Grid.AutoResizeableColumns:=true;
  Grid.OnClick:=GridClick;
  Grid.OnKeyDown:=GridKeyDown;
  LabelCounter.Visible:=true;
  with Provider.FieldNames do begin
    AddKey('TASK_ID');
    AddInvisible('DEAL_ID');
    AddInvisible('ACTION_ID');
    AddInvisible('ACCOUNT_ID');
    FFieldNameChecked:=AddCheckBox('CHECKED','�����',20);
    Add('DEAL_NUM','� ����',30);
    Add('FIRM_SMALL_NAME','��������',70);
    Add('SURNAME','�������',65);
    Add('NAME','���',55);
    Add('PATRONYMIC','��������',70);
    Add('ACCOUNT_NUM','����',55);
    Add('CURRENT_DEBT','����',60).DisplayFormat:=SDisplayFormatFloat;
    Add('CURRENCY_NAME','������',30);
    Add('ARREAR_PERIOD','������',30);
    Add('LAST_RESULT_NAME','��������� ���������',75);
  end;
  Provider.AfterScroll:=ProviderAfterScroll;
  Provider.BeforeOpen:=ProviderAfterScroll;


  FTasksFrame:=TBisCallcDealsFrameTasksFrameTasksFrame.Create(Self);
  FTasksFrame.Parent:=PanelTasks;
  FTasksFrame.Align:=alClient;
  FTasksFrame.PanelData.Margins.Top:=0;
  FTasksFrame.Margins.Left:=5;
  FTasksFrame.Margins.Top:=0;
  FTasksFrame.Margins.Right:=0;
  FTasksFrame.Margins.Bottom:=5;
  FTasksFrame.Provider.MasterSource:=DataSource;
  FTasksFrame.Provider.MasterFields:='DEAL_ID';

  DBMemoTaskDescription.DataSource:=FTasksFrame.DataSource;

  FCheckedCount:=0;
  FFirstBeforeFlag:=false;
  
  MultiSelect:=true;
  FGroups:=TBisVariants.Create;
  RefreshGroups;
end;

destructor TBisCallcDealsFrameTasksFrame.Destroy;
begin
  FGroups.Free;
  UnLockTasks;
  FTasksFrame.Free;
  inherited Destroy;
end;

procedure TBisCallcDealsFrameTasksFrame.DoTaskChecked;
begin
  if Assigned(FOnTaskChecked) then
    FOnTaskChecked(Self);
end;

procedure TBisCallcDealsFrameTasksFrame.ProviderAfterScroll(DataSet: TDataSet);
var
  OldCursor: TCursor;
begin
  if GroupBoxTasks.Visible then
    if DataSet.Active and not DataSet.IsEmpty and not DataSet.ControlsDisabled then begin
      OldCursor:=Screen.Cursor;
      Screen.Cursor:=crHourGlass;
      try
        FTasksFrame.OpenRecords;
        FTasksFrame.LastRecord;
      finally
        Screen.Cursor:=OldCursor;
      end;
    end else FTasksFrame.Provider.EmptyTable;
end;

procedure TBisCallcDealsFrameTasksFrame.RefreshGroups;
var
  P: TBisProvider;
begin
  FGroups.Clear;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_ACCOUNT_GROUPS';
    P.FieldNames.AddInvisible('GROUP_ID');
    P.FilterGroups.Add.Filters.Add('ACCOUNT_ID',fcEqual,Core.AccountId);
    P.Orders.Add('PRIORITY');
    P.Open;
    if P.Active and not P.IsEmpty then begin
      P.First;
      while not P.Eof do begin
        FGroups.Add(P.FieldByName('GROUP_ID').Value);
        P.Next;
      end;
    end;
  finally
    P.Free;
  end;
end;

procedure TBisCallcDealsFrameTasksFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  Iface: TBisCallcDealEditFormIface;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    if AIface is TBisCallcDealEditFormIface then begin
      Iface:=TBisCallcDealEditFormIface(AIface);
      Iface.AsModal:=true;
      Iface.DealId:=Provider.FieldByName('DEAL_ID').Value;
      Iface.DealNum:=Provider.FieldByName('DEAL_NUM').Value;
      Iface.TaskId:=Provider.FieldByName('TASK_ID').Value;
      Iface.ActionId:=Provider.FieldByName('ACTION_ID').Value;
    end;
    if AIface is TBisCallcDealsFrameTasksFilterFormIface then begin
      TBisCallcDealsFrameTasksFilterFormIface(AIface).AsModal:=true;
      if not FFirstBeforeFlag then begin
        FOldIfaceFilterAfterExecute:=TBisCallcDealsFrameTasksFilterFormIface(AIface).OnAfterExecute;
        TBisCallcDealsFrameTasksFilterFormIface(AIface).OnAfterExecute:=IfaceFilterAfterExecute;
      end;
      FFirstBeforeFlag:=true;
    end;
  end;
end;

procedure TBisCallcDealsFrameTasksFrame.IfaceFilterAfterExecute(
  Sender: TBisDataEditForm; Provider: TBisProvider);
begin
  UnCheckingAll;
  if Assigned(FOldIfaceFilterAfterExecute) then
    FOldIfaceFilterAfterExecute(Sender,Provider);
  
end;

function TBisCallcDealsFrameTasksFrame.GetTasksVisible: Boolean;
begin
  Result:=GroupBoxTasks.Visible;
end;

procedure TBisCallcDealsFrameTasksFrame.SetTasksVisible(const Value: Boolean);
begin
  GroupBoxTasks.Visible:=Value;
end;


procedure TBisCallcDealsFrameTasksFrame.GridClick(Sender: TObject);
var
  FieldName: TBisFieldName;
  AChecked: Boolean;
  ATaskId: Variant;
  Flag: Boolean;
begin
  if Provider.Active and not Provider.IsEmpty then begin
    FieldName:=Grid.SelectedFieldName;
    if (FieldName=FFieldNameChecked) and (Grid.SelectedCount=1) then begin
      Provider.BeginUpdate(true);
      try
        AChecked:=Boolean(Provider.FieldByName('CHECKED').AsInteger);
        ATaskId:=Provider.FieldByName('TASK_ID').Value;
        if not AChecked then
          Flag:=LockTask
        else Flag:=UnLockTask;
        if Flag then begin
          Provider.Edit;
          Provider.FieldByName('CHECKED').AsInteger:=Integer(not AChecked);
          Provider.Post;
        end else begin
          Provider.Delete;
          DoUpdateCounters;
        end;
      finally
        Provider.EndUpdate;
        DoTaskChecked;
      end;
    end;
  end;
end;

procedure TBisCallcDealsFrameTasksFrame.GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_SPACE) and (Shift=[]) then
    GridClick(nil);
end;

procedure TBisCallcDealsFrameTasksFrame.Init;
begin
  inherited Init;
  FTasksFrame.Init;
end;

procedure TBisCallcDealsFrameTasksFrame.OpenRecords;
var
  P: TBisProvider;
  OldCursor: TCursor;
  Checked: TBisFieldName;
  AChecked: Boolean;
  i: Integer;
begin
  Provider.Close;
  FTasksFrame.Provider.Close;
  if not VarIsNull(FActionId) then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='S_TASK_FIRMS';
      P.FieldNames.CopyFrom(Provider.FieldNames);
      Checked:=P.FieldNames.Find('CHECKED');
      if Assigned(Checked) then
        P.FieldNames.Remove(Checked);
      P.FilterGroups.CopyFrom(Provider.FilterGroups);

      if FOnlyOneTask then
        P.FilterGroups.Add.Filters.Add('TASK_ID',fcEqual,TaskId);
       

      with P.FilterGroups.Add do begin
        Filters.Add('PURPOSE',fcEqual,FPurpose);
        Filters.Add('ACTION_ID',fcEqual,FActionId);
      end;
      with P.FilterGroups.Add do begin
        Filters.Add('ACCOUNT_ID',fcEqual,Core.AccountId);
        Filters.Add('ACCOUNT_ID',fcIsNull,Null).Operator:=foOr;
      end;
      with P.FilterGroups.Add do begin
        for i:=0 to FGroups.Count - 1 do
          Filters.Add('GROUP_ID',fcEqual,FGroups.Items[i].Value).Operator:=foOr;
      end;
      with P.Orders do begin
        Add('DATE_CREATE');
      end;
      P.Open;
      if P.Active then begin
        Provider.BeginUpdate;
        try
          Provider.CreateStructure(P);
          Provider.FieldDefs.Add('CHECKED',ftInteger);
          Provider.CreateTable;
          P.First;
          FCheckedCount:=0;
          while not P.Eof do begin
            Provider.Append;
            Provider.CopyRecord(P,false,false);
            AChecked:=not VarIsNull(P.FieldByName('ACCOUNT_ID').Value);
            Provider.FieldByName('CHECKED').Value:=Integer(AChecked);
            Provider.Post;
            if AChecked then begin
              Inc(FCheckedCount);
              if FCheckedCount=1 then
                FFirstTaskId:=P.FieldByName('TASK_ID').Value;
            end;
            P.Next;
          end;
          Provider.First;
        finally
          Provider.EndUpdate;
          DoUpdateCounters;
        end;
      end;
    finally
      P.Free;
      Screen.Cursor:=OldCursor;
    end;
  end;

  if GroupBoxTasks.Visible and Provider.Active then begin
    FTasksFrame.OpenRecords;
    FTasksFrame.LastRecord;
  end;


  UnCheckingAll;

  CheckingSelected(true,true);
end;

procedure TBisCallcDealsFrameTasksFrame.ActionCheckingAllExecute(
  Sender: TObject);
begin
  CheckingAll;
end;

procedure TBisCallcDealsFrameTasksFrame.ActionCheckingAllUpdate(
  Sender: TObject);
begin
  ActionCheckingAll.Enabled:=CanCheckingAll;
end;

procedure TBisCallcDealsFrameTasksFrame.ActionCheckingExecute(Sender: TObject);
begin
  Checking;
end;

procedure TBisCallcDealsFrameTasksFrame.ActionCheckingUpdate(Sender: TObject);
begin
  ActionChecking.Enabled:=CanChecking;
end;

procedure TBisCallcDealsFrameTasksFrame.ActionUnCheckingAllExecute(
  Sender: TObject);
begin
  UnCheckingAll;
end;

procedure TBisCallcDealsFrameTasksFrame.ActionUnCheckingAllUpdate(
  Sender: TObject);
begin
  ActionUnCheckingAll.Enabled:=CanUnCheckingAll;
end;

procedure TBisCallcDealsFrameTasksFrame.ActionUnCheckingExecute(
  Sender: TObject);
begin
  UnChecking;
end;

procedure TBisCallcDealsFrameTasksFrame.ActionUnCheckingUpdate(Sender: TObject);
begin
  ActionUnChecking.Enabled:=CanUnChecking;
end;

function TBisCallcDealsFrameTasksFrame.CanChecking: Boolean;
begin
  Result:=Provider.Active and not Provider.IsEmpty and
          (Grid.SelectedCount>0);
end;

procedure TBisCallcDealsFrameTasksFrame.Checking;
begin
  if CanChecking then
    CheckingSelected(true,true);
end;

function TBisCallcDealsFrameTasksFrame.CanUnChecking: Boolean;
begin
  Result:=Provider.Active and not Provider.IsEmpty and
          (Grid.SelectedCount>0);
end;

procedure TBisCallcDealsFrameTasksFrame.UnChecking;
begin
  if CanUnChecking then
    CheckingSelected(true,false);
end;

function TBisCallcDealsFrameTasksFrame.CanCheckingAll: Boolean;
begin
  Result:=Provider.Active and not Provider.IsEmpty and
          (Grid.SelectedCount>0);
end;

procedure TBisCallcDealsFrameTasksFrame.CheckingAll;
begin
  if CanCheckingAll then
    CheckingSelected(false,true);
end;

function TBisCallcDealsFrameTasksFrame.CanUnCheckingAll: Boolean;
begin
  Result:=Provider.Active and not Provider.IsEmpty and
          (Grid.SelectedCount>0);
end;

procedure TBisCallcDealsFrameTasksFrame.UnCheckingAll;
begin
  if CanUnCheckingAll then
    CheckingSelected(false,false);
end;

function TBisCallcDealsFrameTasksFrame.LockTask: Boolean;
var
  P: TBisProvider;
  Param: TBisParam;
begin
  Result:=false;
  if Provider.Active and not Provider.IsEmpty then begin
    P:=TBisProvider.Create(Self);
    try
      P.ProviderName:='LOCK_TASK2';
      with P.Params do begin
        AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
        AddInvisible('TASK_ID').Value:=Provider.FieldByName('TASK_ID').Value;
        Param:=AddInvisible('LOCKED',ptOutput);
      end;
      P.Execute;
      Result:=not Param.Empty and Boolean(VarToIntDef(Param.Value,0));
      if Result then begin
        Inc(FCheckedCount);
        if FCheckedCount=1 then
          FFirstTaskId:=Provider.FieldByName('TASK_ID').Value;
      end;
    finally
      P.Free;
    end;
  end;
end;

function TBisCallcDealsFrameTasksFrame.UnLockTask: Boolean;
var
  P: TBisProvider;
  Param: TBisParam;
begin
  Result:=false;
  if Provider.Active and not Provider.IsEmpty then begin
    P:=TBisProvider.Create(Self);
    try
      P.ProviderName:='UNLOCK_TASK2';
      with P.Params do begin
        AddInvisible('TASK_ID').Value:=Provider.FieldByName('TASK_ID').Value;
        Param:=AddInvisible('UNLOCKED',ptOutput);
      end;
      P.Execute;
      Result:=not Param.Empty and Boolean(VarToIntDef(Param.Value,0));
      if Result then begin
        Dec(FCheckedCount);
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisCallcDealsFrameTasksFrame.UnLockTasks;
var
  AChecked: Boolean;
  OldCursor: TCursor;
  Breaked: Boolean;
  Position: Integer;
  ATaskId: Variant;
begin
  if Provider.Active and not Provider.IsEmpty then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    Core.Progress(0,0,0,Breaked);
    Provider.BeginUpdate(true);
    try
      Position:=1;
      Provider.First;
      while not Provider.Eof do begin
        ATaskId:=Provider.FieldByName('TASK_ID').Value;
        AChecked:=Boolean(Provider.FieldByName('CHECKED').AsInteger);
        if AChecked then
          UnLockTask;
        Core.Progress(0,Provider.RecordCount,Position,Breaked);
        Inc(Position);
        Provider.Next;
      end;
    finally
      Provider.EndUpdate;
      DoUpdateCounters;
      Core.Progress(0,0,0,Breaked);
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisCallcDealsFrameTasksFrame.CheckingSelected(OnlySelected, Checked: Boolean);
var
  i: Integer;
  List: TBisVariants;
  Node: PVirtualNode;
  Data: PDBVTData;
  ATaskId: Variant;
  Flag: Boolean;
  Breaked: Boolean;
  AChecked: Boolean;
begin
  if CanChecking then begin
    Core.Progress(0,0,0,Breaked);
    List:=TBisVariants.Create;
    try
      if OnlySelected then begin

        Node:=Grid.GetFirstSelected;
        while Assigned(Node) do begin
          Data:=Grid.GetNodeData(Node);
          if Assigned(Data) then
            List.Add(Data.ID);
          Node:=Grid.GetNextSelected(Node);
        end;

        Provider.BeginUpdate(true);
        try
          for i:=0 to List.Count-1 do begin
            if Provider.Locate('TASK_ID',List.Items[i].Value,[loCaseInsensitive]) then begin
              AChecked:=Boolean(Provider.FieldByName('CHECKED').AsInteger);
              if AChecked<>Checked then begin
                ATaskId:=Provider.FieldByName('TASK_ID').Value;
                if Checked then
                  Flag:=LockTask
                else Flag:=UnLockTask;
                if Flag then begin
                  Provider.Edit;
                  Provider.FieldByName('CHECKED').AsInteger:=Integer(Checked);
                  Provider.Post;
                  Grid.Synchronize;
                end else
                  Provider.Delete;
              end;
            end;
            Core.Progress(0,List.Count,i+1,Breaked);
          end;
        finally
          Provider.EndUpdate;
          DoUpdateCounters;
          DoTaskChecked;
        end;

      end else begin

        Provider.BeginUpdate(true);
        try
          i:=0;
          Provider.First;
          while not Provider.Eof do begin
            AChecked:=Boolean(Provider.FieldByName('CHECKED').AsInteger);
            if AChecked<>Checked then begin
              ATaskId:=Provider.FieldByName('TASK_ID').Value;
              if Checked then
                Flag:=LockTask
              else Flag:=UnLockTask;
              if Flag then begin
                Provider.Edit;
                Provider.FieldByName('CHECKED').AsInteger:=Integer(Checked);
                Provider.Post;
                Grid.Synchronize;
                Provider.Next;
              end else
                Provider.Delete;
            end else
              Provider.Next;
            Inc(i);
            Core.Progress(0,Provider.RecordCount,i,Breaked);
          end;
        finally
          Provider.EndUpdate;
          DoUpdateCounters;
          DoTaskChecked;
        end;

      end;
    finally
      List.Free;
      Core.Progress(0,0,0,Breaked);
    end;
  end;
end;

function TBisCallcDealsFrameTasksFrame.ExecuteTask(PerformerId,ResultId: Variant; Description: String; DateTask: TDateTime; PlanId: Variant): Boolean;
var
  AChecked: Boolean;
  OldCursor: TCursor;
  Breaked: Boolean;
  Position: Integer;
  ATaskId: Variant;
  P: TBisProvider;
  FlagNext: Boolean;
begin
  Result:=true;
  if Provider.Active and not Provider.IsEmpty then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    Core.Progress(0,0,0,Breaked);
    Provider.BeginUpdate(true);
    try
      Position:=1;
      Provider.First;
      while not Provider.Eof do begin
        ATaskId:=Provider.FieldByName('TASK_ID').Value;
        FlagNext:=true;
        AChecked:=Boolean(Provider.FieldByName('CHECKED').AsInteger);
        if AChecked then begin
          P:=TBisProvider.Create(nil);
          try
            P.WithWaitCursor:=false;
            P.ProviderName:='EXECUTE_TASK';
            with P.Params do begin
              AddInvisible('TASK_ID').Value:=ATaskId;
              AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
              AddInvisible('PERFORMER_ID').Value:=PerformerId;
              AddInvisible('RESULT_ID').Value:=ResultId;
              AddInvisible('DESCRIPTION').Value:=iff(Description<>'',Description,NULL);
              AddInvisible('DATE_TASK').Value:=DateTask;
              AddInvisible('PLAN_ID').Value:=PlanId;
            end;
            try
              P.Execute;
              FlagNext:=not P.Success;
              if not FlagNext then begin
                Provider.Delete;
                Dec(FCheckedCount);
              end;
            except
              On E: Exception do
                Core.Logger.Write(E.Message,ltError);
            end;
          finally
            P.Free;
          end;
        end;
        Core.Progress(0,Provider.RecordCount,Position,Breaked);
        Inc(Position);
        if FlagNext then
          Provider.Next;
      end;
    finally
      Provider.EndUpdate;
      DoUpdateCounters;
      FFirstTaskId:=Null;
      Core.Progress(0,0,0,Breaked);
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

end.