unit BisCallcHbookDealsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DBCtrls, Dialogs,
  BisDataGridFm;

type
  TBiCallcHbookDealsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
  end;

  TBisCallcHbookDealsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookDealsForm: TBiCallcHbookDealsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisCallcHbookDealEditFm, BisCallcConsts;

{ TBisCallcHbookDealsFormIface }

constructor TBisCallcHbookDealsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBiCallcHbookDealsForm;
  InsertClass:=TBisCallcHbookDealInsertFormIface;
  UpdateClass:=TBisCallcHbookDealUpdateFormIface;
  DeleteClass:=TBisCallcHbookDealDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  FilterOnShow:=true;
  ProviderName:='S_DEALS';
  with FieldNames do begin
    AddKey('DEAL_ID');
    AddInvisible('PLAN_ID');
    AddInvisible('PLAN_NAME');
    AddInvisible('GROUP_ID');
    AddInvisible('GROUP_NAME');
    AddInvisible('AGREEMENT_ID');
    AddInvisible('AGREEMENT_NUM');
    AddInvisible('DEBTOR_ID');
    AddInvisible('DEBT_INFORMATION');
    AddInvisible('GUARANTORS');
    AddInvisible('DATE_CLOSE');
    AddInvisible('ACCOUNT_NUM');
    AddInvisible('DEBTOR_NUM');
    AddInvisible('DEBTOR_DATE');
    Add('DEAL_NUM','����� ����',90);
    Add('DATE_ISSUE','���� ��������',70);
    Add('DEBTOR_NAME','�������',240);
    Add('ARREAR_PERIOD','������',60);
    Add('INITIAL_DEBT','����',90).DisplayFormat:=SDisplayFormatFloat;
  end;
  Orders.Add('DEAL_NUM');
end;

end.
