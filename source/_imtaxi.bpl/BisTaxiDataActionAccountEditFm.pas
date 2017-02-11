unit BisTaxiDataActionAccountEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataActionAccountEditForm = class(TBisDataEditForm)
    LabelAction: TLabel;
    EditAction: TEdit;
    ButtonAction: TButton;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
  public
  end;

  TBisTaxiDataActionAccountEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataActionAccountFilterFormIface=class(TBisTaxiDataActionAccountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataActionAccountInsertFormIface=class(TBisTaxiDataActionAccountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataActionAccountUpdateFormIface=class(TBisTaxiDataActionAccountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataActionAccountDeleteFormIface=class(TBisTaxiDataActionAccountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataActionAccountEditForm: TBisTaxiDataActionAccountEditForm;

implementation

uses BisUtils, BisTaxiConsts, BisTaxiDataActionsFm, BisCore;

{$R *.dfm}

{ TBisTaxiDataActionAccountEditFormIface }

constructor TBisTaxiDataActionAccountEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataActionAccountEditForm;
  with Params do begin
    AddEditDataSelect('ACTION_ID','EditAction','LabelAction','ButtonAction',
                      TBisTaxiDataActionsFormIface,'ACTION_NAME',true,true,'','NAME').Older('OLD_ACTION_ID');
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassDataRolesAndAccountsFormIface,'USER_NAME',true,true).Older('OLD_ACCOUNT_ID');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');                      
  end;
end;


{ TBisTaxiDataActionAccountFilterFormIface }

constructor TBisTaxiDataActionAccountFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр по доступу к действиям';
end;

{ TBisTaxiDataActionAccountInsertFormIface }

constructor TBisTaxiDataActionAccountInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACTION_ACCOUNT';
  Caption:='Создать доступ к действию';
end;

{ TBisTaxiDataActionAccountUpdateFormIface }

constructor TBisTaxiDataActionAccountUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACTION_ACCOUNT';
  Caption:='Изменить доступ к действию';
end;

{ TBisTaxiDataActionAccountDeleteFormIface }

constructor TBisTaxiDataActionAccountDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACTION_ACCOUNT';
  Caption:='Удалить доступ к действию';
end;

end.
