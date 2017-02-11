unit BisTaxiDataActionsFm;

interface

uses                                                                                                              
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  VirtualTrees, 
  BisDataFrm, BisDataGridFm, BisDBTree;

type
  TBisTaxiDataActionsForm = class(TBisDataGridForm)
  private
    procedure GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
                                  Column: TColumnIndex; CellRect: TRect);
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataActionsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataActionsForm: TBisTaxiDataActionsForm;

implementation

{$R *.dfm}

uses BisUtils,
     BisFilterGroups, BisTaxiDataActionEditFm, BisValues, BisTaxiDataActionsFrm;

{ TBisTaxiDataActionsFormIface }

constructor TBisTaxiDataActionsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataActionsForm;
  FilterClass:=TBisTaxiDataActionFilterFormIface;
  InsertClass:=TBisTaxiDataActionInsertFormIface;
  UpdateClass:=TBisTaxiDataActionUpdateFormIface;
  DeleteClass:=TBisTaxiDataActionDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_ACTIONS';
  with FieldNames do begin
    AddKey('ACTION_ID');
    AddInvisible('PROC_DETECT');
    AddInvisible('PERIOD');
    AddInvisible('PRIORITY');
    Add('NAME','Наименование',150);
    Add('DESCRIPTION','Описание',250);
    Add('FONT_COLOR','Цвет шрифта',50).Visible:=false;
    Add('BRUSH_COLOR','Цвет фона',50).Visible:=false;
  end;
end;

{ TBisTaxiDataActionsForm }

constructor TBisTaxiDataActionsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    with DataFrame do begin
      Grid.OnPaintText:=GridPaintText;
      Grid.OnBeforeCellPaint:=GridBeforeCellPaint;
    end;
  end;
end;

class function TBisTaxiDataActionsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataActionsFrame;
end;

procedure TBisTaxiDataActionsForm.GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
                                                       Column: TColumnIndex; CellRect: TRect);
var
  Data: PBisDBTreeNodeData;
  Index: Integer;
begin
  Data:=DataFrame.Grid.GetNodeData(Node);
  if Assigned(Data) then begin
    Index:=DataFrame.Grid.GetValueIndex('BRUSH_COLOR');
    if Index<>-1 then begin
      if not VarIsEmpty(Data.Values[Index]) then begin
        TargetCanvas.Brush.Style:=bsSolid;
        TargetCanvas.Brush.Color:=TColor(VarToIntDef(Data.Values[Index],clWindow));
        TargetCanvas.FillRect(CellRect);
      end;
    end;
  end;
end;

procedure TBisTaxiDataActionsForm.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                                                Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
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
