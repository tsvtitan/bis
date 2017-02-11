unit BisMessDataInMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList,
  BisDataEditFm, BisParam, BisControls;

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
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;

  end;

  TBisMessDataInMessageEditFormIface=class(TBisDataEditFormIface)
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

uses BisUtils, BisCore, BisFilterGroups, BisMessConsts, BisMessDataCodeMessagesFm,
     BisParamEditDataSelect, BisMessDataAccountsFm;

{$R *.dfm}

function GetTypeMessageByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='SMS';
//    1: Result:='Email';
  end;
end;


{ TBisMessDataInMessageEditFormIface }

constructor TBisMessDataInMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataInMessageEditForm;
  with Params do begin
    AddKey('IN_MESSAGE_ID').Older('OLD_IN_MESSAGE_ID');
    AddComboBoxIndex('TYPE_MESSAGE','ComboBoxType','LabelType',true);
    if IsMainModule then begin
      AddEditDataSelect('SENDER_ID','EditSender','LabelSender','ButtonSender',
                         TBisMessDataAccountsFormIface,'SENDER_NAME',false,false,'ACCOUNT_ID','USER_NAME');
    end else begin
      AddEditDataSelect('SENDER_ID','EditSender','LabelSender','ButtonSender',
                         SIfaceClassDataAccountsFormIface,'SENDER_NAME',false,false,'ACCOUNT_ID','USER_NAME');
    end;
    AddEditDataSelect('CODE_MESSAGE_ID','EditCodeMessage','LabelCodeMessage','ButtonCodeMessage',
                       TBisMessDataCodeMessagesFormIface,'CODE');
    AddEdit('CONTACT','EditContact','LabelContact',true);
    AddMemo('TEXT_IN','MemoText','LabelText');
    AddEditDateTime('DATE_IN','DateTimePickerIn','DateTimePickerInTime','LabelDateIn',true);
    AddEditDateTime('DATE_SEND','DateTimePickerSend','DateTimePickerSendTime','LabelDateSend',true);
  end;
end;

{ TBisMessDataInMessageInsertFormIface }

constructor TBisMessDataInMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_IN_MESSAGE';
  Caption:='Создать входящее сообщение';
end;

{ TBisMessDataInMessageUpdateFormIface }

constructor TBisMessDataInMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_IN_MESSAGE';
  Caption:='Изменить входящее сообщение';
end;

{ TBisMessDataInMessageDeleteFormIface }

constructor TBisMessDataInMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_IN_MESSAGE';
  Caption:='Удалить входящее сообщение';
end;

{ TBisMessDataInMessageEditForm }

constructor TBisMessDataInMessageEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxType.Clear;
  for i:=0 to 0 do
    ComboBoxType.Items.Add(GetTypeMessageByIndex(i));

end;

procedure TBisMessDataInMessageEditForm.BeforeShow;
begin
  inherited BeforeShow;
end;

procedure TBisMessDataInMessageEditForm.ChangeParam(Param: TBisParam);
var
  ParamSender: TBisParamEditDataSelect;
  ParamType: TBisParam;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'SENDER_NAME') and not Param.Empty then begin
    if Mode in [emInsert] then begin
      ParamSender:=TBisParamEditDataSelect(Provider.Params.ParamByName('SENDER_ID'));
      if not ParamSender.Empty then begin
        ParamType:=Provider.Params.ParamByName('TYPE_MESSAGE');
        case ParamType.AsInteger of
          0: Provider.Params.ParamByName('CONTACT').Value:=ParamSender.Values.GetValue('PHONE');
        end;
      end;
    end;
  end;
end;


end.
