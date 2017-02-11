unit BisTaxiDataCarTypesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  VirtualTrees, 
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
  ProviderName:='S_CAR_TYPES';
  with FieldNames do begin
    AddKey('CAR_TYPE_ID');
    AddInvisible('PRIORITY');
    AddInvisible('COST_IDLE');
    Add('NAME','������������',80);
    Add('DESCRIPTION','��������',190);
    Add('RATIO','�����������',50).DisplayFormat:='#0.00';
    AddCheckBox('VISIBLE','���������',30);
    Add('FONT_COLOR','���� ������',50).Visible:=false;
    Add('BRUSH_COLOR','���� ����',50).Visible:=false;
  end;
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
  Data: PBisDBTreeNodeData;
  Index: Integer;
begin
  Data:=DataFrame.Grid.GetNodeData(Node);
  if Assigned(Data) then begin
    Index:=DataFrame.Grid.GetValueIndex('BRUSH_COLOR');
    if Index<>-1 then begin
      if not VarIsNull(Data.Values[Index]) then begin
        TargetCanvas.Brush.Style:=bsSolid;
        TargetCanvas.Brush.Color:=TColor(VarToIntDef(Data.Values[Index],clWindow));
        TargetCanvas.FillRect(CellRect);
      end;
    end;
  end;
end;

procedure TBisTaxiDataCarTypesForm.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
                                                  TextType: TVSTTextType);
var
  Data, DataFocused: PBisDBTreeNodeData;
  Flag: Boolean;
  Index: Integer;
begin
  Data:=DataFrame.Grid.GetNodeData(Node);
  DataFocused:=DataFrame.Grid.GetNodeData(DataFrame.Grid.FocusedNode);
  if Assigned(Data) and Assigned(DataFocused) then begin
    Flag:=(ArraySameValues(Data.KeyValues,DataFocused.KeyValues) and (Column<>DataFrame.Grid.FocusedColumn)) or
           not ArraySameValues(Data.KeyValues,DataFocused.KeyValues);
    if Flag then begin
      Index:=DataFrame.Grid.GetValueIndex('FONT_COLOR');
      if Index<>-1 then begin
        if not VarIsEmpty(Data.Values[Index]) then
          TargetCanvas.Font.Color:=TColor(VarToIntDef(Data.Values[Index],clWindowText));
      end;
    end;
  end
end;

end.