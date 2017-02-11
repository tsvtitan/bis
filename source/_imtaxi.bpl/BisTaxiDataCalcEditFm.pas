unit BisTaxiDataCalcEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisParam, BisControls, ImgList;

type
  TBisTaxiDataCalcEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelPercent: TLabel;
    EditPercent: TEdit;
    LabelSum: TLabel;
    EditSum: TEdit;
    LabelProc: TLabel;
    EditProc: TEdit;
  private
  public
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisTaxiDataCalcEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCalcFilterFormIface=class(TBisTaxiDataCalcEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCalcInsertFormIface=class(TBisTaxiDataCalcEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCalcUpdateFormIface=class(TBisTaxiDataCalcEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCalcDeleteFormIface=class(TBisTaxiDataCalcEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCalcEditForm: TBisTaxiDataCalcEditForm;

implementation

uses BisUtils;

{$R *.dfm}

{ TBisTaxiDataCalcEditFormIface }

constructor TBisTaxiDataCalcEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCalcEditForm;
  with Params do begin
    AddKey('CALC_ID').Older('OLD_CALC_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddComboBox('TYPE_CALC','ComboBoxType','LabelType',true);
    AddEdit('PROC_NAME','EditProc','LabelProc');
    AddEditFloat('PERCENT','EditPercent','LabelPercent');
    AddEditFloat('CALC_SUM','EditSum','LabelSum');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
  end;
end;

{ TBisTaxiDataCalcFilterFormIface }

constructor TBisTaxiDataCalcFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр рачетов';
end;

{ TBisTaxiDataCalcInsertFormIface }

constructor TBisTaxiDataCalcInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CALC';
  Caption:='Создать расчет';
end;

{ TBisTaxiDataCalcUpdateFormIface }

constructor TBisTaxiDataCalcUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CALC';
  Caption:='Изменить расчет';
end;

{ TBisTaxiDataCalcDeleteFormIface }

constructor TBisTaxiDataCalcDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CALC';
  Caption:='Удалить расчет';
end;

{ TBisTaxiDataCalcEditForm }

procedure TBisTaxiDataCalcEditForm.BeforeShow;
begin
  inherited BeforeShow;
end;

procedure TBisTaxiDataCalcEditForm.ChangeParam(Param: TBisParam);
var
  TypeCalc: Integer;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'TYPE_CALC') and not VarIsNull(Param.Value) and
     not (Mode in [emDelete,emFilter]) then begin
    TypeCalc:=VarToIntDef(Param.Value,0);
    Provider.Params.Find('PROC_NAME').Enabled:=false;
    Provider.Params.Find('PERCENT').Enabled:=false;
    Provider.Params.Find('CALC_SUM').Enabled:=false;
    case TypeCalc of
      1: Provider.Params.Find('PROC_NAME').Enabled:=true;
      2: Provider.Params.Find('PERCENT').Enabled:=true;
      3: Provider.Params.Find('CALC_SUM').Enabled:=true;
    end;
  end;
end;

end.
