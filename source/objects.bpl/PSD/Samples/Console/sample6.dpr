program sample6;

uses
  uPSCompiler,
  uPSUtils,
  uPSRuntime,

  Dialogs

  ;

procedure MyOwnFunction(const Data: string);
begin
  // Do something with Data
  ShowMessage(Data);
end;

function ScriptOnExportCheck(Sender: TPSPascalCompiler; Proc: TPSInternalProcedure; const ProcDecl: string): Boolean;
{
  The OnExportCheck callback function is called for each function in the script
  (also for the main proc, with '!MAIN' as a Proc^.Name). ProcDecl contains the
  function's result type and parameter types using this format:
  ProcDecl: ResultType + ' ' + Parameter1 + ' ' + Parameter2 + ' '+Parameter3 + .....
  Parameter: ParameterType+TypeName
  ParameterType is @ for a normal parameter and ! for a var parameter.
  A result type of 0 means no result.
}
begin
  if Proc.Name = 'TEST' then begin // Check if the proc is the Test proc we want.
    // Check if the proc has the correct params.
    if not ExportCheck(Sender, Proc, [0, btString], [pmIn]) then begin
      { Something is wrong, so cause an error at the declaration position of the proc. }
      Sender.MakeError('', ecTypeMismatch, '');
      Result := False;
      Exit;
    end;
    Result := True;
  end else Result := True;
end;

function ScriptOnUses(Sender: TPSPascalCompiler; const Name: string): Boolean;
{ the OnUses callback function is called for each "uses" in the script.
  It's always called with the parameter 'SYSTEM' at the top of the script. 
  For example: uses ii1, ii2;   
  This will call this function 3 times. First with 'SYSTEM' then 'II1' and then 'II2'.
}
begin
  if Name = 'SYSTEM' then begin
    Sender.AddDelphiFunction('procedure MyOwnFunction(Data: string)');
    { This will register the function to the script engine.
      Now it can be used from within the script. }

    Result := True;
  end else
    Result := False;
end;

procedure ExecuteScript(const Script: string);
var
  Compiler: TPSPascalCompiler;
  { TPSPascalCompiler is the compiler part of the script engine. This will
    translate a Pascal script into compiled data for the executer. }
  Exec: TPSExec;
   { TPSExec is the executer part of the script engine. It uses the output of
    the compiler to run a script. }
  Data: string;

  N: PIfVariant;      // the variant in which we are going to store the parameter
  ParamList: TIfList; // the parameter list
begin
  Compiler := TPSPascalCompiler.Create; // create an instance of the compiler.
  Compiler.OnUses := ScriptOnUses;      // assign the OnUses event.

  Compiler.OnExportCheck := ScriptOnExportCheck; // Assign the onExportCheck event.

  if not Compiler.Compile(Script) then begin // Compile the Pascal script into bytecode.
    Compiler.Free;
     // You could raise an exception here.
    Exit;
  end;

  Compiler.GetOutput(Data); // Save the output of the compiler in the string Data.
  Compiler.Free;            // After compiling the script, there is no further need for the compiler.

  Exec := TPSExec.Create;   // Create an instance of the executer.

  Exec.RegisterDelphiFunction(@MyOwnFunction, 'MYOWNFUNCTION', cdRegister);
  { This will register the function to the executer. The first parameter is the executer.
    The second parameter is a pointer to the function.
    The third parameter is the name of the function (in uppercase).
    The last parameter is the calling convention (usually Register). }

  if not Exec.LoadData(Data) then begin // Load the data from the Data string.
    { For some reason the script could not be loaded. This is usually the case when a
      library that has been used at compile time isn't registered at runtime. }
    Exec.Free;
     // You could raise an exception here.
    Exit;
  end;

  ParamList := TIfList.Create; // Create the parameter list

  N := CreateHeapVariant(Exec.FindType2(btString)); // create a variant for the string parameter 
  if n = nil then begin
    { Something is wrong. Exit here }
    ParamList.Free;
    Exec.Free;
    Exit;
  end;
  VSetString(n, 'Test Parameter!');
  // Put something in the string parameter.

  ParamList.Add(n); // Add it to the parameter list.

  Exec.RunProc(ParamList, Exec.GetProc('TEST'));
  { This will call the test proc that was exported before }

  FreePIFVariantList(ParamList); // Cleanup the parameters (This will also free N)

  Exec.Free; // Free the executer.
end;



const
  Script = 'procedure test(s: string); begin MyOwnFunction(''Test is called: ''+s);end; begin end.';

begin
  ExecuteScript(Script);
end.
