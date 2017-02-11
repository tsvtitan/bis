unit BisCallcHbookPlansFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, ComCtrls, ActnList,
  Dialogs, BisDataGridFm, BisFm;

type
  TBisCallcHbookPlansForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookPlansFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookPlansForm: TBisCallcHbookPlansForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisCallcHbookPlanEditFm;

{ TBisCallcHbookPlansFormIface }

constructor TBisCallcHbookPlansFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookPlansForm;
  InsertClass:=TBisCallcHbookPlanInsertFormIface;
  UpdateClass:=TBisCallcHbookPlanUpdateFormIface;
  DeleteClass:=TBisCallcHbookPlanDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_PLANS';
  with FieldNames do begin
    AddKey('PLAN_ID');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',250);
  end;
  Orders.Add('NAME');
end;

end.
