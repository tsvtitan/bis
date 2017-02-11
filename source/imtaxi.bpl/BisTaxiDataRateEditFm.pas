unit BisTaxiDataRateEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type                                                                                                    
  TBisTaxiDataRateEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelSum: TLabel;
    EditSum: TEdit;
    LabelProc: TLabel;
    EditProc: TEdit;
    LabelPeriod: TLabel;
    EditPeriod: TEdit;
    LabelRoundUp: TLabel;
    EditRoundUp: TEdit;
  private
  public
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisTaxiDataRateEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataRateFilterFormIface=class(TBisTaxiDataRateEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataRateInsertFormIface=class(TBisTaxiDataRateEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataRateUpdateFormIface=class(TBisTaxiDataRateEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataRateDeleteFormIface=class(TBisTaxiDataRateEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataRateEditForm: TBisTaxiDataRateEditForm;

implementation

uses BisUtils;

{$R *.dfm}

{ TBisTaxiDataRateEditFormIface }

constructor TBisTaxiDataRateEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataRateEditForm;
  with Params do begin
    AddKey('RATE_ID').Older('OLD_RATE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddComboBox('TYPE_RATE','ComboBoxType','LabelType',true);
    AddEdit('PROC_NAME','EditProc','LabelProc');
    AddEditFloat('RATE_SUM','EditSum','LabelSum');
    AddEditInteger('PERIOD','EditPeriod','LabelPeriod');
    AddEditFloat('ROUND_UP','EditRoundUp','LabelRoundUp');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
  end;
end;

{ TBisTaxiDataRateFilterFormIface }

constructor TBisTaxiDataRateFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр тарифов';
end;

{ TBisTaxiDataRateInsertFormIface }

constructor TBisTaxiDataRateInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_RATE';
  Caption:='Создать тариф';
end;

{ TBisTaxiDataRateUpdateFormIface }

constructor TBisTaxiDataRateUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_RATE';
  Caption:='Изменить тариф';
end;

{ TBisTaxiDataRateDeleteFormIface }

constructor TBisTaxiDataRateDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_RATE';
  Caption:='Удалить тариф';
end;

{ TBisTaxiDataRateEditForm }

procedure TBisTaxiDataRateEditForm.BeforeShow;
begin
  inherited BeforeShow;
end;

procedure TBisTaxiDataRateEditForm.ChangeParam(Param: TBisParam);
begin
  inherited ChangeParam(Param);
end;

end.
