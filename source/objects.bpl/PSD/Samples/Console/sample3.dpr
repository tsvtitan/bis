program sample3;

uses
  uPSC_dll,
  uPSR_dll,
  uPSCompiler,
  uPSRuntime;
  
function ScriptOnUses(Sender: TPSPascalCompiler; const Name: string): Boolean;
{ the OnUses callback function is called for each "uses" in the script. 
  It's always called with the parameter 'SYSTEM' at the top of the script. 
  For example: uses ii1, ii2;   
  This will call this function 3 times. First with 'SYSTEM' then 'II1' and then 'II2'.
}
begin
  if Name = 'SYSTEM' then begin
    Sender.OnExternalProc := @DllExternalProc;
    { Assign the dll library to the script engine. This function can be found in the uPSC_dll.pas file.
      When you have assigned this, it's possible to do this in the script:
    
        Function FindWindow(c1, c2: PChar): Cardinal; external 'FindWindow@user32.dll stdcall';
        
        The syntax for the external string is 'functionname@dllname callingconvention'.
    }

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
begin
  Compiler := TPSPascalCompiler.Create;      // create an instance of the compiler.
  Compiler.OnUses := ScriptOnUses;           // assign the OnUses event.
  if not Compiler.Compile(Script) then begin // Compile the Pascal script into bytecode.
    Compiler.Free;
     // You could raise an exception here.
    Exit;
  end;

  Compiler.GetOutput(Data); // Save the output of the compiler in the string Data.
  Compiler.Free;            // After compiling the script, there is no further need for the compiler.

  Exec := TPSExec.Create;   // Create an instance of the executer.

  RegisterDLLRuntime(Exec);
  { Register the DLL runtime library. This can be found in the uPSR_dll.pas file.}

  if not  Exec.LoadData(Data) then begin // Load the data from the Data string.
    { For some reason the script could not be loaded. This is usually the case when a
      library that has been used at compile time isn't registered at runtime. }
    Exec.Free;
     // You could raise an exception here.
    Exit;
  end;

  Exec.RunScript; // Run the script.
  Exec.Free;      // Free the executer.
end;


const
  Script =
    'function MessageBox(hWnd: Longint; lpText, lpCaption: PChar; uType: Longint): Longint; external ''MessageBoxA@user32.dll stdcall'';'#13#10 +
    'var s: string; begin s := ''Test''; MessageBox(0, s, ''Caption Here!'', 0);end.';

begin
  ExecuteScript(Script);
end.
