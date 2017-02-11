unit BisTaxiDataDispatcherEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList, DB,
  BisDataEditFm, BisParam, BisDataFrm,
  BisCallDataCallEditFm,
  BisTaxiDataInMessagesFm, BisTaxiDataOutMessagesFm,
  BisTaxiDataCallEditFm, BisTaxiDataCallsFm, BisTaxiDataOrdersFrm,
  BisControls;

type
  TBisTaxiDataDispatcherEditForm = class(TBisDataEditForm)
    PageControl: TPageControl;
    TabSheetMain: TTabSheet;
    TabSheetMessages: TTabSheet;                                                         
    PageControlMessages: TPageControl;
    TabSheetInMessages: TTabSheet;
    TabSheetOutMessages: TTabSheet;
    TabSheetCalls: TTabSheet;
    PageControlCalls: TPageControl;
    TabSheetInCalls: TTabSheet;
    TabSheetOutCalls: TTabSheet;
    TabSheetOrders: TTabSheet;
    LabelName: TLabel;
    LabelDescription: TLabel;
    LabelPhone: TLabel;
    LabelSurname: TLabel;
    LabelPatronymic: TLabel;
    LabelCalc: TLabel;
    LabelPhoneHome: TLabel;
    LabelPassport: TLabel;
    LabelPlaceBirth: TLabel;
    LabelDateBirth: TLabel;
    LabelAddressResidence: TLabel;
    LabelAddressActual: TLabel;
    LabelUserName: TLabel;
    LabelBalance: TLabel;
    LabelPassword: TLabel;
    LabelFirm: TLabel;
    LabelPhoneInternal: TLabel;
    EditName: TEdit;
    MemoDescription: TMemo;
    EditPhone: TEdit;
    EditSurname: TEdit;
    EditPatronymic: TEdit;
    ComboBoxCalc: TComboBox;
    EditPhoneHome: TEdit;
    MemoPassport: TMemo;
    DateTimePickerBirth: TDateTimePicker;
    EditAddressResidence: TEdit;
    EditAddressActual: TEdit;
    EditPlaceBirth: TEdit;
    CheckBoxLocked: TCheckBox;
    EditUserName: TEdit;
    EditBalance: TEdit;
    EditPassword: TEdit;
    ComboBoxFirm: TComboBox;
    EditPhoneInternal: TEdit;
    procedure PageControlChange(Sender: TObject);
    procedure PageControlMessagesChange(Sender: TObject);
    procedure PageControlCallsChange(Sender: TObject);
  private
    FInMessagesFrame: TBisTaxiDataInMessagesFrame;
    FOutMessagesFrame: TBisTaxiDataOutMessagesFrame;
    FInCallsFrame: TBisTaxiDataCallsFrame;
    FOutCallsFrame: TBisTaxiDataCallsFrame;
    FOrdersFrame: TBisTaxiDataOrdersFrame;

    procedure InsertProfile;
    procedure SetActualBalance;
    procedure SetFirmSmallName;
    function FrameCan(Sender: TBisDataFrame): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ChangeParam(Param: TBisParam); override;
    procedure Execute; override;
    procedure BeforeShow; override;
  end;

  TBisTaxiDataDispatcherEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDispatcherFilterFormIface=class(TBisTaxiDataDispatcherEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDispatcherInsertFormIface=class(TBisTaxiDataDispatcherEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDispatcherUpdateFormIface=class(TBisTaxiDataDispatcherEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDispatcherDeleteFormIface=class(TBisTaxiDataDispatcherEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDispatcherEditForm: TBisTaxiDataDispatcherEditForm;

implementation

uses BisCore, BisUtils, BisTaxiConsts, BisProvider, BisFilterGroups,
     BisTaxiDataCalcsFm, BisTaxiDataCarsFm;

{$R *.dfm}

{ TBisTaxiDataDispatcherEditFormIface }

constructor TBisTaxiDataDispatcherEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDispatcherEditForm;
  with Params do begin
    AddKey('DISPATCHER_ID').Older('OLD_DISPATCHER_ID');
    AddEdit('SURNAME','EditSurName','LabelSurName');
    AddEdit('NAME','EditName','LabelName');
    AddEdit('PATRONYMIC','EditPatronymic','LabelPatronymic');
    AddEdit('PHONE','EditPhone','LabelPhone');
    AddEdit('PHONE_INTERNAL','EditPhoneInternal','LabelPhoneInternal');
    AddEdit('PHONE_HOME','EditPhoneHome','LabelPhoneHome');
    AddComboBoxDataSelect('FIRM_ID','ComboBoxFirm','LabelFirm',
                          'S_OFFICES','FIRM_SMALL_NAME',false,false,'','SMALL_NAME');
    AddEdit('ADDRESS_ACTUAL','EditAddressActual','LabelAddressActual');
    AddMemo('PASSPORT','MemoPassport','LabelPassport');
    AddEdit('ADDRESS_RESIDENCE','EditAddressResidence','LabelAddressResidence');
    AddEditDate('DATE_BIRTH','DateTimePickerBirth','LabelDateBirth');
    AddEdit('PLACE_BIRTH','EditPlaceBirth','LabelPlaceBirth');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddComboBoxDataSelect('CALC_ID','ComboBoxCalc','LabelCalc','',
                          TBisTaxiDataCalcsFormIface,'CALC_NAME',false,false,'','NAME').ExcludeModes(AllParamEditModes);
    AddEdit('BALANCE','EditBalance','LabelBalance').ExcludeModes(AllParamEditModes);                          
    AddEdit('USER_NAME','EditUserName','LabelUserName',true);                          
    AddEdit('PASSWORD','EditPassword','LabelPassword');
    AddCheckBox('LOCKED','CheckBoxLocked');
  end;
end;

{ TBisTaxiDataDispatcherFilterFormIface }

constructor TBisTaxiDataDispatcherFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ �����������';
end;

{ TBisTaxiDataDispatcherInsertFormIface }

constructor TBisTaxiDataDispatcherInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Permissions.Enabled:=true;
  ProviderName:='I_DISPATCHER';
  ParentProviderName:='S_DISPATCHERS';
  Caption:='������� ����������';
  SMessageSuccess:='��������� %USER_NAME ������� ������.';
end;

{ TBisTaxiDataDispatcherUpdateFormIface }

constructor TBisTaxiDataDispatcherUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_DISPATCHER';
  Caption:='�������� ����������';
end;

{ TBisTaxiDataDispatcherDeleteFormIface }

constructor TBisTaxiDataDispatcherDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_DISPATCHER';
  Caption:='������� ����������';
end;

{ TBisTaxiDataDispatcherEditForm }

constructor TBisTaxiDataDispatcherEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Provider.UseWaitCursor:=false;
  EditPassword.Password:=true;

  FInMessagesFrame:=TBisTaxiDataInMessagesFrame.Create(nil);
  with FInMessagesFrame do begin
    Parent:=TabSheetInMessages;
    Align:=alClient;
    Caption:='�������� ���������';
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('NEW_SENDER_NAME').Visible:=false;
    end;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Checked:=true;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FOutMessagesFrame:=TBisTaxiDataOutMessagesFrame.Create(nil);
  with FOutMessagesFrame do begin
    InsertClasses.Remove(InsertClasses.Items[InsertClasses.Count-1]);
    Parent:=TabSheetOutMessages;
    Align:=alClient;
    Caption:='��������� ���������';
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('NEW_RECIPIENT_NAME').Visible:=false;
    end;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Checked:=true;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FInCallsFrame:=TBisTaxiDataCallsFrame.Create(nil);
  with FInCallsFrame do begin
    Parent:=TabSheetInCalls;
    Align:=alClient;
    Caption:='�������� ������';
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('NEW_ACCEPTOR_NAME').Visible:=false;
    end;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Checked:=true;
    ViewMode:=vmIncoming;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FOutCallsFrame:=TBisTaxiDataCallsFrame.Create(nil);
  with FOutCallsFrame do begin
    Parent:=TabSheetOutCalls;
    Align:=alClient;
    Caption:='��������� ������';
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('NEW_CALLER_NAME').Visible:=false;
    end;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Checked:=true;
    ViewMode:=vmOutgoing;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FOrdersFrame:=TBisTaxiDataOrdersFrame.Create(nil);
  with FOrdersFrame do begin
    Parent:=TabSheetOrders;
    Align:=alClient;
    Caption:='������';
    AsModal:=true;
    LabelCounter.Visible:=true;
    Provider.FieldNames.FieldByName('WHO_ACCEPT').Visible:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

end;

destructor TBisTaxiDataDispatcherEditForm.Destroy;
begin
  FOrdersFrame.Free;
  FOutCallsFrame.Free;
  FInCallsFrame.Free;
  FOutMessagesFrame.Free;
  FInMessagesFrame.Free;
  inherited Destroy;
end;

procedure TBisTaxiDataDispatcherEditForm.Init;
begin
  inherited Init;
  FInMessagesFrame.Init;
  FOutMessagesFrame.Init;
  FInCallsFrame.Init;
  FOutCallsFrame.Init;
  FOrdersFrame.Init;
end;

procedure TBisTaxiDataDispatcherEditForm.BeforeShow;
var
  Exists: Boolean;
begin
  inherited BeforeShow;

  Exists:=Mode in [emUpdate,emDelete,emView];
  TabSheetMessages.TabVisible:=Exists;
  TabSheetCalls.TabVisible:=Exists;
  TabSheetOrders.TabVisible:=Exists;

  if (Mode in [emUpdate,emDelete,emView]) then
    SetActualBalance;

  if Mode in [emInsert,emDuplicate] then
    SetFirmSmallName;

  if not VarIsNull(Core.FirmId) then
    Provider.ParamByName('FIRM_ID').Enabled:=(Mode in [emFilter]);

  FInMessagesFrame.BeforeShow;
  FOutMessagesFrame.BeforeShow;
  FInCallsFrame.BeforeShow;
  FOutCallsFrame.BeforeShow;
  FOrdersFrame.BeforeShow;

  if Mode in [emDelete] then begin
    EnableControl(TabSheetMain,false);
    EnableControl(TabSheetInMessages,false);
    EnableControl(TabSheetOutMessages,false);
    EnableControl(TabSheetInCalls,false);
    EnableControl(TabSheetOutCalls,false);
    EnableControl(TabSheetOrders,false);
  end else begin
    FInMessagesFrame.ShowType:=ShowType;
    FOutMessagesFrame.ShowType:=ShowType;
    FInCallsFrame.ShowType:=ShowType;
    FOutCallsFrame.ShowType:=ShowType;
    FOrdersFrame.ShowType:=ShowType;
  end;

  UpdateButtonState;
end;

procedure TBisTaxiDataDispatcherEditForm.SetActualBalance;
var
  ParamBalance: TBisParam;
  ParamDriverId: TBisParam;
  P: TBisProvider;
begin
  ParamBalance:=Provider.Params.ParamByName('BALANCE');
  ParamDriverId:=Provider.Params.ParamByName('DISPATCHER_ID');
  if not ParamDriverId.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.UseShowError:=true;
      P.ProviderName:='GET_ACCOUNT_BALANCE';
      P.Params.AddInvisible('ACCOUNT_ID').Value:=ParamDriverId.Value;
      P.Params.AddInvisible('BALANCE',ptOutput);
      P.Execute;
      if P.Success then
        ParamBalance.SetNewValue(P.Params.ParamByName('BALANCE').Value)
      else
        ParamBalance.SetNewValue(Null);
    finally
      P.Free;
    end;
  end;
end;

procedure TBisTaxiDataDispatcherEditForm.SetFirmSmallName;
var
  ParamFirmId: TBisParam;
  ParamFirmSmallName: TBisParam;
begin
  if not VarIsNull(Core.FirmId) then begin
    ParamFirmId:=Provider.ParamByName('FIRM_ID');
    ParamFirmSmallName:=Provider.ParamByName('FIRM_SMALL_NAME');
    if Assigned(ParamFirmId) and Assigned(ParamFirmSmallName) then begin
      ParamFirmId.SetNewValue(Core.FirmId);
      ParamFirmSmallName.SetNewValue(Core.FirmSmallName);
    end;
  end;
end;

procedure TBisTaxiDataDispatcherEditForm.ChangeParam(Param: TBisParam);
var
  P1, P2, P3, P4: TBisParam;
  S: String;
begin
  inherited ChangeParam(Param);
  if (AnsiSameText(Param.ParamName,'SURNAME') or
      AnsiSameText(Param.ParamName,'NAME') or
      AnsiSameText(Param.ParamName,'PATRONYMIC')) and (Mode in [emInsert,emDuplicate]) then begin
    P1:=Param.Find('SURNAME');
    P2:=Param.Find('NAME');
    P3:=Param.Find('PATRONYMIC');
    P4:=Param.Find('USER_NAME');
    if Assigned(P1) and Assigned(P2) and Assigned(P3) then begin
      S:='';
      if not P1.Empty then
        S:=VarToStrDef(P1.Value,'');
      if not P2.Empty then
        S:=S+' '+Copy(VarToStrDef(P2.Value,''),1,1)+'.';
      if not P3.Empty then
        S:=S+Copy(VarToStrDef(P3.Value,''),1,1)+'.';
      P4.SetNewValue(S);
      UpdateButtonState;
    end;
  end;
end;

procedure TBisTaxiDataDispatcherEditForm.InsertProfile;
var
  P: TBisProvider;
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('DISPATCHER_ID');
  if Assigned(Param) and not Param.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='I_PROFILE';
      P.UseWaitCursor:=false;
      with P.Params do begin
        AddInvisible('ACCOUNT_ID').SetNewValue(Param.Value);
        AddInvisible('APPLICATION_ID').SetNewValue(Core.Application.ID);
      end;
      P.Execute;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisTaxiDataDispatcherEditForm.PageControlMessagesChange(Sender: TObject);
var
  Param: TBisParam;
begin

  if PageControlMessages.ActivePage=TabSheetInMessages then begin
    Param:=Provider.Params.ParamByName('DISPATCHER_ID');
    if not Param.Empty then begin
      with FInMessagesFrame do begin
        SenderId:=Param.Value;
        SenderUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        SenderSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        SenderName:=Self.Provider.Params.ParamByName('NAME').Value;
        SenderPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        Contact:=Self.Provider.Params.ParamByName('PHONE').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('SENDER_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControlMessages.ActivePage=TabSheetOutMessages then begin
    Param:=Provider.Params.ParamByName('DISPATCHER_ID');
    if not Param.Empty then begin
      with FOutMessagesFrame do begin
        RecipientId:=Param.Value;
        RecipientUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        RecipientSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        RecipientName:=Self.Provider.Params.ParamByName('NAME').Value;
        RecipientPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        Contact:=Self.Provider.Params.ParamByName('PHONE').Value;
        Provider.FilterGroups.Clear;
        with Provider.FilterGroups.Add do begin
          Filters.Add('CREATOR_ID',fcEqual,Param.Value).CheckCase:=true;
          with Filters.Add('RECIPIENT_ID',fcEqual,Param.Value) do begin
            &Operator:=foOr;
            CheckCase:=true;
          end;
        end;
        OpenRecords;
      end;
    end;
  end;

end;

procedure TBisTaxiDataDispatcherEditForm.PageControlCallsChange(Sender: TObject);
var
  Param: TBisParam;
begin

  if PageControlCalls.ActivePage=TabSheetInCalls then begin
    Param:=Provider.Params.ParamByName('DISPATCHER_ID');
    if not Param.Empty then begin
      with FInCallsFrame do begin
        AcceptorId:=Param.Value;
        AcceptorUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        AcceptorSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        AcceptorName:=Self.Provider.Params.ParamByName('NAME').Value;
        AcceptorPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        AcceptorPhone:=Self.Provider.Params.ParamByName('PHONE').Value;
        Provider.FilterGroups.Clear;
        with Provider.FilterGroups.Add do begin
          Filters.Add('ACCEPTOR_ID',fcEqual,Param.Value).CheckCase:=true;
          with Filters.Add('CREATOR_ID',fcEqual,Param.Value) do begin
            &Operator:=foOr;
            CheckCase:=true;
          end;
        end;
        OpenRecords;
      end;
    end;
  end;

  if PageControlCalls.ActivePage=TabSheetOutCalls then begin
    Param:=Provider.Params.ParamByName('DISPATCHER_ID');
    if not Param.Empty then begin
      with FOutCallsFrame do begin
        CallerId:=Param.Value;
        CallerUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        CallerSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        CallerName:=Self.Provider.Params.ParamByName('NAME').Value;
        CallerPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        CallerPhone:=Self.Provider.Params.ParamByName('PHONE').Value;
        Provider.FilterGroups.Clear;
        with Provider.FilterGroups.Add do begin
          Filters.Add('CALLER_ID',fcEqual,Param.Value).CheckCase:=true;
          with Filters.Add('CREATOR_ID',fcEqual,Param.Value) do begin
            &Operator:=foOr;
            CheckCase:=true;
          end;
        end;
        OpenRecords;
      end;
    end;
  end;

end;

procedure TBisTaxiDataDispatcherEditForm.PageControlChange(Sender: TObject);
var
  Param: TBisParam;
begin

  if PageControl.ActivePage=TabSheetMessages then begin
    PageControlMessagesChange(nil);
  end;

  if PageControl.ActivePage=TabSheetCalls then begin
    PageControlCallsChange(nil);
  end;

  if PageControl.ActivePage=TabSheetOrders then begin
    Param:=Provider.Params.ParamByName('DISPATCHER_ID');
    if not Param.Empty then begin
      with FOrdersFrame do begin
        with Provider do begin
          FilterGroups.Clear;
          with FilterGroups.Add do begin
         {   Filters.Add('PARENT_ID',fcIsNull,Null);
            Filters.Add('DATE_HISTORY',fcIsNull,Null); }
            Filters.Add('WHO_HISTORY_ID',fcIsNull,Null);
            Filters.Add('WHO_ACCEPT_ID',fcEqual,Param.Value).CheckCase:=true;
          end;
        end;
        OpenRecords;
      end;
    end;
  end;

end;

procedure TBisTaxiDataDispatcherEditForm.Execute;
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    inherited Execute;
    if Mode in [emInsert,emDuplicate] then
      InsertProfile;
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

function TBisTaxiDataDispatcherEditForm.FrameCan(Sender: TBisDataFrame): Boolean;
begin
  Result:=Mode in [emUpdate];
end;

end.
