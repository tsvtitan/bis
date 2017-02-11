////////
///
//  dws2ThreadedDebugger.pas
//
//  DWSII debugger component
//
//  Copyright (c) 2002-2003 Fabio Augusto Dal Castel
//
//  Modified by Pietro Barbaro - A&F Informatica S.r.l.
//
/////

{$I dws2.inc}

{$DEFINE USE_FIBERS}

unit dws2ThreadedDebugger;

interface

uses
  Classes,
  {$IFDEF NEWVARIANTS}
  Variants,
  {$ENDIF}
  Contnrs, SyncObjs, {$IFDEF USE_FIBERS}Fibers, {$ENDIF}
  dws2Exprs, dws2Errors, dws2Symbols;

type
  TOnDebugEvent = procedure(Sender: TObject; Prog: TProgram; Expr: TExpr) of object;

{$IFDEF USE_FIBERS}
  Tdws2DebuggerThread = class(TFiber)
{$ELSE}
  Tdws2DebuggerThread = class(TThread)
{$ENDIF}
  private
    // 20/02/2003 - Pietro
    // FProcName is the name of the procedure to call
    // FProcName = '' means to run the entire program
    FProcName: string;                // name of the procedure to call
    FProcParams: array of variant;    // list of parameters
    FRes: IInfo;
    FProgram: TProgram;
  protected
    procedure Execute; override;
    procedure executeEntireProgram;
    procedure executeProcedureCall;
  public
    constructor Create(AProgram: TProgram);
  end;

  Tdws2DebuggerState = (dsStopped, dsRunning, dsSteppingInto, dsSteppingOver, dsRunningToLine, dsRunningUntilReturn);

  Tdws2ThreadedDebugger = class(TComponent, IUnknown, IDebugger)
  private
    FBreakpoints: TBits;
    FCallStack: TObjectStack;
    FLastStopExpr: TExpr;
    FLastEvaluatedExpr: TExpr;
    FProgramRoot: TProgram;
    FDebuggerThread: Tdws2DebuggerThread;
    FRunningToLine: Integer;
    FRunningUntilReturnStackLevel: Integer;
    FState: Tdws2DebuggerState;
    FStatements: TBits;
    FStepOverStackLevel: Integer;
    FWantPause: Boolean;
    FExecuteCallResult: variant;

    SyncProg: TProgram;
    SyncExpr: TExpr;
    FOnDebugPause: TOnDebugEvent;
    FOnDebugResume: TNotifyEvent;
    FOnDebugTerminate: TNotifyEvent;

    procedure CallDebugPause;
    procedure CheckBreakpointsSize(ASize: Integer);
    procedure CheckProgram(AProgram: TProgram);
    procedure CheckStatementsSize(ASize: Integer);
    procedure DebuggerThreadTerminate(Sender: TObject);
    procedure DoDebugResume;
    procedure DoDebugTerminate;
    function GetBreakPoint(ALine: Integer): Boolean;
    function GetInDebugPause: Boolean;
    function GetInDebugSession: Boolean;
    function GetStatement(ALine: Integer): Boolean;
    procedure SetBreakPoint(ALine: Integer; const Value: Boolean);
    procedure SetStatement(ALine: Integer; const Value: Boolean);
  public
    lastExpr: TExpr;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // IDebugger methods
    procedure DoDebug(Prog: TProgram; Expr: TExpr);
    procedure EnterFunc(Prog: TProgram; Expr: TExpr);
    procedure LeaveFunc(Prog: TProgram; Expr: TExpr);
    procedure StartDebug(MainProg: TProgram);
    procedure StopDebug(MainProg: TProgram);

    // Public methods
    function CanModifyLastEvaluated: Boolean;
    procedure ClearAllBreakpoints;
    procedure ClearAllStatements;
    function Evaluate(AExpression: string): string;
    procedure GetCallStack(AItems: TStrings);
    procedure ModifyLastEvaluated(ANewValue: string);
    procedure Pause;
    procedure Prepare(AProgram: TProgram);
    procedure Reset;
    procedure Run;
    procedure RunToLine(ALine: Integer);
    procedure RunUntilReturn;
    procedure ScanStatements(AProgram: TProgram);
    procedure StepInto;
    procedure StepOver;
    procedure ToggleBreakpoint(ALine: Integer);

    // PIETRO
    procedure ClearProcedureName;
    // PIETRO
    procedure SetProcedureName(procName: string; const Params: array of variant);
    //PIETRO
    function GetExecuteCallResult: variant;

    property Breakpoint[ALine: Integer]: Boolean read GetBreakpoint write SetBreakpoint;
    property Statement[ALine: Integer]: Boolean read GetStatement write SetStatement;

    property InDebugPause: Boolean read GetInDebugPause;
    property InDebugSession: Boolean read GetInDebugSession;

    property OnDebugPause: TOnDebugEvent read FOnDebugPause write FOnDebugPause;
    property OnDebugResume: TNotifyEvent read FOnDebugResume write FOnDebugResume;
    property OnDebugTerminate: TNotifyEvent read FOnDebugTerminate write FOnDebugTerminate;
  end;

implementation

uses SysUtils, Forms, dws2Compiler;

const
  BREAKPOINTS_ARRAY_INITIAL_SIZE = 1024;
  STATEMENTS_ARRAY_INITIAL_SIZE = 1024;
  NIL_STRING = 'nil';
  NULL_STRING = 'Null';
  UNASSIGNED_STRING = 'Unassigned';

type
  TDebuggerStackFunc = class;

  TDebuggerStackArg = class(TObject)        // An argument of a TDebuggerStackFunc
  private
    FOwner: TDebuggerStackFunc;
    FValue: Variant;
    FTyp: TSymbol;
  public
    constructor Create(AOwner: TDebuggerStackFunc; AValue: Variant; ATyp: TSymbol);
    function DisplayText: string;
  end;

  TDebuggerStackFunc = class(TObject)       // A function call in stack
  private
    FFunc: TFuncExpr;
    FArgs: TObjectList;
  public
    constructor Create(AFunc: TFuncExpr);
    destructor Destroy; override;
    function DisplayText: string;
  end;

// --- Functions ---------------------------------------------------------

function VarToScriptObj(V: Variant): IScriptObj;
begin
  Result := nil;
  if VarType(V) = varUnknown then
    Result := IScriptObj(IUnknown(V));
end;

function ValueToString(AValue: Variant; ATyp: TSymbol; AProg: TProgram): string;
begin
  if ATyp is TBaseSymbol then
    if ATyp = AProg.TypString then
      Result := QuotedStr(VarToStr(AValue))
    else if ATyp = AProg.TypVariant then
      if VarIsNull(AValue) then
        Result := NULL_STRING
      else if VarIsEmpty(AValue) then
        Result := UNASSIGNED_STRING
      else
        Result := VarToStr(AValue)
    else
      Result := VarToStr(AValue)
  else if ATyp is TArraySymbol then
    Result := '()'
  else if ATyp is TRecordSymbol then
    Result := '()'
  else if ATyp is TClassSymbol then
    if VarToScriptObj(AValue) = nil then
      Result := NIL_STRING
    else
      Result := '()'             
  else if ATyp is TClassOfSymbol then
    if AValue = '' then
      Result := NIL_STRING
    else
      Result := VarToStr(AValue)
  else if ATyp is TNilSymbol then
    Result := NIL_STRING;
end;

function ArrayToString(AExpr: TExpr): string;

  function ArrayValueToString(AVal: Integer; ATyp: TSymbol): string;
  var
    ArrayLength, ArrayElementSize: Integer;
    i: Integer;
  begin
    ArrayLength := (AExpr as TDataExpr).Data[AVal];
    Inc(AVal);
    ArrayElementSize := (AExpr as TDataExpr).Data[AVal];
    Inc(AVal);

    Result := '';
    for i := 0 to ArrayLength - 1 do
    begin
      if ATyp is TArraySymbol then
        // array of array ...
        Result := Result + ArrayValueToString((AExpr as TDataExpr).Data[AVal], ATyp.Typ) + ', '
      else
        Result := Result + ValueToString((AExpr as TDataExpr).Data[AVal], ATyp, AExpr.Prog) + ', ';
      Inc(AVal, ArrayElementSize);
    end;
    if Result <> '' then
      Delete(Result, Length(Result) - 1, 2);
    Result := '(' + Result + ')';
  end;

var
  Val: Variant;
begin
  Val := AExpr.Eval;
  if VarIsNull(Val) then
    Result := NIL_STRING               // Empty array
  else
    Result := ArrayValueToString(Val, AExpr.Typ.Typ);
end;

function RecordToString(AExpr: TExpr): string;
var
  ExprTyp: TRecordSymbol;
  Val: Integer;
  Member: TSymbol;
  i: Integer;
begin
  ExprTyp := (AExpr.Typ as TRecordSymbol);
  Val := (AExpr as TDataExpr).Addr;

  Result := '';
  for i := 0 to ExprTyp.Members.Count - 1 do
  begin
    Member := ExprTyp.Members.Symbols[i];
    if Member is TMemberSymbol then
      Result := Result + Member.Name + ': ' + ValueToString((AExpr as TDataExpr).Data[Val + (Member as TMemberSymbol).Offset], Member.Typ, AExpr.Prog) + ', ';
  end;
  if Result <> '' then
    Delete(Result, Length(Result) - 1, 2);
  Result := '(' + Result + ')';
end;

function ClassToString(AExpr: TExpr): string;

  function EnumMembers(AObj: IScriptObj; AMemberTable: TSymbolTable): string;
  var
    Member: TSymbol;
    i: Integer;
  begin
    Result := '';
    if AMemberTable.ParentCount > 0 then
      // Display parent class fields
      Result := EnumMembers(AObj, TSymbolTable(AMemberTable.Parents[0]));

    for i := 0 to AMemberTable.Count - 1 do
    begin
      Member := AMemberTable.Symbols[i];
      if Member is TFieldSymbol then
        Result := Result + Member.Name + ': ' + ValueToString(AObj.Data[(Member as TFieldSymbol).Offset], Member.Typ, AExpr.Prog) + ', ';
    end;
  end;

var
  ExprTyp: TClassSymbol;
  Obj: IScriptObj;
begin
  ExprTyp := (AExpr.Typ as TClassSymbol);
  Obj := VarToScriptObj(AExpr.Eval);
  if Obj = nil then
    Result := NIL_STRING
  else
  begin
    Result := EnumMembers(Obj, ExprTyp.Members);
    if Result <> '' then
      Delete(Result, Length(Result) - 1, 2);
    Result := '(' + Result + ')';
  end;
end;

function ClassOfToString(AExpr: TExpr): string;
begin
  Result := AExpr.Eval;
  if Result = '' then
    Result := NIL_STRING;
end;

function ExprToString(AExpr: TExpr): string;
begin
  if AExpr.Typ is TBaseSymbol then
    Result := ValueToString(AExpr.Eval, AExpr.Typ, AExpr.Prog)
  else if AExpr.Typ is TArraySymbol then
    Result := ArrayToString(AExpr)
  else if AExpr.Typ is TRecordSymbol then
    Result := RecordToString(AExpr)
  else if AExpr.Typ is TClassSymbol then
    Result := ClassToString(AExpr)
  else if AExpr.Typ is TClassOfSymbol then
    Result := ClassOfToString(AExpr)
  else if AExpr.Typ is TNilSymbol then
    Result := NIL_STRING
  else
    if AExpr.Typ = nil then
      Result := 'Unknow expression type.'
    else
      Result := 'Unknow expression type: ' + AExpr.Typ.Name;
end;

// --- TDebuggerStackArg -------------------------------------------------

constructor TDebuggerStackArg.Create(AOwner: TDebuggerStackFunc; AValue: Variant; ATyp: TSymbol);
begin
  inherited Create;
  FOwner := AOwner;
  FValue := AValue;
  FTyp := ATyp;
end;

function TDebuggerStackArg.DisplayText: string;
begin
  Result := ValueToString(FValue, FTyp, FOwner.FFunc.Prog)
end;

// --- TDebuggerStackFunc ------------------------------------------------

constructor TDebuggerStackFunc.Create(AFunc: TFuncExpr);
var
  i: Integer;
begin
  FFunc := AFunc;
  FArgs := TObjectList.Create(True);

  // Save current value and type of each argument
  for i := 0 to FFunc.Args.Count - 1 do
    FArgs.Add(TDebuggerStackArg.Create(Self, FFunc.Args[i].Eval, FFunc.Args[i].Typ));
end;

destructor TDebuggerStackFunc.Destroy;
begin
  FArgs.Free;
  inherited;
end;

function TDebuggerStackFunc.DisplayText: string;
var
  sArgs: string;
  i: Integer;
begin
  sArgs := '';
  for i := 0 to FArgs.Count - 1 do
    sArgs := sArgs + (FArgs[i] as TDebuggerStackArg).DisplayText + ', ';
  if sArgs <> '' then
    Delete(sArgs, Length(sArgs) - 1, 2);

  Result := '';
  if FFunc is TMethodStaticExpr then
    Result := (FFunc.FuncSym as TMethodSymbol).ClassSymbol.Name + '.';
  Result := Result + FFunc.FuncSym.Name + '(' + sArgs + ')';
end;

// --- Tdws2DebuggerThread -----------------------------------------------------

constructor Tdws2DebuggerThread.Create(AProgram: TProgram);
begin
  inherited Create(True);
  FProgram := AProgram;
  FreeOnTerminate := True;
end;

// --------------------------------------------------------------------
// 20/02/2003 - Pietro
// --------------------------------------------------------------------
procedure Tdws2DebuggerThread.Execute;
begin
  // check FProcName
  if (FProcName = '') then
    // is empty --> run entire program
    ExecuteEntireProgram
  else
    // execute a call to the procedure specified in FProcName
    executeProcedureCall;
end;

// PIETRO
procedure Tdws2DebuggerThread.executeEntireProgram;
begin
  try
    FProgram.Execute
  except
    // Catch any exception as Error
    on e: exception do
      if (e.message <> '') then
        FProgram.Msgs.AddError(e.Message);
  end;
end;

// PIETRO
procedure Tdws2DebuggerThread.executeProcedureCall;
var
  Info: TProgramInfo;
begin
  FProgram.BeginProgram(false);
  if not FProgram.Msgs.HasErrors then
  begin
    Info := TProgramInfo.Create(FProgram.Table, FProgram);
    try
      // execute a call to the procedure specified in FProcName
      FRes := Info.Func[FProcName].Call(FProcParams);
    except
      // Catch any unhandled exception during execution
      on e: exception do
        if (e.message <> '') then
          FProgram.Msgs.AddError(e.Message);
    end;
    Info.free;
  end;
  FProgram.EndProgram;
end;


// --- Tdws2ThreadedDebugger ---------------------------------------------

constructor Tdws2ThreadedDebugger.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBreakpoints := TBits.Create;
  FBreakpoints.Size := BREAKPOINTS_ARRAY_INITIAL_SIZE;
  FCallStack := TObjectStack.Create;
  FStatements := TBits.Create;
  FStatements.Size := STATEMENTS_ARRAY_INITIAL_SIZE;
end;

destructor Tdws2ThreadedDebugger.Destroy;
begin
  FStatements.Free;
  FCallStack.Free;
  FBreakpoints.Free;

  FreeAndNil(FLastEvaluatedExpr);
  inherited Destroy;
end;

procedure Tdws2ThreadedDebugger.CallDebugPause;
begin
  if Assigned(FOnDebugPause) then
    FOnDebugPause(Self, SyncProg, SyncExpr);
end;

procedure Tdws2ThreadedDebugger.CheckBreakpointsSize(ASize: Integer);
begin
  if FBreakpoints.Size <= ASize then
    FBreakpoints.Size := ASize * 2;
end;

procedure Tdws2ThreadedDebugger.CheckProgram(AProgram: TProgram);
begin
  // This version supports only one program at time.
  // This procedure just check this.

  if FProgramRoot = nil then
    // Never should happen, but...
    raise Exception.Create('Debugger isn''t running (bug !?)');

  if AProgram.Root <> FProgramRoot then
    raise Exception.Create('This debugger version supports only one program at time.');
end;

procedure Tdws2ThreadedDebugger.CheckStatementsSize(ASize: Integer);
begin
  if FStatements.Size <= ASize then
    FStatements.Size := ASize * 2;
end;

procedure Tdws2ThreadedDebugger.DoDebugResume;
begin
  // Called in main thread context
  if Assigned(FOnDebugResume) then
    FOnDebugResume(Self);
  FDebuggerThread.Resume;
end;

procedure Tdws2ThreadedDebugger.DoDebugTerminate;
begin
  // Called in main thread context
  if Assigned(FOnDebugTerminate) then
    FOnDebugTerminate(Self);
end;

function Tdws2ThreadedDebugger.GetBreakPoint(ALine: Integer): Boolean;
begin
  CheckBreakpointsSize(ALine);
  Result := FBreakpoints[ALine];
end;

function Tdws2ThreadedDebugger.GetInDebugPause: Boolean;
begin
  Result := (FDebuggerThread <> nil) and FDebuggerThread.Suspended;
end;

function Tdws2ThreadedDebugger.GetInDebugSession: Boolean;
begin
  Result := (FDebuggerThread <> nil);
end;

function Tdws2ThreadedDebugger.GetStatement(ALine: Integer): Boolean;
begin
  Result := False;
  if ALine < FStatements.Size then
    Result := FStatements.Bits[ALine];
end;

procedure Tdws2ThreadedDebugger.SetBreakPoint(ALine: Integer; const Value: Boolean);
begin
  CheckBreakpointsSize(ALine);
  FBreakpoints[ALine] := Value;
end;

procedure Tdws2ThreadedDebugger.SetStatement(ALine: Integer; const Value: Boolean);
begin
  CheckStatementsSize(ALine);
  FStatements[ALine] := Value;
end;

procedure Tdws2ThreadedDebugger.DebuggerThreadTerminate(Sender: TObject);
begin
  // PIETRO - catch result value of function call
  if (FDebuggerThread.FProcName = '') then
    FExecuteCallResult := null
  else begin
    if assigned(FDebuggerThread.FRes) and not VarIsEmpty(FDebuggerThread.FRes.value) then
      FExecuteCallResult := FDebuggerThread.FRes.Value
    else
      FExecuteCallResult := null;
  end;

  FDebuggerThread := nil;           // FDebuggerThread.FreeOnTerminate = True
  DoDebugTerminate;
end;

procedure Tdws2ThreadedDebugger.DoDebug(Prog: TProgram; Expr: TExpr);
var
  DebugThisEvent: Boolean;
  LastStopLine: Integer;
begin
  // Called in DebuggerThread context

  if FDebuggerThread.Terminated then
  begin
    // Thread has been asked to terminate. Stop the program.
    // (this will finish TThread.Execute)
    FDebuggerThread.FProgram.Stop;
    Exit;
  end;

  lastExpr := expr;
  CheckProgram(Prog);

  DebugThisEvent := FWantPause;
  if FWantPause then
    FWantPause := False;

  if not DebugThisEvent then
    // Don't need to stop if there isn't a line number
    if Expr.Pos.Line > 0 then            // Can be -1
    begin
      DebugThisEvent := BreakPoint[Expr.Pos.Line];

      // Line number of last stop
      LastStopLine := -1;
      if FLastStopExpr <> nil then
        LastStopLine := FLastStopExpr.Pos.Line;

      if not DebugThisEvent then
        case FState of
          dsSteppingInto:
            DebugThisEvent := (Expr.Pos.Line <> LastStopLine);

          dsSteppingOver:
            DebugThisEvent := (FCallStack.Count <= FStepOverStackLevel) and
                              (Expr.Pos.Line <> LastStopLine);

          dsRunningToLine:
            DebugThisEvent := (Expr.Pos.Line = FRunningToLine);
        end;
    end;

  if DebugThisEvent then
  begin
    FLastStopExpr := Expr;
    FState := dsRunning;

    if Assigned(FOnDebugPause) then
    begin
      SyncProg := Prog;
      SyncExpr := Expr;
      FDebuggerThread.Synchronize(CallDebugPause);
      FDebuggerThread.Suspend;
    end;
  end
  else
    application.ProcessMessages;
end;

procedure Tdws2ThreadedDebugger.EnterFunc(Prog: TProgram; Expr: TExpr);
begin
  CheckProgram(Prog);
  FCallStack.Push(TDebuggerStackFunc.Create(Expr as TFuncExpr));
end;

procedure Tdws2ThreadedDebugger.LeaveFunc(Prog: TProgram; Expr: TExpr);
begin
  CheckProgram(Prog);
  FCallStack.Pop.Free;

  // Check hit of "Running until return"
  if (FState = dsRunningUntilReturn) and (FCallStack.Count < FRunningUntilReturnStackLevel) then
    FState := dsSteppingInto;
end;

procedure Tdws2ThreadedDebugger.StartDebug(MainProg: TProgram);
begin
  FProgramRoot := MainProg;
  // Don't set State to dsRunning. It must be initialized by methods
  // (Run, StepInto, StepOver, etc.)

  FLastStopExpr := nil;
end;

procedure Tdws2ThreadedDebugger.StopDebug(MainProg: TProgram);
begin
  FState := dsStopped;
  FProgramRoot := nil;
  FLastStopExpr := nil;
end;

function Tdws2ThreadedDebugger.CanModifyLastEvaluated: Boolean;
begin
  // Return TRUE if the last evaluated expression can be modified
  Result := (FLastEvaluatedExpr <> nil) and
            (FLastEvaluatedExpr is TDataExpr) and
            (FLastEvaluatedExpr as TDataExpr).IsWritable;
end;

procedure Tdws2ThreadedDebugger.ClearAllBreakpoints;
begin
  FBreakpoints.Size := 0;
  FBreakpoints.Size := BREAKPOINTS_ARRAY_INITIAL_SIZE;
end;

procedure Tdws2ThreadedDebugger.ClearAllStatements;
begin
  FStatements.Size := 0;
  FStatements.Size := STATEMENTS_ARRAY_INITIAL_SIZE;
end;

function Tdws2ThreadedDebugger.Evaluate(AExpression: string): string;
begin
  // Evaluate 'AExpression' in context of FLastStopExpr.
  // Save the resulting Expr in FLastEvaluatedExpr (for Modify)
  try
    if FLastEvaluatedExpr <> nil then
      FreeAndNil(FLastEvaluatedExpr);

    FLastEvaluatedExpr := Tdws2Compiler.Evaluate(FLastStopExpr.Prog, AExpression);
    Result := ExprToString(FLastEvaluatedExpr);
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

type
  TStackHack = class(TStack);

procedure Tdws2ThreadedDebugger.GetCallStack(AItems: TStrings);
var
  i: Integer;
  DebuggerStackFunc: TDebuggerStackFunc;
begin
  // Return current call stack state formatted as string
  AItems.BeginUpdate;
  try
    AItems.Clear;
    for i := FCallStack.Count - 1 downto 0 do
    begin
      DebuggerStackFunc := TDebuggerStackFunc(TStackHack(FCallStack).List.Items[i]);
      AItems.AddObject(DebuggerStackFunc.DisplayText, DebuggerStackFunc.FFunc);
    end;
  finally
    AItems.EndUpdate;
  end;
end;

procedure Tdws2ThreadedDebugger.ModifyLastEvaluated(ANewValue: string);
var
  NewValueExpr: TExpr;
begin
  // Modify the value of last expression evaluated by Evaluate()
  if CanModifyLastEvaluated then
  begin
    NewValueExpr := TDws2Compiler.Evaluate(FLastStopExpr.Prog, ANewValue);
    try
      (FLastEvaluatedExpr as TDataExpr).AssignExpr(NewValueExpr);
    finally
      NewValueExpr.Free;
    end;
  end;
end;

procedure Tdws2ThreadedDebugger.Pause;
begin
  if InDebugSession then
    FWantPause := True;
end;

procedure Tdws2ThreadedDebugger.Prepare(AProgram: TProgram);
begin
  // Start the debugger engine leaving it in suspended state
  if (not InDebugSession) and
     (AProgram <> nil) and
     (not AProgram.Msgs.HasErrors) and
     (not AProgram.Msgs.HasCompilerErrors) then
  begin
    AProgram.Debugger := Self;
    FDebuggerThread := Tdws2DebuggerThread.Create(AProgram);
    FDebuggerThread.OnTerminate := DebuggerThreadTerminate;
  end;
end;

procedure Tdws2ThreadedDebugger.Reset;
begin
  if InDebugSession then
  begin
    FDebuggerThread.Terminate;           // Ask thread to terminate
    if FDebuggerThread.Suspended then
      FDebuggerThread.Resume;              // If paused, resume to terminate

    // Wait for thread finish
    try
      FDebuggerThread.WaitFor;
    except
      // Sometimes WaitFor can raise an "Handle is invalid" error
      // (thread was already finished)
    end;
  end;
end;

procedure Tdws2ThreadedDebugger.Run;
begin
  if InDebugSession then
  begin
    FState := dsRunning;
    DoDebugResume;
  end;
end;

procedure Tdws2ThreadedDebugger.RunToLine(ALine: Integer);
begin
  if InDebugSession then
  begin
    FRunningToLine := ALine;
    FState := dsRunningToLine;
    DoDebugResume;
  end;
end;

procedure Tdws2ThreadedDebugger.RunUntilReturn;
begin
  if InDebugSession then
  begin
    FRunningUntilReturnStackLevel := FCallStack.Count;
    FState := dsRunningUntilReturn;
    DoDebugResume;
  end;
end;

procedure Tdws2ThreadedDebugger.ScanStatements(AProgram: TProgram);
begin
  // To do: How discover what lines contains executable code?
  ClearAllStatements;
end;

procedure Tdws2ThreadedDebugger.StepInto;
begin
  if InDebugSession then
  begin
    FState := dsSteppingInto;
    DoDebugResume;
  end;
end;

procedure Tdws2ThreadedDebugger.StepOver;
begin
  if InDebugSession then
  begin
    FStepOverStackLevel := FCallStack.Count;
    FState := dsSteppingOver;
    DoDebugResume;
  end;
end;

procedure Tdws2ThreadedDebugger.ToggleBreakpoint(ALine: Integer);
begin
  Breakpoint[ALine] := not Breakpoint[ALine];
end;


// - Pietro
// -------------------------------------------------------------------
// use this procedure to set a procedure name and parameters
// to call
// -------------------------------------------------------------------
procedure Tdws2ThreadedDebugger.SetProcedureName(procName: string;
  const Params: array of variant);
var
  i: integer;
begin
  FDebuggerThread.FProcName := procName;
  FDebuggerThread.FRes := nil;
  if high(Params) >= 0 then
  begin
    SetLength(FDebuggerThread.FProcParams, Length(Params));
    for i:= low(Params) to high(Params) do
      FDebuggerThread.FProcParams[i] := Params[i];
  end;
end;

// -------------------------------------------------------------------
// Set procedure name to ''
// -------------------------------------------------------------------
procedure Tdws2ThreadedDebugger.ClearProcedureName;
begin
  FDebuggerThread.FProcName := '';
  FDebuggerThread.FRes := nil;
  SetLength(FDebuggerThread.FProcParams, 0);
end;

// -------------------------------------------------------------------
// Get the result of an execution call
// -------------------------------------------------------------------
function Tdws2ThreadedDebugger.GetExecuteCallResult: variant;
begin
  result := FExecuteCallResult;
end;

end.

