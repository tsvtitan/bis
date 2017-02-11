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
{    January 28, 2003                                                  }
{                                                                      }
{    The Initial Developer of the Original Code is Mark Ericksen.      }
{    Portions created by Mark Ericksen Copyright (C) 2002, 2003        }
{    Mark Ericksen, United States of America.                          }
{    Rights Reserved.                                                  }
{                                                                      }
{    Contributor(s):                                                   }
{                                                                      }
{**********************************************************************}

{$I dws2.inc}

{ This code is based on the example code for creating and assigning event
  handlers at design-time in Delphi 5/6.
  Originally Created March, 2001 by Erik Berry <eberry@gexperts.org> }
unit CreateDWSEval;

interface

{ NOTE: dws2Symbols must be declared *after* TypeInfo. They both have a
        TMethodType types defined and the compiler can get confused.}
uses SysUtils, Classes, Windows, ToolsApi, dws2Comp, TypInfo, dws2Symbols,
  dws2Exprs,
{$IFDEF DELPHI6up}
  DesignIntf,
{$ELSE}
  DsgnIntf,   // Delphi 5-
{$ENDIF}
  SourceParserTree, dws2PasGenerator;

type
  Tdws2OTACreateDWSOnEval = class(TNotifierObject, IOTAWizard)
  protected
    FParser: TSourceParserTree;               // only created when Initialized
    FCodeGenerator: Tdws2PascalCodeGenerator; // only created when Initialized
    procedure Execute;
    function FuncEventUpdate(UnitFunc: Tdws2Function; AFuncSym: TFuncSymbol;
                             const Editor: IOTASourceEditor;
                             const View: IOTAEditView; const OwningFormName: string;
                             IsNew: Boolean; const FuncEventName: string;
                             CodeOptions: TCodeGenOptions;
                             const WrappedType, VarPrefix: string): Boolean;
  public
    procedure Initialize;
    procedure Finalize;
    //
    procedure CreateEvalEvent(AProgram: TProgram; const AUnitName: string;
                  AFuncSym: TFuncSymbol; UnitFunc: Tdws2Function;
                  CodeOpts: TCodeGenOptions;
                  const WrappedType, VarPrefix: string);
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
  end;

resourcestring
  resClassParamID  = '%s_Id';
  resClassParamObj = '%s_Obj';
  resVarDeclStmt   = '  %s: %s;';        // variable declaration statement
  resResult_Array  = 'Result_Array';     // intermediate variable name for array result
  resResult_Obj    = 'Result_Obj';       // intermediate variable name for object result
  resResult_Rec    = 'Result_Rec';    // return record value

procedure Register;

var CreateEvalCode: Tdws2OTACreateDWSOnEval;

implementation

uses
  dws2UnitUtils, OTASourceTreeUtil, dws2IDEUtils;

type
  {$IFDEF VER130}
  FormDesignerInterface = IFormDesigner; // Delphi 5
  {$ELSE not VER130}
  FormDesignerInterface = IDesigner;     // Delphi 6+
  {$ENDIF}

procedure Register;
begin
  CreateEvalCode := Tdws2OTACreateDWSOnEval.Create;
  RegisterPackageWizard(CreateEvalCode);
end;

const
  DWS_VarDecl        = 'DWS_VarDecl';
  DWS_ScriptCall     = 'DWS_ScriptCall';
  DWS_VarAssign      = 'DWS_VarAssign';
  DWS_VarRevAssign   = 'DWS_VarRevAssign';

  DWS_VarDecl_START      : string = '{'+DWS_VarDecl+'}';
  DWS_VarDecl_STOP       : string = '{/'+DWS_VarDecl+'}';
  DWS_ScriptCall_START   : string = '{'+DWS_ScriptCall;     // no trailing '}'
  DWS_ScriptCall_STOP    : string = '/'+DWS_ScriptCall+'}'; // no leading '{'
  DWS_VarAssign_START    : string = '{'+DWS_VarAssign+'}';
  DWS_VarAssign_STOP     : string = '{/'+DWS_VarAssign+'}';
  DWS_VarRevAssign_START : string = '{'+DWS_VarRevAssign+'}';
  DWS_VarRevAssign_STOP  : string = '{/'+DWS_VarRevAssign+'}';

{ Convert boolean value to str (needed for multiple Delphi versions }
function BoolToStr(Value: Boolean): string;
begin
  if Value then
    Result := 'True'
  else
    Result := 'False';
end;

{ Local function - convert function kind to string }
function GetFuncKindName(Value: TFuncKind): string;
begin
  Result := GetEnumName(TypeInfo(TFuncKind), Integer(Value));
end;



{-----------------------------------------------------------------------------
  Procedure: InsertText
  Author:    Mark Ericksen
  Date:      09-Nov-2002
  Arguments: var AText: string; const StartWord, StopWord: string; InsertOption: TInsertTextType
  Result:    Boolean
  Purpose:   Insert text into the provided AText string. Option to insert
             between start and stop or replace them too. It returns if a change
             was made.
-----------------------------------------------------------------------------}
function InsertText(Strings: TStrings; const NewText, StartWord, StopWord: string; InsertOption: TInsertOption): Boolean;
var
  tmpString: string;
  StartPos, EndPos: Integer;
begin
  Result := False;
  tmpString := Strings.Text;
  // if the text is placed INSIDE the search words
  if InsertOption = ioPlaceInside then
  begin
    StartPos := Pos(StartWord, tmpString) + Length(StartWord);
    EndPos := Pos(StopWord, tmpString);
  end
  // if the text will REPLACE the search words
  else
  begin
    StartPos := Pos(StartWord, tmpString);
    EndPos := Pos(StopWord, tmpString) + Length(StopWord);
  end;
  // if found the position
  if (StartPos > 0) and (EndPos > 0) then
  begin
    Delete(tmpString, StartPos, EndPos-StartPos);
    Insert(NewText, tmpString, StartPos);
    Strings.Text := tmpString;    // write back the altered text
    Result := True;
  end;
end;

// Use to create a new method in the source and assign it to a TPersistent
procedure DoCreateMethod(FormDesigner: FormDesignerInterface; Persistent: TPersistent;
            MethodShortName, MethodSourceName: string; CreateNeeded: Boolean);
var
  Method: TMethod;
  PropInfo: PPropInfo;
  TypeInfo: PTypeInfo;
begin
  TypeInfo := PTypeInfo(Persistent.ClassInfo);
  PropInfo := GetPropInfo(TypeInfo, 'On' + MethodShortName); // Ex: MethodName := "Click"
//  if CreateNeeded then
//  begin
  Method := FormDesigner.CreateMethod(MethodSourceName, GetTypeData(PropInfo^.PropType^));
  SetMethodProp(Persistent, PropInfo, Method);
//  end
//  else
//  begin
//    // A rename doesn't work because the old Persistent object was freed and
//    // a new one created. It will never be hooked up to an existing event
//    Method := GetMethodProp(Persistent, PropInfo);
//    ShowMessage('Method name: '+FormDesigner.GetMethodName(Method));
//    FormDesigner.RenameMethod(FormDesigner.GetMethodName(Method), MethodSourceName);
//  end;
end;

function GetCurrentIdeModule: IOTAModule;
var
  ModuleServices: IOTAModuleServices;
begin
  ModuleServices := BorlandIDEServices as IOTAModuleServices;
  Assert(Assigned(ModuleServices));
  Result := ModuleServices.CurrentModule;
end;

function GetFormEditorFromModule(const Module: IOTAModule): IOTAFormEditor;
var
  i: Integer;
  Editor: IOTAEditor;
  FormEditor: IOTAFormEditor;
begin
  Result := nil;
  if not Assigned(Module) then
    Exit;
  for i := 0 to Module.GetModuleFileCount-1 do
  begin
    Editor := Module.GetModuleFileEditor(i);
    if Supports(Editor, IOTAFormEditor, FormEditor) then
    begin
      Assert(not Assigned(Result));
      Result := FormEditor;
      Break;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: GetTopMostEditBuffer
  Author:    (Taken from GX_OtaUtils.pas)
  Date:      06-Nov-2002
  Arguments: None
  Result:    IOTAEditBuffer
-----------------------------------------------------------------------------}
function GetTopMostEditBuffer: IOTAEditBuffer;
var
  EditorServices: IOTAEditorServices;
begin
  EditorServices := (BorlandIDEServices as IOTAEditorServices);
  Assert(Assigned(EditorServices));
  Result := EditorServices.TopBuffer;
end;

{-----------------------------------------------------------------------------
  Procedure: GetSourceEditorFromModule
  Author:    (Taken from GX_OtaUtils.pas)
  Date:      06-Nov-2002
  Arguments: Module: IOTAModule; const FileName: string
  Result:    IOTASourceEditor
-----------------------------------------------------------------------------}
function GetSourceEditorFromModule(Module: IOTAModule; const FileName: string): IOTASourceEditor;

      {$IFNDEF DELPHI6up}
      // Only needed for Pre-D6 versions
      function SameFileName(const S1, S2: string): Boolean;
      begin
        Result := SameText(S1, S2);
      end;
      {$ENDIF}

var
  i: Integer;
  IEditor: IOTAEditor;
  ISourceEditor: IOTASourceEditor;
begin
  Result := nil;
  if not Assigned(Module) then
    Exit;

  for i := 0 to Module.GetModuleFileCount-1 do
  begin
    IEditor := Module.GetModuleFileEditor(i);

    if Supports(IEditor, IOTASourceEditor, ISourceEditor) then
    begin
      if Assigned(ISourceEditor) then
      begin
        if (FileName = '') or SameFileName(ISourceEditor.FileName, FileName) then
        begin
          Result := ISourceEditor;
          Break;
        end;
      end;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: GetSourceEditor
  Author:    (Taken from GX_OtaUtils.pas)
  Date:      06-Nov-2002
  Arguments: None
  Result:    IOTASourceEditor
-----------------------------------------------------------------------------}
function GetSourceEditor: IOTASourceEditor;
var
  EditBuffer: IOTAEditBuffer;
begin
  Result := nil;
  EditBuffer := GetTopMostEditBuffer;
  if Assigned(EditBuffer) and (EditBuffer.FileName <> '') then
    Result := GetSourceEditorFromModule(GetCurrentIdeModule, EditBuffer.FileName);
  if Result = nil then
    Result := GetSourceEditorFromModule(GetCurrentIdeModule, '');
end;

{-----------------------------------------------------------------------------
  Procedure: ReplaceSelection
  Author:    Based on code taken from "http://www.tempest-sw.com/opentools/NewSort.html"
  Date:      06-Nov-2002
  Arguments: const Editor: IOTASourceEditor; const View: IOTAEditView
  Result:    None
-----------------------------------------------------------------------------}
//procedure ReplaceSelection(const Editor: IOTASourceEditor; const View: IOTAEditView; const UseText: string);
//var
//  BlockStart: TOTACharPos;
//  BlockAfter: TOTACharPos;
//  StartPos, EndPos: LongInt;
//  Reader: IOTAEditReader;
//  Writer: IOTAEditWriter;
//  TopPos, CursorPos: TOTAEditPos;
//  Text: string;
////  Strings: TStringList;
//begin
//  // Get the limits of the selected text.
//  BlockStart := Editor.BlockStart;
//  BlockAfter := Editor.BlockAfter;
//
//  // Sort entire lines, so modify the positions accordingly.
////  BlockStart.CharIndex := 0;   // start of line
////  if BlockAfter.CharIndex > 0 then
////  begin
////    // Select the entire line by setting the After position
////    // to the start of the next line.
////    BlockAfter.CharIndex := 0;
////    Inc(BlockAfter.Line);
////  end;
//
//  // Convert the character positions to buffer positions.
//  StartPos := View.CharPosToPos(BlockStart);
//  EndPos   := View.CharPosToPos(BlockAfter);
//
//  // Get the selected text.
//  Reader := Editor.CreateReader;
//  SetLength(Text, EndPos - StartPos - 1);
//  Reader.GetText(StartPos, PChar(Text), Length(Text));
//  Reader := nil;
//
//  Text := UseText;
////  // Sort the text. Use a TStringList because it's easy.
////  Strings := TStringList.Create;
////  try
////    Strings.Text := Text;
////    Strings.Sort;
////    Text := Strings.Text;
////  finally
////    Strings.Free;
////  end;
//
//  // Replace the selection with the sorted text.
//  ReplaceSelection(Editor, View, Text);
//
//  // Set the cursor to the start of the sorted text.
//  CursorToBlockStart(View, BlockStart);
//
//  // Make sure the top of the sorted text is visible.
//  // Scroll the edit window if ncessary.
//  if (BlockStart.Line < View.TopPos.Line) or
//     (BlockAfter.Line >= View.TopPos.Line + View.ViewSize.CY) then
//  begin
//    View.ConvertPos(False, TopPos, BlockStart);
//    View.TopPos := TopPos;
//  end;
//
//  // Select the newly inserted, sorted text.
//  Editor.BlockVisible := False;
//  Editor.BlockType    := btNonInclusive;
////  Editor.BlockStart   := BlockStart;
////  Editor.BlockAfter   := BlockAfter;
////  Editor.BlockVisible := True;
//end;

procedure Tdws2OTACreateDWSOnEval.CreateEvalEvent(AProgram: TProgram; const AUnitName: string;
  AFuncSym: TFuncSymbol; UnitFunc: Tdws2Function; CodeOpts: TCodeGenOptions;
  const WrappedType, VarPrefix: string);
var
  FormEditor: IOTAFormEditor;
  NativeFormEditor: INTAFormEditor;
  //
  ModuleServices: IOTAModuleServices;
  Module: IOTAModule;
  //Intf: IOTAEditor;
  Editor: IOTASourceEditor;
  View: IOTAEditView;
  //
  CreatedNew: Boolean;
  OwningFormName: string;
  NewFuncEventName: string;
  eventShortName: string;
begin
  FCodeGenerator.Options := CodeOpts;

  ModuleServices := BorlandIDEServices as IOTAModuleServices;
  // Get the module interface for the current file.
  Module := ModuleServices.CurrentModule;
  // If no file is open, Module is nil.
  if Module = nil then
    Exit;

  // Get the interface to the source editor.
  Editor := GetSourceEditor;
  // If the file is not a source file, Editor is nil.
  if Editor = nil then
    Exit;
  if Editor.EditViewCount <= 0 then
    Exit;

  View := Editor.EditViews[0];

  NewFuncEventName := FCodeGenerator.GetFunctionEventName(AUnitName, AFuncSym);
  { Create the OnEval event stub }
  FormEditor := GetFormEditorFromModule(GetCurrentIdeModule);
  if Supports(FormEditor, INTAFormEditor, NativeFormEditor) then
  begin
    eventShortName := 'Eval';   // default value
    if UnitFunc is Tdws2Constructor then
    begin
      CreatedNew := @Tdws2Constructor(UnitFunc).OnAssignExternalObject = nil;  // points to a different OnEval instance (one for methods)
      eventShortName := 'AssignExternalObject';          // override name for constructor event type
    end
    else if UnitFunc is Tdws2Method then
      CreatedNew := @Tdws2Method(UnitFunc).OnEval = nil  // points to a different OnEval instance (one for methods)
    else
      CreatedNew := @UnitFunc.OnEval = nil;              // points to OnEval for functions
      
    if NativeFormEditor.FormDesigner <> nil then
    begin
    { TODO -oMark : if the function exists, don't create it, but synch function name }
      // only create method if it wasn't attached. If attached, just change the name
      DoCreateMethod(NativeFormEditor.FormDesigner, UnitFunc, eventShortName,
                     NewFuncEventName, CreatedNew);
      NativeFormEditor.FormDesigner.ShowMethod(NewFuncEventName);
      OwningFormName := NativeFormEditor.FormDesigner.GetRoot.ClassName;

      ParseUnit(Editor, FParser);

      if FuncEventUpdate(UnitFunc, AFuncSym, Editor, View, OwningFormName, CreatedNew,
                         NewFuncEventName, CodeOpts, WrappedType, VarPrefix)
      then
        NativeFormEditor.FormDesigner.Modified;
    end;
  end;

  // Bring the focus back to the source editor window.
  Editor.Show;
end;

procedure Tdws2OTACreateDWSOnEval.Execute;
begin
  // nothing done here. Needs to exist for interface, not needed for usage.
end;

{-----------------------------------------------------------------------------
  Procedure: TCreateDWSOnEval.Finalize
  Author:    Mark
  Date:      08-Nov-2002
  Arguments: None
  Result:    None
  Purpose:   The object will exist as long as the package is loaded. With this
             call, the caller can setup for a batch process where there is not
             as much object creation/destruction. Then when completed, they free
             it all. Minor optimization.
-----------------------------------------------------------------------------}
procedure Tdws2OTACreateDWSOnEval.Finalize;
begin
  if Assigned(FParser) then
    FreeAndNil(FParser);
  if Assigned(FCodeGenerator) then
    FreeAndNil(FCodeGenerator);
end;

{-----------------------------------------------------------------------------
  Procedure: FuncEventUpdate
  Author:    Mark Ericksen
  Date:      07-Nov-2002
  Arguments: EventCode: TStrings; Func: Tdws2Function
  Result:    Boolean
  Purpose:   Return if the code was altered. Process Delphi Event code to update
             any portions that exist. OwningFormName is used to find the correct
             method/function in the source.
-----------------------------------------------------------------------------}
function Tdws2OTACreateDWSOnEval.FuncEventUpdate(UnitFunc: Tdws2Function; AFuncSym: TFuncSymbol;
  const Editor: IOTASourceEditor; const View: IOTAEditView;
  const OwningFormName: string; IsNew: Boolean;
  const FuncEventName: string; CodeOptions: TCodeGenOptions;
  const WrappedType, VarPrefix: string): Boolean;
var
  Node: TCodeTreeNode;
  PulledCode: TStringList;
begin
  Result := False;
  PulledCode := TStringList.Create;
  try
    Node := FParser.CodeNodeMap.FindMethodImplementation(OwningFormName, FuncEventName);
    if Assigned(Node) then
    begin
      SelectNode(Editor, View, Node);           // select the desired block from the editor
      PulledCode.Text := ReturnSelection(Editor, View); // copy out the selected text

      { TODO : Create object (for whole class) and set properties... make the needed call here. }
      FCodeGenerator.BuildUnitComponentExecEvent(AFuncSym, PulledCode, IsNew, WrappedType);

      { Replace the selection with the new code }
      ReplaceSelection(Editor, View, PulledCode.Text);
      Result := True;        // something in editor changed
    end
//    else
//      ShowMessage(Format('Node "%s" not found', [OwningFormName +'.'+ FuncEventName]));
  finally
    PulledCode.Free;
  end;
end;

function Tdws2OTACreateDWSOnEval.GetIDString: string;
begin
  Result := 'DWSII.Tdws2Unit_Editor';
end;

function Tdws2OTACreateDWSOnEval.GetName: string;
begin
  Result := 'Create DWSII Tdws2Unit events';
end;

function Tdws2OTACreateDWSOnEval.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

{-----------------------------------------------------------------------------
  Procedure: TCreateDWSOnEval.Initialize
  Author:    Mark
  Date:      08-Nov-2002
  Arguments: None
  Result:    None
  Purpose:   The object will exist as long as the package is loaded. With this
             call, the caller can setup for a batch process where there is not
             as much object creation/destruction. Then when completed, they free
             it all. Minor optimization.
-----------------------------------------------------------------------------}
procedure Tdws2OTACreateDWSOnEval.Initialize;
begin
  if not Assigned(FParser) then
    FParser:= TSourceParserTree.Create;
  if not Assigned(FCodeGenerator) then
    FCodeGenerator := Tdws2PascalCodeGenerator.Create(nil);
end;

end.

