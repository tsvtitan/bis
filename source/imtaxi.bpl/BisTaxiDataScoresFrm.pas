unit BisTaxiDataScoresFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids,
  VirtualTrees,           
  BisDataFrm, BisDataGridFrm, BisDataEditFm, BisFieldNames;

type
  TBisTaxiDataScoresFrame = class(TBisDataGridFrame)
    PanelBottom: TPanel;
    LabelSum: TLabel;
  private
    FDriverId: Variant;
    FDriverUserName: String;
    FDriverPatronymic: Variant;
    FDriverName: Variant;
    FDriverSurname: Variant;
    procedure SetAmountSum;
    procedure AfterChangeData(Sender: TBisDataFrame);
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
    procedure DoAfterOpenRecords; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OpenRecords; override;

    property DriverId: Variant read FDriverId write FDriverId;
    property DriverUserName: String read FDriverUserName write FDriverUserName;
    property DriverSurname: Variant read FDriverSurname write FDriverSurname;
    property DriverName: Variant read FDriverName write FDriverName;
    property DriverPatronymic: Variant read FDriverPatronymic write FDriverPatronymic;
  end;

implementation

uses BisUtils, BisConsts, BisParam,
     BisTaxiDataScoreEditFm, BisTaxiDataScoreFilterFm;

{$R *.dfm}

{ TBisTaxiDataScoresFrame }

constructor TBisTaxiDataScoresFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FilterClass:=TBisTaxiDataScoreFilterFormIface;
  InsertClass:=TBisTaxiDataScoreInsertFormIface;
  UpdateClass:=TBisTaxiDataScoreUpdateFormIface;
  DeleteClass:=TBisTaxiDataScoreDeleteFormIface;
  with Provider do begin
    ProviderName:='S_SCORES';
    with FieldNames do begin
      AddKey('SCORE_ID');
      AddInvisible('DRIVER_ID');
      AddInvisible('RATING_ID');
      AddInvisible('CREATOR_ID');
      AddInvisible('CREATOR_USER_NAME');
      AddInvisible('DESCRIPTION');
      Add('DATE_CREATE','���� ��������',110);
      Add('DRIVER_USER_NAME','��������',110);
      Add('RATING_NAME','��� ������',150);
      Add('AMOUNT','�����',50);
    end;
  end;
  OnAfterInsertRecord:=AfterChangeData;
  OnAfterDuplicateRecord:=AfterChangeData;
  OnAfterUpdateRecord:=AfterChangeData;
  OnAfterDeleteRecord:=AfterChangeData;
  OnAfterFilterRecords:=AfterChangeData;

  Grid.OnPaintText:=GridPaintText;
  
  FDriverId:=Null;
end;

procedure TBisTaxiDataScoresFrame.DoAfterOpenRecords;
begin
  inherited DoAfterOpenRecords;
  SetAmountSum;
end;

procedure TBisTaxiDataScoresFrame.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                                                       Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Amount: Variant;
  V: Integer;
begin
  if (Node<>Sender.FocusedNode) or ((Node=Sender.FocusedNode) and (Column<>Sender.FocusedColumn)) then begin
    Amount:=Grid.GetNodeValue(Node,'AMOUNT');
    if not VarIsNull(Amount) then begin
      V:=VarToIntDef(Amount,0);
      if V>0 then
        TargetCanvas.Font.Color:=clGreen
      else if V<0 then
        TargetCanvas.Font.Color:=clRed;
    end;
  end;
end;

procedure TBisTaxiDataScoresFrame.OpenRecords;
begin
  inherited OpenRecords;
end;

procedure TBisTaxiDataScoresFrame.SetAmountSum;

  function GetSum: Integer;
  var
    Field: TField;
  begin
    Result:=0;
    if Provider.Active then begin
      Provider.BeginUpdate(true);
      try
        Provider.First;
        while not Provider.Eof do begin
          Field:=Provider.FieldByName('AMOUNT');
          Result:=Result+Field.AsInteger;
          Provider.Next;
        end;
      finally
        Provider.EndUpdate(true);
      end;
    end;
  end;

begin
  LabelSum.Caption:=IntToStr(GetSum);
end;

procedure TBisTaxiDataScoresFrame.AfterChangeData(Sender: TBisDataFrame);
begin
  SetAmountSum;
end;

procedure TBisTaxiDataScoresFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  Param: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    with AIface.Params do begin
      ParamByName('DRIVER_USER_NAME').Value:=FDriverUserName;
      Param:=ParamByName('DRIVER_ID');
      Param.Value:=FDriverId;
      if not Param.Empty then
        Param.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

end.
