unit BisTaxiDataChargeFilterFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, StdCtrls, ComCtrls, ExtCtrls,
  BisTaxiDataChargeEditFm, BisControls;

type
  TBisTaxiDataChargeFilterForm = class(TBisTaxiDataChargeEditForm)
    LabelDateChargeTo: TLabel;
    DateTimePickerChargeTo: TDateTimePicker;
    DateTimePickerChargeToTime: TDateTimePicker;
    ButtonDateCharge: TButton;
    procedure ButtonDateChargeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataChargeFilterFormIface=class(TBisTaxiDataChargeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataChargeFilterForm: TBisTaxiDataChargeFilterForm;

implementation

uses DateUtils,
     BisCore, BisFilterGroups, BisParam, BisPeriodFm;

{$R *.dfm}

{ TBisTaxiDataChargeFilterFormIface }

constructor TBisTaxiDataChargeFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataChargeFilterForm;
  with Params do begin
    Unique:=false;
    with ParamByName('DATE_CHARGE') do begin
      Modes:=[emFilter];
      FilterCondition:=fcEqualGreater;
    end;
    with AddEditDateTime('DATE_CHARGE','DateTimePickerChargeTo','DateTimePickerChargeToTime','LabelDateChargeTo') do begin
      Modes:=[emFilter];
      FilterCondition:=fcEqualLess;
    end;
    with ParamByName('WHO_CREATE_ID') do begin
      Modes:=[emFilter];
    end;
  end;
  Caption:='������ ��������';
end;

{ TBisTaxiDataChargeFilterForm }

procedure TBisTaxiDataChargeFilterForm.ButtonDateChargeClick(Sender: TObject);
var
  AIface: TBisPeriodFormIface;
  PeriodType: TBisPeriodType;
  D1,D2: TDate;
begin
  AIface:=TBisPeriodFormIface.Create(nil);
  try
    PeriodType:=ptMonth;
    D1:=DateOf(Provider.Params.ParamByName('DATE_CHARGE').AsDateTime);
    D2:=DateOf(Provider.Params.ParamByName('DATE_CHARGE',1).AsDateTime);
    if AIface.Select(PeriodType,D1,D2) then begin
      Provider.Params.ParamByName('DATE_CHARGE').Value:=D1;
      Provider.Params.ParamByName('DATE_CHARGE',1).Value:=D2;
    end;
  finally
    AIface.Free;
  end;
end;

end.