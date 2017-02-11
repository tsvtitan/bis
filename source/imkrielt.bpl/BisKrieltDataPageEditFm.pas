unit BisKrieltDataPageEditFm;

interface                                                                                              

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList,
  BisDataEditFm, BisControls;

type
  TBisKrieltDataPageEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelAddress: TLabel;
    EditAddress: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataPageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPageInsertFormIface=class(TBisKrieltDataPageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPageUpdateFormIface=class(TBisKrieltDataPageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPageDeleteFormIface=class(TBisKrieltDataPageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataPageEditForm: TBisKrieltDataPageEditForm;

implementation

{$R *.dfm}

{ TBisKrieltDataPageEditFormIface }

constructor TBisKrieltDataPageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataPageEditForm;
  with Params do begin
    AddKey('PAGE_ID').Older('OLD_PAGE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEdit('ADDRESS','EditAddress','LabelAddress',true);
  end;
end;

{ TBisKrieltDataPageInsertFormIface }

constructor TBisKrieltDataPageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PAGE';
end;

{ TBisKrieltDataPageUpdateFormIface }

constructor TBisKrieltDataPageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PAGE';
end;

{ TBisKrieltDataPageDeleteFormIface }

constructor TBisKrieltDataPageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PAGE';
end;

end.
