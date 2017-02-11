unit BisTaxiDataOutMessageFilterFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ImgList,
  BisTaxiDataOutMessageEditFm, BisControls, Menus, ActnPopup;
                                                                                                         
type
  TBisTaxiDataOutMessageFilterForm = class(TBisTaxiDataOutMessageEditForm)
    ButtonCreator: TButton;
    LabelDateOutTo: TLabel;
    DateTimePickerOutTo: TDateTimePicker;
    DateTimePickerOutToTime: TDateTimePicker;
    LabelDateCreateTo: TLabel;
    DateTimePickerCreateTo: TDateTimePicker;
    DateTimePickerCreateToTime: TDateTimePicker;
    ButtonCreateTo: TButton;
    ButtonDateOut: TButton;
    LabelDateEndTo: TLabel;
    DateTimePickerEndTo: TDateTimePicker;
    DateTimePickerEndToTime: TDateTimePicker;
    ButtonDateEnd: TButton;
    LabelDateBeginTo: TLabel;
    DateTimePickerBeginTo: TDateTimePicker;
    DateTimePickerBeginToTime: TDateTimePicker;
    ButtonDateBegin: TButton;
    procedure ButtonDateOutClick(Sender: TObject);
    procedure ButtonCreateToClick(Sender: TObject);
    procedure ButtonDateBeginClick(Sender: TObject);
    procedure ButtonDateEndClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataOutMessageFilterFormIface=class(TBisTaxiDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;

  end;

var
  BisTaxiDataOutMessageFilterForm: TBisTaxiDataOutMessageFilterForm;

implementation

uses DateUtils,
     BisParamEditDataSelect, BisFilterGroups, BisParam, BisPeriodFm;

{$R *.dfm}

{ TBisTaxiDataOutMessageFilterFormIface }

constructor TBisTaxiDataOutMessageFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataOutMessageFilterForm;
  with Params do begin
    Unique:=false;
    ParamByName('DATE_BEGIN').FilterCondition:=fcEqualGreater;
    ParamByName('DATE_END').FilterCondition:=fcEqualGreater;
    ParamByName('DATE_OUT').FilterCondition:=fcEqualGreater;
    with TBisParamEditDataSelect(ParamByName('CREATOR_ID')) do begin
      Modes:=[emFilter];
      ButtonName:='ButtonCreator';
    end;
    with ParamByName('DATE_CREATE') do begin
      Modes:=[emFilter];
      FilterCondition:=fcEqualGreater;
    end;
    with AddEditDateTime('DATE_BEGIN','DateTimePickerBeginTo','DateTimePickerBeginToTime','LabelDateBeginTo') do begin
      FilterCondition:=fcEqualLess;
      FilterCaption:='Дата начала по:';
    end;
    with AddEditDateTime('DATE_END','DateTimePickerEndTo','DateTimePickerEndToTime','LabelDateEndTo') do begin
      FilterCondition:=fcEqualLess;
      FilterCaption:='Дата окончания по:';
    end;
    with AddEditDateTime('DATE_OUT','DateTimePickerOutTo','DateTimePickerOutToTime','LabelDateOutTo') do begin
      FilterCondition:=fcEqualLess;
      FilterCaption:='Дата отправки по:';
    end;
    with AddEditDateTime('DATE_CREATE','DateTimePickerCreateTo','DateTimePickerCreateToTime','LabelDateCreateTo') do begin
      FilterCondition:=fcEqualLess;
      FilterCaption:='Дата создания по:';
    end;
  end;
  Caption:='Фильтр исходящих сообщений';
end;

procedure TBisTaxiDataOutMessageFilterForm.ButtonDateBeginClick(Sender: TObject);
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

procedure TBisTaxiDataOutMessageFilterForm.ButtonDateEndClick(Sender: TObject);
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

procedure TBisTaxiDataOutMessageFilterForm.ButtonDateOutClick(Sender: TObject);
var
  AIface: TBisPeriodFormIface;
  PeriodType: TBisPeriodType;
  D1,D2: TDate;
begin
  AIface:=TBisPeriodFormIface.Create(nil);
  try
    PeriodType:=ptMonth;
    D1:=DateOf(Provider.Params.ParamByName('DATE_OUT').AsDateTime);
    D2:=DateOf(Provider.Params.ParamByName('DATE_OUT',1).AsDateTime);
    if AIface.Select(PeriodType,D1,D2) then begin
      Provider.Params.ParamByName('DATE_OUT').Value:=D1;
      Provider.Params.ParamByName('DATE_OUT',1).Value:=D2;
    end;
  finally
    AIface.Free;
  end;
end;

procedure TBisTaxiDataOutMessageFilterForm.ButtonCreateToClick(Sender: TObject);
var
  AIface: TBisPeriodFormIface;
  PeriodType: TBisPeriodType;
  D1,D2: TDate;
begin
  AIface:=TBisPeriodFormIface.Create(nil);
  try
    PeriodType:=ptMonth;
    D1:=DateOf(Provider.Params.ParamByName('DATE_CREATE').AsDateTime);
    D2:=DateOf(Provider.Params.ParamByName('DATE_CREATE',1).AsDateTime);
    if AIface.Select(PeriodType,D1,D2) then begin
      Provider.Params.ParamByName('DATE_CREATE').Value:=D1;
      Provider.Params.ParamByName('DATE_CREATE',1).Value:=D2;
    end;
  finally
    AIface.Free;
  end;
end;

end.
