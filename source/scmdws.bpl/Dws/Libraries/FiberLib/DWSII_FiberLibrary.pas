// **********************************************
// * Copyright Joen Joensen. 2001-2004          *
// *                                            *
// * Unit for use with DWSII (www.dwscript.com) *
// * Extension to DWS2Unit.                     *
// *                                            *
// * released under MPL licence                 *
// **********************************************
unit DWSII_FiberLibrary;

interface

uses
  FiberLibrary, Classes, dws2Comp, DWS2Exprs, DWS2Symbols, Windows;

type
  TDWSII_FiberLibraryExtension = class(TComponent)
  private
    FDWS2Unit: TDWS2Unit;
    procedure RegisterToDWS2UNIT;
  protected
    procedure SetDWS2Unit(ADWS2Unit: TDWS2Unit);
    //  FUNCTION GetFiberData(Info: TProgramInfo; name : String):String;
    procedure GetFiberDataFuncExecute(Info: TProgramInfo);
    //  PROCEDURE SetFiberData(Info: TProgramInfo; name, value : String);
    procedure SetFiberDataFuncExecute(Info: TProgramInfo);
    //  PROCEDURE NextFiber(Info: TProgramInfo);
    procedure NextFiberFuncExecute(Info: TProgramInfo);
    //  PROCEDURE FiberMessage(MessageText : String);
    procedure FiberMessageFuncExecute(Info: TProgramInfo);
  public
  published
    property DWS2Unit: TDWS2Unit read FDWS2Unit write SetDWS2Unit;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('DWS2', [TDWSII_FiberLibraryExtension]);
end;

procedure TDWSII_FiberLibraryExtension.SetDWS2Unit(ADWS2Unit: TDWS2Unit);

begin
  FDWS2Unit := ADWS2Unit;
  if Assigned(FDWS2Unit) then
    if not (csdesigning in componentstate) then
      RegisterToDWS2Unit;
end;

//+ Unit FiberLibrary.pas

procedure TDWSII_FiberLibraryExtension.GetFiberDataFuncExecute(Info: TProgramInfo);
var
  resString: string;
begin
  ResString := GetFiberData(Info, Info['name']);
  Info['Result'] := ResString;
end;

procedure TDWSII_FiberLibraryExtension.SetFiberDataFuncExecute(Info: TProgramInfo);
begin
  SetFiberData(Info, Info['name'], Info['value']);
end;

procedure TDWSII_FiberLibraryExtension.NextFiberFuncExecute(Info: TProgramInfo);
begin
  NextFiber(Info);
end;

procedure TDWSII_FiberLibraryExtension.FiberMessageFuncExecute(Info: TProgramInfo);
begin
  FiberMessage(Info['MessageText']);
end;

//- Unit FiberLibrary.pas

procedure TDWSII_FiberLibraryExtension.RegisterToDWS2UNIT;
var
  NewFunction: Tdws2function;
  NewParameter: Tdws2parameter;
begin
  //+ Unit FiberLibrary.pas
  NewFunction := Tdws2function.Create(dws2unit.Functions);
  NewFunction.Name := 'GetFiberData';
  NewFunction.ResultType := 'String';
  NewFunction.OnEval := GetFiberDataFuncExecute;
  NewParameter := Tdws2parameter.Create(NewFunction.Parameters);
  NewParameter.IsVarParam := false;
  NewParameter.DataType := 'String';
  NewParameter.Name := 'name';
  NewFunction := Tdws2function.Create(dws2unit.Functions);
  NewFunction.Name := 'SetFiberData';
  NewFunction.ResultType := '';
  NewFunction.OnEval := SetFiberDataFuncExecute;
  NewParameter := Tdws2parameter.Create(NewFunction.Parameters);
  NewParameter.IsVarParam := false;
  NewParameter.DataType := 'String';
  NewParameter.Name := 'name';
  NewParameter := Tdws2parameter.Create(NewFunction.Parameters);
  NewParameter.IsVarParam := false;
  NewParameter.DataType := 'String';
  NewParameter.Name := 'value';
  NewFunction := Tdws2function.Create(dws2unit.Functions);
  NewFunction.Name := 'NextFiber';
  NewFunction.ResultType := '';
  NewFunction.OnEval := NextFiberFuncExecute;
  NewFunction := Tdws2function.Create(dws2unit.Functions);
  NewFunction.Name := 'FiberMessage';
  NewFunction.ResultType := '';
  NewFunction.OnEval := FiberMessageFuncExecute;
  NewParameter := Tdws2parameter.Create(NewFunction.Parameters);
  NewParameter.IsVarParam := false;
  NewParameter.DataType := 'String';
  NewParameter.Name := 'MessageText';
  //- Unit FiberLibrary.pas
end;

end.

