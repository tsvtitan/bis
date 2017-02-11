unit DbErrors;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GWXLib_TLB, StdCtrls, ExtCtrls;

type
  TDbErrForm = class(TForm)
    List: TListBox;
    Panel1: TPanel;
    Button1: TButton;
  private
    { Private declarations }
  public
    procedure ShowNotLoadedRecords(tbl: IGWTable; db: string);
  end;

var
  DbErrForm: TDbErrForm;

implementation

{$R *.dfm}

procedure TDbErrForm.ShowNotLoadedRecords(tbl: IGWTable; db: string);
var
  dbname: string;
  p: integer;
begin         //tbl: name(string) recordN(int)
  dbname:=ExtractFileName(db);
  p:=tbl.MoveFirst;

  List.Items.Clear;
  while p>=0 do begin
    if CompareText(tbl.getText(0), dbname)=0 then List.Items.Add(tbl.getText(1));
    p:=tbl.MoveNext;
  end;
  if List.Items.Count=0 then exit;
  ShowModal;
end;

end.
