{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  19368: IdReplyFTP.pas 
{
{   Rev 1.14    10/26/2004 10:39:54 PM  JPMugaas
{ Updated refs.
}
{
{   Rev 1.13    8/8/04 12:28:04 AM  RLebeau
{ Bug fix for SetFormattedReply() to better conform to RFC 959
}
{
{   Rev 1.12    6/20/2004 8:30:28 PM  JPMugaas
{ TIdReply was ignoring Formatted Output in some strings used in output.
}
{
{   Rev 1.11    5/18/04 2:42:30 PM  RLebeau
{ Changed TIdRepliesFTP to derive from TIdRepliesRFC, and changed constructor
{ back to using 'override'
}
{
{   Rev 1.10    5/17/04 9:52:36 AM  RLebeau
{ Changed TIdRepliesFTP constructor to use 'reintroduce' instead
}
{
{   Rev 1.9    5/16/04 5:27:56 PM  RLebeau
{ Added TIdRepliesFTP class
}
{
{   Rev 1.8    2004.02.03 5:45:46 PM  czhower
{ Name changes
}
{
{   Rev 1.7    2004.01.29 12:07:52 AM  czhower
{ .Net constructor problem fix.
}
{
{   Rev 1.6    1/20/2004 10:03:26 AM  JPMugaas
{ Fixed a problem with a server where there was a line with only one " ".  It
{ was throwing things off.  Fixed by checking to see if a line <4 chars is
{ actually a number.
}
{
{   Rev 1.5    1/3/2004 8:05:46 PM  JPMugaas
{ Bug fix:  Sometimes, replies will appear twice due to the way functionality
{ was enherited.
}
{
{   Rev 1.4    10/26/2003 04:25:46 PM  JPMugaas
{ Fixed a bug where a line such as:
{ 
{ "     Version wu-2.6.2-11.73.1" would be considered the end of a command
{ response.
}
{
{   Rev 1.3    2003.10.18 9:42:12 PM  czhower
{ Boatload of bug fixes to command handlers.
}
{
{   Rev 1.2    2003.09.20 10:38:38 AM  czhower
{ Bug fix to allow clearing code field (Return to default value)
}
{
    Rev 1.1    5/30/2003 9:23:44 PM  BGooijen
  Changed TextCode to Code
}
{
{   Rev 1.0    5/26/2003 12:21:10 PM  JPMugaas
}
unit IdReplyFTP;

interface

uses
  Classes,
  IdReply, IdReplyRFC, IdTStrings;

type
  TIdReplyRFCFormat = (rfNormal, rfIndentMidLines);

const
  DEF_ReplyFormat = rfNormal;

type
  TIdReplyFTP = class(TIdReplyRFC)
  protected
    FReplyFormat : TIdReplyRFCFormat;
    function GetFormattedReply: TIdStrings; override;
    procedure SetFormattedReply(const AValue: TIdStrings); override;
    procedure AssignTo(ADest: TPersistent); override;
  public
    constructor Create(
      ACollection: TCollection = nil;
      AReplyTexts: TIdReplies = nil
      ); override;
    class function IsEndMarker(const ALine: string): Boolean; override;
  published
    property ReplyFormat : TIdReplyRFCFormat read FReplyFormat write FReplyFormat default DEF_ReplyFormat;
  end;

  TIdRepliesFTP = class(TIdRepliesRFC)
  public
    constructor Create(AOwner: TPersistent); override;
  end;

implementation

uses
  IdGlobal,
  SysUtils;

{ TIdReplyFTP }

procedure TIdReplyFTP.AssignTo(ADest: TPersistent);
var
  LR: TIdReplyFTP;
begin

  if ADest is TIdReplyFTP then begin
    LR := TIdReplyFTP(ADest);
     LR.ReplyFormat := ReplyFormat;
    LR.NumericCode := Self.NumericCode;
    LR.FText.Assign(Text);

  end
  else
  begin
    inherited;
  end;
end;

constructor TIdReplyFTP.Create(
      ACollection: TCollection = nil;
      AReplyTexts: TIdReplies = nil
      );
begin
  inherited;
  FReplyFormat := DEF_ReplyFormat;
end;

function TIdReplyFTP.GetFormattedReply: TIdStrings;
var i : Integer;
begin
  Result := GetFormattedReplyStrings;
  if NumericCode > 0 then begin
    if FText.Count > 0 then begin
      for i := 0 to FText.Count - 1 do begin
        if i < FText.Count - 1 then begin
          if Self.FReplyFormat=rfIndentMidLines then
          begin
            if i = 0 then
            begin
              Result.Add( IntToStr(NumericCode) + '-' + FText[i]);
            end
            else
            begin
              Result.Add( ' ' + FText[i]);
            end;
          end
          else
          begin
            Result.Add( IntToStr(NumericCode) + '-' + FText[i]);
          end;
        end else begin
          Result.Add( IntToStr(NumericCode) + ' ' + FText[i]);
        end;
      end;
    end else begin
      Result.Add( IntToStr(NumericCode));
    end;
  end else if FText.Count > 0 then begin
    Result.AddStrings(FText);
  end;
end;

class function TIdReplyFTP.IsEndMarker(const ALine: string): Boolean;
begin
  // Use copy not ALine[4] as it might not be long enough for that reference
  // to be valid
  Result := (Length(ALine) < 4) and IsNumeric(ALine);
  if Result = False then
  begin
    //"     Version wu-2.6.2-11.73.1"  is not a end of reply
    //"211 End of status" is the end of a reply
    Result := IsNumeric(Copy(ALine,1,3)) and (Copy(ALine, 4, 1) = ' ');
  end;
end;

procedure TIdReplyFTP.SetFormattedReply(const AValue: TIdStrings);
var
  i: Integer;
  LCode, LTemp: string;
begin
  Clear;
  if AValue.Count > 0 then begin
    // Get 4 chars - for POP3
    LCode := Trim(Copy(AValue[0], 1, 4));
    if Length(LCode) = 4 then begin
      if LCode[4] = '-' then begin
        SetLength(LCode, 3);
      end;
    end;
    Code := LCode;
    Text.Add(Copy(AValue[0], 5, MaxInt));
    FReplyFormat := rfNormal;
    if AValue.Count > 1 then begin
      for i := 1 to AValue.Count - 1 do begin
        // RLebeau - RFC 959 does not require the response code
        // to be prepended to every line like with other protocols.
        // Most FTP servers do this, but not all of them do, so
        // check here for that possibility ...
        if TextIsSame(Copy(AValue[i], 1, 3), LCode) then begin
          LTemp := Copy(AValue[i], 5, MaxInt);
        end else begin
          if Copy(AValue[i], 1, 1) = ' ' then begin
            FReplyFormat := rfIndentMidLines;
          end;
          LTemp := TrimLeft(AValue[i]);
        end;
        Text.Add(LTemp);
      end;
    end;
  end;
end;

{ TIdRepliesFTP }

constructor TIdRepliesFTP.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TIdReplyFTP);
end;

end.
