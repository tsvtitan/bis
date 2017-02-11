{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  16168: IdFTPListParseNovellNetware.pas
{
{   Rev 1.8    10/26/2004 9:51:14 PM  JPMugaas
{ Updated refs.
}
{
{   Rev 1.7    4/20/2004 4:01:30 PM  JPMugaas
{ Fix for nasty typecasting error.  The wrong create was being called.
}
{
{   Rev 1.6    4/19/2004 5:05:24 PM  JPMugaas
{ Class rework Kudzu wanted.
}
{
{   Rev 1.5    2004.02.03 5:45:20 PM  czhower
{ Name changes
}
{
{   Rev 1.4    1/22/2004 4:59:16 PM  SPerry
{ fixed set problems
}
{
{   Rev 1.3    1/22/2004 7:20:44 AM  JPMugaas
{ System.Delete changed to IdDelete so the code can work in NET.
}
{
    Rev 1.2    10/19/2003 3:36:06 PM  DSiders
  Added localization comments.
}
{
{   Rev 1.1    4/7/2003 04:04:08 PM  JPMugaas
{ User can now descover what output a parser may give.
}
{
{   Rev 1.0    2/19/2003 02:02:08 AM  JPMugaas
{ Individual parsing objects for the new framework.
}
unit IdFTPListParseNovellNetware;

interface
uses classes, IdFTPList, IdFTPListParseBase, IdFTPListTypes, IdTStrings;
{
This parser should work with Netware 3 and 4.  It will probably work on later
versions of Novell Netware as well.

}
type
  TIdNovellNetwareFTPListItem = class(TIdNovellBaseFTPListItem);
  TIdFTPLPNovellNetware = class(TIdFTPListBase)
  protected
    class function MakeNewItem(AOwner : TIdFTPListItems)  : TIdFTPListItem; override;
    class function ParseLine(const AItem : TIdFTPListItem; const APath : String=''): Boolean; override;
  public
    class function GetIdent : String; override;
    class function CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): boolean; override;
    class function ParseListing(AListing : TIdStrings; ADir : TIdFTPListItems) : boolean; override;
  end;

implementation

uses
  IdGlobal, IdFTPCommon, IdGlobalProtocols, SysUtils;

{ TIdFTPLPNovellNetware }

class function TIdFTPLPNovellNetware.CheckListing(AListing: TIdStrings;
  const ASysDescript: String; const ADetails: Boolean): boolean;

  function IsNetwareLine(AData : String) : Boolean;
  var LPerms : String;
  begin
    Result := AData <> '';
    if Result then
    begin
      //The space in the set might be necessary for a test case I had captured
      //from a website.  I don't know if that is an real FTP list or not but it's
      //better to be safe then sorry.  At least I did tighten up the Novell Permissions
      //check.
      Result := (CharIsInSet(AData, 1, ['d','D','-',' ']));  {Do not translate}
      if Result then
      begin
        // we need to test HellSoft separately from this even though they will be handled by
        //the same parser.
        if Result then
        begin
          LPerms := ExtractNovellPerms(AData);
          Result := IsValidNovellPermissionStr(LPerms) and (Length(LPerms)=8) and
                    (IsNovelPSPattern(AData)=False);
        end;
      end;
    end;
  end;

begin
  Result := False;
  if AListing.Count > 0 then
  begin
    if IsTotalLine(AListing[0]) then
    begin
      Result := (AListing.Count >1) and IsNetwareLine(AListing[1]);
    end
    else
    begin
      Result := IsNetwareLine(AListing[0]);
    end;
  end;
end;

class function TIdFTPLPNovellNetware.GetIdent: String;
begin
  Result := 'Novell Netware'; {do not localize}
end;

class function TIdFTPLPNovellNetware.MakeNewItem(
  AOwner: TIdFTPListItems): TIdFTPListItem;
begin
  Result := TIdNovellNetwareFTPListItem.Create(AOwner);
end;

class function TIdFTPLPNovellNetware.ParseLine(const AItem: TIdFTPListItem;
  const APath: String): Boolean;
var strs : TIdStrings;
  wYear, LCurrentMonth, wMonth, wDay: Word;
  wHour, wMin, wSec, wMSec: Word;
  ADate: TDateTime;
  LBuf : String;
  NameStartPos : Integer;
  NameStartIdx : Integer;
  LName : String;
  LI : TIdNovellNetwareFTPListItem;
{
- [RWCEAFMS]          0                       1576 Feb 08  2000 00README
- [RWCEAFMS]          0                        742 Jan 03  2001 00INDEX
- [RWCEAFMS] tjhamalainen                  1020928 Sep 25  2001 winntnw.exe
d [RWCEAFMS] Okkola                            512 Aug 17 03:42 WINDOWS

-[R----F-]  1 raj           857 Feb 23  2000 !info!
d[R----F-]  1 raj           512 Nov 30  2001 incoming

d [R----F--] supervisor            512       Jan 16 18:53    login
- [R----F--] rhesus             214059       Oct 20 15:27    cx.exe


}
begin
  LI := AItem as TIdNovellNetwareFTPListItem;
  NameStartIdx := 5;
  // Get defaults for modified date/time
  ADate := Now;
  DecodeDate(ADate, wYear, wMonth, wDay);
  DecodeTime(ADate, wHour, wMin, wSec, wMSec);
  LCurrentMonth := wMonth;

  if (UpperCase(Copy(LI.Data,1,1)) = 'D') then
  begin
    LI.ItemType :=  ditDirectory;
  end
  else
  begin
    LI.ItemType :=  ditFile;
  end;
  //Most FTP Clients don't support permissions on a Novel Netware server.
  LBuf :=  AItem.Data;
  LI.NovellPermissions := ExtractNovellPerms(LBuf);
  Fetch(LBuf,'] ');
  if LBuf <> '' then
  begin
    //One Novell Server I found at nf.wsp.krakow.pl
    //uses an old version of Novell Netware (3.12 or so).  That differs slightly
    if (LBuf[1] = ' ') then
    begin
      IdDelete(LBuf,1,1);
      // LBuf := TrimLeft(LBuf);
      Fetch(LBuf);
    end;
    strs := TIdStringList.Create;
    try
      SplitColumns(LBuf, strs);
   //   IdStrings.SplitColumns(LBuf,strs);

      {
      0 - owner
      1 - size
      2 - month
      3 - day of month
      4 - time or year
      5 - start of file name or time
      6 - start of file name if 5 was time
      }
      if (strs.Count > 4) then
      begin
        LI.OwnerName := strs[0];
        LI.Size := StrToIntDef(strs[1],0);
        wMonth := StrToMonth(strs[2]);
        if wMonth < 1 then
        begin
          wMonth := LCurrentMonth;
        end;
        wDay := StrToIntDef(strs[3],wDay);
        if (IndyPos(':',Strs[4])=0) then
        begin
          wYear := StrToIntDef(strs[4],wYear);
          wYear := Y2Year(wYear);
          wHour := 0;
          wMin := 0;
          if (Strs.Count > 5) and (IndyPos(':',Strs[5])>0) then
          begin
            LBuf := Strs[5];
            wHour := StrToIntDef(Fetch(LBuf,':'),wHour);
            wMin := StrToIntDef(Fetch(LBuf,':'),wMin);
            NameStartIdx := 6;
          end;
        end
        else
        begin
          wYear := AddMissingYear(wDay,wMonth);
          LBuf := Strs[4];
          wHour := StrToIntDef(Fetch(LBuf,':'),wHour);
          wMin := StrToIntDef(Fetch(LBuf,':'),wMin);
        end;
        LI.ModifiedDate := EncodeDate(wYear,wMonth,wDay);
        LI.ModifiedDate := LI.ModifiedDate + EncodeTime(wHour,wMin,0,0);
        //Note that I doubt a file name can start with a space in Novel/
        //Netware.  Some code I've seen strips those off.
        for NameStartPos := NameStartIdx to Strs.Count -1 do
        begin
          LName := LName + ' '+Strs[NameStartPos];
        end;
        IdDelete(LName,1,1);
        LI.FileName := LName;
        //Novell Netware is case sensitive I think.
        LI.LocalFileName := LName;
      end;
    finally
      FreeAndNil(strs);
    end;
  end;
  Result := True;
end;

class function TIdFTPLPNovellNetware.ParseListing(AListing: TIdStrings;
  ADir: TIdFTPListItems): boolean;
var LStartLine : Integer;
    i : Integer;
    LItem : TIdFTPListItem;
begin
  if AListing.Count = 0 then
  begin
    Result := True;
    Exit;
  end;
  If IsTotalLine(AListing[0]) then
  begin
    LStartLine := 1;
  end
  else
  begin
    LStartLine := 0;
  end;
  for i := LStartLine to AListing.Count -1 do
  begin
    LItem := Self.MakeNewItem(ADir);
    LItem.Data := AListing[i];
    ParseLine( LItem);
  end;
  Result := True;
end;

initialization
  RegisterFTPListParser(TIdFTPLPNovellNetware);
finalization
  UnRegisterFTPListParser(TIdFTPLPNovellNetware);
end.
