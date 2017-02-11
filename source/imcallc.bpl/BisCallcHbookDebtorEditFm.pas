unit BisCallcHbookDebtorEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisControls, BisParam;

type

  TBisCallcHbookDebtorEditForm = class(TBisDataEditForm)
    LabelSurname: TLabel;
    EditSurname: TEdit;
    LabelPassport: TLabel;
    MemoPassport: TMemo;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelName: TLabel;
    EditName: TEdit;
    LabelPatronymic: TLabel;
    EditPatronymic: TEdit;
    LabelSex: TLabel;
    ComboBoxSex: TComboBox;
    LabelDateBirth: TLabel;
    DateTimePickerBirth: TDateTimePicker;
    LabelPlaceBirth: TLabel;
    LabelAddressResidence: TLabel;
    EditAddressResidence: TEdit;
    LabelIndexResidence: TLabel;
    EditIndexResidence: TEdit;
    LabelAddressActual: TLabel;
    EditAddressActual: TEdit;
    LabelIndexActual: TLabel;
    EditIndexActual: TEdit;
    LabelAddressAdditional: TLabel;
    EditAddressAdditional: TEdit;
    LabelIndexAdditional: TLabel;
    EditIndexAdditional: TEdit;
    LabelPlaceWork: TLabel;
    EditPlaceWork: TEdit;
    LabelJobTitle: TLabel;
    EditJobTitle: TEdit;
    LabelAddressWork: TLabel;
    EditAddressWork: TEdit;
    LabelIndexWork: TLabel;
    EditIndexWork: TEdit;
    LabelPhoneHome: TLabel;
    EditPhoneHome: TEdit;
    LabelPhoneWork: TLabel;
    EditPhoneWork: TEdit;
    EditPhoneMobile: TEdit;
    LabelPhoneMobile: TLabel;
    LabelPhoneOther1: TLabel;
    EditPhoneOther1: TEdit;
    EditPhoneOther2: TEdit;
    LabelPhoneOther2: TLabel;
    LabelFounders: TLabel;
    MemoFounders: TMemo;
    EditPlaceBirth: TEdit;
  private
    procedure LabelClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure ChangeParam(Param: TBisParam); override;
    procedure BeforeShow; override;
  end;

  TBisCallcHbookDebtorEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookDebtorInsertFormIface=class(TBisCallcHbookDebtorEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookDebtorUpdateFormIface=class(TBisCallcHbookDebtorEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookDebtorDeleteFormIface=class(TBisCallcHbookDebtorEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookDebtorEditForm: TBisCallcHbookDebtorEditForm;

function GetDebtorTypeByIndex(Index: Integer): String;
function GetSexByIndex(Index: Integer): String;

implementation

uses StrUtils,
     BisUtils, BisFm, BisDataGridFm, BisProvider, BisFilterGroups, BisCallcHbookDebtorHistoriesFm,
     BisParamComboBox, BisParamEdit, BisParamMemo, BisParamEditDate;

{$R *.dfm}

function GetDebtorTypeByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='���������� ����';
    1: Result:='����������� ����';
  end;
end;

function GetSexByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='�������';
    1: Result:='�������';
  end;
end;

{ TBisCallcHbookDebtorEditFormIface }

constructor TBisCallcHbookDebtorEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookDebtorEditForm;
  with Params do begin
    AddKey('DEBTOR_ID').Older('OLD_DEBTOR_ID');
    AddComboBox('DEBTOR_TYPE','ComboBoxType','LabelType',true);
    AddEdit('SURNAME','EditSurname','LabelSurname',true);
    AddEdit('NAME','EditName','LabelName',true);
    AddEdit('PATRONYMIC','EditPatronymic','LabelPatronymic',true);
    AddMemo('PASSPORT','MemoPassport','LabelPassport',true);
    AddEditDate('DATE_BIRTH','DateTimePickerBirth','LabelDateBirth',true);
    AddEdit('PLACE_BIRTH','EditPlaceBirth','LabelPlaceBirth',true);
    AddComboBox('SEX','ComboBoxSex','LabelSex',true);
    AddEdit('ADDRESS_RESIDENCE','EditAddressResidence','LabelAddressResidence');
    AddEdit('INDEX_RESIDENCE','EditIndexResidence','LabelIndexResidence');
    AddEdit('ADDRESS_ACTUAL','EditAddressActual','LabelAddressActual');
    AddEdit('INDEX_ACTUAL','EditIndexActual','LabelIndexActual');
    AddEdit('ADDRESS_ADDITIONAL','EditAddressAdditional','LabelAddressAdditional');
    AddEdit('INDEX_ADDITIONAL','EditIndexAdditional','LabelIndexAdditional');
    AddEdit('PLACE_WORK','EditPlaceWork','LabelPlaceWork');
    AddEdit('JOB_TITLE','EditJobTitle','LabelJobTitle');
    AddEdit('ADDRESS_WORK','EditAddressWork','LabelAddressWork');
    AddEdit('INDEX_WORK','EditIndexWork','LabelIndexWork');
    AddEdit('PHONE_HOME','EditPhoneHome','LabelPhoneHome');
    AddEdit('PHONE_WORK','EditPhoneWork','LabelPhoneWork');
    AddEdit('PHONE_MOBILE','EditPhoneMobile','LabelPhoneMobile');
    AddEdit('PHONE_OTHER1','EditPhoneOther1','LabelPhoneOther1');
    AddEdit('PHONE_OTHER2','EditPhoneOther2','LabelPhoneOther2');
    AddMemo('FOUNDERS','MemoFounders','LabelFounders');
  end;
end;

{ TBisCallcHbookDebtorInsertFormIface }

constructor TBisCallcHbookDebtorInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_DEBTOR';
end;

{ TBisCallcHbookDebtorUpdateFormIface }

constructor TBisCallcHbookDebtorUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_DEBTOR';
end;

{ TBisCallcHbookDebtorDeleteFormIface }

constructor TBisCallcHbookDebtorDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_DEBTOR';
end;

{ TBisCallcHbookDebtorEditForm }

constructor TBisCallcHbookDebtorEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ComboBoxType.Clear;
  ComboBoxType.Items.Add(GetDebtorTypeByIndex(0));
  ComboBoxType.Items.Add(GetDebtorTypeByIndex(1));

  ComboBoxSex.Clear;
  ComboBoxSex.Items.Add(GetSexByIndex(0));
  ComboBoxSex.Items.Add(GetSexByIndex(1));
end;

procedure TBisCallcHbookDebtorEditForm.ChangeParam(Param: TBisParam);
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'DEBTOR_TYPE') then begin
    LabelFounders.Enabled:=Boolean(VarToIntDef(Param.Value,0));
    MemoFounders.Enabled:=LabelFounders.Enabled;
    MemoFounders.Color:=iff(MemoFounders.Enabled,clWindow,clBtnFace);
  end;
end;

procedure TBisCallcHbookDebtorEditForm.BeforeShow;
var
  i: Integer;
  Fields: TStringList;
  Param: TBisParam;
  ALabel: TLabel;
begin
  inherited BeforeShow;
  Param:=Provider.Params.Find('DEBTOR_ID');
  if Assigned(Param) and not Param.Empty and (Mode in [emUpdate]) then begin
    Fields:=TStringList.Create;
    try
      for i:=0 to Provider.Params.Count-1 do begin
        Fields.Add(Provider.Params.Items[i].ParamName);
      end;
      GetDebtorHistoryExists(Param.Value,Fields);
      for i:=0 to Fields.Count-1 do begin
        Param:=Provider.Params.Find(Fields[i]);
        if Assigned(Param) and (Integer(Fields.Objects[i])>0) then begin
          ALabel:=nil;
          if Param is TBisParamComboBox then
            ALabel:=TBisParamComboBox(Param).LabelComboBox;
          if Param is TBisParamEdit then
            ALabel:=TBisParamEdit(Param).LabelEdit;
          if Param is TBisParamMemo then
            ALabel:=TBisParamMemo(Param).LabelMemo;
          if Param is TBisParamEditDate then
            ALabel:=TBisParamEditDate(Param).LabelEditDate;

          if Assigned(ALabel) then begin
            ALabel.Font.Color:=clGreen;
            ALabel.Cursor:=crHandPoint;
            ALabel.OnClick:=LabelClick;
            ALabel.Tag:=Integer(Pointer(Param));
          end;

        end;
      end;
    finally
      Fields.Free;
    end;
  end;
end;

procedure TBisCallcHbookDebtorEditForm.LabelClick(Sender: TObject);
var
  ALabel: TLabel;
  ParamDebtorId, Param: TBisParam;
  S: String;
  Value: Variant;
begin
  if Assigned(Sender) and (Sender is TLabel) then begin
    ALabel:=TLabel(Sender);
    Param:=TBisParam(Pointer(ALabel.Tag));
    S:=StringReplace(ALabel.Caption,':','',[rfReplaceAll]);
    ParamDebtorId:=Provider.Params.ParamByName('DEBTOR_ID');
    if SelectDebtorHistory(ParamDebtorId.Value,Param.ParamName,S,Value) then begin
      Param.Value:=Value;     
    end;
  end;
end;


end.
