unit BisCallcDealsFrameTasksFilterFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcDealsFrameTasksFilterForm = class(TBisDataEditForm)
    LabelDealNum: TLabel;
    EditDealNum: TEdit;
    LabelFirm: TLabel;
    EditFirm: TEdit;
    LabelSurname: TLabel;
    EditSurname: TEdit;
    LabelName: TLabel;
    EditName: TEdit;
    LabelPatronymic: TLabel;
    EditPatronymic: TEdit;
    LabelAccountNum: TLabel;
    EditAccountNum: TEdit;
    LabelLastResult: TLabel;
    EditLastResult: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcDealsFrameTasksFilterFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcDealsFrameTasksFilterForm: TBisCallcDealsFrameTasksFilterForm;

implementation

{$R *.dfm}

{ TBisCallcDealsFrameTasksFilterFormIface }

constructor TBisCallcDealsFrameTasksFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcDealsFrameTasksFilterForm;
  with Params do begin
    AddEdit('DEAL_NUM','EditDealNum','LabelDealNum');
    AddEdit('FIRM_SMALL_NAME','EditFirm','LabelFirm');
    AddEdit('SURNAME','EditSurname','LabelSurname');
    AddEdit('NAME','EditName','LabelName');
    AddEdit('PATRONYMIC','EditPatronymic','LabelPatronymic');
    AddEdit('ACCOUNT_NUM','EditAccountNum','LabelAccountNum');
    AddEdit('LAST_RESULT_NAME','EditLastResult','LabelLastResult');
  end;
end;

end.
