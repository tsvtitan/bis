unit OrdersConfig;

interface

uses Classes, IniFiles;

type
  TOrdersConfig=class(TComponent)
  private
    FConfig: TMemIniFile;
    FIsInit: Boolean;
    FFileName: string;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile;
  protected
    function GetAsText: String;
    function GetIsInit: Boolean;
    property IsInit: Boolean read GetIsInit;
  public
    procedure CreateFile(const FileName: string);
    procedure Init(const FileName: String); virtual;
    procedure Done; virtual;

    function ReadString(const Section, Ident, Default: String): String;
    function ReadInteger(const Section, Ident: String; Default: Longint): Longint;
    function ReadBool(const Section, Ident: String; Default: Boolean): Boolean;
    function ReadDate(const Section, Ident: String; Default: TDateTime): TDateTime;
    function ReadDateTime(const Section, Ident: String; Default: TDateTime): TDateTime;
    function ReadFloat(const Section, Ident: String; Default: Double): Double;
    function ReadTime(const Section, Ident: String; Default: TDateTime): TDateTime;
    procedure ReadSectionValues(const Section: string; out Strings: String);
    procedure ReadSection(const Section: string; out Strings: String);

    procedure WriteString(const Section, Ident, Value: String);
    procedure WriteInteger(const Section, Ident: String; Value: Longint);
    procedure WriteBool(const Section, Ident: String; Value: Boolean);
    procedure WriteDate(const Section, Ident: String; Value: TDateTime);
    procedure WriteDateTime(const Section, Ident: String; Value: TDateTime);
    procedure WriteFloat(const Section, Ident: String; Value: Double);
    procedure WriteTime(const Section, Ident: String; Value: TDateTime);

    procedure EraseSection(const Section: String); 
    procedure UpdateFile; 

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property FileName: String read FFileName;
  end;

implementation

uses SysUtils, OrdersDialogs, OrdersConsts;

{ TOrdersConfig }

constructor TOrdersConfig.Create(AOwner: TComponent); 
begin
  Inherited Create(AOwner);
  FConfig:=TMemIniFile.Create('');
end;

destructor TOrdersConfig.Destroy;
begin
  Done;
  FConfig.Free;
  Inherited Destroy;
end;

function TOrdersConfig.ReadString(const Section, Ident, Default: String): String; 
begin
  Result:=FConfig.ReadString(Section,Ident,Default);
end;

function TOrdersConfig.ReadInteger(const Section, Ident: String; Default: Longint): Longint; 
begin
  Result:=FConfig.ReadInteger(Section,Ident,Default);
end;

function TOrdersConfig.ReadBool(const Section, Ident: String; Default: Boolean): Boolean; 
begin
  Result:=FConfig.ReadBool(Section,Ident,Default);
end;

function TOrdersConfig.ReadDate(const Section, Ident: String; Default: TDateTime): TDateTime; 
begin
  Result:=FConfig.ReadDate(Section,Ident,Default);
end;

function TOrdersConfig.ReadDateTime(const Section, Ident: String; Default: TDateTime): TDateTime; 
begin
  Result:=FConfig.ReadDateTime(Section,Ident,Default);
end;

function TOrdersConfig.ReadFloat(const Section, Ident: String; Default: Double): Double; 
begin
  Result:=FConfig.ReadFloat(Section,Ident,Default);
end;

function TOrdersConfig.ReadTime(const Section, Ident: String; Default: TDateTime): TDateTime; 
begin
  Result:=FConfig.ReadTime(Section,Ident,Default);
end;

procedure TOrdersConfig.ReadSectionValues(const Section: string; out Strings: String);
var
  List: TStringList; 
begin
  List:=TStringList.Create;
  try
    FConfig.ReadSectionValues(Section,List);
    Strings:=List.Text;   
  finally
    List.Free;
  end;  
end;

procedure TOrdersConfig.ReadSection(const Section: string; out Strings: String); 
var
  List: TStringList; 
begin
  List:=TStringList.Create;
  try
    FConfig.ReadSection(Section,List);
    Strings:=List.Text;   
  finally
    List.Free;
  end;  
end;

procedure TOrdersConfig.WriteString(const Section, Ident, Value: String); 
begin
  FConfig.WriteString(Section,Ident,Value);
end;

procedure TOrdersConfig.WriteInteger(const Section, Ident: String; Value: Longint); 
begin
  FConfig.WriteInteger(Section,Ident,Value);
end;

procedure TOrdersConfig.WriteBool(const Section, Ident: String; Value: Boolean); 
begin
  FConfig.WriteBool(Section,Ident,Value);
end;

procedure TOrdersConfig.WriteDate(const Section, Ident: String; Value: TDateTime); 
begin
  FConfig.WriteDate(Section,Ident,Value);
end;

procedure TOrdersConfig.WriteDateTime(const Section, Ident: String; Value: TDateTime); 
begin
  FConfig.WriteDateTime(Section,Ident,Value);
end;

procedure TOrdersConfig.WriteFloat(const Section, Ident: String; Value: Double); 
begin
  FConfig.WriteFloat(Section,Ident,Value);
end;

procedure TOrdersConfig.WriteTime(const Section, Ident: String; Value: TDateTime); 
begin
  FConfig.WriteTime(Section,Ident,Value);
end;

procedure TOrdersConfig.CreateFile(const FileName: string);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
    fs:=TFileStream.Create(FileName,fmCreate);
    FFileName:=FileName;
  finally
    fs.Free;
  end;
end;

procedure TOrdersConfig.Init(const FileName: String); 
var
  fs: TFileStream;
begin
  if not FIsInit then begin
    fs:=nil;
    try
      try
        fs:=TFileStream.Create(FileName,fmOpenRead);
        LoadFromStream(fs);
        FFileName:=FileName;
        FIsInit:=true;
      except
        on E: Exception do begin
          raise;
        end;  
      end;  
    finally
      fs.Free;
    end;
  end;  
end;

procedure TOrdersConfig.Done; 
begin
  if FIsInit then begin
    FIsInit:=false;
    SaveToFile;
    FConfig.Clear;
  end;  
end;

procedure TOrdersConfig.SaveToFile;
var
  List: TStringList;
begin
  List:=TStringList.Create;
  try
    FConfig.GetStrings(List);
    List.SaveToFile(FFileName);
  finally
    List.Free;
  end;
end;

procedure TOrdersConfig.LoadFromStream(Stream: TStream);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.LoadFromStream(Stream);
    FConfig.SetStrings(List);
  finally
    List.Free;
  end;
end;

function TOrdersConfig.GetAsText: String;
var
  List: TStringList;
begin
  List:=TStringList.Create;
  try
    FConfig.GetStrings(List);
    Result:=Trim(List.Text);
  finally
    List.Free;
  end;
end;

function TOrdersConfig.GetIsInit: Boolean; 
begin
  Result:=FIsInit;
end;

procedure TOrdersConfig.UpdateFile; 
begin
  SaveToFile;
end;

procedure TOrdersConfig.EraseSection(const Section: String); 
begin
  FConfig.EraseSection(Section);
end;


end.