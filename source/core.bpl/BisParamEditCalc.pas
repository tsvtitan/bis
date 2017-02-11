unit BisParamEditCalc;

interface

uses Classes, Controls, StdCtrls, DB,
     BisParam, BisParamEdit, BisControls;

type

  TBisParamEditCalc=class(TBisParamEdit)
 private
    FEditCalc: TEditCalc;
    property Edit;
  protected
    function GetValue: Variant; override;
    procedure SetValue(const AValue: Variant); override;
     function GetEmpty: Boolean; override;
    procedure SetAlignment(const Value: TAlignment); override;
    function GetAlignment: TAlignment; override;
    function GetSize: Integer; override;
    procedure SetSize(const Value: Integer); override;
    function GetPrecision: Integer; override;
    procedure SetPrecision(const Value: Integer); override;
  public
    constructor Create; override;
    procedure LinkControls(Parent: TWinControl); override;

    property EditCalc: TEditCalc read FEditCalc;
  end;


implementation

uses SysUtils, Variants,
     BisUtils;

{ TBisParamEditCalc }

constructor TBisParamEditCalc.Create; 
begin
  inherited Create;
  DataType:=ftFloat;
end;

procedure TBisParamEditCalc.LinkControls(Parent: TWinControl);
var
  AEdit: TEdit;
begin
  inherited LinkControls(Parent);
  if Assigned(Edit) then begin
    AEdit:=Edit;
    FEditCalc:=ReplaceEditToEditCalc(AEdit);
    FEditCalc.Alignment:=taRightJustify;
    Edit:=TEdit(FEditCalc);
    if Assigned(LabelEdit) then
      LabelEdit.FocusControls.Add(FEditCalc);
  end;
end;

function TBisParamEditCalc.GetValue: Variant;
begin
  Result:=inherited GetValue;
  if Assigned(FEditCalc) then
    Result:=iff(not Empty,FEditCalc.Value,Result);
end;

procedure TBisParamEditCalc.SetValue(const AValue: Variant);
begin
  if not VarSameValue(Value,AValue) then begin
    if Assigned(FEditCalc) then begin
      FEditCalc.OnChange:=nil;
      try
        FEditCalc.Value:=AValue;
      finally
        FEditCalc.OnChange:=EditChange;
      end;
    end;
    inherited SetValue(AValue);
  end;
end;

function TBisParamEditCalc.GetAlignment: TAlignment;
begin
  Result:=inherited GetAlignment;
  if Assigned(FEditCalc) then
    Result:=FEditCalc.Alignment;
end;

function TBisParamEditCalc.GetEmpty: Boolean;
begin
  if Assigned(FEditCalc) then
    Result:=VarIsNull(FEditCalc.Value)
  else
    Result:=inherited GetEmpty;
end;

procedure TBisParamEditCalc.SetAlignment(const Value: TAlignment);
begin
  if Alignment<>Value then begin
    if Assigned(FEditCalc) then begin
      FEditCalc.Alignment:=Value;
    end;
    inherited SetAlignment(Value);
  end;
end;

function TBisParamEditCalc.GetPrecision: Integer;
begin
  Result:=inherited GetPrecision;
  if Assigned(FEditCalc) then
    Result:=FEditCalc.MaxLength;
end;

procedure TBisParamEditCalc.SetPrecision(const Value: Integer);
begin
  if Precision<>Value then
    if Assigned(FEditCalc) then
      FEditCalc.MaxLength:=Value
    else
      inherited SetPrecision(Value);
end;

function TBisParamEditCalc.GetSize: Integer;
begin
  Result:=inherited GetSize;
  if Assigned(FEditCalc) then
    Result:=FEditCalc.DecimalPlaces;
end;

procedure TBisParamEditCalc.SetSize(const Value: Integer);
begin
  if Size<>Value then
    if Assigned(FEditCalc) then
      FEditCalc.DecimalPlaces:=Value
    else
      inherited SetSize(Value);
end;

end.
