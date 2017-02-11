
ILFScriptEngine - Version: 1.1 - (18-03-2003)

A Delphi component to embed a DelphiWebScriptII development environement
Its aim is to allow you to easily embed a DelphiWebScriptII development environement into your applications, something similar to VBA in Office applications. It should be able to wrap the DWS component in most occasions.
------------------------------------------------------------------------------------------

--------------------------------
Methods
--------------------------------
- Function Compile: boolean;
      	Compiles the DWS program. Returns False if compile fails.

- procedure reset;
	Resets the current program. 
	There are two reset method, depending on the the 'ForceRecompile' parameter
	- true		reset the current program execution and set to nil the FProgram variable. 
			In this case, the next execution need to recompile the program
	- false	(def.)	reset the current program execution but let the FProgram variable unchanged.
			In this case, the next execution does not need a recompilation

- Procedure openIde;
      	Opensthe IDE. Needs DebugMode=True

- procedure execute; overload;
      	Executes the entire program.
      	with DebugMode=False : simply wraps a DWS "Execute" call
      	with DebugMode=True  : executes the program within a thread and use the debugger.
                             if a Runtime error occurs, opens the IDE and showing the error

- function Execute(const sFunctionName: string): Variant; overload;
- function Execute(const sFunctionName: string; Params: array of Variant): Variant; overload;
      	Executes a function Call.
      	with DebugMode=False : simply wraps a DWS "Info.Func[sFunctionName].Call(Params)" call
      	with DebugMode=True  : executes the function within a thread and use the debugger.
                             if a Runtime error occurs, opens the IDE and showing the error
- function executeCommand(const commandText): variant;
	use this function if you need to execute a command (function) where
	it is required to do a parsing of parameters
	If an error occourred during parsing, the function raise a
	'Compiler' error.

- continue;
	Continue execution (meaningful only in debugMode)

- pause;
	Pause execution of the script (meaningful only in debugMode)

- stepInto;
	Step into (meaningful only in debugMode)

- stepOver;
	Step over (meaningful only in debugMode)

- runToLine;
	Run to line (meaningful only in debugMode)

- runUntilReturn;
	Run until retunr (meaningful only in debugMode)


--------------------------------
list of property
--------------------------------
- debugMode;
      	if False ILFScriptEngine is just a wrapper to DWS component. 
               No debug, no IDE. 
               DWS compiler optimizations are enabled.
      	if True  The code is always executed within a thread and the debugger is active.
               IDE can work and RunTime errors are intercepted and debugged.
               DWS compiler optimizations are disabled (they hurt the debugger)
- script;
	The script to execute

- scriptEngine;
      	Link to the DWS component.

- EditorHighLigher;
      	Link to the Synedit Highlighter that you want to use inside the IDE

- version;
	Version info
	
- inDebugSession
	true	if DebugMode is true and the script is in execution. 
		True also if debugger in in pause
	false	otherwise

- inDebugPause
	true	if debugMode is true and the debugger is in pause
	false	otherwise


--------------------------------
list of event
--------------------------------
- onEditorClose;
      	Occurs when the IDE is closing

- onError;
      Occurs when DWS find an error (Internal, Syntax or Runtime)

- onScriptSaved;
      	Occurs when the user saves the script through the IDE or calling the DoSaveScript procedure.
      	The script is passed as a parameter. 
      	It is not automatically saved on disk. To do this through the IDE, use "File|Export"



--------------------------------
Whats news from version 0.84
--------------------------------

Modification on ILFScriptEngine
- Work with release DSWIII 1.2
- work with new TThreadedDebugger rel 1.2
- Despict of the name, the TThreadedDebugger works with fibers and not with Thread (see also dws2ThreadedDebugger.txt)
- The event 'OnUnHandledException' is no more available. With current version all the events are handled by the 'OnError' 
- some events (ThreadRunnerFinished, ThreadRunnerRunTimeError, ThreadRunnerUnHandledException) used in the previous version to catch result values and error are no more needed. They are all handled directly by the fm_editor.
- fix a bug during debug evaluation of variables. IN the previous version the evaluation did not work properly in procedures called inside other procedures (stack level > 1).


Modifications on TDws2DebuggerThread
- added three properties in order to handle function call
* FProcName, name of the procedure/function to call
* FProcParams, list of parameters required by the procName
* FRes, result of the procedure call
- Redefinition of the Execute method in order to handle procedure call
- Definition of two methods
* ExecuteEntireProgram, execute the entire program
* ExecuteProcedureCall, execute a procedure call


Modification on Tdws2ThreadedDebugger
- The unit dws2Compiler.pas has been modified by Fabio Augusto Dal Castel in order to introduce the class function Evaluate, for evaluation of variable during debugger. In order to avoid the modification of the base DWSII unit dws2Compiler.pas, the modified unit is placed in the same directory of the Tdws2ThreadedDebugger and called dws2CompilerBeta.pas
- SetProcedureName, set procedure/function name and parameters to execute
- GetExecuteCallResult, get the result of a procedure/function call
- modification on procedure DebuggerThreadTerminate in order to get the result of a procedure call

IMPORTANT:
To successfully compile ILFScriptEngine, you need to previously install 
- SynEdit (http://synedit.sourceforge.net) and 
- DelphiWebScriptII 1.2 (http://www.dwscript.com).


This code is most likely not bug free, suggestions and bug fixes are always welcome

TO CONTACT US:
---------------
Albini & Fontanot Informatica S.r.l.
Email: pietro@aflabs.it
       


-------------------------------------------------------------------------------
Version: 0.84 - (11-21-2002)

MODIFICATIONS ON DWS2IDE (Fabio Augusto Dal Castel) UNITS:

* frm_Editor.pas:
Moved most of the DWS related code from this unit to the component ILFScriptEngine.pas
Added some code to interact with the component
Addes some functionalities: Input/Output console with Immediate Eval, ToolTip Insight, 
a primitive CodeTree (it will be rewritten), ability to 

* dws2ThreadRunner.pas
Added some code to allow the debugging of Calls, to allow a clean reset, to trap runtime errors.
Added CoInizialize/CoUnInizialize in the TThreadRunner.Execute.

* dws2NotSoSimpleDebugger.pas
Just two very little bugfixes:
---   
  procedure Tdws2NotSoSimpleDebugger.CheckStatementsSize(ASize: Integer);
  begin
    if FStatements.Size <= ASize then     // it was  FStatements.Size < ASize then
      FStatements.Size := ASize * 2;
  end;

  procedure Tdws2NotSoSimpleDebugger.CheckBreakpointsSize(ASize: Integer);
  begin
    if FBreakpoints.Size <= ASize then    // it was  FBreakpoints.Size < ASize then
      FBreakpoints.Size := ASize * 2;
  end;
---
* frm_EditorCallStack.pas, frm_EditorConfirmReplace.pas,
  frm_EditorEvaluate.pas, frm_EditorReplace.pas, frm_EditorSearch.pas:
Untouched.

