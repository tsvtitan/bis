unit BisKrieltDataParamValuesFm;
                                                                                                        
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataGridFm, BisDataGridFrm, BisDataFrm, BisDataEditFm;

type
  TBisKrieltDataParamValuesForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisKrieltDataParamValuesFormIface=class(TBisDataGridFormIface)
  private
    FParamName: String;
    FParamId: Variant;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property ParamId: Variant read FParamId write FParamId;
    property ParamName: String read FParamName write FParamName;
  end;

var
  BisKrieltDataParamValuesForm: TBisKrieltDataParamValuesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataParamValueEditFm, BisParam,
    BisKrieltDataParamValuesFrm;

{ TBisKrieltDataParamValuesFormIface }

constructor TBisKrieltDataParamValuesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParamId:=Null;
  FormClass:=TBisKrieltDataParamValuesForm;
  FilterClass:=TBisKrieltDataParamValueFilterFormIface;
  InsertClass:=TBisKrieltDataParamValueInsertFormIface;
  UpdateClass:=TBisKrieltDataParamValueUpdateFormIface;
  DeleteClass:=TBisKrieltDataParamValueDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  FilterOnShow:=true;
  ProviderName:='S_PARAM_VALUES';
  with FieldNames do begin
    AddKey('PARAM_VALUE_ID');
    AddInvisible('PARAM_ID');
    AddInvisible('DESCRIPTION');
    AddInvisible('EXPORT');
    Add('NAME','��������',200);
    Add('PARAM_NAME','��������',150);
    Add('PRIORITY','�������',50);
  end;
  Orders.Add('PARAM_NAME');
  Orders.Add('PRIORITY');
end;

function TBisKrieltDataParamValuesFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisKrieltDataParamValuesForm(Result) do begin
      TBisKrieltDataParamValuesFrame(DataFrame).ParamId:=FParamId;
      TBisKrieltDataParamValuesFrame(DataFrame).ParamName:=FParamName;
    end;
  end;
end;

{ TBisKrieltDataParamValuesForm }

class function TBisKrieltDataParamValuesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltDataParamValuesFrame;
end;

end.
