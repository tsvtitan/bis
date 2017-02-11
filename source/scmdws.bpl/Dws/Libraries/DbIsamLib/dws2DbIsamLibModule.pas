unit dws2DbIsamLibModule;

interface
uses Forms, Classes, dws2Comp, dws2Exprs, dws2Symbols;

{ Class TDBIsamQuery
    Constructor Create(Databasename, SQL : String);
    Destructor Destroy;
    Procedure First;
    Procedure Next;
    Procedure Prior;
    Procedure Last;
    Procedure Append;
    Procedure Insert;
    Procedure Edit;
    Procedure Delete;
    Procedure Cancel;
    Procedure Post;
    Function BOF : Boolean;
    Function EOF : Boolean;
    Function FieldByName(Name : String) : Variant;
    Procedure Store(FieldName : String; Value : Variant);
    Function AsString(FieldName : String) : String;
    Function AsFloat(FieldName : String) : Float;
    Function AsInteger(FieldName : String) : Integer;
    Function AsBoolean(FieldName : String) : Boolean;
    Class Procedure Execute(Alias : String; SQL : String);
    Function Locate(KeyFields : String; KeyValues : Variant) : Boolean;
    Function IsEmpty : Boolean;
    Function RecNo : Integer;
    Function RecordCount : Integer;
  Class TDBIsamTable
    Constructor Create(Databasename, TableName : String);
    Destructor Destroy;
    Procedure First;
    Procedure Next;
    Procedure Last;
    Procedure Prior;
    Procedure Append;
    Procedure Insert;
    Procedure Edit;
    Procedure Delete;
    Procedure Cancel;
    Procedure Post;
    Function BOF : Boolean;
    Function EOF : Boolean;
    Function Locate(KeyFields : String; KeyValues : Variant) : Boolean;
    Function FieldByName(Name : String) : Variant;
    Procedure Store(FieldName : String; Value : Variant);
    Function AsString(FieldName : String) : String;
    Function AsFloat(FieldName : String) : Float;
    Function AsInteger(FieldName : String) : Integer;
    Function AsBoolean(FieldName : String) : Boolean;
    Function IsEmpty : Boolean;
    Property IndexName : String;
    Property Filter : String;
    Function RecNo : Integer;
    Function RecordCount : Integer;
}

type
  Tdws2DbIsamLib = class(TDataModule)
    DbIsamUnit: Tdws2Unit;
    procedure FirstMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure NextMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure LastMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure EofFunction(Info: TProgramInfo; ExtObject: TObject);
    procedure FieldByNameFunction(Info: TProgramInfo; ExtObject: TObject);
    procedure QueryExecute(Info: TProgramInfo; ExtObject: TObject);
    procedure TableGetIndexName(Info: TProgramInfo; ExtObject: TObject);
    procedure TableSetIndexName(Info: TProgramInfo; ExtObject: TObject);
    procedure TableGetFilter(Info: TProgramInfo; ExtObject: TObject);
    procedure TableSetFilter(Info: TProgramInfo; ExtObject: TObject);
    procedure LocateFunction(Info: TProgramInfo; ExtObject: TObject);
    procedure AppendMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure InsertMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure EditMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure DeleteMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure CancelMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure IsEmptyFunction(Info: TProgramInfo; ExtObject: TObject);
    procedure RecNoFunction(Info: TProgramInfo; ExtObject: TObject);
    procedure RecordCountFunction(Info: TProgramInfo; ExtObject: TObject);
    procedure AsStringMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure AsIntegerMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure AsFloatMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure AsBooleanMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure PriorMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure BOFFunction(Info: TProgramInfo; ExtObject: TObject);
    procedure StoreMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure PostMethod(Info: TProgramInfo; ExtObject: TObject);
    procedure QueryConstructorsCreateAssignExternalObject(Info: TProgramInfo; var ExtObject: TObject);
    procedure TableConstructorsCreateAssignExternalObject(Info: TProgramInfo; var ExtObject: TObject);
    procedure AsDateTimeMethod(Info: TProgramInfo; ExtObject: TObject);
  private
    FScript: TDelphiWebScriptII;
    procedure SetScript(const Value: TDelphiWebScriptII);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property Script: TDelphiWebScriptII read FScript write SetScript;
  end;

procedure Register;

implementation
uses DB, DBIsamTb, DbIsamSq, Windows, StrUtils;

{$R *.DFM}

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2DbIsamLib]);
end;

procedure Tdws2DbIsamLib.SetScript;

var
  n: Integer;

begin
  if Assigned(FScript) then
    FScript.RemoveFreeNotification(Self);
  if Assigned(Value) then
    Value.FreeNotification(Self);
  FScript := Value;
  for n := 0 to ComponentCount - 1 do
    if Components[n] is Tdws2Unit then
      Tdws2Unit(Components[n]).Script := Value;
end;

procedure Tdws2DbIsamLib.Notification;
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Script) then
    SetScript(nil)
end;

{ "TDbIsamQuery" and "TDbIsamTable" }

procedure Tdws2DbIsamLib.QueryConstructorsCreateAssignExternalObject;
begin
  ExtObject := TDBIsamQuery.Create(nil);
  with TDBIsamQuery(ExtObject) do
  begin
    DatabaseName := Info['DatabaseName'];
    SQL.Text := Info['Sql'];
    DBSession.PrivateDir := DatabaseName;
    Prepare;
    Active := True;
    Refresh;
  end;
end;

procedure Tdws2DbIsamLib.TableConstructorsCreateAssignExternalObject;
begin
  ExtObject := TDBIsamTable.Create(nil);
  with TDBIsamTable(ExtObject) do
  begin
    DatabaseName := Info['DatabaseName'];
    TableName := Info['TableName'];
    Active := True;
    Refresh;
  end;
end;

procedure Tdws2DbIsamLib.FirstMethod;
begin
  TDataSet(ExtObject).First;
end;

procedure Tdws2DbIsamLib.NextMethod;
begin
  TDataSet(ExtObject).Next;
end;

procedure Tdws2DbIsamLib.PriorMethod;
begin
  TDataSet(ExtObject).Prior;
end;

procedure Tdws2DbIsamLib.LastMethod;
begin
  TDataSet(ExtObject).Last;
end;

procedure Tdws2DbIsamLib.BOFFunction;
begin
  Info['Result'] := TDataSet(ExtObject).BOF;
end;

procedure Tdws2DbIsamLib.EofFunction;
begin
  Info['Result'] := TDataSet(ExtObject).Eof;
end;

procedure Tdws2DbIsamLib.FieldByNameFunction;
begin
  Info['Result'] := TDataSet(ExtObject).FieldByName(Info['Name']).AsVariant;
end;

procedure Tdws2DbIsamLib.QueryExecute;
begin
  with TDbIsamQuery.Create(nil) do
  begin
    DatabaseName := Info['Alias'];
    SQL.Text := Info['Sql'];
    ExecSQL;
    Free;
  end;
end;

procedure Tdws2DbIsamLib.TableGetIndexName;
begin
  Info['Result'] := TDbIsamTable(ExtObject).IndexName;
end;

procedure Tdws2DbIsamLib.TableSetIndexName;
begin
  TDbIsamTable(ExtObject).IndexName := Info['Value'];
end;

procedure Tdws2DbIsamLib.TableGetFilter;
begin
  with TDbIsamTable(ExtObject) do
    Info['Result'] := IfThen(Filtered, Filter);
end;

procedure Tdws2DbIsamLib.TableSetFilter;
begin
  with TDbIsamTable(ExtObject) do
    if Info['Value'] = '' then
      Filtered := False
    else
    begin
      Filtered := True;
      Filter := Info['Value'];
    end;
end;

procedure Tdws2DbIsamLib.LocateFunction;
begin
  Info['Result'] := TDataSet(ExtObject).Locate(Info['KeyFields'], Info['KeyValues'], [loCaseInsensitive]);
end;

procedure Tdws2DbIsamLib.AppendMethod;
begin
  TDataSet(ExtObject).Append;
end;

procedure Tdws2DbIsamLib.InsertMethod;
begin
  TDataSet(ExtObject).Insert;
end;

procedure Tdws2DbIsamLib.EditMethod;
begin
  TDataSet(ExtObject).Edit;
end;

procedure Tdws2DbIsamLib.DeleteMethod;
begin
  TDataSet(ExtObject).Delete;
end;

procedure Tdws2DbIsamLib.CancelMethod;
begin
  TDataSet(ExtObject).Cancel;
end;

procedure Tdws2DbIsamLib.PostMethod;
begin
  TDataSet(ExtObject).Post;
end;

procedure Tdws2DbIsamLib.IsEmptyFunction;
begin
  Info['Result'] := TDataSet(ExtObject).IsEmpty;
end;

procedure Tdws2DbIsamLib.RecNoFunction;
begin
  Info['Result'] := TDataSet(ExtObject).RecNo;
end;

procedure Tdws2DbIsamLib.RecordCountFunction;
begin
  Info['Result'] := TDataSet(ExtObject).RecordCount;
end;

procedure Tdws2DbIsamLib.AsStringMethod;
begin
  Info['Result'] := TDataSet(ExtObject).FieldByName(Info['FieldName']).AsString;
end;

procedure Tdws2DbIsamLib.AsIntegerMethod;
begin
  Info['Result'] := TDataSet(ExtObject).FieldByName(Info['FieldName']).AsInteger;
end;

procedure Tdws2DbIsamLib.AsFloatMethod;
begin
  Info['Result'] := TDataSet(ExtObject).FieldByName(Info['FieldName']).AsFloat;
end;

procedure Tdws2DbIsamLib.AsBooleanMethod;
begin
  Info['Result'] := TDataSet(ExtObject).FieldByName(Info['FieldName']).AsBoolean;
end;

procedure Tdws2DbIsamLib.StoreMethod;
begin
  TDataSet(ExtObject).FieldByName(Info['FieldName']).AsVariant := Info['Value'];
end;

procedure Tdws2DbIsamLib.AsDateTimeMethod;
begin
  Info['Result'] := TDataSet(ExtObject).FieldByName(Info['FieldName']).AsDateTime;
end;

end.

