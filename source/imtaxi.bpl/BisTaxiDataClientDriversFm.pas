unit BisTaxiDataClientDriversFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DB,
  VirtualTrees,
  BisDataFrm, BisDataGridFrm, BisDataGridFm, BisDataEditFm, BisFieldNames;

type
  TBisTaxiDataClientDriversFrame=class(TBisDataGridFrame)
  private
    FClientId: Variant;
    FUserName: String;
    function GetKindName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;

    property ClientId: Variant read FClientId write FClientId;
    property UserName: String read FUserName write FUserName;
  end;

  TBisTaxiDataClientDriversForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataClientDriversFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataClientDriversForm: TBisTaxiDataClientDriversForm;

implementation

uses BisUtils, BisTaxiDataClientDriverEditFm, BisConsts, BisParam;

{$R *.dfm}

{ TBisTaxiDataClientDriversFrame }

constructor TBisTaxiDataClientDriversFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FilterClass:=TBisTaxiDataClientDriverFilterFormIface;
  InsertClass:=TBisTaxiDataClientDriverInsertFormIface;
  UpdateClass:=TBisTaxiDataClientDriverUpdateFormIface;
  DeleteClass:=TBisTaxiDataClientDriverDeleteFormIface;
  with Provider do begin
    ProviderName:='S_CLIENT_DRIVERS';
    with FieldNames do begin
      AddInvisible('CLIENT_ID').IsKey:=true;
      AddInvisible('DRIVER_ID').IsKey:=true;
      AddInvisible('PRIORITY');
      AddInvisible('DESCRIPTION');
      Add('DATE_CREATE','���� ��������',110);
      Add('CLIENT_USER_NAME','������',110);
      Add('DRIVER_USER_NAME','��������',110);
      AddCalculate('KIND_NAME','��� ������',GetKindName,ftString,100,120);
      Add('KIND','���',0).Visible:=false;
    end;
  end;

  Grid.OnPaintText:=GridPaintText;
  
  FClientId:=Null;
end;

function TBisTaxiDataClientDriversFrame.GetKindName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
begin
  Result:=Null;
  if DataSet.Active then
    Result:=GetKindNameByIndex(DataSet.FieldByName('KIND').AsInteger);
end;

procedure TBisTaxiDataClientDriversFrame.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                                                       Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Kind: TBisTaxiDataClientDriverKind;                                                       
begin
  if (Node<>Sender.FocusedNode) or ((Node=Sender.FocusedNode) and (Column<>Sender.FocusedColumn)) then begin
    Kind:=TBisTaxiDataClientDriverKind(Grid.GetNodeValue(Node,'KIND'));
    case Kind of
      dkWhite: TargetCanvas.Font.Color:=clGreen;
      dkBlack: TargetCanvas.Font.Color:=clRed;
    end;
  end;
end;

procedure TBisTaxiDataClientDriversFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  Param: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    with AIface.Params do begin
      ParamByName('CLIENT_USER_NAME').Value:=FUserName;
      Param:=ParamByName('CLIENT_ID');
      Param.Value:=FClientId;
      if not Param.Empty then
        Param.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

{ TBisTaxiDataClientDriversFormIface }

constructor TBisTaxiDataClientDriversFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataClientDriversForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisTaxiDataClientDriversForm }

class function TBisTaxiDataClientDriversForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataClientDriversFrame;
end;

end.
