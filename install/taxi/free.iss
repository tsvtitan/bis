
#define AppBinDir "free"
#define AppBin SourcePath+"\"+AppBinDir
;#define WizardImage AppBin+"\wizard.bmp";
#define AppVersion GetFileProductVersion(AppBin+"\taxi.exe")
#define AppVersionClient GetFileVersion(AppBin+"\imtaxi.bpl")
#define AppVersionSecure GetFileVersion(AppBin+"\imsecure.bpl")
#define AppVersionFirebird GetFileVersion(AppBin+"\Firebird-2.5.1.26351_1_Win32.exe")
#define AppVersionOrders GetFileVersion(AppBin+"\smtaxi.bpl")
#define AppVersionMessages GetFileVersion(AppBin+"\smsmpp.bpl")
#define AppVersionCalls GetFileVersion(AppBin+"\smcall.bpl")
#define AppVersionMaps GetFileVersion(AppBin+"\smhttpmap.bpl")
#define AppVersionAccess GetFileVersion(AppBin+"\smhttpdef.bpl")
#define AppVersionPayments GetFileVersion(AppBin+"\smhttpplt.bpl")
#define AppVersionMobile GetFileVersion(AppBin+"\smhttpmob.bpl")
#define AppVersionTasks GetFileVersion(AppBin+"\core.bpl")
#define AppVersionSupport GetFileVersion(AppBin+"\smhttpsup.bpl")
#define AppVersionImport GetFileVersion(AppBin+"\imimport.bpl")

#define AppPublisher "NextSoft"
#define AppPublisherURL "http://nextsoft.ru"
#define OutputDir SourcePath+"\_output"
#define SetupIconFile ""

#define AppName "Такси"
#define AppVerName AppName+' '+AppVersion
#define OutputBaseFilename "taxi_free_"+AppVersion+"_18"
#define AppID "{{605FB262-2D8B-4946-AB19-3E05E7E7F948}"

#define DEBUG

[Setup]
AppName={#AppName}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppPublisherURL}
AppSupportURL={#AppPublisherURL}
AppUpdatesURL={#AppPublisherURL}
DefaultDirName={pf}\{#AppPublisher}\{#AppVerName}
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
MinVersion=4.1.1998,5.0.2195
AppCopyright={#AppPublisher}
AppMutex=NextSoft_Taxi
EnableDirDoesntExistWarning=true
AppVersion={#AppVersion}
UninstallDisplayName={#AppName} {#AppVersion}
UninstallDisplayIcon={app}\taxi.exe
SetupIconFile={#SetupIconFile}
UserInfoPage=false
PrivilegesRequired=admin
;WizardImageFile={#WizardImage}
AlwaysShowComponentsList=false

[Languages]
Name: russian; MessagesFile: compiler:Languages\Russian.isl

[Types]
Name: full; Description: "Полная установка"; Flags: iscustom
Name: dbserver; Description: "База данных + Сервер Firebird"; 
Name: server; Description: "Сервера приложений"; 
Name: client; Description: "Клиент"; 

[Files]
Source: {#AppBin}\access.bis; DestDir: {app}; Flags: ignoreversion; Components: access
Source: {#AppBin}\calls.bis; DestDir: {app}; Flags: ignoreversion; Components: calls
Source: {#AppBin}\client.bis; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\import.bis; DestDir: {app}; Flags: ignoreversion; Components: import
Source: {#AppBin}\messages.bis; DestDir: {app}; Flags: ignoreversion; Components: messages
Source: {#AppBin}\mobile.bis; DestDir: {app}; Flags: ignoreversion; Components: mobile
Source: {#AppBin}\maps.bis; DestDir: {app}; Flags: ignoreversion; Components: maps
Source: {#AppBin}\orders.bis; DestDir: {app}; Flags: ignoreversion; Components: orders
Source: {#AppBin}\payments.bis; DestDir: {app}; Flags: ignoreversion; Components: payments
Source: {#AppBin}\secure.bis; DestDir: {app}; Flags: ignoreversion; Components: secure
Source: {#AppBin}\support.bis; DestDir: {app}; Flags: ignoreversion; Components: support
Source: {#AppBin}\tasks.bis; DestDir: {app}; Flags: ignoreversion; Components: tasks

Source: {#AppBin}\cmhttp.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\cmuibase.bpl; DestDir: {app}; Flags: replacesameversion; Components: client import orders messages calls access payments mobile tasks
Source: {#AppBin}\core.bpl; DestDir: {app}; Flags: replacesameversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\dbrtl100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\imaudio.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\imcall.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\imdesign.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\imimport.bpl; DestDir: {app}; Flags: replacesameversion; Components: import
Source: {#AppBin}\immap.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\immess.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\imsecure.bpl; DestDir: {app}; Flags: replacesameversion; Components: secure
Source: {#AppBin}\imsupport.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\imtaxi.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\inet100.bpl; DestDir: {app}; Flags: replacesameversion; Components: maps access payments mobile support
Source: {#AppBin}\objects.bpl; DestDir: {app}; Flags: replacesameversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\omaudio.bpl; DestDir: {app}; Flags: replacesameversion; Components: client calls
Source: {#AppBin}\omcom.bpl; DestDir: {app}; Flags: replacesameversion; Components: messages
Source: {#AppBin}\omnet.bpl; DestDir: {app}; Flags: replacesameversion; Components: client maps access payments mobile support
Source: {#AppBin}\rpmfast.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\rtl100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\smcall.bpl; DestDir: {app}; Flags: replacesameversion; Components: calls
Source: {#AppBin}\smcallback.bpl; DestDir: {app}; Flags: replacesameversion; Components: calls
Source: {#AppBin}\smcallevt.bpl; DestDir: {app}; Flags: replacesameversion; Components: calls
Source: {#AppBin}\smcallsip.bpl; DestDir: {app}; Flags: replacesameversion; Components: calls
Source: {#AppBin}\smgsm.bpl; DestDir: {app}; Flags: replacesameversion; Components: messages
Source: {#AppBin}\smhttp.bpl; DestDir: {app}; Flags: replacesameversion; Components: maps access payments mobile support
Source: {#AppBin}\smhttpdef.bpl; DestDir: {app}; Flags: replacesameversion; Components: access
Source: {#AppBin}\smhttpfls.bpl; DestDir: {app}; Flags: replacesameversion; Components: support
Source: {#AppBin}\smhttping.bpl; DestDir: {app}; Flags: replacesameversion; Components: maps
Source: {#AppBin}\smhttpmap.bpl; DestDir: {app}; Flags: replacesameversion; Components: maps
Source: {#AppBin}\smhttpmob.bpl; DestDir: {app}; Flags: replacesameversion; Components: mobile
Source: {#AppBin}\smhttpplt.bpl; DestDir: {app}; Flags: replacesameversion; Components: payments
Source: {#AppBin}\smhttpsup.bpl; DestDir: {app}; Flags: replacesameversion; Components: support
Source: {#AppBin}\smhttpupd.bpl; DestDir: {app}; Flags: replacesameversion; Components: support
Source: {#AppBin}\smsmpp.bpl; DestDir: {app}; Flags: replacesameversion; Components: messages
Source: {#AppBin}\smtaxi.bpl; DestDir: {app}; Flags: replacesameversion; Components: orders
Source: {#AppBin}\smudpevt.bpl; DestDir: {app}; Flags: replacesameversion; Components: client orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\tee7100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\teedb7100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\teeui7100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client
Source: {#AppBin}\vcl100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\vclactnband100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\vcldb100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\vcliex100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\vclimg100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\vcljpg100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\vclx100.bpl; DestDir: {app}; Flags: replacesameversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\udfibase.dll; DestDir: {app}; Flags: replacesameversion; Components: firebird

Source: {#AppBin}\taxi.exe; DestDir: {app}; Flags: replacesameversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\Firebird-2.5.1.26351_1_Win32.exe; DestDir: {tmp}; Flags: deleteafterinstall ignoreversion; Components: firebird client import orders messages calls access payments mobile tasks

Source: {#AppBin}\taxi.fdb; DestDir: {app}\db; Flags: confirmoverwrite uninsneveruninstall; Components: database

Source: {#AppBin}\access.ini; DestDir: {app}; Flags: ignoreversion; Components: access
Source: {#AppBin}\calls.ini; DestDir: {app}; Flags: ignoreversion; Components: calls
Source: {#AppBin}\client.ini; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\client.ini; DestDir: {app}; DestName: config.ini; Flags: ignoreversion; Components: client
Source: {#AppBin}\import.ini; DestDir: {app}; Flags: ignoreversion; Components: import
Source: {#AppBin}\messages.ini; DestDir: {app}; Flags: ignoreversion; Components: messages
Source: {#AppBin}\mobile.ini; DestDir: {app}; Flags: ignoreversion; Components: mobile
Source: {#AppBin}\maps.ini; DestDir: {app}; Flags: ignoreversion; Components: maps
Source: {#AppBin}\orders.ini; DestDir: {app}; Flags: ignoreversion; Components: orders
Source: {#AppBin}\payments.ini; DestDir: {app}; Flags: ignoreversion; Components: payments
Source: {#AppBin}\secure.ini; DestDir: {app}; Flags: ignoreversion; Components: secure
Source: {#AppBin}\support.ini; DestDir: {app}; Flags: ignoreversion; Components: support
Source: {#AppBin}\tasks.ini; DestDir: {app}; Flags: ignoreversion; Components: tasks

Source: {#AppBin}\taxi.jar; DestDir: {app}; Flags: ignoreversion; Components: javaclient

#ifdef DEBUG
Source: {#AppBin}\cmhttp.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\cmuibase.map; DestDir: {app}; Flags: ignoreversion; Components: client import orders messages calls access payments mobile tasks
Source: {#AppBin}\core.map; DestDir: {app}; Flags: ignoreversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\imaudio.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\imcall.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\imdesign.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\imimport.map; DestDir: {app}; Flags: ignoreversion; Components: import
Source: {#AppBin}\immap.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\immess.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\imsecure.map; DestDir: {app}; Flags: ignoreversion; Components: secure
Source: {#AppBin}\imsupport.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\imtaxi.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\objects.map; DestDir: {app}; Flags: ignoreversion; Components: client import secure orders messages calls maps access payments mobile tasks support
Source: {#AppBin}\omaudio.map; DestDir: {app}; Flags: ignoreversion; Components: client calls
Source: {#AppBin}\omcom.map; DestDir: {app}; Flags: ignoreversion; Components: messages
Source: {#AppBin}\omnet.map; DestDir: {app}; Flags: ignoreversion; Components: client maps access payments mobile support
Source: {#AppBin}\rpmfast.map; DestDir: {app}; Flags: ignoreversion; Components: client
Source: {#AppBin}\smcall.map; DestDir: {app}; Flags: ignoreversion; Components: calls
Source: {#AppBin}\smcallback.map; DestDir: {app}; Flags: ignoreversion; Components: calls
Source: {#AppBin}\smcallevt.map; DestDir: {app}; Flags: ignoreversion; Components: calls
Source: {#AppBin}\smcallsip.map; DestDir: {app}; Flags: ignoreversion; Components: calls
Source: {#AppBin}\smgsm.map; DestDir: {app}; Flags: ignoreversion; Components: messages
Source: {#AppBin}\smhttp.map; DestDir: {app}; Flags: ignoreversion; Components: maps access payments mobile support
Source: {#AppBin}\smhttpdef.map; DestDir: {app}; Flags: ignoreversion; Components: access
Source: {#AppBin}\smhttpfls.map; DestDir: {app}; Flags: ignoreversion; Components: support
Source: {#AppBin}\smhttping.map; DestDir: {app}; Flags: ignoreversion; Components: maps
Source: {#AppBin}\smhttpmap.map; DestDir: {app}; Flags: ignoreversion; Components: maps
Source: {#AppBin}\smhttpmob.map; DestDir: {app}; Flags: ignoreversion; Components: mobile
Source: {#AppBin}\smhttpplt.map; DestDir: {app}; Flags: ignoreversion; Components: payments
Source: {#AppBin}\smhttpsup.map; DestDir: {app}; Flags: ignoreversion; Components: support
Source: {#AppBin}\smhttpupd.map; DestDir: {app}; Flags: ignoreversion; Components: support
Source: {#AppBin}\smsmpp.map; DestDir: {app}; Flags: ignoreversion; Components: messages
Source: {#AppBin}\smtaxi.map; DestDir: {app}; Flags: ignoreversion; Components: orders
Source: {#AppBin}\smudpevt.map; DestDir: {app}; Flags: ignoreversion; Components: client orders messages calls maps access payments mobile tasks support
#endif

Source: {#AppBin}\config.xml; DestDir: {app}; Flags: replacesameversion; Components: javaclient

[Icons]
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Клиент; Filename: {app}\taxi.exe; Parameters: /config client.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Клиент [{#AppVersionClient}]; IconIndex: 0; Components: client
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Клиент Мобильный; Filename: {app}\taxi.jar; WorkingDir: {app}; IconFilename: {app}\taxi.jar; Comment: Клиент Мобильный [2.1]; IconIndex: 0; Components: javaclient
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Редактор настроек; Filename: {app}\taxi.exe; Parameters: /config secure.ini /command info info.hex; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Редактор настроек [{#AppVersionSecure}]; IconIndex: 0; Components: secure
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Импорт скриптов и данных; Filename: {app}\taxi.exe; Parameters: /config import.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Импорт скриптов и данных [{#AppVersionImport}]; IconIndex: 0; Components: import
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Сервер Заказов; Filename: {app}\taxi.exe; Parameters: /config orders.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Заказов [{#AppVersionOrders}]; IconIndex: 0; Components: orders
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Сервер Сообщений; Filename: {app}\taxi.exe; Parameters: /config messages.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Сообщений [{#AppVersionMessages}]; IconIndex: 0; Components: messages
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Сервер Телефонии; Filename: {app}\taxi.exe; Parameters: /config calls.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Телефонии [{#AppVersionCalls}]; IconIndex: 0; Components: calls
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Сервер Карт; Filename: {app}\taxi.exe; Parameters: /config maps.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Карт [{#AppVersionMaps}]; IconIndex: 0; Components: maps
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Сервер Доступа; Filename: {app}\taxi.exe; Parameters: /config maps.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Доступа [{#AppVersionAccess}]; IconIndex: 0; Components: access
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Сервер Платежей; Filename: {app}\taxi.exe; Parameters: /config maps.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Платежей [{#AppVersionPayments}]; IconIndex: 0; Components: payments
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Сервер Мобильный; Filename: {app}\taxi.exe; Parameters: /config mobile.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Мобильный [{#AppVersionMobile}]; IconIndex: 0; Components: mobile
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Сервер Заданий; Filename: {app}\taxi.exe; Parameters: /config tasks.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Заданий [{#AppVersionTasks}]; IconIndex: 0; Components: tasks
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Сервер Поддержки; Filename: {app}\taxi.exe; Parameters: /config support.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Поддержки [{#AppVersionSupport}]; IconIndex: 0; Components: support
Name: {userprograms}\{#AppPublisher}\{#AppVerName}\Удалить {#AppName}; Filename: {uninstallexe}; WorkingDir: {app}; IconFilename: {uninstallexe}; Comment: Удалить {#AppVerName}

Name: {userdesktop}\Клиент; Filename: {app}\taxi.exe; Parameters: /config client.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Клиент [{#AppVersionClient}]; IconIndex: 0; Components: client

Name: {app}\client; Filename: {app}\taxi.exe; Parameters: /config client.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Клиент [{#AppVersionClient}]; IconIndex: 0; Components: client
Name: {app}\secure; Filename: {app}\taxi.exe; Parameters: /config secure.ini /command info info.hex; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Редактор настроек [{#AppVersionSecure}]; IconIndex: 0; Components: secure
Name: {app}\import; Filename: {app}\taxi.exe; Parameters: /config import.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Импорт скриптов и данных [{#AppVersionImport}]; IconIndex: 0; Components: import
Name: {app}\orders; Filename: {app}\taxi.exe; Parameters: /config orders.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Заказов [{#AppVersionOrders}]; IconIndex: 0; Components: orders
Name: {app}\messages; Filename: {app}\taxi.exe; Parameters: /config messages.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Сообщений [{#AppVersionMessages}]; IconIndex: 0; Components: messages
Name: {app}\calls; Filename: {app}\taxi.exe; Parameters: /config calls.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Телефонии [{#AppVersionCalls}]; IconIndex: 0; Components: calls
Name: {app}\maps; Filename: {app}\taxi.exe; Parameters: /config maps.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Карт [{#AppVersionMaps}]; IconIndex: 0; Components: maps
Name: {app}\access; Filename: {app}\taxi.exe; Parameters: /config access.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Доступа [{#AppVersionAccess}]; IconIndex: 0; Components: access
Name: {app}\payments; Filename: {app}\taxi.exe; Parameters: /config payments.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Платежей [{#AppVersionPayments}]; IconIndex: 0; Components: payments
Name: {app}\mobile; Filename: {app}\taxi.exe; Parameters: /config mobile.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Мобильный [{#AppVersionMobile}]; IconIndex: 0; Components: mobile
Name: {app}\tasks; Filename: {app}\taxi.exe; Parameters: /config tasks.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Заданий [{#AppVersionTasks}]; IconIndex: 0; Components: tasks
Name: {app}\support; Filename: {app}\taxi.exe; Parameters: /config support.ini; WorkingDir: {app}; IconFilename: {app}\taxi.exe; Comment: Сервер Поддержки [{#AppVersionSupport}]; IconIndex: 0; Components: support

[Components]
Name: client; Description: "Клиент [{#AppVersionClient}]"; Types: client full
Name: javaclient; Description: "Клиент Мобильный [2.1]"; Types: client full
Name: secure; Description: "Редактор настроек [{#AppVersionSecure}]"; Types: server full
Name: import; Description: "Импорт скриптов и данных [{#AppVersionImport}]"; Types: server full
Name: database; Description: "База данных под Firebird"; Types: dbserver full
Name: firebird; Description: "Сервер Firebird [{#AppVersionFirebird}]"; Types: dbserver full
Name: orders; Description: "Сервер Заказов [{#AppVersionOrders}]"; Types: server full
Name: messages; Description: "Сервер Сообщений [{#AppVersionMessages}]"; Types: server full
Name: calls; Description: "Сервер Телефонии [{#AppVersionCalls}]"; Types: server full
Name: maps; Description: "Сервер Карт [{#AppVersionMaps}]"; Types: server full
Name: access; Description: "Сервер Доступа [{#AppVersionAccess}]"; Types: server full
Name: payments; Description: "Сервер Платежей [{#AppVersionPayments}]"; Types: server full
Name: mobile; Description: "Сервер Мобильный [{#AppVersionMobile}]"; Types: server full
Name: tasks; Description: "Сервер Заданий [{#AppVersionTasks}]"; Types: server full
Name: support; Description: "Сервер Поддержки [{#AppVersionSupport}]"; Types: server full

[Run]
Filename: {tmp}\Firebird-2.5.1.26351_1_Win32.exe; Parameters: "/sp- /verysilent /nocancel /components=""ClientComponent"""; WorkingDir: {tmp}; StatusMsg: Установка клиента базы данных ...; Flags: runhidden; Components: client orders messages calls access payments mobile tasks import
Filename: {tmp}\Firebird-2.5.1.26351_1_Win32.exe; Parameters: "/sp- /verysilent /nocancel /suppressmsgboxes /force /components=""ServerComponent\SuperServerComponent,ServerComponent,DevAdminComponen"""; WorkingDir: {tmp}; StatusMsg: Установка сервера базы данных ...; Flags: runhidden; Components: firebird
Filename: {app}\taxi.exe; WorkingDir: {app}; Parameters: /config client.ini; Flags: nowait postinstall skipifsilent; Description: Запустить Клиент; Components: client

[Dirs]
Name: {app}\logs\client; Components: client
Name: {app}\logs\secure; Components: secure
Name: {app}\logs\import; Components: import
Name: {app}\db; Components: database
Name: {app}\logs\orders; Components: orders
Name: {app}\logs\messages; Components: messages
Name: {app}\logs\calls; Components: calls
Name: {app}\logs\maps; Components: maps
Name: {app}\logs\access; Components: access
Name: {app}\logs\payments; Components: payments
Name: {app}\logs\mobile; Components: mobile
Name: {app}\logs\tasks; Components: tasks
Name: {app}\logs\support; Components: support

[Code]
var
  PageKey: TWizardPage;
  PageDatabase: TWizardPage; 
  EditKey: TEdit;
  MemoLicense: TMemo;
  EditDatabase: TEdit;

function PageKeyCreate(PreviousPageId: Integer): Integer;
var
  LabelInfo: TLabel;
  LabelKey: TLabel;
  LabelLicense: TLabel;
begin
  PageKey := CreateCustomPage(PreviousPageId,
                              'Настройка лицензии',
                              'Пожалуйста, введите ключ и лицензию.');

  LabelInfo := TLabel.Create(PageKey);
  with LabelInfo do
  begin
    Parent := PageKey.Surface;
    Caption :='   Для работы программы {#AppName}, необходимо указать ключ и лицензию.';
    Left := ScaleX(0);
    Top := ScaleY(8);
    Width := ScaleX(400);
    Height := ScaleY(55);
    AutoSize := False;
    WordWrap := True;
  end;

  LabelKey := TLabel.Create(PageKey);
  with LabelKey do
  begin
    Parent := PageKey.Surface;
    Caption :='Ключ:';
    Left := ScaleX(0);
    Top := ScaleY(52);
    Width := ScaleX(94);
    Height := ScaleY(13);
    Alignment := taRightJustify;
  end;
  
  EditKey := TEdit.Create(PageKey);
  with EditKey do
  begin
    Parent := PageKey.Surface;
    Left := ScaleX(100);
    Top := ScaleY(50);
    Width := ScaleX(280);
    Height := ScaleY(21);
    TabOrder := 1;
  end;

  LabelKey.FocusControl := EditKey;
  
  LabelLicense := TLabel.Create(PageKey);
  with LabelLicense do
  begin
    Parent := PageKey.Surface;
    Caption :='Лицензия:';
    Left := ScaleX(10);
    Top := ScaleY(90);
    Width := ScaleX(84);
    Height := ScaleY(13);
    Alignment := taRightJustify;
  end;

  MemoLicense := TMemo.Create(PageKey);
  with MemoLicense do
  begin
    Parent := PageKey.Surface;
    Left := ScaleX(100);
    Top := ScaleY(90);
    Width := ScaleX(280);
    Height := ScaleY(63);
    TabOrder := 2;
    WordWrap:=true;
  end;

  LabelLicense.FocusControl := MemoLicense;
  
  Result := PageKey.ID;
end;

function PageDatabaseSelect(PreviousPageId: Integer): Integer;
var
  LabelInfo: TLabel;
  LabelDatabase: TLabel;
begin
  PageDatabase := CreateCustomPage(PreviousPageId,
                                   'Выбор базы данных',
                                   'Пожалуйста, введите путь к базе данных с учетом сервера.');

  LabelInfo := TLabel.Create(PageDatabase);
  with LabelInfo do
  begin
    Parent := PageDatabase.Surface;
    Caption :='   Для работы программы {#AppName} с базой данных, необходимо указать путь.';
    Left := ScaleX(0);
    Top := ScaleY(8);
    Width := ScaleX(400);
    Height := ScaleY(55);
    AutoSize := False;
    WordWrap := True;
  end;

  LabelDatabase := TLabel.Create(PageDatabase);
  with LabelDatabase do
  begin
    Parent := PageDatabase.Surface;
    Caption :='Путь:';
    Left := ScaleX(0);
    Top := ScaleY(88);
    Width := ScaleX(94);
    Height := ScaleY(13);
    Alignment := taRightJustify;
  end;

  EditDatabase := TEdit.Create(PageDatabase);
  with EditDatabase do
  begin
    Parent := PageDatabase.Surface;
    Left := ScaleX(102);
    Top := ScaleY(86);
    Width := ScaleX(280);
    Height := ScaleY(21);
    TabOrder := 1;
  end;

  LabelDatabase.FocusControl := EditDatabase;
  
  Result := PageDatabase.ID;
end;

procedure InitializeWizard();
var
  PageID: Integer;
begin
  PageID:=PageKeyCreate(wpSelectComponents);
  PageDatabaseSelect(PageID);
end;

function IsClient(var Index: Integer): Boolean;
begin
  Index:=0;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function IsSecure(var Index: Integer): Boolean;
begin
  Index:=2;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function IsImport(var Index: Integer): Boolean;
begin
  Index:=3;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function IsDatabase(var Index: Integer): Boolean;
begin
  Index:=4;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function IsFirebird(var Index: Integer): Boolean;
begin
  Index:=5;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function IsOrders(var Index: Integer): Boolean;
begin
  Index:=6;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function IsMessages(var Index: Integer): Boolean;
begin
  Index:=7;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function IsCalls(var Index: Integer): Boolean;
begin
  Index:=8;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function IsMaps(var Index: Integer): Boolean;
begin
  Index:=9;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function IsAccess(var Index: Integer): Boolean;
begin
  Index:=10;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function IsPayments(var Index: Integer): Boolean;
begin
  Index:=11;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function IsMobile(var Index: Integer): Boolean;
begin
  Index:=12;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function IsTasks(var Index: Integer): Boolean;
begin
  Index:=13;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function IsSupport(var Index: Integer): Boolean;
begin
  Index:=14;
  Result:=WizardForm.ComponentsList.Checked[Index];
end;

function NeedKeyCreate: Boolean;
var
  Index: Integer;
begin
  Result:=IsClient(Index) or 
          IsSecure(Index) or 
          IsImport(Index) or 
          IsOrders(Index) or 
          IsMessages(Index) or 
          IsCalls(Index) or 
          IsMaps(Index) or 
          IsAccess(Index) or 
          IsPayments(Index) or 
          IsMobile(Index) or 
          IsTasks(Index) or 
          IsSupport(Index);
end;

function NeedDatabaseSelect: Boolean;
var
  Index: Integer;
begin
  Result:=IsClient(Index) or
          IsImport(Index) or
          IsOrders(Index) or
          IsMessages(Index) or
          IsCalls(Index) or
          IsAccess(Index) or
          IsPayments(Index) or
          IsMobile(Index) or
          IsTasks(Index);
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result:=false;
  if PageID=PageKey.ID then
    Result:=not NeedKeyCreate
  else if PageID=PageDatabase.ID then
    Result:=not NeedDatabaseSelect;   
end;

function CheckLicense: Boolean;
begin
  Result:=Trim(MemoLicense.Text)<>'';
end;

function CheckKey: Boolean;
begin
  Result:=Trim(EditKey.Text)<>'';
end;

function CheckDatabase: Boolean;
begin
  Result:=Trim(EditDatabase.Text)<>'';
end;

function DefaultDatabase: String;
var
  Host: String;
  Index: Integer;
begin
  Result:='';
  if IsFirebird(Index) then
    Host:='localhost'
  else Host:='server'; 
  if IsDatabase(Index) then 
    Result:=Host+':'+ExpandConstant('{app}\db\taxi.fdb')
  else  
    Result:=Host+':path\taxi.fdb';
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  S: String;
begin
  Result:=true;
  if CurPageID=wpSelectComponents then begin
    if NeedDatabaseSelect then begin
      S:=DefaultDatabase;
      if (Trim(EditDatabase.Text)='') and (S<>EditDatabase.Text) then
        EditDatabase.Text:=S;
    end;  
  end else if CurPageID=PageKey.ID then begin
    Result:=CheckLicense and CheckKey;
    if not Result then
      MsgBox('Не указан ключ ил лицензия.',mbError,MB_OK);
  end else if CurPageID=PageDatabase.ID then begin
    Result:=CheckDatabase;
    if not Result then  
      MsgBox('Не указан путь.',mbError,MB_OK);
  end;
end;

function GetFirebirdPath: String;
begin
  RegQueryStringValue(HKEY_LOCAL_MACHINE,'SOFTWARE\Firebird Project\Firebird Server\Instances','DefaultInstance',Result);
end;

procedure ReSaveByKey(Index: Integer; Key,Config: String);
var
  Params: String;
  ResultCode: Integer;
begin
  WizardForm.StatusLabel.Caption:='Настройка ключа и лицензии: '+WizardForm.ComponentsList.ItemCaption[Index]+' ...';
  Params:='/config '+Config+' /set License='+Trim(MemoLicense.Text);
  Exec(ExpandConstant('{app}\taxi.exe'),Params,ExpandConstant('{app}'),SW_HIDE,ewWaitUntilTerminated,ResultCode);
  Params:='/config '+Config+' /920C7934688DE6FCC4392CFF5C7B7A65 '+Key+' '+' info.hex';
  Exec(ExpandConstant('{app}\taxi.exe'),Params,ExpandConstant('{app}'),SW_HIDE,ewWaitUntilTerminated,ResultCode);
  BringToFrontAndRestore();
end;

procedure InstallServiceAndRun(Index: Integer; Config,ServiceName: String; WithFirebird: Boolean);
var
  Params: String;
  ResultCode: Integer;
begin
  WizardForm.StatusLabel.Caption:='Установка и запуск службы: '+WizardForm.ComponentsList.ItemCaption[Index]+' ...';
  if WithFirebird then begin
    Params:='/config '+Config+' /set';
    Params:=Params+' ConnectionModules\[NAME|UIBase|CONNECTIONS]\[NAME|Default|PARAMS]\[NAME|Database|VALUE]="'+EditDatabase.Text+'"'; 
    Exec(ExpandConstant('{app}\taxi.exe'),Params,ExpandConstant('{app}'),SW_HIDE,ewWaitUntilTerminated,ResultCode);
  end;
  Params:='/config '+Config+' /install /service name="'+ServiceName+'" display="$title [$version]"'; 
  if WithFirebird and IsFirebird(Index) then
    Params:=Params+' dependencies=FirebirdServerDefaultInstance';
  Exec(ExpandConstant('{app}\taxi.exe'),Params,ExpandConstant('{app}'),SW_HIDE,ewWaitUntilTerminated,ResultCode);
  Params:='start '+ServiceName;
  Exec(ExpandConstant('{sys}\net'),Params,ExpandConstant('{sys}'),SW_HIDE,ewWaitUntilTerminated,ResultCode);
  BringToFrontAndRestore();
end;

procedure StopServiceAndUninstall(Config,ServiceName: String);
var
  Params: String;
  ResultCode: Integer;
  S: String;
begin
  S:=ExpandConstant('{app}\'+Config);
  if FileExists(S) then begin 
    Params:='stop '+ServiceName;
    Exec(ExpandConstant('{sys}\net'),Params,ExpandConstant('{sys}'),SW_HIDE,ewWaitUntilTerminated,ResultCode);
    Params:='/config '+Config+' /uninstall /service name="'+ServiceName; 
    Exec(ExpandConstant('{app}\taxi.exe'),Params,ExpandConstant('{app}'),SW_HIDE,ewWaitUntilTerminated,ResultCode);
    BringToFrontAndRestore();
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
  UdfDir: String;
  UdfFile: String;
  KeyHash: String;
  Index: Integer;
begin
  case CurStep of
    ssPostInstall: begin

      if NeedKeyCreate then begin
      
        KeyHash:=UpperCase(GetMD5OfString(EditKey.Text));
        
        if IsClient(Index) then ReSaveByKey(Index,KeyHash,'client.ini');
        if IsSecure(Index) then ReSaveByKey(Index,KeyHash,'secure.ini');
        if IsImport(Index) then ReSaveByKey(Index,KeyHash,'import.ini');
        if IsOrders(Index) then ReSaveByKey(Index,KeyHash,'orders.ini');
        if IsMessages(Index) then ReSaveByKey(Index,KeyHash,'messages.ini');
        if IsCalls(Index) then ReSaveByKey(Index,KeyHash,'calls.ini');
        if IsMaps(Index) then ReSaveByKey(Index,KeyHash,'maps.ini');
        if IsAccess(Index) then ReSaveByKey(Index,KeyHash,'access.ini');
        if IsPayments(Index) then ReSaveByKey(Index,KeyHash,'payments.ini');
        if IsMobile(Index) then ReSaveByKey(Index,KeyHash,'mobile.ini');
        if IsTasks(Index) then ReSaveByKey(Index,KeyHash,'tasks.ini');
        if IsSupport(Index) then ReSaveByKey(Index,KeyHash,'support.ini');
        
        Exec(ExpandConstant('{app}\taxi.exe'),'/info info.hex',ExpandConstant('{app}'),SW_HIDE,ewWaitUntilTerminated,ResultCode);
      end;

      if IsFirebird(Index) then begin 
        UdfDir:=GetFirebirdPath+'udf';
        UdfFile:=ExpandConstant('{app}\udfibase.dll');
        if DirExists(UdfDir) and FileExists(UdfFile) then
          FileCopy(UdfFile,UdfDir+'\udfibase.dll',false);
        BringToFrontAndRestore();  
      end;
      
      if IsOrders(Index) then InstallServiceAndRun(Index,'orders.ini','TaxiServerOrders',true);
      if IsMessages(Index) then InstallServiceAndRun(Index,'messages.ini','TaxiServerMessages',true);
      if IsCalls(Index) then InstallServiceAndRun(Index,'calls.ini','TaxiServerCalls',true);
      if IsMaps(Index) then InstallServiceAndRun(Index,'maps.ini','TaxiServerMaps',false);
      if IsAccess(Index) then InstallServiceAndRun(Index,'access.ini','TaxiServerAccess',true);
      if IsPayments(Index) then InstallServiceAndRun(Index,'payments.ini','TaxiServerPayments',true);
      if IsMobile(Index) then InstallServiceAndRun(Index,'mobile.ini','TaxiServerMobile',true);
      if IsTasks(Index) then InstallServiceAndRun(Index,'tasks.ini','TaxiServerTasks',true);
      if IsSupport(Index) then InstallServiceAndRun(Index,'support.ini','TaxiServerSupport',false);
      
      BringToFrontAndRestore();
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep); 
begin
  case CurUninstallStep of
    usUninstall: begin
     
      StopServiceAndUninstall('orders.ini','TaxiServerOrders');
      StopServiceAndUninstall('messages.ini','TaxiServerMessages');
      StopServiceAndUninstall('calls.ini','TaxiServerCalls');
      StopServiceAndUninstall('maps.ini','TaxiServerMaps');
      StopServiceAndUninstall('access.ini','TaxiServerAccess');
      StopServiceAndUninstall('payments.ini','TaxiServerPayments');
      StopServiceAndUninstall('mobile.ini','TaxiServerMobile');
      StopServiceAndUninstall('tasks.ini','TaxiServerTasks');
      StopServiceAndUninstall('support.ini','TaxiServerSupport');
      
      BringToFrontAndRestore();
    end;
  end;
end;


