unit BisTaxiHistoryFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids,
  VirtualTrees, 
  BisDataGridFrm, BisFieldNames, BisDBTree;                                                         

type
  TBisTaxiHistoryFrame = class(TBisDataGridFrame)
  private
    function GetTimeProcess(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    procedure GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
                                  Column: TColumnIndex; CellRect: TRect);
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
                            Column: TColumnIndex; TextType: TVSTTextType);
    procedure GridGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
                                var Ghosted: Boolean; var ImageIndex: Integer);                            
    function GetNewDriverName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
    procedure EnableControls(AEnabled: Boolean); override;

  end;

implementation

uses BisValues, BisUtils;

{$R *.dfm}

{ TBisTaxiHistoryFrame }

constructor TBisTaxiHistoryFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ActionFilter.Visible:=false;
  ActionView.Visible:=false;
  ActionInsert.Visible:=false;             
  ActionDuplicate.Visible:=false;
  ActionUpdate.Visible:=false;
  ActionDelete.Visible:=false;
  LabelCounter.Visible:=true;

  with Provider do begin
    ProviderName:='S_ORDERS';
    with FieldNames do begin
      AddKey('ORDER_ID');
      AddInvisible('CAR_CALLSIGN');
      AddInvisible('DRIVER_USER_NAME');
      AddInvisible('DRIVER_SURNAME');
      AddInvisible('DRIVER_NAME');
      AddInvisible('DRIVER_PATRONYMIC');
      Add('DATE_HISTORY','���� �������',130);
      Add('WHO_HISTORY','��� ������ �������',100);
      AddCalculate('TIME_PROCESS','����� ���������',GetTimeProcess,ftDateTime,0,60).DisplayFormat:='hh:nn.ss';
      Add('ACTION_NAME','��������',140);
      Add('RESULT_NAME','���������',140);
      Add('DATE_BEGIN','����� ������',110);
      Add('DATE_END','����� ���������',110);
      Add('WHO_PROCESS','��� ���������',100);
      Add('COST_GROSS','�����',45).DisplayFormat:='#0.00';
      Add('COST_RATE','����',45).DisplayFormat:='#0.00';
      Add('COST_FACT','��������',45).DisplayFormat:='#0.00';
      AddCalculate('NEW_DRIVER_NAME','��������',GetNewDriverName,ftString,150,100);
      
      Add('ACTION_BRUSH_COLOR','���� ���� ��������',50).Visible:=false;
      Add('ACTION_FONT_COLOR','���� ������ ��������',50).Visible:=false;
      Add('RESULT_BRUSH_COLOR','���� ���� ����������',50).Visible:=false;
      Add('RESULT_FONT_COLOR','���� ������ ����������',50).Visible:=false;
      Add('TYPE_PROCESS','��� ���������',20).Visible:=false;
    end;
//    Orders.Add('DATE_HISTORY');
    Orders.Add('DATE_BEGIN');
  end;

  Grid.OnPaintText:=GridPaintText;
  Grid.OnBeforeCellPaint:=GridBeforeCellPaint;
  Grid.OnGetImageIndex:=GridGetImageIndex;
end;

procedure TBisTaxiHistoryFrame.EnableControls(AEnabled: Boolean);
begin
  inherited EnableControls(AEnabled);
end;

function TBisTaxiHistoryFrame.GetNewDriverName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S1, S2, S3, S4: String;
begin
  Result:=Null;
  if DataSet.Active then begin
    S1:=DataSet.FieldByName('DRIVER_USER_NAME').AsString;
    S2:=DataSet.FieldByName('DRIVER_SURNAME').AsString;
    S3:=DataSet.FieldByName('DRIVER_NAME').AsString;
    S4:=DataSet.FieldByName('DRIVER_PATRONYMIC').AsString;
    Result:=FormatEx('%s - %s %s',[S1,S2,S3,S4]);
    if Trim(Result)='-' then
      Result:=Null;
  end;
end;

function TBisTaxiHistoryFrame.GetTimeProcess(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  FieldDateBegin: TField;
  FieldDateEnd: TField;
begin
  Result:=Null;
  FieldDateBegin:=DataSet.FieldByName('DATE_BEGIN');
  FieldDateEnd:=DataSet.FieldByName('DATE_END');
  if not VarIsNull(FieldDateBegin.Value) and not VarIsNull(FieldDateEnd.Value) then begin
    Result:=FieldDateEnd.AsDateTime-FieldDateBegin.AsDateTime;
  end;
end;

procedure TBisTaxiHistoryFrame.GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
                                                   Column: TColumnIndex; CellRect: TRect);
var
  ActionColor: Variant;
  ResultColor: Variant;
  AColor: TColor;
begin
  ActionColor:=Grid.GetNodeValue(Node,'ACTION_BRUSH_COLOR');
  ResultColor:=Grid.GetNodeValue(Node,'RESULT_BRUSH_COLOR');
  AColor:=TColor(VarToIntDef(ActionColor,clWindow));
  if not VarIsNull(ResultColor) then
    AColor:=TColor(VarToIntDef(ResultColor,clWindow));
  TargetCanvas.Brush.Style:=bsSolid;
  TargetCanvas.Brush.Color:=AColor;
  TargetCanvas.FillRect(CellRect);
end;

procedure TBisTaxiHistoryFrame.GridGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
                                                 var Ghosted: Boolean; var ImageIndex: Integer);
var
  TypeProcess: Integer;
begin
 if (Column=1) then begin
    TypeProcess:=VarToIntDef(Grid.GetNodeValue(Node,'TYPE_PROCESS'),1);
    if TypeProcess=0 then
      ImageIndex:=16
    else ImageIndex:=17;
 end;
end;

procedure TBisTaxiHistoryFrame.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
                                             Column: TColumnIndex; TextType: TVSTTextType);
var
  ActionColor: Variant;
  ResultColor: Variant;
  AColor: TColor;
  Flag: Boolean;
begin
  Flag:=((Node=Grid.FocusedNode) and (Column<>Grid.FocusedColumn)) or (Node<>Grid.FocusedNode);
  if Flag then begin
    ActionColor:=Grid.GetNodeValue(Node,'ACTION_FONT_COLOR');
    ResultColor:=Grid.GetNodeValue(Node,'RESULT_FONT_COLOR');
    AColor:=TColor(VarToIntDef(ActionColor,clWindowText));
    if not VarIsNull(ResultColor) then
      AColor:=TColor(VarToIntDef(ResultColor,clWindowText));
    TargetCanvas.Font.Color:=AColor;
  end;
end;

end.