{**********************************************************************}
{                                                                      }
{    dws2MFLib                                                         }
{                                                                      }
{    A function library for DWSII                                      }
{    Version 1.0 Beta                                                  }
{    July 2001                                                         }
{                                                                      }
{    This software is distributed on an "AS IS" basis,                 }
{    WITHOUT WARRANTY OF ANY KIND, either express or implied.          }
{                                                                      }
{    The Initial Developer of the Original Code is Manfred Fuchs       }
{    Portions created by Manfred Fuchs are Copyright                   }
{    (C) 2001 Manfred Fuchs, Germany. All Rights Reserved.             }
{                                                                      }
{**********************************************************************}

unit dws2MFLibUtils;

interface

uses
  dws2Comp, dws2Exprs, dws2Symbols;

procedure AddIntConst(dws2Unit: Tdws2Unit; Name: string; Value: Integer);
procedure AddStringConst(dws2Unit: Tdws2Unit; Name: string; Value: string);

implementation

procedure AddIntConst(dws2Unit: Tdws2Unit; Name: string; Value: Integer);
var
  cnst: Tdws2Constant;
begin
  cnst := Tdws2Constant(dws2Unit.Constants.Add);
  cnst.DataType := 'Integer';
  cnst.Name := Name;
  cnst.Value := Value;
end;

procedure AddStringConst(dws2Unit: Tdws2Unit; Name: string; Value: string);
var
  cnst: Tdws2Constant;
begin
  cnst := Tdws2Constant(dws2Unit.Constants.Add);
  cnst.DataType := 'String';
  cnst.Name := Name;
  cnst.Value := Value;
end;

end.
