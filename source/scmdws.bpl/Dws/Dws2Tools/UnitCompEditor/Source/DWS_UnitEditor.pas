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
{    January 28, 2003                                                  }
{                                                                      }
{    The Initial Developer of the Original Code is Mark Ericksen.      }
{    Portions created by Mark Ericksen Copyright (C) 2002, 2003        }
{    Mark Ericksen, United States of America.                          }
{    Rights Reserved.                                                  }
{                                                                      }
{    Contributor(s):                                                   }
{                                                                      }
{**********************************************************************}

{$I dws2.inc}

unit DWS_UnitEditor;

interface

uses
  SysUtils, Classes,
{$IFDEF DELPHI6up}
  DesignIntf, DesignEditors,
{$ELSE}
  DsgnIntf, EditIntf,
{$ENDIF}
  dws2Comp;

type
  TdwsUnitEditor = class(TComponentEditor)
  protected
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure Register;

implementation

uses
{$IFDEF USES_SYNEDIT}  // directive declared in Package Project Options
  dwsUnitEditorSynEditForm;
{$ENDIF}
{$IFDEF USES_RICHEDIT} // directive declared in Package Project Options
  dwsUnitEditorRichEditForm;
{$ENDIF}

procedure Register;
begin
  RegisterComponentEditor(Tdws2Unit, TdwsUnitEditor);
end;

{ TdwsUnitEditor }

procedure TdwsUnitEditor.ExecuteVerb(Index: Integer);
begin
  inherited;
{$IFDEF USES_SYNEDIT}
  if TfmDwsUnitEditorSynEdit.EditUnitAsScript(Tdws2Unit(Component)) then
    Designer.Modified;  // signal that the component was changed
{$ENDIF}
{$IFDEF USES_RICHEDIT}
  if TfmDwsUnitEditorRichEdit.EditUnitAsScript(Tdws2Unit(Component)) then
    Designer.Modified;  // signal that the component was changed
{$ENDIF}
end;

function TdwsUnitEditor.GetVerb(Index: Integer): string;
begin
  case Index of
  0 : Result := '&Edit DWS unit...';
  end;
end;

function TdwsUnitEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

end.
