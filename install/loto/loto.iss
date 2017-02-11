; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT files!

#define AppBinDir "loto"
#define AppBin SourcePath+"\"+AppBinDir
#define WizardImage AppBin+"\wizard.bmp";
#define AppVersion GetFileVersion(AppBin+"\imloto.bpl")
#define AppPublisher "DMD"
#define AppPublisherURL "http://www.dmd.akadem.ru"
#define OutputDir SourcePath+"\_output"
#define SetupIconFile ""

#define AppName "���� �� ������"
#define OutputBaseFilename "loto_"+AppVersion
#define AppID "{{58671524-E040-408A-90C5-760151B78DD5}"

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
AppMutex=DMD_Loto
EnableDirDoesntExistWarning=true
AppVersion={#AppVersion}
UninstallDisplayName={#AppName} {#AppVersion}
UninstallDisplayIcon={app}\loto.exe
SetupIconFile={#SetupIconFile}
UserInfoPage=false
PrivilegesRequired=admin
WizardImageFile={#WizardImage}
AlwaysShowComponentsList=false

[Languages]
Name: russian; MessagesFile: compiler:Languages\Russian.isl

[Types]
Name: full; Description: Full install; Flags: iscustom

[Files]
Source: {#AppBin}\loto.bis; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\cmx.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\cmxibase.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\core.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\dbrtl100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\imdesign.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\imimport.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\imloto.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\objects.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\omcom.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\rpmfast.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\rtl100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\tee7100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\teedb7100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\teeui7100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\vcl100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\vclactnband100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\vcldb100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\vcliex100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\vcljpg100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\vclx100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\dbxadapter30.dll; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\dbxint30.dll; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\gds32.dll; DestDir: {sys}; Flags: replacesameversion; Components: client
Source: {#AppBin}\Firebird-1.5.6.5026-0-Win32.exe; DestDir: {tmp}; Flags: deleteafterinstall ignoreversion; Components: firebird
Source: {#AppBin}\loto.exe; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\loto.fdb; DestDir: {app}; Flags: confirmoverwrite uninsneveruninstall; Components: database
Source: {#AppBin}\info.hex; DestDir: {app}; Flags: ignoreversion deleteafterinstall; Components: client
Source: {#AppBin}\config.ini; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\cmx.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\cmxibase.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\core.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\imdesign.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\imloto.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\loto.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\objects.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\omcom.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\rpmfast.map; DestDir: {app}; Flags: ignoreversion; Components: client

[Icons]
Name: {userprograms}\{#AppPublisher}\{#AppName}\��������� {#AppName}; Filename: {app}\loto.exe; WorkingDir: {app}; IconFilename: {app}\loto.exe; Comment: ��������� {#AppName} {#AppVersion}; IconIndex: 0; Components: client
Name: {userprograms}\{#AppPublisher}\{#AppName}\������� {#AppName}; Filename: {uninstallexe}; WorkingDir: {app}; IconFilename: {uninstallexe}; Comment: ������� {#AppName} {#AppVersion}
Name: {userdesktop}\{#AppName}; Filename: {app}\loto.exe; WorkingDir: {app}; IconFilename: {app}\loto.exe; Comment: {#AppName} {#AppVersion}; IconIndex: 0; Components: client

[Components]
Name: client; Description: ���� �� ������ 1.0.0.120; Types: full
Name: firebird; Description: Firebird Server 1.5.6.5026; Types: full
Name: database; Description: ���� ������ � ������� 001; Types: full

[Run]
Filename: {tmp}\Firebird-1.5.6.5026-0-Win32.exe; Parameters: /silent; WorkingDir: {tmp}; StatusMsg: ��������� Firebird � ��������� ���������� ...; Flags: runhidden; Components: firebird
Filename: {app}\loto.exe; WorkingDir: {app}; Flags: nowait postinstall skipifsilent; Description: ��������� {#AppName}; Components: client

[Code]

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  case CurStep of
    ssPostInstall: begin

      if WizardForm.ComponentsList.Checked[0] then begin
        Exec(ExpandConstant('{app}\loto.exe'),'/info info.hex',ExpandConstant('{app}'),SW_HIDE,ewWaitUntilTerminated,ResultCode);
        Exec(ExpandConstant('{app}\loto.exe'),'/nologin /command connections',ExpandConstant('{app}'),SW_SHOWNORMAL,ewWaitUntilTerminated,ResultCode);
      end;

      BringToFrontAndRestore();
    end;
  end;
end;