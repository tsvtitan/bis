unit BisCallcHbookActionResultEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcHbookActionResultEditForm = class(TBisDataEditForm)
    LabelAction: TLabel;
    EditAction: TEdit;
    ButtonAction: TButton;
    LabelResult: TLabel;
    EditResult: TEdit;
    ButtonResult: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
  end;

  TBisCallcHbookActionResultEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookActionResultInsertFormIface=class(TBisCallcHbookActionResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookActionResultUpdateFormIface=class(TBisCallcHbookActionResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookActionResultDeleteFormIface=class(TBisCallcHbookActionResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookActionResultEditForm: TBisCallcHbookActionResultEditForm;

implementation

uses BisCallcHbookResultsFm, BisCallcHbookActionsFm;

{$R *.dfm}

{ TBisCallcHbookActionResultEditFormIface }

constructor TBisCallcHbookActionResultEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookActionResultEditForm;
  with Params do begin
    AddEditDataSelect('ACTION_ID','EditAction','LabelAction','ButtonAction',
                      TBisCallcHbookActionsFormIface,'ACTION_NAME',true,true,'','NAME').Older('OLD_ACTION_ID');
    AddEditDataSelect('RESULT_ID','EditResult','LabelResult','ButtonResult',
                      TBisCallcHbookResultsFormIface,'RESULT_NAME',true,true,'','NAME').Older('OLD_RESULT_ID');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);                      
  end;
end;

{ TBisCallcHbookActionResultInsertFormIface }

constructor TBisCallcHbookActionResultInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACTION_RESULT';
end;

{ TBisCallcHbookActionResultUpdateFormIface }

constructor TBisCallcHbookActionResultUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACTION_RESULT';
end;

{ TBisCallcHbookActionResultDeleteFormIface }

constructor TBisCallcHbookActionResultDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACTION_RESULT';
end;


end.
