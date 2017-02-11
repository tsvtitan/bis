unit BisBallMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ExtCtrls, XPMan, ComCtrls, Contnrs,
  BisObject, ActnList, XPStyleActnCtrls, ShellAPI, AppEvnts, Menus, ActnPopup, Buttons,
  ActnMan, ToolWin, ActnCtrls, ActnMenus, CustomizeDlg, jpeg, ActnColorMaps,
  OleCtrls, SHDocVw,

  BisFm, BisCore, BisConnections, BisDataFm, BisProvider, BisIfaces, BisNotifyEvents,
  BisMdiMainFm;

type
  TBisBallMainForm = class(TBisMdiMainForm)
    ActionManager: TActionManager;
    ActionFileExit: TAction;
    ActionWindowsCascade: TAction;
    ActionWindowsVertical: TAction;
    ActionWindowsHorizontal: TAction;
    ActionWindowsCloseAll: TAction;
    PanelControlBar: TPanel;
    ControlBar: TControlBar;
    ToolBar: TToolBar;
    ActionListToolbar: TActionList;
    ImageListToolbar: TImageList;
    ActionImport: TAction;
    ToolButtonImport: TToolButton;
    ToolButtonManage: TToolButton;
    ToolButtonLottery: TToolButton;
    ActionManage: TAction;
    ActionLottery: TAction;
    ToolButtonTirages: TToolButton;
    ActionTirages: TAction;
    ActionExport: TAction;
    ToolButtonExport: TToolButton;
    ToolButtonDistr: TToolButton;
    ActionDistr: TAction;
    procedure ActionImportExecute(Sender: TObject);
    procedure ActionImportUpdate(Sender: TObject);
    procedure ActionManageExecute(Sender: TObject);
    procedure ActionManageUpdate(Sender: TObject);
    procedure ActionLotteryExecute(Sender: TObject);
    procedure ActionLotteryUpdate(Sender: TObject);
    procedure ActionTiragesExecute(Sender: TObject);
    procedure ActionTiragesUpdate(Sender: TObject);
    procedure ActionExportExecute(Sender: TObject);
    procedure ActionExportUpdate(Sender: TObject);
    procedure ActionDistrExecute(Sender: TObject);
    procedure ActionDistrUpdate(Sender: TObject);
  private
    FFileItem: TActionClientItem;
    FWindowsItem: TActionClientItem;
  protected
    procedure SetLogoPosition(Visible: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RefreshMenus; override;
  end;

  TBisBallMainFormIface=class(TBisMDIMainFormIface)
  private
    FAfterLoginEvent: TBisNotifyEvent;
    FBeforeLogoutEvent: TBisNotifyEvent;

    procedure AfterLogin(Sender: TObject);
    procedure BeforeLogout(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  BisBallMainForm: TBisBallMainForm;

var
  TiragesIface: TBisFormIface=nil;
  ImportIface: TBisFormIface=nil;
  ManageIface: TBisFormIface=nil;
  DistrIface: TBisFormIface=nil;
  LotteryIface: TBisFormIface=nil;
  ExportIface: TBisFormIface=nil;

implementation

{$R *.dfm}

uses BisIfaceModules, BisConsts, BisUtils, BisFilterGroups, BisFieldNames, BisOrders,
     BisBallConsts, BisDialogs, BisPicture;

{ TBisBallMainFormIface }

constructor TBisBallMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisBallMainForm;
  FAfterLoginEvent:=Core.AfterLoginEvents.Add(AfterLogin);
  FBeforeLogoutEvent:=Core.BeforeLogoutEvents.Add(BeforeLogout);

end;

destructor TBisBallMainFormIface.Destroy;
begin
  Core.BeforeLogoutEvents.Remove(FBeforeLogoutEvent);
  Core.AfterLoginEvents.Remove(FAfterLoginEvent);
  inherited Destroy;
end;

procedure TBisBallMainFormIface.AfterLogin(Sender: TObject);
begin
end;

procedure TBisBallMainFormIface.BeforeLogout(Sender: TObject);
begin
end;

{ TBisTaxiMainForm }

constructor TBisBallMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoMenu:=true;
  SizesStored:=true;
  CloseToTray:=false;

  if Assigned(TiragesIface) then TiragesIface.ShowType:=stMdiChild;
  if Assigned(ImportIface) then ImportIface.ShowType:=stMdiChild;
  if Assigned(ManageIface) then ManageIface.ShowType:=stMdiChild;
  if Assigned(DistrIface) then DistrIface.ShowType:=stMdiChild;
  if Assigned(LotteryIface) then LotteryIface.ShowType:=stMdiChild;
  if Assigned(ExportIface) then ExportIface.ShowType:=stMdiChild;

end;

destructor TBisBallMainForm.Destroy;
begin
  inherited Destroy;
end;

procedure TBisBallMainForm.RefreshMenus;
var
  ParentItems: TActionClients;
  Item: TActionClientItem;

  procedure SetLocalAction(Action: TAction);
  var
    OldIndex: Integer;
  begin
    if Assigned(Item) then begin
      if Action.ImageIndex=-1 then
        OldIndex:=Item.ImageIndex
      else OldIndex:=Action.ImageIndex;
      Item.Action:=Action;
      Item.ImageIndex:=OldIndex;
    end;
  end;

const
  FSFileItemCaption='����';
  FSFileExitItemCaption='�����';
  FSWindowsItemCaption='����';
  FSWindowsCascadeItemCaption='��������';
  FSWindowsVerticalItemCaption='�����������';
  FSWindowsHorizontalItemCaption='�������������';
  FSWindowsCloseAllItemCaption='������� ���';
begin
  FFileItem:=nil;
  FWindowsItem:=nil;

  if Assigned(ActionMainMenuBar.ActionClient) then begin
    ParentItems:=ActionMainMenuBar.ActionClient.Items;
    if Assigned(ParentItems) then begin
      inherited RefreshMenus;

      FFileItem:=FindItemByCaption(ParentItems,FSFileItemCaption);
      if Assigned(FFileItem) then begin
        Item:=FindItemByCaption(FFileItem.Items,FSFileExitItemCaption);
        SetLocalAction(ActionFileExit);
      end;

      FWindowsItem:=FindItemByCaption(ParentItems,FSWindowsItemCaption);
      if Assigned(FWindowsItem) then begin
        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsCascadeItemCaption);
        SetLocalAction(ActionWindowsCascade);

        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsVerticalItemCaption);
        SetLocalAction(ActionWindowsVertical);

        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsHorizontalItemCaption);
        SetLocalAction(ActionWindowsHorizontal);

        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsCloseAllItemCaption);
        SetLocalAction(ActionWindowsCloseAll);
      end;

      ActionMainMenuBar.CreateControls;
    end;
  end;
end;

procedure TBisBallMainForm.SetLogoPosition(Visible: Boolean);
begin
  PanelLogo.Anchors:=[];
  if Visible then begin
    PanelLogo.Left:=ClientWidth-PanelLogo.Width-10;
    PanelLogo.Top:=ClientHeight-PanelControlBar.Height-PanelLogo.Height-50;
    PanelLogo.Anchors:=[akRight,akBottom];
    PanelLogo.Visible:=not TBisPicture(ImageLogo.Picture).Empty;
  end else begin
    PanelLogo.Visible:=false;
    PanelLogo.Anchors:=[akLeft,akTop];
    PanelLogo.Top:=50;
  end;
end;

procedure TBisBallMainForm.ActionDistrExecute(Sender: TObject);
begin
  if Assigned(DistrIface) then DistrIface.Show;
end;

procedure TBisBallMainForm.ActionDistrUpdate(Sender: TObject);
begin
  ActionDistr.Enabled:=Assigned(DistrIface) and DistrIface.CanShow;
end;

procedure TBisBallMainForm.ActionExportExecute(Sender: TObject);
begin
  if Assigned(ExportIface) then ExportIface.Show;
end;

procedure TBisBallMainForm.ActionExportUpdate(Sender: TObject);
begin
  ActionExport.Enabled:=Assigned(ExportIface) and ExportIface.CanShow;
end;

procedure TBisBallMainForm.ActionImportExecute(Sender: TObject);
begin
  if Assigned(ImportIface) then ImportIface.Show;
end;

procedure TBisBallMainForm.ActionImportUpdate(Sender: TObject);
begin
  ActionImport.Enabled:=Assigned(ImportIface) and ImportIface.CanShow;
end;

procedure TBisBallMainForm.ActionManageExecute(Sender: TObject);
begin
  if Assigned(ManageIface) then ManageIface.Show;
end;

procedure TBisBallMainForm.ActionManageUpdate(Sender: TObject);
begin
  ActionManage.Enabled:=Assigned(ManageIface) and ManageIface.CanShow;
end;

procedure TBisBallMainForm.ActionTiragesExecute(Sender: TObject);
begin
  if Assigned(TiragesIface) then TiragesIface.Show;
end;

procedure TBisBallMainForm.ActionTiragesUpdate(Sender: TObject);
begin
  ActionTirages.Enabled:=Assigned(TiragesIface) and TiragesIface.CanShow;
end;

procedure TBisBallMainForm.ActionLotteryExecute(Sender: TObject);
begin
  if Assigned(LotteryIface) then LotteryIface.Show;
end;

procedure TBisBallMainForm.ActionLotteryUpdate(Sender: TObject);
begin
  ActionLottery.Enabled:=Assigned(LotteryIface) and LotteryIface.CanShow;
end;

end.
