unit BisKrieltDataTypeOperationEditFm;

interface
                                                                                                       
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, DB,
  BisDataEditFm, BisControls;

type
  TBisKrieltDataTypeOperationEditForm = class(TBisDataEditForm)
    LabelOperation: TLabel;
    EditOperation: TEdit;
    ButtonOperation: TButton;
    LabelType: TLabel;
    EditType: TEdit;
    ButtonType: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
    function CanShow: Boolean; override;
  end;

  TBisKrieltDataTypeOperationEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataTypeOperationFilterFormIface=class(TBisKrieltDataTypeOperationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataTypeOperationInsertFormIface=class(TBisKrieltDataTypeOperationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataTypeOperationUpdateFormIface=class(TBisKrieltDataTypeOperationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataTypeOperationDeleteFormIface=class(TBisKrieltDataTypeOperationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataTypeOperationEditForm: TBisKrieltDataTypeOperationEditForm;

implementation

uses BisParam, BisParamEditDataSelect, BisKrieltDataTypesFm, BisKrieltDataOperationsFm;

{$R *.dfm}

{ TBisKrieltDataTypeOperationEditFormIface }

constructor TBisKrieltDataTypeOperationEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataTypeOperationEditForm;
  with Params do begin
    AddInvisible('TYPE_NUM',ptUnknown);
    AddInvisible('TYPE_NAME',ptUnknown);
    AddInvisible('OPERATION_NUM',ptUnknown);
    AddInvisible('OPERATION_NAME',ptUnknown);
    with AddEditDataSelect('TYPE_ID','EditType','LabelType','ButtonType',
                           TBisKrieltDataTypesFormIface,'TYPE_NUM;TYPE_NAME',true,true,'','NUM;NAME') do begin
      DataAliasFormat:='%s - %s';                           
      Older('OLD_TYPE_ID');
    end;
    with AddEditDataSelect('OPERATION_ID','EditOperation','LabelOperation','ButtonOperation',
                           TBisKrieltDataOperationsFormIface,'OPERATION_NUM;OPERATION_NAME',true,true,'','NUM;NAME') do begin
      DataAliasFormat:='%s - %s';                           
      Older('OLD_OPERATION_ID');
    end;
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisKrieltDataTypeOperationFilterFormIface }

constructor TBisKrieltDataTypeOperationFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataTypeOperationInsertFormIface }

constructor TBisKrieltDataTypeOperationInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_TYPE_OPERATION';
end;

{ TBisKrieltDataTypeOperationUpdateFormIface }

constructor TBisKrieltDataTypeOperationUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_TYPE_OPERATION';
end;

{ TBisKrieltDataTypeOperationDeleteFormIface }

constructor TBisKrieltDataTypeOperationDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_TYPE_OPERATION';
end;

{ TBisKrieltDataTypeOperationEditForm }

function TBisKrieltDataTypeOperationEditForm.CanShow: Boolean;
var
  Param: TBisParamEditDataSelect;
begin
  Result:=inherited CanShow;
  if Result and (Mode in [emInsert]) then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('OPERATION_ID'));
    if Assigned(Param) then
      Result:=Param.Select;
  end;
end;

end.
