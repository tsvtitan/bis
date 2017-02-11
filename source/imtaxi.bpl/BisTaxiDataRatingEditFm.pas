unit BisTaxiDataRatingEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataRatingEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;                                                                                  
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    CheckBoxVisible: TCheckBox;
    LabelScore: TLabel;
    EditScore: TEdit;
  private
  public
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisTaxiDataRatingEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataRatingFilterFormIface=class(TBisTaxiDataRatingEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataRatingInsertFormIface=class(TBisTaxiDataRatingEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataRatingUpdateFormIface=class(TBisTaxiDataRatingEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataRatingDeleteFormIface=class(TBisTaxiDataRatingEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataRatingEditForm: TBisTaxiDataRatingEditForm;

implementation

uses BisUtils;

{$R *.dfm}

{ TBisTaxiDataRatingEditFormIface }

constructor TBisTaxiDataRatingEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataRatingEditForm;
  with Params do begin
    AddKey('RATING_ID').Older('OLD_RATING_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddComboBox('TYPE_RATING','ComboBoxType','LabelType',true);
    AddEditInteger('SCORE','EditScore','LabelScore');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddCheckBox('VISIBLE','CheckBoxVisible',1);
  end;
end;

{ TBisTaxiDataRatingFilterFormIface }

constructor TBisTaxiDataRatingFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ����� ������';
end;

{ TBisTaxiDataRatingInsertFormIface }

constructor TBisTaxiDataRatingInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_RATING';
  Caption:='������� ��� ������';
end;

{ TBisTaxiDataRatingUpdateFormIface }

constructor TBisTaxiDataRatingUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_RATING';
  Caption:='�������� ��� ������';
end;

{ TBisTaxiDataRatingDeleteFormIface }

constructor TBisTaxiDataRatingDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_RATING';
  Caption:='������� ��� ������';
end;

{ TBisTaxiDataDiscountEditForm }

procedure TBisTaxiDataRatingEditForm.ChangeParam(Param: TBisParam);
begin
  inherited ChangeParam(Param);
end;

end.