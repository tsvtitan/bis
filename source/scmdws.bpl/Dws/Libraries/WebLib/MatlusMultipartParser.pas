{                                                                      }
{    This MultipartParser is from http://www.matlus.com                }
{    please visit this site, you will find lots of                     }
{    usefull things there.                                             }
{                                                                      }
{                                                                      }

unit MatlusMultipartParser;

interface

uses
{$IFDEF LINUX}
  Libc,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows, {Forms, Messages,}
{$ENDIF}
  HTTPApp, SysUtils, Classes, Contnrs;

type
  { Single HTTP File Object }
  THTTPFile = class(TObject)
  private
    FFieldName: string;
    FContentType: string;
    FFileName: string;
    FFileData: TStream;
    function GetImageFileType: integer;
    procedure SetFileData(const Value: TStream);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SaveToFile(SaveAsFile: string);
    procedure SaveToStream(Stream: TStream);
    property FieldName: string read FFieldName write FFieldName;
    property ContentType: string read FContentType write FContentType;
    property FileName: string read FFileName write FFileName;
    property ImageFileType: integer read GetImageFileType;
    property FileData: TStream read FFileData write SetFileData;
  end;
  { List Of HTTPFile Objects }
  THTTPFiles = class(TObjectList)
  private
    FOwnsObjects: Boolean;
  protected
    function GetItem(Index: Integer): THTTPFile;
    procedure SetItem(Index: Integer; AObject: THTTPFile);
  public
    function Add(AObject: THTTPFile): Integer;
    function Remove(AObject: THTTPFile): Integer;
    function IndexOf(AObject: THTTPFile): Integer;
    procedure Insert(Index: Integer; AObject: THTTPFile);
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
    property Items[Index: Integer]: THTTPFile read GetItem write SetItem; default;
  end;
  { TMsMultipartFormParser }
  TMsMultipartFormParser = class(TObject)
  private
    FHTTPFiles: THTTPFiles;
    FContentFields: TStrings;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Parse(Request: TWebRequest);
    property Files: THTTPFiles read FHTTPFiles;
    property ContentFields: TStrings read FContentFields;
  end;

implementation

{ THTTPFile }

constructor THTTPFile.Create;
begin
  inherited;
  FFileData := TMemoryStream.Create;
end;

destructor THTTPFile.Destroy;
begin
  FFileData.Free;
  inherited;
end;

procedure THTTPFile.SaveToFile(SaveAsFile: string);
begin
  TMemoryStream(FFileData).SaveToFile(SaveAsFile);
end;

procedure THTTPFile.SaveToStream(Stream: TStream);
begin
  FileData.Position := 0;
  TMemoryStream(FileData).SaveToStream(Stream);
  Stream.Position := 0;
end;

procedure THTTPFile.SetFileData(const Value: TStream);
begin
  Value.Position := 0;
  FFileData := Value;
end;

function THTTPFile.GetImageFileType: integer;
 { types: ioUnknown=0; ioGIF=2; ioJPEG=3; ioPNG=8; }
var
  sH : string;
begin
  sH := uppercase(ExtractFileExt(FFileName));
  if sH='.GIF' then
    result := 2
  else  if sH='.JPG' then
    result := 3
  else  if sH='.PNG' then
    result := 8
  else
    result := 0;
end;


{ THTTPFiles }

function THTTPFiles.Add(AObject: THTTPFile): Integer;
begin
  Result := inherited Add(AObject);
end;

function THTTPFiles.GetItem(Index: Integer): THTTPFile;
begin
  Result := THTTPFile(inherited Items[Index]);
end;

function THTTPFiles.IndexOf(AObject: THTTPFile): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

procedure THTTPFiles.Insert(Index: Integer; AObject: THTTPFile);
begin
  inherited Insert(Index, AObject);
end;

function THTTPFiles.Remove(AObject: THTTPFile): Integer;
begin
  Result := inherited Remove(AObject);
end;

procedure THTTPFiles.SetItem(Index: Integer; AObject: THTTPFile);
begin
  inherited Items[Index] := AObject;
end;

{ TMsMultipartFormParser }

constructor TMsMultipartFormParser.Create;
begin
  inherited;
  FHTTPFiles := THTTPFiles.Create;
  FContentFields := TStringList.Create;
end;

destructor TMsMultipartFormParser.Destroy;
begin
  FHTTPFiles.Free;
  FContentFields.Free;
  inherited;
end;

procedure TMsMultipartFormParser.Parse(Request: TWebRequest);
const
  HeaderTerminator = #13#10#13#10;
var
  Buffer: array[0..8191] of byte;
  ContentStream: TMemoryStream;
  HTTPFile: THTTPFile;
  ContentBuffer: PChar;
  BytesToRead: Longint;
  ExtraBytes: Longint;
  BytesRead: Longint;
  ContentBytes: Longint;
  CurrentPosition: Longint;
  HeaderInfo: string;
  FieldNameInHeader: string;
  ContentType: string;
  FileNameInHeader: string;
  HeaderDataTerminator: string;
  sBuffer: string;
begin
  ContentStream := TMemoryStream.Create;
  ContentFields.Clear; // hh:  TMsMultipartFormParser can be reused
  Files.Clear;
  try
    ContentBytes := Length(Request.Content);
    ContentBuffer := PChar(Request.Content);
    ContentStream.Write(ContentBuffer^, ContentBytes);
    { If ContentLength is larger than 48K, then use ReadClient to get the rest }
    if (Request.ContentLength > ContentBytes) then
    begin
      ExtraBytes := Request.ContentLength - ContentBytes;
      BytesRead := 0;
      BytesToRead := SizeOf(Buffer);
      while (BytesRead < ExtraBytes) do
      begin
        ContentBytes := Request.ReadClient(Buffer, BytesToRead);
        BytesRead := BytesRead + ContentBytes;
        ContentStream.Write(Buffer, ContentBytes);
        if (ExtraBytes - BytesRead) < SizeOf(Buffer) then
          BytesToRead := ExtraBytes - BytesRead;
      end;
    end;
    { Break the content up into it various parts }
    ContentStream.Position := 0;
    while (ContentStream.Position < ContentStream.Size) do
    begin
      { Extract the Header from the ContentStream. There can be multiple "Headers"
        if multiple files are being uploaded or there are additonal form fields }
      CurrentPosition := ContentStream.Position;
      SetLength(sBuffer, ContentStream.Size - CurrentPosition);
      ContentStream.Read(sBuffer[1], ContentStream.Size - CurrentPosition);
      BytesRead := Pos(HeaderTerminator, sBuffer) - 1;
      HeaderInfo := Copy(sBuffer, 1, BytesRead);
      ContentStream.Position := CurrentPosition + BytesRead + Length(HeaderTerminator);
      if HeaderInfo = '' then
        Break;

      FieldNameInHeader := '';
      ContentType := '';
      FileNameInHeader := '';
      { FieldNameInHeader }
      if (Pos('name="', LowerCase(HeaderInfo)) > 0) then
      begin
        FieldNameInHeader := Copy(HeaderInfo, Pos('name="', LowerCase(HeaderInfo)) + 6,
          Length(HeaderInfo));
        Delete(FieldNameInHeader, Pos('"', FieldNameInHeader), Length(FieldNameInHeader));
      end;
      { ContentType }
      if (Pos('content-type: ', LowerCase(HeaderInfo)) > 0) then
      begin
        ContentType := Copy(HeaderInfo, Pos('content-type: ', LowerCase(HeaderInfo)) + 14,
          Length(HeaderInfo));
      end;

      { FileNameInHeader }
      if (Pos('filename="', LowerCase(HeaderInfo)) > 0) then
      begin
        FileNameInHeader := Copy(HeaderInfo, Pos('filename="', LowerCase(HeaderInfo)) + 10,
          Length(HeaderInfo));
        Delete(FileNameInHeader, pos('"', FileNameInHeader), Length(FileNameInHeader));
        FileNameInHeader := ExtractFileName(FileNameInHeader);
      end;
      { Set the HeaderDataTermininator if required }
      if (HeaderDataTerminator = '') then
        HeaderDataTerminator := #13#10 + Copy(HeaderInfo, 1, Pos(#13#10, HeaderInfo) - 1);
      { Extract the data and put it in sBuffer }
      CurrentPosition := ContentStream.Position;
      SetLength(sBuffer, ContentStream.Size - CurrentPosition);
      ContentStream.Read(sBuffer[1], ContentStream.Size - CurrentPosition);
      BytesRead := Pos(HeaderDataTerminator, sBuffer) - 1;
      sBuffer := Copy(sBuffer, 1, BytesRead);
      { sBuffer now contains the actual data }
      ContentStream.Position := CurrentPosition + BytesRead + Length(HeaderDataTerminator);

      if sBuffer <> '' then
      begin
        { If ContentType is not blank, then it is a File otherwise it is a
          Form field }
        if ContentType <> '' then
        begin
          HTTPFile := THTTPFile.Create;
          HTTPFile.FileData.Write(sBuffer[1], Length(sBuffer));
          HTTPFile.FileData.Position := 0;
          HTTPFile.ContentType := ContentType;
          HTTPFile.FieldName := FieldNameInHeader;
          HTTPFile.FileName := FileNameInHeader;
          Files.Add(HTTPFile);
        end
        else { Then this must be additional fields of the form }
          ContentFields.Add(FieldNameInHeader + '=' + sBuffer);
      end;
    end; { while (ContentStream.Position < ContentStream.Size) do }
  except
    ContentStream.Free;
  end;
end;

end.

