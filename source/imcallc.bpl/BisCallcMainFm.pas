unit BisCallcMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ExtCtrls, XPMan, ComCtrls, Contnrs,
  BisObject, ActnList, XPStyleActnCtrls, ShellAPI, AppEvnts, Menus, ActnPopup, Buttons,
  ActnMan, ToolWin, ActnCtrls, ActnMenus, CustomizeDlg, jpeg, ActnColorMaps,

  BisFm, BisCore, BisConnections, BisDataFm, BisProvider, BisIfaces, BisMDIMainFm;

type

  TBisCallcMainForm = class(TBisMDIMainForm)
    ActionManager: TActionManager;
    ActionFileExit: TAction;
    ActionWindowsCascade: TAction;
    ActionWindowsVertical: TAction;
    ActionWindowsHorizontal: TAction;
    ActionWindowsCloseAll: TAction;
    ControlBar: TControlBar;
  private
    FFileItem: TActionClientItem;
    FWindowsItem: TActionClientItem;
  public
    constructor Create(AOwner: TComponent); override;
    procedure RefreshMenus; override;
  end;

  TBisCallcMainFormIface=class(TBisMdiMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcMainForm: TBisCallcMainForm;

var
  MainIface: TBisCallcMainFormIface=nil;

implementation

{$R *.dfm}

uses BisCallcConsts, BisIfaceModules, BisConsts, BisUtils, BisFilterGroups, BisParam;

{ TBisCallcMainFormIface }

constructor TBisCallcMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcMainForm;
end;

{ TBisCallcMainForm }

constructor TBisCallcMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoMenu:=true;
end;

procedure TBisCallcMainForm.RefreshMenus;
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
        if Assigned(Item) then begin
          ActionFileExit.ImageIndex:=Item.ImageIndex;
          Item.Action:=ActionFileExit;
        end;
      end;

      FWindowsItem:=FindItemByCaption(ParentItems,FSWindowsItemCaption);
      if Assigned(FWindowsItem) then begin
        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsCascadeItemCaption);
        if Assigned(Item) then begin
          ActionWindowsCascade.ImageIndex:=Item.ImageIndex;
          Item.Action:=ActionWindowsCascade;
        end;
        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsVerticalItemCaption);
        if Assigned(Item) then begin
          ActionWindowsVertical.ImageIndex:=Item.ImageIndex;
          Item.Action:=ActionWindowsVertical;
        end;
        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsHorizontalItemCaption);
        if Assigned(Item) then begin
          ActionWindowsHorizontal.ImageIndex:=Item.ImageIndex;
          Item.Action:=ActionWindowsHorizontal;
        end;
        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsCloseAllItemCaption);
        if Assigned(Item) then begin
          ActionWindowsCloseAll.ImageIndex:=Item.ImageIndex;
          Item.Action:=ActionWindowsCloseAll;
        end;
      end;

      ActionMainMenuBar.CreateControls;

    end;
  end;
end;

end.
