unit BisKrieltDataDesignEditFm;

interface                                                                                    

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList,
  BisDataEditFm, BisControls;

type
  TBisKrieltDataDesignEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    LabelDescription: TLabel;
    LabelNum: TLabel;
    EditName: TEdit;
    MemoDescription: TMemo;
    EditNum: TEdit;
    LabelCssClass: TLabel;
    EditCssClass: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataDesignEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataDesignInsertFormIface=class(TBisKrieltDataDesignEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataDesignUpdateFormIface=class(TBisKrieltDataDesignEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataDesignDeleteFormIface=class(TBisKrieltDataDesignEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataDesignEditForm: TBisKrieltDataDesignEditForm;

implementation

{$R *.dfm}

{ TBisKrieltDataDesignEditFormIface }

constructor TBisKrieltDataDesignEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataDesignEditForm;
  with Params do begin
    AddKey('DESIGN_ID').Older('OLD_DESIGN_ID');
    AddEdit('NUM','EditNum','LabelNum',true);
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEdit('CSS_CLASS','EditCssClass','LabelCssClass');
  end;
end;

{ TBisKrieltDataDesignInsertFormIface }

constructor TBisKrieltDataDesignInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_DESIGN';
end;

{ TBisKrieltDataDesignUpdateFormIface }

constructor TBisKrieltDataDesignUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_DESIGN';
end;

{ TBisKrieltDataDesignDeleteFormIface }

constructor TBisKrieltDataDesignDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_DESIGN';
end;

end.
