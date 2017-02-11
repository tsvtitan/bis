unit BisKrieltDataSubscriptionEditFm;

interface
                                                                                                       
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisParam, BisControls, ImgList;

type
  TBisKrieltDataSubscriptionEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelService: TLabel;
    EditService: TEdit;
    ButtonService: TButton;
  private
    { Private declarations }
  public
  end;

  TBisKrieltDataSubscriptionEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataSubscriptionFilterFormIface=class(TBisKrieltDataSubscriptionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataSubscriptionInsertFormIface=class(TBisKrieltDataSubscriptionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataSubscriptionUpdateFormIface=class(TBisKrieltDataSubscriptionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataSubscriptionDeleteFormIface=class(TBisKrieltDataSubscriptionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataSubscriptionEditForm: TBisKrieltDataSubscriptionEditForm;

implementation

{$R *.dfm}

uses BisKrieltDataServicesFm;

{ TBisKrieltDataSubscriptionEditFormIface }

constructor TBisKrieltDataSubscriptionEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataSubscriptionEditForm;
  with Params do begin
    AddKey('SUBSCRIPTION_ID').Older('OLD_SUBSCRIPTION_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddEditDataSelect('SERVICE_ID','EditService','LabelService','ButtonService',
                      TBisKrieltDataServicesFormIface,'SERVICE_NAME',true,false,'','NAME');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
  end;
end;

{ TBisKrieltDataSubscriptionFilterFormIface }

constructor TBisKrieltDataSubscriptionFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

{ TBisKrieltDataSubscriptionInsertFormIface }

constructor TBisKrieltDataSubscriptionInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_SUBSCRIPTION';
end;

{ TBisKrieltDataSubscriptionUpdateFormIface }

constructor TBisKrieltDataSubscriptionUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_SUBSCRIPTION';
end;

{ TBisKrieltDataSubscriptionDeleteFormIface }

constructor TBisKrieltDataSubscriptionDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_SUBSCRIPTION';
end;


end.
