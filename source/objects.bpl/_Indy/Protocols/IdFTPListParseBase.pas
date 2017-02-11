{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  16159: IdFTPListParseBase.pas
{
{   Rev 1.16    11/5/2004 1:17:26 AM  JPMugaas
{ Now also should support sizd fact in some dir listings on PureFTPD.
}
{
{   Rev 1.15    10/26/2004 9:27:32 PM  JPMugaas
{ Updated references.
}
{
{   Rev 1.14    6/27/2004 1:45:36 AM  JPMugaas
{ Can now optionally support LastAccessTime like Smartftp's FTP Server could. 
{ I also made the MLST listing object and parser support this as well.
}
{
    Rev 1.13    6/11/2004 9:35:00 AM  DSiders
  Added "Do not Localize" comments.
}
{
{   Rev 1.12    6/7/2004 7:38:42 PM  JPMugaas
{ Fixed bug that appears in some descendant classes.  TIdFTPListBaseHeader
{ would only call ADir.Add.  If a descendant is using it's own descendant of
{ the TIdFTPListItem class for special properties, that would cause an invalid
{ typecast error.  It now calls MakeNewItem so that a descendant can override
{ the item creation to make it's own TIdFTPListItem descendant.
}
{
{   Rev 1.11    6/5/2004 3:04:12 PM  JPMugaas
{ In MLST format, we now indicate if Size is available  for item.   One version
{ of NcFTP will omit that for directories.  Confirmed at ftp.borland.com.  I
{ also did the same for Modified Date if MLST doesn't provide it.
}
{
{   Rev 1.10    4/19/2004 5:05:12 PM  JPMugaas
{ Class rework Kudzu wanted.
}
{
{   Rev 1.9    2004.02.03 5:45:14 PM  czhower
{ Name changes
}
{
{   Rev 1.8    11/26/2003 6:22:18 PM  JPMugaas
{ IdFTPList can now support file creation time for MLSD servers which support
{ that feature.  I also added support for a Unique identifier for an item so
{ facilitate some mirroring software if the server supports unique ID with EPLF
{ and MLSD.
}
{
    Rev 1.7    10/19/2003 2:27:02 PM  DSiders
  Added localization comments.
}
{
{   Rev 1.6    10/6/2003 08:58:00 PM  JPMugaas
{ Reworked the FTP list parsing framework so that the user can obtain the list
{ of capabilities from a parser class with TIdFTP.  This should permit the user
{ to present a directory listing differently for each parser (some FTP list
{ parsers do have different capabilities).
}
{
{   Rev 1.5    4/7/2003 04:03:06 PM  JPMugaas
{ User can now descover what output a parser may give.
}
{
{   Rev 1.4    3/3/2003 04:23:18 PM  JPMugaas
{ Fix for a stack overflow.  stupid mistake really.  Procedure kept calling
{ itself.
}
{
{   Rev 1.3    2/23/2003 06:08:16 AM  JPMugaas
}
{
{   Rev 1.2    2/21/2003 06:54:22 PM  JPMugaas
{ The FTP list processing has been restructured so that Directory output is not
{ done by IdFTPList.  This now also uses the IdFTPListParserBase for parsing so
{ that the code is more scalable.
}
{
{   Rev 1.1    2/19/2003 05:53:10 PM  JPMugaas
{ Minor restructures to remove duplicate code and save some work with some
{ formats.  The Unix parser had a bug that caused it to give a False positive
{ for Xercom MicroRTOS.
}
{
{   Rev 1.0    2/18/2003 07:00:30 PM  JPMugaas
{ Base class for new parsing framework.
}
unit IdFTPListParseBase;

interface

uses
  Classes, IdContainers, IdFTPList, IdTStrings;

type

  //We don't want to create instances of these classes and
  //these classes should not contain variables accross procedures
  //because they may run in threads.
  TIdFTPListBase = class(TObject)
  protected
    class function MakeNewItem(AOwner : TIdFTPListItems)  : TIdFTPListItem; virtual;
  //This is probably going to be a commonly used thing so it may be best to define it here.
  //THis is for parsing an individual line of data using AItem.Data
  //AItem is the item that was already created
  //APath should probably be a path passed to the parser for qualitying the filename and should
  //used only for recursive lists
    class function ParseLine(const AItem : TIdFTPListItem; const APath : String=''): Boolean; virtual;
  public

  //This should return a unique string indicating the type of format the parser supports
    class function GetIdent : String; virtual;
    //This determines if the parser is appropriate and returns True if it is or False if another parser
    //should be used
    class function CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): boolean; virtual;
    //This parses the AListing TIdStrings and fills in the ADir object
    class function ParseListing(AListing : TIdStrings; ADir : TIdFTPListItems) : boolean; virtual;
  end;
  TIdFTPListParseClass = class of TIdFTPListBase;
  TIdFTPRegParseList = class(TIdObjectList)
  protected
    function FindParserByDirData(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True) : TIdFTPListParseClass;
    function FindParserByIdent(const AIdent : String) : TIdFTPListParseClass;
  public
    constructor Create; overload;
    constructor Create(AOwnsObjects: Boolean); overload;
    function ParseListing(AListing : TIdStrings; ADir : TIdFTPListItems; const AFormatID : String ) : boolean; virtual;
    function CheckListParse(AListing : TIdStrings; ADir : TIdFTPListItems;var VFormat : String; const ASysDescript : String =''; const ADetails : Boolean = True) : boolean; virtual;
    function CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): String; virtual;
   {
   This is for TIdFTP.  This parses a list, returns the Parser ID, and the capabilities of the parser.
   }
    function CheckListParseCapa(AListing : TIdStrings; ADir : TIdFTPListItems; var VFormat : String; var VClass :  TIdFTPListParseClass; const ASysDescript : String =''; const ADetails : Boolean = True) : boolean; virtual;
  end;

  //these are anscestors for some listings with a heading
  TIdFTPListBaseHeader = class(TIdFTPListBase)
  protected
    class function IsHeader(const AData : String): Boolean; virtual;
    class function IsFooter(const AData : String): Boolean; virtual;
  public

    class function CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): boolean; override;
    class function ParseListing(AListing : TIdStrings; ADir : TIdFTPListItems) : boolean; override;
  end;
  //base class for line-by-line items where there is a file owner along with mod date and file size
  TIdFTPLineOwnedList = class(TIdFTPListBase)
  protected
    class function MakeNewItem(AOwner : TIdFTPListItems)  : TIdFTPListItem; override;
  public
  end;
  //These two parsers are manditory for the FTP Protocol
  TIdFTPLPNList = class(TIdFTPListBase)
  protected
    class function ParseLine(const AItem : TIdFTPListItem; const APath : String=''): Boolean; override;
  public
    class function GetIdent : String; override;
    class function CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): boolean; override;
  end;
  TIdFTPLPMList = class(TIdFTPListBase)
  protected
    class function ParseLine(const AItem : TIdFTPListItem; const APath : String=''): Boolean; override;
    class function MakeNewItem(AOwner : TIdFTPListItems)  : TIdFTPListItem; override;
  public

    class function GetIdent : String; override;
    class function CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): boolean; override;
  end;

function ParseListing(AListing : TIdStrings; ADir : TIdFTPListItems; const AFormatID : String ) : boolean;
function CheckListParse(AListing : TIdStrings; ADir : TIdFTPListItems;var AFormat : String; const ASysDescript : String =''; const ADetails : Boolean = True) : boolean;
function CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): String;
function CheckListParseCapa(AListing: TIdStrings;
  ADir: TIdFTPListItems; var VFormat: String;
  var VClass:  TIdFTPListParseClass; const ASysDescript: String;
  const ADetails: Boolean=True): boolean;

procedure RegisterFTPListParser(const AParser : TIdFTPListParseClass);
procedure UnregisterFTPListParser(const AParser : TIdFTPListParseClass);

const
  NLST = 'NLIST'; {do not localize}
  MLST = 'MLST';  {do not localize}

implementation

uses
  IdFTPCommon, IdFTPListTypes, IdGlobalProtocols, IdStrings, SysUtils;

var GParserList : TIdFTPRegParseList;

{ TIdFTPRegParseList }

constructor TIdFTPRegParseList.Create;
begin
  inherited Create(False);
end;

function TIdFTPRegParseList.CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): String;
var
  LCurParser : TIdFTPListParseClass;
begin
  Result := '';
  LCurParser := Self.FindParserByDirData(AListing, ASysDescript, ADetails);
  if LCurParser<>nil then
  begin
    Result := LCurParser.GetIdent;
  end;
end;

constructor TIdFTPRegParseList.Create(AOwnsObjects: Boolean);
begin
  inherited Create(AOwnsObjects);
end;

function TIdFTPRegParseList.ParseListing(AListing: TIdStrings;
  ADir: TIdFTPListItems; const AFormatID: String): boolean;
var
  LCurParser : TIdFTPListParseClass;
begin
  //we do not want to fault a user or developer for an ambigious list
  //such as something only containing a "total 0".
  Result := True;
  ADir.Clear;
  LCurParser := Self.FindParserByIdent(AFormatID);
  if LCurParser<>nil then
  begin
    Result := LCurParser.ParseListing(AListing,ADir);
  end;
end;

function TIdFTPRegParseList.CheckListParse(AListing : TIdStrings;
  ADir : TIdFTPListItems;var VFormat : String;
  const ASysDescript : String =''; const ADetails : Boolean = True) : boolean;
var LCurParser : TIdFTPListParseClass;
begin
  LCurParser := FindParserByDirData(AListing);
  Result := Assigned(LCurParser);
  if Result then
  begin
    VFormat := LCurParser.GetIdent;
    Result := ParseListing(AListing,ADir,VFormat);
  end;
end;

function TIdFTPRegParseList.FindParserByIdent(
  const AIdent: String): TIdFTPListParseClass;
var i : Integer;
  LCurParser : TIdFTPListParseClass;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    LCurParser := TIdFTPListParseClass(Items[i]);
    if LCurParser.GetIdent = AIdent then
    begin
      Result := LCurParser;
      break;
    end;
  end;
end;

function TIdFTPRegParseList.FindParserByDirData(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True) : TIdFTPListParseClass;
var i : Integer;
  LCurParser : TIdFTPListParseClass;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    LCurParser := TIdFTPListParseClass(Items[i]);
    if LCurParser.CheckListing(AListing,ASysDescript,ADetails) then
    begin
      Result := LCurParser;
      break;
    end;
  end;
end;

function TIdFTPRegParseList.CheckListParseCapa(AListing: TIdStrings;
  ADir: TIdFTPListItems; var VFormat: String;
  var VClass:  TIdFTPListParseClass; const ASysDescript: String;
  const ADetails: Boolean): boolean;
begin
  VFormat := '';
  VClass := FindParserByDirData(AListing,ASysDescript,ADetails);
  Result := VClass<>nil;
  if Result then
  begin

    VFormat := VClass.GetIdent;
    Result := VClass.ParseListing(AListing,ADir);
  end
  else
  begin
    ADir.Clear;
  end;
end;

{ TIdFTPListBase }

{register and unreg procedures}
procedure RegisterFTPListParser(const AParser : TIdFTPListParseClass);
begin
 GParserList.Add(TObject(AParser));
end;

procedure UnregisterFTPListParser(const AParser : TIdFTPListParseClass);
begin
  if Assigned(GParserList) then
  begin
    GParserList.Remove(TObject(AParser));
  end;
end;

function ParseListing(AListing : TIdStrings; ADir : TIdFTPListItems; const AFormatID : String ) : boolean;
begin
  Result := GParserList.ParseListing(AListing,ADir,AFormatID);
end;

function CheckListParse(AListing : TIdStrings; ADir : TIdFTPListItems;var AFormat : String; const ASysDescript : String =''; const ADetails : Boolean = True) : boolean;
begin
  Result := GParserList.CheckListParse(AListing,ADir,AFormat,ASysDescript,ADetails);
end;

function CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): String;
begin
  Result := GParserList.CheckListing(AListing,ASysDescript,ADetails);
end;

function CheckListParseCapa(AListing: TIdStrings;
  ADir: TIdFTPListItems; var VFormat: String;
  var VClass :  TIdFTPListParseClass; const ASysDescript: String;
  const ADetails: Boolean): boolean;
begin
  Result := GParserList.CheckListParseCapa(AListing,
    ADir, VFormat,
    VClass,
    ASysDescript,
    ADetails);
end;

{ TIdFTPListBase }

class function TIdFTPListBase.CheckListing(AListing: TIdStrings;
  const ASysDescript: String; const ADetails: Boolean): boolean;
begin
//C++Builder can not use abstract virtual class methods.
  Result := False;
end;

class function TIdFTPListBase.GetIdent: String;
begin
  Result := '';
end;

class function TIdFTPListBase.MakeNewItem(AOwner : TIdFTPListItems) : TIdFTPListItem;
begin
  Result := AOwner.Add;
end;

class function TIdFTPListBase.ParseLine(const AItem: TIdFTPListItem;
  const APath: String): Boolean;
begin
//C++Builder can not use abstract virtual class methods.
  Result := False;
end;

class function TIdFTPListBase.parselisting(AListing: TIdStrings;
  ADir: TIdFTPListItems): boolean;
var i : Integer;
  AItem : TIdFTPListItem;
begin
  Result := True;
  for i := 0 to AListing.Count -1 do
  begin
    if ( AListing[i]<>'') then
    begin
      AItem := MakeNewItem(ADir);
      AItem.Data := AListing[i];
      ParseLine(AItem,'');
    end;
  end;
end;

{ TIdFTPLPNList }

class function TIdFTPLPNList.CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): boolean;
begin
  Result := (ADetails=False);
end;

class function TIdFTPLPNList.GetIdent: String;
begin
  Result := NLST;
end;

class function TIdFTPLPNList.ParseLine(const AItem: TIdFTPListItem;
  const APath: String = ''): Boolean;
begin
  AItem.FileName := AItem.Data;
  Result := True;
end;

{ TIdFTPLPMList }

class function TIdFTPLPMList.CheckListing(AListing : TIdStrings; const ASysDescript : String =''; const ADetails : Boolean = True): boolean;
begin
//user has to specifically ask for this parser
  Result := False;
end;

class function TIdFTPLPMList.GetIdent: String;
begin
  Result := MLST;
end;

class function TIdFTPLPMList.MakeNewItem(
  AOwner: TIdFTPListItems): TIdFTPListItem;
begin
  Result := TIdMLSTFTPListItem.Create(AOwner);
end;

class function TIdFTPLPMList.ParseLine(const AItem: TIdFTPListItem;
  const APath: String =''): Boolean;
var LFacts : TIdStrings;
    LBuffer : String;
    LI : TIdMLSTFTPListItem;
//based on:
//
//http://www.ietf.org/internet-drafts/draft-ietf-ftpext-mlst-15.txt
begin
  LI := AItem as TIdMLSTFTPListItem;
  LFacts := TIdStringList.Create;
  try
    LI.FileName := ParseFacts(AItem.Data,LFacts);
    LI.LocalFileName := AItem.FileName;

    LBuffer := LFacts.Values['type']; {do not localize}
//   file         -- a file entry
//   cdir         -- the listed directory
//   pdir         -- a parent directory
//   dir          -- a directory or sub-directory
//   OS.name=type -- an OS or file system dependent file type

    if (LBuffer = 'cdir') or (LBuffer='pdir') or  {do not localize}
      (LBuffer = 'dir') then  {do not localize}
    begin
      LI.ItemType := ditDirectory;
    end
    else
    begin
      LI.ItemType := ditFile;
    end;
    LBuffer := LFacts.Values['modify']; {do not localize}
    if LBuffer <> '' then
    begin
      LI.ModifiedDate := FTPMLSToLocalDateTime(LBuffer);
      LI.ModifiedDateGMT := FTPMLSToGMTDateTime(LBuffer);
    end
    else
    begin
      LI.ModifiedAvail := False;
    end;
    //create
    LBuffer := LFacts.Values['create']; {do not localize}
    if LBuffer <> '' then
    begin
      LI.CreationDate := FTPMLSToLocalDateTime(LBuffer);
      LI.CreationDateGMT := FTPMLSToGMTDateTime(LBuffer);
    end;
    //last access time
    LBuffer := LFacts.Values['windows.lastaccesstime']; {do not localize}
    if LBuffer <> '' then
    begin
      LI.LastAccessDate := FTPMLSToLocalDateTime(LBuffer);
      LI.LastAccessDateGMT := FTPMLSToGMTDateTime(LBuffer);
    end;
    LBuffer := LFacts.Values['size']; {do not localize}
    if LBuffer<>'' then
    begin
      LI.Size := StrToIntDef(LBuffer, 0);

    end
    else
    begin
      LI.SizeAvail := False;
    end;
    if LI.SizeAvail = False and (LI.ItemType=ditDirectory) then
    begin
      {PureFTPD uses a sizd fact for directories instead of the size fact}
      LBuffer := LFacts.Values['sizd']; {Do not localize}
      if LBuffer<>'' then
      begin
        LI.Size := StrToIntDef(LBuffer, 0);
        LI.SizeAvail := True;
      end
      else
      begin
        LI.SizeAvail := False;
      end;
    end;
    LI.MLISTPermissions := LFacts.Values['perm'];  {do not localize}
    LI.UniqueID := LFacts.Values['unique']; {do not localize}
    Result := True;
  finally
    FreeAndNil(LFacts);
  end;
end;

{ TIdFTPListBaseHeader }


class function TIdFTPListBaseHeader.CheckListing(AListing: TIdStrings;
  const ASysDescript: String; const ADetails: Boolean): boolean;
var i : Integer;
begin
  Result := False;
  for i := 0 to AListing.Count -1 do
  begin
    if IsWhiteString(AListing[i])
       or IsLineStr(AListing[i]) then
    begin
    end
    else
    begin
      Result := IsHeader(AListing[i]);
      break;
    end;
  end;
end;

class function TIdFTPListBaseHeader.IsFooter(const AData: String): Boolean;
begin
  Result := False;
end;

class function TIdFTPListBaseHeader.IsHeader(const AData: String): Boolean;
begin
  Result := False;
end;

class function TIdFTPListBaseHeader.ParseListing(AListing: TIdStrings;
  ADir: TIdFTPListItems): boolean;
var LStart : Integer;
   i : Integer;
   LItem : TIdFTPListItem;
begin
  if AListing.Count >0 then
  begin
    //find the entries below the header
    LStart := 0;
    for i := 0 to AListing.Count -1 do
    begin
      if IsHeader(AListing[i]) or IsWhiteString(AListing[i])
       or IsLineStr(AListing[i]) then
      begin
        LStart := i+1;
      end
      else
      begin
        //we found where the header ends
        break;
      end;
    end;
    for i := LStart to AListing.Count -1 do
    begin
      if (IsWhiteString(AListing[i])=False) and
        (IsLineStr(AListing[i])=False)
        and (IsFooter(AListing[i])=False) then
      begin
        LItem := MakeNewItem(ADir);
        LItem.Data := AListing[i];
        ParseLine(LItem);
      end;
    end;
  end;
  Result := True;
end;

{ TIdFTPLineOwnedList }

class function TIdFTPLineOwnedList.MakeNewItem(
  AOwner: TIdFTPListItems): TIdFTPListItem;
begin
  Result := TIdOwnerFTPListItem.Create(AOwner);
end;

initialization
  GParserList := TIdFTPRegParseList.Create;

  //Register the manditory parsers
  RegisterFTPListParser(TIdFTPLPNList);
  RegisterFTPListParser(TIdFTPLPMList);

finalization
  FreeAndNil(GParserList);
end.
