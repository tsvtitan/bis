{ This demo was created to illustrate how to use ClassCompletion.
  The heart of it all is "CompleteClassesExecute()".

  NOTE: ClassCompletion internally is recompiling the script to find the
        problem areas so it can be fixed. Exceptions are used to trap the
        information about class problems. Running this in the Delphi IDE will
        show the exceptions unless you suppress these types. Running it outside
        the IDE is the easiest way to play with it.

        If you choose to suppress the errors, then the language exceptions to
        ignore are...
          EScriptError
          EClassPropertyIncompleteError
          EClassMethodImplIncompleteError
Copyright 2003 - Mark Ericksen }

{$INCLUDE dws2.inc}

unit MainForm;

interface

uses
  Windows, Messages, SysUtils,
{$IFDEF NEWVARIANTS}
  Variants,
{$ENDIF}
  Classes, Graphics, Controls, Forms,
  Dialogs, SynEditHighlighter, SynHighlighterPas, SynEdit, dws2Comp, Menus,
  ActnList, StdCtrls, dws2Exprs;

type
  TfmMain = class(TForm)
    SynEdit1: TSynEdit;
    SynPasSyn1: TSynPasSyn;
    alActions: TActionList;
    actCompleteClass: TAction;
    actCompleteAllClasses: TAction;
    MainMenu1: TMainMenu;
    Completeallclasses2: TMenuItem;
    ClassCompletionTest1: TMenuItem;
    Completeclassatcursor1: TMenuItem;
    DelphiWebScriptII1: TDelphiWebScriptII;
    N1: TMenuItem;
    miBarebones: TMenuItem;
    lbMessages: TListBox;
    actSyntaxCheck: TAction;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure CompleteClassesExecute(Sender: TObject);
    procedure miBarebonesClick(Sender: TObject);
    procedure actSyntaxCheckExecute(Sender: TObject);
  private
  public
    // display messages for compiled program
    procedure DisplayMessages(AProg: TProgram);
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

uses dws2IDEUtils;

procedure TfmMain.actSyntaxCheckExecute(Sender: TObject);
var
  Prog: TProgram;
begin
  { Simple compile to test for and display messages }
  Prog := DelphiWebScriptII1.Compile(SynEdit1.Lines.Text);
  try
    DisplayMessages(Prog);
  finally
    Prog.Free;
  end;
end;

procedure TfmMain.CompleteClassesExecute(Sender: TObject);
var
  Prog: TProgram;
  DoAll: Boolean;
begin
  // based on sender use different completion method
  DoAll := (Sender = actCompleteAllClasses);

  // compile to find errors about missing class parts. (Needs SymbolDictionary and ContextMap)
  Prog := CompileWithSymbolsAndMap(DelphiWebScriptII1, SynEdit1.Lines.Text);
  try
    DisplayMessages(Prog);       // display any compiler error messages

    // Attempt to complete the class(es) as instructed.

    if DoAll then
      // Complete ALL incomplete classes
      CompleteAllClasses(DelphiWebScriptII1, SynEdit1.Lines, miBarebones.Checked)
    else
      // Try to complete ONLY the class where the cursor is located
      CompleteClassAtCursor(DelphiWebScriptII1, Prog, SynEdit1.CaretY, SynEdit1.CaretX, SynEdit1.Lines, miBarebones.Checked);

    // recompile the new altered script to give a current error state
    actSyntaxCheck.Execute;
  finally
    Prog.Free;
  end;
end;

procedure TfmMain.DisplayMessages(AProg: TProgram);
var
  i: Integer;
begin
  { Show messages }
  lbMessages.Items.Clear;
  for i := 0 to AProg.Msgs.Count - 1 do
    lbMessages.Items.Add(AProg.Msgs[i].AsInfo);
  { If compile was without error }
  if lbMessages.Items.Count = 0 then
    lbMessages.Items.Add('**Compiled**');
end;

procedure TfmMain.miBarebonesClick(Sender: TObject);
begin
  // "Bare bones" means that the procedure's parameters are not included in
  // the implementation. This is valid script and can reduce the maintenance
  // of keeping the two in synch.
  miBarebones.Checked := not miBarebones.Checked;
end;

end.
