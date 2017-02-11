unit BisDesignDataApplicationsFrm;

interface

uses                                                                                                          
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  ExtCtrls, Grids, DBGrids, Contnrs, StdCtrls,

  BisDataGridFrm, BisDataFrm, BisDesignDataApplicationInterfacesFm;

type
  TBisDesignDataApplicationFrameIfaces=class(TObjectList)
  public
    function FindApplicationById(ApplicationId: Variant): TBisDesignDataApplicationInterfacesFormIface;
  end;

  TBisDesignDataApplicationsFrame = class(TBisDataGridFrame)
    ToolBarReport: TToolBar;
    ToolButtonInterfaces: TToolButton;
    ActionInterfaces: TAction;
    MenuItemInterfaces: TMenuItem;
    N16: TMenuItem;
    procedure ActionInterfacesExecute(Sender: TObject);
    procedure ActionInterfacesUpdate(Sender: TObject);
  private
    FIfaces: TBisDesignDataApplicationFrameIfaces;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanInterfaces: Boolean;
    procedure Interfaces;

  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisFilterGroups,
     BisParam, BisCore;

{$R *.dfm}

{ TBisDesignDataApplicationFrameIfaces }

function TBisDesignDataApplicationFrameIfaces.FindApplicationById(ApplicationId: Variant): TBisDesignDataApplicationInterfacesFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisDesignDataApplicationInterfacesFormIface) then begin
      if VarSameValue(TBisDesignDataApplicationInterfacesFormIface(Obj).ApplicationId,ApplicationId) then begin
        Result:=TBisDesignDataApplicationInterfacesFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

{ TBisDesignDataReportsFrame }

constructor TBisDesignDataApplicationsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIfaces:=TBisDesignDataApplicationFrameIfaces.Create;
end;

destructor TBisDesignDataApplicationsFrame.Destroy;
begin
  FIfaces.Free;
  inherited Destroy;
end;

procedure TBisDesignDataApplicationsFrame.ActionInterfacesExecute(Sender: TObject);
begin
  Interfaces;
end;

procedure TBisDesignDataApplicationsFrame.ActionInterfacesUpdate(Sender: TObject);
begin
  ActionInterfaces.Enabled:=CanInterfaces;
end;

function TBisDesignDataApplicationsFrame.CanInterfaces: Boolean;
var
  Iface: TBisDesignDataApplicationInterfacesFormIface;
begin
  Result:=Provider.Active and not Provider.Empty;
  if Result then begin
    Iface:=TBisDesignDataApplicationInterfacesFormIface.Create(nil);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisDesignDataApplicationsFrame.Interfaces;
var
  Iface: TBisDesignDataApplicationInterfacesFormIface;
  ApplicationId: Variant;
  ApplicationName: String;
begin
  if CanInterfaces then begin
    ApplicationId:=Provider.FieldByName('APPLICATION_ID').Value;
    ApplicationName:=Provider.FieldByName('NAME').AsString;
    Iface:=FIfaces.FindApplicationById(ApplicationId);
    if not Assigned(Iface) then begin
      Iface:=TBisDesignDataApplicationInterfacesFormIface.Create(Self);
      Iface.ApplicationId:=ApplicationId;
      Iface.ApplicationName:=ApplicationName;
      Iface.MaxFormCount:=1;
      FIfaces.Add(Iface);
      Iface.Init;
      Iface.FilterGroups.Add.Filters.Add('APPLICATION_ID',fcEqual,ApplicationId);
    end;
    Iface.Caption:=FormatEx('%s => %s',[ActionInterfaces.Caption,ApplicationName]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;
  end;
end;


end.
