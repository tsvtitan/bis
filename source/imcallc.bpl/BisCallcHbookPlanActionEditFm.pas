unit BisCallcHbookPlanActionEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcHbookPlanActionEditForm = class(TBisDataEditForm)
    LabelPlan: TLabel;
    EditPlan: TEdit;
    ButtonPlan: TButton;
    LabelAction: TLabel;
    EditAction: TEdit;
    ButtonAction: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelPeriod: TLabel;
    EditPeriod: TEdit;
  private
    { Private declarations }
  public
  end;

  TBisCallcHbookPlanActionEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookPlanActionInsertFormIface=class(TBisCallcHbookPlanActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookPlanActionUpdateFormIface=class(TBisCallcHbookPlanActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookPlanActionDeleteFormIface=class(TBisCallcHbookPlanActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookPlanActionEditForm: TBisCallcHbookPlanActionEditForm;

implementation

uses BisCallcHbookActionsFm, BisCallcHbookPlansFm;

{$R *.dfm}

{ TBisCallcHbookPlanActionEditFormIface }

constructor TBisCallcHbookPlanActionEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookPlanActionEditForm;
  with Params do begin
    AddEditDataSelect('PLAN_ID','EditPlan','LabelPlan','ButtonPlan',
                      TBisCallcHbookPlansFormIface,'PLAN_NAME',true,true,'','NAME').Older('OLD_PLAN_ID');
    AddEditDataSelect('ACTION_ID','EditAction','LabelAction','ButtonAction',
                      TBisCallcHbookActionsFormIface,'ACTION_NAME',true,true,'','NAME').Older('OLD_ACTION_ID');
    AddEditInteger('PERIOD','EditPeriod','LabelPeriod',true);                      
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisCallcHbookPlanActionInsertFormIface }

constructor TBisCallcHbookPlanActionInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PLAN_ACTION';
end;

{ TBisCallcHbookPlanActionUpdateFormIface }

constructor TBisCallcHbookPlanActionUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PLAN_ACTION';
end;

{ TBisCallcHbookPlanActionDeleteFormIface }

constructor TBisCallcHbookPlanActionDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PLAN_ACTION';
end;


end.
