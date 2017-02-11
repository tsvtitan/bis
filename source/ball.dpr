program ball;

uses
 // Forms,
  BisLoader in 'loader.exe\BisLoader.pas',
  BisObject in 'core.bpl\BisObject.pas',
  BisObjectIntf in 'core.bpl\BisObjectIntf.pas',
  BisLoaderCmdLine in 'loader.exe\BisLoaderCmdLine.pas',
  BisCoreIntf in 'core.bpl\BisCoreIntf.pas',
  BisLoaderResource in 'loader.exe\BisLoaderResource.pas',
  BisLoaderUpdate in 'loader.exe\BisLoaderUpdate.pas',
  BisUpdateMapFile in 'update.exe\BisUpdateMapFile.pas';

{$R *.res}


begin
  //Application.Initialize;
  ConfigFileName:='config.ini';
  CheckUpdate:=false;
  InitLoader;
end.
