program update;

uses
  Forms,
  BisUpdateMainFm in 'update.exe\BisUpdateMainFm.pas' {BisUpdateMainForm},
  BisCrypter in 'core.bpl\BisCrypter.pas',
  BisUpdateConnection in 'update.exe\BisUpdateConnection.pas',
  BisUpdateConsts in 'update.exe\BisUpdateConsts.pas',
  BisUpdateConfig in 'update.exe\BisUpdateConfig.pas',
  BisUpdateMapFile in 'update.exe\BisUpdateMapFile.pas',
  BisSizeGrip in 'core.bpl\BisSizeGrip.pas',
  BisUpdateTypes in 'update.exe\BisUpdateTypes.pas',
  BisModuleInfo in 'core.bpl\BisModuleInfo.pas',
  BisVersionInfo in 'core.bpl\BisVersionInfo.pas',
  BisFileDirs in 'core.bpl\BisFileDirs.pas',
  ALXmlDoc in 'objects.bpl\Alcinoe\source\ALXmlDoc.pas',
  BisBase64 in 'core.bpl\BisBase64.pas',
  DCPrijndael in 'objects.bpl\DcpCrypt2\DCPrijndael.pas',
  DCPcrypt2 in 'objects.bpl\DcpCrypt2\DCPcrypt2.pas',
  DCPconst in 'objects.bpl\DcpCrypt2\DCPconst.pas',
  DCPbase64 in 'objects.bpl\DcpCrypt2\DCPbase64.pas',
  DCPblockciphers in 'objects.bpl\DcpCrypt2\DCPblockciphers.pas',
  BisNetUtils in 'core.bpl\BisNetUtils.pas';

{$R *.res}

begin
  Init;
  try
    if Exists then
     exit;
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TBisUpdateMainForm, BisUpdateMainForm);
  Application.Run;
  finally
    Done;
  end;
end.