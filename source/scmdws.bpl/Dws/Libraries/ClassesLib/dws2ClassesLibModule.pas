unit dws2ClassesLibModule;

interface

uses
  Windows, Messages, SysUtils, Graphics, Controls, Forms, Dialogs,
  dws2Comp, dws2Exprs, Classes;

type
  Tdws2ClassesLib = class(TDataModule)
    dws2Unit: Tdws2Unit;
    procedure dws2UnitClassesTListMethodsAddEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsCountEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsDeleteEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsIndexOfEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsRemoveEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsDestroyEval(Info: TProgramInfo;
      ExtObject: TObject);                             
    procedure dws2UnitClassesTHashtableMethodsSizeEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTHashtableMethodsCapacityEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTIntegerHashtableMethodsPutEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTIntegerHashtableMethodsGetEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTIntegerHashtableMethodsHasKeyEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTIntegerHashtableMethodsRemoveKeyEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringHashtableMethodsPutEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringHashtableMethodsGetEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringHashtableMethodsHasKeyEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringHashtableMethodsRemoveKeyEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStackMethodsPushEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStackMethodsPopEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStackMethodsPeekEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStackMethodsCountEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTQueueMethodsPushEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTQueueMethodsPopEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTQueueMethodsPeekEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTQueueMethodsCountEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTQueueMethodsDestroyEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStackMethodsDestroyEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringHashtableMethodsDestroyEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTIntegerHashtableMethodsDestroyEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsClearEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsInsertEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsDestroyEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsAddEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsGetEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsIndexOfEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsIndexOfNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsInsertEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsGetValuesEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsGetNamesEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsClearEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsGetTextEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsSetTextEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsGetCountEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsGetCommaTextEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsSetCommaTextEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsLoadFromFileEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsSaveToFileEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsDeleteEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsExchangeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsMoveEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsAddStringsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsGetObjectsEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsAddObjectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsInsertObjectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsIndexOfObjectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringListMethodsSortEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringListMethodsFindEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringListMethodsGetDuplicatesEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringListMethodsSetDuplicatesEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringListMethodsGetSortedEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringListMethodsSetSortedEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsGetStringsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsSetStringsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsGetItemsEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsSetItemsEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsSetObjectsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsSetValuesEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTListConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTIntegerHashtableConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTStringHashtableConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTQueueConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTStackConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTStringsConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTHashtableMethodsClearEval(Info: TProgramInfo;
      ExtObject: TObject);
  private
    FScript: TDelphiWebScriptII;
    procedure SetScript(const Value: TDelphiWebScriptII);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property Script: TDelphiWebScriptII read FScript write SetScript;
  end;

procedure Register;

var
  dws2ClassesLib: Tdws2ClassesLib;

implementation

uses
  dws2Hashtables, dws2Symbols, Contnrs, dws2Classes;

{$R *.DFM}

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2ClassesLib]);
end;

{ Tdws2Lib }

procedure Tdws2ClassesLib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Script) then
    SetScript(nil)
end;

procedure Tdws2ClassesLib.SetScript(const Value: TDelphiWebScriptII);
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

procedure Tdws2ClassesLib.dws2UnitClassesTListConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TInterfaceList.Create;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTListMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTListMethodsAddEval(Info: TProgramInfo;
  ExtObject: TObject);
begin
  Info.Result := TInterfaceList(ExtObject).Add(Info['Obj']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTListMethodsClearEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TInterfaceList(ExtObject).Clear;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTListMethodsCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TInterfaceList(ExtObject).Count;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTListMethodsDeleteEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TInterfaceList(ExtObject).Delete(Info['Index']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTListMethodsGetItemsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TInterfaceList(ExtObject)[Info['Index']];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTListMethodsIndexOfEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TInterfaceList(ExtObject).IndexOf(Info['Obj']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTListMethodsInsertEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TInterfaceList(ExtObject).Insert(Info['Index'], Info['Obj']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTListMethodsRemoveEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TInterfaceList(ExtObject).Remove(Info['Obj']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTListMethodsSetItemsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TInterfaceList(ExtObject)[Info['Index']] := Info['Value'];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  if not Assigned(ExtObject) then
    ExtObject := Tdws2StringList.Create;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsAddEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2Strings(ExtObject).Add(Info['Str']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsAddObjectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2Strings(ExtObject).AddObject(Info['S'], Info['AObject']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsAddStringsEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  IObj: IScriptObj;
  StringsObj: Tdws2StringList;
begin
  IObj := IScriptObj(IUnknown(Info['Strings']));
  if IObj = nil then
    StringsObj := nil
  else
    StringsObj := Tdws2StringList(IObj.ExternalObject);
  Tdws2Strings(ExtObject).AddStrings(StringsObj);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsClearEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2Strings(ExtObject).Clear;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsDeleteEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2Strings(ExtObject).Delete(Info['Index']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsExchangeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2Strings(ExtObject).Exchange(Info['Index1'], Info['Index2']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsGetEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2Strings(ExtObject)[Info['Index']];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsGetCommaTextEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2Strings(ExtObject).CommaText;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsGetCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2Strings(ExtObject).Count;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsGetNamesEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2Strings(ExtObject).Names[Info['s']];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsGetObjectsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := IUnknown(Pointer(Tdws2Strings(ExtObject).Objects[Info['Index']]));
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsGetStringsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2Strings(ExtObject)[Info['Index']];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsGetTextEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2Strings(ExtObject).Text;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsGetValuesEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2Strings(ExtObject).Values[Info['Str']];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsInsertObjectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2Strings(ExtObject).InsertObject(Info['Index'], Info['S'], Info['AObject']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsIndexOfEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2Strings(ExtObject).IndexOf(Info['Str']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsIndexOfNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2Strings(ExtObject).IndexOfName(Info['Str']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsIndexOfObjectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2Strings(ExtObject).IndexOfObject(Info['AObject']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsInsertEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2Strings(ExtObject).Insert(Info['Index'], Info['Str']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsLoadFromFileEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2Strings(ExtObject).LoadFromFile(Info['FileName']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsMoveEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2Strings(ExtObject).Move(Info['CurIndex'], Info['NewIndex']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsSaveToFileEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2Strings(ExtObject).SaveToFile(Info['FileName']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsSetCommaTextEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2Strings(ExtObject).CommaText := Info['Value'];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsSetObjectsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2Strings(ExtObject).Objects[Info['Index']] := Info['Value'];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsSetStringsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2Strings(ExtObject)[Info['Index']] := Info['Value'];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsSetTextEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2Strings(ExtObject).Text := Info['Value'];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringsMethodsSetValuesEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2Strings(ExtObject).Values[Info['Str']] := Info['Value'];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringListMethodsSortEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2StringList(ExtObject).Sort;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringListMethodsFindEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  Index: Integer;
begin
  Info.Result := Tdws2StringList(ExtObject).Find(Info['S'], Index);
  Info['Index'] := Index;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringListMethodsGetDuplicatesEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2StringList(ExtObject).Duplicates;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringListMethodsSetDuplicatesEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2StringList(ExtObject).Duplicates := Info['Value'];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringListMethodsGetSortedEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := Tdws2StringList(ExtObject).Sorted;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringListMethodsSetSortedEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Tdws2StringList(ExtObject).Sorted := Info['Value'];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTHashtableMethodsSizeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := THashTable(ExtObject).Size;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTHashtableMethodsCapacityEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := THashTable(ExtObject).Capacity;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTHashtableMethodsClearEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  THashTable(ExtObject).Clear;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTIntegerHashtableConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TIntegerHashtable.Create;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringHashtableMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTIntegerHashtableMethodsPutEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIntegerHashTable(ExtObject).Put(Info['Key'], Info['Value']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTIntegerHashtableMethodsGetEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TIntegerHashTable(ExtObject).Get(Info['Key']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTIntegerHashtableMethodsHasKeyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TIntegerHashTable(ExtObject).HasKey(Info['Key']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTIntegerHashtableMethodsRemoveKeyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TIntegerHashTable(ExtObject).RemoveKey(Info['Key']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringHashtableConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TStringHashtable.Create;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTIntegerHashtableMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringHashtableMethodsPutEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TStringHashtable(ExtObject).Put(Info['Key'], Info['Value']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringHashtableMethodsGetEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TStringHashtable(ExtObject).Get(Info['Key']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringHashtableMethodsHasKeyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TStringHashtable(ExtObject).HasKey(Info['Key']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStringHashtableMethodsRemoveKeyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TStringHashtable(ExtObject).RemoveKey(Info['Key']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStackConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TInterfaceList.Create;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStackMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStackMethodsPushEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TInterfaceList(ExtObject).Add(Info['Obj']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStackMethodsPopEval(Info: TProgramInfo;
  ExtObject: TObject);
var
  intfList: TInterfaceList;
begin
  intfList := TInterfaceList(ExtObject);
  Info.Result := intfList[intfList.Count - 1];
  intfList.Delete(intfList.Count - 1);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStackMethodsPeekEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  intfList: TInterfaceList;
begin
  intfList := TInterfaceList(ExtObject);
  Info.Result := intfList[intfList.Count - 1];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTStackMethodsCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TInterfaceList(ExtObject).Count;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTQueueConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TInterfaceList.Create;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTQueueMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure Tdws2ClassesLib.dws2UnitClassesTQueueMethodsPushEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TInterfaceList(ExtObject).Add(Info['Obj']);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTQueueMethodsPopEval(Info: TProgramInfo;
  ExtObject: TObject);
var
  intfList: TInterfaceList;
begin
  intfList := TInterfaceList(ExtObject);
  Info.Result := intfList[0];
  intfList.Delete(0);
end;

procedure Tdws2ClassesLib.dws2UnitClassesTQueueMethodsPeekEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TInterfaceList(ExtObject)[0];
end;

procedure Tdws2ClassesLib.dws2UnitClassesTQueueMethodsCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TInterfaceList(ExtObject).Count;
end;

end.
