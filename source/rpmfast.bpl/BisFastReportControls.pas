unit BisFastReportControls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, StdCtrls, Variants,
  ExtCtrls, Forms, Menus, Dialogs, Comctrls, Buttons, Mask, CheckLst, DB, 
  frxClass, frxDsgnIntf,
  BisControls;

type
  TBisLabelControl = class(TfrxDialogControl)
  private
    FLabel: TLabel;
    FFocusControl: TfrxDialogControl;
    function GetAlignment: TAlignment;
    function GetAutoSize: Boolean;
    function GetWordWrap: Boolean;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetAutoSize(const Value: Boolean);
    procedure SetWordWrap(const Value: Boolean);
    procedure SetFocusControl(Value: TfrxDialogControl);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    procedure BeforeStartReport; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    property LabelCtl: TLabel read FLabel;
  published
    property Alignment: TAlignment read GetAlignment write SetAlignment
      default taLeftJustify;
    property AutoSize: Boolean read GetAutoSize write SetAutoSize default True;
    property Caption;
    property Color;
    property WordWrap: Boolean read GetWordWrap write SetWordWrap default False;
    property FocusControl: TfrxDialogControl read FFocusControl write SetFocusControl;

    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TBisEdit=class(TEdit)
  private
    FReport: TfrxReport;
  protected
    property Report: TfrxReport read FReport write FReport;
  end;

  TBisEditControl = class(TfrxDialogControl)
  private
    FEdit: TBisEdit;
    FOnChange: TfrxNotifyEvent;
    function GetMaxLength: Integer;
    function GetPasswordChar: Char;
    function GetReadOnly: Boolean;
    function GetText: String;
    procedure DoOnChange(Sender: TObject);
    procedure SetMaxLength(const Value: Integer);
    procedure SetPasswordChar(const Value: Char);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetText(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property Edit: TBisEdit read FEdit;
  published
    property Color;
    property MaxLength: Integer read GetMaxLength write SetMaxLength;
    property PasswordChar: Char read GetPasswordChar write SetPasswordChar;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property Text: String read GetText write SetText;
    property OnChange: TfrxNotifyEvent read FOnChange write FOnChange;
    property TabStop;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TBisMemo=class(TMemo)
  private
    FReport: TfrxReport;
  protected
    property Report: TfrxReport read FReport write FReport;
  end;

  TBisMemoControl = class(TfrxDialogControl)
  private
    FMemo: TBisMemo;
    FOnChange: TfrxNotifyEvent;
    function GetMaxLength: Integer;
    function GetPasswordChar: Char;
    function GetReadOnly: Boolean;
    function GetText: String;
    procedure DoOnChange(Sender: TObject);
    procedure SetMaxLength(const Value: Integer);
    procedure SetPasswordChar(const Value: Char);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetText(const Value: String);
    function GetLines: TStrings;
    procedure SetLines(const Value: TStrings);
    function GetScrollStyle: TScrollStyle;
    function GetWordWrap: Boolean;
    procedure SetScrollStyle(const Value: TScrollStyle);
    procedure SetWordWrap(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property Memo: TBisMemo read FMemo;
  published
    property Color;
    property Lines: TStrings read GetLines write SetLines;
    property MaxLength: Integer read GetMaxLength write SetMaxLength;
    property PasswordChar: Char read GetPasswordChar write SetPasswordChar;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ScrollBars: TScrollStyle read GetScrollStyle write SetScrollStyle default ssNone;
    property Text: String read GetText write SetText;
    property WordWrap: Boolean read GetWordWrap write SetWordWrap default True;
    property OnChange: TfrxNotifyEvent read FOnChange write FOnChange;
    property TabStop;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TBisComboBox=class(TComboBox)
  private
    FReport: TfrxReport;
  protected
    property Report: TfrxReport read FReport write FReport;
  end;

  TBisComboBoxControl = class(TfrxDialogControl)
  private
    FComboBox: TBisComboBox;
    FOnChange: TfrxNotifyEvent;
    function GetItemIndex: Integer;
    function GetItems: TStrings;
    function GetStyle: TComboBoxStyle;
    function GetText: String;
    procedure DoOnChange(Sender: TObject);
    procedure SetItemIndex(const Value: Integer);
    procedure SetItems(const Value: TStrings);
    procedure SetStyle(const Value: TComboBoxStyle);
    procedure SetText(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property ComboBox: TBisComboBox read FComboBox;
  published
    property Color;
    property Items: TStrings read GetItems write SetItems;
    property Style: TComboBoxStyle read GetStyle write SetStyle default csDropDown;
    property TabStop;
    property Text: String read GetText write SetText;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property OnChange: TfrxNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  TBisEditDate=class(TEditDate)
  private
    FReport: TfrxReport;
  protected
    property Report: TfrxReport read FReport write FReport;
  end;

  TBisEditDateControl = class(TfrxDialogControl)
  private
    FEditDate: TBisEditDate;
    FOnChange: TfrxNotifyEvent;
    function GetDate: Variant;
    procedure DoOnChange(Sender: TObject);
    procedure SetDate(const Value: Variant);
    function GetText: String;
    procedure SetText(Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property EditDate: TBisEditDate read FEditDate;
  published
    property Color;
    property Date: Variant read GetDate write SetDate;
    property Value: Variant read GetDate write SetDate;
    property Text: String read GetText write SetText;
    property TabStop;
    property OnChange: TfrxNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  TBisRadioButton=class(TRadioButton)
  private
    FReport: TfrxReport;
  protected
    property Report: TfrxReport read FReport write FReport;
  end;

  TBisRadioButtonControl = class(TfrxDialogControl)
  private
    FRadioButton: TBisRadioButton;
    function GetAlignment: TAlignment;
    function GetChecked: Boolean;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetChecked(const Value: Boolean);
    function GetWordWrap: Boolean;
    procedure SetWordWrap(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property RadioButton: TBisRadioButton read FRadioButton;
  published
    property Alignment: TAlignment read GetAlignment write SetAlignment
      default taRightJustify;
    property Caption;
    property Checked: Boolean read GetChecked write SetChecked default False;
    property TabStop;
    property WordWrap: Boolean read GetWordWrap write SetWordWrap default False;
    property Color;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TBisEditFloat=class(TEditFloat)
  private
    FReport: TfrxReport;
  protected
    property Report: TfrxReport read FReport write FReport;
  end;

  TBisEditFloatControl = class(TfrxDialogControl)
  private
    FEditFloat: TBisEditFloat;
    FOnChange: TfrxNotifyEvent;
    function GetValue: Variant;
    procedure DoOnChange(Sender: TObject);
    procedure SetValue(const AValue: Variant);
    function GetText: String;
    procedure SetText(Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    property EditFloat: TBisEditFloat read FEditFloat;
  published
    property Color;
    property Value: Variant read GetValue write SetValue;
    property Text: String read GetText write SetText;
    property TabStop;
    property OnChange: TfrxNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  TBisWinControlProperty=class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    function GetValue: String; override;
    procedure GetValues; override;
    procedure SetValue(const Value: String); override;
  end;

implementation

uses StrUtils,
     frxRes, fs_iinterpreter,
     BisUtils, BisConsts;

function GetLabelByReport(WinControl: TControl; FReport: TfrxReport): TLabel;
var
  i: Integer;
  c: TfrxComponent;
  Control: TControl;
begin
  Result:=nil;
  if Assigned(FReport) then begin
    for i:=0 to FReport.AllObjects.Count-1 do begin
      c:=TfrxComponent(FReport.AllObjects.Items[i]);
      if Assigned(c) and (c is TfrxDialogControl) then begin
        Control:=TfrxDialogControl(c).Control;
        if Assigned(Control) and (Control is TLabel) then begin
          if TLabel(Control).FocusControl=WinControl then begin
            Result:=TLabel(Control);
            break;
          end;
        end;
      end;
    end;
  end;
end;

type
  TFunctions=class(TfsRTTIModule)
  public
    constructor Create(AScript: TfsScript); override;
  end;

{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do begin
    AddClass(TBisLabelControl,'TfrxDialogControl');
    AddClass(TBisEditControl,'TfrxDialogControl');
    AddClass(TBisMemoControl,'TfrxDialogControl');
    AddClass(TBisComboBoxControl,'TfrxDialogControl');
    AddClass(TBisEditDateControl,'TfrxDialogControl');
    AddClass(TBisRadioButtonControl,'TfrxDialogControl');
    AddClass(TBisEditFloatControl,'TfrxDialogControl');
  end;
end;

{ TBisLabelControl }

constructor TBisLabelControl.Create(AOwner: TComponent);
begin
  inherited;
  BaseName:=SLabel;
  FLabel := TLabel.Create(nil);
  InitControl(FLabel);
end;

class function TBisLabelControl.GetDescription: String;
begin
  Result := SLabelDecs;
end;

procedure TBisLabelControl.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
begin
  if FLabel.AutoSize then
  begin
    Width := FLabel.Width;
    Height := FLabel.Height;
  end
  else
  begin
    FLabel.Width := Round(Width);
    FLabel.Height := Round(Height);
  end;
  inherited;
end;

function TBisLabelControl.GetAlignment: TAlignment;
begin
  Result := FLabel.Alignment;
end;

function TBisLabelControl.GetAutoSize: Boolean;
begin
  Result := FLabel.AutoSize;
end;

function TBisLabelControl.GetWordWrap: Boolean;
begin
  Result := FLabel.WordWrap;
end;

procedure TBisLabelControl.SetAlignment(const Value: TAlignment);
begin
  FLabel.Alignment := Value;
end;

procedure TBisLabelControl.SetAutoSize(const Value: Boolean);
begin
  FLabel.AutoSize := Value;
end;

procedure TBisLabelControl.SetWordWrap(const Value: Boolean);
begin
  FLabel.WordWrap := Value;
end;

procedure TBisLabelControl.BeforeStartReport;
begin
  if not FLabel.AutoSize then
  begin
    FLabel.Width := Round(Width);
    FLabel.Height := Round(Height);
  end;
end;

procedure TBisLabelControl.SetFocusControl(Value: TfrxDialogControl);
var
  i: Integer;
  c: TfrxComponent;
  Control: TControl;
begin
  if FFocusControl<>Value then
    if Assigned(FLabel) and Assigned(Report) then begin
      for i:=0 to Report.AllObjects.Count-1 do begin
        c:=TfrxComponent(Report.AllObjects.Items[i]);
        if Assigned(c) and (c is TfrxDialogControl) then begin
          if TfrxDialogControl(c)=Value then begin
            Control:=TfrxDialogControl(c).Control;
            if Assigned(Control) and (Control is TWinControl) then begin
              FLabel.FocusControl:=TWinControl(Control);
              FLabel.FocusControl.FreeNotification(Self);
              FFocusControl:=Value;
            end;
            break;
          end;
        end;
      end;
    end;
end;

procedure TBisLabelControl.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if Assigned(FLabel) and (AComponent=FFocusControl) and (Operation=opRemove) then begin
    FFocusControl:=nil;
    FLabel.FocusControl:=nil;
  end;
end;

{ TBisEdit }

{ TBisEditControl }

constructor TBisEditControl.Create(AOwner: TComponent);
begin
  inherited;
  BaseName:=SEdit;
  FEdit := TBisEdit.Create(nil);
  FEdit.Report:=Report;
  FEdit.OnChange := DoOnChange;
  InitControl(FEdit);
  Width := 121;
  Height := 21;
end;

class function TBisEditControl.GetDescription: String;
begin
  Result := SEditDesc;
end;

function TBisEditControl.GetMaxLength: Integer;
begin
  Result := FEdit.MaxLength;
end;

function TBisEditControl.GetPasswordChar: Char;
begin
  Result := FEdit.PasswordChar;
end;

function TBisEditControl.GetReadOnly: Boolean;
begin
  Result := FEdit.ReadOnly;
end;

function TBisEditControl.GetText: String;
begin
  Result := FEdit.Text;
end;

procedure TBisEditControl.SetMaxLength(const Value: Integer);
begin
  FEdit.MaxLength := Value;
end;

procedure TBisEditControl.SetPasswordChar(const Value: Char);
begin
  FEdit.PasswordChar := Value;
end;

procedure TBisEditControl.SetReadOnly(const Value: Boolean);
begin
  FEdit.ReadOnly := Value;
end;

procedure TBisEditControl.SetText(const Value: String);
begin
  FEdit.Text := Value;
end;

procedure TBisEditControl.DoOnChange(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnChange);
end;

{ TBisMemo }

{ TBisMemoControl }

constructor TBisMemoControl.Create(AOwner: TComponent);
begin
  inherited;
  BaseName:=SMemo;
  FMemo := TBisMemo.Create(nil);
  FMemo.Report:=Report;
  FMemo.OnChange := DoOnChange;
  InitControl(FMemo);
  Width := 185;
  Height := 89;
end;

class function TBisMemoControl.GetDescription: String;
begin
  Result := SMemoDesc;
end;

function TBisMemoControl.GetMaxLength: Integer;
begin
  Result := FMemo.MaxLength;
end;

function TBisMemoControl.GetPasswordChar: Char;
begin
  Result := FMemo.PasswordChar;
end;

function TBisMemoControl.GetReadOnly: Boolean;
begin
  Result := FMemo.ReadOnly;
end;

function TBisMemoControl.GetText: String;
begin
  Result := FMemo.Text;
end;

procedure TBisMemoControl.SetMaxLength(const Value: Integer);
begin
  FMemo.MaxLength := Value;
end;

procedure TBisMemoControl.SetPasswordChar(const Value: Char);
begin
  FMemo.PasswordChar := Value;
end;

procedure TBisMemoControl.SetReadOnly(const Value: Boolean);
begin
  FMemo.ReadOnly := Value;
end;

procedure TBisMemoControl.SetText(const Value: String);
begin
  FMemo.Text := Value;
end;

procedure TBisMemoControl.DoOnChange(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnChange);
end;

function TBisMemoControl.GetLines: TStrings;
begin
  Result := FMemo.Lines;
end;

function TBisMemoControl.GetScrollStyle: TScrollStyle;
begin
  Result := FMemo.ScrollBars;
end;

function TBisMemoControl.GetWordWrap: Boolean;
begin
  Result := FMemo.WordWrap;
end;

procedure TBisMemoControl.SetLines(const Value: TStrings);
begin
  FMemo.Lines := Value;
end;

procedure TBisMemoControl.SetScrollStyle(const Value: TScrollStyle);
begin
  FMemo.ScrollBars := Value;
end;

procedure TBisMemoControl.SetWordWrap(const Value: Boolean);
begin
  FMemo.WordWrap := Value;
end;

{ TBisComboBox }

{ TBisComboBoxControl }

constructor TBisComboBoxControl.Create(AOwner: TComponent);
begin
  inherited;
  BaseName:=SComboBox;
  FComboBox := TBisComboBox.Create(nil);
  FComboBox.OnChange := DoOnChange;
  FComboBox.Report:=Report;
  InitControl(FComboBox);

  Width := 145;
  Height := 21;
end;

class function TBisComboBoxControl.GetDescription: String;
begin
  Result := SComboBoxDesc;
end;

function TBisComboBoxControl.GetItems: TStrings;
begin
  Result := FComboBox.Items;
end;

function TBisComboBoxControl.GetItemIndex: Integer;
begin
  Result := FComboBox.ItemIndex;
end;

function TBisComboBoxControl.GetStyle: TComboBoxStyle;
begin
  Result := FComboBox.Style;
end;

function TBisComboBoxControl.GetText: String;
begin
  Result := FComboBox.Text;
end;

procedure TBisComboBoxControl.SetItems(const Value: TStrings);
begin
  FComboBox.Items := Value;
end;

procedure TBisComboBoxControl.SetItemIndex(const Value: Integer);
begin
  FComboBox.ItemIndex := Value;
end;

procedure TBisComboBoxControl.SetStyle(const Value: TComboBoxStyle);
begin
  FComboBox.Style := Value;
end;

procedure TBisComboBoxControl.SetText(const Value: String);
begin
  FComboBox.Text := Value;
end;

procedure TBisComboBoxControl.DoOnChange(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnChange);
end;

{ TBisEditDate }

{ TBisEditDateControl }

constructor TBisEditDateControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BaseName:=SEditDate;
  FEditDate := TBisEditDate.Create(nil);
  FEditDate.OnChange := DoOnChange;
  FEditDate.Report:=Report;
  InitControl(FEditDate);

  Width := 145;
  Height := 21;
end;

class function TBisEditDateControl.GetDescription: String;
begin
  Result:=SEditDateDesc;
end;

function TBisEditDateControl.GetDate: Variant;
var
  S: String;
  V: Variant;
  D: TDate;
const
  NullDate: TDate=0.0;  
begin
  S:=DateToStr(FEditDate.Date);
  V:=StrToDate(S);
  D:=V;
  if D=NullDate then
    Result:=Null
  else
    Result := V;
end;

procedure TBisEditDateControl.SetDate(const Value: Variant);
var
  V: Variant;
  S: String;
begin
  V:=Value;
  if VarType(V)=varString then begin
    S:=VarToStrDef(V,'');
    V:=StrToDateDef(S,FEditDate.Date);
  end;
  FEditDate.Date:= VarToDateDef(V,FEditDate.Date);
end;

function TBisEditDateControl.GetText: String;
begin
  Result:=FEditDate.Text;
end;

procedure TBisEditDateControl.SetText(Value: String);
begin
  FEditDate.Text:=Value;
end;

procedure TBisEditDateControl.DoOnChange(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnChange);
end;

{ TBisRadioButton }

{ TBisRadioButtonControl }

constructor TBisRadioButtonControl.Create(AOwner: TComponent);
begin
  inherited;
  BaseName:=SRadioButton;
  FRadioButton := TBisRadioButton.Create(nil);
  InitControl(FRadioButton);

  Width := 113;
  Height := 17;
  Alignment := taRightJustify;
end;

class function TBisRadioButtonControl.GetDescription: String;
begin
  Result := SRadioButtonDesc;
end;

function TBisRadioButtonControl.GetAlignment: TAlignment;
begin
  Result := FRadioButton.Alignment;
end;

function TBisRadioButtonControl.GetChecked: Boolean;
begin
  Result := FRadioButton.Checked;
end;

procedure TBisRadioButtonControl.SetAlignment(const Value: TAlignment);
begin
  FRadioButton.Alignment := Value;
end;

procedure TBisRadioButtonControl.SetChecked(const Value: Boolean);
begin
  FRadioButton.Checked := Value;
end;

function TBisRadioButtonControl.GetWordWrap: Boolean;
begin
  Result := FRadioButton.WordWrap;
end;

procedure TBisRadioButtonControl.SetWordWrap(const Value: Boolean);
begin
  FRadioButton.WordWrap := Value;
end;

{ TBisEditFloat }

{ TBisEditFloatControl }

constructor TBisEditFloatControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BaseName:=SEditFloat;
  FEditFloat := TBisEditFloat.Create(nil);
  FEditFloat.OnChange := DoOnChange;
  FEditFloat.Report:=Report;
  InitControl(FEditFloat);

  Width := 145;
  Height := 21;
end;

class function TBisEditFloatControl.GetDescription: String;
begin
  Result:=SEditFloatDesc;
end;

function TBisEditFloatControl.GetValue: Variant;
begin
  if Trim(FEditFloat.Text)='' then
    Result:=Null
  else
    Result:=FEditFloat.Value;
end;

procedure TBisEditFloatControl.SetValue(const AValue: Variant);
begin
  if VarIsNull(AValue) then
    FEditFloat.Text:=''
  else
    FEditFloat.Value:=VarToExtendedDef(AValue,0.0);
end;

function TBisEditFloatControl.GetText: String;
begin
  Result:=FEditFloat.Text;
end;

procedure TBisEditFloatControl.SetText(Value: String);
begin
  FEditFloat.Text:=Value;
end;

procedure TBisEditFloatControl.DoOnChange(Sender: TObject);
begin
  if Report <> nil then
    Report.DoNotifyEvent(Self, FOnChange);
end;

{ TBisWinControlProperty }

function TBisWinControlProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result:=[paMultiSelect, paValueList, paSortList];
end;

function TBisWinControlProperty.GetValue: String;
var
  c: TComponent;
begin
  c := TComponent(GetOrdValue);
  if c <> nil then
    Result := c.Name else
    Result := '';
end;

procedure TBisWinControlProperty.GetValues;
var
  i: Integer;
  c: TfrxComponent;
  Control: TControl;
begin
  inherited GetValues;
  if Component is TfrxDialogControl then begin
    if Assigned(frComponent) then begin
      for i:=0 to frComponent.Report.AllObjects.Count-1 do begin
        c:=TfrxComponent(frComponent.Report.AllObjects.Items[i]);
        if Assigned(c) and (c is TfrxDialogControl) then begin
          Control:=TfrxDialogControl(c).Control;
          if Assigned(Control) and (Control is TWinControl) then
            Values.Add(TfrxDialogControl(c).Name);
        end;
      end;
    end;
  end;
end;

procedure TBisWinControlProperty.SetValue(const Value: String);
var
  c: TComponent;
begin
  c := nil;
  if Value <> '' then
  begin
    c := frComponent.Report.FindObject(Value);
    if c = nil then
      raise Exception.Create(frxResources.Get('prInvProp'));
  end;

  SetOrdValue(Integer(c));
end;

initialization
  frxObjects.RegisterObject1(TBisLabelControl, nil, '', '', 0, 12);
  frxObjects.RegisterObject1(TBisEditControl, nil, '', '', 0, 13);
  frxObjects.RegisterObject1(TBisMemoControl, nil, '', '', 0, 14);
  frxObjects.RegisterObject1(TBisRadioButtonControl, nil, '', '', 0, 17);
  frxObjects.RegisterObject1(TBisComboBoxControl, nil, '', '', 0, 19);
  frxObjects.RegisterObject1(TBisEditDateControl, nil, '', '', 0, 20);
  frxObjects.RegisterObject1(TBisEditFloatControl, nil, '', '', 0, 13);
  frxPropertyEditors.Register(TypeInfo(TWinControl),TBisLabelControl,'FocusControl',TBisWinControlProperty);
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then fsRTTIModules.Remove(TFunctions);
//  frxObjects.UnRegister(TBisEditDateControl);


end.
