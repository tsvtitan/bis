unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WideStrings, DB, StdCtrls, ExtCtrls,
  SqlExpr,
  IBDatabase, IBStoredProc, IBQuery;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Timer1: TTimer;
    Button2: TButton;
    ButtonRunStop: TButton;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Button3: TButton;
    Button4: TButton;
    RadioButtonSelect: TRadioButton;
    RadioButtonInsert: TRadioButton;
    RadioButtonUpdate: TRadioButton;
    RadioButtonDelete: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ButtonRunStopClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    FRunning: Boolean;
    procedure OutputLeaks;
    function GetLeakCaption(LeakName: String): String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses BisLeak;

{$R *.dfm}

{ TForm1 }

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

procedure TForm1.Button1Click(Sender: TObject);
var
  Proc: TSQLStoredProc;
  C: TSQLConnection;
begin
  StartLeak('SQL Stored Proc');
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
    C.Params.Add('Database=s1:E:\work\bis\source\cmx.bpl\CodeGear\leak\LEAKS.FDB');
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
    StopLeak('SQL Stored Proc');
    Button1.Caption:=GetLeakCaption('SQL Stored Proc');
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Proc: TIBStoredProc;
  DB: TIBDataBase;
  Tran: TIBTransaction;
begin
  StartLeak('IB Stored Proc');
  DB:=TIBDataBase.Create(nil);
  try
    DB.DatabaseName:='s1:E:\work\bis\source\cmx.bpl\CodeGear\leak\LEAKS.FDB';
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
    StopLeak('IB Stored Proc');
    Button2.Caption:=GetLeakCaption('IB Stored Proc');
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Query: TSQLQuery;
  C: TSQLConnection;
begin
  StartLeak('SQL Query');
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
    C.Params.Add('Database=s1:E:\work\bis\source\cmx.bpl\CodeGear\leak\LEAKS.FDB');
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
    StopLeak('SQL Query');
    Button3.Caption:=GetLeakCaption('SQL Query');
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  Query: TIBQuery;
  DB: TIBDataBase;
  Tran: TIBTransaction;
begin
  StartLeak('IB Query');
  DB:=TIBDataBase.Create(nil);
  try
    DB.DatabaseName:='s1:E:\work\bis\source\cmx.bpl\CodeGear\leak\LEAKS.FDB';
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
    StopLeak('IB Query');
    Button4.Caption:=GetLeakCaption('IB Query');
  end;
end;

procedure TForm1.ButtonRunStopClick(Sender: TObject);
begin
  if not FRunning then begin
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
    Button1.Click;
    Button3.Click;
    Button2.Click;
    Button4.Click;
  finally
    Timer1.Enabled:=true;
  end;
end;

end.
