unit BisCallDataCallFilterFm;

interface
                                              
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, Buttons, StdCtrls, ComCtrls, ExtCtrls,
  BisCallDataCallEditFm, BisControls;
                                                                                            
type
  TBisCallDataCallFilterForm = class(TBisCallDataCallEditForm)
    LabelDateCreateTo: TLabel;
    DateTimePickerCreateTo: TDateTimePicker;
    DateTimePickerCreateTimeTo: TDateTimePicker;
    ButtonDateCreate: TButton;
    LabelDateBeginTo: TLabel;
    DateTimePickerBeginTo: TDateTimePicker;
    DateTimePickerBeginTimeTo: TDateTimePicker;
    ButtonDateBegin: TButton;
    LabelDateEndTo: TLabel;
    DateTimePickerEndTo: TDateTimePicker;
    DateTimePickerEndTimeTo: TDateTimePicker;
    ButtonDateEnd: TButton;
    ButtonCreator: TButton;
    LabelDateFoundTo: TLabel;
    DateTimePickerFoundTo: TDateTimePicker;
    DateTimePickerFoundTimeTo: TDateTimePicker;
    ButtonDateFound: TButton;
    procedure ButtonDateCreateClick(Sender: TObject);
    procedure ButtonDateBeginClick(Sender: TObject);
    procedure ButtonDateEndClick(Sender: TObject);
    procedure ButtonDateFoundClick(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallDataCallFilterFormIface=class(TBisCallDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallDataCallFilterForm: TBisCallDataCallFilterForm;

implementation

uses DateUtils,
     BisParamEditDataSelect, BisFilterGroups, BisParam, BisPeriodFm;

{$R *.dfm}

{ TBisCallDataCallFilterFormIface }

constructor TBisCallDataCallFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallDataCallFilterForm;
  with Params do begin
    Unique:=false;
    with ParamByName('DATE_CREATE') do begin
      Modes:=[emFilter];
      FilterCondition:=fcEqualGreater;
    end;
    ParamByName('DATE_FOUND').FilterCondition:=fcEqualGreater;
    ParamByName('DATE_BEGIN').FilterCondition:=fcEqualGreater;
    ParamByName('DATE_END').FilterCondition:=fcEqualGreater;
    with TBisParamEditDataSelect(ParamByName('CREATOR_ID')) do begin
      Modes:=[emFilter];
      ButtonName:='ButtonCreator';
    end;
    with AddEditDateTime('DATE_CREATE','DateTimePickerCreateTo','DateTimePickerCreateTimeTo','LabelDateCreateTo') do begin
      FilterCondition:=fcEqualLess;
      FilterCaption:='���� �������� ��:';
    end;
    with AddEditDateTime('DATE_FOUND','DateTimePickerFoundTo','DateTimePickerFoundTimeTo','LabelDateFoundTo') do begin
      FilterCondition:=fcEqualLess;
      FilterCaption:='���� ����������� ��:';
    end;
    with AddEditDateTime('DATE_BEGIN','DateTimePickerBeginTo','DateTimePickerBeginTimeTo','LabelDateBeginTo') do begin
      FilterCondition:=fcEqualLess;
      FilterCaption:='���� ������ ��:';
    end;
    with AddEditDateTime('DATE_END','DateTimePickerEndTo','DateTimePickerEndTimeTo','LabelDateEndTo') do begin
      FilterCondition:=fcEqualLess;
      FilterCaption:='���� ��������� ��:';
    end;
  end;
  Caption:='������ �������';
end;

{ TBisCallDataCallFilterForm }

procedure TBisCallDataCallFilterForm.ButtonDateBeginClick(Sender: TObject);
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

procedure TBisCallDataCallFilterForm.ButtonDateCreateClick(Sender: TObject);
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

procedure TBisCallDataCallFilterForm.ButtonDateEndClick(Sender: TObject);
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

procedure TBisCallDataCallFilterForm.ButtonDateFoundClick(Sender: TObject);
var
  AIface: TBisPeriodFormIface;
  PeriodType: TBisPeriodType;
  D1,D2: TDate;
begin
  AIface:=TBisPeriodFormIface.Create(nil);
  try
    PeriodType:=ptMonth;
    D1:=DateOf(Provider.Params.ParamByName('DATE_FOUND').AsDateTime);
    D2:=DateOf(Provider.Params.ParamByName('DATE_FOUND',1).AsDateTime);
    if AIface.Select(PeriodType,D1,D2) then begin
      Provider.Params.ParamByName('DATE_FOUND').Value:=D1;
      Provider.Params.ParamByName('DATE_FOUND',1).Value:=D2;
    end;
  finally
    AIface.Free;
  end;
end;

constructor TBisCallDataCallFilterForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LabelCallResult.Anchors:=[akLeft,akTop];
  LabelAcceptor.Anchors:=LabelCallResult.Anchors;
end;

end.
