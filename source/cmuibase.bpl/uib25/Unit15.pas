unit Unit15;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  uib, uiblib, uibase, uibconst, IBDatabase, DB, IBCustomDataSet, IBStoredProc,
  BisThreads;

type

  TUIBQuery=class(uib.TUIBQuery)
  end;

  TIBStoredProc=class(IBStoredProc.TIBStoredProc)
  end;

  TBisExecuteThread=class(TBisWorkThread)
  private
    FDbase: TUIBDataBase;
    FQuery: TUIBQuery;
    FTranId: Cardinal;
    FWait: TBisWaitThread;
  public

    procedure Terminate; override;
    procedure CleanUp; override;
    destructor Destroy; override;
  end;

  TMainForm = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
    Button3: TButton;
    IBDatabase1: TIBDatabase;
    IBStoredProc1: TIBStoredProc;
    IBTransaction1: TIBTransaction;
    Button4: TButton;
    Button5: TButton;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    FDatabase: TUIBDataBase;
    FExecuteThread: TBisWorkThread;
    FLastWorkPeriod: Int64;
    FLastError: String;

    procedure ShowTime;
    procedure ShowWaitForm;
    procedure HideWaitForm;
    
    procedure ExecuteThreadWork(Thread: TBisWorkThread);
    procedure ExecuteThreadWorkBegin(Thread: TBisWorkThread);
    procedure ExecuteThreadWorkEnd(Thread: TBisWorkThread; const AException: Exception=nil);
    procedure ExecuteThreadTimeout(Thread: TBisWorkThread; var Forced: Boolean);
    procedure ExecuteThreadDestroy(Thread: TBisThread);

    procedure WaitTimeout(Thread: TBisWaitThread);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TBisUIBaseStoredProc=class(TUIBStatement)
  private
    FStoredProcName: String;
  public
//    procedure RefreshParams;

    property StoredProcName: String read FStoredProcName write FStoredProcName;
  end;

var
  MainForm: TMainForm;
  ApplicationFinished: Boolean=false;

implementation

uses Unit1, BisUtils;

{$R *.dfm}

{ TBisUIBaseStoredProc }

(*procedure TBisUIBaseStoredProc.RefreshParams;
var
  i, r: Integer;
  Str: string;
  Query: TUIBStatement;
  FieldType: SmallInt;
  ParamName: String;
  ParamType: SmallInt;
  ParamScale: SmallInt;
begin
  Query:=TUIBStatement.Create(nil);
  try
    Query.Transaction:=Transaction;
    Query.SQL.Text:='SELECT RDB$FIELD_TYPE, RDB$PARAMETER_NAME, RDB$FIELD_SCALE, RDB$PARAMETER_TYPE '+
                    'FROM RDB$PROCEDURE_PARAMETERS PRM JOIN RDB$FIELDS FLD ON '+
                    'PRM.RDB$FIELD_SOURCE = FLD.RDB$FIELD_NAME '+
                    'WHERE PRM.RDB$PROCEDURE_NAME = ''' + SQLUnQuote(FStoredProcName) + ''' '+
                    'ORDER BY RDB$PARAMETER_TYPE, PRM.RDB$PARAMETER_NUMBER';
    Query.Open;
    while not Query.Eof do begin

      FieldType:=Query.Fields.AsSmallInt[0];
      ParamName:=Trim(Query.Fields.AsString[1]);
      ParamScale:=Query.Fields.AsSmallInt[2];
      ParamType:=Query.Fields.AsSmallInt[3];

      if ParamScale<0 then begin
        case FieldType of
          blr_short:  Params.AddFieldType(ParamName, uftNumeric, - ParamScale, 4);
          blr_long:  Params.AddFieldType(ParamName, uftNumeric, - ParamScale, 7);
          blr_int64,blr_quad,blr_double: Params.AddFieldType(ParamName, uftNumeric, - ParamScale, 15);
        else
          Raise Exception.Create(EUIB_UNEXPECTEDERROR);
        end;
      end else begin
        case FieldType of
          blr_text,blr_text2,blr_varying,blr_varying2,blr_cstring,blr_cstring2 : Params.AddFieldType(ParamName, uftChar);
          blr_float,blr_d_float: Params.AddFieldType(ParamName, uftFloat);
          blr_short: Params.AddFieldType(ParamName, uftSmallint);
          blr_long: Params.AddFieldType(ParamName, uftInteger);
          blr_quad: Params.AddFieldType(ParamName, uftQuad);
          blr_double: Params.AddFieldType(ParamName, uftDoublePrecision);
          blr_timestamp: Params.AddFieldType(ParamName, uftTimestamp);
          blr_blob,blr_blob_id: Params.AddFieldType(ParamName, uftBlob);
          blr_sql_date: Params.AddFieldType(ParamName, uftDate);
          blr_sql_time: Params.AddFieldType(ParamName, uftTime);
          blr_int64: Params.AddFieldType(ParamName, uftInt64);
        {$IFDEF IB7_UP}
          blr_boolean_dtype: Params.AddFieldType(ParamName, uftBoolean);
        {$ENDIF}
        else
          raise Exception.Create(EUIB_UNEXPECTEDERROR);
        end;
      end;


      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;*)

{ TBisExecuteThread }

procedure TBisExecuteThread.CleanUp;
begin
  inherited CleanUp;
  FQuery:=nil;
  FDbase:=nil;
end;

destructor TBisExecuteThread.Destroy;
begin
  if Assigned(FWait) then begin
    FWait.CleanUp;
    FWait.Free;
    FWait:=nil;
  end;
  inherited Destroy;
end;

procedure TBisExecuteThread.Terminate;
begin
  inherited Terminate;
{  if Assigned(FDbase) then
    FDbase.CancelAbort;}
{  if Assigned(FQuery) then
    FQuery.}
      
end;

{ TForm15 }

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDatabase:=TUIBDataBase.Create(nil);
  FDatabase.CharacterSet:=csWIN1251;
  FDatabase.DatabaseName:='s1:e:\taxi\taxi.fdb';
  FDatabase.UserName:='SYSDBA';
  FDatabase.PassWord:='masterkey';

end;

destructor TMainForm.Destroy;
begin
  if Assigned(FExecuteThread) then begin
    FExecuteThread.FreeOnTerminate:=false;
    FExecuteThread.Terminate;
    FExecuteThread.Free;
    FExecuteThread:=nil;

{    FExecuteThread.FreeOnTerminate:=false;
    FExecuteThread.Terminate;
    FExecuteThread.Free;
    FExecuteThread:=nil;}
  end;
  FDatabase.Free;
  inherited Destroy;
end;

procedure TMainForm.Button1Click(Sender: TObject);
{var
  Tran: TUIBTransaction;
  Proc: TBisUIBaseStoredProc;}
begin
{  FDatabase.Connected:=true;
  Tran:=TUIBTransaction.Create(nil);
  Proc:=TBisUIBaseStoredProc.Create(nil);
  try
    Tran.DataBase:=FDatabase;
    Proc.Transaction:=Tran;
    Proc.StoredProcName:='GET_TEST';
    Proc.RefreshParams;

    Proc.Params.ByNameAsInteger['IN_INTEGER']:=100;
    Proc.Params.ByNameAsString['IN_VARCHAR']:='100';
    Proc.Params.ByNameAsDouble['IN_FLOAT']:=100.999;

    Proc.Execute;

    Label1.Caption:=IntToStr(Proc.Params.ByNameAsInteger['OUT_INTEGER']);
    Label2.Caption:=Proc.Params.ByNameAsString['OUT_VARCHAR'];
    Label3.Caption:=FloatToStr(Proc.Params.ByNameAsDouble['OUT_FLOAT']);

  finally
    Proc.Free;
    Tran.Free;
    FDatabase.Connected:=false;
  end;}
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  Tran: TUIBTransaction;
  Query: TUIBQuery;
  Stream: TMemoryStream;
begin
  FDatabase.Connected:=true;
  Tran:=TUIBTransaction.Create(nil);
  Query:=TUIBQuery.Create(nil);
  Stream:=TMemoryStream.Create;
  try
    Tran.DataBase:=FDatabase;
    Query.Transaction:=Tran;
    Query.FetchBlobs:=true;
    Query.BuildStoredProc('GET_TEST',false);
//    Query.BuildStoredProc('GET_TEST2',true);
//    Query.BuildStoredProc('GET_TEST2',false);


    Query.Params.ByNameAsInteger['IN_INTEGER']:=100;
    Query.Params.ByNameAsString['IN_VARCHAR']:='100';
    Query.Params.ByNameAsSingle['IN_FLOAT']:=100.99;

    Stream.LoadFromFile('c:\!!!.wav');
    Stream.Position:=0;
    Query.ParamsSetBlob('IN_BLOB',Stream);

    Query.BeginExecute;
    Query.InternalNext;

//    Query.Open();

    Label1.Caption:=IntToStr(Query.Fields.ByNameAsInteger['OUT_INTEGER']);
    Label2.Caption:=Query.Fields.ByNameAsString['OUT_VARCHAR'];
    Label3.Caption:=FloatToStr(Query.Fields.ByNameAsSingle['OUT_FLOAT']);

    Stream.Clear;
    Query.Fields.ReadBlob('OUT_BLOB',Stream);
    Stream.Position:=0;
    Stream.SaveToFile('c:\###.wav');

  finally
    Stream.Free;
    Query.Free;
    Tran.Free;
    FDatabase.Connected:=false;
  end;
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  Stream: TMemoryStream;
//  S: String;
begin
  Stream:=TMemoryStream.Create;
  try

    IBStoredProc1.ParamByName('IN_INTEGER').Value:=100;
    IBStoredProc1.ParamByName('IN_VARCHAR').Value:='100';
    IBStoredProc1.ParamByName('IN_FLOAT').Value:=100.99;

    Stream.LoadFromFile('c:\!!!.wav');
    Stream.Position:=0;
    IBStoredProc1.ParamByName('IN_BLOB').LoadFromStream(Stream,ftBlob);

    IBStoredProc1.ExecProc;

    Label1.Caption:=IntToStr(IBStoredProc1.ParamByName('OUT_INTEGER').AsInteger);
    Label2.Caption:=IBStoredProc1.ParamByName('OUT_VARCHAR').AsString;
    Label3.Caption:=FloatToStr(IBStoredProc1.ParamByName('OUT_FLOAT').AsFloat);

    Stream.Clear;
    IBStoredProc1.QSelect.FieldByName('OUT_BLOB').SaveToStream(Stream);

//    S:=IBStoredProc1.ParamByName('OUT_BLOB').AsString;
//    Stream.Write(Pointer(S)^,Length(S));
    Stream.Position:=0;
    Stream.SaveToFile('c:\###.wav');

  finally
    Stream.Free;
  end;
end;

procedure TMainForm.ShowTime;
begin
  ShowMessage(IntToStr(FLastWorkPeriod)+' : '+FLastError);
end;

procedure TMainForm.ShowWaitForm;
begin
  if Assigned(WaitForm) then
    WaitForm.Show;
end;

procedure TMainForm.HideWaitForm;
begin
  if Assigned(WaitForm) then begin
     WaitForm.Hide;
  end;
end;

procedure TMainForm.ExecuteThreadWork(Thread: TBisWorkThread);
var
  Dbase: TUIBDataBase;
  Tran: TUIBTransaction;
  Query: TUIBQuery;
begin
  Dbase:=TUIBDataBase.Create(nil);
  Tran:=TUIBTransaction.Create(nil);
  Query:=TUIBQuery.Create(nil);
  try
    TBisExecuteThread(Thread).FDbase:=Dbase;
    TBisExecuteThread(Thread).FQuery:=Query;

    Dbase.CharacterSet:=csWIN1251;
    Dbase.DatabaseName:='s1:e:\taxi\taxi.fdb';
    Dbase.UserName:='SYSDBA';
    Dbase.PassWord:='masterkey';

    Dbase.Connected:=true;

//    Dbase.CancelEnable;

    Tran.DataBase:=Dbase;
    Query.Transaction:=Tran;
   
    Query.BuildStoredProc('TASK_TEST',false);

    Query.Params.ByNameAsVariant['TASK_ID']:=Null;
    Query.Params.ByNameAsVariant['ACCOUNT_ID']:=Null;

    Query.BeginTransaction;

    TBisExecuteThread(Thread).FTranId:=Tran.GetTransactionID;

    Query.Execute;

    Tran.Commit;

//    Dbase.CancelDisable;
  finally
    Query.Free;
    Tran.Free;
    Dbase.Free;
  end;
end;

procedure TMainForm.WaitTimeout(Thread: TBisWaitThread);
begin
  if not ApplicationFinished then
    Thread.Queue(ShowWaitForm);
end;

procedure TMainForm.ExecuteThreadWorkBegin(Thread: TBisWorkThread);
var
  Wait: TBisWaitThread;
begin
  FLastWorkPeriod:=0;
  FLastError:='';

  if not ApplicationFinished then begin
    with TBisExecuteThread(Thread) do begin
      Wait:=TBisWaitThread.Create(1500);
      FWait:=Wait;
      Wait.OnTimeout:=WaitTimeout;
      Wait.FreeOnTerminate:=false;
      Wait.Start;
    end;
  end;
end;

procedure TMainForm.ExecuteThreadWorkEnd(Thread: TBisWorkThread; const AException: Exception=nil);
begin

  with TBisExecuteThread(Thread) do begin
    if Assigned(FWait) then begin
      FWait.CleanUp;
      FWait.Free;
      FWait:=nil;
    end;
  end;

  if not ApplicationFinished then begin
    Thread.Synchronize(HideWaitForm);

    FLastWorkPeriod:=Thread.WorkPeriod;
    if Assigned(AException) then
      FLastError:=AException.Message;

    Thread.Synchronize(ShowTime);
  end;
end;

procedure TMainForm.ExecuteThreadTimeout(Thread: TBisWorkThread; var Forced: Boolean);
var
  Dbase: TUIBDataBase;
  Tran: TUIBTransaction;
  Stat: TUIBStatement;
  StHandle: IscStmtHandle;
  TranId: Integer;
begin
  with TBisExecuteThread(Thread) do begin
    if Assigned(FQuery) and Assigned(FDbase) then begin
//      FDbase.CancelAbort;
{      StHandle:=TBisExecuteThread(Thread).FQuery.StHandle;
      StHandle:=IscStmtHandle(Integer(StHandle)+1);

      FDbase.Lib.DSQLFreeStatement(StHandle,DSQL_unprepare);}

      TranId:=TBisExecuteThread(Thread).FTranId;

      Dbase:=TUIBDataBase.Create(nil);
      Tran:=TUIBTransaction.Create(nil);
      Stat:=TUIBStatement.Create(nil);
      try
        Dbase.CharacterSet:=csWIN1251;
        Dbase.DatabaseName:='s1:e:\taxi\taxi.fdb';
        Dbase.UserName:='SYSDBA';
        Dbase.PassWord:='masterkey';
        Dbase.Connected:=true;

        Tran.DataBase:=Dbase;

        Stat.DataBase:=Dbase;
        Stat.Transaction:=Tran;
        Stat.SQL.Text:='DELETE FROM MON$STATEMENTS WHERE MON$TRANSACTION_ID='+IntToStr(TranId);
        Stat.ExecSQL;  

    //    Dbase.ExecuteImmediate('DELETE FROM MON$STATEMENTS WHERE MON$TRANSACTION_ID='+IntToStr(TranId));
        //Forced:=true;

      finally
        Stat.Free;
        Tran.Free;
        Dbase.Free;
      end;


    end;
  end;
end;

procedure TMainForm.ExecuteThreadDestroy(Thread: TBisThread);
begin
  if not ApplicationFinished then begin
    if Thread=FExecuteThread then begin
      FExecuteThread:=nil
    end;
  end;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  if not Assigned(FExecuteThread) then begin
    FExecuteThread:=TBisExecuteThread.Create;
    FExecuteThread.OnWorkBegin:=ExecuteThreadWorkBegin;
    FExecuteThread.OnWork:=ExecuteThreadWork;
    FExecuteThread.OnWorkEnd:=ExecuteThreadWorkEnd;
    FExecuteThread.OnTimeout:=ExecuteThreadTimeout;
    FExecuteThread.OnDestroy:=ExecuteThreadDestroy;

    FExecuteThread.Timeout:=100;
    FExecuteThread.FreeOnTerminate:=CheckBox1.Checked;
    FExecuteThread.Start;

    WaitForm.Thread:=FExecuteThread;
  end;
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
  if Assigned(FExecuteThread) then begin
    HideWaitForm;

    if FExecuteThread.FreeOnTerminate then
      FExecuteThread.Terminate
    else begin
      FExecuteThread.Terminate;
      FExecuteThread.Free;
      FExecuteThread:=nil;
    end;  
  end;
end;


end.
