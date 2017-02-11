unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dws2Comp, StdCtrls, dws2Exprs, ExtCtrls, ComCtrls, 
  SynEditHighlighter, SynHighlighterPas, SynEdit, SynCompletionProposal;

type
  TfmMain = class(TForm)
    ScriptInit: TDelphiWebScriptII;
    InitializeUnit: Tdws2Unit;
    ScriptForUse: TDelphiWebScriptII;
    DynamicSymbolUnit: Tdws2Unit;
    mDescription: TMemo;
    btnRunInitScript: TButton;
    BasicClassesUnit: Tdws2Unit;
    grpTestingArea: TGroupBox;
    Edit1: TEdit;
    Label1: TLabel;
    lblInitScript: TLabel;
    Button2: TButton;
    Panel1: TPanel;
    TrackBar1: TTrackBar;
    btnRunScript: TButton;
    CheckBox1: TCheckBox;
    btnRegisterInCode: TButton;
    chkUseAllTypes: TCheckBox;
    synInitScript: TSynEdit;
    SynPasSyn1: TSynPasSyn;
    synRegularScript: TSynEdit;
    CodeProposalInit: TSynCompletionProposal;
    ParamProposalInit: TSynCompletionProposal;
    chkIncludeGetSet: TCheckBox;
    CodeProposalUse: TSynCompletionProposal;
    ParamProposalUse: TSynCompletionProposal;
    procedure BasicClassesUnitTPersistentMethodsAssignEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTPersistentMethodsGetNamePathEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsSetTagEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsGetTagEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsSetNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsGetNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsGetOwnerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsSetComponentIndexEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsGetComponentIndexEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsGetComponentCountEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsGetComponentEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsFindComponentEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsFreeNotificationEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsRemoveFreeNotificationEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsGetParentComponentEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsGetNamePathEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure BasicClassesUnitTComponentMethodsHasParentEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure btnRunInitScriptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BasicClassesUnitInstancesHostFormInstantiate(
      var ExtObject: TObject);
    procedure btnRunScriptClick(Sender: TObject);
    procedure InitializeUnitFunctionsRegisterClassWithUnitEval(
      Info: TProgramInfo);
    procedure btnRegisterInCodeClick(Sender: TObject);
    procedure CodeInsightExecute(Kind: SynCompletionType; Sender: TObject;
      var CurrentInput: String; var x, y: Integer;
      var CanExecute: Boolean);
  private
    FAvailableTypes: TProgram;
    procedure ShowError(AProg: TProgram);
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

uses
  dws2SynEditUtils, dws2IDEUtils;

procedure TfmMain.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  { Delphi help is wrong on GetClass/FindClass. It reports that:
      "The Class must be registered before GetClass can find it.  Form
      classes and component classes that are referenced in a form declaration
      (instance variables) are automatically registered when the form is loaded."
    This is incorrect because without explicitly registering them they cannot
    be found using the above calls. (D5/D7) Using this method, you can always
    be certain that every component on the form is registered and therfore
    accessible to some degree to a script. }
  for i := 0 to Self.ComponentCount - 1 do
    RegisterClass(TPersistentClass(Self.Components[i].ClassType));
end;

procedure TfmMain.BasicClassesUnitInstancesHostFormInstantiate(var ExtObject: TObject);
begin
  // expose the hosting TForm as a TComponent to the ScriptForUse program.
  ExtObject := Self;
end;

procedure TfmMain.btnRunInitScriptClick(Sender: TObject);
var
  initProg: TProgram;
begin
  { If supporting all known types, compile a program that uses the units that
    will be available to our dynamic classes. If the type is supported it can
    be added to the dynamic class. }
  if chkUseAllTypes.Checked then
    FAvailableTypes := ScriptForUse.Compile('')
  else
    FAvailableTypes := nil;

  // use program for initializing other scripts
  initProg := ScriptInit.Compile(synInitScript.Lines.Text);
  try
    ShowError(initProg);  // compile errors
    initProg.Execute;
  finally
    ShowError(initProg);  // execution errors
    initProg.Free;
    FreeAndNil(FAvailableTypes);
  end;
end;

procedure TfmMain.btnRunScriptClick(Sender: TObject);
var
  useProg: TProgram;
begin
  // use program for regular script usage
  useProg := ScriptForUse.Compile(synRegularScript.Lines.Text);
  try
    ShowError(useProg);  // compile errors
    useProg.Execute;
  finally
    ShowError(useProg);  // execution errors
    useProg.Free;
  end;
end;

procedure TfmMain.ShowError(AProg: TProgram);
begin
  // display any errors with the program
  if AProg.Msgs.HasErrors or AProg.Msgs.HasExecutionErrors then
    MessageDlg(AProg.Msgs.AsString, mtError, [mbOK], 0);
end;

procedure TfmMain.btnRegisterInCodeClick(Sender: TObject);
begin
  DynamicSymbolUnit.ExposeClassToUnit(TPanel, TComponent);
end;

procedure TfmMain.InitializeUnitFunctionsRegisterClassWithUnitEval(Info: TProgramInfo);
begin
  { This will get the class types named in the initialization script and register
    those objects at runtime to expose properties through RTTI. }

  //procedure RegisterClassWithUnit(const AClassName: String; const AAncestorType: String);
  DynamicSymbolUnit.ExposeClassToUnit(FindClass(Info['AClassName']), FindClass(Info['AAncestorType']), FAvailableTypes);
end;

// == AUTO GENERATED WRAPPER FUNCTIONS == =====================

procedure TfmMain.BasicClassesUnitTPersistentMethodsAssignEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  Source_Obj: TPersistent;
begin
  //procedure TPersistent.Assign(Source: TPersistent);
  // Get param "Source" as object in Source_Obj
  Source_Obj := TPersistent(Info.GetExternalObjForVar('Source'));
  Assert((ExtObject<>nil) and (ExtObject is TPersistent));
  TPersistent(ExtObject).Assign(Source_Obj);
end;

procedure TfmMain.BasicClassesUnitTPersistentMethodsGetNamePathEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  //function TPersistent.GetNamePath: String;
  Assert((ExtObject<>nil) and (ExtObject is TPersistent));
  Info.Result := TPersistent(ExtObject).GetNamePath;
end;

procedure TfmMain.BasicClassesUnitTComponentConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  AOwner_Obj: TComponent;
begin
  //constructor TComponent.Create(AOwner: TComponent);
  // Get param "AOwner" as object in AOwner_Obj
  AOwner_Obj := TComponent(Info.GetExternalObjForVar('AOwner'));
  ExtObject := TComponent.Create(AOwner_Obj);
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsSetTagEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  //procedure TComponent.SetTag(Value: Integer);
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  TComponent(ExtObject).Tag := Info['Value'];
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsGetTagEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  //function TComponent.GetTag: Integer;
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  Info.Result := TComponent(ExtObject).Tag;
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsSetNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  //procedure TComponent.SetName(Value: String);
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  TComponent(ExtObject).Name := Info['Value'];
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsGetNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  //function TComponent.GetName: String;
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  Info.Result := TComponent(ExtObject).Name;
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsGetOwnerEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  Result_Obj: TComponent;
begin
  //function TComponent.GetOwner: TComponent;
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  Result_Obj := TComponent(ExtObject).Owner;
  Info.Result := Info.RegisterExternalObject(Result_Obj);
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsSetComponentIndexEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  //procedure TComponent.SetComponentIndex(Value: Integer);
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  TComponent(ExtObject).ComponentIndex := Info['Value'];
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsGetComponentIndexEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  //function TComponent.GetComponentIndex: Integer;
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  Info.Result := TComponent(ExtObject).ComponentIndex;
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsGetComponentCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  //function TComponent.GetComponentCount: Integer;
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  Info.Result := TComponent(ExtObject).ComponentCount;
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsGetComponentEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  Result_Obj: TComponent;
begin
  //function TComponent.GetComponent(Index: Integer): TComponent;
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  Result_Obj := TComponent(ExtObject).Components[Info['Index']];
  Info.Result := Info.RegisterExternalObject(Result_Obj);
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsFindComponentEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  Result_Obj: TComponent;
begin
  //function TComponent.FindComponent(const AName: String): TComponent;
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  Result_Obj := TComponent(ExtObject).FindComponent(Info['AName']);
  Info.Result := Info.RegisterExternalObject(Result_Obj);
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsFreeNotificationEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  AComponent_Obj: TComponent;
begin
  //procedure TComponent.FreeNotification(AComponent: TComponent);
  // Get param "AComponent" as object in AComponent_Obj
  AComponent_Obj := TComponent(Info.GetExternalObjForVar('AComponent'));
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  TComponent(ExtObject).FreeNotification(AComponent_Obj);
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsRemoveFreeNotificationEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  AComponent_Obj: TComponent;
begin
  //procedure TComponent.RemoveFreeNotification(AComponent: TComponent);
  // Get param "AComponent" as object in AComponent_Obj
  AComponent_Obj := TComponent(Info.GetExternalObjForVar('AComponent'));
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  TComponent(ExtObject).RemoveFreeNotification(AComponent_Obj);
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsGetParentComponentEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  Result_Obj: TComponent;
begin
  //function TComponent.GetParentComponent: TComponent;
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  Result_Obj := TComponent(ExtObject).GetParentComponent;
  Info.Result := Info.RegisterExternalObject(Result_Obj);
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsGetNamePathEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  //function TComponent.GetNamePath: String;
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  Info.Result := TComponent(ExtObject).GetNamePath;
end;

procedure TfmMain.BasicClassesUnitTComponentMethodsHasParentEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  //function TComponent.HasParent: Boolean;
  Assert((ExtObject<>nil) and (ExtObject is TComponent));
  Info.Result := TComponent(ExtObject).HasParent;
end;

procedure TfmMain.CodeInsightExecute(Kind: SynCompletionType;
  Sender: TObject; var CurrentInput: String; var x, y: Integer;
  var CanExecute: Boolean);
var
  CurrentEditor: TCustomSynEdit;
  CurrentScript: TDelphiWebScriptII;
begin
  CurrentEditor := TSynCompletionProposal(Sender).Editor;
  if CurrentEditor = synInitScript then
    CurrentScript := ScriptInit
  else if CurrentEditor = synRegularScript then
    CurrentScript := ScriptForUse
  else
    EXIT;

  case Kind of
  ctCode :
    begin
      // use the compiled program to fetch out the symbols in the script. Re-use
      // the symbols from the FUnitXXX lists.
      CanExecute := PerformCodeCompletion(CurrentEditor, CurrentScript,
                                          TSynCompletionProposal(Sender),
                                          x, y, False, chkIncludeGetSet.Checked);
    end;
  ctParams :
    begin
      CanExecute := PerformParamProposal(CurrentEditor, CurrentScript,
                                         TSynCompletionProposal(Sender), x, y);
    end;
  ctHint :
    begin
      CanExecute := PerformHintProposal(CurrentEditor, CurrentScript,
                                        TSynCompletionProposal(Sender), x, y,
                                        False);
    end;
  end;
end;

end.
