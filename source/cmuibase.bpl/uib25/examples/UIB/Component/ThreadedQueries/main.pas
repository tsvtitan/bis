unit main;

interface

uses
{$IFDEF LINUX}
  libc, QForms, QStdCtrls, QControls, QGraphics, QDialogs, QExtCtrls,
{$ELSE}
  Windows, Graphics, Controls, Forms, Messages, Dialogs, StdCtrls,
{$ENDIF}
  SysUtils, Classes, uib, uiblib, SyncObjs, Contnrs;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    FDataBase: TUIBDataBase;
    FList: TObjectList;
    procedure ThreadTerminate(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TMyThread = class(TThread)
  private
    FForm: TForm1;
    FError: String;
    procedure Error;
  protected
    procedure Execute; override;
  public
    constructor Create(AForm: TForm1);
    destructor Destroy; override;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

constructor TForm1.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDataBase:=TUIBDataBase.Create(nil);
  FDataBase.DatabaseName:= 's1:e:\taxi\taxi.fdb';
  FDataBase.CharacterSet:= csWIN1251;
  FDataBase.UserName:= 'SYSDBA';
  FDataBase.PassWord:= 'masterkey';
  FDataBase.LibraryName:= 'gds32.dll';
  FDataBase.Connected:= True;

  FList:=TObjectList.Create(false);

{    Params.Strings = (
      'sql_dialect=3'
      'lc_ctype=WIN1251'
      'user_name=SYSDBA'
      'password=masterkey'
      '')}
end;

destructor TForm1.Destroy;
begin
  FList.Free;
  FDataBase.Free;
  inherited Destroy;
end;

procedure TForm1.ThreadTerminate(Sender: TObject);
begin
  FList.Remove(Sender);
  Caption:='Threads: '+IntToStr(FList.Count);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
  Thread: TMyThread;
begin
  for i := 0 to 0 do begin
    Thread:=TMyThread.Create(Self);
    Thread.OnTerminate:=ThreadTerminate;
    FList.Add(Thread);
    Thread.Resume;
  end;
  Caption:='Threads: '+IntToStr(FList.Count);
end;

var
  x: integer = 0;

{ TMyThread }

constructor TMyThread.Create(AForm: TForm1);
begin
  inherited Create(true);
  FForm:=AForm;
end;

destructor TMyThread.destroy;
begin
  inherited destroy;
end;

procedure TMyThread.Error;
begin
  if Assigned(FForm) then
    FForm.Memo1.Lines.Add(FError);
end;

procedure TMyThread.Execute;
var
  Query: TUIBQuery;
  Transaction: TUIBTransaction;
  NCount: Integer;
begin
  FreeOnTerminate := true;
  // Form1.DataBase.Lock; //simulate single thread
  try
    Query := TUIBQuery.Create(nil);
    Transaction := TUIBTransaction.Create(nil);
    try
      NCount:=0;
      try
        Transaction.DataBase := FForm.FDataBase;
        Query.Transaction := Transaction;
        Query.FetchBlobs := True;
        Query.SQL.Text := 'select * from accounts';
        Query.Open;
        while not Query.EOF do
        begin
          Query.Next;
          Inc(NCount);
          Sleep(1); // simulate activity
        end;
      except
        on E: Exception do begin
          FError:=IntToStr(NCount)+': '+E.Message;
          Synchronize(Error);
        end;
      end;
    finally
      Query.Close(etmCommit);
      Query.Free;
      Transaction.Free;
    end;
  finally
    // Form1.DataBase.UnLock; //simulate single thread
  end;
end;

end.
