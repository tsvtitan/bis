unit BisCallcHbookPlanActionsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisCallcHbookPlanActionsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookPlanActionsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookPlanActionsForm: TBisCallcHbookPlanActionsForm;

implementation

{$R *.dfm}

uses BisCallcHbookPlanActionEditFm;

{ TBisCallcHbookPlanActionsFormIface }

constructor TBisCallcHbookPlanActionsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookPlanActionsForm;
  InsertClass:=TBisCallcHbookPlanActionInsertFormIface;
  UpdateClass:=TBisCallcHbookPlanActionUpdateFormIface;
  DeleteClass:=TBisCallcHbookPlanActionDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_PLAN_ACTIONS';
  with FieldNames do begin
    AddKey('PLAN_ID');
    AddKey('ACTION_ID');
    Add('PLAN_NAME','����',100);
    Add('ACTION_NAME','��������',200);
    Add('PERIOD','������',50);
    Add('PRIORITY','�������',50);
  end;
  Orders.Add('PLAN_NAME');
  Orders.Add('PRIORITY');
  Orders.Add('ACTION_NAME');
end;

end.