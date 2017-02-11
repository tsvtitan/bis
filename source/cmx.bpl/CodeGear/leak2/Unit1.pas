unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WideStrings, DB, StdCtrls, ExtCtrls,
  SqlExpr,
  IBDatabase, IBStoredProc, IBQuery, TeEngine, Series, TeeProcs, Chart;

type
  TForm1 = class(TForm)
    ButtonSqlStoredProc: TButton;
    Timer1: TTimer;
    ButtonIbStoredProc: TButton;
    ButtonRunStop: TButton;
    GroupBoxLeaksLog: TGroupBox;
    Memo1: TMemo;
    ButtonSqlQuery: TButton;
    ButtonIbQuery: TButton;
    RadioButtonSelect: TRadioButton;
    RadioButtonInsert: TRadioButton;
    RadioButtonUpdate: TRadioButton;
    RadioButtonDelete: TRadioButton;
    LabelDatabase: TLabel;
    EditDatabase: TEdit;
    ButtonDatabase: TButton;
    OpenDialog1: TOpenDialog;
    Chart1: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    ShapeSqlStoredProc: TShape;
    ShapeSqlQuery: TShape;
    ShapeIbStoredProc: TShape;
    ShapeIbQuery: TShape;
    procedure ButtonSqlStoredProcClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonIbStoredProcClick(Sender: TObject);
    procedure ButtonRunStopClick(Sender: TObject);
    procedure ButtonSqlQueryClick(Sender: TObject);
    procedure ButtonIbQueryClick(Sender: TObject);
    procedure ButtonDatabaseClick(Sender: TObject);
  private
    FRunning: Boolean;
    procedure OutputLeaks;
    function GetLeakCaption(LeakName: String): String;
    function GetDatabaseName: String;
    procedure AddSeriesValues(LeakName: String);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  Form1: TForm1;

implementation

uses StrUtils, WinSock,
     BisLeak;

{$R *.dfm}

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

{ TForm1 }

constructor TForm1.Create(AOwner: TComponent);
var
  Path: String;
begin
  inherited Create(AOwner);
  Path:=ExtractFilePath(Application.ExeName);
  EditDatabase.Text:=Path+'INTERBASE.IB';

  Series1.Title:=ButtonSqlStoredProc.Caption;
  Series1.Color:=ShapeSqlStoredProc.Brush.Color;

  Series2.Title:=ButtonSqlQuery.Caption;
  Series2.Color:=ShapeSqlQuery.Brush.Color;

  Series3.Title:=ButtonIbStoredProc.Caption;
  Series3.Color:=ShapeIbStoredProc.Brush.Color;

  Series4.Title:=ButtonIbQuery.Caption;
  Series4.Color:=ShapeIbQuery.Brush.Color;
end;

function TForm1.GetDatabaseName: String;
var
  Str: TStringList;
begin
  Str:=TStringList.Create;
  try
    Result:=Trim(EditDatabase.Text);
    GetStringsByString(Result,':',Str);
    if Str.Count<=2 then
      Result:=GetHostNameEx+':'+Result;
  finally
    Str.Free;
  end;
end;

procedure TForm1.AddSeriesValues(LeakName: String);

  function GetSeriesByTitle: TLineSeries;
  var
    i: Integer;
    S: TChartSeries;
  begin
    Result:=nil;
    for i:=0 to Chart1.SeriesList.Count-1 do begin
      S:=Chart1.SeriesList.Items[i];
      if Assigned(S) and (S is TLineSeries) then
        if AnsiSameText(S.Title,LeakName) then begin
          Result:=TLineSeries(S);
        break;
        end;
    end;
  end;

var
  Series: TLineSeries;
  Leak: TBisLeak;
begin
  Series:=GetSeriesByTitle;
  if Assigned(Series) then begin
    Leak:=Leaks.Find(LeakName);
    if Assigned(Leak) then
      Series.AddXY(Leak.Count,Leak.AllBytes);
  end;
end;

procedure TForm1.OutputLeaks;
var
  i: Integer;
  Item: TBisLeak;
begin
  for i:=0 to Leaks.Count-1 do begin
    Item:=Leaks.Items[i];
    Memo1.Lines.Add(Format('%s Count=%d Time=%s Bytes=%d',[Item.Name,Item.Count,FormatDateTime('hh:nn:ss.zzz',Item.AllTime),Item.AllBytes]));
  end;
end;

function TForm1.GetLeakCaption(LeakName: String): String;
var
  Item: TBisLeak;
begin
  Result:=LeakName;
  Item:=Leaks.Find(LeakName);
  if Assigned(Item) then
    Result:=Format('%s Count=%d Time=%s Bytes=%d',[Item.Name,Item.Count,FormatDateTime('hh:nn:ss.zzz',Item.AllTime),Item.AllBytes])
end;

procedure TForm1.ButtonSqlStoredProcClick(Sender: TObject);
var
  Proc: TSQLStoredProc;
  C: TSQLConnection;
begin
  StartLeak(Series1.Title);
  C := TSQLConnection.Create(Self);
  try
    C.LoadParamsOnConnect:=false;
    C.ConnectionName:='Interbase';
    C.DriverName := 'InterbaseConnection';
    C.LibraryName := 'dbxint30.dll';
    C.VendorLib := 'GDS32.dll';
    C.GetDriverFunc := 'getSQLDriverINTERBASE';
    C.Params.Add('User_Name=SYSDBA');
    C.Params.Add('Password=masterkey');
    C.Params.Add(Format('Database=%s',[GetDatabaseName]));
    C.Open;
    if C.Connected then begin
      StartLeak('SQL Stored Proc Execute');
      Proc:=TSQLStoredProc.Create(nil);
      try
        Proc.SQLConnection:=C;
        Proc.StoredProcName:='PROC_EMPTY';
        Proc.ExecProc;
      finally
        Proc.Free;
        StopLeak('SQL Stored Proc Execute');
      end;
    end;
  finally
    C.Close;
    C.Free;
    StopLeak(Series1.Title);
    AddSeriesValues(Series1.Title);
    ButtonSqlStoredProc.Caption:=GetLeakCaption(Series1.Title);
  end;
end;

procedure TForm1.ButtonIbStoredProcClick(Sender: TObject);
var
  Proc: TIBStoredProc;
  DB: TIBDataBase;
  Tran: TIBTransaction;
begin
  StartLeak(Series3.Title);
  DB:=TIBDataBase.Create(nil);
  try
    DB.DatabaseName:=GetDatabaseName;
    DB.LoginPrompt:=false;
    DB.Params.Add('User_Name=SYSDBA');
    DB.Params.Add('Password=masterkey');
    DB.Open;
    if DB.Connected then begin
      StartLeak('IB Stored Proc Execute');
      Proc:=TIBStoredProc.Create(nil);
      Tran:=TIBTransaction.Create(nil);
      try
        Tran.Params.Text:='read_committed'+#13#10+'rec_version'+#13#10+'nowait';
        DB.AddTransaction(Tran);
        Tran.AddDatabase(DB);
        Proc.Database:=DB;
        Proc.Transaction:=Tran;
        Tran.Active:=true;
        Proc.StoredProcName:='PROC_EMPTY';
        Proc.ExecProc;
        Tran.Commit;
      finally
        Proc.Free;
        Tran.Free;
        StopLeak('IB Stored Proc Execute');
      end;
    end;
  finally
    DB.Close;
    DB.Free;
    StopLeak(Series3.Title);
    AddSeriesValues(Series3.Title);
    ButtonIbStoredProc.Caption:=GetLeakCaption(Series3.Title);
  end;
end;

procedure TForm1.ButtonSqlQueryClick(Sender: TObject);
var
  Query: TSQLQuery;
  C: TSQLConnection;
begin
  StartLeak(Series2.Title);
  C := TSQLConnection.Create(Self);
  try
    C.LoadParamsOnConnect:=false;
    C.ConnectionName:='Interbase';
    C.DriverName := 'InterbaseConnection';
    C.LibraryName := 'dbxint30.dll';
    C.VendorLib := 'GDS32.dll';
    C.GetDriverFunc := 'getSQLDriverINTERBASE';
    C.Params.Add('User_Name=SYSDBA');
    C.Params.Add('Password=masterkey');
    C.Params.Add(Format('Database=%s',[GetDatabaseName]));
    C.Open;
    if C.Connected then begin
      StartLeak('SQL Query Open');
      Query:=TSQLQuery.Create(nil);
      try
        Query.SQLConnection:=C;
        if RadioButtonSelect.Checked then begin
//        Query.SQL.Text:='SELECT * FROM TABLE_EMPTY';
          Query.SQL.Text:='SELECT * FROM TABLE_ONE_RECORD';
          Query.Open;
        end;
        if RadioButtonInsert.Checked then begin
          Query.SQL.Text:='INSERT INTO TABLE_INSERT (ID) VALUES (1)';
          Query.ExecSQL;
        end;
        if RadioButtonUpdate.Checked then begin
          Query.SQL.Text:='UPDATE TABLE_UPDATE SET NAME=''Test'' WHERE ID=1';
          Query.ExecSQL;
        end;
        if RadioButtonDelete.Checked then begin
          Query.SQL.Text:='DELETE FROM TABLE_DELETE WHERE ID=1';
          Query.ExecSQL;
        end;
      finally
        Query.Free;
        StopLeak('SQL Query Open');
      end;
    end;
  finally
    C.Close;
    C.Free;
    StopLeak(Series2.Title);
    AddSeriesValues(Series2.Title);
    ButtonSqlQuery.Caption:=GetLeakCaption(Series2.Title);
  end;
end;

procedure TForm1.ButtonIbQueryClick(Sender: TObject);
var
  Query: TIBQuery;
  DB: TIBDataBase;
  Tran: TIBTransaction;
begin
  StartLeak(Series4.Title);
  DB:=TIBDataBase.Create(nil);
  try
    DB.DatabaseName:=GetDatabaseName;
    DB.LoginPrompt:=false;
    DB.Params.Add('User_Name=SYSDBA');
    DB.Params.Add('Password=masterkey');
    DB.Open;
    if DB.Connected then begin
      StartLeak('IB Query Open');
      Query:=TIBQuery.Create(nil);
      Tran:=TIBTransaction.Create(nil);
      try
        Tran.Params.Text:='read_committed'+#13#10+'rec_version'+#13#10+'nowait';
        DB.AddTransaction(Tran);
        Tran.AddDatabase(DB);
        Query.Database:=DB;
        Query.Transaction:=Tran;
        Tran.Active:=true;
        if RadioButtonSelect.Checked then begin
//        Query.SQL.Text:='SELECT * FROM TABLE_EMPTY';
          Query.SQL.Text:='SELECT * FROM TABLE_ONE_RECORD';
          Query.Open;
        end;
        if RadioButtonInsert.Checked then begin
          Query.SQL.Text:='INSERT INTO TABLE_INSERT (ID) VALUES (1)';
          Query.ExecSQL;
        end;
        if RadioButtonUpdate.Checked then begin
          Query.SQL.Text:='UPDATE TABLE_UPDATE SET NAME=''Test'' WHERE ID=1';
          Query.ExecSQL;
        end;
        if RadioButtonDelete.Checked then begin
          Query.SQL.Text:='DELETE FROM TABLE_DELETE WHERE ID=1';
          Query.ExecSQL;
        end;
      finally
        Query.Free;
        Tran.Free;
        StopLeak('IB Query Open');
      end;
    end;
  finally
    DB.Close;
    DB.Free;
    StopLeak(Series4.Title);
    AddSeriesValues(Series4.Title);
    ButtonIbQuery.Caption:=GetLeakCaption(Series4.Title);
  end;
end;

procedure TForm1.ButtonDatabaseClick(Sender: TObject);
begin
  OpenDialog1.FileName:=EditDatabase.Text;
  if OpenDialog1.Execute then
    EditDatabase.Text:=OpenDialog1.FileName;
end;

procedure TForm1.ButtonRunStopClick(Sender: TObject);
begin
  if not FRunning then begin
    Series1.Clear;
    Series2.Clear;
    Series3.Clear;
    Series4.Clear;
    Memo1.Clear;
    InitLeaks;
  end;
  try
    FRunning:=not FRunning;
    Timer1.Enabled:=FRunning;
  finally
    if not FRunning then begin
      DoneLeaks;
      OutputLeaks;
    end;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=false;
  try
    ButtonSqlStoredProc.Click;
    ButtonIbStoredProc.Click;
    ButtonSqlQuery.Click;
    ButtonIbQuery.Click;
  finally
    Timer1.Enabled:=true;
  end;
end;

end.
