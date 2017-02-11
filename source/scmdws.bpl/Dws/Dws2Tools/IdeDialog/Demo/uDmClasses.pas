unit uDmClasses;

interface

uses
  SysUtils, Classes, Forms, dws2Comp, dws2Exprs, dws2Symbols;

type
  TPippo = class
    uno: string;
    due: string;
  end;
  
  TdmClasses = class(TDataModule)
    dwsTemp: TDelphiWebScriptII;
    dwsClasses: Tdws2Unit;
    procedure dws2UnitClassesTListMethodsCreateEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsDestroyEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsAddEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsGetEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsClearEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsGetCountEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsCreateEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsAddEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsCreateEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsSetCaptionEval(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsSetPositionEval(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsSetSizeEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsUpdateEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsSetParamsEval(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsVarParamTestEval(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsUseVarParamTestEval(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsNewInstanceEval(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTFieldMethodsAsStringEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTFieldMethodsAsIntegerEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTFieldsMethodsCreateEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTFieldsMethodsGetFieldEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTQueryMethodsCreateEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTQueryMethodsDestroyEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTQueryMethodsFirstEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTQueryMethodsNextEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTQueryMethodsEofEval(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure dws2UnitClassesTQueryMethodsFieldByNameEval(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dwsClassesFunctionsInputEval(Info: TProgramInfo);
    procedure dwsClassesClassesTListConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dwsClassesClassesTListMethodsDestroyEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dwsClassesClassesTListMethodsAddEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dwsClassesClassesTListMethodsGetEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dwsClassesClassesTListMethodsClearEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dwsClassesClassesTListMethodsGetCountEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dwsClassesClassesTStringsConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dwsClassesClassesTStringsMethodsAddEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dwsClassesClassesTWindowConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dwsClassesClassesTWindowConstructorsCreateEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dwsClassesClassesTWindowMethodsSetCaptionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dwsClassesClassesTWindowMethodsSetPositionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dwsClassesClassesTWindowMethodsSetSizeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dwsClassesClassesTWindowMethodsUpdateEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dwsClassesClassesTWindowMethodsSetParamsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dwsClassesClassesTWindowMethodsVarParamTestEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dwsClassesClassesTWindowMethodsUseVarParamTestEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dwsClassesClassesTWindowMethodsNewInstanceEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dwsClassesClassesTWindowMethodsfreeEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dwsClassesClassesTFieldMethodsAsStringEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dwsClassesClassesTFieldMethodsAsIntegerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dwsClassesClassesTFieldsConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dwsClassesClassesTFieldsConstructorsCreateEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dwsClassesClassesTFieldsMethodsGetFieldEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dwsClassesClassesTQueryConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dwsClassesClassesTQueryMethodsDestroyEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dwsClassesClassesTQueryMethodsFirstEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dwsClassesClassesTQueryMethodsNextEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dwsClassesClassesTQueryMethodsEofEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dwsClassesClassesTQueryMethodsFieldByNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dwsClassesClassesTpippoConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dwsClassesClassesTpippoMethodsReadUnoEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dwsClassesClassesTpippoMethodsReadDueEval(Info: TProgramInfo;
      ExtObject: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmClasses: TdmClasses;
  pippo: TPippo;

implementation

{$R *.dfm}

uses Db, DbTables, Dialogs;

procedure TdmClasses.dws2UnitClassesTListMethodsCreateEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TList.Create;
end;

procedure TdmClasses.dws2UnitClassesTListMethodsDestroyEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure TdmClasses.dws2UnitClassesTListMethodsAddEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  Info['Result'] := TList(ExtObject).Add(Pointer(Integer(Info['Obj'])));
end;

procedure TdmClasses.dws2UnitClassesTListMethodsGetEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  Info['Result'] := Integer(TList(ExtObject).Items[Info['Index']]);
end;

procedure TdmClasses.dws2UnitClassesTListMethodsClearEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  TList(ExtObject).Clear;
end;

procedure TdmClasses.dws2UnitClassesTListMethodsGetCountEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  Info['Result'] := TList(ExtObject).Count;
end;

procedure TdmClasses.dws2UnitClassesTStringsMethodsCreateEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TStringList.Create;
end;

procedure TdmClasses.dws2UnitClassesTStringsMethodsAddEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  TStrings(ExtObject).Add(Info['s']);
end;

procedure TdmClasses.dws2UnitClassesTWindowMethodsCreateEval(
  Info: TProgramInfo; var ExtObject: TObject);
var
  frm: TForm;
begin
  frm := TForm.Create(Self);
  ExtObject := frm;

  // Use default
  Info['Width'] := frm.Width;
  Info['Height'] := frm.Height;

  // Calls method SetPosition
  Info.Vars['Self'].Method['SetPosition'].Call([Info['Left'], Info['Top']]);

  // Another way to call a method
  Info.Func['SetCaption'].Call([Info['Caption']]);

  frm.Show;
end;

procedure TdmClasses.dws2UnitClassesTWindowMethodsSetCaptionEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  TForm(ExtObject).Caption := Info['s'];
end;

procedure TdmClasses.dws2UnitClassesTWindowMethodsSetPositionEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  Info.Vars['Self'].Member['Left'].Value := Info['Left'];
  Info.Vars['Self'].Member['Top'].Value := Info['Top'];
  Info.Func['Update'].Call;
end;

procedure TdmClasses.dws2UnitClassesTWindowMethodsSetSizeEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  Info.Vars['Self'].Member['Height'].Value := Info['Height'];
  Info.Vars['Self'].Member['Width'].Value := Info['Width'];
  Info.Func['Update'].Call;
end;

procedure TdmClasses.dws2UnitClassesTWindowMethodsUpdateEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  TForm(ExtObject).Left := Info['Left'];
  TForm(ExtObject).Top := Info['Top'];
  TForm(ExtObject).Width := Info['Width'];
  TForm(ExtObject).Height := Info['Height'];
  TForm(ExtObject).caption := Info['Caption'];
end;

procedure TdmClasses.dws2UnitClassesTWindowMethodsSetParamsEval(
  Info: TProgramInfo; var ExtObject: TObject);
var
  params: IInfo;
begin
  Info['Left'] := Info.Vars['params'].Member['Left'].Value;
  Info['Top'] := Info.Vars['params'].Member['Top'].Value;
  Info['Width'] := Info.Vars['params'].Member['Width'].Value;
  Info['Height'] := Info.Vars['params'].Member['Height'].Value;
  Info['Caption'] := Info.Vars['params'].Member['Caption'].Value;

  // The same thing but optimized
  params := Info.Vars['params'];
  Info['Left'] := params.Member['Left'].Value;
  Info['Top'] := params.Member['Top'].Value;
  Info['Width'] := params.Member['Width'].Value;
  Info['Height'] := params.Member['Height'].Value;
  Info['Caption'] := params.Member['Caption'].Value;

  Info.Func['Update'].Call;
end;

procedure TdmClasses.dws2UnitClassesTWindowMethodsVarParamTestEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  // Assign value to the var parameters
  Info['a'] := 12;
  Info['b'] := 21;
end;

procedure TdmClasses.dws2UnitClassesTWindowMethodsUseVarParamTestEval(
  Info: TProgramInfo; var ExtObject: TObject);
var
  meth: IInfo;
  s: string;
begin
  // Get the function
  meth := Info.Func['VarParamTest'];
  // Call the function
  meth.Call;
  // Display the output value of the var parameters
  s := Format('Var params: a = %s, b = %s', [meth.Parameter['a'].Value, meth.Parameter['b'].Value]);
  Info.Func['SetCaption'].Call([s]);

  // Another way to call a function with parameters
  // This is the prefered way if the method has arguments with complex types
  meth := Info.Func['SetSize'];
  meth.Parameter['Width'].Value := 300;
  meth.Parameter['Height'].Value := 50;
  meth.Call;
end;

procedure TdmClasses.dws2UnitClassesTWindowMethodsNewInstanceEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  Info['Result'] := Info.Vars['TWindow'].Method['Create'].Call([50, 50, 'Hello']).Value;
end;

procedure TdmClasses.dws2UnitClassesTFieldMethodsAsStringEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  Info['Result'] := TField(ExtObject).AsString;
end;

procedure TdmClasses.dws2UnitClassesTFieldMethodsAsIntegerEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  Info['Result'] := TField(ExtObject).AsInteger;
end;

procedure TdmClasses.dws2UnitClassesTFieldsMethodsCreateEval(
  Info: TProgramInfo; var ExtObject: TObject);
var
  x: Integer;
  flds: TFields;
begin
  flds := (ExtObject as TFields);
  for x := 0 to flds.Count - 1 do
    flds[x].Tag := Info.Vars['TField'].GetConstructor('Create', flds[x]).Call.Value;
end;

procedure TdmClasses.dws2UnitClassesTFieldsMethodsGetFieldEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TFields).FieldByName(Info['FieldName']).Tag;
end;

procedure TdmClasses.dws2UnitClassesTQueryMethodsCreateEval(
  Info: TProgramInfo; var ExtObject: TObject);
var
  q: TQuery;
begin
  q := TQuery.Create(Application);
  ExtObject := q;
  try
    q.DatabaseName := Info['db'];
    q.SQL.Text := Info['query'];
    q.Prepare;
    q.Open;

    Info['FFields'] := Info.Vars['TFields'].GetConstructor('Create', q.Fields).Call.Value;
  except
    q.Free;
    raise;
  end;
end;

procedure TdmClasses.dws2UnitClassesTQueryMethodsDestroyEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject.Free;
  ExtObject := nil;
end;

procedure TdmClasses.dws2UnitClassesTQueryMethodsFirstEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  TQuery(ExtObject).First;
end;

procedure TdmClasses.dws2UnitClassesTQueryMethodsNextEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  TQuery(ExtObject).Next;
end;

procedure TdmClasses.dws2UnitClassesTQueryMethodsEofEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  Info['Result'] := TQuery(ExtObject).Eof;
end;

procedure TdmClasses.dws2UnitClassesTQueryMethodsFieldByNameEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  Info['Result'] :=
    Info.Vars['FFields'].Method['GetField'].Call([Info['FieldName']]).Value;
end;

procedure TdmClasses.dwsClassesFunctionsInputEval(Info: TProgramInfo);
begin
  Info['Result'] := InputBox(Info['Title'], Info['Prompt'], '');
end;

{
procedure TdmClasses.dwsClassesClassesTWindowCleanUp(Obj: TScriptObj;
  ExternalObject: TObject);
begin
  ShowMessage('TWindow.OnCleanUp');
end;
}
{
procedure TdmClasses.dwsClassesClassesTWindowMethodsfreeEval(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  extObject.free;
end;
}

procedure TdmClasses.dwsClassesClassesTListConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TList.Create;
end;

procedure TdmClasses.dwsClassesClassesTListMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure TdmClasses.dwsClassesClassesTListMethodsAddEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TList(ExtObject).Add(Pointer(Integer(Info['Obj'])));
end;

procedure TdmClasses.dwsClassesClassesTListMethodsGetEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := Integer(TList(ExtObject).Items[Info['Index']]);
end;

procedure TdmClasses.dwsClassesClassesTListMethodsClearEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TList(ExtObject).Clear;
end;

procedure TdmClasses.dwsClassesClassesTListMethodsGetCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TList(ExtObject).Count;
end;

procedure TdmClasses.dwsClassesClassesTStringsConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TStringList.Create;
end;

procedure TdmClasses.dwsClassesClassesTStringsMethodsAddEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TStrings(ExtObject).Add(Info['s']);
end;

procedure TdmClasses.dwsClassesClassesTWindowConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
//  ExtObject := TFTest.Create(nil);
  ExtObject := TForm.Create(nil);
end;

procedure TdmClasses.dwsClassesClassesTWindowConstructorsCreateEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  frm: TForm;
begin
  frm := TForm(ExtObject);

  // Use default
  Info['Width'] := frm.Width;
  Info['Height'] := frm.Height;

  // Calls method SetPosition
  Info.Vars['Self'].Method['SetPosition'].Call([Info['Left'], Info['Top']]);

  // Another way to call a method
  Info.Func['SetCaption'].Call([Info['Caption']]);

  frm.Show;
end;

procedure TdmClasses.dwsClassesClassesTWindowMethodsSetCaptionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TForm(ExtObject).Caption := Info['s'];
end;

procedure TdmClasses.dwsClassesClassesTWindowMethodsSetPositionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Vars['Self'].Member['Left'].Value := Info['Left'];
  Info.Vars['Self'].Member['Top'].Value := Info['Top'];
  Info.Func['Update'].Call;
end;

procedure TdmClasses.dwsClassesClassesTWindowMethodsSetSizeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Vars['Self'].Member['Height'].Value := Info['Height'];
  Info.Vars['Self'].Member['Width'].Value := Info['Width'];
  Info.Func['Update'].Call;
end;

procedure TdmClasses.dwsClassesClassesTWindowMethodsUpdateEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
//  TFTest(ExtObject).Left := Info['Left'];
//  TFTest(ExtObject).Top := Info['Top'];
//  TFTest(ExtObject).Width := Info['Width'];
//  TFTest(ExtObject).Height := Info['Height'];
  TForm(ExtObject).Left := Info['Left'];
  TForm(ExtObject).Top := Info['Top'];
  TForm(ExtObject).Width := Info['Width'];
  TForm(ExtObject).Height := Info['Height'];
end;

procedure TdmClasses.dwsClassesClassesTWindowMethodsSetParamsEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  params: IInfo;
begin
  Info['Left'] := Info.Vars['params'].Member['Left'].Value;
  Info['Top'] := Info.Vars['params'].Member['Top'].Value;
  Info['Width'] := Info.Vars['params'].Member['Width'].Value;
  Info['Height'] := Info.Vars['params'].Member['Height'].Value;
  Info['Caption'] := Info.Vars['params'].Member['Caption'].Value;

  // The same thing but optimized
  params := Info.Vars['params'];
  Info['Left'] := params.Member['Left'].Value;
  Info['Top'] := params.Member['Top'].Value;
  Info['Width'] := params.Member['Width'].Value;
  Info['Height'] := params.Member['Height'].Value;
  Info['Caption'] := params.Member['Caption'].Value;

  Info.Func['Update'].Call;
end;

procedure TdmClasses.dwsClassesClassesTWindowMethodsVarParamTestEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  // Assign value to the var parameters
  Info['a'] := 12;
  Info['b'] := 21;
end;

procedure TdmClasses.dwsClassesClassesTWindowMethodsUseVarParamTestEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  meth: IInfo;
  s: string;
begin
  // Get the function
  meth := Info.Func['VarParamTest'];
  // Call the function
  meth.Call;
  // Display the output value of the var parameters
  s := Format('Var params: a = %s, b = %s', [meth.Parameter['a'].Value, meth.Parameter['b'].Value]);
  Info.Func['SetCaption'].Call([s]);

  // Another way to call a function with parameters
  // This is the prefered way if the method has arguments with complex types
  meth := Info.Func['SetSize'];
  meth.Parameter['Width'].Value := 300;
  meth.Parameter['Height'].Value := 50;
  meth.Call;
end;

procedure TdmClasses.dwsClassesClassesTWindowMethodsNewInstanceEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := Info.Vars['TWindow'].Method['Create'].Call([50, 50, 'Hello']).Value;
end;

procedure TdmClasses.dwsClassesClassesTWindowMethodsfreeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  extObject.free;
end;

procedure TdmClasses.dwsClassesClassesTFieldMethodsAsStringEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TField(ExtObject).AsString;
end;

procedure TdmClasses.dwsClassesClassesTFieldMethodsAsIntegerEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TField(ExtObject).AsInteger;
end;

procedure TdmClasses.dwsClassesClassesTFieldsConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  query: TQuery;
begin
  query := TQuery(Info.Vars['Parent'].ScriptObj.ExternalObject);
  ExtObject := query.FieldByName(Info['FieldName']);
end;

procedure TdmClasses.dwsClassesClassesTFieldsConstructorsCreateEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  x: Integer;
  flds: TFields;
begin
  flds := (ExtObject as TFields);
  for x := 0 to flds.Count - 1 do
    flds[x].Tag := Info.Vars['TField'].GetConstructor('Create', flds[x]).Call.Value;
end;

procedure TdmClasses.dwsClassesClassesTFieldsMethodsGetFieldEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TFields).FieldByName(Info['FieldName']).Tag;
end;

procedure TdmClasses.dwsClassesClassesTQueryConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TQuery.Create(nil);
end;

procedure TdmClasses.dwsClassesClassesTQueryMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure TdmClasses.dwsClassesClassesTQueryMethodsFirstEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TQuery(ExtObject).First;
end;

procedure TdmClasses.dwsClassesClassesTQueryMethodsNextEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TQuery(ExtObject).Next;
end;

procedure TdmClasses.dwsClassesClassesTQueryMethodsEofEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TQuery(ExtObject).Eof;
end;

procedure TdmClasses.dwsClassesClassesTQueryMethodsFieldByNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    Info.Vars['FFields'].Method['GetField'].Call([Info['FieldName']]).Value;
end;

procedure TdmClasses.dwsClassesClassesTpippoConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := pippo;
end;

procedure TdmClasses.dwsClassesClassesTpippoMethodsReadUnoEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TPippo(ExtObject).Uno;
end;

procedure TdmClasses.dwsClassesClassesTpippoMethodsReadDueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TPippo(ExtObject).Due;
end;

end.
