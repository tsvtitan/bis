unit BisKrieltDataPublishingEditFm;

interface
                                                                                                         
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisKrieltDataPublishingEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataPublishingEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPublishingInsertFormIface=class(TBisKrieltDataPublishingEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPublishingUpdateFormIface=class(TBisKrieltDataPublishingEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPublishingDeleteFormIface=class(TBisKrieltDataPublishingEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataPublishingEditForm: TBisKrieltDataPublishingEditForm;

implementation

{$R *.dfm}

{ TBisKrieltDataPublishingEditFormIface }

constructor TBisKrieltDataPublishingEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataPublishingEditForm;
  with Params do begin
    AddKey('PUBLISHING_ID').Older('OLD_PUBLISHING_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisKrieltDataPublishingInsertFormIface }

constructor TBisKrieltDataPublishingInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PUBLISHING';
end;

{ TBisKrieltDataPublishingUpdateFormIface }

constructor TBisKrieltDataPublishingUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PUBLISHING';
end;

{ TBisKrieltDataPublishingDeleteFormIface }

constructor TBisKrieltDataPublishingDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PUBLISHING';
end;

end.
