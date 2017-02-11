unit BisScriptUtils;

interface

uses BisScriptType;


function ScriptTypeAsInteger(Value: Variant): Integer;
function ScriptTypeAsFloat(Value: Variant): Extended;
function ScriptTypeAsString(Value: Variant): String;
function ScriptTypeAsDateTime(Value: Variant): TDateTime;
function ScriptTypeAsBoolean(Value: Variant): Boolean;
function ScriptTypeAsObject(Value: Variant): TObject;

function IntegerAsScriptType(Value: Integer): Variant;
function FloatAsScriptType(Value: Extended): Variant;
function StringAsScriptType(Value: String): Variant;
function DateTimeAsScriptType(Value: TDateTime): Variant;
function BooleanAsScriptType(Value: Boolean): Variant;
function ObjectAsScriptType(Value: TObject): Variant;

implementation

uses Variants, SysUtils,
     BisUtils;

function ScriptTypeAsInteger(Value: Variant): Integer;
begin
  Result:=VarToIntDef(Value,0);
end;

function ScriptTypeAsFloat(Value: Variant): Extended;
begin
  Result:=VarToExtendedDef(Value,0.0);
end;

function ScriptTypeAsString(Value: Variant): String;
begin
  Result:=VarToStrDef(Value,'');
end;

function ScriptTypeAsDateTime(Value: Variant): TDateTime;
begin
  Result:=VarToDateTimeDef(Value,0.0);
end;

function ScriptTypeAsBoolean(Value: Variant): Boolean;
begin
  Result:=Boolean(VarToIntDef(Value,0));
end;

function ScriptTypeAsObject(Value: Variant): TObject;
begin
  Result:=TObject(VarToIntDef(Value,0));
end;

function IntegerAsScriptType(Value: Integer): Variant;
begin
  Result:=VarAsType(Value,varInteger);
end;

function FloatAsScriptType(Value: Extended): Variant;
begin
  Result:=VarAsType(Value,varDouble);
end;

function StringAsScriptType(Value: String): Variant;
begin
  Result:=VarAsType(Value,varString);
end;

function DateTimeAsScriptType(Value: TDateTime): Variant;
begin
  Result:=VarAsType(Value,varDate);
end;

function BooleanAsScriptType(Value: Boolean): Variant;
begin
  Result:=VarAsType(Value,varBoolean);
end;

function ObjectAsScriptType(Value: TObject): Variant;
begin
  Result:=Integer(Value);
end;

end.
