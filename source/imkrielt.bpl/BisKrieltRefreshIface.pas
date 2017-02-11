unit BisKrieltRefreshIface;

interface                                                               

uses
     BisIfaces;

type

  TBisKrieltRefreshIface=class(TBisIface)
  public
    procedure Show; override;
  end;

implementation

uses BisDialogs, BisProvider;

{ TBisKrieltRefreshIface }

procedure TBisKrieltRefreshIface.Show;
var
  P: TBisProvider;
begin
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='R_PRESENTATIONS';
    P.Execute;
  finally
    P.Free;
  end;
end;

end.
