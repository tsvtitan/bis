unit BisCallcDealFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, DB, OleCtrls, SHDocVw,

  BisCallcTaskFrm, BisDataGridFrm, BisFieldNames, BisControls, BisTapi,
  BisProvider, BisParams, BisParam, BisDataEditFm,
  BisCallcDealFrameTasksFrm, BisCallcDealFramePaymentsFrm, BisCallcDealFrameDocumentsFrm;

type
  TBisCallcDealFrameTapi=class(TBisTapi)
  private
    FButton: TButton;
    FEdit: TEdit;
    FLabelStatus: TLabel;
    FLabelEditCaption: String;
  public
    procedure EmptyControlLinks;

    property Button: TButton read FButton write FButton;
    property Edit: TEdit read FEdit write FEdit;
    property LabelEditCaption: String read FLabelEditCaption write FLabelEditCaption;
    property LabelStatus: TLabel read FLabelStatus write FLabelStatus;
  end;

  TBisCallcDealFrame = class(TBisCallcTaskFrame)
    PanelDeal: TPanel;
    GroupBoxDeal: TGroupBox;
    LabelNoDeal: TLabel;
    PanelControls: TPanel;
    LabelFirm: TLabel;
    LabelCurrency: TLabel;
    LabelAccountNum: TLabel;
    LabelArrearPeriod: TLabel;
    LabelCurrentDebt: TLabel;
    LabelDebtor: TLabel;
    EditFirm: TEdit;
    EditCurrency: TEdit;
    EditAccountNum: TEdit;
    EditArrearPeriod: TEdit;
    EditCurrentDebt: TEdit;
    EditDebtor: TEdit;
    PageControl: TPageControl;
    TabSheetDebtor: TTabSheet;
    TabSheetGuarantors: TTabSheet;
    MemoGuarantors: TMemo;
    TabSheetDebtInformation: TTabSheet;
    MemoDebtInformation: TMemo;
    TabSheetTasks: TTabSheet;
    TabSheetPayments: TTabSheet;
    TabSheetDeal: TTabSheet;
    PageControlDebtor: TPageControl;
    TabSheetDebtorGeneral: TTabSheet;
    TabSheetDebtorAddresses: TTabSheet;
    TabSheetDebtorJob: TTabSheet;
    TabSheetDebtorPhones: TTabSheet;
    TabSheetDebtorFounders: TTabSheet;
    LabelSurname: TLabel;
    EditSurname: TEdit;
    LabelName: TLabel;
    EditName: TEdit;
    LabelPatronymic: TLabel;
    EditPatronymic: TEdit;
    LabelPassport: TLabel;
    MemoPassport: TMemo;
    LabelDateBirth: TLabel;
    LabelSex: TLabel;
    LabelAddressResidence: TLabel;
    EditAddressResidence: TEdit;
    LabelAddressActual: TLabel;
    EditAddressActual: TEdit;
    LabelAddressAdditional: TLabel;
    EditAddressAdditional: TEdit;
    LabelIndexResidence: TLabel;
    EditIndexResidence: TEdit;
    LabelIndexActual: TLabel;
    EditIndexActual: TEdit;
    LabelIndexAdditional: TLabel;
    EditIndexAdditional: TEdit;
    LabelPlaceWork: TLabel;
    EditPlaceWork: TEdit;
    LabelJobTitle: TLabel;
    EditJobTitle: TEdit;
    LabelIndexWork: TLabel;
    EditIndexWork: TEdit;
    LabelAddressWork: TLabel;
    EditAddressWork: TEdit;
    LabelPhoneHome: TLabel;
    EditPhoneHome: TEdit;
    LabelPhoneWork: TLabel;
    EditPhoneWork: TEdit;
    LabelPhoneMobile: TLabel;
    EditPhoneMobile: TEdit;
    LabelPhoneOther1: TLabel;
    EditPhoneOther1: TEdit;
    LabelPhoneOther2: TLabel;
    EditPhoneOther2: TEdit;
    ButtonPhoneHome: TButton;
    ButtonPhoneWork: TButton;
    ButtonPhoneMobile: TButton;
    ButtonPhoneOther1: TButton;
    ButtonPhoneOther2: TButton;
    LabelStatusPhoneHome: TLabel;
    LabelStatusPhoneWork: TLabel;
    LabelStatusPhoneMobile: TLabel;
    LabelStatusPhoneOther1: TLabel;
    LabelStatusPhoneOther2: TLabel;
    MemoFounders: TMemo;
    TabSheetDocuments: TTabSheet;
    TabSheetPattern: TTabSheet;
    RichEditPattern: TRichEdit;
    ComboBoxSex: TComboBox;
    DateTimePickerDateBirth: TDateTimePicker;
    LabelPlaceBirth: TLabel;
    EditPlaceBirth: TEdit;
    LabelDebtorNum: TLabel;
    EditDebtorNum: TEdit;
    LabelDebtorDate: TLabel;
    EditDebtorDate: TEdit;
    LabelInitialDebt: TLabel;
    EditInitialDebt: TEdit;
    EditAmountPayment: TEdit;
    LabelAmountPayment: TLabel;
    TabSheetJournal: TTabSheet;
    WebBrowser: TWebBrowser;
    procedure ButtonFirmClick(Sender: TObject);
    procedure ButtonDebtorClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure ButtonPhoneHomeClick(Sender: TObject);
    procedure EditPhoneHomeChange(Sender: TObject);
  private
    FFirmId: Variant;
    FDebtorId: Variant;
    FPaymentsFrame: TBisCallcDealFramePaymentsFrame;
    FTasksFrame: TBisCallcDealFrameTasksFrame;
    FDocumentsFrame: TBisCallcDealFrameDocumentsFrame;
    FPatternStream: TMemoryStream;
    FDebtorParams: TBisParams;
    FTapi: TBisCallcDealFrameTapi;
    FOldPageActiveIndex: Integer;
    FDebtorEdited: Boolean;
    FGroupBoxDealCaption: String;
    FChangesArePresent: Boolean;
    FEmptyFileSize: Integer;
    FOnDebtorParamsChange: TNotifyEvent;
    procedure VisibleControls(AVisible: Boolean);
    procedure RefreshDeal;
    procedure RefreshHistories;
    function GetPhoneControlsByButton(Button: TButton; var Edit: TEdit; var LabelEdit, LabelStatus: TLabel): Boolean;
    procedure TapiConnect(Sender: TObject);
    procedure TapiDisconnect(Sender: TObject);
    procedure TapiAfterRecord(Sender: TObject);
    procedure PhoneControlsFirstState;
    procedure PhoneControlsDisabled;
    procedure ChangePatternVars;
    procedure SetDebtorEdited(const Value: Boolean);
    procedure ReadOnlyControls(AParent: TWinControl; AReadOnly: Boolean);
    function PreparePhoneNumber(PhoneNumber: String): String;
    procedure LabelDebtorClick(Sender: TObject);
    procedure DebtorParamsChange(Param: TBisParam);
    procedure RefreshDebts;
    procedure GenerateJournal;
    procedure FramePaymentAfterEditFormExecute(Sender: TBisDataEditForm; Provider: TBisProvider);
  protected
    procedure SetDealNum(const Value: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure RefreshControls; override;
    function CheckControls: Boolean; override;
    procedure SaveChanges; override;

    property ChangesArePresent: Boolean read FChangesArePresent;

    property DebtorEdited: Boolean read FDebtorEdited write SetDebtorEdited;

    property OnDebtorParamsChange: TNotifyEvent read FOnDebtorParamsChange write FOnDebtorParamsChange;
  end;

  TBisCallcDealFrameClass=class of TBisCallcDealFrame;

implementation

uses ShellApi, DateUtils, MSHTML,
     BisUtils, BisFilterGroups, BisConsts, BisOrders, BisCallcHbookDebtorHistoriesFm,
     BisCallcConsts, BisCallcHbookDebtorsFm, BisCallcHbookDebtorEditFm,
     BisCallcHbookPaymentEditFm, BisDialogs, BisCore, BisCodec,
     BisCallcHbookTaskDocumentEditFm, BisVariants, BisDataFm, BisIfaces,
     BisParamComboBox, BisParamEdit, BisParamMemo, BisParamEditDate, BisCallcBiasFIO;

{$R *.dfm}

{ TBisCallcDealFrameTapi }

procedure TBisCallcDealFrameTapi.EmptyControlLinks;
begin
  FButton:=nil;
  FEdit:=nil;
  FLabelStatus:=nil;
end;


{ TBisCallcDealFrame }

constructor TBisCallcDealFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UseUnlock:=true;

  EditFirm.Anchors:=EditFirm.Anchors+[akRight];
//  ButtonFirm.Anchors:=ButtonFirm.Anchors+[akRight]-[akLeft];
  LabelAccountNum.Anchors:=LabelAccountNum.Anchors+[akRight]-[akLeft];
  EditAccountNum.Anchors:=EditAccountNum.Anchors+[akRight]-[akLeft];
  LabelCurrency.Anchors:=LabelCurrency.Anchors+[akRight]-[akLeft];
  EditCurrency.Anchors:=EditCurrency.Anchors+[akRight]-[akLeft];
  EditDebtor.Anchors:=EditDebtor.Anchors+[akRight];
//  ButtonDebtor.Anchors:=ButtonDebtor.Anchors+[akRight]-[akLeft];
  LabelInitialDebt.Anchors:=LabelInitialDebt.Anchors+[akRight]-[akLeft];
  EditInitialDebt.Anchors:=LabelInitialDebt.Anchors;
  LabelAmountPayment.Anchors:=LabelAmountPayment.Anchors+[akRight]-[akLeft];
  EditAmountPayment.Anchors:=LabelAmountPayment.Anchors;
  LabelCurrentDebt.Anchors:=LabelCurrentDebt.Anchors+[akRight]-[akLeft];
  EditCurrentDebt.Anchors:=LabelCurrentDebt.Anchors;
  LabelArrearPeriod.Anchors:=LabelArrearPeriod.Anchors+[akRight]-[akLeft];
  EditArrearPeriod.Anchors:=LabelArrearPeriod.Anchors;

  FGroupBoxDealCaption:=GroupBoxDeal.Caption;

  PageControl.Anchors:=PageControl.Anchors+[akRight,akBottom];
  PageControl.ActivePageIndex:=0;
  PageControlDebtor.ActivePageIndex:=0;

  TabSheetDebtorFounders.TabVisible:=false;

  ComboBoxSex.Clear;
  ComboBoxSex.Items.Add(GetSexByIndex(0));
  ComboBoxSex.Items.Add(GetSexByIndex(1));

  FDebtorParams:=TBisParams.Create;
  with FDebtorParams do begin
    AddInvisible('DEBTOR_ID').Older('OLD_DEBTOR_ID');
    AddInvisible('DEBTOR_TYPE');
    AddEdit('SURNAME',EditSurname.Name,LabelSurname.Name,true);
    AddEdit('NAME',EditName.Name,LabelName.Name,true);
    AddEdit('PATRONYMIC',EditPatronymic.Name,LabelPatronymic.Name,true);
    AddEditDate('DATE_BIRTH',DateTimePickerDateBirth.Name,LabelDateBirth.Name,true);
    AddComboBox('SEX',ComboBoxSex.Name,LabelSex.Name,true);
    AddEdit('PLACE_BIRTH',EditPlaceBirth.Name,LabelPlaceBirth.Name,true);
    AddMemo('PASSPORT',MemoPassport.Name,LabelPassport.Name,true);
    AddEdit('ADDRESS_RESIDENCE',EditAddressResidence.Name,LabelAddressResidence.Name);
    AddEdit('INDEX_RESIDENCE',EditIndexResidence.Name,LabelIndexResidence.Name);
    AddEdit('ADDRESS_ACTUAL',EditAddressActual.Name,LabelAddressActual.Name);
    AddEdit('INDEX_ACTUAL',EditIndexActual.Name,LabelIndexActual.Name);
    AddEdit('ADDRESS_ADDITIONAL',EditAddressAdditional.Name,LabelAddressAdditional.Name);
    AddEdit('INDEX_ADDITIONAL',EditIndexAdditional.Name,LabelIndexAdditional.Name);
    AddEdit('ADDRESS_WORK',EditAddressWork.Name,LabelAddressWork.Name);
    AddEdit('INDEX_WORK',EditIndexWork.Name,LabelIndexWork.Name);
    AddEdit('PLACE_WORK',EditPlaceWork.Name,LabelPlaceWork.Name);
    AddEdit('JOB_TITLE',EditJobTitle.Name,LabelJobTitle.Name);
    AddEdit('PHONE_HOME',EditPhoneHome.Name,LabelPhoneHome.Name);
    AddEdit('PHONE_WORK',EditPhoneWork.Name,LabelPhoneWork.Name);
    AddEdit('PHONE_MOBILE',EditPhoneMobile.Name,LabelPhoneMobile.Name);
    AddEdit('PHONE_OTHER1',EditPhoneOther1.Name,LabelPhoneOther1.Name);
    AddEdit('PHONE_OTHER2',EditPhoneOther2.Name,LabelPhoneOther2.Name);
    AddMemo('FOUNDERS',MemoFounders.Name,'');
    LinkControls(Self);
    OnChange:=DebtorParamsChange;
  end;

  FPaymentsFrame:=TBisCallcDealFramePaymentsFrame.Create(nil);
  FPaymentsFrame.Parent:=TabSheetPayments;
  FPaymentsFrame.Align:=alClient;
  FPaymentsFrame.OnAfterEditFormExecute:=FramePaymentAfterEditFormExecute;

  FTasksFrame:=TBisCallcDealFrameTasksFrame.Create(nil);
  FTasksFrame.Parent:=TabSheetTasks;
  FTasksFrame.Align:=alClient;

  WebBrowser.Navigate('about:blank');

  FDocumentsFrame:=TBisCallcDealFrameDocumentsFrame.Create(nil);
  FDocumentsFrame.Parent:=TabSheetDocuments;
  FDocumentsFrame.Align:=alClient;
  FDocumentsFrame.Path:=Core.Config.Read('Tapi','Path','');

  FFirmId:=Null;
  FDebtorId:=Null;

  FTapi:=TBisCallcDealFrameTapi.Create(Self);
  FTapi.RecordFromLine:=true;
  FTapi.DeviceName:=Core.Config.Read('Tapi','DeviceName','');
  FTapi.PhonePrefix:=Core.Config.Read('Tapi','PhonePrefix','');

  FEmptyFileSize:=Core.Config.Read('Tapi','EmptyFileSize',0);

  FTapi.OnConnect:=TapiConnect;
  FTapi.OnDisconnect:=TapiDisconnect;
  FTapi.OnAfterRecord:=TapiAfterRecord;

  FPatternStream:=TMemoryStream.Create;

  VisibleControls(false);
  PhoneControlsFirstState;
end;

destructor TBisCallcDealFrame.Destroy;
begin
  FPatternStream.Free;
  FTapi.Free;
  FDocumentsFrame.Free;
  FTasksFrame.Free;
  FPaymentsFrame.Free;
  FDebtorParams.Free;
  inherited Destroy;
end;

procedure TBisCallcDealFrame.DebtorParamsChange(Param: TBisParam);
begin
  FChangesArePresent:=true;
  if Assigned(FOnDebtorParamsChange) then
    FOnDebtorParamsChange(Self);
end;

procedure TBisCallcDealFrame.RefreshDeal;
var
  P: TBisProvider;
begin
  if DealExists then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_DEAL_FIRMS';
      with P.FieldNames do begin
        AddInvisible('FIRM_ID');
        AddInvisible('FIRM_SMALL_NAME');
        AddInvisible('DEBTOR_ID');
        AddInvisible('SURNAME');
        AddInvisible('NAME');
        AddInvisible('PATRONYMIC');
        AddInvisible('ACCOUNT_NUM');
        AddInvisible('ARREAR_PERIOD');
        AddInvisible('CURRENCY_NAME');
        AddInvisible('AMOUNT_PAYMENT');
        AddInvisible('INITIAL_DEBT');
        AddInvisible('CURRENT_DEBT');
        AddInvisible('DATE_BIRTH');
        AddInvisible('PLACE_BIRTH');
        AddInvisible('SEX');
        AddInvisible('PASSPORT');
        AddInvisible('ADDRESS_RESIDENCE');
        AddInvisible('INDEX_RESIDENCE');
        AddInvisible('ADDRESS_ACTUAL');
        AddInvisible('INDEX_ACTUAL');
        AddInvisible('ADDRESS_ADDITIONAL');
        AddInvisible('INDEX_ADDITIONAL');
        AddInvisible('ADDRESS_WORK');
        AddInvisible('INDEX_WORK');
        AddInvisible('PLACE_WORK');
        AddInvisible('JOB_TITLE');
        AddInvisible('PHONE_HOME');
        AddInvisible('PHONE_WORK');
        AddInvisible('PHONE_MOBILE');
        AddInvisible('PHONE_OTHER1');
        AddInvisible('PHONE_OTHER2');
        AddInvisible('FOUNDERS');
        AddInvisible('DEBTOR_TYPE');
        AddInvisible('GUARANTORS');
        AddInvisible('DEBT_INFORMATION');
        AddInvisible('DEBTOR_NUM');
        AddInvisible('DEBTOR_DATE');

        AddInvisible('PATTERN');
        
      end;
      P.FilterGroups.Add.Filters.Add('DEAL_ID',fcEqual,DealId);
      P.Open;
      if P.Active and not P.IsEmpty then begin
        FFirmId:=P.FieldByName('FIRM_ID').Value;
        EditFirm.Text:=P.FieldByName('FIRM_SMALL_NAME').AsString;
        FDebtorId:=P.FieldByName('DEBTOR_ID').Value;
        EditDebtor.Text:=Trim(FormatEx('%s %s %s',[P.FieldByName('SURNAME').AsString,
                                                   P.FieldByName('NAME').AsString,
                                                   P.FieldByName('PATRONYMIC').AsString]));
        EditAccountNum.Text:=P.FieldByName('ACCOUNT_NUM').AsString;
        EditArrearPeriod.Text:=P.FieldByName('ARREAR_PERIOD').AsString;
        EditCurrency.Text:=P.FieldByName('CURRENCY_NAME').AsString;
        EditInitialDebt.Text:=FormatFloat(SDisplayFormatFloat,P.FieldByName('INITIAL_DEBT').AsFloat);
        EditAmountPayment.Text:=FormatFloat(SDisplayFormatFloat,P.FieldByName('AMOUNT_PAYMENT').AsFloat);
        EditCurrentDebt.Text:=FormatFloat(SDisplayFormatFloat,P.FieldByName('CURRENT_DEBT').AsFloat);

        FDebtorParams.RefreshByDataSet(P,True,False);
        FChangesArePresent:=false;
        if Assigned(FOnDebtorParamsChange) then
          FOnDebtorParamsChange(Self);

        TabSheetDebtorFounders.TabVisible:=P.FieldByName('DEBTOR_TYPE').AsInteger=1;
        MemoGuarantors.Lines.Text:=P.FieldByName('GUARANTORS').AsString;
        MemoDebtInformation.Lines.Text:=P.FieldByName('DEBT_INFORMATION').AsString;
        EditDebtorNum.Text:=P.FieldByName('DEBTOR_NUM').AsString;
        EditDebtorDate.Text:=P.FieldByName('DEBTOR_DATE').AsString;

        FPatternStream.Clear;
        TBlobField(P.FieldByName('PATTERN')).SaveToStream(FPatternStream);

      end else begin
        FFirmId:=Null;
        FDebtorId:=Null;
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisCallcDealFrame.RefreshHistories;
var
  i: Integer;
  Fields: TStringList;
  Param: TBisParam;
  ALabel: TLabel;
begin
  if not VarIsNull(FDebtorId) then begin
    Fields:=TStringList.Create;
    try
      for i:=0 to FDebtorParams.Count-1 do begin
        Fields.Add(FDebtorParams.Items[i].ParamName);
      end;
      GetDebtorHistoryExists(FDebtorId,Fields);
      for i:=0 to Fields.Count-1 do begin
        Param:=FDebtorParams.Find(Fields[i]);
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
            ALabel.OnClick:=LabelDebtorClick;
            ALabel.Tag:=Integer(Pointer(Param));
          end;

        end;
      end;
    finally
      Fields.Free;
    end;
  end;
end;

procedure TBisCallcDealFrame.LabelDebtorClick(Sender: TObject);
var
  ALabel: TLabel;
  Param: TBisParam;
  S: String;
  Value: Variant;
begin
  if Assigned(Sender) and (Sender is TLabel) then begin
    ALabel:=TLabel(Sender);
    Param:=TBisParam(Pointer(ALabel.Tag));
    S:=StringReplace(ALabel.Caption,':','',[rfReplaceAll]);
    if SelectDebtorHistory(FDebtorId,Param.ParamName,S,Value) then begin
      if FDebtorEdited then
        Param.Value:=Value;
    end;
  end;
end;

procedure TBisCallcDealFrame.RefreshControls;
begin
  inherited RefreshControls;
//  PageControl.ActivePageIndex:=0;
  PageControlDebtor.ActivePageIndex:=0;
  RefreshDeal;
  RefreshHistories;
  FOldPageActiveIndex:=-1;
  PageControlChange(nil);
  VisibleControls(DealExists);
  PhoneControlsFirstState;
end;

procedure TBisCallcDealFrame.VisibleControls(AVisible: Boolean);
begin
  PanelControls.Visible:=AVisible;

  LabelNoDeal.Visible:=not AVisible;
  LabelNoDeal.Align:=iff(LabelNoDeal.Visible,alClient,alNone);
end;

procedure TBisCallcDealFrame.ButtonFirmClick(Sender: TObject);
var
  AClass: TBisIfaceClass;
  Iface: TBisDataFormIface;
begin
  if not VarIsNull(FFirmId) then begin
    AClass:=Core.FindIfaceClass(SIfaceClassHbookFirmsFormIface);
    if Assigned(AClass) and IsClassParent(AClass,TBisDataFormIface) then begin
      Iface:=TBisDataFormIfaceClass(AClass).Create(nil);
      try
        Iface.LocateFields:='FIRM_ID';
        Iface.LocateValues:=FFirmId;
        Iface.ShowModal;
      finally
        Iface.Free;
      end;
    end;
  end;
end;

procedure TBisCallcDealFrame.ButtonDebtorClick(Sender: TObject);
var
  Iface: TBisCallcHbookDebtorsFormIface;
begin
  if not VarIsNull(FDebtorId) then begin
    Iface:=TBisCallcHbookDebtorsFormIface.Create(nil);
    try
      Iface.LocateFields:='DEBTOR_ID';
      Iface.LocateValues:=FDebtorId;
      Iface.ShowModal;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisCallcDealFrame.PageControlChange(Sender: TObject);
begin
  if FOldPageActiveIndex<>PageControl.ActivePageIndex then begin
    case PageControl.ActivePageIndex of
      3: begin
        FTasksFrame.Provider.Close;
        if DealExists then begin
          FTasksFrame.Provider.FilterGroups.Clear;
          with FTasksFrame.Provider.FilterGroups.Add do begin
            Filters.Add('DEAL_ID',fcEqual,DealId);
            Filters.Add('RESULT_ID',fcIsNotNull,NULL);
          end;
          FTasksFrame.RefreshRecords;
          FTasksFrame.LastRecord;
        end;
      end;
      4: begin
        GenerateJournal;
      end;
      5: begin
        FPaymentsFrame.Provider.Close;
        if DealExists then begin
          FPaymentsFrame.Provider.FilterGroups.Clear;
          FPaymentsFrame.Provider.FilterGroups.Add.Filters.Add('DEAL_ID',fcEqual,DealId);
          FPaymentsFrame.DealId:=DealId;
          FPaymentsFrame.DealNum:=DealNum;
          FPaymentsFrame.RefreshRecords;
        end;
      end;
      6: begin
        FDocumentsFrame.Provider.Close;
        if not VarIsNull(TaskId) then begin
          FDocumentsFrame.Provider.FilterGroups.Clear;
          with FDocumentsFrame.Provider.FilterGroups.Add do begin
            Filters.Add('TASK_ID',fcEqual,TaskId);
          end;
          FDocumentsFrame.TaskId:=TaskId;
          FDocumentsFrame.TaskName:=TaskName;
          FDocumentsFrame.RefreshRecords;
        end;
      end;
      8: begin
        ChangePatternVars;
      end;
    end;
    FOldPageActiveIndex:=PageControl.ActivePageIndex;
  end;
end;

function TBisCallcDealFrame.GetPhoneControlsByButton(Button: TButton; var Edit: TEdit; var LabelEdit, LabelStatus: TLabel): Boolean;
begin
  Result:=false;
  if Button=ButtonPhoneHome then begin
    Edit:=EditPhoneHome;
    LabelEdit:=LabelPhoneHome;
    LabelStatus:=LabelStatusPhoneHome;
    Result:=true;
  end;
  if Button=ButtonPhoneWork then begin
    Edit:=EditPhoneWork;
    LabelEdit:=LabelPhoneWork;
    LabelStatus:=LabelStatusPhoneWork;
    Result:=true;
  end;
  if Button=ButtonPhoneMobile then begin
    Edit:=EditPhoneMobile;
    LabelEdit:=LabelPhoneMobile;
    LabelStatus:=LabelStatusPhoneMobile;
    Result:=true;
  end;
  if Button=ButtonPhoneOther1 then begin
    Edit:=EditPhoneOther1;
    LabelEdit:=LabelPhoneOther1;
    LabelStatus:=LabelStatusPhoneOther1;
    Result:=true;
  end;
  if Button=ButtonPhoneOther2 then begin
    Edit:=EditPhoneOther2;
    LabelEdit:=LabelPhoneOther2;
    LabelStatus:=LabelStatusPhoneOther2;
    Result:=true;
  end;
end;

procedure TBisCallcDealFrame.Init;
begin
  inherited Init;
  FPaymentsFrame.Init;
  FTasksFrame.Init;
  FDocumentsFrame.Init;
end;

procedure TBisCallcDealFrame.PhoneControlsFirstState;
var
  Exists: Boolean;
begin
  Exists:=FTapi.DeviceExists;

  EditPhoneHome.ReadOnly:=not FDebtorEdited;
  ButtonPhoneHome.Enabled:=(PreparePhoneNumber(EditPhoneHome.Text)<>'') and Exists;
  ButtonPhoneHome.Caption:='Набрать';
  LabelStatusPhoneHome.Caption:='не соединен';
  LabelStatusPhoneHome.Font.Style:=[];

  EditPhoneWork.ReadOnly:=not FDebtorEdited;
  ButtonPhoneWork.Enabled:=(PreparePhoneNumber(EditPhoneWork.Text)<>'') and Exists;
  ButtonPhoneWork.Caption:='Набрать';
  LabelStatusPhoneWork.Caption:='не соединен';
  LabelStatusPhoneWork.Font.Style:=[];

  EditPhoneMobile.ReadOnly:=not FDebtorEdited;
  ButtonPhoneMobile.Enabled:=(PreparePhoneNumber(EditPhoneMobile.Text)<>'') and Exists;
  ButtonPhoneMobile.Caption:='Набрать';
  LabelStatusPhoneMobile.Caption:='не соединен';
  LabelStatusPhoneMobile.Font.Style:=[];

  EditPhoneOther1.ReadOnly:=not FDebtorEdited;
  ButtonPhoneOther1.Enabled:=(PreparePhoneNumber(EditPhoneOther1.Text)<>'') and Exists;
  ButtonPhoneOther1.Caption:='Набрать';
  LabelStatusPhoneOther1.Caption:='не соединен';
  LabelStatusPhoneOther1.Font.Style:=[];

  EditPhoneOther2.ReadOnly:=not FDebtorEdited;
  ButtonPhoneOther2.Enabled:=(PreparePhoneNumber(EditPhoneOther2.Text)<>'') and Exists;
  ButtonPhoneOther2.Caption:='Набрать';
  LabelStatusPhoneOther2.Caption:='не соединен';
  LabelStatusPhoneOther2.Font.Style:=[];
end;

procedure TBisCallcDealFrame.PhoneControlsDisabled;
begin
  ButtonPhoneHome.Enabled:=false;
  ButtonPhoneWork.Enabled:=false;
  ButtonPhoneMobile.Enabled:=false;
  ButtonPhoneOther1.Enabled:=false;
  ButtonPhoneOther2.Enabled:=false;
end;

function TBisCallcDealFrame.PreparePhoneNumber(PhoneNumber: String): String;
var
  i: Integer;
const
  Nums=['0'..'9'];
begin
  Result:='';
  for i:=1 to Length(PhoneNumber) do begin
    if PhoneNumber[i] in Nums then
      Result:=Result+PhoneNumber[i];
  end;
end;

procedure TBisCallcDealFrame.EditPhoneHomeChange(Sender: TObject);
var
  Exists: Boolean;
  Active: Boolean;
  AEdit: TEdit;
begin
  if Assigned(Sender) then
    if Sender is TEdit then begin
      AEdit:=TEdit(Sender);
      Exists:=FTapi.DeviceExists;
      Active:=FTapi.Active;
      if AEdit=EditPhoneHome then
        ButtonPhoneHome.Enabled:=(PreparePhoneNumber(EditPhoneHome.Text)<>'') and Exists and not Active;
      if AEdit=EditPhoneWork then
        ButtonPhoneWork.Enabled:=(PreparePhoneNumber(EditPhoneWork.Text)<>'') and Exists and not Active;
      if AEdit=EditPhoneMobile then
        ButtonPhoneMobile.Enabled:=(PreparePhoneNumber(EditPhoneMobile.Text)<>'') and Exists and not Active;
      if AEdit=EditPhoneOther1 then
        ButtonPhoneOther1.Enabled:=(PreparePhoneNumber(EditPhoneOther1.Text)<>'') and Exists and not Active;
      if AEdit=EditPhoneOther2 then
        ButtonPhoneOther2.Enabled:=(PreparePhoneNumber(EditPhoneOther2.Text)<>'') and Exists and not Active;
    end;
end;

procedure TBisCallcDealFrame.RefreshDebts;
var
  P: TBisProvider;
begin
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='GET_DEAL_INFO';
    with P.Params do begin
      AddInvisible('DEAL_ID').Value:=DealId;
      AddInvisible('INITIAL_DEBT',ptOutput);
      AddInvisible('AMOUNT_PAYMENT',ptOutput);
      AddInvisible('CURRENT_DEBT',ptOutput);
    end;
    P.Execute;
    if P.Success then begin
      EditInitialDebt.Text:=FormatFloat(SDisplayFormatFloat,VarToExtendedDef(P.Params.ParamByName('INITIAL_DEBT').Value,0.0));
      EditAmountPayment.Text:=FormatFloat(SDisplayFormatFloat,VarToExtendedDef(P.Params.ParamByName('AMOUNT_PAYMENT').Value,0.0));
      EditCurrentDebt.Text:=FormatFloat(SDisplayFormatFloat,VarToExtendedDef(P.Params.ParamByName('CURRENT_DEBT').Value,0.0));
    end;
  finally
    P.Free;
  end;
end;

procedure TBisCallcDealFrame.FramePaymentAfterEditFormExecute(
  Sender: TBisDataEditForm; Provider: TBisProvider);
begin
  if Assigned(Sender) and (Sender is TBisCallcHbookPaymentEditForm) then begin
    RefreshDebts;
  end;
end;

procedure TBisCallcDealFrame.ButtonPhoneHomeClick(Sender: TObject);
var
  Edit: TEdit;
  Button: TButton;
  LabelEdit: TLabel;
  LabelStatus: TLabel;
begin
  if Assigned(FTapi.Button) then begin
    FTapi.EndCall;
    FTapi.EmptyControlLinks;
    PhoneControlsFirstState;
  end else begin
    if Sender is TButton then begin
      Button:=TButton(Sender);
      if GetPhoneControlsByButton(Button,Edit,LabelEdit,LabelStatus) then begin
        if Assigned(Edit) and (Trim(Edit.Text)<>'') then begin
          FTapi.Button:=Button;
          FTapi.Edit:=Edit;
          FTapi.Edit.ReadOnly:=true;
          FTapi.LabelEditCaption:=LabelEdit.Caption;
          FTapi.LabelStatus:=LabelStatus;
          FTapi.PhoneNumber:=PreparePhoneNumber(Edit.Text);
          FTapi.Button.Caption:='Сбросить';
          FTapi.LabelStatus.Caption:='набор номера';
          FTapi.LabelStatus.Font.Style:=[fsBold];
          if DirectoryExists(FDocumentsFrame.Path) then
            FTapi.RecordFile:=FDocumentsFrame.Path+FormatEx('%s.wav',[GetUniqueID])
          else
            FTapi.RecordFile:=ExtractFilePath(Application.ExeName)+FormatEx('%s.wav',[GetUniqueID]);
          PhoneControlsDisabled;
          FTapi.BeginCall;
        end;
      end;
    end;
  end;
end;

procedure TBisCallcDealFrame.TapiConnect(Sender: TObject);
begin
  if Assigned(FTapi.Button) then begin
    FTapi.LabelStatus.Caption:='соединение';
    FTapi.Button.Enabled:=true;
  end;
end;

procedure TBisCallcDealFrame.TapiDisconnect(Sender: TObject);
begin
  FTapi.EmptyControlLinks;
  PhoneControlsFirstState;
end;

procedure TBisCallcDealFrame.TapiAfterRecord(Sender: TObject);
var
  Codec: TBisCodec;
  WmaFileName: String;
  WmaExtension: String;
  Provider: TBisProvider;
  OldCursor: TCursor;
  АSize: Integer;
begin
  if FTapi.RecordFromLine then begin

    if FileExists(FTapi.RecordFile) then begin
      АSize:=GetFileSizeEx(FTapi.RecordFile);
      if (АSize>FEmptyFileSize) and (ShowQuestion('Сохранить запись разговора?')=mrYes) then begin
        Update;
        OldCursor:=Screen.Cursor;
        try
          Screen.Cursor:=crHourGlass;
          WmaExtension:='.wma';
          Codec:=TBisCodec.Create(nil);
          try
            WmaFileName:=ChangeFileExt(FTapi.RecordFile,WmaExtension);
            Codec.WavToWma(FTapi.RecordFile,WmaFileName);
          finally
            Codec.Free;
          end;
          if FileExists(WmaFileName) and not VarIsNull(TaskId) then begin
            Provider:=TBisProvider.Create(Self);
            try
              Provider.ProviderName:='I_TASK_DOCUMENT';
              Provider.WithWaitCursor:=false;
              with Provider.Params do begin
                AddKey('TASK_DOCUMENT_ID');
                AddInvisible('TASK_ID').Value:=TaskId;
                AddInvisible('DOCUMENT_TYPE').Value:=dtAudio;
                AddInvisible('DOCUMENT').LoadFromFile(WmaFileName);
                AddInvisible('NAME').Value:=FormatEx('Звонок на %s %s',[FTapi.LabelEditCaption,FTapi.PhoneNumber]);
                AddInvisible('EXTENSION').Value:=WmaExtension;
                AddInvisible('DATE_DOCUMENT').Value:=Now;
                AddInvisible('DESCRIPTION').Value:='Запись разговора от '+DateTimeToStr(Now);
              end;
              Provider.Execute;
            finally
              Provider.Free;
            end;
            DeleteFile(WmaFileName);
          end;
        finally
          Screen.Cursor:=OldCursor;;
        end;
      end;
      DeleteFile(FTapi.RecordFile);
    end;
  end;
end;

procedure TBisCallcDealFrame.ChangePatternVars;
var
  List: TStringList;

  procedure Add(FieldName: String; Value: String);
  var
    Obj: TBisVariant;
    S: String;
  begin
    Obj:=TBisVariant.Create;
    Obj.Value:=Value;
    S:=FormatEx('<%s>',[FieldName]);
    List.AddObject(S,Obj);
  end;

  function GetValue(Value: Variant; FieldType: TFieldType): String;
  begin
    Result:=VarToStrDef(Value,'');
    if not VarIsNull(Value) then
      case FieldType of
        ftDate, ftDateTime, ftTimeStamp: Result:=FormatDateTime('dd mmm. yyyy г.',Value);
        ftFloat: Result:=FormatFloat('# ##0.00',Value);
      end;
  end;

  procedure SetCases;
  var
    P: TBisProvider;
    Field: TField;
    i: Integer;
    InSurName, InName, InPatronymic: String;
    OutSurName, OutName, OutPatronymic: String;
  begin
    P:=TBisProvider.Create(nil);
    try
      InSurName:=EditSurname.Text;
      InName:=EditName.Text;
      InPatronymic:=EditPatronymic.Text;
      
      P.ProviderName:='S_CASES';
      with P.FilterGroups.Add do begin
        Filters.Add('SURNAME_IP',fcEqual,InSurName);
        Filters.Add('NAME_IP',fcEqual,InName);
        Filters.Add('PATRONYMIC_IP',fcEqual,InPatronymic);
      end;
      P.Open;
      if P.Active and not P.IsEmpty then begin
        for i:=0 to P.Fields.Count-1 do begin
          Field:=P.Fields[i];
          Add(Field.FieldName,GetValue(Field.Value,Field.DataType));
        end;
      end else begin
        Add('SURNAME_IP',GetValue(InSurName,ftString));
        Add('NAME_IP',GetValue(InName,ftString));
        Add('PATRONYMIC_IP',GetValue(InPatronymic,ftString));

        GetGenitiveCase(InSurName,InName,InPatronymic,OutSurName,OutName,OutPatronymic);
        Add('SURNAME_RP',GetValue(OutSurName,ftString));
        Add('NAME_RP',GetValue(OutName,ftString));
        Add('PATRONYMIC_RP',GetValue(OutPatronymic,ftString));

        GetDativeCase(InSurName,InName,InPatronymic,OutSurName,OutName,OutPatronymic);
        Add('SURNAME_DP',GetValue(OutSurName,ftString));
        Add('NAME_DP',GetValue(OutName,ftString));
        Add('PATRONYMIC_DP',GetValue(OutPatronymic,ftString));

        GetAccusativeCase(InSurName,InName,InPatronymic,OutSurName,OutName,OutPatronymic);
        Add('SURNAME_VP',GetValue(OutSurName,ftString));
        Add('NAME_VP',GetValue(OutName,ftString));
        Add('PATRONYMIC_VP',GetValue(OutPatronymic,ftString));

        GetInstrumentalCase(InSurName,InName,InPatronymic,OutSurName,OutName,OutPatronymic);
        Add('SURNAME_TP',GetValue(OutSurName,ftString));
        Add('NAME_TP',GetValue(OutName,ftString));
        Add('PATRONYMIC_TP',GetValue(OutPatronymic,ftString));
        
        GetPrepositionalCase(InSurName,InName,InPatronymic,OutSurName,OutName,OutPatronymic);
        Add('SURNAME_PP',GetValue(OutSurName,ftString));
        Add('NAME_PP',GetValue(OutName,ftString));
        Add('PATRONYMIC_PP',GetValue(OutPatronymic,ftString));
      end;
    finally
      P.Free;
    end;
  end;

  procedure SearchAndReplace(RichEdit: TRichEdit; SearchText, ReplaceText: string);
  var
    StartPos, EndPos, Pos: integer;
  begin
     StartPos := 0;
     with RichEdit do
     begin
        EndPos := Length( Text );
        Lines.BeginUpdate;
        while FindText( SearchText, StartPos, EndPos, [stMatchCase,stWholeWord] )<> -1 do
        begin
           EndPos := Length( RichEdit.Text ) - StartPos;
           Pos := FindText( SearchText, StartPos, EndPos, [stMatchCase,stWholeWord] );
           Inc( StartPos, Length( SearchText ) );
           SelStart := Pos;
           SelLength := Length( SearchText );
           ClearSelection;
           SelText := ReplaceText;
        end;
        Lines.EndUpdate;
     end;
  end;

var
  i: Integer;
  Obj: TBisVariant;
  Param: TBisParam;
begin
  RichEditPattern.Visible:=false;
  List:=TStringList.Create;
  try
    SetCases;
    Add('FIRM_SMALL_NAME',GetValue(EditFirm.Text,ftString));
    Add('SURNAME_NAME_PATRONYMIC',GetValue(EditDebtor.Text,ftString));
    Add('ACCOUNT_NUM',GetValue(EditAccountNum.Text,ftString));
    Add('ARREAR_PERIOD',GetValue(EditArrearPeriod.Text,ftInteger));
    Add('CURRENCY_NAME',GetValue(EditCurrency.Text,ftString));
    Add('INITIAL_DEBT',GetValue(EditInitialDebt.Text,ftFloat));
    Add('AMOUNT_PAYMENT',GetValue(EditAmountPayment.Text,ftFloat));
    Add('CURRENT_DEBT',GetValue(EditCurrentDebt.Text,ftFloat));
    Add('GUARANTORS',GetValue(MemoGuarantors.Lines.Text,ftString));
    Add('DEBT_INFORMATION',GetValue(MemoDebtInformation.Lines.Text,ftString));
    Add('GUARANTORS',GetValue(MemoGuarantors.Lines.Text,ftString));
    Add('DEBTOR_NUM',GetValue(EditDebtorNum.Text,ftString));
    Add('DEBTOR_DATE',GetValue(StrToDate(EditDebtorDate.Text),ftDate));
    Add('CURRENT_DATE',GetValue(DateOf(Date),ftDate));

    for i:=0 to FDebtorParams.Count-1 do begin
      Param:=FDebtorParams.Items[i];
      Add(Param.ParamName,GetValue(Param.Value,Param.DataType));
    end;

    FPatternStream.Position:=0;
    RichEditPattern.Lines.LoadFromStream(FPatternStream);
    for i:=0 to List.Count-1 do begin
      Obj:=TBisVariant(List.Objects[i]);
      SearchAndReplace(RichEditPattern,List[i],Obj.Value);
    end;

  finally
    ClearStrings(List);
    List.Free;
    RichEditPattern.Visible:=true;
  end;
end;

type
  THackWinControl=class(TWinControl)
  end;

procedure TBisCallcDealFrame.ReadOnlyControls(AParent: TWinControl; AReadOnly: Boolean);
var
  i: Integer;
  AControl: TControl;
begin
  if Assigned(AParent) then begin
    for i:=0 to AParent.ControlCount-1 do begin
      AControl:=AParent.Controls[i];
      if AControl is TWinControl then begin
        THackWinControl(AControl).Color:=iff(AReadOnly,ColorControlReadOnly,clWindow);
        if AControl is TEdit then
          TEdit(AControl).ReadOnly:=AReadOnly;
        if AControl is TMemo then
          TMemo(AControl).ReadOnly:=AReadOnly;
      end;
    end;
  end;
end;

procedure TBisCallcDealFrame.SetDealNum(const Value: String);
begin
  inherited SetDealNum(Value);
  GroupBoxDeal.Caption:=iff(Trim(DealNum)<>'',FGroupBoxDealCaption+'- '+DealNum+' ',FGroupBoxDealCaption);
end;

procedure TBisCallcDealFrame.SetDebtorEdited(const Value: Boolean);
begin
  FDebtorEdited := Value;
  ReadOnlyControls(TabSheetDebtorGeneral,not Value);
  ReadOnlyControls(TabSheetDebtorAddresses,not Value);
  ReadOnlyControls(TabSheetDebtorJob,not Value);
  ReadOnlyControls(TabSheetDebtorPhones,not Value);
  ReadOnlyControls(TabSheetDebtorFounders,not Value);
end;

function TBisCallcDealFrame.CheckControls: Boolean;
const
  SNeedControlValue='Необходимо ввести значение в поле (%s).';

  function CheckDebtorControls: Boolean;
  begin
    Result:=true;
    if Trim(EditSurname.Text)='' then begin
      ShowError(Format(SNeedControlValue,[LabelSurname.Caption]));
      PageControl.ActivePage:=TabSheetDebtor;
      PageControlDebtor.ActivePage:=TabSheetDebtorGeneral;
      EditSurname.SetFocus;
      Result:=false;
      exit;
    end;
    if Trim(EditName.Text)='' then begin
      ShowError(Format(SNeedControlValue,[LabelName.Caption]));
      PageControl.ActivePage:=TabSheetDebtor;
      PageControlDebtor.ActivePage:=TabSheetDebtorGeneral;
      EditName.SetFocus;
      Result:=false;
      exit;
    end;
    if Trim(EditPatronymic.Text)='' then begin
      ShowError(Format(SNeedControlValue,[LabelPatronymic.Caption]));
      PageControl.ActivePage:=TabSheetDebtor;
      PageControlDebtor.ActivePage:=TabSheetDebtorGeneral;
      EditPatronymic.SetFocus;
      Result:=false;
      exit;
    end;
    if TEditDate(DateTimePickerDateBirth).Date=NullDate then begin
      ShowError(Format(SNeedControlValue,[LabelDateBirth.Caption]));
      PageControl.ActivePage:=TabSheetDebtor;
      PageControlDebtor.ActivePage:=TabSheetDebtorGeneral;
      TEditDate(DateTimePickerDateBirth).SetFocus;
      Result:=false;
      exit;
    end;
    if Trim(EditPlaceBirth.Text)='' then begin
      ShowError(Format(SNeedControlValue,[LabelPlaceBirth.Caption]));
      PageControl.ActivePage:=TabSheetDebtor;
      PageControlDebtor.ActivePage:=TabSheetDebtorGeneral;
      EditPlaceBirth.SetFocus;
      Result:=false;
      exit;
    end;
    if Trim(MemoPassport.Lines.Text)='' then begin
      ShowError(Format(SNeedControlValue,[LabelPassport.Caption]));
      PageControl.ActivePage:=TabSheetDebtor;
      PageControlDebtor.ActivePage:=TabSheetDebtorGeneral;
      MemoPassport.SetFocus;
      Result:=false;
      exit;
    end;
  end;

begin
  Result:=inherited CheckControls;
  if FDebtorEdited then
    Result:=Result and CheckDebtorControls;
end;

procedure TBisCallcDealFrame.SaveChanges;

  procedure SaveDebtor;
  var
    P: TBisProvider;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='U_DEBTOR';
      P.Params.CopyFrom(FDebtorParams);
      P.Execute;
    finally
      P.Free;
    end;
  end;

begin
  inherited SaveChanges;
  if FDebtorEdited then
    SaveDebtor;
end;

procedure TBisCallcDealFrame.GenerateJournal;
var
  Document: IHTMLDocument2;
  P: TBisProvider;
  Str: TStringList;
  S: String;
  Style: String;
begin
  Document:=WebBrowser.Document as IHtmlDocument2;
  if Assigned(Document) then begin
    P:=TBisProvider.Create(nil);
    Str:=TStringList.Create;
    try
      Document.clear;
      Document.title:=TabSheetJournal.Caption;
      Document.body.style.fontFamily:=Self.Font.Name;

      P.ProviderName:='S_TASKS';
      with P.FieldNames do begin
        AddInvisible('DATE_END');
        AddInvisible('PERFORMER_USER_NAME');
        AddInvisible('ACTION_NAME');
        AddInvisible('RESULT_NAME');
        AddInvisible('DESCRIPTION');
      end;
      with P.FilterGroups.Add do begin
        Filters.Add('DEAL_ID',fcEqual,DealId);
        Filters.Add('RESULT_ID',fcIsNotNull,NULL);
      end;
      P.Orders.Add('DATE_END');
      P.Open;

      if P.Active then begin

        Style:=Format('font-size:%spx; border:silver 1px solid; border-width:1px',[IntToStr(Abs(Self.Font.Height))]);
        Str.Add('<TABLE width=100% cellSpacing=0 cellPadding=2 style="'+Style+'">');
        Str.Add('<TR align=center valign=center>');
        Str.Add('<TD width=15% style="border-right:silver 1px solid;"><B>Дата выполнения</B></TD>');
        Str.Add('<TD width=15% style="border-right:silver 1px solid;"><B>Кто выполнил</B></TD>');
        Str.Add('<TD width=15% style="border-right:silver 1px solid;"><B>Действие</B></TD>');
        Str.Add('<TD width=15% style="border-right:silver 1px solid;"><B>Результат</B></TD>');
        Str.Add('<TD width=40%><B>Комментарий</B></TD>');
        Str.Add('</TR>');
        if not P.IsEmpty then begin
          P.First;
          while not P.Eof do begin
            Str.Add('<TR valign=top>');
            Str.Add('<TD align=center style="border-right:silver 1px solid;border-top:silver 1px solid;">'+P.FieldByName('DATE_END').AsString+'</TD>');
            Str.Add('<TD style="border-right:silver 1px solid;border-top:silver 1px solid;">'+P.FieldByName('PERFORMER_USER_NAME').AsString+'</TD>');
            Str.Add('<TD style="border-right:silver 1px solid;border-top:silver 1px solid;">'+P.FieldByName('ACTION_NAME').AsString+'</TD>');
            Str.Add('<TD style="border-right:silver 1px solid;border-top:silver 1px solid;">'+P.FieldByName('RESULT_NAME').AsString+'</TD>');
            S:=P.FieldByName('DESCRIPTION').AsString;
            Str.Add('<TD style="border-top:silver 1px solid;">'+iff(Trim(S)<>'',S,'&nbsp')+'</TD>');
            Str.Add('</TR>');
            P.Next;
          end;
        end;
        Str.Add('</TABLE>');

        Document.body.innerHTML:=Str.Text;
      end;
    finally
      Str.Free;
      P.Free;
    end;
  end;
end;

end.
