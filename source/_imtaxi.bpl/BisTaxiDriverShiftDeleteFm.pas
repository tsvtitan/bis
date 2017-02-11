unit BisTaxiDriverShiftDeleteFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB,
  BisDataEditFm, BisParam, BisControls, ImgList;

type
  TBisTaxiDriverShiftDeleteForm = class(TBisDataEditForm)
    LabelDriver: TLabel;
    EditDriver: TEdit;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    DateTimePickerBeginTime: TDateTimePicker;
    LabelCar: TLabel;
    EditCar: TEdit;
    LabelPark: TLabel;
    EditPark: TEdit;
    DateTimePickerEnd: TDateTimePicker;
    DateTimePickerEndTime: TDateTimePicker;
    LabelDateEnd: TLabel;
    CheckBoxLocked: TCheckBox;
  private
  public
    procedure BeforeShow; override;
  end;

  TBisTaxiDriverShiftDeleteFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDriverShiftDeleteForm: TBisTaxiDriverShiftDeleteForm;

implementation

uses BisUtils, BisTaxiConsts, BisCore, BisFilterGroups;

{$R *.dfm}

{ TBisTaxiDriverShiftDeleteFormIface }

constructor TBisTaxiDriverShiftDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDriverShiftDeleteForm;
  ProviderName:='D_DRIVER_SHIFT';
  Caption:='������� ����� ��������';
  with Params do begin
    AddKey('SHIFT_ID').Older('OLD_SHIFT_ID');
    AddInvisible('DRIVER_ID');
    AddInvisible('DRIVER_USER_NAME');
    AddInvisible('DRIVER_SURNAME');
    AddInvisible('DRIVER_NAME');
    AddInvisible('DRIVER_PATRONYMIC');

    AddInvisible('ACCOUNT_ID');
    AddInvisible('PARK_ID');
    AddInvisible('CAR_COLOR');
    AddInvisible('CAR_BRAND');
    AddInvisible('CAR_STATE_NUM');
    AddInvisible('PARK_NAME');
    AddInvisible('PARK_DESCRIPTION');

    AddEdit('DRIVER_USER_NAME;DRIVER_SURNAME;DRIVER_NAME;DRIVER_PATRONYMIC','EditDriver','LabelDriver').ParamFormat:='%s - %s %s %s';
    AddEdit('CAR_COLOR;CAR_BRAND;CAR_STATE_NUM','EditCar','LabelCar').ParamFormat:='%s %s %s';
    AddEdit('PARK_NAME;PARK_DESCRIPTION','EditPark','LabelPark').ParamFormat:='%s - %s';

    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin').ExcludeModes(AllParamEditModes);
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd',true);

    AddCheckBox('LOCKED','CheckBoxLocked');
  end;
end;

{ TBisTaxiDriverShiftEditForm }

procedure TBisTaxiDriverShiftDeleteForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emDelete] then begin
    with Provider.Params do begin
      Find('ACCOUNT_ID').SetNewValue(Core.AccountId);
      Find('DATE_END').SetNewValue(Core.ServerDate);
      Find('DATE_END').Enabled:=true;
      Find('LOCKED').Enabled:=true;
    end;
    UpdateButtonState;
  end;
end;

end.
