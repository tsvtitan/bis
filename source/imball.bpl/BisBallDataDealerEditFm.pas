unit BisBallDataDealerEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisFm, BisControls, BisParamEditDataSelect;

type
  TBisBallDataDealerEditForm = class(TBisDataEditForm)
    LabelSmallName: TLabel;
    LabelFullName: TLabel;
    LabelPhone: TLabel;
    LabelFax: TLabel;
    LabelEmail: TLabel;
    LabelSite: TLabel;
    LabelDirector: TLabel;
    EditSmallName: TEdit;
    EditFullName: TEdit;
    EditPhone: TEdit;
    EditFax: TEdit;
    EditEmail: TEdit;
    EditSite: TEdit;
    EditDirector: TEdit;
    LabelContactFace: TLabel;
    EditContactFace: TEdit;
    GroupBoxPostAddress: TGroupBox;
    LabelStreetPost: TLabel;
    LabelIndexPost: TLabel;
    LabelHousePost: TLabel;
    LabelFlatPost: TLabel;
    EditStreetPost: TEdit;
    ButtonStreetPost: TButton;
    EditIndexPost: TEdit;
    EditHousePost: TEdit;
    EditFlatPost: TEdit;
    LabelPaymentPercent: TLabel;
    EditPaymentPercent: TEdit;
    LabelPaymentType: TLabel;
    ComboBoxPaymentType: TComboBox;
    procedure EditSmallNameExit(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisBallDataDealerEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisBallDataDealerInsertFormIface=class(TBisBallDataDealerEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisBallDataDealerUpdateFormIface=class(TBisBallDataDealerEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisBallDataDealerDeleteFormIface=class(TBisBallDataDealerEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisBallDataDealerEditForm: TBisBallDataDealerEditForm;


function GetPaymentTypeByIndex(Index: Integer): String;

implementation

uses BisParam, BisVariants, BisUtils,
     BisBallConsts;

{$R *.dfm}

function GetPaymentTypeByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='�����';
    1: Result:='����������';
  end;
end;

{ TBisBallDataDealerEditFormIface }

constructor TBisBallDataDealerEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisBallDataDealerEditForm;
  with Params do begin
    AddKey('DEALER_ID').Older('OLD_DEALER_ID');
    AddInvisible('LOCALITY_POST_ID');
    AddInvisible('LOCALITY_POST_PREFIX');
    AddInvisible('LOCALITY_POST_NAME');
    AddInvisible('STREET_POST_PREFIX');
    AddInvisible('STREET_POST_NAME');

    AddEdit('SMALL_NAME','EditSmallName','LabelSmallName',true);
    AddComboBox('PAYMENT_TYPE','ComboBoxPaymentType','LabelPaymentType',true);
    AddEdit('FULL_NAME','EditFullName','LabelFullName',true);
    AddEditCalc('PAYMENT_PERCENT','EditPaymentPercent','LabelPaymentPercent');
    with AddEditDataSelect('STREET_POST_ID','EditStreetPost','LabelStreetPost','ButtonStreetPost',
                           SClassDataStreetsFormIface,'STREET_POST_PREFIX;STREET_POST_NAME;LOCALITY_POST_PREFIX;LOCALITY_POST_NAME;LOCALITY_POST_ID',
                           false,false,'STREET_ID','PREFIX;NAME;LOCALITY_PREFIX;LOCALITY_NAME;LOCALITY_ID') do begin
      DataAliasFormat:='%s%s %s%s';
      ExcludeModes([emFilter]);
    end;
    AddEdit('HOUSE_POST','EditHousePost','LabelHousePost');
    AddEdit('FLAT_POST','EditFlatPost','LabelFlatPost');
    AddEdit('INDEX_POST','EditIndexPost','LabelIndexPost');
    AddEdit('DIRECTOR','EditDirector','LabelDirector');
    AddEdit('PHONE','EditPhone','LabelPhone');
    AddEdit('CONTACT_FACE','EditContactFace','LabelContactFace');
    AddEdit('FAX','EditFax','LabelFax');
    AddEdit('EMAIL','EditEmail','LabelEmail');
    AddEdit('SITE','EditSite','LabelSite');
  end;
end;

{ TBisBallDataDealerInsertFormIface }

constructor TBisBallDataDealerInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_DEALER';
  Caption:='������� ������';
end;

{ TBisBallDataDealerUpdateFormIface }

constructor TBisBallDataDealerUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_DEALER';
  Caption:='�������� ������';
end;

{ TBisBallDataDealerDeleteFormIface }

constructor TBisBallDataDealerDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_DEALER';
  Caption:='������� ������';
end;

{ TBisBallDataDealerEditForm }

constructor TBisBallDataDealerEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  for i:=0 to 1 do
    ComboBoxPaymentType.Items.Add(GetPaymentTypeByIndex(i));

end;

procedure TBisBallDataDealerEditForm.EditSmallNameExit(Sender: TObject);
begin
  if (Mode in [emInsert,emDuplicate,emUpdate]) and
     (Trim(EditSmallName.Text)<>'') and (Trim(EditFullName.Text)='') then
    EditFullName.Text:=EditSmallName.Text;
end;

end.
