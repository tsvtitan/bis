unit BisFastReportComponents;

interface

uses Classes, DB, Controls, Contnrs, 
     frxClass, frxCustomDB, frxDsgnIntf,
     BisProvider, BisFieldNames, BisFilterGroups, BisOrders,
     BisParams, BisDataSet;

type
  TBisParams=class(TPersistent)
  private
    FParams: BisParams.TBisParams;
    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    property Params: BisParams.TBisParams read FParams write FParams;
  end;

  TBisFieldNames=class(TPersistent)
  private
    FFieldNames: BisFieldNames.TBisFieldNames;
    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    property FieldNames: BisFieldNames.TBisFieldNames read FFieldNames write FFieldNames;
  end;

  TBisFilterGroups=class(TPersistent)
  private
    FFilterGroups: BisFilterGroups.TBisFilterGroups;
    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    property FilterGroups: BisFilterGroups.TBisFilterGroups read FFilterGroups write FFilterGroups;
  end;

  TBisOrders=class(TPersistent)
  private
    FOrders: BisOrders.TBisOrders;
    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    property Orders: BisOrders.TBisOrders read FOrders write FOrders;
  end;

  TBisProviderOpenMode=TBisDataSetOpenMode;

  TBisProvider=class(TfrxCustomDataset)
  private
    FProvider: BisProvider.TBisProvider;
    FParams: TBisParams;
    FFieldNames: TBisFieldNames;
    FFilterGroups: TBisFilterGroups;
    FOrders: TBisOrders;
    function GetFetchCount: Integer;
    procedure SetFetchCount(const Value: Integer);
    procedure SetParams(const Value: TBisParams);
    function GetProviderName: String;
    procedure SetProviderName(const Value: String);
    procedure SetFieldNames(const Value: TBisFieldNames);
    procedure SetFilterGroups(const Value: TBisFilterGroups);
    procedure SetOrders(const Value: TBisOrders);
    function GetOpenMode: TBisProviderOpenMode;
    procedure SetOpenMode(const Value: TBisProviderOpenMode);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    constructor DesignCreate(AOwner: TComponent; Flags: Word); override;
    class function GetDescription: String; override;
    procedure BeforeStartReport; override;
    procedure Open; override;
    procedure Execute;
    procedure First; reintroduce;
    procedure Next; reintroduce;
    procedure Last; reintroduce;
    procedure Prior; reintroduce;
    function Bof: Boolean; reintroduce;
    function Eof: Boolean; reintroduce;
    procedure Append;
    procedure Edit;
    procedure Post; 
    procedure CreateTable(Source: TfrxCustomDataset);
    procedure CopyRecords(Source: TfrxCustomDataset);
    procedure CopyRecord(Source: TfrxCustomDataset);

    property Provider: BisProvider.TBisProvider read FProvider;
  published
    property ProviderName: String read GetProviderName write SetProviderName;
    property FetchCount: Integer read GetFetchCount write SetFetchCount;
    property Params: TBisParams read FParams write SetParams;
    property FieldNames: TBisFieldNames read FFieldNames write SetFieldNames;
    property FilterGroups: TBisFilterGroups read FFilterGroups write SetFilterGroups;
    property Orders: TBisOrders read FOrders write SetOrders;
    property OpenMode: TBisProviderOpenMode read GetOpenMode write SetOpenMode;
  end;

  TBisObjectList=class(TfrxDialogComponent)
  private
    FList: TObjectList;
    function GetItems(Index: Integer): TObject;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add(AObject: TObject): Integer;
    procedure Clear; reintroduce;
    function Count: Integer;

    property Items[Index: Integer]: TObject read GetItems;
  end;

  TBisProviderNameProperty=class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
  end;

  TBisProviderParamsProperty=class(TfrxClassProperty)
    function GetAttributes: TfrxPropertyAttributes; override;
    function Edit: Boolean; override;
  end;

  TBisProviderFieldNamesProperty=class(TfrxClassProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    function Edit: Boolean; override;
  end;

  TBisProviderOrdersProperty=class(TfrxClassProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    function Edit: Boolean; override;
  end;

  TBisProviderFilterGroupsProperty=class(TfrxClassProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    function Edit: Boolean; override;
  end;

implementation

{$R *.res}

uses Graphics, SysUtils, Variants,
     frxDBSet, fs_iinterpreter, frxRes,

     BisUtils, BisConsts, BisParam, BisParamInvisible, BisOrdersFm, BisFieldNamesFm;

type
  TFunctions=class(TfsRTTIModule)
  public
    constructor Create(AScript: TfsScript); override;

    function TBisProvider_Create(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_Open(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_Execute(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_First(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_Next(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_Prior(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_Last(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_Append(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_Edit(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_Post(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_CreateTable(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_CopyRecords(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_CopyRecord(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_FieldByName(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisProvider_GetEof(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    function TBisProvider_GetBof(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    function TBisProvider_GetFieldDefs(Instance: TObject; ClassType: TClass; const PropName: String): Variant;

    function TBisParam_GetParamName(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisParam_SetParamName(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
    function TBisParam_GetParamType(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisParam_SetParamType(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
    function TBisParam_GetValue(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisParam_SetValue(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);

    function TBisParams_Add(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisParams_Items(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisParams_GetCount(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    function TBisParams_Clear(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;

    function TBisFieldName_GetFieldName(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisFieldName_SetFieldName(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
    function TBisFieldName_GetFuncType(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisFieldName_SetFuncType(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);

    function TBisFieldNames_Add(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisFieldNames_Items(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisFieldNames_GetCount(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    function TBisFieldNames_Clear(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;

    function TBisFilter_GetFieldName(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisFilter_SetFieldName(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
    function TBisFilter_GetOperator(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisFilter_SetOperator(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
    function TBisFilter_GetCondition(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisFilter_SetCondition(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
    function TBisFilter_GetCheckCase(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisFilter_SetCheckCase(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
    function TBisFilter_GetRightSide(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisFilter_SetRightSide(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
    function TBisFilter_GetLeftSide(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisFilter_SetLeftSide(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
    function TBisFilter_GetValue(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisFilter_SetValue(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);

    function TBisFilters_Add(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisFilters_Items(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;

    function TBisFilterGroup_GetGroupName(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisFilterGroup_SetGroupName(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
    function TBisFilterGroup_GetOperator(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisFilterGroup_SetOperator(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
    function TBisFilterGroup_GetFilters(Instance: TObject; ClassType: TClass; const PropName: String): Variant;

    function TBisFilterGroups_Add(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisFilterGroups_Items(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisFilterGroups_GetCount(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    function TBisFilterGroups_Clear(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;

    function TBisOrder_GetFieldName(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisOrder_SetFieldName(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
    function TBisOrder_GetOrderType(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure TBisOrder_SetOrderType(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);

    function TBisOrders_Add(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisOrders_Items(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisOrders_GetCount(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    function TBisOrders_Clear(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;

    function TBisObjectList_Create(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisObjectList_Add(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisObjectList_Clear(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisObjectList_Count(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function TBisObjectList_Items(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;

  end;

{ TFunctions }


constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do begin
    with AddClass(TBisProvider,'TfrxCustomDataset') do begin
      AddConstructor('constructor Create(AOwner: TComponent)',TBisProvider_Create);
      AddMethod('procedure Execute',TBisProvider_Execute);
      AddMethod('procedure Open',TBisProvider_Open);
      AddMethod('procedure First',TBisProvider_First);
      AddMethod('procedure Next',TBisProvider_Next);
      AddMethod('procedure Prior',TBisProvider_Prior);
      AddMethod('procedure Last',TBisProvider_Last);
      AddMethod('procedure Append',TBisProvider_Append);
      AddMethod('procedure Edit',TBisProvider_Edit);
      AddMethod('procedure Post',TBisProvider_Post);
      AddMethod('function FieldByName(const FieldName: String): TField',TBisProvider_FieldByName);
      AddMethod('procedure CreateTable(Source: TfrxCustomDataset=nil);',TBisProvider_CreateTable);
      AddMethod('procedure CopyRecords(Source: TfrxCustomDataset);',TBisProvider_CopyRecords);
      AddMethod('procedure CopyRecord(Source: TfrxCustomDataset);',TBisProvider_CopyRecord);
      AddProperty('Eof','Boolean',TBisProvider_GetEof,nil);
      AddProperty('Bof','Boolean',TBisProvider_GetBof,nil);
      AddProperty('FieldDefs','TFieldDefs',TBisProvider_GetFieldDefs,nil);
    end;
    AddType('TParamType',fvtInt);
    AddConst('ptUnknown','TParamType',ptUnknown);
    AddConst('ptInput','TParamType',ptInput);
    AddConst('ptOutput','TParamType',ptOutput);
    AddConst('ptInputOutput','TParamType',ptInputOutput);
    AddConst('ptResult','TParamType',ptResult);
    with AddClass(TBisParam,'TObject') do begin
      AddProperty('ParamName','String',TBisParam_GetParamName,TBisParam_SetParamName);
      AddProperty('ParamType','TParamType',TBisParam_GetParamType,TBisParam_SetParamType);
      AddProperty('Value','Variant',TBisParam_GetValue,TBisParam_SetValue);
    end;
    with AddClass(TBisParams,'TPersistent') do begin
      AddMethod('function Add(const ParamName: string; ParamType: TParamType=ptInput): TBisParam',TBisParams_Add);
      AddMethod('procedure Clear',TBisParams_Clear);
      AddIndexProperty('Items','Integer','TBisParam',TBisParams_Items);
      AddProperty('Count','Integer',TBisParams_GetCount,nil);
    end;
    AddType('TBisFieldNameFuncType',fvtInt);
    AddConst('ftNone','TBisFieldNameFuncType',ftNone);
    AddConst('ftSum','TBisFieldNameFuncType',ftSum);
    AddConst('ftDistinct','TBisFieldNameFuncType',ftDistinct);
    with AddClass(TBisFieldName,'TObject') do begin
      AddProperty('FieldName','String',TBisFieldName_GetFieldName,TBisFieldName_SetFieldName);
      AddProperty('FuncType','TBisFieldNameFuncType',TBisFieldName_GetFuncType,TBisFieldName_SetFuncType);
    end;
    with AddClass(TBisFieldNames,'TPersistent') do begin
      AddMethod('function Add(const FieldName: string; FuncType: TBisFieldNameFuncType=ftNone): TBisFieldName',TBisFieldNames_Add);
      AddMethod('procedure Clear',TBisFieldNames_Clear);
      AddIndexProperty('Items','Integer','TBisFieldName',TBisFieldNames_Items);
      AddProperty('Count','Integer',TBisFieldNames_GetCount,nil);
    end;
    AddType('TBisFilterOperator',fvtInt);
    AddConst('foAnd','TBisFilterOperator',foAnd);
    AddConst('foOr','TBisFilterOperator',foOr);
    AddType('TBisFilterCondition',fvtInt);
    AddConst('fcEqual','TBisFilterCondition',fcEqual);
    AddConst('fcGreater','TBisFilterCondition',fcGreater);
    AddConst('fcLess','TBisFilterCondition',fcLess);
    AddConst('fcNotEqual','TBisFilterCondition',fcNotEqual);
    AddConst('fcEqualGreater','TBisFilterCondition',fcEqualGreater);
    AddConst('fcEqualLess','TBisFilterCondition',fcEqualLess);
    AddConst('fcLike','TBisFilterCondition',fcLike);
    AddConst('fcNotLike','TBisFilterCondition',fcNotLike);
    AddConst('fcIsNull','TBisFilterCondition',fcIsNull);
    AddConst('fcIsNotNull','TBisFilterCondition',fcIsNotNull);
    with AddClass(TBisFilter,'TObject') do begin
      AddProperty('FieldName','String',TBisFilter_GetFieldName,TBisFilter_SetFieldName);
      AddProperty('Operator','TBisFilterOperator',TBisFilter_GetOperator,TBisFilter_SetOperator);
      AddProperty('Condition','TBisFilterCondition',TBisFilter_GetCondition,TBisFilter_SetCondition);
      AddProperty('CheckCase','TBisFilterCheckCase',TBisFilter_GetCheckCase,TBisFilter_SetCheckCase);
      AddProperty('RightSide','TBisFilterRightSide',TBisFilter_GetRightSide,TBisFilter_SetRightSide);
      AddProperty('LeftSide','TBisFilterLeftSide',TBisFilter_GetLeftSide,TBisFilter_SetLeftSide);
      AddProperty('Value','Varaint',TBisFilter_GetValue,TBisFilter_SetValue);
    end;
    with AddClass(TBisFilters,'TObjectList') do begin
      AddMethod('function Add(const FieldName: string; Condition: TBisFilterCondition; Value: Variant): TBisFilter',TBisFilters_Add);
      AddIndexProperty('Items','Integer','TBisFilter',TBisFilters_Items);
    end;
    with AddClass(TBisFilterGroup,'TObject') do begin
      AddProperty('GroupName','String',TBisFilterGroup_GetGroupName,TBisFilterGroup_SetGroupName);
      AddProperty('Operator','TBisFilterOperator',TBisFilterGroup_GetOperator,TBisFilterGroup_SetOperator);
      AddProperty('Filters','TBisFilters',TBisFilterGroup_GetFilters,nil);
    end;
    with AddClass(TBisFilterGroups,'TPersistent') do begin
      AddMethod('function Add(Operator: TBisFilterOperator=foAnd): TBisFilterGroup',TBisFilterGroups_Add);
      AddMethod('procedure Clear',TBisFilterGroups_Clear);
      AddIndexProperty('Items','Integer','TBisFilterGroup',TBisFilterGroups_Items);
      AddProperty('Count','Integer',TBisFilterGroups_GetCount,nil);
    end;
    AddType('TBisOrderType',fvtInt);
    AddConst('otNone','TBisOrderType',otNone);
    AddConst('otAsc','TBisOrderType',otAsc);
    AddConst('otDesc','TBisOrderType',otDesc);
    with AddClass(TBisOrder,'TObject') do begin
      AddProperty('FieldName','String',TBisOrder_GetFieldName,TBisOrder_SetFieldName);
      AddProperty('OrderType','TBisOrderType',TBisOrder_GetOrderType,TBisOrder_SetOrderType);
    end;
    with AddClass(TBisOrders,'TPersistent') do begin
      AddMethod('function Add(const FieldName: string; OrderType: TBisOrderType): TBisOrder',TBisOrders_Add);
      AddMethod('procedure Clear',TBisOrders_Clear);
      AddIndexProperty('Items','Integer','TBisOrder',TBisOrders_Items);
      AddProperty('Count','Integer',TBisOrders_GetCount,nil);
    end;

    with AddClass(TBisObjectList,'TPersistent') do begin
      AddConstructor('constructor Create(AOwner: TComponent)',TBisObjectList_Create);
      AddMethod('function Add(AObject: TObject): Integer',TBisObjectList_Add);
      AddMethod('procedure Clear',TBisObjectList_Clear);
      AddMethod('function Count: Integer',TBisObjectList_Count);
      AddIndexProperty('Items','Integer','TBisObject',TBisObjectList_Items);
    end;

  end;
end;

function TFunctions.TBisProvider_Create(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Create') then begin
    Result:=Integer(TBisProvider(Instance).Create(TComponent(Integer(Caller.Params[0]))));
  end
end;

function TFunctions.TBisProvider_Open(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Open') then begin
    TBisProvider(Instance).Open;
  end;
end;

function TFunctions.TBisProvider_Execute(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Execute') then begin
    TBisProvider(Instance).Execute;
  end;
end;

function TFunctions.TBisProvider_First(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'First') then begin
    TBisProvider(Instance).First;
  end;
end;

function TFunctions.TBisProvider_Next(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Next') then begin
    TBisProvider(Instance).Next;
  end;
end;

function TFunctions.TBisProvider_Last(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Last') then begin
    TBisProvider(Instance).Last;
  end;
end;

function TFunctions.TBisProvider_Append(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Append') then begin
    TBisProvider(Instance).Append;
  end;
end;

function TFunctions.TBisProvider_Edit(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Edit') then begin
    TBisProvider(Instance).Edit;
  end;
end;

function TFunctions.TBisProvider_Post(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Post') then begin
    TBisProvider(Instance).Post;
  end;
end;

function TFunctions.TBisProvider_CreateTable(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'CreateTable') then begin
    TBisProvider(Instance).CreateTable(TfrxCustomDataset(Integer(Caller.Params[0])));
  end;
end;

function TFunctions.TBisProvider_CopyRecords(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'CopyRecords') then begin
    TBisProvider(Instance).CopyRecords(TfrxCustomDataset(Integer(Caller.Params[0])));
  end;
end;

function TFunctions.TBisProvider_CopyRecord(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'CopyRecord') then begin
    TBisProvider(Instance).CopyRecord(TfrxCustomDataset(Integer(Caller.Params[0])));
  end;
end;

function TFunctions.TBisProvider_Prior(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Prior') then begin
    TBisProvider(Instance).Prior;
  end;
end;

function TFunctions.TBisProvider_FieldByName(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result:=0;
  if AnsiSameText(MethodName,'FieldByName') then begin
    Result:=Integer(TBisProvider(Instance).Provider.FieldByName(VarToStrDef(Caller.Params[0],'')));
  end;
end;

function TFunctions.TBisProvider_GetEof(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := False;
  if AnsiSameText(PropName,'Eof') then begin
    Result:=TBisProvider(Instance).Eof;
  end;
end;

function TFunctions.TBisProvider_GetBof(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := false;
  if AnsiSameText(PropName,'Bof') then begin
    Result:=TBisProvider(Instance).Bof;
  end;
end;

function TFunctions.TBisProvider_GetFieldDefs(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := false;
  if AnsiSameText(PropName,'FieldDefs') then begin
    Result:=Integer(TBisProvider(Instance).Provider.FieldDefs);
  end;
end;

function TFunctions.TBisParam_GetParamName(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := '';
  if AnsiSameText(PropName,'ParamName') then begin
    Result:=TBisParam(Instance).ParamName;
  end;
end;

procedure TFunctions.TBisParam_SetParamName(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'ParamName') then begin
    TBisParam(Instance).ParamName:=VarToStrDef(Value,TBisParam(Instance).ParamName);
  end;
end;

function TFunctions.TBisParam_GetParamType(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;
  if AnsiSameText(PropName,'ParamType') then begin
    Result:=TBisParam(Instance).ParamType;
  end;
end;

procedure TFunctions.TBisParam_SetParamType(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'ParamType') then begin
    TBisParam(Instance).ParamType:=TParamType(VarToIntDef(Value,Integer(ftUnknown)));
  end;
end;

function TFunctions.TBisParam_GetValue(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := Null;
  if AnsiSameText(PropName,'Value') then begin
    Result:=TBisParam(Instance).Value;
  end;
end;

procedure TFunctions.TBisParam_SetValue(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'Value') then begin
    TBisParam(Instance).Value:=Value;
  end;
end;

function TFunctions.TBisParams_Add(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  Name: String;
  ParamType: TParamType;
  Obj: TBisParam;
begin
  Result:=0;
  if AnsiSameText(MethodName,'Add') then begin
    Name:=VarToStrDef(Caller.Params[0],'');
    ParamType:=TParamType(VarToIntDef(Caller.Params[1],Integer(ptInput)));
    Obj:=TBisParams(Instance).Params.AddInvisible(Name,ParamType);
    if Assigned(Obj) then begin
      Result:=Integer(Obj);
    end;
  end;
end;

function TFunctions.TBisParams_Items(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result:=0;
  if AnsiSameText(MethodName,'Items.Get') then begin
    Result:=Integer(TBisParams(Instance).Params.Items[Caller.Params[0]]);
  end;
{  if AnsiSameText(MethodName,'Items.Set') then begin
    TBisParams(Instance).Params.Items[Caller.Params[0]]:=TBisParam(Integer(Caller.Params[1]));
  end;}
end;

function TFunctions.TBisParams_GetCount(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;
  if AnsiSameText(PropName,'Count') then begin
    Result:=TBisParams(Instance).Params.Count;
  end;
end;

function TFunctions.TBisParams_Clear(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Clear') then begin
    TBisParams(Instance).Params.Clear;
  end;
end;

function TFunctions.TBisFieldName_GetFieldName(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := '';
  if AnsiSameText(PropName,'FieldName') then begin
    Result:=TBisFieldName(Instance).FieldName;
  end;
end;

procedure TFunctions.TBisFieldName_SetFieldName(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'FieldName') then begin
    TBisFieldName(Instance).FieldName:=VarToStrDef(Value,TBisFieldName(Instance).FieldName);
  end;
end;

function TFunctions.TBisFieldName_GetFuncType(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;
  if AnsiSameText(PropName,'FuncType') then begin
    Result:=TBisFieldName(Instance).FuncType;
  end;
end;

procedure TFunctions.TBisFieldName_SetFuncType(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'FuncType') then begin
    TBisFieldName(Instance).FuncType:=TBisFieldNameFuncType(VarToIntDef(Value,Integer(ftNone)));
  end;
end;

function TFunctions.TBisFieldNames_Add(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  Name: String;
  FuncType: TBisFieldNameFuncType;
  Obj: TBisFieldName;
begin
  Result:=0;
  if AnsiSameText(MethodName,'Add') then begin
    Name:=VarToStrDef(Caller.Params[0],'');
    FuncType:=TBisFieldNameFuncType(VarToIntDef(Caller.Params[1],Integer(ftNone)));
    Obj:=TBisFieldNames(Instance).FieldNames.AddInvisible(Name);
    if Assigned(Obj) then begin
      Obj.FuncType:=FuncType;
      Result:=Integer(Obj);
    end;
  end;
end;

function TFunctions.TBisFieldNames_Items(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result:=0;
  if AnsiSameText(MethodName,'Items.Get') then begin
    Result:=Integer(TBisFieldNames(Instance).FieldNames.Items[Caller.Params[0]]);
  end;
{  if AnsiSameText(MethodName,'Items.Set') then begin
    TBisFieldNames(Instance).FieldNames.Items[Caller.Params[0]]:=TBisFieldName(Integer(Caller.Params[1]));
  end;}
end;

function TFunctions.TBisFieldNames_GetCount(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;
  if AnsiSameText(PropName,'Count') then begin
    Result:=TBisFieldNames(Instance).FieldNames.Count;
  end;
end;

function TFunctions.TBisFieldNames_Clear(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Clear') then begin
    TBisFieldNames(Instance).FieldNames.Clear;
  end;
end;

function TFunctions.TBisFilter_GetFieldName(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := '';
  if AnsiSameText(PropName,'FieldName') then begin
    Result:=TBisFilter(Instance).FieldName;
  end;
end;

procedure TFunctions.TBisFilter_SetFieldName(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'FieldName') then begin
    TBisFilter(Instance).FieldName:=VarToStrDef(Value,TBisFilter(Instance).FieldName);
  end;
end;

function TFunctions.TBisFilter_GetOperator(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;
  if AnsiSameText(PropName,'Operator') then begin
    Result:=TBisFilter(Instance).Operator;
  end;
end;

procedure TFunctions.TBisFilter_SetOperator(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'Operator') then begin
    TBisFilter(Instance).Operator:=TBisFilterOperator(VarToIntDef(Value,Integer(foAnd)));
  end;
end;

function TFunctions.TBisFilter_GetCondition(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;
  if AnsiSameText(PropName,'Condition') then begin
    Result:=TBisFilter(Instance).Condition;
  end;
end;

procedure TFunctions.TBisFilter_SetCondition(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'Condition') then begin
    TBisFilter(Instance).Condition:=TBisFilterCondition(VarToIntDef(Value,Integer(foAnd)));
  end;
end;

function TFunctions.TBisFilter_GetCheckCase(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;
  if AnsiSameText(PropName,'CheckCase') then begin
    Result:=TBisFilter(Instance).CheckCase;
  end;
end;

procedure TFunctions.TBisFilter_SetCheckCase(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'CheckCase') then begin
    TBisFilter(Instance).CheckCase:=Boolean(VarToIntDef(Value,Integer(false)));
  end;
end;

function TFunctions.TBisFilter_GetRightSide(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;
  if AnsiSameText(PropName,'RightSide') then begin
    Result:=TBisFilter(Instance).RightSide;
  end;
end;

procedure TFunctions.TBisFilter_SetRightSide(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'RightSide') then begin
    TBisFilter(Instance).RightSide:=Boolean(VarToIntDef(Value,Integer(false)));
  end;
end;

function TFunctions.TBisFilter_GetLeftSide(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;
  if AnsiSameText(PropName,'LeftSide') then begin
    Result:=TBisFilter(Instance).LeftSide;
  end;
end;

procedure TFunctions.TBisFilter_SetLeftSide(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'LeftSide') then begin
    TBisFilter(Instance).LeftSide:=Boolean(VarToIntDef(Value,Integer(false)));
  end;
end;

function TFunctions.TBisFilter_GetValue(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := Null;
  if AnsiSameText(PropName,'Value') then begin
    Result:=TBisFilter(Instance).Value;
  end;
end;

procedure TFunctions.TBisFilter_SetValue(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'Value') then begin
    TBisFilter(Instance).Value:=Value;
  end;
end;

function TFunctions.TBisFilters_Add(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  FieldName: String;
  Condition: TBisFilterCondition;
  Value: Variant;
begin
  Result:=0;
  if AnsiSameText(MethodName,'Add') then begin
    FieldName:=VarToStrDef(Caller.Params[0],'');
    Condition:=TBisFilterCondition(VarToIntDef(Caller.Params[1],Integer(fcEqual)));
    Value:=Caller.Params[2];
    Result:=Integer(TBisFilters(Instance).Add(FieldName,Condition,Value));
  end;
end;

function TFunctions.TBisFilters_Items(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result:=0;
  if AnsiSameText(MethodName,'Items.Get') then begin
    Result:=Integer(TBisFilters(Instance).Items[Caller.Params[0]]);
  end;
{  if AnsiSameText(MethodName,'Items.Set') then begin
    TBisFilters(Instance).Items[Caller.Params[0]]:=TBisFilter(Integer(Caller.Params[1]));
  end;}
end;

function TFunctions.TBisFilterGroup_GetGroupName(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := '';
  if AnsiSameText(PropName,'GroupName') then begin
    Result:=TBisFilterGroup(Instance).GroupName;
  end;
end;

procedure TFunctions.TBisFilterGroup_SetGroupName(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'GroupName') then begin
    TBisFilterGroup(Instance).GroupName:=VarToStrDef(Value,TBisFilterGroup(Instance).GroupName);
  end;
end;

function TFunctions.TBisFilterGroup_GetOperator(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := '';
  if AnsiSameText(PropName,'Operator') then begin
    Result:=TBisFilterGroup(Instance).Operator;
  end;
end;

procedure TFunctions.TBisFilterGroup_SetOperator(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'Operator') then begin
    TBisFilterGroup(Instance).Operator:=TBisFilterOperator(VarToIntDef(Value,Integer(foAnd)));
  end;
end;

function TFunctions.TBisFilterGroup_GetFilters(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result:=0;
  if AnsiSameText(PropName,'Filters') then begin
    Result:=Integer(TBisFilterGroup(Instance).Filters);
  end;
end;

function TFunctions.TBisFilterGroups_Add(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  Operator: TBisFilterOperator;
begin
  Result:=0;
  if AnsiSameText(MethodName,'Add') then begin
    Operator:=TBisFilterOperator(VarToIntDef(Caller.Params[0],Integer(foAnd)));
    Result:=Integer(TBisFilterGroups(Instance).FilterGroups.Add(Operator));
  end;
end;

function TFunctions.TBisFilterGroups_Items(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result:=0;
  if AnsiSameText(MethodName,'Items.Get') then begin
    Result:=Integer(TBisFilterGroups(Instance).FilterGroups.Items[Caller.Params[0]]);
  end;
{  if AnsiSameText(MethodName,'Items.Set') then begin
    TBisFilterGroups(Instance).FilterGroups.Items[Caller.Params[0]]:=TBisFilterGroup(Integer(Caller.Params[1]));
  end;}
end;

function TFunctions.TBisFilterGroups_GetCount(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;
  if AnsiSameText(PropName,'Count') then begin
    Result:=TBisFilterGroups(Instance).FilterGroups.Count;
  end;
end;

function TFunctions.TBisFilterGroups_Clear(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Clear') then begin
    TBisFilterGroups(Instance).FilterGroups.Clear;
  end;
end;

function TFunctions.TBisOrder_GetFieldName(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := '';
  if AnsiSameText(PropName,'FieldName') then begin
    Result:=TBisOrder(Instance).FieldName;
  end;
end;

procedure TFunctions.TBisOrder_SetFieldName(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'FieldName') then begin
    TBisOrder(Instance).FieldName:=VarToStrDef(Value,TBisOrder(Instance).FieldName);
  end;
end;

function TFunctions.TBisOrder_GetOrderType(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;
  if AnsiSameText(PropName,'OrderType') then begin
    Result:=TBisOrder(Instance).OrderType;
  end;
end;

procedure TFunctions.TBisOrder_SetOrderType(Instance: TObject; ClassType: TClass; const PropName: String; Value: Variant);
begin
  if AnsiSameText(PropName,'OrderType') then begin
    TBisOrder(Instance).OrderType:=TBisOrderType(VarToIntDef(Value,Integer(otAsc)));
  end;
end;

function TFunctions.TBisOrders_Add(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  FieldName: String;
  OrderType: TBisOrderType;
begin
  Result:=0;
  if AnsiSameText(MethodName,'Add') then begin
    FieldName:=VarToStrDef(Caller.Params[0],'');
    OrderType:=TBisOrderType(VarToIntDef(Caller.Params[1],Integer(otAsc)));
    Result:=Integer(TBisOrders(Instance).Orders.Add(FieldName,OrderType));
  end;
end;

function TFunctions.TBisOrders_Items(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result:=0;
  if AnsiSameText(MethodName,'Items.Get') then begin
    Result:=Integer(TBisOrders(Instance).Orders.Items[Caller.Params[0]]);
  end;
{  if AnsiSameText(MethodName,'Items.Set') then begin
    TBisOrders(Instance).Orders.Items[Caller.Params[0]]:=TBisOrder(Integer(Caller.Params[1]));
  end;}
end;

function TFunctions.TBisOrders_GetCount(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;
  if AnsiSameText(PropName,'Count') then begin
    Result:=TBisOrders(Instance).Orders.Count;
  end;
end;

function TFunctions.TBisOrders_Clear(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Clear') then begin
    TBisOrders(Instance).Orders.Clear;
  end;
end;

function TFunctions.TBisObjectList_Create(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Create') then begin
    Result:=Integer(TBisObjectList(Instance).Create(TComponent(Integer(Caller.Params[0]))))
  end
end;

function TFunctions.TBisObjectList_Add(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  Obj: TObject;
begin
  Result:=-1;
  if AnsiSameText(MethodName,'Add') then begin
    Obj:=TObject(VarToIntDef(Caller.Params[0],0));
    Result:=TBisObjectList(Instance).Add(Obj);
  end;
end;

function TFunctions.TBisObjectList_Clear(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if AnsiSameText(MethodName,'Clear') then begin
    TBisObjectList(Instance).Clear;
  end;
end;

function TFunctions.TBisObjectList_Count(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result:=0;
  if AnsiSameText(MethodName,'Count') then begin
    Result:=TBisObjectList(Instance).Count;
  end;
end;

function TFunctions.TBisObjectList_Items(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result:=0;
  if AnsiSameText(MethodName,'Items.Get') then begin
    Result:=Integer(TBisObjectList(Instance).Items[Caller.Params[0]]);
  end;
{  if AnsiSameText(MethodName,'Items.Set') then begin
    TBisOrders(Instance).Orders.Items[Caller.Params[0]]:=TBisOrder(Integer(Caller.Params[1]));
  end;}
end;


{ TBisParams }

procedure TBisParams.ReadData(Reader: TReader);
var
  Param: TBisParamInvisible;
begin
  Reader.ReadListBegin;
  FParams.Clear;
  while not Reader.EndOfList do begin
    Param:=FParams.AddInvisible(Reader.ReadString,TParamType(Reader.ReadInteger));
    if Assigned(Param) then begin
      Param.Value:=Reader.ReadVariant;
      Param.DataType:=TFieldType(Reader.ReadInteger);
      Param.IsKey:=Reader.ReadBoolean;
      Param.DefaultValue:=Reader.ReadVariant;
      Param.Size:=Reader.ReadInteger;
      Param.Precision:=Reader.ReadInteger;
      Param.Required:=Reader.ReadBoolean;
      Param.OldValue:=Reader.ReadVariant;
      Param.Olders.Text:=Reader.ReadString;
    end;
  end;
  Reader.ReadListEnd;
end;

procedure TBisParams.WriteData(Writer: TWriter);
var
  I: Integer;
  Param: TBisParam;
begin
  Writer.WriteListBegin;
  for I := 0 to FParams.Count - 1 do begin
    Param:=FParams.Items[i];
    Writer.WriteString(Param.ParamName);
    Writer.WriteInteger(Integer(Param.ParamType));
    Writer.WriteVariant(Param.Value);
    Writer.WriteInteger(Integer(Param.DataType));
    Writer.WriteBoolean(Param.IsKey);
    Writer.WriteVariant(Param.DefaultValue);
    Writer.WriteInteger(Param.Size);
    Writer.WriteInteger(Param.Precision);
    Writer.WriteBoolean(Param.Required);
    Writer.WriteVariant(Param.OldValue);
    Writer.WriteString(Param.Olders.Text);
  end;
  Writer.WriteListEnd;
end;

procedure TBisParams.DefineProperties(Filer: TFiler);

  function DoWrite: Boolean;
  begin
    if Filer.Ancestor <> nil then begin
      Result := True;
    end else
      Result := FParams.Count > 0;
  end;

begin
  Filer.DefineProperty('Params',ReadData,WriteData,DoWrite);
end;

{ TBisFieldNames }

procedure TBisFieldNames.ReadData(Reader: TReader);
var
  FieldName: TBisFieldName;
begin
  Reader.ReadListBegin;
  FFieldNames.Clear;
  while not Reader.EndOfList do begin
    FieldName:=FFieldNames.AddInvisible(Reader.ReadString);
    if Assigned(FieldName) then begin
      FieldName.Caption:=Reader.ReadString;
      FieldName.Width:=Reader.ReadInteger;
      FieldName.Alignment:=TBisFieldNameAlignment(Reader.ReadInteger);
      FieldName.IsKey:=Reader.ReadBoolean;
      FieldName.IsParent:=Reader.ReadBoolean;
      FieldName.Visible:=Reader.ReadBoolean;
      FieldName.DataType:=TFieldType(Reader.ReadInteger);
      FieldName.Size:=Reader.ReadInteger;
      FieldName.Precision:=Reader.ReadInteger;
      FieldName.DisplayFormat:=Reader.ReadString;
      FieldName.FuncType:=TBisFieldNameFuncType(Reader.ReadInteger);
      FieldName.VisualType:=TBisFieldNameVisualType(Reader.ReadInteger);
    end;
  end;
  Reader.ReadListEnd;
end;

procedure TBisFieldNames.WriteData(Writer: TWriter);
var
  I: Integer;
  FieldName: TBisFieldName;
begin
  Writer.WriteListBegin;
  for I := 0 to FFieldNames.Count - 1 do begin
    FieldName:=FFieldNames.Items[i];
    Writer.WriteString(FieldName.FieldName);
    Writer.WriteString(FieldName.Caption);
    Writer.WriteInteger(FieldName.Width);
    Writer.WriteInteger(Integer(FieldName.Alignment));
    Writer.WriteBoolean(FieldName.IsKey);
    Writer.WriteBoolean(FieldName.IsParent);
    Writer.WriteBoolean(FieldName.Visible);
    Writer.WriteInteger(Integer(FieldName.DataType));
    Writer.WriteInteger(FieldName.Size);
    Writer.WriteInteger(FieldName.Precision);
    Writer.WriteString(FieldName.DisplayFormat);
    Writer.WriteInteger(Integer(FieldName.FuncType));
    Writer.WriteInteger(Integer(FieldName.VisualType));
  end;
  Writer.WriteListEnd;
end;

procedure TBisFieldNames.DefineProperties(Filer: TFiler);

  function DoWrite: Boolean;
  begin
    if Filer.Ancestor <> nil then begin
      Result := True;
    end else
      Result := FFieldNames.Count > 0;
  end;

begin
  Filer.DefineProperty('FieldNames',ReadData,WriteData,DoWrite);
end;

{ TBisFilterGroups }

procedure TBisFilterGroups.ReadData(Reader: TReader);
var
  FieldName: String;
  Operator: TBisFilterOperator;
  Condition: TBisFilterCondition;
  CheckCase: Boolean;
  RightSide: Boolean;
  LeftSide: Boolean;
  Value: Variant;
  FilterType: TBisFilterType;
  Group: TBisFilterGroup;
  Filter: TBisFilter;
begin
  Reader.ReadListBegin;
  FFilterGroups.Clear;
  while not Reader.EndOfList do begin
    Group:=FFilterGroups.AddByName(Reader.ReadString,TBisFilterOperator(Reader.ReadInteger));
    if Assigned(Group) then begin
      Group.Enabled:=Reader.ReadBoolean;
      Group.Visible:=Reader.ReadBoolean;
      Group.Active:=Reader.ReadBoolean;
      Reader.ReadListBegin;
      while not Reader.EndOfList do begin
        FieldName:=Reader.ReadString;
        Operator:=TBisFilterOperator(Reader.ReadInteger);
        Condition:=TBisFilterCondition(Reader.ReadInteger);
        CheckCase:=Reader.ReadBoolean;
        RightSide:=Reader.ReadBoolean;
        LeftSide:=Reader.ReadBoolean;
        Value:=Reader.ReadVariant;
        FilterType:=TBisFilterType(Reader.ReadInteger);
        Filter:=Group.Filters.Add(FieldName,Condition,Value);
        if Assigned(Filter) then begin
          Filter.Operator:=Operator;
          Filter.CheckCase:=CheckCase;
          Filter.RightSide:=RightSide;
          Filter.LeftSide:=LeftSide;
          Filter.Value:=Value;
          Filter.FilterType:=FilterType;
        end;
      end;
      Reader.ReadListEnd;
    end;
  end;
  Reader.ReadListEnd;
end;

procedure TBisFilterGroups.WriteData(Writer: TWriter);
var
  I, J: Integer;
  Group: TBisFilterGroup;
  Filter: TBisFilter;
begin
  Writer.WriteListBegin;
  for I := 0 to FFilterGroups.Count - 1 do begin
    Group:=FFilterGroups.Items[i];
    Writer.WriteString(Group.GroupName);
    Writer.WriteInteger(Integer(Group.Operator));
    Writer.WriteBoolean(Group.Enabled);
    Writer.WriteBoolean(Group.Visible);
    Writer.WriteBoolean(Group.Active);
    Writer.WriteListBegin;
    for J:=0 to Group.Filters.Count-1 do begin
      Filter:=Group.Filters.Items[J];
      Writer.WriteString(Filter.FieldName);
      Writer.WriteInteger(Integer(Filter.Operator));
      Writer.WriteInteger(Integer(Filter.Condition));
      Writer.WriteBoolean(Filter.CheckCase);
      Writer.WriteBoolean(Filter.RightSide);
      Writer.WriteBoolean(Filter.LeftSide);
      Writer.WriteVariant(Filter.Value);
      Writer.WriteInteger(Integer(Filter.FilterType));
    end;
    Writer.WriteListEnd;
  end;
  Writer.WriteListEnd;
end;

procedure TBisFilterGroups.DefineProperties(Filer: TFiler);

  function DoWrite: Boolean;
  begin
    if Filer.Ancestor <> nil then begin
      Result := True;
    end else
      Result := FFilterGroups.Count > 0;
  end;

begin
  Filer.DefineProperty('FilterGroups',ReadData,WriteData,DoWrite);
end;

{ TBisOrders }

procedure TBisOrders.ReadData(Reader: TReader);
var
  Order: TBisOrder;
begin
  Reader.ReadListBegin;
  FOrders.Clear;
  while not Reader.EndOfList do begin
    Order:=Orders.Add(Reader.ReadString,TBisOrderType(Reader.ReadInteger));
    if Assigned(Order) then begin
      Order.Caption:=Reader.ReadString;
    end;
  end;
  Reader.ReadListEnd;
end;

procedure TBisOrders.WriteData(Writer: TWriter);
var
  I: Integer;
  Order: TBisOrder;
begin
  Writer.WriteListBegin;
  for I := 0 to FOrders.Count - 1 do begin
    Order:=FOrders.Items[i];
    Writer.WriteString(Order.FieldName);
    Writer.WriteInteger(Integer(Order.OrderType));
    Writer.WriteString(Order.Caption);
    Writer.WriteListEnd;
  end;
  Writer.WriteListEnd;
end;

procedure TBisOrders.DefineProperties(Filer: TFiler);

  function DoWrite: Boolean;
  begin
    if Filer.Ancestor <> nil then begin
      Result := True;
    end else
      Result := FOrders.Count > 0;
  end;

begin
  Filer.DefineProperty('Orders',ReadData,WriteData,DoWrite);
end;

{ TBisProvider }

constructor TBisProvider.Create(AOwner: TComponent);
begin
  FProvider:=BisProvider.TBisProvider.Create(nil);
  DataSet:=FProvider;

  inherited Create(AOwner);
  BaseName:=SProvider;

  FParams:=TBisParams.Create;
  FParams.Params:=FProvider.Params;

  FFieldNames:=TBisFieldNames.Create;
  FFieldNames.FieldNames:=FProvider.FieldNames;

  FFilterGroups:=TBisFilterGroups.Create;
  FFilterGroups.FilterGroups:=FProvider.FilterGroups;

  FOrders:=TBisOrders.Create;
  FOrders.Orders:=FProvider.Orders;

end;

destructor TBisProvider.Destroy;
begin
  FOrders.Free;
  FFilterGroups.Free;
  FFieldNames.Free;
  FParams.Free;
  inherited Destroy;
end;

procedure TBisProvider.Execute;
begin
  if Assigned(FProvider) then
    FProvider.Execute;
end;

procedure TBisProvider.First;
begin
  if Assigned(FProvider) then
    FProvider.First;
end;

procedure TBisProvider.Next;
begin
  if Assigned(FProvider) then
    FProvider.Next;
end;

procedure TBisProvider.Post;
begin
  if Assigned(FProvider) then
    FProvider.Post;
end;

procedure TBisProvider.Prior;
begin
  if Assigned(FProvider) then
    FProvider.Prior;
end;

procedure TBisProvider.Last;
begin
  if Assigned(FProvider) then
    FProvider.Last;
end;

function TBisProvider.Bof: Boolean;
begin
  Result:=false;
  if Assigned(FProvider) then
    Result:=FProvider.Bof;
end;

procedure TBisProvider.Edit;
begin
  if Assigned(FProvider) then
    FProvider.Edit;
end;

function TBisProvider.Eof: Boolean;
begin
  Result:=false;
  if Assigned(FProvider) then
    Result:=FProvider.Eof;
end;

class function TBisProvider.GetDescription: String;
begin
  Result:=SProviderDesc;
end;

procedure TBisProvider.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (AComponent=FProvider) and (Operation=opRemove) then
    FProvider:=nil;
end;

procedure TBisProvider.Open;
begin
  inherited Open;
  if Assigned(FProvider) then
    if not FProvider.Active then
      FProvider.Open;
end;

procedure TBisProvider.CreateTable(Source: TfrxCustomDataset);
begin
  if Assigned(FProvider) then begin
    if Assigned(Source) then
      FProvider.CreateTable(Source.DataSet)
    else
      FProvider.CreateTable;
  end;
end;

procedure TBisProvider.CopyRecords(Source: TfrxCustomDataset);
begin
  if Assigned(FProvider) and Assigned(Source) then
    FProvider.CopyRecords(Source.DataSet);
end;

procedure TBisProvider.CopyRecord(Source: TfrxCustomDataset);
begin
  if Assigned(FProvider) and Assigned(Source) then
    FProvider.CopyRecord(Source.DataSet);
end;

function TBisProvider.GetFetchCount: Integer;
begin
  Result:=0;
  if Assigned(FProvider) then
    Result:=FProvider.FetchCount;
end;

procedure TBisProvider.SetFetchCount(const Value: Integer);
begin
  if Assigned(FProvider) then
    FProvider.FetchCount:=Value;
end;

procedure TBisProvider.SetFieldNames(const Value: TBisFieldNames);
begin
  if Assigned(FProvider) then
    FProvider.FieldNames.CopyFrom(Value.FieldNames);
end;

procedure TBisProvider.SetFilterGroups(const Value: TBisFilterGroups);
begin
  if Assigned(FProvider) then
    FProvider.FilterGroups.CopyFrom(Value.FilterGroups);
end;

procedure TBisProvider.SetOrders(const Value: TBisOrders);
begin
  if Assigned(FProvider) then
    FProvider.Orders.CopyFrom(Value.Orders);
end;

procedure TBisProvider.SetParams(const Value: TBisParams);
begin
  if Assigned(FProvider) then
    FProvider.Params.CopyFrom(Value.Params);
end;

function TBisProvider.GetProviderName: String;
begin
  Result:='';
  if Assigned(FProvider) then
    Result:=FProvider.ProviderName;
end;

procedure TBisProvider.SetProviderName(const Value: String);
begin
  if Assigned(FProvider) then
    FProvider.ProviderName:=Value;
end;

function TBisProvider.GetOpenMode: TBisProviderOpenMode;
begin
  Result:=omOpen;
  if Assigned(FProvider) then
    Result:=FProvider.OpenMode;
end;

procedure TBisProvider.SetOpenMode(const Value: TBisProviderOpenMode);
begin
  if Assigned(FProvider) then
    FProvider.OpenMode:=Value;
end;


constructor TBisProvider.DesignCreate(AOwner: TComponent; Flags: Word);
begin
  inherited DesignCreate(AOwner,Flags);
end;

procedure TBisProvider.Append;
begin
  if Assigned(FProvider) then
    FProvider.Append;
end;

procedure TBisProvider.BeforeStartReport;
begin
end;

procedure TBisProvider.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
end;

{ TBisObjectList }

constructor TBisObjectList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FList:=TObjectList.Create;
end;

destructor TBisObjectList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TBisObjectList.GetItems(Index: Integer): TObject;
begin
  Result:=FList.Items[Index];
end;

function TBisObjectList.Add(AObject: TObject): Integer;
begin
  Result:=FList.Add(AObject);
end;

procedure TBisObjectList.Clear;
begin
  FList.Clear;
end;

function TBisObjectList.Count: Integer;
begin
  Result:=FList.Count;
end;

{ TBisProviderNameProperty }

function TBisProviderNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result:=[paMultiSelect];
end;

{ TBisProviderParamsProperty }

function TBisProviderParamsProperty.Edit: Boolean;
{var
  Form: TBisBaseParamsForm;}
begin
  Result:=false;
{  Form:=TBisBaseParamsForm.Create(Designer);
  try
    Form.Params:=TBisProvider(Component).Params.Params;
    Result:=Form.ShowModal=mrOk;
  finally
    Form.Free;
  end;}
end;

function TBisProviderParamsProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

{ TBisProviderFieldNamesProperty }

function TBisProviderFieldNamesProperty.Edit: Boolean;
var
  Form: TBisFieldNamesForm;
begin
  Result:=false;
  if Assigned(Component) and (Component is TBisProvider) then begin
    Form:=TBisFieldNamesForm.Create(Designer);
    try
      Form.FieldNames:=TBisProvider(Component).FieldNames.FieldNames;
      Result:=Form.ShowModal=mrOk;
      if Result then begin
      end;
    finally
      Form.Free;
    end;
  end;
end;

function TBisProviderFieldNamesProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

{ TBisProviderOrdersProperty }

function TBisProviderOrdersProperty.Edit: Boolean;
var
  Form: TBisOrdersForm;
begin
  Result:=false;
  if Assigned(Component) and (Component is TBisProvider) then begin
    Form:=TBisOrdersForm.Create(Designer);
    try
      Form.Orders:=TBisProvider(Component).Orders.Orders;
      Result:=Form.ShowModal=mrOk;
    finally
      Form.Free;
    end;
  end;
end;

function TBisProviderOrdersProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

{ TBisProviderFilterGroupsProperty }

function TBisProviderFilterGroupsProperty.Edit: Boolean;
{var
  Form: TBisBaseFilterGroupsForm;
  CoreIntf: IBisCore;
  Database: IBisDatabase;
  ProviderName: String;}
begin
  Result:=false;
{ CoreIntf:=TBisProvider(Component).CoreIntf;
  if Assigned(CoreIntf) then begin
    ProviderName:=TBisProvider(Component).ProviderName;
    Database:=CoreIntf.DatabaseModules.Current.Database;
    if Database.ProviderExists(ProviderName) then begin
      Form:=TBisBaseFilterGroupsForm.Create(Designer);
      try
        Form.FilterGroups:=TBisProvider(Component).FilterGroups.FilterGroups;
        Form.ProviderName:=ProviderName;
        Form.CoreIntf:=CoreIntf;
        Result:=Form.ShowModal=mrOk;
      finally
        Form.Free;
      end;
    end else
      Raise Exception.CreateFmt(SProviderNotFound,[ProviderName]);
  end;}
end;

function TBisProviderFilterGroupsProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;


var
  B1: TBitmap;

initialization
  B1:=TBitmap.Create;
  B1.LoadFromResourceName(HInstance,UpperCase('BisProvider'));
  frxObjects.RegisterObject1(TBisProvider,B1,'','',0,-1,[ctData]);
  frxPropertyEditors.Register(TypeInfo(String),TBisProvider,'ProviderName',TBisProviderNameProperty);
  frxPropertyEditors.Register(TypeInfo(TBisParams), TBisProvider, 'Params', TBisProviderParamsProperty);
  frxPropertyEditors.Register(TypeInfo(TBisFieldNames), TBisProvider, 'FieldNames', TBisProviderFieldNamesProperty);
  frxPropertyEditors.Register(TypeInfo(TBisOrders), TBisProvider, 'Orders', TBisProviderOrdersProperty);
  frxPropertyEditors.Register(TypeInfo(TBisFilterGroups), TBisProvider, 'FilterGroups', TBisProviderFilterGroupsProperty); 
  frxResources.Add('propProviderName','��� ���������� ������ �� �������');
  frxResources.Add('propFetchCount','���������� �������, ������������� � �������. �������� -1 ��� ������');
  frxResources.Add('propFieldNames','������ �����, ������������ ��� ������� � �������. ������ ������ ��� ����');
  frxResources.Add('propOrders','���������� ������ �� �������');
  frxResources.Add('propFilterGroups','���������� ������ �� �������');
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules<>nil then fsRTTIModules.Remove(TFunctions);
  frxObjects.UnRegister(TBisProvider);
  B1.Free;
  
end.
