unit BisKrieltDataColumnParamsFm;

interface                                                                                        

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataGridFm, BisDataGridFrm, BisDataFrm, BisDataEditFm;

type
  TBisKrieltDataColumnParamsFrame=class(TBisDataGridFrame)
  private
    FColumnId: Variant;
    FColumnName: String;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    property ColumnId: Variant read FColumnId write FColumnId;
    property ColumnName: String read FColumnName write FColumnName;
  end;

  TBisKrieltDataColumnParamsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisKrieltDataColumnParamsFormIface=class(TBisDataGridFormIface)
  private
    FColumnId: Variant;
    FColumnName: String;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property ColumnId: Variant read FColumnId write FColumnId;
    property ColumnName: String read FColumnName write FColumnName;
  end;

var
  BisKrieltDataColumnParamsForm: TBisKrieltDataColumnParamsForm;

implementation

{$R *.dfm}

uses BisKrieltDataColumnParamEditFm, BisParam;

{ TBisKrieltDataColumnParamsFrame }

procedure TBisKrieltDataColumnParamsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  ParamId: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    ParamId:=AIface.Params.Find('COLUMN_ID');
    if Assigned(ParamId) and not VarIsNull(FColumnId) then begin
      ParamId.Value:=FColumnId;
      AIface.Params.ParamByName('COLUMN_NAME').Value:=FColumnName;
      ParamId.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

{ TBisKrieltDataColumnParamsFormIface }

constructor TBisKrieltDataColumnParamsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColumnId:=Null;
  FormClass:=TBisKrieltDataColumnParamsForm;
  FilterClass:=TBisKrieltDataColumnParamFilterFormIface;
  InsertClass:=TBisKrieltDataColumnParamInsertFormIface;
  UpdateClass:=TBisKrieltDataColumnParamUpdateFormIface;
  DeleteClass:=TBisKrieltDataColumnParamDeleteFormIface;
  Permissions.Enabled:=true;
  FilterOnShow:=true;
  ProviderName:='S_COLUMN_PARAMS';
  with FieldNames do begin
    AddKey('COLUMN_ID');
    AddKey('PARAM_ID');
    AddInvisible('STRING_BEFORE');
    AddInvisible('USE_STRING_BEFORE');
    AddInvisible('STRING_AFTER');
    AddInvisible('USE_STRING_AFTER');
    AddInvisible('ELEMENT_TYPE');
    AddInvisible('POSITION');
    AddInvisible('PLACING');
    AddInvisible('GENERAL');
    Add('PARAM_NAME','��������',150);
    Add('PRIORITY','�������',50);
    Add('COLUMN_NAME','�������',150);
  end;
  Orders.Add('COLUMN_NAME');
  Orders.Add('PRIORITY');
end;

function TBisKrieltDataColumnParamsFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisKrieltDataColumnParamsForm(Result) do begin
      TBisKrieltDataColumnParamsFrame(DataFrame).ColumnId:=FColumnId;
      TBisKrieltDataColumnParamsFrame(DataFrame).ColumnName:=FColumnName;
    end;
  end;
end;

{ TBisKrieltDataColumnParamsForm }

class function TBisKrieltDataColumnParamsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltDataColumnParamsFrame;
end;

end.