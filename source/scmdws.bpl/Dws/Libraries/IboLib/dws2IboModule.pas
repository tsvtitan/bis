{**********************************************************************}
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at                                          }
{                                                                      }
{    http://www.mozilla.org/MPL/                                       }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{    The Original Code is DelphiWebScriptII source code, released      }
{    January 1, 2001                                                   }
{                                                                      }
{    http://www.dwscript.com                                           }
{                                                                      }
{    The Initial Developers of the Original Code are Matthias          }
{    Ackermann and hannes hernler.                                     }
{    Portions created by Matthias Ackermann are Copyright (C) 2001     }
{    Matthias Ackermann, Switzerland. All Rights Reserved.             }
{    Portions created by hannes hernler are Copyright (C) 2001         }
{    hannes hernler, Austria. All Rights Reserved.                     }
{                                                                      }
{    Contributor(s): ______________________________________.           }
{                                                                      }
{**********************************************************************}

unit dws2IboModule;

interface

uses
  Windows,  SysUtils, Controls, Classes, Forms,
  dws2Comp, dws2Exprs, IB_Session, IB_Components;

type
  TdwsIBOStatementObj = class(TObject)
    IBOStatement: TIB_Statement;
    LUCol, ParamCol: TIB_Column;
    KeyFieldName, KeyFieldValue, LUFieldName: string;
    procedure AddLUFieldRow(sFieldValue: string);
  public
   destructor destroy; override;
  end;

  TdwsIboDataBaseObj = class(TObject)
    IBOConnection: TIB_Connection;
  public
   destructor destroy; override;
  end;

  TdwsDBGroupObj = class(TObject)
    IBODataset: TIB_Dataset;
    GroupCol: TIB_Column;
    GroupFieldName, GroupFieldValue: string;
    iGroupCnt: Integer;
    boNewGrp: boolean;
    GroupValues: TStringList;
    procedure AddFieldValue(IboCol: TIB_Column);
    procedure ResetGroup;
    procedure AddGroupRow;
    function GetGroupSum(sFieldName: string): extended;
  end;

  TdwsMemoLookUpObj = class(TObject)
    IBODataset: TIB_Dataset;
    MLUCol: TIB_Column;
    MLUFieldName: string;
    ValueList : TStringList;
  public
   constructor create;
   destructor destroy; override;
  end;

  Tdws2IboLib = class(TDataModule)
    customIBOUnit: Tdws2Unit;
    procedure AFreeExtObject(Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTStatementMethodsGetSQLEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTStatementMethodsSetSQLEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTStatementMethodsExecuteEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTStatementMethodsFieldByNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTStatementMethodsFieldEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTStatementMethodsParamByNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTStatementMethodsSetParamEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatasetMethodsCreateFromDBEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatasetMethodsOpenEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatasetMethodsFirstEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatasetMethodsNextEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatasetMethodsEditEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatasetMethodsInsertEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatasetMethodsPostEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatasetMethodsDeleteEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatasetMethodsCloseEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTQueryMethodsPriorEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTFieldMethodsSetValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTFieldMethodsGetValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTFieldMethodsSetValueStrEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTFieldMethodsGetValueStrEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatasetMethodsEofEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTStatementMethodsFieldIsNullEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatasetMethodsCancelEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTQueryMethodsGetFilterEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTQueryMethodsSetFilterEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTQueryMethodsGetFilteredEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTQueryMethodsSetFilteredEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTQueryMethodsGetSortOrderEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTQueryMethodsSetSortOrderEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDataSetGrpMethodsAddSumFieldEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDataSetGrpMethodsGroupEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDataSetGrpMethodsCountEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDataSetGrpMethodsAddGroupRowEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDataSetGrpMethodsRestartGroupEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDataSetGrpMethodsResetGroupEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDataSetGrpMethodsSumOfFieldEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatabaseMethodsconnectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatabaseMethodsdisconnectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatabaseMethodssetdialectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatabaseMethodsgetdialectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatabaseMethodssetcharsetEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatabaseMethodsgetcharsetEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTQueryMethodsLookUpEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTQueryMethodsSetLookUpFieldsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTLUFieldMethodsGetValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTLUFieldMethodsGetValueStrEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTLUFieldMethodsSetValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTLUFieldMethodsSetValueStrEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDBFieldMethodsSetIntegerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDBFieldMethodsSetFloatEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDBFieldMethodsSetDateTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDBFieldMethodsGetIntegerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDBFieldMethodsGetFloatEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDBFieldMethodsGetDateTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatabaseConstructorscreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBOUnitClassesTStatementConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBOUnitClassesTStatementConstructorsCreateFromDBAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBOUnitClassesTDatasetConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBOUnitClassesTQueryConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBOUnitClassesTDataSetGrpConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBOUnitClassesTMLUFieldMethodsGetValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTMLUFieldMethodsSetNameValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTStatementMethodsOpenEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customIBOUnitClassesTDatasetConstructorsCreateFromDBAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBOUnitClassesTMLUFieldConstructorscreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customIBOUnitClassesTQueryConstructorsCreateFromDBAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
  private
    FScript: TDelphiWebScriptII;
    FIBOConnection: TIB_Connection;
    FIBOTransaction: TIB_Transaction;
//    FConstantSrc: Tdws2Constants;
    procedure SetScript(const Value: TDelphiWebScriptII);
    procedure SetIBOConnection(const Value: TIB_Connection);
    procedure SetIBOTransaction(const Value: TIB_Transaction);
    procedure LUFieldSetValue(FieldValue: variant; ExtObject: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property Script: TDelphiWebScriptII read FScript write SetScript;
    property IBOConnection: TIB_Connection read FIBOConnection write SetIBOConnection;
    property IBOTransaction: TIB_Transaction read FIBOTransaction write SetIBOTransaction;
//    property ConstantSrc: Tdws2Constants read FConstantSrc write FConstantSrc;
  end;

procedure Register;

var
  dws2IboLib: Tdws2IboLib;

implementation

{$R *.DFM}

uses
  dws2Symbols;

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2IboLib]);
end;

function hhURLencode(sURL : string): string;
Var
   i, iMax:Integer;
Begin
   result :='';
   iMax:=Length(sURL);
   for i:=1 to iMax do
      if sURL[i]<#64 then
        result := result+'%'+IntToHex(Ord(sURL[i]),2)
      else
        result := result +sURL[i];
end;

function hhURLdecode(sURL : string): string;
var
   sH : string;
   ch : Char;
   i : Integer;
begin
   sURL := stringreplace(sUrl,'+',#32,[rfReplaceAll]);
   i := Pos('%',sURL);
   While i>0 do
   Begin
      sH :='$'+Copy(sURL,i+1,2);
      try
        Ch :=Char(StrToInt(sH));
        result := result + Copy(sURL,1,i-1) +Ch;
        delete(sURL,1,i+2);
      except
        result := result + Copy(sURL,1,i-1)
      end;
      i :=Pos('%',sURL);
   End;
   result := result + sURL;
end;


// ****************************************************************************
// ********************* internal library classes  *****************************
// ****************************************************************************

destructor TdwsIBOStatementObj.destroy;
begin
  if assigned(IBOStatement) then
    IBOStatement.Unprepare;
  inherited destroy;
end;

procedure TdwsIBOStatementObj.AddLUFieldRow(sFieldValue: string);
begin
  TIB_Query(IBOStatement).Insert;
  IBOStatement.FieldByName(KeyFieldName).asstring := KeyFieldValue;
  LUCol.AsString := sFieldValue;
  TIB_Query(IBOStatement).Post;
end;

destructor TdwsIboDataBaseObj.destroy;
begin
  if assigned(IBOConnection) then
    IBOConnection.Close;
  inherited destroy;
end;
constructor TdwsMemoLookUpObj.create;
begin
  inherited create;
  ValueList := TStringList.create;
end;

destructor TdwsMemoLookUpObj.destroy;
begin
  if assigned(ValueList) then
    ValueList.free;
  inherited destroy;
end;



// ****************************************************************************
// ********************* DBGroupObj object ***********************************
// ****************************************************************************
procedure TdwsDBGroupObj.AddFieldValue(IboCol: TIB_Column);
var
  rSum: extended;
  sH: string;
begin
  rSum := IboCol.AsExtended;
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
      + IBODataset.FieldByName(sH).asextended;
    GroupValues.Values[sH] := Format('%g', [rSum]);
  end;
end;



// ****************************************************************************
// ********************* IBO Library object ***********************************
// ****************************************************************************

procedure Tdws2IboLib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FScript) then
    SetScript(nil);
  if (Operation = opRemove) and (AComponent = FIBOConnection) then
    SetIBOConnection (nil);
  if (Operation = opRemove) and (AComponent = FIBOTransaction) then
    SetIBOTransaction (nil);
end;

procedure Tdws2IboLib.SetScript(const Value: TDelphiWebScriptII);
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

procedure Tdws2IboLib.SetIBOConnection(const Value: TIB_Connection);
begin
//  if Assigned(FIBOConnection) then
//    FScript.RemoveFreeNotification(Self);
  if Assigned(Value) then
    Value.FreeNotification(Self);
  FIBOConnection := Value;
end;

procedure Tdws2IboLib.SetIBOTransaction(const Value: TIB_Transaction);
begin
//  if Assigned(FIBOTransaction) then
//    FScript.RemoveFreeNotification(Self);
  if Assigned(Value) then
    Value.FreeNotification(Self);
  FIBOTransaction := Value;
end;

procedure Tdws2IboLib.LUFieldSetValue(FieldValue: variant; ExtObject: TObject);
var
  sFieldValue : string;
begin
  with TdwsIBOStatementObj(ExtObject)do
  begin
    if IBOStatement.FieldByName(KeyFieldName).AsString = KeyFieldValue then
    begin   // KeyFieldValue is active row
      LUCol.AsVariant := FieldValue;
    end
    else begin    // lookup row KeyFieldValue
      if TIB_Query(IBOStatement).Locate(KeyFieldName, KeyFieldValue, [lopCaseInsensitive]) then
        LUCol.AsVariant := FieldValue
      else begin
        sFieldValue := FieldValue;
        AddLUFieldRow(sFieldValue);
      end;
    end;
  end;
end;

// ****************************************************************************
// ********************* IBO Class Methods  ***********************************
// ****************************************************************************

procedure Tdws2IboLib.AFreeExtObject(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
  ExtObject := nil;
end;

procedure Tdws2IboLib.customIBOUnitClassesTStatementConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TdwsIBOStatementObj.Create;
  TdwsIBOStatementObj(ExtObject).IBOStatement := TIB_Statement.Create(self);
  TdwsIBOStatementObj(ExtObject).IBOStatement.IB_Connection := FIBOConnection;
  TdwsIBOStatementObj(ExtObject).IBOStatement.IB_Transaction := FIBOTransaction;
end;

procedure Tdws2IboLib.customIBOUnitClassesTStatementConstructorsCreateFromDBAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  ScriptObj: IScriptObj;
  DBObj: TdwsIboDataBaseObj;
begin
  ScriptObj := IScriptObj(IUnknown(Info['Database']));
  if ScriptObj = nil then
    DBObj := nil
  else
    DBObj := TdwsIboDataBaseObj(ScriptObj.ExternalObject);

  ExtObject := TdwsIBOStatementObj.Create;
  TdwsIBOStatementObj(ExtObject).IBOStatement := TIB_Statement.Create(self);
  TdwsIBOStatementObj(ExtObject).IBOStatement.IB_Connection := DBObj.IBOConnection;
  TdwsIBOStatementObj(ExtObject).IBOStatement.IB_Transaction := FIBOTransaction;
end;

procedure Tdws2IboLib.customIBOUnitClassesTStatementMethodsGetSQLEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TdwsIBOStatementObj(ExtObject).IBOStatement.SQL.Text;
end;

procedure Tdws2IboLib.customIBOUnitClassesTStatementMethodsSetSQLEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsIBOStatementObj(ExtObject).IBOStatement.SQL.Text := Info['sSQL'];
end;

procedure Tdws2IboLib.customIBOUnitClassesTStatementMethodsExecuteEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsIBOStatementObj(ExtObject).IBOStatement.Execute;
end;

procedure Tdws2IboLib.customIBOUnitClassesTStatementMethodsFieldByNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
      Info.Vars['TDBField'].GetConstructor('Create',
      TdwsIBOStatementObj(ExtObject).IBOStatement.FieldByName(Info['FieldName'])
      ).Call.Value;
end;

procedure Tdws2IboLib.customIBOUnitClassesTStatementMethodsFieldEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  MyStatement: TIB_Statement;
  IboCol: TIB_Column;
  sFieldName : string;
begin
  MyStatement := TdwsIBOStatementObj(ExtObject).IBOStatement;
  sFieldName := Info['FieldName'];
  IboCol := MyStatement.FindField(sFieldName);
  with MyStatement do
  if IboCol = nil then
    Info['Result'] := '!!dbfield('+sFieldName+')??'
  else begin
    if (MyStatement is TIB_Dataset) and (IboCol.IsNull or TIB_Dataset(MyStatement).eof
        or TIB_Dataset(MyStatement).bof) then
    begin
      if IboCol.IsNumeric then
      begin
         Info['Result'] := 0.0
      end
      else
        Info['Result'] := '';
    end
    else
      Info['Result'] := IboCol.AsVariant;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTStatementMethodsFieldIsNullEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    Info['Result'] :=  FieldByName(Info['FieldName']).isnull;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTStatementMethodsParamByNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
      Info.Vars['TDBField'].GetConstructor('Create',
      TdwsIBOStatementObj(ExtObject).IBOStatement.parambyname(Info['ParamName'])
      ).Call.Value;
end;

procedure Tdws2IboLib.customIBOUnitClassesTStatementMethodsSetParamEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsIBOStatementObj(ExtObject).IBOStatement do
  begin
    if not prepared then
      prepare;
    parambyname(Info['ParamName']).AsVariant := Info['Value'];
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatasetConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TdwsIBOStatementObj.Create;
  TdwsIBOStatementObj(ExtObject).IBOStatement := TIB_Cursor.Create(self);
  TdwsIBOStatementObj(ExtObject).IBOStatement.IB_Connection := FIBOConnection;
  TdwsIBOStatementObj(ExtObject).IBOStatement.IB_Transaction := FIBOTransaction;
end;


procedure Tdws2IboLib.customIBOUnitClassesTDatasetMethodsOpenEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Dataset(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    if active then
    begin
      // refresh;
    First;
    end
    else begin
      if not prepared then
        prepare;
      open;
    end;
   // First;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatasetMethodsFirstEval(
  Info: TProgramInfo; ExtObject: TObject);
begin                                                                                                      with TIB_Dataset(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    First;
    Info['Result'] :=  not eof;
  end;

end;

procedure Tdws2IboLib.customIBOUnitClassesTDatasetMethodsNextEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Dataset(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    next;
    Info['Result'] :=  not eof;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatasetMethodsEofEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Dataset(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    Info['Result'] :=  eof;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatasetMethodsEditEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Dataset(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    if not active then
      open;
    edit;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatasetMethodsInsertEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Dataset(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    if not active then
      open;
    insert;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatasetMethodsPostEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Dataset(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    if state in [dssEdit, dssInsert] then
    post;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatasetMethodsCancelEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Dataset(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    cancel;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatasetMethodsDeleteEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Dataset(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    delete;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatasetMethodsCloseEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Dataset(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    close;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTQueryMethodsPriorEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Query(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    prior;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTFieldMethodsSetValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIB_Column(ExtObject).AsVariant := Info['Value'];
end;

procedure Tdws2IboLib.customIBOUnitClassesTFieldMethodsGetValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIB_Column(ExtObject).AsVariant;
end;

procedure Tdws2IboLib.customIBOUnitClassesTFieldMethodsSetValueStrEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIB_Column(ExtObject).AsString := Info['Value'];
end;

procedure Tdws2IboLib.customIBOUnitClassesTFieldMethodsGetValueStrEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIB_Column(ExtObject).AsString;
end;


procedure Tdws2IboLib.customIBOUnitClassesTQueryMethodsGetFilterEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Query(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    Info['Result'] :=  Filter;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTQueryMethodsSetFilterEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Query(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    Filter := Info['FilterStr'];
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTQueryMethodsGetFilteredEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Query(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    Info['Result'] :=  Filtered;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTQueryMethodsSetFilteredEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Query(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    Filtered := Info['Filtered'];
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTQueryMethodsGetSortOrderEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Query(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    Info['Result'] :=  OrderingItemNo;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTQueryMethodsSetSortOrderEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TIB_Query(TdwsIBOStatementObj(ExtObject).IBOStatement) do
  begin
    OrderingItemNo := Info['SortOrder'];
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDataSetGrpConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  IBGroup: TdwsDBGroupObj;
  ScriptObj: IScriptObj;
  DBObj: TdwsIBOStatementObj;
begin
  ScriptObj := IScriptObj(IUnknown(Info['DataSet']));
  if ScriptObj = nil then
    DBObj := nil
  else
    DBObj := TdwsIBOStatementObj(ScriptObj.ExternalObject);
  IBGroup := TdwsDBGroupObj.Create;
  try
    IBGroup.IBODataset := TIB_Dataset(DBObj.IBOStatement);
    IBGroup.GroupFieldName := Info['GroupFieldName'];
    IBGroup.GroupCol := IBGroup.IBODataset.Fieldbyname(IBGroup.GroupFieldName);
    IBGroup.GroupFieldValue := IBGroup.GroupCol.AsString;
    IBGroup.GroupValues := TStringList.Create;
    ExtObject := IBGroup;
  except
    raise;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDataSetGrpMethodsAddSumFieldEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsDBGroupObj(ExtObject) do
  begin
    GroupValues.Add(Info['FieldName'] + '=0');
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDataSetGrpMethodsGroupEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  IBGroup: TdwsDBGroupObj;
  boOK : boolean;
begin
  IBGroup := TdwsDBGroupObj(ExtObject);
  if not (IBGroup.IBODataset.eof or IBGroup.IBODataset.bof) then
  begin
    boOK := IBGroup.GroupFieldValue = IBGroup.GroupCol.AsString;
    if boOK then
      inc(IBGroup.iGroupCnt);
    Info['result'] := not boOK;
  end
  else
    Info['result'] := true;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDataSetGrpMethodsCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['result'] := TdwsDBGroupObj(ExtObject).iGroupCnt;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDataSetGrpMethodsAddGroupRowEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsDBGroupObj(ExtObject) do
  begin
    AddGroupRow;
    if boNewGrp then
    begin
      GroupFieldValue := GroupCol.AsString;
      boNewGrp :=  false;
      iGroupCnt := 0;
    end
    else
      boNewGrp := not (GroupFieldValue=GroupCol.AsString)
  end;

end;

procedure Tdws2IboLib.customIBOUnitClassesTDataSetGrpMethodsRestartGroupEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsDBGroupObj(ExtObject) do
  begin
    // ResetGroup;
      GroupFieldValue := GroupCol.AsString;
      boNewGrp :=  false;
      iGroupCnt := 0;
  end;

end;

procedure Tdws2IboLib.customIBOUnitClassesTDataSetGrpMethodsResetGroupEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsDBGroupObj(ExtObject)  do
  begin
    ResetGroup;
      GroupFieldValue := GroupCol.AsString;
      boNewGrp :=  false;
      iGroupCnt := 0;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDataSetGrpMethodsSumOfFieldEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['result'] := TdwsDBGroupObj(ExtObject).GetGroupSum(Info['FieldName']);
end;

procedure Tdws2IboLib.customIBOUnitClassesTQueryConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TdwsIBOStatementObj.Create;
  TdwsIBOStatementObj(ExtObject).IBOStatement := TIB_Query.Create(self);
  TdwsIBOStatementObj(ExtObject).IBOStatement.IB_Connection := FIBOConnection;
  TdwsIBOStatementObj(ExtObject).IBOStatement.IB_Transaction := FIBOTransaction;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatabaseConstructorscreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  dbh: TdwsIboDataBaseObj;
begin
  dbh := TdwsIboDataBaseObj.Create;
  dbh.IBOConnection := TIB_Connection.Create(self);
  dbh.IBOConnection.DatabaseName := Info['Database'];
  dbh.IBOConnection.Username := Info['user'];
  dbh.IBOConnection.Password := Info['pwd'];
  dbh.IBOConnection.Protocol := cpTCP_IP;
  dbh.IBOConnection.Connect;
  ExtObject :=  dbh;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatabaseMethodsconnectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsIboDataBaseObj(ExtObject)  do
  begin
    IBOConnection.Connect;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatabaseMethodsdisconnectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsIboDataBaseObj(ExtObject)  do
  begin
    IBOConnection.Disconnect;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatabaseMethodssetdialectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsIboDataBaseObj(ExtObject).IBOConnection.SQLDialect  := Info['iDialect'];
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatabaseMethodsgetdialectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['result'] := TdwsIboDataBaseObj(ExtObject).IBOConnection.SQLDialect;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatabaseMethodssetcharsetEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsIboDataBaseObj(ExtObject).IBOConnection.CharSet  := Info['sCharSet'];
end;

procedure Tdws2IboLib.customIBOUnitClassesTDatabaseMethodsgetcharsetEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['result'] := TdwsIboDataBaseObj(ExtObject).IBOConnection.CharSet;
end;

procedure Tdws2IboLib.customIBOUnitClassesTQueryMethodsSetLookUpFieldsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsIBOStatementObj(ExtObject) do
  try
    if not IBOStatement.Prepared then
      IBOStatement.Prepare;
    KeyFieldName := Info['KeyFieldName'];
    LUFieldName := Info['LUFieldName'];
//    ParamCol := IBOStatement.ParamByName(KeyFieldName);
    LUCol := IBOStatement.FieldByName(LUFieldName);
  except
    raise;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTQueryMethodsLookUpEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  DBLookUp: TdwsIBOStatementObj;
begin
  DBLookUp := TdwsIBOStatementObj(ExtObject);
  DBlookUp.KeyFieldValue :=  Info['KeyFieldValue'];
  if Assigned(DBLookUp.LUCol) then
  with DBLookUp do
  begin
    if TIB_Query(IBOStatement).Locate(KeyFieldName, KeyFieldValue, [lopCaseInsensitive]) then
    begin    // datarow found by locate ->  read from/write to TDBField
      Info['Result'] :=
          Info.Vars['TDBField'].GetConstructor('Create',LUCol).Call.Value;
    end
    else begin  // datarow not found by locate -> read NULL / write = insert
      Info['Result'] :=
          Info.Vars['TLUField'].GetConstructor('Create',DBLookUp).Call.Value;
    end;
  end
  else
    Info['Result'] := 'no lookup field';
end;

procedure Tdws2IboLib.customIBOUnitClassesTLUFieldMethodsGetValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if TdwsIBOStatementObj(ExtObject).LUCol.IsNumeric then
    Info['Result'] := 0.0
  else
    Info['Result'] := '';
end;

procedure Tdws2IboLib.customIBOUnitClassesTLUFieldMethodsGetValueStrEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if TdwsIBOStatementObj(ExtObject).LUCol.IsNumeric then
    Info['Result'] := '0'
  else
    Info['Result'] := '';
end;


procedure Tdws2IboLib.customIBOUnitClassesTLUFieldMethodsSetValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  LUFieldSetValue(Info['Value'], ExtObject);
end;

procedure Tdws2IboLib.customIBOUnitClassesTLUFieldMethodsSetValueStrEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  vFieldValue : variant;
begin
  vFieldValue := Info['Value'];
  LUFieldSetValue(vFieldValue, ExtObject);
end;

procedure Tdws2IboLib.customIBOUnitClassesTDBFieldMethodsSetIntegerEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIB_Column(ExtObject).AsInteger := Info['Value'];
end;

procedure Tdws2IboLib.customIBOUnitClassesTDBFieldMethodsSetFloatEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIB_Column(ExtObject).AsExtended := Info['Value'];
end;

procedure Tdws2IboLib.customIBOUnitClassesTDBFieldMethodsSetDateTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIB_Column(ExtObject).AsDateTime := Info['Value'];
end;

procedure Tdws2IboLib.customIBOUnitClassesTDBFieldMethodsGetIntegerEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIB_Column(ExtObject).AsInteger;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDBFieldMethodsGetFloatEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIB_Column(ExtObject).AsExtended;
end;

procedure Tdws2IboLib.customIBOUnitClassesTDBFieldMethodsGetDateTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIB_Column(ExtObject).AsDateTime;
end;


procedure Tdws2IboLib.customIBOUnitClassesTMLUFieldMethodsGetValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsMemoLookUpObj(ExtObject)  do
  begin
    ValueList.Text := MLUCol.AsString;
    Info['Result'] := hhURLdecode(ValueList.Values[Info['Name']]);
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTMLUFieldMethodsSetNameValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsMemoLookUpObj(ExtObject)  do
  begin
    ValueList.Text := MLUCol.AsString;
    ValueList.Values[Info['Name']] := hhURLencode(Info['Value']);
    MLUCol.AsString := ValueList.Text;
  end;
end;






procedure Tdws2IboLib.customIBOUnitClassesTDatasetConstructorsCreateFromDBAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  ScriptObj: IScriptObj;
  DBObj: TdwsIboDataBaseObj;
begin
  ScriptObj := IScriptObj(IUnknown(Info['Database']));
  if ScriptObj = nil then
    DBObj := nil
  else
    DBObj := TdwsIboDataBaseObj(ScriptObj.ExternalObject);

  ExtObject := TdwsIBOStatementObj.Create;
  TdwsIBOStatementObj(ExtObject).IBOStatement := TIB_Cursor.Create(self);
  TdwsIBOStatementObj(ExtObject).IBOStatement.IB_Connection := DBObj.IBOConnection;
  TdwsIBOStatementObj(ExtObject).IBOStatement.IB_Transaction := FIBOTransaction;
end;

procedure Tdws2IboLib.customIBOUnitClassesTMLUFieldConstructorscreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  MLUobj: TdwsMemoLookUpObj;
  ScriptObj: IScriptObj;
  DBObj: TdwsIBOStatementObj;
begin
  ScriptObj := IScriptObj(IUnknown(Info['DataSet']));

  if ScriptObj = nil then
    DBObj := nil
  else
    DBObj := TdwsIBOStatementObj(ScriptObj.ExternalObject);
  MLUobj := TdwsMemoLookUpObj.Create;
  try
    MLUobj.IBODataset := TIB_Dataset(DBObj.IBOStatement);
    MLUobj.MLUFieldName := Info['MLUFieldName'];
    MLUobj.MLUCol := MLUobj.IBODataset.Fieldbyname(MLUobj.MLUFieldName);
    ExtObject := MLUobj;
  except
    raise;
  end;
end;

procedure Tdws2IboLib.customIBOUnitClassesTQueryConstructorsCreateFromDBAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  ScriptObj: IScriptObj;
  DBObj: TdwsIboDataBaseObj;
begin
  ScriptObj := IScriptObj(IUnknown(Info['Database']));
  if ScriptObj = nil then
    DBObj := nil
  else
    DBObj := TdwsIboDataBaseObj(ScriptObj.ExternalObject);

  ExtObject := TdwsIBOStatementObj.Create;
  TdwsIBOStatementObj(ExtObject).IBOStatement := TIB_Query.Create(self);
  TdwsIBOStatementObj(ExtObject).IBOStatement.IB_Connection := DBObj.IBOConnection;
  TdwsIBOStatementObj(ExtObject).IBOStatement.IB_Transaction := FIBOTransaction;
end;

end.
