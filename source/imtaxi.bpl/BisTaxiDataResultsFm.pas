unit BisTaxiDataResultsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB, DBCtrls,
  VirtualTrees, 
  BisFm, BisDataFrm, BisDataGridFm, BisFieldNames, BisFilterGroups, BisDataEditFm,                      
  BisProvider, BisDataGridFrm;

type
  TBisTaxiDataResultsFrame=class(TBisDataGridFrame)
  private
    FActionName: String;
    FActionId: Variant;
    procedure GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
                                  Column: TColumnIndex; CellRect: TRect);
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;  
  public
    constructor Create(AOwner: TComponent); override;


    property ActionId: Variant read FActionId write FActionId;
    property ActionName: String read FActionName write FActionName;
  end;

  TBisTaxiDataResultsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataResultsFormIface=class(TBisDataGridFormIface)
  private
    FActionId: Variant;
    FActionName: String;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property ActionId: Variant read FActionId write FActionId;
    property ActionName: String read FActionName write FActionName;
  end;

var
  BisTaxiDataResultsForm: TBisTaxiDataResultsForm;

implementation

{$R *.dfm}

uses DateUtils,
     BisUtils, BisOrders, BisCore, BisDialogs, BisTaxiDataResultEditFm, 
     BisVariants, BisDbTree, BisValues;

{ TBisTaxiDataResultsFrame }

procedure TBisTaxiDataResultsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    AIface.Params.ParamByName('ACTION_ID').Value:=FActionId;
    AIface.Params.ParamByName('ACTION_NAME').Value:=FActionName;
  end;
end;


constructor TBisTaxiDataResultsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Grid.OnPaintText:=GridPaintText;
  Grid.OnBeforeCellPaint:=GridBeforeCellPaint;
end;

procedure TBisTaxiDataResultsFrame.GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
                                                       Column: TColumnIndex; CellRect: TRect);
var
  BrushColor: Variant;                                                       
begin
  BrushColor:=Grid.GetNodeValue(Node,'BRUSH_COLOR');
  if not VarIsEmpty(BrushColor) then begin
    TargetCanvas.Brush.Style:=bsSolid;
    TargetCanvas.Brush.Color:=TColor(VarToIntDef(BrushColor,clWindow));
    TargetCanvas.FillRect(CellRect);
  end;
end;

procedure TBisTaxiDataResultsFrame.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
                                                 Column: TColumnIndex; TextType: TVSTTextType);
var
  FontColor: Variant;
  Flag: Boolean;
begin
  Flag:=((Node=Grid.FocusedNode) and (Column<>Grid.FocusedColumn)) or (Node<>Grid.FocusedNode);
  if Flag then begin
    FontColor:=Grid.GetNodeValue(Node,'FONT_COLOR');
    if not VarIsEmpty(FontColor) then
      TargetCanvas.Font.Color:=TColor(VarToIntDef(FontColor,clWindowText));
  end;
end;

{ TBisTaxiDataResultsFormIface }

constructor TBisTaxiDataResultsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataResultsForm;
  FilterClass:=TBisTaxiDataResultFilterFormIface;
  InsertClass:=TBisTaxiDataResultInsertFormIface;
  UpdateClass:=TBisTaxiDataResultUpdateFormIface;
  DeleteClass:=TBisTaxiDataResultDeleteFormIface; 
  Permissions.Enabled:=true;
  ProviderName:='S_RESULTS';
  with FieldNames do begin
    AddKey('RESULT_ID');
    AddInvisible('ACTION_ID');
    AddInvisible('ACTION_NAME');
    AddInvisible('NEXT_ID');
    AddInvisible('NEXT_NAME');
    AddInvisible('PROC_DETECT');
    AddInvisible('PROC_PROCESS');
    AddInvisible('PRIORITY');
    AddInvisible('VISIBLE');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',250);
    Add('FONT_COLOR','���� ������',50).Visible:=false;
    Add('BRUSH_COLOR','���� ����',50).Visible:=false;
  end;
//  Orders.Add('PRIORITY');
end;

function TBisTaxiDataResultsFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisTaxiDataResultsForm(Result) do begin
      DataFrame.Provider.FilterGroups.Add.Filters.Add('ACTION_ID',fcEqual,FActionId);
      TBisTaxiDataResultsFrame(DataFrame).ActionId:=FActionId;
      TBisTaxiDataResultsFrame(DataFrame).ActionName:=FActionName;
    end;
  end;
end;

{ TBisTaxiDataResultsForm }

class function TBisTaxiDataResultsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataResultsFrame;
end;

end.