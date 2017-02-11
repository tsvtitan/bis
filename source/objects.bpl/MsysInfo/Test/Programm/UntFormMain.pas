unit UntFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, Buttons;

type
  TfrmFormMain = class(TBaseForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private

  public
    
  end;

var
   frmFormMain: TfrmFormMain;

implementation

uses
   UntForm1, UntForm2;

{$R *.dfm}

procedure TfrmFormMain.BitBtn1Click(Sender: TObject);
var
   frm: TForm1;
begin
   Application.CreateForm(TForm1, frm);
   frm.ShowModal;
   frm.Free;
end;

procedure TfrmFormMain.BitBtn2Click(Sender: TObject);
var
   frm: TForm2;
begin
   Application.CreateForm(TForm2, frm);
   frm.ShowModal;
   frm.Free;
end;

end.
