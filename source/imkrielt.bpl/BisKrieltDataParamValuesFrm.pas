unit BisKrieltDataParamValuesFrm;
                                                                                                      
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  ExtCtrls, Grids, DBGrids, StdCtrls, Contnrs,

  BisDataGridFrm, BisDataEditFm,
  BisKrieltDataParamValueDependsFm;

type
  TBisKrieltDataParamValuesFrameIfaces=class(TObjectList)
  public
    function FindParamValueById(ParamValueId: Variant): TBisKrieltDataParamValueDependsFormIface;
  end;

  TBisKrieltDataParamValuesFrame = class(TBisDataGridFrame)
    ToolBar1: TToolBar;
    N18: TMenuItem;
    ToolButtonDependend: TToolButton;
    ActionDependend: TAction;
    MenuItemDependend: TMenuItem;
    procedure ActionDependendExecute(Sender: TObject);
    procedure ActionDependendUpdate(Sender: TObject);
  private
    FIfaces: TBisKrieltDataParamValuesFrameIfaces;
    FParamName: String;
    FParamId: Variant;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanDependend: Boolean;
    procedure Dependend;

    property ParamId: Variant read FParamId write FParamId;
    property ParamName: String read FParamName write FParamName;
  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisKrieltDataColumnEditFm, BisFilterGroups, BisParam;

{$R *.dfm}

{ TBisKrieltDataParamValuesFrameIfaces }

function TBisKrieltDataParamValuesFrameIfaces.FindParamValueById(ParamValueId: Variant): TBisKrieltDataParamValueDependsFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisKrieltDataParamValueDependsFormIface) then begin
      if VarSameValue(TBisKrieltDataParamValueDependsFormIface(Obj).ParamValueId,ParamValueId) then begin
        Result:=TBisKrieltDataParamValueDependsFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

{ TBisKrieltDataColumnsFrame }

constructor TBisKrieltDataParamValuesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIfaces:=TBisKrieltDataParamValuesFrameIfaces.Create;
end;

destructor TBisKrieltDataParamValuesFrame.Destroy;
begin
  FIfaces.Free;
  inherited Destroy;
end;

procedure TBisKrieltDataParamValuesFrame.ActionDependendExecute(Sender: TObject);
begin
  Dependend;
end;

procedure TBisKrieltDataParamValuesFrame.ActionDependendUpdate(Sender: TObject);
begin
  ActionDependend.Enabled:=CanDependend;
end;

procedure TBisKrieltDataParamValuesFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  ParamId: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    ParamId:=AIface.Params.Find('PARAM_ID');
    if Assigned(ParamId) and not VarIsNull(FParamId) then begin
      ParamId.Value:=FParamId;
      AIface.Params.ParamByName('PARAM_NAME').Value:=FParamName;
      ParamId.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

function TBisKrieltDataParamValuesFrame.CanDependend: Boolean;
var
  Iface: TBisKrieltDataParamValueDependsFormIface;  
begin
  Result:=Provider.Active and not Provider.Empty;
  if Result then begin
    Iface:=TBisKrieltDataParamValueDependsFormIface.Create(nil);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisKrieltDataParamValuesFrame.Dependend;
var
  Iface: TBisKrieltDataParamValueDependsFormIface;
  ParamId: Variant;
  ParamName: String;
  ParamValueId: Variant;
  ParamValueName: String;
begin
  if CanDependend then begin
    ParamId:=Provider.FieldByName('PARAM_ID').Value;
    ParamName:=Provider.FieldByName('PARAM_NAME').AsString;
    ParamValueId:=Provider.FieldByName('PARAM_VALUE_ID').Value;
    ParamValueName:=Provider.FieldByName('NAME').AsString;
    Iface:=FIfaces.FindParamValueById(ParamValueId);
    if not Assigned(Iface) then begin
      Iface:=TBisKrieltDataParamValueDependsFormIface.Create(Self);
      Iface.ParamId:=ParamId;
      Iface.ParamName:=ParamName;
      Iface.ParamValueId:=ParamValueId;
      Iface.ParamValueName:=ParamValueName;
      Iface.MaxFormCount:=1;
      Iface.FilterOnShow:=false;
      FIfaces.Add(Iface);
      Iface.Init;
      Iface.FilterGroups.Add.Filters.Add('WHAT_PARAM_VALUE_ID',fcEqual,ParamValueId);
    end;
    Iface.Caption:=FormatEx('%s => %s',[ActionDependend.Caption,ParamValueName]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;   
  end;
end;

end.
