unit BisKrieltObjectsFm;
                                                                                                            
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ExtCtrls, ComCtrls, DB, DBCtrls,
  BisDataFrm, BisDataGridFm, BisDataGridFrm, BisFieldNames, BisKrieltObjectsFrm;

type
  TBisKrieltObjectParamsFrame=class(TBisDataGridFrame)
  private
    function GetValue(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltObjectsForm = class(TBisDataGridForm)
    PanelMaster: TPanel;
    Splitter: TSplitter;
    PanelDetail: TPanel;
    PanelDetailCaption: TPanel;
    GroupBoxDescription: TGroupBox;
    MemoDescription: TDBMemo;
  private
    FDetailDataFrame: TBisKrieltObjectParamsFrame;
    procedure DataFrameProviderAfterScroll(DataSet: TDataSet);
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure BeforeShow; override;
  end;

  TBisKrieltObjectsFormIface=class(TBisDataGridFormIface)
  private
    function GetStatusName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    function GetViewTypeOper(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltObjectsForm: TBisKrieltObjectsForm;

implementation

uses BisUtils, BisConsts,
     BisFilterGroups, BisKrieltObjectEditFm, BisOrders, BisKrieltObjectParamEditFm,
     BisKrieltObjectDeleteFm, BisKrieltDataParamEditFm;

{$R *.dfm}

{ TBisKrieltObjectParamsFrame }

constructor TBisKrieltObjectParamsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UpdateClass:=TBisKrieltObjectParamUpdateFormIface;
  DeleteClass:=TBisKrieltObjectParamDeleteFormIface;
  with Provider do begin
    ProviderName:='S_OBJECT_PARAMS';
    with FieldNames do begin
      AddKey('OBJECT_PARAM_ID');
      AddInvisible('ACCOUNT_ID');
      AddInvisible('PARAM_ID');
      AddInvisible('OBJECT_ID');
      AddInvisible('DATE_CREATE');
      AddInvisible('DESCRIPTION');
      AddInvisible('USER_NAME');
      AddInvisible('VALUE_STRING');
      AddInvisible('VALUE_NUMBER');
      AddInvisible('VALUE_DATE');
      AddInvisible('VALUE_BLOB');
      AddInvisible('EXPORT');
      AddInvisible('PARAM_TYPE');
      AddInvisible('PARAM_MAX_LENGTH');
      AddInvisible('PARAM_SORTING');
      Add('PARAM_NAME','��������',100);
      AddCalculate('VALUE','��������',GetValue,ftString,1000,175);
    end;
    MasterFields:='OBJECT_ID';
    Orders.Add('PARAM_NAME');
  end;
end;

function TBisKrieltObjectParamsFrame.GetValue(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  ParamType: TBisKrieltDataParamType;
  S: String;
  APos: Integer;
begin
  Result:=Null;
  if DataSet.Active then begin
    S:='';
    ParamType:=TBisKrieltDataParamType(DataSet.FieldByName('PARAM_TYPE').AsInteger);
    case ParamType of
      dptList,dptString,dptLink: begin
        S:=VarToStrDef(DataSet.FieldByName('VALUE_STRING').Value,'');
        APos:=AnsiPos(#13#10,S);
        if APos>0 then
          S:=Copy(S,1,APos-1);
      end;
      dptInteger,dptFloat: begin
        S:=FloatToStr(VarToExtendedDef(DataSet.FieldByName('VALUE_NUMBER').Value,0.0));
      end;
      dptDate: begin
        S:=DateToStr(VarToDateDef(DataSet.FieldByName('VALUE_DATE').Value,NullDate));
      end;
      dptDateTime: begin
        S:=DateTimeToStr(VarToDateDef(DataSet.FieldByName('VALUE_DATE').Value,NullDate));
      end;
      dptImage: begin
        S:=GetParamTypeByIndex(Integer(ParamType));
      end;
      dptDocument: begin
        S:=GetParamTypeByIndex(Integer(ParamType));
      end;
      dptVideo: begin
        S:=GetParamTypeByIndex(Integer(ParamType));
      end;
    end;
    S:=Copy(S,1,1000);
    Result:=S;
  end;
end;

{ TBisKrieltObjectsFormIface }

constructor TBisKrieltObjectsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltObjectsForm;
  InsertClass:=TBisKrieltObjectInsertFormIface;
  UpdateClass:=TBisKrieltObjectUpdateFormIface;
  DeleteClass:=TBisKrieltObjectDeleteFormIface;
  FilterClass:=TBisKrieltObjectFilterFormIface;
  Permissions.Enabled:=true;
  FilterOnShow:=true;
  ProviderName:='S_PUBLISHING_OBJECTS';
  with FieldNames do begin
    AddKey('PUBLISHING_ID');
    AddKey('OBJECT_ID');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('VIEW_ID');
    AddInvisible('TYPE_ID');
    AddInvisible('OPERATION_ID');
    AddInvisible('DESIGN_ID');
    AddInvisible('STATUS');
    AddInvisible('DATE_END');
    AddInvisible('VIEW_NAME');
    AddInvisible('TYPE_NAME');
    AddInvisible('OPERATION_NAME');
    AddInvisible('DESIGN_NAME');
    AddInvisible('VIEW_NUM');
    AddInvisible('TYPE_NUM');
    AddInvisible('OPERATION_NUM');
    Add('PUBLISHING_NAME','�������',50);
    Add('DATE_BEGIN','���� ������',105);
    Add('USER_NAME','��� ���������',65);
    AddCalculate('VIEW_TYPE_OPER','���',GetViewTypeOper,ftString,100,35);
    Add('DESIGN_NUM','����������',35);
    Add('PRIORITY','�������',35);
    AddCalculate('STATUS_NAME','������',GetStatusName,ftString,100,55);
  end;
  Orders.Add('DATE_BEGIN',otDesc);
  Orders.Add('STATUS');

end;

function TBisKrieltObjectsFormIface.GetStatusName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  if DataSet.Active then begin
    S:=GetStatusByIndex(DataSet.FieldByName('STATUS').AsInteger);
    if Trim(S)<>'' then
      Result:=S;
  end;
end;

function TBisKrieltObjectsFormIface.GetViewTypeOper(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S1,S2,S3: String;
begin
  Result:=Null;
  if DataSet.Active then begin
    S1:=Trim(DataSet.FieldByName('VIEW_NUM').AsString);
    S2:=Trim(DataSet.FieldByName('TYPE_NUM').AsString);
    S3:=Trim(DataSet.FieldByName('OPERATION_NUM').AsString);
    Result:=S1+S2+S3;
  end;
end;

{ TBisKrieltObjectsForm }

constructor TBisKrieltObjectsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DataFrame.Parent:=PanelMaster;
  DataFrame.Margins.Right:=0;
  DataFrame.Provider.AfterScroll:=DataFrameProviderAfterScroll;
  DataFrame.Provider.BeforeOpen:=DataFrameProviderAfterScroll;

  FDetailDataFrame:=TBisKrieltObjectParamsFrame.Create(nil);
  FDetailDataFrame.Parent:=PanelDetail;
  FDetailDataFrame.Align:=alClient;
  FDetailDataFrame.Margins.Left:=0;
  FDetailDataFrame.Margins.Bottom:=0;
  with FDetailDataFrame do begin
    Provider.MasterSource:=DataFrame.DataSource;
    ActionFilter.Visible:=false;
    ActionReport.Visible:=false;
    ActionView.Visible:=false;
    ActionInsert.Visible:=false;
    ActionDuplicate.Visible:=false;
    LabelCounter.Visible:=true;
  end;

  MemoDescription.DataSource:=FDetailDataFrame.DataSource;
end;

destructor TBisKrieltObjectsForm.Destroy;
begin
  FDetailDataFrame.Free;
  inherited Destroy;
end;

class function TBisKrieltObjectsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltObjectsFrame;
end;

procedure TBisKrieltObjectsForm.Init;
begin
  inherited Init;
  FDetailDataFrame.ShowType:=ShowType;
  FDetailDataFrame.Init;
end;

procedure TBisKrieltObjectsForm.BeforeShow;
begin
  inherited BeforeShow;
  FDetailDataFrame.BeforeShow;
  if DataFrame.Provider.Active then
    FDetailDataFrame.OpenRecords;
end;

procedure TBisKrieltObjectsForm.DataFrameProviderAfterScroll(DataSet: TDataSet);
var
  OldCursor: TCursor;
begin
  if DataSet.Active and not DataSet.IsEmpty and not DataSet.ControlsDisabled then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    try
      FDetailDataFrame.OpenRecords;
    finally
      Screen.Cursor:=OldCursor;
    end;
  end else FDetailDataFrame.Provider.EmptyTable;
end;


end.
