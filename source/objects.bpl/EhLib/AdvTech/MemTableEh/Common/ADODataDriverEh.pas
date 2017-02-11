{*******************************************************}
{                                                       }
{                     EhLib v4.0                        }
{                                                       }
{         TADODataDriverEh component (Build 4.0.17)     }
{                                                       }
{     Copyright (c) 2004-2005 by Dmitry V. Bolshakov    }
{                                                       }
{*******************************************************}

unit ADODataDriverEh;

{$I EHLIB.INC}

interface

uses Windows, SysUtils, Classes, Controls, DB,
{$IFDEF EH_LIB_6} Variants, {$ENDIF}
{$IFDEF EH_LIB_5} Contnrs, {$ENDIF}
  ToolCtrlsEh, MemTableDataEh, DataDriverEh, ADODB;

type

  TAssignParameterEhEvent = procedure (Command: TCustomSQLCommandEh;
    MemRecord: TMemoryRecordEh; DataValueVersion: TDataValueVersionEh;
    Parameter: TParameter) of object;

  TADODataDriverEh = class;

  TADODBCommandEh = class(TADOCommand)
  protected
    property ComponentRef;
  end;

{ TADOCommandEh }

  TADOCommandEh = class(TCustomSQLCommandEh)
  private
    FOnAssignParameter: TAssignParameterEhEvent;
    FCommand: TADODBCommandEh;
    FParams: TParams;
    function GetParamCheck: Boolean;
    function GetParameters: TParameters;
    function GetDataDriver: TADODataDriverEh;
  protected
    procedure CommandTextChanged(Sender: TObject); override;
    procedure SetParamCheck(const Value: Boolean); virtual;
    procedure SetParameters(const Value: TParameters); virtual;
  public
    constructor Create(ADataDriver: TADODataDriverEh);
    destructor Destroy; override;
    function Execute(var Cursor: TDataSet; var FreeOnEof: Boolean): Integer; override;
    function GetParams: TParams; override;
    procedure Assign(Source: TPersistent); override;
    procedure DefaultRefreshParameter(MemRecord: TMemoryRecordEh;
      DataValueVersion: TDataValueVersionEh; Parameter: TParameter); virtual;
    procedure RefreshParams(MemRecord: TMemoryRecordEh; DataValueVersion: TDataValueVersionEh); override;
    procedure SetParams(AParams: TParams); override;

    property DataDriver: TADODataDriverEh read GetDataDriver;
    property OnAssignParameter: TAssignParameterEhEvent read FOnAssignParameter write FOnAssignParameter;
  published
    property CommandText;
    property CommandType;
    property Parameters: TParameters read GetParameters write SetParameters;
    property ParamCheck: Boolean read GetParamCheck write SetParamCheck default True;
  end;

{ TADODataDriverEh }

  TADODataDriverEh = class(TCustomSQLDataDriverEh)
  private
    FADOConnection: TADOConnection;
    FOnAssignCommandParameter: TAssignParameterEhEvent;
    FConnectionString: WideString;
    procedure SetConnection(const Value: TADOConnection);
    procedure SetConnectionString(const Value: WideString);
  protected
    function CreateCommand: TCustomSQLCommandEh; override;
    procedure AssignCommandParameter(Command: TADOCommandEh;
      MemRecord: TMemoryRecordEh; DataValueVersion: TDataValueVersionEh; Parameter: TParameter); virtual;
    procedure SetAutoIncFields(Fields: TFields; DataStruct: TMTDataStructEh); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CreateDesignCopy: TCustomSQLDataDriverEh; override;
    function HaveDataConnection(): Boolean; override;
    procedure GetBackUpdatedValues(MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh; ResDataSet: TDataSet); override;
//    procedure DoServerSpecOperations(MemRec: TMemoryRecordEh; Command: TCustomSQLCommandEh; ResDataSet: TDataSet); virtual;
    procedure DefaultAssignCommandParameter(Command: TADOCommandEh;
      MemRecord: TMemoryRecordEh; DataValueVersion: TDataValueVersionEh; Parameter: TParameter); virtual;
  published
    property ADOConnection: TADOConnection read FADOConnection write SetConnection;
    property ConnectionString: WideString read FConnectionString write SetConnectionString;
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
    property DynaSQLParams;
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
    property OnAssignCommandParameter: TAssignParameterEhEvent read FOnAssignCommandParameter write FOnAssignCommandParameter;
    property OnUpdateError;
  end;

function DefaultExecuteADOCommandEh(SQLDataDriver: TCustomSQLDataDriverEh;
    Command: TCustomSQLCommandEh; var Cursor: TDataSet; var FreeOnEof: Boolean;
    var Processed: Boolean; ADOConnection: TADOConnection;
    ConnectionString: WideString): Integer;

type TGetADODataDriverServerSpecOperations = function (DataDriver: TADODataDriverEh): TServerSpecOperationsEh;

function RegisterGetADODataDriverServerSpecOperationsPrg(Prg: TGetADODataDriverServerSpecOperations): TGetADODataDriverServerSpecOperations;

implementation

var
  FGetADODataDriverServerSpecOperationsPrg: TGetADODataDriverServerSpecOperations;

function RegisterGetADODataDriverServerSpecOperationsPrg(Prg: TGetADODataDriverServerSpecOperations): TGetADODataDriverServerSpecOperations;
begin
  Result := FGetADODataDriverServerSpecOperationsPrg;
  FGetADODataDriverServerSpecOperationsPrg := Prg;
end;

function DefaultExecuteADOCommandEh(SQLDataDriver: TCustomSQLDataDriverEh;
    Command: TCustomSQLCommandEh; var Cursor: TDataSet; var FreeOnEof: Boolean;
    var Processed: Boolean; ADOConnection: TADOConnection;
    ConnectionString: WideString): Integer;
var
  ACursor: TDataSet;
begin
  Result := -1;
  Cursor := nil;
  FreeOnEof := False;
  ACursor := nil;
  Processed := True;
  try
    case Command.CommandType of
      cthSelectQuery, cthUpdateQuery:
        begin
          ACursor := TADOQuery.Create(nil);
          with ACursor as TADOQuery do
          begin
            Connection := ADOConnection;
            ConnectionString := ConnectionString;
            SQL := Command.CommandText;
            Parameters.Assign(TBaseSQLCommandEh(Command).Params);
            if Command.CommandType = cthSelectQuery then
              Open
            else
            begin
              ExecSQL;
              Result := RowsAffected;
            end;
            TBaseSQLCommandEh(Command).Params.Assign(Parameters);
          end;
        end;
      cthTable:
        begin
          ACursor := TADOTable.Create(nil);
          with ACursor as TADOTable do
          begin
            Connection := ADOConnection;
            ConnectionString := ConnectionString;
            TableName := Command.CommandText.Text;
//            Parameters.Assign(TBaseSQLCommandEh(Command).Params);
            Open;
//            TBaseSQLCommandEh(Command).Params.Assign(Parameters);
          end;
        end;
      cthStoredProc:
        begin
          ACursor := TADOStoredProc.Create(nil);
          with ACursor as TADOStoredProc do
          begin
            Connection := ADOConnection;
            ConnectionString := ConnectionString;
            ProcedureName := Command.CommandText.Text;
            Parameters.Assign(TBaseSQLCommandEh(Command).Params);
            ExecProc;
//??            Result := RowsAffected;
            TBaseSQLCommandEh(Command).Params.Assign(Parameters);
          end;
        end;
    end;
    if ACursor.Active then
    begin
      Cursor := ACursor;
      FreeOnEof := True;
      ACursor := nil;
    end
  finally
    if ACursor <> nil then
      ACursor.Free;
  end;
end;

{ TADOCommandEh }

constructor TADOCommandEh.Create(ADataDriver: TADODataDriverEh);
begin
  inherited Create(ADataDriver);
  FCommand := TADODBCommandEh.Create(ADataDriver);
  FCommand.ComponentRef := ADataDriver;
end;

destructor TADOCommandEh.Destroy;
begin
  FCommand.Free;
  FParams.Free;
  inherited Destroy;
end;

procedure TADOCommandEh.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TBaseSQLCommandEh then
    with (Source as TBaseSQLCommandEh) do
    begin
      Self.ParamCheck := ParamCheck;
      Self.Parameters := Parameters;
    end;
end;

procedure TADOCommandEh.CommandTextChanged(Sender: TObject);
begin
  inherited CommandTextChanged(Sender);
  if (DataDriver <> nil) then
  begin
    FCommand.Connection := DataDriver.ADOConnection;
    FCommand.ConnectionString := DataDriver.ConnectionString;
  end;
  FCommand.CommandText := CommandText.Text;
//  if not (csReading in DataDriver.ComponentState) then
//    if ParamCheck then
//      Parameters.ParseSQL(CommandText.Text, True);
end;

procedure TADOCommandEh.RefreshParams(MemRecord: TMemoryRecordEh;
  DataValueVersion: TDataValueVersionEh);
var
  I: Integer;
begin
  for I := 0 to Parameters.Count - 1 do
  begin
    if Assigned(OnAssignParameter)
      then OnAssignParameter(Self, MemRecord, DataValueVersion, Parameters[I])
      else DefaultRefreshParameter(MemRecord, DataValueVersion, Parameters[I]);
  end;
end;

procedure TADOCommandEh.DefaultRefreshParameter(MemRecord: TMemoryRecordEh;
  DataValueVersion: TDataValueVersionEh; Parameter: TParameter);
begin
  DataDriver.AssignCommandParameter(Self, MemRecord, DataValueVersion, Parameter);
end;

function TADOCommandEh.Execute(var Cursor: TDataSet; var FreeOnEof: Boolean): Integer;
var
  ACursor: TDataSet;
begin
  Result := -1;
  Cursor := nil;
  FreeOnEof := False;
  ACursor := nil;
  try
    case CommandType of
      cthSelectQuery, cthUpdateQuery:
        begin
          ACursor := TADOQuery.Create(nil);
          with ACursor as TADOQuery do
          begin
            Connection := DataDriver.ADOConnection;
            ConnectionString := DataDriver.ConnectionString;
            SQL := Self.CommandText;
            Parameters.Assign(Self.Parameters);
            if CommandType = cthSelectQuery then
              Open
            else
            begin
              ExecSQL;
              Result := RowsAffected;
            end;
            Self.Parameters.Assign(Parameters);
          end;
        end;
      cthTable:
        begin
          ACursor := TADOTable.Create(nil);
          with ACursor as TADOTable do
          begin
            Connection := DataDriver.ADOConnection;
            ConnectionString := DataDriver.ConnectionString;
            TableName := Self.CommandText.Text;
            Parameters.Assign(Self.Parameters);
            Open;
            Self.Parameters.Assign(Parameters);
          end;
        end;
      cthStoredProc:
        begin
          ACursor := TADOStoredProc.Create(nil);
          with ACursor as TADOStoredProc do
          begin
            Connection := DataDriver.ADOConnection;
            ConnectionString := DataDriver.ConnectionString;
            ProcedureName := Self.CommandText.Text;
            Parameters.Assign(Self.Parameters);
            ExecProc;
//??            Result := RowsAffected;
            Self.Parameters.Assign(Parameters);
          end;
        end;
    end;
    if ACursor.Active then
    begin
      Cursor := ACursor;
      FreeOnEof := True;
      ACursor := nil;
    end
  finally
    if ACursor <> nil then
      ACursor.Free;
  end;
end;

function TADOCommandEh.GetDataDriver: TADODataDriverEh;
begin
  Result := TADODataDriverEh(inherited DataDriver);
end;

function TADOCommandEh.GetParamCheck: Boolean;
begin
  Result := FCommand.ParamCheck;
end;

procedure TADOCommandEh.SetParamCheck(const Value: Boolean);
begin
  FCommand.ParamCheck := Value;
end;

function TADOCommandEh.GetParameters: TParameters;
begin
  Result := FCommand.Parameters;
end;

procedure TADOCommandEh.SetParameters(const Value: TParameters);
begin
  FCommand.Parameters := Value;
end;

function TADOCommandEh.GetParams: TParams;
begin
  if not Assigned(FParams) then
    FParams := TParams.Create(Self);
  FParams.Assign(Parameters);
  Result := FParams;
end;

procedure TADOCommandEh.SetParams(AParams: TParams);
begin
  Parameters.Assign(AParams);
end;

{ TADODataDriverEh }

(*
var
  DataBaseInc: Integer = 0;

function GetUnicalDataBaseName: String;
begin
  Inc(DataBaseInc);
  Result := 'ADODataDriverEhDataBaseName' + IntToStr(DataBaseInc);
end;
*)

constructor TADODataDriverEh.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TADODataDriverEh.Destroy;
begin
  inherited Destroy;
end;

function TADODataDriverEh.CreateDesignCopy: TCustomSQLDataDriverEh;
begin
  Result := TADODataDriverEh.Create(nil);
  Result.SelectCommand := SelectCommand;
  Result.UpdateCommand := UpdateCommand;
  Result.InsertCommand := InsertCommand;
  Result.DeleteCommand := DeleteCommand;
  Result.GetrecCommand := GetrecCommand;
  TADODataDriverEh(Result).SpecParams := SpecParams;
//  TADODataDriverEh(Result).DatabaseName :=
//   (DesignDataBase as IDBXDesignDataBaseEh).GetDataBase.DatabaseName;
end;

type
  TDBDescription = record
    szName          : String;          { Logical name (Or alias) }
    szText          : String;          { Descriptive text }
    szPhyName       : String;          { Physical name/path }
    szDbType        : String;          { Database type }
  end;

function TADODataDriverEh.CreateCommand: TCustomSQLCommandEh;
begin
  Result := TADOCommandEh.Create(Self);
end;

procedure TADODataDriverEh.GetBackUpdatedValues(MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin
  inherited GetBackUpdatedValues(MemRec, Command, ResDataSet);
//  DoServerSpecOperations(MemRec, Command, ResDataSet);
end;

(*
//DB2
procedure DoDB2ServerSpecOperations(DataDriver: TADODataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin
end;

//InterBase
procedure DoInterBaseServerSpecOperations(DataDriver: TADODataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
const
  SGENSQL = 'SELECT GEN_ID(%s, %d) FROM RDB$DATABASE';  {do not localize}
var
  Generator, GeneratorField: String;
  q: TADOQuery;
begin
{ TODO : May be better to use Memrec.UpdateStatus = Inserted ? }
  if Command <> DataDriver.InsertCommand then Exit;
  Generator := DataDriver.SpecParams.Values['GENERATOR'];
  GeneratorField := DataDriver.SpecParams.Values['GENERATOR_FIELD'];
  if MemRec.DataStruct.FindField(GeneratorField) = nil then
    GeneratorField := '';
  if (Generator <> '') and (GeneratorField <> '') then
  begin
    q := TADOQuery.Create(nil);
    try
      q.Connection := DataDriver.ADOConnection;
      q.SQL.Text := Format(SGENSQL, [Generator, 0]);
      q.Open;
      // Get current GENERATOR value
      MemRec.DataValues[GeneratorField, dvvValueEh] := q.Fields[0].Value;
    finally
      q.Free;
    end;
  end;
end;

//Oracle
procedure DoOracleServerSpecOperations(DataDriver: TADODataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
const
  SEQSQL = 'SELECT %s.curval FROM dual';  {do not localize}
var
  Sequence, SequenceField: String;
  q: TADOQuery;
begin
  if Command <> DataDriver.InsertCommand then Exit;
  Sequence := DataDriver.SpecParams.Values['SEQUENCE'];
  SequenceField := DataDriver.SpecParams.Values['SEQUENCE_FIELD'];
  if MemRec.DataStruct.FindField(SequenceField) = nil then
    SequenceField := '';
  if (Sequence <> '') and (SequenceField <> '') and
     (ResDataSet is TCustomADODataSet) and (TCustomADODataSet(ResDataSet).Connection <> nil) then
  begin
    q := TADOQuery.Create(nil);
    try
      q.Connection := TCustomADODataSet(ResDataSet).Connection;
      q.SQL.Text := Format(SEQSQL, [Sequence, 0]);
      q.Open;
      // Get current Sequence value
      MemRec.DataValues[SequenceField, dvvValueEh] := q.Fields[0].Value;
    finally
      q.Free;
    end;
  end;
end;

//Sybase
procedure DoSybaseServerSpecOperations(DataDriver: TADODataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin
end;

//Informix
procedure DoInformixServerSpecOperations(DataDriver: TADODataDriverEh; MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
begin
end;


procedure TADODataDriverEh.DoServerSpecOperations(MemRec: TMemoryRecordEh;
  Command: TCustomSQLCommandEh; ResDataSet: TDataSet);
//var
//  DbType: String;
begin
  if (ADOConnection = nil) then
    Exit;
  if @FGetADODataDriverServerSpecOperationsPrg <> nil then
    FGetADODataDriverServerSpecOperationsPrg(Self).GetBackUpdatedValues(MemRec, Command, ResDataSet);

  // TODO : How to get name of server type from ADOConnection? 'Interbase, Oracle, MSSQL ....'
{
  //DbType := UpperCase(ADOConnection.DriverName);
  DbType := '';
  if DbType = 'INFROMIX' then
    DoInformixServerSpecOperations(Self, MemRec, Command, ResDataSet)
  else if DbType = 'DB2' then
    DoDB2ServerSpecOperations(Self, MemRec, Command, ResDataSet)
  else if DbType = 'INTRBASE' then
    DoInterBaseServerSpecOperations(Self, MemRec, Command, ResDataSet)
  else if DbType = 'ORACLE' then
    DoOracleServerSpecOperations(Self, MemRec, Command, ResDataSet)
  else if DbType = 'SYBASE' then
    DoSybaseServerSpecOperations(Self, MemRec, Command, ResDataSet);
}
end;

*)

procedure TADODataDriverEh.SetConnection(const Value: TADOConnection);
begin
  FADOConnection := Value;
end;

procedure TADODataDriverEh.SetAutoIncFields(Fields: TFields; DataStruct: TMTDataStructEh);
var
  AutoIncFieldName: String;
  AutoIncField: TMTDataFieldEh;
begin
  AutoIncFieldName := SpecParams.Values['AUTO_INCREMENT_FIELD'];
  AutoIncField := nil;
  if AutoIncFieldName <> '' then
    AutoIncField := DataStruct.FindField(AutoIncFieldName);
  if (AutoIncField <> nil) and (AutoIncField is TMTNumericDataFieldEh) then
//    TMTNumericDataFieldEh(AutoIncField).NumericDataType := fdtAutoIncEh;
    TMTNumericDataFieldEh(AutoIncField).AutoIncrement := True;
end;

procedure TADODataDriverEh.AssignCommandParameter(
  Command: TADOCommandEh; MemRecord: TMemoryRecordEh;
  DataValueVersion: TDataValueVersionEh; Parameter: TParameter);
begin
  if Assigned(OnAssignCommandParameter)
    then OnAssignCommandParameter(Command, MemRecord, DataValueVersion, Parameter)
    else DefaultAssignCommandParameter(Command, MemRecord, DataValueVersion, Parameter);
end;

procedure TADODataDriverEh.DefaultAssignCommandParameter(
  Command: TADOCommandEh; MemRecord: TMemoryRecordEh;
  DataValueVersion: TDataValueVersionEh; Parameter: TParameter);
var
  FIndex: Integer;
begin
  FIndex := MemRecord.DataStruct.FieldIndex(Parameter.Name);
  if FIndex >= 0 then
  begin
    { TODO : Check DataType as in TParam.AssignFieldValue }
    if Command.ParamCheck then
      Parameter.DataType := MemRecord.DataStruct[FIndex].DataType;
    Parameter.Value := MemRecord.DataValues[Parameter.Name, DataValueVersion];
  end
  else if (UpperCase(Copy(Parameter.Name,1, Length('OLD_'))) = 'OLD_') then
  begin
    FIndex := MemRecord.DataStruct.FieldIndex(Copy(Parameter.Name, 5, 255));
    if FIndex >= 0 then
    begin
      if Command.ParamCheck then
        Parameter.DataType := MemRecord.DataStruct[FIndex].DataType;
      Parameter.Value := MemRecord.DataValues[Copy(Parameter.Name, 5, 255), dvvOldestValue];
    end
  end;
end;

procedure TADODataDriverEh.SetConnectionString(const Value: WideString);
begin
  FConnectionString := Value;
end;

function TADODataDriverEh.HaveDataConnection: Boolean;
begin
  if Assigned(ADOConnection)
    then Result := True
    else Result := inherited HaveDataConnection();
end;

end.
