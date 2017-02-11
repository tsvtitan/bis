unit BisKrieltDataTypeParamEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisKrieltDataTypeParamEditForm = class(TBisDataEditForm)
    LabelParam: TLabel;
    EditParam: TEdit;
    ButtonParam: TButton;
    LabelType: TLabel;
    EditType: TEdit;
    ButtonType: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelOperation: TLabel;
    EditOperation: TEdit;
    ButtonOperation: TButton;
    CheckBoxMain: TCheckBox;
    CheckBoxVisible: TCheckBox;
  private
    { Private declarations }
  public
  end;

  TBisKrieltDataTypeParamEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataTypeParamFilterFormIface=class(TBisKrieltDataTypeParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataTypeParamInsertFormIface=class(TBisKrieltDataTypeParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataTypeParamUpdateFormIface=class(TBisKrieltDataTypeParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataTypeParamDeleteFormIface=class(TBisKrieltDataTypeParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataTypeParamEditForm: TBisKrieltDataTypeParamEditForm;

implementation

uses BisKrieltDataTypesFm, BisKrieltDataParamsFm, BisKrieltDataOperationsFm, BisParam;

{$R *.dfm}

{ TBisKrieltDataTypeParamEditFormIface }

constructor TBisKrieltDataTypeParamEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataTypeParamEditForm;
  with Params do begin
    AddEditDataSelect('PARAM_ID','EditParam','LabelParam','ButtonParam',
                      TBisKrieltDataParamsFormIface,'PARAM_NAME',true,true,'','NAME').Older('OLD_PARAM_ID');
    AddEditDataSelect('TYPE_ID','EditType','LabelType','ButtonType',
                      TBisKrieltDataTypesFormIface,'TYPE_NAME',true,true,'','NAME').Older('OLD_TYPE_ID');
    AddEditDataSelect('OPERATION_ID','EditOperation','LabelOperation','ButtonOperation',
                      TBisKrieltDataOperationsFormIface,'OPERATION_NAME',true,true,'','NAME').Older('OLD_OPERATION_ID');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
    AddCheckBox('MAIN','CheckBoxMain').ExcludeModes([emFilter]);
    AddCheckBox('VISIBLE','CheckBoxVisible').ExcludeModes([emFilter]);
  end;
end;

{ TBisKrieltDataTypeParamFilterFormIface }

constructor TBisKrieltDataTypeParamFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

{ TBisKrieltDataTypeParamInsertFormIface }

constructor TBisKrieltDataTypeParamInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_TYPE_PARAM';
end;

{ TBisKrieltDataTypeParamUpdateFormIface }

constructor TBisKrieltDataTypeParamUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_TYPE_PARAM';
end;

{ TBisKrieltDataTypeParamDeleteFormIface }

constructor TBisKrieltDataTypeParamDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_TYPE_PARAM';
end;


end.
