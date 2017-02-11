unit BisTaxiDriverParkDeleteFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList,
  BisFm, BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDriverParkDeleteForm = class(TBisDataEditForm)
    LabelDriver: TLabel;
    EditDriver: TEdit;
    LabelDateIn: TLabel;
    DateTimePickerIn: TDateTimePicker;
    DateTimePickerInTime: TDateTimePicker;
    LabelCar: TLabel;
    EditCar: TEdit;
    LabelPark: TLabel;
    EditPark: TEdit;
    DateTimePickerOut: TDateTimePicker;
    DateTimePickerOutTime: TDateTimePicker;
    LabelDateOut: TLabel;
  private
    FDriverUserName: Variant;
    FParkId: Variant;
    FParkDescription: Variant;
    FDriverId: Variant;
    FParkName: Variant;
    FDriverPatronymic: Variant;
    FDriverName: Variant;
    FDriverSurname: Variant;
  public
    procedure BeforeShow; override;

    property DriverId: Variant read FDriverId write FDriverId;
    property DriverUserName: Variant read FDriverUserName write FDriverUserName;
    property DriverSurname: Variant read FDriverSurname write FDriverSurname;
    property DriverName: Variant read FDriverName write FDriverName;
    property DriverPatronymic: Variant read FDriverPatronymic write FDriverPatronymic;

    property ParkId: Variant read FParkId write FParkId;
    property ParkName: Variant read FParkName write FParkName;
    property ParkDescription: Variant read FParkDescription write FParkDescription;
  end;

  TBisTaxiDriverParkDeleteFormIface=class(TBisDataEditFormIface)
  private
    FDriverId: Variant;
    FDriverUserName: Variant;
    FParkId: Variant;
    FParkName: Variant;
    FParkDescription: Variant;
    FDriverSurname: Variant;
    FDriverName: Variant;
    FDriverPatronymic: Variant;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property DriverId: Variant read FDriverId write FDriverId;
    property DriverUserName: Variant read FDriverUserName write FDriverUserName;
    property DriverSurname: Variant read FDriverSurname write FDriverSurname;
    property DriverName: Variant read FDriverName write FDriverName;
    property DriverPatronymic: Variant read FDriverPatronymic write FDriverPatronymic;

    property ParkId: Variant read FParkId write FParkId;
    property ParkName: Variant read FParkName write FParkName;
    property ParkDescription: Variant read FParkDescription write FParkDescription;
  end;

var
  BisTaxiDriverParkDeleteForm: TBisTaxiDriverParkDeleteForm;

implementation

uses BisUtils, BisTaxiConsts, BisCore, BisFilterGroups;

{$R *.dfm}

{ TBisTaxiDriverParkDeleteFormIface }

constructor TBisTaxiDriverParkDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDriverParkDeleteForm;
  ProviderName:='D_DRIVER_PARK';
  Caption:='Снять со стоянки';
  with Params do begin

    AddInvisible('ID').IsKey:=true;

    AddInvisible('DRIVER_ID');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('PARK_ID');
    AddInvisible('CAR_COLOR');
    AddInvisible('CAR_BRAND');
    AddInvisible('CAR_STATE_NUM');
    AddInvisible('DRIVER_USER_NAME');
    AddInvisible('DRIVER_SURNAME');
    AddInvisible('DRIVER_NAME');
    AddInvisible('DRIVER_PATRONYMIC');
    AddInvisible('PARK_NAME');
    AddInvisible('PARK_DESCRIPTION');

    AddEdit('DRIVER_USER_NAME;DRIVER_SURNAME;DRIVER_NAME;DRIVER_PATRONYMIC','EditDriver','LabelDriver').ParamFormat:='%s - %s %s %s';
    AddEdit('CAR_COLOR;CAR_BRAND;CAR_STATE_NUM','EditCar','LabelCar').ParamFormat:='%s %s %s';
    AddEdit('PARK_NAME;PARK_DESCRIPTION','EditPark','LabelPark').ParamFormat:='%s - %s';

    AddEditDateTime('DATE_IN','DateTimePickerIn','DateTimePickerInTime','LabelDateIn').ExcludeModes(AllParamEditModes);
    AddEditDateTime('DATE_OUT','DateTimePickerOut','DateTimePickerOutTime','LabelDateOut',true);
  end;
end;

function TBisTaxiDriverParkDeleteFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    TBisTaxiDriverParkDeleteForm(Result).DriverId:=FDriverId;
    TBisTaxiDriverParkDeleteForm(Result).DriverUserName:=FDriverUserName;
    TBisTaxiDriverParkDeleteForm(Result).DriverSurname:=FDriverSurname;
    TBisTaxiDriverParkDeleteForm(Result).DriverName:=FDriverName;
    TBisTaxiDriverParkDeleteForm(Result).DriverPatronymic:=FDriverPatronymic;
    TBisTaxiDriverParkDeleteForm(Result).ParkId:=FParkId;
    TBisTaxiDriverParkDeleteForm(Result).ParkName:=FParkName;
    TBisTaxiDriverParkDeleteForm(Result).ParkDescription:=FParkDescription;
  end;
end;

{ TBisTaxiDriverParkEditForm }

procedure TBisTaxiDriverParkDeleteForm.BeforeShow;
var
  Param, ParamParkName, ParamParkDescription: TBisParam;
  ParamDriverUserName, ParamDriverSurname, ParamDriverName, ParamDriverPatronymic: TBisParam;
begin
  inherited BeforeShow;
  if Mode in [emDelete] then begin
    with Provider.Params do begin
      Find('ACCOUNT_ID').SetNewValue(Core.AccountId);
      Find('DRIVER_ID').SetNewValue(FDriverId);
      ParamDriverUserName:=Find('DRIVER_USER_NAME');
      ParamDriverUserName.SetNewValue(FDriverUserName);
      ParamDriverSurname:=Find('DRIVER_SURNAME');
      ParamDriverSurname.SetNewValue(FDriverSurname);
      ParamDriverName:=Find('DRIVER_NAME');
      ParamDriverName.SetNewValue(FDriverName);
      ParamDriverPatronymic:=Find('DRIVER_PATRONYMIC');
      ParamDriverPatronymic.SetNewValue(FDriverPatronymic);
      Param:=Find('DRIVER_USER_NAME;DRIVER_SURNAME;DRIVER_NAME;DRIVER_PATRONYMIC');
      Param.SetNewValue(FormatEx(Param.ParamFormat,[ParamDriverUserName.Value,ParamDriverSurname.Value,
                                                    ParamDriverName.Value,ParamDriverPatronymic.Value]));
      Find('PARK_ID').SetNewValue(FParkId);
      ParamParkName:=Find('PARK_NAME');
      ParamParkName.SetNewValue(FParkName);
      ParamParkDescription:=Find('PARK_DESCRIPTION');
      ParamParkDescription.SetNewValue(FParkDescription);
      Param:=Find('PARK_NAME;PARK_DESCRIPTION');
      Param.SetNewValue(FormatEx(Param.ParamFormat,[ParamParkName.Value,ParamParkDescription.Value]));
      Find('DATE_OUT').SetNewValue(Core.ServerDate);
      Find('DATE_OUT').Enabled:=true;
    end;
    UpdateButtonState;
  end;
end;

end.
