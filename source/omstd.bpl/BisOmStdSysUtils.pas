unit BisOmStdSysUtils;

interface

uses Classes, SysUtils,
     BisScriptUnits, BisScriptType, BisScriptTypes, BisScriptFuncs;

type
  TBisSysUtilsScriptUnit=class(TBisScriptUnit)
  private
    function FuncIntToStr(Func: TBisScriptFunc): Variant;
    function FuncFloatToStr(Func: TBisScriptFunc): Variant;
    function FuncNow(Func: TBisScriptFunc): Variant;
    function FuncFormatDateTime(Func: TBisScriptFunc): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
     BisUtils, BisScriptParams;

{ TBisSysUtilsScriptUnit }

constructor TBisSysUtilsScriptUnit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UnitName:='SysUtils';

  Depends.Add('System');

  with Funcs.AddFunction('IntToStr',FuncIntToStr,'String') do begin
    Params.Add('Value','Integer');
  end;

  with Funcs.AddFunction('FloatToStr',FuncFloatToStr,'String') do begin
    Params.Add('Value','Extended');
  end;

  with Funcs.AddFunction('Now',FuncNow,'TDateTime') do begin
  end;

  with Funcs.AddFunction('FormatDateTime',FuncFormatDateTime,'String') do begin
    Params.Add('Format','String',spkConst);
    Params.Add('DateTime','TDateTime');
  end;

end;

function TBisSysUtilsScriptUnit.FuncIntToStr(Func: TBisScriptFunc): Variant;
begin
  Result:=IntToStr(Func.Params[0].AsInteger);
end;

function TBisSysUtilsScriptUnit.FuncFloatToStr(Func: TBisScriptFunc): Variant;
begin
  Result:=FloatToStr(Func.Params[0].AsFloat);
end;

function TBisSysUtilsScriptUnit.FuncNow(Func: TBisScriptFunc): Variant;
begin
  Result:=Now;
end;

function TBisSysUtilsScriptUnit.FuncFormatDateTime(Func: TBisScriptFunc): Variant;
begin
  Result:=FormatDateTime(Func.Params[0].AsString,Func.Params[1].AsDateTime);
end;

end.
