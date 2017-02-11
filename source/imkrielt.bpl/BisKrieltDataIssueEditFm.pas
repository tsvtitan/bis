unit BisKrieltDataIssueEditFm;
                                                                                                          
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisControls, BisParam, ImgList;

type
  TBisKrieltDataIssueEditForm = class(TBisDataEditForm)
    LabelPublishing: TLabel;
    EditPublishing: TEdit;
    ButtonPublishing: TButton;
    LabelNum: TLabel;
    EditNum: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelDateBegin: TLabel;
    LabelDateEnd: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    DateTimePickerEnd: TDateTimePicker;
    ButtonPeriod: TButton;
    procedure ButtonPeriodClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
  end;

  TBisKrieltDataIssueEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataIssueFilterFormIface=class(TBisKrieltDataIssueEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataIssueInsertFormIface=class(TBisKrieltDataIssueEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataIssueUpdateFormIface=class(TBisKrieltDataIssueEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataIssueDeleteFormIface=class(TBisKrieltDataIssueEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataIssueEditForm: TBisKrieltDataIssueEditForm;

implementation

{$R *.dfm}

uses DateUtils,
     BisKrieltDataPublishingFm, BisPeriodFm,
     BisInterfaces, BisIfaces, BisFilterGroups;

{ TBisKrieltDataIssueEditFormIface }

constructor TBisKrieltDataIssueEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataIssueEditForm;
  with Params do begin
    AddKey('ISSUE_ID').Older('OLD_ISSUE_ID');
    AddEdit('NUM','EditNum','LabelNum',true);
    AddEditDataSelect('PUBLISHING_ID','EditPublishing','LabelPublishing','ButtonPublishing',
                      TBisKrieltDataPublishingFormIface,'PUBLISHING_NAME',true,false,'','NAME');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEditDate('DATE_BEGIN','DateTimePickerBegin','LabelDateBegin',true).FilterCondition:=fcEqualGreater;
    AddEditDate('DATE_END','DateTimePickerEnd','LabelDateEnd',true).FilterCondition:=fcEqualLess;
  end;
end;

{ TBisKrieltDataIssueFilterFormIface }

constructor TBisKrieltDataIssueFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataIssueInsertFormIface }

constructor TBisKrieltDataIssueInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ISSUE';
end;

{ TBisKrieltDataIssueUpdateFormIface }

constructor TBisKrieltDataIssueUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ISSUE';
end;

{ TBisKrieltDataIssueDeleteFormIface }

constructor TBisKrieltDataIssueDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ISSUE';
end;


{ TBisKrieltDataIssueEditForm }

constructor TBisKrieltDataIssueEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisKrieltDataIssueEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      Find('DATE_BEGIN').SetNewValue(DateOf(Date));
    end;
  end;
  UpdateButtonState;
end;

procedure TBisKrieltDataIssueEditForm.ButtonPeriodClick(Sender: TObject);
var
  Form: TBisPeriodForm;
  D1,D2: TDate;
  P1,P2: TBisParam;
  PeriodType: TBisPeriodType;
begin
  Form:=TBisPeriodForm.Create(nil);
  try
    D1:=Date;
    D2:=Date;
    P1:=Provider.Params.ParamByName('DATE_BEGIN');
    P2:=Provider.Params.ParamByName('DATE_END');
    if not P1.Empty then
      D1:=P1.Value;
    if not P2.Empty then
      D2:=P2.Value;
    PeriodType:=ptInterval;
    if Form.Select(PeriodType,D1,D2) then begin
      P1.Value:=D1;
      P2.Value:=D2;
    end;
  finally
    Form.Free;
  end;
end;


end.
