unit BisReportFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, ExtCtrls,
  StdCtrls,
  BisDataSet,
  BisFrm;

type
  TBisReportFrame=class;

  TBisReportFrameCanEvent=function (Sender: TBisReportFrame): Boolean of object;
  TBisReportFrameEvent=procedure (Sender: TBisReportFrame) of object;
  TBisReportFrameGetParamValueEvent=procedure (Sender: TBisReportFrame; const ParamName: String; var Value: Variant) of object;

  TBisReportFrame = class(TBisFrame)
    PanelReport: TPanel;
    ControlBar: TControlBar;
    ToolBarRefresh: TToolBar;
    ToolButtonRefresh: TToolButton;
    ActionList: TActionList;
    ActionRefresh: TAction;
    ActionFirst: TAction;
    ActionPrior: TAction;
    ActionNext: TAction;
    ActionLast: TAction;
    ImageList: TImageList;
    Popup: TPopupActionBar;
    MenuItemRefresh: TMenuItem;
    N8: TMenuItem;
    MenuItemFirst: TMenuItem;
    MenuItemPrior: TMenuItem;
    MenuItemNext: TMenuItem;
    MenuItemLast: TMenuItem;
    ToolBarNavigate: TToolBar;
    ToolButtonFirst: TToolButton;
    ToolButtonPrior: TToolButton;
    ToolButtonNext: TToolButton;
    ToolButtonLast: TToolButton;
    ToolButtonEdit: TToolButton;
    ActionEdit: TAction;
    MenuItemEdit: TMenuItem;
    ActionPrint: TAction;
    ToolButtonPrint: TToolButton;
    ActionFind: TAction;
    ToolButtonFind: TToolButton;
    MenuItemPrint: TMenuItem;
    MenuItemFind: TMenuItem;
    ActionProperty: TAction;
    ToolButtonProperty: TToolButton;
    ActionExport: TAction;
    ToolButtonExport: TToolButton;
    PanelPageNum: TPanel;
    EditPageNum: TEdit;
    LabelCounter: TLabel;
    MenuItemExport: TMenuItem;
    MenuItemProperty: TMenuItem;
    procedure ActionRefreshExecute(Sender: TObject);
    procedure ActionRefreshUpdate(Sender: TObject);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionEditUpdate(Sender: TObject);
    procedure ActionPrintExecute(Sender: TObject);
    procedure ActionPrintUpdate(Sender: TObject);
    procedure ActionFindExecute(Sender: TObject);
    procedure ActionFindUpdate(Sender: TObject);
    procedure ActionPropertyExecute(Sender: TObject);
    procedure ActionPropertyUpdate(Sender: TObject);
    procedure ActionFirstExecute(Sender: TObject);
    procedure ActionFirstUpdate(Sender: TObject);
    procedure ActionPriorExecute(Sender: TObject);
    procedure ActionPriorUpdate(Sender: TObject);
    procedure ActionNextExecute(Sender: TObject);
    procedure ActionNextUpdate(Sender: TObject);
    procedure ActionLastExecute(Sender: TObject);
    procedure ActionLastUpdate(Sender: TObject);
    procedure ActionExportExecute(Sender: TObject);
    procedure ActionExportUpdate(Sender: TObject);
    procedure EditPageNumKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPageNumChange(Sender: TObject);
  private
    FOnCanRefreshReport: TBisReportFrameCanEvent;
    FReportId: Variant;
    FOnCanEditPage: TBisReportFrameCanEvent;
    FOnGetParamValue: TBisReportFrameGetParamValueEvent;
    FSFormatLabelCounter: String;
    FPattern: TComponent;
  protected
    procedure DoUpdateCounters; virtual;
    procedure SetPageNum(PageNum: Integer); virtual;
    function GetPageNum: Integer; virtual;
    procedure DoGetParamValue(const ParamName: String; var Value: Variant); virtual;
    function GetPageCount: Integer; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure BeforeShow; override;
    function ReportExists: Boolean; virtual;
    function ReportLoaded: Boolean; virtual;
    function ReportPrepared: Boolean; virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure CreateByPattern; virtual;
    function CanRefreshReport: Boolean; virtual;
    procedure RefreshReport; virtual;
    procedure OpenReport; virtual;
    function CanExportReport: Boolean; virtual;
    procedure ExportReport; virtual;
    function CanEditPage: Boolean; virtual;
    procedure EditPage; virtual;
    function CanPrintReport: Boolean; virtual;
    procedure PrintReport; virtual;
    function CanFindText: Boolean; virtual;
    procedure FindText; virtual;
    function CanPropertyPage: Boolean; virtual;
    procedure PropertyPage; virtual;
    function CanFirstPage: Boolean; virtual;
    procedure FirstPage; virtual;
    function CanPriorPage: Boolean; virtual;
    procedure PriorPage; virtual;
    function CanNextPage: Boolean; virtual;
    procedure NextPage; virtual;
    function CanLastPage: Boolean; virtual;
    procedure LastPage; virtual;
    function PageExists(PageNum: Integer): Boolean; virtual;
    procedure RefreshPageNum; virtual;

    procedure ResizeToolbar(Toolbar: TToolbar); virtual;
    procedure ResizeToolbars; virtual;
    procedure RepositionControlBarControls;

    property ReportId: Variant read FReportId write FReportId;
    property Pattern: TComponent read FPattern write FPattern;
    property PageNum: Integer read GetPageNum write SetPageNum;

    property OnCanRefreshReport: TBisReportFrameCanEvent read FOnCanRefreshReport write FOnCanRefreshReport;
    property OnCanEditPage: TBisReportFrameCanEvent read FOnCanEditPage write FOnCanEditPage;
    property OnGetParamValue: TBisReportFrameGetParamValueEvent read FOnGetParamValue write FOnGetParamValue;

  published
    property SFormatLabelCounter: String read FSFormatLabelCounter write FSFormatLabelCounter;  
  end;

  TBisReportFrameClass=class of TBisReportFrame;

implementation

{$R *.dfm}

uses
     BisUtils, BisCore, BisConnectionUtils;

{ TBisReportFrame }

constructor TBisReportFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FReportId:=Null;
  FSFormatLabelCounter:='�����: %d';
end;


destructor TBisReportFrame.Destroy;
begin
  inherited Destroy;
end;

procedure TBisReportFrame.Init;
begin
  inherited Init;
end;

procedure TBisReportFrame.BeforeShow;
begin
  inherited BeforeShow;

  ResizeToolbars;
  RepositionControlBarControls;
end;

procedure TBisReportFrame.ResizeToolbar(Toolbar: TToolbar);
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

procedure TBisReportFrame.ResizeToolbars;
begin
  ResizeToolbar(ToolBarRefresh);
  ResizeToolbar(ToolBarNavigate);
end;

procedure TBisReportFrame.RepositionControlBarControls;
var
  i: Integer;
  List: TList;
  Control: TControl;
  x: Integer;
begin
  x:=0;
  List:=TList.Create;
  try
    ControlBar.GetTabOrderList(List);
    for i:=0 to List.Count-1 do begin
      Control:=TControl(List.Items[i]);
      if Control.Visible then begin
        Control.Left:=x;
        x:=x+Control.Width+1;
      end;
    end;
    Constraints.MinWidth:=x+50;
  finally
    List.Free;
  end;
end;

procedure TBisReportFrame.ActionEditExecute(Sender: TObject);
begin
  EditPage;
end;

procedure TBisReportFrame.ActionEditUpdate(Sender: TObject);
begin
  ActionEdit.Enabled:=CanEditPage;
end;

procedure TBisReportFrame.ActionExportExecute(Sender: TObject);
begin
  ExportReport;
end;

procedure TBisReportFrame.ActionExportUpdate(Sender: TObject);
begin
  ActionExport.Enabled:=CanExportReport;

  LabelCounter.Enabled:=ActionExport.Enabled;
end;

procedure TBisReportFrame.ActionFindExecute(Sender: TObject);
begin
  FindText;
end;

procedure TBisReportFrame.ActionFindUpdate(Sender: TObject);
begin
  ActionFind.Enabled:=CanFindText;
end;

procedure TBisReportFrame.ActionFirstExecute(Sender: TObject);
begin
  FirstPage;
end;

procedure TBisReportFrame.ActionFirstUpdate(Sender: TObject);
begin
  ActionFirst.Enabled:=CanFirstPage;
end;

procedure TBisReportFrame.ActionLastExecute(Sender: TObject);
begin
  LastPage;
end;

procedure TBisReportFrame.ActionLastUpdate(Sender: TObject);
begin
  ActionLast.Enabled:=CanLastPage;
end;

procedure TBisReportFrame.ActionNextExecute(Sender: TObject);
begin
  NextPage;
end;

procedure TBisReportFrame.ActionNextUpdate(Sender: TObject);
begin
  ActionNext.Enabled:=CanNextPage;
end;

procedure TBisReportFrame.ActionPrintExecute(Sender: TObject);
begin
  PrintReport;
end;

procedure TBisReportFrame.ActionPrintUpdate(Sender: TObject);
begin
  ActionPrint.Enabled:=CanPrintReport;
end;

procedure TBisReportFrame.ActionPriorExecute(Sender: TObject);
begin
  PriorPage;
end;

procedure TBisReportFrame.ActionPriorUpdate(Sender: TObject);
begin
  ActionPrior.Enabled:=CanPriorPage;
end;

procedure TBisReportFrame.ActionPropertyExecute(Sender: TObject);
begin
  PropertyPage;
end;

procedure TBisReportFrame.ActionPropertyUpdate(Sender: TObject);
begin
  ActionProperty.Enabled:=CanPropertyPage;
end;

procedure TBisReportFrame.ActionRefreshExecute(Sender: TObject);
begin
  RefreshReport;
end;

procedure TBisReportFrame.ActionRefreshUpdate(Sender: TObject);
begin
  ActionRefresh.Enabled:=CanRefreshReport;
end;

function TBisReportFrame.ReportExists: Boolean;
begin
  Result:=not VarIsNull(FReportId) or Assigned(FPattern);
end;

function TBisReportFrame.ReportLoaded: Boolean;
begin
  Result:=false;
end;

function TBisReportFrame.ReportPrepared: Boolean;
begin
  Result:=false;
end;

function TBisReportFrame.CanRefreshReport: Boolean;
begin
  Result:=ReportExists;
  if Result and Assigned(FOnCanRefreshReport) then
    Result:=FOnCanRefreshReport(Self);
end;

procedure TBisReportFrame.DoUpdateCounters;
begin
  LabelCounter.Caption:=FormatEx(FSFormatLabelCounter,[GetPageCount]);
  LabelCounter.Width:=LabelCounter.Canvas.TextWidth(LabelCounter.Caption)+5;
end;

procedure TBisReportFrame.LoadFromStream(Stream: TStream);
begin
  //
end;

procedure TBisReportFrame.CreateByPattern;
begin
  //
end;

procedure TBisReportFrame.OpenReport;
var
  Stream: TMemoryStream;
begin
  if ReportExists then begin
    if not VarIsNull(FReportId) then begin
      Stream:=TMemoryStream.Create;
      try
        if DefaultLoadReport(FReportId,Stream) then begin
          Stream.Position:=0;
          LoadFromStream(Stream);
          FirstPage;
          DoUpdateCounters;
        end;
      finally
        Stream.Free;
      end;
    end else if Assigned(FPattern) then begin
      CreateByPattern;
      FirstPage;
      DoUpdateCounters;
    end;
  end;
end;

procedure TBisReportFrame.RefreshReport;
begin
  if CanRefreshReport then begin
    OpenReport;
  end;
end;

function TBisReportFrame.CanExportReport: Boolean;
begin
  Result:=ReportLoaded;
end;

procedure TBisReportFrame.ExportReport;
begin
end;

function TBisReportFrame.CanEditPage: Boolean;
begin
  Result:=ReportLoaded;
  if Result and Assigned(FOnCanEditPage) then
    Result:=FOnCanEditPage(Self);
end;

procedure TBisReportFrame.EditPage;
begin
end;

procedure TBisReportFrame.EditPageNumChange(Sender: TObject);
var
  Page: Integer;
begin
  EditPageNum.OnChange:=nil;
  try
    if TryStrToInt(EditPageNum.Text,Page) then begin
      if PageExists(Page) then
        PageNum:=Page
      else
        EditPageNum.Text:='';
    end else
      EditPageNum.Text:='';
  finally
    EditPageNum.OnChange:=EditPageNumChange;
  end;
end;

procedure TBisReportFrame.EditPageNumKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Page: Integer;
begin
  if TryStrToInt(EditPageNum.Text,Page) then begin
    if not PageExists(Page) then
      Key:=0;
  end else
    Key:=0;
end;

function TBisReportFrame.CanPrintReport: Boolean;
begin
  Result:=ReportLoaded;
end;

function TBisReportFrame.PageExists(PageNum: Integer): Boolean;
begin
  Result:=false;
end;

procedure TBisReportFrame.SetPageNum(PageNum: Integer);
begin
end;

function TBisReportFrame.GetPageCount: Integer;
begin
  Result:=0;
end;

function TBisReportFrame.GetPageNum: Integer;
begin
  Result:=0;
end;

procedure TBisReportFrame.RefreshPageNum;
begin
  EditPageNum.OnChange:=nil;
  try
    EditPageNum.Text:=IntToStr(PageNum);
    EditPageNum.SelectAll;
  finally
    EditPageNum.OnChange:=EditPageNumChange;
  end;
end;

procedure TBisReportFrame.PrintReport;
begin
end;

function TBisReportFrame.CanFindText: Boolean;
begin
  Result:=ReportLoaded;
end;

procedure TBisReportFrame.FindText;
begin
end;

function TBisReportFrame.CanPropertyPage: Boolean;
begin
  Result:=ReportLoaded;
end;

procedure TBisReportFrame.PropertyPage;
begin
end;

function TBisReportFrame.CanFirstPage: Boolean;
begin
  Result:=ReportLoaded;
end;

procedure TBisReportFrame.FirstPage;
begin
  RefreshPageNum;
end;

function TBisReportFrame.CanPriorPage: Boolean;
begin
  Result:=ReportLoaded;
end;

procedure TBisReportFrame.PriorPage;
begin
  RefreshPageNum;
end;

function TBisReportFrame.CanNextPage: Boolean;
begin
  Result:=ReportLoaded;
end;

procedure TBisReportFrame.NextPage;
begin
  RefreshPageNum;
end;

function TBisReportFrame.CanLastPage: Boolean;
begin
  Result:=ReportLoaded
end;

procedure TBisReportFrame.LastPage;
begin
  RefreshPageNum;
end;

procedure TBisReportFrame.DoGetParamValue(const ParamName: String; var Value: Variant);
begin
  if Assigned(FOnGetParamValue) then
    FOnGetParamValue(Self,ParamName,Value);
end;

end.
