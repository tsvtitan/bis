unit BisTaxiDataClientPhoneEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, ComCtrls,
  BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataClientPhoneEditForm = class(TBisDataEditForm)
    LabelPhone: TLabel;
    EditPhone: TEdit;
    LabelMethod: TLabel;
    LabelClient: TLabel;
    EditClient: TEdit;
    ButtonClient: TButton;                                                                         
    LabelDescription: TLabel;
    ComboBoxMethod: TComboBox;
    EditDescription: TEdit;
  private
  public
  end;

  TBisTaxiDataClientPhoneEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientPhoneFilterFormIface=class(TBisTaxiDataClientPhoneEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientPhoneInsertFormIface=class(TBisTaxiDataClientPhoneEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientPhoneUpdateFormIface=class(TBisTaxiDataClientPhoneEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientPhoneDeleteFormIface=class(TBisTaxiDataClientPhoneEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataClientPhoneEditForm: TBisTaxiDataClientPhoneEditForm;

implementation

uses BisUtils, BisCore, BisFilterGroups,
     BisTaxiDataClientsFm, BisTaxiDataMethodsFm;

{$R *.dfm}

{ TBisTaxiDataClientPhoneEditFormIface }

constructor TBisTaxiDataClientPhoneEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataClientPhoneEditForm;
  with Params do begin
    AddEditDataSelect('CLIENT_ID','EditClient','LabelClient','ButtonClient',
                      TBisTaxiDataClientsFormIface,'USER_NAME',true,true,'ID').Older('OLD_CLIENT_ID');
    with AddEdit('PHONE','EditPhone','LabelPhone',true) do begin
      IsKey:=true;
      Older('OLD_PHONE');
    end;
    AddComboBoxDataSelect('METHOD_ID','ComboBoxMethod','LabelMethod','',
                          TBisTaxiDataMethodsFormIface,'METHOD_NAME',false,false,'','NAME');
    AddEdit('DESCRIPTION','EditDescription','LabelDescription');
  end;
end;

{ TBisTaxiDataClientPhoneFilterFormIface }

constructor TBisTaxiDataClientPhoneFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ���������';
end;

{ TBisTaxiDataClientPhoneInsertFormIface }

constructor TBisTaxiDataClientPhoneInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CLIENT_PHONE';
  Caption:='������� �������';
end;

{ TBisTaxiDataClientPhoneUpdateFormIface }

constructor TBisTaxiDataClientPhoneUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CLIENT_PHONE';
  Caption:='�������� �������';
end;

{ TBisTaxiDataClientPhoneDeleteFormIface }

constructor TBisTaxiDataClientPhoneDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CLIENT_PHONE';
  Caption:='������� �������';
end;

end.