unit BisTaxiDataCarTypesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  VirtualTrees, VirtualDBTreeEx,
  BisFm, BisDataGridFm, BisDBTree;

type
  TBisTaxiDataCarTypesForm = class(TBisDataGridForm)
  private
    procedure GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
                                  Column: TColumnIndex; CellRect: TRect);
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
                            Column: TColumnIndex; TextType: TVSTTextType);
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCarTypesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCarTypesForm: TBisTaxiDataCarTypesForm;

implementation

{$R *.dfm}

uses BisUtils,
     BisFilterGroups, BisTaxiDataCarTypeEditFm, BisValues;

{ TBisTaxiDataCarTypesFormIface }

constructor TBisTaxiDataCarTypesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCarTypesForm;
  FilterClass:=TBisTaxiDataCarTypeFilterFormIface;
  InsertClass:=TBisTaxiDataCarTypeInsertFormIface;
  UpdateClass:=TBisTaxiDataCarTypeUpdateFormIface;
  DeleteClass:=TBisTaxiDataCarTypeDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_CAR_TYPES';
  with FieldNames do begin
    AddKey('CAR_TYPE_ID');
    AddInvisible('PRIORITY');
    AddInvisible('COST_IDLE');
    Add('NAME','������������',100);
    Add('DESCRIPTION','��������',200);
    Add('RATIO','�����������',50).DisplayFormat:='#0.00';
    Add('FONT_COLOR','���� ������',50).Visible:=false;
    Add('BRUSH_COLOR','���� ����',50).Visible:=false;
  end;
  Orders.Add('PRIORITY');
end;

{ TBisTaxiDataCarTypesForm }

constructor TBisTaxiDataCarTypesForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    with DataFrame do begin
      Grid.OnPaintText:=GridPaintText;
      Grid.OnBeforeCellPaint:=GridBeforeCellPaint;
    end;
  end;
end;

procedure TBisTaxiDataCarTypesForm.GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
                                                        Column: TColumnIndex; CellRect: TRect);
var
  Data: PBisDBTreeNode;
  DataKey: PDBVTData;
  DateKeyFocused: PDBVTData;
  Item: TBisValue;
begin
  Data:=DataFrame.Grid.GetDBNodeData(Node);
  DataKey:=DataFrame.Grid.GetNodeData(Node);
  DateKeyFocused:=DataFrame.Grid.GetNodeData(DataFrame.Grid.FocusedNode);
  if Assigned(Data) and Assigned(DataKey) and Assigned(DateKeyFocused) then begin
    if Assigned(Data.Values) and (DataKey.Hash<>DateKeyFocused.Hash)  then begin
      Item:=Data.Values.Find('BRUSH_COLOR');
      if Assigned(Item) and not VarIsNull(Item.Value) then begin
        TargetCanvas.Brush.Style:=bsSolid;
        TargetCanvas.Brush.Color:=TColor(VarToIntDef(Item.Value,clWindow));
        TargetCanvas.FillRect(CellRect);
      end;
    end;
  end;
end;

procedure TBisTaxiDataCarTypesForm.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
                                                  TextType: TVSTTextType);
var
  Data: PBisDBTreeNode;
  DataKey: PDBVTData;
  DateKeyFocused: PDBVTData;
  Item: TBisValue;
begin
  Data:=DataFrame.Grid.GetDBNodeData(Node);
  DataKey:=DataFrame.Grid.GetNodeData(Node);
  DateKeyFocused:=DataFrame.Grid.GetNodeData(DataFrame.Grid.FocusedNode);
  if Assigned(Data) and Assigned(DataKey) and Assigned(DateKeyFocused) then begin
    if Assigned(Data.Values) and (DataKey.Hash<>DateKeyFocused.Hash)  then begin
      Item:=Data.Values.Find('FONT_COLOR');
      if Assigned(Item) and not VarIsNull(Item.Value) then begin
        TargetCanvas.Font.Color:=TColor(VarToIntDef(Item.Value,clWindowText));
      end;
    end;
  end;
end;

end.
