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
{    http://www.dwscript.com                                           }
{                                                                      }
{    The Initial Developers of the Original Code are Matthias          }
{    Ackermann and hannes hernler.                                     }
{    Portions created by Matthias Ackermann are Copyright (C) 2001     }
{    Matthias Ackermann, Switzerland. All Rights Reserved.             }
{    Portions created by hannes hernler are Copyright (C) 2001         }
{    hannes hernler, Austria. All Rights Reserved.                     }
{                                                                      }
{    Contributor(s): ______________________________________.           }
{                                                                      }
{**********************************************************************}

unit dws2PageloaderModule;

interface

uses
{$IFDEF LINUX}
  Libc,
{$ELSE}
  Windows, Forms,
{$ENDIF}
  SysUtils, Classes, HTTPApp,
  dws2Comp, dws2Exprs, dws2WebBasics, dws2Errors, dws2WebLibModule,
  dws2Debugger, dws2StringResult;

type
  Tdws2Pageloader = class(TDataModule)
    customPageLoaderUnit: Tdws2Unit;
  private
    FScript: TDelphiWebScriptII;
    FDebugger: TComponent;
    FDebuggerIntf: IDebugger;
    FDebugging: Boolean;
    FOnContent: TContentEvent;
    FScriptDocDate: TDateTime;
    FScriptDocSize: Integer;
    FScriptDocFileName: string;
    FScriptDocPath: string;
    procedure SetDebugging(const Value: Boolean);
    procedure SetDebugger(const Value: TComponent);
    procedure SetScript(const Value: TDelphiWebScriptII);
    procedure SetDocFileName(const Value: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
    function Content: string;
    function ContentFromStream(s: TStream): string;
    function ContentFromString(const s: string): string;
    function ContentFromFile(FilePath: string): string;
    function ContentStringList: TStringlist;
    procedure DumpContentString(ContentString: string);
    property ScriptDocDate: TDateTime read FScriptDocDate;
    property ScriptDocSize: Integer read FScriptDocSize;
    property ScriptDocPath: string read FScriptDocPath;
  published
    property Script: TDelphiWebScriptII read FScript write SetScript;
    property Debugger: TComponent read FDebugger write SetDebugger;
    property Debugging: Boolean read FDebugging write SetDebugging;
    property OnContent: TContentEvent read FOnContent write FOnContent;
    property ScriptDocFileName: string read FScriptDocFileName write SetDocFileName;
  end;

procedure Register;

implementation
{$R *.dfm}

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2PageLoader]);
end;

function ShowMsgs(Prg: TProgram): string;
var
  x: Integer;
begin
  Result := '<html><body>';
  for x := 0 to Prg.Msgs.Count - 1 do
  begin
    try
      if Prg.Msgs[x] is TScriptMsg then
        Result := Result + '<p>' + Prg.Msgs[x].AsInfo + '<br>' +
          Prg.Msgs.GetErrorLine(TScriptMsg(Prg.Msgs[x]).Pos) + '</p>'
      else
        Result := Result + '<p>' + Prg.Msgs[x].AsInfo + '</p>';
    except
      on e: Exception do
        Result := '<p>' + IntToStr(x) + '</p>';
    end;
  end;
  Result := Result + '</body></html>';
end;


{ ******************  Tdws2PageLoader ****************************}

constructor Tdws2PageLoader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor Tdws2PageLoader.destroy;
begin
  inherited;
end;

procedure Tdws2PageLoader.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FScript) then
    SetScript(nil);
  if (Operation = opRemove) and (AComponent = FDebugger) then
    SetDebugger(nil);
  inherited;
end;

procedure Tdws2PageLoader.SetScript(const Value: TDelphiWebScriptII);
var
  x: Integer;
begin
  if Assigned(FScript) then
    FScript.RemoveFreeNotification(Self);
  FScript := Value;
  if Assigned(FScript) then
    FScript.FreeNotification(Self);
  if not (csDesigning in ComponentState) then
    for x := 0 to ComponentCount - 1 do
      if Components[x] is Tdws2Unit then
        Tdws2Unit(Components[x]).Script := Value;
end;

procedure Tdws2PageLoader.SetDocFileName(const Value: string);
begin
  FScriptDocFileName := Value;
  FScriptDocPath := ExtractFilePath(FScriptDocFileName);
end;

function Tdws2PageLoader.Content: string;
begin
  Result := ContentFromFile(FScriptDocFileName);
end;

function Tdws2PageLoader.ContentFromFile(FilePath: string): string;
var
  fs: TFileStream;
begin
  try
    fs := TFileStream.Create(FilePath, fmOpenRead + fmShareDenyWrite);

    try
      FScriptDocFileName := ExtractFileName(FilePath);
      FScriptDocPath := ExtractFilePath(FilePath);
      FScriptDocDate := FileDateToDateTime(FileGetDate(fs.Handle));
//      ScriptDocSize := fs.Size;

      Script.Config.ScriptPaths.Add(ScriptDocPath);
      Result := ContentFromStream(fs);
      Script.Config.ScriptPaths.Delete(Script.Config.ScriptPaths.Count - 1);
    finally
      fs.Free;
    end;
  except
    on e: Exception do
      result := '<html><body><p>PageProducer-Error: ' + e.Message + '</p></body></html>';
  end;
end;

function Tdws2PageLoader.ContentFromStream(s: TStream): string;
var
  ss: TStringStream;
begin
  ss := TStringStream.Create('');
  try
    ss.CopyFrom(s, s.Size);
    ss.Position := 0;
    Result := ContentFromString(ss.DataString);
  finally
    ss.Free;
  end;
end;

function Tdws2PageLoader.ContentStringList: TStringlist;
var
  slCont: TStringlist;
begin
  slCont := TStringlist.create;
  slCont.Text := Content;
  result := slCont;
end;

function Tdws2PageLoader.ContentFromString(const s: string): string;
var
  prog: TProgram;
//  DumpStr : string;
begin
  Result := '';
  try
    prog := Script.Compile(s);
    try
      if prog.Msgs.HasErrors then
        Result := ShowMsgs(prog)
      else begin
        if Debugging then
          prog.Debugger := FDebuggerIntf;

        prog.Execute;
        if prog.Msgs.Count = 0 then
        begin
          Result := Tdws2StringResult(prog.Result).Str; // send content
        end
        else
          Result := ShowMsgs(prog);
      end;

    finally
      FScriptDocFileName := '';
      FScriptDocPath := '';
      FScriptDocDate := 0;
      FScriptDocSize := 0;
      prog.Free;
    end;
  except
    on e: EForward do
  //    Result := ContentFromFile(WebLib.HttpInfo.ScriptDocPath + e.Message);
  end;
end;

procedure Tdws2PageLoader.DumpContentString(ContentString: string);
var
  slCont: TStringlist;
begin
  slCont := TStringlist.create;
  slCont.Text := ContentString;
//  slCont.SaveToFile(WebLib.HttpInfo.ScriptDocPath + WebLib.DumpFileName);
  slCont.free;
end;

procedure Tdws2PageLoader.SetDebugging(const Value: Boolean);
begin
  FDebugging := Value;
end;

procedure Tdws2PageLoader.SetDebugger(const Value: TComponent);
begin
  if Assigned(Value) and not Supports(Value, IDebugger, FDebuggerIntf) then
    raise Exception.CreateFmt('Component "%s" doesn''t support the IDebugger interface', [Value.Name]);
  if Assigned(FDebugger) then
    FDebugger.RemoveFreeNotification(Self);
  FDebugger := Value;
  if Assigned(FDebugger) then
    FDebugger.FreeNotification(Self);
end;


end.

