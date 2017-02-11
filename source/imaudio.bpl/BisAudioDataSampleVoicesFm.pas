unit BisAudioDataSampleVoicesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DB,
  BisDataGridFm, BisFieldNames, BisDataFrm;

type                                                                                                      
  TBisAudioDataSampleVoicesForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisAudioDataSampleVoicesFormIface=class(TBisDataGridFormIface)
  private
    function GetTypeSampleName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisAudioDataSampleVoicesForm: TBisAudioDataSampleVoicesForm;

implementation

{$R *.dfm}

uses BisUtils, BisConsts,
     BisAudioDataSampleVoiceEditFm, BisAudioDataSampleVoicesFrm;

{ TBisAudioDataSampleVoicesFormIface }

constructor TBisAudioDataSampleVoicesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisAudioDataSampleVoicesForm;
  FilterClass:=TBisAudioDataSampleVoiceFilterFormIface;
  InsertClass:=TBisAudioDataSampleVoiceInsertFormIface;
  UpdateClass:=TBisAudioDataSampleVoiceUpdateFormIface;
  DeleteClass:=TBisAudioDataSampleVoiceDeleteFormIface;
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

function TBisAudioDataSampleVoicesFormIface.GetTypeSampleName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetTypeSampleByIndex(DataSet.FieldByName('TYPE_SAMPLE').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;

{ TBisAudioDataSampleVoicesForm }

class function TBisAudioDataSampleVoicesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisAudioDataSampleVoicesFrame;
end;

end.