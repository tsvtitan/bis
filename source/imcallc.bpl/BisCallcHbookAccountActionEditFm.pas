unit BisCallcHbookAccountActionEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcHbookAccountActionEditForm = class(TBisDataEditForm)
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelAction: TLabel;
    EditAction: TEdit;
    ButtonAction: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
  end;

  TBisCallcHbookAccountActionEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookAccountActionInsertFormIface=class(TBisCallcHbookAccountActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookAccountActionUpdateFormIface=class(TBisCallcHbookAccountActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookAccountActionDeleteFormIface=class(TBisCallcHbookAccountActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookAccountActionEditForm: TBisCallcHbookAccountActionEditForm;

implementation

uses BisCallcHbookActionsFm, BisCallcConsts;

{$R *.dfm}

{ TBisCallcHbookAccountActionEditFormIface }

constructor TBisCallcHbookAccountActionEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookAccountActionEditForm;
  with Params do begin
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassHbookAccountsFormIface,'USER_NAME',true,true).Older('OLD_ACCOUNT_ID');
    AddEditDataSelect('ACTION_ID','EditAction','LabelAction','ButtonAction',
                      TBisCallcHbookActionsFormIface,'ACTION_NAME',true,true,'','NAME').Older('OLD_ACTION_ID');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);                      
  end;
end;

{ TBisCallcHbookAccountActionInsertFormIface }

constructor TBisCallcHbookAccountActionInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACCOUNT_ACTION';
end;

{ TBisCallcHbookAccountActionUpdateFormIface }

constructor TBisCallcHbookAccountActionUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACCOUNT_ACTION';
end;

{ TBisCallcHbookAccountActionDeleteFormIface }

constructor TBisCallcHbookAccountActionDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACCOUNT_ACTION';
end;


end.
