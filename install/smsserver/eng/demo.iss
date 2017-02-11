; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define AppBinDir "demo"
#define AppBin SourcePath+"\"+AppBinDir
#define AppVersion GetFileVersion(AppBin+"\smsms.bpl")
#define AppPublisher "NextSoft"
#define AppPublisherURL "http://nextsoft.biz"
#define OutputDir SourcePath+"\_output"
#define SetupIconFile ""
#define HistoryFile AppBin+"\history.rtf"

#define AppName "SMS Sever & Client Demo"
#define OutputBaseFilename "sms_server_&_client_demo_"+AppVersion
#define AppID "{{CEF7172B-FC1E-4ACE-8421-E7228CA7F212}"

[Setup]
AppName={#AppName}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppPublisherURL}
AppSupportURL={#AppPublisherURL}
AppUpdatesURL={#AppPublisherURL}
DefaultDirName={pf}\{#AppPublisher}\{#AppName}
DefaultGroupName={#AppName}
OutputDir={#OutputDir}
OutputBaseFilename={#OutputBaseFilename}
InfoAfterFile={#HistoryFile}
Compression=lzma/ultra
SolidCompression=true
AppID={#AppID}
InternalCompressLevel=ultra
VersionInfoVersion={#AppVersion}
VersionInfoCompany={#AppPublisher}
VersionInfoDescription={#AppName} Setup
VersionInfoTextVersion={#AppVersion}
VersionInfoCopyright={#AppPublisher}
MinVersion=4.0.950,5.0.2195
AppCopyright={#AppPublisher}
AppMutex=nextsoft_sms_server_demo
EnableDirDoesntExistWarning=true
AppVersion={#AppVersion}
UninstallDisplayName={#AppName} {#AppVersion}
UninstallDisplayIcon={app}\loader.exe
SetupIconFile={#SetupIconFile}
UserInfoPage=true
PrivilegesRequired=admin

[Types]
Name: full; Description: Full install; Flags: iscustom

[Files]
Source: {#AppBin}\client.bis; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\server.bis; DestDir: {app}; Flags: ignoreversion; Components: server
Source: {#AppBin}\cmx.bpl; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\cmxibase.bpl; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\core.bpl; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\dbrtl100.bpl; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\immess.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\objects.bpl; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\omcom.bpl; DestDir: {app}; Flags: replacesameversion; Components: server
Source: {#AppBin}\rtl100.bpl; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\smsms.bpl; DestDir: {app}; Flags: replacesameversion; Components: server
Source: {#AppBin}\vcl100.bpl; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\vclactnband100.bpl; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\vcldb100.bpl; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\vcliex100.bpl; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\vcljpg100.bpl; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\vclsmp100.bpl; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\vclx100.bpl; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\dbxadapter30.dll; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\dbxint30.dll; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\Firebird-1.5.5.4926-3-Win32.exe; DestDir: {tmp}; Flags: deleteafterinstall ignoreversion; Components: firebird
Source: {#AppBin}\loader.exe; DestDir: {app}; Flags: replacesameversion; Components: server client
Source: {#AppBin}\smssvr.fdb; DestDir: {app}; Flags: confirmoverwrite; Components: server
Source: {#AppBin}\info.hex; DestDir: {app}; Flags: ignoreversion deleteafterinstall; Components: database
Source: {#AppBin}\client.ico; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\server.ico; DestDir: {app}; Flags: ignoreversion; Components: server
Source: {#AppBin}\client.ini; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\nlclient.ini; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\nlserver.ini; DestDir: {app}; Flags: ignoreversion; Components: server
Source: {#AppBin}\server.ini; DestDir: {app}; Flags: ignoreversion; Components: server
Source: {#AppBin}\client.log; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\server.log; DestDir: {app}; Flags: ignoreversion; Components: server
Source: {#AppBin}\cmx.map; DestDir: {app}; Flags: ignoreversion; Components: server client
Source: {#AppBin}\cmxibase.map; DestDir: {app}; Flags: ignoreversion; Components: server client
Source: {#AppBin}\core.map; DestDir: {app}; Flags: ignoreversion; Components: server client
Source: {#AppBin}\immess.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\loader.map; DestDir: {app}; Flags: ignoreversion; Components: server client
Source: {#AppBin}\objects.map; DestDir: {app}; Flags: ignoreversion; Components: server client
Source: {#AppBin}\omcom.map; DestDir: {app}; Flags: ignoreversion; Components: server
Source: {#AppBin}\smsms.map; DestDir: {app}; Flags: ignoreversion; Components: server
Source: {#HistoryFile}; DestDir: {app}; Flags: ignoreversion; Components: server client


[Icons]
Name: {userprograms}\{#AppPublisher}\{#AppName}\Server; Filename: {app}\loader.exe; Parameters: /config server.ini; WorkingDir: {app}; IconFilename: {app}\server.ico; IconIndex: 0; Comment: Run SMS Server Demo; Components: server
Name: {userprograms}\{#AppPublisher}\{#AppName}\Client; Filename: {app}\loader.exe; Parameters: /config client.ini; WorkingDir: {app}; IconFilename: {app}\client.ico; IconIndex: 0; Comment: Run SMS Client Demo; Components: client
Name: {userprograms}\{#AppPublisher}\{#AppName}\Modems; Filename: {app}\loader.exe; Parameters: /config nlserver.ini /command modems; WorkingDir: {app}; IconFilename: {sys}\cmd.exe; IconIndex: 0; Comment: Adjustment modems; Components: server
Name: {userprograms}\{#AppPublisher}\{#AppName}\History; Filename: {app}\history.rtf; WorkingDir: {app}; IconFilename: {app}\history.rtf; Comment: History of versions; Components: server client
Name: {userprograms}\{#AppPublisher}\{#AppName}\Remove; Filename: {uninstallexe}; WorkingDir: {app}; IconFilename: {uninstallexe}; Comment: Remove {#AppName}; Components: server client
Name: {userdesktop}\SMS Server Demo; Filename: {app}\loader.exe; Parameters: /config server.ini; WorkingDir: {app}; IconFilename: {app}\server.ico;  IconIndex: 0; Comment: Run SMS Server Demo; Components: server
Name: {userdesktop}\SMS Client Demo; Filename: {app}\loader.exe; Parameters: /config client.ini; WorkingDir: {app}; IconFilename: {app}\client.ico;  IconIndex: 0; Comment: Run SMS Client Demo; Components: client

[Components]
Name: server; Description: SMS Server Demo 1.0.0.332; Types: full
Name: client; Description: SMS Client Demo 1.0.0.319; Types: full
Name: firebird; Description: Firebird Server 1.5.5.4926; Types: full
Name: database; Description: Demo Database; Types: full

[Run]
Filename: {tmp}\Firebird-1.5.5.4926-3-Win32.exe; Parameters: /silent; WorkingDir: {tmp}; StatusMsg: Installing Firebird and configuring modems ...; Flags: runhidden; Components: firebird
Filename: {app}\loader.exe; Parameters: /config server.ini; WorkingDir: {app}; Flags: postinstall nowait; Description: Run SMS Server Demo; Components: server
Filename: {app}\loader.exe; Parameters: /config client.ini; WorkingDir: {app}; Flags: postinstall nowait unchecked; Description: Run SMS Client Demo; Components: client

[UninstallRun]

[Dirs]

[Code]

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  case CurStep of
    ssPostInstall: begin

      Exec(ExpandConstant('{app}\loader.exe'),'/info info.hex',ExpandConstant('{app}'),SW_HIDE,ewWaitUntilTerminated,ResultCode);

      if WizardForm.ComponentsList.Checked[0] then begin
        Exec(ExpandConstant('{app}\loader.exe'),'/config nlserver.ini /command modems',ExpandConstant('{app}'),SW_SHOWNORMAL,ewWaitUntilTerminated,ResultCode);
      end;

      BringToFrontAndRestore();
    end;
  end;
end;


