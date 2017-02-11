unit BisKrieltDataViewsFrm;

interface                                                                                              

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  ExtCtrls, Grids, DBGrids, StdCtrls, Contnrs,

  BisDataGridFrm, BisKrieltDataViewTypesFm;

type
  TBisKrieltDataViewsFrameIfaces=class(TObjectList)
  public
    function FindViewById(ViewId: Variant): TBisKrieltDataViewTypesFormIface;
  end;

  TBisKrieltDataViewsFrame = class(TBisDataGridFrame)
    ToolBar1: TToolBar;
    N18: TMenuItem;
    ToolButtonComposition: TToolButton;
    ActionComposition: TAction;
    MenuItemComposition: TMenuItem;
    procedure ActionCompositionExecute(Sender: TObject);
    procedure ActionCompositionUpdate(Sender: TObject);
  private
    FIfaces: TBisKrieltDataViewsFrameIfaces;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanComposition: Boolean;
    procedure Composition;
  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisKrieltDataColumnEditFm, BisFilterGroups;

{$R *.dfm}

{ TBisKrieltDataViewsFrameIfaces }

function TBisKrieltDataViewsFrameIfaces.FindViewById(ViewId: Variant): TBisKrieltDataViewTypesFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisKrieltDataViewTypesFormIface) then begin
      if VarSameValue(TBisKrieltDataViewTypesFormIface(Obj).ViewId,ViewId) then begin
        Result:=TBisKrieltDataViewTypesFormIface(Obj);
        exit;
      end; 
    end;
  end;
end;

{ TBisKrieltDataColumnsFrame }

constructor TBisKrieltDataViewsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIfaces:=TBisKrieltDataViewsFrameIfaces.Create;
end;

destructor TBisKrieltDataViewsFrame.Destroy;
begin
  FIfaces.Free;
  inherited Destroy;
end;

procedure TBisKrieltDataViewsFrame.ActionCompositionExecute(Sender: TObject);
begin
  Composition;
end;

procedure TBisKrieltDataViewsFrame.ActionCompositionUpdate(Sender: TObject);
begin
  ActionComposition.Enabled:=CanComposition;
end;

function TBisKrieltDataViewsFrame.CanComposition: Boolean;
var
  Iface: TBisKrieltDataViewTypesFormIface;
begin
  Result:=Provider.Active and not Provider.Empty;
  if Result then begin
    Iface:=TBisKrieltDataViewTypesFormIface.Create(nil);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisKrieltDataViewsFrame.Composition;
var
  Iface: TBisKrieltDataViewTypesFormIface;
  ViewId: Variant;
  ViewName: String;
  ViewNum: String;
begin
  if CanComposition then begin
    ViewId:=Provider.FieldByName('VIEW_ID').Value;
    ViewName:=Provider.FieldByName('NAME').AsString;
    ViewNum:=Provider.FieldByName('NUM').AsString;
    Iface:=FIfaces.FindViewById(ViewId);
    if not Assigned(Iface) then begin
      Iface:=TBisKrieltDataViewTypesFormIface.Create(Self);
      Iface.ViewId:=ViewId;
      Iface.ViewName:=ViewName;
      Iface.ViewNum:=ViewNum;
      Iface.MaxFormCount:=1;
      Iface.FilterOnShow:=false;
      FIfaces.Add(Iface);
      Iface.Init;
      Iface.LoadOptions;
      Iface.FilterGroups.Add.Filters.Add('VIEW_ID',fcEqual,ViewId);
    end;
    Iface.Caption:=FormatEx('%s => %s',[ActionComposition.Hint,ViewName]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;    
  end;
end;

end.
