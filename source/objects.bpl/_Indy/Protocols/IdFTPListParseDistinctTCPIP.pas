{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  16218: IdFTPListParseDistinctTCPIP.pas
{
{   Rev 1.8    10/26/2004 9:36:28 PM  JPMugaas
{ Updated ref.
}
{
{   Rev 1.7    4/19/2004 5:05:56 PM  JPMugaas
{ Class rework Kudzu wanted.
}
{
{   Rev 1.6    2004.02.03 5:45:32 PM  czhower
{ Name changes
}
{
{   Rev 1.5    24/01/2004 19:19:28  CCostelloe
{ Cleaned up warnings
}
{
{   Rev 1.4    1/23/2004 12:52:58 PM  SPerry
{ fixed set problems
}
{
{   Rev 1.3    1/22/2004 5:54:02 PM  SPerry
{ fixed set problems
}
{
    Rev 1.2    10/19/2003 2:27:08 PM  DSiders
  Added localization comments.
}
{
{   Rev 1.1    4/7/2003 04:03:46 PM  JPMugaas
{ User can now descover what output a parser may give.
}
{
{   Rev 1.0    2/19/2003 10:13:32 PM  JPMugaas
{ Moved parsers to their own classes.
}
unit IdFTPListParseDistinctTCPIP;

interface
uses classes, IdFTPList, IdFTPListParseBase, IdTStrings;

type
  TIdDistinctTCPIPFTPListItem =  class(TIdFTPListItem)
  protected
    FDist32FileAttributes : String;
  public
    property ModifiedDateGMT;
    property Dist32FileAttributes : string read FDist32FileAttributes write FDist32FileAttributes;
  end;
  TIdFTPLPDistinctTCPIP = class(TIdFTPListBase)
  protected
    class function MakeNewItem(AOwner : TIdFTPListItems)  : TIdFTPListItem; override;
    class function ParseLine(const AItem : TIdFTPListItem; const APath : String=''): Boolean; override;
  public
    class function GetIdent : String; override;
    class function CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): boolean; override;
  end;

implementation

uses
  IdGlobal, IdFTPCommon, IdGlobalProtocols, SysUtils;

{ TIdFTPLPDistinctTCPIP }

class function TIdFTPLPDistinctTCPIP.CheckListing(AListing: TIdStrings;
  const ASysDescript: String; const ADetails: Boolean): boolean;
var s : TIdStrings;
  const DistValidTypes : set of AnsiChar = ['-','d'];
    DistValidAttrs : set of AnsiChar = ['w','a','s','h','-','d'];
    //w - can write - read attribute not set
    //a - archive bit set
    //s - system attribute bit set
    //h - hidden system bit set
begin
  Result := False;
  if AListing.Count > 0 then
  begin
    Result := False;
    s := TIdStringList.Create;
    try
      SplitColumns(AListing[0],s);
      if (s.Count > 2) then
      begin
        Result := (Length(s[0])=5) and (CharIsInSet(s[0], 1, DistValidTypes))
          and IsNumeric(s[1]) and ( StrToMonth(s[2])>0);
        if Result then
        begin
          Result := (CharIsInSet(s[0], 1, DistValidAttrs)) and
                    (CharIsInSet(s[0], 2, DistValidAttrs)) and
                    (CharIsInSet(s[0], 3, DistValidAttrs)) and
                    (CharIsInSet(s[0], 4, DistValidAttrs)) and
                    (CharIsInSet(s[0], 5, DistValidAttrs));
        end;
      end;
    finally
      FreeAndNil(s);
    end;
  end;
end;

class function TIdFTPLPDistinctTCPIP.GetIdent: String;
begin
  Result := 'Distinct TCP/IP';  {do not localize}
end;

class function TIdFTPLPDistinctTCPIP.MakeNewItem(
  AOwner: TIdFTPListItems): TIdFTPListItem;
begin
  Result := TIdDistinctTCPIPFTPListItem.Create(AOwner);
end;

class function TIdFTPLPDistinctTCPIP.ParseLine(const AItem: TIdFTPListItem;
  const APath: String): Boolean;
var LBuf : String;
    LBuf2 : String;
    LDate : String;
   LI : TIdDistinctTCPIPFTPListItem;
begin
  LI := AItem as TIdDistinctTCPIPFTPListItem;
  LBuf := TrimLeft(LI.Data);
  //attributes and attributes
  LI.Dist32FileAttributes := Fetch(LBuf);
  LBuf := TrimLeft(LBuf);
  if Copy(LI.Dist32FileAttributes, 1, 1)='d' then
  begin
    LI.ItemType := ditDirectory;
  end;
  //size
  LI.Size := StrToIntDef(Fetch(LBuf), 0);
  LBuf := TrimLeft(LBuf);
  //date - month
  LDate := Fetch(LBuf);
  LBuf := TrimLeft(LBuf);
  //date - day and year
  LBuf2 := Fetch(LBuf);
  //we do it this way because a year might sometimes be missing
  //in which case, we just add the current year.
  LDate := LDate + ',' + LBuf2;
  LDate := StringReplace(LDate, ',', ' ', [rfReplaceAll]);
  LI.ModifiedDate := DateStrMonthDDYY(LDate, ' ', True);
  //time
  LBuf := TrimLeft(LBuf);
  LDate := Fetch(LBuf);
  LI.ModifiedDate := LI.ModifiedDate + TimeHHMMSS(LDate);
  // -wa--          23  Dec 29,2002  18:42  createtest.txt
  // #Timestamp test with createtest.txt.
  // Corresponding local Dir entry:
  // 12/29/2002  01:42p                  23 CreateTest.txt
  // I suspect that this server returns the timestamp as GMT
  LI.ModifiedDateGMT := LI.ModifiedDate;
  LI.ModifiedDate := LI.ModifiedDate -TimeZoneBias;
  // file name
  LBuf := StripSpaces(LBuf, 1);
  LI.FileName := LBuf;
  Result := True;
end;

initialization
  RegisterFTPListParser(TIdFTPLPDistinctTCPIP);
finalization
  UnRegisterFTPListParser(TIdFTPLPDistinctTCPIP);
end.
