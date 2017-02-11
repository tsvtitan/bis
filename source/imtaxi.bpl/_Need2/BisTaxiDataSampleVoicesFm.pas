unit BisTaxiDataSampleVoicesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DB,
  BisDataGridFm, BisFieldNames, BisDataFrm;

type                                                                                                      
  TBisTaxiDataSampleVoicesForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataSampleVoicesFormIface=class(TBisDataGridFormIface)
  private
    function GetTypeSampleName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataSampleVoicesForm: TBisTaxiDataSampleVoicesForm;

implementation

{$R *.dfm}

uses BisUtils, BisConsts,
     BisTaxiDataSampleVoiceEditFm, BisTaxiDataSampleVoicesFrm;

{ TBisTaxiDataSampleVoicesFormIface }

constructor TBisTaxiDataSampleVoicesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataSampleVoicesForm;
  FilterClass:=TBisTaxiDataSampleVoiceFilterFormIface;
  InsertClass:=TBisTaxiDataSampleVoiceInsertFormIface;
  UpdateClass:=TBisTaxiDataSampleVoiceUpdateFormIface;
  DeleteClass:=TBisTaxiDataSampleVoiceDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_SAMPLE_VOICES';
  with FieldNames do begin
    AddKey('SAMPLE_VOICE_ID');
    AddInvisible('DESCRIPTION');
    AddInvisible('TYPE_SAMPLE');
    AddCalculate('TYPE_SAMPLE_NAME','��� �������',GetTypeSampleName,ftString,10,60);
    Add('SAMPLE_TEXT','�����',240);
    Add('PRIORITY','�������',50);
  end;
end;

function TBisTaxiDataSampleVoicesFormIface.GetTypeSampleName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetTypeSampleByIndex(DataSet.FieldByName('TYPE_SAMPLE').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;

{ TBisTaxiDataSampleVoicesForm }

class function TBisTaxiDataSampleVoicesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataSampleVoicesFrame;
end;

end.
