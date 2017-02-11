unit BisTaxiDataActionsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids, Contnrs,
  BisDataFrm, BisDataGridFrm, BisTaxiDataResultsFm;

type

  TBisTaxiDataActionsFrameResults=class(TObjectList)
  public
    function FindById(ActionId: Variant): TBisTaxiDataResultsFormIface;
  end;

  TBisTaxiDataActionsFrame = class(TBisDataGridFrame)
    ToolBar1: TToolBar;
    ToolButtonResults: TToolButton;
    ActionResults: TAction;
    N13: TMenuItem;
    MenuItemResults: TMenuItem;
    procedure ActionResultsExecute(Sender: TObject);
    procedure ActionResultsUpdate(Sender: TObject);
  private
    FResults: TBisTaxiDataActionsFrameResults;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CanResults: Boolean;
    procedure Results;

  end;

implementation

uses BisProvider, BisUtils;

{$R *.dfm}

{ TBisTaxiDataActionsFrameResults }

function TBisTaxiDataActionsFrameResults.FindById(ActionId: Variant): TBisTaxiDataResultsFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) then begin
      if VarSameValue(TBisTaxiDataResultsFormIface(Obj).ActionId,ActionId) then begin
        Result:=TBisTaxiDataResultsFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

{ TBisTaxiDataActionsFrame }

constructor TBisTaxiDataActionsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FResults:=TBisTaxiDataActionsFrameResults.Create;
end;

destructor TBisTaxiDataActionsFrame.Destroy;
begin
  FResults.Free;
  inherited Destroy;
end;

procedure TBisTaxiDataActionsFrame.ActionResultsExecute(Sender: TObject);
begin
  Results;
end;

procedure TBisTaxiDataActionsFrame.ActionResultsUpdate(Sender: TObject);
begin
  ActionResults.Enabled:=CanResults;
end;

function TBisTaxiDataActionsFrame.CanResults: Boolean;
var
  P: TBisProvider;
  Iface: TBisTaxiDataResultsFormIface;
begin
  P:=GetCurrentProvider;
  Result:=Assigned(P) and P.Active and not P.IsEmpty;
  if Result then begin
    Iface:=TBisTaxiDataResultsFormIface.Create(Self);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisTaxiDataActionsFrame.Results;
var
  Iface: TBisTaxiDataResultsFormIface;
  P: TBisProvider;
  ActionId: Variant;
  ActionName: String;
begin
  if CanResults then begin
    P:=GetCurrentProvider;
    ActionId:=P.FieldByName('ACTION_ID').Value;
    ActionName:=P.FieldByName('NAME').AsString;
    Iface:=FResults.FindById(ActionId);
    if not Assigned(Iface) then begin
      Iface:=TBisTaxiDataResultsFormIface.Create(Self);
      Iface.ActionId:=ActionId;
      Iface.ActionName:=ActionName;
      Iface.MaxFormCount:=1;
      FResults.Add(Iface);
      Iface.Init;
    end;
    Iface.Caption:=FormatEx('%s => %s',[ActionResults.Caption,ActionName]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;
  end;
end;


end.
