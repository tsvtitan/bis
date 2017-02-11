unit BisKrieltDataSubscriptionContentsFm;

interface                                                                                                 

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisKrieltDataSubscriptionContentsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataSubscriptionContentsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataSubscriptionContentsForm: TBisKrieltDataSubscriptionContentsForm;

implementation

{$R *.dfm}

uses BisKrieltDataSubscriptionContentEditFm;

{ TBisKrieltDataSubscriptionContentsFormIface }

constructor TBisKrieltDataSubscriptionContentsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataSubscriptionContentsForm;
  FilterClass:=TBisKrieltDataSubscriptionContentFilterFormIface;
  InsertClass:=TBisKrieltDataSubscriptionContentInsertFormIface;
  UpdateClass:=TBisKrieltDataSubscriptionContentUpdateFormIface;
  DeleteClass:=TBisKrieltDataSubscriptionContentDeleteFormIface;
  Permissions.Enabled:=true;
  FilterOnShow:=true;
//  Available:=true;
  ProviderName:='S_SUBSCRIPTION_CONTENTS';
  with FieldNames do begin
    AddKey('SUBSCRIPTION_ID');
    AddKey('VIEW_ID');
    AddKey('TYPE_ID');
    AddKey('OPERATION_ID');
    AddKey('PUBLISHING_ID');
    Add('SUBSCRIPTION_NAME','Подписка',200);
    Add('PUBLISHING_NAME','Издание',75);
    Add('VIEW_NAME','Вид объектов',100);
    Add('TYPE_NAME','Тип объектов',100);
    Add('OPERATION_NAME','Операция',70);
  end;
  Orders.Add('SUBSCRIPTION_NAME');
  Orders.Add('PUBLISHING_NAME');
  Orders.Add('VIEW_NAME');
  Orders.Add('TYPE_NAME');
  Orders.Add('OPERATION_NAME');
end;

end.
