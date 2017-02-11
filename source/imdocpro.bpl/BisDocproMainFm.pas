unit BisDocproMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ExtCtrls, XPMan, ComCtrls, Contnrs,
  BisObject, ActnList, XPStyleActnCtrls, ShellAPI, AppEvnts, Menus, ActnPopup, Buttons,
  ActnMan, ToolWin, ActnCtrls, ActnMenus, CustomizeDlg, jpeg, ActnColorMaps,

  BisFm, BisCore, BisConnections, BisDataFm, BisProvider, BisIfaces,
  BisMDIMainFm,
  BisDocproManagementFm, OleCtrls, SHDocVw;

type
  TBisDocproMainForm = class(TBisMDIMainForm)
    ActionManager: TActionManager;
    ActionFileExit: TAction;
    ActionWindowsCascade: TAction;
    ActionWindowsVertical: TAction;
    ActionWindowsHorizontal: TAction;
    ActionWindowsCloseAll: TAction;
    PanelControlBar: TPanel;
    ControlBar: TControlBar;
    ToolBar1: TToolBar;
    ToolButtonManagement: TToolButton;
    ActionListToolbar: TActionList;
    ActionManagement: TAction;
    ImageListToolbar: TImageList;
    procedure ActionManagementExecute(Sender: TObject);
    procedure ActionManagementUpdate(Sender: TObject);
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

  TBisDocproMainFormIface=class(TBisMDIMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproMainForm: TBisDocproMainForm;

var
  MainIface: TBisDocproMainFormIface=nil;
  ManagementIface: TBisDocproManagementFormIface=nil;

implementation

{$R *.dfm}

uses BisIfaceModules, BisConsts, BisUtils, BisFilterGroups, BisFieldNames;

{ TBisDocproMainFormIface }

constructor TBisDocproMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproMainForm;
end;

{ TBisDocproMainForm }

constructor TBisDocproMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoMenu:=true;
  ManagementIface.ShowType:=stMdiChild;
end;

destructor TBisDocproMainForm.Destroy;
begin
  inherited Destroy;
end;

procedure TBisDocproMainForm.RefreshMenus;
var
  ParentItems: TActionClients;
  Item: TActionClientItem;
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
        if Assigned(Item) then
          Item.Action:=ActionFileExit;
      end;

      FWindowsItem:=FindItemByCaption(ParentItems,FSWindowsItemCaption);
      if Assigned(FWindowsItem) then begin
        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsCascadeItemCaption);
        if Assigned(Item) then
          Item.Action:=ActionWindowsCascade;
        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsVerticalItemCaption);
        if Assigned(Item) then
          Item.Action:=ActionWindowsVertical;
        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsHorizontalItemCaption);
        if Assigned(Item) then
          Item.Action:=ActionWindowsHorizontal;
        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsCloseAllItemCaption);
        if Assigned(Item) then
          Item.Action:=ActionWindowsCloseAll;
      end;

      ActionMainMenuBar.CreateControls;
    end;
  end;
end;

procedure TBisDocproMainForm.ActionManagementExecute(Sender: TObject);
begin
  ManagementIface.Show;
end;

procedure TBisDocproMainForm.ActionManagementUpdate(Sender: TObject);
begin
  ActionManagement.Enabled:=ManagementIface.CanShow;
end;

procedure TBisDocproMainForm.SetLogoPosition(Visible: Boolean);
begin
  PanelLogo.Anchors:=[];
  if Visible then begin
    PanelLogo.Left:=ClientWidth-PanelLogo.Width-10;
    PanelLogo.Top:=ClientHeight-PanelControlBar.Height-PanelLogo.Height-50;
    PanelLogo.Anchors:=[akRight,akBottom];
    PanelLogo.Visible:=true;
  end else begin
    PanelLogo.Visible:=false;
    PanelLogo.Anchors:=[akLeft,akTop];
    PanelLogo.Top:=50;
  end;
end;



end.
