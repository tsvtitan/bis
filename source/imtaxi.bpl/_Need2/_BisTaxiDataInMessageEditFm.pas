unit BisTaxiDataInMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList, Menus, ActnPopup,
  BisDataFm, BisDataEditFm, BisParam, BisControls;
                                                                                                            
type
  TBisTaxiDataInMessageEditForm = class(TBisDataEditForm)
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
    procedure ButtonSenderClick(Sender: TObject);
  private
    function CanSelectAccount: Boolean;
    procedure SelectAccount;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;

  end;

  TBisTaxiDataInMessageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataInMessageViewFormIface=class(TBisTaxiDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataInMessageInsertFormIface=class(TBisTaxiDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataInMessageUpdateFormIface=class(TBisTaxiDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataInMessageDeleteFormIface=class(TBisTaxiDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataInMessageEditForm: TBisTaxiDataInMessageEditForm;

function GetTypeMessageByIndex(Index: Integer): String;

implementation

uses BisUtils, BisCore, BisFilterGroups, BisTaxiConsts, BisTaxiDataCodeMessagesFm,
     BisParamEditDataSelect, BisIfaces, BisDataSet,
     BisDesignDataAccountsFm,
     BisTaxiDataReceiptTypesFm, BisTaxiDataDriversFm, BisTaxiDataClientsFm;

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


{ TBisTaxiDataInMessageEditFormIface }

constructor TBisTaxiDataInMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataInMessageEditForm;
  with Params do begin
    AddKey('IN_MESSAGE_ID').Older('OLD_IN_MESSAGE_ID');
    AddInvisible('ORDER_ID');
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
                      TBisTaxiDataCodeMessagesFormIface,'CODE');
    AddEdit('CONTACT','EditContact','LabelContact',true);
    AddMemo('TEXT_IN','MemoText','LabelText');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddComboBoxDataSelect('FIRM_ID','ComboBoxFirm','LabelFirm',
                          'S_OFFICES','FIRM_SMALL_NAME',false,false,'','SMALL_NAME');
    AddEditDateTime('DATE_IN','DateTimePickerIn','DateTimePickerInTime','LabelDateIn',true);
    AddEditDateTime('DATE_SEND','DateTimePickerSend','DateTimePickerSendTime','LabelDateSend',true);
  end;
end;

{ TBisTaxiDataInMessageViewFormIface }

constructor TBisTaxiDataInMessageViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='�������� ��������� ���������';
end;

{ TBisTaxiDataInMessageInsertFormIface }

constructor TBisTaxiDataInMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_IN_MESSAGE';
  Caption:='������� �������� ���������';
end;

{ TBisTaxiDataInMessageUpdateFormIface }

constructor TBisTaxiDataInMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_IN_MESSAGE';
  Caption:='�������� �������� ���������';
end;

{ TBisTaxiDataInMessageDeleteFormIface }

constructor TBisTaxiDataInMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_IN_MESSAGE';
  Caption:='������� �������� ���������';
end;

{ TBisTaxiDataInMessageEditForm }

constructor TBisTaxiDataInMessageEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxType.Clear;
  for i:=0 to 2 do
    ComboBoxType.Items.Add(GetTypeMessageByIndex(i));

end;

procedure TBisTaxiDataInMessageEditForm.BeforeShow;
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

procedure TBisTaxiDataInMessageEditForm.ButtonSenderClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=PanelControls.ClientToScreen(Point(ButtonSender.Left,ButtonSender.Top+ButtonSender.Height));
  PopupAccount.Popup(Pt.X,Pt.Y);
end;

procedure TBisTaxiDataInMessageEditForm.ChangeParam(Param: TBisParam);
begin
  inherited ChangeParam(Param);
end;

function TBisTaxiDataInMessageEditForm.CanSelectAccount: Boolean;
var
  AIface: TBisDesignDataAccountsFormIface;
begin
  AIface:=TBisDesignDataAccountsFormIface.Create(nil);
  try
    AIface.Init;
    Result:=AIface.CanShow;
  finally
    AIface.Free;
  end;
end;

procedure TBisTaxiDataInMessageEditForm.SelectAccount;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisDesignDataAccountsFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectAccount then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('SENDER_ID'));
    AIface:=TBisDesignDataAccountsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ACCOUNT_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('ACCOUNT_ID').Value;
        Provider.Params.ParamByName('SENDER_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName('SENDER_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('SENDER_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('SENDER_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        Provider.Params.ParamByName('CONTACT').Value:=DS.FieldByName('PHONE').AsString;
        P1:=Provider.Params.ParamByName('SENDER_USER_NAME;SENDER_SURNAME;SENDER_NAME;SENDER_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

end.
