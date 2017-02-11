unit BisKrieltDataSubscriptionsFm;

interface
                                                                                                         
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisKrieltDataSubscriptionsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataSubscriptionsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataSubscriptionsForm: TBisKrieltDataSubscriptionsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataSubscriptionEditFm;

{ TBisKrieltDataSubscriptionsFormIface }

constructor TBisKrieltDataSubscriptionsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataSubscriptionsForm;
  FilterClass:=TBisKrieltDataSubscriptionFilterFormIface;
  InsertClass:=TBisKrieltDataSubscriptionInsertFormIface;
  UpdateClass:=TBisKrieltDataSubscriptionUpdateFormIface;
  DeleteClass:=TBisKrieltDataSubscriptionDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_SUBSCRIPTIONS';
  with FieldNames do begin
    AddKey('SUBSCRIPTION_ID');
    AddInvisible('SERVICE_ID');
    AddInvisible('DESCRIPTION');
    Add('NAME','Наименование',250);
    Add('SERVICE_NAME','Услуга',150);
  end;
  Orders.Add('NAME');
end;

end.
