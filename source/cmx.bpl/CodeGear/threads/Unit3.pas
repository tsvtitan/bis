unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Contnrs,

  SqlExpr;

type
  TForm3 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  ListConn: TObjectList;

implementation

{$R *.dfm}

uses WinSock;

function GetHostNameEx: String;
const
  WSVer = $101;
var
  wsaData: TWSAData;
  Buf: array [0..127] of Char;
begin
  Result := '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      Result:=Buf;
    end;
    WSACleanup;
  end;
end;

procedure GetStringsByString(const S,Delim: String; Strings: TStrings);
var
  Apos: Integer;
  S1,S2: String;
begin
  if Assigned(Strings) then begin
    Apos:=-1;
    S2:=S;
    while Apos<>0 do begin
      Apos:=AnsiPos(Delim,S2);
      if Apos>0 then begin
        S1:=Copy(S2,1,Apos-Length(Delim));
        S2:=Copy(S2,Apos+Length(Delim),Length(S2));
        if S1<>'' then
          Strings.AddObject(S1,TObject(Apos))
        else begin
          if Length(S2)>0 then
            APos:=-1;
        end;
      end else
        Strings.AddObject(S2,TObject(Apos));
    end;
  end;
end;

function GetDatabaseName: String;
var
  Str: TStringList;
begin
  Str:=TStringList.Create;
  try
//    Result:=ExtractFilePath(Application.ExeName)+'INTERBASE.IB';
    Result:=ExtractFilePath(Application.ExeName)+'FIREBIRD.FDB';
    GetStringsByString(Result,':',Str);
    if Str.Count<=2 then
      Result:=GetHostNameEx+':'+Result;
  finally
    Str.Free;
  end;
end;

function AddConn: TSQLConnection;
begin
  Result:=TSQLConnection.Create(nil);
  ListConn.Add(Result);
  with Result do begin
    LoadParamsOnConnect:=false;
    AutoClone:=false;

    DriverName := 'Interbase';
    GetDriverFunc := 'getSQLDriverINTERBASE';
    LibraryName := 'dbxint30.dll';
    VendorLib := 'gds32.dll';

{    DriverName:='Firebird';
    GetDriverFunc := 'getSQLDriverFIREBIRD';
    LibraryName := 'dbxfb40.dll';
    VendorLib := 'gds32.dll'; }

    Params.Add('User_Name=SYSDBA');
    Params.Add('Password=masterkey');
    Params.Add(Format('Database=%s',[GetDatabaseName]));
    Params.Add('RoleName=');
    Params.Add('ServerCharSet=');
    Params.Add('SQLDialect=3');
    Params.Add('BlobSize=-1');
    Params.Add('ErrorResourceFile=');
    Params.Add('LocaleCode=0000');
    Params.Add('CommitRetain=False');
    Params.Add('WaitOnLock=True');
    Params.Add('Interbase TransIsolation=ReadCommited');
    Params.Add('Trim Char=False');
    ParamsLoaded:=true;
    Open;
  end;
end;

initialization
  ListConn:=TObjectList.Create;

finalization
  ListConn.Free;
  
end.