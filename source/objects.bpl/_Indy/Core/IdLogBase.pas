{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  11647: IdLogBase.pas 
{
{   Rev 1.5    2004.02.03 4:17:14 PM  czhower
{ For unit name changes.
}
{
{   Rev 1.4    2004.01.20 10:03:28 PM  czhower
{ InitComponent
}
{
{   Rev 1.3    2003.10.17 6:15:54 PM  czhower
{ Upgrades
}
{
{   Rev 1.2    2003.10.14 1:27:08 PM  czhower
{ Uupdates + Intercept support
}
{
{   Rev 1.1    6/16/2003 10:39:02 AM  EHill
{ Done: Expose Open/Close as public in TIdLogBase
}
{
{   Rev 1.0    11/13/2002 07:55:58 AM  JPMugaas
}
unit IdLogBase;

interface

uses
  Classes,
  IdIntercept, IdGlobal, IdSocketHandle;

type
  TIdLogBase = class(TIdConnectionIntercept)
  protected
    FActive: Boolean;
    FLogTime: Boolean;
    FReplaceCRLF: Boolean;
    FStreamedActive: Boolean;
    //
    procedure InitComponent; override;
    procedure LogStatus(AText: string); virtual; abstract;
    procedure LogReceivedData(AText: string; AData: string); virtual; abstract;
    procedure LogSentData(AText: string; AData: string); virtual; abstract;
    procedure SetActive(AValue: Boolean); virtual;
    procedure Loaded; override;
  public
    procedure Open; virtual;
    procedure Close; virtual;
    procedure Connect(AConnection: TComponent); override;
    destructor Destroy; override;
    procedure Disconnect; override;
    procedure Receive(var ABuffer: TIdBytes); override;
    procedure Send(var ABuffer: TIdBytes); override;
  published
    property Active: Boolean read FActive write SetActive default False;
    property LogTime: Boolean read FLogTime write FLogTime default True;
    property ReplaceCRLF: Boolean read FReplaceCRLF write FReplaceCRLF default true;
  end;

implementation

uses
  IdResourceStringsCore,
  SysUtils;

{ TIdLogBase }

procedure TIdLogBase.Close;
begin
end;

procedure TIdLogBase.Connect(AConnection: TComponent);
begin
  if FActive then begin
    inherited Connect(AConnection);
    LogStatus(RSLogConnected);
  end;
end;

destructor TIdLogBase.Destroy;
begin
  Active := False;
  inherited Destroy;
end;

procedure TIdLogBase.Disconnect;
begin
  if FActive then begin
    LogStatus(RSLogDisconnected);
    inherited Disconnect;
  end;
end;

procedure TIdLogBase.InitComponent;
begin
  inherited;
  FLogTime := True;
  ReplaceCRLF := True;
end;

procedure TIdLogBase.Loaded;
begin
  Active := FStreamedActive;
end;

procedure TIdLogBase.Open;
begin
end;

procedure TIdLogBase.Receive(var ABuffer: TIdBytes);
var
  s: string;
  LMsg: string;
begin
  if FActive then begin
    inherited Receive(ABuffer);
    LMsg := '';
    if LogTime then begin
      LMsg := DateTimeToStr(Now);
    end;
    s := BytesToString(ABuffer);
    if FReplaceCRLF then begin
      s := StringReplace(s, EOL, RSLogEOL, [rfReplaceAll]);
      s := StringReplace(s, CR, RSLogCR, [rfReplaceAll]);
      s := StringReplace(s, LF, RSLogLF, [rfReplaceAll]);
    end;
    LogReceivedData(LMsg, s);
  end;
end;

procedure TIdLogBase.Send(var ABuffer: TIdBytes);
var
  s: string;
  LMsg: string;
begin
  if FActive then begin
    inherited Send(ABuffer);
    LMsg := '';
    if LogTime then begin
      LMsg := DateTimeToStr(Now);
    end;
    s := BytesToString(ABuffer);
    if FReplaceCRLF then begin
      s := StringReplace(s, EOL, RSLogEOL, [rfReplaceAll]);
      s := StringReplace(s, CR, RSLogCR, [rfReplaceAll]);
      s := StringReplace(s, LF, RSLogLF, [rfReplaceAll]);
    end;
    LogSentData(LMsg, s);
  end;
end;

procedure TIdLogBase.SetActive(AValue: Boolean);
begin
  if (csReading in ComponentState) then
    FStreamedActive := AValue
  else
    if FActive <> AValue then
    begin
      FActive := AValue;
      if FActive then
        Open
      else
        Close;
    end;
end;

end.


