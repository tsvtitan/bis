unit ftpobjunit;

interface

uses idftp, classes, sysutils, idcomponent, IdLogDebug;

type
  TFtpClientObject = class
  private
    idFtp1: TIDFtp;
    IdLogDebug: TIdLogDebug;
    AbortTransfer: Boolean;
    TransferringData: Boolean;
    BytesToTransfer: LongWord;
    AverageSpeed: Double;
    STime: TDateTime;
    ContatoreFind: integer;
    procedure IdFTP1Status(axSender: TObject; const axStatus: TIdStatus;
      const asStatusText: string);
    procedure IdFTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdFTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure IdFTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    function GetNameFromLine(Line: string; var IsDirectory: Boolean): string;
    procedure IdFTP1Disconnected(Sender: TObject);
    procedure IdFTP1Connected(Sender: TObject);
    procedure CutFirstWord(var Stringa: string);
    procedure WordPos(Stringa: string; var Position, Size: integer);
    function GetSizeFromLine(Line: string): integer;
    procedure IdLogDebug1LogItem(ASender: TComponent; var AText: string);
    function GetLogTarget: TIdLogDebugTarget;
    procedure SetLogTarget(Value: TIdLogDebugTarget);
    function GetLogFile: string;
    procedure SetLogFile(Value: string);
  public
    Host, Username, Password, DefaultDir, CurrentDir, Status: string;
    MaskPassword: Boolean;
    DirectoryFilter, LastError, LastResponse: string;
    DirectoryList: TStringList;
    procedure Execute(Cmd: string; out rets: integer);
    function GetFileProperties(Filename: string; var IsDirectory: Boolean; var Size: Integer): string;
    function DeleteFile(Name: string): string;
    function RemoveDir(Name: string): string;
    function Download(SourceFile, DestFile: string): string;
    function Upload(SourceFile, DestFile: string): string;
    function Connect: string;
    function DisConnect: string;
    function ChangeDir(Dirname: string): string;
    function MakeDir(Name: string): string;
    function FindFirst(Specifier: string; var Filename: string; var IsDirectory: Boolean; var Size: integer): string;
    function FindNext(var FileName: string; var IsDirectory: Boolean; var Size: integer): string;
    function FindClose: string;
    procedure Abort;
    constructor Create;
    destructor Destroy; override;
    property LogType: TIdLogDebugTarget read GetLogTarget write SetLogTarget;
    property LogFile: string read GetLogFile write SetLogFile;
  end;

implementation

uses
  Dialogs;

function TFtpClientObject.GetLogFile: string;
begin
  result := idlogdebug.Filename;
end;

procedure TFtpClientObject.SetLogFile(Value: string);
begin
  if Value <> '' then
  begin
    idlogdebug.Filename := Value;
    idlogdebug.Target := ltFile;
  end;
end;

function TFtpClientObject.GetLogTarget: TIdLogDebugTarget;
begin
  result := idlogdebug.Target;
end;

procedure TFtpClientObject.SetLogTarget(Value: TIdLogDebugTarget);
begin
  idlogdebug.Target := Value;
end;

procedure TFtpClientObject.IdLogDebug1LogItem(ASender: TComponent;
  var AText: string);
var
  inizio: integer;
const
  INVIO_PWD = 'Sent: pass ';
begin
  if MaskPassword then
  begin
    Inizio := Pos(INVIO_PWD, AText);
    if Inizio > 0 then
    begin
      Atext := Copy(AText, 0, Inizio - 1) + INVIO_PWD + '*****<EOL>';
    end;
  end;
  LastResponse := AText;
end;

procedure TFtpClientObject.Execute(Cmd: string; out rets: integer);
begin
  rets := idftp1.SendCmd(cmd);
end;

procedure TFtpClientObject.CutFirstWord(var Stringa: string);
var
  x, s: integer;
begin
  WordPos(Stringa, x, s);
  Stringa := Trim(Copy(Stringa, x + s, Length(Stringa)));
end;

procedure TFtpClientObject.WordPos(Stringa: string; var Position, Size: integer);
var
  Str: string;
begin
  position := 1;
  Str := Stringa;

  while Str[1] = ' ' do
  begin
    System.Delete(str, 1, 1);
    Inc(Position);
  end;

  Size := Pos(' ', Str) - 1;
end;

procedure TFtpClientObject.IdFTP1Status(axSender: TObject; const axStatus: TIdStatus;
  const asStatusText: string);
begin
  Status := asStatusText;
end;

procedure TFtpClientObject.IdFTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
  TransferringData := true;
  AbortTransfer := false;
  STime := Now;
  AverageSpeed := 0;
end;

procedure TFtpClientObject.IdFTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  Status := 'Transfer complete.';
  BytesToTransfer := 0;
  TransferringData := false;
  AverageSpeed := 0;
end;

procedure TFtpClientObject.IdFTP1Disconnected(Sender: TObject);
begin
  Status := 'Disconnected.';
end;

procedure TFtpClientObject.IdFTP1Connected(Sender: TObject);
begin
  Status := 'Connected.';
end;

procedure TFtpClientObject.IdFTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
var
  S: string;
  TotalTime: TDateTime;
  H, M, Sec, MS: Word;
  DLTime: Double;
begin
  TotalTime := Now - STime;
  DecodeTime(TotalTime, H, M, Sec, MS);
  Sec := Sec + M * 60 + H * 3600;
  DLTime := Sec + MS / 1000;
  if DLTime > 0 then
    AverageSpeed := {(AverageSpeed + }(AWorkCount / 1024) / DLTime {) / 2};

  S := FormatFloat('0.00 KB/s', AverageSpeed);
  case AWorkMode of
    wmRead: status := 'Download speed ' + S;
    wmWrite: status := 'Upload speed ' + S;
  end;

  if AbortTransfer then
    IdFTP1.Abort;

  AbortTransfer := false;
end;

function TFtpClientObject.GetSizeFromLine(Line: string): integer;
var
  str: string;
  x, s: integer;
begin
  CutFirstWord(Line);
  CutFirstWord(Line);

  WordPos(Line, x, s);
  str := Copy(Line, x, s);
  try
    Result := StrToInt(str);
  except
    Result := -1;
  end;
end;

function TFtpClientObject.GetFileProperties(Filename: string; var IsDirectory: Boolean; var Size: Integer): string;
var
  i: Integer;
  strName, Line: string;
  IsDir, FileExists: Boolean;
begin
  Size := 0;
  IsDirectory := false;
  FileExists := False;

  for i := 0 to DirectoryList.Count - 1 do
  begin
    Line := DirectoryList[i];
    StrName := GetNameFromLine(Line, IsDir);
    if strName = FileName then
    begin
      FileExists := true;
      Size := GetSizeFromLine(Line);
      IsDirectory := isdir;
    end;
  end;

  if FileExists then
    Result := ''
  else
    Result := 'File does not exists';

  LastError := Result;
end;

function TFtpClientObject.GetNameFromLine(Line: string; var IsDirectory: Boolean): string;
var
  i: Integer;
  DosListing: Boolean;
begin
  IsDirectory := Line[1] = 'd';
  DosListing := false;
  for i := 0 to 7 do
  begin
    if (i = 2) and not IsDirectory then
    begin
      IsDirectory := Copy(Line, 1, Pos(' ', Line) - 1) = '<DIR>';
      if not IsDirectory then
        DosListing := Line[1] in ['0'..'9']
      else
        DosListing := true;
    end;
    System.Delete(Line, 1, Pos(' ', Line));
    while Line[1] = ' ' do
      System.Delete(Line, 1, 1);
    if DosListing and (i = 2) then
      break;
  end;
  Result := Line;
end;

constructor TFtpClientObject.Create;
begin
  inherited Create;
  maskPassword := True;
  idFTP1 := TIdFtp.Create(nil);
  idftp1.Name := 'myidftp';
  DefaultDir := '/';
  AverageSpeed := 0;
  AbortTransfer := False;
  TransferringData := False;
  BytesToTransfer := 0;

  DirectoryList := TStringList.Create;
  DirectoryFilter := '';

  idftp1.OnDisconnected := IdFTP1Disconnected;
  idftp1.OnConnected := IdFTP1Connected;
  idftp1.OnStatus := IdFTP1Status;
  idftp1.OnWork := IdFTP1Work;
  idftp1.OnWorkEnd := IdFTP1WorkEnd;
  idftp1.OnWorkBegin := IdFTP1WorkBegin;

  IdLogDebug := TIdLogDebug.Create(nil);
  IdLogdebug.OnLogItem := IdLogDebug1LogItem;
  idftp1.Intercept := IdLogDebug;
  idftp1.InterceptEnabled := true;
  IdLogDebug.Target := ltDebugOutput;
end;

destructor TFtpClientObject.Destroy;
begin
  idlogdebug.Free;
  DirectoryList.Clear;
  DirectoryList.Free;
  idFtp1.Free;
  inherited Destroy;
end;

function TFtpClientObject.Connect: string;
begin
  IdLogDebug.Active := true;
  try
    if IdFTP1.Connected then
    begin
      if TransferringData then
        IdFTP1.Abort;
      IdFTP1.Quit;
    end
    else
    begin
      IdFTP1.User := Self.UserName;
      IdFTP1.Password := Self.Password;
      IdFTP1.Host := Self.Host;
      IdFTP1.Connect;
      ChangeDir(DefaultDir);
    end;
  except
    on e: exception do
    begin
      Result := e.message;
    end;
  end;

  LastError := Result;
end;

function TFtpClientObject.DisConnect: string;
begin
  try
    if IdFTP1.Connected then
    begin
      if TransferringData then
        IdFTP1.Abort;
      IdFTP1.Quit;
      idftp1.Disconnect
    end;
  except
    on e: exception do
    begin
      Result := e.message;
    end;
  end;
  LastError := Result;
end;

function TFtpClientObject.ChangeDir(DirName: string): string;
begin
  try
    IdFTP1.ChangeDir(DirName);
    IdFTP1.TransferType := ftASCII;
    CurrentDir := IdFTP1.RetrieveCurrentDir;
    IdFTP1.List(DirectoryList, DirectoryFilter);
  except
    on e: exception do
    begin
      Result := e.message;
    end;
  end;
  LastError := Result;
end;

function TFtpClientObject.Download(SourceFile, DestFile: string): string;
begin
  if not IdFTP1.Connected then
  begin
    Result := 'not connected';
    LastError := Result;
    exit;
  end;

  try
    IdFTP1.TransferType := ftBinary;
    BytesToTransfer := IdFTP1.Size(SourceFile);
    IdFTP1.Get(SourceFile, DestFile, true);
  except
    on e: exception do
    begin
      Result := e.message;
    end;
  end;
  LastError := Result;
end;

function TFtpClientObject.Upload(SourceFile, DestFile: string): string;
var
  Done: boolean;
  RetryNumber: integer;
begin
  if not IdFTP1.Connected then
  begin
    Result := 'not connected';
    LastError := Result;
    exit;
  end;

  RetryNumber := 5;
  Done := False;
  try
    IdFTP1.TransferType := ftBinary;
    while not Done do
    try
      IdFTP1.Put(SourceFile, DestFile);
      Done := True;
    except
      Sleep(1000);
      Dec(RetryNumber);
      if RetryNumber = 0 then
        raise;
    end;
    ChangeDir(idftp1.RetrieveCurrentDir);
  except
    on e: exception do
    begin
      Result := e.message;
    end;
  end;
  LastError := Result;
end;

function TFtpClientObject.RemoveDir(name: string): string;
begin
  if not IdFTP1.Connected then
  begin
    Result := 'not connected';
    LastError := Result;
    exit;
  end;

  try
    idftp1.RemoveDir(Name);
    ChangeDir(idftp1.RetrieveCurrentDir);
  except
    on e: exception do
    begin
      Result := e.message;
    end;
  end;
  LastError := Result;
end;

function TFtpClientObject.MakeDir(name: string): string;
begin
  if not IdFTP1.Connected then
  begin
    Result := 'not connected';
    LastError := Result;
    exit;
  end;

  try
    IdFTP1.MakeDir(Name);
    ChangeDir(idftp1.RetrieveCurrentDir);
  except
    on e: exception do
    begin
      Result := e.message;
      LastError := Result;
    end;
  end;
end;

function TFtpClientObject.DeleteFile(name: string): string;
begin
  if not IdFTP1.Connected then
  begin
    Result := 'not connected';
    LastError := Result;
    exit;
  end;

  try
    idftp1.Delete(Name);
    // se il filtro è attivo, non è il caso di rifare il dir
    if DirectoryFilter = '' then
      ChangeDir(idftp1.RetrieveCurrentDir);
  except
    on e: exception do
    begin
      Result := e.message;
    end;
  end;
  LastError := Result;
end;

procedure TFtpClientObject.Abort;
begin
  AbortTransfer := true;
end;

function TFtpClientObject.FindFirst(Specifier: string; var Filename: string; var IsDirectory: Boolean; var Size: integer): string;
var
  Line: string;
begin
  Size := 0;
  IsDirectory := false;
  ContatoreFind := 0;

  DirectoryFilter := Specifier;
  idFtp1.List(DirectoryList, DirectoryFilter);

  if ContatoreFind >= DirectoryList.Count then
  begin
    FileName := '';
    IsDirectory := false;
    Size := 0;
    Exit;
  end;

  Line := DirectoryList[ContatoreFind];
  FileName := GetNameFromLine(Line, IsDirectory);
  Size := GetSizeFromLine(Line);
end;

function TFtpClientObject.FindNext(var FileName: string; var IsDirectory: Boolean; var Size: integer): string;
var
  Line: string;
begin
  Inc(ContatoreFind);

  if ContatoreFind >= DirectoryList.Count then
  begin
    FileName := '';
    IsDirectory := false;
    Size := 0;
    Exit;
  end;

  Line := DirectoryList[ContatoreFind];
  FileName := GetNameFromLine(Line, IsDirectory);
  Size := GetSizeFromLine(Line);
end;

function TFtpClientObject.FindClose: string;
begin
  DirectoryFilter := '';
  idFtp1.List(DirectoryList, DirectoryFilter);
  ContatoreFind := 0;
end;

end.

