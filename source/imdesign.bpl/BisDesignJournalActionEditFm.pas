unit BisDesignJournalActionEditFm;

interface                                                                                 

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisParam, BisControls, ImgList;

type
  TBisDesignJournalActionEditForm = class(TBisDataEditForm)
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelApplication: TLabel;
    EditApplication: TEdit;
    ButtonApplication: TButton;
    LabelModule: TLabel;
    EditModule: TEdit;
    LabelObject: TLabel;
    EditObject: TEdit;
    LabelMethod: TLabel;
    EditMethod: TEdit;
    LabelParam: TLabel;
    EditParam: TEdit;
    LabelValue: TLabel;
    MemoValue: TMemo;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelDate: TLabel;
    DateTimePicker: TDateTimePicker;
    DateTimePickerTime: TDateTimePicker;
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
  end;

  TBisDesignJournalActionEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignJournalActionFilterFormIface=class(TBisDesignJournalActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignJournalActionInsertFormIface=class(TBisDesignJournalActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignJournalActionUpdateFormIface=class(TBisDesignJournalActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignJournalActionDeleteFormIface=class(TBisDesignJournalActionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignJournalActionEditForm: TBisDesignJournalActionEditForm;

function GetActionTypeByIndex(Index: Integer): String;

implementation

{$R *.dfm}

uses BisCore, BisDesignDataAccountsFm, BisDesignDataApplicationsFm;

function GetActionTypeByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='����������';
    1: Result:='��������������';
    2: Result:='������';
  end;
end;

     
{ TBisDesignJournalActionEditFormIface }

constructor TBisDesignJournalActionEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignJournalActionEditForm;
  with Params do begin
    AddKey('JOURNAL_ACTION_ID').Older('OLD_JOURNAL_ACTION_ID');
    AddEditDateTime('DATE_ACTION','DateTimePicker','DateTimePickerTime','LabelDate',true).ExcludeModes([emFilter]);
    AddComboBox('ACTION_TYPE','ComboBoxType','LabelType',true);
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      TBisDesignDataAccountsFormIface,'USER_NAME',true);
    AddEditDataSelect('APPLICATION_ID','EditApplication','LabelApplication','ButtonApplication',
                      TBisDesignDataApplicationsFormIface,'APPLICATION_NAME',true,false,'','NAME');
    AddEdit('MODULE','EditModule','LabelModule');
    AddEdit('OBJECT','EditObject','LabelObject');
    AddEdit('METHOD','EditMethod','LabelMethod');
    AddEdit('PARAM','EditParam','LabelParam');
    AddMemo('VALUE','MemoValue','LabelValue',true);
  end;
end;

{ TBisDesignJournalActionFilterFormIface }

constructor TBisDesignJournalActionFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisDesignJournalActionInsertFormIface }

constructor TBisDesignJournalActionInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_JOURNAL_ACTION';
end;

{ TBisDesignJournalActionUpdateFormIface }

constructor TBisDesignJournalActionUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_JOURNAL_ACTION';
end;

{ TBisDesignJournalActionDeleteFormIface }

constructor TBisDesignJournalActionDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_JOURNAL_ACTION';
end;

{ TBisDesignJournalActionEditForm }

constructor TBisDesignJournalActionEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ComboBoxType.Items.Add(GetActionTypeByIndex(0));
  ComboBoxType.Items.Add(GetActionTypeByIndex(1));
  ComboBoxType.Items.Add(GetActionTypeByIndex(2));
end;

procedure TBisDesignJournalActionEditForm.BeforeShow;
begin
  with Provider.Params do begin
    ParamByName('DATE_ACTION').SetNewValue(Core.ServerDate);
  end;
  inherited BeforeShow;
end;

end.