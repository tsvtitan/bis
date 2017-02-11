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

unit dws2SessionGlobals;

interface

uses
  Classes, Sysutils, contnrs, dws2WebBasics, dws2SessionBasics;

const
  DWS_MAXUSERSESSIONS = 150; // max concurrent user sessions

type
  ESessionOverflow = class(Exception);

  // global array of user sessions, access only allowed in Critical Sections
  TGlobalSessionList = class(TStringList)
  private
    FMaxSessions: Integer;
    ListSynchronizer: TMultiReadExclusiveWriteSynchronizer;
  public
    constructor create;
    destructor destroy; override;
    procedure FreeListObjects; virtual;
    function CreateUserSession: TUserSession; virtual;
    function GetUserSession(SBrand: string; ReqTime, TchTime: real): TUserSession; virtual;
    function TouchUserSession(SBrand: string; ReqTime, TchTime: real): TUserSession; virtual;
    procedure DeleteUserSession(SBrand: string); virtual;
    function GetExpiredSessions(ReqTime, Tchtime: real): TObjectList; virtual;
    property MaxSessions: integer read FMaxSessions write FMaxSessions;
  end;


implementation

// ************************** TGlobalSessionList  *************************

constructor TGlobalSessionList.create;
begin
  inherited;
  ListSynchronizer := TMultiReadExclusiveWriteSynchronizer.Create;
  capacity := DWS_MAXUSERSESSIONS;
  FMaxSessions := DWS_MAXUSERSESSIONS;
  Sorted := true;
  Duplicates := dupError;
end;

destructor TGlobalSessionList.destroy;
begin
  FreeListObjects;
  ListSynchronizer.Free;
  inherited;
end;

procedure TGlobalSessionList.FreeListObjects;
var
  i: integer;
begin
  try
  // Critical Section  **************************   Critical Section ***************
    ListSynchronizer.BeginWrite;
    for i := 0 to count - 1 do
      if not (Objects[i] = nil) then
        Objects[i].Free;
  finally
    ListSynchronizer.EndWrite;
  end;
  // Critical Section end  **********************   Critical Section end ***********
end;

function TGlobalSessionList.CreateUserSession: TUserSession;
var
  id: integer;
begin
  if count < DWS_MAXUSERSESSIONS then
  try
  // Critical Section  **************************   Critical Section ***************
    ListSynchronizer.BeginWrite;
    result := TUserSession.create;
    id := IndexOf(result.SessionBrand); // no doublettes
    while id >= 0 do
    begin
      result.reset;
      id := IndexOf(result.SessionBrand);
    end;
    addobject(result.SessionBrand, result);
  finally
    ListSynchronizer.EndWrite;
  end
  // Critical Section end  **********************   Critical Section end ***********
  else
    raise ESessionOverflow.Create('SessionOverflow');
  // example for code:  on e: ESessionOverflow do raise;
end;

function TGlobalSessionList.GetUserSession(SBrand: string; ReqTime, TchTime: real): TUserSession;
begin
  result := TouchUserSession(SBrand, ReqTime, TchTime);
  if not (result = nil) then
  begin
    result.TLastAction := now;
  end;
end;

function TGlobalSessionList.TouchUserSession(SBrand: string; ReqTime, TchTime: real): TUserSession;
var
  id: integer;
  dtReqTime, dtTchTime: TDateTime;
begin
  // Critical Section  **************************   Critical Section ***************
  ListSynchronizer.BeginRead;
  try
    // compare SessionBrand  with SessionBrand in global sessions list
    id := IndexOf(SBrand);
    if id < 0 then
      Result := nil
    else
      Result := TUserSession(objects[id])
  finally
    ListSynchronizer.EndRead;
  end;
  // Critical Section end  **********************   Critical Section end ***********
  if not (result = nil) then
  begin
    dtReqTime := now - ReqTime;
    if TchTime > 0 then
      dtTchTime := now - TchTime
    else
      dtTchTime := now - ReqTime;
    if (Result.TLastAction < dtReqTime) or (Result.TLastTouch < dtTchTime) then
    begin
      result.ClientState := dwsClientStateTOUT;
      result := nil;
    end
    else
      result.TLastTouch := now;
  end;
end;


procedure TGlobalSessionList.DeleteUserSession(SBrand: string);
var
  id: integer;
begin
  // Critical Section  **************************   Critical Section ***************
  ListSynchronizer.BeginWrite;
  try
    // compare SessionBrand  with SessionBrand in global sessions list
    id := IndexOf(SBrand);
    if id >= 0 then
    begin
      TUserSession(objects[id]).free;
      delete(id);
    end;
  finally
    ListSynchronizer.EndWrite;
  end;
  // Critical Section end  **********************   Critical Section end ***********
end;

function TGlobalSessionList.GetExpiredSessions(ReqTime, TchTime: real): TObjectList;
var
  id: integer;
  dtReqTime, dtTchTime: TDateTime;
begin
  result := TObjectList.Create;
  dtReqTime := now - ReqTime;
  if TchTime > 0 then
    dtTchTime := now - TchTime
  else
    dtTchTime := now - ReqTime;

  // Critical Section  **************************   Critical Section ***************
  ListSynchronizer.BeginWrite;
  try
    // compare SessionBrand  with SessionBrand in global sessions list
    for id := 1 to count - 1 do
      with TUserSession(objects[id]) do
      begin
        if (TLastAction < dtReqTime) or (TLastTouch < dtTchTime)
          or (ClientState = dwsClientStateTOUT) then
        begin
          result.add(TUserSession(objects[id]));
          self.Delete(id);
        end;
      end;
  finally
    ListSynchronizer.EndWrite;
  end;
  // Critical Section end  **********************   Critical Section end ***********
end;

end.
