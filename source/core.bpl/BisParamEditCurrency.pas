unit BisParamEditCurrency;

interface

uses Classes, Controls, StdCtrls, DB,
     BisParam, BisParamEdit, BisControls;

type

  TBisParamEditCurrency=class(TBisParamEdit)
 private
    FEditCurrency: TEditCurrency;
    property Edit;
  protected
    function GetValue: Variant; override;
    procedure SetAlignment(const Value: TAlignment); override;
    function GetAlignment: TAlignment; override;
    function GetSize: Integer; override;
    procedure SetSize(const Value: Integer); override;
    function GetPrecision: Integer; override;
    procedure SetPrecision(const Value: Integer); override;
  public
    constructor Create; override;
    procedure LinkControls(Parent: TWinControl); override;

    property EditCurrency: TEditCurrency read FEditCurrency;
  end;


implementation

uses SysUtils,
     BisUtils;

{ TBisParamEditCurrency }

constructor TBisParamEditCurrency.Create; 
begin
  inherited Create;
  DataType:=ftFloat;
end;

procedure TBisParamEditCurrency.LinkControls(Parent: TWinControl);
var
  AEdit: TEdit; 
begin
  inherited LinkControls(Parent);
  if Assigned(Edit) then begin
    AEdit:=Edit;
    FEditCurrency:=ReplaceEditToEditCurrency(AEdit);
    FEditCurrency.Alignment:=taRightJustify;
    Edit:=TEdit(FEditCurrency);
    if Assigned(LabelEdit) then
      LabelEdit.FocusControls.Add(FEditCurrency);
  end;
end;

function TBisParamEditCurrency.GetValue: Variant;
begin
  Result:=inherited GetValue;
  if Assigned(FEditCurrency) then
    Result:=iff(not Empty,FEditCurrency.Value,Result);
end;

function TBisParamEditCurrency.GetAlignment: TAlignment;
begin
  Result:=inherited GetAlignment;
  if Assigned(FEditCurrency) then
    Result:=FEditCurrency.Alignment;
end;

procedure TBisParamEditCurrency.SetAlignment(const Value: TAlignment);
begin
  if Alignment<>Value then begin
    if Assigned(FEditCurrency) then begin
      FEditCurrency.Alignment:=Value;
    end;
    inherited SetAlignment(Value);
  end;
end;

function TBisParamEditCurrency.GetPrecision: Integer;
begin
  Result:=inherited GetPrecision;
  if Assigned(FEditCurrency) then
    Result:=FEditCurrency.MaxLength;
end;

procedure TBisParamEditCurrency.SetPrecision(const Value: Integer);
begin
  if Precision<>Value then
    if Assigned(FEditCurrency) then
      FEditCurrency.MaxLength:=Value
    else
      inherited SetPrecision(Value);
end;

function TBisParamEditCurrency.GetSize: Integer;
begin
  Result:=inherited GetSize;
  if Assigned(FEditCurrency) then
    Result:=FEditCurrency.DecimalPlaces;
end;

procedure TBisParamEditCurrency.SetSize(const Value: Integer);
begin
  if Size<>Value then
    if Assigned(FEditCurrency) then
      FEditCurrency.DecimalPlaces:=Value
    else
      inherited SetSize(Value);
end;

end.
