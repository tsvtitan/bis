{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  16214: IdFTPListParseBullGCOS8.pas
{
{   Rev 1.6    10/26/2004 9:36:28 PM  JPMugaas
{ Updated ref.
}
{
{   Rev 1.5    4/19/2004 5:05:52 PM  JPMugaas
{ Class rework Kudzu wanted.
}
{
{   Rev 1.4    2004.02.03 5:45:30 PM  czhower
{ Name changes
}
{
{   Rev 1.3    1/22/2004 4:42:38 PM  SPerry
{ fixed set problems
}
{
    Rev 1.2    10/19/2003 2:27:04 PM  DSiders
  Added localization comments.
}
{
{   Rev 1.1    4/7/2003 04:03:42 PM  JPMugaas
{ User can now descover what output a parser may give.
}
{
{   Rev 1.0    2/19/2003 10:13:20 PM  JPMugaas
{ Moved parsers to their own classes.
}
unit IdFTPListParseBullGCOS8;

interface
uses classes, IdFTPList, IdFTPListParseBase, IdFTPListTypes, IdTStrings;

type
  TIdFTPLPGOS8ListItem = class(TIdUnixPermFTPListItem);
  TIdFTPLPGOS8 = class(TIdFTPListBase)
  protected
    class function MakeNewItem(AOwner : TIdFTPListItems)  : TIdFTPListItem; override;
    class function ParseLine(const AItem : TIdFTPListItem; const APath : String=''): Boolean; override;
  public
    class function GetIdent : String; override;
    class function CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): boolean; override;
  end;

implementation

uses
  IdGlobal, IdFTPCommon, IdGlobalProtocols, IdStrings, SysUtils;

{ TIdFTPLPGOS8 }

class function TIdFTPLPGOS8.CheckListing(AListing: TIdStrings;
  const ASysDescript: String; const ADetails: Boolean): boolean;
var LData : String;
begin
  Result := False;
  if AListing.Count > 0 then
  {
  d rwx rwx ---           0 02/25/98           ftptest2      catalog1
  - rwx rwx ---        1280 05/06/98 10:12:10  uid           testbcd
  12345678901234567890123456789012345678901234567890123456789012345678901234567890
           1         2         3         4         5         6         7         8
  }
  begin
    LData := AListing[0];
    Result := (Length(LData)>59) and
      (CharIsInSet(LData, 1, ['d', '-'])) and    {Do not Localize}
      (LData[2]=' ') and
      (CharIsInSet(LData, 3, ['t','s','r','w','x','-'])) and    {Do not Localize}
      (CharIsInSet(LData, 4, ['t','s','r','w','x','-'])) and    {Do not Localize}
      (CharIsInSet(LData, 5, ['t','s','r','w','x','-'])) and    {Do not Localize}
      (LData[6]=' ') and
      (CharIsInSet(LData, 7, ['t','s','r','w','x','-'])) and    {Do not Localize}
      (CharIsInSet(LData, 8, ['t','s','r','w','x','-'])) and    {Do not Localize}
      (CharIsInSet(LData, 9, ['t','s','r','w','x','-'])) and    {Do not Localize}
      (LData[10]=' ') and
      (CharIsInSet(LData, 11, ['t','s','r','w','x','-'])) and    {Do not Localize}
      (CharIsInSet(LData, 12, ['t','s','r','w','x','-'])) and    {Do not Localize}
      (CharIsInSet(LData, 13, ['t','s','r','w','x','-'])) and    {Do not Localize}
      (LData[14]=' ') and
      IsNumeric(LData[25]) and (LData[26]=' ');
  end;
end;

class function TIdFTPLPGOS8.GetIdent: String;
begin
  Result := 'Bull GCOS8'; {do not localize}
end;

class function TIdFTPLPGOS8.MakeNewItem(
  AOwner: TIdFTPListItems): TIdFTPListItem;
begin
  Result := TIdFTPLPGOS8ListItem.Create(AOwner);
end;

class function TIdFTPLPGOS8.ParseLine(const AItem: TIdFTPListItem;
  const APath: String): Boolean;
//Based on FTP 8 Administrator's and User's Guide
//which is available at: http://www.bull.com/us/cd_doc/cd_doc_data/rj05a03.pdf

//  d rwx rwx ---           0 02/25/98           ftptest2      catalog1
//  - rwx rwx ---        1280 05/06/98 10:12:10  uid           testbcd
//                12345678901                    12345678901234
//  12345678901234567890123456789012345678901234567890123456789012345678901234567890
//           1         2         3         4         5         6         7         8
var LBuf : String;
  LI : TIdUnixPermFTPListItem;
begin
  LI := AItem as TIdFTPLPGOS8ListItem;
  if Length(AItem.Data)>0 then
  begin
    if LI.Data[1] = 'd' then
    begin
      LI.ItemType := ditDirectory;
    end
    else
    begin
      LI.ItemType := ditFile;
    end;

    LI.FileName := Copy(AItem.Data, 60, Length(AItem.Data));
    //These may correspond roughly to Unix permissions
    //The values are the same as reported with Unix emulation mode
    LI.UnixOwnerPermissions := Copy(AItem.Data, 3, 3);
    LI.UnixGroupPermissions := Copy(AItem.Data, 7, 3);
    LI.UnixOtherPermissions := Copy(AItem.Data, 11, 3);

    LI.Size := StrToIntDef(Trim(Copy(AItem.Data, 15, 11)), 0);

    LI.OwnerName := Trim(Copy(AItem.Data,46,14));

    LI.ModifiedDate := DateMMDDYY(Copy(AItem.Data, 27, 8));
    LBuf := Copy(AItem.Data, 36, 8);
    if IsWhiteString(LBuf) = False then
    begin
      LI.ModifiedDate := LI.ModifiedDate + TimeHHMMSS(LBuf);
    end;
  end;
  Result := True;
end;

initialization
  RegisterFTPListParser(TIdFTPLPGOS8);
finalization
  UnRegisterFTPListParser(TIdFTPLPGOS8);

end.

