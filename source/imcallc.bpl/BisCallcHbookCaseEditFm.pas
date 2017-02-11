unit BisCallcHbookCaseEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisCallcHbookCaseEditForm = class(TBisDataEditForm)
    LabelSurname: TLabel;
    EditSurnameIp: TEdit;
    LabelName: TLabel;
    EditNameIp: TEdit;
    LabelPatronymic: TLabel;
    EditPatronymicIp: TEdit;
    LabelIp: TLabel;
    LabelRp: TLabel;
    EditSurnameRp: TEdit;
    EditNameRp: TEdit;
    EditPatronymicRp: TEdit;
    LabelDp: TLabel;
    EditSurnameDp: TEdit;
    EditNameDp: TEdit;
    EditPatronymicDp: TEdit;
    LabelVp: TLabel;
    EditSurnameVp: TEdit;
    EditNameVp: TEdit;
    EditPatronymicVp: TEdit;
    LabelTp: TLabel;
    EditSurnameTp: TEdit;
    EditNameTp: TEdit;
    EditPatronymicTp: TEdit;
    LabelPp: TLabel;
    EditSurnamePp: TEdit;
    EditNamePp: TEdit;
    EditPatronymicPp: TEdit;
    ButtonRp: TButton;
    ButtonDp: TButton;
    ButtonVp: TButton;
    ButtonTp: TButton;
    ButtonPp: TButton;
    ButtonBias: TButton;
    procedure ButtonRpClick(Sender: TObject);
    procedure ButtonDpClick(Sender: TObject);
    procedure ButtonVpClick(Sender: TObject);
    procedure ButtonTpClick(Sender: TObject);
    procedure ButtonPpClick(Sender: TObject);
    procedure ButtonBiasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookCaseEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookCaseInsertFormIface=class(TBisCallcHbookCaseEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookCaseUpdateFormIface=class(TBisCallcHbookCaseEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookCaseDeleteFormIface=class(TBisCallcHbookCaseEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookCaseEditForm: TBisCallcHbookCaseEditForm;

implementation

uses BisCallcBiasFIO;

{$R *.dfm}

{ TBisCallcHbookCaseEditFormIface }

constructor TBisCallcHbookCaseEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookCaseEditForm;
  with Params do begin
    AddEdit('SURNAME_IP','EditSurnameIp','LabelIp',true,true).Older('OLD_SURNAME_IP');
    AddEdit('NAME_IP','EditNameIp','LabelIp',true,true).Older('OLD_NAME_IP');
    AddEdit('PATRONYMIC_IP','EditPatronymicIp','LabelIp',true,true).Older('OLD_PATRONYMIC_IP');
    AddEdit('SURNAME_RP','EditSurnameRp','LabelRp',false);
    AddEdit('NAME_RP','EditNameRp','LabelRp',false);
    AddEdit('PATRONYMIC_RP','EditPatronymicRp','LabelRp',false);
    AddEdit('SURNAME_DP','EditSurnameDp','LabelDp',false);
    AddEdit('NAME_DP','EditNameDp','LabelDp',false);
    AddEdit('PATRONYMIC_DP','EditPatronymicDp','LabelDp',false);
    AddEdit('SURNAME_VP','EditSurnameVp','LabelVp',false);
    AddEdit('NAME_VP','EditNameVp','LabelVp',false);
    AddEdit('PATRONYMIC_VP','EditPatronymicVp','LabelVp',false);
    AddEdit('SURNAME_TP','EditSurnameTp','LabelTp',false);
    AddEdit('NAME_TP','EditNameTp','LabelTp',false);
    AddEdit('PATRONYMIC_TP','EditPatronymicTp','LabelTp',false);
    AddEdit('SURNAME_PP','EditSurnamePp','LabelPp',false);
    AddEdit('NAME_PP','EditNamePp','LabelPp',false);
    AddEdit('PATRONYMIC_PP','EditPatronymicPp','LabelPp',false);
  end;
end;

{ TBisCallcHbookCaseInsertFormIface }

constructor TBisCallcHbookCaseInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CASE';
end;

{ TBisCallcHbookCaseUpdateFormIface }

constructor TBisCallcHbookCaseUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CASE';
end;

{ TBisCallcHbookCaseDeleteFormIface }

constructor TBisCallcHbookCaseDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CASE';
end;

procedure TBisCallcHbookCaseEditForm.ButtonRpClick(Sender: TObject);
var
  OutSurName,OutName,OutPatronymic: String;
begin
  GetGenitiveCase(Trim(EditSurnameIp.Text),Trim(EditNameIp.Text),Trim(EditPatronymicIp.Text),
                  OutSurName,OutName,OutPatronymic);
  EditSurnameRp.Text:=OutSurName;
  EditNameRp.Text:=OutName;
  EditPatronymicRp.Text:=OutPatronymic;
end;

procedure TBisCallcHbookCaseEditForm.ButtonDpClick(Sender: TObject);
var
  OutSurName,OutName,OutPatronymic: String;
begin
  GetDativeCase(Trim(EditSurnameIp.Text),Trim(EditNameIp.Text),Trim(EditPatronymicIp.Text),
                OutSurName,OutName,OutPatronymic);
  EditSurnameDp.Text:=OutSurName;
  EditNameDp.Text:=OutName;
  EditPatronymicDp.Text:=OutPatronymic;
end;

procedure TBisCallcHbookCaseEditForm.ButtonVpClick(Sender: TObject);
var
  OutSurName,OutName,OutPatronymic: String;
begin
  GetAccusativeCase(Trim(EditSurnameIp.Text),Trim(EditNameIp.Text),Trim(EditPatronymicIp.Text),
                    OutSurName,OutName,OutPatronymic);
  EditSurnameVp.Text:=OutSurName;
  EditNameVp.Text:=OutName;
  EditPatronymicVp.Text:=OutPatronymic;
end;

procedure TBisCallcHbookCaseEditForm.ButtonTpClick(Sender: TObject);
var
  OutSurName,OutName,OutPatronymic: String;
begin
  GetInstrumentalCase(Trim(EditSurnameIp.Text),Trim(EditNameIp.Text),Trim(EditPatronymicIp.Text),
                      OutSurName,OutName,OutPatronymic);
  EditSurnameTp.Text:=OutSurName;
  EditNameTp.Text:=OutName;
  EditPatronymicTp.Text:=OutPatronymic;
end;

procedure TBisCallcHbookCaseEditForm.ButtonPpClick(Sender: TObject);
var
  OutSurName,OutName,OutPatronymic: String;
begin
  GetPrepositionalCase(Trim(EditSurnameIp.Text),Trim(EditNameIp.Text),Trim(EditPatronymicIp.Text),
                       OutSurName,OutName,OutPatronymic);
  EditSurnamePp.Text:=OutSurName;
  EditNamePp.Text:=OutName;
  EditPatronymicPp.Text:=OutPatronymic;
end;

procedure TBisCallcHbookCaseEditForm.ButtonBiasClick(Sender: TObject);
begin
  ButtonRp.Click;
  ButtonDp.Click;
  ButtonVp.Click;
  ButtonTp.Click;
  ButtonPp.Click;
end;


end.