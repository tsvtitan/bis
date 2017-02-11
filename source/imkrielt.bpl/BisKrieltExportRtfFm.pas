unit BisKrieltExportRtfFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, ExtCtrls, Buttons, StdCtrls, ComCtrls, DB, Contnrs,
  VirtualTrees, VirtualDBTreeEx,
  BisFm, BisExecuteFm, BisDataSet, BisFilterGroups, BisDbTree;

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
    LabelPath: TLabel;
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
    FThreadId: Variant;
    FTree: TBisDBTree;
    FLastError: String;
    procedure ProgressVisible(AVisible: Boolean);
    procedure SyncProgress;
    procedure SyncDataSet;
    procedure RefreshDataSet;
    function GetCondtionString(Condition: TBisFilterCondition): String;
//    procedure TreeChecking(Sender: TBaseVirtualTree; Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
//    procedure TreeReadNodeFromDB(Sender: TBaseVirtualDBTreeEx; Node: PVirtualNode);
    procedure TreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
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

  TBisKrieltExportRtfFormIface=class(TBisExecuteFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltExportRtfForm: TBisKrieltExportRtfForm;

implementation

uses DateUtils, StrUtils,
     ALXmlDoc,
     BisConsts, BisUtils, BisProvider, BisRtfStream, BisValues, BisVariants, BisDialogs,
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
    FValueExists: Boolean;
  public
    property ParamName: String read FParamName write FParamName;
    property ParamType: TBisKrieltDataParamType read FParamType write FParamType;
    property ValueString: String read FValueString write FValueString;
    property ValueNumber: Extended read FValueNumber write FValueNumber;
    property ValueDate: TDateTime read FValueDate write FValueDate;
    property ValueBlob: String read FValueBlob write FValueBlob;
    property ValueExists: Boolean read FValueExists write FValueExists;
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
    FHead: String;
    FBody: String;
    FPattern: String;
    FNodeType: TBisKrieltNodeType;
    FParent: TBisKrieltNode;
    function GetPath: String;
  public
    constructor Create(AParent: TBisKrieltNode=nil);
    destructor Destroy; override;

    property Name: String read FName write FName;
    property NodeType: TBisKrieltNodeType read FNodeType write FNodeType;
    property Head: String read FHead write FHead;
    property Body: String read FBody write FBody;
    property Pattern: String read FPattern write FPattern;


    property Path: String read GetPath; 
    property Childs: TBisKrieltNodes read FChilds;
    property Params: TBisKrieltNodeParams read FParams;
    property Parent: TBisKrieltNode read FParent; 
  end;

  TBisKrieltNodes=class(TObjectList)
  private
    FParent: TBisKrieltNode;
    function GetItem(Index: Integer): TBisKrieltNode;
  public
    function AddNode(Name: String; Head,Body: String; Parent: TBisKrieltNode=nil): TBisKrieltNode;
    function AddParams(Parent: TBisKrieltNode=nil): TBisKrieltNode;

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

constructor TBisKrieltNode.Create(AParent: TBisKrieltNode=nil);
begin
  inherited Create;
  FParent:=AParent;
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
  FParent:=nil;
  inherited Destroy;
end;

function TBisKrieltNode.GetPath: String;
var
  Node: TBisKrieltNode;
begin
  Result:=FName;
  Node:=Self;
  while Assigned(Node.Parent) do begin
    Result:=Node.Parent.Name+'\'+Result;
    Node:=Node.Parent;
  end;
end;

{ TBisKrieltNodes }

function TBisKrieltNodes.AddNode(Name: String; Head,Body: String; Parent: TBisKrieltNode=nil): TBisKrieltNode;
begin
  Result:=TBisKrieltNode.Create(Parent);
  Result.Name:=Name;
  Result.NodeType:=ntNode;
  Result.Head:=Head;
  Result.Body:=Body;
  inherited Add(Result);
end;

function TBisKrieltNodes.AddParams(Parent: TBisKrieltNode=nil): TBisKrieltNode;
begin
  Result:=TBisKrieltNode.Create(Parent);
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
    Add('ID',ftString,32);
    Add('PARENT_ID',ftString,32);
    Add('VIEW_ID',ftString,32);
    Add('TYPE_ID',ftString,32);
    Add('OPERATION_ID',ftString,32);
    Add('NAME',ftString,100);
    Add('HEAD',ftBlob);
    Add('BODY',ftBlob);
    Add('PATTERN_DATASET',ftBlob);
    Add('FILTER_DATASET',ftBlob);
    Add('SORTING',ftBlob);
    Add('CHILD_EXISTS',ftInteger);
//    Add('CHECKED',ftInteger);
  end;
  with FDataSet.FieldNames do begin
    Add('NAME','Наименование',250);
    with AddKey('ID') do begin
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
  FTree.OnChange:=TreeChange;
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

procedure TBisKrieltExportRtfForm.TreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  LabelPath.Caption:='';
  if Assigned(Node) then
    LabelPath.Caption:=FTree.Path(Node,1,ttNormal,PathDelim);
end;

function TBisKrieltExportRtfForm.GetCondtionString(Condition: TBisFilterCondition): String;
begin
  Result:='';
  case Condition of
    fcEqual: Result:='=';
    fcGreater: Result:='>';
    fcLess: Result:='<';
    fcNotEqual: Result:='<>';
    fcEqualGreater: Result:='>=';
    fcEqualLess: Result:='<=';
    fcLike: Result:='LIKE';
    fcNotLike: Result:='NOT LIKE';
    fcIsNull: Result:='IS NULL';
    fcIsNotNull: Result:='IS NOT NULL';
  end;
end;

procedure TBisKrieltExportRtfForm.RefreshDataSet;
var
  PExports: TBisProvider;
  DSParamValues: TBisDataSet;
  PPatterns: TBisProvider;

  procedure ProcessParam(ParamId: Variant; Condition: TBisFilterCondition; Value: String;
                         ParamSorting: TBisKrieltDataParamSorting;
                         ParamExports, ParamDescriptions: TBisVariants);

    procedure FillParamNames(DS: TBisDataSet);
    var
      AName, AExport, ADesc: String;
      S, V: String;
    begin
      DS.Filtered:=false;
      S:=GetCondtionString(Condition);
      V:='';
      if not (Condition in [fcIsNull,fcIsNotNull]) then
        V:=QuotedStr(Value);
      S:=FormatEx('%s %s %s',['NAME',S,V]);
      DS.Filter:=Trim(S);
      DS.Filtered:=DS.Filter<>'';
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

  function CreatePatternDataSet: TBisDataSet;
  begin
    Result:=TBisDataSet.Create(nil);
    with Result.FieldDefs do begin
      Add('DESIGN_ID',ftString,32);
      Add('RTF',ftBlob);
    end;
    Result.CreateTable();
  end;

  procedure ProcessPatterns(ExportId: Variant; NewPatterns, OldPatterns: TBisDataSet);
  var
    DesignId: String;
    Exists: Boolean;
  begin
    PPatterns.Filtered:=false;
    PPatterns.Filter:=FormatEx('EXPORT_ID=%s',[QuotedStr(VarToStrDef(ExportId,''))]);
    PPatterns.Filtered:=true;
    if PPatterns.Active and not PPatterns.Empty then begin
      PPatterns.First;
      while not PPatterns.Eof do begin
        DesignId:=VarToStrDef(PPatterns.FieldByName('DESIGN_ID').Value,'');
        NewPatterns.CopyRecord(PPatterns);
        PPatterns.Next;
      end;
    end;
    OldPatterns.First;
    while not OldPatterns.Eof do begin
      DesignId:=VarToStrDef(OldPatterns.FieldByName('DESIGN_ID').Value,'');
      Exists:=NewPatterns.Locate('DESIGN_ID',DesignId,[loCaseInsensitive]);
      if not Exists then
        NewPatterns.CopyRecord(OldPatterns);
      OldPatterns.Next;
    end;
  end;

  function ExportChildExists(ExportId: Variant): Boolean;
  begin
    PExports.Filtered:=false;
    if VarisNull(ExportId) then
      PExports.Filter:='PARENT_ID IS NULL'
    else
      PExports.Filter:=FormatEx('PARENT_ID=%s',[QuotedStr(VarToStrDef(ExportId,''))]);
    PExports.Filtered:=true;
    Result:=PExports.RecordCount>0;
  end;

  function CreateFilterDataSet: TBisDataSet;
  begin
    Result:=TBisDataSet.Create(nil);
    with Result.FieldDefs do begin
      Add('FIELD_NAME',ftString,32);
      Add('CONDITION',ftInteger);
      Add('VALUE',ftString,100);
    end;
    Result.CreateTable();
  end;

  procedure ProcessFilters(ParamId: Variant; ParamType: TBisKrieltDataParamType;
                           Condition: TBisFilterCondition; Value: String;
                           NewFilters, OldFilters: TBisDataSet);
  var
    FieldName: String;
    Support: Boolean;
  begin
    NewFilters.CopyRecords(OldFilters);
    if not VarIsNull(ParamId) then begin
      FieldName:=VarToStrDef(ParamId,'');
      Support:=not (ParamType in [dptImage,dptDocument,dptVideo]);
      if Support then begin
        NewFilters.Append;
        NewFilters.FieldByName('FIELD_NAME').AsString:=FieldName;
        NewFilters.FieldByName('CONDITION').AsInteger:=Integer(Condition);
        NewFilters.FieldByName('VALUE').AsString:=Value;
        NewFilters.Post;
      end;
    end;
  end;

  function ProcessData(ParentId,ParentExportId,ParentViewId,ParentTypeId,ParentOperationId,ParentParamId: Variant;
                       ParentHead,ParentBody: String; ParentPatterns: TBisDataSet; ParentFilters: TBisDataSet;
                       ParentSortings: TStringList): Boolean;
  var
    DS: TBisDataSet;
    Id: Variant;
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
    ParamExports, ParamDescriptions: TBisVariants;
    Patterns: TBisDataSet;
    PatternsStream: TMemoryStream;
    NewFilters,Filters: TBisDataSet;
    NewFiltersStream, FiltersStream: TMemoryStream;
    Sortings: TStringList;
    NewName: Boolean;
    Name: String;
    i: Integer;
    ChildExists: Boolean;
  begin
    DS:=TBisDataSet.Create(nil);
    ParamExports:=TBisValues.Create;
    ParamDescriptions:=TBisValues.Create;
    Patterns:=CreatePatternDataSet;
    PatternsStream:=TMemoryStream.Create;
    Filters:=CreateFilterDataSet;
    FiltersStream:=TMemoryStream.Create;
    NewFilters:=CreateFilterDataSet;
    NewFiltersStream:=TMemoryStream.Create;
    Sortings:=TStringList.Create;
    try
      PExports.Filtered:=false;
      if VarisNull(ParentExportId) then
        PExports.Filter:='PARENT_ID IS NULL'
      else
        PExports.Filter:=FormatEx('PARENT_ID=%s',[QuotedStr(VarToStrDef(ParentExportId,''))]);
      PExports.Filtered:=true;
      DS.CreateTable(PExports);
      DS.CopyRecords(PExports);

      Result:=DS.Active and not DS.Empty;
      if Result then begin

        DS.First;
        while not DS.Eof do begin

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

          Patterns.EmptyTable;
          ProcessPatterns(ExportId,Patterns,ParentPatterns);
          PatternsStream.Clear;
          Patterns.SaveToStream(PatternsStream);
          PatternsStream.Position:=0;

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
            NewName:=(AParamType=dptList) and (ACondition in [fcNotEqual,fcNotLike,fcIsNotNull]);

          Filters.EmptyTable;
          ProcessFilters(ParamId,AParamType,ACondition,Value,Filters,ParentFilters);
          FiltersStream.Clear;
          Filters.SaveToStream(FiltersStream);
          FiltersStream.Position:=0;

          Sortings.Clear;
          Sortings.Text:=Trim(DS.FieldByName('SORTING').AsString);
          if Trim(Sortings.Text)='' then
            Sortings.Text:=ParentSortings.Text;

          if NewName then begin

            ParamExports.Clear;
            ParamDescriptions.Clear;
            ProcessParam(ParamId,ACondition,Value,AParamSorting,ParamExports,ParamDescriptions);

            for i:=0 to ParamDescriptions.Count-1 do begin
              NewFilters.EmptyTable;
              ProcessFilters(ParamId,dptList,fcEqual,VarToStrDef(ParamExports.Items[i].Value,''),NewFilters,Filters);
              NewFiltersStream.Clear;
              NewFilters.SaveToStream(NewFiltersStream);
              NewFiltersStream.Position:=0;

              Id:=GetUniqueID;

              ChildExists:=ExportChildExists(ExportId);

              FDataSet.Append;
              FDataSet.FieldByName('ID').Value:=Id;
              FDataSet.FieldByName('PARENT_ID').Value:=ParentId;
              FDataSet.FieldByName('VIEW_ID').Value:=ViewId;
              FDataSet.FieldByName('TYPE_ID').Value:=TypeId;
              FDataSet.FieldByName('OPERATION_ID').Value:=OperationId;
              FDataSet.FieldByName('NAME').Value:=ParamDescriptions.Items[i].Value;
              FDataSet.FieldByName('HEAD').Value:=Head;
              FDataSet.FieldByName('BODY').Value:=Body;
              TBlobField(FDataSet.FieldByName('PATTERN_DATASET')).LoadFromStream(PatternsStream);
              TBlobField(FDataSet.FieldByName('FILTER_DATASET')).LoadFromStream(NewFiltersStream);
              FDataSet.FieldByName('SORTING').Value:=Trim(Sortings.Text);
              FDataSet.FieldByName('CHILD_EXISTS').AsInteger:=Integer(ChildExists);
              FDataSet.Post;

              if ChildExists then
                ProcessData(Id,ExportId,ViewId,TypeId,OperationId,ParamId,Head,Body,Patterns,NewFilters,Sortings)

            end;

          end else begin

            Id:=GetUniqueID;

            ChildExists:=ExportChildExists(ExportId);

            FDataSet.Append;
            FDataSet.FieldByName('ID').Value:=Id;
            FDataSet.FieldByName('PARENT_ID').Value:=ParentId;
            FDataSet.FieldByName('VIEW_ID').Value:=ViewId;
            FDataSet.FieldByName('TYPE_ID').Value:=TypeId;
            FDataSet.FieldByName('OPERATION_ID').Value:=OperationId;
            FDataSet.FieldByName('NAME').Value:=Name;
            FDataSet.FieldByName('HEAD').Value:=Head;
            FDataSet.FieldByName('BODY').Value:=Body;
            TBlobField(FDataSet.FieldByName('PATTERN_DATASET')).LoadFromStream(PatternsStream);
            TBlobField(FDataSet.FieldByName('FILTER_DATASET')).LoadFromStream(FiltersStream);
            FDataSet.FieldByName('SORTING').Value:=Trim(Sortings.Text);
            FDataSet.FieldByName('CHILD_EXISTS').AsInteger:=Integer(ChildExists);
            FDataSet.Post;

            if ChildExists then
              ProcessData(Id,ExportId,ViewId,TypeId,OperationId,ParamId,Head,Body,Patterns,Filters,Sortings)

          end;

          DS.Next;
        end;
      end;
    finally
      Sortings.Free;
      NewFiltersStream.Free;
      NewFilters.Free;
      FiltersStream.Free;
      Filters.Free;
      PatternsStream.Free;
      Patterns.Free;
      ParamExports.Free;
      ParamDescriptions.Free;
      DS.Free;
    end;
  end;

var
  OldCursor: TCursor;
  Patterns: TBisDataSet;
  Filters: TBisDataSet;
  Sortings: TStringList;
  T1: TTime; 
begin
  OldCursor:=Screen.Cursor;
  T1:=Time;
  Screen.Cursor:=crHourGlass;
  FDataSet.EmptyTable;
  FDataSet.BeginUpdate;
  PExports:=TBisProvider.Create(nil);
  DSParamValues:=TBisDataSet.Create(nil);
  PPatterns:=TBisProvider.Create(nil);
  Patterns:=CreatePatternDataSet;
  Filters:=CreateFilterDataSet;
  Sortings:=TStringList.Create;
  try
    PExports.WithWaitCursor:=false;
    PExports.ProviderName:='S_EXPORTS';
    with PExports.Orders do begin
      Add('LEVEL');
      Add('PRIORITY');
    end;
    PExports.FilterGroups.Add.Filters.Add('DISABLED',fcNotEqual,1);
    PExports.Open;
    if PExports.Active and not PExports.Empty then begin

      with DSParamValues.FieldDefs do begin
        Add('PARAM_ID',ftString,32);
        Add('DATASET',ftBlob);
      end;
      DSParamValues.CreateTable();

      PPatterns.WithWaitCursor:=false;
      PPatterns.ProviderName:='S_PATTERNS';
      with PPatterns.FieldNames do begin
        AddInvisible('EXPORT_ID');
        AddInvisible('DESIGN_ID');
        AddInvisible('RTF');
      end;
      PPatterns.Open;

      if PPatterns.Active then begin
        FDataSet.First;
        ProcessData(Null,Null,Null,Null,Null,Null,'','',Patterns,Filters,Sortings);
      end;

    end;
  finally
    Sortings.Free;
    Filters.Free;
    Patterns.Free;
    FDataSet.First;
    FDataSet.EndUpdate;
    PPatterns.Free;
    DSParamValues.Free;
    PExports.Free;
    LoggerWrite(TimeToStr(Time-T1));
    Screen.Cursor:=OldCursor;
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

function TBisKrieltExportRtfForm.CanStart: Boolean;
begin
  Result:=inherited CanStart and not VarIsNull(FPublishingId);
end;

procedure TBisKrieltExportRtfForm.ShowLastError;
begin
  if Trim(FLastError)<>'' then
    ShowError(FLastError);
end;

procedure TBisKrieltExportRtfForm.Start;
var
  Stream: TMemoryStream;
begin
  if CanStart then begin
    if SaveDialog.Execute then begin
      Stream:=TMemoryStream.Create;
      try
        FFileName:=SaveDialog.FileName;
        FTemp.EmptyTable;
        Self.Update;
        FDataSet.SaveToStream(Stream);
        Stream.Position:=0;
        FTemp.LoadFromStream(Stream);
        Self.Update;
        FTemp.Open;
        FLastError:='';
        inherited Start;
        ProgressVisible(true);
        EnableControl(PanelControls,false);
      finally
        Stream.Free;
      end;
    end;
  end;
end;

procedure TBisKrieltExportRtfForm.SyncDataSet;
begin
  if FDataSet.Active then begin
   // FTree.Next;
 {   if FDataSet.Locate('ID',FThreadId,[loCaseInsensitive,loPartialKey]) then begin
      //
    end;}
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
  PParams: TBisProvider;
  DSObjects: TBisDataSet;

  procedure ProcessObjects(ParentNodes: TBisKrieltNodes; ParentNode: TBisKrieltNode;
                           ViewId,TypeId,OperationId: Variant;
                           Patterns: TBisDataSet; Filters: TBisDataSet; Sortings: TStringList);

    function GetFN(S: String): String;
    begin
      Result:='P'+S;
    end;

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
            Index:=Sortings.IndexOf(AName);
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

    procedure ApplyFilter(DSSource, DSDestination: TBisDataSet);
    var
      Str: TStringList;
      Condition: String;
      ACondition: TBisFilterCondition;
      Value: String;
      Field: TField;
      FN: String;
      S: String;
      i: Integer;
      AValue: Variant;
    begin
      Str:=TStringList.Create;
      try
        DSSource.Filtered:=false;
        Filters.First;
        while not Filters.Eof do begin
          FN:=GetFN(Filters.FieldByName('FIELD_NAME').AsString);
          Field:=DSSource.FindField(FN);
          if Assigned(Field) then begin
            ACondition:=TBisFilterCondition(Filters.FieldByName('CONDITION').AsInteger);
            Condition:=GetCondtionString(ACondition);
            Value:=Trim(Filters.FieldByName('VALUE').AsString);
            case Field.DataType of
              ftString: begin
                if Value<>'' then
                  Value:=QuotedStr(Value);
              end;
              ftInteger: ;
              ftFloat:;
              ftDate: begin
                if Value<>'' then
                  Value:=QuotedStr(Value);
              end;
              ftDateTime: begin
                if Value<>'' then
                  Value:=QuotedStr(Value);
              end;
            end;
            Str.Add(FormatEx('%s %s %s',[FN,Condition,Value]));
          end;
          Filters.Next;
        end;
        S:=GetFilterString(Str,'AND');
        DSSource.Filter:=S;
        DSSource.Filtered:=Trim(DSSource.Filter)<>'';
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
//        DSDestination.CopyRecords(DSSource);
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

    procedure FillNodeParams(DS: TBisDataSet);
    var
      Node: TBisKrieltNode;
      NodeParam: TBisKrieltNodeParam;
      PatternExists: Boolean;
      Field: TField;
      ParamExists: Boolean;
      i: Integer;
      FN: String;
    begin
      DS.First;
      while not DS.Eof do begin
        if AThread.Terminated then
          break;

        Node:=ParentNodes.AddParams(ParentNode);
        Node.Name:=DS.FieldByName('OBJECT_ID').AsString;
        Node.Body:=ParentNodes.Parent.Body;                                                                  

        PatternExists:=Patterns.Locate('DESIGN_ID',DS.FieldByName('DESIGN_ID').AsString,[loCaseInsensitive]);
        if PatternExists then
          Node.Pattern:=Trim(Patterns.FieldByName('RTF').AsString);

        for i:=3 to DS.Fields.Count-1 do begin
          Field:=DS.Fields[i];
          FN:=Copy(Field.FieldName,2,MaxInt);
          ParamExists:=PParams.Locate('PARAM_ID',FN,[loCaseInsensitive]);
          if ParamExists then begin
            NodeParam:=Node.Params.Add(PParams.FieldByName('NAME').AsString);
            NodeParam.ParamType:=TBisKrieltDataParamType(PParams.FieldByName('PARAM_TYPE').AsInteger);
            NodeParam.ValueExists:=not VarSameValue(Field.Value,GetNullValue(Field));
            if NodeParam.ValueExists then begin
              case NodeParam.ParamType of
                dptList,dptString,dptLink: NodeParam.ValueString:=Trim(Field.AsString);
                dptInteger,dptFloat: NodeParam.ValueNumber:=Field.AsFloat;
                dptDate,dptDateTime: NodeParam.ValueDate:=Field.AsDateTime;
                dptImage,dptDocument,dptVideo: NodeParam.ValueBlob:=Trim(Field.AsString);
              end;
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
    DS, DSF: TBisDataSet;
    Value: Variant;
    Index: String;
    Priority: Variant;
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
            AddInvisible('PRIORITY');
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
              DS.SaveToStream(Stream);
              Stream.Position:=0;
              TBlobField(DSObjects.FieldByName('DATASET')).LoadFromStream(Stream);
              DSObjects.Post;
              if not DS.Empty then begin
                DSF:=CreateObjectsDataSet(true,Index);
                try
                  ApplyFilter(DS,DSF);
                  ApplyIndex(DSF,Index);
                  FillNodeParams(DSF);
                finally
                  DSF.Free;
                end;
              end;
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
            DSF:=CreateObjectsDataSet(true,Index);
            try
              ApplyFilter(DS,DSF);
              ApplyIndex(DSF,Index);
              FillNodeParams(DSF);
            finally
              DSF.Free;
            end;
          end;
        finally
          DS.Free;
        end;
      end;
    finally
      Stream.Free;
    end;
  end;

  procedure ProcessData(ParentNodes: TBisKrieltNodes; ParentNode: TBisKrieltNode; ParentId: Variant);
  var
    DS: TBisDataSet;
    ChildExists: Boolean;
    Id: Variant;
    Name: String;
    ViewId,TypeId,OperationId: Variant;
    Head, Body: String;
    Node: TBisKrieltNode;
    Patterns: TBisDataSet;
    Filters: TBisDataSet;
    Stream: TMemoryStream;
    Sortings: TStringList;
  begin
    DS:=TBisDataSet.Create(nil);
    Patterns:=TBisDataSet.Create(nil);
    Filters:=TBisDataSet.Create(nil);
    Stream:=TMemoryStream.Create;
    Sortings:=TStringList.Create;
    try
      FTemp.Filtered:=false;
      if VarisNull(ParentId) then
        FTemp.Filter:='PARENT_ID IS NULL'
      else
        FTemp.Filter:=FormatEx('PARENT_ID=%s',[QuotedStr(VarToStrDef(ParentId,''))]);
      FTemp.Filtered:=true;
      DS.CreateTable(FTemp);
      DS.CopyRecords(FTemp);
      if DS.Active and not DS.Empty then begin
        DS.First;
        while not DS.Eof do begin
          if AThread.Terminated then
            break;

          Id:=DS.FieldByName('ID').Value;

          Inc(FPosition);
          AThread.Synchronize(SyncProgress);

          FThreadId:=Id;
          AThread.Synchronize(SyncDataSet);

          Name:=Trim(DS.FieldByName('NAME').AsString);
          ViewId:=DS.FieldByName('VIEW_ID').Value;
          TypeId:=DS.FieldByName('TYPE_ID').Value;
          OperationId:=DS.FieldByName('OPERATION_ID').Value;
          Head:=Trim(DS.FieldByName('HEAD').AsString);
          Body:=Trim(DS.FieldByName('BODY').AsString);

          Stream.Clear;
          TBlobField(DS.FieldByName('PATTERN_DATASET')).SaveToStream(Stream);
          Patterns.LoadFromStream(Stream);
          Patterns.Open;

          Stream.Clear;
          TBlobField(DS.FieldByName('FILTER_DATASET')).SaveToStream(Stream);
          Filters.LoadFromStream(Stream);
          Filters.Open;

          Sortings.Text:=Trim(DS.FieldByName('SORTING').AsString);

          ChildExists:=Boolean(DS.FieldByName('CHILD_EXISTS').AsInteger);

          Node:=ParentNodes.AddNode(Name,Head,Body,ParentNode);
          if ChildExists then
            ProcessData(Node.Childs,Node,Id)
          else begin
            if not VarIsNull(ViewId) and
               not VarIsNull(TypeId) and
               not VarIsNull(OperationId) then
              ProcessObjects(Node.Childs,Node,ViewId,TypeId,OperationId,Patterns,Filters,Sortings);
          end;

          DS.Next;
        end;
      end;
    finally
      Sortings.Free;
      Stream.Free;
      Filters.Free;
      Patterns.Free;
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

    function ApplyModeSize(S: String; Mode,Size: Integer): String;
    begin
      Result:=S;
      if Size>0 then
        Result:=Copy(S,1,Size);
      if Result<>'' then begin
        case Mode of
          1: Result:=AnsiUpperCase(Result);
          2: Result:=AnsiLowerCase(Result);
          3: begin
            if Length(Result)>0 then
              Result:=AnsiUpperCase(Result[1])+AnsiLowerCase(Copy(Result,2,Length(Result)));
          end
        end;
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
      ADefault: String;
      AMode: Integer;
      ASize: Integer;
      ABack: String;
      V: String;
      Flag: Boolean;
      BackColor: TColor;
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
            ADefault:=Trim(VarToStrDef(ParentNode.Attributes['default'],''));
            AMode:=VarToIntDef(ParentNode.Attributes['mode'],0);
            ASize:=VarToIntDef(ParentNode.Attributes['size'],0);
            BackColor:=clWindow;
            ABack:=Trim(VarToStrDef(ParentNode.Attributes['back'],''));
            if ABack<>'' then
              BackColor:=StrToIntDef('$'+ABack,BackColor);
            Item:=Values.Find(AName);
            V:='';
            Flag:=true;
            if Assigned(Item) then begin
              V:=Trim(VarToStrDef(Item.Value,''));
              Flag:=V<>'';
              if Flag then
                S:=ReplaceText(S,'%',ApplyModeSize(V,AMode,ASize))
              else begin
                if ADefault<>'' then begin
//                  S:=ReplaceText(S,'%',ApplyModeSize(ADefault,AMode,ASize));
                  S:=ApplyModeSize(ADefault,AMode,ASize);
                  Flag:=true;
                end else
                  S:=V;
              end;
            end else begin
              if IsParam then begin
                if AName<>'' then begin
                  ParamExists:=PParams.Locate('NAME',AName,[loCaseInsensitive]);
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
                Stream.CreateString('',NodeFont,clWindow,true);
              Stream.CreateString(S,NodeFont,BackColor,false);
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
          Stream.CreateString('',Self.Font,clWindow,true);
        end;
      except
        On E: Exception do begin
          Stream.CreateString(E.Message,Self.Font,clWindow,true);
        end;
      end;
    finally
      Str.Free;
      Xml.Free;
    end;
  end;

  procedure ProcessNodeParams(ParentNode: TBisKrieltNode; Stream: TBisRtfStream; Path: String);

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
      Values.Add('PATH',Path);
      
      for i:=0 to ParentNode.Params.Count-1 do begin
        NodeParam:=ParentNode.Params[i];
        Value:='';
        if NodeParam.ValueExists then begin
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
          Stream.CreateString(ParentNode.Name,Self.Font,clWindow,true); 
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
        Values.Add('NAME',Node.Name);

        case Node.NodeType of
          ntNode: begin
            if Trim(Node.Head)<>'' then
              CreateString(Node.Head,'',Values,Stream)
            else
              Stream.CreateString(Node.Name,Self.Font,clWindow,true);
            ProcessNodes(Node.Childs,Stream);
          end;
          ntParams: begin
            ProcessNodeParams(Node,Stream,Node.Parent.Path);
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
  T1: TTime;
begin
  Success:=false;
  try
    Stream:=TBisRtfStream.Create;
    PParams:=TBisProvider.Create(nil);
    DSObjects:=TBisDataSet.Create(nil);
    Nodes:=TBisKrieltNodes.Create;
    T1:=Time;
    try
      Stream.Open;
      Stream.CreateHeader;
      Stream.OpenBody;

      with DSObjects.FieldDefs do begin
        Add('VIEW_ID',ftString,32);
        Add('TYPE_ID',ftString,32);
        Add('OPERATION_ID',ftString,32);
        Add('DATASET',ftBlob);
      end;
      DSObjects.CreateTable();

      PParams.WithWaitCursor:=false;
      PParams.ProviderName:='S_PARAMS';
      PParams.FilterGroups.Add.Filters.Add('LOCKED',fcEqual,0);
      PParams.Open;
      if PParams.Active and not PParams.Empty then begin

        FTemp.Filtered:=false;
        FPosition:=0;
        FMax:=FTemp.RecordCount;
        AThread.Synchronize(SyncProgress);

        ProcessData(Nodes,nil,Null);

        if not CheckBoxFull.Checked then
          DeleteEmptyNodes(Nodes);

        ProcessNodes(Nodes,Stream);
      end;

      Stream.CloseBody;
      Stream.Close;
      Stream.SaveToFile(FFileName);

      Success:=true;
    finally
      LoggerWrite(TimeToStr(Time-T1));
      LoggerWrite(IntToStr(FPosition));
      Nodes.Free;
      DSObjects.Free;
      PParams.Free;
      Stream.Free;
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
