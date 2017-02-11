unit BisTaxiDriverShiftInsertFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB,
  BisDataEditFm, BisParam, BisControls, ImgList;

type
  TBisTaxiDriverShiftInsertForm = class(TBisDataEditForm)
    LabelDriver: TLabel;
    EditDriver: TEdit;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    DateTimePickerBeginTime: TDateTimePicker;
    ButtonDriver: TButton;
    LabelCar: TLabel;
    EditCar: TEdit;
    LabelPark: TLabel;
    ComboBoxPark: TComboBox;
  private
  public
    procedure BeforeShow; override;
    function CanShow: Boolean; override;
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisTaxiDriverShiftInsertFormIface=class(TBisDataEditFormIface)
  private
    FCarTypeName: String;
    FCarTypeId: Variant;
    procedure SetCarTypeId(const Value: Variant);
  published
  public
    constructor Create(AOwner: TComponent); override;

    property CarTypeName: String read FCarTypeName write FCarTypeName;
    property CarTypeId: Variant read FCarTypeId write SetCarTypeId;
  end;

var
  BisTaxiDriverShiftInsertForm: TBisTaxiDriverShiftInsertForm;

implementation

uses BisUtils, BisTaxiConsts, BisCore, BisFilterGroups, BisDataFrm,
     BisTaxiDataDriversFm, BisTaxiDataParksFm, BisParamEditDataSelect, BisParamComboBoxDataSelect;

{$R *.dfm}

type
  TBisTaxiDataDriversFormIface=class(BisTaxiDataDriversFm.TBisTaxiDataDriversFormIface)
  protected
    procedure SetDataFrameProperties(DataFrame: TBisDataFrame); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataParksFormIface=class(BisTaxiDataParksFm.TBisTaxiDataParksFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

{ TBisTaxiDataDriversFormIface }

constructor TBisTaxiDataDriversFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisTaxiDataDriversFormIface.SetDataFrameProperties(DataFrame: TBisDataFrame);
begin
  inherited SetDataFrameProperties(DataFrame);
  if Assigned(DataFrame) then
    DataFrame.Provider.ProviderName:='S_DRIVER_FREE';
end;

{ TBisTaxiDataParksFormIface }

constructor TBisTaxiDataParksFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='S_PARK_FREE';
  Caption:='Свободные стоянки';
end;

{ TBisTaxiDriverShiftInsertFormIface }

constructor TBisTaxiDriverShiftInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDriverShiftInsertForm;
  ProviderName:='I_DRIVER_SHIFT';
  Caption:='Открыть смену водителя';
  with Params do begin
    AddKey('SHIFT_ID').Older('OLD_SHIFT_ID');
    AddInvisible('DRIVER_USER_NAME');
    AddInvisible('DRIVER_SURNAME');
    AddInvisible('DRIVER_NAME');
    AddInvisible('DRIVER_PATRONYMIC');
    AddInvisible('DRIVER_PHONE');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('CAR_ID');
    AddInvisible('CAR_CALLSIGN');
    AddInvisible('CAR_TYPE_NAME');
    AddInvisible('CAR_TYPE_FONT_COLOR');
    AddInvisible('CAR_TYPE_BRUSH_COLOR');
    AddInvisible('CAR_COLOR');
    AddInvisible('CAR_BRAND');
    AddInvisible('CAR_STATE_NUM');
    AddInvisible('PARK_NAME');
    AddInvisible('PARK_DESCRIPTION');
    with AddEditDataSelect('DRIVER_ID','EditDriver','LabelDriver','ButtonDriver',
                           TBisTaxiDataDriversFormIface,'DRIVER_USER_NAME;DRIVER_SURNAME;DRIVER_NAME;DRIVER_PATRONYMIC',
                           true,false,'','USER_NAME;SURNAME;NAME;PATRONYMIC') do begin
      DataAliasFormat:='%s - %s %s %s';
    end;
    AddEdit('CAR_COLOR;CAR_BRAND;CAR_STATE_NUM','EditCar','LabelCar').ParamFormat:='%s %s %s';
    with AddComboBoxDataSelect('PARK_ID','ComboBoxPark','LabelPark','',
                               TBisTaxiDataParksFormIface,'PARK_NAME;PARK_DESCRIPTION',false,false,'','NAME;DESCRIPTION') do begin
      DataAliasFormat:='%s - %s';
    end;
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin',true);
  end;
end;

procedure TBisTaxiDriverShiftInsertFormIface.SetCarTypeId(const Value: Variant);
var
  DriverParam: TBisParamEditDataSelect;
begin
  FCarTypeId := Value;
  if not VarIsNull(FCarTypeId) then begin
    DriverParam:=TBisParamEditDataSelect(Params.ParamByName('DRIVER_ID'));
    DriverParam.DataCaption:=FormatEx('Свободные водители - %s',[FCarTypeName]);
    DriverParam.FilterGroups.Clear;
    with DriverParam.FilterGroups.Add do begin
      Filters.AddInside('CAR_ID','','S_CAR_IN_TYPES').InsideFilterGroups.Add.Filters.Add('CAR_TYPE_ID',fcEqual,FCarTypeId).CheckCase:=true;
    end;
  end;
end;


{ TBisTaxiDriverShiftEditForm }

function TBisTaxiDriverShiftInsertForm.CanShow: Boolean;
var
  Param: TBisParamEditDataSelect;
begin
  Result:=inherited CanShow;
  if Result then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('DRIVER_ID'));
    if Assigned(Param) then
      Result:=Param.Select;
  end;
end;

procedure TBisTaxiDriverShiftInsertForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      Find('ACCOUNT_ID').SetNewValue(Core.AccountId);
      Find('DATE_BEGIN').SetNewValue(Core.ServerDate);
    end;
    UpdateButtonState;
  end;
end;

procedure TBisTaxiDriverShiftInsertForm.ChangeParam(Param: TBisParam);
var
  DriverParam: TBisParamEditDataSelect;
  ParkParam: TBisParamComboBoxDataSelect;
  P1: TBisParam;
begin
  inherited ChangeParam(Param);

  if AnsiSameText(Param.ParamName,'DRIVER_USER_NAME;DRIVER_SURNAME;DRIVER_NAME;DRIVER_PATRONYMIC') then begin
    DriverParam:=TBisParamEditDataSelect(Provider.Params.ParamByName('DRIVER_ID'));
    if DriverParam.Empty then begin
      Provider.Params.ParamByName('DRIVER_USER_NAME').SetNewValue(Null);
      Provider.Params.ParamByName('DRIVER_SURNAME').SetNewValue(Null);
      Provider.Params.ParamByName('DRIVER_NAME').SetNewValue(Null);
      Provider.Params.ParamByName('DRIVER_PATRONYMIC').SetNewValue(Null);
      Provider.Params.ParamByName('DRIVER_PHONE').SetNewValue(Null);
      Provider.Params.ParamByName('CAR_ID').SetNewValue(Null);
      Provider.Params.ParamByName('CAR_CALLSIGN').SetNewValue(Null);
      Provider.Params.ParamByName('CAR_COLOR;CAR_BRAND;CAR_STATE_NUM').SetNewValue(Null);
      Provider.Params.ParamByName('CAR_COLOR').SetNewValue(Null);
      Provider.Params.ParamByName('CAR_BRAND').SetNewValue(Null);
      Provider.Params.ParamByName('CAR_STATE_NUM').SetNewValue(Null);
    end else begin
      Provider.Params.ParamByName('DRIVER_USER_NAME').SetNewValue(DriverParam.Values.ValueByName('USER_NAME').Value);
      Provider.Params.ParamByName('DRIVER_SURNAME').SetNewValue(DriverParam.Values.ValueByName('SURNAME').Value);
      Provider.Params.ParamByName('DRIVER_NAME').SetNewValue(DriverParam.Values.ValueByName('NAME').Value);
      Provider.Params.ParamByName('DRIVER_PATRONYMIC').SetNewValue(DriverParam.Values.ValueByName('PATRONYMIC').Value);
      Provider.Params.ParamByName('DRIVER_PHONE').SetNewValue(DriverParam.Values.ValueByName('PHONE').Value);
      Provider.Params.ParamByName('CAR_ID').SetNewValue(DriverParam.Values.ValueByName('CAR_ID').Value);
      Provider.Params.ParamByName('CAR_CALLSIGN').SetNewValue(DriverParam.Values.ValueByName('CAR_CALLSIGN').Value);
      P1:=Provider.Params.ParamByName('CAR_COLOR;CAR_BRAND;CAR_STATE_NUM');
      P1.SetNewValue(FormatEx(P1.ParamFormat,[DriverParam.Values.ValueByName('CAR_COLOR').Value,
                                              DriverParam.Values.ValueByName('CAR_BRAND').Value,
                                              DriverParam.Values.ValueByName('CAR_STATE_NUM').Value]));
      Provider.Params.ParamByName('CAR_COLOR').SetNewValue(DriverParam.Values.ValueByName('CAR_COLOR').Value);
      Provider.Params.ParamByName('CAR_BRAND').SetNewValue(DriverParam.Values.ValueByName('CAR_BRAND').Value);
      Provider.Params.ParamByName('CAR_STATE_NUM').SetNewValue(DriverParam.Values.ValueByName('CAR_STATE_NUM').Value);
    end;
  end;

  if AnsiSameText(Param.ParamName,'PARK_NAME;PARK_DESCRIPTION') then begin
    ParkParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('PARK_ID'));
    if ParkParam.Empty then begin
      Provider.Params.ParamByName('PARK_NAME').SetNewValue(Null);
      Provider.Params.ParamByName('PARK_DESCRIPTION').SetNewValue(Null);
    end else begin
      Provider.Params.ParamByName('PARK_NAME').SetNewValue(ParkParam.Values.GetValue('NAME'));
      Provider.Params.ParamByName('PARK_DESCRIPTION').SetNewValue(ParkParam.Values.GetValue('DESCRIPTION'));
    end;
  end;

end;

end.
