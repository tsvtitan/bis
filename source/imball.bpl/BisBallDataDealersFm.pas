unit BisBallDataDealersFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  BisDataGridFm, BisFieldNames;

type
  TBisBallDataDealersForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisBallDataDealersFormIface=class(TBisDataGridFormIface)
  private
    function GetPaymentTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisBallDataDealersForm: TBisBallDataDealersForm;

implementation

uses BisBallDataDealerEditFm;

{$R *.dfm}

{ TBisBallDataDealersFormIface }

constructor TBisBallDataDealersFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisBallDataDealersForm;
  FilterClass:=TBisBallDataDealerEditFormIface;
  InsertClass:=TBisBallDataDealerInsertFormIface;
  UpdateClass:=TBisBallDataDealerUpdateFormIface;
  DeleteClass:=TBisBallDataDealerDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_DEALERS';
  with FieldNames do begin
    AddKey('DEALER_ID');
    AddInvisible('FAX');
    AddInvisible('EMAIL');
    AddInvisible('SITE');
    AddInvisible('DIRECTOR');
    AddInvisible('FULL_NAME');
    AddInvisible('INDEX_POST');
    AddInvisible('STREET_POST_ID');
    AddInvisible('HOUSE_POST');
    AddInvisible('FLAT_POST');
    AddInvisible('STREET_POST_NAME');
    AddInvisible('STREET_POST_PREFIX');
    AddInvisible('LOCALITY_POST_ID');
    AddInvisible('LOCALITY_POST_NAME');
    AddInvisible('LOCALITY_POST_PREFIX');
    AddInvisible('PAYMENT_TYPE');
    Add('SMALL_NAME','������������',150);
    Add('CONTACT_FACE','���������� ����',150);
    Add('PHONE','��������',100);
    AddCalculate('PAYMENT_TYPE_NAME','������� ������',GetPaymentTypeName,ftString,20,100);
    Add('PAYMENT_PERCENT','�������',50);
  end;
  Orders.Add('SMALL_NAME');
end;

function TBisBallDataDealersFormIface.GetPaymentTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetPaymentTypeByIndex(DataSet.FieldByName('PAYMENT_TYPE').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;

end.
