unit BisExceptionFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisFm, ExtCtrls, Buttons, StdCtrls, OleCtrls, SHDocVw;

type
  TBisExceptionForm = class(TBisForm)
    iIcon: TImage;
    bTimer: TSpeedButton;
    Timer: TTimer;
    ButtonOk: TButton;
    ButtonDetail: TButton;
    MemoMessage: TMemo;
    PanelDetail: TPanel;
    WebBrowserDetail: TWebBrowser;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BisExceptionForm: TBisExceptionForm;

implementation

{$R *.dfm}

procedure TBisExceptionForm.FormCreate(Sender: TObject);
begin
  inherited;
  Height:=100;
end;

end.