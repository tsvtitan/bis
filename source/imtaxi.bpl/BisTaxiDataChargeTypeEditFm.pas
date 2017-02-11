unit BisTaxiDataChargeTypeEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataChargeTypeEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;                                                                         
    LabelSum: TLabel;
    EditSum: TEdit;
    CheckBoxVirtual: TCheckBox;
    CheckBoxVisible: TCheckBox;
  private
  public
  end;

  TBisTaxiDataChargeTypeEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataChargeTypeFilterFormIface=class(TBisTaxiDataChargeTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataChargeTypeInsertFormIface=class(TBisTaxiDataChargeTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataChargeTypeUpdateFormIface=class(TBisTaxiDataChargeTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataChargeTypeDeleteFormIface=class(TBisTaxiDataChargeTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataChargeTypeEditForm: TBisTaxiDataChargeTypeEditForm;

implementation

uses BisUtils;

{$R *.dfm}

{ TBisTaxiDataChargeTypeEditFormIface }

constructor TBisTaxiDataChargeTypeEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataChargeTypeEditForm;
  with Params do begin
    AddKey('CHARGE_TYPE_ID').Older('OLD_CHARGE_TYPE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditFloat('SUM_CHARGE','EditSum','LabelSum');
    AddCheckBox('VIRTUAL','CheckBoxVirtual').Value:=0;
    AddCheckBox('VISIBLE','CheckBoxVisible').Value:=1;
  end;
end;

{ TBisTaxiDataChargeTypeFilterFormIface }

constructor TBisTaxiDataChargeTypeFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ����� ��������';
end;

{ TBisTaxiDataChargeTypeInsertFormIface }

constructor TBisTaxiDataChargeTypeInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CHARGE_TYPE';
  Caption:='������� ��� ��������';
end;

{ TBisTaxiDataChargeTypeUpdateFormIface }

constructor TBisTaxiDataChargeTypeUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CHARGE_TYPE';
  Caption:='�������� ��� ��������';
end;

{ TBisTaxiDataChargeTypeDeleteFormIface }

constructor TBisTaxiDataChargeTypeDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CHARGE_TYPE';
  Caption:='������� ��� ��������';
end;

end.
