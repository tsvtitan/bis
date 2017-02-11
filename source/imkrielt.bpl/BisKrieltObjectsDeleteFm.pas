unit BisKrieltObjectsDeleteFm;
                                                                                                         
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls,
  BisFm,
  BisControls;

type
  TBisKrieltObjectsDeleteForm = class(TBisForm)
    LabelPublishing: TLabel;
    EditPublishing: TEdit;
    ButtonPublishing: TButton;
    LabelDateBeginFrom: TLabel;
    DateTimePickerBeginFrom: TDateTimePicker;
    LabelDateBeginTo: TLabel;
    DateTimePickerBeginTo: TDateTimePicker;
    ButtonIssue: TButton;
    PanelBottom: TPanel;
    ButtonCancel: TButton;
    ButtonDelete: TButton;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    procedure ButtonPublishingClick(Sender: TObject);
    procedure ButtonIssueClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonAccountClick(Sender: TObject);
  private
    FPublishingId: Variant;
    FIssueId: Variant;
    FAccountId: Variant;
    FEditDateFrom: TEditDate;
    FEditDateTo: TEditDate;
    function CheckParams: Boolean;
    function Delete(var Count: Integer): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TBisKrieltObjectsDeleteFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltObjectsDeleteForm: TBisKrieltObjectsDeleteForm;

implementation

{$R *.dfm}

uses DateUtils, DB,
     BisDataSet, BisFilterGroups, BisDialogs, BisUtils, BisProvider,
     BisDataFm, BisCore, BisIfaces,
     BisKrieltConsts, BisKrieltDataPublishingFm, BisKrieltDataIssuesFm;

{ TBisKrieltObjectsDeleteFormIface }

constructor TBisKrieltObjectsDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltObjectsDeleteForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
  ShowType:=stMdiChild;

end;

{ TBisKrieltObjectsDeleteForm }

constructor TBisKrieltObjectsDeleteForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;

  FEditDateFrom:=ReplaceDateTimePickerToEditDate(DateTimePickerBeginFrom);
  FEditDateTo:=ReplaceDateTimePickerToEditDate(DateTimePickerBeginTo);

  FPublishingId:=Null;
  FIssueId:=Null;
end;

destructor TBisKrieltObjectsDeleteForm.Destroy;
begin
  FEditDateTo.Free;
  FEditDateFrom.Free;
  inherited Destroy;
end;

procedure TBisKrieltObjectsDeleteForm.ButtonIssueClick(Sender: TObject);
var
  AIface: TBisKrieltDataIssuesFormIface;
  DS: TBisDataSet;
begin
  AIface:=TBisKrieltDataIssuesFormIface.Create(nil);
  DS:=TBisDataSet.Create(nil);
  try
    AIface.LocateFields:='ISSUE_ID';
    AIface.LocateValues:=FIssueId;
    AIface.FilterGroups.Add.Filters.Add('PUBLISHING_ID',fcEqual,FPublishingId);
    if AIface.SelectInto(DS) then begin
      FIssueId:=DS.FieldByName('ISSUE_ID').Value;
      FEditDateFrom.Date:=DateOf(DS.FieldByName('DATE_BEGIN').AsDateTime);
      FEditDateTo.Date:=DateOf(DS.FieldByName('DATE_END').AsDateTime);
    end;
  finally
    DS.Free;
    AIface.Free;
  end;
end;

procedure TBisKrieltObjectsDeleteForm.ButtonPublishingClick(Sender: TObject);
var
  AIface: TBisKrieltDataPublishingFormIface;
  DS: TBisDataSet;
begin
  AIface:=TBisKrieltDataPublishingFormIface.Create(nil);
  DS:=TBisDataSet.Create(nil);
  try
    AIface.LocateFields:='PUBLISHING_ID';
    AIface.LocateValues:=FPublishingId;
    if AIface.SelectInto(DS) then begin
      FPublishingId:=DS.FieldByName('PUBLISHING_ID').Value;
      EditPublishing.Text:=DS.FieldByName('NAME').AsString;
    end;
  finally
    DS.Free;
    AIface.Free;
  end;
end;

function TBisKrieltObjectsDeleteForm.CheckParams: Boolean;
begin
  Result:=true;

  if VarIsNull(FPublishingId) then begin
    ShowError('�������� �������.');
    EditPublishing.SetFocus;
    Result:=false;
  end;

end;

function TBisKrieltObjectsDeleteForm.Delete(var Count: Integer): Boolean;
var
  P: TBisProvider;
  DEnd: Variant;
begin
  Result:=false;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='DELETE_OBJECTS';
    DEnd:=FEditDateTo.Date2;
    if not VarIsNull(DEnd) then
      DEnd:=IncDay(DEnd,1);
    with P.Params do begin
      AddInvisible('PID').Value:=FPublishingId;
      AddInvisible('AID').Value:=FAccountId;
      AddInvisible('DBEGIN').Value:=FEditDateFrom.Date2;
      AddInvisible('DEND').Value:=DEnd;
    //  AddInvisible('OBJECT_COUNT',ptInputOutput).Value:=Count;
    end;
    P.Execute;
    if P.Success then begin
//      Count:=P.ParamByName('OBJECT_COUNT').AsInteger;
      Result:=true;
    end;
  finally
    P.Free;
  end;
end;

procedure TBisKrieltObjectsDeleteForm.ButtonAccountClick(Sender: TObject);
var
  AClass: TBisIfaceClass;
  AIface: TBisDataFormIface;
  DS: TBisDataSet;
begin
  AClass:=Core.FindIfaceClass(SIfaceClassDataAccountsFormIface);
  if Assigned(AClass) and IsClassParent(AClass,TBisDataFormIface) then begin
    AIface:=TBisDataFormIfaceClass(AClass).Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ACCOUNT_ID';
      AIface.LocateValues:=FAccountId;
      if AIface.SelectInto(DS) then begin
        FAccountId:=DS.FieldByName('ACCOUNT_ID').Value;
        EditAccount.Text:=DS.FieldByName('USER_NAME').AsString;
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisKrieltObjectsDeleteForm.ButtonCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TBisKrieltObjectsDeleteForm.ButtonDeleteClick(Sender: TObject);
var
  Count: Integer;
begin
  Count:=0;
  if CheckParams then
    if Delete(Count) then
        ShowInfo('������� ������� �������.');
end;


end.