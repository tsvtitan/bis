{**********************************************************************}
{    DWS2 ADO Library  - Version 1.0                                   }
{    Developed by Fabrizio Vita (http://web.tiscali.it/bizio)           }
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
{    The Original Code is DWS2-IBO-Library released January 1, 2001    }
{    (http://www.dwscript.com) and translated to ADO on September 2002 }
{                                                                      }
{**********************************************************************}

unit dws2ADOModule;

interface

uses
  Windows, SysUtils, Controls, Classes, Forms,
  dws2Comp, dws2Exprs, ADODB, Db;

type
  TdwsAdoDatasetObj = class(TObject)
    AdoDataset: TAdoDataset;
  public
    destructor destroy; override;
  end;

  TdwsADODataBaseObj = class(TObject)
    ADOConnection: TADOConnection;
  public
    RecordsAffected: Integer;
    destructor destroy; override;
  end;

  Tdws2ADOLib = class(TDataModule)
    customADOUnit: Tdws2Unit;
    procedure customADOUnitClassesTFieldMethodsSetValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTFieldMethodsGetValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTFieldMethodsSetValueStrEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTFieldMethodsGetValueStrEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDBFieldMethodsSetIntegerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDBFieldMethodsSetFloatEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDBFieldMethodsSetDateTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDBFieldMethodsGetIntegerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDBFieldMethodsGetFloatEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDBFieldMethodsGetDateTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDatasetMethodsLastEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDatasetMethodsGetSQLEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDatasetMethodsSetSQLEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDatasetMethodsFieldByNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDatasetMethodsFreeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDBFieldMethodsIsNullEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDatabaseMethodsExecuteEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDatabaseMethodsFreeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsExecuteEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsGetRecordsetEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsVersionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsStateEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsGetProviderEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsSetProviderEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsDatasetCountEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsSetConnectionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsRollbackTransEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsBeginTransEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsCommitTransEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsRecordCountEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsFirstEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsNextEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsCloseEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsEditEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsInsertEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsPostEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsCancelEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsDeleteEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsOpenEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsEofEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsOpenEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsCloseEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsSetFieldEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsGetFieldEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsFieldCountEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDBFieldMethodsDataTypeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDBFieldMethodsDataSizeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTDBFieldMethodsNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsGetHTMLComboEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsSetCommandTimeoutEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionMethodsGetCommandTimeoutEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsFieldAsStringEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsFieldAsDateTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsFieldAsIntegerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsFieldAsFloatEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsGetFieldAsVariantEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsSetFieldAsStringEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsSetFieldAsIntegerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsSetFieldAsDateTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsSetFieldAsFloatEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsSetFieldAsVariantEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsGetFieldIsNullEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsSetCommandTimeoutEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetMethodsGetCommandTimeoutEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customADOUnitClassesTADOConnectionConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure customADOUnitClassesTADODatasetConstructorsCreateAssignExternalObject(
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
  dws2ADOLib: Tdws2ADOLib;

implementation

{$R *.DFM}

uses
  ActiveX, Variants, dws2Symbols;

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2ADOLib]);
end;

destructor TdwsADODataBaseObj.destroy;
begin
  if assigned(ADOConnection) then
    ADOConnection.Close;
  inherited destroy;
end;

procedure Tdws2ADOLib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FScript) then
    SetScript(nil);
end;

procedure Tdws2ADOLib.SetScript(const Value: TDelphiWebScriptII);
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

// ****************************************************************************
// ********************* ADO Class Methods  ***********************************
// ****************************************************************************

destructor TdwsAdoDatasetObj.destroy;
begin
  if assigned(ADODataset) then
    AdoDataset.Free;
  inherited destroy;
end;

procedure Tdws2ADOLib.customADOUnitClassesTFieldMethodsSetValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TField(ExtObject).AsVariant := Info['Value'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTFieldMethodsGetValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TField(ExtObject).AsVariant;
end;

procedure Tdws2ADOLib.customADOUnitClassesTFieldMethodsSetValueStrEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TField(ExtObject).AsString := Info['Value'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTFieldMethodsGetValueStrEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TField(ExtObject).AsString;
end;

procedure Tdws2ADOLib.customADOUnitClassesTDBFieldMethodsSetIntegerEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TField(ExtObject).AsInteger := Info['Value'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTDBFieldMethodsSetFloatEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TField(ExtObject).AsFloat := Info['Value'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTDBFieldMethodsSetDateTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TField(ExtObject).AsDateTime := Info['Value'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTDBFieldMethodsGetIntegerEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TField(ExtObject).AsInteger;
end;

procedure Tdws2ADOLib.customADOUnitClassesTDBFieldMethodsGetFloatEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TField(ExtObject).AsFloat;
end;

procedure Tdws2ADOLib.customADOUnitClassesTDBFieldMethodsGetDateTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TField(ExtObject).AsDateTime;
end;

procedure Tdws2ADOLib.customADOUnitClassesTDatasetMethodsLastEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsADODatasetObj(ExtObject).AdoDataset do
  begin
    Last;
    Info.Result := not eof;
  end;
end;

procedure Tdws2ADOLib.customADOUnitClassesTDatasetMethodsGetSQLEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TdwsADODatasetObj(ExtObject).ADODataset.CommandText;
end;

procedure Tdws2ADOLib.customADOUnitClassesTDatasetMethodsSetSQLEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsADODatasetObj(ExtObject).ADODataset.CommandText := Info['sSQL'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTDatasetMethodsFieldByNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  //genera memoryleek
  Info.Result :=
    Info.Vars['TDBField'].GetConstructor('Create',
    TdwsADODatasetObj(ExtObject).ADODataset.FieldByName(Info['FieldName'])
    ).Call.Value;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  dsh: TdwsAdoDatasetObj;
begin
  dsh := TdwsAdoDatasetObj.Create;
  dsh.AdoDataset := TADODataset.Create(self);
  dsh.AdoDataset.CursorType := ctOpenForwardOnly;
  dsh.AdoDataset.CursorLocation := clUseClient;
  ExtObject := dsh;
end;

procedure Tdws2ADOLib.customADOUnitClassesTDatasetMethodsFreeEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  DatasetObj: TdwsAdoDatasetObj;
begin
  DatasetObj := TdwsADODatasetObj(ExtObject);

  DatasetObj.ADODataset.Close;
  DatasetObj.ADODataset.Free;
end;

procedure Tdws2ADOLib.customADOUnitClassesTDBFieldMethodsIsNullEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TField(ExtObject).IsNull;
end;

procedure Tdws2ADOLib.customADOUnitClassesTDatabaseMethodsExecuteEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  DBObj: TdwsAdoDatabaseObj;
begin
  DBObj := TdwsADODatabaseObj(ExtObject);

  with DBObj.ADOConnection do
  begin
    Execute(Info['sSQL'], DBObj.RecordsAffected);
  end;
end;

procedure Tdws2ADOLib.customADOUnitClassesTDatabaseMethodsFreeEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  dbh: TdwsADODataBaseObj;
begin
  dbh := TdwsADODataBaseObj(ExtObject);
  dbh.ADOConnection.Close;
  dbh.ADOConnection.Free;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsExecuteEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  scriptObj: IScriptObj;
  strSQL: string;
  datasetObj: TdwsAdoDatasetObj;
  dbObj: TdwsADODatabaseObj;
begin
  strSQL := Info['sSQL'];
  // il TADOConnection lo ricavo da ExtObject (l'oggetto chiamante)
  dbObj := TdwsADODatabaseObj(ExtObject);

  // creo l'oggetto TADODataset e memorizzo il suo indice
  scriptObj := IScriptObj(IUnknown(Info.Vars['TADODataset'].GetConstructor('Create', dbObj).Call.Value));
  // tramite iObj, ricavo il puntatore per DatasetObj e lo assegno
  datasetObj := TdwsAdoDatasetObj(scriptObj.ExternalObject);
  // creo l'oggetto ADODataset
  datasetObj.AdoDataset := TAdodataset.Create(dbObj.ADOConnection);

  datasetObj.AdoDataset.Recordset := dbObj.ADOConnection.Execute(strsql);

  Info.Result := scriptObj;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsGetRecordsetEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  scriptObj: IScriptObj;
  strSQL: string;
  datasetObj: TdwsAdoDatasetObj;
  dbObj: TdwsADODatabaseObj;
begin
  strSQL := Info['sSQL'];
  // il TADOConnection lo ricavo da ExtObject (l'oggetto chiamante)
  dbObj := TdwsADODatabaseObj(ExtObject);

  // creo l'oggetto TADODataset e memorizzo il suo indice
  scriptObj := IScriptObj(IUnknown(Info.Vars['TADODataset'].GetConstructor('Create', dbObj).Call.Value));
  // tramite iObj, ricavo il puntatore per DatasetObj e lo assegno
  datasetObj := TdwsAdoDatasetObj(scriptObj.ExternalObject);
  // creo l'oggetto ADODataset
  datasetObj.AdoDataset := TAdodataset.Create(dbObj.ADOConnection);

  with DatasetObj.AdoDataset do
  begin
    CursorType := ctOpenForwardOnly;
    CursorLocation := clUseClient;
    Connection := DBObj.ADOConnection;
    CommandText := strsql;
    Open;
  end;

  Info.Result := scriptObj;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsVersionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TdwsADODataBaseObj(ExtObject).ADOConnection.Version;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsStateEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsADODataBaseObj(ExtObject).ADOConnection do
  begin
    if State = [stClosed] then
      Info.Result := 0
    else if State = [stOpen] then
      Info.Result := 1
    else if State = [stConnecting] then
      Info.Result := 2
    else if State = [stExecuting] then
      Info.Result := 3
    else if State = [stFetching] then
      Info.Result := 4;
  end;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsGetProviderEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TdwsADODatabaseObj(ExtObject).Adoconnection.ConnectionString;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsSetProviderEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsADODatabaseObj(ExtObject).Adoconnection.ConnectionString := Info['Value'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsDatasetCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TdwsADODatabaseObj(ExtObject).Adoconnection.DataSetCount;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsSetConnectionEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  dbObj: TdwsADODatabaseObj;
  scriptObj: IScriptObj;
begin
  scriptObj := IScriptObj(IUnknown(Info['Value']));
  if scriptObj = nil then
    dbObj := nil
  else
    dbObj := TdwsADODatabaseObj(scriptObj.ExternalObject);

  TdwsADODatasetObj(ExtObject).AdoDataset.Connection := dbObj.Adoconnection;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsRollbackTransEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsADODatabaseObj(ExtObject).Adoconnection.RollbackTrans;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsBeginTransEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsADODatabaseObj(ExtObject).Adoconnection.BeginTrans;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsCommitTransEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsADODatabaseObj(ExtObject).Adoconnection.CommitTrans;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsRecordCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TdwsADODatasetObj(ExtObject).AdoDataset.RecordCount;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsFirstEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsADODatasetObj(ExtObject).AdoDataset do
  begin
    First;
    Info.Result := eof;
  end;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsNextEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsADODatasetObj(ExtObject).ADODataset do
  begin
    next;
    Info.Result := not eof;
  end;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsCloseEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsADODatasetObj(ExtObject).AdoDataset.close;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsEditEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsADODatasetObj(ExtObject).AdoDataset.edit;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsInsertEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsADODatasetObj(ExtObject).AdoDataset.Insert;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsPostEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsADODatasetObj(ExtObject).AdoDataset.Post;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsCancelEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsADODatasetObj(ExtObject).AdoDataset.cancel;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsDeleteEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsADODatasetObj(ExtObject).AdoDataset.Delete;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsOpenEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsADODatasetObj(ExtObject).AdoDataset.Open;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsEofEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TdwsADODatasetObj(ExtObject).AdoDataset.eof;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  dbh: TdwsADODataBaseObj;
begin
  dbh := TdwsADODataBaseObj.Create;
  dbh.ADOConnection := TADOConnection.Create(self);
  dbh.ADOConnection.CursorLocation := clUseClient;
  dbh.ADOConnection.LoginPrompt := False;
  dbh.ADOConnection.ConnectionString := Info['ConnectionString'];
  if dbh.ADOConnection.ConnectionString <> '' then
    dbh.ADOConnection.Open;
  ExtObject := dbh;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsOpenEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsADODatabaseObj(ExtObject) do
  begin
    ADOConnection.Open;
  end;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsCloseEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TdwsADODatabaseObj(ExtObject) do
  begin
    ADOConnection.Close;
  end;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsSetFieldEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  DatasetObj: TdwsAdoDatasetObj;
  FieldObj: TField;
  iObj: Integer;
begin
  iObj := Info['Value'];
  if iObj = 0 then
    FieldObj := nil
  else
    FieldObj := TField(ExtObject);

  DatasetObj := TdwsAdoDatasetObj(ExtObject);
  DatasetObj.AdoDataset.Fields[info['Index']] := FieldObj;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsGetFieldEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  DatasetObj: TdwsAdoDatasetObj;
begin
  DatasetObj := TdwsAdoDatasetObj(ExtObject);
  //genera memoryleek
  Info.Result :=
    Info.Vars['TDBField'].GetConstructor('Create',
    DatasetObj.ADODataset.Fields[Info['Index']]
    ).Call.Value;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsFieldCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TdwsAdoDatasetObj(ExtObject).AdoDataset.FieldCount;
end;

procedure Tdws2ADOLib.customADOUnitClassesTDBFieldMethodsDataTypeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TField(ExtObject).DataType;
end;

procedure Tdws2ADOLib.customADOUnitClassesTDBFieldMethodsDataSizeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TField(ExtObject).DataSize;
end;

procedure Tdws2ADOLib.customADOUnitClassesTDBFieldMethodsNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TField(ExtObject).FieldName;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsGetHTMLComboEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  DatasetObj: TdwsAdoDatasetObj;
  Selected, sField, res: string;
begin
  DatasetObj := TdwsAdoDatasetObj(ExtObject);
  Selected := Info['Selected'];
  Res := '';

  with DatasetObj.AdoDataset do
  begin
    while not EOF do
    begin
      sField := Fields[0].AsString;

      if sField = selected then
      begin
        Res := Res + '<OPTION SELECTED>' + sField + '</OPTION>';
      end
      else
      begin
        Res := Res + '<OPTION>' + sField + '</OPTION>';
      end;
      next;
    end;
  end;

  Info.Result := Res;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsSetCommandTimeoutEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsADODatabaseObj(ExtObject).Adoconnection.CommandTimeout := Info['Value'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTADOConnectionMethodsGetCommandTimeoutEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TdwsADODatabaseObj(ExtObject).Adoconnection.CommandTimeout;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsFieldAsStringEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  Index: Variant;
begin
  Index := info['Index'];
  if VarIsOrdinal(Index) then
    Info.Result := TdwsADODatasetObj(ExtObject).ADODataset.Fields[StrToInt(VarToStr(Index))].AsString
  else
    Info.Result := TdwsADODatasetObj(ExtObject).ADODataset.FieldByName(VarToStr(Index)).AsString;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsFieldAsDateTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  Index: Variant;
begin
  Index := info['Index'];
  if VarIsOrdinal(Index) then
    Info.Result := TdwsADODatasetObj(ExtObject).ADODataset.Fields[StrToInt(VarToStr(Index))].AsDateTime
  else
    Info.Result := TdwsADODatasetObj(ExtObject).ADODataset.FieldByName(VarToStr(Index)).AsDateTime;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsFieldAsIntegerEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  index: Variant;
begin
  index := info['index'];
  if VarIsOrdinal(index) then
    Info.Result := TdwsADODatasetObj(ExtObject).ADODataset.Fields[StrToInt(VarToStr(index))].AsInteger
  else
    Info.Result := TdwsADODatasetObj(ExtObject).ADODataset.FieldByName(VarToStr(index)).AsInteger;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsFieldAsFloatEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  index: Variant;
begin
  index := info['index'];
  if VarIsOrdinal(index) then
    Info.Result := TdwsADODatasetObj(ExtObject).ADODataset.Fields[StrToInt(VarToStr(index))].AsFloat
  else
    Info.Result := TdwsADODatasetObj(ExtObject).ADODataset.FieldByName(VarToStr(index)).AsFloat;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsGetFieldAsVariantEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  index: Variant;
begin
  index := info['index'];
  if VarIsOrdinal(index) then
    Info.Result := TdwsADODatasetObj(ExtObject).ADODataset.Fields[StrToInt(VarToStr(index))].AsVariant
  else
    Info.Result := TdwsADODatasetObj(ExtObject).ADODataset.FieldByName(VarToStr(index)).Asvariant;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsSetFieldAsStringEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  index: Variant;
begin
  index := info['index'];
  if VarIsOrdinal(index) then
    TdwsADODatasetObj(ExtObject).ADODataset.Fields[StrToInt(VarToStr(index))].AsString := info['Value']
  else
    TdwsADODatasetObj(ExtObject).ADODataset.FieldByName(VarToStr(index)).AsString := info['Value'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsSetFieldAsIntegerEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  index: Variant;
begin
  index := info['index'];
  if VarIsOrdinal(index) then
    TdwsADODatasetObj(ExtObject).ADODataset.Fields[StrToInt(VarToStr(index))].AsInteger := info['Value']
  else
    TdwsADODatasetObj(ExtObject).ADODataset.FieldByName(VarToStr(index)).AsInteger := info['Value'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsSetFieldAsDateTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  Index: Variant;
begin
  Index := info['Index'];
  if VarIsOrdinal(Index) then
    TdwsADODatasetObj(ExtObject).ADODataset.Fields[StrToInt(VarToStr(Index))].AsDateTime := info['Value']
  else
    TdwsADODatasetObj(ExtObject).ADODataset.FieldByName(VarToStr(Index)).AsDateTime := info['Value'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsSetFieldAsFloatEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  Index: Variant;
begin
  Index := info['Index'];
  if VarIsOrdinal(Index) then
    TdwsADODatasetObj(ExtObject).ADODataset.Fields[StrToInt(VarToStr(Index))].AsFloat := info['Value']
  else
    TdwsADODatasetObj(ExtObject).ADODataset.FieldByName(VarToStr(Index)).AsFloat := info['Value'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsSetFieldAsVariantEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  Index: Variant;
begin
  Index := info['Index'];
  if VarIsOrdinal(Index) then
    TdwsADODatasetObj(ExtObject).ADODataset.Fields[StrToInt(VarToStr(Index))].AsVariant := info['Value']
  else
    TdwsADODatasetObj(ExtObject).ADODataset.FieldByName(VarToStr(Index)).AsVariant := info['Value'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsGetFieldIsNullEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  index: Variant;
begin
  index := info['index'];
  if VarIsOrdinal(index) then
    Info.Result := TdwsADODatasetObj(ExtObject).ADODataset.Fields[StrToInt(VarToStr(index))].IsNull
  else
    Info.Result := TdwsADODatasetObj(ExtObject).ADODataset.FieldByName(VarToStr(index)).IsNull;
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsSetCommandTimeoutEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TdwsAdoDatasetObj(ExtObject).AdoDataset.CommandTimeout := Info['Value'];
end;

procedure Tdws2ADOLib.customADOUnitClassesTADODatasetMethodsGetCommandTimeoutEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TdwsAdoDatasetObj(ExtObject).AdoDataset.CommandTimeout;
end;

initialization
  CoInitializeEx(nil, COINIT_MULTITHREADED);
finalization
  CoUninitialize;
end.

