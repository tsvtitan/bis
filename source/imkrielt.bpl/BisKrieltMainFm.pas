unit BisKrieltMainFm;

interface                                                                                                    

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ExtCtrls, XPMan, ComCtrls, Contnrs,
  BisObject, ActnList, XPStyleActnCtrls, ShellAPI, AppEvnts, Menus, ActnPopup, Buttons,
  ActnMan, ToolWin, ActnCtrls, ActnMenus, CustomizeDlg, jpeg, ActnColorMaps,
  OleCtrls, SHDocVw,

  BisFm, BisCore, BisConnections, BisDataFm, BisProvider, BisIfaces,
  BisKrieltPresentationFm, BisMDIMainFm;

type
  TBisPresentationAction=class(TAction)
  private
    FIface: TBisKrieltPresentationFormIface;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Iface: TBisKrieltPresentationFormIface read FIface write FIface;
  end;

  TBisKrieltMainForm = class(TBisMDIMainForm)
    ActionManager: TActionManager;
    ActionFileExit: TAction;
    ActionWindowsCascade: TAction;
    ActionWindowsVertical: TAction;
    ActionWindowsHorizontal: TAction;
    ActionWindowsCloseAll: TAction;
    ControlBar: TControlBar;
  private
    FActions: TObjectList;
    FFileItem: TActionClientItem;
    FPresentationsItem: TActionClientItem;
    FWindowsItem: TActionClientItem;
    procedure RefreshMenuPresenations;
    procedure PresentationActionExecute(Sender: TObject);
  protected
    procedure SetLogoPosition(Visible: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RefreshMenus; override;                 
  end;

  TBisKrieltMainFormIface=class(TBisMDIMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
    procedure RefreshMenuPresentations;
  end;

var
  BisKrieltMainForm: TBisKrieltMainForm;

var
  MainIface: TBisKrieltMainFormIface=nil;

implementation

{$R *.dfm}

uses BisIfaceModules, BisConsts, BisUtils, BisFilterGroups, BisFieldNames,
     BisPicture;

{ TBisPresentationAction }

constructor TBisPresentationAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;


destructor TBisPresentationAction.Destroy;
begin
  if Assigned(FIface) then
    FIface.Free;
  inherited Destroy;
end;

{ TBisKrieltMainFormIface }

constructor TBisKrieltMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltMainForm;
end;

procedure TBisKrieltMainFormIface.RefreshMenuPresentations;
begin
  if Assigned(LastForm) then
    TBisKrieltMainForm(LastForm).RefreshMenuPresenations;
end;

{ TBisKrieltMainForm }

constructor TBisKrieltMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoMenu:=true;
  ButtonGroup.Visible:=false;
  FActions:=TObjectList.Create(true);
end;

destructor TBisKrieltMainForm.Destroy;
begin
  FActions.Free;
  inherited Destroy;
end;

procedure TBisKrieltMainForm.RefreshMenus;
var
  ParentItems: TActionClients;
  Item: TActionClientItem;
const
  FSFileItemCaption='����';
  FSFileExitItemCaption='�����';
  FSPresentationsItemCaption='�������������';
  FSWindowsItemCaption='����';
  FSWindowsCascadeItemCaption='��������';
  FSWindowsVerticalItemCaption='�����������';
  FSWindowsHorizontalItemCaption='�������������';
  FSWindowsCloseAllItemCaption='������� ���';
begin
  FFileItem:=nil;
  FPresentationsItem:=nil;
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

      FPresentationsItem:=FindItemByCaption(ParentItems,FSPresentationsItemCaption);
      RefreshMenuPresenations;

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

procedure TBisKrieltMainForm.SetLogoPosition(Visible: Boolean);
begin
  PanelLogo.Anchors:=[];
  if Visible then begin
    PanelLogo.Left:=ClientWidth-PanelLogo.Width-10;
    PanelLogo.Top:=ClientHeight-PanelLogo.Height-50;
    PanelLogo.Anchors:=[akRight,akBottom];
    PanelLogo.Visible:=not TBisPicture(ImageLogo.Picture).Empty;
  end else begin
    PanelLogo.Visible:=false;
    PanelLogo.Anchors:=[akLeft,akTop];
    PanelLogo.Top:=50;
  end;
end;

procedure TBisKrieltMainForm.RefreshMenuPresenations;
var
  P: TBisProvider;
  AccountId, OldAccountId: String;
  AccountItem: TActionClientItem;
  PublishingId, OldPublishingId: String;
  PublishingItem: TActionClientItem;
  ViewId, OldViewId: String;
  ViewItem: TActionClientItem;
  TypeId, OldTypeId: String;
  TypeItem: TActionClientItem;
  OperationItem: TActionClientItem;
  Action: TBisPresentationAction;
begin
  exit;
  FActions.Clear;
  if Assigned(FPresentationsItem) then begin
    FPresentationsItem.Items.Clear;

    AccountItem:=nil;
    PublishingItem:=nil;
    ViewItem:=nil;
    TypeItem:=nil;

    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_MENU_PRESENTATIONS';
      with P.FieldNames do begin
        AddInvisible('ACCOUNT_ID');
        AddInvisible('USER_NAME');
        AddInvisible('VIEW_NAME');
        AddInvisible('VIEW_ID');
        AddInvisible('TYPE_NAME');
        AddInvisible('TYPE_ID');
        AddInvisible('OPERATION_NAME');
        AddInvisible('OPERATION_ID');
        AddInvisible('PRESENTATION_NAME');
        AddInvisible('PRESENTATION_ID');
        AddInvisible('PUBLISHING_NAME');
        AddInvisible('PUBLISHING_ID');
        AddInvisible('TABLE_NAME');
      end;
      P.Orders.Add('USER_NAME');
      P.Open;
      if P.Active and not P.IsEmpty then begin
        P.First;
        while not P.Eof do begin
          PublishingId:=P.FieldByName('PUBLISHING_ID').AsString;
          AccountId:=P.FieldByName('ACCOUNT_ID').AsString;
          ViewId:=P.FieldByName('VIEW_ID').AsString;
          TypeId:=P.FieldByName('TYPE_ID').AsString;

          if AccountId<>OldAccountId then begin
            AccountItem:=FPresentationsItem.Items.Add;
            AccountItem.Caption:=P.FieldByName('USER_NAME').AsString;
            OldAccountId:=AccountId;
            OldPublishingId:='';
          end;

          if Assigned(AccountItem) then begin
            if PublishingId<>OldPublishingId then begin
              PublishingItem:=AccountItem.Items.Add;
              PublishingItem.Caption:=P.FieldByName('PUBLISHING_NAME').AsString;
              OldPublishingId:=PublishingId;
              OldViewId:='';
            end;

            if Assigned(PublishingItem) then begin

              if ViewId<>OldViewId then begin
                ViewItem:=PublishingItem.Items.Add;
                ViewItem.Caption:=P.FieldByName('VIEW_NAME').AsString;
                OldViewId:=ViewId;
                OldTypeId:='';
              end;

              if Assigned(ViewItem) then begin

                if TypeId<>OldTypeId then begin
                  TypeItem:=ViewItem.Items.Add;
                  TypeItem.Caption:=P.FieldByName('TYPE_NAME').AsString;
                  OldTypeId:=TypeId;
                end;

                if Assigned(TypeItem) then begin
                  OperationItem:=TypeItem.Items.Add;
                  Action:=TBisPresentationAction.Create(nil);
                  FActions.Add(Action);
                  Action.Caption:=P.FieldByName('OPERATION_NAME').AsString;
                  Action.Iface:=TBisKrieltPresentationFormIface.Create(Action);
                  with Action.Iface do begin
                    ShowType:=stMdiChild;
                    PresentationName:=P.FieldByName('PRESENTATION_NAME').AsString;
                    PresentationId:=P.FieldByName('PRESENTATION_ID').AsString;
                    TableName:=P.FieldByName('TABLE_NAME').AsString;
                    UserName:=P.FieldByName('USER_NAME').AsString;
                    PresentationPath:=FormatEx('%s\%s\%s\%s',[PublishingItem.Caption,
                                                                 ViewItem.Caption,
                                                                 TypeItem.Caption,
                                                                 Action.Caption]);
                  end;
                  Action.Iface.PublishingId:=PublishingId;
                  Action.Iface.ViewId:=ViewId;
                  Action.Iface.TypeId:=TypeId;
                  Action.Iface.OperationId:=P.FieldByName('OPERATION_ID').AsString;

                  Action.OnExecute:=PresentationActionExecute;
                  OperationItem.Action:=Action;
                end;
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

procedure TBisKrieltMainForm.PresentationActionExecute(Sender: TObject);
begin
  if Assigned(Sender) and (Sender is TBisPresentationAction) then begin
    with TBisPresentationAction(Sender) do begin
      Iface.RefreshByPresentationId;
      Iface.Show;
    end;
  end;
end;

end.