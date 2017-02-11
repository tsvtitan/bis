unit BisTaxiDataInMessageFilterFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ImgList, Menus, ActnPopup,                                           
  BisTaxiDataInMessageEditFm, BisControls;

type
  TBisTaxiDataInMessageFilterForm = class(TBisTaxiDataInMessageEditForm)
    LabelDateInTo: TLabel;
    DateTimePickerInTo: TDateTimePicker;
    DateTimePickerInToTime: TDateTimePicker;
    LabelDateSendTo: TLabel;
    DateTimePickerSendTo: TDateTimePicker;
    DateTimePickerSendToTime: TDateTimePicker;
    ButtonSendTo: TButton;
    ButtonDateIn: TButton;
    procedure ButtonDateInClick(Sender: TObject);
    procedure ButtonSendToClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataInMessageFilterFormIface=class(TBisTaxiDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataInMessageFilterForm: TBisTaxiDataInMessageFilterForm;

implementation

uses DateUtils,
     BisParamEditDataSelect, BisFilterGroups, BisParam, BisPeriodFm;

{$R *.dfm}

{ TBisTaxiDataInMessageFilterFormIface }

constructor TBisTaxiDataInMessageFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataInMessageFilterForm;
  with Params do begin
    Unique:=false;
    ParamByName('DATE_IN').FilterCondition:=fcEqualGreater;
    with ParamByName('DATE_SEND') do begin
      Modes:=[emFilter];
      FilterCondition:=fcEqualGreater;
    end;
    with AddEditDateTime('DATE_IN','DateTimePickerInTo','DateTimePickerInToTime','LabelDateInTo') do begin
      FilterCondition:=fcEqualLess;
      FilterCaption:='���� ��������� ��:';
    end;
    with AddEditDateTime('DATE_SEND','DateTimePickerSendTo','DateTimePickerSendToTime','LabelDateSendTo') do begin
      FilterCondition:=fcEqualLess;
      FilterCaption:='���� �������� ��:';
    end;
  end;
  Caption:='������ �������� ���������';
end;

procedure TBisTaxiDataInMessageFilterForm.ButtonDateInClick(Sender: TObject);
var
  AIface: TBisPeriodFormIface;
  PeriodType: TBisPeriodType;
  D1,D2: TDate;
begin
  AIface:=TBisPeriodFormIface.Create(nil);
  try
    PeriodType:=ptMonth;
    D1:=DateOf(Provider.Params.ParamByName('DATE_IN').AsDateTime);
    D2:=DateOf(Provider.Params.ParamByName('DATE_IN',1).AsDateTime);
    if AIface.Select(PeriodType,D1,D2) then begin 
      Provider.Params.ParamByName('DATE_IN').Value:=D1;
      Provider.Params.ParamByName('DATE_IN',1).Value:=D2;
    end;
  finally
    AIface.Free;
  end;
end;

procedure TBisTaxiDataInMessageFilterForm.ButtonSendToClick(Sender: TObject);
var
  AIface: TBisPeriodFormIface;
  PeriodType: TBisPeriodType;
  D1,D2: TDate;
begin
  AIface:=TBisPeriodFormIface.Create(nil);
  try
    PeriodType:=ptMonth;
    D1:=DateOf(Provider.Params.ParamByName('DATE_SEND').AsDateTime);
    D2:=DateOf(Provider.Params.ParamByName('DATE_SEND',1).AsDateTime);
    if AIface.Select(PeriodType,D1,D2) then begin
      Provider.Params.ParamByName('DATE_SEND').Value:=D1;
      Provider.Params.ParamByName('DATE_SEND',1).Value:=D2;
    end;
  finally
    AIface.Free;
  end;
end;

end.
