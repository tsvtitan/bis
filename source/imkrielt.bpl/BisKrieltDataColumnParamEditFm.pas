unit BisKrieltDataColumnParamEditFm;
                                                                                                
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisControls, BisParam;

type
  TBisKrieltDataColumnParamEditForm = class(TBisDataEditForm)
    LabelParam: TLabel;
    EditParam: TEdit;
    ButtonParam: TButton;
    LabelColumn: TLabel;
    EditColumn: TEdit;
    ButtonColumn: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelStringBefore: TLabel;
    EditStringBefore: TEdit;
    LabelStringAfter: TLabel;
    EditStringAfter: TEdit;
    CheckBoxUseStringBefore: TCheckBox;
    CheckBoxUseStringAfter: TCheckBox;
    LabelElementType: TLabel;
    LabelPosition: TLabel;
    ComboBoxElementType: TComboBox;
    ComboBoxPosition: TComboBox;
    CheckBoxGeneral: TCheckBox;
    LabelPlacing: TLabel;
    EditPlacing: TEdit;
    ButtonElementType: TButton;
    procedure ButtonElementTypeClick(Sender: TObject);
  private
    { Private declarations }
  public
    function CanShow: Boolean; override;
    procedure BeforeShow; override;
  end;

  TBisKrieltDataColumnParamEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataColumnParamFilterFormIface=class(TBisKrieltDataColumnParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataColumnParamInsertFormIface=class(TBisKrieltDataColumnParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataColumnParamUpdateFormIface=class(TBisKrieltDataColumnParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataColumnParamDeleteFormIface=class(TBisKrieltDataColumnParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataColumnParamEditForm: TBisKrieltDataColumnParamEditForm;

implementation

uses BisKrieltDataColumnsFm, BisKrieltDataParamsFm, BisParamEditDataSelect;

{$R *.dfm}

{ TBisKrieltDataColumnParamEditFormIface }

constructor TBisKrieltDataColumnParamEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataColumnParamEditForm;
  with Params do begin
    AddEditDataSelect('COLUMN_ID','EditColumn','LabelColumn','ButtonColumn',
                      TBisKrieltDataColumnsFormIface,'COLUMN_NAME',true,true,'','NAME').Older('OLD_COLUMN_ID');
    AddEditDataSelect('PARAM_ID','EditParam','LabelParam','ButtonParam',
                      TBisKrieltDataParamsFormIface,'PARAM_NAME',true,true,'','NAME').Older('OLD_PARAM_ID');
    AddEdit('STRING_BEFORE','EditStringBefore','LabelStringBefore');
    AddCheckBox('USE_STRING_BEFORE','CheckBoxUseStringBefore').ExcludeModes([emFilter]);
    AddEdit('STRING_AFTER','EditStringAfter','LabelStringAfter');
    AddCheckBox('USE_STRING_AFTER','CheckBoxUseStringAfter').ExcludeModes([emFilter]);
    AddComboBoxIndex('ELEMENT_TYPE','ComboBoxElementType','LabelElementType');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
    AddCheckBox('GENERAL','CheckBoxGeneral').ExcludeModes([emFilter]);
    AddComboBoxIndex('POSITION','ComboBoxPosition','LabelPosition');
    AddEdit('PLACING','EditPlacing','LabelPlacing');
  end;
end;

{ TBisKrieltDataColumnParamFilterFormIface }

constructor TBisKrieltDataColumnParamFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataColumnParamInsertFormIface }

constructor TBisKrieltDataColumnParamInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_COLUMN_PARAM';
end;

{ TBisKrieltDataColumnParamUpdateFormIface }

constructor TBisKrieltDataColumnParamUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_COLUMN_PARAM';
end;

{ TBisKrieltDataColumnParamDeleteFormIface }

constructor TBisKrieltDataColumnParamDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_COLUMN_PARAM';
end;


{ TBisKrieltDataColumnParamEditForm }

procedure TBisKrieltDataColumnParamEditForm.BeforeShow;
begin
  inherited BeforeShow;

  ButtonElementType.Enabled:=Mode<>emDelete;

  UpdateButtonState;
end;

procedure TBisKrieltDataColumnParamEditForm.ButtonElementTypeClick(Sender: TObject);
begin
  Provider.ParamByName('ELEMENT_TYPE').Value:=Null;
end;

function TBisKrieltDataColumnParamEditForm.CanShow: Boolean;
var
  Param: TBisParamEditDataSelect;
begin
  Result:=inherited CanShow;
  if Result and (Mode in [emInsert]) then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('PARAM_ID'));
    if Assigned(Param) then
      Result:=Param.Select;
  end;
end;

end.
