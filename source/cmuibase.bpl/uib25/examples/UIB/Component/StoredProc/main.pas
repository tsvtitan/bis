unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uib, StdCtrls;

type
  TMainForm = class(TForm)
    Go: TButton;
    DataBase: TUIBDataBase;
    Transaction: TUIBTransaction;
    Memo: TMemo;
    StoredProc: TUIBQuery;
    procedure GoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses uibLib;

{$R *.dfm}

procedure TMainForm.GoClick(Sender: TObject);
var i: Integer;
begin
  Memo.Clear;
  StoredProc.BuildStoredProc('GET_ORDER_NUM',false);
  Memo.Lines.Add(StoredProc.SQL.Text);
//  Memo.Lines.Add(StoredProc.Params.FieldName[0] + ': NULL');
  Memo.Lines.Add('---');
//  StoredProc.Params.ByNameIsNull['ORDER_NUM'] := true;

  StoredProc.Open;
  with StoredProc.Fields do
  for i := 0 to FieldCount - 1 do
    memo.Lines.Add(AliasName[i] + ': ' + AsString[i]);
  StoredProc.Close(etmCommit);
end;

end.
