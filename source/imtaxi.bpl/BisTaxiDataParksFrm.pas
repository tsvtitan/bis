unit BisTaxiDataParksFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids, Contnrs,
                                                                                                          
  BisDataGridFrm, BisIfaces, BisTaxiDataParkStatesFm;

type

  TBisTaxiDataParksFrameIfaces=class(TObjectList)
  public
    function FindById(ParkId: Variant): TBisTaxiDataParkStatesFormIface;
  end;

  TBisTaxiDataParksFrame = class(TBisDataGridFrame)
    ToolBar1: TToolBar;
    ToolButtonStates: TToolButton;
    ActionStates: TAction;
    N13: TMenuItem;
    MenuItemStates: TMenuItem;
    procedure ActionStatesExecute(Sender: TObject);
    procedure ActionStatesUpdate(Sender: TObject);
  private
    FIfaces: TBisTaxiDataParksFrameIfaces;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CanStates: Boolean;
    procedure States;
  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisFilterGroups;

{$R *.dfm}

{ TBisTaxiDataParksFrameIfaces }

function TBisTaxiDataParksFrameIfaces.FindById(ParkId: Variant): TBisTaxiDataParkStatesFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisTaxiDataParkStatesFormIface) then begin
      if VarSameValue(TBisTaxiDataParkStatesFormIface(Obj).ParkId,ParkId) then begin
        Result:=TBisTaxiDataParkStatesFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

{ TBisTaxiDataParksFrame }

constructor TBisTaxiDataParksFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIfaces:=TBisTaxiDataParksFrameIfaces.Create;
end;

destructor TBisTaxiDataParksFrame.Destroy;
begin
  FIfaces.Free;
  inherited Destroy;
end;

procedure TBisTaxiDataParksFrame.ActionStatesExecute(Sender: TObject);
begin
  States;
end;

procedure TBisTaxiDataParksFrame.ActionStatesUpdate(Sender: TObject);
begin
  ActionStates.Enabled:=CanStates;
end;

function TBisTaxiDataParksFrame.CanStates: Boolean;
var
  P: TBisProvider;
  Iface: TBisTaxiDataParkStatesFormIface;
begin
  P:=GetCurrentProvider;
  Result:=Assigned(P) and P.Active and not P.IsEmpty;
  if Result then begin
    Iface:=TBisTaxiDataParkStatesFormIface.Create(Self);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisTaxiDataParksFrame.States;
var
  Iface: TBisTaxiDataParkStatesFormIface;
  P: TBisProvider;
  ParkId: Variant;
  ParkName: String;
begin
  if CanStates then begin
    P:=GetCurrentProvider;
    ParkId:=P.FieldByName('PARK_ID').Value;
    ParkName:=P.FieldByName('NAME').AsString;
    Iface:=FIfaces.FindById(ParkId);
    if not Assigned(Iface) then begin
      Iface:=TBisTaxiDataParkStatesFormIface.Create(Self);
      Iface.ParkId:=ParkId;
      Iface.ParkName:=ParkName;
      Iface.MaxFormCount:=1;
      FIfaces.Add(Iface);
      Iface.Init;
      Iface.FilterGroups.Add.Filters.Add('PARK_ID',fcEqual,ParkId).CheckCase:=true;
    end;
    Iface.Caption:=FormatEx('Состояние стоянки => %s',[ParkName]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;
  end;
end;

end.
