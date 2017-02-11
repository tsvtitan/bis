unit BisKrieltDataAccountSubscriptionsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,                          
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DB,
  BisFieldNames;

type
  TBisKrieltDataAccountSubscriptionsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataAccountSubscriptionsFormIface=class(TBisDataGridFormIface)
  private
    function GetAccessTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataAccountSubscriptionsForm: TBisKrieltDataAccountSubscriptionsForm;

implementation

{$R *.dfm}

uses BisKrieltDataAccountSubscriptionEditFm;

{ TBisKrieltDataAccountSubscriptionsFormIface }

constructor TBisKrieltDataAccountSubscriptionsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataAccountSubscriptionsForm;
  FilterClass:=TBisKrieltDataAccountSubscriptionFilterFormIface;
  InsertClass:=TBisKrieltDataAccountSubscriptionInsertFormIface;
  UpdateClass:=TBisKrieltDataAccountSubscriptionUpdateFormIface;
  DeleteClass:=TBisKrieltDataAccountSubscriptionDeleteFormIface;
  Permissions.Enabled:=true;
  FilterOnShow:=true;
//  Available:=true;
  ProviderName:='S_ACCOUNT_SUBSCRIPTIONS';
  with FieldNames do begin
    AddKey('SUBSCRIPTION_ID');
    AddKey('ACCOUNT_ID');
    AddInvisible('DATE_BEGIN');
    AddInvisible('DATE_END');
    AddInvisible('ACCESS_TYPE');
    Add('USER_NAME','������� ������ (����)',150);
    Add('SUBSCRIPTION_NAME','��������',200);
    AddCalculate('ACCESS_TYPE_NAME','��� �������',GetAccessTypeName,ftString,100,150);
  end;
  Orders.Add('USER_NAME');
  Orders.Add('SUBSCRIPTION_NAME');
end;

function TBisKrieltDataAccountSubscriptionsFormIface.GetAccessTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetAccessTypeByIndex(DataSet.FieldByName('ACCESS_TYPE').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;

end.