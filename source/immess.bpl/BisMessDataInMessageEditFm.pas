unit BisMessDataInMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList, Menus, ActnPopup,
  BisDataFm, BisDataEditFm, BisParam, BisControls;
                                                                                                            
type
  TBisMessDataInMessageEditForm = class(TBisDataEditForm)
    LabelSender: TLabel;
    EditSender: TEdit;
    LabelDateSend: TLabel;
    DateTimePickerSend: TDateTimePicker;
    DateTimePickerSendTime: TDateTimePicker;
    ButtonSender: TButton;
    LabelDateIn: TLabel;
    DateTimePickerIn: TDateTimePicker;
    DateTimePickerInTime: TDateTimePicker;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelContact: TLabel;
    EditContact: TEdit;
    LabelText: TLabel;
    MemoText: TMemo;
    LabelCodeMessage: TLabel;
    EditCodeMessage: TEdit;
    ButtonCodeMessage: TButton;
    MemoDescription: TMemo;
    LabelDescription: TLabel;
    LabelFirm: TLabel;
    ComboBoxFirm: TComboBox;
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
  end;

  TBisMessDataInMessageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataInMessageViewFormIface=class(TBisMessDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataInMessageInsertFormIface=class(TBisMessDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataInMessageUpdateFormIface=class(TBisMessDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataInMessageDeleteFormIface=class(TBisMessDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessDataInMessageEditForm: TBisMessDataInMessageEditForm;

function GetTypeMessageByIndex(Index: Integer): String;

implementation

uses BisUtils, BisCore, BisFilterGroups,
     BisParamEditDataSelect, BisIfaces, BisDataSet,
     BisDesignDataAccountsFm,
     BisMessDataCodeMessagesFm;

{$R *.dfm}

function GetTypeMessageByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='���������';
    1: Result:='������';
    2: Result:='�����';
  end;
end;

{ TBisMessDataInMessageEditFormIface }

constructor TBisMessDataInMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataInMessageEditForm;
  with Params do begin
    AddKey('IN_MESSAGE_ID').Older('OLD_IN_MESSAGE_ID');
    AddInvisible('CHANNEL');
    AddInvisible('SENDER_USER_NAME');
    AddInvisible('SENDER_SURNAME');
    AddInvisible('SENDER_NAME');
    AddInvisible('SENDER_PATRONYMIC');
    AddInvisible('OPERATOR_ID');
    AddInvisible('OPERATOR_NAME');
    AddComboBoxIndex('TYPE_MESSAGE','ComboBoxType','LabelType',true);
    with AddEditDataSelect('SENDER_ID','EditSender','LabelSender','ButtonSender',
                           TBisDesignDataAccountsFormIface,'SENDER_USER_NAME;SENDER_SURNAME;SENDER_NAME;SENDER_PATRONYMIC',
                           false,false,'ACCOUNT_ID','USER_NAME;SURNAME;NAME;PATRONYMIC') do begin
      DataAliasFormat:='%s - %s %s %s';
    end;
    AddEditDataSelect('CODE_MESSAGE_ID','EditCodeMessage','LabelCodeMessage','ButtonCodeMessage',
                      TBisMessDataCodeMessagesFormIface,'CODE');
    AddEdit('CONTACT','EditContact','LabelContact',true);
    AddMemo('TEXT_IN','MemoText','LabelText');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddComboBoxDataSelect('FIRM_ID','ComboBoxFirm','LabelFirm',
                          'S_OFFICES','FIRM_SMALL_NAME',false,false,'','SMALL_NAME');
    AddEditDateTime('DATE_IN','DateTimePickerIn','DateTimePickerInTime','LabelDateIn',true);
    AddEditDateTime('DATE_SEND','DateTimePickerSend','DateTimePickerSendTime','LabelDateSend',true);
  end;
end;

{ TBisMessDataInMessageViewFormIface }

constructor TBisMessDataInMessageViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='�������� ��������� ���������';
end;

{ TBisMessDataInMessageInsertFormIface }

constructor TBisMessDataInMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_IN_MESSAGE';
  Caption:='������� �������� ���������';
end;

{ TBisMessDataInMessageUpdateFormIface }

constructor TBisMessDataInMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_IN_MESSAGE';
  Caption:='�������� �������� ���������';
end;

{ TBisMessDataInMessageDeleteFormIface }

constructor TBisMessDataInMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_IN_MESSAGE';
  Caption:='������� �������� ���������';
end;

{ TBisMessDataInMessageEditForm }

constructor TBisMessDataInMessageEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxType.Clear;
  for i:=0 to 2 do
    ComboBoxType.Items.Add(GetTypeMessageByIndex(i));

end;

procedure TBisMessDataInMessageEditForm.BeforeShow;
begin
  inherited BeforeShow;

  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      Find('FIRM_ID').SetNewValue(Core.FirmId);
      Find('FIRM_SMALL_NAME').SetNewValue(Core.FirmSmallName);
    end;
  end;

  if not VarIsNull(Core.FirmId) and (Mode<>emFilter) then
    Provider.ParamByName('FIRM_ID').Enabled:=false;
end;


end.