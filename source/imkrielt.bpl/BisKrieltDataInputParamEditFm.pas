unit BisKrieltDataInputParamEditFm;
                                                                                                   
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisControls;

type
  TBisKrieltDataInputParamEditForm = class(TBisDataEditForm)
    LabelParam: TLabel;
    EditParam: TEdit;
    ButtonParam: TButton;
    LabelType: TLabel;
    EditType: TEdit;
    ButtonType: TButton;
    LabelOperation: TLabel;
    EditOperation: TEdit;
    ButtonOperation: TButton;
    CheckBoxRequired: TCheckBox;
    LabelView: TLabel;
    EditView: TEdit;
    ButtonView: TButton;
    LabelElementType: TLabel;
    ComboBoxElementType: TComboBox;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelPosition: TLabel;
    EditPosition: TEdit;
    ButtonElementType: TButton;
    procedure ButtonElementTypeClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure BeforeShow; override;
  end;

  TBisKrieltDataInputParamEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataInputParamFilterFormIface=class(TBisKrieltDataInputParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataInputParamInsertFormIface=class(TBisKrieltDataInputParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataInputParamUpdateFormIface=class(TBisKrieltDataInputParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataInputParamDeleteFormIface=class(TBisKrieltDataInputParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataInputParamEditForm: TBisKrieltDataInputParamEditForm;

implementation

uses BisKrieltDataViewsFm, BisKrieltDataTypesFm, BisKrieltDataOperationsFm, BisKrieltDataParamsFm, BisParam;

{$R *.dfm}

{ TBisKrieltDataInputParamEditFormIface }

constructor TBisKrieltDataInputParamEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataInputParamEditForm;
  with Params do begin
    AddKey('INPUT_PARAM_ID').Older('OLD_INPUT_PARAM_ID');
    AddEditDataSelect('VIEW_ID','EditView','LabelView','ButtonView',
                      TBisKrieltDataViewsFormIface,'VIEW_NAME',true,false,'','NAME');
    AddEditDataSelect('TYPE_ID','EditType','LabelType','ButtonType',
                      TBisKrieltDataTypesFormIface,'TYPE_NAME',true,false,'','NAME');
    AddEditDataSelect('OPERATION_ID','EditOperation','LabelOperation','ButtonOperation',
                      TBisKrieltDataOperationsFormIface,'OPERATION_NAME',true,false,'','NAME');
    AddEditDataSelect('PARAM_ID','EditParam','LabelParam','ButtonParam',
                      TBisKrieltDataParamsFormIface,'PARAM_NAME',true,false,'','NAME');
    AddComboBoxIndex('ELEMENT_TYPE','ComboBoxElementType','LabelElementType');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
    AddEditInteger('POSITION','EditPosition','LabelPosition');
    AddCheckBox('REQUIRED','CheckBoxRequired').ExcludeModes([emFilter]);
  end;
end;

{ TBisKrieltDataInputParamFilterFormIface }

constructor TBisKrieltDataInputParamFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

{ TBisKrieltDataInputParamInsertFormIface }

constructor TBisKrieltDataInputParamInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_INPUT_PARAM';
end;

{ TBisKrieltDataInputParamUpdateFormIface }

constructor TBisKrieltDataInputParamUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_INPUT_PARAM';
end;

{ TBisKrieltDataInputParamDeleteFormIface }

constructor TBisKrieltDataInputParamDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_INPUT_PARAM';
end;


procedure TBisKrieltDataInputParamEditForm.BeforeShow;
begin
  inherited BeforeShow;

  ButtonElementType.Enabled:=Mode<>emDelete;

  UpdateButtonState;
end;

procedure TBisKrieltDataInputParamEditForm.ButtonElementTypeClick(Sender: TObject);
begin
  Provider.ParamByName('ELEMENT_TYPE').Value:=Null;
end;

end.