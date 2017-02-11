unit dws2MFLoader;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  dws2Comp, dws2Exprs;

type
  Tdws2MFLoader = class(TComponent)
  private
    FAutomaticEncrypt: Boolean;
    FCheckSourceDate: Boolean;
    FEncryptedExtension: String;
    FFileName: String;
    FPrimaryKey: Word;
    FSecondaryKey: Word;
    FStartKey: Word;
    FScript: TDelphiWebScriptII;
    FSource: TStringList;
    FSourceExtension: String;
    function AutoEncrypt: Boolean;
    function Encrypt(Source: TStringList; FileName: String): Boolean;
    function LoadEncrypted(FileName: String): Boolean;
    function LoadSource(FileName: String): Boolean;
    procedure SetScript(const Value: TDelphiWebScriptII);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function EncryptFile(FileName: String): Boolean;
    function Load(FileName: String): Boolean;
    property FileName: String read FFileName;
    property Source: TStringList read FSource;
  published
    property AutomaticEncrypt: Boolean read FAutomaticEncrypt write FAutomaticEncrypt default False;
    property CheckSourceDate: Boolean read FCheckSourceDate write FCheckSourceDate default False;
    property EncryptedExtension: String read FEncryptedExtension write FEncryptedExtension;
    property PrimaryKey: Word read FPrimaryKey write FPrimaryKey;
    property SecondaryKey: Word read FSecondaryKey write FSecondaryKey;
    property StartKey: Word read FStartKey write FStartKey;
    property Script: TDelphiWebScriptII read FScript write SetScript;
    property SourceExtension: String read FSourceExtension write FSourceExtension;
  end;

procedure Register;

implementation

uses
  dws2MFLibFuncs;

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2MFLoader]);
end;

constructor Tdws2MFLoader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutomaticEncrypt := False;
  FCheckSourceDate := False;
  FEncryptedExtension := '.dwe';
  FFileName := '';
  FPrimaryKey := 0;
  FSecondaryKey := 0;
  FScript := nil;
  FSourceExtension := '.dws';
  FSource := TStringList.Create;
end;

destructor Tdws2MFLoader.Destroy;
begin
  FSource.Free;
  inherited Destroy;
end;

function Tdws2MFLoader.AutoEncrypt: Boolean;
var
  SrcFile,
  EncFile : String;
begin
  Result := False;
  if not FAutomaticEncrypt then
    Exit;
  if ( FFileName = '' ) or ( FSource.Count = 0 ) or ( FEncryptedExtension = '' ) then
    Exit;
  SrcFile := ChangeFileExt( FFileName, FSourceExtension );
  if not FileExists( SrcFile ) then
    Exit;
  EncFile := ChangeFileExt( FFileName, FEncryptedExtension );
  if not FileExists( EncFile ) or
     ( FCheckSourceDate and
       ( FileDate( SrcFile, FILEDATE_LASTWRITE ) >
         FileDate( EncFile, FILEDATE_LASTWRITE ) ) ) then
    Result := Encrypt( FSource, EncFile );
end;

function Tdws2MFLoader.Encrypt(Source: TStringList; FileName: String): Boolean;
var
  FS : TFileStream;
  S : String;
  Buf : PChar;
  Key : Word;
  B : Byte;
//  p,
  i : Integer;
begin
  Result := False;
  if ( FileName = '' ) or ( Source.Count = 0 ) or ( FEncryptedExtension = '' ) then
    Exit;
  try
    S := '';
    for i := 0 to Source.Count - 1 do
    begin
      S := Source[i];
//      p := Pos( '//', S );
//      if p > 0 then
//        Delete( S, p, Length( S ) - p + 1 );
      Source[i] := Trim( S );
    end;
    S := Source.Text;
    Buf := AllocMem( Length( S ) );
    try
      Key := FStartKey;
      for i := 1 to Length( S ) do
      begin
        B := Byte( S[i] ) xor ( Key shr 8 );
        Buf[i - 1] := Char( B );
        Key := ( B + Key ) * FPrimaryKey + FSecondaryKey;
      end;
      FS := TFileStream.Create( ChangeFileExt( Filename, FEncryptedExtension ),
        fmCreate or fmShareExclusive );
      try
        FS.WriteBuffer( Buf^, Length( S ) );
        Result := True;
      finally
        FS.Free;
      end;
    finally
      FreeMem( Buf );
    end;
  except
    ;
  end;
end;

function Tdws2MFLoader.EncryptFile(FileName: String): Boolean;
var
  SL : TStringList;
begin
  Result := False;
  FileName := ChangeFileExt( FileName, FSourceExtension );
  if not FileExists( FileName ) or ( FEncryptedExtension = '' ) then
    Exit;
  try
    SL := TStringList.Create;
    try
      SL.LoadFromFile( FileName );
      Result := Encrypt( SL, FileName );
    finally
      SL.Free;
    end;
  except
    ;
  end;
end;

function Tdws2MFLoader.Load(FileName: String): Boolean;
var
  SrcFile,
  EncFile,
  Ext : String;
begin
  Result := False;
  FSource.Clear;
  FFileName := '';
  Ext := ExtractFileExt( FileName );
  if Ext = '' then
  begin
    SrcFile := ChangeFileExt( FileName, FSourceExtension );
    EncFile := ChangeFileExt( FileName, FEncryptedExtension );
    if not FileExists( EncFile ) then
    begin
      if LoadSource( SrcFile ) then
      begin
        AutoEncrypt;
        Result := True;
      end;
    end
    else if not FileExists( SrcFile ) or not FCheckSourceDate then
      Result := LoadEncrypted( EncFile )
    else
    begin
      if FileDate( SrcFile, FILEDATE_LASTWRITE ) >
         FileDate( EncFile, FILEDATE_LASTWRITE ) then
      begin
        if LoadSource( SrcFile ) then
        begin
          AutoEncrypt;
          Result := True;
        end;
      end
      else
        Result := LoadEncrypted( EncFile )
    end;
  end
  else if AnsiCompareText( Ext, FSourceExtension ) = 0 then
  begin
    if LoadSource( FileName ) then
    begin
      AutoEncrypt;
      Result := True;
    end;
  end
  else if AnsiCompareText( Ext, FEncryptedExtension ) = 0 then
    Result := LoadEncrypted( FileName );
end;

function Tdws2MFLoader.LoadEncrypted(FileName: String): Boolean;
var
  FS : TFileStream;
  S : String;
  Buf : PChar;
  Key : Word;
  B : Byte;
  i : Integer;
begin
  Result := False;
  try
    if FileExists( FileName ) then
    begin
      FS := TFileStream.Create( FileName, fmOpenRead or fmShareDenyNone );
      try
        Buf := AllocMem( FS.Size );
        try
          FS.ReadBuffer( Buf^, FS.Size );
          S := '';
          Key := FStartKey;
          for i := 0 to FS.Size - 1 do
          begin
            B := Byte( Buf[i] );
            S := S + Char( B xor ( Key shr 8 ) );
            Key := ( B + Key ) * FPrimaryKey + FSecondaryKey;
          end;
          FSource.Add( S );
          FFileName := ChangeFileExt( FileName, '' );
          Result := True;
        finally
          FreeMem( Buf );
        end;
      finally
        FS.Free;
      end;
    end;
  except
    ;
  end;
end;

function Tdws2MFLoader.LoadSource(FileName: String): Boolean;
begin
  Result := False;
  try
    if FileExists( FileName ) then
    begin
      FSource.LoadFromFile( FileName );
      FFileName := ChangeFileExt( FileName, '' );
      Result := True;
    end;
  except
    ;
  end;
end;

procedure Tdws2MFLoader.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Script) then
    SetScript(nil)
end;

procedure Tdws2MFLoader.SetScript(const Value: TDelphiWebScriptII);
begin
  if Assigned(FScript) then
    FScript.RemoveFreeNotification(Self);
  if Assigned(Value) then
    Value.FreeNotification(Self);
  FScript := Value;
end;

end.
