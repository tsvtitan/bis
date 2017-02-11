unit BisCallcHbookAccountGroupEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcHbookAccountGroupEditForm = class(TBisDataEditForm)
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelGroup: TLabel;
    EditGroup: TEdit;
    ButtonGroup: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
  end;

  TBisCallcHbookAccountGroupEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookAccountGroupInsertFormIface=class(TBisCallcHbookAccountGroupEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookAccountGroupUpdateFormIface=class(TBisCallcHbookAccountGroupEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookAccountGroupDeleteFormIface=class(TBisCallcHbookAccountGroupEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookAccountGroupEditForm: TBisCallcHbookAccountGroupEditForm;

implementation

uses BisCallcHbookGroupsFm, BisCallcConsts;

{$R *.dfm}

{ TBisCallcHbookAccountGroupEditFormIface }

constructor TBisCallcHbookAccountGroupEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookAccountGroupEditForm;
  with Params do begin
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassHbookAccountsFormIface,'USER_NAME',true,true).Older('OLD_ACCOUNT_ID');
    AddEditDataSelect('GROUP_ID','EditGroup','LabelGroup','ButtonGroup',
                      TBisCallcHbookGroupsFormIface,'GROUP_NAME',true,true,'','NAME').Older('OLD_GROUP_ID');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);                      
  end;
end;

{ TBisCallcHbookAccountGroupInsertFormIface }

constructor TBisCallcHbookAccountGroupInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACCOUNT_GROUP';
end;

{ TBisCallcHbookAccountGroupUpdateFormIface }

constructor TBisCallcHbookAccountGroupUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACCOUNT_GROUP';
end;

{ TBisCallcHbookAccountGroupDeleteFormIface }

constructor TBisCallcHbookAccountGroupDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACCOUNT_GROUP';
end;


end.
