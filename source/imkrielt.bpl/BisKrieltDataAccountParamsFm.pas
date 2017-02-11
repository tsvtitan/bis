unit BisKrieltDataAccountParamsFm;

interface
                                                                                                                      
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisKrieltDataAccountParamsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataAccountParamsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataAccountParamsForm: TBisKrieltDataAccountParamsForm;

implementation

{$R *.dfm}

uses BisKrieltDataAccountParamEditFm;

{ TBisKrieltDataAccountParamsFormIface }

constructor TBisKrieltDataAccountParamsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataAccountParamsForm;
  FilterClass:=TBisKrieltDataAccountParamFilterFormIface;
  InsertClass:=TBisKrieltDataAccountParamInsertFormIface;
  UpdateClass:=TBisKrieltDataAccountParamUpdateFormIface;
  DeleteClass:=TBisKrieltDataAccountParamDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_ACCOUNT_PARAMS';
  with FieldNames do begin
    AddKey('ACCOUNT_ID');
    AddKey('PARAM_ID');
    Add('USER_NAME','������� ������ (����)',150);
    Add('PARAM_NAME','��������',150);
    Add('PRIORITY','�������',50);
  end;
  Orders.Add('USER_NAME');
  Orders.Add('PARAM_NAME');
  Orders.Add('PRIORITY');
end;

end.
