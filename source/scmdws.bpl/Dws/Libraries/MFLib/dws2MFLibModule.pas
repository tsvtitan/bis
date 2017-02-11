{**********************************************************************}
{                                                                      }
{    dws2MFLib                                                         }
{                                                                      }
{    A function library for DWSII                                      }
{    Version 1.0 Beta                                                  }
{    July 2001                                                         }
{                                                                      }
{    This software is distributed on an "AS IS" basis,                 }
{    WITHOUT WARRANTY OF ANY KIND, either express or implied.          }
{                                                                      }
{    The Initial Developer of the Original Code is Manfred Fuchs       }
{    Portions created by Manfred Fuchs are Copyright                   }
{    (C) 2001 Manfred Fuchs, Germany. All Rights Reserved.             }
{                                                                      }
{**********************************************************************}

unit dws2MFLibModule;

interface

uses
  {$IFDEF MSWINDOWS}
  Variants,
  {$ENDIF}
  Windows, SysUtils, ShellApi, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, WinSock, IniFiles, dws2Comp, dws2Exprs, dws2Symbols;

const
  CROP_LEFT = 0;
  CROP_RIGHT = 1;

type
  Tdws2MFLib = class(TDataModule)
    dws2UnitBasic: Tdws2Unit;
    dws2UnitConnection: Tdws2Unit;
    dws2UnitDialog: Tdws2Unit;
    dws2UnitFile: Tdws2Unit;
    dws2UnitInfo: Tdws2Unit;
    dws2UnitIniFiles: Tdws2Unit;
    dws2UnitRegistry: Tdws2Unit;
    dws2UnitShell: Tdws2Unit;
    dws2UnitString: Tdws2Unit;
    dws2UnitSystem: Tdws2Unit;
    dws2UnitWindow: Tdws2Unit;
    procedure dws2UnitBasicFunctionsBeepEval(Info: TProgramInfo);
    procedure dws2UnitBasicFunctionsDecEval(Info: TProgramInfo);
    procedure dws2UnitBasicFunctionsDec2Eval(Info: TProgramInfo);
    procedure dws2UnitBasicFunctionsIncEval(Info: TProgramInfo);
    procedure dws2UnitBasicFunctionsInc2Eval(Info: TProgramInfo);
    procedure dws2UnitBasicFunctionsGetTickCountEval(Info: TProgramInfo);
    procedure dws2UnitBasicFunctionsSleepEval(Info: TProgramInfo);
    procedure dws2UnitBasicFunctionsWriteLnEval(Info: TProgramInfo);
    procedure dws2UnitConnFunctionsConnectedEval(Info: TProgramInfo);
    procedure dws2UnitConnFunctionsIPAddressEval(Info: TProgramInfo);
    procedure dws2UnitDialogFunctionsSelectStringDialogEval(
      Info: TProgramInfo);
    procedure dws2UnitFileFunctionsDescCopyEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsDescListCreateEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsDescListReadEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsDescMoveEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsDescReadEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsDescWriteEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsOpenDialogEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsOpenDialogMultiEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsSaveDialogEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsCDCloseEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsCDOpenEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsGetCRC32FromFileEval(
      Info: TProgramInfo);
    procedure dws2UnitFileFunctionsGetDriveNameEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsGetDriveNumEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsGetDriveReadyEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsGetDriveSerialEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsGetDriveTypeEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsDirectoryExistsEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsDirectoryListEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsCopyFileEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsFileDateEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsFileListEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsFileSizeEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsMakePathEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsMoveFileEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsMoveFileExEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsReadOnlyPathEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsSplitPathEval(Info: TProgramInfo);
    procedure dws2UnitFileFunctionsSubdirectoryExistsEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetAllUsersDesktopDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetAllUsersProgramsDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetAllUsersStartmenuDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetAllUsersStartupDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetAppdataDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetCacheDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetChannelFolderNameEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetCommonFilesDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetComputerNameEval(Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetConsoleTitleEval(Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetCookiesDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetCPUSpeedEval(Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetDesktopDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetDevicePathEval(Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetEnvironmentVariableEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetFavoritesDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetFontsDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetHistoryDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetLinkfolderNameEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetMediaPathEval(Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetNethoodDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetPersonalDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetPFAccessoriesNameEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetPrinthoodDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetProgramfilesDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetProgramsDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetRecentDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetSendtoDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetSMAccessoriesNameEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetStartmenuDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetStartupDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetSystemDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetTempDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetTemplatesDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetUserNameEval(Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetVersionEval(Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetWallpaperDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetWindowsDirectoryEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsGetWindowsVersionEval(
      Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsIsWin2000Eval(Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsIsWin9xEval(Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsIsWinNTEval(Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsIsWinNT4Eval(Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsSetComputerNameEval(Info: TProgramInfo);
    procedure dws2UnitInfoFunctionsSetConsoleTitleEval(Info: TProgramInfo);
    procedure dws2UnitIniFilesClassesTIniFileMethodsDestroyEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsDeleteKeyEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsEraseSectionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsReadBoolEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsReadDateEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsReadDateTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsReadFileNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsReadFloatEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsReadIntegerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsReadSectionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsReadSectionsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsReadSectionValuesEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsReadStringEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsReadTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsSectionExistsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsUpdateFileEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsWriteBoolEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsWriteDateEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsWriteDateTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsWriteFloatEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsWriteIntegerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsWriteStringEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsWriteTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitIniFilesClassesTIniFileMethodsValueExistsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitRegistryFunctionsRegCreateKeyEval(
      Info: TProgramInfo);
    procedure dws2UnitRegistryFunctionsRegDeleteKeyEval(
      Info: TProgramInfo);
    procedure dws2UnitRegistryFunctionsRegDeleteValueEval(
      Info: TProgramInfo);
    procedure dws2UnitRegistryFunctionsRegReadIntegerEval(
      Info: TProgramInfo);
    procedure dws2UnitRegistryFunctionsRegReadStringEval(
      Info: TProgramInfo);
    procedure dws2UnitRegistryFunctionsRegGetTypeEval(Info: TProgramInfo);
    procedure dws2UnitRegistryFunctionsRegKeyExistsEval(
      Info: TProgramInfo);
    procedure dws2UnitRegistryFunctionsRegValueExistsEval(
      Info: TProgramInfo);
    procedure dws2UnitRegistryFunctionsRegWriteIntegerEval(
      Info: TProgramInfo);
    procedure dws2UnitRegistryFunctionsRegWriteStringEval(
      Info: TProgramInfo);
    procedure dws2UnitShellFunctionsDesktopRefreshEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsANSI2OEMEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsChangeTokenValueEval(
      Info: TProgramInfo);
    procedure dws2UnitStringFunctionsChrEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsCmpREEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsCmpWCEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsCropEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsForEachEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsFormatColumnsEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsGetCRC32FromStringEval(
      Info: TProgramInfo);
    procedure dws2UnitStringFunctionsGetStringFromListEval(
      Info: TProgramInfo);
    procedure dws2UnitStringFunctionsGetTokenListEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsIncWCEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsNum2TextEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsOEM2ANSIEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsOrdEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsPosXEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsStringOfCharEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsTestWCEval(Info: TProgramInfo);
    procedure dws2UnitStringFunctionsTranslateEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsShellExecuteEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsShellExecuteWaitEval(
      Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsExitWindowsExEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsWriteMailslotEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsGetProcessListEval(
      Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsHiWordEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsIsFileActiveEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsKillProcessEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsLoWordEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsMakeLongEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsPostMessageEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsSendKeysEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsSendKeysExEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsSendKeysNamedWinEval(
      Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsSendKeysNamedWinExEval(
      Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsSendKeysWinEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsSendKeysWinExEval(Info: TProgramInfo);
    procedure dws2UnitSystemFunctionsSendMessageEval(Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsFindWindowEval(Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsFindWindowExEval(Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsGetClassNameEval(Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsGetWindowTextEval(Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsHideTaskbarEval(Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsIsIconicEval(Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsIsWindowEval(Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsIsWindowEnabledEval(
      Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsIsWindowVisibleEval(
      Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsIsZoomedEval(Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsSearchWindowEval(Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsSearchWindowExEval(
      Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsShowTaskbarEval(Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsWaitForWindowEval(Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsWaitForWindowCloseEval(
      Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsWaitForWindowCloseExEval(
      Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsWaitForWindowEnabledEval(
      Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsWaitForWindowEnabledExEval(
      Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsWaitForWindowExEval(
      Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsWindowMoveEval(Info: TProgramInfo);
    procedure dws2UnitWindowFunctionsWindowResizeEval(Info: TProgramInfo);
    procedure dws2UnitIniFilesClassesTIniFileConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
  private
    FScript: TDelphiWebScriptII;
    procedure SetScript(const Value: TDelphiWebScriptII);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  published
    property Script: TDelphiWebScriptII read FScript write SetScript;
  end;

procedure Register;

var
  dws2MFLib: Tdws2MFLib;

implementation

{$R *.DFM}

uses
  dws2MFLibFuncs, dws2MFLibUtils, ProcessViewer, RegExpr;

const
  WKey = '\Software\Microsoft\Windows\CurrentVersion';
  EKey = '\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders';

  numNamesA: array[1..17] of string =
  (
    ('ein'),
    ('zwei'),
    ('drei'),
    ('vier'),
    ('fünf'),
    ('sechs'),
    ('sieben'),
    ('acht'),
    ('neun'),
    ('zehn'),
    ('elf'),
    ('zwölf'),
    ('dreizehn'),
    ('vierzehn'),
    ('fünfzehn'),
    ('sechzehn'),
    ('siebzehn')
    );

  numNamesB: array[1..9] of string =
  (
    ('zehn'),
    ('zwanzig'),
    ('dreissig'),
    ('vierzig'),
    ('fünfzig'),
    ('sechzig'),
    ('siebzig'),
    ('achtzig'),
    ('neunzig')
    );

  hundert: string = 'hundert';
  tausend = 'tausend';
  und = 'und';
  million = 'million';

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2MFLib]);
end;

{ Tdws2MFLib }

procedure Tdws2MFLib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Script) then
    SetScript(nil)
end;

procedure Tdws2MFLib.SetScript(const Value: TDelphiWebScriptII);
var
  x: Integer;
begin
  if Assigned(FScript) then
    FScript.RemoveFreeNotification(Self);
  if Assigned(Value) then
    Value.FreeNotification(Self);

  FScript := Value;
  for x := 0 to ComponentCount - 1 do
    if Components[x] is Tdws2Unit then
      Tdws2Unit(Components[x]).Script := Value;

  if not (csDesigning in ComponentState) then
  begin
    AddIntConst(dws2UnitFile, 'DRIVE_UNKNOWN', DRIVE_UNKNOWN);
    AddIntConst(dws2UnitFile, 'DRIVE_NO_ROOT_DIR', DRIVE_NO_ROOT_DIR);
    AddIntConst(dws2UnitFile, 'DRIVE_REMOVABLE', DRIVE_REMOVABLE);
    AddIntConst(dws2UnitFile, 'DRIVE_FIXED', DRIVE_FIXED);
    AddIntConst(dws2UnitFile, 'DRIVE_REMOTE', DRIVE_REMOTE);
    AddIntConst(dws2UnitFile, 'DRIVE_CDROM', DRIVE_CDROM);
    AddIntConst(dws2UnitFile, 'DRIVE_RAMDISK', DRIVE_RAMDISK);
    AddIntConst(dws2UnitFile, 'FILEDATE_CREATION', FILEDATE_CREATION);
    AddIntConst(dws2UnitFile, 'FILEDATE_LASTACCESS', FILEDATE_LASTACCESS);
    AddIntConst(dws2UnitFile, 'FILEDATE_LASTWRITE', FILEDATE_LASTWRITE);
    AddIntConst(dws2UnitFile, 'MOVEFILE_REPLACE_EXISTING',
      MOVEFILE_REPLACE_EXISTING);
    AddIntConst(dws2UnitFile, 'MOVEFILE_COPY_ALLOWED', MOVEFILE_COPY_ALLOWED);
    AddIntConst(dws2UnitFile, 'MOVEFILE_DELAY_UNTIL_REBOOT',
      MOVEFILE_DELAY_UNTIL_REBOOT);
    AddIntConst(dws2UnitFile, 'MOVEFILE_WRITE_THROUGH', MOVEFILE_WRITE_THROUGH);
    AddIntConst(dws2UnitFile, 'MOVEFILE_CREATE_HARDLINK',
      MOVEFILE_CREATE_HARDLINK);
    AddIntConst(dws2UnitFile, 'MOVEFILE_FAIL_IF_NOT_TRACKABLE',
      MOVEFILE_FAIL_IF_NOT_TRACKABLE);

    AddIntConst(dws2UnitInfo, 'VER_UNKNOWN', VER_UNKNOWN);
    AddIntConst(dws2UnitInfo, 'VER_WIN32S', VER_WIN32S);
    AddIntConst(dws2UnitInfo, 'VER_WIN95', VER_WIN95);
    AddIntConst(dws2UnitInfo, 'VER_WIN98', VER_WIN98);
    AddIntConst(dws2UnitInfo, 'VER_WIN98SE', VER_WIN98SE);
    AddIntConst(dws2UnitInfo, 'VER_WINME', VER_WINME);
    AddIntConst(dws2UnitInfo, 'VER_WINNT', VER_WINNT);
    AddIntConst(dws2UnitInfo, 'VER_WINNT4', VER_WINNT4);
    AddIntConst(dws2UnitInfo, 'VER_WIN2000', VER_WIN2000);
    AddIntConst(dws2UnitInfo, 'VER_WIN32', VER_WIN32);

{$WARNINGS OFF}
    AddIntConst(dws2UnitRegistry, 'HKEY_CLASSES_ROOT', HKEY_CLASSES_ROOT);
    AddIntConst(dws2UnitRegistry, 'HKEY_CURRENT_USER', HKEY_CURRENT_USER);
    AddIntConst(dws2UnitRegistry, 'HKEY_LOCAL_MACHINE', HKEY_LOCAL_MACHINE);
    AddIntConst(dws2UnitRegistry, 'HKEY_USERS', HKEY_USERS);
    AddIntConst(dws2UnitRegistry, 'HKEY_PERFORMANCE_DATA', HKEY_PERFORMANCE_DATA);
    AddIntConst(dws2UnitRegistry, 'HKEY_CURRENT_CONFIG', HKEY_CURRENT_CONFIG);
    AddIntConst(dws2UnitRegistry, 'HKEY_DYN_DATA', HKEY_DYN_DATA);
{$WARNINGS ON}

    AddIntConst(dws2UnitString, 'CROP_LEFT', CROP_LEFT);
    AddIntConst(dws2UnitString, 'CROP_RIGHT', CROP_RIGHT);

    AddIntConst(dws2UnitSystem, 'SW_HIDE', SW_HIDE);
    AddIntConst(dws2UnitSystem, 'SW_SHOWNORMAL', SW_SHOWNORMAL);
    AddIntConst(dws2UnitSystem, 'SW_NORMAL', SW_NORMAL);
    AddIntConst(dws2UnitSystem, 'SW_SHOWMINIMIZED', SW_SHOWMINIMIZED);
    AddIntConst(dws2UnitSystem, 'SW_SHOWMAXIMIZED', SW_SHOWMAXIMIZED);
    AddIntConst(dws2UnitSystem, 'SW_MAXIMIZE', SW_MAXIMIZE);
    AddIntConst(dws2UnitSystem, 'SW_SHOWNOACTIVATE', SW_SHOWNOACTIVATE);
    AddIntConst(dws2UnitSystem, 'SW_SHOW', SW_SHOW);
    AddIntConst(dws2UnitSystem, 'SW_MINIMIZE', SW_MINIMIZE);
    AddIntConst(dws2UnitSystem, 'SW_SHOWMINNOACTIVE', SW_SHOWMINNOACTIVE);
    AddIntConst(dws2UnitSystem, 'SW_SHOWNA', SW_SHOWNA);
    AddIntConst(dws2UnitSystem, 'SW_RESTORE', SW_RESTORE);
    AddIntConst(dws2UnitSystem, 'SW_SHOWDEFAULT', SW_SHOWDEFAULT);
    AddIntConst(dws2UnitSystem, 'EWX_LOGOFF', EWX_LOGOFF);
    AddIntConst(dws2UnitSystem, 'EWX_SHUTDOWN', EWX_SHUTDOWN);
    AddIntConst(dws2UnitSystem, 'EWX_REBOOT', EWX_REBOOT);
    AddIntConst(dws2UnitSystem, 'EWX_FORCE', EWX_FORCE);
    AddIntConst(dws2UnitSystem, 'EWX_POWEROFF', EWX_POWEROFF);
    AddIntConst(dws2UnitSystem, 'EWX_FORCEIFHUNG', EWX_FORCEIFHUNG);

    AddIntConst( dws2UnitSystem, 'WM_MOVE',             WM_MOVE );
    AddIntConst( dws2UnitSystem, 'WM_SIZE',             WM_SIZE );
    AddIntConst( dws2UnitSystem, 'WM_ACTIVATE',         WM_ACTIVATE );
    AddIntConst( dws2UnitSystem, 'WM_SETFOCUS',         WM_SETFOCUS );
    AddIntConst( dws2UnitSystem, 'WM_KILLFOCUS',        WM_KILLFOCUS );
    AddIntConst( dws2UnitSystem, 'WM_ENABLE',           WM_ENABLE );
//    AddIntConst( dws2UnitSystem, 'WM_SETREDRAW',        WM_SETREDRAW );
//    AddIntConst( dws2UnitSystem, 'WM_SETTEXT',          WM_SETTEXT );
//    AddIntConst( dws2UnitSystem, 'WM_GETTEXT',          WM_GETTEXT );
//    AddIntConst( dws2UnitSystem, 'WM_GETTEXTLENGTH',    WM_GETTEXTLENGTH );
//    AddIntConst( dws2UnitSystem, 'WM_PAINT',            WM_PAINT );
    AddIntConst( dws2UnitSystem, 'WM_CLOSE',            WM_CLOSE );
    AddIntConst( dws2UnitSystem, 'WM_QUIT',             WM_QUIT );
//    AddIntConst( dws2UnitSystem, 'WM_QUERYOPEN',        WM_QUERYOPEN );
//    AddIntConst( dws2UnitSystem, 'WM_ERASEBKGND',       WM_ERASEBKGND );
    AddIntConst( dws2UnitSystem, 'WM_SHOWWINDOW',       WM_SHOWWINDOW );
//    AddIntConst( dws2UnitSystem, 'WM_CTLCOLOR',         WM_CTLCOLOR );
    AddIntConst( dws2UnitSystem, 'WM_ACTIVATEAPP',      WM_ACTIVATEAPP );
    AddIntConst( dws2UnitSystem, 'WM_SETCURSOR',        WM_SETCURSOR );
    AddIntConst( dws2UnitSystem, 'WM_MOUSEACTIVATE',    WM_MOUSEACTIVATE );
    AddIntConst( dws2UnitSystem, 'WM_CHILDACTIVATE',    WM_CHILDACTIVATE );
//    AddIntConst( dws2UnitSystem, 'WM_PAINTICON',        WM_PAINTICON );
//    AddIntConst( dws2UnitSystem, 'WM_ICONERASEBKGND',   WM_ICONERASEBKGND );
//    AddIntConst( dws2UnitSystem, 'WM_DRAWITEM',         WM_DRAWITEM );
//    AddIntConst( dws2UnitSystem, 'WM_MEASUREITEM',      WM_MEASUREITEM );
//    AddIntConst( dws2UnitSystem, 'WM_DELETEITEM',       WM_DELETEITEM );
//    AddIntConst( dws2UnitSystem, 'WM_VKEYTOITEM',       WM_VKEYTOITEM );
//    AddIntConst( dws2UnitSystem, 'WM_CHARTOITEM',       WM_CHARTOITEM );
//    AddIntConst( dws2UnitSystem, 'WM_SETFONT',          WM_SETFONT );
//    AddIntConst( dws2UnitSystem, 'WM_GETFONT',          WM_GETFONT );
//    AddIntConst( dws2UnitSystem, 'WM_QUERYDRAGICON',    WM_QUERYDRAGICON );
//    AddIntConst( dws2UnitSystem, 'WM_COMPAREITEM',      WM_COMPAREITEM );
//    AddIntConst( dws2UnitSystem, 'WM_COPYDATA',         WM_COPYDATA );
//    AddIntConst( dws2UnitSystem, 'WM_NOTIFY',           WM_NOTIFY );
    AddIntConst( dws2UnitSystem, 'WM_HELP',             WM_HELP );

//    AddIntConst( dws2UnitSystem, 'WM_CONTEXTMENU',      WM_CONTEXTMENU );
//    AddIntConst( dws2UnitSystem, 'WM_GETICON',          WM_GETICON );
//    AddIntConst( dws2UnitSystem, 'WM_SETICON',          WM_SETICON );

//    AddIntConst( dws2UnitSystem, 'WM_NCMOUSEMOVE',      WM_NCMOUSEMOVE );
//    AddIntConst( dws2UnitSystem, 'WM_NCLBUTTONDOWN',    WM_NCLBUTTONDOWN );
//    AddIntConst( dws2UnitSystem, 'WM_NCLBUTTONUP',      WM_NCLBUTTONUP );
//    AddIntConst( dws2UnitSystem, 'WM_NCLBUTTONDBLCLK',  WM_NCLBUTTONDBLCLK );
//    AddIntConst( dws2UnitSystem, 'WM_NCRBUTTONDOWN',    WM_NCRBUTTONDOWN );
//    AddIntConst( dws2UnitSystem, 'WM_NCRBUTTONUP',      WM_NCRBUTTONUP );
//    AddIntConst( dws2UnitSystem, 'WM_NCRBUTTONDBLCLK',  WM_NCRBUTTONDBLCLK );
//    AddIntConst( dws2UnitSystem, 'WM_NCMBUTTONDOWN',    WM_NCMBUTTONDOWN );
//    AddIntConst( dws2UnitSystem, 'WM_NCMBUTTONUP',      WM_NCMBUTTONUP );
//    AddIntConst( dws2UnitSystem, 'WM_NCMBUTTONDBLCLK',  WM_NCMBUTTONDBLCLK );

//    AddIntConst( dws2UnitSystem, 'WM_KEYFIRST',         WM_KEYFIRST );
//    AddIntConst( dws2UnitSystem, 'WM_KEYDOWN',          WM_KEYDOWN );
//    AddIntConst( dws2UnitSystem, 'WM_KEYUP',            WM_KEYUP );
//    AddIntConst( dws2UnitSystem, 'WM_CHAR',             WM_CHAR );
//    AddIntConst( dws2UnitSystem, 'WM_DEADCHAR',         WM_DEADCHAR );
//    AddIntConst( dws2UnitSystem, 'WM_SYSKEYDOWN',       WM_SYSKEYDOWN );
//    AddIntConst( dws2UnitSystem, 'WM_SYSKEYUP',         WM_SYSKEYUP );
//    AddIntConst( dws2UnitSystem, 'WM_SYSCHAR',          WM_SYSCHAR );
//    AddIntConst( dws2UnitSystem, 'WM_SYSDEADCHAR',      WM_SYSDEADCHAR );
//    AddIntConst( dws2UnitSystem, 'WM_KEYLAST',          WM_KEYLAST );

    AddIntConst( dws2UnitSystem, 'WM_COMMAND',          WM_COMMAND );
    AddIntConst( dws2UnitSystem, 'WM_SYSCOMMAND',       WM_SYSCOMMAND );
    AddIntConst( dws2UnitSystem, 'WM_HSCROLL',          WM_HSCROLL );
    AddIntConst( dws2UnitSystem, 'WM_VSCROLL',          WM_VSCROLL );
//    AddIntConst( dws2UnitSystem, 'WM_INITMENU',         WM_INITMENU );
//    AddIntConst( dws2UnitSystem, 'WM_INITMENUPOPUP',    WM_INITMENUPOPUP );
//    AddIntConst( dws2UnitSystem, 'WM_MENUSELECT',       WM_MENUSELECT );
//    AddIntConst( dws2UnitSystem, 'WM_MENUCHAR',         WM_MENUCHAR );
//    AddIntConst( dws2UnitSystem, 'WM_ENTERIDLE',        WM_ENTERIDLE );

//    AddIntConst( dws2UnitSystem, 'WM_MENURBUTTONUP',    WM_MENURBUTTONUP );
//    AddIntConst( dws2UnitSystem, 'WM_MENUDRAG',         WM_MENUDRAG );
//    AddIntConst( dws2UnitSystem, 'WM_MENUGETOBJECT',    WM_MENUGETOBJECT );
//    AddIntConst( dws2UnitSystem, 'WM_UNINITMENUPOPUP',  WM_UNINITMENUPOPUP );
//    AddIntConst( dws2UnitSystem, 'WM_MENUCOMMAND',      WM_MENUCOMMAND );

//    AddIntConst( dws2UnitSystem, 'WM_MOUSEFIRST',       WM_MOUSEFIRST );
    AddIntConst( dws2UnitSystem, 'WM_MOUSEMOVE',        WM_MOUSEMOVE );
    AddIntConst( dws2UnitSystem, 'WM_LBUTTONDOWN',      WM_LBUTTONDOWN );
    AddIntConst( dws2UnitSystem, 'WM_LBUTTONUP',        WM_LBUTTONUP );
    AddIntConst( dws2UnitSystem, 'WM_LBUTTONDBLCLK',    WM_LBUTTONDBLCLK );
    AddIntConst( dws2UnitSystem, 'WM_RBUTTONDOWN',      WM_RBUTTONDOWN );
    AddIntConst( dws2UnitSystem, 'WM_RBUTTONUP',        WM_RBUTTONUP );
    AddIntConst( dws2UnitSystem, 'WM_RBUTTONDBLCLK',    WM_RBUTTONDBLCLK );
    AddIntConst( dws2UnitSystem, 'WM_MBUTTONDOWN',      WM_MBUTTONDOWN );
    AddIntConst( dws2UnitSystem, 'WM_MBUTTONUP',        WM_MBUTTONUP );
    AddIntConst( dws2UnitSystem, 'WM_MBUTTONDBLCLK',    WM_MBUTTONDBLCLK );
    AddIntConst( dws2UnitSystem, 'WM_MOUSEWHEEL',       WM_MOUSEWHEEL );
//    AddIntConst( dws2UnitSystem, 'WM_MOUSELAST',        WM_MOUSELAST );

//    AddIntConst( dws2UnitSystem, 'WM_PARENTNOTIFY',     WM_PARENTNOTIFY );
//    AddIntConst( dws2UnitSystem, 'WM_ENTERMENULOOP',    WM_ENTERMENULOOP );
//    AddIntConst( dws2UnitSystem, 'WM_EXITMENULOOP',     WM_EXITMENULOOP );
//    AddIntConst( dws2UnitSystem, 'WM_NEXTMENU',         WM_NEXTMENU );

//    AddIntConst( dws2UnitSystem, 'WM_MDIACTIVATE',      WM_MDIACTIVATE );
//    AddIntConst( dws2UnitSystem, 'WM_MDIRESTORE',       WM_MDIRESTORE );
//    AddIntConst( dws2UnitSystem, 'WM_MDINEXT',          WM_MDINEXT );
//    AddIntConst( dws2UnitSystem, 'WM_MDIMAXIMIZE',      WM_MDIMAXIMIZE );
    AddIntConst( dws2UnitSystem, 'WM_MDITILE',          WM_MDITILE );
    AddIntConst( dws2UnitSystem, 'WM_MDICASCADE',       WM_MDICASCADE );
//    AddIntConst( dws2UnitSystem, 'WM_MDIICONARRANGE',   WM_MDIICONARRANGE );
//    AddIntConst( dws2UnitSystem, 'WM_MDIGETACTIVE',     WM_MDIGETACTIVE );
//    AddIntConst( dws2UnitSystem, 'WM_MDISETMENU',       WM_MDISETMENU );

//    AddIntConst( dws2UnitSystem, 'WM_ENTERSIZEMOVE',    WM_ENTERSIZEMOVE );
//    AddIntConst( dws2UnitSystem, 'WM_EXITSIZEMOVE',     WM_EXITSIZEMOVE );

//    AddIntConst( dws2UnitSystem, 'WM_MOUSEHOVER',       WM_MOUSEHOVER );
//    AddIntConst( dws2UnitSystem, 'WM_MOUSELEAVE',       WM_MOUSELEAVE );

    AddIntConst( dws2UnitSystem, 'WM_CUT',              WM_CUT );
    AddIntConst( dws2UnitSystem, 'WM_COPY',             WM_COPY );
    AddIntConst( dws2UnitSystem, 'WM_PASTE',            WM_PASTE );
    AddIntConst( dws2UnitSystem, 'WM_CLEAR',            WM_CLEAR );
    AddIntConst( dws2UnitSystem, 'WM_UNDO',             WM_UNDO );
//    AddIntConst( dws2UnitSystem, 'WM_DESTROYCLIPBOARD', WM_DESTROYCLIPBOARD );
//    AddIntConst( dws2UnitSystem, 'WM_DRAWCLIPBOARD',    WM_DRAWCLIPBOARD );
//    AddIntConst( dws2UnitSystem, 'WM_PAINTCLIPBOARD',   WM_PAINTCLIPBOARD );
//    AddIntConst( dws2UnitSystem, 'WM_VSCROLLCLIPBOARD', WM_VSCROLLCLIPBOARD );
//    AddIntConst( dws2UnitSystem, 'WM_SIZECLIPBOARD',    WM_SIZECLIPBOARD );
//    AddIntConst( dws2UnitSystem, 'WM_HSCROLLCLIPBOARD', WM_HSCROLLCLIPBOARD );

//    AddIntConst( dws2UnitSystem, 'WM_PRINT',            WM_PRINT );
//    AddIntConst( dws2UnitSystem, 'WM_PRINTCLIENT',      WM_PRINTCLIENT );

//    AddIntConst( dws2UnitSystem, 'WM_APP',              WM_APP );

    AddIntConst( dws2UnitSystem, 'WM_USER',             WM_USER );

    AddIntConst( dws2UnitSystem, 'BM_CLICK',            BM_CLICK );
    AddIntConst( dws2UnitSystem, 'BM_GETCHECK',         BM_GETCHECK );
    AddIntConst( dws2UnitSystem, 'BM_SETCHECK',         BM_SETCHECK );

    AddIntConst( dws2UnitSystem, 'BST_CHECKED',         BST_CHECKED );
    AddIntConst( dws2UnitSystem, 'BST_INDETERMINATE',   BST_INDETERMINATE );
    AddIntConst( dws2UnitSystem, 'BST_UNCHECKED',       BST_UNCHECKED );

    AddIntConst( dws2UnitSystem, 'CB_GETCOUNT',         CB_GETCOUNT );
    AddIntConst( dws2UnitSystem, 'CB_GETCURSEL',        CB_GETCURSEL );
    AddIntConst( dws2UnitSystem, 'CB_GETDROPPEDSTATE',  CB_GETDROPPEDSTATE );
    AddIntConst( dws2UnitSystem, 'CB_GETEDITSEL',       CB_GETEDITSEL );
    AddIntConst( dws2UnitSystem, 'CB_GETTOPINDEX',      CB_GETTOPINDEX );
    AddIntConst( dws2UnitSystem, 'CB_RESETCONTENT',     CB_RESETCONTENT );
    AddIntConst( dws2UnitSystem, 'CB_SETCURSEL',        CB_SETCURSEL );
    AddIntConst( dws2UnitSystem, 'CB_SETEDITSEL',       CB_SETEDITSEL );
    AddIntConst( dws2UnitSystem, 'CB_SETTOPINDEX',      CB_SETTOPINDEX );
    AddIntConst( dws2UnitSystem, 'CB_SHOWDROPDOWN',     CB_SHOWDROPDOWN );

    AddIntConst( dws2UnitSystem, 'EM_GETSEL',           EM_GETSEL );
    AddIntConst( dws2UnitSystem, 'EM_SETSEL',           EM_SETSEL );
    AddIntConst( dws2UnitSystem, 'EM_UNDO',             EM_UNDO );

    AddIntConst( dws2UnitSystem, 'LB_GETCOUNT',         LB_GETCOUNT );
    AddIntConst( dws2UnitSystem, 'LB_GETCURSEL',        LB_GETCURSEL );
    AddIntConst( dws2UnitSystem, 'LB_GETSEL',           LB_GETSEL );
    AddIntConst( dws2UnitSystem, 'LB_GETSELCOUNT',      LB_GETSELCOUNT );
    AddIntConst( dws2UnitSystem, 'LB_GETTEXT',          LB_GETTEXT );
    AddIntConst( dws2UnitSystem, 'LB_GETTEXTLEN',       LB_GETTEXTLEN );
    AddIntConst( dws2UnitSystem, 'LB_GETTOPINDEX',      LB_GETTOPINDEX );
    AddIntConst( dws2UnitSystem, 'LB_ITEMFROMPOINT',    LB_ITEMFROMPOINT );
    AddIntConst( dws2UnitSystem, 'LB_RESETCONTENT',     LB_RESETCONTENT );
    AddIntConst( dws2UnitSystem, 'LB_SELITEMRANGE',     LB_SELITEMRANGE );
    AddIntConst( dws2UnitSystem, 'LB_SETCURSEL',        LB_SETCURSEL );
    AddIntConst( dws2UnitSystem, 'LB_SETSEL',           LB_SETSEL );
    AddIntConst( dws2UnitSystem, 'LB_SETTOPINDEX',      LB_SETTOPINDEX );

    AddIntConst( dws2UnitSystem, 'SB_BOTTOM',           SB_BOTTOM );
    AddIntConst( dws2UnitSystem, 'SB_ENDSCROLL',        SB_ENDSCROLL );
    AddIntConst( dws2UnitSystem, 'SB_LINEDOWN',         SB_LINEDOWN );
    AddIntConst( dws2UnitSystem, 'SB_LINEUP',           SB_LINEUP );
    AddIntConst( dws2UnitSystem, 'SB_PAGEDOWN',         SB_PAGEDOWN );
    AddIntConst( dws2UnitSystem, 'SB_PAGEUP',           SB_PAGEUP );
    AddIntConst( dws2UnitSystem, 'SB_THUMBPOSITION',    SB_THUMBPOSITION );
    AddIntConst( dws2UnitSystem, 'SB_THUMBTRACK',       SB_THUMBTRACK );
    AddIntConst( dws2UnitSystem, 'SB_TOP',              SB_TOP );
  end;
end;

// ****************************************************************************
// *** Basic Functions ********************************************************
// ****************************************************************************

procedure Tdws2MFLib.dws2UnitBasicFunctionsBeepEval(Info: TProgramInfo);
begin
  SysUtils.Beep;
end;

procedure Tdws2MFLib.dws2UnitBasicFunctionsDecEval(Info: TProgramInfo);
var
  i: Integer;
begin
  i := Info['I'];
  Dec(i);
  Info['I'] := i;
end;

procedure Tdws2MFLib.dws2UnitBasicFunctionsDec2Eval(Info: TProgramInfo);
var
  i: Integer;
begin
  i := Info['I'];
  Dec(i, Integer(Info['N']));
  Info['I'] := i;
end;

procedure Tdws2MFLib.dws2UnitBasicFunctionsIncEval(Info: TProgramInfo);
var
  i: Integer;
begin
  i := Info['I'];
  Inc(i);
  Info['I'] := i;
end;

procedure Tdws2MFLib.dws2UnitBasicFunctionsInc2Eval(Info: TProgramInfo);
var
  i: Integer;
begin
  i := Info['I'];
  Inc(i, Integer(Info['N']));
  Info['I'] := i;
end;

procedure Tdws2MFLib.dws2UnitBasicFunctionsGetTickCountEval(
  Info: TProgramInfo);
begin
{$WARNINGS OFF}
  Info['Result'] := GetTickCount;
{$WARNINGS ON}
end;

procedure Tdws2MFLib.dws2UnitBasicFunctionsSleepEval(Info: TProgramInfo);
begin
  Sleep(Info['mSecs']);
end;

procedure Tdws2MFLib.dws2UnitBasicFunctionsWriteLnEval(Info: TProgramInfo);
begin
  WriteLn(Info['Text']);
end;

// ****************************************************************************
// *** Connection Functions ***************************************************
// ****************************************************************************

procedure Tdws2MFLib.dws2UnitConnFunctionsConnectedEval(
  Info: TProgramInfo);
var
  InternetGetConnectedState: function(lpdwFlags: LPDWord;
    dwReserved: DWord
    ): Boolean; stdcall;
  RasEnumConnections: TRasEnumConnections;
  RasConns: array[1..15] of TRasConn;
  Entries,
    Bufsize: DWord;

  Flags,
    Dummy: LongInt;
  hRasApi,
    hWinInet: THandle;
begin
  Info['Result'] := False;
  hRasApi := LoadLibrary('rasapi32');
  if hRasApi <> 0 then
  try
    RasEnumConnections := GetProcAddress(hRasApi, 'RasEnumConnectionsA');
    if @RasEnumConnections <> nil then
    begin
      FillChar(RasConns, Sizeof(RasConns), 0);
      RasConns[1].Size := Sizeof(TRasConn);
      Bufsize := Sizeof(RasConns);
      if RasEnumConnections(@RasConns[1], Bufsize, Entries) = 0 then
        if Entries > 0 then
        begin
          Info['Result'] := True;
          Exit;
        end;
    end;
  finally
    FreeLibrary(hRasApi);
  end;
  Dummy := 0;
  hWinInet := LoadLibrary('wininet');
  if hWinInet <> 0 then
  try
    InternetGetConnectedState := GetProcAddress(hWininet,
      'InternetGetConnectedState');
    if @InternetGetConnectedState <> nil then
    begin
      if InternetGetConnectedState(@Flags, Dummy) then
      begin
        Info['Result'] := True;
        Exit;
      end;
    end;
  finally
    FreeLibrary(hWinInet);
  end;
end;

procedure Tdws2MFLib.dws2UnitConnFunctionsIPAddressEval(
  Info: TProgramInfo);
var
  wVersionRequested: Word;
  wsaData: TWSAData;
  p: PHostEnt;
  s: array[0..128] of Char;
  p2: PChar;
begin
  {Start up WinSock}
  wVersionRequested := MakeWord(1, 1);
  WSAStartup(wVersionRequested, wsaData);

  {Get the computer name}
  GetHostName(@s, 128);
  p := GetHostByName(@s);

  {Get the IpAddress}
  p2 := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
  Info['Result'] := string(p2);

  {Shut down WinSock}
  WSACleanup;
end;

// ****************************************************************************
// *** Dialog Functions *******************************************************
// ****************************************************************************

procedure Tdws2MFLib.dws2UnitDialogFunctionsSelectStringDialogEval(
  Info: TProgramInfo);
var
  ScriptObj: IScriptObj;
  StringsObj: TStringList;
begin
  ScriptObj := IScriptObj(IUnknown(Info['Strings']));
  if ScriptObj = nil then
    StringsObj := nil
  else
    StringsObj := TStringList(ScriptObj.ExternalObject);
  Info['Result'] := SelectStringDialog( Info['Title'], StringsObj, Info['Selected'] );
end;

// ****************************************************************************
// *** File Functions *********************************************************
// ****************************************************************************

procedure Tdws2MFLib.dws2UnitFileFunctionsDescCopyEval(Info: TProgramInfo);
begin
  Info['Result'] := DescWrite(Info['Target'], DescRead(Info['Source']));
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsDescListCreateEval(
  Info: TProgramInfo);
var
  SL: TStringList;
begin
  SL := DescListCreate(Info['Dir']);
  if Assigned(SL) then
    Info['Result'] := Info.Vars['TStringList'].GetConstructor('Create', SL).Call.Value
  else
    Info['Result'] := 0;
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsDescListReadEval(
  Info: TProgramInfo);
var
  ScriptObj: IScriptObj;
  StringsObj: TStringList;
begin
  ScriptObj := IScriptObj(IUnknown(Info['List']));
  if ScriptObj = nil then
    StringsObj := nil
  else
    StringsObj := TStringList(ScriptObj.ExternalObject);
  Info['Result'] := DescListRead(StringsObj, Info['FileName']);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsDescMoveEval(Info: TProgramInfo);
begin
  Info['Result'] := DescWrite(Info['Target'], DescRead(Info['Source']));
  if Info['Result'] then
    DescWrite(Info['Source'], '');
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsDescReadEval(Info: TProgramInfo);
begin
  Info['Result'] := DescRead(Info['Filename']);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsDescWriteEval(
  Info: TProgramInfo);
begin
  Info['Result'] := DescWrite(Info['FileName'], Info['Desc']);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsOpenDialogEval(
  Info: TProgramInfo);
var
  OD: TExtOpenDialog;
begin
  Info['Result'] := '';
  try
    OD := TExtOpenDialog.Create(nil);
    try
      OD.InitialDir := Info['InitialDir'];
      OD.FileName := Info['FileName'];
      OD.Title := Info['Title'];
      OD.DefaultExt := Info['DefaultExt'];
      OD.Filter := Info['Filter'];
      OD.FilterIndex := Info['FilterIndex'];
      OD.Options := [ofHideReadOnly, ofPathMustExist, ofFileMustExist,
        ofEnableSizing];
      if OD.Execute then
        Info['Result'] := OD.FileName;
    finally
      OD.Free;
    end;
  except
    ;
  end;
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsOpenDialogMultiEval(
  Info: TProgramInfo);
var
  OD: TExtOpenDialog;
  SL: TStringList;
begin
  Info['Result'] := 0;
  OD := TExtOpenDialog.Create(nil);
  try
    OD.InitialDir := Info['InitialDir'];
    OD.FileName := Info['FileName'];
    OD.Title := Info['Title'];
    OD.DefaultExt := Info['DefaultExt'];
    OD.Filter := Info['Filter'];
    OD.FilterIndex := Info['FilterIndex'];
    OD.Options := [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist,
      ofFileMustExist, ofEnableSizing];
    if OD.Execute then
    begin
      SL := TStringList.Create;
      SL.AddStrings(OD.Files);
      SL.Sort;
      Info['Result'] := Info.Vars['TStringList'].GetConstructor('Create', SL).Call.Value;
    end;
  finally
    OD.Free;
  end;
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsSaveDialogEval(
  Info: TProgramInfo);
var
  SD: TExtSaveDialog;
begin
  Info['Result'] := '';
  try
    SD := TExtSaveDialog.Create(nil);
    try
      SD.InitialDir := Info['InitialDir'];
      SD.FileName := Info['FileName'];
      SD.Title := Info['Title'];
      SD.DefaultExt := Info['DefaultExt'];
      SD.Filter := Info['Filter'];
      SD.FilterIndex := Info['FilterIndex'];
      SD.Options := [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist,
        ofEnableSizing];
      if SD.Execute then
        Info['Result'] := SD.FileName;
    finally
      SD.Free;
    end;
  except
    ;
  end;
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsCDCloseEval(Info: TProgramInfo);
var
  Drive: Integer;
begin
  Drive := Info['Drive'];
  Info['Result'] := CDClose(Drive);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsCDOpenEval(Info: TProgramInfo);
var
  Drive: Integer;
begin
  Drive := Info['Drive'];
  Info['Result'] := CDOpen(Drive);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsGetCRC32FromFileEval(
  Info: TProgramInfo);
begin
  Info['Result'] := GetCRC32FromFile(Info['Filename']);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsGetDriveNameEval(
  Info: TProgramInfo);
var
  Drive: Integer;
begin
  Drive := Info['Drive'];
  Info['Result'] := DriveName(Drive);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsGetDriveNumEval(
  Info: TProgramInfo);
var
  Drive: string;
begin
  Drive := Info['Drive'];
  if (Length(Drive) = 1) or // Nur ein Zeichen
  ((Length(Drive) > 1) and (Drive[2] = #58)) then // oder zweites Zeichen ein ":"
    Info['Result'] := Ord(UpCase(Drive[1])) - 64
  else
    Info['Result'] := -1;
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsGetDriveReadyEval(
  Info: TProgramInfo);
var
  Drive: Integer;
begin
  Drive := Info['Drive'];
  Info['Result'] := DriveReady(Drive);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsGetDriveSerialEval(
  Info: TProgramInfo);
var
  Drive: Integer;
begin
  Drive := Info['Drive'];
  Info['Result'] := DriveSerial(Drive);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsGetDriveTypeEval(
  Info: TProgramInfo);
var
  Drive: Integer;
begin
  Drive := Info['Drive'];
  Info['Result'] := DriveType(Drive);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsDirectoryExistsEval(
  Info: TProgramInfo);
begin
  Info['Result'] := DirectoryExists(Info['DirName']);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsDirectoryListEval(
  Info: TProgramInfo);
var
  SL: TStringList;
begin
  SL := ScanForFiles(Info['DirName'] + '\*', Info['Recurse'], Info['Hidden'],
    False, True);
  Info['Result'] := Info.Vars['TStringList'].GetConstructor('Create', SL).Call.Value;
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsCopyFileEval(Info: TProgramInfo);
var
  Source,
    Target: string;
begin
  Source := Info['Source'];
  Target := Info['Target'];
  Info['Result'] := CopyFile(PChar(Source), PChar(Target), Info['Fail']);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsFileDateEval(Info: TProgramInfo);
begin
  Info['Result'] := FileDate(Info['FileName'], Info['Flag']);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsFileListEval(Info: TProgramInfo);
var
  SL: TStringList;
begin
  SL := ScanForFiles(Info['FileName'], Info['Recurse'], Info['Hidden'], True,
    Info['Dirs']);
  Info['Result'] := Info.Vars['TStringList'].GetConstructor('Create', SL).Call.Value;
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsFileSizeEval(Info: TProgramInfo);
begin
  Info['Result'] := Integer(FileSize(Info['FileName']));
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsMakePathEval(Info: TProgramInfo);
begin
  Info['Result'] := MakePath(Info['Drive'], Info['Dir'], Info['Name'],
    Info['Ext']);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsMoveFileEval(Info: TProgramInfo);
var
  Source,
    Target: string;
begin
  Source := Info['Source'];
  Target := Info['Target'];
  Info['Result'] := MoveFile(PChar(Source), PChar(Target));
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsMoveFileExEval(
  Info: TProgramInfo);
var
  Source,
    Target: string;
begin
  Source := Info['Source'];
  Target := Info['Target'];
  if Target = '' then
    Info['Result'] := MoveFileEx(PChar(Source), nil, Info['Flags'])
  else
    Info['Result'] := MoveFileEx(PChar(Source), PChar(Target), Info['Flags']);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsReadOnlyPathEval(
  Info: TProgramInfo);
begin
  Info['Result'] := ReadOnlyPath(Info['Path']);
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsSplitPathEval(
  Info: TProgramInfo);
var
  Drive,
    Dir,
    Name,
    Ext: string;
begin
  SplitPath(Info['Path'], Drive, Dir, Name, Ext);
  Info['Drive'] := Drive;
  Info['Dir'] := Dir;
  Info['Name'] := Name;
  Info['Ext'] := Ext;
end;

procedure Tdws2MFLib.dws2UnitFileFunctionsSubdirectoryExistsEval(
  Info: TProgramInfo);
begin
  Info['Result'] := SubdirectoryExists(Info['Dir']);
end;

// ****************************************************************************
// *** Info Functions *********************************************************
// ****************************************************************************

function _GetRegistryString(Root: HKey; Key, Name: string): string;
var
  Reg: TRegistry;
begin
  Result := '';
  Reg := TRegistry.Create;
  try
    Reg.RootKey := Root;
    if Reg.OpenKey(Key, False) then
      Result := Reg.ReadString(Name);
  finally
    Reg.Free;
  end;
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetAllUsersDesktopDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_LOCAL_MACHINE, EKey, 'Common Desktop');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetAllUsersProgramsDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_LOCAL_MACHINE, EKey,
    'Common Programs');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetAllUsersStartmenuDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_LOCAL_MACHINE, EKey,
    'Common Start Menu');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetAllUsersStartupDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_LOCAL_MACHINE, EKey, 'Common Startup');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetAppdataDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'AppData');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetCacheDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'Cache');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetChannelFolderNameEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_LOCAL_MACHINE, WKey,
    'ChannelFolderName');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetCommonFilesDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_LOCAL_MACHINE, WKey, 'CommonFilesDir');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetComputerNameEval(
  Info: TProgramInfo);
var
  CN: array[0..MAX_COMPUTERNAME_LENGTH] of Char;
  L: DWORD;
begin
  L := MAX_COMPUTERNAME_LENGTH;
  if GetComputerName(CN, L) then
    Info['Result'] := string(CN)
  else
    Info['Result'] := '';
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetConsoleTitleEval(
  Info: TProgramInfo);
var
  CT: array[0..MAX_PATH] of Char;
begin
  if GetConsoleTitle(CT, MAX_PATH) > 0 then
    Info['Result'] := string(CT)
  else
    Info['Result'] := '';
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetCookiesDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'Cookies');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetCPUSpeedEval(
  Info: TProgramInfo);
const
  DelayTime = 500; // measure time in ms
var
  TimerHi,
    TimerLo: DWORD;
  PriorityClass,
    Priority: Integer;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);

  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  Sleep(10);
  asm
        dw 310Fh // rdtsc
        mov TimerLo, eax
        mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
        dw 310Fh // rdtsc
        sub eax, TimerLo
        sbb edx, TimerHi
        mov TimerLo, eax
        mov TimerHi, edx
  end;

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

  Info['Result'] := TimerLo / (1000.0 * DelayTime);
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetDesktopDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'Desktop');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetDevicePathEval(
  Info: TProgramInfo);
var
  Dir: array[0..MAX_PATH] of Char;
begin
  GetWindowsDirectory(Dir, MAX_PATH);
  Info['Result'] := string(Dir) +
    Copy(_GetRegistryString(HKEY_LOCAL_MACHINE, WKey, 'DevicePath'), 13, 255);
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetEnvironmentVariableEval(
  Info: TProgramInfo);
var
  EV: array[0..MAX_PATH] of Char;
  P: PChar;
  i: Integer;
begin
  Info['Result'] := '';
  StrPCopy(EV, Info['Name']);
  i := GetEnvironmentVariable(EV, nil, 0);
  if i > 0 then
  begin
    GetMem(P, i);
    try
      if GetEnvironmentVariable(EV, P, i) > 0 then
        Info['Result'] := string(P);
    finally
      FreeMem(P);
    end;
  end;
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetFavoritesDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'Favorites');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetFontsDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'Fonts');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetHistoryDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'History');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetLinkfolderNameEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_LOCAL_MACHINE, WKey, 'LinkFolderName');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetMediaPathEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_LOCAL_MACHINE, WKey, 'MediaPath');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetNethoodDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'NetHood');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetPersonalDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'Personal');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetPFAccessoriesNameEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_LOCAL_MACHINE, WKey,
    'PF_AccessoriesName');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetPrinthoodDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'PrintHood');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetProgramfilesDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_LOCAL_MACHINE, WKey,
    'ProgramFilesDir');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetProgramsDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'Programs');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetRecentDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'Recent');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetSendtoDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'SendTo');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetSMAccessoriesNameEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_LOCAL_MACHINE, WKey,
    'SM_AccessoriesName');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetStartmenuDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'Start Menu');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetStartupDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'Startup');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetSystemDirectoryEval(
  Info: TProgramInfo);
var
  Dir: array[0..MAX_PATH] of Char;
begin
  GetSystemDirectory(Dir, MAX_PATH);
  Info['Result'] := string(Dir);
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetTempDirectoryEval(
  Info: TProgramInfo);
var
  Dir: array[0..MAX_PATH] of Char;
begin
  if GetEnvironmentVariable('TEMP', Dir, MAX_PATH) > 0 then
    Info['Result'] := string(Dir)
  else if GetEnvironmentVariable('TMP', Dir, MAX_PATH) > 0 then
    Info['Result'] := string(Dir)
  else
    Info['Result'] := '';
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetTemplatesDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_CURRENT_USER, EKey, 'Templates');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetUserNameEval(
  Info: TProgramInfo);
var
  UN: array[0..MAX_COMPUTERNAME_LENGTH] of Char;
  L: DWORD;
begin
  L := MAX_COMPUTERNAME_LENGTH;
  if GetUserName(UN, L) then
    Info['Result'] := string(UN)
  else
    Info['Result'] := '';
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetVersionEval(
  Info: TProgramInfo);
begin
{$WARNINGS OFF}
  Info['Result'] := GetVersion;
{$WARNINGS ON}
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetWallpaperDirectoryEval(
  Info: TProgramInfo);
begin
  Info['Result'] := _GetRegistryString(HKEY_LOCAL_MACHINE, WKey, 'WallPaperDir');
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetWindowsDirectoryEval(
  Info: TProgramInfo);
var
  Dir: array[0..MAX_PATH] of Char;
begin
  GetWindowsDirectory(Dir, MAX_PATH);
  Info['Result'] := string(Dir);
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsGetWindowsVersionEval(
  Info: TProgramInfo);
begin
  Info['Result'] := GetWindowsVersion;
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsIsWin2000Eval(
  Info: TProgramInfo);
begin
  Info['Result'] := IsWin2000;
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsIsWin9xEval(Info: TProgramInfo);
begin
  Info['Result'] := IsWin9x;
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsIsWinNTEval(Info: TProgramInfo);
begin
  Info['Result'] := IsWinNT;
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsIsWinNT4Eval(Info: TProgramInfo);
begin
  Info['Result'] := IsWinNT4;
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsSetComputerNameEval(
  Info: TProgramInfo);
var
  CN: array[0..MAX_COMPUTERNAME_LENGTH] of Char;
begin
  StrPCopy(CN, Info['Name']);
  Info['Result'] := SetComputerName(CN);
end;

procedure Tdws2MFLib.dws2UnitInfoFunctionsSetConsoleTitleEval(
  Info: TProgramInfo);
var
  CT: array[0..MAX_PATH] of Char;
begin
  StrPCopy(CT, Info['Title']);
  Info['Result'] := SetConsoleTitle(CT);
end;

// ****************************************************************************
// *** TIniFile Functions *****************************************************
// ****************************************************************************

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TIniFile.Create(Info['FileName']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIniFile(ExtObject).Free;
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsDeleteKeyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIniFile(ExtObject).DeleteKey(Info['Section'], Info['Ident']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsEraseSectionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIniFile(ExtObject).EraseSection(Info['Section']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsReadBoolEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIniFile(ExtObject).ReadBool(Info['Section'], Info['Ident'],
    Info['Default']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsReadDateEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIniFile(ExtObject).ReadDate(Info['Section'], Info['Ident'],
    Info['Default']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsReadDateTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIniFile(ExtObject).ReadDateTime(Info['Section'], Info['Ident'],
    Info['Default']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsReadFileNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIniFile(ExtObject).Filename;
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsReadFloatEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIniFile(ExtObject).ReadFloat(Info['Section'], Info['Ident'],
    Info['Default']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsReadIntegerEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIniFile(ExtObject).ReadInteger(Info['Section'], Info['Ident'],
    Info['Default']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsReadSectionEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  ScriptObj: IScriptObj;
  StringsObj: TStringList;
begin
  ScriptObj := IScriptObj(IUnknown(Info['Strings']));
  if ScriptObj = nil then
    StringsObj := nil
  else
    StringsObj := TStringList(ScriptObj.ExternalObject);
  TIniFile(ExtObject).ReadSection(Info['Section'], StringsObj);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsReadSectionsEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  ScriptObj: IScriptObj;
  StringsObj: TStringList;
begin
  ScriptObj := IScriptObj(IUnknown(Info['Strings']));
  if ScriptObj = nil then
    StringsObj := nil
  else
    StringsObj := TStringList(ScriptObj.ExternalObject);
  TIniFile(ExtObject).ReadSections(StringsObj);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsReadSectionValuesEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  ScriptObj: IScriptObj;
  StringsObj: TStringList;
begin
  ScriptObj := IScriptObj(IUnknown(Info['Strings']));
  if ScriptObj = nil then
    StringsObj := nil
  else
    StringsObj := TStringList(ScriptObj.ExternalObject);
  TIniFile(ExtObject).ReadSectionValues(Info['Section'], StringsObj);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsReadStringEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIniFile(ExtObject).ReadString(Info['Section'], Info['Ident'],
    Info['Default']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsReadTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIniFile(ExtObject).ReadTime(Info['Section'], Info['Ident'],
    Info['Default']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsSectionExistsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIniFile(ExtObject).SectionExists(Info['Section']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsUpdateFileEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIniFile(ExtObject).UpdateFile;
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsWriteBoolEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIniFile(ExtObject).WriteBool(Info['Section'], Info['Ident'], Info['Value']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsWriteDateEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIniFile(ExtObject).WriteDate(Info['Section'], Info['Ident'], Info['Value']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsWriteDateTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIniFile(ExtObject).WriteDate(Info['Section'], Info['Ident'], Info['Value']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsWriteFloatEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIniFile(ExtObject).WriteFloat(Info['Section'], Info['Ident'], Info['Value']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsWriteIntegerEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIniFile(ExtObject).WriteInteger(Info['Section'], Info['Ident'], Info['Value']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsWriteStringEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIniFile(ExtObject).WriteString(Info['Section'], Info['Ident'], Info['Value']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsWriteTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TIniFile(ExtObject).WriteTime(Info['Section'], Info['Ident'], Info['Value']);
end;

procedure Tdws2MFLib.dws2UnitIniFilesClassesTIniFileMethodsValueExistsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TIniFile(ExtObject).ValueExists(Info['Section'], Info['Ident']);
end;

// ****************************************************************************
// *** Registry Functions *****************************************************
// ****************************************************************************

procedure Tdws2MFLib.dws2UnitRegistryFunctionsRegCreateKeyEval(
  Info: TProgramInfo);
var
  Key: HKey;
begin
  RegCreateKeyEx(HKey(Info['MainKey']), PChar(string(Info['SubKey'])), 0, nil,
    REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, nil, Key, nil);
  RegCloseKey(Key);
end;

procedure Tdws2MFLib.dws2UnitRegistryFunctionsRegDeleteKeyEval(
  Info: TProgramInfo);
begin
  RegDeleteKey(HKey(Info['MainKey']), PChar(string(Info['SubKey'])));
end;

procedure Tdws2MFLib.dws2UnitRegistryFunctionsRegDeleteValueEval(
  Info: TProgramInfo);
var
  Key: HKey;
begin
  if RegOpenKeyEx(HKey(Info['MainKey']), PChar(string(Info['SubKey'])), 0,
    KEY_ALL_ACCESS, Key) = ERROR_SUCCESS then
  begin
    RegDeleteValue(Key, PChar(string(Info['ValName'])));
    RegCloseKey(Key);
  end;
end;

procedure Tdws2MFLib.dws2UnitRegistryFunctionsRegReadIntegerEval(
  Info: TProgramInfo);
var
  Key: HKey;
  I,
  D,
  D2: DWord;
begin
  Info['Result'] := Integer(Info['ValDef']);
  if RegOpenKeyEx(HKey(Info['MainKey']), PChar(string(Info['SubKey'])), 0,
    KEY_READ, Key) = ERROR_SUCCESS then
  begin
    D2 := Sizeof(I);
    if RegQueryValueEx(Key, PChar(string(Info['ValName'])), nil, @D, @I, @D2) =
      ERROR_SUCCESS then
      Info['Result'] := Integer(I);
    RegCloseKey(Key);
  end;
end;

procedure Tdws2MFLib.dws2UnitRegistryFunctionsRegReadStringEval(
  Info: TProgramInfo);
var
  Key: HKey;
  C: array[0..1023] of Char;
  D,
    D2: DWord;
begin
  Info['Result'] := string(Info['ValDef']);
  if RegOpenKeyEx(HKey(Info['MainKey']), PChar(string(Info['SubKey'])), 0,
    KEY_READ, Key) = ERROR_SUCCESS then
  begin
    D2 := Sizeof(C);
    if RegQueryValueEx(Key, PChar(string(Info['ValName'])), nil, @D, @C, @D2) =
      ERROR_SUCCESS then
      Info['Result'] := string(C);
    RegCloseKey(Key);
  end;
end;

procedure Tdws2MFLib.dws2UnitRegistryFunctionsRegGetTypeEval(
  Info: TProgramInfo);
var
  Key: HKey;
  D,
    D2: DWord;
begin
  Info['Result'] := 0;
  if RegOpenKeyEx(HKey(Info['MainKey']), PChar(string(Info['SubKey'])), 0,
    KEY_READ, Key) = ERROR_SUCCESS then
  begin
    D2 := 0;
    if RegQueryValueEx(Key, PChar(string(Info['ValName'])), nil, @D, nil, @D2) =
      ERROR_SUCCESS then
    begin
{$WARNINGS OFF}
      Info['Result'] := D;
      Info['Size'] := D2;
{$WARNINGS ON}
    end;
    RegCloseKey(Key);
  end;
end;

procedure Tdws2MFLib.dws2UnitRegistryFunctionsRegKeyExistsEval(
  Info: TProgramInfo);
var
  Key: HKey;
begin
  RegOpenKeyEx(HKey(Info['MainKey']), PChar(string(Info['SubKey'])), 0, KEY_READ,
    Key);
  Info['Result'] := Key <> 0;
  if Info['Result'] then
    RegCloseKey(Key);
end;

procedure Tdws2MFLib.dws2UnitRegistryFunctionsRegValueExistsEval(
  Info: TProgramInfo);
var
  Key: HKey;
  D,
    D2: DWord;
begin
  Info['Result'] := False;
  if RegOpenKeyEx(HKey(Info['MainKey']), PChar(string(Info['SubKey'])), 0,
    KEY_READ, Key) = ERROR_SUCCESS then
  begin
    D2 := 0;
    Info['Result'] := RegQueryValueEx(Key, PChar(string(Info['ValName'])), nil, @D,
      nil, @D2) = ERROR_SUCCESS;
    RegCloseKey(Key);
  end;
end;

procedure Tdws2MFLib.dws2UnitRegistryFunctionsRegWriteIntegerEval(
  Info: TProgramInfo);
var
  Key: HKey;
  I: DWord;
begin
  if RegOpenKeyEx(HKey(Info['MainKey']), PChar(string(Info['SubKey'])), 0,
    KEY_ALL_ACCESS, Key) = ERROR_SUCCESS then
  begin
    I := Info['Value'];
    RegSetValueEx(Key, PChar(string(Info['ValName'])), 0, REG_DWORD, @I,
      Sizeof(I));
    RegCloseKey(Key);
  end;
end;

procedure Tdws2MFLib.dws2UnitRegistryFunctionsRegWriteStringEval(
  Info: TProgramInfo);
var
  Key: HKey;
  S: string;
begin
  if RegOpenKeyEx(HKey(Info['MainKey']), PChar(string(Info['SubKey'])), 0,
    KEY_ALL_ACCESS, Key) = ERROR_SUCCESS then
  begin
    S := Info['Value'];
    RegSetValueEx(Key, PChar(string(Info['ValName'])), 0, REG_SZ, PChar(S),
      Length(S));
    RegCloseKey(Key);
  end;
end;

// ****************************************************************************
// *** Shell Functions ********************************************************
// ****************************************************************************

procedure Tdws2MFLib.dws2UnitShellFunctionsDesktopRefreshEval(
  Info: TProgramInfo);
begin
  SendMessage(FindWindow('Progman', 'Program Manager'),
    WM_COMMAND,
    $A065,
    0);
end;

// ****************************************************************************
// *** String Functions *******************************************************
// ****************************************************************************

procedure Tdws2MFLib.dws2UnitStringFunctionsANSI2OEMEval(
  Info: TProgramInfo);
var
  S: string;
begin
  S := Info['S'];
  Info['Result'] := ANSI2OEM(S);
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsChangeTokenValueEval(
  Info: TProgramInfo);
begin
  Info['Result'] := ChangeTokenValue(Info['S'], Info['Name'], Info['Value'],
    Info['Delimiter']);
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsChrEval(Info: TProgramInfo);
var
  S: string;
  i: Integer;
begin
  i := Info['Byte'];
  if (i >= 0) and (i <= 255) then
    S := Chr(i)
  else
    S := '';
  Info['Result'] := S;
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsCmpREEval(Info: TProgramInfo);
begin
  try
    Info['Result'] := ExecRegExpr(Info['RE'], Info['S']);
  except
    Info['Result'] := False;
  end;
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsCmpWCEval(Info: TProgramInfo);
begin
  Info['Result'] := CmpWC(Info['S'], Info['WC'], Info['Case']);
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsCropEval(Info: TProgramInfo);
var
  Text,
    Caption: string;
  Len: Integer;
  Direction: Integer;
  Separator: string;
  Parts: TStringList;
  FirstPartIsDrive: Boolean;

  procedure _AdjustCaption;
  var
    CurWidth,
      LenEtc,
      Start,
      Stop,
      iRep: Integer;
    StrDrive,
      StrEtc,
      StrRep,
      StrName: string;
  begin
    Start := 0;
    if (Text = '') or
      (Length(Text) <= Len) then
      Caption := Text
    else
    begin
      StrEtc := '...' + Separator;
      LenEtc := Length(StrEtc);
      StrName := Parts[Parts.Count - 1];
      CurWidth := Length(StrName);
      if (CurWidth + LenEtc) < Len then
      begin
        CurWidth := CurWidth + LenEtc;
        if FirstPartIsDrive then
        begin
          StrDrive := Parts[0] + Separator;
          Start := 1;
        end;
        if (CurWidth + Length(StrDrive)) < Len then
        begin
          CurWidth := CurWidth + Length(StrDrive);
          Stop := Parts.Count - 2;
          case Direction of
            CROP_LEFT:
              begin
                for iRep := Stop downto Start do
                begin
                  if (CurWidth + Length(Parts[iRep] + Separator + StrRep)) > Len
                    then
                    Break;
                  StrRep := Parts[iRep] + Separator + StrRep;
                end;
                Caption := StrDrive + StrEtc + StrRep + StrName;
              end;
            CROP_RIGHT:
              begin
                for iRep := Start to Stop do
                begin
                  if (CurWidth + Length(StrRep + Parts[iRep] + Separator)) > Len
                    then
                    Break;
                  StrRep := StrRep + Parts[iRep] + Separator;
                end;
                Caption := StrDrive + StrRep + StrEtc + StrName;
              end;
          end; {case Direction }
        end { if StrDrive }
        else
          Caption := StrEtc + StrName;
      end { if StrEtc }
      else
        Caption := StrName;
    end; { else }
  end;
  function _BreakApart(BaseString, BreakString: string; StringList: TStringList):
    TStringList;
  var
    EndOfCurrentString: Byte;
  begin
    repeat
      EndOfCurrentString := Pos(BreakString, BaseString);
      if EndOfCurrentString = 0 then
        StringList.Add(BaseString)
      else
        StringList.Add(Copy(BaseString, 1, EndOfCurrentString - 1));
      BaseString := Copy(BaseString, EndOfCurrentString + Length(BreakString),
        Length(BaseString) - EndOfCurrentString);
    until EndOfCurrentString = 0;
    Result := StringList;
  end;
  procedure _FillParts;
  begin
    Parts.Clear;
    _BreakApart(Text, Separator, Parts);
    if (Parts.Count <> 0) and
      (Length(Parts[0]) > 1) and
      (Parts[0][Length(Parts[0])] = ':') then
      FirstPartIsDrive := True
    else
      FirstPartIsDrive := False;
  end;
begin
  Text := Info['S'];
  Len := Info['Len'];
  Direction := Info['Dir'];
  Separator := Info['Delimiter'];
  Caption := '';
  try
    Parts := TStringList.Create;
    try
      _FillParts;
      _AdjustCaption;
      Info['Result'] := Caption;
    finally
      Parts.Free;
    end;
  except
    Info['Result'] := '';
  end;
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsForEachEval(
  Info: TProgramInfo);
var
  ProgInfo: TProgramInfo;
  PInfo: IInfo;
  ScriptObj: IScriptObj;
  StringsObj: TStringList;
  Flag,
    i: Integer;
begin
  Info['Result'] := False;

  ProgInfo := TProgramInfo.Create(Info.Caller.Table, Info.Caller);
  try
    try
      PInfo := ProgInfo.Func[Info['Func']];
      if Assigned(PInfo) then
      begin
        ScriptObj := IScriptObj(IUnknown(Info['List']));
        if ScriptObj = nil then
          Exit;
        StringsObj := TStringList(ScriptObj.ExternalObject);
        if StringsObj.Count = 0 then
        begin
          Info['Result'] := True;
          Exit;
        end;
        Flag := Info['Flag'];
        for i := 0 to StringsObj.Count - 1 do
          if not PInfo.Call([StringsObj[i], i, Flag]).Value then
            Exit;
        Info['Result'] := True;
      end;
    except
      ;
    end;
  finally
    ProgInfo.Free;
  end;
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsFormatColumnsEval(
  Info: TProgramInfo);
var
  ScriptObj: IScriptObj;
  StringsObj: TStringList;
  Delim: string;
begin
  ScriptObj := IScriptObj(IUnknown(Info['List']));
  if ScriptObj = nil then
    StringsObj := nil
  else
    StringsObj := TStringList(ScriptObj.ExternalObject);
  Delim := Info['Delimiter'];
  FormatColumns(StringsObj, Delim[1], Info['Space'], Info['Adjustment']);
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsGetCRC32FromStringEval(
  Info: TProgramInfo);
begin
  Info['Result'] := GetCRC32FromString(Info['S']);
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsGetStringFromListEval(
  Info: TProgramInfo);
var
  ScriptObj: IScriptObj;
  StringsObj: TStringList;
  Delim: string;
begin
  ScriptObj := IScriptObj(IUnknown(Info['List']));
  if ScriptObj = nil then
    StringsObj := nil
  else
    StringsObj := TStringList(ScriptObj.ExternalObject);
  Delim := Info['Delimiter'];
  Info['Result'] := GetStringFromList(StringsObj, Delim[1]);
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsGetTokenListEval(
  Info: TProgramInfo);
var
  SL: TStringList;
begin
  SL := GetTokenList(Info['S'], Info['Delimiter'], Info['Repeater'],
    Info['IgnoreFirst'], Info['IgnoreLast']);
  if Assigned(SL) then
    Info['Result'] := Info.Vars['TStringList'].GetConstructor('Create', SL).Call.Value
  else
    Info['Result'] := 0;
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsIncWCEval(Info: TProgramInfo);
var
  ebene: Integer;
begin
  ebene := -1;
  Info['Result'] := IncWC(Info['S'], Info['WC'], Info['Case'], ebene);
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsNum2TextEval(
  Info: TProgramInfo);
  function convNummer(i: Integer): string;
  var
    j: integer;
  begin
    if i = 0 then
      Result := ''
    else if i < 17 then
      Result := numNamesA[i]
    else if i < 20 then
      Result := numNamesA[i mod 10] + numNamesB[1]
    else if i < 100 then
    begin
      if (i mod 10) = 0 then
        Result := numNamesB[i div 10]
      else
        Result := numNamesA[i mod 10] + und + numNamesB[i div 10];
    end
    else if i < 1000 then
      Result := convNummer(i div 100) + hundert + convNummer(i mod 100)
    else if i < 1000000 then
      Result := convNummer(i div 1000) + tausend + convNummer(i mod 1000)
    else
    begin
      j := i div 1000000;
      if j = 1 then
        Result := 'eine'
      else
        Result := convNummer(j);
      Result := Result + million;
      if j > 1 then
        Result := Result + 'en';
      Result := Result + convNummer(i mod 1000000);
    end;
  end;
  function IntegerToKlartext(i: Integer): string;
  begin
    if i < 0 then
      Result := 'minus ' + IntegerToKlartext(-i)
    else if i = 0 then
      Result := 'null'
    else if i = 1 then
      Result := 'eins'
    else
      Result := convNummer(i);
  end;
begin
  Info['Result'] := IntegerToKlartext(Info['Num']);
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsOEM2ANSIEval(
  Info: TProgramInfo);
var
  S: string;
begin
  S := Info['S'];
  Info['Result'] := OEM2ANSI(S);
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsOrdEval(Info: TProgramInfo);
var
  S: string;
  i: Integer;
begin
  S := Info['Char'];
  i := Ord(S[1]);
  Info['Result'] := i;
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsPosXEval(Info: TProgramInfo);
begin
  Info['Result'] := PosX(Info['SubStr'], Info['S']);
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsStringOfCharEval(
  Info: TProgramInfo);
var
  S: string;
begin
  S := Info['Ch'];
  Info['Result'] := StringOfChar( S[1], Integer( Info['Count'] ) );
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsTestWCEval(Info: TProgramInfo);
begin
  Info['Result'] := TestWC(Info['S']);
end;

procedure Tdws2MFLib.dws2UnitStringFunctionsTranslateEval(
  Info: TProgramInfo);
var
  S,
    F: string;
begin
  S := Info['S'];
  F := Info['Place'];
  Info['Result'] := Translate(S, Info['Out'], Info['In'], F[1], Info['Case']);
end;

// ****************************************************************************
// *** System Functions *******************************************************
// ****************************************************************************

procedure Tdws2MFLib.dws2UnitSystemFunctionsShellExecuteEval(
  Info: TProgramInfo);
var
  O: string;
  F: string;
  P: string;
  D: string;
  PO: PChar;
  PF: PChar;
  PP: PChar;
  PD: PChar;
begin
  if VarType(Info['Operation']) = varString then
  begin
    O := Info['Operation'];
    PO := PChar(O);
  end
  else
    PO := nil;
  if VarType(Info['Filename']) = varString then
  begin
    F := Info['Filename'];
    PF := PChar(F);
  end
  else
    PF := nil;
  if VarType(Info['Parameters']) = varString then
  begin
    P := Info['Parameters'];
    PP := PChar(P);
  end
  else
    PP := nil;
  if VarType(Info['Directory']) = varString then
  begin
    D := Info['Directory'];
    PD := PChar(D);
  end
  else
    PD := nil;
{$WARNINGS OFF}
  Info['Result'] := ShellExecute(0, PO, PF, PP, PD, Info['ShowCmd']);
{$WARNINGS ON}
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsShellExecuteWaitEval(
  Info: TProgramInfo);
var
  F: string;
  P: string;
  D: string;
begin
  if VarType(Info['Filename']) = varString then
    F := Info['Filename']
  else
    F := '';
  if VarType(Info['Parameters']) = varString then
    P := Info['Parameters']
  else
    P := '';
  if VarType(Info['Directory']) = varString then
    D := Info['Directory']
  else
    D := '';
  Info['Result'] := ExecAndWait(F, P, D, Info['ShowCmd']);
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsExitWindowsExEval(
  Info: TProgramInfo);
  function SetPrivilege(PrivilegeName: string; Enable: Boolean): Boolean;
  var
    tpPrev,
      tp: TTokenPrivileges;
    token: THandle;
    dwRetLen: DWORD;
  begin
    Result := False;
    OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
      token);
    tp.PrivilegeCount := 1;
    if LookupPrivilegeValue(nil, PChar(PrivilegeName), tp.Privileges[0].LUID) then
    begin
      if enable then
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
      else
        tp.Privileges[0].Attributes := 0;
      dwRetLen := 0;
      Result := AdjustTokenPrivileges(token, False, tp, SizeOf(tpPrev), tpPrev,
        dwRetLen);
    end;
    CloseHandle(token);
  end;
begin
  Info['Result'] := False;
  if IsWinNT then
  begin
    if SetPrivilege('SeShutdownPrivilege', True) then
    begin
      Info['Result'] := ExitWindowsEx(Info['Flags'], 0);
      SetPrivilege('SeShutdownPrivilege', False)
    end;
  end
  else
    Info['Result'] := ExitWindowsEx(Info['Flags'], 0);
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsWriteMailslotEval(
  Info: TProgramInfo);
var
  MailslotName,
    MachineOrDomain: string;
  MailId: Integer;
  Mailtext: string;
  hMailslotClient: THandle;
  TextToSend: string;
  NumBytesWritten: DWord;
begin
  Info['Result'] := False;

  MachineOrDomain := Info['Machine'];
  MailslotName := Info['Mailslot'];
  Mailtext := Info['Text'];

  // A new client will only be created on valid machine/domain and mailslot-name
  if (MachineOrDomain <> '') and (MailslotName <> '') and (Mailtext <> '') then
  begin
    // Create a mailslot-client-handle for sending mails
    hMailslotClient := CreateFile(PChar('\\' + MachineOrDomain + '\mailslot\' +
      MailSlotName),
      GENERIC_WRITE,
      FILE_SHARE_READ,
      PSecurityAttributes(nil),
      OPEN_EXISTING,
      FILE_ATTRIBUTE_NORMAL,
      0);
    if hMailslotClient = INVALID_HANDLE_VALUE then
      Exit;

    // Write mail to mailslot
    Randomize;
    Random(999);
    MailId := Random(999) + 1;
    TextToSend := Format('%.3d%s ', [MailId, Mailtext]);
    Info['Result'] := WriteFile(hMailslotClient,
      PChar(TextToSend)^,
      Length(TextToSend),
      NumBytesWritten,
      nil);

    CloseHandle(hMailslotClient);
  end;
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsGetProcessListEval(
  Info: TProgramInfo);
var
  SL: TStringList;
begin
  GetProcessList;
  SL := TStringList.Create;
  SL.AddStrings(PI_DateiList);
  SL.Sort;
  Info['Result'] := Info.Vars['TStringList'].GetConstructor('Create', SL).Call.Value;
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsHiWordEval(Info: TProgramInfo);
begin
  Info['Result'] := HiWord(Info['Value']);
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsIsFileActiveEval(
  Info: TProgramInfo);
begin
  Info['Result'] := IsFileActive(Info['FileName']);
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsKillProcessEval(
  Info: TProgramInfo);
var
  Handle: HWnd;
  App,
    FileName: string;
begin
  Info['Result'] := False;

  Handle := Info['Window'];
  FileName := Info['FileName'];
  App := '';

  if Handle <> 0 then
    App := GetFileNameFromHandle(Handle);
  if FileName <> '' then
    if App = '' then
      App := FileName
    else if AnsiCompareText(App, FileName) <> 0 then
      Exit;

  if App <> '' then
    Info['Result'] := KillProcessByFileName(App, Info['KillAll']);
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsLoWordEval(Info: TProgramInfo);
begin
  Info['Result'] := LoWord(Info['Value']);
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsMakeLongEval(
  Info: TProgramInfo);
begin
  Info['Result'] := MakeLong(Info['Low'], Info['High']);
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsPostMessageEval(
  Info: TProgramInfo);
begin
  Info['Result'] := PostMessage(Info['Window'], Info['Msg'], Info['WParam'],
    Info['LParam']);
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsSendKeysEval(
  Info: TProgramInfo);
begin
  SendKeys(Info['Keys']);
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsSendKeysExEval(
  Info: TProgramInfo);
begin
  SendKeys(Info['Keys'], Info['Wait']);
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsSendKeysNamedWinEval(
  Info: TProgramInfo);
var
  w: string;
begin
  w := Info['Window'];
  Info['Result'] := SendKeysWin(w, string(Info['Keys']));
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsSendKeysNamedWinExEval(
  Info: TProgramInfo);
var
  w: string;
begin
  w := Info['Window'];
  Info['Result'] := SendKeysWin(w, string(Info['Keys']), Info['Wait'],
    Info['Back']);
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsSendKeysWinEval(
  Info: TProgramInfo);
var
  w: HWnd;
begin
  w := Info['Window'];
  Info['Result'] := SendKeysWin(w, string(Info['Keys']));
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsSendKeysWinExEval(
  Info: TProgramInfo);
var
  w: HWnd;
begin
  w := Info['Window'];
  Info['Result'] := SendKeysWin(w, string(Info['Keys']), Info['Wait'],
    Info['Back']);
end;

procedure Tdws2MFLib.dws2UnitSystemFunctionsSendMessageEval(
  Info: TProgramInfo);
begin
  Info['Result'] := SendMessage(Info['Window'], Info['Msg'], Info['WParam'],
    Info['LParam']);
end;

// ****************************************************************************
// *** Window Functions *******************************************************
// ****************************************************************************

procedure Tdws2MFLib.dws2UnitWindowFunctionsFindWindowEval(
  Info: TProgramInfo);
var
  cn: array[0..1023] of Char;
  wn: array[0..1023] of Char;
  cp: PChar;
  wp: PChar;
begin
  if string(Info['Class']) = '' then
    cp := nil
  else
  begin
    StrPCopy(cn, Info['Class']);
    cp := cn;
  end;
  if string(Info['Window']) = '' then
    wp := nil
  else
  begin
    StrPCopy(wn, Info['Window']);
    wp := wn;
  end;
{$WARNINGS OFF}
  Info['Result'] := FindWindow(cp, wp);
{$WARNINGS ON}
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsFindWindowExEval(
  Info: TProgramInfo);
var
  cn: array[0..1023] of Char;
  wn: array[0..1023] of Char;
  cp: PChar;
  wp: PChar;
begin
  if string(Info['Class']) = '' then
    cp := nil
  else
  begin
    StrPCopy(cn, Info['Class']);
    cp := cn;
  end;
  if string(Info['Window']) = '' then
    wp := nil
  else
  begin
    StrPCopy(wn, Info['Window']);
    wp := wn;
  end;
{$WARNINGS OFF}
  Info['Result'] := FindWindowEx(Info['Parent'], Info['ChildAfter'], cp, wp);
{$WARNINGS ON}
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsGetClassNameEval(
  Info: TProgramInfo);
var
  cn: array[0..1023] of Char;
begin
  GetClassName(Info['Window'], cn, 1023);
  Info['Result'] := string(cn);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsGetWindowTextEval(
  Info: TProgramInfo);
var
  wn: array[0..1023] of Char;
begin
  GetWindowText(Info['Window'], wn, 1023);
  Info['Result'] := string(wn);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsHideTaskbarEval(
  Info: TProgramInfo);
var
  wndHandle: THandle;
  wndClass: array[0..50] of Char;
begin
  StrPCopy(wndClass, 'Shell_TrayWnd');
  wndHandle := FindWindow(wndClass, nil);
  ShowWindow(wndHandle, SW_HIDE);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsIsIconicEval(
  Info: TProgramInfo);
var
  Handle: HWnd;
begin
  Handle := Info['Window'];
  Info['Result'] := IsIconic(Handle);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsIsWindowEval(
  Info: TProgramInfo);
var
  Handle: HWnd;
begin
  Handle := Info['Window'];
  Info['Result'] := IsWindow(Handle);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsIsWindowEnabledEval(
  Info: TProgramInfo);
var
  Handle: HWnd;
begin
  Handle := Info['Window'];
  Info['Result'] := IsWindowEnabled(Handle);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsIsWindowVisibleEval(
  Info: TProgramInfo);
var
  Handle: HWnd;
begin
  Handle := Info['Window'];
  Info['Result'] := IsWindowVisible(Handle);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsIsZoomedEval(
  Info: TProgramInfo);
var
  Handle: HWnd;
begin
  Handle := Info['Window'];
  Info['Result'] := IsZoomed(Handle);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsSearchWindowEval(
  Info: TProgramInfo);
var
  cn,
    wn: string;
begin
  cn := Info['Class'];
  wn := Info['Window'];
{$WARNINGS OFF}
  Info['Result'] := SearchWindow(cn, wn, Info['ProcID']);
{$WARNINGS ON}
  Info['Class'] := cn;
  Info['Window'] := wn;
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsSearchWindowExEval(
  Info: TProgramInfo);
var
  cn,
    wn: string;
begin
  cn := Info['Class'];
  wn := Info['Window'];
{$WARNINGS OFF}
  Info['Result'] := SearchWindowEx(Info['Parent'], Info['ChildAfter'], cn, wn,
    Info['Num']);
{$WARNINGS ON}
  Info['Class'] := cn;
  Info['Window'] := wn;
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsShowTaskbarEval(
  Info: TProgramInfo);
var
  wndHandle: THandle;
  wndClass: array[0..50] of Char;
begin
  StrPCopy(wndClass, 'Shell_TrayWnd');
  wndHandle := FindWindow(wndClass, nil);
  ShowWindow(wndHandle, SW_RESTORE);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsWaitForWindowEval(
  Info: TProgramInfo);
var
  cn,
    wn: string;
begin
  cn := Info['Class'];
  wn := Info['Window'];
{$WARNINGS OFF}
  Info['Result'] := WaitForWindow(cn, wn, Info['Timeout'], Info['ProcID']);
{$WARNINGS ON}
  Info['Class'] := cn;
  Info['Window'] := wn;
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsWaitForWindowCloseEval(
  Info: TProgramInfo);
var
  w: HWnd;
begin
  w := Info['Window'];
  Info['Result'] := WaitForWindowClose(w, Info['Timeout']);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsWaitForWindowCloseExEval(
  Info: TProgramInfo);
var
  cn,
    wn: string;
begin
  cn := Info['Class'];
  wn := Info['Window'];
  Info['Result'] := WaitForWindowClose(cn, wn, Info['Timeout'], Info['ProcID']);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsWaitForWindowEnabledEval(
  Info: TProgramInfo);
var
  w: HWnd;
begin
  w := Info['Window'];
  Info['Result'] := WaitForWindowEnabled(w, Info['Timeout']);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsWaitForWindowEnabledExEval(
  Info: TProgramInfo);
var
  cn,
    wn: string;
begin
  cn := Info['Class'];
  wn := Info['Window'];
  Info['Result'] := WaitForWindowEnabled(cn, wn, Info['Timeout'], Info['ProcID']);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsWaitForWindowExEval(
  Info: TProgramInfo);
var
  cn,
    wn: string;
begin
  cn := Info['Class'];
  wn := Info['Window'];
{$WARNINGS OFF}
  Info['Result'] := WaitForWindowEx(Info['Parent'], cn, wn, Info['Timeout'],
    Info['Num']);
{$WARNINGS ON}
  Info['Class'] := cn;
  Info['Window'] := wn;
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsWindowMoveEval(
  Info: TProgramInfo);
begin
  WindowMove(Info['Window'], Info['X'], Info['Y'], Info['Abs']);
end;

procedure Tdws2MFLib.dws2UnitWindowFunctionsWindowResizeEval(
  Info: TProgramInfo);
begin
  WindowResize(Info['Window'], Info['X'], Info['Y'], Info['Abs']);
end;

end.

