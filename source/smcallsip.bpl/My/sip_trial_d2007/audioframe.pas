unit audioframe;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TAudioFrm = class(TFrame)
    Label2: TLabel;
    Image1: TImage;
    Image2: TImage;
    Label8: TLabel;
    Image3: TImage;
    waveRingDevice: TComboBox;
    waveOutDevice: TComboBox;
    waveInDevice: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
