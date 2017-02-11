unit dws2IbxModule;

interface

uses
  SysUtils, Classes, dws2Comp, dws2Exprs, IBDatabase, DB, IBCustomDataSet,
  IBQuery;

type
  TdwsIBXStatementObj = class(TObject)
    IBXStatement: TIBCustomDataSet;
    LUCol, ParamCol: TField;
    KeyFieldName, KeyFieldValue, LUFieldName: string;
    procedure AddLUFieldRow(sFieldValue: string);
  public

    destructor destroy; override;
  end;

  TdwsIbxDataBaseObj = class(TObject)
    IBXConnection: TIBDatabase;
  public
    destructor destroy; override;
  end;

  TdwsDBGroupObj = class(TObject)
    IBXDataset: TIBDataset;
    GroupCol: TField;
    GroupFieldName, GroupFieldValue: string;
    iGroupCnt: Integer;
    boNewGrp: boolean;
    GroupValues: TStringList;
    procedure AddFieldValue(IboCol: TField);
    procedure ResetGroup;
    procedure AddGroupRow;
    function GetGroupSum(sFieldName: string): extended;
  end;

  TiboLookUpObj = class(TdwsIBXStatementObj)
  end;

  Tdws2IBXLib = class(TDataModule)
    customIBXUnit: Tdws2Unit;
    procedure customIBXUnitClassesTStatementMethodsGetSQLEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTStatementMethodsSetSQLEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTStatementMethodsExecuteEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTStatementMethodsFieldByNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTStatementMethodsFieldEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTStatementMethodsParamByNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTStatementMethodsSetParamEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatasetMethodsOpenEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatasetMethodsFirstEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatasetMethodsNextEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatasetMethodsEditEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatasetMethodsInsertEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatasetMethodsPostEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatasetMethodsDeleteEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatasetMethodsCloseEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatasetMethodsEofEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatasetMethodsCancelEval(
      Info: TProgramInfo; ExtObject: TObject);

    procedure customIBXUnitClassesTQueryMethodsPriorEval(
      Info: TProgramInfo; ExtObject: TObject);

    procedure customIBXUnitClassesTFieldMethodsSetValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTFieldMethodsGetValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTFieldMethodsSetValueStrEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTFieldMethodsGetValueStrEval(
      Info: TProgramInfo; ExtObject: TObject);

    procedure customIBXUnitClassesTStatementMethodsFieldIsNullEval(
      Info: TProgramInfo; ExtObject: TObject);

    procedure customIBXUnitClassesTQueryMethodsGetFilterEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTQueryMethodsSetFilterEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTQueryMethodsGetFilteredEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTQueryMethodsSetFilteredEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTQueryMethodsGetSortOrderEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTQueryMethodsSetSortOrderEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDataSetGrpMethodsAddSumFieldEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDataSetGrpMethodsGroupEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDataSetGrpMethodsCountEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDataSetGrpMethodsAddGroupRowEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDataSetGrpMethodsRestartGroupEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDataSetGrpMethodsResetGroupEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDataSetGrpMethodsSumOfFieldEval(
      Info: TProgramInfo; ExtObject: TObject);

    procedure customIBXUnitClassesTDatabaseMethodsconnectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatabaseMethodsdisconnectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatabaseMethodssetdialectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatabaseMethodsgetdialectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatabaseMethodssetcharsetEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatabaseMethodsgetcharsetEval(
      Info: TProgramInfo; ExtObject: TObject);

    procedure customIBXUnitClassesTQueryMethodsLookUpEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTQueryMethodsSetLookUpFieldsEval(
      Info: TProgramInfo; ExtObject: TObject);

    procedure customIBXUnitClassesTLUFieldMethodsGetValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTLUFieldMethodsGetValueStrEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTLUFieldMethodsSetValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTLUFieldMethodsSetValueStrEval(
      Info: TProgramInfo; ExtObject: TObject);

    procedure customIBXUnitClassesTDBFieldMethodsSetIntegerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDBFieldMethodsSetFloatEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDBFieldMethodsSetDateTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDBFieldMethodsGetIntegerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDBFieldMethodsGetFloatEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDBFieldMethodsGetDateTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatasetMethodsExecSQLEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBXUnitClassesTDatabaseConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBXUnitClassesTStatementConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBXUnitClassesTStatementConstructorsCreateFromDBAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBXUnitClassesTDatasetConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBXUnitClassesTDatasetConstructorsCreateFromDBAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBXUnitClassesTQueryConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBXUnitClassesTQueryConstructorsCreateFromDBAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBXUnitClassesTDataSetGrpConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);

  private
    FScript: TDelphiWebScriptII;
    FIBXConnection: TIBDatabase;
    FIBXTransaction: TIBTransaction;
    procedure SetScript(const Value: TDelphiWebScriptII);
    procedure LUFieldSetValue(FieldValue: variant; ExtObject: TObject);
    procedure SetIBXConnection(const Value: TIBDatabase);
    procedure SetIBXTransaction(const Value: TIBTransaction);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  published
    property Script: TDelphiWebScriptII read FScript write SetScript;
    property IBXDatabase: TIBDatabase read FIBXConnection write
      SetIBXConnection;
    property IBXTransaction: TIBTransaction read FIBXTransaction write
      SetIBXTransaction;
  end;

procedure Register;

var
  dws2IBXLib: Tdws2IBXLib;

implementation

{$R *.dfm}

uses
  dws2Symbols;

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2IbxLib]);
end;

{ Tdws2IBXLibrary }

procedure Tdws2IBXLib.customIBXUnitClassesTDatabaseMethodsconnectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsIbxDataBaseObj(ExtObject) do
  begin
    IBXConnection.Connected := true;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatabaseConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  dbh: TdwsIbxDataBaseObj;
begin
  dbh := TdwsIbxdataBaseObj.Create;
  dbh.IBXConnection := TIBDatabase.Create(self);
  dbh.IBXConnection.DatabaseName := Info['Database'];
  dbh.IBXConnection.Params.Add('user_name=' + Info['user']);
  dbh.IBXConnection.Params.Add('password=' + Info['pwd']);
  { TODO : Important: Connection type specified by db-filename string!!! }
  // dbh.IBXConnection.Protocol := cpTCP_IP;
  dbh.IBXConnection.Connected := true;
  ExtObject := dbh;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatabaseMethodsdisconnectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsIbxDataBaseObj(ExtObject) do
  begin
    IBXConnection.Connected := false;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatabaseMethodsgetcharsetEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  raise Exception.Create('Not yet supported ..');
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatabaseMethodsgetdialectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TdwsIbxDataBaseObj(ExtObject).IBXConnection.SQLDialect;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatabaseMethodssetcharsetEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  con: boolean;
begin
  with TdwsIbxDataBaseObj(ExtObject).IBXConnection do
  begin
    con := Connected;
    Connected := false;
    Params.Add('lc_ctype=' + Info['sCharSet']);
    Connected := con;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatabaseMethodssetdialectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsIbxDataBaseObj(ExtObject).IBXConnection.SQLDialect := Info['iDialect'];
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDataSetGrpMethodsAddGroupRowEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsDBGroupObj(ExtObject) do
  begin
    AddGroupRow;
    if boNewGrp then
    begin
      GroupFieldValue := GroupCol.AsString;
      boNewGrp := false;
      iGroupCnt := 0;
    end
    else
      boNewGrp := not (GroupFieldValue = GroupCol.AsString)
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDataSetGrpMethodsAddSumFieldEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsDBGroupObj(ExtObject) do
  begin
    GroupValues.Add(Info['FieldName'] + '=0');
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDataSetGrpMethodsCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['result'] := TdwsDBGroupObj(ExtObject).iGroupCnt;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDataSetGrpConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  IBGroup: TdwsDBGroupObj;
  ScriptObj: IScriptObj;
  DBObj: TdwsIBXStatementObj;
begin
  ScriptObj := IScriptObj(IUnknown(Info['DataSet']));
  if ScriptObj = nil then
    DBObj := nil
  else
    DBObj := TdwsIBXStatementObj(ScriptObj.ExternalObject);
  IBGroup := TdwsDBGroupObj.Create;
  try
    IBGroup.IBXDataset := DBObj.IBxStatement as TIBDataset;
    IBGroup.GroupFieldName := Info['GroupFieldName'];
    IBGroup.GroupCol := IBGroup.IBXDataset.FieldByName(IBGroup.GroupFieldName);
    IBGroup.GroupFieldValue := IBGroup.GroupCol.AsString;
    IBGroup.GroupValues := TStringList.Create;
    ExtObject := IBGroup;
  except
    raise;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDataSetGrpMethodsGroupEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  IBGroup: TdwsDBGroupObj;
  boOK: boolean;
begin
  IBGroup := TdwsDBGroupObj(ExtObject);
  if not (IBGroup.IBXDataset.eof or IBGroup.IBXDataset.bof) then
  begin
    boOK := IBGroup.GroupFieldValue = IBGroup.GroupCol.AsString;
    if boOK then
      inc(IBGroup.iGroupCnt);
    Info['result'] := not boOK;
  end
  else
    Info['result'] := true;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDataSetGrpMethodsResetGroupEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsDBGroupObj(ExtObject) do
  begin
    ResetGroup;
    GroupFieldValue := GroupCol.AsString;
    boNewGrp := false;
    iGroupCnt := 0;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDataSetGrpMethodsRestartGroupEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsDBGroupObj(ExtObject) do
  begin
    // ResetGroup;
    GroupFieldValue := GroupCol.AsString;
    boNewGrp := false;
    iGroupCnt := 0;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDataSetGrpMethodsSumOfFieldEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['result'] := TdwsDBGroupObj(ExtObject).GetGroupSum(Info['FieldName']);
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatasetMethodsCancelEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBDataset(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Cancel;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatasetMethodsCloseEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBDataset(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Close;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatasetConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TdwsIBXStatementObj.Create;
  TdwsIBXStatementObj(ExtObject).IBXStatement := TIBDataset.Create(self);
  TdwsIBXStatementObj(ExtObject).IBXStatement.Database := FIBXConnection;
  TdwsIBXStatementObj(ExtObject).IBXStatement.Transaction := FIBXTransaction;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatasetConstructorsCreateFromDBAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  ScriptObj: IScriptObj;
  DBObj: TdwsIbxDataBaseObj;
begin
  ScriptObj := IScriptObj(IUnknown(Info['Database']));
  if ScriptObj = nil then
    DBObj := nil
  else
    DBObj := TdwsIbxDataBaseObj(ScriptObj.ExternalObject);

  ExtObject := TdwsIBXStatementObj.Create;
  TdwsIBXStatementObj(ExtObject).IBXStatement := TIBDataset.Create(self);
  TdwsIBXStatementObj(ExtObject).IBXStatement.Database := DBObj.IBXConnection;
  TdwsIBXStatementObj(ExtObject).IBXStatement.Transaction := FIBXTransaction;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatasetMethodsDeleteEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBDataset(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Delete;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatasetMethodsEditEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBDataset(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Edit;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatasetMethodsEofEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBDataset(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Info['Result'] := eof;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatasetMethodsFirstEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBDataset(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    First;
    Info['Result'] := not eof;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatasetMethodsInsertEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBDataset(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Insert;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatasetMethodsNextEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBDataset(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Next;
    Info['Result'] := not eof;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatasetMethodsOpenEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBDataset(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Prepare;
    Open;
    First;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatasetMethodsPostEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBDataset(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Post;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDBFieldMethodsGetDateTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if ExtObject is TField then
    Info['Result'] := TField(ExtObject).AsDateTime
  else if ExtObject is TParam then
    Info['Result'] := TParam(ExtObject).AsDateTime;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDBFieldMethodsGetFloatEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if ExtObject is TField then
    Info['Result'] := TField(ExtObject).AsFloat
  else if ExtObject is TParam then
    Info['Result'] := TParam(ExtObject).AsFloat;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDBFieldMethodsGetIntegerEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if ExtObject is TField then
    Info['Result'] := TField(ExtObject).AsInteger
  else if ExtObject is TParam then
    Info['Result'] := TParam(ExtObject).AsInteger;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDBFieldMethodsSetDateTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if ExtObject is TField then
    TField(ExtObject).AsDateTime := Info['Value']
  else if ExtObject is TParam then
    TParam(ExtObject).AsDateTime := Info['Value'];
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDBFieldMethodsSetFloatEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if ExtObject is TField then
    TField(ExtObject).AsFloat := Info['Value']
  else if ExtObject is TParam then
    TParam(ExtObject).AsFloat := Info['Value'];
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDBFieldMethodsSetIntegerEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if ExtObject is TField then
    TField(ExtObject).AsInteger := Info['Value']
  else if ExtObject is TParam then
    TParam(ExtObject).AsInteger := Info['Value'];
end;

procedure Tdws2IBXLib.customIBXUnitClassesTFieldMethodsGetValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if ExtObject is TField then
    Info['Result'] := TField(ExtObject).AsVariant
  else if ExtObject is TParam then
    Info['Result'] := TParam(ExtObject).AsString;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTFieldMethodsGetValueStrEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if ExtObject is TField then
    Info['Result'] := TField(ExtObject).AsString
  else if ExtObject is TParam then
    Info['Result'] := TParam(ExtObject).AsString;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTFieldMethodsSetValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if ExtObject is TField then
    TField(ExtObject).AsVariant := Info['Value']
  else if ExtObject is TParam then
    TParam(ExtObject).AsString := Info['Value'];
end;

procedure Tdws2IBXLib.customIBXUnitClassesTFieldMethodsSetValueStrEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if ExtObject is TField then
    TField(ExtObject).AsString := Info['Value']
  else if ExtObject is TParam then
    TParam(ExtObject).AsString := Info['Value'];
end;

procedure Tdws2IBXLib.customIBXUnitClassesTLUFieldMethodsGetValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  { TODO : .IsNumeric not supported }
 //if TdwsIBXStatementObj(ExtObject).LUCol.IsNumeric then
 //  Info['Result'] := 0.0
 //else
  Info['Result'] := '';
end;

procedure Tdws2IBXLib.customIBXUnitClassesTLUFieldMethodsGetValueStrEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  { TODO : .IsNumeric not supported }
//  if TdwsIBOStatementObj(ExtObject).LUCol.IsNumeric then
//    Info['Result'] := '0'
//  else
  Info['Result'] := '';
end;

procedure Tdws2IBXLib.customIBXUnitClassesTLUFieldMethodsSetValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  LUFieldSetValue(Info['Value'], ExtObject);
end;

procedure Tdws2IBXLib.customIBXUnitClassesTLUFieldMethodsSetValueStrEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  vFieldValue: variant;
begin
  vFieldValue := Info['Value'];
  LUFieldSetValue(vFieldValue, ExtObject);
end;

procedure Tdws2IBXLib.customIBXUnitClassesTQueryConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TdwsIBXStatementObj.Create;
  TdwsIBXStatementObj(ExtObject).IBXStatement := TIBQuery.Create(self);
  TdwsIBXStatementObj(ExtObject).IBXStatement.Database := FIBXConnection;
  TdwsIBXStatementObj(ExtObject).IBXStatement.Transaction := FIBXTransaction;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTQueryConstructorsCreateFromDBAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  ScriptObj: IScriptObj;
  DBObj: TdwsIbxDataBaseObj;
begin
  ScriptObj := IScriptObj(IUnknown(Info['Database']));
  if ScriptObj = nil then
    DBObj := nil
  else
    DBObj := TdwsIbxDataBaseObj(ScriptObj.ExternalObject);

  ExtObject := TdwsIBXStatementObj.Create;
  TdwsIBXStatementObj(ExtObject).IBXStatement := TIBQuery.Create(self);
  TdwsIBXStatementObj(ExtObject).IBXStatement.Database := DBObj.IBXConnection;
  TdwsIBXStatementObj(ExtObject).IBXStatement.Transaction := FIBXTransaction;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTQueryMethodsGetFilteredEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBQuery(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Info['Result'] := Filtered;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTQueryMethodsGetFilterEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBQuery(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Info['Result'] := Filter;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTQueryMethodsGetSortOrderEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  raise Exception.Create('Not supported by IBX');
end;

procedure Tdws2IBXLib.customIBXUnitClassesTQueryMethodsLookUpEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  DBLookUp: TdwsIBXStatementObj;
begin
  DBLookUp := TdwsIBXStatementObj(ExtObject);
  DBlookUp.KeyFieldValue := Info['KeyFieldValue'];
  if Assigned(DBLookUp.LUCol) then
    with DBLookUp do
    begin
      if TIBQuery(IBXStatement).Locate(KeyFieldName, KeyFieldValue,
        [loCaseInsensitive]) then
      begin
        Info['Result'] :=
          Info.Vars['TDBField'].GetConstructor('Create', LUCol).Call.Value;
      end
      else
      begin // datarow not found by locate
        Info['Result'] :=
          Info.Vars['TLUField'].GetConstructor('Create', DBLookUp).Call.Value;
      end;
    end
  else
    Info['Result'] := 'no lookup field';
end;

procedure Tdws2IBXLib.customIBXUnitClassesTQueryMethodsPriorEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBQuery(TdwsIBxStatementObj(ExtObject).IBXStatement) do
  begin
    prior;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTQueryMethodsSetFilteredEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBQuery(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Filtered := Info['Filtered'];
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTQueryMethodsSetFilterEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBQuery(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Filter := Info['FilterStr'];
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTQueryMethodsSetLookUpFieldsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsIBXStatementObj(ExtObject) do
  try
    if not (IBXStatement as TIBQuery).Prepared then
      (IBXStatement as TIBQuery).Prepare;
    KeyFieldName := Info['KeyFieldName'];
    LUFieldName := Info['LUFieldName'];
    //    ParamCol := IBOStatement.ParamByName(KeyFieldName);
    LUCol := IBXStatement.FieldByName(LUFieldName);
  except
    raise;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTQueryMethodsSetSortOrderEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  raise Exception.Create('Not supported by IBX');
end;

procedure Tdws2IBXLib.customIBXUnitClassesTStatementConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TdwsIBXStatementObj.Create;
  TdwsIBXStatementObj(ExtObject).IBXStatement := TIBQuery.Create(self);
  TdwsIBXStatementObj(ExtObject).IBXStatement.Database := FIBXConnection;
  TdwsIBXStatementObj(ExtObject).IBXStatement.Transaction := FIBXTransaction;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTStatementConstructorsCreateFromDBAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  ScriptObj: IScriptObj;
  DBObj: TdwsIbxDataBaseObj;
begin
  ScriptObj := IScriptObj(IUnknown(Info['Database']));
  if ScriptObj = nil then
    DBObj := nil
  else
    DBObj := TdwsIbxDataBaseObj(ScriptObj.ExternalObject);

  ExtObject := TdwsIBXStatementObj.Create;
  TdwsIBXStatementObj(ExtObject).IBXStatement := TIBQuery.Create(self);
  TdwsIBXStatementObj(ExtObject).IBXStatement.Database := DBObj.IBXConnection;
  TdwsIBXStatementObj(ExtObject).IBXStatement.Transaction := FIBXTransaction;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTStatementMethodsExecuteEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (TdwsIBXStatementObj(ExtObject).IBXStatement as TIBQuery).ExecSQL;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTStatementMethodsFieldByNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    Info.Vars['TDBField'].GetConstructor('Create',
    TdwsIBXStatementObj(ExtObject).IBXStatement.FieldByName(Info['FieldName'])
    ).Call.Value;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTStatementMethodsFieldEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  MyStatement: TIBCustomDataSet;
  IboCol: TField;
  sFieldName: string;
begin
  MyStatement := TdwsIBXStatementObj(ExtObject).IBXStatement;
  sFieldName := Info['FieldName'];
  IboCol := MyStatement.FindField(sFieldName);
  with MyStatement do
    if IboCol = nil then
      Info['Result'] := '!!dbfield(' + sFieldName + ')??'
    else
    begin
      if (MyStatement is TIBDataset) and (IboCol.IsNull or
        TIBDataset(MyStatement).eof
        or TIBDataset(MyStatement).bof) then
      begin
        { TODO : .IsNumeric not available in IBX! }
        //if IboCol.IsNumeric then
        //begin
        //   Info['Result'] := 0.0
        //end
        //else
        Info['Result'] := '';
      end
      else
        Info['Result'] := IboCol.AsVariant;
    end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTStatementMethodsFieldIsNullEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Info['Result'] := FieldByName(Info['FieldName']).IsNull;
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTStatementMethodsGetSQLEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (TdwsIBXStatementObj(ExtObject).IBXStatement as
    TIBQuery).SQL.Text;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTStatementMethodsParamByNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    Info.Vars['TDBField'].GetConstructor('Create',
    (TdwsIBXStatementObj(ExtObject).IBXStatement as
    TIBQuery).ParamByName(Info['ParamName'])
    ).Call.Value;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTStatementMethodsSetParamEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (TdwsIBXStatementObj(ExtObject).IBXStatement as
    TIBQuery).parambyname(Info['ParamName']).Value
    := Info['Value'];
end;

procedure Tdws2IBXLib.customIBXUnitClassesTStatementMethodsSetSQLEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (TdwsIBXStatementObj(ExtObject).IBXStatement as TIBQuery).SQL.Text :=
    Info['sSQL'];
end;

procedure Tdws2IBXLib.LUFieldSetValue(FieldValue: variant;
  ExtObject: TObject);
var
  sFieldValue: string;
begin
  with TdwsIBXStatementObj(ExtObject) do
  begin
    if IBxStatement.FieldByName(KeyFieldName).AsString = KeyFieldValue then
    begin
      LUCol.AsVariant := FieldValue;
    end
    else
    begin
      sFieldValue := FieldValue;
      AddLUFieldRow(sFieldValue);
    end;
  end;
end;

procedure Tdws2IBXLib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FScript) then
    SetScript(nil);
  if (Operation = opRemove) and (AComponent = FIBXConnection) then
    SetIBXConnection(nil);
  if (Operation = opRemove) and (AComponent = FIBXTransaction) then
    SetIBXTransaction(nil);
end;

procedure Tdws2IBXLib.SetIBXConnection(const Value: TIBDatabase);
begin
  FIBXConnection := Value;
end;

procedure Tdws2IBXLib.SetIBXTransaction(const Value: TIBTransaction);
begin
  FIBXTransaction := Value;
end;

procedure Tdws2IBXLib.SetScript(const Value: TDelphiWebScriptII);
var
  x: Integer;
begin
  if Assigned(FScript) then
    FScript.RemoveFreeNotification(Self);
  if Assigned(Value) then
    Value.FreeNotification(Self);
  FScript := Value;
  for x := 0 to ComponentCount - 1 do
    if Components[x] is Tdws2Unit then
      Tdws2Unit(Components[x]).Script := Value;
end;
{begin
  FScript := Value;
  customIBXUnit.Script := Value;
end;
}
{ TdwsIBXStatementObj }

procedure TdwsIBXStatementObj.AddLUFieldRow(sFieldValue: string);
begin
  TIBQuery(IBXStatement).Insert;
  IBXStatement.FieldByName(KeyFieldName).asstring := KeyFieldValue;
  LUCol.AsString := sFieldValue;
  TIBQuery(IBXStatement).Post;
end;

destructor TdwsIBXStatementObj.destroy;
begin
  if assigned(IBXStatement) then
    IBXStatement.Close;
  inherited destroy;
end;

{ TdwsIboDataBaseObj }

destructor TdwsIbxDataBaseObj.destroy;
begin
  if assigned(IBXConnection) then
    IBXConnection.Close;
  inherited destroy;
end;

{ TdwsDBGroupObj }

{ATTENTION: IBX fields max. .AsFloat!!!}

procedure TdwsDBGroupObj.AddFieldValue(IboCol: TField);
var
  rSum: extended;
  sH: string;
begin
  rSum := IboCol.AsFloat;
  if GroupValues.IndexOfName(IboCol.FieldName) < 0 then
  begin
    sH := IboCol.FieldName + '=' + Format('%g', [rSum]);
    GroupValues.Add(sH);
  end
  else
  begin
    try
      sH := GroupValues.Values[IboCol.FieldName];
      rSum := rSum + StrToFloat(sH);
    except
      rSum := 0;
    end;
    GroupValues.Values[IboCol.FieldName] := Format('%g', [rSum]);
  end;
end;

procedure TdwsDBGroupObj.AddGroupRow;
var
  rSum: extended;
  sH: string;
  ii: Integer;
begin
  for ii := 0 to GroupValues.Count - 1 do
  begin
    sH := GroupValues.Names[ii];
    rSum := StrToFloat(GroupValues.Values[sH])
      + IBXDataset.FieldByName(sH).AsFloat;
    GroupValues.Values[sH] := Format('%g', [rSum]);
  end;
end;

function TdwsDBGroupObj.GetGroupSum(sFieldName: string): extended;
var
  sH: string;
begin
  try
    sH := GroupValues.Values[sFieldName];
    result := StrToFloat(sH);
  except
    result := 0;
  end;
end;

procedure TdwsDBGroupObj.ResetGroup;
var
  ii: Integer;
begin
  for ii := 0 to GroupValues.Count - 1 do
  begin
    GroupValues.Values[GroupValues.Names[ii]] := '0';
  end;
end;

procedure Tdws2IBXLib.customIBXUnitClassesTDatasetMethodsExecSQLEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIBDataset(TdwsIBXStatementObj(ExtObject).IBXStatement) do
  begin
    Prepare;
    ExecSQL;
  end;
end;

end.

