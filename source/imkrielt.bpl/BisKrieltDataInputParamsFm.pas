unit BisKrieltDataInputParamsFm;

interface
                                                                                                     
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataGridFm;

type
  TBisKrieltDataInputParamsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataInputParamsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataInputTypesForm: TBisKrieltDataInputParamsForm;

implementation

{$R *.dfm}

uses BisKrieltDataInputParamEditFm;

{ TBisKrieltDataInputParamsFormIface }

constructor TBisKrieltDataInputParamsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataInputParamsForm;
  FilterClass:=TBisKrieltDataInputParamFilterFormIface;
  InsertClass:=TBisKrieltDataInputParamInsertFormIface;
  UpdateClass:=TBisKrieltDataInputParamUpdateFormIface;
  DeleteClass:=TBisKrieltDataInputParamDeleteFormIface;
  Permissions.Enabled:=true;
  FilterOnShow:=true;
  ProviderName:='S_INPUT_PARAMS';
  with FieldNames do begin
    AddKey('INPUT_PARAM_ID');
    AddInvisible('VIEW_ID');
    AddInvisible('TYPE_ID');
    AddInvisible('OPERATION_ID');
    AddInvisible('PARAM_ID');
    AddInvisible('ELEMENT_TYPE');
    AddInvisible('POSITION');
    AddInvisible('REQUIRED');
    Add('VIEW_NAME','��� �������',150);
    Add('TYPE_NAME','��� �������',150);
    Add('OPERATION_NAME','��������',100);
    Add('PARAM_NAME','��������',150);
    Add('PRIORITY','�������',50);
  end;
  Orders.Add('VIEW_NAME');
  Orders.Add('TYPE_NAME');
  Orders.Add('OPERATION_NAME');
  Orders.Add('PARAM_NAME');
  Orders.Add('PRIORITY');
end;

end.