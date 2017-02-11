unit BisDesignDataLockEditFm;

interface

uses                                                                                                          
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst, ComCtrls, Menus, ActnPopup, ExtDlgs,
  BisDataEditFm, BisParam, BisControls, ImgList;

type
  TBisDesignDataLockEditForm = class(TBisDataEditForm)
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelMethod: TLabel;
    LabelObject: TLabel;
    EditObject: TEdit;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    DateTimePickerBeginTime: TDateTimePicker;
    LabelApplication: TLabel;
    EditApplication: TEdit;
    ButtonApplication: TButton;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
    DateTimePickerEndTime: TDateTimePicker;
    LabelIpList: TLabel;
    MemoIpList: TMemo;
    ComboBoxMethod: TComboBox;
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
  end;

  TBisDesignDataLockEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataLockInsertFormIface=class(TBisDesignDataLockEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataLockUpdateFormIface=class(TBisDesignDataLockEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataLockDeleteFormIface=class(TBisDesignDataLockEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataLockEditForm: TBisDesignDataLockEditForm;

implementation

uses DateUtils, DB,
     BisDesignDataApplicationsFm, BisDesignDataAccountsFm, BisDesignDataRolesAndAccountsFm,
     BisFilterGroups, BisProvider, BisUtils, BisCore;

{$R *.dfm}

{ TBisDesignDataLockEditFormIface }

constructor TBisDesignDataLockEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataLockEditForm;
  with Params do begin
    AddKey('LOCK_ID').Older('OLD_LOCK_ID');
    AddEditDataSelect('APPLICATION_ID','EditApplication','LabelApplication','ButtonApplication',
                      TBisDesignDataApplicationsFormIface,'APPLICATION_NAME',true,false,'','NAME');
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      TBisDesignDataRolesAndAccountsFormIface,'USER_NAME',false,false);
    AddComboBoxTextIndex('METHOD','ComboBoxMethod','LabelMethod',false);
    AddEdit('OBJECT','EditObject','LabelObject',false);
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin',true).ExcludeModes([emFilter]);
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd',false).ExcludeModes([emFilter]);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddMemo('IP_LIST','MemoIpList','LabelIpList');
  end;
end;

{ TBisDesignDataLockInsertFormIface }

constructor TBisDesignDataLockInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_LOCK';
end;

{ TBisDesignDataLockUpdateFormIface }

constructor TBisDesignDataLockUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_LOCK';
end;

{ TBisDesignDataLockDeleteFormIface }

constructor TBisDesignDataLockDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_LOCK';
end;

{ TBisDesignDataLockEditForm }

constructor TBisDesignDataLockEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisDesignDataLockEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      Find('DATE_BEGIN').SetNewValue(Core.ServerDate);
    end;
  end;
  UpdateButtonState;
end;


end.
