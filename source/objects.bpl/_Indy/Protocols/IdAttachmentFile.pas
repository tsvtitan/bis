{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  13730: IdAttachmentFile.pas 
{
{   Rev 1.4    28.09.2004 21:04:44  Andreas Hausladen
{ Delphi 5 does not have a Owner property in TCollection
}
{
{   Rev 1.3    24.08.2004 18:01:42  Andreas Hausladen
{ Added AttachmentBlocked property to TIdAttachmentFile.
}
{
{   Rev 1.2    2004.02.03 5:44:50 PM  czhower
{ Name changes
}
{
    Rev 1.1    5/9/2003 10:27:20 AM  BGooijen
  Attachment is now opened in fmShareDenyWrite mode
}
{
{   Rev 1.0    11/14/2002 02:12:42 PM  JPMugaas
}
unit IdAttachmentFile;

interface

uses
  IdAttachment, Classes, SysUtils, IdMessageParts;

type
  TIdAttachmentFile = class(TIdAttachment)
  protected
    FTempFileStream: TFileStream;
    FStoredPathName: TFileName;
    FFileIsTempFile: Boolean;
    FAttachmentBlocked: Boolean;
  public
    constructor Create(Collection: TIdMessageParts; const AFileName: TFileName = ''); reintroduce;
    destructor Destroy; override;

    function OpenLoadStream: TStream; override;
    procedure CloseLoadStream; override;
    function PrepareTempStream: TStream; override;
    procedure FinishTempStream; override;

    procedure SaveToFile(const FileName: TFileName); override;

    property FileIsTempFile: Boolean read FFileIsTempFile write FFileIsTempFile;
    property StoredPathName: TFileName read FStoredPathName write FStoredPathName;
    property AttachmentBlocked: Boolean read FAttachmentBlocked;
  end;

implementation

uses
  IdGlobal, IdGlobalProtocols, IdException, IdResourceStringsProtocols,
  IdMessage;

{ TIdAttachmentFile }

procedure TIdAttachmentFile.CloseLoadStream;
begin
  FreeAndNil(FTempFileStream);
end;

constructor TIdAttachmentFile.Create(Collection: TIdMessageParts; const AFileName: TFileName = '');
begin
  inherited Create(Collection);
  FFilename := ExtractFilename(AFilename);
  FTempFileStream := nil;
  FStoredPathName := AFileName;
  FFileIsTempFile := False;
end;

destructor TIdAttachmentFile.Destroy;
begin
  if FileIsTempFile then begin
    DeleteFile(StoredPathName);
  end;
  inherited Destroy;
end;

procedure TIdAttachmentFile.FinishTempStream;
begin
  FreeAndNil(FTempFileStream);
  // An on access virus scanner meight delete/block the temporary file.
  FAttachmentBlocked := not FileExists(StoredPathName);
  if FAttachmentBlocked and TIdMessage(TIdMessageParts(Collection).OwnerMessage).ExceptionOnBlockedAttachments then
  begin
    raise EIdMessageCannotLoad.CreateFmt(RSTIdMessageErrorAttachmentBlocked, [StoredPathName]);
  end;
end;

function TIdAttachmentFile.OpenLoadStream: TStream;
begin
  FTempFileStream := TFilestream.Create(StoredPathName, fmOpenRead or fmShareDenyWrite);
  Result := FTempFileStream;
end;

function TIdAttachmentFile.PrepareTempStream: TStream;
begin
  FStoredPathName := MakeTempFilename();
  FTempFileStream := TFilestream.Create(FStoredPathName, fmCreate);
  Result := FTempFileStream;
  FFileIsTempFile := True;
end;

procedure TIdAttachmentFile.SaveToFile(const FileName: TFileName);
begin
  if not CopyFileTo(StoredPathname, FileName) then begin
    raise EIdException.Create(RSTIdMessageErrorSavingAttachment);
  end;
end;

initialization
  RegisterClass(TIdAttachmentFile);

end.
