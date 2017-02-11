unit BisKrieltDataParamValueDependsFm;

interface                                                                                              

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataGridFm, BisDataGridFrm, BisDataFrm, BisDataEditFm;

type
  TBisKrieltDataParamValueDependsFrame = class(TBisDataGridFrame)
  private
    FParamValueName: String;
    FParamName: String;
    FParamValueId: Variant;
    FParamId: Variant;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    property ParamValueId: Variant read FParamValueId write FParamValueId;
    property ParamValueName: String read FParamValueName write FParamValueName;
    property ParamId: Variant read FParamId write FParamId;
    property ParamName: String read FParamName write FParamName;
  end;

  TBisKrieltDataParamValueDependsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisKrieltDataParamValueDependsFormIface=class(TBisDataGridFormIface)
  private
    FParamValueId: Variant;
    FParamValueName: String;
    FParamName: String;
    FParamId: Variant;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property ParamValueId: Variant read FParamValueId write FParamValueId;
    property ParamValueName: String read FParamValueName write FParamValueName;
    property ParamId: Variant read FParamId write FParamId;
    property ParamName: String read FParamName write FParamName;
  end;

var
  BisKrieltDataTypeTypesForm: TBisKrieltDataParamValueDependsForm;

implementation

{$R *.dfm}

uses BisKrieltDataParamValueDependEditFm, BisParam;

{ TBisKrieltDataParamValueDependsFrame }

procedure TBisKrieltDataParamValueDependsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  Param: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    Param:=AIface.Params.Find('WHAT_PARAM_VALUE_ID');
    if Assigned(Param) and not VarIsNull(FParamValueId) then begin
      Param.Value:=FParamValueId;
      AIface.Params.ParamByName('WHAT_PARAM_VALUE_NAME').Value:=FParamValueName;
      AIface.Params.ParamByName('WHAT_PARAM_ID').Value:=FParamId;
      AIface.Params.ParamByName('WHAT_PARAM_NAME').Value:=FParamName;
      Param.ExcludeModes(AllParamEditModes);
      AIface.Params.ParamByName('WHAT_PARAM_ID').ExcludeModes(AllParamEditModes);
    end;
  end;
end;

{ TBisKrieltDataParamValueDependsFormIface }

constructor TBisKrieltDataParamValueDependsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParamValueId:=Null;
  FParamId:=Null;
  FormClass:=TBisKrieltDataParamValueDependsForm;
  FilterClass:=TBisKrieltDataParamValueDependFilterFormIface;
  InsertClass:=TBisKrieltDataParamValueDependInsertFormIface;
  UpdateClass:=TBisKrieltDataParamValueDependUpdateFormIface;
  DeleteClass:=TBisKrieltDataParamValueDependDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  FilterOnShow:=true;
  ProviderName:='S_PARAM_VALUE_DEPENDS';
  with FieldNames do begin
    AddKey('WHAT_PARAM_VALUE_ID');
    AddKey('FROM_PARAM_VALUE_ID');
    AddInvisible('WHAT_PARAM_ID');
    AddInvisible('FROM_PARAM_ID');
    Add('WHAT_PARAM_VALUE_NAME','Какое значение',125);
    Add('WHAT_PARAM_NAME','Какой параметр',125);
    Add('FROM_PARAM_VALUE_NAME','От какого значения',125);
    Add('FROM_PARAM_NAME','От какого параметра',125);
  end;
  Orders.Add('WHAT_PARAM_NAME');
  Orders.Add('WHAT_PARAM_VALUE_NAME');
end;

function TBisKrieltDataParamValueDependsFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisKrieltDataParamValueDependsForm(Result) do begin
      TBisKrieltDataParamValueDependsFrame(DataFrame).ParamValueId:=FParamValueId;
      TBisKrieltDataParamValueDependsFrame(DataFrame).ParamValueName:=FParamValueName;
      TBisKrieltDataParamValueDependsFrame(DataFrame).ParamId:=FParamId;
      TBisKrieltDataParamValueDependsFrame(DataFrame).ParamName:=FParamName;
    end;
  end;
end;

{ TBisKrieltDataParamValueDependsForm }

class function TBisKrieltDataParamValueDependsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltDataParamValueDependsFrame;
end;

end.
