{*******************************************************}
{                                                       }
{                       EhLib v2.5                      }
{                    Registration unit                  }
{                                                       }
{   Copyright (c) 1998, 2001 by Dmitry V. Bolshakov     }
{                                                       }
{*******************************************************}

{$I EhLib.Inc}

{$IFDEF EH_LIB_CLX}
unit QEhLibReg;
{$ELSE}
unit EhLibReg;
{$ENDIF}

interface

procedure Register;

implementation

{$IFDEF EH_LIB_VCL}
uses Classes, TypInfo,
{$IFDEF EH_LIB_6}DesignIntf, DesignEditors, VCLEditors, Variants,
{$ELSE}DsgnIntf, {$ENDIF}
  DBGridEh, GridEhEd, DBSumLst, PrViewEh, ComCtrls, SysUtils,
  DBCtrlsEh, PrnDbgEh, DBLookupEh, DB, ToolCtrlsEh, Controls;
{$ELSE}
uses Classes, TypInfo,DesignIntf, DesignEditors, Variants,
 QDBSumLst, QControls;
{$ENDIF}

{$IFDEF EH_LIB_VCL}

{ TListFieldProperty }

type
  TListFieldProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual;
    procedure GetValues(Proc: TGetStrProc); override;
    function GetDataSourcePropName: string; virtual;
  end;

function TListFieldProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

function GetPropertyValue(Instance: TPersistent; const PropName: string): TPersistent;
var
  PropInfo: PPropInfo;
begin
  Result := nil;
  PropInfo := TypInfo.GetPropInfo(Instance.ClassInfo, PropName);
  if (PropInfo <> nil) and (PropInfo^.PropType^.Kind = tkClass) then
    Result := TObject(GetOrdProp(Instance, PropInfo)) as TPersistent;
end;

procedure TListFieldProperty.GetValueList(List: TStrings);
var
  DataSource: TDataSource;
begin
  DataSource := GetPropertyValue(GetComponent(0), GetDataSourcePropName) as TDataSource;
  if (DataSource <> nil) and (DataSource.DataSet <> nil) then
    DataSource.DataSet.GetFieldNames(List);
end;

procedure TListFieldProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

function TListFieldProperty.GetDataSourcePropName: string;
begin
  Result := 'ListSource';
end;

{ TDateProperty
  Date property editor for Value property of TDBDateTimeEditEh components. }

type
  TVarDateProperty = class(TPropertyEditor)
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

function TVarDateProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paRevertable];
end;

function TVarDateProperty.GetValue: string;
var
  v: Variant;
begin
  v := GetVarValue;
  if v = Null then Result := ''
  else if TCustomDBDateTimeEditEh(GetComponent(0)).Kind = dtkDateEh then Result := DateToStr(v)
  else Result := TimeToStr(v);
end;

procedure TVarDateProperty.SetValue(const Value: string);
var
  v: Variant;
begin
  if Value = '' then v := Null
  else if TCustomDBDateTimeEditEh(GetComponent(0)).Kind = dtkDateEh then v := StrToDate(Value)
  else v := StrToTime(Value);
  SetVarValue(v);
end;

{ TNumberProperty
  Date property editor for Value property of TCustomDBNumberEditEh components. }

type
  TVarNumberProperty = class(TPropertyEditor)
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

function TVarNumberProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paRevertable];
end;

function TVarNumberProperty.GetValue: string;
var
  v: Variant;
begin
  v := GetVarValue;
  if v = Null then Result := ''
  else Result := FloatToStr(v);
end;

procedure TVarNumberProperty.SetValue(const Value: string);
var
  v: Variant;
begin
  if Value = '' then v := Null
  else v := StrToFloat(Value);
  SetVarValue(v);
end;

{$ENDIF}

procedure Register;
begin

{$IFDEF EH_LIB_VCL}

{$IFDEF EH_LIB_6}
  GroupDescendentsWith(TDBSumList, Controls.TControl);
  GroupDescendentsWith(TPrintDBGridEh, Controls.TControl);
{$ENDIF}

  RegisterComponents('Data Controls', [TDBGridEh]);
  RegisterComponentEditor(TDBGridEh, TDBGridEhEditor);
  RegisterPropertyEditor(TypeInfo(TCollection), TCustomDBGridEh, 'Columns', TDBGridEhColumnsProperty);

  RegisterComponents('Data Controls', [TDBEditEh, TDBDateTimeEditEh, TDBNumberEditEh, TDBComboBoxEh, TDBCheckBoxEh]);
  RegisterComponents('Data Controls', [TDBLookupComboboxEh]);
  RegisterPropertyEditor(TypeInfo(string), TDBLookupComboboxEh, 'KeyField', TListFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TDBLookupComboboxEh, 'ListField', TListFieldProperty);

  RegisterPropertyEditor(TypeInfo(TCollection), TColumnDropDownBoxEh, 'Columns', TDBGridEhColumnsProperty);
  RegisterComponentEditor(TDBLookupComboboxEh, TDBLookupComboboxEhEditor);

  RegisterPropertyEditor(TypeInfo(Variant), TCustomDBDateTimeEditEh, 'Value', TVarDateProperty);
  RegisterPropertyEditor(TypeInfo(Variant), TCustomDBNumberEditEh, 'Value', TVarNumberProperty);

  RegisterPropertyEditor(TypeInfo(string), TColumnEh, 'FieldName', TDBGridEhFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TColumnFooterEh, 'FieldName', TDBGridEhFieldAggProperty);

  RegisterPropertyEditor(TypeInfo(string), TPrintDBGridEh, 'PrintFontName', TFontNameProperty);

  RegisterComponents('Data Controls', [TDBSumList]);
  RegisterComponents('Data Controls', [TPrintDBGridEh]);
  RegisterComponents('System', [TPreviewBox]);

  { Property Category registration }
{$IFDEF EH_LIB_6}
  RegisterPropertyEditor(TypeInfo(TShortCut), TEditButtonEh, 'ShortCut', TShortCutProperty);
  RegisterPropertyEditor(TypeInfo(TShortCut), TSpecRowEh, 'ShortCut', TShortCutProperty);

  RegisterPropertiesInCategory(sDatabaseCategoryName, [TypeInfo(TDBGridColumnsEh)]);
  RegisterPropertyInCategory(sDatabaseCategoryName, TColumnEh, 'FieldName');
  RegisterPropertiesInCategory(sLocalizableCategoryName, TColumnEh, ['Picklist', 'KeyList']); { Do not localize }
  RegisterPropertiesInCategory(sLocalizableCategoryName, [TypeInfo(TColumnTitleEh)]);
  RegisterPropertiesInCategory(sVisualCategoryName, TColumnEh, ['AlwaysShowEditButton',
    'AutoFitColWidth', 'WordWrap', 'EndEllipsis', 'Checkboxes']);

{$ELSE}
{$IFDEF EH_LIB_5}
  RegisterPropertiesInCategory(TDatabaseCategory, [TypeInfo(TDBGridColumnsEh)]);
  RegisterPropertyInCategory(TDatabaseCategory, TColumnEh, 'FieldName');
  RegisterPropertiesInCategory(TLocalizableCategory, TColumnEh, ['Picklist', 'KeyList']); { Do not localize }
  RegisterPropertiesInCategory(TLocalizableCategory, [TypeInfo(TColumnTitleEh)]);
  RegisterPropertiesInCategory(TVisualCategory, TColumnEh, ['AlwaysShowEditButton',
    'AutoFitColWidth', 'WordWrap', 'EndEllipsis', 'Checkboxes']);
{$ENDIF}
{$ENDIF}

{$ELSE} //Clx

  GroupDescendentsWith(TDBSumList, QControls.TControl);
  RegisterComponents('Data Controls', [TDBSumList]);

{$ENDIF}

end;

end.
