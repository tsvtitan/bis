unit BisConfig;

interface

uses Classes, IniFiles,
     BisObject, BisCmdLine;

type

  TBisConfigMode=(cmDefault,cmBase64);

  TBisConfig=class(TBisObject)
  private
    FIniFile: TMemIniFile;
    FFileName: String;
    FCmdLine: TBisCmdLine;
    function GetAsText: String;
    procedure SetAsText(Value: String);
  public
    constructor Create(AOwner: Tcomponent); override;
    destructor Destroy; override;
    
    procedure Init; override;
    procedure Load; virtual;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);
    procedure UpdateFile;
    procedure LoadFromString(const S: String);
    procedure Write(const Section,Param: String; Value: Variant; Mode: TBisConfigMode=cmDefault);
    function Read(const Section,Param: String; Default: Variant; Mode: TBisConfigMode=cmDefault): Variant;
    procedure ReadSection(const Section: String; Strings: TStrings);
    procedure ReadSectionValues(const Section: String; Strings: TStrings);
    procedure AddSectionText(const SectionName, SectionText: String);
    function Exists(const Section,Param: String): Boolean;

    property Text: String read GetAsText write SetAsText;
    property FileName: String read FFileName write FFileName;
    property CmdLine: TBisCmdLine read FCmdLine write FCmdLine;
    property IniFile: TMemIniFile read FIniFile write FIniFile;
  end;

implementation

uses SysUtils, Variants, TypInfo,
     BisBase64, BisUtils, BisConsts, BisDialogs;

{ TBisConfig }

constructor TBisConfig.Create(AOwner: Tcomponent);
begin
  inherited Create(AOwner);
  FIniFile:=TMemIniFile.Create('');
end;

destructor TBisConfig.Destroy;
begin
  FreeAndNilEx(FIniFile);
  inherited Destroy;
end;

procedure TBisConfig.Init;
var
  Exists: Boolean;
  S: String;
begin
  inherited Init;
  if Assigned(FCmdLine) then begin
    S:=PrepareFileName(FCmdLine,ChangeFileExt(FCmdLine.FileName,SIniExtension),SCmdParamConfig,Exists);
    if not FileExists(S) then
      S:=ExpandFileNameEx(FFileName);
    FFileName:=S;
  end;
end;

procedure TBisConfig.Load;
begin
  if Assigned(FCmdLine) then
    if FileExists(FFileName) then
      LoadFromFile(FFileName);
end;

procedure TBisConfig.LoadFromStream(Stream: TStream);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.LoadFromStream(Stream);
    FIniFile.SetStrings(List);
  finally
    List.Free;
  end;
end;

procedure TBisConfig.SaveToStream(Stream: TStream);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    FIniFile.GetStrings(List);
    List.SaveToStream(Stream);
  finally
    List.Free;
  end;
end;

procedure TBisConfig.LoadFromFile(const FileName: string);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
    fs:=TFileStream.Create(FileName,fmOpenRead);
    LoadFromStream(fs);
    FFileName:=FileName;
  finally
    fs.Free;
  end;
end;

procedure TBisConfig.SaveToFile(const FileName: string);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
    fs:=TFileStream.Create(FileName,fmCreate);
    SaveToStream(fs);
  finally
    fs.Free;
  end;
end;

procedure TBisConfig.Write(const Section,Param: String; Value: Variant; Mode: TBisConfigMode=cmDefault);
begin
  case VarType(Value) of
     varSmallint, varInteger, varShortInt, varByte, varWord, varLongWord, varInt64: begin
       FIniFile.WriteInteger(Section,Param,Value);
     end;
     varOleStr, varStrArg, varString: begin
       case Mode of
         cmDefault: FIniFile.WriteString(Section,Param,Value);
         cmBase64: FIniFile.WriteString(Section,Param,StrToBase64(Value));
       end;
     end;
     varBoolean: begin
       FIniFile.WriteBool(Section,Param,Value);
     end;
     varSingle, varDouble, varCurrency: begin
       FIniFile.WriteFloat(Section,Param,Value);
     end;
     varDate: begin
       FIniFile.WriteDateTime(Section,Param,Value);
     end;
  else
    case Mode of
      cmDefault: FIniFile.WriteString(Section,Param,VarToStrDef(Value,''));
      cmBase64: FIniFile.WriteString(Section,Param,StrToBase64(VarToStrDef(Value,''))); 
    end;
  end;
end;

function TBisConfig.Read(const Section,Param: String; Default: Variant; Mode: TBisConfigMode=cmDefault): Variant;
var
  V: Word;
  S: String;
begin
  V:=VarType(Default);
  case V of
     varSmallint, varInteger, varShortInt, varByte, varWord, varLongWord, varInt64: begin
       Result:=FIniFile.ReadInteger(Section,Param,Default);
     end;
     varOleStr, varStrArg, varString: begin
       case Mode of
         cmDefault: Result:=FIniFile.ReadString(Section,Param,Default);
         cmBase64: Result:=Base64ToStr(FIniFile.ReadString(Section,Param,StrToBase64(Default)));
       end;
     end;
     varBoolean: begin
       Result:=FIniFile.ReadBool(Section,Param,Default);
     end;
     varSingle, varDouble, varCurrency: begin
       Result:=FIniFile.ReadFloat(Section,Param,Default);
     end;
     varDate: begin
       Result:=FIniFile.ReadDateTime(Section,Param,Default);
     end;
  else
    S:=FIniFile.ReadString(Section,Param,VarToStrDef(Default,''));
    case Mode of
      cmDefault: Result:=S;
      cmBase64: Result:=Base64ToStr(S);
    end;
  end;
end;

function TBisConfig.Exists(const Section, Param: String): Boolean;
begin
  Result:=FIniFile.SectionExists(Section);
  if Result then
    FIniFile.ValueExists(Section,Param);
end;

procedure TBisConfig.ReadSection(const Section: String; Strings: TStrings);
begin
  FIniFile.ReadSection(Section,Strings);
end;

procedure TBisConfig.ReadSectionValues(const Section: String; Strings: TStrings);
begin
  FIniFile.ReadSectionValues(Section,Strings);
end;

procedure TBisConfig.UpdateFile;
begin
  SaveToFile(FFileName);
end;

procedure TBisConfig.LoadFromString(const S: String);
var
  Stream: TStringStream;
begin
  Stream:=TStringStream.Create(S);
  try
    Stream.Position:=0;
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

function TBisConfig.GetAsText: String;
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    FIniFile.GetStrings(List);
    Result:=List.Text;
  finally
    List.Free;
  end;
end;

procedure TBisConfig.SetAsText(Value: String);
var
  List: TStringList;
begin
  List:=TStringList.Create;
  try
    List.Text:=Value;
    FIniFile.SetStrings(List);
  finally
    List.Free;
  end;
end;

procedure TBisConfig.AddSectionText(const SectionName, SectionText: String);
var
  List: TStringList;
begin
  List:=TStringList.Create;
  try
    List.Text:=SectionText;
    List.Insert(0,'['+SectionName+']');
    FIniFile.SetStrings(List);
  finally
    List.Free;
  end;
end;

end.