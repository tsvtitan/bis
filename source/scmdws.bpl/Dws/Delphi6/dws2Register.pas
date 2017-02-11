{**********************************************************************}
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at                                          }
{                                                                      }
{    http://www.mozilla.org/MPL/                                       }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{    The Original Code is DelphiWebScriptII source code, released      }
{    January 1, 2001                                                   }
{                                                                      }
{    The Initial Developer of the Original Code is Matthias            }
{    Ackermann. Portions created by Matthias Ackermann are             }
{    Copyright (C) 2000 Matthias Ackermann, Switzerland. All           }
{    Rights Reserved.                                                  }
{                                                                      }
{    Contributor(s): Willibald Krenn                                   }
{                                                                      }
{**********************************************************************}

{$I ..\source\dws2.inc}

// Design-Time only, do NOT include this unit in runtime packages.
//
unit dws2Register;

interface

procedure Register;

implementation

uses
  Classes, Controls, QControls, dws2Comp,
  dws2HtmlFilter, dws2ComConnector, dws2Debugger,
  dws2FileFunctions, dws2CLXGUIFunctions,
  dws2VCLGUIFunctions, dws2GlobalVarsFunctions,
  dws2StringResult;

procedure Register;
begin
  GroupDescendentsWith(dws2VCLGUIFunctions.Tdws2GUIFunctions,
    Controls.TControl);
  GroupDescendentsWith(Tdws2ComConnector,
    Controls.TControl);
  GroupDescendentsWith(dws2CLXGUIFunctions.Tdws2GUIFunctions,
    QControls.TControl);

  RegisterClass(dws2VCLGUIFunctions.Tdws2GUIFunctions);
  RegisterClass(Tdws2ComConnector);
  RegisterClass(dws2CLXGUIFunctions.Tdws2GUIFunctions);

  RegisterComponents('DWS2', [TDelphiWebScriptII,
    Tdws2ComConnector, Tdws2HtmlFilter,  Tdws2SimpleDebugger,
      Tdws2FileFunctions,
      dws2VCLGUIFunctions.Tdws2GUIFunctions,
      dws2CLXGUIFunctions.Tdws2GUIFunctions,
      Tdws2GlobalVarsFunctions, Tdws2StringResultType, Tdws2Unit, Tdws2HTMLUnit, 
      Tdws2StringsUnit]);
end;

end.

