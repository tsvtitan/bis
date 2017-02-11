unit BisChildFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisFm;

type
  TBisChildForm = class(TBisForm)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisChildIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisChildForm: TBisChildForm;

implementation

{$R *.dfm}

{ TBisChildIface }

constructor TBisChildIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisChildForm;
end;

{ TBisChildForm }

constructor TBisChildForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ShowType:=stMdiChild;
end;

end.
