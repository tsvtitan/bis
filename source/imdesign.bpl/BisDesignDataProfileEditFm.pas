unit BisDesignDataProfileEditFm;

interface

uses                                                                                                          
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisDesignDataProfileEditForm = class(TBisDataEditForm)
    LabelApplication: TLabel;
    EditApplication: TEdit;
    ButtonApplication: TButton;
    LabelLogin: TLabel;
    EditLogin: TEdit;
    ButtonLogin: TButton;
    LabelProfile: TLabel;
    MemoProfile: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataProfileEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataProfileInsertFormIface=class(TBisDesignDataProfileEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataProfileUpdateFormIface=class(TBisDesignDataProfileEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataProfileDeleteFormIface=class(TBisDesignDataProfileEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataProfileEditForm: TBisDesignDataProfileEditForm;

implementation

uses BisDesignDataAccountsFm, BisDesignDataApplicationsFm;

{$R *.dfm}

{ TBisDesignDataProfileEditFormIface }

constructor TBisDesignDataProfileEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataProfileEditForm;
  with Params do begin
    AddEditDataSelect('APPLICATION_ID','EditApplication','LabelApplication','ButtonApplication',
                      TBisDesignDataApplicationsFormIface,'APPLICATION_NAME',true,true,'','NAME').Older('OLD_APPLICATION_ID');
    AddEditDataSelect('ACCOUNT_ID','EditLogin','LabelLogin','ButtonLogin',
                      TBisDesignDataAccountsFormIface,'USER_NAME',true,true).Older('OLD_ACCOUNT_ID');
    AddMemo('PROFILE','MemoProfile','LabelProfile');
  end;
end;

{ TBisDesignDataProfileInsertFormIface }

constructor TBisDesignDataProfileInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PROFILE';
end;

{ TBisDesignDataProfileUpdateFormIface }

constructor TBisDesignDataProfileUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PROFILE';
end;

{ TBisDesignDataProfileDeleteFormIface }

constructor TBisDesignDataProfileDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PROFILE';
end;

end.
