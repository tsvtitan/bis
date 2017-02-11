unit UnitLeak;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  SqlExpr, DBXCommon;

type
  TFormLeaks = class(TForm)
    Label1: TLabel;
    Timer1: TTimer;
    CheckBoxSqlMonitor: TCheckBox;
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBoxSqlMonitorClick(Sender: TObject);
  private
    FCounter: Integer;
    FConnection: TSQLConnection;
    FMonitor: TSQLMonitor;

    procedure ExecuteSqlStoredProc;
    procedure ExecuteSqlQuery;

    procedure MonitorLogTrace(Sender: TObject; TraceInfo: TDBXTraceInfo);

  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  FormLeaks: TFormLeaks;

implementation

{$R *.dfm}

uses WinSock, PsAPI;

   
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

function GetWorkingSetSize: Integer;
var
  pmc: TProcessMemoryCounters;
begin
  Result:=0;
  pmc.cb:=SizeOf(pmc);
  FillChar(pmc,SizeOf(pmc),0);
  if GetProcessMemoryInfo(GetCurrentProcess, @pmc, SizeOf(pmc)) then
    Result:=pmc.WorkingSetSize;
end;

{ TFormLeaks }

constructor TFormLeaks.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FConnection:=TSQLConnection.Create(Self);
  with FConnection do begin
    LoadParamsOnConnect:=false;
    AutoClone:=false;

 {   DriverName := 'Interbase';
    GetDriverFunc := 'getSQLDriverINTERBASE';
    LibraryName := 'dbxint30.dll';
    VendorLib := 'gds32.dll';  }

    DriverName:='Firebird';
    GetDriverFunc := 'getSQLDriverFIREBIRD';
    LibraryName := 'dbxfb40.dll';
    VendorLib := 'gds32.dll';

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

  FMonitor:=TSQLMonitor.Create(Self);
  FMonitor.SQLConnection:=FConnection;
  FMonitor.OnLogTrace:=MonitorLogTrace;
  FMonitor.Active:=false;


end;

procedure TFormLeaks.MonitorLogTrace(Sender: TObject; TraceInfo: TDBXTraceInfo);
begin
  FMonitor.TraceList.Clear;
end;

procedure TFormLeaks.ExecuteSqlStoredProc;
var
  Proc: TSQLStoredProc;
  S: String;
begin
  if FConnection.Connected then begin
    Proc:=TSQLStoredProc.Create(nil);
    try
      Proc.SQLConnection:=FConnection;

      Proc.StoredProcName:='PROC_EMPTY';
      Proc.ExecProc;

      Proc.StoredProcName:='PROC_ONE_IN_PARAM';
      Proc.Params[0].AsString:='Hello';
      Proc.ExecProc;

      Proc.StoredProcName:='PROC_ONE_OUT_PARAM';
      Proc.ExecProc;
      S:=Proc.Params[0].AsString;
      if S<>'' then

      Proc.StoredProcName:='PROC_OUT_IN_PARAM';
      Proc.Params[0].AsString:='Hello';
      Proc.ExecProc;
      S:=Proc.Params[1].AsString;
      if S<>'' then

    finally
      Proc.Free;
    end;
  end;
end;

procedure TFormLeaks.ExecuteSqlQuery;
var
  Query: TSQLQuery;
begin
  if FConnection.Connected then begin
    Query:=TSQLQuery.Create(nil);
    try
      Query.SQLConnection:=FConnection;

      Query.SQL.Text:='SELECT * FROM TABLE_ONE_RECORD';
      Query.Open;

      Query.Close;
      Query.SQL.Text:='INSERT INTO TABLE_INSERT (ID) VALUES (1)';
      Query.ExecSQL;

      Query.SQL.Text:='UPDATE TABLE_UPDATE SET NAME=''Test'' WHERE ID=1';
      Query.ExecSQL;

      Query.SQL.Text:='DELETE FROM TABLE_DELETE WHERE ID=1';
      Query.ExecSQL;
    finally
      Query.Free;
    end;
  end;
end;

procedure TFormLeaks.Timer1Timer(Sender: TObject);
var
  B1: Integer;
begin
  Timer1.Enabled:=false;
  try
    B1:=GetWorkingSetSize;
    ExecuteSqlStoredProc;
    ExecuteSqlQuery;
    FCounter:=FCounter+(GetWorkingSetSize-B1);
    Label1.Caption:='Bytes allocated: '+IntToStr(FCounter);
  finally
    Timer1.Enabled:=true;
  end;
end;

procedure TFormLeaks.CheckBoxSqlMonitorClick(Sender: TObject);
begin
  FMonitor.Active:=CheckBoxSqlMonitor.Checked;
end;


end.
