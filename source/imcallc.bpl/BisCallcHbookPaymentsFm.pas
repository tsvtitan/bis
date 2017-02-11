unit BisCallcHbookPaymentsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DBCtrls, Dialogs, DB,
  BisDataGridFm, BisFieldNames, BisControls;

type
  TBiCallcHbookPaymentsForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoDescription: TDBMemo;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookPaymentsFormIface=class(TBisDataGridFormIface)
  private
    function GetStateName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookPaymentsForm: TBiCallcHbookPaymentsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisOrders,
     BisCallcConsts, 
     BisCallcHbookPaymentEditFm;

{ TBisCallcHbookPaymentsFormIface }

constructor TBisCallcHbookPaymentsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBiCallcHbookPaymentsForm;
  InsertClass:=TBisCallcHbookPaymentInsertFormIface;
  UpdateClass:=TBisCallcHbookPaymentUpdateFormIface;
  DeleteClass:=TBisCallcHbookPaymentDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_PAYMENTS';
  with FieldNames do begin
    AddKey('PAYMENT_ID');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('USER_NAME');
    AddInvisible('DEAL_ID');
    AddInvisible('DESCRIPTION');
    AddInvisible('STATE');
    Add('DEAL_NUM','����� ����',100);
    Add('DATE_PAYMENT','���� �������',80);
    Add('AMOUNT','����� �������',90).DisplayFormat:=SDisplayFormatFloat;
    Add('PERIOD','������',70);
    AddCalculate('STATE_NAME','���������',GetStateName,ftString,100,110);
  end;
  Orders.Add('DATE_PAYMENT',otDesc);
end;

function TBisCallcHbookPaymentsFormIface.GetStateName(FieldName: TBisFieldName;
  DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetStateByIndex(DataSet.FieldByName('STATE').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;

{ TBiCallcHbookPaymentsForm }

constructor TBiCallcHbookPaymentsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    DBMemoDescription.DataSource:=DataFrame.DataSource;
  end;
end;

end.
