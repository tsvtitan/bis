unit BisKrieltDataAnswerEditFm;

interface

uses                                                                                                  
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, ComCtrls,
  BisDataEditFm, BisParam, BisControls;

type
  TBisKrieltDataAnswerEditForm = class(TBisDataEditForm)
    LabelConsultant: TLabel;
    LabelQuestion: TLabel;
    EditQuestion: TEdit;
    ButtonQuestion: TButton;
    ComboBoxConsultant: TComboBox;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    LabelText: TLabel;
    MemoText: TMemo;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;

  end;

  TBisKrieltDataAnswerEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAnswerFilterFormIface=class(TBisKrieltDataAnswerEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAnswerInsertFormIface=class(TBisKrieltDataAnswerEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAnswerUpdateFormIface=class(TBisKrieltDataAnswerEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAnswerDeleteFormIface=class(TBisKrieltDataAnswerEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataAnswerEditForm: TBisKrieltDataAnswerEditForm;

implementation

uses BisCore, BisParamComboBoxDataSelect, BisUtils, 
     BisKrieltDataQuestionsFm, BisKrieltDataConsultantsFm;

{$R *.dfm}

{ TBisKrieltDataAnswerEditFormIface }

constructor TBisKrieltDataAnswerEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataAnswerEditForm;             
  with Params do begin
    AddKey('ANSWER_ID').Older('OLD_ANSWER_ID');
    AddInvisible('QUESTION_NUM');
    AddInvisible('QUESTION_DATE_CREATE');
    AddInvisible('CONSULTANT_SURNAME');
    AddInvisible('CONSULTANT_NAME');
    AddInvisible('CONSULTANT_PATRONYMIC');
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes([emFilter]);
    with AddEditDataSelect('QUESTION_ID','EditQuestion','LabelQuestion','ButtonQuestion',
                           TBisKrieltDataQuestionsFormIface,'QUESTION_NUM;QUESTION_DATE_CREATE',true,false,'','NUM;DATE_CREATE') do begin
      DataAliasFormat:='%s �� %s';
    end;
    with AddComboBoxDataSelect('CONSULTANT_ID','ComboBoxConsultant','LabelConsultant','',
                               TBisKrieltDataConsultantsFormIface,'CONSULTANT_SURNAME;CONSULTANT_NAME;CONSULTANT_PATRONYMIC',true,false,'','SURNAME;NAME;PATRONYMIC') do begin
      DataAliasFormat:='%s %s %s';
    end;
    AddMemo('ANSWER_TEXT','MemoText','LabelText',true);
  end;
end;

{ TBisKrieltDataAnswerFilterFormIface }

constructor TBisKrieltDataAnswerFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ �������';
end;

{ TBisKrieltDataAnswerInsertFormIface }

constructor TBisKrieltDataAnswerInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ANSWER';
  Caption:='������� �����';
end;

{ TBisKrieltDataAnswerUpdateFormIface }

constructor TBisKrieltDataAnswerUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ANSWER';
  Caption:='�������� �����';
end;

{ TBisKrieltDataAnswerDeleteFormIface }

constructor TBisKrieltDataAnswerDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ANSWER';
  Caption:='������� �����';
end;


{ TBisKrieltDataAnswerEditForm }

constructor TBisKrieltDataAnswerEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisKrieltDataAnswerEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    Provider.ParamByName('DATE_CREATE').SetNewValue(Core.ServerDate);
  end;
  UpdateButtonState;
end;

procedure TBisKrieltDataAnswerEditForm.ChangeParam(Param: TBisParam);
var
  ConsultantParam: TBisParamComboBoxDataSelect;
begin
  inherited ChangeParam(Param);

  if AnsiSameText(Param.ParamName,'CONSULTANT_SURNAME;CONSULTANT_NAME;CONSULTANT_PATRONYMIC') then begin
    ConsultantParam:=TBisParamComboBoxDataSelect(Provider.Params.ParamByName('CONSULTANT_ID'));
    if ConsultantParam.Empty then begin
      Provider.Params.ParamByName('CONSULTANT_SURNAME').SetNewValue(Null);
      Provider.Params.ParamByName('CONSULTANT_NAME').SetNewValue(Null);
      Provider.Params.ParamByName('CONSULTANT_PATRONYMIC').SetNewValue(Null);
    end else begin
      Provider.Params.ParamByName('CONSULTANT_SURNAME').SetNewValue(ConsultantParam.Values.ValueByName('SURNAME').Value);
      Provider.Params.ParamByName('CONSULTANT_NAME').SetNewValue(ConsultantParam.Values.ValueByName('NAME').Value);
      Provider.Params.ParamByName('CONSULTANT_PATRONYMIC').SetNewValue(ConsultantParam.Values.ValueByName('PATRONYMIC').Value);
    end;
  end;
end;


end.