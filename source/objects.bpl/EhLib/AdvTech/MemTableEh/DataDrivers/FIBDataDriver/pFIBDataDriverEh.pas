{*******************************************************}
{                                                       }
{                     EhLib vX.X                        }
{                                                       }
{          TpFIBDataDriverEh component (Build 2)        }
{                                                       }
{      Copyright (c) 2004 by Serguei S. Borisoff        }
{                                                       }
{*******************************************************}

unit pFIBDataDriverEh;

{$I EhLib.inc}

interface

uses
  Windows, SysUtils, Classes, Controls, DB,
{$IFDEF EH_LIB_6} Variants, {$ENDIF}
{$IFDEF EH_LIB_5} Contnrs, {$ENDIF}
  ToolCtrlsEh, DBCommon, MemTableDataEh, DataDriverEh,
  pFIBDatabase;

type
  TpFIBDataDriverEh = class;

{ TpFIBCommandEh }

  TpFIBCommandEh = class(TBaseSQLCommandEh)
  private
    function GetDataDriver: TpFIBDataDriverEh;
  public
    function Execute(var Cursor: TDataSet;
      var FreeOnEof: Boolean): Integer; override;
    property DataDriver: TpFIBDataDriverEh read GetDataDriver;
  published
    property Params;
    property ParamCheck;
    property CommandText;
    property CommandType;
  end;

{ TpFIBDataDriverEh }

  TPFIBDataDriverEh = class(TBaseSQLDataDriverEh)
  private
    FDatabase: TpFIBDatabase;
    procedure SetDatabase(const Value: TpFIBDatabase);
  protected
    function CreateSelectCommand: TCustomSQLCommandEh; override;
    function CreateUpdateCommand: TCustomSQLCommandEh; override;
    function CreateInsertCommand: TCustomSQLCommandEh; override;
    function CreateDeleteCommand: TCustomSQLCommandEh; override;
    function CreateGetrecCommand: TCustomSQLCommandEh; override;
    procedure SetAutoIncFields(Fields: TFields;
      DataStruct: TMTDataStructEh); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CreateDesignCopy: TCustomSQLDataDriverEh; override;
    procedure GetBackUpdatedValues(MemRec: TMemoryRecordEh;
      Command: TCustomSQLCommandEh; ResDataSet: TDataSet); override;
    procedure DoServerSpecOperations(MemRec: TMemoryRecordEh;
      Command: TCustomSQLCommandEh; ResDataSet: TDataSet); virtual;
  published
    property Database: TpFIBDatabase read FDatabase write SetDatabase;
    property SelectCommand;
    property SelectSQL;
    property UpdateCommand;
    property UpdateSQL;
    property InsertCommand;
    property InsertSQL;
    property DeleteCommand;
    property DeleteSQL;
    property GetrecCommand;
    property GetrecSQL;
    property ProviderDataSet;
    property KeyFields;
    property SpecParams;

    property OnExecuteCommand;
    property OnBuildDataStruct;
    property OnGetBackUpdatedValues;
    property OnProduceDataReader;
    property OnAssignFieldValue;
    property OnReadRecord;
    property OnRefreshRecord;
    property OnUpdateRecord;
    property OnAssignCommandParam;
    property OnUpdateError;
  end;

function DefaultExecuteFIBCommandEh(SQLDataDriver: TCustomSQLDataDriverEh;
  Command: TCustomSQLCommandEh; var Cursor: TDataSet;
  var FreeOnEof, Processed: Boolean; ADatabase: TpFIBDatabase): Integer;

procedure Register;
  
implementation

uses
  FIBQuery, pFIBQuery, FIBDataSet, pFIBDataSet, pFIBProps;

procedure Register;
begin
{$IFDEF EH_LIB_5}
  RegisterComponents('EhLib', [TpFIBDataDriverEh]);
{$ENDIF}
end;
 
procedure ParamsToFIB(const Params: TParams; const FIBParams: TFIBXSQLDA);
var
  i: Integer;
  param: TParam;
  fib_param: TFIBXSQLVAR;
begin
  for i := 0 to Params.Count - 1 do begin
    param := Params[i];
    fib_param := FIBParams.FindParam(param.Name);
    if Assigned(fib_param) then
      fib_param.Value := param.Value;
  end;
end;

procedure FIBToParams(const FIBParams: TFIBXSQLDA; const Params: TParams);
var
  i: Integer;
  fib_param: TFIBXSQLVAR;
  param: TParam;
begin
  for i := 0 to FIBParams.Count - 1 do begin
    fib_param := FIBParams[i];
    param := Params.FindParam(fib_param.Name);
    if Assigned(param) then
      param.Value := fib_param.Value;
  end;  
end;

function DefaultExecuteFIBCommandEh(SQLDataDriver: TCustomSQLDataDriverEh;
  Command: TCustomSQLCommandEh; var Cursor: TDataSet;
  var FreeOnEof, Processed: Boolean; ADatabase: TpFIBDatabase): Integer;
var
  ACursor: TpFIBDataSet;
  q: TpFIBQuery;
begin
  Result := - 1;
  Cursor := nil;
  FreeOnEof := False;
  ACursor := nil;
  Processed := True;

  try
    case Command.CommandType of
      cthSelectQuery, cthTable: begin
        ACursor := TpFIBDataSet.Create(ADatabase);
        ACursor.Database := ADatabase;
        ACursor.Options := ACursor.Options + [poStartTransaction];
        ACursor.SelectSQL := Command.CommandText;

        if Command.CommandType = cthSelectQuery then
          ParamsToFIB(TBaseSQLCommandEh(Command).Params, ACursor.Params);

        if not ACursor.Database.Connected then
          ACursor.Database.Open();
          
        ACursor.Open();

        if Command.CommandType = cthSelectQuery then
          FIBToParams(ACursor.Params, TBaseSQLCommandEh(Command).Params);
      end;
      cthUpdateQuery, cthStoredProc: begin
        q := TpFIBQuery.Create(ADatabase);
        try
          q.Database := ADatabase;
          q.Transaction := TpFIBTransaction.Create(q);
          q.Transaction.DefaultDatabase := q.Database;
          q.Options := [qoTrimCharFields, qoStartTransaction, qoAutoCommit];
          q.SQL := Command.CommandText;
          ParamsToFIB(TBaseSQLCommandEh(Command).Params, q.Params);

          if not ACursor.Database.Connected then
            ACursor.Database.Open();

          if Command.CommandType = cthUpdateQuery then begin
            q.ExecQuery();
            Result := q.RowsAffected;
          end
          else begin // cthStoredProc
            q.ExecProc();
//??            Result := q.RowsAffected;
          end;  

          FIBToParams(q.Params, TBaseSQLCommandEh(Command).Params);
        finally
          FreeAndNil(q);
        end;
      end;
    end;

    if ACursor.Active then begin
      Cursor := ACursor;
      FreeOnEof := True;
      ACursor := nil;
    end
  finally
    if Assigned(ACursor) then
      ACursor.Free();
  end;
end;

{ TpFIBCommandEh }

function TpFIBCommandEh.Execute(var Cursor: TDataSet;
  var FreeOnEof: Boolean): Integer;
var
  ACursor: TpFIBDataSet;
  q: TpFIBQuery;
begin
  Result := - 1;
  Cursor := nil;
  FreeOnEof := False;
  ACursor := nil;

  try
    case CommandType of
      cthSelectQuery, cthTable: begin
        ACursor := TpFIBDataSet.Create(DataDriver.Database);
        ACursor.Database := DataDriver.Database;
        ACursor.Options := ACursor.Options + [poStartTransaction];
        ACursor.SelectSQL := CommandText;

        if CommandType = cthSelectQuery then
          ParamsToFIB(Params, ACursor.Params);

        ACursor.Open();

        if CommandType = cthSelectQuery then
          FIBToParams(ACursor.Params, Params);
      end;
      cthUpdateQuery, cthStoredProc: begin
        q := TpFIBQuery.Create(DataDriver.Database);
        try
          q.Database := DataDriver.Database;
          q.Transaction := TpFIBTransaction.Create(q);
          q.Transaction.DefaultDatabase := q.Database;
          q.Options := [qoTrimCharFields, qoStartTransaction, qoAutoCommit];
          q.SQL := CommandText;
          ParamsToFIB(Params, q.Params);

          if CommandType = cthUpdateQuery then begin
            q.ExecQuery();
            Result := q.RowsAffected;
          end
          else begin // cthStoredProc
            q.ExecProc();
//??            Result := q.RowsAffected;
          end;  

          FIBToParams(q.Params, Params);
        finally
          q.Free();
        end;
      end;
    end;

    if ACursor.Active then begin
      Cursor := ACursor;
      FreeOnEof := True;
      ACursor := nil;
    end
  finally
    if Assigned(ACursor) then
      ACursor.Free();
  end;
end;

function TpFIBCommandEh.GetDataDriver: TpFIBDataDriverEh;
begin
  Result := TpFIBDataDriverEh(inherited DataDriver);
end;

{ TpFIBDataDriverEh }

constructor TpFIBDataDriverEh.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TpFIBDataDriverEh.Destroy;
begin
  inherited;
end;

function TpFIBDataDriverEh.CreateDesignCopy: TCustomSQLDataDriverEh;
begin
  Result := TpFIBDataDriverEh.Create(nil);
  Result.SelectCommand := SelectCommand;
  Result.UpdateCommand := UpdateCommand;
  Result.InsertCommand := InsertCommand;
  Result.DeleteCommand := DeleteCommand;
  Result.GetrecCommand := GetrecCommand;
//  TpFIBDataDriverEh(Result).DatabaseName :=
//   (DesignDataBase as IFIBDesignDataBaseEh).GetDataBase.DatabaseName;
end;

function TpFIBDataDriverEh.CreateInsertCommand: TCustomSQLCommandEh;
begin
  Result := TpFIBCommandEh.Create(Self);
end;

function TpFIBDataDriverEh.CreateSelectCommand: TCustomSQLCommandEh;
begin
  Result := TpFIBCommandEh.Create(Self);
end;

function TpFIBDataDriverEh.CreateGetrecCommand: TCustomSQLCommandEh;
begin
  Result := TpFIBCommandEh.Create(Self);
end;

function TpFIBDataDriverEh.CreateUpdateCommand: TCustomSQLCommandEh;
begin
  Result := TpFIBCommandEh.Create(Self);
end;

function TpFIBDataDriverEh.CreateDeleteCommand: TCustomSQLCommandEh;
begin
  Result := TpFIBCommandEh.Create(Self);
end;

procedure TpFIBDataDriverEh.GetBackUpdatedValues(MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin
  inherited;
  
  DoServerSpecOperations(MemRec, Command, ResDataSet);
end;

//InterBase
procedure DoInterBaseServerSpecOperations(DataDriver: TpFIBDataDriverEh;
  MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
const
  SGENSQL = 'select gen_id(%s, %d) from rdb$database';  {do not localize}
var
  Generator, GeneratorField: String;
  q: TpFIBQuery;
begin
{ TODO : May be better to use Memrec.UpdateStatus = Inserted ? }
  if Command <> DataDriver.InsertCommand then
    Exit;
    
  Generator := DataDriver.SpecParams.Values['GENERATOR'];
  GeneratorField := DataDriver.SpecParams.Values['GENERATOR_FIELD'];
  if MemRec.DataStruct.FindField(GeneratorField) = nil then
    GeneratorField := '';
  if (Generator <> '') and (GeneratorField <> '') then begin
    q := TpFIBQuery.Create(DataDriver.Database);
    try
      q.Database := DataDriver.Database;
      q.Options := [qoTrimCharFields, qoStartTransaction];
      q.SQL.Text := Format(SGENSQL, [Generator, 0]);
      q.ExecQuery();
      // Get current GENERATOR value
      MemRec.DataValues[GeneratorField, dvvValueEh] := q.Fields[0].Value;
    finally
      q.Free();
    end;
  end;
end;

procedure TpFIBDataDriverEh.DoServerSpecOperations(MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin
  if (Database = nil) then
    Exit;

  DoInterBaseServerSpecOperations(Self, MemRec, Command, ResDataSet)
end;

procedure TpFIBDataDriverEh.SetDatabase(const Value: TpFIBDatabase);
begin
  FDatabase := Value;
end;

procedure TpFIBDataDriverEh.SetAutoIncFields(Fields: TFields;
  DataStruct: TMTDataStructEh);
var
  AutoIncFieldName: String;
  AutoIncField: TMTDataFieldEh;
begin
  AutoIncFieldName := SpecParams.Values['AUTO_INCREMENT_FIELD'];
  AutoIncField := nil;
  if AutoIncFieldName <> '' then
    AutoIncField := DataStruct.FindField(AutoIncFieldName);
  if (AutoIncField <> nil) and (AutoIncField is TMTNumericDataFieldEh) then
    TMTNumericDataFieldEh(AutoIncField).NumericDataType := fdtAutoIncEh;
end;

end.