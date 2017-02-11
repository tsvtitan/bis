unit BisDataFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ToolWin, ActnMan, ActnCtrls, ComCtrls, ExtCtrls, ImgList,
  DBActns, DB, Grids, DBGrids, Menus, ActnPopup, Contnrs, StdCtrls,
  BisFm, BisDataSet, BisProvider, BisDataEditFm, BisFilterGroups, BisFieldNames,
  BisIfaces, BisReportFm, BisThreads, BisEvents,
  BisFrm;

type
  TBisDataFrame=class;

  TBisDataFrameCanEvent=function (Sender: TBisDataFrame): Boolean of object;
  TBisDataFrameEvent=procedure (Sender: TBisDataFrame) of object;

  TBisDataFrameInsertMenuItem=class(TMenuItem)
  private
    FInsertClass: TBisDataEditFormIfaceClass;
  public
    property InsertClass: TBisDataEditFormIfaceClass read FInsertClass write FInsertClass;
  end;

  TBisDataFrameReportMenuItem=class(TMenuItem)
  private
    FReportClass: TBisReportFormIfaceClass;
  public
    property ReportClass: TBisReportFormIfaceClass read FReportClass write FReportClass;
  end;
  
  TBisDataFrameFilterMenuItem=class(TMenuItem)
  private
    FFilterGroups: TBisFilterGroups;
    FCaption: String;
    FCanDelete: Boolean;
    FRequestLargeData: Boolean;
    procedure SetCaption(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Caption: String read FCaption write SetCaption;
    property FilterGroups: TBisFilterGroups read FFilterGroups;
    property CanDelete: Boolean read FCanDelete write FCanDelete;
    property RequestLargeData: Boolean read FRequestLargeData write FRequestLargeData;
  end;

  TBisDataFrameIfaces=class(TObjectList)
  private
    function GetFormCount: Integer;
  public
    function FindByClass(AClass: TBisDataEditFormIfaceClass; Mode: TBisDataEditMode): TBisDataEditFormIface; overload;
    function FindByClass(AClass: TBisReportFormIfaceClass): TBisReportFormIface; overload;

    property FormCount: Integer read GetFormCount;
  end;

  TBisDataFrameState=(dfsRefreshRecords);
  TBisDataFrameStates=set of TBisDataFrameState;

  TBisDataFrame = class(TBisFrame)
    PanelData: TPanel;
    DataSource: TDataSource;
    ActionList: TActionList;
    ActionRefresh: TAction;
    ActionFilter: TAction;
    ActionView: TAction;
    ActionInsert: TAction;
    ActionDuplicate: TAction;
    ActionUpdate: TAction;
    ActionDelete: TAction;
    ActionFirst: TAction;
    ActionPrior: TAction;
    ActionNext: TAction;
    ActionLast: TAction;
    ImageList: TImageList;
    Popup: TPopupActionBar;
    MenuItemRefresh: TMenuItem;
    MenuItemFilter: TMenuItem;
    MenuItemView: TMenuItem;
    N3: TMenuItem;
    MenuItemInsert: TMenuItem;
    MenuItemDuplicate: TMenuItem;
    MenuItemUpdate: TMenuItem;
    MenuItemDelete: TMenuItem;
    N8: TMenuItem;
    MenuItemFirst: TMenuItem;
    MenuItemPrior: TMenuItem;
    MenuItemNext: TMenuItem;
    MenuItemLast: TMenuItem;
    ControlBar: TControlBar;
    ToolBarEdit: TToolBar;
    ToolButtonInsert: TToolButton;
    ToolButtonDuplicate: TToolButton;
    ToolButtonUpdate: TToolButton;
    ToolButtonDelete: TToolButton;
    ToolBarRefresh: TToolBar;
    ToolButtonRefresh: TToolButton;
    ToolButtonFilter: TToolButton;
    ToolButtonView: TToolButton;
    ToolBarNavigate: TToolBar;
    ToolButtonFirst: TToolButton;
    ToolButtonPrior: TToolButton;
    ToolButtonNext: TToolButton;
    ToolButtonLast: TToolButton;
    PopupFilter: TPopupActionBar;
    PopupInsert: TPopupActionBar;
    MenuItemFilterClear: TMenuItem;
    MenuItemFilterDeleteAll: TMenuItem;
    N14: TMenuItem;
    LabelCounter: TLabel;
    ToolButtonReport: TToolButton;
    ActionReport: TAction;
    MenuItemReport: TMenuItem;
    ActionInfo: TAction;
    PopupReport: TPopupActionBar;
    PopupRefresh: TPopupActionBar;
    MenuItemRefreshEvent: TMenuItem;
    procedure ActionRefreshExecute(Sender: TObject);
    procedure ActionRefreshUpdate(Sender: TObject);
    procedure ActionInsertExecute(Sender: TObject);
    procedure ActionInsertUpdate(Sender: TObject);
    procedure ActionUpdateExecute(Sender: TObject);
    procedure ActionUpdateUpdate(Sender: TObject);
    procedure ActionDuplicateExecute(Sender: TObject);
    procedure ActionDuplicateUpdate(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure ActionDeleteUpdate(Sender: TObject);
    procedure ActionViewExecute(Sender: TObject);
    procedure ActionViewUpdate(Sender: TObject);
    procedure ActionFirstExecute(Sender: TObject);
    procedure ActionFirstUpdate(Sender: TObject);
    procedure ActionPriorExecute(Sender: TObject);
    procedure ActionPriorUpdate(Sender: TObject);
    procedure ActionNextExecute(Sender: TObject);
    procedure ActionNextUpdate(Sender: TObject);
    procedure ActionLastExecute(Sender: TObject);
    procedure ActionLastUpdate(Sender: TObject);
    procedure ActionFilterExecute(Sender: TObject);
    procedure ActionFilterUpdate(Sender: TObject);
    procedure PopupFilterPopup(Sender: TObject);
    procedure MenuItemFilterClearClick(Sender: TObject);
    procedure MenuItemFilterDeleteAllClick(Sender: TObject);
    procedure ActionReportExecute(Sender: TObject);
    procedure ActionReportUpdate(Sender: TObject);
    procedure ActionInfoExecute(Sender: TObject);
    procedure ActionInfoUpdate(Sender: TObject);
    procedure MenuItemRefreshEventClick(Sender: TObject);
  private
    FProvider: TBisProvider;
    FEventRefresh: TBisEvent;
    FIfaces: TBisDataFrameIfaces;
    FUpdateList: TList;
    FStates: TBisDataFrameStates;

    FOnCanRefreshRecords: TBisDataFrameCanEvent;
    FOnUpdateCounters: TBisDataFrameEvent;
    FOnAfterOpenRecords: TBisDataFrameEvent;
    FOnAfterInsertRecord: TBisDataFrameEvent;

    FOnCanInsertRecord: TBisDataFrameCanEvent;
    FOnCanDuplicateRecord: TBisDataFrameCanEvent;
    FOnCanUpdateRecord: TBisDataFrameCanEvent;
    FOnCanDeleteRecord: TBisDataFrameCanEvent;
    FOnCanFilterRecords: TBisDataFrameCanEvent;
    FOnCanViewRecord: TBisDataFrameCanEvent;
    FOnCanInfoRecord: TBisDataFrameCanEvent;
    FOnCanReportRecords: TBisDataFrameCanEvent;

    FReportClasses: TBisReportFormIfaceClasses;
    FInsertClasses: TBisDataEditFormIfaceClasses;
    FDuplicateClass: TBisDataEditFormIfaceClass;
    FUpdateClass: TBisDataEditFormIfaceClass;
    FDeleteClass: TBisDataEditFormIfaceClass;
    FFilterClass: TBisDataEditFormIfaceClass;
    FViewClass: TBisDataEditFormIfaceClass;
    FReportClass: TBisDataEditFormIfaceClass;

    FAsModal: Boolean;
    FShowType: TBisFormShowType;
    FLastFiltered: Boolean;
    FSLabelCounter: String;
    FOnAfterUpdateRecord: TBisDataFrameEvent;
    FOnAfterDeleteRecord: TBisDataFrameEvent;
    FOnAfterFilterRecords: TBisDataFrameEvent;
    FOnSynchronize: TBisDataFrameEvent;
    FOnAfterDuplicateRecord: TBisDataFrameEvent;
    FSLargeData: String;
    FRequestLargeData: Boolean;
    FDefaultEventRefreshName: String;
    FOnBeforeOpenRecords: TBisDataFrameEvent;
    FLocateFields: String;
    FLocateValues: Variant;
    FReadyForResize: Boolean;

    function GetInsertClass: TBisDataEditFormIfaceClass;
    procedure SetInsertClass(const Value: TBisDataEditFormIfaceClass);
    procedure FillInsertMenus(Items: TMenuItem);
    procedure FillReportMenus(Items: TMenuItem);
    function GetDefaultInsertClass: TBisDataEditFormIfaceClass;
    function GetDefaultReportClass: TBisReportFormIfaceClass;
    procedure MenuInsertClick(Sender: TObject);
    procedure MenuReportClick(Sender: TObject);
    procedure ProviderUpdateCounters(Sender: TObject);
    procedure ProviderSynchronize(Sender: TObject);
    procedure ProviderAfterDelete(DataSet: TDataSet);
    procedure ProviderThreadBegin(Sender: TObject);
    procedure ProviderThreadEnd(Sender: TObject);
    function CheckLargeData(Request: Boolean): Boolean;
    function EventHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function GetEventRefreshName: String;
    procedure SetEventRefreshName(const Value: String);
  protected

    procedure SetCaption(const Value: String); override;

    procedure Update; reintroduce; virtual;

    procedure DoUpdateCounters; virtual;
    procedure DoSynchronize; virtual;
//    procedure DoEventRefresh; virtual;

    procedure FilterRecordsAfterExecute(AForm: TBisDataEditForm); virtual;
    procedure InsertRecordAfterExecute(AForm: TBisDataEditForm); virtual;
    procedure DuplicateRecordAfterExecute(AForm: TBisDataEditForm); virtual;
    procedure UpdateRecordAfterExecute(AForm: TBisDataEditForm); virtual;
    procedure DeleteRecordAfterExecute(AForm: TBisDataEditForm); virtual;

    procedure DoBeforeOpenRecords; virtual;
    procedure DoAfterOpenRecords; virtual;
    procedure DoAfterInsertRecord; virtual;
    procedure DoAfterDuplicateRecord; virtual;
    procedure DoAfterUpdateRecord; virtual;
    procedure DoAfterDeleteRecord; virtual;
    procedure DoAfterFilterRecords; virtual;

    function GetCurrentProvider: TBisProvider; virtual;
    function GetCurrentControl: TWinControl; virtual;
    function GetCurrentInsertClass: TBisDataEditFormIfaceClass; virtual;
    function GetCurrentDuplicateClass: TBisDataEditFormIfaceClass; virtual;
    function GetCurrentUpdateClass: TBisDataEditFormIfaceClass; virtual;
    function GetCurrentDeleteClass: TBisDataEditFormIfaceClass; virtual;
    function GetCurrentFilterClass: TBisDataEditFormIfaceClass; virtual;
    function GetCurrentViewClass: TBisDataEditFormIfaceClass; virtual;
    function GetCurrentReportClass: TBisReportFormIfaceClass; virtual;
    function GetCountString: String; virtual;
    function GetReportPattern: TComponent; virtual;
    function GetMultiSelect: Boolean; virtual;
    procedure SetMultiSelect(const Value: Boolean); virtual;
    function CreateIface(AClass: TBisDataEditFormIfaceClass): TBisDataEditFormIface; overload; virtual;
    function CreateIface(AClass: TBisReportFormIfaceClass): TBisReportFormIface; overload; virtual;
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); overload; virtual;
    procedure BeforeIfaceExecute(AIface: TBisReportFormIface); overload; virtual;
    function GetSelectedFieldName: TBisFieldName; virtual;
    procedure PrepareFilterGroups(AFilterGroups: TBisFilterGroups); virtual;
    function GetDefaultFilterGroups: TBisFilterGroups; virtual;
    procedure EnableUpdateActions(AEnabled: Boolean); virtual;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Resize; override;
    procedure Init; override;
    procedure BeforeShow; override;
    procedure EnableControls(AEnabled: Boolean); override;
    function CanRefreshRecords: Boolean; virtual;
    procedure OpenRecords; virtual;
    procedure RefreshRecords; virtual;
    function CanInsertRecord: Boolean; virtual;
    procedure InsertRecord; virtual;
    function CanDuplicateRecord: Boolean; virtual;
    procedure DuplicateRecord; virtual;
    function CanUpdateRecord: Boolean; virtual;
    procedure UpdateRecord; virtual;
    function CanDeleteRecord: Boolean; virtual;
    procedure DeleteRecord; virtual;
    function CanFilterRecords: Boolean; virtual;
    procedure FilterRecords; virtual;
    function CanViewRecord: Boolean; virtual;
    procedure ViewRecord; virtual;
    function CanInfoRecord: Boolean; virtual;
    procedure InfoRecord; virtual;
    function CanFirstRecord: Boolean; virtual;
    procedure FirstRecord; virtual;
    function CanPriorRecord: Boolean; virtual;
    procedure PriorRecord; virtual;
    function CanNextRecord: Boolean; virtual;
    procedure NextRecord; virtual;
    function CanLastRecord: Boolean; virtual;
    procedure LastRecord; virtual;
    function CanSelect: Boolean; virtual;
    function LocateRecord(Fields: String; Values: Variant): Boolean; virtual;
    function SelectInto(DataSet: TBisDataSet): Boolean; virtual;
    function CanReportRecords: Boolean; virtual;
    procedure ReportRecords; virtual;
    function CanClose: Boolean; virtual;
    function CanRefreshByEvent: Boolean; virtual;
    procedure RefreshByEvent; virtual;

    procedure ResizeToolbar(Toolbar: TToolbar); virtual;
    procedure ResizeToolbars; virtual;

    procedure RepositionControlBarControls;
    procedure MenuFilterClick(Sender: TObject);
    function CreateFilterMenuItem(ACaption: String): TBisDataFrameFilterMenuItem;

    property Provider: TBisProvider read FProvider;
    property CurrentProvider: TBisProvider read GetCurrentProvider;
    property CurrentControl: TWinControl read GetCurrentControl;
    property SelectedFieldName: TBisFieldName read GetSelectedFieldName;
    property Ifaces: TBisDataFrameIfaces read FIfaces;

    property ReportClasses: TBisReportFormIfaceClasses read FReportClasses;
    property InsertClass: TBisDataEditFormIfaceClass read GetInsertClass write SetInsertClass;
    property InsertClasses: TBisDataEditFormIfaceClasses read FInsertClasses;
    property DuplicateClass: TBisDataEditFormIfaceClass read FDuplicateClass write FDuplicateClass;
    property UpdateClass: TBisDataEditFormIfaceClass read FUpdateClass write FUpdateClass;
    property DeleteClass: TBisDataEditFormIfaceClass read FDeleteClass write FDeleteClass;
    property FilterClass: TBisDataEditFormIfaceClass read FFilterClass write FFilterClass;
    property ViewClass: TBisDataEditFormIfaceClass read FViewClass write FViewClass;
    property ReportClass: TBisDataEditFormIfaceClass read FReportClass write FReportClass;

    property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
    property AsModal: Boolean read FAsModal write FAsModal;
    property ShowType: TBisFormShowType read FShowType write FShowType;
    property LastFiltered: Boolean read FLastFiltered write FLastFiltered;
    property RequestLargeData: Boolean read FRequestLargeData write FRequestLargeData;
    property EventRefreshName: String read GetEventRefreshName write SetEventRefreshName;

    property OnCanRefreshRecords: TBisDataFrameCanEvent read FOnCanRefreshRecords write FOnCanRefreshRecords;
    property OnCanInsertRecord: TBisDataFrameCanEvent read FOnCanInsertRecord write FOnCanInsertRecord;
    property OnCanDuplicateRecord: TBisDataFrameCanEvent read FOnCanDuplicateRecord write FOnCanDuplicateRecord;
    property OnCanUpdateRecord: TBisDataFrameCanEvent read FOnCanUpdateRecord write FOnCanUpdateRecord;
    property OnCanDeleteRecord: TBisDataFrameCanEvent read FOnCanDeleteRecord write FOnCanDeleteRecord;
    property OnCanViewRecord: TBisDataFrameCanEvent read FOnCanViewRecord write FOnCanViewRecord;
    property OnCanFilterRecords: TBisDataFrameCanEvent read FOnCanFilterRecords write FOnCanFilterRecords;
    property OnCanInfoRecord: TBisDataFrameCanEvent read FOnCanInfoRecord write FOnCanInfoRecord;
    property OnCanReportRecords: TBisDataFrameCanEvent read FOnCanReportRecords write FOnCanReportRecords;

    property OnUpdateCounters: TBisDataFrameEvent read FOnUpdateCounters write FOnUpdateCounters;
    property OnSynchronize: TBisDataFrameEvent read FOnSynchronize write FOnSynchronize;

    property OnBeforeOpenRecords: TBisDataFrameEvent read FOnBeforeOpenRecords write FOnBeforeOpenRecords; 
    property OnAfterOpenRecords: TBisDataFrameEvent read FOnAfterOpenRecords write FOnAfterOpenRecords;
    property OnAfterInsertRecord: TBisDataFrameEvent read FOnAfterInsertRecord write FOnAfterInsertRecord;
    property OnAfterDuplicateRecord: TBisDataFrameEvent read FOnAfterDuplicateRecord write FOnAfterDuplicateRecord;
    property OnAfterUpdateRecord: TBisDataFrameEvent read FOnAfterUpdateRecord write FOnAfterUpdateRecord;
    property OnAfterDeleteRecord: TBisDataFrameEvent read FOnAfterDeleteRecord write FOnAfterDeleteRecord;
    property OnAfterFilterRecords: TBisDataFrameEvent read FOnAfterFilterRecords write FOnAfterFilterRecords;
  published
    property SLabelCounter: String read FSLabelCounter write FSLabelCounter;
    property SLargeData: String read FSLargeData write FSLargeData;
  end;

  TBisDataFrameClass=class of TBisDataFrame;

implementation

{$R *.dfm}

uses BisUtils, BisCore, BisDialogs, BisConsts, BisParam,
     BisMemoFm, BisReportModules, BisCoreUtils;

{ TBisDataFrameFilterMenuItem }

constructor TBisDataFrameFilterMenuItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanDelete:=true;
  FRequestLargeData:=false;
  FFilterGroups:=TBisFilterGroups.Create;
end;

destructor TBisDataFrameFilterMenuItem.Destroy;
begin
  FFilterGroups.Free;
  inherited Destroy;
end;

procedure TBisDataFrameFilterMenuItem.SetCaption(const Value: String);
var
  S: String;
  NCount: Integer;
begin
  FCaption:=Value;
  S:=Value;
  NCount:=Round(Screen.Width*200/1280);
  if Length(FCaption)>NCount then
    S:=Copy(FCaption,1,NCount)+' ...';
  inherited Caption:=S;
end;

{ TBisDataFrameIfaces }

function TBisDataFrameIfaces.FindByClass(AClass: TBisDataEditFormIfaceClass; Mode: TBisDataEditMode): TBisDataEditFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisDataEditFormIface) and (Obj.ClassType=AClass) then begin
      if TBisDataEditFormIface(Obj).Mode=Mode then begin
        Result:=TBisDataEditFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

function TBisDataFrameIfaces.FindByClass(AClass: TBisReportFormIfaceClass): TBisReportFormIface; 
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisReportFormIface) and (Obj.ClassType=AClass) then begin
      Result:=TBisReportFormIface(Obj);
      exit;
    end;
  end;
end;

function TBisDataFrameIfaces.GetFormCount: Integer;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=0;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisFormIface) then begin
      Result:=Result+TBisFormIface(Obj).Forms.Count;
    end;
  end;
end;

{ TBisDataFrame }

constructor TBisDataFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Font.Name:=STahoma;
  TranslateClass:=TBisDataFrame;

  FProvider:=TBisProvider.Create(Self);
  FProvider.Threaded:=true;
  FProvider.UseShowWait:=true;
  FProvider.WaitInterval:=250;
  FProvider.WaitTimeout:=10;
  FProvider.WaitAsModal:=true;
  FProvider.UseWaitCursor:=false;
  FProvider.OnUpdateCounters:=ProviderUpdateCounters;
  FProvider.OnSynchronize:=ProviderSynchronize;
  FProvider.OnThreadBegin:=ProviderThreadBegin;
  FProvider.OnThreadEnd:=ProviderThreadEnd;
  FProvider.AfterDelete:=ProviderAfterDelete;

  DataSource.DataSet:=FProvider;

  FDefaultEventRefreshName:=GetUniqueID;
  FEventRefresh:=Core.Events.Add(FDefaultEventRefreshName,EventHandler,false);
  FEventRefresh.Enabled:=true;
  FEventRefresh.Threaded:=false;

  FIfaces:=TBisDataFrameIfaces.Create;
  FUpdateList:=TList.Create;

  FReportClasses:=TBisReportFormIfaceClasses.Create;
  FInsertClasses:=TBisDataEditFormIfaceClasses.Create;

  FLocateFields:='';
  FLocateValues:=Null;

  FSLabelCounter:='�����: %s';
  FSLargeData:='������ ����� ���� ������� �����. ����������?';

end;

destructor TBisDataFrame.Destroy;
begin
  FInsertClasses.Free;
  FReportClasses.Free;
  FUpdateList.Free;
  FIfaces.Free;
  Core.Events.Remove(FEventRefresh);
  DataSource.DataSet:=nil;
  FProvider.Free;
  inherited Destroy;
end;

procedure TBisDataFrame.Init;
begin
  inherited Init;

  TranslateFieldNames(FProvider.FieldNames,ClassType);
  TranslateFilterGroups(FProvider.FilterGroups,ClassType);

end;

procedure TBisDataFrame.BeforeShow;

  procedure FillReportClasses;
  var
    i: Integer;
    Module: TBisReportModule;
  begin
    for i:=0 to Core.ReportModules.Count-1 do begin
      Module:=Core.ReportModules.Items[i];
      if Module.Enabled and Assigned(Module.ReportClass) then begin
        if FReportClasses.IndexOf(Module.ReportClass)=-1 then
          FReportClasses.Add(Module.ReportClass);
      end;
    end;
  end;

var
  OldPopupMenu: TPopupMenu;
  OldStyle: TToolButtonStyle;
begin
  inherited BeforeShow;

  FillReportClasses;
  
  FillReportMenus(PopupReport.Items);

  if FReportClasses.Count>1 then begin
    MenuItemReport.Clear;
    MenuItemReport.Action:=nil;
    MenuItemReport.OnClick:=nil;
    MenuItemReport.ShortCut:=0;
    MenuItemReport.Enabled:=CanReportRecords;
    FillReportMenus(MenuItemReport);
  end else begin
    MenuItemReport.Clear;
    MenuItemReport.Action:=ActionReport;
  end;
  
  FillInsertMenus(PopupInsert.Items);

  if FInsertClasses.Count>1 then begin
    MenuItemInsert.Clear;
    MenuItemInsert.Action:=nil;
    MenuItemInsert.OnClick:=nil;
    MenuItemInsert.ShortCut:=0;
    MenuItemInsert.Enabled:=CanInsertRecord;
    FillInsertMenus(MenuItemInsert);
  end else begin
    MenuItemInsert.Clear;
    MenuItemInsert.Action:=ActionInsert;
  end;

  if not Assigned(FDuplicateClass) then
    FDuplicateClass:=FInsertClasses.FirstItem;

  OldPopupMenu:=ToolButtonReport.DropdownMenu;
  OldStyle:=ToolButtonReport.Style;
  ToolButtonReport.DropdownMenu:=nil;
  ToolButtonReport.Style:=tbsButton;
  if (OldStyle=tbsDropDown) then begin
    if FReportClasses.Count>1 then begin
      ToolButtonReport.Style:=tbsDropDown;
      ToolButtonReport.DropdownMenu:=OldPopupMenu;
    end;
  end else begin
    ToolButtonReport.Style:=OldStyle;
  end;

  OldPopupMenu:=ToolButtonInsert.DropdownMenu;
  OldStyle:=ToolButtonInsert.Style;
  ToolButtonInsert.DropdownMenu:=nil;
  ToolButtonInsert.Style:=tbsButton;
  if (OldStyle=tbsDropDown) then begin
    if (FInsertClasses.Count>1) then begin
      ToolButtonInsert.Style:=tbsDropDown;
      ToolButtonInsert.DropdownMenu:=OldPopupMenu;
    end;
  end else begin
    ToolButtonInsert.Style:=OldStyle;
  end;

  ResizeToolbars;
  RepositionControlBarControls;

  FReadyForResize:=true;
end;

function TBisDataFrame.CheckLargeData(Request: Boolean): Boolean;
begin
  Result:=true;
  if Request then begin
    Result:=ShowWarningQuestion(FSLargeData,mbNo)=mrYes;
    Update;
  end;
end;

procedure TBisDataFrame.ProviderAfterDelete(DataSet: TDataSet);
begin
  DoUpdateCounters;
end;

procedure TBisDataFrame.ProviderSynchronize(Sender: TObject);
begin
  DoSynchronize;
end;

procedure TBisDataFrame.ProviderUpdateCounters(Sender: TObject);
begin
  DoUpdateCounters;
end;

function TBisDataFrame.GetCurrentControl: TWinControl;
begin
  Result:=nil;
end;

function TBisDataFrame.GetCurrentProvider: TBisProvider;
begin
  Result:=FProvider;
end;

function TBisDataFrame.GetCurrentReportClass: TBisReportFormIfaceClass;
begin
  Result:=GetDefaultReportClass;
end;

function TBisDataFrame.GetCurrentInsertClass: TBisDataEditFormIfaceClass;
begin
  Result:=GetDefaultInsertClass;
end;

function TBisDataFrame.GetCurrentDuplicateClass: TBisDataEditFormIfaceClass;
begin
  Result:=FDuplicateClass;
end;

function TBisDataFrame.GetCurrentUpdateClass: TBisDataEditFormIfaceClass;
begin
  Result:=FUpdateClass;
end;

function TBisDataFrame.GetCurrentDeleteClass: TBisDataEditFormIfaceClass;
begin
  Result:=FDeleteClass;
end;

function TBisDataFrame.GetCurrentFilterClass: TBisDataEditFormIfaceClass;
begin
  Result:=FFilterClass;
end;

function TBisDataFrame.GetCurrentViewClass: TBisDataEditFormIfaceClass;
begin
  Result:=FViewClass;
end;

procedure TBisDataFrame.Resize;
begin
  inherited Resize;
  if FReadyForResize then begin
    ResizeToolbars;
    RepositionControlBarControls;
  end;
end;

procedure TBisDataFrame.ResizeToolbar(Toolbar: TToolbar);
var
  i: Integer;
  Button: TToolButton;
  x: Integer;
begin
  if Assigned(Toolbar) then begin
    if not Toolbar.HandleAllocated then
      Toolbar.HandleNeeded;
    x:=0;
    for i:=0 to Toolbar.ButtonCount-1 do begin
      Button:=Toolbar.Buttons[i];
      if Button.Visible then
        x:=x+Button.Width;
    end;
    Toolbar.Visible:=x>0;
    if Toolbar.Visible then begin
      Toolbar.Width:=x+3;
      Toolbar.Width:=Toolbar.Width;
    end;
  end;
end;

procedure TBisDataFrame.ResizeToolbars;
begin
  ResizeToolbar(ToolBarRefresh);
  ResizeToolbar(ToolBarEdit);
  ResizeToolbar(ToolBarNavigate);
end;

procedure TBisDataFrame.RepositionControlBarControls;

  procedure GetOrderedList(AControl: TWinControl; List: TList);
  var
    i,j: Integer;
    Control: TControl;
    Index: Integer;
  begin
    for i:=0 to AControl.Width do begin
      for j:=0 to AControl.ControlCount-1 do begin
        Control:=AControl.Controls[j];
        if (Control.Left<=i) then begin
          Index:=List.IndexOf(Control);
          if (Index=-1) then
            List.Add(Control);
        end;
      end;
    end;
  end;

var
  i: Integer;
  Control: TControl;
  x: Integer;
  List: TList;
begin
  x:=0;
  List:=TList.Create;
  try
    GetOrderedList(ControlBar,List);
    for i:=0 to List.Count-1 do begin
      Control:=TControl(List.Items[i]);
      if Control.Visible then begin
        Control.Top:=0;
        Control.Left:=x;
        x:=x+Control.Width+1;
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TBisDataFrame.ActionDeleteExecute(Sender: TObject);
begin
  DeleteRecord;
end;

procedure TBisDataFrame.ActionDeleteUpdate(Sender: TObject);
begin
  ActionDelete.Enabled:=CanDeleteRecord and ActionDelete.Visible and ToolBarEdit.Enabled;
end;

procedure TBisDataFrame.ActionDuplicateExecute(Sender: TObject);
begin
  DuplicateRecord;
end;

procedure TBisDataFrame.ActionDuplicateUpdate(Sender: TObject);
begin
  ActionDuplicate.Enabled:=CanDuplicateRecord and ActionDuplicate.Visible and ToolBarEdit.Enabled;
end;

procedure TBisDataFrame.ActionReportExecute(Sender: TObject);
begin
  ReportRecords;
end;

procedure TBisDataFrame.ActionReportUpdate(Sender: TObject);
begin
  ActionReport.Enabled:=CanReportRecords and ActionReport.Visible and ToolBarRefresh.Enabled;
end;

procedure TBisDataFrame.ActionFilterExecute(Sender: TObject);
begin
  FilterRecords;
end;

procedure TBisDataFrame.ActionFilterUpdate(Sender: TObject);
begin
  ActionFilter.Enabled:=CanFilterRecords and ActionFilter.Visible and ToolBarRefresh.Enabled;
end;

procedure TBisDataFrame.ActionFirstExecute(Sender: TObject);
begin
  FirstRecord;
end;

procedure TBisDataFrame.ActionFirstUpdate(Sender: TObject);
begin
  ActionFirst.Enabled:=CanFirstRecord and ActionFirst.Visible and ToolBarNavigate.Enabled;
end;

procedure TBisDataFrame.ActionInfoExecute(Sender: TObject);
begin
  InfoRecord;
end;

procedure TBisDataFrame.ActionInfoUpdate(Sender: TObject);
begin
  ActionInfo.Enabled:=CanInfoRecord;
end;

procedure TBisDataFrame.ActionInsertExecute(Sender: TObject);
begin
  InsertRecord;
end;

procedure TBisDataFrame.ActionInsertUpdate(Sender: TObject);
begin
  ActionInsert.Enabled:=CanInsertRecord and ActionInsert.Visible and ToolBarEdit.Enabled;
end;

procedure TBisDataFrame.ActionLastExecute(Sender: TObject);
begin
  LastRecord;
end;

procedure TBisDataFrame.ActionLastUpdate(Sender: TObject);
begin
  ActionLast.Enabled:=CanLastRecord and ActionLast.Visible and ToolBarNavigate.Enabled;
end;

procedure TBisDataFrame.ActionNextExecute(Sender: TObject);
begin
  NextRecord;
end;

procedure TBisDataFrame.ActionNextUpdate(Sender: TObject);
begin
  ActionNext.Enabled:=CanNextRecord and ActionNext.Visible and ToolBarNavigate.Enabled;
end;

procedure TBisDataFrame.ActionPriorExecute(Sender: TObject);
begin
  PriorRecord;
end;

procedure TBisDataFrame.ActionPriorUpdate(Sender: TObject);
begin
  ActionPrior.Enabled:=CanPriorRecord and ActionPrior.Visible and ToolBarNavigate.Enabled;
end;

procedure TBisDataFrame.ActionRefreshExecute(Sender: TObject);
begin
  RefreshRecords;
end;

procedure TBisDataFrame.ActionRefreshUpdate(Sender: TObject);
begin
  ActionRefresh.Enabled:=CanRefreshRecords and ActionRefresh.Visible and ToolBarRefresh.Enabled;
end;

procedure TBisDataFrame.ActionUpdateExecute(Sender: TObject);
begin
  UpdateRecord;
end;

procedure TBisDataFrame.ActionUpdateUpdate(Sender: TObject);
begin
  ActionUpdate.Enabled:=CanUpdateRecord and ActionUpdate.Visible and ToolBarEdit.Enabled;
end;

procedure TBisDataFrame.ActionViewExecute(Sender: TObject);
begin
  ViewRecord;
end;

procedure TBisDataFrame.ActionViewUpdate(Sender: TObject);
begin
  ActionView.Enabled:=CanViewRecord and ActionView.Visible and ToolBarRefresh.Enabled;
end;

function TBisDataFrame.CanRefreshRecords: Boolean;
var
  DS: TBisProvider;
begin
  DS:=GetCurrentProvider;
  Result:=Assigned(DS) and ((DS.FieldNames.Count>0) or (DS.Fields.Count>0) or (DS.FieldDefs.Count>0)) and
          not (dfsRefreshRecords in FStates);
  if Result and Assigned(FOnCanRefreshRecords) then
    Result:=FOnCanRefreshRecords(Self);
end;

procedure TBisDataFrame.DoBeforeOpenRecords;
begin
  if Assigned(FOnBeforeOpenRecords) then
    FOnBeforeOpenRecords(Self);
end;

procedure TBisDataFrame.DoAfterOpenRecords;
begin
  if Assigned(FOnAfterOpenRecords) then
    FOnAfterOpenRecords(Self);
end;

procedure TBisDataFrame.DoAfterInsertRecord;
begin
  if Assigned(FOnAfterInsertRecord) then
    FOnAfterInsertRecord(Self);
end;

procedure TBisDataFrame.DoAfterUpdateRecord;
begin
  if Assigned(FOnAfterUpdateRecord) then
    FOnAfterUpdateRecord(Self);
end;

procedure TBisDataFrame.DoSynchronize;
begin
  if Assigned(FOnSynchronize) then
    FOnSynchronize(Self);
end;

procedure TBisDataFrame.DoAfterDeleteRecord;
begin
  if Assigned(FOnAfterDeleteRecord) then
    FOnAfterDeleteRecord(Self);
end;

procedure TBisDataFrame.DoAfterDuplicateRecord;
begin
  if Assigned(FOnAfterDuplicateRecord) then
    FOnAfterDuplicateRecord(Self);
end;

procedure TBisDataFrame.DoAfterFilterRecords;
begin
  if Assigned(FOnAfterFilterRecords) then
    FOnAfterFilterRecords(Self);
end;

function TBisDataFrame.GetCountString: String;
begin
  Result:=IntToStr(0);
  if Provider.Active then
    Result:=IntToStr(Provider.RecordCount);
end;

procedure TBisDataFrame.DoUpdateCounters;
begin
  LabelCounter.Caption:=FormatEx(FSLabelCounter,[GetCountString]);
  if Assigned(FOnUpdateCounters) then
    FOnUpdateCounters(Self);
  LabelCounter.Width:=LabelCounter.Canvas.TextWidth(LabelCounter.Caption)+5;
end;

procedure TBisDataFrame.Update;
var
  i: Integer;
begin
  inherited Update;
  for i:=0 to FUpdateList.Count-1 do begin
    TControl(FUpdateList[i]).Update;
  end;
end;

procedure TBisDataFrame.ProviderThreadBegin(Sender: TObject);
begin
  Update;
end;

procedure TBisDataFrame.ProviderThreadEnd(Sender: TObject);
begin
  Update;
  try
    DoAfterOpenRecords;
  finally
    if Trim(FLocateFields)<>'' then begin
      if FProvider.Active and not FProvider.Empty then
        FProvider.Locate(FLocateFields,FLocateValues,[loCaseInsensitive,loPartialKey]);
      FLocateFields:='';
      FLocateValues:=Null;
    end;
    EnableUpdateActions(true);
    FProvider.EnableControls;
    DoUpdateCounters;
    Exclude(FStates,dfsRefreshRecords);
  end;
end;

procedure TBisDataFrame.EnableUpdateActions(AEnabled: Boolean);
begin
  if not AEnabled then begin
    ActionRefresh.OnUpdate:=nil;
    ActionFilter.OnUpdate:=nil;
    ActionView.OnUpdate:=nil;
    ActionInsert.OnUpdate:=nil;
    ActionDuplicate.OnUpdate:=nil;
    ActionUpdate.OnUpdate:=nil;
    ActionDelete.OnUpdate:=nil;
    ActionFirst.OnUpdate:=nil;
    ActionPrior.OnUpdate:=nil;
    ActionNext.OnUpdate:=nil;
    ActionLast.OnUpdate:=nil;
    ActionReport.OnUpdate:=nil;
    ActionInfo.OnUpdate:=nil;
  end else begin
    ActionRefresh.OnUpdate:=ActionRefreshUpdate;
    ActionFilter.OnUpdate:=ActionFilterUpdate;
    ActionView.OnUpdate:=ActionViewUpdate;
    ActionInsert.OnUpdate:=ActionInsertUpdate;
    ActionDuplicate.OnUpdate:=ActionDuplicateUpdate;
    ActionUpdate.OnUpdate:=ActionUpdateUpdate;
    ActionDelete.OnUpdate:=ActionDeleteUpdate;
    ActionFirst.OnUpdate:=ActionFirstUpdate;
    ActionPrior.OnUpdate:=ActionPriorUpdate;
    ActionNext.OnUpdate:=ActionNextUpdate;
    ActionLast.OnUpdate:=ActionLastUpdate;
    ActionReport.OnUpdate:=ActionReportUpdate;
    ActionInfo.OnUpdate:=ActionInfoUpdate;
  end;
end;

procedure TBisDataFrame.OpenRecords;
var
  FilterGroups: TBisFilterGroups;
begin
  EnableUpdateActions(false);

  FProvider.DisableControls;

  Update;

  DoBeforeOpenRecords;

  Update;

  if FProvider.Active then begin

    FLocateFields:='';
    FLocateValues:=Null;
    FProvider.GetKeyFieldsValues(FLocateFields,FLocateValues);

  end;

  FProvider.Close;

  FilterGroups:=GetDefaultFilterGroups;
  if Assigned(FilterGroups) then begin
    PrepareFilterGroups(FilterGroups);
    FProvider.FilterGroups.DeleteVisible;
    FProvider.FilterGroups.CopyFrom(FilterGroups,false);
  end else
    PrepareFilterGroups(FProvider.FilterGroups);

  Update;

  FProvider.Open;

  if not FProvider.Threaded or (FProvider.Threaded and not FProvider.Working) then
    ProviderThreadEnd(nil);
end;

procedure TBisDataFrame.RefreshRecords;
begin
  if CanRefreshRecords then begin
    Include(FStates,dfsRefreshRecords);
    OpenRecords;
  end;
end;

function TBisDataFrame.GetInsertClass: TBisDataEditFormIfaceClass;
begin
  Result:=FInsertClasses.FirstItem;
end;

procedure TBisDataFrame.SetCaption(const Value: String);
begin
  inherited SetCaption(Value);
  FProvider.WaitStatus:=Value;
end;

procedure TBisDataFrame.SetEventRefreshName(const Value: String);
begin
  FEventRefresh.Name:=Value;
end;

procedure TBisDataFrame.SetInsertClass(const Value: TBisDataEditFormIfaceClass);
begin
  FInsertClasses.Clear;
  FInsertClasses.Add(Value);
end;

function TBisDataFrame.GetMultiSelect: Boolean;
begin
  Result:=False;
end;

function TBisDataFrame.GetReportPattern: TComponent;
begin
  Result:=nil;
end;

function TBisDataFrame.GetSelectedFieldName: TBisFieldName;
begin
  Result:=nil;
end;

procedure TBisDataFrame.SetMultiSelect(const Value: Boolean);
begin
end;

function TBisDataFrame.CreateIface(AClass: TBisDataEditFormIfaceClass): TBisDataEditFormIface;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    Result:=AClass.Create(Self);
    Result.Permissions.Enabled:=false;
  end;
end;

function TBisDataFrame.CreateIface(AClass: TBisReportFormIfaceClass): TBisReportFormIface;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    Result:=AClass.Create(Self);
    Result.Permissions.Enabled:=false;
  end;
end;

procedure TBisDataFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
begin
end;

procedure TBisDataFrame.MenuInsertClick(Sender: TObject);
var
  MenuItem: TBisDataFrameInsertMenuItem;
begin
  MenuItem:=TBisDataFrameInsertMenuItem(Sender);
  MenuItem.Checked:=true;
  if MenuItem.Parent<>PopupInsert.Items then begin
    PopupInsert.Items[MenuItem.MenuIndex].Checked:=true;
  end else begin
    MenuItemInsert.Items[MenuItem.MenuIndex].Checked:=true;
  end;
//  ToolButtonInsert.Caption:=MenuItem.Caption;
  ToolButtonInsert.Hint:=MenuItem.Hint;
  InsertRecord;
end;

procedure TBisDataFrame.FillInsertMenus(Items: TMenuItem);
var
  MenuItem: TBisDataFrameInsertMenuItem;
  AClass: TBisDataEditFormIfaceClass;
  i: Integer;
  AIface: TBisDataEditFormIface;
  Flag: Boolean;
begin
  Items.Clear;
  Flag:=false;
  for i:=0 to FInsertClasses.Count-1 do begin
    AClass:=FInsertClasses.Items[i];
    if Assigned(AClass) then begin
      AIface:=CreateIface(AClass);
      try
        AIface.Init;
        MenuItem:=TBisDataFrameInsertMenuItem.Create(Self);
        MenuItem.Caption:=iff(Trim(AIface.Caption)<>'',AIface.Caption,ActionInsert.Caption);
        MenuItem.Hint:=iff(Trim(AIface.Description)<>'',AIface.Description,ActionInsert.Hint);
        MenuItem.Enabled:=AIface.CanShow;
        MenuItem.InsertClass:=AClass;
        MenuItem.RadioItem:=true;
        MenuItem.OnClick:=MenuInsertClick;
        MenuItem.Checked:=MenuItem.Enabled and not Flag;
        if MenuItem.Checked then begin
        //  ToolButtonInsert.Caption:=MenuItem.Caption;
          ToolButtonInsert.Hint:=MenuItem.Hint;
          Flag:=true;
        end;
        Items.Add(MenuItem);
      finally
        AIface.Free;
      end;
    end;
  end;
end;

procedure TBisDataFrame.FillReportMenus(Items: TMenuItem);
var
  MenuItem: TBisDataFrameReportMenuItem;
  AClass: TBisReportFormIfaceClass;
  i: Integer;
  AIface: TBisReportFormIface;
  Flag: Boolean;
begin
  Items.Clear;
  Flag:=false;
  for i:=0 to FReportClasses.Count-1 do begin
    AClass:=FReportClasses.Items[i];
    if Assigned(AClass) then begin
      AIface:=CreateIface(AClass);
      try
        AIface.Init;
        MenuItem:=TBisDataFrameReportMenuItem.Create(Self);
        MenuItem.Caption:=iff(Trim(AIface.Caption)<>'',AIface.Caption,ActionReport.Caption);
        MenuItem.Hint:=iff(Trim(AIface.Description)<>'',AIface.Description,ActionReport.Hint);
        MenuItem.Enabled:=AIface.CanShow;
        MenuItem.ReportClass:=AClass;
        MenuItem.RadioItem:=true;
        MenuItem.OnClick:=MenuReportClick;
        MenuItem.Checked:=MenuItem.Enabled and not Flag;
        if MenuItem.Checked then begin
//          ToolButtonReport.Caption:=MenuItem.Caption;
          ToolButtonReport.Hint:=MenuItem.Hint;
          Flag:=true;
        end;
        Items.Add(MenuItem);
      finally
        AIface.Free;
      end;
    end;
  end;
end;

function TBisDataFrame.GetDefaultInsertClass: TBisDataEditFormIfaceClass;
var
  i: Integer;
  MenuItem: TBisDataFrameInsertMenuItem;
begin
  Result:=nil;
  for i:=0 to PopupInsert.Items.Count-1 do begin
    MenuItem:=TBisDataFrameInsertMenuItem(PopupInsert.Items[i]);
    if MenuItem.Checked then begin
      Result:=MenuItem.InsertClass;
      exit;
    end;
  end;
end;

function TBisDataFrame.GetDefaultReportClass: TBisReportFormIfaceClass;
var
  i: Integer;
  MenuItem: TBisDataFrameReportMenuItem;
begin
  Result:=nil;
  for i:=0 to PopupReport.Items.Count-1 do begin
    MenuItem:=TBisDataFrameReportMenuItem(PopupReport.Items[i]);
    if MenuItem.Checked then begin
      Result:=MenuItem.ReportClass;
      exit;
    end;
  end;
end;

function TBisDataFrame.GetEventRefreshName: String;
begin
  Result:=iff(FEventRefresh.Name=FDefaultEventRefreshName,'',FEventRefresh.Name);
end;

function TBisDataFrame.CanInsertRecord: Boolean;
var
  AClass: TBisDataEditFormIfaceClass;
  P: TBisProvider;
begin
  AClass:=GetCurrentInsertClass;
  P:=GetCurrentProvider;
  Result:=Assigned(AClass) and Assigned(P) and P.Active;
  if Result and Assigned(FOnCanInsertRecord) then
    Result:=FOnCanInsertRecord(Self);
end;

procedure TBisDataFrame.InsertRecordAfterExecute(AForm: TBisDataEditForm);
begin
  DoAfterInsertRecord;
end;

procedure TBisDataFrame.InsertRecord;
var
  AIface: TBisDataEditFormIface;
  AClass: TBisDataEditFormIfaceClass;
begin
  if CanInsertRecord then begin
    AClass:=GetCurrentInsertClass;
    AIface:=FIfaces.FindByClass(AClass,emInsert);
    if not Assigned(AIface) then begin
      AIface:=CreateIface(AClass);
      AIface.ParentDataSet:=GetCurrentProvider;
      AIface.Init;
      AIface.Mode:=emInsert;
      FIfaces.Add(AIface);
    end;
    AIface.AsModal:=FAsModal;
    AIface.ShowType:=FShowType;
    AIface.OnAfterExecute:=InsertRecordAfterExecute;
    BeforeIfaceExecute(AIface);
    AIface.Execute;
  end;
end;

function TBisDataFrame.CanUpdateRecord: Boolean;
var
  DS: TBisProvider;
  AClass: TBisDataEditFormIfaceClass;
begin
  AClass:=GetCurrentUpdateClass;
  DS:=GetCurrentProvider;
  Result:=Assigned(AClass) and Assigned(DS) and
          DS.Active and not DS.IsEmpty;
  if Result and Assigned(FOnCanUpdateRecord) then
    Result:=FOnCanUpdateRecord(Self);
end;

procedure TBisDataFrame.UpdateRecordAfterExecute(AForm: TBisDataEditForm);
begin
  DoAfterUpdateRecord;
end;

procedure TBisDataFrame.UpdateRecord;
var
  AIface: TBisDataEditFormIface;
  AClass: TBisDataEditFormIfaceClass;
begin
  if CanUpdateRecord then begin
    AClass:=GetCurrentUpdateClass;
    AIface:=FIfaces.FindByClass(AClass,emUpdate);
    if not Assigned(AIface) then begin
      AIface:=CreateIface(AClass);
      AIface.ParentDataSet:=GetCurrentProvider;
      AIface.Init;
      AIface.Mode:=emUpdate;
      FIfaces.Add(AIface);
    end;
    AIface.SelectedFieldName:=GetSelectedFieldName;
    AIface.AsModal:=FAsModal;
    AIface.ShowType:=FShowType;
    AIface.OnAfterExecute:=UpdateRecordAfterExecute;
    BeforeIfaceExecute(AIface);
    AIface.Execute;
  end;
end;

function TBisDataFrame.CanDuplicateRecord: Boolean;
var
  DS: TBisProvider;
  AClass: TBisDataEditFormIfaceClass;
begin
  AClass:=GetCurrentDuplicateClass;
  DS:=GetCurrentProvider;
  Result:=Assigned(AClass) and Assigned(DS) and
          DS.Active and not DS.IsEmpty;
  if Result and Assigned(FOnCanDuplicateRecord) then
    Result:=FOnCanDuplicateRecord(Self);
end;

procedure TBisDataFrame.DuplicateRecordAfterExecute(AForm: TBisDataEditForm);
begin
  DoAfterDuplicateRecord;
end;

procedure TBisDataFrame.DuplicateRecord;
var
  AIface: TBisDataEditFormIface;
  AClass: TBisDataEditFormIfaceClass;
begin
  if CanDuplicateRecord then begin
    AClass:=GetCurrentDuplicateClass;
    AIface:=FIfaces.FindByClass(AClass,emDuplicate);
    if not Assigned(AIface) then begin
      AIface:=CreateIface(AClass);
      AIface.ParentDataSet:=GetCurrentProvider;
      AIface.Init;
      AIface.Mode:=emDuplicate;
      FIfaces.Add(AIface);
    end;
    AIface.SelectedFieldName:=GetSelectedFieldName;
    AIface.AsModal:=FAsModal;
    AIface.ShowType:=FShowType;
    AIface.OnAfterExecute:=DuplicateRecordAfterExecute;
    BeforeIfaceExecute(AIface);
    AIface.Execute;
  end;
end;

function TBisDataFrame.CanClose: Boolean;
begin
  Result:=true;
end;

function TBisDataFrame.CanDeleteRecord: Boolean;
var
  DS: TBisProvider;
  AClass: TBisDataEditFormIfaceClass;
begin
  AClass:=GetCurrentDeleteClass;
  DS:=GetCurrentProvider;
  Result:=Assigned(AClass) and Assigned(DS) and
          DS.Active and not DS.IsEmpty;
  if Result and Assigned(FOnCanDeleteRecord) then
    Result:=FOnCanDeleteRecord(Self);
end;

procedure TBisDataFrame.DeleteRecordAfterExecute(AForm: TBisDataEditForm);
begin
  DoAfterDeleteRecord;
end;

procedure TBisDataFrame.DeleteRecord;
var
  AIface: TBisDataEditFormIface;
  AClass: TBisDataEditFormIfaceClass;
begin
  if CanDeleteRecord then begin
    AClass:=GetCurrentDeleteClass;
    AIface:=FIfaces.FindByClass(AClass,emDelete);
    if not Assigned(AIface) then begin
      AIface:=CreateIface(AClass);
      AIface.ParentDataSet:=GetCurrentProvider;
      AIface.Init;
      AIface.Mode:=emDelete;
      FIfaces.Add(AIface);
    end;
    AIface.AsModal:=FAsModal;
    AIface.ShowType:=FShowType;
    AIface.OnAfterExecute:=DeleteRecordAfterExecute;
    BeforeIfaceExecute(AIface);
    AIface.Execute;
  end;
end;

procedure TBisDataFrame.PopupFilterPopup(Sender: TObject);

  function DeleteFilterExists: Boolean;
  var
    i: Integer;
    MenuItem: TMenuItem;
  begin
    Result:=false;
    for i:=0 to PopupFilter.Items.Count-1 do begin
      MenuItem:=PopupFilter.Items[i];
      if (MenuItem is TBisDataFrameFilterMenuItem) and
         TBisDataFrameFilterMenuItem(MenuItem).CanDelete then begin
        Result:=true;
        exit;
      end;
    end;
  end;

var
  MenuItem: TMenuItem;
begin
  MenuItem:=GetFirstMenuChecked(PopupFilter.Items);
  MenuItemFilterClear.Enabled:=Assigned(MenuItem);
  MenuItemFilterDeleteAll.Enabled:=DeleteFilterExists;
end;

procedure TBisDataFrame.MenuItemFilterClearClick(Sender: TObject);
var
  DS: TBisProvider;
  MenuItem: TBisDataFrameFilterMenuItem;
begin
  if CheckLargeData(FRequestLargeData) then begin
    DS:=GetCurrentProvider;
    MenuItem:=TBisDataFrameFilterMenuItem(GetFirstMenuChecked(PopupFilter.Items));
    if Assigned(DS) then begin
      if Assigned(MenuItem) then
        MenuItem.Checked:=false;
      DS.FilterGroups.DeleteVisible;
      OpenRecords;
    end;
  end;
end;

procedure TBisDataFrame.MenuItemFilterDeleteAllClick(Sender: TObject);
var
  i: Integer;
  DS: TBisProvider;
begin
  if CheckLargeData(FRequestLargeData) then begin
    DS:=GetCurrentProvider;
    if Assigned(DS) then begin
      for i:=PopupFilter.Items.Count-1 downto 0 do begin
        if PopupFilter.Items[i] is TBisDataFrameFilterMenuItem then begin
          if TBisDataFrameFilterMenuItem(PopupFilter.Items[i]).CanDelete then
            PopupFilter.Items.Delete(i)
          else PopupFilter.Items[i].Checked:=false;
        end;
      end;
      DS.FilterGroups.DeleteVisible;
      OpenRecords;
    end;
  end;
end;

procedure TBisDataFrame.MenuItemRefreshEventClick(Sender: TObject);
begin
  MenuItemRefreshEvent.Checked:=not MenuItemRefreshEvent.Checked;
end;

procedure TBisDataFrame.MenuReportClick(Sender: TObject);
var
  MenuItem: TBisDataFrameReportMenuItem;
begin
  MenuItem:=TBisDataFrameReportMenuItem(Sender);
  MenuItem.Checked:=true;
  if MenuItem.Parent<>PopupReport.Items then begin
    PopupReport.Items[MenuItem.MenuIndex].Checked:=true;
  end else begin
    MenuItemReport.Items[MenuItem.MenuIndex].Checked:=true;
  end;
//  ToolButtonReport.Caption:=MenuItem.Caption;
  ToolButtonReport.Hint:=MenuItem.Hint;
  ReportRecords;
end;

procedure TBisDataFrame.MenuFilterClick(Sender: TObject);
var
  DS: TBisProvider;
  MenuItem: TBisDataFrameFilterMenuItem;
begin
  DS:=GetCurrentProvider;
  if Assigned(DS) and Assigned(Sender) and (Sender is TBisDataFrameFilterMenuItem) then begin
    MenuItem:=TBisDataFrameFilterMenuItem(Sender);
    if CheckLargeData(MenuItem.RequestLargeData) then begin
      MenuItem.Checked:=true;
      DS.FilterGroups.DeleteVisible;
      DS.FilterGroups.CopyFrom(MenuItem.FilterGroups,false);
      OpenRecords;
    end;
  end;
end;

function TBisDataFrame.CreateFilterMenuItem(ACaption: String): TBisDataFrameFilterMenuItem;
begin
  Result:=TBisDataFrameFilterMenuItem.Create(Self);
  Result.Caption:=ACaption;
  Result.CanDelete:=false;
  Result.RadioItem:=true;
  Result.OnClick:=MenuFilterClick;
  PopupFilter.Items.Add(Result);
end;

function TBisDataFrame.GetDefaultFilterGroups: TBisFilterGroups;
var
  i: Integer;
begin
  Result:=nil;
  for i:=0 to PopupFilter.Items.Count-1 do begin
    if PopupFilter.Items[i] is TBisDataFrameFilterMenuItem then begin
      if PopupFilter.Items[i].Checked then begin
        Result:=TBisDataFrameFilterMenuItem(PopupFilter.Items[i]).FilterGroups;
        exit;
      end;
    end;
  end;
end;

procedure TBisDataFrame.PrepareFilterGroups(AFilterGroups: TBisFilterGroups);
begin
end;

procedure TBisDataFrame.FilterRecordsAfterExecute(AForm: TBisDataEditForm);
var
  AFilterGroups: TBisFilterGroups;
  MenuItem: TBisDataFrameFilterMenuItem;
  S: String;
  OldRequest: Boolean;
begin
  if Assigned(AForm) and Assigned(AForm.Provider) then begin
    OldRequest:=FRequestLargeData;
    FUpdateList.Add(AForm);
    try
      FRequestLargeData:=FRequestLargeData and not AForm.RequestLargeData;
      if not AForm.Provider.Params.Empty then begin
        AFilterGroups:=TBisFilterGroups.Create;
        try
          AForm.Provider.Params.CopyToFilterGroups(AFilterGroups);
          TranslateFilterGroups(AFilterGroups,ClassType);
          S:=AFilterGroups.GetViewString;
          if Trim(S)<>'' then begin
            MenuItem:=CreateFilterMenuItem(S);
            if Assigned(MenuItem) then begin
              MenuItem.CanDelete:=true;
              MenuItem.FilterGroups.CopyFrom(AFilterGroups);
              MenuFilterClick(MenuItem);
            end;
          end else
            MenuItemFilterClearClick(nil);
        finally
          AFilterGroups.Free;
        end;
      end else
        MenuItemFilterClearClick(nil);
      FLastFiltered:=true;
    finally
      FUpdateList.Remove(AForm);
      FRequestLargeData:=OldRequest; 
    end;
  end;
  DoAfterFilterRecords;
end;

function TBisDataFrame.CanFilterRecords: Boolean;

  function FilterExists: Boolean;
  var
    i: Integer;
    MenuItem: TMenuItem;
  begin
    Result:=false;
    for i:=0 to PopupFilter.Items.Count-1 do begin
      MenuItem:=PopupFilter.Items[i];
      if MenuItem is TBisDataFrameFilterMenuItem then begin
        Result:=true;
        exit;
      end;
    end;
  end;

var
  DS: TBisProvider;
  AClass: TBisDataEditFormIfaceClass;
begin
  AClass:=GetCurrentFilterClass;
  DS:=GetCurrentProvider;
  Result:=(Assigned(AClass) or FilterExists) and Assigned(DS);
  if Result and Assigned(FOnCanFilterRecords) then
    Result:=FOnCanFilterRecords(Self);
end;

procedure TBisDataFrame.FilterRecords;
var
  AIface: TBisDataEditFormIface;
  AClass: TBisDataEditFormIfaceClass;
begin
  if CanFilterRecords then begin
    FLastFiltered:=false;
    AClass:=GetCurrentFilterClass;
    if Assigned(AClass) then begin
      AIface:=FIfaces.FindByClass(AClass,emFilter);
      if not Assigned(AIface) then begin
        AIface:=CreateIface(AClass);
        AIface.ParentDataSet:=GetCurrentProvider;
        AIface.Init;
        AIface.Mode:=emFilter;
        FIfaces.Add(AIface);
      end;
      AIface.AsModal:=FAsModal;
      AIface.ShowType:=FShowType;
      AIface.OnAfterExecute:=FilterRecordsAfterExecute;
      BeforeIfaceExecute(AIface);
      AIface.Execute;
    end else begin
      ///
    end;
  end;
end;

function TBisDataFrame.CanViewRecord: Boolean;
var
  DS: TBisProvider;
  AClass: TBisDataEditFormIfaceClass;
begin
  AClass:=GetCurrentViewClass;
  DS:=GetCurrentProvider;
  Result:=Assigned(AClass) and Assigned(DS) and
          DS.Active and not DS.IsEmpty;
  if Result and Assigned(FOnCanViewRecord) then
    Result:=FOnCanViewRecord(Self);
end;

procedure TBisDataFrame.ViewRecord;
var
  AIface: TBisDataEditFormIface;
  AClass: TBisDataEditFormIfaceClass;
begin
  if CanViewRecord then begin
    AClass:=GetCurrentViewClass;
    AIface:=FIfaces.FindByClass(AClass,emView);
    if not Assigned(AIface) then begin
      AIface:=CreateIface(AClass);
      AIface.ParentDataSet:=GetCurrentProvider;
      AIface.Init;
      AIface.Mode:=emView;
      FIfaces.Add(AIface);
    end;
    AIface.SelectedFieldName:=GetSelectedFieldName;
    AIface.AsModal:=FAsModal;
    AIface.ShowType:=FShowType;
    BeforeIfaceExecute(AIface);
    AIface.Execute;
  end;
end;

function TBisDataFrame.CanInfoRecord: Boolean;
var
  DS: TBisProvider;
begin
  DS:=GetCurrentProvider;
  Result:=Assigned(DS) and DS.Active and not DS.IsEmpty;
  if Result and Assigned(FOnCanInfoRecord) then
    Result:=FOnCanInfoRecord(Self);
end;

procedure TBisDataFrame.InfoRecord;
var
  S: String;
  Form: TBisMemoForm;
begin
  if CanInfoRecord then begin
    S:=GetCurrentProvider.GetInfo(SReturn);
    Form:=TBisMemoForm.Create(Self);
    try
      Form.Init;
      Form.Memo.Lines.Text:=S;
      Form.ButtonOk.Visible:=false;
      Form.ShowModal;
    finally
      Form.Free;
    end;
  end;
end;

function TBisDataFrame.CanFirstRecord: Boolean;
var
  DS: TBisProvider;
begin
  DS:=GetCurrentProvider;
  Result:=Assigned(DS) and DS.Active and
          not DS.IsEmpty and not DS.Bof;
end;

procedure TBisDataFrame.FirstRecord;
begin
  if CanFirstRecord then
    FProvider.First;
end;

function TBisDataFrame.CanPriorRecord: Boolean;
var
  DS: TBisProvider;
begin
  DS:=GetCurrentProvider;
  Result:=Assigned(DS) and DS.Active and
          not DS.IsEmpty and not DS.Bof;
end;

procedure TBisDataFrame.PriorRecord;
begin
  if CanPriorRecord then
    FProvider.Prior;
end;

function TBisDataFrame.CanNextRecord: Boolean;
var
  DS: TBisProvider;
begin
  DS:=GetCurrentProvider;
  Result:=Assigned(DS) and DS.Active and
          not DS.IsEmpty and not DS.Eof;
end;

procedure TBisDataFrame.NextRecord;
begin
  if CanNextRecord then
    FProvider.Next;
end;

function TBisDataFrame.CanLastRecord: Boolean;
var
  DS: TBisProvider;
begin
  DS:=GetCurrentProvider;
  Result:=Assigned(DS) and DS.Active and
          not DS.IsEmpty and not DS.Eof;
end;

procedure TBisDataFrame.LastRecord;
begin
  if CanLastRecord then
    FProvider.Last;
end;

function TBisDataFrame.CanSelect: Boolean;
begin
  Result:=FProvider.Active and not FProvider.IsEmpty;
end;

function TBisDataFrame.LocateRecord(Fields: String; Values: Variant): Boolean;
begin
  Result:=false;
  if FProvider.Active and not FProvider.IsEmpty and (Trim(Fields)<>'') then
    Result:=FProvider.Locate(Fields,Values,[loCaseInsensitive,loPartialKey]);
end;

function TBisDataFrame.SelectInto(DataSet: TBisDataSet): Boolean;
begin
  Result:=false;
  if Assigned(DataSet) and FProvider.Active  then begin
    DataSet.CreateTable(FProvider);
    DataSet.CopyRecord(FProvider);
    Result:=DataSet.Active and not DataSet.Empty;
  end;
end;

function TBisDataFrame.CanReportRecords: Boolean;
var
  AClass: TBisReportFormIfaceClass;
  DS: TBisProvider;
  Pattern: TComponent;
begin
  AClass:=GetCurrentReportClass;
  DS:=GetCurrentProvider;
  Pattern:=GetReportPattern;
  Result:=Assigned(AClass) and Assigned(DS) and DS.Active and not DS.Empty and
          Assigned(Pattern);
  if Result and Assigned(FOnCanReportRecords) then
    Result:=FOnCanReportRecords(Self);
end;

procedure TBisDataFrame.BeforeIfaceExecute(AIface: TBisReportFormIface);
begin
  //
end;

procedure TBisDataFrame.ReportRecords;
var
  AIface: TBisReportFormIface;
  AClass: TBisReportFormIfaceClass;
begin
  if CanReportRecords then begin
    AClass:=GetCurrentReportClass;
    AIface:=FIfaces.FindByClass(AClass);
    if not Assigned(AIface) then begin
      AIface:=CreateIface(AClass);
      AIface.Pattern:=GetReportPattern;
      AIface.Caption:=Caption;
      AIface.Init;
      FIfaces.Add(AIface);
    end;
    AIface.AsModal:=FAsModal;
    AIface.ShowType:=FShowType;
    BeforeIfaceExecute(AIface);
    AIface.Execute;
  end;
end;

procedure TBisDataFrame.EnableControls(AEnabled: Boolean);
begin
  inherited EnableControls(AEnabled);
  EnableControl(Self,AEnabled);
end;

function TBisDataFrame.CanRefreshByEvent: Boolean;
begin
  Result:=MenuItemRefreshEvent.Checked;
end;

procedure TBisDataFrame.RefreshByEvent;
begin
  RefreshRecords;
end;

function TBisDataFrame.EventHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
begin
  Result:=false;
  if CanRefreshByEvent then begin
    RefreshByEvent;
    Result:=true;
  end;
end;

end.
