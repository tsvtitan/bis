unit BisMessDataRoleEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisControls;

type
  TBisMessDataRoleEditForm = class(TBisDataEditForm)
    LabelUserName: TLabel;
    EditUserName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisMessDataRoleEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataRoleInsertFormIface=class(TBisMessDataRoleEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataRoleUpdateFormIface=class(TBisMessDataRoleEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataRoleDeleteFormIface=class(TBisMessDataRoleEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessDataRoleEditForm: TBisMessDataRoleEditForm;

implementation

uses BisCore;

{$R *.dfm}

{ TBisMessDataRoleEditFormIface }

constructor TBisMessDataRoleEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataRoleEditForm;
  with Params do begin
    AddKey('ACCOUNT_ID').Older('OLD_ACCOUNT_ID');
    AddInvisible('IS_ROLE').Value:=1;
    AddInvisible('AUTO_CREATED').Value:=0;
    AddInvisible('DATE_CREATE').Value:=Core.ServerDate;
    AddInvisible('LOCKED').Value:=0;
    AddEdit('USER_NAME','EditUserName','LabelUserName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
  end;
end;

{ TBisMessDataRoleInsertFormIface }

constructor TBisMessDataRoleInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACCOUNT';
end;

{ TBisMessDataRoleUpdateFormIface }

constructor TBisMessDataRoleUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACCOUNT';
end;

{ TBisMessDataRoleDeleteFormIface }

constructor TBisMessDataRoleDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACCOUNT';
end;

end.
