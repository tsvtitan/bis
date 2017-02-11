unit UnitApp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  UnitThread;

type

  TForm3 = class(TForm,IConnectionThreadForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FCounter: Integer;
    FBreaked: Boolean;

    procedure IncCounter;
    function IsBreaked: Boolean;
    
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses UnitConn;

{ TThread3 }

{ TForm3 }

procedure TForm3.Button1Click(Sender: TObject);
begin
  InitConn;
  InitThread(Self);
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  FBreaked:=true;
  DoneThread;
  DoneConn;
end;

constructor TForm3.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //
end;

destructor TForm3.Destroy;
begin
  FBreaked:=true;
  inherited Destroy;
end;

procedure TForm3.IncCounter;
begin
  Inc(FCounter);
  Label1.Caption:=IntToStr(FCounter);
  Label1.Update;
end;

function TForm3.IsBreaked: Boolean;
begin
  Result:=FBreaked;
end;

end.
