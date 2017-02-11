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
{    Contributor(s): Willibald Krenn, Eric Grange.                     }
{                                                                      }
{**********************************************************************}

unit dws2Module;

interface

uses
  Windows, Messages, SysUtils, Classes, HTTPApp, Forms,
  dws2Comp, dws2Exprs,
  dws2PageProducer, dws2WebLibModule,
  dws2FileFunctions, dws2VCLGUIFunctions, dws2SessionLibModule,
  dws2Debugger, dws2Compiler, dws2HtmlFilter, dws2ClassesLibModule,
  dws2DbLibModule;

type
  Tdws2WebModule = class(TWebModule)
    dws2PageProducer: Tdws2PageProducer;
    Script: TDelphiWebScriptII;
    dws2WebLib: Tdws2WebLib;
    dws2FileFunctions: Tdws2FileFunctions;
    dws2SessionLib: Tdws2SessionLib;
    dws2Unit: Tdws2Unit;
    dws2ClassesLib: Tdws2ClassesLib;
    dws2HtmlFilter1: Tdws2HtmlFilter;
    dws2HtmlUnit1: Tdws2HtmlUnit;
    dws2SimpleDebugger1: Tdws2SimpleDebugger;
    dws2DbLib: Tdws2DbLib;
    procedure WebModuleCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  dws2WebModule: Tdws2WebModule;

implementation

{$R *.DFM}

procedure Tdws2WebModule.WebModuleCreate(Sender: TObject);
begin
  //dws2PageProducer.SessionManager := dws2SessionLib;
end;

end.
