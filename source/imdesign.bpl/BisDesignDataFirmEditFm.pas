unit BisDesignDataFirmEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,                                  
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisFm, BisControls, BisParamEditDataSelect;

type
  TBisDesignDataFirmEditForm = class(TBisDataEditForm)
    LabelSmallName: TLabel;
    LabelFullName: TLabel;
    LabelInn: TLabel;
    LabelPaymentAccount: TLabel;
    LabelBank: TLabel;
    LabelCorrAccount: TLabel;
    LabelPhone: TLabel;
    LabelFirmType: TLabel;
    LabelFax: TLabel;
    LabelEmail: TLabel;
    LabelSite: TLabel;
    LabelOkonh: TLabel;
    LabelOkpo: TLabel;
    LabelKpp: TLabel;
    LabelDirector: TLabel;
    LabelAccountant: TLabel;
    LabelBik: TLabel;
    EditSmallName: TEdit;
    EditFullName: TEdit;
    EditInn: TEdit;
    EditPaymentAccount: TEdit;
    EditBank: TEdit;
    EditCorrAccount: TEdit;
    EditPhone: TEdit;
    EditFax: TEdit;
    EditEmail: TEdit;
    EditSite: TEdit;
    EditOkonh: TEdit;
    EditOkpo: TEdit;
    EditKpp: TEdit;
    EditDirector: TEdit;
    EditAccountant: TEdit;
    EditBik: TEdit;
    LabelParent: TLabel;
    EditParent: TEdit;
    ButtonParent: TButton;
    LabelContactFace: TLabel;
    EditContactFace: TEdit;
    GroupBoxLegalAddress: TGroupBox;
    LabelStreetLegal: TLabel;
    EditStreetLegal: TEdit;
    ButtonStreetLegal: TButton;
    LabelIndexLegal: TLabel;
    EditIndexLegal: TEdit;
    LabelHouseLegal: TLabel;
    EditHouseLegal: TEdit;
    LabelFlatLegal: TLabel;
    EditFlatLegal: TEdit;
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
    ComboBoxFirmType: TComboBox;
    procedure EditSmallNameExit(Sender: TObject);
  private
  public
  end;

  TBisDesignDataFirmEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataFirmInsertFormIface=class(TBisDesignDataFirmEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataFirmInsertChildFormIface=class(TBisDesignDataFirmEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataFirmUpdateFormIface=class(TBisDesignDataFirmEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataFirmDeleteFormIface=class(TBisDesignDataFirmEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataFirmEditForm: TBisDesignDataFirmEditForm;

implementation

uses BisDesignDataFirmTypesFm, BisDesignDataFirmsFm, BisParam,
     BisDesignDataStreetsFm, BisVariants, BisUtils;

{$R *.dfm}

{ TBisDesignDataFirmEditFormIface }

constructor TBisDesignDataFirmEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataFirmEditForm;
  with Params do begin
    AddKey('FIRM_ID').Older('OLD_FIRM_ID');
    AddInvisible('LOCALITY_LEGAL_ID');
    AddInvisible('LOCALITY_LEGAL_PREFIX');
    AddInvisible('LOCALITY_LEGAL_NAME');
    AddInvisible('STREET_LEGAL_PREFIX');
    AddInvisible('STREET_LEGAL_NAME');
    AddInvisible('LOCALITY_POST_ID');
    AddInvisible('LOCALITY_POST_PREFIX');
    AddInvisible('LOCALITY_POST_NAME');
    AddInvisible('STREET_POST_PREFIX');
    AddInvisible('STREET_POST_NAME');
    AddEditDataSelect('PARENT_ID','EditParent','LabelParent','ButtonParent',
                      TBisDesignDataFirmsFormIface,'PARENT_SMALL_NAME',false,false,'FIRM_ID','SMALL_NAME');
    AddEdit('SMALL_NAME','EditSmallName','LabelSmallName',true);
    AddComboBoxDataSelect('FIRM_TYPE_ID','ComboBoxFirmType','LabelFirmType','',
                          TBisDesignDataFirmTypesFormIface,'FIRM_TYPE_NAME',true,false,'','NAME');
    AddEdit('FULL_NAME','EditFullName','LabelFullName',true);
    AddEdit('INN','EditInn','LabelInn');
    AddEdit('BANK','EditBank','LabelBank');
    AddEdit('BIK','EditBik','LabelBik');
    AddEdit('PAYMENT_ACCOUNT','EditPaymentAccount','LabelPaymentAccount');
    AddEdit('CORR_ACCOUNT','EditCorrAccount','LabelCorrAccount');
    with AddEditDataSelect('STREET_LEGAL_ID','EditStreetLegal','LabelStreetLegal','ButtonStreetLegal',
                            TBisDesignDataStreetsFormIface,'STREET_LEGAL_PREFIX;STREET_LEGAL_NAME;LOCALITY_LEGAL_PREFIX;LOCALITY_LEGAL_NAME;LOCALITY_LEGAL_ID',
                            false,false,'STREET_ID','PREFIX;NAME;LOCALITY_PREFIX;LOCALITY_NAME;LOCALITY_ID') do begin
      DataAliasFormat:='%s%s %s%s';
      ExcludeModes([emFilter]);
    end;
    AddEdit('HOUSE_LEGAL','EditHouseLegal','LabelHouseLegal');
    AddEdit('FLAT_LEGAL','EditFlatLegal','LabelFlatLegal');
    AddEdit('INDEX_LEGAL','EditIndexLegal','LabelIndexLegal');
    with AddEditDataSelect('STREET_POST_ID','EditStreetPost','LabelStreetPost','ButtonStreetPost',
                           TBisDesignDataStreetsFormIface,'STREET_POST_PREFIX;STREET_POST_NAME;LOCALITY_POST_PREFIX;LOCALITY_POST_NAME;LOCALITY_POST_ID',
                           false,false,'STREET_ID','PREFIX;NAME;LOCALITY_PREFIX;LOCALITY_NAME;LOCALITY_ID') do begin
      DataAliasFormat:='%s%s %s%s';
      ExcludeModes([emFilter]);
    end;  
    AddEdit('HOUSE_POST','EditHousePost','LabelHousePost');
    AddEdit('FLAT_POST','EditFlatPost','LabelFlatPost');
    AddEdit('INDEX_POST','EditIndexPost','LabelIndexPost');
    AddEdit('PHONE','EditPhone','LabelPhone');
    AddEdit('FAX','EditFax','LabelFax');
    AddEdit('EMAIL','EditEmail','LabelEmail');
    AddEdit('SITE','EditSite','LabelSite');
    AddEdit('OKONH','EditOkonh','LabelOkonh');
    AddEdit('OKPO','EditOkpo','LabelOkpo');
    AddEdit('KPP','EditKpp','LabelKpp');
    AddEdit('DIRECTOR','EditDirector','LabelDirector');
    AddEdit('ACCOUNTANT','EditAccountant','LabelAccountant');
    AddEdit('CONTACT_FACE','EditContactFace','LabelContactFace');
  end;
end;

{ TBisDesignDataFirmInsertFormIface }

constructor TBisDesignDataFirmInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='I_FIRM';
  ParentProviderName:='S_FIRMS';
  Caption:='������� �����������';
  SMessageSuccess:='����������� %SMALL_NAME ������� �������.';
end;

function TBisDesignDataFirmInsertFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
      with LastForm.Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentDataSet.FieldByName('PARENT_ID').Value);
        Params.ParamByName('PARENT_SMALL_NAME').SetNewValue(ParentDataSet.FieldByName('PARENT_SMALL_NAME').Value);
      end;
    end;
  end;
end;

{ TBisDesignDataFirmInsertChildFormIface }

constructor TBisDesignDataFirmInsertChildFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_FIRM';
  Caption:='������� �������� �����������';
end;

function TBisDesignDataFirmInsertChildFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
      with LastForm.Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentDataSet.FieldByName('FIRM_ID').Value);
        Params.ParamByName('PARENT_SMALL_NAME').SetNewValue(ParentDataSet.FieldByName('SMALL_NAME').Value);
      end;
    end;
  end;
end;

{ TBisDesignDataFirmUpdateFormIface }

constructor TBisDesignDataFirmUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_FIRM';
  Caption:='�������� �����������';
end;

{ TBisDesignDataFirmDeleteFormIface }

constructor TBisDesignDataFirmDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_FIRM';
  Caption:='������� �����������';
end;

{ TBisDesignDataFirmEditForm }

procedure TBisDesignDataFirmEditForm.EditSmallNameExit(Sender: TObject);
begin
  if (Mode in [emInsert,emDuplicate,emUpdate]) and
     (Trim(EditSmallName.Text)<>'') and (Trim(EditFullName.Text)='') then
    EditFullName.Text:=EditSmallName.Text;
end;

end.
