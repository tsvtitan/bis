unit BisCoreIntf;

interface

uses BisObjectIntf;

type
  TBisCoreMode=(smStandalone,smService);
  TBisCoreAction=(saHelp,saDefault,saInstall,saUninstall,saCommand,saShow,saSet,saSave);

  IBisCore=interface(IBisObject)
  ['{8511B6F5-D9D4-4308-B9ED-34D56B00ED83}']
    procedure Init;
    procedure Done;
    procedure RunStandalone;
    procedure RunAutomation;
    procedure RunRegserver;
    procedure RunUnregserver;
    procedure Terminate;

    function Translate(S: String): String;

    function GetInited: Boolean;
    function GetMode: TBisCoreMode;
    function GetAction: TBisCoreAction;
    function GetConfigFile: String;

    procedure SetConfigFile(Value: String);

    property Inited: Boolean read GetInited;
    property Mode: TBisCoreMode read GetMode;
    property Action: TBisCoreAction read GetAction;
    property ConfigFileName: String read GetConfigFile write SetConfigFile;
  end;

implementation

end.
