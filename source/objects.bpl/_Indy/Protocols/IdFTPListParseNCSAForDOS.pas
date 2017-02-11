{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  16220: IdFTPListParseNCSAForDOS.pas
{
{   Rev 1.5    10/26/2004 9:51:14 PM  JPMugaas
{ Updated refs.
}
{
{   Rev 1.4    6/5/2004 4:45:22 PM  JPMugaas
{ Reports SizeAvail=False for directories in a list.  As per the dir format.
}
{
{   Rev 1.3    4/19/2004 5:05:58 PM  JPMugaas
{ Class rework Kudzu wanted.
}
{
{   Rev 1.2    2004.02.03 5:45:32 PM  czhower
{ Name changes
}
{
    Rev 1.1    10/19/2003 3:36:04 PM  DSiders
  Added localization comments.
}
{
{   Rev 1.0    2/19/2003 10:13:38 PM  JPMugaas
{ Moved parsers to their own classes.
}
unit IdFTPListParseNCSAForDOS;

interface

uses
  Classes, IdFTPList, IdFTPListParseBase, IdTStrings;

type
  TIdNCSAforDOSFTPListItem = class(TIdFTPListItem);
  TIdFTPLPNCSAforDOS = class(TIdFTPListBaseHeader)
  protected
    class function MakeNewItem(AOwner : TIdFTPListItems)  : TIdFTPListItem; override;
    class function IsHeader(const AData: String): Boolean; override;
    class function IsFooter(const AData : String): Boolean; override;
    class function ParseLine(const AItem : TIdFTPListItem; const APath : String=''): Boolean; override;
  public
    class function CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): boolean; override;
    class function GetIdent : String; override;
  end;

implementation

uses
  IdGlobal, IdFTPCommon, IdGlobalProtocols, SysUtils;


{ TIdFTPLPNCSAforDOS }

class function TIdFTPLPNCSAforDOS.CheckListing(AListing: TIdStrings;
  const ASysDescript: String; const ADetails: Boolean): boolean;
var s : TIdStrings;
  LData : String;
begin
  Result := False;
  if AListing.Count > 0 then
  begin
    LData := AListing[0];
    Result := False;
    s := TIdStringList.Create;
    try
      SplitColumns(LData,s);
      if (s.Count > 3) then
      begin
        Result := (s[1] = '<DIR>') or (IsNumeric(s[1]));  {do not localize}
        Result := Result and IsHHMMSS(s[3], ':') and IsMMDDYY(s[2], '-')
          and ExcludeQVNET(LData);
      end;
    finally
      FreeAndNil(s);
    end;
  end;
end;

class function TIdFTPLPNCSAforDOS.GetIdent: String;
begin
  Result := 'NCSA for MS-DOS (CU/TCP)'; {do not localize}
end;

class function TIdFTPLPNCSAforDOS.IsFooter(const AData: String): Boolean;
var LWords : TIdStrings;
begin
  Result := False;
  LWords := TIdStringList.Create;
  try
    SplitColumns(Trim(StringReplace(AData, '-', ' ', [rfReplaceAll])), LWords);
    while (LWords.Count >2) do
    begin
      LWords.Delete(0);
    end;
    if LWords.Count = 2 then
    begin
      Result := (LWords[0] = 'Bytes') and (LWords[1] = 'Available');  {do not localize}
    end;
  finally
    FreeAndNil(LWords);
  end;
end;

class function TIdFTPLPNCSAforDOS.IsHeader(const AData: String): Boolean;
begin
  Result := False;
end;

class function TIdFTPLPNCSAforDOS.MakeNewItem(
  AOwner: TIdFTPListItems): TIdFTPListItem;
begin
  Result := TIdNCSAforDOSFTPListItem.Create(AOwner);
end;

class function TIdFTPLPNCSAforDOS.ParseLine(const AItem: TIdFTPListItem;
  const APath: String): Boolean;
var LBuf, LPt : String;

begin
  LBuf := AItem.Data;
  {filename - note that a space is illegal in MS-DOS so this should be safe}
  AItem.FileName := Fetch(LBuf);
  {type or size}
  LBuf := Trim(LBuf);
  LPt := Fetch(LBuf);
  if LPt = '<DIR>' then {do not localize}
  begin
    AItem.ItemType := ditDirectory;
    AItem.SizeAvail := False;
  end
  else
  begin
    AItem.ItemType := ditFile;
    AItem.Size := StrToIntDef(LPt,0);
  end;
  //time stamp
  if LBuf <> '' then
  begin
    LBuf := Trim(LBuf);
    LPt := Fetch(LBuf);
    if LPt <> '' then
    begin
      //Date
      AItem.ModifiedDate := DateMMDDYY(LPt);
      LBuf := Trim(LBuf);
      LPt := Fetch(LBuf);
      if LPt <> '' then
      begin
        AItem.ModifiedDate := AItem.ModifiedDate + TimeHHMMSS(LPt);
      end;
    end;
  end;
  Result := True;
end;

initialization
  RegisterFTPListParser(TIdFTPLPNCSAforDOS);
finalization
  UnRegisterFTPListParser(TIdFTPLPNCSAforDOS);
end.
