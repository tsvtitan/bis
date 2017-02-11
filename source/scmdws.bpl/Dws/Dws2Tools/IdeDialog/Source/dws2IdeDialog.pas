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
{    The Original Code is dws2IdeDialog source code, released May 2003 }
{                                                                      }
{    The Initial Developer of the Original Code is Pietro Barbaro      }
{    Portions created by Pietro Barbaro are Copyright (C) 2003         }
{    Pietro Barbaro. All Rights Reserved.                              }
{                                                                      }
{    Contributors: Mark Ericksen                                       }
{                                                                      }
{**********************************************************************}

unit dws2IdeDialog;

interface

uses
  Forms, Windows, Messages, Dialogs, SysUtils, Classes, Graphics, Controls,
  {$IFDEF NEWVARIANTS}
  Variants,
  {$ENDIF}
  SynEditHighlighter,
  dws2Comp, dws2Compiler, dws2Exprs, dws2Errors, dws2Symbols, frm_Editor,
  dwsIDETypes;

type
  TOnErrorEvent = procedure(Sender: TObject; ErrType: TErrType; ErrString: string) of object;
  TOnEditorClose = procedure(Sender: TObject; var CanClose: boolean) of object;
//  TOnUnHandledException = procedure(Sender: TObject; E: Exception) of object;
  TOnScriptLoadEvent = procedure(Sender: TObject; var ScriptName: string; const AScript: TStrings; var AReadOnly, IsAFileName, WasLoaded: Boolean) of object;
  TOnScriptSaveEvent = procedure(Sender: TObject; const ScriptName: string; const AScript: TStrings) of object;
  TOnScriptSaveAsEvent = procedure(Sender: TObject; var ScriptName: string; const AScript: TStrings; var WasSaved: Boolean) of object;

type
  Tdws2IdeDialog = class(TComponent, IExternalScriptHandler, IExternalOptionSetter)
  private
    FFrmEditor: TFrmEditor;
    FEditorFont: TFont;
    FOptions: TEditorOptions;
    FScriptEngine: TDelphiWebScriptII;
    FDebugMode: Boolean;
    FHighlighter: TSynCustomHighlighter;
    FCEAlign: TAlign;
    FScript: TStrings;
    FTitle: string;
    FHintPropDelay: Integer;
    FParamPropDelay: Integer;
    FCodePropDelay: Integer;

    FOnCloseQuery: TCloseQueryEvent;
    FOnError: TOnErrorEvent;
    FOnLoadScript: TOnScriptLoadEvent;
    FOnSaveAsScript: TOnScriptSaveAsEvent;
    FOnSaveScript: TOnScriptSaveEvent;
    FOnCloseEditor: TNotifyEvent;
    FOnOpenEditor: TNotifyEvent;
    FOnShowAboutBox: TNotifyEvent;
    FOnShowHelp: TNotifyEvent;

    function GetVersion: string;
    procedure SetScript(const Value: TStrings);
    procedure SetVersion(const Value: string);
    function GetInDebugPause: boolean;
    function GetInDebugSession: boolean;
    procedure SetEditorFont(const Value: TFont);
  protected
    { IExternalScriptHandler support methods }
    procedure FetchInitialScript(const AScript: TStrings);
    function GetDWScript: TDelphiWebScriptII;
    function LoadScript(var ScriptName: string; AScript: TStrings; var AReadOnly, IsAFileName: Boolean): Boolean;
    procedure SaveScript(const ScriptName: string; AScript: TStrings);
    function SaveScriptAs(var ScriptName: string; AScript: TStrings): Boolean;
    function  HandleError(ErrType: TErrType; ErrString: string): Boolean;
    procedure EditorOpen;
    function  EditorCanClose: Boolean;
    procedure EditorClose;
    function ShowAboutBox: Boolean;
    function ShowHelp: Boolean;
    { IExternalOptionSetter support methods }
    function GetOptions: TEditorOptions;
    function GetCodeExplorerAlignment: TAlign;
    function GetTimerSettings: TTimerDelaySettings;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure PrepareIDE;
    procedure OpenIDE;
    function Compile: boolean;
    // Execute entire program
    procedure Execute; overload;
    // Execute a Call
    function Execute(const sFunctionName: string): Variant; overload;
    function Execute(const sFunctionName: string; const Params: array of Variant): Variant; overload;
    function ExecuteCommand(const CommandText: string): Variant;
    procedure Continue;
    procedure Pause;
    procedure StepInto;
    procedure StepOver;
    procedure RunToLine(Line: integer);
    procedure RunUntilReturn;
    procedure Reset(ForceRecompile: boolean = false);

    property InDebugSession: boolean read GetInDebugSession;
    property InDebugPause: boolean read GetInDebugPause;
  published
    // DebugMode: if True use the debugger and open IDE on RunTime Errors
    property DebugMode: Boolean read FDebugMode write FDebugMode;
    // Script: the script to be interpreted
    property Script: TStrings read FScript write SetScript;
    // ScriptEngine: The DWS2 Component
    property ScriptEngine: TDelphiWebScriptII
      read FScriptEngine write FScriptEngine;
    // EditorHighLighter: SynEdit highlighter for the IDE
    property EditorHighLighter: TSynCustomHighlighter
      read FHighlighter write FHighlighter;
    // Version: TILFScriptEngine current Version
    property Version: string read getVersion write setVersion stored False;
    property Options: TEditorOptions read FOptions write FOptions default [eoAllowNew, eoAllowOpen, eoAllowSave, eoAllowSaveAs];
    property EditorFont: TFont read FEditorFont write SetEditorFont;
    property CodeExplorerAlignment: TAlign read FCEAlign write FCEAlign default alLeft;
    property Title: string read FTitle write FTitle;
    property DelayOnCodeProposal: Integer read FCodePropDelay write FCodePropDelay default 500;
    property DelayOnHintProposal: Integer read FHintPropDelay write FHintPropDelay default 500;
    property DelayOnParamProposal: Integer read FParamPropDelay write FParamPropDelay default 500;

    { EVENTS }

    // Event OnScriptLoad: If assigned then user is resposible for loading the script
    property OnLoadScript: TOnScriptLoadEvent
      read FOnLoadScript write FOnLoadScript;
    // Event OnScriptSave: If assigned then user is resposible for saving the script
    property OnSaveScript: TOnScriptSaveEvent
      read FOnSaveScript write FOnSaveScript;
    // Event OnScriptSaveAs: Fires when a script is being saved to another name
    property OnSaveAsScript: TOnScriptSaveAsEvent
      read FOnSaveAsScript write FOnSaveAsScript;
    // Event OnError: An error was found by DWS
    property OnError: TOnErrorEvent
      read FOnError write FOnError;
    // Event OnOpen: When the IDE form is openned
    property OnOpenEditor: TNotifyEvent
      read FOnOpenEditor write FOnOpenEditor;
    // Event OnCloseQuery: Determine if the IDE form can close
    property OnCloseQuery: TCloseQueryEvent
      read FOnCloseQuery write FOnCloseQuery;
    // Event OnClose: When the IDE form is closed
    property OnCloseEditor: TNotifyEvent
      read FOnCloseEditor write FOnCloseEditor;
    // Event OnShowAboutBox: Fires when user hit's about button
    property OnShowAboutBox: TNotifyEvent
      read FOnShowAboutBox write FOnShowAboutBox;
    // Event OnShowHelp: Fires when a user hits the "help" menu item
    property OnShowHelp: TNotifyEvent
      read FOnShowHelp write FOnShowHelp;
  end;

implementation

{ Tdws2IdeDialog }

function Tdws2IdeDialog.getVersion: string;
begin
  Result := '2.0';
end;

procedure Tdws2IdeDialog.setVersion(const Value: string);
begin
  // don't do anything (show as published but not editable)
end;

constructor Tdws2IdeDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScript := TStringList.Create;
  FOptions := [eoAllowNew, eoAllowOpen, eoAllowSave, eoAllowSaveAs];
  FCEAlign := alLeft;
  FEditorFont := TFont.Create;
  FEditorFont.Name := 'Courier New';   // set default font properties
  FEditorFont.Size := 9;
  FTitle := 'Script Editor';
  FHintPropDelay := 500;
  FParamPropDelay := 500;
  FCodePropDelay := 500;
end;

destructor Tdws2IdeDialog.Destroy;
begin
  FEditorFont.Free;
  FreeAndNil(FFrmEditor);     // only frees if assigned
  FScript.Free;
  inherited Destroy;
end;

function Tdws2IdeDialog.Compile: boolean;
begin
  PrepareIDE;
  result := FFrmEditor.Compile;
end;

procedure Tdws2IdeDialog.Reset(ForceRecompile: boolean = false);
begin
  PrepareIDE;
  FFrmEditor.Reset(ForceRecompile);
end;

procedure Tdws2IdeDialog.Execute;
begin
  PrepareIDE;
  FFrmEditor.Execute;
end;

function Tdws2IdeDialog.Execute(const sFunctionName: string): Variant;
begin
  Result := Execute(sFunctionName, []);
end;

function Tdws2IdeDialog.Execute(const sFunctionName: string; const Params: array of Variant): Variant;
begin
  PrepareIDE;
  Result := FFrmEditor.Execute(sFunctionName, params);
end;

function Tdws2IdeDialog.ExecuteCommand(const commandText: string): Variant;
begin
  PrepareIDE;
  Result := FFrmEditor.ExecuteCommand(commandText);
end;

procedure Tdws2IdeDialog.PrepareIDE;
begin
  if not Assigned(FScriptEngine) then
    raise Exception.Create('Not attached to a TDelphiWebScriptII component.');
  // create editor if not already created
  if not Assigned(FFrmEditor) then
    FFrmEditor := TfrmEditor.Create(nil, self, self);

  FFrmEditor.PrepareIDE;
  FFrmEditor.Title := FTitle;
  FFrmEditor.DebugMode := FDebugMode;
  FFrmEditor.SynEdit.Font := FEditorFont;
  if (FFrmEditor.SynEdit.Highlighter = nil) then
    FFrmEditor.SynEdit.Highlighter := EditorHighLighter;
end;

procedure Tdws2IdeDialog.OpenIDE;
begin
  PrepareIDE;
  FFrmEditor.OpenIDE;
end;

procedure Tdws2IdeDialog.SetScript(const Value: TStrings);
begin
  FScript.Assign(Value);
end;

procedure Tdws2IdeDialog.StepInto;
begin
  PrepareIDE;
  FFrmEditor.stepInto;
end;

procedure Tdws2IdeDialog.StepOver;
begin
  PrepareIDE;
  FFrmEditor.stepOver;
end;

procedure Tdws2IdeDialog.RunToLine(Line: integer);
begin
  PrepareIDE;
  FFrmEditor.RunToLine(Line);
end;

procedure Tdws2IdeDialog.RunUntilReturn;
begin
  PrepareIDE;
  FFrmEditor.runUntilReturn;
end;

procedure Tdws2IdeDialog.Pause;
begin
  PrepareIDE;
  FFrmEditor.pause;
end;

procedure Tdws2IdeDialog.Continue;
begin
  PrepareIDE;
  FFrmEditor.continue;
end;

function Tdws2IdeDialog.GetInDebugPause: boolean;
begin
  if Assigned(FFrmEditor) then
    result := FFrmEditor.InDebugPause
  else
    result := False;
end;

function Tdws2IdeDialog.GetInDebugSession: boolean;
begin
  if Assigned(FFrmEditor) then
    result := FFrmEditor.InDebugSession
  else
    result := False;
end;

function Tdws2IdeDialog.GetDWScript: TDelphiWebScriptII;
begin
  Result := FScriptEngine;
end;

function Tdws2IdeDialog.GetOptions: TEditorOptions;
begin
  Result := FOptions;
end;

function Tdws2IdeDialog.LoadScript(var ScriptName: string;
  AScript: TStrings; var AReadOnly, IsAFileName: Boolean): Boolean;
begin
  Result := False;  // default to not loaded
  if Assigned(FOnLoadScript) then
    FOnLoadScript(Self, ScriptName, AScript, AReadOnly, IsAFileName, Result);
  // when loaded store the script in component Script property
  if Result then
    FScript.Assign(AScript);
end;

procedure Tdws2IdeDialog.SaveScript(const ScriptName: string;
  AScript: TStrings);
begin
  if Assigned(FOnSaveScript) then
  begin
    FOnSaveScript(Self, ScriptName, AScript);
    // store the saved script in component Script property
    FScript.Assign(AScript);
  end;
end;

function Tdws2IdeDialog.SaveScriptAs(var ScriptName: string;
  AScript: TStrings): Boolean;
begin
  Result := False;   // default to not saved
  if Assigned(FOnSaveAsScript) then
  begin
    FOnSaveAsScript(Self, ScriptName, AScript, Result);
    // if saved, store the loaded script in component Script property
    if Result then
      FScript.Assign(AScript);
  end;
end;

function Tdws2IdeDialog.EditorCanClose: Boolean;
begin
  Result := True;
  if Assigned(FOnCloseQuery) then
    FOnCloseQuery(Self, Result);
end;

function Tdws2IdeDialog.HandleError(ErrType: TErrType; ErrString: string): Boolean;
begin
  if Assigned(FOnError) then
  begin
    Result := True;
    FOnError(Self, ErrType, ErrString);
  end
  else
    Result := False;
end;

procedure Tdws2IdeDialog.EditorClose;
begin
  if Assigned(FOnCloseEditor) then
    FOnCloseEditor(Self);
end;

procedure Tdws2IdeDialog.EditorOpen;
begin
  if Assigned(FOnOpenEditor) then
    FOnOpenEditor(Self);
end;

function Tdws2IdeDialog.GetCodeExplorerAlignment: TAlign;
begin
  Result := FCEAlign;
end;

procedure Tdws2IdeDialog.FetchInitialScript(const AScript: TStrings);
begin
  // when an initial script is requested. Return the script in the component
  AScript.Assign(FScript);
end;

function Tdws2IdeDialog.ShowAboutBox: Boolean;
begin
  Result := False;
  if Assigned(FOnShowAboutBox) then
  begin
    FOnShowAboutBox(Self);
    Result := True;
  end;
end;

function Tdws2IdeDialog.ShowHelp: Boolean;
begin
  Result := False;
  if Assigned(FOnShowHelp) then
  begin
    FOnShowHelp(Self);
    Result := True;
  end;
end;

procedure Tdws2IdeDialog.SetEditorFont(const Value: TFont);
begin
  FEditorFont.Assign(Value);
end;

function Tdws2IdeDialog.GetTimerSettings: TTimerDelaySettings;
begin
  Result.CodeProposal := FCodePropDelay;
  Result.HintProposal := FHintPropDelay;
  Result.ParamProposal := FParamPropDelay;
end;

end.
