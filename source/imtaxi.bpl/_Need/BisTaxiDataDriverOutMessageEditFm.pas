unit BisTaxiDataDriverOutMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList,
  BisFm, BisDataFm, BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataDriverOutMessageEditForm = class(TBisDataEditForm)
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
    procedure MemoTextChange(Sender: TObject);
    procedure ButtonPatternClick(Sender: TObject);
  private
    FSHigh: String;
    FSNormal: String;
    FSLow: String;
    function CanPattern: Boolean;
    procedure Pattern;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
  published
    property SHigh: String read FSHigh write FSHigh;
    property SNormal: String read FSNormal write FSNormal;
    property SLow: String read FSLow write FSLow;
  end;

  TBisTaxiDataDriverOutMessageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverOutMessageInsertFormIface=class(TBisTaxiDataDriverOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverOutMessageUpdateFormIface=class(TBisTaxiDataDriverOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverOutMessageDeleteFormIface=class(TBisTaxiDataDriverOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDriverOutMessageEditForm: TBisTaxiDataDriverOutMessageEditForm;

function GetTypeMessageByIndex(Index: Integer): String;

implementation

uses BisUtils, BisCore, BisFilterGroups, BisTaxiConsts, BisParamEditDataSelect,
     BisProvider, BisValues, BisDataSet, BisIfaces, BisTaxiDataDriversFm, BisTaxiDataPatternMessagesFm;

{$R *.dfm}

function GetTypeMessageByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='SMS';
//    1: Result:='Email';
  end;
end;


{ TBisTaxiDataDriverOutMessageEditFormIface }

constructor TBisTaxiDataDriverOutMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDriverOutMessageEditForm;
  with Params do begin
    AddKey('OUT_MESSAGE_ID').Older('OLD_OUT_MESSAGE_ID');
    AddInvisible('LOCKED');
    AddInvisible('ORDER_ID');
    AddInvisible('CHANNEL');
    AddInvisible('DATE_DELIVERY');
    AddInvisible('DEST_PORT');
    AddInvisible('OPERATOR_ID');
    AddInvisible('OPERATOR_NAME');
    AddInvisible('CAR_CALLSIGN',ptUnknown);
    AddInvisible('CAR_COLOR',ptUnknown);
    AddInvisible('CAR_BRAND',ptUnknown);
    AddInvisible('CAR_STATE_NUM',ptUnknown);
    AddComboBoxIndex('TYPE_MESSAGE','ComboBoxType','LabelType',true).Value:=0;
    AddCheckBox('DELIVERY','CheckBoxDelivery');
    AddCheckBox('FLASH','CheckBoxFlash');
    AddComboBoxIndex('PRIORITY','ComboBoxPriority','LabelPriority',true);
    AddEditDataSelect('RECIPIENT_ID','EditRecipient','LabelRecipient','ButtonRecipient',
                       TBisTaxiDataDriversFormIface,'RECIPIENT_NAME',true,false,'DRIVER_ID','USER_NAME');
    AddEdit('CONTACT','EditContact','LabelContact',true);
    AddMemo('TEXT_OUT','MemoText','LabelCounter');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin',true);
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd');
    AddEditDateTime('DATE_OUT','DateTimePickerOut','DateTimePickerOutTime','LabelDateOut');
    AddEditDataSelect('CREATOR_ID','EditCreator','LabelCreator','',
                       SClassDataAccountsFormIface,'CREATOR_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes(AllParamEditModes);
  end;
end;

{ TBisTaxiDataDriverOutMessageInsertFormIface }

constructor TBisTaxiDataDriverOutMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Permissions.Enabled:=true;
  ProviderName:='I_OUT_MESSAGE';
  ParentProviderName:='S_OUT_MESSAGES';
  Caption:='Создать исходящее сообщение';
  SMessageSuccess:='Сообщение успешно создано.';
end;

{ TBisTaxiDataDriverOutMessageUpdateFormIface }

constructor TBisTaxiDataDriverOutMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_OUT_MESSAGE';
  Caption:='Изменить исходящее сообщение';
end;

{ TBisTaxiDataDriverOutMessageDeleteFormIface }

constructor TBisTaxiDataDriverOutMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_OUT_MESSAGE';
  Caption:='Удалить исходящее сообщение';
end;

{ TBisTaxiDataDriverOutMessageEditForm }

constructor TBisTaxiDataDriverOutMessageEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxType.Clear;
  for i:=0 to 0 do
    ComboBoxType.Items.Add(GetTypeMessageByIndex(i));

  FSHigh:='высокий';
  FSNormal:='нормальный';
  FSLow:='низкий';

end;

procedure TBisTaxiDataDriverOutMessageEditForm.Init;
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

procedure TBisTaxiDataDriverOutMessageEditForm.MemoTextChange(Sender: TObject);
begin
  LabelCounter.Caption:=IntToStr(Length(MemoText.Lines.Text));
end;

procedure TBisTaxiDataDriverOutMessageEditForm.BeforeShow;
var
  D: TDateTime;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    D:=Core.ServerDate;
    ActiveControl:=EditContact;
    with Provider.Params do begin
      Find('TYPE_MESSAGE').SetNewValue(0);
      Find('PRIORITY').SetNewValue(1);
      Find('DATE_BEGIN').SetNewValue(D);
      Find('CREATOR_ID').SetNewValue(Core.AccountId);
      Find('CREATOR_NAME').SetNewValue(Core.AccountUserName);
      Find('DATE_CREATE').SetNewValue(D);
    end;
  end;
  LabelCounter.Enabled:=not (Mode in [emDelete]);
  ButtonPattern.Enabled:=LabelCounter.Enabled and CanPattern;
  UpdateButtonState;
  MemoTextChange(nil);
end;

function TBisTaxiDataDriverOutMessageEditForm.CanPattern: Boolean;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataFormIface;
begin
  Result:=false;
  AClass:=TBisTaxiDataPatternMessagesFormIface;
  if Assigned(AClass) and IsClassParent(AClass,TBisDataFormIface) then begin
    AIface:=TBisDataFormIfaceClass(AClass).Create(nil);
    try
      AIface.Init;
      Result:=AIface.CanShow;
    finally
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataDriverOutMessageEditForm.Pattern;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataFormIface;
  DS: TBisDataSet;
begin
  if CanPattern then begin
    AClass:=TBisTaxiDataPatternMessagesFormIface;
    if Assigned(AClass) and IsClassParent(AClass,TBisDataFormIface) then begin
      AIface:=TBisDataFormIfaceClass(AClass).Create(nil);
      DS:=TBisDataSet.Create(nil);
      try
        AIface.Init;
        if AIface.SelectInto(DS) then begin
          Provider.Params.ParamByName('TEXT_OUT').Value:=DS.FieldByName('TEXT_PATTERN').Value;
        end;
      finally
        DS.Free;
        AIface.Free;
      end;
    end;
  end;
end;

procedure TBisTaxiDataDriverOutMessageEditForm.ButtonPatternClick(Sender: TObject);
begin
  Pattern;
end;

procedure TBisTaxiDataDriverOutMessageEditForm.ChangeParam(Param: TBisParam);
var
  ParamRecipient: TBisParamEditDataSelect;
  ParamType: TBisParam;
  V: TBisValue;
begin
  inherited ChangeParam(Param);

  if AnsiSameText(Param.ParamName,'RECIPIENT_NAME') and not Param.Empty then begin
    ParamRecipient:=TBisParamEditDataSelect(Provider.Params.ParamByName('RECIPIENT_ID'));
    if Mode in [emInsert,emDuplicate] then begin
      if not ParamRecipient.Empty then begin
        ParamType:=Provider.Params.ParamByName('TYPE_MESSAGE');
        case ParamType.AsInteger of
          0: Provider.Params.ParamByName('CONTACT').Value:=ParamRecipient.Values.GetValue('PHONE');
        end;
      end;
    end;
    V:=ParamRecipient.Values.Find('CAR_CALLSIGN');
    if Assigned(V) then Provider.Params.ParamByName('CAR_CALLSIGN').SetNewValue(V.Value);
    V:=ParamRecipient.Values.Find('CAR_COLOR');
    if Assigned(V) then Provider.Params.ParamByName('CAR_COLOR').SetNewValue(V.Value);
    V:=ParamRecipient.Values.Find('CAR_BRAND');
    if Assigned(V) then Provider.Params.ParamByName('CAR_BRAND').SetNewValue(V.Value);
    V:=ParamRecipient.Values.Find('CAR_STATE_NUM');
    if Assigned(V) then Provider.Params.ParamByName('CAR_STATE_NUM').SetNewValue(V.Value);
  end;

end;


end.
