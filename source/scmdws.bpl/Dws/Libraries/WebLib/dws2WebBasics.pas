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
{    Portions created by Willibad Krenn are Copyright (C) 2001         }
{    Williald Krenn, Austria. All Rights Reserved.                     }
{                                                                      }
{    Contributor(s): ______________________________________.           }
{                                                                      }
{**********************************************************************}

unit dws2WebBasics;

interface

uses
  HTTPApp, Sysutils, Classes, MatlusMultipartParser, IdTCPClient,
  dws2SessionBasics;

type
  TContentEvent = procedure(Sender: TComponent; WebRequest: TWebRequest; WebResponse: TWebResponse) of object;

  EForward = class(Exception);


  THttpInfo = class
  private
    FHttpRequest: TWebRequest;
    FHttpResponse: TWebResponse;
    procedure SetHttpRequest(HRequest: TWebRequest);
    procedure SetHttpResponse(HResponse: TWebResponse);
  public
    Params: TStrings;
    ContentSize: Integer;
    ScriptDocDate: TDateTime;
    ScriptDocSize: Integer;
    ScriptDocFileName: string;
    ScriptDocPath: string;
    UserSession: TUserSession;
    FMsMultipartFormParser: TMsMultipartFormParser;
    constructor Create;
    destructor Destroy; override;
    property HttpRequest: TWebRequest read FHttpRequest write SetHttpRequest;
    property HttpResponse: TWebResponse read FHttpResponse write SetHttpResponse;
  end;

  ISessionManager = interface
    ['{0650BDFF-5314-4B12-8DCB-A04F4C8AC071}']
    function GetUserSession: TUserSession;
    function GetSessionBrand: string;
    function LocateUserSession(HttpInfo: THttpInfo): TSessionTrackingState;
    function CreateUserSession: TUserSession;
    procedure CloseUserSession(USession: TUserSession);
  end;

  TFormVarGroupObj = class(TObject)
  private
    FPrefix: string;
    FRecNr,
      FPrefixLength: Integer;
    FAddNullFields: boolean;
    FParams, FParamGrp: TStringList;
    procedure SetPrefix(Prefix: string);
    function GetExt: string;
    function GetValue: string;
    function GetCount: Integer;
  public
    constructor create(Params: TStringList);
    property Prefix: string read FPrefix write SetPrefix;
    property AddNullFields: boolean read FAddNullFields write FAddNullFields;
    property RecNr: Integer read FRecNr write FRecNr;
    property Count: Integer read GetCount;
    property PrefixLength: Integer read FPrefixLength;
    property Ext: string read GetExt;
    property Value: string read GetValue;
  end;


implementation


// ************************** THttpInfo  *************************

constructor THttpInfo.Create;
begin
  Params := TStringList.Create;
  FMsMultipartFormParser := TMsMultipartFormParser.Create;
//  UserSession := TUserSession.create;
end;

destructor THttpInfo.Destroy;
begin
  Params.Free;
  FMsMultipartFormParser.Free;
  inherited;
end;

procedure THttpInfo.SetHttpRequest(HRequest: TWebRequest);
begin
  FHttpRequest := HRequest;
  ContentSize := Length(HRequest.Content); // FActRequest.ContentLength;
  ScriptDocFileName := ExtractFileName(HRequest.PathTranslated);
  ScriptDocPath := ExtractFilePath(HRequest.PathTranslated);
  ScriptDocDate := FileDateToDateTime(FileAge(HRequest.PathTranslated));

  Params.clear;
  Params.AddStrings(HRequest.QueryFields);
  if pos('multipart', HRequest.ContentType) > 0 then // since ver1.6.2 fileupload!!
  begin
   // MultiPartBoundary := copy(HRequest.ContentType,
   //    pos('BOUNDARY=',uppercase(HRequest.ContentType))+9,255);
    FMsMultipartFormParser.Parse(HRequest);
    Params.AddStrings(FMsMultipartFormParser.ContentFields);
  end
  else begin
    Params.AddStrings(HRequest.ContentFields);
  end;
end;

procedure THttpInfo.SetHttpResponse(HResponse: TWebResponse);
begin
  FHttpResponse := HResponse;
end;


// **************************   *************************
// ************************** FormVarGrp  *************************
// **************************   *************************

constructor TFormVarGroupObj.create(Params: TStringList);
begin
  FParamGrp := TStringList.create;
  FParams := Params;
  FAddNullFields := false;
  FRecNr := 0;
end;

procedure TFormVarGroupObj.SetPrefix(Prefix: string);
var
  ii: integer;
  sH: string;
begin
  FPrefix := uppercase(Prefix);
  FPrefixLength := length(FPrefix);
  FParamGrp.clear;
  FRecNr := 0;
  for ii := 0 to FParams.Count - 1 do
  begin
    sH := FParams[ii];
    if pos(Prefix, uppercase(sH)) = 1 then
    begin
      delete(sH, 1, FPrefixLength);
      if FAddNullFields or (length(copy(sH, pos('=', sH) + 1, 255)) > 0) then
        FParamGrp.Add(sH);
    end;
  end;
end;

function TFormVarGroupObj.GetExt: string;
begin
  result := FParamGrp.Names[FRecNr];
end;

function TFormVarGroupObj.GetValue: string;
begin
  result := copy(FParamGrp.Strings[FRecNr], pos('=', FParamGrp.Strings[FRecNr]) + 1, 255);
end;

function TFormVarGroupObj.GetCount: Integer;
begin
  result := FParamGrp.count;
end;




end.
