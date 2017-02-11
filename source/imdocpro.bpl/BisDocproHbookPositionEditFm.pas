unit BisDocproHbookPositionEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisControls;

type
  TBisDocproHbookPositionEditForm = class(TBisDataEditForm)
    LabelView: TLabel;
    EditView: TEdit;
    ButtonView: TButton;
    LabelFirm: TLabel;
    EditFirm: TEdit;
    ButtonFirm: TButton;
    LabelPlan: TLabel;
    EditPlan: TEdit;
    ButtonPlan: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
  end;

  TBisDocproHbookPositionEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookPositionInsertFormIface=class(TBisDocproHbookPositionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookPositionUpdateFormIface=class(TBisDocproHbookPositionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookPositionDeleteFormIface=class(TBisDocproHbookPositionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproHbookPositionEditForm: TBisDocproHbookPositionEditForm;

implementation

uses BisDocproConsts, BisDocproHbookViewsFm, BisDocproHbookPlansFm;

{$R *.dfm}

{ TBisDocproHbookPositionEditFormIface }

constructor TBisDocproHbookPositionEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproHbookPositionEditForm;
  with Params do begin
    AddKey('POSITION_ID').Older('OLD_POSITION_ID');
    AddEditDataSelect('PLAN_ID','EditPlan','LabelPlan','ButtonPlan',
                      TBisDocproHbookPlansFormIface,'PLAN_NAME',true,false,'','NAME');
    AddEditDataSelect('VIEW_ID','EditView','LabelView','ButtonView',
                      TBisDocproHbookViewsFormIface,'VIEW_NAME',true,false,'','NAME');
    AddEditDataSelect('FIRM_ID','EditFirm','LabelFirm','ButtonFirm',
                      SIfaceClassHbookFirmsFormIface,'FIRM_SMALL_NAME',true,false,'','SMALL_NAME');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisDocproHbookPositionInsertFormIface }

constructor TBisDocproHbookPositionInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_POSITION';
end;

{ TBisDocproHbookPositionUpdateFormIface }

constructor TBisDocproHbookPositionUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_POSITION';
end;

{ TBisDocproHbookPositionDeleteFormIface }

constructor TBisDocproHbookPositionDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_POSITION';
end;

end.
