unit DBXDynalink.QC57849;

interface

implementation

uses SysUtils, CodeRedirect, DBXCommon, DBXPlatform, DBXDynalink;

type
  TDBXDynalinkCommandCrack = class(TDBXDynalinkCommand);

  TDBXMethodTableHelper = class helper for TDBXMethodTable
  private
    procedure RaiseError(DBXContext: TDBXContext; DBXResult: TDBXErrorCode;
        DBXHandle: TDBXCommonHandle); overload;
    procedure RaiseError(DBXContext: TDBXContext; DBXResult: TDBXErrorCode;
        DBXHandle: TDBXCommonHandle; AdditionalInfo: WideString); overload;
  end;

  {$HINTS OFF}
  TDBXDynalinkCommandAccessor = class(TDBXCommand)
  private
    FConnectionHandle:  TDBXConnectionHandle;
    FCommandHandle:     TDBXCommandHandle;
    FMethodTable:       TDBXMethodTable;
  end;

  {$if CompilerVersion = 18.5}
  TDBXDynalinkRowAccessor = class(TDBXRowEx)
  private
    FRowHandle: TDBXRowHandle;
    FMethodTable: TDBXMethodTable;
  end;
  {$ifend}

  {$if CompilerVersion >= 20}
  TDBXDynalinkRowAccessor = class(TDBXRow)
  private
    FRowHandle:   TDBXRowHandle;
    FMethodTable: TDBXMethodTable;
    FTempBuffer:  TBytes;
  end;
  {$ifend}
  {$HINTS ON}

  TDBXDynalinkRowEx = class(TDBXDynalinkRow)
  private
    function Accessor: TDBXDynalinkRowAccessor;
  public
    procedure BeforeDestruction; override;
  end;

  TDBXDynalinkCommandHelper = class helper for TDBXDynalinkCommand
  private
    function Accessor: TDBXDynalinkCommandAccessor;
    procedure CheckResult(DBXResult: TDBXErrorCode);
  protected
    function CreateParameterRowPatch: TDBXRow;
  end;

function TDBXDynalinkCommandHelper.Accessor: TDBXDynalinkCommandAccessor;
begin
  Result := TDBXDynalinkCommandAccessor(Self);
end;

procedure TDBXDynalinkCommandHelper.CheckResult(DBXResult: TDBXErrorCode);
begin
  if DBXResult <> TDBXErrorCodes.None then
    Accessor.FMethodTable.RaiseError(FDBXContext, DBXResult, Accessor.FCommandHandle, '');
end;

function TDBXDynalinkCommandHelper.CreateParameterRowPatch: TDBXRow;
var
  ParameterRowHandle: TDBXRowHandle;
  M: TDBXMethodTable;
begin
  if Accessor.FCommandHandle = nil then
    Open;
  M := Accessor.FMethodTable;
  CheckResult(M.FDBXCommand_CreateParameterRow(Accessor.FCommandHandle, ParameterRowHandle));
  Result := TDBXDynalinkRowEx.Create(FDBXContext, Accessor.FMethodTable, ParameterRowHandle);
end;

procedure TDBXMethodTableHelper.RaiseError(DBXContext: TDBXContext; DBXResult:
    TDBXErrorCode; DBXHandle: TDBXCommonHandle);
begin
  RaiseError(DBXContext, DBXResult, DBXHandle, '');
end;

procedure TDBXMethodTableHelper.RaiseError(DBXContext: TDBXContext; DBXResult:
    TDBXErrorCode; DBXHandle: TDBXCommonHandle; AdditionalInfo: WideString);
var
  ErrorMessageBuilder: TDBXWideStringBuilder;
  ErrorMessage: WideString;
  Status: TDBXErrorCode;
  MessageLength: TInt32;
begin
  ErrorMessage := '';
  Status := FDBXBase_GetErrorMessageLength(DBXHandle, DBXResult, MessageLength);
  if(Status = TDBXErrorCodes.None) and(MessageLength > 0) then
  begin
    ErrorMessageBuilder := TDBXPlatform.CreateWideStringBuilder(MessageLength+1);
    try
      Status := FDBXBase_GetErrorMessage(DBXHandle, DBXResult, TDBXWideStringBuilder(ErrorMessageBuilder));
      if(Status = TDBXErrorCodes.None) then
      begin
        ErrorMessage := TDBXPlatform.ToWideString(ErrorMessageBuilder);
      end;
    finally
      TDBXPlatform.FreeAndNilWideStringBuilder(ErrorMessageBuilder);
    end;
  end;
  if AdditionalInfo <> '' then
  begin
    DBXContext.Error(DBXResult, WideFormat(SAdditionalInfo, [AdditionalInfo, ErrorMessage]));
  end else
  begin
    DBXContext.Error(DBXResult, ErrorMessage);
  end;

end;

function TDBXDynalinkRowEx.Accessor: TDBXDynalinkRowAccessor;
begin
  Result := TDBXDynalinkRowAccessor(Self);
end;

procedure TDBXDynalinkRowEx.BeforeDestruction;
begin
  inherited;
  Accessor.FMethodTable.FDBXBase_Close(Accessor.FRowHandle);
end;

var QC57849: TCodeRedirect;

initialization
  QC57849 := TCodeRedirect.Create(@TDBXDynalinkCommandCrack.CreateParameterRow, @TDBXDynalinkCommand.CreateParameterRowPatch);
finalization
  QC57849.Free;
end.
