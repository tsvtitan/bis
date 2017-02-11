unit BisDocproHbookPlanEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ComCtrls;

type
  TBisDocproHbookPlanEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDocproHbookPlanEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookPlanInsertFormIface=class(TBisDocproHbookPlanEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookPlanUpdateFormIface=class(TBisDocproHbookPlanEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookPlanDeleteFormIface=class(TBisDocproHbookPlanEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproHbookPlanEditForm: TBisDocproHbookPlanEditForm;

implementation

{$R *.dfm}

{ TBisDocproHbookPlanEditFormIface }

constructor TBisDocproHbookPlanEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproHbookPlanEditForm;
  with Params do begin
    AddKey('PLAN_ID').Older('OLD_PLAN_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
  end;
end;

{ TBisDocproHbookPlanInsertFormIface }

constructor TBisDocproHbookPlanInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PLAN';
end;

{ TBisDocproHbookPlanUpdateFormIface }

constructor TBisDocproHbookPlanUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PLAN';
end;

{ TBisDocproHbookPlanDeleteFormIface }

constructor TBisDocproHbookPlanDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PLAN';
end;

end.
