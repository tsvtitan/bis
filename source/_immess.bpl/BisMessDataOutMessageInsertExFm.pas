unit BisMessDataOutMessageInsertExFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList,
  BisFm, BisDataEditFm, BisParam, BisControls;

type
  TBisMessRecipientInfo=class(TObject)
  private
    FAccountId: Variant;
    FIsRole: Boolean;
  public
    property AccountId: Variant read FAccountId write FAccountId;
    property IsRole: Boolean read FIsRole write FIsRole; 
  end;

  TBisMessDataOutMessageInsertExForm = class(TBisDataEditForm)
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
    procedure MemoTextChange(Sender: TObject);
    procedure ButtonRecipientsAddClick(Sender: TObject);
    procedure ButtonRecipientsDelClick(Sender: TObject);
    procedure ListBoxRecipientsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ButtonPatternClick(Sender: TObject);
  private
    FSHigh: String;
    FSNormal: String;
    FSLow: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    destructor Destroy; override;
    procedure BeforeShow; override;
    procedure Execute; override;
    function ChangesExists: Boolean; override;
    function CheckParams: Boolean; override;
  published
    property SHigh: String read FSHigh write FSHigh;
    property SNormal: String read FSNormal write FSNormal;
    property SLow: String read FSLow write FSLow;

  end;

  TBisMessDataOutMessageInsertExFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessDataOutMessageInsertExForm: TBisMessDataOutMessageInsertExForm;

implementation

uses BisUtils, BisCore, BisFilterGroups, BisMessConsts, BisParamEditDataSelect,
     BisMessDataOutMessageEditFm, BisProvider, BisParams, BisDialogs, BisMessDataPatternMessagesFm,
     BisMessDataRolesAndAccountsFm;

{$R *.dfm}

{ TBisMessDataOutMessageInsertExFormIface }

constructor TBisMessDataOutMessageInsertExFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataOutMessageInsertExForm;
  Permissions.Enabled:=true;
  ProviderName:='I_OUT_MESSAGE';
  ParentProviderName:='S_OUT_MESSAGES';
  Caption:='������� ����� ��������� ���������';
  SMessageSuccess:='��������� ������� �������.';
  with Params do begin
    AddKey('OUT_MESSAGE_ID').Older('OLD_OUT_MESSAGE_ID');
    AddInvisible('LOCKED');
    AddInvisible('RECIPIENT_ID');
    AddInvisible('RECIPIENT_NAME');
    AddInvisible('CONTACT');
    AddComboBoxIndex('TYPE_MESSAGE','ComboBoxType','LabelType',true).Value:=0;
    AddComboBoxIndex('PRIORITY','ComboBoxPriority','LabelPriority',true);
    AddMemo('TEXT_OUT','MemoText','LabelCounter');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin',true);
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd');
    AddEditDateTime('DATE_OUT','DateTimePickerOut','DateTimePickerOutTime','LabelDateOut');
    if IsMainModule then begin
      AddEditDataSelect('CREATOR_ID','EditCreator','LabelCreator','',
                         TBisMessDataRolesAndAccountsFormIface,'CREATOR_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
    end else begin
      AddEditDataSelect('CREATOR_ID','EditCreator','LabelCreator','',
                         SIfaceClassDataRolesAndAccountsFormIface,'CREATOR_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
    end;
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes(AllParamEditModes);
  end;
end;

{ TBisMessDataOutMessageInsertExForm }

constructor TBisMessDataOutMessageInsertExForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxType.Clear;
  for i:=0 to 0 do
    ComboBoxType.Items.Add(GetTypeMessageByIndex(i));

  Provider.WithWaitCursor:=false;

  FSHigh:='�������';
  FSNormal:='����������';
  FSLow:='������';
end;

destructor TBisMessDataOutMessageInsertExForm.Destroy;
begin
  ClearStrings(ListBoxRecipients.Items);
  inherited Destroy;
end;

procedure TBisMessDataOutMessageInsertExForm.Init;
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

procedure TBisMessDataOutMessageInsertExForm.MemoTextChange(Sender: TObject);
begin
  LabelCounter.Caption:=IntToStr(Length(MemoText.Lines.Text));
end;

procedure TBisMessDataOutMessageInsertExForm.BeforeShow;
var
  D: TDateTime;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    D:=Core.ServerDate;
    ActiveControl:=ListBoxRecipients;
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
  ButtonPattern.Enabled:=LabelCounter.Enabled;
  UpdateButtonState;
  MemoTextChange(nil);
end;

function TBisMessDataOutMessageInsertExForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists and (ListBoxRecipients.Items.Count>0);
end;

function TBisMessDataOutMessageInsertExForm.CheckParams: Boolean;
begin
  Result:=inherited CheckParams;
  if Result then begin
    Result:=ListBoxRecipients.Count>0;
    if not Result then
     ShowError(Format(SNeedControlValue,[LabelRecipients.Caption]));
  end;
end;

procedure TBisMessDataOutMessageInsertExForm.Execute;

  function RefreshPackageParams: Boolean;
  var
    Params: TBisParams;
    Obj: TBisMessRecipientInfo;
    i: Integer;
    P1Group: TBisFilterGroup;
    P2Group: TBisFilterGroup;
    P1,P2: TBisProvider;
    Flag: Boolean;
    Contact: Variant;
    RoleExists: Boolean;
  begin
    Result:=false;
    P1:=TBisProvider.Create(nil);
    P2:=TBisProvider.Create(nil);
    try
      P1.WithWaitCursor:=false;
      P1.ProviderName:='S_ACCOUNTS';
      with P1.FieldNames do begin
        AddInvisible('ACCOUNT_ID');
        AddInvisible('USER_NAME');
        AddInvisible('PHONE');
        AddInvisible('EMAIL');
      end;
      P1.FilterGroups.Add.Filters.Add('LOCKED',fcNotEqual,1);
      P1Group:=P1.FilterGroups.Add;

      P2.WithWaitCursor:=false;
      P2.ProviderName:='S_ACCOUNT_ROLES';
      P2.FieldNames.AddInvisible('ACCOUNT_ID');
      P2Group:=P2.FilterGroups.Add;
      RoleExists:=false;
      for i:=0 to ListBoxRecipients.Count-1 do begin
        Obj:=TBisMessRecipientInfo(ListBoxRecipients.Items.Objects[i]);
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
        while not P1.Eof do begin
          Contact:=Null;
          case Provider.Params.ParamByName('TYPE_MESSAGE').AsInteger of
            0: Contact:=P1.FieldByName('PHONE').Value;
//            1: Contact:=P1.FieldByName('EMAIL').Value;
          end;

          if not VarIsNull(Contact) then begin
            if Flag then begin
              Provider.Params.ParamByName('RECIPIENT_ID').Value:=P1.FieldByName('ACCOUNT_ID').Value;
              Provider.Params.ParamByName('RECIPIENT_NAME').Value:=P1.FieldByName('USER_NAME').Value;
              Provider.Params.ParamByName('CONTACT').Value:=Contact;
              Flag:=false;
              Result:=true;
            end else begin
              Params:=Provider.PackageParams.Add;
              with Params do begin
                AddInvisible('OUT_MESSAGE_ID').Value:=GetUniqueID;
                AddInvisible('LOCKED').Value:=Provider.Params.ParamByName('LOCKED').Value;
                AddInvisible('RECIPIENT_ID').Value:=P1.FieldByName('ACCOUNT_ID').Value;
                AddInvisible('RECIPIENT_NAME').Value:=P1.FieldByName('USER_NAME').Value;
                AddInvisible('CONTACT').Value:=Contact;
                AddInvisible('TYPE_MESSAGE').Value:=Provider.Params.ParamByName('TYPE_MESSAGE').Value;
                AddInvisible('PRIORITY').Value:=Provider.Params.ParamByName('PRIORITY').Value;
                AddInvisible('TEXT_OUT').Value:=Provider.Params.ParamByName('TEXT_OUT').Value;
                AddInvisible('DESCRIPTION').Value:=Provider.Params.ParamByName('DESCRIPTION').Value;
                AddInvisible('DATE_BEGIN').Value:=Provider.Params.ParamByName('DATE_BEGIN').Value;
                AddInvisible('DATE_END').Value:=Provider.Params.ParamByName('DATE_END').Value;
                AddInvisible('DATE_OUT').Value:=Provider.Params.ParamByName('DATE_OUT').Value;
                AddInvisible('CREATOR_ID').Value:=Provider.Params.ParamByName('CREATOR_ID').Value;
                AddInvisible('CREATOR_NAME').Value:=Provider.Params.ParamByName('CREATOR_NAME').Value;
                AddInvisible('DATE_CREATE').Value:=Provider.Params.ParamByName('DATE_CREATE').Value;
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
    Provider.PackageParams.Clear;
    if RefreshPackageParams then begin
      Provider.Execute;
      if Assigned(Provider.ParentDataSet) and (Provider.ParentDataSet.Active) then begin
        for i:=0 to Provider.PackageParams.Count-1 do begin
          Params:=Provider.PackageParams.Items[i];
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

procedure TBisMessDataOutMessageInsertExForm.ListBoxRecipientsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=VK_INSERT then
    ButtonRecipientsAddClick(nil);
  if Key=VK_DELETE then
    ButtonRecipientsDelClick(nil);
end;

procedure TBisMessDataOutMessageInsertExForm.ButtonPatternClick(Sender: TObject);
var
  AIface: TBisMessDataPatternMessagesFormIface;
  P: TBisProvider;
begin
  AIface:=TBisMessDataPatternMessagesFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.Init;
//    AIface.ShowType:=stNormal;
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

procedure TBisMessDataOutMessageInsertExForm.ButtonRecipientsAddClick(Sender: TObject);
var
  P: TBisProvider;
  Obj: TBisMessRecipientInfo;
  UserName: String;
  Iface: TBisMessDataRolesAndAccountsFormIface;
begin
  P:=TBisProvider.Create(nil);
  try
    if IsMainModule then begin
      Iface:=TBisMessDataRolesAndAccountsFormIface.Create(nil);
      try
        Iface.Init;
        if Iface.SelectInto(P) then begin
          if P.Active and not P.Empty then begin
            P.First;
            while not P.Eof do begin
              UserName:=P.FieldByName('USER_NAME').AsString;
              if ListBoxRecipients.Items.IndexOf(UserName)=-1 then begin
                Obj:=TBisMessRecipientInfo.Create;
                Obj.AccountId:=P.FieldByName('ACCOUNT_ID').Value;
                Obj.IsRole:=VarIsNull(P.FieldByName('PARENT_ID').Value);
                ListBoxRecipients.Items.AddObject(UserName,Obj);
              end;
              P.Next;
            end;
            UpdateButtonState;
          end;
        end;
      finally
        Iface.Free;
      end;
    end else begin
      if Core.DataSelectInto(SIfaceClassDataRolesAndAccountsFormIface,P,'',Null,true,imIfaceClass) then begin
        if P.Active and not P.Empty then begin
          P.First;
          while not P.Eof do begin
            UserName:=P.FieldByName('USER_NAME').AsString;
            if ListBoxRecipients.Items.IndexOf(UserName)=-1 then begin
              Obj:=TBisMessRecipientInfo.Create;
              Obj.AccountId:=P.FieldByName('ACCOUNT_ID').Value;
              Obj.IsRole:=VarIsNull(P.FieldByName('PARENT_ID').Value);
              ListBoxRecipients.Items.AddObject(UserName,Obj);
            end;
            P.Next;
          end;
          UpdateButtonState;
        end;
      end;
    end;
  finally
    P.Free;
  end;
end;

procedure TBisMessDataOutMessageInsertExForm.ButtonRecipientsDelClick(Sender: TObject);
var
  i: Integer;
  Obj: TBisMessRecipientInfo;
begin
  ListBoxRecipients.Items.BeginUpdate;
  try
    for i:=ListBoxRecipients.Items.Count-1 downto 0 do begin
      if ListBoxRecipients.Selected[i] then begin
        Obj:=TBisMessRecipientInfo(ListBoxRecipients.Items.Objects[i]);
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