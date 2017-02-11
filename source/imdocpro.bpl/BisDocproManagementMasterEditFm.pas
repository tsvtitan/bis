unit BisDocproManagementMasterEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisControls;

type
  TBisDocproManagementMasterEditForm = class(TBisDataEditForm)
    LabelDateIssue: TLabel;
    DateTimePickerDateIssue: TDateTimePicker;
    DateTimePickerTimeIssue: TDateTimePicker;
    GroupBoxDoc: TGroupBox;
    LabelName: TLabel;
    LabelNum: TLabel;
    LabelDateDoc: TLabel;
    EditName: TEdit;
    EditNum: TEdit;
    DateTimePickerDateDoc: TDateTimePicker;
    LabelWhoFirm: TLabel;
    EditWhoFirm: TEdit;
    LabelWhoAccount: TLabel;
    EditWhoAccount: TEdit;
    GroupBoxDescription: TGroupBox;
    MemoDescription: TMemo;
    CheckBoxProcess: TCheckBox;
    LabelDescription: TLabel;
  private
    { Private declarations }
  public
    procedure Execute; override;
  end;

  TBisDocproManagementMasterEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproManagementMasterUpdateFormIface=class(TBisDocproManagementMasterEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproManagementMasterEditForm: TBisDocproManagementMasterEditForm;

implementation

{$R *.dfm}

uses BisParam, BisCore;

{ TBisDocproManagementMasterEditFormIface }

constructor TBisDocproManagementMasterEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproManagementMasterEditForm;
  OnlyOneForm:=true;
  with Params do begin
    AddKey('MOTION_ID').Older('OLD_MOTION_ID');
    AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
    AddEditDateTime('DATE_ISSUE','DateTimePickerDateIssue','DateTimePickerTimeIssue','LabelDateIssue',true).ExcludeModes(AllParamEditModes);
    AddEdit('WHO_FIRM','EditWhoFirm','LabelWhoFirm').ExcludeModes(AllParamEditModes);
    AddEdit('WHO_ACCOUNT','EditWhoAccount','LabelWhoAccount').ExcludeModes(AllParamEditModes);
    AddEdit('DOC_NUM','EditNum','LabelNum',true).ExcludeModes(AllParamEditModes);
    AddEditDate('DATE_DOC','DateTimePickerDateDoc','LabelDateDoc',true).ExcludeModes(AllParamEditModes);
    AddEdit('DOC_NAME','EditName','LabelName',true).ExcludeModes(AllParamEditModes);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddCheckBox('STATUS','CheckBoxProcess');
  end;
end;

{ TBisDocproManagementMasterUpdateFormIface }

constructor TBisDocproManagementMasterUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_MANAGEMENT';
  Caption:='Изменить движение'
end;

{ TBisDocproManagementMasterEditForm }

procedure TBisDocproManagementMasterEditForm.Execute;
begin
  inherited Execute;
  if CheckBoxProcess.Checked then
    Provider.DeleteFromParent;
end;

end.
