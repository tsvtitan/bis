unit BisTaxiDataOutMessageInsertExFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList,
  BisFm, BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataOutMessageRecipientInfo=class(TObject)
  private                                                                                           
    FAccountId: Variant;
    FIsRole: Boolean;
    FSurname: String;
    FName: String;
    FPatronymic: String;
    FPhone: String;
  public
    property AccountId: Variant read FAccountId write FAccountId;
    property IsRole: Boolean read FIsRole write FIsRole;
    property Surname: String read FSurname write FSurname;
    property Name: String read FName write FName;
    property Patronymic: String read FPatronymic write FPatronymic;
    property Phone: String read FPhone write FPhone;   
  end;

  TBisTaxiDataOutMessageInsertExForm = class(TBisDataEditForm)
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    LabelDateOut: TLabel;
    DateTimePickerOut: TDateTimePicker;
    DateTimePickerOutTime: TDateTimePicker;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelCreator: TLabel;
    EditCreator: TEdit;
    LabelPriority: TLabel;
    ComboBoxPriority: TComboBox;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelText: TLabel;
    MemoText: TMemo;
    LabelCounter: TLabel;
    LabelRecipients: TLabel;
    ListBoxRecipients: TListBox;
    ButtonRecipientsAdd: TButton;
    ButtonRecipientsDel: TButton;
    ButtonPattern: TButton;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    DateTimePickerBeginTime: TDateTimePicker;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
    DateTimePickerEndTime: TDateTimePicker;
    CheckBoxFlash: TCheckBox;
    CheckBoxDelivery: TCheckBox;
    CheckBoxOffset: TCheckBox;
    EditOffset: TEdit;
    UpDownOffset: TUpDown;
    LabelFirm: TLabel;
    ComboBoxFirm: TComboBox;
    procedure MemoTextChange(Sender: TObject);
    procedure ButtonRecipientsAddClick(Sender: TObject);
    procedure ButtonRecipientsDelClick(Sender: TObject);
    procedure ListBoxRecipientsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ButtonPatternClick(Sender: TObject);
    procedure CheckBoxOffsetClick(Sender: TObject);
  private
    FSHigh: String;
    FSNormal: String;
    FSLow: String;
    FWithLocked: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    destructor Destroy; override;
    procedure BeforeShow; override;
    procedure Execute; override;
    function ChangesExists: Boolean; override;
    function CheckParams: Boolean; override;
    function AddRecipient(UserName, Surname, Name, Patronymic, Phone: String;
                          AccountId: Variant; IsRole: Boolean): TBisTaxiDataOutMessageRecipientInfo;

    property WithLocked: Boolean read FWithLocked write FWithLocked;                       
  published
    property SHigh: String read FSHigh write FSHigh;
    property SNormal: String read FSNormal write FSNormal;
    property SLow: String read FSLow write FSLow;

  end;

  TBisTaxiDataOutMessageInsertExFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataOutMessageInsertExForm: TBisTaxiDataOutMessageInsertExForm;

implementation

uses DateUtils,
     BisUtils, BisCore, BisFilterGroups, BisConsts, BisTaxiConsts, BisParamEditDataSelect,
     BisDataSet, BisProvider, BisParams, BisDialogs,
     BisDesignDataRolesAndAccountsFm, BisMessDataPatternMessagesFm,
     BisTaxiDataOutMessageEditFm;

{$R *.dfm}

{ TBisTaxiDataOutMessageInsertExFormIface }

constructor TBisTaxiDataOutMessageInsertExFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataOutMessageInsertExForm;
  Permissions.Enabled:=true;
  ProviderName:='I_OUT_MESSAGE';
  ParentProviderName:='S_OUT_MESSAGES';
  Caption:='������� ����� ��������� ���������';
  SMessageSuccess:='��������� ������� �������.';
  with Params do begin
    AddKey('OUT_MESSAGE_ID').Older('OLD_OUT_MESSAGE_ID');
    AddInvisible('LOCKED');
    AddInvisible('RECIPIENT_ID');
    AddInvisible('RECIPIENT_USER_NAME');
    AddInvisible('RECIPIENT_SURNAME');
    AddInvisible('RECIPIENT_NAME');
    AddInvisible('RECIPIENT_PATRONYMIC');
    AddInvisible('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
    AddInvisible('CONTACT');
    AddInvisible('ORDER_ID');
    AddInvisible('CHANNEL');
    AddInvisible('DATE_DELIVERY');
    AddInvisible('DEST_PORT');
    AddInvisible('OPERATOR_ID');
    AddInvisible('OPERATOR_NAME');
    AddComboBoxIndex('TYPE_MESSAGE','ComboBoxType','LabelType',true).Value:=0;
    AddCheckBox('DELIVERY','CheckBoxDelivery');
    AddCheckBox('FLASH','CheckBoxFlash');
    AddComboBoxIndex('PRIORITY','ComboBoxPriority','LabelPriority',true);
    AddMemo('TEXT_OUT','MemoText','LabelCounter');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin',true);
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd');
    AddEditDateTime('DATE_OUT','DateTimePickerOut','DateTimePickerOutTime','LabelDateOut');
    AddEditDataSelect('CREATOR_ID','EditCreator','LabelCreator','',
                      TBisDesignDataRolesAndAccountsFormIface,'CREATOR_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
    AddComboBoxDataSelect('FIRM_ID','ComboBoxFirm','LabelFirm',
                          'S_OFFICES','FIRM_SMALL_NAME',false,false,'','SMALL_NAME');
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes(AllParamEditModes);
  end;
end;

{ TBisTaxiDataOutMessageInsertExForm }

constructor TBisTaxiDataOutMessageInsertExForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxType.Clear;
  for i:=0 to 2 do
    ComboBoxType.Items.Add(GetTypeMessageByIndex(i));

  Provider.UseWaitCursor:=false;

  CheckBoxOffsetClick(nil);

  FWithLocked:=true;
  
  FSHigh:='�������';
  FSNormal:='����������';
  FSLow:='������';
end;

destructor TBisTaxiDataOutMessageInsertExForm.Destroy;
begin
  ClearStrings(ListBoxRecipients.Items);
  inherited Destroy;
end;

procedure TBisTaxiDataOutMessageInsertExForm.Init;
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

procedure TBisTaxiDataOutMessageInsertExForm.MemoTextChange(Sender: TObject);
begin
  LabelCounter.Caption:=IntToStr(Length(MemoText.Lines.Text));
end;

procedure TBisTaxiDataOutMessageInsertExForm.BeforeShow;
var
  D: TDateTime;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    D:=Core.ServerDate;
    ActiveControl:=ListBoxRecipients;
    with Provider.Params do begin
      Find('TYPE_MESSAGE').SetNewValue(0);
      Find('PRIORITY').SetNewValue(2);
      Find('DATE_BEGIN').SetNewValue(D);
      Find('CREATOR_ID').SetNewValue(Core.AccountId);
      Find('CREATOR_NAME').SetNewValue(Core.AccountUserName);
      Find('DATE_CREATE').SetNewValue(D);
      Find('FIRM_ID').SetNewValue(Core.FirmId);
      Find('FIRM_SMALL_NAME').SetNewValue(Core.FirmSmallName);
    end;
  end;
  if not VarIsNull(Core.FirmId) then
    Provider.ParamByName('FIRM_ID').Enabled:=false;
  LabelCounter.Enabled:=not (Mode in [emDelete]);
  ButtonPattern.Enabled:=LabelCounter.Enabled;
  CheckBoxOffset.Checked:=true;
  UpdateButtonState;
  MemoTextChange(nil);
end;

function TBisTaxiDataOutMessageInsertExForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists and (ListBoxRecipients.Items.Count>0);
end;

procedure TBisTaxiDataOutMessageInsertExForm.CheckBoxOffsetClick(Sender: TObject);
begin
  EditOffset.Enabled:=CheckBoxOffset.Checked;
  EditOffset.Color:=iff(EditOffset.Enabled,clWindow,ColorControlReadOnly);
  UpDownOffset.Enabled:=CheckBoxOffset.Checked;
end;

function TBisTaxiDataOutMessageInsertExForm.CheckParams: Boolean;
begin
  Result:=inherited CheckParams;
  if Result then begin
    Result:=ListBoxRecipients.Count>0;
    if not Result then
     ShowError(Format(SNeedControlValue,[LabelRecipients.Caption]));
  end;
end;

procedure TBisTaxiDataOutMessageInsertExForm.Execute;

  function RefreshPackageParams: Boolean;
  var
    Params: TBisParams;
    Obj: TBisTaxiDataOutMessageRecipientInfo;
    i: Integer;
    P1Group: TBisFilterGroup;
    P2Group: TBisFilterGroup;
    P1,P2: TBisProvider;
    Flag: Boolean;
    Contact: Variant;
    RoleExists: Boolean;
    DNew: TDateTime;
  begin
    Result:=false;
    P1:=TBisProvider.Create(nil);
    P2:=TBisProvider.Create(nil);
    try
      P1.UseWaitCursor:=false;
      P1.ProviderName:='S_ACCOUNTS';
      with P1.FieldNames do begin
        AddInvisible('ACCOUNT_ID');
        AddInvisible('USER_NAME');
        AddInvisible('SURNAME');
        AddInvisible('NAME');
        AddInvisible('PATRONYMIC');
        AddInvisible('PHONE');
      end;
      if FWithLocked then
        P1.FilterGroups.Add.Filters.Add('LOCKED',fcNotEqual,1);
      P1Group:=P1.FilterGroups.Add;

      P2.UseWaitCursor:=false;
      P2.ProviderName:='S_ACCOUNT_ROLES';
      P2.FieldNames.AddInvisible('ACCOUNT_ID');
      P2Group:=P2.FilterGroups.Add;
      RoleExists:=false;
      for i:=0 to ListBoxRecipients.Count-1 do begin
        Obj:=TBisTaxiDataOutMessageRecipientInfo(ListBoxRecipients.Items.Objects[i]);
        if not Obj.IsRole then begin
          P1Group.Filters.Add('ACCOUNT_ID',fcEqual,Obj.AccountId).Operator:=foOr;
        end else begin
          P2Group.Filters.Add('ROLE_ID',fcEqual,Obj.AccountId).Operator:=foOr;
          RoleExists:=true;
        end;
      end;

      if RoleExists then begin

        P2.Open;

        if P2.Active and not P2.Empty then begin
          P2.First;
          while not P2.Eof do begin
            P1Group.Filters.Add('ACCOUNT_ID',fcEqual,P2.FieldByName('ACCOUNT_ID').Value).Operator:=foOr;
            P2.Next;
          end;
        end;
      end;

      Flag:=true;
      P1.Open;
      if P1.Active and not P1.Empty then begin
        P1.First;
        DNew:=Provider.Params.ParamByName('DATE_BEGIN').Value;
        while not P1.Eof do begin
          Contact:=Null;
          case Provider.Params.ParamByName('TYPE_MESSAGE').AsInteger of
            0: Contact:=P1.FieldByName('PHONE').Value;
          end;

          if not VarIsNull(Contact) then begin
            if Flag then begin
              Provider.Params.ParamByName('RECIPIENT_ID').Value:=P1.FieldByName('ACCOUNT_ID').Value;
              Provider.Params.ParamByName('RECIPIENT_USER_NAME').Value:=P1.FieldByName('USER_NAME').Value;
              Provider.Params.ParamByName('RECIPIENT_SURNAME').Value:=P1.FieldByName('SURNAME').Value;
              Provider.Params.ParamByName('RECIPIENT_NAME').Value:=P1.FieldByName('NAME').Value;
              Provider.Params.ParamByName('RECIPIENT_PATRONYMIC').Value:=P1.FieldByName('PATRONYMIC').Value;
              Provider.Params.ParamByName('CONTACT').Value:=Contact;
              Flag:=false;
              Result:=true;
            end else begin
              if CheckBoxOffset.Checked then
                DNew:=IncSecond(DNew,UpDownOffset.Position);
              
              Params:=Provider.PackageAfter.Add;
              with Params do begin
                AddInvisible('OUT_MESSAGE_ID').Value:=GetUniqueID;
                AddInvisible('LOCKED').Value:=Provider.Params.ParamByName('LOCKED').Value;
                AddInvisible('RECIPIENT_ID').Value:=P1.FieldByName('ACCOUNT_ID').Value;
                AddInvisible('RECIPIENT_USER_NAME').Value:=P1.FieldByName('USER_NAME').Value;
                AddInvisible('RECIPIENT_SURNAME').Value:=P1.FieldByName('SURNAME').Value;
                AddInvisible('RECIPIENT_NAME').Value:=P1.FieldByName('NAME').Value;
                AddInvisible('RECIPIENT_PATRONYMIC').Value:=P1.FieldByName('PATRONYMIC').Value;
                AddInvisible('CONTACT').Value:=Contact;
                AddInvisible('TYPE_MESSAGE').Value:=Provider.Params.ParamByName('TYPE_MESSAGE').Value;
                AddInvisible('DELIVERY').Value:=Provider.Params.ParamByName('DELIVERY').Value;
                AddInvisible('FLASH').Value:=Provider.Params.ParamByName('FLASH').Value;
                AddInvisible('PRIORITY').Value:=Provider.Params.ParamByName('PRIORITY').Value;
                AddInvisible('TEXT_OUT').Value:=Provider.Params.ParamByName('TEXT_OUT').Value;
                AddInvisible('DESCRIPTION').Value:=Provider.Params.ParamByName('DESCRIPTION').Value;
                AddInvisible('DATE_BEGIN').Value:=DNew;
                AddInvisible('DATE_END').Value:=Provider.Params.ParamByName('DATE_END').Value;
                AddInvisible('DATE_OUT').Value:=Provider.Params.ParamByName('DATE_OUT').Value;
                AddInvisible('CREATOR_ID').Value:=Provider.Params.ParamByName('CREATOR_ID').Value;
                AddInvisible('CREATOR_NAME').Value:=Provider.Params.ParamByName('CREATOR_NAME').Value;
                AddInvisible('DATE_CREATE').Value:=Provider.Params.ParamByName('DATE_CREATE').Value;
                AddInvisible('FIRM_ID').Value:=Provider.Params.ParamByName('FIRM_ID').Value;
                AddInvisible('FIRM_SMALL_NAME').Value:=Provider.Params.ParamByName('FIRM_SMALL_NAME').Value;
                AddInvisible('OPERATOR_ID').Value:=Null;
                AddInvisible('OPERATOR_NAME').Value:=Null;
              end;
            end;
          end;
          P1.Next;
        end;
      end;

    finally
      P1.Free;
    end;
  end;
  
var
  OldCursor: TCursor;
  i,j: Integer;
  Params: TBisParams;
  Field: TField;
  Item: TBisParam;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    Provider.PackageAfter.Clear;
    if RefreshPackageParams then begin
      Provider.Execute;
      if Assigned(Provider.ParentDataSet) and (Provider.ParentDataSet.Active) then begin
        for i:=0 to Provider.PackageAfter.Count-1 do begin
          Params:=Provider.PackageAfter.Items[i];
          Provider.ParentDataSet.BeginUpdate(false);
          try
            Provider.ParentDataSet.Append;
            for j:=0 to Params.Count-1 do begin
              Item:=Params.Items[j];
                Field:=Provider.ParentDataSet.FindField(Item.ParamName);
                if Assigned(Field) then begin
                  if Item.Empty then
                    Field.Value:=Null
                  else
                    Field.Value:=Item.Value;
                end;
            end;
            Provider.ParentDataSet.Post;
            Provider.ParentDataSet.ServerRecordCount:=Provider.ParentDataSet.ServerRecordCount+1;
          finally
            Provider.ParentDataSet.EndUpdate(true);
          end;
        end;
      end;
      Provider.InsertIntoParent;
    end;

  finally
    Screen.Cursor:=OldCursor;
  end;
end;

procedure TBisTaxiDataOutMessageInsertExForm.ListBoxRecipientsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=VK_INSERT then
    ButtonRecipientsAddClick(nil);
  if Key=VK_DELETE then
    ButtonRecipientsDelClick(nil);
end;

procedure TBisTaxiDataOutMessageInsertExForm.ButtonPatternClick(Sender: TObject);
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

function TBisTaxiDataOutMessageInsertExForm.AddRecipient(UserName,Surname,Name,Patronymic,Phone: String; AccountId: Variant;
                                                         IsRole: Boolean): TBisTaxiDataOutMessageRecipientInfo;
begin
  Result:=nil;
  if ListBoxRecipients.Items.IndexOf(UserName)=-1 then begin
    Result:=TBisTaxiDataOutMessageRecipientInfo.Create;
    Result.AccountId:=AccountId;
    Result.IsRole:=IsRole;
    Result.Surname:=Surname;
    Result.Name:=Name;
    Result.Patronymic:=Patronymic;
    Result.Phone:=Phone;
    if not IsRole then
      ListBoxRecipients.Items.AddObject(FormatEx('%s - %s %s %s',[UserName,Surname,Name,Patronymic]),Result)
    else
      ListBoxRecipients.Items.AddObject(FormatEx('%s',[UserName]),Result);
  end;
end;

procedure TBisTaxiDataOutMessageInsertExForm.ButtonRecipientsAddClick(Sender: TObject);
var
  D: TBisDataSet;
  Iface: TBisDesignDataRolesAndAccountsFormIface;
  Phone: String;
begin
  Iface:=TBisDesignDataRolesAndAccountsFormIface.Create(nil);
  D:=TBisDataSet.Create(nil);
  try
    Iface.Init;
//    if Core.DataSelectInto(SClassDataRolesAndAccountsFormIface,P,'',Null,true,imIfaceClass) then begin
    Iface.MultiSelect:=true; 
    if Iface.SelectInto(D) then begin
      if D.Active and not D.Empty then begin
        D.First;
        while not D.Eof do begin
          Phone:=D.FieldByName('PHONE').AsString;
          if (Trim(Phone)<>'') or VarIsNull(D.FieldByName('PARENT_ID').Value) then begin
            AddRecipient(D.FieldByName('USER_NAME').AsString,
                         D.FieldByName('SURNAME').AsString,
                         D.FieldByName('NAME').AsString,
                         D.FieldByName('PATRONYMIC').AsString,
                         Phone,
                         D.FieldByName('ACCOUNT_ID').Value,
                         VarIsNull(D.FieldByName('PARENT_ID').Value));
          end;
          D.Next;
        end;
        UpdateButtonState;
      end;
    end;
  finally
    D.Free;
    Iface.Free;
  end;
end;

procedure TBisTaxiDataOutMessageInsertExForm.ButtonRecipientsDelClick(Sender: TObject);
var
  i: Integer;
  Obj: TBisTaxiDataOutMessageRecipientInfo;
begin
  ListBoxRecipients.Items.BeginUpdate;
  try
    for i:=ListBoxRecipients.Items.Count-1 downto 0 do begin
      if ListBoxRecipients.Selected[i] then begin
        Obj:=TBisTaxiDataOutMessageRecipientInfo(ListBoxRecipients.Items.Objects[i]);
        Obj.Free;
        ListBoxRecipients.Items.Delete(i);
      end;
    end;
    UpdateButtonState;
  finally
    ListBoxRecipients.Items.EndUpdate;
  end;
end;

end.
