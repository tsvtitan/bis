{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  17827: IdFTPListParseVxWorks.pas
{
{   Rev 1.4    10/26/2004 10:03:22 PM  JPMugaas
{ Updated refs.
}
{
{   Rev 1.3    4/19/2004 5:06:08 PM  JPMugaas
{ Class rework Kudzu wanted.
}
{
{   Rev 1.2    2004.02.03 5:45:40 PM  czhower
{ Name changes
}
{
    Rev 1.1    10/19/2003 3:48:16 PM  DSiders
  Added localization comments.
}
{
{   Rev 1.0    4/7/2003 04:10:34 PM  JPMugaas
{ Renamed IdFTPListParseVsWorks.  The s was a typo.
}
{
{   Rev 1.0    2/19/2003 05:49:54 PM  JPMugaas
{ Parsers ported from old framework.
}
unit IdFTPListParseVxWorks;

interface
uses classes, IdFTPList, IdFTPListParseBase, IdTStrings;

type
  TIdVxWorksFTPListItem = class(TIdFTPListItem);
  TIdFTPLPVxWorks = class(TIdFTPListBaseHeader)
  protected
    class function MakeNewItem(AOwner : TIdFTPListItems)  : TIdFTPListItem; override;
    class function IsHeader(const AData: String): Boolean;  override;
    class function IsFooter(const AData : String): Boolean; override;
    class function ParseLine(const AItem : TIdFTPListItem; const APath : String=''): Boolean; override;
  public
    class function GetIdent : String; override;
  end;

implementation

uses
  IdGlobal, IdFTPCommon, IdGlobalProtocols, IdStrings, SysUtils;

{ TIdFTPLPVxWorks }

class function TIdFTPLPVxWorks.GetIdent: String;
begin
  Result := 'Wind River VxWorks'; {do not localize}
end;

class function TIdFTPLPVxWorks.IsFooter(const AData: String): Boolean;
begin
  {Not sure if the value string is in the FTP list
   because I didn't see it first hand, it could've been a VxWorks command
   prompt, but just in case.}
  Result := IndyPos('value', AData) = 1;  {do not localize}
end;

class function TIdFTPLPVxWorks.IsHeader(const AData: String): Boolean;
var LCols : TIdStrings;
begin
  Result := False;
  LCols := TIdStringList.Create;
  try
     SplitColumns(Trim(AData),LCols);
     if (LCols[0] = 'size') and (LCols[1] = 'date') and   {do not localize}
        (LCols[2] = 'time') and (LCols[3] = 'name') then  {do not localize}
        begin
          Result := True;
        end;
  finally
    FreeAndNil(LCols);
  end;
end;

class function TIdFTPLPVxWorks.MakeNewItem(
  AOwner: TIdFTPListItems): TIdFTPListItem;
begin
  Result := TIdVxWorksFTPListItem.Create(AOwner);
end;

class function TIdFTPLPVxWorks.ParseLine(const AItem: TIdFTPListItem;
  const APath: String): Boolean;
var LBuffer : String;
begin
  LBuffer := Trim(AItem.Data);
  //Size
  AItem.Size := StrToIntDef(Fetch(LBuffer),0);
  //  date
  LBuffer := TrimLeft(LBuffer);
  AItem.ModifiedDate := DateStrMonthDDYY(Fetch(LBuffer));

  // time
  LBuffer := TrimLeft(LBuffer);
  AItem.ModifiedDate := AItem.ModifiedDate + TimeHHMMSS(Fetch(LBuffer));

  // item type
  if Copy(LBuffer, Length(LBuffer)-4, 5) = '<DIR>' then {do not localize}
  begin
    AItem.ItemType := ditDirectory;
    LBuffer := Copy(LBuffer, 1, Length(LBuffer)-5);
  end;
  //I hope filenames and dirs don't start or end with a space
  AItem.FileName := Trim(LBuffer);
  Result := True;
end;

initialization
  RegisterFTPListParser(TIdFTPLPVxWorks);
finalization
  UnRegisterFTPListParser(TIdFTPLPVxWorks);
end.
