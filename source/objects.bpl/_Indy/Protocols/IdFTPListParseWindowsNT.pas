{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  16162: IdFTPListParseWindowsNT.pas
{
{   Rev 1.10    10/26/2004 10:03:22 PM  JPMugaas
{ Updated refs.
}
{
{   Rev 1.9    9/7/2004 10:01:12 AM  JPMugaas
{ FIxed problem parsing:
{ 
{ drwx------ 1 user group              0 Sep 07 09:20 xxx
{ 
{ It was mistakenly being detected as Windows NT because there was a - in the
{ fifth and eigth position in the string.  The fix is to detect to see if the
{ other chactors in thbat column are numbers.
{ 
{ I did the same thing to the another part of the detection so that something
{ similar doesn't happen there with "-" in Unix listings causing false
{ WindowsNT detection.
}
{
{   Rev 1.8    6/5/2004 3:02:10 PM  JPMugaas
{ Indicates SizeAvail = False for a directory.  That is the standard MS-DOS
{ Format.
}
{
{   Rev 1.7    4/20/2004 4:01:14 PM  JPMugaas
{ Fix for nasty typecasting error.  The wrong create was being called.
}
{
{   Rev 1.6    4/19/2004 5:05:16 PM  JPMugaas
{ Class rework Kudzu wanted.
}
{
{   Rev 1.5    2004.02.03 5:45:16 PM  czhower
{ Name changes
}
{
{   Rev 1.4    1/22/2004 4:56:12 PM  SPerry
{ fixed set problems
}
{
{   Rev 1.3    1/22/2004 7:20:54 AM  JPMugaas
{ System.Delete changed to IdDelete so the code can work in NET.
}
{
    Rev 1.2    10/19/2003 3:48:16 PM  DSiders
  Added localization comments.
}
{
{   Rev 1.1    9/27/2003 10:45:50 PM  JPMugaas
{ Added support for an alternative date format.
}
{
{   Rev 1.0    2/19/2003 02:01:54 AM  JPMugaas
{ Individual parsing objects for the new framework.
}
unit IdFTPListParseWindowsNT;

interface

uses
  Classes,
  IdFTPList, IdFTPListParseBase, IdTStrings;

{
Note:

This parser comes from the code in Indy 9.0's MS-DOS parser.

It has been renamed Windows NT here because that is more accurate than
the old name.

This is really the standard Microsoft IIS FTP Service format.  We have
tested this parser with Windows NT 4.0, Windows 2000, and Windows XP.

This parser also handles recursive dir lists.
}
type
  TIdWindowsNTFTPListItem = class(TIdFTPListItem);
  TIdFTPLPWindowsNT = class(TIdFTPListBase)
  protected
    class function MakeNewItem(AOwner : TIdFTPListItems)  : TIdFTPListItem; override;
    class function ParseLine(const AItem : TIdFTPListItem; const APath : String=''): Boolean; override;
  public
    class function GetIdent : String; override;
    class function CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): boolean; override;
    class function ParseListing(AListing : TIdStrings; ADir : TIdFTPListItems) : boolean; override;
  end;

const
  WINNTID = 'Windows NT'; {do not localize}

implementation

uses
  IdGlobal, IdFTPCommon, IdGlobalProtocols,
  SysUtils;

{ TIdFTPLPWindowsNT }

class function TIdFTPLPWindowsNT.CheckListing(AListing: TIdStrings;
  const ASysDescript: String; const ADetails: Boolean): boolean;
var SDir, sSize : String;
  i : Integer;
  SData : String;
begin
  Result := False;
  for i := 0 to AListing.Count - 1 do
  begin
    if (AListing[i]<>'') and
      (IsSubDirContentsBanner(AListing[i])=False) then
    begin
      SData := UpperCase(AListing[i]);
      sDir := Trim(Copy(SData, 25, 6));
      sSize := StringReplace(Trim(Copy(SData, 31, 8)), ',', '', [rfReplaceAll]);    {Do not Localize}
      //VM/BFS does share the date/time format as MS-DOS for the first two columns
  //    if ((CharIsInSet(SData, 3, ['/', '-'])) and (CharIsInSet(SData, 6, ['/', '-']))) then
      if IsMMDDYY(Copy(SData,1,8),'-') or IsMMDDYY(Copy(SData,1,8),'/') then
      begin
        if (sDir = '<DIR>') then  {do not localize}
        begin
          Result := IsVMBFS(SData)=False;
        end
        else
        begin
          //may be a file - see if we can get the size if sDir is empty
          if ((sDir = '') and    {Do not Localize}
            (StrToInt64Def(sSize, -1) <> -1)) then
          begin
            Result := IsVMBFS(SData)=False;
          end;
        end;
      end
      else
      begin
        //maybe, we are dealing with this pattern
        //2002-09-02  18:48       <DIR>          DOS dir 2
        //or
        //2002-09-02  19:06                9,730 DOS file 2
        //
        //Those were obtained from soem comments in some FileZilla source-code.
        //FtpListResult.cpp
        //Note that none of that GNU source-code was used.
      //  if ((CharIsInSet(SData, 5, ['/', '-'])) and (CharIsInSet(SData , 8, ['/', '-']))) then
        if IsYYYYMMDD(SData) then
        begin
          if (sDir = '<DIR>') then  {do not localize}
          begin
            Result := IsVMBFS(SData)=False;
          end
          else
          begin
            //may be a file - see if we can get the size if sDir is empty
            if ((sDir = '') and    {Do not Localize}
              (StrToInt64Def(sSize, -1) <> -1)) then
            begin
              Result := IsVMBFS(SData)=False;
            end;
          end;
        end;
      end;
    end;
  end;
end;

class function TIdFTPLPWindowsNT.GetIdent: String;
begin
  Result := WINNTID;
end;

class function TIdFTPLPWindowsNT.MakeNewItem(
  AOwner: TIdFTPListItems): TIdFTPListItem;
begin
  Result := TIdWindowsNTFTPListItem.Create(AOwner);
end;

class function TIdFTPLPWindowsNT.ParseLine(const AItem: TIdFTPListItem;
  const APath: String): Boolean;
var
  LModified: string;
  LTime: string;
  LName: string;
  LValue: string;
  LBuffer: string;
  LPosMarker : Integer;
begin
//Note that there is quite a bit of duplicate code in this if.
//That is because there are two similar forms but the dates are in
//different forms and have to be processed differently.
  if IsNumeric(Copy(AItem.Data,1,4)) then
  begin
    LModified := Copy(AItem.Data, 1,4) + '/' + Copy(AItem.Data, 6, 2) + '/' +
      Copy(AItem.Data, 9, 2) + ' ';
    LBuffer := Trim(Copy(AItem.Data, 11, Length(AItem.Data)));
      // Scan time info
    LTime := Fetch(LBuffer);
    // Scan optional letter in a[m]/p[m]
    LModified := LModified + LTime;
    // Convert modified to date time
    try
      AItem.ModifiedDate := IdFTPCommon.DateYYMMDD(Fetch(LModified));
      AItem.ModifiedDate := AItem.ModifiedDate + TimeHHMMSS(LModified);
    except
      AItem.ModifiedDate := 0.0;
    end;
  end
  else
  begin
    LModified := Copy(AItem.Data, 1, 2) + '/' + Copy(AItem.Data, 4, 2) + '/' +    {Do not Localize}
      Copy(AItem.Data, 7, 2) + ' ';    {Do not Localize}
    LBuffer := Trim(Copy(AItem.Data, 9, Length(AItem.Data)));
      // Scan time info
    LTime := Fetch(LBuffer);
    // Scan optional letter in a[m]/p[m]
    LModified := LModified + LTime;
    // Convert modified to date time
    try
      AItem.ModifiedDate := DateMMDDYY(Fetch(LModified));
      AItem.ModifiedDate := AItem.ModifiedDate + TimeHHMMSS(LModified);
    except
      AItem.ModifiedDate := 0.0;
    end;
  end;

  LBuffer := Trim(LBuffer);

  // Scan file size or dir marker
  LValue := Fetch(LBuffer);

  // Strip commas or StrToInt64Def will barf
  if (IndyPos(',', LValue) <> 0) then    {Do not Localize}
  begin
    LValue := StringReplace(LValue, ',', '', [rfReplaceAll]);    {Do not Localize}
  end;

  // What did we get?
  if (UpperCase(LValue) = '<DIR>') then    {Do not Localize}
  begin
    AItem.ItemType := ditDirectory;
    AItem.SizeAvail := False;
  end
  else
  begin
    AItem.ItemType := ditFile;
    AItem.Size := StrToInt64Def(LValue, 0);
  end;

  //We do things this way because a space starting a file name is legel
  if (AItem.ItemType = ditDirectory) then
  begin
    LPosMarker := 10;
  end
  else
  begin
    LPosMarker := 1;
  end;

  // Rest of the buffer is item name
  AItem.LocalFileName := LName;
  LName := Copy(LBuffer,LPosMarker,Length(LBuffer ));
  if APath<>'' then
  begin
  //MS_DOS_CURDIR
    AItem.LocalFileName := LName;
    LName := APath + PATH_FILENAME_SEP_DOS + LName;
    if Copy(LName,1,Length(MS_DOS_CURDIR))=MS_DOS_CURDIR then
    begin
      IdDelete(LName,1,Length(MS_DOS_CURDIR));
    end;
  end;
  AItem.FileName := LName;
  Result := True;
end;

class function TIdFTPLPWindowsNT.ParseListing(AListing: TIdStrings;
  ADir: TIdFTPListItems): boolean;
var i : Integer;
  LPathSpec : String;
  LItem : TIdFTPListItem;
begin
  for i := 0 to AListing.Count -1 do
  begin
    if (AListing[i] ='') then
    begin
    end
    else
    begin
      if IsSubDirContentsBanner(AListing[i]) then
      begin
        LPathSpec := Copy(AListing[i],1,Length(AListing[i])-1);
      end
      else
      begin
        LItem := MakeNewItem (ADir);
        LItem.Data := AListing[i];
        ParseLine( LItem, LPathSpec);
      end;
    end;
  end;
  Result := True;
end;

initialization
  RegisterFTPListParser(TIdFTPLPWindowsNT);
finalization
  UnRegisterFTPListParser(TIdFTPLPWindowsNT);
end.
