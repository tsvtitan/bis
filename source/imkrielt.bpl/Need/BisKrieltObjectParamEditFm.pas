unit BisKrieltObjectParamEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList,
  BisDataEditFm, BisControls, BisParam;

type
  TBisKrieltObjectParamEditForm = class(TBisDataEditForm)
    LabelParam: TLabel;
    EditParam: TEdit;
    ButtonParam: TButton;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelValue: TLabel;
    EditValue: TEdit;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
  end;

  TBisKrieltObjectParamEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltObjectParamInsertFormIface=class(TBisKrieltObjectParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltObjectParamUpdateFormIface=class(TBisKrieltObjectParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltObjectParamDeleteFormIface=class(TBisKrieltObjectParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltObjectParamEditForm: TBisKrieltObjectParamEditForm;

implementation

uses Dateutils,
     BisKrieltDataParamsFm,
     BisCore, BisFilterGroups, BisKrieltConsts;

{$R *.dfm}

{ TBisKrieltObjectParamEditFormIface }

constructor TBisKrieltObjectParamEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltObjectParamEditForm;
  with Params do begin
    AddKey('OBJECT_PARAM_ID').Older('OLD_OBJECT_PARAM_ID');
    AddInvisible('OBJECT_ID');
    AddInvisible('EXPORT');
    AddEditDataSelect('PARAM_ID','EditParam','LabelParam','ButtonParam',
                      TBisKrieltDataParamsFormIface,'PARAM_NAME',true,false,'','NAME');
    AddEdit('VALUE','EditValue','LabelValue',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassDataAccountsFormIface,'USER_NAME',true);
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes([emFilter]);
  end;
end;

{ TBisKrieltObjectParamInsertFormIface }

constructor TBisKrieltObjectParamInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_OBJECT_PARAM';
end;

{ TBisKrieltObjectParamUpdateFormIface }

constructor TBisKrieltObjectParamUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_OBJECT_PARAM';
end;

{ TBisKrieltObjectParamDeleteFormIface }

constructor TBisKrieltObjectParamDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_OBJECT_PARAM';
end;


{ TBisKrieltObjectParamEditForm }

constructor TBisKrieltObjectParamEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisKrieltObjectParamEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      with Find('ACCOUNT_ID') do begin
        Enabled:=false;
        SetNewValue(Core.AccountId);
      end;
      Find('WHO_PLACED_NAME').SetNewValue(Core.AccountUserName);
      with Find('DATE_CREATE') do begin
        Enabled:=false;
        SetNewValue(Now);
      end;
    end;
    UpdateButtonState;
  end;
end;


end.
