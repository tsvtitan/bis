unit BisDesignDataAlarmFilterFm;

interface

uses                                                                                                              
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ComCtrls, ExtCtrls,
  BisDesignDataAlarmEditFm, BisControls;

type
  TBisDesignDataAlarmFilterForm = class(TBisDesignDataAlarmEditForm)
    LabelDateBeginTo: TLabel;
    DateTimePickerBeginTo: TDateTimePicker;
    DateTimePickerBeginToTime: TDateTimePicker;
    ButtonDateBegin: TButton;
    LabelDateEndTo: TLabel;
    DateTimePickerEndTo: TDateTimePicker;
    DateTimePickerEndToTime: TDateTimePicker;
    ButtonDateEnd: TButton;
    procedure ButtonDateBeginClick(Sender: TObject);
    procedure ButtonDateEndClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataAlarmFilterFormIface=class(TBisDesignDataAlarmEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataAlarmFilterForm: TBisDesignDataAlarmFilterForm;

implementation

uses DateUtils,
     BisParamEditDataSelect, BisFilterGroups, BisParam, BisPeriodFm;

{$R *.dfm}

{ TBisDesignDataAlarmFilterFormIface }

constructor TBisDesignDataAlarmFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataAlarmFilterForm;
  with Params do begin
    Unique:=false;

    ParamByName('DATE_BEGIN').FilterCondition:=fcEqualGreater;
    ParamByName('DATE_END').FilterCondition:=fcEqualGreater;

    with AddEditDateTime('DATE_BEGIN','DateTimePickerBeginTo','DateTimePickerBeginToTime','LabelDateBeginTo') do begin
      FilterCondition:=fcEqualLess;
      FilterCaption:='Дата начала по:';
    end;

    with AddEditDateTime('DATE_END','DateTimePickerEndTo','DateTimePickerEndToTime','LabelDateEndTo') do begin
      FilterCondition:=fcEqualLess;
      FilterCaption:='Дата окончания по:';
    end;

  end;
  Caption:='Фильтр оповещений';
end;

procedure TBisDesignDataAlarmFilterForm.ButtonDateBeginClick(Sender: TObject);
var
  AIface: TBisPeriodFormIface;
  PeriodType: TBisPeriodType;
  D1,D2: TDate;
begin
  AIface:=TBisPeriodFormIface.Create(nil);
  try
    PeriodType:=ptMonth;
    D1:=DateOf(Provider.Params.ParamByName('DATE_BEGIN').AsDateTime);
    D2:=DateOf(Provider.Params.ParamByName('DATE_BEGIN',1).AsDateTime);
    if AIface.Select(PeriodType,D1,D2) then begin
      Provider.Params.ParamByName('DATE_BEGIN').Value:=D1;
      Provider.Params.ParamByName('DATE_BEGIN',1).Value:=D2;
    end;
  finally
    AIface.Free;
  end;
end;

procedure TBisDesignDataAlarmFilterForm.ButtonDateEndClick(Sender: TObject);
var
  AIface: TBisPeriodFormIface;
  PeriodType: TBisPeriodType;
  D1,D2: TDate;
begin
  AIface:=TBisPeriodFormIface.Create(nil);
  try
    PeriodType:=ptMonth;
    D1:=DateOf(Provider.Params.ParamByName('DATE_END').AsDateTime);
    D2:=DateOf(Provider.Params.ParamByName('DATE_END',1).AsDateTime);
    if AIface.Select(PeriodType,D1,D2) then begin
      Provider.Params.ParamByName('DATE_END').Value:=D1;
      Provider.Params.ParamByName('DATE_END',1).Value:=D2;
    end;
  finally
    AIface.Free;
  end;
end;

end.
