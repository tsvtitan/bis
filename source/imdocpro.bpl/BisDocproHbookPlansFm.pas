unit BisDocproHbookPlansFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisDocproHbookPlansForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDocproHbookPlansFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproHbookPlansForm: TBisDocproHbookPlansForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDocproHbookPlanEditFm;

{ TBisDocproHbookPlansFormIface }

constructor TBisDocproHbookPlansFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproHbookPlansForm;
  InsertClass:=TBisDocproHbookPlanInsertFormIface;
  UpdateClass:=TBisDocproHbookPlanUpdateFormIface;
  DeleteClass:=TBisDocproHbookPlanDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_PLANS';
  with FieldNames do begin
    AddKey('PLAN_ID');
    AddInvisible('DESCRIPTION');
    Add('NAME','Наименование',310);
  end;
  Orders.Add('NAME');
end;

end.
