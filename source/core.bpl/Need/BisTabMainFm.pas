unit BisTabMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ExtCtrls, AppEvnts, ComCtrls,
  BisMainFm;

type
  TBisTabMainForm = class(TBisMainForm)
    StatusBar: TStatusBar;
    ApplicationEvents: TApplicationEvents;
    PageControl: TPageControl;
    procedure ApplicationEventsHint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTabMainFormIface=class(TBisMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTabMainForm: TBisTabMainForm;

implementation

{$R *.dfm}

{ TBisTabMainFormIface }

constructor TBisTabMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTabMainForm;
end;

{ TBisTabMainForm }

procedure TBisTabMainForm.ApplicationEventsHint(Sender: TObject);
begin
  StatusBar.Panels[1].Text:=Application.Hint;
end;


end.
