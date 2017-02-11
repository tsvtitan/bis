unit BisTaxiDataActionsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  VirtualTrees, VirtualDBTreeEx,
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
//  Available:=true;
  ProviderName:='S_ACTIONS';
  with FieldNames do begin
    AddKey('ACTION_ID');
    AddInvisible('PROC_DETECT');
    AddInvisible('PERIOD');
    AddInvisible('PRIORITY');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',250);
    Add('FONT_COLOR','���� ������',50).Visible:=false;
    Add('BRUSH_COLOR','���� ����',50).Visible:=false;
  end;
  Orders.Add('PRIORITY');
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
  Data: PBisDBTreeNode;
  DataKey: PDBVTData;
  DateKeyFocused: PDBVTData;
  Item: TBisValue;
begin
  Data:=DataFrame.Grid.GetDBNodeData(Node);
  DataKey:=DataFrame.Grid.GetNodeData(Node);
  DateKeyFocused:=DataFrame.Grid.GetNodeData(DataFrame.Grid.FocusedNode);
  if Assigned(Data) and Assigned(DataKey) and Assigned(DateKeyFocused) then begin
    if Assigned(Data.Values) {and (DataKey.Hash<>DateKeyFocused.Hash)}  then begin
      Item:=Data.Values.Find('BRUSH_COLOR');
      if Assigned(Item) and not VarIsEmpty(Item.Value) then begin
        TargetCanvas.Brush.Style:=bsSolid;
        TargetCanvas.Brush.Color:=TColor(VarToIntDef(Item.Value,clWindow));
        TargetCanvas.FillRect(CellRect);
      end;
    end;
  end;
end;

procedure TBisTaxiDataActionsForm.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
                                                  TextType: TVSTTextType);
var
  Data: PBisDBTreeNode;
  DataKey: PDBVTData;
  DateKeyFocused: PDBVTData;
  Item: TBisValue;
  Flag: Boolean;
begin
  Data:=DataFrame.Grid.GetDBNodeData(Node);
  DataKey:=DataFrame.Grid.GetNodeData(Node);
  DateKeyFocused:=DataFrame.Grid.GetNodeData(DataFrame.Grid.FocusedNode);
  if Assigned(Data) and Assigned(DataKey) and Assigned(DateKeyFocused) then begin
    Flag:=((DataKey.Hash=DateKeyFocused.Hash) and (Column<>DataFrame.Grid.FocusedColumn)) or (DataKey.Hash<>DateKeyFocused.Hash);
    if Assigned(Data.Values) and Flag then begin
      Item:=Data.Values.Find('FONT_COLOR');
      if Assigned(Item) and not VarIsEmpty(Item.Value) then begin
        TargetCanvas.Font.Color:=TColor(VarToIntDef(Item.Value,clWindowText));
      end;
    end;
  end;
end;

end.
