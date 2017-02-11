{*******************************************************}
{                                                       }
{                       EhLib vX.X                      }
{                                                       }
{               PropStorage register unit               }
{                                                       }
{   Copyright (c) 2002 by Dmitry V. Bolshakov           }
{                                                       }
{*******************************************************}

{$I EhLib.Inc}
//{$I EhLibClx.Inc}

{$IFDEF EH_LIB_VCL}
unit PropStorageEhReg;
{$ELSE}
unit QPropStorageEhReg;
{$ENDIF}

interface

uses
{$IFDEF EH_LIB_VCL}
  {$IFDEF EH_LIB_6}DesignIntf, DesignEditors, VCLEditors, Variants,
  {$ELSE}DsgnIntf, {$ENDIF}
    PropStorageEh, PropStorageEditEh, Controls, Windows,
{$ELSE}
  DesignIntf, DesignEditors, Variants,
  QPropStorageEh, QPropStorageEditEh, QControls,
{$ENDIF}
   SysUtils, Classes;

procedure Register;

implementation

type

{ TPropertyNamesEhProperty }

  TPropertyNamesEhProperty = class(TPropertyEditor {TClassProperty})
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;

{ TPropStorageEhEditor }

  TPropStorageEhEditor = class(TComponentEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

{ TPropertyNamesEhProperty }

type
  TPersistentCracker = class(TPersistent);

procedure TPropertyNamesEhProperty.Edit;
var
  Obj: TPersistent;
begin
  Obj := GetComponent(0);
  while (Obj <> nil) and not (Obj is TComponent) do
    Obj := TPersistentCracker(Obj).GetOwner;
  if EditPropStorage(TPropStorageEh(Obj)) then
    Designer.Modified;
end;

function TPropertyNamesEhProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly {, paSubProperties}];
end;

function TPropertyNamesEhProperty.GetValue: string;
begin
  FmtStr(Result, '(%s)', [GetPropType^.Name]);
end;

{ TPropStorageEhEditor }

procedure TPropStorageEhEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: if EditPropStorage(TPropStorageEh(Component))  then
         Designer.Modified;
  end;
end;

function TPropStorageEhEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Stored properties ...';
  end;
end;

function TPropStorageEhEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{$IFDEF EH_LIB_VCL}

{ TRegistryKeyProperty }
type

  TRegistryKeyProperty = class(TIntegerProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

{ TRegistryKeyProperty }

function TRegistryKeyProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paSortList, paValueList];
end;

function TRegistryKeyProperty.GetValue: string;
begin
  if not RegistryKeyToIdent(HKEY(GetOrdValue), Result) then
    FmtStr(Result, '%d', [GetOrdValue]);
end;

procedure TRegistryKeyProperty.GetValues(Proc: TGetStrProc);
begin
  GetRegistryKeyValues(Proc);
end;

procedure TRegistryKeyProperty.SetValue(const Value: string);
var
  NewValue: Longint;
begin
  if IdentToRegistryKey(Value, NewValue)
    then SetOrdValue(NewValue)
    else inherited SetValue(Value);
end;

{$ENDIF}

procedure Register;
begin
{$IFDEF EH_LIB_CLX}
  GroupDescendentsWith(TPropStorageEh, QControls.TControl);
  GroupDescendentsWith(TPropStorageManagerEh, QControls.TControl);
//  GroupDescendentsWith(TIniPropStorageManEh, QControls.TControl);

  RegisterPropertyEditor(TypeInfo(TStrings), TPropStorageEh, 'StoredProps', TPropertyNamesEhProperty);
  RegisterComponentEditor(TPropStorageEh, TPropStorageEhEditor);

  RegisterComponents('System', [TPropStorageEh, TIniPropStorageManEh]);
{$ELSE}
  {$IFDEF EH_LIB_6}
  GroupDescendentsWith(TPropStorageEh, Controls.TControl);
  GroupDescendentsWith(TPropStorageManagerEh, Controls.TControl);
//  GroupDescendentsWith(TIniPropStorageManEh, Controls.TControl);
//  GroupDescendentsWith(TRegPropStorageManEh, Controls.TControl);
  {$ENDIF}

  RegisterPropertyEditor(TypeInfo(TStrings), TPropStorageEh, 'StoredProps', TPropertyNamesEhProperty);
  RegisterComponentEditor(TPropStorageEh, TPropStorageEhEditor);

  RegisterComponents('System', [TPropStorageEh, TIniPropStorageManEh, TRegPropStorageManEh]);
  RegisterPropertyEditor(TypeInfo(HKEY), TRegPropStorageManEh, 'Key', TRegistryKeyProperty);
{$ENDIF}
end;

end.
