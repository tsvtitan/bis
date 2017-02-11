unit BisIngitMapFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls,

  BisFm, BisMapFm, BisMapFrm;

type
  TBisIngitMapForm = class(TBisMapForm)
  private
    { Private declarations }
  protected
    function GetMapFrameClass: TBisMapFrameClass; override;
  public
    { Public declarations }
  end;

  TBisIngitMapFormIface=class(TBisMapFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisIngitMapForm: TBisIngitMapForm;

implementation

{$R *.dfm}

{ TBisIngitMapFormIface }

constructor TBisIngitMapFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisIngitMapForm;
end;

{ TBisIngitMapForm }

function TBisIngitMapForm.GetMapFrameClass: TBisMapFrameClass;
begin
  Result:=nil;
end;

end.
