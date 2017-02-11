unit BisDesignDataSessionsFrm;

interface

uses                                                                                                          
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  ExtCtrls, Grids, DBGrids, Contnrs, StdCtrls,

  BisDataGridFrm, BisDataFrm;

type
  TBisDesignDataAlarmEditIfaces=class(TObjectList)
  end;

  TBisDesignDataSessionsFrame = class(TBisDataGridFrame)
    ToolBarReport: TToolBar;
    ToolButtonAlarm: TToolButton;
    ActionAlarm: TAction;
    MenuItemAlarm: TMenuItem;
    N16: TMenuItem;
    procedure ActionAlarmExecute(Sender: TObject);
    procedure ActionAlarmUpdate(Sender: TObject);
  private
    FIfaces: TBisDesignDataAlarmEditIfaces;  
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanAlarm: Boolean;
    procedure Alarm;

  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisFilterGroups,
     BisParam, BisCore,
     BisDesignDataAlarmEditFm;

{$R *.dfm}

{ TBisDesignDataSessionsFrame }

constructor TBisDesignDataSessionsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIfaces:=TBisDesignDataAlarmEditIfaces.Create;
end;

destructor TBisDesignDataSessionsFrame.Destroy;
begin
  FIfaces.Free;
  inherited Destroy;
end;

procedure TBisDesignDataSessionsFrame.ActionAlarmExecute(Sender: TObject);
begin
  Alarm;
end;

procedure TBisDesignDataSessionsFrame.ActionAlarmUpdate(Sender: TObject);
begin
  ActionAlarm.Enabled:=CanAlarm;
end;

function TBisDesignDataSessionsFrame.CanAlarm: Boolean;
var
  Iface: TBisDesignDataAlarmInsertFormIface;
begin
  Result:=Provider.Active and not Provider.Empty;
  if Result then begin
    Iface:=TBisDesignDataAlarmInsertFormIface.Create(nil);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisDesignDataSessionsFrame.Alarm;
var
  Iface: TBisDesignDataAlarmInsertFormIface;
begin
  if CanAlarm then begin
    Iface:=TBisDesignDataAlarmInsertFormIface.Create(Self);
    FIfaces.Add(Iface);
    Iface.Init;
    Iface.Params.ParamByName('RECIPIENT_ID').Value:=Provider.FieldByName('ACCOUNT_ID').Value;
    Iface.Params.ParamByName('RECIPIENT_NAME').Value:=Provider.FieldByName('USER_NAME').Value;
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;  
  end;
end;


end.
