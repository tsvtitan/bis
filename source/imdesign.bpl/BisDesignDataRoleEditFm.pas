unit BisDesignDataRoleEditFm;

interface
                                                                                                        
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisDesignDataRoleEditForm = class(TBisDataEditForm)
    LabelUserName: TLabel;
    EditUserName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataRoleEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataRoleInsertFormIface=class(TBisDesignDataRoleEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataRoleUpdateFormIface=class(TBisDesignDataRoleEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataRoleDeleteFormIface=class(TBisDesignDataRoleEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataRoleEditForm: TBisDesignDataRoleEditForm;

implementation

uses BisCore;

{$R *.dfm}

{ TBisDesignDataRoleEditFormIface }

constructor TBisDesignDataRoleEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataRoleEditForm;
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

{ TBisDesignDataRoleInsertFormIface }

constructor TBisDesignDataRoleInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ACCOUNT';
end;

{ TBisDesignDataRoleUpdateFormIface }

constructor TBisDesignDataRoleUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ACCOUNT';
end;

{ TBisDesignDataRoleDeleteFormIface }

constructor TBisDesignDataRoleDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ACCOUNT';
end;

end.
