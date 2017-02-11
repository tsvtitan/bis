unit BisKrieltDataTypeOperationsFm;
                                                                                                         
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataFrm, BisDataGridFm, BisDataGridFrm, BisDataEditFm;

type

  TBisKrieltDataTypeOperationsFrame=class(TBisDataGridFrame)
  private
    FTypeName: String;
    FTypeId: Variant;
    FTypeNum: String;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    property TypeId: Variant read FTypeId write FTypeId;
    property TypeName: String read FTypeName write FTypeName;
    property TypeNum: String read FTypeNum write FTypeNum;
  end;

  TBisKrieltDataTypeOperationsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    { Public declarations }
  end;

  TBisKrieltDataTypeOperationsFormIface=class(TBisDataGridFormIface)
  private
    FTypeName: String;
    FTypeId: Variant;
    FTypeNum: String;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property TypeId: Variant read FTypeId write FTypeId;
    property TypeName: String read FTypeName write FTypeName;
    property TypeNum: String read FTypeNum write FTypeNum;
  end;

var
  BisKrieltDataTypeOperationsForm: TBisKrieltDataTypeOperationsForm;

implementation

{$R *.dfm}

uses BisUtils, BisParam, BisKrieltDataTypeOperationEditFm, BisParamEditDataSelect;

{ TBisKrieltDataTypeOperationsFrame }

procedure TBisKrieltDataTypeOperationsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  ParamId: TBisParamEditDataSelect;
  P1: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    ParamId:=TBisParamEditDataSelect(AIface.Params.Find('TYPE_ID'));
    if Assigned(ParamId) and not VarIsNull(FTypeId) then begin
      ParamId.Value:=FTypeId;
      with AIface do begin
        Params.ParamByName('TYPE_NAME').Value:=FTypeName;
        Params.ParamByName('TYPE_NUM').Value:=FTypeNum;
        P1:=Params.ParamByName('TYPE_NUM;TYPE_NAME');
        P1.Value:=FormatEx(ParamId.DataAliasFormat,[FTypeNum,FTypeName]);
      end;
      ParamId.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

{ TBisKrieltDataTypeOperationsFormIface }

constructor TBisKrieltDataTypeOperationsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataTypeOperationsForm;
  FilterClass:=TBisKrieltDataTypeOperationFilterFormIface;
  InsertClass:=TBisKrieltDataTypeOperationInsertFormIface;
  UpdateClass:=TBisKrieltDataTypeOperationUpdateFormIface;
  DeleteClass:=TBisKrieltDataTypeOperationDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_TYPE_OPERATIONS';
  with FieldNames do begin
    AddKey('TYPE_ID');
    AddKey('OPERATION_ID');
    Add('OPERATION_NUM','����� ��������',30);
    Add('OPERATION_NAME','��������',130);
    Add('TYPE_NUM','����� ����',30);
    Add('TYPE_NAME','��� �������',130);
    Add('PRIORITY','�������',30);
  end;
  Orders.Add('TYPE_NAME');
  Orders.Add('PRIORITY');
  Orders.Add('OPERATION_NAME');
end;

function TBisKrieltDataTypeOperationsFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisKrieltDataTypeOperationsForm(Result) do begin
      TBisKrieltDataTypeOperationsFrame(DataFrame).TypeId:=FTypeId;
      TBisKrieltDataTypeOperationsFrame(DataFrame).TypeName:=FTypeName;
      TBisKrieltDataTypeOperationsFrame(DataFrame).TypeNum:=FTypeNum;
    end;
  end;
end;

{ TBisKrieltDataTypeOperationsForm }

class function TBisKrieltDataTypeOperationsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltDataTypeOperationsFrame;
end;

end.
