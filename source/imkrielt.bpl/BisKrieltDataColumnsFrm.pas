unit BisKrieltDataColumnsFrm;
                                                                                                  
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  ExtCtrls, Grids, DBGrids, StdCtrls, Contnrs,

  BisDataGridFrm, BisKrieltDataColumnParamsFm, BisDataEditFm, BisKrieltDataPresentationEditFm;

type
  TBisKrieltDataColumnsFrameIfaces=class(TObjectList)
  public
    function FindColumnById(ColumnId: Variant): TBisKrieltDataColumnParamsFormIface;
  end;

  TBisKrieltDataColumnsFrame = class(TBisDataGridFrame)
    ToolBar1: TToolBar;
    N18: TMenuItem;
    ToolButtonComposition: TToolButton;
    ActionComposition: TAction;
    MenuItemComposition: TMenuItem;
    procedure ActionCompositionExecute(Sender: TObject);
    procedure ActionCompositionUpdate(Sender: TObject);
  private
    FIfaces: TBisKrieltDataColumnsFrameIfaces;
    FPresentationId: Variant;
    FPresentationName: String;
    FPresentationType: TBisKrieltDataPresentationType;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanComposition: Boolean;
    procedure Composition;

    property PresentationId: Variant read FPresentationId write FPresentationId;
    property PresentationName: String read FPresentationName write FPresentationName;
    property PresentationType: TBisKrieltDataPresentationType read FPresentationType write FPresentationType;  

  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisKrieltDataColumnEditFm, BisFilterGroups, BisParam;

{$R *.dfm}

{ TBisKrieltDataColumnsFrameIfaces }

function TBisKrieltDataColumnsFrameIfaces.FindColumnById(ColumnId: Variant): TBisKrieltDataColumnParamsFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisKrieltDataColumnParamsFormIface) then begin
      if VarSameValue(TBisKrieltDataColumnParamsFormIface(Obj).ColumnId,ColumnId) then begin
        Result:=TBisKrieltDataColumnParamsFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

{ TBisKrieltDataColumnsFrame }

constructor TBisKrieltDataColumnsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIfaces:=TBisKrieltDataColumnsFrameIfaces.Create;
end;

destructor TBisKrieltDataColumnsFrame.Destroy;
begin
  FIfaces.Free;
  inherited Destroy;
end;

procedure TBisKrieltDataColumnsFrame.ActionCompositionExecute(Sender: TObject);
begin
  Composition;
end;

procedure TBisKrieltDataColumnsFrame.ActionCompositionUpdate(Sender: TObject);
begin
  ActionComposition.Enabled:=CanComposition;
end;

procedure TBisKrieltDataColumnsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  ParamId: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    ParamId:=AIface.Params.Find('PRESENTATION_ID');
    if Assigned(ParamId) and not VarIsNull(FPresentationId) then begin
      ParamId.Value:=FPresentationId;
      AIface.Params.ParamByName('PRESENTATION_NAME').Value:=FPresentationName;
      ParamId.ExcludeModes(AllParamEditModes);
      if FPresentationType=ptImport then begin
        AIface.Params.ParamByName('ALIGN').ExcludeModes(AllParamEditModes);
        AIface.Params.ParamByName('WIDTH').ExcludeModes(AllParamEditModes);
      end;
    end;
  end;
end;

function TBisKrieltDataColumnsFrame.CanComposition: Boolean;
var
  Iface: TBisKrieltDataColumnParamsFormIface;
begin
  Result:=Provider.Active and not Provider.Empty;
  if Result then begin
    Iface:=TBisKrieltDataColumnParamsFormIface.Create(nil);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisKrieltDataColumnsFrame.Composition;
var
  Iface: TBisKrieltDataColumnParamsFormIface;
  ColumnId: Variant;
  ColumnName: String;
begin
  if CanComposition then begin
    ColumnId:=Provider.FieldByName('COLUMN_ID').Value;
    ColumnName:=Provider.FieldByName('NAME').AsString;
    Iface:=FIfaces.FindColumnById(ColumnId);
    if not Assigned(Iface) then begin
      Iface:=TBisKrieltDataColumnParamsFormIface.Create(Self);
      Iface.ColumnId:=ColumnId;
      Iface.ColumnName:=ColumnName;
      Iface.MaxFormCount:=1;
      Iface.FilterOnShow:=false;
      FIfaces.Add(Iface);
      Iface.Init;
      Iface.FilterGroups.Add.Filters.Add('COLUMN_ID',fcEqual,ColumnId);
    end;
    Iface.Caption:=FormatEx('%s => %s',[ActionComposition.Hint,ColumnName]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;    
  end;
end;

end.
