unit BisCallcHbookResultEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisParam, BisControls;

type
  TBisCallcHbookResultEditForm = class(TBisDataEditForm)
    LabelAction: TLabel;
    EditAction: TEdit;
    ButtonAction: TButton;
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    CheckBoxChoiceDate: TCheckBox;
    LabelPeriod: TLabel;
    EditPeriod: TEdit;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    CheckBoxChoicePerformer: TCheckBox;
  private
    { Private declarations }
  public
  end;

  TBisCallcHbookResultEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookResultInsertFormIface=class(TBisCallcHbookResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookResultUpdateFormIface=class(TBisCallcHbookResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookResultDeleteFormIface=class(TBisCallcHbookResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookResultEditForm: TBisCallcHbookResultEditForm;

implementation

uses BisCallcHbookActionsFm;

{$R *.dfm}

{ TBisCallcHbookResultEditFormIface }

constructor TBisCallcHbookResultEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookResultEditForm;
  with Params do begin
    AddKey('RESULT_ID').Older('OLD_RESULT_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddComboBox('RESULT_TYPE','ComboBoxType','LabelType',true);
    AddEditDataSelect('ACTION_ID','EditAction','LabelAction','ButtonAction',
                      TBisCallcHbookActionsFormIface,'ACTION_NAME',false,false,'','NAME');
    AddEditInteger('PERIOD','EditPeriod','LabelPeriod',true);
    AddCheckBox('CHOICE_DATE','CheckBoxChoiceDate');
    AddCheckBox('CHOICE_PERFORMER','CheckBoxChoicePerformer');
  end;
end;

{ TBisCallcHbookResultInsertFormIface }

constructor TBisCallcHbookResultInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_RESULT';
end;

{ TBisCallcHbookResultUpdateFormIface }

constructor TBisCallcHbookResultUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_RESULT';
end;

{ TBisCallcHbookResultDeleteFormIface }

constructor TBisCallcHbookResultDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_RESULT';
end;

{ TBisCallcHbookResultEditForm }

end.
