unit dwsIdeTypes;

interface

uses SysUtils, Classes, dws2Comp, Controls;

type
  TErrType = (errCompiler, errRuntime, errInternal);

  TEditorOption = (eoAllowNew, eoAllowOpen, eoAllowSave, eoAllowSaveAs {,eoAllowMRUList},
                   eoShowHelpMenu, eoShowAboutMenu, eoShowLineNumbers, eoReadOnly,
                   eoShowCodeInsightIcons, eoShowPropertyAccessors);
  TEditorOptions  = set of TEditorOption;

  TArrayOfVariant = array of Variant;

  { Timer values for the delay on SynEdit TSynCompletionProposal components }
  TTimerDelaySettings = record
    CodeProposal: Integer;
    HintProposal: Integer;
    ParamProposal: Integer;
  end;


  { Interface used to provided external functions for the editor. }
  IExternalScriptHandler = interface
  ['{B324DFE0-85C8-11D6-84FB-0003B3003D8C}']
    procedure FetchInitialScript(const AScript: TStrings);
    function GetDWScript: TDelphiWebScriptII;
    function LoadScript(var ScriptName: string; AScript: TStrings; var AReadOnly, IsAFileName: Boolean): Boolean;
    //function LoadMRUScript(const ScriptName: string; var ScriptText: string;
    //                       var AReadOnly, IsAFileName: Boolean): Boolean;
    procedure SaveScript(const ScriptName: string; AScript: TStrings);
    function SaveScriptAs(var ScriptName: string; AScript: TStrings): Boolean;
    //procedure FillMRUList(AList: TStrings);
    //procedure AddItemToMRUList(const ScriptName: string);
    function  HandleError(ErrType: TErrType; ErrString: string): Boolean;
    procedure EditorOpen;
    function  EditorCanClose: Boolean;
    procedure EditorClose;
    function ShowAboutBox: Boolean;
    function ShowHelp: Boolean;
//    procedure UnhandledException(E: Exception);
  end;

  { Interface used to provide external options for the editor's behavior and display properties }
  IExternalOptionSetter = interface
  ['{BBFA3048-552B-40A8-89EF-177D199F8E5D}']
    function GetOptions: TEditorOptions;
    function GetCodeExplorerAlignment: TAlign;
    function GetTimerSettings: TTimerDelaySettings;
  end;

implementation

end.
