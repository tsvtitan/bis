unit BisTaxiDataZonesFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids, Contnrs,
  BisDataFrm, BisDataGridFrm, BisTaxiDataZoneParksFm, BisTaxiDataCostsFm,
  BisTaxiDataCompositionsFm;

type

  TBisTaxiDataZonesFrameZoneParks=class(TObjectList)
  public
    function FindById(ZoneId: Variant): TBisTaxiDataZoneParksFormIface;
  end;

  TBisTaxiDataZonesFrameCosts=class(TObjectList)
  public
    function FindById(ZoneId: Variant): TBisTaxiDataCostsFormIface;
  end;

  TBisTaxiDataZonesFrameCompositions=class(TObjectList)
  public
    function FindById(ZoneId: Variant): TBisTaxiDataCompositionsFormIface;
  end;

  TBisTaxiDataZonesFrame = class(TBisDataGridFrame)
    ToolBarAdditional: TToolBar;
    ToolButtonZoneParks: TToolButton;
    ToolButtonCosts: TToolButton;
    ToolButtonCompositions: TToolButton;
    ActionZoneParks: TAction;
    N13: TMenuItem;
    MenuItemZoneParks: TMenuItem;
    ActionCosts: TAction;
    MenuItemCosts: TMenuItem;
    ActionCompositions: TAction;
    MenuItemCompositions: TMenuItem;
    procedure ActionZoneParksExecute(Sender: TObject);
    procedure ActionZoneParksUpdate(Sender: TObject);
    procedure ActionCostsExecute(Sender: TObject);
    procedure ActionCostsUpdate(Sender: TObject);
    procedure ActionCompositionsExecute(Sender: TObject);
    procedure ActionCompositionsUpdate(Sender: TObject);
  private
    FZoneParks: TBisTaxiDataZonesFrameZoneParks;
    FCosts: TBisTaxiDataZonesFrameCosts;
    FCompositions: TBisTaxiDataZonesFrameCompositions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CanZoneParks: Boolean;
    procedure ZoneParks;
    function CanCosts: Boolean;
    procedure Costs;
    function CanCompositions: Boolean;
    procedure Compositions;

  end;

implementation

uses BisProvider, BisUtils;

{$R *.dfm}

{ TBisTaxiDataZonesFrameZoneParks }

function TBisTaxiDataZonesFrameZoneParks.FindById(ZoneId: Variant): TBisTaxiDataZoneParksFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) then begin
      if VarSameValue(TBisTaxiDataZoneParksFormIface(Obj).ZoneId,ZoneId) then begin
        Result:=TBisTaxiDataZoneParksFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

{ TBisTaxiDataZonesFrameCosts }

function TBisTaxiDataZonesFrameCosts.FindById(ZoneId: Variant): TBisTaxiDataCostsFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) then begin
      if VarSameValue(TBisTaxiDataCostsFormIface(Obj).ZoneId,ZoneId) then begin
        Result:=TBisTaxiDataCostsFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

{ TBisTaxiDataZonesFrameCompositions }

function TBisTaxiDataZonesFrameCompositions.FindById(ZoneId: Variant): TBisTaxiDataCompositionsFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) then begin
      if VarSameValue(TBisTaxiDataCompositionsFormIface(Obj).ZoneId,ZoneId) then begin
        Result:=TBisTaxiDataCompositionsFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

{ TBisTaxiDataZonesFrame }

constructor TBisTaxiDataZonesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FZoneParks:=TBisTaxiDataZonesFrameZoneParks.Create;
  FCosts:=TBisTaxiDataZonesFrameCosts.Create;
  FCompositions:=TBisTaxiDataZonesFrameCompositions.Create;
end;

destructor TBisTaxiDataZonesFrame.Destroy;
begin
  FCompositions.Free;
  FCosts.Free;
  FZoneParks.Free;
  inherited Destroy;
end;

procedure TBisTaxiDataZonesFrame.ActionCompositionsExecute(Sender: TObject);
begin
  Compositions;
end;

procedure TBisTaxiDataZonesFrame.ActionCompositionsUpdate(Sender: TObject);
begin
  ActionCompositions.Enabled:=CanCompositions;
end;

procedure TBisTaxiDataZonesFrame.ActionCostsExecute(Sender: TObject);
begin
  Costs;
end;

procedure TBisTaxiDataZonesFrame.ActionCostsUpdate(Sender: TObject);
begin
  ActionCosts.Enabled:=CanCosts;
end;

procedure TBisTaxiDataZonesFrame.ActionZoneParksExecute(Sender: TObject);
begin
  ZoneParks;
end;

procedure TBisTaxiDataZonesFrame.ActionZoneParksUpdate(Sender: TObject);
begin
  ActionZoneParks.Enabled:=CanZoneParks;
end;

function TBisTaxiDataZonesFrame.CanZoneParks: Boolean;
var
  P: TBisProvider;
  Iface: TBisTaxiDataZoneParksFormIface;
begin
  P:=GetCurrentProvider;
  Result:=Assigned(P) and P.Active and not P.IsEmpty;
  if Result then begin
    Iface:=TBisTaxiDataZoneParksFormIface.Create(Self);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisTaxiDataZonesFrame.ZoneParks;
var
  Iface: TBisTaxiDataZoneParksFormIface;
  P: TBisProvider;
  ZoneId: Variant;
  ZoneName: String;
begin
  if CanZoneParks then begin
    P:=GetCurrentProvider;
    ZoneId:=P.FieldByName('ZONE_ID').Value;
    ZoneName:=P.FieldByName('NAME').AsString;
    Iface:=FZoneParks.FindById(ZoneId);
    if not Assigned(Iface) then begin
      Iface:=TBisTaxiDataZoneParksFormIface.Create(Self);
      Iface.ZoneId:=ZoneId;
      Iface.ZoneName:=ZoneName;
      Iface.MaxFormCount:=1;
      FZoneParks.Add(Iface);
      Iface.Init;
    end;
    Iface.Caption:=FormatEx('%s => %s',[ActionZoneParks.Caption,ZoneName]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;
  end;
end;

function TBisTaxiDataZonesFrame.CanCosts: Boolean;
var
  P: TBisProvider;
  Iface: TBisTaxiDataCostsFormIface;
begin
  P:=GetCurrentProvider;
  Result:=Assigned(P) and P.Active and not P.IsEmpty;
  if Result then begin
    Iface:=TBisTaxiDataCostsFormIface.Create(Self);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisTaxiDataZonesFrame.Costs;
var
  Iface: TBisTaxiDataCostsFormIface;
  P: TBisProvider;
  ZoneId: Variant;
  ZoneName: String;
begin
  if CanCosts then begin
    P:=GetCurrentProvider;
    ZoneId:=P.FieldByName('ZONE_ID').Value;
    ZoneName:=P.FieldByName('NAME').AsString;
    Iface:=FCosts.FindById(ZoneId);
    if not Assigned(Iface) then begin
      Iface:=TBisTaxiDataCostsFormIface.Create(Self);
      Iface.ZoneId:=ZoneId;
      Iface.ZoneName:=ZoneName;
      Iface.MaxFormCount:=1;
      FCosts.Add(Iface);
      Iface.Init;
    end;
    Iface.Caption:=FormatEx('%s => %s',[ActionCosts.Caption,ZoneName]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;
  end;
end;

function TBisTaxiDataZonesFrame.CanCompositions: Boolean;
var
  P: TBisProvider;
  Iface: TBisTaxiDataCompositionsFormIface;
begin
  P:=GetCurrentProvider;
  Result:=Assigned(P) and P.Active and not P.IsEmpty;
  if Result then begin
    Iface:=TBisTaxiDataCompositionsFormIface.Create(Self);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisTaxiDataZonesFrame.Compositions;
var
  Iface: TBisTaxiDataCompositionsFormIface;
  P: TBisProvider;
  ZoneId: Variant;
  ZoneName: String;
begin
  if CanCompositions then begin
    P:=GetCurrentProvider;
    ZoneId:=P.FieldByName('ZONE_ID').Value;
    ZoneName:=P.FieldByName('NAME').AsString;
    Iface:=FCompositions.FindById(ZoneId);
    if not Assigned(Iface) then begin
      Iface:=TBisTaxiDataCompositionsFormIface.Create(Self);
      Iface.ZoneId:=ZoneId;
      Iface.ZoneName:=ZoneName;
      Iface.MaxFormCount:=1;
      FCompositions.Add(Iface);
      Iface.Init;
    end;
    Iface.Caption:=FormatEx('%s => %s',[ActionCompositions.Caption,ZoneName]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;
  end;
end;


end.
