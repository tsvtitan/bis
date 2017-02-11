{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  16170: IdFTPListParseHellSoft.pas
{
{   Rev 1.5    10/26/2004 9:36:30 PM  JPMugaas
{ Updated ref.
}
{
{   Rev 1.4    4/19/2004 5:05:26 PM  JPMugaas
{ Class rework Kudzu wanted.
}
{
{   Rev 1.3    2004.02.03 5:45:20 PM  czhower
{ Name changes
}
{
{   Rev 1.2    24/01/2004 19:20:06  CCostelloe
{ Cleaned up warnings
}
{
    Rev 1.1    10/19/2003 2:27:14 PM  DSiders
  Added localization comments.
}
{
{   Rev 1.0    2/19/2003 02:02:12 AM  JPMugaas
{ Individual parsing objects for the new framework.
}
unit IdFTPListParseHellSoft;

interface
uses classes, IdFTPList, IdFTPListParseBase, IdFTPListParseNovellNetware, IdTStrings;
{
This parser works just like Novell Netware's except that the detection is
different.

HellSoft made a freeware FTP Server for Novell Netware in the early 1990's for
Novell Netware 3 and 4.  It is still somewhat in use in some Eastern parts of Europ.
}
type
  TIdHellSoftFTPListItem = class(TIdNovellNetwareFTPListItem);
  TIdFTPLPHellSoft = class(TIdFTPLPNovellNetware)
  protected
    class function MakeNewItem(AOwner : TIdFTPListItems)  : TIdFTPListItem; override;
  public

    class function GetIdent : String; override;
    class function CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): boolean; override;
  end;

implementation

uses
  IdGlobal, IdFTPCommon, IdGlobalProtocols, SysUtils;

{ TIdFTPLPHellSoft }

class function TIdFTPLPHellSoft.CheckListing(AListing: TIdStrings;
  const ASysDescript: String; const ADetails: Boolean): boolean;

  function IsHellSoftLine(AData : String) : Boolean;
  var LPerms : String;
  begin
    Result := AData <> '';
    if Result then
    begin
      Result := CharIsInSet(AData, 1, ['d','D','-']); {do not localize}
      if Result then
      begin
        //we have to be careful to distinguish between Hellsoft and
        //NetWare Print Services for UNIX, FTP File Transfer Service
        LPerms := ExtractNovellPerms(Copy(AData, 1, 12));
        Result := (Length(LPerms) = 7) and IsValidNovellPermissionStr(LPerms);
      end;
    end;
  end;

begin
  Result := False;
  if AListing.Count > 0 then
  begin
    if IsTotalLine(AListing[0]) then
    begin
      Result := (AListing.Count > 1) and IsHellSoftLine(AListing[1]);
    end
    else
    begin
      Result := IsHellSoftLine(AListing[0]);
    end;
  end;
end;

class function TIdFTPLPHellSoft.GetIdent: String;
begin
  Result := 'Hellsoft'; {do not localize}
end;

class function TIdFTPLPHellSoft.MakeNewItem(
  AOwner: TIdFTPListItems): TIdFTPListItem;
begin
  Result :=  TIdHellSoftFTPListItem.Create(AOwner);
end;

initialization
  RegisterFTPListParser(TIdFTPLPHellSoft);
finalization
  UnRegisterFTPListParser(TIdFTPLPHellSoft);
end.

