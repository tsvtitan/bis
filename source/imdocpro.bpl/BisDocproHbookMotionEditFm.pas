unit BisDocproHbookMotionEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisControls;

type
  TBisDocproHbookMotionEditForm = class(TBisDataEditForm)
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelDoc: TLabel;
    EditDoc: TEdit;
    ButtonDoc: TButton;
    LabelPosition: TLabel;
    EditPosition: TEdit;
    ButtonPosition: TButton;
    LabelDateIssue: TLabel;
    DateTimePickerDateIssue: TDateTimePicker;
    DateTimePickerTimeIssue: TDateTimePicker;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelDateProcess: TLabel;
    DateTimePickerDateProcess: TDateTimePicker;
    DateTimePickerTimeProcess: TDateTimePicker;
  private
    { Private declarations }
  public
    procedure BeforeShow; override;
  end;

  TBisDocproHbookMotionEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookMotionInsertFormIface=class(TBisDocproHbookMotionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookMotionUpdateFormIface=class(TBisDocproHbookMotionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookMotionDeleteFormIface=class(TBisDocproHbookMotionEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproHbookMotionEditForm: TBisDocproHbookMotionEditForm;

implementation

uses BisFilterGroups, BisParam,
     BisDocproConsts, BisDocproHbookPositionsFm, BisDocproHbookDocsFm;

{$R *.dfm}

{ TBisDocproHbookMotionEditFormIface }

constructor TBisDocproHbookMotionEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproHbookMotionEditForm;
  with Params do begin
    AddKey('MOTION_ID').Older('OLD_MOTION_ID');
    AddEditDataSelect('POSITION_ID','EditPosition','LabelPosition','ButtonPosition',
                      TBisDocproHbookPositionsFormIface,'POSITION_PRIORITY',true,false,'','PRIORITY');
    AddEditDataSelect('DOC_ID','EditDoc','LabelDoc','ButtonDoc',
                      TBisDocproHbookDocsFormIface,'DOC_FULL_NAME',true,false,'','NUM;DATE_DOC;NAME');
    AddEditDateTime('DATE_ISSUE','DateTimePickerDateIssue','DateTimePickerTimeIssue','LabelDateIssue',true).FilterCondition:=fcEqualGreater;
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassHbookAccountsFormIface,'USER_NAME',false,false,'','');
    AddEditDateTime('DATE_PROCESS','DateTimePickerDateProcess','DateTimePickerTimeProcess','LabelDateProcess').FilterCondition:=fcEqualGreater;
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
  end;
end;

{ TBisDocproHbookMotionInsertFormIface }

constructor TBisDocproHbookMotionInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_MOTION';
end;

{ TBisDocproHbookMotionUpdateFormIface }

constructor TBisDocproHbookMotionUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_MOTION';
end;

{ TBisDocproHbookMotionDeleteFormIface }

constructor TBisDocproHbookMotionDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_MOTION';
end;

{ TBisDocproHbookMotionEditForm }

procedure TBisDocproHbookMotionEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emFilter] then begin
    EditPosition.ReadOnly:=false;
    EditPosition.Color:=clWindow;
    EditDoc.ReadOnly:=false;
    EditDoc.Color:=clWindow;
  end;
end;

end.
