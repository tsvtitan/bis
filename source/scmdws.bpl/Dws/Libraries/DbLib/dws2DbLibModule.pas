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
{    February 16, 2000                                                 }
{                                                                      }
{    The Initial Developer of the Original Code is Willibald           }
{    Krenn. Portions created by Willibald Krenn are                    }
{    Copyright (C) 2000 Willibald Krenn, Austria. All                  }
{    Rights Reserved.
{                                                                      }
{    Contributor(s): ______________________________________.           }
{                                                                      }
{**********************************************************************}

unit dws2DbLibModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dws2Comp, dws2Exprs, Db, DBTables;

type
  Tdws2DbLib = class(TDataModule)
    dws2Unit1: Tdws2Unit;
    procedure dws2Unit1ClassesTQueryMethodsDestroyEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2Unit1ClassesTQueryMethodsFirstEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2Unit1ClassesTQueryMethodsNextEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2Unit1ClassesTQueryMethodsLastEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2Unit1ClassesTQueryMethodsEofEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2Unit1ClassesTQueryMethodsFieldByNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTQueryMethodsExecuteEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2Unit1ClassesTQueryMethodsFieldCountEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTQueryMethodsDisplayNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTQueryMethodsFieldValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2Unit1ClassesTQueryConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
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
  dws2DbLib: Tdws2DbLib;

implementation

{$R *.DFM}

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2DbLib]);
end;

{ TDataModule2 }

procedure Tdws2DbLib.SetScript(const Value: TDelphiWebScriptII);
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

procedure Tdws2DbLib.dws2Unit1ClassesTQueryConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  query: TQuery;
begin
  query := TQuery.Create(nil);
  query.DatabaseName := Info['Alias'];
  query.SQL.Text := Info['Sql'];
  query.Prepare;
  query.Active := True;
  ExtObject := query;
end;

procedure Tdws2DbLib.dws2Unit1ClassesTQueryMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure Tdws2DbLib.dws2Unit1ClassesTQueryMethodsFirstEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TQuery(ExtObject).First;
end;

procedure Tdws2DbLib.dws2Unit1ClassesTQueryMethodsNextEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TQuery(ExtObject).Next;
end;

procedure Tdws2DbLib.dws2Unit1ClassesTQueryMethodsLastEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TQuery(ExtObject).Last;
end;

procedure Tdws2DbLib.dws2Unit1ClassesTQueryMethodsEofEval(Info: TProgramInfo;
  ExtObject: TObject);
begin
  Info['Result'] := TQuery(ExtObject).Eof;
end;

procedure Tdws2DbLib.dws2Unit1ClassesTQueryMethodsFieldByNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TQuery(ExtObject).FieldByName(Info['Name']).AsVariant;
end;

procedure Tdws2DbLib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Script) then
    SetScript(nil)
end;

procedure Tdws2DbLib.dws2Unit1ClassesTQueryMethodsExecuteEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  query: TQuery;
begin
  query := TQuery.Create(nil);
  query.DatabaseName := Info['Alias'];
  query.SQL.Text := Info['Sql'];
  query.ExecSQL;
  query.Free;
end;

procedure Tdws2DbLib.dws2Unit1ClassesTQueryMethodsFieldCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TQuery(ExtObject).Fields.Count;
end;

procedure Tdws2DbLib.dws2Unit1ClassesTQueryMethodsDisplayNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TQuery(ExtObject).Fields[Info['i']].DisplayName;
end;

procedure Tdws2DbLib.dws2Unit1ClassesTQueryMethodsFieldValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TQuery(ExtObject).Fields[Info['i']].AsString;
end;

end.
