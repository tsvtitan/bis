unit BisLotoTiragePrizeEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type
  TBisLotoTiragePrizeEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelRoundNum: TLabel;
    LabelCost: TLabel;
    EditCost: TEdit;
    ComboBoxRoundNum: TComboBox;
  private
  public
  end;

  TBisLotoTiragePrizeEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisLotoTiragePrizeFilterFormIface=class(TBisLotoTiragePrizeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisLotoTiragePrizeInsertFormIface=class(TBisLotoTiragePrizeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisLotoTiragePrizeUpdateFormIface=class(TBisLotoTiragePrizeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisLotoTiragePrizeDeleteFormIface=class(TBisLotoTiragePrizeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisLotoTiragePrizeEditForm: TBisLotoTiragePrizeEditForm;

implementation

uses
     BisUtils, BisLotoConsts, 
     BisValues;

{$R *.dfm}

{ TBisLotoTiragePrizeEditFormIface }

constructor TBisLotoTiragePrizeEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisLotoTiragePrizeEditForm;
  with Params do begin
    AddKey('PRIZE_ID').Older('OLD_PRIZE_ID');
    AddInvisible('TIRAGE_ID');
    AddComboBoxText('ROUND_NUM','ComboBoxRoundNum','LabelRoundNum',true).ExcludeModes(AllParamEditModes);
    AddEdit('NAME','EditName','LabelName',true);
    AddEditCalc('COST','EditCost','LabelCost',true);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisLotoTiragePrizeFilterFormIface }

constructor TBisLotoTiragePrizeFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр призов';
end;

{ TBisLotoTiragePrizeInsertFormIface }

constructor TBisLotoTiragePrizeInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PRIZE';
  Caption:='Создать приз';
end;

{ TBisLotoTiragePrizeUpdateFormIface }

constructor TBisLotoTiragePrizeUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PRIZE';
  Caption:='Изменить приз';
end;

{ TBisLotoTiragePrizeDeleteFormIface }

constructor TBisLotoTiragePrizeDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PRIZE';
  Caption:='Удалить приз';
end;


end.
