unit BisKrieltExportXlsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, ExtCtrls, Buttons, StdCtrls, ComCtrls, DB, Contnrs,
  VirtualTrees, VirtualDBTreeEx,
  BisFm, BisExecuteFm, BisDataSet, BisFilterGroups, BisDbTree;

type
  TBisKrieltExportXlsForm = class(TBisExecuteForm)
    ProgressBar: TProgressBar;
    SaveDialog: TSaveDialog;
    PanelSettings: TPanel;
    LabelPublishing: TLabel;
    EditPublishing: TEdit;
    ButtonPublishing: TButton;
    LabelDateBeginFrom: TLabel;
    DateTimePickerBeginFrom: TDateTimePicker;
    LabelDateBeginTo: TLabel;
    DateTimePickerBeginTo: TDateTimePicker;
    ButtonIssue: TButton;
    LabelPath: TLabel;
    procedure ButtonIssueClick(Sender: TObject);
    procedure ButtonPublishingClick(Sender: TObject);
  private
    FFileName: String;
    FPosition: Integer;
    FMax: Integer;
    FPublishingId: Variant;
    FIssueId: Variant;
    FLastError: String;
    procedure ProgressVisible(AVisible: Boolean);
    procedure SyncProgress;
    procedure ShowLastError;
  protected
    procedure ThreadExecute(AThread: TBisExecuteFormThread); override;
    procedure DoTerminate; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanOptions: Boolean; override;
    function CanStart: Boolean; override;
    procedure Start; override;

  end;

  TBisKrieltExportXlsFormIface=class(TBisExecuteFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltExportXlsForm: TBisKrieltExportXlsForm;

implementation

uses DateUtils, StrUtils, ActiveX, ComObj,
     ALXmlDoc,
     BisConsts, BisUtils, BisProvider, BisRtfStream, BisValues, BisVariants, BisDialogs,
     BisKrieltDataIssuesFm, BisKrieltDataPublishingFm, BisKrieltDataParamEditFm;

{$R *.dfm}

{ TBisKrieltExportXlsFormIface }

constructor TBisKrieltExportXlsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltExportXlsForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
end;

{ TBisKrieltExportRtfForm }

constructor TBisKrieltExportXlsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SizesStored:=true;

  ProgressVisible(false);

  DateTimePickerBeginFrom.Date:=DateOf(Date);
  DateTimePickerBeginTo.Date:=DateOf(Date);

  FPublishingId:=Null;
  FIssueId:=Null;
end;

destructor TBisKrieltExportXlsForm.Destroy;
begin

  inherited Destroy;
end;

procedure TBisKrieltExportXlsForm.DoTerminate;
begin
  inherited DoTerminate;
  ProgressVisible(false);
  EnableControl(PanelControls,true);
end;

procedure TBisKrieltExportXlsForm.ButtonIssueClick(Sender: TObject);
var
  AIface: TBisKrieltDataIssuesFormIface;
  P: TBisProvider;
begin
  AIface:=TBisKrieltDataIssuesFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.LocateFields:='ISSUE_ID';
    AIface.LocateValues:=FIssueId;
    AIface.FilterGroups.Add.Filters.Add('PUBLISHING_ID',fcEqual,FPublishingId);
    if AIface.SelectInto(P) then begin
      FIssueId:=P.FieldByName('ISSUE_ID').Value;
      DateTimePickerBeginFrom.Date:=DateOf(P.FieldByName('DATE_BEGIN').AsDateTime);
      DateTimePickerBeginTo.Date:=DateOf(P.FieldByName('DATE_END').AsDateTime);
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisKrieltExportXlsForm.ButtonPublishingClick(Sender: TObject);
var
  AIface: TBisKrieltDataPublishingFormIface;
  P: TBisProvider;
begin
  AIface:=TBisKrieltDataPublishingFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.LocateFields:='PUBLISHING_ID';
    AIface.LocateValues:=FPublishingId;
    if AIface.SelectInto(P) then begin
      FPublishingId:=P.FieldByName('PUBLISHING_ID').Value;
      EditPublishing.Text:=P.FieldByName('NAME').AsString;
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

function TBisKrieltExportXlsForm.CanOptions: Boolean;
begin
  Result:=false;
end;

procedure TBisKrieltExportXlsForm.ProgressVisible(AVisible: Boolean);
begin
  ProgressBar.Visible:=AVisible;
  if AVisible then begin
    PanelButtons.Height:=80;
  end else begin
    PanelButtons.Height:=60;
  end;
end;

{procedure TBisKrieltExportRtfForm.TreeChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
                                               var NewState: TCheckState; var Allowed: Boolean);
var
  Data: PBisDBTreeNode;
  ExportId: Variant;
begin
  Allowed:=false;
  Data:=FTree.GetDBNodeData(Node);
  if Assigned(Data) then begin
    ExportId:=Data.Values.GetValue('EXPORT_ID');
    if not VarIsNull(ExportId) then begin
      if FDataSet.Locate('EXPORT_ID',ExportId,[loCaseInsensitive]) then begin
        FDataSet.Edit;
        FDataSet.FieldByName('CHECKED').AsInteger:=iff(NewState=csCheckedNormal,1,0);
        FDataSet.Post;
        Allowed:=true;
      end;
    end;
  end;
end;}

{procedure TBisKrieltExportRtfForm.TreeReadNodeFromDB(Sender: TBaseVirtualDBTreeEx; Node: PVirtualNode);
begin
  if Assigned(Node) then begin
    Node.CheckState:=csCheckedNormal;
  end;
end;}

function TBisKrieltExportXlsForm.CanStart: Boolean;
begin
  Result:=inherited CanStart and not VarIsNull(FPublishingId);
end;

procedure TBisKrieltExportXlsForm.ShowLastError;
begin
  if Trim(FLastError)<>'' then
    ShowError(FLastError);
end;

procedure TBisKrieltExportXlsForm.Start;
begin
  if CanStart then begin
    if SaveDialog.Execute then begin
      FFileName:=SaveDialog.FileName;
      FLastError:='';
      inherited Start;
      ProgressVisible(true);
      EnableControl(PanelControls,false);
    end;
  end;
end;

procedure TBisKrieltExportXlsForm.SyncProgress;
begin
  ProgressBar.Position:=FPosition;
  ProgressBar.Max:=FMax;
  ProgressBar.Update;
end;

procedure TBisKrieltExportXlsForm.ThreadExecute(AThread: TBisExecuteFormThread);
var
  PParams: TBisProvider;

  function GetFN(S: String): String;
  begin
    Result:='P'+S;
  end;

  function GetNullValue(Field: TField): Variant;
  begin
    Result:=Null;
    case Field.DataType of
      ftString: Result:=DupeString(AnsiChar($FF),Field.Size);
      ftInteger: Result:=MaxInt;
      ftFloat: Result:=1.7E+308;
      ftDate: Result:=Trunc(1.7E+308);
      ftDateTime: Result:=1.7E+308;
    end;
  end;

  procedure ProcessObjects(DataSet: TBisDataSet; ViewId,TypeId,OperationId: Variant; Sortings: TStringList);

    function CreateObjectsDataSet(WithSorting: Boolean; var IndexName: String): TBisDataSet;
    var
      AName: String;
      AParamId: String;
      AMaxLength: Integer;
      AParamType: TBisKrieltDataParamType;
      ADataType: TFieldType;
      FN: String;
      FieldSupport: Boolean;
      i: Integer;
      Fields: String;
      Indexes: TStringList;
      Index: Integer;
    begin
      Indexes:=TStringList.Create;
      try
        Indexes.Assign(Sortings);
        Result:=TBisDataSet.Create(nil);
        with Result.FieldDefs do begin
          Add('OBJECT_ID',ftString,32);
          Add('DESIGN_ID',ftString,32);
          Add('DESIGN_NAME',ftString,100);
          Add('PRIORITY',ftInteger);
        end;
        PParams.First;
        while not PParams.Eof do begin
          AName:=PParams.FieldByName('NAME').AsString;
          AParamId:=PParams.FieldByName('PARAM_ID').AsString;
          AMaxLength:=PParams.FieldByName('MAX_LENGTH').AsInteger;
          AParamType:=TBisKrieltDataParamType(PParams.FieldByName('PARAM_TYPE').AsInteger);
          ADataType:=ftString;
          FieldSupport:=true;
          case AParamType of
            dptList,dptString,dptLink: ADataType:=ftString;
            dptInteger: ADataType:=ftInteger;
            dptFloat: ADataType:=ftFloat;
            dptDate: ADataType:=ftDate;
            dptDateTime: ADataType:=ftDateTime;
            dptImage, dptDocument, dptVideo: FieldSupport:=false;
          else
            FieldSupport:=false;
          end;
          if FieldSupport then begin
            FN:=GetFN(AParamId);
            Result.FieldDefs.Add(FN,ADataType,AMaxLength,false);
            Index:=Sortings.IndexOf(AParamId);
            if Index<>-1 then begin
              Indexes.Strings[Index]:=FN;
            end;
          end;
          PParams.Next;
        end;
        Result.CreateTable;

        if WithSorting then begin
          Fields:='';
          for i:=0 to Indexes.Count-1 do begin
            if i=0 then
              Fields:=Indexes[i]
            else
              Fields:=Fields+';'+Indexes[i];
          end;
          if Fields<>'' then begin
            IndexName:='I'+GetUniqueID;
            Result.IndexDefs.Add(IndexName,Fields,[]);
            Result.CreateIndexes;
          end;
        end;

      finally
        Indexes.Free;
      end;
    end;

    procedure ApplyFilter(DSSource, DSDestination: TBisDataSet);
    var
      Str: TStringList;
      Field: TField;
      i: Integer;
      AValue: Variant;
    begin
      Str:=TStringList.Create;
      try
        DSSource.Filtered:=false;
        DSSource.First;
        while not DSSource.Eof do begin
          DSDestination.Append;
          for i:=0 to DSSource.FieldCount-1 do begin
            AValue:=DSSource.Fields[i].Value;
            Field:=DSDestination.Fields[i];
            if VarIsNull(AValue) then
              Field.Value:=GetNullValue(DSSource.Fields[i])
            else begin
              Field.Clear;
              Field.Value:=AValue;
            end;  
          end;
          DSDestination.Post;
          DSSource.Next;
        end;
      finally
        Str.Free;
      end;
    end;

    procedure ApplyIndex(DS: TBisDataSet; IndexName: String);
    begin
      if DS.Active and not DS.Empty then begin
        DS.EnableIndexes:=false;
        DS.IndexName:=IndexName;
        DS.EnableIndexes:=true;
        DS.UpdateIndexes;
      end;
    end;

  var
    P: TBisProvider;
    ObjectId,OldObjectId: Variant;
    ParamId: String;
    ParamType: TBisKrieltDataParamType;
    Stream: TMemoryStream;
    DS, DSF: TBisDataSet;
    Value: Variant;
    Index: String;
    Priority: Variant;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.WithWaitCursor:=false;
      P.ProviderName:='S_OBJECT_PARAMS_EX';
      with P.FieldNames do begin
        AddInvisible('OBJECT_ID');
        AddInvisible('DESIGN_ID');
        AddInvisible('PARAM_ID');
        AddInvisible('PARAM_NAME');
        AddInvisible('PARAM_TYPE');
        AddInvisible('MAX_LENGTH');
        AddInvisible('VALUE_STRING');
        AddInvisible('VALUE_NUMBER');
        AddInvisible('VALUE_DATE');
        AddInvisible('VALUE_BLOB');
        AddInvisible('EXPORT');
        AddInvisible('PRIORITY');
        AddInvisible('DESIGN_NAME');
      end;
      with P.FilterGroups.Add do begin
        Filters.Add('PUBLISHING_ID',fcEqual,FPublishingId).CheckCase:=true;
        Filters.Add('VIEW_ID',fcEqual,ViewId).CheckCase:=true;
        Filters.Add('TYPE_ID',fcEqual,TypeId).CheckCase:=true;
        Filters.Add('OPERATION_ID',fcEqual,OperationId).CheckCase:=true;
        Filters.Add('STATUS',fcEqual,1);
      end;
      P.FilterGroups.Add.Filters.Add('DATE_BEGIN',fcEqualGreater,DateOf(DateTimePickerBeginFrom.Date));
      with P.FilterGroups.Add do begin
        Filters.Add('DATE_END',fcEqualGreater,DateOf(IncDay(DateTimePickerBeginTo.Date)));
        Filters.Add('DATE_END',fcIsNull,Null).&Operator:=foOr;
      end;
      with P.Orders do begin
        Add('OBJECT_ID');
        Add('PRIORITY');
        Add('DATE_CREATE');
      end;
      P.Open;
      if P.Active then begin
        DS:=CreateObjectsDataSet(false,Index);
        try
          OldObjectId:=Null;
          P.First;
          while not P.Eof do begin
            if AThread.Terminated then
              break;

            ObjectId:=P.FieldByName('OBJECT_ID').Value;
            if not VarSameValue(ObjectId,OldObjectId) then begin
              if DS.State in [dsInsert,dsEdit] then
                DS.Post;
              OldObjectId:=ObjectId;
              DS.Append;
              DS.FieldByName('OBJECT_ID').Value:=ObjectId;
              DS.FieldByName('DESIGN_ID').Value:=P.FieldByName('DESIGN_ID').Value;
              DS.FieldByName('DESIGN_NAME').Value:=P.FieldByName('DESIGN_NAME').Value;
              Priority:=P.FieldByName('PRIORITY').Value;
              if VarIsNull(Priority) then
                DS.FieldByName('PRIORITY').Value:=MaxInt
              else
                DS.FieldByName('PRIORITY').Value:=VarToIntDef(Priority,MaxInt);
            end;

            ParamId:=P.FieldByName('PARAM_ID').AsString;
            ParamType:=TBisKrieltDataParamType(P.FieldByName('PARAM_TYPE').AsInteger);
            Value:=Null;
            case ParamType of
              dptList: begin
                Value:=Trim(VarToStrDef(P.FieldByName('EXPORT').Value,''));
                if Value='' then
                  Value:=P.FieldByName('VALUE_STRING').Value;
              end;
              dptString,dptLink: Value:=P.FieldByName('VALUE_STRING').Value;
              dptInteger,dptFloat: Value:=P.FieldByName('VALUE_NUMBER').Value;
              dptDate,dptDateTime: Value:=P.FieldByName('VALUE_DATE').Value;
              dptImage,dptDocument,dptVideo: Value:=P.FieldByName('VALUE_BLOB').Value;
            end;
            DS.FieldByName(GetFN(ParamId)).Value:=Value;

            P.Next;
          end;
          if DS.State in [dsInsert,dsEdit] then
            DS.Post;

          if not DS.Empty then begin
            Stream:=TMemoryStream.Create;
            DSF:=CreateObjectsDataSet(true,Index);
            try
              ApplyFilter(DS,DSF);
              ApplyIndex(DSF,Index);

              DSF.SaveToStream(Stream);
              Stream.Position:=0;
              DataSet.LoadFromStream(Stream);
              DataSet.Open;

            finally
              DSF.Free;
              Stream.Free;
            end;
          end;
        finally
          DS.Free;
        end;
      end;
    finally
      P.Free;
    end;
  end;

  procedure ProcessData(DataSet: TBisDataSet; Sheet: OleVariant; var Row: Integer);
  var
    NewTown,OldTown: String;
    NewDistrict,OldDistrict: String;
    NewStreetHouse,OldStreetHouse: String;
    Range: OleVariant;
    S1,S2,S3: String;
    Field1,Field2,Field3: TField;
  begin
    FPosition:=0;
    FMax:=DataSet.RecordCount;
    AThread.Synchronize(SyncProgress);
    
    OldTown:=GetUniqueID;
    OldDistrict:=GetUniqueID;
    DataSet.First;
    while not DataSet.Eof do begin
      if AThread.Terminated then
        break;

      Field1:=DataSet.FieldByName(GetFN('E774322A3928ADC74A75A4E8815D6C4A'));
      NewTown:=Field1.AsString;
      if NewTown<>OldTown then begin
        Inc(Row);
        Range:=Sheet.Cells[Row,1];
        Range.Value:=AnsiUpperCase(iff(VarSameValue(Field1.Value,GetNullValue(Field1)),'��� �������� ����������� ������',NewTown));
        Range:=Sheet.Range[Sheet.Cells[Row,1],Sheet.Cells[Row,7]];
        Range.Merge;
        OldTown:=NewTown;
      end;

      Field1:=DataSet.FieldByName(GetFN('0538CA0399AB9FA9468D1A4741BA5090'));
      NewDistrict:=Field1.AsString;
      if NewDistrict<>OldDistrict then begin
        Inc(Row);
        Range:=Sheet.Cells[Row,1];
        Range.Value:=AnsiUpperCase(iff(VarSameValue(Field1.Value,GetNullValue(Field1)),'��� �������� ������',NewDistrict));
        Range:=Sheet.Range[Sheet.Cells[Row,1],Sheet.Cells[Row,7]];
        Range.Interior.ColorIndex:=1;
        Range.Font.Bold:=true;
        Range.Font.ColorIndex:=2;
        Range.Merge;
        OldDistrict:=NewDistrict;
      end;

      Field1:=DataSet.FieldByName(GetFN('E7F33B7C110F96E240BC3C739F3172EB'));
      Field2:=DataSet.FieldByName(GetFN('251E5058A3518AA14A728599362FCE0B'));
      if VarSameValue(Field2.Value,GetNullValue(Field2)) then
        NewStreetHouse:=Format('[%s]',[Field1.AsString])
      else
        NewStreetHouse:=FormatEx('[%s, %s]',[Field1.AsString,Field2.AsString]);
      if NewStreetHouse<>OldStreetHouse then begin
        Inc(Row);
        Range:=Sheet.Cells[Row,4];
        Range.Value:=iff(VarSameValue(Field1.Value,GetNullValue(Field1)),'[��� �������� �����]',NewStreetHouse);
        OldStreetHouse:=NewStreetHouse;
      end;

      Field1:=DataSet.FieldByName(GetFN('CE659B2F7353BD004164E11CF5B84711'));
      Inc(Row);
      Range:=Sheet.Cells[Row,1];
      Range.Value:=iff(VarSameValue(Field1.Value,GetNullValue(Field1)),'',Field1.AsString);
      Range.Font.Bold:=true;
      Range.Interior.ColorIndex:=15;
      Range.Borders[$0000000A].LineStyle:=$00000001;

      Field1:=DataSet.FieldByName(GetFN('A1BF4E0914809A1C4669F69D1477F627'));
      if VarSameValue(Field1.Value,GetNullValue(Field1)) then
        S1:=''
      else S1:=Field1.AsString;
      Field2:=DataSet.FieldByName(GetFN('A7E7C7A7C184956443532919F7C4852E'));
      if VarSameValue(Field2.Value,GetNullValue(Field2)) then
        S2:=''
      else S2:=Field2.AsString;
      Field3:=DataSet.FieldByName(GetFN('776FCE172335B3F444FE4225ACC8C543'));
      if VarSameValue(Field3.Value,GetNullValue(Field3)) then
        S3:=''
      else S3:=Field3.AsString;
      Range:=Sheet.Cells[Row,2];
      Range.Value:=FormatEx('%s/%s%s',[S1,S2,S3]);
      Range.Borders[$0000000A].LineStyle:=$00000001;

      S1:='';
      Field1:=DataSet.FieldByName(GetFN('A753A13C38F2846842B225E8FE9608F5'));
      if not VarSameValue(Field1.Value,GetNullValue(Field1)) then
        S1:=Field1.AsString;
      Field1:=DataSet.FieldByName(GetFN('93B2E581C50EAC7B4D4F7610B78639E9'));
      if not VarSameValue(Field1.Value,GetNullValue(Field1)) then
        S1:=iff(Trim(S1)<>'',S1+'/'+Field1.AsString,Field1.AsString);
      Field1:=DataSet.FieldByName(GetFN('1B5C7024F91CA674453748230A848286'));
      if not VarSameValue(Field1.Value,GetNullValue(Field1)) then
        S1:=iff(Trim(S1)<>'',S1+'/'+Field1.AsString,Field1.AsString);
      Range:=Sheet.Cells[Row,3];
      Range.Value:=S1;
      Range.Borders[$0000000A].LineStyle:=$00000001;

      S1:='';
      Field1:=DataSet.FieldByName(GetFN('D2744730B67587E64F188F456B71BC0B'));
      if not VarSameValue(Field1.Value,GetNullValue(Field1)) then
        S1:=Field1.AsString;
      Field1:=DataSet.FieldByName(GetFN('AF5827387B5B969945648D50FA542E63'));
      if not VarSameValue(Field1.Value,GetNullValue(Field1)) then
        S1:=iff(Trim(S1)<>'',S1+', '+Field1.AsString,Field1.AsString);
      Field1:=DataSet.FieldByName(GetFN('4C1A1DC2B73D9529446CF484607150A8'));
      if not VarSameValue(Field1.Value,GetNullValue(Field1)) then
        S1:=iff(Trim(S1)<>'',S1+', '+Field1.AsString,Field1.AsString);
      Field1:=DataSet.FieldByName(GetFN('9C1E4655E9DFB674480FA4EE3D78D907'));
      if not VarSameValue(Field1.Value,GetNullValue(Field1)) then
        S1:=iff(Trim(S1)<>'',S1+', '+Field1.AsString,Field1.AsString);
      Field1:=DataSet.FieldByName(GetFN('A689766CFE41A9EB40AC456AA3B23C76'));
      if not VarSameValue(Field1.Value,GetNullValue(Field1)) then
        S1:=iff(Trim(S1)<>'',S1+', '+Field1.AsString,Field1.AsString);
      Range:=Sheet.Cells[Row,4];
      Range.Value:=S1;
      Range.Borders[$0000000A].LineStyle:=$00000001;

      Field1:=DataSet.FieldByName(GetFN('271300892F008CDD46CF6DDD4769FE9A'));
      Range:=Sheet.Cells[Row,5];
      Range.Value:=iff(VarSameValue(Field1.Value,GetNullValue(Field1)),'',Field1.AsString);
      Range.Font.Bold:=true;
      Range.Interior.ColorIndex:=15;
      Range.Borders[$0000000A].LineStyle:=$00000001;

      Field1:=DataSet.FieldByName(GetFN('1A600A207C6BA0C24C7597AA954D9A04'));
      Range:=Sheet.Cells[Row,6];
      Range.Value:=iff(VarSameValue(Field1.Value,GetNullValue(Field1)),'',Field1.AsString);
      Range.Borders[$0000000A].LineStyle:=$00000001;

      Field1:=DataSet.FieldByName('DESIGN_NAME');
      Range:=Sheet.Cells[Row,7];
      Range.Value:=iff(VarSameValue(Field1.Value,GetNullValue(Field1)),'',Field1.AsString);
      Range.Borders[$0000000A].LineStyle:=$00000001;


      Range:=Sheet.Range[Sheet.Cells[Row,1],Sheet.Cells[Row,7]];
      Range.Borders[$00000009].LineStyle:=$00000001;
      Range.Borders[$00000007].LineStyle:=$00000001;
      Range.Borders[$0000000A].LineStyle:=$00000001;
      Range.Borders[$00000008].LineStyle:=$00000001;

      Inc(FPosition);
      AThread.Synchronize(SyncProgress);

      DataSet.Next;
    end;
  end;

var
  Success: Boolean;
  Excel: OleVariant;
  WorkBook: OleVariant;
  Sheet: OleVariant;
  Range: OleVariant;
  Stream: TMemoryStream;
  Sortings: TStringList;
  DataSet: TBisDataSet;
  T1: TTime;
  Row: Integer;
begin
  Success:=false;
  try
    T1:=Time;
    CoInitialize(nil);
    PParams:=TBisProvider.Create(nil);
    DataSet:=TBisDataSet.Create(nil);
    Stream:=TMemoryStream.Create;
    Sortings:=TStringList.Create;
    try
      FPosition:=0;
      FMax:=0;
      AThread.Synchronize(SyncProgress);

      PParams.WithWaitCursor:=false;
      PParams.ProviderName:='S_PARAMS';
      PParams.FilterGroups.Add.Filters.Add('LOCKED',fcEqual,0);
      PParams.Open;
      if PParams.Active and not PParams.Empty then begin

        Sortings.Add('E774322A3928ADC74A75A4E8815D6C4A'); // ���������� �����
        Sortings.Add('0538CA0399AB9FA9468D1A4741BA5090'); // �����
        Sortings.Add('E7F33B7C110F96E240BC3C739F3172EB'); // �����
        Sortings.Add('251E5058A3518AA14A728599362FCE0B'); // ����� ����
        Sortings.Add('CE659B2F7353BD004164E11CF5B84711'); // �����������

        ProcessObjects(DataSet,
                       '6ECFE94699F1B91B48FC58BBFB4E680F',
                       '9D0659F6DCAB913D40C3E391622AF719',
                       '9BB38FBAEE8B88A54FD02C983AE5C607',Sortings);

        if DataSet.Active and not DataSet.Empty then begin

          Excel:=CreateOleObject('Excel.Application');
          if not VarIsNull(Excel) then begin
            WorkBook:=Excel.WorkBooks.Add;

            Sheet:=WorkBook.Sheets.Item[1];
            Sheet.Columns[1].ColumnWidth:=7;
            Sheet.Columns[1].HorizontalAlignment:=$FFFFEFF4;
            Sheet.Columns[1].NumberFormat:='@';

            Sheet.Columns[2].ColumnWidth:=12;
            Sheet.Columns[2].HorizontalAlignment:=$FFFFEFF4;
            Sheet.Columns[2].NumberFormat:='@';

            Sheet.Columns[3].ColumnWidth:=10;
            Sheet.Columns[3].HorizontalAlignment:=$FFFFEFF4;
            Sheet.Columns[3].NumberFormat:='@';

            Sheet.Columns[4].ColumnWidth:=50;
            Sheet.Columns[4].HorizontalAlignment:=$FFFFEFF4;
            Sheet.Columns[4].NumberFormat:='@';

            Sheet.Columns[5].ColumnWidth:=12;
            Sheet.Columns[5].HorizontalAlignment:=$FFFFEFF4;
            Sheet.Columns[5].NumberFormat:='@';
            
            Sheet.Columns[6].ColumnWidth:=30;
            Sheet.Columns[6].HorizontalAlignment:=$FFFFEFF4;
            Sheet.Columns[6].NumberFormat:='@';

            Sheet.Columns[7].ColumnWidth:=12;
            Sheet.Columns[7].HorizontalAlignment:=$FFFFEFF4;
            Sheet.Columns[7].NumberFormat:='@';

            Row:=1;

            Sheet.Cells[Row,1].Value:='��.';
            Sheet.Cells[Row,1].Interior.ColorIndex:=1;
            Sheet.Cells[Row,1].Font.ColorIndex:=2;

            Sheet.Cells[Row,2].Value:='�/�/�';
            Sheet.Cells[Row,2].Interior.ColorIndex:=1;
            Sheet.Cells[Row,2].Font.ColorIndex:=2;

            Sheet.Cells[Row,3].Value:='��., �2';
            Sheet.Cells[Row,3].Interior.ColorIndex:=1;
            Sheet.Cells[Row,3].Font.ColorIndex:=2;

            Sheet.Cells[Row,4].Value:='����������';
            Sheet.Cells[Row,4].Interior.ColorIndex:=1;
            Sheet.Cells[Row,4].Font.ColorIndex:=2;

            Sheet.Cells[Row,5].Value:='����,�.�.';
            Sheet.Cells[Row,5].Interior.ColorIndex:=1;
            Sheet.Cells[Row,5].Font.ColorIndex:=2;

            Sheet.Cells[Row,6].Value:='�������';
            Sheet.Cells[Row,6].Interior.ColorIndex:=1;
            Sheet.Cells[Row,6].Font.ColorIndex:=2;

            Sheet.Cells[Row,7].Value:='����������';
            Sheet.Cells[Row,7].Interior.ColorIndex:=1;
            Sheet.Cells[Row,7].Font.ColorIndex:=2;

            Range:=Sheet.Range[Sheet.Cells[Row,1],Sheet.Cells[Row,7]];
            Range.Font.Bold:=true;

            ProcessData(DataSet,Sheet,Row);

            DeleteFile(FFileName);
            WorkBook.SaveAs(FileName:=FFileName);
            Excel.Visible:=True;
            Success:=true;
          end;
        end;  
      end;
    finally
      Sortings.Free;
      Stream.Free;
      DataSet.Free;
      PParams.Free;
      LoggerWrite(TimeToStr(Time-T1));
      LoggerWrite(IntToStr(FPosition));
      AThread.Success:=Success;
    end;
  except
    On E: Exception do begin
      FLastError:=E.Message;
      AThread.Synchronize(ShowLastError);
    end;
  end;
end;

end.