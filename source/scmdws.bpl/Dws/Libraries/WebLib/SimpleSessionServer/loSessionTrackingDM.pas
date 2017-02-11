unit loSessionTrackingDM;

interface

uses
  SysUtils, Classes, DB, DBClient, IdComponent, IdTCPServer,
  IdBaseComponent, IdThreadMgr, variants,
  dws2SessionBasics, syncobjs;

type
  TDataModule1 = class(TDataModule)
    Sessions: TClientDataSet;
    server: TIdTCPServer;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure serverExecute(AThread: TIdPeerThread);
    procedure serverConnect(AThread: TIdPeerThread);
  private
    SessionLocks: TStringList;
    Lock: TCriticalSection;
    FTTime: Real;
    FSTime: Real;

    function AddSession(const Brand: string; const Data: Variant): Boolean;
    function DeleteSession(const Brand: string): Boolean;
    function GetSessionData(const Brand: string; out Data: Variant; out LastTouched: TDateTime; out LastAction: TDateTime): Boolean;
    function EditSession(const Brand: string; const Data: Variant; const LastTouched: TDateTime; const LastAction: TDateTime): Boolean;
    function DeleteExpiredSessions(const ReqTime,
      Tchtime: real; out SessionBrands: string): Boolean;
    function FEnumerateSessions: string;
    procedure SetTTime(const Value: Real);
    procedure SetSTime(const Value: Real);
  public
    property TTime: Real read FTTime write SetTTime;
    property STime: Real read FSTime write SetSTime;
  end;


var
  DataModule1: TDataModule1;
  MyBaseFileName: string = 'NSessions.xml';
  Synchronizer: TCriticalSection;

implementation
{$R *.xfm}

procedure TDataModule1.DataModuleDestroy(Sender: TObject);
begin
  DataModule1 := nil;
  Server.Active := False;
  Sessions.SaveToFile(MyBaseFileName, dfXML);
  SessionLocks.Free;
  Lock.Free;
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  DataModule1 := self;
  Lock := TCriticalSection.create;
  SessionLocks := TStringList.Create;
  if fileexists(MyBaseFileName) then
  begin
    Sessions.LoadFromFile(MyBaseFilename);
    Sessions.IndexDefs.Clear;
    with Sessions.IndexDefs.AddIndexDef do
    begin
      Fields := 'SessionBrand';
      Name := 'Ind1';
      Options := [ixPrimary, ixUnique, ixCaseInsensitive];
    end;
    Sessions.IndexName := 'Ind1';
  end
  else
    with Sessions do
    begin
      with FieldDefs.AddFieldDef do
      begin
        DataType := ftString;
        Name := 'SessionBrand';
      end;
      with FieldDefs.AddFieldDef do
      begin
        DataType := ftBlob;
        Name := 'SessionData';
      end;
      with FieldDefs.AddFieldDef do
      begin
        DataType := ftDateTime;
        Name := 'LastAction';
      end;
      with FieldDefs.AddFieldDef do
      begin
        DataType := ftDateTime;
        Name := 'LastTouch';
      end;
      with IndexDefs.AddIndexDef do
      begin
        Fields := 'SessionBrand';
        Name := 'Ind1';
        Options := [ixPrimary, ixUnique, ixCaseInsensitive];
      end;
      CreateDataSet;
    end;
  Sessions.FileName := MyBaseFileName;
  Sessions.Active := True;
  Server.Active := True;
end;

procedure TDataModule1.serverExecute(AThread: TIdPeerThread);
var
  Command: Integer;
  Brand, input, input2: string;
  Puffer: Variant;
  touch, action: TDateTime;
begin
  Command := strtoint(AThread.Connection.ReadLn(SLF));
  Brand := AThread.Connection.ReadLn(SLF);
  case Command of
    EnumerateSessions:
      AThread.Connection.Write(FEnumerateSessions + SLF);

    IsSession: if GetSessionData(Brand, Puffer, touch, action) then
        AThread.Connection.Write(Brand + SLF) else
        AThread.Connection.Write(SLF);
    NewSession: begin
        Puffer := AThread.Connection.ReadLn(SLF);
        if AddSession(Brand, Puffer) then
          AThread.Connection.Write(Brand + SLF) else
          AThread.Connection.Write(SLF);
      end;
    EndSession: if DeleteSession(Brand) then
        AThread.Connection.Write(Brand + SLF) else
        AThread.Connection.Write(SLF);
    GetSession: if GetSessionData(Brand, Puffer, touch, action) then
      begin
        AThread.Connection.Write(Brand + SLF);
        AThread.Connection.Write(string(Puffer) + SLF);
        { TODO : be sure to use the same datetime formattings on client + server!!!! }
        AThread.Connection.Write(datetimetostr(touch) + SLF);
        AThread.Connection.Write(datetimetostr(action) + SLF);
      end else
        AThread.Connection.Write(SLF);
    EditSessionData:
      begin
        try
          Puffer := AThread.Connection.ReadLn(SLF);
        { TODO : be sure to use the same datetime formattings on client + server!!!! }
          input := AThread.Connection.ReadLn(SLF);
          input2 := AThread.Connection.ReadLn(SLF);
          touch := StrToDateTime(input);
          action := StrToDateTime(input2);
          if EditSession(Brand, Puffer, touch, action) then
            AThread.Connection.Write(Brand + SLF) else
            AThread.Connection.Write(SLF);
        except
          asm
         int 3;
          end;
        end;
      end;
  else
    AThread.Connection.Disconnect;
  end;
end;

function TDataModule1.AddSession(const Brand: string;
  const Data: Variant): Boolean;
var muell: string;
begin
  Synchronizer.Enter;
  try
    DeleteExpiredSessions(STime, TTime, muell);
    try
      Sessions.InsertRecord([Brand, Data, now, now]);
      {Sessions.Insert;
      Sessions.FieldByName('SessionBrand').AsString := Brand;
      Sessions.FieldByName('SessionData').AsString := Data;
      Sessions.FieldByName('LastAction').AsDateTime := now;
      Sessions.FieldByName('LastTouch').AsDateTime := now;
      Sessions.Post;}
      Result := True;
    except
      Result := False;
      Sessions.Cancel;
    end;
  finally
    Synchronizer.Leave;
  end;
end;

function TDataModule1.DeleteSession(const Brand: string): Boolean;
begin
  Synchronizer.Enter;
  try
    Result := False;
    if not Sessions.Locate('SessionBrand', Brand, []) then
      exit;
    Sessions.Delete;
    Result := True;
  finally
    Synchronizer.Leave;
  end;
end;

function TDataModule1.GetSessionData(const Brand: string;
  out Data: Variant; out LastTouched: TDateTime; out LastAction: TDateTime): Boolean;
begin
  Synchronizer.Enter;
  try
    Result := False;
    if not Sessions.Locate('SessionBrand', Brand, []) then
      exit;
    Data := Sessions.fieldbyname('SessionData').AsVariant;
    LastTouched := Sessions.fieldbyname('LastTouch').AsDateTime;
    LastAction := Sessions.fieldbyname('LastAction').AsDateTime;
    Result := True;
  finally
    Synchronizer.Leave;
  end;
end;

function TDataModule1.EditSession(const Brand: string;
  const Data: Variant; const LastTouched: TDateTime; const LastAction: TDateTime): Boolean;
begin
  Synchronizer.Enter;
  try
    Result := False;
    if not Sessions.Locate('SessionBrand', Brand, []) then
      exit;
    Sessions.Edit;
    if not VarIsEmpty(Data) then
      Sessions.FieldByName('SessionData').AsVariant := Data;
    Sessions.FieldByName('LastTouch').AsDateTime := LastTouched;
    Sessions.FieldByName('LastAction').AsDateTime := LastAction;
    try
      Sessions.Post;
      Result := True;
    except
      Sessions.Cancel;
      Result := false;
    end;
  finally
    Synchronizer.Leave;
  end;
end;


function TDataModule1.DeleteExpiredSessions(const ReqTime,
  Tchtime: real; out SessionBrands: string): Boolean;

var
  OutStr: TStringList;
  dtReqTime, dtTchTime: TDateTime;
  userSess: TUserSession;
  sessiondata: string;
begin
  Result := True;
  OutStr := TStringList.Create;
  dtReqTime := now - ReqTime;
  if TchTime > 0 then
    dtTchTime := now - TchTime
  else
    dtTchTime := now - ReqTime;
  Sessions.First;
  userSess := TUserSession.create;
  while not Sessions.Eof do
  begin
    sessiondata := Sessions.fieldbyname('SessionData').AsString;
    userSess.FromString(sessiondata);
    with userSess do
    begin
      if (TLastAction < dtReqTime) or (TLastTouch < dtTchTime)
        or (ClientState = dwsClientStateTOUT) then
      begin
        OutStr.add(userSess.SessionBrand);
        Sessions.Delete;
      end
      else
        Sessions.Next;
    end;
  end; // while
  userSess.free;
  SessionBrands := OutStr.Text;
  OutStr.Free;
end;

procedure TDataModule1.serverConnect(AThread: TIdPeerThread);
begin
  AThread.Connection.Write(floattostr(TTime) + slf); // max touch time
  AThread.Connection.Write(floattostr(STime) + slf); // max req. time
end;

procedure TDataModule1.SetTTime(const Value: Real);
begin
  FTTime := Value;
end;

procedure TDataModule1.SetSTime(const Value: Real);
begin
  FSTime := Value;
end;

function TDataModule1.FEnumerateSessions: string;
var AList: TStringList;
begin
  Result := ''; ;
  Synchronizer.Enter;
  AList := TStringList.Create;
  try
    Sessions.First;
    while not Sessions.Eof do
    begin
      AList.Add(Sessions.Fieldbyname('SessionBrand').AsString);
      Sessions.Next;
    end;
    Result := AList.Text;
  finally
    Synchronizer.Leave;
    AList.Free;
  end;
end;

initialization
  Synchronizer := TCriticalSection.Create;
finalization
  Synchronizer.Free;
end.


