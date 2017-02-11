unit BisMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ExtCtrls, Menus, ActnPopup,
  BisFm;

type
  TBisMainForm = class(TBisForm)
    TrayIcon: TTrayIcon;
    ImageList: TImageList;
    PopupActionBar: TPopupActionBar;
    MenuItemShow: TMenuItem;
    MenuItemHide: TMenuItem;
    N2: TMenuItem;
    MenuItemExit: TMenuItem;
    N1: TMenuItem;
    MenuItemAbout: TMenuItem;
    procedure TrayIconDblClick(Sender: TObject);
    procedure MenuItemShowClick(Sender: TObject);
    procedure MenuItemHideClick(Sender: TObject);
    procedure PopupActionBarPopup(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
  private
    FCloseExit: Boolean;
    FSCloseQuery: String;
    FUseCloseQuery: Boolean;
    FShowTrayIcon: Boolean;
    FCloseToTray: Boolean;
    FSecondVisible: Boolean;
    FFirstCaption: String;
  protected
    procedure DoClose(var Action: TCloseAction); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CloseQuery: Boolean; override;
    function CanShow: Boolean; override;
    procedure BeforeShow; override;

    function CanAbout: Boolean; virtual;
    procedure About; virtual;

    property UseCloseQuery: Boolean read FUseCloseQuery write FUseCloseQuery;
    property CloseToTray: Boolean read FCloseToTray write FCloseToTray;
    property FirstCaption: String read FFirstCaption write FFirstCaption;

    property ShowTrayIcon: Boolean read FShowTrayIcon;
  published
    property SCloseQuery: String read FSCloseQuery write FSCloseQuery;
  end;

  TBisMainFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMainForm: TBisMainForm;

implementation

uses BisCore, BisConsts, BisDialogs, BisCoreIntf;

{$R *.dfm}

{ TBisMainFormIface }

constructor TBisMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMainForm;
  AutoShow:=true;
  ApplicationCreateForm:=true;
  Permissions.Enabled:=false;
  ChangeFormCaption:=false;
end;

{ TBisMainForm }

constructor TBisMainForm.Create(AOwner: TComponent);
var
  Buffer: String;
begin
  inherited Create(AOwner);
  SizesStored:=true;

  FUseCloseQuery:=false;
  Buffer:='';
  if Core.LocalBase.ReadParam(SUseCloseQuery,Buffer) then
    FUseCloseQuery:=Boolean(StrToIntDef(Buffer,0));

  FShowTrayIcon:=false;
  Buffer:='';
  if Core.LocalBase.ReadParam(SShowTrayIcon,Buffer) then
    FShowTrayIcon:=Boolean(StrToIntDef(Buffer,0));

  FCloseToTray:=FShowTrayIcon;

  FSecondVisible:=Core.Application.ShowMainForm;
  FFirstCaption:=Core.Application.Title;

  FSCloseQuery:='Закрыть программу?';
end;

destructor TBisMainForm.Destroy;
begin
  inherited Destroy;
end;

procedure TBisMainForm.DoClose(var Action: TCloseAction);
begin
  inherited DoClose(Action);
  if FCloseToTray then
    if TrayIcon.Visible and not FCloseExit then begin
      Action:=caNone;
      Hide;
    end;
end;

procedure TBisMainForm.MenuItemExitClick(Sender: TObject);
{var
  Old: Boolean;}
begin
//  Old:=FCloseExit;
  FCloseExit:=true;
  try
    Close;
  finally
  //  FCloseExit:=Old;
  end;
end;

procedure TBisMainForm.MenuItemHideClick(Sender: TObject);
begin
  Hide;
end;

procedure TBisMainForm.MenuItemShowClick(Sender: TObject);
begin
  FSecondVisible:=true;
  if IsMainForm then
    Forms.Application.Restore;
  Show;
  BringToFront;
end;

procedure TBisMainForm.MenuItemAboutClick(Sender: TObject);
begin
  About;
end;

procedure TBisMainForm.PopupActionBarPopup(Sender: TObject);
begin
  MenuItemShow.Enabled:=not Visible or (IsMainForm and IsIconic(Application.Handle));
  MenuItemHide.Enabled:=not MenuItemShow.Enabled;
  MenuItemAbout.Enabled:=CanAbout;
  MenuItemExit.Visible:=IsMainForm or not Assigned(Application.MainForm);
end;

procedure TBisMainForm.TrayIconDblClick(Sender: TObject);
begin
  MenuItemShowClick(nil);
end;

function TBisMainForm.CloseQuery: Boolean;
var
  Flag: Boolean;
begin
  Result:=inherited CloseQuery;
  Flag:=FUseCloseQuery and (not FCloseToTray or (FCloseToTray and FCloseExit));
  if Flag then begin
    MenuItemShowClick(nil);    
    Result:=ShowQuestion(FSCloseQuery,mbNo)=mrYes;
  end;
end;

procedure TBisMainForm.BeforeShow;
begin
  inherited BeforeShow;
  TrayIcon.Visible:=FShowTrayIcon and IsMainForm;
end;

function TBisMainForm.CanAbout: Boolean;
begin
  Result:=Assigned(Core) and IsMainForm;
end;

procedure TBisMainForm.About;
begin
  if CanAbout then
    Core.AboutIface.ShowModal;
end;

function TBisMainForm.CanShow: Boolean;
begin
  if IsMainForm then
    Result:=FSecondVisible
  else
    Result:=inherited CanShow;  
end;


end.
