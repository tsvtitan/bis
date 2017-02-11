{**********************************************************************}
{                                                                      }
{    dws2MFLib                                                         }
{                                                                      }
{    A function library for DWSII                                      }
{    Version 1.0 Beta                                                  }
{    July 2001                                                         }
{                                                                      }
{    This software is distributed on an "AS IS" basis,                 }
{    WITHOUT WARRANTY OF ANY KIND, either express or implied.          }
{                                                                      }
{    The Initial Developer of the Original Code is Manfred Fuchs       }
{    Portions created by Manfred Fuchs are Copyright                   }
{    (C) 2001 Manfred Fuchs, Germany. All Rights Reserved.             }
{                                                                      }
{**********************************************************************}

unit dws2MFLibFuncs;

interface

uses
  Windows, SysUtils, Controls, Forms, StdCtrls, Buttons, Classes, ShellApi,
  Dialogs, CommDlg, TLHelp32, Messages, MMSystem;

const
  SK_None = 0;
  SK_WindowNotFound = 1;
  SK_WindowNotActive = 2;

  RAS_MaxDeviceType = 16;
  RAS_MaxDeviceName = 128;
  RAS_MaxEntryName = 256;

  FILEDATE_CREATION = 1;
  FILEDATE_LASTACCESS = 2;
  FILEDATE_LASTWRITE = 3;

  VER_UNKNOWN = $0000;
  VER_WIN32S = $0001;
  VER_WIN95 = $1000;
  VER_WIN98 = $1010;
  VER_WIN98SE = $1030;
  VER_WINME = $1070;
  VER_WINNT = $2000;
  VER_WINNT4 = $2010;
  VER_WIN2000 = $2030;
  VER_WIN32 = $3000;

type
  TOpenFileNameEx = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HINST;
    lpstrFilter: PAnsiChar;
    lpstrCustomFilter: PAnsiChar;
    nMaxCustFilter: DWORD;
    nFilterIndex: DWORD;
    lpstrFile: PAnsiChar;
    nMaxFile: DWORD;
    lpstrFileTitle: PAnsiChar;
    nMaxFileTitle: DWORD;
    lpstrInitialDir: PAnsiChar;
    lpstrTitle: PAnsiChar;
    Flags: DWORD;
    nFileOffset: Word;
    nFileExtension: Word;
    lpstrDefExt: PAnsiChar;
    lCustData: LPARAM;
    lpfnHook: function(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): UINT
      stdcall;
    lpTemplateName: PAnsiChar;
    pvReserved: Pointer;
    dwReserved: DWORD;
    FlagsEx: DWORD;
  end;

  TExtOpenDialog = class(TOpenDialog)
  protected
    FInterceptor: Pointer;
    function IsWin2000orME: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean; override;
  end;

  TExtSaveDialog = class(TExtOpenDialog)
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean; override;
  end;

  PWinRec = ^TWinRec;
  TWinRec = record
    ClassName: string;
    WindowName: string;
    ProcID: DWord;
    Handle: HWnd;
    Child: HWnd;
    Num: Integer;
  end;
  TRasConn = record
    Size: DWORD;
    Handle: THandle;
    EntryName: array[0..RAS_MaxEntryName] of Char;
    DeviceType: array[0..RAS_MaxDeviceType] of Char;
    DeviceName: array[0..RAS_MaxDeviceName] of Char;
  end;
  TRasEnumConnections = function(RasConn: Pointer; var cb: DWORD;
    var Connections: DWORD): DWORD; stdcall;

function DescListCreate(verz: string): TStringList;
function DescListRead(list: TStringList; dat: string): string;
function DescRead(dat: string): string;
function DescWrite(dat, desc: string): Boolean;

function DirectoryExists(const Name: string): Boolean;
function FileDate(const FileName: string; Flag: Integer): TDateTime;
function FileSize(const FileName: string): Int64;
function MakePath(const Drive, Dir, Name, Ext: string): string;
function ReadOnlyPath(const Path: string): Boolean;
procedure SplitPath(const Path: string; var Drive, Dir, Name, Ext: string);
function SubdirectoryExists(const Dir: string): Boolean;
function ScanForFiles(Filename: string; Recurse, Hidden, IncludeFiles, IncludeDirs:
  Boolean): TStringList;

function CDClose(Drive: Integer): Boolean; overload;
function CDClose(Drive: string): Boolean; overload;
function CDOpen(Drive: Integer): Boolean; overload;
function CDOpen(Drive: string): Boolean; overload;
function DriveName(Drive: Integer): string; overload;
function DriveName(Drive: string): string; overload;
function DriveReady(Drive: Integer): Boolean; overload;
function DriveReady(Drive: string): Boolean; overload;
function DriveSerial(Drive: Integer): string; overload;
function DriveSerial(Drive: string): string; overload;
function DriveType(Drive: Integer): Integer; overload;
function DriveType(Drive: string): Integer; overload;

function GetWindowsVersion: Integer;
function IsWin2000: Boolean;
function IsWin9x: Boolean;
function IsWinNT: Boolean;
function IsWinNT4: Boolean;
function ExecAndWait(const Filename, Params, Dir: string; WindowState: Word):
  Boolean;
function GetCPUSpeed: Double;
function GetCRC32FromString(S: string): Integer;
function GetCRC32FromFile(FileName: string): Integer;

function ChangeTokenValue(str, name, value, delim: string): string;
procedure FormatColumns(sl: TStringList; delim: Char; space: string; adjust:
  Integer);
function GetStringFromList(sl: TStringList; delim: Char): string;
function GetTokenList(str, delim: string; repeater, ignorefirst, ignorelast:
  Boolean): TStringList;
function PosX(substr, s: string): Integer;

function ANSI2OEM(s: string): string;
function OEM2ANSI(s: string): string;
function Translate(s: string; tout, tin: string; fill: Char; f: Boolean): string;

function CmpWC(source, wc: string; cf: Boolean): Boolean;
function IncWC(source, wc: string; cf: Boolean; var ebene: Integer): string;
function TestWC(wc: string): Integer;

function SearchWindow(var cName, wName: string; ProcID: DWord = 0): HWnd;
function SearchWindowEx(Parent, Child: HWnd; var cName, wName: string; Num: Integer
  = 0): HWnd;
function WaitForWindow(var cName, wName: string; Timeout: DWord; ProcID: DWord =
  0): HWnd;
function WaitForWindowClose(var cName, wName: string; Timeout: DWord; ProcID: DWord
  = 0): Boolean; overload;
function WaitForWindowClose(w: HWnd; Timeout: DWord): Boolean; overload;
function WaitForWindowEnabled(var cName, wName: string; Timeout: DWord; ProcID:
  DWord = 0): Boolean; overload;
function WaitForWindowEnabled(w: HWnd; Timeout: DWord): Boolean; overload;
function WaitForWindowEx(Parent: HWnd; var cName, wName: string; Timeout: DWord;
  Num: Integer = 0): HWnd;
procedure WindowMove(w: HWnd; x, y: Integer; Abs: Boolean);
procedure WindowResize(w: HWnd; x, y: Integer; Abs: Boolean);

function SendKeysWin(w, s: string; wait: Integer = 0; back: Boolean = False):
  Integer; overload;
function SendKeysWin(w: HWnd; s: string; wait: Integer = 0; back: Boolean = False):
  Integer; overload;
procedure SendKeys(s: string; wait: Integer = 0);

function SelectStringDialog(Title: String; Strings: TStringList; Selected: Integer): Integer;

function GetOpenFileNameEx(var OpenFile: TOpenFilenameEx): Boolean; stdcall;
function GetSaveFileNameEx(var OpenFile: TOpenFilenameEx): Boolean; stdcall;

implementation

function GetOpenFileNameEx; external 'comdlg32.dll' name 'GetOpenFileNameA';
function GetSaveFileNameEx; external 'comdlg32.dll' name 'GetSaveFileNameA';

const
  BUFLEN = 65536;
{$WARNINGS OFF}
  aTableCRC32: array[0..255] of LongInt = (
    {;           $}
    $00000000, $77073096, $EE0E612C, $990951BA,
    $076DC419, $706AF48F, $E963A535, $9E6495A3,
    $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
    $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
    {;            1}
    $1DB71064, $6AB020F2, $F3B97148, $84BE41DE,
    $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
    $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
    {;            2}
    $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
    $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
    $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940,
    $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
    {;            3}
    $26D930AC, $51DE003A, $C8D75180, $BFD06116,
    $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
    $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
    $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,
    {;            4}
    $76DC4190, $01DB7106, $98D220BC, $EFD5102A,
    $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
    $7807C9A2, $0F00F934, $9609A88E, $E10E9818,
    $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
    {;            5}
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
    $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
    $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C,
    $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
    {;            6}
    $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2,
    $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
    $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
    $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
    {;            7}
    $5005713C, $270241AA, $BE0B1010, $C90C2086,
    $5768B525, $206F85B3, $B966D409, $CE61E49F,
    $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4,
    $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,
    {;            8}
    $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A,
    $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
    $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8,
    $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
    {;            9}
    $F00F9344, $8708A3D2, $1E01F268, $6906C2FE,
    $F762575D, $806567CB, $196C3671, $6E6B06E7,
    $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
    $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
    {;            A}
    $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
    $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
    $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60,
    $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
    {;            B}
    $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
    $CC0C7795, $BB0B4703, $220216B9, $5505262F,
    $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04,
    $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
    {;            C}
    $9B64C2B0, $EC63F226, $756AA39C, $026D930A,
    $9C0906A9, $EB0E363F, $72076785, $05005713,
    $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38,
    $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21,
    {;            D}
    $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E,
    $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
    $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
    $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
    {;            E}
    $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
    $A7672661, $D06016F7, $4969474D, $3E6E77DB,
    $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0,
    $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
    {;            F}
    $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6,
    $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
    $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D
    );
{$WARNINGS ON}

var
  start: string;

function OpenInterceptor(var DialogData: TOpenFileName): Boolean; stdcall;
var
  DialogDataEx: TOpenFileNameEx;
begin
  Move(DialogData, DialogDataEx, Sizeof(DialogData));
  DialogDataEx.FlagsEx := 0;
  DialogDataEx.lStructSize := Sizeof(TOpenFileNameEx);
  Result := GetOpenFileNameEx(DialogDataEx);
end;

function SaveInterceptor(var DialogData: TOpenFileName): Boolean; stdcall;
var
  DialogDataEx: TOpenFileNameEx;
begin
  Move(DialogData, DialogDataEx, Sizeof(DialogData));
  DialogDataEx.FlagsEx := 0;
  DialogDataEx.lStructSize := Sizeof(TOpenFileNameEx);
  Result := GetSaveFileNameEx(DialogDataEx);
end;

constructor TExtOpenDialog.Create(AOwner: TComponent);
begin
  inherited;
  FInterceptor := @OpenInterceptor;
end;

function TExtOpenDialog.Execute: Boolean;
begin
  if IsWin2000orME then
  begin
    Result := DoExecute(FInterceptor);
  end
  else
    Result := inherited Execute;
end;

function TExtOpenDialog.IsWin2000orME: Boolean;
var
  Ver: TOSVersionInfo;
begin
  Result := False;
  Ver.dwOSVersionInfoSize := Sizeof(TOSVersionInfo);
  if not GetVersionEx(Ver) then
    Exit;
  if (Ver.dwPlatformId = VER_PLATFORM_WIN32_NT) then
  begin
    if (Ver.dwMajorVersion >= 5) then
      Result := True;
  end
  else if ((Ver.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) and
    (Ver.dwMajorVersion >= 4) and
    (Ver.dwMinorVersion >= 90)) then
    Result := True;
end;

constructor TExtSaveDialog.Create(AOwner: TComponent);
begin
  inherited;
  FInterceptor := @SaveInterceptor;
end;

function TExtSaveDialog.Execute: Boolean;
begin
  if IsWin2000orME then
    Result := inherited Execute
  else
    Result := DoExecute(@GetSaveFileName);
end;

// ****************************************************************************

function CRC32Calc(var Buf; CRC: Integer; BufSize: Integer): Integer; assembler;
asm
    push esi
    mov esi,Buf
@1:
    movzx eax,byte ptr [esi]
    inc ESI
    xor al,dl
    shr edx,8
    xor edx,dword ptr [atablecrc32+eax*4]
    Loop @1
    mov eax,edx
    pop esi
end;

function EnumWindowsProc(w: HWnd; lp: LParam): Boolean; stdcall;
var
  cn: array[0..1023] of Char;
  wn: array[0..1023] of Char;
  id: DWord;
  Found: Boolean;
  p: PWinRec;
begin
  Result := True;
  p := PWinRec(lp);

  if p^.Child <> 0 then
  begin
    if w = p^.Child then
      p^.Child := 0;
    Exit;
  end;

  wn[0] := #0;
  GetWindowText(w, wn, 1023);
  if (GetClassName(w, cn, 1023) = 0) or
    (GetWindowThreadProcessId(w, @id) = 0) then
    Exit;

  Found := True;

  if (p^.ClassName <> '') and
    not CmpWC(string(cn), p^.ClassName, True) then
    Found := False;

  if Found then
    if (p^.WindowName <> '') and
      not CmpWC(string(wn), p^.WindowName, True) then
      Found := False;

  if Found then
    if (p^.ProcID <> 0) and
      (id <> p^.ProcID) then
      Found := False;

  if Found then
  begin
    if p^.Num > 0 then
      Dec(p^.Num)
    else
    begin
      p^.Handle := w;
      p^.ClassName := string(cn);
      p^.WindowName := string(wn);
      p^.ProcID := id;
      Result := False;
    end;
  end;
end;

// ****************************************************************************

function DescListCreate(verz: string): TStringList;
var
  Pfad: string;
  Liste: TStringList;
  Laenge: Integer;
begin
  Liste := TStringList.Create;
  Pfad := verz;
  Laenge := Length(Pfad);
  if (Laenge > 0) and (Pfad[Laenge] <> ':') and (Pfad[Laenge] <> '\') then
    Pfad := Pfad + '\';
  Pfad := Pfad + 'DESCRIPT.ION';
  if FileExists(Pfad) then
    Liste.LoadFromFile(Pfad);
  Result := Liste;
end;

function DescListRead(list: TStringList; dat: string): string;
var
  Datei: string;
  Anzahl: Integer;
  Loop: Integer;
  Laenge: Integer;
begin
  Result := '';

  Anzahl := list.Count;
  if Anzahl = 0 then
    Exit
  else
  begin
    Datei := ExtractFileName(dat);
    if Pos(' ', Datei) > 0 then
      Datei := '"' + Datei + '"';
    Laenge := Length(Datei);

    for Loop := 0 to (Anzahl - 1) do
    begin
      if (AnsiCompareText(Datei, Copy(list[Loop], 1, Laenge)) = 0) and
        (list[Loop][Laenge + 1] = ' ') then
      begin
        Result := OEM2ANSI(Copy(list[Loop], Laenge + 2, 1024));
        Exit;
      end;
    end;
  end;
end;

function DescRead(dat: string): string;
var
  DatIn: TextFile;
  Pfad: string;
  Datei: string;
  Zeile: string;
  Laenge: Integer;
begin
  Result := '';

  Pfad := ExtractFilePath(dat) + 'DESCRIPT.ION';

  Datei := ExtractFileName(dat);
  if Pos(' ', Datei) > 0 then
    Datei := '"' + Datei + '"';
  Laenge := Length(Datei);

  if FileExists(Pfad) then
  begin
    AssignFile(DatIn, Pfad);
    Reset(DatIn);
    while not SeekEof(DatIn) do
    begin
      ReadLn(DatIn, Zeile);
      if (AnsiCompareText(Datei, Copy(Zeile, 1, Laenge)) = 0) and
        (Zeile[Laenge + 1] = ' ') then
      begin
        CloseFile(DatIn);
        Result := OEM2ANSI(Copy(Zeile, Laenge + 2, 1024));
        Exit;
      end;
    end;
    CloseFile(DatIn);
  end;
end;

function DescWrite(dat, desc: string): Boolean;
var
  Pfad: string;
  Datei: string;
  Liste: TStringList;
  Anzahl: Integer;
  Loop: Integer;
  Laenge: Integer;
  InList: Boolean;
  CPfad: array[0..MAX_PATH] of char;
begin
  try
    Liste := TStringList.Create;

    Pfad := ExtractFilePath(dat) + 'DESCRIPT.ION';
    StrPCopy(CPfad, Pfad);
    desc := ANSI2OEM(desc);

    Datei := UpperCase(ExtractFileName(dat));
    if Pos(' ', Datei) > 0 then
      Datei := '"' + Datei + '"';
    Laenge := Length(Datei);

    SetFileAttributes(CPfad, FILE_ATTRIBUTE_NORMAL);

    if FileExists(Pfad) then
      Liste.LoadFromFile(Pfad);

    InList := False;

    Anzahl := Liste.Count;
    if Anzahl > 0 then
    begin
      for Loop := 0 to (Anzahl - 1) do
      begin
        if (AnsiCompareText(Datei, Copy(Liste[loop], 1, Laenge)) = 0) and
          (Liste[loop][Laenge + 1] = ' ') then
        begin
          if desc = '' then
            Liste.Delete(loop)
          else
            Liste[loop] := Datei + ' ' + desc;
          InList := True;
          Break;
        end;
      end;
    end;

    if (InList = False) and
      (desc <> '') then
      Liste.Add(Datei + ' ' + desc);

    if Liste.Count = 0 then
    begin
      if FileExists(Pfad) then
        DeleteFile(CPfad);
    end
    else
      Liste.SaveToFile(Pfad);
    Liste.Free;

    if FileExists(Pfad) then
      SetFileAttributes(CPfad, FILE_ATTRIBUTE_HIDDEN);

    Result := True;
  except
    Result := False;
  end;
end;

function DirectoryExists(const Name: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function FileDate(const FileName: string; Flag: Integer): TDateTime;
var
  H : THandle;
  FindData : TWin32FindData;
  function _FileDateToDateTime(FileTime: TFileTime): TDateTime;
  var
    LocalFileTime : TFileTime;
    DosTime : Integer;
  begin
    Result := 0;
    FileTimeToLocalFileTime( FileTime, LocalFileTime );
    if FileTimeToDosDateTime( LocalFileTime, LongRec( DosTime ).Hi, LongRec( DosTime ).Lo ) then
      Result := FileDateToDateTime( DosTime );
  end;
begin
  Result := 0;
  H := FindFirstFile( PChar( FileName ), FindData );
  if H <> INVALID_HANDLE_VALUE then
  begin
    case Flag of
      FILEDATE_CREATION:
        Result := _FileDateToDateTime( FindData.ftCreationTime );
      FILEDATE_LASTACCESS:
        Result := _FileDateToDateTime( FindData.ftLastAccessTime );
      FILEDATE_LASTWRITE:
        Result := _FileDateToDateTime( FindData.ftLastWriteTime );
    end;
    Windows.FindClose( H );
  end;
end;

function FileSize(const FileName: string): Int64;
var
  H: THandle;
  FindData: TWin32FindData;
begin
  Result := -1;
  H := FindFirstFile(PChar(FileName), FindData);
  if H <> INVALID_HANDLE_VALUE then
  begin
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
      Result := (FindData.nFileSizeHigh * MAXWORD) + FindData.nFileSizeLow;
    Windows.FindClose(H);
  end;
end;

function MakePath(const Drive, Dir, Name, Ext: string): string;
var
  i: Integer;
begin
  Result := Drive;
  i := Length(Result);
  if (i > 0) then
  begin
    if IsPathDelimiter(Result, i) then
    begin
      if IsPathDelimiter(Dir, 1) then
        SetLength(Result, i - 1);
    end
    else if not IsDelimiter(':', Result, i) and
      not IsPathDelimiter(Dir, 1) then
      Result := Result + '\';

  end;

  Result := Result + Dir;
  if not IsPathDelimiter(Result, Length(Result) - 1) then
    Result := Result + '\';

  Result := Result + Name;

  if Ext <> '' then
    if Ext[1] = '.' then
      Result := Result + Ext
    else
      Result := Result + '.' + Ext;
end;

function ReadOnlyPath(const Path: string): Boolean;
var
  Name: string;
  Handle: TextFile;
  i: Integer;
begin
  Result := True;

  for i := 0 to MaxInt do
  begin
    Name := MakePath('', Path, Format('ROtmp%d', [i]), '.tmp');
    if not FileExists(Name) then
    begin
      AssignFile(Handle, Name);
{$I-}
      Rewrite(Handle);
{$I+}
      if IOResult = 0 then
      begin
        CloseFile(Handle);
        DeleteFile(Name);
        Result := False;
      end;
      Exit;
    end;
  end;
end;

procedure SplitPath(const Path: string; var Drive, Dir, Name, Ext: string);
var
  i: Integer;
begin
  i := LastDelimiter('\:', Path);
  Name := Copy(Path, i + 1, MaxInt);
  i := LastDelimiter('.', Name);
  if (i > 0) then
  begin
    Ext := Copy(Name, i, MaxInt);
    Delete(Name, i, MaxInt);
  end
  else
    Ext := '';
  Dir := ExtractFileDir(Path);
  Drive := ExtractFileDrive(Dir);
  Delete(Dir, 1, Length(Drive));
end;

function SubdirectoryExists(const Dir: string): Boolean;
var
  FindHandle: THandle;
  FindData: TWin32FindData;
  Erg: Boolean;
begin
  Result := False;
  if not DirectoryExists(Dir) then
    Exit;

  FindHandle := FindFirstFile(PChar(Dir + '\*'), FindData);
  if FindHandle <> INVALID_HANDLE_VALUE then
  try
    Erg := True;
    while Erg do
    begin
      if ((FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > 0) and
        not ((FindData.cFileName[0] = #46) and
        ((FindData.cFileName[1] = #0) or
        ((FindData.cFileName[1] = #46) and
        (FindData.cFileName[2] = #0)))) then
      begin
        Result := True;
        Exit;
      end;
      Erg := FindNextFile(FindHandle, FindData);
    end;
  finally
    Windows.FindClose(FindHandle);
  end;
end;

function ScanForFiles(Filename: string; Recurse, Hidden, IncludeFiles, IncludeDirs:
  Boolean): TStringList;
var
  FindHandle: THandle;
  FindData: TWin32FindData;
  Erg: Boolean;
  paths: TStringList;
  dirpath,
    wildcard,
    pathspec: string;
  i: Integer;
begin
  Result := TStringList.Create;
  try
    paths := nil;

    try
      try
        dirpath := Trim(ExtractFileDir(FileName));
        if dirpath = '' then
          dirpath := GetCurrentDir;
        wildcard := Trim(ExtractFileName(FileName));

        if dirpath[Length(dirpath)] = '\' then
          dirpath := Copy(dirpath, 1, Length(dirpath) - 1);

        if not DirectoryExists(dirpath) then
          Exit;

        if wildcard = '' then
          wildcard := '*';

        paths := TStringList.Create;
        paths.Add(dirpath);

        i := 0;
        while i < paths.Count do
        begin
          dirpath := paths[i];
          Inc(i);
          pathspec := dirpath + '\*';
          FindHandle := FindFirstFile(PChar(pathspec), FindData);
          if FindHandle <> INVALID_HANDLE_VALUE then
          try
            Erg := True;
            while Erg do
            begin
              if not ((FindData.cFileName[0] = #46) and
                ((FindData.cFileName[1] = #0) or
                ((FindData.cFileName[1] = #46) and
                (FindData.cFileName[2] = #0)))) then
              begin
                if ((FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0)
                  then
                begin
                  if Hidden or
                    (((FindData.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN) = 0)
                      and
                    ((FindData.dwFileAttributes and FILE_ATTRIBUTE_SYSTEM) = 0))
                      then
                  begin
                    if IncludeDirs then
                      Result.Add(dirpath + '\' + string(FindData.cFileName));
                    if Recurse then
                      paths.Insert(i, dirpath + '\' + string(FindData.cFileName));
                  end;
                end
                else if IncludeFiles then
                  if (wildcard = '*') or CmpWC(string(FindData.cFileName),
                    wildcard, True) then
                  begin
                    if Hidden or
                      (((FindData.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN) = 0)
                        and
                      ((FindData.dwFileAttributes and FILE_ATTRIBUTE_SYSTEM) = 0))
                        then
                    begin
                      Result.Add(dirpath + '\' + string(FindData.cFileName));
                    end;
                  end;
              end;
              Erg := FindNextFile(FindHandle, FindData);
            end;
          finally
            Windows.FindClose(FindHandle);
          end;
        end;
      except
        Result.Clear;
      end;
    finally
      paths.Free;
    end;
    Result.Sort;
  except
    ;
  end;
end;

function CDClose(Drive: Integer): Boolean; overload;
var
  D: string;
begin
  if Drive = 0 then
    Result := CDClose('')
  else
  begin
    D := 'A:';
    D[1] := Chr(Drive + 64);
    Result := CDClose(D);
  end;
end;

function CDClose(Drive: string): Boolean; overload;
var
  Res: MciError;
  OpenParm: TMCI_Open_Parms;
  Flags: DWord;
  DeviceID: Word;
begin
  Result := False;
  Flags := mci_Open_Type or mci_Open_Element;
  with OpenParm do
  begin
    dwCallback := 0;
    lpstrDeviceType := 'CDAudio';
    if Drive = '' then
      lpstrElementName := PChar(ExtractFileDrive(GetCurrentDir))
    else
      lpstrElementName := PChar(ExtractFileDrive(Drive));
  end;
  Res := mciSendCommand(0, mci_Open, Flags, Longint(@OpenParm));
  if Res <> 0 then
    Exit;
  DeviceID := OpenParm.wDeviceID;
  try
    Res := mciSendCommand(DeviceID, MCI_SET, MCI_SET_DOOR_CLOSED, 0);
    if Res = 0 then
      Exit;
    Result := True;
  finally
    mciSendCommand(DeviceID, mci_Close, Flags, Longint(@OpenParm));
  end;
end;

function CDOpen(Drive: Integer): Boolean; overload;
var
  D: string;
begin
  if Drive = 0 then
    Result := CDOpen('')
  else
  begin
    D := 'A:';
    D[1] := Chr(Drive + 64);
    Result := CDOpen(D);
  end;
end;

function CDOpen(Drive: string): Boolean; overload;
var
  Res: MciError;
  OpenParm: TMCI_Open_Parms;
  Flags: DWord;
  DeviceID: Word;
begin
  Result := False;
  Flags := mci_Open_Type or mci_Open_Element;
  with OpenParm do
  begin
    dwCallback := 0;
    lpstrDeviceType := 'CDAudio';
    if Drive = '' then
      lpstrElementName := PChar(ExtractFileDrive(GetCurrentDir))
    else
      lpstrElementName := PChar(ExtractFileDrive(Drive));
  end;
  Res := mciSendCommand(0, mci_Open, Flags, Longint(@OpenParm));
  if Res <> 0 then
    Exit;
  DeviceID := OpenParm.wDeviceID;
  try
    Res := mciSendCommand(DeviceID, MCI_SET, MCI_SET_DOOR_OPEN, 0);
    if Res = 0 then
      Exit;
    Result := True;
  finally
    mciSendCommand(DeviceID, mci_Close, Flags, Longint(@OpenParm));
  end;
end;

function DriveName(Drive: Integer): string; overload;
var
  N: array[0..MAX_PATH] of Char;
  D: string;
  L: Cardinal;
begin
  N[0] := #0;
  if Drive = 0 then
    GetVolumeInformation(nil, N, MAX_PATH, nil, L, L, nil, 0)
  else
  begin
    D := 'A:\';
    D[1] := Chr(Drive + 64);
    GetVolumeInformation(PChar(D), N, MAX_PATH, nil, L, L, nil, 0);
  end;
  Result := string(N);
end;

function DriveName(Drive: string): string; overload;
var
  N: array[0..MAX_PATH] of Char;
  D: string;
  L: Cardinal;
begin
  N[0] := #0;
  if Drive = '' then
    GetVolumeInformation(nil, N, MAX_PATH, nil, L, L, nil, 0)
  else
  begin
    D := ExtractFileDrive(Drive) + '\';
    GetVolumeInformation(PChar(D), N, MAX_PATH, nil, L, L, nil, 0);
  end;
  Result := string(N);
end;

function DriveReady(Drive: Integer): Boolean; overload;
var
  ErrorMode: WORD;
begin
  Result := False;
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  try
    if DiskSize(Drive) > -1 then
      Result := True;
  finally
    SetErrorMode(ErrorMode);
  end;
end;

function DriveReady(Drive: string): Boolean; overload;
var
  ErrorMode: WORD;
  I: Integer;
begin
  Result := False;

  if Drive = '' then
    I := 0
  else
    I := Ord(UpCase(Drive[1])) - 64;
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  try
    if DiskSize(I) > -1 then
      Result := True;
  finally
    SetErrorMode(ErrorMode);
  end;
end;

function DriveSerial(Drive: Integer): string; overload;
var
  D: string;
begin
  if Drive = 0 then
    Result := DriveSerial('')
  else
  begin
    D := 'A:';
    D[1] := Chr(Drive + 64);
    Result := DriveSerial(D);
  end;
end;

function DriveSerial(Drive: string): string; overload;
var
  VolumeSerialNumber,
    MaximumComponentLength,
    FileSystemFlags: DWord;
  D: array[0..3] of Char;
begin
  StrPCopy(D, ExtractFileDrive(Drive) + '\');
  GetVolumeInformation(D,
    nil,
    0,
    @VolumeSerialNumber,
    MaximumComponentLength,
    FileSystemFlags,
    nil,
    0);
  Result := IntToHex(HiWord(VolumeSerialNumber), 4) +
    '-' +
    IntToHex(LoWord(VolumeSerialNumber), 4);
end;

function DriveType(Drive: Integer): Integer; overload;
var
  D: string;
begin
  if Drive = 0 then
    Result := GetDriveType(nil)
  else
  begin
    D := 'A:\';
    D[1] := Chr(Drive + 64);
    Result := GetDriveType(PChar(D));
  end;
end;

function DriveType(Drive: string): Integer; overload;
var
  D: string;
begin
  if Drive = '' then
    Result := GetDriveType(nil)
  else
  begin
    D := ExtractFileDrive(Drive) + '\';
    Result := GetDriveType(PChar(D));
  end;
end;

function GetWindowsVersion: Integer;
var
  VersionInfo: TOsVersionInfo;
begin
  Result := VER_UNKNOWN;

  VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
  GetVersionEx(VersionInfo);
  with VersionInfo do
  begin
    case dwPlatformId of
      VER_PLATFORM_WIN32s:
        begin
          Result := VER_WIN32S;
        end;
      VER_PLATFORM_WIN32_WINDOWS:
        begin
          Result := VER_WIN95;
          if (dwMajorVersion >= 4) then
            if (dwMinorVersion >= 90) then
              Result := VER_WINME
            else if (dwMinorVersion >= 10) then
              Result := VER_WIN98;
        end;
      VER_PLATFORM_WIN32_NT:
        begin
          if VersionInfo.dwMajorVersion >= 5 then
            Result := VER_WIN2000
          else if VersionInfo.dwMajorVersion = 4 then
            Result := VER_WINNT4
          else
            Result := VER_WINNT;
        end;
    end;
  end;
end;

function IsWin2000: Boolean;
begin
  Result := GetWindowsVersion and VER_WIN2000 >= VER_WIN2000;
end;

function IsWin9x: Boolean;
begin
  Result := GetWindowsVersion and VER_WIN95 >= VER_WIN95;
end;

function IsWinNT: Boolean;
begin
  Result := GetWindowsVersion and VER_WINNT >= VER_WINNT;
end;

function IsWinNT4: Boolean;
begin
  Result := GetWindowsVersion and VER_WINNT4 >= VER_WINNT4;
end;

function ExecAndWait(const Filename, Params, Dir: string; WindowState: Word):
  Boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: string;
  PD: PChar;
begin
  CmdLine := '"' + Filename + '" ' + Params;

  FillChar(SUInfo, SizeOf(SUInfo), #0);
  with SUInfo do
  begin
    cb := SizeOf(SUInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WindowState;
  end;

  if Dir = '' then
    PD := nil
  else
    PD := PChar(Dir);

  Result := CreateProcess(PChar(Filename), PChar(CmdLine), nil, nil, False,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
    PD, SUInfo, ProcInfo);
  if Result then
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
end;

function GetCPUSpeed: Double;
const
  DelayTime = 500;
var
  TimerHi,
    TimerLo: DWORD;
  PriorityClass,
    Priority: Integer;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);

  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  Sleep(10);
  asm
        dw 310Fh // rdtsc
        mov TimerLo, eax
        mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
        dw 310Fh // rdtsc
        sub eax, TimerLo
        sbb edx, TimerHi
        mov TimerLo, eax
        mov TimerHi, edx
  end;

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

  Result := TimerLo / (1000.0 * DelayTime);
end;

function GetCRC32FromString(S: string): Integer;
begin
{$WARNINGS OFF}
  Result := not CRC32Calc(Byte(S[1]), $FFFFFFFF, Length(S));
{$WARNINGS ON}
end;

function GetCRC32FromFile(FileName: string): Integer;
var
  CRC: Integer;
  InFile: file;
  Len: Integer;
  Buffer: array[0..BUFLEN - 1] of Byte;
  LastMode: Byte;
begin
  Result := 0;
  if FileExists(FileName) then
  begin
    LastMode := FileMode;
    try
      FileMode := 0;
      AssignFile(InFile, FileName);
      try
        Reset(InFile, 1);
        try
{$WARNINGS OFF}
          CRC := $FFFFFFFF;
{$WARNINGS ON}
          while True do
          begin
            BlockRead(InFile, Buffer, BUFLEN, Len);
            if Len = 0 then
              Break;
            CRC := CRC32Calc(Buffer, CRC, Len);
          end;
          Result := not CRC;
        finally
          CloseFile(InFile);
        end;
      except
        ;
      end;
    finally
      FileMode := LastMode;
    end;
  end;
end;

function ChangeTokenValue(str, name, value, delim: string): string;
var
  SL: TStringList;
  i: Integer;
begin
  Result := str;
  SL := GetTokenList(str, delim, False, False, False);
  try
    if SL.Count > 0 then
    begin
      for i := 0 to SL.Count - 1 do
      begin
        if SL.Names[i] = name then
        begin
          SL[i] := name + '=' + value;
          Result := GetStringFromList(SL, delim[1]);
          Exit;
        end;
      end;
    end;
  finally
    SL.Free;
  end;
end;

procedure FormatColumns(sl: TStringList; delim: Char; space: string; adjust:
  Integer);
var
  ColWidths: array of Integer;
  Cols: Integer;
  TempSL: TStringList;
  S: string;
  i,
    j: Integer;
begin
  if not Assigned(SL) then
    Exit;
  Cols := 0;
  for i := 0 to sl.Count - 1 do
  begin
    TempSL := GetTokenList(SL[i], delim, False, False, False);
    try
      if Cols < TempSL.Count then
      begin
        SetLength(ColWidths, TempSL.Count);
        for j := Cols to High(ColWidths) do
          ColWidths[j] := 0;
        Cols := TempSL.Count;
      end;
      for j := 0 to TempSL.Count - 1 do
        if ColWidths[j] < Length(TempSL[j]) then
          ColWidths[j] := Length(TempSL[j]);
    finally
      TempSL.Free;
    end;
  end;
  if Cols <= 1 then
    Exit;
  for i := 0 to sl.Count - 1 do
  begin
    TempSL := GetTokenList(SL[i], delim, False, False, False);
    try
      for j := 0 to TempSL.Count - 1 do
      begin
        S := TempSL[j];
        if (j < 32) and ((adjust shr j) and 1 = 1) then
          S := StringOfChar(' ', ColWidths[j] - Length(S)) + S
        else
          S := S + StringOfChar(' ', ColWidths[j] - Length(S));
        if j < TempSL.Count - 1 then
          S := S + space;
        TempSL[j] := S;
      end;
      SL[i] := GetStringFromList(TempSL, #0);
    finally
      TempSL.Free;
    end;
  end;
end;

function GetStringFromList(sl: TStringList; delim: Char): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to sl.Count - 1 do
  begin
    if (Result <> '') and (delim <> #0) then
      Result := Result + delim;
    Result := Result + sl[i];
  end;
end;

function GetTokenList(str, delim: string; repeater, ignorefirst, ignorelast:
  Boolean): TStringList;
var
  LastDelim: Char;
  S: string;
  p: Integer;
  i: Integer;
begin
  Result := TStringList.Create;
  S := '';
  LastDelim := #0;

  for i := 1 to Length(str) do
  begin
    p := Pos(str[i], delim);
    if p > 0 then
    begin
      if (i = 1) and ignorefirst then
      begin
        LastDelim := str[i];
        Continue;
      end;
      if repeater and (str[i] = LastDelim) then
        Continue;
      Result.Add(S);
      S := '';
      LastDelim := str[i];
    end
    else
    begin
      S := S + str[i];
      LastDelim := #0;
    end;
  end;
  if (S <> '') or not ignorelast then
    Result.Add(S);
end;

function PosX(substr, s: string): Integer;
var
  ls,
    lsub,
    i,
    j,
    p: Integer;
begin
  Result := 0;
  ls := Length(s);
  lsub := Length(substr);
  if (ls = 0) or (lsub = 0) then
    Exit;

  i := 1;
  while (i <= ls) and (s[i] = substr[1]) do
  begin
    if lsub > 1 then
    begin
      p := i - 1;
      if p + lsub > ls then
        Break;
      for j := 2 to lsub do
        if s[p + j] <> substr[j] then
          Break;
      Inc(i, lsub);
    end
    else
      Inc(i);
  end;
  if i <= ls then
    Result := i;
end;

function ANSI2OEM(s: string): string;
begin
  Result := s;
  CharToOem(PChar(Result), PChar(Result));
end;

function OEM2ANSI(s: string): string;
begin
  Result := s;
  OemToChar(PChar(Result), PChar(Result));
end;

function Translate(s: string; tout, tin: string; fill: Char; f: Boolean): string;
var
  zeichen: string;
  zeichpos: Integer;
  max: Integer;
  laenge: Integer;
  loop: Integer;
  loop2: Integer;
begin
  try
    laenge := Length(s);
    if laenge = 0 then
      Exit;

    if Length(tin) = 0 then
    begin
      if fill = #0 then
      begin
        s := AnsiUpperCase(s);
        Exit;
      end
      else
      begin
        for loop := 1 to laenge do
          s[loop] := fill;
        Exit;
      end;
    end;

    max := Length(tout);

    SetLength(zeichen, 1);

    loop := 1;
    while loop <= laenge do
    begin
      zeichen[1] := s[loop];
      zeichpos := Pos(zeichen, tin);
      if zeichpos <> 0 then
      begin
        if zeichpos > max then
        begin
          if fill = #0 then
          begin
            Dec(laenge);
            for loop2 := loop to laenge do
              s[loop2] := s[loop2 + 1];
            SetLength(s, laenge);
            if laenge = 0 then
              Exit;
          end
          else
          begin
            s[loop] := fill;
            Inc(loop);
          end;
        end
        else
        begin
          s[loop] := tout[zeichpos];
          Inc(loop);
        end;
      end
      else
        Inc(loop);
    end;
  finally
    Result := s;
  end;
end;

function _brktcmp(range: string; zeich: char): Boolean;
var
  inv: Boolean;
  bpos: Integer;
  hpos: Integer;
begin
  inv := False;
  bpos := 2;
  result := False;

  if range[bpos] = '~' then
  begin
    Inc(bpos);
    inv := True;
  end;

  while (result = False) and (range[bpos] <> ']') do
  begin
    if range[bpos] = '\' then
      Inc(bpos);

    if range[bpos + 1] = '-' then
    begin
      hpos := bpos + 2;
      if range[hpos] = '\' then
        Inc(hpos);

      if (range[bpos] <= zeich) and (zeich <= range[hpos]) then
        result := True;
      bpos := hpos;
    end
    else if range[bpos] = zeich then
      result := True;
    Inc(bpos);
  end;

  if inv then
    result := (result = False);
end;

function CmpWC(source, wc: string; cf: Boolean): Boolean;
var
  afterstar: Integer;
  p: Integer;
  s: Integer;
begin
  afterstar := 0;
  p := 1;
  s := 1;
  result := True;

  if cf then
  begin
    Source := AnsiUpperCase(source);
    wc := AnsiUpperCase(wc);
  end;

  if Length(source) = 0 then
  begin
    SetLength(source, 1);
    source[1] := #0;
  end;
  if Length(wc) = 0 then
  begin
    SetLength(wc, 1);
    wc[1] := #0;
  end;

  while result and (wc[p] <> #0) and (source[s] <> #0) do
  begin
    case wc[p] of
      '?':
        begin
          if source[s] <> #0 then
          begin
            Inc(p);
            Inc(s);
            if afterstar > 0 then
              Dec(afterstar);
          end
          else
            result := False;
        end;
      '+':
        begin
          if source[s] <> #0 then
          begin
            Inc(p);
            Inc(s);
            Inc(afterstar);
          end
          else
            result := False;
        end;
      '*':
        begin
          Inc(p);
          Inc(afterstar);
        end;
      '[':
        begin
          if afterstar > 0 then
          begin
            result := _brktcmp(Copy(wc, p, Length(wc)), source[s]);
            while (source[s] <> #0) and result do
            begin
              result := _brktcmp(Copy(wc, p, Length(wc)), source[s]);
              Inc(s);
            end;
            while CmpWC(Copy(source, s, Length(source)), Copy(wc, p, Length(wc)),
              False) = False do
            begin
              Inc(s);
              if source[s] = #0 then
              begin
                result := False;
                Exit;
              end;
            end;
            result := True;
            Exit;
          end
          else
          begin
            if _brktcmp(Copy(wc, p, Length(wc)), source[s]) = False then
            begin
              result := False;
              Exit;
            end;
            Inc(s);
          end;

          while wc[p] <> ']' do
          begin
            if wc[p] = '\' then
              Inc(p);
            Inc(p);
          end;
          Inc(p);
        end;
    else
      if wc[p] = '\' then
        Inc(p);
      if afterstar > 0 then
      begin
        while (source[s] <> #0) and (wc[p] <> source[s]) do
          Inc(s);
        if (source[s] = #0) then
        begin
          result := False;
          Exit;
        end;
        while CmpWC(Copy(source, s, Length(source)), Copy(wc, p, Length(wc)), False)
          = False do
        begin
          Inc(s);
          if source[s] = #0 then
          begin
            result := False;
            Exit;
          end;
        end;
        result := True;
        Exit;
      end
      else
      begin
        if wc[p] <> source[s] then
        begin
          result := False;
          Exit;
        end;
        Inc(p);
        Inc(s);
      end;
    end;
  end;

  while (afterstar > 0) and (source[s] <> #0) do
    Inc(s);
  while wc[p] = '*' do
    Inc(p);
  if result and ((wc[p] <> #0) or (source[s] <> #0)) then
    result := False;
end;

function IncWC(source, wc: string; cf: Boolean; var ebene: Integer): string;
var
  afterstar: Integer;
  p: Integer;
  s: Integer;
  pat: Integer;
begin
  afterstar := 0;
  p := 1;
  s := 1;
  pat := p;
  result := source;

  Inc(ebene);
  if ebene = 0 then
  begin
    start := source;
    if Length(source) = 0 then
    begin
      SetLength(source, 1);
      source[1] := #0;
    end;
    if Length(wc) = 0 then
    begin
      SetLength(wc, 1);
      wc[1] := #0;
    end;
  end;

  if cf then
  begin
    Source := AnsiUpperCase(source);
    wc := AnsiUpperCase(wc);
  end;

  while (result <> '') and (wc[p] <> #0) and (source[s] <> #0) do
  begin
    case wc[p] of
      '?':
        begin
          if source[s] <> #0 then
          begin
            Inc(p);
            Inc(s);
            if afterstar > 0 then
              Dec(afterstar);
          end
          else
            result := '';
        end;
      '+':
        begin
          if source[s] <> #0 then
          begin
            Inc(p);
            Inc(s);
            Inc(afterstar);
          end
          else
            result := '';
        end;
      '*':
        begin
          Inc(p);
          Inc(afterstar);
        end;
      '[':
        begin
          if afterstar > 0 then
          begin
            if _brktcmp(Copy(wc, p, Length(wc)), source[s]) = False then
              result := '';
            while (source[s] <> #0) and (result <> '') do
            begin
              if _brktcmp(Copy(wc, p, Length(wc)), source[s]) = False then
                result := '';
              Inc(s);
            end;
            while IncWC(Copy(source, s, Length(source)), Copy(wc, p, Length(wc)),
              False, ebene) = '' do
            begin
              Inc(s);
              if source[s] = #0 then
              begin
                Dec(ebene);
                result := '';
                Exit;
              end;
            end;
            Dec(ebene);
            result := Source;
            Exit;
          end
          else
          begin
            if _brktcmp(Copy(wc, p, Length(wc)), source[s]) = False then
            begin
              if ebene > 0 then
              begin
                Dec(ebene);
                result := '';
                Exit;
              end
              else
              begin
                p := pat;
                start := Copy(start, 2, Length(source));
                s := Length(source) - Length(start) + 1;
                Break;
              end;
            end;
            Inc(s);
          end;

          while wc[p] <> ']' do
          begin
            if wc[p] = '\' then
              Inc(p);
            Inc(p);
          end;
          Inc(p);
        end;
    else
      if wc[p] = '\' then
        Inc(p);
      if afterstar > 0 then
      begin
        while (source[s] <> #0) and (wc[p] <> source[s]) do
          Inc(s);
        if source[s] = #0 then
          result := '';
        while IncWC(Copy(source, s, Length(source)), Copy(wc, p, Length(wc)),
          False, ebene) = '' do
        begin
          Inc(s);
          if source[s] = #0 then
          begin
            Dec(ebene);
            result := '';
            Exit;
          end;
        end;
        Dec(ebene);
        result := start;
        Exit;
      end
      else
      begin
        if wc[p] <> source[s] then
        begin
          if ebene > 0 then
          begin
            Dec(ebene);
            result := '';
            Exit;
          end
          else
          begin
            p := pat;
            start := Copy(start, 2, Length(source));
            s := Length(source) - Length(start) + 1;
          end;
        end
        else
        begin
          Inc(p);
          Inc(s);
        end;
      end;
    end;
  end;

  while (afterstar > 0) and (source[s] <> #0) do
    Inc(s);
  while wc[p] = '*' do
    Inc(p);
  if (result <> '') and (wc[p] <> #0) then
    result := '';

  Dec(ebene);

  if result <> '' then
  begin
    start := Copy(start, 1, Length(start) - (Length(source) - s + 1));
    result := start;
  end;
end;

function TestWC(wc: string): Integer;
var
  p: Integer;
begin
  p := 1;
  result := 0;

  while wc[p] <> #0 do
  begin
    case wc[p] of
      '\':
        begin
          Inc(p);
          if wc[p] = #0 then
          begin
            result := 1;
            Exit;
          end;
          Inc(p);
        end;
      '[':
        begin
          Inc(p);
          while (wc[p] <> #0) and (wc[p] <> ']') do
          begin
            if wc[p] = '\' then
              Inc(p, 2)
            else
              Inc(p);

            if wc[p] = '-' then
            begin
              Inc(p);
              if (wc[p] = #0) or (wc[p] = ']') then
              begin
                result := 2;
                Exit;
              end
              else if wc[p] = '\' then
                Inc(p);
              Inc(p);
            end;
          end;

          if wc[p] <> ']' then
          begin
            result := 3;
            Exit;
          end;
          Inc(p);
        end;
      '+',
        '*',
        '?':
        Inc(p);
    else
      Inc(p);
    end;
  end;
end;

function SearchWindow(var cName, wName: string; ProcID: DWord = 0): HWnd;
var
  WinRec: TWinRec;
begin
  WinRec.Handle := 0;
  WinRec.ProcID := ProcID;
  WinRec.Child := 0;
  WinRec.Num := 0;
  WinRec.ClassName := cName;
  WinRec.WindowName := wName;
  EnumWindows(@EnumWindowsProc, LPARAM(@WinRec));
  Result := WinRec.Handle;
  if WinRec.Handle > 0 then
  begin
    cName := WinRec.ClassName;
    wName := WinRec.WindowName;
  end;
end;

function SearchWindowEx(Parent, Child: HWnd; var cName, wName: string; Num: Integer
  = 0): HWnd;
var
  WinRec: TWinRec;
begin
  WinRec.Handle := 0;
  WinRec.ProcID := 0;
  WinRec.Child := Child;
  WinRec.Num := Num;
  WinRec.ClassName := cName;
  WinRec.WindowName := wName;
  EnumChildWindows(Parent, @EnumWindowsProc, LPARAM(@WinRec));
  Result := WinRec.Handle;
  if WinRec.Handle > 0 then
  begin
    cName := WinRec.ClassName;
    wName := WinRec.WindowName;
  end;
end;

function WaitForWindow(var cName, wName: string; Timeout: DWord; ProcID: DWord =
  0): HWnd;
var
  WinRec: TWinRec;
  Count: DWord;
begin
  WinRec.Handle := 0;
  WinRec.ProcID := ProcID;
  WinRec.Child := 0;
  WinRec.Num := 0;
  WinRec.ClassName := cName;
  WinRec.WindowName := wName;
  Count := GetTickCount;
  EnumWindows(@EnumWindowsProc, LPARAM(@WinRec));
  while WinRec.Handle = 0 do
  begin
    Sleep(100);
    if Timeout > 0 then
      if (GetTickCount - Count) > Timeout then
      begin
        Break;
      end;
    EnumWindows(@EnumWindowsProc, LPARAM(@WinRec));
  end;
  Result := WinRec.Handle;
  if WinRec.Handle > 0 then
  begin
    cName := WinRec.ClassName;
    wName := WinRec.WindowName;
  end;
end;

function WaitForWindowClose(var cName, wName: string; Timeout: DWord; ProcID: DWord
  = 0): Boolean;
var
  w: HWnd;
begin
  w := SearchWindow(cName, wName, ProcID);
  if w = 0 then
  begin
    Result := True;
    Exit;
  end;
  Result := WaitForWindowClose(w, Timeout);
end;

function WaitForWindowClose(w: HWnd; Timeout: DWord): Boolean;
var
  Count: DWord;
begin
  Count := GetTickCount;
  if w = 0 then
    w := GetForegroundWindow;
  Result := not IsWindow(w);
  while not Result do
  begin
    Sleep(100);
    if Timeout > 0 then
      if (GetTickCount - Count) > Timeout then
      begin
        Break;
      end;
    Result := not IsWindow(w);
  end;
end;

function WaitForWindowEnabled(var cName, wName: string; Timeout: DWord; ProcID:
  DWord = 0): Boolean;
var
  w: HWnd;
begin
  w := SearchWindow(cName, wName, ProcID);
  if w = 0 then
  begin
    Result := False;
    Exit;
  end;
  Result := WaitForWindowEnabled(w, Timeout);
end;

function WaitForWindowEnabled(w: HWnd; Timeout: DWord): Boolean;
var
  Ret: DWord;
begin
  if SendMessageTimeout(w, WM_USER, 0, 0, SMTO_NORMAL, Timeout, Ret) = 0 then
    Result := False
  else
    Result := True;
end;

function WaitForWindowEx(Parent: HWnd; var cName, wName: string; Timeout: DWord;
  Num: Integer = 0): HWnd;
var
  WinRec: TWinRec;
  Count: DWord;
begin
  WinRec.Handle := 0;
  WinRec.ProcID := 0;
  WinRec.Child := 0;
  WinRec.Num := Num;
  WinRec.ClassName := cName;
  WinRec.WindowName := wName;
  Count := GetTickCount;
  EnumChildWindows(Parent, @EnumWindowsProc, LPARAM(@WinRec));
  while WinRec.Handle = 0 do
  begin
    Sleep(100);
    if Timeout > 0 then
      if (GetTickCount - Count) > Timeout then
      begin
        Break;
      end;
    EnumChildWindows(Parent, @EnumWindowsProc, LPARAM(@WinRec));
  end;
  Result := WinRec.Handle;
  if WinRec.Handle > 0 then
  begin
    cName := WinRec.ClassName;
    wName := WinRec.WindowName;
  end;
end;

procedure WindowMove(w: HWnd; x, y: Integer; Abs: Boolean);
var
  Rect: TRect;
begin
  if IsWindow(w) then
  begin
    if GetWindowRect(w, Rect) then
    begin
      if abs then
      begin
        Rect.Left := x;
        Rect.Top := y;
      end
      else
      begin
        Inc(Rect.Left, x);
        Inc(Rect.Top, y);
      end;
      SetWindowPos(w, 0,
        Rect.Left, Rect.Top,
        0, 0,
        SWP_NOSIZE or SWP_NOZORDER);
    end;
  end;
end;

procedure WindowResize(w: HWnd; x, y: Integer; Abs: Boolean);
var
  Rect: TRect;
begin
  if IsWindow(w) then
  begin
    if GetWindowRect(w, Rect) then
    begin
      if abs then
      begin
        Rect.Right := x;
        Rect.Bottom := y;
      end
      else
      begin
        Inc(Rect.Right, x);
        Inc(Rect.Bottom, y);
        Rect.Right := Rect.Right - Rect.Left;
        Rect.Bottom := Rect.Bottom - Rect.Top;
      end;
      SetWindowPos(w, 0,
        0, 0,
        Rect.Right, Rect.Bottom,
        SWP_NOMOVE or SWP_NOZORDER);
    end;
  end;
end;

function SendKeysWin(w, s: string; wait: Integer = 0; back: Boolean = False):
  Integer;
var
  KeyWin: HWnd;
  c: string;
begin
  c := '';
  KeyWin := SearchWindow(c, w);
  if KeyWin = 0 then
  begin
    Result := SK_WindowNotFound;
    Exit;
  end;
  Result := SendKeysWin(KeyWin, s, wait, back);
end;

function SendKeysWin(w: HWnd; s: string; wait: Integer = 0; back: Boolean = False):
  Integer;
var
  OldWin: HWnd;
begin
  if Back then
    OldWin := GetForegroundWindow
  else
    OldWin := 0;
  if w <> 0 then
  begin
    if not IsWindow(w) then
    begin
      Result := SK_WindowNotFound;
      Exit;
    end;
    if IsIconic(w) then
      ShowWindow(w, SW_RESTORE);
    if not SetForegroundWindow(w) then
    begin
      Result := SK_WindowNotActive;
      Exit;
    end;
  end;
  Result := SK_None;
  SendKeys(s, wait);
  if (w <> 0) and
    (OldWin <> 0) and
    (OldWin <> w) then
    SetForegroundWindow(OldWin);
end;

procedure SendKeys(s: string; wait: Integer = 0);
var
  i: Integer;
  k: Integer;
  shift: Boolean;
  alt: Boolean;
  ctrl: Boolean;
  flag: Boolean;
  w: Word;
  hs: string;
  fw: HWnd;

  procedure SimulateKeyDown(Key: Byte);
  begin
    keybd_event(Key, 0, 0, 0);
  end;

  procedure SimulateKeyUp(Key: Byte);
  begin
    keybd_event(Key, 0, KEYEVENTF_KEYUP, 0);
  end;

  procedure SimulateKeystroke(Key: Byte; extra: DWORD);
  begin
    keybd_event(Key, extra, 0, 0);
    keybd_event(Key, extra, KEYEVENTF_KEYUP, 0);
  end;

  procedure SetOff;
  begin
    if alt then
    begin
      SimulateKeyUp(VK_MENU);
      alt := false;
    end;
    if ctrl then
    begin
      SimulateKeyUp(VK_CONTROL);
      ctrl := false;
    end;
    if shift then
    begin
      SimulateKeyUp(VK_SHIFT);
      shift := false;
    end;
  end;

  procedure SendSingleKey;
  var
    shift: Boolean;
  begin
    shift := HiByte(w) and 1 = 1;
    if shift then
      SimulateKeyDown(VK_SHIFT);
    case w of
      1617, // @
      1592, // [
      1755, // \
      1593, // ]
      1591, // {
      1762, // |
      1584, // }
      1723, // ~
      1586, // ²
      1587, // ³
      1613: // µ
        begin
          if not alt then
          begin
            SimulateKeyDown(VK_MENU);
            alt := true;
          end;
          if not ctrl then
          begin
            SimulateKeyDown(VK_CONTROL);
            ctrl := true;
          end;
        end;
    end;
    SimulateKeystroke(LoByte(w), 0);
    SetOff;

    if shift then
      SimulateKeyUp(VK_SHIFT);
  end;

  function weekday(i: Integer): string;
  begin
    case i of
      1: weekday := 'Montag';
      2: weekday := 'Dienstag';
      3: weekday := 'Mittwoch';
      4: weekday := 'Donnerstag';
      5: weekday := 'Freitag';
      6: weekday := 'Samstag';
      7: weekday := 'Sonntag';
    end;
  end;
begin
  fw := GetForegroundWindow;
  if not IsWindowVisible(fw) then
    Exit;
  if not IsWindowEnabled(fw) then
  begin
    if wait > 0 then
    begin
      if not WaitForWindowEnabled(fw, wait) then
        Exit;
    end
    else
      Exit;
  end;
  alt := false;
  ctrl := false;
  shift := false;
  flag := not GetKeyState(VK_CAPITAL) and 1 = 0;
  if flag then
    SimulateKeystroke(VK_CAPITAL, 0);
  i := 1;
  while i <= Length(s) do
  begin
    w := VkKeyScan(s[i]);
    if ((HiByte(w) <> $FF) and
      (LoByte(w) <> $FF)) then
    begin
      if (s[i] = '@') then
      begin
        if (s[i + 1] <> '@') then
        begin
          SimulateKeyDown(VK_MENU);
          alt := true;
        end
        else
        begin
          inc(i);
          SendSingleKey;
        end;
      end
      else if s[i] = '^' then
      begin
        if (s[i + 1] <> '^') then
        begin
          SimulateKeyDown(VK_CONTROL);
          ctrl := true;
        end
        else
        begin
          inc(i);
          SendSingleKey;
        end;
      end
      else if s[i] = '{' then
      begin
        if (s[i + 1] <> '{') then
        begin
          k := pos('}', copy(s, i + 1, length(s)));
          if k > 0 then
          begin
            hs := uppercase(copy(s, i + 1, k - 1));
            if hs = 'INS' then
              SimulateKeystroke(VK_INSERT, 0)
            else if hs = 'DEL' then
              SimulateKeystroke(VK_DELETE, 0)
            else if hs = 'ENTER' then
              SimulateKeystroke(VK_RETURN, 0)
            else if hs = 'TAB' then
              SimulateKeystroke(VK_TAB, 0)
            else if hs = 'ESC' then
              SimulateKeystroke(VK_ESCAPE, 0)
            else if hs = 'BACK' then
              SimulateKeystroke(VK_BACK, 0)
            else if hs = 'UP' then
              SimulateKeystroke(VK_up, 0)
            else if hs = 'DOWN' then
              SimulateKeystroke(VK_DOWN, 0)
            else if hs = 'LEFT' then
              SimulateKeystroke(VK_LEFT, 0)
            else if hs = 'RIGHT' then
              SimulateKeystroke(VK_RIGHT, 0)
            else if hs = 'PGDN' then
              SimulateKeystroke(VK_NEXT, 0)
            else if hs = 'PGUP' then
              SimulateKeystroke(VK_PRIOR, 0)
            else if hs = 'END' then
              SimulateKeystroke(VK_END, 0)
            else if hs = 'HOME' then
              SimulateKeystroke(VK_HOME, 0)
            else if hs = 'PRTSC' then
              SimulateKeystroke(VK_SNAPSHOT, 0)
            else if hs = 'F1' then
              SimulateKeystroke(VK_F1, 0)
            else if hs = 'F2' then
              SimulateKeystroke(VK_F2, 0)
            else if hs = 'F3' then
              SimulateKeystroke(VK_F3, 0)
            else if hs = 'F4' then
              SimulateKeystroke(VK_F4, 0)
            else if hs = 'F5' then
              SimulateKeystroke(VK_F5, 0)
            else if hs = 'F6' then
              SimulateKeystroke(VK_F6, 0)
            else if hs = 'F7' then
              SimulateKeystroke(VK_F7, 0)
            else if hs = 'F8' then
              SimulateKeystroke(VK_F8, 0)
            else if hs = 'F9' then
              SimulateKeystroke(VK_F9, 0)
            else if hs = 'F10' then
              SimulateKeystroke(VK_F10, 0)
            else if hs = 'F11' then
              SimulateKeystroke(VK_F11, 0)
            else if hs = 'F12' then
              SimulateKeystroke(VK_F12, 0)
            else if hs = 'SHIFT' then
            begin
              SimulateKeystroke(VK_SHIFT, 0);
              shift := true;
            end
            else if copy(hs, 1, 6) = 'SELECT' then
            begin
              hs := copy(hs, 8, length(hs));
              while (length(hs) > 0) and (hs[1] = ' ') do
                hs := copy(hs, 2, length(hs));
              {*
              for j := 0 to WindowsList1.TheWindowsList.count - 1 do
                  if pos( hs, uppercase( WienieMacro.windowslist1.TheWindowsList[j] ) ) > 0 then
                  begin
                      Handle := WindowsList1.GetHandle( j );
                      SetForegroundWindow( Handle );
                  end;
              *}
            end
            else if hs = 'DATE' then
            begin
              insert(DateToStr(Date), s, i + k + 1);
            end
            else if hs = 'TIME' then
            begin
              insert(TimeToStr(Time), s, i + k + 1);
            end
            else if hs = 'DAY' then
            begin
              insert(weekday(DayOfWeek(Date)), s, i + k + 1);
            end;
            i := i + k;
          end
          else
          begin
            SendSingleKey;
          end;
        end
        else
        begin
          inc(i);
          SendSingleKey;
        end;
      end
      else
      begin
        SendSingleKey;
      end;
      inc(i);
    end;
  end;
  if flag then
    SimulateKeystroke(VK_CAPITAL, 0);
  SetOff;
end;

function SelectStringDialog(Title: String; Strings: TStringList; Selected: Integer): Integer;
var
  Form: TForm;
  List: TListBox;
  Button: TBitBtn;
  MaxLineWidth,
  LineHeight,

  w,
  i: Integer;
begin
  Result := -1;

  if not Assigned(Strings) or (Strings.Count = 0) then
    Exit;

  Form := TForm.Create(Application);
  try
    with Form.Canvas do
    begin
      MaxLineWidth := TextWidth(Title + 'XXXXXXXXXXXXXXX');
      for i := 0 to Strings.Count - 1 do
      begin
        w := TextWidth(Strings[i] + 'x');
        if w > MaxLineWidth then
          MaxLineWidth := w;
      end;
      LineHeight := TextHeight(Strings[0]);
    end;

    List := TListBox.Create(Form);
    with List do
    begin
      Parent := Form;
      Left := 10;
      Top := 10;
      if MaxLineWidth + 4 < 600 then
        Width := MaxLineWidth + 4
      else
        Width := 600;
      if Width < 200 then
        Width := 200;
      if LineHeight * Strings.Count + 4 < 400 then
      begin
        if Width = 600 then
          Height := LineHeight * Strings.Count + 24
        else
          Height := LineHeight * Strings.Count + 4;
      end
      else
      begin
        Height := 400;
        if Width < 600 then
          Width := Width + 20;
      end;
      Items.AddStrings(Strings);
      SendMessage(Handle, LB_SETHORIZONTALEXTENT, MaxLineWidth, 0);
    end;
    if (Selected >= 0) and (Selected < Strings.Count) then
      List.ItemIndex := Selected
    else
      List.ItemIndex := 0;

    with Form do
    begin
      Caption := Title;
      ClientWidth := List.Width + 20;
      ClientHeight := List.Height + 55;
      Left := Screen.Monitors[0].Width div 2 - Width div 2 + Screen.Monitors[0].Left;
      Top := Screen.Monitors[0].Height div 2 - Height div 2 + Screen.Monitors[0].Top;
    end;

    Button := TBitBtn.Create(Form);
    with Button do
    begin
      Parent := Form;
      Default := True;
      Kind := bkOK;
      Width := Form.ClientWidth div 5 * 2;
      Height := 25;
      Left := Form.ClientWidth div 15;
      Top := List.Top + List.Height + 10;
    end;

    Button := TBitBtn.Create(Form);
    with Button do
    begin
      Parent := Form;
      Cancel := True;
      Kind := bkCancel;
      Width := Form.ClientWidth div 5 * 2;
      Height := 25;
      Left := Form.ClientWidth div 15 * 2 + Width;
      Top := List.Top + List.Height + 10;
    end;

    if Form.ShowModal = mrOK then
      Result := List.ItemIndex;
  finally
    Form.Free;
  end;
end;

end.

