unit BisKrieltDataViewTypesFm;
                                                                                                         
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataFrm, BisDataGridFm, BisDataGridFrm, BisDataEditFm;

type

  TBisKrieltDataViewTypesFrame=class(TBisDataGridFrame)
  private
    FViewName: String;
    FViewId: Variant;
    FViewNum: String;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    property ViewId: Variant read FViewId write FViewId;
    property ViewName: String read FViewName write FViewName;
    property ViewNum: String read FViewNum write FViewNum;
  end;

  TBisKrieltDataViewTypesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    { Public declarations }
  end;

  TBisKrieltDataViewTypesFormIface=class(TBisDataGridFormIface)
  private
    FViewName: String;
    FViewId: Variant;
    FViewNum: String;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property ViewId: Variant read FViewId write FViewId;
    property ViewName: String read FViewName write FViewName;
    property ViewNum: String read FViewNum write FViewNum;
  end;

var
  BisKrieltDataViewTypesForm: TBisKrieltDataViewTypesForm;

implementation

{$R *.dfm}

uses BisUtils, BisParam, BisKrieltDataViewTypeEditFm, BisParamEditDataSelect;

{ TBisKrieltDataViewTypesFrame }

procedure TBisKrieltDataViewTypesFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  ParamId: TBisParamEditDataSelect;
  P1: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    ParamId:=TBisParamEditDataSelect(AIface.Params.Find('VIEW_ID'));
    if Assigned(ParamId) and not VarIsNull(FViewId) then begin
      ParamId.Value:=FViewId;
      with AIface do begin
        Params.ParamByName('VIEW_NAME').Value:=FViewName;
        Params.ParamByName('VIEW_NUM').Value:=FViewNum;
        P1:=Params.ParamByName('VIEW_NUM;VIEW_NAME');
        P1.Value:=FormatEx(ParamId.DataAliasFormat,[FViewNum,FViewName]);
      end;
      ParamId.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

{ TBisKrieltDataViewTypesFormIface }

constructor TBisKrieltDataViewTypesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataViewTypesForm;
  FilterClass:=TBisKrieltDataViewTypeFilterFormIface;
  InsertClass:=TBisKrieltDataViewTypeInsertFormIface;
  UpdateClass:=TBisKrieltDataViewTypeUpdateFormIface;
  DeleteClass:=TBisKrieltDataViewTypeDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_VIEW_TYPES';
  with FieldNames do begin
    AddKey('VIEW_ID');
    AddKey('TYPE_ID');
    Add('TYPE_NUM','����� ����',30);
    Add('TYPE_NAME','��� �������',130);
    Add('VIEW_NUM','����� ����',30);
    Add('VIEW_NAME','��� �������',130);
    Add('PRIORITY','�������',30);
  end;
  Orders.Add('VIEW_NAME');
  Orders.Add('PRIORITY');
  Orders.Add('TYPE_NAME');
end;

function TBisKrieltDataViewTypesFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisKrieltDataViewTypesForm(Result) do begin
      TBisKrieltDataViewTypesFrame(DataFrame).ViewId:=FViewId;
      TBisKrieltDataViewTypesFrame(DataFrame).ViewName:=FViewName;
      TBisKrieltDataViewTypesFrame(DataFrame).ViewNum:=FViewNum;
    end;
  end;
end;

{ TBisKrieltDataViewTypesForm }

class function TBisKrieltDataViewTypesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltDataViewTypesFrame;
end;

end.
