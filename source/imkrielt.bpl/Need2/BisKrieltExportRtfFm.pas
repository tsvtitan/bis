unit BisKrieltExportRtfFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, ExtCtrls, Buttons, StdCtrls, ComCtrls, DB, Contnrs,
  VirtualTrees, VirtualDBTreeEx,
  BisFm, BisExecuteFm, BisDataSet, BisDbTree;

type
  TBisKrieltExportRtfForm = class(TBisExecuteForm)
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
    DataSource: TDataSource;
    PanelTree: TPanel;
    CheckBoxFull: TCheckBox;
    procedure ButtonIssueClick(Sender: TObject);
    procedure ButtonPublishingClick(Sender: TObject);
  private
    FFileName: String;
    FPosition: Integer;
    FMax: Integer;
    FPublishingId: Variant;
    FIssueId: Variant;
    FDataSet: TBisDataSet;
    FTemp: TBisDataSet;
    FTree: TBisDBTree;
    procedure ProgressVisible(AVisible: Boolean);
    procedure SyncProgress;
    procedure RefreshDataSet;
//    procedure TreeChecking(Sender: TBaseVirtualTree; Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
//    procedure TreeReadNodeFromDB(Sender: TBaseVirtualDBTreeEx; Node: PVirtualNode);
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

  TBisKrieltExportRtfFormIface=class(TBisExecuteFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltExportRtfForm: TBisKrieltExportRtfForm;

implementation

uses DateUtils, StrUtils,
     ALXmlDoc,
     BisConsts, BisUtils, BisProvider, BisFilterGroups, BisRtfStream, BisValues, BisVariants,
     BisKrieltDataIssuesFm, BisKrieltDataPublishingFm, BisKrieltDataParamEditFm;

{$R *.dfm}

type
  TBisKrieltNodes=class;

  TBisKrieltNode=class;

  TBisKrieltNodeParam=class(TObject)
  private
    FParamName: String;
    FValueString: String;
    FParamType: TBisKrieltDataParamType;
    FValueNumber: Extended;
    FValueDate: TDateTime;
    FValueBlob: String;
  public
    property ParamName: String read FParamName write FParamName;
    property ParamType: TBisKrieltDataParamType read FParamType write FParamType;
    property ValueString: String read FValueString write FValueString;
    property ValueNumber: Extended read FValueNumber write FValueNumber;
    property ValueDate: TDateTime read FValueDate write FValueDate;
    property ValueBlob: String read FValueBlob write FValueBlob;
  end;

  TBisKrieltNodeParams=class(TObjectList)
  private
    FParent: TBisKrieltNode;
    function GetItem(Index: Integer): TBisKrieltNodeParam;
  public
    function Add(ParamName: String): TBisKrieltNodeParam;
    property Parent: TBisKrieltNode read FParent write FParent;
    property Items[Index: Integer]: TBisKrieltNodeParam read GetItem; default;
  end;

  TBisKrieltNodeType=(ntNode,ntParams);

  TBisKrieltNode=class(TObject)
  private
    FName: String;
    FChilds: TBisKrieltNodes;
    FParams: TBisKrieltNodeParams;
    FViewId: Variant;
    FTypeId: Variant;
    FOperationId: Variant;
    FParamId: Variant;
    FParamType: TBisKrieltDataParamType;
    FParamSorting: TBisKrieltDataParamSorting;
    FCondition: TBisFilterCondition;
    FHead: String;
    FBody: String;
    FParamValue: String;
    FPattern: String;
    FNodeType: TBisKrieltNodeType;
  public
    constructor Create;
    destructor Destroy; override;

    property Name: String read FName write FName;
    property NodeType: TBisKrieltNodeType read FNodeType write FNodeType;  
    property ViewId: Variant read FViewId write FViewId;
    property TypeId: Variant read FTypeId write FTypeId;
    property OperationId: Variant read FOperationId write FOperationId;
    property ParamId: Variant read FParamId write FParamId;
    property ParamType: TBisKrieltDataParamType read FParamType write FParamType;
    property ParamSorting: TBisKrieltDataParamSorting read FParamSorting write FParamSorting;
    property ParamValue: String read FParamValue write FParamValue;
    property Condition: TBisFilterCondition read FCondition write FCondition;
    property Head: String read FHead write FHead;
    property Body: String read FBody write FBody;
    property Pattern: String read FPattern write FPattern; 

    property Childs: TBisKrieltNodes read FChilds;
    property Params: TBisKrieltNodeParams read FParams;
  end;

  TBisKrieltNodes=class(TObjectList)
  private
    FParent: TBisKrieltNode;
    function GetItem(Index: Integer): TBisKrieltNode;
  public
    function AddNode(Name: String;
                     ViewId,TypeId,OperationId,ParamId: Variant;
                     ParamType: TBisKrieltDataParamType; ParamSorting: TBisKrieltDataParamSorting;
                     ParamValue: String; Condition: TBisFilterCondition; Head,Body: String): TBisKrieltNode;
    function AddParams: TBisKrieltNode;

    property Parent: TBisKrieltNode read FParent write FParent;
    property Items[Index: Integer]: TBisKrieltNode read GetItem; default;
  end;

{ TBisKrieltNodeParams }

function TBisKrieltNodeParams.Add(ParamName: String): TBisKrieltNodeParam;
begin
  Result:=TBisKrieltNodeParam.Create;
  Result.ParamName:=ParamName;
  inherited Add(Result);
end;

function TBisKrieltNodeParams.GetItem(Index: Integer): TBisKrieltNodeParam;
begin
  Result:=TBisKrieltNodeParam(inherited Items[Index]);
end;


{ TBisKrieltNode }

constructor TBisKrieltNode.Create;
begin
  inherited Create;
  FChilds:=TBisKrieltNodes.Create;
  FChilds.Parent:=Self;
  FParams:=TBisKrieltNodeParams.Create;
  FParams.Parent:=Self;
end;

destructor TBisKrieltNode.Destroy;
begin
  FParams.Parent:=nil;
  FParams.Free;
  FChilds.Parent:=nil;
  FChilds.Free;
  inherited Destroy;
end;

{ TBisKrieltNodes }

function TBisKrieltNodes.AddNode(Name: String; ViewId,TypeId,OperationId,ParamId: Variant;
                                 ParamType: TBisKrieltDataParamType; ParamSorting: TBisKrieltDataParamSorting;
                                 ParamValue: String; Condition: TBisFilterCondition; Head,Body: String): TBisKrieltNode;
begin
  Result:=TBisKrieltNode.Create;
  Result.Name:=Name;
  Result.NodeType:=ntNode;
  Result.ViewId:=ViewId;
  Result.TypeId:=TypeId;
  Result.OperationId:=OperationId;
  Result.ParamId:=ParamId;
  Result.ParamType:=ParamType;
  Result.ParamSorting:=ParamSorting;
  Result.ParamValue:=ParamValue;
  Result.Condition:=Condition;
  Result.Head:=Head;
  Result.Body:=Body;
  inherited Add(Result);
end;

function TBisKrieltNodes.AddParams: TBisKrieltNode;
begin
  Result:=TBisKrieltNode.Create;
  Result.NodeType:=ntParams;
  inherited Add(Result);
end;

function TBisKrieltNodes.GetItem(Index: Integer): TBisKrieltNode;
begin
  Result:=TBisKrieltNode(inherited Items[Index]);
end;

{ TBisKrieltExportRtfFormIface }

constructor TBisKrieltExportRtfFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltExportRtfForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
end;

{ TBisKrieltExportRtfForm }

constructor TBisKrieltExportRtfForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SizesStored:=true;

  FDataSet:=TBisDataSet.Create(Self);
  with FDataSet.FieldDefs do begin
    Add('EXPORT_ID',ftString,32);
    Add('PARENT_ID',ftString,32);
    Add('VIEW_ID',ftString,32);
    Add('TYPE_ID',ftString,32);
    Add('OPERATION_ID',ftString,32);
    Add('PARAM_ID',ftString,32);
    Add('PARAM_TYPE',ftInteger);
    Add('PARAM_SORTING',ftInteger);
    Add('NAME',ftString,100);
    Add('EXPORT',ftString,100);
    Add('COND',ftInteger);
    Add('VALUE',ftString,100);
    Add('HEAD_RTF',ftBlob);
    Add('BODY_RTF',ftBlob);
//    Add('CHECKED',ftInteger);
  end;
  with FDataSet.FieldNames do begin
    Add('NAME','Наименование',250);
    with AddKey('EXPORT_ID') do begin
      Caption:='Идентификатор';
      Visible:=false;
    end;
    AddParentKey('PARENT_ID');
  end;
  FDataSet.CreateTable();
  DataSource.DataSet:=FDataSet;

  FTemp:=TBisDataSet.Create(Self);
  FTemp.CreateTable(FDataSet);

  FTree:=TBisDBTree.Create(Self);
  FTree.Parent:=PanelTree;
  FTree.Align:=alClient;
  FTree.SortEnabled:=false;
  FTree.NavigatorVisible:=true;
  FTree.NumberVisible:=false;
  FTree.SearchEnabled:=true;
  FTree.SortColumnVisible:=true;
  FTree.ChessVisible:=true;
  FTree.GridEmulate:=false;
  FTree.RowVisible:=true;
  FTree.ReadOnly:=true;
  FTree.AutoResizeableColumns:=true;
  FTree.CopyFromFieldNames(FDataSet.FieldNames);
  FTree.DataSource:=DataSource;
  FTree.GradientVisible:=true;
//  FTree.TreeOptions.MiscOptions:=FTree.TreeOptions.MiscOptions+[toCheckSupport];
//  FTree.DBOptions:=FTree.DBOptions+[dboShowChecks,dboAllowChecking];
  FTree.Images:=ImageList;
//  FTree.OnChecking:=TreeChecking;
//  FTree.OnReadNodeFromDB:=TreeReadNodeFromDB;
  FTree.NormalIndex:=2;
  FTree.OpenIndex:=3;
  FTree.LastIndex:=4;

  RefreshDataSet;

  FTree.CollapseAll;

  ProgressVisible(false);

  DateTimePickerBeginFrom.Date:=DateOf(Date);
  DateTimePickerBeginTo.Date:=DateOf(Date);
  
  FPublishingId:=Null;
  FIssueId:=Null;
end;

destructor TBisKrieltExportRtfForm.Destroy;
begin

  inherited Destroy;
end;

procedure TBisKrieltExportRtfForm.DoTerminate;
begin
  inherited DoTerminate;
  ProgressVisible(false);
  EnableControl(PanelControls,true);
end;

procedure TBisKrieltExportRtfForm.RefreshDataSet;
var
  P: TBisProvider;
begin
  FDataSet.EmptyTable;
  FDataSet.BeginUpdate;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_EXPORTS';
    with P.Orders do begin
      Add('LEVEL');
      Add('PRIORITY');
    end;
    P.Open;
    if P.Active and not P.Empty then begin
      P.First;
      while not P.Eof do begin
        FDataSet.Append;
        FDataSet.CopyRecord(P,false,false);
//        FDataSet.FieldByName('CHECKED').AsInteger:=Integer(True);
        FDataSet.Post;
        P.Next;
      end;
    end;
  finally
    FDataSet.First;
    FDataSet.EndUpdate;
    P.Free;
  end;
end;

procedure TBisKrieltExportRtfForm.ButtonIssueClick(Sender: TObject);
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

procedure TBisKrieltExportRtfForm.ButtonPublishingClick(Sender: TObject);
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

function TBisKrieltExportRtfForm.CanOptions: Boolean;
begin
  Result:=false;
end;

procedure TBisKrieltExportRtfForm.ProgressVisible(AVisible: Boolean);
begin
  ProgressBar.Visible:=AVisible;
  if AVisible then begin
    PanelButtons.Height:=65;
  end else begin
    PanelButtons.Height:=40;
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

function TBisKrieltExportRtfForm.CanStart: Boolean;
begin
  Result:=inherited CanStart and not VarIsNull(FPublishingId);
end;

procedure TBisKrieltExportRtfForm.Start;
begin
  if CanStart then begin
    if SaveDialog.Execute then begin
      FFileName:=SaveDialog.FileName;
      FTemp.EmptyTable;
      FTemp.CopyRecords(FDataSet);
      inherited Start;
      ProgressVisible(true);
      EnableControl(PanelControls,false);
    end;
  end;
end;

procedure TBisKrieltExportRtfForm.SyncProgress;
begin
  ProgressBar.Position:=FPosition;
  ProgressBar.Max:=FMax;
  ProgressBar.Update;
end;

procedure TBisKrieltExportRtfForm.ThreadExecute(AThread: TBisExecuteFormThread);
var
  DSParamValues: TBisDataSet;
  DSPatterns: TBisProvider;
  DSParams: TBisProvider;
  DSObjects: TBisDataSet;

  procedure ProcessParam(ParamId: Variant; ParamSorting: TBisKrieltDataParamSorting;
                         ParamExports, ParamDescriptions: TBisVariants);

    procedure FillParamNames(DS: TBisDataSet);
    var
      AName, AExport, ADesc: String;
    begin
      DS.First;
      while not DS.Eof do begin
        AName:=Trim(DS.FieldByName('NAME').AsString);

        AExport:=Trim(DS.FieldByName('EXPORT').AsString);
        if AExport='' then
          AExport:=AName;
        ParamExports.Add(AExport);

        ADesc:=Trim(DS.FieldByName('DESCRIPTION').AsString);
        if ADesc='' then
          ADesc:=AName;
        ParamDescriptions.Add(ADesc);

        DS.Next;
      end;
    end;

  var
    Exists: Boolean;
    P: TBisProvider;
    DS: TBisDataSet;
    Stream: TMemoryStream;
  begin
    Stream:=TMemoryStream.Create;
    try
      Exists:=DSParamValues.Locate('PARAM_ID',ParamId,[loCaseInsensitive]);
      if not Exists then begin
        P:=TBisProvider.Create(nil);
        try
          P.WithWaitCursor:=false;
          P.ProviderName:='S_PARAM_VALUES';
          with P.FieldNames do begin
            AddInvisible('NAME');
            AddInvisible('EXPORT');
            AddInvisible('DESCRIPTION');
          end;
          P.FilterGroups.Add.Filters.Add('PARAM_ID',fcEqual,ParamId).CheckCase:=true;
          case ParamSorting of
            dpsName: P.Orders.Add('NAME');
            dpsPriority: P.Orders.Add('PRIORITY');
          end;
          P.Open;
          if P.Active and not P.Empty then begin
            P.SaveToStream(Stream);
            Stream.Position:=0;
            DSParamValues.Append;
            DSParamValues.FieldByName('PARAM_ID').Value:=ParamId;
            TBlobField(DSParamValues.FieldByName('DATASET')).LoadFromStream(Stream);
            DSParamValues.Post;
            FillParamNames(P);
          end;
        finally
          P.Free;
        end;
      end else begin
        DS:=TBisDataSet.Create(nil);
        try
          TBlobField(DSParamValues.FieldByName('DATASET')).SaveToStream(Stream);
          Stream.Position:=0;
          DS.LoadFromStream(Stream);
          DS.Open;
          if DS.Active and not DS.Empty then
            FillParamNames(DS);
        finally
          DS.Free;
        end;
      end;
    finally
      Stream.Free;
    end;
  end;

  procedure ProcessPatterns(ExportId: Variant; NewPatterns, OldPatterns: TBisValues);
  var
    DesignId: String;
    Pattern: TBisValue;
    i: Integer;
  begin
    DSPatterns.Filtered:=false;
    DSPatterns.Filter:=FormatEx('EXPORT_ID=%s',[QuotedStr(VarToStrDef(ExportId,''))]);
    DSPatterns.Filtered:=true;
    if DSPatterns.Active and not DSPatterns.Empty then begin
      DSPatterns.First;
      while not DSPatterns.Eof do begin
        DesignId:=VarToStrDef(DSPatterns.FieldByName('DESIGN_ID').Value,'');
        NewPatterns.Add(DesignId,DSPatterns.FieldByName('RTF').AsString);
        DSPatterns.Next;
      end;
    end;
    for i:=0 to OldPatterns.Count-1 do begin
      Pattern:=OldPatterns.Items[i];
      if not Assigned(NewPatterns.Find(Pattern.Name)) then
        NewPatterns.Add(Pattern.Name,Pattern.Value);
    end;
  end;

  function ChildExists(ParentId: Variant): Boolean;
  begin
    FTemp.Filtered:=false;
    if VarisNull(ParentId) then
      FTemp.Filter:='PARENT_ID IS NULL'
    else
      FTemp.Filter:=FormatEx('PARENT_ID=%s',[QuotedStr(VarToStrDef(ParentId,''))]);
    FTemp.Filtered:=true;  
    Result:=FTemp.RecordCount>0;
  end;

  procedure ProcessObjects(ParentNodes: TBisKrieltNodes; ViewId,TypeId,OperationId: Variant;
                           Patterns: TBisValues; Filters: TBisFilters);

    function GetFN(S: String): String;
    begin
      Result:='P'+S;
    end;

    function CreateObjectsDataSet: TBisDataSet;
    var
      AParamId: String;
      AMaxLength: Integer;
      AParamType: TBisKrieltDataParamType;
      ADataType: TFieldType;
      FlagSupport: Boolean;
    begin
      Result:=TBisDataSet.Create(nil);
      with Result.FieldDefs do begin
        Add('OBJECT_ID',ftString,32);
        Add('DESIGN_ID',ftString,32);
      end;
      DSParams.First;
      while not DSParams.Eof do begin
        AParamId:=DSParams.FieldByName('PARAM_ID').AsString;
        AMaxLength:=DSParams.FieldByName('MAX_LENGTH').AsInteger;
        AParamType:=TBisKrieltDataParamType(DSParams.FieldByName('PARAM_TYPE').AsInteger);
        ADataType:=ftString;
        FlagSupport:=true;
        case AParamType of
          dptList,dptString,dptLink: ADataType:=ftString;
          dptInteger: ADataType:=ftInteger;
          dptFloat: ADataType:=ftFloat;
          dptDate: ADataType:=ftDate;
          dptDateTime: ADataType:=ftDateTime;
          dptImage, dptDocument, dptVideo: FlagSupport:=false;
        else
          FlagSupport:=false;
        end;
        if FlagSupport then
          Result.FieldDefs.Add(GetFN(AParamId),ADataType,AMaxLength,false);
        DSParams.Next;
      end;
      Result.CreateTable;
    end;

    procedure ApplyFilter(DS: TBisDataSet);
    var
      i: Integer;
      Filter: TBisFilter;
      Str: TStringList;
      Condition: String;
      Value: Variant;
      Field: TField;
      FN: String;
      S: String;
    begin
      Str:=TStringList.Create;
      try
        DS.Filtered:=false;
        for i:=0 to Filters.Count-1 do begin
          Filter:=Filters[i];
          FN:=GetFN(Filter.FieldName);
          Field:=DS.FindField(FN);
          if Assigned(Field) then begin
            Condition:='';
            case Filter.Condition of
              fcEqual: Condition:='=';
              fcGreater: Condition:='>';
              fcLess: Condition:='<';
              fcNotEqual: Condition:='<>';
              fcEqualGreater: Condition:='>=';
              fcEqualLess: Condition:='<=';
              fcLike: Condition:='LIKE';
              fcNotLike: Condition:='NOT LIKE';
              fcIsNull: Condition:='IS NULL';
              fcIsNotNull: Condition:='IS NOT NULL';
            end;
            Value:=Filter.Value;
            case Field.DataType of
              ftString: begin
                if not VarIsNull(Value) then
                  Value:=QuotedStr(VarToStrDef(Value,''));
              end;
              ftInteger: ;
              ftFloat:;
              ftDate: begin
                if not VarIsNull(Value) then
                  Value:=QuotedStr(VarToStrDef(Value,''));
              end;
              ftDateTime: begin
                if not VarIsNull(Value) then
                  Value:=QuotedStr(VarToStrDef(Value,''));
              end;
            end;
            Str.Add(FormatEx('%s %s %s',[GetFN(Filter.FieldName),Condition,Value]));
          end;
        end;
        S:=GetFilterString(Str,'AND');
        DS.Filter:=S;
        DS.Filtered:=Trim(DS.Filter)<>'';
      finally
        Str.Free;
      end;
    end;

    procedure FillNodeParams(DS: TBisDataSet);
    var
      Node: TBisKrieltNode;
      NodeParam: TBisKrieltNodeParam;
      Pattern: TBisValue;
      Field: TField;
      ParamExists: Boolean;
      i: Integer;
      FN: String;
    begin
      DS.First;
      while not DS.Eof do begin
        if AThread.Terminated then
          break;

        Node:=ParentNodes.AddParams;
        Node.Name:=DS.FieldByName('OBJECT_ID').AsString;
        Node.Body:=ParentNodes.Parent.Body;
        Pattern:=Patterns.Find(DS.FieldByName('DESIGN_ID').AsString);
        if Assigned(Pattern) then
          Node.Pattern:=VarToStrDef(Pattern.Value,'');

        for i:=2 to DS.Fields.Count-1 do begin
          Field:=DS.Fields[i];
          FN:=Copy(Field.FieldName,2,MaxInt);
          ParamExists:=DSParams.Locate('PARAM_ID',FN,[loCaseInsensitive]);
          if ParamExists then begin
            NodeParam:=Node.Params.Add(DSParams.FieldByName('NAME').AsString);
            NodeParam.ParamType:=TBisKrieltDataParamType(DSParams.FieldByName('PARAM_TYPE').AsInteger);
            case NodeParam.ParamType of
              dptList,dptString,dptLink: NodeParam.ValueString:=Trim(Field.AsString);
              dptInteger,dptFloat: NodeParam.ValueNumber:=Field.AsFloat;
              dptDate,dptDateTime: NodeParam.ValueDate:=Field.AsDateTime;
              dptImage,dptDocument,dptVideo: NodeParam.ValueBlob:=Trim(Field.AsString);
            end;
          end;
        end;

        DS.Next;
      end;
    end;

  var
    ObjectExists: Boolean;
    P: TBisProvider;
    ObjectId,OldObjectId: Variant;
    ParamId: String;
    ParamType: TBisKrieltDataParamType;
    Stream: TMemoryStream;
    DS: TBisDataSet;
    Value: Variant;
  begin
    Stream:=TMemoryStream.Create;
    try
      ObjectExists:=DSObjects.Locate('VIEW_ID;TYPE_ID;OPERATION_ID',
                                     VarArrayOf([ViewId,TypeId,OperationId]),
                                     [loCaseInsensitive]);
      if not ObjectExists then begin
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
            DS:=CreateObjectsDataSet;
            try
              DSObjects.Append;
              DSObjects.FieldByName('VIEW_ID').Value:=ViewId;
              DSObjects.FieldByName('TYPE_ID').Value:=TypeId;
              DSObjects.FieldByName('OPERATION_ID').Value:=OperationId;
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
              DS.SaveToStream(Stream);
              Stream.Position:=0;
              TBlobField(DSObjects.FieldByName('DATASET')).LoadFromStream(Stream);
              DSObjects.Post;
              ApplyFilter(DS);
              FillNodeParams(DS);
            finally
              DS.Free;
            end;
          end;
        finally
          P.Free;
        end;
      end else begin
        DS:=TBisDataSet.Create(nil);
        try
          TBlobField(DSObjects.FieldByName('DATASET')).SaveToStream(Stream);
          Stream.Position:=0;
          DS.LoadFromStream(Stream);
          DS.Open;
          if DS.Active and not DS.Empty then begin
            ApplyFilter(DS);
            FillNodeParams(DS);
          end;
        finally
          DS.Free;
        end;
      end;
    finally
      Stream.Free;
    end;
  end;
  
  procedure BuildFilters(Filters: TBisFilters; ParamId: Variant; ParamType: TBisKrieltDataParamType;
                         Condition: TBisFilterCondition; Value: String);
  var
    V: Variant;
    FieldName: String;
    Support: Boolean;
  begin
    if not VarIsNull(ParamId) then begin
      V:=Null;
      FieldName:=VarToStrDef(ParamId,'');
      Support:=true;
      case ParamType of
        dptList,dptString,dptLink: begin
          if Value<>'' then
            V:=Value;
        end;
        dptInteger: begin
          if Value<>'' then
            V:=StrToIntDef(Value,0);
        end;
        dptFloat: begin
          if Value<>'' then
            V:=StrToFloatDef(Value,0.0);
        end;
        dptDate: begin
          if Value<>'' then
            V:=StrToDateDef(Value,NullDate);
        end;
        dptDateTime: begin
          if Value<>'' then
            V:=StrToDateTimeDef(Value,NullDate);
        end;
        dptImage,dptDocument,dptVideo: Support:=false;
      end;
      if Support then
        Filters.Add(FieldName,Condition,V);
    end;
  end;

  function ProcessData(ParentNodes: TBisKrieltNodes;
                       ParentId,ParentViewId,ParentTypeId,ParentOperationId,ParentParamId: Variant;
                       ParentHead,ParentBody: String; ParentPatterns: TBisValues; ParentFilters: TBisFilters;
                       IncPosition: Boolean): Boolean;
  var
    DS: TBisDataSet;
    ExportId: Variant;
    ViewId: Variant;
    TypeId: Variant;
    OperationId: Variant;
    ParamId: Variant;
    ParamType: Variant;
    AParamType: TBisKrieltDataParamType;
    ParamSorting: Variant;
    AParamSorting: TBisKrieltDataParamSorting;
    Conditon: Variant;
    ACondition: TBisFilterCondition;
    Head, Body: String;
    Value: String;
    Name: String;
    ParamExports, ParamDescriptions: TBisVariants;
    Patterns: TBisValues;
    NewName: Boolean;
    i: Integer;
    Node: TBisKrieltNode;
    Filters, NewFilters: TBisFilters;
    TempCount: Integer;
  begin
    DS:=TBisDataSet.Create(nil);
    ParamExports:=TBisValues.Create;
    ParamDescriptions:=TBisValues.Create;
    Patterns:=TBisValues.Create;
    Filters:=TBisFilters.Create;
    NewFilters:=TBisFilters.Create;
    try
      FTemp.Filtered:=false;
      if VarisNull(ParentId) then
        FTemp.Filter:='PARENT_ID IS NULL'
      else
        FTemp.Filter:=FormatEx('PARENT_ID=%s',[QuotedStr(VarToStrDef(ParentId,''))]);
      FTemp.Filtered:=true;
      DS.CreateTable(FTemp);
      DS.CopyRecords(FTemp);

      Result:=DS.Active and not DS.Empty;
      if Result then begin

        TempCount:=DS.RecordCount;
//        FMax:=FMax+TempCount;
      {  if (FMax-TempCount)>0 then
          FPosition:=Round((FPosition*FMax)/(FMax-TempCount));}

        DS.First;
        while not DS.Eof do begin
          if AThread.Terminated then
            break;
            
          ExportId:=DS.FieldByName('EXPORT_ID').Value;

          Name:=DS.FieldByName('EXPORT').AsString;
          if Trim(Name)='' then
            Name:=DS.FieldByName('NAME').AsString;

          ViewId:=DS.FieldByName('VIEW_ID').Value;
          if VarIsNull(ViewId) then
            ViewId:=ParentViewId;

          TypeId:=DS.FieldByName('TYPE_ID').Value;
          if VarIsNull(TypeId) then
            TypeId:=ParentTypeId;

          OperationId:=DS.FieldByName('OPERATION_ID').Value;
          if VarIsNull(OperationId) then
            OperationId:=ParentOperationId;

          Head:=DS.FieldByName('HEAD_RTF').AsString;
          if Trim(Head)='' then
            Head:=ParentHead;

          Body:=DS.FieldByName('BODY_RTF').AsString;
          if Trim(Body)='' then
            Body:=ParentBody;

          Patterns.Clear;
          ProcessPatterns(ExportId,Patterns,ParentPatterns);

          ParamId:=DS.FieldByName('PARAM_ID').Value;
          ParamType:=DS.FieldByName('PARAM_TYPE').Value;
          AParamType:=TBisKrieltDataParamType(VarToIntDef(ParamType,Integer(dptList)));
          ParamSorting:=DS.FieldByName('PARAM_SORTING').Value;
          AParamSorting:=TBisKrieltDataParamSorting(VarToIntDef(ParamSorting,Integer(dpsNone)));
          Conditon:=DS.FieldByName('COND').Value;
          ACondition:=TBisFilterCondition(VarToIntDef(Conditon,Integer(fcIsNotNull)));
          Value:=Trim(DS.FieldByName('VALUE').AsString);

          NewName:=false;
          if not VarIsNull(ParamId) and not VarIsNull(ParamType) then
            NewName:=(AParamType=dptList) and (ACondition=fcIsNotNull);

          Filters.Clear;
          Filters.CopyFrom(ParentFilters);
          BuildFilters(Filters,ParamId,AParamType,ACondition,Value);

          if NewName then begin

            ParamExports.Clear;
            ParamDescriptions.Clear;
            ProcessParam(ParamId,AParamSorting,ParamExports,ParamDescriptions);

{            TempCount:=ParamDescriptions.Count;
            if TempCount>0 then begin
              if FPosition>0 then
                FMax:=Round((FMax*(FPosition+TempCount))/FPosition);
             end;}

            for i:=0 to ParamDescriptions.Count-1 do begin
              if AThread.Terminated then
                break;

              Name:=VarToStrDef(ParamDescriptions.Items[i].Value,'');

              NewFilters.Clear;
              NewFilters.CopyFrom(Filters);

              BuildFilters(NewFilters,ParamId,dptList,fcEqual,VarToStrDef(ParamExports.Items[i].Value,''));

              Node:=ParentNodes.AddNode(Name,ViewId,TypeId,OperationId,
                                        ParamId,AParamType,AParamSorting,Value,ACondition,Head,Body);
              if ChildExists(ExportId) then
                ProcessData(Node.Childs,ExportId,ViewId,TypeId,OperationId,ParamId,Head,Body,Patterns,NewFilters,false)
              else
                ProcessObjects(Node.Childs,ViewId,TypeId,OperationId,Patterns,NewFilters);

  {            Inc(FPosition);
              AThread.Synchronize(SyncProgress);

              Sleep(100);}
            end;

          end else begin

            Node:=ParentNodes.AddNode(Name,ViewId,TypeId,OperationId,
                                      ParamId,AParamType,AParamSorting,Value,ACondition,Head,Body);

            if IncPosition then begin
              Inc(FPosition);
              AThread.Synchronize(SyncProgress);
              Sleep(100);
            end;
                                      
            if ChildExists(ExportId) then
              ProcessData(Node.Childs,ExportId,ViewId,TypeId,OperationId,ParamId,Head,Body,Patterns,Filters,IncPosition)
            else
              ProcessObjects(Node.Childs,ViewId,TypeId,OperationId,Patterns,Filters);

          end;

          DS.Next;
        end;
      end;
    finally
      NewFilters.Free;
      Filters.Free;
      Patterns.Free;
      ParamExports.Free;
      ParamDescriptions.Free;
      DS.Free;
    end;
  end;

  procedure DeleteEmptyNodes(ParentNodes: TBisKrieltNodes);
  var
    i: Integer;
    Node: TBisKrieltNode;
  begin
    for i:=ParentNodes.Count-1 downto 0 do begin
      Node:=ParentNodes[i];
      DeleteEmptyNodes(Node.Childs);
      if (Node.Childs.Count=0) and
         (Node.Params.Count=0) then begin
        ParentNodes.Delete(i);
      end;
    end;
  end;
  
  procedure CreateString(Pattern, Design: String; Values: TBisValues; Stream: TBisRtfStream);

    function ReplaceCodes(S: String): String;
    var
      i: Integer;
      H: String;
      S1: String;
    begin
      Result:=S;
      for i:=0 to 255 do begin
        H:='#'+IntToHex(i,2);
        S1:=Char(i);
        Result:=ReplaceText(Result,H,S1);
      end;
    end;

    procedure ProcessNode(ParentNode: TALXMLNode; ParentFont: TFont);
    var
      NodeFont: TFont;
      IsFont: Boolean;
      IsParam: Boolean;
      IsDesign: Boolean;
      ParamExists: Boolean;
      AColor: String;
      NodeColor: TColor;
      NodeBold: Boolean;
      S: String;
      Item: TBisValue;
      i: Integer;
      Node: TALXMLNode;
      ALine: Integer;
      AName: String;
      V: String;
      Flag: Boolean;
    begin
      IsFont:=AnsiSameText(ParentNode.NodeName,'F');
      NodeFont:=ParentFont;
      if IsFont then begin
        NodeFont:=TFont.Create;
        NodeFont.Assign(ParentFont);
        
        NodeFont.Size:=VarToIntDef(ParentNode.Attributes['size'],NodeFont.Size);
        NodeFont.Name:=VarToStrDef(ParentNode.Attributes['name'],NodeFont.Name);

        NodeColor:=NodeFont.Color;
        AColor:=Trim(VarToStrDef(ParentNode.Attributes['color'],''));
        if AColor<>'' then
          NodeColor:=StrToIntDef('$'+AColor,NodeColor);
        NodeFont.Color:=NodeColor;

        NodeBold:=fsBold in NodeFont.Style;
        NodeBold:=Boolean(VarToIntDef(ParentNode.Attributes['bold'],Integer(NodeBold)));
        if NodeBold then
          NodeFont.Style:=NodeFont.Style+[fsBold]
        else
          NodeFont.Style:=NodeFont.Style-[fsBold];
      end;
      try
        if not ParentNode.IsTextElement then begin
          for i:=0 to ParentNode.ChildNodes.Count-1 do begin
            Node:=ParentNode.ChildNodes[i];
            ProcessNode(Node,NodeFont);
          end;
        end else begin
          IsParam:=AnsiSameText(ParentNode.NodeName,'P');
          IsDesign:=AnsiSameText(ParentNode.NodeName,'D');
          if IsParam or IsDesign then begin
            S:=VarToStrDef(ParentNode.NodeValue,'');
            AName:=Trim(VarToStrDef(ParentNode.Attributes['name'],''));
            Item:=Values.Find(AName);
            V:='';
            Flag:=true;
            if Assigned(Item) then begin
              V:=Trim(VarToStrDef(Item.Value,''));
              Flag:=V<>'';
              if Flag then
                S:=ReplaceText(S,'%',V)
              else
                S:=V;
            end else begin
              if IsParam then begin
                if AName<>'' then begin
                  ParamExists:=DSParams.Locate('NAME',AName,[loCaseInsensitive]);
                  if not ParamExists then
                    S:=Trim(ParentNode.XML)
                  else
                    Flag:=false;  
                end;
              end;
              if IsDesign then
                S:=ReplaceText(S,'%',Design);
            end;
            if Flag then begin
              S:=ReplaceCodes(S);
              ALine:=VarToIntDef(ParentNode.Attributes['line'],0);
              for i:=0 to ALine-1 do
                Stream.CreateString('',NodeFont,true);
              Stream.CreateString(S,NodeFont,false);
            end;
          end;
        end;
      finally
        if IsFont then
          NodeFont.Free;
      end;
    end;

  var
    Xml: TALXmlDocument;
    Str: TStringList;
    i: Integer;
    Node: TALXMLNode;
  begin
    Xml:=TALXmlDocument.Create(nil);
    Str:=TStringList.Create;
    try
      Str.Add(Pattern);
      try
        Xml.LoadFromXML(Trim(Str.Text));
        for i:=0 to Xml.ChildNodes.Count-1 do begin
          Node:=Xml.ChildNodes[i];
          ProcessNode(Node,Self.Font);
          Stream.CreateString('',Self.Font,true);
        end;
      except
        On E: Exception do begin
          Stream.CreateString(E.Message,Self.Font,true);
        end;
      end;
    finally
      Str.Free;
      Xml.Free;
    end;
  end;

  procedure ProcessNodeParams(ParentNode: TBisKrieltNode; Stream: TBisRtfStream);

    function CheckXmlPattern(S: String): Boolean;
    var
      Xml: TALXmlDocument;
    begin
      Result:=false;
      if S<>'' then begin
        Xml:=TALXmlDocument.Create(nil);
        try
          try
            Xml.LoadFromXML(S);
            Result:=Xml.ChildNodes.Count>0;
          except
            On E: Exception do begin
              //
            end;
          end;
        finally
          Xml.Free;
        end;
      end;
    end;

  var
    i: Integer;
    NodeParam: TBisKrieltNodeParam;
    Values: TBisValues;
    Value: String;
    S: String;
    Design: String;
  begin
    Values:=TBisValues.Create;
    try
      for i:=0 to ParentNode.Params.Count-1 do begin
        NodeParam:=ParentNode.Params[i];
        Value:='';
        case NodeParam.ParamType of
          dptList,dptString,dptLink: Value:=NodeParam.ValueString;
          dptInteger: Value:=IntToStr(Trunc(NodeParam.ValueNumber));
          dptFloat: Value:=FloatToStr(NodeParam.ValueNumber);
          dptDate: Value:=DateToStr(NodeParam.ValueDate);
          dptDateTime: Value:=DateTimeToStr(NodeParam.ValueDate);
          dptImage: Value:='Изображение';
          dptDocument: Value:='Документ';
          dptVideo: Value:='Видео';
        end;
        Values.Add(NodeParam.ParamName,Value);
      end;
      if Values.Count>0 then begin

        Design:='';
        S:=Trim(ParentNode.Pattern);
        if S<>'' then begin
          if not CheckXmlPattern(S) then begin
            Design:=S;
            S:=Trim(ParentNode.Body);
          end;
        end else begin
          S:=Trim(ParentNode.Body);
        end;

        if S<>'' then
          CreateString(S,Design,Values,Stream)
        else
          Stream.CreateString(ParentNode.Name,Self.Font,true); 
      end;
    finally
      Values.Free;
    end;
  end;

  procedure ProcessNodes(ParentNodes: TBisKrieltNodes; Stream: TBisRtfStream);
  var
    i: Integer;
    Node: TBisKrieltNode;
    Values: TBisValues;
  begin
    Values:=TBisValues.Create;
    try
      for i:=0 to ParentNodes.Count-1 do begin
        Node:=ParentNodes[i];

        Values.Clear;
        Values.Add('VIEW_ID',Node.ViewId);
        Values.Add('TYPE_ID',Node.TypeId);
        Values.Add('OPERATION_ID',Node.OperationId);
        Values.Add('PARAM_ID',Node.ParamId);
        Values.Add('NAME',Node.Name);

        case Node.NodeType of
          ntNode: begin
            if Trim(Node.Head)<>'' then
              CreateString(Node.Head,'',Values,Stream)
            else
              Stream.CreateString(Node.Name,Self.Font,true);
            ProcessNodes(Node.Childs,Stream);
          end;
          ntParams: begin
            ProcessNodeParams(Node,Stream);
          end;
        end;

      end;
    finally
      Values.Free;
    end;
  end;

var
  Success: Boolean;
  Stream: TBisRtfStream;
  Nodes: TBisKrieltNodes;
  Patterns: TBisValues;
  Filters: TBisFilters;
  T1: TTime;
begin
  Success:=false;
  Stream:=TBisRtfStream.Create;
  DSParamValues:=TBisDataSet.Create(nil);
  DSPatterns:=TBisProvider.Create(nil);
  DSParams:=TBisProvider.Create(nil);
  DSObjects:=TBisDataSet.Create(nil);
  Nodes:=TBisKrieltNodes.Create;
  Patterns:=TBisValues.Create;
  Filters:=TBisFilters.Create;
  T1:=Time;
  try
    Stream.Open;
    Stream.CreateHeader;
    Stream.OpenBody;

    with DSParamValues.FieldDefs do begin
      Add('PARAM_ID',ftString,32);
      Add('DATASET',ftBlob);
    end;
    DSParamValues.CreateTable();

    DSPatterns.WithWaitCursor:=false;
    DSPatterns.ProviderName:='S_PATTERNS';
    with DSPatterns.FieldNames do begin
      AddInvisible('EXPORT_ID');
      AddInvisible('DESIGN_ID');
      AddInvisible('RTF');
    end;
    DSPatterns.Open;

    if DSPatterns.Active then begin
    
      with DSObjects.FieldDefs do begin
        Add('VIEW_ID',ftString,32);
        Add('TYPE_ID',ftString,32);
        Add('OPERATION_ID',ftString,32);
        Add('DATASET',ftBlob);
      end;
      DSObjects.CreateTable();

      DSParams.WithWaitCursor:=false;
      DSParams.ProviderName:='S_PARAMS';
      DSParams.FilterGroups.Add.Filters.Add('LOCKED',fcEqual,0);
      DSParams.Open;
      if DSParams.Active and not DSParams.Empty then begin

        FTemp.Filtered:=false;
        FPosition:=0;
        FMax:=FTemp.RecordCount;
        AThread.Synchronize(SyncProgress);

        ProcessData(Nodes,Null,Null,Null,Null,Null,'','',Patterns,Filters,true);

        if not CheckBoxFull.Checked then
          DeleteEmptyNodes(Nodes);
        
        ProcessNodes(Nodes,Stream);
      end;
    end;  

    Stream.CloseBody;
    Stream.Close;
    Stream.SaveToFile(FFileName);

    Success:=true; 
  finally
    LoggerWrite(TimeToStr(Time-T1));
    LoggerWrite(IntToStr(FPosition));
    Filters.Free;
    Patterns.Free;
    Nodes.Free;
    DSObjects.Free;
    DSParams.Free;
    DSPatterns.Free;
    DSParamValues.Free;
    Stream.Free;
    AThread.Success:=Success;
  end;
end;

end.
