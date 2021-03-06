unit BisKrieltObjectEditFm;

interface
                                                                                                      
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList, DB, Grids, DBGrids,
  BisDataEditFm, BisControls, BisParam, BisFilterGroups, BisDataSet;

type
  TBisKrieltObjectEditForm = class(TBisDataEditForm)
    PanelLeft: TPanel;
    LabelPublishing: TLabel;
    LabelStatus: TLabel;
    LabelDateBegin: TLabel;
    LabelAccount: TLabel;
    LabelView: TLabel;
    LabelType: TLabel;
    LabelOperation: TLabel;
    LabelDateEnd: TLabel;
    LabelDateBeginTo: TLabel;
    LabelDateEndTo: TLabel;
    LabelDesign: TLabel;
    LabelPriority: TLabel;
    EditPublishing: TEdit;
    ButtonPublishing: TButton;
    ComboBoxStatus: TComboBox;
    DateTimePickerBegin: TDateTimePicker;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    DateTimePickerBeginTime: TDateTimePicker;
    EditView: TEdit;
    ButtonView: TButton;
    EditType: TEdit;
    ButtonType: TButton;
    EditOperation: TEdit;
    ButtonOperation: TButton;
    DateTimePickerEnd: TDateTimePicker;
    DateTimePickerEndTime: TDateTimePicker;
    DateTimePickerBeginTo: TDateTimePicker;
    DateTimePickerBeginTimeTo: TDateTimePicker;
    DateTimePickerEndTo: TDateTimePicker;
    DateTimePickerEndTimeTo: TDateTimePicker;
    EditDesign: TEdit;
    ButtonDesign: TButton;
    EditPriority: TEdit;
    PanelClient: TPanel;
    Grid: TDBGrid;
    DataSource: TDataSource;
    procedure FormResize(Sender: TObject);
    procedure GridCellClick(Column: TColumn);
    procedure GridEditButtonClick(Sender: TObject);
    procedure GridColEnter(Sender: TObject);
    procedure GridColExit(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FDataSet: TBisDataSet;
    procedure FillDataSet;
    procedure AlignColumnsWidth;
    procedure DataSetAfterScroll(DataSet: TDataSet);
    procedure DataSetAfterInsert(DataSet: TDataSet);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure BeforeShow; override;
    procedure Execute; override;

    procedure GetParamFilterGroup(AFilterGroup: TBisFilterGroup);
  end;

  TBisKrieltObjectEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltObjectInsertFormIface=class(TBisKrieltObjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltObjectUpdateFormIface=class(TBisKrieltObjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltObjectFilterFormIface=class(TBisKrieltObjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltObjectEditForm: TBisKrieltObjectEditForm;

function GetStatusByIndex(Index: Integer): String;
  
implementation

uses Dateutils,
     BisCore, BisUtils, BisProvider, BisKrieltConsts,
     BisKrieltDataPublishingFm, BisKrieltDataViewsFm,
     BisKrieltDataViewTypesFm, BisKrieltDataTypeOperationsFm, BisKrieltDataDesignsFm,
     BisKrieltObjectDeleteFm, BisKrieltDataParamEditFm, BisKrieltDataParamValuesFm;

{$R *.dfm}

function GetStatusByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='�� �����������';
    1: Result:='�����������';
    2: Result:='���������';
  end;
end;


{ TBisKrieltObjectEditFormIface }

constructor TBisKrieltObjectEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltObjectEditForm;
  with Params do begin
    AddKey('OBJECT_ID').Older('OLD_OBJECT_ID');
    AddInvisible('VIEW_NUM');
    AddInvisible('VIEW_NAME');
    AddInvisible('TYPE_NUM');
    AddInvisible('TYPE_NAME');
    AddInvisible('OPERATION_NUM');
    AddInvisible('OPERATION_NAME');
    AddInvisible('DESIGN_NUM');
    AddInvisible('DESIGN_NAME');
    AddEditDataSelect('PUBLISHING_ID','EditPublishing','LabelPublishing','ButtonPublishing',
                      TBisKrieltDataPublishingFormIface,'PUBLISHING_NAME',true,true,'','NAME').Older('OLD_PUBLISHING_ID');
    AddEditDataSelect('VIEW_ID','EditView','LabelView','ButtonView',
                      TBisKrieltDataViewsFormIface,'VIEW_NUM;VIEW_NAME',true,false,'','NUM;NAME').DataAliasFormat:='%s - %s';
    AddEditDataSelect('TYPE_ID','EditType','LabelType','ButtonType',
                      TBisKrieltDataViewTypesFormIface,'TYPE_NUM;TYPE_NAME',true,false,'','').DataAliasFormat:='%s - %s';
    AddEditDataSelect('OPERATION_ID','EditOperation','LabelOperation','ButtonOperation',
                      TBisKrieltDataTypeOperationsFormIface,'OPERATION_NUM;OPERATION_NAME',true,false,'','').DataAliasFormat:='%s - %s';
    AddEditDataSelect('DESIGN_ID','EditDesign','LabelDesign','ButtonDesign',
                      TBisKrieltDataDesignsFormIface,'DESIGN_NUM;DESIGN_NAME',false,false,'','NUM;NAME').DataAliasFormat:='%s - %s';
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassDataAccountsFormIface,'USER_NAME',true,false);
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin',true).FilterCondition:=fcEqualGreater;
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd',false).FilterCondition:=fcEqualGreater;
    AddComboBox('STATUS','ComboBoxStatus','LabelStatus',true);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
  end;
end;

{ TBisKrieltObjectInsertFormIface }

constructor TBisKrieltObjectInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PUBLISHING_OBJECT';
end;

{ TBisKrieltObjectUpdateFormIface }

constructor TBisKrieltObjectUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PUBLISHING_OBJECT';
end;

{ TBisKrieltObjectFilterFormIface }

constructor TBisKrieltObjectFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with Params do begin
    Unique:=false;
    with AddEditDateTime('DATE_BEGIN','DateTimePickerBeginTo','DateTimePickerBeginTimeTo','LabelDateBeginTo') do begin
      FilterCondition:=fcEqualLess;
      ExcludeModes(AllParamEditModes);
      Modes:=[emFilter];
    end;
    with AddEditDateTime('DATE_END','DateTimePickerEndTo','DateTimePickerEndTimeTo','LabelDateEndTo') do begin
      FilterCondition:=fcEqualLess;
      ExcludeModes(AllParamEditModes);
      Modes:=[emFilter];
    end;
  end;
end;

{ TBisKrieltObjectEditForm }

constructor TBisKrieltObjectEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  FDataSet:=TBisDataSet.Create(nil);
  with FDataSet do begin
    FieldDefs.Add('PARAM_ID',ftString,32);
    FieldDefs.Add('PARAM_TYPE',ftInteger);
    FieldDefs.Add('NAME',ftString,100);
    FieldDefs.Add('VALUE',ftString,1000);
  end;
  FDataSet.CreateTable();
  FDataSet.AfterInsert:=DataSetAfterInsert;
  FDataSet.AfterScroll:=DataSetAfterScroll;

  DataSource.DataSet:=FDataSet;

  ComboBoxStatus.Clear;
  for i:=0 to 2 do begin
    ComboBoxStatus.Items.Add(GetStatusByIndex(i));
  end;
end;

destructor TBisKrieltObjectEditForm.Destroy;
begin
  FDataSet.Free;
  inherited Destroy;
end;

procedure TBisKrieltObjectEditForm.FillDataSet;
var
  P: TBisProvider;
begin
  FDataSet.EmptyTable;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_PARAMS';
    P.FilterGroups.Add.Filters.Add('LOCKED',fcEqual,0);
    with P.FilterGroups.Add do begin
      Filters.Add('PARAM_TYPE',fcEqual,dptList).&Operator:=foOr;
      Filters.Add('PARAM_TYPE',fcEqual,dptString).&Operator:=foOr;
      Filters.Add('PARAM_TYPE',fcEqual,dptLink).&Operator:=foOr;
      Filters.Add('PARAM_TYPE',fcEqual,dptInteger).&Operator:=foOr;
      Filters.Add('PARAM_TYPE',fcEqual,dptFloat).&Operator:=foOr;
      Filters.Add('PARAM_TYPE',fcEqual,dptDate).&Operator:=foOr;
      Filters.Add('PARAM_TYPE',fcEqual,dptDateTime).&Operator:=foOr;
    end;
    P.Orders.Add('NAME');
    P.Open;
    if P.Active then begin
      FDataSet.AfterInsert:=nil;
      FDataSet.AfterScroll:=nil;
      try
        FDataSet.CopyRecords(P);
        FDataSet.First;
        Grid.Columns[0].Width:=170;
        Grid.Columns[1].Width:=130;
        DataSetAfterScroll(FDataSet);
      finally
        FDataSet.AfterInsert:=DataSetAfterInsert;
        FDataSet.AfterScroll:=DataSetAfterScroll;
      end;
    end;
  finally
    P.Free;
  end;
end;

procedure TBisKrieltObjectEditForm.FormResize(Sender: TObject);
begin
  AlignColumnsWidth;
end;

procedure TBisKrieltObjectEditForm.DataSetAfterInsert(DataSet: TDataSet);
begin
  FDataSet.Cancel;
end;

procedure TBisKrieltObjectEditForm.DataSetAfterScroll(DataSet: TDataSet);
begin
  if Grid.SelectedIndex<>-1 then
    GridCellClick(Grid.Columns[Grid.SelectedIndex]);
  Grid.Invalidate;
end;

procedure TBisKrieltObjectEditForm.BeforeShow;
begin
  inherited BeforeShow;
  FillDataSet;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      Find('ACCOUNT_ID').SetNewValue(Core.AccountId);
      Find('USER_NAME').SetNewValue(Core.AccountUserName);
      Find('DATE_BEGIN').SetNewValue(Now);
      Find('DATE_END').SetNewValue(IncDay(DateOf(Now),7));
    end;
    UpdateButtonState;
  end;
  if not (Mode in [emFilter]) then begin
    PanelLeft.Align:=alClient;
    Constraints.MinWidth:=350;
    Width:=Constraints.MinWidth;
    LabelDateBeginTo.Enabled:=false;
    DateTimePickerBeginTo.Enabled:=false;
    DateTimePickerBeginTo.Color:=clBtnFace;
    DateTimePickerBeginTimeTo.Enabled:=false;
    DateTimePickerBeginTimeTo.Color:=clBtnFace;
    LabelDateEndTo.Enabled:=false;
    DateTimePickerEndTo.Enabled:=false;
    DateTimePickerEndTo.Color:=clBtnFace;
    DateTimePickerEndTimeTo.Enabled:=false;
    DateTimePickerEndTimeTo.Color:=clBtnFace;
  end else begin
    PanelClient.Visible:=true;
    Constraints.MinWidth:=640;
    Width:=Constraints.MinWidth;
  end;
  WriteProfileParams;
end;

procedure TBisKrieltObjectEditForm.Execute;
begin
  inherited Execute;
  if Mode=emUpdate then
    RefreshObject(Provider.Params.ParamByName('OBJECT_ID').Value);
end;

type
  THackGrid=class(TCustomGrid)
  end;

procedure TBisKrieltObjectEditForm.AlignColumnsWidth;
var
  i: Integer;
  w1,w2: Integer;
  Col: TColumn;
  r: Extended;
begin
  w1:=0;
  for i:=0 to Grid.Columns.Count-1 do begin
    Col:=Grid.Columns.Items[i];
    if Col.Visible then
      w1:=w1+Col.Width;
  end;
  w2:=Grid.ClientWidth-Grid.Columns.Count-GetSystemMetrics(SM_CYVSCROLL);

  for i:=0 to Grid.Columns.Count-1 do begin
    Col:=Grid.Columns.Items[i];
    if Col.Visible and (w1>0) then begin
      r:=w2*Col.Width/w1;
      Col.Width:=Trunc(r);
    end;
  end;
end;

procedure TBisKrieltObjectEditForm.GridCellClick(Column: TColumn);
var
  ParamType: TBisKrieltDataParamType;
begin
  Column.ButtonStyle:=cbsAuto;
  if Column.FieldName='VALUE' then begin
    Grid.Options:=Grid.Options+[dgEditing];
    Grid.ReadOnly:=false;
    if FDataSet.Active and not FDataSet.IsEmpty then begin
      ParamType:=TBisKrieltDataParamType(FDataSet.FieldByName('PARAM_TYPE').AsInteger);
      Column.ButtonStyle:=iff(ParamType=dptList,cbsEllipsis,Column.ButtonStyle);
    end;
  end else begin
    Grid.Options:=Grid.Options-[dgEditing];
    Grid.ReadOnly:=true;
  end;
end;

procedure TBisKrieltObjectEditForm.GridColEnter(Sender: TObject);
begin
  if Grid.SelectedIndex<>-1 then
    GridCellClick(Grid.Columns[Grid.SelectedIndex]);
end;

procedure TBisKrieltObjectEditForm.GridColExit(Sender: TObject);
begin
  if Grid.SelectedIndex<>-1 then begin
    GridCellClick(Grid.Columns[Grid.SelectedIndex]);
    if FDataSet.State in [dsEdit] then
      FDataSet.Post;
  end;
end;

procedure TBisKrieltObjectEditForm.GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE) and (ssCtrl in Shift) then
    Key:=0;
end;

procedure TBisKrieltObjectEditForm.GridEditButtonClick(Sender: TObject);
var
  AIface: TBisKrieltDataParamValuesFormIface;
  DS: TBisDataSet;
begin
  if FDataSet.Active and not FDataSet.Empty then begin
    AIface:=TBisKrieltDataParamValuesFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='NAME';
      AIface.LocateValues:=FDataSet.FieldByName('VALUE').AsString;
      AIface.FilterGroups.Add.Filters.Add('PARAM_ID',fcEqual,FDataSet.FieldByName('PARAM_ID').Value);
      AIface.FilterOnShow:=false;
      if AIface.SelectInto(DS) then begin
        FDataSet.Edit;
        FDataSet.FieldByName('VALUE').Value:=DS.FieldByName('NAME').Value;
        FDataSet.Post;
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisKrieltObjectEditForm.GetParamFilterGroup(AFilterGroup: TBisFilterGroup);
var
  B: TBookmark;
  ParamType: TBisKrieltDataParamType;
  FieldValue: String;
  Condition: TBisFilterCondition;
  Value: Variant;
  ValueString: String;
  ValueInteger: Integer;
  ValueFloat: Extended;
  ValueDate: TDateTime;
  Support: Boolean;
  LeftSide: Boolean;
begin
  if Assigned(AFilterGroup) and FDataSet.Active then begin
    FDataSet.DisableControls;
    B:=FDataSet.GetBookmark;
    try
      FDataSet.First;
      while not FDataSet.Eof do begin
        ParamType:=TBisKrieltDataParamType(FDataSet.FieldByName('PARAM_TYPE').AsInteger);
        ValueString:=FDataSet.FieldByName('VALUE').AsString;
        Support:=true;
        Value:=Null;
        Condition:=fcEqual;
        LeftSide:=false;
        case ParamType of
          dptList,dptString,dptLink: begin
            FieldValue:='VALUE_STRING';
            Condition:=fcLike;
            LeftSide:=true;
            if Trim(ValueString)<>'' then
              Value:=ValueString;
          end;
          dptInteger: begin
            FieldValue:='VALUE_NUMBER';
            if TryStrToInt(ValueString,ValueInteger) then
              Value:=ValueInteger;
          end;
          dptFloat: begin
            FieldValue:='VALUE_NUMBER';
            if TryStrToFloat(ValueString,ValueFloat) then
              Value:=ValueFloat;
          end;
          dptDate: begin
            FieldValue:='VALUE_DATE';
            if TryStrToDate(ValueString,ValueDate) then
              Value:=ValueDate;
          end;
          dptDateTime: begin
            FieldValue:='VALUE_DATE';
            if TryStrToDateTime(ValueString,ValueDate) then
              Value:=ValueDate;
          end;
        else
          Support:=false;  
        end;
        if Support and not VarIsNull(Value) then begin
          with AFilterGroup.Filters.AddInside('OBJECT_ID','','S_OBJECT_PARAMS').InsideFilterGroups.Add do begin
            Filters.Add('PARAM_ID',fcEqual,FDataSet.FieldByName('PARAM_ID').Value).CheckCase:=true;
            Filters.Add(FieldValue,Condition,Value).LeftSide:=LeftSide;
          end;
        end;
        FDataSet.Next;
      end;
    finally
      if Assigned(B) and FDataSet.BookmarkValid(B) then
        FDataSet.GotoBookmark(B);
      FDataSet.EnableControls;  
    end;
  end;
end;


end.
