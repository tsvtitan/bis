{**********************************************************************}
{    DWS2 FTP Library  - Version 1.0                                   }
{    Developed by Fabrizio Vita (http://web.tiscali.it/bizio)           }
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at                                          }
{                                                                      }
{    http://www.mozilla.org/MPL/                                       }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{                                                                      }
{**********************************************************************}

unit dws2FTPModule;

interface

uses
  dws2Comp, dws2Exprs, Classes, ftpobjunit;

type
  Tdws2FTPLib = class(TDataModule)
    customFTPUnit: Tdws2Unit;
    procedure customFTPUnitClassesTFTPConnectionMethodsFindFirstEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsFindNextEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsFindCloseEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsIsDirectoryEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsFilesizeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsAbortEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsFreeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsOpenEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsGetFileEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsPutFileEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsChangeDirEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsMakeDirEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsExecuteEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsCreateSAVFEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsSetHostEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsGetHostEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsSetUserIDEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsGetUserIDEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsSetPwdEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsGetPWDEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsSetDefaultDirEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsGetDefaultDirEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsGetStatusEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsGetCurrentDirEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsDeleteFileEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsRemoveDirEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsCloseEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsConnectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsDisconnectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsLastErrorEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsLastResponseEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsSetLogFileEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsSetMaskPasswordEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionMethodsGetMaskPasswordEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customFTPUnitClassesTFTPConnectionConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
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
  dws2FTPLib: Tdws2FTPLib;

implementation

{$R *.dfm}

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2FTPLib]);
end;

procedure Tdws2FTPLib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FScript) then
    SetScript(nil);
end;

procedure Tdws2FTPLib.SetScript(const Value: TDelphiWebScriptII);
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
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsFindFirstEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  IsDir: boolean;
  size: integer;
  fn: string;
  FTPClientObj: TFtpClientObject;
  Specifier: string;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  Specifier := Info['Specifier'];
  FTPClientObj.FindFirst(Specifier, fn, isdir, size);
  Info.Result := fn;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsFindNextEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  IsDir: boolean;
  fn: string;
  Size: integer;
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FTPClientObj.FindNext(fn, IsDir, Size);
  Info.Result := fn;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsFindCloseEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FTPClientObj.FindClose;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsIsDirectoryEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  Size: integer;
  IsDir: boolean;
  FTPClientObj: TFtpClientObject;
  Nome: string;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  Nome := Info['Value'];

  FtpClientObj.GetFileProperties(Nome, IsDir, Size);
  if IsDir then
    Info.Result := true
  else
    Info.Result := False;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsFilesizeEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  IsDir: boolean;
  Size: integer;
  FTPClientObj: TFtpClientObject;
  Nome, err: string;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  Nome := Info['Value'];
  err := FtpClientObj.GetFileProperties(Nome, IsDir, Size);

  if err <> '' then
  begin
    Info.Result := -1;
  end
  else
  begin
    if IsDir then
    begin
      err := Name + ' is a directory';
      Info.Result := -1;
    end
    else
    begin
      Info.Result := Size;
    end;
  end;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsAbortEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FtpClientObj.Abort;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject.Create;
  ExtObject := FTPClientObj;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsFreeEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FTPClientObj.DisConnect;
  FTPClientObj.Free;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsOpenEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
  err: string;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FTPClientObj.Host := Info['Host'];
  FTPClientObj.Username := Info['Userid'];
  FTPClientObj.Password := Info['pwd'];
  err := FTPClientObj.Connect;
  Info.Result := (err = '');
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsGetFileEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
  err: string;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  err := FtpClientObj.Download(Info['Source'], Info['Dest']);
  Info.Result := (err = '');
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsPutFileEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
  err: string;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  err := FtpClientObj.Upload(Info['Source'], Info['Dest']);
  Info.Result := (err = '');
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsChangeDirEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
  err: string;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  err := FtpClientObj.ChangeDir(Info['DirName']);
  Info.Result := (err = '');
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsMakeDirEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
  err: string;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  err := FtpClientObj.Makedir(Info['dirName']);
  Info.Result := (err = '');
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsExecuteEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
  rets: integer;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FTPClientObj.Execute(Info['Command'], rets);
  Info.Result := rets;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsCreateSAVFEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
  command: string;
  rets: integer;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  Command := 'RMCD CRTSAVF FILE(' + Info['Library'] + '/' + Info['File'] + ') TEXT(''' + Info['Description'] + ''')';
  FTPClientObj.Execute(Command, rets);
  Info.Result := rets;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsSetHostEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FTPClientObj.Host := Info['Value'];
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsGetHostEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  Info.Result := FTPClientObj.Host;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsSetUserIDEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FTPClientObj.Username := Info['Value'];
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsGetUserIDEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  Info.Result := FTPClientObj.Username;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsSetPwdEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FTPClientObj.Password := Info['Value'];
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsGetPWDEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  Info.Result := FTPClientObj.Password;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsSetDefaultDirEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FTPClientObj.DefaultDir := Info['Value'];
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsGetDefaultDirEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  Info.Result := FTPClientObj.DefaultDir;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsGetStatusEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  Info.Result := FTPClientObj.Status;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsGetCurrentDirEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  Info.Result := FTPClientObj.CurrentDir;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsDeleteFileEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
  err: string;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  err := FTPClientObj.DeleteFile(Info['FileName']);
  Info.Result := (err = '');
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsRemoveDirEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
  err: string;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  err := FTPClientObj.RemoveDir(Info['DirName']);
  Info.Result := (err = '');
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsCloseEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FTPClientObj.DisConnect;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsConnectEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
  err: string;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  err := FTPClientObj.Connect;
  Info.Result := (err = '');
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsDisconnectEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FTPClientObj.DisConnect;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsLastErrorEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  Info.Result := FTPClientObj.LastError;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsLastResponseEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  Info.Result := FTPClientObj.LastResponse;
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsSetLogFileEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FTPClientObj.LogFile := Info['Value'];
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsSetMaskPasswordEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  FTPClientObj.MaskPassword := Info['Value'];
end;

procedure Tdws2FTPLib.customFTPUnitClassesTFTPConnectionMethodsGetMaskPasswordEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  FTPClientObj: TFtpClientObject;
begin
  FTPClientObj := TFtpClientObject(ExtObject);
  Info.Result := FTPClientObj.MaskPassword;
end;

end.

