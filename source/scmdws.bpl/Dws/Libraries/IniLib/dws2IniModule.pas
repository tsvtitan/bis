(******************************************************************************)
(** DWS 2 - Ini Module                                                       **)
(******************************************************************************)
(** Developed by: Jeremy Darling                                             **)
(** Developed on: July 10th 2001                                             **)
(** Developed in: Delphi v5.1 Professional                                   **)
(******************************************************************************)
(** This is a class wrapper for the TIniFile component, it works exaclty     **)
(** like the normal TIniFile                                                 **)
(******************************************************************************)

unit dws2IniModule;

interface

uses Windows, SysUtils, Classes, Controls, Forms, dws2Comp, dws2Exprs;

type
  Tdws2IniLib = class(TDataModule)
    IniUnit: Tdws2Unit;
    procedure ConstructorsCreateAssignExternalObject(Info: TProgramInfo;
      var ExtObject: TObject);
    procedure ReadStringEval(Info: TProgramInfo; ExtObject: TObject);
    procedure WriteStringEval(Info: TProgramInfo; ExtObject: TObject);
    procedure EraseSectionEval(Info: TProgramInfo; ExtObject: TObject);
    procedure DeleteKeyEval(Info: TProgramInfo; ExtObject: TObject);
    procedure UpdateFileEval(Info: TProgramInfo; ExtObject: TObject);
    procedure SectionExistsEval(Info: TProgramInfo; ExtObject: TObject);
    procedure ReadIntegerEval(Info: TProgramInfo; ExtObject: TObject);
    procedure WriteIntegerEval(Info: TProgramInfo; ExtObject: TObject);
    procedure ReadBoolEval(Info: TProgramInfo; ExtObject: TObject);
    procedure WriteBoolEval(Info: TProgramInfo; ExtObject: TObject);
    procedure ReadDateEval(Info: TProgramInfo; ExtObject: TObject);
    procedure ReadDateTimeEval(Info: TProgramInfo; ExtObject: TObject);
    procedure ReadFloatEval(Info: TProgramInfo; ExtObject: TObject);
    procedure ReadTimeEval(Info: TProgramInfo; ExtObject: TObject);
    procedure WriteDateEval(Info: TProgramInfo; ExtObject: TObject);
    procedure WriteDateTimeEval(Info: TProgramInfo; ExtObject: TObject);
    procedure WriteFloatEval(Info: TProgramInfo; ExtObject: TObject);
    procedure WriteTimeEval(Info: TProgramInfo; ExtObject: TObject);
    procedure ValueExistsEval(Info: TProgramInfo; ExtObject: TObject);
    procedure GetFileNameEval(Info: TProgramInfo; ExtObject: TObject);
    procedure ReadSectionEval(Info: TProgramInfo; ExtObject: TObject);
    procedure ReadSectionsEval(Info: TProgramInfo; ExtObject: TObject);
    procedure ReadSectionValuesEval(Info: TProgramInfo; ExtObject: TObject);
    procedure DestructEval(Info: TProgramInfo; ExtObject: TObject);
  private
    FScript: TDelphiWebScriptII;
    procedure SetScript(const Value: TDelphiWebScriptII);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property Script: TDelphiWebScriptII read FScript write SetScript;
  end;

procedure Register;

implementation

{$R *.DFM}

uses Registry, IniFiles, dws2Symbols;

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2IniLib]);
end;

{ Tdws2Ini }

procedure Tdws2IniLib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Script) then
    SetScript(nil)
end;

procedure Tdws2IniLib.SetScript(const Value: TDelphiWebScriptII);
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

procedure Tdws2IniLib.ReadStringEval;
begin
  Info['Result'] := TIniFile(ExtObject).ReadString(Info['Section'], Info['Ident'], Info['Default']);
end;

procedure Tdws2IniLib.WriteStringEval;
begin
  TIniFile(ExtObject).WriteString(Info['Section'], Info['Ident'], Info['Value']);
end;

procedure Tdws2IniLib.EraseSectionEval;
begin
  TIniFile(ExtObject).EraseSection(Info['Section']);
end;

procedure Tdws2IniLib.DeleteKeyEval;
begin
  TIniFile(ExtObject).DeleteKey(Info['Section'], Info['Ident']);
end;

procedure Tdws2IniLib.UpdateFileEval;
begin
  TIniFile(ExtObject).UpdateFile;
end;

procedure Tdws2IniLib.SectionExistsEval;
begin
  Info['Result'] := TIniFile(ExtObject).SectionExists(Info['Section']);
end;

procedure Tdws2IniLib.ReadIntegerEval;
begin
  Info['Result'] := TIniFile(ExtObject).ReadInteger(Info['Section'], Info['Ident'], Info['Default']);
end;

procedure Tdws2IniLib.WriteIntegerEval;
begin
  TIniFile(ExtObject).WriteInteger(Info['Section'], Info['Ident'], Info['Value']);
end;

procedure Tdws2IniLib.ReadBoolEval;
begin
  Info['Result'] := TIniFile(ExtObject).ReadBool(Info['Section'], Info['Ident'], Info['Default']);
end;

procedure Tdws2IniLib.WriteBoolEval;
begin
  TIniFile(ExtObject).WriteBool(Info['Section'], Info['Ident'], Info['Value']);
end;

procedure Tdws2IniLib.ReadDateEval;
begin
  Info['Result'] := TIniFile(ExtObject).ReadDate(Info['Section'], Info['Name'], Info['Default']);
end;

procedure Tdws2IniLib.ReadDateTimeEval;
begin
  Info['Result'] := TIniFile(ExtObject).ReadDateTime(Info['Section'], Info['Name'], Info['Default']);
end;

procedure Tdws2IniLib.ReadFloatEval;
begin
  Info['Result'] := TIniFile(ExtObject).ReadFloat(Info['Section'], Info['Name'], Info['Default']);
end;

procedure Tdws2IniLib.ReadTimeEval;
begin
  Info['Result'] := TIniFile(ExtObject).ReadTime(Info['Section'], Info['Name'], Info['Default']);
end;

procedure Tdws2IniLib.WriteDateEval;
begin
  TIniFile(ExtObject).WriteDate(Info['Section'], Info['Name'], Info['Value']);
end;

procedure Tdws2IniLib.WriteDateTimeEval;
begin
  TIniFile(ExtObject).WriteDateTime(Info['Section'], Info['Name'], Info['Value']);
end;

procedure Tdws2IniLib.WriteFloatEval;
begin
  TIniFile(ExtObject).WriteFloat(Info['Section'], Info['Name'], Info['Value']);
end;

procedure Tdws2IniLib.WriteTimeEval;
begin
  TIniFile(ExtObject).WriteTime(Info['Section'], Info['Name'], Info['Value']);
end;

procedure Tdws2IniLib.ValueExistsEval;
begin
  Info['Result'] := TIniFile(ExtObject).ValueExists(Info['Section'], Info['Ident']);
end;

procedure Tdws2IniLib.GetFileNameEval;
begin
  Info['Result'] := TIniFile(ExtObject).FileName;
end;

procedure Tdws2IniLib.ConstructorsCreateAssignExternalObject;
begin
  ExtObject := TIniFile.Create(Info['FileName']);
end;

procedure Tdws2IniLib.ReadSectionEval;
begin
  TIniFile(ExtObject).ReadSection(Info['Section'],
    TStringList(IScriptObj(IUnknown(Info['Strings'])).ExternalObject));
end;

procedure Tdws2IniLib.ReadSectionsEval;
begin
  TIniFile(ExtObject).ReadSections(
    TStringList(IScriptObj(IUnknown(Info['Strings'])).ExternalObject));
end;

procedure Tdws2IniLib.ReadSectionValuesEval;
begin
  TRegistryIniFile(ExtObject).ReadSectionValues(Info['Section'],
    TStringList(IScriptObj(IUnknown(Info['Strings'])).ExternalObject));
end;

procedure Tdws2IniLib.DestructEval;
begin
  // Empty
end;

end.
