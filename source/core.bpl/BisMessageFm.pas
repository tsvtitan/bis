unit BisMessageFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, OleCtrls, SHDocVw, BisFm;

type
  TBisMessageForm = class(TForm)
    iIcon: TImage;
    bTimer: TSpeedButton;
    Timer: TTimer;
    ButtonOk: TButton;
    ButtonDetail: TButton;
    MemoMessage: TMemo;
    PanelDetail: TPanel;
    WebBrowserDetail: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure ButtonDetailClick(Sender: TObject);
  private
    FDetailed: Boolean;

  public
    { Public declarations }
  end;

var
  BisMessageForm: TBisMessageForm;

procedure BisMessageBox(Msg, Title: string; DlgType: TMsgDlgType; Detailed: Boolean; Seconds: Integer; UseTimer: Boolean=true);

implementation

{$R *.dfm}

procedure BisMessageBox(Msg, Title: string; DlgType: TMsgDlgType; Detailed: Boolean; Seconds: Integer; UseTimer: Boolean=true);
var
  Form: TBisMessageForm;
begin
  Form:=TBisMessageForm.Create(nil);
  try

  finally
    Form.Free;
  end;
end;

{ TBisMessageForm }

procedure TBisMessageForm.FormCreate(Sender: TObject);
begin
  inherited;
  FDetailed:=true;
  ButtonDetailClick(nil);
end;

procedure TBisMessageForm.ButtonDetailClick(Sender: TObject);
begin
  if FDetailed then
    Height:=95
  else Height:=300;
  FDetailed:=not FDetailed;
end;

end.