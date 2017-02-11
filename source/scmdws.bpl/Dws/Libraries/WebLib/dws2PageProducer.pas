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

unit dws2PageProducer;

interface

uses
{$IFDEF LINUX}
  Libc,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SysUtils, Classes, HTTPApp,
  dws2Comp, dws2Exprs, dws2WebBasics, dws2Errors, dws2WebLibModule,
  dws2Debugger, dws2StringResult;

type

  Tdws2PageProducer = class(TCustomContentProducer)
  private
    FDebugger: TComponent;
    FDebuggerIntf: IDebugger;
    FDebugging: Boolean;
    FWebLib: Tdws2WebLib;
    FOnContent: TContentEvent;
    procedure SetWebLib(const Value: Tdws2WebLib);
    procedure SetDebugging(const Value: Boolean);
    procedure SetDebugger(const Value: TComponent);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
    function Content: string; override;
    function ContentFromStream(s: TStream): string; override;
    function ContentFromString(const s: string): string; override;
    function ContentFromFile(FilePath: string): string;
    procedure DumpContentString(ContentString: string);
  published
    property Debugger: TComponent read FDebugger write SetDebugger;
    property Debugging: Boolean read FDebugging write SetDebugging;
    property OnContent: TContentEvent read FOnContent write FOnContent;
    property WebLib: Tdws2WebLib read FWebLib write SetWebLib;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2PageProducer]);
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

{ ******************  Tdws2PageProducer ****************************}

constructor Tdws2PageProducer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor Tdws2PageProducer.destroy;
begin
  inherited;
end;

function Tdws2PageProducer.Content: string;
begin
  Result := ContentFromFile(Dispatcher.Request.PathTranslated)
end;

function Tdws2PageProducer.ContentFromFile(FilePath: string): string;
var
  fs: TFileStream;
begin
  try
    if not Assigned(FWebLib) then
      raise Exception.Create('Property ' + Name + '.WebLib is undefined!');

    fs := TFileStream.Create(FilePath, fmOpenRead + fmShareDenyWrite);

    with FWebLib.HttpInfo do
    try
      ScriptDocFileName := ExtractFileName(FilePath);
      ScriptDocPath := ExtractFilePath(FilePath);
      ScriptDocDate := FileDateToDateTime(FileGetDate(fs.Handle));
      //      ScriptDocSize := fs.Size;

      FWebLib.Script.Config.ScriptPaths.Add(ScriptDocPath);
      Result := ContentFromStream(fs);
      FWebLib.Script.Config.ScriptPaths.Delete(FWebLib.Script.Config.ScriptPaths.Count - 1);
    finally
      fs.Free;
    end;
  except
    on e: Exception do
      result := '<html><body><p>PageProducer-Error: ' + e.Message +
        '</p></body></html>';
  end;
end;

function Tdws2PageProducer.ContentFromStream(s: TStream): string;
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

function Tdws2PageProducer.ContentFromString(const s: string): string;
var
  prog: TProgram;
  //  session: TUserSession;
  DumpStr: string;
begin
  Result := '';
  FWebLib.DumpActContent := false;

  if Assigned(OnContent) then
    OnContent(Self, Dispatcher.Request, Dispatcher.Response);
  try
    if not Assigned(WebLib) then
      raise Exception.Create('Property ' + Name + '.WebLib is undefined!');
    FWebLib.HttpInfo.ScriptDocSize := length(s);

    prog := WebLib.Script.Compile(s);
    try
      if prog.Msgs.HasErrors then
        Result := ShowMsgs(prog)
      else
      begin
        try
          WebLib.InitIsapiSession(Dispatcher.Request, Dispatcher.Response);
        except
          on e: ESecurityException do
          begin
            if (e is ENeedSession) and (WebLib.NeedSessionDWSErrorFile <> '')
              then
              Result := ContentFromFile(WebLib.HttpInfo.ScriptDocPath +
                WebLib.NeedSessionDWSErrorFile)
            else if (e is ENeedLogin) and (WebLib.NeedLoginDWSErrorFile <> '')
              then
              Result := ContentFromFile(WebLib.HttpInfo.ScriptDocPath +
                WebLib.NeedLoginDWSErrorFile)
            else if (e is ENeedMemberLogin) and
              (WebLib.NeedMemberLoginDWSErrorFile <> '') then
              Result := ContentFromFile(WebLib.HttpInfo.ScriptDocPath +
                WebLib.NeedMemberLoginDWSErrorFile)
            else
              Result := e.Message;
            exit;
          end
        else
          self.Owner.Tag := 1;
        end;
        if Debugging then
          prog.Debugger := FDebuggerIntf;
        //      prog.UserDef := THttpInfo.Create;

        try
          prog.Execute;
          //          session := THttpInfo(prog.UserDef).Session;
        finally
          //          prog.UserDef.Free;
        end;
        if prog.Msgs.Count = 0 then
        begin
          if FWebLib.DumpActContent then
          begin
            DumpStr := WebLib.ActivateDumpScript(Tdws2StringResult(prog.Result).Str);
            DumpContentString(DumpStr);
            Result := ContentFromString(DumpStr);
            // or http status '201' (created)
          end
          else
            Result := Tdws2StringResult(prog.Result).Str; // send content
        end
        else
          Result := ShowMsgs(prog);
      end;

    finally
      WebLib.CloseIsapiSession;
      with WebLib.HttpInfo do
      begin
        ScriptDocFileName := '';
        ScriptDocPath := '';
        ScriptDocDate := 0;
        ScriptDocSize := 0;
      end;

      prog.Free;
    end;
  except
    on e: EForward do
      Result := ContentFromFile(WebLib.HttpInfo.ScriptDocPath + e.Message);
  end;
end;

procedure Tdws2PageProducer.DumpContentString(ContentString: string);
var
  slCont: TStringlist;
begin
  slCont := TStringlist.create;
  slCont.Text := ContentString;
  slCont.SaveToFile(WebLib.HttpInfo.ScriptDocPath + WebLib.DumpFileName);
  slCont.free;
end;

procedure Tdws2PageProducer.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FWebLib) then
    SetWebLib(nil);
  if (Operation = opRemove) and (AComponent = FDebugger) then
    SetDebugger(nil);
  inherited;
end;

procedure Tdws2PageProducer.SetWebLib(const Value: Tdws2WebLib);
begin
  //  if Assigned(FWebLib) then
  //    FWebLib.RemoveFreeNotification(Self);
  FWebLib := Value;
  if Assigned(FWebLib) then
    FWebLib.FreeNotification(Self);
end;

procedure Tdws2PageProducer.SetDebugging(const Value: Boolean);
begin
  FDebugging := Value;
end;

procedure Tdws2PageProducer.SetDebugger(const Value: TComponent);
begin
  if Assigned(Value) and not Supports(Value, IDebugger, FDebuggerIntf) then
    raise
      Exception.CreateFmt('Component "%s" doesn''t support the IDebugger interface', [Value.Name]);
  if Assigned(FDebugger) then
    FDebugger.RemoveFreeNotification(Self);
  FDebugger := Value;
  if Assigned(FDebugger) then
    FDebugger.FreeNotification(Self);
end;

end.

