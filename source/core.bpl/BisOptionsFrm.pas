unit BisOptionsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  BisFrm;

type
  TBisOptionsFrame = class(TBisFrame)
  private
    { Private declarations }
  public
    function CanSave: Boolean; virtual;
    procedure Save; virtual;
  end;

  TBisOptionsFrameClass=class of TBisOptionsFrame;

var
  BisOptionsFrame: TBisOptionsFrame;

implementation

{$R *.dfm}

{ TBisOptionsFrame }

function TBisOptionsFrame.CanSave: Boolean;
begin
  Result:=false;
end;

procedure TBisOptionsFrame.Save;
begin
  if CanSave then ;
end;

end.
