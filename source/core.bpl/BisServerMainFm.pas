unit BisServerMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, Menus, ActnPopup, ImgList,
  StdCtrls, Contnrs, ActnList,

  BisFm, BisMainFm, BisObject, BisIfaceModules, BisServers;

type
  TBisServerMainForm = class(TBisMainForm)
    ControlBar: TControlBar;
    Timer: TTimer;
    MenuItemStart: TMenuItem;
    MenuItemStop: TMenuItem;
    ToolBar: TToolBar;
    LabelTime: TLabel;
    ActionList: TActionList;
    ActionAbout: TAction;
    ToolButtonAbout: TToolButton;
    ActionOptions: TAction;
    ToolButtonOptions: TToolButton;
    ActionStart: TAction;
    ActionStop: TAction;
    ToolButtonStart: TToolButton;
    ToolButtonStop: TToolButton;
    ToolButton1: TToolButton;
    N3: TMenuItem;
    MenuItemOptions: TMenuItem;
    procedure TimerTimer(Sender: TObject);
    procedure ActionAboutExecute(Sender: TObject);
    procedure ActionAboutUpdate(Sender: TObject);
    procedure ActionOptionsExecute(Sender: TObject);
    procedure ActionOptionsUpdate(Sender: TObject);
    procedure ActionStartExecute(Sender: TObject);
    procedure ActionStartUpdate(Sender: TObject);
    procedure ActionStopExecute(Sender: TObject);
    procedure ActionStopUpdate(Sender: TObject);
  private
    FWorking: Boolean;
    FDays: Integer;
    FTime: TDateTime;
    FServers: TBisServers;
    FDefaultWidth: Integer;

    FSFormatTime: String;
    FSServerWorking: String;
    FSServerIdle: String;
    FSServerPause: String;

    procedure RefreshServers;
    procedure SetIcon;
  protected
    function GetServerClass: TBisServerClass; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;

    procedure Init; override;

    function CanStart: Boolean; virtual;
    procedure Start; virtual;
    function CanStop: Boolean; virtual;
    procedure Stop; virtual;
    function CanOptions: Boolean; override;
    procedure Options; override;

    property Servers: TBisServers read FServers;
  published
    property SFormatTime: String read FSFormatTime write FSFormatTime;
    property SServerWorking: String read FSServerWorking write FSServerWorking;
    property SServerIdle: String read FSServerIdle write FSServerIdle;
    property SServerPause: String read FSServerPause write FSServerPause;
  end;

  TBisServerFormIface=class(TBisMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisServerMainFormIface=class(TBisServerFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var
  BisServerMainForm: TBisServerMainForm;

implementation

{$R *.dfm}

uses BisConsts, BisUtils, BisCore, BisServerModules;

{ TBisServerFormIface }

constructor TBisServerFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisServerMainForm;
  AutoShow:=false;
  ApplicationCreateForm:=false;
end;

{ TTBisServerMainFormIface }

constructor TBisServerMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoShow:=true;
  ApplicationCreateForm:=true;
end;

{ TTBisServerMainForm }

constructor TBisServerMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDefaultWidth:=Width;

  FDays:=0;
  FTime:=Core.ServerDate;

  FServers:=TBisServers.Create(Self);
  FServers.OwnsObjects:=false;

  FSFormatTime:='����� ������: %d ��. %s';
  FSServerWorking:='������ ������������ ������� ...';
  FSServerIdle:='������ ����������� ...';
  FSServerPause:='������ ����������.';

  Caption:=FirstCaption;

  RefreshServers;

  SetIcon;
end;

destructor TBisServerMainForm.Destroy;
begin
  FServers.Free;
  inherited Destroy;
end;

function TBisServerMainForm.GetServerClass: TBisServerClass;
begin
  Result:=TBisServer;
end;

procedure TBisServerMainForm.Init;
begin
  inherited Init;
end;

procedure TBisServerMainForm.BeforeShow;
begin
  inherited BeforeShow;
  TrayIcon.Visible:=ShowTrayIcon;
  TimerTimer(nil);
end;

procedure TBisServerMainForm.TimerTimer(Sender: TObject);
var
  Hour, Min, Sec, MSec: Word;
  Current: TDateTime;
begin
  Timer.Enabled:=false;
  try
    try
      Current:=Now-FTime;
      DecodeTime(Current,Hour,Min,Sec,MSec);
      if Hour>=24 then begin
        FDays:=FDays+1;
        FTime:=Now;
        Current:=Now-FTime;
      end;
      LabelTime.Caption:=FormatEx(FSFormatTime,[FDays,FormatDateTime('hh:nn:ss',Current)]);
      LabelTime.Font.Color:=iff(FServers.Working and FServers.Started,clRed,clWindowText);
      TrayIcon.Hint:=FormatEx('%s %s',[Caption,LabelTime.Caption]);
      SetIcon;
      if FServers.Started then begin
        if (FWorking<>FServers.Working) then begin
          if FServers.Working then
            TrayIcon.BalloonHint:=FSServerWorking
          else
            TrayIcon.BalloonHint:=FSServerIdle;
        end;
        FWorking:=FServers.Working;
      end else begin
        TrayIcon.BalloonHint:=FSServerPause;
      end;
    except
    end;
  finally
    Timer.Enabled:=true;
  end;
end;

procedure TBisServerMainForm.SetIcon;
var
  NewIcon: TIcon;
begin
  NewIcon:=TIcon.Create;
  try
    if FServers.Started then
      TrayIcon.IconIndex:=iff(FServers.Working,1,0)
    else TrayIcon.IconIndex:=2;
    if (ImageList.Count-1)>=TrayIcon.IconIndex then begin
      ImageList.GetIcon(TrayIcon.IconIndex,NewIcon);
      TrayIcon.Icon.Assign(NewIcon);
    end;
  finally
    NewIcon.Free;
  end;
end;

procedure TBisServerMainForm.RefreshServers;
var
  i: Integer;
  j: Integer;
  AClass: TBisServerClass;
  Module: TBisServerModule;
  Server: TBisServer;
begin
  AClass:=GetServerClass;
  if Assigned(AClass) then begin
    FServers.Clear;
    for i:=0 to Core.ServerModules.Count-1 do begin
      Module:=Core.ServerModules.Items[i];
      if Module.Enabled then begin
        for j:=0 to Module.Servers.Count-1 do begin
          Server:=Module.Servers.Items[j];
          if (Server.Enabled) and IsClassParent(Server.ClassType,AClass) then begin
            FServers.AddServer(Server);
          end;
        end;
      end;
    end;
  end;
end;

procedure TBisServerMainForm.ActionAboutUpdate(Sender: TObject);
begin
  ActionAbout.Enabled:=CanAbout;
end;

procedure TBisServerMainForm.ActionOptionsExecute(Sender: TObject);
begin
  Options;
end;

procedure TBisServerMainForm.ActionOptionsUpdate(Sender: TObject);
begin
  ActionOptions.Enabled:=CanOptions;
end;

procedure TBisServerMainForm.ActionStartExecute(Sender: TObject);
begin
  Start;
end;

procedure TBisServerMainForm.ActionStartUpdate(Sender: TObject);
begin
  ActionStart.Enabled:=CanStart;
end;

procedure TBisServerMainForm.ActionStopExecute(Sender: TObject);
begin
  Stop;
end;

procedure TBisServerMainForm.ActionStopUpdate(Sender: TObject);
begin
  ActionStop.Enabled:=CanStop;
end;

procedure TBisServerMainForm.ActionAboutExecute(Sender: TObject);
begin
  About;
end;

function TBisServerMainForm.CanOptions: Boolean;
begin
 // Result:=not FServers.Started;
  Result:=false;
end;

procedure TBisServerMainForm.Options;
begin
end;

function TBisServerMainForm.CanStart: Boolean;
begin
  Result:=not FServers.Started;
end;

procedure TBisServerMainForm.Start;
begin
  FServers.Start;
end;

function TBisServerMainForm.CanStop: Boolean;
begin
  Result:=FServers.Started;
end;

procedure TBisServerMainForm.Stop;
begin
  FServers.Stop;
end;

end.
