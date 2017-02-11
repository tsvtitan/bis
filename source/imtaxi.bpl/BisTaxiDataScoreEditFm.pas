unit BisTaxiDataScoreEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, ComCtrls,
  BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataScoreEditForm = class(TBisDataEditForm)
    LabelRating: TLabel;
    EditRating: TEdit;
    ButtonRating: TButton;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelDriver: TLabel;
    EditDriver: TEdit;
    ButtonDriver: TButton;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    LabelCreator: TLabel;
    EditCreator: TEdit;
    EditAmount: TEdit;
    LabelAmount: TLabel;
    ButtonCreator: TButton;
  private
  public
    constructor Create(AOwner: TComponent); override;
    function CanShow: Boolean; override;
    procedure ChangeParam(Param: TBisParam); override;
    procedure BeforeShow; override;
  end;

  TBisTaxiDataScoreEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataScoreInsertFormIface=class(TBisTaxiDataScoreEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataScoreUpdateFormIface=class(TBisTaxiDataScoreEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataScoreDeleteFormIface=class(TBisTaxiDataScoreEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataScoreEditForm: TBisTaxiDataScoreEditForm;

implementation

uses BisUtils, BisCore, BisFilterGroups,
     BisTaxiConsts, BisParamEditDataSelect, BisParamEditInteger,
     BisDesignDataAccountsFm,
     BisTaxiDataDriversFm, BisTaxiDataRatingsFm;

{$R *.dfm}

{ TBisTaxiDataScoreEditFormIface }

constructor TBisTaxiDataScoreEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataScoreEditForm;
  with Params do begin
    AddKey('SCORE_ID').Older('OLD_SCORE_ID');
    AddEditDataSelect('DRIVER_ID','EditDriver','LabelDriver','ButtonDriver',
                      TBisTaxiDataDriversFormIface,'DRIVER_USER_NAME',true,false,'DRIVER_ID','USER_NAME');
    AddEditDataSelect('RATING_ID','EditRating','LabelRating','ButtonRating',
                      TBisTaxiDataRatingsFormIface,'RATING_NAME',true,false,'RATING_ID','NAME');
    AddEditInteger('AMOUNT','EditAmount','LabelAmount',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes(AllParamEditModes);
    AddEditDataSelect('CREATOR_ID','EditCreator','LabelCreator','ButtonCreator',
                       TBisDesignDataAccountsFormIface,'CREATOR_USER_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
  end;
end;

{ TBisTaxiDataScoreInsertFormIface }

constructor TBisTaxiDataScoreInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_SCORE';
  Caption:='������� ������ ��������';
end;

{ TBisTaxiDataScoreUpdateFormIface }

constructor TBisTaxiDataScoreUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_SCORE';
  Caption:='�������� ������ ��������';
end;

{ TBisTaxiDataScoreDeleteFormIface }

constructor TBisTaxiDataScoreDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_SCORE';
  Caption:='������� ������ ��������';
end;

{ TBisTaxiDataScoreEditForm }

procedure TBisTaxiDataScoreEditForm.BeforeShow;
begin
  inherited BeforeShow;

  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      Find('CREATOR_ID').SetNewValue(Core.AccountId);
      Find('CREATOR_USER_NAME').SetNewValue(Core.AccountUserName);
      Find('DATE_CREATE').SetNewValue(Core.ServerDate);
    end;
  end;
  
end;

function TBisTaxiDataScoreEditForm.CanShow: Boolean;
var
  Param: TBisParamEditDataSelect;
begin
  Result:=inherited CanShow;
  if Result and (Mode in [emInsert]) then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('RATING_ID'));
    if Assigned(Param) then
      Result:=Param.Select;
  end;
end;

procedure TBisTaxiDataScoreEditForm.ChangeParam(Param: TBisParam);
var
  RatingParam: TBisParamEditDataSelect;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'RATING_NAME') and not Param.Empty then begin
    RatingParam:=TBisParamEditDataSelect(Provider.Params.ParamByName('RATING_ID'));
    if RatingParam.Empty then
      Provider.Params.ParamByName('AMOUNT').SetNewValue(Null)
    else
      Provider.Params.ParamByName('AMOUNT').SetNewValue(RatingParam.Values.GetValue('SCORE'));
  end;
end;

constructor TBisTaxiDataScoreEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
