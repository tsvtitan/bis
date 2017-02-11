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

unit dws2MFZipLibModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ZipUnzip,
  dws2Comp, dws2Exprs;

const
  Zip_Add = 0;
  Zip_Move = 1;
  Zip_Update = 2;
  Zip_Freshen = 3;

  Zip_Extract = 0;
  Zip_Test = 1;

type
  Tdws2MFZipLib = class(TDataModule)
    dws2UnitZip: Tdws2Unit;
    procedure dws2UnitZipClassesTZipMethodsCreateEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsDestroyEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsAddEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsAddListEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsDeleteEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsDeleteListEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsExtractEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsExtractListEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsListEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsMessageEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadSpanEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsSFX2ZIPEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteSpanEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsZIP2SFXEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadAddHiddenFilesEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteAddHiddenFilesEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadAddZipTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteAddZipTimeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadAddDirNamesEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteAddDirNamesEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadAddSeparateDirsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteAddSeparateDirsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadAddCompLevelEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteAddCompLevelEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadAddRecurseDirsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteAddRecurseDirsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadAddEncryptEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteAddEncryptEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadPasswordEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWritePasswordEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadExtrDirNamesEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteExtrDirNamesEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadExtrOverwriteEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteExtrOverwriteEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadConfirmEraseEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteConfirmEraseEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadHowToDeleteEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteHowToDeleteEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadAddDiskSpanEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteAddDiskSpanEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadAddDiskSpanEraseEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteAddDiskSpanEraseEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadMaxVolumeSizeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteMaxVolumeSizeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadMinFreeVolumeSizeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteMinFreeVolumeSizeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadKeepFreeOnDisk1Eval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteKeepFreeOnDisk1Eval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadSFXCaptionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteSFXCaptionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadSFXCommandLineEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteSFXCommandLineEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadSFXDefaultDirEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteSFXDefaultDirEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadSFXAskCmdLineEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteSFXAskCmdLineEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadSFXAskFilesEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteSFXAskFilesEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadSFXHideOverwriteBoxEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteSFXHideOverwriteBoxEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadSFXOverwriteModeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteSFXOverwriteModeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsReadTempEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitZipClassesTZipMethodsWriteTempEval(
      Info: TProgramInfo; ExtObject: TObject);
  private
    FScript: TDelphiWebScriptII;
    procedure SetScript(const Value: TDelphiWebScriptII);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property Script: TDelphiWebScriptII read FScript write SetScript;
  end;

procedure Register;

var
  dws2MFZipLib: Tdws2MFZipLib;

implementation

{$R *.DFM}
{$R ZipMsgUS.res}

uses
  dws2MFLibUtils, dws2Symbols;

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2MFZipLib]);
end;

{ Tdws2MFZipLib }

procedure Tdws2MFZipLib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Script) then
    SetScript(nil)
end;

procedure Tdws2MFZipLib.SetScript(const Value: TDelphiWebScriptII);
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
    AddIntConst(dws2UnitZip, 'Zip_Add', Zip_Add);
    AddIntConst(dws2UnitZip, 'Zip_Move', Zip_Move);
    AddIntConst(dws2UnitZip, 'Zip_Update', Zip_Update);
    AddIntConst(dws2UnitZip, 'Zip_Freshen', Zip_Freshen);
    AddIntConst(dws2UnitZip, 'Zip_Extract', Zip_Extract);
    AddIntConst(dws2UnitZip, 'Zip_Test', Zip_Test);
    AddIntConst(dws2UnitZip, 'Zip_OverwriteConfirm', Integer(OvrConfirm));
    AddIntConst(dws2UnitZip, 'Zip_OverwriteAlways', Integer(OvrAlways));
    AddIntConst(dws2UnitZip, 'Zip_OverwriteNever', Integer(OvrNever));
    AddIntConst(dws2UnitZip, 'Zip_EraseFinal', Integer(htdFinal));
    AddIntConst(dws2UnitZip, 'Zip_EraseAllowUndo', Integer(htdAllowUndo));
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsCreateEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  Dir: array[0..MAX_PATH] of Char;
begin
  if not Assigned(ExtObject) then
    ExtObject := TZipMaster.Create(nil);
  with (ExtObject as TZipMaster) do
  begin
    Load_Zip_Dll;
    Load_Unz_Dll;

    AddCompLevel := 9;
    AddOptions := [];
    ConfirmErase := True;
    DLLDirectory := '';
    ExtrBaseDir := '';
    ExtrOptions := [];
    FSpecArgs.Clear;
    HowToDelete := htdAllowUndo;
    KeepFreeOnDisk1 := 0;
    MaxVolumeSize := 0;
    MinFreeVolumeSize := 65536;
    Password := '';
    SFXCaption := '';
    SFXCommandLine := '';
    SFXDefaultDir := '';
    SFXOptions := [SFXAskCmdLine, SFXAskFiles, SFXCheckSize];
    SFXOverWriteMode := OvrConfirm;
    SFXPath := '';
    if GetEnvironmentVariable('TEMP', Dir, MAX_PATH) > 0 then
      TempDir := string(Dir)
    else if GetEnvironmentVariable('TMP', Dir, MAX_PATH) > 0 then
      TempDir := string(Dir)
    else
      TempDir := '';
    Trace := False;
    Unattended := False;
    Verbose := False;
    ZipFilename := '';
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TZipMaster).Free;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsAddEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    case Info['Action'] of
      Zip_Move:
        AddOptions := AddOptions + [AddMove];
      Zip_Update:
        AddOptions := AddOptions + [AddUpdate];
      Zip_Freshen:
        AddOptions := AddOptions + [AddFreshen];
    end;
    ZipFilename := Info['ZipFile'];
    if ExtractFileExt(ZipFilename) = '' then
      ChangeFileExt(ZipFilename, '.zip');
    FSpecArgs.Add(Info['FileName']);
    try
      Add;
    finally
      Info['Result'] := ErrCode;
      AddOptions := AddOptions - [AddMove, AddUpdate, AddFreshen];
      ZipFilename := '';
      FSpecArgs.Clear;
    end;
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsAddListEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  ScriptObj: IScriptObj;
  StringsObj: TStringList;
begin
  with (ExtObject as TZipMaster) do
  begin
    case Info['Action'] of
      Zip_Move:
        AddOptions := AddOptions + [AddMove];
      Zip_Update:
        AddOptions := AddOptions + [AddUpdate];
      Zip_Freshen:
        AddOptions := AddOptions + [AddFreshen];
    end;
    ZipFilename := Info['ZipFile'];
    if ExtractFileExt(ZipFilename) = '' then
      ChangeFileExt(ZipFilename, '.zip');
    ScriptObj := IScriptObj(IUnknown(Info['FileNames']));
    if ScriptObj = nil then
      StringsObj := nil
    else
      StringsObj := TStringList(ScriptObj.ExternalObject);
    FSpecArgs.AddStrings(StringsObj);
    try
      Add;
    finally
      Info['Result'] := ErrCode;
      AddOptions := AddOptions - [AddMove, AddUpdate, AddFreshen];
      ZipFilename := '';
      FSpecArgs.Clear;
    end;
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsDeleteEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    ZipFilename := Info['ZipFile'];
    if ExtractFileExt(ZipFilename) = '' then
      ChangeFileExt(ZipFilename, '.zip');
    FSpecArgs.Add(Info['FileName']);
    try
      Delete;
    finally
      Info['Result'] := ErrCode;
      ZipFilename := '';
      FSpecArgs.Clear;
    end;
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsDeleteListEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  ScriptObj: IScriptObj;
  StringsObj: TStringList;
begin
  with (ExtObject as TZipMaster) do
  begin
    ZipFilename := Info['ZipFile'];
    if ExtractFileExt(ZipFilename) = '' then
      ChangeFileExt(ZipFilename, '.zip');
    ScriptObj := IScriptObj(IUnknown(Info['FileNames']));
    if ScriptObj = nil then
      StringsObj := nil
    else
      StringsObj := TStringList(ScriptObj.ExternalObject);
    FSpecArgs.AddStrings(StringsObj);
    try
      Delete;
    finally
      Info['Result'] := ErrCode;
      ZipFilename := '';
      FSpecArgs.Clear;
    end;
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsExtractEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    case Info['Action'] of
      Zip_Test:
        ExtrOptions := ExtrOptions + [ExtrTest];
      Zip_Update:
        ExtrOptions := ExtrOptions + [ExtrUpdate];
      Zip_Freshen:
        ExtrOptions := ExtrOptions + [ExtrFreshen];
    end;
    ZipFilename := Info['ZipFile'];
    if ExtractFileExt(ZipFilename) = '' then
      ChangeFileExt(ZipFilename, '.zip');
    FSpecArgs.Add(Info['FileName']);
    ExtrBaseDir := Info['BaseDir'];
    try
      Extract;
    finally
      Info['Result'] := ErrCode;
      ZipFilename := '';
      FSpecArgs.Clear;
      ExtrBaseDir := '';
    end;
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsExtractListEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  ScriptObj: IScriptObj;
  StringsObj: TStringList;
begin
  with (ExtObject as TZipMaster) do
  begin
    case Info['Action'] of
      Zip_Test:
        ExtrOptions := ExtrOptions + [ExtrTest];
      Zip_Update:
        ExtrOptions := ExtrOptions + [ExtrUpdate];
      Zip_Freshen:
        ExtrOptions := ExtrOptions + [ExtrFreshen];
    end;
    ZipFilename := Info['ZipFile'];
    if ExtractFileExt(ZipFilename) = '' then
      ChangeFileExt(ZipFilename, '.zip');
    ScriptObj := IScriptObj(IUnknown(Info['FileNames']));
    if ScriptObj = nil then
      StringsObj := nil
    else
      StringsObj := TStringList(ScriptObj.ExternalObject);
    FSpecArgs.AddStrings(StringsObj);
    ExtrBaseDir := Info['BaseDir'];
    try
      Extract;
    finally
      Info['Result'] := ErrCode;
      ZipFilename := '';
      FSpecArgs.Clear;
      ExtrBaseDir := '';
    end;
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsListEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  SL: TStringList;
  i: Integer;
begin
  Info['Result'] := 0;
  SL := TStringList.Create;
  with (ExtObject as TZipMaster) do
  begin
    ZipFilename := Info['ZipFile'];
    if ExtractFileExt(ZipFilename) = '' then
      ChangeFileExt(ZipFilename, '.zip');
    try
      for i := 0 to Count - 1 do
      begin
        SL.Add( ZipDirEntry( ZipContents[i]^ ).FileName );
      end;
      SL.Sort;
      Info['Result'] := Info.Vars['TStringList'].GetConstructor('Create', SL).Call.Value;
    finally
      ZipFilename := '';
    end;
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsMessageEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := LoadStr(Info['ZipFile']);
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadSpanEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  S: string;
begin
  S := Info['ZipFile'];
  Info['Result'] := (ExtObject as TZipMaster).ReadSpan(Info['SpanFile'], S);
  Info['ZipFile'] := S;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsSFX2ZIPEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    ZipFilename := Info['ZipFile'];
    if ExtractFileExt(ZipFilename) = '' then
      ChangeFileExt(ZipFilename, '.exe');
    try
      Info['Result'] := ConvertZIP;
    finally
      ZipFilename := '';
    end;
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteSpanEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TZipMaster).WriteSpan(Info['ZipFile'], Info['SpanFile']);
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsZIP2SFXEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    ZipFilename := Info['ZipFile'];
    if ExtractFileExt(ZipFilename) = '' then
      ChangeFileExt(ZipFilename, '.zip');
    try
      Info['Result'] := ConvertSFX;
    finally
      ZipFilename := '';
    end;
  end;
end;

// ****************************************************************************

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadAddHiddenFilesEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := AddHiddenFiles in (ExtObject as TZipMaster).AddOptions;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteAddHiddenFilesEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    if Info['Value'] then
      AddOptions := AddOptions + [AddHiddenFiles]
    else
      AddOptions := AddOptions - [AddHiddenFiles];
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadAddZipTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := AddZipTime in (ExtObject as TZipMaster).AddOptions;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteAddZipTimeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    if Info['Value'] then
      AddOptions := AddOptions + [AddZipTime]
    else
      AddOptions := AddOptions - [AddZipTime];
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadAddDirNamesEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := AddDirNames in (ExtObject as TZipMaster).AddOptions;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteAddDirNamesEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    if Info['Value'] then
      AddOptions := AddOptions + [AddDirNames]
    else
      AddOptions := AddOptions - [AddDirNames];
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadAddSeparateDirsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := AddSeparateDirs in (ExtObject as TZipMaster).AddOptions;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteAddSeparateDirsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    if Info['Value'] then
      AddOptions := AddOptions + [AddSeparateDirs]
    else
      AddOptions := AddOptions - [AddSeparateDirs];
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadAddCompLevelEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TZipMaster).AddCompLevel;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteAddCompLevelEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TZipMaster).AddCompLevel := Info['Value'];
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadAddRecurseDirsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := AddRecurseDirs in (ExtObject as TZipMaster).AddOptions;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteAddRecurseDirsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    if Info['Value'] then
      AddOptions := AddOptions + [AddRecurseDirs]
    else
      AddOptions := AddOptions - [AddRecurseDirs];
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadAddEncryptEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := AddEncrypt in (ExtObject as TZipMaster).AddOptions;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteAddEncryptEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    if Info['Value'] then
      AddOptions := AddOptions + [AddEncrypt]
    else
      AddOptions := AddOptions - [AddEncrypt];
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadPasswordEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TZipMaster).Password;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWritePasswordEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TZipMaster).Password := Info['Value'];
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadExtrDirNamesEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := ExtrDirNames in (ExtObject as TZipMaster).ExtrOptions;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteExtrDirNamesEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    if Info['Value'] then
      ExtrOptions := ExtrOptions + [ExtrDirNames]
    else
      ExtrOptions := ExtrOptions - [ExtrDirNames];
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadExtrOverwriteEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := ExtrOverWrite in (ExtObject as TZipMaster).ExtrOptions;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteExtrOverwriteEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    if Info['Value'] then
      ExtrOptions := ExtrOptions + [ExtrOverWrite]
    else
      ExtrOptions := ExtrOptions - [ExtrOverWrite];
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadConfirmEraseEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TZipMaster).ConfirmErase;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteConfirmEraseEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TZipMaster).ConfirmErase := Info['Value'];
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadHowToDeleteEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TZipMaster).HowToDelete;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteHowToDeleteEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TZipMaster).HowToDelete := Info['Value'];
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadAddDiskSpanEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := AddDiskSpan in (ExtObject as TZipMaster).AddOptions;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteAddDiskSpanEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    AddOptions := AddOptions - [AddDiskSpanErase];
    if Info['Value'] then
      AddOptions := AddOptions + [AddDiskSpan]
    else
      AddOptions := AddOptions - [AddDiskSpan];
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadAddDiskSpanEraseEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := AddDiskSpanErase in (ExtObject as TZipMaster).AddOptions;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteAddDiskSpanEraseEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    AddOptions := AddOptions - [AddDiskSpan];
    if Info['Value'] then
      AddOptions := AddOptions + [AddDiskSpanErase]
    else
      AddOptions := AddOptions - [AddDiskSpanErase];
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadMaxVolumeSizeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TZipMaster).MaxVolumeSize;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteMaxVolumeSizeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TZipMaster).MaxVolumeSize := Info['Value'];
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadMinFreeVolumeSizeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TZipMaster).MinFreeVolumeSize;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteMinFreeVolumeSizeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TZipMaster).MinFreeVolumeSize := Info['Value'];
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadKeepFreeOnDisk1Eval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TZipMaster).KeepFreeOnDisk1;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteKeepFreeOnDisk1Eval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TZipMaster).KeepFreeOnDisk1 := Info['Value'];
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadSFXCaptionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TZipMaster).SFXCaption;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteSFXCaptionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TZipMaster).SFXCaption := Info['Value'];
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadSFXCommandLineEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TZipMaster).SFXCommandLine;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteSFXCommandLineEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TZipMaster).SFXCommandLine := Info['Value'];
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadSFXDefaultDirEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TZipMaster).SFXDefaultDir;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteSFXDefaultDirEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TZipMaster).SFXDefaultDir := Info['Value'];
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadSFXAskCmdLineEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := SFXAskCmdLine in (ExtObject as TZipMaster).SFXOptions;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteSFXAskCmdLineEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    if Info['Value'] then
      SFXOptions := SFXOptions + [SFXAskCmdLine]
    else
      SFXOptions := SFXOptions - [SFXAskCmdLine];
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadSFXAskFilesEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := SFXAskFiles in (ExtObject as TZipMaster).SFXOptions;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteSFXAskFilesEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    if Info['Value'] then
      SFXOptions := SFXOptions + [SFXAskFiles]
    else
      SFXOptions := SFXOptions - [SFXAskFiles];
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadSFXHideOverwriteBoxEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := SFXHideOverWriteBox in (ExtObject as TZipMaster).SFXOptions;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteSFXHideOverwriteBoxEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with (ExtObject as TZipMaster) do
  begin
    if Info['Value'] then
      SFXOptions := SFXOptions + [SFXHideOverWriteBox]
    else
      SFXOptions := SFXOptions - [SFXHideOverWriteBox];
  end;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadSFXOverwriteModeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TZipMaster).SFXOverWriteMode;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteSFXOverwriteModeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TZipMaster).SFXOverWriteMode := Info['Value'];
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsReadTempEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := (ExtObject as TZipMaster).TempDir;
end;

procedure Tdws2MFZipLib.dws2UnitZipClassesTZipMethodsWriteTempEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  (ExtObject as TZipMaster).TempDir := Info['Value'];
end;

end.
