unit BisKrieltPresentationEditFm;
                                                                                                           
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, Contnrs,
  BisFm, BisDataEditFm, BisParam, BisControls, ImgList;

type

  TBisKrieltPresentationEditForm = class(TBisDataEditForm)
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    DateTimePickerEnd: TDateTimePicker;
    LabelDateEnd: TLabel;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    DateTimePickerTimeBegin: TDateTimePicker;
    DateTimePickerTimeEnd: TDateTimePicker;
    ScrollBox: TScrollBox;
    LabelPhone: TLabel;
    EditPhone: TEdit;
    ButtonIssue: TButton;
    procedure ButtonIssueClick(Sender: TObject);
  private
    FPresentationId: String;
    FTableName: String;
    FControls: TObjectList;
    procedure CreateControls;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;

    property PresentationId: String read FPresentationId write FPresentationId;
    property TableName: String read FTableName write FTableName;
  end;

  TBisKrieltPresentationEditFormIface=class(TBisDataEditFormIface)
  private
    FPresentationId: String;
    FTableName: String;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property PresentationId: String read FPresentationId write FPresentationId;
    property TableName: String read FTableName write FTableName;
  end;

  TBisKrieltPresentationFilterFormIface=class(TBisKrieltPresentationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltPresentationViewingFormIface=class(TBisKrieltPresentationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltPresentationEditForm: TBisKrieltPresentationEditForm;

implementation

{$R *.dfm}

uses DateUtils,
     BisFilterGroups, BisConsts, BisProvider, BisUtils, BisKrieltConsts,
     BisKrieltDataIssuesFm;

{ TBisKrieltPresentationEditFormIface }

constructor TBisKrieltPresentationEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltPresentationEditForm;
  with Params do begin
    Unique:=false;
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerTimeBegin','LabelDateBegin').FilterCondition:=fcEqualGreater;
    with AddEditDateTime('DATE_BEGIN','DateTimePickerEnd','DateTimePickerTimeEnd','LabelDateEnd') do begin
      FilterCondition:=fcEqualLess;
      ExcludeModes([emView]);
    end;
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassDataAccountsFormIface,'USER_NAME');
    AddEdit('PHONE','EditPhone','LabelPhone');
  end;
end;

function TBisKrieltPresentationEditFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) and (Result is TBisKrieltPresentationEditForm) then begin
    TBisKrieltPresentationEditForm(Result).PresentationId:=FPresentationId;
    TBisKrieltPresentationEditForm(Result).TableName:=FTableName;
    TBisKrieltPresentationEditForm(Result).CreateControls;
  end;
end;

{ TBisKrieltPresentationFilterFormIface }

constructor TBisKrieltPresentationFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltPresentationViewingFormIface }

constructor TBisKrieltPresentationViewingFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltPresentationEditForm }

constructor TBisKrieltPresentationEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FControls:=TObjectList.Create;
  DateTimePickerTimeBegin.Time:=TimeOf(NullDate);
  DateTimePickerTimeEnd.Time:=TimeOf(StrToTime('23:59:59'));
end;

destructor TBisKrieltPresentationEditForm.Destroy;
begin
  FControls.Free;
  inherited Destroy;
end;

procedure TBisKrieltPresentationEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emFilter] then begin
    EditAccount.ReadOnly:=false;
    EditAccount.Color:=clWindow;
  end;
end;

procedure TBisKrieltPresentationEditForm.CreateControls;
var
  P: TBisProvider;
  S: String;
  Field: TField;
  i: Integer;
  AFieldName: String;
  ALabel: TLabel;
  AEdit: TEdit;
  ATop: Integer;
  AWidth: Integer;
  ALeft: Integer;
  Dh: Integer;
  Dw: Integer;
begin
  FControls.Clear;
  if Trim(FPresentationId)<>'' then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:=FTableName;
      P.FetchCount:=0;
      P.Open;
      if P.Active then begin
        ATop:=0;
        AWidth:=200;
        ALeft:=EditPhone.Left+EditPhone.Width-AWidth-ScrollBox.Left;
        Dh:=5;
        Dw:=5;
        for i:=0 to P.FieldCount-1 do begin
          Field:=P.Fields[i];
          AFieldName:=Field.FieldName;
          S:=Copy(AFieldName,Length(AFieldName)-2,3);
          if S<>'_ID' then begin
            if not AnsiSameText(AFieldName,'PUBLISHING_NAME') and
               not AnsiSameText(AFieldName,'VIEW_NAME') and
               not AnsiSameText(AFieldName,'TYPE_NAME') and
               not AnsiSameText(AFieldName,'OPERATION_NAME') and
               not AnsiSameText(AFieldName,'DATE_BEGIN') and
               not AnsiSameText(AFieldName,'USER_NAME') and
               not AnsiSameText(AFieldName,'PHONE') then begin

               

              AEdit:=TEdit.Create(Self);
              AEdit.Parent:=ScrollBox;
              AEdit.Top:=ATop;
              AEdit.Width:=AWidth;
              AEdit.Left:=ALeft;
              AEdit.Anchors:=AEdit.Anchors+[akRight];
              AEdit.Name:='Edit'+GetUniqueID;
              AEdit.Text:='';
              FControls.Add(AEdit);

              ALabel:=TLabel.Create(Self);
              ALabel.Caption:=AFieldName+':';
              ALabel.Parent:=ScrollBox;
              ALabel.Top:=AEdit.Top+AEdit.Height div 2 - ALabel.Height div 2;
              ALabel.Left:=ALeft-Dw-ALabel.Width;
              ALabel.Name:='Label'+GetUniqueID;
              FControls.Add(ALabel);

              Provider.Params.AddEdit(AFieldName,AEdit.Name,ALabel.Name);

              ATop:=ATop+AEdit.Height+Dh;
            end;
          end;
        end;
      end;
    finally
      P.Free;
    end;
  end;
end;


procedure TBisKrieltPresentationEditForm.ButtonIssueClick(Sender: TObject);
var
  Iface: TBisKrieltDataIssuesFormIface;
  P: TBisProvider;
begin
  Iface:=TBisKrieltDataIssuesFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    if Iface.SelectInto(P) then begin
      with Provider.Params do begin
        ParamByName('DATE_BEGIN').Value:=P.FieldByName('DATE_BEGIN').Value;
      end;
    end;
  finally
    P.Free;
    Iface.Free;
  end;
end;


end.
