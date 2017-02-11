unit dws2Pageloader;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dws2Comp;

type
  TDataModule2 = class(TDataModule)
    dws2Unit1: Tdws2Unit;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  DataModule2: TDataModule2;

implementation

{$R *.DFM}

end.
