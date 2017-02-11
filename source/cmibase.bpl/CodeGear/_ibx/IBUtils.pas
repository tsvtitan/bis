{$A8} {$R-}
{*************************************************************}
{                                                             }
{       CodeGear Delphi Visual Component Library              }
{       InterBase Express core components                     }
{                                                             }
{       Copyright (c) 1998-2007 CodeGear                      }
{                                                             }
{    InterBase Express is based in part on the product        }
{    Free IB Components, written by Gregory H. Deatz for      }
{    Hoagland, Longo, Moran, Dunst & Doukas Company.          }
{    Free IB Components is used under license.                }
{                                                             }
{    Additional code created by Jeff Overcash and used        }
{    with permission.                                         }
{*************************************************************}

unit IBUtils;

interface

uses
  {$IFDEF MSWINDOWS}
  Windows, Messages,
  {$ENDIF}
  {$IFDEF LINUX}
  Types, ThreadedTimer,
  {$ENDIF}
  Classes, SysUtils, DB, DBCommon;

const
{$IFDEF MSWINDOWS}
  CRLF = #13 + #10;
{$ENDIF}
{$IFDEF LINUX}
  CRLF = #10;
{$ENDIF}
  CR   = #13;
  LF   = #10;
  TAB  = #9;
  NULL_TERMINATOR = #0;

function Max(n1, n2: Integer): Integer;
function Min(n1, n2: Integer): Integer;
function RandomString(iLength: Integer): String;
function RandomInteger(iLow, iHigh: Integer): Integer;
function StripString(st: String; CharsToStrip: String): String;
function FormatIdentifier(Dialect: Integer; Value: String): String;
function FormatIdentifierValue(Dialect: Integer; Value: String): String;
function ExtractIdentifier(Dialect: Integer; Value: String): String;
function QuoteIdentifier(Dialect: Integer; Value: String): String;
function AddIBParamSQLForDetail(Params: TParams; SQL: string; Native: Boolean; Dialect : Integer): string;
procedure DecomposeDatabaseName(DatabaseName : String;
            var ServerName, Protocol, DatabasePath : String);

type
{$IFDEF MSWINDOWS}
  TIBTimer = class(TComponent)
  private
    FInterval: Cardinal;
    FWindowHandle: HWND;
    FOnTimer: TNotifyEvent;
    FEnabled: Boolean;
    procedure UpdateTimer;
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: Cardinal);
    procedure SetOnTimer(Value: TNotifyEvent);
    procedure WndProc(var Msg: TMessage);
  protected
    procedure Timer; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Interval: Cardinal read FInterval write SetInterval default 1000;
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
  end;
{$ENDIF}
{$IFDEF LINUX}
  TIBTimer = class(TThreadedTimer);
{$ENDIF}

var
  CopyMasterFieldToDetail : Boolean;

implementation

uses IBXConst, IB;

function Max(n1, n2: Integer): Integer;
begin
  if (n1 > n2) then
    result := n1
  else
    result := n2;
end;

function Min(n1, n2: Integer): Integer;
begin
  if (n1 < n2) then
    result := n1
  else
    result := n2;
end;

function RandomString(iLength: Integer): String;
begin
  result := '';
  while Length(result) < iLength do
    result := result + IntToStr(RandomInteger(0, High(Integer)));
  if Length(result) > iLength then
    result := Copy(result, 1, iLength);
end;

function RandomInteger(iLow, iHigh: Integer): Integer;
begin
  result := Random(iHigh - iLow) + iLow;
end;

function StripString(st: String; CharsToStrip: String): String;
var
  i: Integer;
begin
  result := '';
  for i := 1 to Length(st) do begin
    if AnsiPos(st[i], CharsToStrip) = 0 then
      result := result + st[i];
  end;
end;

function FormatIdentifier(Dialect: Integer; Value: String): String;
begin
  Value := Trim(Value);
  if Dialect = 1 then
    Value := AnsiUpperCase(Value)
  else
    if (Value <> '') and (Value[1] = '"') then
      Value := '"' + StringReplace (TrimRight(Value), '"', '""', [rfReplaceAll]) + '"'
    else
      Value := AnsiUpperCase(Value);
  Result := Value;
end;

function FormatIdentifierValue(Dialect: Integer; Value: String): String;
begin
  Value := Trim(Value);
  if Dialect = 1 then
    Value := AnsiUpperCase(Value)  
  else
  begin
    if (Value <> '') and (Value[1] = '"') then
    begin
      Delete(Value, 1, 1);
      Delete(Value, Length(Value), 1);
      Value := StringReplace (Value, '""', '"', [rfReplaceAll]);
    end
    else
      Value := AnsiUpperCase(Value);
  end;
  Result := Value;
end;

function ExtractIdentifier(Dialect: Integer; Value: String): String;
begin
  Value := Trim(Value);
  if Dialect = 1 then
    Value := AnsiUpperCase(Value)
  else
  begin
    if (Value <> '') and (Value[1] = '"') then
    begin
      Delete(Value, 1, 1);
      Delete(Value, Length(Value), 1);
      Value := StringReplace (Value, '""', '"', [rfReplaceAll]);
    end
    else
      Value := AnsiUpperCase(Value);
  end;
  Result := Value;
end;

function QuoteIdentifier(Dialect: Integer; Value: String): String;
begin
  if Dialect = 1 then
    Value := AnsiUpperCase(Trim(Value))
  else
    Value := '"' + StringReplace (Value, '"', '""', [rfReplaceAll]) + '"';
  Result := Value;
end;

function AddIBParamSQLForDetail(Params: TParams; SQL: string; Native: Boolean; Dialect : Integer): string;
const
  SWhere = ' where ';     { do not localize }
  SAnd = ' and ';         { do not localize }

  function GenerateParamSQL: string;  
  var
    I: Integer;
  begin
    for I := 0 to Params.Count -1 do
    begin
      if I > 0 then Result := Result + SAnd;
      if Native then
        Result := Result + format('%s = ?', [QuoteIdentifier(Dialect, Params[I].Name)]) {do not localize}
      else
        Result := Result + format('%0:s = :%0:s', [QuoteIdentifier(Dialect, Params[I].Name)]); {do not localize}
    end;
    if pos(SWhere, LowerCase(Result)) > 0 then
      Result := SAnd + Result
    else
      Result := SWhere + Result;
  end;

  function AddWhereClause: string;
  var
    Start: PChar;
    Rest, FName: string;
    SQLToken, CurSection: TSQLToken;
  begin
    Start := PChar(SQL);
    CurSection := stUnknown;
    repeat
      SQLToken := NextSQLToken(Start, FName, CurSection);
    until SQLToken in [stFrom, stEnd];
    if SQLToken = stFrom then
      NextSQLToken(Start, FName, CurSection);
    Rest := string(Start);
    if Rest = '' then
      Result := SQL + ' ' + GenerateParamSQL
    else
      Result := Copy(SQL, 1, pos(Rest, SQL)) + ' ' + GenerateParamSQL + Rest;
  end;

begin
  Result := SQL;
  if (Params.Count > 0) then
    Result := AddWhereClause;
end;

procedure DecomposeDatabaseName(DatabaseName : String;
  var ServerName, Protocol, DatabasePath : String);
var
  Idx1, Idx2: Integer;
  st: string;
begin
  if Pos('\\', DatabaseName) <> 0 then {do not localize}
  begin
    Protocol := 'NamedPipe';
    st := copy(DatabaseName, 3, Length(DatabaseName));
    Idx1 := Pos('\', st); {do not localize}
    if Idx1 = 0 then
      IBError(ibxeUnknownError, [nil])
    else
    begin
      ServerName := Copy(st, 1, Idx1 - 1);
      DatabasePath := Copy(st, Idx1 + 1, Length(st));
    end;
  end
  else
  begin
    Idx1 := Pos(':', DatabaseName ); {do not localize}
    If (Idx1 = 0) or (Idx1 = 2) then
    begin
      DatabasePath := DatabaseName;
      ServerName := '';
      Protocol := 'Local';
    end
    else
    begin
      Idx2 := Pos('@', DatabaseName); {do not localize}
      if Idx2 = 0 then
      begin
        Protocol := 'TCP';
        ServerName := copy(DatabaseName, 1, Idx1 - 1);
        DatabasePath := copy(DatabaseName, Idx1 + 1, Length(DatabaseName));
      end
      else
      begin
        Protocol := 'SPX';
        ServerName := copy(DatabaseName, 1, Idx2 - 1);
        DatabasePath := copy(DatabaseName, Idx2 + 1, Length(DatabaseName));
      end;
    end;
  end;
end;

{$IFDEF MSWINDOWS}
{ TIBTimer }

constructor TIBTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True;
  FInterval := 1000;
  FWindowHandle := AllocateHWnd(WndProc);
end;

destructor TIBTimer.Destroy;
begin
  FEnabled := False;
  UpdateTimer;
  DeallocateHWnd(FWindowHandle);
  inherited Destroy;
end;

procedure TIBTimer.WndProc(var Msg: TMessage);
begin
  with Msg do
    if Msg = WM_TIMER then
      try
        Timer;
      except
        if Assigned(ApplicationHandleException) then
          ApplicationHandleException(Self);
      end
    else
      Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
end;

procedure TIBTimer.UpdateTimer;
begin
  KillTimer(FWindowHandle, 1);
  if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then
    if SetTimer(FWindowHandle, 1, FInterval, nil) = 0 then
      raise EOutOfResources.Create(SNoTimers);
end;

procedure TIBTimer.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure TIBTimer.SetInterval(Value: Cardinal);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    UpdateTimer;
  end;
end;

procedure TIBTimer.SetOnTimer(Value: TNotifyEvent);
begin
  FOnTimer := Value;
  UpdateTimer;
end;

procedure TIBTimer.Timer;
begin
  if Assigned(FOnTimer) then FOnTimer(Self);
end;
{$ENDIF}

initialization
  CopyMasterFieldToDetail := false;
end.
