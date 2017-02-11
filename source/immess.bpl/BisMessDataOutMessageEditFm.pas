unit BisMessDataOutMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList, Menus, ActnPopup,
  BisFm, BisDataFm, BisDataEditFm, BisParam, BisControls;                                               

type
  TBisMessDataOutMessageEditForm = class(TBisDataEditForm)
    LabelRecipient: TLabel;
    EditRecipient: TEdit;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    ButtonRecipient: TButton;
    LabelDateOut: TLabel;
    DateTimePickerOut: TDateTimePicker;
    DateTimePickerOutTime: TDateTimePicker;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelContact: TLabel;
    EditContact: TEdit;
    LabelCreator: TLabel;
    EditCreator: TEdit;
    LabelPriority: TLabel;
    ComboBoxPriority: TComboBox;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    MemoText: TMemo;
    ButtonPattern: TButton;
    LabelCounter: TLabel;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    DateTimePickerBeginTime: TDateTimePicker;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
    DateTimePickerEndTime: TDateTimePicker;
    CheckBoxDelivery: TCheckBox;
    CheckBoxFlash: TCheckBox;
    LabelFirm: TLabel;
    ComboBoxFirm: TComboBox;
    LabelAttempts: TLabel;
    EditAttempts: TEdit;
    procedure MemoTextChange(Sender: TObject);
    procedure ButtonPatternClick(Sender: TObject);
  private
    FSHigh: String;
    FSNormal: String;
    FSLow: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    procedure BeforeShow; override;
  published
    property SHigh: String read FSHigh write FSHigh;
    property SNormal: String read FSNormal write FSNormal;
    property SLow: String read FSLow write FSLow;
  end;

  TBisMessDataOutMessageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataOutMessageViewFormIface=class(TBisMessDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataOutMessageInsertFormIface=class(TBisMessDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataOutMessageUpdateFormIface=class(TBisMessDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataOutMessageDeleteFormIface=class(TBisMessDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessDataOutMessageEditForm: TBisMessDataOutMessageEditForm;

function GetTypeMessageByIndex(Index: Integer): String;

implementation

uses BisUtils, BisCore, BisFilterGroups, BisParamEditDataSelect,
     BisProvider, BisIfaces, BisDataSet,
     BisDesignDataAccountsFm, BisMessDataPatternMessagesFm;

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

{ TBisMessDataOutMessageEditFormIface }

constructor TBisMessDataOutMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataOutMessageEditForm;
  with Params do begin
    AddKey('OUT_MESSAGE_ID').Older('OLD_OUT_MESSAGE_ID');
    AddInvisible('LOCKED');
    AddInvisible('CHANNEL');
    AddInvisible('DATE_DELIVERY');
    AddInvisible('DEST_PORT');
    AddInvisible('RECIPIENT_USER_NAME');
    AddInvisible('RECIPIENT_SURNAME');
    AddInvisible('RECIPIENT_NAME');
    AddInvisible('RECIPIENT_PATRONYMIC');
    AddInvisible('OPERATOR_ID');
    AddInvisible('OPERATOR_NAME');
    AddInvisible('SOURCE');
    AddComboBoxIndex('TYPE_MESSAGE','ComboBoxType','LabelType',true);
    AddCheckBox('DELIVERY','CheckBoxDelivery');
    AddCheckBox('FLASH','CheckBoxFlash');
    AddComboBoxIndex('PRIORITY','ComboBoxPriority','LabelPriority',true);
    AddEditInteger('ATTEMPTS','EditAttempts','LabelAttempts');
    with AddEditDataSelect('RECIPIENT_ID','EditRecipient','LabelRecipient','ButtonRecipient',
                           TBisDesignDataAccountsFormIface,'RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC',
                           false,false,'ACCOUNT_ID','USER_NAME;SURNAME;NAME;PATRONYMIC') do begin
      DataAliasFormat:='%s - %s %s %s';
    end;
    AddEdit('CONTACT','EditContact','LabelContact',true);
    AddMemo('TEXT_OUT','MemoText','LabelCounter');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin',true);
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd');
    AddEditDateTime('DATE_OUT','DateTimePickerOut','DateTimePickerOutTime','LabelDateOut');
    AddEditDataSelect('CREATOR_ID','EditCreator','LabelCreator','',
                       TBisDesignDataAccountsFormIface,'CREATOR_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
    AddComboBoxDataSelect('FIRM_ID','ComboBoxFirm','LabelFirm',
                          'S_OFFICES','FIRM_SMALL_NAME',false,false,'','SMALL_NAME');
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes(AllParamEditModes);
  end;
end;

{ TBisMessDataOutMessageViewFormIface }

constructor TBisMessDataOutMessageViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='�������� ���������� ���������';
end;

{ TBisMessDataOutMessageInsertFormIface }

constructor TBisMessDataOutMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Permissions.Enabled:=true;
  ProviderName:='I_OUT_MESSAGE';
  ParentProviderName:='S_OUT_MESSAGES';
  Caption:='������� ��������� ���������';
  SMessageSuccess:='��������� ������� �������.';
  with Params do begin
    Find('TYPE_MESSAGE').Value:=0;
  end;
end;

{ TBisMessDataOutMessageUpdateFormIface }

constructor TBisMessDataOutMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_OUT_MESSAGE';
  Caption:='�������� ��������� ���������';
end;

{ TBisMessDataOutMessageDeleteFormIface }

constructor TBisMessDataOutMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_OUT_MESSAGE';
  Caption:='������� ��������� ���������';
end;

{ TBisMessDataOutMessageEditForm }

constructor TBisMessDataOutMessageEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxType.Clear;
  for i:=0 to 2 do
    ComboBoxType.Items.Add(GetTypeMessageByIndex(i));

  FSHigh:='�������';
  FSNormal:='����������';
  FSLow:='������';

end;

procedure TBisMessDataOutMessageEditForm.Init;
var
  OldIndex: Integer;
begin
  inherited Init;
  OldIndex:=ComboBoxPriority.ItemIndex;
  try
    ComboBoxPriority.Items.Strings[0]:=FSHigh;
    ComboBoxPriority.Items.Strings[1]:=FSNormal;
    ComboBoxPriority.Items.Strings[2]:=FSLow;
  finally
    ComboBoxPriority.ItemIndex:=OldIndex;
  end;
end;

procedure TBisMessDataOutMessageEditForm.MemoTextChange(Sender: TObject);
begin
  LabelCounter.Caption:=IntToStr(Length(MemoText.Lines.Text));
end;

procedure TBisMessDataOutMessageEditForm.BeforeShow;
var
  D: TDateTime;
begin
  inherited BeforeShow;
  
  if Mode in [emInsert,emDuplicate] then begin
    D:=Core.ServerDate;
    ActiveControl:=EditContact;
    with Provider.Params do begin
//      Find('TYPE_MESSAGE').SetNewValue(0);
      if Mode=emInsert then
        Find('PRIORITY').SetNewValue(2);
      Find('DATE_BEGIN').SetNewValue(D);
      Find('CREATOR_ID').SetNewValue(Core.AccountId);
      Find('CREATOR_NAME').SetNewValue(Core.AccountUserName);
      Find('DATE_CREATE').SetNewValue(D);
      Find('FIRM_ID').SetNewValue(Core.FirmId);
      Find('FIRM_SMALL_NAME').SetNewValue(Core.FirmSmallName);
      Find('LOCKED').SetNewValue(Null);
      Find('DATE_OUT').SetNewValue(Null);
    end;
  end;

  if not VarIsNull(Core.FirmId) and (Mode<>emFilter) then
    Provider.ParamByName('FIRM_ID').Enabled:=false;

  LabelCounter.Enabled:=not (Mode in [emDelete]);
  ButtonPattern.Enabled:=LabelCounter.Enabled;
  UpdateButtonState;
  MemoTextChange(nil);
end;

procedure TBisMessDataOutMessageEditForm.ButtonPatternClick(Sender: TObject);
var
  AIface: TBisMessDataPatternMessagesFormIface;
  P: TBisProvider;
begin
  AIface:=TBisMessDataPatternMessagesFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.Init;
    if AIface.SelectInto(P) then begin
      if P.Active and not P.Empty then begin
        Provider.Params.ParamByName('TEXT_OUT').Value:=P.FieldByName('TEXT_PATTERN').Value;
        MemoTextChange(nil);
      end;
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

end.
