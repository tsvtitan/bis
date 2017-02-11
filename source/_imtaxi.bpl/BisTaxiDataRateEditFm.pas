unit BisTaxiDataRateEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisParam, BisControls, ImgList;

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
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
  end;
end;

{ TBisTaxiDataRateFilterFormIface }

constructor TBisTaxiDataRateFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ �������';
end;

{ TBisTaxiDataRateInsertFormIface }

constructor TBisTaxiDataRateInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_RATE';
  Caption:='������� �����';
end;

{ TBisTaxiDataRateUpdateFormIface }

constructor TBisTaxiDataRateUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_RATE';
  Caption:='�������� �����';
end;

{ TBisTaxiDataRateDeleteFormIface }

constructor TBisTaxiDataRateDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_RATE';
  Caption:='������� �����';
end;

{ TBisTaxiDataRateEditForm }

procedure TBisTaxiDataRateEditForm.BeforeShow;
begin
  inherited BeforeShow;
end;

procedure TBisTaxiDataRateEditForm.ChangeParam(Param: TBisParam);
{var
  TypeRate: Integer; }
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'TYPE_RATE') and not VarIsNull(Param.Value) and
     not (Mode in [emDelete,emFilter]) then begin
    //TypeRate:=VarToIntDef(Param.Value,0);
  {  Provider.Params.Find('PROC_NAME').Enabled:=false;
    Provider.Params.Find('RATE_SUM').Enabled:=false;
    case TypeRate of
      1: Provider.Params.Find('PROC_NAME').Enabled:=true;
      3,4: Provider.Params.Find('RATE_SUM').Enabled:=true;
      5: Provider.Params.Find('RATE_SUM').Enabled:=true;
    end; }
  end;
end;

end.