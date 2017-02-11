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

unit GenDelphiCodeForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
{$IFDEF NEWVARIANTS}
  Variants,
{$ENDIF}
  Dialogs, StdCtrls, dws2Comp, dws2Exprs, CheckLst, Buttons, ExtCtrls;

type
  { The speed buttons for operating on the 'checked' states need nice graphics.
    I didn't have time to hunt them down yet. }
  TfmGenDelphiCode = class(TForm)
    btnGenerate: TButton;
    grpCodeOptions: TGroupBox;
    rbtnWrapped: TRadioButton;
    rbtnCreateUpdate: TRadioButton;
    chkVarDeclaration: TCheckBox;
    chkOnlyNeededParams: TCheckBox;
    chkScriptCall: TCheckBox;
    chkVarAssign: TCheckBox;
    chkVarRevAssign: TCheckBox;
    Label1: TLabel;
    edVarPrefix: TEdit;
    btnClose: TButton;
    clbClasses: TCheckListBox;
    Label2: TLabel;
    Label3: TLabel;
    clbFuncs: TCheckListBox;
    sbtnClassesAll: TSpeedButton;
    sbtnClassesNone: TSpeedButton;
    sbtnClassesToggle: TSpeedButton;
    sbtnFuncAll: TSpeedButton;
    sbtnFuncNone: TSpeedButton;
    sbtnFuncToggle: TSpeedButton;
    chkAssertWrappedCall: TCheckBox;
    rbtnClearEvent: TRadioButton;
    chkScriptComments: TCheckBox;
    Bevel1: TBevel;
    procedure btnGenerateClick(Sender: TObject);
    procedure UpdateCheckStates(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbtnClassesAllClick(Sender: TObject);
    procedure sbtnClassesNoneClick(Sender: TObject);
    procedure sbtnClassesToggleClick(Sender: TObject);
    procedure sbtnFuncAllClick(Sender: TObject);
    procedure sbtnFuncNoneClick(Sender: TObject);
    procedure sbtnFuncToggleClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    FProgram: TProgram;
    FUnit: Tdws2Unit;
  public
    class procedure ShowForm(AProgram: TProgram; AUnit: Tdws2Unit);
  end;

var
  fmGenDelphiCode: TfmGenDelphiCode;

implementation

uses CreateDWSEval, dws2Symbols, dws2UnitUtils, dws2PasGenerator;

{$R *.dfm}

{ Set all items to have the 'Checked' state }
procedure SetCheckState(Control: TCheckListBox; Checked: Boolean);
var
  i: Integer;
begin
  for i := 0 to Control.Items.Count - 1 do
    Control.Checked[i] := Checked;
end;

{ Toggle what is checked to unchecked, vice versa }
procedure ToggleCheckStates(Control: TCheckListBox);
var
  i: Integer;
begin
  for i := 0 to Control.Items.Count - 1 do
    Control.Checked[i] := not Control.Checked[i];
end;

{ Copy checked items to Strings list. }
procedure ListCheckedItems(Control: TCheckListBox; Strings: TStrings);
var
  i: Integer;
begin
  Strings.Clear;
  for i := 0 to Control.Items.Count - 1 do
    if Control.Checked[i] then
      Strings.AddObject(Control.Items[i], Control.Items.Objects[i]);  // copy object and pointer values
end;

{ TfmGenDelphiCode }

class procedure TfmGenDelphiCode.ShowForm(AProgram: TProgram; AUnit: Tdws2Unit);
begin
  with Self.Create(nil) do
    try
      FProgram := AProgram;
      FUnit := AUnit;
      ShowModal;
    finally
      Free;
    end;
end;

procedure TfmGenDelphiCode.btnGenerateClick(Sender: TObject);
var
  i, x: Integer;
  CodeOpts: TCodeGenOptions;
  tmpClassName: string;
  funcSym: TFuncSymbol;
  unitFunc: Tdws2Function;
  CheckedItems: TStringList;
  funcCnt, methCnt: Integer;
begin
  CodeOpts := [];
  // if synching comment tags should be included
  if chkScriptComments.Checked then
    CodeOpts := CodeOpts + [coIncludeCommentTags];
  // create/synch comment that declares the script call
  if chkScriptCall.Checked then
    CodeOpts := CodeOpts + [coScriptCall];

  { if in 'wrap' mode, set default options }
  if rbtnWrapped.Checked then
  begin
    CodeOpts := CodeOpts + [coCreateWrapperCall];
    if chkAssertWrappedCall.Checked then
      CodeOpts := CodeOpts + [coAssertWrappedObj];
    // add standard options for wrapped calls
    CodeOpts := CodeOpts + [coVarDeclaration, coOnlyNeededParams, coVarAssign, coVarRevAssign];
  end
  { if not wrapping, take user options }
  else if rbtnCreateUpdate.Checked then
  begin
    if chkVarDeclaration.Checked then
      CodeOpts := CodeOpts + [coVarDeclaration];
    // if Variable declarations are an enabled and checked...
    if chkVarDeclaration.Enabled and chkVarDeclaration.Checked then
    begin
      if chkOnlyNeededParams.Checked then
        CodeOpts := CodeOpts + [coOnlyNeededParams];
      if chkVarAssign.Checked then
        CodeOpts := CodeOpts + [coVarAssign];
      if chkVarRevAssign.Checked then
        CodeOpts := CodeOpts + [coVarRevAssign];
    end;
  end
  { if clearing the event code }
  else if rbtnClearEvent.Checked then
  begin
    CodeOpts := [coEmptyOnly];
  end;

  funcCnt := 0;
  methCnt := 0;
  { Create/Update the events }
  CreateEvalCode.Initialize;
  CheckedItems := TStringList.Create;
  try
    { Create/Update methods for Unit Classes  }
    ListCheckedItems(clbClasses, CheckedItems);      // get copy of checked classes
    for i := 0 to FUnit.Classes.Count - 1 do         // cycle classes in unit
    begin
      tmpClassName := FUnit.Classes.Items[i].Name;   // get name of current class
      if CheckedItems.IndexOf(tmpClassName) > -1 then   // if class is checked
      begin
        // Cycle constructors for this class. Create/Update this method.
        for x := 0 to Tdws2Class(FUnit.Classes.Items[i]).Constructors.Count - 1 do
        begin
          unitFunc := Tdws2Constructor(Tdws2Class(FUnit.Classes.Items[i]).Constructors.Items[x]);
          funcSym := FindSymbolForUnitFunction(FProgram, unitFunc);

          CreateEvalCode.CreateEvalEvent(FProgram, FUnit.Name, funcSym, unitFunc,
                                         CodeOpts, tmpClassName, { TODO -oMark : Add support for an alternate wrapped type? }
                                         edVarPrefix.Text);
          Inc(methCnt);
        end; {for x}
        // Cycle methods for this class. Create/Update this method.
        for x := 0 to Tdws2Class(FUnit.Classes.Items[i]).Methods.Count - 1 do
        begin
          unitFunc := Tdws2Method(Tdws2Class(FUnit.Classes.Items[i]).Methods.Items[x]);
          funcSym := FindSymbolForUnitFunction(FProgram, unitFunc);

          CreateEvalCode.CreateEvalEvent(FProgram, FUnit.Name, funcSym, unitFunc,
                                         CodeOpts, tmpClassName, { TODO -oMark : Add support for an alternate wrapped type? }
                                         edVarPrefix.Text);
          Inc(methCnt);
        end; {for x}
      end; 
    end; {for i}
    { Create/Update unit declared functions }
    ListCheckedItems(clbFuncs, CheckedItems);      // get copy of checked classes
    for i := 0 to FUnit.Functions.Count - 1 do     // cycle functions in unit
    begin
      unitFunc := Tdws2Function(FUnit.Functions.Items[i]);
      if CheckedItems.IndexOf(unitFunc.Name) > -1 then   // if function is checked
      begin
        funcSym := FindSymbolForUnitFunction(FProgram, unitFunc);

        CreateEvalCode.CreateEvalEvent(FProgram, FUnit.Name, funcSym, unitFunc,
                                       CodeOpts, '',  // no wrapped type for functions
                                       edVarPrefix.Text);
        Inc(funcCnt);
      end;
    end; {for i}
    { If clearing events, show message for that }
    if rbtnClearEvent.Checked then
      MessageDlg(Format('%d events cleared for %d methods and %d functions.', [methCnt+funcCnt, methCnt, funcCnt]), mtInformation, [mbOK], 0)
    { If building events, show message for that }
    else
      MessageDlg(Format('%d events created/updated for %d methods and %d functions.', [methCnt+funcCnt, methCnt, funcCnt]), mtInformation, [mbOK], 0);
  finally
    CheckedItems.Free;
    CreateEvalCode.Finalize;
  end;
end;

procedure TfmGenDelphiCode.UpdateCheckStates(Sender: TObject);
begin
  // Call to update check states
  chkAssertWrappedCall.Enabled := rbtnWrapped.Checked;
  chkVarDeclaration.Enabled   := rbtnCreateUpdate.Checked;
  // Update those dependent on Variable declarations being included
  chkOnlyNeededParams.Enabled := chkVarDeclaration.Checked and chkVarDeclaration.Enabled;
  chkVarAssign.Enabled        := chkVarDeclaration.Checked and chkVarDeclaration.Enabled;
  chkVarRevAssign.Enabled     := chkVarDeclaration.Checked and chkVarDeclaration.Enabled;
  edVarPrefix.Enabled         := chkVarDeclaration.Checked and chkVarDeclaration.Enabled;
  // set color to reflect enabled status of edVarPrefix
  if edVarPrefix.Enabled then
    edVarPrefix.Color := clWindow
  else
    edVarPrefix.ParentColor := True;
end;

procedure TfmGenDelphiCode.FormShow(Sender: TObject);
var
  i: Integer;
begin
  UpdateCheckStates(nil);

  // Fill Classes list
  clbClasses.Items.Clear;
  for i := 0 to FUnit.Classes.Count - 1 do
    clbClasses.Items.Add(Tdws2Class(FUnit.Classes.Items[i]).Name);

  // Fill Func/Proc list
  clbFuncs.Items.Clear;
  for i := 0 to FUnit.Functions.Count - 1 do
    clbFuncs.Items.Add(Tdws2Function(FUnit.Functions.Items[i]).Name);

  // By default, check all
  SetCheckState(clbClasses, True);
  SetCheckState(clbFuncs, True);
end;

procedure TfmGenDelphiCode.sbtnClassesAllClick(Sender: TObject);
begin
  SetCheckState(clbClasses, True);
end;

procedure TfmGenDelphiCode.sbtnClassesNoneClick(Sender: TObject);
begin
  SetCheckState(clbClasses, False);
end;

procedure TfmGenDelphiCode.sbtnClassesToggleClick(Sender: TObject);
begin
  ToggleCheckStates(clbClasses);
end;

procedure TfmGenDelphiCode.sbtnFuncAllClick(Sender: TObject);
begin
  SetCheckState(clbFuncs, True);
end;

procedure TfmGenDelphiCode.sbtnFuncNoneClick(Sender: TObject);
begin
  SetCheckState(clbFuncs, False);
end;

procedure TfmGenDelphiCode.sbtnFuncToggleClick(Sender: TObject);
begin
  ToggleCheckStates(clbFuncs);
end;

procedure TfmGenDelphiCode.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
