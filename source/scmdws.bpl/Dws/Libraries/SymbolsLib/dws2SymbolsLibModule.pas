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
{    The Initial Developer of the Original Code is Matthias            }
{    Ackermann. Portions created by Matthias Ackermann are             }
{    Copyright (C) 2000 Matthias Ackermann, Switzerland. All           }
{    Rights Reserved.                                                  }
{                                                                      }
{    Contributor(s): ______________________________________.           }
{                                                                      }
{**********************************************************************}

unit dws2SymbolsLibModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dws2Comp, dws2Exprs;

type
  Tdws2SymbolsLib = class(TDataModule)
    dws2Unit1: Tdws2Unit;
    procedure dws2Unit1ClassesTSymbolsMethodsFirstEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsMethodsLastEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsMethodsNextEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsMethodsPreviousEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsMethodsEofEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsMethodsCaptionEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsMethodsDescriptionEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsMethodsGetMembersEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsMethodsSymbolTypeEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsMethodsDestroyEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsMethodsNameEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsMethodsLocateEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsMethodsGetSuperClassEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsConstructorsCreateMainAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsConstructorsCreateUnitAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsConstructorsCreateUidAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2Unit1ClassesTSymbolsMethodsGetParametersEval(
      Info: TProgramInfo; ExtObject: TObject);
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
  dws2SymbolsLib: Tdws2SymbolsLib;

implementation

{$R *.DFM}

uses
  dws2Symbols;

type
  TSymbols = class
  private
    FIndex: Integer;
    FCount: Integer;
    FTable: TSymbolTable;
    FCurrentSymbol: TSymbol;
  public
    constructor Create(Table: TSymbolTable); overload;
    constructor Create(Symbol: TSymbol); overload;
    procedure SetIndex(Index: Integer);
    procedure SetSymbol(Symbol: TSymbol);
    property CurrentSymbol: TSymbol read FCurrentSymbol;
    property Count: Integer read FCount;
    property Index: Integer read FIndex;
  end;

const
  stUnknown = -1;
  stAlias = 0;
  stArray = 1;
  stClass = 2;
  stConstant = 3;
  stField = 4;
  stFunction = 5;
  stMember = 6;
  stParam = 7;
  stProperty = 8;
  stRecord = 9;
  stUnit = 10;
  stVariable = 11;

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2SymbolsLib]);
end;

{ TSymbols }

constructor TSymbols.Create(Table: TSymbolTable);
begin
  FTable := Table;
  FCount := Table.Count;
  SetIndex(0)
end;

constructor TSymbols.Create(Symbol: TSymbol);
begin
  SetSymbol(Symbol);
end;

procedure TSymbols.SetIndex(Index: Integer);
begin
  FIndex := Index;
  if Assigned(FTable) and (Index >= 0) and (Index < FCount) then
    FCurrentSymbol := FTable.Symbols[Index]
  else
    FCurrentSymbol := nil;
end;

procedure TSymbols.SetSymbol(Symbol: TSymbol);
begin
  FTable := nil;
  FCount := 0;
  FCurrentSymbol := Symbol;
end;

{ Tdws2SymbolsLib }

procedure Tdws2SymbolsLib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Script) then
    SetScript(nil)
end;

procedure Tdws2SymbolsLib.SetScript(const Value: TDelphiWebScriptII);
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

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsConstructorsCreateMainAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TSymbols.Create(Info.Caller.Root.RootTable);
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsConstructorsCreateUnitAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  sym: TSymbol;
begin
  sym := Info.Caller.Root.RootTable.FindLocal(Info['Name']);
  if Assigned(sym) and (sym is TUnitSymbol) then
    ExtObject := TSymbols.Create(TUnitSymbol(sym).Table)
  else
    raise Exception.CreateFmt('Unit "%s" not found!', [Info['Name']]);
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsConstructorsCreateUidAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  table: TSymbolTable;
  sym: TSymbol;
  uid, name: string;
  p: Integer;
begin
  table := Info.Caller.Root.RootTable;
  uid := Info['Uid'];
  sym := nil;

  while Length(uid) > 0 do
  begin
    p := Pos('$', uid);
    if p = 0 then
      p := Length(uid) + 1;

    name := Copy(uid, 1, p - 1);
    Delete(uid, 1, p);

    sym := table.FindLocal(name);

    if Length(uid) = 0 then
      Break;

    if sym is TUnitSymbol then
      table := TUnitSymbol(sym).Table
    else if sym is TClassSymbol then
      table := TClassSymbol(sym).Members
    else if sym is TFuncSymbol then
      table := TFuncSymbol(sym).Params
    else if sym is TRecordSymbol then
      table := TRecordSymbol(sym).Members;
  end;

  ExtObject := TSymbols.Create(sym);
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsFirstEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TSymbols(ExtObject).SetIndex(0);
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsLastEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TSymbols(ExtObject).SetIndex(TSymbols(ExtObject).Count - 1);
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsNextEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TSymbols(ExtObject).SetIndex(TSymbols(ExtObject).Index + 1);
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsPreviousEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TSymbols(ExtObject).SetIndex(TSymbols(ExtObject).Index - 1);
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsEofEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := not Assigned(TSymbols(ExtObject).FCurrentSymbol);
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsCaptionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TSymbols(ExtObject).CurrentSymbol.Caption;
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsDescriptionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TSymbols(ExtObject).CurrentSymbol.Description;
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsGetMembersEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  sym: TSymbol;
begin
  sym := TSymbols(ExtObject).CurrentSymbol;
  if sym is TRecordSymbol then
    Info.Result := Info.Vars['TSymbols'].GetConstructor('Create',
      TSymbols.Create(TRecordSymbol(sym).Members)).Call.Value
  else if sym is TClassSymbol then
    Info.Result := Info.Vars['TSymbols'].GetConstructor('Create',
      TSymbols.Create(TClassSymbol(sym).Members)).Call.Value
  else if sym is TUnitSymbol then
    Info.Result := Info.Vars['TSymbols'].GetConstructor('Create',
      TSymbols.Create(TUnitSymbol(sym).Table)).Call.Value
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsSymbolTypeEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  sym: TSymbol;
begin
  sym := TSymbols(ExtObject).CurrentSymbol;
  if sym is TArraySymbol then
    Info.Result := stArray
  else if sym is TAliasSymbol then
    Info.Result := stAlias
  else if sym is TClassSymbol then
    Info.Result := stClass
  else if sym is TConstSymbol then
    Info.Result := stConstant
  else if sym is TFieldSymbol then
    Info.Result := stField
  else if sym is TFuncSymbol then
    Info.Result := stFunction
  else if sym is TMemberSymbol then
    Info.Result := stMember
  else if sym is TParamSymbol then
    Info.Result := stParam
  else if sym is TPropertySymbol then
    Info.Result := stProperty
  else if sym is TRecordSymbol then
    Info.Result := stRecord
  else if sym is TUnitSymbol then
    Info.Result := stUnit
  else if sym is TDataSymbol then
    Info.Result := stVariable
  else
    Info.Result := stUnknown;
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TSymbols(ExtObject).CurrentSymbol.Name;
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsLocateEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  x: Integer;
  table: TSymbolTable;
  name: string;
  wasFound: Boolean;
begin
  table := TSymbols(ExtObject).FTable;
  name := Info['Name'];
  wasFound := False;
  for x := 0 to table.Count - 1 do
    if SameText(table[x].Name, name) then
    begin
      TSymbols(ExtObject).FIndex := x;
      wasFound := True;
      break;
    end;
  Info['Result'] := wasFound;
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsGetSuperClassEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  sym: TSymbol;
begin
  sym := TSymbols(ExtObject).CurrentSymbol;
  if sym is TClassSymbol then
    Info.Result := Info.Vars['TSymbols'].GetConstructor('Create',
      TSymbols.Create(TClassSymbol(sym).Parent)).Call.Value
  else
    Info.Result := 0;
end;

procedure Tdws2SymbolsLib.dws2Unit1ClassesTSymbolsMethodsGetParametersEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  sym: TSymbol;
begin
  sym := TSymbols(ExtObject).CurrentSymbol;
  Info.Result := Info.Vars['TSymbols'].GetConstructor('Create',
    TSymbols.Create(TFuncSymbol(sym).Params)).Call.Value
end;

end.
