unit BisTaxiDataActionAccountsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisTaxiDataActionAccountsForm = class(TBisDataGridForm)
  end;

  TBisTaxiDataActionAccountsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataActionAccountsForm: TBisTaxiDataActionAccountsForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataActionAccountEditFm, BisConsts, BisOrders;

{ TBisTaxiDataActionAccountsFormIface }

constructor TBisTaxiDataActionAccountsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataActionAccountsForm;
  FilterClass:=TBisTaxiDataActionAccountFilterFormIface;
  InsertClass:=TBisTaxiDataActionAccountInsertFormIface;
  UpdateClass:=TBisTaxiDataActionAccountUpdateFormIface;
  DeleteClass:=TBisTaxiDataActionAccountDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_ACTION_ACCOUNTS';
  with FieldNames do begin
    AddKey('ACTION_ID');
    AddKey('ACCOUNT_ID');
    Add('ACTION_NAME','Действие',180);
    Add('USER_NAME','Учетная запись',100);
    Add('PRIORITY','Порядок',70);
  end;
  Orders.Add('USER_NAME');
  Orders.Add('PRIORITY');
end;

end.
