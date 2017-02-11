unit BisTaxiDataCompositionsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB, DBCtrls,
  BisFm, BisDataFrm, BisDataGridFm, BisFieldNames, BisFilterGroups, BisDataEditFm,
  BisProvider, BisDataGridFrm;

type
  TBisTaxiDataCompositionsFrame=class(TBisDataGridFrame)
  private
    FZoneName: String;                                                                          
    FZoneId: Variant;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;  
  public
    property ZoneId: Variant read FZoneId write FZoneId;
    property ZoneName: String read FZoneName write FZoneName;
  end;

  TBisTaxiDataCompositionsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataCompositionsFormIface=class(TBisDataGridFormIface)
  private
    FZoneId: Variant;
    FZoneName: String;
    function GetAddress(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    function GetTypeCompositionName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property ZoneId: Variant read FZoneId write FZoneId;
    property ZoneName: String read FZoneName write FZoneName;
  end;

var
  BisTaxiDataCompositionsForm: TBisTaxiDataCompositionsForm;

implementation

{$R *.dfm}

uses DateUtils,
     BisUtils, BisOrders, BisCore, BisDialogs, BisTaxiDataCompositionEditFm,
     BisVariants;

{ TBisTaxiDataCompositionsFrame }

procedure TBisTaxiDataCompositionsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    AIface.Params.ParamByName('ZONE_ID').Value:=FZoneId;
    AIface.Params.ParamByName('ZONE_NAME').Value:=FZoneName;
  end;
end;


{ TBisTaxiDataCompositionsFormIface }

constructor TBisTaxiDataCompositionsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCompositionsForm;
  FilterClass:=TBisTaxiDataCompositionFilterFormIface;
  InsertClass:=TBisTaxiDataCompositionInsertFormIface;
  UpdateClass:=TBisTaxiDataCompositionUpdateFormIface;
  DeleteClass:=TBisTaxiDataCompositionDeleteFormIface;
  Permissions.Enabled:=true;

  ProviderName:='S_COMPOSITIONS';
  with FieldNames do begin
    AddKey('COMPOSITION_ID');
    AddInvisible('ZONE_ID');
    AddInvisible('ZONE_NAME');
    AddInvisible('STREET_ID');
    AddInvisible('STREET_NAME');
    AddInvisible('STREET_PREFIX');
    AddInvisible('LOCALITY_NAME');
    AddInvisible('LOCALITY_PREFIX');
    AddInvisible('TYPE_COMPOSITION');
    AddCalculate('ADDRESS','�����',GetAddress,ftString,1000,200);
    AddCalculate('TYPE_COMPOSITION_NAME','��� �������',GetTypeCompositionName,ftString,100,100);
    Add('HOUSES','������ �����',100);
    Add('EXCEPTIONS','����������',100);
  end;
  Orders.Add('STREET_NAME');
end;

function TBisTaxiDataCompositionsFormIface.GetAddress(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  Args: TBisVariants;
begin
  Result:=Null;
  if DataSet.Active then begin
    Args:=TBisVariants.Create;
    try
      Args.Add(DataSet.FieldByName('STREET_NAME').Value);
      Args.Add(DataSet.FieldByName('LOCALITY_PREFIX').Value);
      Args.Add(DataSet.FieldByName('LOCALITY_NAME').Value);
      Result:=FormatEx('%s, %s%s',Args);
    finally
      Args.Free;
    end;
  end;
end;

function TBisTaxiDataCompositionsFormIface.GetTypeCompositionName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetTypeCompositionByIndex(DataSet.FieldByName('TYPE_COMPOSITION').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;


function TBisTaxiDataCompositionsFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisTaxiDataCompositionsForm(Result) do begin
      DataFrame.Provider.FilterGroups.Add.Filters.Add('ZONE_ID',fcEqual,FZoneId);
      TBisTaxiDataCompositionsFrame(DataFrame).ZoneId:=FZoneId;
      TBisTaxiDataCompositionsFrame(DataFrame).ZoneName:=FZoneName;
    end;
  end;
end;

{ TBisTaxiDataCompositionsForm }

class function TBisTaxiDataCompositionsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataCompositionsFrame;
end;

end.
