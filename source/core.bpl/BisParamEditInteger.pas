unit BisParamEditInteger;

interface

uses Classes, Controls, StdCtrls, DB,
     BisParam, BisParamEdit, BisControls;

type

  TBisParamEditInteger=class(TBisParamEdit)
 private
    FEditInteger: TEditInteger;
    property Edit;
  protected
    function GetValue: Variant; override;
    procedure SetAlignment(const Value: TAlignment); override;
    function GetAlignment: TAlignment; override;
  public
    constructor Create; override;
    procedure LinkControls(Parent: TWinControl); override;

    property EditInteger: TEditInteger read FEditInteger;
  end;


implementation

uses SysUtils,
     BisUtils;

{ TBisParamEditInteger }

constructor TBisParamEditInteger.Create; 
begin
  inherited Create;
  DataType:=ftInteger;
end;

procedure TBisParamEditInteger.LinkControls(Parent: TWinControl);
var
  AEdit: TEdit; 
begin
  inherited LinkControls(Parent);
  if Assigned(Edit) then begin
    AEdit:=Edit;
    FEditInteger:=ReplaceEditToEditInteger(AEdit);
    FEditInteger.Alignment:=taRightJustify;
    Edit:=TEdit(FEditInteger);
    if Assigned(LabelEdit) then
      LabelEdit.FocusControls.Add(FEditInteger);
  end;
end;

function TBisParamEditInteger.GetValue: Variant;
begin
  Result:=inherited GetValue;
  if Assigned(FEditInteger) then
    Result:=iff(not Empty,FEditInteger.Value,Result);
end;

function TBisParamEditInteger.GetAlignment: TAlignment;
begin
  Result:=inherited GetAlignment;
  if Assigned(FEditInteger) then
    Result:=FEditInteger.Alignment;
end;

procedure TBisParamEditInteger.SetAlignment(const Value: TAlignment);
begin
  if Alignment<>Value then begin
    if Assigned(FEditInteger) then begin
      FEditInteger.Alignment:=Value;
    end;
    inherited SetAlignment(Value);
  end;
end;



end.