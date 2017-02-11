unit BisTaxiDataDiscountEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, ComCtrls,
  BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataDiscountEditForm = class(TBisDataEditForm)
    LabelNum: TLabel;
    EditNum: TEdit;
    LabelPriority: TLabel;
    EditPriority: TEdit;                                                                      
    LabelDiscountType: TLabel;
    EditDiscountType: TEdit;
    ButtonDiscountType: TButton;
    LabelClient: TLabel;
    EditClient: TEdit;
    ButtonClient: TButton;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
  private
  public
    procedure BeforeShow; override;
  end;

  TBisTaxiDataDiscountEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDiscountFilterFormIface=class(TBisTaxiDataDiscountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDiscountInsertFormIface=class(TBisTaxiDataDiscountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDiscountUpdateFormIface=class(TBisTaxiDataDiscountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDiscountDeleteFormIface=class(TBisTaxiDataDiscountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDiscountEditForm: TBisTaxiDataDiscountEditForm;

implementation

uses BisUtils, BisCore, BisFilterGroups,
     BisTaxiDataDiscountTypesFm, BisTaxiDataClientsFm;

{$R *.dfm}

{ TBisTaxiDataDiscountEditFormIface }

constructor TBisTaxiDataDiscountEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDiscountEditForm;
  with Params do begin
    AddKey('DISCOUNT_ID').Older('OLD_DISCOUNT_ID');
    AddEditDataSelect('CLIENT_ID','EditClient','LabelClient','ButtonClient',
                      TBisTaxiDataClientsFormIface,'USER_NAME',true,false,'ID');
    AddEditDataSelect('DISCOUNT_TYPE_ID','EditDiscountType','LabelDiscountType','ButtonDiscountType',
                      TBisTaxiDataDiscountTypesFormIface,'DISCOUNT_TYPE_NAME',true,false,'','NAME');
    AddEdit('NUM','EditNum','LabelNum',true);
    AddEditDate('DATE_BEGIN','DateTimePickerBegin','LabelDateBegin',true).FilterCondition:=fcEqualGreater;
    AddEditDate('DATE_END','DateTimePickerEnd','LabelDateEnd');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
  end;
end;


{ TBisTaxiDataDiscountFilterFormIface }

constructor TBisTaxiDataDiscountFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ���������';
end;

{ TBisTaxiDataDiscountInsertFormIface }

constructor TBisTaxiDataDiscountInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_DISCOUNT';
  Caption:='������� �������';
end;

{ TBisTaxiDataDiscountUpdateFormIface }

constructor TBisTaxiDataDiscountUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_DISCOUNT';
  Caption:='�������� �������';
end;

{ TBisTaxiDataDiscountDeleteFormIface }

constructor TBisTaxiDataDiscountDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_DISCOUNT';
  Caption:='������� �������';
end;


{ TBisTaxiDataDiscountEditForm }

procedure TBisTaxiDataDiscountEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      Find('DATE_BEGIN').SetNewValue(Core.ServerDate);
    end;
  end;
end;

end.
