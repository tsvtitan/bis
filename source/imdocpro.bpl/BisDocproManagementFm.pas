unit BisDocproManagementFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, DBCtrls, DB,
  BisFm,
  BisDocproManagementMasterFrm, BisDocproManagementDetailFrm;

type
  TBisDocproManagementForm = class(TBisForm)
    PanelMaster: TPanel;
    Splitter: TSplitter;
    StatusBar: TStatusBar;
    TimerRefresh: TTimer;
    TrayIcon: TTrayIcon;
    DataSource: TDataSource;
    PanelDetail: TGridPanel;
    PanelDetailLeft: TPanel;
    GroupBoxDescription: TGroupBox;
    DBMemoDescription: TDBMemo;
    procedure SplitterMoved(Sender: TObject);
    procedure TimerRefreshTimer(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
  private
    FMasterFrame: TBisDocproManagementMasterFrame;
    FDetailFrame: TBisDocproManagementDetailFrame;
    procedure MasterProviderAfterScroll(DataSet: TDataSet);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure BeforeShow; override;
  end;

  TBisDocproManagementFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproManagementForm: TBisDocproManagementForm;

implementation

{$R *.dfm}

{ TBisDocproManagementFormIface }

constructor TBisDocproManagementFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproManagementForm;
  Permissions.Enabled:=true;
  Available:=true;
end;

{ TBisDocproManagementForm }

constructor TBisDocproManagementForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FreeOnClose:=true;

  FMasterFrame:=TBisDocproManagementMasterFrame.Create(nil);
  FMasterFrame.Parent:=PanelMaster;
  FMasterFrame.Align:=alClient;
  FMasterFrame.Provider.AfterScroll:=MasterProviderAfterScroll;
  FMasterFrame.Provider.BeforeOpen:=MasterProviderAfterScroll;

  FDetailFrame:=TBisDocproManagementDetailFrame.Create(nil);
  FDetailFrame.Parent:=PanelDetailLeft;
  FDetailFrame.Align:=alClient;
  FDetailFrame.Provider.MasterSource:=FMasterFrame.DataSource;

  DataSource.DataSet:=FDetailFrame.Provider;

  TrayIcon.Icon.Assign(Application.Icon);
  TimerRefresh.Interval:=5*60*1000;


end;

destructor TBisDocproManagementForm.Destroy;
begin
  FDetailFrame.Free;
  FMasterFrame.Free;
  inherited Destroy;
end;

procedure TBisDocproManagementForm.Init;
begin
  inherited Init;

  FMasterFrame.ShowType:=ShowType;
  FMasterFrame.Init;

  FDetailFrame.ShowType:=ShowType;
  FDetailFrame.Init;
end;

procedure TBisDocproManagementForm.BeforeShow;
begin
  inherited BeforeShow;
  FMasterFrame.BeforeShow;
  FMasterFrame.OpenRecords;
  TimerRefresh.Enabled:=true;
  TrayIcon.Visible:=true;
end;


procedure TBisDocproManagementForm.MasterProviderAfterScroll(DataSet: TDataSet);
var
  OldCursor: TCursor;
begin
  if DataSet.Active and not DataSet.IsEmpty and not DataSet.ControlsDisabled then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    try
      FDetailFrame.OpenRecords;
      FDetailFrame.LastRecord;
    finally
      Screen.Cursor:=OldCursor;
    end;
  end else FDetailFrame.Provider.EmptyTable;
end;

procedure TBisDocproManagementForm.SplitterMoved(Sender: TObject);
begin
  StatusBar.Top:=PanelDetail.Top+PanelDetail.Height+1;
end;

procedure TBisDocproManagementForm.TimerRefreshTimer(Sender: TObject);
begin
  TimerRefresh.Enabled:=false;
  try
    FMasterFrame.RefreshRecords;
    if not FMasterFrame.Provider.IsEmpty then begin
      TrayIcon.ShowBalloonHint;
    end;
  finally
    TimerRefresh.Enabled:=true;
  end;
end;

procedure TBisDocproManagementForm.TrayIconDblClick(Sender: TObject);
begin
  if Assigned(Self) then begin
    if Self.WindowState=wsMinimized then begin
      ShowWindow(Self.Handle,SW_SHOW);
      ShowWindow(Self.Handle,SW_RESTORE);
    end;
    Self.BringToFront;
  end;
  Application.BringToFront;
  Application.Restore;
end;

end.
