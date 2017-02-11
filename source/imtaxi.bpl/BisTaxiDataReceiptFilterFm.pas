unit BisTaxiDataReceiptFilterFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, StdCtrls, ComCtrls, ExtCtrls,
  BisTaxiDataReceiptEditFm, BisControls;

type
  TBisTaxiDataReceiptFilterForm = class(TBisTaxiDataReceiptEditForm)
    LabelDateReceiptTo: TLabel;                                                                     
    DateTimePickerReceiptTo: TDateTimePicker;
    DateTimePickerReceiptToTime: TDateTimePicker;
    ButtonDateReceipt: TButton;
    procedure ButtonDateReceiptClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataReceiptFilterFormIface=class(TBisTaxiDataReceiptEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataReceiptFilterForm: TBisTaxiDataReceiptFilterForm;

implementation

uses DateUtils,
     BisFilterGroups, BisParam, BisPeriodFm;

{$R *.dfm}

{ TBisTaxiDataReceiptFilterFormIface }

constructor TBisTaxiDataReceiptFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataReceiptFilterForm;
  with Params do begin
    Unique:=false;
    with ParamByName('DATE_RECEIPT') do begin
      Modes:=[emFilter];
      FilterCondition:=fcEqualGreater;
    end;
    with AddEditDateTime('DATE_RECEIPT','DateTimePickerReceiptTo','DateTimePickerReceiptToTime','LabelDateReceiptTo') do begin
      Modes:=[emFilter];
      FilterCondition:=fcEqualLess;
    end;
    with ParamByName('WHO_CREATE_ID') do begin
      Modes:=[emFilter];
    end;
  end;
  Caption:='Фильтр поступлений';
end;

{ TBisTaxiDataReceiptFilterForm }

procedure TBisTaxiDataReceiptFilterForm.ButtonDateReceiptClick(Sender: TObject);
var
  AIface: TBisPeriodFormIface;
  PeriodType: TBisPeriodType;
  D1,D2: TDate;
begin
  AIface:=TBisPeriodFormIface.Create(nil);
  try
    PeriodType:=ptMonth;
    D1:=DateOf(Provider.Params.ParamByName('DATE_RECEIPT').AsDateTime);
    D2:=DateOf(Provider.Params.ParamByName('DATE_RECEIPT',1).AsDateTime);
    if AIface.Select(PeriodType,D1,D2) then begin
      Provider.Params.ParamByName('DATE_RECEIPT').Value:=D1;
      Provider.Params.ParamByName('DATE_RECEIPT',1).Value:=D2;
    end;
  finally
    AIface.Free;
  end;
end;

end.
